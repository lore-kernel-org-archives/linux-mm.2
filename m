Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85F0DCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 15:59:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C57C36B0088; Wed, 27 May 2026 11:59:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C098B6B00AB; Wed, 27 May 2026 11:59:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF7936B00AC; Wed, 27 May 2026 11:59:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D25D6B0088
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:59:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 57FBA161B10
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:59:16 +0000 (UTC)
X-FDA: 84813659112.20.B454F95
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf21.hostedemail.com (Postfix) with ESMTP id D15D01C000D
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:59:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Pdk60eNr;
	spf=pass (imf21.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779897554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pe67Snf+8PFUZF0q2zQ5HtqPFOOz0ld8eei02edpPcc=;
	b=G9Z05/svOhu7LLufpaC2YzbKtmJvV8Mnf93WqjwRQzs9F7eYw7QXPMq8FXbP3iAKAOzD1w
	cvtvN0YYjoTOhWuwB9dHxu6GZpi9mS0qL4tR/hP9snPATW9CdGoqCMGg/pJNgsZ0kClgwI
	c8XD1oA5Mn35E76gIz8PqYCa8EbmlNo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Pdk60eNr;
	spf=pass (imf21.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779897554; a=rsa-sha256;
	cv=none;
	b=GYYLBgi5+xNfrg9b/H2BTFdykZWN271JOrUXZAayJkvObL9Y6+QilwGRo2oBkkV4P+yhQA
	cmcht9zq1uZW1UCyzFhYCgERB18fc4oji++2Pn8CrfKbcrVYLQpLKH8GBX/S8uNN9bp0KK
	vqUKBWRWA9z1YeHaG2xJTUfBffRPvY0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779897555; x=1811433555;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pe67Snf+8PFUZF0q2zQ5HtqPFOOz0ld8eei02edpPcc=;
  b=Pdk60eNrDPl3r8ZG9Ui/O1VPZe+CW9tWrTMop+OgL4+cVK7R2MIFLljX
   V6qn14DiOaLZH3UVl/o+/y936SQEUcpqaVjAK/AkUnM93nQK5h6h2y1E0
   9bi0x9oz6s46NbQa39XH1kWKaa2yX3yuTkvIu631G/Ucq5iZ9WayjuEES
   aonq02YGhLOrVS+SVFEMIwjohCzruFuClaJsRnrq/1BoYl2GuRzdjELpb
   fD3ivKD9Xxa3OGP0jsVNu4QuTiT7Mr1GkFUSGL1L7kn6ENbp3GXt8vIN8
   OQpDjiZEFTqZkqHieFubg1AcjTnoxNH79kNQhBQp48qjiUmesiI9EnIeI
   w==;
X-CSE-ConnectionGUID: QH8ZRq7dRmGL6YdameZ41g==
X-CSE-MsgGUID: RmqvAPyVRH2Dw7Pu0jKpzg==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="80458718"
X-IronPort-AV: E=Sophos;i="6.24,171,1774335600"; 
   d="scan'208";a="80458718"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 08:59:13 -0700
X-CSE-ConnectionGUID: PGIMwxxMQ8CTIyCYw/68Tg==
X-CSE-MsgGUID: ULt0qmExS9CNImI1mD0OuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,171,1774335600"; 
   d="scan'208";a="272615667"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.111.27]) ([10.125.111.27])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 08:59:12 -0700
Message-ID: <54986350-dfd4-4065-b960-e1ba30fee4b8@intel.com>
Date: Wed, 27 May 2026 08:58:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/3] make persistent huge zero folio read-only
To: Xueyuan chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 david@kernel.org, ljs@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, ryan.roberts@arm.com, dev.jain@arm.com,
 lance.yang@linux.dev, yang@os.amperecomputing.com, jannh@google.com
References: <20260527035607.14919-1-xueyuan.chen21@gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260527035607.14919-1-xueyuan.chen21@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D15D01C000D
X-Stat-Signature: x5csmudm1zwfn4nadhgh58aj6nbufsg8
X-HE-Tag: 1779897553-794365
X-HE-Meta: U2FsdGVkX19I2LCS8Td3MUO9MFvoWDbIftlJydYyr/myiI+s8ht9CkxENr9zehGWND0ZFrnpmW9f4kdqOY2liSA4Lo1KYMvweDOughWBBkvxYO4mlmdMZoEzTi4eP7wPkTeQvQ1biIcahZlE1y4uAZllG/1reLE9lZij8bN+Q9u5EWU/R59YF/ws8XdDg56b36IdxO/oR/mnhb2ejxF0RSCZhWlytEl0AKn6DX7MSdF0gSiFOnP0xFPf84dUalUkuUf4Ecdoo6GCA9HeMkWYEoxZeRfBw9I1aj9eyWxb5Vr1v/ZlY1gPMQduJHNhX3B1jA/lNZ9d1wHPM/82kIO9CVF8gs70/8elxvlrStc7dBCon3efN+6msIqdibzENNO5W9LFuIMVtmULE6FeId17MPDLi2AxWdjo/dKxsgixL02FJqtXFmzU3MfSSmfdKvErekRuh/yt5+/CbDb0ye2YUmQAWnh/ZcbxYRCDyXAJ01dv0h4M2nwBI2Gm2TEa/R+AVaY06mdmpR0y5R0KDUBa99fhSBOXGReRB4JN3pHJSqG7P860BernLbmhYDg7lfQYa5qioZ61EjFqsiiddHSJnecObHUSqNgnoLOjRVXyuzLIK2j+z8HBCDSPyshPTXw1y7uUO/i+2QlfnFZRW5/w1UoUAzlTMT35f9V7sy3p402FWZJURuzRZp+1XUKVye56wfSGRFGkTQ8rAX4kOfxyZLzy1Qe/oqh6MuRf2ZaurrBjknQjSef5V+VD569jcFHeWNXB/1SCZTq1Kd1SWfFfpD9j2q84Z+q33zr6l7OswZ3SUPb6I3yp9oD4xO23lTVT35/S1npLRvl6Vb33M/lmA1IjMoazQQtxYYxkiruaJ/pb9BGFm883RS5Wsd8oKLXLOoGBkZd6iwh5aUGsel14dl1iL32vjI3kwA8qi4aemXHxIKzz/TORCCZ1ebA6i0a0iQGadLFRP/74pevE7lJ
 OuoixzTF
 nmKDbM7nHAlRsVghs7S7Isom+JvlFntjZ2geR33IOQVfzpdTvfuQ5/XkLGqQjGSAHynJ5jkqoGn+ZMkFiVF8qn3cMOYX/fKQrfqpriI0uaQPJbY4In9rtIobH22aFq8OgRhTwONsONRsdSlfSE4Dh8nyEILYk6wfnKBo2pMp9nuh/K3xZtPrwTij1cAeV1aPENWT95pXHABhTMS73RlXlhhFIZuwjKD8a/jVAdLquZs/OkDNsXApVEqS+LYGYhTQn7VvBzQ04xnp/HHUet+bbapNlsJu7vZzlMNhSOjlG16lXULM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 20:56, Xueyuan chen wrote:
> The motivation comes from Jann Horn's read-only zero page work[1] and the
> follow-up discussion[2] with Yang Shi. As Jann pointed out, the kernel has
> had bugs, including security bugs, where pages taken with read-only
> semantics were later written to.

My overall concern with this is that it's just a code hack for the huge
zero page and nothing else. It's a total one-off.

I think you need to make the case here that the huge zero page truly is
a special snowflake and deserves a one-off special snowflake solution.
Because it doesn't seem *that* crazy that there are more things that the
kernel dynamically allocates that it wants to keep read only.

Maybe there aren't many things that get mapped to userspace like this.
But the case needs to get made either way.

