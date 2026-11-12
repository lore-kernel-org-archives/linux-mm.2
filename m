Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55F7A606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 10:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aWaWETBU
Received: by kanga.kvack.org (Postfix)
	id 727C96B05B3; Thu, 12 Nov 2026 05:55:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D78D6B05B4; Thu, 12 Nov 2026 05:55:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 615686B05B7; Thu, 12 Nov 2026 05:55:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F1406B05B3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:55:28 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CFE6C1C3C27
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:55:27 +0000 (UTC)
X-FDA: 85426160694.28.CFBDCA9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3E4591C0005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:55:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aWaWETBU;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794480926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MmheJU6Q1TfEreGKF6QGCIAOg0LXxZZYNAd2NqNTzw8=;
	b=Bkd80SKxhoG50/IEd1NaykIakfV2sairpHqjvZNd4gQbgEnck328orPgqB1EFRcQX6BzNB
	oVz5nhM/kFCkn+TOaQJDnkhPSFcjtjl251IO/cwpK/Xvhkac/kxYNIvLtEUyC38Ue2AOJo
	FZGNMQh+VuUH5eeDnNB1hrQe93BmWUM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794480926;
	b=lwvN9Ztk0vMcw9b5fEgOLxugS6LRSLM6pAHblYMwg539pZnA3+WRe6rKpmstUX2I3WvZ+x
	FKgFinGteN7JnNiJjjnyhAPDVo1Nd8CNvC69qlLd8KsRtbNc7JEWDMGwa5BTVZfENxFCg4
	9ZyOec+bktmh/4qrvsgIx2+txRncmMQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aWaWETBU;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 82BDF43BF4;
	Thu, 12 Nov 2026 10:55:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1901F00A06;
	Thu, 12 Nov 2026 10:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794480925;
	bh=MmheJU6Q1TfEreGKF6QGCIAOg0LXxZZYNAd2NqNTzw8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aWaWETBULe5lqRTShuLTEzxp415DFCyuF3dsXHtF7yFzc+Kn7Id2TOuqeaO+Kxte4
	 rtkTWAvtps0ZdvaexqhiAowoW7uZyrxVkJWTu0jm2q71E7PWh08gg8bta4z4bfG/rA
	 qMXA1ioROTPQqukYSGYwDi6EN0NVMgNlhixe5lPvnp5fnySScGOD1hM6uMWB0Bk3ap
	 6sDxoW73DjdzfoLweO7EzI3FgS+CxndvzAAuefvS1R7DIs8vHgAjRLNEhGKtFfBbte
	 GX4cRddlvQwbxvfj14H72gFiI5aaQyLSM5RonsFF/xsHQb6t03J6/WJHDe1DRobYUV
	 +ySQ4q1HP1uog==
Date: Thu, 12 Nov 2026 10:55:19 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] mm/khugepaged: release contended mmap read lock
 after scanning enough VMAs
Message-ID: <avWbD-FfFJbFOuQB@gremlin>
References: <20261110-khugepaged-latency-fix-v3-0-6eea743cf9a3@kernel.org>
 <20261110-khugepaged-latency-fix-v3-3-6eea743cf9a3@kernel.org>
 <avNrPKIoZ3JHiAjh@gremlin>
 <a1ee8e44-5a3b-4bef-aeff-eb19d354f767@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1ee8e44-5a3b-4bef-aeff-eb19d354f767@kernel.org>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 3tqecxcoiwzkcgaxubi9efoptu4dumof
X-Rspamd-Queue-Id: 3E4591C0005
X-Rspam-User: 
X-HE-Tag: 1794480926-109085
X-HE-Meta: U2FsdGVkX190bSrRT4b1v9/Ub1+hM7CJDAHnoT4pCG3xBUR5wI9VvNmpvQNHZ/i1NSQrrKdw52h7lAIXf3KINSoYfgqKZz8UU64CAb78llEAclJB+5wmp8fWMlZZwi1Tc0l/kT348itn1LFyQzy0QIkr30GiuQpWvbuMne+hHYF1tlP7eIDdYOLk1WPUaQ7BMeEOjIlcY4RM4yGTJSpjMJwiPp/mtJLUHqolmYSzgNz8W1PU1SppyknmG9tDNj24d0IqVRumO00kfs6r+eEoBiUzruPGMBf2yxXq5izACOJ0M6vVJw0RWGUJ8DJzepJbkODsjURvWYEVqQND2Nio1eQALFkQZgYBhIeSn559celbS/AQMd7tPcbOQ57pWLEb1V4snLAFRXW71F+U+XSKOHGmtfDSiFPN8J5L8/wh9NahtewBXL6iuxOZdMGiCuUPQ2bLlTQcl3rHKSryXMdfX9Q8jmpuXbzLgL5hNY11xPHQh8JUVfBduznaY7MELz9uvVKz0nFx7VatINfOJqRJL/2tOJkqjZgfVuyGNIPy/rxr6tbYOxFDf6QjvBdKssWtc7W9rO25JBmVfBvYlpUeXajTO4uICQ7m/KDcR7N2O0DDGkZznF0gG1KtlZdPBqeWLTN99VD4EIiO1je2jPH06FjVZGkS+JPL6vv+bmT6xOk4Dzgy++6XDnRiA0LtDPjAT9+cGlyHJQjwSo5mi9cfGjggDUMWVWg3bnyWPsIqcBevwe0i9EY3+qA/XOdhUaApeNzIB+p7wH0gLnVz82vDfWqvOqi/dVu56yVrgYSV86bge2NrpWD9e8jxBwsEqypIWLtccx8pD5lm82u8wED/XBBh/tNs4CRowxgh0qWdO7aN5UVlLUOpqsxLKius1974mkrh8uB5oWgyBmvuf7lpky320bfgcXHcIgBCYvRCUobUN3oRFx13YWXQEGb4oRoOvAxWeFItwOkGS8xKhjT
 5h9Xgu9L
 3R/yA+VT8NYbgFbhWhfq+dHggTakwXq7phHek1BAsZ5h2SsQBP5BPuyVxhtaj9A6C26JhNpMPrzXDURQbYFygPMMkx2VtV8sno5oBJwyVKmECFRrZhfOHwM9YbjDKJSQHZR8SWjENE/BBxvO0dV71yZDO9vMdm5tgAOR0J92GiR2Jx2slk1/QXDkgPHCgXj9jAHM2r/W7ulgT1j0lNAUgAlV/Vl4ukPSz4qdPNOVZPLwoWEEsbLR0FphXME8n9ULclVpZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 10:26:46AM +0100, David Hildenbrand (Arm) wrote:
> On 11/10/26 20:09, Lorenzo Stoakes (ARM) wrote:
> > On Tue, Nov 10, 2026 at 05:19:13PM +0000, Lorenzo Stoakes (ARM) wrote:
> >> khugepaged walks an mm's VMAs under the mmap read lock in
> >> collapse_scan_mm_slot(), checking for ineligible VMAs first, and skipping
> >> them if encountered.
> >>
> >> It charges cc->progress 1 page against the /sys/.../pages_to_scan budget
> >> when these are encountered, however only checking this budget once an
> >> eligible PMD-spanning VMA is encountered.
> >>
> >> It can therefore hold the mmap read lock for a long time if there are a
> >> large number of ineligible VMAs present in an mm, over which time no mmap
> >> write locks (and thus no VMA write locks) can be acquired.
> >>
> >> Address this by checking whether the mmap lock is contended after 1-10
> >> ms (depending on CONFIG_HZ), i.e. the granularity of jiffies. This is a
> >> long time for a lock to be held, so is a reasonable compromise for
> >> determining when best to do this.
> >
> > Oops I left this in from the previous approach :)
> >
> > Replace with:
> >
> > 	Address this by checking whether the mmap lock is contended after 1024
> > 	VMAs scanned. This was measured to take around ~100 us on a fast
> > 	machine, and given VMA eligibility checking is a light operation, it is
> > 	likely this will remain at the same order of magnitude for slower
> > 	machines.
> >
> > 	This therefore establishes a reasonable upper bound on how long a
> > 	contended mmap lock is held.
> >
> > Thanks! :)
>
> Fixing it up as I am applying :)

Cheers!

--
Cheers, Lorenzo

