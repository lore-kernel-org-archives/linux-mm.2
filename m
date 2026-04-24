Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00D58FED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 17:30:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 540B76B0005; Fri, 24 Apr 2026 13:30:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 518CE6B008A; Fri, 24 Apr 2026 13:30:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4560E6B008C; Fri, 24 Apr 2026 13:30:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 375426B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:30:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5D56A0271
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:30:20 +0000 (UTC)
X-FDA: 84694138200.26.D81903E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2C6EF180014
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:30:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=iOAoXV+n;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777051819; a=rsa-sha256;
	cv=none;
	b=6UcOalcbXS7JvmfdDv56bDWgH1UoEfvi50uezrvGk3c12gcFdws+4LIWJ8mBaJvuK5QpcN
	bTo8kVNc1u3hXXBxQR/AJDtm5ynPewRcPQRt+uGrzNf6o+TNZIEHVkQZMvQ0jwWlY5nvJa
	+lOOSYJHLVngM35gAbwx0dJe2S56kdU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=iOAoXV+n;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777051819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d9Jg9Lzi8tSEG9qdok9IxuJnr/WiNyH5aRTYirTZ2CI=;
	b=xYJzOG7P9gGGWzBOFt3y2Gd3hbJuFC/VDLCaxQ0GZn2u3O4kocz326M2Ob8skbsAI6ma+s
	0yvDig5/IdcNVrxQcfhxJsvRAlZViCCDGlfX1c+mz/b98sI2F3WjLfBShE83IBGBsLgF3N
	o8NUn5FC/9vxa2uGiiiOAolc3L+st6I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E2D2600AE;
	Fri, 24 Apr 2026 17:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548D8C19425;
	Fri, 24 Apr 2026 17:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777051817;
	bh=FJU/2TkCOeajLjX0b6PlHQiWuH3XWM9F2Fppc5W6w1Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=iOAoXV+nD0woDWou3qWdbKPLCxnMBb6XSFk8Fa+kFopjKVG7GJy+vOCPAwQ19OLlg
	 dsIP4hsihV5RDoBZvoocZKO/0i0MvAlvqLKtkgliyXPylDuNDOzgWGyxjgrvGnHdn5
	 7XXTVveqyBlOQ42NPRt3rr+9d/ZzDvJhrq7uC3Rk=
Date: Fri, 24 Apr 2026 10:30:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Breno Leitao <leitao@debian.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan
 <shuah@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 0/2] mm/kmemleak: dedupe verbose scan output
Message-Id: <20260424103016.4ad3219ae815e45de62cfaf7@linux-foundation.org>
In-Reply-To: <20260424-kmemleak_dedup-v2-0-8bea649b2a92@debian.org>
References: <20260424-kmemleak_dedup-v2-0-8bea649b2a92@debian.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2C6EF180014
X-Stat-Signature: yrfg93ps6u5keorh7tjh1fcbr6bxujfg
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1777051819-130462
X-HE-Meta: U2FsdGVkX1+FtcDgi+kAVbx3/S3zdVyRuz+V5iijVMjAlWC8QappP1wqf7y5N10dUTVjd3tbT3P+8/rc5rgk7rGJPGjhYLX/ZIOs1xB0+wyOJlBXqLkLf3Rxir8RXR9mj6Un54n9y6s5A5eVxUL77XOG4ia+W8obTn5Uy27oFekRjaD2/WEZU/brN0EbVR8jH0VtmlT/3TMMuuzfrAD7bRVttr+oP78Ur+MNEAravwQh0EcuLYByFGvzSVBcW0Y89w2G9Iyi0fL9FdAjrgcDHmoAyJwrDWs+JgEawDB7ox7/LMbC/pZSxKj7JqnYk2OUk/B6BpvnVe1CvtojdtT1gVxf9d9x8XwPeNuTb7lTx/bu3wJZWAvtVxQO96yxd91S28FUAjhP2SFnnEEewwW2nv8cknwUSzF4Yy7HSHBbhyG3dogLvavbE+Pw+mT657RMRRXqO3XH4zNJFcgvA5+Y71VVTvCsi9MN7x0dgYjdCH6B+/lhe6Wtq1kGz7Pn60rJy9w8j3DYiF1YePXF/iK+B+602qn6krl4TG/QhD3pXnWrYXPpVpsUxDvhHMnZFSped+ywhhKuw0j6KWO69HxCsP2llj94XHFsdTFAcu4exA85mG02X11jwExnVTBFe+VNszv9dbITWpTGbNvtKO3aIjUmtjUpOCEIBNc3v3bSfDP1UkIFJEDJr/XhP+2aEDGErfaQX0pA/P6gZKkAkD4krrQFj48UHacVj6TKEPPFjXMEkboWzQB7bSxRGuqwFhpX98GPljoS2Mv2XEU1aViNUf1Wu4C7ID4NsgVsEi9JDo4dWVTEfFQVZEGfIcE3nMrJdtOnfwGBhvEdsbM6n4TRfhkFMJdLoZruXNcMHXhr5jD6ogw+OCmYINklrxbVxoeQdlWw0N0wYPc15CnHRmDCpKwrzmvsuZJnPJwjC9FNU2YTpi4iUv/TYw/0Ff2y6uanq2vjJzoRoHoXuAHDh5E
 Qndwlq6q
 YpCpsaQI5xf2UPk/erm6Tv8JwOykVES3Lw8mpOl4s9xAaQ6e/f4l8uKrCTgpHySK7Sd3bmLeXo+bTkc/FARtkvbDx+gb/YtfhpVgJ5vtNX4vc8PWramlEd4tOTOSCurK9HKgFN6xEvyOUhwjgifaaUSUFG4qJvXiE5vLvR4cmx0PASvFS17hFNMyZJGr+1D/1G8hbcJj0oQuuhgVeRQwOfmFJMiAra8BHFJKM4054AxA5t8+yp5zjzX4CZK8oXizBbu8mc48nV89EoHToHHAl8Qgo3w5qchYs86Iow96B9f2AtIPmgmqOMqE+O+ULSL4tnDJwCOBb/BLY5Wg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Apr 2026 08:03:35 -0700 Breno Leitao <leitao@debian.org> wrote:

> I am starting to run with kmemleak in verbose enabled in some "probe
> points" across the my employers fleet so that suspected leaks land in
> dmesg without needing a separate read of /sys/kernel/debug/kmemleak.
> 
> The downside is that workloads which leak many objects from a single
> allocation site flood the console with byte-for-byte identical
> backtraces. Hundreds of duplicates per scan are common, drowning out
> distinct leaks and unrelated kernel messages, while adding no signal
> beyond the first occurrence.
> 
> This series collapses those duplicates inside kmemleak itself. Each
> unique stackdepot trace_handle prints once per scan, followed by a
> short summary line when more than one object shares it:
> 
>   kmemleak: unreferenced object 0xff110001083beb00 (size 192):
>   kmemleak:   comm "modprobe", pid 974, jiffies 4294754196
>   kmemleak:   ...
>   kmemleak:   backtrace (crc 6f361828):
>   kmemleak:     __kmalloc_cache_noprof+0x1af/0x650
>   kmemleak:     ...
>   kmemleak:   ... and 71 more object(s) with the same backtrace
> 
> The "N new suspected memory leaks" tally and the contents of
> /sys/kernel/debug/kmemleak are unchanged - the per-object detail is
> still available on demand, only the verbose (dmesg) output is collapsed.

AI review likes the kernel patch but worries about the selftest:
	https://sashiko.dev/#/patchset/20260424-kmemleak_dedup-v2-0-8bea649b2a92@debian.org

