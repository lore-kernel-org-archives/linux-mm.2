Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EEE1C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:51:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96A576B0098; Tue,  8 Sep 2026 09:51:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91B196B0099; Tue,  8 Sep 2026 09:51:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8305A6B009B; Tue,  8 Sep 2026 09:51:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CE146B0098
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:51:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ECE52A4C90
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:51:19 +0000 (UTC)
X-FDA: 85190731878.13.C60FF01
Received: from mta1.migadu.com (out-246.mta1.migadu.com [95.215.58.246])
	by imf28.hostedemail.com (Postfix) with ESMTP id D58BFC000F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:51:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oPb63NSV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.246 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788875478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lIbLTlNRNZAXVtUeXdcU4aonrybJMLyfv8dVgq/DzRs=;
	b=KZDxdbMqpT0SfTQUVBX15Q6gFlR3akO2t28I3BiceInAJvNiigsix9N5Heyu2Ytwl69Hdl
	x9OhtT+EbFuxohqZmUVMfAc2fcJ/uaSh8V/24AcWZ/wf/NsqS5aWKKYyyuRm7L97ufYTMf
	8OnPo56H1WLjSucIZeMMmAqg2WyShvI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788875478;
	b=aoqlEupo1wyTJkXi5kbGNWQAJmM1c+4IWamJQ67pDWghM9Vo7uUbveiP2YgLANfUobMA5x
	dyFzQfe7nx0CU5Ljyeqn5BoKinZZcCfbhswvVET/PfEh3HID2/weTdmMMY4c+T2BKYewI6
	CGZD1AzY7xkVdHudAo7L4ULeniyy1F4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oPb63NSV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.246 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=yAkATAbOR8BHFyRFOsELRt+fYAiuqFYEVcejaIN9a/4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788875468; v=1; x=1789480268;
 b=oPb63NSVAM1cGM61r3OUh0VWBaMubfLs+kPoSFk9e7+oGzj0ePEgc9bgB4asCYi5sHCcAaRP
 NWU8SJVHohPq/gjzQJUeOcCbNOIBmYtjjS1THrf3uAfm1tPHWli2HKeC0gJ2P3EHcJW3c6I9wGm
 3jlBD3YJb4AtNxO//+Wiblz4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 73574c6019326117;
	Tue, 08 Sep 2026 13:51:08 +0000
X-Mizu-Trace-ID: 73574c6019326117
X-Migadu-Flow: FLOW_OUT
Message-ID: <13fefc5b-7148-48aa-95a6-7f64cf7c66d5@linux.dev>
Date: Tue, 8 Sep 2026 21:50:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] selftests/mm: init page sizes early in
 pagemap_ioctl test
To: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, gourry@gourry.net
References: <20260908134117.84405-1-zenghui.yu@linux.dev>
 <20260908134405.84448-1-zenghui.yu@linux.dev>
Content-Language: en-US
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20260908134405.84448-1-zenghui.yu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D58BFC000F
X-Stat-Signature: xshrm3g83qqetati15u43zbuudddapdb
X-HE-Tag: 1788875477-110460
X-HE-Meta: U2FsdGVkX1/8/HkRyzQlwm5SPeGzxhgd6Ib00IMvByvs5QputwADG0FikhEezM/o+PSmQOLJd17sW3LmQveTemCqJ+ywv3ax4L3lfAFHscamaIjsCrx2n7GEU+B742ayFKGg0yVxueHfbLZkNzpV2kDSqPuBq79zVJBo5zAazK+iyESHmI1dPBmQHgs+JrdKhJhHs1VE3HeeXmjV8MyXdDJg+fy5YuDcjmQLSb1kICULLx1PVxqYlWDI+fnoEX6KU1qHzF4djw6JWq7W030FxnpQzT30Ve7rUoiP47svVoW/d43CMkbfq91k/nkWszRip8i+yboLLhI3GAXw37Q4gj4zHcM6+plVCvC5rscxpAH3Cgb9BfLga3h0hSw+Cb1p82cA2sJrVxWgFjEntW+aZkJA6yjb79c2hv1g/6MsiOYgPSYMNcL7URa1ec++b1fBCnAOCYlkUY59b+oIchjJqC3KLV2Auu195PE2iH3uIDG7zgN1WcSZE4kLhq1ujVFGk2F9QOyVoypvGMlcjOXMAkGWgQTB4JVVoHg4NiYTvRLRL340dUepTB5LElcLYBl00IylQdmCv34jP4e/3xy8w6nlck063Rps3VCKlR1NMjh1wcSYiUnq197MH/yhphL83K6leI2aQWbpof5iwGyv9zB8Pqn1qpKM/QjbF9cUF6z2MFzNkw4mH3pP05pM/g0+i3EIrYwR97HFpJN7h/ZU+ilvesBFB5c5+WsgoRboPst34wuv14BXiRlNrYwdwsSFpTs+/LH81kGUbvTItYqGz1tWBk49+a1IkgXqrwMryNSHVNQr9YenH8jsKq2EMTGesVKrMUS/+kwcQXKTJeiBVRQ5w/zYTH17PrL26JUkrcslfM8h4BgkIPyq03HtSx4xotcDOTo6FS0pycxv5sUxRcVG4e7DiM4k4ZVE8dioN+fHC7ymcNMG25q0JoV2rImWZBszIOzNnXriB8s52b3
 1IX64IPi
 ZXMGS5e0y1JlkmMOjGg8kHHDPzvfOSOvIpXsYuiDlC8s/DOtBqLVb3lExTzFxTNzT15TpqyoXXpRzel6yE9rdmpIZ1KDNkV3E/QiGmnkVhIkTyvtTQCHJnrs1p8Vbe+Dead3MdNVexwCrGxUBkd8bWZ3wK9j1bGTbJIv3L4bCA5qqVOk2f5RXj1DloJSIBnpQSh09b70TJr8oa7mmMMpiBOFHVcAbcSjhITKRI6Jb/qfKzpNOSd5iENS4uBeb4heI8mnwJPpvIOf3NTQuvnQSRRRAcZpJ+oxrZleR/MCzJnNLUPFKcCdh+MK4YZ4bO6jA+2sJApnZe7A6UlUpPOkTynpBsp8hyxX/spL0fKJkP12DOegj1hnclp8Cqc+z3jOyKKi5+15+H2/ycJ5paBDNM9n0gQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 9:44 PM, Zenghui Yu wrote:
> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> 
> Initialize page_size and hpage_size before calling init_uffd(),
> hugetlb_setup_default(), etc.  That won't fix anything, but it is safer and
> saner to get these globals set up before doing other things.
> 
> While at it, drop the page_size parameter of transact_test(), which is
> actually unnecessary.
> 
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>

See https://lore.kernel.org/20260628111329.9cfcd9c67925869307020aba@linux-foundation.org/ .

> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
> ---
>  tools/testing/selftests/mm/pagemap_ioctl.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
> index 1a87b7483316..d9a4fb782ecf 100644
> --- a/tools/testing/selftests/mm/pagemap_ioctl.c
> +++ b/tools/testing/selftests/mm/pagemap_ioctl.c
> @@ -1489,7 +1489,7 @@ static void *thread_proc(void *mem)
>  	return NULL;
>  }
>  
> -static void transact_test(int page_size)
> +static void transact_test(void)
>  {
>  	unsigned int i, count, extra_pages;
>  	unsigned int c;
> @@ -1653,6 +1653,9 @@ int main(int __attribute__((unused)) argc, char *argv[])
>  
>  	ksft_print_header();
>  
> +	page_size = getpagesize();
> +	hpage_size = read_pmd_pagesize();
> +
>  	if (init_uffd())
>  		ksft_exit_skip("Failed to initialize userfaultfd\n");
>  
> @@ -1661,9 +1664,6 @@ int main(int __attribute__((unused)) argc, char *argv[])
>  
>  	ksft_set_plan(119);
>  
> -	page_size = getpagesize();
> -	hpage_size = read_pmd_pagesize();
> -
>  	pagemap_fd = open(PAGEMAP, O_RDONLY);
>  	if (pagemap_fd < 0)
>  		ksft_exit_fail_msg("Failed to open " PAGEMAP "\n");
> @@ -1823,7 +1823,7 @@ int main(int __attribute__((unused)) argc, char *argv[])
>  	mprotect_tests();
>  
>  	/* 13. Transact test */
> -	transact_test(page_size);
> +	transact_test();
>  
>  	/* 14. Sanity testing */
>  	sanity_tests();

