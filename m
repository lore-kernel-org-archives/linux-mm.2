Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 182D4CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 13:19:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D3C78E001C; Wed, 17 Sep 2025 09:19:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 582E28E0003; Wed, 17 Sep 2025 09:19:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 471F58E001C; Wed, 17 Sep 2025 09:19:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 30FA68E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:19:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5140B9EA1
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:19:32 +0000 (UTC)
X-FDA: 83898798984.24.4DC6E2D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 66F274000C
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:19:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UxWaw7VI;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758115170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GnzUrOdcBemtX94K3X42zgRnlnpIqExLzJ+Ix1CFZmI=;
	b=5wCYrgM9uICVyiozYMZtJqKJtUhNlBsQihEvSEVGcbstk2TCmwhkydRXHKnbznHlcZD5C2
	JAmHSpkf2ohWv6gP7MyfV+Bj7AiU+WZLc3NgyOX4BDZDxo0DL3jWSWMZJnDGoEQXUUwbNT
	Q1OjG3JQLDx7hjOuU1fkQQGzA7rV+Qc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UxWaw7VI;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758115170; a=rsa-sha256;
	cv=none;
	b=4yDzziU2OApp+/UnPuD6x3jK1wdvmTk5ujDTjrEhKdqwkvNm8x9iDSjqv7WnvGaWEPGIAy
	56ncv/jlFWiTBTf57tmMcArtlV0momJrHJ5WDmCQ3cXz62VP5rWoV/vKFLHIgbbiDBIkr1
	LwGRaTRJuhDJcnHXQHC/wz6Ov+VL4AA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758115169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GnzUrOdcBemtX94K3X42zgRnlnpIqExLzJ+Ix1CFZmI=;
	b=UxWaw7VIqQODfzhCjtPOaq69AsilNsSsK4Oet9ovRomwcTs9C0UoL+6XYU1Omb9zSOXP2n
	E2bko8lrnYYy7+V6I4EN9s5uHvZ+HjP0pGgwYen6IGMDVriRwEWcczCyBJufPFM0+nRr5j
	cRLsV3cNnnsETLhuDBVA++ATRYqlGt8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-257-KiqAUQj8NTWmCHZHddx1Jg-1; Wed, 17 Sep 2025 09:19:28 -0400
X-MC-Unique: KiqAUQj8NTWmCHZHddx1Jg-1
X-Mimecast-MFC-AGG-ID: KiqAUQj8NTWmCHZHddx1Jg_1758115167
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45f2a1660fcso33353445e9.1
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 06:19:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758115167; x=1758719967;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GnzUrOdcBemtX94K3X42zgRnlnpIqExLzJ+Ix1CFZmI=;
        b=unzcOr3p3oVJI35nI5Ud2yUsguO+7Lbx3nJi/sG/KqcUo2bhcunaDR+UnkZ0x28H+7
         /ygIUqozjv30QHewO6VMce2xjXLo02hMNwr96PSxKdgjsnAOsjDO/6NVGeVWvHayevyl
         28Ce9bNK6ZlAlqMo4aJ6XbFs3cEQ/VD7hQvmo4E5QnYfhdQiHQMP3Kxg+YbfxLDYRh+E
         m1NbVqYGsNgJXAEscyUSRGICh51j6shTS8A/5C9rZiA13b2zG/3srkofsuOWgu+2SEOB
         j6Iv6tgjNCY08REvSoIjT/gqBhZrUV89lZ6k09d5Fpq8V0IONmUjIR/mtn4oVJ4JLH/k
         ZWBQ==
X-Forwarded-Encrypted: i=1; AJvYcCW1abJwWcmrzzIAmMGhMhuXARD3Oj2XkdWzYvvkZ6uUR4Jf0B5JooRWWaXsv7VBKRQfhzSqZteikg==@kvack.org
X-Gm-Message-State: AOJu0YyxgOjYS81cKqJt+OZR16EondKvtHwIHE1gjwYlCcUvnL7p/6Nj
	5Q0YwtD+AY/txZkECwVY7TpfhX88uKNSOzpiJ+oq6VMfBa4VeyRFD6gz5Fq3uonmbU27JDNiUjG
	DjtUOxbVX8+n29FVJU2+to2pT5FkiSLAE0MmQYBvIqbNMwzb3LpVP
X-Gm-Gg: ASbGncsCsV5SEpSd3dZCUYuwPE8qmn9fss5gHFUiYdd7dDXMwfQWrorhygy52F8ppqG
	+RiC9yrWevbW9crflVFe0ol2//2fwF7c48de1sVfcHdv9tT67lWh8pn/bO2sQwvXCPR8huNPP/L
	mojE36IbSh2cYrg+ulst6jbG3zFhYO6zzj3wK77YuiOIooSfBoXyeH9N2VyIP3ytfYwoXsmOdAY
	J/LzmeS7oXE53zR5czpf9w29NwGSq2lLV0BekQYFKVODNtaZ8jlpx941AW0i3xODNcesy7BYIHo
	xG8w9+h6rjVnWdYm6hDcqZVB5LdAj8C2nY4+Ed9ULN7/nxeH9ilb0ApvpiwiGYa2VrB0JCBFjRV
	TbDygL2NylHJjW2RplkNqmraTnyRVT/XxB0C+hoqOvE8zhUDOzht0bOeeVeNu9uVT
X-Received: by 2002:a05:600c:680a:b0:45b:83fe:9cf7 with SMTP id 5b1f17b1804b1-4625a2e5059mr21772365e9.6.1758115167076;
        Wed, 17 Sep 2025 06:19:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHbHkHsqmSE1TzQcAUHd1ErKND4A6lwO0ygnBDKXF3NTBgJ2UsMnDHnhZBoD2TXSixnzV02Ng==
X-Received: by 2002:a05:600c:680a:b0:45b:83fe:9cf7 with SMTP id 5b1f17b1804b1-4625a2e5059mr21772025e9.6.1758115166573;
        Wed, 17 Sep 2025 06:19:26 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f27:6d00:7b96:afc9:83d0:5bd? (p200300d82f276d007b96afc983d005bd.dip0.t-ipconnect.de. [2003:d8:2f27:6d00:7b96:afc9:83d0:5bd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607cd0a7sm25851981f8f.39.2025.09.17.06.19.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 06:19:26 -0700 (PDT)
Message-ID: <d4988c21-1e1a-4de2-a1c0-7d78525d2939@redhat.com>
Date: Wed, 17 Sep 2025 15:19:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] selftests/mm: Added fork test to verify global
 ksm_zero_pages counter behavior
To: Donet Tom <donettom@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Wei Yang <richard.weiyang@gmail.com>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
References: <cover.1757946863.git.donettom@linux.ibm.com>
 <5910cb6bfc7c43b169b679a0108667a56d7ebdb8.1757946863.git.donettom@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <5910cb6bfc7c43b169b679a0108667a56d7ebdb8.1757946863.git.donettom@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uET8L0xY9vL1ABajIh9ntzoR-jH5r6rVSmvgHuJf9Cs_1758115167
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 66F274000C
X-Stat-Signature: z85f7t8u8e1csmfxxy9fhn8qcczwhqt5
X-HE-Tag: 1758115170-77532
X-HE-Meta: U2FsdGVkX1/Ht9LoEKx08LtJeGpd9yLqNdNOJv03qFV4GIkAfYxQBut3xInZdvCmN01/jxt/fc306MdzZq7XBhXlc/bOJCrqCACavURqJ5hvLT5CQBdUHa34KEGb+uNXE466lIA9Fd3GWmFIR+e6VOdy5FgyeQZwcu/uapxLwdiBGUL/X7s3jCVvG3fqA1BeZ+2rr8rQK5LPx9cciGHEV694QeCCon8nm49Q/HwnSuhyiDd91iQjBWMCDRPKKt+BvvuX3Raf3/T0VeeoS49/HfLT2j2FNjUkPPB9YsySnpyLoRYU6iAe+3sbXnI6eZv+Gl3zClOdVfeng3nO+64c04bQ4Lx1oT5hblRjvetjEHqdMStOmoY3VMqdV9SnQzf5dEWjzwY6c5ukgHl5knY/mcsQ3NR7LNLQTxsx0DDSbV3XaED9yg2oa8SYodkvsv/8yHCZeY1XUOLhsE7u/lP/UpuRjbWmP6ZZTThY2AUzThtw1Dd9sGRByvg9V1Xg4S7LvRwlsyIhMM05aNkDC6q9mwvSuB4lfifRY1qCpdC9PZcwujCuZtvj6WNGKt/Py4t8YKsWLTBAoA2xJ9TL23tDfJZcnx8LpBJUJEcj7moWq4tn06xjczzWfw9O5p3ySR8TyIUSmdwrCZl81OcrRyzrjIFf95h6B9J48lCDdA0j0rLcbSugL+NfyPtLqsnkKHZlK2+63vldlSsDuPhIoqmdJFO7H+9eO8vAicuenPIqGSwdyUQbg9vDYjMqoFfr03s9V70RK51tHwwOwzUJLIbt7haeowTKR7tCt09l1nIdMJXmjsMCCizDxXyciI3d0iEyv7ds7egYwo4iFmU6swfmtkH+zTSH1ORAcJpQ8AXbw1aIAzHADUZqOAiDyl9V5lLzmx5+J17YbS37ryJ8G317T396rrB8fzbho/viGymleSEcmG1JqJYqC4TDBFVNY4EHDBMO3imy3T/JtL+Iz4k
 eSbDMch9
 WBEZYw/+WQLPvx5AmHes74I4XScq9KzDyyVDUyAHrytKCXpj8/nRlSQc9YoxUPW0JQJTlZzATOY6O69QYBtbWEq+1taP9ihQ5L+a106zxp2MXlqUit3QSIfBHTqilwht4k2CciB6BPtri4qSgFF2msySh9XiQ5UYcXiIZkn2s2wVY+ILS7v8aUynRARpf3/cUyYW3P24/WiGpEriRjdgY75ZDuGXVMEttf7E2C2xHwZ/HDNK8EZ/USu9VZl8EAYkMFsw6BSjb/ZH6M8GwkZ5EdZXQkc/BSAvuU2pucytOjhA5b0Ot0v9LpI5ahUnHET4U+4emZJr/hAsTEtdRykwDC8ZBmnmmzmovhe/JJTCnDi9Rx5AJoHG+4qqffB2yR9s0CNKnBoF2KpwtnIvmqIJEaaWZhwPpqjKBm41+B6GovHGkyLnWOQJOeKDRqe0kebm7jV1PHl1ZTe8D5TQTr600bz0ZUhCsJ4GW9nvhTt+6zUXfxPYqE+dCco7e4cRz772RyWUfuBkoslLxlUslBUC6rz2hXXaIcwKQDVxwyp7UKn885ZOMYYRLzlTHlgTxsf7aeopU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.09.25 17:03, Donet Tom wrote:
> Added a selftest to verify the behavior of the global KSM zero-page
> counter during fork. When a process forks, the per-process zero-page
> counter is inherited by the child, and the global counter should be
> updated with this inherited value. This test ensures that the global
> counter is correctly updated after fork.
> 
> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
> ---
>   .../selftests/mm/ksm_functional_tests.c       | 74 ++++++++++++++++++-
>   1 file changed, 73 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
> index 645cefba2126..f23597ac8066 100644
> --- a/tools/testing/selftests/mm/ksm_functional_tests.c
> +++ b/tools/testing/selftests/mm/ksm_functional_tests.c
> @@ -602,6 +602,77 @@ static void test_prot_none(void)
>   	munmap(map, size);
>   }
>   
> +long ksm_get_global_ksm_zero_pages(void)
> +{
> +	int global_ksm_zero_pages_fd;
> +	char buf[10];
> +	ssize_t ret;
> +
> +	global_ksm_zero_pages_fd = open("/sys/kernel/mm/ksm/ksm_zero_pages",
> +								O_RDONLY);
> +	if (global_ksm_zero_pages_fd < 0)
> +		return -errno;
> +
> +	ret = pread(global_ksm_zero_pages_fd, buf, sizeof(buf) - 1, 0);
> +	close(global_ksm_zero_pages_fd);
> +	if (ret <= 0)
> +		return -errno;
> +	buf[ret] = 0;
> +
> +	return strtol(buf, NULL, 10);
> +}
> +
> +static void test_fork_global_ksm_zero_pages_count(void)
> +{
> +	const unsigned int size = 2 * MiB;
> +	char *map;
> +	pid_t child_pid;
> +	int status;
> +	long g_zpages_before = 0, g_zpages_after = 0;
> +
> +	ksft_print_msg("[RUN] %s\n", __func__);
> +
> +	/* Unmerge all pages before test */
> +	if (ksm_stop() < 0) {
> +		ksft_test_result_fail("KSM unmerging failed\n");
> +		return;
> +	}
> +	/* Get the global zero page count before test */

That only works when "use_zero_pages" is enabled, no?

> +	g_zpages_before = ksm_get_global_ksm_zero_pages();
> +	/* Let KSM deduplicate zero pages. */
> +	map = mmap_and_merge_range(0x00, size, PROT_READ | PROT_WRITE, KSM_MERGE_MADVISE);
> +	if (map == MAP_FAILED)
> +		return;
> +
> +	child_pid = fork();
> +	if (!child_pid) {
> +		exit(ksm_stop());
> +	} else if (child_pid < 0) {
> +		ksft_test_result_fail("fork() failed\n");
> +		return;

Cleanup missing as for patch #2.

> +	}
> +	if (waitpid(child_pid, &status, 0) < 0) {
> +		ksft_test_result_fail("waitpid() failed\n");
> +		return;
> +	}
> +	status = WEXITSTATUS(status);
> +	if (status < 0) {
> +		ksft_test_result_fail("KSM unmerging failed in child\n");
> +		return;
> +	}
> +
> +	/* Verify global zero-page count remains unchanged */
> +	g_zpages_after = ksm_get_global_ksm_zero_pages();
> +	if (g_zpages_before != g_zpages_after) {
> +		ksft_test_result_fail("Incorrect global ksm zero page count after fork\n");
> +		return;
> +	}
> +
> +	ksft_test_result_pass("Global ksm zero page count is correct after fork\n");
> +	ksm_stop();
>

What stops KSM from merging pages in other processes by accident 
concurrently and giving false failures?

Likely you would want to stop ksm before the fork.

-- 
Cheers

David / dhildenb


