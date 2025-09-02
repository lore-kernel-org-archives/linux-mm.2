Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7526FCA1002
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 01:49:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CD7A6B0006; Mon,  1 Sep 2025 21:49:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67E316B0007; Mon,  1 Sep 2025 21:49:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 593EF6B0008; Mon,  1 Sep 2025 21:49:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 452566B0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 21:49:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 98E6A13B02D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 01:49:38 +0000 (UTC)
X-FDA: 83842628436.04.D12A103
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 08E14120009
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 01:49:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pRN7Gou4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756777777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tDxZ10HsOohBQoRJCf440J4T3FAPtV6loCVPTJ239vY=;
	b=Z/IrtY4UJSSrJ+6uNsSYe0owsvtPSZoCzOeUKOWwEVd2ec34LTo4L8owuvOIe5lR2nSVXK
	2u+gLahpDkegr5OPyL0gOQI9NOrNFXp2Z+UYwdL5FYpzbZyZPRAiVFrFl9riRbjAWuKKb/
	tM8ILuBNEaoJhwcUCIfq/aSH4OZAW4c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pRN7Gou4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756777777; a=rsa-sha256;
	cv=none;
	b=YsyBcqkR63Wqm1Jti52H12S17fASmXxhqGAjicM/uor+SIHXy6fCMcTQYV0Mj3DV4Sz6UD
	ck78MMpSpymFFwGXJ87u33x9vkV4VuLmqZXaWv5T6yqfjfqH3LWv25sJb7uLTinmuf0oQ8
	UNUn6lKbjeJSlq8BK81SAF4hkLgBwQ8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 15C81601EE;
	Tue,  2 Sep 2025 01:49:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC59C4CEF0;
	Tue,  2 Sep 2025 01:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756777775;
	bh=8M8wnjRYNPa0jtbL/Noba8HTd/cqzH4ui9hKV/F7loU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pRN7Gou4OABBn9mlDaRLEp4VCeCBzahudyrXnvcxU+/TZyHLuurlIkuuCJ3OHoQTu
	 kWWlP+ote19hsy/oahskqXVB5hbctkXkeQr0GwxhWP8+JyaZgBRAckKISLJ5Hock/1
	 Emo+mpZsOo58573gxzfPov1buzoG/xBdV4TEnNKd/TXTA6zlD6LAnA0Ss0WmYiOxm6
	 K0JK9op2UJ1McsiMhyef7muPqGCxwAx4IxiQhsjBB6yg1BZ8QOajFdgvfl4u1Nh0QA
	 hFMkpifOKnD8C2WcYQU+e0BH4tdnRVbukkEAr15B4rMmOogpp74cjAV8+WD1ov/BEc
	 lWz3d3DLYJRIg==
From: SeongJae Park <sj@kernel.org>
To: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	kernel-dev@igalia.com
Subject: Re: [PATCH] mm: show_mem: show number of zspages in show_free_areas
Date: Mon,  1 Sep 2025 18:49:33 -0700
Message-Id: <20250902014933.93741-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250901183729.3900578-1-cascardo@igalia.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 08E14120009
X-Stat-Signature: d5p9s7ok36fgrf13k3xcmhh83fhsbzih
X-Rspam-User: 
X-HE-Tag: 1756777776-482734
X-HE-Meta: U2FsdGVkX1+9GaON0Yq+vHdmXtsBt0BG2p4RtExCBmhBe23J7m3brlxyJS83I3NW31nci7DexyS6nTiiYsa63Smua6ag2CT3mgerHO8cFJJlMh8Wx/2BcZe/+IFGqFNvDPJgDGQuwXYvClR6Pc13YOhrlNKNrh1DCsJhEePUrG48iBNRGkDl62XwQ/0MUsDq4Oo137tcq6Jqnm3B0/4Tz3cwp5QpDbQXRyhhSFfHHpPZg4yUgbAnFq+gmYL4HZMvzESgSnskFu8X03nnLi31Sn8E/cCg5zd+7lVv4kSCp+wfeFMPkncG9TFXQ65XY6xyr38XD6TIsMi2ep8FJBNwbPtZ8f3nvFmj4HIljLMe0FsMiWacCw911TeQtyykAdKqxdg23lUWY1mkSA3GB4WwA8xM9seimvzccORuTWqcMCU0OpFW+Ayh5kYeS0iBMeiRRAJLl7iFZEKsKcVr/TE+7T3YGDD3jyQMEFtIMtUNi+ycskAWrt5fwQ91NSjEgbN4aFvFLjnZEVWfrD7iibyC4gFPGA1Rd2e6GKfo3YzFTrHvpdvW7OGOOjfQ6r8jvtSnAeFSJrN+dbP9x/fqrFEFdU4rm5m4h7ErE4XP3iZsM7JU9E2paVaT9oi/UcuprJVf/zeREFxjn3+/i1dyC2kX3aOgXLVR6oKLoYWy3FSQeGBOd98WsRKGS+DCvJ4nA1kGJvW3bhFqTkoVKX9OK/lBt+t9ZH6EzuPi9bt6Ecp4kYGmcTO89gO42KKo4Zt7iIY6aDyUPfYwpBSB9ofqg2GOxX1tbRSnbIiP61jkEVpZFDbq5GNVeDTHzdYZHS53fhQt9IxtPOzzpm5Wg2W2YX6rhYMUqNr3Nq1asQt5Go9/UAnXDdO3fyw25pjZfTPxHJ4rcSlLcs7aY/6XZ+CGzyEJssyZXUJP4LPdHswBjuCA0GLBKsiil1ArxLU87ZDS0Jt82hFAnmiWhERPgnPfeuJ
 H0L1sGR8
 SDQdlLGXlrF69s13TPioYSV5ZnaWkCtl/DabTUunxSz2FVgy89loszJMTgmYABwMz1/+FPuhy1gMjAxuBnhRI2I/sWLgvgnHTZqREYzE/uwsHcfTl/iCxmsyaZ+TEjLoUqugDuSo9nJku6tt64YnFquvmtByqYXr7WvCMRlH59MF7ykMPI84JajQkWa0LKjKawTzd2hQmjA35FC9nNovStaQv15+0aQiv5okPqARJunP3UHaNa8ZyQE1iy0P20IDeZKO3148OSZBGzr+KhM0KvmTB5Hv5XK4cDxzlUojXFbx3jpoFKCRRaFiECQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Mon,  1 Sep 2025 15:37:28 -0300 Thadeu Lima de Souza Cascardo <cascardo@igalia.com> wrote:

> When OOM is triggered, it will show where the pages might be for each zone.
> When using zram, it might look like lots of pages are missing. After this
> patch, zspages are shown as below.
[...]
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
> ---
>  mm/show_mem.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/show_mem.c b/mm/show_mem.c
> index 41999e94a56d..ecf20a93ea54 100644
> --- a/mm/show_mem.c
> +++ b/mm/show_mem.c
> @@ -310,6 +310,7 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
>  			" inactive_file:%lukB"
>  			" unevictable:%lukB"
>  			" writepending:%lukB"
> +			" zspages:%lukB"
>  			" present:%lukB"
>  			" managed:%lukB"
>  			" mlocked:%lukB"
> @@ -332,6 +333,7 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
>  			K(zone_page_state(zone, NR_ZONE_INACTIVE_FILE)),
>  			K(zone_page_state(zone, NR_ZONE_UNEVICTABLE)),
>  			K(zone_page_state(zone, NR_ZONE_WRITE_PENDING)),
> +			K(zone_page_state(zone, NR_ZSPAGES)),

I found latest mm-new fails kunit's um build as below, and 'git bisect' points
this patch.

    $ make all compile_commands.json scripts_gdb ARCH=um O=.kunit --jobs=40
    ERROR:root:In file included from ../mm/show_mem.c:18:
    ../mm/show_mem.c: In function ‘show_free_areas’:
    ../mm/show_mem.c:336:49: error: ‘NR_ZSPAGES’ undeclared (first use in this function); did you mean ‘NR_STATS’?
      336 |                         K(zone_page_state(zone, NR_ZSPAGES)),
          |                                                 ^~~~~~~~~~
    [...]

Maybe some CONFIG_ZSMALLOC undeclard case handling, like below, is needed?

    --- a/mm/show_mem.c
    +++ b/mm/show_mem.c
    @@ -333,7 +333,9 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
                            K(zone_page_state(zone, NR_ZONE_INACTIVE_FILE)),
                            K(zone_page_state(zone, NR_ZONE_UNEVICTABLE)),
                            K(zone_page_state(zone, NR_ZONE_WRITE_PENDING)),
    +#if IS_ENABLED(CONFIG_ZSMALLOC)
                            K(zone_page_state(zone, NR_ZSPAGES)),
    +#endif
                            K(zone->present_pages),
                            K(zone_managed_pages(zone)),
                            K(zone_page_state(zone, NR_MLOCK)),


Thanks,
SJ

[...]

