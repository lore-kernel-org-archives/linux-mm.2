Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D494FC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 00:44:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B91B36B009E; Sun,  5 Jul 2026 20:44:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B42836B009F; Sun,  5 Jul 2026 20:44:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A58F96B00A0; Sun,  5 Jul 2026 20:44:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7E33F6B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:44:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 04576A0232
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 00:44:46 +0000 (UTC)
X-FDA: 84956506614.04.4FC4DBD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 425E5160002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 00:44:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xOP1sBW5;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783298685;
	b=UifMIL5TENuqmAMgPHX0n2k5AvYhXZl/bjcTGKnwCbFb29K4U1ZKWwTGjmgCp0Vl798Nzu
	N+2wo8mYnJpV+EFB2Apj8kvikT2dPE25qtU/nKFE/9tsqUqMVH/0Ka+g0dsNGi+/grXvGi
	8NQy05WZTl2TVUhLmx1V++06LhUfJp4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xOP1sBW5;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783298685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ono3OPczy7q+WvHfQ9YIB/OU9xKW8rPIpMvkdre5TM=;
	b=ghn8eA5XRLKGaKw3KHlkqCzVVjz9GCcbH7VUwxS/BrqnMDZryop+X3Tba0uHqQ6D7TaDMi
	AY/aa1OxfzgAnSSSRZSEWSVwbus/mRLEThtKuUOl9wgEPusDyJZH12fBLP9NA1GBRKQy+K
	JFw0ecmbUrG4CewFomfMIr8EzCr+Qcg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B9D160018;
	Mon,  6 Jul 2026 00:44:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1431F000E9;
	Mon,  6 Jul 2026 00:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783298684;
	bh=8ono3OPczy7q+WvHfQ9YIB/OU9xKW8rPIpMvkdre5TM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=xOP1sBW57M6RvqEa/nwhSk4qzx9lH3puJG8onkI34ewVq80xp+6nyBjyKu30lzAIl
	 0teBCB7x2q4oJcu4Tl+RHNJVfofADhVSc4WBgfx/bNW4WI4nrCi2jkwcRQ8L3zpZOP
	 fDWjtMQCpWCR6equj+C0JT9LkI3AIDj483T8nWYo=
Date: Sun, 5 Jul 2026 17:44:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, jannh@google.com,
 pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: nommu: add sysctl_max_map_count() check for
 do_mmap()
Message-Id: <20260705174443.08a11649b8e1c9e58e8cae22@linux-foundation.org>
In-Reply-To: <m2se5xt1ft.wl-thehajime@gmail.com>
References: <20260702012830.667205-1-thehajime@gmail.com>
	<20260705151512.5edabd9bb5d11cb6f1c6309f@linux-foundation.org>
	<m2se5xt1ft.wl-thehajime@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 425E5160002
X-Stat-Signature: kj4gf7mjumhfqj8zgid6o7hoxugazqkt
X-HE-Tag: 1783298685-144423
X-HE-Meta: U2FsdGVkX18USIzrzL86PLGBvIJo0FDQbVQUkmSTVystLp1gmPlV1o26Y1kdmgOlU2rzM2BE3Ezbl6lwAS0I8k4lrZJNU37DnITBptaJNn83tPpyh20A3NrkABGG/jmUdal9duAiiAfCS2JkddVTIz84v1ycPBkH6mshHiciGhEAuCUmNwO3vFAuECGnWjnIQgdXkCOCT5obhEEx42UIb2CcZ4BwPFY/FgEkkTo0wBn58DcnHeGxi08eSsqHFAC81KcOkPgO2VKbpX0Cb4do9wNkUPVVqbEQWpT3WCL+ISyNOVgwnAnsadu1jPulx8RlsW1xw6rKk3pZ8obvj1oHDUQtvr0r1sevhSWO7Q96/4MjWNJ9fi+oVdO5ZtuW/2JM8IOSyWi91vt7SlOp6FSU5yd1KxIbQ/aIDix4MxlCi5T1tscXiFCwaBGl4IHBB+ZUxQ6jOUiHAKj9ocekITVVnJbS0QpV62LQDarWrHA5Lb9RydyN2HYXsLBbO0TwFcdXRXL+TJhKn9rDf6mZoNGIIWMf/1SKr/au/xNaNYXPXJ6CrcS35j/aCjrWZa/vDSiOAbkTnVHI6FZIpN6jNSaybjAI1LEyddbamMNnG9at9VDc3Tl8yW3P6KCcgB6Tpw9gY7zHtqNvt3OO5jinkSpcJVJ2gNxeBiAEopN4sIDOZBy0HGhk9AeM5PlYYnjEUy4ZeTF8pWu2/SZ06V304FQ/IWYyvFOMu4gdtpJb6Q/avcFrgW5kN6WUOcusqSqh01U7Z+aVIb+jxkNEdqDoqqfL7owO58bjsWZoc1ozJFG0dPClRcvGsUlwPlRkn3x4XbXfa48tpyzngcxY7LJJjTYMmXGRDDZu+kubICKMN4JAGTg7VEJwUqFYhexQ4WqYiTDkclOPaTYBKmc6VCzyCG/BTiVjpeZd9Nbzm8x1mrwG5zv5q31Yj2485aVmAYyOwfwkfZ4l4hpIkjxb7TR0wRi
 kFiu4e+6
 29rnjTa3KxjsFER2Gl54kbS+Y6x81Gyf14UBZslFKInhgVj1M8oNQuBhRiub+cQyokwas97l3cp3a8w4XxbHJ002EUn6/fgNJ+xMj6Fh5lkjfb8EgWF6/OlZZ1uDyYD0OOiHEmWiEn/UT9xOTYuNlGqoy7ixi0d3jjofSUae63Yxne/RLUjY5zr8kzPlOFShGuoL2b0ifWHgn1/Zobc4zFVUx5H/oKYND0irCBZh90NmqBC//rCLzYLS7q8vkLiYw1d7rbhLQuRd+IImxt2PYy6Ayhr2IC+OqUTEiq+3Bi3zlLnB+OtHgPptjsHe/CFx/7PK9bztb7UtBQFyboyGBiX9VQpu8QoCExoBc3U9xdNrvgJ1ojFfXfZ9YZaFS2lHNiXfq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 06 Jul 2026 09:19:02 +0900 Hajime Tazaki <thehajime@gmail.com> wrote:

> 
> On Mon, 06 Jul 2026 07:15:12 +0900,
> Andrew Morton wrote:
> > 
> > On Thu,  2 Jul 2026 10:28:30 +0900 Hajime Tazaki <thehajime@gmail.com> wrote:
> > 
> > > The sysctl variable vm.max_map_count (sysctl_max_map_count) is not
> > > expose under !MMU case but used it wit the default vaule
> > > DEFAULT_MAX_MAP_COUNT as a limit of count.  This is currently used when
> > > a vma entry is split into two chunks (split_vma()) but not used when
> > > allocated (do_mmap()).  As a result, even if users request a large
> > > number of allocate memory, it will keep allocating until OOM happens.
> > > 
> > > This commit introduces a check at the begining of do_mmap in nommu.c to
> > > prevent this situation.
> > > 
> > > This is detected with a LTP (Linux Test Project) test, which linked
> > > below.
> > 
> > AI review flagged a couple of issues in the current code, one quite
> > serious:
> > 
> > https://sashiko.dev/#/patchset/20260702012830.667205-1-thehajime@gmail.com
> 
> I will follow up with another patch for the issue detected here.

Great, thanks.

> btw, I found (and sashiko also detected) several typos for this
> particular patch.  Can I send v2 patch with the additional fix, or do
> you prefer that I'll only send the additional patch ?

Ah.  Well.  Confession.  I actually quietly fed your changelog through
Gemini to fix up a few things, resulting in

: The sysctl variable vm.max_map_count (sysctl_max_map_count) is not exposed
: under !MMU configurations, but its default value (DEFAULT_MAX_MAP_COUNT)
: is still used as a allocation limit.  Currently, this limit is enforced
: when a VMA entry is split into two chunks (split_vma()), but it is not
: checked during initial allocation (do_mmap()).  As a result, if a user
: requests a large number of memory allocations, the system will continue
: allocating until it hits an Out-Of-Memory (OOM) condition.
: 
: This commit introduces a check at the beginning of do_mmap() in nommu.c to
: prevent this situation.
: 
: This issue was detected using the Linux Test Project (LTP) test linked
: below.

I did this "quietly" because it feels a bit rude telling people that
their English isn't great ;)

Lots of non-English speakers appear to be using LLMs on their
changelogs nowadays and as long as they double-check the result, I
think it's working very well!


