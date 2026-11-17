Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E7ED606A330
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 13:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l8U7GqET
Received: by kanga.kvack.org (Postfix)
	id 922986B00EF; Tue, 17 Nov 2026 08:31:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D27D6B05B0; Tue, 17 Nov 2026 08:31:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E8176B05B1; Tue, 17 Nov 2026 08:31:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 589BB6B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:31:06 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EE2711A044F
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:31:05 +0000 (UTC)
X-FDA: 85444696890.06.E8EEBC5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 56C954000E
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:31:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l8U7GqET;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794922264;
	b=fWHSdhAizLbdNzjnXVvPcM2sm8XfvG+idxSl2+29BNarGdKF+m0wyntH8qmrg41u9z21FH
	TNDvAROSNhHX4yQHaD2mj55pn+wnfOfZAdOQMfKGgfdpSvzw7ha5WZ2zMr9k0YfB32zbfk
	SGzp+S1soJaypMfUh4xvgYs/oJmUaS8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794922264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LbIEKVK3wtMckNJgD329X9n3dQQ2GgjJnxeeqAkeQkE=;
	b=pfDraiFAf/wgNZcDwoYkgE+74cXYp+HtaGnQbTanCPgb6KWCsBFzBsVHix9zTmVLHU/d+l
	wYED/HfJaC0b2rnJUga8T7ZOBjE8gQ98dALf+fbm/fhrCRZLyNVkC5XKY9nwP4Tyg5E+9o
	6ke5dvGmKC17QwEItxZp32Nes8K9ls4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l8U7GqET;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CE3F363453;
	Tue, 17 Nov 2026 13:31:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FED21F000C4;
	Tue, 17 Nov 2026 13:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794922263;
	bh=LbIEKVK3wtMckNJgD329X9n3dQQ2GgjJnxeeqAkeQkE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l8U7GqETRL3AIroPoYVEwG1Zqs2ydfYeVWZ0AHd/YTG9+hmsOL6kg+s4y8FVsG9VA
	 0j0vYOygo3p8xkye+gtyOuHycs2BTfqUWA6hbuskk3EADC9KLuLlqUH0oZSx9WIDt5
	 XALPoHwqcZ8Vgb15Q7OA4WmxhfuhMHPxZYPDn6ec8tqOqS6zK7YwKoeyau24M9GhoA
	 yVP/kdoruOfJ2gjktLSzzSIY+FugzYKiOjN2tOTIUVp9TEueBKZld+wC5QwbRUSkA9
	 oBtr/kvXMUMTrksntIW+V5vGdDfeFhWcChrxuK3Y0+41x4xQ5WPWHDKpA2yyf3IUbq
	 0jhhza+q1EIHQ==
Date: Tue, 17 Nov 2026 13:30:56 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Christoph Hellwig <hch@infradead.org>, 
	Yuan-Hao Hsu <aa9736195201@gmail.com>, John Hubbard <jhubbard@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v5 0/8] mm/gup: walk and batch whole PTE tables in slow
 GUP
Message-ID: <avxWSJNLL6znDOEg@gremlin>
References: <20261116210127.3837898-1-riel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116210127.3837898-1-riel@surriel.com>
X-Rspamd-Queue-Id: 56C954000E
X-Rspam-User:
X-Stat-Signature: t8ku58ynrwdgbrk8s1pnowqap9ws5etw
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794922264-288635
X-HE-Meta: U2FsdGVkX18qCbcL/kT5MW7+QlaGt2cKk5RU4/66Rdet3l5BCNk0UQzCl9VYJTTMm/6/VCSPUTIBIjxYP6Em20GjzAV+ztjEPwfUOvVeTkAEwUEkQW9KJeYWxm4cCLWJOwCZ6baEWs9jpuobk+ZaxuZ+wnHupVU34NAtDRsp+pUDeEJeXqFLSvrh3Nx2Ltnrdt6KlVLZL7G1VLgZ1c8n8hBGzuA05WgM8xyR6uFfeEiGNUB605SHwF+y2JQ+yzFFPCm3VpAxr2p21zkxXYKMG945xLkYWRjzQT8grrOLO1OY+RKdJ4N3+tRjDy8Y0x2euUgEEa/yd+C3OhZM91dCRLZdA4ZO9ciMoKUWXQMA5xYoTrJDCheL13rjnUH9E0WjYAFE20BCq/0bgrBa8SYYhiNaX2okmjwKiopb6BRBEywK8g9gCxUE3vwyNIPBjseuq9fgTgpKvhCTP6GCHf6Nsm1K791sJhXE+G7kIO0KrWumHDHq/kp0lcAMbemmCVDv8h6GDqVZqz+haDxMhAqTrhPOsm4WXWDAT6nrShMI/yPrwG1hwqCFCU2i+d8aQUwslM9ZgQPi1JNa/oi3qDw1SG+lwsmgI0gOg53Xgkuuyjvogj6oCUt3RChBaKsjq8XGRGiI0YbBevCc3jP4ziQhjY3CX2qH9eA5uzRV/KVGJbVpGZ6Aon9H5OgsKowsvGo50lrq0DsMQ4okKjaDTflEXSxS/pZaXQICsa2T3mmar8zWUVoMLe7aET9QSKf8CZIxZ3rFTS3KnZHKrQDt8kGcPDZlBcNqnYNe6v8NF4oWCIUSmuwHwEpT7LdWJVjDKcA7hKws7gV1EA7S9E/OHqc4ns+0p/0pUzwEWDPUEL7I0Q82URHJFk3Q9y4sM6w5cPu/SPoF8zqieL1/nlLk6qtacXjwkMTutDm0c2JGhDltUpL37baigWPNdSfG9JDZ3gz/NRxZ1ACFF0ycv6qQmzm
 zG6FqRDx
 ezMtwXhDWr0cHysWUHwwFdKWzyyx/uW7I653tDdWBvR6v1OnfGpK1k7nUo/nb+zTHgjs7KTUZbqj/QiBZcF9b1yJYAQtbz+CBRRh3UfCB7uQxIBNF4WEgCI6o6xlLuG3XbsayccCl9Y+VL9W0CyeNRc7ZJhvV8Vljdoz1Wt2fyc0U9blgVIGhkE+cvGHQDHbRqxow5tIFpBeW/q1NM3Jdj9RPFH0RIScSkCXkHS/sOwpzuhWGhQXYri+qX7SkKY6YzN9l9H6J+0VYSUbYxHM/dsZIsH14R4nmJxXTXpEeo8Wut/DRYd212eTh+p7N0ObmhtJN+vH20zjw0tQUOYhiy5EEWhCAwELx6iH3X50Rw4giETk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 04:01:19PM -0500, Rik van Riel wrote:
> mm/gup.c only: 347 insertions, 226 deletions.

I'm glad you describe it here, but could we please just have a normal diffstat
like every other series? I feel like I've asked you this before :)

I really hate a missing diffstat in the _usual_ form because it makes it hard to
glance at it and know what's touched (and pretty much 100% of the time it turns
out the diffstat is v. large when this happens...)

Here it is for this one:

 mm/gup.c | 573 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------------------------------------------------------------------------------------
 1 file changed, 347 insertions(+), 226 deletions(-)

--
Cheers, Lorenzo

