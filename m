Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5801AEB5946
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 01:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 737BC6B0005; Tue, 10 Feb 2026 20:30:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E5B36B0089; Tue, 10 Feb 2026 20:30:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F1A36B008A; Tue, 10 Feb 2026 20:30:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 50CA06B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 20:30:51 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 070A8B6A9F
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 01:30:51 +0000 (UTC)
X-FDA: 84430446702.04.ECD932A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id A3D0F1C0006
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 01:30:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Qj/oc/a5";
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770773448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rTdAv7ESz6Rg9Fz8C8SooM9hTZwCGw9JUJYuwBPOGMU=;
	b=l6xXxUCQr/wxAMeHanO5RmzQF9QVBw0+W2npGz7Pvpce4aYF3h9brgwBfQ6khXGjDPNIuA
	2A4aCEPdF2nowwLwGLdFSUDHA9ul+Gb+31aThluDA2FeHiyp3ddh5KV9Pg9XCi7abA241G
	xFqChHxPkwPAuOT/jDVQ3rXn/nvL9ys=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Qj/oc/a5";
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770773448; a=rsa-sha256;
	cv=none;
	b=tYOU6cjDizVmpLY8BKDdwq6nkPc0TBgTdxpwA5u/iEXb6xQbO8LURcqiyyUP12odczyVes
	ZtmeCtBdJGiQlWQw+Qay0w8Vy5yN9ENAJf8HrFC5fc/YTIkHLm86C9Da/ghc8NeqPNn5Eg
	Wl5cGfsQ/ah2bz1jAY/d2WzZXorBTys=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E30C360130;
	Wed, 11 Feb 2026 01:30:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A06C19423;
	Wed, 11 Feb 2026 01:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770773447;
	bh=Fi1WNYnUwJRuTNrA01/0llli4cFlbNWkNf0uzzIfG1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qj/oc/a5754lLv4yItnshbjodvBlITYun3IA8xek2ttqA/zlqBju/Fe664ap2i6xc
	 Y7MpTcU5VyBn5UnDqE1r4+GlCs7VRA2G7VnjEzYz7YWb9qJM4XQMMSPRIusF0KTwwb
	 oQR2G8nN3drVkvDc9gA0jH4YL5PtYG6AUKHikDnT2852PSkpCmsg+dxa0dZfB6Ze5L
	 JjxWRATC2apsvTFM8/Ef3u5QU3hn3DJA3cfFUJzCP1IgcqnwPBQ0FC/PR77CogTx8V
	 QA/xhmTAnZtVNjORc2XtYu8zsvuQAuWr9FTVljDVAtdIXaxu4RdGBL33qv1u9f3BEd
	 dVYq/uD7Lmp/A==
From: SeongJae Park <sj@kernel.org>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: SeongJae Park <sj@kernel.org>,
	"jack@suse.cz" <jack@suse.cz>,
	"clm@meta.com" <clm@meta.com>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"chrisl@kernel.org" <chrisl@kernel.org>,
	Pavan Rallabhandi <Pavan.Rallabhandi@ibm.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Subject: RE: [Lsf-pc] [LSF/MM/BPF TOPIC] Machine Learning (ML) library in Linux kernel
Date: Tue, 10 Feb 2026 17:30:38 -0800
Message-ID: <20260211013039.68143-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <c24a209d5a4af0c4cc08f30098998ce16c668b58.camel@ibm.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o41ppfqtoosonw38zfk169qm1szni138
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A3D0F1C0006
X-HE-Tag: 1770773448-13554
X-HE-Meta: U2FsdGVkX18YmaQAMb/zP/NxB0MhHZWC4G6JJjaJdj6hjHtTt0m4L+1HyqlgCQe4r61p/xJH5YE4t0G5LOwEaydk29gG2kneBGUXk5uFtbAvjt+Kug8+4n5jBdXLHeGcxFvK/nYlZoqXXz6Wl2HTegB0zSoXm0UkD65aazBVrB86ZBomNLeMF3URJLI9cckiabEj2t8GSO+2DkfLLoF8GmFEW4lJUpibu6lcag5F6d579LRsr88N0znG9h/mZWOcJFHxv5AWQTgo1ATZxSpryLBcArKJlvo1YNxQ1ONMvU+msUXEegiWbztAbnQw1Q5XZnK1w39NqeqDpqgjwkDQXAcUWJUf3/60fo2ZJaOm+KJXupiuzu0Jxtnc0y0fEdexcSb8EjVOrxbVkMSJach1Y19IrlgsvErzCvtm058JtWnaIUholn6w9NKqMD8r/APyie676ng7WoA5ojKnmq2jM4piuVIwvySCj2rcDnZl7q6K/2y3RYdqhvsxaordFOPMabBewi8GBkeuzDnHAU1e8XkD5sgUAb/5Gih521dufIMBK5vbDbuHtVwBIjo15EPgwSHSlGgb9LlC6hJhViO/lz4iEgGosu7UOSTpiaARdzXQsVVyMU4j9qxqa/+DW/RTgOBWpuoJFCmHar51AJRxN9WnwftAZaqp3jz+Q4r2inPmshcUsxWYiutO+94odCMDEkPgCnxOrsRSacFa+p+ga6hLakCGXX2tr/JCubqvzkXNtvpMCEryDIpI3oscMuAYh9UMxPfssCf9R7t2PYs4voc9L0dtGFt00DMlznyewIe1N3hkDKiVwxId6zPKAqKBV7ghrkWHpZ8qvAdA6/t6qfJ9zL3WiN+IsWSoZZWpEDqy0792UFYlE0HzCqTAcFPBSB2CHOgGT2zsYwCahHlyYojYX54SKmo/LvVoOqmVbT3wHwh0C7jWV8yCfYDxgVoemVKvO8JXpin96CtWByI
 R1AiMMUJ
 ldpul
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 10 Feb 2026 22:36:35 +0000 Viacheslav Dubeyko <Slava.Dubeyko@ibm.com> wrote:

> Exactly, ML-based DAMON approach by using ML library is my next
> implementation/exploring step.

Glad to hear this.  If you find any question or need help for DAMON while doing
this, please feel free to reach out.  I will be more than happy to help :)


Thanks,
SJ

[...]

