Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAB7BCD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 12:10:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F398F6B0005; Wed, 13 May 2026 08:10:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F12286B008A; Wed, 13 May 2026 08:10:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E27546B008C; Wed, 13 May 2026 08:10:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD53C6B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:10:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 696F1C3134
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:10:33 +0000 (UTC)
X-FDA: 84762279546.02.CDBF2CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id A089CC0002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:10:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QWGtMWLa;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778674231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NRizklNVseBfCtPCn2Z3D3ikzfMMPBI3DBsFbH8JTm0=;
	b=5cW7oQRzc4Ezru8YI66lrjf2Of+osOMPaeTXrsc4CYbQL5j9WBXy9ihj0dlZp9eHiPROy6
	vRiba01XMfiY9ECYzZ0sLDlgNwABD5v+gZxHCl9vyRk3LDLasvw0b3tQdXhzGM8pFUJas5
	1XjRBI8pEFSnbqkvQsknkUU/6M4gNCM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QWGtMWLa;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778674231; a=rsa-sha256;
	cv=none;
	b=j5tv0Iy7p+1o6LhXwvCzBx6rUdmMfzX8jg40cbbuQvp+QUOkBRQMCXLixB5OkSpQcA0AnZ
	d+zqaNCeAFiqG5IGcNEZy1bqSnyx4PRYpPUMaqVKKCOlGP/Dym8AEi4qx6+rAt8mWb3WZ2
	8TmLQAJ5G3wVKxxi07yXkw1DDkTVWh4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B60260121;
	Wed, 13 May 2026 12:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B42C2BCB7;
	Wed, 13 May 2026 12:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778674230;
	bh=DKsaSfcfuE1IVUrZuwxuOKUdV2c4V7dwWzUcqfRcakg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QWGtMWLaBDi9QplgclFyV9E7EYmvm2m2mtJk+Q2QlJgCMFc6T0CBreB+g1kFIN1jB
	 h9Dvmb9bAuE1t+CGkTs/AXddm5G+oG/BRz4oGwD3wOUr+KMcUZ4zgjMpktA1HzrJ/O
	 9FCU/X/OfkyKdTufMokoPzxPigrEnx1K8AYKltZnRt7lKf6olDPGZU1f0FnJ/TR33C
	 saSQEbmmDHNtaJhqIC+f++57hEezrT4l5zhorNpJF3p5ppddWXnyaKekhfFOzt7VS2
	 ceJLkQxmxwxG8xuEeBK4/7u0mv7bLVhlPv75hAGRJDnmS1nJMPW94tCkteIWdmEx7z
	 i02HiNcB+sucQ==
Message-ID: <962c2a3d-0502-44b9-a115-863b513bafe2@kernel.org>
Date: Wed, 13 May 2026 14:10:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/5] ksm: add mremap selftests for ksm_rmap_walk
To: xu.xin16@zte.com.cn, ljs@kernel.org, akpm@linux-foundation.org
Cc: hughd@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 michel@lespinasse.org
References: <20260503205153715oK1yza2bba5lfAl3QwiPx@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260503205153715oK1yza2bba5lfAl3QwiPx@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A089CC0002
X-Rspamd-Server: rspam06
X-Stat-Signature: omcoktkdhf1rp4npob51ypy8t46idf19
X-HE-Tag: 1778674231-798190
X-HE-Meta: U2FsdGVkX196Hg+XRtBgVnbZ5+cZQzk3KLiQnH/FZvDVRRb6jaztH7J58DEvrHpus9yg/hAwvKANxQooI5wPK6QHZ9XKQwQl0xcR6amtk5zABXB0TtCWkXu9UuGvN271OFqtkpk1vkqZH5fue/2l2SYNfR6FQZckrvTkTJJQ81fzKRtUTjoPWHub4r/tmokre8oL7CafCQt328d3whU+YJ7P7a58lrKRgtxPFCmhbfRtcJ7h0hk5QeyZJpWyU+c8vsyElyWVLt+kX1lLm28YKyEA0va9h4cAhYd6M3WLoYGAvxAyOhec4B7n1+K9ixx1jvb+swtRsvMu+AhZZ6K71XNEvIBX4sY0BYAWE33hE9/PkO+FVZsUwBgUNbJsFg0udO/SS1bXdvOsCE3OZM/8BAxSkKkxfLuo3gGt70msYs3t2XZb85Laxk0MVUNU7tLUu66ZEooxIFm9Pqz/01vc78Dpoouw7UG98uk9v3iyAdBlu2/w0qd2NZwL9v0WtnC4iIhZYlSM55YRQeDwk59UEUvgtu1tcPzqrs1AePBXGi3TGjfchlkSe76pD5IE59rjvch9se/RAtTSuHvLircyJ7e38xSGSQbltygXS609X9MbIx4L68TbKEpDygS3SycnJfTgqxcJzaOj0xGg5TNctOwJSw1eZ5tRDVLiHbuHiyCo12GyzAZ7cryvD1vYfOhB2hXpykxgNW5T88tVwQdpiDo08qBwhU6GjY1Fq7cSqfE79NWIaslEgwBudVGh7DS0gLoxoC3W91RqAjHFqVETSoFm5hjiE8lVFheC/3N5rnQUMN6ZUv8jCN9PpSIBklHaENOIbApC5aGtjzpAWF4iDKRCWAjtjYiWVPIp0l07E8y+IlYJ13Jb0KkB+rAKf/BFeAc30lf8nvVIwKqdOrUbn5EJMwTU7IlHuO08N8ePYWaaR633CKP53YxkpMzuCFhJjsP7Pm5cB+SGCWgWdns
 REFcV7Ea
 ivQRuyfO18jT3p0aHj1bQA/JR1W5HjtA/eByl6YxMm6KGOEqKtFgqTo6vEAMHtvdl2eMmFPFs76/wbD9qK1dcqPz/uumlmCoGWoin7YuW2Y4S1TrpgFwwxnrTZpoAiS6aXUppFZZ3T032joBcSL4Mun2oYnqfAhthgySF9lSlpF22NX2mdmpOWJnZ7FXZQpTHWoh2zuh5paTwDISInGVg4MGTgGsy5QNC6RvSTRp9XbTpje6oAI8dGGv/NSMpliWg64nBT7dtVdp6lPzG7qttOUCHRFRn8Vs5W/NFvWSCS/PQaDWKbL8hEDbd5YJeaY2GOD5cXT14l949lJ9HMiBnpdTgutuzZJp2sRPzMfzaaMIceVAPHRv6r9YOs8u2ydOTHZwITsbpWCN12pG5AfETTK63qwVUPl5KiP6A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/3/26 14:51, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> The existing tools/testing/selftests/mm/rmap.c has already one testcase
> for ksm_rmap_walk in TEST_F(migrate, ksm), which takes use of migration
> of page from one NUMA node to another NUMA node. However, it just lacks
> the scenario of mremapped VMAs.
> 
> There are one worker process and several checker processes, and in worker,
> we add the calling of mremap() and then trigger KSM to merge pages before
> migrating, , which is specailly to test a optimization which is introduced
> by this patch ("ksm: Optimize rmap_walk_ksm by passing a suitable address
> range"). In other checker processes, we just trigger KSM to merge pages
> from each child process and check their PFN.
> 
> This test can reproduce the issue that Hugh points out at
> https://lore.kernel.org/all/02e1b8df-d568-8cbb-b8f6-46d5476d9d75@google.com/
> 
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> ---
>  tools/testing/selftests/mm/rmap.c    | 79 ++++++++++++++++++++++++++++
>  tools/testing/selftests/mm/vm_util.c | 38 +++++++++++++
>  tools/testing/selftests/mm/vm_util.h |  2 +
>  3 files changed, 119 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/rmap.c b/tools/testing/selftests/mm/rmap.c
> index 53f2058b0ef2..fced1f6304ac 100644
> --- a/tools/testing/selftests/mm/rmap.c
> +++ b/tools/testing/selftests/mm/rmap.c
> @@ -430,4 +430,83 @@ TEST_F(migrate, ksm)
>  	propagate_children(_metadata, data);
>  }
> 
> +static void prepare_two_pages(struct global_data *data)
> +{
> +	/* Allocate exactly 2 pages for the test */
> +	data->mapsize = 2 * getpagesize();
> +	data->region = mmap(NULL, data->mapsize, PROT_READ | PROT_WRITE,
> +			    MAP_PRIVATE | MAP_ANON, -1, 0);
> +	if (data->region == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap failed");
> +
> +	/* Fill both pages with identical content to encourage KSM merging */
> +	memset(data->region, 0x77, data->mapsize);
> +}
> +
> +static int mremap_merge_and_migrate(struct global_data *data)
> +{
> +	int ret, pagemap_fd;
> +	void *old_region = data->region;
> +	unsigned long page_sz = getpagesize();
> +
> +	/*
> +	 * Mremap the second page to the first page's location (FIXED).
> +	 * This effectively overwrites the first page, leaving the second page
> +	 * unmapped. The physical page originally at the second page is now
> +	 * mapped at the first page's virtual address.
> +	 */


But if there is only a single page, why should it get merged by KSM?


-- 
Cheers,

David

