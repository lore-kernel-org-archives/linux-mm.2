Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3762D29FFF
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 12:37:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63D796B00A9; Wed, 14 Jan 2026 07:37:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EBE46B00AA; Wed, 14 Jan 2026 07:37:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E08D6B00AD; Wed, 14 Jan 2026 07:37:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D6E06B00A9
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:37:19 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 117C01A048E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:37:19 +0000 (UTC)
X-FDA: 84330519798.09.1F4677B
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf07.hostedemail.com (Postfix) with ESMTP id 10DAC40007
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:37:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=MCDkIVJu;
	spf=pass (imf07.hostedemail.com: domain of "prvs=94744532ae=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=94744532ae=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768394237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rl5dmfTpOqb6nmXRmMjziUP1h91ZxP1IGb2cOMuPhG4=;
	b=K/fXOt5TtOK+KsOV3at2u8mJ7jellzHfj+Gc9yjZ2KpOI5Nen7lFmOP1YF/SlU7XzTmqd0
	JO1moe7YvJApvaFYOh7xvUdKE8J6zwVAuVdMRJdKGrvsNiGzuzW6DDggKHohWVDLH8B5qN
	UX8dYQSc6PMpP5nucYX25NJwDDpX0qk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768394237; a=rsa-sha256;
	cv=none;
	b=k7eBi6DyBqS0GeGPMxl3ILNkMT1yVOBPfV82Z+D+gdsNjHAOu1El5d9Km5sxGX9XSQ58i2
	t2S5zzRtwosTYAK8ke5ifL9O7WuRO1dg6deJr0EGCrcjQlrdOui7wUik356SlXsfgk/Evn
	Jy0YjJqctdnhBNGsyd2V5Yn/bFAdMZ0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=MCDkIVJu;
	spf=pass (imf07.hostedemail.com: domain of "prvs=94744532ae=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=94744532ae=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60E3oNMk970127;
	Wed, 14 Jan 2026 04:37:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=rl5dmfTpOqb6nmXRmMjziUP1h91ZxP1IGb2cOMuPhG4=; b=MCDkIVJuJ6UK
	kYOwjf0/6uew79opwH8bG6BqPmgKEx7zS2dK5bGtdRw7MApC9vXnvqNBfZk7IpGd
	GrmeIAkU4G9kOx3LPR+4rWKAmN/u2h6wnVQ4jD/R0zMF2aPwC0ENujAAM0z01bi3
	p6g88fLGbTRKbUgNdLYaR2OOoV7fS/yGbTMFnHQ2iqlTYDY/z/5/RJBcS1ALQKdv
	I/JCnufu6ubRDcmgoq5bt1MujvWqZjeSVs4gNzv7TGrmA67TIh7/RX0HTQuvD1Hj
	I8EMy4gueedpNMs7FU8yNzEdBYtgSTVx2ovG2QfcCFtVXCYTkqmWl1GV21GMcOP4
	oYJh9gI6Jw==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4bnuxc6t0j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 14 Jan 2026 04:37:11 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Wed, 14 Jan 2026 12:37:10 +0000
From: Chris Mason <clm@meta.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
CC: Chris Mason <clm@meta.com>, Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, Brian Geffon <bgeffon@google.com>,
        "David
 Stevens" <stevensd@google.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-block@vger.kernel.org>
Subject: Re: [PATCH 2/3] zram: rename internal slot API
Date: Wed, 14 Jan 2026 04:36:54 -0800
Message-ID: <20260114123658.1231407-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <775a0b1a0ace5caf1f05965d8bc637c1192820fa.1765775954.git.senozhatsky@chromium.org>
References:
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c0a8:1b::8e35]
X-Proofpoint-ORIG-GUID: rf_1snwYzoHiJENk1_PLmMUp08i5UTY9
X-Proofpoint-GUID: rf_1snwYzoHiJENk1_PLmMUp08i5UTY9
X-Authority-Analysis: v=2.4 cv=ZfwQ98VA c=1 sm=1 tr=0 ts=69678df8 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=cm27Pg_UAAAA:8
 a=rX5dzeJzlTyKBjE-IuUA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDEwMiBTYWx0ZWRfX70vd2EiqxqbB
 GpdUDkV1GtatYuA/ytMlzPeqU4OcjX9h+tnu/z6cX2tavHVnQpNJ0s9V0BgVOKKoLu/g1q8D/fL
 qllvYp6f5JOSrpOt/ziXB7Jf1Zl7rPS8skPi4HFn2fv8274uCP7YputbbfXIWAmHJKRohU0VrFx
 Mza2bU/lbERaLF2YREJ/sUZGFq4D5MCtngsG9x7Ahp6C9qR7dGYvvO8Fhm4WcbR50WjBQELwr0c
 HYH8bHoXlwSrXLTtV4Cfu55yoErMYtCgk0X55VycPUwqpuMaVHHE3cjWp6xGtmr+Ed+vCrMP0l6
 Q4orfFbm0LYMgYskxID5lvHBzaQOfUJYami4EvQBooLygGxLzRyGwjl7VbavW7T30g/Rg5NdMfI
 V0dzeSV9OfP0NiuTQoIPWk04WLpDSe5bXvBTIXM8kdhL8z4EOKeBJPq/XWltHKZz1PN0D0QkhYL
 kZTkHuKI8OhW4v68Q7w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_04,2026-01-09_02,2025-10-01_01
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 10DAC40007
X-Rspam-User: 
X-Stat-Signature: w7841xfgnt3sgbxqdh9hfqp4mgxkxptx
X-HE-Tag: 1768394236-176260
X-HE-Meta: U2FsdGVkX1+4jIvgdmbnNe7bMvZXjKW/gHhAc+tf+zPkiUTg6D2vuS19Ydv/R7mLi9ii7lmCkb/Mu34eKp8gUSi6PGa8l40FgA00xTvwchyn4jft0tbxS1yeMkqjJ0Uy/iZ0mtPPkt5RbZAiGRgNKyf+Q4KRiqcUH4kPr9Hl1gEAkAZ31l839NieHASI7Brw7yYlv1AFyDxuxmvlJgZ1sI8fhC2pTfYkXPfDIqBu+PNzA8d/z0nRSFfqftFZxU0ncsxDOuxWcwzACj3FxpAmjQNVasw87ysmRPjt4gIdwmxveK0vewa8q9FEffPqYRgjaJvdL0YvWbzG/aX/EPARmNiB+sef8zOwAzWQctSVK4jKu7768V1mbuFtCfrjdv/KZh6cerQuX4Fxa9l8HYfE2cLADL0mSk0cm6Bu6l5NUcQ+v7sdhh90WaHJuAKJlyNF9FpC0A9Pc+EYRfgjFQsIrbVeBekuP9vNs3W1Cr1Bsc6u06pvOuISidM2K4oEzK4IOzj7DMf1+X6T3Lb3+uBcwLGuWobEzx/9kU9bkzai3Wmo6fGBLPgFYIVAS2LRK8bWJ+6xXC60hh1WOdFMP3XRzQAJTmyE/5RtDb8s97usQ5t17ntzAS3m9chSOQhLS6caX6KGol19q6XKJ6E4UJLwMgqF9mIbEHUralfLySqY8RrgioEAZdOLs6VRZOoZjV4BYGbtX4JHwQac9C4kvTMEDK1CkU4gbs9AuT52id57ylboU5D2D/YSzTVG08RZxcgaT6eqc+8EaJua3twm1be56i1Wet1JSvH2z1SdMfdZ5oRahqDgU8gkQ6dh+oIxDKxBIlQsQWN1xBWwM03Dv0Sb+QmuAGmCWCwYT/30k8npQnrw1Jd9z/3yfsfS1W8KwOo6jUXZAisX9cUdCcbOsFp9ctp0hY4XQx7jxW2I8i5mjBACX2/cVTZhX21n+fJ5g6rDwnllgrsDOHv9KRPC5sM
 mwd+16HR
 atlP02a2l06umZcUd26P8xWKUWFsuPSTZIznQWHW8Et/PnODTZyuZLsR6eAXAhSbMx8929EsZjIzU6IfLRPECDflJbuWiH94hx+EE//kgEUN7tB8dLU/WAWTTCSMM4oUIgvRpyZycugstXgggTJ6kUTDfEaIq5xmOyDCtIPRG6WHfN84Ogf3vNGtRwfvyDXaw8ay9Ap1cue665h8J+m7D+zlh425akdiXaFwMEPYjvA0cqZyhV0gV6mkxHnsH755cBrLxCqRumYXENY7xMK07QJPYCy5IC5SxIc/3yvjov/Qi8PzPxKoli56vyxjzIu6JCLeqM6n0HyhYi5lExvZBodr6Mr6dnavoR5QaVVp+lnMc+i63HO4isQ5lLS6P0638zsX225N0BX1WvYs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Dec 2025 14:47:12 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:

> We have a somewhat confusing internal API naming.  E.g.
> the following code:
> 
> 	zram_slot_lock()
> 	if (zram_allocated())
> 		zram_set_flag()
> 	zram_slot_unlock()
> 
> may look like it does something on zram device level, but in
> fact it tests and sets slot entry flags, not the device ones.
> 
> Rename API to explicitly distinguish functions that operate on
> the slot level from functions that operate on the zram device
> level.
> 
> While at it, fixup some coding styles.

Hi everyone,

I ran mm-new through the AI patch review prompts and this one was flagged.
It uses a lot of words here to suggest a copy/paste error, but it does look
right to me:

> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 65f99ff3e2e54..f00f3d22d5e32 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c

[ ... ]

> +static void mark_slot_accessed(struct zram *zram, u32 index)
> +{
> +	clear_slot_flag(zram, index, ZRAM_IDLE);
> +	clear_slot_flag(zram, index, ZRAM_PP_SLOT);
> +#ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
> +	zram->table[index].attr.ac_time = ktime_get_boottime();
                                           ^^^^^^^^^^^^^^^^^^^^

The previous commit (472f3f208d78e "zram: use u32 for entry ac_time
tracking") changed this from ktime_get_boottime() to
(u32)ktime_get_boottime_seconds() because ac_time was changed from
ktime_t to u32.

This patch appears to revert that change, storing the result of
ktime_get_boottime() (which returns a 64-bit nanosecond value) into
the u32 ac_time field. This truncates to the lower 32 bits, which
wraps every ~4.29 seconds.

The result is that mark_idle() will compare ktime_after(cutoff, ac_time)
using a truncated nanosecond value, causing pages to be incorrectly
marked as IDLE almost immediately after being accessed.

Was this change intentional, or was it accidentally reverted during
the rename refactoring?

> +#endif
> +}

[ ... ]

> -static void zram_accessed(struct zram *zram, u32 index)
> -{
> -	zram_clear_flag(zram, index, ZRAM_IDLE);
> -	zram_clear_flag(zram, index, ZRAM_PP_SLOT);
> -#ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
> -	zram->table[index].attr.ac_time = (u32)ktime_get_boottime_seconds();
> -#endif
> -}

This is the original code that was correctly using
ktime_get_boottime_seconds() with the u32 cast. The new
mark_slot_accessed() function above should preserve this behavior.


