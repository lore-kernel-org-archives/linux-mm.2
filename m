Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 087A2606A335
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 11:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZcIFm6+K
Received: by kanga.kvack.org (Postfix)
	id 111336B06AD; Tue, 27 Oct 2026 07:01:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E9476B06AF; Tue, 27 Oct 2026 07:01:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F40346B06B0; Tue, 27 Oct 2026 07:01:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4E166B06AD
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:01:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 68883409B2
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:01:52 +0000 (UTC)
X-FDA: 85368116064.16.50027A1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id EC368100012
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:01:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZcIFm6+K;
	spf=pass (imf05.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793098910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mswFdaLeZadM3beKHgTV0+pA+8tp/9smRtFllvNXA0g=;
	b=djAMhOuJreM/uoOw+EeXLQt5kwsB/hZoEC8vXszP0ZgGhRukTFP5GNgPUFHlL2aabR0juP
	a8iLFDzo8hiQdaZNyNxcCxAMXrGm1Xh73Y+tYW8mLGTmw9c5kYEER/epwRQCWFdleMwCKB
	enWX83D0JxfZb8HRBn/TKq6I884+EWU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZcIFm6+K;
	spf=pass (imf05.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793098910;
	b=LH3k2xXqnaWKEPfUNxwO74wU/qdHYr2ouxIO0fQKj3dmseM9mgOye+fDyAKFH0ziccGS8f
	l+h/n3WQENYvay1kBz6Jh5boozW3bZ+65uQNCNx+/4nFC0vroxb7f6d7kNORbrH6jpbql3
	e3HM8pogvvpZGwFUvxU7N5e5DxeNqRA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793098909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mswFdaLeZadM3beKHgTV0+pA+8tp/9smRtFllvNXA0g=;
	b=ZcIFm6+KMrPqs5XTHWruxYF/YnpQSS13+DVpBxh0cN85dlwzjzF5GcdWwaNUFTnKMCkXeR
	uuQjm1+bI3UVwfaBzt2W+rLWBnPEH0jJFlIbmC+jQLEBxboHRHWMfb0cg6cbsxzmEmhBx5
	3I9FK9SuT7qBvxGfxYsIrWfVC6mAqDI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-530-ap8VWlliN0OQlVaKZfkrdg-1; Tue, 27 Oct 2026 07:01:48 -0400
X-MC-Unique: ap8VWlliN0OQlVaKZfkrdg-1
X-Mimecast-MFC-AGG-ID: ap8VWlliN0OQlVaKZfkrdg_1793098907
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a2b0669946so22034885e9.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:01:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793098907; x=1793703707;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mswFdaLeZadM3beKHgTV0+pA+8tp/9smRtFllvNXA0g=;
        b=XF/lddmLP9HNb7hbNzM1PbtRWCcNAtvOCeaRWMINgZPW+nI3uUbTgSLbW7vfXZboiP
         adM9O1jDcLKve80Nfv9SjyXVT952t4B7nxC4HG24lCFBJe4cqnvK2J8OC3Omg9P0uzAh
         FJ1HAs12yX5xdhEYyhZYbdnXy6Pro8tGBZlVExDITQ1UArH7Aw7Lxa7wrrr2eQ3nfC0J
         uPTWyPg6LPMJRW//dBxxLxdhOVK3/y02d4XEvLKIzqXcUJ3CeiCjuawA0WQbb3l7xDqZ
         I3bJPYo82tqKeiJMujBGHBgfBkUPgWNVKJT89gdPiXbhlG713ST5P2+kp2i4lnQSqf83
         hR8A==
X-Forwarded-Encrypted: i=1; AKwUvBwX1cqYUNXXGFt4fNu30CepSeZ5wIkhncAzKZGHZmCTxwlTHnsmBupjvODOO4Vr3TPnkMp6+9O98w==@kvack.org
X-Gm-Message-State: AFq9FYLf8Xzdrd0NGNwiIPdHbAGLUny34knofNiu8JlzW+wjGjXYCfmX
	XhBOm4kZjtGToWJBDvvPzm6NRHNkc02jPDWBmpTQRVKu02N36Rx+iy70XD2kRGFct7wL68TE3yr
	Br4M8OUQez1JDzYhMQdo+xchHCVO5nxfEVp0RnmACsWKbLZGSnJXEG2HKdrUYMu/6YDxEfDEjm4
	d5GlkFNPpbohNWD28xCFwiI31d6H8=
X-Gm-Gg: AYBFou2qHIkZGDDiMl8Q7InpNCVRbhUDOKl3jANY30f1nMKob1W/U2K6i08bKspFpDC
	xDE6Vhx1PlislvqXEDtPLjKUKtLgHh7W8MJZXeKgXeGoRF1qiAJgiUSthLubK1cPbfGKUQ/heQ5
	FyeJO3xTk4AuYc1v0XptwKWqWxGHrlMWl/3WoPQ9O3JhD79Lg80V0YPwthAx6uB93nCbHZLgi6H
	8Yknc2CU3CbajgBoBWxMKeR4sMyJrVTypr8I/xsnIidHAQ7YDAHJUbkKtV6VA==
X-Received: by 2002:a05:600c:8b6d:b0:4a7:669c:c988 with SMTP id 5b1f17b1804b1-4a7669cc9d8mr64989105e9.23.1793098906381;
        Tue, 27 Oct 2026 04:01:46 -0700 (PDT)
X-Received: by 2002:a05:600c:8b6d:b0:4a7:669c:c988 with SMTP id
 5b1f17b1804b1-4a7669cc9d8mr64987735e9.23.1793098905407; Tue, 27 Oct 2026
 04:01:45 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20260804120529.1730187-1-pbonzini@redhat.com> <at9ahKiYsVtH8kpU@google.com>
In-Reply-To: <at9ahKiYsVtH8kpU@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 27 Oct 2026 12:01:32 +0100
X-Gm-Features: AclHuK_gMHxkpSkqtzZpmI4E9n3tRQVDE0ExdUQ32JdSX7MqnvWed3WEPGPoNjU
Message-ID: <CABgObfYgZ87=W+6E=N=WwTuyYkaoKU3hqd84JDTSAvT3_9dh6w@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] mm, drm: fix interaction of .pfn_mkwrite() with fixup_user_fault()
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Alex Williamson <alex@shazbot.org>, bcm-kernel-feedback-list@broadcom.com, 
	Boris Brezillon <boris.brezillon@collabora.com>, Christian Koenig <christian.koenig@amd.com>, 
	David Hildenbrand <david@kernel.org>, dri-devel@lists.freedesktop.org, 
	Fei Li <fei1.li@intel.com>, Huang Rui <ray.huang@amd.com>, linux-mm@kvack.org, 
	linux-s390@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Peter Xu <peterx@redhat.com>, 
	Sergio Lopez <slp@redhat.com>, Thomas Zimmermann <tzimmermann@suse.de>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HvO78-ANRD3hyyjl_bGAy_6GBk4ActcWl4GQ5Ct1hxM_1793098907
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EC368100012
X-Stat-Signature: byjjjamjsbfyt3jhu8jcb5m94ea58j5y
X-Rspam-User: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793098909-72165
X-HE-Meta: U2FsdGVkX1/oj1peijAR5qd8+Nbpnrgh4L/WVY5Lk5z0+AgxGJ7tKCnLKarWEpZXpXG0vOmdeL4zO2hJrcV6W5gSH3RFNaDKuxbea9dt6qOvkRyJKWLIsme6V+NFzOzUTCt8B+YJhZjsSY4QxsWWzrUaatUnHTGa2U3v+4QHx03PhwWnCm7UQaVRO1WBW93HGfM2RTw8mwwBlm1/bh8uTQWSBU29mh1eAZkIYnJ6e8Ojjb08cIlTxkaZt+FhPXKSxLIQUExgkvtN+kySRx/Vs3gUZdePCgwZkXPhQYA6fHNKVtiueh3c6hwdgIBNovBdf7vleMVKWebRNej/uPFkxvo/JbxnBjjVrRNrZ25jf/+eaRU3AMHdJkz95uDmCOxEhiZuwJw1iGV/7FepQRKe4M622+GD6Y8XWCNDP/zY9kdeU0CIQfPkygE2xtRbBrBj34cac4NuUM0fXRnsZzfSXNhI2JINdNqIy4ilgdQGhIVO5WxcDAW3KZiQ70oH/8ecIqIgssZHWkU4KA8T5ea+J0vvSh2Yr6io0/7vEVFDA/9maQNklkGHY+PatlcaUMb2h9ZYA44FyhLP/hnVj+L8704EHmuGsSLdjEucadD8fZVA4GnhSqgucj3DV4NISgqUKMK4z6CvqhHfUByLe/hiu9ewvwYaEUuD+8bd4rH+2wIVEQFvvFdDF5EhDlmH3SnBQtJViIXgM866Pvmcs5MrZXWWH5oMP2JEsW6IMNxoBnY4g5ahB+HyDCMiQ01BGu9tsWP083aHQ1GgZZId/XERvbRToTUSG/o1870QO8v+w3YSMVfIoLD00dHJZR3q9q9XRlc7PJUVerTkqftuFKWaKY5yZIdzqGDIRqpMxcYwximzqxJErUUT7r7NV9iL8kaw4IpTLY2DiKJ3UE5aGlXEq7GAqAqei2gQI91udIl3VLwRrptMOwQ94i1mZuH48xlvVu8WFYYJFLiQK3tODW3
 NstaqWpU
 9o/e8ziihxbpmlbZVOF8+Z26RNyNfYWjipcEidEF9KWih4IfO6PE/E24gsWp+RHiYBnBT1M3ITVVq4YpjELn85AgKUkF8ML0SdFz6TCg2DtWNVUC9dFeeoh79WZEU5j+3qWqybyMhwo24c4UPeT3Mx3MsrAQTk0VtqmGKp6/rFdmQrAr3zg71gT+0b4iAn3qEFXzJEvI7J5DrRrGrGkO6OqJPIt0mTGaHynP0qEC4Gy6sUIKKInuwKcARW815AfS+Rip1tYlcXxbHX8Mx4h/ZyqPBjZjrDmhP2K3H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 2:50=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> > To sum up:
> >
> > - patches 1-3 introduce the new MM API, and use it in the DRM .fault()
> >   callbacks to install writable PTEs in response to write faults
> >
> > - patch 4 is a preparatory fix in KVM, eliminating inconsistencies in t=
he
> >   handling of !VM_READ and !VM_WRITE VMAs; these would return different
> >   error codes for a !VM_WRITE VMA depending on whether the PTE happens
> >   to be mapped (but with wrong permissions).  This needs to be here
> >   because the next patch would introduce even more inconsistencies.
> >
> > - patch 5 moves the check for writable PTEs from follow_pfnmap_start()'=
s
> >   callers to the function itself
> >
> > - finally, patch 6 is a KVM addendum that will have to wait until
> >   the next merge window; it removes yet another inconsistency in
> >   KVM's handling of !VM_WRITE but is technically userspace-visible,
> >   and therefore it shouldn't be included in stable kernel releases
> >   unlike the rest.
>
> What happened to this series?  It seemed liked something semi-urgent, but=
 AFAICT
> it got silently dropped?

It ballooned a bit and getting acks from everyone involved is hard...
Either I or Sergio will get back to it.

Paolo


