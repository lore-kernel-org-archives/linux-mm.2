Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE354C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:57:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3E556B0099; Mon, 28 Sep 2026 04:57:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D166A6B00A0; Mon, 28 Sep 2026 04:57:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2B7C6B00A1; Mon, 28 Sep 2026 04:57:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A7156B0099
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:57:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 20056160149
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:57:02 +0000 (UTC)
X-FDA: 85262566284.14.95E771B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4B63240007
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:57:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JH+eE9go;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790585820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U/es/Q6WATzmcpCkf73wnBo14QES0LRvqpHHAkP1+Fo=;
	b=3DL1dudaqIYT4FN8FWzdFwxc/SARwWTgVNwHqwJGhheF/pW1DFqqkIj/1Hj6Z5zh1orNb0
	fkMTBa+AGQykFJ9+Qjstiguxc0GsZjzGewCi6TPfhkw0DBGtsAPnd/fTLl8aLY6yaijSAM
	rvbV1qtbEA6nKGBujX/07Ztltabwvww=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JH+eE9go;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790585820;
	b=p+xqDUVY3YPcarf9yOB7LgTDbnN0WkW3QuT+CEVsDQUpcKYv02bwy80RI3wOQ3ScAQ9QWM
	TlcJF24PzOp2aBl05ciQAIJ9s8GaYNvFhtdR6TlP7zG1EOvojOIbrcCodI65XqQw38w4ZP
	ar/+r7wZIsHBY8AK+2+vIZWILSafuOs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 75C5543DF2;
	Mon, 28 Sep 2026 08:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580571F000FF;
	Mon, 28 Sep 2026 08:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790585819;
	bh=U/es/Q6WATzmcpCkf73wnBo14QES0LRvqpHHAkP1+Fo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JH+eE9goK3rIn18v64x245T5XiGN0xKbfc/yMGdWKxFecHTX8vVxR/Bp/RhgQ3dYs
	 I25+7FZsblm0M7Lg5E1uQIi/zO6fE9bh+v1DLVoDKHruUJg27Pr11zdKknZdDPWJmr
	 n0XxxGtRTTgF3pf12tH6f9zM631CLRHADVgQyrtdYKU4UP9UMeOynUEEA/GlWd7jqJ
	 Svh2sqlBv0baQZy+xp9E072C8feuqjOWnKlbaDrQ4F8m+efdlQ1N9iKhzSrxdOyNZO
	 cHSrCCKDUBC/z4A1gMjLXrXStdvs1Rc/iDMyPQLXUa8dEFAQhaUOe8OBXvjli4Hclg
	 GmGqb3obY99cQ==
Message-ID: <85284364-9e38-46aa-87a6-a81720447c07@kernel.org>
Date: Mon, 28 Sep 2026 10:56:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] hibernation: ensure secretmem pages don't reach a
 snapshot
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>, Len Brown <lenb@kernel.org>,
 Pavel Machek <pavel@kernel.org>, kasan-dev@googlegroups.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org
References: <20260926-hibernation-v2-0-235f69f3ab2a@kernel.org>
 <20260926-hibernation-v2-2-235f69f3ab2a@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260926-hibernation-v2-2-235f69f3ab2a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4B63240007
X-Rspam-User: 
X-Stat-Signature: dk41kjxsif7j9qrqhirjmpbd6dazmzkp
X-HE-Tag: 1790585820-638635
X-HE-Meta: U2FsdGVkX18Em2NHGBsc3ep0ayF5nvsT5fMAkBubeZiLfvamttRWM6N7HXZ9+UHTWdv9VkUBNCemvPNZXTOpaEqiOXSXdD/0SzcMf+FZhdeOaEkFtdmQOlO3FRy0ijNz7/Flz+/CW+yhyCkT90pOO+X86iOtRN0rYkWK8DSBlPLZmHeby3AUYP97zEwZ/SAgBZKcgnUbql4Pxbq7BRvHeL5vNwTvuQw/yMwXlbRBaXWoy1PbtBkLQtE7HxTFxzPcw3S+YBP21ak9TPH1J3OsbTxL3NPQCbmdi+XIY6+h7cjlUcUxhuUEEW1OcOgUCYAVnAyWAJ1B69p048hkZFn+lIBtxdwd9ShQiaTD9A0SweSvHwRDaQ/TCNG5VXlWSYzXHAn5JVD3OvmkRAtpNT2AlssUpnXopz8PrZ/8l7OJkhuLeT5EsG8i+qObrUhNXy52WamVmAFCeNsMX2MKpPdR6hnQzx/GtWnRaapXtdrHatm+U16XGngErjmKbfuRx+z4K+pegdjLpPCQolLedPU6f1DiHfEtg3H05lVqztjryJd8sOin2nWam8hHXLvJX5p1VhOy8lStYAVrbDV/ahN65w+EhtQyZ5Yyb6RMuZzy4VBKaX6eWBc3dOIDClI0G4BGsF1Qg/FU4x3QAHiR5UmtrX+6zUJbDDLwzlfS7Fioizc1CGTM9vKDrXoe32hQ6KhpM/VAeQrsxva8dq7rB3LnweVu/XqWkdLwELS/TvAZg39ctPRhsKiKZkbpxYPMjp0EFxhVJekOp3NSKdKWn21OIuI6OWSpEitW8OpBrwduCI9K9QXt1z1dVglUhEA3OvgpXjyZ3oX7CH5ucpd9KpIHjtVJvHI12zh3Oc9DFveof4C8bvPyD9rRS3LYGlJN7KomgytVxWEvzhO4RnzdwupmpMVegX8LpiDqgVPuWkuPKdzz6IpmPOG0tWDdy+WqhfVeKMQ9WCLdi0FTpk9b2c2
 TK8BqzX6
 jAMH0xqGAgE+OvFlLtEkv9P6dVOB8ksDHhW7q1xp45cRkDvL4Uo2lYc0UZRRzT62xoQk3TgJMB2i6o6AF1qnWPxKKBZ1sH7NNth0Sra3pKK9n/t7Fw4pbthcyIZBVlP4zH5rTFAKclfuLmh5gjq4gx3QvBj9hxj0KU3yYjY/h3pyaaduGTa+55P+JQDVy+KpVvj/7R7e92R0S2dFPN13AVpoVc1Jq2/uBPh9oCuvgMx4ysOS7Qz58KyrT7MGq1MeC+wrmhbuzwGZnNriCUa8TyRPVcfyXPi6mMhrb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/26/26 11:26, Mike Rapoport (Microsoft) wrote:
> hibernation_available() checks for active secretmem users, but a secretmem
> file can be created after this check and its pages may get into the
> hibernation snapshot although they should not.
> 
> Recheck that hibernation_available() after userspace is frozen and abort
> hibernation if it is not.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

