Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A49FFC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 14:54:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ADA76B00B4; Wed,  1 Jul 2026 10:54:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 985766B00B5; Wed,  1 Jul 2026 10:54:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 877156B00C8; Wed,  1 Jul 2026 10:54:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5A4ED6B00B4
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:54:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CBFB8C1D8F
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:54:08 +0000 (UTC)
X-FDA: 84940502976.25.E389F90
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	by imf21.hostedemail.com (Postfix) with ESMTP id EA4AF1C0004
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:54:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=SM4lVPI3;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782917646;
	b=qGpooB0kC0UCpdmzwEuygZy8NuKUdwpjpeP126wO/HBtK6L8zbfHoN2L76bPlde4V3fp18
	HV4i/xkkDtlcpDzfS4uMd0ibC3CRybA9uThHS4vuUrP8EqTZDWJ8iStJT7M9z6FPKewIry
	uGYwItNVXMLQ9OmINCTg5wbn7XK96X0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782917646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F+1DffOn/qJQQJg4tUTvbBsXqCT8v6DtqvEjTPgSGG8=;
	b=wi+WFgLnE6MjJYcw+1nX56o9w39gBGjyqJj6O4iX7nT2XdNob/ZJd11NWRkNLj3kjeHg5A
	dnczf6pUO0HLEQfsxLX25H6GGJ9ii7f5R+FWKVyNQim4rO4lwiviNRafY041dUFf4sBkV5
	9vOTofNflFVlFaMrWp/Gf132+8hTbf8=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=SM4lVPI3;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-664a10cd4a4so823537d50.2
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 07:54:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782917645; cv=none;
        d=google.com; s=arc-20260327;
        b=da2thvJ3WG+VhFSgkwLXt3NKAZobiQhF49Q7OZfu7Eap/f+ZepPL3EtWdHxmYOqOi9
         xG9+8gsEHMFLVGieHTzGSTXj8kxrlAUQxmqmXnUmwKByOMU87xGwrtYx+0uGZCFxejMy
         ye02M4IMoRfRCtV48CKRuyfUi0faUybHu4/wYOaCHGx3LKrUv7SxB0JrWH8dZ/jytX3Q
         1FWwgUHcWOHsrgIronz6pp2BH3Q0jCw8QuGPgQsWUglP0T5FyBJhdY+bi5WatqzXQ5rN
         8q6/EDE17tZeJvvHRFTill95EDjNIhWA35b+et7AEqKRy9afPjlJmd4JT2Nw2nADDYhF
         5Fgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=F+1DffOn/qJQQJg4tUTvbBsXqCT8v6DtqvEjTPgSGG8=;
        fh=9FfCG77BPOXpJWLv8PXmfhx4ouzHEIoyYArmSPlUaj8=;
        b=rwqKklIYKq7ftN+ijRs/SSozx+oB8oxC75SXhTNR7S1YZ7aakhGjXWiH1FKJvUXRaQ
         +A3I3/N14C9UV/nHjuUSh6GX/H5MHchXzeJqDIGqMpe6oomeV0S73Fc108zS5KiKB1t8
         quVGh56qMzOmaRDRF38Aj3PM/Vn2mV8/y2ElAwJgFWluFauX9/dM5OqFjxQ6bOQnHCoW
         A13QHn8K7x/5YngJVR3Nvumgn/cwI5nAdUFuSUxjOByO3hvPYz0c1AiREMa0akqIaX+G
         c4hjYqEBVt5H3hK5dE8xQEYn1D1/tqbha0wj6/jbJZ/uR99CZNoEFAhGKaJax1A082ui
         daxA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1782917645; x=1783522445; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F+1DffOn/qJQQJg4tUTvbBsXqCT8v6DtqvEjTPgSGG8=;
        b=SM4lVPI3t647gywcTUE84kaBolYNmUAn2drdLasT9C/8i6yQzQ1WDnH85LqeuFBpLw
         FRiEgMnkNvirQYduAH8VsnaRFj6Rau4DPsu/XtOTS0C2ztCqhXR8GznQVyxwpHPXQlPR
         7HiTwoLzEFdUMNrl/ZDiCB6+Ob58HhHKTesfAKImsNSAocqfODhsOsWUAsbUkfbx6frK
         CjYcR3jDgayBwLP0DI2VTAntES0Ugpm+YyeYO00hipT+oXB+/A+8FNDiFfhowjpGRPIT
         7Iw92arSOltJ+VcLo41EkhC5mU2okTuOPRCtM37aB6aGIJdZUI2yKh0ZxkvYPqMwHPfZ
         QcpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782917645; x=1783522445;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=F+1DffOn/qJQQJg4tUTvbBsXqCT8v6DtqvEjTPgSGG8=;
        b=qMMEKoj1ZF5R9LbJ8bZKtWYhw8LNPEO8vJ2fa505646bGBSRMYwEMe+BPc1Uz6dS8Q
         OU2kOaUYdT4sox9JpcB0uJ/lgcdyHV1WAEY1hOTNmvZM+LfjFo8GFRK92c9+9VwSsw4R
         3ShZJr4UttZtppkAkpExbweED8feIY0ewo9aIbPd2XNhxLtDBNs4xxrsEeaI00AYGVvJ
         e2xWyNr8uClMi+BEw7ABoEgyEAJ7CFtoyW/Q/t5U01MPMbHOR8xPiClwWLt+Ssrx9dZP
         OBhtA6DfmEyh5o+/q4r/C0NdrIwkvwrhi4bYWZBe6T0fm6VvQFrYgfbFPISiCMmG808X
         j5JA==
X-Forwarded-Encrypted: i=1; AHgh+RoF0N6QnUPWYUBQGojNC46F5TZtnvLRmvqaoV//Z1DIP4e3p0bEL8pAwTV3LaV39gWr0yiqtOu+QQ==@kvack.org
X-Gm-Message-State: AOJu0YzepJJLdqjccfVpo/pAF2Yb89FuZ2Dyx7m87E20G+itT6vbeh09
	dk0Kw958zCc/+OwopgksIJLqbEuSsScdC17I5yQzgMNuhj8KncRgKJVvBJyaeFG+T1z20YEmJSg
	lLqYjViNVej5xJKJIp3naRoJfsDL7z9O8WoGFWyviSjS6r0zAEq+vjiOFhg==
X-Gm-Gg: AfdE7cl5XNEZyDB5zf21bDWq5PoPp5c0c+CYJVlT1vF3HfkEYYyPxyR5rsdIjBhcwPQ
	MCxiAK/QN9222MznP5pvIVqAs5Sd8BX/48p6IMzZR8NTDo4CpQXbxO2FqQy2MLzL2aiUDv/Y0rQ
	VVW5MlWgsOvBvH819V8xIb3ZssTEwKxsGvcoeRvc5BXkSoWajYbk2E9e0PmFj7wI2FW4BtpuJT/
	qvwW2VBNvoZ8UzQ0RJjCixDJPvng+ZJaLBK+8ln4sEwKOKqulK20yK2FsLkT/6+qyEf8AHtgws=
X-Received: by 2002:a53:ac8f:0:b0:664:e429:dd22 with SMTP id
 956f58d0204a3-66521d1efc1mr1851551d50.56.1782917644676; Wed, 01 Jul 2026
 07:54:04 -0700 (PDT)
MIME-Version: 1.0
References: <202607010945.6lDjBFTU-lkp@intel.com>
In-Reply-To: <202607010945.6lDjBFTU-lkp@intel.com>
From: Muchun Song <songmuchun@bytedance.com>
Date: Wed, 1 Jul 2026 22:53:28 +0800
X-Gm-Features: AVVi8Cf0CJ5E8M7_qFK2F6kC2qUGExtwdwzx7OnJal-wZJfledGXONFqKny1avk
Message-ID: <CAMZfGtUtS_dqh4wNX9sAM01VaqCUMRDTxg+NgWYsRwrjp=CBWw@mail.gmail.com>
Subject: Re: [linux-next:master 1977/2307] mm/hugetlb.c:3095:4: warning: array
 subscript -1 is below array bounds of 'struct list_head[1]'
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EA4AF1C0004
X-Rspam-User: 
X-Stat-Signature: tmwzpmhdkrudxnufwcqwnzrdt7d6fkcc
X-HE-Tag: 1782917645-771179
X-HE-Meta: U2FsdGVkX19/MGPb8smJO89QC41aKA2/ALiZanD+HOTTUCcGiUA/Af5LMBznfYOF3Oo21JLhfVduT0plx1oTmjaqsWfhwxYqfEcaVmSQmkkQQnJ/K5ka7bPtROG8MwStpog27kSwy6Lm3cricrWuN4aowTv9Uq/W6+VhetYkVn7jtx/n41LTqRyM8ZSBce+RiIkJQ1mQX7f3LOZYYx6hJiF3+uM69/Gc3QAzG8ztlcBJBnRwP6Q2KKZNOUx2xM5FnM1imDnESN1XwYP7SERVgm8jwVGPeqsvT0aY8r5bzDzLC+y1SxwvtLmtUX2cnt4kSpnV7blVL0C/Yy4HhRqEqIYDyTqngX/iOVcxqRN6YNWOr5UsRzLrDgpJjMRsP3RxwsZ1uv1vtdla9dtMwdcF4/yNL8bS2b/n7EOA9YOerZhadKRznNk7zwedUHQyPpJZ+13yrJVcKbx3BdrV4EZg4K9gnW9oBfp8z/dgoeWDB5C1tc6KFCQiSoJ7Yx3D/0kWJqLtUX+AmVIF45L0BsNIzkHClGuku0BayZDNsh6Vt4ZTasSQJ3vrPYY8o2PJK7Kmob95wEU6VEXwQY0ItYR5lgSDs5s3lSbabj+amQV0iauMtmB2TycLXSNM9sdJ6kfp3Hdj/ElDbZMtr/vQ1njkAvB9KTfYvwISHABnSRSK0jM3N4M6M22IN0IS5FYGrhR2IjtiqQnBCNJUhDFL31DoRtoytpnwJbb9SlbbQhzT1bBxCcGUROCRLOvfuAvj/ZG0B+piFkHNZeqwDHVUWMFoXiRQFwcGstE+z9UW8lzIiMSi3MWnBZ62hEAcCR3O76D935McCSCgq6Qo1pZaC3P5z4Pq275zJHjrVy0mmr3BzqQkVfCjn7Re3gUJkBcpzqaE4xp72nCO6Dkcg2+lC9a28uroXH3Zvnk9c+Gmz9aEnAnxnap4DIInah50Yls6xS6vvwpX6YoXB00e4rZplV1
 sOKm8kGd
 l64PZ9l7+O5BNPb7EdCTJAHqii55+Pot2T7kdpf3YxMTNVCivU36enCqZjRQHvITaKHVVdAmUcBcYrPdXkUA3NMW2OwSYfphroDrscXrIwsUjAEFdhN3dDWs5VEkHAL9C2Qnp228N+VcQq/Flyuwoca+x4tXyw0q6LD+YKg46ubTr1xvb+9DXzSGImfH+tbjOlyaarQLxu+N8PecIW+6TNUTiYLQS6vn2CHcnebUByF2MH+l40653ZJwQR3NGJAH3jSroJ368V+n5Y2SKVM6I/r6sX1K7kQHL9uDJO5Hc5M58Dwg/0eUB/11unBtcAvdkoaDQ9tB7dcmNa8i5neVLR2rudQ5SMHhQ7qyFd8UkkaGzGPLksPpz6BQHbjmydaVvwSihJ6YkO6iLQLHGPgT3Zx6Hj9gWtBoLJuFeeDslM+KHqq0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 1, 2026 at 9:37=E2=80=AFAM kernel test robot <lkp@intel.com> wr=
ote:
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.g=
it master
> head:   be5c93fa674f0fc3c8f359c2143abce6bbb422e6
> commit: f48ee682d55e3602fcc194cb93b8398f2546e53f [1977/2307] mm/hugetlb: =
free cross-zone bootmem gigantic pages after allocation
> config: sparc-randconfig-r131-20260701 (https://download.01.org/0day-ci/a=
rchive/20260701/202607010945.6lDjBFTU-lkp@intel.com/config)
> compiler: sparc64-linux-gcc (GCC) 8.5.0
> sparse: v0.6.5-rc1
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20260701/202607010945.6lDjBFTU-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202607010945.6lDjBFTU-lkp=
@intel.com/
>
> All warnings (new ones prefixed by >>):
>
>    mm/hugetlb.c: In function 'alloc_bootmem_huge_page':
> >> mm/hugetlb.c:3095:4: warning: array subscript -1 is below array bounds=
 of 'struct list_head[1]' [-Warray-bounds]
>        list_add(&m->list, &huge_boot_pages[nid_request]);
>        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>

It seems like a false positive?

>
> vim +3095 mm/hugetlb.c
>
>   3060
>   3061  static bool __init alloc_bootmem_huge_page(struct hstate *h, int =
nid)
>   3062  {
>   3063          unsigned long pfn;
>   3064          unsigned int nid_request =3D nid;
>   3065          struct huge_bootmem_page *m =3D arch_alloc_bootmem_huge_p=
age(h, nid);
>   3066
>   3067          if (!m)
>   3068                  return false;
>   3069
>   3070          pfn =3D PHYS_PFN(__pa(m));
>   3071          nid =3D early_pfn_to_nid(pfn);
>   3072          /*
>   3073           * Use the beginning of the huge page to store the huge_b=
ootmem_page
>   3074           * struct (until gather_bootmem puts them into the mem_ma=
p).
>   3075           *
>   3076           * Put them into a private list first because mem_map is =
not up yet.
>   3077           */
>   3078          INIT_LIST_HEAD(&m->list);
>   3079          m->hstate =3D h;
>   3080          if (!hugetlb_early_cma(h)) {
>   3081                  m->cma =3D NULL;
>   3082                  m->flags =3D 0;
>   3083          }
>   3084
>   3085          /* CMA pages: zone-crossing is validated in hugetlb_cma_r=
eserve(). */
>   3086          if (!hugetlb_early_cma(h) &&
>   3087              pfn_range_intersects_zones(nid, pfn, pages_per_huge_p=
age(h))) {
>   3088                  /*
>   3089                   * If the allocated page is on a different node t=
han requested
>   3090                   * (e.g., on PowerPC LPARs), put it on the reques=
ted node's list,
>   3091                   * because hugetlb_free_cross_zone_pages() only f=
rees cross-zone
>   3092                   * pages belonging to the requested node.
>   3093                   */
>   3094                  if (WARN_ON_ONCE(nid_request !=3D NUMA_NO_NODE &&=
 nid !=3D nid_request))

We have a check here to make sure that nid_request cannot be -1.

> > 3095                          list_add(&m->list, &huge_boot_pages[nid_r=
equest]);
>   3096                  else
>   3097                          list_add(&m->list, &huge_boot_pages[nid])=
;
>   3098          } else {
>   3099                  list_add_tail(&m->list, &huge_boot_pages[nid]);
>   3100                  m->flags |=3D HUGE_BOOTMEM_ZONES_VALID;
>   3101                  /*
>   3102                   * Only initialize the head struct page in memmap=
_init_reserved_pages,
>   3103                   * rest of the struct pages will be initialized b=
y the HugeTLB
>   3104                   * subsystem itself.
>   3105                   * The head struct page is used to get folio info=
rmation by the HugeTLB
>   3106                   * subsystem like zone id and node id.
>   3107                   */
>   3108                  memblock_reserved_mark_noinit(__pa((void *)m + PA=
GE_SIZE),
>   3109                                  huge_page_size(h) - PAGE_SIZE);
>   3110          }
>   3111
>   3112          return true;
>   3113  }
>   3114
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

