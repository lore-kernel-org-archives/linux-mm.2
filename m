Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7605C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 04:58:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A62DD6B009D; Tue,  7 Jul 2026 00:58:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A146E6B009E; Tue,  7 Jul 2026 00:58:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 905BE6B009F; Tue,  7 Jul 2026 00:58:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 623EE6B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 00:58:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C5BF6168A48
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:58:04 +0000 (UTC)
X-FDA: 84960773688.03.474675B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id E02CC1C0004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:58:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DRLmW3Iu;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783400283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vw1aSVRkui57kS3Ukf1Ya4vLbuBj2tNPNuge/YY/2r4=;
	b=25i6/kqJe89qFaPe6ziT0POaZ2obN8UK04PGPYaTVg0KDh4GxnEu2S99kn9C/RkWHvs6m6
	yRyNngbkBiGYt0wdqw0+kO7jRsmtgCmtMdfz0B9SPV+CfDQtDXl8UJcSTWuOdi0Q+YbCxy
	Qlcxx4VsyvhuCPOXWTaneijc+jyo654=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DRLmW3Iu;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783400283;
	b=xxMS89k4fV16uF9dViqeOXmYuxkEwhqAY0rgl8UAu8oalf7CxCcdpZIV8tnom3PzlEgNq2
	JZpR+z5GMuwPZFoxkEM1+e5Pqc4px++vqV1R5C2bZ2lWJILip+hA5d9qCyoCgOr8S9sITm
	79lavNyQrhRvctQMZRIFmy32+GQ6ErY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 90EEF1C01;
	Mon,  6 Jul 2026 21:57:57 -0700 (PDT)
Received: from [10.174.43.45] (unknown [10.174.43.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 92DD43F85F;
	Mon,  6 Jul 2026 21:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783400281; bh=xvbL7kvG0VDsGKdPSXKFCr/Na/I99QDnXl/z867q6ns=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DRLmW3Iuf07Npj/O/cDrlSVfLRplOTmmzrAyWqHn+praAlNGWHYSOGz9FiI5WAyRT
	 fLtqQm+INNflV8nXZQoHxalM4+MBsFhAuvZQPSp7VqFhEzKW4jQlYGI5lD1t5zwTXC
	 YNkgpqHqi1F0UxByS2f7dy+T9Hu7ZUk6tsqQh4xU=
Message-ID: <6f68a4b6-9f6b-471e-bd21-fd1591cb6a69@arm.com>
Date: Tue, 7 Jul 2026 10:27:54 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Standardize printing for pgtable entries
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, andriy.shevchenko@linux.intel.com,
 usama.arif@linux.dev, hughd@google.com,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20260707041703.658021-1-anshuman.khandual@arm.com>
 <akyGWZCRbasIX_wY@casper.infradead.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <akyGWZCRbasIX_wY@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bn7rcdqw48yq58964pwioqzafsy5mrmo
X-Rspamd-Queue-Id: E02CC1C0004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783400282-315284
X-HE-Meta: U2FsdGVkX18erY+ODguOKObG1Q5idsLVavEbfz+7B6C3+gTztcTvdJcWFlXwtK11TWiAknF+19zLGE7RjJyJ+rSFTcgW6yfe25zH1c5bpu77QPzlRFyKpZsD6O/L0/o2HO6oH/rc61lnA3KonBvXhlRZ/DII/XXeImwCf9xhdukL7Mbvr9S3QM0yPyOa3LDOWRby0ADQcFPMN1FB25ToqMfhKNXd6824hQxjhErWYpjRp1hW93YqF/APjS4ShEKTOH4+7AugrT9VAFlDRJh+k1wePAZs7pxsQaPSR1GGoU2HjvbLRYNrd+UuAtchqwRNdy3ILoMNJB2m5n90gPlxd3h+0GGCdJy77GEm+CCCar5I8c35bR20y6nmhvyVxOFwPwTqGP/KixNIhT27cYly92lW6oMywujXXK/VSB2PW4POPmYvpud/Tu+t8d4NVTOefYf0hquWEaC2ucKXFAd//oHrs4ktZ4yfP6UrqVxut94LWOspbfILp2B9Yhiut2M4XoqxobCoJPAvb8vImAip6r3GrsnwOANGKI2GoNyx7ijpkK5Z2kRBuQG5ViKlSMKBRBzUSvALhZcEjeln5IKgsip9axIlAaM8/l/w89NOlpeTFBReAosXBtAktLQiXGNltBkyH7uawAMurPUqaTGmB6qqHkNmoE+XgvDWAQFt55KtEKUguaKJcvLOrYz5y9V4tYzdTGzmDwFZ0gxoc2Bp1ez2C5/HaUz5lFYS5JXoqI/sevotfN4lI+TrCiFZKjyF6oriorQ3CJKnVKRe1eVD7X/4FlW2fzl4sBvngDBbInGzG2XaVk7wY31HNvnduFp8wq72+0sRgBM5vbSiundBBWVKLvpvbeypPaquWS5KTo715+4M5Bva3+FH77TzBIW4UlYhRcWjVl7eRxWF211lI1DGkWwVK+R3jYNDifiRbXRw3DgsS0JZVg2IJglLlgFyrCdryQd7obVWvJWTwha
 mwhkWQMn
 yuzvlH6SbQp8iVU7k4xdROnAmWJTKZU6JhkgxTjQ9/qGQBN9WLCa+iXnxaeSQwhJtkxP//MJ+eAauaBebjyjkmKchktDut8WtXUOV5EiqJaktmzp/+z6ZS32JSfJowftvjrSDDbx7nHxUEGmiWkuYC2HXpPqnIFqlbZuo326156n2orxUkZs7QZ5RmuQooic+tnJwPp2BGYD8hZFOLApbuo2ufWRfwpighOK9w13ftMyqD2M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 07/07/26 10:23 AM, Matthew Wilcox wrote:
> On Tue, Jul 07, 2026 at 09:47:03AM +0530, Anshuman Khandual wrote:
>>  	if (!pgd_present(*pgdp) || pgd_leaf(*pgdp)) {
>> -		pr_alert("pgd:%08llx\n", pgdv);
>> +		pr_alert("pgd: %s\n", pgd_str);
> 
> I don't like the extra space being introduced after the colon.
> It's normal practice to not do that.

Sure will remove that.
> 
> But in general, this looks a lot better.

Thanks !


