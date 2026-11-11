Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE8DF606A9D5
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 18:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DkaOjBc8
Received: by kanga.kvack.org (Postfix)
	id D626B6B05B0; Wed, 11 Nov 2026 13:13:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D13526B05B1; Wed, 11 Nov 2026 13:13:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C28CD6B05B2; Wed, 11 Nov 2026 13:13:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C4F36B05B0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:13:16 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C9D01403BA
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:13:16 +0000 (UTC)
X-FDA: 85423635192.20.1C360BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 44E7AA0010
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:13:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DkaOjBc8;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794420794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4rHAAvYSlBWkR1aF9Xd3HF5s4Ut8KHf5ROnk4jdL0S8=;
	b=k85mW7AgxAYncD2SVF0hnKectwPv6Yf+i/3HIiq9CYwX6qqmOuwilWmacEsizfFLbW/V0i
	2zQ5TBe+MlN+PLy4U5M1R7ToW6AbC7ARFUeRcf2LR6udDw++NVXXOg4+mpShe515u7SraM
	d0rmGgqGnFcBg+QE4aRwielpwllS5Rg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794420794;
	b=k4oiuBt1+n1Y897pKZA5Y0m/QKLaimfWlPLBJbQBa8fjBnrmQx65Uj1IhJh8yJ5nZuOxQ7
	6/ANErvVXDAzonLFnJA3MRu41dxZRsXd/kzoRh5WNJvh7qA4Kxj5qXs4koZwCSe30yal1I
	mMwMVUV57fXdI01vo6B9jSRHdIwL4XA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DkaOjBc8;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D7D06338D;
	Wed, 11 Nov 2026 18:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A0D1F00A05;
	Wed, 11 Nov 2026 18:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794420793;
	bh=4rHAAvYSlBWkR1aF9Xd3HF5s4Ut8KHf5ROnk4jdL0S8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DkaOjBc83AOtUS+wAQ6snaEfwanqbU1gepO5aM6iLzhkqsVB7Up1ZIv3/gR5l0QL2
	 gQ90bzwQWRBynbl7QWenQRyqsNLMdXDooroznbXKy2akXcw8E89fZS9Lp5oxJPN425
	 QUHrfwjfizov4gJfRlB0LeJy1LVLD51GYcs+NeQgPzOMIXnmFNRGVCeNk8PB4nnv8O
	 c0dUDI4Qsf+z02O1hrnPstpHBTYPHSugCZ1568pj94wO/xcPg4hTcvjveEJSk/Zxdc
	 7v8fhw68uQ/VOx31YVUXzRrOBBQgTE4p2/dIp/8Sso0tv/9s+AlD3XOqEJVzJ/P+S5
	 iw6z1m+NMYmUA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id AAAA8198003A;
	Wed, 11 Nov 2026 13:13:07 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 11 Nov 2026 13:13:10 -0500
X-ME-Sender: <xms:M7D0aokjtv4APqRmcYie62JzPiHLtEOtm7zjCt6RVbOeBlOBYinmDA>
    <xme:M7D0ahgaU4V-d_R-cvnEtFCgzklInukxYuDMUatU-VSHb47sI58VH1N8MYo3KM85v
    YD4ZzjU0-6SzNNX82Nl9jYZHfD4g_U3hFmDSmLUlEtsE_MYU28G0ro9nA>
X-ME-Received: <xmr:M7D0al_tVEt-W9TwyHs3QkdFTITAd3qhP-RX48JLhmTQwRw394xO3_dmHwo>
X-ME-Proxy-Cause: dmFkZTGu7m8AL92X1wQsLwgYQLNYwRQeDr8zbde6dcnyv9dQrptwrEaFdgJfap2gDLWQsC
    0XZ095QhiRtyLW5/WT6hfJwc6+DQeAmSOP/cTI/D2WryiH78HbM9g123dyydih3hJxAIRG
    RwH5MCZDYobP/A7+o2KGkIde3fTRNL4aSWPUbBUFoIdYAapIFC4Yt2ExoZuYN+m53x6Tq9
    uacbpfpSCufs21hCT932qk6292iuJB41xISPNttnTOxYUt7fjaQ7OLUqSMKdMva7YDCGu+
    gwoHdMzDF9dqKX3GeM5dNZv3S1w075h9XiuqHUYp27qeO1o6hDTY/DH6sQCbmoZxcDu1RR
    GIMGP5/HijBGpMjt9RAnKT6j8dYErUBEtp7l6VgyLkcdTdEBGkpzlXkWbXoVrDUuEZZOL6
    +0Z6j3sTsasFKS+DoU7bahfe65Wjdor/71iq/TWUCenLvLLp5efTMOID43qscNIzEMcuBu
    7Xp2p0JVuPNCOLFBojazAwCviEKa219u2XiY4d2dWE4IsWCpq2ELmetxOJns3tpl37QnzP
    8Kyn2hUGeBEcv/LE3R6KLd8WRk5VT4xnShKMtJWzrZ3TdybvL4EHlrbDyy4wAGxj1p/w3a
    /onSIrV1y5SqulzROe27U1o41Dtafoq9fMmw01UuYLDGFLFVNYazZh71RhDQ
X-ME-Proxy: <xmx:M7D0asqJAabJBIXZsOZcbNn929PtJ817T3L3wDUCcwJ7kPmNSq8Y8Q>
    <xmx:M7D0arN7c59Zo4PAqOeNK_FWQKsAMGPySUeM-qhDvSwH85d_bl3bpQ>
    <xmx:M7D0aoQhTIX5FQn6VuRXedznWLprJORHnRNw96l5AVDjDLN0WC7lsw>
    <xmx:M7D0ao86CqKxTjuLbDUVYRZEfHfezxhjEn-mHALWSiwlkaT4Xa-f1g>
    <xmx:M7D0asp--KUB1u2KpRPr6K1n4MdkFbWmEOkK6lhM8hynnZORtjf_1pBJ>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Nov 2026 13:13:06 -0500 (EST)
Date: Wed, 11 Nov 2026 18:13:05 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Pedro Falcato <pfalcato@suse.de>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Chris Mason <mason@kernel.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 2/2] mm/memory: refuse to map page cache folios that
 are not uptodate
Message-ID: <avSv89I3zeLC-gQB@thinkstation>
References: <20261109120403.82361-1-kas@kernel.org>
 <20261109120403.82361-3-kas@kernel.org>
 <7698b32c-eb47-46d9-8ebb-337aa575d062@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7698b32c-eb47-46d9-8ebb-337aa575d062@kernel.org>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: goaohzuqeu9zipcasroj13gqxkpf9w1e
X-Rspamd-Queue-Id: 44E7AA0010
X-Rspam-User: 
X-HE-Tag: 1794420794-531258
X-HE-Meta: U2FsdGVkX1/pbBbmcU++Kpp95fE8QI9R4BANQ5Fch7TZPVasUXyVXjtTbIqw5Bz12sBHQNVcjJ5wnDLVP4zovZM+vKybI/8ZOxIe7ZdB/RFwonKMLFo0TkIzDWlTJJAzUshqQo9zIMEpS+oA5WAyHI5dtkqSUQrKxbg9rltibnODcG/CpE/bPOgGpBasEymZy7PjC88QtUKavDG8Kpf2MgkTDHiTMNWZCydPW3CCJBZeimqo+FiLoGaXMp+cx9Rs+YhHnqAzW3rDevB3OMkh7ANyQ7lUr9s5R74GLe2FvwT977OLlzwPDMg5wtpdwAcEAH2e7PXeRMrevp5PCiIovPQTKENbXdJPQUCbfRhcWwLLMjroPnJG+ydQXSIpj3V8GIeXmXyw/cTEyQ26Ia6u+4Utx/R6PMabqxA+yyvlg53pzerIRiYprHBmtOHk+LI33kcOlEU0hGuDKZE0kPdU3KCPA5/d9bMQILGgTcqpbFT1zz7cGVPVU74E4/wN2edvol5aygEcUd7AtGAXsCzM5zfoZddU6Ta6Sfk8McwiaiWrRIYhzie2isxVBlBYADCMlgLyoFi4/vel8WN8/btVLVKXCR0yjjDiLsavyf5ARHwL3ER732JWQmFO5BKFc1Uuiaos2zMk8hDTiNaPjM/T8wzrMV54R+F4shkrhVViOj5oD61nOHmUofpBWQHsiNfLgP9xn9LUeMAky/p7DtkF1NaL3i77QSEy9OLNOEgAFfFE2eCoer8eZTeREzWgABGZzvZfqyxXSdvxrtwSsidAg277ckjEfPv/jCsmk6WLU8ZgquQ3ni5giR7w8+XOZBmz+j3k35ThqDbzlxVJiabGyAfRmttAhxFLbb6HViP+qvoHfrkSy9SOqNSh6GsFGsBV/5UY3tfcxsps0fn5ZoP3WI9oa00K/m5oex40oNp9pIQZB9Z9mGrnL9T0YZWZlLyiS1J4YAcT/mVUOx1NT7s
 bBwadNT5
 VZxc66kAF3WVo+u9HBRBeA3yZ3Cd135aBxER95Kc6MwGdHJeFt39nlzDkFxtVJZMK20iUz1jgueLZek00cWUe1DYhAAAkjY0CAMGC8Rp8g+lNNMC0nZ5mhW0XtsC8T5ouuTBs4FYpQN/uF7uRohqO/w7ZxUAYIxzWOd39RxAqnqOWmjllSBfnyWA05vSpwNYqSj6o1IyoF1mjjRCTQi+AMNWkchvVApckTMj06N130F8JtVFIt0xcXMcbuaDq3+kNOSs2V9wdX57aNBTEbF2mOUW42K+40GR37ZyOYHaF0rdeVa0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 09:05:54AM +0100, David Hildenbrand (Arm) wrote:
> On 11/9/26 13:04, Kiryl Shutsemau (Meta) wrote:
> > A page cache folio that is not uptodate holds data that was never read
> > in or cleared. shmem fallocate(2), for one, adds such folios and clears
> > them only on first use. Mapping one hands userspace whatever the memory
> > held before.
> > 
> > Each path that maps page cache checks for this itself: fault-around in
> > next_uptodate_folio(), a fault in filemap_fault() or shmem_get_folio().
> > Nothing in the mapping code does, so a caller that misses the check
> > leaks stale memory silently. MADV_COLLAPSE did exactly that with
> > fallocated shmem THPs until recently.
> > 
> > Warn and refuse the mapping in __do_fault() and do_set_pmd().
> > 
> > __do_fault() checks the folio ->fault() returned while it is still
> > locked. do_shared_fault() unlocks it for ->page_mkwrite(), and a
> > writeback error can clear PG_uptodate after that; that case retries the
> > fault instead. For CoW, __do_fault() sees the page cache folio that
> > do_cow_fault() copies from. do_set_pmd() covers MADV_COLLAPSE, which
> > maps without a fault.
> > 
> > The fault gets SIGBUS, as for a folio that fails to read in.
> > MADV_COLLAPSE fails and leaves the range to be faulted in.
> > 
> > Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> > Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> > ---
> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> How do we proceed with patch #1 (on which this patch relies on :) )?

I will move the helper from 1/2 here and send v3 as a single patch.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

