Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A5A6C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 08:12:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 364036B00A9; Tue, 22 Sep 2026 04:12:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33BEE6B00AA; Tue, 22 Sep 2026 04:12:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 251A16B00AB; Tue, 22 Sep 2026 04:12:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A5916B00A9
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:12:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4DBB71C2794
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:06:48 +0000 (UTC)
X-FDA: 85240666896.12.DFF6964
Received: from mta1.migadu.com (out-247.mta1.migadu.com [95.215.58.247])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4A03E1C0003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:06:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pZWTZU4L;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.247 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790064406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CDUhekT+dHHEfwUJMas3OBH9JBfvOhivPPlgcZw/Efw=;
	b=Jyihor2U06sblUNqWxaqRKcGV/XXfp12QCBcHt/lglYpTUvDNlzRfSTvASUg6X1EkTQayv
	chwP4l+aCMvQKq6p7fe43BWVokeYPj5fiQ/njPYnOeWv/IMhZ4cnZ5i95Tx4Tgnou4heO8
	nmEjz0d7HIiAsLrhTp6y29+1jdnNmqA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790064406;
	b=bquPpdhE/QbiaFG+YbzTpMINpc5+shT85DmIuLqbk6c5IjgEt2p3QVdooGNgcWsk3qPTt6
	6V/oxvw677lWf4efOLhamOTZL9A5n1RynD7XWgPj/Uh3x1ju9EnKLeGgsYpoFAKo7I1buZ
	18NqIZ+sTnVD6FCWjdTygSaRUgU/WJc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pZWTZU4L;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.247 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=L3E1ABTsvQD+v6c+2rBUEff5SSrYDo8CA8Cr1zQwot4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790064404; v=1; x=1790669204;
 b=pZWTZU4LUhgakPVLGPX5D3FFmTpz3l4NLv1Dxd8Hh3GY6WQ89/zEBlXWSy5IxOqeZKiwBf+I
 szl3QUQlqfANKxTdOHbhlH8HoCr7f/+XDZoOK/y8NyoC+YxoDfPuHfOsRIX8BFlcR76U/bkOlLw
 w+UG/W3InrzU8AMWSb8ChDwA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 69a7d16cab5036eb;
	Tue, 22 Sep 2026 08:06:44 +0000
X-Mizu-Trace-ID: 69a7d16cab5036eb
X-Migadu-Flow: FLOW_OUT
Message-ID: <8a135fee-1f75-4260-afa0-10f8b522809f@linux.dev>
Date: Tue, 22 Sep 2026 16:06:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] mm/sparse-vmemmap: drop Device DAX-specific
 population path
To: Muchun Song <songmuchun@bytedance.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin
 <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev
References: <20260913083734.86802-1-songmuchun@bytedance.com>
 <20260913083734.86802-4-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260913083734.86802-4-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ndz148e6uo56hsddn7ct8dk1pp8pdrwq
X-Rspamd-Queue-Id: 4A03E1C0003
X-HE-Tag: 1790064406-254527
X-HE-Meta: U2FsdGVkX18b/c6qOn8TPjWUeIvkMxKgaJXXK8SgeDz0xjxoDvbP4rsV+ZUjCvnWHwSKmKblzsGfv40OwNhyfCN4T2tITeQssr7qO1KRZ5x+lcFzW1AqKdg1WXgJVeGQ9MEBj9h/q5LsEDK9QLSYVN+w/IGtepo8TQp4ZT03ASPUEd0qMAcoAUQUXtrRAx8OKRdV2SnWw35Appw7m04+oasGx3gWmojSKLNOVAN4n7VzIU9iy/anhut2N+Ofv6mhI577HrDiWl3evP81Ja54IhP6XPtTfcWP3UQft0PYTP2NC7mzssDte7l/OPk44ZcqYlz3DQc/ALk5P8jupf06itE4Y1O3HunOtQRtrepL2uWWsRtKqA5/NbH9kv0kIJRCNDCcm8NWHtBX48UpR4GkZZ5xd3xburmVmig+G3v9JTdbFYnVnBtfgapmiFy8ox6UxPshmz1iUpVLcoV4ml2Mg+uFuN6qnzyxw/BF+flZ2eZi1DSLEUaFctobFuRW761Fr4Glr+ijb5sQJ0epvsLOWF2HsVHT83cHPCbJlQjSbQXEIbQzSfUw46MTVV5kJOuFQabIoEQkcQA+eOAjpLSVy2J0eOD4Yn5NWlBUpgMmshJU0r2wsmwWNtCtEE3SLspDoSiXYU5AYmgHBA+v1C85v7RTM6cqdV+oHPFYhhdDERpC9iJGHo8+hAN3HsIfnDeqgFLIaaUSY861qeHoZo0Xjy1kdQCoTAWs1R7q4+7QTt47QOwqFWeDbzrw+O2EUoV1EZ+QHIgO4PPFcak4kaC94SahkfU+PpJyopK6we8MrKM285vJE3oKL/wEnnvZ5FUVVl5gcYP40Viwcn5Gjn7O8KDvoFg269D5GbBoJP+D2M5Unz5r5HNot22eKE4VVmF33rXlnIVlZ2GPo3BinmWYyRcOggnzn+Ls3C/+pf8eR4EBNvG9q/cffZuRmPR9b9HoChIFewMzxS22sg+uwmw
 FmAus8yq
 eGiAYPeHU9oD8+2kpCxsd/xZ2FPVakv+DYCDjoen323YDQMLtqGOIh5zszbgz7fhNa9QeC7Q9bXGxiTtE4Ru3k85j3yASsGYoeT1gFGY4gR8sN1XUUJ/slFuorDtUMUdmNq89OYFfsSP4J/q0yHqU1oE/COKT6MaecvXCk2OGtUPqelJsD0NLMNYawr32JD2o/ttxeMZSaS/HJbGuenGRaCLTfNx8brAPcnrBdTqB+EtoEyv/6en6N+rU1Jp9T6v6H/zXiSgHTkg5DosQwLvVe9wVp6dB4x2hCOuU4tGsSuAoKi8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/13/26 4:37 PM, Muchun Song wrote:
> The common vmemmap path selects the shared page for optimized mappings
> itself, so Device DAX no longer needs vmemmap_populate_compound_pages()
> to find a shared tail page and pass its backing PFN through the generic
> population helpers.
> 
> Remove the Device DAX-specific population path and let section memmap
> population always use vmemmap_populate(). The powerpc retains an
> architecture-specific compound-page implementation, so select it directly
> from radix__vmemmap_populate() for optimizable sections.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   arch/powerpc/mm/book3s64/radix_pgtable.c |  3 +
>   mm/mm_init.c                             |  2 +-
>   mm/sparse-vmemmap.c                      | 71 +-----------------------
>   3 files changed, 5 insertions(+), 71 deletions(-)

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi

