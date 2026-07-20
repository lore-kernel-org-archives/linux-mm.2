Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1AFCC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 13:05:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B44B56B0095; Mon, 20 Jul 2026 09:05:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF5366B0099; Mon, 20 Jul 2026 09:05:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E51C6B009B; Mon, 20 Jul 2026 09:05:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53AD76B0095
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:05:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9C06240189
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 13:05:11 +0000 (UTC)
X-FDA: 85009175622.02.EABD50F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf17.hostedemail.com (Postfix) with ESMTP id D79CF40009
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 13:05:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="nK/1g3PV";
	spf=pass (imf17.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784552709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9iwk3+XNQYlbEmXDu592ICNgUwDwIp4s3EjQCPpt95w=;
	b=wxCfCqrifNOqufTe7SHg81Vl6/GVNp2hHuZrRglYb5J+WwRXeLTzaL0z704tEGpE22om63
	0ZSM7yrztODLryQfo7djs0w2oXWE5cEC34+PKI63tqpo17v88eEb14yHAgObq6BB3oxLde
	hbxMq6V110Yf/fhew08LRpxT87GARqA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="nK/1g3PV";
	spf=pass (imf17.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784552709;
	b=Z4d5zXh9P4cKgJTTb7FrIIT1+PAFgIaZ+eNgXIqta7h25Sz4LJOTT5RET87Vgi9joSChmn
	4jBQ4o2baomRle4hlC/rHLEYkv5ZsXDLkDYDZDlEQ7OAxxpsQOppLTnIsIaNiEM3cx7Z9p
	BFfUtBcFw41eDxyP8wJ6DURDAvSj1Ng=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784552710; x=1816088710;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9iwk3+XNQYlbEmXDu592ICNgUwDwIp4s3EjQCPpt95w=;
  b=nK/1g3PVx9o88PmpFq43xCqGt74XS6EyKWRCcvYktlITbSH+foxOBlC4
   ntD4cELtF8E5fh4q9PRNpyotm7qmnrmBe9PP78glxUV2RsSt/B2fzV6kF
   JX6rESpUY8gGvY9KPuSrIxgj26Ns+ICVehaiUP+NdxFKEqamWhGKjtNao
   ttaYK8afqkEOBzXODFKbCDpEL2N+YdceJN5oDh1ilqecw8CAagsnhVqRg
   W4fBL9cUnfnwshwTYY3HhRTGc/y0LkAfGrL8cNMI89B2Nq6VdsYnm8eE+
   Zo9Ld+v9poXb9Ek29Se0Pm+6H7idb1zGlRYDDjKmCXeKWGPP3wk+1Cc3l
   g==;
X-CSE-ConnectionGUID: XLRI6L/XRLm0GjcBCBjGTw==
X-CSE-MsgGUID: Httlhhz2QYqxuI+gZZa1QA==
X-IronPort-AV: E=McAfee;i="6800,10657,11852"; a="84898528"
X-IronPort-AV: E=Sophos;i="6.25,174,1779174000"; 
   d="scan'208";a="84898528"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2026 06:05:08 -0700
X-CSE-ConnectionGUID: 9Eb9vpu/RaeFxpiW+w8L1Q==
X-CSE-MsgGUID: TX930MbuTsSLX0njsjivxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,174,1779174000"; 
   d="scan'208";a="295658442"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.109.156]) ([10.125.109.156])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2026 06:05:07 -0700
Message-ID: <33fae97d-75db-4df7-9aa3-05a51f8747cd@intel.com>
Date: Mon, 20 Jul 2026 06:05:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/9] mm: optimize zone-device memmap initialization
To: Li Zhe <lizhe.67@bytedance.com>, akpm@linux-foundation.org,
 apopple@nvidia.com, arnd@arndb.de, balbirs@nvidia.com, bp@alien8.de,
 dave.hansen@linux.intel.com, david@kernel.org, kees@kernel.org,
 mingo@redhat.com, rppt@kernel.org, tglx@kernel.org, muchun.song@linux.dev
Cc: linux-arch@vger.kernel.org, linux-hardening@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
References: <20260720120259.1545-1-lizhe.67@bytedance.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260720120259.1545-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D79CF40009
X-Rspamd-Server: rspam01
X-Stat-Signature: ef1wowbzrmaqnssnc3hk5chfacjyimwf
X-HE-Tag: 1784552708-325844
X-HE-Meta: U2FsdGVkX180bh0csWHWz0326ezCmPdHeu1KWyHO4tuGNJGMUaKVez9mV6fwd9J3HDBnvcsCnkb3MZggpribCH14iHeOO7gBQCUKPz4vcEUhmUXzksVvduHTvLH4jDNFHkc6AR8UEpyqxCEXpxKjQh7eLVtKgyXCbhcKjIvr19HpZpUWQQ2mfbTlshIBgOMHFm3c6Z5QcEUdRnylr/QxRsIp7TU5yHKDsv2RigOI7CRMktfXE0ddKQNNCtHQD4z7WLrE+WpqEqPc5sq06KXOjAlP4M4lnoO+rUMeFV4O2HNGsh+APdKK9msupT0VZRfcOy/dEGPtZOQxaKnifaj9Oy/5oBBzhqEN1zYU/TPf7Tr9IRu2uCl1yU0bDEwIjhLQzODrCT50M68kTnirR/S9tWmMrnL4hy7sHzJIz5G7ES9f9rmeOgYHYbXDOb/2fn4mw30T1bVo+UqpZyREA3MUYJx6Y2uu7yHnXWRzzU10+Z1FxeK9H3I5b5IV//8WEnlNAxroI8c65o3lKeg2ZFH/A6Z/JiymScfXM/7Ug3Cs+gtZ5f5DZUXYZCKEDA64NUWvP14d5vxkIkmvALK7bmHDwDc/0PaGsWWCJoDltVUckPPAolV3IT/I/7sq9xD+qiwq1kRQlF4v8vvTJjWzl6D5S2CCdG5rdldqTMil43K2mKe/5Oi0g3XZh6mmCBNk4jS2WbYmV2OcekiVv3zdG/qTYi0uzHJ2w92uGPE2+07THtSdrMwAp0jiiHEq+q841d7Aa8FaUuXUpCIpeiinarJXRXVK9lHeZ5K0UEdVOooYnEjrvyFxzX2zubvH+aYgh5sUWDlB/wrupC3c4n3MhduuaD4vIQI0gD5PMjW2TRnQVG/vzc6m0/pr3r2I9zDn7JM4BmK4qttSJnxVzjXm2k9p8uNJ7KRmpe8TZGV80Um9KG5EkugoN48jqRWYJNMT/R9QhAGKfkaxGEAqXqGGEIK
 QEs6BS/H
 AY6g2uAxK9eZdJYkLO5+fYyAoauowlxJyw+zXrwISHyxkY2/FmMdGLuhy9jdTBzYHAP2g2Ba5Jlfl+6kAnvSQJ81FrLR83O6ZDb4BvAkDUIgVsYD6a946wuuOTx/zpNcPAfShm8sxqM1oKpnkMtWMqwbegUhi219sKDseWa3VxkLhmKnmglsTwjdwQiXRZPfzTmh1lyHNfsJQXD4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/20/26 05:02, Li Zhe wrote:
> This reduces the average memmap initialization time measured during
> rebind by about 60.4% for nd_pmem and 56.4% for dax_pmem.

There are lots of things in the kernel we could optimize.

Why is this important?

