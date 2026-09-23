Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9880DC9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:22:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6635F6B0095; Wed, 23 Sep 2026 17:22:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 614E56B0096; Wed, 23 Sep 2026 17:22:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52A706B009B; Wed, 23 Sep 2026 17:22:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 23EC76B0095
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:22:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AFFD9140136
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:22:41 +0000 (UTC)
X-FDA: 85246301322.05.7C36AC7
Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	by imf27.hostedemail.com (Postfix) with ESMTP id C6B4A40005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:22:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=mYToTtxQ;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.235 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790198559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6JszVb+RTu6ALEMMDucuPIFOfd98yGFKjSHhbkgHgjU=;
	b=5EVjnCaGbl8YrEi/drmzRDUlkc+GDhV10oQaLm9m4SpRqjN3kRzHsiLvNKFFEOLLgh1INK
	HK6uaDC/qKxX1wSh8qO67Uzng+c5C5LyGtdcWmThJkZ1dBMYo0qU1eH8MrOvFUBxVMBBK9
	5ZB4q24Tu4eyZpWQ37Tr+gVpOkMTDXE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=mYToTtxQ;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.235 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790198559;
	b=yxk4nZJZvzbSDv7oAZ82mgHyT5DmcHEzyu3XTqYphWKOrORNQwzZ3DlcJIHUMICz2L0WJh
	OoWNrvuQ1PUVZtmGlNYaZgP+7KtXLSPmwYA9ZU0lUFTR3q2ybVbKJr//u2MEgcLcCfbPpD
	AH2BVW7wxVah9rfzZnTVEDCDXMhj9Mo=
Received: by mail-qk2-f43.google.com with SMTP id af79cd13be357-93a2dea320fso125441985a.2
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790198559; x=1790803359; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6JszVb+RTu6ALEMMDucuPIFOfd98yGFKjSHhbkgHgjU=;
        b=mYToTtxQWyPchV4Tv4fB44mReCl7+0wK/CzKpk2YY5bMjsfdhOOk7y+YPyorMr7SZ8
         C30dR6U1EMvTZW6VeIDAS+900RbiIkt3REvRCF/tN2x6wuEem1u1NXKFHcwhGUfLH2RH
         ajmykGSoHYh0L8g1WdbvCrNletAZkDG/8jajsmWKz4kIM8ce6/owXRQY7XPjyP+xqhkb
         6N6e56MNYtW/QtOAt8UFy4Eu4wiuxiVzjtQMXSZVun4eD1PBJW1ftJTElHrNscODCUNP
         2oHiF3NNq+mNw6ykEVvb1RBNu1aP761j6DDkmWX2kWJbUT6SOuI8kbkyIpL9GC29stg7
         PF+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790198559; x=1790803359;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6JszVb+RTu6ALEMMDucuPIFOfd98yGFKjSHhbkgHgjU=;
        b=uTdecPXlkeRxn2Gi37Njbd1YbCVllYnRBHd7lY8BsST/oTqpGtqWkOts6R5QcJpLHV
         Wut4BMgW4e5/h7veKjuOuYHv8QY7N+pMCkDN/NGuMgY7EzP7gqONG5kmlekE0lu3hq+Y
         NEI/Re4lBlJN/v3E4GnxCKRWbDZzP4tDKPd3AbLsXWFqUyQ93IpBnosgHLnmhOjPv8N5
         J0qrXAvBg1ZU5+a1Dk0zNH4ni+G7lCr8xeeWjWblBnSdeZBCczvW/C0Jk2AtJvL3+H1r
         kwLUmlDg5yBH8hcGCWREjer7u4F+kDCMxW000y2CAq5HhunTZIubWIdL7ZxZ4Q4Fe7Me
         bjAQ==
X-Forwarded-Encrypted: i=1; AKwUvByodcJ31tvN2o9rUazGuYeZAMQVt9INdxqklAaYLLVi6kdsRaJey4dStg4LfHudyy6vRP+7p9dx0Q==@kvack.org
X-Gm-Message-State: AFuF++nVdCYR2rfzjF4QSFItfdOEv+gmGmLsjRaycp17iu8A9S1PXQqp
	ChiIsCTaoU81f+Na6j2QO9HyZtqu2wta7cT5nTGyfvOtgBMeSd5cUUWnZDYY88I//7o=
X-Gm-Gg: AYBFou0F+emNrJCKSMDT+jLKkuMoFnb/gvGBlTj/L1F3DQr3HZKj0EP55PQgAbgx1ZJ
	R4j0UN8Fs89b6oiGqYdNK+9rh75OF9oY8g8CFJZF1O2LFZkqugw18+FchIJHv0eAVZT44mgvP+9
	/73Ohsx9sEf0991/hH+/VcJxT9TAc7JCDLDngT/cNWRHh19wofYRTCogOw3fAxYBsm9Pi9rDzoe
	PigKM4INYMt+teelo7/ynDpxph5TJW1qjjK2/RAdRZscJtMx6NJavskm4tVFU/AMm60G/6OtWbx
	6WQAgMNlG/p1ROS6uJGUdpDLryJ3nG5orjFyaO7SOVxxA6HMS45n0ajTg79o4jSb6oYmcN13d4T
	ySVM1OWVFSYYhn6rFABmR6sbdW+npaCQ0WvBIoSY+vWa6015N0YBpl6VYzuC6P6m/JZCH3adPRj
	GYcOWuV8Sn1QUmcHocdbmcL5SqwyOOtu9MFUAxMjn3pvHh9iMN9fJIK728TnGFHjcAwrIKariVx
	RCTqAx9BJQ6Tei0wQGEGqrwGY9RuMteK6Cuja1QHWAzJGM3RsMk1rjUyS8gth+tIA==
X-Received: by 2002:a05:620a:225b:10b0:93c:b10:7243 with SMTP id af79cd13be357-93c346c2cabmr50513785a.5.1790198558842;
        Wed, 23 Sep 2026 14:22:38 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c248cf620sm315660985a.43.2026.09.23.14.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 14:22:38 -0700 (PDT)
Date: Wed, 23 Sep 2026 17:22:36 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/vma: predicate setting mmap_prepare VMA fields on new
 vma alloc
Message-ID: <arRC6lU7yJCrosDp@gourry-fedora-PF4VCD3F>
References: <20260923-fix-mmap-prepare-overwrite-v1-1-3b3f1bfcdf5e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923-fix-mmap-prepare-overwrite-v1-1-3b3f1bfcdf5e@kernel.org>
X-Stat-Signature: 3jdt19j1ec1ufjibp73uyf9syfnoraz3
X-Rspamd-Queue-Id: C6B4A40005
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790198559-562144
X-HE-Meta: U2FsdGVkX186vD26v21Ce+9SnbvcJBBByRwT22h2mg8X/VCwaZGmfKIsW0IEuwTDhDr6U233pjXT4X3zDGDVLu+GwjLDvm9AjtCyo7UTrAKAOR4Rlnqj6/EjGwaigL6SoEc20MlbUfyfGbVobABtT+l4hOBXQmdE2EjVrfzSM9YJF2Beu59p8PaNCtNzpn3z7NHTsJnwlU9/y1v+TTccgXrImAQ+GBdIC5gtlJnr51yqoB3lGBlY+vze0JJsCqEemquZjDdafXmHRdBnaFDQ0C0V+FAL4f2si42yfXHjl2/q6Iz8hBsYJAvpfyRtE8jCf9KGJXDnURyuKkveBXiRQVEDy0LecliybV6IVhcXpBaHhXXSqc/rTmdXpxazGc8+lUiosLlziU6w4MiQePaQzCriJeVs+4uyyOQGrEs0A95xmJqfazICDcU0Gbc5mucwnxCKGmnOgQC87HGYCAhBcFiCEzGjPJ/si6Xq0N7Ypf0M8K5SigJnCVADkI24vBa3qSVFE7YKRdC/xI/JVqGbHCzwJ5T5BTvxOKDNuc4ZGhZNnGNp7nn8n9yakVdUBr30GgdTqeigPgqLaNa/j2N5GnL+luI4Z0dYEkY2oNy1X7TQiEQglYwHQoHsMz7Pqb/OZTxMoQq3DA0OZrdBqdNs0LPXHY8R2t0+EReyuhlA7aZXkjRdGKhF1mDoLEjKa36n9MaODNGfmmW7UJIpwCnU3I7ADIGaOgqRi1aKWed6HotqJv+xhIVBTGA4fTQGSHjBBu2GBE+nfP4DPA2PYstvSQFc2by6dEnmfP1WGyh1o2fPlfPMZ7iflbNwo8XzSK6/0pHbeLpQxbzOvUhFCl+EhAaFpimk8vQDkZmPFpncWzghHidijvYfM8kFNzPg3X1dYZESq4KWLq42AgTwZyXWJvz5CBsdeKtpS8wwAF2pbtEL37+U17Vnr8Iuxhzv7Ye+ff6XVDC726lkgGmeWbY
 /1T92niy
 U0keieR2pEkFIv+ULWhxje42qETxlUv5Dkg+mTpF/4s3dT/wn3DLi/b2GkCdwDUptzPgcDVEPh96nU8Ba7etm1uVzwDPYvYi1WWBBGbggyWsormbsPkLSaT8zMj3AuIRho90iosjHM88GLwf5xSZl+7lIs0y8pdxxCm11KED/UsXIAY1MEhIxf9c71WhJfDH5TKWx8m2Q2DREa33i85MJSQpaqsfLHZGKueHSCY85PAnN83ibo+PSD9rT8Sf7TNF7n6NN7zEil7ymdeqy7iNeR38c/+oyS5ynDnTxxVo4IXFP3OOu3mwkz2BPs+kUC7NyVXARDE2UMqfp1fMotmCa3cEBiZw7+SK2sBQzFbRNV+RNE1Qq6nJWZmWfhjuIC2Lp/luk5Docl1+BwHL6fin9m8BFXXM2Jfbjb+7zMOMVF0u4jkaEGp/tcreU7nBUFqxsMzMUGVy3ynYV/pk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 06:45:41PM +0100, Lorenzo Stoakes (ARM) wrote:
> It only makes sense to manipulate VMA fields if a new VMA was allocated,
> rather than merged.
> 
> VMA merging does not compare vm_ops or vm_private_data, so a merged VMA
> keeps its own, which is also what the legacy f_op->mmap path does since it
> never touches an existing VMA.
> 
> Currently, these fields will get overwritten by whatever state is
> established in the mmap_prepare hook, and if the VMA was merged,
> vm_ops->mapped will not have been called, so this could destructively clear
> existing state without replacing it with anything valid.
> 
> There is an implicit requirement that vm_private_data and vm_ops are
> fungible across VMAs which means that losing the 'new' state is
> fine.
> 
> However in this case the 'old' state is being overwritten by potentially
> invalid 'new' state, so this must be rectified.
> 
> Additionally constify have_mmap_prepare while here.
> 
> All existing in-tree users either derive state for the tree or are
> unmergeable due to VMA flags, so this has no direct impact.
> 
> Fixes: c84bf6dd2b83 ("mm: introduce new .mmap_prepare() file callback")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>


