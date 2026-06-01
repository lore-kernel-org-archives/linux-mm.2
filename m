Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45D19CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:40:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A91AC6B03E1; Mon,  1 Jun 2026 10:40:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A69676B03E3; Mon,  1 Jun 2026 10:40:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97F2D6B03E4; Mon,  1 Jun 2026 10:40:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 840166B03E1
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:40:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3264FA06DA
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:40:52 +0000 (UTC)
X-FDA: 84831605544.27.D88EF7E
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4654F4000D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:40:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=evFhdQCP;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780324850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J4aPGrRgNjMb89kE0MsI1jCpJ1Gg+ht17UOIw37ygFY=;
	b=oE4J2533qUllhP4IRayRGa1FVFT01aDbn7QMyxku3EGEB33IkIbh5slMI+laT1NQRKSYfd
	UCFqKOIdbqw61R8ATQCW05vcDLwb/Ca0kAxEni30QL5PTNq/+762nj3ECK63WwVeBiPbv/
	oU850g5FkUyKOulvrb27PWSxYsmhEuI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=evFhdQCP;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780324850; a=rsa-sha256;
	cv=none;
	b=6dKnjVTf4Gye+XQo0wr2l1RgHs3NfQ6pV3Lrp7EN3fnhMYxj9aXJyEN6RkGgm7lUe4SSpd
	iuJr/4/C/4bRuqcRnYEyyca2OcEwwct/rFkW/s4EfDqA8eXr+lvgJQ2LeQJSYYQiFmIcDz
	DRO9j3zl2kYMmmno4iALsipoqcBNcnQ=
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-7e2fc11088dso11879047b3.2
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 07:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780324849; x=1780929649; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J4aPGrRgNjMb89kE0MsI1jCpJ1Gg+ht17UOIw37ygFY=;
        b=evFhdQCPy7Yg55PEyUqJkp13GbMHnf5tk2gIjYk0tm2+ryfzoK55AlupacvtxBX7De
         IvRp/KCw2J+ls1ga9X+vUjjQ7dqD1oXZXDUV8a+RqskXeuaZUCSz5EqzdKPg49jQSggl
         CwlVBoE4r6YiUT+ewDUIPZnu6gWbmZpW9pxCSrk/iQt3CBJR+1Gtj9HgI8m4+aIzTCRl
         sVYC+jIQcZrDFQR29DK4SNbMSu/bP7yLp7iAaa5UDT6bO/Zi38FpvMi4U05Wezcrcjzm
         2vLLq2H+lrE7DsfO2mXATGVX28e+6KazS0shIBynt1kvGlvKa8QLh+ayZRitVpojKhDv
         VKng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780324849; x=1780929649;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J4aPGrRgNjMb89kE0MsI1jCpJ1Gg+ht17UOIw37ygFY=;
        b=bCT/0pUr4trXnFFT2dMWwiLuRhKci+hUgVihDCxOPcSOgKRycMxRpCy5N9f9GYK07w
         qR9EWYnpljLvhWVvQ57sMpv2twNMKVi0n1ngWA7pLKyDzuiB8CPAuykmjjNvTdyLn3tY
         DlrIowF/j4MpCPKQSAu/5/mYGYugBRnfKuZ00PU8Dlm2TH0Y1UmhRL2O4XPawVw3CUhx
         zmxA4kIXQ7RIz8/ICGAsixdiMlgZX1S2JPzJm9nr92hZKN9tWk7BlTYOMVSIDrFrUPUd
         RdXJBgeL+QPwKLul0uQX8EumxF/EmsKqtoEg1YVXC6aa2760XzHmhFXZHqu8jLsSI+Ez
         sKFw==
X-Forwarded-Encrypted: i=1; AFNElJ+7VJeBvjQwC25kDK/OZThyfqXAfRPyDV0rMrbCuc3CQpxE+99KrgcP4umIp7Jpytn9qMISNwq8sg==@kvack.org
X-Gm-Message-State: AOJu0YwWG8GLPRrzfems6dYYTAC7sU7/o7XTpLs0LYufPDFRimuBQcfG
	Vkm0EoAtosSyXUAKAmHkJ2EblZsKwDya9YYcpdxVxhwo7NjuyqB0MyE5ZoLiaMMAB4M=
X-Gm-Gg: Acq92OF+M4rR3tIleMP+GskVpoJFJUTFi5dx+eBs2pEKKJXCm3mnIKPNwPrkhPn2ZEb
	/LH91+zqgRFUMED5jKL1lnj57XKuIKPqiyJVp+/8YXqKPqFcVnPOQMAFtHl0SxyMM/j0A6PXjPj
	3EswSoxzBaAXEatyEGsC6aMKIbBi+E4iGca+r57YGaWLuTTArJV1sT0QSrzkKE3kdSnCSW+8wYF
	+Rf+euIykGZpsbsohqXA4OPvWLOSaECuUHENl3D5gyqWcjnVO427IzL9efXcjs6PcS4f4LAec8d
	x3IUUROIeg+Jo5vH9G3KIaAmDm64pV/HInD4auD4FdLC+/PISI38IeWeH6OcU92MIN3/suyW0Mk
	sMdztyyuDCuuDpdLspW1SgiB7gH0xhdcpbgGB9siQ9IaB+pR1OFi/6LKiqkKkV2F64cqeR42BeJ
	KZ7QwM55KEoY+Zm0Zh/OlhtnJ7CKh5oa4LuiKDyELuhBjS4LAqhK8TQQH3EQ98QJd7d6Pe1ct9T
	mn4CiJlG5g0e99dfjwj7Ywz2KErAwPq9FkvZfggXoSkV/4O5ITR1Q==
X-Received: by 2002:a05:690c:4889:b0:7b2:fc6f:b9bc with SMTP id 00721157ae682-7e05ab41b21mr96105247b3.21.1780324849077;
        Mon, 01 Jun 2026 07:40:49 -0700 (PDT)
Received: from google.com (138.200.150.34.bc.googleusercontent.com. [34.150.200.138])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7e175de2469sm40997617b3.2.2026.06.01.07.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 07:40:48 -0700 (PDT)
Date: Mon, 1 Jun 2026 10:40:47 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, akpm@linux-foundation.org, 
	linux-mm@kvack.org, skhan@linuxfoundation.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, corbet@lwn.net, dmatlack@google.com, kexec@lists.infradead.org, 
	skhawaja@google.com, graf@amazon.com
Subject: Re: [PATCH v4 10/13] liveupdate: Remove limit on the number of files
 per session
Message-ID: <ah2Z0R9uI7bNaUi5@google.com>
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
 <20260530221938.115978-11-pasha.tatashin@soleen.com>
 <2vxzbjdufirq.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzbjdufirq.fsf@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4654F4000D
X-Stat-Signature: 85oazu8n8i666em8x9cb94f7n19ywhjz
X-HE-Tag: 1780324850-224034
X-HE-Meta: U2FsdGVkX1/9v54+Y16TlNfHdGYtQ0cqvfvm81MQFOSZEUTxQtkTPdoUDjqV6LF9Gzizfsa5NKFMfrPLCZCuok/7/D/2+cfgF2pyHFHTHW0sZTBQ0AlB/0iJNFzaj40NIR1i1qHhEohJsjTWmiFDdV0IJnOJc2+Ap4ZVXUZ2vizVdorBnWxmW1WFJsAwDY/HD+2tOu9Tn8olyY0/NpSs9gqi2L/PxYGLhj+HnU74nSgBJbJhh0wDuztoYQ+TOWKbVjucmLlxZe5/7T3F5Ux2Lx9EzFuqhgmaee6r4LuPlyi+Em1EaIPetsk1+HmLzlBq48caibQRKQqALYQJXE4IdsRkDFbWPJiMP3FNb6hM06t8hWDtFlGbQGIq6yZK3DGnG3XhHrJJzwBbf1yAfB5TB2vlWnkJjlbqVRploJ1PqGPkHuzf09L3Gido0rotf7FL8IMo1nKuREMoGVBs9ivMpNcVrClLaSWGuI28RxcK/BRPfDbct/ilexyNliudPxMLWv2s7duOxvoZC1dwsLnPXn5ZWga/oJ/KQUztnJXevoHBhd2SZGUWGU+X5DcLIeyM1Av8O1J1RDRygEEkNoO51PlVktNqDrgotdq377CS8jRaviF9WcedDPhZ95lnsVyQT8lAL2GnPo3oJBHHHVls4dDH+3R8UCyXNCac/6zkVOEMmBliHo9ADxYHIM39k1xf9t4TbH7OSKosHEK2Gq6Gvt8a5WrmxDFjX5PfJZpCOm4srIwZamBb89xHJwggHClCxTEFfYGcwbMUILaB0fPfd5AU2VP3tfpr3CEj7Nv0278p5YNlXiGvIWYayiQDrgeq82kLx0JiRdQCAWEpd/n1cJz9Na/Ub/bRN07IZTdYQLtcd9eGMTbpKjiUyM3+FReOhmKHQIkIEIDKbYElMZ1Z9OapQCIWa8nVUMeEOWxlqWZ1r5aIsPv6LMHoKyqkVfjrk5wVly4gLRD6I1yzL2e
 uqL4paJe
 qA7ZKaqEs+6e0cV7LH6cqLNEtHww2rUFpFdDOZlqyHR04nsnb84Og/aq8HxUx/jgNUflK+GW+YBfK4HLYJLVsfOcPqzRGGKQrez7bxLFlck4OHn7NXl9owsdhcKVPAV8JYKuPQqd122KQ2qwdmYhTs7yuy19HOxvX70ejxcoSLocefNsifXZ2COa5NJbU6plcqZmr1EvsdRhIYUco2vdC/Qc20jryxDYQGFEVo0rTQbQNsx22BmI/JKcIYZGqOZgr32jX3JFRxep1S7GoUSIJmz6e//AdKv2n4XlSe46D4u41X2OG+gODZOsvFEYdbyXq1wiT5sLfRyrp7WA7dvj5kYquKlw9l2UCsfKVlFjgRjEcRI7w2sWOsqtXP3wWHhj+Sg4oZGLDYPNeNHI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06-01 16:16, Pratyush Yadav wrote:
> On Sat, May 30 2026, Pasha Tatashin wrote:
> 
> > To remove the fixed limit on the number of preserved files per session,
> > transition the file metadata serialization from a single contiguous
> > memory block to a chain of linked blocks.
> >
> > Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  include/linux/kho/abi/luo.h      |  13 +--
> >  kernel/liveupdate/luo_file.c     | 144 +++++++++++++++----------------
> >  kernel/liveupdate/luo_internal.h |   6 +-
> >  3 files changed, 80 insertions(+), 83 deletions(-)
> >
> > diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
> > index 79758d92ed5f..16df550ef143 100644
> > --- a/include/linux/kho/abi/luo.h
> > +++ b/include/linux/kho/abi/luo.h
> > @@ -35,8 +35,8 @@
> >   *
> >   *   - struct luo_session_ser:
> >   *     Metadata for a single session, including its name and a physical pointer
> > - *     to another preserved memory block containing an array of
> > - *     `struct luo_file_ser` for all files in that session.
> > + *     to the first `struct kho_block_header_ser` for all files in that session.
> > + *     Multiple blocks are linked via the `next` field in the header.
> >   *
> >   *   - struct luo_file_ser:
> >   *     Metadata for a single preserved file. Contains the `compatible` string to
> > @@ -65,7 +65,7 @@
> >   * The LUO state is registered under this KHO entry name.
> >   */
> >  #define LUO_KHO_ENTRY_NAME	"LUO"
> > -#define LUO_COMPAT_BASE		"luo-v3"
> > +#define LUO_COMPAT_BASE		"luo-v4"
> >  #define LUO_ABI_COMPATIBLE	LUO_COMPAT_BASE "-" KHO_BLOCK_ABI_COMPATIBLE
> >  #define LUO_ABI_COMPAT_LEN	ALIGN(sizeof(LUO_ABI_COMPATIBLE), 8)
> >  
> > @@ -103,9 +103,10 @@ struct luo_file_ser {
> >  
> >  /**
> >   * struct luo_file_set_ser - Represents the serialized metadata for file set
> > - * @files:   The physical address of a contiguous memory block that holds
> > - *           the serialized state of files (array of luo_file_ser) in this file
> > - *           set.
> > + * @files:   The physical address of the first `struct kho_block_header_ser`.
> > + *           This structure is the header for a block of memory containing
> > + *           an array of `struct luo_file_ser` entries. Multiple blocks are
> > + *           linked via the `next` field in the header.
> >   * @count:   The total number of files that were part of this session during
> >   *           serialization. Used for iteration and validation during
> >   *           restoration.
> > diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> > index 9eec07a9e9fc..a445b1950ca7 100644
> > --- a/kernel/liveupdate/luo_file.c
> > +++ b/kernel/liveupdate/luo_file.c
> > @@ -118,11 +118,6 @@ static LIST_HEAD(luo_file_handler_list);
> >  /* Keep track of files being preserved by LUO */
> >  static DEFINE_XARRAY(luo_preserved_files);
> >  
> > -/* 2 4K pages, give space for 128 files per file_set */
> > -#define LUO_FILE_PGCNT		2ul
> > -#define LUO_FILE_MAX							\
> > -	((LUO_FILE_PGCNT << PAGE_SHIFT) / sizeof(struct luo_file_ser))
> > -
> >  /**
> >   * struct luo_file - Represents a single preserved file instance.
> >   * @fh:            Pointer to the &struct liveupdate_file_handler that manages
> > @@ -174,39 +169,6 @@ struct luo_file {
> >  	u64 token;
> >  };
> >  
> > -static int luo_alloc_files_mem(struct luo_file_set *file_set)
> > -{
> > -	size_t size;
> > -	void *mem;
> > -
> > -	if (file_set->files)
> > -		return 0;
> > -
> > -	WARN_ON_ONCE(file_set->count);
> > -
> > -	size = LUO_FILE_PGCNT << PAGE_SHIFT;
> > -	mem = kho_alloc_preserve(size);
> > -	if (IS_ERR(mem))
> > -		return PTR_ERR(mem);
> > -
> > -	file_set->files = mem;
> > -
> > -	return 0;
> > -}
> > -
> > -static void luo_free_files_mem(struct luo_file_set *file_set)
> > -{
> > -	/* If file_set has files, no need to free preservation memory */
> > -	if (file_set->count)
> > -		return;
> > -
> > -	if (!file_set->files)
> > -		return;
> > -
> > -	kho_unpreserve_free(file_set->files);
> > -	file_set->files = NULL;
> > -}
> > -
> >  static unsigned long luo_get_id(struct liveupdate_file_handler *fh,
> >  				struct file *file)
> >  {
> > @@ -276,16 +238,15 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
> >  	if (luo_token_is_used(file_set, token))
> >  		return -EEXIST;
> >  
> > -	if (file_set->count == LUO_FILE_MAX)
> > -		return -ENOSPC;
> > +	err = kho_block_grow(&file_set->block_set, file_set->count);
> > +	if (err)
> > +		return err;
> >  
> >  	file = fget(fd);
> > -	if (!file)
> > -		return -EBADF;
> > -
> > -	err = luo_alloc_files_mem(file_set);
> > -	if (err)
> > -		goto  err_fput;
> > +	if (!file) {
> > +		err = -EBADF;
> > +		goto err_shrink;
> > +	}
> >  
> >  	err = -ENOENT;
> >  	down_read(&luo_register_rwlock);
> > @@ -300,7 +261,7 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
> >  
> >  	/* err is still -ENOENT if no handler was found */
> >  	if (err)
> > -		goto err_free_files_mem;
> > +		goto err_fput;
> >  
> >  	err = xa_insert(&luo_preserved_files, luo_get_id(fh, file),
> >  			file, GFP_KERNEL);
> > @@ -343,10 +304,10 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
> >  	xa_erase(&luo_preserved_files, luo_get_id(fh, file));
> >  err_module_put:
> >  	module_put(fh->ops->owner);
> > -err_free_files_mem:
> > -	luo_free_files_mem(file_set);
> >  err_fput:
> >  	fput(file);
> > +err_shrink:
> > +	kho_block_shrink(&file_set->block_set, file_set->count);
> >  
> >  	return err;
> >  }
> > @@ -392,13 +353,14 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
> >  
> >  		list_del(&luo_file->list);
> >  		file_set->count--;
> > +		kho_block_shrink(&file_set->block_set, file_set->count);
> >  
> >  		fput(luo_file->file);
> >  		mutex_destroy(&luo_file->mutex);
> >  		kfree(luo_file);
> >  	}
> >  
> > -	luo_free_files_mem(file_set);
> > +	kho_block_destroy(&file_set->block_set);
> >  }
> >  
> >  static int luo_file_freeze_one(struct luo_file_set *file_set,
> > @@ -454,7 +416,7 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
> >  		luo_file_unfreeze_one(file_set, luo_file);
> >  	}
> >  
> > -	memset(file_set->files, 0, LUO_FILE_PGCNT << PAGE_SHIFT);
> > +	kho_block_set_clear(&file_set->block_set);
> >  }
> >  
> >  /**
> > @@ -493,19 +455,23 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
> >  int luo_file_freeze(struct luo_file_set *file_set,
> >  		    struct luo_file_set_ser *file_set_ser)
> >  {
> > -	struct luo_file_ser *file_ser = file_set->files;
> >  	struct luo_file *luo_file;
> > +	struct kho_block_it it;
> >  	int err;
> > -	int i;
> >  
> >  	if (!file_set->count)
> >  		return 0;
> >  
> > -	if (WARN_ON(!file_ser))
> > -		return -EINVAL;
> > +	kho_block_it_init(&it, &file_set->block_set);
> >  
> > -	i = 0;
> >  	list_for_each_entry(luo_file, &file_set->files_list, list) {
> > +		struct luo_file_ser *file_ser = kho_block_it_next(&it);
> > +
> > +		if (!file_ser) {
> > +			err = -ENOSPC;
> > +			goto err_unfreeze;
> > +		}
> 
> This should not fail normally, right? Since we pre-allocate the memory.
> Perhaps add a comment saying that?
> 
> > +
> >  		err = luo_file_freeze_one(file_set, luo_file);
> >  		if (err < 0) {
> >  			pr_warn("Freeze failed for token[%#0llx] handler[%s] err[%pe]\n",
> > @@ -514,16 +480,21 @@ int luo_file_freeze(struct luo_file_set *file_set,
> >  			goto err_unfreeze;
> >  		}
> >  
> > -		strscpy(file_ser[i].compatible, luo_file->fh->compatible,
> > -			sizeof(file_ser[i].compatible));
> > -		file_ser[i].data = luo_file->serialized_data;
> > -		file_ser[i].token = luo_file->token;
> > -		i++;
> > +		strscpy(file_ser->compatible, luo_file->fh->compatible,
> > +			sizeof(file_ser->compatible));
> > +		file_ser->data = luo_file->serialized_data;
> > +		file_ser->token = luo_file->token;
> >  	}
> > +	kho_block_it_finalize(&it);
> >  
> >  	file_set_ser->count = file_set->count;
> > -	if (file_set->files)
> > -		file_set_ser->files = virt_to_phys(file_set->files);
> > +	if (!list_empty(&file_set->block_set.blocks)) {
> > +		struct kho_block *block;
> > +
> > +		block = list_first_entry(&file_set->block_set.blocks,
> > +					 struct kho_block, list);
> > +		file_set_ser->files = virt_to_phys(block->ser);
> > +	}
> 
> Please, add an API in KHO block to return the header physical address.
> Poking into the internals of the data structure like this is not a good
> idea.

SGTM

> 
> I missed that patch 9 also does this. So please use that there too.
> 
> >  
> >  	return 0;
> >  
> > @@ -741,14 +712,12 @@ int luo_file_finish(struct luo_file_set *file_set)
> >  		module_put(luo_file->fh->ops->owner);
> >  		list_del(&luo_file->list);
> >  		file_set->count--;
> > +		kho_block_shrink(&file_set->block_set, file_set->count);
> >  		mutex_destroy(&luo_file->mutex);
> >  		kfree(luo_file);
> >  	}
> >  
> > -	if (file_set->files) {
> > -		kho_restore_free(file_set->files);
> > -		file_set->files = NULL;
> > -	}
> > +	kho_block_destroy(&file_set->block_set);
> >  
> >  	return 0;
> >  }
> > @@ -822,16 +791,18 @@ int luo_file_deserialize(struct luo_file_set *file_set,
> >  			 struct luo_file_set_ser *file_set_ser)
> >  {
> >  	struct luo_file_ser *file_ser;
> > +	struct kho_block_it it;
> >  	int err;
> > -	u64 i;
> >  
> >  	if (!file_set_ser->files) {
> >  		WARN_ON(file_set_ser->count);
> >  		return 0;
> >  	}
> >  
> > -	file_set->count = file_set_ser->count;
> > -	file_set->files = phys_to_virt(file_set_ser->files);
> > +	file_set->count = 0;
> > +	err = kho_block_restore(&file_set->block_set, file_set_ser->files);
> > +	if (err)
> > +		return err;
> >  
> >  	/*
> >  	 * Note on error handling:
> > @@ -848,25 +819,50 @@ int luo_file_deserialize(struct luo_file_set *file_set,
> >  	 * userspace to detect the failure and trigger a reboot, which will
> >  	 * reliably reset devices and reclaim memory.
> >  	 */
> > -	file_ser = file_set->files;
> > -	for (i = 0; i < file_set->count; i++) {
> > -		err = luo_file_deserialize_one(file_set, &file_ser[i]);
> > +	kho_block_it_init(&it, &file_set->block_set);
> > +	while ((file_ser = kho_block_it_read(&it))) {
> > +		err = luo_file_deserialize_one(file_set, file_ser);
> >  		if (err)
> > -			return err;
> > +			goto err_destroy_blocks;
> > +		file_set->count++;
> > +	}
> > +
> > +	if (file_set->count != file_set_ser->count) {
> > +		pr_warn("File count mismatch: expected %llu, found %llu\n",
> > +			file_set_ser->count, file_set->count);
> > +		err = -EINVAL;
> > +		goto err_destroy_blocks;
> >  	}
> >  
> >  	return 0;
> > +
> > +err_destroy_blocks:
> > +	while (!list_empty(&file_set->files_list)) {
> > +		struct luo_file *luo_file;
> > +
> > +		luo_file = list_first_entry(&file_set->files_list,
> > +					    struct luo_file, list);
> > +		list_del(&luo_file->list);
> > +		module_put(luo_file->fh->ops->owner);
> > +		mutex_destroy(&luo_file->mutex);
> > +		kfree(luo_file);
> > +	}
> > +	file_set->count = 0;
> > +	kho_block_destroy(&file_set->block_set);
> > +	return err;
> >  }
> >  
> >  void luo_file_set_init(struct luo_file_set *file_set)
> >  {
> >  	INIT_LIST_HEAD(&file_set->files_list);
> > +	kho_block_set_init(&file_set->block_set, sizeof(struct luo_file_ser));
> >  }
> >  
> >  void luo_file_set_destroy(struct luo_file_set *file_set)
> >  {
> >  	WARN_ON(file_set->count);
> >  	WARN_ON(!list_empty(&file_set->files_list));
> > +	WARN_ON(!list_empty(&file_set->block_set.blocks));
> 
> Here too.

Sure

> 
> >  }
> >  
> >  /**
> > diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
> > index ee18f9a11b91..64879ffe7378 100644
> > --- a/kernel/liveupdate/luo_internal.h
> > +++ b/kernel/liveupdate/luo_internal.h
> > @@ -10,6 +10,7 @@
> >  
> >  #include <linux/liveupdate.h>
> >  #include <linux/uaccess.h>
> > +#include <linux/kho_block.h>
> >  
> >  struct luo_ucmd {
> >  	void __user *ubuffer;
> > @@ -44,14 +45,13 @@ static inline int luo_ucmd_respond(struct luo_ucmd *ucmd,
> >   * struct luo_file_set - A set of files that belong to the same sessions.
> >   * @files_list: An ordered list of files associated with this session, it is
> >   *              ordered by preservation time.
> > - * @files:      The physically contiguous memory block that holds the serialized
> > - *              state of files.
> > + * @block_set:  The set of serialization blocks.
> >   * @count:      A counter tracking the number of files currently stored in the
> >   *              @files_list for this session.
> >   */
> >  struct luo_file_set {
> >  	struct list_head files_list;
> > -	struct luo_file_ser *files;
> > +	struct kho_block_set block_set;
> >  	u64 count;
> >  };
> 
> -- 
> Regards,
> Pratyush Yadav

