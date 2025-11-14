Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCC90CE7A8C
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 08:55:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 162448E0012; Fri, 14 Nov 2025 03:55:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 139A88E0011; Fri, 14 Nov 2025 03:55:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 076D58E0012; Fri, 14 Nov 2025 03:55:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC9928E0011
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:55:57 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A8BB91A029C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:55:57 +0000 (UTC)
X-FDA: 84108605154.06.10D2F89
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0B07B80009
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:55:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cuDJC7iZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763110556; a=rsa-sha256;
	cv=none;
	b=XNZ97Fe6FtSm0725y4Rr/poQWbyId4vfP7+/vHf0KfgY5HUXI0BR4CaVreq6dhMoD2WamW
	zyMuF7iCOpyztEjawx94fe0bEepbQrOFcI1i/XeXukeakLKgAVt2Ybizc110ywCsftPL4p
	8BbxIPparNg47XowFXrEYeAMAgB29NE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cuDJC7iZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763110556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uwf5bRU3kexEmP1AXYZm57AgucOAIrQvx+XjIm6xsS0=;
	b=jtxxsFO66yLdUTQJz2Itv93xW4c7AEgy2xKSlEqnTWWH6/ef5oBlmQbq2JK3Y4Ox4C//1D
	U1wP9bMkhFsGIfGseYgsu91YHQ/XqYhbemgmCSW4P3N9gQJ1IjW71CFuSghhcX0Ugwuev0
	jFd1XaoRdPdbB/t0zluYN+WorJpr4ZI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7CE2E60167;
	Fri, 14 Nov 2025 08:55:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF61C4CEF8;
	Fri, 14 Nov 2025 08:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763110555;
	bh=Y9GaWZjsaZYBlLOBfHlz225w8pyP9PxE/E+ITzoHF9I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cuDJC7iZYaF42xW9AIG+wfnPQeCsU+GOAUmZ/kExTcKDqdSii8Ga6RMVMjPaL2lTA
	 9fYD7u7MXv7Z0jj7/MGZe9JwQ4w4dy4wlxynz3Vvy+rxXOhxpE7fJic+qXj+BQFk+x
	 XXsw4FSEoadJ1ubG0EJ22aTcCIiHe5a2NSC+P/4LCCt9xMQQbyqzWfyU6ZPRQ56eof
	 R6GTpIT7qY/ThoGAaLsmT6CT5S51AS1rpEExWKGrkwdpcvwJTgI9QIokZJ7aZGLWD0
	 x0tXjwN/P8c5tsVQGMyiDxMN3mrMQ8MQdUPu6nQN2xc4bwslL1PIIoAuQkCIHcutM4
	 mqODBQbYUho1g==
Message-ID: <5ae16c37-dccb-49c6-a43c-7f225060d8cf@kernel.org>
Date: Fri, 14 Nov 2025 09:55:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2 3/3] mm/khugepaged: unify SCAN_PMD_NONE and
 SCAN_PMD_NULL into SCAN_NO_PTE_TABLE
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com
Cc: linux-mm@kvack.org
References: <20251114030028.7035-1-richard.weiyang@gmail.com>
 <20251114030028.7035-4-richard.weiyang@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251114030028.7035-4-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0B07B80009
X-Rspamd-Server: rspam07
X-Stat-Signature: nb1eu5ff6cb3751ypda6cyi9uxot1rox
X-Rspam-User: 
X-HE-Tag: 1763110555-235816
X-HE-Meta: U2FsdGVkX19YbeuvCeXc1WydZ9kGB11rEtlTeKMOtH42t0tbQIA0tkvimxih/0Ox7TvRf/WZOHhm8L54pUSE/eKBJbgL1JHSOMJkGHDxlfjqdXZmriYDRVulmx8X9MQ89j05vMAY7q5dd02qCmN6grhFq7+WqTx916W28HlhDQfjeJuTrzOFoTvgp3rtkOnnrLxHTjDt7oZ/JDZsiQwPkPXE7GJHU5dcpTdllEgdWMl6MZY98V+OH4wktk0Rq1tgq4uSXl+j3juL96CUjjgEoPWz7G/clRHz0+Wq3caiErpn2OjKYxQ8X36CqnlMsenloWUhX/PbPZPJaJit11gIAbsXt9yoRxVTW3NvwkLoZr1mYlCw1fEloSVHSjcX5r64kRmjWd6M+40uzrwA+Ddio/Py3zgkkqAsNPiOAXtQhNCBfSKtAU+YeiHJcLLsGXEyAWlJcxas1bteatbBtbNkgM9LV60kIvMBmM3lju9/EQlCUsC4Gri9/AD6b63Ni159HBnewuyCSnzym8A560e0yBt2HTHCi7NzaGRNwfvagzeCxA+LRbwVzSrbPb4S6Lgh/ou4vuhtFv1eJZdD3Pp3gTDdtWCr5hPNvGZaFnHq2jpTsfH+nTESuOiMGkZRp8d1ZrsRGfK7pzlhz2Jvg1y6yucRXJJw+hTOh/wByotIqwF+urd7SqAhC56fR39Fm2vxQY5yJPZJmY9zqPa1O4SB+HaRMJf6yxHNm/WNIibMHcGm1CYe/M0AfQNdmLgSgwWzaWvtCVEQxZ4jln9F9Go7cnlliIYvueel4RM14KdOTMuEqtMGjd2QPNPUolEOdGS62kgXUibjJ+s0Qj/OSAm40qlz1RZ9NUsE0uykGdpQGxo7PBxNw+hhAbYR4+KWK6+J7crYxW22BzqKjdzrX0YNDacINOGFyXAdyRRA8If8F5GbgpS46TxM2bjyzDKXZ3RJf3cepFVwokImpiytY9a
 WAYkhkQ3
 e/AeBjNIt+Z1x5rt4nZ78SuFsf7nJQnKP//CzU8pLvFF+inaUmT1H1xPNE2BB49dPA61d445JS5/ZKJfHqp3mSmZxMJRUucOi1uImY2HllEC505z5+ZnqVIVyB0O+wPu3YX0CK04M4LrYF4iAiIeIee/gpE9K2HupK01oShi55ldLtXAfbA5+XgUtb6iMa10GOYvZQotyhp4raGynl8q4uOshyONyXeLtaddhtIat5+lQjmjgUdyfw19a9GZX+Hzc3rwca7kReEPu6kqRb802wdl15HScv3/h41DWeQI8LyDAnt+4FWz5uTDoLtqnl5u/eGoW29YCnhboUUBgQAQy50tAKSMJ3vTQ9nHrkvFwZAh+uZZsV/u6naeNFb/jvHM2RrApu1HB0GHQtrj8cYxafqfWlHnEeUDoRxRxtzqdpXkBYKo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.11.25 04:00, Wei Yang wrote:
> The current hugepage collapse scan results include two separate values,
> SCAN_PMD_NONE and SCAN_PMD_NULL, which are handled identically by
> the consuming code.
> 
> To reduce confusion and improve long-term maintenance, this commit
> merges these two functionally equivalent states into a single, clearer
> identifier: SCAN_NO_PTE_TABLE
> 
> Suggested-by: "David Hildenbrand (Red Hat)" <david@kernel.org>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

