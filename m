Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FD87C982D8
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 22:39:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 128156B00A0; Sun, 20 Sep 2026 18:39:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DBB96B00C1; Sun, 20 Sep 2026 18:39:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F32F46B00DD; Sun, 20 Sep 2026 18:39:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B339C6B00D9
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 18:39:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 231A31C1BEE
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 22:39:25 +0000 (UTC)
X-FDA: 85235608290.07.93BB743
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3580340004
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 22:39:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hKFZfZYo;
	spf=pass (imf11.hostedemail.com: domain of nsd.project.dev@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=nsd.project.dev@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789943963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KpJKV9oL0BlyVbCMHmeY3GdCnj0W6bhLkcjPYkX4BAw=;
	b=QHl7sipFyY6SjqR6nnpswUQS3XGzwJ8uPLRL1wug3/ZZ05NWTgil1TCZt56AU2vchpeXct
	52FoZvNW+Y1DsOxbtf1Kngd4+Ula8t4FUQ/uVLYI0w6/1UF/hxOxKCYjVRWKx/oNHGaBOA
	ConHL0Bkcy20mFzHktbyFMSZqd7Y6/k=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789943963;
	b=6FlLY35DVzr3ibXx9in0C82mwRaWHcuAwhfKjVfDmI6x97JTupDz/t8isAmj4s6lBGm/9m
	lzmxL0qCUSjahetIjB3OwbWey6tD59cQM5S5JZhOcAfaLgiODfv/CuaQ6EcgJ6nvF7+ye9
	/Dq7rhpDYzanizZT7ctNXnmphrWUTJ0=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hKFZfZYo;
	spf=pass (imf11.hostedemail.com: domain of nsd.project.dev@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=nsd.project.dev@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6a9ac6aa620so4361091a12.1
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:39:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789943961; cv=none;
        d=google.com; s=arc-20260327;
        b=V0bf1vA7gdY+MRHDaC6GManZ5G9NN0BIRRZbV2IdBTi/tva6uZepFbqbjo9VOAQHXi
         OdasFVl4cCpEkUQ83UEyT0ZghNkbEl5UhFMhi/js3N+sIC/Q5GgW0IuKmgy0FqxPzDgr
         RMPaajdfEyZSSrzchW1XaXTazH4v//caJaCXUmVAZBaL8aMLiszOg+Kyais/g6LlYSGC
         9LVnq/rsvuj7neq16q/RVNIp1f/5yiNNDN8oUdCSsOnw635kaAX/PDWN3e6+pQe5VK1o
         tw8Bod/OOi6eqF3sWq61b/C7CV4QhBoF0RQyeoaBsKwz/vJADvi/RIhLOCb38xd34RnR
         pQdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:dkim-signature;
        bh=KpJKV9oL0BlyVbCMHmeY3GdCnj0W6bhLkcjPYkX4BAw=;
        fh=+nwss2xFrET5TaTBl3EabMw7Z83dbMTx/JcdWZ3ZDfk=;
        b=AinHMH/bLZap2836q/53O3+SEhjWuvNWHqCwFBZP1Zj010fNK1RsR59jNZOWVtMjzg
         IbAcyW6+05GxUA3FR8Me0XHYWMwEjEdWlwU6P5G7r+wgrjq2dLnT5zedKneAhBgJ41PQ
         AFFBd3VbxW0pvPcqqesHbfHkHldSzoeizwbi62cjLlOdGQr7HTe0b7qfvKOJwMKiElBI
         dpicFPUnAdF5GhhNYvMYQoc1133HqKaRjRw7aIkCInx8A6ubKY/AWgBdq36G+kr25+z0
         mOoLJkOneQmFIysMM1+Flp1jfsqe5nuSRTlGwwGPxorOFSibrSBszNKeEV7fcuC32Bab
         XtJQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789943961; x=1790548761; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=KpJKV9oL0BlyVbCMHmeY3GdCnj0W6bhLkcjPYkX4BAw=;
        b=hKFZfZYobx87wEom8OLg5eou9a6Lu6UWleOUJkWuGaCOMCmgspHdN+KXLXp28Mfoa9
         bOrkZ+/W/yEIFVomtXvXe91OTGnAP4WCKIFk69yuYb6O6pEJXeVm3Fi16BNoO231TEK4
         +pntZ+amnL4a4oyrzr+XX0YPyqB5sZICBiovH0ZD8pTiE7TquJyAYSNzELFTZwsF/VHf
         HgoLP9xdXDCj6jyu6STNReGuA2zhQLzfPGNp9PBz6m0JoF/t66NQSNZXtpYmcFZEAcRd
         fDDVt2dNJMJEu72H7tc3S6ifBXWk8gn5lx9V87acfgcN6s12djrgF8fnhwsEsn0M6ywq
         9rnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789943961; x=1790548761;
        h=content-type:cc:to:subject:message-id:date:from:references
         :in-reply-to:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=KpJKV9oL0BlyVbCMHmeY3GdCnj0W6bhLkcjPYkX4BAw=;
        b=ZnO+QizvImMNm0hfmOmn4ZzbM+g3IDcGUxPOEjrV92nydyrT88oXsJAizokWqu6Jeu
         FcTKH5RPpK0KRERyP+076E1UA9j+aZkCBik5j5/8Vqp0X4cB5or71y+wL+FgxMfLQ6Rt
         CueaO2GXa9V/mWPotMOZYaOeDrG9LAsVY8CdVFeqLV0vBkF3t0BHnkb+us8dDlULS45J
         noPtuwzPj6Wwlq0ABYaAsQwzHRDS/9Pm31XjksjpJYgvBeSsTLTCdJEqTmxVw5kA6DKl
         q/jtRxlNX8DlMHo7qjNJlGbfxMbBllzG8N24duGQ5gytDZzBoWvkSrlAjy7BuEchOKjt
         z8yg==
X-Forwarded-Encrypted: i=1; AKwUvBzDwLm5Rc1FJR9ALm/+wyUW402q3MHjDnDluyeZVNOvQXN8mbZ4fdRBbxThoFgfTKD2GC+2nOYnsA==@kvack.org
X-Gm-Message-State: AFuF++nItNf7aUsJN5CaaEzQdmvy8nP05t3WQa+bpUNHMF5W2jr23W8q
	EIKZ0SmYTNKXBL1aQ9MpAyaQpE7TCHtMDK1aAvX0NSbqq6iXO6Tqin1kE/rFY0NfnB3hWlXpzDO
	+BVX4hX4eiVf5TYiO6amLLPpU0xb2myg=
X-Gm-Gg: AYBFou3eePF7GOankDOJc0UZrlx39rPJmHlppfkPPFC+I6PUfmjBt/d+ZFnynjaU7Na
	aRukHD0btnsZqqYjmc9lHpXSiDIoQk32h7l6Kv92zdlnrLPuvYMK+FoSSVvYThVFGAqitGEBEuc
	LVUWEgKvzhy/XPYrsKPD468+WKtcRvUBsTK2p73xMOlOYHe17coJCiIoxScZ/P4OmOJZCQPDO0h
	M4JxZGCaSdrwT5OVql04lKWNXIpTzqheyxnWtL4FI5Xsdo7VVlftS5Hr320c+mstzesvSbVhpZ+
	gzvTlAF55vC+7dgZg2m+b5r5DNgCeSUEaksVYcl29vFUsmYhWvV2/UWxog==
MIME-Version: 1.0
X-Received: by 2002:a17:907:3ea4:b0:c29:6bf0:eb73 with SMTP id
 a640c23a62f3a-c29f5228f5fmr1121776566b.1.1789943961258; Sun, 20 Sep 2026
 15:39:21 -0700 (PDT)
Received: from 292895732794 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 20 Sep 2026 15:39:20 -0700
Received: from 292895732794 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 20 Sep 2026 15:39:20 -0700
In-Reply-To: <<o5ihhfa252cjfspqlag65xhnmehz3a5feyclmlyy4xlrcmceck@njmhyu7oom3d>>
References: <20260725182628.221603-1-nsd.project.dev@gmail.com>
 <CAFLp9PEQQVuDpJPwrNvLN1-u3w3TMwZPUUrf0+rOBrvDjBBf1A@mail.gmail.com>
 <anlByPDZmvEhWeXI@casper.infradead.org> <ffcij36vnozf3rginqd2opd2dwqyki7xhtdo4veuty734hhgba@utjav2k263o6>
 <nsd.1787001235.35928@mail.gmail.com> <w7vte4itudtkw2yf4vbmuofiumfffmp2y52dpu2bqvqtdgjvpd@5femyiozss3e>
 <CAFLp9PGkVYZcQT5qAx-RKFOF-urZ92m417zpAeF7ZQempbS1HQ@mail.gmail.com> <o5ihhfa252cjfspqlag65xhnmehz3a5feyclmlyy4xlrcmceck@njmhyu7oom3d>
From: =?UTF-8?B?YXloYW4gYXlkxLFu?= <nsd.project.dev@gmail.com>
Date: Sun, 20 Sep 2026 15:39:20 -0700
X-Gm-Features: AcwNN1Uij5l810gjQSoNTyE4DLMXLaa4cmXOi_eWZ3R4ZbTL0QkRJm-CP3x26yU
Message-ID: <CAFLp9PF+6KUY7ZAGQZ_X9AN4VYbkdW_aDk1QSth3ZAVVqLTqsQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Neural Storage Driver - learning page cache prefetcher
To: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3580340004
X-Stat-Signature: 3jkrb1myu3wa3m8fmmgzuh3bnxamtnp3
X-Rspam-User: 
X-HE-Tag: 1789943963-90105
X-HE-Meta: U2FsdGVkX19NXv3nkWmiIJGQTEiThCYd7Z+iHUzZyjLUxAb/KPznh2XYnYfF3ijqAkP8ErwzE3aRa1U27kIUlPfslXzd2JTdV6LPDJ9NSNRwUPgkFS1g5XbIHefaWtdSjIp0yAVTHdk9kxd9iasJW76sw2q75gIm5s6JYjrbCeqEMt1U0bMnYxVcEp907hiNmocIpoBqJlRSqoJv9tpJJUXxz7CdOzsXHlhW1mIn46+XjqUQj/lYIjOT+P3Kj0NZ/9RKbSbXE1iJ7/WacmERXClx8FEjkt6Nxr7p6DpsUoaOLwD1oFsJPpnRxd1N/Ffw40KtrsUlTLF0d46KdZhpIT6wpHsBl9OpObQMCWu10WLZZR+hEny1E2hBojacejS60Tup1qVHn0YK5YiiqwiJkksUiNNgQAZyxqfYdqUf08PXrWwaLHMH5qWa9FyMkCdYeYyIwnlTb4KgFL799wF6uAM9aLXEN5V7JIdbuaBkftk1G0dxn777LTQeY7RElcAvJ2pT4kHt4UzKZvEt/G49l0eySQRgRmxTirUWB7Q4XKSDYZndpcVYus/AcLT9gySYhScIHq5Yt+B1+w1mx4xcc2syM5SJu+iuHYxYF1QiMt69ZAnv1jlpaN2HwPTiMAwXlCUxSb4Qt+mlnlV5j3kl+bqpG/K+xb0Z0MsPTudSIMt4O37nZ6OE5wLwZxn4n6lSI1aFl0YIWulB9FdRJGzvoEhnSVgauaRTFEi3NIKXSj6SbxLSf6ed5vezS04gzOpWeiZsTlpX3KOCn85RA5lJwpqpuHU7DZFnMsicYskMiqL5tr0Knvb4D90W1ESintxeqLPmDmDdh/1YNGmEmJjIoyy/moUWKazm7BIB8GHt6TMonp3WV0rBKvAWASHuzxfQrApth3bN3snntDXCPSgK5wDTuBeT6mDDsN62COh8UdAV2RoB3GqDjsldIR3OLtNLPCy8i+1p1qsF66/xKCB
 eayBjR0Y
 /065M6Eo2yCt9M00z/3rfd/d7i59kvRUUcYA1sXNYipplx1Oq4a45ja7O1O2jn4xHvl56z1B7eeUVJokdJowyQ1gBs/dVD+1OyITNM1PD53og0GcxHvfZK8sGu0xVRFmSPv1DurVu8SoqEjkGxenT6hqWqL5AyGXYLokc6sSO4tExcbcowxJmWq1TcOUijdwrX1vrs7ROE84ajDLveHUVPZGrOTZIK3epoFylF0YkSB87UZf8wUfh4xdZsuUT7k2c8B0ZVvcYTVwcqj7uxmMDo4Ovs2VWeGNn7XvyCstgXKhsvWUXiCLFriKbHpo6FQQv4ncJ+nhw5bmCDzn0lX5Yj2SJxPTpODZ8gqiVNGKWDahRXTUabUOPD+LsVpT4v7FYpLxRJGHkWNcyiSwyfgpf5WpfEpu+gxybT9DD+gmUp5cfl8Q2esAokTYuVi4oFXapMnkGKerjbMsL/j2IVoPFx6eFfKw0va+8cbxRIZOvU/BaIIVJq4ghUETCLv4nvBfu6A8hfTBNlX+3m8c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Honza, hi Willy,

First, my Aug 20 follow-up bounced on the HTML part. My mistake, resending
as plain text. Below is that content updated with six more weeks of
measurement. Two self corrections first, before any numbers.

What changed since the RFC (same out of tree module):
Automated prefetch never exceeds ra_pages now. Overhangs get trimmed
or dropped, all counted. The only exception is our own measured
willneed ranges up to io_pages. That follows Ming Lei's RFC direction
and the MADV_POPULATE precedent. It is toggleable, Mod A means strict cap.

Fault path first, as you asked in Q3. filemap_fault hook observes, then
prefetches with depth capped at 2 and bounded by the cap. One more
thing on this: the fault path stands down explicitly at 1M windows and
up. There is a straight s_bdi->ra_pages check in nsd_process(). The
  parity we see at 256K and 512K is a different thing. Our code still
  fires there. The kernel just catches up on its own at those sizes.

A sleeping in atomic bug in our fast path got found through a stack
trace and fixed. vfs_fadvise was called from fprobe context. It now
goes through a workqueue.

A len==0 fadvise footgun got found through our own counters. Len 0
means to end of file, so those sends preloaded whole files. All our
earlier big mmap and SQLite speedups traced back to it. Retracted.
Sends with len 0 are now dropped and counted.

Narrowed claims after all that. Interleaved A/B, drop_caches before
every run, checksums verified, 500+ runs in total:

  sparse mmap scan, about 64KB stride, 512MB to 20GB files, 128K window,
  SSD: ON ~47s vs OFF ~88s median over 30+30 reps, no overlap.
    The threshold lines up exactly with FAULT_AROUND_ORDER=4 (65536B).
    Below it the kernel fault around covers the fault by itself.
    Above it, it does not.
  same setup at 256K, 512K, 1024K windows: parity, kernel catches up.
  dense mmap, rand 4K, seq read, SQLite, THP, and HDD sparse mmap:
  parity everywhere. The early small HDD lean got remeasured with
  current code and traced to the same len 0 accident, retracted too.
  No workload regresses. dmesg tracked throughout, no new warnings.

So the scope is sparse mmap scans at default size windows on
SSD. That is where the fault path underprovisions while the read path
is already saturated. Dense, random, 1M tuned and HDD cases are parity
by measurement.
Separately, one thing that might be useful here too: p99 tail latency
is about 4x worse at 1M than at 128K regardless of NSD state. Another
practical reason to keep windows small.

Open questions, updated:
  Q1, fadvise beyond ra_pages: we stopped doing it silently. Only
      measured willneed ranges up to io_pages, and that can be turned
      off. Acceptable shape?
  Q2, ra_state integration: we prototyped window steering from the
      module. The kernel keeps our window but wall clock does not move
      because there is just not enough volume from outside. Real
      integration needs in kernel changes, so we drafted a minimal one:
      2 stream slots plus stride state in file_ra_state, every window
      bounded by ra_pages, read path only. Want me to post it separately
      for direction feedback before any boot testing?
  Q3: fault path first as described above, with timely versus correct
      accounting running underneath.

For Willy: backward patterns get detected near perfectly (strides with
negative deltas, counted separately) but they do not move the wall on
SATA SSD, so throttled now. Fault path is covered as you asked.
PG_readahead replacement stays an in kernel question as above.

Full data and the retraction notes are in the tree. Happy to run any
counter matrix you ask for.

Thanks,
Ayhan

