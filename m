Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CAE3CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 13:52:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C2D98E00AE; Fri, 22 Aug 2025 09:52:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 999468E009D; Fri, 22 Aug 2025 09:52:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D6258E00AE; Fri, 22 Aug 2025 09:52:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7E2308E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:52:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 00193B6FAD
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:52:13 +0000 (UTC)
X-FDA: 83804532546.10.7309BAA
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id DE050160011
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:52:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Vi+RpGgq;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.51 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755870732; a=rsa-sha256;
	cv=none;
	b=pdGJj1fBRfGCWjMMv6cO12koxdzGlum1TZYJOuzs1WvskPH4ddqQRGTxDG0FilE79gKbPr
	96hhucuwALo+qen/sbEcWA7IgsLMaAJl8svlTRTV5Ee/3QxRHQXoBXz/TVpVL7fIoTNpif
	iDvn4NxdMflR/j9MHex200oV02mnKZ8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Vi+RpGgq;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.51 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755870732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NRu/0FoVw+bU0VwjyXzuUF8CXZhxspV/ZyS4JSE6Hqs=;
	b=tficmACxYw5T+VL6HkxLOPvMqjTnV/Y2VYxWyi9spf703l6TgtRvkfy+CPXFOr/lnozhUR
	t2Cdd4D3kzcyg7Lqy5gpvNHZ4dhyZS48qpZkiKAuCQ3pN+ypmoq60YhX1bfB20chOfisnk
	EWeJjC3CmLJEYZMQXHV0zq+lixyIPfI=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-afcb78fb04cso279047166b.1
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 06:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1755870730; x=1756475530; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NRu/0FoVw+bU0VwjyXzuUF8CXZhxspV/ZyS4JSE6Hqs=;
        b=Vi+RpGgqoYRSbqhjJmDRXYxVxu9QFcbcT+XWRv95TlKBmQMMG82kWIsP3YSgZnIUYZ
         JaNc2RF+FnZWt05+/9+y6kkCzl93Uj5ia3CDZgfo5wNw1mfECeeia/R/RD74hKiZWtSB
         QjciHm78xOh1JGmiodw9NW1aPUaE1ZSymcDzo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755870730; x=1756475530;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NRu/0FoVw+bU0VwjyXzuUF8CXZhxspV/ZyS4JSE6Hqs=;
        b=V7wtNghcd+gYbiYjhWQiolhLSh7y7KQ7ryLy1b7YE+Rq/SikY17Vz1NpWHEmJ2h0QE
         gYjWPNJkYIPKacAjvhmQ3nCWjykboMpDAStWYm6C96MS3ScFdPtHYoDKMPAGpzrsmb4Z
         EWSyOXUT5YanVR09viADa7DCoibqgUGEcqtFc2ShxPs+zAXeqlduJxmPMfH4Yacv0WHZ
         9MuLvLRR5eRGtTdckkbOKNPJZ43ASmbGzFUzghgp32e48O72GnEmWtdfiIXjd4jBO6M9
         4vvuWPhcaQ50eBLQQrlvI8ia/dyFJ65srhlVh9CX8Z3vtJnc7jyI7N+EwjtJAPoSAuZz
         kHiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUdD+MhfWVJ8c0AbDw1z6DISGNB7b5RwsdvmQdLDvcNy41QsSddqELPSOibuzYmX+YruruvPn0nwQ==@kvack.org
X-Gm-Message-State: AOJu0Yy4W72pDhOdg0Fj4bmv3NWoDQ4tEIrxgUaaThtMiC07RysZWaHb
	tVLGts2CvSJOEcZ82trUJJwvOe65VB+Ee7HZrpj+bJjC5E7S63glD8DPD7dcZNnxbNo/7J0Y34i
	Md6t0+Mw=
X-Gm-Gg: ASbGncvFd+B4KoBapn7mB5mlKbZ4GqxMYq9xtpP7aA5hrxaYz38mgroeC+8147MqtQ7
	Cvcm6LKDsZqtQBV7Xd3NT7B0+EBA1BbMGHDzP7aCNsnkqEVZZceOSZ90E80qdAA/Hj2Er4gAfML
	K9eJq7REk9kzMPK5Ka9OE/wmCenRxXKyVsdQFaqqt/hru7tEZPKQN8sHquSUugxpLnLytyb92x+
	hIikSGk1vUkD5FoY1MbletKOR73MUQrYnfpeFax+I7tz9TAZYRhiwM3BTFqRiMJz++DRvNqjJUO
	3hYkIqoiv7SzOs131liIcMBffFFx85PUeM2ObN1mv/1+Vo6sh5jzFEHOtT/WTYzXW87f8F7qnvV
	oCt6lhMj+gKoQXmiZAsAdCiC1ndh/GQNxmPSnO0b+SvUx+xCNP/5KWnzovrxgRV64Flg6H4+6
X-Google-Smtp-Source: AGHT+IFEAKUr6eT3eBvvuQWLrCZG6WJY8b33arqrzcrtzSoik3qpgmQUVaURBpC62i7i++cuugQ8Qw==
X-Received: by 2002:a17:907:1c92:b0:afc:b617:de96 with SMTP id a640c23a62f3a-afe2963b638mr247994466b.49.1755870730051;
        Fri, 22 Aug 2025 06:52:10 -0700 (PDT)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com. [209.85.221.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afded479020sm615071066b.74.2025.08.22.06.52.09
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Aug 2025 06:52:09 -0700 (PDT)
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3c6df24f128so64883f8f.3
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 06:52:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUMZjzZ9aZ4ZsKJ6KsPHgK3o5IT68Nra5WrTrlteNbGWZ5V16yYwzbKDNSZTVr+yrUGkfy0YRljlw==@kvack.org
X-Received: by 2002:a05:6402:5110:b0:615:6481:d1c with SMTP id
 4fb4d7f45d1cf-61c1b450840mr2274281a12.1.1755870414406; Fri, 22 Aug 2025
 06:46:54 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1755854833.git.christophe.leroy@csgroup.eu> <82b9c88e63a6f1f5926e39471364168b345d84cc.1755854833.git.christophe.leroy@csgroup.eu>
In-Reply-To: <82b9c88e63a6f1f5926e39471364168b345d84cc.1755854833.git.christophe.leroy@csgroup.eu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 22 Aug 2025 09:46:37 -0400
X-Gmail-Original-Message-ID: <CAHk-=whKeVCEtR2mQJQjT2ndSOXGDdb+L0=WoVUQUGumm88VpA@mail.gmail.com>
X-Gm-Features: Ac12FXyg7aT4BFeJsiyaeWdfrE2FPhwu5xUJIJ1D8_vj4L1z_hVeZFuzgKfsNNk
Message-ID: <CAHk-=whKeVCEtR2mQJQjT2ndSOXGDdb+L0=WoVUQUGumm88VpA@mail.gmail.com>
Subject: Re: [PATCH v2 02/10] uaccess: Add speculation barrier to copy_from_user_iter()
To: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Darren Hart <dvhart@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>, 
	Andre Almeida <andrealmeid@igalia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Laight <david.laight.linux@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Daniel Borkmann <daniel@iogearbox.net>, linux-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: DE050160011
X-Stat-Signature: ea6ajcob8wu9gqunqx38hywb1stphm5y
X-HE-Tag: 1755870731-78391
X-HE-Meta: U2FsdGVkX1/c+hM2P3ltu/dwxUt1Oif8RZHHW7HL/BW1VffX/BiiH3WRjYIngVMYRIEC7g0U2LGUIe+89QC82R1ysUJ+5Bc3xHrdGGLPG4Foy1MA4axaSUxaWj5vQSANvVZLfa9A/DOxRi2pFcNpY5f7TzqPMJ/vZsHzUiSd6Q7i6lw3bJowBBOLriNwwqxVdj9MhIn2ZWU4dND6FoZVwcU3wyCoS/E2Rm95jVHUF1CRBH2FKq98Asw7BLKhJMbnfyq5tOGi1gIdBt1gUtWbHOkjJCk6DBDRO8gP4d/8J1ZrGDgXIiwsc3E3hawr+tCc0q4TcML3idzpC3H9pV3Dh7rfJuKdpFeUp1eMQoCUHni5BR0mlv7CMFNJwJ3vHm86E2EjeqM4RuJjrI0us1BrXMoKlI8HDWHyId7La8Z032PXG3kVkzfAvEwxB4foDWB1nh3Bfciu2+AgNGRGSj+sL/TGq/95Mw2JYkXPfKGP5A+3OMufzGawloZsMtGz51A6xv1okLZnL+kXCcbJCxNXbXq8fKVtdE4cfHjas/O1SVEWGJ1Swfk6sKruLkZ/jr/DORoqqT4LJjwfbLi5scfUZ/5ygJaRp5G2rJhPsRN3HL81pXclCIlyAd3qVszSNese1pmsVFTS3mIdBO7ALDF+zcRcgSy8rUwWCMrm4h6tTNz+ERh/cCdq8DqYQRYe8Ma/iiS+Aw9K/5XCTFFGeP6b9EiWAtavxL3ffdZvu7T3trlRa5PyyAekwyuhiM1q/pnracsNhzWio2DqgVHrHJHMaCmlEt03KhxSQtWj5u0jjdC1rFKGEqbjZSIIynol1HOkOWUzya0hns8W9FuX1+lu4N2f4hXmWo7zM6+YPwGnC/K2xMDJbs8eg+RaCorTqglXhl+nLdNRwicF7wtWOKoKk4jfIfQEo4NlQ14mYQq/9kUkeEwq1wHj5CpsGmZOuWRMSbEJiFF6yGsOdJqFA9h
 5359a1zg
 NBuiizqDEQjS53uFcwYkP3OF65qK67FHyqYnRwStbMV/h47akzz8qFEINV2mJXuKKNjUle1qC6BGqQymD0/QTMiG8KSBwmIbB9y/MqNLS3wU0h3QhiWVWmTNPxkUhne/B1h2OnLOdfgCHBLn9J+hg+i5/S9P67Jzb83VolqjvGVfI2MvxyZsCVbYHRadhMJFRVdj1ioO/wtHdcmPrCRDq6Oc4U71XOGcQDruLt5R4jJFRLuhvsuvfIs7B16svM7Gr786l21LVQeKRa02ZveYnvSG1SYUjAtV8b0ks7+Tb0spiweoHY/FVsWLpuQGrNDqHhtf5+Aaud2Lc7i9VCguHZjITJCe1zqL9HfYmb5dzOR+hvPEHFUDswmFKIBz968eCeX3x0ElaOi1ZBqRh/VAM4/hTpeUj+hi2R4EqRza14jjQF/4uzh71RRltnG01w9BpzLbYBLUjeDx1zJ4XtTtnVJZ7eNMxnJuuFBVXt/UPDo68dZdYFmuLShsqf7JKv0YSKvjpsD8BlnI89dkho2hxyWNciYbl6MJOsxFvdI2ZpC6ih5fjLFtTMSe5urBCIin1IXdPsWHWjltTNJpQz3emRtgAO6xVaFxiUJiL1sB9qBr7aBQ7RKRcNsAzP12b011PVC54SIea6uJ78J+4Hkj8XSj24vo4OWIFYOkSF0Oivz/pLxaZepFF8t4i1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 Aug 2025 at 05:58, Christophe Leroy
<christophe.leroy@csgroup.eu> wrote:
>
> The results of "access_ok()" can be mis-speculated.  The result is that
> you can end speculatively:
>
>         if (access_ok(from, size))
>                 // Right here

I actually think that we should probably just make access_ok() itself do this.

We don't have *that* many users since we have been de-emphasizing the
"check ahead of time" model, and any that are performance-critical can
these days be turned into masked addresses.

As it is, now we're in the situation that careful places - like
_inline_copy_from_user(), and with your patch  copy_from_user_iter() -
do maybe wethis by hand and are ugly as a result, and lazy and
probably incorrect places don't do it at all.

That said, I don't object to this patch and maybe we should do that
access_ok() change later and independently of any powerpc work.

                 Linus

