Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFA7CC54FCD
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 05:37:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79B846B007B; Sat,  1 Aug 2026 01:37:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74CF56B0088; Sat,  1 Aug 2026 01:37:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6629E6B008A; Sat,  1 Aug 2026 01:37:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 447166B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 01:37:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D7D03C0243
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 05:37:48 +0000 (UTC)
X-FDA: 85051593816.25.64A3343
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf17.hostedemail.com (Postfix) with ESMTP id 97A8C40009
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 05:37:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=H8F19DKG;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785562667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4mjnroDt3NYGYmhJROVWxiFtMXCSRJVFSmdPavCLqTA=;
	b=MJKuBHc4spKWc7NyXDLVeKd0Kpz+K0lyq6YTsK1kXnBuLCQGLWS9zmH/4uabhVKKKzAJPh
	i/ywQhVwgHZbqHnsMHZEo2Ip9ZL7A9GQUHrmay3yar5tcOuc7xX7ZGYH3QI/T1T5E74iYY
	eFi5CGqkRZlHk13AnmARMbT4HWFUTqY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=H8F19DKG;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785562667;
	b=NGV2eJeU72dQMWfT48qFmf8Jt4AN5yRLkPM0K/7Gtg2gBxVHjeqQtDgRrSaNaBKYJpgTb0
	QB3aT3dWd58gzZ1W8HHGqTxrqd68b3AIKOfr0ZkKHsF27Iivv2G4IJdZsHmzeWY78ig0TP
	GAdeKAi8sVYH6El6nxVfrwjDk7s+RMM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785562661; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=4mjnroDt3NYGYmhJROVWxiFtMXCSRJVFSmdPavCLqTA=;
	b=H8F19DKGp9QKOWwdOa3vvgZWMf6h0DQDGgDnlAvH4pDmvDcrCNlKM5dVZvDtRKrkz5FwlJedjxdYgfYfUTVYlGDEEQRWaa5TyEDE34f5kQWPikHeu4XlAt5pxkvWo2IAC3Ip1pTvM/aQwKruQ/hDuVIeG7jYvH/ly2ip5gDeqFk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0X89YbOs_1785562657;
Received: from 30.32.91.114(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X89YbOs_1785562657 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 01 Aug 2026 13:37:38 +0800
Message-ID: <4280f431-ce88-4f09-9de6-328414c98411@linux.alibaba.com>
Date: Sat, 1 Aug 2026 13:37:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] selftests: mm: add mTHP collapse test cases
To: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org
Cc: ziy@nvidia.com, liam@infradead.org, nico.pache@linux.dev,
 dev.jain@arm.com, ryan.roberts@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, usama.arif@linux.dev, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1785224928.git.baolin.wang@linux.alibaba.com>
 <bea2086517b69a1af8813dac5774a1409aafd262.1785224928.git.baolin.wang@linux.alibaba.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <bea2086517b69a1af8813dac5774a1409aafd262.1785224928.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 97A8C40009
X-Rspamd-Server: rspam01
X-Stat-Signature: erjqu1se3umphqmqdbkgcc3osfbg9e5s
X-HE-Tag: 1785562665-191173
X-HE-Meta: U2FsdGVkX19MKUqK8ugMBDSv/D+yGFcdW+K3P5wtTPC+ffWl3b0lpOgLlSkZ60NLSSD43ECirweJMAylCzdtnZYhIyqWNLNQa7Gpb9lxHD14Awy9NNoKQLr0qp70koczNX1045DGHaOey5KJGOy8c8o8L6qxxK0NbPewsKGpwQthgDX0PR7PlDhqzqs2TPaX64/wiBRT9wqpRHk5g33Dc/zrmNKGb5gKr1oyaywY2UJwIFa8DACeKoi+2LWUrGQvxftc3iXnTe1SgfVHz+GV8mjQ2JXhrUz4ecnO2xpwHTTdTOSLsz5PxR1m15JOPNqTGhWHAeq2lh8C6+ERuS9UygHKKSNS1u3liDVdTpOYhBObP+o3xXgY2uK7FWMAwyKIj07tfbKpMTVrY+5OnDzvHFet2zFSwp5HSTwTBg3KxEDj2Bot9cz/WwpmwJ5ibmIWo6xT3h2/PFnKcNmeRsWtrSCIcpU/93TZDQQBYUvOaRMymhpPeLpZCfzxcuQNhQ3Mqx1LZ4fnMdj6FmMmf27QgI+CRZGzhQhRH//0zbNXU4ksHmwGHA/i68tAAJN2t6ORfV0Cs/JiItTCRANHopqyBI6yhL7JQjkaJT+bdxA5tPKuCYwt1v1YbP0LgM7n/vclIhUVVDSuafw74D8grTPd/7AxxDDlc/E+OXgWv+7pYhlhP/XhN6Pwj662+caCjgusAD62501ld3DiyN/Qg9qQhVbEwHCr+/doUqFSZCbv2n213coXOm3sVR0eu7NmSHXzS//g1yPnifyh5EJGsKnBsPPGmq24E+yN777Ewm4pXJ5WNGKAv85VC1ZQHULPfCaaQi9PTy6ONwUyvCqFzWCojKxO4usW+Tb0RqGjEdkhkBFr5DYSJ0iyKAyZpqE+o7zGEnJ+GM4ofrOpXixUhC98a9EqEwdZe9OueAQhgsyTtCtwRu3iLlxPh39k0FzaJVylpt+qxeAzfx/IWPOmjuR
 e7dSCVi0
 GH6712njdgLAebVSusvNphjWI4t2GTBfZ1vsrQ7mhjv0xkixB5EqYTKnHuSnKKZz70YD9vCSzXH5HT0ADCsWvQgXQWAuVCqYMQsTcnVffNSRxhTElptrOp4SyPlgPaRvmInlJ72A7XyTCpl1plrmI4upidT9Jj4cd8H+9MMW2hpcxzNjY8OtQiJ0lvGe0o06apghEbTBJAzpwwrOiCf14R53mHWFzevZoyqpU0U/nrIWgQZhcq4aAjO4XQh8Xvqq6XkQf737vtWTDtU9PLwbq5GaKDWr24V2k53BbJQa0vYZqWCA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/28/26 4:13 PM, Baolin Wang wrote:
> Added a new command 'mthp_khugepaged' for mTHP collapse, along with the '-c'
> parameter to specify the collapse order. Additionally, added mTHP collapse
> test cases for 'collapse_full', 'collapse_empty', and 'collapse_single_mthp'
> for anonymous folios. All khugepaged test cases passed.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>   tools/testing/selftests/mm/khugepaged.c   | 130 ++++++++++++++++++----
>   tools/testing/selftests/mm/run_vmtests.sh |   2 +
>   2 files changed, 113 insertions(+), 19 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index f69be6be0ecd..e21a6ec38363 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -26,9 +26,11 @@
>   
>   #define BASE_ADDR ((void *)(1UL << 30))
>   static unsigned long hpage_pmd_size;
> +static int hpage_pmd_order;
>   static unsigned long page_size;
>   static int hpage_pmd_nr;
>   static int anon_order;
> +static int collapse_order;
>   
>   #define PID_SMAPS "/proc/self/smaps"
>   #define TEST_FILE "collapse_test_file"
> @@ -69,6 +71,7 @@ struct collapse_context {
>   };
>   
>   static struct collapse_context *khugepaged_context;
> +static struct collapse_context *mthp_khugepaged_context;
>   static struct collapse_context *madvise_context;
>   
>   struct file_info {
> @@ -554,25 +557,25 @@ static void madvise_collapse(const char *msg, char *p, int nr_hpages,
>   }
>   
>   #define TICK 500000
> -static bool wait_for_scan(const char *msg, char *p, int nr_hpages,
> -			  struct mem_ops *ops)
> +static bool wait_for_scan(const char *msg, char *p, unsigned long size,
> +		int nr_hpages, int collap_order, struct mem_ops *ops)
>   {
> -	unsigned long size = nr_hpages * hpage_pmd_size;
> +	unsigned long hpage_size = page_size << collap_order;
>   	int full_scans;
>   	int timeout = 6; /* 3 seconds */
>   
>   	/* Sanity check */
> -	if (!ops->check_huge(p, size, 0, hpage_pmd_size))
> +	if (!ops->check_huge(p, size, 0, hpage_size))
>   		ksft_exit_fail_msg("Unexpected huge page\n");
>   
> -	madvise(p, nr_hpages * hpage_pmd_size, MADV_HUGEPAGE);
> +	madvise(p, size, MADV_HUGEPAGE);
>   
>   	/* Wait until the second full_scan completed */
>   	full_scans = thp_read_num("khugepaged/full_scans") + 2;
>   
>   	ksft_print_msg("%s...", msg);
>   	while (timeout--) {
> -		if (ops->check_huge(p, size, nr_hpages, hpage_pmd_size))
> +		if (ops->check_huge(p, size, nr_hpages, hpage_size))
>   			break;
>   		if (thp_read_num("khugepaged/full_scans") >= full_scans)
>   			break;
> @@ -595,7 +598,7 @@ static void khugepaged_collapse(const char *msg, char *p, int nr_hpages,
>   	if (!is_tmpfs(ops) && ops == &__read_write_file_write_ops)
>   		expect = false;
>   
> -	if (wait_for_scan(msg, p, nr_hpages, ops)) {
> +	if (wait_for_scan(msg, p, size, nr_hpages, hpage_pmd_order, ops)) {
>   		if (expect)
>   			fail("Timeout");
>   		else
> @@ -617,12 +620,62 @@ static void khugepaged_collapse(const char *msg, char *p, int nr_hpages,
>   		fail("Fail");
>   }
>   
> +static void mthp_khugepaged_collapse(const char *msg, char *p, int nr_hpages,
> +				struct mem_ops *ops, bool expect)
> +{
> +	unsigned long hpage_size = page_size << collapse_order;
> +	struct thp_settings settings = *thp_current_settings();
> +	/* mTHP collpase only allocates PMD sized memory */
> +	unsigned long size = hpage_pmd_size;
> +
> +	/* Set mTHP setting for mTHP collapse */
> +	if (ops == &__anon_ops) {
> +		settings.thp_enabled = THP_NEVER;
> +		settings.hugepages[collapse_order].enabled = THP_ALWAYS;
> +	}
> +
> +	thp_push_settings(&settings);
> +
> +	if (wait_for_scan(msg, p, size, nr_hpages, collapse_order, ops)) {

sashiko said:
"Could this setup create a race condition that leads to spurious test 
failures?
In mthp_khugepaged_collapse(), thp_push_settings() is called to set 
hugepages[collapse_order].enabled = THP_ALWAYS before wait_for_scan() is
invoked. The khugepaged thread is then immediately allowed to scan and
collapse the faulted memory.
The very first action in wait_for_scan() is a sanity check to verify 
that there are currently zero huge pages:
tools/testing/selftests/mm/khugepaged.c:wait_for_scan() {
         ...
         /* Sanity check */
         if (!ops->check_huge(p, size, 0, hpage_size))
                 ksft_exit_fail_msg("Unexpected huge page\n");
         ...
}
If khugepaged collapses the memory in the brief window between 
thp_push_settings() and this sanity check, will the test falsely fail 
with an unexpected huge page error?
For configurations relying on THP_MADVISE, this race doesn't appear to 
occur because the madvise(..., MADV_HUGEPAGE) call happens after the 
sanity check in wait_for_scan()."

Although this race is unlikely to happen (from my testing, it has never 
occurred), setting it to THP_MADVISE is indeed more reasonable. Will do 
in the next version.

