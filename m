Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A4F2CA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 14:41:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 273958E006B; Mon,  1 Sep 2025 10:39:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24B2C8E001A; Mon,  1 Sep 2025 10:39:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1621C8E006B; Mon,  1 Sep 2025 10:39:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F3CD88E001A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:39:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A0C33160833
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:39:45 +0000 (UTC)
X-FDA: 83840940330.17.1F5D691
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6FD96140006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:39:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=Hfb2spAE;
	spf=pass (imf09.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756737583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=htQYfrQvt/cTrdobxmgH73W4WPpszNwvgv/0+a/GiHg=;
	b=ePU0o7bbP8KprQOXydoeVsp5meVl57NSsX9kzGCnEeBwzudjxm1fZgKvpnklNDNhV+m5Ee
	crx5oX52kFL6l8v6OPyaMpWqP5h2OHw6Wne3+5O/7OK+Se6ZT+x4WVJp6K2ryycO8NPOyy
	J8YGqMReahRQ3N9EvQercWKUwa40Ous=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=Hfb2spAE;
	spf=pass (imf09.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756737583; a=rsa-sha256;
	cv=none;
	b=UoK/Ph2JhBZWGkqyiCIWLtb8PLVW4o0gPvc0L8EmYKK72FtM38zmDHJP09zrm8d2Ujdz9Z
	4O6neoBUx1dIocSkM1NiogQeO6IHLZCxpjkyUvVBs24WUMY8jqz2sIEUPqxQ8AoGbIEwgX
	5TDpcpIfZH+qtUF8bQ4gfPPCqYFHtRY=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b04271cfc3eso154194566b.3
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 07:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756737582; x=1757342382; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=htQYfrQvt/cTrdobxmgH73W4WPpszNwvgv/0+a/GiHg=;
        b=Hfb2spAEgGT+L7qyVweIx6eXmZ2H3psTrrltuxQx+6NPcIe2wr5xzIx6xNXQ/UcrOg
         DB8bRlu+LsDyxa8L3KGsUXauNeZaoryzOSYlJ4UUPkSteA2djWUQx/4zHImYNGH9hQiR
         yfRo9ypvCMP7Wz7p5smAkyy52YSk/l5DLBo7hfdbodf5FH9rz0FMxYw5ytuPph0gRfRF
         0Y4l3scVtayI5BtfQUASWie4GO3xFz+BSqxmzILBK6xIM46WSzDQFb7kAcdAdK6omovf
         uuIlDg0UABJrKwfQMHt/okrDuTjSZIwdlOqM0EpyIT2V2PqKkwUXJS2ZZIvDXEwwCjJA
         iGZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756737582; x=1757342382;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=htQYfrQvt/cTrdobxmgH73W4WPpszNwvgv/0+a/GiHg=;
        b=Po+mOIlqFXkF3YrjJX+jNrZ5SQByNInNAj+E/cyXFmHy3Y46hnr4cZ6nWDyhtxGQe9
         +TRXriwqo472UB8daQVGeFewZQU4FLeiG93sVnf6ba3sGRxZ2ka5MM1OxgxGP5yBpzPM
         kTcOh03l4l4a8bFsNGIYl1kDifaKGi2ImyaUTWa830kxpq8x+CZuOmOHvQp/7r9MvsCG
         U2ni6ERV6OpaGenXZnCf6BtAZXGTWYCi+5usFY3UFNruUY9OCBHrgadgFjQFvB6EhikI
         nJdyQleIRb0AtQEDwmHfA0yOZVkC7EaLoQD1cswzFycPxhjVuF8ZszH2nSjMEApKITS7
         5SzQ==
X-Forwarded-Encrypted: i=1; AJvYcCW24ulMDXdq8mssHFHz4atHs5qNQJIgl1XjI2zqdSwm8LV8DJzYFApPIxWlGDgIWNQ1OLLt/AQ8pA==@kvack.org
X-Gm-Message-State: AOJu0Yx+1WWcpzNBxpjB4f2468r61tjvP/sg2gU+IqYBZVAAhXymG4Gs
	2iPBEE1HfLMrrumKWOXgr/8RqCsmlS0uezd+G5dQGlRx8napWq/PqlYLnum7TvBwiLT+oS/o0i7
	2IIFaL+fwFxWnniOiJFH7o/paxYsmVXqnLOFtKl15Ug==
X-Gm-Gg: ASbGncvIVYzlPY4fj4PKp5HSUXcxj7eSEDQADcWb6pHAsgAzXlAPAOTdNhKIHH6Vh0D
	EBCfVxUZSSeCEBr9tIvoE5x1J8PaH8sJvSOixKVcCil7EGhAnZ3erS5/gai1+AnmCqlESjTEvbw
	SPkV0Kzt98TbOsRnuYuN6ObxRlkZ7bY+SDnsuc4LFLu/IAVlDGlpRqiChWCbLUIX6ThfHGDksMf
	OuuqRske4OOUXSOhNgEdvhenafI59fKsUGUZjcycZTgyQ==
X-Google-Smtp-Source: AGHT+IHTqF1JAmNmg2OO5LltznXi0o7wJKri+X2655du84wb99ZGTC9056cINHWh8si0MefDcLENJcuak3msFoGR/no=
X-Received: by 2002:a17:907:1ca2:b0:b04:470b:64a5 with SMTP id
 a640c23a62f3a-b04470b665cmr30691666b.36.1756737581693; Mon, 01 Sep 2025
 07:39:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
 <20250901123028.3383461-3-max.kellermann@ionos.com> <e509a5c4-f71b-4fcd-9776-6a3d39761b4b@redhat.com>
In-Reply-To: <e509a5c4-f71b-4fcd-9776-6a3d39761b4b@redhat.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 1 Sep 2025 16:39:30 +0200
X-Gm-Features: Ac12FXxHU5onUYdItrFe4rtUI2ez9M9oa4kNLp6RrsUlpVm1LJn2X4DtIQLritA
Message-ID: <CAKPOu+-ti5bL6YLfBGMt1=3c6gjLMeBqmHGPD1nQC2J9uU9mPA@mail.gmail.com>
Subject: Re: [PATCH v5 02/12] mm: constify pagemap related test functions for
 improved const-correctness
To: David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com, 
	willy@infradead.org, hughd@google.com, mhocko@suse.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	vishal.moola@gmail.com, linux@armlinux.org.uk, 
	James.Bottomley@hansenpartnership.com, deller@gmx.de, agordeev@linux.ibm.com, 
	gerald.schaefer@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	borntraeger@linux.ibm.com, svens@linux.ibm.com, davem@davemloft.net, 
	andreas@gaisler.com, dave.hansen@linux.intel.com, luto@kernel.org, 
	peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	x86@kernel.org, hpa@zytor.com, chris@zankel.net, jcmvbkbc@gmail.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, weixugc@google.com, 
	baolin.wang@linux.alibaba.com, rientjes@google.com, shakeel.butt@linux.dev, 
	thuth@redhat.com, broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com, 
	mpe@ellerman.id.au, nysal@linux.ibm.com, linux-arm-kernel@lists.infradead.org, 
	linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6FD96140006
X-Rspam-User: 
X-Stat-Signature: d7nruajdheeekdcniz9ybdha61oz613k
X-Rspamd-Server: rspam09
X-HE-Tag: 1756737583-69031
X-HE-Meta: U2FsdGVkX19WvvlOiCLlnKGI5cs0pMfarJCWWzhPTwcNpgPAdhMQ2TxIdgQcLzdGO4zNqEuayXun4J64o8Xow1HOvXDJxS/HUucdazGQ7kUkNHhGFB9qE2LiZupdzzyPkM7OwYawWo8kFPZXvwFggjVOlwFZ9svtCHIqgQHJS0N0It4NsL5ITjCpUTN0RYsimY1jr0MiL9F9pRX2KbARzvk56g950Rhq3nmSQzPc5WS3ddu60TfRnimIUQGYyE6nkZs15zdoTLc2m5yyr9cuumzQxbPBpMHCh4k54JIlYp9QzT9e+LIaM5ZDnkXTJzi4vRS2Z5/YyThw1rXSnrFcEiHYXTeeGuYzGCmSi922tBTK7Uhxwkfg6TY8PWQHI6nLz7iWqaZ5PTvAFXUmd1Yf7N+LMcOPLfe+TZt6tbxR+kdtJ54/Wq7LZX6+C/dlltsBOB4lnUaIrR6m3EDAbmdvuo9oxwT09qWHN1Zu76Xw9xnbApXDHlRs281KARY0g2KViylof1Q/AaNERXv/RXUOl4nOUqmXFq0j5dwM7nn9CE4+6kEP3/uVVTaJbvLT9sAcsU2TJNUqr12aQ7K9RrUzCknAbPWSzh/tL/nsIVBEydct6aLCRfnDot11kj55g3/hEnZUY9xDpl1hthiy+BlYbwfqePOqCoR/ii2x+qhrv5vqgRVaPpZJjYw2+IkzgsevVsgotfCpDYk78Yl1gdWhy3AxggEY10Bb7Jh4SaYaFvmXBOGX9/VXuw7U2kKIqU372+qSdIQHpo6mzeO1IluC56vxg0Q4Lz4FB3M0C0x3AH1HIn+so2rc2zNc87EfEN1nkUq0iYUSDP3aDoNoBGZ/xElxT1Uvt48ExC7C9SfOifQW2gJG07okhGAdToetXgnUmNlZxAqZo6KHN8btsrHOyJrbgfL6DbeFAzUqbnAEwIR1nJKQeMOpkVLG9UinqTKGQ/wgavnlRMzaz5qgfJJ
 JgDeDRx6
 AJ2G2yN9D3mdk2P87fzSSFYjugY0pNYiR5ZcaTNRWjrJ1YzN11uj1VKaFuMu+U1ethdR34pQTwYSNik4DzA1JfQuIgFTXIP6/qOnwtlTfz9pKkrShHSroedz6Xnc0o5Dvv/8U1J7Sjeaxx/tw2xMbAibF7GVENO3C0INZZEYWmPLwoHTFg7bXK3EX2ij82ILMlGB+0/Td864sRSekJk4GPJux0d8X/3PQC2+kLD3EJC8yMxa2C6ye2czcf2GU1c2kMOYW5UgDE1ybLZGGu1MtfaMaEifbtec1DPYZyggkwhHFBJw2qXpDL5HNyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 3:49=E2=80=AFPM David Hildenbrand <david@redhat.com>=
 wrote:
> Not only test functions but also some other "getters" in there.

Oh, I thought getter/test function means the same for you. I'll amend the t=
ext.

