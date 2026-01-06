Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35A9ECDC192
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 12:43:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64F536B0088; Tue,  6 Jan 2026 07:43:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FD0F6B008A; Tue,  6 Jan 2026 07:43:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FC526B0093; Tue,  6 Jan 2026 07:43:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D1466B0088
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 07:43:02 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B550CB9CA1
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 12:43:01 +0000 (UTC)
X-FDA: 84301503762.29.4047A4F
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf11.hostedemail.com (Postfix) with ESMTP id B94EB4000A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 12:42:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Fs4PN+j+;
	spf=pass (imf11.hostedemail.com: domain of maze@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=maze@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767703379; a=rsa-sha256;
	cv=pass;
	b=Ds30aa8wvuEsTyHMgRHF5+nkpR5HT1bKtCD+YK9KLQ0hiJdTE+sWITta7WRZBy2nN9ZrLq
	/QgWjMdkviOOB5YpewPLuvKPxrbiTCujnu5aU757bCL77hOQXbTIxLADwMxiMjoTwvSsZ9
	LxZSA5KA0fTM69c5WV+q2DXnGPtPYRY=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Fs4PN+j+;
	spf=pass (imf11.hostedemail.com: domain of maze@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=maze@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767703379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6VaaRHRd5E6uRpWJGcDGRBcsl4ux3CBEvtldX20kevU=;
	b=59cauBbATi3ROW/lm2iurooqjsmTHxZnj4iYE7IE75+lSdFSlbROvtuYNZ20cEsyoIhYL6
	Bf8jtKThIhfmPyzVWOIrjPjnSH/AAsX7mrkMg4SLqbM6ML3EkFZ8ICHSADI4vpR3g+uh9d
	2ssHHSHly/JT3lcTbYcDo8eZk9gsQW8=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4f34f257a1bso315431cf.0
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 04:42:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767703379; cv=none;
        d=google.com; s=arc-20240605;
        b=khj3wsnjtqoJq5TF2myGHEUyzfxp7gkQlCcMPZXIJgv9vGMxkXgv1eT/Ir+PaY9zet
         1fDNwFPCajdLxbUna7Fsm+foe6GriGxivUjvPcDfrEDYyn0CnjvseDcZdtP9/JeGOmXU
         A35zVadu57MP5Ex+c1/Xvx7anWvhEL+K+fDRrP/nwedLtPQM7xMBAz4smewjbHHQq10V
         i7g2mFhelZ7HGH6CN/mmyyRCHdTKo3EFXksjA6+WCVr1k7ml2ayCWHMQNgqv4lhNeUTY
         VYVRep72og+6HQ1/q4VPPk0MHBkgcs80KA2FF87ewxpddXwfDuSbElRnpToxQukKXSkY
         Httw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=6VaaRHRd5E6uRpWJGcDGRBcsl4ux3CBEvtldX20kevU=;
        fh=NIu0QlvIKKd2sJDAspNggYXHiChVVgQY3ctjQJ3VRzU=;
        b=fdtw+nAu0sr24f0iKJnOP7dk1rzoUYrpQIWSGuLA4gUYIOu0KtS17z0fERGld6+vci
         jxU4F7K1aoupM/3qq8WIX7ZoI/EkwUIQRCitRqyEew8HZOxi9jqYNmudPDon9X08HOei
         cnlfDpXlEh8h56GfQboyah8M3/QSv8/FOU/ee9o1f++La7GoetEV7BUxqQ4tfSbAPbV2
         p7N1AaVsDWlk5qm5OFstiIkX85fb0eSX+LdNlVx64lpIixrSHYJPhH5iKLDbZmDwd83h
         Hzpbj4j7LrtbcBTobpiNtWn/+Z3F7c52CZ7URFcuM7E8py+2xhmyd/in/oSwQvBlrxFd
         XVLA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767703379; x=1768308179; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6VaaRHRd5E6uRpWJGcDGRBcsl4ux3CBEvtldX20kevU=;
        b=Fs4PN+j+bV1XHrv+K9nm2atppzTDPAVuwOT8/i1n4P4FwSJrlUy9z7ozUq6bj0Zwk2
         eQAhpEyNElqm33X9bE2VIfNJvdxFsLrcrYdCDfKaDuRQ+srz79lWIE2Pda3WGltX+BYr
         AKZNUkf51nmXmsmAxIXM3ridU19UvQsZnjGBwNYsKOxB1y0U1A8uaEo2Tt//vq2he4sB
         mliZlH3cv9ctYbTFRP+0QmO5fteu/OUmugTlduboEIIB94MKuKQX/oK7D8T4m/+EgUaw
         Ni4NU/xqZwGn8HlVDuZy0behaD5GrRRNnH3gX3jDhNPxndgT+OTn8HQSHYW2kLDzT+KG
         bRRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767703379; x=1768308179;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6VaaRHRd5E6uRpWJGcDGRBcsl4ux3CBEvtldX20kevU=;
        b=sYmOjDYeM40DCjBAkw+rUPujy818o6gKvZRLxO0kmcyV9SwZW7vSAJYoVHg2/blga5
         gRM2Px+K0xrAcpjrO0pmU9H4tl4Truo7szegyMDVCM58F+dr2A6UGn12cqJDr1BmiQWL
         SnwY0YI8+cxfaUzcnBg/IYyFAp6O+5l8HsRz49k3HeVb0olteZkEOZiJvx1r6DjOU7gV
         9/SwvP5iKjok2BRbCcJZoKeEIqFj1OnBQ1Z+Cmwx8uaCtGz6I+MmEFOJUYdH92FMkFN1
         uxZeJWGfyLIeqKzHo8QjE6TZwL1Kox3FOF4vXKd0dF3e9zscdkjQtF8k+w9v4oaZ3Yrx
         EwNg==
X-Forwarded-Encrypted: i=1; AJvYcCUylf/HLj2K025oyAiuedBTkALnZcSOu3W8xwm6XLCL56HSueWtyoqCXlOQQ1DwkPgOBXb0YJqrcw==@kvack.org
X-Gm-Message-State: AOJu0YybXBTQAJkOAnlWuVgEZ+bH8QL3tHHKVDLqrIfNotAURF98f0EI
	IbFOyb+lOyFG5DVyPqh7IEbfrcnmvL4LzGPyoZPmucf8lIfUn9whefdVq78wDFEHCwWtB9Do65v
	LKnwQHj5bKMwdeftOOrzwGMji1+CImLpN4GDP+lB3
X-Gm-Gg: AY/fxX4xRdaPS+IGRsOtjpjI3/Gn1ehZkMff/PgOcFSlDP76cRznztSE56cEe7f+WF3
	ly0GT8SaEOTS5ZNl6QPROjDJUjCY99jEIbYTSkkXMspvHv/x43eWV2/42yG2sc2dKzuWmV6x3Us
	HiH5nEGtnf5W0Ndxfw1FINQC+HlXiHUXVX0ziOFckc1IiTxZ9UR/34f2iZF+8wu9NNGbBEC3wMU
	HqavqRCagllMZGmJjxWY0fXUTiLCUBVC+qNwPxSTGBE8vzsFOOBFXFF2w1DEvojsNsN2rIufCU8
	MCKCYUaK+XyB11HJr7OpPVFWCucwnSf+ZQN4u8M=
X-Google-Smtp-Source: AGHT+IF2dfr0SMyFQSL6v0PMc5yR7XxJ4qkpwDrq4c4RXHNO+Xdso8ZsWtwR+M8KWBYE6f6ityYl33zzMf6nK+95nws=
X-Received: by 2002:ac8:5fc5:0:b0:4f3:b0f3:62bb with SMTP id
 d75a77b69052e-4ffa963a05cmr9713571cf.13.1767703378488; Tue, 06 Jan 2026
 04:42:58 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date: Tue, 6 Jan 2026 13:42:45 +0100
X-Gm-Features: AQt7F2qAI1ZtC3RYWs2Wp-HOwXoK03sV5LG9X9mZr-LKGvVUmzl8KqyB9wnW6k4
Message-ID: <CANP3RGeuRW53vukDy7WDO3FiVgu34-xVJYkfpm08oLO3odYFrA@mail.gmail.com>
Subject: KASAN vs realloc
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: joonki.min@samsung-slsi.corp-partner.google.com, 
	Kees Cook <keescook@google.com>, Andrew Morton <akpm@google.com>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Danilo Krummrich <dakr@kernel.org>, Kees Cook <kees@kernel.org>, 
	jiayuan.chen@linux.dev, syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, 
	Kernel hackers <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: B94EB4000A
X-Rspamd-Server: rspam04
X-Stat-Signature: y4y4tf38srjwzs1aks8jtqqsw9rso4p8
X-HE-Tag: 1767703379-852808
X-HE-Meta: U2FsdGVkX18632sF3GuokTYFdaut433wET/0GwqRKKFIgtMWOx+PW40WXULDyTTdrcR/E1zE/dFb5CbnG/ohAhnFZ/rIppqh3dKAJO8HQWdZZR2CLCpxGof60E6N/vl9icquUFwzduzyEkdEDey1O7yCmJEbkNkqK6gGgtWTB/4sUiVSzTrqg7bPDpKyYaNpjf11sHzVoM2KyQH6dZgzHB7ScOVlJNKAy4ijluGr3VNSDlI9o/pXfl0ch9byAXILQpEYXXjeP9bL1cFauznOUaE7a30SM2EIp1SWG0UCC2SOKZnJO3YOSuKtikcry3v0L08Tcy0DAAcesI7GdYfMy7yxiyMusApvykw6sJY1OjW/sCb9Dbjx/IADnxGomlxGXxoFC+bsw2Li0nDrTV5Ha0I+2xcnwUcCbcqYOA7JcXZchv4ScLspFQgZFJh1jDZce5yre/s1GmmxrE9cB7bJ5esWWfD41x9BgdgkyDHiF85RFndrBXSb0ekG6Y3cpbmDhs4HUu1Svm4ouHOpWfuMCMiEUJ3So39h/+KRBLCZH03dcgQ2XL2vFjgkOblBCFyZjurwU8TOZSZdw0w4M9GtyWEiJeP7G79fqPosmjp3BXol0k0HdQZwnApfO8/6TANiYi6D340xjgCT633PFXMpgbvdTerN88vO5XRAMxM0fhGOMH2Bp33vOdEhm+LFCXKR9jX2f30S2CCn3GTadagA1ad4Tnc3fMkGk2wHhQ1Z7ex/EFRuH6Nz1exHWG0uSx5xF45Q32A1MPuuUm7X7cGuW5bB+TtZs8bj1jVKAsALntQylVKGQ44zHAJp9A9tnEM5laIr8b4bTqnWdF4pBB6Cgkhw81Yr0sX9/rc2+e63/XoIkrt9XWJqAzfOxLgpiWeg/Aj+8REASMJ4YvLU0jM0R5/Fe2wb4xAhYH3HdeC+hztw3vCw8dSsfxj610Da8UNaRxDxp3bnQUmMz+OEFdM
 +k8KTCHv
 t9/WSBGSBAxlN8DJ0PQJm/rCWcer+wdHCt7RIVFIp0MgJs7oeXRmGiaXnOr8vrKVVVH8KKRx1iT6nn5YJU56LoOR4CMbeZvnMdGFrwOGtKxn6dMLDJr2W1ehsusZX1qU464jlc07RMmLsTY04cOwC1zqQjw3RUv9/PHFS7zMcmWdYOCi3e3hANyQGlRF+twTKTY6mlNn+VSx7TR0ashlukNNpqOfWLkGMJI3gB2GBCZlkVf/yZDR9KtghfT7ss6I5RQw/Uua2/wxFFgGXDtIN9oAUmQQRKdQC8T32egSUa1O/cyDnfZRv39vtznDigWzijkuV51AqutUML6XRjVNKSqWPYzcM3TuItcmBJIwsAHx81S6X6+sK7dRpV5cEWU0tjMjvLY+YhZNjdD2W0BW+Q4kjJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We've got internal reports (b/467571011 - from CC'ed Samsung
developer) that kasan realloc is broken for sizes that are not a
multiple of the granule.  This appears to be triggered during Android
bootup by some ebpf program loading operations (a struct is 88 bytes
in size, which is a multiple of 8, but not 16, which is the granule
size).

(this is on 6.18 with
https://lore.kernel.org/all/38dece0a4074c43e48150d1e242f8242c73bf1a5.176487=
4575.git.m.wieczorretman@pm.me/
already included)

joonki.min@samsung-slsi.corp-partner.google.com summarized it as
"When newly requested size is not bigger than allocated size and old
size was not 16 byte aligned, it failed to unpoison extended area."

and *very* rough comment:

Right. "size - old_size" is not guaranteed 16-byte alignment in this case.

I think we may unpoison 16-byte alignment size, but it allowed more
than requested :(

I'm not sure that's right approach.

if (size <=3D alloced_size) {
- kasan_unpoison_vmalloc(p + old_size, size - old_size,
+               kasan_unpoison_vmalloc(p + old_size, round_up(size -
old_size, KASAN_GRANULE_SIZE),
      KASAN_VMALLOC_PROT_NORMAL |
      KASAN_VMALLOC_VM_ALLOC |
      KASAN_VMALLOC_KEEP_TAG);
/*
* No need to zero memory here, as unused memory will have
* already been zeroed at initial allocation time or during
* realloc shrink time.
*/
- vm->requested_size =3D size;
+               vm->requested_size =3D round_up(size, KASAN_GRANULE_SIZE);

my personal guess is that

But just above the code you quoted in mm/vmalloc.c I see:
        if (size <=3D old_size) {
...
                kasan_poison_vmalloc(p + size, old_size - size);

is also likely wrong?? Considering:

mm/kasan/shadow.c

void __kasan_poison_vmalloc(const void *start, unsigned long size)
{
        if (!is_vmalloc_or_module_addr(start))
                return;

        size =3D round_up(size, KASAN_GRANULE_SIZE);
        kasan_poison(start, size, KASAN_VMALLOC_INVALID, false);
}

This doesn't look right - if start isn't a multiple of the granule.

--
Maciej =C5=BBenczykowski, Kernel Networking Developer @ Google

