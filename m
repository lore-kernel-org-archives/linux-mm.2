Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A59FC54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 15:50:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BD616B009B; Fri, 31 Jul 2026 11:50:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26E1B6B009D; Fri, 31 Jul 2026 11:50:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15D596B009E; Fri, 31 Jul 2026 11:50:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0B7D6B009B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 11:50:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 78837A199A
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 15:50:23 +0000 (UTC)
X-FDA: 85049508726.07.DFEB486
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf03.hostedemail.com (Postfix) with ESMTP id 744FC20007
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 15:50:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PjyDjsL5;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of greatdanerrrr@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=greatdanerrrr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785513021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ah8Z7zZb2aUzlRFQ3wZW7Sv1LOKIqAHqegwScZgE+k=;
	b=v+nrCakN/iPMiYPyNFCyM8nDXEZ9+Pd7uIvLU65nh8jc8vF5nq/zEiMBKa1nq4hBCFzhR/
	/1fT0xd0F53WF/RLiMg7I5YK2FQ/vtYe60AVPArimzZrvhvIVuC4iqhnVd5fD5I6bXoSkA
	Mcgl7ynVMlh4xolhDM/s6UkJXBt3C0c=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PjyDjsL5;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of greatdanerrrr@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=greatdanerrrr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785513021;
	b=UnbsP/OmTULbvKYczsDFxoJaRd2SCtw3DPt1AHnAvLkzTY/ekV83E0v5xtNvU/QabkmKfH
	YbUcvjPbJss5pJuHxFFNh8c/P+agV8Zb1fLjVEqWU3C7p4Vh80Jfi5K/SJIkFyxgPTcBkq
	63O/A0RL9yk/N8H7ei2FnraJA0WyBIs=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c1f5208b38dso212027066b.0
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:50:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785513020; cv=none;
        d=google.com; s=arc-20260327;
        b=Qn9HLBbf157R0h/V//+PTK10dc/jEeVhq5hc6DkUDRedqjAhcHZ63abijKqhKke727
         XntrU+EPu0IGsMQeA3gn/lydUWjuvI2W4sAOsrxx5J4J9KGoSv0DS3HISplivFP9jC1l
         xvy2otnpmRr72LR/gvGhJ5KoqP/ueeLFqQhu7rSwW+GH3o39Tj0y5Y6fOoCJKx/YPSCc
         b0bk0TjQbkAvECPtPQWNWL6IZXB4VB5xiBmi2pN87Woxb3wFKF5gCaL8PZU5MuDD1CxC
         +jwg7CqxzrOE3Xz79uxxjmlVhnbMjOxy3SzYpMeWdEngzMfrkF97OLGw03aoKEhbUvd+
         PmCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0ah8Z7zZb2aUzlRFQ3wZW7Sv1LOKIqAHqegwScZgE+k=;
        fh=xEs5vZX9mh4svYoBz8T+Nu+8XCla+I/UP9t2LB8+we8=;
        b=N3yyAivWqg8d8OU/SbOOF++Nk7E1h7Nynm0rEgoAaF7YyZHuuaHjzN8IKXaKmg0GgM
         cvaRKOd0k/PuGJ5gONqsYLW0VTcOOqi8EEESbYByAyx8XfGU5L5+6G+QZGhv9deDpKw1
         a7OHZzqiTHnE2dfiylqcqM4CX1i3mERQi/ezZWf1RXx2bxzOgA7HvaJ9X+CttiJtmUkS
         /sEa9V7WyRa5fOthVvKpOdpXEDAqqc1Ma74vtGveulzFmUMsdHhW5E8+kEaP48wTzFOl
         eqODcjY+pI+iKwtldaKxERpIexG0G0PkqHDT9alLQzI4NgGBpdEQ7cV7aONwhK91cxF9
         SmGA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785513020; x=1786117820; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0ah8Z7zZb2aUzlRFQ3wZW7Sv1LOKIqAHqegwScZgE+k=;
        b=PjyDjsL5BlPQ03k9/Rl2hD3iVXBC/uZtqA0rPnG9yeqiiWh0Jq58IPjXhcpkF56mnk
         KzkfqjEKDFuuX2fHCH5eoSughf0+507OazbYSsn1AtF3ZrexdplbpU7i9FSpYZE5t5mh
         LVQnQTBX7yTBwWd3mUHT4hpECft+FzB9p24LSthu5vsq0HTpVc4ff49FePDKeckKpWDI
         w0bnvJelUocWGmY6IG5fk5WfLUhjVA5jR3okYBDcJbeV4+9eF1fazuOTDO4gBut9t5U5
         Df43KXcIIJ8y9qRoWwaKSvvPtq+TXb0vzzXPvYwY4A+tEBwl1h0DY2czGHqjR1diIoP6
         KGBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785513020; x=1786117820;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0ah8Z7zZb2aUzlRFQ3wZW7Sv1LOKIqAHqegwScZgE+k=;
        b=pGymQFKNsEUBEMUSoLrBS0ajtZOw895pOppi8mEtno5DeyGbmdrTUw5cN65zinZwd1
         fYHWu1ZA2vV+Vszs19Mv1r8LBzaB0Vpj5FyecRgoidD3l2etfs74WXSjQCWK3X+ty32E
         2Showh9SiAJasxk75uAcEEIIN/T3CxVhpvRPb7L3e2g9h13/MZKlsWbJkzK53ivKSRXY
         R6hadBlvcfLN1JgsIuTUTKKqCRNO9D3DjId7AbWXEBizFZCcs8gzssYPHWTJJb52I9bM
         qh1HdOrCDOkP8viA2ac5PVgdMC+col1eOZfC5+h19iv78l3+JxM+VXEWYR/vpIbLpCIK
         ySpQ==
X-Forwarded-Encrypted: i=1; AHgh+Roy9wf+1qHUqkU1yFkG5pyc9cprb1FU2U9dX3h7/3kcimDSeU0iA2wvzYevlmFjAxqGbwJGI/S7BA==@kvack.org
X-Gm-Message-State: AOJu0YwTHBqupHOsubIkAxU/LpVkYrZkbH9/CO4FZrkZuXpjWPxrteqi
	TgrVUicCOyUZ+xCPK+5fagTrxMvOXF+hRt4lAEQuKEszHrVYc4ahMtjUiufxl9wkHXuA3vWKMkh
	JtpxPX9mLS+1SPJ5t93wx1FVaNMv1TW4=
X-Gm-Gg: AR+sD10qFpLQl45JO7byXoURhVTG1vnXDTmJy01qFxo1jOpzznH3pES5phdt/GkHE+P
	jD8xSli5pBhDMn5VWgt5PwdRFl40jdkwGNEAOI2vkpMWNaW6iwnUhdNfcMbpXK0sfmWmftqwIVh
	SCRpCpouNffo8hDhouHuinwm1YmGc/OHaBme6W0jMYIgF+UGWxWSVpzh6Piojv8gh5Ktr1T5avx
	kSQxOZvBaOqDsOGqzLCAXAnFUAeMyitrMxjmjV4fosuDA1OO/gucpM1s56M8aCSBGTNc3bDpasH
	AKXCj6SyR86g+I7JGV/834lVWDbI7WqO5QtmlgGiO9dlzS753fId+AveUSALwqcYNxnQCmNLeEk
	jbQHpke8uJutT+IEz5wFOvbLPnjqgqT5fsQ==
X-Received: by 2002:a17:906:5ad7:b0:c1f:6f31:2880 with SMTP id
 a640c23a62f3a-c1fe82297c7mr6067766b.50.1785513019508; Fri, 31 Jul 2026
 08:50:19 -0700 (PDT)
MIME-Version: 1.0
References: <CAAzp_c6=Ka7q4pZtp_mWB2m_8MK9=z6OZgLiFoXJNTey0soGfw@mail.gmail.com>
In-Reply-To: <CAAzp_c6=Ka7q4pZtp_mWB2m_8MK9=z6OZgLiFoXJNTey0soGfw@mail.gmail.com>
From: dane phillips <greatdanerrrr@gmail.com>
Date: Fri, 31 Jul 2026 08:50:07 -0700
X-Gm-Features: AUfX_myX_1GrFlGQ7SpxB9_HmG2eaEqZo83Ex80VhXNy80yaz_cQ8LH1Pn-TQ8k
Message-ID: <CAAzp_c7vP1om1eHrwhXLZdqURo6vhu9S0J0b3HM8z7hFzmaRpQ@mail.gmail.com>
Subject: Re: KMSAN: use-after-free in sw842_decompress (zswap writeback)
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 744FC20007
X-Stat-Signature: wfz1kmsrydnw6u7osek81ch4y31sq3tb
X-HE-Tag: 1785513021-646678
X-HE-Meta: U2FsdGVkX18CMXTJpBQ9o0W+ymwwCTvTf/OlhShToKy1g2WziKRnFqbB6guTlxgjg/FVgVrc5mMgsxAHhul3l/WblOU5uR0lmlB3GJIO0zh+VWm4kLA1yMtSbTomUc15iGVtWZhah3OPJZroT3LX2NHzfAglanDrnlDULIqPN3XPDqddQxVa9h88HIfRbgA5ODshpEfrzQjF4Urml7n9FpOm79rVUqGWyocwHSP8CiL7uUU0o6H06EcHjuV67WwDFcbNpLA1I6wlzgAcOJTKsZVFD7reNjbvAcS9dFGnGVBR+7cdwn2whVtSAlY/7E46riQHhQj7XWDhZTTktfKb5Nj0ih3fVGWZF9XGBiTmz9wij+pYyVIo0zYQh20ZrumjWRX6cShgIydHw729Zy8MesW+XmphIpc3xSxB1jRPz1ByGUUbAQpWTz0XnZALs/5xTjieYCw3NPng9KWTFTtF+8s21qIK3vg4L6KT7pUezFz2IEvHX7YS0NWhkdWNO03oOBjepYS+cepHtz5tpvbIcipbL5Uel7qOvPOpROeOGdtUBOXdJrDfVizdKXP8kSlwe9TgAbfSPubRiWCkbOXqZ71+TQJx5d1ZTkQ7mgySPvKNAkhI6gJI7OFSMRJR+9THU7PtpqHcHoUp1LK1qOVJ6jrh6VHixl4y7sKqqaYi12LkRtDu7+uRyFQizCON5xpG9csW9jj4IWcPZiOpvys/+56sQzc/UQ+U8UwnfcdAGE6CVbFIfI479Kf5iKndCyCb4nr2GOgCkhDu10gfs4xE3bHlbeFCb0b624tNxBKCbX89mZRa/7SHu3TeYbqkY99CoB0EuJsvXr7a4U06MQciu3EDy+aEXN8OQaDFRBApvMM0y4KRndF4N1LFCOBoMKtqyW2oPvTnLtDD7Nzk3ZFKRTFGC/DrQnUJ50Sv38S0Tk7f21307KzTgY8wzN/xND2XSXiLn/G8Db48w6VhkYH
 nUJbYy1P
 /7IHqqEPZ306tKMlU5QkNSw78iVliVwLdGqDDwnXafnq6eZVgWeJQpIbm2stZD6rGwNUKNG0lC2c8zrCt+EdyO7tAjwZe6abkzSB6VwsEBhKbLt83BrBKAT5DCPd0M83f0UlP10xZ1xVGCyTlOLmEngTGZQGuuCxlwqIrZ5u/e7LdCe+PxZxJ2B3rFUpbZAQu31rUHctExp6qjQy2a1zA3hW2pjgNifS+fBg72N+S5EilBA6wLaNunMVoUvb6X735EdJ04UKb2LYQcDCEdiqN9/9RTNwMQGRns+v8EsuTzOcQ/8oHX4CtNW7H4EMDo6lzdU/rrNgDWRM49fUVZ+IVNjYyv8R4o84m3a5+5Q1DWasip7I7AoVt4FWWvRjtmOj8vbnlI38DZx/y4llTqIvNAvcLRlpqJXjoBkXkBIQY+SmvMmlAaQm37gi3YwLN8Ep/GGhiNZkIZRcD2JjEVCJ9k84xQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I got the mechanism wrong in my first mail, correcting before anyone
wastes time on it.

I read the "Uninit was created at" chain as causal. It isn't. That
chain just says where the page had been before the allocator handed
it back out. exit_mmap has nothing to do with it and there's no race
with process exit.

The poison is in the compressed input, not in a swapped-out page:

  next_bits+0xac2         lib/842/842_decompress.c:118
  sw842_decompress+0x1a6  lib/842/842_decompress.c:297
  sw842_decompress+0x11c8 lib/842/842_decompress.c:303

297 is the opcode fetch, 303 uses it.

What I think is happening: zpool_obj_read_begin() copies exactly
entry->length bytes into acomp_ctx->buffer, which is kmalloc'd and
never zeroed, and sw842_decompress reads past entry->length into
whatever was there before. next_bits() does full 8-byte loads while
p->ilen >=3D 8, so entry->length not being a multiple of 8 looks like
the trigger.

So the subject should be something like "KMSAN: uninit-value in
sw842_decompress, over-read of compressed input past entry->length"
rather than use-after-free.

Testing that now with kzalloc_node() for the buffer, plus a sweep of
compressed lengths across residues mod 8. Also rerunning with lzo,
zstd and deflate to see whether this is lib/842 or zswap's bounce
buffer.

Two things I should have mentioned the first time: the kernel was
already tainted W from an unrelated get_xsave_addr warning earlier in
that boot, and the tree was 503 commits past 7.2.0-rc4. I'll redo it
clean on mainline.

More once I have something.

Dane

On Thu, Jul 30, 2026 at 11:20=E2=80=AFAM dane phillips <greatdanerrrr@gmail=
.com> wrote:
>
> Hi,
>
> I am running syzkaller on commit 3dab139d4795 and it
> reported the use-after-free below. The issue occurs when zswap
> writeback decompresses a page that has already been freed by
> process exit.
>
> Kernel version: 7.2.0-rc4-00503-g3dab139d4795
> Config: CONFIG_KMSAN=3Dy, CONFIG_ZSWAP=3Dy, CONFIG_CRYPTO_842=3Dy
>
> The bug manifests in sw842_decompress accessing memory that was
> freed in exit_mmap, while the shrinker is still walking the zswap
> pool.
>
> BUG: KMSAN: use-after-free in sw842_decompress+0x11c8/0x1750
> lib/842/842_decompress.c:303
>  sw842_decompress+0x11c8/0x1750 lib/842/842_decompress.c:303
>  crypto842_sdecompress+0x46/0x60 crypto/842.c:53
>  scomp_acomp_comp_decomp+0xa49/0x1120 include/crypto/internal/scompress.h=
:-1
>  scomp_acomp_decompress+0x30/0x40 crypto/scompress.c:283
>  crypto_acomp_decompress+0x5c4/0xe50 crypto/acompress.c:297
>  zswap_decompress+0x4ba/0xcc0 mm/zswap.c:952
>  zswap_writeback_entry mm/zswap.c:1032 [inline]
>  shrink_memcg_cb+0x78f/0xda0 mm/zswap.c:1147
>  __list_lru_walk_one+0x49a/0xde0 mm/list_lru.c:362
>  list_lru_walk_one+0x5c/0x70 mm/list_lru.c:399
>  list_lru_shrink_walk include/linux/list_lru.h:332 [inline]
>  zswap_shrinker_scan+0x11f/0x290 mm/zswap.c:1181
>  do_shrink_slab+0x736/0x1460 mm/shrinker.c:443
>  shrink_slab_memcg mm/shrinker.c:560 [inline]
>  shrink_slab+0xb70/0x14c0 mm/shrinker.c:638
>  shrink_one+0x560/0xc10 mm/vmscan.c:5026
>  shrink_many mm/vmscan.c:5087 [inline]
>  lru_gen_shrink_node mm/vmscan.c:5165 [inline]
>  shrink_node+0x47a5/0x5b70 mm/vmscan.c:6154
>  kswapd_shrink_node mm/vmscan.c:7008 [inline]
>  balance_pgdat mm/vmscan.c:7186 [inline]
>  kswapd+0x3029/0x5a50 mm/vmscan.c:7462
>  kthread+0x53f/0x600 kernel/kthread.c:436
>  ret_from_fork+0x20f/0x8d0 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Uninit was stored to memory at:
>  sw842_decompress+0x11c1/0x1750 lib/842/842_decompress.c:303
>  crypto842_sdecompress+0x46/0x60 crypto/842.c:53
>  scomp_acomp_comp_decomp+0xa49/0x1120 include/crypto/internal/scompress.h=
:-1
>  scomp_acomp_decompress+0x30/0x40 crypto/scompress.c:283
>  crypto_acomp_decompress+0x5c4/0xe50 crypto/acompress.c:297
>  zswap_decompress+0x4ba/0xcc0 mm/zswap.c:952
>  zswap_writeback_entry mm/zswap.c:1032 [inline]
>  shrink_memcg_cb+0x78f/0xda0 mm/zswap.c:1147
>  __list_lru_walk_one+0x49a/0xde0 mm/list_lru.c:362
>  list_lru_walk_one+0x5c/0x70 mm/list_lru.c:399
>  list_lru_shrink_walk include/linux/list_lru.h:332 [inline]
>  zswap_shrinker_scan+0x11f/0x290 mm/zswap.c:1181
>  do_shrink_slab+0x736/0x1460 mm/shrinker.c:443
>  shrink_slab_memcg mm/shrinker.c:560 [inline]
>  shrink_slab+0xb70/0x14c0 mm/shrinker.c:638
>  shrink_one+0x560/0xc10 mm/vmscan.c:5026
>  shrink_many mm/vmscan.c:5087 [inline]
>  lru_gen_shrink_node mm/vmscan.c:5165 [inline]
>  shrink_node+0x47a5/0x5b70 mm/vmscan.c:6154
>  kswapd_shrink_node mm/vmscan.c:7008 [inline]
>  balance_pgdat mm/vmscan.c:7186 [inline]
>  kswapd+0x3029/0x5a50 mm/vmscan.c:7462
>  kthread+0x53f/0x600 kernel/kthread.c:436
>  ret_from_fork+0x20f/0x8d0 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Uninit was stored to memory at:
>  next_bits+0xac2/0xda0 lib/842/842_decompress.c:118
>  sw842_decompress+0x1a6/0x1750 lib/842/842_decompress.c:297
>  crypto842_sdecompress+0x46/0x60 crypto/842.c:53
>  scomp_acomp_comp_decomp+0xa49/0x1120 include/crypto/internal/scompress.h=
:-1
>  scomp_acomp_decompress+0x30/0x40 crypto/scompress.c:283
>  crypto_acomp_decompress+0x5c4/0xe50 crypto/acompress.c:297
>  zswap_decompress+0x4ba/0xcc0 mm/zswap.c:952
>  zswap_writeback_entry mm/zswap.c:1032 [inline]
>  shrink_memcg_cb+0x78f/0xda0 mm/zswap.c:1147
>  __list_lru_walk_one+0x49a/0xde0 mm/list_lru.c:362
>  list_lru_walk_one+0x5c/0x70 mm/list_lru.c:399
>  list_lru_shrink_walk include/linux/list_lru.h:332 [inline]
>  zswap_shrinker_scan+0x11f/0x290 mm/zswap.c:1181
>  do_shrink_slab+0x736/0x1460 mm/shrinker.c:443
>  shrink_slab_memcg mm/shrinker.c:560 [inline]
>  shrink_slab+0xb70/0x14c0 mm/shrinker.c:638
>  shrink_one+0x560/0xc10 mm/vmscan.c:5026
>  shrink_many mm/vmscan.c:5087 [inline]
>  lru_gen_shrink_node mm/vmscan.c:5165 [inline]
>  shrink_node+0x47a5/0x5b70 mm/vmscan.c:6154
>  kswapd_shrink_node mm/vmscan.c:7008 [inline]
>  balance_pgdat mm/vmscan.c:7186 [inline]
>  kswapd+0x3029/0x5a50 mm/vmscan.c:7462
>  kthread+0x53f/0x600 kernel/kthread.c:436
>  ret_from_fork+0x20f/0x8d0 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Uninit was created at:
>  __free_pages_prepare mm/page_alloc.c:1327 [inline]
>  free_unref_folios+0x280/0x2880 mm/page_alloc.c:3011
>  folios_put_refs+0xb2e/0xba0 mm/swap.c:1057
>  free_pages_and_swap_cache+0x804/0x840 mm/swap_state.c:589
>  __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
>  tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
>  tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
>  tlb_flush_mmu+0x92b/0xe90 mm/mmu_gather.c:424
>  zap_pte_range mm/memory.c:1973 [inline]
>  zap_pmd_range mm/memory.c:2020 [inline]
>  zap_pud_range mm/memory.c:2048 [inline]
>  zap_p4d_range mm/memory.c:2069 [inline]
>  __zap_vma_range+0x763f/0x9340 mm/memory.c:2109
>  unmap_vmas+0x440/0x800 mm/memory.c:2178
>  exit_mmap+0x27c/0xac0 mm/mmap.c:1300
>  __mmput+0x134/0x650 kernel/fork.c:1187
>  mmput+0x74/0x90 kernel/fork.c:1210
>  exit_mm+0x2b1/0x4b0 kernel/exit.c:615
>  do_exit+0x9a9/0x3c30 kernel/exit.c:997
>  do_group_exit+0x258/0x390 kernel/exit.c:1152
>  __do_sys_exit_group kernel/exit.c:1163 [inline]
>  __se_sys_exit_group kernel/exit.c:1161 [inline]
>  __x64_sys_exit_group+0x35/0x40 kernel/exit.c:1161
>  x64_sys_call+0x3e6d/0x3ea0 arch/x86/include/generated/asm/syscalls_64.h:=
232
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15d/0x3c0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> CPU: 0 UID: 0 PID: 81 Comm: kswapd0 Tainted: G        W
> 7.2.0-rc4-00503-g3dab139d4795 #9 PREEMPT(lazy)
> Tainted: [W]=3DWARN
> Hardware name: QEMU Ubuntu 26.04 PC (i440FX + PIIX, 1996), BIOS
> 1.17.0-debian-1.17.0-1ubuntu1 04/01/2014
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>
>
>
> The full syzkaller log is available if needed.  I do not yet have a
> reliable reproducer.
>
> Thanks,
>
> Dane Phillips

