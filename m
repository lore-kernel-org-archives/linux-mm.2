Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F174FC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 14:04:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F04CB6B0092; Thu,  3 Sep 2026 10:04:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDCEF6B0095; Thu,  3 Sep 2026 10:04:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1A6C6B0096; Thu,  3 Sep 2026 10:04:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C2E396B0092
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:04:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5FAD3C0564
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:04:58 +0000 (UTC)
X-FDA: 85172622276.04.70AB8AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id B476EC001D
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:04:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U1dKkoSP;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788444296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=elge9bDwtCLKT6xvAo3JEAnzLjGry/X8H8tlMHRXEkQ=;
	b=c6QglQZ40yEMfznA3uokw5LKCt6pKV0Q+K9Ur1f2bgnmvm3IPPUKvh9+m+UCzTWiiiZiXD
	mehk0N97moeYgepnrCEpldsTUtiezL/kXlWPkOpjEycbNlWCztUleknJSLaxbqMBl2YvE8
	1XXTVUJrxCboK15YuEQ6VRFH0fMlYQk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U1dKkoSP;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788444296;
	b=sx9Tuu4ojHn2us6LEQJF69lHkHjpukmYaJadhV1I/9aIIALbLMo287q/iU/Jf7X0BOm341
	Q6VRDb22jc7DCOcv06BX3pX3HGW60/8l3MpjazYNYJPYdsSub0FwDkoKP0s8OmuGGlkySF
	U7hLZCxGvGZVzyqRbJITzB2ncy8LZVY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D386B42AAE;
	Thu,  3 Sep 2026 14:04:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2951F00A3E;
	Thu,  3 Sep 2026 14:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788444295;
	bh=elge9bDwtCLKT6xvAo3JEAnzLjGry/X8H8tlMHRXEkQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U1dKkoSPdAWi+lBx2IodRAo+PkpJIhGCvTSJ1ADsxn5z9A2citGbidswvrrava5iz
	 ++OYMoE48S/FkIlqNm6nOVnquLiVBZeP17Bd0w81JRE0U9f+x1UgeDzMqMEkoKS3zJ
	 wF33hMQM0KtC8xU0KwGdS1jDmNv3eZDvnGIffxXzvT3d6fMHZWrp7fX3PDwV4h9RBT
	 EgHZ6+D7tLUZDNsT9CHbSTPVCHUbVQaKauNHhx+AWBu23+LiPfJPTG63l8yyz9Y1UN
	 ijDg3/bwZEG3FE+VFXUxp1mI+Xfjhflq/tdU+l6+5UJWrzpN82ooLFbSMh6l/h+Vqo
	 tjK95QBJzG+Yg==
Date: Thu, 3 Sep 2026 15:04:48 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	shuah@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, usama.arif@linux.dev
Subject: Re: [PATCH] selftests/mm: remove unreachable returns after ksft exit
 helpers
Message-ID: <apl-bS787dYOwTP-@gremlin>
References: <20260903135251.39593-1-zenghui.yu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903135251.39593-1-zenghui.yu@linux.dev>
X-Stat-Signature: oh9fmmhuzb5apnfapst3thfhfzfjsy7k
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B476EC001D
X-Rspam-User: 
X-HE-Tag: 1788444296-716585
X-HE-Meta: U2FsdGVkX1+B0iGL+6Kdbh2fSmgl2xBW+9sdTvnCpzvw3iHCNXsXHa+CPSqhSmPSiHtClE8n6NJXBUia/qPk/RSfnrWYu9MpC8vHTzc2UJ7NHMSNf5ISnBnk8JOGhdGR1wbkc7VBuaHrJBUGHhL3sjX7dSimo/0nwIG9aYnujlH3g0YJrso+tsu33m7osrogkqc4WNS/Eh0cHAvcFTEENZykvRyAS56R4/7w7uc/UQuWLXBbHWFDTvYz8kE9i3rxtb2pwy7yjyBNG8hpmQ+MfcXahyce9o5mOo3jmmnneqYUsxifcLqqrVmF4K1UtsQnj/HUTGhpc46bOefud+DoYpCveSZSJSMFB0N63EZecYsVv21Dn0Otjo6E780uJ5mrsEcK0xSqP+rPUZg4ooHpkDyFELZD6yRCFGUaJAgrj0Vf3qvnzE0Q96U7uLzn9ssz1K6/5BL6FBpcWHCenI3wZ36R+OZWLqMQhBaRgMCI88H+X7P+ba+mWtrOd/wQZW+iHkZY8Y15yKiODzzJly2lG2Jw+X9OESKigNWnGFvEKevh0fkdN2bfMoOhlgkCRHfSQatmV8pHxUhMFIH7IRl+LLCXV+pkIH+Z+pkw5y9VvhQkvtq2CbLQHEIhEHB2WyXY/x72W8m24yGNjZtJ6MotXNDvd8WsEQDNh/sZWpAzX6NC5cLwacdHbldjYnaJLyQpu3itMQ/82rqFcJyocHfhi9itPFwh7o12YKN8Z15x6ebXMw0sXeaHFoHSFnq9XypVkBdGeSJbShyR8rFBlpAXdYpiaekSYTL2QQXmrULdbGarn1zAH7DvCaPwKzXON3+r3DdQjod+jNqLgGDUjBsrAA7hk2mX1AqZ/MxMpsb60Nv5R7bC1in77yQDb/QmYRrv3I+Yf65Xb+dLjGsJkFTSdMGVAk6pW1YyZIa4cqI8KRcfVXa+50qS20OWyM38QnNxnLW8QHL+Kp5+jgcAx/a
 +FIFExoM
 GmXuYC4BjAL70HFO08VYO/ppj5USM2N+r2//juse85OiWLIkNizFHNrCrQQzW68F7SGkB5n/RnqHQYBWSpEBIky3Y6tyzdFU2//9ya2YsJcYFq74TfAikIoQI/lucNHuic0vTuinFeGAaD/tadKh6kkyzQdr04Q+YjiTHKQE2T+tyW+esxB0u6LDUlleEZYER3rdDmpP9NkLeoGl0sGUoPhoikTyHxJzvHxvFceRvafeJgdZi7h3F01YB8v644i5CVa/NdOIQmdIhxynz+/aXVvJ7sw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 09:52:51PM +0800, Zenghui Yu wrote:
> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
>
> The ksft_exit*() helpers such as ksft_exit_fail_msg() are declared
> __noreturn, and the ksft_exit() and ksft_finished() macros expand to calls
> of them, always terminating the process via exit().  Any return statements
> following such calls are unreachable, both at the end of main() and on
> error paths of helper functions.
>
> Remove all of them.  No functional change.
>
> Assisted-by: GLM-5.3 OpenCode

Thanks for providing the tag, much appreciated :)

> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  tools/testing/selftests/mm/folio_split_race_test.c | 2 --
>  tools/testing/selftests/mm/mlock-random-test.c     | 1 -
>  tools/testing/selftests/mm/pkey_sighandler_tests.c | 1 -
>  tools/testing/selftests/mm/split_huge_page_test.c  | 4 ----
>  4 files changed, 8 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/folio_split_race_test.c b/tools/testing/selftests/mm/folio_split_race_test.c
> index 45b84f7b364e..1960635a953e 100644
> --- a/tools/testing/selftests/mm/folio_split_race_test.c
> +++ b/tools/testing/selftests/mm/folio_split_race_test.c
> @@ -269,6 +269,4 @@ int main(void)
>  				      NUM_ITERATIONS);
>
>  	ksft_exit(iter == NUM_ITERATIONS);
> -
> -	return 0;
>  }
> diff --git a/tools/testing/selftests/mm/mlock-random-test.c b/tools/testing/selftests/mm/mlock-random-test.c
> index 16294bc7dae6..58772914fd79 100644
> --- a/tools/testing/selftests/mm/mlock-random-test.c
> +++ b/tools/testing/selftests/mm/mlock-random-test.c
> @@ -71,7 +71,6 @@ int get_proc_locked_vm_size(void)
>
>  	fclose(f);
>  	ksft_exit_fail_msg("cannot parse VmLck in /proc/self/status: %s\n", strerror(errno));
> -	return -1;
>  }
>
>  /*
> diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
> index 74bf79a5399d..f9c728ba96a5 100644
> --- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
> +++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
> @@ -556,5 +556,4 @@ int main(int argc, char *argv[])
>  	}
>
>  	ksft_finished();
> -	return 0;
>  }
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index 86a603692826..c01d227d7fd6 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -101,7 +101,6 @@ static bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
>  	return (pfn_flags & folio_tail_flags) != folio_tail_flags;
>  fail:
>  	ksft_exit_fail_msg("Failed to get folio info\n");
> -	return false;
>  }
>
>  static int check_after_split_folio_orders(char *vaddr_start, size_t len,
> @@ -548,7 +547,6 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
>  err_out_unlink:
>  	unlink(testfile);
>  	ksft_exit_fail_msg("Failed to create large pagecache folios\n");
> -	return -1;
>  }
>
>  static void split_thp_in_pagecache_to_order_at(size_t fd_size,
> @@ -711,6 +709,4 @@ int main(int argc, char **argv)
>  	free(expected_orders);
>
>  	ksft_finished();
> -
> -	return 0;
>  }
> --
> 2.53.0
>

--
Cheers, Lorenzo

