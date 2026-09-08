Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50DA4C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 17:00:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C3EC6B0092; Tue,  8 Sep 2026 13:00:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34E2F6B0093; Tue,  8 Sep 2026 13:00:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EEDF6B0095; Tue,  8 Sep 2026 13:00:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E9F0E6B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:00:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 82C0F12072B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 17:00:00 +0000 (UTC)
X-FDA: 85191207360.04.7C121B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id AD3614000E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:59:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nKAdUKg3;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788886798;
	b=MN2HWFjXMIPH3ULxvpX15pRalyagkcWIMqOmXyEmU6Yt9H1++Hw+JQnzUFgx5nNz0+tBa/
	TOo1UE0BlZ3OtYqP+JsP4OK4reZjVfMZPHW84FILRHSQXVbAFW69OBGGf0uQ97lOaYFJRC
	kBKQlTa6g2mymRL0LaI1dt7UjLEcyy8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nKAdUKg3;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788886798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OMQ70/u9u8szoGpESycjyQ4jjTMGAaUnnXdZJr5u6/w=;
	b=uxp1NFNJNk3xGYYRtmHAeD7UsbMawVZSblVtVUWQH8JnIuCAf6bCyDU7KKEvKQxlwNUIj1
	pcxVL2gVfIpYSz6YWnMlWdzMHmtV5XmD/I0rMyhhkKSqKz3iiCZLvxN41qH+W0Y7fkFHa7
	oDx4t3UBVYR3u6HdG9kfqWNTmtqnLKE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CE9B0405A7;
	Tue,  8 Sep 2026 16:59:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40E01F00A3A;
	Tue,  8 Sep 2026 16:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788886797;
	bh=OMQ70/u9u8szoGpESycjyQ4jjTMGAaUnnXdZJr5u6/w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nKAdUKg3A1aykLfiEUW6krK0n/AY7E3QMlIU7kvdE1FohxbPYOXiL1PXo3lQ85Qm1
	 /w+XLES/yMGzI8yCW6vi77eFy2yoXUhghyV09DnNRW9/vY86XCjZkTJM9Dt1gEDqKR
	 4MwBYc+sazM9MQCWVZERpV1Umhai4/ATKX3wHirYBI2Zmi58mpPhOYpNxgKuH7KOLw
	 3m5sR0CnQuBoqPQEDDvvpqi05uRYSmmlEGoc7Tasv6KsC1sUtq+USrUJmqu1/bxgpO
	 1RXCHPOsFiej2e4xQIFliIJXAeueCBM8FTCDC3MlfKkSeCaPPqdRXOcxTICWfbLYbZ
	 3hDHeI+ivlJwg==
Message-ID: <6efff84b-7628-4d26-b65a-6f5b747030d0@kernel.org>
Date: Tue, 8 Sep 2026 18:59:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/14] mm/page-flags: introduce folio_test_fs_private()
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, linux-fsdevel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-10-6ae22f9d9272@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907-remove-pg_private-v3-10-6ae22f9d9272@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AD3614000E
X-Stat-Signature: d56irf49kc8pzhcmwxrncrjfm97iknm1
X-Rspam-User: 
X-HE-Tag: 1788886798-495032
X-HE-Meta: U2FsdGVkX1+57MlFk5xtwj+xEsd3ZNSzXi9LUPy1UsgCRRJZL8ButBdoSklzMWMSiRwT1pUU3LZPiKeTk6D1F3oRkiv+YvWYmyo6quyalfCxoArN28Hzk8FmJ79RUtNO1Q+Y48XV4SYXwNHECIsvlEq4EZlHD1EWNbVWmO8XeXtFlfMrR5KU8Oev/02m8axmZUeyApmeMEvrBlBZdTX80GVYNaUyYnygLW3u7D39JaZvo2ZevmqPnCOuko+7mUjMt8gw74WO2Fj+cHryZe/1vC+USxcb05D/EJAEIe8Djaz2NEXAd5llnrP/lP2skCz6GRh6h6uTWX1J7FBQI4rItMD7Up3Vwz21FWiD5hFwibSXBJFCvFvTVOUg8XMLLrZkJu9mgGCnXx8Kg4lfpWz6x4y0vJpfrJRay7l9uD28hbKAOjFRiBWq6Q8WPn2uCSggBoCaVvL2g5IxKhqI9cSzKcPsOeBDWKYrms9ZLHIpLJ1mJ860xcZAQzGkOgv7TLc3pD2r7lvU5uiA0N/Hh4lyKdswPclN1FK/q83T2SlJKM+iGGu6VMmHl+m8wOTmoO4ZSVbxFcitTtWJPyiGtLtjIv9ugLDECHiix98162d76+EU0upWSTBdXA8C/cuNf5iyPDlN2RPH8yECzlxvPDQoCrz/dhqSv0zzh78hHtOsfZsEmHQjbe1J4USU34gmNE78Gk37kxPDTZMgYkrjjrX94AUHmjW/S760I9iQTk5D0elH17cDoLu5sADy4fO+GE4BXpVntixJWb7NzU+S5y4Et7PLjecw9k3r9cvtUDJ0rFV4TjSWkfmHhuzCUViFzwJb/Hs7uw3araTKHvRjXhW1Q0Ku2Er/zXWTgHFRIufwk5J3+16CJe6y5PhciZg6eH1wyxNaS7gaVicqzLVbxf2nfjJYTFpAk0n78BY7jLfv5NRKIOX01h0aTQyOhUIQFs1rPcVmhjI+WeEXn2TTf9z
 Gl97cp5V
 H9fUZWUW661kHIsqcQ2cX8fZfoZTACPWqRK8iLyNKr7WSfwd9zKN/cCz9/HD063ZY3uufCNoavcK6CVWEzFBkdGSoYP0TUE5kynr7zjkGZYu9JuSpb+iz4jriGnEikp4lEAtMOCFC3c5/jmncE+QpgyVTb2Djp7/HNCcCsLI+nQ8PW/EgIusRHIAj3I7W27LpAkzd66/HyQhq1dI1QnOIA4IGIH0ymE1ZD9vQM8RUCwxckwXx5RT+LiwnsaqVRc1m562a5XXer55QbwaevZ4OnmwzBdO50GTVmy79QlrKy7ZyTTX1eQP+S36q27XWJf437miEtUW9DbLp7LZBjB+C+bmSrKfWCaqCJC/q16p+0YQbgOT0HiRHW47OO9CyYTvqT9oJMyqE8T6MhE3zzkgo3IiAp0fyQ2yBzvAGAh/XRN+NIOrc26y1nP8tLaFTUAmUSjZPGz4Eey+l8awRKsLlEU7x1dNUdXRyHN7gIwCmD3quuLNRrCu48j2/uJwlE/r9yfZJYv2XtfrOaeabzwMZELiP0LnOoKxgwVeEX0SD3gybZmTgUL+rWSHwwxu57C1BoMkqO6iJZkXRwimPYaSpgfII2do0BOKojwLb3zR/7LpiCEMIlGExzx+vOnBfpOqpR5oxZuPZn3GtDTUMMip+KAu7EqVbS+uLc82mY9HkG/E7OC0JURhtOaihyl6gc1sve4EwvWA3AaXPjcCssxS8fddVjHFvP9iohVjDhkrE+23qAl1A/69XeB/Ou5/qOUQXRQzGTfblnObA2/nAlhrqE0oFWW3q3ke8AMh6XfA3gZILxvQ+euiugwHtVSblUvI5QTKm0tvIq5aZRkD6rFvCuIBkZAUSxurm6WAWXgQTAAg/adPy8hP7mp3DcLDsX2lvTSeXEOtBjkCaaiuIRzgt6wdI0OL9Mtnx20IMaU96wdxO5N+IBC2WIAociQsLbqXia7d5DU0qw7AtXi+wu4mQ0ViNvW6G
 3hpq8yH/
 7Sg52detX621i8IJUr+GVcjtM9DnIQxzHMLjZVJm+kyYBgcQy7dl7gCtjk5PdNozkqt+rsui3IA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 04:56, Zi Yan wrote:
> folio_test_fs_private() wraps folio->private != NULL check and excludes
> swapcache and hugetlb folios, since swapcache uses swp_entry_t overlapping
> with folio->private and hugetlb sets its own flags in folio->private.
> Replace open code with the helper, since core MM does this check
> frequently.
> 
> No functional change intended.
> 
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Andrew Morton <akpm@linux-foundation.org>
> To: David Hildenbrand <david@kernel.org>
> To: Steven Rostedt <rostedt@goodmis.org>
> To: Masami Hiramatsu <mhiramat@kernel.org>
> To: Lorenzo Stoakes <ljs@kernel.org>
> Cc: "Liam R. Howlett" <liam@infradead.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Nico Pache <nico.pache@linux.dev>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Usama Arif <usama.arif@linux.dev>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-trace-kernel@vger.kernel.org
> ---
>  include/linux/mm.h             |  4 +---
>  include/linux/page-flags.h     | 26 +++++++++++++++++++++++---
>  include/trace/events/pagemap.h |  4 +---
>  mm/huge_memory.c               |  4 +---
>  mm/migrate.c                   |  3 +--
>  mm/page-writeback.c            |  5 +----
>  mm/vmscan.c                    |  3 +--
>  7 files changed, 29 insertions(+), 20 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 5eb8a62fafb56..c861525cda83f 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3053,9 +3053,7 @@ static inline int folio_expected_ref_count(const struct folio *folio)
>  		 * One reference from filesystem private data.
>  		 * Use data_race() since folio might not be locked.
>  		 */
> -		ref_count += data_race(folio_test_private(folio)) &&
> -			     !folio_test_hugetlb(folio) &&
> -			     !folio_test_swapbacked(folio);
> +		ref_count += data_race(folio_test_fs_private(folio));
>  	}

Lol :) That's what I meant with folio_has_attached_private()

(I think I prefer that name as it matches folio_attach_private(), but I might be
biased ;) )


This really should be sqashed into the previous patch, OR, have a prep patch
that only replaces these instances and uses folio_test_private() until you
convert it to folio->private in the second patch.

In short: touch these call sites only once, not twice in a row.

-- 
Cheers,

David

