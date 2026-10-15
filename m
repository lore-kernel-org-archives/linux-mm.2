Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0351BCC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 09:20:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1CF46B008C; Thu, 15 Oct 2026 05:20:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCEE76B0092; Thu, 15 Oct 2026 05:20:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0B986B0095; Thu, 15 Oct 2026 05:20:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B5916B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 05:20:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 12B831C4351
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:20:07 +0000 (UTC)
X-FDA: 85324314054.12.D4D31C3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 77B3A1A0003
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:20:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ee8GqM5Q;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792056005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jWjMbMJOkJlVwkNWl6sXzkpalYbjUF5GANsswwBKBBE=;
	b=wKFG56Po6hDmZ1eN0Nl2+3ZnjH4vbcNrKIKmfSzmJslO71ZBwsM4YXthHSOC3SdX76gaOq
	nY/sC03JjZWD3zATsgvDiEfeHsKUL3Vj/mtnuR48q302lE0W/5rIUASJ1NufQKmaBclcAu
	ADIsipxWDy+FxLGi7saMwno/b+QQBaU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ee8GqM5Q;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792056005;
	b=d4hq9usbEzLK+njSeB//WShan9Ptoj2pVKHrErWLxzMuHkKluTrhcTJLueTZGwN4YN3z8D
	RkKVduVZLkdZ2klhBe+Z9/vbq6hdDHvSjxgStVe42x7xNOJBhw/GcWKe7aJRjZtEPE98uT
	t9m1bnB+3Es0zVq8IG0mSBqHU1YW3sI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 061366022A;
	Thu, 15 Oct 2026 09:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8431F000C4;
	Thu, 15 Oct 2026 09:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792056004;
	bh=jWjMbMJOkJlVwkNWl6sXzkpalYbjUF5GANsswwBKBBE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ee8GqM5Q8ed1YdkRKIdgL5TdxLdgu5NjTIu/9H/2bHGSpU79fcQV+K4dQcuP5UxEZ
	 Sp7QhHmQwTXdL/rbynzwN2rhmVGnmHYCOo99YQuHiBBXqIUmLYbySXD1/UXocCKmsV
	 AFOexAFfDmwiKXLVEFjhX9XgHF16YCHqHYV9CVnO4jsybDzVbZ4tAzEPmc76QnGf5T
	 t/rJTzxXn8AQHwQ/kB5s+fCa0n9FJrCUifhB71/YYBzZh9On3dqP0BiYesp9/wihg9
	 sdFWaGY9/iCUGLVsCqBBAVks+PugGBX7i21WbrN6bcG9ZEPJ4cC4CuiVexY2wfpqIs
	 /Cabgy2U9Y/7w==
Date: Thu, 15 Oct 2026 10:19:55 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nimrod Oren <noren@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Laight <david.laight.linux@gmail.com>, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: stop recalculating min_free_kbytes once set by
 userspace
Message-ID: <atCYukfCn8TOgM7S@gremlin>
References: <20261014140859.1006967-1-noren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014140859.1006967-1-noren@nvidia.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 77B3A1A0003
X-Rspam-User: 
X-Stat-Signature: 46yugzgcs9qwuqkczcf9ox4d31wfrjxb
X-HE-Tag: 1792056005-794310
X-HE-Meta: U2FsdGVkX19SuhZll7Gg2Dv8sBhxVtg+aW9qkKN2SkwsYGAlMCkllf1HZuvtUAZ5LGMM7Yw2yl4sBiwJxY2l3m9Ae98fxjafxfT8CZVGp7HY6ZsBFaRMPQEkXEvqbS4I90KhSdAChOKXVMcO85fl899QKt8U2n619WNQYmX0/l0Grly1JFFIz1zEl60jrAN7fwnEFPOrI5lD7IYKRU98QjOsKJuUC5ApoDAR+UnNMnlqbRrS60DfhUeltH3Jumi8DV+vwHbB0CEQBjKJP4bDMsGXxOLRtiEA7V/eGt98JRwxATAevv15WXX3Ejs95sXW+lG+O/Q1AN6kSPaKJmovXcsIkFf+S+/h/fgolGt+ma6ZtJk/ss6Ot2bsOgPaYh4dBK/KsMsco6e5VFzm0/Kt//Aij3rcrdbX+uU0mIx9VSWIPeTT9Y51v3uUpj3X5j5JKSqgxnV5fun67EoiCoZuG1OvTpcSFnuIvo/tBeHOfJ4CoyVQon2L1IfvfdBuB90zCqyuz2gaTSpLe3XjsnnbZAbhDQN5+Lx5UQUD+DsABySZzAJBUiB9hJ4N8LWraWYeZBhXn9ZrqgM+14p3C3bKpA4zBgHGLXA32nC99hMtt+o+Uso7uaDAKMwgQi8nrpBSoQs+XcvwXAFwq5WUyHuI9jyQEjcPK706ETKK0vxvrPRuKUtoPzQdwp7BPrhfqTNJpiixXwDrw49xv+NtYNPqgvBJK46lOdyC+L1Xj9swgdZSQRAUbQZJ0wI3Bt3JcpJD/9MtZ/1+hQ4Is5u6zLguuM6S0gODwAsVmKJmXZ05zlvopa7UCR34Hy5Da34LtNSUPEwP4IvT+9GGjjK2AaX0iqFD8QCepmg5Bs7ds7rf2R5pbwqdb2Lx8Pol1/yc1R45VlEicz4YDmkXe48C2QmckCkW900rCuMq/8Y+WGWKYU2FTJCVeGHXWpuIFuE2ZQSXs/TzkWEpUPxqblzHqsJ
 xmIdnHSX
 D46UeLPRweFk8tRf4ar1kiA6sHRCthP+dft6Hj7DK9ZG/Vywk7/z6ubKUCE8QIrQUPt5yHY1aVNPCMbdFX1k10Ns2gbgo7FJkWFbMUgLKXvVKeThEAu2RCr6lzt4rNibxywQDXeBZdNo9x9ZMhKmqhhKeCtGAWQX73DeOMvpexKY2Omw49SrcnU1TCZa8IxEi1D6+F3TeTHiRBWDDfwyo8xN8tSNrQryKoj0VifGZDmoUq/JXAoZpYzv9dj9i/J7MLoqhbRPD+4EQLn3z/pWhB9oc2fGIoC6GMxB1bMdrKRSQICG+6GS3bqTPK4cIJxQfJMQhUcRa2YVeMjsH+2PBp0orjrPGCrGiXdxvNAABdxKH5ChXiSHWrOkZsfi1TQjTnYLPYb4mE//35Or/vE5SDq9EovbwKOzLR5JmGhOvfIwSE98=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 05:08:59PM +0300, Nimrod Oren wrote:
> min_free_kbytes is recalculated on memory hotplug and on THP sysfs
> writes. The new value comes from calculate_min_free_kbytes() or, while
> THP is enabled, from set_recommended_min_free_kbytes(). A value written
> to the vm.min_free_kbytes sysctl is replaced whenever the new value is
> higher, so a lower value does not stick. This matters most when THP is
> enabled on configurations with large pageblocks, where the new value
> can be excessive [1].
>
> Stop recalculating min_free_kbytes once a value has been written to the
> sysctl. Systems where the sysctl is never written keep the current
> behavior.
>
> Link: https://lore.kernel.org/r/20260716173504.760369-1-noren@nvidia.com/ [1]
> Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Link: https://lore.kernel.org/r/d202dcc3-d7d7-4e98-a9a5-3137cfbfd041@kernel.org/
> Signed-off-by: Nimrod Oren <noren@nvidia.com>

With an added, focused, paragraph about user-visible effects as requested
by Andrew (you can probably just reply to Andrew with something and he can
fold it in for you), LGTM and:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Thanks for sticking with this! :)

> diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
> index 5b318d17aa4b..189fc57dac5f 100644
> --- a/Documentation/admin-guide/sysctl/vm.rst
> +++ b/Documentation/admin-guide/sysctl/vm.rst

> +By default, the kernel sets this value based on the amount of lowmem
> +and recalculates it on memory hotplug.  When Transparent Hugepage (THP)
> +support is enabled through global or per-size controls, the kernel may
> +also raise it to help keep pageblocks free and reduce fragmentation for
> +THP allocations.  Once a value is written to this file, the kernel no
> +longer adjusts it automatically.
> +

Ah nice to update this also!

--
Cheers, Lorenzo

