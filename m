Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D94FCA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 11:12:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35BA76B0088; Mon,  5 Oct 2026 07:12:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30B6F6B008C; Mon,  5 Oct 2026 07:12:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 222406B0095; Mon,  5 Oct 2026 07:12:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0448B6B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 07:12:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 779741A0213
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 11:12:34 +0000 (UTC)
X-FDA: 85288309428.08.EE3FA48
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9052420009
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 11:12:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DiAmdi5c;
	spf=pass (imf03.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791198752;
	b=A8kIbjww0BopwFMnAujjNup0XRntxmALyf7BUGGtswm3TvA+jZ9YNMGeL70m20p8FX7snc
	BKAVOIdSr9T3XKwTCHEMZTuCY9jBE9km72LZ5SjFwSrouuKOsZa4RVBc1jDR/6yx/uZhsR
	RpYwQHgPJUE4JbRUg02EUErGirFVO28=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DiAmdi5c;
	spf=pass (imf03.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791198752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n6asPcMXLFOX0ANnIJU7SQSG1NIQTAQReGVm6nlDr34=;
	b=UqtB+LQ1dqvU8sZCH7NMIu4WZ4P8MTHD5bWNm1a6GA+AE2h1xKu4oybrztjGCKdCLgdPXD
	qWtqW7+OMJ9qdH0Gao56+/lxvH/twmri7qfWjKsyWbUXAdhGYN5B+GUyy1nJHEVTa+ti2p
	Jw/6AkvQHjhl9pVaeoEBLhhloMRep1M=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 74D60152B;
	Mon,  5 Oct 2026 04:12:28 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0B1E33F86F;
	Mon,  5 Oct 2026 04:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791198751; bh=MEZ3+wQPyUj1ckIQWi+S/NiOG90urc2hAt/8uUoF0i4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DiAmdi5cLAEzN4qUXoEyyBne5c2jWgZqTfITHQYH+W3s110u1+BSV4Bz3tXPmX99m
	 TJWwBfGj/ceU7duWZCm7oID2NfY4ENQhfXBNeQMwJOXRIUGM+DJ/atEaav4avPLiHY
	 K1EmaZH8Y5GxZMy/3SsdVdjY6phLG2JyrY4LDeyw=
Message-ID: <ef380330-b15f-412b-a517-15383913e45d@arm.com>
Date: Mon, 5 Oct 2026 16:42:25 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: hugetlb_madv_vs_map: fix TAP plan
 mismatches
To: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Guillaume Morin <guillaume@morinfr.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Breno Leitao <leitao@debian.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <aqgUdbtumaO8RiIb@bender.morinfr.org>
 <20261004230018.190880-1-jaeyeon.lee.dev@gmail.com>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20261004230018.190880-1-jaeyeon.lee.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mrztmtffr1uo8ky9h7wr33ny5fdxr5sn
X-Rspamd-Queue-Id: 9052420009
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791198752-103079
X-HE-Meta: U2FsdGVkX1+gCv9VZGg29CyoeWhbz0yPK7qWAgo9wXQ6TcG9jjyutSP1KbaZQBx3IOSSZrxg0MvYqVvLOPQyha4KF/mWwso3txbpWKrdqnzL7oBpnxjwN85cEru5trloOAGBPmQ+zWwWyi2zELy9TYF8iiu9aCHFQGGAD2PKUdbsliLEmb+Z+DHlTW8ulso56ayoGt2a5KH9mcaKHOq21FbslPKObL3Oh2G14YGwMSI+7/B4xnSQRx3zNNa9RX5a1XDP0YXrU/XWq9PPQqwXKV/780xrW4hlRXVNTNoA5c3nh3MKSLpVr1E6PQPQHGqDzVRLRaYy5zYPGr+YfSxn8xLDWhgu1rNCgIC9oSX9QaIgzK4uOPBpnSlck8wOTPryQUc/vk4LF1Qvm/3HdFSmJNz93PL5mDEojeqSTtU1XjBEWdU8E0dxO1bC+zeMTWG6CEL6UH5V/acXdNTcnE+zxGxc5dxjkkdDMB+Cxjjmgs4dhnvrG91m5e92FfyjImUvxTghPx1Blylw0+LQ8LKLv4SFi/6UZ+85haIpraKbpjHf5CknNHEu7pHfDf9FguVYyW7hks0k4sjvwGYtBDQRMbX9xuGk25xZJQPRE6OGbOABl0klUaFdAMbOlXZoMsIoPOZScbo9mbyk3ZTwjvipc4qxg+zoFVFdftJvlnryrIjiOHDuQ2yEahnb7bNCElnwCcUwXaCABepQ052fIgs52dt9/+4NxxZVYy2tVMQvX4VNY/y2rtZ8uf3sSK0NyfOVGQp3UsGxcnIbKf3D3uVfpbKsPs/GQM9YX69IMsIB7p8fwOM3ZNDm7o0nILIaQJiKqVsYBCvMNo4dhCxU00169/Fk3TmedYlHLJIWH+Je1ED74KKTqlmbULOZ32XqaRsN1gceJnSQWt3DjVvLWjY33PzN3wdoWMADvjrQ10YIolJaZ0UDXW8ETN7Pb5DcqpB4JFVU3Go73wppWTOMa4V
 kJ6V9/xB
 /vHcwv78akSy/Z9Vn0H/+SaNvhydK7JZKWPFNwSLdyqYlZOeyV40VDUm7Msv7jhSnpTESQYohHC1aku/a/J3rBqvyHPBstag2H8+A1Ny2VQYk3GNzzriTRce+iTGP+ALw1+P0fr/kikm6MIotf3uh6u5YfyLy46eCKRBcLHbE3DxnK5izwxY9ngpRGcRQS26y6/Sn7Z0pb7iW+z0T4YutzfdmP23e3EGtkiv0BkzbUBTjI3wtP3vESjClhvpUn9lctjeUh4Jo7ED/ubiV7VRCQsOecrvyCJiECcNvFOcmBvfU1RIdXCPP7iomIRv2r0mznWTswKLslZ9ObT1tqLuOxWhPfLO/k7lawi+UZfopPXoXc53wCOfxJHmIOU3g55no2J6X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jaeyeon!

On 10/5/26 4:30 AM, Jaeyeon Lee wrote:
> The plan was raised from 1 to 3, but the HugeTLB setup check that may
> call ksft_exit_skip() still runs after ksft_set_plan(), so a setup
> failure reports one result against a plan of 3. Move ksft_set_plan()
> below the setup check.
> 
> Also, when the underflow check fails, or munmap() fails,
> test_underflow() jumps to err_cleanup and exits without reporting the
> remaining results. Report the munmap() failure as a test result and
> skip the final HugePages_Rsvd check in err_cleanup, so the output
> always contains the planned 3 results.
> 
> Fixes: 827149aad495 ("selftests/mm: hugetlb_madv_vs_map: add underflow test")
> Assisted-by: LLM
> Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
> ---
>  tools/testing/selftests/mm/hugetlb_madv_vs_map.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
> index 1d111f42dd59..5dc44ff0a377 100644
> --- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
> +++ b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
> @@ -169,6 +169,7 @@ void test_underflow(void)
>  	/* First unmap, this will close the vma */
>  	if (munmap(huge_ptr, mmap_size) != 0) {
>  		ksft_perror("munmap failed");
> +		ksft_test_result_fail("munmap failed\n");

This is duplicating the "munmap failed" message. Can we simply put a
ksft_test_result_fail("munmap failed: %s (%d)\n", strerror(errno),
errno) here?

Also, please send your patch in a new thread instead of replying on
another thread from next time onwards :)

>  		goto err_cleanup;
>  	}
>  
> @@ -203,18 +204,20 @@ void test_underflow(void)
>  	if (waitpid(pid, NULL, 0) <= 0)
>  		ksft_exit_fail_perror("waitpid failed");
>  
> +	ksft_test_result_skip("HugePages_Rsvd check after child exit\n");
>  	ksft_exit_fail();
>  }
>  
>  int main(void)
>  {
>  	ksft_print_header();
> -	ksft_set_plan(3);
>  
>  	if (!hugetlb_setup_default_exact(1))
>  		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
>  			       hugetlb_free_default_pages());
>  
> +	ksft_set_plan(3);
> +
>  	test_madv_vs_map();
>  	test_underflow();
>  


