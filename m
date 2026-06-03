Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDB0ACD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 13:21:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F12CA6B0095; Wed,  3 Jun 2026 09:21:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE9DD6B0096; Wed,  3 Jun 2026 09:21:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E26C76B0098; Wed,  3 Jun 2026 09:21:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D4B9A6B0095
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:21:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7721A1C08D8
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:21:29 +0000 (UTC)
X-FDA: 84838663098.13.949E0D1
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9DE2B40013
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:21:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kciVZR5q;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780492887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EYzLxXCyFp78st9iZvxHkpqPKyf62haaChBN9xQvBYM=;
	b=Ku5wGcCCXx63ov/USzrQxucWraKQCOzLq+F/AvK+9HWokMBI3eeRkMjWRn53CJcPvyR2CP
	vVjQyUBiNYjpqvKL47IcrFIpbeuMdncGPzj4x+KYySuMBCdF0yljx8s1zmCvgZLJRid48A
	2RZ4N2Q3XL+5pyaKgwFh/PuyY3Qp908=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kciVZR5q;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780492887;
	b=aq/mEiiviSi4tYH7yUWJ9OA2Cs3zTYbektZ64ETDZgAurOhjHA5qsIijBgJqJ7r7Anl4Tx
	ePOFwFaFjGSBumCJz8oxV6LhGR07pp9JDa2lEk/vem9YszYmQR8GZKIU6vjfJxVyTGQOHl
	uyleaZEGAgkheVwePtFkWbHcb6OYu4I=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-9155183b42cso87073785a.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 06:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780492887; x=1781097687; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EYzLxXCyFp78st9iZvxHkpqPKyf62haaChBN9xQvBYM=;
        b=kciVZR5qmULZW+20jDvoADHWxXhu0m1JpYaw+9d2Q++FrnwseA9u2sNl501tEQImJX
         LcHkxWjfLKQmeBg1pUkpsTOOgu0hAykLCHygWXaxgi1b3X6HBSveF2nP81iiuRJlgi9x
         cznszqdbx8vgW4hHDxYuAg9md7PVSH65HgWnuKdwlVx6Fv+IX8oq8qyTwGnKbT3B2Jur
         P3C+PP3flHEa38Q850BuF9CxAcd/2tZc2CGbMU9ELQk66aBeOOcA11mfm2IfNTceT8SI
         qeZ0A0WXJMB0eslU8KzJELA0aMADPli3vp6kTxGRcnGglVqcADFmLkEFvMtDP+eUSG9X
         FScg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780492887; x=1781097687;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EYzLxXCyFp78st9iZvxHkpqPKyf62haaChBN9xQvBYM=;
        b=K8yBmDqWbneKMAOvsHLIA9ME63HWNmXnskjsR2/3R6En5yrNoq4x0skPIKgHTe2F1L
         Qq2ef/PO/wc6j+Q3IPlPSta8Lu9Dki475WsJHpLLhTvYdBK/7m4HtQoFMirhYbGzGTkw
         2wc4BB2jRaHEjBL42kHRXpZEo0cvASL9XJQjZlMMdYOboVYOkAp5TQJg/2TdzsktRbfl
         r9kV5VJM02hQ1jrAol9XhQX5fHgfmOqNdINUOXw2+duquXUelOHVr9I7JHL9kWfyBKRE
         rTWerDXJkjhS2x1L+IlB8bBQZ6+zfF+6eKHCgT3ZmmL1gf6gn8eAJ6yc2hlHpHjkqB3R
         y1hA==
X-Forwarded-Encrypted: i=1; AFNElJ/y13e8sUkM+Kf2fln/gB6CuU27UR1s5l0R9WKu4sv21gAsDBfmgzl6k/7tHW1dNxZ+GJuadP9Ghw==@kvack.org
X-Gm-Message-State: AOJu0YzicpRmF2f9TAByPrpbrLFsUS+XU5ygqumRVrtPeyCghL3PdJZM
	jTzNNtN5L6NUp1pQwN0Z78NrbrbkaOy32FpXHk4hOkvf+LKMVu1J4mXpiT2YsAVZlQ4=
X-Gm-Gg: Acq92OG8MEceh3MGAG7RIihhDjbwxg1VhcNJPxU0e+VJ4H3KUxfNfYc6D5v+92f5gzY
	x0EJk+XmIOyD/Nslz3BJTBonyjg1kivI1z4H8Sw2zObYtektxU/dFMnPdleV55TH7Ya0H6t3I80
	PqhJLox/yxhnwqw68+fV6kB5ttaAo8n5MKhhMDfxTTqKJV5+TU35A7T7pG6CW0MwJtIJBzwbeGB
	Ez4mrfRoLEPXrjmib27e8Ck6u/62e9BR7dEwr2e+tnAqjhwg13p9T5tm0YaYI+2/uGy1lyvDXI4
	gCD071oVuCd4yXfkpcjrSUJzlvvlvvuNL/orhlejyVDsirf16nfG0EbbZVCRd9FAM83F66ioA1Y
	UPWYmALscqHvsL76Lxq2yRepFKi+ock1OfBVw0oQxmP0sawsCv+GVQJ1csoP3mHa9BPfXcgs1Pq
	ajDVrdmAd9pMpErnEz2zqgbA89Cl5O55khYl7dt8swkAE9Ik0T3M7WPgUCHNhXGA==
X-Received: by 2002:a05:620a:414a:b0:8ef:6b87:5c52 with SMTP id af79cd13be357-9158b76c157mr410625285a.38.1780492886503;
        Wed, 03 Jun 2026 06:21:26 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a37cae4sm240219185a.29.2026.06.03.06.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 06:21:26 -0700 (PDT)
Date: Wed, 3 Jun 2026 13:21:24 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	linux-kselftest@vger.kernel.org, shuah@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	corbet@lwn.net, dmatlack@google.com, kexec@lists.infradead.org, 
	pratyush@kernel.org, skhawaja@google.com, graf@amazon.com
Subject: Re: [PATCH v6 07/13] kho: add support for linked-block serialization
Message-ID: <aiAqOaA_J4PrIoow@plex>
References: <20260603032905.344462-1-pasha.tatashin@soleen.com>
 <20260603032905.344462-8-pasha.tatashin@soleen.com>
 <178046937151.468621.13398573538792303093.b4-review@b4>
 <aiANtYRRDr5iO5QR@plex>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiANtYRRDr5iO5QR@plex>
X-Rspamd-Queue-Id: 9DE2B40013
X-Rspam-User: 
X-Stat-Signature: 86cxomarau9h3psm7dd68re7s4gi6xww
X-Rspamd-Server: rspam09
X-HE-Tag: 1780492887-528701
X-HE-Meta: U2FsdGVkX1+x2Q2lsHlSBrQQrOsS49Kiv6ffg5Igz0pJsmtq6U7czAQOhNAKe8WQlPvnwzbIL54xfY8PPitWj5eEO2kW8zI/W+c7Nfp5e27NkkJfdmrw2PxhNTh1bSZ1E9cc4uy5XJJJzWX5JF+ryUglgJkhhAkSEzs/irjD+0Zvq+VawuojtMtUsJ9MSqqgHncBmx+3VCbwKPqDM5VsXjykgpMqtYeuIiP8Z5Uc+k9YwiiAF+qtuxxEB8HyovwLUNM5FXONMTWJQWOIHgASZPq/JvncAeLFgFPQ2/FVBA1qs83zY3P6MxXzCvN8SI0nQn6zeSn6/enXg81MfWtEzWSV3nHmv8jDc1RPS8vPNwgkNmlY6m4yxSiLSGnhh3b3advXkItMDSCdmm3TJKeKBZZCRrWVYohp5/gTq2scb4+ZkTv09vnFfA1KOS3ZgSEx306Fz2WmxTJ9WN31+WRzCYDMGXjBSU4+j1JQ5Dl0QQs+4Gtz/zjP9lzidJ35aznNkpjVk8FWUoOVfKaaUM6L8uygqwYwIz+w5UHmrIoSSKq6NkOCtkDyly4woZO4vfCKuc2X6WNrT8UET0pX3dSdkDio1qlv2QJ9nkipeO1DOZwD6AV2GRC4wD2rbOlgIK7For7YkLOHF2KwBIhbVzj4dmINu/8C3+jQuJmj1ZA4odqK25x1HB1+/FteasIRaRlFKl+aNM+286bUc68LgyLP4RwZvoAR1+txw6Va4BRgHuSv4Bknz9LqjGtxiLdJySASeYNh33B5T1mV8fTQ5uPpyacxgKK40pXPxav8F0KYRjyyHT1Tohu7L/mOnLABm2gtg89GTFoBB7YVNRPYeEo1mizwMzOPsJ93F0jDGRzLxzm888LE3ZPzn3vbsjCjVOpRZhXUBZCrNAMpt82u8Lh7shcM8CLY/O0/XUolY3LwVhBqfjJiUI1VimjN2FFWyyFZEf3tRJmxpYYSY1KZfiT
 RoSb3ptb
 RMgzLuNvzNQA1XW9CD+a/BcIfPFodoVSrOzKD2Rt8KGB1D4UU9RG4p7WwSS+IbHywix8v0OHZCN652rOM4u5xxbrEKKrNJH4aUK5o5OzcdXo/U7onXSH/t2Xsjw9m78lH5zFxvgPPbbcemRpvv4evmc/M0M+VT7JeSa1wkB30+1D89xh7NuOovBVWdzwnHYPBvFcA3NpBH5ywIuJVKbwO5qfIbob4/nCMRDc4Ry4a7NBGhUfhKxR+BnT21P9n8upgS9ZzAbojnogttsDRUAX7YzxtOy+Qr5/tZyXu0+YfKveXgFwa0iiHZBaaX1hpKEpxvHtjS+MdKzpAHqeET9gIvqwddg5mAKLttoYK7l5g/iB7XIfZJ6u9YkPYNsO4T7DAANbW4580IFx+KkJ9tSFrwI0BAMngy05e35MJuBqmqtvJ/sAXPNZY7xe7ITGXgOtnR+ToXssNduovYpt0jNMwhjjo+wkCACANmdAWRyvSXvx07RY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06-03 12:05, Pasha Tatashin wrote:
> On 06-03 09:49, Mike Rapoport wrote:
> > On Wed, 03 Jun 2026 03:28:58 +0000, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> > > diff --git a/include/linux/kho/abi/block.h b/include/linux/kho/abi/block.h
> > > new file mode 100644
> > > index 000000000000..8641c20b379b
> > > --- /dev/null
> > > +++ b/include/linux/kho/abi/block.h
> > > @@ -0,0 +1,56 @@
> > > [ ... skip 25 lines ... ]
> > > +#define _LINUX_KHO_ABI_BLOCK_H
> > > +
> > > +#include <asm/page.h>
> > > +#include <linux/types.h>
> > > +
> > > +#define KHO_BLOCK_ABI_COMPATIBLE	"kho-block-v1"
> > 
> > It's never used by block set and after looking at the following patches I
> > found that it's appended to LUO compatible string.
> > 
> > While this works for LUO, I think it should be kho_block_set_restore()
> > responsibility to verify the compatibility.
> 
> It should work for any component that relies on  kho_block. My proposal 
> is to use this method for other common KHO data structures (e.g.,  kho 
> vmalloc,  kho radix, future kho xarray). There is no need for them to 
> carry the compatibility string in their metadata, as whoever uses them 
> will include their compatibility string.
> 
> For now, reviewers will have to make sure that if the ABI header content 
> is changed, the compatibility string is updated.
> 
> > > diff --git a/kernel/liveupdate/kho_block.c b/kernel/liveupdate/kho_block.c
> > > new file mode 100644
> > > index 000000000000..4f147c308e6b
> > > --- /dev/null
> > > +++ b/kernel/liveupdate/kho_block.c
> > > @@ -0,0 +1,411 @@
> > > [ ... skip 121 lines ... ]
> > > +/**
> > > + * kho_block_set_grow - Expand the block set to accommodate the target count.
> > > + * @bs:    The block set.
> > > + * @count: The target number of valid entries to accommodate.
> > > + *
> > > + * Acts as a runtime notifier when new resources (such as files or sessions)
> > 
> > Not sure I understand what "runtime notifier" means in this context.
> 
> It came from discussion with Pratyush, but I think we are on the same 
> page what they are, and I will just remove this.
> 
> > 
> > > [ ... skip 11 lines ... ]
> > > +
> > > +	while (count > bs->nblocks * bs->count_per_block) {
> > > +		int err = kho_block_set_grow_one(bs);
> > > +
> > > +		if (err)
> > > +			return err;
> > 
> > This leaks memory if more than one block is added.
> > 
> > > [ ... skip 31 lines ... ]
> > > + * unregistered, allowing the block set to release and unallocate redundant
> > > + * preserved memory blocks. Checks if the last block in the set can be removed
> > > + * because the remaining entry count is fully accommodated by the preceding blocks.
> > > + *
> > > + * Note: It is the caller's responsibility to ensure that entries are removed
> > > + * in LIFO (last-in, first-out) order (the reverse order of their insertion).
> > 
> > I think "in LIFO order" is sufficient :)
> 
> Oh, I keep removing those :-)
> 
> > > [ ... skip 173 lines ... ]
> > > +		it->i = 0;
> > > +	}
> > > +
> > > +	entry = kho_block_entry(it, it->i++);
> > > +	it->block->ser->count = it->i;
> > > +	return entry;
> > 
> > This looks way better than the previous version :)
> > Thanks!
> 
> Thank you. I will send a new version of this patch as a reply to this 
> email to avoid cluttering the mailing list.

The patch is here:
https://lore.kernel.org/all/20260603130612.397948-1-pasha.tatashin@soleen.com/

I messed up in-reply-to field with wrong message-id.

Pasha

> 
> Pasha
> 
> > 
> > -- 
> > Sincerely yours,
> > Mike.
> > 

