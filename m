Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 048A1CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 10:40:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C1216B008C; Fri, 12 Jun 2026 06:40:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 698C66B0092; Fri, 12 Jun 2026 06:40:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AEFE6B0093; Fri, 12 Jun 2026 06:40:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4750A6B008C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 06:40:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 10E6F8F825
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:40:13 +0000 (UTC)
X-FDA: 84870915906.01.713306F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3AC1F20002
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:40:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I8NwfTEu;
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781260810;
	b=InBXG89L7gHYXalLEv3v0Kg7PQoDuzPj5reiF7acla+ovszahq4SMAhJwd5WiUa/3UJPm2
	nTp+s1zLPGItLq7cMBWSQnqFnML/FJhCIMBG3/PAs4FFQoIVZbMQlV+Xz7eGyndEir9Dnp
	QxsR5oxkxnowaMNkLU8AfIjDlbfdbXQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I8NwfTEu;
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781260810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wbMHc9owEYeagDmLS6VGhSW9KveQRoz2Io2kiAEfmqw=;
	b=pX7ZLavRSCoDTlFE2wOLcFcA836Gqn75Heg2PVKef1NlFHaS/CwBR220Yt/AiaNbe2Gyeb
	2jq2pc/gTIfBeb5FrX7OV9fqb2044nRQAuUi0BWDnHY28wdbALmokZ0uLAjMPaX0o6Auuh
	SQOVNtC60V0iXGDMg+y+KwgHk7jdtR0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781260809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wbMHc9owEYeagDmLS6VGhSW9KveQRoz2Io2kiAEfmqw=;
	b=I8NwfTEuXwy9osWIvMLnnuX2366LGwzOxfxLHnQlgC4D1cf7XV17M/cpJWztronUGmA27S
	rKh6mVZZi8/p4jTJmocKAggd0Dh5uSpJXjLo6hXkKbdDPdpY+EZHZyGnLFLhPmr6+iW5Cm
	AgKNQyv4rixAvxiWv4rUzRmop40St6o=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-471-8JcfYDDPOeeb041kP2Nvtw-1; Fri, 12 Jun 2026 06:40:06 -0400
X-MC-Unique: 8JcfYDDPOeeb041kP2Nvtw-1
X-Mimecast-MFC-AGG-ID: 8JcfYDDPOeeb041kP2Nvtw_1781260805
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-490ae0167ceso4052815e9.1
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:40:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781260805; x=1781865605;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wbMHc9owEYeagDmLS6VGhSW9KveQRoz2Io2kiAEfmqw=;
        b=nlzjvK5vpU0ZyGVUwkvL6YQTZcg914+G9niw3IdBYyi6k3NPA7XYv+Mqc+n9sKWMBf
         zlNZFxRdtc4X7EV7H1/9NeAVCnfWX/EU6Pbi8PSuTY922TN5qkeOvZ1vF0kinRI8ij7w
         wa9skZFmdjFP+bleVtU7W1vIUIiVUHkrzsWzpA7cQBFwwRdjqwUmjbwU9mY+J82WtyQ7
         I5XfKRbdlBC49EkxOkMCNWtsD4IqR6vJaXP+IXurQ2+AafhfWDYpFdSGhob7tMv1WSuJ
         HCTrUirW3ke3aII9UHmmhb7+I/9xU2BqpYKRfWTaaJeAEhNJ//vdAgXzjexPwyDW8nKe
         3K0g==
X-Forwarded-Encrypted: i=1; AFNElJ/1/2nZ1PkOXX7HtRwS/9C8SNO6PCFMEeeCwx9EUl0hR8kq1DfoweZ4xrE76KLQZrdxFf+4L2tNMQ==@kvack.org
X-Gm-Message-State: AOJu0Yz/7cI84gtBGIr+HDiLgCOfXbc5IPIz9utU3Iz6zmHWNuKBaoAZ
	d/ZFQFQqCboxBSwi4gGJsw755Ii9LqBXfBOcN6udJmG8w0kEGwbE/omltYEd8CS+43aJaLr0CVS
	Fj+aWFrgswu3m0be9EgLG814DTjnMBdEYVdOk8lsfwDRXUo7147uU
X-Gm-Gg: Acq92OFihDHEE0fMyHz7lb0kCZ1txxASVR+1sIA/8YDauRhCDwO9bBvT20XXhkFE9mQ
	xbj/Q5HGAepor5WNV/RzSfnnUCNwT6ihfF3fsXqDTCHUeyGW0fcd94cU6LOm1KqU7lqrYBNWfzM
	lgXraKoLtNZqoJLib0TRCM0wuglrsothtw3F3md4iyfLJD8g0TW8Q/Qz+kA2qcuiq33i4AqmVIG
	iWpN4FYgYbjvGZxTRZYVAVF84fv2WOMHcNJ+zZQUscn4VRQ+Fqd5YAdhBeS/7WSLB76BogNaVOk
	Dmrpn+OGVw9x1n2pgD2VtWQuANE9ScXwu0gDtwGjZIsyage2eSEPQch0b7emKaodRV2ypdFHZQE
	nqsq8hlvKQS2TWF1msRmEvm3/NJ2l6pbl0YH2mQagGOXn8ZLZOLZp35Y0iLXB4dUb
X-Received: by 2002:a05:600c:190b:b0:490:adb6:7957 with SMTP id 5b1f17b1804b1-490ec524ed1mr28332605e9.33.1781260805126;
        Fri, 12 Jun 2026 03:40:05 -0700 (PDT)
X-Received: by 2002:a05:600c:190b:b0:490:adb6:7957 with SMTP id 5b1f17b1804b1-490ec524ed1mr28331945e9.33.1781260804631;
        Fri, 12 Jun 2026 03:40:04 -0700 (PDT)
Received: from [172.31.99.182] (91.red-83-48-118.staticip.rima-tde.net. [83.48.118.91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea4a128csm68072655e9.0.2026.06.12.03.40.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 03:40:04 -0700 (PDT)
Message-ID: <4406fdcf-098e-4523-a441-5343bb22e667@redhat.com>
Date: Fri, 12 Jun 2026 04:41:18 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 11/11] selftests: mm: add mTHP collapse test cases
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, hughd@google.com
Cc: willy@infradead.org, ziy@nvidia.com, liam@infradead.org,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
 <fcf0fcc52aa6c4e18682fcb302fe9371a8d800c3.1781083630.git.baolin.wang@linux.alibaba.com>
From: Nico Pache <npache@redhat.com>
In-Reply-To: <fcf0fcc52aa6c4e18682fcb302fe9371a8d800c3.1781083630.git.baolin.wang@linux.alibaba.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oDp9ukxAswu3nQlsBY9kjFUZ1zgam2R-yhUeGlyS08M_1781260805
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3AC1F20002
X-Rspam-User: 
X-Stat-Signature: j4sjoift7te5twro5sofxjwgabzyee6j
X-HE-Tag: 1781260810-583381
X-HE-Meta: U2FsdGVkX1+wWtfORtEEyEuaICdfzCFEHmhoB2YrdGsVa0t7ebgMokLOYXUIkCRep0LvSDIQxupIaIRufMRteVkJDHZ5KA8316eu835ISu/RdjJZxuXEBRMTKMehOoawT/yvdLXhu9LKXxSjKus25nLYeiPppEf1YI1nuysTtlQdpKj6cTvSkgrdVgM2Yr8VnpoUYbo0oB1O9sYvv7jEwiX1WqEo0sPRPlqCD+6zhv0yiFjmP9ZjHqdkaUHmeIriCboehZ0ImqWaCSZYfGV8nCfkiz24Q8mAJH6hAZAxmOH3UTZifBMPhRRRw5OUetZ9A3jm0eEFMTb7NKiGD9Oth9qYCjz2M3M5qwqc5nTuD6/wlRe+0gQJILwT1jmAklGs67GsrJMdmFcwIzSPMiaESfNw+s7bQOF/4kh2I3dST0WD8QWgS2l6dWkjRvztYyUeLAxvsJQ7j3OuVZ7mFu94/wOqTZCiUVF8AQ2/99cdhA6A0zTWZNAhbu6NBfRWAwcDUeemRA5/GYlnix1zp7cE8JPTvDWkNb8Kz3TGl+m3UEBHdNDAQL+Op4ML/Mk1zX/BE/Oe2gYQC+Ysv1DTzg7F6/mnRSs4hte0/NBEb2j13onqLoLc5jsK+pQPBEle+Kd5MAAD0T6MWaBgDEW2PrcW0o4JumudTkcFEa+KkBZoGO4tm4cJt7MB+KRUjwrZv0OUnSU2WS2SQ/CZMaeX++dbtvO1gQggTGROBs9eqRUJiBFYN41vMJxeZFrPPWFZuNvpmr8vYVJAoE7w4VSsrf9GoQmn4mVf2scjBL3jdls6iWVu0CHQGFZ77o6Qw21LW1wTDzExUzp7CYU273zMYJ/aTCQucfaoUXKXR2Z++tFx0j50kVPjOdLbyBzFYqCgGCZX1NIj/+hBRQ6Lt8w5FX8RZFT+bBVMy+0/SGIkkS6k8jGU/qawT7BFyulYp7AJ7rlv5a/+6e/sXZ05QDcaeeL
 DRvCinQq
 EOkHp0p122Ddgm5oZh0jXvsg8CduVwJ93En/7OOy8vHBt5ZiKADVB1eWi9kFmRC3mI0D4CayvCLfr4iuJqQsyHBZOKixJUzt7XNPZrntVCLrsbdmbHANlYzWzOH4pKbYsmYyd72+u3ZnoGhZvLdI5FJnUvIHWpBp1EU+/RAYZzktdxlRMVW5KL7o75VY6GzySv6FhfnjS91zb0yILKfISzWoVPwtZ88no/gDkIFfN6EFxfn5Kj+uiU+DY+4L1I3sbh51o3fLRmgs4mFWGa9e8om5GcLxF3LUhGT4AX2/CjVaRsjwdGrZdtcFPpKDwjg33rW8fbFmsxb/gV0ZLXq/rCzaKZx4hHTqtkYLIf7X2EVZmOa0u+YwROdhfNCCNrxurGrztZ/wP7d97jTBc09Ok0tSnEZp52t4DyTc5T2OD4qohAQ00xxeiHCjW1teBHJchExoEQrjvu1jQ1so=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/10/26 4:29 AM, Baolin Wang wrote:
> Added a new command 'mthp_khugepaged' for mTHP collapse, along with the '-c'
> parameter to specify the collapse order. Additionally, added mTHP collapse
> test cases for 'collapse_full', 'collapse_empty', and 'collapse_single_mthp'
> for both anonymous pages and shmem. All khugepaged test cases passed.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Will rip out the Shmem stuff and test these selftests on top of my mTHP stuff
soon :)

Ill provide the diff so its easier for you and if I come up with more cases ill
add those too.

Thanks for doing this!!!
-- Nico

> ---
>  tools/testing/selftests/mm/khugepaged.c   | 135 +++++++++++++++++++---
>  tools/testing/selftests/mm/run_vmtests.sh |   4 +
>  2 files changed, 120 insertions(+), 19 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index f69be6be0ecd..8975be5b7b2f 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -26,9 +26,11 @@
>  
>  #define BASE_ADDR ((void *)(1UL << 30))
>  static unsigned long hpage_pmd_size;
> +static int hpage_pmd_order;
>  static unsigned long page_size;
>  static int hpage_pmd_nr;
>  static int anon_order;
> +static int collapse_order;
>  
>  #define PID_SMAPS "/proc/self/smaps"
>  #define TEST_FILE "collapse_test_file"
> @@ -69,6 +71,7 @@ struct collapse_context {
>  };
>  
>  static struct collapse_context *khugepaged_context;
> +static struct collapse_context *mthp_khugepaged_context;
>  static struct collapse_context *madvise_context;
>  
>  struct file_info {
> @@ -554,25 +557,25 @@ static void madvise_collapse(const char *msg, char *p, int nr_hpages,
>  }
>  
>  #define TICK 500000
> -static bool wait_for_scan(const char *msg, char *p, int nr_hpages,
> -			  struct mem_ops *ops)
> +static bool wait_for_scan(const char *msg, char *p, unsigned long size,
> +		int nr_hpages, int collap_order, struct mem_ops *ops)
>  {
> -	unsigned long size = nr_hpages * hpage_pmd_size;
> +	unsigned long hpage_size = page_size << collap_order;
>  	int full_scans;
>  	int timeout = 6; /* 3 seconds */
>  
>  	/* Sanity check */
> -	if (!ops->check_huge(p, size, 0, hpage_pmd_size))
> +	if (!ops->check_huge(p, size, 0, hpage_size))
>  		ksft_exit_fail_msg("Unexpected huge page\n");
>  
> -	madvise(p, nr_hpages * hpage_pmd_size, MADV_HUGEPAGE);
> +	madvise(p, size, MADV_HUGEPAGE);
>  
>  	/* Wait until the second full_scan completed */
>  	full_scans = thp_read_num("khugepaged/full_scans") + 2;
>  
>  	ksft_print_msg("%s...", msg);
>  	while (timeout--) {
> -		if (ops->check_huge(p, size, nr_hpages, hpage_pmd_size))
> +		if (ops->check_huge(p, size, nr_hpages, hpage_size))
>  			break;
>  		if (thp_read_num("khugepaged/full_scans") >= full_scans)
>  			break;
> @@ -595,7 +598,7 @@ static void khugepaged_collapse(const char *msg, char *p, int nr_hpages,
>  	if (!is_tmpfs(ops) && ops == &__read_write_file_write_ops)
>  		expect = false;
>  
> -	if (wait_for_scan(msg, p, nr_hpages, ops)) {
> +	if (wait_for_scan(msg, p, size, nr_hpages, hpage_pmd_order, ops)) {
>  		if (expect)
>  			fail("Timeout");
>  		else
> @@ -617,12 +620,65 @@ static void khugepaged_collapse(const char *msg, char *p, int nr_hpages,
>  		fail("Fail");
>  }
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
> +	} else if (ops == &__shmem_ops) {
> +		settings.shmem_enabled = SHMEM_NEVER;
> +		settings.shmem_hugepages[collapse_order].enabled = SHMEM_ALWAYS;
> +	}
> +
> +	thp_push_settings(&settings);
> +
> +	if (wait_for_scan(msg, p, size, nr_hpages, collapse_order, ops)) {
> +		if (expect)
> +			fail("Timeout");
> +		else
> +			success("OK");
> +
> +		/* Restore THP settings for mTHP collapse. */
> +		thp_pop_settings();
> +		return;
> +	}
> +
> +	/*
> +	 * For file and shmem memory, khugepaged only retracts pte entries after
> +	 * putting the new hugepage in the page cache. The hugepage must be
> +	 * subsequently refaulted to install the pmd mapping for the mm.
> +	 */
> +	if (ops != &__anon_ops)
> +		ops->fault(p, 0, nr_hpages * hpage_size);
> +
> +	if (ops->check_huge(p, size, expect ? nr_hpages : 0, hpage_size))
> +		success("OK");
> +	else
> +		fail("Fail");
> +
> +	/* Restore THP settings for mTHP collapse. */
> +	thp_pop_settings();
> +}
> +
>  static struct collapse_context __khugepaged_context = {
>  	.collapse = &khugepaged_collapse,
>  	.enforce_pte_scan_limits = true,
>  	.name = "khugepaged",
>  };
>  
> +static struct collapse_context __mthp_khugepaged_context = {
> +	.collapse = &mthp_khugepaged_collapse,
> +	.enforce_pte_scan_limits = true,
> +	.name = "mthp_khugepaged",
> +};
> +
>  static struct collapse_context __madvise_context = {
>  	.collapse = &madvise_collapse,
>  	.enforce_pte_scan_limits = false,
> @@ -661,10 +717,17 @@ static void alloc_at_fault(void)
>  static void collapse_full(struct collapse_context *c, struct mem_ops *ops)
>  {
>  	void *p;
> -	int nr_hpages = 4;
> +	int nr_pmds = 4, nr_hpages = 4;
>  	unsigned long size = nr_hpages * hpage_pmd_size;
>  
> -	p = ops->setup_area(nr_hpages);
> +	/* Only try 1 PMD sized range for mTHP collapse. */
> +	if (c == &__mthp_khugepaged_context) {
> +		nr_pmds = 1;
> +		nr_hpages = 1 << (hpage_pmd_order - collapse_order);
> +		size = hpage_pmd_size;
> +	}
> +
> +	p = ops->setup_area(nr_pmds);
>  	ops->fault(p, 0, size);
>  	c->collapse("Collapse multiple fully populated PTE table", p, nr_hpages,
>  		    ops, true);
> @@ -676,10 +739,31 @@ static void collapse_full(struct collapse_context *c, struct mem_ops *ops)
>  
>  static void collapse_empty(struct collapse_context *c, struct mem_ops *ops)
>  {
> +	int nr_hpages = 1;
> +	void *p;
> +
> +	if (c == &__mthp_khugepaged_context)
> +		nr_hpages = 1 << (hpage_pmd_order - collapse_order);
> +
> +	p = ops->setup_area(1);
> +	c->collapse("Do not collapse empty PTE table", p, nr_hpages, ops, false);
> +	ops->cleanup_area(p, hpage_pmd_size);
> +	ksft_test_result_report(exit_status, "%s\n", __func__);
> +}
> +
> +static void collapse_single_mthp(struct collapse_context *c, struct mem_ops *ops)
> +{
> +	unsigned long hpage_size = page_size << collapse_order;
>  	void *p;
>  
>  	p = ops->setup_area(1);
> -	c->collapse("Do not collapse empty PTE table", p, 1, ops, false);
> +	/*
> +	 * Only fault collapse_order sized ranges, and only check 1
> +	 * collapse_order sized huge page.
> +	 */
> +	ops->fault(p, 0, hpage_size);
> +	c->collapse("Collapse PTE table with half PTE entries present",
> +		p, 1, ops, true);
>  	ops->cleanup_area(p, hpage_pmd_size);
>  	ksft_test_result_report(exit_status, "%s\n", __func__);
>  }
> @@ -1081,8 +1165,8 @@ static void madvise_retracted_page_tables(struct collapse_context *c,
>  	ops->fault(p, 0, size);
>  
>  	/* Let khugepaged collapse and leave pmd cleared */
> -	if (wait_for_scan("Collapse and leave PMD cleared", p, nr_hpages,
> -			  ops)) {
> +	if (wait_for_scan("Collapse and leave PMD cleared", p, size, nr_hpages,
> +			  hpage_pmd_order, ops)) {
>  		fail("Timeout");
>  		return;
>  	}
> @@ -1098,7 +1182,7 @@ static void usage(void)
>  {
>  	fprintf(stderr, "\nUsage: ./khugepaged [OPTIONS] <test type> [dir]\n\n");
>  	fprintf(stderr, "\t<test type>\t: <context>:<mem_type>\n");
> -	fprintf(stderr, "\t<context>\t: [all|khugepaged|madvise]\n");
> +	fprintf(stderr, "\t<context>\t: [all|khugepaged|mthp_khugepaged|madvise]\n");
>  	fprintf(stderr, "\t<mem_type>\t: [all|anon|file|shmem]\n");
>  	fprintf(stderr, "\n\t\"file,all\" mem_type requires [dir] argument\n");
>  	fprintf(stderr, "\n\t\"file,all\" mem_type requires a file system\n");
> @@ -1109,6 +1193,7 @@ static void usage(void)
>  	fprintf(stderr,	"\t\t-h: This help message.\n");
>  	fprintf(stderr,	"\t\t-s: mTHP size, expressed as page order.\n");
>  	fprintf(stderr,	"\t\t    Defaults to 0. Use this size for anon or shmem allocations.\n");
> +	fprintf(stderr,	"\t\t-c: collapse order for mTHP collapse, expressed as page order.\n");
>  	exit(1);
>  }
>  
> @@ -1118,11 +1203,14 @@ static void parse_test_type(int argc, char **argv)
>  	char *buf;
>  	const char *token;
>  
> -	while ((opt = getopt(argc, argv, "s:h")) != -1) {
> +	while ((opt = getopt(argc, argv, "s:c:h")) != -1) {
>  		switch (opt) {
>  		case 's':
>  			anon_order = atoi(optarg);
>  			break;
> +		case 'c':
> +			collapse_order = atoi(optarg);
> +			break;
>  		case 'h':
>  		default:
>  			usage();
> @@ -1148,6 +1236,10 @@ static void parse_test_type(int argc, char **argv)
>  		madvise_context =  &__madvise_context;
>  	} else if (!strcmp(token, "khugepaged")) {
>  		khugepaged_context =  &__khugepaged_context;
> +	} else if (!strcmp(token, "mthp_khugepaged")) {
> +		mthp_khugepaged_context =  &__mthp_khugepaged_context;
> +		if (collapse_order == 0 || collapse_order >= hpage_pmd_order)
> +			usage();
>  	} else if (!strcmp(token, "madvise")) {
>  		madvise_context =  &__madvise_context;
>  	} else {
> @@ -1213,7 +1305,6 @@ static int nr_test_cases;
>  
>  int main(int argc, char **argv)
>  {
> -	int hpage_pmd_order;
>  	struct thp_settings default_settings = {
>  		.thp_enabled = THP_MADVISE,
>  		.thp_defrag = THP_DEFRAG_ALWAYS,
> @@ -1239,10 +1330,6 @@ int main(int argc, char **argv)
>  	if (!thp_is_enabled())
>  		ksft_exit_skip("Transparent Hugepages not available\n");
>  
> -	parse_test_type(argc, argv);
> -
> -	setbuf(stdout, NULL);
> -
>  	page_size = getpagesize();
>  	hpage_pmd_size = read_pmd_pagesize();
>  	if (!hpage_pmd_size)
> @@ -1250,6 +1337,10 @@ int main(int argc, char **argv)
>  	hpage_pmd_nr = hpage_pmd_size / page_size;
>  	hpage_pmd_order = __builtin_ctz(hpage_pmd_nr);
>  
> +	parse_test_type(argc, argv);
> +
> +	setbuf(stdout, NULL);
> +
>  	default_settings.khugepaged.max_ptes_none = hpage_pmd_nr - 1;
>  	default_settings.khugepaged.max_ptes_swap = hpage_pmd_nr / 8;
>  	default_settings.khugepaged.max_ptes_shared = hpage_pmd_nr / 2;
> @@ -1267,6 +1358,8 @@ int main(int argc, char **argv)
>  	TEST(collapse_full, khugepaged_context, read_write_file_read_ops);
>  	TEST(collapse_full, khugepaged_context, read_write_file_write_ops);
>  	TEST(collapse_full, khugepaged_context, shmem_ops);
> +	TEST(collapse_full, mthp_khugepaged_context, anon_ops);
> +	TEST(collapse_full, mthp_khugepaged_context, shmem_ops);
>  	TEST(collapse_full, madvise_context, anon_ops);
>  	TEST(collapse_full, madvise_context, read_only_file_ops);
>  	TEST(collapse_full, madvise_context, read_write_file_read_ops);
> @@ -1274,8 +1367,12 @@ int main(int argc, char **argv)
>  	TEST(collapse_full, madvise_context, shmem_ops);
>  
>  	TEST(collapse_empty, khugepaged_context, anon_ops);
> +	TEST(collapse_empty, mthp_khugepaged_context, anon_ops);
>  	TEST(collapse_empty, madvise_context, anon_ops);
>  
> +	TEST(collapse_single_mthp, mthp_khugepaged_context, anon_ops);
> +	TEST(collapse_single_mthp, mthp_khugepaged_context, shmem_ops);
> +
>  	TEST(collapse_single_pte_entry, khugepaged_context, anon_ops);
>  	TEST(collapse_single_pte_entry, khugepaged_context, read_only_file_ops);
>  	TEST(collapse_single_pte_entry, khugepaged_context, read_write_file_read_ops);
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index 8c296dedf047..c0f4f3e5f1f1 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -411,6 +411,10 @@ CATEGORY="thp" run_test ./khugepaged all:shmem
>  
>  CATEGORY="thp" run_test ./khugepaged -s 4 all:shmem
>  
> +CATEGORY="thp" run_test ./khugepaged -c 4 mthp_khugepaged:anon
> +
> +CATEGORY="thp" run_test ./khugepaged -c 4 mthp_khugepaged:shmem
> +
>  # Try to create XFS if not provided
>  if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
>      if test_selected "thp"; then


