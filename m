Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EFE1FD0048
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 03:34:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17FBE6B0005; Sat, 28 Feb 2026 22:34:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12E136B0089; Sat, 28 Feb 2026 22:34:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 002006B008A; Sat, 28 Feb 2026 22:34:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DFC5F6B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 22:34:26 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4B59D1C4A6
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 03:34:26 +0000 (UTC)
X-FDA: 84496076532.19.6CF7C4F
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf07.hostedemail.com (Postfix) with ESMTP id 24DD74000F
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 03:34:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=atqmPBN6;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf07.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.46 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772336064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e8blWJ8aOcNrTsAtzklQWdnEP5eXPHVO124aNy2APDA=;
	b=JjREmh84fVbXp3Y1nzxI5S40HW7VnazUtCCS3pMf65veXM4MNYqASn/Ha5biAfB/hZOWwU
	q2/zk3stZzMwh9iLOizYpHaKkAqtOVutC/Sw179YwM1E1FnhMXXirSKLnEbKPMZknX47vc
	3Zkk92YIY0pl8oXIqnsp+5XMdanJ+jE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=atqmPBN6;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf07.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.46 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772336064; a=rsa-sha256;
	cv=none;
	b=koWja30Ienhz2AL7e3BG5rfeFPBgce/VZc7ujUp4Qn66Wd+eytXNwdWJoDY5KS7opViA1g
	kfuciVwY34A0dr8tXAjk+XFBIp3zYnHUwSzMB5Hr6pBJxJ9nskRQ9ZaL9MW+E5rr2nlU7U
	KDvmwS8+pzJoEBay/EUcP5kP34y0+VY=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b936505e7a0so410297766b.1
        for <linux-mm@kvack.org>; Sat, 28 Feb 2026 19:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1772336062; x=1772940862; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=e8blWJ8aOcNrTsAtzklQWdnEP5eXPHVO124aNy2APDA=;
        b=atqmPBN69qOQ1KKTtzE2qLu6z6BkRUe+xeF/UNTh9+xPv9Te0G/qIvqw+QHTFTaIIO
         eANP9kPYADVUMWPYMZsJnkyK0EOC05bFfEmGTYezz9XbVvJvxGe0kuS4reZ3iGMxDcgn
         Ez+I1v1Vaz6aaUeIFtxSoSPry6ltPDKdx9m+E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772336062; x=1772940862;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e8blWJ8aOcNrTsAtzklQWdnEP5eXPHVO124aNy2APDA=;
        b=ELMFdJf1Ot7DV51Ty1kIfnUhr4GvHGDGbi37+hTC9wJEpEf2Pw6IAhsc3EmIc0UqHj
         6134C9br6UYSYNK7gzIEQMmY4GUOdAqIdmRZT0TPpAkaIY3jOgZy9BQ6ryMqa+jiZ1Zp
         Y1lm+s+kpCoFLPna5Up4o4Yqne4czcC8q8uRpG8H7cf1f9/2kJoZ3c8faiWxt/ByPTzN
         4o91u0PG7cnC33RS9tTv90gT5owliXKQILvxMezbtYslkPHHrvfCHeLbfeh/GGStLRAg
         CUqlPBW0kdTW0INo5WhE2yn5VcwRVz3lNn7epG5pmU0Jade0lLhZNTjzb6yAy/NqctLA
         KTyg==
X-Forwarded-Encrypted: i=1; AJvYcCUsu3HcmxDeyao0tY9I9XhkQ3pAVAqhl371m6v5ssDI9crlqizHvGftlMr5J+Do3u//Ia3W3yAF/g==@kvack.org
X-Gm-Message-State: AOJu0YzoYYF5WFSuSZi9A9nGXz/nRtgI7cE8ENrZPxOl+/btyW9cHVb/
	+tUoIYEOF29fQ+qMhEXe4Lv5tzIswf2jmP7RY3JIJBnhqOxkKd/JH4oKKRS3/W51xmdc0vJlGxt
	BgsPCE9U=
X-Gm-Gg: ATEYQzxg7QixLg66C2LhYeYS1hmYy6UNN5pzab82QrXHdO/cg0cxLozceXcBP1XiFlU
	+BYPADeWHfQQds6Ecv5vOT3E80W6y0tK1xqsHqw/r1+BSd5CnhlrSltW85AocpLyi+EMWoo9OXO
	sbqSuYFvB8K+X2oM0N4RK/AbpNL1fnxcV0B+NGaWzflUdxOcqMHqdIEz8J0nhia91FCvypvVMJC
	9PpM9FbGinvR9VB0rKr0N/oa4jbFhZV8n2cm4NWeSqwJrzqVr10K1MCxY3JYfRFzFlqJQ+zifTz
	tiMJMamw3MXZ/lFMbnqLNydDNKW1g4BWFGlCEeQ6AhZT6gpYvf+eB/71rBH1GFFyZVFAYQrPeWU
	++9NEhEQB3ipLrYnZz0o7pIsFY8jmw8UoxtEGZcO/pjnIKAoGnmzUUo58o21vxBEOFQn5DTk2pu
	HRko/xbZxRorVEGBoD/PLDjiSeHY83VO/rTUpJ9Dg7pfLTBJ+8DNAv76v3mIcOHiga317ENsfNI
	4RFhZDgkw==
X-Received: by 2002:a17:907:3d92:b0:b3a:8070:e269 with SMTP id a640c23a62f3a-b9375932ab8mr548424466b.14.1772336062105;
        Sat, 28 Feb 2026 19:34:22 -0800 (PST)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b935ac51431sm317668666b.17.2026.02.28.19.34.21
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Feb 2026 19:34:21 -0800 (PST)
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-65fa79f5c98so5662340a12.1
        for <linux-mm@kvack.org>; Sat, 28 Feb 2026 19:34:21 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV2EG0nonQZq3tbEUNatiWypNd0pIKVo6EuVC13wcX508HHwRofPw3dgV3cyBO1rIyHO1kRMxXThA==@kvack.org
X-Received: by 2002:a17:907:3f07:b0:b93:6bd1:a4ba with SMTP id
 a640c23a62f3a-b937580cabbmr562817066b.3.1772335665433; Sat, 28 Feb 2026
 19:27:45 -0800 (PST)
MIME-Version: 1.0
References: <cover.1772120327.git.gladyshev.ilya1@h-partners.com> <20260228141941.f6fec687aae9d80a161387f4@linux-foundation.org>
In-Reply-To: <20260228141941.f6fec687aae9d80a161387f4@linux-foundation.org>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Sat, 28 Feb 2026 19:27:28 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgfs7KqS8pD8F9F9yC8jwSgQtmifytbmmXVfz9xXrQzuw@mail.gmail.com>
X-Gm-Features: AaiRm531sCUwemUstTzZzIWd7hU2AnSIoxD7IQcnp8JZvGjd-leCm0f4hxCzjVI
Message-ID: <CAHk-=wgfs7KqS8pD8F9F9yC8jwSgQtmifytbmmXVfz9xXrQzuw@mail.gmail.com>
Subject: Re: [PATCH 0/1] mm: improve folio refcount scalability
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Matthew Wilcox <willy@infradead.org>, Yu Zhao <yuzhao@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Gorbunov Ivan <gorbunov.ivan@h-partners.com>, Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Kiryl Shutsemau <kirill@shutemov.name>, 
	Dave Chinner <david@fromorbit.com>
Content-Type: multipart/mixed; boundary="000000000000c58470064bee0d01"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 24DD74000F
X-Stat-Signature: tkk9wn3p7rygjrexa198nt4rmtexydpy
X-Rspam-User: 
X-HE-Tag: 1772336063-472703
X-HE-Meta: U2FsdGVkX1/rYhcZS//3/E/eNyBPnHqwm1cR5u9nZx2FHFhFWW87Vsay7oEyly+lcdY4wywVGzzCqDiBUqKcXhVHA6HnOHOojU0FzRBh9JgJ4ck6fBjRaJoH8q2Fz/B4oSezi8Bq3vPMxcyJDeM+eNnHJuGt2avuXtM9r3O+sCexMPDhK9aVfiTNOLoHmVULdxYxVhp6oXTSom8Qc4GqkhRW08OR7jX3sbm0DZUkI1nWgI93xwccsGqEuxGubO6p5qVSypnBkkodgyYZjoSLYun2VE01L2YD7XY4Od0Pzrx0HHLTF2zEnC7pdQxZJbO8Sf3OEzTXDcxiPHTtdmgA3sRonoYfk97TSiWc1sQx+3FctXNpU3DyVG2KGBQj1z6n9qBWSWKQ8tpG96nEc+4cXqtgZkU0Yyzzg1fEbAE0hlQb0EeXVujYDKDeJv8jPvnMOfPw74qGwCldNCGqXq2zHTYXzk6axUZ7kU5nMOicWh1xcwcdVEu/swDLY6Dxr1ybEFwMLn8TEMJXglF81xuhQm9smv+jeGPcXfK5rP/KrzCGl2uEiA+RhcPTAfFctaohLVsQbwDK1h14zRor5ZQI82ZauuZlM/NG4kC1QshKvQ4R4fOVUoC79cibWYUmrcmEJHIRb/gKo8Y5x7Sg/npzUg7jusxUu+qJG5Lco1VuSv/C78MH+NgBcYDCDzPQa4mOm/Mt7oQOq98rvv6UCIzuXuahI8TqJMqQlU3o7mjJfJZ6dXLlBdY4YbcKpjotAFQ3oLhtAfYmg6lSv1bWGSqOLDnPc68nZVkvJlnlPqZAkJc2rJB+/SE1J+0vqOBbact9tAu1A1RWsUsVrerZkey5+S4jBCjVOPCvtMbNdbDI/D/t8K/aY93LFK5BeSF9vDEveSHdnuXXonHYN6AgSpmyxwPrkL9noCyNBWPEHtLp3uUPgHiZ12+kVfqe61hMUuV02kM4zPJYrC5ugHBINj1
 SCOoaeJM
 skMci12kLsvHSG2NM7mQuxP2sYYCjKK3KgK41LCuQ3p4aOO/xCmGVF+sCKwOuBCz8kZBNtpRasXdb9QSeUhfo5gnzt1kFZr6oCTMEUgWV4YL8zbRR2Yh9R+UkJIbDETrcFJnwm24rF3hRRKYVWUKr/uBnpBo+Du1wSB5QOtG79wOXbaBS9FZpcDq4YBD5tPBKzJU8e4TixnaksXSqKLEokvLDDGNYgJI5LvmZnc936wLYsqD6SIggAod1T2eZEzs6BR1es6GoYvmzkPkn5Gs9jRtwJto08NNJL82Y0HWn29XwRvFa1DPufWeBwtwE34kNVQ+6uXCzAHUKEUIxWOs8/Qv5c1nBK/6WvzXY4bp24OzT9cS/GiToZqU0XaAMCD2EyIzyIe+3ISQ18K/sWALjgilM4dKUDoV9gtZtxsAsn4dJKFb4+guUmB1wiZylxPYvsDfT0Dwr+183UE/O93V9/OrgfUaX3HDyd+IrjS3+NdVe/zKdCDrOzCGhAXbATk4Q04jY/xUJFP4fpMPaXObZNoNxSDJR3CfV4X6jMULsz4FpNTF6a/4+AKANzBfZBtl0/s5lveHtyG4zP29oT1NivKky6W0Rb35xTupz/lJWSoHWV9ohFm/xVk1nTyBPfexOElc5Jp+uYaxI0CInX7Ewf5tSc4Ub2aVpSB5q9uQYWr3xelhncipwiQwWNSoERC3CXD12Oai+PLAvMHn8f3GWkctTNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000c58470064bee0d01
Content-Type: text/plain; charset="UTF-8"

On Sat, 28 Feb 2026 at 14:19, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Well it's nice to see the performance benefits from Kiryl's ill-fated
> patch
> (https://lore.kernel.org/linux-mm/20251017141536.577466-1-kirill@shutemov.name/)
>
> And this approach looks far simpler.

This attempt does something completely different, in that it doesn't
actually remove any atomics at all.

Quite the opposite, in fact. It adds *new* atomics - just in a different place.

But if it helps performance, that is certainly still interesting.

It's basically saying that it's not the atomic op itself that is so
expensive, it's literally just the "read + cmpxchg" in
atomic_add_unless() that makes for most of the expense.

And that, in turn, is probably due the fact that the read in that loop
first tries to make the cacheline shared, and then the cmpxchg has to
turn the shared cacheline exclusive, so you have two cache ops - and
possibly then many more because of bouncing due to this all.

Fine, I can believe that.

But if it's purely about the cacheline shared/exclusive behavior, I
think there's a much simpler patch

That much more simple patch is something we've done before: do *not*
read the old value before the cmpxchg loop. Do the cmpxchg with a
default value, and if we guessed wrong, just do the extra loop
iteration.

This attached patch is ENTIRELY UNTESTED. I might have gotten
something wrong. A quick look at the assembler seems to say it
generates that expected code (gcc is not great at this), with the loop
being

        mov    $0x1,%eax
        lea    0x34(%rdi),%rdx
        lea    0x1(%rax),%ecx
        lock cmpxchg %ecx,(%rdx)
        ...

ie the first time through we just assume the count is one.

And yes, that assumption may be wrong, but at least we don't go
through the shared state, and since we got the cacheline for exclusive
the first time around the loop, the second time around we will get it
right.

What do the numbers look with this much simpler patch? (All assuming I
didn't screw some logic up and get some conditional the wrong way
around - please check me).

                        Linus

--000000000000c58470064bee0d01
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_mm76tjhi0>
X-Attachment-Id: f_mm76tjhi0

IGluY2x1ZGUvbGludXgvcGFnZV9yZWYuaCB8IDE0ICsrKysrKysrKysrKy0tCiAxIGZpbGUgY2hh
bmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9pbmNs
dWRlL2xpbnV4L3BhZ2VfcmVmLmggYi9pbmNsdWRlL2xpbnV4L3BhZ2VfcmVmLmgKaW5kZXggNTQ0
MTUwZDFkNWZkLi5lZDNmMjYyYWE3ZjEgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvcGFnZV9y
ZWYuaAorKysgYi9pbmNsdWRlL2xpbnV4L3BhZ2VfcmVmLmgKQEAgLTIzNCw4ICsyMzQsMTggQEAg
c3RhdGljIGlubGluZSBib29sIHBhZ2VfcmVmX2FkZF91bmxlc3Moc3RydWN0IHBhZ2UgKnBhZ2Us
IGludCBuciwgaW50IHUpCiAKIAlyY3VfcmVhZF9sb2NrKCk7CiAJLyogYXZvaWQgd3JpdGluZyB0
byB0aGUgdm1lbW1hcCBhcmVhIGJlaW5nIHJlbWFwcGVkICovCi0JaWYgKHBhZ2VfY291bnRfd3Jp
dGFibGUocGFnZSwgdSkpCi0JCXJldCA9IGF0b21pY19hZGRfdW5sZXNzKCZwYWdlLT5fcmVmY291
bnQsIG5yLCB1KTsKKwlpZiAocGFnZV9jb3VudF93cml0YWJsZShwYWdlLCB1KSkgeworCQkvKiBB
c3N1bWUgY291bnQgPT0gMSwgZG9uJ3QgcmVhZCBpdCEgKi8KKwkJaW50IG9sZCA9IDE7CisJCWZv
ciAoOzspIHsKKwkJCWlmIChhdG9taWNfdHJ5X2NtcHhjaGcoJnBhZ2UtPl9yZWZjb3VudCwgJm9s
ZCwgb2xkKzEpKSB7CisJCQkJcmV0ID0gdHJ1ZTsKKwkJCQlicmVhazsKKwkJCX0KKwkJCWlmICh1
bmxpa2VseSghb2xkKSkKKwkJCQlicmVhazsKKwkJfQorCX0KIAlyY3VfcmVhZF91bmxvY2soKTsK
IAogCWlmIChwYWdlX3JlZl90cmFjZXBvaW50X2FjdGl2ZShwYWdlX3JlZl9tb2RfdW5sZXNzKSkK
--000000000000c58470064bee0d01--

