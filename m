Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE431606A329
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 20:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=A2zzr5Mi
Received: by kanga.kvack.org (Postfix)
	id AD2A36B05B1; Mon, 16 Nov 2026 15:33:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A83586B05B2; Mon, 16 Nov 2026 15:33:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 972F06B05B3; Mon, 16 Nov 2026 15:33:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6AE7D6B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:33:42 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 01490A7834
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:33:41 +0000 (UTC)
X-FDA: 85442133084.21.5D1203B
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0FCA3C0009
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:33:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=A2zzr5Mi;
	spf=pass (imf10.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.171 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794861220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FRUBObM4vFL1TGf3o6s1ZDBsKZdTJ/3jimI0MzXw8Fk=;
	b=dAfefdQQFKT11Iboco3eXrVQIrCZk7IR56AUBlNYRVCwPm9mw4D+VZ0ghodIW4jOc6e/x8
	cjDcT5w69Y3uNixonwcgm55DQDEWsPHMFKkHTxi4Xfl/Kxmm4ii1Wf1iuH2CNK75R6IrDm
	cUJc0hqCJCHoJNGXZ9Y9h90ViWG0q7M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794861220;
	b=vR0icAeRIv7Kqzx2CaI3UdG1a0toyLMkG833dGmxZeiU0Ye6hkkzt4shS2bNwnWRCW24DB
	FxWv3DFxwa4KsNSJDGSogaTGYEwENu6tWy4EtINU4WVMFQqpbhEU8g6E0IYQZF9dN+NAFb
	fKs9sgrvEOuxQj0TnY1fwFORZQnpuKg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=A2zzr5Mi;
	spf=pass (imf10.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.171 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-945e6d9ceeaso409930685a.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1794861219; x=1795466019; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FRUBObM4vFL1TGf3o6s1ZDBsKZdTJ/3jimI0MzXw8Fk=;
        b=A2zzr5Miy/pivZAJChYCO2wYYOsUIdiglKD8QHIMy0jwwhnBXoqaHAMF/MAacIz8I0
         sP68QOgz/1tD3NcEgvubLANJtYYMvoRs1Roky9GVzKkAExjlq+IpZkpGTcR27oU++JtY
         K/S8I9SV5UfSuHu0q9aNHH07LeMNhduQa2jmmBcC4mJqwQdXcFXxeysASkQtVShhOtEk
         5GtxtfAe/nBXvYxip+GmcDIbo8pxPFhW1cFaEQndKKPwz7AW0SrKobaoxUUQGEBarFEt
         PV3F0LC/mXMkK8XkgYAQrxmULcMeRzzMXYP7V6/T2GKqmt6GGUE+0RXzL0zaX28IhuuS
         EndQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794861219; x=1795466019;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FRUBObM4vFL1TGf3o6s1ZDBsKZdTJ/3jimI0MzXw8Fk=;
        b=TBA+qcIV+Pak9c4a4hU8pz5LTZ67hg/68UC1tkaj199S702VPxPuR+ygnO3bDTcNJB
         NU2dViWL9eQOSIz4FYTHfhPSL7QjRg7OhGBCCt3CREDTPFzYvj3LleNiISUx2b8NsI98
         a3Vcnxt3GLrNT0dZuczo/xSkAETaeYLLkdeGze7t+wCcfQd4xCgXuS138HmphgeO8GSB
         Z3cPrRcw6agdp+Q84qS0sR3hpKeIHTKPBh3duRWyCcn5nLDWHhfpKSWReYD1lWDvNt/a
         +cJn0iJcEod7OtBLz6ndiM7u2ETkKZ4dYgLPWP9KT7iSTMa8BQF/q8UGWv42+6D8Z5sv
         J5rQ==
X-Forwarded-Encrypted: i=1; AL+hErG/ujfpzQTYfXO9a21gg7nUX1HenfFGNhUJvsIAyUhMq6FRhmJSbAdPvLmj04fAI9d0L+HSchYzhA==@kvack.org
X-Gm-Message-State: APuU4Z81dlgglpr9asdkloL3/d7y+AfEa6oNJxa4vW3wSiISvFUQ5xSn
	O8VBKo5s+17TWwNIynGArqVWSkAOHgkzDpACjMxZV26wfQUCpskuc1ietpO7ayRTSy0=
X-Gm-Gg: AYBFou3Sx11NjddNX8JKZkxaND2FiKu89CalOLYrSGfpNI2miNhWCd8XzNVq6hGbCED
	XaqS7XdYlWAN0i3qjBf99wcAsvJ1ZAluCWBWbcL5/BMqev9oTu2sw1CRY+pBeKcRjv8riAJ9IDL
	z0ObaOHn/kkJhTGQyOvlBwAzUwHajmdhLlcIkk/5K+J2FnRWHbggWzFJxbI/QoD5B881JLKSSAG
	Yb2eSDPpA2eUTTUc2FzE+IsCZ8w94aALTMabonKWTtgZceBW4WNPve5mi2rqdEM5pCnwugqw47j
	6Qyx2FRiFIFCphfN0ysBtds7yjml381MQqshtumwjGp/PvmmOkNHd7HabxR96NejdzkWBjYWD6R
	l8BUj1StFxDVjGpdpbMGwbzs1cnB1Z7CjbnGt4g1IM/OThJqu0ZgpnPnZ76zUdMfX88fN2m9J0C
	uPo1U4Bpyp4kdyXpx3rxK+6sl4bgq4xvj9e/fTVA8Q9rPjdiaKBKYO8HntwfXgfhbnlCYG9/nGv
	xQsDz1N73YiThUKHMGFUm5n/y1mUiiiRwN3KlfaRJks9UceXCzmIj0dYa010q9n33ttu6cDquZg
	mYfiDw==
X-Received: by 2002:a05:620a:46a6:b0:949:733e:ddd8 with SMTP id af79cd13be357-949733ee766mr1034555085a.54.1794861219140;
        Mon, 16 Nov 2026 12:33:39 -0800 (PST)
Received: from ziepe.ca ([142.166.156.71])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c804f9esm930800685a.11.2026.11.16.12.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 12:33:38 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xT3OT-0000000ARJs-2rZa;
	Mon, 16 Nov 2026 16:33:37 -0400
Date: Mon, 16 Nov 2026 16:33:37 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Tao Cui <cui.tao@linux.dev>
Cc: akpm@linux-foundation.org, dgilbert@interlog.com, mkp@kernel.org,
	loberman@redhat.com, jmeneghi@redhat.com, kraxel@redhat.com,
	vivek.kasireddy@intel.com, mst@redhat.com, jasowangio@gmail.com,
	eperezma@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
	rostedt@goodmis.org, vdonnefort@google.com, mhiramat@kernel.org,
	kevin.tian@intel.com, axboe@kernel.dk, linux-mm@kvack.org,
	James.Bottomley@hansenpartnership.com, sumit.semwal@linaro.org,
	christian.koenig@amd.com, phasta@kernel.org, joro@8bytes.org,
	will@kernel.org, linux-scsi@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, linux-trace-kernel@vger.kernel.org,
	iommu@lists.linux.dev, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, bobbyeshleman@meta.com,
	mathieu.desnoyers@efficios.com, robin.murphy@arm.com,
	mason@kernel.org, aesteve@redhat.com, tjmercier@google.com,
	harry@kernel.org, vbabka@suse.cz, cuitao@kylinos.cn
Subject: Re: [PATCH 5/7] iommufd: account the hw_queue page array to memcg
Message-ID: <20261116203337.GA2481588@ziepe.ca>
References: <20261106131829.3228926-1-cui.tao@linux.dev>
 <20261106131829.3228926-6-cui.tao@linux.dev>
 <20261116195213.GF2452510@ziepe.ca>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116195213.GF2452510@ziepe.ca>
X-Stat-Signature: oe3aj7fpqbt4nkm8pgw8jxase3m3xhqp
X-Rspam-User: 
X-Rspamd-Queue-Id: 0FCA3C0009
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794861219-650886
X-HE-Meta: U2FsdGVkX18JjQcDdurfR58DwpbCt2yUvNhOpZEUW5753gaSE0rTLIZOKlt0Pq/13rEQYXcx1Xs1ZBSzfS4Nz58BYVhP97QuXNYoNFX9DxV3RABtuNn7sZDjp8268mLklWceG7hzhgdkkYw5JveA0intmrX6ZAr+wLMLAo+7oTJwEaCIrn1vCVu01bBUSXHOizK4aA/rednAs9WuRHDU0xK3vjhTOG8tucrGNBIYSFZ65k2d6d6MacWYK1fpc+TCqCBq4+zEx9VGaDbRFUQ8/yIoct9X3aeiyy+y73EJs/+Yzw19OcmaSBCeqNZnZB0F0UivkMI2m1dXl26HTwb7lXrm2X/QzBag8dOK9wr1tV6DrUl6h1yY4RQb7+HEfUaFGjQOgNMXKINvXwYRrSGr347ZSGf3ItOuzdAN8VHiRssUd8MBl6hHFgNixeoESJdDjEjY2PlOjUST10Ikl1fYgByKiFQNYSsGv6WiZh+LOJb3oMyjHWzhmcL59NRhY2MiEWTb3g5OvVpy7Ywq53BU5J9xP3lHU3oV/y1bWKnyhrY5R4M615YT08P1yw/UyBk2xOWt0RbdCKbY3U1O35gWFnFRu25ckPHjOvPa88PrpUjuN0Xg5MZMS6LUqiiyYkCWTKRo+pyfXXqtcvZ4dxudXSZMoL82UdNffV17ueXM4trapeDC0WgVVvaejtO0f0OxOnK8anUFCUmEJfP8uzEkwkilZp857OriRiaIhGjLOCDWHd1tuLQIP1/pBxhZekwvBi+oHr/TyUC0d6wN475WnaDCpF9SbBbnceSUeP0TLiOjYd/1SCjYiqbD9sTgyCDuJa5uUXpvob7C++orI+gHwutGVtILj/uKI1FCc2SYO40N2UNowcDhAkd08j6v6apfxTkOERLsyRkoZ1shJhR8WZkpSooe/6ND+HNhwSDXvalZytdnS90K28osq9DNLE1N+3GcoPyJ9dx4H4r3zmr
 l9GkwAdv
 eis/ZMAni/Gbqr210+it3Mz5JmykjuhOdLKBwti2glTCgVtsMsSbu40miV6dtIrVs24ytM1WC+wkl0GAqbpfDP+IQmMoQd70aYkmYPN+ffrMaQUWa0jTBPqsFKsadFul1jZVNzdX2T7Qz5keplXMl5EyG2wMju9+nIAPt9imOOhr91G5cuHVX2rVHQxVZEyZ6mT3ZLUdkxrB3MIOrptlHZTqc3tSDlpmVxvW4crV8XoFv07QEBPt4GLVbdWsmSIuYjQbvo61pLwgm89/w/eTZRngZmwRcVFqgAGv5Jjf0aBqzzrMvX0K8TVIgXOL4J7vmnyEtyn6av95beFK1VMP2W0h8w43v/3aYrRWd+sZCtFzM9/6Suo20T+VLmckPZVMn6gMGJ6QN/pUbLjTVLQWXKSKfg/blX6j9zj2I3+/pgnatWNsaQdAvKt8sLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 03:52:13PM -0400, Jason Gunthorpe wrote:
> On Fri, Nov 06, 2026 at 09:18:27PM +0800, Tao Cui wrote:
> > From: Tao Cui <cuitao@kylinos.cn>
> > 
> > IOMMUFD_CMD_HW_QUEUE_ALLOC pins up to max_npages pages just to check
> > that a user supplied queue region is physically contiguous, and the
> > page array for that check is plain GFP_KERNEL.  The size comes from
> > cmd->length, a u64 that is only overflow checked, and the array is
> > freed again as soon as the contiguity check fails, so the allocation
> > can be repeated concurrently: a 1GB region costs about 2MB of
> > uncharged memory per attempt.
> > 
> > Every other iommufd allocation that scales with user input is already
> > charged, and the pinned pages charge the mapper at map time.  Charge
> > this array like the rest.
> > 
> > Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> > ---
> >  drivers/iommu/iommufd/viommu.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

I'll just apply it, thanks

Jason

