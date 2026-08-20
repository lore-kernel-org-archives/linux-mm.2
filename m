Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ED77C5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 08:40:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9CFF6B0095; Thu, 20 Aug 2026 04:40:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C741C6B0098; Thu, 20 Aug 2026 04:40:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8A916B009B; Thu, 20 Aug 2026 04:40:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 927A96B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 04:40:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 11B601A0702
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:40:53 +0000 (UTC)
X-FDA: 85121002386.23.3555342
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5652A1C0006
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:40:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zxahij7h;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787215251;
	b=W4UbIsulF/T+u61L6q1WRba/f2r5I9xOjDMVlEBK8aoLfM149dHq7eNeOJZGFoY95JiT66
	XPa5aOiK3AOIzrVodDEgYc3xRxSgZsWF7+Ge6FsyGNhsdi/7Y0SYkhp7ioaGVsZ5VGYnb8
	8Hev0rS/2L5dOQ7q+jugVr+SiWXF7Nw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zxahij7h;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787215251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HnwWZ/4ehQreeTuY9y550MCVlYTbzZnYeWaGxttv8V8=;
	b=OSvmo58YdBqbacyonxmXu2X00OOHzBYim8Gjaj6qbXXAdQCINnoQaHEywXzK6EltICOPL5
	QKkbK1USxqZJFxgV1rhEh+gKPf3cjY2NRsD7FEM0bQX3ayhf5jIKJLjo/b2a9NEx0a8Ug8
	Qfyi9uD7T4WwqnMONu9m36dxMFzl5sU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4EFAA41677;
	Thu, 20 Aug 2026 08:40:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96121F00A3A;
	Thu, 20 Aug 2026 08:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787215250;
	bh=HnwWZ/4ehQreeTuY9y550MCVlYTbzZnYeWaGxttv8V8=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=Zxahij7hcCaeST/KxDrHxadXlTEHdefBJX3VXVdNv+RR+o9RIhpozzK6q7YjE5dMk
	 NFDi88q8ugE9cDxe8u/ZXlK3WwNBKI24escXcAheJjehORUh3WQdHcHPAJOsP+o+EL
	 1NnYUW98hde4bi1OIfdAJD+5X3njg08kWPKIkhJWxEvq/hc9XOfO+hkZcwxoslx8jM
	 I4fcG0oUdfiQGmTLybKAGsqswoOrr3YwTUT1Usr9N6BNo9QNClAJe+A8ML6Nff5Y18
	 NKIgxB34fnaqoc0zRQV53H7Aap0Wy3YdG4p2dwXWO9gQ+m4Tw56QTArtdpSYLLaoYv
	 4sxLm09FfcmpQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 04/19] selftests/mm: skip khugepaged page cache
 cases without a PMD folio
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
 nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
 dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, 
 liam@infradead.org, mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, 
 shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
 vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, 
 agordeev@linux.ibm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kas@kernel.org
In-Reply-To: <20260815015901.1236937-5-kirill@shutemov.name>
References: <20260815015901.1236937-1-kirill@shutemov.name>
 <20260815015901.1236937-5-kirill@shutemov.name>
Date: Thu, 20 Aug 2026 11:40:35 +0300
Message-Id: <178721523516.2799959.14298419435530679565.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5652A1C0006
X-Stat-Signature: bi8r94itgo664adcxu7gxsgoz3gcb7xc
X-HE-Tag: 1787215251-41285
X-HE-Meta: U2FsdGVkX1/fcTN6a+aNWAdnw/PnAJGzwmAPNFA+hofoeH9HV3M+XprPTiCKj6nYMaktmyjzEVal9djQxZbYEchq9YY8LjApnw44NVkBBuA5Kh/lI/gYrlTgIhc2yq8xfGQKzQL4ceC3yaRPbFFRyxmPZElz0UGcIy7EQH1wdSiMwFddkXUyQjb4bnJWXIKH2H1i8QwUCLiR6t4MLsv8+xdI3SEkYiKPiAjmhE/SVDTCqqDomiuc5qRhcP6oFXuoxF39sQFUgNz6fcfGumkP4SBxYYYG9wMxDXoXy0roezIWfQBF9Cv5Dw2Lqp0KrPaESYvvEtDQJjvFo8PLbw9Mw5V6z+ssesNJsfKBCGB+O9/vRPAE+bEyRRGjiKLQGd1racJsQ7WLnVJmO1ddOh5LNXhM7N91QdktqcVKeXmf5GwKrQjVfqAoupJ9usGH2G/SYrlySUyKWn8fXIN3MuOrzBGEgjmr6mPOOfz7wRvm/yuretSUTfMmYei12lbVj+SaSwouu4rRZgDVUH6o0XRLwrLapCGjiDCmUAByVmFhH7OQwhLjVUSz+zVSZAiXIND2cyoBZKa4fhAN/5ikW4KNXTErCKGh4whK8eXVNdy+nA4UVOGNRLB5xcJPmnNiGPIRjHClckzg3z66wUdDKl+rgiupKH/cJF5wBx5G9C1sfe1wT+E2c+r1N53UMFrYj7axCbZYB8iqADqOwHPNZ+e1M553a1cMugBnHZBBCRcTuyGnHJy7WPUJ14F7DbNUX7gR6vFy/7hWo3twWVgA0/bdJ+H0RC3kQXeI7Jw0IWZqXcsMQX1DslFKp/a3uT3QbJDyc4FAUTCWQkCB5tLqjTrDxfvBUba6P7Kuuhr+BDUaXIXydbC3TvYpmAFHfnIt+esG0kd1ZUuiGQX0cqtcC3jfqYWI9oUyVMTEd2O75Qz8gl02fntIQ67d6w+XD65TAIm1sC92nu3t+xxT5yUVTk1
 Pm++jdsB
 DBV/Nk/78FVlZ611Zp4JygidpSXjIDFpPktObOuzGwKfdZRgYOdkXiBdn59tTDUvXwMRsbCEC1xpj2RbIUC73n/mDHn587tJHRgqdzN+H+XCNtRCJWs/jnbbRFCED3h/ywhpS5n0mULWGurkwelrZyBukVeFqKT13rovlJjzWG7kK0epf4WIL7/MX9qxGJApWkOChG4zbrL/fxxw/MhkJAJpvKdTyXeyOYo7XYl8C/458gljiL9DVE/Xz+Vghkq4pGFnabxhtVgq6oOM3k+INCABikUmQFwTWTceAQ5RVPFLiTrtq3RkHSDvlJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> The page cache caps folio order at MAX_PAGECACHE_ORDER, which is smaller
> than the PMD order on arm64 with 64K pages, where a PMD is 512M.  A
> PMD-sized page cache folio is impossible there, so MADV_COLLAPSE answers

Nit: the code comment phrases it better: "so kernel refuses these
collapses".

> -EINVAL and khugepaged passes over the range.  The shmem cases ask for a
> PMD-sized folio anyway, so four of them fail and the run bails out in the
> middle.
> 
> MAX_PAGECACHE_ORDER is not shmem-specific: it caps every file folio.  Skip
> both mem types where the cap is below the PMD order.
> 
> Anonymous collapse is unaffected: its orders are not capped this way.
> 
> Assisted-by: Claude-Code:claude-opus-5
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index a5ada78d90ee..b436b401e2ea 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -1391,6 +1391,30 @@ int main(int argc, char **argv)
>  
>  	setbuf(stdout, NULL);
>  
> +	/*
> +	 * The page cache caps folio order at MAX_PAGECACHE_ORDER, which is
> +	 * below the PMD order on arm64 with 64K pages.  A PMD-sized page cache
> +	 * folio is impossible there, so the kernel refuses these collapses by
> +	 * design and there is nothing to test.  The cap is not shmem-specific:
> +	 * it rules out regular files too, and the per-order shmem_enabled
> +	 * controls exist for exactly the orders it allows, which is what makes
> +	 * them readable here.
> +	 */
> +	if (!(thp_shmem_supported_orders() & (1UL << hpage_pmd_order))) {
> +		if (shmem_ops) {
> +			ksft_print_msg("no PMD-order page cache folio: skipping shmem\n");
> +			shmem_ops = NULL;
> +		}
> +		if (read_only_file_ops) {
> +			ksft_print_msg("no PMD-order page cache folio: skipping file\n");
> +			read_only_file_ops = NULL;
> +			read_write_file_read_ops = NULL;
> +			read_write_file_write_ops = NULL;
> +		}
> +		if (!anon_ops && !shmem_ops && !read_only_file_ops)
> +			ksft_exit_skip("Nothing left to collapse into\n");
> +	}
> +
>  	default_settings.khugepaged.max_ptes_none = hpage_pmd_nr - 1;
>  	default_settings.khugepaged.max_ptes_swap = hpage_pmd_nr / 8;
>  	default_settings.khugepaged.max_ptes_shared = hpage_pmd_nr / 2;

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


