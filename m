Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 267CBD3942A
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 13:49:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EF326B008A; Thu,  2 Apr 2026 09:49:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C6486B008C; Thu,  2 Apr 2026 09:49:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DC116B0092; Thu,  2 Apr 2026 09:49:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6C3686B008A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 09:49:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 12E228C35E
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:49:01 +0000 (UTC)
X-FDA: 84613746882.12.9CAB854
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf28.hostedemail.com (Postfix) with ESMTP id 13DDBC000D
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:48:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cYETwehI;
	spf=pass (imf28.hostedemail.com: domain of elver@google.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775137739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4odl4u5FIkYFl0AjuN4ex6RSgkq9844Lzudav/PrauU=;
	b=5RIpWPHcXck/SvbDh8SdyHRhfWL4EPuGUdLCcwxa9yY9Vi5b8TJEFXtoFcPZWzLOnEYCBA
	+UvJLsmCny+qqS/vpLdSBPwuiNWI1mQ7MoW3Zd2oB3KOFHbjmToI6bPskswms7APalJ4G/
	aiRBDNhGWqVS5mUU7KwLjD1DpEKS5Js=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cYETwehI;
	spf=pass (imf28.hostedemail.com: domain of elver@google.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775137739; a=rsa-sha256;
	cv=pass;
	b=u+4TrKAFnVV0poUmO7L49LUeQf4g3+EZNRxg9GD00ydqBY43KzBptTJEK1Y/vXNIhBhkVZ
	PfSFjMyYd14nb+MmkHPML8C48q8EoxUmBQGX6S52lxCGArEPJkZFN0lJSROwyanOmOPKSH
	KIBz2SJajVhUsv1tmwd/kidLh25sb+Y=
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-127380532eeso2564609c88.1
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 06:48:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775137738; cv=none;
        d=google.com; s=arc-20240605;
        b=HCuSyHyPNs8gmTNmYiRIRoklASLkPoAG891+AQz5O4ANSN1eAEV2CYdfvkPeP0dlMp
         NoxpwEY9JQ4ApeeLv5MITon0nACa9bzk5R2VRTYw6tOr5+XK3nhcroIHk4VFNtxRi6dg
         pRXxtn3/iVW7XMztFvHcsGXktk6BoGWw2XLHm0XHOTddH6E0LGI8N7qwMty/9NHqBtW9
         ML9CrCjJp7YYIZKT+aYRESxcOK362Ba7wxsETcbx43wiDmdqgxqkd/scpMIe0AdlU7iX
         EzL+AJWrO3p5lX9divYrN9AwkqlerZTRUavzYVzBb5/cXTxbe6V4H6W4992Pl6WgDvlL
         jKnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=4odl4u5FIkYFl0AjuN4ex6RSgkq9844Lzudav/PrauU=;
        fh=e1zajWDP5u3VDnh5ShDZKDMIArEc/FI9uWsOxsXljkY=;
        b=RiGqe7uydZsYmG84j6kzIURYlztN9C4pv0lwTiIr83TczJpGyhmgx1NyHABorUhlJX
         pZuF5kzqmqhAPC4774jIvqROspfxqQOsDFEBycwoyKlT6Qp3EYlvnB8dCYjUeHxXZfFg
         BSvgdPBSSn6pSmGKwl177XRgN1sOndQfq/sBFaPIgu85YucTzP0Px2qFwnMPDrIv83kS
         vxhBWJZLdmAgk2TuQle/DI5xYWR0mdeYEx/2pYJAllr3C/vvDa0zwTONAZwM0iTfBQfF
         ZP5Zd1m41zc8mhrhtzb90IdhQglIdYVqXbZyprCKXWNY8jNbVs488gCSadpaGhmQSMwI
         Z3Yw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775137738; x=1775742538; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4odl4u5FIkYFl0AjuN4ex6RSgkq9844Lzudav/PrauU=;
        b=cYETwehIK8zKpPIt+/Y+HduuRCgRFWqlLgdyOqtRM+QIbGqO+B0RDBoTWjMrjIcjfy
         80gH2Dw/HURasMxcWXczcLhQhdElSXybHnotMyAykHR9aZiMTY+KF+PxdEB2Qc4wux8B
         2bG5I19NUOWLnu/wViN33ecDhKlFHD6D0LGhLpcPxNUwfLN/TRKMLau+ShPSoPY8x4Rv
         s/wCcXKLHtAZt4eKkwGR+YkEV30/eettgeo/Z33vmFWxoG5mnhaEc/NqBd0VuXVW2+0k
         w6stOr6VtecnNUzfVIC6v/G4NePU+z1l9xlJ5hO5SXtsHbpCSQwoGaWcqlCHC7nTUj9h
         yWUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775137738; x=1775742538;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4odl4u5FIkYFl0AjuN4ex6RSgkq9844Lzudav/PrauU=;
        b=KeeTHtBScNNeTAvEsP1jppLnUu/z369I1VTv8YdODV3hjaWch4S6CoI/Y5Tg9lGXtY
         Qd9bOrpYfNY3y4O70vKI9tiL/5UbCCXmoCwVzRcJDqtkz4HAnMxWmZQjbE4VcBZg4P1o
         VK2TvWIOIbHJSyL7v4yBuogDY+CJxARgRt0fGG2LSaV5YhxwcAXpevWdluQReCH6KP6s
         iT8xKLNEyJBHYT+N3H2pxD8IXBDse3QjCWamhpuIx5Gf4kGlfWLgeju0IfwA819ztQfb
         jiZQBTbbNKu3OlEWq03Vii4P2DpQfiFhiygt0v45CNSj0lqKhp9vu21KmoyVCuIdvRjG
         pV8g==
X-Forwarded-Encrypted: i=1; AJvYcCW3/Uhg19lvezSTdJ8DqE6WO3NaQIl10ZVNN3rcRsLrzwncqtJwdIOm2Q2di0TbtcyU2SDc3aLkHA==@kvack.org
X-Gm-Message-State: AOJu0YyR3J6vqOSzM5p+sYCs+jctYZIonEnddfHPGget95JHu8i2c/6e
	qpkGZeMWD/qsiEVXJG2VOczs2ocP66W/u9cmVDLvohYrxl+xR4WR35TrZXrUqyLG8EBvUGUTh6y
	PLUbYHaKBPE4eVVHMM03b2STiooEy5UswTNp+aVZw
X-Gm-Gg: ATEYQzyz8Vb5iwaIkMUcHlhdC5gkPQegjKxCtxPnae1t3+j0+UPnW6kqNSjqUIUNN7m
	HkOMM7jUKDGGXlWtam4SBonq3++f23tbu49T0tZOmWJzYDu4KP2bPV+YFqc4m96VX7u55BQecXu
	znOlrUqTB+BOiltX45xt74jvOa3pdCdNvTUwWV/JmyNVNMfOToPgzsEgJS1U0YgLju5wCLDWkZl
	/EEzfe+nLSudkD9Bju4fHASvY7J/ydEcYTFCu3PkwGyYwVBd1sRYzZ5v6uScy81DpLTsLw5bu15
	E7YVLCu3quoByRdWo/lksFtOWoK82jX25ZSX+Kc=
X-Received: by 2002:a05:7022:4582:b0:11d:c86c:652e with SMTP id
 a92af1059eb24-12be64206a6mr4246421c88.5.1775137736932; Thu, 02 Apr 2026
 06:48:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260331111240.153913-1-elver@google.com> <202604020400.jEq32K95-lkp@intel.com>
In-Reply-To: <202604020400.jEq32K95-lkp@intel.com>
From: Marco Elver <elver@google.com>
Date: Thu, 2 Apr 2026 15:48:20 +0200
X-Gm-Features: AQROBzBTzNfYUXOsbmlfPQCs1PnLUVzNWPXPqQybMa2GKboY40C31FthWXXrJZ4
Message-ID: <CANpmjNOsM1e8jMvRKtEizMmZgPCCZ9YqpuZKad61Zg7PAGW7RA@mail.gmail.com>
Subject: Re: [PATCH v1] slab: support for compiler-assisted type-based slab
 cache partitioning
To: Dan Carpenter <error27@gmail.com>
Cc: oe-kbuild@lists.linux.dev, Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, lkp@intel.com, oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@linux-foundation.org>, Harry Yoo <harry.yoo@oracle.com>, 
	Hao Li <hao.li@linux.dev>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
	kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 13DDBC000D
X-Stat-Signature: d817k9r64sgsgr4jesu6cr5gjsb11ze5
X-Rspamd-Server: rspam06
X-HE-Tag: 1775137738-285215
X-HE-Meta: U2FsdGVkX1/cy7mA7vgEZ2mJclPOdY8rXUGnRE9T8OLMYyPs9m0trl2QdObyitzAUJqR3UsQu0oUkxJZdJqXZsUUMGUycsFEu8IfZ/vvbj3lHCUkWFNm6JNwDDUpVKrf5fiKyQ0mI7+Mikdg9LJMFmOp0nILVfrSCiowSuJ4En2rigsuoImTRx2QQJmtwGIuza1R8ZggPhLgUT6yaKNyecC+wfpuYcST13hJgxjG6+djqhlZdMngrL/VamrZ+1wuLLRQWEPlHBTdws08qskWGs9DlZt/H9Toa1ebWERMoaLX4FRQ4x8TACiwBZP/rYYsXZ8ZxfboOKnPGCMfVqdvOYXVzXsQyY6r6ReDAniyro0CO+oTTJiCHAPw6OXEc8HKbu4u1BUIpsxksUZbD/grwlkQEoId5rztw8csFhRk3vbqT/+v/g3NswgXcF9riJEb6K6nZWzBSxu/7jqs/Ytyi2QsZgjXL9eCOHTAeLYiYFwlCbG8Jcsfaen8kaHQNHqmHeAV44mj0PHRcC8p0IHfbxg8w8BI76Z80XSWkBnJ/7+sngNWvRyDYB4Aa0k+4cP7dItSgU03mzZF6DDCgimgjP1icn77mR8UeTTFqrhwASqvxu12cBR0/PanUIjAxFR4m3cOVqr+q67i0UNKZJH/JNNMImQO9dj9/sHDG9QXMiodUvMYSnqaLxSCjcmNF+aKS9rTgliegeYXMiw+KkuEsTJn90lQGAfYPI0sK3Y2wGDf3mVeuzhWFwUfDkYpNmFWS7YDSfEMHerI1xEM++PKFvE/uG6Fhyfivmbw4R+7XJZSuBnZfLTqAVZ8D28wOzUAmbrD7N7HwJGHIVdw7svXJU8KDxTChFRARw10FDJX+MXO+l8yxBs4l8qdp6+h8IfhJKoFSA9oAPXDg9BjJbG+F96o3llJ5iOxZbCYHUf1VEItpd6/VGEPwhHJWNbNf9rWvQImgmSCvBOIwwsiLt7
 DAnHle4I
 s6rw6gjSY3P6w3PGtdfSg8X7XRVtO9w1ciyncHJ8LnXFbaeuern9QVIoaINbWuoJcpeMSy8mFjV3trEzx3h4ah/wYJe1e6IawwlkgK6hsbstZG1p7EFwu5m458F2r0W9f80pq0NVdYw3DWraqxNYzc/1U3ZSg2mt3shlyTUrrYSsyaCVApNd1oARx63XUYglb0ou4ZaI0xSkNQ32mdCK8Z6gDJ/mYRwrRDOhtIPMUJQlf02tseo+WW1HYJaLWF+hXtCAIL1w72YdDXOPVjIj2sjgps/rKgFBg75pgtzgX41W72FN/l9dpKIBw8YXh0c43YbyfS1LMiEeDFPZ1Y/zAWFZEK2qBfU7oMYmuMEqjFF4KjwHV1+s9wGsQSAoQtI+SLO0iENZkwxeQxj0shiS5E8qeJAvJOrFxaBv7gpPScxQH4kjHVFldLClxa9yd8FbujiNyxHUfD3HCoMs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2 Apr 2026 at 15:33, Dan Carpenter <error27@gmail.com> wrote:
>
> Hi Marco,
>
> kernel test robot noticed the following build warnings:
>
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Marco-Elver/slab-support-for-compiler-assisted-type-based-slab-cache-partitioning/20260401-035608
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/20260331111240.153913-1-elver%40google.com
> patch subject: [PATCH v1] slab: support for compiler-assisted type-based slab cache partitioning
> config: um-randconfig-r072-20260401
> compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> smatch: v0.5.0-9004-gb810ac53
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <error27@gmail.com>
> | Closes: https://lore.kernel.org/r/202604020400.jEq32K95-lkp@intel.com/
>
> New smatch warnings:
> drivers/misc/lkdtm/heap.c:118 lkdtm_READ_AFTER_FREE() warn: potential pointer math issue ('base' is a 32 bit pointer)
> drivers/misc/lkdtm/heap.c:169 lkdtm_KFENCE_READ_AFTER_FREE() warn: potential pointer math issue ('base' is a 32 bit pointer)

How is this related to the patch I sent? Did the <linux/slab.h> change
force rechecking of all these files and it found latent issues?

> vim +118 drivers/misc/lkdtm/heap.c
>
> 73f62e60d80c2d drivers/misc/lkdtm/heap.c Kees Cook    2022-03-03   92  static void lkdtm_READ_AFTER_FREE(void)
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26   93  {
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26   94   int *base, *val, saw;
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26   95   size_t len = 1024;
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26   96   /*
> e12145cf1c3a80 drivers/misc/lkdtm/heap.c Kees Cook    2020-06-25   97    * The slub allocator will use the either the first word or
> e12145cf1c3a80 drivers/misc/lkdtm/heap.c Kees Cook    2020-06-25   98    * the middle of the allocation to store the free pointer,
> e12145cf1c3a80 drivers/misc/lkdtm/heap.c Kees Cook    2020-06-25   99    * depending on configurations. Store in the second word to
> e12145cf1c3a80 drivers/misc/lkdtm/heap.c Kees Cook    2020-06-25  100    * avoid running into the freelist.
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  101    */
> e12145cf1c3a80 drivers/misc/lkdtm/heap.c Kees Cook    2020-06-25  102   size_t offset = sizeof(*base);
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  103
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  104   base = kmalloc(len, GFP_KERNEL);
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  105   if (!base) {
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  106           pr_info("Unable to allocate base memory.\n");
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  107           return;
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  108   }
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  109
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  110   val = kmalloc(len, GFP_KERNEL);
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  111   if (!val) {
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  112           pr_info("Unable to allocate val memory.\n");
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  113           kfree(base);
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  114           return;
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  115   }
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  116
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  117   *val = 0x12345678;
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26 @118   base[offset] = *val;
>
> This doesn't really matter, but the comment says we are writing to the
> second word.  The base[] array holds 256 integers, so:
>
>         base[sizeof(int)] = *val;
>
> would be the third word, right?  A word is unsigned long, right?  All
> of a sudden I am unsure.  :P

???

So this is clearly a minor defect in this existing code (comment wrong
or code might want to match what the comment said), but "slab: support
for compiler-assisted type-based slab cache partitioning" didn't touch
that.

> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  119   pr_info("Value in memory before free: %x\n", base[offset]);
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  120
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  121   kfree(base);
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  122
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  123   pr_info("Attempting bad read from freed memory\n");
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  124   saw = base[offset];
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  125   if (saw != *val) {
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  126           /* Good! Poisoning happened, so declare a win. */
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  127           pr_info("Memory correctly poisoned (%x)\n", saw);
> 5b777131bd8005 drivers/misc/lkdtm/heap.c Kees Cook    2021-06-23  128   } else {
> 5b777131bd8005 drivers/misc/lkdtm/heap.c Kees Cook    2021-06-23  129           pr_err("FAIL: Memory was not poisoned!\n");
> 5b777131bd8005 drivers/misc/lkdtm/heap.c Kees Cook    2021-06-23  130           pr_expected_config_param(CONFIG_INIT_ON_FREE_DEFAULT_ON, "init_on_free");
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  131   }
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  132
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  133   kfree(val);
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  134  }
> ffc514f3fcac4a drivers/misc/lkdtm_heap.c Kees Cook    2016-06-26  135
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  136  static void lkdtm_KFENCE_READ_AFTER_FREE(void)
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  137  {
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  138   int *base, val, saw;
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  139   unsigned long timeout, resched_after;
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  140   size_t len = 1024;
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  141   /*
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  142    * The slub allocator will use the either the first word or
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  143    * the middle of the allocation to store the free pointer,
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  144    * depending on configurations. Store in the second word to
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  145    * avoid running into the freelist.
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  146    */
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  147   size_t offset = sizeof(*base);
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  148
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  149   /*
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  150    * 100x the sample interval should be more than enough to ensure we get
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  151    * a KFENCE allocation eventually.
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  152    */
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  153   timeout = jiffies + msecs_to_jiffies(100 * kfence_sample_interval);
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  154   /*
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  155    * Especially for non-preemption kernels, ensure the allocation-gate
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  156    * timer can catch up: after @resched_after, every failed allocation
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  157    * attempt yields, to ensure the allocation-gate timer is scheduled.
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  158    */
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  159   resched_after = jiffies + msecs_to_jiffies(kfence_sample_interval);
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  160   do {
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  161           base = kmalloc(len, GFP_KERNEL);
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  162           if (!base) {
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  163                   pr_err("FAIL: Unable to allocate kfence memory!\n");
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  164                   return;
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  165           }
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  166
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  167           if (is_kfence_address(base)) {
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29  168                   val = 0x12345678;
> aabf7c37dfbce3 drivers/misc/lkdtm/heap.c Stephen Boyd 2023-11-29 @169                   base[offset] = val;
>                                                                                         ^^^^^^^^^^^^^^^^^^
> Same here.

Unrelated to "slab: support for compiler-assisted type-based slab
cache partitioning".

