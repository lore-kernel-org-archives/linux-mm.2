Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E19DBE9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 07:06:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 238F16B0088; Thu, 19 Feb 2026 02:06:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E7086B0089; Thu, 19 Feb 2026 02:06:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F2FB6B008A; Thu, 19 Feb 2026 02:06:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ED7676B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 02:06:25 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 931D8140457
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:06:25 +0000 (UTC)
X-FDA: 84460322730.21.0AAAD3D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id AC1F240004
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:06:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sRCkoCF2;
	spf=pass (imf04.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771484783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4QNNF5RJKkqO5Vm2pdDiMVsDGlVupXGHmQz87XPpdcc=;
	b=3+O2rBb5kp8mZ6pelaKOZcK8Y0JiFL3t9XNGbD7r97MtvRuzK0oCC20haR60S6nAD2KHiu
	AtxOdyUQ9SWCT1KXS67oyDD56N6fMAVwnGHa1ql4Xv/5V5sjRnge8WCDho98lm46vs7vf+
	tXCS5cadCq2wQIrL2y6/AA7rL/9s9Tc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sRCkoCF2;
	spf=pass (imf04.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771484783; a=rsa-sha256;
	cv=none;
	b=QAn9sErT+07AdNRlt2jnPZ9q+fiyVrPt6E+FC3CdtJK5OAX+IDxFZP230ngRYsyokkEFTY
	z4U3Yb1UqP6cfsrFRuBTGIRfNXbAjnOn01lEdCmYGhEaa54ecJxyzVJvSMiU/xb3LjoDeB
	+TvtT2UTtvLYIZviZdqAIPC/ZfDFhno=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B0E57437DA
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:06:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C995C19423
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771484782;
	bh=ZdFSLJvL4NcVHf+sUxnxeOrGUy4j4aIn1TnvUv6XzIM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=sRCkoCF2cVyRR/wHVVO+OTEYKfSJ0ryR6aAp7qpJz+kBdKYuNn/7LTKyMuYWVICkJ
	 YlI2lJbi7N5vBcUAoZAfGh7mQLGL5yotmE3Xs8mPqxcXk20JeACbEj5qSkBDdaiK9u
	 yufJxsqBOJK7uTMyWnALPSIb3xoMQAjjqhHFbZmnI+/egGUGzz3VDxlOqYdFzK3j1E
	 yIeV3FMu5kPSNXDpTe8VqZGQKk81m26Vcf2ipTsmF+ESVgSw1Qrx+bX/O+65LzRPvQ
	 b1jBL1Vf3kTX10GCEfMkiox7lodiRzxJMGnPEnmUa4OSoACFVCGIoG0b144I3zwYSf
	 PexzjNeIaZH+g==
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-79273a294edso5406077b3.3
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 23:06:22 -0800 (PST)
X-Gm-Message-State: AOJu0YwIAFtSGFmJhgZVFg6s8K6D5j9MwH8HeaDlSaXBvHWLodK/IoBE
	Uy2kp7YLdA9MlHLhDgz3vGvSn+uX/iLkJe2rNu6A9yhOeUqBRneummTS0Ssb+lUTPPEYgyupGN/
	xApS9IYM1k8tG7X3RbFmA/O4VMaNu88/J63l/JCakNQ==
X-Received: by 2002:a53:b177:0:b0:649:58b6:ea81 with SMTP id
 956f58d0204a3-64c556c964fmr2478396d50.73.1771484781785; Wed, 18 Feb 2026
 23:06:21 -0800 (PST)
MIME-Version: 1.0
References: <20260218-swap-table-p3-v3-9-f4e34be021a7@tencent.com>
 <202602181835.58TEynxc-lkp@intel.com> <aZWuLZi-vYi3vAWe@KASONG-MC4>
In-Reply-To: <aZWuLZi-vYi3vAWe@KASONG-MC4>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 18 Feb 2026 23:06:11 -0800
X-Gmail-Original-Message-ID: <CACePvbVZH45zO0T716ru=voZVSoJbor0TYdqiT=LPmUc7rpCLg@mail.gmail.com>
X-Gm-Features: AZwV_QiSFOXwJ3UV6YDn1vcgaPkFq9WmxMcNj-RL3MGWvhZKm_Rc1O0W9z_CMU8
Message-ID: <CACePvbVZH45zO0T716ru=voZVSoJbor0TYdqiT=LPmUc7rpCLg@mail.gmail.com>
Subject: Re: [PATCH v3 09/12] mm, swap: use the swap table to track the swap count
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, kernel test robot <lkp@intel.com>, 
	Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 33oc7z9f1newdhaqd3hygofzqrif6dha
X-Rspam-User: 
X-Rspamd-Queue-Id: AC1F240004
X-Rspamd-Server: rspam01
X-HE-Tag: 1771484783-780271
X-HE-Meta: U2FsdGVkX18LpFzlHzNp5bi645hzQsex4kauloUBbk0HjemrTgEB5249njr4FOUBdEucGlJm9Sd5R7iP37aakVxJ0AGKMNVzrqh3fyOCG2pQfy0Zf3Wj/hqlDu2DpPB0/g0XjrP6uCyR78kR7hYN8z1FHjfH2ZkZlOnBfcZu/HUMG2d5aSGOTzWeymQyovaDSatbHsdxRW+YfgnQsRPAM4/aypUm2Lgy8HmkBQvtSDtCFwPHZrgs4GmTdy6uBpwYYHWas8vGWZ0F48J3PlQNQCFUEfpGt74O51pa1KoO9JVYiU6QS4j+m34BuELWZRfa6HB9IB10fpmdjEIwfFzs7ZJTuwdZF5Zf/R94Pk9IC3YeC+coGG7L0w/3xDXqo5T/i5dE7qwzPb4+pqxgka2XPVmZrUA89m+QBquta9Pn9VvSMJGjHhdOrBOGsjpuHu5P+0Imhx1w9UVz/TmkVh8mc2JFhlmCRo1QSq0CGIjkYz+hXxZapgFJ6RRe7ruo0UeE9aLkemKG7Tvrw2ZDiDOIwS4yBUk18zKEtWn7x1wxHURE+nxCo4KXgVr4IUbP20WDF+u+FE8PC5FM9MNayXR1Evm4HV9DZ6G+al7RKPLdDmv9Dc6f+q7ctxEQjtdGSFOroKRm5491c2jEyKxITnqzsHDPEvJS2PvESLCLNoItCNRWrtXBgXysAEadiL9TqRw9Nbzre07ooPS86zy3ZTasKGaUDIB40YpYXpn68+Jn5IVDfBxYXDpTaLxIGXc5GF/yfkpFh3AeIbom2Fgsr9iIPpATO6oj4I/Oj8320qL6vtn0FyvP3DxhQy3D1ucmuTwVHGuZ+xs0jCNs71WmUMvpK4kB4n2wEeNNQW0IlgQJXNfR484hLmXHWDbRS2ydxYimUybgJ+kFQVkc3/3V1d0hTrRScZ8yGjtFAAC/6zkkT59Zx5C/zWsQqQB+daGseZRTH4w0X3hgWQA2Irqwouq
 Si/Ta8qx
 PcJUWveI6eedvY8Hush5ERQ9Cyi5vaFCnn+pj4Jm3Qb0RWBk7PhzLDDImuYKDaNf3wGjwP5XXcBVaHifJ0VuvroQFi9lErmtpXUW0jxzYIZCKiJALmbN7nc1mWvwG4N6VpWqLOls99Oe5tESY0RI8Y3CQLjD6sHkq5VuBxVi4+ckt1O7JOUidyrkP/ON6OHKS1OfW7OvvM7VGN8ZqQvItgdYr5UHbQl/6lDJ1ft/8WMua3tDUmi1reXvn1V7QOLKhR5uW63TsJPYVUv0BVcdyzKiet5cKXXEU6odaCstN0KZNtV7BF4HX1zWH8SZx4N+2cM0bEcWsUGJAWhvm0fp5HxqCz6McmG9ClrHKLG03RwLDcGwoK1E8ZRJxsnExjntPXV6DycVL26IDcbAwZfSOAIvq+tiqAf6HEfqDARGYVZpKhWxmyzEuKtI0hM2E3/SpNw3j7O3IU8IqSeDfp2FA9gWKJP6ryj/1lCl8+HpCIEg0FGmhKdQ3dlZ0f1LteS/mLCYjrdsfXZL84J1ymJ76mVlWotD5yUK/cVYb1k37vDcshRM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 4:23=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Wed, Feb 18, 2026 at 06:40:16PM +0800, kernel test robot wrote:
> > Hi Kairui,
> >
> > kernel test robot noticed the following build warnings:
> >
> > [auto build test WARNING on d9982f38eb6e9a0cb6bdd1116cc87f75a1084aad]
> >
> > url:    https://github.com/intel-lab-lkp/linux/commits/Kairui-Song-via-=
B4-Relay/mm-swap-protect-si-swap_file-properly-and-use-as-a-mount-indicator=
/20260218-040852
> > base:   d9982f38eb6e9a0cb6bdd1116cc87f75a1084aad
> > patch link:    https://lore.kernel.org/r/20260218-swap-table-p3-v3-9-f4=
e34be021a7%40tencent.com
> > patch subject: [PATCH v3 09/12] mm, swap: use the swap table to track t=
he swap count
> > config: i386-buildonly-randconfig-001-20260218 (https://download.01.org=
/0day-ci/archive/20260218/202602181835.58TEynxc-lkp@intel.com/config)
> > compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87=
f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> > reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/arc=
hive/20260218/202602181835.58TEynxc-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new ve=
rsion of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202602181835.58TEynxc-l=
kp@intel.com/
> >
> > All warnings (new ones prefixed by >>):
> >
> > >> mm/swapfile.c:1627:6: warning: shift count >=3D width of type [-Wshi=
ft-count-overflow]
> >     1626 |                 VM_WARN_ON_ONCE(ci->extend_table[ci_off] >=
=3D
> >          |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >     1627 |                                 (BIT(BITS_PER_TYPE(ci->exten=
d_table[0]))) - 1);
> >          |                                 ~^~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~~~~~~~~
> >    include/vdso/bits.h:7:26: note: expanded from macro 'BIT'
> >        7 | #define BIT(nr)                 (UL(1) << (nr))
> >          |                                        ^
> >    include/linux/mmdebug.h:123:50: note: expanded from macro 'VM_WARN_O=
N_ONCE'
> >      123 | #define VM_WARN_ON_ONCE(cond) (void)WARN_ON_ONCE(cond)
> >          |                                     ~~~~~~~~~~~~~^~~~~
> >    include/asm-generic/bug.h:120:25: note: expanded from macro 'WARN_ON=
_ONCE'
> >      120 |         int __ret_warn_on =3D !!(condition);                =
              \
> >          |                                ^~~~~~~~~
> >    1 warning generated.
>
> Nice catch from the bot. It's a new added sanity check in V3 just
> in case the swap count maybe grow larger than UINT_MAX, which should
> never happen, but just in case.
>
> I really should just use the existing helper macro for that:

With this fix up.

Acked-by: Chris Li <chrisl@kernel.org>

Chris

>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 801d8092be51..34b38255f72a 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1624,7 +1624,7 @@ static int __swap_cluster_dup_entry(struct swap_clu=
ster_info *ci,
>                 }
>         } else if (count =3D=3D SWP_TB_COUNT_MAX) {
>                 VM_WARN_ON_ONCE(ci->extend_table[ci_off] >=3D
> -                               (BIT(BITS_PER_TYPE(ci->extend_table[0])))=
 - 1);
> +                               type_max(typeof(ci->extend_table[0])));
>                 ++ci->extend_table[ci_off];
>         } else {
>                 /* Never happens unless counting went wrong */
>

