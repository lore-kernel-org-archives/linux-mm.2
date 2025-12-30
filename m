Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33414EE4999
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 19:50:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 842AC6B0088; Tue, 30 Dec 2025 14:50:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EFF16B0089; Tue, 30 Dec 2025 14:50:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FBB86B008A; Tue, 30 Dec 2025 14:50:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D8A06B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 14:50:22 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1424114028F
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 19:50:22 +0000 (UTC)
X-FDA: 84277179084.05.32E8006
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4D46E40007
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 19:50:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LctxVuP+;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767124220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JgKiXrd3O1ADwnEAOpQmDjzAv2Fil3aPwM3FQ2NOb3o=;
	b=6O+Dq667+ZZJp681nBirqzicbGF898DAgrMbjhWdDRyG6p4velDaLa8WslTyLX3VTVjbxV
	Yz530dUnem9RJFY8lCQltzwFMOSXETCu4+4XhbP+uA+J/bvBv+aTde0+pqE8/noxDAP2/g
	1bgQSgxioWopSnRUuvbLNqOt2lzUe98=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LctxVuP+;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767124220; a=rsa-sha256;
	cv=none;
	b=FukTsFGYyVuet96wrCydG5qfoidsdDne6BnSFJfaEsLPsHYLpnUEkVbn8TFk3R+Ghb7v4p
	Fnr/+bf5ksR9QplfFquJQQ6O9e5LKGIWM9KrBqNiz72p6wBDjdP9YXXuyQyrvAVDeTg3Ff
	P/6EYbRpBEwvfJl38avfky9v/hq03Wo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F1C1B41844;
	Tue, 30 Dec 2025 19:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA735C4CEFB;
	Tue, 30 Dec 2025 19:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767124218;
	bh=6/uuccFi8B5P+mwhXwtQ7m967pcf1JVoQNog8D4H3Ic=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LctxVuP+edtIZ4IxW/HuJMuZen7QzAstVgsd1GcvRKEeq4EmDBZDMkksyZ+4chiX6
	 5UeplLB87siQPH8XOdTmF2yBQ6+bwQBA/ndq3E3pR7ik/DdIss74eagMQPEBu+VhOA
	 ioUNMoP8nP5LWd7xRoUsisaU/qbspUy6S2T5Tr29Vwnihnh26K0rCdcPjqn4kLPQEV
	 B1Ki8UxgFP221L1GuGbGA3z4+lX9Tmf2PR5F10cwNgikq/ExoT5hk1thKS1hdVWoTV
	 fpVam8nK4FFNAJhqBU+xjpQIrVc4FghvO9nqMDcq5ASyCSubXc/66hxedkHL6TbvG3
	 RFsdQZs4h+G0Q==
Message-ID: <cb69a1e7-e836-4115-8733-12d2de879f51@kernel.org>
Date: Tue, 30 Dec 2025 20:50:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/swapops,rmap: remove should-never-be-compiled
 codes.
To: Wale Zhang <wale.zhang.ftd@gmail.com>, akpm@linux-foundation.org,
 chrisl@kernel.org, ziy@nvidia.com
Cc: lorenzo.stoakes@oracle.com, baohua@kernel.org, matthew.brost@intel.com,
 linux-mm@kvack.org
References: <20251230130110.1366374-1-wale.zhang.ftd@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251230130110.1366374-1-wale.zhang.ftd@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4D46E40007
X-Stat-Signature: ghiswnoarabygggshxzti6bwonfy8wb3
X-Rspam-User: 
X-HE-Tag: 1767124220-252367
X-HE-Meta: U2FsdGVkX1+ppfR9D1/Op3IcxjdvjQn+B2uEtOzjVF1EsoFDy/adqJcSsYSiBrjvjVF2u+Ml+X2sKi9Wy4gfgkRqyABRj2EjgR9ye0NRY1r+IbK/dRiuitTJSMss5OeUN2XY6SJ/rLXbB/AiDHBz0ECQwMHXZdJRWY2ov7NK7ThUe6d7BaXd+pGQSvaoRrChhlWg1R/VcSBqL0bUqWWYvPQIprRKJ9DhImPFQuBuHM+o9GUDsFfot+apx6xaDdTMFiM1bxnKpV0XPNbRFV372XGaAl+Tg231Ojhu7VbT4RO5OU7Ypplm+ErOJv2qUJEPe7QXbCAiKs8IiQRsSf47d1cRk3oQIA0FpRdb2dYYg0xRcocwXHS0SA3wJeaNdV9auahT4VoP3AUzi9DI83Uk6at7wGNAOL+xT9EjuQroeU3YyhT5CeRq3II6Tiq4vaca4owpo2Qs32GfPX+GGBrbPbYnHc63MdqsbaOQjh7TAVn/JXHcUB6G13oWyWcBPksX7I4pHQ6GaUrkh3x9YVjYmiFxxRqGz3j3Bf5DZLxc+UAuG3lcqIZ92jDL2fz82LwFRhhiSghbhLPU7U9FTFNvFKnZjKB97HwBwwoA1Y6UMJhBLYQBKMyIfvTmnUqTRznlniEtCbrxr+fXNpJsKs8/ZRr/HBVGmbmccXHCMwvPoB41RRBdEp8MgQd7FucYBDaqJmawlRDfqlohxxBBha7apMuvnzH7qWaiI4INI0u7BGD8k0b8KEj1rE6y0b8pvkLorFbuS4wkoK0d/nt7hsM/PrpTT6jCS+TjDclFP781+700K5sBZN6ruzQK8zcWcB+2B5P16ilaWOkaFro8VO8xAHw3RnxzQE7wNgQhkJAswec7/HyIepc4GVtnoMvOXawa4YFAhR1afvOA1BUOck493+WWVLSE44BXOLMbPsPbSNmQP15ejxkCL+6/AD08zLjAhv8ZCM2J97ApTclElaf
 qKTRGua6
 ina5D55ngKezztLIlfDPSuwluUg9BaeRcZ0o7L6sefRjzbJqM+jiGf58IRB28DzasyMaOneU6z2bk+cQlGYUmtj17+jknTd7Ebg5DfITZ0GMnMeDFYQyEoG1KEIvHg7KnI6zBN5hReZWSns80Tj7P3+hkiipyg+M1uipALt59XS2F2VPJZoMFtKcTM4BeFxmC6F+3JVTm3GSETqx+re6rjOjKi6H4LyGPWZTdrdaFP8ZNB/Z5HWzZCBkPtiHs9qJysjZbWkUMcqZEAVAJYPdjgUaxoewyFpzF64i/aVvcv15wKOHgUAxAC6DEqq2U/BoDV+dop0Uet8jz+vy5iHpjky12KBJ77+1YoAHv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> -			break;
> +#ifdef CONFIG_NO_PAGE_MAPCOUNT
> +		last = atomic_add_negative(-1, &folio->_entire_mapcount);
> +		if (level == PGTABLE_LEVEL_PMD && last)
> +			nr_pmdmapped = folio_large_nr_pages(folio);
> +		nr = folio_dec_return_large_mapcount(folio, vma);
> +		if (!nr) {
> +			/* Now completely unmapped. */
> +			nr = folio_large_nr_pages(folio);
> +		} else {
> +			partially_mapped = last &&
> +				nr < folio_large_nr_pages(folio);
> +			nr = 0;

The whole code was written to avoid ifdefs.

Sorry, no.

-- 
Cheers

David

