Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8C3860A262F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iB7Jd4pq
Received: by kanga.kvack.org (Postfix)
	id 1C02A6B05B1; Mon,  2 Nov 2026 06:18:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 171716B05B2; Mon,  2 Nov 2026 06:18:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 061126B05B7; Mon,  2 Nov 2026 06:18:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D90586B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:18:17 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 74C37C0C6B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:18:17 +0000 (UTC)
X-FDA: 85389930234.26.3F247A3
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9A17E140005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:18:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=iB7Jd4pq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793618295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1yynEp54ZHg/bAl3tECuL99Dgvavr9fresZi3o0Y1io=;
	b=AGKeS2rQiMW4vZ1cWjAXcQrocWKbhfOCpDXxdYC0GR/a5e99T63an3dz5D78AN0DahVNH+
	bO4wIi7cmmN4y1xkNkl4mvwwV8VkLt7gAEm81Ycbltrvfnd94noqhVjgzeIPfAojio7YOb
	lT0tOYQ7qFSXh7GjcvRs56GFIQb2QVg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=iB7Jd4pq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793618295;
	b=8NukAeWCZV+t8ydQKh7ElUjwNyBupiO+RvCVvyKzQIsA9hZNArUrFAW/e4FOdyn3YCmIyx
	gby5NSGERYTA5iwb8nhIPbHP175ie/9ei9GLFa5qRDHZrGyNtOjqJj88JnWq8gIJjF9e1y
	8Ce8/QJKL/E/eTRfIfYynUb0MJqnYPQ=
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5be4b61fd3dso2405992e87.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 03:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793618294; x=1794223094; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1yynEp54ZHg/bAl3tECuL99Dgvavr9fresZi3o0Y1io=;
        b=iB7Jd4pqTnbCHRh8DsC5cn/y4HrYTl9B0bH8XmY+yEZ+kUPsc5ChBpLMbjoc7traos
         ts1X3KDGWc4zbC/yVWUGJwHC+crdLClQpfu4BWXnJFXRCt+HL52mWOF4Yj2tjImCb6GU
         EKwh2WsGipR6PChR44/rVemw2LmUJ/Wrp6044nVL+OATlUuIRZ3fxhabXfG2e6SYya4g
         U1DF9NlnzzOpBkA7XJzM/JVrahg3krnjlg3nxKmZEcFcOVvWp9m/xKRzyb64zr+rPJyI
         NQawQcNbqX0THa/ozL+Pfwn+XL9iCqF9mOcgz52jWMssWUvIcwIOx31nWno+p5x3b95O
         nO+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793618294; x=1794223094;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1yynEp54ZHg/bAl3tECuL99Dgvavr9fresZi3o0Y1io=;
        b=no0ltu9e5TEBQh2fYi46jJcm2ntfgnkqWMNgOG/bz0aZoOWYFTR9zzwWzZ5QNrYdbM
         DWEvSyuJ6hjxAqkzuGMZU1Fqe1h5qu8dOgbpCNIjHLhWK435eelOBAn0s428xL4U55JH
         ZqsuMYs75zdcEglDqH+/m/Zw5TliwVqH98BwsO7Hyo9X2BT6BDOe6AyIE8zOZ8O3J/nz
         38e5wKlPFExNvQw+2B3n/AD/ZLOXdopiyz6yPsrJwFcaDx++yp5pm9mAjvZYUy0WEyME
         ooe1F9G5VqIl52sPB6gIpBWD4/x8BCmsfmgr16qkLrp+ttON3XGcFKnFj8XIGD1c4dXD
         +KnA==
X-Forwarded-Encrypted: i=1; AKwUvBywLuV1NDsvruTnlkMHBr0PFk4PBvTmy7ulFI2aiHDABE8b80QCT6vd3E+CA4C8Z2zzydeQtYVD5A==@kvack.org
X-Gm-Message-State: APuU4Z9TEG8vB1XJDWNWcUT+X+TpOVyInnKZo+D5e1MimY/5Jpl64Zls
	Gn99HCIfIpltXU5k3Lygfp4fDi7jjLN0FJf6v/ZlN4WCmnfgWsR0AFqX
X-Gm-Gg: AYBFou2ifBlalTpidieabF3cckpC8+kO2TykiHa1UZISlGpjJdUzozTbATZ+tNAXBLI
	QNuJAkdkkbNnH2mYooCwV8thEwauRiJIQ8tklAXxa6O+Fby31ZuSUMHIWU0AHXmpwn9Z9mwURGc
	caFqgjI7O3XcfQWfv6hup8L4WieAfTWQBKToVbe6W07YrHcc++hoAuLtVElLOqGK0koS6lWmmn3
	+hNwpk/92gSDxHMTnmI273DlaKrsYPSYuQ06J16h0Cdg41KgjCrlHsySsU9jBWJO/hUhTwnSSes
	RM8XFknxnehb3ICm5qPysgmP6Pc2vs0FQ7cPWmXpU85qe84+l/PhkGiO2Bso9E8+6ugN6E28eKD
	Nog+Rf+IT18+LpaK0cqYw+pkfbWN1S1VhgVdLmUK2PCgoTT72/9hsEfhlmElugU6DktHC1NiCU9
	h6uakMh2edhmNa7qeHZQxflL/JmjxLQw4p0GYgQrhGOI+i+pcYiiuuX1FY4w8kWgXOGdqfR5p0B
	Fl93dU5MPiU0a9MH+0rLx5MPZFUlu/UgOHEJyvkBb9r4neauB64dzlnERh9MNsFF537tWzNFcK6
	GJRcKQ9/aeEizOmLKVF8CrrYX95Zzvzv/nrj7jIR0VI/wjZXkFIi3Q==
X-Received: by 2002:a05:6512:1392:b0:5bf:c9c7:eae2 with SMTP id 2adb3069b0e04-5bfd9596876mr3227650e87.66.1793618293591;
        Mon, 02 Nov 2026 03:18:13 -0800 (PST)
Received: from pc636 (host-95-203-3-139.mobileonline.telia.com. [95.203.3.139])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfe074168bsm1622248e87.63.2026.11.02.03.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 03:18:12 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 2 Nov 2026 12:18:09 +0100
To: Matthew Wilcox <willy@infradead.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"Liam R. Howlett (Google)" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>, Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
Message-ID: <auhxcS4rtrPG3tVF@pc636>
References: <20261028154218.1668182-1-liam@infradead.org>
 <20261028154218.1668182-5-liam@infradead.org>
 <auKshDXKQXt1kvjy@gondor.apana.org.au>
 <auMbCuecFeRmBFSK@pc636>
 <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
 <auQhkHG6XlgNTdRr@gondor.apana.org.au>
 <auRo5WBj2OlKlWGW@pc636>
 <auTrzlSFCWNJYisW@casper.infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auTrzlSFCWNJYisW@casper.infradead.org>
X-Rspamd-Queue-Id: 9A17E140005
X-Stat-Signature: 7cu4xdh3rcwgje1c9uo3rou8ijyx9aqx
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793618295-136721
X-HE-Meta: U2FsdGVkX1/out6YnNuIznSTbZf0PiQ2U2SCr9Jexodv56JfL9P6GxhMY1MFYVe3KTavjQE1qYzsmgXMKwOhS+0zOiz9EvsDKcyXith1oigCKs+w8WgqaiydhLHaZL+UwyE0JuXUwmMFfqRPGlithSVuEBNHDC9gRam9jBcXHiL8BAQYnilxQSEJkpQL58Lc1/nxLgtZMpXQtr6B8bGYfMOQ/jAtdUfAxhbdyJgvqnoVlEz5jurw4lExUxkZZlAy6xIQEmS3NCz/un97HZ4X6/roTq/4f8UhcwGsaRxvBNYZepyGCEw2MQCIk529xsVm2r9XjK7ZQoSUdQ50zDtPJikdtPIPd+6embB+JrvN6RH+XIYRAjtHYErKk0TG4HWM9L+YDFgt6wQ81J+9Vt4sQNK1ypdcUO5now8EAqgGaQaZuLLE6IobwtNlfAN9R6tjlfonaeCB0owzVkBu2i18+kI1uIGLNUQwtxWQLJcZkfNtRVLVxrWeCbHDBPPoCR6gAUKLmhkr0asF8PEzQyYCjkmQBZPQx1/7BG8QgksUP4jfE9rr9JFzqYIGYJAM7hkerVD+BE8J8hwLFlYQ5bHYtHQsrl5eqbtgBPpi4NdOqMAoZovggdfFsF+ju8KhXUk3CLI0GkCdnSYYQ07HqlPGsNt+Qd/XIW/O8Yp6aoZCxR8sZbSf3OZzurzcSXWDj/HXclRMI5aNYq5l+bHfM//p/cNTyopFb0bpG4NLYnNKY+r3BbJO2kZVD6PR96apvgzRWkLR8CthNSPyxdBJjD5jKRPJt6U0gC38CeGuE4Bnsiun3/CTeefp2acNkEKrFN0vXMPNnVV0qJgKQIEOMw13QJJuo+6u/fBEtRNv1ggPTBPwqDnTVQWO/4chMfsdBvp4wXkNZnKM0wnqAwUNHs+bOzigm8DUmwNSlQhDNmb44PKhCFvqwzEhoNezJteFCb7lQskrjnr1VxK4Qfrlaqp
 AdXDRJo/
 0k51wM94yK4FBUn64deHz/Clyg1qdA5VxKadwxO4iyoHPjJBfxJOvhswN+OP35v/n4GMareDWN0DY1r4e33/2haFXxxEifk6ItwkSBoYAMo9ulAgv1nREOGxOt02XrdXy1fkJA42MzxiApJM0o6NJey3L3Gh7Ax+mDidZ0Amdo9ZDSJvRBRwouxS7TZ9Sy5uWWsol2BXLkANWN6tyYdKiDBheOFi23LitQnqlCatjmayfsRw6zSECXHyqQbNyGJL+oCDjHa6R5zSZUSA6TphCTvx9yHpZ/+a+uzq4f9HMqkTBzawOY50g5EYPrsJ8EtYtiuXTyMP8ua53yFZRQVoec/OO7ucjsLfswKcJ8P1wiSZliOtAg9lLtrxUTCg4odT2J/jC19gI4CsgmxEZhumuNox0XvDuoQNE9lfm8nE32bMN4XcBpyLzHNureH+kSQX/IQC82/LhaBQSljz/zuzu9oGez+2jsbN6BFUaQMVfY6eRvxVeVMBVlpIpEv3h+am/8QTJUyBYgx09DE/bg0F3LhA0UBRxMLQHnyRE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello, Matthew!

> On Fri, Oct 30, 2026 at 10:52:37AM +0100, Uladzislau Rezki wrote:
> > The problem with spin_lock_irqsave() is that vmalloc() path can take
> > time to alloc and map pages. I am not sure this is worth to switch to
> > irq-save locking primitive. So this is the "heaviest" allocator in the
> > kernel. Callers have to be careful how the call vmalloc().
> > 
> > IMO, this caller has to be fixed.
> 
> Which caller, though?  Are you saying rhashtable_insert_rehash()
> needs to call kmalloc() instead of kvmalloc()?
>
The problem is that we used to BUG_ON() in vmalloc if soft-irq or BH
is disabled, i.e. for vmalloc it is incorrect state.

See https://lore.kernel.org/all/69ff8c7c.050a0220.1036b8.000b.GAE@google.com/
Two patches to address this:

1. https://lore.kernel.org/all/20260515153009.2296191-1-urezki@gmail.com/
2. https://lore.kernel.org/all/20261026102503.30860-1-urezki@gmail.com/

second can be updated and resent as it checks if the context does soft
irq processing whereas it allows:

bh-disable;
vmalloc();

forbidding this will address the rhashtable deadlock(discussed here) but
this will just fail allocation because it is incorrect state for vmalloc
and calling kvmalloc() for rhashtable will not succeed.

i.e. rhashtable context should be fixed also. This is what i meant by
saying: this caller has to be fixed.

--
Uladzislau Rezki

