Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E644CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 10:30:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5C9D6B0005; Fri, 12 Jun 2026 06:30:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0D0C6B0088; Fri, 12 Jun 2026 06:30:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 923186B008C; Fri, 12 Jun 2026 06:30:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 855B26B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 06:30:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 144031405C0
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:30:49 +0000 (UTC)
X-FDA: 84870892218.16.2CF908E
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4B1B5A0003
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:30:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CrMuqKYy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781260247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=oARqs+T9JbWNb6W4wENAtGBSBaXfYyAinTQCHjHTX1s=;
	b=dddim8OvlhCFAVYHraOmyUZy7jEUKQlwsu2b4pbEHWDrusmoG3d0Il9P1rLm0TX0Q8x1C4
	jqjoaxj2/2GHWY3GBt1BF7b72L2g9OfMZTmOFgmeR1NrjJ1a+9FvbcstPYkSDRa8kAaPur
	WPqeutBnTGAPUPBqoIYkpg3NVeRDhyA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CrMuqKYy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781260247;
	b=xzseTdtqKFUviggccEkg5tWoin42ze5TDNMeY0aYdC7ODMjssDpcQdl1EvX/ZuugjQ8B1d
	jMyTk8JllBdzp5RQ+bYM4qn5MOxsQqVVhXYHGMCigrew9WWQY92yUMuGaIzhh6d252kb/8
	ATYDik400gAX7nX9Mm3Y75Bsex6sOEA=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2c2da7fa321so3611965ad.1
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781260246; x=1781865046; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oARqs+T9JbWNb6W4wENAtGBSBaXfYyAinTQCHjHTX1s=;
        b=CrMuqKYy9EPf4/wttwN9XdHguKVHDzY7KxlEExKxykkbfKKTAwl7/QUh/zUzs1cqhN
         YPgjstyh28PQBWiJMhqFd91kpW4wUJdExCEpsb4jiWG7wO5ayXAR+8IcFX4/7Dqim7E/
         SSIsbHIXSwMCOdpRe+PzZL65ISWqR+qSpNuf5Jnh5h469O2GfmBFeqTpDih8y1V+KnWq
         JCeNrRqp4uLGiVwg6uDr+d9MzWpgAtPkXrrFWcksbTsvO9QrKtNcxwJmPPdm9fbSpHd3
         cX8SSRaC0qH54mLPc/CkPI7EtBHUizdl8I1rd5PwFQR4prWBG7X3y1Do+aPAkh7jT9ly
         wGeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781260246; x=1781865046;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oARqs+T9JbWNb6W4wENAtGBSBaXfYyAinTQCHjHTX1s=;
        b=ZpyCEuS4YkSAahcN8WyDLg9BU1n+NRwpUrKblPCWEDvFtfiVdgSSZmpTslkWx9tqMX
         YtHqoX119uIbcyHOcljymbxFoMbhJNcim+OwmpjxRIAXOSRyyCzEPB4s/8sTi/E1UD2k
         9KtBIUJfrGm/zVafCjm4G3UbIRRTiuL0OMSBnpTGQsmTSE4DmENcSB2CzFTcMCCL55qs
         QZigpVvf4bBv48LpRJQx9+IBzT/gRGN2+ewSaEfGpsCV+tqagzw1ghn5G1oiWKQw7h+8
         QZ93vF5LiKvhe+AX0/LNV5mX/ikZGfFO61pFSPOHoiY5w5hBVywrQAffXWDGTKSuF5bO
         L9mg==
X-Forwarded-Encrypted: i=1; AFNElJ/R6B2wExL08lA+Myo9xFHwejfE6/TfDa8nhvdgLG6P1kdOiqX/WfjDJyVsm139he93/gnca7KPJw==@kvack.org
X-Gm-Message-State: AOJu0Yyqy8tTaxDyyXyNe0jxOZJyBu1G0fr1WJjLIBH8GQp12YAN42dW
	7JimHpXjwbnPCWXZKPpNvSL+aqnf82VORx2MecKzGhJYclID1avgJlH/
X-Gm-Gg: Acq92OGPyLtuiHIpDjp97Jdv2XVGqaE/vptNHtI/cF/iY5gpWEYNonlUxWH464cGFos
	0EGw+OA+IEBMVZjvT5a0jqxIwTZuLsgCBm43JIMR5SuUXcW7synWPjlot5/ocNBrdy1barbAjMV
	2HILGtNIlInVysIqWMvpsfdBeZWhrNbzlgie/Hai0m2W3qnoxv45kvfBnC0wtAhz1boe0Cs5dX3
	W5huGawI1m/80fRrCKtThPphD7dZ0KvkhFyTyKb5lMt64s304khvfOWA/6dTYK6ao0VxP21afxv
	m6o0pufhB76nY1vUd1TdWtQAY/P+yuMDv9T++TsuxTG5Z6BVz2GgGzxfSmoa8OAfUGDr6oyueRx
	dYZ0IXUavXwtFTjclt3jmcedQHnPFmukFPzs4Kwh63tCA/M5M1uDbrFI+1wRtY5SF7TEmEgduw7
	h1X81La5mv3KyQqJIzvbROt7GmFA==
X-Received: by 2002:a17:903:3887:b0:2b2:4d36:7ba with SMTP id d9443c01a7336-2c40e0350d2mr27814135ad.0.1781260245979;
        Fri, 12 Jun 2026 03:30:45 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c42fbb50e5sm17778985ad.35.2026.06.12.03.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 03:30:44 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: kernel test robot <lkp@intel.com>, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Memory Management List <linux-mm@kvack.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, Sayali Patil <sayalip@linux.ibm.com>
Subject: Re: [PATCH v2 3/3] powerpc: Kconfig: Enable THP_SWAP on Book3S64
In-Reply-To: <202606121305.h0cxjhP2-lkp@intel.com>
Date: Fri, 12 Jun 2026 12:01:26 +0530
Message-ID: <jys4e0ch.ritesh.list@gmail.com>
References: <3abf510d24c8ef17bd5e324cccc5e03e548afade.1781170904.git.ritesh.list@gmail.com> <202606121305.h0cxjhP2-lkp@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4B1B5A0003
X-Stat-Signature: xss39n83d51ktgopz8pz7oxg6sog8p6f
X-HE-Tag: 1781260247-129169
X-HE-Meta: U2FsdGVkX18DHEK7N+5aaH8Bxp01yEnd4uIpzF8zx40nXQggMLpJ8A5JmvT7opvjx+45IlJWVXRgDWXa/pYJ3I8q6qpJNXBS14M78bDyPajZeMnGH+HR7TvT142bUc3w2ocZHi6Yp8TqHtYJZQJ3AB7vQK2PAJqh6Yl/dT7u/ZnP0/W8/+ynlS7vaZbkWD9vBpGQg6JEXLV5cE6WI9QtJJYOuFztvqG7gMhlbVByQYOzwPcGwpeGyiMEIJgSt3xKx4AEGNlr2kxFOBO4xdHEm/r+b4bnMFS32+E7weVaD3CEMt9EwY9SgctcpAqqstaMwZC0BQ4Lz0uOu0yhaRaawszs/tywRCR3o8PC7njdqAMNx83bDZzf0zooGBEvFRVN0nGKFLzbr1Rn3aSgbSWeXoM827dLtVL7y/VmaoKd3e1aeRzAMUL6d2xuG/m0KMkBM/XX7nUBChEIUGvLaWEi3gX1h+nrI34N08ZSIOAEq233bOXa5CrqcSPKt24UiDF2LCbajPr2V/iUHbn8IlBDcg9yhm9KWoJv1JdGiagpFctWAB1m/1US3cZA7Wj8d+LOZDkDWHSp2TefUjcqiWH8Bd9Bvxs/67J2Ag8/HdU4vafGz3wDi2nAk5aheiWkud/LNeGvhVFZwNM7n3E73JQU8v9t4FdtaaUDaL2dqo8Dy4qtpzOg4b6hGcorzRMpkSYnGC14RmoDECgifSFWYLSi8OnHAN5wQgZQg+pu1aw0IkVgKIZcGJ6Smugtarh1jvG07V+h7ufx1g7lbxxNhoxvWuNwOFua9JP9iDv+QmgXc+P2597/8NT6aiUQjUGZhjJVfzj6X93WS5cWwrnME0kg5S+RZR+GeylM0+uq75npIHWopQVFWBZHYiC9VUiH+gS/5Q93qrDv+WAfp0aC07wplrNaUtifFmU/Vg6jiFlK9CQPhDq43Le2cWh7j/kpL+cPPc4JLy/SQYuuolhOTa7
 AcaWUBsl
 iXDRvU4MsCFTK+N8xp5KqASOwOKXnKgLl2SNt5xzdCJ1SntIpraxHywCNj6pQw4+FzIqN6dnci2NdqfJ6zARi3rdTlcKvGogYz9v85D4ZinFyknfBYcJ2obBc6H4VA8YMq9XcpW0673lHC5NwChiKs4//ScXjKNxM4dkRnJnKc6+tewOGVn1bzA7RIN4mmDMAsDrSf3+PJC4VrFITpZgEdx4vCghZgCeSWb7oOUoWDzH88he9fnmjEjGeQszFG0GO16xt4vDKoi0Vxv+bhRQVc5p9mwih57wHL5Wsj3mlgz2RQHS/hAo5KgW0Yb+g0iTH5lZS6GqMyNdt9VPAkGfitLd/z21TLejniZlGysN+UlFvUp+KR9Qi/EvgomjOeml4zJbfeXcayC8SbaxinXW7dF03a8tAAFb8rUfqp7EBFzQdCmz4XogNJLYqGsXEQuyphJDn+QY7/tiBTIjBdlNDTpyafZ+Y0vOWhgHFhe5VhqzbhNLwl93GVMzrlsWFwUIIA39m6jW8wDLFSpJn0nOtptF+w4WW6kSvH7WJVgsb1Qt3xgXq4YiVKxyhPuOeUOLli753ryAnRAzRu+ZY2DoxoIWveeBUx74SJ+vWqiyJ61AKDDR8EaKbLwJo3TxzvBTlkkY1HKKJLPBZ+r4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kernel test robot <lkp@intel.com> writes:

> Hi Ritesh,
>
> kernel test robot noticed the following build warnings:
>
> [auto build test WARNING on akpm-mm/mm-everything]
> [also build test WARNING on linux-review/Ritesh-Harjani-IBM/include-linux-swap-h-Remove-unused-leftovers/20260611-111124 next-20260611]
> [cannot apply to powerpc/next powerpc/fixes linus/master v7.1-rc7]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Ritesh-Harjani-IBM/mm-swap-make-SWAPFILE_CLUSTER-runtime/20260611-181121
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/3abf510d24c8ef17bd5e324cccc5e03e548afade.1781170904.git.ritesh.list%40gmail.com
> patch subject: [PATCH v2 3/3] powerpc: Kconfig: Enable THP_SWAP on Book3S64
> config: arm64-randconfig-r133-20260611 (https://download.01.org/0day-ci/archive/20260612/202606121305.h0cxjhP2-lkp@intel.com/config)
> compiler: aarch64-linux-gcc (GCC) 8.5.0
> sparse: v0.6.5-rc1
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260612/202606121305.h0cxjhP2-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202606121305.h0cxjhP2-lkp@intel.com/
>
> sparse warnings: (new ones prefixed by >>)
>>> mm/swapfile.c:133:6: sparse: sparse: symbol 'swap_table_use_page' was not declared. Should it be static?
>
> vim +/swap_table_use_page +133 mm/swapfile.c
>
>    131	
>    132	unsigned int swap_slots_in_cluster __read_mostly;
>  > 133	bool swap_table_use_page __read_mostly;
>    134	

I had noticed this after sending the v2. But by then it was late.
Good that the sparse checker caught it.

So, I will declare this variable as static - that should fix the
sparse warning. I will spin a v3 in sometime with this fixed.

-ritesh

