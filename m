Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E76A9C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:09:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EACF96B009D; Mon,  3 Aug 2026 09:09:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E84A26B00A1; Mon,  3 Aug 2026 09:09:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D73EA6B00A4; Mon,  3 Aug 2026 09:09:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ADFD96B009D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:09:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B5DCF14066D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:30:29 +0000 (UTC)
X-FDA: 85059437778.24.D34D579
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 007FB2000E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:30:27 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V8vyRB9Q;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785749428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zjh5R7JiqdaVW/vRw+XBY0BM+01RpjpIK/UObm893hw=;
	b=lC7qfip+6D6C4mynth4RZj08rmmNyj2NoF6kABEkHg/0xTZj5wgbST9YZzpp2jN6AG2X0N
	qms90J/2sjOLWKFADt3nxUqcnqic+yhEkLiBoENrPzacq0Ltuj3J3oD31VIokwTQUOPJug
	YTtck2e6SA1SELdlTCnejl3a8+DahW8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785749428;
	b=CJs6rg1xWZ3Hqsr4y7ao3NbpY3cvDEycfCJmOWyJFU1B4MPF/D/cHNrpP5fNvnhi5sa2pa
	+T7m8Y+PR9aOAQgPg/Uvadsv9BZ5PB8LiqX28SNf8XguKYb3brYpu/H4W+FRaB57jai+mL
	ebmt5oWhfwss3dsohXiOrVgwEdRVPbE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V8vyRB9Q;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8959E60A69;
	Mon,  3 Aug 2026 09:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD37C1F000E9;
	Mon,  3 Aug 2026 09:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785749427;
	bh=Zjh5R7JiqdaVW/vRw+XBY0BM+01RpjpIK/UObm893hw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=V8vyRB9Qh24DBIJLDfn63WPRgS18/lHWUS4HBAJ0kTRWs6ZmedVmrCFmdddwSe4vT
	 5a0v2VRt5ZYF6TJxFZwRb1kVWG0YzNUsPMwcAAGbA4uDcJEF/RKLQSX8rqVzICiBFK
	 wnYqhWReKHBGiV7anEVAJaGcQmWGl3MSdB9t3zQ/iEg40HOuduZvuPpHYG05/754K7
	 XG+lX0uv11g4BdHt+e1xaoiyCkvEbxHPh73il4Jr5qzEZqtI84vTO82GyeRuaXCF2j
	 g+Bocdwto/LOymtNfLqr2FLm519accY0LBWjIBRxn4mX676u+9ri7OPH9VwSB1th1V
	 JnRJiYNYE+Jpw==
Message-ID: <dee6920a-c0e0-4cc1-bd5f-d503da0492ae@kernel.org>
Date: Mon, 3 Aug 2026 11:30:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 22/26] mm: Minimal KUnit tests for some new page_alloc
 logic
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>,
 rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>,
 Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>,
 Sean Christopherson <seanjc@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-22-6f5729aa9832@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260726-page_alloc-unmapped-v3-22-6f5729aa9832@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 007FB2000E
X-Stat-Signature: byw9jjjnfka1jdeybnq5jfeh34aj7pta
X-HE-Tag: 1785749427-649073
X-HE-Meta: U2FsdGVkX19IVHyb6qbvR9MZxmaCUGtRb3jFNaltlKa8t2HlQGfxrSa9ecLP7oNrSG8/rxdZATmVGtcrhwbPCQ/DLO5Ew9RA0pSl8sOtJJHUlNiaeION6I/Y0XIzPnxjdfSIZrTDW+DjDkQpklzIxFH+EY8fappCEWhn1Dq5TKj+Zo6Tphe72ZOnEPOtVH/TflsBmpxe3q2ilTDuUGnztTct/u5OznREUpHw2nlS1P6wStGN9sCthsddEE8Uwd/wwYWLiwLWEqTQcescmPcs61ePpMzVlN3Zhj62rw9HsSV6ssr8WkZBI5DR9QPsW33sQkevwDjw/i/ob9jRHgIJjAXJDsw1I8NYHDvo3Sr1U0mDE0eZZ5eBpI+RnsDtZ5qbtlc2OM6K16BWmpL0osKvm3t3l9iAfJ61yUqht9hGBi94cGoUMRSO8U4+h4I6L1f4f0VzBbkOM5oKVDUVhUaTX7E4CFzd5UkRV1TW7mQI7oz4ZRFQsFzV5e3bxMoFzHKuWUx2VoBFEvuqx11D8T5y9e+bpH8dzkuAMpOnh03IqJUZ5grRNQ7EAFEJ9i/d0h2DPQ+Agp/eG9CqiKAgWhhCapd1H0OVsFiIKntmXI8AWHLO3V8FaQTDp//rIxvWIKrT00s7Fdvd44EaR+11zSOwONBXN1bzkNl6izX2bx8Z3i96nb7WgSBXVA76xwqbRqrUI2y1aHgIsPYI2f+ri+3526zkTVHclXPJz/rSwZLuPxtgRdsabGRfFmKA70z3jBtD4nzUlLv1Dy864EU3fJi039jlcaI/Ak1LEgDsZAV9d0ir2LijFTxlvePqiDoywawzhjJA6+oPYEg2+ismBv7RomRKxLBS1gTV75IEUirn/yLs4haRthyUSkdeSaRdYkA1dQydCDknJ+Fyeskb4kPLR7PnDLT21uCoM9TIRw9QiESbsYmwEBIuSC6bJ9L/nqCgFPGV+txOiogMmpMgO8/
 pmywWTBO
 CDMNUWhSd1KfIjLTpA1fE125+nS75NA+wwPrboIBdbSBihe0EWijdfcI6ZSjUO44kTxQpm3m3NcWDi7ax2Y6LD5Yi4UppwS8/mzm5SD4NQBjshwWJHVcOxf8/G7Y/cYdRay5bQSoGJEix8ftAQdz+pVPnOjfN5I6JMaPFPmyhacnAeDFWQcn1/8wmRXn5vJKKMm8hMIaoP0Xce95pMKLZ2iEj6LaodXH2JiSOqW+IpFsEK2f27CfeCgod/nd+OSj5bOl8yJkn7fX5u4NczLXqJUZDG9y/pEIGrYPS56c5T9QTVdbw7MzhtCnVBK+oFzkuGL1rscUQhQ99t+rLsIPE34teU6uazuMPHr0p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/27/26 00:22, Brendan Jackman wrote:
> Add a simple smoke test for ALLOC_UNMAPPED that tries to exercise
> flipping pageblocks between mapped/unmapped state.
> 
> Also add some basic tests for some freelist-indexing helpers.
> 
> Simplest way to run these on x86:
> 
> tools/testing/kunit/kunit.py run --arch=x86_64 "page_alloc.*" \
> 	--kconfig_add CONFIG_MERMAP=y --kconfig_add CONFIG_PAGE_ALLOC_UNMAPPED=y
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>



