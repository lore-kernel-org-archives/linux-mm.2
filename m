Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BC9FCCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 19:42:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7890D8E0008; Tue,  7 Oct 2025 15:42:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 739DB8E0002; Tue,  7 Oct 2025 15:42:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 629058E0008; Tue,  7 Oct 2025 15:42:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5106C8E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 15:42:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0A7961193FC
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 19:42:03 +0000 (UTC)
X-FDA: 83972338926.17.6E79070
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 79778C0013
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 19:41:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q6iITTHQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759866121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zRD8Y24rfOwZBHOlWyyDCKiTB/jD/NkvAE4w5vB3uEw=;
	b=PLwyAmj1fIw4MyHGwoHzda55tdjuM9fUnymwZ15hNPkIxvMVAmT9jva/tdnpzPVd3w3qVX
	nAX3jo8A2lIK4Fkm8/jsaOz4qudEoPxuG49oPkQ9mWzzlM+sDVE4hQhlClkVkQOvlq2Bxn
	h77qHn0pbjt4/sDMShF5RzA+n2vnO3c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759866121; a=rsa-sha256;
	cv=none;
	b=Y0MQ+7KTt2SE/hBeRS6gNacUyTrsxNfbTuq/PO0GAPe+R5bpw91j0X1f5uhUhaN7Xj5g/N
	Vg2Sh7eDdOFWuW2iMBkyBuDs0egbZLDv7Xfoo66Nvf+MFH/hCa+d+yk18U1gRlax9dgNsq
	/hv5CF4722Uw5OTgj6pQoIr4ML1CxIQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q6iITTHQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759866118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zRD8Y24rfOwZBHOlWyyDCKiTB/jD/NkvAE4w5vB3uEw=;
	b=Q6iITTHQYvb11sUb0WooAJWW+t8YUFEpn+gw+9vss1pYAjSVPinQo/ecqF1n68ldU9RsHa
	UU/zvlK7wxdeijjcUlGr7Mx2TvqrOIV4khwTQEDB24RAmvZnAAlqGVI6v3+JvUY4zSm4/y
	S4cHsRH4UrUxtRG7TXhO3U6oarmBHMw=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-W4CHa0mhN2-tK-dmeN1WTg-1; Tue, 07 Oct 2025 15:41:56 -0400
X-MC-Unique: W4CHa0mhN2-tK-dmeN1WTg-1
X-Mimecast-MFC-AGG-ID: W4CHa0mhN2-tK-dmeN1WTg_1759866116
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4dfe8dafd18so271942191cf.0
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 12:41:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759866116; x=1760470916;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zRD8Y24rfOwZBHOlWyyDCKiTB/jD/NkvAE4w5vB3uEw=;
        b=SWKbpk+pAX1Ym5gjfB9wSBcq00cHQe7ZXmY2aq/1A13n2kgLTNPew3crE72Nrfcyqr
         7hfz3hJJfqMqME+UW0EKd1LxPOtos50b9UMcJ8PG3S8mAim46BkhPszQzUOJOskTeqTN
         HvPX2zNgcYlfTFLTjq6jIosG+7ZQj4LY41MiExIBGnJOvcrD1A3f9VLF6eHsWUv18XyO
         Du2/Rui2iWmAop+eE7pRaiNB7sd5sMIk6mIuXyigHKWTHOSc//sfw8sQN0FvIuVWyvvN
         Sh4blmGFtSqFcLXdZ7p4LnbIyDZv607s+kBn0PfgRw4++3MVnC1wENjWiulfzQAnQ8kR
         ym3g==
X-Forwarded-Encrypted: i=1; AJvYcCV/8CApE/j+biXSgYuKubyLXY0GYnWYxXqwlMkRMmpprq6GsTc67yGnxQSQ4MTNsp+DOlnxWWMhmg==@kvack.org
X-Gm-Message-State: AOJu0YwqtOhTt53kvAg/+Jzb2afrGt1GUbc0N+wRtCwlSh0FWaR02shn
	76LUHDG2wDpRP+TO5EUblS8lYPx54VsV8l/vLfYrYILvEaekfdPBiVQyVHTXkqql7mDlcMT4hL0
	h6CnwoR5g9WIViKdFnj+Zfh/+yb07PEoa/1KIzMgZHy1e6JAupAk6
X-Gm-Gg: ASbGncuQv6NaN4KY196ctGBJZ8o7E8pp7aGIQNGAbM7TwH/SEsvFx8IeU8P8WAKMPKO
	mo+FJYwT50+RnTHz6BNYWkmfFDxl+VtexQXbkhKG35mNqo4Gj95rCLPclKJ4jWrw4lTNAIUSZgC
	L/QuNKyaj7qav5DVnksLyKQAmSzkEsU+sw4TgVJah/zaCvpPZQ6MCHmpiSYjcSy1G4/UPrTEpCl
	3MBLKW3KaLKndNm54YmQfwGJUVGRiToF01LuHgWw5FvyT0D1OC8dzUbmofHTl/9kL6nAf5fD7Eg
	/rDkfARJ0eccedWLdRl3NKgEtSTiKNl005liqg==
X-Received: by 2002:a05:622a:2593:b0:4dd:2d5a:4c81 with SMTP id d75a77b69052e-4e6ead6b8d2mr10550851cf.80.1759866115752;
        Tue, 07 Oct 2025 12:41:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFGlDdIA/7LCIBCuSR0IVfWs+CBYQn3+44+6aZyv0zDCvJHB0MK6MuVqYhuG/1465hjHYnfrw==
X-Received: by 2002:a05:622a:2593:b0:4dd:2d5a:4c81 with SMTP id d75a77b69052e-4e6ead6b8d2mr10550231cf.80.1759866114994;
        Tue, 07 Oct 2025 12:41:54 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e55c9e77bcsm149262041cf.24.2025.10.07.12.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 12:41:54 -0700 (PDT)
Date: Tue, 7 Oct 2025 15:41:52 -0400
From: Peter Xu <peterx@redhat.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Axel Rasmussen <axelrasmussen@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	James Houghton <jthoughton@google.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v3 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <aOVtAMm8PqEbGANh@x1.local>
References: <ad124fb6-a712-4cf5-8a7e-2abacbc2e4be@redhat.com>
 <aN_XZbQjuYx-OnFr@x1.local>
 <cq3zcvnajs55zr7cplf5oxxjoh54fb7tvo23hehd5dmh4atvum@6274mneik6hu>
 <aOQuZy_Hpu1yyu29@x1.local>
 <akld3v2mtnjdqvs5dgwr4gnffdqf5dojwhmfylq3mkfzakjj7j@5oqqxsymkcbp>
 <aOUa8C8bhWvo5TbV@x1.local>
 <frnos5jtmlqvzpcrredcoummuzvllweku5dgp5ii5in6epwnw5@anu4dqsz6shy>
 <9089d994-262f-4941-8bed-f3c6ee05a769@redhat.com>
 <aOVEDii4HPB6outm@x1.local>
 <6csw4pmymno4kdtlbzd74posr3dekamq4zkje2mfkmbg5q7xbx@y3o323tbm7h3>
MIME-Version: 1.0
In-Reply-To: <6csw4pmymno4kdtlbzd74posr3dekamq4zkje2mfkmbg5q7xbx@y3o323tbm7h3>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mjksK2UNuzyBIX5RuY_8qRLKJq4o8GEToSnTxrmfl8E_1759866116
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 79778C0013
X-Rspamd-Server: rspam02
X-Stat-Signature: zqtka3rtw64qdcuqbu91bw3g7dem6m7y
X-HE-Tag: 1759866119-480755
X-HE-Meta: U2FsdGVkX1+uq9zFw7VgYaxrza4yIZAMOD/SKHhQhUNpoKZORax5fnpjmcbLevk85451FgMc1+t8d7JRUyQqlq140Oj4q2Psk1+kxnGkVW1XXqv0qtceQV/tPnG8SFkhwWarkqsz3Jvl66r+zcj6fVCoY39pHVRNa3ezfcFFQ12MwHVS5G5hB0VI7bbyDfdeBiVMcXQJ9Dn18ooHBDlc2ldMTI7+0gtbZlOG1c/TcJUHY4bU4VDuLyTdhsZyLrq2zRWv0YHbY+tSjOFOClTIibnMtigvLbWr00Ta6uQTOcWXIHhURUA0xpFToSr/QxafAggqc/SosXxBNB+0glVvhEymwhDrmZHow6aBFVNrJiCxsd1030RIlDQMfvt55Jw2P43Q3YPqFyuwAjPr0Bs8Q+RfVNuX0INQsiSnAOeXdUzKa+iKEQKaTI8ud5pOg+cuPD7VzESTa1lujU/Opuzq1i1fhwVSM6enM0XqWTIVQaQCaLuaIvmpk174T5hrDsrhf1W33squzLCXKfbtVhIVc1eXoLzTcbZvjp/rBJBzlEaoCDw6mw4PNQ99uE/yIqORFC7effAe4zN8W3u8QocMGjZ93oUrriY/ro63Nzf0b1hKM/5j2IjSVHsAndjMfXPHqipgnhIjV0FPBKu06wlW8bxAsLJqkn+bPBNCwxhU+NBjNCSLL3Qzf7Jfhubu+DBzr0S2J5NnauwAnjqjQTLx7TyL6jlUsl0perjj6gfp4J+/ZH1AYhXjyixZIuuuUzhQtIbzsf/KtiDLzEy0CaR7RrxIlBE0HNGPfxcQSC2BsDYxlfV87h4UbDWyzASbwc1RwU5zAEdk3sW/CsDb4rxzCEK/eG17TAHULt2lnhJWfZ62JK8JpszbiEqoQS8UJAQBnX+1ijDAJV5OvtPjT2NuFdYXYQ23VUDKpRkN+FzyCS143l8Jd/a6OX2Wmn0uLP72ir7J9ihlblbdwBQ+txu
 I9wsORJF
 eaJwGLRJov8U7PnBtvggx8buO4QvGhr4qfG4HvMZjcSCJ02g9ut7q+VbdnKz406R2OjbovVjeeO+iv1ckicLIKeMl64FngoZ9Bn918MozN1eDRg2oBUhcEZ86yAW1IB5OVb8fBQTjFB9uxaAxBiVm88XAZfkhHDAb55DKZWsoIB9fLvhhbKH13KPCyHa4c8zbFH1LysxYbEzp4UE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 07, 2025 at 02:46:46PM -0400, Liam R. Howlett wrote:
> * Peter Xu <peterx@redhat.com> [251007 12:47]:
> 
> ...
> 
> > > > 
> > > > This way is_vm_hugetlb_page() never really needs to be used because the
> > > > function pointer already makes that distinction.
> > > > 
> > > > Right now, we have checks for hugetlb through other functions that "pass
> > > > off to appropriate routine", and we end up translating the
> > > > ioctl_supports into the function call eventually, anyways.
> > > 
> > > Right, it would be great to get rid of that. I recall I asked for such a
> > > cleanup in RFC (or was it v1).
> > 
> > I didn't send RFC, likely you meant this reply in v1?
> > 
> > https://lore.kernel.org/all/0126fa5f-b5aa-4a17-80d6-d428105e45c7@redhat.com/
> > 
> >         I agree that another special-purpose file (like implemented by
> >         guest_memfd) would need that. But if we could get rid of
> >         "hugetlb"/"shmem" special-casing in userfaultfd, it would be a
> >         rasonable independent cleanup.
> > 
> > Get rid of hugetlbfs is still not my goal as of in this series.
> 
> My example picked hugetlbfs because it is the most special of the types
> of memory we have (so very special).  If the interface works for
> hugetlbfs, then the rest will use a subset of the features and be happy.
> 
> IOW, doing the hard thing first makes what follows easy.  Doing the easy
> thing first may mean rewriting the easy thing once you arrive at the
> more difficult part.

In general I agree, but hugetlbfs is special when it is major-feature
frozen.  IMHO we shouldn't design an API to suite hugetlbfs, but only
trying to move it closer to all the rest of file systems as much as
possible.

So the generic API should be designed without hugetlbfs involvement.  Then
if there is guest-memfd / hugetlbfsv2 / ... they should fit into this API.

> 
> > 
> > OTOH, I generalized shmem and removed shmem.h header from userfaultfd, but
> > that was prior versions when with uffd_copy() and it was rejected.
> > 
> > What should I do now to move this series forward?  Could anyone provide a
> > solid answer?
> 
> My understanding is that we need an interface for memory types so they
> are modularised, with the short term goal of solving the faulting
> support for guest_memfd and the long term goal of code cleanup, or at
> least don't make things worse.
> 
> I think we all agree on that?
> 
> I propose that we need to add the minimum amount of uffd_ops to support
> guest_memfd's specialness without creating an interface that makes
> things worse.
> 
> It is very difficult to see a reason to pass in two variables (modes and
> ioctls) to dispatch to the correct function in a struct that could

The reason is "modes" cannot directly be intepreted into ioctls.  But
indeed ioctls can be intepreted into supported modes.

> simply point to the function in the first place.  If we can avoid that,
> then it would be good.
> 
> Looking at the example you pointed to here [1], It appears the minimal
> viable product would need to implement this:
> 
> uffd_ops = {
>         .get_folio = <>,
>         .minor_fault = <>,
>         .atomic_fill_continue = <>,

These three are fundamentally the same thing.  As explained, if we have
get_folio() we don't need the rest.  However we still need something to
describe e.g. shmem supports MISSING mode.

> }
> 
> Then shmem and hugetlb can define these and end up calling them in
> today's spaghetti, but we are free to append more uffd_ops to reduce the
> spaghetti later.
> 
> If using new #defines to clears up translations of features/modes and
> ioctl codes, then please do that.  These should be removable once the
> uffd_ops grows to support all necessary calls.
> 
> If there are places where you need to consult the modes/ioctls and a
> translation does not work, then you could add something to uffd_ops that
> is NULL for guest_memfd and use it to determine if the code path is
> valid.  But this code should already exist for the other memory types.
> 
> What does everyone think?
> 
> [1]. https://lore.kernel.org/all/114133f5-0282-463d-9d65-3143aa658806@amazon.com/

Would it look better to you if I drop uffd_modes_supported, deducing it
from uffd_ioctls_supported?

I believe that's what David mentioned very initially here:

https://lore.kernel.org/r/f1da3505-f17f-4829-80c1-696b1d99057d@redhat.com

I'd rather go with the two fields, but if we're trying to introduce another
feature sets almost only for vm_uffd_ops, I'd prefer keeping it simple, and
deduce the modes from ioctls.

Is that ok for you?  So it'll have (1) get_folio(), (2) supported_ioctls.
That's all.

Thanks,

-- 
Peter Xu


