Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D40B8606B809
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 19:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gadnwvYG
Received: by kanga.kvack.org (Postfix)
	id F216F6B00EF; Wed, 11 Nov 2026 14:25:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED2326B05B4; Wed, 11 Nov 2026 14:25:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9A8A6B05B5; Wed, 11 Nov 2026 14:25:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF32C6B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:25:43 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 471F01403EB
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:25:43 +0000 (UTC)
X-FDA: 85423817766.01.5445203
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 51212140007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:25:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gadnwvYG;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794425141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nLrVl/k3KgLHzXmtBoOIZdPXNZn+ttWx65joOkMlZPo=;
	b=ba4hETWGDYNqVgwnPS01CdOgxLqHSqShBvDOugikf+LyuLjzUkatxqHQzcvOSEAsyd9VdZ
	Jw51RdaYurDnVIzwBBkSx1ACMBFHEVPSwOBejBzQ3+ms2hhOiLHMJWjT+eZRGvko1evglm
	ryYAycj6FGybthGfefQwtDkNTCN5uDQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gadnwvYG;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794425141;
	b=5925a5X0LMAjUYEsQk1nIPcdfyxNrMhnscQqcL6U/mJMwkGJfhkeJYLj4BzjxV2jUqz5Yo
	WPwkWxcTOVyeB24FbOncVp7thmwQR19Oly2u9bv6CZzt7Dc+YRXcOcpr8BlsJjZsrJYWz6
	DVZYsbZIllKiIMIyQzVXjmKEyYcMOS4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CFF706550D;
	Wed, 11 Nov 2026 19:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28BA21F00A05;
	Wed, 11 Nov 2026 19:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794425140;
	bh=nLrVl/k3KgLHzXmtBoOIZdPXNZn+ttWx65joOkMlZPo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gadnwvYGYHAXYYVGk1JbKh/JDgeU8CHZAAEHkxHMQYEAdjkvpD8GlA+iOgSQ1gHaL
	 2WzgFZY6dMZD32ET9fMNrWhfaCiiC4Y34HIpRimS6mMDQa+GnhVjYmWL0criR6mOtK
	 zgJJQ9YNM5t4J8cc/PQdZCvMpwY+05M13mf7H+QBNj6lYRfha3d3soNYgfiFNOolqF
	 VYJoG90Garjxk7cNd08Ew9nNK6lpJvaAyiecaPHkl2rgqsykZnNfbzF/DGjbGZM8m+
	 5qPOW61uhkaFVNmP1xkqi8Y9uKTeB9BtnxR6ewQC9bAdsv6tH3LqBSnOTHgYav5hxB
	 IehLsKRBtSjyQ==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id 28E98198003A;
	Wed, 11 Nov 2026 14:25:30 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 11 Nov 2026 14:25:36 -0500
X-ME-Sender: <xms:KcH0akBuLsxUavrAsIs6NxQG55-wDLmQDqxgoT0hHBepF8UnAiZSeQ>
    <xme:KcH0aqs-jZwa7Qx5qtAF6J6d_EYjkpJrHlD-J6XSJ9ah6Bhk6l9Opreu5nh6zox7g
    05Qbwf7W_s8mcVxEo1MvTLOUWeb__Z-Ky_kPZ_YkdZoO9UbwBrjVlIv>
X-ME-Received: <xmr:KcH0asPHhMRC6GJyUYQaU_FufK1SRqQnikEBJtKQgnI7YZ3L_HNdvZ6EYe0>
X-ME-Proxy-Cause: dmFkZTGVCwJi64G/NFk0BwzEnaSuCMVZAMzOi2v2VfdLLUWVfoxG0mAp0ULnNCJcShF2US
    zpqvkUUooMNrb9VT5bI+vNxuhwJuht9BnZuyP6D7bvZpoK8a5uikkJGwYKWB4heRQ9E8Qp
    8sFCVqzwGTCEaJn44LCyasSmVXfeqafjx/O0DiPO5mcDIuboMSbr92WRN5tGZf5rQpFY31
    06/Afv0VFlX+JK/uyhMP0CiVCN8q3iMXiYF4dq1x7GZLlVF4MqhHo0IfHCmyrD1YpPu8fo
    03njvV/FKfclnNsctu4TRqpZ7QfV9E18C6DC5sQImJkZh9i7ypzb+El+NDySjRQo2OVLmI
    GM/Jd7JhmF5Y9hVDkKokHMQIA4bJVVX0aPReG+1uGfuFZd8dJ5WNxaQuO1dD5m/6En8RPK
    fUMhgFo2c7IxI+em9h58OsEervXa2F08mHxIEqGlCjYMUwpIC7K970CUfnPFsukHH/piiy
    lCPIsBlh5O0aJWIWnYjPobC+oObXpKCZLinZ+jw1aWP1N+wt7+9ur7cXHwegSBM2LUJ8s1
    yyfVCMVinA/PEJWsRAk+M0qK5itVdjSu/G85tdlBzL/yO3fxabKkS3ayTaNJDQ1MoTPQGb
    OuCHDUZmlNpKRYpF7Unv6Ca2ihvDHAJ43ZIC3u5t/aMPRgDoWkE6i8PBRRXA
X-ME-Proxy: <xmx:KcH0ahXb3pDaG-egTgcyFVKal5e5UJWmwA1XCxDAJeDBi3hTpotZwQ>
    <xmx:KcH0arUxJGgpq3-DqS4au7fqAE9HdioSg8Jej7YolRZKJZHet3H6tQ>
    <xmx:KcH0ap5Iz5xKUdVTI4f5hOAPXNy9NechvYgzaz-UPcVSLyQ1L5azBA>
    <xmx:KcH0aoL0yRAdUIWxNF1_p7NySAlNl5Swaox8JtCcvlugxxWdBLVD7A>
    <xmx:KcH0avLoZVlC1P_az5xw1K8JfENI-Sr8XNvn7CujOffJIHpVDW_DeoTl>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Nov 2026 14:25:28 -0500 (EST)
Date: Wed, 11 Nov 2026 19:25:27 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>, Andrea Arcangeli <aarcange@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, Andrei Vagin <avagin@gmail.com>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>, 
	Muhammad Usama Anjum <usama.anjum@arm.com>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Chris Down <chris@chrisdown.name>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, =?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 11/12] mm/madvise: send UFFD_EVENT_REMOVE when installing
 guard regions
Message-ID: <avTA58zlxJZ69TB8@thinkstation>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-11-00713d368976@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-uffd-state-fixes-v1-11-00713d368976@columbia.edu>
X-Stat-Signature: qbfnayax9zw33wxgz3dcjkwo1gm9wfae
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 51212140007
X-HE-Tag: 1794425141-570377
X-HE-Meta: U2FsdGVkX1+Cjwm9L7KtcXoIY2q/hFmwFzfW9trgLCrNm5kwjXsQT1ug7w3Hb0eNBjSSC8Zu7z0K0tUJJKApw0qktLp6g8mrKyYFfAcT83ImSBszPv/otmhA2YKcq9uyeiQFbV+mVJvl2GuWQ7TuOnZd0T9asu2k9c1fVeF/77uzmtkCOE7wdGfV8XxI7tiTT0Xj9DINp/lVnfANr7CMeI2kNL4rc3oXcWpraJ/dzeMnQH1yhI0RoXeooy2tLD0el3F0om3MpZopX1FhSNrgBTU1xylGoVtcg/LyqZGTg4FoI2nZjd2GdOSCM82V51o1X2xctT3wXFmBoWEawklbg0HblgioSGYV7ITRrkV2i0WSfZ/DDt1VMmv23vdn4ovGXxePElMFe1QZyVqj4Nt8Hq1/SWyFb4D4rkSFY/vaf1UD4PdbK4cwS/lunbVWFsGiSITerJYKyVTriG/EhtFjgj/+yr0SW2SfLRLVbMe25aiEWYkG9bivtTgKjvY1vhuAI4cKMJKVNBAU2vJwdjgkmZV/eJpA55Cpjzlknjomqfoj96TQa2dkp1tiM5me9G2Qux4lSu2mjKWL9cNS9lWgAhiRIldm5v6bzkhn4n5EvjBtpAFYzbsP17ENYO6GcBhEVMkTLqODKOEKYjfFiuWjz1TAwmJQ2bph8jrHmlsuofA7R6IQ0K+k7Jg8uMvjh8vD+BwDCmZzO8uHEtreVR/iJB4eyFVUVnhcHWQPZfHWufsj3QeAIfOe2tRmUMYSc7JaOrFxsrhLxr1blTyr0T21LMkgggCge293kUcs5+fC8VyUs9k4IOqKhMdByFiatjQdW5m8ZGpSBzfR2TRn2bkVMNA4e9LvL6QCD9ET7U+TsoPdkDK+AsrD8YkTUG2C7lMCnMbzaPcKlbFo22b/L6P7Q0ZOURWi660bGJsVv4d80p/h32yHc6OLKJB9mni7Pwo4drXQt3c62xZdZ1P9py6
 9tK0GEbK
 VNGlM75eoCaU6yqBJObGvn8i11mG0HnmjljVohFhWgrLR28hQnYv6IkO9gTVkJEbhFnIIqkncVHXVTNGztgY+W0r2bKFoUt5GzRPYfkAAbogf0sD/4qRPKrENpQa5xFyjxymRbOb51jbusukXuwCRQUr4PUR/9sWsyfKsv0xaVsBxxoXpab1rqjowN8go3zx5QA+QLg2xDPVmXQH6X707TLfY6oDIOpxS7dZhErqT7dj6ZiaT9DAgbnuN9FQCwNGBZj4oq/z0MslZQ6dEkzafVxjo1AL1W6MMVAI7bCB1y3BUA2kde0ZHG9XB4xBfSW7+MArXPo6g5lxnI0Nkjzel7sBpFnbgOWIqevSZwhZOdjH7vTmUVW20Wgo+/wfzYlwDKuIloWbEtiMJm1JMhQuO6yfhMygW7zGnuERcnunh4FYY00k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 12:55:19PM -0500, Tal Zussman wrote:
> On an anonymous VMA, the zap drops uffd-wp and RWP protection along with
> the pages. Writes and accesses to the range after the guard is removed
> are then not reported, and the manager cannot know that it has to
> protect the range again.

For RWP this only holds if the range is registered without MISSING.

The zap frees the pages, so with MISSING the first access after the
guard is removed is reported as a missing fault. And there is nothing to
protect again: RWP only covers present PTEs, and a page faulted back in
shows up as accessed in PAGEMAP_SCAN.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

