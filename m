Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8C0E606A329
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 19:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uqzq17v0
Received: by kanga.kvack.org (Postfix)
	id C32406B05B7; Tue,  3 Nov 2026 14:46:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C08916B05BB; Tue,  3 Nov 2026 14:46:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF6BF6B05BC; Tue,  3 Nov 2026 14:46:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8246A6B05B7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:46:50 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 19F361604AC
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:46:50 +0000 (UTC)
X-FDA: 85394840580.08.0DCC063
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf31.hostedemail.com (Postfix) with ESMTP id 500EF2000A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:46:49 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=uqzq17v0;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793735208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tbhFeeAdo3cGeZk0Do0XADy8H3/aCehg8bO9iheoWj0=;
	b=QLB+ol3lSF9/Cc3n/H0whWO3e+YlEW6fLD5AhENapWBvcFydPO/36OXDb3r96DwbvzgUni
	5yU/NShhBXguswytaru3gyU8iUlENavtvWAHCQ056I8J4Sl5mALsP5vSOjuxzCUTuMnE7L
	VdQRxrj2JsvSqDKA3ZIHkcBBzRw7eHg=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=uqzq17v0;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793735208;
	b=yAQUUo+03u7zjAJLt4YDbVyJJ5n+Hyn+ro6a0JIqWVT3TsHkJ9vbTPGDmazMXQktsXTt8z
	i1MPRbBhnf3JczPbxG5g8AOBhTUbF9PFGEzcBANaieFpBXTwp1q46b8EWsg/PEuGlUR+Sa
	OWZI56UGy1RvKyXLMKl4jXRfxyrWki0=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48df8fe8513so3964121f8f.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 11:46:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793735207; cv=none;
        d=google.com; s=arc-20260327;
        b=Om/ioVRcvKXzQXna49H6KikD3AgOhviQ5Bp3M9nMHPyJxCvL8wrTQN8EFGpUuIcA77
         UHRKsi+ygs0mjM+44j21yTfD7O1GOOiOtt6aUR82buorPJPq26SZ/eCex4sePKtGFJqa
         XaBa46SnVCipBrzhOJNLvDqBFXPkoEzyzNikl9c/Amb3oSkwwi4rFhAe1vkd+dCQpUEX
         e6kbmCy1gi0wsL/M8X8lqARgA+RwIvWTxln8+XTpM2LYokOoNwYy7XXX4uc9mxacv27P
         dwIfU2e+WC5ZAVfpIM0bTcoKVVm/iS+1/INLxB8pHI/jmkbVsloB3IvcIOILv+vh5X0p
         GJqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tbhFeeAdo3cGeZk0Do0XADy8H3/aCehg8bO9iheoWj0=;
        fh=NeOQSueWNV/RfeMOeScwzsEpFTH8lV+z29KmQu9OMEE=;
        b=kW6wZMZ1O4S79462C6qnU6duqq138F9fNi6R9ClDNdELutRfJTGfVYXmPBRtnW7bbg
         u/i+nLKoVP6E7qI6prvAmGR2wa4Dla8bP+NZdWkA/e3k0+ASTu1GpWZjs5g/g3PKNG/J
         by58IOUsYzvvmB5/iZuL6dkDuY2DfY83v0CAYMbyPZuE0VY88OK41meEhwkg8v8WMoMi
         sXeS4Iok0pZ2auU1QGSDAtdyB1jtWXu3P1NmcukWuwJJ+Y3It2UUtIijkn6BcarUG3Gz
         P7jPRdbI8YV+lTn0E5vgDvhMpl8n9yzvrkNvQKQwI5ZpaEueKrmyQjTAaK6BrFfOmzqU
         kKRg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793735207; x=1794340007; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tbhFeeAdo3cGeZk0Do0XADy8H3/aCehg8bO9iheoWj0=;
        b=uqzq17v0Jz5/gD8HRYwortD2eiP+ZNi+z3qGRt0KoEJCAVNpf4/HKYEEB+/SkihBAU
         mgb4AbVap4q3DZc+Yaa8JdyQag5FwR5hU4u+a5U81KQgBvtNqaWqZO58FL1USOlRfgeC
         9Pu5OySQWZE7g+GSCqtRuADBoL2Yhka9lFmpJlpV1ufVH/2GvzK67xOpT7Z8z84t4dAq
         tgm6ZalfFyPGD4wVBEXg/how0E78CJYVTEJgqQ9rDytLqOYUHP1B6STkH+GVevgOP0U4
         AduDvSgXo4wgRlpHNbLLPTH36KowFEiOVnkJujbOr302zZsqM4eyUnvYf2Yt4dUkE5De
         qGSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793735207; x=1794340007;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tbhFeeAdo3cGeZk0Do0XADy8H3/aCehg8bO9iheoWj0=;
        b=pNr8jEbApi9ygK87MedgAbUuTnk+zvJXEX7Tg29O885SG2gMZfDTfk1fcpokb8y7Cr
         YXr+avmVH45PVRGOW9L7HdzfBGje1nIpV6GTcjTNazNY+dt7dn+XZB1HL38jkz8iFtxc
         pDKF5eP4tdHCjlUU2zIvcbikAjvje6oHLgx3AN0joMWjxnaCRlt/gfXeuRS1jOpRIbWy
         Ux3QOBQSGKAr6E+vgfigJq0cpimyKGO91jXkZljqwpuWC5GUyxy4dUULCq/mz6tE8qIn
         c6gCyk8EZ8GoJvYIROLTtmGarzFNf6oE3qTA/zT7TvKPssvC2HJ5Drdk0kjJW7Sw+KWj
         RKOg==
X-Gm-Message-State: APuU4Z8aPSNzQwV3MLXVBDmnXEGGATF6SqUvL+kirbmrAd3BUZOaUCpY
	GgMCep8o7wmUo9JcCxmpKHyLfiBkFL5ulEAj0OLVCVbWdeoTyKfR9ZBGM42XOFa4gQiN88cTDlo
	T6ONxkLXL8ppjKfEvsDXwq9Ypg9ZAKkw=
X-Gm-Gg: AYBFou0O50Q5bbLS9evAYRbe8Eotbu4k37/hmwRWdaTmp5hD1ysPS8DL1al2YOXknG6
	uqomEXn4e5FfzR/gd90FXHN5NgvxEqGFCvUUsNpEDi+g2aNP/h3+Nb2VIfQrtvNSEsYxBXcuD09
	yYa8SGwEibWVYE0Zqo/WkoVyIkLzEkUnp6nfzjgvo/mLGPrZkXyQyXC8R0apgUKUL2IuuTgkEXy
	ksAvdquhXz683GPfWdajzGKujaQ09ISHXc/14dF7UL2ZUz+3lOlpmBslsua0ZCdt2ZnFd9D3qG1
	TXqgTEy0iMG7M+stm6xBw3jpESdQ9QlO5LPIx/XsbcuK3w82xeCGN0E2oPnq10FR5WQwIk8riUE
	iRrxXaRJiZsKS1SCv+2rFtVRRnMT3+jWKC5+xYpMlbatLZUbhdITx2kdDaiNvmmRnD1ZZdLq0BU
	tSuvjH4XhdlTXSRAlox/6fbDj33cvqFGLzHJWORHNZtJ9yU3Fky+lR
X-Received: by 2002:a05:6000:24c7:b0:48d:f460:2c62 with SMTP id
 ffacd0b85a97d-48e6e50da1dmr33623603f8f.33.1793735206702; Tue, 03 Nov 2026
 11:46:46 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261104-swap-fixes-v2-0-204be064be5b@tencent.com> <20261104-swap-fixes-v2-3-204be064be5b@tencent.com>
In-Reply-To: <20261104-swap-fixes-v2-3-204be064be5b@tencent.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 3 Nov 2026 12:46:35 -0700
X-Gm-Features: AclHuK-ifuPPTCYvHoJl5pkRRgKpd0YlnXnCuFZkcIsac1IPAugr69fjd2WTEQY
Message-ID: <CAKEwX=NY98sJMcCwT6M-Mke9aenfd6fpBLZLy3r_18uFPKsk=w@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] mm/swap: account synchronous swap reads as memory stall
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Usama Arif <usamaarif642@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chuanhua Han <hanchuanhua@oppo.com>, 
	Mani Tofigh <mt4022@columbia.edu>, NeilBrown <neil@brown.name>, Christoph Hellwig <hch@lst.de>, 
	linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 500EF2000A
X-Stat-Signature: nm1wharzqh4m97jmmfmwagh7mdx8qqhy
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793735209-452945
X-HE-Meta: U2FsdGVkX1/cqOBSaKWrrVFMPaTeS94YQHI8TbIEt0h5Gb7A6wvmgcQ4AE55KzYtYb32aalMJm875B7WgJ4M9oglH9BGU8snO0vG2dS2mt6LhqK9HwJDscf2JqsWwcYJhQPj0ii8qknmJ7M5tKt+X5GMZcZmHftLRyAWdEorzYqsqV6poVvc2MiE5/CuuOfSQaeVxg1/wb9ZIbKkWInND+vhXi5bW/Kz7X/Lk3GV9zcbeH5jaBDBG4P2tXa4xwQYLWwFr3qCk0+Pjs2UJ322I3b9t1VsC9dJ8/PhqroHJsS4GksVIPH9DcCzaCSsihS/0P6jAn6QvcWD3Q3aBwAcCUBZjpMdRPSgbOfupWpHkwTj/MBTkkHhjFjxKpwdTmgaXQSvz4igTqOxQNxthOYZ2hiel37HqdPYPj4Do7eAOeeE+I0T+f8RBQ35LS9D2KoXIFz2zHtQGJ6PV59ke3PGXdlg6mKfWJ4jtneApGgJrB9h14+iIOZbAt3kxbAVFG/df8OecWDdqgoaeR80kxk0cAa5WEoAjSK7w08UtNwwXQFS/fSLbLoH+gKXz4ej+37JWvY35+fZyJ4+odINj2aYYCWxVjgedDsg38Xrsq55wzRFHRmfpCAMAee/AoLerjZzGP4TXGfEYrQZZJMiFQB2WRLemllgJgA/whypwKpMyZxugMYgW3vcXWHrOMv135mO3g/JOe+YsOJfgeLC7wHpbDqBD49FcNs05DuR/V9gu3faf/lNktDqILX5QUpZq2Y/h3mr2NMcE1uO0htPwcFSRBKX1PufIaYrKJJOKYWMOE24EfauzTUvkfrR6X6qeZGcIdrw1kMjERswifTCRehb4x+UaYhvlcXdxK4pyUUO6xNFTlMCLI73UHEnFOdW/lBVuTbuvy/BVD0ywTRjkL1NsTKszbCu3Dz1qn4vWu/BEOebrf7wY2+Rvf5NBr5m2ArIve8XhGrtKvdTYdWSS4V
 slCe7AX+
 rdSKfMtZR1Y9p0dt+vQBlPWcDuUlC7BxcvfJcAynVHKEfCnn+2ENabdUDHfOx4i3BZq4qbfqBMO28MIbYfMdorxtOAVbyNFEITjvPV1EtcRAHv7y4lYCjAgVZ/88Qf9uMPg6mu7FJ+JpINjGGsRHvLa63F5c0WSYQuqk+9eFl7mynJ0oeAQBUOFGCgNiND3tCHpYUwGhDAa7KFBue4DV30eNDi8ANeXZTvWmqtQyM7SeweyPOGKZQMNQ/fGSDDdvAtKdKn+aCxH9GdmVg01pnrlK3v5l0+sI3G0A73dpvWTz6vUhYLXfIl94oUM3vEw79ZnDDUMeTpMWwd6dFkjk+8DsOddEjffYV78ttJPRYTSUp30IIHohrpRnEGRtNOeJaNGf22qYw43dimmgyOTFVcJKas8U4iQKg2EmiYRvLK9eK6EW9vO1EkTlUz3TtL8d7DHvakU8UG8PiJu5CGVJtuzBm2fyisrOZkNejY1OC3U9lBoXJIk4xD/RqPS2KsmLe+EmQ53aE4MBaoyQ63lmZ1ziOLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 3, 2026 at 9:18=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Josef Bacik <josef@toxicpanda.com>
>
> Swap-ins from SWP_SYNCHRONOUS_IO devices such as zram are no longer
> counted in PSI memory pressure or in the swapin and thrashing delays of
> delay accounting.  Refaults of the workingset from zram, the main input
> to userspace OOM handlers like lmkd and systemd-oomd on zram systems,
> become invisible in /proc/pressure/memory.
>
> swap_read_folio() opens the accounting window with
> psi_memstall_enter() and delayacct_swapin_start() and, per its comment,
> means to count the submission time.  For synchronous devices the
> submission is the entire read: swap_bdev_submit_read() does
> submit_bio_wait() and completes the folio.  Since reads are batched in
> a swap_iocb, swap_read_folio() only queues the folio with
> swap_add_folio(), and the bio is submitted later by swap_read_submit()
> in the caller, e.g. swapin_sync(), after the window has been closed.
> By then the folio is uptodate and unlocked, so the fault does not wait
> on the folio lock either and the read time is not counted anywhere.
>
> Fix by submitting synchronous reads from within swap_read_folio(), as
> was done before the batching, rather than from the caller.  This gives
> up batching of readahead for synchronous devices, which do their I/O
> inline anyway, in exchange for keeping the accounting simple and in one
> place.
>
> Fixes: dda8fb68b590 ("mm/swap: also use struct swap_iocb for block I/O")
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/page_io.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/mm/page_io.c b/mm/page_io.c
> index 65681eed9c80..83ed0246ebfc 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -500,6 +500,13 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct=
 folio *folio)
>         zswap_folio_swapin(folio);
>         swap_add_folio(ctx, folio, READ);
>
> +       /*
> +        * Synchronous devices do the whole read at submission time, subm=
it
> +        * it here so that it is accounted as memory stall and delay.
> +        */
> +       if (synchronous)
> +               swap_read_submit(ctx);
> +

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

