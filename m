Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23B43F8FA72
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 13:06:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F03B6B0098; Tue, 21 Apr 2026 09:06:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C68A6B0099; Tue, 21 Apr 2026 09:06:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B5666B009B; Tue, 21 Apr 2026 09:06:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C4736B0098
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:06:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DAA2D160D8A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:06:10 +0000 (UTC)
X-FDA: 84682586100.27.AFD627F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 77586C0018
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:06:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=K1FR8HI7;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776776768; a=rsa-sha256;
	cv=none;
	b=64xR9IN+ARUkWCe1jj7crGkwKGkxXKHttNlcrRgYdh+I4dukcK7GihV3t/Afxtun416YEY
	2sal8MKBIsPA+y8PDR4SNJvXeRc/LCgQco4zAek9v1Rw1FLQUdhV2zjv5TeIHSmbg/jzbW
	2SCvuYbksfP4S5oyCdYH7oZmhRNACS0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=K1FR8HI7;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776776768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z1rvnWiWbaVtbuakXF1GY3gyQym0BGWKhGhCncv/qMI=;
	b=03grcEICIWURTpeeHwv7IZ8eP9ud7ndB2F4yvrAZOgSVmJ9VC9HJDq2WyAod6J0CQKYiUa
	zD8gPUxuLHOiw248w9rkWlpcmZuak1r2QNKsXwdPh7RCMgK+mhg3w+mmlEYFaNcAE2xPu6
	MfKEdV/fAGsNmahrOi0fm5wDS/yQyK8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776776767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z1rvnWiWbaVtbuakXF1GY3gyQym0BGWKhGhCncv/qMI=;
	b=K1FR8HI7+aJTrOzd6hstviNxyAWS2Xn+xz8TI29K1I+DDewdleqMT9bKzFlFYTYTzws7GJ
	QTfjjzrz4gJ98gyn4YDQfg9uGMhsMNAdAbtGQJpWBIPkCeMQiibSDeekGvK/3+0RlSWniC
	7DRppX8Mp8RE/FgHQNmlTfTyEX+hn2c=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-29axtkzEOTesab_PEqVncw-1; Tue, 21 Apr 2026 09:06:06 -0400
X-MC-Unique: 29axtkzEOTesab_PEqVncw-1
X-Mimecast-MFC-AGG-ID: 29axtkzEOTesab_PEqVncw_1776776765
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43d7757463eso2890493f8f.0
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:06:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776776765; x=1777381565;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z1rvnWiWbaVtbuakXF1GY3gyQym0BGWKhGhCncv/qMI=;
        b=npPrpsDHCpmyxf+sdHZNTY/ZNLSs+jmAmcW/C5ge908cO5SFxF5r2NX/gDWWxcu4f+
         LD4mc7itaIqO72cPX7NnhlkC9qcoD0cBZSHrLXBo9IzpGRzeupOY8qdQX284gxqhFjJ2
         tPAOlPe/5hguTeybrUmAaKEPj72qrZnCg2JmRef/9tMV1Dtktgr7p3GmrLRTGtIQGMi4
         7RD3Pl2ayeSnR/fJa8lQhB/9/yw4BpFPft2O6DjWdMyZVCkXe8ZybhOdk+fZQGJBd59P
         4Zo1F2FiKfH7z2ZdfFy+g97y1EFUdsndvJvC7ks9nqaAhhBxcsU432+APkZT2tsDTCRW
         w11g==
X-Forwarded-Encrypted: i=1; AFNElJ+LWGOpAmkn+KXh4eEHbo3AB7j3Hjg0G10LFBpBpxiu1GYct8YuPZQtkr9vGrH8/pg2vvMVJLxWgQ==@kvack.org
X-Gm-Message-State: AOJu0Yx6IYdsAXTLzjHi+iCNldw4wkorUjh2wh0mWvezK1vIU2AUTg4B
	6K17NpbTkGUpc+9nwLMlpC71sMePwYrGBju2AGEnQIHyIPqrsH1t1Eez4Zyqzjo3fE0Sb7mGjUZ
	3de/bz8/0U0F8dp31xqeyC2cVYKUkLzVucZ5wFYPooVEZwF1bQC3M
X-Gm-Gg: AeBDieuNM3KGAawoV7YAUi0y9dBM0MrG+AXF3uCVOqLRLqcn722hMGXiqropE5YEwhP
	KY16p+2pMiP/R6wt75oWNJHKDQuFa5qUhMHeaLWMec/7A0h/tSq3134oFUol/jYySXblHTHrPcs
	mqup/eMJ6S/sEpJh5Zxx1tQczyXCSNBbIfCmdOPvUXX9ijWOw3JyEW1ciEgVXHuvScq1eIUoccq
	5vlV8z4uXAHUiazE18kSpgEs+GXkKsibcH0pf6R0sy8wYy4cxyJe3W/sLEdAFLcbYkhBC+cPUyM
	LMzsXIf/W7uoKReCSDCjqQsb9y7AaPALNYRATJ/avzHwGQPzWkocGS35Gk45rvGwfYEPsg7hgHy
	8hRlCIc8jq1twdMGJVLfPPs+aSNPUZFPnFyxtySrcdUzZh+2d6UBkFw==
X-Received: by 2002:a05:6000:2a0d:b0:43d:7a5e:8162 with SMTP id ffacd0b85a97d-43fe407df74mr18663583f8f.15.1776776764970;
        Tue, 21 Apr 2026 06:06:04 -0700 (PDT)
X-Received: by 2002:a05:6000:2a0d:b0:43d:7a5e:8162 with SMTP id ffacd0b85a97d-43fe407df74mr18663537f8f.15.1776776764395;
        Tue, 21 Apr 2026 06:06:04 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4dc26a3sm42414615f8f.15.2026.04.21.06.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 06:06:03 -0700 (PDT)
Date: Tue, 21 Apr 2026 09:06:00 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Price <gourry@gourry.net>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev
Subject: Re: [PATCH RFC v2 00/18] mm/virtio: skip redundant zeroing of
 host-zeroed reported pages
Message-ID: <20260421090341-mutt-send-email-mst@kernel.org>
References: <cover.1776689093.git.mst@redhat.com>
 <c199e47d-b2fd-42f3-9e50-c47c848dc72f@kernel.org>
 <20260420192037-mutt-send-email-mst@kernel.org>
 <aebjG-qMLr0joG61@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <aebjG-qMLr0joG61@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mzc6Cn4dKfTzkk3QLv8FUTETvN1nPskLLBpvM3mRxzM_1776776765
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 77586C0018
X-Rspamd-Server: rspam12
X-Stat-Signature: pg9ybosrc4ybzrphk7asgtswp77jsp67
X-Rspam-User: 
X-HE-Tag: 1776776768-130061
X-HE-Meta: U2FsdGVkX1/lh4prnL2pvy3UNlmkji4HjdCRA3y7P7CpjLJ4cpb9BXwOp2B+wwG0r6Rwmmx9zTeohRrGHebcTs1ExcEc7xy3OBjKvQ+boKVZpOkH2rs9NpqRRLxe1bGKEpbZgOONuVXE3WL9+u8BhiNzA33KLZHHF5katseQstGRm/IFMPOg5VBB8aUcoyoqbi4rGDTEGt6IugElY/BW2k0k3L085a8em4uqfXh4zoI4VOryX6ZAvyJA1ixfRlzGLmHXkMpBD/ZEFpboWVzvSpzfTib1r4ZmaBnF04QS8rKVAoHK1naBgszSA28BHC/WkW9Tdd/XH95kFDPwfzjmIgdnYPadPUsDQ5Ej4tJCLBGeolVMiprBZHs3gDS35zfvr5y3LKwiypoYEWW7tn7H6ajd/f52XuJqjQhLFbGiIQNzy0ImnYGU5Hq/K7qYMd5BJaMnsow/sgJa51UdymwT0NAnXWY+EdKLUR2iG8Yhn3q0jtAgA4x1PTcJqjBVOM2fKcdHE/2rhY33km0t081RbYLPoInvxUnzvjjwcYJItA6dNOriALcPHLLWefUURMtSYvyA0o5LdJ8M+BFhm50WZE2+hHVMMTuAPpq92+umq9rc8q1rcemFFQ4VFRRZDnAaW1NbpdXNvaXnVn76896MB1GuCjpTVtA6FP8Pz5C4PvOcnb4XOjd86F6QBmLMG3Ihg2oB+CkPa8QYoKXzT3iuem0lMUrpI/Sx6WFrL98kJ9VahPYJXI5Q3qWG+k4razg9R5ij6+qFCSpGYjvO8tSJAqHWv90weQn5pdS/zJy/C4TVuVrBR+c2qTOBOETxTH+ByLEugTTnCKOoppkyWRhKfzT3DgS4nya+fFFVCnjzOIOfkg6bGRj0jocNyc0Wm3ud0r4eq1OfCEl7EjwIIoIFJHghkzvW2cEOjhusXV6BYZYoGRt4EBw0L2+9859WSvCqB8SUYLYsZgRM1Fi/wi1
 H99Bu/Zn
 o7z7Qj7Chhj2fGqR/SAEtHe/O9MU4Cx5gloScZbRdjbPO61BTiODfn4DxlFzYiy7DIyewg6pqLmjOui+thZJSgrQuvVlZ6pDmgY9mvMX7P25SQ5tpHHTo3kQ+hTAU9+ilDWLiuSPyYU9uYuRVa4DhOY2rpX3QiLvrgpUoPLKhZmJ9Pu6bczdAwCxOvE17Zr5NFOpGr+u9Xex7z5rqEkCACTDg5X+ZbjHOdEcLSQNvvhaw2SXSfx/6qpXQ/gV6YubhSGjU4Zp2r7++G91rIs+IhpwkBjNC8aRDFV6TtB01OkKblQE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 10:38:19PM -0400, Gregory Price wrote:
> On Mon, Apr 20, 2026 at 07:33:38PM -0400, Michael S. Tsirkin wrote:
> > On Mon, Apr 20, 2026 at 08:20:57PM +0200, David Hildenbrand (Arm) wrote:
> > > On 4/20/26 14:51, Michael S. Tsirkin wrote:
> > 
> > > > A lot of churn, and my concern is, if we miss even one
> > > > place, silent, subtle data corruption will result and only
> > > > on some arches (x86 will be fine).
> > > 
> > > Which would *already* be the case of you use folio_alloc(GFP_ZERO)
> > > instead of magical vma_alloc_folio() + folio_zero_user().
> > > 
> > > I don't really see how vma_alloc_folio_hints() -- that also consumes the
> > > address -- is any better in that regard?
> > 
> > By itself, it is not. But the issue is propagating the address from
> > there all over mm. If we miss even one place - we get a subtle cache
> > corruption on non x86.
> > 
> 
> Why does it need to propogate?
> 
> Can we leave folio_zero_user() callers the same, but add a PG_zeroed
> check in folio_zero_user() that skips the zeroing (but not the cache
> flush) and clear the PG_zeroed bit?
> 
> Is this feasible?

I do not see how - this would require leaking the page flag out of the
buddy allocator.


> You don't eliminate the folio_zero_user(), but maybe we shouldn't?
> 
> (a bit naive here - i haven't checked the PG_zeroed lifetime, i did
>  see it overloads PG_private - so this might not be feasible)
> 
> > 
> > I also note that we need a flag for free in order to implement
> > balloon deflate as you asked. Here, I reused the hints.
> > 
> 
> I'd sooner just implement this as
> 
>    ___put_folio(folio, gfp_t)
> 
>    __put_folio(folio) { ___put_folio(folio, NULL); }
> 
> And change the free path to take overloaded gfp flags.
> Some of the existing ones might even be useful as-is.
> 
> It's essentially the same thing, but prevents a bunch of churn and
> saves us a new concept.
> 
> optional gfp flags on free seem like genuinely useful interface for
> certain callers (definitely not all).
> 
> ~Gregory

But we do not have a gfp_t flag meaning "this has been zeroed"
and when I proposed something similar in v1, David hated abusing
gfp flags for what is not an allocation property.



