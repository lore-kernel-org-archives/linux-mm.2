Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C006AD3C525
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 03:09:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 194686B0005; Tue,  9 Dec 2025 22:09:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16BF26B0007; Tue,  9 Dec 2025 22:09:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D1B56B0008; Tue,  9 Dec 2025 22:09:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F06186B0005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 22:09:54 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BAA1012F70
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 03:09:54 +0000 (UTC)
X-FDA: 84202081908.20.F0B14E7
Received: from relay.hostedemail.com (unirelay09 [10.200.18.72])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1090C1C0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 03:09:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765336193; a=rsa-sha256;
	cv=none;
	b=hvEWp51+2ASZkpmayK3KlhUpIojms7VxPMSIjWdUEmHJHbT/WyKHRmy/n87VnCtdeF9tbR
	HLu82WyF/QWtfQCXZe0lKa+Yeb5wXrr8FmCNiKNVBRe/hBw6Zl4CgabvSTM9cbtRx5o60H
	FqeVLuRVPp0AGUFnXdbjPQwSKtKPbJU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765336193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VVZIS1/8XKlnw7cvXfOuyAadAOqf0jQKywnqvpQSfl4=;
	b=wGhBBKcOqXzBKoUDGVMQK9jCJzWKLJPSthQC9xgTWVcQKqCj6reRAtV6LB99SOk/6qy3ze
	t/5OoqN0YuxIcoams6WsBWh4DUaX/IgSSlwLKZ6jEq+0+HJgzmT8M/H1raDfnLZE/2mg7l
	d+dHIfJkP0M1hRKin/AIxm6miY1JKoA=
Received: from omf05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3743F896BA;
	Wed, 10 Dec 2025 03:09:52 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf05.hostedemail.com (Postfix) with ESMTPA id 7564320011;
	Wed, 10 Dec 2025 03:09:49 +0000 (UTC)
Date: Tue, 9 Dec 2025 22:09:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Ballasi <tballasi@linux.microsoft.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: vmscan: add PIDs to vmscan tracepoints
Message-ID: <20251209220944.6ff1a578@fedora>
In-Reply-To: <20251208181413.4722-3-tballasi@linux.microsoft.com>
References: <20251208181413.4722-1-tballasi@linux.microsoft.com>
	<20251208181413.4722-3-tballasi@linux.microsoft.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19Mw/tq0GrYj1b/7THa4iMpPMQW6mvMW/k=
X-HE-Meta: U2FsdGVkX1+3QV7/E+Czttoxvu68qqIVrv1Zgw+slAu7J2VSyochonNUMCPalBvZB1c88lbwSKf0TXkG7G0dK73wrvjCf+YpxJLc46MtnStZXip5aq1rduD/MHo+mFF3QYa9n0929iAP2sM0DlTTd3rvlDRqbyUlPx/QEN0+qMpfAU/JOMA9Rwa41uQpl/zVCBt9rwFjH8/OW9W+Jr2mRqz7I5cBeJwbxigw6oyJEYYanRTBKntIu6SxQJVhAxuiIozRq0PWUTmfl2WakYr4+Nnkmey2mYzvX46/nlBZCfvpPxl3G1CXVDtkLDhe7oDSty6WQlDLMOQ5E4rlkKoGf0J8dwHD2NMn
X-Stat-Signature: equyd4f4eiwygz3n4a87ox5n8zz7xxbt
X-Rspam-User: 
X-HE-Tag-Orig: 1765336189-187340
X-Rspamd-Queue-Id: 1090C1C0006
X-Rspamd-Server: rspam01
X-HE-Tag: 1765336192-384786
X-HE-Meta: U2FsdGVkX19h1B5DyKIzZp/FoSwA25a+OEtPcjkOCWfQYOOJoU7PYAhSX0wgSrJZIzLTWvf96VNdwhPDD1pufPp3UTc0YbMk+NbqAUjtGMjPgkRbMYNVY5NbACGC4+cMySHn+mnVTnD7zAa2A+lxXoVeikJMWHNNpISMkSlLwDt1gA3MMGf5w27munLUwOglGPx94V2SqWS0bL5xMnDlQG9CEe7Yx/5BozvQp82CVDryB5/xXPQYGRi98A9P+/drJgjQWXVkYP1+vUvmHJfb1i8ea4O3eaEcDujX96pcs7xaVK86aSnOBxDK7WvUCtZQOi4reZXmlnbz+90NGhTGwGwr5pXl2GnaaBbv2a/xWdq3d9zlumHc2rpAxosJxZeMjiQgx97A7kZ/J0Vqtzwdd8NRt4lb/MghS5X1EMvZjRqXCZzkoRsVqfWtvreumZZj1BPoo59wwU56vMwkZYvrJqPIu9unL7Wq4kZYwB2wWXFGDvAF1r8dZYO/BQ5EvbD2MlWm4XP0Rt5bQCRXOi2S3+4e+Yqvhk6bRsPQ5p4czJnU3tM3OTg+R/uCTpGjMRhOcXLM/basD2Xqhp2tOechEe2fEJ16/QPZJKWtLJ5EQWfS/fMB5kt8O+Hd3IQQ2gmGeEv0dnYrP21oKCh8NUvOFJdsS3ZB7P+oA9D/ufyu0xSNq3nkbdIpYJiD4L6Lwwy64qbNxF2+hWZCb3jafNKKXW9swg1tkCAESE6QfoWUFsovbnuzdie3qc248Aui1zo68ByOpNSiUvRhwIl7fiPSpspMa25OjuNOmCXnyuxBHKGGpRF85OwyTRQs3PavPQoh0wUQT2f4T+iSxO13HnN+0xm63eiiUqdcS1xhpNKZfTw5xPr9yuh1tuiB78QjMLf3cU80FGzwljt8nHzPUb9KT5QdxriBum42qp00ZzVyveuRle45CUdXdQAOqcB6WCTEIvwSSkVgUIbbps1NdDu
 jecXB6lc
 ppVI/O7R43ApHlFY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  8 Dec 2025 10:14:13 -0800
Thomas Ballasi <tballasi@linux.microsoft.com> wrote:

> ---
>  include/trace/events/vmscan.h | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
> index afc9f80d03f34..eddb4e75e2e23 100644
> --- a/include/trace/events/vmscan.h
> +++ b/include/trace/events/vmscan.h
> @@ -121,18 +121,21 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
>  	TP_STRUCT__entry(
>  		__field(	int,	order		)
>  		__field(	unsigned long,	gfp_flags	)
> +		__field(	int,	pid		)

This puts a hole in the ring buffer on 64 bit machines. Please keep pid
next to order as they are both 'int' and not have an "unsigned long"
between the two.

>  		__field(	unsigned short,	memcg_id	)
>  	),

-- Steve

