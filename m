Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 094D0606A32C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 09:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IxJgacnn
Received: by kanga.kvack.org (Postfix)
	id 26BAE6B0600; Fri, 20 Nov 2026 04:00:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21B4D6B0601; Fri, 20 Nov 2026 04:00:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10A876B0602; Fri, 20 Nov 2026 04:00:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D29B56B0600
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:00:29 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6C284160E58
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:00:29 +0000 (UTC)
X-FDA: 85454901378.08.F9DEC7B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9878F1C000D
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:00:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IxJgacnn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795165227;
	b=PkjrgSwNO5PA/VgQ1AuWJMoYWLlcuaSTOj5BgD8caEneCEmCIlP66h36dxnNVOVpC+muyk
	QcqbBYIc852bx9rKiBYqTOTCuf22HZrNv1hFm2Zb/EmQX6I1+MUaGjEeeCmoJ6T5stk7jP
	lt6KxLI0v+Z2dFUksaNiKRbRkt5KoZw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795165227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bCMFgdHxFNCuUaIO4TWmPoLc3I/qaZLwtfUY2bWpsDk=;
	b=0fIyHVavgLJkc2HbvofWpkmhe/210ufBGTI0bINnm8plhIMkesec3iekA+EgxdlfxS3SDN
	k4gBt3Fx7SeXU28ltS7kWBjfhU7O6KA6TxpIaccKhMggR7QRlAlSx3uTlHSbNYIObEahP9
	SVPg2+PpmgtGBhnhfIv9VaNqrsWuZbA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IxJgacnn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 28A8361EFB;
	Fri, 20 Nov 2026 09:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57CE11F000C6;
	Fri, 20 Nov 2026 09:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795165226;
	bh=bCMFgdHxFNCuUaIO4TWmPoLc3I/qaZLwtfUY2bWpsDk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IxJgacnnFDeCFwz91x5Og4nh2kgEZVHMU9L70ytLCpG0KHr1xgXr5q245WBCAuJZl
	 MmqLkR3fUuGSMZ3RkqsJFyNZXnF+BpIb0y+BDziwHQMJegeIDMBVf4jJqprnYX8bfG
	 NG1eEIFMW/iSpQQccFOWn+bFyzKXXMqfPQH9ihf1BvRQmlcL2MfUT5HWfyCNrEehmg
	 8Bc5am9zrHcbITMCQGp5XP3Ju/X3Tbc1y1M8LeoYtehJ07qeS/NwND5nxhA4PeOq3A
	 LsAP+lKT/n0kOUL2bGqOgsOBc3IxrgYI2qEoRdB4dCqNVQbDe168/xeKdidTwo8+UZ
	 cJZzmKW+uTVLA==
Message-ID: <370ef3a3-aa32-4821-ad03-558ea0ec8cba@kernel.org>
Date: Fri, 20 Nov 2026 10:00:13 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] mm: fixes for stale TLB entries due to
 delayed/batched TLB flushes
To: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, "Borislav Petkov (AMD)" <bp@alien8.de>,
 =?UTF-8?Q?Cenk_Y=C4=B1lmaz?= <cenk@deepfinresearch.com>,
 Zhang Peng <zippermonkey@icloud.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, Mel Gorman <mgorman@suse.de>,
 Sasha Levin <sasha.levin@oracle.com>, Rik van Riel <riel@redhat.com>,
 Ingo Molnar <mingo@kernel.org>, Peter Xu <peterx@redhat.com>,
 Hugh Dickins <hughd@google.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261118-file_folio_flush-v1-0-e9e739ed14e0@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261118-file_folio_flush-v1-0-e9e739ed14e0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Queue-Id: 9878F1C000D
X-Stat-Signature: rahp9mbty89pzcn79351pujp6j4dgs16
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795165227-686360
X-HE-Meta: U2FsdGVkX19LwAkr/Cguey+PqYTVFJIeHTMvrNkSimK7uAvWDm40mHi+LPnGr0XmUj5lv1VCyeY1qj7jKi0WBIVklHLUIbNIx6CTud15QHpnlsVNwHCY4kqNaVbdEbVu7qzYaXpGXS9E2svQhXnNCJ2kK/nP9nv2jE+Rp2kE7wDj19rFUGLZwdiOt1pqvLp5XVBmQOPE4sFC9b1zcIIkfoBfq0E43SvaYqiXsQa3iFRXhY7SY5bXoJf1vdb1qg55PCVRRcd3jcXi+iNNCnPZ0yWhYDkLN3eVhC+pWcjYtLGUmdVZRy5o8vyAZNTuwkRpPs0Gnds+Fu1Se9qKBrMQ956rxaz06ADXWFV6sLdZBADb4y176xFMylhymAQ/0P+jwk2pY0Qa+x19YSR4Uf2WpKVOzqvqhTPex4u9OfIYrte43zMKQzviJ4m/FfdKQaLfdI2L6pLiz0sJYrAhdc8+BYeHwAPVwtcGWK38kXNh79yrpt+imd1uTpSAehRBxz6ddempo11n69mtv/XAHGjcPnHhb0CFcMOfgn8koNypfzncr3FMAcC4rRucJ10L1xUPQlIQ+QmbT9lRy65STyIwFF6bOGdmgsx4IcC43Y0peaWoCFCR7L0PQDtHg5KC92L0the6cehppVIv3O/R4e4/C0ZrimjBBW/77mykZa/0R9Q4nd/NvZ/DITnEPDFDmkWMHz9qwpGSZ6qDvGiM3oiOBt6ig8auTaOkp+mMl+6DWfkPR/VEslGc7qF2hhsYKiDrLzrPUezNcsi5ADSc9b9vAwteU956O3wzYiJsXyuEW2zfhg9MQnu8PWRkbKXRBjTaQorwEq5VB75q+WVLC4Ny1w5p2Ics5PZpBbx0MchI1LfLeh3od2w5/j8o66Ciq27vS40YVZ6qarQJK35WmvXBRYrG/TGJ04S78br+/MaPUisTtgIuBKuaatbCSaFNmKKB8psMtdTsaeGe9BwgSf4
 Z6w3Tp3v
 FPbM/CwR+gEl5OwqyY7SAHf0pXDTRn0aStTBQ4v4D0ShVlmTN+8EWDApP88OaTez81duIBSZPbS0P1vQM8kwXjqCJgjHAh2Lp18v6q7ZFHox2HeaERiMP8sC0TF7b7AoI3DmZEBce0wk1LKmZBqGkR4GzEOjtnTYwASWv7zPUCP+/bR2DJdCnYQmvBDG+TBwA/xavhRs5XrGvmLr4B4OW7u9uO3gosG2/BnvknolIJLOrcbMNZUTvpb0Js2ovEiFC4SYmLrKTdhi9MKRNEmxqm7p0xNLZT35sTD/unGkS5TH1cKEashQQGMXuLnapTkN+QDfT7UENWWB8sQa0NUZK9yMUfFpxacJMnN3Mi27g9MibVEwZy7C9I4qKeqHu6j2SCGjWliFMcVk8OODkOMmaVk7JJDQtz+IQoIdzJx36+aVsUxH9IzymqoNWYRmpiJILRygDJKFKbyLL/wldQVuj700vdRf6Gqt9MNt1u1BFLPMVnkkuuPjh5GGZgmMhU0I8HFz1aKoaoWcjyH0is+X0JtWsgTbC4bQrRjmNUISXDZtm+RdapSOw7NhzRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Thanks everybody for the review!

I'll throw patch 1 and 2 onto for-next-fixes for now, to get them into v7.4.

The other two, we'll target for the next merge window, and I'll leave them on
the list for now. Please do review #4, that's the hardest nut to crack.

-- 
Cheers,

David

