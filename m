Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A9E4C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 06:49:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BA186B0092; Thu, 10 Sep 2026 02:49:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 990346B0093; Thu, 10 Sep 2026 02:49:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A9096B0095; Thu, 10 Sep 2026 02:49:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A9686B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:49:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F3D6BA4B83
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:49:13 +0000 (UTC)
X-FDA: 85196925786.10.308B99C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 615991A0003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:49:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C9AIY50B;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789022952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xJCLyYcAILQ6PWEPe08MSic0RriCtlYRtE8Zs0diMnI=;
	b=jF0rPpRpC422bsk+/2ftVwGNcD3m1SNdShPrWXU6NqoBD+iyooazDukTzzPIASw1inwwTs
	0t1D66FFka4lMp3h5lSoFkT12mSrVBXSRLUb+4epQohcOwfHvNSyqsxmowNxjHfg4IBjBk
	u5LJB334gWukNwqk0HuC3r8sAhmqDjM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C9AIY50B;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789022952;
	b=Z3dOgZqaxaGwnQEmDgGT4YHPT6NdKE5Q1j83N7LM2LFZxGJwTKTXYqsZ0tZaBLJ7K0XWh3
	81PekEMcUJnhnoNgSSmhAIPBGvC197BCk46QbiVI+jHq9mcb+7wwuuTa1vjDM6Eod/uplm
	vJO4MMWf/7P/hVLUEp46kGciXKiNj4c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D3FF4038E;
	Thu, 10 Sep 2026 06:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203761F000FF;
	Thu, 10 Sep 2026 06:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789022951;
	bh=xJCLyYcAILQ6PWEPe08MSic0RriCtlYRtE8Zs0diMnI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C9AIY50ByFhKMO+HrWu+5m+uYpZIpV/7aqSWksUxqx0JfEPqfpeTzgYd2q1sUOLun
	 LPCd47Vmf3dGuxg4hnSTVRzmL29cZ0owNIfqHIp0Wmfc/vxuHmdePDYQzlK5GDdgfN
	 HDHUvqtIpqU34l1+3BJuHCdrppNHapq2cmloeyOZu33NTkH0PLoXT6AIq2VrSD7pzy
	 agxoB1I8IQMxitX+BA/F9vVdLqwKc8dZo4VONWEY4veaH1Y3up5Pl89vk422YpA3AN
	 J7Qp/ROd6RlwWF0C+mJNFA41oaLj/h6DhxHDxxw8enM8jycKtNsy38aMXwzighJ6RM
	 Fp/xFeKhZal9g==
Date: Thu, 10 Sep 2026 09:49:06 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Guillaume Morin <guillaume@morinfr.org>
Cc: linux-mm@kvack.org, leitao@debian.org
Subject: Re: [PATCH v4] selftests/mm: hugetlb_madv_vs_map: add underflow test
Message-ID: <aqJS4rVDDTQjxF3N@kernel.org>
References: <apsdO-IK6p-IDb-a@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apsdO-IK6p-IDb-a@bender.morinfr.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 615991A0003
X-Stat-Signature: py5bk4xds9jqjunsda1wp1grruauj6qh
X-Rspam-User: 
X-HE-Tag: 1789022952-989874
X-HE-Meta: U2FsdGVkX1/FlDottby4vZXpXDgykWXNCM0Gnfn3DzXX4Eq3Co227bXF3zGs6Y2vSWX1bR5hH/oU6iRFEBJugjKskYnTiYzmmUMGwOhXYxul9TgZj+RJ4ITPzfvrCYjIN4uHq2XkxmDmmlIZeBQiEBajZKXaci0kHBkOtd3THezgAFKQcW0QJrkVInqDbomp4lCj73ZcdQSYoLL1HJxgmYZ+rN/kzjpmBUtSttErJthYB6AQ3fsg1DHsTm7I+JqiTzgxcCPJgA/98s91oxx9TKeIJc04hyAyZQUTz1r2NaIhgNmveRDrZm7yWEyH3+o+lpkEoJTeaW4IaTPvZ3hKEnjRrc+aePjhIwLrY1g9nZAEpdGWsK+i047vp6x77I+rSdNM840ktBHaPgvZe4ZIb8tHdW3DvlwOxiqTE3PF8zsB2EScGAFfpOCnKjFaCVXJ5IS0j3A8T/R/RnmG3gAjE3/4AY20j35d+CGIyeGcyBKI7J9YylCXY3Ale2mABoq0aJAkuh9VvEnVaeSA4nWfjCLpq9zg7T4zQXPMsDEYkSi7H3jSyKilp3QFBM99Bmh8tcbr6WAhKLSVJuHlvfM+QZ4V2MQ+Ha2g0nbenrR/kl+YcwBkxYCfTdXE/4/oX/lg1wwpeO9SQ56Zu1nAFK1wflMyTahAfVgi3NstkIMMAhKRBSNbK9PoLp7tWZSgUZl/Y8l7aABmb5n+5JSBgHXoNkH1qtxvmoZyADdHB0yP+O2HDBH2+1h/rKJ++6ZiNz9qjfGJi3+G/mi19U/6x9pH/pWrQMXssphfkW2yJWq6IzGcv+3XLWaDZdU7I3I9K5e3LVIcXPO22EvzS5C54gvDgItIG0vED1bZXEkTbNL73n/SVduE3qUgsyTfD3IUwqOeUDGfpy/H3pNtwH48sKrNk1JmbhB5ZPyFH3Kyh/QWCPIZ6TOv07/LzE++0ws+uzQ5Uvw3gBatXNC6o4c4s5h
 0OR0zRf7
 VigRmtYP5SBx3TWBncFCsz7tEuXaACZ0oVnr/h6ZwkptX8FmqTm5sQtZ8I67gD2coKX4a06iTTLDMjx0u7P+ZVIUdpXoJj2HWVOecwSc/MAkml5Oz1P0SOmKWsci9Z6By7u3/9ZpH+wtXiijM+mkUtSGV79TNugTbUQKqjbsbb3v9BQFPLlo93654ws6dE70I2L4AJ5w5EvUhvFczdPiGKuKYYsY7M5P2giJMl/fXe7I3gCtcqPe3LlxnEcwFcS0arJASV7fGY2VyEW/eESQh6b4bZza1WWFhnQmjN216Cg7bqV6lylXMc+cVHX1CT+T392Vo9+45npMPWu6tLy4GFGhFIsKZID/S04Bi5p8Nln82b2xc+oQhA1ND2TJNs0Y+i0nbZ15esvyc/TxupbZTDx/OAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 09:34:19PM +0200, Guillaume Morin wrote:
> Add a test that checks for underflows when a parent unmaps the page
> first. Also check that when the child exits the reserve count is
> correct.
> 
> Link: https://lore.kernel.org/all/alEJkwn5VlTTH_ZX@bender.morinfr.org/
> Signed-off-by: Guillaume Morin <guillaume@morinfr.org
> Cc: Breno Leitao <leitao@debian.org>
> Cc: Mike Rapoport <rppt@kernel.org>

With some small nits below fixed

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> v4: address Mike's comments
> v3: address Mike's comments
> v2: refactor tests into 2 functions
> 
> @@ -100,7 +98,7 @@ int main(void)
>  				-1, 0);
>  
>  		if ((unsigned long)huge_ptr == -1)
> -			ksft_exit_fail_msg("Failed to allocate huge page\n");
> +			ksft_exit_fail_perror("Failed to allocate huge page\n");

Nit: _perror() does not need "\n".

>  		pthread_create(&thread1, NULL, madv, NULL);
>  		pthread_create(&thread2, NULL, touch, NULL);
> @@ -120,5 +118,110 @@ int main(void)
>  	}
>  
>  	ksft_test_result_pass("No unexpected huge page allocations\n");
> +}
> +
> +/*  We create a child process, then unmap the page in the parent while the child
> + *  waits and verify that there is no underflow of the reserved count. We also
> + *  verify that after the child exits, the reserved count is properly restored.
> + */
> +void test_underflow(void)
> +{
> +	pid_t pid;
> +	int pipe_fds[2];
> +	unsigned long nr_reserved = 0;
> +
> +	huge_ptr = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE,
> +			MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
> +
> +	if ((unsigned long)huge_ptr == -1)
> +		ksft_exit_fail_perror("Failed to allocate huge page\n");

Ditto.

> +
> +	nr_reserved = hugetlb_nr_resv_pages(default_huge_page_size());
> +	if (nr_reserved != 1)
> +		ksft_exit_fail_msg("Unexpected number of reserved pages: %lu, expected 1\n",
> +				   nr_reserved);
> +

-- 
Sincerely yours,
Mike.

