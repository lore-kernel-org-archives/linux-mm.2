Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29070606A333
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 01:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hLCYwnta
Received: by kanga.kvack.org (Postfix)
	id 3464F6B05BB; Mon,  9 Nov 2026 20:55:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F76C6B05BC; Mon,  9 Nov 2026 20:55:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C6856B05BD; Mon,  9 Nov 2026 20:55:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E9AB66B05BB
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 20:55:57 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 64AE7A0666
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:55:57 +0000 (UTC)
X-FDA: 85417543554.22.D81D496
Received: from mta0.migadu.com (out-62.mta0.migadu.com [91.218.175.62])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5C08B40009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:55:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hLCYwnta;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.62 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794275755;
	b=oxuPsROJqj9DOzLrBmab6kOc27CqIegw6h0hvlS/oWHPh3ilJDR4mEemWcmaBaZhQ/uHc2
	rLFeI52DNTUnFv0QAgmx3CkPs3mti5t1T/5dvhoUB5iH8JQE/cO/qiPX7uIno8xyf4uc/y
	V4t3/ofrUgE4DIPcDkd4tYa+ySqLwSg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794275755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V0cF+hL3s3Nznw0EXwoT1iWnOP26Hs1pcC3+uYuF8Eo=;
	b=qdImwO2NLKDTBxmwR+EnD3PtDqbavycrsWg70hBmAN7u2EJaLBfZ66jQZd9AhQDOGCa7pO
	DcW8hx7/yFTvN/RjE8XdqO1fkesoZNXGIwlsPDWOPYEvkxd52l8kL3OOndzoC+QKLIfowY
	V3HavkitIdjvOpCJ9bVL/VmpI1iDDlY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hLCYwnta;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.62 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VLvCTcg6TZhdcREqx1XyK6ag0Xvx6fqdb0jTAv5YmhU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794275754; v=1; x=1794880554;
 b=hLCYwntaq2IvC7I54IraG2FpiZf61/SNXXW5ZnZAF9DH5d+3np8Us92hPXx0vWhStYoJOPsB
 VtU1YOHNhRmKcfPO1V5yJR/nCO2lT3qQ2Vf5Bgpbhrzdt/PijFh+agbgKNT+MScadOZclAZCzht
 X017NuaJaD+iMOoWjYlE36uc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2f1bd38a9b4ac25b;
	Tue, 10 Nov 2026 01:55:53 +0000
X-Mizu-Trace-ID: 2f1bd38a9b4ac25b
X-Migadu-Flow: FLOW_OUT
Message-ID: <c537a1ed-7cd4-4466-813e-ff066d792c8b@linux.dev>
Date: Tue, 10 Nov 2026 09:55:44 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] MAINTAINERS: MEMORY MANAGEMENT - MGLRU (MULTI-GEN
 LRU) update
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Lance Yang <lance.yang@linux.dev>, Ridong Chen <ridong.chen@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261109-maintainers_mglru-v1-0-c25e6de60bcc@kernel.org>
 <20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5C08B40009
X-Rspamd-Server: rspam12
X-Stat-Signature: zn96kg9bfmt5e4gsrkmfsy49ajc3rd3r
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794275755-219350
X-HE-Meta: U2FsdGVkX1/lQNI1lmslnRlRV+8yX1htzJ7gdTBIwi8wZIlJzaAPzxjcPiOobxM5koqNrq10Li68AaJiaBv/23fqfk6Ccs7ds4v4qxApsvpbPM8ISpXFbTghSiXpohLuxuMoJK3bSBNxojDq2Y1h4J1NG55Lq2qUM3mbvkcIsdZR/XyJoR3+x8Svu9nCiWgGG9XLlTCkuHiZxkFlXUuhuySGpL35jzookjActNdPaacQU04QGEGYHhCT3yDrIPrt7mNEMfgcLFP+liy3Viwy8Ia3siYJTHSCzwMw3eyWuMa7eESkLxcT9o22az/9gN72AFMnbMIwApLn78q+d/3Cslsu/Ro+7qR+VXissciobci8JK0DaP554RPrL5vGXJtCq+T5KJC9U4LxWg/vIQdsaRsI4hzZdRvcx5sDoe76f9wyHM4phOVpLP62BDCWYp3O1VjFoZ34bfZSAhMvQgh1gOHPLMrFkNnDdFNTs3n4HztvhWdII3nrLKOLU3L1pM0ckaBh9Lvou6pEmwtU8yGBMdmlEdmLth1NFoWlps48pAUm4wPS65BiOeBtFGGLrVbqVUXemSIzj+HLNE4422+vWa7YJvnQ++I3k3c9sWHUZDo/RjtMujCj+QnAOlEjZPM4yGWbe4/tqWWQiFooD2OFPueHaaCeY4NhbcovO4w8SB/S/RpsDu4phCY/gbFlvhlFOSe8FZW5gP3b2HBaqqScrW9+tbkL4I5FJ0+Car04DGvLa3ixbOiWEfXlv2/ZOhQ3EXRC4lrOSSyWPDhT/SDfXC+dBP6YioRmrY+ILWblCTKVjp0U7KxcK6IWjCiH2g869mjT5badlZO8IQ2h3EIaxScUf6k6tetzNLAv4meIjblZY6C3y8VJTDto7MxhWcvK0a9P6+GDmvjT8OWDXFF3Hy3BKKTdNv8Axmi6AkLYF7UqLLjhic5d4HYWUpm0gpAI9dpSNHKEHDDZpdyk7VH
 LupSRflK
 Gtce9JyR+dFz1CB+fGsuAtGDefN4AV9QxveOpjFfWzyYGtr0U/AYQhRa47pCkdFY03XO5PmskKoVlEisCUtt9xT18P2Ecyl7sOPTBj+tSutDYMCWxjZtD89HfMqsw/5Zwmo9nbjLraAcPQbqRJql9is0EeUDqreMoxdpylS2Efi9lr+e3EJ/uQBpxvFx5zrnpIaTC/aNqG7M8Ka9HJHgxInCNfmN6QPVBzPxXNZUh5JoLLKkyCOC9t7vY5J6xhIPg9Omt/4ktpKE3sBmT65TcXj8jwlbojHufXzJoqjvfRWC9mEyrjafpTqc+0SrI2VlQXjDHFxZk74ndzrk+KlrWcX6Bppn/i/SDr6CTiMTBCIRtdnyMKfOT99EVCwfzIvdzwvq6iBEWkKdSs/6JJkGzLb/5rDth0poRaDvwU5mJb+mnPZyDkfK4yvsvKiEcfpLoYB9UX/CKyFKTsdgJAo8s+PPskRKlXcO1WQgIXClUyWoLDMu0kqM7BZOkiQxsnf9+1K4YR6U1yXHUrmBER4RVTvgP6RCzWGM7+CySLfJWbPPgu8AZNLX/mjefvRXMkC7+mszo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/10/26 2:31 AM, David Hildenbrand (Arm) wrote:
> MGLRU is currently the only MM component without a dedicated component
> maintainer. Fortunately, Kairui and Barry have been actively
> contributing to MGLRU and have volunteered to take on more responsibility
> by officially taking care of it.
> 
> Given that Kairui is already an established MM component maintainer in
> a related MM component (SWAP), add him as an MGLRU maintainer right away.
> 
> For Barry, the idea is to transition him towards a component maintainer
> role over the coming months, starting by moving him to the top of the
> reviewer list.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>   MAINTAINERS | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)

Acked-by: Qi Zheng <qi.zheng@linux.dev>

> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 222b7fc2c3aa..e7ac319a570c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17635,10 +17635,10 @@ K:	(?i:vmemmap)
>   
>   MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
>   M:	Andrew Morton <akpm@linux-foundation.org>
> -R:	Kairui Song <kasong@tencent.com>
> +M:	Kairui Song <kasong@tencent.com>
> +R:	Barry Song <baohua@kernel.org>
>   R:	Qi Zheng <qi.zheng@linux.dev>
>   R:	Shakeel Butt <shakeel.butt@linux.dev>
> -R:	Barry Song <baohua@kernel.org>
>   R:	Axel Rasmussen <axelrasmussen@google.com>
>   R:	Yuanchu Xie <yuanchu@google.com>
>   R:	Wei Xu <weixugc@google.com>
> 


