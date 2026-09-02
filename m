Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98738C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 20:59:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B7506B008A; Wed,  2 Sep 2026 16:59:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38EC76B00B8; Wed,  2 Sep 2026 16:59:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A5366B00B9; Wed,  2 Sep 2026 16:59:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E23046B008A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:59:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E0E3A3AD6
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 20:59:22 +0000 (UTC)
X-FDA: 85170037764.11.CE81ED8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf21.hostedemail.com (Postfix) with ESMTP id F3D931C0002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 20:59:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EGSrJa6I;
	spf=pass (imf21.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788382760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y8LNmScARa7HJkvU5Ez/Vyz+tDF7/HPp977A/Faa5lo=;
	b=1Tjpe83x1NoBldqprP7Nfy01qz11gCuGzS+nfgYuamg7B0aB29AvE6HRAL2hm/Uf1NvjIy
	3vGVyF8DR7hRWLBQEeeC2Jqt3X0aLCTu8FSXwKSbNuwLfrC8FmnvPcQ5lY1vn4xfnjgsxT
	XOF4eaIgJbMHUQertI2225x9kGDxzns=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EGSrJa6I;
	spf=pass (imf21.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788382760;
	b=CRsgWZv3n86JG5tFOUO92aAN/iY8ZhlyCORmn34slI3lxF7PGWwqqMCxUVuSXwq5JHfg5o
	iPuQbofdyYYw1q+CxBiTfF0h05WHuLRNZzfYTtS+jOjlQtGK1+KxH2IRh5GSTco+GBVuD3
	g8gwS5YkAqvKRBLufXGPElJWErkCLQ8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788382761; x=1819918761;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cF6IiUx+BCoe0m+3uvTplcUMQWNqx5NBiPSWA23TLCQ=;
  b=EGSrJa6IYeRlz54RAOGYtpgLSXU92mhzY0Mrk1la1XQ4eNEkiv1Pap5t
   3YvvG7ku+c91RdHqWEHOPgQNOzqnF7XY6CpR0UDlcFRItzp6GLoc6UW3o
   hbLkyz4nvyATNIAs0iUH+lqtodVO/vYdo0HNLau3Sibm04OXMOtgZu2SF
   L1BPf1ED1cnIqSct7PfvHN3GBYJvOfcyK31gG9KO6+OTXFGva+pAyr1om
   szB8WbEXnt+PzUrerxosdkp+6ag+SjYzgMgj8FM5Fd7pbc3bIUlYj85O4
   VA77heALNeGqZOQjsikAogR4WPfTkypcKW5mLqIbUoLDTpp679iYm5z76
   Q==;
X-CSE-ConnectionGUID: aL5H0INeQTWdlXNTXT97uQ==
X-CSE-MsgGUID: 840vTsNbQVys63OSbpNkdw==
X-IronPort-AV: E=McAfee;i="6800,10657,11894"; a="88618509"
X-IronPort-AV: E=Sophos;i="6.25,258,1779174000"; 
   d="scan'208";a="88618509"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 13:59:19 -0700
X-CSE-ConnectionGUID: ikwRYlfkQFWAwOzWRoIzTQ==
X-CSE-MsgGUID: eJoC9yYvSRuQE0aGcQiTIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,258,1779174000"; 
   d="scan'208";a="265198010"
Received: from cjhill-mobl.amr.corp.intel.com (HELO [10.125.110.134]) ([10.125.110.134])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 13:59:17 -0700
Message-ID: <5026dbec-0b71-4408-a78a-484a4b8e77dd@intel.com>
Date: Wed, 2 Sep 2026 13:59:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/3] mm: make persistent huge zero folio read-only
To: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org
Cc: david@kernel.org, ljs@kernel.org, usama.arif@linux.dev, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, kas@kernel.org, rppt@kernel.org,
 catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 luto@kernel.org, peterz@infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260901151818.3191443-1-xueyuan.chen21@gmail.com>
 <20260901151818.3191443-2-xueyuan.chen21@gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260901151818.3191443-2-xueyuan.chen21@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1mef7df8wq8wjq8iiaq75h9joizznu13
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F3D931C0002
X-Rspam-User: 
X-HE-Tag: 1788382759-112827
X-HE-Meta: U2FsdGVkX18EWfNcEmRXw31/GtBdbJYHvM3JScL2gtyhsgYzT6CwSIqYgZMsLWNQztq0nnEdxkghqddINQJKxRDXaKpjz9iYUmrVsPvDZhasvgOz+VshpIkPGAYmDUMSB+1PnBYLHksyjyy4DZikrEev+erutbaNrrfu7eNaXds9QWfyxukunenRekphiIiCYYdrUkp0ZemERiOHOaQZ4z0qsADXL0tto+vmCin1WXeZs17C1SWNufTRTkDlOqvf40n2RCiZQ4ORS3DkVgJxZqbFw4KgfcZInHfX4SIaplc/6j4sSNXrD3+ZdRWLxhkb4XHzEXTPTBr8r8M/3G/vBWAedFnf8kwKHjplC7PluQN2H81AwEXxVVWzaTQg5wf7weftWY35JLF4yJ8Fl7MrVrwi5/s3LR7bIHe6bxot+20EC6zb6cwMs8tSEdH8WmFAiCEFF+ecNLMd7E0C0z+Kj/rHrJtOlOpF2DdKXY4BthSgUBV28pITMsYxHPpKkXh9rf//ngHZJBQir4i0ep2Tn2WxwSKdgCFC0O5n6tysV1wrQhgTRV7URKRixWR952e8RdjazpW+Ax9WdIxxBAfLyf+M0mScAAb31EpCfmE3sXuRxes5NQu73eCps7S6SCjR9R4GhjYfxk9XBeQ0fAPXWGOqtjSrc091hAaDwyYLqDXWbKn5um/x692yydKJsUQoBCv6/iHk3FXcnnvG5cDa6cTzx6/bnR5mKjhZ11kgTuw012D83rmQLRG3e5+2AyPZIy6WD/OkDu2AaoH8lyqRBetchHJOgg/UzbAQ/TZ9csqbq2SYNOrrjYsyRvSO45YPIEHCufhCHUnseZZO29xHKTyTZh9X1L8iBjUcB3Xwo2bT3QrAJ+bDPh5moDtOT+L56jZfVYH3bDLZu8LyJm5cRFtEcbT+zNRnpUCYW3M4vcygkidt5erYxxM756eSbzixMsp9cVABgZndh7yiC0q
 6pAxEAvN
 zh/F92T7OOl2nRNrYgkR5gU9sjYayJOSE2nJrGJCOf5g6Fzr7b4zFMraora44JBP/2+VYm/jBd++yNCBdiabrZAgk/pknrki8Y+Irz2PxJDhlZAhOhm6C8f5jcvGuekWdN1lY8TTtVd+6rBeuVgpzskQ9fdW0QGkkKyHp/3FJQQb0uJKu00Ovt17EbBdzzfY/02JsiKnI7dOkSOMj3ehaCc4Qjj+JgpwGcT1c8qUlWEnbwinJcLsgDfBXbXpgi2Fb8r5jZCprWLyJ/LOC/8z/YDzJag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/1/26 08:18, Xueyuan Chen wrote:
> +static inline int set_direct_map_ro(struct page *page, unsigned int nr)
> +{
> +	return 0;
> +}

I still really think the stub here needs to return an error *or* the
thing needs to just be void and tell folks that they can't know whether
it worked or not.

