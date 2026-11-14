Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 780F7606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 15:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MgvfdDjL
Received: by kanga.kvack.org (Postfix)
	id 9735D6B05B1; Sat, 14 Nov 2026 10:41:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 923B46B05B2; Sat, 14 Nov 2026 10:41:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 861C16B05B3; Sat, 14 Nov 2026 10:41:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 64D086B05B1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 10:41:19 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EBD1B80431
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:41:18 +0000 (UTC)
X-FDA: 85434138636.17.F403FD7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5757E1C0004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:41:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MgvfdDjL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794670877;
	b=in/r5KzkJzXVCbb1SaIz3YkMwUbT/z4Q7LAefuStLWHPaZxaXmP91Jqix2DdPXWVyoi4q7
	NcSNvYyCaqbCXUAHBa+NDwKFcPpMDP32qGgJAm1tQngOtWN21QUpQBK00NaN/FWQD15jyu
	PGC4bob7Dhmd4wZygf+8X6kB078LcLw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794670877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lyjlnv4ZRBvs7zUFFyqEqs19DSFipCUMf6YtQsMhMYY=;
	b=iJx7nUSrlAgOx9JnSl1vhe2HxNrO5TqQ5nYiTbvxUzUFv08GyvsQFRm/XQ7e2EQn4pC4iv
	K+8wYW0qDLOW0cuboUpx+MXRxlfZ6Co0D6AXe0raYxxYtFpsnjTQnquFZEaohOPYMgd/MI
	aLm8rrZZItPzhuMyiQ6OLeaR5ifmPdY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MgvfdDjL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D7443628A1;
	Sat, 14 Nov 2026 15:41:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDF21F000C4;
	Sat, 14 Nov 2026 15:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794670876;
	bh=lyjlnv4ZRBvs7zUFFyqEqs19DSFipCUMf6YtQsMhMYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MgvfdDjL5NtTgcxkBujbYg3Nqh1Jtk4GVjDfSBcHsyqH3kQmi567e4BKTVJHi7p04
	 5ZMx6TH0BjuKsZRhk9iqU7PTS6Kc3ktantVMFwlbCGlyRJwQjzhNkMYKIUAqMYTHOy
	 gQWVsVljXh6hIWu8gFMtRwOLRyN1UvManNJuve9be37iPZ2pQ2CsgCgBKJ7YZh8gR7
	 Mlu21r21HTp+KErkDsIQM8Smjujf91tutsIu7icjMxnODvEkMCIUilu65d6q3mTEzw
	 erG4L7ubDckkh0snhsIqa1/0srRvIPIadVclzLP3k6LKmtwVYDH0Tg8Ls2fcA0qQPv
	 JBtzCaEL5ogJA==
From: Sasha Levin <sashal@kernel.org>
To: SJ Park <sj@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	gregkh@linuxfoundation.org,
	4ncienth@gmail.com,
	akpm@linux-foundation.org,
	azpijr@gmail.com,
	corbet@lwn.net,
	david@kernel.org,
	jannh@google.com,
	liam@infradead.org,
	ljs@kernel.org,
	mhocko@suse.com,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	rdunlap@infradead.org,
	rppt@kernel.org,
	shakeel.butt@linux.dev,
	stable@vger.kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	linux-mm@kvack.org,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH 7.3 463/507] mm/vma: avoid spurious write locks when mm->mm_lock_seq overflows
Date: Sat, 14 Nov 2026 10:41:11 -0500
Message-ID: <20261114154112.3718615-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261114031943.192867-1-sj@kernel.org>
References: <20261113153812.408825269@linuxfoundation.org> <20261114003912.82206-1-ojeda@kernel.org> <20261114031943.192867-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5757E1C0004
X-Rspamd-Server: rspam12
X-Stat-Signature: zm91ndzhai58xhg9qc6sad7zn5u3fdmi
X-Rspam-User:
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794670877-674255
X-HE-Meta: U2FsdGVkX1+ORezJWoUkgIcwykFk1vJPnugdNO6iRXnEdfpMtS0HsFMMl1I0q9qgk7cROzX4MhiAZR4MBokPmoznhImqNrhObQMXquvN1BaitCNMCHXRa62Sgi6N4Wimcq7xbMYskZBLfEfoaflu5o/U9vnFL4fSAS7BPi4PCKwim2espRUnmzEQv8uDrM7vjlW8jOW0BhNnzA5jnoi/aAih5e0PmgzKlMNjrYnbtHJfkC+eapArpwSmpd6ADTkoaPmljjRVy6xWOGIoD8ANSZcgJdDyzEA8JXQHPj7dP9B03RiujypfuxZJ/hkELgJcQBEf3ISSiwKnLaQUzYwQmo33rbqJop2zXb3Mj5u+xR8kLWK3ACfYjSlqMPUIFiAj6N6gd304YkxK2ZYsiEiXvWm02QurVdx2yravA8LJSpqVU5w4fYQlfSb3OtYob+phtFfgn6UynhFOV+950AGwY4OMTrWdoyNjkcoMMEWhp/I7pOjGT/J8DrhJGL6OapR1k7S1OamC9rVSbmwKe5WUrpI9gFOC8VOrRc/h3MyU3hObjMStfue8ndDmX8Drszu+ebhhWE76ONqoNBkgNgYZvMXAruNoIxDZD27ZMgDCKx9gTBTQN5TCz0WoaiT9WLZS3h6DJIj3jy74saE2HgCnJMQizamTfWROQAJlJbIQS/EMVZ5sLGFa7swhAOVlH82xfAIOv10To2BQHU2tNesdBUAMV9E0eV1GTszGq9fc7nxFaAkjp5X6Ug884ogCnfoDQPkYRKzYFXCXVrGpcDjoup8xfMmy0Zx1zYK2U0tGoxzJ3JER7QzmTZlvPPvAU67xnwB8fbfRd6YW3ZFaJS1V8OdChZhX/ZEv3iWb0aHZHP0lvCbVvbAJrfd908zOfgHb1mxNJ2h3BJ9TZ22GIqOUXKL7nR0PkJnywCMb4ChGGgReCmHDsZ7FH2jGGR6ONgAxXNfs8eMErta8+JUlKvu
 IvGAeuTe
 p8rIztKceRD3iVZ+98jmcxsciynztf2GRQ2bjyWTTOgI8aCpNFKRWOueMiFUrkSR2D1yz4kXDNNcAlL7CPakQAklVIACLZK0NFrl4BPqLY1rBD0bCdxfWde6jnCQkqHtwGRelsgbXzVDPDR0ZGeCrjqvWFZ3CYhHlvRy4hzSHndt3q5UdSnAoF0W6aVw7+G6w8iq9GB+T/cRD1bkzw3/sGSFajR72zjdrMKwQTI5/sfEXeQ9QP2Xge28ovDJuMXxzwIBzEv2vL8iFSoG/+3YcSej7rDB9srdfCs6PiF68NwhecfzfWIs0EL3gC82q+yqw4xR2ZTBK+MTgBF6Dr0EJF7R2vAfFSEvH5kT7SKZQHA7zAxBj9Awp9yI0IdKjz9X4S+FHAh328WUbxZ1BjMK++4vyBJxQ7o+0EEVD5gjZk4qAKw1b4huXB66VXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 07:19:42PM -0800, SJ Park wrote:
> On Sat, 14 Nov 2026 01:39:12 +0100 Miguel Ojeda <ojeda@kernel.org> wrote:
>> ./include/linux/mmap_lock.h:604:20: error: no member named 'mm_lock_seq' in 'struct mm_struct'
>
> I found same thing while running kunit.  I also confirmed both applying commit
> 47e725702b0b from Dave and reverting this patch fix the problem on my setup.

Dropped from the 7.3 queue, together with the prerequisite it pulled in.

Thanks to both of you for the report and the confirmation.

-- 
Thanks,
Sasha

