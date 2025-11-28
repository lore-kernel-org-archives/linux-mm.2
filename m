Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3266CFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 15:51:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA9C16B0006; Fri, 28 Nov 2025 10:51:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C80A06B0010; Fri, 28 Nov 2025 10:51:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBD5A6B0011; Fri, 28 Nov 2025 10:51:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AA8CA6B0006
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 10:51:31 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4AD5E140394
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 15:51:31 +0000 (UTC)
X-FDA: 84160455582.14.5BA99B9
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id 86A3EC0018
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 15:51:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="WhvUZ0F/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of glider@google.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764345089; a=rsa-sha256;
	cv=none;
	b=LFcyr7/tgOUSLS+1jPepdecpOOd77X7a5mRpQFNS5MQzdZyWcPgCy31UiDzqENvoBFXeUG
	O+cxuUVU0yECXrY8clD5oh9cq4L+wIEaxQJIkzwif4825dmoc+DB8cxGTK1UQZ2jK2aXNG
	bnldmPzdCjOzeEq56ADe5j984TmYo4I=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="WhvUZ0F/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of glider@google.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764345089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ozvegxpQZ76Gmd4MPL9aKvB06f3a0E0RzNh/s6Socck=;
	b=h8TymcvpkwnUYcT79k0oKCftncX8YN0AzWY9vrHCfSi4yoW1BruhVqTlTTGKK1H6Iv07D2
	l08xRwmizKzGV0Am7MabmVD7FwxjJd/CisUsZQuzufUoxAMMmTEWOu2n4Gotv433pOHS+M
	M8JnmEIBDa26gfaMc45vRJZ9rZP5sTo=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-880439c5704so19456956d6.1
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764345088; x=1764949888; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ozvegxpQZ76Gmd4MPL9aKvB06f3a0E0RzNh/s6Socck=;
        b=WhvUZ0F/8CVxR2XKBUc56ZCRD6FcveLzfsmoKjhGiK2zm3vHRs67RZHi14LLCcCvUP
         ZaQ1ppkxnwzmvYZotvW8tfKE+VYSvjXe/LO8lrrk2I/v7PC8T/5pcd3N9X9cQM7NY8n1
         EvP4saUkF2upPJ1gEK7DEqO9qweQH25SEvPyz3fRjMMFNwWQ4b4O+Ze8EY/DpQrD2MWv
         Kf03nbykzKgYz1tGHFyMqU2H7jf/+P+L6qDBjPVC92XdCZD7qvEZWVwILM3ZjM9nj2l8
         ZJSy0zgyHEF5+0QnypTQt1dDLcZD8RPuZ6KBpgA+rYN4/v7Wz1wj/UnUbi6xH/c05BD/
         oLwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764345088; x=1764949888;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ozvegxpQZ76Gmd4MPL9aKvB06f3a0E0RzNh/s6Socck=;
        b=wUv+Pl561/suXrhdxknqRFfNr+Rz5r5uuQImDMvIhHejNnhRCjWPRZZ9yMbqYAVTEE
         +1XbTfCKOYFMMRh61/Mp+cpg3S59vgM9KpvTx7ik2dU1QdLo/F+NAHB304Bwyf1/A/H3
         xFJCfmWd97H6ZA2MJdPhVrY8B7kyBjs8mTEwX4w9LkrSfWALZlodct9WnwCpXoT8uVOV
         edXLro6lZR8tYfqd2FuAJwSB2zLIHJg2pSqFQz+jI0USH/z71NsbcXpFfMCwecCkSEPy
         mflUCscp76gW+pBcIE9GiZBqSPihtbCvDXx+uskbjO23jD304U2u2EMgkl7rettdUsEc
         ep9A==
X-Gm-Message-State: AOJu0YyzrpqAUEfBeeq00TkPcWC0zSZFno6t+NJFQoruwRv2VNPeYD8Q
	SqAXkpCkW84IIhqBWKL8kmxuj/hOIObosaG3LnMdCZqNZIOm1kqIKWAQFmvAOu1vqttr7m7koCY
	uiFp0NXoC5JjihOt32LCkfiPoPnrsReduIlrfGLwP
X-Gm-Gg: ASbGncv74aqU+eFWURe3toPJa2QP3YGy8jYq6cw+EfgkAKh4oShwUwc6gTsPvA1pxRx
	5dl9GD07f/FBtsYCASXnx5KOxjxc1IcbxhSE7Oha9SHpcd5kIz+1mdlHF6nL8LDoqzRifvQPYBX
	nU1W3LXNt8UMIj5qv72+j5n+4vtR2e6Lna5O36vUfuRO0HZ5Yg/wZNjBDSHL6OsBY9Ao3K3cJFP
	Viyx0xYKdrbD14uc3R2JvKgaxDzIBnzpeIr4kUL8rkYP3dhCdSlevQXXb8m8qCIqjeOanNy2YEo
	g4TiEjUNKa6Hv1Pw3NbtGCwvPsFVNdyTCVDQ
X-Google-Smtp-Source: AGHT+IFtScpt1Nn88BhPzS0M76f9pclabIXatA2MxZVyE6xow24YTfIN5+xoj84xP9E83CZGjyUfH3MOrsIHCxgycDw=
X-Received: by 2002:a05:6214:458c:b0:880:415d:a9ee with SMTP id
 6a1803df08f44-8863ae8a8b3mr216933026d6.26.1764345088423; Fri, 28 Nov 2025
 07:51:28 -0800 (PST)
MIME-Version: 1.0
References: <20251128033320.1349620-1-bhe@redhat.com> <20251128033320.1349620-13-bhe@redhat.com>
In-Reply-To: <20251128033320.1349620-13-bhe@redhat.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 28 Nov 2025 16:50:51 +0100
X-Gm-Features: AWmQ_blrBdFoteeKgRy9ZgZrLR9hCgiNwq7F8c9neFw0fvcV5_-PUj9Uqs2bsZc
Message-ID: <CAG_fn=WpLtVhhOfU3pBKbJ2P3ih+PX4oW+MKAAmHRW0onOgSvg@mail.gmail.com>
Subject: Re: [PATCH v4 12/12] mm/kasan: make kasan=on|off take effect for all
 three modes
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, ryabinin.a.a@gmail.com, andreyknvl@gmail.com, 
	dvyukov@google.com, vincenzo.frascino@arm.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, elver@google.com, sj@kernel.org, 
	lorenzo.stoakes@oracle.com, snovitoll@gmail.com, christophe.leroy@csgroup.eu
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 86A3EC0018
X-Stat-Signature: x8y37mxz5c5zjw3ps5hwufjpr9soupjg
X-Rspam-User: 
X-HE-Tag: 1764345089-81179
X-HE-Meta: U2FsdGVkX1/LD8k05QAK49sSiwgbv1C9YNhultSKkaGszW+g8fSJlBE9XZbyeNMl5ke+N0mvt8Qw9i+wf+k/bECtb06Kyw3G7lZl7eTdGXKMqV36OwmPIxBhRXsPDKfNw8AQ1rfuMGX33hdilOR049oICig1+1yKRxfyyVAEd6rcFwGbKh654WXq8XFeZB6YI17knibmUVE+qU3CoBhxTjUzWCIEqaI/AJ296rYFvYPYJ7+Y1NVl3VEwDjCTYmfy2pfqZze+WjTJ6oshRMIMxfqPcmyVyQAmkNl4fToLPGgNx2CqmCJjYovkB8rSLZtYeTeHviA4+9GJR+UZG4JUOwihAB166ZwnZEjAy7m0dfttztKcO6W70tt3yKrGbpOsAGLMc1Tof1og9c7K+mYlfNz32uIZWYpFe2VChy2VKiwcthDvqM8RqPaA/hwKxVf9l+lZ+wc7hcyMCQyw2wu8tFgbQNxsv39uBaHHxNVnIsgRzFK4FZiKFz5KGMpcjalfrtxOWbdqruI7utpafH3wOtGBRz8GawNelSvjQw6eITqWdwcxphKe2pl91xKA5Do38dkFwAEvK+Ynpovaxt/b7RPfeiUF8Kx99BPsllKcgqscIkmq/oxclrw7y6yrCM5/HPe0SxftN7qyeuJbrcDmg5qpPPl8e8ksvlelfKXHc5ovOsu0AjQF97kuDmuMn69BdaX59I+htT1Fa9iL2zgXczn1WaODW9erpdX1fJ/4g4+43Sa702Fi9LHb4uJIfIO3ND7LT3qg+vkT8yJpI3jvn4OmPQXZMKJTV6DiuWY0FPvjiyT6yypYBjQVXH0nMYMjhxF5WvPCDmKXco/lIvZT0yA0yh9Zgh4bh49U1ZoUm8KV4c9XvAno821426T6Gy7VjM/ofiE3SNXwRjUa5HoeF1PAx/8BpWETz2BAD3TB+rrXG3Ih6zrvq7uDTcil8qxoePFlDPvaCvEb3VvL+0t
 9wk6pod9
 dYyLASIxH0K391umB/4kcSypqWFIdX8PgptkvcuER9TINHNpv75y6NIqmM+e6FnQDB12nBfac0fRxenQJ0nx8KSuYvC/5KLLBca/FFRW8BLhbl03N58hVy43FSZQtdi6GsgGo3Vmu/rnrNFR42VgAil67jrLMPrzzK/rNPl/7Mh6wmqO3sx/1eLeBj+irLLenIR9MtsyNeK+fmkmLiGEFPLNhBAy8Y8gG4m0quZjkCLxE+EKSioYhvpY5qsfNFZ5XAjH8WwdvMuABaaAghA+2J9uw2O73UTZ7Jyam6NeEwkjEeBo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> @@ -30,7 +30,7 @@ static inline void kasan_enable(void)
>  /* For architectures that can enable KASAN early, use compile-time check. */
I think the behavior of kasan_enabled() is inconsistent with this comment now.
>  static __always_inline bool kasan_enabled(void)
>  {
> -       return IS_ENABLED(CONFIG_KASAN);
> +       return false;
>  }

