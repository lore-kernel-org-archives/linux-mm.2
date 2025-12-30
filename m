Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC52AE9410E
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 04:11:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EC716B0089; Mon, 29 Dec 2025 23:11:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 396C66B008A; Mon, 29 Dec 2025 23:11:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D9DA6B008C; Mon, 29 Dec 2025 23:11:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1ED7E6B0089
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 23:11:39 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E1073141002
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 04:11:38 +0000 (UTC)
X-FDA: 84274813476.06.9E498E8
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf25.hostedemail.com (Postfix) with ESMTP id B890AA000E
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 04:11:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ccobxUBT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767067895; a=rsa-sha256;
	cv=none;
	b=gU31HoP1Yy+U+w55mDwFJqr20Nx8GRdNioGQOBC6+Rj8IXDZtY3KqvQWpJxooIZ4sB1IO3
	Lvj0aTWtw99vk3XNfOZHk3B1YaA2QZ37setpfCYXImngw3DQAOpt4DzQD27AtLYRfBA6Cx
	9A0og35gmdY1hF5dfasZ3QGQXW3YP5I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ccobxUBT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767067895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r8Gvt0xBPaqEQHpjlZBewh20jN1+cqjtxMqmPyTRtzI=;
	b=5nBsKAPH1m69EjpCNj6lzTe4kTW0KFMuwtli55keZ16J1+NuCOlNQuZHSOLWqpiudqtves
	Vk+dZaxKsz24V21i6QvXJQ5m2Mpg3YqekRltWAY04lpjS84WqP857U+/T+HZZDMTX8w6b4
	8iOZ5gdjRU+hANKfRJtZWe68QoXLwCY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767067891;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r8Gvt0xBPaqEQHpjlZBewh20jN1+cqjtxMqmPyTRtzI=;
	b=ccobxUBTuMWM7EGfjZbZGfYYmluDNpGprUkUsrrUwOgE1A/0Jz4Rd+dAiIV4sGNn8VaHsJ
	LU8ikPNPEIYA7HBVPiySWJff/Q74rwDsVFPPEHvuES3vY8x0NVc/ABFvlE5wYSEGnNEDQE
	d1lAn+7A+D0JdjkMw2ii8kU8IzBfZmA=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>,  hannes@cmpxchg.org,  hughd@google.com,
  mhocko@suse.com,  muchun.song@linux.dev,  david@kernel.org,
  lorenzo.stoakes@oracle.com,  ziy@nvidia.com,  harry.yoo@oracle.com,
  imran.f.khan@oracle.com,  kamalesh.babulal@oracle.com,
  axelrasmussen@google.com,  yuanchu@google.com,  weixugc@google.com,
  chenridong@huaweicloud.com,  mkoutny@suse.com,
  akpm@linux-foundation.org,  hamzamahfooz@linux.microsoft.com,
  apais@linux.microsoft.com,  lance.yang@linux.dev,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  cgroups@vger.kernel.org,  Qi Zheng
 <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
In-Reply-To: <423puqc6tesx7y6l4oqmslbby2rfjenfnw5pn5mgi63aq74jwj@jwgorel2uj3m>
	(Shakeel Butt's message of "Mon, 29 Dec 2025 20:01:30 -0800")
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
	<7ia4ldikrbsj.fsf@castle.c.googlers.com>
	<423puqc6tesx7y6l4oqmslbby2rfjenfnw5pn5mgi63aq74jwj@jwgorel2uj3m>
Date: Mon, 29 Dec 2025 20:11:22 -0800
Message-ID: <87ecoc7gnp.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B890AA000E
X-Stat-Signature: rbq5zwkq11u1so49bn69iyjnaq46uj8z
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767067895-129917
X-HE-Meta: U2FsdGVkX19P6PNF3SkvtLJxv827eeys5da2EuFVvPRobzNJ4dWGQM6PxROCSz70agHV2LnPbhNjl/FmHqbryva+Wp/PtB66dcyOPMcvVvZKLfWInR3fQrkfdFbQAgrp4x6SrIcF4OJybt5u2Q6z8FtoLuW8PLSWgbBYA8yTttamtLvLnraeMU+Nk4s+03VgR2qpT1LG+I1l4nqF3iqPXQUI3/H7TZeCgkjgZEi2+vYvX24deydfV/IV9Wj7DPPuv36ZSUMEzNx0vS9NrNoftysag5+C+lja+0H5z6gYICFJyzNC9mhywinReBx7F/HFR0Fm8ncMgQDMFXeKUWJlCqSGzIca0oBKuqeyZMNA6YcPAYfflU1Kp7mE28oGrfHxFSrcR1RIbXu1xoKoa209yh608axu3ITztybMpDFNf5GjkYg7Bj1En3Gki0fLnrfQPPYzyu3outyprhxONWrzZ1HTNaku/80OTmAWVuQlX4C8Qbymtt0cuXQp+7sFOZHO3alAdNrWrrWfFQDlHz+iRKl36+lRVOk+6+Ngtf1yBye8K/vwl8kuvKqRkHLxdXAxr+A2qfOkb11qJcCWiKLVMG32w3GwpT+T3ljOb8PuFZEvcwunwOnke5mfQKg+7XMgjlbxta66qMsF7OLW5wlx790jsd825O/vm3Y6XQ+LHrdgrdE1QopJyIOKpyyxR65WspeBauLpTaLc4J/SOz/qjkhlpZ0hbkZpcgHruIWfHClKq0xfbDnoJJqO23kh/+TSO4Rkh9H7IfTh2slIEpdXbwxO6s5cbI6nHzLJDNBoMcn/XWvfJG0XrMn5KM7QAdfw78hdITrt4h436eKeoAHr25ltvnOgx3hTRygDcCzKyJy3M8MVBlDPJQ1QEu8zE36afLzVwAmIcjttDfTDrzZpPCPfH6rLa/aElTf7DysivjIXBZFcvFqWz4GPKpuPkavgU8ffTX2e5tf0mcAKMJE
 NP4KuEja
 pK1sFyN9Vy//kPEKZX1hXSXYVhgPfw+ss42BPSXRRe+xUM3c0Or5mHGG6o9TM999NxjGfiOvEB5kzKARoGU+tFnvDcAXpnyqRYYIXr10wWTvW9+8Te6B/5Fxwm/Jz0Yf1FHexlSIRME5ncr0BipIfltkQqQrUHgZBBJp4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shakeel Butt <shakeel.butt@linux.dev> writes:

> On Tue, Dec 30, 2025 at 01:36:12AM +0000, Roman Gushchin wrote:
>> Qi Zheng <qi.zheng@linux.dev> writes:
>> 
>> Hey!
>> 
>> I ran this patchset through AI review and it found few regression (which
>> can of course be false positives). When you'll have time, can you,
>> please, take a look and comment on which are real and which are not?
>> 
>> Thank you!
>
> Hi Roman, this is really good. I assume this is Gemini model. I see BPF
> and networking folks have automated the AI review process which is
> really good. I think MM should also adopt that model. Are you looking
> into automating MM review bot?

Yes, absolutely. We're working on it, hopefully in January/February we
can have something reasonably solid.

Thanks

