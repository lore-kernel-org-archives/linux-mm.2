Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28AE4EA8545
	for <linux-mm@archiver.kernel.org>; Sun,  8 Mar 2026 21:19:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 534326B0005; Sun,  8 Mar 2026 17:19:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E2116B0089; Sun,  8 Mar 2026 17:19:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 418326B008A; Sun,  8 Mar 2026 17:19:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 31B236B0005
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 17:19:45 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BBFF81A05E9
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 21:19:44 +0000 (UTC)
X-FDA: 84524162688.09.4DDB450
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 13BD8120004
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 21:19:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=diu2qG3H;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773004783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TZDfUSd42qO2Pu4OJ3PBtuuAfumyJRopBTfWK9tpKG0=;
	b=Sx2aVFVs0tC4TWn1CWlXrjog9qDVzefe6TMw+m4zGrXTCs/MbjUTMFrxzxdLyOw/CaKUlI
	nVZkH0fX4jwcdUdJuZjWhnT2/F9HFl/73P2T6xd8usJTL4hcqD+7TzW9VNn6CriFuPBNkA
	Q4F4ylQuRfP3ImxRZ1yk3ygiVqeYq+o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773004783; a=rsa-sha256;
	cv=none;
	b=8SDHbwoVbeAKbowDJXAuBOmqb9oWavBYMoswpa2YPCRrlUFG50eunmh3WAe3ElvVRdlBtF
	Njeeg8qY4EQ7BpJthDXkpZJJBVLh9MTQyPrWybhg0E27HrhS6BFARzYFWy2HgR0nqpJIt4
	jIXu0oA+EqC++cYOxyGwSNFD+BYUTPo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=diu2qG3H;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BCE9B404B8;
	Sun,  8 Mar 2026 21:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69EF0C116C6;
	Sun,  8 Mar 2026 21:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773004781;
	bh=KaIM6uppfpewOmxL9KYkE+WipHc364p2EAFsaV09DXc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=diu2qG3H0beC7fhBLaYTjH7wGD9ALJfbw9xBRm2G8HcuBpZHIivqkJYjptqysymlf
	 Pbh5bRigRx5FnAQHYOBvrc9TaAdmiZ5UvGty67+/iyXE3i6kUgeoAQLxSSWpzJXT6V
	 sgdA/ebUTaW/6zYM4n3ukhizzROyEv8TwzfstAJs=
Date: Sun, 8 Mar 2026 14:19:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Jianhui Zhou <jianhuizzzzz@gmail.com>, llvm@lists.linux.dev,
 oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>, Linux
 Memory Management List <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-unstable 34/207] fs/binfmt_elf.c:1140:17: warning:
 implicit conversion from 'unsigned long long' to 'unsigned long' changes
 value from 4294967296 to 0
Message-Id: <20260308141940.0cfd8a176e643b3a6ce49f1f@linux-foundation.org>
In-Reply-To: <202603072018.Dl1xONhs-lkp@intel.com>
References: <202603072018.Dl1xONhs-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: c8jahyo9hhcnmkp8qo4yuk196yf5hnpk
X-Rspamd-Queue-Id: 13BD8120004
X-Rspamd-Server: rspam03
X-HE-Tag: 1773004782-405095
X-HE-Meta: U2FsdGVkX1+A3z9+rQgevIubfQcOOazS/MlHwrJ5IN+LrWInacRjsINdjEirFYUFIKuQc3kUXcymE8UgJIbtFNtIcnHC2O1dth692MTFZPKfGP78vgCTBRg1lkg39Xa5oGNbnQMefgxMOPnhuZ84iGQ+AbWGCXOk5CJmDBcP2yp81rdsf3P/SdqvyXNCGeqskxHO1Zcxy+wDzbKcsfsG/aBPykx1SdqnEVPPpKlGeYaugCQAQlE6BXT7EvJIl0/f2wwszpf2LlE9ypHjMRad1DgpJ7IeeXUuSIehj2s0kilHuN3zFXwcg1gTgQqddqwhI2xNQplGK2W50M5MNtwtxMws5rqISXMquvgaI33Xx5K93Kw1DKPra2NNXzWrgNGP1u/qdGp6HDcBr89Ajva7TET+bUFflVTmkLPV3eonz3qsgpuCwNTvsRU/pgSefENFCF4d+eyd9qz8e7frsZ7UwdDCQjNntN9ve9DdR1HaNZ7OFR4bn2pCzuAEB1EbyBexDQ6o1J3b7kIS817sgrIl4cjSHfkGGxsmY4RZzQ4MZ3kMdbBxfktir+4dDFMpwvOQOvyyiaBVcMzDQW0X1jgzf7edewCrNQf10ytbTxi4q8R429hfkGnr89bJ2jZYFypMHKCGfd0cjICBUOdg27wxWd4QRbEy9P8mmtVhcPsyUzehGVx+Vl2sPfef7pz1h1YThe8w4zBG/qrFNQBKYcLCkkf2l2Y7Y4kQ8i61fkBog1cfJz3yza3KpIpt2cuUU7Q4B/TY7C+5fju7sXmrvhi3+g53qJXGBCs3Zr9cpSM40p4OXrumn/OFSPnLtWymrQ7QwSmCe+kFj20ZyDXuxQtF4n/HI561J6ecUnLBtHTWpH+lgtoM9pvEnsiXu46dV0QLrW3lGZYr9XPrkfM4+1+f2NCv3OLrlqwyXOyWBpC50PzfHzU8wPzER4Tt/uS3tS7iU8Vf5b9dFlKnthWg3m4
 I7vNAs1o
 DRwiAjyyzElMTVVAqUnYdi+1D5dP7YzwO/LkXYzPYlcUWvj2cPgQdMgVyMfgYSeNdOlmLVfW4p/tNe/+qxnmV+AQscp2Vk/cLfk3zpPQ2+c+hmqT6cEXvFFcDrHg7EOU685eijBmK5yF0eaCvuccrEZGS51hdPjtRQ4IgTPuWLqcD5lxWWOVXtFJQKQ28b5BoCDHsn3sUveo5IwAm/rM6rM0u+MM/RnIDGsBlKVNnLbjTp7SdC7hjfMO38vBovweG0SmxZPnl3Ve55fF5MdtRZdg2cEzWcE3koFoaZYghA6DF0hJrXjC2Ks9TpLZj1fGwRybSI4mP97ZcHdKzHjReonccS/wCGR0kWawj81tNtGBTZ2UoRTYQpnHbVALP4nFucEZ7i8ZZbj8XDt3LuYGToNkdGnlKfT484c3MEjqMrpS84//ZUL8SfDwMZm5drkOe7ucS4rla8Qu5hMk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 07 Mar 2026 20:21:02 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   49cb736d092aaa856283e33b78ec3afb3964d82f
> commit: cd9119a9480d9d93fdf06792f8f9917cc4f9999c [34/207] mm/userfaultfd: fix hugetlb fault mutex hash calculation
> config: powerpc-currituck_defconfig (https://download.01.org/0day-ci/archive/20260307/202603072018.Dl1xONhs-lkp@intel.com/config)
> compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project c32caeec8158d634bb71ab8911a6031248b9fc47)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260307/202603072018.Dl1xONhs-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202603072018.Dl1xONhs-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
>    In file included from fs/binfmt_elf.c:31:
>    include/linux/hugetlb.h:1214:9: error: call to undeclared function 'linear_page_index'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>     1214 |         return linear_page_index(vma, address);
>          |                ^
>    In file included from fs/binfmt_elf.c:32:

Thanks, I expect v2 will fix this.

--- a/include/linux/hugetlb.h~mm-userfaultfd-fix-hugetlb-fault-mutex-hash-calculation-v2
+++ a/include/linux/hugetlb.h
@@ -1208,12 +1208,6 @@ static inline unsigned int huge_page_shi
 	return PAGE_SHIFT;
 }
 
-static inline pgoff_t vma_hugecache_offset(struct hstate *h,
-		struct vm_area_struct *vma, unsigned long address)
-{
-	return linear_page_index(vma, address);
-}
-
 static inline bool hstate_is_gigantic(struct hstate *h)
 {
 	return false;
_


