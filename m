Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B702AE9A77D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 12:28:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B9036B0005; Tue, 24 Mar 2026 08:28:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06A6D6B0088; Tue, 24 Mar 2026 08:28:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC20F6B0089; Tue, 24 Mar 2026 08:28:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DACC96B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:28:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 88044141912
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:28:13 +0000 (UTC)
X-FDA: 84580884066.11.F9910FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id CADFE40006
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:28:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CChkzDRW;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774355291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KBJYk0jnl/qBzVP92/zEdcYK8GDf1XZDdv1vQfv9m7A=;
	b=nebJjwGIQcpyMvoiqDtj7kwx0BnAzSyR1ADupFJuURV9prANEpahOoJoXPpAhDXyBE7RZ5
	CAvXitOiqvpwJAs+w+C7YAmNoW7zfySTdSU26MDxmyI3WVPYU3mUV93a1OPq9JoroLJDRg
	qgAo2iN3z0NLFo3vhhqggOCZ1b8O7/A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774355291; a=rsa-sha256;
	cv=none;
	b=7g1T2nfX7pmEETmKzbDXmsJ2ifNZQFsh9i8wpEKU1yGGW6neOBvNENwE23kA6WwYBU31hr
	SjnZWLL7CPJKtbxlOPzxjZM8I3+2nphUQA+lqJv4yLPbOX79NbKs/bGUgObqbLeuNt52RG
	WGANfJ4Nl2Wbi9I//upuOEM6YuSCh64=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CChkzDRW;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E90B60138;
	Tue, 24 Mar 2026 12:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46579C19424;
	Tue, 24 Mar 2026 12:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774355290;
	bh=K1yw3A7DgEAUfWkAMhwo1R6Akouv6hzLeyyg1k5FtBg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CChkzDRWxDbXE0vBOO2ajMb9+ROGziGKBGXK0iNrwtZvThaRBbOnWWobALLRJg0qu
	 wPjonLvy+1WB07i/h9s/dtZ0p9k2lN4tUOXemPsPojphBGcVGkjAHBRDYJaQovxZpr
	 GhItk9bZ7jz1z2FHbeX9nRgssRcEgQCI1DW76/D31bv8kLbI5SUoTm3l6YJ7yR3ytt
	 hePIpOBqrxjYKQpMNvwMbSHtsGPt7+NRfhPumIbV5CiowZBUZ5hU3DZ8QRem71ZWBW
	 xOaR79nTzcVxu73ClIG6P6yM0QI3qefUFrq+NO9oDY3a9D2448DuhTvPn2Dvgf/6ey
	 MJpv54nc3xPDA==
Date: Tue, 24 Mar 2026 12:28:08 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH 3/3] mm: memcontrol: correct the nr_pages parameter type
 of mem_cgroup_update_lru_size()
Message-ID: <641f8cfa-3a8a-439e-bf03-87af4c49ca2e@lucifer.local>
References: <cover.1774342371.git.zhengqi.arch@bytedance.com>
 <2cf06f9faf51900ce6acbb4740fc60355a2842ed.1774342371.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cf06f9faf51900ce6acbb4740fc60355a2842ed.1774342371.git.zhengqi.arch@bytedance.com>
X-Rspamd-Queue-Id: CADFE40006
X-Stat-Signature: aeboaq1jw5foyfr9senksyj3drfoid5x
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774355291-225639
X-HE-Meta: U2FsdGVkX1+ALorZTJbHbg/0IGYFvpaMoc9O2+mauLcGH/bs6VfxYPXFRukBWfFzomI4nyYMDfLWHCUMgX90mJQhkGrQNx3HFC0ZML+U7bYxnNugR425FM7nE7U0rjRqTOMTi/lhwfwEn3HflKi7CmW2DcJoB8Mw5KjvHZh37PLc9MpTdHrJ3dAmkhmOC/1+fNQfBpUKoNHZudMXGJMYvvH+7Z252Z4Rlcv/2wCBorACJK+O9TCeisZFWKJUv+CY59gPtF5BV3nr74c1tdd7VMc9bVFKi1N6SXRh2uZXSqk0nxvahvast8h5tuqbnpuIAmNDC2h6sU5O/8D+H8wc80/JGXetp+CD1/w8c7d42IBv1KwH2Mt9b5WhnEqJFKOwZkyxMB0Gs2m+6AlZ5NW5tbTfzsp7NmjZM/5v/A4mzDdxGnG5fY90+rNBnVlmMHBwV89xdvbFeL5N5O0qj0RDVRRayQGOn1C89D3NC8hOCOW1nuYd99Jr9PNup4WjA0TcHni8H6PQq+GkszdctxiAQWjnmIu/ZeTq+TIafRYOAscZJbTuSvV/XfS6IZ59rG8ftSPSqrI6qaFvuO1AKuBGt3cn+L6mZuzL/UBD0nOtnG5YCeqx2jiOj8Sd4+EOeCtdbAhc5OQmrS26aje9qy6n6xRyncOI5YXgHyx82EFYgTfbA5NzMMLWlK43/mSjQLdCyHxBPRIEqzqu/VBspmxdCEv4HEq0v89gPCqZJ3VxmsCVufD2B9SUN3ZVeh/hQq3i6Wpun7xzeIOYcHF5OBeNHKa/QpkhhLSjymGb0g2jli2PUqnMLldN0AvxC/CNHeYMa9JSfIQ7k9phDIQil7MpyDt+nh4focVYH7bQMvN16/xCMUk51qhKpeKRM43Wah6+6o3wNDTC7EflL2rLoylI+3QFvD5zPleH0QhfpEa8fSz8W8qDcw8Qzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 07:31:29PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
>
> The nr_pages parameter of mem_cgroup_update_lru_size() should clearly
> be long instead of int, let's correct it.

Hmm, but are you ever going to be adding that many pages? I guess technically
correct though.

You should list all the callers and how they use long or unsigned long,
e.g. update_lru_sizes(), lruvec_reparent_lru(), lru_gen_reparent_memcg().

And maybe look a bit into why this was int, if there's any reason for it at
all :)

I'm assuming there's no weird 'let's intentionally let this overflow'
behaviour here.

>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

This one looks correct overall, so, with commit message improved:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  include/linux/memcontrol.h | 2 +-
>  mm/memcontrol.c            | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 0861589695298..dc3fa687759b4 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -878,7 +878,7 @@ static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
>  }
>
>  void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
> -		int zid, int nr_pages);
> +		int zid, long nr_pages);
>
>  static inline
>  unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 4a78550f6174e..6491ca74b3398 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1466,7 +1466,7 @@ struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
>   * to or just after a page is removed from an lru list.
>   */
>  void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
> -				int zid, int nr_pages)
> +				int zid, long nr_pages)
>  {
>  	struct mem_cgroup_per_node *mz;
>  	unsigned long *lru_size;
> --
> 2.20.1
>

