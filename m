Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E86ECD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FBBE6B0005; Mon, 18 May 2026 19:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D4746B0088; Mon, 18 May 2026 19:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8101E6B008C; Mon, 18 May 2026 19:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6FD596B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:17:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1C9F31A0A48
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:17:16 +0000 (UTC)
X-FDA: 84782103672.14.DAEBF1F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 72D628000F
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:17:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kLHw4xjo;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779146234; a=rsa-sha256;
	cv=none;
	b=yQappuRkCYO3uCFfIQ1DTMzifdafNxgBnHi/QIQhklqPx0T/9Ap9QEpPHOcWr6fopjqqm4
	wo1aCsNqldJ9IBoZZ+R3Qig7ARsAJ++Yx1pWa7qUSaz+Z675WcBAXulIgni26Po/lpHS3E
	NHipGDDGCU/vkhDrdfUXaAoUs49NgjM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kLHw4xjo;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779146234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3NR2P8wTCJmNFctXRmLF5Et4x3ZIl0ToKkrWypa2eac=;
	b=BBfPOk+Um0dovE8r3s7k7FHa2+NoEkQZ/vAbkHjpGbCuncMqNxVEMFFHslMA8ORz0CwCWP
	hfNRYP4zmZmgWau8VtI3J5cyHY+hT3dHFf9+HQJjLovwPzoFciIubf5lDWbPTMI3S7Z0Ng
	YDWMyIVxhwUofefF50kIKncg0Bh6kvc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D3C53600CB;
	Mon, 18 May 2026 23:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D98C2BCB7;
	Mon, 18 May 2026 23:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779146233;
	bh=LfjxQXsQ3tcPz6MkAwaKoNJ0VzmTQVXgyQEeFsvcg8M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kLHw4xjoWRm/Do7/qKgwnmTiG3OfAulM00ODyxOJQxkZM7OejP8q0McchBsBAutTN
	 abE2X6JkcLGFCmTkd41kPm+CKoToqO1vk+ohbdQDOZgUQlb7WvWr+LN6weNM7uE3p9
	 G4mFB9rnSgOlg3hwJ1MJDsYhpNq4xArVIi1RsX34=
Date: Mon, 18 May 2026 16:17:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alban Crequy <alban.crequy@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Christian Brauner
 <brauner@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Alban
 Crequy <albancrequy@microsoft.com>, Peter Xu <peterx@redhat.com>, Willy
 Tarreau <w@1wt.eu>, linux-kselftest@vger.kernel.org, shuah@kernel.org,
 Usama Arif <usama.arif@linux.dev>, David Laight
 <david.laight.linux@gmail.com>
Subject: Re: [PATCH v4 0/2] mm/process_vm_access: pidfd and nowait support
 for process_vm_readv/writev
Message-Id: <20260518161712.ab28a5cf65764b3538ac9609@linux-foundation.org>
In-Reply-To: <20260515143335.739511-1-alban.crequy@gmail.com>
References: <20260515143335.739511-1-alban.crequy@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: o11kx4ry4y3mm5ows1iziit7uupqqjg3
X-Rspam-User: 
X-Rspamd-Queue-Id: 72D628000F
X-Rspamd-Server: rspam07
X-HE-Tag: 1779146234-967801
X-HE-Meta: U2FsdGVkX18Uqba5YN7e/07+x+pu3KhmiW6XEpSMTdbNU9D2A3sVSYAsgkpXjh/AiwHx2IjsUWn9UPucr8rDAqmGj+SxQv+0ZsuZUelZS4iprs8RO0A1p7rHyQ0923d4vhb9bQYp5F+0nV45uE6bD3mBiTe+3TMetvwSOJeQBGmbpAyy6M60cSpg/zmX0zp+Hlr5pJaZnxB0ut4SJqqjDJ3xghcHk0y3UluQ7+vxJGYeK43/lpn5R8lx2w6cf+rIRibUoTFYKRPVj21uER5w7fG48clN/9dkRGoJ1OEfexRdAh7JjSnl7EAvi1MnFtZST6sV75GIgBrIXYYOLZ21yxDZSSg3EbFOFWdzIFNNEJA3g4lBiXMJ1uRJAGBatHW5QCxJqoOvV0mqSTp5nLs8Orbbf5dXdA2WwkrP1yjRkgG1y87WRiv20lBua362wcYfp2iXATWsXc8AmbabJ8i2LLX7hmuXlqjO0zXd7MD9gG5TuQl4vb61g6b4UsKHVRC8vZ6C3DhrUXGlFbsPZfVX1lw5yTVI3j1kbcB5RaEYqSDzbeFWjPe37BH271d/yAQhgAwkhHLnzuUf9ZyeKCaVuvb0IKSk6OAsJ1q9+Gu78ImCRD9THDTPtjrV5SjxJU0sKI+ctVCGi8hgGnqo8QMShnlo7l9D32JK7BKRvaxiOJwNl7bbxhC8GThxGWuzeXjzardIlWRSTznyqUFMHCqbVQjG+jcxgFjHs1wk1kKE+Rwru675vvcqgRCz8Qr/vYnXubxFF2PmVxoDIqyEIMJM07kIBcil48CcDD6IHvkSULJ7yX8uZ/Xuzz8Z4FoOUzb6kuMntfBkCCyErHH3vOVGCChBQqSFtv9mSXO7J84yJyYRSNJ30QFbz7fSa61qJ6qvcpfrxcCb2q55sx6Qk0c9/RmdkBYPckOoxi9lwHuTUQ5s3/3WB9/PeSCwS2GLbQ18AGMrZdqxTCBamjLfVMf
 J/M6HBgv
 tr5dGth9u4AnWDR9L+lQGuHx16DQkT9rYhjJJ4H44q73UJGutFeT0lIhyQ8de291V39NMjnzJm42DVtxa8Yu0XDAGBQ1Xi/LMuop4WrtJWt+zDk+P4F+x5iME0AHYdcKc0rjbb07whvxVwJ29Ya0+vjsRQTu+aq6uGUPo6mW4SzPWakGiMmjmmQbTEEPjPyjGwjf3TckSHpJu6QmtT48gqJ79W8EheSh2B9iQSWAojF8NMPRmrhhkoh2p9cJRlMCRUK7eV9JWiLVRAXQDuCs3eULP1MgtjwiPb43JooZ1wRqL0eonRWtAG0Oq6M6CWH4GMRNSN5MCH4u1wI/tbKjD+BgfHb31ggD0WN35GeSISkPhK8GSQU5Z1ptK2Tif95vatBxRTTD4MAnbnSOHMwt+xWzkAnTcK2V7HmYXU9MG3AVVf/o9RNqQvSqDY2SElyQXELncxqy2QYGxphcav+HyEL/00osiNY7gYkeS9hxLpr2SCxqoguixvOTJmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 15 May 2026 16:33:33 +0200 Alban Crequy <alban.crequy@gmail.com> wrote:

> This adds two flags to process_vm_readv/writev:
> 
> - PROCESS_VM_PIDFD: refer to the remote process via PID file descriptor
>   instead of PID.
> - PROCESS_VM_NOWAIT: do not block on IO if the memory access causes a
>   page fault.

Thanks, I'll await further reviewer input before doing anything with
this.

> v3: https://lore.kernel.org/lkml/20260428122826.339550-1-alban.crequy@gmail.com/
> v2: https://lore.kernel.org/lkml/20260408145436.843538-1-alban.crequy@gmail.com/
> v1: https://lore.kernel.org/lkml/20251118132348.2415603-1-alban.crequy@gmail.com/
> Sashiko review of v3: https://sashiko.dev/#/patchset/20260428122826.339550-1-alban.crequy@gmail.com
> Sashiko review of v2: https://sashiko.dev/#/patchset/20260408145436.843538-1-alban.crequy@gmail.com

Sashiko found a bunch of new things to say:
	https://sashiko.dev/#/patchset/20260428122826.339550-1-alban.crequy@gmail.com

