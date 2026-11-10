Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6459A606A337
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=mlXxr88Y
Received: by kanga.kvack.org (Postfix)
	id 7D0EF6B05B3; Tue, 10 Nov 2026 04:01:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 781C66B05B4; Tue, 10 Nov 2026 04:01:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 697CC6B05B5; Tue, 10 Nov 2026 04:01:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 480996B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:01:50 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D2E19808D2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:01:49 +0000 (UTC)
X-FDA: 85418616738.15.89C0525
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id C38BA180002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:01:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mlXxr88Y;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794301308;
	b=GaP0b9oCgb6/tied5XT/b+rCIQxVLUcp0oyBOCVlq3FCNchIHWl2LoWnBP5QF70zHT2LI8
	IwKa1sInYvRyRb6RFMri2QJ2cFqrF4qiylbNsdP5QV5ynq130KSoLlP4eOgcQDNNW/LgUI
	Esl6IbHxHvoWW6WzrolGeqtQRWQ5mf8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mlXxr88Y;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794301308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N5RMWLcP7isxBVM2qsk29DjsEb+SK3rhdns3s69Yvq8=;
	b=wtwhKmKcP4ZVzc2HywrqXR5d5SHdlzBlDloOLu1z4vyZEJR+hG5dQ5GdX6WEvAD4rHwO31
	AdOcqiRK4ub4VClvT7hNQIL424sEvyulycJEZxU3lHnU4rYSpvxaO8su+Un16EPgJXYhpj
	ItjFChtZznMkdc3bWQvZE6Tqwq+J3f8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 665221516;
	Tue, 10 Nov 2026 01:01:43 -0800 (PST)
Received: from [10.57.60.120] (unknown [10.57.60.120])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A60013F85F;
	Tue, 10 Nov 2026 01:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794301306; bh=9CU41Se9la/KtdDwMQULrIKfytvMpdfr7XLUHb+OkJk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mlXxr88YJEAGdd0L2wAgQsnosP8cErHqpjtUnIFgrZRlpeDVMedSkCWzs5XJQabcP
	 AYoasvJ/eG3DdRL64rFmaMFN2uhjRLcP6I3ZkVQpszUmeizzIzpLY6LqjYw9gK2PiX
	 Tw4LA2EMpYvVCFN3nkVI0GLFrsqAWZf0DZ7bW+m8=
Message-ID: <9e59fd71-97e7-422c-a7dd-bc23c6e6a852@arm.com>
Date: Tue, 10 Nov 2026 10:01:36 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v10 22/22] mm: Add basic tests for
 kpkeys_hardened_pgtables
To: Mark Brown <broonie@kernel.org>
Cc: linux-hardening@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>, Ard Biesheuvel <ardb+git@google.com>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org,
 Ira Weiny <iweiny@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-22-aa6c4d9603bc@arm.com>
 <2d13fbb7-b5b4-446e-8709-5b43349ff19a@sirena.org.uk>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <2d13fbb7-b5b4-446e-8709-5b43349ff19a@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ajxucr4hr8zb73aci5rq8dydbwjdbzu8
X-Rspamd-Queue-Id: C38BA180002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794301307-319355
X-HE-Meta: U2FsdGVkX18eg1b4xUi5EtIYHFhY4VeAQtb5v4wAB066W8Nh+m24U7LSb+b7mvzFu5NeGb9xZ3wIzkceIz8ZF5RNbeFfa4jGcAQ2SIPpFBBLvVicq/v2EZLqSPDFhLU/oaK2LQz7m5BStzUHUwSG4ihpbi8T07jtTPeHddQhrZJGT9Q88R7U11lkJkb3CHMTIeKcn8r8nghfXIf+JIarVL7DHhfE9Suf8oFb0zqF/EsYlgzMh9VlPTqpehAg6rfNEfHzDD/n/Bvod1cE9gFGPObQYtPImsP5mO2VI4bkNO7QmPC4MkLty6XEpZj5uUN8jCrOdY33eLdXtid/0iUSe2g1+raV1kM4BpncivGqoTS53xmXQKpoScp6ByRQeOh8Gq/cQVbAfu0Ma2iCzQp/8YnpvTbVEt+Ek2I7B1MWB/lF52BHVhsR5BZyODurnqNVwvpsvSEOdmNjaDvgT+XVj8K3cRzQXUIxV2W1I0KdeauW6J543zaY8HnWFIfaC4VVh/VuLNjm/7lmireAaom55i3tmz142rkwJmZD6BMYRdajv6L9vys9+A/3P8DXzL17VTTu5F5RS96/EuoRCpAkr4JHwea8OfwilXop3f3XBUZLFv77ePGX9QiF1/OMJt2MeXJBscjm1lAeAc3e0djm5kyA4jbS4yicpVNdRAfrbVBsTSjcRMAP/5z2wbPP3QUNjOJzr8cQcOuKY3ovrs9yQjYzyknBG5l1YxwJnWCthjKV8+ZvMa2Dkvp076nztSGXllRjdMwRIaBAQazPbwglTId30YOZdHT8MRNS0uvEIJc6u1820Om28sp2hWYGycLAT9oXjg6YjrXTknxnEgt53BVIOxlrn2espajRVmOmdjv84rEN7e2PWWD2FfA254U9b91aMCXboeweAgkpTCASolQCUOH8BSuDH6x6Bay/q/VDwHW64oac1+ETphNcI7N98gAFGSRLSWfhE/pHqim
 K79mK1Lk
 bj+7TaqrYs2fKxcYzDP7GgpvWFEF9yFCiIQJDeh0s+lMfCtRqCexlbtiAp3VMc1u7dW9c0u1LsUPC9PyQyILc52svjbragAz4rKHad4/GA6c6OKs34sjHQQD2N6brODoIZgOsyhvnhfKg03l+TnTwWna+0qKbB2t5cVZrgaa4057fUr+2Ui3/xfk8rmRqEp0PF14IWtFbdh9FNXKAnw0axc213hzOwNFWs/GUEx0zhdRXFX2HI4fitxB7S3zlnEAodtas72GVF9CCbRtmKnG7Ps8RFhJMux+643sNa3tmIQh2ZigtJVZ2rfB7KbwQ2ppv4YZ5IA6tw6wBdomFzLJOqAhOXBhu0m13UrkTVjWycFLiDnZqQOBNu3xtq5LvuR5V+AyVZuAwftpJl3E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 09/11/2026 20:28, Mark Brown wrote:
> On Mon, Nov 09, 2026 at 03:58:47PM +0000, Kevin Brodsky wrote:
>
>> ---
>>  mm/Makefile                               |   1 +
>>  mm/tests/kpkeys_hardened_pgtables_kunit.c | 200 ++++++++++++++++++++++++++++++
>>  security/Kconfig.hardening                |  12 ++
>>  3 files changed, 213 insertions(+)
>> +config KPKEYS_HARDENED_PGTABLES_KUNIT_TEST
>> +	bool "KUnit tests for kpkeys_hardened_pgtables" if !KUNIT_ALL_TESTS
>> +	depends on KPKEYS_HARDENED_PGTABLES
>> +	depends on KUNIT=y
>> +	default KUNIT_ALL_TESTS
> I'd also expect to see this added to one of the KUnit config fragments
> somewhere so it gets run as standard, though that's a little awkward
> given that KPKEYS_HARDENED_PGTABLES isn't universally available.

Do you mean adding the dependency KPKEYS_HARDENED_PGTABLES=y to
tools/testing/kunit/configs/all_tests.config? Indeed that would only be
meaningful on arm64 (for now). That said it wouldn't hurt other
architectures, so happy to add it there if you think that's worth it.

- Kevin

