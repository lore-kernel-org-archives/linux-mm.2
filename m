Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DCAA106FD79
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 04:32:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 427E16B0005; Fri, 13 Mar 2026 00:32:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D5CC6B0088; Fri, 13 Mar 2026 00:32:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B73A6B0089; Fri, 13 Mar 2026 00:32:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 17BF66B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:32:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9F9935A844
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:32:27 +0000 (UTC)
X-FDA: 84539768334.12.CF854F0
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id AF3B44000D
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:32:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=NfDDrueV;
	spf=none (imf27.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773376346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4PWorIuVBtzdK1hCG3yXXkHLa5cHfJHYltPsR/+plI4=;
	b=KSIGcf6vU1oVjGU9TWrHmZW8sgnpmK1oWtHA38cZM9+sVALI3TiMM9h0TtmeZ49kCjGogw
	32y6fzaf5VUFHczPYBZ8CkR5pX7O0jipsy8zF7VatomKYE0sw9Uvf1KHLKVPs+X6CdBHI4
	a6uXZnYDz/xRImc8PnK4vvXSG89z95k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=NfDDrueV;
	spf=none (imf27.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773376346; a=rsa-sha256;
	cv=none;
	b=O44zjKyh/G0QtblyZnIM60HUTjjbXEJGH3ksgQXYr99+7d+TmI8JihNQoF2BuNj36IugvZ
	vEQKMZXvR9/fUgyoqIGXiqUw+opSprO5sr1IIUjxJt2jcxrBNMhUKUca0XitEsrXE1LGhu
	aBii+nAXZpjqomq1Zp5NcqN4otIi3Qc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=4PWorIuVBtzdK1hCG3yXXkHLa5cHfJHYltPsR/+plI4=; b=NfDDrueVefetZKJanjVgnCq4zk
	UZIkbuQS2jeq093BU7Y0zaXJTOqerb5HzpMh3a8fmR0Ytu/IV/x9zPXXEThTo8H6On6BNYsngyt4k
	1IXAeQIKZFiWNiq4kbqFoAt/UOiSbi0HUhTkiNiHk1vOCd841OXtycuBMPUxnZDpgt9JXLqosw1WR
	Wba7Q7+Oal2nKOSpjaf2EZ6PWNwUXvwac+Ks+ST0joPrmnRBF1+4sAYnLpXg+oF4NEZAjoYI35i6d
	+gltQVHRKto2K4xWJAukJLzeEp8tX6wj40FSBwcU8DN2pg6oOr4KRjy938veusI9cpO6dT6IMk15T
	8lfr9rKA==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w0uCE-0000000GVR2-1QIZ;
	Fri, 13 Mar 2026 04:32:22 +0000
Message-ID: <4843aecd-fe54-401e-9e30-237e1d9fa1ec@infradead.org>
Date: Thu, 12 Mar 2026 21:32:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [akpm-mm:mm-new 367/381] htmldocs:
 Documentation/filesystems/mmap_prepare.rst: WARNING: document isn't included
 in any toctree [toc.not_included]
To: kernel test robot <lkp@intel.com>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>, linux-doc@vger.kernel.org
References: <202603130548.Eq61ZQ3W-lkp@intel.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <202603130548.Eq61ZQ3W-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AF3B44000D
X-Rspamd-Server: rspam07
X-Stat-Signature: 4kjq5zbgqibk3du8f1ttytygy56w6c18
X-Rspam-User: 
X-HE-Tag: 1773376344-187445
X-HE-Meta: U2FsdGVkX19+K1icLcnZGxgqhjkCMdTWoRVb/zoh0cClfykp5npmd/wV8S4oxEdyfGsEwVwuLwgAqOo3nVuyQY/4qLlTJY6OlLN+xAkjstVRoQzG2KeL4dYMA9D+5KuR9czFbWvXXPe08dixjCTbQBdZQYBwD+jp9FzOVxl53nkiHw1dBNIx4qBIaJ1TF+cnbnW6Cjt3b2VlhTM7AiAmAWDDr2TJpsFrsuYG2f7Lit8+KXaZVa+qT7YSBNbeu22JHp3GHwIWB7nFbd6sOTslOaiMAAStRxuxqtxsohYRZsogYW0qwZUOdBpCWIXRNBIiKIVFXpNeJ8D0gRcBTZDZxu1+SETO84n5V0pJ1aiF8WMCJU9YOvSWrkvFKFZuuJBEey1/VkL2o5W2AegANd7VOmKSocE+vY/Q9eQAEqpVYjpvYkgRhYn3hilgyYXc0p/Iy2ipiHSCYRWZmpEcvAYOgbvLgctR8XhzvfaZgO/DXZtgCRBmTri/DwTkNlqjsriM/ZZdLqlCFEIO92hBjQf8xewY+l/6NI5zWJbakTvWfWVGbyS655cPdoj34cHVisjGxFVM5j4sFg7cxvLMaxf1J/spKewEYcm4FqHkh/DskscFJ0/+Joq+/xZpZGCdABGrkbe+UMiatnggSFqGPiTS2bKjixQf9CbWfv9O5jlRhA7Ebm4Zrym9FA6BHARJl8F0gWcN8e2gkBYQ7UhK2kFaQ9wSmLViJ6CIneTxikKEZoAjY291qwj3sQ3QqFxll+EeylVeAw9KUYCUJZb8DZ7VqihMy1WHou/euF5a0c7DQYA2nQAZbZ+hqtC8s9ec0JHE5ftW2Ckqnu8x1hntJVrEY2+6Wg6F26rdtLFf/ikcLxHyKK7ysc8458whI9buZ9M+mlhO4ghPWjFFB1bS71tl20BQG7SpPJSksgJmw/mw89tayT4EOzgYQxH3FHQWBbZsVnMOcdR0F4BKOlRXWL2
 jUdO4Ggn
 pOnuhd8W44QPmc24E7cgPCz8EsaNhJ8luRKF4KiqHOjjFBl54u4cnY8Tdzhw7waOc6UcPISQloODub557hffJYfwUXryuNQJTDsLerpIsnsAjyj9wJj1ch53fLHrEUegqAqw48XT/otqoRlbjIpEDhwwWgIG/DrLmTlUqDpgzlwS0al1/7wyPohITlmTI1Bs27mE5LmX1EaLppOR5J4HTjxSlc7u42WpDm9OdTmFpJ+DDuIm8wYWZaRXlj3vg8Agi/UNJ9MFVDUYugiN1+6uRNS8jKaqlnwxRfu8Nj96HQOsv2PZ7vJQ18WULJNPumMLre9XRN3vC37XF/J0dJWeoFBh4DL2Vi18qH6biAYQv+aKFLN12y+eSc6AMXfLAhi1YJg1jXPkv3du580cUhBbU5a/HWDQKGMFSQajStCDKwfIYpgLIcXyFB4WltG5aVUQkSBxiRky5Nj7z3oQvUBwHetpJP3WgwKNm6unFKSxanc39v/GoTrJmi8VPdGCm8STNkFwThuItvMOaDVVVa9HHXU+d4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/12/26 9:17 PM, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   593fab843afbd6800243552aebcc61d02d3cdcb2
> commit: a6cdd3274e8a03e218fe6bf3ef711902adb76727 [367/381] mm: add documentation for the mmap_prepare file operation callback
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> docutils: docutils (Docutils 0.21.2, Python 3.13.5, on linux)
> reproduce: (https://download.01.org/0day-ci/archive/20260313/202603130548.Eq61ZQ3W-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202603130548.Eq61ZQ3W-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 


>>> Documentation/filesystems/mmap_prepare.rst:60: WARNING: Pygments lexer name 'Cw' is not known [misc.highlighting_failure]
>    Documentation/networking/skbuff:36: ./include/linux/skbuff.h:181: WARNING: Failed to create a cross reference. A title or caption not found: 'crc' [ref.ref]
> 

Patch for these 2 is here:
https://lore.kernel.org/linux-mtd/f0e33b51-d465-462d-b0f6-98a1db66bb15@infradead.org/T/#mf78dd33fe8fec8bb02379ab15eefd4d3eba23f78

(written before k.t.r. reported the warnings, so no Reported-by:)

-- 
~Randy


