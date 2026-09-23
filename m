Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4F68C98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 15:42:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F2E16B0092; Wed, 23 Sep 2026 11:42:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CB736B0093; Wed, 23 Sep 2026 11:42:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 808BE6B0095; Wed, 23 Sep 2026 11:42:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 628DB6B0092
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:42:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5EC8C01A4
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:42:56 +0000 (UTC)
X-FDA: 85245445152.06.4C981F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 00EF64000C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:42:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i1WVzvYS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790178175;
	b=Q8r9wtA0VYBi8kkDkN05B2ZLLFeG5OEizrc6sDAuQ2HToY1bzpCoL3YT7/jNyg6gECpj8v
	gL2HFhSUc3oqkzFcn/DpRFOiROsbZpdkUtRWVfQCanuKV1zva1vwKyQa37tP4nnzzQAlT6
	tGAbHnxiO6/eK9Sp93Qbv4Zae5xMpOQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i1WVzvYS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790178175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xphkqddDG35nFJUUbtMc1goiI0QNxJoZwZ8bkZ0ElbI=;
	b=3MwIVnWhWeZINTovibjKDHfFyRNBnH2qBbFtqUlt6uTGdriIlvzznrK3H7/m1pw4mEeZV2
	umJHMLRDgn7QwfN6FbBf9yn5WaewxaSuLVsXYvmf4W58DXpW8KYRbUGEkNsHOVyxy9gLRS
	KcEmMEy7DVXxJZfmAgZz2Vy47awdS0s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D1E8600D4;
	Wed, 23 Sep 2026 15:42:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DB71F000FF;
	Wed, 23 Sep 2026 15:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790178174;
	bh=xphkqddDG35nFJUUbtMc1goiI0QNxJoZwZ8bkZ0ElbI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i1WVzvYSaOYfd49odTZtOLwJB4iQITBY8XUEHEEQpD/kWRTktnbTJkZLDjXqGF0nf
	 bed3l3/hj4PNXTAYRUfC87gBnl+Ou/2V6U2Z06a4p+yIp32aU8PJepF9HHIQa+kN/G
	 6YkyGBytjw8PcWz0+cGVnCmGoxH1Ih3YLSRzMonWf4MZiN6Ixfz3sqIoKyZcmZ5S1m
	 EpnjtizqCMRHM+y4BLDJ+0DnanHh94QBNgq76UqxnY5daStbLnFCa3UfFDQIlp57K5
	 Xgjz+SZ1Tz1Lp1rxttFLMq95OEkmKTDC/Y0RYfRcd4nPWysiyPxN5F+hhQu8GxipAx
	 nkj6NUiUe/+Ww==
Date: Wed, 23 Sep 2026 18:42:48 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, Len Brown <lenb@kernel.org>,
	Pavel Machek <pavel@kernel.org>, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH 3/5] hibernate: handle potential errors in
 hibernate_{map,unmap}_page()
Message-ID: <arPzeJ7ZsdrXkzbF@kernel.org>
References: <20260917-hibernation-v1-0-7f7dfae3dbe0@kernel.org>
 <20260917-hibernation-v1-3-7f7dfae3dbe0@kernel.org>
 <5271866c-a334-453b-a95c-8bfbede1232b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5271866c-a334-453b-a95c-8bfbede1232b@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: ctpftde5eouktqgroxgj1nrhh958nryr
X-Rspam-User: 
X-Rspamd-Queue-Id: 00EF64000C
X-HE-Tag: 1790178174-579535
X-HE-Meta: U2FsdGVkX18/zYbxqDs9xk4x6AQOCMJ/vIkz4+3CY/Dl9MZZ3OhoY/k2fKDgB9dWI4nQ9nTxgGERiq6S4p+s5ada4MgH7u/UFdFIy5cUmiRCxGlZsXjXXWQ3jR8LrYXVuiuwyQ4Aa6d4Xn01DQ5Rho3K/wkjLWUYSvbtiQcCyr6t6sH/SFZDa+YymLidUn37x9+s2jfpxkAvQ96dMfMTIffh2577gAYqrQYHMvSqdh/1gLFDXNTnJv8cw9dcVsPlPXKl3CV2AP8CDLvPdiG5n6GPeV10CyuxykNtUh4e84+u0+3gn/LTuHk8k2PWBjK/by4Mdr+UgeuFCozi76pAnvD2vkfuSAfly+CadwBj7KXecImykOG8FHTIQ2dA2qnXRCNOkZYaUUdU0s9KNrs7V6WODnKP2vXxA9eLehX3NmDmENxP6LYqgQ96gnmuPjNFxwRDTfiOJhG4f3k95J7NfqJ6/FTNcOX7QXwu+cqIdzB3GOQnKF9iFlXOYTHO/qUeOQ+XC1ER1XEEVYo7w1dUv89KP4XEIZ+tbzjt/ycKPDqPmwoPgBqt3KGCOgzAt7D2nisro3rfXcEbSai2AcxCtbEnlss7T7FghJzV1P/vNtI5BLy9XxHbWRoyiXzD9yZaZcTPH2CW/rb/oaXp7N8JeblbryWpH7iwldAqgcjzZRW4y9UkCHVifUHWeikpi0pp0ioQK8tsqNa3k3FyMhlRLb4MI2IH+OkIMwUxPjhg8Oo61bRZIdF/qn4YzVeUkr8sNgn+NGe8ipiFSo0VM8BZRWJfVg+MQANMmZl23cyURo8FKdMIDXqtSdA5jI//mwByJWcFNbTm0RNGDQYCaDDx7EdiFMFp9mx6N9IaU7MEuob3CvhzVizOtwZvFSMifEz1vFTFEqCexUkoxaUOMDpIRGZINSC6T9q9pgHpH7VCIqWxsYjyKwX7RmFvuAxvVwVMRR5j9GxHIF0LKMeIC54
 /3k0o5ax
 az3dAv27Dz8zeP1GVYUhuQyJlt2njpxn1Fxx/7U5PQAN3aXqjZcaZCuZ5mbwgkXnwGFBbc9Lwb3S9cfSoo1jnZs6OnX5yRH8zqI3CXzdcK4yLxGRJ3uNejoC1carwUXMuQhbhC/4EX5sg1CxaB6bgVEo6xA/jRf/cbnnVhpdDVkBIfT17jyhIML2gJ+sZEV6JHjm4zwJYSKJVXtHMPlCrAUNk0Xaq2cC6L5E4MWpyDVPFafx9+9cOfL3VK+E/4U+wPbpUh2Wwnb/NKEmaNKZ24SHh5o9djH8sbW7SdEKk6wnkdLo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 12:13:39PM +0200, David Hildenbrand (Arm) wrote:
> On 9/17/26 08:07, Mike Rapoport (Microsoft) wrote:
> > When safe_copy_page() had to map/unmap pages only because of
> > debug_pagealloc() there could be no errors in the kernel page table
> > updates.
> > 
> > However, with the increasing desire to remove pages from the direct map
> > this assumption becomes a real stretch.
> 
> What's our general direction in that regard?
> 
> I'd assume we'd not want to modify the directmap from hibernation code and
> simply fail instead if we encounter that scenario.

First I want hibernation to only touch the memory that we know is safe to
remap, for now it's only kfence (the next patch), so no arbitrary direct
map changes there.

And if remapping fails, my take is that we should abort the hibernation.
 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

