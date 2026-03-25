Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A17AFEA801
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 03:27:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFF286B0005; Tue, 24 Mar 2026 23:27:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB05C6B0089; Tue, 24 Mar 2026 23:27:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC5E26B008A; Tue, 24 Mar 2026 23:27:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AABCF6B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 23:27:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5A38B140595
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:27:58 +0000 (UTC)
X-FDA: 84583151436.15.89DC95E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7894FA0008
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:27:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qpqwWuBR;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774409276; a=rsa-sha256;
	cv=none;
	b=FaAjU/jl7DZx61fwcWH2ifaorF/+AEzMRQ9MDIwLn0sL/LAg83tSulr5E+vggX9gQ1oUiV
	yD0nSTZIWUjRCQI9uM4g1WkTZ8ZERey/6dX/w1W5kYCz2Up7xrYYvSSC7hN/N1dizZCRZp
	8zknR0FZvEghfBP+IgZIOqgWJOzOJ1E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qpqwWuBR;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774409276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3KNCg4692U/NPDrYLr9UzE8knKzKWIU8vIVuc0+6I9Y=;
	b=01pA11nSRy0rF9SsJmWSpeB/IgoQ/dSW72tWsN3HCutxXgT+Z6X8TaEZRekZmvKDx9VXaO
	CI88n/30IM2SQjK1LTBygphxW3kpUkSQgTfM3bumbZC2i797u/+/vU0AG14CFZLhaawWfv
	cNMsCOe1OrY0/rWQps7OcbkA4r8xUAQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 69A65419C1;
	Wed, 25 Mar 2026 03:27:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BC9C19424;
	Wed, 25 Mar 2026 03:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774409275;
	bh=XQI3pacTwDOUH6lX17s48Hb/r1GQJZ4G3TPuumMTRyM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qpqwWuBRgrwruqyXWeUn97gPCvrjWcjAahESuSpINPeyeq2CDtNpXwmhX6NHFaUwl
	 AzVf1ZxljVPoWSoJbVatbfJDUEq8ZWMdLb4Xk7Zp55tKadTu5iaEk0XG48h1D36fqm
	 nYV4h+kIM45nZUaxP+V+9Ax+XZQvVnwIWK0/uxv0=
Date: Tue, 24 Mar 2026 20:27:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Chengkaitao <chengkaitao@kylinos.cn>, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-stable 72/140] arch/sparc/mm/init_64.c:2582:16:
 error: implicit declaration of function 'vmemmap_pgd_populate'; did you
 mean 'vmemmap_populate'?
Message-Id: <20260324202754.6f29c4f6530ec7ea9d1f753d@linux-foundation.org>
In-Reply-To: <202603251147.CtgepAeH-lkp@intel.com>
References: <202603251147.CtgepAeH-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: edpjd66rjiun5keuhor3yq8ujt9h3f8j
X-Rspamd-Queue-Id: 7894FA0008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774409276-821199
X-HE-Meta: U2FsdGVkX191nvsMQB4umd7PRye/5aN5XAUzWi2Wjv1uKPCPII3AJVlRx3bmingogfCfeYmmwIEb1mnCPMsgQF76SaLVxiVVlYqI3M41VKkObtFzFTg7Z6UEoNaM0FWaZAoNmbUl2UOkBsRugScCfDjVu+WkgzBuqnY2cxiAS+rs6bz6jbBrE4MrE+syt2Z3xx78XctClon0DbPyqd2qfKOYgowpPK78CEMBI9FxttVuOSfXHc/vFBfUh/mGYQ/1+ToBK2clmAgZAWxu/G7wYvhmRZS0plidop6dJQ/B3mKnDablvmWj2Cjg3Ic3sQQi3YNoX6y5sQBHW8669wL6Xul/+kEqc2yFpezt9/0tkQZM8yBzaedbP1Oa5DmfEClq5CuOs5xgvb+phgSnrjvd56dku5Wp/34XEmtLBIB+thoc+ODcmDgwBHUYq6mG8IsXRfJ71hfY4nQaj1lZyhvKYwd2cuaBNwfmP7hTpnY0B2R7jiU0FwyyjjprCfRVLsEXbK8hLCWGlta3kKvPe+7Uhe/GvLsssrpXdKBKyX1QtNAbrGgrz+5EgDy+FibZlIOSaf8o+FPQhlVRJCoI1ThMa4btYgh8mboQ6FrdZpmsw9ljMSwFzbKhOXftcCNateYGL6wVoFLrXvSjA8msVqaevUSdlyC0R5cHTUri2QPQ315mp9hRNcNATRpnxrs38+WosiuNu8fPqyc/UQ3K+Qft53uqKU3qJKVhuotKXtU4O/3xlagv2IQShELuvYP6+QA1xcUjMdIdSUKdt2vJzlWx6tQAgnMTBWfkaMNW8H7fszMMNv3Igq9NWloK5cbtaTQom26cHFIiF8oUpZ9yeRbZMXP8PS8k2SERdWgpCIR7IXG9sNnOakolJrdoKYguKtaKWGdSV0SS1oDbun43mn0qm8yoBeRKpbi8X2DXdgSu0LJVes0qYqGc+T07F9fMV7aPAwU2gDC9PLHjom7Mduv
 DlE0YyiE
 k9mh6GsxtU502zcqR2BHi7xJ7/d83Ws0yDFjdwT6RVquN5kyQ/Z6eUnn+rGOIFzb77914cpc0redX9vxQEQA6cXN2BcG3BvGEo+Y9v40Hw3vv6UgO8lVM6c4ezOhZuqsqqUW/Cou0Iix65u/OKv7AYdAY2hce263u7WB91k5KvdWHAKHYfiSQjcz2IlXCSvmaVSDeAYUdFFL1gH1+B45uaVKgSqFseOCFlO5XTQpHN/V1xpeWsNoN5KJ9ayZcQlSAS4g5vVGXxdVCSQTUp9AkVvWR6bTYeuKmeSmj2XsVA20bxqzCM8cdZZbwptjb8bD1ySUpkkTWwR19nKRreJIZv9Of5ySNsZqCdZqc/Bwn/kMB+ltq6NU4WvqIwqAuyqUuCKawixKdTc7FhqzIhvKJkajjOOYu8hk3w4Aejwg688h4Ba4N0yV2yleU7xWQlULwsiE3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 11:10:49 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-stable
> head:   e393ce79b3cf63c2810be882eb6e531a54f520f4
> commit: e504282091c8e4dc4f945c89d9b44ac2e0bfe504 [72/140] mm: convert vmemmap_p?d_populate() to static functions
> config: sparc-randconfig-001-20260325 (https://download.01.org/0day-ci/archive/20260325/202603251147.CtgepAeH-lkp@intel.com/config)
> compiler: sparc64-linux-gcc (GCC) 8.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260325/202603251147.CtgepAeH-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202603251147.CtgepAeH-lkp@intel.com/
> 
> All error/warnings (new ones prefixed by >>):
> 
>    arch/sparc/mm/init_64.c: In function 'sun4v_linear_pte_xor_finalize':
>    arch/sparc/mm/init_64.c:2202:16: warning: variable 'pagecv_flag' set but not used [-Wunused-but-set-variable]
>      unsigned long pagecv_flag;
>                    ^~~~~~~~~~~
>    arch/sparc/mm/init_64.c: In function 'vmemmap_populate':
> >> arch/sparc/mm/init_64.c:2582:16: error: implicit declaration of function 'vmemmap_pgd_populate'; did you mean 'vmemmap_populate'? [-Werror=implicit-function-declaration]
>       pgd_t *pgd = vmemmap_pgd_populate(vstart, node);
>                    ^~~~~~~~~~~~~~~~~~~~

Oh fecal matter.  Seven weeks in mm.git and then seven milliseconds
after I move it into mm-stable, we get this.

The coincidence is too great.  I assume Kernel Test Robot is somehow
treating the mm-stable differently from other branches?  Can we please
not do that?

Thanks, I dropped the patch.  Chengkaitao, please redo and resend after
7.1-rc1.


