Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 235F4C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 16:49:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E585B6B0105; Fri, 26 Jun 2026 12:49:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E08FF6B0106; Fri, 26 Jun 2026 12:49:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF9436B0107; Fri, 26 Jun 2026 12:49:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A40E96B0105
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:49:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 16E16A0507
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:49:42 +0000 (UTC)
X-FDA: 84922650204.17.834962B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6AD0D40007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:49:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=n1iuLFxp;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782492580;
	b=mViiawSpUB4r2ICskkE1CTBdrGsyaWfRddHFVGtIMB4xz7UEVnvllpU4lsmooQvnA/zvFa
	hUHYAsh5SfFyrNMXEvScyxjFF1gkxVyFrtN+w+Pl5bWPsByqaFpeE+E6vifIerVYb5eumw
	VawzVKtnqp/U+tlhJGig34ga2fcUQfM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782492580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LHtnHVcHvaGJI0X6HGdEp2HjguFCMl0poNtw25Olve4=;
	b=dsEoWbf3KKvPwRTihYGwktSDMIl9ynSuZauXCwW4WDsPtKhck87zA1TUchoEKlnrb61lhU
	lk+muTZvsMRRkT/b4Gjoh8FauKdSB9ao587qzSdunBcvVyLlHLKJcpaf1BtWbNd6+m7SoB
	YEzfy0zsOe6tbIU/IyZDx2YekCp/700=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=n1iuLFxp;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A40340C0B;
	Fri, 26 Jun 2026 16:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E5C1F000E9;
	Fri, 26 Jun 2026 16:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782492579;
	bh=LHtnHVcHvaGJI0X6HGdEp2HjguFCMl0poNtw25Olve4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=n1iuLFxpMtpGE5mv8i8CbeL0peisfF6NQmwEapcRmoyn0NuxB0bkwUhVHqK4zw0Kc
	 kzDG9Vks90pZFG9J/viaaKHaR+dB7b4qEEs7jEbvnxYjofzrjzupYGHE8osL4cs5UY
	 RBzWLiqn1cUux1NGfJd6Wio3AfOhlTwQjtlAH8nA=
Date: Fri, 26 Jun 2026 09:49:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>, Vlastimil Babka
 <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl
 <aliceryhl@google.com>, linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: fix CONFIG_STACK_GROWSUP typo in
 tools/testing/vma/include/dup.h
Message-Id: <20260626094938.a28667d2aa090fdb6ad204aa@linux-foundation.org>
In-Reply-To: <aj5qnsGDPC3nREdT@lucifer>
References: <20260611012258.432043-1-enelsonmoore@gmail.com>
	<aj5qnsGDPC3nREdT@lucifer>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6AD0D40007
X-Stat-Signature: 5dz6dsh6whiusy5urwrpqyi6k1e3fb8f
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782492580-901139
X-HE-Meta: U2FsdGVkX18fOSRnyU7Ua6Pccgi7QEOnRE4iZjb5SOJysT+yghQ1d4pLeuP46Rhr1InzvaEtcuiZiQK9/u01sZJYGt1PNvBH54k4Ycw5wHoMMAZNj+Esw3dGZWYTMzava36mcvRpm/NkV6SRVTnnj5i0PqRBXEghjOp87rDZbV1rldR0SDLTmGAN5Q04IbPNZf+910JPGmBmIbHUu4BLTywMNY2K7TXF7zLs+40N6fluMJ5Adem6a/Deltbfyn4t98v1kkvE8gp3DgJy9AZRnxlAs3XvII5K92lhK6jXCseegASuIxVjdwZ2AUiWgFwyFzoFqdb0NYXz5t3IDYh1JqU6v6aw6rxdr6umawUqz89zGMqQhjmgQ8YIG52g4aq6dMWMsWFgC7xoaOm2elDQSfCnS2+7gdhxauNFJm6GIDC2axSwO3v6vRhk9Px4/XHi0NmmPiBlAMJnp65ub8Dlt3PAzrzl6BeetCC5SonGAcEv6/uANV9mBeG4HBvfsGLwTgQx/4xQi/GJX+2Mrxl2srIMpbb7a+C1ORceoyvcJHSaRgnhGw/zWB2ba1IKS3m9HoRfGTYnCix4fXbDnlzOcQ2muorgL5s/AFLP0cCE3jJrGfpnzl29esO+eflvj7RfzzZteP8vAB8UkcxOcOd4vSTi8+L2gQGTEE4k8hLZHs7w1ipFaphdL+uwEGTWieX34cCi92oVLqud8PFL8o3VDtIL3c4lBGL7VpVoP47lDLexEHU8WFCL6DRlQIcdxc+rBvISdh6TrpaG7Dg6Q3FiZgg1UymVjO2LVgaVsfpsbZdoPG3aaNdxRjJZpZiHnQMuAjdNd/IwL9eQEXQo7PhlmCFMcbaCs9liERZ/JrXgXitWDUEuxJZLUEHUIOEUo/9zjToZ/ut5YZ8JqkT4JnS/cMUL1YYIq/p8hPPKgPF2MgwS/s8HUCnR+fTKyDielkvz0NwG2NDrUK55RzuVtXF
 TOVPo6Gl
 mMzfzWRZr3tAy4GS9C++kTXA/sibCXTVwoH4/uiREnj4BfXnGnY9Y7x6d5HiuMmKkq6EE5QN8GB4a87zZplxBi171dD/AOC1Tq7zss5eL2PlmwvyN7bQ6MsWnsU/qrHZIy0CJEj6vhHoOK38XwBZt7jB1yKEBa8KQmdNUKhWnxALwD551HPA564wJxqr0sB/MIqGCHC7F0adPF5u+nL4X85NPvviyZnmA7ANdg+SK0CGRWZroIraENRDDQ36jUtjhYkjS/oqvX/UZc0BImrdgT7HxidTHzIsZCTGVw+wpDNFh8J3mUa5mLWLCM4O/nKiCgkUjRXeH+O5lj/LWLl6IMH9yIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Jun 2026 13:06:23 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:

> So drop both Fixes, and the Cc: stable please as per David (Andrew - can
> you make that change? Thanks!)

Done, thanks.



