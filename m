Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53D1DEC01DF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 12:18:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC0AA6B008A; Mon, 23 Mar 2026 08:18:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B98506B008C; Mon, 23 Mar 2026 08:18:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAE3F6B0092; Mon, 23 Mar 2026 08:18:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C4006B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:18:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4B8F5160B35
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:18:51 +0000 (UTC)
X-FDA: 84577231662.05.0B89048
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 86EAC80003
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:18:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p0Sc+GLk;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774268329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MvV76WYZd9dbzvNvU//nx+R9xgD7AsqMlgMajA/tf8s=;
	b=DjFhlnJnvw+r99HZTA1MG2oIuasO39GX049Ln2MkZ28Euu0wjzAfHZG/2gQkLfEOtONerZ
	Wgf5TRp3mrgzBm4kjItasVSk2nYq7f2PL3jX4xhtFIr44MQECcggoWgUdvCZwtqtkg32UM
	TuBCW/NABvB/qv3jkubF5+iFscIpzNo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p0Sc+GLk;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774268329; a=rsa-sha256;
	cv=none;
	b=bh8kWwffeRr+tYcXbfbS7Zl+Ea/u4iKYG9cROUIBD5bQXG5Oo1415Bi4gtwvYEQ/KeFFbc
	vAPRs4Eg5nS8YkMqjhfkcs1sooehG62vIiMqN3hlqVSJLFECGMu3Fn7S80yMEVJuzVXC4B
	ppqLMQD65z2XQK5emsu4HufbAKdwt5k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A101600C4;
	Mon, 23 Mar 2026 12:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C682C2BC9E;
	Mon, 23 Mar 2026 12:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774268328;
	bh=8rTMUplvsy3GUiOl2Ee2a81gMpLl8wa03tgFTy+X8WM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=p0Sc+GLkxzD5ptVda0chtGhxV8SlOcoiVI9/IqO9ERCR/CzN/YsDXU6MNj9nCC1mE
	 cND3Y8q1CECdbuLps+hoOF6gleLYVequemye6DNUO30gCStBB7m/Y09jROj3oNnKU1
	 JGAgjHJxKGZ1ykZA92ZQueiib8+cz4DrJ3dnHs3wapFNlYNxS9cXvpgznWtpzFtnqp
	 zXV/S8xe5OXkGCbStzKjrVW2Ljlg4iHIY2egi22nOHF6VZsuOgGAPsCB7kksQ1tPZj
	 4Ud3RcCI0h1mmvPTTqo8mJRbxiCn8ei0/KG49jM2eFvJAh8IJqW9S86m3g3jXpRdsd
	 MZ1tmMjSZ/Bqw==
Message-ID: <ae23e885-0fb9-4afb-b4da-f8e8a7ac8a9c@kernel.org>
Date: Mon, 23 Mar 2026 13:18:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] memblock: move reserve_bootmem_range() to memblock.c
 and make it static
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <kees@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260323072042.3651061-1-rppt@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260323072042.3651061-1-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 86EAC80003
X-Stat-Signature: 7mc71b1q6y46uukhgts8mqorj8age31p
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774268329-436854
X-HE-Meta: U2FsdGVkX19JLk8HbTbFhK6VrwSfeoBR/gcXJXcEnu+5aLaaheS3PnME+5nxBhvSyZUgHK9W3CmL2TIM3WBQcMRMM3/JgFyL6fqeV6QY+n0MWW3x42+oOUu657mAz6PdOGLzxBTz3htkVtyPKsBFk8gwRBK/Y1evGnMPhyD+WE+LPIYmDOE9gHbkVV7y025bI78wVKfFceCts4z/mtNb83u5b8zYY3b+DIYxRU/kh77Z5A2AibrRg2yBSOn242WHJLx6njINyiBxIGLmErKl8GJIYOZcTt5o1lwWWZv1WASwO1pffq99aOkvBLwPbnYqaEXC8ZzU29ByH/hLFTCBjszeksAoJd5s9EcT6/KV+bFcq4c2h7+tRKdz6HdYlzorbb/fKkl5MMH/ugu7wgkj/xJpc2XAlhS1BNo4gKQxsIMnD0uBiaiti9IkTcOfXmHnivAZa92wLVOepKKkl8LYrBtxRvZqxK8S8GF3jJE1KXaqpnqbF2v1HlrOk3Z/LRDDi1QWDKuAKEMQ85W5bhpkA4lxXeHTCxsHupaGqlKGChrelwqCrrhAEKwjCFgGX+UOSpwkiFbzBh/YEJ7nkDqJUGsfsbiRxxOPLqkeqceuv9KFuSrnlIEPd89ocM3UT5qn9C3ZY/ul09lmu7Wzdt5oxKiI9eUVMeOlrhY0FvMnhsngokid/034BVxPbcip+eTKkzQiRoORsheTldkrXaSCKJb1cSiIIFTNPOp982MCGZWJccfwmVq0qI8J44jlYGeMkVG1HOR4JwZHuEYN03ozENfBr4qJHcSxAUFRXqxHmwSRtYrUldufPAhrLuuuvevtoRjGX2W7ia5AJ887fnikxEI9y+8Yk9vr4KAL0vzpy8yhLbQWsY1Oy1FjeP5cQQ3K/vT7FNuIVV54vdP/rNN9IAeZS/xeVHe0q3Jc7U8lCSPlTCUy9ZfPVFutthEa61xMeJ2XLYWYcMk3vv/kMyK
 Udc9dBnV
 iRduTwIJLrhgSTXugR7Ee8jMr5rf6ts4/3d3AY2CAr/GT8+euJLcjOb5ounj5x9M7dbuKvHqNfEJY5p637DPILcnRzeIHhAMaO+LC0WLUHzhJlfSqrmt2tSrYqEIcGSAvqdzxzow+C7O4KkNKhDeoNTaUF0VUhzATcGQZhZofvPPzXu2RZ3DrQ5sMGListAJp0qmr3qZXdTxGZqNtmAxk4cV2kU4LJctV2uG/clU3+wobmt/OMtdkGfPUHTnz5ReYAQMYgv0dQTAVioWbXj4SOsYStEWMdm/E7FWkE7H9a3DTNBJEltsoa28g7mcPfAF76P4WD5rKlrkVLG0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/23/26 08:20, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> reserve_bootmem_region() is only called from
> memmap_init_reserved_pages() and it was in mm/mm_init.c because of its
> dependecies on static init_deferred_page().
> 
> Since init_deferred_page() is not static anymore, move
> reserve_bootmem_region(), rename it to memmap_init_reserved_range() and
> make it static.
> 
> Update the comment describing it to better reflect what the function
> does and drop bogus comment about reserved pages in free_bootmem_page().
> 
> Update memblock test stubs to reflect the core changes.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

