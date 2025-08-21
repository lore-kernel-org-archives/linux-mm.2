Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92274CA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 13:02:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AABA8E0008; Thu, 21 Aug 2025 09:02:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15B4C8E0005; Thu, 21 Aug 2025 09:02:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 022E78E0008; Thu, 21 Aug 2025 09:02:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD9D68E0005
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 09:02:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5E1E458B09
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:02:14 +0000 (UTC)
X-FDA: 83800777788.18.6597CC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8C9BB140012
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:02:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nLjdZUQr;
	spf=pass (imf23.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755781332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0C160FFCWRXvcqeCUBEGZ6UKWpWBE07aah4F5zpxARg=;
	b=XeNFKuOzUzp6BYrjBl9c8NwB8SMKTEhCQagitJoKLTP2vIH51oOnnMWxKJbE7jZH8aMgzd
	zwZgO44HlGJT4H6aqZ1BeW9F/HGZfAckqfjMWyi6j4XDVC1JPtj6eQU1ngjFR82NWfn5Ok
	ZD0SDK3yFLczMvJoBC4mLsGHD/Xxlvg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nLjdZUQr;
	spf=pass (imf23.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755781332; a=rsa-sha256;
	cv=none;
	b=fBQ7uzq/ngnoM/xSBrufATZy/sE2fIBFN0XbBURnUKr7p+UJpPiRf6oqbKMcvwal3bKkeT
	orO8h1V8SEt3VCZDaRs2DPyYFWBDPG/QI31kby/AtfkQfW07gfrycm2g7xW3PEQx3VKcTs
	XEaQs9Q0OXXGYTEA8l6GQ6Vy1LBB7Xs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A29544AD6;
	Thu, 21 Aug 2025 13:02:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40EA3C4CEEB;
	Thu, 21 Aug 2025 13:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755781331;
	bh=HNHiZLThPQ887txOD81b+D+T9uJUF8eSiY2C4Hx0+CM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nLjdZUQrco0yrBsfgTjmkII/EchFrBZc3oUnkgzCbhO9PiSuT3OJHBPNnOmZU/qcm
	 W8vSazTpvJGQ56zyEZcwal9IKlGpIMiBSAUQNh1nbU/Fgt5M6/X2HfsBYi9Ybl1qc0
	 NbgexLJbd+TEdcLzM/VVHiY956Fk0Fw5O9k2IjmURetxJcXVRk0tDyZpYJOSXuVuTT
	 HhRAAHWu42OkPojnJYm+GyOszaNXb5xGvT/Wi6yQlg3rRxO0cjwc08lXmyAQjSNsD5
	 jMueGfHlncQvGJfTVm9vGi2NizVzLpE9Hyl0kFnSGhn88LekF/R6ScFKoKrN6IF1be
	 hWX9ZG06deOtQ==
Date: Thu, 21 Aug 2025 09:02:10 -0400
From: Sasha Levin <sashal@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@redhat.com, surenb@google.com, aarcange@redhat.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/userfaultfd: fix kmap_local LIFO ordering for
 CONFIG_HIGHPTE
Message-ID: <aKcY0ocUDHnLJv12@laps>
References: <20250731144431.773923-1-sashal@kernel.org>
 <20250801141101.9f3555a172609cb64fde7f71@linux-foundation.org>
 <aI04CQZZzgCDO2A5@lappy>
 <20250820212423.fbac2b17eb4f6a9667a8c979@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250820212423.fbac2b17eb4f6a9667a8c979@linux-foundation.org>
X-Rspamd-Queue-Id: 8C9BB140012
X-Rspam-User: 
X-Stat-Signature: za9da4qt96rdkq9sjuw95d3q64x374nt
X-Rspamd-Server: rspam09
X-HE-Tag: 1755781332-336691
X-HE-Meta: U2FsdGVkX1/nvdLFZ5O1k7/khBBfyIWni3Evt0CFnPsv6oXr9nWeqrK5cPakviZNPV7LlfdQH9kwcLcx/3ya/HvLa+a560YXRAw+BBsVdWmyeA8tGU64W4FHSPE/W6Xg8S4Q9pE5zG8Ry8cb/NUTsJK+OKGxx+JaixvOL0lygWWI0NuUDuOeGvlKTpNzVq2GWfkWHkaiKkb5CzAgsF+qeKsmTsqrchAw6T1VtDlXubLW6doI7kdv6ghk5tkuAlgBQuPcD/XXmygq7u4YUOq8LSq78e0fxi5u+6fS7w1M5YtbTDzEaDa8CgGkgYHtDcjmOT1I3cSbhLiAgYxrw428klLGHYZ5YqC0OJi/+urlwsiQicqOHbhVBGNJUhuRn6YT5cxYB5dXc080VSd4/UKSSEu7hrOIYY7kIeeZSvtO77b3LHToiABUHpVELJLdrn5n9iBOn6W9Obz/o6HxEkxRTEMClTUgZDy/zQdz9BCACVwQx0B7nHO5dAbLRVNColGhY5HEic73RBWzUcLvaU2PCjNvDonkHoopJ8HmaWVnxNSwEOsUekPP3p3Sxqyy/5+cU5pq6aIZ1GPOIvsaJ/pA4XYGnnFkqOz06qSoZvpGAW4ft+tJjlHkjlSVqq5nGhlitOk0uwtlyQ8Be1UGZO0zAmmYsBFuaUx4hfrUIApaxfuVywDITEEsAvmbjpYpZWck4rh04KNhyFEJ3AH+ANJ/A4JjDhh+DGwVqH+Lg2uD1jK3qo6N1SUPm9s4a4C4wjoKkK+tHm944Xm+Uxbbvg4puU1GdXN5LdFOzeg1oZ9T4BIf7Zrm/IIooK+ktb119koZWMqqB6uS7kqI/DSFY3heg9rsf18yF+DRVy9aEv84i6sU9PN+bzPVj+f1h/hBGaXP4KWatI0/KfmMkOYMEKAoZgi8r90E5MSLVH9TYxr7Y3pqvRLeqvxld1Ecdpiu4YIETVufKo+IOjf8bQh1rs4
 WbKcl9Ik
 ilhKcq9BI997ZLLAnhScrjuP3n1l1pESYpjdnWVOkpBjsdED45u8lJed23McCDp8rvpT3lOC/wUJKHz3rA4JsiTq6ip/LIHKFjOihzR3gkMmwP1/JRXDie3+0gZvrze9H/iAVFWq7Ivp0C1NzyuIDOgd3hNmUkd7Ytm5fDkOFjPzxXpYPF7Ewb0cU7Ob4UmctHwqW8hIG+vg9oOAUsBP/QX5LQnsfOv43Q9p5FxkU3EW/9FPUuWZ+Nlsdcuioonh2eNqotNuNgZQ1ZK5lWNmZ68346GLr/zn9G9dmyoeVGKKyRfWv/ME3SfhST1So7dOLNx0NFmnX+t7Zclcroya8skUc7pEp8AObhhPVxg6vlq7mT35mcVV8uUJfou7C7Ks04Ul2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 09:24:23PM -0700, Andrew Morton wrote:
>On Fri, 1 Aug 2025 17:56:25 -0400 Sasha Levin <sashal@kernel.org> wrote:
>
>> >> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
>> >> Co-developed-by: Claude claude-opus-4-20250514
>> >
>> >Well this is innovative.  I doubt if Co-developed-by: is appropriate
>> >for this (where's Claude's Signed-off-by:?)
>>
>> Claude (or any other AI) can't legally sign off on code :)
>>
>> >I'd support creating a new changelog tag for this case.
>>
>> This is in the context of a proposal on workflows@:
>> https://lore.kernel.org/workflows/20250728105634.GF787@pendragon.ideasonboard.com/T/#t
>>
>> The Co-developed-by: usage wasn't my proposal, but it looked like the
>> majority of folks were okay with it.
>>
>
>I need to do something about this and the discussion over on
>ksummit@lists.linux.dev has been as beer-addled as one would expect.
>
>Oh well.  I guess for now we can welcome Claude to the kernel
>development team.

FWIW, I've switched the new RFC to use Assisted-by: as suggested by yourself
and David. If you'd prefer, I can resend it with the Assisted-by tag instead.

-- 
Thanks,
Sasha

