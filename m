Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25D32CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 06:18:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69C326B0005; Wed, 13 May 2026 02:18:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64C216B008A; Wed, 13 May 2026 02:18:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53AE06B008C; Wed, 13 May 2026 02:18:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3FE436B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:18:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D59331C1091
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:18:14 +0000 (UTC)
X-FDA: 84761391708.10.15E4230
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf27.hostedemail.com (Postfix) with ESMTP id C838B40003
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:18:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aqa0k19k;
	spf=pass (imf27.hostedemail.com: domain of 3oxcEagsKCDofkkjskjgWjcckkcha.Ykihejqt-iigrWYg.knc@flex--joonwonkang.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3oxcEagsKCDofkkjskjgWjcckkcha.Ykihejqt-iigrWYg.knc@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778653092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TX9DcXAmoIgsu4IRPsBLLucku/osUjEAMFhUMNrAFrU=;
	b=KcqoSK2G1v+IfD0QuxPJSNTsJErlgOrCfURKO+9h63b33DBbJlXkV95UEH9PTLg47ph1X8
	FXQo6nUhd5fuCVfU2aLz4QWOBRC4QCItFkRYKSxHH3dtPM7MEhbdolVThss7i4yqkwUk6r
	46M+jr9O5g/zohfMyJ9y48tkJK+ljTk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aqa0k19k;
	spf=pass (imf27.hostedemail.com: domain of 3oxcEagsKCDofkkjskjgWjcckkcha.Ykihejqt-iigrWYg.knc@flex--joonwonkang.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3oxcEagsKCDofkkjskjgWjcckkcha.Ykihejqt-iigrWYg.knc@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778653092; a=rsa-sha256;
	cv=none;
	b=HtPQqxgWphlYpfxH6zg5JEVxaexEPvZC+aN4zTZIzrnHPs/7FOduDoCWkWJUGrJPjfSJy0
	PHn0YzLa5YQLWHgxEpNJWIe7cQHWW3iuZ2fhNnp7J+NRXr8sTdE1FI4xx1CmkclogGRASV
	JK3F1UlOefYfCJ/fg78a0C0malyPepc=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c828b1b7fddso1778649a12.3
        for <linux-mm@kvack.org>; Tue, 12 May 2026 23:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778653091; x=1779257891; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TX9DcXAmoIgsu4IRPsBLLucku/osUjEAMFhUMNrAFrU=;
        b=aqa0k19kcUzGoWS1OQoYgluL/2SYMn2O5hWtuyXHpZOP5x41aktKZzZUmygJDEtWDL
         JriHZD6uuM013Jn1b/Ph9uEX03oJlIrGb0w4pQ64H2+2sHJ3SUDuvFqh+7R5HuEir+Pw
         ZsCiqUzwx/7B9Vvi6Bn9pQF44QdttF68d8TeFw9+75pRTKmZhDS3y1N16cVfjw8zoPQt
         pEGL2whsIdiayhFEpNS++jXpu52UfGpCHYLw1Z83FELBxucQS6/aSKdHVoozyE2RRE/r
         7N7s0wArJ6TwbPyyj1JgvB5ckp+kocrHAEPwW9srFNeujbOdwOZrg3W76hZeZXA1i7jh
         mPZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778653091; x=1779257891;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TX9DcXAmoIgsu4IRPsBLLucku/osUjEAMFhUMNrAFrU=;
        b=agwe0zxStcclAol9z3RUFvVwqIcn/c9+JD+qgAue/J0Ng1gbzyhNBlzAyeH3Idb+um
         DkfnYGpS3Ze/a8hBZzJCqHEyociMt0A+60saBpdeAIM+Cn7JVDjOPZus4nHJ7F4MC18E
         nGEM8Nj+nd72Z/zeGLEXagSIKrwO2UgKPXPkLlW+sk3JYMdgqjzy5eo+9lu81ncBRKCN
         2W6yHX9lbJ+CIMJpBiBdd2f1uPoXU/ljzNjoRZVBlvApdnvDP55XHZeyo9wNOoQOlszD
         7DmffB3CD3AH7LsCXhFQOSzLlqF4d6VRs+n26rQMaQnJKm7xV7VXRYOn8axPz6BlfFvC
         965Q==
X-Forwarded-Encrypted: i=1; AFNElJ8jSVPEyxEDcZydXOJHibAglw0SuG2x0PprKL0m71fEM7Mpv9CjwDt6XR4bKIMhuna2SXurPLIeTg==@kvack.org
X-Gm-Message-State: AOJu0YxZNkenOo8Py1CKIC6UjPK7hYU4RWOZZKglxJfAZ50d1FIvdo2I
	6urmxtZ7HhpY8SAijQzpSNY8LLjZJHi0QLlepq/t5L7chAl/rrLZPzz//pYmA1V9DJO4hqu1526
	3MeRfomjDhztAyOJNEHIsqhQp5w==
X-Received: from pgno29.prod.google.com ([2002:a63:7e5d:0:b0:c76:6c2f:89d4])
 (user=joonwonkang job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6300:210e:b0:38d:fad1:cf2a with SMTP id adf61e73a8af0-3af7ee42920mr2030816637.13.1778653091052;
 Tue, 12 May 2026 23:18:11 -0700 (PDT)
Date: Wed, 13 May 2026 06:18:09 +0000
In-Reply-To: <20260512154628.a30e8eb1827c80e0529b672e@linux-foundation.org>
Mime-Version: 1.0
References: <20260512154628.a30e8eb1827c80e0529b672e@linux-foundation.org>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260513061809.3868837-1-joonwonkang@google.com>
Subject: Re: [PATCH v5 4/4] percpu: Fix hint invariant breakage
From: Joonwon Kang <joonwonkang@google.com>
To: akpm@linux-foundation.org
Cc: cl@gentwo.org, dennis@kernel.org, dodam@google.com, joonwonkang@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C838B40003
X-Stat-Signature: htk86s189giuakaab7ootpn9i84cya8a
X-HE-Tag: 1778653092-946986
X-HE-Meta: U2FsdGVkX1/0SOLER7zq4FzvGCZUusaC7b5ZqnzjaVGfpaaN6C4o3L0F1WtR3Ib+/Gk3tepXW/1IBaHARO7XYgVMHsEP9MzT1abJZG6RdYCBlNqjq9jHU7NaXwxtpE2H3lu1j95tfH9mAUX8tMLnGBu1Q42kQzqKve8KwAPT7REjHVQQD/pznXQRHuo/BuvTKxQvgohToLqwkQPLwkIqqVq6i+HJvgAMfPZAcs/lfHB7rQRH4m/6wpNf6w0NhJjEkWkaYbh4tql7XhpA9zBmnCHvz6xG//H+q/BXF6Fs4Ue3nuWtCzGXC5lgblUrfPBM2TG7VxAJ7W0ZXY53uehuPhEbDsK3P9pAPoqK3o+vfzjIP2ZVmj4e5fheg48HnCyLfl4ob+FUAA6ycbE15ld1X78m75xCW2IstEJ6Yqw5scq5nGy6x/sJy+DphlS8hfRUX+olGWcwxQ6MhEGnqFqFt9z5ofZc+nKa9YFAMKrJMTsQGuwAUXQNWs0lZYNQG7rXqogkL3Efn761RE46l7UjAsmi8M+0xojkzEsyHBarB3AGMRugLg1Cx5GbpveElngbNkspm8h/jh0wQHM1ZvmcKk85Rb49Q8+TbMMlDZKDeTbGwMnwgRWjyVRZLSJlS5/du3UgLolz1683STF6PkBpZ3YWQCgWflvSSIDedBHYKQUOIXlAZGXXDUeDTl2aWXlP4etTZpzPDcoTe8zZfj5g8+o36XGqpFClwkEF/2zRN4wvsdoH3RvXkiyMX+SBIEKKPec3+m2qrOU03iAje3ychWew4146evQGi2FfuobZuuPxxRqdu2NVaTTEeYAK42CS0H+po/2KiLVCw4cp1KkZC/HcssFj+JMrrTFOBzKWEv2c9a3wMFaL4RsfFv/MKj435+le2D4TAmFXFsFcocOgByHOuv5rFd4z/h2a638GinYFCxl3T3MKflNC+16AdiuxDd2LVs+1Qvegb1kFIxT
 57Bg4UGL
 eV4x8UG3YwsIrE8FJjifCjS4hgW9VQstPe72aXGGmq6HZ+zZnQYd/CiVx4FxL7ep6kMXiBsIQ5uZPg0EokqC35WukGDoR388L9BDot/1E0VNw8tJg3qvx9a1f6aaaRXuTcgysSZhEw6BDsnyeNE6Ay/5jmnqn0En+rSx58XfyyLWQofTUq2k+PQrciH0sPDxCcsa7glqH0pv8DsLWwPc/FUA+qZLo8LPj+kJBqL8NgiPGXr8sEmmxP1AU5y9sX2odsh74j+h0eXjP6XbKQElECR30Dxmi4P+jw5dlWBQT3qGcY7BBDKtyXYO+meld0Ip2WgMa4BHiWRWfyTKbNSN02Nds11oMM60mN94PS5MPmeEli+H29yGvvCUWf3QwSBqsJy3uj9l41nSCyACvF4wRzMHJAUWcLRFE0a2E+bExIlXQg1SNxIb2s5ZhADkwRAZi7HQEJofafAHipUfhqkDAWgjNc02gCMR+pM5OxDnQsZqNYV0espWKKf5C2x0Ft6vHjK+Vbz3scSZN4wecQlKgaY5nJjQkIK11ZEO0UYJPSg9wZBqEH4Y89NKyLw/4CkZCAHLRbS2NTFlE+3gbQXlZXrX16b5W0F8hc3VOycI0ivl3h+63Tkl4iGjVUm5KiuPvPPyQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Sun, 10 May 2026 07:21:49 +0000 Joonwon Kang <joonwonkang@google.com> wrote:
> 
> > The invariant "scan_hint_start > contig_hint_start if and only if
> > scan_hint == contig_hint" should be kept for hint management. However,
> > it could be broken in some cases:
> > 
> >   - if (new contig == contig_hint == scan_hint) && (contig_hint_start <
> >     scan_hint_start < new contig start) && the new contig is to become a
> >     new contig_hint due to its better alignment, then scan_hint should
> >     be invalidated instead of keeping the old value.
> > 
> >   - if (new contig == contig_hint > scan_hint) && (new contig start <
> >     contig_hint_start) && the new contig is not to become a new
> >     contig_hint, then scan_hint should be not updated to the new contig.
> > 
> > This commit mainly fixes this invariant breakage and includes more:
> 
> Thanks.  AI review asked a single question:
> 	https://sashiko.dev/#/patchset/20260510072149.1279887-1-joonwonkang@google.com

Thanks for sharing it. Let me answer it inline.

> > diff --git a/mm/percpu.c b/mm/percpu.c
> > index 35e058f56a6fd..359f92d9637db 100644
> > --- a/mm/percpu.c
> > +++ b/mm/percpu.c
> [ ... ]
> > @@ -661,21 +710,41 @@ static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
> >  		if (block->contig_hint.start &&
> >  		    (!free.start ||
> >  		     __ffs(free.start) > __ffs(block->contig_hint.start))) {
> [ ... ]
> >  			/* new start has a better alignment so use it */
> >  			block->contig_hint.start = free.start;
> > -			if (block->scan_hint.size &&
> > -			    free.start < block->scan_hint.start &&
> > -			    block->contig_hint.size > block->scan_hint.size)
> > -				block->scan_hint.size = 0;
> > -		} else if ((block->scan_hint.size &&
> > -			    free.start > block->scan_hint.start) ||
> > -			   block->contig_hint.size > block->scan_hint.size) {
> > -			/*
> > -			 * Knowing new contig size == contig_hint.size, update
> > -			 * the scan_hint if it is farther than or larger than
> > -			 * the current scan_hint.
> > -			 */
> > -			block->scan_hint = free;
> > +		} else {
> > +			if (block->contig_hint.size > block->scan_hint.size) {
> > +				if (free.start < block->contig_hint.start) {
> > +					/*
> > +					 * old scan_hint.size < new contig size
> > +					 * == old contig_hint.size. But, the new
> > +					 * contig is before the old contig_hint
> > +					 * so hold the invariant
> > +					 * scan_hint.start > contig_hint.start
> > +					 * iff scan_hint.size ==
> > +					 * contig_hint.size.
> > +					 */
> > +					block->scan_hint.size = 0;
> Does this code unnecessarily invalidate the existing scan_hint by setting its
> size to 0?
> Since block->contig_hint.size > block->scan_hint.size in this branch, it
> appears the existing scan_hint already satisfies the invariant.
> While updating scan_hint to free would violate the invariant because
> free.start < contig_hint.start, simply retaining the old scan_hint rather
> than actively zeroing it seems to preserve the invariant.
> Could we leave the existing scan_hint intact here instead of clearing it to
> prevent a regression from losing a valid allocator hint?

If the old scan_hint is before the new free region, it makes sense to leave
the old scan_hint as-is and I don't see much demerit of it. If the old
scan_hint is after the new free region, however, leaving the old scan_hint
as-is is more likely to break the contig_hint later and I guess it is still
better to scan from 0 in that case. So, let me more diverge in this case.

Thanks,
Joonwon Kang

> > +				} else {
> > +					block->scan_hint = free;
> > +				}
> > +			} else if (free.start > block->scan_hint.start) {
> > +				block->scan_hint = free;
> > +			}
> >  		}

