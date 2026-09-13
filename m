Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 721A2C88E5C
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 18:17:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 016426B0088; Sun, 13 Sep 2026 14:17:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE22F6B008C; Sun, 13 Sep 2026 14:17:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAAB66B0092; Sun, 13 Sep 2026 14:17:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B07E6B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 14:17:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4151716099C
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 18:17:05 +0000 (UTC)
X-FDA: 85209545610.08.BF65FDF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 78B3B180002
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 18:17:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CH2uAWDP;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789323423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KU9uwymn0LP9fWhntovos+AUWynKcZgGYx2o/2j+a04=;
	b=UQG/OZpl8MzYUdvNRaFmgIcLGEUUBZ1H7t2Q1FV4hggzxyUs5kcyIxz7fVAfb/oK5aLNXE
	y2LnJj3xC/pzGkhwbxuM2honDT2Nkyh18caCKq+SvQ4iF55KU1zHZ3eTRKowfRbctWWqVk
	uWynMFmKXP/6EpqPm8h8oS7Yum41e6s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CH2uAWDP;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789323423;
	b=5F4jnWO4W4uGNHooXtxBihHXal9fP7KAmmBbkOF4jLF0hazlJ8dx5cPbpn3dgE4Sl6WkTr
	ZwpLf2HF+Bga6D3xRXGfmrqvKSd3GdIdoZzYnQy8t0sGb+DWwNLp/FKyiqM77kSuHbRKJk
	+Eztg2A7lTfQqbF0hQM9az5wJOgI8Fk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A2C760F86;
	Sun, 13 Sep 2026 18:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7899E1F000FF;
	Sun, 13 Sep 2026 18:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789323422;
	bh=KU9uwymn0LP9fWhntovos+AUWynKcZgGYx2o/2j+a04=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=CH2uAWDPfwJyNBnFFm4FV6Qp6lxylRxMjUnlTHRYBRgV6ogXRxUnAeAuICkUT9bW0
	 3HeCA7cuIqR5q9Gk6G14cSFkh+hoeSXKNcYBE8tMpgn6AhbDt/j1m+ZslOy2aDmnqI
	 cubMNgGpEpRteAyW+WxLtkz+6XEEN/wL+Q/XueLA=
Date: Sun, 13 Sep 2026 11:17:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry
 Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2] khugepaged: hold invalidate_lock across
 collapse_file() readahead
Message-Id: <20260913111700.6de78b5834842f7dd3f12d07@linux-foundation.org>
In-Reply-To: <20260913163644.122133-1-ngocthang2710.1999@gmail.com>
References: <DLEBZ0GIGNQ8.17U563YYJ37AA@nvidia.com>
	<20260913163644.122133-1-ngocthang2710.1999@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 78B3B180002
X-Stat-Signature: ghuh3oq4zgenu3kt46346tudwgxiyy63
X-Rspam-User: 
X-HE-Tag: 1789323423-975889
X-HE-Meta: U2FsdGVkX19X+dmgSoYYpBubq0Zy5xEkVr7U06dY5m3p32FzRyaWZzvYBfCllLsbCx4dXsEYERi20zjC9K2X0H6R7kRBd+X5Gy4/jc7Uv0h1yO36EHOs6l/LopCRakHnHgmfAXjlKmauk7DkzK6cXsge2nsAaAfvduQNSBHAR14XUwnOpjdwm68sUavzq7ZS64C6+kV6qm8ro+SqgWBVelOCCX9MZVc/7L25WnV1xxWOYTUEjdonYgnGHRDy9qrGY2wp459z7qQah7rRd6RWgIGlOczZjpU8Fd99JlQCo9Nt/zlarBpx3V6wyMp3qmK1fMESjye5479oxmMwLL7zqPW+n+10rS1zD/5MZahK55wqKgz9vZ4uOyuNC9umiq7xP4JoAE716esJMQ3VLy178S9zYJJRERvpqN44GKH99RwfROLbBVarUYAwMApzjLMioc4OzjeLc8xUDEhbKARmhoOhhGyYOUU7tS/bhmfsUUwL2LSS47s63V/IaspLGtG0KIhmtOLKr9jiJU4X7Mo+Af218ribzhegNLOTU8TTds5zNuEcjH1ElAcpN8XkDZC+x491vwLSMme/QQ0Do0ESCRBZimA0mUUcKO7dOtBeo014zwpdBmxE6JV+Ni8X51syKJUEjCsFgfC0nn1zwKrDACmQxMwSQ6rzvj88Mt8uZBksSuoOjhXlCeAunTqw0/sRHY/hvTEC5XK+bnmbPRFpfq9rwZbRydsp1kUSHn5aoLCDh1EUwrJq5OxCnwSw7HqSlUqZ8WgRvUVys66K7O2ruc/EyY/ae5cbyXcBWPSbJKy8XNNK4vX4HMVJgkt6OJ9+BKJUMTvDG/oXsN3NznR3i8Ilf965hr1Le/y607DK58S7IsmfkI28eThoxXK6ldu0e7ElZWAgalcLGXRjTVV/vnGIdCRoBWglIb0lunAss6qiFYqe8kQlTGDCTBYmw+i/epru3yI0/oo8OtkEV9b
 EThBCeS0
 s9q88Xq2aFjRbWFt6Ka0ktBo4igX6qjEP2qYb/3eLo/JErV67geYEqHCVoMHEwhsfLfMLvrDQM3+RPteQt15GE4DG9LrXG4s69MzaOxH7ZmANE+hqeWJ0Tgzjgec8x3vtXg2Ca7gAPwNoPIEJIky6eBMNZn0mCJTJ03CM8Ix1vgZFJ/5N7c9PrFCFUyTn5N88dZVRH39k5+s2F1H/aam2jRat9P3Us0BCHx5Nj28Ak9qvOVusqcp3sB69OTOLTVfIGx9eATH/HgtyVgJxjKty+c+GFOt+G20kfmu0tAvK6qzJSUnKQSxljkMy6B1pML6gjkp3/5I493i4yWSlzGm3LmUaEn0JDsJXxTIpO9kE0sdinfX77S8+p1zEHNZ6xGlRQYbeqm+rcfK0e7RYfq4t22I/vBT3f2c77wY/Wl4CeR56DOnHRcr8cf/qYApe1o3I0eT8guhgFuDllW8hH3jsgKCQbIrSUpMh0vV7cp0AelF+sMLw5OUeRlj3QjB36L4mQ2bG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 13 Sep 2026 23:36:44 +0700 Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com> wrote:

> collapse_file() calls page_cache_sync_readahead() to fault in missing
> pages before collapsing them into a THP. That helper takes
> mapping->invalidate_lock itself for the duration of the call, then
> drops it -- but truncate (e.g. ext4_setattr() -> truncate_pagecache())
> takes invalidate_lock and then waits on each page's folio lock while
> holding it. If collapse_file() has already locked one of those folios
> by the time truncate reaches it, and then tries to acquire
> invalidate_lock again (e.g. on the first readahead call, since
> invalidate_lock is not yet held at that point), the two paths can
> deadlock/hang on each other's lock: truncate blocked on the folio lock
> collapse holds, and collapse blocked waiting for invalidate_lock that
> truncate holds.
> 
> Reproducing this over ~150,000 collapse iterations with truncate
> racing concurrently reliably hits hung_task: blocked tasks within
> about 20 seconds on an unpatched kernel.
> 
> Fix it by taking invalidate_lock_shared once for the whole scan, after
> alloc_charge_folio() succeeds and before locking any folio, and using
> page_cache_ra_unbounded() directly in the readahead call site instead
> of page_cache_sync_readahead(), since the latter would try to retake
> the lock we already hold. page_cache_ra_unbounded() does not clamp to
> EOF like the helper it replaces, so clamp the requested range
> explicitly.
> 
> 730633f0b7f9 added invalidate_lock acquisition around readahead but
> missed collapse_file(), which already locks pages while calling
> readahead; later filesystem conversions made the deadlock reachable by
> taking invalidate_lock before waiting on page locks during truncate.
> 
> Reported-by: syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
> Fixes: 730633f0b7f9 ("mm: Protect operations adding pages to page cache with invalidate_lock")

(You forgot to cc the original author)

Five years.  

I wonder why this hasn't been discovered by lockdep, AI, syzbot or any
other of the tools we've been using for so long.

Thanks for doing all this.

> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2257,6 +2257,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	enum scan_result result = SCAN_SUCCEED;
>  	int nr_none = 0;
>  	bool is_shmem = shmem_file(file);
> +	bool need_unlock = false;
>  
>  	/*
>  	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem
> @@ -2271,6 +2272,15 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	if (result != SCAN_SUCCEED)
>  		goto out;
>  
> +	/*
> +	 * Take invalidate_lock before any folio lock: the readahead below
> +	 * needs it, and truncate holds it while waiting on folio locks.
> +	 */
> +	if (!is_shmem) {

Is the shmem special-case a red flag?

Probably this fix an acceptable minimal-thing-for-backporting.

Question for maintainers as well as for yourself: but does this
indicate a need for a more architected redo?


