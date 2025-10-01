Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32390CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 20:30:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A30F8E000B; Wed,  1 Oct 2025 16:30:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82C448E0003; Wed,  1 Oct 2025 16:30:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CDDD8E000B; Wed,  1 Oct 2025 16:30:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 557538E0003
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 16:30:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E6428B77AB
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 20:30:04 +0000 (UTC)
X-FDA: 83950687128.11.293E883
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9B5F310000B
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 20:30:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OS7KGxbL;
	spf=pass (imf14.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759350602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x+L3eqNwlE1XNXWCzM2qp6IsiU2Pj3HFoytcmsW8ZOc=;
	b=D7IbZ3wN3lDcuDeyAsrx32UuvkBuLYSOmiTCeRfcXbTgQ/WpWEEdoHKgjYNJQmJN59wPOC
	70SSJkNP2WUV4tS9VdG0AjaumhcWKWefEEzyMe/ioA1tBbzR3aSBNykk6BKtJKLLBUh0YR
	bKl6Edkon4hdWZo2XtF0Uxk231z2ivQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759350602; a=rsa-sha256;
	cv=none;
	b=jmg58J0i8S2mZmVdv/Qx/hNYXfIzWKoTHWMVO2HO9ZG4lYJl2JH28DJ2pkJJq1go3One6b
	D3GEjsfYFZ/VQHaCGeaS52V0HsHPMyfYCOVbPO8W96lsN2CgT4BPKQ3HG9l7E4QyunJS/0
	PEMTQtL8dmk3uxNiVVzARTDniK1FLfk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OS7KGxbL;
	spf=pass (imf14.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759350603; x=1790886603;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=x+L3eqNwlE1XNXWCzM2qp6IsiU2Pj3HFoytcmsW8ZOc=;
  b=OS7KGxbLrsrrJA7nv7JAjs/ymUbsF/wIFohx0khCFcPTMVzvrUk2WAqB
   0bWM+itA0EhqEeuEZg1Rh731DbxfKuuWCWOP0sQ/TaZjKgUjwuGRSIiqA
   n5EejMO64Bu9e8FPM0KLMwWfl/JssQDkRRqHC2x99M0lAh79ASMqSN4qa
   1poBBYCDASvrSzAdsFzK4NDZlPN4kAEt40lhyNZ+w2/jilvyKTt5VaptJ
   J2u28uJwCzt/0sU07qGJIxnh4YWfg8wGfCMRLDInjHibSWj9S5Bud6LId
   sMGhifO4afjEuyxjtIxAK5AdAOk9dmKjWkICVxA7UTQpT7tXmAYrbsTR8
   w==;
X-CSE-ConnectionGUID: Qyj4HiStQze8nXKTGOS6ww==
X-CSE-MsgGUID: 4R1WsAceTjKacjv4OxV9WA==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="87083872"
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="87083872"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 13:30:02 -0700
X-CSE-ConnectionGUID: Fe+AqTixS3CpuPLRxgvT2g==
X-CSE-MsgGUID: J38wk/e4QyiyD3tdpVOnNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="215999128"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.109.221]) ([10.125.109.221])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 13:30:01 -0700
Message-ID: <7dd29a1e-cea8-4889-bff1-462ad00e25fb@intel.com>
Date: Wed, 1 Oct 2025 13:30:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/21] mm: ASI direct map management
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>, Andy Lutomirski <luto@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, peterz@infradead.org,
 bp@alien8.de, dave.hansen@linux.intel.com, mingo@redhat.com,
 tglx@linutronix.de, akpm@linux-foundation.org, david@redhat.com,
 derkling@google.com, junaids@google.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, reijiw@google.com, rientjes@google.com, rppt@kernel.org,
 vbabka@suse.cz, x86@kernel.org
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <726d6a45-d732-4c23-a7b7-766d6a62122e@intel.com>
 <eajnyirurulezkgpqaonfqmh5ydi7ujzztgok2ab3fsumcmtwi@34ios2bpwxk5>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <eajnyirurulezkgpqaonfqmh5ydi7ujzztgok2ab3fsumcmtwi@34ios2bpwxk5>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mm9y1czau5ze76qf8xmkz9jj9sr9bw4j
X-Rspamd-Queue-Id: 9B5F310000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759350602-625023
X-HE-Meta: U2FsdGVkX1/ywYmq7RdbjDeiLTX8V9Q65+QCdxQaGclGsSkLBD3082V9fw3fF7btpSWSSi792wfxfubYhqZhytcO7dRvM6kfnglme06Rt0SOigtJYFizckATghnR0rj0eqoCVb3uC9+2vH1JNzmGl9voIS0KoUc6QFJP5oWhIHp9Kg5FnhLNID1Eu2nWomYgSbsm4525KHqfZNUo4OPCJZLia6k7seo1/5m89bL1MsK0Y9xeTxVLSNq/VfsdrRAMxNnIo6aEZBY4gYmJ44f/J0Ki8cMA9wRQKtLccgW5lV4uleBGv8RYwQOvFQb/quj/JPzBo+zSIHDivx9IyACDBGVIdmiN2pYKxjQhNSW6rQv6E+A/EMNd0bklWJljHfKDROxczgc8sP5wGvVi8L9z5ZLb0ESybgfuX+xs0+wn94Qzu40Sgw5pAtsFVDymEXmuClP4gO4n70z/DutYstkN5zz96ZNcS0J0CqXzLrfqAQrZ+WHkwuNBVbgNKXHr4AeyxFU0fef0RetdmHDVuO5YC+8nTElaWVGz/HhUtRn79Z4srTXnYGd74NhEAHO0yDFYsAxPWvm3pJZ1VDj1dTozzp1qrTyqu0ADoIpPWbudJJ1HeDlzxBMFhTi+x7Jlow7bYRhgB3GSRZmo08oZyEg2yi9+UGO75oSbngt8TwZHn2eprVxiACRCIyBpXuemunqBqE5pRjmo5muKtNI+JYUpAYNXy6T3mgzgQyS71seVX1v+N81JcZTsrjkK6CH0rzcL2uDuYVJO6BjMXbUED7nxt8ZPV4nhrbpZGd/KWfBGZMAq9E6qyq1om189IbGIyygLNkEweOt/fq1cJTWAu4SIpd2TMNW4q44liF8a2HkOWI4adxkSJx04Vtoku/O+19bRrsopMJbRQTiXH96r2MTg9IYI4TiVBNOa3qKGffhAsZbNYT/cpYWBTKFok3P5JN0N/GwWYQX0D6SkfxwBU+N
 n1nSQBmf
 NduDwNNSb5Jq0YOwpFqRooJYXLrECG2pYYJdKaPLjv/E1Gg6NqRq3Nvtm4TzIEzJf/6hiYVbO9h70dgE5vVA58ZN8MzvsbpvW15Yp5jk4c1huXMZaZDm5LIG9yJIy79DtLhW9G5TaYJddgnSJ/53145T6lo9FhKx7vFx6K6qyxMJ77N+hvBb5KZeqYUIQxdkA6KVfQx75JfyAFaE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/1/25 13:22, Yosry Ahmed wrote:
> On Wed, Oct 01, 2025 at 12:54:42PM -0700, Dave Hansen wrote:
>> On 9/24/25 07:59, Brendan Jackman wrote:
>>> As per [0] I think ASI is ready to start merging. This is the first
>>> step. The scope of this series is: everything needed to set up the
>>> direct map in the restricted address spaces.
>> Brendan!
>>
>> Generally, we ask that patches get review tags before we consider them
>> for being merged. Is there a reason this series doesn't need reviews
>> before it gets merged?
> I think Brendan just meant that this is not an RFC aimed at prompting
> discussion anymore, these are fully functional patches aimed at being
> merged after they are reviewed and iterated on accordingly.

Just setting expectations ... I think Brendan has probably rewritten
this two or three times. I suggest he's about halfway done; only two or
three rewrites left. ;)

But, seriously, this _is_ a big deal. It's not going to be something
that gets a few tags slapped on it and gets merged. At least that's not
how I expect it to go.

