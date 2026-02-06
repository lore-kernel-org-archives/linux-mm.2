Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C676EE20A6
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 15:53:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58DA16B0089; Fri,  6 Feb 2026 10:53:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 565676B0092; Fri,  6 Feb 2026 10:53:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 464876B0093; Fri,  6 Feb 2026 10:53:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 323ED6B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:53:17 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D0AF256215
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 15:53:16 +0000 (UTC)
X-FDA: 84414475992.04.C81DFEE
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id EE9851C000E
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 15:53:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SpArwTnr;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770393195; a=rsa-sha256;
	cv=none;
	b=M6vcY/XKIGwKY/CIlEK0U7b9h4BTUSvRcK+GposwsnN1qGEl55wN+HfeQvczBJMMrFqbtT
	vf+LDNdDxufqe1BgH9TZrYNFTmasjDvEyZ3SfrcC90qdfDiMxVQ+OkaEPuqtVQLORoL+sN
	Sje8m2g7J09zk83bXHTac5KKC/EC7Ag=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SpArwTnr;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770393195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7podOaUCjU/O3I21k18RXk2UZLq1mKBY8Ro47wlihIQ=;
	b=DkxrnLOZ67qLQzUnd6BHKk6VUGwe4jUX2g+Gc7ddpStu3iCgvqj6oCzMF8HecLCfs3WFWp
	NsPprPq3FEUIv3k11XPvKyIrXBOqUe8n0LBW/VdCeBlOKWRwtBcYmaHIDtUeFz+NR1UkL6
	Qjup/12sJprasyzFl1ApmEDJukZmNww=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8c5384ee23fso95154285a.1
        for <linux-mm@kvack.org>; Fri, 06 Feb 2026 07:53:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1770393194; x=1770997994; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7podOaUCjU/O3I21k18RXk2UZLq1mKBY8Ro47wlihIQ=;
        b=SpArwTnrnkHLtzzIIMeh7W0SEXmPaPBKumE0wFzl4YIG66vNUhTG2Ca3ZMZe//lcdD
         T6xYB+lgQYl+ylS/Fo9rkDfC3NPmT9/MxDBpmkGy/HLC/Q0YlrAhTAf2ue32SXqAVNGv
         v3y4+qs4azTU6hkIfg5lm6QUY/TRWo2tf60gkJdgVl0+j9PAB6R31hTZu4zfhrThDHls
         xWi7BIKyIxxOB7/2CurJn4yuRrQ23YhfzOHFDuhtCmg9QU8548wLNNxuij9ASMZpuvTb
         fXYSP9e04JYJT1eN1b7TydpsK9M+SEE74ki725g/Mo89SuxDo3CXdcWvKtP3TFaL4MF/
         lIlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770393194; x=1770997994;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7podOaUCjU/O3I21k18RXk2UZLq1mKBY8Ro47wlihIQ=;
        b=oYYIL3ccd1VCfbazQb64cVzsfF4IQE5V4+QkL4qO+KyorBXrdYfMeX9tLTUxVWazQx
         bkzGhx71DN/XV0DL5gs4LnWaEWefzEiObjusWUb8Kax/yFCYelCIkR6cyxHsZrRkqB5w
         +aN5nAF/c7hgLgNF1PKyEIz0YI5MAqMKk+6XGZGb75Tj6KpdSwdxyG8iip46KeMhHj3C
         ZqDJRBnSPmFTPMgIALsOoewUynsW7qBZj07uBqtaX38iJg/71feQ+Cw0rjEUC+7/hGBK
         Tetipq8JLoP3oYni+tMFvydBe2wsyPa3jzcmzBgl0nlyx9kMEK+AY7WBbSGMNf0ioVLQ
         d1Fg==
X-Forwarded-Encrypted: i=1; AJvYcCXSbYmjqNzbwl3POjTdrFXtqb7+Zx3GKV9MMWYwdjLHQlLtjfC/djouIuOZKttAm9Etqqw98gJccA==@kvack.org
X-Gm-Message-State: AOJu0YxHDTY19qmOXepYOpkaxcZR/d7HMmgOfs6UIL7f6JGDB6lw35D5
	o6/cLEDlxrrdGTAyF3avxo45GgXDWL5UpyGp95j5p1+89ZvLD+y+76DobBiD8KjPhlk=
X-Gm-Gg: AZuq6aLdGHrSJDCB/McfUTOK46yo1kQwOcsltGdXul0flbmcxDFkm9ACWHJS6DYIUcz
	wlg14ms1qEmJVE7UUV5XNAmMTFibpBa9XEzOQoLBPiyAdFLLmsygcUfwL0xfkzZo0akXuKGF0aR
	708qX+L87MRmbhjucmvIP8ubmuIhPB5cyPtamlvhzEeCyBsAtIYTluDyU6S2da8zwdWRxudLrm8
	Ad4pMT2YZKZ5zwSPf1iYd0MS3Y9WuSrChyAZIKqkb7/iKvw/nS1rpRwy+0e6IAVHRUlillBl3BN
	mPbWVL5fOIauhwQhlDod7YH9L6nSKXBAaXnWW8xP+Va1Bdqu47fDWYJ17M6e9SWfrSrtqN4EDo5
	8B3wB/vv6dMF/+ivlU5oxuN2Ace10IkxVeaNqZvhUkA0FfP2lCTwygWqx2AwzTP+8Ff7d6zAMNo
	4g6YOk9m0UWc2el+4YMDDrlM9ZJZo/yJvqSplkJS8/hckE1WRnfTEgez7MIL2A7maPWKNB7y2Or
	LF2Woy3AQ==
X-Received: by 2002:a05:620a:44cf:b0:8c6:a1d5:47e1 with SMTP id af79cd13be357-8caeeb4e117mr380491485a.9.1770393193829;
        Fri, 06 Feb 2026 07:53:13 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8caf9fdf739sm176815485a.41.2026.02.06.07.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 07:53:13 -0800 (PST)
Date: Fri, 6 Feb 2026 10:53:11 -0500
From: Gregory Price <gourry@gourry.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Cui Chao <cuichao1753@phytium.com.cn>, dan.j.williams@intel.com,
	Mike Rapoport <rppt@kernel.org>,
	Wang Yinfeng <wangyinfeng@phytium.com.cn>,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, qemu-devel@nongnu.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH v2 1/1] mm: numa_memblks: Identify the accurate NUMA ID
 of CFMW
Message-ID: <aYYOZ1TK5dpX_h_Q@gourry-fedora-PF4VCD3F>
References: <20260115101858.85fd7b8e837c1c92a4fdc5f0@linux-foundation.org>
 <696944eca1837_34d2a10056@dwillia2-mobl4.notmuch>
 <2d1e23ad-7ec1-483b-88b3-70ce19b69106@phytium.com.cn>
 <aXOl9CN_66HywIjZ@gourry-fedora-PF4VCD3F>
 <a90bc6f2-105c-4ffc-99d9-4fa5eaa79c45@phytium.com.cn>
 <20260205145842.efb90572a902ae4c481e6ef6@linux-foundation.org>
 <aYUjf0OrD8f_bJCy@gourry-fedora-PF4VCD3F>
 <20260206110305.00001fbb@huawei.com>
 <aYXtHa4Y2y_5xgcS@gourry-fedora-PF4VCD3F>
 <20260206150941.000028ae@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206150941.000028ae@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EE9851C000E
X-Stat-Signature: jbig4hpubk4aq7fmmtzz795okbu4xqkr
X-HE-Tag: 1770393194-117715
X-HE-Meta: U2FsdGVkX1/5uuTDsVOu4ZbIqk1ueHsMDdpb3VI4OiZuzaFthfGkSEj3EoXWjke99Io0xoHaNtOtw6XfFLNEUZLd8FCg9ISr2GrCdIl7XJwTDumoraKnGYP+WyO7gVMODv9ZB5VBqjL/bv5iE6YFMhY4sGNqos5U4SSKro+ZQ5yRkD0MPDvBJZv2yOCuLFB+VaxdoyBdJk4hzVpAXmMw1y7/HOwv+kK3WphzQHOtAPkoIYs4mjLDtyF2GBCoh13Jx/lfEVoTmP4Tt+CDnBE4bwg5DXJWoD68FwuVtV5+KIyT8mm6K95EmJCCnFYUNadYXJyIfZJQAApRdO5LKXX7xz/9HX3vFcaslCuuYmFGg5DnmRC4AyylYCDJ9z88P3+LUPUYlNGSobJmRQ3WFkJdmuFZNc6sDrnxAAth0aHfrFzQC53Mg+qBaMRKPOLiI0Dz2MnLw0raoHaoE6UyrfAUR1O3n1WJmZ3NDxOMXcsalwXJVJ3Mh7FJrh5mASlrnlki/f5gN0BZ/99jbOJUL3K3qxQCs4bBqQYJPHQeZ35NR2w9axlWA68HsufNdMGCH87WLOGzzhO27jUGHMdteEW3XE+5i/rmZezqhhSWc4MHCU9dR8TOCYNtxWK9UIpw1JUdyQfgcXSHwRf5pOpDtjb2dHtSb2ILkaWnQguqpWVgttW2hMnjHjBSne+CdI5pbvjCi0+MiMupNOAbCECpkZwodPIP9Yp/FiFAEPiupFnsLszqZpXIBGKk45nRHlLssoDF4Oz2RaL+P6LLlMSnh2w4MGqHw7Z5RTcp6MhsAi2doMz6kzj/qop2Scjtq+q8jOqQVxyNrLJe2gYbr9PMBgWmE8eBXxrB7utDmaWzatQ+5gSQyyc+COlR90cM/8mb5R+cxGL5iySaHQpikNr8vmfKmfLuIF8vVvXGJVShwMvUup8QvaQ1OEX7/XZHCOd7kcY39NlfnWQjEMzJZmvav19
 FzdNbIkc
 NY6IefrQQUaclZb/seVgCp0euAraUAKetWWrY0S3b9HKUmuXhGN7AlS8h7i9K/tT21Y21nnlscXBErX+z1VI4hGe4jaaoCBj7ntV760DYHjGe0nU7jDI083GswnNqEZfXsro9REwa1zOiIn/1MR60flB3Ikvrk/EWdcjbVCQ9/FEf8aQt7zcbTKxeWBAnCgli91sn1yW36GW9gICD2tkPBpIGVoDATVhxKAVzod9m3lFpjIHS2bwLFjgGUTK0xE9rAZ8mYajqyl69Ci9UsMHzCgLjtc26vmbaURmdfz++G0qMg3jpRSswIxNQL1N7uV1rFTc6jGFKPFyE/h51tkkCp1CpxmCcjMTdtDOyb+ctjIwbLl/tM4CQ8KrbROfYoUywX7M9lykd3tqzAe8GBszvNJG6tsYXsa5n5zT0/NlRvQoE15IlS9Ag2yqo5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 03:09:41PM +0000, Jonathan Cameron wrote:
> On Fri, 6 Feb 2026 08:31:09 -0500
> Gregory Price <gourry@gourry.net> wrote:
> 
> Now a fun corner is that a node isn't created unless there is something
> in it - the whole SRAT is the source of truth for what nodes exist
> - so we need 'something' in it - a cpu will do, or a GI, probably a GP.
> Otherwise memory ends up in node0.  However, fallback lists etc happen
> as normal when first mem in a node is added.
> 
...
> For now I 'suspect' we could hack things to provide lots of waiting numa nodes
> and merrily assign HPA into them as we like whatever SRAT provides
> in the way of 'hints' :) 
> 

look at ACPI MSCT - "Maximum Proximity Domain Information Structure" ;]

I don't remember reading anything in the ACPI spec that says something
has to be ON any of these PXMs for it to be accounted for in the MSCT.

Platforms can just say "Reserve that many Nodes".

(Linux does not read this value, and on my existing systems, this number
always reflects the number of actually present PXMs)

---

We probably want to ignore that and just add this:

CONFIG_ACPI_NUMA_NODES_PER_CFMWS
    int
    range 1 4
    help
        This option determines the number of NUMA nodes that will be
	added for each CEDT CFMWS entry.

	By default ACPI reserves 1 per unique PXM entry in the SRAT,
	or 1 for a CXL Fixed Memory Window without SRAT mappings.

	This will reserve up to N nodes per CEDT entry, even if that
	CEDT has one or more SRAT entries.

then in the acpi/numa/srat.c code that parses srat/cedt, just track
the number of nodes over a CEDT range.

for each srat:
   account_unique_pxm(pxm, srat_range)

for each cedt:
   nr_nodes = unique_pxms(cedt_range)
   while (nr_nodes < CONFIG_ACPI_NUMA_NODES_PER_CFMWS)
      node = acpi_map_pxm_to_node(*fake_pxm++);
      if (node == NUMA_NO_NODE):
      	err("Unable to reserve additional nodes for CXL windows")
	break;
      node_set(node, numa_nodes_parsed);
      nr_nodes++

This should fall out cleanly.

The additional nodes won't be associated with anything, but could be
used for hotplug - I imagine.

~Gregory

