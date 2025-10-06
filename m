Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B60D7CCA470
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 20:51:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7B408E0012; Mon,  6 Oct 2025 16:51:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2C618E0002; Mon,  6 Oct 2025 16:51:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A42178E0012; Mon,  6 Oct 2025 16:51:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 95F2A8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 16:51:02 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1AF984596A
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:51:02 +0000 (UTC)
X-FDA: 83968883964.26.89A3012
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id B1C59A000F
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:50:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="fgrx/U/8";
	spf=pass (imf25.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759783860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fXplKL3U9+yiFp5hWzw6vRxuErqvUQ9NyXTS2v11Bzg=;
	b=mnc24hyasxGNLh137ovW8qRd215w4YFbYTFuKCEsQ34t4fxRpXzOmZl11x50MYca0Ne8YD
	7W/64RPia5kS8jdFKa9GTUM526O2nDh7BWI9snRFyL/BRd+he8L6jzuq5uBqqDHGnkWU09
	eUFL/VcxcKFZ2pkwVC9KwDcbpqZ+y9U=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="fgrx/U/8";
	spf=pass (imf25.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759783860; a=rsa-sha256;
	cv=none;
	b=GwzqH/KgpPey4mLUAz9rPjE6R18avHz9rNtyMpDHvlbMbWebtYWf+cF24PLvmqHgU3mDA9
	fObfTiE6fwE1ROQhRnUJYkx5sBlWHpoAC6HQKE/QGY1g1HbtAF2ELu/rAp3/LaJ65aepBM
	tj+mf1xTDkXY5n6bvDGNjPf0kAlPgZg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759783859;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fXplKL3U9+yiFp5hWzw6vRxuErqvUQ9NyXTS2v11Bzg=;
	b=fgrx/U/8UNbyqCcLnw9MHuSWy8GtINi2rNxtszl71hRmMwEe7/eCNRUSklHTt6mcwLW785
	tDCtTwNMtfvdderNasU/d9GqdL+ZPx5WOU8Uv+VCsB8cX/eNMtaUSyqQASLhrBKluVqM+4
	t9TfC7zbdIiM0/BAXn3eZCfBSShB/fw=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-150-byCwSkt7M1agZ8Q6DOSOZg-1; Mon, 06 Oct 2025 16:50:58 -0400
X-MC-Unique: byCwSkt7M1agZ8Q6DOSOZg-1
X-Mimecast-MFC-AGG-ID: byCwSkt7M1agZ8Q6DOSOZg_1759783857
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-879e66b788bso122417496d6.2
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 13:50:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759783857; x=1760388657;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fXplKL3U9+yiFp5hWzw6vRxuErqvUQ9NyXTS2v11Bzg=;
        b=liGgjiElDRVS7Dxbq10hBFYvuTDwIMN3JQ5xYRgL2pYm/4mVdSEbJWC19nYMLi6zuh
         e77t/OR23d+LoRTAc9FcLQB1KH9LgKUkQSDLThhD29jXZgyBJDkCeA5X/IzOhDuz6AR5
         VRE+AvSFqe9b4HzafplGVyqZapaNLCKaDVAVIzOfH2o8+rHCxvISC8iYQ9Bev/N5Mg6E
         QR34xHOwx4X96iRj1oEQtBzFIdg7D8yfjs1WxHAkDLouyEcv53VvakWGPoeFOtkAjM4r
         BAooInxDhiRZVPmlMVUjXXzbKsmwplcoY5dyOpaWNLQ4Nx0feZiPoDN8akgHpcUiT6nu
         3YoA==
X-Forwarded-Encrypted: i=1; AJvYcCUXGqnM4NRpvrbYEirhP3iXO6979m/gYmi7YNXWUVq2/RmTDL4LA++Csdx1Yj+AQ2FlJqH82kqz9g==@kvack.org
X-Gm-Message-State: AOJu0Yy5Me5DUV6GVxwNYgORd+yhAD8rJsdnXXc/2MSIwaCb6pgc0dtH
	OfAf98nQyNyoquZ+UNl0r2K1XSZYouO3hJaWbbTggKmRQysAfg6ZiHQQsAwgsMSTNUIhFBxR67D
	ExHgKNBgAl2CNF8aa1w+31IWv7khp6HStrJQCsrz+lIcakMb11kEh
X-Gm-Gg: ASbGncsGAUABokBjrTe4+UCWx+ZZagdvmcX79tTRFqOwXFUcfcrkU3+NoRXG+wK86St
	G1PoZPzb9AeJ43XF7G+pyTCcFYr/f4WFxQKDtTHjuTQDeGH1N1YcCR1NNHjVu8jt/20rEE/nX6a
	do1oFXYNuyfuAQx/wkPd4jEg55grupe4Szd++cGa4YyaFfAdQO174F4Sz/PVVLYgNnsAasINDll
	I7FoQGF17N48jl6s1aFKPH8LexW7HxQTRfzk7aVz4DdiIGjo/rImeuVjvGiMrZOjSgLrVK0cPfx
	drzWY1rAdN5a1WcBQqKEnMsLo/9oX/9lfjQFpQ==
X-Received: by 2002:ad4:5de3:0:b0:870:ab6b:105 with SMTP id 6a1803df08f44-879dc777110mr155996256d6.3.1759783857223;
        Mon, 06 Oct 2025 13:50:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGQNNOyW5MXymGTDgws+yvd18UHEfEytNGukwU/VTaTdl8mj1jr8QxvR4iXFt6HUdiGxhNrRA==
X-Received: by 2002:ad4:5de3:0:b0:870:ab6b:105 with SMTP id 6a1803df08f44-879dc777110mr155995986d6.3.1759783856720;
        Mon, 06 Oct 2025 13:50:56 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-878bae60c89sm124573466d6.12.2025.10.06.13.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 13:50:55 -0700 (PDT)
Date: Mon, 6 Oct 2025 16:50:53 -0400
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Alistair Popple <apopple@nvidia.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, kaleshsingh@google.com, ngeoffray@google.com,
	jannh@google.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Barry Song <baohua@kernel.org>, SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH 1/2] mm: always call rmap_walk() on locked folios
Message-ID: <aOQrrblVobOP8Edb@x1.local>
References: <CA+EESO4h-_U=Xo3x0G_74t_qJQ54AZ4Qd2Ji437aMV8nDZ+tkw@mail.gmail.com>
 <5549ac3a-20cf-4959-ac53-0a89ed0eadd2@redhat.com>
 <CA+EESO5e0gupVfM9NgWqx34oMRk1jGzsNfM=X3idPKaXkRL2fg@mail.gmail.com>
 <7305f905-0f81-4268-a3b3-933ac00cdb6a@redhat.com>
 <CA+EESO5QruRtz8X=2aO8=6P_=uUQuun3f8Uom9gR9-zL-F7dWg@mail.gmail.com>
 <4909d194-58b7-4e94-b730-f916100238d3@redhat.com>
 <aOBWF8uLmm9iQ2XG@x1.local>
 <872c98fa-56d8-45cc-a7d2-1b8d44614640@redhat.com>
 <aOQdVILmD-4Odjs5@x1.local>
 <ae42bf24-e516-46b2-9c67-95df5baffa86@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ae42bf24-e516-46b2-9c67-95df5baffa86@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MMGrTMkTFeVxGfUwIxKujBhZHqOdV-G12bPhSGzhoZY_1759783857
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B1C59A000F
X-Stat-Signature: f8tfs5r86tph1x76rmdy35shyfrmdkar
X-Rspam-User: 
X-HE-Tag: 1759783859-141512
X-HE-Meta: U2FsdGVkX18jPtVEHidf6qcvP7YPgC1GtZbK47XLiv4Hk+tnP097NGZeunSiX+QbJ1dGL6fQAsBUV0OEG1JvaB9YSc9JxooLlhX2mbsgJhr0itsrTyptPzMDBTu1ps/WQWj/aqsIw0/zLLCCWdOzvkAzwfqbVWh5wRwK3RNnjJbFeUYFpi7ErTryLNzLfKplkcKcQXPMxUA3WThBpaZFV7a4p3myK3rOuNvwC6iFSsLZRIbDj4ZC32qHrfcoqm1LbOMwRrhr4VIIaAHFuUu+z2a4F4Aw0EfKW8damyPe1QWOgVv1AFvhTo97U6NlVgeC9pzmeQyU56ykpDpjM9eKihz/PzJcb7JcdGTqafbQWfWIvUov1cPRYRxDvpcMZhSmZr7xUfns3eMjNBmXqn1/qv8lO3VX9SZVT89gVO9Wxap+xoVl+ttCvfgRyFHktTZz8mrABHfjC7XM7Lk8D+UeOaEsNdVXAeqWTJciL3PHrAHhVy4JGxoFSjBeWheVa4buWkvo1I59zkz8K+mxYgAI3r593JRnIAsaGGFWI1bTLdMqeJkpCr1ZNuGL3VfyrR9KNU2yN2rYI1sABG4/mncRRoXoKRCy4pmxgafdkoGOz8ZKNh4snKkagW85seytPBalaJQY6evt8+w7AMYyiMOpG17xLqOmEwLkqZi6IXdeQfJOJTd0UuxZ5e46cXeatSegH+gestX16f/6KSoOZ4wiit79evL7t6sCZfVLCHrYTsXR9m2fc16nHThHMRsvklo6xP5BSLCj0hgaDmmzbdYeBnjU6G6RqtALm+SCEGPJ74RdALLqPAoqs95T46OcwF30YoU85AZK73iI4wQ2Fgw2ulEMPSub9UXBAbFa2B6dfVG6hv7zVa9OU8XKJ+6+U9ZUChpWxtQHqtr5wy4se/zfP1xzRnJpwMuQ6KP/0+mp+ssjuWGB+6sOm4TBXIz3tU19Po09+Z5C5rtXmC7tWzQ
 cbnL8dlg
 wYWWJkp5VwQtyXf8hSwy2KMrP3U+9YpChre1iiCuEObJihoDI62BthKAimZdj2YHOo/8k4vnuBrIkuSa5eyvxwG+C/kFD48yT7ZKXGZVyOLTO1o6yR+m+lwnOop90LvTagralSRs7reioIhE5H/STaH0kZ/valWj59tHBohG+dwOoFEehKVvl+7V+7tcqSk6dDTGald/2aHfJjcVOitFH8CWBdlQ9PKS1UZ/2nstKnXF8FqBUabniWSZJqC61bd2J+zrm7oLjflz/a6U2a6O6XfxxkiwBqxCbqOngZZUXZOP1aqjc9j29B9swOAcuaPpxKRSpwtoIfje9sg245+d/ARBHPH6+dahJ8wblSP3BeheqMnjtoyL4v/9oENaomlenoZvtUi+zmm/CZEjwU7Q5xxfpbWFrw+5OFRUEXwMuB88OppkXhPpNNlJag02IQTRqUlU2OMM5L8sp+c5Mv62+j7mk94UHipZ/cq/eqhzXR6LKjJr+G0JQ8mRMaipuoXHS4Pxe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 06, 2025 at 10:02:45PM +0200, David Hildenbrand wrote:
> Just like other anonymous folios we can walk the rmap to unmap/migrate them.
> And just like anonymous folios, they are not added to a page cache.
> 
> COW-sharing etc. works the very same way for them.

I agree. After all, many of the folio fields are reused here.

> 
> So I think they are really just anonymous folios representing a chunk of
> device memory that is not addressable by the CPU. Apart from that, nothing
> should be too special about them (well, except the way they are mapped into
> page tables of course).

I think they're still very special, though.. not only because they're
essentially swap entries, but also because I don't strictly think they're
really "anonymous", per the definition of normal anon private folios..

After all, they are closely attached to whatever device driver is providing
the service under the hood.  It doesn't really have a page cache, but it
kind of having it maintained in the device model..

The "private" side is accurate and uncontroversial.

Thanks,

-- 
Peter Xu


