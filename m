Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D818B10F2867
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 18:30:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 233F56B008C; Fri, 27 Mar 2026 14:30:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20BAB6B0095; Fri, 27 Mar 2026 14:30:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1223F6B0096; Fri, 27 Mar 2026 14:30:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F266B6B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:30:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AA0885EDBC
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 18:30:04 +0000 (UTC)
X-FDA: 84592682328.02.918EB7A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id ABB75C0005
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 18:30:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wc9yXTlu;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774636202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9PnBEqwTEzdfII9RApdHD4RVDBGZQUpYnXLFnJfX15w=;
	b=ae4hlVXCOXuBPOs0LgONB+YxBN23SLGatsDQXXmHqH3Xp9ywc9Yp66GN/9UFMPuOnMogyQ
	/+96vOL/sZTV2+koG4mnXtR1pAkZ/AB6zNYVE+bKLOuU9g/DsgnEdJkbyHasEvjVZC2YsE
	b/FtwR6i4YNjMyyhfZukltvOrKj/0hM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wc9yXTlu;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774636202; a=rsa-sha256;
	cv=none;
	b=n87RgEA6SA7Y561zPK8pFZP7s4tprSm5j+pBaOnb8gmt9UYy4VM2Oag0MUmJ9SwAnN139h
	uiTUmpN0yoSeII7io2IBEqmTvoDL4o02EWllh5ddlAzVh+zk+tyTjfJcKmb3IK2JZC7Tzo
	dRUosqFnJqh7n4ismH895N9OBadY+wA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B0B6C43EB6;
	Fri, 27 Mar 2026 18:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1DF6C19423;
	Fri, 27 Mar 2026 18:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774636201;
	bh=Rp2hmEe8KHjNIHNEeE1IOiE1vcOydHkUYvEL/i1gZK4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Wc9yXTlucsxjlv6ORVbWMxUZ4LvwAPNUD0HVxALNf0AJgRJde+SB566PcPDHbnvWg
	 pUzQiO54SuOZdo9ze/iTTTcNOJwoIn8kzSnFDiMxRMe+Wuu+bsiDSVG6gMgWdrjQ7D
	 xCf1Uu80TWT8hmOnbUh75gZ6wNeQMKrspKPTiNNoEpXuYRtPUNfvNFf05xtqImtDXS
	 WPJVPcLXaH/EjS4lQVrTSQkucUVqWczFh41j5ixljBs0ot8i9KtcrBYPwFt4sTbfPr
	 rEd9Y+MbjtSAZW6BUofNmtLEk4QWaCcgFUttKT7sVgY+l7oVG4TDvJkYXjLq8XTrBg
	 OQeO2T8yZrjeg==
Message-ID: <debf8271-5d88-437d-8872-50bb5fad6a2a@kernel.org>
Date: Fri, 27 Mar 2026 19:29:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/mseal: update VMA end correctly on merge
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Jeff Xu <jeffxu@chromium.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 antonius <bluedragonsec2023@gmail.com>
References: <20260327173104.322405-1-ljs@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260327173104.322405-1-ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: ABB75C0005
X-Stat-Signature: cjz8pjcagc68zho655fo4fuuuq13opiw
X-Rspamd-Server: rspam06
X-HE-Tag: 1774636202-882946
X-HE-Meta: U2FsdGVkX1/wFtUtD56bjKSLVCH89uvC3eBvMWkd0anHJEGGOcu4aeuBwqdA7Irv7mJ4kHN8K8VpEYwuX9/6Ay/qL6dD7w3zV02FpkWPjO1EZJGvS/UUXe5tR1JisDnXl4UGvFETnKaYAZ2+57GfwRSqmPhStdP8wqLwtpbSkOBxzD38wZ+v2Hb7ECaASana3uZDr2tWaDWx+wGO58rE1sm4YbPLxAOqcq0y0P/NmBvrpNrBq+1oeWDHvFUD1jwussQdEzd1CHNETb/quGlUJYAPNOh4Y6lEXS8W6MC2m6sDjl5KAUQerOn6Cs8JIgKeQ7HDeC47MX651FErj3PWtwLSIzX2MugnN8rGy/CMQwwXHLIMGDIGTL59cVNN7ec5QTwjbkVXDg2ws/gvXJStOkH2vWwJPn4OzdTwDU89q6QkNmhb2sU3RoLc88JDcG3NRR87vEgstAyvS/rvppX+KN7o1+wtKoASjioZw2oHdCdJmbWRReqREmjmyk2bpMpn87rhdivZ1cV77EC3pE1GI5RIR70MDvU6WuM/Tzd4hqaH03ydcWCTYQqWlEFeTw2s4FRbnY2bRhPHl/SVJZTzbD2tJoriYfZ3ydZLT6wnyuuCCZkn/pfICrGlcA+nw3qC+9bPTiq44k5iZvnjSc6cUTurE8UnjldIt0sgcTiZROxjyzhQLwdDu+eIJjmOl7nsRS8uA+8FjtHy0XXWC3ND/4uhkdnkqDBjJZi45sE5K+FuhuG6jdyHZjOxSuWCPjcIXtKM4V1N2qFlBL0SGeDIyFcXfw2mg9bOWgMSOwo/wJxeax34JucydBjHIXXqsNqIEB4YLQTaiI1mjK6k4Q9MWoTXDeJPIUAQ+o0gwaMNzmAVlJJGXEuxNq8oqFH+oASJCGHh5Hb1fPcoOAOa2Shu5uPOHTqQyZbz9DtfTCri8U6ZKvq7RKVgHBTa1mcvEitcm/a5kVN38Zm0hUj3Iua
 RacVcldv
 uSEsCXreIKWjWIgzsEQ70latDNV1rOlpoDT5OOxS8CYGm+6vGZy8lb+ypFzEgr+1aIXoH9Dv0wsRtFKhaHpqTHo0dGAuaFCDapSqRPavOv8dchyRpBPDAn1dW1OsufmUqSCA40P+TAHPJw2YQQqpro7KtIRYVpA+7Wp0D9gYDl0os4g3rP864zxeMnYRCip2pn4W3quGfqaLy8mUrrOo1asJ2GXyOMr+EKSOzFuT+ILPJncRjBHyUU619M46h7fzOOw9g5S5+qXfUWpL29V+s4FAzHprTq15+I6K1wNCcWRjbUXa856fLpI/UAJuNhx3OW3kEWzA8b1lxARoW4x7C+f4igf9CLaO/OcKAsIyRR1fDQzI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/27/26 18:31, Lorenzo Stoakes (Oracle) wrote:
> Previously we stored the end of the current VMA in curr_end, and then upon
> iterating to the next VMA updated curr_start to curr_end to advance to the
> next VMA.
> 
> However, this doesn't take into account the fact that a VMA might be
> updated due to a merge by vma_modify_flags(), which can result in curr_end
> being stale and thus, upon setting curr_start to curr_end, ending up with
> an incorrect curr_start on the next iteration.
> 
> Resolve the issue by setting curr_end to vma->vm_end unconditionally to
> ensure this value remains updated should this occur.
> 
> While we're here, eliminate this entire class of bug by simply setting
> const curr_[start/end] to be clamped to the input range and VMAs, which
> also happens to simplify the logic.
> 
> Reported-by: Antonius <antonius@bluedragonsec.com>
> Closes: https://lore.kernel.org/linux-mm/CAK8a0jwWGj9-SgFk0yKFh7i8jMkwKm5b0ao9=kmXWjO54veX2g@mail.gmail.com/
> Suggested-by: David Hildenbrand (ARM) <david@kernel.org>
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Fixes: 6c2da14ae1e0 ("mm/mseal: rework mseal apply logic")
> Cc: <stable@vger.kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

