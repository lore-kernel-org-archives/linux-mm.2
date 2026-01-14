Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95A5DD29FF9
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 12:45:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05EA26B00A6; Wed, 14 Jan 2026 07:45:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 025CD6B00A8; Wed, 14 Jan 2026 07:45:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E77826B00AA; Wed, 14 Jan 2026 07:45:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D50DF6B00A6
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:45:46 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7E2AA8BE52
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:45:46 +0000 (UTC)
X-FDA: 84330541092.10.ADC49AF
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf02.hostedemail.com (Postfix) with ESMTP id 42A3F80014
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:45:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=lB7tLl+l;
	spf=pass (imf02.hostedemail.com: domain of "prvs=94744532ae=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=94744532ae=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768394744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/mbzjjpPpsVzlkiMoi7YIoiToKWvmhWtEUDnWSeDPQ8=;
	b=tKI89A0RVvqED1MkLT/eAb0AcNDxPitiZ4FCOIr97NuWvFs7A4TgD9YJnAYxBP8c3XATfp
	ui7Puf9s4s2IUgYQZHCIDjcpckWMoVCB8EkSuzsgbENu7YWa3svQJdq9t+FdJbguZv0DsH
	61CNtjQ93fYfw6Q4bGAfs2zvExN62Ak=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=lB7tLl+l;
	spf=pass (imf02.hostedemail.com: domain of "prvs=94744532ae=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=94744532ae=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768394744; a=rsa-sha256;
	cv=none;
	b=7NVzdEP+DKGTn1MDe7+4JdKxq7mSy4AlVADUY0ps5EV2Ga3zqQWxZXR9mirX+Of/mT7Y7b
	Fb9DdNKlU3huddTRJJ/bgTsXy7+y9/4WPSM3FSoxO+DnCNpDsnoH8TTmVls8rhRI39eSOO
	tmOj85Yf19roXIty8Mm9Q2NlVFuqWYk=
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60EBY4Hr1562086;
	Wed, 14 Jan 2026 04:45:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=/mbzjjpPpsVzlkiMoi7YIoiToKWvmhWtEUDnWSeDPQ8=; b=lB7tLl+l2I1S
	ofzL/aelsqyH+NKrxmfXvEXhmAMb1fRqdpRbFVOFzsxxylyDNsaLjc1KO1vJSZtg
	D85wfPdQK/z2Ugank7CIE5aRW70AdZEUYIMwxTHKbvPKpD6IQMzbwXEBi9n/EkQm
	ysyjc3lkZvv18QOqjLfBWYUtaxm+zPQ4TZQX1OmvM6BVl+EpVRKx5t4XR/IgkNPH
	8H/G3mPOuN+aTzDcoM155XSR4sDw+Q+eem8y+Kzn9ItBAXCydUdxfd5UrEmtuChc
	0/t363IdtEcK6MnOwcRy7jlg8OPQULvaTWN+DFKikpxoEhHYcFx2p58mGcfvJXAi
	eDp7wj3bqw==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4bpact8f94-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 14 Jan 2026 04:45:38 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Wed, 14 Jan 2026 12:45:36 +0000
From: Chris Mason <clm@meta.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
CC: Chris Mason <clm@meta.com>, Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, Brian Geffon <bgeffon@google.com>,
        "David
 Stevens" <stevensd@google.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-block@vger.kernel.org>
Subject: Re: [PATCH 1/3] zram: use u32 for entry ac_time tracking
Date: Wed, 14 Jan 2026 04:45:07 -0800
Message-ID: <20260114124522.1326519-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <d7c0b48450c70eeb5fd8acd6ecd23593f30dbf1f.1765775954.git.senozhatsky@chromium.org>
References:
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c0a8:1b::8e35]
X-Proofpoint-ORIG-GUID: oZjgV2DufGzTBOccm1TJGbVQnIOX0PPd
X-Authority-Analysis: v=2.4 cv=d5f4CBjE c=1 sm=1 tr=0 ts=69678ff2 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=cm27Pg_UAAAA:8
 a=XjV5nGeaLPyDJ1P11u0A:9
X-Proofpoint-GUID: oZjgV2DufGzTBOccm1TJGbVQnIOX0PPd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDEwNiBTYWx0ZWRfX4Bbro2YFOdmr
 WvZ7hQLyaHbsDQwXHz4cWEw+UB2D9Kph4AH+X9S5H2IdPfk3msQo8bgK51MR2xCWCERBunaFKeR
 IbUpS/ZV5To+zgtKg8PqhICjPK2FES/4aki85aVyqUhLKBQQJdbXvOpn/S+BoZT1ptFDpyUPrTV
 CR9r3ZR/zCqClq4GslGkAy7XMKZTjukeOLkjANqcCJMoRkOyJmNnVB5kLNt+2iIrcRwXNzh0zdP
 Mc1fQ6XBUO6ohFRj+19+IojcjtrIcihQ87t6smv6GUO22vL0Kuvjuscei5gOI7AImsKBU8EvEBT
 yKfxbSWURDRD1FkRCXqyjCU0oLkfLGt313mNq6zzg12WA2Yzihv+gtfX+rua8pWED5Z27VkpCgd
 AUXGEr8Zi6PiiCWW698Fftwrt0yuYfuWqLAY2SYFVKznDaLftH7RSSO6GbUA3EYe5mI2iO0Efmf
 HdgMUJvwnNyREGhzVVw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_04,2026-01-09_02,2025-10-01_01
X-Rspamd-Queue-Id: 42A3F80014
X-Stat-Signature: bfgqhtr3xxzfb6pqyw16uqwh3ru731ay
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768394744-665539
X-HE-Meta: U2FsdGVkX1/LkP32lz1q2gPmoWAlpOUTieeqaJkL3tc6j155ftYkY+Zd6iKMnBcWsjxUCoeLRB3U+NFQCLZ+m3tiS97XKob66XSrpRJmZbJPMofckW8GogPpsqcc/MU/ZICfSsJ/0dtR0wXFyDb8B1zvPQHNSka6yafrFF9uSfqIXh3EChHBOFApGpxxJavHGs6lpBfvCnIun5cF08sMoi7Tj+qmC4RCsbjqJSfdQuXh449Y2flML3KxrZQnIOFvVhLElo/fB4M2fgm0IKOpyucHnvDRN4pHo4psobIh4s4ia2jCwXiTsoEqaoqOFUc6LtNm6yrIlo9jCvfDKVcZ6vo/tYvUeCp424llGLsRYlNdshLmNd9plXI3JdRZPx1dyJU7hoY2ehBA1oB+SyhhyyWzA5CQtRyo8oOiprnFCEAvaW682W5YsvJAtuU7ViTHBnlrxYVqJNzOLrs5y+VY0cAmscxudexR7ubXfzM5Iu/+m8cebIn1EYx1fF9ld7zWm5mhfK7X/LzyR35ky7cXj6N/e5FXruYDQqLLiILLZVavUMIpauoEfCfYjB2RFaQO9NJOyAfmo/9naIBL2L1JaluERI7Isc2Yq20hJMeo0FXS6AsSVVCDj2s48CjnHWoy6os5BLm3jpIVCJ5j/SJmfpcUgJj7I39zqkkf2ZSqCSNpzMCECA7duQ2xLNCcB91ttacrawAwvh9inXyYdi0xuUQ3BM+oe5nhwIEv+PWl4LrItdHWwvYUuoRBscLp5EWKjg4Khto99RwH2DZnInLwwSP4NqOE9DRGeInrUVH5I/PM7MWuMFhdTvYMP+XlYLxFZWq5fWJz5H59aSrkazp3wfesq8MJwSAUeb12QPtA3VRn5L2rW30Bjhs+ODIFL5XhW1yahiM9pYFJ5BbBsXHZ1a04GPbaJAq0w3OiqtP9D7lh7iJA5GqRgaCcJDKDWtdNHcQYcyomy3f83+lBSFW
 Xu75TgmZ
 Iev8Bv1WxQejsIC2QL6ALoJEoe0bezwPbWSKgYNl53Mdrl6fkKw0B+/SBPRm8dQZDyuDT19fjcsBP70ANvGh+vp8pcvol3kx+slAVzshKUnR2ltLaEjymUAK0TM8QQL1FzaQjFkFlgUEXZlBHJDhksqI+xaV/6YkVb27CaYXu31JD4yNP6nP44BpW5eBPGtTpQfAI/lkpZUTfaecf+LrnC+8F1vwCEppvIIuo7R5ir9LrgdHXu2C6zB1mDJ+S++ZcifoLMQLcXQ9ClxmAxnOE/hSYDHDldRud0RdmC2DkmKH6BIrOJ9bgbAQvRftD2XUjkuOKjutnHWfOMuKBqlDs3yZkqBjMNiKedfsEfvCAczte8St9HjwL1GUBk9oeZMoUx2g24Skt1U684oxVtbhe6EIMHGijaFTIKUT4PAk0I3qzCc538ogQMV3l+S8CAQggBL8Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Dec 2025 14:47:11 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:

> We can reduce sizeof(zram_table_entry) on 64-bit systems
> by converting flags and ac_time to u32.  Entry flags fit
> into u32, and for ac_time u32 gives us over a century of
> entry lifespan (approx 136 years) which is plenty (zram
> uses system boot time (seconds)).
> 
> In struct zram_table_entry we use bytes aliasing, because
> bit-wait API (for slot lock) requires a whole unsigned
> long word.

Hi everyone,

I ran mm-new through the AI patch review prompts, and this one was flagged:

> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c

[ ... ]

> @@ -222,7 +221,7 @@ static void zram_accessed(struct zram *zram, u32 index)
>  	zram_clear_flag(zram, index, ZRAM_IDLE);
>  	zram_clear_flag(zram, index, ZRAM_PP_SLOT);
>  #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
> -	zram->table[index].ac_time = ktime_get_boottime();
> +	zram->table[index].attr.ac_time = (u32)ktime_get_boottime_seconds();
>  #endif
>  }

This stores seconds in ac_time.

[ ... ]

> @@ -1588,7 +1588,7 @@ static ssize_t read_block_state(struct file *file, char __user *buf,
>  		if (!zram_allocated(zram, index))
>  			goto next;
>
> -		ts = ktime_to_timespec64(zram->table[index].ac_time);
> +		ts = ktime_to_timespec64(zram->table[index].attr.ac_time);
>  		copied = snprintf(kbuf + written, count,
>  			"%12zd %12lld.%06lu %c%c%c%c%c%c\n",
>  			index, (s64)ts.tv_sec,
>  			ts.tv_nsec / NSEC_PER_USEC,

ktime_to_timespec64() is defined as ns_to_timespec64(), which expects
nanoseconds.  Since ac_time now stores seconds, will this produce
incorrect output?

For example, if ac_time is 3600 (representing 1 hour of uptime),
ns_to_timespec64(3600) would compute ts.tv_sec = 3600 / 1000000000 = 0
and ts.tv_nsec = 3600, resulting in "0.000003" instead of "3600.000000".



