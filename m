Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41EF2EC1109
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 16:35:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A05146B0088; Mon, 23 Feb 2026 11:35:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A5B06B0089; Mon, 23 Feb 2026 11:35:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BF126B008A; Mon, 23 Feb 2026 11:35:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 79E1E6B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:35:43 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 351D11B557C
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:35:43 +0000 (UTC)
X-FDA: 84476272566.16.1E6EE8A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf05.hostedemail.com (Postfix) with ESMTP id AD4D9100017
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:35:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UMqhh+0f;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771864541; a=rsa-sha256;
	cv=none;
	b=xKRQ1pSjEDHLnsYFObn4H7q8laBT2AggePv1nii09ZhlfhDu+gF0o8oZZTMLdLBhuQ9Idd
	QOYEpJ8UcdcqvI+Wa3DrW+eXCelr9L6IRRokziqN+Dngdu23sR1w5DpIQ1N01jIO5mWljR
	bFT7X+TP2+fCRsUo0JCh04edUKi220c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UMqhh+0f;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771864541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mc5jA4WHl5Daz5wji0l03kcXGprq4/im3O/9YHdy/t8=;
	b=HVACPTRGJgRHDmObA2CZm4PIbDishi+94uRrrtr+Ew9CQlFF6S+6bZZfYE36sufX3QEWtu
	j7zCF3achRKILoI/bydNNLgiroy5Y7broVXOm3QHd60psgGSayCNiSjZ6WD6pEQLtymWGv
	xkt8pWIS0R1L6n0LnZzgGYKoS4BY2Yw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771864539; x=1803400539;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=INgbWi1LfXN0Ez9j66pRQryu6hcLX3HbDIxmBmoNo/A=;
  b=UMqhh+0f8PxcCZeTsU9TNGRepU9uoBoIrFs5+sTCZnCi7cTPG2fOdBUe
   UzuTYFW4AnL5C4kbtEWhVTWa3YfgXgSiBSjF3jfMuyCe+R6bAhwL4Q7d4
   /ZvX3GompJzgptgEhHMajdmrnOD4rxZVzZZkoInZ9EaZ0EKeT3KHNdueY
   pwDASOMcF0F2qmZyqczy48foDuS9217A/8aYprePgV1x3kF35Xgk8sxkT
   IdQdmKZO01f5MELAlbyA9xm7t5YNTw2wRWdNYq5wAY08oF9RcT7tNzwGY
   A0+ocBcIdyWk8GO3VFQmg19NnT2sm/TOhDbFmQ0y+8jWZeReiXnQe1ty4
   A==;
X-CSE-ConnectionGUID: 5gLStNhsSA2RGGOqWlKOaA==
X-CSE-MsgGUID: Bia2PpRPTY2Il8DL5+VmrQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11710"; a="84225326"
X-IronPort-AV: E=Sophos;i="6.21,307,1763452800"; 
   d="scan'208";a="84225326"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 08:35:38 -0800
X-CSE-ConnectionGUID: lndfx9ZQRBO9VCQx+Jnnlw==
X-CSE-MsgGUID: GAw/SMTaRk2P18vPFA03VQ==
X-ExtLoop1: 1
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.110.205]) ([10.125.110.205])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 08:35:37 -0800
Message-ID: <c348453a-6a1f-43e4-acbb-02bbeb2ce805@intel.com>
Date: Mon, 23 Feb 2026 08:35:39 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/mmu_gather: replace IPI with synchronize_rcu()
 when batch allocation fails
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, aneesh.kumar@kernel.org,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, npiggin@gmail.com, peterz@infradead.org,
 will@kernel.org, david@kernel.org
References: <2a6c4e62-1663-4a98-9adc-406a6a1ebfd3@kernel.org>
 <20260223125826.28207-1-lance.yang@linux.dev>
 <a0c434c4-ec65-4a37-9422-5614249124bc@intel.com>
 <1373db93-3977-425f-ad59-5970e7e50b48@linux.dev>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <1373db93-3977-425f-ad59-5970e7e50b48@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9mtn4cyiihycra1qwcakxfnxwn9z9xth
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AD4D9100017
X-HE-Tag: 1771864539-748795
X-HE-Meta: U2FsdGVkX19xiW1YwNQD+ZJCsOUqMSefo2h2KEFMrC/L6uZrxjn0fvK/3n/iqxeqw13v9G3uD5xb4otBz/lHTl/m6Eu7eS3oPGIvpNguGoYZI4+yneW7UOFO8DmGkIXm3ju+3tGqUbSJXAX9J18UHlVrHwOueLTVFwhNHuPleEdNzeCgd6iPGV9dF37blifvZSCsCXzRlcURkPdUqXyQYvD8h87nuenQEGIw+K39nfTbCOJ9P+Hr0hnFQHxyVHHvwNtYFFYRIzKzrpLcbe9/HbAmzHFaiV5MURNv8B6oH+L34Cs+/mvMs4EgO2gvzd7TL8QTahyeiARy1ENuno6GlSou5Ri87Hf8GmM1t2pDPuZq8dFZDymEso32moK8Zdn+9mhJUyKowbsFFUAuR+m50sxifXhyra+CavG5t8JgqqQEw04EDtBctPjrPXaWN/Ne2Q/IB4Jrhs4Kw2wGgmpgGJReAeBZQy3Gn2zL8w0O69HsfJDKfxqU97aNMi444XRWVJOzMx+6/o1xqjEcO1yvuShVnwu0WUUB1Cma5Sto7x6EoiCGXzYIO6b0OCib5gmMM3Tzvt8u3tprAnD6p8i3B71mSFa5E0BC9FXzZqtiZEjbtVZzDuiOGV+0rWUabIlIv9gvwmInKLZADxrH2uIsFYJO/ZTQMpxgof0We+5EGPhwzweATSJbKNkI7tq55jnsoVJGovToqoPOrQP0goina6x/SIsh4k7xYT0uNz1LE7Mrm2yLgIlf0ofxv95TC1N6vhFIJJHjxkygbX48dcdPQZp/JNsfosKth1gofsuxM8nmfJeIJtwAejygbUSCWMJpHET94tyVEKA/zNxfvPUTSWiIBxemuWh0TfcF9L09XF15P14u3ZFZfmgths+CVXONrEYwRbPXTJKWtjBwhERJmO4/6jJ/nJgaY2xRwbiJsv4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/23/26 08:29, Lance Yang wrote:
> 
> Note: Use this when code really needs to wait for synchronization,
> *not* for freeing memory. Memory freeing should use RCU callbacks
> that don't cause latency spikes in this thread.

Yeah, but I'd probably mix it in with the other chit chat about
non-atomic contexts. I'd also make it something like:

	Do not use for freeing memory. Use RCU callbacks instead to
	avoid latency spikes.

to make the commands clear.

