Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A5EBC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 01:37:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BBBF6B0005; Thu,  9 Jul 2026 21:37:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16C646B0088; Thu,  9 Jul 2026 21:37:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05CF26B008A; Thu,  9 Jul 2026 21:37:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D39D16B0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 21:37:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2E1B8A02C3
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:37:29 +0000 (UTC)
X-FDA: 84971154618.03.F770B7D
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	by imf01.hostedemail.com (Postfix) with ESMTP id 54DD140009
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:37:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=m44hk35h;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.161.45 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783647447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VaPhGtocKLbFXsyQXoR9g3DKOWhugqrS27IBZSVVhcw=;
	b=Qui1JBYgXKU/VQG+FiCMmlADy0ar7dz25e/HBZ9CNklXuM4pKNI8f7+gGmHtnGtxvK3Hfe
	M1VAiBuIa5TDYT3lIclILbqHg//J0BN3ScJy1N55oCkVybeIcNXB3rakJfEmU4864KG5MU
	WviFoMrBv/uuDc5unO0UxQRHcwSJ4Bs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=m44hk35h;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.161.45 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783647447;
	b=Ffbdy/s16d5exsi1qjrSqt2nEdDFw08v+N4lz45QpOVYrLBGFlwqNeqZxwCM1IHfHTwNNT
	lESR6w4xEXOtjZMf78QBHpZ8y54lwe3piqBCZl53w2wmt1EMIGQVJ1U7Int6JHbxRvx6H8
	Ebebv0emdvu0KdaHA+znHByN+aR32nI=
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-6a0e55e82d0so342390eaf.1
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 18:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783647446; x=1784252246; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VaPhGtocKLbFXsyQXoR9g3DKOWhugqrS27IBZSVVhcw=;
        b=m44hk35hZqkiaZf90zkz/a6oFFtSJGKegGo+lIJo2dr2Ap1xR3a7SDwm3unaTUzmoz
         UM7YsbhSTMrjwiSwHBAjmO0bX0it5V2hhiL2hwzsxQVimXpRbvalUZKfwFYaOBAgeeOB
         zU155WX2qFtXfVphTLejE8oNjDRBrV17X4m3t0mIEV+cK4I6Qcx80lSsB7FcuLjxFAp/
         dI9gzaFK7U5r1nroFDb+lB4VZK6KOznghY5VFLqFiSzsZVhxztnduO3yklXVAzr8SvYE
         +G8lEMEs6/r05Tyj6tFZWSu5ozw0Lw/7gBvMv0FXcuxxBudqtQQeUABXAFUAeiNsu6rh
         rc5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783647446; x=1784252246;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VaPhGtocKLbFXsyQXoR9g3DKOWhugqrS27IBZSVVhcw=;
        b=aJlWfOv5XtzSEkKT15znDxr7VtnZcusm2UAn/hVUH+j6LsMgMCt4DeAzkumLAVVjOj
         RSOjR+zfF4CO+bu/nWRrGArtd/5OOd7Rv4n2eLRfo7BI0e7j7qwPx3J7fVUkkP4S/Xvs
         +BXyLjeMpKnyQGlUTh9Np9C4RSgPQct88iWqdiamjMZ95/Rqlh2WLhIK5PntwXubPa48
         1oJyr4QDeeAyhUT3IEWoAo8WzuRpWPtYf2EkyBo4vmZmIa6zMiHJsoOTjmJy3WlsstcU
         Hd7VnOV9dFeU4MRArvHZaz35+CRFSU2o0H1SKsa46Gb/abIIzeaz8B2wnvCE3T2pwb0H
         FIoA==
X-Gm-Message-State: AOJu0YzhyP7pH6W9Kt33s2B3zorTnwS50fAAJv3770mjG7KuRLiWzfCD
	owYh4clWGWWYAH9MQsZ0sUV1tPbl2vdgh81oe0b7lL2kUsLI1jEXx69pmr1XIDOVBHs2fO43yrI
	Ioo8h
X-Gm-Gg: AfdE7cmMI1nZ8SADFSWJNdYFC/XB4D6RSIM0oJ9D3WH6KrF4zpFs3Z8qaMIFk3iVX2k
	GIbnf6dbsfk78wcKcNNi6VI0IX7e6KW5vpTWMz6VhnVgYyrcyaAwwcQeYqcI4tnxV6hKcnQp+J4
	Ur57fuaqUddAz9BdESTEOct8eaLV5hizSx6m4bU65L67kP4wlK/tMD7D5NORjkFW0S4uLE6JNue
	CeKaKhA/SOiMplUYkxm68up95w/VQFlxnr+ucIXsT1cukuPxRPyb15i2vweWjDkJDsPIehx2/1G
	304Ub5xOQQrvZ2DeC2LqdeQ+xLrl21oqIpfOBO9BbeJPr+eDTZrnDu7NU5AoFmbbBSEKikQss3P
	lIgv/RUWI18fsj9kr29kShT/hzfT/dDSAnfwYs06P5s01KU71svS3l0Sw8wb23/ZqgzpyJlG/rr
	tM5ptJjJI+RfV5lMCQ+FTbl/HYThJXLpXodccQood5cqqLpJNgAlnT2F48W6svUt93/y6u
X-Received: by 2002:ad4:5c8a:0:b0:8cc:2a92:48e4 with SMTP id 6a1803df08f44-8fec217b8bfmr110693186d6.32.1783647019857;
        Thu, 09 Jul 2026 18:30:19 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd7c1e8aesm29789146d6.28.2026.07.09.18.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 18:30:19 -0700 (PDT)
Date: Thu, 9 Jul 2026 21:30:14 -0400
From: Gregory Price <gourry@gourry.net>
To: "Dan Williams (nvidia)" <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com,
	alison.schofield@intel.com, akpm@linux-foundation.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
Subject: Re: [PATCH v6 07/10] dax: plumb hotplug online_type through dax
Message-ID: <alBLJoM86ujz5Fg1@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-8-gourry@gourry.net>
 <6a5016bf71df4_3b7ee5100b3@djbw-dev.notmuch>
 <alAb7Q_Ku5dVRKZ7@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alAb7Q_Ku5dVRKZ7@gourry-fedora-PF4VCD3F>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 54DD140009
X-Stat-Signature: irccwebtcsetr7pque1c17kyr5yrg83y
X-HE-Tag: 1783647447-958927
X-HE-Meta: U2FsdGVkX18+l0rQBEjOk1h1nLPfqHHUSI7JyQY78TLAygk8ITWgZrUwYLGAUi75y/8vkk6yVx71L3CwPz0uqKaEggUQIXUHKm6Rkccx1/gHXj5dVvZ+q3b/a6EqZEyJwKgGfSSgDt7hii/GOi39agC8IrqipFh01Mn8E7Ufoa8JU3zen4RbHr8pmezTXLWLA8t/3N9MzNn5+JSFeuLlq/reN3mdjV96NFtmwGM15xQf7F4gqbNevMaeaokCcduu523rLpEXbmOMLvy7xIUHQ90hUz6KJVuO0fJwl5WGIR+l73eRTA7IgO1+lOvadArcoWmhK071MSzx5V9w5jXl7Su5tfLf/CxYGTjpP5hm61fEaYkMbFTDUjVViv0j8cc2cYC5v/TwUFkLbCsSyj/hQfHVvUgnD1Yf69w5Ur/oys4bMICS1LZH80x288XS53haDIFghGqLb1xXkCFrNBe/qr6XJwMqD1xV9bAuVNmza6gklqZ3ogDA0TGlUhUOYffRSQfl1v0ndpYGkuVoBKIXAYPCLUgdxfgPwjIIqIoPlXcZGegYCMMoyN3X1a5zdmzaX2j3DCl+Cm1B12essAp5pzH8BOFy1ROzUXSVpXCOlMMmUcYciSt2RuosgBjnGfpIaQihnacRRlFCbexEFF8zpdNrekIUogE9G2zz6SE5bKDArZFzRM7oyfIwo6UNAqLm7EyB5dXUCKJ069agmPrkoKhQmx9U5wbAxbqyM7rj9Tf5TBSSBa34ScjMf48O9NorpkP/KmXFVvUulngarz76Sbk9X+lRHLqWwDmpYgfb1kw4EEXlIh+MJst4f583tiM0CFQaD4CFByNzu9KypwWH5lR07VSI77PewH72+CL/bFYvl5DTZeJya2fg6DYy0GW1hSUkX1tHfNcaolFHfBXAwZo0/AXqTR2IaraTnKJeroPr2/zXNJbp3CUzROTUb5wkW9LtC39VFNLZ+g9pfaR
 OggJ+O68
 cGr2QOsKj9olBXq4I7pF6akWUs6udd7rsxb8R0P9HzjhiC0B4secKxtZqFg3i2aVlEvPGebdsZ5QLnkfT2j0Q7tuZhHNDnsDlv//fRgduJgWRPGcpkFAVNA+gklLQQeB/O2VoZlfuw7F0J5LsHLSy7tRVv1h/fpfOrwAUiSux6Ea4xqmZ4KDAQqx1h1dEsSjT3NhhpZiQ8sCIFzb8xn/6txM5GlTBn7xIBEbu7n64vdwm87zXpJuYIDRIVBkrdfN9H6HBCwjANfFGqZpvDX+Zr+hiFQeGTGGTrGwQVuiVzWhp75DXW5o5iPRyufHgGyj6nR4bxD1UYQ4icxHap3e2sNV8pk4nhPqKI5v9h9jQ/ozkL1qjxb5r2o3aLZoI5OUv0K3iD0QMl/2bMaqzJkPbO2+xxH0vCLGTTfMyYgKhRWCc1nAvD/z01ez1uEvnNnKZt44e9zHyOHyhZjU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 06:08:45PM -0400, Gregory Price wrote:
> On Thu, Jul 09, 2026 at 02:46:39PM -0700, Dan Williams (nvidia) wrote:
> 
> This was more a matter of having the DEFAULT set consistently across
> the dax driver variant probe() functions to make the behavior explicit.
> I didn't want an un-set value bug to creep in here somehow.
> 
> Happy to drop them if you think that's unneeded.
> 

Ah

Not setting the value in each of those places is equivalent to setting
MMOP_OFFLINE (0), so better to just set DEFAULT regardless.

So unless you have strong feelings i will keep them as-is.

~Gregory

