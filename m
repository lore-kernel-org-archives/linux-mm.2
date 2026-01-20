Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02017D2628A
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 19:00:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59D7D6B0498; Tue, 20 Jan 2026 14:00:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 575816B049A; Tue, 20 Jan 2026 14:00:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A1A46B049B; Tue, 20 Jan 2026 14:00:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 34B2E6B0498
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 14:00:17 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE6031A0637
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 19:00:16 +0000 (UTC)
X-FDA: 84353257632.01.6BBB4D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1EBCA180012
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 19:00:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bxw8pyjH;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768935615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lq3aLbEqRyA37VDbVG+GjNtcxF/ESTkZeYhJniRXhow=;
	b=uugPoxNFnytO+Xj28HaV/g4PjZ0lQbAyGO8mAtfQ2Qa3OmvJH5eK8gQktjTakin+A4ND4S
	NYzyxS0TkETXxQgR1OSwG55J/Af9tKPmXlUO+IPqf6dWbPOYGlD4XDbaRjH7KVB4stKZ27
	20lfoSDPsOWKUWSlpO7NwDGK5ogSeho=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bxw8pyjH;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768935615; a=rsa-sha256;
	cv=none;
	b=sYf0oOqPZ2E73CV6p1Ol2QwUPstQmqtsDoz1KbJDtT+Aw98N58W7be+almVjri6pvbCfj5
	/vNRaiVfVHlgWazy6jsUgW1G0utbEygHyb3Jo4zbZ2EmA0wGbacjZuS4yVYF6PfiFpDKN8
	4wk7eSJbKm64hcia2pq0pY8d81UrNPE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 78868600BB;
	Tue, 20 Jan 2026 19:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A071C16AAE;
	Tue, 20 Jan 2026 19:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768935614;
	bh=yvQMSUis/1NCpptkFQ9k3gZYHiivZOEOD7LfuZ7H1ks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bxw8pyjHejSup2eL6mvA96uU19t1osAViIerhPz9jEnZivgiUot4+fBfGEx0iha+T
	 tXrlbmjA2vd6EeDIeLRb2kKyZz70+J3Lr77AfxsAALlJdTn0+9HmXJY2vVEfquWKl+
	 /kUgz8xUTkbXsDISlW7QbcnuTK+LqCWkiBo4cft+B3f0bWY8VaUZvdrh5qXW97zWu+
	 Xwojtdzz62UqOT6v+AEq2StJ47k/j+r5XCK4QMrieSUO8Dxi0VYsRqff8ZaCPywzDC
	 kk+ZxOYZl+u0wBH1Yd6NDCEzY7/NzyT+lk7J1sMjayMtIa2SKc2vNKYRBOWT+MAnMQ
	 3/uXHubLDOvIA==
Date: Tue, 20 Jan 2026 21:00:07 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Evangelos Petrongonas <epetron@amazon.de>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>, Jason Miu <jasonmiu@google.com>,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, nh-open-source@amazon.com
Subject: Re: [PATCH v2] kho: skip memoryless NUMA nodes when reserving
 scratch areas
Message-ID: <aW_Qtz6X-XErS74D@kernel.org>
References: <20260120175913.34368-1-epetron@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120175913.34368-1-epetron@amazon.de>
X-Rspam-User: 
X-Stat-Signature: j47f1thsmbeey34b45zbw1d4nno9a7xr
X-Rspamd-Queue-Id: 1EBCA180012
X-Rspamd-Server: rspam04
X-HE-Tag: 1768935614-968749
X-HE-Meta: U2FsdGVkX1+4CxTrPjdb3nQBh1PTlCuP+BaYr/0dT1y0Z3gHaT1+ordV2iRYFfEqqa+6UHWzeVZhrdoXsRwH6xSmGXLFF3XWsrZt6fnydEn4mYEA3KOvGmU1Y8+rvfb/8FPddOmxn7T585259sCc5zyLYskuMSSuhQ4TEYK4olyJUPNx0Lukf4rHlDchtUwM6BkHjH04/BknqMxEX3O/PqESh2pNGfD+R/iohmzfk+0XF1llijP1reD8KBhmRFbOaJnDMd/Uu+VQMr4DhJ0sTFey1SWhDE4o+o3Y84FPD9PW1dV7+kzyLCK1zu00OXZ3+V6sJHkTv+ZYRuuNOqbHWp92ZcMV62Y8k2z0G5DmsBP2iOrfuZprhP3PaWs4NqrXr9HEwaVG4CENdDkwjbusTIAWmVclksc3aIqI1Vpk/VJMQ9vsekSyp9KtCYdCcQtDehDSdeJfpDN5x4xQfRNet+TO6sirycpq/IUBzsrTnAjW1MS6pNyvyqXwojDqDPqmxGN7hUJ17GKTHztnAaKLJ/K7eIDRlYDvCYnXgYKnxn3NQQfMu7Lg6hz+XWjcx9xP0Htfwdk7jZzA/20yoOEdHEHAKcW6CVfYGdO4OBIW9KE0DPL2ulFjPb4NlQphxry9u+S5uvOYTwlKEmh7hXFl2J/nXUoFhtIoDbSZRHg0GgXwMUMv8MUed86yhXH9DrWbfg/L98gnvaW0NZLa8D9ps3qFrt1ah5jeXGivzs8DrlkU7QK0hEnHyJQAHbqq6tc8pH/UKZKvIdC3g1VKB/M2lSHt7nYzft5hdkfhKq+W94LVmardakc6Ft6QmsQ1o8FY+Rk+I9wVeGg8HWKuueI6OwXBI7hAwGwJkFz+qaYbH1piVu6c4vLNNfnhJKx9E9/nmnyxa5nD0yYYL0SE+H0PDSW/5BVWkT7l/J3UgqDsJuxS56x+zU/xbceM9aGYVxOHlAJffeEBi2sODYEa5P2
 VweZB7Ti
 QNOCeS7YCeqqb+z9+In4ugZn9Vw/IDQjun18CI+Hz4nIbPHI7IAPGPm8Ht0Al8NtkgbMAbd6+IO4LiZzzYf2bYFJeuvV+RjpJlajHO/mvPa6on1HXixBC2LP3jrcFV7Ed/r8wLKOrQnppSg3V7mWAuUoSlCRYJQxETpTjtYbohU7PzznRHrKEr2YB2koTGwpLMXdlFzXNo/v585/sBZiixaSfmJZMyIBYsUaLp9vhSu6coYvlkjELbtUigapBWqt8EszhqSuM10mjok+Fpa8F71jWXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 05:59:11PM +0000, Evangelos Petrongonas wrote:
> kho_reserve_scratch() iterates over all online NUMA nodes to allocate
> per-node scratch memory. On systems with memoryless NUMA nodes (nodes
> that have CPUs but no memory), memblock_alloc_range_nid() fails because
> there is no memory available on that node. This causes KHO initialization
> to fail and kho_enable to be set to false.
> 
> Some ARM64 systems have NUMA topologies where certain nodes contain only
> CPUs without any associated memory. These configurations are valid and
> should not prevent KHO from functioning.
> 
> Fix this by only counting nodes that have memory (N_MEMORY state) and
> skip memoryless nodes in the per-node scratch allocation loop.
> 
> Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> v2:
> - Removed kho_mem_nodes_count in favour of nodes_weight(nodes_state[N_MEMORY])
> - Use for_each_node_state(nid, N_MEMORY) to loop over nodes that are both
> online and have memory.
> TIL: Nodes in N_MEMORY are a subset of those that are online. Thanks Mike :)
> 
>  kernel/liveupdate/kexec_handover.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 9dc51fab604f..979ebaf015bf 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -643,7 +643,7 @@ static void __init kho_reserve_scratch(void)
>  	scratch_size_update();
>  
>  	/* FIXME: deal with node hot-plug/remove */
> -	kho_scratch_cnt = num_online_nodes() + 2;
> +	kho_scratch_cnt = nodes_weight(node_states[N_MEMORY]) + 2;
>  	size = kho_scratch_cnt * sizeof(*kho_scratch);
>  	kho_scratch = memblock_alloc(size, PAGE_SIZE);
>  	if (!kho_scratch)
> @@ -673,7 +673,11 @@ static void __init kho_reserve_scratch(void)
>  	kho_scratch[i].size = size;
>  	i++;
>  
> -	for_each_online_node(nid) {
> +	/*
> +	 * Loop over nodes that have both memory and are online. Skip
> +	 * memoryless nodes, as we can not allocate scratch areas there.
> +	 */
> +	for_each_node_state(nid, N_MEMORY) {
>  		size = scratch_size_node(nid);
>  		addr = memblock_alloc_range_nid(size, CMA_MIN_ALIGNMENT_BYTES,
>  						0, MEMBLOCK_ALLOC_ACCESSIBLE,
> -- 
> 2.43.0
> 
> 
> 
> 
> Amazon Web Services Development Center Germany GmbH
> Tamara-Danz-Str. 13
> 10243 Berlin
> Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
> Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
> Sitz: Berlin
> Ust-ID: DE 365 538 597
> 

-- 
Sincerely yours,
Mike.

