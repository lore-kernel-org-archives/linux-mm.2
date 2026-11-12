Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E86D606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 08:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Dn/SRGj1
Received: by kanga.kvack.org (Postfix)
	id 8F1C66B00EF; Thu, 12 Nov 2026 03:04:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A1016B05B0; Thu, 12 Nov 2026 03:04:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B7D16B05B1; Thu, 12 Nov 2026 03:04:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5012D6B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:04:04 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D0422120518
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:04:03 +0000 (UTC)
X-FDA: 85425728766.03.5FCB826
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id 060F0160002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:04:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="Dn/SRGj1";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794470642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h7KD51JuAVXS/zaBEdvdcGsS4ekwTjWuZyMjjV1lAGI=;
	b=MrXgrX283KXijkSCDKu5WmcEfGoxOkAWEKz1yygEHasVrm+ys97dCtIYgXJXTqeqvvdET/
	Ecmr4YZBnypXh7nVZgg5d2Vrm2/W8CRphoUGHtmXBsU4YVmKJSuMJZkB7NNp9QCWZVfC2w
	XAVk47YXDY+jq/nae0WBhZzOh8yMHuU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794470642;
	b=13/jnmm9gNFm4u5KS3yQkGq66gmuO9gABc0GMq9OA9od9RZ0wskeMK+RWz3L8emdj8+qOM
	NyWjKQfJ+DEY3RlYVh41b/8FphbXRCzGS4yabJkFWfN5gh8mvyT2PwDJN45DdA0TqhzEM8
	nVnM7WhT3mj31HGye9tktjEJpraaMVg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="Dn/SRGj1";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8a594d313a3so2382708b3a.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794470641; x=1795075441; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h7KD51JuAVXS/zaBEdvdcGsS4ekwTjWuZyMjjV1lAGI=;
        b=Dn/SRGj1ldeAgetWRV/W9LuFYVZKw3yGMu6BiCrbqCeUn9v5ss4+jnYhX0TP9oie/U
         IdF/pgu44Yt1fd/BC+4xKiWx6Zhf6VtjXORmit1j7Ntqyc+aT5b4vUgC+6fl+TM1jG4o
         VJvrr2GVpJsAtzKzbmTWuyaGG36CqdKBQsnlcf4Sdl35u02Nz8I3DX1sctOMY5IYKiXW
         Dn31POZEDED0BLrEKLMNbJd7Z4OB+mcp2xvtfm1klZwqyzW8PohzdncfdxA66lwI59hR
         KCUaXUdCkHiu8mh1q1mFAJAtao88oQvZxNrZljHG2a1x7Xu7oaP5/VDvxb2QDbc+nUVe
         PaBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794470641; x=1795075441;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h7KD51JuAVXS/zaBEdvdcGsS4ekwTjWuZyMjjV1lAGI=;
        b=TSjCHYALNTdz1rT2YOjHgnWhksXVPW/aVcvPjDJEumGlv+DbR4M/FS6272tFS9BLGs
         /LeVMbXuzb7BZLS1Dwjwxxbv3059II0pIjT1Hgo1RIvqHboT9dkkSl8adfAr56yly91o
         XSkX+GG6tgn+kxZSrIY71wQ6zk9l786+rG4nIoTjJPc6hl/Ac/AIO5fisd0RDzYO9mHM
         Vj3oZLngx7DdyZJzmnx8xdvlzPteBUM5ReckZC1KJ9VvKUhGiO/rCbuBQCvENS0U15+u
         PZ1H9r9/jsiQVggBF8BmJ9edr8ur4VwkhrEFZT8DUTbhH28yX63O3Zc3pvVj6RVA64Ca
         wJ5g==
X-Forwarded-Encrypted: i=1; AL+hErEbSJeWaVRTnIKIdKI0HXVHkNRoyRYve66eHCUTa9yE3VxPzVJmzA1HlMKhi+xWd59qA2vcElp4yA==@kvack.org
X-Gm-Message-State: APuU4Z/+VEQL9NoK0GHtFKwRmuIePR5NK3cvYoYRARAgODUvds1r30Bv
	qK8bpCPKuv2raq4Q3b0+Mty8TPyxGxTco1+0Rnvs7CFYfA5DoEekSUuK
X-Gm-Gg: AYBFou31mUVB6HIipC8PgiguD1qe8Bz8r70dzVhxXhr9JPB4kjRsKndh+If3J5JuIVW
	b9ryQXSpJiXBQjCjiC9r7RUNoFICne7vqZtHIM4YHk+Reie+jKoJajQSLWw7KH6HFS9ItATKcqz
	AcGhlJAtqodRe2OPMIVCVxPeI9ocnxI2lEL5OtsMFHxxycmO1Sp/o3oJrQ0mWKYlDw9ktIUspYc
	axnzoEGTXBqP+5bFOiXj5r+GwpPZ5fpcZrksRVVI1VCzUndvtDvrwK125/F4oy6VlYXBvjzdcaU
	brwTytKyLgbryaBL2GQRCDVoL385qhsZYbsNLcrFTioDp+El7rYqfhr1dbvTs0L1GGSykmB0zDd
	/vc79O2dQ5+eTYkAwQIbrSHXHGx9QYf0Kh+vfK9Dq38cmFobcHpeoKnazc4QTgHEeAgfSKBmgwr
	z338pa/HrQ2HIlf9aNjzhm9dIZesS7K7fv3lmxnInsyZt3VMA04IOkM6IojANKj1rcYCJUTB0e3
	/vtxve03RtduTNBb9cW6PDrU6v1ib6QLqGAxd1n9LPnn7BXNORZvRH/7ojbusC30ns7FOcbg460
	8dvPJUW21UxsWUusrwsTDqz731cDzwWbRMGvYkBB8dV/ts8dQp+YAEZGE32L5LRJ9qdG8QaeQA=
	=
X-Received: by 2002:a05:6a00:3d54:b0:8b1:3137:d78b with SMTP id d2e1a72fcca58-8bc1c78b3e4mr4735592b3a.48.1794470640490;
        Thu, 12 Nov 2026 00:04:00 -0800 (PST)
Received: from KASONG-MC4 ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab4fd5c6sm3065568b3a.46.2026.11.12.00.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 00:03:59 -0800 (PST)
Date: Thu, 12 Nov 2026 16:03:54 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH] mm/mglru: check need_resched() in fill/drain_evictable()
Message-ID: <avVx_1BEP7fIzGDK@KASONG-MC4>
References: <20261112075827.255602-1-hui.zhu@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112075827.255602-1-hui.zhu@linux.dev>
X-Stat-Signature: uoofuqwqmuoi3rina54bwrncz4w96s7j
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 060F0160002
X-HE-Tag: 1794470641-262546
X-HE-Meta: U2FsdGVkX1/IxrWRgB3Vo/+z8nj7RcmTrq48NiiUU8UpCfytcoyRAfY6tQN6s5x+Gs2dokSoMsi7zTIXKZsCIABn6qaliUv7j2LNa8jYeBEmxzVjndjGeSDWUGR2c7cXv/Wd9gogb0tWPwgXc/hpgYSxMD2RG3lMdUJlspBXfus3mr/08HCxl3H40Kb6M1lzNeUR1VWbMa6Kcz5xqhQM8tviAzZVa2g77GzvaDhwuvYpE+vvn1yCn2dL7FxIuQVAuj2fj2+hKOAs/aSwyIEPpjWrluYKZPqMuSZQZDbV2TradxD4SzIi80bjPfeHJ8kxgePH4uz2akA8X03sgr+8xC0FENSUJpEMwnA4hRI2a2cn7BmvRv3Y3NsgLSYGNlNNhXxZMgknbcdreBGfQaGSa8Y5LWSrfRv/5WQtBUpMOm0kJjBOyMhtfcbxb7EUg3pnnWaFukb8//AsYq+hsHZ/Bd4iSn64Dvkhgh12ZLBhV6HTBNKTkqbaOGnfqBnE6cg6WGHwWcrEN6CYZWFQaEZKxkwYpYBLsH3mWkUdli1jXi3gw7ODtNBKddGRwafj3eBtO088u1VUL2arKPVFF6J4xhKqHYgGZ5u66TfA7vBYtE6VJsahhkun6P2WHbvvBzyG5TZc9oVBM4n8iUzt629JqVsFQB23mdJw146t7v543uoMgYTh95sQAGGTWzyeSgsBN3ds4LVgwtwV7NOKv75Ov54D5QSwUi2D43bn0GFwA/GcUWA5FA6QwiOy0y/bYIPLGJUBuABJHFwAuzS1U95lUcPGIYRO79NK1ElCUdAJJstlhD1aVyOO9doYkc3xQRgmjElMAbS8csD/eu2nUoOO1MCmeYb5oBt+kSK1ifrcGVYDg4l5qeqSqZmcRi9aYSUvmmll7VQwkYPJ6EUoa0HMOQ7VIZ5x5CGDUl8v6Iv2eHFkM2lm+RKXtp4wyrSxggzolKdjxwXetBmD10Qzjux
 3SvosXE3
 mnhM0/T1cIL7FEBEbx+/J/SNy8p/BU7DOJwxt7/+SdcpQElUTY6TKRIDEhAkBPKBM2+mNdesyjegd/EFfxEyt+hQTkxdOIT6fk83U0+1kVfziy4tiyCLR/36EE+u92ZRlbPrjR5tFQtyPhTrfTwA7MRTY70L/g03hPyFQ1hF1lnM/TbQ5ycn/RNNdAMBUMl02mJnoNbEF21LmU4ou3h5BiGzE9cIrCvv0btVQLNl3HKKJLvmN7Ty74/RoJy34IJxIhsuvwq/HODLHQGt4aKSOilipnbBMAwc9MpnnsyoHPNHiR5ERCCXGe7WgnkqZtQBz1rqub0VAZWocxH0diNS9DZSJg+U+N0TFaPhWHlo9V7w3HENN6R9BcEeIAXgUHxBod+m2UI949RboZSYTrI1H3o8swoZssEmr+xyPNfACMamZqdISYyTOyY6D6bvuius0dH0DJqstPgvihc7gsiUXTJga06wd7eMFKZrrMFSyjTun1iI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 03:58:27PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> lru_gen_change_state() migrates folios in batches of up to
> MAX_LRU_BATCH (4096) folios under lruvec_lock_irq().  A full batch
> keeps local interrupts off for up to about a millisecond, and CPUs
> contending for the same lru_lock spin with interrupts disabled for
> that long.
> 
> The caller already reschedules between batches, but a batch itself
> only ends after 4096 folios.  Stop it early when a resched is
> pending; the caller restarts the migration where it left off.  A
> remote resched_curr() sets TIF_NEED_RESCHED directly in the target's
> thread_info, so the flag can still be set with interrupts off.
> 
> This follows walk_pud_range(), which already pairs need_resched()
> with a MAX_LRU_BATCH cap, and commit 6e9be217a3ce ("mm/mglru: use a
> smaller batch for reclaim").
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
>  mm/vmscan.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 6a1af9b92349..47f2cb25eb46 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5533,7 +5533,8 @@ static bool fill_evictable(struct lruvec *lruvec)
>  			success = lru_gen_add_folio(lruvec, folio, !active);
>  			VM_WARN_ON_ONCE(!success);
>  
> -			if (!--remaining)
> +			/* stop early to shorten the irq-off section */
> +			if (!--remaining || need_resched())

Hi Hui,

I've been thinking about a different design, what if we just
delete the `--remaining` check completely, and check
spin_is_contended on the lruvec and need_resched()?

In the optimal case we don't need to keep lock/unlock the lruvec
at all so this is faster. And it still avoids lock contention or
blocked schedule, and it might be even more responsive as we are
release the lock earlier on contention.

