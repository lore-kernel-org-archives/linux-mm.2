Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 100AFCD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 07:33:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B2FB6B0005; Thu, 28 May 2026 03:33:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 063BD6B0088; Thu, 28 May 2026 03:33:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBC316B0092; Thu, 28 May 2026 03:33:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DCD9D6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 03:33:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7C68B4077B
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:33:21 +0000 (UTC)
X-FDA: 84816013002.25.45D592F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id D6CB780004
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:33:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EAjbWHGO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779953599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YDa9wMSfYYNphGeMQHvqmiXt3L8QPz7i/ws9GTBQqJk=;
	b=xabVMpNvLQLWSiSYKEo7L8dGy5QmjR+7PxPNSE+uMMedyvVi9itiWqAbWhFOZeM4Eb+/VD
	3iHi2NTtG/aot7gnWrQEOB7MZ9Q+3oVGhwtRtPvEd5Sxh/H7zj6zZ0dzK17rPgNMXVfzqL
	3Cx/546bpP7BfgAKWcvPK6g7w3hqZwY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EAjbWHGO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779953599; a=rsa-sha256;
	cv=none;
	b=ak3GxAoUI38wqxw4G0HpRdc6ED9j9bSfD+uLYJNJXNI26U7NZp1NbWHgD5KVdWmkfkaSFV
	bkyd3gCPYjuEpdAToRUB2z994V5XcCnWwo8FBoa2X+HzhknK8iubuqjb1KZyPGmrZDBQhV
	fpGVMK/ACgoLxOLe6+RYGUWvzTtVBT0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C01243CD3;
	Thu, 28 May 2026 07:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92BB61F00A3A;
	Thu, 28 May 2026 07:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779953598;
	bh=YDa9wMSfYYNphGeMQHvqmiXt3L8QPz7i/ws9GTBQqJk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EAjbWHGO1NgmGqsUhE0AvTIokCQTquUZ9eFHAjOZlVY0tv6GU+4QHLFfviiSa80dB
	 zOmmonUwUB+W0k9sjSJOGT9JJ0emB4jEuPNPsufcatNlK6IZxE0kF0DfulzjvHkyOu
	 Agy1rkd+6er2HXtxNSc5s6y+2U4AfFKZQQ3s9+UGNm7q3CtsDKJRFM7nIcZOStAfUU
	 C1XzUp5SoyEX9vZ7/FK9OP/EcHXwadC2JpufQAXo6dsuYwbaTYOdoZMa1wouJofqA3
	 JQ0z/FAlENAx602rKk/4uP42RhkTBw9eMwwQZh3r9nR2mbAXCpoJ7Vc9vejrbAE8WC
	 hDEYgTWmWk7Wg==
Date: Thu, 28 May 2026 10:33:12 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David CARLIER <devnexen@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Heechan Kang <gganji11@naver.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] userfaultfd: refuse to __mfill_atomic_pte() for
 unsupported VMAs
Message-ID: <ahfvuAdJs8zhzkTF@kernel.org>
References: <20260527184751.4147364-1-rppt@kernel.org>
 <20260527184751.4147364-3-rppt@kernel.org>
 <CA+XhMqy6NH6Nn0=jT7Js6nAe-8UbZbhpTCoP5gSBsODpAMfqnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+XhMqy6NH6Nn0=jT7Js6nAe-8UbZbhpTCoP5gSBsODpAMfqnQ@mail.gmail.com>
X-Stat-Signature: eickf3jbzh8fggqj1nfh65xhq9bcxxah
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D6CB780004
X-Rspam-User: 
X-HE-Tag: 1779953599-712298
X-HE-Meta: U2FsdGVkX19O9If2SYJy4ivdJGaJdyj3mJLeOW03w31UxnHKb645Oq2/8+1MWaDV1Yp88veIA8KH4HrsCcU7ej3AaUZhfaDYE4g5jmHw0zotwkF8l+LMByZ6tsnT1fJEZSM1D68wsDZnnUFlpZy7DN6UkKDTocI2lUTkyudytrLZAUCdGhtkT5kMOUqFYqlp6WYq8zYDs0ATwmPLH+Sml9iDyPlqA3zfS2kEoT+CYXm0tJ7TxOU4u1rlhWmgIGC1N7reNsnnWcP0UTwEvMmuDmg+KpQrEaXOzYW46rXKUZEOvFxbEEseH1V5G+w/gLSgyhx9ce5AMcv5LaBcazSkz5cWQkPpaXUQaQGNFZID2MKJtvsXsG6zUjPdJ3OZrQPHxiQ/ApFm0PtD1OgFaIQIZnWCiM8PRtf14Q0gf2x9qAJ953+szTSjP8eANTeM2kIgP665+WRiQYvSceeEruQgeTpaYOAtUdZ0skUQbtupKiYaYRiNGI8Q6EyQNrdIc2YUOEA3TK05OwczlQAqP6f+Rrz4p0TsD6Xb1UMsIVyOB7se+YfRhieQz+u7Zkl9JDibQ4yoiddSV7BmTEqKScYvTw6wPBUE3UDfVRG7Di+UROH4AqwmyGiJvAnAOyGy6sED9BQ5Emle3hta/0QKi/9MJd/ftzBmMKfPp2d6U4VbsqtW3BDSu6PnXMY7LLuTJwvpxSYUz032qjI+1+N314KY1avMvsCI4eHvW6hv2VQVla2unT6GzdOSxPXWAIgWBUsj9ZDNKmiPFKlu4b4hNckqnpEHKEHF5mtCZYr/lrQ5hQuPo6L2ENdKzzJ/hUWmyPSOaSXYjVcJNmqzPMKhaYRwLmhtqlbiT0wDIE0yh2IK0jIZPGsyPiFaenZj/Tfay5IDqhdDtpQYKaZYKAeoI21jKUZXn92IVv/JPTZHaxg9LRxcNlVplso4bCYEQxiUu8/axTZsJwqQZF3iWZv3cNH
 j9Nw8xgw
 hJr32YRh/YsLMnjVLxhLEKFVZ+vbbeM6odu7p4o8pi6jSgqZth7Wsxv2fz+wP2nods/ksLtZx/EbT8jmeh6tJmjEWfsnaMYUq2c5lnrf5Tp109g39iUxmawOCq54h3iemNMceCUQlkWCNwm/t+ImJvHWcbW/+CdHdQzZ9KPy8jXAQEnh7sg2yVSxBkWeKpTqapF0/VoBjSs9OFmfznVtP009HCkml3tGTCYz2KJLBUCZKwnrvMWj30RHrOozaBhUag06Tj4UAk6AYM8+dJ3WzCWScYDVyZ1LS+urBVeSp5tvLAmWL+3W8tnJUiMaWlNuY/GdYm9q8R2BzlA/0CbVUcVHtRwPryMJw1LxLOI+WStm0W0TIWegSrTgx0N1DhVQTAzX67khTpo9IG4c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 08:09:01PM +0100, David CARLIER wrote:
> Hi,
> 
> just chiming it
> 
> On Wed, 27 May 2026 at 19:48, Mike Rapoport <rppt@kernel.org> wrote:
> >
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> >
> > __mfill_atomic_pte() unconditionally dereferences ops because there is an
> > assumption that VMAs that can undergo mfill_* operations are vetted on
> > registration and must have valid vm_uffd_ops.
> >
> > Add a guard against potential bugs and make sure __mfill_atomic_pte() bails
> > out if ops is NULL.
> >
> > Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
> > Fixes: ad9ac3081332 ("userfaultfd: introduce vm_uffd_ops->alloc_folio()")
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  mm/userfaultfd.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index e5d2fb3ce2c1..2872c71bbf36 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -552,6 +552,11 @@ static int __mfill_atomic_pte(struct mfill_state *state,
> >         struct folio *folio;
> >         int ret;
> >
> > +       if (!ops) {
> > +               VM_WARN_ONCE(1, "UFFDIO_COPY for unsupported VMA");
> 
> nit: Is the warning message a bit too specific ? i.e. Also handle
> MFILL_ATOMIC_ZEROPAGE case.

It handles ZEROPAGE case by actually copying a zeroed page there so in a
sense it's still a copy.

Differentiating COPY and ZEROPAGE here will add complexity that is not
justified for a message that should be never printed.
 
> > +               return -EOPNOTSUPP;
> > +       }
> > +
> >         folio = ops->alloc_folio(state->vma, state->dst_addr);
> >         if (!folio)
> >                 return -ENOMEM;
> > --
> > 2.53.0
> >
> 
> Cheers.
> 

-- 
Sincerely yours,
Mike.

