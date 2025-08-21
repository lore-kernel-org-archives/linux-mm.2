Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D26CCA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 16:20:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E7068E000C; Thu, 21 Aug 2025 12:20:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8962C8E0001; Thu, 21 Aug 2025 12:20:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D3208E000C; Thu, 21 Aug 2025 12:20:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6CDCF8E0001
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:20:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2A0EF1DD6B2
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:20:00 +0000 (UTC)
X-FDA: 83801276160.12.3EC33EE
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6D45440008
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:19:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=redhat.com (policy=quarantine);
	spf=pass (imf27.hostedemail.com: domain of "SRS0=upZg=3B=redhat.com=david@kernel.org" designates 147.75.193.91 as permitted sender) smtp.mailfrom="SRS0=upZg=3B=redhat.com=david@kernel.org"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755793198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l73kjzY3ZAMDBMjTpy8HUP02H/3wG+BXP6fxZxluQ5k=;
	b=eQLZmt9yfjYdLaXi77l0UOIDCQJnIohvP5qstjm+jmBMN4THR8x3Ckp5SmisX7e4MjO2Ts
	PTHxhDM5NGbs/acdYrDz0cYzvfouDPCpHSvKRw2pI2S22IPtx08OTbEa8HubKSsQ1TBRiz
	Xbtx4B1d0tYXhkXxxCGaaqE4uPAOoUc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=redhat.com (policy=quarantine);
	spf=pass (imf27.hostedemail.com: domain of "SRS0=upZg=3B=redhat.com=david@kernel.org" designates 147.75.193.91 as permitted sender) smtp.mailfrom="SRS0=upZg=3B=redhat.com=david@kernel.org"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755793198; a=rsa-sha256;
	cv=none;
	b=IIJE1aJnICVyzInFlacGBSOExkhJxJYGaBpifY3nJRG28j7i6myfIZS7m64ZWcojVr09tZ
	bXGUqUImZAwcX2bvEv5fcW5u1RTZWxGoQWFz9TN7Ptl8xcbogILbMyYY0Z1Fab6K8F50rY
	nwrnQN8PLGZBXwPkjUbLfQkkMAevruA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id E38BBA58172;
	Thu, 21 Aug 2025 16:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09403C4CEEB;
	Thu, 21 Aug 2025 16:19:54 +0000 (UTC)
Message-ID: <443d3d83-2b1b-4def-99c4-1b09ddc9879b@redhat.com>
Date: Thu, 21 Aug 2025 18:19:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: remove enforce_sysfs from
 __thp_vma_allowable_orders
To: Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, lorenzo.stoakes@oracle.com,
 linux-mm@kvack.org
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, kernel-team@meta.com
References: <20250821150038.2025521-1-usamaarif642@gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250821150038.2025521-1-usamaarif642@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: stjiodxhjortp1redpnu9o6h7ax5o4te
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D45440008
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspamd-Server: rspam05
X-Rspam: Yes
X-HE-Tag: 1755793198-349801
X-HE-Meta: U2FsdGVkX18R8FMK79KCMkizWXl0+hQCbuIlxub/+dWtGKAZybaD51zK5H6BvfrfWcMt49xhne/hax4I1bQ+Zj7KTrC7/2P3aC0jqzhJTTVApLj4PhQ2RD6ySBulbs00oR1HxdcOaKncHbWLeQMibsaFhDr+DLOiF+wk2mvGmCCxhCMsGWyo5rHyxeiP4VYbHnQDpRfY0+MHvfU0Js2rWl1BEHQe1udaRQ8iumPIGhH5JQAnGgQ/Z0ejDrHIugaST5ORJaNUT+d19LSkqIK8SIv8FpCB5v+e07KSrL8hSopjvTkVqZHDg4Vl3+oWMFTs8c/BU6zY7DmHRU/PaX6hktIY272QS45ty3UcgdA6I2hAaCXGeJxM/0LtE60mmnVmX4DwQK/b6AP7h+NHuncvJoJEdoCXZzYWm+94kUI72fy4F5IjMUPzrcpvM0og1dzn8t3tbj7LPTKbjTuesL2bz0hHO43y667LhAK5BTHk70bo7X3upxqB7TaZ4Ti752yRQtQgLzNdPJl2kcqDcBnAgiswW350g2nETiJ+waAxsB+Y2MebA73Tr+6Dec7aNuqy1qgpppN8xdWU57o+ufh6dD2PE1+cR25cG46w3OWUcwb7W/d0EGzo1nsjMCXcP74SKZq9pwZKcspBTQJ9TpOKJN9FYtJwCmNsezfssIrz9+khKMAfRUk1cLsF52VVOBuyh8g8n8+Y9xfxwkddZkNGL4WDMZyfls/c48v1FGfKQVmqHGUuR/tU33YlBJmJ/2E7L59S0ks+q+RqustFtyCVzQmrcG9kjb1YZQplyyMmPiuK8GNoaJgUJpailCosIM7zPEnlT22CIDA4Em2ACUmI0fpzmQSIayb6SPc9TdTagrpRh1oDeiGkYWVlRsCh3yVjdGIXNvYBDAhxahY8a4UJZpIw1ZO6FzXV6uG/fQuyijLGnQYl21zQj2ROrms/GL6GEOZb0EuJZv9PEWMnoCj
 rBWSfTa5
 huLpSkoTYeRCAFLgT+mi10LqgTv/HR6W2eDImUlbuew2gT+PdsiII6ya3Y6cI9u2DV6SuZm0S8MDSyvXpMrhQfTyBzmhflRbX5gLrTS1i+rcclKXaCYfRgIX7YWVSq2CLWsaFstVFnqwb0aH0ztmBXQle+lc+oefaNZPmr7rUu7qtHYHt0ZmYJYlMXlaENRXI+rwpCSFZd2gZH/eTVFp/+psKXkrP3LkhI5nMG5s3hMYyvHyccdtJRG4WQhFTQC2BikN6cCr8FdykjDcAIiac4Zzy8qfNvk5Quv05FfA8juUSXpEAoGwuXqQz7JUmdgkMDxGD0Q0sfPvYliHFkBLXyr8PgseWnkB5xKi0xdmIEKuip/uYVrT1hoXyZScJIhmCVCTmtH0KDAVupC3jDxtlU4oFw+o0NQgzMPTqGZMKx8wuRzQUJKv4T+hONN1+R1VGjl+5ZnLL9UMcLoM96YBn0Aj4nmmvRrJLRT5H
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.08.25 17:00, Usama Arif wrote:
> Using forced_collapse directly is clearer and enforce_sysfs is not
> really needed.
> 
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb

