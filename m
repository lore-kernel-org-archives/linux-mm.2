Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1105ECAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 23:02:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 475F28E0006; Fri,  3 Oct 2025 19:02:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 425CB8E0002; Fri,  3 Oct 2025 19:02:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3152D8E0006; Fri,  3 Oct 2025 19:02:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1ACD28E0002
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 19:02:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AE2C61A09A5
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 23:02:54 +0000 (UTC)
X-FDA: 83958329868.11.D0324B7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6B0F2C0010
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 23:02:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I0bMrZZ7;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759532572; a=rsa-sha256;
	cv=none;
	b=XMHaLEIsJCM677jKyjgBgfY4PMlQv16bQAfxHm/cmd5UFTB8fVCM8Eek2C/X858VP35a+8
	seW3386Mi7sUbZ1ULEo8N6sZFSgXMmiFbIdQw4zzCZ6m4ISBs9rXV6AAHKB3x/JXt5VLKv
	AGR+jbxnWTTnp+8QcqvyJHuwffzEpwc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I0bMrZZ7;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759532572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WId7cfAWLgQXALFKcgjDx0q+DrxMe6HEDRIRNEdOIrc=;
	b=FrFtKNPV2W9iParUnI3LXoh+DEmaXOny6kz4/WSwbTARWJ47cHVAEZHEmovHVTzwU4F4wE
	TSnso5XpZI2hTjngnSWh7Zznzj+JKw2b9yF+te16gt1e8VKpKnKUBbx7KdmYv2wxZN/gK7
	blnfcRA7Q6jz5qqlSj1yQv+2fnrTV1o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759532571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WId7cfAWLgQXALFKcgjDx0q+DrxMe6HEDRIRNEdOIrc=;
	b=I0bMrZZ7w9HBkVCdW2wh4A1EXWYhHEkIt8xdjQYlou2FOL8D1vUaS/Yab+uXiSvZqxewg7
	au3PsDWYeD3IqcafV1Zb6yGs2s6ltobGdFJQhnKZZOiZ0fBp+oIj7h1ZZRDVSNkYqv6EDX
	Qz1gNY/KaqAc90eMOXhNE98aqcZ7xYo=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-tiru3zTENVmWAahsSBNPxQ-1; Fri, 03 Oct 2025 19:02:50 -0400
X-MC-Unique: tiru3zTENVmWAahsSBNPxQ-1
X-Mimecast-MFC-AGG-ID: tiru3zTENVmWAahsSBNPxQ_1759532570
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-78e50889f83so73716716d6.1
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 16:02:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759532570; x=1760137370;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WId7cfAWLgQXALFKcgjDx0q+DrxMe6HEDRIRNEdOIrc=;
        b=oF9r9Ub3abtYmAYCk8WGxzzpSMU/WN7d52GLywLfP4AwElP/dLXGoe2aXPlI7o5Fnv
         vDeP3p/5vnPtHasm/b9lz6p83NXsuj69Z1SYAuH5g1lfGn+NohkqFj92Fa8nG14v7h+V
         UbFIT7IR6EKYUDAYBAOUyzkY3+LU/aia6lBOGU1uybR/UsHssBRQ9wIN5SsxxQiQ8EWc
         fi0ltTBeIFA1hyNJHnz+w0Vd6Yg6yegpVY0HfKOfG0fVZcnLNRze4FZx/L8VfnjJrgd5
         +Zr7Yas8Ccg/LBs8DhDjiAJZPo02hhiXtQJcH/cnODHYsRVoCOuSNji/+hHIigSsz9T2
         GqGA==
X-Forwarded-Encrypted: i=1; AJvYcCUx2Z+WCJMJ0ihBWQdcRPUFKvPj7xtGWTd5kcl/00Z1aEjXyEmnE1A63rksSlbF2/2+mxT9QGy73g==@kvack.org
X-Gm-Message-State: AOJu0Yz1NueET6W+sAFLHWtgaPk99Jm5QkAVdJH/ScREylmH6nA54qJx
	f0BLZm6TpxF+wscnkq6+GppjIK+i+bXuBtQh2km+Xoo9wTWKixyl3Mce5PJ6z83TI/ZePtPoZaH
	/j2VsqHEqa0IFesh7ZLuTooyuQt9qAiHq6lmzU2li+HKCMwS1QkqI
X-Gm-Gg: ASbGncum9WvcYFlN4ygkYmg+5RoYOdmTt3r/NLW3lWO4/bqBicExkwYPDqps7EOqj8j
	hK6gJ1BVdBhlIU3I6GRaHSxY1N/uS5ZjiFsFtC3Dk3kXphyMXhiorfxKMe7TnAb+rwthAMY//jc
	80yiBgPxOuX7uJDPSlJFqreoujCOvbFSCw0hbhIQ5h8lHeAe6OHJ6mK/LQ4cuwqdt9gF8D40YKa
	jyysqvCD+qbn4akx22rinpm56h0C+lXAH5iIOdmQSqATzS77FSWeLdhSCHQJHd44NO9nvDqyZwK
	7N5h1w7VdUo//r4KjWtFcRhcTkTiRJFGo2BadA==
X-Received: by 2002:a05:6214:e66:b0:76f:6972:bb89 with SMTP id 6a1803df08f44-879dc793f40mr58144356d6.9.1759532569943;
        Fri, 03 Oct 2025 16:02:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGdjxQK/SIQmBxqiFpbr5my9xqFpA/9o9Svq5Aijjn6t3T3PtAGl9re1nRM2ZFbJRBoI1QpTg==
X-Received: by 2002:a05:6214:e66:b0:76f:6972:bb89 with SMTP id 6a1803df08f44-879dc793f40mr58143696d6.9.1759532569404;
        Fri, 03 Oct 2025 16:02:49 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-878bdf533b8sm53043906d6.50.2025.10.03.16.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Oct 2025 16:02:48 -0700 (PDT)
Date: Fri, 3 Oct 2025 19:02:47 -0400
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
Message-ID: <aOBWF8uLmm9iQ2XG@x1.local>
References: <20250918055135.2881413-1-lokeshgidra@google.com>
 <20250918055135.2881413-2-lokeshgidra@google.com>
 <2c9df5ee-6109-4fa5-b895-ad8e47d34bee@redhat.com>
 <CA+EESO4h-_U=Xo3x0G_74t_qJQ54AZ4Qd2Ji437aMV8nDZ+tkw@mail.gmail.com>
 <5549ac3a-20cf-4959-ac53-0a89ed0eadd2@redhat.com>
 <CA+EESO5e0gupVfM9NgWqx34oMRk1jGzsNfM=X3idPKaXkRL2fg@mail.gmail.com>
 <7305f905-0f81-4268-a3b3-933ac00cdb6a@redhat.com>
 <CA+EESO5QruRtz8X=2aO8=6P_=uUQuun3f8Uom9gR9-zL-F7dWg@mail.gmail.com>
 <4909d194-58b7-4e94-b730-f916100238d3@redhat.com>
MIME-Version: 1.0
In-Reply-To: <4909d194-58b7-4e94-b730-f916100238d3@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jc4RaErfu3QdExScDVT1mtUnIxL3_qyiEpfrjzxn5fM_1759532570
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6B0F2C0010
X-Stat-Signature: b3j3uuwj4kdga6n7b7epjoqy1g6e8sw9
X-Rspam-User: 
X-HE-Tag: 1759532572-633384
X-HE-Meta: U2FsdGVkX1/R+IpCIs1cQDBwsECxi77necZRpAfvII7ndc/YN8wEKMjzoKigpKCX4R0UuNjjupq+39PBm6uFsQAqW1zUqOqoKlns6wvXJ4BZHiexJP/bfbPiq7BIrTd67dmsdlsHrfEzisXIMJBs80/EM3zBkbd9m3ipRrw/MMeCBFGjzw1zM/4MRQmIlMXsmhmi/SlyE7aPnpNRr+s7K/Q1KEASKd8q161ck6mXMtAcRB63c8OBpLz9M/k8R5RSfepKnLAsRbBrJ2ufwW5VIExHJH70V5wFzPA11HHnvVZe4OIx84rLXPiWinPz834Duhd+Ux9K0jBG62VHpckyIm+iXlXC9qpwygmbSDRueR5zHHhnNJ7c+vFT0K14ZG9N1RyCFK6/eQNgCXKvsteWAwazs4sRsKu3ANlNAOyRROEWzIz0hW45Ig7Tm7eDoHPQrhfy5Ook8teTqaMXEWkGrL1RrXH3s9UvbRbFFZHWNeIERaGABSEhw0lfeNntmdA6RmPg6R43j/YseRbESQsAzDwZiwwSWFTcduie7rEmoLg0lhOsYDOSts/abgI88h6jKPWAzFZjlKZTJI3L+DTFKz3smSOQdmvlUpA0K7aWJ82FLXG8/zmH2xXR+eL97Gr9j+9t91CZt565RxPV5uQG4I1rSbEbt+2Hqsy15Pq0zYhtp8Qi2JFeBR+yGNLzf0Wf5QCN5FvVe6E5Qwkq7w9jn+EFsyvL2Zl31YPbCvR9yOsLYk/2z1YnDmBRSfEBy0Q9fKU6xmorVAD8yjRLczJQbueNPozd3pkSN0P93KTNms5y/YwuTObgiExS+W1x5k0b4VgikugsF8mIXmORvouzBk5uxnaJeIvH1pbqLnoHo4jZ2MKMnL3KLco3pTF4A3m2zki6HKAqZa9JdnkMD2OH4kcOK+ixwsFVryMA1m+vJy7A0b6EzwFEeOPuEmwDCDDVrImw4l9OuilknWUMVZx
 XLIFqoyj
 /iC84rTIv6m+aEJ7QDzBFNUJSqxcAS1MBgqDABbReZC//xxlRyUqjT1Xy7JEuAOSvQkNOAPmBsXXYVgr6lVMEP5Vj4kfNUqJ7w0P9U9XS+ibQb5veapaB/67COI82nu5Ugpd2sYcDDk9XZhXCxYBsZ0pCsbo5Z8xYTBlRVu4qHkx2OZ67dFkYoMsM5yg5rDIg8Anh38a5h5NH2SFHXOrsOQm39nQPBZBx9UMhiaamsz+AYlqYvBB3nJUiPP9uta/sKEEkaKhtErjZ7pDW5oE+dfKYcWEELbk6bBYhTLZVDEogKyB5vdPcpTI8VZ5L9PZ3CSCHHmA9fWdUzL+CXULHKECH1yhLPsWO4Jsjba05h77Mp0DgkWid/MUNI65Y8YObSninAzV8ECHOTD11HxQWQhGSCkvZo2paVDUUxkCkk5LGjBXnPS7nmfHJb9OErmkgA3sTurEbtkGNivlbcp7N8YNQTLB8iJxoV6Ii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 02, 2025 at 09:22:45AM +0200, David Hildenbrand wrote:
> Staring at mf_generic_kill_procs() once again, we have this
> 
> switch (pgmap->type) {
> case MEMORY_DEVICE_PRIVATE:
> case MEMORY_DEVICE_COHERENT:
> 	rc = -ENXIO;
> 	goto unlock;
> ...
> }
> 
> IIRC, all anon device folios are MEMORY_DEVICE_PRIVATE, so we should
> actually not succeed in this function and just abort.

The doc says:

 * MEMORY_DEVICE_PRIVATE:
 * Device memory that is not directly addressable by the CPU: CPU can neither
 * read nor write private memory. In this case, we do still have struct pages
 * backing the device memory. Doing so simplifies the implementation, but it is
 * important to remember that there are certain points at which the struct page
 * must be treated as an opaque object, rather than a "normal" struct page.

It does not intepret to anon private memories, but something that the cpu
cannot access..

The only way to inteprete this from reading dax_lock_folio() is
folio->mapping should normally points to a real address_space of dax but
never an anon_vma, otherwise dax_mapping() looks inproper indeed.

So I also agree with the conclusion so far, looks like it should be good to
ignore the dax path for this problem.

Thanks,

-- 
Peter Xu


