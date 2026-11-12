Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D326606A8BC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uwhSFvpt
Received: by kanga.kvack.org (Postfix)
	id 6256C6B05B1; Thu, 12 Nov 2026 04:40:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FC956B05B7; Thu, 12 Nov 2026 04:40:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 513816B05B9; Thu, 12 Nov 2026 04:40:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2CDB46B05B1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:40:47 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B3815C04F7
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:40:46 +0000 (UTC)
X-FDA: 85425972492.24.5C8AB12
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf22.hostedemail.com (Postfix) with ESMTP id CD7CDC000A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:40:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=uwhSFvpt;
	spf=pass (imf22.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794476444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hf+uCs+VHDQDVs3psYlyxaAnFaCOs7LnZX6+jXmv1vI=;
	b=zYgh0OBbVr4GuOvAho9rFd+Cd2s1qj4QPuodu2gW2G4cOqRhZJ2Q+rc81ScFZAJxpREdor
	bfWKtxo5VYWGJGskQz5CXlG0Ezn0tWpUkfx0tu4syOZUGQAZvxq2PRA3vZB9/QlaWRCTdb
	gYGRVioI1WpzE0VMCoUPBHIPtq56BQQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=uwhSFvpt;
	spf=pass (imf22.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794476444;
	b=vkfUfEJMtrzoCR0QppsCnDEhjpqCzaASLu4e1lAY2nxRaiU6M3nOq87hvWjtwimlV5qn5w
	I22mXxu2iVfFwVV59CryyO932RLv6b1LSirZGaNuivCQAnlcaKDjHitMzbxToWRa9mveV1
	hpBDHQgstiZeGYEtnmIda2PhVw8Lu6c=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-492fcbfaa87so2657022f8f.3
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 01:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794476443; x=1795081243; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hf+uCs+VHDQDVs3psYlyxaAnFaCOs7LnZX6+jXmv1vI=;
        b=uwhSFvptcbgtS9ucZn54NG9wFE65Zy2zfEJ1EvOpOeUiy/vkA6IUjxIK5RC9W3B6lR
         LSvNeEQZtKqiYfcbdnyAihOBWul7djB1RNwOOkMUQVLE5dckl9/p/YrANx6N4/MwgEJs
         clBeNjykWIgiJp1LSEAHcWjfNgoRFHiciIMj19hTvmvmz0ff8h0CDfNjivq23A0Gowut
         S0S903nkAuIFXRfJ3JXi+kd5RLb6Nn36J1gS7/XzhiLYjD2XnGbaVpQhC9W8i86w0s9h
         D+ObKNRLqHl1rpxM1jYzglFPoWtraS2m5YUSSCEBLyzibWf/FhqdNQD8uEyEPssEUSx6
         ORiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794476443; x=1795081243;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hf+uCs+VHDQDVs3psYlyxaAnFaCOs7LnZX6+jXmv1vI=;
        b=R+VGZe/ratmIcB9PApuLFWHTWezl3oKjo11MYwKQrroRdxeqKYTtdIk9IzjStPdi0j
         LTwZ39UIuRuPYKY1GNs5Drgn3Q1wC+WNTJOYvckO8ySpFuuU+Ij5dr+773UuVW8C3a/j
         SonOPAXMn03mfjZMf580lOYAURre+H3yYzUFwTl5p/7qcWea/BbpjfGW6fdzaBirE/6l
         tLkrO1Ye1jq+SYMyB6ENRlmhPp8lqzr1yLgeM/DgBECuNhQ1QyKUm/MzlT7E2Bj38fE0
         GcMgaksCefUswX+1hxSymk6Lwhyp6Y+EWpT01voXr8RAz7wPJtE2xcU7ycmzMteCwyY8
         M4Vw==
X-Forwarded-Encrypted: i=1; AL+hErEEmrh3EwENSS6oLl/mRovOSFjThNswfFgI7cgsJOacURyh6TCEGLaInKf3N/jqjVjWuS/7Jcu86w==@kvack.org
X-Gm-Message-State: APuU4Z+KiU00uhOXtGh4ZKdj4OERtyVqjti7I7VxTBZpNOjdXQUNGjK3
	MZtpuR4pa0XRj8iQN7AysIJnr2k/bZTHuduBRH7pwCZkClIhmQEQdfOG
X-Gm-Gg: AYBFou0zPTEzxGWW3qimWXrQA6RlCBvXMZKThjLoGp5SmBBVr1AxLrbnfgCGeWSKbt0
	SsweQrhBdpaLr6xZ2co5her0KZjrTUh3rIa9PayYvhJJFZTRd9aKkvDq3G+8qljDWLfT/VY9jRp
	P84hSSttsR3BjVhqs/mqCrenAMORJLRSH1smhHPQ1FBk4kIlrTz1zphcZFYq/kY5kSmcKyPv9I1
	1XKOWm4npu3n5rJvSbskwWShrHQldXsgbOpv3CCSs5QyNKnGZL9m7jjCi8FSXStXcjfyZO08rk3
	4bKTd4nhUwrr+fbum9krrjMVUttLK28KEKK/xiaSmlgEMbgjrwU7gLp+Y7X0QuelZTm7qrONDcY
	Pz8EBai4tfL0zTRhnqMpNoa2/lafFdke6NdKtmRC6SfA4u5oYtvN91Mivra7wr+zWMIuMwC1mZs
	3YWdBvpnZQJIVAxlfJGcSe2nnJhUINY2kZjxM7Qdrs/1xoZUbL7Ho2kOD8CXDFo+lWG7NQf4KF6
	NmYtuslbAqe8YaIjnQASo6/GRKQaWPxXv1yFT/LxTnEoFpF5ZuwcROwXJzTgyf5uANSKquLppoU
	BQNJEszUFCUB/ZXVbC3VqaZw
X-Received: by 2002:a05:6000:25ec:b0:498:1d72:106c with SMTP id ffacd0b85a97d-499c764c9eemr7954310f8f.55.1794476443061;
        Thu, 12 Nov 2026 01:40:43 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4983284c990sm14867834f8f.3.2026.11.12.01.40.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 01:40:42 -0800 (PST)
Message-ID: <db9ed03f-0b85-4360-a2e9-f6719773c7eb@gmail.com>
Date: Thu, 12 Nov 2026 10:40:38 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/12] mm/madvise: send UFFD_EVENT_REMOVE when installing
 guard regions
To: Tal Zussman <tz2294@columbia.edu>, Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport
 <rppt@kernel.org>, Peter Xu <peterx@redhat.com>,
 James Houghton <jthoughton@google.com>,
 Andrea Arcangeli <aarcange@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?=
 <mirq-linux@rere.qmqm.pl>, Andrei Vagin <avagin@gmail.com>,
 Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
 Muhammad Usama Anjum <usama.anjum@arm.com>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Chris Down <chris@chrisdown.name>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>,
 Michal Hocko <mhocko@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-11-00713d368976@columbia.edu>
 <avTA58zlxJZ69TB8@thinkstation>
 <e19f1fff-f1a7-4c2b-8908-2d3ee6a49069@columbia.edu>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <e19f1fff-f1a7-4c2b-8908-2d3ee6a49069@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pbsqur57orgu7hz7hhz3h6tnmgqg5eyu
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: CD7CDC000A
X-HE-Tag: 1794476444-619293
X-HE-Meta: U2FsdGVkX18Z/5AMsefj8k8sg5B+HRLn2VknVOStKXJ1F0AkZARv6XwyiiWKMp4gu8CswDJR7quhMaPd2oWaXpD7RA8V/naas/fBGPaytSJzRErk/gK5KUXUg1bhA3M0+7LtcIWRuWCU2AxiY5A74qbeAuX3DOSa3MDHNQQu3yRdRqpI9wukE7HslRW/s9Nyb62lAQUe38Z55uquyt0ilDN6Nkh/OAGaOmREGWDcgkL4KMoOXcEfagUkYzCqvbUfb43FGGM3fEaegFoTsza6O7/LFe9bH3kx+SJK6Z/hvbbxUs0Zr3oCdm98sxYBWe96siotmuUCjepZEqFnvYM01tPTVOJ/uSSiu4QK+Gz8LeG73DWnCUcMoZ0JYGOPpHnYCLt/qsmGfnpUJ7V1NxNb8uAN2gsgSlD81QLNLNCVlFEhNG8SnG8DvvTQU/+GSd6Pp6z2lqYQAOTzDLLuBaJXS4+LzGgE75Jb94t/8xOX3H7HUQVifOKaTYNg8NeXv3Wn9GAaXEJ2OM3wSl6DeycGpzrPTAbDTiyl4ichkUjtLFZR+BZ1UpM8hg9s4MptU0TNxyi2snVa5dmXPDfXFkS85dDAZalXl0vLEBSI6pCkgqlK72jvKGc4o46QtzCn1SUEOskNT25oA0Pb1mFiLr9DxLXybxrWp2BW9xcyEPRCdKlInRrjmxp93+bsWRCE+/EKfxop/49aI1i2G6Y7r/U4oS/pVXqVSOV+C4qGR47cHV8omriVEas0O9I0ToNptJeXkJJNQvVQUapthCq/NcD9ocBTvvS2QAT69Ci3bZ3xbzIky3NnBxmRuj5gCooi/nWUHVe5s0winXhoNnximUvWD73aw3rPiIKfwmrhHoRS34BzJCBxX9ugf88Cu4n4CYiQtZxw8f3O1QbrpZ1mHkO8mRnMkFRhMbyPKJMdWOBtj1rXciY+cQJkRWhM4MsR0TWZh85YCE+6DP5tzUjrluc
 oq70Ys+y
 KlKMCCzotdDpTNzKiaymJFa5HnYklNAaO25hLhF86UUAABSDPhw4j6jSq01i2ipTOOqRiId0wJ3z2gCL1vTD5WqjHZhXr9FJ35/D9awARFo2SW0ncu12uq3Ggry6e7tN1EGYfEwH8xJA7/Nu9hxAzJwCEtHFtsG3m3FLM1tWb77QIuGF7ghi9w5IIsTtoQlPFP2hD0KRb47LRUg0G90KJ3nYZw5VHNlO9KDn+9kd/gv7GKEPmAlH8SqvX//mQDh+N12Qw5xyHZszmX+x7bTV9wB+VlTK30h75qH99iUKeuU+qh0A+m+ls55B6c/9kJ/cjG9YWkZD+KWExTw7oMuTQV7pr0YE5lMGmVC46PQ7f/7hteg0B3aoAAknwNSEHDf0USh5a4CPBeL/Kk3TOHUZxyKWPf1r5Az92XFkhy33RBmxp77eCHoIpzjrjYsReN9Zps+O5le5/vjYCZm1AjR5J4A0g68dy0+t7AYjX6UivIPXsubeI56gP9MEjUxivdg6JmUWfRe4xbEb+3SdiRn/yRG/tV3zYzbQJ8GT+Kh3hzIrweqFhpd8mdw017w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 12:21 AM, Tal Zussman wrote:
> + Jose
> 
> On 11/11/26 2:25 PM, Kiryl Shutsemau wrote:
>> On Wed, Nov 11, 2026 at 12:55:19PM -0500, Tal Zussman wrote:
>>> On an anonymous VMA, the zap drops uffd-wp and RWP protection along with
>>> the pages. Writes and accesses to the range after the guard is removed
>>> are then not reported, and the manager cannot know that it has to
>>> protect the range again.
>>
>> For RWP this only holds if the range is registered without MISSING.
>>
>> The zap frees the pages, so with MISSING the first access after the
>> guard is removed is reported as a missing fault. And there is nothing to
>> protect again: RWP only covers present PTEs, and a page faulted back in
>> shows up as accessed in PAGEMAP_SCAN.
>>
> So this makes sense, but I think this gets at the documentation point
> raised in the other thread. It seems that to use sync RWP "properly" it
> needs to be combined with MINOR for shmem and hugetlb (and MISSING for
> holes) and with MISSING for anonymous memory. Is that accurate? If so,
> this should be stated much more explicitly in the documentation + man
> page. I see that co-registering with MISSING is mentioned, but not the
> rest of the points (reclaim, collapse, etc.) The example in
> userfaultfd.rst also registers a MAP_SHARED mapping only with RWP and
> MISSING, no MINOR, so that should be clarified too. Hopefully this will
> make it into Jose's documentation patch.

okay, if Kiryl is okay with that I will add it to my upcoming patch.

-- 
cheers,
jose a. p-a

