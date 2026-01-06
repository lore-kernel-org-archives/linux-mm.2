Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E459CEFCE2
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 17:45:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 718766B008A; Tue,  6 Jan 2026 12:45:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C6516B0092; Tue,  6 Jan 2026 12:45:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D2316B0093; Tue,  6 Jan 2026 12:45:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4A9146B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 12:45:52 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D1ED213B923
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 17:45:51 +0000 (UTC)
X-FDA: 84302266902.14.2D47DBE
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1BB461C0004
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 17:45:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ddBisYSl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767721550; a=rsa-sha256;
	cv=none;
	b=fw4LbBCAl1GJoHcQFEpRmuM48xnRNOWAYuBC1VDCKSGV9YHfGyuD1K7ix/XcJXxgeU73c9
	KyDuHIYEq7nXc08/zUi8VZXPMrOAjIWkT+GG1TTs1tLzqejMz2VNxIxqCp9vZN1sP4mM9h
	FTq8cu3649Gq3WKW/8JivletHV3sFEc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ddBisYSl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767721550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y/kBjuMXhStl7onHCZ0buyxDH8xV9zQReV5PqlsjQPo=;
	b=vEexWDjvJ73I7KNvFUe8aKtDg+QwUs8CvCsQzFFDY1gW123mpoCRkuU50eFD2tnavzs6jC
	qxX8r99leaRMy0VXy/bsXyDHTSHprUDtENAS3F88Pk+u35KG8SRxJfJGoW9ZzVFHQdGvn3
	uFfq/LdveXUYcTjAVBRiKgdVCTcnc0c=
Date: Tue, 6 Jan 2026 09:45:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767721547;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y/kBjuMXhStl7onHCZ0buyxDH8xV9zQReV5PqlsjQPo=;
	b=ddBisYSl3C75O4UEQSBLay1K770egWxta8YEpv9zexBYiQVWsVY9tVbSjqQSdjXg8+aY7C
	Ey+DqOKErtjN14+/e2uqX57CpWIIJJc0xr24MPDBqXVb3D8bVs3fcQlGyXgoLSkSofl4WA
	G64pImsNl9sW9HZHkyCjaeC6aNfQrr4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/vmscan: mitigate spurious kswapd_failures reset
 from direct reclaim
Message-ID: <owsicyzohs54ozkwolv55mf65j4e647azcipy7qi3ydvuha6fu@uevqtyfwsifm>
References: <20251222122022.254268-1-jiayuan.chen@linux.dev>
 <4owaeb7bmkfgfzqd4ztdsi4tefc36cnmpju4yrknsgjm4y32ez@qsgn6lnv3cxb>
 <2e574085ed3d7775c3b83bb80d302ce45415ac42@linux.dev>
 <u2llnnpmpsgarwrt74ffgo3cuwe4apdbeh5hkclzbh5gykwltb@whb7uuj7ub5i>
 <e93c75cb1a46a60ec415215c555312c82b9145ac@linux.dev>
 <gd7qbyakigogdbfxkujtc2ewwfzbwudn2l6vqkbkttv46wkfrd@nqseltiu2do5>
 <d7df4e26841d83154f2cc2487d5acbaf2ff2cc27@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7df4e26841d83154f2cc2487d5acbaf2ff2cc27@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 1BB461C0004
X-Stat-Signature: 34xx3fmrhzt3prmb53ieupjo9og36dcm
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767721549-913553
X-HE-Meta: U2FsdGVkX1/rtZCoNNEBLwogcqWx6nQCvwf9yrdaDBpb1EzHmKo6L9gL+4qjI4E/n2MR/AiianHxgCcGNT+rdq7nisDn97DuzViLbZUF/sRI6W5mmVQ1ZR28FaA5UZuN/5QZ5O/Xvf6oceLXu/0cJDOF1ENUjt8IkfzXXsSCENa+r/Ley52gdn0qOidqD5VKAjyCAJ1mrq9ByByNIQpr/kcmYKVngIbQUOq7ZzZ9hpvdokVj/nj8IRkOCe4k57HImCgpJeC1Tc7PvfQtIfFFkvlh8R3lPnHyb3p1GfeHulA6bnXj2hYUYrcLlDTmIHblCmC0OkHeWC6QTkKPc8XgKfejlJA6g2bAbbEunvlSRQn2TpZYALjRMmfPKtb2w38fjS7o+6UujIKCmDBHGxo/ElEiH16v7P8ijoscZ5UKpdyRE5KyBGKSwZg0TFR7nJFCMoVcmKtvLL2Lo3bytplzffbCNEeEoYoHC6IVz7aysDv2QyjaPcu6Vi0fggRt1qGxdkDwrOClb6QcSp8QjxCQZK8W8C7WgzRWNPbitdXVOBEK2s2cg0elqcseDq1DeSQGjMDp31soaBpMIrpLMnegjgTAAgK0T8goLsaf43FTQrFkxaWVOlZ+9hFtGW/7+g5DDLGQc6AgGTtWHZAOxZ7caybGqXJjRsIjQuJP5zT2kSejY7Sp4ZyU/NghT6Bfuht/cDno8f8VeSCNq6lUMW0IhGfMv0OjdyJ6iBsYqlrirJ87SMQ102NZ3kSrCeiRV5+TyY4B93BQCsr2i2vy6GObgihgT81XZyi3+dVPfXEjRVdJ+FuADZdibCAXQRRaEpo2++GB2VtpzlBPteuXsqm1UW8c3ZRLeOOJB+At07KtxxaEnuK95DXZp6S70Y5z0s0+VDaDtH4g9xSKglG5UZCEF4IGBxJiIx66
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 05:25:42AM +0000, Jiayuan Chen wrote:
> January 5, 2026 at 12:51, "Shakeel Butt" <shakeel.butt@linux.dev mailto:shakeel.butt@linux.dev?to=%22Shakeel%20Butt%22%20%3Cshakeel.butt%40linux.dev%3E > wrote:
> 
> 
> 
> > I think the simplest solution for you is to enable swap to have more
> > reclaimable memory on the system. Hopefully you will have workingset of
> > the workloads fully in memory on each node.
> > 
> > You can try to change application/workload to be more numa aware and
> > balance their anon memory on the given nodes but I think that would much
> > more involved and error prone.
> 
> Enabling swap is one solution, but due to historical reasons we haven't
> enabled it - our disk performance is relatively poor. zram is also an
> option, but the migration would take significant time.

Beside zram, You can try zswap with memory.zswap.writeback=0 to avoid
disk for swap. I would suggest to try swap (zswap or swap on zram) on
couple of impacted machines to see if the issue you are seeing is
resolved.

