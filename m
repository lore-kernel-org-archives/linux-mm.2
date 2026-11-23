Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98CE2606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 18:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TvXhpuIu
Received: by kanga.kvack.org (Postfix)
	id 4B4EB6B05B4; Mon, 23 Nov 2026 13:40:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48DA06B05B5; Mon, 23 Nov 2026 13:40:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37D816B05B6; Mon, 23 Nov 2026 13:40:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 192906B05B4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:40:28 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A2A141C2700
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:40:27 +0000 (UTC)
X-FDA: 85467249294.04.28D63E5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 095B64000D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:40:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TvXhpuIu;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795459226;
	b=31KGzUf1mN0hkU8OloeTYLX2Aellau9N9P4txe8xNcN753IJmddJiCcMhqWL5yN7hbZd1o
	L2NlEDJlR3GOY614hWhK58zqtQIziitFyISrPuCfKJQ+08Zo6rS3RDf1FyOISP0kanAo6Z
	c7iTYBagDpS/qVAxIadxEUoi4XL37wM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795459226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zbWiMuLWEtC6VF7ymn7U7/1PFk3dFO6xySrPg9JcUPk=;
	b=c+Dl/Eg+e5usV6VqJSCeJO68OPMipgWlfdi8dlgrJ3JWG35P0SHuZ2aHsPJSEmBG6ayAml
	0d2jnWgqN3QCTjlMcNlI7Sh3BlGfyquB7Xz8vOV8NpKkZ5gwkeL+wpQUP1Ct/soyvBZ3OP
	LF5JtpK1h/LzSRI2lQvUQ3mX2rHwqjw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TvXhpuIu;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C4156125A;
	Mon, 23 Nov 2026 18:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192BC1F000C0;
	Mon, 23 Nov 2026 18:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795459224;
	bh=zbWiMuLWEtC6VF7ymn7U7/1PFk3dFO6xySrPg9JcUPk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TvXhpuIu7BmJs0KnVfb0hIS5nE4sSxgXUTwRIhck7dpblkXbMRn1qe0Ud8K9Nh6rH
	 Bjc7dJoT87mNgjLSEZKPow8dj/FxeQAhU6ArJxzeWiLPhh+3I83QhViQB8GeDuepxn
	 EKgpuiMZ/F13mnvOUJHJjB45LS+No/7cbyBnVVRQ2Qg7Rh+EEETR9bXb3yvNxB66eS
	 hZBH9y3wrf5OXFfMmgjawpkf8IDMvQXQo/F71/P19KbgN20gE4bJguQTSk0+m5XVHx
	 rsCm5UvxIR3MBwmSQZGl69GI/F+hmZL2bEIvhf9com2ZLq7nlhzx0CtSntiKAiUnLD
	 iMF3d5z8iqwdg==
Date: Mon, 23 Nov 2026 18:40:22 +0000
From: Harry Yoo <harry@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v4 2/2] mm/vmscan: consolidate promo vs. high watermark
 checks
Message-ID: <awSHRi4nS1evi27Z@thinkstation>
References: <20261123181829.4065581-1-joshua.hahnjy@gmail.com>
 <20261123181829.4065581-3-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261123181829.4065581-3-joshua.hahnjy@gmail.com>
X-Stat-Signature: fytdsau5r6jecfsk8xwhgrekuhjh3cto
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 095B64000D
X-HE-Tag: 1795459225-84267
X-HE-Meta: U2FsdGVkX18xPY0PzdYiGwp2TMI3ILzrW5xx4xdXQiFEQThdVkoSQeUYq8+3OQQfqQQO9pOzSTV+lImA3YJxvnTZQXOtQi7OFJo6VNDyOtfsgoMGuiwbILbroZyRyeiwRWfVpgvw00qQH+vaZaO5iiwaCr8Dlsx7MnZp15T9T9uWv8NYKkwNrdIp6NZ9H//spje5XVJ+kqc0IIgJrskR21BLbGdWXdv0Zx/mbyqBx8uTdh0GNmh5uejdrchJ0r2p5IrqAq05sE+Cziz6BntpMGPwFiJ90yuuClOaJy3Az6Y0TxVu3stqZw2CdlkDKQ+rGH4CpilZwWy5AfvsIz8et8ht9LHkyE/N3VKkdHkc0dnLMOtx8UDlJB3n/zpU0ZJJsM51tBKqiMMAW79CWRkg7lzBVbU7x6xq0EyYfbb+4x8aVEcc4T1MNbKl9n1uCmZTXQu33fgbC/Hw/IWMh0rbUqkmdoPaYf0Qn/WwttEp0YLufIxj41GW6BRC5EPrFDnRBObrFhpAegZcBUXPOfG+C0V4C73wxLmFBMsu7j9IfBghEWqbhe9Ml5vyWPXH7/Y21vP7TxEYjAWy7kyNiqJ91BKuSIVO6eOMBnigIJcGwvg0D9KwNGVvdZfKHqGfDNN6odFDInN6kbitxaHqIbo6RPljylA40n2J1iHluR5S+YlHkoZo+fGVg6Inb/OD4rgSIAKRQQ1z6uucQjdv28Mz15Oa0eI398OBso+7/+p2Kj6pFjYougQiwd5TqqbvQ6W08PVhyyms5fLE7E8rEbYYyGYqI9fNhr2PYni/Vlc7x7qbHjvltW++JpaHInmpPl8CQu4rn/yWky/iJLSCQOrvc9f4cYllwIUQxMRAmWVBsuhDHbauR1OGGIkWQS7RdqacCIYbuyuY65NA8DPCblgd0Aqu0sRdbjbyuOegrWipyk4yOxumhNF4FBwe0mOCFnpSW8yHe5kUeag3EU4Xwhv
 Hno8ncNs
 lAtK+mVz0o1R0F+jS28HUdzuUkx6Bd0ZNPcpxP2oQaxBONnFxZPiYpm9bZcntS8Y5tIIerqB/F7Qok+6NFLptKDUaLkH3uIOFCCUC5HCflHDhTc563FVoFxiCVoYkt7A92mOY0kFiMuMpf3iCsfL8XeyIQisGANPJXalykx4zEAuOIl9pCUGXdzoEt8fSB/sDBEon05sQPRGD6zF70Xp/vwmQY0Rsb4HWDfOjgxqwC8rOwuuCbePWylJD3SOdaJPK/8iK+MLEdDO6cFLeRzEDX7flWvA0FW5TXSQcNmFUQPA9AE/aNPE5eU/ob/aJ7haHCHwWKosRond/CZMqTv9te8Sbo3e5USFPm2p65HO2Qx8948CrxvV/2ytEhlHeunuNmM2/M8T10wYZ5FzeLY/lMvXlwc9yYioAOhGSC4NeQvEudD4fQkt+XzBgGixLXUnrUmncNy3HcroV5F6AtpDYbT0gQ7aLQHvCm/xQZsEu7GW5aHY7lAj5+9IX2inqLKQ6oSn+Uc+nEPmNV5zCOxVP3n7GCDPlwadRHJfG5YnwtSMKbtM6iyq1pCMjkLWABqzOykSoT498vTl0mUynHGrBbmH9LaqQI0dKPPsZ9l4IqIKBj1O7wgs/yupGkyUjGLLHzmbPa5Ni8rjG23+Da2Mzhol5Op5JSwjNyQGrAZaVh2ircZgzMmoNEU/o3sm1H2ujVJWIH9zzwH3uVA3eks3t7O7dmpse31/oN85KBGG6PAV2Iu8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 10:18:28AM -0800, Joshua Hahn wrote:
> There are three sites which all check the watermark that kswapd reclaims
> zones up to, which is the promo watermark when NUMA balancing memory
> tiering is enabled, and the high watermark otherwise.
> 
> Consolidate the pattern into an inline helper and move the dependency
> on the sysctl.h header into page_alloc.h.
> 
> No functional changes intended.
> 
> Reviewed-by: SJ Park <sj@kernel.org>
> Reviewed-by: Chris Down <chris@chrisdown.name>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Tested-by: Chris Down <chris@chrisdown.name>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

