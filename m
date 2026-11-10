Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 744A2606C68C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 17:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iOVSMI1o
Received: by kanga.kvack.org (Postfix)
	id 91CB66B05B0; Tue, 10 Nov 2026 12:55:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F6396B05B1; Tue, 10 Nov 2026 12:55:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80C976B05B2; Tue, 10 Nov 2026 12:55:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5AD766B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:55:22 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E3D2440A58
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:55:21 +0000 (UTC)
X-FDA: 85419961242.17.82446DA
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	by imf10.hostedemail.com (Postfix) with ESMTP id ED467C0002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:55:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=iOVSMI1o;
	spf=pass (imf10.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794333320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H5aIR7GM7jF71ICZGcnmJRpWwPiNZxHyJtzFYIH9Kgk=;
	b=bv10Lp0ds1XuCEBP+09GWMY/CKpFBAETxNkg9vEBR+kXc9/WauvPpfzLl4YNj3ZMK7J7co
	/iFtvcNMIuXQjPOTfntva676mIE0bXP+YBOYOjjh0B7Zgqls0crMAbHze8w5PWuWpP+Jm1
	FcEXHQXCzDsPowsYGvnt1VJFv/zULBU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794333320;
	b=8Wttp2+yVPcu6xYaA0j1pWaZWgJBtJ10XRVQ3WFuTQiRgc/2xTCAO84myDK92arpnxE8h3
	0+TUguXHsmSFiHCDUD5Hb2XrorYhNOQAylI6bYdZv7l4iQopBm1be2tLLx6fkQ9MXqFY8G
	Fp5zLfqNrfjEQ5FV75TPMnOhOtvZgPY=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=iOVSMI1o;
	spf=pass (imf10.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-3adfe77d336so18577311fa.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:55:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794333318; cv=none;
        d=google.com; s=arc-20260327;
        b=BsyWYEkDIgOYmPD/y5J02nRYgid0JZA3xryosls4tPG9QFPK36UqM+WtefV3AGLPSi
         YaRcD1xoUF8wI44m6hR4NRm7tdhLfPbQ2R9kPMF3llR3uyaJHE44G6/IlxKRMq/mVcqq
         iCfNRQNwkr0lP26Hb47uyhHLt4vGqly48N0oLkpC8T1ma7WVssXJI0IG9MwexX7cEmXl
         ZgBXyZkTwFjSHrKmV4t3aOMthJGeZ3/A9Bjr4PwNl4VyEkBfNYeZ1wGUkRTZaFLe4Zxq
         a/dQK66R7z50siejIapN7Lf/ek+psagoedJWWTlZBdXdYVC6l0Eif5ysl5ZjQCZL52k+
         Hk8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=H5aIR7GM7jF71ICZGcnmJRpWwPiNZxHyJtzFYIH9Kgk=;
        fh=QB6oGoVGds12AEp5qioIEmkLDUgTEaTsCE/jwlN1kqk=;
        b=rKUzEGTUc1FzuTRCheV0oWK+sg2uAD9bxoqJL/hV2u8sgTmKm1n5b09hYkARRgtlD4
         b/fbF5j1md4nYdlUXnW5EU5L7Jbn9ihl/QAk9xKQscwEEqDV1k1eDhvxvlstf12skXnB
         rnrpg/zVyIpoeTj5CTvrUMrCofA/FB8lXSEWSSWsZgnkMO5uLaEaaH/1qnVtP8xB0mzQ
         ezbye9A68nESbfVTEhVn6g+axhkB2ki60U2O+Df8nXnqzofSyffpS/DGlwYwU9PVGE0y
         Ozy+pztqNRdcDMCHbBrGiegsmXna1ifZor06bLqcDDhdh4AXqCzpJypMR3OaD98X+0D8
         p0xw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794333318; x=1794938118; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=H5aIR7GM7jF71ICZGcnmJRpWwPiNZxHyJtzFYIH9Kgk=;
        b=iOVSMI1oSohJfHRBEzLFTC9pe6pQ2y38rLUYKMAVTFFL1/0rfw8hafj0ECAn4+He/K
         qXju6f2nU1DTt0U3yYPyrPzipi9444A8vIm957IIbjjtbd9j9rOl/TA/T2Jafz7qbmv6
         CUBvjBg3lC+nsFooma6hxcW/Z/nOcKuMsBASytDV+b8fuET5aZQlfTQBl+oKDJz4qQE+
         maqLZ8cHAIYi2xXu0j3336jhP4co7ffAYwr4Dty1eeVCM44JxRvF8EPitcXA/M7lRo5q
         wdmi8K5e2EdPMmjPSsy7jRZuRKLlHDcIrs92hZM8bm3SZNuLLyPmKr6T6XztFj2S8fa3
         eirA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794333318; x=1794938118;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H5aIR7GM7jF71ICZGcnmJRpWwPiNZxHyJtzFYIH9Kgk=;
        b=biek+WCWlgU4YYAygZ2YiEGyPUrwjdvWlCY5ta0GWHIYYaOM1oJN/sX28H9aEGTVY9
         aBFdy7JzPzffPn/bnqpcRtGgJcp3zMAzOw/K2R2+bNPvi2n29qdsUzAglDprqRtfcKdi
         1vN2mw/mS/y/ZlAU1qE3nBNPTxHZqjs/fd1/dT+RQMFjpXJvjgZD2LbJ6JgyGAHBU4+L
         bKFprwyrNHOmUt88HFEyVSt8vI8gwMoInRAJ/Cq2dN8ALVnPmyNQ1IjJ5E/K/pnKoS8U
         1HXW98hoOfo99w53Le4CXn9q4ffDNebdF6Hi/XMmldgPxrcZM7jKhDUq4z9EHBQhfj9z
         ZEyg==
X-Forwarded-Encrypted: i=1; AL+hErFCb1Llij8xrobszRd8RMRTkqwhtqNDno5X48AeaujxBpsiLFvr9D7x/TqQnDlqlS3k3iHnW3+Guw==@kvack.org
X-Gm-Message-State: APuU4Z9zDyyNxjEYKeBBy+RJO3Lr7aX8YcVhBVcxfreNqomek045ccqD
	9Xb4UM6aUC18kDt2kkxD8KYwzSa6nENzup9Jgsb6/3Fy5M3Rw+JfS/igcEvIfaao+sERMt36p2k
	+28ER+1UQLTGwO46PVvq0c0T/bgnSwWY=
X-Gm-Gg: AYBFou1n8HcbChoUX0Sg/UZcU0U/2F24t1BxXlSZahHAM0YkG38u9vnseW/2JmeysgK
	Zg5ZwKTHOpndQibS7R7AaOuH7xwHQEW4NRDqaWpD78yM82OxJa5LM5FnKakkxERzH231rtyMt33
	iMMso1oRmnL7HjaM7vyVxJ0FgVreEE7+o1o+je8M43CP+vHvcULOMCmFTT0qu0tF3l3z0ZJKH8y
	dmLNX5X7KkP09KRK+hE+kmC/m5YIyPuWZqnP/VEXiDt0Ltb9tHcjzuNWtQkNMGHa6EahAgFxkqo
	2AgN7RYouEZ7HQ9nwe0ATCwpDfh3X6BLuo5AePg7VFh9+I5ypqsIyCJrgMJL0IOmnbJgoOZve1U
	q+vOz2EOuH0NV5AS6C3lubVwvEzMIGY39z2NpGm9YNHbSWEAnSgzpSpjNWI5/ywcOikrX32Ykg+
	ytqhhwm1K6JP62vg8VLHeXBPbcUrxLaQHdT/F79QfqREnY/FDmXjGw
X-Received: by 2002:a05:651c:a344:b0:3ab:1207:bd2f with SMTP id
 38308e7fff4ca-3ae096160cdmr7384251fa.11.1794333318160; Tue, 10 Nov 2026
 09:55:18 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110054836.1515030-1-senozhatsky@chromium.org> <20261110054836.1515030-10-senozhatsky@chromium.org>
In-Reply-To: <20261110054836.1515030-10-senozhatsky@chromium.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 10 Nov 2026 10:55:06 -0700
X-Gm-Features: AclHuK_-YWO9U5znFV7lB_KSdDYEIcp41HaPLmU_TnbiEvQvr2rPC4K4fEQZSco
Message-ID: <CAKEwX=PO3frCWftPnbdpoP+in32PFVZ5O9o-7AiNFovwXMB8iA@mail.gmail.com>
Subject: Re: [PATCH v2 09/11] zsmalloc: embed struct zs_handle into zram and
 zswap entries
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Richard Chang <richardycc@google.com>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: e6itmrmi3oszeps8oy4dc859ahn4wu55
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: ED467C0002
X-Rspam-User: 
X-HE-Tag: 1794333319-88767
X-HE-Meta: U2FsdGVkX18SjLrysoELzJOBrDfPSUlwQJPPihFoYpw65a5Yqy2i4k0m3AkxPpKZNEkrDrvulA6s0lOtvB+9kmN/C4iRpBXjrYkltDTzX9n3EZeAstLXWCVWW494V8aqO7odqsuDebL0v+HOURfsmpEWB3G2uEReWv1kfYF/kerNi0CEXv5i3lzKLBFhzs8G1C364XCQNDbzAWLr4xptRw0dt7/VaYQtB7R4cUbi3EG+/jXycz2jbLEd36tgCAxiS2pYMZy6ihoQ8hFwKM/MJiQ/AaCFWb/Pa3zzxfYa/02AEwM0LlKLL/1QvoaKUWu3Lz5NT//rhhn0ShCrCh0rgkxVIjGYD2eXAP1ybLgZ2iMkd1qItyZNt0jYVTEcw+l5FnYX6brZ03KAzvAJ1MvgQRa5w9a1//v0i+gUbcZjllXMO+cpKZt2ujMEo+BdquYqF8jxznXAxF9UqV2h+51SjnAk00mNiwWUbCLsBJdAdCKlVmgFZuRGmC9NfHojHuyXn7U/QO49zPxkzgtmVTSed/Hb4TSlzQCTa4U/ESUkxdGwiY0rL62XQ83nK9d3BBJR12UdfswTRzkye9NWSnJ9Zrk4YO83DRCs6U9lsJ1Y2fJF1ijDXz6PKgWOqAmS1YbmBvrDYtClLQYid4Lnv3/XMEuESoWyDmorJdjtvF7BpgWD7YTwv21WSyvofGNz5CLdxgj6CeKZ2pXk0oGTz61MrgxwLjE4aYYWjJwd0rbZnxieU69HWfKCDjyq9ssoc1dfsLSOVVScah95T0mgfWPo7eBwxFCISNbAcvkl9Uc6ajyo693zt+MAIVDRAyAy0z/ZCsjSage5DS6gnhMXiuwXOxFv4zke8MamKFof5O4WfWqCk0NC+xa0/+zbw6q/xzfrHWK0PVdYXO/jIAY/1b60Or22IFB9/n/BhwgZjqjsxO5AR+mfRTydOBunpoYbZrrT96A1U9UO1kwp4NQt4kH
 EEe8Sq9/
 5RlSHPT5YCQE+crAKMzDJGYES+dSFafikA9uX7LvgnkJfCpyFZ3/uH0EN6vYGbAmL4x80ZINR1h0uBaoW421qcIrO+MKe4KxpiyvgmoI6+49suqgrPtaG+dLkNgOON1E09XhauDv9GOCdwOxnUBbLXE7tw2Ag6CYK7rZ7iyXFowjCf1Cjlaws/ysuD4nJAOg/WmWKn9lyr1Qso5mMUkatF/0SQtvyMXfMeFZpKNPWu+hDnXM/BIEl5/tPuYfkydVINgGPoxnCdASKDNzELyPVK6MFiD95TyjapbVUHiv749+6aQPzhEBW4XhjliD2R3BSHEB6iehcEqe/aw+ksty+F7UvlY+XaBHuHxZnUAJH4wvxe8hESVz7q1IZLUrai7K3M8o6CzLQI6Cqg4RartIUebsnSgcJ9LHMG0Evg2TkuacbeL1bw2/sjBBnEwXq5VE4ZDMcxgbttbXEbfbF4CV27+DqJL21TOBhBmHNKFXiJy5KiEAMhn6T91aYiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 9, 2026 at 10:49=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> zsmalloc allocates an object from handle_cachep for every stored
> object, just to have a stable address which compaction and page
> migration can update when the object moves.  Both zram and zswap
> already have per-entry structures that hold the handle, so we basically
> keep a pointer to a pointer, which costs 8 bytes per stored object,
> slab alloc/free on every store and free, and one more memory load on
> every access.
>
> Make struct zs_handle public and embed it into zram_table_entry and
> zswap_entry (their sizes don't change), so that zsmalloc writes object
> location directly there, and remove handle_cachep.  zs_malloc() now
> takes a handle pointer and returns an error code, zs_free() resets the
> handle.
>
> Since compaction and migration update the handle in place, it must be
> naturally aligned, must not be on the stack (zs_malloc() warns about
> both), must not be copied, and must stay allocated until zs_free() or
> zs_rebind_handle().  zram recompression allocates a new object before
> it frees the old one, so it uses zram->recomp_handle, protected by
> ->dev_lock, and zs_rebind_handle() moves the new object to the slot
> handle.  zram recompression is the only user of zs_rebind_handle().
>
> This saves 8 bytes per stored page, e.g. 2MB per 1GB of swapped out
> 4K pages.  Since handle is per-entry the memory savings scale.
>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

