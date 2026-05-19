Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA8D8CD5BA6
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 11:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D90776B0005; Tue, 19 May 2026 07:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D13596B0088; Tue, 19 May 2026 07:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDAB86B008C; Tue, 19 May 2026 07:22:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A871D6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 07:22:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3F38C8C333
	for <linux-mm@kvack.org>; Tue, 19 May 2026 11:22:59 +0000 (UTC)
X-FDA: 84783932478.22.1AB7066
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9B8E1C0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 11:22:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V0rpKCMR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779189777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7XcvHNiY39PjwZcoF6kG1VO5t7tixZKA3g8KIP+xbKQ=;
	b=iK2lhgOID2T3DBOiO5NEb4r+nvA8z0uoJ9fc/B9dtBqkj6jj1xsgRxBHUyWr/rE14+LC+0
	kTdFdceHZ/lxzkrMCROfeoMYKyjuFvjJ76Zw5NWdjeWyyUOiUhhXtz76v/7y3LDn7ZoFuZ
	e48/DYMSohuzx5ngViJw9rRD992/ic8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779189777; a=rsa-sha256;
	cv=none;
	b=X2qprRNCSPH2UsWf3/g1Yf/BzG7H9w2XyoEaw0kC+U79w4POCASshQBWNAV45aZ+FxQ+j6
	gmnX62nyBGWrhmZ1vUG8HbhOERNvcref6hDqtk9fX/i56shwcyn0aZSJoehSiFSdruSYwV
	8qI5++Q67qJmIk8t9x8JcN9ZCYyBfe8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V0rpKCMR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A20E60129;
	Tue, 19 May 2026 11:22:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54AC7C2BCC7;
	Tue, 19 May 2026 11:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779189776;
	bh=gc360qGXUrPfTfpneVVNX9VHgZq+mPudQxnSBXz8kUA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V0rpKCMREYqSY21J8h1NTof9rp8/fytmRhaENLUJptlBlCG+6yG3u29xYQOZZnw5t
	 V2CoRKLu5neRiBwYRyoIeDRfMlM9iRKifYpnEO7nTyIVDg2gUfXJQA9ctdOWRhG1b6
	 cAev9QAiJCaX4LDe2qWc6jtdT0vHZaUEZ47in2LKXXqegQzCXuls78ZRikcFmdkHyL
	 m7+K9JK0wlpfmcUV4gzMOB0eg2DnHRrgn7W72FXdTwy17/EhZZSVBMTmz7HftXBMdR
	 etpVgo0bJk7Rk5CyLtxGh9ssfJCuSqeJz5I3VDbotYh5RF/KSwNcA4xW3dkScOndxJ
	 JBRcM25I2c37g==
Message-ID: <32387576-691d-44b7-a5de-c211046e376a@kernel.org>
Date: Tue, 19 May 2026 20:22:52 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: memcontrol: propagate NMI slab stats to memcg vmstats
To: Alexandre Ghiti <alex@ghiti.fr>, Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, stable@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260518082830.599102-1-alex@ghiti.fr>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260518082830.599102-1-alex@ghiti.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B8E1C0005
X-Rspamd-Server: rspam04
X-Stat-Signature: e736qtpjf3ztyifxy7ge11x6bre79j5w
X-HE-Tag: 1779189777-819540
X-HE-Meta: U2FsdGVkX19M56oN6ZpXtB9w6W1Dbe4Rg6Pmp8OmmEeWkFQJIjFefZmyLt8zlIn4vyiZaL2DR7eYWvhD29W1LJ390wsY1lmuzpWIlSrxc5OKMJ4B72Y6xjIilkXerwsorT7yfG7rChvsoUTkvFpmOzqaGtH+BcedgPr5kLBO1SoM9autr6i2HKICN2sxHpYKGgIzaDwh9Z7aRAV45imdxoomXCIy+gVkslJ0Nwea7J+s4+1LbWljJmusNc1+efzfyooWlflRATUOKpQ9fdFxOdvGqnv18vAvb2nYxu2ciuQiqArkMMPKt0HE+LiQhsdsqCLrKBm3XaKZWZkSuUdoPx+VOBUNZ78Zfsd3bRamxZ62RbuIOptErHWHAUQymXaJCAqhdczWPKtGMkl/vS5fdxLIvxqsFbhszg4zHtwTpqLOJKsZccJA6FzWqSYF6sAoyYqe2W8w/pTHb9zrkUKOk0Qtpj7SNnz5cJ2Vu7S9ycPvTXk4HOEVP4MYqDB/b89BcYHXf1CjjNuWd3RXSa/toce1EcUUDsKBhzZxb5YrnFxlQiwb063ClvFK6HP8tdPHgD1etwkeq6uYu8wK0GKB6REHgkd2TEU4lmWMMSBLDrVW4HArvfZ6Xh5rNuCusc1bbrpkMN5UzVqNFkl+bFbz5anXeEZxP7qb2dqoHykDaVgClS6YogbKv9Csx1M/7kdPXskqWuliWw1XWtv66bLH/pSupqRmLhxO0A23VS9yl5xc1CA4MQH7oERuq6Ff0stACAbPuFXUl3DM8TNv6WIBwnmYRHJb3xIFVE+2ycdEnaQtHqIAnsfjXBe98Bl/7z+JCH6EB0+p1YhLFnlLMBL5osjJ38HH6E2SiUf85NQCgUMxdjblSBPdb2UE1RLcbrMzIX4VYgdBcPixOrNaIuO5sl6KpXcCvIq+h06aPcJ82GS1J1MixKqYCl57cZc4Ec7Bhy8QjyOxAdcwsY5zGXH
 TsFkHVD3
 j4JrCXq1wuH+0q3RMAD+l/hQdwRO1yDObjCR9zdXP2D/vJSHnHOALKJAURKo9BbJnwShmxrFI0S1qWbZUehcyxDpv2tVkLzD1/oQHgpM086ZrG4KXCiom/bxXI9GH2TcSKgZidlW7fANVEH1VtV15Ll5mKWk+SYco08sNId8Rz5fxl/iUdUSBrcjgTj51P4Lqzk0cZ8+oFjdglEgqfVLI0t0iXk+t0/4hTdMvyAme3+zD3C8r7Fa+iVzeGDhLGOLhcvWtItamaYDEomt7PP8Oc+9hQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/18/26 5:28 PM, Alexandre Ghiti wrote:
> flush_nmi_stats() drains per-node NMI slab atomics into the per-node
> lruvec_stats, but does not propagate them to the memcg-level vmstats.
> 
> For non NMI case, account_slab_nmi_safe() calls mod_memcg_lruvec_state()
> which updates both per-node lruvec_stats and memcg-level vmstats, so
> flush_nmi_stats() needs to flush to per-node lruvec_stats as well as
> memcg-level vmstats.
> 
> So fix this by flushing to the memcg-level vmstats for NMI too.
> 
> Fixes: 940b01fc8dc1 ("memcg: nmi safe memcg stats for specific archs")
> Cc: stable@vger.kernel.org
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

