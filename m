Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50958CD6E5D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 02:44:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA2F26B008C; Tue,  2 Jun 2026 22:44:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B540A6B0092; Tue,  2 Jun 2026 22:44:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6A416B0093; Tue,  2 Jun 2026 22:44:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 93AC46B008C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:44:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5C64B16149F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:44:31 +0000 (UTC)
X-FDA: 84837057942.01.E093AED
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf03.hostedemail.com (Postfix) with ESMTP id 62A7320004
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:44:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WH278a1p;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780454669;
	b=7cebQ78MjYheQr5mvISXCIcrGHFUYsUFUFRENakdJVoDQ2QOBmjQNzafWTxLrtJrs2SLrC
	LMpTBR1Mg5ZZL04dbPiGdU5zmMj5ONYaqpm0tPaEP21rGEBzAJiCnSSgX+pYMXWwcnq1ng
	xy64KXWG9fbpxbTGADwNSkK2tLuG+W0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WH278a1p;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780454669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tcJUWEM17xr95CuXHQAYaU7dL0/ztgzuxkWQEIuPEA8=;
	b=D8PIL2eUq9QTaAw7Q9GlKI+3IbCQ68dHOJuvPNNTR/U7ifEYFF+6QIVqBIDGKI0i1NElKS
	9SCIsmL4q68P18Bo3jHHJDHf6Vy+4MCtBR/JhtnnMPZo1HF71si5KiiYbh4tmkhYRZSeHu
	8mDvv416rJ2MAjN29HJVrGwUxlXaXj0=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8424b6792efso859920b3a.3
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 19:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780454668; x=1781059468; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tcJUWEM17xr95CuXHQAYaU7dL0/ztgzuxkWQEIuPEA8=;
        b=WH278a1pgJQ/7QtRvwwPh+NHgSqIIFv3YCN/0nMrC2hsAG6OOznLzWfsLSfGef9gae
         pWN3dtd1yDXqn+mbkkqSbZ4PDxb+znKJ0uRM9k8EIfuWNniX/o3JjF/XopAW8H7QVviA
         OjNUWKY0ZD6TtTrL2LO1ABg6CESiz2VGa1A24nmoUxxGMRcfZTfWXTsVkoXUk5mxYHzu
         KPMDZL6Ob6xZIkF+Yb3DXNHndOY1Bn0znH8uVAgXOTMDOv2J6DnwJmNBFJSDKIhnAv7r
         Ut3k6MyjSi/jWh82ufHngT4yfqhuDIlFldDNfI26Co1wsTFfdiyzUCzP51WXRew0bJA7
         fXsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780454668; x=1781059468;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tcJUWEM17xr95CuXHQAYaU7dL0/ztgzuxkWQEIuPEA8=;
        b=CjqSynD/HTgV+hf0C9B840kRxZD9efq/22af55HS9kupTedRCXmUuVdBaZNkcyVxlA
         cZXAySLjzeZxV8+mj/LFXs9+4nxA7OonkyqD7vn38/4Mn7m3SeYJZR0IXeKYXtzbLraz
         hOSh7ulIz9+3hqvPo2bn8o/7Znt4pe+UpKlCGMcBYeUsjMw3O30cQD38IVy2IOTyXowg
         xE8vTv1BfGp7yuamgGBN+6s1T1qdNn/TKkL4op2K6D1BdfmNiVpv6jLHD9FYinqirOST
         OS9ExB1jZfyTzuscotMjBVMSrh/J0+431zS2aBXcf99YW8ZyI/2u+8dZoGxyVGFpNcLf
         NWBA==
X-Forwarded-Encrypted: i=1; AFNElJ8rfzyXYmHjROVQn08fRsFXwzcS4ZkR3bvexpohSd1Vd2CC1mNPyuI1ihnDgJLmxnqbqkD4yKF0tw==@kvack.org
X-Gm-Message-State: AOJu0Yxw+xfUtUDBiFquS587n18r2Q5uMEHJNjehitmmXT/aT0jdd9D+
	e9eDIeIM1SdCq3IyzcHKe2tbHC9HMaejzC7l6Ft4e9sfZsXvnArlhMoFS8a5vhV++QjsXDGNex3
	QVbwH
X-Gm-Gg: Acq92OEpk6E1nZwOYGk5x/cJA53ROqEZIII329zSzPLY0IH1jLizDyLofquCVmvWtR4
	8urZQOGGFDJsLA3K0uyJvQIxXc1nT9AiRMfM48ruZ/bwG39dRqFc8h1/11P7A8MI8UY6vPcDCf5
	f2R38guJ9564drsKtWf/LHsT5ISEMp7NH7C5dWBNjIqLa6mc0oGlvGKD+2ftvURo5WfJav4LzrT
	WiuW/bICEGdFEOubSc3ndwEnJQRSUfczK7eWllNBj4JNkees7NyHlWWpXGNKX4b5lmaI2sw0lPl
	scBGbCrWspNGuJizDVuqNBZazG11McyiWRfZbL0W1HjHAHhLvnxMz6CrLsIf2p3V3xZpvyx3TU2
	xHHheq8gFG3ydIEPRvxlgxCGSGeV+YwYHNpoh7Gj+U20sBSfKbOBDAqcJckGlZNuKvABcHzvtBH
	GyPIYqojZSRzh+DHOYkF+OBm9T/yMzXxmi4IOiTrfCjQOAuD7D64vKr2xYh05xeQ==
X-Received: by 2002:aa7:88c1:0:b0:831:7f71:c810 with SMTP id d2e1a72fcca58-84284fbd441mr1411085b3a.35.1780454668067;
        Tue, 02 Jun 2026 19:44:28 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84282350f8csm1314806b3a.14.2026.06.02.19.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 19:44:27 -0700 (PDT)
Date: Wed, 3 Jun 2026 02:44:25 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, akpm@linux-foundation.org, 
	linux-mm@kvack.org, skhan@linuxfoundation.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, corbet@lwn.net, dmatlack@google.com, kexec@lists.infradead.org, 
	skhawaja@google.com, graf@amazon.com
Subject: Re: [PATCH v4 07/13] kho: add support for linked-block serialization
Message-ID: <ah-QtVHQpvqqlPT5@plex>
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
 <20260530221938.115978-8-pasha.tatashin@soleen.com>
 <2vxzqzmqfkit.fsf@kernel.org>
 <ah2OeTDFltPWwsik@google.com>
 <2vxzcxy8evuo.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzcxy8evuo.fsf@kernel.org>
X-Rspamd-Queue-Id: 62A7320004
X-Stat-Signature: aj9zie6w5x94u9zo4qwenawh143jufjy
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780454669-675762
X-HE-Meta: U2FsdGVkX1+ODtIDTwbbymfR3MOR0traOgHhK8QGLuYtu6yvGb0VEhoUYAakRo8qqd/8yhQ31jAPYq7Nr5BHuLmc/ulR9/PtCC0VxyKZB147B8qMuDGc9rKKUTQKwJgw/T4JdZVL2L20j7ZecWxcQAWyTUtlFTzMjIA2bM3ZPJkVDKSpinZNWCbjSZ3gwIX57DANufFBgYZ+6Y4YOiwS+Wr/LFH6npireOXvAgEGgALUowqJ4cTcyIZ5C33dTvdP6/UdBTCiW6FUUBbipXwfSGraMMlctWPDDEXgykISWGr5gGpc0882aFhWx4W62wwLgErU08/LbKaeZMSLM19IiYDWPyXc9XSC2K8tOXfcN8FdN+R7p6bnisdmZoRKcLYMuSR4L3hlHwZcW613+GN8bKdI8svPEhX4AgcwlQLhsXhE3McxDZaG3vhI+qvKZyM0szg81/BpbGXQKp5tbgAiX2MZWGAJzHJBd7UoLP8uyJr1Aro1FdLE29E9VlBwBAbQKT6f4XcjyeQVZB9jHf5ob7tW3tNdgH7r53iWVUDPe44vrW/d+Wbgf1QIOrQosIl/UcddOJoKpeVnZ+/Xr3AWCFA5bbhjQpeNbS0ke/AFu3VlMsFqUiLkSVDcXqe+ZUizTML3O+znN7PrMBSdg2pcDeZuuOEiMd1XsSudTq0T3Jb5XITvNlPGFMcnTk+nC4lnq/HGykP+posyBCLv5zUtCS6AGaVOOqwhEzeCZral4MAjjIzRKva6mi1+wzfDn/dzC4l7uTTNarvlxa45HCeizIoSigK8BNKc5fXqXFSFZzKBxB6ypNxMvTqIXyQEBGCwPdIzXxAZo2WZefXxlIURT+59xz28kPOib/JHp4mIvTWyb67Tuqrixs6Jpr3EclRwZoFnbwHCmo9LZG+xleJKJne4rIt5ADM+Z0VPnrTBAS4N0LLUncJQStOMgL8Ol8oEeSP5+dPBU7E9dTKuJyw
 5trPjwjH
 AUr1XJKcfgFppwZdhYXkh/5iCl+iHVNXWNty+SCTtoGO48+1wsCgQ6M0rB+PxbrKNu1jaEpKpjZY8blXBvhFX9X2Ea4v/G4lzRZmvRZKMEoyKPBmXNyg0/5h9c6M2+g97shpMVfeYdVUNOjNHVW4CtTvXNlY6nLsyKd2kqZSyaUnVj3mUDuXqQpljXuzTqPpy0mMM5qQvj8l7lDAi2PUwx3ON6YvJZlNuPfkh093oGuz1RDCYfsU4B69eHvngg6j2hCMiXUJygAjU1VmTwz198Gldwz0j9pMP0Q3EHBFL34zT97qlr0+E5KYDOKvW/FfNIF1DFtWIqWzHf/4mxS2TCCgvD+nyYTtEzUhbVXH9fif2N+P4gb9lQ5issg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06-02 18:43, Pratyush Yadav wrote:
> On Mon, Jun 01 2026, Pasha Tatashin wrote:
> 
> > On 06-01 15:38, Pratyush Yadav wrote:
> >> On Sat, May 30 2026, Pasha Tatashin wrote:
> >> 
> >> > Introduce a linked-block serialization mechanism for state handover.
> >> >
> >> > Previously, LUO used contiguous memory blocks for serializing sessions
> >> > and files, which imposed limits on the total number of items that could
> >> > be preserved across a live update.
> >> >
> >> > This commit adds the infrastructure for a more flexible, block-based
> >> > approach where serialized data is stored in a chain of linked blocks.
> >> > This is a generic KHO serialization block infrastructure that can be
> >> > used by multiple subsystems.
> >> >
> >> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> [...]
> >> > +/**
> >> > + * DOC: KHO Serialization Blocks ABI
> >> > + *
> >> > + * Subsystems using the KHO Serialization Blocks framework rely on the stable
> >> > + * Application Binary Interface defined below to pass serialized state from a
> >> > + * pre-update kernel to a post-update kernel.
> >> > + *
> >> > + * This interface is a contract. Any modification to the structure fields,
> >> > + * compatible strings, or the layout of the `__packed` serialization
> >> > + * structures defined here constitutes a breaking change. Such changes require
> >> > + * incrementing the version number in the `KHO_BLOCK_ABI_COMPATIBLE` string to
> >> > + * prevent a new kernel from misinterpreting data from an old kernel.
> >> > + *
> >> > + * Changes are allowed provided the compatibility version is incremented;
> >> > + * however, backward/forward compatibility is only guaranteed for kernels
> >> > + * supporting the same ABI version.
> >> > + */
> >> > +
> >> > +#ifndef _LINUX_KHO_ABI_BLOCK_H
> >> > +#define _LINUX_KHO_ABI_BLOCK_H
> >> > +
> >> > +#include <asm/page.h>
> >> > +#include <linux/types.h>
> >> > +
> >> > +#define KHO_BLOCK_ABI_COMPATIBLE	"kho-block-v1"
> >> 
> >> During KHO radix development, I argued for a separate compatible for the
> >> radix tree, but at that time, we tied the radix tree to core KHO ABI.
> >> The argument being that all core KHO data structures belong to the KHO
> >> ABI set. I imagine this will be used by kho_vmalloc, so it will also be
> >> end up being used by a core KHO API.
> >> 
> >> So, do we want separate ABI? I don't much have a preference myself, but
> >> I do think the compatible management will be a bit easier if this relied
> >> on KHO compatible, especially once kho_vmalloc starts using it.
> >
> > I prefer to make them fine-grained, now that we are adding more and more 
> > features: kho vmalloc, kho radix, and kho block should all have their 
> > own compatibility strings. Furthermore, any components that depend on 
> > them should include these compatibility strings in their own 
> > compatibility strings, in the same manner I have done in this series.
> 
> Sure, sounds good.
> 
> >
> >> 
> >> > +
> >> > +/**
> >> > + * KHO_BLOCK_SIZE - The size of each serialization block.
> >> > + *
> >> > + * This is defined as PAGE_SIZE. PAGE_SIZE is ABI compliant because live
> >> > + * update between kernels with different page sizes is not supported by KHO.
> >> > + */
> >> > +#define KHO_BLOCK_SIZE			PAGE_SIZE
> >> > +
> >> > +/**
> >> > + * struct kho_block_header_ser - Header for the serialized data block.
> >> > + * @next:  Physical address of the next struct kho_block_header_ser.
> >> > + * @count: The number of entries that immediately follow this header in the
> >> > + *         memory block.
> >> > + *
> >> > + * This structure is located at the beginning of a block of physical memory
> >> > + * preserved across a kexec. It provides the necessary metadata to interpret
> >> > + * the array of entries that follow.
> >> > + */
> >> > +struct kho_block_header_ser {
> >> > +	u64 next;
> >> > +	u64 count;
> >> > +} __packed;
> >> > +
> >> > +#endif /* _LINUX_KHO_ABI_BLOCK_H */
> >> > diff --git a/include/linux/kho_block.h b/include/linux/kho_block.h
> >> > new file mode 100644
> >> > index 000000000000..5e6b87b1befa
> >> > --- /dev/null
> >> > +++ b/include/linux/kho_block.h
> >> > @@ -0,0 +1,79 @@
> >> > +/* SPDX-License-Identifier: GPL-2.0 */
> >> > +/*
> >> > + * Copyright (c) 2026, Google LLC.
> >> > + * Pasha Tatashin <pasha.tatashin@soleen.com>
> >> > + */
> >> > +
> >> > +#ifndef _LINUX_KHO_BLOCK_H
> >> > +#define _LINUX_KHO_BLOCK_H
> >> > +
> >> > +#include <linux/list.h>
> >> > +#include <linux/types.h>
> >> > +#include <linux/kho/abi/block.h>
> >> > +
> >> > +/**
> >> > + * struct kho_block - Internal representation of a serialization block.
> >> > + * @list: List head for linking blocks in memory.
> >> > + * @ser:  Pointer to the serialized header in preserved memory.
> >> > + */
> >> > +struct kho_block {
> >> > +	struct list_head list;
> >> > +	struct kho_block_header_ser *ser;
> >> > +};
> >> > +
> >> > +/**
> >> > + * struct kho_block_set - A set of blocks that belong to the same object.
> >> > + * @blocks:          The list of serialization blocks (struct kho_block).
> >> > + * @nblocks:         The number of allocated serialization blocks.
> >> > + * @head_pa:         Physical address of the first block header.
> >> > + * @entry_size:      The size of each entry in the blocks.
> >> > + * @count_per_block: The maximum number of entries each block can hold.
> >> > + * @incoming:        True if this block set was restored from the previous kernel.
> >> > + */
> >> > +struct kho_block_set {
> >> > +	struct list_head blocks;
> >> > +	long nblocks;
> >> > +	u64 head_pa;
> >> > +	size_t entry_size;
> >> 
> >> I think we should add the entry_size to kho_block_header_ser? I think it
> >> is a part of the ABI of the block set. If this changes, we cannot parse
> >> a block set with a different size. If a subsystem wants to change entry
> >> size, they create a new block set with different entry size, and then
> >> they bump their compatible version.
> >
> > I have considered that, and we can certainly do it; however, I do not 
> > see how it would affect the current implementation. If luo_file or 
> > luo_session change entry_size, they must change the LUO compatibility 
> > version, which would prevent LU from one kernel to the next. However, 
> > for flexibility and future extensibility, I believe it would be useful 
> > to add entry_size and block_size (which is PAGE_SIZE, but could be 
> > larger for some users) to the header. This is more of a feature request 
> > than an issue with the current series.
> 
> My suggestion was mainly for sanity checking. So if LUO or another user
> inadvertently changes entry size, it gets caught. But thinking about it
> more, there are a million other ways to break compatibility while
> keeping the entry size same so perhaps it doesn't matter as much...
> 
> >
> >> 
> >> > +	u64 count_per_block;
> >> > +	bool incoming;
> >> > +};
> >> > +
> >> > +/**
> >> > + * struct kho_block_it - Iterator for serializing entries into blocks.
> >> > + * @bs:         The block set being iterated.
> >> > + * @block:      The current block.
> >> > + * @i:          The current entry index within @block.
> >> > + */
> >> > +struct kho_block_it {
> >> > +	struct kho_block_set *bs;
> >> > +	struct kho_block *block;
> >> > +	u64 i;
> >> > +};
> >> > +
> >> > +/**
> >> > + * KHO_BLOCK_SET_INIT - Initialize a static kho_block_set.
> >> > + * @_name:       Name of the kho_block_set variable.
> >> > + * @_entry_size: The size of each entry in the block set.
> >> > + */
> >> > +#define KHO_BLOCK_SET_INIT(_name, _entry_size) {                        \
> >> > +	.blocks = LIST_HEAD_INIT((_name).blocks),                       \
> >> > +	.entry_size = _entry_size,                                      \
> >> > +}
> >> > +
> >> > +void kho_block_set_init(struct kho_block_set *bs, size_t entry_size);
> >> > +
> >> > +int kho_block_grow(struct kho_block_set *bs, u64 count);
> >> > +void kho_block_shrink(struct kho_block_set *bs, u64 count);
> >> 
> >> These block management functions seem like internal details of the block
> >
> > This is not so. The confusion here is that they must be allocated and 
> > preserved at runtime as resources are registered/unregistered, while 
> > these blocks are only used serialization phase, 
> >
> > These calls are more like notifiers that more files/sessions are created 
> > removed, so we can adjust block count accordingly if necessary (allocate 
> > preserver memory), and have them available durign 
> > serialization/deserialization
> 
> Yeah, I got that when reading the later patches that use these.
> 
> Perhaps kho_block_prealloc() and kho_block_unalloc() is more clear,
> although it does not sound as nice. If not, then I suppose at least add
> a comment explaining the intended usage.

Done

> 
> >
> >> set API. Do we need to export them? I think users should not have to
> >> worry about block management. They should read, set, or clear entries
> >> using the iterators, and internally the block management should take of
> >> allocation or freeing. So here for example, I th
> >
> > something is missing :-)
> 
> I don't remember what I meant to say anymore :-/
> 
> [...]
> >> > +/**
> >> > + * kho_block_set_init - Initialize a block set.
> >> > + * @bs:         The block set to initialize.
> >> > + * @entry_size: The size of each entry in the blocks.
> >> > + */
> >> > +void kho_block_set_init(struct kho_block_set *bs, size_t entry_size)
> >> > +{
> >> > +	*bs = (struct kho_block_set)KHO_BLOCK_SET_INIT(*bs, entry_size);
> >> > +}
> >> > +
> >> > +static inline u64 kho_block_count_per_block(struct kho_block_set *bs)
> >> > +{
> >> > +	if (unlikely(!bs->count_per_block)) {
> >> > +		bs->count_per_block = (KHO_BLOCK_SIZE -
> >> > +				       sizeof(struct kho_block_header_ser)) /
> >> > +				      bs->entry_size;
> >> > +		WARN_ON(!bs->count_per_block);
> >> > +	}
> >> > +	return bs->count_per_block;
> >> > +}
> >> 
> >> This looks odd. I don't see a reason to calculate this lazily. Why not
> >> just do it when initializing the block set, in kho_block_set_init() or
> >> kho_block_restore()? And then use bs->count_per_block directly.
> >
> > This allows for blocks to use static initilziation, I like static inits 
> > :-)
> 
> You can do this:
> 
> #define KHO_BLOCK_SET_INIT(_name, _entry_size) {                        \
> 	.blocks = LIST_HEAD_INIT((_name).blocks),                       \
> 	.entry_size = _entry_size,                                      \
> 	.count_per_block = (KHO_BLOCK_SIZE - sizeof(struct kho_block_header_ser)) / (_entry_size), \
> }
> 
> Compiles for me.

You are correct, done.

> 
> [...]
> >> > +void kho_block_destroy(struct kho_block_set *bs)
> >> > +{
> >> > +	u64 head_pa = bs->head_pa;
> >> > +	struct kho_block *block;
> >> > +
> >> > +	while (!list_empty(&bs->blocks)) {
> >> > +		block = list_first_entry(&bs->blocks, struct kho_block, list);
> >> > +		list_del(&block->list);
> >> > +		kfree(block);
> >> > +	}
> >> 
> >> Nit:
> >> 
> >> 	list_for_each_entry_safe(block, tmp, &bs->blocks, list) {
> >> 		list_del(&block->list);
> >> 		kfree(block);
> >> 	}
> >> 
> >> is a bit more idiomatic (and IMO easier to read).
> >
> > Sure
> >
> >> 
> >> > +	bs->nblocks = 0;
> >> > +	bs->head_pa = 0;
> >> > +
> >> > +	while (head_pa) {
> >> > +		struct kho_block_header_ser *ser = phys_to_virt(head_pa);
> >> > +
> >> > +		head_pa = ser->next;
> >> > +		kho_block_free_ser(bs, ser);
> >> 
> >> Nit: also, can't you put this also in the previous loop? Something like:
> >> 
> >> 	list_for_each_entry_safe(block, tmp, &bs->blocks, list) {
> >> 		list_del(&block->list);
> >> 		kho_block_free_ser(block->ser);
> >> 		kfree(block);
> >> 	}
> >
> > We actually can't merge these into a single loop because of partial 
> > restoration failures handling in kho_block_restore().
> >
> > If kho_block_restore fails halfway through restoring a chain of blocks 
> > (for example, if kho_block_add fails on block 3 of 5), we jump to the 
> > err_destroy cleanup path which calls kho_block_destroy().
> >
> > At this point:
> > - bs->blocks only contains the tracked blocks we successfully added 
> >   (blocks 1 and 2).
> > - bs->head_pa still points to the physical head of the entire 5-block 
> >   incoming chain.
> >
> > But, this is a good place to add a comment.
> 
> IMO it would be cleaner for kho_block_destroy() to destroy the currently
> initialized block set, and then the error handling path in restore path
> can clean up the rest.

Sounds good, done.

> 
> >
> >> > +	}
> >> > +}
> [...]
> >> > +/**
> >> > + * kho_block_it_prev - Return the previous entry slot in the block set.
> >> > + * @it: The block iterator.
> >> > + *
> >> > + * If the current index is at the start of a block, it automatically moves to
> >> > + * the end of the previous block.
> >> > + *
> >> > + * Return: A pointer to the previous entry slot, or NULL if at the very
> >> > + * beginning of the block set.
> >> > + */
> >> > +void *kho_block_it_prev(struct kho_block_it *it)
> >> > +{
> >> > +	if (!it->block)
> >> > +		return NULL;
> >> > +
> >> > +	if (it->i == 0) {
> >> > +		if (list_is_first(&it->block->list, &it->bs->blocks))
> >> > +			return NULL;
> >> > +		it->block = list_prev_entry(it->block, list);
> >> > +		it->i = kho_block_count_per_block(it->bs);
> >> > +	}
> >> > +
> >> > +	return (void *)(it->block->ser + 1) + (--it->i * it->bs->entry_size);
> >> > +}
> >> > +
> >> > +/**
> >> > + * kho_block_it_finalize - Finalize the current block by setting its entry count.
> >> > + * @it: The block iterator.
> >> > + */
> >> > +void kho_block_it_finalize(struct kho_block_it *it)
> >> > +{
> >> > +	if (it->block)
> >> > +		it->block->ser->count = it->i;
> >> > +}
> >> 
> >> Doesn't kho_block_it_next() already do this when you add an entry? So
> >> this seems redundant.
> >
> > It is not redundant because of how the final partially-fille block is handled.
> >
> > kho_block_it_next() only writes the count into the block header when a block is completely full and it is advancing to the next one:
> >
> > if (it->i == kho_block_count_per_block(it->bs)) {
> >     it->block->ser->count = it->i;
> >     ...
> >
> > But for the very last block in the set, it is usually only partially
> > filled (e.g., we write 10 entries into a block with a capacity of 64).
> > Since it->i never reaches the maximum capacity, kho_block_it_next()
> > never commits its count.
> >
> > Pasha
> 
> I think we can make kho_block_it_next() always write it. I think it
> makes sense from an API point of view, since I see this API as "adding
> an entry to the block set", so updating its internal counters makes
> sense.
> 
> Requiring the finalize will be error prone, since it is easy to forget.
> Then you silently lose some entries on the next boot.

Good suggetion, cleaned-up.

Thank you!

Pasha

> 
> -- 
> Regards,
> Pratyush Yadav

