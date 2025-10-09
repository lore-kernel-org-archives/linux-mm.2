Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23B8DCCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 17:29:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76E618E00A0; Thu,  9 Oct 2025 13:29:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71F6D8E002C; Thu,  9 Oct 2025 13:29:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E6998E00A0; Thu,  9 Oct 2025 13:29:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B87E8E002C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 13:29:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F09FBBCBF3
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:29:35 +0000 (UTC)
X-FDA: 83979262710.30.46FE3CC
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id C136A40016
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:29:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Uf5EJPHA;
	spf=pass (imf01.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.42 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760030974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dPx2sbctu0M7xDmpPB5FNDq3+BQ6qXvsQGjhqoyqbsU=;
	b=30VdwwLQ9GzxTSbb/MbxZCIhIo0Y99bIg9nTo3eHZhTySQL3+NNc4emglLtMOSiMnd6iN6
	fA9yOKgPqm1r2nSV6AYISwqbRRxara+ob0deNxcXVRFi+mXUIFMAWcUGaDa1dglNif7Z8T
	ZXiHT//kcKNoD2SGOe8uqOAgLPx/xvU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Uf5EJPHA;
	spf=pass (imf01.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.42 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760030974; a=rsa-sha256;
	cv=none;
	b=iYOPEEFaQ/o5ZNxPOePGVRtkXGf84Y7tYnjhKBLBv20nkftgyB3q5uofXlxmGrf8fy4Ewc
	CVp/BBL2rAPW+5oCSrBmoAXjZvFsFW6YroRDBcTLgSSe/IwsJDIMT9canYzLg3M0R/F42j
	d8iDlei1OABDJnUs3XAlzLqchJ8rPmc=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b472842981fso155158266b.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 10:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1760030972; x=1760635772; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dPx2sbctu0M7xDmpPB5FNDq3+BQ6qXvsQGjhqoyqbsU=;
        b=Uf5EJPHA8GGbw1wkrjisQqlqChUFoyhxKytiUJX2UTjoW1H29CsiGZkNHuckieymaI
         XCnEgU5m9XwCWv8RyfLHt7rrS43nBcDICYYgu55AraJmUQmwK6hUp6Q3NznYZ+pCYS7Q
         nVgB2I2KTI/A1fVoC6BTjFP8q8pzpbSFT051c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760030972; x=1760635772;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dPx2sbctu0M7xDmpPB5FNDq3+BQ6qXvsQGjhqoyqbsU=;
        b=N8OFtQ4W6UDouogSoQ7r04R0/mp2wPBAPUf1SMf/CvYh5jAmSqP43OSzXYGMOqqq/c
         wXeKd47Z9KbaUU61Ek0watFjjmHzA9n3fksJ2v/H+52SofLncEkZLTCOUIqZvB8Izx86
         swr5Pz9TH7QKzyrByvVbiwjQjhwl5KJL8B1TrpEZ79jb9u4Oaq9Pz6cOjiRqcfCrlxlL
         l1qfbA1MuauvhSPp2b9rYhaCC1+ojyIrKmBPPw6CkIpD8PFynH9B4xp4HzWrc1oFS9Yk
         2g+C2vjVNKcR0gIBm6QG1kdet/gr+BqSxTqOoIdsG+XzoCfJU2YCji1wulERGGM9Ii8F
         mjLg==
X-Forwarded-Encrypted: i=1; AJvYcCV6W6N7uoH0MBTEDe0i1+QsSGd2O0mHjAGEwbpIaFTsGJfd172lZ5rfFYaAtFTwTd+UPgBrGOQFSA==@kvack.org
X-Gm-Message-State: AOJu0YxlDXwfBVhiN6olP1bnJrtaNSrCAQEPqYOmSaCFD9REdE00KGbI
	raMzOIkN1ShiFJll34Qp7NJckyPyh3cvoaix2UCTksvCBmItjLlDl9H91Z9GmR6sGu4f20azvWC
	SfrEclmo=
X-Gm-Gg: ASbGncvlbssS4PpYxGIThAPptYgx7HKo+YO4wY59gG59elVOkWFi4rZ7/Ldx3SpiCFV
	O74hgrTYaaZ7Z4my14OROJUdgmnEzEln6rhMFYYViUAPl6Rw84TDaik9LrN3o5GlhIYW7sMVF7k
	hVd6KnNYHq4NGCrPFWOeKJESCcE7VL1tpMndf/KIeHnmK48/5eunSbA6HQc91gTDT0UNuiTezzL
	iP44oY07ZN0zDEmwtiMahRDwS6zs6k0JdaODgwlyuenMu4sTiPdMx0ykVO/BDPHro0XfgjIQ7MX
	54pP2JWlExCSdguFerNm7Hsbu+6xoP3uGf52GYd8KTFJLMwaUROrOMmm9D1cgDzVZo65xuvTarO
	ceNBLaTKTm91uDRGO99Sf6yoQKCpwaoD736maV1CFO7lCKLyuMe8JgZ12EiTTfONCA4gEHHc9m8
	XWzwqSEnXqHL5JNXoR9A0Cr2I9HORzvy8=
X-Google-Smtp-Source: AGHT+IEopII7JLK8lcyKgeVQThX1ay56eKGGmu4oK6nnILsE5Xh5BwZcmm7gjdk0WNQzLOhg+DCWvA==
X-Received: by 2002:a17:907:d86:b0:b07:957e:b64c with SMTP id a640c23a62f3a-b50ac8e52d9mr948015666b.52.1760030971633;
        Thu, 09 Oct 2025 10:29:31 -0700 (PDT)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b55d5cacc21sm22119366b.11.2025.10.09.10.29.30
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 10:29:30 -0700 (PDT)
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-639e34ffa69so1763945a12.3
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 10:29:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWNYZrRMH+CfyQ+XhjAwmyFt54NcK49FlXwhNugnUrSwUexgm0pKT7K1GImILIw5v0Lu/6LagDffQ==@kvack.org
X-Received: by 2002:a17:907:3f21:b0:b40:51c0:b2d2 with SMTP id
 a640c23a62f3a-b50ace27589mr886846266b.63.1760030970199; Thu, 09 Oct 2025
 10:29:30 -0700 (PDT)
MIME-Version: 1.0
References: <4bjh23pk56gtnhutt4i46magq74zx3nlkuo4ym2tkn54rv4gjl@rhxb6t6ncewp>
 <CAHk-=wi4Cma0HL2DVLWRrvte5NDpcb2A6VZNwUc0riBr2=7TXw@mail.gmail.com>
 <5zq4qlllkr7zlif3dohwuraa7rukykkuu6khifumnwoltcijfc@po27djfyqbka>
 <CAHk-=wjDvkQ9H9kEv-wWKTzdBsnCWpwgnvkaknv4rjSdLErG0g@mail.gmail.com>
 <CAHk-=wiTqdaadro3ACg6vJWtazNn6sKyLuHHMn=1va2+DVPafw@mail.gmail.com>
 <CAHk-=wgzXWxG=PCmi_NQ6Z50_EXAL9vGHQSGMNAVkK4ooqOLiA@mail.gmail.com>
 <CAHk-=wgbQ-aS3U7gCg=qc9mzoZXaS_o+pKVOLs75_aEn9H_scw@mail.gmail.com>
 <ik7rut5k6vqpaxatj5q2kowmwd6gchl3iik6xjdokkj5ppy2em@ymsji226hrwp>
 <CAHk-=wghPWAJkt+4ZfDzGB03hT1DNz5_oHnGL3K1D-KaAC3gpw@mail.gmail.com>
 <CAHk-=wi42ad9s1fUg7cC3XkVwjWFakPp53z9P0_xj87pr+AbqA@mail.gmail.com> <nhrb37zzltn5hi3h5phwprtmkj2z2wb4gchvp725bwcnsgvjyf@eohezc2gouwr>
In-Reply-To: <nhrb37zzltn5hi3h5phwprtmkj2z2wb4gchvp725bwcnsgvjyf@eohezc2gouwr>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 9 Oct 2025 10:29:12 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi1rrcijcD0i7V7JD6bLL-yKHUX-hcxtLx=BUd34phdug@mail.gmail.com>
X-Gm-Features: AS18NWAte-czLoaMmDi6pQnXuRVuv098dMpIVY51gdMJ4ypv7e8n0y7lkdhlF-w
Message-ID: <CAHk-=wi1rrcijcD0i7V7JD6bLL-yKHUX-hcxtLx=BUd34phdug@mail.gmail.com>
Subject: Re: Optimizing small reads
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Linux-MM <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000c634ff0640bd2493"
X-Rspamd-Queue-Id: C136A40016
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 9t3j4qdqr1aj4mri1ydoy3b4wzwqgd3a
X-HE-Tag: 1760030973-736568
X-HE-Meta: U2FsdGVkX19Th3a5nxKj5wbyASixh5pFKilR3OPqErfdW0Oqv5wvDOmZ9dAtCeayx1Ad7LloVZM3f4uJDrcpgbI1zeby1f+KNLlWwJ8GqEcu5BecQtblPfa/fM80MnQ33tEV01XNqem6bmSks37qdctOdZmW363rQ8U8YYQ2QuiYWCmn4THdgN+EKiYvw/VnkV1iGdMXglH2RaA/+OxQg30wPzzoLphvRnv83KAc7fFGSRZVJtG35JsO1keTMkEnPdg3vSmVJxAUrWcOSp+4hp5kfYYf60gQpDkawZHJrT5HfjqnhAkx/VxbsDhorGfRqVqR6YH1kvBjKFFG+tS0zVqWH8N3T7q1CmrzGhGkVrJIjQgLMYOZ7FtNV0H6GXKwRo72AacaK7/rUvfc2o6XIDEoe7+e6ni1b/b+lIzz/NnAjsKI2tj5JfkaAaKvhMRnkUuPxk/NVW+DJ+DAIZ4OQT7wJUdcbkKPkgLH3ZRGFKC+Qpm5ZVzlkTwmmy241k+g6Vpj4/fhfPpj/AJEJus/Iw9NjIrzzfHMSQn2rhWRvS/WHrT9XM7Nb8CZpAHdWJCDKRG6LOg1R6eXp8VCFkYoA8SJSII7KMf7GxE0Ptg4c3rERHfQg6hu9KF1ajgt3+t+pfhrgmzt45TS/a64dwY0Fl4j493EqgBpRhiBgItmXmhkQvHQ5Rh4Jo3Nx4aCIwHHpDanRYKrTxip/dSH6hz0zfbybo20bJK3nIRx4yEYY7EUJ2mDVG3Km5mLoWfCzYHNu/ZzZK5AyAnd52++hCyJgj9/+Z4vVmMpc5m4COyJT6Sj5b9dGWFpAxYn52npxQTIv9wopmsUsT/IddKhO7ZSQWhlBFzoijq+p6Nn07NF6rt35u5yRBwhaYS61BEOchxZYpE3dvx7MfxYVcgSdG8dAcByDTFJHKq1LFEJj/D7R/5oxMw+F+As2LrNQPHMLGTXW7rZDzP/Z0TY9tmQOJj
 abDqDdfL
 eNXXA5l6AW9ojSqoBz+FGszx09854ZWtJo1PAIZsBrWZXEAm3hAWhmfumPVGPJnY0RJYk/7qBDlIB2ZitRlwCr1AWm0Cn1ZeLjk6ZAD5GIoOcCDQtsykJfcLvxSQWD8wJE73o1duMqm0iMqtET/tI7jv7OiRrxqvkIsSk4PxAe4kQR1uNlqvIFeFbv8qsVMe93d4zV3uJCc9Rmi6GIMYdTbkiXU92tSa1JndENGwOeRfe3u9oOcknY83TKPJW8xi2gmMBxLIO4WXy/Eiapa1dR/YL8DnRnJVya+7K1U25dToshy16v3Na91ZP4m3NFYRAOycmFuDRFLL6qOTMqBkA+Ls2S+Z6m6uouVN8HwIvgFjbcsw2wYMgLRBxvNYq88yfPf0nzylFpu7vmsW4qvGPF88RLQPMVY3016yhj7JljUqh+jYyANp2es4EgBIuEN22b+ZZ4JAKOZxwcJCNmDO+fjuClS4Hm218U4ueJwXGqwbiBc/LQ7au/+N/fB+brA/X+hhFKtZkLo2PbXKaLvgc3Iij3ucNch7vo23lw784wtdxjl8q5VmTujgURMbYUX8lktcFWoUK48MGGPTS9eWFWCUz9TBiB4/2GYRJA6gu/00iGJSb74DSOa+wIBxwIqyda5rB8GJZ8r2DCn4jpjtA1q01kQXnSy1TBh3Hn16icuLpZ+E41bfTAdRwqk5ju6VHqiiHE+uWSA0P8cLKQPa9loQZqQECXjFM9Twp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000c634ff0640bd2493
Content-Type: text/plain; charset="UTF-8"

On Thu, 9 Oct 2025 at 09:22, Kiryl Shutsemau <kirill@shutemov.name> wrote:
>
> Objtool is not happy about calling random stuff within UACCESS. I
> ignored it for now.

Yeah, that needs to be done inside the other stuff - including, very
much, the folio lookup.

> I am not sure if I use user_access_begin()/_end() correctly. Let me know
> if I misunderstood or misimplemented your idea.

Close. Except I'd have gotten rid of the iov stuff by making the inner
helper just get a 'void __user *' pointer and a length, and then
updating the iov state outside that helper.

> This patch brings 4k reads from 512k files to ~60GiB/s. Making the
> buffer 4k, brings it ~95GiB/s (baseline is 100GiB/s).

Note that right now, 'unsafe_copy_to_user()' is a horrible thing. It's
almost entirely unoptimized, see the hacky unsafe_copy_loop
implementation in <asm/uaccess.h>.

Because before this code, it was only used for readdir() to copy
individual filenames, I think.

Anyway, I'd have organized things a bit differently. Incremental
UNTESTED patch attached.

objtool still complains about SMAP issues, because
memcpy_from_file_folio() ends up resulting in a external call to
memcpy. Not great.

I don't love how complicated this all got, and even with your bigger
buffer it's slower than the baseline/

So honestly I'd be inclined to go back to "just deal with the
trivially small reads", and scratch this extra complexity.

       Linus

--000000000000c634ff0640bd2493
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_mgjozf8j0>
X-Attachment-Id: f_mgjozf8j0

IG1tL2ZpbGVtYXAuYyB8IDgxICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
Ky0tLS0tLS0tLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDUzIGluc2VydGlvbnMoKyks
IDI4IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL21tL2ZpbGVtYXAuYyBiL21tL2ZpbGVtYXAu
YwppbmRleCAxM2M1ZGU5NGM4ODQuLjY0ZGVmMGRkM2I5NyAxMDA2NDQKLS0tIGEvbW0vZmlsZW1h
cC5jCisrKyBiL21tL2ZpbGVtYXAuYwpAQCAtMjY5Nyw3ICsyNjk3LDQxIEBAIHN0YXRpYyB2b2lk
IGZpbGVtYXBfZW5kX2Ryb3BiZWhpbmRfcmVhZChzdHJ1Y3QgZm9saW8gKmZvbGlvKQogCX0KIH0K
IAotc3RhdGljIGJvb2wgZmlsZW1hcF9yZWFkX2Zhc3Qoc3RydWN0IGtpb2NiICppb2NiLCBzdHJ1
Y3QgaW92X2l0ZXIgKml0ZXIsCitzdGF0aWMgc2l6ZV90IGlubmVyX3JlYWRfbG9vcChzdHJ1Y3Qg
a2lvY2IgKmlvY2IsIHN0cnVjdCBmb2xpbyAqZm9saW8sCisJCQkJdm9pZCBfX3VzZXIgKmRzdCwg
c2l6ZV90IGRzdF9zaXplLAorCQkJCWNoYXIgKmJ1ZmZlciwgc2l6ZV90IGJ1ZmZlcl9zaXplLAor
CQkJCXN0cnVjdCBhZGRyZXNzX3NwYWNlICptYXBwaW5nLCB1bnNpZ25lZCBpbnQgc2VxKQorewor
CXNpemVfdCByZWFkID0gMDsKKworCWlmIChjYW5fZG9fbWFza2VkX3VzZXJfYWNjZXNzKCkpCisJ
CWRzdCA9IG1hc2tlZF91c2VyX2FjY2Vzc19iZWdpbihkc3QpOworCWVsc2UgaWYgKCF1c2VyX2Fj
Y2Vzc19iZWdpbihkc3QsIGRzdF9zaXplKSkKKwkJcmV0dXJuIDA7CisKKwlkbyB7CisJCXNpemVf
dCB0b19yZWFkID0gbWluKGRzdF9zaXplLCBidWZmZXJfc2l6ZSk7CisKKwkJdG9fcmVhZCA9IG1l
bWNweV9mcm9tX2ZpbGVfZm9saW8oYnVmZmVyLCBmb2xpbywgaW9jYi0+a2lfcG9zLCB0b19yZWFk
KTsKKworCQkvKiBHaXZlIHVwIGFuZCBnbyB0byBzbG93IHBhdGggaWYgcmFjZWQgd2l0aCBwYWdl
X2NhY2hlX2RlbGV0ZSgpICovCisJCWlmIChyZWFkX3NlcWNvdW50X3JldHJ5KCZtYXBwaW5nLT5p
X3BhZ2VzX2RlbGV0ZV9zZXFjbnQsIHNlcSkpCisJCQlicmVhazsKKworCQl1bnNhZmVfY29weV90
b191c2VyKGRzdCwgYnVmZmVyLCB0b19yZWFkLCBFZmF1bHQpOworCisJCWRzdCArPSByZWFkOwor
CQlkc3Rfc2l6ZSAtPSByZWFkOworCisJCWlvY2ItPmtpX3BvcyArPSByZWFkOworCX0gd2hpbGUg
KGRzdF9zaXplICYmIGlvY2ItPmtpX3BvcyAlIGZvbGlvX3NpemUoZm9saW8pKTsKKworRWZhdWx0
OgorCXVzZXJfYWNjZXNzX2VuZCgpOworCXJldHVybiByZWFkOworfQorCitzdGF0aWMgYm9vbCBu
b2lubGluZSBmaWxlbWFwX3JlYWRfZmFzdChzdHJ1Y3Qga2lvY2IgKmlvY2IsIHN0cnVjdCBpb3Zf
aXRlciAqaXRlciwKIAkJCSAgICAgIGNoYXIgKmJ1ZmZlciwgc2l6ZV90IGJ1ZmZlcl9zaXplLAog
CQkJICAgICAgc3NpemVfdCAqYWxyZWFkeV9yZWFkKQogewpAQCAtMjcxOSwxNCArMjc1MywxMiBA
QCBzdGF0aWMgYm9vbCBmaWxlbWFwX3JlYWRfZmFzdChzdHJ1Y3Qga2lvY2IgKmlvY2IsIHN0cnVj
dCBpb3ZfaXRlciAqaXRlciwKIAlpZiAoIXJhd19zZXFjb3VudF90cnlfYmVnaW4oJm1hcHBpbmct
PmlfcGFnZXNfZGVsZXRlX3NlcWNudCwgc2VxKSkKIAkJcmV0dXJuIGZhbHNlOwogCi0JaWYgKCF1
c2VyX2FjY2Vzc19iZWdpbihpdGVyLT51YnVmICsgaXRlci0+aW92X29mZnNldCwgaXRlci0+Y291
bnQpKQotCQlyZXR1cm4gZmFsc2U7Ci0KIAlyY3VfcmVhZF9sb2NrKCk7CiAJcGFnZWZhdWx0X2Rp
c2FibGUoKTsKIAogCWRvIHsKIAkJc2l6ZV90IHRvX3JlYWQsIHJlYWQ7CisJCXZvaWQgX191c2Vy
ICpkc3Q7CiAJCVhBX1NUQVRFKHhhcywgJm1hcHBpbmctPmlfcGFnZXMsIGlvY2ItPmtpX3BvcyA+
PiBQQUdFX1NISUZUKTsKIAogCQl4YXNfcmVzZXQoJnhhcyk7CkBAIC0yNzUwLDM0ICsyNzgyLDI3
IEBAIHN0YXRpYyBib29sIGZpbGVtYXBfcmVhZF9mYXN0KHN0cnVjdCBraW9jYiAqaW9jYiwgc3Ry
dWN0IGlvdl9pdGVyICppdGVyLAogCQkvKiBpX3NpemUgY2hlY2sgbXVzdCBiZSBhZnRlciBmb2xp
b190ZXN0X3VwdG9kYXRlKCkgKi8KIAkJZmlsZV9zaXplID0gaV9zaXplX3JlYWQobWFwcGluZy0+
aG9zdCk7CiAKLQkJZG8gewotCQkJaWYgKHVubGlrZWx5KGlvY2ItPmtpX3BvcyA+PSBmaWxlX3Np
emUpKQotCQkJCWdvdG8gb3V0OworCQlpZiAodW5saWtlbHkoaW9jYi0+a2lfcG9zID49IGZpbGVf
c2l6ZSkpCisJCQlicmVhazsKKwkJZmlsZV9zaXplIC09IGlvY2ItPmtpX3BvczsKKwkJdG9fcmVh
ZCA9IGlvdl9pdGVyX2NvdW50KGl0ZXIpOworCQlpZiAodG9fcmVhZCA+IGZpbGVfc2l6ZSkKKwkJ
CXRvX3JlYWQgPSBmaWxlX3NpemU7CiAKLQkJCXRvX3JlYWQgPSBtaW4oaW92X2l0ZXJfY291bnQo
aXRlciksIGJ1ZmZlcl9zaXplKTsKLQkJCWlmICh0b19yZWFkID4gZmlsZV9zaXplIC0gaW9jYi0+
a2lfcG9zKQotCQkJCXRvX3JlYWQgPSBmaWxlX3NpemUgLSBpb2NiLT5raV9wb3M7Ci0KLQkJCXJl
YWQgPSBtZW1jcHlfZnJvbV9maWxlX2ZvbGlvKGJ1ZmZlciwgZm9saW8sIGlvY2ItPmtpX3Bvcywg
dG9fcmVhZCk7Ci0KLQkJCS8qIEdpdmUgdXAgYW5kIGdvIHRvIHNsb3cgcGF0aCBpZiByYWNlZCB3
aXRoIHBhZ2VfY2FjaGVfZGVsZXRlKCkgKi8KLQkJCWlmIChyZWFkX3NlcWNvdW50X3JldHJ5KCZt
YXBwaW5nLT5pX3BhZ2VzX2RlbGV0ZV9zZXFjbnQsIHNlcSkpCi0JCQkJZ290byBvdXQ7Ci0KLQkJ
CXVuc2FmZV9jb3B5X3RvX3VzZXIoaXRlci0+dWJ1ZiArIGl0ZXItPmlvdl9vZmZzZXQsIGJ1ZmZl
ciwKLQkJCQkJICAgIHJlYWQsIG91dCk7Ci0KLQkJCWl0ZXItPmlvdl9vZmZzZXQgKz0gcmVhZDsK
LQkJCWl0ZXItPmNvdW50IC09IHJlYWQ7Ci0JCQkqYWxyZWFkeV9yZWFkICs9IHJlYWQ7Ci0JCQlp
b2NiLT5raV9wb3MgKz0gcmVhZDsKLQkJCWxhc3RfcG9zID0gaW9jYi0+a2lfcG9zOwotCQl9IHdo
aWxlIChpb3ZfaXRlcl9jb3VudChpdGVyKSAmJiBpb2NiLT5raV9wb3MgJSBmb2xpb19zaXplKGZv
bGlvKSk7CisJCWRzdCA9IGl0ZXItPnVidWYgKyBpdGVyLT5pb3Zfb2Zmc2V0OworCQlyZWFkID0g
aW5uZXJfcmVhZF9sb29wKGlvY2IsIGZvbGlvLAorCQkJZHN0LCB0b19yZWFkLCBidWZmZXIsIGJ1
ZmZlcl9zaXplLAorCQkJbWFwcGluZywgc2VxKTsKKwkJaWYgKCFyZWFkKQorCQkJYnJlYWs7CisJ
CWl0ZXItPmlvdl9vZmZzZXQgKz0gcmVhZDsKKwkJaXRlci0+Y291bnQgLT0gcmVhZDsKKwkJKmFs
cmVhZHlfcmVhZCArPSByZWFkOworCQlsYXN0X3BvcyA9IGlvY2ItPmtpX3BvczsKIAl9IHdoaWxl
IChpb3ZfaXRlcl9jb3VudChpdGVyKSk7Ci1vdXQ6CisKIAlwYWdlZmF1bHRfZW5hYmxlKCk7CiAJ
cmN1X3JlYWRfdW5sb2NrKCk7Ci0JdXNlcl9hY2Nlc3NfZW5kKCk7CiAKIAlmaWxlX2FjY2Vzc2Vk
KGlvY2ItPmtpX2ZpbHApOwogCXJhLT5wcmV2X3BvcyA9IGxhc3RfcG9zOwo=
--000000000000c634ff0640bd2493--

