Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65282606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 13:18:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2E5C6B05B1; Wed, 18 Nov 2026 08:18:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F05E76B05B2; Wed, 18 Nov 2026 08:18:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E436C6B05B3; Wed, 18 Nov 2026 08:18:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C325B6B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:18:42 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4957E4071F
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:18:42 +0000 (UTC)
X-FDA: 85448294484.29.415997C
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2D8F3120009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:18:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795007920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=upd0IxCj2792Sd+Vd6lDIAbHvUW1f3kpvaia8Zd/3Ck=;
	b=AqUVz0B+Dhhk0UON+Ez82r2F7QC+OkqdF7ETBEtKGbXjOB7KaQ8kZrZnHZqn9MSmGWvn0y
	SZ+Y0tm00yao+byyOxsjuy8gWSl9Y2j7VEv15hCvi3uWzWrupMvUs+qCxY7RHp2+fAE5kO
	5FYttS0uHMeApQdLxlw8xQP9UGw0XRg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795007920;
	b=YpMa2pfb4FlNyba1MM7KCwKKTPIO+V9s/L2D2uNSfxL4/b4oapOS1+v6BxQOirczCEbUzK
	LqxfKpyuto8zawpRAw9Kn+QZg3+TGmkEIbNZF3HKdXaDdu/zm9kRMZ32FMFbpdNt/6CP1D
	ouBz+KPPp991p7jC/fEVSZyAoiSqsjs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
X-UUID: 8c311e00e35211f19a56ed5b684f684d-20261118
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:8e9c81ca-96b8-4040-b02f-cb5bf20b073f,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:8e9c81ca-96b8-4040-b02f-cb5bf20b073f,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:590b889ced8d4f83e2e07ffedd64af85,BulkI
	D:261118093247FQF070YS,BulkQuantity:2,SF:17|19|38|64|66|78|80|81|82|83|102
	|127|136|153|841|865|898,TC:nil,Content:0|15|16|50|99,EDM:-3|-100,IP:-2,UR
	L:99|1,File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1
	,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8c311e00e35211f19a56ed5b684f684d-20261118
X-User: lienze@kylinos.cn
Received: from [192.168.3.106] [(111.193.136.161)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 603697062; Wed, 18 Nov 2026 21:18:30 +0800
Message-ID: <06e16d01-328b-4267-902b-1b4821139029@kylinos.cn>
Date: Wed, 18 Nov 2026 21:18:26 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/damon/paddr: avoid truncation warning in high-address
 KUnit test
To: Aveline Noir <jm5905938@gmail.com>, SJ Park <sj@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Justin Stitt <justinstitt@google.com>, linux-kernel@vger.kernel.org,
 Linux Memory Management List <linux-mm@kvack.org>,
 kernel test robot <lkp@intel.com>, llvm@lists.linux.dev,
 mm-commits@vger.kernel.org, Bill Wendling <morbo@google.com>,
 Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>, oe-kbuild-all@lists.linux.dev,
 rdunlap@infradead.org, sashiko-bot@kernel.org,
 sashiko-reviews@lists.linux.dev
References: <20261118-fix-damon-paddr-sparse-20261118-v1-1-3a0e943406d5@gmail.com>
Content-Language: en-US
From: Enze Li <lienze@kylinos.cn>
In-Reply-To: <20261118-fix-damon-paddr-sparse-20261118-v1-1-3a0e943406d5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: m7eojsh5ywefrks1uebycnqumhxrww6m
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D8F3120009
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795007917-754748
X-HE-Meta: U2FsdGVkX18zetBCyXWEN8N70N85CpwIiUtqowuvXOuJqj9jOJPlA+8FURHPEb+FBHe3Pxb9kvisQard1lK89ir2SZ482pWYSCYnJjqZoTKS0hkO7DueA62PtL/UGI0rL7AU+mS/lsSOijg6lBKEWhgdmh7sghCzJ/WslbReHs5D5VrOSXBOYmRTCnKHq6DRL1qVebOVtGHzYdUg4D/twEoaXD3k4YVSKTQ24jVkDPReoIYCx747j9LTT/UouIMYS+cCJSTaTWhFBGTlWIrKL0G+N1KM9K8yzUcDqlV889RN4VUPvtFhrTncF3Ieao5ocXiPWU2LF0tTEn0MRES2I+0FOHMUt83vhWQhCLcXR7lyCr/rP57jy/GZO+Z3BqKuXD/ZTgLN+kAGNW94tApWjOyNSK7Mx6pjPmFTD700jZ0G+W7rv6VJg1VtKuLUFOXf7oTSDY9VzRuB24Q8vgvXhJQL18xPFB9aCVVn853EQFkuXJ1lkj2QbsplLG1I3T1j/u8FAkT0Z+nkU5mIfFmkhPmNjVW8qXJNizYvBPy2LBDmUTjyoy6NW8xkhmbvz/dzaamvUW45F3T7Sq9LPI5qwa79uGWcqOJE/NRe91g0U/uIEwf39vK73lkPu1JTn0V8zTTgTtSlvR4h8EnGDOP8cSR/QK4b6iXTivNgNI1uSoOWp7djDofxkIyfkUdnKReq7KRB4QHyqoXn0ZbXaNz4W6uvPw446qePpFguvt1Uu2Iz+FQD0Fji0bHxtjB9PLxBYyCkfJkd8+ZP4IrP9NYGmRSynY1ET6wYH+MwxSXHc1fJPhwIUUaAMxpJgVjCrIGDUfVgjn2Pqukm230289fG7H18d7tlUYNmxa7mlyF+CPew+nzPMX0veoAyO07jai9DhtoibiQ6pBZ1bNu6UPv5fxrxK4wTR8hhCHaMm8ohr5tH5ZB3yKQVj6zTE99FqiBDkWNCx7PQ7QiJDwmyccg
 /fRixGXt
 1seXRM5a2QRkAbvtM5NQXL/cukiAEXRcdFiF27dM9czAkYRYbzXq8VvHkpzclht3jAfVASJz7econiJPb9E+dkDK00uOuk3rxUeuliDxwX+aH/+t/I8UFy12uog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/11/18 01:04, Aveline Noir wrote:
> Hi SJ, Andrew,
> 
> The kernel test robot caught this issue in my earlier addr_unit KUnit
> patch. Feel free to fold this fix into that patch.
> 
> Thanks,
> Aveline Noir
> 
> -- >8 --
> When phys_addr_t is 32-bit, Sparse warns about truncating the u64 address
> passed to damon_pa_core_addr() in damon_test_pa_addr_over_4g().  The
> runtime kunit_skip() does not prevent Sparse from checking that
> conversion.
> 
> Compile the high-address assertions only with CONFIG_PHYS_ADDR_T_64BIT,
> and keep the test skipped otherwise.
> 
> Fixes: 7a983cc1b573 ("mm/damon/paddr: add KUnit tests for addr_unit conversion")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/20261117170155.fEdeuuhm-lkp@intel.com/
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>

Reviewed-by: Enze Li <lienze@kylinos.cn>

Thanks,
Enze

> ---
> The reported warning is gone with the original i386 config, Clang 22.1.8
> and Sparse v0.6.5-rc1-21-g84ec0658. All executed DAMON KUnit tests passed
> on x86_64 and i386 with and without PAE; the high-address case skips
> without PAE.
> ---
>  mm/damon/tests/paddr-kunit.h | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/damon/tests/paddr-kunit.h b/mm/damon/tests/paddr-kunit.h
> index 9839cc233071..2b11f0e67a12 100644
> --- a/mm/damon/tests/paddr-kunit.h
> +++ b/mm/damon/tests/paddr-kunit.h
> @@ -26,15 +26,16 @@ static void damon_test_pa_core_addr(struct kunit *test)
>  
>  static void damon_test_pa_addr_over_4g(struct kunit *test)
>  {
> +#ifdef CONFIG_PHYS_ADDR_T_64BIT
>  	unsigned long addr = 0xffffffffUL;
>  	unsigned long addr_unit = 0x1000;
>  	u64 pa = 0xffffffff000ULL;
>  
> -	if (!IS_ENABLED(CONFIG_PHYS_ADDR_T_64BIT))
> -		kunit_skip(test, "phys_addr_t is 32-bit");
> -
>  	KUNIT_EXPECT_EQ(test, damon_pa_phys_addr(addr, addr_unit), pa);
>  	KUNIT_EXPECT_EQ(test, damon_pa_core_addr(pa, addr_unit), addr);
> +#else
> +	kunit_skip(test, "phys_addr_t is 32-bit");
> +#endif
>  }
>  
>  static struct kunit_case damon_paddr_test_cases[] = {
> 
> ---
> base-commit: 7a983cc1b57309a875a9e07a934c9944bf3d088d
> change-id: 20261118-fix-damon-paddr-sparse-20261118-fb08902768d7


