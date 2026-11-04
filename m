Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3410B606A33B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bVXe39cp
Received: by kanga.kvack.org (Postfix)
	id 54DE56B05DC; Wed,  4 Nov 2026 11:52:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 526406B05DE; Wed,  4 Nov 2026 11:52:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44AEE6B05DC; Wed,  4 Nov 2026 11:52:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21C806B05DC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:52:42 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A64D4A84CA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:52:41 +0000 (UTC)
X-FDA: 85398030522.13.F39E70F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 175EA1C0004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:52:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bVXe39cp;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793811160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TbExPZxbTeMwQMvr6C5iO2LZTzsQVMp/KAjDfnAxAsA=;
	b=05dlVbpvd8m1Fty1iWToOv41lhzPYo+/WxpuHGXlwPixlrSgn7HQH2wj/GHRhQMOmnPPl/
	VQB75dJX+fWQ4T1Yu3agoeVd529ptilI9b2ItI/QtcPYmGneubSkcYT/JRTdvSYVmdnB8f
	2Pi4wx7OZZQtTs55Q8GTuuZwP7889iU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bVXe39cp;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793811160;
	b=kdVDhvLd55dVU02cxWH5FCrXeqB4/4UjWN57Nd+/+dTFmA04a7LvGD4nwUaPVy7X73+uYd
	tcOcKdveC1ddQ7oaw+EI/YPZGNQ4BrF95Mui2ZXaa7KV/xhGmMWBSueEUeBKF4fJtmLOXP
	npHiYjxvSjoUN2NdhdVDCBe50SEW0ik=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A96842E00;
	Wed,  4 Nov 2026 16:52:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863471F000C1;
	Wed,  4 Nov 2026 16:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793811159;
	bh=TbExPZxbTeMwQMvr6C5iO2LZTzsQVMp/KAjDfnAxAsA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=bVXe39cpVVcLguYmk8EACqs3hMlDpO2DUlD9NW4R6vZdAbeUsJ2gAV5m8uPsX3MM+
	 uBLD2AhG1qjg2zDH6eW0xq6rjKOLzEgtecSyZoU6wJWL3DfMryw9p0hYVBXBgHvOW0
	 4wn524rxoxn5Nb6GNB/CGP3plpbD1hK8p8f3TLvF+Vmehn9dYVo7pSD94J41K2Zp6V
	 mCJHRVbjEPEUw0045ku4CI8dhVZ5A49Dk6S6igqBDQ6/yHy3CbUeqpXFqFdKTUuh9S
	 /zdY0WfTdfVJLSsrvUxXkeqmzeFlB5bMkIaNav8xtirU1gA2dMCPyRe4q4iM0yeBRK
	 aANSnFkLhO5GA==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-kselftest@vger.kernel.org,
  linux-mm@kvack.org,  Alexander Graf <graf@amazon.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Baolin Wang <baolin.wang@linux.alibaba.com>,
  Christian Brauner <brauner@kernel.org>,  David Hildenbrand
 <david@kernel.org>,  Hugh Dickins <hughd@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  "Liam R. Howlett" <liam@infradead.org>,  Lorenzo
 Stoakes <ljs@kernel.org>,  Michal Hocko <mhocko@suse.com>,  Mike Rapoport
 <rppt@kernel.org>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  Randy Dunlap <rdunlap@infradead.org>,
  Samiullah Khawaja <skhawaja@google.com>,  Shuah Khan
 <skhan@linuxfoundation.org>,  Suren Baghdasaryan <surenb@google.com>,
  Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v3 09/10] mm/shmem_luo: Allow retrieving tmpfs files
 with O_RDONLY
In-Reply-To: <20261103010216.3447716-10-dmatlack@google.com> (David Matlack's
	message of "Tue, 3 Nov 2026 01:02:15 +0000")
References: <20261103010216.3447716-1-dmatlack@google.com>
	<20261103010216.3447716-10-dmatlack@google.com>
Date: Wed, 04 Nov 2026 17:52:34 +0100
Message-ID: <2vxz5wyck08d.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: h4xw7mqnmujd44gdaark61x9anpbubz7
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 175EA1C0004
X-HE-Tag: 1793811159-573624
X-HE-Meta: U2FsdGVkX18zQErZgwQAtvBi0Ftuf+qDvnsVEANBiLRff9TRV8MFOFGVcx2XQT5P/FUNS34jgr2SurvE/qQBh+kc5btC2AHmoZoSPeUFNnHoaS3QCdcfn5RWeMgKVjFzRgXT78IbReECa+XCBNRZqoDWZpAfwb8PGEJzPWexZtyMFEOZ0ZzwivxDwTUlkX7pZ8Y+lAkBETJfioKd5GAMVKZBQ3Oy3RwI+A9YKPbszOo4QF96aqP8FX4Jrz5PcRG0JQhFCrnEQgAdQUtKnjjBhr8HanpXfyVwXOpIsiA5QUhXjaKzV/6fIFE1Zkr7KvlcFL/2heulC2qaGYVc8FPsfNg2AMrfR29r7hBydoik37ogRBB9xhtPzsUgJLuqoeHir9RJijwq0F5PnbEtos2QFT5DxvmBa5xAL7Ed6tngRJISz55K0nWcQ/rU3Lf0rlGwwmvBZqlLOXIZoog6QwLghCeieeXacOSnREIC6v9fe4Q63rKxLwMQ5u8BGA2fX9ojlpuxO2tA778Qi9b0U5ssNCIqIP3U0B4P6UtwhZKrTw6Vivm03Wi/g7d/ObnTcDymNhS17/MLaygtJCrLgwldRvTdQazqYCJ9j9HDJNMFi+CvqclnFTQIdIxQYZFCwukBMt88VzS0PKZ9qwXQw0ZSupRc6F6qGGjBEdE5l2MpxqEdy2gCZn79ff3GnqWMd5/uKEQIL1a1XbhUiId0CJlvuGpsQ/oSEfsg21CHWEliuTidbPokJ2WEA1G9IB9UzXXHsL8vvUQHu/At34vMp5yemim6RjShn5l+rGEwqfdZE8IKJVj31TPbHwMCr7ELw+7Mo3bc4t8YV/tBmOuMY6HlxK9Um9Fs6Q93RBrVjLDxAxaMC0F6BfIOkkN9H7wmcIkGEEXqIH8qS7K3KymbUL2I/NlG5kj/h5sBJY0HE0/ZtE+BvES9eZ3brcMj1cx+4Wediw2NMtNr0UrT6PZpbUS
 KVpa4gmm
 lc6HqJIHLhw0wG57XxCtiu0kjR9efKEngB8adalv+nB5UxvfQ5kt7Bv4wrEk9JAT3CSf+Sv4/JCcGdLxOvOeCbtLIxa0pzk5/EWuawxsW+LJ1W4DuRVI96xbfmI0o7CG7cS94vq0WGcWWBdFj5fBQlFAQZM098DOfQYbmR41hts8+V4RS0+1YF3nAhaPI/SWS8CzVxx4fYPIERj1MaIgHYOh8RHlYZe0KGZ7G4bsoRmJQoJBZn0aXDwY4NFW66xIvejvy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03 2026, David Matlack wrote:

> Allow userspace to pass O_RDONLY in struct liveupdate_shmem_retrieve_arg
> to retrieve a tmpfs file read-only.
>
> open() requires write access for O_TMPFILE, so create the file writable
> like before, then reopen it read-only with dentry_open() using the flags
> of the writable file, which file_open_root() normalized, and drop the
> writable file. Like open(), which grants the requested access to a new
> file regardless of its mode, don't check permission for the read-only
> open.
>
> Retrieving a file read-only allows a restored binary to be executed
> before the session is finished. LUO keeps the retrieved file open until
> then, and executing a binary that is open for writing fails with
> -ETXTBSY. Being able to execute restored binaries right away matters
> when they are needed to finish restoring the system, e.g. to bring up
> the services that retrieve and finish the remaining sessions.

Can't you put all your binaries in a separate session, retrieve it as
the very first thing, and then finish the session? Then you can execute
those and retrieve all the other sessions.

Why do we need to support this in the kernel?

Also, please put the motivation as on the top-ish of the commit message,
and the mechanics later. For example, your second paragraph should
likely come below this one.

[...]

-- 
Regards,
Pratyush Yadav

