Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3913D43363
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 06:30:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 726BB6B0005; Fri, 12 Dec 2025 01:30:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D7986B0006; Fri, 12 Dec 2025 01:30:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ED676B0007; Fri, 12 Dec 2025 01:30:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4722B6B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 01:30:03 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D5F0CC042E
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 06:30:02 +0000 (UTC)
X-FDA: 84209843844.18.A6D198F
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id 07DD6100013
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 06:30:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=qh1LX372;
	spf=none (imf14.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765521001; a=rsa-sha256;
	cv=none;
	b=eeFbEVLSsjXTN0n/pkCqFs1s08iyj9M/Wdgl3io4bipE5vHjQ5v0gvXzfQJqY1Iyx9jz7t
	yqR8LEwbghGdS9iY/JYfQJ8yOOKzFwnEoqAEMZmuCWE3fnC4z7aLyiXj7TQUc4kmRub/IL
	ixouDx/JQ/ylenIX6XZMiL/f4AKEZyo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=qh1LX372;
	spf=none (imf14.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765521001;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K/5oi+83CBKKaWTURWV0mnEWv5TIfLfBd+3xTzWf0Jg=;
	b=KhPTV6apG/Wy9Z07ZB4hXbs4cUODA7WAbUkWoem+R4SMOkP0XxYYOMqGGUUu/rnRVlcdSe
	k1uX2DG2mafsVPD+pV6NnZxSQPRe6O6tD7lrs3kuaKAfOTgTMenH8Qr6kHgDIDNJdZhePj
	cbXPeE349AHk5Pm3InDm8iNvtBOcolE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=K/5oi+83CBKKaWTURWV0mnEWv5TIfLfBd+3xTzWf0Jg=; b=qh1LX372w0ta30pPX89JVFqobP
	O1t2/Y4PZA1ZCLgQnQa4/W37TZW42KS3Jjs7Mm90yoCoMCisImxQYTjXq/fdBtq3n8q0WCoQlHoOn
	Q3JfCaRGMv8x6JwRs1b5xRaGDS9ABdVf980pFA27H0ADCnyvhBkdin8gm1Yl6WcUdU2/zU+gkXDJv
	yma/qp8aj6D2XNJ+ugqhG5AwOOrEH77PCpHxVP+GavJdFKVSZHS79p6cXVwtN5zkHxvOxghkp36zB
	oMdIgMsgJzIl/+RRLdREpDNHUFa49ilJPsRoFLwNiOiQviVdMQtA8Jum9PM+Vjx0EafaxqEl0RKU1
	+iaiEWow==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vTwfa-0000000BlXc-1NdW;
	Fri, 12 Dec 2025 06:30:26 +0000
Date: Fri, 12 Dec 2025 06:30:26 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Hugh Dickins <hughd@google.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: 6.19 tmpfs __d_lookup() lockup
Message-ID: <20251212063026.GF1712166@ZenIV>
References: <47e9d03c-7a50-2c7d-247d-36f95a5329ed@google.com>
 <20251212050225.GD1712166@ZenIV>
 <20251212053452.GE1712166@ZenIV>
 <8ab63110-38b2-2188-91c5-909addfc9b23@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ab63110-38b2-2188-91c5-909addfc9b23@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 07DD6100013
X-Rspamd-Server: rspam04
X-Stat-Signature: 6tws8etihuwnn7thosbpo68fybjj6z8i
X-HE-Tag: 1765521000-467004
X-HE-Meta: U2FsdGVkX1+KtVyMw98CsGA1yB6pjZvjqk5VM2NHFPvtKfkbs9rcj6XUY/4uWwmzNyjBR4nq+gKRp+6ax3Tm7uyqn0flZAGEdcXkR8sESCuIKfJmhLh6HqybossvEIjPCiekvt7NMxDrsA+MWwFhcxesv+5Sgv+DIeYW6acmW3m0RsbTfK3r17ie0LhooNZ9YcUjFJLiTO6gis6rro1uZGip3rSkmB7rhsc4MG8uhlcyltIHTM+NpaMtdFC/gkiTL16q4kzabtV4VoLqgWLK8YIx7lPHCQUklLVKJ2pvdVSH0Dce0cqy5ZwPQsJ/8tOqGZGTEZGnfvtGJoVmOIR8tbVtHI5wy1lysauJm76AD7ZJSUnM6bn4VQV6EYdQFZsBVRiCG8jEeVcG2yRgeHXWQq4CiUJFuZU44SucOXnbWsh53Q27B80JYM+WG/5Dc6KBaX7mHTYsNx7Y6AQf4CmoRALh1R88OtF+Eg7kp0cJS1dqEZkRz29QbmRtjCq+XEnb7wZdfk5FTTcs4s90u6ugRN8Ar281L935stfT8I39puea8ckZYgCo/+4Gwm7PEaxwT25m3vtDcCmb3stLISXaHK9n71uSiYR+RIDZCsWYiCgbWcguBdfwUe6wlYBW/o44zwOxc0+Vu6RqN/muT8a9A+dAPPBg3g/5ckY2MkCFA4CzT+EWMAkDBQzX3lKw5l0YDoYIDMWrw+Fsm2CLYlQQO4wtjVOeJ/vgOjcZgp70d5ehEVzmG8bU68wOvhhGi4mScFCsd+R2+/7suPuUKrF/ObAFVQRkgVd8PUtfK5ZOJNW2Dcf8WpcZcReZ8GFc3O8NyPi0FWoxNO+GNsyM2DQEHUi12iS6l1DO2/gVZt6wVcdBjkZzy12gMnv5/hrDp7cuOshjKir67qObAYRJ40ZXtdIuQeW3yBDZBd6I/YWrEfsNaoKuudKS3FPgPDOxambkAn9QntefakcLkKweQu9
 Ml7jMjwL
 XTa/iqNEwgHJIi1mEwVxTWEvZ7CIt2LNTaj0XyQJAvo1Kk83QhUSU4EEgliOqvoe+8bL6Iw3yK8yGOG0BKpgTjdZK1ciHRvATMeQZfa0Jo5+tzqzcuXptQpJKYnQ5avdX/6sMZ0XbWiXDPro7zIqBQlT107PVg9cAvzQonnExySVy7n+COFfTkFuzeWNLALPuLNZNJFx5EK/60z+HGlYdwefY8Y5oBrj9n95E/6ya/MGE48c2u35LvnrYSaPfTrovP3CADpuwwN2c6Grk4KLFh3xeVN3WgyniWSednIz4UmpgcOLt4PK9D9trCr9rbRWH+5GnMPbOM63fIJtGnWhDSHCOSrhQDDZWS8/uyWgXRKAkeyUzPQxdQZlWRRD950DbMWRzcb/KwAlMFeN4JhvbunymaL0LCwD8PDdK7E5dGhAZg77DR5pmtWbTrIMTNH9DIz5rgkRnkqdvz/eATBJrkohM+TCIn1NbTyaRbs+5QkeQiqk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 11, 2025 at 09:57:15PM -0800, Hugh Dickins wrote:

> No, sad to say, CONFIG_UNICODE is not set.
> 
> (I see why you're asking, I did notice from the diff that the
> case-folding stuff in shmem.c used to do something different but
> now the same in several places; but the case-folding people will
> have to look out for themselves, it's beyond me.)
> 
> (And yes, I was being stupid in my previous response: once I looked
> at how simple d_in_lookup() is, I understood your "hitting"; but at
> least I gave the right answer, no, that warning does not show up.)

A few more things to check:

1) do we, by any chance, ever see dentry_free() called with
dentry->d_flags & DCACHE_PERSISTENT?

2) does d_make_persistent() ever call __d_rehash() when called with
dentry->d_sb->s_magic == TMPFS_MAGIC?

3) is shmem_whiteout() ever called?  If that's the case, could you try
to remove that d_rehash() call in it and see what happens?  Because
that's another place where shmem is playing odd games...

