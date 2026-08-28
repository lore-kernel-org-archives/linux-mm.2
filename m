Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3A20C61DCD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 05:37:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 809166B008A; Fri, 28 Aug 2026 01:37:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7926C6B008C; Fri, 28 Aug 2026 01:37:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6330A6B0092; Fri, 28 Aug 2026 01:37:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 387AB6B008A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:37:31 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 629D71A0391
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:37:30 +0000 (UTC)
X-FDA: 85149570660.18.A67BF9A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id A10F2180006
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:37:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RQ3yEnvm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787895448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H/VifZxkJSk1k+3aE/imUllFCc9JvxhQtddtCwuwgbg=;
	b=58m9r5sPdCr44kzFF8Gos6Fa6z+EjkavVTn+hpEdh899xGoJXH2Kj0CBUooK7pGP5rYtVj
	WH+hr6HENv/HHKgL4WY1wGAXU6B8/3sVLwcu8UeGsjtB/E2/jXVzy95DaNYI+gwIMy+CoX
	N8+YGoQpcHudejMmP/BlznmgQAeUWcA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RQ3yEnvm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787895448;
	b=7CKdYQgjnDq7VwOcV3p+d6ffGEP4TQQvc7eRz9SmUzryQA+p7D7qkJLuqJIEsqj6mY42ZQ
	iZFFzjAzMvKWyScf3NVCaLACrALsto/zcMBlRvWjDyfG3QSxe4zVp/MnmdBf1AjYF1Xw/6
	T8ShgRq+SnAUl2zbQW97KhzhTyoP4yQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6774B602A8
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4591F00ACF
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787895447;
	bh=H/VifZxkJSk1k+3aE/imUllFCc9JvxhQtddtCwuwgbg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=RQ3yEnvmddp8nb+1nMK2sB0pqv1JFKKfCfibJ5P+kia6a6V3i6Zgtx/PwPnLBbs1q
	 EgMQasl/9ouFhJgteF2mA1DQhRvaZvFK12CA3B7oIrjcZa64LTOMpfLd7tEIgYBGTe
	 9FAeEy4xpwYLO9iLaxpT9lsv/ztMDT4eorH/z6xC5eve0LX50Kr2/1YFcvUK+8dy+E
	 cfdrFvF/zdsm6XfCdDFoUZaS8TDTWlHQ8kRGTYf9LrAbXyyHKHB1EIqiWKgzo1soiA
	 TuxKTrT3ImCZ2Ggwqzq90JZhbRw83LB/VqV5uD+OJd4RdZ6LyHPzstNbzy6LriHMKl
	 xZX/ja4pehXJw==
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-90ce3971a86so1710946d6.0
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 22:37:27 -0700 (PDT)
X-Gm-Message-State: AFuF++nv6BjT8LQ5H7PJWQ24CvZeLgcZiXptLCcOSm9o3PxnfEH7wjzR
	IVCuLY6HOc52Jzyr33xV+XVLJSBLn+Dg9x/k0svYcXHxqxqSTRBw65wHya7K4B7V4e3Mt3Nuhqf
	V9XXGqbytuLNCYxTN8WQZ+1hJYrhG85M=
X-Received: by 2002:a05:6214:5b0f:b0:90c:5947:7e60 with SMTP id
 6a1803df08f44-90ce0c3d7bemr67500216d6.4.1787895446368; Thu, 27 Aug 2026
 22:37:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260824073806.629593-1-hebaoquan@kylinos.cn> <20260824073806.629593-2-hebaoquan@kylinos.cn>
In-Reply-To: <20260824073806.629593-2-hebaoquan@kylinos.cn>
From: Barry Song <baohua@kernel.org>
Date: Fri, 28 Aug 2026 13:37:15 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y-aAhfYEEroOD0=hromLZA63CYw6OegN9tgYBswD20cA@mail.gmail.com>
X-Gm-Features: AcwNN1VuYRowG3GmuIFFw_UGh3tRxLgNLrdlpD6S5c_QZxAVgl9KzWVuJNQ_sHc
Message-ID: <CAGsJ_4y-aAhfYEEroOD0=hromLZA63CYw6OegN9tgYBswD20cA@mail.gmail.com>
Subject: Re: [PATCH 1/9] mm/mglru: add MM_WALK_EMPTY stats and tracepoint
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org, 
	rostedt@goodmis.org, mhiramat@kernel.org, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, baolin.wang@linux.alibaba.com, 
	hannes@cmpxchg.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A10F2180006
X-Stat-Signature: bpxbgxk39oy8m54ggj1qzqdjyuw5izwj
X-Rspam-User: 
X-HE-Tag: 1787895448-918631
X-HE-Meta: U2FsdGVkX1/sKBK7FqnvJRRZAMZyUwpt9Qz3umSPYOqmTmGgbpLVLGN3MRNIISPLpbUt8OwntPlMZkyt1+qtHFV+9bpoALZ1wIIpx1OUT327VDh7L4KzywrnpxIgEcHxNngxeBvpY0u9sHpGQ+eI/N/pkidzvLGAjm17gcUZ0+U0ToCRlyH3BNn0M4MXVDMo7+nqHAHXHcwoOGXnJas73T4/4PWHmEJVH+6c9brYgKtsCuyGQukDaTHIIZGA1t1z3HYCtv03gPyz4a6n62Heng6OmwcZtFSwid2fMBW1+olOyqiD2Oudd+OdcZQJjX+5T44iwuaUv7xOnDbN7bt1xMg7FMIaSrwxqIekcD8NvSHJ+rZoZwP2bA8fS0kkZ/qV1lN1zEKe9uuwgVC03h/giSMSyC5F5vCqV9BoijUf49NMT8BUmSR2k4k61yf2JIOmSSvePmGZtdp1RPNDaqAis3F232BHdQmE4Qx5Rz7y22hq0OivxxSmhX+05ROoImQIL/u1wKF1fbwajM5c0hrAnxkfqAFidWHLah1x5I/bdXtiNcWO6tH8mpUQqsaEFDZ15t8nBKhemfo2ZkUIk+7I7xfcaBg5o8TWKc/n+ie3V+HeTBIGTz9yOVTqMixWvIkXHvzBh9bfAtlrhOOgIOCyw1PWbCEE05Wpw5EuS4bu19gSUp2vM3sCmA2R17SwLD49+XOWLJKoZhvA2d2LMJWN2kHrbo+MbmDjPLTNKEBpXUquVB52oQxNahCSNpnwV4sYh5PEIqz257A+i4cEnZ1T5uV5F4Wgom13ct1vB2GGMY8m/7R5mCCFCjExFy0QRoQdHFHpgjLoIgBW8OZl1Low3JGzhtM/lqF49nEA2//QMC/garYN9hd5ovteuvmHdmUUAGDsyBT9TZQDefywLAG5aah3CrDfDLiGLHWB6HqJT4gxyLbuHgTM93N7HGSCPATeKwGlvzcm2MzNWhhfSwI
 y8RiU7yk
 EzQCjY8joaDTcHjoqTFD66mn9Fdp+/qldpNpL8AqB5xV0Ky2fxgSCSsSb3aS378xSS+NT0LlgPduFdtfYcnNQcx5+6/vfPQj9/SOxMcqivMh/p6SMmDCwPXv05yfbo+6W5dvMoURo/cB8He/Auf2qks2NVkCjtB+qYmBE2uiiK8C3PGHQZUtaGLYXZQBjcYSpnw5nCAXLiJO26bDmlQyx/IXgRcBJFAlzhzQ/hG/s2TuRWWtzkuy3bfiMSBUY7rVR0iwB56ZrjtKcKEmoW71FC3e3+sh178+MfOkpBOybPT7uccxD+52WcovFjOrptwCx9DKlQMH1b4HTblQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 3:38=E2=80=AFPM Baoquan He <hebaoquan@kylinos.cn> w=
rote:
>
> Add per-walk counters to measure empty aging walks which traverse
> an mm's page tables but find no folio for the current lruvec (node+memcg)=
.
> These are common on multi-NUMA node systems because lru_gen_use_mm() mark=
s
> an mm for all nodes at every context switch.
>
> New counters (accumulated in mm_state->stats[]):
>
>   MM_LEAF_ELIGIBLE    - folios belonging to this lruvec
>   MM_WALK_TOTAL       - page-table walks completed
>   MM_WALK_EMPTY       - walks that found no eligible folio
>   MM_LEAF_TOTAL_EMPTY - leaf entries scanned by empty walks

Hi Baoquan,

I'm having a hard time understanding what MM_LEAF_ELIGIBLE means.
In particular, I'm not sure why "eligible" refers to folios here.

I'm also finding MM_LEAF_TOTAL_EMPTY quite difficult to understand
without looking at the implementation.

Could we come up with clearer and more descriptive names for these
counters?  might be?

MM_LEAF_ASSOCIATED,          /* folios associated with this lruvec */
MM_WALK_TOTAL,               /* completed page-table walks */
MM_WALK_WITHOUT_ASSOCIATED,  /* walks with no associated folio */
MM_LEAF_WITHOUT_ASSOCIATED,  /* leaf entries in such walks */

>
> A new tracepoint, mm_vmscan_lru_gen_walk(), fires after each walk, and th=
e
> debugfs lru_gen output ("TYFALWEE") exposes the new counters.
>
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> ---
>  include/linux/mmzone.h        |  4 ++++
>  include/trace/events/vmscan.h | 28 ++++++++++++++++++++++++++++
>  mm/vmscan.c                   | 30 ++++++++++++++++++++++++++----
>  3 files changed, 58 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 94f9c3ff5416..229d27fbfb54 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -595,6 +595,10 @@ enum {
>         MM_LEAF_YOUNG,          /* young leaf entries */
>         MM_NONLEAF_FOUND,       /* non-leaf entries found in Bloom filter=
s */
>         MM_NONLEAF_ADDED,       /* non-leaf entries added to Bloom filter=
s */
> +       MM_LEAF_ELIGIBLE,       /* folios belonging to this lruvec (node+=
memcg) */
> +       MM_WALK_TOTAL,          /* page-table walks completed */
> +       MM_WALK_EMPTY,          /* walks that found no eligible folio */
> +       MM_LEAF_TOTAL_EMPTY,    /* leaf entries scanned by empty walks */
>         NR_MM_STATS
>  };
>

Best Regards
Barry

