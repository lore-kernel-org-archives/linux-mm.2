Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6D20C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 07:13:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8EC76B01AA; Thu, 13 Aug 2026 03:13:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B679A6B01AB; Thu, 13 Aug 2026 03:13:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7CA76B01AE; Thu, 13 Aug 2026 03:13:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 804B16B01AA
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:13:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7D472A2C10
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:13:11 +0000 (UTC)
X-FDA: 85095379782.02.D5400CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id A22688000C
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:13:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YaH3wzyy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786605189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ljZR619xg+IXw5LIW+/SpuAVOzKILECXTZKiydlMDrw=;
	b=34/YKphlbiT6qvYwc2VJBAV00rKnpBwuZ6IaB5dAK2qLlD+bk01JyQii+VIMHx8EoJ8POs
	LEnORe5OYydRdJdo0cZ8I+rVJ+SDHRamtopTRQT7KseLTBIZX6YPOEqFdG5JyA3MrCVXCi
	GfJIzK+fn9EK0CzhQKUcMRt5YXaebuc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YaH3wzyy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786605189;
	b=0eH6CjR0/nR3Pzp2QB0GLUbvShe1XA6NKBrL7C6megfwotxz/YSteiYMYl54CfqejoMzyL
	lr2TtmO6qfrhRPgENGN8lVGT8ffwrcMifSAbOuAcvlCV0GulR/qWGWhyl4QV5A08lKbUT+
	o6DOwvJEWxscpYCIE1WXFVm7MZ4VOJc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CB644037B;
	Thu, 13 Aug 2026 07:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21551F000E9;
	Thu, 13 Aug 2026 07:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786605188;
	bh=ljZR619xg+IXw5LIW+/SpuAVOzKILECXTZKiydlMDrw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YaH3wzyygs1VGyF3sOYA2UaFAQ3B0Vla5iInKG9FE3ZDZPkQvi3cyQmQNeXFR1XHc
	 dhPW7kRsGOKKOGz+Xd3UChuCft253Iw7vXf6s4VvED7WhgGiXZQBo6wdPJxNDSxhmZ
	 UVAvuHO2YzanXeSk4psp7bhqgOAeHB0DeCnjl51ucWJk/Kp35u2ByRJpBk60aKkDgv
	 6Zsxe+bohU3dUeu87O9rX8DEgxaZ+eY2vENmhbuaHbvp1aLhS4Ln1lja8SjO86Ug0W
	 JoIU8Wr7C00avKW17GoYKml/WW/CK3iw86U13XpOclb5nzQldXBZ7fLwYbR5COdfh2
	 qVx1QxoXDGd4w==
Message-ID: <6bfa6c93-4eb5-46c6-9524-7b59297f3601@kernel.org>
Date: Thu, 13 Aug 2026 09:13:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/7] mm/khugepaged: Refactor the PTE state checks into
 a helper
To: Zi Yan <ziy@nvidia.com>, "Nico Pache (Red Hat)" <nico.pache@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-5-ddac39d61c4a@linux.dev>
 <f1371b4d-6e98-4699-8c1b-7612f6d70f02@kernel.org>
 <753cb38f-66b4-4bd0-8b53-7480efe30ec3@kernel.org>
 <DKNGC4X9V83D.268DMWU0WIILG@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <DKNGC4X9V83D.268DMWU0WIILG@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: xzwjcoj4z4f448ekpd47gwk8wuiu8a57
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A22688000C
X-HE-Tag: 1786605189-944305
X-HE-Meta: U2FsdGVkX19I9f5RpeWA4tyPcGsencgXA1/oMEce7Aw9Z5ZHXWYlO1ijhQqkts9N889bMQG6q/8XL7LPkkuBwW3jFy7a3OkmEBq7vWNdlpS3ENpcLYvZ9/69UHOJji0pB2WbJOEw8c6GJfVVNFKR/RAGqF9kTSv2BFcBy5iV1WmU6Qm1nk/mObk5wph2QaAS/BnRRJrUre2Q/oVVP9jR7jv7RImsqVJgmjHJkVEKUplRIm8DvSMeZIv8pgIIs5Op3O81dbwIsH728htXVr3bjsomnzwrRFIICvbHbYu9g7H+GjxEYMR5dkRahJho/69gH1EihtGmXzbM23MomjzZsde+diHyC0c9Jb5bP6DIHZ7Z+UGAeirwHfflMRhWrXaup6Hvveivyy6Mz8IM3Hryq2hFaImwRItq94dVundVcYX+TdUQuxY38dQdK+It7j8SMCV/yLHuOEhmsyZ4tgd82JE1QQVE6i+pcm53Fieqv9fGkCgGYRGJsH1tu7RpXWpqQhp1mGA/MjsmQkFdfRAAbjDgaFwu1/zIigfg/zJ43lWKxnNZuKRIjHwG02z1nZh9GC1EDBMauK6mjQRwICIyxocujIxiyAJ0w0BFSgYtlcwxfmdriNllF9hdjESURNuZ0g5C7zUJ84KSn7iUjcSoutjdX7PpNlmPtN8WsgMEKEWfoprDvZ8u0oFFvPGM8Jwcprdqnw/O5MVDbAJKb1M45czk37IyHa2Lsj6rC1H3KTraOeaRuTInlfGGvSkc2wJPU/As7d31KtE3+5ILw9zja101vnbJqZMFDXXx7hjlC+Gm2KNRoqNV7Jw8xSL7kCxj+LYYp2qDjk+qYt8pIfujam4U2Kq4XfY+jLFy/Hi2WD3nq8g2D9jbaHYoJts3apFgtxl57pS81Oq6v+Qi9YAIFR5bInzQ+l7zbxXBu3QTrAnQ2ICrygCfx6CpRjm1F9gjhCFolbnxSB+zTWmAIFQ
 XnYSFTk0
 qqAf6t+Z4aN38+X7DB4XEF/nFhNpZwmosnPypHAefthTSFNE8KJylKZMFZra4XTt4XofTF7M2eFC2Hk6BfuRjD2Vu5rRMF3qa4vR57STLGIH+V76l/EtO48QlZinYdwzErL2xKNTufjDMJA59thDgKTgHz7GEvXLEYprnV66aUuxAYHJ3sqqZr6oiUHbfUNV7nWq8dtKIleQd/GVDyGtffwM2qXZRV+xmLd3/6AH7MLbkfzKTX+nVs5uz9ePVMVvWPQ4U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> +	if (!pte_present(pteval)) {
>> +		if (ctx->max_ptes_swap < 0)
>> +			return SCAN_PTE_NON_PRESENT;
>> +		if (++ctx->nonpresent_ptes > ctx->max_ptes_swap) {
> 
> So max_ptes_swap is actually max_ptes_nonpresent. But due to
> khugepaged's max_ptes_swap config name, we just keep the variable and
> related function names that way?

Yes, that's how we handle it today, unfortunately, for historical reasons.
Mistakes were made.

I think we might be able to convert this code to actually only count swap
entries, and simply reject any other ones (migration, hwpoison, ...), but that's
something for another patch.

[...]

> 
> SCAN_SUCCEED + folio != NULL means to proceed with the pte, while
> SCAN_SUCCEED + folio == NULL means to skip the pte.
> 
> collapse_anon_pte_check() probably needs to document this?

Not really, as you say it's straight forward if you look at it from what's
actually happening:

SCAN_SUCCEED + folio != NULL: check folio
SCAN_SUCCEED + folio == NULL: don't check folio (no folio to check?)

-- 
Cheers,

David

