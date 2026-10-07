Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8559CA5FFF
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 06:40:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60E3E6B0088; Wed,  7 Oct 2026 02:40:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BF746B008C; Wed,  7 Oct 2026 02:40:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ACF56B0092; Wed,  7 Oct 2026 02:40:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 23E8D6B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 02:40:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8F131120449
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 06:40:20 +0000 (UTC)
X-FDA: 85294881000.09.C83B394
Received: from mta0.migadu.com (out-155.mta0.migadu.com [91.218.175.155])
	by imf16.hostedemail.com (Postfix) with ESMTP id 30747180004
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 06:40:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ot27lTRw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.155 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791355218;
	b=uVnvKjExcsgxw0U8n3GSo3UqBf6x3gGyJezASTFVyJxy47wKFUy0JF+Ieo3kqw6WJR/NNG
	JKqbqM9CvcEkr5w64CNeN09pk173+XL4K0lV7VMIpv1ljP+II1gDlw/Wmm1zHRO/WbpNoZ
	evcPZfXyT4ZfEoGq3U+1wWQ7ncBfsTI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ot27lTRw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.155 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791355218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hMXg57aAgl6g/Q1Nhdv8T99f47TCD6YMcjWTjqANCfU=;
	b=Z7qm1k1dNLfEIYYnL3s208JfdljqMNoyZo7W94tgpnf7Es/vklFbeWbxiWm7AlU5hCyepH
	ZkyusA3CmQWFDt4upsFoqew3FDewlsQrDmwbrRj27f7EcQAG63qgn9k42IJz8XWREaq7rH
	0IiEITstcZxoomK/EUcet+DoC0ZPk/s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=hMXg57aAgl6g/Q1Nhdv8T99f47TCD6YMcjWTjqANCfU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791355215; v=1; x=1791960015;
 b=Ot27lTRwuB2bZPXvafsldv2xH0ZqnCMSZkkXB5kl47EqD8VZKAKjTmdRmA4Od8iNRXvPiE1H
 Gy3dB55TTa7On+KujpcdORUBnWYQxCZnm9PKJG/MMX34JHirmiwbXhrXcaP31uhxGdlQupnKuPT
 RLgM+flc63elXfGDyrelHnBw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 827d5bafe38176b3;
	Wed, 07 Oct 2026 02:14:44 +0000
X-Mizu-Trace-ID: 827d5bafe38176b3
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	liam@infradead.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	david@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	arnd@arndb.de,
	gregkh@linuxfoundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	lance.yang@linux.dev,
	syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com
Subject: Re: [PATCH] drivers/char/mem: mmap readonly MAP_SHARED-/dev/zero correctly
Date: Wed,  7 Oct 2026 10:14:36 +0800
Message-ID: <20261007021436.82381-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260924-fix-dev-zero-readonly-shared-v1-1-153c2111e323@kernel.org>
References: <20260924-fix-dev-zero-readonly-shared-v1-1-153c2111e323@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7z4j49knfas3hkxsdrbuc1dktku8ppys
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 30747180004
X-HE-Tag: 1791355217-408682
X-HE-Meta: U2FsdGVkX19MwSg7JJi0OD5uSXzJ7Mv8EuVI2z2Qso3LLAQe/IKyGvrbrOOl7mq/yg5tFdkkcpCl0TGbgbGuAit6z92Og1vH2NUl0BN2oPERPpzvLXMfTeZBEv6BG9mnRvJnJ66wH5JrpZprRa8jIY+wFK+WWThgB6uAwWolCeOIIymIzYeG29P+Sp4VZiUGSM/wB6sZJJHC84Biev3LazRgevePdQ3+kQ4XOjnhm2kT85XBFS8qvSVeXRpk5vvzUJDH5E88OAusyyBSNDWq/DnuUTETdMvkgGh3T1OJNUrIKdHr4Ss6RlWtnK3T3Z+zd78DZEfOCAykCUoTZ8xJZPwh165KSFuGrRnyyshk1eDtG+mam7CDvuMGFRn6fXQQ2UxDd7MTRm6zC222MVyWK6ot/tAahLELC84ukryXmMKn/uXhbIzbjsnznufHo7B0xLm7slQtFfkzA20T7/dT8h+t2HNC6R+id3/LvyI0BwNc/dR7YQnDmRlP4OpcgP30N8na6ZdjAcc322x57qFBJn9ziSAX51cK17ShzI6W/joLLB7s5U+jEMtvMkftjEjHnFyLbEZZ/4qUhxDWEzV/t+MqbvNlzQ47q90OOeE+QASBeP+75ZHoHjIUs0QIC30DynUmEUFKJAaxMmnaM20QY5a2piZZHnvnIfAqYvJQWNS382OZF8W3sdIBIiQtg5L6JUNUqr+mz2LMTR+mmGm+pWuiZ6aFr23s8aQgVZUINxFhHPAwWiEsAwvaBCNLE2upnB0Lf7kX/RzuaU7Sjq/ByAo4r5HHu4UGtpr6v8XqYYXR/UKHdO5SWxiSf6L5wYMRUXeaLoudOkTVnMWbi7GDoobMH6uXQJW9glkrSTsF0a+c6ClLwhsI4Ip4L3h4Zl6D63mI/3vBW3pmJo5QcTbeSyUH/10ZWOqBrOk4KBiQYUbdsAvAo53brZTYMasKjlxuXDfESVAbj54lvhtMvpI
 pMrt9r6l
 0lXSNcWYPQgVB/coerS+4cPgrWUgLEIIJTg1GjW58eSKPEYXep2dOEATmDnGEmMxtn1GTf2LmUB9ufs7xmGE/NMBjOIwFdZedNEYqclIaMvz+7YfS4IMS5yFIs+u6S+hPPt68jlVpOzMHwN6tNuroCPniZSucLOTcxhbubPWEURSPDqh3yNuYp+mzpqnKwC7iAFdFWrvS07puRJxo1izXKzpE/YPGUOidQDir9tr6pm1Q6LvufFBcdx7cE2/ht6q4ZV/gQ+052/TQL2IBtpMAmBEwG/aXBInx2RIsTcoWw7yk596eoEExgyLKdl0OpL6UQ4ouNVvVIg+tHZCbCS8hFy908o3eUZna+Ix9GoTMnorg8ByxRwzNNxXKGsF5ymsYgR0RWMJ3jJfOJp9npVO2nchdjkk4qzq73tGECrjON/1nhdYn2aNtdrbI2nLtymoTtW9y28QxU8a6ZAOeBWasxdEk/hbIG6VBieeArYmQ4rRyXXltZNKnKQi7KaLh2G9LSViiXbqPhcG63dI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Sep 24, 2026 at 03:48:24PM +0100, Lorenzo Stoakes (ARM) wrote:
>Rather surprisingly, opening /dev/zero read-only then mmap()'ing it
>MAP_SHARED gets you true anonymous memory (albeit in a VMA with
>non-NULL vma->vm_file).
>
>This is a by-product of MAP_PRIVATE-/dev/zero being how anonymous memory
>was mapped in Linux's distant past.
>
>It happens because mmap_zero_prepare() gates on VMA_SHARED_BIT and when
>mapping a read-only file MAP_SHARED, do_mmap() clears VMA_SHARED_BIT and
>VMA_MAYWRITE_BIT.
>
>The gating is incorrect - the (poorly named) VMA_MAYSHARE_BIT flag exists
>explicitly to tell you if something was originally mapped MAP_SHARED.
>
>So the fix is simple - gate on this instead.
>
>This isn't exactly a common use case, but it's unexpected behaviour which
>now causes an assert if CONFIG_DEBUG_VM is set.
>
>While this bug has existed since the dawn of time for linux (or at least
>since 2.6.12), it hasn't caused issues in the past, so while it's incorrect
>behaviour, it doesn't seem necessary to backport that far.
>
>The mapping is now accounted at mmap time and can fail with -ENOMEM under
>strict overcommit, and read faults allocate folios. However this is normal
>behaviour for a read-only shmem mapping.
>
>Commit 93c0c8dc87f6 ("mm/rmap: use anon pgoff to track MAP_PRIVATE
>file-backed anon folios") is the first patch at which the debug assert
>fires, so target that instead.
>
>Fixes: 93c0c8dc87f6 ("mm/rmap: use anon pgoff to track MAP_PRIVATE file-backed anon folios")
>Reported-by: syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com
>Closes: https://lore.kernel.org/linux-mm/6ab4ae75.80e1c6cc.1e8e5f.000d.GAE@google.com/
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

