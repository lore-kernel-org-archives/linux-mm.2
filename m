Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A12FCCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 19:32:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D4008E0091; Thu,  9 Oct 2025 15:32:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6831C8E0002; Thu,  9 Oct 2025 15:32:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54BDF8E0091; Thu,  9 Oct 2025 15:32:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 411438E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:32:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E13B15C411
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:32:14 +0000 (UTC)
X-FDA: 83979571788.10.52043EA
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6EE9718000C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:32:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="ntGbiAl/";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760038332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+BfdDdHsvIg5pohaQk6z4UjY6nDAvslbjwgC/1ieyR8=;
	b=IAahnwVO7/9ZULy6Uy1LWQmRfhx1my7y+1pUw8L/J9W9mnztxpBs3eQ/Of1F2dnfDsHFeA
	jczflxFOBdZ3dyQ3c16qDQIrzdEVvEP1IQY3XdpJuSP224yPgEhcPQbEyg8S+ts+ipnbGC
	9hdWOqPy3LULWwW9V1QReSLrJKCAYrc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760038332; a=rsa-sha256;
	cv=none;
	b=LxiPRy8y8b8lZFyCKjOHus5U4VA/7N2jnNzI9VmeFkuC3ddjD/ipQ4QwIT7DZ107WZnHQH
	PzwES+2AmSfvLLd/IqlpTD8LDjFH5ugHZKi6d/TJxf8gGHX0foJCsl5lflnSSSnjhWXSjM
	XWCkYqZdzQptmNRUNRVgO8F02pmCsYs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="ntGbiAl/";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760038332; x=1791574332;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QTIZB4cXar6tcTAPv6wGI1eBlG8KHsLbakGl0mcnySY=;
  b=ntGbiAl/Ih02aBgGZArtzulDgrRe6Qpw1aAEN5nWYn6xhsIaMHHb4lo6
   g19HoY+c3uc2Oz4/9dttosYPREA8cZ3Gm4fNyobtw+kCzC3a7ucoKPfny
   Xswg6DgWusHVOgB2ZnV9aSclzR1yXTJ+uLxIu1yllh1/Ef5zbBWuSS2k5
   D72Lq1DsCX/MfSwTYPBkzpskctSxkK35FlMLMYi2ibClVcPFcKpy0Hy9j
   zRhiXE8yF++08hjVpFHL4mYZBNJY3M4lWo4AYIMwrIIOpxfI8zpR0cAGl
   xom2mjnc2JjGknw8Zf7viFRv4x+ExpBFC6um8HJ5i3gFQtQOHkEVHlFnr
   w==;
X-CSE-ConnectionGUID: CiqCFTNJSYWxaWoPCiv5ag==
X-CSE-MsgGUID: ASrDFYAwTzmEYL5gDov2KQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11577"; a="62286578"
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="62286578"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 12:32:05 -0700
X-CSE-ConnectionGUID: 2dIFX4OXSYKjl+0raW5S5A==
X-CSE-MsgGUID: ibQ1W0FOTVqpk0fcIifTxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="180815015"
Received: from unknown (HELO [10.24.81.144]) ([10.24.81.144])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 12:32:02 -0700
Message-ID: <aefa20f8-49d4-4fa9-9d18-39b7b0ffebf3@intel.com>
Date: Thu, 9 Oct 2025 12:32:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/8] mm: Introduce deferred freeing for kernel page
 tables
To: David Hildenbrand <david@redhat.com>, Lu Baolu
 <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Kevin Tian <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jann Horn <jannh@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Alistair Popple <apopple@nvidia.com>,
 Peter Zijlstra <peterz@infradead.org>, Uladzislau Rezki <urezki@gmail.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>
Cc: iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>
References: <20250919054007.472493-1-baolu.lu@linux.intel.com>
 <20250919054007.472493-7-baolu.lu@linux.intel.com>
 <4858074d-f058-41ec-a581-a8254b8cc2d7@redhat.com>
Content-Language: en-US
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <4858074d-f058-41ec-a581-a8254b8cc2d7@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: de5kkyikirnrrxg6cr1kqxghfgcyqt41
X-Rspam-User: 
X-Rspamd-Queue-Id: 6EE9718000C
X-HE-Tag: 1760038332-430387
X-HE-Meta: U2FsdGVkX1/ktxqZ4ZxbAtBcJvjj5LTkH5505oWP2b3WRfe5nGGGyy4H98QGMmh4EwYeqq5GjZvzHWPc9/vrB87Xvk5MKxzYO4fxkSTwzlbY7O81OGRaYqcJEOtlSlrQgLVo1RHkSuGo3jyqQz/U6XRhLWy0KjZhmEHDaBZXmHvyRRtVNgdSchA8oqx2ljYap27I2Aq7xiZ9YIijJjUWHQ8VVraYXm83JJmdUIscN81hp46D7hE9oEUIdaH3TIeTR8ixEXgtn1oC3arXl8dR5PgeJw+JANThkp9s3ukbWb/sWulBLs8xfAKrY/ivgbt5gwHRZgQ1rs+9dgPIkmf9DKXCa+wkT7vE4OwbrXgkPT31yROcjQ3YKEEk32fKe0XMhQboi1vSsBDvWO8vJWiP6amTTBU5YSKMGR+ry5GHZqAbdR55L3ZeMI1zVsVwZ/9OWpkcHmV6CPle5eirKBeQIDVlmCCynvAXQdb9r8xWzRTCpD004HtxiimJ/a20oPQ/up3A5Q2DSsxDnDjGTtlX+H2KmrjLcBiaf8Yd0dgDIyZYNc2Gqg9LraTJimfMr3wQ4IX5UlznjKdi8HRdH2X/ckf/8SEtQ2QSf9EwJvzUZv9KV2QT2j9TkrgR2SIw99Td1oqT99NqmtmZYZWa8JKlzovjmsUneIzOvxZ4lSgFPhS9MylCbTKHI0yCLf5WdbI/xBIdyBJLYJixeF0dfrDlXhLS4OZ5OiyucULa6fmEq5DOOlmwVh3WQaZsIzXJfTkuWwQRje8yrhr68FUZrGUMYUQgdBk6BlpU9giyGKFZjAhcVSAE4ZOUUcChfGU6S5quBGzq2eifqr+rT5/82xtud0YOIJxP1UOnylqgo7ZsJDrwU9RtbDjtUoatEOrP7tGqcEZVmc2GWcqM+Pe9zsJZQM1/WJ8V0pbomMGqMlOh0Lctsg1eybZpOjbSG8VUXi9WB/G7o1O0BCZ9M8fDPzJ
 UDGQvidh
 PVDvHNnU6MQddgj5hsJT9DjzYkuqPG90F0dJrWql7lu6aZ+knlTUi0ev1CXmyBVEN4tMg85ZZJnEekRQTEFG2c2E/N1xSxqiJMXCenYaohPZiqohMm3bcB5Kqwe2wR2vMBRZZq3ENcLiKjP/u9Dcgl4mTSa+kjVNR5bovDw8DMMFwoUQQdsp+azpQDpEgWVaqjhB+6lyQWAzfuNIRuV6sSpcY5gtlXk5TmEFq+oY9NcckyWWMKA1GaZiSQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/25 12:28, David Hildenbrand wrote:
...
> Can we please squash #7 in here and make sure to call the config knob
> something that indicates that it is for *kernel* page tables only?
> 
> ASYNC_KERNEL_PGTABLE_FREE

I'm fine with both of those. That name ^ looks fine to me too.

