Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFBE3CD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 11:12:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE8BA6B008C; Tue, 23 Jun 2026 07:12:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D71516B0092; Tue, 23 Jun 2026 07:12:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C62716B0093; Tue, 23 Jun 2026 07:12:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A02DC6B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:12:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 34C5716709E
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:12:18 +0000 (UTC)
X-FDA: 84910913556.08.1E009DC
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id 708AF140008
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:12:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T+KJD3gB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3Dmo6agkKCCUUBSVOTBIVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3Dmo6agkKCCUUBSVOTBIVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782213136;
	b=HtcyjclLF4rIaoaSjxyX98MxaRufaWvqhhfJ6JkscoFKbSgrQfgEzx/MmnvMhVpJqqxpJX
	RTEbiGKAkxmR/NynIcN1EDmNsHkZiDi0rqmA1lYvPQv7FyqmsuLn/MMDBb/K9YUsBNFhPt
	GK8LKTjEYyj8sQNLrKuVG6Ioz+e1zyo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782213136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0GTqVg+rgasX/S0lzuuc6nnVfnMSvL9+pic5H7oW7Ww=;
	b=21DlwWZ7nxt1qTqujzNbjgh5RTwndhGFjcFpQNCifdj31lZ/8HdsZ+vzpwlbP8OLqBrbb7
	NKTeOTs0eYXDdvTnfPl2oSc8iCpTmQLy+7DWH3V+mO3vXMWacLWyxPwfUWi8+fFGKX8lv+
	eV4RwJHqabns9cpmoM/Q9zP6O6CV40o=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T+KJD3gB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3Dmo6agkKCCUUBSVOTBIVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3Dmo6agkKCCUUBSVOTBIVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--tarunsahu.bounces.google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-69604dfdce2so5203247a12.0
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782213135; x=1782817935; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0GTqVg+rgasX/S0lzuuc6nnVfnMSvL9+pic5H7oW7Ww=;
        b=T+KJD3gBr1dug/lamRjwUVz6Oj/qJMICTjVgVUfqO7bLxLPehi7fnZSim0FtCI5nON
         QEEma09cavRkLpiw1yGDBzoNKD0LdUvy5jiPGU9sZvsX/1e8yT17FIsdJMxdLkc966Q3
         JzXK+Thc7HWI3Ldw0GigdoIleyP87sscVdl6obrf8MDXK8kZYgYHIHrJr2tPegGJmyB2
         3Q3dJfHw6nEGyECmIkBC2filzYNPqg65Awu8XFZZRxY3dzhBjMlshoedZqMZMY3i3l6X
         tMTlhO7IbACptRCCMopCq4yVk2igsJLNuO/NW1xUNUxAi453k2589Jimd8RdwNSLiYXh
         NEbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782213135; x=1782817935;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0GTqVg+rgasX/S0lzuuc6nnVfnMSvL9+pic5H7oW7Ww=;
        b=rH6EVu/G8VuUOGVmMl7dV4goGHcUr+UYMm22DUp/+ziPupOqgArjBlnZwcxJBiJuuI
         yBYljsbkhGouz8wifScCub/8emUKdPZ1yu9fcHWq5TRsCgDOiNZi2uJnoH3JUnrOWHsD
         ixzEod+/dr5CCVTP29LHjm3VuZ3ASpdPZ2/nXtMQXwmLVI8iOgFI8hnI1qCspjdklZva
         TjIeruO/+eWRTlgleNVtWk/fuC3NV4bMAUDmi2etlRP0Osa2u2WVuH/avELG1Y+1esnN
         84oeiTKLnSB4PkeLXyvL7ZI2w2S6WN4welMjkROXYPaMoB1md3AnSzPkAGV/IOzcw5KJ
         Wniw==
X-Forwarded-Encrypted: i=1; AFNElJ+C14mrdi8ZqymMHO6jj7yecaiA0iPSVZ6aPkhOLl6r0TaXb68iwTNlI6VgL1mkuGoRi/SNnnXRWQ==@kvack.org
X-Gm-Message-State: AOJu0YwcchGtIqtYqaW/9Anw/nMDbhpx9mUdgWPPEGKBx56tfOo0nptU
	j+4gXFjouH1VivzaHHZG2/F2MCH1cjbh3UfGajSiw3F/oOQiHuIEw1YgwZyH4QHsnrQGyM9kDz0
	Jy+nybJt032/i7IadaA==
X-Received: from edaa1.prod.google.com ([2002:a05:6402:24c1:b0:695:df16:a5b7])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:3205:b0:68d:4450:d21 with SMTP id 4fb4d7f45d1cf-696ee621b1amr9223700a12.8.1782213134747;
 Tue, 23 Jun 2026 04:12:14 -0700 (PDT)
Date: Tue, 23 Jun 2026 11:12:13 +0000
In-Reply-To: <20260623105201.3724592-3-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260623105201.3724592-1-tarunsahu@google.com> <20260623105201.3724592-3-tarunsahu@google.com>
Message-ID: <9huza4slo6ia.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v5 2/3] kho: add KHOSER_COPY_PTR to allow phys copy of
 serialized ptr
From: tarunsahu@google.com
To: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Alexander Graf <graf@amazon.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 708AF140008
X-Rspam-User: 
X-Stat-Signature: uurfo9hh5km4oykxjm1b9h4kcu8t6qaw
X-HE-Tag: 1782213136-591217
X-HE-Meta: U2FsdGVkX1+0wUVs0OKehJGZrYG9aLPm+/Vl9zqDXq+INhwZUBQw8BuK9KWhi7zwjduLq7aZikR60MSHAaEwDrf7ORSf1YmoTrQSUDK+U6NgPC1YUQ8KFz6Yh7dlgcRXA/HFaN+a8oA9EIglLgdhtD3xNy1Qclce5buXNj9AlV3HvDzls3HRUb4ioUt5cGhHY4m+17VlXwtO6WBiW1hxoeZCFH7kxWsnnWoydmaUXS973h9YTqEaDMyA954YPeV+zI9d3A0eaO3VLZQDukWOt+qnBogYDz/b2sO+KQVOyxq97JQVhH7Pwp2jxJf/dsEfIDuSmTbcsKeypC3bt0Dnkce3PbwyCSdvAPJy0U5IVw5UnarBZVsxWJc5NqMaApfwwFVh1yRjVtEk24v4I99burtgfhJuM+NYgklAZGxvjznX0C1hMCfOnK5OlJKvdMDI26dllRBzJtMlGHWPjbzwlpJ/8PJP9ikCD8IEI1OxEm5p6P4fyIyBh3HJN0sruT4JQojI4mQglfcoHjdw6GcKEjuc22BG95Z0q0FI5gbXnm3vn3qAY91bkt5sFQZZWefXpTZ+SocV6ikhesTwy7++1XbqqhPjVr8f8mNf23tSqkvkgOtGSESOw8Wfzwn3yKN24WXrMEkGl6rIMORkoIRwzlc3fBmduP61rfLmqT1rL02uKJPGUVcYU1IWasmnyF0IvnTBhehLXSvj9WzfyZn16aDVVaVdemxc9+b24Rq+I5Sqi354RAZ8PUVndJ0Y+V7aXhPpRpLY9Jw/oKxOizsJUDnv9VbFwX6tn7yULPueeWqkhznZrQY8AKsWg5+YgWzeRx4s8imhOKk92TBv5SIL7qC1gZSlYqB7WQHSgxa5bh46OfIHCiZ5ABsKjNqBqpar9/Ca2CvVOdqNwRGpQo48yeeCkQjW3UfPo5lr6stJEwY2hrE2lg2uXXCoonAEZTCy4fLkh/ROOT9DSBZMyE/
 cXpahbAb
 YpBKXsLmGC2AYc+7gH8Jpsz70dWE6H/2l7x+l3+Z0QwcRG1z984xP0dQkaUa2dyD35QDE7tY2PMS6NNNnPmKEnTJlU5EJss5DDMFqY99de4U7fFZLJmoYapMhuMh3a6CFx93PK3mfbi2Dfbwzty/V2CsOBZ3uAfNMDlRCA3N8vS0XCqXdvac2OSM4v2JvXpow/riJUllbhL0rQKS8h5MLM/rwCeN955ZvbzHkbBLxAAUWo7aoqaUK5vOvCCRLmLaYQ7vJ1BTQe5mCsZzlPq3h5CCcGzI8Cs2yYN6g2NHD54mMNO4YMYVZZizZrfc6tr4feOCvsa6LRBjYx4HXo726sqkOi+YFSNdq/szmdeqkmaLecgG9fDqEO/PM/TWk+gZwnJMunmxNVp7Xu91FM/1+XrKeg4cZoXrDnCakd79xdDbGU2k4X/vyCbG6di6Mqvx4ORqKUFObrq0aos9UeTkciztpbqs2Aa6arXpS/9aqSl3deBrOxFxcAplbsc85VF+liUjWOPzMZ/YNZq75kpoM+CCKb47UBo+Vj0XkS4hc1sJ6kGoB6zCkILVeM/j4k7JDYt6gSw80p2ynjXyw+yFjIdMvUmry7jcC8tv+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tarun Sahu <tarunsahu@google.com> writes:

> Adding KHOSER_COPY_PTR to copy one serializeable pointer to
> another. It basically allows copy of phys val of the
> serializeable pointer.
>
> It ignores the typecheck if any of the argument is of void *
>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> ---
>  include/linux/kho/abi/kexec_handover.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
> index 5e2eb8519bda..c1b61d875dcc 100644
> --- a/include/linux/kho/abi/kexec_handover.h
> +++ b/include/linux/kho/abi/kexec_handover.h
> @@ -139,6 +139,17 @@
>  		(typeof((s).ptr))((s).phys ? phys_to_virt((s).phys) : NULL); \
>  	})
>  
> +/* Copies one serializable pointer to another. */
> +#define KHOSER_COPY_PTR(dest, src) \
> +	({ \
> +		static_assert( \
> +			__builtin_types_compatible_p(typeof((dest).ptr), typeof((src).ptr)) || \
> +			__builtin_types_compatible_p(typeof((dest).ptr), void *) || \
> +			__builtin_types_compatible_p(typeof((src).ptr), void *), \
> +			"pointer type mismatch in KHOSER_COPY_PTR" \
> +		); \
> +		(dest).phys = (src).phys; \
> +	})

This needs to be updated as per Mike's comment on v4.

>  /*
>   * This header is embedded at the beginning of each `kho_vmalloc_chunk`
>   * and contains a pointer to the next chunk in the linked list,
> -- 
> 2.55.0.rc0.786.g65d90a0328-goog

