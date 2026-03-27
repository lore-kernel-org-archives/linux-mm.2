Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E69110BA435
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 07:46:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B42CB6B0092; Fri, 27 Mar 2026 03:46:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1A366B0095; Fri, 27 Mar 2026 03:46:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A56FE6B0098; Fri, 27 Mar 2026 03:46:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9373C6B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:46:13 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 50C67E1607
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:46:13 +0000 (UTC)
X-FDA: 84591059826.19.082C552
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id AD7D920009
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:46:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RoYYMi8y;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774597571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q4YU8O1ExTdmDS3DrhaG2lsCSxEM4HYAYP6drlYe2TE=;
	b=BZQ/ac+9wJxLRhSyNNqmHCfJ/XQq3TlHI2qFW6OJRJSUOCUV7uXTepsMDCPFVTlnGbdwPQ
	95APM2XSLAsSTkn9isVCQuGMc+gdf72WpjfL7UqDeD4jA0NutBzPD4iYuz9+sNvD3z4wTF
	tZe9oaN0G8BA+79j0X53XIdivU4fhn0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RoYYMi8y;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774597571; a=rsa-sha256;
	cv=none;
	b=sIkHhloN1ESotgxJ65jXApSq+ntyTKZlkbFY8C58ZED6NWluPz4ZaKj6evpvgESnmyoww3
	S6vZmCj0Ugx6fTjP2a1EhhK/AGOCikN6GwxyL2C4hmYZY9xhBWlCn+FQqI9YF1N4l0tjvd
	hBczbkafZ9hkAfUWkANag+p1d0RLQo0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 830D6406CE;
	Fri, 27 Mar 2026 07:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21247C19423;
	Fri, 27 Mar 2026 07:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774597570;
	bh=eAEV6jkSinDBHX+g/clp3faniKXzvRJy9kbUgZA9FYU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RoYYMi8yUVIC6LABKdz3pZSOFlH7vKHjWuAzDmYtIAEtwsmXnmnFpjCd8kfwiJytN
	 Yg9AQsASr8iS2v7eKjKFJ/PmbgrP0wCGmjMTh2rDHikOKg9XlKrV80aMT8KV9qIVos
	 b/AGqUX/6Gj3nvyE3iuxv44oLw802LOad1epym3BeDL0xS4+m8BXH2z0XI2JrdGQ6U
	 OClGvfduAlQBAsGY89etD+SjLcb9vZ3StCJc2yvfNStA99kxD+SgHViiR0HOkuozmF
	 Yf12ZNT7RGzAVubbu6NPP9brH1WBMjvsE2zGceo+foOIOfft8CtA2OH4TrKb9X5wLO
	 XMjT6RvTI3B2Q==
Date: Fri, 27 Mar 2026 07:46:03 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev
Subject: Re: [PATCH v6 4/6] selftests/mm/vm_util: robust write_file()
Message-ID: <c87111e3-5cbe-487c-90b9-78d22a3f7a24@lucifer.local>
References: <20260324013316.2590422-1-chuhu@redhat.com>
 <20260324013316.2590422-5-chuhu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324013316.2590422-5-chuhu@redhat.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AD7D920009
X-Stat-Signature: peow6toibs5ycn84h7iu9g7krzzuoim9
X-Rspam-User: 
X-HE-Tag: 1774597571-72223
X-HE-Meta: U2FsdGVkX1/bvfNheq0J7yoLrtWU76loqw2Zpa9pSjlAVKsAJVc2CWi1kcFcG7leLUxo227QwIDzOqSuDAI/mwiCfLbBAm786Mi9NjC20lBiNuyaH52eHXEWigummOedEpKhoIo8vsOoOMow/x0YxGCCigQYw3RPML6g3dedXT9nJNgCVyHkMQXPbUjoO1PMgykqi7Jgv+un1lQpTugtyYis8dCoHNELAyGvboSuXteohQTB+jWDILEN2Hk+bPNpqO20u/6okJ2r+XAO3mPCig5E4XkH9a5LOyleU+0czGUqYDy8c7QtgRAdvmZDMw8U0fjrKOMuSXzsyVDXKf7fF7BN0AQpiOPlIsya4c14/T1y+8TSDXSuStpYfCFKhf68p5y1urcAzpBV0az3J03ex4t9grYlX04nIJSc0G5RVGhaU7yii+pOWJSywCsTUVYb43W0I9Eb2ucltyLYkrFNwHG31yp7FMM55J9j0rYP+9B/pQylVrWDUbKDZyfjskNHtylgoo1IDnxxjRvm9wC7zED3+CiC99JbNLUQ8bfWEZN9iRbw56VfdlZ4AgXjRk7n5JsR/VyNPJjAgDcudXXVj7GolwRD950H6WdCEFCAJ095z4nlBqji8ry/3GxtuF0pzpcPfDjuD2yNLjyi004scADXraPUaowOwkb0wV4FPgDUiLzW/T2ckwdhZt5JOkRT3ZnfzST8EHekxJSUTvT3g66TmzbyovHhUieu91BFJ0vWj0thWP3YIR7WZJi7AOS7X/6bwvx0SKlfa4LdH9XKC7fOcz8gof2T8q/SkxAq32vmpDpo5xDkcXWj6i4GwfV0tfJFby+huMf1TueQm9edGWAAwMjMxmkNdebqOTzznGrb/PiDTnwNRni1+JbgIVbrBOWRU+Ptm/ZDeY6+wa0QIahhifyrvSDI1sP1P5hrGOWjfRUqTvJ3xeBIPeCUWfcja+KF03tAmoqQZIgenL3
 Ig/rBqWM
 AcS6ml83afwz8COSXPx+CXf8Ew3axgX6MzM59BdHeYiw+y50IsDD8bY0il3PLGQBq4hqcy8B3kDf3YitQWK218F78ZiDyEzRefaD9W8x5zzOJW0Rv+z8OZeltHbt0jV7dTvzebvQUaGIfPA29alIwIGIPZNB6jTMY/2F394h17G4rmYzk0dSQzimNfC53YlJVh7wmIhsGRIO8dmqXeUomerOwAPJrkRDPKKzgw/CqICdLGZhNWkFxrExAzQG2BhN7x7YXrd4PL/O3PVDeMSNx5rWclPmHz9ejamPC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 09:33:14AM +0800, Chunyu Hu wrote:
> Add two more checks for buflen and numwritten. The buflen should be at
> least one, otherwise the 'buflen - 1' could underflow and cause trouble.
> The numwritten should be equal to 'buflen - 1'. The test will exit if
> any of these conditions aren't met.
>
> Additionally, add more print information when a write failure occurs or
> a truncated write happens, providing clearer diagnostics.
>
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> ---
> Changes in v6:
>   - save/restore errno before and after the close(), so the log could show
>     the correct error info on failure. Suggested by AI.
> Chagnes in v5:
>   - new patch for making improve on write_file. Add more safety checks and
>     diagnostics info in log
> ---
>  tools/testing/selftests/mm/vm_util.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index ad96d19d1b85..572ccb99de8e 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -767,15 +767,23 @@ int unpoison_memory(unsigned long pfn)
>
>  void write_file(const char *path, const char *buf, size_t buflen)
>  {
> -	int fd;
> +	int fd, saved_errno;
>  	ssize_t numwritten;
> +	if (buflen < 1)

As per Sashiko (presumably didn't look :P), let's make this < 2 since we
write buflen - 1 bytes below which we don't ever want to be 0.

> +		ksft_exit_fail_msg("Incorrect buffer len: %zu\n", buflen);
>
>  	fd = open(path, O_WRONLY);
>  	if (fd == -1)
>  		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
>
>  	numwritten = write(fd, buf, buflen - 1);
> +	saved_errno = errno;
>  	close(fd);
> +	errno = saved_errno;
>  	if (numwritten < 1)
> -		ksft_exit_fail_msg("Write failed\n");
> +		ksft_exit_fail_msg("%s write(%s) failed: %s\n", path, buf,
> +				strerror(errno));
> +	if (numwritten != buflen - 1)
> +		ksft_exit_fail_msg("%s write(%s) is truncated, expected %zu bytes, got %zd bytes\n",
> +				path, buf, buflen - 1, numwritten);
>  }
> --
> 2.53.0
>

