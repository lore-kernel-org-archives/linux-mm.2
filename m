Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1EEBFED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 18:38:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 297B26B0093; Fri, 24 Apr 2026 14:38:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26F266B0096; Fri, 24 Apr 2026 14:38:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 186656B0098; Fri, 24 Apr 2026 14:38:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08BDD6B0093
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:38:36 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ABFF51B74D5
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:38:35 +0000 (UTC)
X-FDA: 84694310190.07.ED31A90
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id E9F8018000B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:38:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FWO3jI0d;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777055914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FvHInphqYPyAzNmHMYLzhLAWMAQsA9sBs79hb0qZJek=;
	b=dFiNh2KMKBWhUvL9PJdCOG9KzkyfSbAvY+PLTkJCzwC+uJ1BU/6QfkOyrtaUEYFTsVBuFw
	FWXycYfo2N2tcnZn/2fKH+x65Z768dtfntqDc6eMraFxYxW09CcDJRufyq12AANt+SzJeN
	tUmELprIalVIUVtbY6WH6rx9jqnV2IU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FWO3jI0d;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777055914; a=rsa-sha256;
	cv=none;
	b=MdIBfhKDK41dk27oelf+gaBjavhnoUTCKyNcu7J0Qdcojq+JqfbiTB7rSKF/xZ4vLUwPSb
	Aqmgb5rio7Jo3i2kQO7T0EYXc64cijQxvpo6H/0rtbugwT9ZiEqCUDU/7IRH+hneAH1vG2
	yxomuFkEzLnSjabzmlZGO5fwqxLbZq8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5DA88600AE;
	Fri, 24 Apr 2026 18:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC4FC19425;
	Fri, 24 Apr 2026 18:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777055913;
	bh=vMUcWvWTCpvm7mG+W2fz7QA5t4BLYnr+tRdZEDVmxv0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FWO3jI0dMc8sHHEzltU3lN/H8kLSUgXPtEmi/n1dYgnQbcoRcQx5hpphV19Gr/he3
	 9520OarauTYzHeRGGWLE0UNXPzHESvzWTX9vZZGAwWZiqjwCUuhMqeufnOuDEjWJMK
	 IrkoiMwuWRK8QOPowMuXjo+jsCxx0uMNNrKt/8KcVJqVnuWqcq4xTV8aUaKTERBgDi
	 /nbpuV2vXrNlW+v1+wIU7cJWUuesjQwLslZJXRCHHF0ekyHakfPGduRPC2o4FjNVyj
	 6QzulWOZACYuuU1PY/U92s2ZJkLGv3JfsWY35EeAdMvws0KZ9tuD+BaUZXeBoipzA7
	 UU+1nTra41yjQ==
Message-ID: <72e54f57-9bda-495b-a11e-9cadeea0dfe7@kernel.org>
Date: Fri, 24 Apr 2026 20:38:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v4 09/12] mm/truncate: use folio_split() in
 truncate_inode_partial_folio()
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260424024915.28758-1-ziy@nvidia.com>
 <20260424024915.28758-10-ziy@nvidia.com>
 <896b3956-3cdc-48b5-a0a0-a3ec35aefa07@kernel.org>
 <B2F4546B-F57D-4EF8-90E7-37879711877A@nvidia.com>
 <DD21736C-7EFC-4746-B926-54551B757785@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <DD21736C-7EFC-4746-B926-54551B757785@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E9F8018000B
X-Rspam-User: 
X-Stat-Signature: 7pfm8y6aaxfq1b6tfp8joq6bokh3143i
X-HE-Tag: 1777055913-968922
X-HE-Meta: U2FsdGVkX1/zYWM7zFiCaxVYN4NFXENH2Ge2B9aGdxMCkZKmlhLOwPY/k0tjpwdy/9mjfcOZUeZG7RoAgR2U1aCNDawA3lTXs+tZV75PGS2/dW96Qd163omaapoh/CJ4bsKoQZTnrERrzNPSJJmlyw4ARbr15WYun12fBdDlbeeEklKeRIJKQvJGAXB+6eGwuFTa3YoG7L9a+1boCX/VmYGezxgvYMgJMpD8mp5cNCuRmTF3/2xu6ydIjZ+x3uq3/hIl0R1fZHyksfVfRM4TyjYLOL3D03GMGQDGnCqYjgiUqQ5+i3rch3gfXrVbCQy8nSbJ8StH+HJIuVZbyf5bK2auts7Ja7V9vX581oEHPBFurgGNkZOrP4PeotPzrknMm4Bo9A00l4+llPAkC93DWxMSVy7AcisI3k69FNxnEUl2RON+Ll1MnTwtiKMer5MU2Z2cdV7AOM5+e7Oe4Q3CGw0myx01nDM+QhlEAYwMaWIzyI8NcS9exkgesZcOj7q2edvnoNmdUpGuw1ptm3HdZxuY3m8Be5+1UceHD+XIzUaYnGLmmTykkwgSpqA4oOeegffq23SkvsAkPmarBCp2l4FBls78NYqDKowo2zvV5vmENQwjlN1PRAdgbcvNo9Ui4fkGK7O6t2Y2mylNLS8Ra/9pIZn5pTJ2ndmf3RtJZOaKydAmbHKlRulEZ24m4tpwf5Mf/Cyf7L8u4YzS1XkfuvuOzgpIQuWRwfMGYu6LwZz5cucQZdvgKuJ+w1bzJCyp0cab0eyAoP2awcsNC5bLSDR7E62+vhOAommFLuqkTaVPHn4kGQ8LF9DR0YOlEnJ0AFbzVW0ZEaVKedTCWIyZf2ni0cVRg2DgkNFaDQ5n00rKHQZv5OE0Z/3+x+iTSbkhRq1fHJ5kgNzWLATaj+ZgVLi2aEiDQB/rvCIppZEzAKnVc6F3Kpb+pKpDOJeebHz0BQvftnWgF95vrhuHyWJ
 WpPIuRgE
 FI5EC8t1JSBw263xgNrsLfc2Ac1B+ENHnz6MylYgTIBbaEJLCbg+rKhisUzeBNVrjcKcG+GykHva7+7BQhQrUGpYLy3ztSKVEo6qfys3rh4FkbbhP81pKVHMw10mp/7IHE0ta8pLdbP0bbkF4Uy1vYNbfPGC8/3QeP5FsLYwUYjtzOj2lg5w3zilFDqY6rULXiZ3xGogBG9cyecRxuI+9VG9du8bYu8Vq2PK5vKlBw2HZu9QrIX67zNAUNeff18WJTVHWk8ngWSIaOame0MeRj1lq9YsejqsEe5G1Y2Taguidjrh2XsrCzGe7DQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 17:12, Zi Yan wrote:
> On 24 Apr 2026, at 11:07, Zi Yan wrote:
> 
>> On 24 Apr 2026, at 8:54, David Hildenbrand (Arm) wrote:
>>
>>>
>>> In general looks good. Just one question:
>>>
>>> folio_check_splittable() also rejects SPLIT_TYPE_NON_UNIFORM / new_order for
>>> swapcache pages.
>>
>> Since swapcache only supports PMD order or 0 order yet.
>>
>>>
>>> It's confusing, but truncate would never stumble over such folios, correct?
>>
>> Right.
> 
> BTW, sashiko had a similar question when it reviewed v2[1]. It also complained
> about when the split fails, the entire folio remains in memory. But that is the
> consequence of failed split, unless we want to keep retrying the split.

Retry isn't guaranteed to make progress, so it's the current expected behavior.

-- 
Cheers,

David

