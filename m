Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD06ACD5BD1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 09:02:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 319516B0093; Tue, 26 May 2026 05:02:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F0F36B0095; Tue, 26 May 2026 05:02:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22DDE6B0096; Tue, 26 May 2026 05:02:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 12E6F6B0093
	for <linux-mm@kvack.org>; Tue, 26 May 2026 05:02:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D61041A02ED
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:02:07 +0000 (UTC)
X-FDA: 84808979094.08.B2D8AB9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3C6F940003
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:02:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UNomKvyN;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779786126; a=rsa-sha256;
	cv=none;
	b=UYykQa6iKvtg06f205yt4lr9/XUmss7zFkZacfY9efET8PEtMxijILSJo05vDMo1+eIBzC
	VhbJZ/h7/HDKVAnMkt5A6umYtcVM94CgTtI8n8GUIOwVVrwv86X6GREq51vFqE6aQ+ByQL
	TFG0D+tWMzqazSBT+I6Tk9UNOR0xfxI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UNomKvyN;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779786126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wKXIQCwGOxQ2OgGY1VhstzsSDD6YrQoCwtJahftxT68=;
	b=53/RL+mhRe3Bqv394jlpKDluQxqocOazuOifMH/PTXIChzNkSFfR4AQTicExUuj44dYXqk
	HlxYHTazKPgSYMsgzCyrdjYw5A5Wvaahd0KpU7I7XUlw+3wWxb6f2rgga7eKWOAxpkbQsn
	xMQO6Dl+rxpybyF/G+iQLGMjfh+r8GA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 358C142AF1;
	Tue, 26 May 2026 09:02:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588C21F000E9;
	Tue, 26 May 2026 09:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779786125;
	bh=wKXIQCwGOxQ2OgGY1VhstzsSDD6YrQoCwtJahftxT68=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UNomKvyN6nChEG1NxIcLP+N+6IoiopMw+34CALCJS1jVueNSAZJcikxgGk727zWH7
	 /O9hdPRmLXWLr8Ed/g5NPz49bC9TmUl+HlK7pC9ysMn99RGkLEGAFNNN4AGIutRkgj
	 1gFbsnqhWoN5v+gZVG5laclAgI8gyuX64MD6KUdEhjrxGfmdFXM/MeaEYKLst8PS/x
	 aV/64NGkYCAuFFlGutO5jVD5sYTlaFjP/x5AaTy/pBUWXzdo/58xMd6TC7lxShVQK3
	 PqokTXpjbgijnmPHKlhp3IPbYH0iluKzjd38rqcGXg96LlAvdlj8mG/6OqhU1+bJBV
	 1wmaetbFt8CRg==
Date: Tue, 26 May 2026 12:01:53 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Mark Brown <broonie@kernel.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 2/4] tools/lib/mm: move hugepage_settings out of
 selftests
Message-ID: <ahVhgW4MdQLrtNa0@kernel.org>
References: <20260521111801.173019-1-sarthak.sharma@arm.com>
 <20260521111801.173019-3-sarthak.sharma@arm.com>
 <177964236208.4000040.6637433432678119173.b4-review@b4>
 <8992b3c0-a2af-436e-a50f-3729cf589d09@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8992b3c0-a2af-436e-a50f-3729cf589d09@arm.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C6F940003
X-Rspamd-Server: rspam03
X-Stat-Signature: hdiakib9rz9b7nh75f1rhbwq74g79hpf
X-HE-Tag: 1779786126-903395
X-HE-Meta: U2FsdGVkX186hIrfyGx0PvLESPJlGYwITNKPcOUX4l+XWbical6vclFMR1+DTKPInSkTuI6VRHLHpeeAEES+Asg/sk0UOOTSD6e+aLR1EqGbsND95lwPlh96G40MvB39adhpmD1GdSF+9CcaQ/YHRNxMXNIOK8QXLOqZNxS9KXeFA5ODQ2nia0QcEzuBnbZG/+fLGNzDfi0B9WeqbgU6WVriK4t0rGlRAek7af91kKS8BAsypPSx/ccwIznn75yAAoLA00UCfPacB00LVdYkgDqMN4eZlvL5doD2HJZ1UgGCWRGdZXQ+tNUy8VrBjYX3Fkd+o35aaJcseX/cRn5NnMiFCcpKhJrLNhZ3LelMh+ocfGvvQRSrJ4167329GVKKQ//zkdzq94n9nKe9pRqsqpy0BrUihpetymDkPYC4GTa3alBTMA6Ga3MMDdXVKqNScKODtzNtV8i6rF+sawlNxTYuGGVenNhhOZ95GdUdhTGmIS+31nYAmroOiBbxsSAA77/A5Ebi7rBFIm5wVvT9zLtf//MhpnZcm0H5HUREzpWWK5phEatpdIiKsUVLYuBbM7T00FxlUuxKCmJSSjy7v/23KZda5aGoupkfYDtr0hBPiqxkhnzmUYmtCQJsqTtkZtGrfWlzCwoEsOlogrQ+nTeKZqYpK8cW2bq64VvKOHMv4uVd5DNcxrMhNPtjtddvLSTPJ3PlV/H9QfnZ4GMDS3A8pu2PFkQtsTg+lr2VXSczbpgzq1w/9gzdswN4r0EyYcxpvBljS7ElbLLVMbyHE4cL/MuOzivE4qT3Oy/PXfGX561ybdWNbKTkIB5AOknJkedvkwTedJdDP/RWwsIS7OlhEr5u41QmAXB9JIDGpOwHRrxwGhhW2Ma/gW6c0EwERvoIo9WGHY/ahGylaI/C9Lp9EfzrkSi9IsgiMIsXf/3naB9g3ozHPXnhSl3evFURuTjStJfRUlLEUvAqcMg
 4fZdHKrD
 KuWDe19JiySFb+kn2qHAOxW//m76WQNmrD5c6gpYn1avuNp8Gj93EaXL20kUZRB4Vm/aTj/+f4EX/UoQHtdRnI6AKmsNN1AkuB8T7D8MClZpdlFfZ3REM9fBdlPNs76Uu9y5xGsoQ/V/+Tl7wG9zmQkEVo4rmuw1B5CKhCRSaCX31B0wx7NpbfMOQ3755g3Vf54KzeZtN9BYGwKQnyf8/QBJpkVQFAMzJhHqjelfrP+PkJLqSdLqgoLA3fYS46Q2t76o21oHz1wdBZ/8gvlG5QsOQTgdIxM5iPhf/476VmebVXp5T+o+v4NukmDZTaH1NqKo7FaF40FNmGbdRTaEfcztIn1Shaoqss9qqaiGVtvEy7EI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 11:43:37AM +0530, Sarthak Sharma wrote:
> Hi Mike!
> 
> On 5/24/26 10:36 PM, Mike Rapoport wrote:
> > On Thu, 21 May 2026 16:47:59 +0530, Sarthak Sharma <sarthak.sharma@arm.com> wrote:
> > 
> > Hi Sarthak,
> > 
> >>
> >> diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/lib/mm/hugepage_settings.c
> >> similarity index 98%
> >> rename from tools/testing/selftests/mm/hugepage_settings.c
> >> rename to tools/lib/mm/hugepage_settings.c
> >> index 5e947abb7425..b08b27776fc5 100644
> >> --- a/tools/testing/selftests/mm/hugepage_settings.c
> >> +++ b/tools/lib/mm/hugepage_settings.c
> >> @@ -383,8 +387,6 @@ int detect_hugetlb_page_sizes(unsigned long sizes[], int max)
> >>  		if (sscanf(entry->d_name, "hugepages-%zukB", &kb) != 1)
> >>  			continue;
> >>  		sizes[count++] = kb * 1024;
> >> -		ksft_print_msg("[INFO] detected hugetlb page size: %zu KiB\n",
> >> -			       kb);
> > 
> > I believe this message is useful for debugging.
> 
> I removed this because hugepage_settings.c is now moving out of
> selftests, and converting the ksft_print_msg() calls to plain printf()
> would break TAP output for selftests.
> 
> I can add these diagnostic lines back, but since this is now a shared
> helper, in order to preserve TAP compatibility, I'll have to do a
> fprintf(stderr, "# ..."). I feel this would look a bit odd from a
> non-selftest invocation though.

I think "# ... " is not that bad to begin with :)
 
> Another option is to add a logging hook so selftests can wire this to
> ksft_print_msg() while non-selftest users can use normal stderr, but
> that feels too much for 2 print statements and would extend the scope of
> this series.
> 
> Please let me know if you have a preference here.

-- 
Sincerely yours,
Mike.

