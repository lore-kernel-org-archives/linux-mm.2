Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E020CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 16:40:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B06B88E000B; Fri,  3 Oct 2025 12:40:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADE148E0005; Fri,  3 Oct 2025 12:40:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F3C48E000B; Fri,  3 Oct 2025 12:40:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 88F478E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 12:40:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3F2B3C085F
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:40:39 +0000 (UTC)
X-FDA: 83957366598.24.A245C29
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0AC9D4000F
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:40:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=IKtbPkQR;
	spf=pass (imf17.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.44 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759509637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o9Bks0glQoZqJ35eNGrkDQ2Zgt5IyBuc325aBW0rfDA=;
	b=XtXLzTEASZcZO7B3r/GLL7Dn8FKAJEgeCHfSXKbj2WJGLuH8/2xPe3qerMQkJLQizAEYy2
	lnu4La7Hj+8pLVjY0xlPCKVXyHAWWTXBGwimrCjTDP0FtSft27hlDNQTsiHasnJ7Je3c0S
	LpH8i1AXjWRQf5BMlLnFeLQ+fWP4/6g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759509637; a=rsa-sha256;
	cv=none;
	b=kX8iMcLmhzeLMGacQ2y9RVMnHe7iQ0CGf/8vue6VYWf+UiTuQzIvEb3suCMcTe6lVvNlFK
	8fJkAwluzRTKeHFoaQiWBV4ZVKBj6KTlWPQdf6teYmU559J9FT6izg5cOwpOWIfUF1uhnC
	cvcO7nO2MnjE/FDJNIqlmCVCmBZOHoI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=IKtbPkQR;
	spf=pass (imf17.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.44 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-afcb78ead12so460297566b.1
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 09:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1759509635; x=1760114435; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o9Bks0glQoZqJ35eNGrkDQ2Zgt5IyBuc325aBW0rfDA=;
        b=IKtbPkQRNi+d5AIKszxRfLmK0uvOWxgZAeBkC3KZdFc5tFa8gBbbzuNqRtGbHPrbJ2
         1DEGjuijk2uB1AGXVWxmQ4Kw5psd5vwSvGC+8DT16kbnGZqG0INPCbfODEulhEjG0R7E
         X/yta8KE2fu60DHPntEzDXQKLSqwFTaxWZoZc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759509635; x=1760114435;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o9Bks0glQoZqJ35eNGrkDQ2Zgt5IyBuc325aBW0rfDA=;
        b=PjxAV2nlkHTlC4oZCC7rcBS0xoYqO+cVzCGHesnd9NA26RrFn8+GEIPzil3IUFVqUu
         Z6iCuaY8Q83MpK4legGm2SZO80tfvIvuJFKvQFjCmSeX4kd5Y33SmFxa1NoCZEt6qG++
         Tb6szMI+keaKT6MxQKNF++xvs7L78Q5hnAUyfhfJa8TamDCggjddoaEfGt0r7asJXHEh
         kwTazVvjA932oH8eG0WCwZn4K1dFQwZjkuWgq7ubqmAPJPhZgOERSTP5w9NsB0RR9e2v
         xH3D2ubU6wIMAPf4IT4tPayoiU8AhPgu1q8u3W9D1Z5hIWR5bJ1S03PXOn7rM4VLxZs0
         7Biw==
X-Forwarded-Encrypted: i=1; AJvYcCUTZZpbZ9jfXdTeP6UJvUH+xucQyBSq5Bpm+r1fxklisFKx5HFJpXjHo6irRqgI1g0Kx0rkxLkcYw==@kvack.org
X-Gm-Message-State: AOJu0YyBmLpz7YpCIqEJATyxuU9SpH/Y9+KBPaL4mRk7nhYYh9OugcAW
	kTRrmJj3RjsjYYa0Lmg6SJxC6XcsxYLxSmkg2un5KBvYjW3KxRnxQOB1kuBM9gL/3Vh+OwWdXC8
	mvbHw/ig=
X-Gm-Gg: ASbGncs0SM8Bv/DkLnZZ28De6caGPN8dVS9VxhyHlVAq+8X0uXxErDsjbR3SJaUqKu6
	6bU7dF37N8OsKrDFyhHSvMYUjfUAQS9DNOatpfBVcWH0eFaq9O6XHDYFn1Tl591Bo5tXVunlUi2
	Wcb7OeS92BE4nyJWDxWwKGlESd///3pJq7HeQjisBHuvKyLGKBR6qQ2wU1IWNGPsIwVYxChZbHq
	cgxITjCgyP2yxAPdhXCyDKDB4v8BYg5j3k/CkePihEDX4WWvTDr21cSOqZ7uu0rSLYK//eRjcSZ
	xoyk4IfBnwvOg4lSkAroW6QgE1pp1cYewWiQ5PHW0sb0vz83YXyFrxfHAgW47cc7+JWPnPR912P
	pG2HkYWOTN3JL3Fdj3PZ8VRc9D6Q2jBFixFQ3e/BonZx3e3w8zswgqfjrnUovbeOlr0jeXyp/F+
	Fm92s244bnDgpypWgqmrM5
X-Google-Smtp-Source: AGHT+IFKzwU246Z4InGBJdoYaYCCR+oUObMoRUkTADMR3sr/0/wGkQgu4LZXcL2wyIsPV4izuGH6fQ==
X-Received: by 2002:a17:907:25c9:b0:b2d:d7ba:8e7b with SMTP id a640c23a62f3a-b49c2347c2bmr440094266b.23.1759509635214;
        Fri, 03 Oct 2025 09:40:35 -0700 (PDT)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b4865e77427sm473769966b.36.2025.10.03.09.40.33
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Oct 2025 09:40:34 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-afcb7ae6ed0so429253366b.3
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 09:40:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWDXCceURg422pru6JyPUIOkVaePl4kaJ5jUXAEA8CLpKNrdB3/QFMNQVF/Hzryql11iSmvZ8gHqw==@kvack.org
X-Received: by 2002:a17:907:7f25:b0:b37:4f78:55b2 with SMTP id
 a640c23a62f3a-b49c3d74babmr424650466b.34.1759509633396; Fri, 03 Oct 2025
 09:40:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wj00-nGmXEkxY=-=Z_qP6kiGUziSFvxHJ9N-cLWry5zpA@mail.gmail.com>
 <flg637pjmcnxqpgmsgo5yvikwznak2rl4il2srddcui2564br5@zmpwmxibahw2> <CAHk-=wgy=oOSu+A3cMfVhBK66zdFsstDV3cgVO-=RF4cJ2bZ+A@mail.gmail.com>
In-Reply-To: <CAHk-=wgy=oOSu+A3cMfVhBK66zdFsstDV3cgVO-=RF4cJ2bZ+A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 3 Oct 2025 09:40:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=whThZaXqDdum21SEWXjKQXmBcFN8E5zStX8W-EMEhAFdQ@mail.gmail.com>
X-Gm-Features: AS18NWBsgBCnrJzzu5xoBdIh2bX5YeDo-15f38HyVBOhspvW89C8BBlXICWbE3s
Message-ID: <CAHk-=whThZaXqDdum21SEWXjKQXmBcFN8E5zStX8W-EMEhAFdQ@mail.gmail.com>
Subject: Re: Optimizing small reads
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0AC9D4000F
X-Stat-Signature: 984pimwywtpxwsa6654tmhe3ofw3xpg6
X-Rspam-User: 
X-HE-Tag: 1759509636-607109
X-HE-Meta: U2FsdGVkX1/k5dUoHXp5jG7c3NVB3rS3OEwUB1Th/IH5hA8PtWhcPqyYoufbhXjOLieUAtcdlnNQ99Yoh6JcEkx7Ze5IhwJcqoHt5lIDi6mvle5pA4oXi1Wvy4AccHBv4e7I8iB7Q+KeSbCRMHZKml+rEa6ghf0OlRQ5cNfI7o+V+oHcwZvMntDavXg8s3Sv9u0jdstvd4dOE3TzuKbBxazYmN3es4ZUnvYJW6bdVCkNMgvfw/GHNRD2iqTmDLtBO0kLg3MRXw5a3PI9RuDMTT3hj5IKo1zLKWkGTxLaUEtIoIMnqSbehJo8YUwoZFVmrEV3YIo3MBN2NX0g2gqcExdujBA15BENG/C0kI+p4+Zy+Q1ZXZx4jHoFWw54NY+UgXycleGZtDZOPI4j21sYOqFcfEIbE/vTRdYqeLjGT3HT3XuJlkD2szetxfgnOafTHZwQAlC6x+J7MSq7FrmRcyLfj6n20QeM6miXde9xE2D4W6LzsWsebP2PuRhMDAJK99pEz6kfW3Mf7+lOgdiHGv1Ft21mVDXg8orPpsgqWIR9zYlJo3IsQ9svQyEUZqfiFA1MW2M91V5DXb4mt54GzcrnOAxLUfFKiUoDTIBvz6f7+8suazgFUJ8Y8LbvE6IbmAVA4jcKRwfVyiXDz6gxCHuR5/+b9fQNua8aExtBHfZGgtRNcbKP0/nz/cqExlnBRlAfGyfxhhC6KNUHT+JUUOnB8Q4TJHaBOPxQhDR/CkRID/wByY2+5MbQKBU26pYBzLd9d/HRaNbB/n6M2AWX5mKtbtkR9a4HXlmUlTjCTKcIa/LGRzV9xJ5GoFghR3s0RYubhwfzb22E0p6ZLNVFUqvKO7EZ6589QuvN1IzPpqd+AyFQuNeRQM4hxjGyVcSi8ZBk6rLI2WQKxPNeXgkBAJy/BMojsHOH0G8y8vDWtd0llJUcWa1r/ccCOWII2ZnCcWGg+l6YynUX61DWFWA
 88IEmboW
 O2MPSqaVJYPSoWxZ1uxJmwIkhRlfKKxm7RasLH0t7alcrpy6BeeRjA2H5j2a0lVKnXSqegiHrLlyAKEEGcP4CWvlOFabFUTyTxpm9EOjcFe1ZQvPBcPMPh8XrsygdZO6BdJ5RPABGdP2MJkRGOCAOGRbfmkp/RKUGcy/7zGhXTS2y7D2Ipho9nwfpgo5qk0tadObH6S7b6wTovt5i90OcyczFpiJKq7xlwo3LtShdy+J+c3DdngpadIPBa0jtCXbiER90YUbhzRaAAnGlZb16tei5W14NlwWioGiG+mGktNUAQv9jd1Lc8Gmnsh+kA/fqKnRpgDB6dv8pIl9kjCpAGdkJJHAlj+PDnVaM5X50NdWgqYG0rI7Zy9It/byMVL6bEuoBi6iX2v8yu+f6IDXwbRUCLxcyVs6sPzPgML3pmAREmgzlMVr0sHcTXHFoW30bHry56n9/5/SBVj+hOOGSGuK3duTkXF/XqubMmTRYwNnhW5TkAr4VVlCMae5gNGqc4vi1eIeDXYtXak7aOQ2eRzdK9d6bNrcKNEW/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 3 Oct 2025 at 09:18, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> That was one of the theories and it might be the right one. There was
> some discussion about having a sequence number. It's a long time ago,
> I forget.

Ok, this bothered me. So I went back.

Damn. I actually mentioned that in the original submission (well,
actually the reply after I had booted into it [1]):

 "And even then there's the question about replacing the same folio in
  the same spot in the xarray. I'm not convinced it is worth worrying
  about in any reality we care about, but it's _technically_ all a bit
  wrong"

but then I left it because I was hoping somebody else would deal with it.

And I brought up the patch again several months later, but by then I
had obviously repressed that issue.

So yeah, I think that's it, and I even knew about it originally, but
in my incompetence I had entirely forgotten.

And by "that's it", I obviously mean that there might be something
else going on too.

How about a sequence number in 'struct address_space' that gets
incremented by removing folios?

Or even in 'struct xarray': it would always be protected by xa_lock,
so it doesn't even need any new atomicity...

Anyway, I think you're entirely right, Kirill. And sorry for wasting
peoples time when I _should_ have remembered about this.

        Linus

https://lore.kernel.org/all/CAHk-=whFzKO+Vx2f8h72m7ysiEP2Thubp3EaZPa7kuoJb0k=ig@mail.gmail.com/
[1]

