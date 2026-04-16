Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA019F8D765
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 18:56:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E43076B00C0; Thu, 16 Apr 2026 14:56:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF3B46B00C1; Thu, 16 Apr 2026 14:56:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D09DC6B00C2; Thu, 16 Apr 2026 14:56:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BD1EF6B00C0
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:56:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4A52D16098D
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:56:27 +0000 (UTC)
X-FDA: 84665324814.04.CEA000C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id A6EA61A0004
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:56:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mPWqxa6z;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776365785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=igHDUvWpuPA3CJ0qmdL51gGjv8JS17zqgjWar6PctS4=;
	b=N4ucV84BYhK4XOlPpW0XgYcggViSpZo6ALonrt3bh8jP47+vrY7FNdHLkNcEuyeZljNEs7
	ECWhDE7WRr0HeM66uXvvVg/JVdvssHVAYwGeewV3tzLaX5df+eHxcioS/LtUIv15rbLHp2
	LDZF7xQSuMiVvyyxQi+iD7NhIVzQg3o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mPWqxa6z;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776365785; a=rsa-sha256;
	cv=none;
	b=wpPe8WYSnsXv/WOEHmLuF/EQtgS8xjLSSfEykBvkr9zj+TkRaBwXSnum1TRTG6u4xWpaHZ
	MSskcUc0QY/whU7Z0DMBerzs2X6x+/DUM8pLPq8L00MmoYsJH8wFuZzMb+ZZOYNHQ9xL5U
	W2Iy2OjQ1aG9fXwftF4kwRtE7KxZ4Qo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9FB304165A;
	Thu, 16 Apr 2026 18:56:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36227C2BCAF;
	Thu, 16 Apr 2026 18:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776365784;
	bh=7PB2sZPapAgcAUO2mX4Ti0uvTw8JML/xOAAhd79EyPE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mPWqxa6zsjaCrCljJTl+M5Pfc9ek5lJZqoyevDvtoq3cOUYO4GOBQZt870v+D5ksw
	 ahJLWEtNNt22du17mTZV9LoHAvPXrhHzzcLxuemlQ31IsOEBBsNAnwazb4tHijONDH
	 58WLGLrgg8BxusHw0vL5coGv/Zs2qq2lzljX2FdzoKUF0B5128mLRJuxquj0+PrGd3
	 4ZN5MqjRkT9aYKV4lwDtiRW1+ro+0HmU5SNmHs0NAXn9ODB8tSOXWi5SfvCjS0Urjh
	 MPaptaE3DriewkH4aYliuUPzv+eyV82IHb3k3dufAUAOP+MsYq6nAa4tjPKx+tKgUU
	 deaapm856Vdqw==
Date: Thu, 16 Apr 2026 21:56:16 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Aishwarya TCV <aishwarya.tcv@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Specify requirement for
 PROC_MEM_ALWAYS_FORCE=y
Message-ID: <aeEw0Jf1JOCvmdri@kernel.org>
References: <20260416-selftests-mm-proc-mem-always-force-v1-1-3f5865153c67@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416-selftests-mm-proc-mem-always-force-v1-1-3f5865153c67@kernel.org>
X-Stat-Signature: mrz3d5coyp8ui57of5o1cd8rmyidzktw
X-Rspamd-Queue-Id: A6EA61A0004
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776365785-337052
X-HE-Meta: U2FsdGVkX19SRDrwyz5Dffhywskf7r7HfjQMXHPuif5CNY47lSdaPeefDgLq+/1n9NEqcnIVfauVYwr1OyzfxbisW0MIXwmXlcuD3h/vtMi3ahbk9dreHjZOuN6e0KrFGgOqWAya8pBhwIYVpSl5GR7y1xzZjU8fBiItoa8HJD4peWC4YTMDVunLJ276bMlI/pr5T2d4Z419dE+SQcP4qeqJ3aaqYh2yuVShAQFyq2YXmxmRsJGtxwQrPjgO78rhmY2KGDzlM2v+9MIGTLhKA5LmFd9GvDSdSFnrr+JoB845kZGcswktmGVDfkab03tcRHFgu3PLA5FGgEeRj8aW8LAW18oYVVQ/Y/qE8Sin9testWKB82zmJh7ddkcu81VM8c7uCfJWNt1dzZBd3+e1ThnjbgEfZ3xFTn/+AJ5BDxWDXGPKWRCcyib8XrI2fpJUKvK6mZUrwshLeTHArPsCIMu29iXfg09yIGzkEpP6bqS7s/dgVjLG0+DYMfr2DIxRExsZQSKNBhOzQb/N+QFDQS3Va/6z3PylSmswkFu6O37UJTS3B2CM6kLjxdyh+h5Nqoenkp6Nk7YG1quNI7DDNpPN9lFq+XBDOWDqKJnp7Err01euKHhBaoE+T8swpMc7yn1tkfiseV1bXfgYl/rLhNhiPtFOnEVaRsO54P+JMTXk2hGa3MAox55vXKiWzHx2hC2VZBEOwtmQoXAL8zTjiR7yToK4u/wwLyai9pMagSGxeBobuTqjKqe9LRj56zq/F641QDWk5EytpQOScimCwVR9no2TCgjVtWDyr6QvrxP9UEZCadgoDws8V06nHWJGJrfItoV8tUzzl1zF/uCr7XPZMtHRMyE4sYUnteWJieX2GKOTElSfK1hQxupa3QoqBGiGOtbFI7jCqh9ULtsCr1mgq54dizosqwVh/GJQIz9Vl+dxbxGlSkMmCtdgGOenJUDiOiB0XwoqV2ftEUm
 ++P8z7wu
 4ooUobu0yKsCEMzBOqaai+kZ+2jKE0THLkmwQYnFjl8QxiRdf99K0tIlLwOsV/7GNu/vE44zIOAQh49vZ/b3BATBB6iyojaleRqci4HbXDBqcaaau7qXRQUMo3DBA4gBY5daDKB14mFMvC+tsE4g/uOitNcaDrHaDn/79n2iO8y5bcwR/vsnwdRWSUzuuym0W1Bf3jwBUp2/u+r8p7UlridWPeGGAQhIgTtdwJVGtzHw5lu9+ixOHSd/pvaOSYKXWLSlqeSO1vJpKRJR3aK5qqnxu3VG0zgp+duFavspTe67xGg+lN97qHY3IEh7Z67+8d8OASiVKazKZHCA9iOzi6PvmUf3I+Yqv9RXPc89fdeTkIUyFGqyBGLfwtkneUw6uOR5I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 07:40:56PM +0100, Mark Brown wrote:
> Several of the mm selftests made use of /proc/pid/mem as part of their
> operation but we do not specify this in the config fragment for them, at
> least mkdirty and ksm_functional_tests have this requirement.
> 
> This has been working fine in practice since PROC_MEM_ALWAYS_FORCE was the
> default setting but commit 599bbba5a36f ("proc: make PROC_MEM_FORCE_PTRACE
> the Kconfig default") that is no longer the case, meaning that tests run
> on kernels built based on defconfigs have started having the new more
> restrictive default and failing. Add PROC_MEM_ALWAYS_FORCE to the config
> fragment for the mm selftests.
> 
> Thanks to Aishwarya TCV for spotting the issue and identifying the commit
> that introduced it.
> 
> Reported-by: Aishwarya TCV <aishwarya.tcv@arm.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  tools/testing/selftests/mm/config | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/mm/config b/tools/testing/selftests/mm/config
> index 1dbe2b4558ab..06f78bd232e2 100644
> --- a/tools/testing/selftests/mm/config
> +++ b/tools/testing/selftests/mm/config
> @@ -13,3 +13,4 @@ CONFIG_PROFILING=y
>  CONFIG_UPROBES=y
>  CONFIG_MEMORY_FAILURE=y
>  CONFIG_HWPOISON_INJECT=m
> +CONFIG_PROC_MEM_ALWAYS_FORCE=y
> 
> ---
> base-commit: 599bbba5a36f6de57ab14c373c25881e2b5273f5
> change-id: 20260416-selftests-mm-proc-mem-always-force-5ce1b26022c2
> 
> Best regards,
> --  
> Mark Brown <broonie@kernel.org>
> 

-- 
Sincerely yours,
Mike.

