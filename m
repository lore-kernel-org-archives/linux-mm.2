Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5015BC5DF81
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 01:23:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C9CB6B00A0; Thu, 20 Aug 2026 21:23:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87AD56B00A1; Thu, 20 Aug 2026 21:23:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 744D96B00A2; Thu, 20 Aug 2026 21:23:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 425CE6B00A0
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 21:23:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B5FA1C02A4
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 01:23:28 +0000 (UTC)
X-FDA: 85123528896.24.85E2EDF
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id 254DD140004
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 01:23:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xaa4+CoL;
	spf=pass (imf09.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=qwjhust@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787275406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pWsWssuXjwjvPhFQvlbrp337HR9wzl0754C7O4zlVnE=;
	b=z5cicHfzqiQ2W3Rk7z3ykos27Xu7dYv4ppbVl3Pll+CsT2FSGn4vkWmcS6QfESn647hJKY
	lfgSOnIPaJ72W1Dyux57fWl6p5tAWzoz4Dyku52q/VAwC28AcEJ0qlrfnzdWkLKVNiKv7p
	0KMR94N1PRfEL8hHP+AoGcmnTEl1dBc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787275406;
	b=i3Ltm6yhp/glnKxYwaM++lD89EIbWamBuWa7eijeIdEoPtd9d3ND1v82fiPxK7ONvPFI7g
	Aulu6RqVyZNN+xfqoQGYjkFLh5/vLKhwWoF/my1vHqaud5LQp/vKxxzD62vpaXxpJJT3SB
	Wj0TGCvty/rkEeT0xSN3qZak021WSXc=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xaa4+CoL;
	spf=pass (imf09.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=qwjhust@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5b0115b9e17so500378e87.0
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:23:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787275404; cv=none;
        d=google.com; s=arc-20260327;
        b=Hjb/Mb2kLKXEoSat+HQURKmgdDfEQEl+mtWWKrh25G/1E/5eBqbiFS61SJy0hF0Fbc
         XEOb9u9Vy7/4l0mpBaKh0dTYarkMFGq/II1PE3eSVfnBF5r/C0jTjNLAumXgNDEjrmNW
         j3buz7VY3DZ+iW8/Fjr5iTh3fbSBAs7vmnCOJkodOEFwwP0V1xaZByNMz2HE4GMClBsm
         sEBd1Ty5wJKJ2CBBwEdFn8SU7kl39TaBndQJOk3LPrGmQf6fFPRlxIuIvr04nLjM2PKm
         /fBSrM8NI3KeFZGEWDAFxcb3YgTrHsHJ87DY3sPRNypP5ogNVfFF5TPmp12Vum0OP60z
         x4IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pWsWssuXjwjvPhFQvlbrp337HR9wzl0754C7O4zlVnE=;
        fh=DV3RC7Sa3Gwdd5/g7T+96rhzmGOoT3wOZJpEjz9jMgQ=;
        b=ejg5ggU24cWOABwgNOkxj9l0UgLfh8bK4PQilaq6cd72Mqxkkwdg3FtlAdKSxTeKAO
         gJVavHUD+5Kv7fLlZarDXnDXGRUfJn8q4297ucJqAHMFyECECbs+sDtiFqwCx+L7lEyE
         53Osfkt7GrVdBme+Q2SDZk0h3OS3sbir6Yxq98aO8rIFkpGUQ+yc0wstlPB6g8txjrHn
         VMODBXCaQ+ttpxMU1AGdUu0JFNlJRbSlpBmFl+LdSdNY1CUquRM5q90XmApAd+O5ZYcY
         xuXjTNhgGNBrOUnwtrb/v9vzyhsCpICQ10wLOaymk5nJvIbkDUiNn7XClpxKHWDsI7Sb
         GpgQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787275404; x=1787880204; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pWsWssuXjwjvPhFQvlbrp337HR9wzl0754C7O4zlVnE=;
        b=Xaa4+CoLe6/cCOAhEkYaOEa+tyFZ6Fr19l1AHB55i8ypk3V9uInBLw9b41nalMCMnb
         yJIGfYGN6Jq0SLuMMEyiyOP9m2xw0nIF6MORlAraw+ecenn0B829kjRJUuyXMgRNNJ+9
         aTtpgRUy+DufAGkf0BNgL3UVWbp715Nkl40rmlK0aIACExhtomN2ZC5peTcoVLzvP4QK
         sNkc/b1cp+Nacq5jLvfKGqezb1guscTQcW/l9XqmLp0GC2gYGRTSUtKV3+HneJMNjGZZ
         CIsStlZsoVnuxoEgx+ddoD6V4oPkiHZIN7PWPgsHSYljcXdBMmuepdToWFdM6py6oDkV
         /pQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787275404; x=1787880204;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pWsWssuXjwjvPhFQvlbrp337HR9wzl0754C7O4zlVnE=;
        b=khj4Zf1Q5w3eJvLxaewcZe3Y0qY4ngOSsCh0zQ50pxod5M/rYSGiCPFI2hTKSRXSrl
         pfyJgF0CUZJaWkVqd3outX21iqCcNJA9Rw+mDDJb+8r8aYRkpoBgeS/e5WZiOdKPUqib
         rNjpB6DpPtGOLavP/d9IQLVKUJrRSxMetiMCiOTG45cPjqErZxAVyA5ArzGpFBw0lhBN
         olxURfnmmSbcxSG9wS5vHFTQaUoU0x/k143GlKpp+tPZT5roJCsaj89Fkrab1IV7HwB2
         g3+ZjMpyqs4cfsrTIlPM0DfbB+GVWAcq9f4QZyDS1nY2Ztu0ubJN5CNgZobdPU/HJ+ZO
         kmRA==
X-Forwarded-Encrypted: i=1; AHgh+RoZ0nMkeb1LfMaJ9adKZg6XsnMRRGz1lmfChzq+F+axTLE5j/DnmDGDfQjQPZ9RFVD6Fo6uz9CowA==@kvack.org
X-Gm-Message-State: AFuF++kQNihZhzi51ZfriN4uVfKkj3FlL7ksPOEW431Air5Jhnvl3sja
	cNcIM+BtIAIxZTlJigpAdlYxz307KHEmylw9qQtjnvwwY8x/4laGazPSIsh3F918BH1bxUw3+Cy
	XbBEs4niyADYLrM27j9e4y9X7I2FjXzw=
X-Gm-Gg: AR+sD11RYuUK7738TsVBScNdfRlyi33Th5C+XO1VO1q/yySGIe3fVwKhBUCp0fag+sw
	QNg4hvlFR7vk4WXQofJ6rkGBXgnZyrfJ0RMIEZoZMXAew0ZeSzKRnLUHIzE97+cbJ/ZpdlSb6Yf
	3KJ+v9/J/wUwq5Y6vrQKgxAmWZaw9a/pYXYoNS5syZHq3djZobRS1Mr7R5dtR5vw5PSuHBPkoDt
	IWE56xM1gG6TKqBqFYPT7LUkUVhLsPTIbVe2Ei5m7I10aCRlg6gAyRnTR9dMVT7pc5nkBC94FfX
	otOQVbJCp6S6iYBAPojCdfUU2Ye0B1r+t69tkorn80AWR1HDn7pO6PU7sg==
X-Received: by 2002:ac2:4141:0:b0:5b4:5f6b:d43f with SMTP id
 2adb3069b0e04-5b484224d67mr478198e87.11.1787275404102; Thu, 20 Aug 2026
 18:23:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260820142956.1414337-1-qiwenjie@xiaomi.com> <aocQcaMMU7-rfn3e@casper.infradead.org>
In-Reply-To: <aocQcaMMU7-rfn3e@casper.infradead.org>
From: Wenjie Qi <qwjhust@gmail.com>
Date: Fri, 21 Aug 2026 09:23:12 +0800
X-Gm-Features: AcwNN1VJOsgH1LSKLZ_AMXGaWVJhNJ0llxoWGDBcEyWryT43OMevuzPZaGZ4e2s
Message-ID: <CAGFpFsRarmDScAQxHpCtSZxK5H4WCg4Y=y0hXQLjGT804ZoWkw@mail.gmail.com>
Subject: Re: [PATCH] mm: filemap: tighten dropbehind completion context check
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, jack@suse.cz, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, baohua@kernel.org, 
	Wenjie Qi <qiwenjie@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: zrtsmndic1xqrgxkrafs1id6g8btm74w
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 254DD140004
X-HE-Tag: 1787275405-375471
X-HE-Meta: U2FsdGVkX18oTxDq1SS61ZC2eA5UmRxGP1lRb5ceAU/NIR/KZ4KuMaSrj5dmW9uo2KwOY0q6XcQYXHouqCgzTHIJKiTR0K8IjoSPAeu6hXgujZuyxHp12Qdsw02LyJQCnYn8PmcH5o3fQuy8aXRhFRYEVGbM3MD31SuTm5ksAhj2p6+VjQsKvFJoYgWwYbQ+Er731GalXu35SRQWgmB/kFYzYHEBg2oySaBIh4g96s2J6vxrhFeUr6/jfRPIo3k3shbMK/WqWHsoqk9J9iClCfRp9NhHzw2HryEnFw3fRt8rIj86fcqja4eXUmYPYezaufUve4jXC8YzC2d2qCFhlED83/bFzD/kZ+iyEe8SXxlkxfRRbsXqmxJqh47t31q6tDfIE6ZmdjLg9lvgpBs01AxK3Aq1lfzw4y72BtBsPdP6vddM6r47r6AF7lJFfigLkGD5DYEe9mhYUeUNJCxF7RELNlgHVAxhIv1hFfO6+1ebunx4YiXMEcETeuK29C2rCrVa/0W0CsVZbyWxiIgRlD4fgfq3CFQH+Y78C14qoJZlOLwcYcrhp0j2w2nsYQnxxStPp+EgjtIpIAvn2JgeIhsiPtJiLOHvCzYscL5rScid2MtIBxnAtZ3OF/i+vyYH2j3FKWg/V7r+xLuH6kDn9NfG56wxwLFLFjLL0M0zAit/c8oHcnWWkcfnr9EFERKbRG3IzVtFQFAVUhr90ny0BY7dr0WttIMEUosWgqU/VXtCh/v8inUXtjLFz6h8ElsJIQ+QoQI4F2h3ORnm/4nbrJGYFpBce9p1OUDDCHI5EPVdxju3091AMXaOu7TlcHqIUmsv4byWjTm677IZSC7dRGnxdCVA4AjY4P8UZLYaSSNDZrKFPvjtg4A+0YaPt9KomzLBQ6p9KvvY9CTVI06f5Brk7fmELjkwI4x6dp7UcGRjQumre1AMPXzQu0v3I07zDMGBWEw+AdYiq3WZ4RV
 Y9g4I81E
 k9IS/x4+J2qr4szmplBmNkwch9S8TC5PMRk0LIf0+K5BdD7pZukBCgkfNZ4bu9BmwMTn1oLkW/5JPcZE72lCM95w5aOf85fjs9IVzDjPfVfkw+pru8UdXC3+uG2giZkQy9b4xUkFQl3F/4BQmr/1MhVMzMISxmF9WBy6SliHb7LtUz+k2tifmnHeQn2tvG84L3DXnTpSl5/LIThs311khrSUeJFVtIvH5qttu7bWqhh4OXDq8U657EX1ae3KOkrucMdQ7MqPpkx9MmQlz2zdVPsdFT55AtyYuzMTIBwNZCXpRzsb3cIjIh+vmsUB12sPJUn006DWZ7j5ZQevpdfPZyFGcJF6gmJwM6hd9bVm74f8n5/tIid0xt2xCIdwTtklJQqFqKKt1trxEJtO3S2WTfkIWSOtirHDsIRMrTNjV+qoyFXDAHaYwMaYbJKSzk+ApJcAO55wLpwT+wdHUfUGFPOuZncgliy7G0I0ND9/ae2MSvZ52yO0xs0wVjnsy8S61s1Lm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is based on code examination; I have not reproduced it in
  folio_end_dropbehind().
  There is an analogous EROFS report where bio completion ran under an RCU
  read-side critical section and hit a sleeping-function warning even thoug=
h
  in_atomic() and preempt_count were both zero:

  https://lore.kernel.org/r/20230621220848.3379029-1-dhavale@google.com

  That is not a reproducer for this path, but it shows why task context alo=
ne
  does not establish that sleeping is safe. Here, folio_unmap_invalidate() =
can
  reach unmap_mapping_folio(), which takes mapping->i_mmap_rwsem through
  i_mmap_lock_read(). I noticed the mismatch while comparing this path with
  the stricter bio_in_atomic() check used by the block dropbehind work.

On Thu, Aug 20, 2026 at 10:34=E2=80=AFPM Matthew Wilcox <willy@infradead.or=
g> wrote:
>
> On Thu, Aug 20, 2026 at 10:29:56PM +0800, Wenjie Qi wrote:
> > folio_end_dropbehind() uses in_task() to keep folio invalidation out of
> > interrupt context. Task context alone is not sufficient: preemption can
> > still be disabled, or the task can be in a preemptible RCU read-side
> > critical section, while filemap_end_dropbehind() may reach
> > folio_unmap_invalidate() and sleep.
> >
> > Use the established conservative three-part atomic-context test: reject
> > preemptible RCU read-side sections, reject configurations without
> > PREEMPT_COUNT, and otherwise require a preemptible context. Unsafe
> > completions retain the existing best-effort behavior and skip invalidat=
ion.
>
> Have you seen this happen in practice, or is this based on code
> examination?

