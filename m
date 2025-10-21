Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33091CCD1A7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 16:28:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 936DD8E0027; Tue, 21 Oct 2025 12:28:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912B68E0002; Tue, 21 Oct 2025 12:28:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FD238E0027; Tue, 21 Oct 2025 12:28:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D8C38E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:28:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20241BA483
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:28:29 +0000 (UTC)
X-FDA: 84022654338.08.CB2E6AD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id E1E83C0011
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:28:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IrPMp63F;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761064107; a=rsa-sha256;
	cv=none;
	b=OoFsS7Kau0uJcYzZsYhT2F5RsAxi9moIG3E+mDe9sI3M+9xkXAzTwiu1uclRA2VajDKOBN
	FuyF6fvo1DH8bDXKnP4D384vqFotqEYNr+4b8PHK4ilMaZnmwtlOr0k4uQ0CGkY7XxFjRy
	OoJg647AJ8rP8D91VxApVc9T/OcrciQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IrPMp63F;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761064107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sioSGv2R6nSPzmRxdpYSKuGX8pcqdwmqq+r8Ju50xks=;
	b=CAvs26FFLtPvtrlI4lWyIFGSFjkU21zPETYRYq1PNAsj2dPcNBHxZGHdvMiKydgTS5F3AE
	cVnOt/1oTEd1dCSQzeByScPyLtj86oNZvDwC58/inWhPTqAEyvWf7rNfZCNkpB6ib2rvcG
	8kXfTHBOmcc0muN7P0PyC+5jz8n9rU8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761064106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sioSGv2R6nSPzmRxdpYSKuGX8pcqdwmqq+r8Ju50xks=;
	b=IrPMp63FS5T4HPOjwdcZ0jZLz4hty6RxFEeni8LDlYF7q0kyQ7HZfceBkFQOHjkgNKFXW0
	mJjpkGS5uAXyhxWsG2JK5U8Om453IGGoAisWdcZSkSlVy0Yy8k0rvFwV9EoKNbvbjNNhQY
	eMA8WE5xVhxW51EYSS3Tu7VGzhzp0ZM=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-vWc-jn1jOjq5OA1tZmv03g-1; Tue, 21 Oct 2025 12:28:23 -0400
X-MC-Unique: vWc-jn1jOjq5OA1tZmv03g-1
X-Mimecast-MFC-AGG-ID: vWc-jn1jOjq5OA1tZmv03g_1761064102
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4e8916e8d4aso4196741cf.2
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:28:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761064102; x=1761668902;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sioSGv2R6nSPzmRxdpYSKuGX8pcqdwmqq+r8Ju50xks=;
        b=dYT3ek7Ifc7nwx6wBOCYstQatGqRReW+peO+wpd1GMDu2GLPBcM3aRxH6hHCOe7ctp
         oorLetqq/1Eq347Lwb2B8dMkLVyL+Ik9mZWJA4EqnlEopIdIVeDwE1HOOnWqfTboG+ws
         4w8o0bsPBfNiwnBUxz72I7cAx5gxd1rIiSrL+oI7lk4szhYYL2G1tDluI8ZAORd2uwTL
         Z2Bq6JKKpMzEgU/iMS1ZKzoX4eFFMV5tOpnzQTR+/QX38XI97f1w6lzuDHrZj39HHg0h
         40VYJ1LEjI2wWlkwyN7ynGLxwOQrRdQYoAdl0tM//BBbjk+C1eJS9gjYI0kk/UIm00Vh
         ETpQ==
X-Forwarded-Encrypted: i=1; AJvYcCXhT0m8zK4ddgerGKRP8J6yp01pYgHoKHdEm1Fk1KRztt63ONClg1kbtxfleEybPk7dOrjeCL7wrw==@kvack.org
X-Gm-Message-State: AOJu0YxjRcYkLCPPpbX7TO78Z2Ke5xrs/kJxSG+ayhYG9AWcgz9gwyuH
	YIMLzayErNcxtRkVq19o0sUcW11VeQy0Uq4Y9uHYR5fQ7blt+ASKzpgtTJxqsfZdF7nqq3so++4
	I+Q13/SuTgR4PWxTjI9Qm3EamYMMACpmenZ18OGXy0u1EjDGFsTPs
X-Gm-Gg: ASbGncsS4NKm71ljfk4SV0Xik4ZPl2sMzHtPuczWb1dOGPBssytF7e9RTvYM2fV2U3P
	vj8b8VrGWkjaL9oLOEgikR9hxgCr5Z9CEtC8rOqEdI8tf40ccSAp2hTEEdf3lGNluhxq7A6gNAt
	Wt5hGnFtd7V0f9gFzv4Cs2ULFmx+mpu1icJq60WmdZ84c2v2iBN2aZ+RpwwFvrcJgPDJGsi7jTh
	dWAAC+85/jXtD+WbiwdUICjb4xzbmV4OrU0YWBXg6LVHkVutaATstNDO62Yfk5mB784H/IRlaS5
	OraKZZ8wQalWw0aHmCfz9B5Vdx3FefdUOIb6uQVGwI1lLgwIzBGDiEoZ5qlBt4Gzcnc=
X-Received: by 2002:ac8:4659:0:b0:4e8:a0bf:f5b5 with SMTP id d75a77b69052e-4e8a0bff828mr159622541cf.73.1761064102276;
        Tue, 21 Oct 2025 09:28:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFM1Uo1w8gouAcqG+65k+utF3myIC3KHqazzJjQ+llWJyhJmMQcXA/E0CIWf7wbTpckD7BgpA==
X-Received: by 2002:ac8:4659:0:b0:4e8:a0bf:f5b5 with SMTP id d75a77b69052e-4e8a0bff828mr159622091cf.73.1761064101674;
        Tue, 21 Oct 2025 09:28:21 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e8aaf34386sm77137021cf.4.2025.10.21.09.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 09:28:20 -0700 (PDT)
Date: Tue, 21 Oct 2025 12:28:17 -0400
From: Peter Xu <peterx@redhat.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v4 0/4] mm/userfaultfd: modulize memory types
Message-ID: <aPe0oWR9-Oj58Asz@x1.local>
References: <20251014231501.2301398-1-peterx@redhat.com>
 <78424672-065c-47fc-ba76-c5a866dcdc98@redhat.com>
 <aPZDVuscFsYSlQjI@x1.local>
 <dtepn7obw5syd47uhyxavytodp7ws2pzr2yuchda32wcwn4bj4@wazn24gijumu>
MIME-Version: 1.0
In-Reply-To: <dtepn7obw5syd47uhyxavytodp7ws2pzr2yuchda32wcwn4bj4@wazn24gijumu>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -ZcfOyDRpGX9aq2r0QTA450LGy3D5tznng4uBilSDgg_1761064102
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E1E83C0011
X-Stat-Signature: 1uzoidyikr9ogsm4yqo3qmh4o5ut66c1
X-HE-Tag: 1761064106-878475
X-HE-Meta: U2FsdGVkX1+7Sx7cqdvLIZldAAskexnIzKejZN1SJj81XfpXGWIwuIoLjtkwCFN8s51a0/5h9OIqDvIS3g+aByKeQP46xhAwLusuTkN1V5kIqlCXYV93t/g2hxK40auKuHkm2p0rEIJVLtlvXnnpVn5HtLpnsUswXawWkp+bvMV/K9SnG+LcAjP4abZ+JeoZvW6rcNfPouGuUU+0Lp6S9H7sGjMlqJ+IQDUCcPom0iKP5oWWHMs9Z65+onz6CzXizRZgBvDoh0jHlEjYPILXp7l0y/A7FpP0qmCHXPDGdT9SyHLpSag1+KP06OS3uzO1N/HFqlGDC1Ew1rxCzoUoIJ3IqcAOBlrbBE6Q445iDt/KaqKJNn9MT6l02u6sW159ac26TB1XUT9nJoRXs+Fe3qjnFS4QmjVAinhrs/qkQUpylakIIfkWzBXk5gQSSMoIbR+q2t3Qsjf4XjTzqdYGFjE1M81KLy9neIv6JplCpVLgF5gRLCyXuQOKy36T6Okrd55OYrAbEp1KmmTvEqO6oMm8dbNRogr4bXJJ3zMmZSS0Y2zdDIE2QUAisgZnhzPZ7lO5Ot+9YzZ6Tfdf32melkUmMg0Qb3DkSJ4e0Mms015enBx3FgwJV3JDmscN+WJ39aHj0sG3mzvaMcy1HpVy99K4MtFp7m3tcMfZPqQQizWDZ69JtsUJQkjaX9O+Rh/Pm/jnneHNt/owkOa32KDrPCboOg/VhnwFJlGYXq7gpEo1Fl0QqsvKijhBcMwPN6m1/CgLmOPCifpZX9dwFkj6QvBagialQkq4PEY8jmn8RLTHlw6safo/ldzsvbEVAmdUWu75YJsjAH5/vtfdIT0wz623TCrcwYmYaUa+0TCMy6LUmmxHfmn1X0xLco4s4jEOSFepMYBrnJgCyK9g/1P9B7dbVwl80RUu5o59u5mCYi6GPnlZ6wp+ETopdvf1F7gsq/tOu+aWXSGF+EQnG0H
 e4Sqo+3m
 OPPAG92oiwkWiQYvrIT+9x7SR1vPsuvKoK0EE7hTSb5+El5m+G7tHOy2S0NhPRuNESVgvi5etW72Vr2YlCqhH3EihIlztVotwEuQkSi1BMbUjwg8+p3ujlii7gllkHiIiKIbqJwbgkMu4KEXCaAw9d9rjUh8gwI7uXdCs2a7YafphqxepHBSPFrcU3G9lRD1Da/qXv644fBSjzytewObaoa5X+r4Xv6OnHqrGXGBwI+CN9Ih6wcdRUMJGEpgBOMFf4qPWZEXG0ll40ZK9oBX80nPzoyhJzThmunUzyDi3ZgVmRmP0spcGNuzaYNHO6goF0D3Z2zL/p9stNQZescFJre/uW7wrOgwt52YNm8is+u8DFzt/ol/zESK3PeR1ScK5XU1GbYAQWPT8vi1MKfqYOApk3XQ6nj/MuCfr+jFD3qDNMj3IYpfu1U1Psi3vPiQQw2tJpnK6dE1hf266ejtbje4wm/bNWNveaImVaP63AE4RxNw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 11:51:33AM -0400, Liam R. Howlett wrote:
> * Peter Xu <peterx@redhat.com> [251020 10:12]:
> > On Mon, Oct 20, 2025 at 03:34:47PM +0200, David Hildenbrand wrote:
> > > On 15.10.25 01:14, Peter Xu wrote:
> > > > [based on latest akpm/mm-new of Oct 14th, commit 36c6c5ce1b275]
> > > > 
> > > > v4:
> > > > - Some cleanups within vma_can_userfault() [David]
> > > > - Rename uffd_get_folio() to minor_get_folio() [David]
> > > > - Remove uffd_features in vm_uffd_ops, deduce it from supported ioctls [David]
> > > > 
> > > > v1: https://lore.kernel.org/r/20250620190342.1780170-1-peterx@redhat.com
> > > > v2: https://lore.kernel.org/r/20250627154655.2085903-1-peterx@redhat.com
> > > > v3: https://lore.kernel.org/r/20250926211650.525109-1-peterx@redhat.com
> > > > 
> > > > This series is an alternative proposal of what Nikita proposed here on the
> > > > initial three patches:
> > > > 
> > > >    https://lore.kernel.org/r/20250404154352.23078-1-kalyazin@amazon.com
> > > > 
> > > > This is not yet relevant to any guest-memfd support, but paving way for it.
> > > > Here, the major goal is to make kernel modules be able to opt-in with any
> > > > form of userfaultfd supports, like guest-memfd.  This alternative option
> > > > should hopefully be cleaner, and avoid leaking userfault details into
> > > > vm_ops.fault().
> > > > 
> > > > It also means this series does not depend on anything.  It's a pure
> > > > refactoring of userfaultfd internals to provide a generic API, so that
> > > > other types of files, especially RAM based, can support userfaultfd without
> > > > touching mm/ at all.
> > > > 
> > > > To achieve it, this series introduced a file operation called vm_uffd_ops.
> > > > The ops needs to be provided when a file type supports any of userfaultfd.
> > > > 
> > > > With that, I moved both hugetlbfs and shmem over, whenever possible.  So
> > > > far due to concerns on exposing an uffd_copy() API, the MISSING faults are
> > > > still separately processed and can only be done within mm/.  Hugetlbfs kept
> > > > its special paths untouched.
> > > > 
> > > > An example of shmem uffd_ops:
> > > > 
> > > > static const struct vm_uffd_ops shmem_uffd_ops = {
> > > > 	.supported_ioctls	=	BIT(_UFFDIO_COPY) |
> > > > 					BIT(_UFFDIO_ZEROPAGE) |
> > > > 					BIT(_UFFDIO_WRITEPROTECT) |
> > > > 					BIT(_UFFDIO_CONTINUE) |
> > > > 					BIT(_UFFDIO_POISON),
> > > > 	.minor_get_folio	=	shmem_uffd_get_folio,
> > > > };
> 
> I think you forgot to add the link to the guest_memfd implementation [1]
> to your cover letter.

I didn't.

https://lore.kernel.org/all/20251014231501.2301398-1-peterx@redhat.com/

    To show another sample, this is the patch that Nikita posted to implement
    minor fault for guest-memfd (on top of older versions of this series):

      https://lore.kernel.org/all/114133f5-0282-463d-9d65-3143aa658806@amazon.com/


> 
> > > 
> > > This looks better than the previous version to me.
> > > 
> > > Long term the goal should be to move all hugetlb/shmem specific stuff out of
> > > mm/hugetlb.c and of course, we won't be adding any new ones to
> > > mm/userfaultfd.c
> > > 
> > > I agree with Liam that a better interface could be providing default
> > > handlers for the separate ioctls [1], but there is always the option to
> > > evolve this interface into something like that later.
> > 
> > Thanks for accepting this current form.
> > 
> > > 
> > > 
> > > [1] https://lkml.kernel.org/r/frnos5jtmlqvzpcrredcoummuzvllweku5dgp5ii5in6epwnw5@anu4dqsz6shy
> > 
> > I have replied to that, here:
> > 
> > https://lore.kernel.org/all/aOVEDii4HPB6outm@x1.local/
> > 
> > If we ignore hugetlbfs, most of the hooks may not be needed, as explained.
> 
> Those were examples.
> 
> Hooks allow for all the memory type checking to go away in the code,
> which allows for more readable code and less operations per call.
> 
> > 
> > If we introduce hooks only for hugetlbfs, IMHO it's going backwards.  When
> > we want to get rid of hugetlbfs paths, we will have something more to get
> > rid of..
> 
> This is just wrong.
> 
> It is far easier to remove one function pointer than go through all the
> code and remove the checks for hugetlbfs.
> 
> Are you thinking the hooks will just point to the generic function?
> This is the only way I can see your statement making sense.  That's not
> the idea I'm trying to communicate.
> 
> The idea is that you split the functions into parts that everyone does
> and special parts, then call them in the correct sequence for each type.
> New types need new special parts while using the generic code for the
> majority of the work.
> 
> In this way, the memory types are modularized into function pointers
> that all use common code without adding complexity.  In fact, knowing
> implicitly which context from call path means we don't need to check the
> types and should be able to reduce the complexity.
> 
> Then adding a new memory type will call almost all the same functions
> except for special areas.
> 
> Removing old memory types would me removing the special areas only - and
> maybe a function pointer if they are the only user.
> 
> The current patch set does not modularizing memory, it is creating a
> middleware level where we have to parse a value to figure out what to
> do.
> 
> These patches DO expose a method for memory types to be coded in a
> kernel module, which is fundamentally different than modularizing the
> memory types.  Different enough to be glossed over on a ML by looking at
> the subject alone.
> 
> Yes, one value is better than two values, but no magic values is ideal.
> 
> Is it a significant amount of work to remove the magic value by
> fragmenting the code into memory type specific function pointers?
> 
> IOW, instead of decoding the value to figure out where to route calls,
> just expose the calls directly in the function pointer layer that you
> are creating?  What is the minimum amount of function pointers to get
> the guest_memfd to work without this value being parsed?
> 
> [1].  https://lore.kernel.org/all/114133f5-0282-463d-9d65-3143aa658806@amazon.com/

I don't know what you're looking for.

I think I got most acks from userfaultfd developers whoever were active in
the past few years, ever since v1...

Then, we got some concern on uffd_copy() API being complicated, it's fine,
I dropped it.

We got some other concern on having a function returning folio pointer.  We
talked it all through, luckily, even if I do not know what really happened.

Now, I really don't know what you're suggesting here.

Can you send some patches and show us the code, help everyone to support
guest-memfd minor fault, please?

-- 
Peter Xu


