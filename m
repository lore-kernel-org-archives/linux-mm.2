Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ED91C4452B
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 00:47:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A9996B00AA; Tue, 21 Jul 2026 20:47:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65A4F6B00AB; Tue, 21 Jul 2026 20:47:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 572BA6B00AC; Tue, 21 Jul 2026 20:47:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 32D076B00AA
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 20:47:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9D2F04017A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 00:47:21 +0000 (UTC)
X-FDA: 85014573882.29.36DA55C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 884B9A000F
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 00:47:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OKwibTze;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784681239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LLICSoAEbuNBmvuKnc9OnHOe4dlaUu87fmsRcvlQXT0=;
	b=YGnwSoDrhI+EKPSJmowzPcBdoyOlW/AE/WaKs5BVY8kIX7oAGceb/EVh61F+bE9VLXlouL
	gYDYPvfKRmI/o2W8gUB70StGsc50a4z+A2N/uwocJIKx7sKtXDEqWkiD6jnaQCl+gmL0GG
	em3496vfOP8CGv4A562h8Nu47T4e1RY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784681239;
	b=22F+yjsaS6HBs+Vk7Fc4nwY5q8dPijUeVH+lK49uvJElG9VziVt9sSpTsUJlTJb0SNRYGg
	jFEBGLdg/4e0Gnibj6b5DQkaJkkyrMoi2IZnY5UeR2e1ZoiwSlHqmVtfuq61Ky9HG9D6hz
	kB2JyAFSLb4VVLKt6XCRjRtuhJ9aApk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OKwibTze;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BD791601EC;
	Wed, 22 Jul 2026 00:47:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E581F000E9;
	Wed, 22 Jul 2026 00:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784681237;
	bh=LLICSoAEbuNBmvuKnc9OnHOe4dlaUu87fmsRcvlQXT0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=OKwibTzeHVF7J9vs/fUZLk2TyiKRve3uRQZWHObYFvrT89CWXFdm4hOiGv1ylcgFp
	 u8PXxFic1fkHIUcUFGsvF6rSzde2zgAbS7NEblotKRL3YidXVse9tKDTdLBfLPmFTs
	 QoEMzwxUsYfTBuo0DUFJf3qS+9e2omGlPhd+C0D8=
Date: Tue, 21 Jul 2026 17:47:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@lst.de>
Cc: baoquan.he@linux.dev, chrisl@kernel.org, usama.arif@linux.dev,
 kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com,
 youngjun.park@lge.com, linux-mm@kvack.org
Subject: Re: [PATCH 7/7] mm/vmstat: add NRSWP{IN,OUT} counters
Message-Id: <20260721174716.c35ea9ab0db2b8d546135fba@linux-foundation.org>
In-Reply-To: <20260706132206.935272-8-hch@lst.de>
References: <20260706132206.935272-1-hch@lst.de>
	<20260706132206.935272-8-hch@lst.de>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 884B9A000F
X-Stat-Signature: zykjnsoquii7nsj16xy4i4w7nkjabpc8
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784681238-375660
X-HE-Meta: U2FsdGVkX18P7b7O+PCskXBO7PpCAeB+zHPkdT6/w94T95ImsGPGJV44idFXemgtJJgijH+LvVzwpleSxfGkrsrRxDrip3xr6a+Ud6XGTG/gFEO+VA8ba+8Bw5C3ctnbYD3JszZvMQJ17Y7sj+kg0e1WRTsEDoyOrvflL2rmhgg1S5Ydpo732Zfzp4EzQ/MJZ6li1aPKxVRZzHvlAksWNZnVg1FCfbeBRS+zsRlYxNzqmyvfHa4PHYrGC+55B68AXs+7Sj+GU2KLGddzLBT3tubj2GV2x1t+i7WTHok5E93put2Sv+L35Kea4LahlLIs0b+Law0q+ui/xIi8Zs1hLaPhAWnshIZX3A2EhtxbkMxnTsHtTuMrfUG0L6o1eg91QnTS4woWvrEZ0I33bpJ+FKZwcDLvCC+iTZyoLyFoH7sQEyOOvNmxdw/1tz+TvKrsOm3u/iYJ9akWldNRhEeU5bibEAGvfuK1l+vkJgleOOn47/9PHlmTKRhSnGASWm6ex1UbIthZ4XICY89Ay59GhZYaOgT8logzkNBA8mzvGZDgYISVZnwRzVlvdROv9TW+KOt7VPRJxtpVnYGWeF29FSvAn2UqsPl5Cww/fbXwzxnmj++Smlyai5KaGqmqaHTkzilEYVxtg3LSRn/RZWkig7BZbvuT6LrIB8NRAfVzYIPgwjobawwoIapS2QWjTEEQWli366wMVOTjcmUr9VCWKaj0LVbdFeyjn4mZrNqBtseh1Z2/pWk4LO9h8G261hk//FQoLn2Go4fqtqvv8XoYq+cq6TkMX4cmSE1Jp9gwM6woXxRAtA2AGygI+8VsUsZ+qEC7CnahciIyiLx0zRsQHgz+Yh7eHD372NJ8FSZhejUvxd3q2xpytnLKmpLyo4sZAwgjnQZvrcx2Z0Ts/aWT1v8oIUUH/KJJK9ERN/K2h8mdsjTO/9Y5d7pmtwjqtyBognD8kgcmnHsUHRotwM3
 tucu2q7/
 UB9HTIn+1kFkTLPNdCbCkbsRxlM3fhL8Bwo04yPqbnvOEprAAIQuuZ9xkXXu3RDzUb07dSD8+TGKjSDcGPjhW2Srgu4v3NEjxCpukKgQ5pOMYpLxXubr7z5LEB1Mu/PZzraym95FXYDT6k+DwENv6RgX0nKZU3iyMc7jFTp/9Hay4o003lJRhwAMJcorZ1W3FSQHo1lNfcsyhnN2CYxmX/J6otVEPPuZuHgq8Y8kkECWG/oAS1pl+0P6jzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  6 Jul 2026 15:21:59 +0200 Christoph Hellwig <hch@lst.de> wrote:

> Count how many swap I/Os we cause.  Due to batching this can be different
> than the current counter number of pages written/read, and tracking this
> information is useful to see how efficient the batching is.
> 
> The counters are added at the end of enum vm_event_item and the
> vmstat_text array under the assumption that the order of fields in
> /proc/vmstat is an ABI.  If that is not the case, they could be grouped
> with the other swap counters.

Well.  We've always taken the point of view that /proc/vmstat is a
developer dumping ground so things can be added, removed and altered. 
Failing to Document/ the file is our cryptic way of telling users this ;)

IOW, it should be in debugfs, but it predates debugfs.

That being said, I'm sure users are poking at it in all sorts of ways
so let's not churn things without good reason.

That being said, it's all "name value" pairs, so the ordering of things
shouldn't matter.



