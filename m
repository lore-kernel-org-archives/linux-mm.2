Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8669CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 17:04:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11C988E004B; Wed,  8 Oct 2025 13:04:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F3A68E0002; Wed,  8 Oct 2025 13:04:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F246B8E004B; Wed,  8 Oct 2025 13:04:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DDEC58E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 13:04:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B259CC0694
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 17:04:09 +0000 (UTC)
X-FDA: 83975569818.03.6547077
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6C50BC000F
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 17:04:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=AUnKYGro;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.51 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759943047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hB4y1UGEVpwhub5wcO6FK12pD+0ug2lV04A88O4v4vw=;
	b=CcguB/CmB6zIufX7M3LuYQVTttfo+iwjcPPaE5zTBGQV0+vI/p+ngnuDRAtsKKmB7sRh+j
	tYbDMooLX2Mb0T6nzRpsrnjxEorqNj5Bk5FgEg5ry2mEA6dfo/6IUZtr8lE6qnHgfumdqL
	J9NSdtgO8RAgYTCVi+LH+U187Bbpiho=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=AUnKYGro;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.51 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759943047; a=rsa-sha256;
	cv=none;
	b=gCK4RTqrg/PFMFifI6hDga02pEEsh9C8ULOtFeKkPfL+kwTOw32Tk65VSahSd3FcrF4gyp
	7ZmxWQt0x0GcislXHOXxr2Cr6wjgOB1LOBw6ZFPReTazhq6JXEoEXL9+uRiob08CCQX1fJ
	0o792zA2SpsN7TkgKDd6ajgFqCTvaCQ=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b3d50882cc2so5552566b.2
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 10:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1759943046; x=1760547846; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hB4y1UGEVpwhub5wcO6FK12pD+0ug2lV04A88O4v4vw=;
        b=AUnKYGro9KzyI0Ms+GRC+Sokm8SP73M207+7PKAR61CHwi8sJig9qR6dp0l+n/Z4NK
         1fz7BYbqfkkpFmBTjbaBgWtrB3/isLmfvic3jWVyY/RqGV5DEvoEUo28961Omj1z4cXO
         Loa5ylmh4N1wRu3jWxBxbEhXmlqhyF0AXzx4k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759943046; x=1760547846;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hB4y1UGEVpwhub5wcO6FK12pD+0ug2lV04A88O4v4vw=;
        b=GnzoCdW2mhwsI1t+wn640hwTQ6NKVYX/Yb/HAsdDtSzRE0b3Ft59aXssQSlMWgg3hB
         BmdWCmdnYpVcIhO1GOnkXElUNRtGxcHW9VVH9L2ttMlRBeB4yiw7eqY/t39rS/YNpcv5
         Oe9Cq9+kP8O6OOlSdm2la7Ag54nw3re5Ih08gOOBWr8DUaxVu9RkDlQRf1NOj3617cfg
         ZvupQJrSU+m6gdyuW6nK26HvcOKN9XzfGTUwOLcaM5q9daQTjveAqHsF6hfQnIiXD8/m
         2Ilx6ldRWu1sxC8NHUaSHvAv1FvuaA5Eh6PjDzmEiuna727T1APtpkCa75ORcExVI0fX
         ZjSg==
X-Forwarded-Encrypted: i=1; AJvYcCV68qVO3O9da5VbDQKPywno5dDF5CoUxGETfFt9ufG934D9MWZs7qpCGe7iFcBqdBew+pxN9ko8wA==@kvack.org
X-Gm-Message-State: AOJu0YzuNKaZEABFyHNc27ebzeIQFACx7oDOESqDKLwW4T7iDrfDPsRs
	X4dPZZQ0VLgqoLLi8hdMMH2AkFVV3YHQUJ6WqxKwe4IOJvS5JTBhI1HaydymW1Op6wsMUUn2vlB
	ZILW5YM4=
X-Gm-Gg: ASbGnctgBaZOU12n/mnwBmc9HobYdIIiJyc7ds4HGTqNcr8FjhpZDe0Q+jt12xn6mH1
	s5j9x/hChnj+23b0q9UVMsKdzneAO6vH19GAROaK94NXOI+xvIHT6ghLQMNyI9RGmJEW+fDErt3
	kynGfqa092SD8PM/sU7nTrrGGS3SpVhXryu/XtvmCe117eML/yC2tbr9abC1F/oWJMa2akHkjpx
	azsPYVHmLTC0QbI9zlrPnZP7h7tdGW8eyuvSX8acKa67MLDKDQwWR7OcBUW/OI4/A/kr96LvUFb
	SX7ihJMEzdgMBZ1qHH0/sYPafZIB0ouLUyH5dd2x12uxXc/DqW9EuTLPGrC3H2IKGEVtFsEZNB0
	RUQkuUF/0TOXgI5toagYEVM+T3KZQMr0zg1FybYYhkrXOugxho/Lrb5aJtRIxjm5m6U6J8eeyYL
	rJCw/UMBpnZbRR6fNE9Kjf
X-Google-Smtp-Source: AGHT+IGZZ50y0Rg+YazkxRcuXHs8AxJU2gPFcm7tqgGjUmwO411s/spO05RWv5wnHcGQtV1ywUC/jQ==
X-Received: by 2002:a17:907:7287:b0:b48:70a3:d45a with SMTP id a640c23a62f3a-b50acb0e5e7mr433195466b.64.1759943045507;
        Wed, 08 Oct 2025 10:04:05 -0700 (PDT)
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com. [209.85.208.52])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b4ffb161d92sm416813066b.21.2025.10.08.10.04.04
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Oct 2025 10:04:04 -0700 (PDT)
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-62fc0b7bf62so56029a12.2
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 10:04:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWATmjPVqfdejTOcYytDMLrU0dXftksTKMZfzausAf5YhHd4vKJb4M26/mmtgE59xxuZOBWS82ojA==@kvack.org
X-Received: by 2002:a17:907:971b:b0:afe:d590:b6af with SMTP id
 a640c23a62f3a-b50aaa96bb0mr522464266b.20.1759943043731; Wed, 08 Oct 2025
 10:04:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=whThZaXqDdum21SEWXjKQXmBcFN8E5zStX8W-EMEhAFdQ@mail.gmail.com>
 <a3nryktlvr6raisphhw56mdkvff6zr5athu2bsyiotrtkjchf3@z6rdwygtybft>
 <CAHk-=wg-eq7s8UMogFCS8OJQt9hwajwKP6kzW88avbx+4JXhcA@mail.gmail.com>
 <4bjh23pk56gtnhutt4i46magq74zx3nlkuo4ym2tkn54rv4gjl@rhxb6t6ncewp>
 <CAHk-=wi4Cma0HL2DVLWRrvte5NDpcb2A6VZNwUc0riBr2=7TXw@mail.gmail.com>
 <5zq4qlllkr7zlif3dohwuraa7rukykkuu6khifumnwoltcijfc@po27djfyqbka>
 <CAHk-=wjDvkQ9H9kEv-wWKTzdBsnCWpwgnvkaknv4rjSdLErG0g@mail.gmail.com>
 <CAHk-=wiTqdaadro3ACg6vJWtazNn6sKyLuHHMn=1va2+DVPafw@mail.gmail.com>
 <CAHk-=wgzXWxG=PCmi_NQ6Z50_EXAL9vGHQSGMNAVkK4ooqOLiA@mail.gmail.com>
 <CAHk-=wgbQ-aS3U7gCg=qc9mzoZXaS_o+pKVOLs75_aEn9H_scw@mail.gmail.com>
 <ik7rut5k6vqpaxatj5q2kowmwd6gchl3iik6xjdokkj5ppy2em@ymsji226hrwp> <CAHk-=wghPWAJkt+4ZfDzGB03hT1DNz5_oHnGL3K1D-KaAC3gpw@mail.gmail.com>
In-Reply-To: <CAHk-=wghPWAJkt+4ZfDzGB03hT1DNz5_oHnGL3K1D-KaAC3gpw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 8 Oct 2025 10:03:47 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi42ad9s1fUg7cC3XkVwjWFakPp53z9P0_xj87pr+AbqA@mail.gmail.com>
X-Gm-Features: AS18NWDZIu5RNvY1OZ00h_c_VuBUBbSYmDpRpxsYacEd419cgpTVj3E3FoQRX_o
Message-ID: <CAHk-=wi42ad9s1fUg7cC3XkVwjWFakPp53z9P0_xj87pr+AbqA@mail.gmail.com>
Subject: Re: Optimizing small reads
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Linux-MM <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C50BC000F
X-Rspamd-Server: rspam03
X-Stat-Signature: 79uo6ykrm3smf96aqgb4a7migqwmees4
X-HE-Tag: 1759943047-238562
X-HE-Meta: U2FsdGVkX1/08LylWjvlU+THYkmqqfl3nHWsIl/llFsuTLA5nCwYJJzC+7DZrA8oWupQOpjAwquj0HTSa4DwSfznUBz0jcmIljTXmW6DxvTAoT/FxANhIk9CDDaTBV7a+rvW6QS4AxEIYXRasHOZAYgz+u7BaYU4n+Eoa3hmXjAWpjDjXnpZBK7olPT4zmEz5cgLuXvAHdgFRcYfAJCqkpXELPZ2M3h+QTu6o2AukRahz1XYNhQ/w5e1oZvIziH2JUioed8eEgHkkJYQN9ysed6XuBr1oGNn1Y1RITsnExsAwYdcZVua8EZv0ITwGLqUGE5/0gXolib96wM9oeTtgVg29eySnOFVbZsCpcQ7Ewup5CHSOdZVC/+w/tyJs8nvOYvxbrU79Sa87mlxksJsQ4qBvfhza7IOIZiyM5t0L2yFC0Kzp8PT93r1Vn2fMpvpJazK2kmQweoBSdzygiosIHvRco8lTwQS9lLCbPkmaApR58obDQnylvC87v3rf/VyWxRDAAL0BqJ1ZzgQ6ozsUa5klPUmthMyI01Immi172UeLlniaaHKs/uMFnEOzMtnOQXR27FlUKbDLvLSp7d+4FyMo/SVWUIJTcWOvULEHSUP0zeGQGhpY1dAO0+1i9OE4bhUQQ/KOmCl4C0D5vG67NOnmnVaawx3oecvQ7zfeFkJicxic/KAJR+1AEl3G81mO+W3ohDZYMtKCUWIOIUyiKkby3v7CedpBG5RH6vvUQJ5jFr245O8ZAxrf0JvlkdnJ0wshgEiGj1rpi7m7K84F0Sc7fyQJRE5GfdECyK45/YxzxtudVv6MT+xGxoAaxfnkne9vCYMZw7GJMxmC3IiozHs5DKRcGQu/8D+w2WJb4LTNOrk3dR+4BC7f+tAcNuSCHwrQRTfr4mNnfopVN08mJ18uMRL8T0qdpf2O2ip50JOlx/bZjt0dtYSmnsxWGgerBjrI2kRcwBATg3sFxu
 vwH3oiyb
 RD5H6GMyyDrSY8xNHYpPEs4XQFE4Zcjo8sZZfJ6chPR/qV88Bd5P0SgTZraIPybpBYSw2bZis89rv0lwJmfkFm0XrEsyX/8EW4SApp0JJzylIGvXdPwJfgaIWAx4nEa3MLpk4aSh8kiR3APTf0QcCh6fQiPRX6PjQBBZoL+uJnTZAl47C0x+uNdlFRVqY4hUJj3AIhTvbVNVZxph3ia32Il2MGr1qLSPKd+G7ZQNg0MRFuvquaV617YkeRVNHe47sOQIHWHRGgFgJYhUmf1AVz0rfNDD1gkjmz5fyzwR3cI11vHCsZBL4cfLeV/xsOxpRIRgZR+fejDE8EFZ19OPIlJmXKy2DVUkyM8veXorzWbbefN7rWx/jG/2n3kLNoS6hdCqrVUkhSBedkJbVpCiO2KgS5hHbqVTglFIrZN7Iw/qS2AEvzYcKMNI7N1VASvGH0S4zkkSsV+9upbfKXVi95SFQDAbLlBrxlp2Vk689+9JlPuS1r/ISORf+LygFNmzi4CL4q1bsXF0aUMK+NMPSOZGKNw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 8 Oct 2025 at 09:27, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Wed, 8 Oct 2025 at 07:54, Kiryl Shutsemau <kirill@shutemov.name> wrote:
> >
> > Disabling SMAP (clearcpuid=smap) makes it 45.7GiB/s for mine patch and
> > 50.9GiB/s for yours. So it cannot be fully attributed to SMAP.
>
> It's not just smap. It's the iov iterator overheads I mentioned.

I also suspect that if the smap and iov overhead are fixed, the next
thing in line is the folio lookup.

That should be trivial to fix by just having an additional copy loop
inside the "look up page".

So you'd have two levels of looping: the outer loop over the "look up
a folio at a time", and then the inner loop that does the smaller
chunk size copies.

One remaining pain point might be the sequence count retry read - just
because it has that smp_rmb().

Because while the *initial* sequence count read can be moved out of
any loops - so you'd start with just one fixed value that you check -
we do need to check that value before copying the chunk to user space.

So you'd have one smp_rmb() per that inner loop iteration. That sounds
unavoidable, but should be unnoticeable.

SMAP would done in the outer loop (so once per folio).

RCU and page fault protection would be at the outermost levels (so
once per the whole low-latency thing).

At least that's my gut feel.

              Linus

