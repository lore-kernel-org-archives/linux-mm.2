Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D08CCCA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 00:49:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63D8E8E022A; Fri, 15 Aug 2025 20:49:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EE6E8E0008; Fri, 15 Aug 2025 20:49:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52B368E022A; Fri, 15 Aug 2025 20:49:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3BA078E0008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:49:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B35D7581A7
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:49:17 +0000 (UTC)
X-FDA: 83780786754.22.4CAD391
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id DE46A20007
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:49:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="scrT/Tl6";
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755305356; a=rsa-sha256;
	cv=none;
	b=7JZrwmFbAgwqZJ1q7a43XrbaXKg234XYSRSe3WAO2F9tb6IZ1c+nnd+jO3zjNQymlOHagu
	mt3OR6qNZTV1UwiEEKOJm1mS5kW9OIbBxJhtPPNZDek1VzC39KNSv+bEAHwUZsg4cXTpXK
	rc2VOV6PwY+EHT8SYt2/7QxxI1evQ1w=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="scrT/Tl6";
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755305356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=12vBt6pvl2+GG2p3H0QKahJtZuQMrZF6zbce7Pu/ysk=;
	b=kSoWcgSrSjeVrMp3GOja+b5XCdNVAwhDd6zONHJJSyNpdrFyNl3Jgy+nFPEfNG38VLIlYW
	CIyFYSrl9i8HDAvPePHRYCcrX+Ac8Zlh2g6Y+TQbz8fzONycRueNS0Py3N1CEEnxLexh5Z
	fzJk8RlWfOmdeabMSOpZ26QPFLXgHAE=
Date: Fri, 15 Aug 2025 17:48:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755305353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=12vBt6pvl2+GG2p3H0QKahJtZuQMrZF6zbce7Pu/ysk=;
	b=scrT/Tl6kq2/8qsHIu672v4EAg2jieacJyrIn2ZS7JZ/+DIn8+Fzc+R/iCY+CPNT2AaLhP
	8pySf8eWL+30PYXncarpQDaboAq4PG8bxHcibDP2qk2tC3qegkFd2iMq+VDXvu0G+RpSbj
	MImgIvi4ut8bHDyFCHpLUG5MVYH3ugk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, kernel-team@fb.com, wqu@suse.com, willy@infradead.org
Subject: Re: [PATCH v2 2/3] mm: add vmstat for cgroup uncharged pages
Message-ID: <ztt2lhdpzfb3ddvgtqqwzuvdmlz4i5l6ijnwizyky4tv62dncz@taho2tjmqjkc>
References: <cover.1755300815.git.boris@bur.io>
 <a0b3856a4f86bcd684c715469c8a1cb2000bcbe2.1755300815.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0b3856a4f86bcd684c715469c8a1cb2000bcbe2.1755300815.git.boris@bur.io>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DE46A20007
X-Stat-Signature: zoj8phtiwybfdps5apoqzozaz4npc7xf
X-Rspam-User: 
X-HE-Tag: 1755305355-567521
X-HE-Meta: U2FsdGVkX1++UEsZC2rB2Xy1yVljr7B+M+r9CSeYXdnUwIltcpAgjvt8ylO/EzojooUL+dJM72cHXNWP8rbWewjS4zYoBZgmtyBVNpSwL0NOhVLWRspTuKT9Dz0smm2yhLquny65utEvq6TOeLqQ84vWJSsT61wx++q1oxxzn7Ja9ZTDZhe37cROFcAh+StPfceqcUZRkAvoag0j6E933duu/hpB7KKp59eXWurx7lfUI4NRP+zPQL6hrTf+xJpSvLa4O0Q3To4gNvxbPDSXNMJcfaBPKmAtv4/89iaoULTmL2rMEq/7G3Z8uAfqGpadPZPLbs8bcanJP0+zV1x9alo3zy+H7qNiRUK9A+wNda37lJiMBJ0rhjkIyfRyQ5x8waZzJCEkZGURAjTX89EF5LGgDrUjSokdsEzSz6z54gX84wBLdUbaTOJnErHgQnwZR5aXBh7EMb57d/d4fKAzVk3x//h/JxeBLA9wSdSoBEMcekn1GF3OUvWImrJD6nADDITMewBCxUYScFWNz9xO2gGYRn37GzNpTU4Mf27s/wV/kqBOnMYOOSq0c5piNFKuRW90XpjgijBrwArArRiJaYRE0E990mgFK8EyiU2PD+R2SwN41hIqXmka1axb3fT+io2sCPMBUTOhWwzNQiVRzBR5gOXDVCFNudx69syEUAMMfqX68rmJ/tIh92S4suCxkbGy5qE17ZoHh4tcoB7P8sISnaK/JL7SOZHqxxercv+LAEPJfGxQuBQ+j0U+iIf5odglTYvFcdKLAb2VGxw4kHDfdTD28nS3PtC/kPFwAhVDvots4rCpQKGHbyofcZNoptXkoBv1RBgveYHzy9BXT0n8TWzu2FzSGvfgyejdDyZrrWylEhX5hifjrHqqBI5XRw3xe59gKXzhXv5a3l9xpLO+zCWDN/mEAg8kf3mv23QfIFbDsjofNNdr8uz7pQuCfKxFLmxh0ZUsvg+sDuP
 CqwXm0w6
 rhPFj4sRpdIj5QsQVeOffYn2boXwqugjSxzxa8UFUui8rCNAoA4InNPmyTAeHHUrUddzc+JblIY2XtHeJfgoq3xTjKg8ncaOtx3elzXdMkxaYCrwgIa8nLDlhZ+lx6d1czA44l/sNwbcYnxe8oth9VHGyJuDVHk30l1gziTmu92SFx6I0k4st8tIa1V3/uvYm6KBK0LruMLamQF2mZ/rhhwqR1B41W7mFFHvhoFBzZPsM8Rw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 04:40:32PM -0700, Boris Burkov wrote:
> Uncharged pages are tricky to track by their essential "uncharged"
> nature. To maintain good accounting, introduce a vmstat counter tracking
> all uncharged pages. Since this is only meaningful when cgroups are
> configured, only expose the counter when CONFIG_MEMCG is set.
> 
> Confirmed that these work as expected at a high level by mounting a
> btrfs using AS_UNCHARGED for metadata pages, and seeing the counter rise
> with fs usage then go back to a minimal level after drop_caches and
> finally down to 0 after unmounting the fs.
> 
> Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  include/linux/mmzone.h |  3 +++
>  mm/filemap.c           | 17 +++++++++++++++++
>  mm/vmstat.c            |  3 +++
>  3 files changed, 23 insertions(+)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 0c5da9141983..f6d885c97e99 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -245,6 +245,9 @@ enum node_stat_item {
>  	NR_HUGETLB,
>  #endif
>  	NR_BALLOON_PAGES,
> +#ifdef CONFIG_MEMCG
> +	NR_UNCHARGED_FILE_PAGES,
> +#endif
>  	NR_VM_NODE_STAT_ITEMS
>  };
>  
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 6046e7f27709..cd5af44a838c 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -146,6 +146,19 @@ static void page_cache_delete(struct address_space *mapping,
>  	mapping->nrpages -= nr;
>  }
>  
> +#ifdef CONFIG_MEMCG
> +static void filemap_mod_uncharged_vmstat(struct folio *folio, int sign)
> +{
> +	long nr = folio_nr_pages(folio) * sign;
> +
> +	lruvec_stat_mod_folio(folio, NR_UNCHARGED_FILE_PAGES, nr);

Since we expect to add this metric to memory.stat, I think we should use
mod_node_page_state() instead here.

With that you can add:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


