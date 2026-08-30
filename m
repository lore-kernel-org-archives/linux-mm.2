Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F231C61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 03:06:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D19806B0088; Sat, 29 Aug 2026 23:06:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCAC36B008A; Sat, 29 Aug 2026 23:06:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE0166B008C; Sat, 29 Aug 2026 23:06:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0076B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 23:06:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1E7E51C115B
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:06:23 +0000 (UTC)
X-FDA: 85156447446.13.59BCCF8
Received: from mta0.migadu.com (out-249.mta0.migadu.com [91.218.175.249])
	by imf17.hostedemail.com (Postfix) with ESMTP id F184740002
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:06:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pm46zNl3;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.249 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788059181;
	b=N7mCDwzxtOxtKbese86vK+JMyCmNTwk6AZjHWUnlMN2pNpZL8jNW9jlb/gbxuzNBp64ypw
	WBJmiq8WDrJGHxH8ut074D+7ieToTXIRBqaD9wXvTy7QksrfQO6+LssBsmXX0SK92YT9lR
	rvnu3PnrnScGl/Iup/t7qBxwDdwULDw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pm46zNl3;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.249 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788059181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YPtFhA9cBK59YaKLNjdewaJ1q0Nop+upG85M+608ROw=;
	b=CAx43/0ueqjth4taLcNvMlTmSMyuDn/istiPLpF8n9El+K4BneF4jr+FlT3E7caEJxj6FT
	I0fZFYk4Wi/qqRz2xvYrmsF/isfbeYJHu7+ZtiWHEZxEoJjq9aQBSjUrzuBz6JipvpJJ0R
	DuFeH2+g7mgDnxIBzvThBM03LtL0LxI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=qXVdb+IqU2kIMGpTuiVRCYml0ZcRQXM5yPEGZHiM3xg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788059179; v=1; x=1788663979;
 b=pm46zNl3xIZkfZM/IhrNnf/xOvGCe2l+WHpDZYZU/siwYNPDgphRTDZzu4xSxYi4T0RPNrNi
 4iZnXwstTANlXlDFhwvdWa1xvA9gazF/sH0xQv+1F1tvKd5FFq4eNoN9lByRXqwuXA339I2UwEi
 CcpEMcnq4ngr3pcwFcpjLDk8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3cf237b371277dd9;
	Sun, 30 Aug 2026 03:06:09 +0000
X-Mizu-Trace-ID: 3cf237b371277dd9
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: trintaeoitogc@gmail.com
Cc: willy@infradead.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	riel@surriel.com,
	rppt@kernel.org,
	surenb@google.com,
	syzbot+395b7abe9696862fc188@syzkaller.appspotmail.com,
	vbabka@kernel.org
Subject: Re: [PATCH] mm: fix the race on huge alloc failed
Date: Sun, 30 Aug 2026 11:06:01 +0800
Message-Id: <20260830030601.90899-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260829180234.435064-1-trintaeoitogc@gmail.com>
References: <20260829180234.435064-1-trintaeoitogc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: i4mxm8rcpqrb6gy47g6xeyqowryuu8ad
X-Rspamd-Queue-Id: F184740002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788059180-521678
X-HE-Meta: U2FsdGVkX18GMdxqcL8piyWHyTlAH+oDr9HUCriQy52rvNWp1o4thHDkmWNxNGlMdQcsyLcEC/qoZ8WudE45+y8F4hzQNnotnl0WCaRCAtm7whjiDDLDkWr+za7w/TdVLZlQJnrT/6NqdVFzdDQiWHYcwYz9yj7gUh4SLmTYOjvU7kJWB1nnOGlhNKdw77xUEg7eBqcCiECCyaQQagYdedKVxky8gYlFoPb954krvg5YrxcL9NEI0Oiv3JpJ9/3BzEHu80XQ2djZVhcw4ZAloPHZceeCN7/c8e4agNlz2zvvs1IMoxggfs0HnzE46VYSDtGGcLTYFpNRRhBhxYkzWgXkqrgWFLTBj0kGTuj5+RLKywo0q4g77WoLu0xYga5HhzwYpHjqZRqrxeOo+aqBEIdy4ZJfPqLaOJlDFX8vY7CFnLi8JG1wRara2H/LLg9Qkkgei9hB8D9IJ9BjTuoKzkgMmSlB/kk/30JjhlxdY4IJTkzPh75yQnM9hyXJXI+bn7CQftowyBHjf261c4fyrmJ6IDklriUCQqxEkrun7SAP4TNbIZlSsR/oV6MxeiANqiA1bgil6i8Bd+U2cb15CBU1RFBm0c8KQKRCrwKqEPffp65s/3UhBeTDODdjRD16Z8vxlXXmajDSA3XfT7EXNXDunnyQd3V4VAK+LfZfaJ6y7vUUaFbqwebJV8smDwTYWCu0OD7svL8Do4lfvfYCcAmxM69Qe7F1q5hwHWu5SkngXopvlUUUaSa8+Q15gQjovAQlFcg55BOFvYUbTqRv9Xf9bdawTGsDXKjT1kKxA5aIUE6O5Td83DKEsFnKRev/ewqhvBGb9b9Nhiv54G5Jme4Zca8eVpqLt6faVxV3OY9E5cztC0ISkpvfs4pQltVfrOgffRR9hit2ikrfi+U9B/ooOPLdmjjIofQhNXmV4MhhA9MG0toO+tGOfBySDYKzLUlu1ueRtI2cpznw/Vh
 FtpBYkeU
 o5vayNPADGxHOexSFlbO7Sql2M0xYsBtV8Uqvl8DGoKIJYQ1eojuUFfglgczYMcYt6QT0Jfae49Otbsd8hDJHY918DCVsx/rt8E4thbnX6tE2/yVqKeN7Wm1Qezj0axEkiJZnZyYAR2VUgRY0C+R9888VrrrxfQaO1R7CUeajfa+ZHJ5T7xqFpRJW8tRAs7bB27O1Hwg0zlv27IAlTbZOTZaHbFIqPWOhTokeXEj6pjMnCecVMmrQQ1hX0nDqpncqI7RNTgBK+3t7ZqXcM/S9EAeiSTsUZYOYmOGB3LCLXwQmvASc8dL/CATS8kI6GbVbLfNNNmdNHC3yq4mPlnl85TnX4apfhx/i3ELcrdYqIIlfE4yXmCxkJF6YAP9wCRq0za7oxoYtH149NWBiFlqiIGpVtOIPP4znFb9Y1CuOyRj1n6MXI2wo/3xJ2MkB7GffvBa9el3m/975/eM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Sat, Aug 29, 2026 at 03:02:34PM -0300, Guilherme Giacomo Simoes wrote:
>Matthew Wilcox <willy@infradead.org> wrotes:
>>> Fixes: 164b06f238b9 ("mm: call wp_page_copy() under the VMA lock")
>>
>> what makes you think this is the right commit for fixes?
>Maybe I would should analyzed this better. I only seed the commit that introduce
>this function (and consequently this reader)
>
>>> The race occurs because the reader (__vmf_anon_prepare()) checks
>>> `vma->anon->vma` without holding the mmap_lock and withou the
>>> READ_ONCE() macro. Since the writer (__anon_vma_prepare()) is holding the
>>> mmap_lock and updating the pointer, it creates a data race as the two
>>> access are not properly synchronized.
>>
>> also this explanation is bogus.  i don't have time to fix it right now.
>Hmm... I would like to say that the reader (__vmf_anon_prepare) access the same
>data that the writer (__anon_vma_prepare()), lead to a race condition problem.
>
>When the huge page alloc failed, the asm_exc_page_fault interrupt is fired but
>on the same time the procces that was trying to alloc the huge page, try handle
>to this failed too..
>
>How READ_ONCE() and WRITE_ONCE() is atomic, the race problem can be resolved.

This patch should make KCSAN happy, IIUC, BUT ...

Still, the subject and changelog are rather confusing. The race is on
vma->anon_vma, not on a failed huge page allocation. READ_ONCE() and
WRITE_ONCE() do not stop the two faults from racing. They just tell
KCSAN that these concurrent accesses are intentional ... no?

Cheers, Lance

