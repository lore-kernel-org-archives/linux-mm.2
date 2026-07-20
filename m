Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D688C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 20:13:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 193836B00CF; Mon, 20 Jul 2026 16:13:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16B606B00D4; Mon, 20 Jul 2026 16:13:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 033CE6B00D5; Mon, 20 Jul 2026 16:13:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CDE386B00CF
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 16:13:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 599A01C0325
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 20:13:29 +0000 (UTC)
X-FDA: 85010254938.29.AFDF0CA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id E2FC54000A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 20:13:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZZS2V6+O;
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784578407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WjP788oJPluTm8K5VKvNirr5Pl5aX2RlLn0TcUqOTqo=;
	b=eqSDqGHiSofvN6UBnfhtTzCGEqOtI+2GNFyfRQVgPRG8YCpRUaq9OXZt+kuDYVk9Xnfd2j
	QW48/TuEgOgC/E9sy02SLIrqL8RK+fh8lfQvmQ2M2jeAPO5tYr2NG2vwNPtt/3aLluN6pP
	M43DZuc5VwCduuZ8ou7o3zgjOgkQYdw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784578407;
	b=vi7EpK/6Eu6Pon5Kyx+37v35Nc9bVmD8s7oBvS/smODYX9yYdlihKJtJxw69vcFu5pSgM4
	S/h03QV5hSXgvrmg8++MrHr1gP3snSJMrfbHDmXN/GaVFL93hT9EWyyyRNLBDSEsbJof27
	eJ7meHLI+7I1MLFM2WUCZ6hMe5TLB4A=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZZS2V6+O;
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784578406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WjP788oJPluTm8K5VKvNirr5Pl5aX2RlLn0TcUqOTqo=;
	b=ZZS2V6+OfuY1EFQl5U/GJ431yhsjxenFV1/gmZ5Aj8//UO+qVOO/5giKDlK5BvQQ1j3Qmo
	HS/wwMa00MLoUSNU05xkClTf5Vfssb8VLaFXJxhyLq3BrbPF6O/jdlu97MRuKKpYsII/9B
	yrj5sMWTo9R8tkHbbSOJSKgJo40bzFw=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-373-LA6RZw6wM5ioc6IuBJ77DQ-1; Mon, 20 Jul 2026 16:13:23 -0400
X-MC-Unique: LA6RZw6wM5ioc6IuBJ77DQ-1
X-Mimecast-MFC-AGG-ID: LA6RZw6wM5ioc6IuBJ77DQ_1784578402
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5b14d538d06so4136671e87.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 13:13:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784578402; x=1785183202;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WjP788oJPluTm8K5VKvNirr5Pl5aX2RlLn0TcUqOTqo=;
        b=ic4ZLd33sQC86fauuv3HyBVw57fPY0l7BixeOcsCP3dRTgxqMW6e/stnh8gYYMF5X8
         1CKoUroCuH09RKlF19ckgrdQoi9ZiaKHDDztiEqWqxJqUjWFg9ZTDC6BkuyTPrwT4OVk
         CUKCrRmAG9MIzsjX+V836E2YpEf9FkwsfeJ0IvRnsN+/SWAMIHIdKIYWxXSceyqyh2i9
         CK4tu8obOJprzLweaerlbMzFix4L6729iX5yBL+zvorx86/ZRXMnD9G6RAg7kVNg5p/f
         7A9t+jjhVEC4g7n3bUKBJOeUH0bnx+y6+qk9C4Gw23SKym2Yia3q6KHgQjziS1N5bml9
         BtMQ==
X-Forwarded-Encrypted: i=1; AHgh+RrhIbUhPg0dQDnjlPeyZUneqyVRW5oQ36+GpAMcfQWzRj8EtEAQstK/VYtZ1YDfEsgE9i59viNIjQ==@kvack.org
X-Gm-Message-State: AOJu0YyBMSuBi3LAewikcIhH+kGb+QECiYWG6fc0tgQk2vYF/I0zKJqD
	S907ZUMSOwVo33UJUEIKvYOaVViGLVkkZKSFg+AOsAb6oZyQWp6abCIsK9BK6th/zpxQWr/2FlU
	xYHIMytrTXTtcK5KxRbwnzzhH0XIiLXSA5NMY2/dXDzjODpY3lQ4fYM9rZYneeXqi2H3nuvUg0c
	jWntcOzdbM24oh8g7UBPf72vI6Ki4=
X-Gm-Gg: AfdE7clw5d2+5HdREZ+JJGSNA8bETtkrCSQ2fBm93gCW4S5tfv3SVocSxC7P1X5yn9V
	s/oYrG9mQGfwBRShLP3dy+sKnMjkwjyNNSq0LgrE2Znphbxx03uR3R7gvgcc8svd70X8AXidtPd
	UPJIFTRLB1xbGEGfZXh6HuC6gj59sV/IQaNIL2KQUREJ0HqDDk4Pei3A==
X-Received: by 2002:a05:6512:3b8f:b0:5b0:1eed:f700 with SMTP id 2adb3069b0e04-5b28f84a354mr3545367e87.13.1784578402000;
        Mon, 20 Jul 2026 13:13:22 -0700 (PDT)
X-Received: by 2002:a05:6512:3b8f:b0:5b0:1eed:f700 with SMTP id
 2adb3069b0e04-5b28f84a354mr3545345e87.13.1784578401310; Mon, 20 Jul 2026
 13:13:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260720142913.846902-1-pfalcato@suse.de> <CAA1CXcAk1SYopaokUGbT7RK9+gPNN2Jkm2UrpMaZWShjG3-z8g@mail.gmail.com>
 <al56t4zyjYlCl-20@pedro-suse.lan>
In-Reply-To: <al56t4zyjYlCl-20@pedro-suse.lan>
From: Nico Pache <npache@redhat.com>
Date: Mon, 20 Jul 2026 14:14:45 -0600
X-Gm-Features: AUfX_mwMPyjeUaqqkQ5wS83PadVEsP-VgCOXAXJMS4uApz9MEg8bESckyO-doJM
Message-ID: <CAA1CXcD=zNg8q34DhsH8+BnXACA0TbD1+p4QEOCcY2u1qoie4g@mail.gmail.com>
Subject: Re: [PATCH 0/8] mm/khugepaged: collapse_file() cleanups
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qzG3RDKZ-ZfujBiy_4Ck_3DqGiIgABauy97tdN_MZ24_1784578402
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E2FC54000A
X-Stat-Signature: 6on5uu75uujk5qacwnds6msgzjnzyruh
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784578406-805015
X-HE-Meta: U2FsdGVkX1/kUZe5gyqq7xK4QvIjCeGGnqglEj/z1PMzhjsNZpfJ1I8P3IJbC4AH4UW9OGDF20QIvVulnED23mgKDwPtUN2h4n0gkzttV2drRKPPHJ65yoJRy6V6bEEfPT+vPXXVgm3r7GfpFCTkyYjXGbS63oRc0/qsyuvduDMvWof0q8O3zM/DKCgMBU3pGZqWdLY1DYXMc5ReBMhCVa1p9p4HVNlLmbcyuGJb1Z8Shrc4GtI8h++i/sqn1z0Uuph5QhFxIfahRF5I1NQEiMsbuG6Z/clmwHtZBfLUCmEzSeejH6YTEiPKs3mUK1mo9/gpLz+5k9UgZ4MmIiNp+7CLM4xo0EBKhaoMUJWTUqC0YX4zA1AQU+oUYoPaaPEC9zvLYjqJf4qv5M3/i1vuf6hbnJRwhaLSpk9dwuzHeTSj2IzjF9MS+eaOTYSk1i0zWYxtw6zeJN1NQUWiBkqpUeiqenQqm8HLq1ctxras8vC9DYMjjdQKjXyVKOz9iCh9oslO6xRK830dVvHkFnpsdrgHkjqsDVFMX+2Alh91wLzdubtcTOkTaMPNLi87PqRQvus4Dys7xukh76HLGqyzYd6ve8xCFUlEGLolg1rqIzu2690XhceXpD8I0v8VUuAj75ER5Wr0TDAqgXYS1030E1Z23zNcwQhz+ctB+Uk3sBJeKpK8r54B52zqSHRp+lOfNQd5e66UgDtKRnUAwg7DbNXNPQfTM8iK5qWcVPWoWM6Tn0ye68adBLM8wssGs5/StKPH0/z0RP9b2MtjczYyVg+ZcL7gwBOHfIyCk8pads7zpvLYx/73y9PVY9qyN0lAbD8znqrmQCSfKSyRed844iUYpTMxpDm7rJYZOmYQ3DAKfccM8BWV0COWVAFidA3Y8fbtc6b39v74x61MFUBYMI+f3WDfHJ0XwAOIwHKLfB2DHb9/2XdzlzYMmFvjhxLYE/fwOB3Z6ZUi0nyF90D
 AGJ9p3hI
 oVicocJJMJ09tzXtHIBscsb0YQxawclId09Ty1nHQX+X+WK+ZAawujaON92PY+LyVNf8q/YuolbXZI3Iq6fmNLesSjx6RQf59632caKVo4WPqQZOr70AaVf84UZUQEIi2g/nTaFBZ4+aUKs9roGYQz/Aqq2kDFBv3TrM7KGbvuDzwVfrJOrfIWr8eKB7Usbp28/dR8vfL0AT/Ry8Ps+1F0gW83AKoydHdskW61f27Tt5NiCBBR0NgPGWBmv8qGQh3jrQdOd4dzv7//82k94Vku6VP0nTcxwkcODhTqEN3Lr4lGtqz4eV0qU51p3U48FKkJDD9RgdVG7pxZCQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 1:49=E2=80=AFPM Pedro Falcato <pfalcato@suse.de> wr=
ote:
>
> On Mon, Jul 20, 2026 at 09:21:11AM -0600, Nico Pache wrote:
> > On Mon, Jul 20, 2026 at 8:33=E2=80=AFAM Pedro Falcato <pfalcato@suse.de=
> wrote:
> > >
> > > Here are a bunch of cleanups for collapse_file() that attempt to aid
> > > code readability and understanding. This is part 1 out of N, and only
> > > attempts to address the main collapse loop. The exit path is still a
> > > mess but I figure it's much easier to review if I send this batch as-=
is,
> > > versus sending the whole thing.
> >
> > Hi Pedro,
> >
> > I have already prepped a cleanup series for collapse_file().
> >
> > I was waiting for my work here
> > https://lore.kernel.org/lkml/20260715025941.1571316-1-npache@redhat.com=
/
> > to be reviewed (and in mm-unstable) before sending it out.
> >
> > Our series have several similarities; for reference, here is my version=
.
> > https://gitlab.com/npache/linux/-/commits/khugepaged_file_refactor?ref_=
type=3Dheads
>
> Ugh, this is awkward. Do you have any suggestions on next steps?

Let me review your series and see what differences stand out. You
referenced part 1 of N; I think my series covers many of the other
parts. I basically broke down each stage of collapse_file() into
helpers, and cleaned up each part respectively.

Whatever we decide, as long as collapse_file() gets the proper love im
ok with it. I did, however, communicate that I was cleaning this up to
David, Lorenzo, and others.

>
> I can try and take in some of your work on top of this series. But that m=
ight
> be hairy.
>
> This situation really does suck (I've definitely been there), but I would
> prefer not to drop the patchset.

Yeah that might be hard. However, there are other parts I cleaned up
that you haven't touched in this series so perhaps some of those apply
cleanly.

Cheers,
-- Nico

>
> --
> Pedro
>


