Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7AAACD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 20:06:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2688F6B008A; Tue, 12 May 2026 16:06:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 219386B008C; Tue, 12 May 2026 16:06:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E1116B0092; Tue, 12 May 2026 16:06:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA9956B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:06:32 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 92FE0160665
	for <linux-mm@kvack.org>; Tue, 12 May 2026 20:06:32 +0000 (UTC)
X-FDA: 84759850224.21.DC9EB61
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9FBA180014
	for <linux-mm@kvack.org>; Tue, 12 May 2026 20:06:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WJoJ9WKx;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778616390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gvh6SVvBnyn46LW90EYVSNPF6PzhYnXUJVgnPGPv1Ic=;
	b=JDQoA4t4KvB763g2XDcYdcU/vNpzEvI0HV/zUE0Uejp7DEU94keCth9LW60V6HPZfS/HA4
	ivKPEk0xr4jjnJFQAMi3fob524s1GIurcZ/RSi9SfTdrEpJ0KPAyMMrgtaRr8To+Ky0WFL
	H8Kw50GmOd/bZmKraEAdA/JoCeCM/s8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WJoJ9WKx;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778616390; a=rsa-sha256;
	cv=none;
	b=SqwiYwIY6YFbDeJtggSC3MBektAOyepugsjv+5KCzCveKNKI10Dc+DAR18W/hMtzcG+egq
	I3WwNt1nm/bn+xdjIKbTlJfcp/ylOO/4W3PBRJ5SjN7qLoMqdtqLJONM7PdcQMMxcJcsoS
	Wf3BYwUUX5dDO6dJakqyVMaQgaVMrZQ=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-90eb7a63a30so48519585a.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 13:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1778616389; x=1779221189; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gvh6SVvBnyn46LW90EYVSNPF6PzhYnXUJVgnPGPv1Ic=;
        b=WJoJ9WKxFH7i7Z+98qA/2MZAzTE1LNmwPq8QS5K4BVQWBFoYI/MAI2bmFPY6jjzyph
         hQQRpbcwRasPWArDXbO2hn9v93n2T5RQRWU8JSFZqakdylFaOdw01YelGA9dGHjg3dOc
         VrNREuVK0l3tHWMEoaIjp+mAiLMA/2BlzruXGDkeGXO+N4Z719xQsBLhV58enNbjP2KC
         PJo6m7kdfS7qyhJbUGGHp51rS3dBQseQpNnHwUTf4Xa1E+Fm7+1fVlj1g2TNY6qmbLGp
         i/3xyNZYb181VgLtlOl11uXgipQHoBcDtZb93LhzwYinfuCXmofeDlvN3l+91rAPuOam
         /w1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778616389; x=1779221189;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gvh6SVvBnyn46LW90EYVSNPF6PzhYnXUJVgnPGPv1Ic=;
        b=HlRkkGbNbIx+9tQdKiRKjmHrBQu0NeiF7K6MIUAZvZzvJfhMbTacsqgCTZBbQeZuYS
         Oyi2VMFHKsgxvw+8WkUc28D1Rb6GE8tmdqZsUzwmU+F1kuh9ZIbyGgoUDEOLVvHlFL1Y
         PjeMN6AN5yMJUWPgDl3g5vnhAzhKdnINnMz9Y/YYWoPHJ4SYCPje6UznRtSgUOTNMM59
         RBWd1OiWVbt9YDg0M5+c6ua/eciZu51NWbdfeWhYYcvarGXXGNhBj5d+yMdEMjuidBN/
         DqdmDDqhJrbdfEBF1rw9e9AgPGXt9IXmsJmjn1A0Yb00m1wVif72ieG62nYARoW3bITu
         I7wQ==
X-Forwarded-Encrypted: i=1; AFNElJ95b2uMBjQCh1nmaFaF7eJaUDwG6wd6qbxUs6Tgi02FC8GseJ+rzCrF6RC0TUQlwsJnj5TIQc+yjQ==@kvack.org
X-Gm-Message-State: AOJu0Yz1TKtGYRb3sFeFOZYKO0kSIjEB1AwqKi7R3V9schLzY6CmYnVT
	h41J1MAYHkx7XgZQpEbpVUBoFPSPpTk4zxy3+KMF1YHm539o6CgfoxVdfJSAjw9AV7g=
X-Gm-Gg: Acq92OEI1w678POfGCBPbaLDQMbDrIpVCpSIDxjPYyNnPfH9IULVbaKGv+UWd2YKHTi
	DGaMzrBlRtXO+85rf3VjuYbycckZDbNqlpqtL3FDSrD8zGl18+B87kQFeYw/P+IOGM2U6zapOjI
	BoDPuDJqPOoOffROFFplDsTelzjlWl8B8tVVXvhU8iwKGiTgJmYlA+SBHg8wklMRgp7w9WYbI7a
	BLRC1CdCxqiwkJr1r0v87vH8L0a608YLUvTTlB3X9wD3WdRYaUDrMM4MsMFm0k5Am4kedannn4x
	b4FF7zld4AlL9kiREaOzG1dUv//FqrDW9p62uytY3CCambvfraoMFM4Jt/4wdc7tSlLSpHRW2+6
	QMDOsJpVz6GBJd8cVwzWCaeeYnesml4EmCoE7kRyGy2uh2ukxaPmbBIIOp/ot31Wyk8LPgIv6e3
	+piD57d43VSFjbxBY2IfJQxoQCEEwhi3w2C0r7pHjJESNuu070VTw=
X-Received: by 2002:a05:620a:d93:b0:902:eacc:bf88 with SMTP id af79cd13be357-90f8b7b5dbdmr72762485a.62.1778616389387;
        Tue, 12 May 2026 13:06:29 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fc2cd057acsm3815592585a.47.2026.05.12.13.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 13:06:28 -0700 (PDT)
Date: Tue, 12 May 2026 20:06:27 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, dmatlack@google.com, 
	kexec@lists.infradead.org, skhawaja@google.com, graf@amazon.com
Subject: Re: [PATCH 2/5] liveupdate: Remove limit on the number of files per
 session
Message-ID: <agNWbKNvpJFM4YE7@plex>
References: <20260414200237.444170-1-pasha.tatashin@soleen.com>
 <20260414200237.444170-3-pasha.tatashin@soleen.com>
 <2vxzwlx8afwg.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzwlx8afwg.fsf@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9FBA180014
X-Stat-Signature: 6jeq1st4w8nrweo7ngrmh5w5pt9hq7ha
X-HE-Tag: 1778616390-130575
X-HE-Meta: U2FsdGVkX1/4a2/ChKVFfDBjUP9k4iJooDqQP7KRBHTjYknU3HZbAmLLuFwgT4cejBBiKS+NrkxgnIGrXP3/yabMaES6fMHE9XC0wC87nhzGyyaii1jqKEuYfrIAMS0tmYZZkUPsfOUfpIsby4SQ0tPwYhghosIYoXC3tLOLylWKBg4jDCTkcz9x6F4wFEYs5/TtCOZ9fMxwzssT42ZKMe2IkDXQbVSVKX2TZYWew3ZD0FoXGp2XL0GRmA5S0PBHhdWP/j3+ev0qvhyJF+rmuukmmKpIXzsTYlgZ/tWRDntocEw1ayK6ZHu0p7Qw+AULDFxUYwfSwAiTJ0J0rNx8S7uHz3Ka50eXy5x0F8JlpLtlqp9/qB4MpIjc4xSsVQA0C5HwZsCEazI6t+nmIv3/K3RgslsSU5d8LjPN9bvN7PFiNyESIZl10ss9YTmckQ0Bpw3z1XShxAZCLVaMd1+2WpnEYQIKPOT8D9aJPSy1bCvohJ/lB/QONHYS1aPmLwKW9xDdVGhlK3lAMoGOipq8i31caxeeORI1aAE5U11ORMfr9WdT5a7hM1Xx+jRBMoXGkv/D1a7xHi4bA/ghSin/c6lvtLStNd3YbapTmyga7g65FxamETU8fsGON9BTKqfrge6nCCENlHSeOME5AF/WhZ8TnSLPX0qPpOE3xEcyS07cEYu92tl85MsMKU3XBykBMJtN9cJV3KYnfA4yT6O6a57ZlRLt6w/d6J2t26nOriVfylnrEuFovwxS+aVJywKAB+XcWqV9qStr/JpkIMj7GT496hxnjFPxbxA1Gi50L84MBnbpNHU6Z+qTehVaij1CAFCGO3YXA9dAFVjFBPjJFzbo5H1xNZgNKuHWoxjZxaIXrpSkopT79vpde+0uH84rZj+thc6RWx0lm+6mWDJ2wi3oUgGAQ1KFyMwVF9ptm0Cg4852di6ljBmcTiW7J0pmSYFqMi11IW3vgMn/LV0
 mkQssiQB
 9mEnFxTKVM5pnp0fWboWzMQRc1lqTAQY73rTfsFYnv4wiWb+jHiXLB+J19LsCkis1srLc5PNwep8rKGz/8M0JOJle8MmFIPJh1KanKep1wpmX9LwUMzNX+MNICmcKByM17ElfpuWfVj1UQRfLwyM1SbIDLhhInO8Rh9dEVpO9lSxuYiQs0Qfa7GzWvNG2gvqMiRklB3uQt8F8eHmEH6Hb7S53bzpwNg5gyPawkbobx1jIrS/Yo2aLy3cris79hKHiuB1UBINtwpVhVPhZfzmN+8LsxfTIntrNmfPYMe9HyQd/wtszGS+g1n5B2pdpYY6VUGoPR7PALPgN8XrvrtGAmVddAx4QamjzQRhTlA+66ZUJPsd/2hkD8wZJvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-12 15:58, Pratyush Yadav wrote:
> On Tue, Apr 14 2026, Pasha Tatashin wrote:
> 
> > To remove the fixed limit on the number of preserved files per session,
> > transition the file metadata serialization from a single contiguous memory
> > block to a chain of linked blocks.
> 
> Same comment as previous patch about a general linked block data
> structure here.
> 
> >
> > ABI Changes:
> > - Define 'struct luo_file_header_ser' to manage linked blocks in preserved
> >   memory.
> > - Update 'struct luo_file_set_ser' to point to the head of the block chain.
> > - Bump the session ABI version to 'luo-session-v4' to reflect these breaking
> >   changes.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  include/linux/kho/abi/luo.h      |  35 ++++-
> >  kernel/liveupdate/luo_file.c     | 226 ++++++++++++++++++++-----------
> >  kernel/liveupdate/luo_internal.h |  17 ++-
> >  3 files changed, 189 insertions(+), 89 deletions(-)
> >
> > diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
> > index f5732958545e..a15f6a0f3d93 100644
> > --- a/include/linux/kho/abi/luo.h
> > +++ b/include/linux/kho/abi/luo.h
> > @@ -84,8 +84,13 @@
> >   *
> >   *   - struct luo_session_ser:
> >   *     Metadata for a single session, including its name and a physical pointer
> > - *     to another preserved memory block containing an array of
> > - *     `struct luo_file_ser` for all files in that session.
> > + *     to the first `struct luo_file_header_ser` for all files in that session.
> > + *     Multiple blocks are linked via the `next` field in the header.
> > + *
> > + *   - struct luo_file_header_ser:
> > + *     Header for the file data block. Contains the physical address of the
> > + *     next file data block and the number of `struct luo_file_ser` entries
> > + *     that follow this header in the current block.
> >   *
> >   *   - struct luo_file_ser:
> >   *     Metadata for a single preserved file. Contains the `compatible` string to
> > @@ -134,11 +139,29 @@ struct luo_file_ser {
> >  	u64 token;
> >  } __packed;
> >  
> > +/**
> > + * struct luo_file_header_ser - Header for the serialized file data block.
> > + * @next:  Physical address of the next struct luo_file_header_ser.
> > + * @count: The number of `struct luo_file_ser` entries that immediately
> > + *         follow this header in the memory block.
> > + *
> > + * This structure is located at the beginning of a block of
> > + * physical memory preserved across the kexec. It provides the necessary
> > + * metadata to interpret the array of file entries that follow.
> > + *
> > + * If this structure is modified, `LUO_FDT_SESSION_COMPATIBLE` must be updated.
> > + */
> > +struct luo_file_header_ser {
> 
> Nit: Same as before, can we rename it to make it clear that this is a
> block header?

Done

> 
> > +	u64 next;
> > +	u64 count;
> > +} __packed;
> > +
> >  /**
> >   * struct luo_file_set_ser - Represents the serialized metadata for file set
> > - * @files:   The physical address of a contiguous memory block that holds
> > - *           the serialized state of files (array of luo_file_ser) in this file
> > - *           set.
> > + * @files:   The physical address of the first `struct luo_file_header_ser`.
> > + *           This structure is the header for a block of memory containing
> > + *           an array of `struct luo_file_ser` entries. Multiple blocks are
> > + *           linked via the `next` field in the header.
> >   * @count:   The total number of files that were part of this session during
> >   *           serialization. Used for iteration and validation during
> >   *           restoration.
> > @@ -154,7 +177,7 @@ struct luo_file_set_ser {
> >   *                          luo_session_header_ser
> >   */
> >  #define LUO_FDT_SESSION_NODE_NAME	"luo-session"
> > -#define LUO_FDT_SESSION_COMPATIBLE	"luo-session-v3"
> > +#define LUO_FDT_SESSION_COMPATIBLE	"luo-session-v4"
> >  #define LUO_FDT_SESSION_HEADER		"luo-session-header"
> >  
> >  /**
> > diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> > index dedbb8d02e6a..20a2d776cff4 100644
> > --- a/kernel/liveupdate/luo_file.c
> > +++ b/kernel/liveupdate/luo_file.c
> > @@ -119,10 +119,12 @@ static LIST_HEAD(luo_file_handler_list);
> >  /* Keep track of files being preserved by LUO */
> >  static DEFINE_XARRAY(luo_preserved_files);
> >  
> > -/* 2 4K pages, give space for 128 files per file_set */
> > +/* 2 4K pages, give space for 127 files per block */
> >  #define LUO_FILE_PGCNT		2ul
> > -#define LUO_FILE_MAX							\
> > -	((LUO_FILE_PGCNT << PAGE_SHIFT) / sizeof(struct luo_file_ser))
> > +#define LUO_FILE_BLOCK_MAX					\
> > +	(((LUO_FILE_PGCNT << PAGE_SHIFT) -			\
> > +	  sizeof(struct luo_file_header_ser)) /			\
> > +	 sizeof(struct luo_file_ser))
> >  
> >  /**
> >   * struct luo_file - Represents a single preserved file instance.
> > @@ -158,7 +160,7 @@ static DEFINE_XARRAY(luo_preserved_files);
> >   * and the serialized state handle returned by the handler's .preserve()
> >   * operation.
> >   *
> > - * These instances are tracked in a per-file_set list. The @serialized_data
> > + * These structures are tracked in a per-file_set list. The @serialized_data
> >   * field, which holds a handle to the file's serialized state, may be updated
> >   * during the .freeze() callback before being serialized for the next kernel.
> >   * After reboot, these structures are recreated by luo_file_deserialize() and
> > @@ -175,37 +177,68 @@ struct luo_file {
> >  	u64 token;
> >  };
> >  
> > -static int luo_alloc_files_mem(struct luo_file_set *file_set)
> > +static int luo_file_add_block(struct luo_file_set *file_set,
> > +			      struct luo_file_header_ser *ser)
> >  {
> > -	size_t size;
> > -	void *mem;
> > +	struct luo_file_block *block;
> >  
> > -	if (file_set->files)
> > -		return 0;
> > -
> > -	WARN_ON_ONCE(file_set->count);
> > +	if (file_set->nblocks >= LUO_MAX_BLOCKS)
> > +		return -ENOSPC;
> >  
> > -	size = LUO_FILE_PGCNT << PAGE_SHIFT;
> > -	mem = kho_alloc_preserve(size);
> > -	if (IS_ERR(mem))
> > -		return PTR_ERR(mem);
> > +	block = kzalloc_obj(*block);
> > +	if (!block)
> > +		return -ENOMEM;
> >  
> > -	file_set->files = mem;
> > +	block->ser = ser;
> > +	list_add_tail(&block->list, &file_set->blocks);
> > +	file_set->nblocks++;
> >  
> >  	return 0;
> >  }
> >  
> > -static void luo_free_files_mem(struct luo_file_set *file_set)
> > +static int luo_file_create_ser_block(struct luo_file_set *file_set)
> >  {
> > -	/* If file_set has files, no need to free preservation memory */
> > -	if (file_set->count)
> > -		return;
> > +	struct luo_file_block *last = NULL;
> > +	struct luo_file_header_ser *ser;
> > +	int err;
> >  
> > -	if (!file_set->files)
> > -		return;
> > +	ser = kho_alloc_preserve(LUO_FILE_PGCNT << PAGE_SHIFT);
> > +	if (IS_ERR(ser))
> > +		return PTR_ERR(ser);
> > +
> > +	if (!list_empty(&file_set->blocks))
> > +		last = list_last_entry(&file_set->blocks, struct luo_file_block, list);
> > +
> > +	err = luo_file_add_block(file_set, ser);
> > +	if (err)
> > +		goto err_unpreserve;
> > +
> > +	if (last)
> > +		last->ser->next = virt_to_phys(ser);
> 
> Same comments as last patch about list_last_entry_or_null() and moving
> this to luo_file_add_block().

Done

> 
> > +
> > +	return 0;
> >  
> > -	kho_unpreserve_free(file_set->files);
> > -	file_set->files = NULL;
> > +err_unpreserve:
> > +	kho_unpreserve_free(ser);
> > +	return err;
> > +}
> > +
> > +static void luo_file_destroy_ser_blocks(struct luo_file_set *file_set,
> > +					bool unpreserve)
> > +{
> > +	struct luo_file_block *block, *tmp;
> > +
> > +	list_for_each_entry_safe(block, tmp, &file_set->blocks, list) {
> > +		if (block->ser) {
> 
> Same here. block is always created with its ser, so why have this check?

Removed.

> 
> > +			if (unpreserve)
> > +				kho_unpreserve_free(block->ser);
> > +			else
> > +				kho_restore_free(block->ser);
> 
> And same comment about the nastiness here, but once again I have nothing
> better to offer.
> 
> > +		}
> > +		list_del(&block->list);
> > +		kfree(block);
> > +		file_set->nblocks--;
> > +	}
> >  }
> >  
> >  static unsigned long luo_get_id(struct liveupdate_file_handler *fh,
> > @@ -247,7 +280,9 @@ static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
> >   * 3. Iterates through registered handlers, calling can_preserve() to find one
> >   *    compatible with the given @fd.
> >   * 4. Calls the handler's .preserve() operation, which saves the file's state
> > - *    and returns an opaque private data handle.
> > + *    and returns an opaque u64 handle. This is typically performed while the
> > + *    workload is still active to minimize the downtime during the
> > + *    actual reboot transition.
> >   * 5. Adds the new instance to the file_set's internal list.
> >   *
> >   * On success, LUO takes a reference to the 'struct file' and considers it
> > @@ -277,17 +312,16 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
> >  	if (luo_token_is_used(file_set, token))
> >  		return -EEXIST;
> >  
> > -	if (file_set->count == LUO_FILE_MAX)
> > -		return -ENOSPC;
> > +	if (file_set->count == file_set->nblocks * LUO_FILE_BLOCK_MAX) {
> > +		err = luo_file_create_ser_block(file_set);
> > +		if (err)
> > +			return err;
> > +	}
> >  
> >  	file = fget(fd);
> >  	if (!file)
> >  		return -EBADF;
> >  
> > -	err = luo_alloc_files_mem(file_set);
> > -	if (err)
> > -		goto  err_fput;
> > -
> >  	err = -ENOENT;
> >  	down_read(&luo_register_rwlock);
> >  	list_private_for_each_entry(fh, &luo_file_handler_list, list) {
> > @@ -301,7 +335,7 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
> >  
> >  	/* err is still -ENOENT if no handler was found */
> >  	if (err)
> > -		goto err_free_files_mem;
> > +		goto err_fput;
> >  
> >  	/* safe to use fh because its module is pinned */
> >  	err = xa_insert(&luo_preserved_files, luo_get_id(fh, file),
> > @@ -345,8 +379,6 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
> >  	xa_erase(&luo_preserved_files, luo_get_id(fh, file));
> >  err_module_put:
> >  	module_put(fh->ops->owner);
> > -err_free_files_mem:
> > -	luo_free_files_mem(file_set);
> >  err_fput:
> >  	fput(file);
> >  
> > @@ -399,7 +431,7 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
> >  		kfree(luo_file);
> >  	}
> >  
> > -	luo_free_files_mem(file_set);
> > +	luo_file_destroy_ser_blocks(file_set, true);
> >  }
> >  
> >  static int luo_file_freeze_one(struct luo_file_set *file_set,
> > @@ -446,6 +478,7 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
> >  				struct luo_file *failed_entry)
> >  {
> >  	struct list_head *files_list = &file_set->files_list;
> > +	struct luo_file_block *block;
> >  	struct luo_file *luo_file;
> >  
> >  	list_for_each_entry(luo_file, files_list, list) {
> > @@ -455,7 +488,11 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
> >  		luo_file_unfreeze_one(file_set, luo_file);
> >  	}
> >  
> > -	memset(file_set->files, 0, LUO_FILE_PGCNT << PAGE_SHIFT);
> > +	list_for_each_entry(block, &file_set->blocks, list) {
> > +		block->ser->count = 0;
> > +		memset(block->ser + 1, 0,
> > +		       (LUO_FILE_PGCNT << PAGE_SHIFT) - sizeof(*block->ser));
> > +	}
> >  }
> >  
> >  /**
> > @@ -494,7 +531,8 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
> >  int luo_file_freeze(struct luo_file_set *file_set,
> >  		    struct luo_file_set_ser *file_set_ser)
> >  {
> > -	struct luo_file_ser *file_ser = file_set->files;
> > +	struct luo_file_block *block;
> > +	struct luo_file_ser *file_ser;
> >  	struct luo_file *luo_file;
> >  	int err;
> >  	int i;
> > @@ -502,11 +540,18 @@ int luo_file_freeze(struct luo_file_set *file_set,
> >  	if (!file_set->count)
> >  		return 0;
> >  
> > -	if (WARN_ON(!file_ser))
> > -		return -EINVAL;
> > +	block = list_first_entry(&file_set->blocks, struct luo_file_block, list);
> > +	file_ser = (void *)(block->ser + 1);
> >  
> >  	i = 0;
> >  	list_for_each_entry(luo_file, &file_set->files_list, list) {
> > +		if (i == LUO_FILE_BLOCK_MAX) {
> > +			block->ser->count = i;
> > +			block = list_next_entry(block, list);
> > +			file_ser = (void *)(block->ser + 1);
> > +			i = 0;
> > +		}
> > +
> >  		err = luo_file_freeze_one(file_set, luo_file);
> >  		if (err < 0) {
> >  			pr_warn("Freeze failed for token[%#0llx] handler[%s] err[%pe]\n",
> > @@ -521,10 +566,13 @@ int luo_file_freeze(struct luo_file_set *file_set,
> >  		file_ser[i].token = luo_file->token;
> >  		i++;
> >  	}
> > +	block->ser->count = i;
> >  
> >  	file_set_ser->count = file_set->count;
> > -	if (file_set->files)
> > -		file_set_ser->files = virt_to_phys(file_set->files);
> > +	if (!list_empty(&file_set->blocks)) {
> > +		block = list_first_entry(&file_set->blocks, struct luo_file_block, list);
> > +		file_set_ser->files = virt_to_phys(block->ser);
> > +	}
> >  
> >  	return 0;
> >  
> > @@ -746,10 +794,7 @@ int luo_file_finish(struct luo_file_set *file_set)
> >  		kfree(luo_file);
> >  	}
> >  
> > -	if (file_set->files) {
> > -		kho_restore_free(file_set->files);
> > -		file_set->files = NULL;
> > -	}
> > +	luo_file_destroy_ser_blocks(file_set, false);
> >  
> >  	return 0;
> >  }
> > @@ -782,8 +827,10 @@ int luo_file_finish(struct luo_file_set *file_set)
> >  int luo_file_deserialize(struct luo_file_set *file_set,
> >  			 struct luo_file_set_ser *file_set_ser)
> >  {
> > -	struct luo_file_ser *file_ser;
> > -	u64 i;
> > +	struct luo_file_header_ser *header_ser;
> > +	struct luo_file_block *block;
> > +	u64 header_ser_pa;
> > +	int err;
> >  
> >  	if (!file_set_ser->files) {
> >  		WARN_ON(file_set_ser->count);
> > @@ -791,7 +838,15 @@ int luo_file_deserialize(struct luo_file_set *file_set,
> >  	}
> >  
> >  	file_set->count = file_set_ser->count;
> > -	file_set->files = phys_to_virt(file_set_ser->files);
> > +	header_ser_pa = file_set_ser->files;
> > +
> > +	while (header_ser_pa) {
> > +		header_ser = phys_to_virt(header_ser_pa);
> > +		err = luo_file_add_block(file_set, header_ser);
> > +		if (err)
> > +			return err;
> > +		header_ser_pa = header_ser->next;
> > +	}
> >  
> >  	/*
> >  	 * Note on error handling:
> > @@ -808,42 +863,51 @@ int luo_file_deserialize(struct luo_file_set *file_set,
> >  	 * userspace to detect the failure and trigger a reboot, which will
> >  	 * reliably reset devices and reclaim memory.
> >  	 */
> > -	file_ser = file_set->files;
> > -	for (i = 0; i < file_set->count; i++) {
> > -		struct liveupdate_file_handler *fh;
> > -		bool handler_found = false;
> > -		struct luo_file *luo_file;
> > -
> > -		down_read(&luo_register_rwlock);
> > -		list_private_for_each_entry(fh, &luo_file_handler_list, list) {
> > -			if (!strcmp(fh->compatible, file_ser[i].compatible)) {
> > -				if (try_module_get(fh->ops->owner))
> > -					handler_found = true;
> > -				break;
> > -			}
> > -		}
> > -		up_read(&luo_register_rwlock);
> > +	list_for_each_entry(block, &file_set->blocks, list) {
> > +		struct luo_file_ser *file_ser = (void *)(block->ser + 1);
> >  
> > -		if (!handler_found) {
> > -			pr_warn("No registered handler for compatible '%.*s'\n",
> > -				(int)sizeof(file_ser[i].compatible),
> > -				file_ser[i].compatible);
> > -			return -ENOENT;
> > +		if (block->ser->count > LUO_FILE_BLOCK_MAX) {
> > +			pr_warn("File block contains too many entries: %llu\n",
> > +				block->ser->count);
> > +			return -EINVAL;
> >  		}
> >  
> > -		luo_file = kzalloc_obj(*luo_file);
> > -		if (!luo_file) {
> > -			module_put(fh->ops->owner);
> > -			return -ENOMEM;
> > -		}
> > +		for (int i = 0; i < block->ser->count; i++) {
> > +			struct liveupdate_file_handler *fh;
> > +			bool handler_found = false;
> > +			struct luo_file *luo_file;
> > +
> > +			down_read(&luo_register_rwlock);
> > +			list_private_for_each_entry(fh, &luo_file_handler_list, list) {
> > +				if (!strcmp(fh->compatible, file_ser[i].compatible)) {
> > +					if (try_module_get(fh->ops->owner))
> > +						handler_found = true;
> > +					break;
> > +				}
> > +			}
> > +			up_read(&luo_register_rwlock);
> >  
> > -		/* safe to use fh because its module is pinned */
> > -		luo_file->fh = fh;
> > -		luo_file->file = NULL;
> > -		luo_file->serialized_data = file_ser[i].data;
> > -		luo_file->token = file_ser[i].token;
> > -		mutex_init(&luo_file->mutex);
> > -		list_add_tail(&luo_file->list, &file_set->files_list);
> > +			if (!handler_found) {
> > +				pr_warn("No registered handler for compatible '%.*s'\n",
> > +					(int)sizeof(file_ser[i].compatible),
> > +					file_ser[i].compatible);
> > +				return -ENOENT;
> > +			}
> > +
> > +			luo_file = kzalloc_obj(*luo_file);
> > +			if (!luo_file) {
> > +				module_put(fh->ops->owner);
> > +				return -ENOMEM;
> > +			}
> > +
> > +			/* safe to use fh because its module is pinned */
> > +			luo_file->fh = fh;
> > +			luo_file->file = NULL;
> > +			luo_file->serialized_data = file_ser[i].data;
> > +			luo_file->token = file_ser[i].token;
> > +			mutex_init(&luo_file->mutex);
> > +			list_add_tail(&luo_file->list, &file_set->files_list);
> > +		}
> 
> Nit: this diff is very hard to read. Perhaps splitting this into helper
> functions would help?

Done, also added a patch to do the same for sessions.

> 
> >  	}
> >  
> >  	return 0;
> > @@ -852,12 +916,14 @@ int luo_file_deserialize(struct luo_file_set *file_set,
> >  void luo_file_set_init(struct luo_file_set *file_set)
> >  {
> >  	INIT_LIST_HEAD(&file_set->files_list);
> > +	INIT_LIST_HEAD(&file_set->blocks);
> >  }
> >  
> >  void luo_file_set_destroy(struct luo_file_set *file_set)
> >  {
> >  	WARN_ON(file_set->count);
> >  	WARN_ON(!list_empty(&file_set->files_list));
> > +	WARN_ON(!list_empty(&file_set->blocks));
> >  }
> >  
> >  /**
> > diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
> > index a73f42069301..a92aaa9c073d 100644
> > --- a/kernel/liveupdate/luo_internal.h
> > +++ b/kernel/liveupdate/luo_internal.h
> > @@ -50,19 +50,30 @@ static inline int luo_ucmd_respond(struct luo_ucmd *ucmd,
> >   */
> >  #define luo_restore_fail(__fmt, ...) panic(__fmt, ##__VA_ARGS__)
> >  
> > +/**
> > + * struct luo_file_block - Internal representation of a file serialization block.
> > + * @list: List head for linking blocks in memory.
> > + * @ser:  Pointer to the serialized header in preserved memory.
> > + */
> > +struct luo_file_block {
> > +	struct list_head list;
> > +	struct luo_file_header_ser *ser;
> > +};
> > +
> >  /**
> >   * struct luo_file_set - A set of files that belong to the same sessions.
> >   * @files_list: An ordered list of files associated with this session, it is
> >   *              ordered by preservation time.
> > - * @files:      The physically contiguous memory block that holds the serialized
> > - *              state of files.
> > + * @blocks:     The list of serialization blocks (struct luo_file_block).
> >   * @count:      A counter tracking the number of files currently stored in the
> >   *              @files_list for this session.
> > + * @nblocks:    The number of allocated serialization blocks.
> >   */
> >  struct luo_file_set {
> >  	struct list_head files_list;
> > -	struct luo_file_ser *files;
> > +	struct list_head blocks;
> >  	long count;
> > +	long nblocks;
> >  };
> >  
> >  /**
> 
> -- 
> Regards,
> Pratyush Yadav

