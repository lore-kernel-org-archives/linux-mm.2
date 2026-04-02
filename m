Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8060D6AAF6
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 17:05:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 886CE6B0088; Thu,  2 Apr 2026 13:05:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 837736B0089; Thu,  2 Apr 2026 13:05:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 726B86B008A; Thu,  2 Apr 2026 13:05:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 653886B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:05:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 039F8C2002
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 17:05:37 +0000 (UTC)
X-FDA: 84614242356.19.3A62613
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf28.hostedemail.com (Postfix) with ESMTP id F359AC0005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 17:05:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=d7Fh5MB2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of error27@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=error27@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775149536; a=rsa-sha256;
	cv=none;
	b=QworNILRBK1IJrxvmeM5wTq6BOhhviMT2BIDhSppMFwHub+i4t1ckq+IxsVdTzjD/kJ7zO
	iF9ZZ6KjUP9hyDX00yEBxTOhbmC5p0+y86wVoc1EbmOteoFzWeIDO+CHBmgwXtrSRTDpEI
	0BLHmyMx9qDM5ItdmDul727q8O7ap1I=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=d7Fh5MB2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of error27@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=error27@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775149536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IJ96XmrvwmNmdc1Ry2/PJXAWh8krLD6ljIYp6nVbJmg=;
	b=eYxayu643lVMFDRUFbcwdVm8UciA9Ye+dSsauMC1DpzqAnWzy0z2iUIoq/YxYl+89gudox
	YG2Muw0Q3yrVaJUGLVPmAbdluL3XW3KH5Mh8ksXRcnjGqJgrNXmFVX5WhZeA4nQ9Ybr7N+
	xeh3gQeVJ39EFDonyPY4N9J0cVMYuTg=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-486fc4725f0so11710075e9.1
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 10:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775149534; x=1775754334; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IJ96XmrvwmNmdc1Ry2/PJXAWh8krLD6ljIYp6nVbJmg=;
        b=d7Fh5MB269iAJINc9Q/8xi9N+LTXDjI1Aa+oQInJbV/O1EJu08oSIEvT/KoBHNEdt/
         kotqmewGlLVDJUKbzpvAGWuGGndZojli3mcsKOyfPyFOMvGm8xv2w3lAZKdNJqxprhdF
         lsDdgNli6BKXjg3wX9SLXasqOgvJ3PazQe0JTEY3VAoZ8khOeMUwxu6FGt5VzTId+c4k
         4Vcb/MNbjklMIJpAa+4IWBDpl805t9YTUU0tZEpwND87TA0S3jfMIw08I1KexSWn4q9P
         dZT3YiBeECfcVgTqx+/m2w/dN3yVIPaY8GOtEdTCs6ANONKzWv5rFsCVcDl8cZCXmgNO
         aTfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775149534; x=1775754334;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IJ96XmrvwmNmdc1Ry2/PJXAWh8krLD6ljIYp6nVbJmg=;
        b=Xw6IgaDtAnqrQGYOhc2V/6FEY3Vrd6R8rN1JL45tYw6qPljgfc6bznuf7FXYH2urQP
         3p2gaAQENtP6qtG+wQTH3zrDrEIejjzrLzBsdiB857lqBaDFog78PNY/XQJN8+AcYzHG
         Qyn9+B2yLkyft+E8OTHa9BB1ntVu9BQaHjs7zLI934XSpFhRauw7M327LDKn+7RUU1/d
         eI4jbIhlxoQB+bzXG66JX/AlosFlU3FBB9V5KLfO+wCQZsrss1Ree4GmZZMQyd/jgMPB
         u6z8qea2FwUg0O28OpZJHXslmUfUfZ6piGHSl9CFrvFUm0GFFzBd7b9gsZ5pWgflVD0T
         sJfQ==
X-Forwarded-Encrypted: i=1; AJvYcCWflKaal1khbGkhtagdbS7vayP/Amxhm2K0gGMgFIGW+Ziw6trYAAHGI3sLyi3Dsmc1vHU7tiNP7A==@kvack.org
X-Gm-Message-State: AOJu0YxuaAFpmbVyCKmsLd8tabqSZXYaHjoQtt5gtWBP/7W+eLPpsbmr
	GP/wJfujHkATChYZEsnUTUU6Q7Rhs01te22n0winkv/+TsjhD5n8D5D8
X-Gm-Gg: ATEYQzyvBybabCPaPhGefXPJkBG2+mBYIqh+6a3u3kweDYtEXvyAckRgUwI9ejrvVnH
	2E2WxHH4tWyy1nd8ilZHjcsd54Kuy5M38V99ybY116sQhQbtIX+V0wFTbKNAQ2YFBQ9x+L1Y+QX
	T25tQpHnkwaBSs9QD+//ZJQa5YUqNiDCneooPo9giZgfm0VE9ot1Ax7OAu9+ndaFWfbDlkT9QBf
	cO3DzABIMBkbN0bf42kX7qY8FNaQPLi+lZ17cqTJdBh+eZZYOqNHPk3XBsCJveX8bVIevPW2X6f
	+JjkRx/debqNf5ZuGYfGAPkVcDmRxvx6IDHKp8UIkYHbPRY9oN1aMj24mjdS5Qh3r7STvy8ikWZ
	3np/8xsWt6STtYSg5bzmTbdP+LLTgGetXYw72uqPt6EOM9WJcTAdUdOFYDpvEEizq3VVpRpihc4
	PrLpyHmNKvdA7GQsxnZps=
X-Received: by 2002:a05:600c:3b0a:b0:486:f893:56c6 with SMTP id 5b1f17b1804b1-4888e09ba82mr46503895e9.10.1775149534150;
        Thu, 02 Apr 2026 10:05:34 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4887e80a63esm265992305e9.3.2026.04.02.10.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 10:05:33 -0700 (PDT)
Date: Thu, 2 Apr 2026 20:05:30 +0300
From: Dan Carpenter <error27@gmail.com>
To: Marco Elver <elver@google.com>
Cc: oe-kbuild@lists.linux.dev, Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, lkp@intel.com,
	oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux-foundation.org>,
	Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	kasan-dev@googlegroups.com
Subject: Re: [PATCH v1] slab: support for compiler-assisted type-based slab
 cache partitioning
Message-ID: <ac6h2jF-KJ5pm1WM@stanley.mountain>
References: <20260331111240.153913-1-elver@google.com>
 <202604020400.jEq32K95-lkp@intel.com>
 <CANpmjNOsM1e8jMvRKtEizMmZgPCCZ9YqpuZKad61Zg7PAGW7RA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNOsM1e8jMvRKtEizMmZgPCCZ9YqpuZKad61Zg7PAGW7RA@mail.gmail.com>
X-Rspamd-Queue-Id: F359AC0005
X-Stat-Signature: aumptuujdfecejswm8omtdhbfua86ftm
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775149535-374887
X-HE-Meta: U2FsdGVkX1/IyiQvcGdxrrNzvOgy+e3CvvsRv8pVOB4PPNhrT6DpRCaOM5FxlwNzLXblLL1GPs+V62+QU9DJAHHgaXoJ5OwDT8S0NJkVue6IEYGqtQCLYSPjw+V4sTDo+/WJvARurGgA07B8wwUNO2VBZOpWoccDn0dCk0zhDy8sbad9dXgc7MP9+zO+vZWWzpZTwXyHR9QSaZ02XoHDtX0yoB2z202NaFD+6TbFfQU7TUyZ45oDrYd8UpRSGDMTipVCkRk4BHmav2hL4AW7+7lBU2BqschU9KZofZtFEuBX/9swEOHLQsKxCJvCuMV4RlGgla+jtNc33ylUcTJcnlCC6xK4LMSuKV3cAqYD6OUWwEZqptoZgjkMpAM/iPwzawziMXjeMifGoJySGdYPqQ19TD+MmDWQY9ZHVDpZXwb7upwXKHHUR6GVzgDNMAzNu5ijrlaWRu+h8TRcL23ryHJb6vfhgaFx8fOaCueexm+fO3iX5DYF78h54jlCR/lfVXD14UM+iePR9zXe31NdyoR8BsL5QrdWQm6SfXqClLkzeNE0jp3wOlHFbmkasIXvbgvR7oFHwBQoC8hQcBb5/983zGWwyT1OkYpLdN7rXv7xE/kvUL92w25Rk7mYaZv1Z89TsTMDI/J/oNtEy62yIKaZCGsNeCFusnHcKssuAz44fbQOs0DNBJ2WFfpE5E79JbJHwG/wiUS4U6yVBKSImmKKAso0MhdW+4mDwUqDSOiCr4zSr7ZiBh2Ppk0mMbkvqOiywQaXiLYDZBLlwV5F43AvSwJf3TJOuEgR9L8EL0UzgCbwuEWokkA/MlvpE6DiLZYnMff/JMCfIfcQg/cJ2t3bdGimtmmlUQsb308Y+q2abn3/otjHUQEiioQAbVPwxYlX9+V2Cuod0T2UNAglXA6sG2V9fJqVzmi9XT3WrYOuT1JRSMfoH3laGsJfX5o1O4xCteAztCf5iEyVNqv
 8g44Hz7k
 lEFnQFrUsgKwjNfgLDDZdigqE4UWb1FfrXFACm9eEQnv9NY55ZwlD6hx8tsJKlxhjZ58Ev/DOYOxg8piY3oW9/MZgetmVHsrhesZ1v4iZBhf5CO0p/IjLvpH+MBzTmbPPZ52dXsFan0HWEB0Yvf7sBDbT8dAKlbaU7sDwJIHLjpgIuJklsfY3QTB3ojD7/9JMy0lKRR6si0icofPwoA6c4Tgz3GDRNFk/KVtpgfllC9YIm0PZ2FYBlVykX0fUTi86h+czNyydKvHlhVd/ZSO69yCEnfPDFl+P97TWPPASQoMsFo0ixmEYkzopAm0PPrJ03GXelajUw21Qn9ZMG8mF2SEa0jIWPRykujVppPJ8NaV899Dhh004qVthc2BnOpBxii/km37ZqD2hNxYjt54QpkDYZpN8r6kNIa7R0vB4RPvt64DuVHXdH2kNc1ri2e6mzO0PwRBpzMRsmJVL+54u2CTFqPghEOJ7XUbmDE1zdoSiH1HCl0IiRitYBGemL/hC+yMYvtqOn9gR5Mw9UT7qkGhNxd3MPkccI9+712ufn/6gsN02+iBxaOEcfGsuCD0pN1V0ScbHX5BeiNR6mRnNB9TEceuyIVSNAY9T5Y9KnvgV3aC5L366et8w5jp5VOlLcisQm8AtuSk++jfw4UfMhxx36EzfPBqAKolg9OrUKK2t7yGpWd7nKhAbUvl7FVgLdXwJ2JmO6levmV2JOkCVyx4+SSNlsJz3ItO7Mn7vQZhROqc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 03:48:20PM +0200, Marco Elver wrote:
> On Thu, 2 Apr 2026 at 15:33, Dan Carpenter <error27@gmail.com> wrote:
> >
> > Hi Marco,
> >
> > kernel test robot noticed the following build warnings:
> >
> > https://git-scm.com/docs/git-format-patch#_base_tree_information]
> >
> > url:    https://github.com/intel-lab-lkp/linux/commits/Marco-Elver/slab-support-for-compiler-assisted-type-based-slab-cache-partitioning/20260401-035608
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> > patch link:    https://lore.kernel.org/r/20260331111240.153913-1-elver%40google.com
> > patch subject: [PATCH v1] slab: support for compiler-assisted type-based slab cache partitioning
> > config: um-randconfig-r072-20260401
> > compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> > smatch: v0.5.0-9004-gb810ac53
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Reported-by: Dan Carpenter <error27@gmail.com>
> > | Closes: https://lore.kernel.org/r/202604020400.jEq32K95-lkp@intel.com/
> >
> > New smatch warnings:
> > drivers/misc/lkdtm/heap.c:118 lkdtm_READ_AFTER_FREE() warn: potential pointer math issue ('base' is a 32 bit pointer)
> > drivers/misc/lkdtm/heap.c:169 lkdtm_KFENCE_READ_AFTER_FREE() warn: potential pointer math issue ('base' is a 32 bit pointer)
> 
> How is this related to the patch I sent? Did the <linux/slab.h> change
> force rechecking of all these files and it found latent issues?
> 

Oh, crud.  It turns out that for this check Smatch allows
integer_array[sizeof()]so long as we know that the index is within
bounds.  What happened is that your patch renamed the kmalloc()
function so Smatch stopped knowing the size of the buffer.

For these zero day bot warnings, the emails are automatically generated
so I don't have any context outside what's in the email.  I saw that
Kees wrote the code, but I figured maybe you forwarded it or something.
Sorry about that.

regards,
dan carpenter


