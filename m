Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD60DC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 13:10:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73E9D6B0005; Wed,  8 Jul 2026 09:10:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C91D6B0088; Wed,  8 Jul 2026 09:10:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56C326B008A; Wed,  8 Jul 2026 09:10:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 265476B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:10:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A68FE1A0143
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:10:39 +0000 (UTC)
X-FDA: 84965643798.24.4151555
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id F16C420004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:10:37 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X0+8cPel;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783516238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XVbR6znNF637T9MAgobLVmsZoz7qMXfdjHyuLiDhLeU=;
	b=xE7yyqlXQkt8wS+0IWyVr5phCFNpHkZxZlFaAiD7z4/g2i0uX31SoH6qv2GaGNoy8ChMgO
	GlgMhAPHA8pMRcpGnt2dNy8PTur4DdoBOhxdH1vcdFkg4/UMV45e9bkzj34B/gVjASaJxJ
	TF3Kf4VywKfdFRXDUQE57J3mAK5oXwQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X0+8cPel;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783516238;
	b=vdVk773d1C08wrAoVzaC4+2L1DemMpa7E4G2wyC3NqsAUzg/2+vZeed6H3yWAv7wz/ttTQ
	lNK/BL7nlF1dEK/4oRwslkEyEWC8ylNMdSu7jZ6YSL92N9dtou3sLkbCJ2IToMf4HWzpem
	/3/Wrj3MUYHMdzX+3+bGnjQWBo+G82E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B53C6136D;
	Wed,  8 Jul 2026 13:10:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C5D1F000E9;
	Wed,  8 Jul 2026 13:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783516237;
	bh=XVbR6znNF637T9MAgobLVmsZoz7qMXfdjHyuLiDhLeU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=X0+8cPelmsVUM1oV9qfkrrvutBumdGTkzTk5XjIq+6Nxv952UFEV0WE1hwFN/lEdR
	 thDgQXiPP0LZ3ythiiSua63U9+jgwV4dcluGeGF3H9+1zWP3x22hKA6K3gPSkkiAij
	 2vd5CvcgynxmGndas4FjOEyBbjEf0tUGGzUdsG5i2Ert4NSKokmzxDzQjBmZG9mirr
	 sUmPtCRbrFovnNg4CImiBzuRY8tQEJOYgYcMUfXE2saapFJ+xArHATO7Dn4BS4AzGu
	 b5a+YZtS2JchD3P4W+SG86maqmyD8WWY0dkcO7fArhaLENrvXiOulr1fFY4Ona1mCT
	 l0vop9xiE7cEQ==
Message-ID: <bafd6e63-c4c6-432f-97bd-ad0d49391c52@kernel.org>
Date: Wed, 8 Jul 2026 15:10:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm/madvise: skip device-private PMDs in cold and
 pageout walks
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com,
 balbirs@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 byungchul@sk.com, dev.jain@arm.com, gourry@gourry.net, jannh@google.com,
 joshua.hahnjy@gmail.com, lance.yang@linux.dev, liam@infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 matthew.brost@intel.com, npache@redhat.com, rakie.kim@sk.com,
 ryan.roberts@arm.com, vbabka@kernel.org, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, shakeel.butt@linux.dev, hannes@cmpxchg.org
Cc: sashiko-bot <sashiko-bot@kernel.org>, stable@vger.kernel.org
References: <20260708122040.861335-1-usama.arif@linux.dev>
 <20260708122040.861335-3-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260708122040.861335-3-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F16C420004
X-Stat-Signature: baxmun3yjujc7t1tizaadkxbwfh95jrb
X-Rspam-User: 
X-HE-Tag: 1783516237-785221
X-HE-Meta: U2FsdGVkX1/Iv7Z/2YxxBbwNmnDj5ZXRivBYHp8CATKo59C0/5Z9GyKIGgIYWcwzuMbT4dRADKYp5OZC/hjvsIXHT7+wJ8vx5BJPi7SDuTRyURA4m4pah1HfW/PH9eUn1RegfhcHq78w5DILn8eEskRjV+319Cbnb4lkvO8iT47srquvhW4fVtseZSnPF2v5lTyBRpbEsYtTkJCUdAlCnqYTjSSfptAAG+9ASlns8/WwKhWwLZN3Jnv6ySWS3Noxr4L83CftWm7SwsN5EUBMcpk1maAVEubgDFuOaiJIrj6I1Bax44DvhDd8sOk+dJLAu8nEJ/2PPdYlqBfGctqqYvrQtkLHCfoaZb6M/d6RivHAqUmXN0bJXVWF6xHbcc2CJdvPnSib8A5eakI7lFEs5FZZV017Lgl1KvDFbD2HmrbtDjpT3mlN0INKkOCYaHxd1v4PG9387Dvi1wgQAsvErK3bVN+lrSjieI14Qh7hFs7AVyOR/UGukCdFdGYKEBubIy7hXEZsKuG4JbMVdq4sggppLurbo7YGsjVycxI7jk1lfQmVUttosh7rITGm1igEaRngdZsrjJGAcEzzdcxVMt5jOziIh+27vyuXEzHvyDFyUqy2JAIqy6n33jLrpe/XOuvhxR7E9wsmLulHMV5nGN/TcraYVg/dvu0ge2sj+2pnUKXCf5+y1CIWNXxnXogdFqAUGu93J3lGXe2P0Zx2xhr5tWZlF4vNI1mW3Y3WnBEBGwwaOyY4qZcIeZ9bwq8YbLDhjDtoWvvFXHtpK/RTZJq7nzTTCmSeY/29jRHP2ZlBoIzcODAPANgvugrJJ1ArJLkRlQJfFrxgEmUr6cV0c0ANcUN500we+PVff+b5DJXkgKbSg/JX0cIqbL4q8fLaCNYlcpxm65oWxJo6rPPwId4XEEIxYYcS+zNdnj1fpC9gIcLbk2je4iwtRUL3HuVc+FwalYFkxMWey7OqVXF
 gGwQY+xg
 Jrzrqf+CTGls8bxShLJg/CMZEAriMlDoxNGiADH0mQlTh1P1zfIGv17XbPFF+H/7vUkxwxQKyZAfqQhXMvx+FHIkSfAfIv+z6rpn7vuGt7vSwvhW6q6Xer46VIJ0NNkl8FZtnqHdZZ8qASz6I2mO8vORvcS2R0R6kATzP4BQsqHwvijm06r2PPkOzq9WGBlZ9QT9qV/7U0pt6TPSh/6gZTd4a0kwk/hiIhhSyTm8mlHSoPX9SqF/V8MmDScYz9tWRhChVjpnhL4hYWhhyZDc9gzCKCdOqwLFjX/jI08v4GJN54ME/qWl/pJs4EdcCF500hWyZi1ALNrRkrCeFCcW/mdxMUn/p6Sdsk6oMmYnYL7v2FXJJ8WKk45GRZZ80iIzyA3OFal09dOvYhZxG01mS+wThi4D4U/lrUXqsJyHDVuhLRyKlkaHprftswdpSgd5R+MTLjSTZMTAcLbR1DhSlwkr+DQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/8/26 14:20, Usama Arif wrote:
> madvise_cold_or_pageout_pte_range() takes pmd_trans_huge_lock(), whose
> pmd_is_huge() check returns true for a device-private PMD. The subsequent
> !pmd_present() branch has a VM_BUG_ON() asserting migration is the only
> allowed non-present case; a device-private PMD trips it.
> 
> Allow device-private PMDs in that non-present assertion and continue to
> huge_unlock before calling pmd_folio(). This keeps the assertion for
> unexpected PMD softleafs while skipping device-private PMDs like other
> non-present PMDs in this path.
> 
> Potential trigger: an HMM-based GPU driver races with
> madvise(MADV_COLD)/MADV_PAGEOUT: pmd_trans_huge(*pmd) reads true, then
> migrate_vma_pages() flips the PMD to a device-private entry before the
> PMD lock is acquired.
> 
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=6
> Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
> Cc: <stable@vger.kernel.org>
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Balbir Singh <balbirs@nvidia.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/madvise.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 9292f60b19aa..1065b5a84ea7 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -389,7 +389,8 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
>  
>  		if (unlikely(!pmd_present(orig_pmd))) {
>  			VM_BUG_ON(thp_migration_supported() &&
> -					!pmd_is_migration_entry(orig_pmd));
> +					!pmd_is_migration_entry(orig_pmd) &&
> +					!pmd_is_device_private_entry(orig_pmd));

thp_migration_supported() is just effectively CONFIG_TRANSPARENT_HUGEPAGE &&
CONFIG_ARCH_HAS_PMD_SOFTLEAVES.

pmd_is_migration_entry() -> softleaf_is_migration(softleaf_from_pmd(pmd)) ==
false without CONFIG_ARCH_HAS_PMD_SOFTLEAVES. ... and
CONFIG_ARCH_HAS_PMD_SOFTLEAVES is only selected if TRANSPARENT_HUGEPAGE.

While at it, can you drop the thp_migration_supported() check and turn the
VM_BUG_ON into a VM_WARN_ON_ONCE() ?

-- 
Cheers,

David

