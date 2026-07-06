Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9194C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 13:01:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7D2A6B00BC; Mon,  6 Jul 2026 09:01:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C54DC6B00BE; Mon,  6 Jul 2026 09:01:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6C086B00BF; Mon,  6 Jul 2026 09:01:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F85D6B00BC
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:01:18 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0A5611203FB
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:01:18 +0000 (UTC)
X-FDA: 84958362636.01.9B762F9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5AEDC8001D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:01:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jdubb/ld";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783342876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OJidZz22+JDX734AvsvghP5/wyv0jm9tSJVNzE1YIRc=;
	b=24aeH62Oj4NQuZQU83i+hp3ocYz+dc+VdYdyWkVnJd9vdccUK1skPepmwyMB+gXawuZ6o0
	DYk9o3pukw1ritrQWdmtZrUrcprllbjF3ha3uOiqnemro+L+4rJHiN6EVz4V9y8XQw8q8p
	/AEe14gSVxtnXKJ1pkqd/SkPt5leSIs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jdubb/ld";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783342876;
	b=CnkSrGo57V70jAZoHdr7cZ3kdhPJdWZrtHuaOzB8BCo7Juo9aUMgpjq+pmAXNtSBAHAWTa
	HTCPBTNL+n1CVtCxvyXq7OalpMpFNagCPN+bMLAF7Q1/JX1ps27WhXUoVAULjkwfKxqJSC
	/T2O1vdWOm/scIUHtMPAzXXyBbJP+Gc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BDAFF600BB;
	Mon,  6 Jul 2026 13:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFC61F00A3A;
	Mon,  6 Jul 2026 13:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783342875;
	bh=OJidZz22+JDX734AvsvghP5/wyv0jm9tSJVNzE1YIRc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jdubb/ldgnPcXWuJg/PGhYP2/ItNuHyjLnqiq0zuWN0Ee5jtChzaOXMb4R8x1nR2E
	 0BXzaRyotFMDUOQaE8C5tu/w1Es4x7i49K3xxYXBCIIUawtPsrS6lJzJvcpQG2gCey
	 JGK0xnriB7hwda1nIKj2htHngQO1rc6Duc5FQyYYwReJ+oESVcM5XEQzEOzHdCH6lx
	 L3Wj8p9pq/dB4WXdT53ehGA1oBfURA1MoZhiwE9Wq3bzXawRqiU8yVkUqXJKDkhS8e
	 nOjHPGUcKSm3K+lY4Pfc3K1v4DyGcFP4+7vgokoIQ0SX1lRIYmkNtY812RYqL2wFr9
	 Wvuj83TAe1I8g==
Date: Mon, 6 Jul 2026 09:01:14 -0400
From: Sasha Levin <sashal@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Alexander Duyck <alexander.h.duyck@linux.intel.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH v3] mm: page_reporting: allow driver to set batch capacity
Message-ID: <akunGsm92phrfbco@laps>
References: <444c24cf39f3f3620fc90ef4695bd6b0979f4c4b.1783232420.git.mst@redhat.com>
 <20260705011635.9974cac7f0defec9961e85c4@linux-foundation.org>
 <20260705042313-mutt-send-email-mst@kernel.org>
 <20260705013956.36f649b5cb13409d9088838a@linux-foundation.org>
 <20260705044139-mutt-send-email-mst@kernel.org>
 <20260705015116.bdf3335e9a955f057a6d9c5d@linux-foundation.org>
 <20260705050445-mutt-send-email-mst@kernel.org>
 <20260705110649.bd30f742c78801a76137c53b@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260705110649.bd30f742c78801a76137c53b@linux-foundation.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5AEDC8001D
X-Stat-Signature: yeoafidys4t1cqihfeyg8qsae8yfydhi
X-Rspam-User: 
X-HE-Tag: 1783342876-890838
X-HE-Meta: U2FsdGVkX19EPsoTJsRUQGdlQ9Mii7PgKIH5ns8YGIc+ExNfEtq47syvIVkS96zPpNn9QCmNBSCejKhQbxRFjwTU0zkjKD0+GuPqa11h6t1JN7q+z9pYnlUfnP/ikO8UuGCWqxK8KlIhZZ7lLEJLeegCLSGrA1D+JlL4QCSKgZvy2YdxjF2f71bNS4EU6r1UvMc2nm09He6IROtAKUwKImQLM88+eY1fPswvxNpANwngQV52MO8mwH79g4fd2pukqv3Cz//nQsaeSJjcOtuPVfs+xPGHZUJcGIjylZaQps5dckpAvJLmz3AgQPctpqC5sJD5w1TW+Olz75eFjpxt82kqGMbhahWRgzP8d2jtp4RsH4axCNDLuoCCgmxqIF5LBWMVnebEr0/KfME1NDwDw4L6eXC8sbrnbM7kqY2Jc1gsF3x+YDcnT+gQr2mbuqdx+5cjbZmDm9BMKR5xndpjLbYwgdyNpGC008MJ+ROXuhzXRUs6FXFEANABEqeYPRFOq1ctY0vz/6wvUHMCQQqf64PWAIOz6YO+iqGl7QSKy3AXeTZK1lMnDWqplRdwtZEqMZbDC1alJu5vlV0lAB5vJrYsQFYUEE89HofhKwHQQr/trXOVHpjfciGOz716ImoV1bHzoFHdH3N6ybyjBYA7W386J0ZABQR5zcX8XByIVvLSxQDdEADXr6J8DwBnkD+5C5oAqe1DnFRsBMYK5qGUc6kSt/34Jof7Y/Igx0NIjGgKWRpNo4T1Wzb6ca78y+dyRFnlxa7gazUL9f0eAEC2sIDVTVzqAcxKQTQX0klL1PANK6ttAp9PMTbVJrareGP5jqYI7j8XjUtaU/rpWtAcS4q0Sy4Y3LYr1HJh1FlzCvOrfoIOinQMTgei83N/BfWkU0QabhtBLP66NE3ttLdrBOnitG1hd+nnXJrIVFjT2xOV9vyX4hLGRozLxPl1Ka08GhF6JJl+v3S2Edd6OiV
 4L8m4vLj
 wv3I2kYLGiCKsYPXvPSElUkKEIn0n/T0o592AHrsVPkohaRsf6andWpjZWs4eUNx4EozAdsTk8HnmQ1BmeBY5qx/CaOPPRdi9OPKOaABkdQyssj4d8aG1EfHhURL4AUae26ZsFtFSStDE3PLIVb07x1PtVNlYPWWuPwdiQr+riigPLl1LFK3fYPp7SQNxwbXcVk8QSYYomxokrORmfLp7gI9J5NdXYnzIby3gsJEe1u6MTD9yJx66elwjLbRMoonRof9dIoutQ7HBgGUjS+uCUS7D1/UtY/LLhqWuJWK9foeHewI5pQ6yVIwpUEEx7TgIhcKNhlNZqY3F559Z458L8ymx2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 05, 2026 at 11:06:49AM -0700, Andrew Morton wrote:
>On Sun, 5 Jul 2026 05:06:27 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:
>
>> > -stable maintainers have been asked not to do that - only backport
>> > patches which have an explicit cc:stable.
>>
>> Out of curiousity, is this specific to -mm?
>
>Not sure.  I have vague memories of being told "we added MM to the
>list", but perhaps I made that up.
>
>Sasha, it MM the only subsystem which requires explicit cc:stable
>for patches to be backported?

There are a few more. We maintain the list here:

	https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/ignore_list

-- 
Thanks,
Sasha

