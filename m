Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EBEE606A69A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 18:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UtYRBPT2
Received: by kanga.kvack.org (Postfix)
	id 82A4C6B05BD; Mon, 23 Nov 2026 13:53:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DB106B05BC; Mon, 23 Nov 2026 13:53:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 719426B05BD; Mon, 23 Nov 2026 13:53:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D29D6B05BB
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:53:29 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D14A9C09FB
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:53:28 +0000 (UTC)
X-FDA: 85467282096.19.B21CE40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id E815020004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:53:26 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UtYRBPT2;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795460007;
	b=EPoQWATcXojwa/dXxz8TKh4uHVygTlpxJAgvDULwZjA7RIo6/AIKPJrILCCKE0JxbAA/ZS
	8qJgz1V+AcOPfN3FkU1EAS7Q6j5Hy60aCREhQLPblv4uMLEuEam7VmDRTykR+aT6r+O+AE
	+080kKPwJqRFI8jVSAglSZOEZBc0HzY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795460007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=snwenA2UEFoTVk0mC7EykivyD6INKAnjMBdo6EmcVu0=;
	b=UHHtseHyL9esmIz70RpqExaW3zOb0StK/AVmVJO8OzYy+hc7qKGQNwdX4xG5b1Pe2EPaB2
	P5ZYZ+Ys+02ooVeMESMmN/6GkK8tMSbcY5qEoyFdFT0zIiXB+HH0kJJxVDQWIutGmpVLB8
	zbgKX8XQ/p79ww8fp8XFgCkOYWqnA+c=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UtYRBPT2;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4986C432AD;
	Mon, 23 Nov 2026 18:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7441D1F000CF;
	Mon, 23 Nov 2026 18:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460005;
	bh=snwenA2UEFoTVk0mC7EykivyD6INKAnjMBdo6EmcVu0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UtYRBPT2fidmnfFd9lwQ5yWQ0czmOAkmsZ4J1HCHaXNpHtcAFHKLD0Cn6Rr8lPeQd
	 whrCJdnobvEi3WA/AITWyDz9hmjV4WIR+wU0REwZWDUWpnpq9ISz6xPSQYS93PrM35
	 FP3ociNIhDaRxwiPNKWaGMUQvSr7Ft+oqfsshYlLDYlAENl3oUMdJyZ8tdRvkp8Rm9
	 gASedpvdkibfmqVpntYQEq9+JIrezBO8YA8TBpXIrRg4Sn4OnLPMlm9fCUAftrJlw+
	 r9sIux4Vfes6j6QV9KjuZl5jOiuVd1wGqkhpwsQrss/4H256wCzbwUavufZCMMNAg6
	 +bag++oazM6oA==
Date: Mon, 23 Nov 2026 18:53:23 +0000
From: Harry Yoo <harry@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Usama Arif <usamaarif642@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, stable@vger.kernel.org, 
	Chris Mason <mason@kernel.org>
Subject: Re: [PATCH 1/3] alloc_tag: handle a NULL tag in
 alloc_tag_set_inaccurate()
Message-ID: <awSLYc39oOG3EpiI@thinkstation>
References: <20261119-alloc_tag-v1-0-efcccfd3a9c9@kernel.org>
 <20261119-alloc_tag-v1-1-efcccfd3a9c9@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119-alloc_tag-v1-1-efcccfd3a9c9@kernel.org>
X-Stat-Signature: wbihbh8ixmspwcg53cwsdpfz3c8eff79
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E815020004
X-HE-Tag: 1795460006-763697
X-HE-Meta: U2FsdGVkX1/7RS0+H0GXEwbENAER4XZ8d2lcRXSXm/dpWKROv9WNtfmocvDmF8hUmEDe0Y+Q0z/7HxWWsvzkg6A67BXssT6cVBHkrTtl2CSSHQQ5SYdU9iwuxTz1ZPK1mGoE5W1km0jxZiyIm9TLq83fm/Hj1FC/PtJy3J0qLft1lGMfpPwAsF4Mss5jQEv9xNVQts9DCLqbQiW6jgZw6SfaZOCkuU+dhdEYDi8WSL84d5kKq15thN2194AWnshJ+vAlP7xU6CQj52HA2VbPcrNSsCJnpv6gkRIoYyTPiCQYRNF3rrGSw81cA+pnwtW859SFcowo+9SYqNidu/GiIme5xCc1M7YH8bSO8Fx1j20EHiRK8so7EddeVUFbxVA1GLqzg5+VOPpUJC0Ri9vzfDEuiRhLa9H5+SxRt0VG07n/cnhvyLJuxJbqzC3t+LBm4jOaYZMoO2QisO8Okp8GebEJxhc7rdYwD1R1/YSQLb0ESP2aOwTtqajXp5hzvdY3ZpMH0xJHEKR3FjZWBmyU5LK8CmwY7fBA2OXHICuXIDw2unK6nThxSOuSXrCykT9+DUIwRnkxfu1F9Bb6u0mHkuK3b/HbUAHjI7RbvAXpU+WOWCGTmXzJuGgzk8uCL9ei6yhSi3y8XjYPIXzj0hGtHL5DazPCF9TqpBvHIyCOgmnh6Txox4v7VsT28rpkrq1jqcC8uJ3X16u6K5dgFADFpelVn8vWOLa+b73J3C9IokRTll/3OzPKNrXYh1JM1oiiwM5E7/kWxvAcTHGPKmYsC0RL13ob1SLBKmrGsDXTHlE/TkkDTvDA18nWjrlYNZoClCz7F5hsuHPtVrGxDzeEQpWDoBSmI8VBdW4eldlVTpTRzPMFZv9rjpWqtMF3yEnDpoIOqDuuP5kM+kB+UDrNqf5HzmyYSI4TNkfj/Ur5RiJevWI+4kxgEVqoW/9d7+QuHIVPr0VScYvABjoRQpU
 CmaRUPXN
 /4ZTtm/uuD3yIBUWd0T2XZKRkX4XqdheEP+X4+IJRfAxAsN+dh3jDIldwuawTONp/EyUeejqdYHjaTxAfHXdHEu1wvKUftg8xaL34D7vs1rBn29KtCQYSXzy4RkFgToOHWFL9q8486wVdTL8+k3uVzUgaoodsqCRqzqrr/Jehu8Z36BVOc4P7PlzXZS0eHEpbyxNe/nddKgcWGVvjr7TcsOeeXz8k4PuP7tDq5/3q0NrIpfoA/Ps5p4EPYRDB5nbmi8xCbgMO6YFAkwcfsJOAkKKockjpAHHbJDZcsilGrCQVGcNUiojCtIHTqj6Ifghp6Da0S6ESwmZFOBei/oTJkqbi5vHPtfqt8puz0XQn+6rUuC1UEXe67hSitVDpiN7H29ko69cx0zXligY+iVGmPcrkS3pfiXVmcxqUk8ROc/OnlTmdeITih1mHRrKWB50aZkMxyKvFGroInZaxgODDm3iMdHZDjSy1Tlz3c7VwS1xyXavE9DjztzLeDA5rp3YmS945pFIZZnQkweN/SFPHUOm+kCnGkmTTDAxrlxUD5Px66XA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 09:52:20AM +0100, David Hildenbrand (Arm) wrote:
> With memory allocation profiling enabled after boot, a slab allocation
> can dereference a NULL pointer if current->alloc_tag is not set and
> allocating the slab object extensions fails:
> __alloc_tagging_slab_alloc_hook() passes current->alloc_tag to
> alloc_tag_set_inaccurate(), which does not handle a NULL tag currently.
> 
> One way to trigger it is through rhashtable: rhashtable_init() records
> current->alloc_tag in ht->alloc_tag, which is NULL while profiling is
> disabled. Once profiling gets enabled, alloc_hooks_tag() sets
> current->alloc_tag to that NULL tag when allocating a bucket table.
> 
> Fix it by handling NULL tags in alloc_tag_set_inaccurate(), just
> like alloc_tag_add() and alloc_tag_sub() already do, and drop the now
> unnecessary check in __pgalloc_tag_add().
> 
> This has low urgency.
> 
> Fixes: b9e2f58ffb84 ("alloc_tag: mark inaccurate allocation counters in /proc/allocinfo output")
> Cc: stable@vger.kernel.org
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

