Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CD54C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 02:37:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5BDC6B0005; Sun, 12 Jul 2026 22:37:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0CA46B0088; Sun, 12 Jul 2026 22:37:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9255E6B008A; Sun, 12 Jul 2026 22:37:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 68D936B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 22:37:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5190A09D5
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 02:37:24 +0000 (UTC)
X-FDA: 84982192008.30.726C752
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id B6BB9A0004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 02:37:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VIQGmDqD;
	spf=pass (imf15.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783910243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vchVDyKF87J3Ta1I9aV3ORhNtCidOuOiVF/ans+/K3Q=;
	b=3WwBT6+rwQ+5q4iB7OgSkOEi2zGtL8/k8nb8yooO7PiKgLAWDBIkU5Au/KjJ+tsCIF02wC
	ty2J2nquxlg0A2rYETLC9gEcxLBtKZHnlfuFkW3SLvR9rZuGIUKL6osonm6e5T1i0Xf7a/
	qvgBNHj1D6iQbmENG0sz+TBAiwnYJ/4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VIQGmDqD;
	spf=pass (imf15.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783910243;
	b=0ZD+A3t2Z2KGmK8/QpQk52gPADHJDuHyi3kVqbe6dV0I5Zwe8zQY611B+/VvijSoQwvI+F
	ZWFxw2aF5fbAdRZPWQnthpDnNDttUuCy1txXdIm5tVIlN+rDAH37jEaGH5p1t/SBeGeFHi
	Reg6/udkJX/sxZe/BdEzuThKYj9wnLs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 690701595;
	Sun, 12 Jul 2026 19:37:17 -0700 (PDT)
Received: from [10.164.18.40] (unknown [10.164.18.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4B0D13F93E;
	Sun, 12 Jul 2026 19:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783910241; bh=RAOlbtj+ruxKqMGMvP4gQvTsJRk49a7u1pfA/VZ2Hlc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VIQGmDqDNlk/rPWU66rlk1Zsn5AWDdffk6yCK33tgRZ5OYhYA89d1KnPof3/ZrEat
	 hU9ZtCuwwEmSqx4MGX3G50wExe3jHD0D+cTyncFFQLFSsMMfaxl5Cz1+LEQd0r0K0V
	 s7OXBBf6pU+iLQ0hYdJWCD7s9QhQT2532rowFw4E=
Message-ID: <5ee8783e-4deb-48fc-a4c4-96b02d79a6cb@arm.com>
Date: Mon, 13 Jul 2026 08:07:16 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3] mm: Standardize printing for pgtable entries
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, andriy.shevchenko@linux.intel.com,
 usama.arif@linux.dev, hughd@google.com, ryan.roberts@arm.com,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20260709044334.1741263-1-anshuman.khandual@arm.com>
 <alHNjbiWFYXSPZtY@casper.infradead.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <alHNjbiWFYXSPZtY@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B6BB9A0004
X-Stat-Signature: 64re7ixx85q9wwjtntopruwsczg5qaaw
X-HE-Tag: 1783910242-599966
X-HE-Meta: U2FsdGVkX18Xaf+cK41rQ+3kfaPHcfeGw7vjPYmc3hObncUJPUvqueX2Gook7/rSfjvDTWZzE5pBZhkv68xTPXqxPU960sREH2D4uNq7O0Ob7hGH+L4b7/VFg8TTsmURej5m02MC9MmQJKueBEImyFDfugVpW6EcoBG7np/Bl6ILI6DCZCaD5cCVOgd+6JFMy/B1hyoBvigyx6reDgc0dfK0U/oJMrzwN0dslUB1jzVRcBN2r+RyPvEQFSyZ0Qz8EQRmUtXWYvR9jGBJ5lBe5RzVrNnuSVO2ZjZdpOQeLePrFo3P8mnqt1mKJPjAD7AEjazZyZihSXkIbisrQYa5e5wAGwVbTU9QadAzvy6W7zKy2hdzUZ48ThCbO0Jtn20acUVmP5DcfSqWJtVHuv5P5T7Ou6zv7QUnf1mVpAKD9n9FCSNoLeidecIIOKUirVfqhsKPwu9oi/ttN60DQ3bp5ZNJSgrbW/qJ5Zj7JeviO3aMU/s2VtdxKkY7DpxxcfRCfpjXJIw16LGpLo0hcK52iwTAI25Z1kCz959IoUd+zDXXG1SmVeNCchAjTL9aYP43tH6EhxsySY+iBsnbt//lM14BTELizksWuLCMT9JxrSnkaVPOBQdgvs+YPUv/uTYdVnNXQaAjRKzTX3HMbtpuEbw9BBr/uKPYFIO48io8uh+X/bVMK+b/Wfx94WSLPV0X5SiwPxF1cWK0FVg0VXiFPmgRLePBydZ2iZE+0bfa+K/l6t9arcXCgMinSrmvVfYWwcyQOh7ss/c9aYqy2DlxEg4L5x2PwENXkDQiRKefTXA7yRshvLtBLGccA1q2GMOIWoZ6Vpo50HHwPiINkdkVbpRqi226Puk5YvblLNBlMMVJ0e+JdBLNYvlXaO3PhK41STINGMVCCfOqg+oZ7Ttmn9ruhfbThZ1P5410fBnKJPb7eeGGjR5z+8adtxW+uqT7O2nhLXO1gt8isR4Vegn
 M6dhmHKK
 bJjlO9MIr6HsJ6ZIzRrakBWG3763ehOk159S3oNXCl3RjYx5xo7SDr/Lbpwfzq1oFOidcsRSgUzRn7zdr5Qr5uEWGnHQBgFuHNGzde3MspBo217oRwikZfFfHcFOkBNdt7ZIyGqQ1Nuryk57bmKBSoGB5GHfvSSqqjYQ59n7yesxuHPJ7adTnHtmePCQsKelU5s0z9B5W/bsgXkJaYbu0v8R+HqlVHHpYoO/5VvLmDou2sEM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/07/26 10:28 AM, Matthew Wilcox wrote:
> On Thu, Jul 09, 2026 at 10:13:34AM +0530, Anshuman Khandual wrote:
>> @@ -532,34 +575,34 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
>>  	 * see locking requirements for print_bad_page_map().
>>  	 */
>>  	pgdp = pgd_offset(mm, addr);
>> -	pgdv = pgd_val(*pgdp);
>> +	ptval_to_str(pgd_str, pgd_val(*pgdp));
>>  
>>  	if (!pgd_present(*pgdp) || pgd_leaf(*pgdp)) {
>> -		pr_alert("pgd:%08llx\n", pgdv);
>> +		pr_alert("pgd:%s\n", pgd_str);
> 
> Why can't we do this as:
> 
> 		pr_alert("pgd:%*phN\n", sizeof(pgdv), &pgdv);

%*phN dumps raw memory bytes and will have different formats on little
vs big endian platforms which is not desired here. Debug print here is
expected to report pgtable entry canonical value where various platform
specific fields can be inspected.
> 
> It'd save us all this stack space.
> 


