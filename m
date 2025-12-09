Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 759B0D3B7E2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 02:56:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D92066B0008; Mon,  8 Dec 2025 21:56:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D42CA6B000D; Mon,  8 Dec 2025 21:56:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C58356B000E; Mon,  8 Dec 2025 21:56:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B47216B0008
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 21:56:49 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 79EFA890AF
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 02:56:49 +0000 (UTC)
X-FDA: 84198420138.01.9E2D266
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id A86F1C000A
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 02:56:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cSQQwNbD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 37Y83aQgKCDwhYaikYlZemmejc.amkjglsv-kkitYai.mpe@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=37Y83aQgKCDwhYaikYlZemmejc.amkjglsv-kkitYai.mpe@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765249007; a=rsa-sha256;
	cv=none;
	b=LBpiMiLkAdaN5YBnrqfWqUIjF+7yKESYVSPdXaFqWzp0B8szNr5Yd2QrLua0F4Xo3UgO4I
	DroFkwrr5xKX9evU5UwAm6vw75xv8zlA/x+X4tAwWeKj7OqMk4QQ792ifxAfGu1431Pugq
	uYkos6qV3bNEgvMFE93NO9Q5Ham8f1M=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cSQQwNbD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 37Y83aQgKCDwhYaikYlZemmejc.amkjglsv-kkitYai.mpe@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=37Y83aQgKCDwhYaikYlZemmejc.amkjglsv-kkitYai.mpe@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765249007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q7EaRFbH/Lf9R0V6I929pmeRztGDYkW9+BODBzkEPjs=;
	b=6Mj9ZKQ/N8OO6uisDtpo+5bVgl3/0mAPwYe4sTyTG6p/dH+RBz292brgY5yDPe/CPFaHcB
	Ukzlp6UEUOQ8+jxXhaeyKB4eC2zSEytTfeAEkgqfAQw+x1BK453bUk0Bd9O7+GuRmTpRP1
	Ea1CMpyFvO0mnYiusiL4Juy3Zn12XX0=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-42e1e1ca008so3204506f8f.0
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 18:56:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765249006; x=1765853806; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q7EaRFbH/Lf9R0V6I929pmeRztGDYkW9+BODBzkEPjs=;
        b=cSQQwNbDDtzVxecxJEpGQxS4lSYwkkrWSMgwtCliQpp2cvty6OA8S17GRV9+Dth8lQ
         5/hqZq6qaYdiJQ0sg9LoKuoqB62fv239FZUSad/2Nxn5/Nm0aUw4qg7YvyQhjKmKsgMo
         VGDTNsYYw/CW98oqzBHvH5nAYOev/rpCDDen8z0VzfqQkq/OXEwmFN8OthbBUtWg9duW
         o843/ZFwsNkamiO718y7ssHmSdJiKxn+IJ7lVEJ9kdx1ZOn+DS51w49cAk2hhu83fVo1
         SPWReZWhzPmex5+gfPn4z7hI4PVA/wSLwShehkjNJj9/vJriB6NFzB3+7KnAgOEWbyJo
         JZzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765249006; x=1765853806;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q7EaRFbH/Lf9R0V6I929pmeRztGDYkW9+BODBzkEPjs=;
        b=hieJNyEIjdXL+bRxXykGsC0mEOGAz1PYeXehwXo1by7K1MPZpEDYzZH7XLbbfSb4M/
         JQYooCbDEsjkQHmkfdnodwqXEG9Dr24sklmzvexIlFf2ofZjTOD2mwrdQUuE3QN5VHKG
         I+/O2YSpOXPxHiSTYSuLVjc1fL8Lv+3tDTJ86K5+mbYWtc+vN2ZhzpeK1fpHoI4paZHs
         GdWExVxVosQ5v11msbOUu7HtHpEyI/IFslA2e/79NchfQAknMb7Ac4gzK6L88MQ0p0E7
         Qe8hILkucP7IPuenwvmsOvLHgoB1XUwzulPSo1HqYSummjz19uzvVyAzLp875Jd8/uq3
         0U4A==
X-Forwarded-Encrypted: i=1; AJvYcCXCTx1LjDCSv9MM5NxAQpyc74Fqvq/0MKpce9Tc8JzY03pUJv+PicW7XiUPnOF5F8/3jZZArB6DAg==@kvack.org
X-Gm-Message-State: AOJu0YxIzEyQYYglPPLpplfq3vTnzqDzBtYU5AlnPLanHpIn7T8ySz8/
	XenBLM6Zvo85AnRpruuu2Q1rnMVLWuQj00GbV/6YtQoXMOTBymKAi6iicice1tnNscSCjfncj4E
	vPVHvHIH1om0s8w==
X-Google-Smtp-Source: AGHT+IFm5Kmha7smcDj9tIB+hArhWUM5gz1offBTp6XSE0T88cKajhMxGRylJyGmYxNi+7S5qT5lVih1B/u4Zw==
X-Received: from wmsm2.prod.google.com ([2002:a05:600c:3b02:b0:477:3d56:ac34])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:844f:10b0:477:9d88:2da6 with SMTP id 5b1f17b1804b1-47a7f987e56mr294705e9.0.1765249005956;
 Mon, 08 Dec 2025 18:56:45 -0800 (PST)
Date: Tue, 09 Dec 2025 02:56:45 +0000
In-Reply-To: <693691ac.a70a0220.38f243.009a.GAE@google.com>
Mime-Version: 1.0
References: <20251208-b4-vmalloc-might_alloc-v1-1-94a9bb8ecb08@google.com> <693691ac.a70a0220.38f243.009a.GAE@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DETCJPVHXE8O.2A2XQ73M2QOGK@google.com>
Subject: Re: [syzbot ci] Re: mm/vmalloc: clarify why vmap_range_noflush()
 might sleep
From: Brendan Jackman <jackmanb@google.com>
To: syzbot ci <syzbot+cie262549d3c7e101a@syzkaller.appspotmail.com>, 
	<akpm@linux-foundation.org>, <jackmanb@google.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <urezki@gmail.com>
Cc: <syzbot@lists.linux.dev>, <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A86F1C000A
X-Stat-Signature: egb1iwwrqtmddfwp5n4yx5e7tudobbg5
X-Rspam-User: 
X-HE-Tag: 1765249007-236657
X-HE-Meta: U2FsdGVkX1+KHBv75odRa91RufEhLe+A+OgacP13+FdTXAXLl5dQK0xpivCsZjBaDKHF8UpxyCw2L5dvHdeuMrlhelXhRNmeUlO0oziX9/IayxTDY5prh9vZgI6O/dId1sntIP5jfQ+cHBoFkZKP2HjtPNke86rW3Dxkeh8Y/IBxv5jrcM9MvF67a7lLsP5JXQRFAl0nbClSnJg9hZxq6naa4pd6sopm5JDfJCQLT1rpAw+hKoZZXlWb5gdY9EHqHdN0RBv400Ibm3Dwx8DpdstNcOeV6SAtHjvzrFa+JS/p1fNYFO/UTqYOsqKQRe6SxSazWBZ2lzI4TzK9lCw7J3TcDUjraRR1fMY4vxHD2p+v+cVfcWZmymvj+JNiAcgUU0QYmYJ4IJddsBeCaDvuL97D6RjwZ66kMI83SNVPhsnGRgkwJ3d7Ls9dW+xlzsi8arvE/ZAmYocIBfgGcn6NtGoLmfAB7g970vmYNftWiPAMztxvgj9vQjhvHQrldddbkr9RSZwthA1KL2oV7ZndkT18fjq/LsQ7pvM+4XdXTOGJM7nvoSL7KOjwP25fGn1MB5fyAVSnj+iRy3HDH2OSIybqyU6ANIMl1T6mM3QUbHr1O01Ovu+mb3RczYvcOGlE555HKDDL8zJCeC3z5b+oDC0Bf38X5i47H39pVYh3YiDA4aX5uXklaJVjHvTe87+EbLbl7Dt/mmagrORxhuUaFrLH2mqr5E18nygQDcFVtrPO4YWhAiIjLsjq4IUpEvKPs5MzQc/1CSU5tD7BZCSgmEFCOppqQOuQF0NL1A6sBRsPmzYiUgNrAAKVlzk+92iXHMwD4sYuFntwNokGeVQuKQ0+8KMPu3x/i/N8+DDHgJSvZhQTuLgqmWzJmji6Wam14XUYU/UyTjDL61cQcEUikT3cbETFybNknFS0Gt+KdOnMdEh1I1bSpP9C/o0HwBKheerjgLDdgVpX1du17HO
 iMyfJcBM
 L4jzhMwC2ipANee/3KZ5HAuOh+ml/QdDreWW+NzYdJTi2F61Fwc91GQmO1pDuxmLo7LamLrHDIGvhurzoTMoOOb1rnUznoc2a+P7AhSPYWlCOQ9iz4hqu3Q5Lz14bZoYoRm4mzM8szNbXymcROFVJNY0dYzjz0tPYTe51/hm4Oj+ECZ6+8gMsiPjh0PDmUl4xm91lZRelNe/St28AG2LxqBKezBKRm7fzp7+RJBuTeoHkPTiHhwkndN5MRO5Tp8HswWRmS8DHVMmh5ELVxUtEJNhk9h616/FoRsMoq6JykKaE828sMxdnSYSMOuAPbyIriGJ3wxgXs39Jm4SkuHx+M/kbsVOKs4PXcUnMtNgcZe4Sh1GnblifIXG2VhZvko5iqnEbUFaea6FhlJWJsgQHLYQASOqG8t7d58cPA//NA8dgMCwIPGus9TP41phf0680dW8AKmGlwSD2Ik8aosonJcirzwzwuqH1vnCe1+Igg/6sxKum9nqIq0WBKllWRlV0EEvpkoSAvumRA80tOj/Qn5+CColaz51D3Metgw4V9Scf1f7hXZAt8OVdg2ucvPdRFWF/v3KN9Bbto10mq5vx+gRGRujMuS26Pc+32GznfK8234MIooKUxQXba5Pz/VedRgZZsajWMlFT3+GuPCj8BvZ84QVuIkgqYjZJaM1YqTwQ8f5vInYU1D0CgkteWmsA2RlOUZHZLjAAA393PY2TGizmIaxkef80LVhS0UANbzquu6mNANAi1bfjPN4xG80RTBHW+Kw/S8+cNhG4Qkul//0Pn2MvPl3sEX0b5DZ3CodDZHz5Kh7rTK0em8Qzwo+N6UkEDBW0q1YTPar3h+g/mxWqpwQaXfhYyJqtm/WiEZIBREg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Dec 8, 2025 at 8:51 AM UTC, syzbot ci wrote:
> kernel build error
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
> base:      3f43be96f919cc611dcb2a4e38dd464831f4513e
> arch:      amd64

Um, so apparently I didn't even compile this code for x86? Sorry about
this.

FWIW, I do test my patches [0]! Apparently in this case I just decided
to post it without actually checking the results.

[0] https://github.com/bjackman/limmat-kernel-nix

