Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC69FCA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 06:37:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 544D58E000C; Wed, 10 Sep 2025 02:37:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F5588E0001; Wed, 10 Sep 2025 02:37:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E4BD8E000C; Wed, 10 Sep 2025 02:37:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 283728E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:37:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA37BBB611
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 06:37:01 +0000 (UTC)
X-FDA: 83872383042.09.955156F
Received: from unicom146.biz-email.net (unicom146.biz-email.net [210.51.26.146])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2711D180009
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 06:36:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of cuishw@inspur.com designates 210.51.26.146 as permitted sender) smtp.mailfrom=cuishw@inspur.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757486219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9gQwC2UdcguEjNDcCoYZ2NqoG0/PbVM6foYwqK233Wc=;
	b=HZFdgYQUauSMYvRVuFmnYcRadQjARHWXOW0CnhtDVPF3JDx9u225vBnejZIzpMDl9VAhoM
	U2/n00sc2f9v+uroXceVNAYWuvSftxaFO+ZfMseHQAJ9PF/yngGU8W58R6wUZFIuNIJE/b
	SZt550t53+TMjcNg2UJJA5JYUSDVoA8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of cuishw@inspur.com designates 210.51.26.146 as permitted sender) smtp.mailfrom=cuishw@inspur.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757486219; a=rsa-sha256;
	cv=none;
	b=Kh6Yy+BnD7YWNTTc03uD+v7pOf2rpEfoq4S+dVpp3ikNS1bouIGLveN4SQ6OXpn+QDCCNl
	qDDITWadfs9e+B/LUTNi5vhGkFHJitxLVILoDDLY95UxIdb97mltVdD8onKVfjSt0SK+uv
	5juget2fcec4+0G3xoXQWWSDDW8IwE8=
Received: from Jtjnmail201614.home.langchao.com
        by unicom146.biz-email.net ((D)) with ASMTP (SSL) id 202509101436476236;
        Wed, 10 Sep 2025 14:36:47 +0800
Received: from PC00024056.home.langchao.com (10.94.9.241) by
 Jtjnmail201614.home.langchao.com (10.100.2.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.57; Wed, 10 Sep 2025 14:36:48 +0800
From: cuishiwei <cuishw@inspur.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: cuishiwei <cuishw@inspur.com>, Michal Hocko <mhocko@suse.com>,
	<akpm@linux-foundation.org>, <axelrasmussen@google.com>,
	<yuanchu@google.com>, <weixugc@google.com>, <david@redhat.com>,
	<zhengqi.arch@bytedance.com>, <shakeel.butt@linux.dev>,
	<lorenzo.stoakes@oracle.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] disable demotion during memory reclamation
Date: Wed, 10 Sep 2025 14:36:40 +0800
Message-ID: <20250910063643.2323-1-cuishw@inspur.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250909144531.GA1474@cmpxchg.org>
References:
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.94.9.241]
X-ClientProxiedBy: Jtjnmail201615.home.langchao.com (10.100.2.15) To
 Jtjnmail201614.home.langchao.com (10.100.2.14)
tUid: 20259101436489048ee04c079dbb8e6ea2fbdc70eae8d
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Rspamd-Queue-Id: 2711D180009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: eacsuep3ba8k33a59ohesnpxt7zqsxs4
X-HE-Tag: 1757486216-231699
X-HE-Meta: U2FsdGVkX19dTqbJHK3g0MYXPH7SpbNkpjFbmG6FbM4NqWoeXVBAYRxMXzTtICsdOAtsOyWzwCFm9dvbjRLGjm2vL+kkcV42q24i2eW9ozL5KCvqID3sjXh8vdgkMQjmAtJSh5nGKCr1UFqAd+uqoskIsfUR1ojQMy8FKjOcnJlrmCTllixN5NuclGihIP9Zv6I3E4qEcWCMnU1PbQT2C/sNAEi4WZh69zitBZUfvb47TIo66Swe8AmdpVk+FGTwV4JnzrArJk4PJxCyO6py/9t6Wzp83y0ODLcnGILJNZFNCd6bSjuCs5xioE4dhQFtBe8JK8DE1oNOX52PJvyX0T8A8tuIDT4X94qeonjfHLuyaDTC5TjCB4Kqevf6BgExaaAUkd7mWpMrug0xdmB/A2ZL/qlf5gT4ED1fq/wxzFSQ8J3aU8zI6vpm98zmwXnEvpyLju/LcVX3dMkN6nYQxnRQGlgdrypn0jwKDUQvDSUd6lWQ8/R0cbdgDhSNui75vm9QUKOqKsw38VJyUDPFr77BY/hqEhcvYuGVJfkH6TfnE4M7I2Gxsk0L66joUnikWofSXxkltCFZkLEM4ebYOzysFf0PUhch9OA5wlR4F3tV2BXccQYZgcxIFoVnS8taut5H2BSrvGBw25MHLxufJAfd4iokJn4zrawzl5mTGMCQnAGNV3591Snkp2mMV5YhnxU188N4RXzRcr8c/FAnhMABiIbk2fSN5T8H0Lpw3hR81KucoUqLGBfwQGnIiqRamohu92ecB+x9Yf7kedvDyKqUERqH+zjFF7xAdF1yOhelXw34D2j6G9AF1hTPJwoZF0xqqUCCcVTXY1bNJiyyRsZGe+WYaCPz9Q08SecPvvaac5fjepUEYsrSZm3wiUlSebwZsQr1zlxg5Af5KrGhPDHiOlTRHTnvE9mF5psGjNTi7rf7HmGOrIkOFp0hmk3g+mrj19/0+X5arx5/0Fh
 nCeexPCI
 RkWMh5WCya6UpVHXBBmU+eHXVacGv+t1317kAnTmCCpdF0XAZRjBLxYlxRxThI8sGZFZCpdKm9tJA36Sw1pprZPEWN/ettss8RfbgEGLaSUvr+JJrFk4oIQLR0iDQqJ/8JypaTW3qmm3hOe65ADhQ+A6uJZ8bSvmXk9sQ+BMDetooKUPfcjl7UjfJHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 9 Sep 2025 15:45:31 +0100 Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Tue, Sep 09, 2025 at 09:40:51AM +0200, Michal Hocko wrote:
> > On Tue 09-09-25 09:21:41, cuishiwei wrote:
> > > When a memory cgroup exceeds its memory limit, the system reclaims
> > > its cold memory.However, if /sys/kernel/mm/numa/demotion_enabled is
> > > set to 1, memory on fast memory nodes will also be demoted to slow 
> > > memory nodes.
> > > 
> > > This demotion contradicts the goal of reclaiming cold memory within
> > > the memcg.At this point, demoting cold memory from fast to slow nodes
> > > is pointless;it doesn't reduce the memcg's memory usage. Therefore, 
> > > we should set no_demotion when reclaiming memory in a memcg.
> > 
> > We have discussed this in the past and it is my recollection that we
> > have concluded that demotion is a part of proper aging and therefore it
> > should be done during the limit reclaim.
> 
> Yes, thanks. This is intentional. Please see 3f1509c57b1b ("Revert
> "mm/vmscan: never demote for memcg reclaim"") for more details.
Thank you for the guidance. It seems the original processing logic was sound.

Sent using hkml (https://github.com/sjp38/hackermail)

