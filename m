Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 532A2ECD6F5
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 00:08:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FBF56B0005; Wed, 11 Feb 2026 19:08:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A9756B0089; Wed, 11 Feb 2026 19:08:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AB9A6B008A; Wed, 11 Feb 2026 19:08:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 570886B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:08:01 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 04392C2046
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 00:08:00 +0000 (UTC)
X-FDA: 84433866762.27.B981027
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	by imf02.hostedemail.com (Postfix) with ESMTP id 38BEB8000D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 00:07:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=deFBPbRC;
	spf=pass (imf02.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770854879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jod8g++UrMJjPGENywCHZK3vSzJ+1L5xwi8NVPgGzhg=;
	b=eGfBoVv/U/NtNav8h7JYJMlfOj4d6F1JWCscpX/AggrTVmiBGoZKxVSUb00DSpu4fAHhN7
	y1tFKwE5oT3lJ3xXmXWZLgXbpVrR9nTQYnPiFRwtim4CNNaUAe5o01/JHnclWqqtaiAkF7
	Xc8UszuVWfdymhpJE4wPxYMHzu89xG8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=deFBPbRC;
	spf=pass (imf02.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770854879; a=rsa-sha256;
	cv=none;
	b=dLPt2AZxHF7DgF7s+TqkgclMx1vSueblILMt0hMW/hAksM7jHCUuxUok7kyREulkfoA/S0
	Owsp07zPM29LWdHCz6aTBzgR79/Por04P/Pluy+/ArDvlYdhakZYzKmzl72yIZkkT0q/sK
	+vp/cS9z7DsEtDIl8P+sEck98gPET0Q=
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2ba68df3687so6499245eec.1
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770854878; x=1771459678; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jod8g++UrMJjPGENywCHZK3vSzJ+1L5xwi8NVPgGzhg=;
        b=deFBPbRCp6rlUOHlv0aomwyh78mivKmUtcH8O06R2VD7+X77MiKfvkqu5cWbz1vPNs
         f5p25w954XQOHKJhxdbPc7/i5TLNM2TlqqOl6DEar01bADXxV2yO5XktpuLUAhS1XMV6
         R8oLTab+Xtx7rvQ9J8Z8vAO9SVFKh4sX5+j+R8s1L+p9PP2mlkiFDB1vLrPEma22MzdM
         bbbC1XBNMmgtfAYTy+OcwCGrHvO4b5wt8qws22qppRhZu1yrale5EOiRyhAjsfhdPNAf
         CzqUWMhCIOGJ2SiO5fNm9wzkAfS38Gq4t4w6L5uESLDDNTMJfBe+L0D10UsdaS47lnTt
         /lHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770854878; x=1771459678;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jod8g++UrMJjPGENywCHZK3vSzJ+1L5xwi8NVPgGzhg=;
        b=Af7jdMf9mDFpZIV+b6dn8dgSv0jucwv/Od5atXoxyXl40LDYCAFQK2DnBa+aQR0vAG
         PD9tuwAk/PC9H3dKzbOjvhKR1s4Ou8qvI4skKNu4h12hD0RjjlemYHix0FehkfpjrmHD
         13oQsTO+eGi4ABrOMHmoZbs2obcnGL2okZsb+5LfFveK1/HShm0NzOAx49a4WtEH8Law
         ZH7wQGoeR/j/+r5J6xi+tN5ygEX7DbGn6FTuB06GHR2+DpZpxr8AXDyM/nIJYiclcvB0
         5TxOWRYM6E1WOc0cY35AJBI+/bFWLN9e44ZK4a5G6C7nY7lgtYpHBQ5XGMe9TAreUO/m
         YKbw==
X-Forwarded-Encrypted: i=1; AJvYcCVjSPOW8ssQr0MVVLsnNDILMpYYCmwYKmsyLuQ2XVkS9FtX0fFe19cwH/JNtje85RiqDv8HrkU7nA==@kvack.org
X-Gm-Message-State: AOJu0Yw6B4FX3X/jFsQaexC1rKbijX+ArdaXuDxRAT1TkzibhIdOZH/3
	3I9/HqL5bxypmfYzRwvXOe7C7Er9JmVbTMiAHpEp4Tc0mN/oqsOVUT1i
X-Gm-Gg: AZuq6aLguGwRScKeSNIUxLD6PqllT3gRZ4tfb12xb3WPNSBuO5BgyU6Yhp5tmsVi4WA
	Cc3qI0p1TW/GOMvx+E/bREDQc8e6iswRmi6AMDI7nMBloBtUyH8rtZZ56+5RaSzVqveewHeMNBD
	/g8fdR6bWoaL3U0jcbUh07+INzd1nwf9BuF3zMAw3rGnLnr3I6zrXHDEbloixnAKJrEXq76OkXp
	G3oTlqv3rN21HHtEW9nl1Mb6AV++iCkV/m8MVQmJOfwdkA+kf5zIJt6l4+B/xp5eLhzWWgKzMe/
	gatZX2W0yYgwptDYHzXU09X+WjGk00uEYSuoyLhwudlMAziCNFyDCQH0KPl02Kh+ReyZznna8Ze
	Iy9Z2bF/lKTCJmj10eG3CccxLW/4Fp/TUAbdyMPILqGqZ3hI7NklTwVOJ3BLQI857RiQGVeUm6U
	1FLEHbxe/kymgfLGinrfVhmXjFb297rOG5oxCWyligVpH6i4Ckbn6l+pWuzAGOGc0MZA==
X-Received: by 2002:a05:7300:7b92:b0:2ba:8ae0:8576 with SMTP id 5a478bee46e88-2baa7f7064cmr548258eec.3.1770854877882;
        Wed, 11 Feb 2026 16:07:57 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ba9dba2fe9sm2347889eec.7.2026.02.11.16.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 16:07:57 -0800 (PST)
Date: Wed, 11 Feb 2026 16:07:54 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v5 1/4] mm: Add address apis for ptdescs
Message-ID: <aY0Z2qA1xiabEafk@fedora>
References: <20260211195233.368497-1-vishal.moola@gmail.com>
 <20260211195233.368497-2-vishal.moola@gmail.com>
 <0ead4a2d-c88c-4c89-b1dd-5954c28edb99@intel.com>
 <aY0ALB5yKXLY-M-X@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aY0ALB5yKXLY-M-X@fedora>
X-Stat-Signature: rsrz3kms1yaapkzznyaa4zbh31y78ehy
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 38BEB8000D
X-HE-Tag: 1770854879-925324
X-HE-Meta: U2FsdGVkX1+/yvAVc2g+su74ECTy7woI4p6o5qrUN72jHIxaddy0t1+l0kp7sX+RoTIP/cqCudPBJ0/YGVdnxe7j2TfLqhRD7w3HnZuO+lKx1J+l8iwwK1dP5fRwQENw6YzwH5aupzGmkei8skvfzbrcv3C2bWaz4vtd0qcGW/t+ZnsFlfVgjDLANAJB/2QiVZYtdwyQktOR/XS6wm2Fa4VWiDKUFs2rRRUHldTRJWTCzox0c9xgHpib5vAeYyRPN0dlK/BxSw7Bhfhy2+4uAVpshze7EAlXt8uxIYAvFL9DO9h3ZPrDARjzRRPf1sorqnzSp6Ef6dFk+YHnr7d9LItD7MMaBKdKoLgC6CMqMNbquy4uuLDveU8X2vPO4+jg8dYlWYqOx4xdJiCWG3ZcnfWF4X4+fxe8DWtOX5q2h5Q2B9p3fTmjIE8KPf2njqm5DCNHs0R/fiDqSv/jVVEyjaXDX4E8Fn9sFAD7jz3mIH4GMv00AQv35L+XeBdTKxAcO806UaOf/1X9rkK82aAhAL5D4LzqWzgPk/QVM4aS5AdkuHwmMm+9LcJYEnva/LYWo0ylgN3M9wL9mACh/+REbd/gnxYey88J8yq52QgNIYz4b/4MRFirPvZvEXs/fdtx8zb/PxxR5lBKeYagZS4TG3AgChI5RgXy424sLu1v+DY5+Z0QcADDpinGePlHYRBUCvL+pHxGGIx/xNvC50hPsstk83MqmgZpRdJxNG6T16oDsJGvQiM9stJifyh0651T0PGNZ5LAEsn5BJ2j1awXK0T5gs0+DB/u7bQchneOCb1ZzNeq2t1eHljmqEDjBRD9QQk/AqRQRFdumCwtYnPCJsitNscWd09bal9kE8RD9kjcrRKKQQj25TOIOOclQ25LCWGzl7Rcodcr+PH4W5uiskLQOwHySQdtW7uymwYEsxyo4zH+sNx820IS7lglgnnvevqRENavHe0JbPMRXjv
 X7SHaG5v
 R61c7NVSKzwsFCYUQuQTqN+1MDhCzfZHe8xi8ZRuxtDRycmDSUZUMzjGJaVOljZmyXvUNr3Cr//GCBIjbCSbXCefYzsreyydK2VwExbKIm3rKp8a6k0REWpxRKU5J1I/NFjEVMYHj/4UsjJIb900JP0vOnWbFdKV0SBpbsN9Y9LaQ+NOzKS3WsPMvxD8CFWCTIcWgMVsg6akRFdVv9aRoX4TvzqlIj+m/RPNjiSE7Gf2wrdsl2vlvoFdQpRNBGk1RaL7DJKnjSl5cFwZdGmeRZVf5WZME+vulWLNRGHurTkx6X2du8TEXoOsOsIG1sHndL29kLQ9buYATyPj3b0nnFSXs4r/ofNsf6B1/GGf800tdT3sY/L93CeDn4JXoq+edX/24X65N+djD0ycSrTACYlCUHp/a2ey0ZvbVm4fm1ld2eik0f6zedfkDvkEsL5lFWQPBVAiFzcE4fc2Pw7LDrEEEIubj4BHohnUimtVaGU4wqzKywW0liivdCbrOWoyIJRgAZpBUJ9Eifk7AFFwFNYmY3xYwa5U47itRlca2lXOnFoI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 02:18:20PM -0800, Vishal Moola (Oracle) wrote:
> On Wed, Feb 11, 2026 at 12:13:10PM -0800, Dave Hansen wrote:
> > On 2/11/26 11:52, Vishal Moola (Oracle) wrote:
> > > +/**
> > > + * pgtable_alloc_addr - Allocate pagetables to get an address
> > > + * @gfp:       GFP flags
> > > + * @order:     desired pagetable order
> > 
> > FWIW, I don't like how pgtable_alloc_addr() looks in practice. It reads
> > like it is: "allocate a page table address", not "allocate a page
> > table". I don't have a better suggestion other than having:
> 
> Hmmm. I meant for it to read "allocate a page table and get its address."
> 
> > 	pgtable_alloc()
> > 
> > that returns a page table pointer, a void*, and:
> 
> Initially, I intended to name it pgtable_alloc() & pgtable_free(). I saw
> arm using pgtable_alloc() and powerpc using pgtable_free(), so I looked
> for another name.

I've done some digging about these names.
The arm cases uses a function pointer, so we should be able to use that
name without issue.

What do you think is a reasonable name for freeing?

pgtable_free() is defined for sparc and powerpc. I could rename them
prefixed with "__" to get the name since they only have 1-2 internal
callers.

> > 	ptdesc_alloc()
> > 
> > which returns a ptdesc*. But I suspect that would get confusing at the
> > point that ptdescs _themselves_ start getting allocated.
> 
> The ptdesc_alloc() equivalent right now is named pagetable_alloc(), so I
> don't think it'd get confusing.

