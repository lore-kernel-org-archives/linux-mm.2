Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E50BFCA9EC5
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 22:37:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 609396B0088; Sat, 10 Oct 2026 18:37:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BA646B008A; Sat, 10 Oct 2026 18:37:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D27F6B008C; Sat, 10 Oct 2026 18:37:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2ABE36B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 18:37:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 87C618068D
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 22:37:18 +0000 (UTC)
X-FDA: 85308178956.23.9A1B914
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id CB64F180003
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 22:37:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Fq/qR4nj";
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791671836;
	b=KT6DTu3GdbBRHIl2331SeBGVyNZjaQZFbOGdCWuOMnnEeYRkTqm56FvB5pVvFgk/OZbQ6g
	QTdPezdcY6iseFlrPaw+B/QDggv0fqiJ5qJCcrHbvv09/Tb4954wXDIXlVO89QHmsm9UIm
	MyXCG+k+A0upaZbZA/1zEGowz/5G6mk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Fq/qR4nj";
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791671836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F68y83UadITGcYpyHBAEFVCJXmV4RkKPjbHgQ41khuw=;
	b=CdoJQx1C+zpEkCJFM8MoOgZumC0YrBNlHSWk+vG6ZxuP7sye7vG8OpaCgc1WAI1CZyNBRR
	n08yIFzg87VqtB49CkfDYPpoZcu/cj0k2JQdYsRafKPtFyIAlk0Zt+p3CT3ClqGIVyoYJy
	H1vFRpceHqeAJnrCDN6f3VLaCCnMJis=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 29A05600AA;
	Sat, 10 Oct 2026 22:37:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C9F1F000FF;
	Sat, 10 Oct 2026 22:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791671835;
	bh=F68y83UadITGcYpyHBAEFVCJXmV4RkKPjbHgQ41khuw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Fq/qR4njOEsOt6b95HccOD/dyBM+YGPreJy5+PLZjozQsmTx8UJ4N5YJSQi3SXJdX
	 ThoxZk3fp/mmy8AVHIAP4/oeGcHQ+ELd3CmTg4QQpFqC/tbt32RaCJxH7DwjyRGoCW
	 RzAWqoz62TQrfd4qA6gVJ3E8Kpfj/+OSaZ2jVrmI=
Date: Sat, 10 Oct 2026 15:37:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <kees@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Roman
 Gushchin <roman.gushchin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, Pedro Falcato <pfalcato@suse.de>, Kuniyuki Iwashima
 <kuniyu@google.com>, linux-hardening@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 2/8] ipc, msg: Account msg_msg allocations
 with GFP_KERNEL_ACCOUNT again
Message-Id: <20261010153714.b9e91801ea93675da099e903@linux-foundation.org>
In-Reply-To: <202610092010.934197B@keescook>
References: <20261006092030.got.500-kees@kernel.org>
	<20261006092035.166776-2-kees@kernel.org>
	<asjhg2e4-WSeKuXd@thinkpad>
	<202610092010.934197B@keescook>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: y7wjgocrh9et38d91toij3i4sdpn5xnz
X-Rspamd-Queue-Id: CB64F180003
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791671836-976889
X-HE-Meta: U2FsdGVkX1+rEieV/kyfoSwUdXy42SBRId/L6VFnz6WSHUrWTXTwSZUyccASxsKLMajaUQT1/fqvQz375Q3aB3HgM2UelyTyss+Ev1LDLri5j/2l6a7J1WFPrfqVWXnvNzBp104r6aUNDoWz6Hx+PTrAf60C6vebzAuJkdmD8aGu4raGj1/I8mlMh4oiqrHnZUA1xxbvT+UJK2Bpn9OFYEmSV6FFjUJv+zV4o2PXjcvfGWi3AXug6Drq3yAeqAZ0t4NHrYuTKNwKXwWfN//BPQO9vZDfj1EnYqjEY4OVUurSPhstt5JrrNcjPXv9OCeYb7ecKfKXy+xCxpPUmeoQ2s+7c+HBr08gP6aT5zQh6S4oly3IWGwhV/LRWx7Bi8bmPHuUDve5yLeJG9XU0nDDmn1UONVMbidigPsjZWB6wq7Sd+pOExfvZRoDw6sszOx3dF42OWlQBl2OIsZSGMlqGp8cVQDUEs+AtI8DKxdHX7LFGG0jnk15tctePIXBdFR9OhU5GOnv4ksfROHycaUkUeZ9ZTMxFDGEJvcT3zw24gtVJRBJ8qbIYq4uRTcG8fNZFsF8NL97cj/TP+Jhj3EJoOZFtkzISLXw0qsOHL3hsNqZ/FzF98MPPXZiy8VlT8QOWiVrJ60fk1qn69beipmfyGW7L5s/U481JFT5Y/uHBkQ9L6tGL69NU9qR3Vn6VQLzA+TitFXaNFrpbApVXj0+NoGLc8V3WWaOwvWgY3AmYmzdXADJRmrTkeHWI9L36c+7Swei13XD57Nl4eKBJjuPeD3hA5huJnKHRb7A+ch1Y95BtHUEmmzB5uEtHrvuG21M1Et93OAg3wZzGYJG3/1EpH0igBaaBLLTSW9WRb4EjaMe+PUaRSWK0VUXhlQB7SKUMuXY0HJhMg/uwhonxDEeFjNY2vzanFCj7nppSq6bY+aSMAl3XgFZHsgmcxNoAljAI9ZAeFdXlQx3wdVBL2h
 NnhYetQy
 j3jfJLfXC442NKktxosGEznC6KHhEiA4sIMyE1sTeCLaYaouzeK2wtEmVCabDPUJkIfqHDATYWX1YRVQWwMZmYY1AlIehpNJ2BXmlU6dx8AfoWb84z3t5i77a81crWZ42ns+uFWm9gbvcWsqtV6ymuEUlCp253hpYHELkZ0NNd13Su9CJSEfqWqy9eVpSfUwwG1dv3maAltXbrbQyhIGch1ycky9fMsZ0Qp34AkwgBytswmfBaFqIakvXGQ7mnGZU2zHvPtfug1Mce2EwjFs/X+XP1kYrV2R4gARCI3nYz8lXCptBXpmfhXegSHahdYk83GyR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 9 Oct 2026 20:14:20 -0700 Kees Cook <kees@kernel.org> wrote:

> Anything with Fixes: will end up in stable, so I just leave off the
> stable CC these days.

-stable maintainers have been asked to Not Do That for mm patches. 
Other subsystems are doing the same.

I don't know how they determine whether something is an mm patch.  A
patch which covers do-do-that and dont-do-that parts of the tree is
likely to be mishandled.

So yeah, add that cc:stable to reduce the possibility of mistakes.

