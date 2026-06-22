Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA734CDB466
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 18:38:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06FFE6B0005; Mon, 22 Jun 2026 14:38:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 020D16B008A; Mon, 22 Jun 2026 14:38:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E51386B008C; Mon, 22 Jun 2026 14:38:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A939F6B0005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:38:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 098A21C1750
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:38:52 +0000 (UTC)
X-FDA: 84908410104.26.D9FC34A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3D07EA0012
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:38:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sg5UF9ai;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782153530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4gJOKgrcFuTUCEHQYsdjEclgb7VeirQAcn5Q0EzveSk=;
	b=murhS3GUWMQHj3kyGMXMZOc4uIz9mC7Q0euj22supqTN7+LxzFlo2J1IXs2yG1sdmdKhFN
	z3x/q3vlPY1EdVd+GJnd0JS8WFadcP1lkCKD72yjLDVTPL9ZWV3jj41wpCipgUTvvlUDoL
	+AXMNxbr113uN+IR++iT+Ei5ZSOyfAQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782153530;
	b=eNKOGUcdk6Wbw0f4hVVHgHrX01ujO2J3RiXBixsG0T7kJLoW6/7OiMyRGM20ogjlfO4RrH
	BlrXTsnWfsSDO31TPV3kKEf6SPCZ6Mr/EosnusuumuYDvpxAJ5GPvoLvn6hlzVVrukptmo
	yOIGKGU+RY8ncOC0oPGmJ+5vdZ+tZyo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sg5UF9ai;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 48CFC43867;
	Mon, 22 Jun 2026 18:38:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1491F000E9;
	Mon, 22 Jun 2026 18:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782153529;
	bh=4gJOKgrcFuTUCEHQYsdjEclgb7VeirQAcn5Q0EzveSk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Sg5UF9aie4Ukwen70Q8bPYsBeApogmGwATui9tQVae/fexhlT5kYmGLg8fxvTeArN
	 w8EOuFXHrLlJIJvVB84baaswRBrAYrg/I3+Mprn09zh5nd81M6QecMD8KASof9wpbJ
	 BdED5l6LbFG43rI8xEQ9W+bvFA8HF56J6enOXWuAcMW1HheE64fkyhwtsz1f39jrFJ
	 Mr4kcqUvy2AGsoiDTUQMu9d9OC8E/92lndJfTvhkxx2xPOZan8DzlImQ3s+Z1wbedO
	 pPmlXXCDGIShDXYZqqLkt7OVeMJxOovawYoFHkj00l9DPCX7JBLCKHEsuB6x4ayzCR
	 m03K3XGq6qW1g==
Message-ID: <9b11b0c0-dfc7-45ba-934e-19cd053e5635@kernel.org>
Date: Mon, 22 Jun 2026 20:38:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v8 01/24] mm: Introduce kpkeys
To: Linus Walleij <linusw@kernel.org>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, linux-hardening@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski
 <luto@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>,
 Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>
References: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
 <20260526-kpkeys-v8-1-eaaacdacc67c@arm.com>
 <70f4dcdf-c45f-47d3-91df-a7897bd86ff4@kernel.org>
 <CAD++jL=km9hqTuTMFUhyx_QPuMEwWqmnUVQtPtMXnp8paHH1_A@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAD++jL=km9hqTuTMFUhyx_QPuMEwWqmnUVQtPtMXnp8paHH1_A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: tud9p1agci57i8us9p5jo8oypkcm7b7t
X-Rspamd-Queue-Id: 3D07EA0012
X-Rspam-User: 
X-HE-Tag: 1782153530-572083
X-HE-Meta: U2FsdGVkX1+itRsvFyI/D8s93N+fBL0Zyp9EZlVL2SAlmE5iHdC+vK+pbAICJ4J8rx0C6QxC8rE2BbCZNZUEudqQ4yGKL1Kb6aV6BnctMf5cI806qDf2rO4FBLXf5lOOB/X1O9q6s9fCCTsJhl/pOId6wPlcck+F8diZcJG3laJ48c7FKhSv6gn5G51YQQHiEDesfcCCpZ0EqJR41Z3jErzDGOt6Lh+Bm/a6n2me7RiFNC1UVrXad9OCkzqIEmC0cvepH/emUsVrOGuYZTkwDWmExCQ+UwQPbpNh7SxcZkfRxparMl4lXQRRArf1mivJLdgFO1ptiOSd23eE7qtI3uKmkOHu+3GFCLO5+CFJh0a+yHZ4n4QkewjVGNeixfTg47tJDuTkmWHhOc4ftfGh76UO0gviPGEZwcq9uD9hQzrTJLjnisM9M16zuC8lEsRON8IlkKEyW9PW9gCEPLIzyRnicgq1Xo0TrSY9qtPy1YmG76wL958UCMmPjWHtL3Cotny9VjAO3ofCU625gHVLViyJbb7mKazmzKuimGmgMTyTZHADF7RU4AXr8ypg7LPxPTKodr7rFD0Uw3j4IIyh/+brA7nsugzJ7i6kp71bGFftJpvWtc1H7elmXeCW0migpSLWvXWtXn3IuvAxm2mpUQum6OKDRGytio4y2wc3c18N2Wdcxwq4pDrua6CurUxQAbFaC51YinnqAnqqeGKaV1Gv8oMarW8yuEsUJCGUD8w98A8k7+ZlU8prDOUjI2G0+ztp0AzoeazF25yLUWSuL4SvHUk0h3YF+b0XlpVWyDPBdVyrJyRDGSCcQv1XcM+pnutijGfGjEgdi6PTnlRROIaFY4yH4cVsjXLPaKKBdGoeapK43deHblf3UHUV6jn87YXwbzlOCZ0xZtHGVz+9Ixj/6mxHlwgSWzpLjNyQvAXCe58SObVFl54yIvU7ISLls5q5Qpd4wiK47SQix17
 +Kjp8yyj
 hbIkYMVkmAIhAt2DbhC58Y76EH2U5ksu6MyCKGNE+o5srSLOG3s1cfZn14h/zan2OEz0GhMwr+mKDjIi8YavfeRckPCDM0tm+fA4gGiBSbLVULeZW1MbaNVLhIJvIT80zj/L1A2m+rDif1bvvjfLVPIgGtbHWy55km6dEVhvk3EtIAj2pYF7AaGDOLXnKLX74cbkZ1V7sp58bzNkcAMHwtK0tvrU2XnV49pUDfTSG/Q6pq+qoNz5/ZIhzTMXnIAUMZsP/8pyXgXJJjbhMi3Sh7FszFZ5d/v5QaWQueFr9tzr396Lg5rqkYvK2VA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/18/26 15:22, Linus Walleij wrote:
> On Tue, Jun 16, 2026 at 5:19 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> 
>> Looking at this, and wondering about "why do we get registers involved in this
>> API" I would probably have an interface like:
>>
>>         arch_kpkeys_enter_context()
>>         arch_kpkeys_leave_context()
>>
>> Whereby you return a "struct kpkeys_state" or sth like that.
> 
> This is close to what I was looking for as well.

Cool :)

> 
> enter/leave makes the code look more like generic entry.
> 
> Passing some kind of state cookie around is inevitable in
> this design and IIUC Kevin argued that it would be inefficient
> (another level of abstraction) as opposed to just hammering
> in the context we want, where we want it.
> 
> But I think the compiler will optimize that out by constant
> propagation if the backing architecture implementation is
> simple.

Yes, it should be wrapped somehow. I don't think this will be a problem
performance-wise that cannot be solved differently.

Returning an u64 ("register") here is really arm64-sepcific and should be
abstracted.

-- 
Cheers,

David

