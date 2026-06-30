Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 589E4C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 18:41:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D96676B00A6; Tue, 30 Jun 2026 14:41:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D476D6B00A8; Tue, 30 Jun 2026 14:41:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C377F6B00A9; Tue, 30 Jun 2026 14:41:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D8716B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:41:26 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1FCCEA05B8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 18:41:26 +0000 (UTC)
X-FDA: 84937446972.26.B87C803
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 64E6CC0007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 18:41:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QzMu861D;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782844884;
	b=zsZgjO6o85mpANU97LRyUKp3/v6K3Hf9JL1EwIp/wpKJ/8Cf4JFySzg6WZNuye2wL+yjb+
	lbz3wSbn7T6nkkJqItxCNMzcAiUdYvTewQ0ApzPWdcwWcXkmHDWDOt2E2M7yKVb0aTem4c
	z7jI3HrpwACOIfE8GxicyLdPeviAIco=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782844884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZxDMLZGmdOwaoXnC4HajV5npir5XPQg4QmBeqMX7AWA=;
	b=RVhTCdZpjcEOF5N/g0DIV1xSBeivzB+UDAgiR2RkKP9xF20bAlUFQEZbye/wWF35QSEOfV
	QXNbK9dvjMyaoiAcbk17GHhmi8W/wfxN4WyFSOEYgsz35SZa1SFxdGqn3b6fnrebY62oWs
	fMTn+/KStjpY5+z/zZF7wnnKLoYFjT4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QzMu861D;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BD72F600DA;
	Tue, 30 Jun 2026 18:41:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442851F000E9;
	Tue, 30 Jun 2026 18:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782844883;
	bh=ZxDMLZGmdOwaoXnC4HajV5npir5XPQg4QmBeqMX7AWA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QzMu861Dua4FbzXE9DZsyP5ei5Io6q8jRzzsRAe37WnViSMqxy0N9JmQqLAY7MCze
	 Pqzs/0MSJklW9EKehW17QJurH/ii/CrlCMkrwYkGrkLv2T0fFCS9Bc0Na2ThyaJeMa
	 HuzreYid5aZOtgxUIwl98dYNTY+CSvyY5eLS9ES8=
Date: Tue, 30 Jun 2026 11:41:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: David Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org, Barry Song (Xiaomi)
 <baohua@kernel.org>
Subject: Re: [akpm-mm:mm-new] BUILD SUCCESS WITH WARNING
 15654b0268cd65b4e673510c0377774e61b86397
Message-Id: <20260630114122.2a7202249ff0bc6f32df708b@linux-foundation.org>
In-Reply-To: <202607010249.92RC46mZ-lkp@intel.com>
References: <202607010249.92RC46mZ-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 64E6CC0007
X-Rspam-User: 
X-Stat-Signature: w5gtoauowfb3t3kffuejyicinby9c6d5
X-HE-Tag: 1782844884-568293
X-HE-Meta: U2FsdGVkX19bHw169Z/5y+M1lKZ+wHWsan8d/wrjPHyIvTlEUsDC1B2fXb9bCaQNO8GltLgxpx+dIipXjyNL1WJvCj91tnnU3eA6o8ljPLh/ocFxpDns8W+iLzgWxKBKCYlWh7RrGP6Q7hennF7mBo0DlfXBJlo0CfmenVZBJZxSAQCZn34xpd2zplIxqOsIioQIdMT17rHC4YDcAugk2OpYF+rmSnppEbVsVJt4vjcnmkMCuL8VVrau3zt2k350p8A1oQxEGk+5JCNPpqrLgvhk0BhH0PTik1bU+aasJ6t55JMNPGuHhgvjVvo2BnUPU6Wz+MtsF28kK6gEpxzSaMrWSISVZJxwaSQ6UGYRKj+Kth0uMPn7X2L6Y2+Pkx7KYr/LI8mesbq6dMWonQP7IYRP6pBDPDu9pWw4I0Fl0i0p9AzGhT4hjfSD+wz8Rizhzkt8iALarglLKcisiGa4UIPBva0HwGwRlSB76sH2yIxTT9PFKBJKvJdUxorslC6CtSlyCCYFpDSbFYYUt34dn+3s+Nf2H5baljeCrtMLz3wlXUyDdApePNDrCN2axctVkmKd1F7ycyQt51GZ8PdGQBeZ3ak9Y0aKLZ2BmfIvH3qKv80nzaxrjMj5NdSdh4tJrcLP9MYkmTLyNJCY+MeqmK2iIVyqaLXeU/QUbbDBq/Z31gmOvpUhPK1UvW9kjy7JzgK4LgSY/at1nT3KGvA7smSSjS5vdiOSFxS7DtcoZGZD9UvCT0mwSeGxQ64uQ4ECg2hAgjCHCmMQ6ERZim43fub12Z/jAvydO2Yp3InEhthMn8RUpp3+dNhissST9OjdRh/hSlrjdrQNdIkfVVKmmyAvwoOGzAc/QDu7EOC7P4IkT3TjQKA/hXh5zUTm/Ye/LjNm4WffEaDcIgzN/P39Ej28PQ/tO31Bl36Ezr4joxFCANsT6ovm1sxyEFZ+jZVVJ2QJ76E2evG3wje9Z89
 KsRUwiex
 dEL9KPxX78Kg/y9Fg0vQ1LBSEt/ml9aoKAjqgAPIzAZo7Gp7fNgUDMBfTLQGsT010U96ihjBEi5b61hosq5agSVPCxgzntR9mdrBHMaVKYmQETuQyML7ccm6hz5Z3Ry6j8u2h5I0fiGHSH06gBWrIAzzaArQyB5PhhVVPArCj0pzSHqoi5D9pe1gzUz0XUlqwLcuIxqdvuh0jz0pSauT1ajnp6RMVYm8Zh4HIwOSiPLBGiaaXLvL9eCS2zleGAJ3yKjipJerH9sDiPmAMQPitjykxz8Eqj6gwpxTbB7TPNBdf+tYQc2VaY6talkiwMvoEk7aLdnnxH/eGs1P5Hg8ww4PLSLUEywDOpbDoFy9q957SVwfD8uXG09gDtFXEmZ+2DjlUgyrmCCpd/+F+3ShfkHPE3baFcnJZqXUMkSiyxE0xIY6+o3ubfQKn4M8zHDUB8Jf+bdT8tV3DyoCWw/dabWvQRi+lvBrpbF/V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 01 Jul 2026 02:30:11 +0800 kernel test robot <lkp@intel.com> wrote:

> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> branch HEAD: 15654b0268cd65b4e673510c0377774e61b86397  mm/swap, PM: hibernate: atomically replace hibernation pin
> 
> Warning (recently discovered and may have been fixed):
> 
>     https://lore.kernel.org/oe-kbuild-all/202606291606.9h8aGniQ-lkp@intel.com
>     https://lore.kernel.org/oe-kbuild-all/202606291933.Cw5TBs54-lkp@intel.com
> 
>     mm/vmalloc.c:3590:16: warning: unused variable 'start' [-Wunused-variable]
>     mm/vmalloc.c:3590:23: warning: unused variable 'start' [-Wunused-variable]

Sigh, OK, I surrender.  Below.

>     mm/zsmalloc.c:1480:21: warning: 'obj_to_class_idx' defined but not used [-Wunused-function]

hm, I think I (re)fixed that one.


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible-fix
Date: Tue Jun 30 11:35:55 AM PDT 2026

avoid warnings on architectures whose flush_cache_vmap() don't reference
their args

Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Leo Yan <leo.yan@arm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Wen Jiang <jiangwen6@xiaomi.com>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmalloc.c~mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible-fix
+++ a/mm/vmalloc.c
@@ -3629,6 +3629,7 @@ static int vmap_batched(unsigned long ad
 				prot, pages + idx, prev_shift);
 
 out:
+	(void)start;	/* several archs use a macro for flush_cache_vmap() */
 	flush_cache_vmap(start, end);
 	return err;
 }
_


