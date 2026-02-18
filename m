Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60224E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 12:23:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 960E36B0088; Wed, 18 Feb 2026 07:23:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9178D6B008A; Wed, 18 Feb 2026 07:23:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8462C6B0088; Wed, 18 Feb 2026 07:23:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 71B806B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 07:23:07 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 10DE91BC50
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 12:23:07 +0000 (UTC)
X-FDA: 84457492014.01.C19C0A0
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3E2AD40008
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 12:23:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cd9n4auo;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771417385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x/l1g6wqb0NZRc7ZX34WwaHpuKkAAz4lIDkW1nuJe3Y=;
	b=ecJfUiEcIi27hQ6kjasRNE2wR/fJsUs7wX8dFQH11aUVdQ6FqWrQesse0gl7trOHf4rLTe
	NTmE3yyVRCtihsHMOozLY5nJOPaQecQ+w6iTCtS214MzUWV+AA+n7+gEjIPDen+2U04CIA
	FEyA+2lf9ih6afss3uyldzNBEdGHDjg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cd9n4auo;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771417385; a=rsa-sha256;
	cv=none;
	b=DmsQeO3sNrov5WacGH0Bk5b2n81MwS7YCK8K61Fb0SozHVPvYxcUhIba5ciP7W0kaGKSM0
	F/yFJLCTzQYuafpqp7QSedliET5Xfpq4LIvH1bnIZ/DmTjieJxLEi9RN+/4q/B1N4APwpL
	KVQW84cbKRWiHtU6K3XKsvmjEI0H4o8=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2a95de4b5cbso48161695ad.1
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 04:23:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771417383; x=1772022183; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x/l1g6wqb0NZRc7ZX34WwaHpuKkAAz4lIDkW1nuJe3Y=;
        b=cd9n4auouxyOXFc0P5zvIft9CotQHYer78AN3q5KH8aCiDFM+C+Oy7zdNuRCr0+wfm
         EiXPV1XQXSFVqLfVC45xIk/5d0Dh6BocXf+0t6Q9BiK2IxDmzV0TzsyEdEk1775l/8Lv
         mlzryUQHJaMA3Yf54BpGTrOhG8HT0Z3MSj7aFyDtH3fYzNxEv+sIzCPomf86gTeH7OZb
         EmlBZ4dcgrXoiNvZcbIy5Ya/nZRD7vfH08yN4Eqo7ASL8wIj8e27nHvPgiDyNDAV6n08
         oPW0gnSNEtG0dNpa02J71IBMunjTol5ycnJ8DpGiX5l8o41pBsoa8r/MVvoLi/H+xfxU
         hgww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771417383; x=1772022183;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x/l1g6wqb0NZRc7ZX34WwaHpuKkAAz4lIDkW1nuJe3Y=;
        b=O4MC8nF5W7z2uH2knRDvHEqFvqz9DxtFZl7AnArU/o5ti+NFptw4P+ilPWaj3AluaJ
         LzFqDZvvqH7eZMjCPqwCaGTEPnOS9MouCxE9Ai7VH5SE69WpdSVM9NfwDtHexObdQ+q+
         tvyKKi4FtQLNCvgn00MqKJqLRaiPPpnmqslqSQGZsZ0gpvssQ0OvFFBaypaGaJQUE26j
         eW+CNMdLxoqfyQHhv98kyY7MAn8mqMOdurOOz2NWsn9JpSagq2N3Rt59vU+1IE3GSght
         sRLPfcfpkvSe6SS89Nud2yJoEkGC6kWl24YlCeY0090GT3lBzCF4r9aarOotJZRD5WtC
         Vqjg==
X-Gm-Message-State: AOJu0YwaUg8nzKnQQi73ToavMhQHAW5qaCWdZyFsb1WA+F5NMxGEDKQU
	NapGxCGT66PhuLcWiW4W1c7haDevLSq+DHx26LZTVc9uH++bMHld6F7lbaiXgQgNOeI=
X-Gm-Gg: AZuq6aI+toGcMueEalg4JRj8LLQjkMEbOw6VIs4xW8YCDtLbAmZr+xl0fOL+GzaJqrM
	cuxPdRpC/feTp2C+Z8XdBOMvvA1okuXntXpW08zuUAtzfIHzV1acgW1EnI+pkKVWw4gIjvqss89
	KeYIfSQISnKnrbSe8vruhY95/JAZisst0Q+/YkMAn/XdqjoSWO5KgJPieeg2UZjx4I1B/c1I/aG
	FCj+pgUMSkNqtaf54TVKjToT8LtVesueKxG9bWkj5/c4ukchZdZg9Ub5a3luaKv/F5RKO3ppWAj
	2v2SWU4HIuImzzBt9iadgPLn5e+vsVUAP4dAiZLARZ3rsWGatbZn8KKPJ1E6D3yfvZdHTY7bouk
	zBacuQ3K2EMsbT0s3Ij5Gb3lYhU5JoAB84JJEHOLq81mjK/GIpMO9cGR2Hn5Ek4Xa9GJoGc+soY
	HYefdVForGtP+7WoBT7/0GM/5Xd6LhxKr2ohWP/yaeEPiQpXHlIYTJ1xOMhaE=
X-Received: by 2002:a17:902:cccf:b0:2a7:5751:5b30 with SMTP id d9443c01a7336-2ab4cf4f481mr176018015ad.12.1771417383553;
        Wed, 18 Feb 2026 04:23:03 -0800 (PST)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-358878c2a52sm1180707a91.6.2026.02.18.04.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 04:23:02 -0800 (PST)
Date: Wed, 18 Feb 2026 20:22:54 +0800
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org, kernel test robot <lkp@intel.com>
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>, 
	llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Youngjun Park <youngjun.park@lge.com>, 
	linux-kernel@vger.kernel.org, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v3 09/12] mm, swap: use the swap table to track the swap
 count
Message-ID: <aZWuLZi-vYi3vAWe@KASONG-MC4>
References: <20260218-swap-table-p3-v3-9-f4e34be021a7@tencent.com>
 <202602181835.58TEynxc-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202602181835.58TEynxc-lkp@intel.com>
X-Stat-Signature: psw4kyrfiirhe435n93fbkziuue3cyzb
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E2AD40008
X-Rspamd-Server: rspam01
X-HE-Tag: 1771417385-73970
X-HE-Meta: U2FsdGVkX18lsdIiZSGNnCU/q9YbtVOofp0qxs3RHzPEy56uJA4lKkU3MRmvxbn4uqoj5BYEW5yzQcSe1YK9coLtZZG6WIjJjzLw1depi7rvLuZbNIs6T4JBUUNatY2QsZa4p5Mc1bkxFgMRmLFy+IZ1Angd6yFQrjSNcpPgnPbfhjbHngpo6BPtk8Ficko5P2R9b+n6nSZLEbf8ilPqpWCK1hgyDMjWqKEDFdA5EPjyvD9d265WO4fTLLoJWWyvPso/lW329ljprD27DUpv/bpExR/776si45kBpT2QCHuKTih9qnosPC1y6V5p5Sfjop9A0kRshURGsOnvj1jjCEF/kmE6WKyMXUjILgSrKZuir1/IzBX3pj8ckgcIyJ2yd12WmuZgiXV26w7S1Y8B089lVQw67bwTIvseERwiaC4Fbg7yyYYioOdFBrHR+BUlhZ8sKh4z/Sp/P/83hod23iMDtzm30vSBI7+vcnGu4rw07KfOYtXQvvvfx0tPBkUpUPA80OUGg5sk5m32wXX63uoJ9ZE+kRnO5J5CG3Sept/52f3aWIdaZlwnCrDBh5FvZFoq7z798bRiTUseSKDQHmBlsTAXjrqZoNgur64885rZpiGT9ZkSUprousBPDMf9k1e0VBrx2YNTv9dL3CVgG6G2D+jGY/Sgzg/TmLW1zWi2fHnwN8I/PcSSrl2SB1t5kEmMRX2uNRvYMw+Vlk5LrKsWxkpD9nGwvccIwrVyw+nClAniQELenTHRYJMsGgYX7a69/mMruLeGyJj3FtLl8nHDE56d4GbbftN7cWLTKpZA39SidTRfnmrxGQujCgf0I5GDL1oynMmsioOW58NDAGIWcUyUwBPfidHJsLC9X8fiCl7HcTFsvjX+/yPiZfHvzGDviN1r/PWkn0EawZiTAsdQZaF4wo8B08SgKW2YRcPfE9snEqr1ADSAoyW8h+C9WpX8tq5IIHd7zJPFOGF
 1YvV9OvB
 3EVH8qpJhJ4uWMAYnyEsN9lnZh9eRkW62Ku9qjkO3p7C1rrQqy7njqv2ZTgFHxwdtQNGQjF2NSVIT8kGZSM+2DOfN3dFOtJcIbd7wjtF/PjtTlr4oCNpNUa/5+zNcTLBfbAlR7quT2JQSQ7eWRniIVRI/gcf3RpyMb6y74Hx2kXI2Hm5jn1uY1xhesaz+tKD+q2RBZzw3brJBH3Tq+lts/K7vbOcXLRs+zHIpBxyK0kOJ2bGGDkqDJ3uR4HqvBGpgAvQ23lj27hD4SDbcPsJ2vWt3h93BQMlfWRz6XQVafujkWGtQi1WTrFIiDRuz/oQ4yQgHfhrmqSAWgpNpah23xLuwzRbkUaZbgBlkUTOlXZnsU2DVS4d/19PQWEW0AMMQ3vYfVwv5JgtQ/w5EyE1ez7Wm8a0M2T8Z/HcnzlvjrJodV76kYMt6hC0Lh8ELaKEI4nEwKX1vKt3oH/ZVwbtuCGG1KXkAV/HzKcQgy6agG0Tn6vOiz6tx2rEudZlrJxGVxzjqQHtueAsZse2QC9ia0wFK5aj0AoR7f30m4TypQDMdNrL3mwgjAgnBIGTPg0C0uI/Y/SbS4PjwYU55sS5EwtyPgutetGtBW8Z8TZNxbD2bmWK6EGYCBydnI9KRKRQXemAw3XjBvcvru2RI+ekS44QQ7BnkKYGY38mrUfnpoV/9bqU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 06:40:16PM +0800, kernel test robot wrote:
> Hi Kairui,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on d9982f38eb6e9a0cb6bdd1116cc87f75a1084aad]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Kairui-Song-via-B4-Relay/mm-swap-protect-si-swap_file-properly-and-use-as-a-mount-indicator/20260218-040852
> base:   d9982f38eb6e9a0cb6bdd1116cc87f75a1084aad
> patch link:    https://lore.kernel.org/r/20260218-swap-table-p3-v3-9-f4e34be021a7%40tencent.com
> patch subject: [PATCH v3 09/12] mm, swap: use the swap table to track the swap count
> config: i386-buildonly-randconfig-001-20260218 (https://download.01.org/0day-ci/archive/20260218/202602181835.58TEynxc-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260218/202602181835.58TEynxc-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202602181835.58TEynxc-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
> >> mm/swapfile.c:1627:6: warning: shift count >= width of type [-Wshift-count-overflow]
>     1626 |                 VM_WARN_ON_ONCE(ci->extend_table[ci_off] >=
>          |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     1627 |                                 (BIT(BITS_PER_TYPE(ci->extend_table[0]))) - 1);
>          |                                 ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    include/vdso/bits.h:7:26: note: expanded from macro 'BIT'
>        7 | #define BIT(nr)                 (UL(1) << (nr))
>          |                                        ^
>    include/linux/mmdebug.h:123:50: note: expanded from macro 'VM_WARN_ON_ONCE'
>      123 | #define VM_WARN_ON_ONCE(cond) (void)WARN_ON_ONCE(cond)
>          |                                     ~~~~~~~~~~~~~^~~~~
>    include/asm-generic/bug.h:120:25: note: expanded from macro 'WARN_ON_ONCE'
>      120 |         int __ret_warn_on = !!(condition);                              \
>          |                                ^~~~~~~~~
>    1 warning generated.

Nice catch from the bot. It's a new added sanity check in V3 just
in case the swap count maybe grow larger than UINT_MAX, which should
never happen, but just in case.

I really should just use the existing helper macro for that:

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 801d8092be51..34b38255f72a 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1624,7 +1624,7 @@ static int __swap_cluster_dup_entry(struct swap_cluster_info *ci,
                }
        } else if (count == SWP_TB_COUNT_MAX) {
                VM_WARN_ON_ONCE(ci->extend_table[ci_off] >=
-                               (BIT(BITS_PER_TYPE(ci->extend_table[0]))) - 1);
+                               type_max(typeof(ci->extend_table[0])));
                ++ci->extend_table[ci_off];
        } else {
                /* Never happens unless counting went wrong */

