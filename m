Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DEBDCD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 12:40:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84D4D6B00A0; Mon, 11 May 2026 08:40:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FD866B00A1; Mon, 11 May 2026 08:40:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73B026B00A2; Mon, 11 May 2026 08:40:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 65CBE6B00A0
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:40:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EF5071C05FF
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:40:15 +0000 (UTC)
X-FDA: 84755096790.17.1EF61B4
Received: from mail-m82108.xmail.ntesmail.com (mail-m82108.xmail.ntesmail.com [156.224.82.108])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4B15AC000D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:40:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.108 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778503213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xdb/KFhiAGENLopBEDdNnSpzfG2KpgWV0oQyo+ePNBQ=;
	b=IU+rvpxFETuvvjJ2HEsqK4VArxFWwwRQIqvNDfrVr4jNY3yTLhIDqqHWf1cneTvO0GPbOg
	uN15o9aGnQMT+YhHL+1YG+iA9HotgOn+6cU7EvLku4olJ3cU1KGui0zfEKdCNVEIKnFzvn
	uxncqFi1WEf3N99fC/VCxBXbqpXpv00=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.108 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778503213; a=rsa-sha256;
	cv=none;
	b=NV7xsIp503Pru7xs51N9IcHKmm6Wy22YtJ6cOdx6eaerusF+9OmP74SwK2x8QHHWioo1FQ
	fofRXR3q+8g/Hlj46hf/Qq/+zdKnjEY6lxy2bmde+Ghr/iwNhbi4qo+X/rrlc6K/ONaMrr
	J3gDucwmyZZGhwoOZ/YlFA+fR153gpE=
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 19f9af50a;
	Mon, 11 May 2026 20:40:07 +0800 (GMT+08:00)
Message-ID: <d19c927c-4af7-4c2d-8c62-82b8fc841089@easystack.cn>
Date: Mon, 11 May 2026 20:40:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/3] mm/page_owner: add filter infrastructure for
 print_mode and NUMA filtering
To: Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260511033017.747781-1-zhen.ni@easystack.cn>
 <agHKWCw3CFO0CZ_E@tiehlicka>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <agHKWCw3CFO0CZ_E@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e170d4a260229kunm8ac60bde304377
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaGh1PVkpDHkJPThlKQ09OGlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVCQk
	lOS1VKS0tVSkJLQlkG
X-Stat-Signature: up8af6573hzux5dpgy9oh7qt4busp69g
X-Rspamd-Queue-Id: 4B15AC000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778503211-665696
X-HE-Meta: U2FsdGVkX1/3KjCWIYEZgw46xXNpLJAMiSLsGO3W2o25xBE3Lp7xOSOgW9j4+zexlDHJFiFzLyF0RXWcEGHfcJ7//LLT4aEiqg2MWKXYmU6/YVAuGffaDNM5/If07uFRfY1cuLFMKtIRnVhyYy5cILL6LqO6CYDhIxDeWN5QcxtPj0EhlbSaZMWL1Yq3v8qiFL/38RKzHuqv1sj+bbn3aH/KAPE8YVBUyI6eo64rxmniHseevbEcr+/iG2dYm5PJErqAx/aM8SHDWdynqrwK+BUNaR7xD+Q/JbDWjh5KMdLbWCnNzBEOYJ16XIb1OyDjPEuqHTXeQf+rMeWQiijU2mJ+gOzc9LStNQiOdDhX1S2rosKG+zVO//vvE8xoTkvMg5WsrfewztkoIAIUYGH6ejxDRkuCfFz5RTLmSdMaAIvuErS17eAJ9/1aXlEN6X2I6f0N1n5brZGxxmUiaOx0Mc5+lzzz5E9ig8LjVCDshWsV0Nib3La/if/UT97H44vU5Z4K5Q8EIWjTgSuUByhNzH4yajktCF2y7bAx0Qb39KXGQGjec3sEPSlvCc7BDJ0BjQ/5zGEEzLS5h6lIiIHkmuvIiTAH5hVGe7h/UhrQ98g4nqVj0424n1HAqzc5PlP9y9uauBBAvL/9HwTXDTRcFiws4qjpaDTWXXMFDNzUCXISXnI26LxzXFnVGAQ7tRo15y59KfDyr+If/uAIHUoVheKl30cwUADvniZ7ymJGMotoFHC7z4MMehBvPzjuqN73XTcH3CKWc2SCD43GDoeNKeL/6LukJAUg4TrY3OQticKYjIqkDFKGYlS9ewTPj86ds4php7QEopXvRjSlUCzJwmMqI866wdkIaGOQw9l3TRdSPDkg6ICm9lE0UbVRGh2xptZXqjUgHXAWy+UixXaN7+TWqpVkgzf5JOfqOCXA79aONSAhlDtylzxs/X4yajOb4+dufWmnQStxzD4Pwag
 uFWGaiZ1
 i4OEysbJ2zfVVf97wlaWIRnmU9kJs4TigRnlCvyoUG2kqL3TTLn9bovM2if86xPzeBgiBA6fGChWf1SeVPMjFnIDNNlLwit6hKnQ5tJjLem+e5ye8wy3ZqGlSx9Aaj8QfiNy86hBmv9Lpj7dM1Fl6DaJ3ld5GmjQcYPBeiCsAonpFJO8J1/UF8gtzWPaOrbVs9jYhVJBp69fd20tByIzjW3cP7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/5/11 20:23, Michal Hocko 写道:
> On Mon 11-05-26 11:30:14, Zhen Ni wrote:
>> Solution
>> ========
>>
>> This patch series introduces a flexible filter infrastructure with
>> two initial filters:
>>
>> 1. **Print Mode Filter**: Outputs only stack handles instead of
>>     full stack traces. The handle-to-stack mapping can be retrieved
>>     from the existing show_stacks_handles interface. This dramatically
>>     reduces output size while preserving all allocation metadata.
>>
>> 2. **NUMA Node Filter**: Allows filtering pages by specific NUMA node(s)
>>     using flexible nodelist format, enabling targeted analysis of memory
>>     issues in NUMA-aware deployments.
> 
> How does this work when there are multiple consumers of the interface?
> E.g per numa tool to watch node lock page_owner information?
> 
I understand your concern about concurrent access. Are you asking
about this scenario?

Scenario: Multiple tools monitoring different NUMA nodes
   Tool 1: echo "0" > nid && cat page_owner > node0.log
   Tool 2: echo "1" > nid && cat page_owner > node1.log

The current global filter implementation would have race conditions
in this case.


Best regards,
Zhen

