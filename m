Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 464E4C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 12:48:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 307036B00DD; Tue, 25 Aug 2026 08:48:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DEB76B00DE; Tue, 25 Aug 2026 08:48:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F50C6B00DF; Tue, 25 Aug 2026 08:48:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EDCE86B00DD
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:48:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5D3DDC03E8
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:48:12 +0000 (UTC)
X-FDA: 85139769624.01.7C0687A
Received: from mta1.migadu.com (out-101.mta1.migadu.com [95.215.58.101])
	by imf21.hostedemail.com (Postfix) with ESMTP id 52F0A1C0008
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:48:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vaLj+Fl7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.101 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787662090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AGes/AwmwaJVSq3pKsSXdhEkCyH/JkukFofl5OMHhFo=;
	b=2cGi8h6RyPe07El2kppmY1AXHCSMlStMlLSu0U3NaXY4msJdtu30Vc1mVKPCh9WI/blRcf
	oOM9wh9YZNSvvyiZQUyOGVsY1I7Wnb3cxnbfikKeOhx22gbCoc/b0Q+bZR3A3WYAu+rM7x
	432ckGFhuLzzWJc6pZnkFjQxytJuaYE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vaLj+Fl7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.101 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787662090;
	b=r7WbWiSDgLF6kWPbRoZynuONxSYe4GJpPwr5tQNDkVuTeE5NRXmYkC1JPxg6YNMrikjKSj
	ZKIN5C3xkcj12r8w1GQbxA+DLNohzVbnuArFBsNgqTrBcigmitWjznt8jzA+1FUFC7ciak
	vfOI6sCaS9u/oLhWhZlU3SAdItAYSgE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=xl1X/ERnfdb/Po0MH7kJ/YHraADcPjNCbK3IAQ+MWqs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787662085; v=1; x=1788266885;
 b=vaLj+Fl7HSE4h7MF2Yt3FmAOp19+eVa2mpUmlNxBEDVE6fVsPtxa/cET68m/VtOSw5joC2lQ
 MqTrP2e90lJdBAxcl3DHdqAO7Ko4h2chI+v3YOTGtwHIFl2POgITrvXQ+aM9JdA3yS/UYv578W1
 PkLD84+SNRS/F9NSIWDsBhu4=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.244.244.3] (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id 952ab7d5463f0b6b;
	Tue, 25 Aug 2026 12:48:05 +0000
X-Mizu-Trace-ID: 952ab7d5463f0b6b
X-Migadu-Flow: FLOW_OUT
Message-ID: <bfe1b5fd-30d9-4d0c-9c8c-a8801a138e3a@linux.dev>
Date: Tue, 25 Aug 2026 20:47:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: khugepaged: remove str_dup() usage
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>,
 Usama Arif <usama.arif@linux.dev>, Dev Jain <dev.jain@arm.com>,
 Shuah Khan <shuah@kernel.org>, Barry Song <baohua@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
References: <20260825-remove_str_dup-v1-1-0ba2121a820c@kernel.org>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260825-remove_str_dup-v1-1-0ba2121a820c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 52F0A1C0008
X-Rspamd-Server: rspam07
X-Stat-Signature: ho5r5ze4efjinz3aynzuag9u8bymqeea
X-HE-Tag: 1787662090-25248
X-HE-Meta: U2FsdGVkX1+Uckc6Yyy6VCo3K5fhIYE6pIFAb9XHY5rFjw0pn1LhJvN6b9vrEIschl/tWocV1r7bkfNQmteDavIjABLz6gPSspwWeKa0UTlXx7jymoClMilhg5VO3bzzXDZj+Xrrs0V4GHXH2RvkVd9UujImwrECd+wKE7SWArGPAC/mjovtYBH/viB2bLPOC6m9z5LaKHchMWmetvR7wNePKoOAhmyqSTpntlht4pUBpHYyXmI2VBQLSM9oa+O+9wZ8Bs9wa39WW0S0oZm/4Y3H9VVmx/duiIMlkuOOAsqoQukUdz3rEVzwTSiV/ZZAOdXSWDcIcirNbnKGUsKSDWjtr8LwTxDd7PoNdVKnAhrZph2BlHcWPlmce63PkbhzBOF1jwMdDNpPyCA+ry16KLTr8NL7uzSVbDjmuwKalEqmUg1A9wRvHoHnuvSuvqba7cOtlQezX8wrFiIIUOIUwy7oE9b8U93zAhqpQcN/4gnDNPPVDcc7Yoq6M1mlJSq0bRqI5UqFmgVAqKm9WpPnoxqFADic1P41cxvi0xQxQXCt6XFns5jZjwBQYOcIl8Lr7nOkye9U/hFXCPYF/sg3TTIDed0OqMrDyFMvTuhGwSbQJp/WrnTuCmUrG9uIQ6prT3gYhCY4fz+IcWMc/L80FgZM2lCZ7Hziv6QR/RqHOmdMP0x4BnNvlHnWNzPKCgMVSo2QPz8BdZqE12VjZkeA4MWQo/Wi17enibRXH7P2yXhkMMM35m70pOQjfv9dCXXcGLkNjiO7zk4DlpnJtqxTR9SAAb/fGkFtS/ki+SjgHT7AiaN5XLyMTODYXMBspnPwOe1Bzlgu33uI6hmdOPcq9C+JHs8fYixw+QqNHVcgRw5ZgSJCEPiLpdZ39MwzRipdlMp77xJ+njve919nk+4yB2fH8OPMb7buo3AJYdulGI0T2NjUFTlzS4rbQHw0xQnCoO0uDOPeZpb84XTmruu
 rfGRsGo2
 hf48ZbnN4kJTigP6obP4C47CgAML4wb44SvaxOUj/DrMhEbLMQnm+0f0pzYiu7RiUXzzmg2eP5lbwJSuJf6khYmW+nbR3I7OehP2DITg4tZb606tO2G6zWfkUQeutdwnS8/m4RY6OZenz3ocyR9Qt1Gy51p6KE7XwXjK61SRDD4C/8DI5mIxPEjTkbN/miage5k6BpZLUPlz/7GgCYXDdPJ3k8t7YP2S+eE4lKdoj0soV4qNuhmE4lQr4XZIGH2vZf+E/Cvnaq5sZ++9E2hEDMf3oU97tG+L8sfcuBnsdx7CaKCY35gL0RfByjPqF+nVt7ZY5PKJPJQoKG9fS4zxtKlDMw2+71AFiSx/v2IQKABprZLYCWBGe+81HEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/8/25 19:20, David Hildenbrand (Arm) wrote:
> We don't check str_dup() return value and never free it. While both
> things are irrelevant in practice, let's just clean it up by working on
> argv[0] directly and avoiding the str_dup().
> 
> Nobody after us needs these parts of the argv[0] string anyway.
> 
> This patch is inspired by previous work from Anshuman Tewari [1].
> 
> Link: https://lore.kernel.org/r/20260821114416.12255-1-anshumantewari123@gmail.com [1]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

