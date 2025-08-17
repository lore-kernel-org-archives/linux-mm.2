Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3D2ECA0EE9
	for <linux-mm@archiver.kernel.org>; Sun, 17 Aug 2025 08:12:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DF9E8E0037; Sun, 17 Aug 2025 04:12:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B7EC8E0035; Sun, 17 Aug 2025 04:12:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A64D8E0037; Sun, 17 Aug 2025 04:12:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 17AE58E0035
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 04:12:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4F7201DDB63
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 08:07:09 +0000 (UTC)
X-FDA: 83785518978.13.28C09C7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id EF1E0140005
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 08:07:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="hWLb/CQG";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755418027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oXCR6jx4ey42aR655U9PtXbjqfLl2uQopYEZjH9HCRE=;
	b=g45gvF7IRFICUXEmiE3KtwnSZVHsCADLaFHBUkKFV86j8lMxsO+rFI8O3Qs64jIRUm/csr
	Ka9hH1IGa7XvALd7zgIc4pui3cH2L2nsj9urvSqZuT6Z2JqAJEpusxY7CtKh3MEjLNxKQU
	8j4qrNjY0q/Tzo25z/RzWi4tmrvm8ds=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="hWLb/CQG";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755418027; a=rsa-sha256;
	cv=none;
	b=00bO9hRPmTyXpija8T7R9T9CvZtUd3a3DDqf7/we48RGHv3C1Q4707ENX8juO5kawto/bs
	Sqn+piibedHIjJq5hmwzyH0TIE0wuPS+rpanDFh2psS84ffrvG3iKDTQZmn657bYFghkc6
	XkgE9Sb3CX1kc7zHONeBueUhG4D5jOw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755418026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oXCR6jx4ey42aR655U9PtXbjqfLl2uQopYEZjH9HCRE=;
	b=hWLb/CQGIkrwEU5tk5zHjoDHW4IRAQ7DiFbof+cDPlHzAs8vu27XI5rzL6fSAo1S88jVSM
	bgDxx0do+depZf0n6bPERMkMTUkcSSjcZThTXnTO3tbsiNZ68tjSaoVFamouQXYsM7jsw3
	wSYpqY1e78w0RncFALEkamyePmgTEO4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-686-2-q_6UvnMvK2-DfNm3GJFA-1; Sun, 17 Aug 2025 04:07:05 -0400
X-MC-Unique: 2-q_6UvnMvK2-DfNm3GJFA-1
X-Mimecast-MFC-AGG-ID: 2-q_6UvnMvK2-DfNm3GJFA_1755418024
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b005db5so16179675e9.0
        for <linux-mm@kvack.org>; Sun, 17 Aug 2025 01:07:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755418024; x=1756022824;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oXCR6jx4ey42aR655U9PtXbjqfLl2uQopYEZjH9HCRE=;
        b=G0Y7LUKGwb3Cx6e1UQbBLFmMh30G7Sd9GWGsZ7JGXbqqsQNc63+XMh1KV5BrikiHt8
         qaZK9+BTKhs1G1/wMGEwMO+sfH+eIypM6Pr7zyWknbezwAMAQItHgLvQbbEqzZ5O7n6s
         qdGndtAf3GQp2fv5YjCP/r5GP12OYoYztCLbBcloh/85GgYNPGN8wPz1EQN4y9l9mG+n
         OzrydC/8j/xuDZazDb9O/nJkrRJ4GIKY7OV4j/crBAX8a28aucbBl7XMFGkFOfPNWc1b
         uPBQFl7LLZb1O7qUpoXV38+1XqvJbJTmWX/VTIyRVD8eUg7WMKkFdqihyVR0nzix920y
         1wFw==
X-Forwarded-Encrypted: i=1; AJvYcCVgfgm7N8SZyXB1DyYf1oNRO7obexYGjfHH2LFkUayTbmlqtE0cBOSHauBZ994AVmrLNHwyJTQS/w==@kvack.org
X-Gm-Message-State: AOJu0YzizeLog5YAvhLLehMisqQ6XKSIHW70NwvRDZPtcxjsIi+LyayY
	/VU1TTUGmwO++Ao+MmMm9GFD9EXDNV6i4UpdQ3YT6SSlsrT930l01vfyte9KXnxDWDH2wuLHsJL
	bbiaAbv5fmCeD+3yi7zV+eZGxN3kNh/iyofVhYD5tmKw+MVCoZ3ih
X-Gm-Gg: ASbGnct7KyNN5ciak/0OKOKWz1dSku5aaIaDAPY1a39JYuBARn33DcrHwvfefKpK2m/
	OyvKvfxLDEYeBTDpnwxNA6SjRaGDdZ9VA4fzkiajk27mAuUlXjXk9p2rd2VDJP011djsv7kXHqG
	iYZDS14G13ExJyI57zWMPIZIQnmfznU4xkGNFjQxv8nBU+UGRKJRH9q5wiLtz3g/AGflplx1hCR
	NGUtzoo9Ws/L3Mri3ta3TNo4wsIPzk2W+G+9m6yPqJNHu6mi69uE4wLgTczZVLs0N/aoqSpB5Oi
	Z3TxO1cJX9YM5h2NwohgHtLgNbnOlriSQ823WI5rCRIegeD37RD2GVXy94IimBED0AlOcyYQH4Y
	L6RfpEpZSB15sIQ7eIxi0bCxa0fMGzA6n3Yo0Ri+2/eXIX++Ey1k0W/fZRXdEwQ4z4gE=
X-Received: by 2002:a05:600c:4f89:b0:455:fc16:9eb3 with SMTP id 5b1f17b1804b1-45a2679b098mr31050515e9.33.1755418023901;
        Sun, 17 Aug 2025 01:07:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IELs9JlOUQoCDAv7GOq3qlfRmrWqshCbe5IY8nTGKMjFukcAnSW5YEjUHnLDr5jRqTIMYyWXA==
X-Received: by 2002:a05:600c:4f89:b0:455:fc16:9eb3 with SMTP id 5b1f17b1804b1-45a2679b098mr31050285e9.33.1755418023465;
        Sun, 17 Aug 2025 01:07:03 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0b:a400:87b2:80d2:3e99:1b85? (p200300d82f0ba40087b280d23e991b85.dip0.t-ipconnect.de. [2003:d8:2f0b:a400:87b2:80d2:3e99:1b85])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1c78b410sm127199905e9.24.2025.08.17.01.07.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Aug 2025 01:07:02 -0700 (PDT)
Message-ID: <fb4d74b9-a92a-4040-8d3a-09c72db3f35a@redhat.com>
Date: Sun, 17 Aug 2025 10:07:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/7] mm/selftests: Fix split_huge_page_test failure on
 systems with 64KB page size
To: Giant Sand Fans <rampxxxx@gmail.com>, Wei Yang <richard.weiyang@gmail.com>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "shuah@kernel.org" <shuah@kernel.org>, "pfalcato@suse.de"
 <pfalcato@suse.de>, "ziy@nvidia.com" <ziy@nvidia.com>,
 "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
 "npache@redhat.com" <npache@redhat.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "dev.jain@arm.com" <dev.jain@arm.com>, "baohua@kernel.org"
 <baohua@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "donettom@linux.ibm.com" <donettom@linux.ibm.com>,
 "ritesh.list@gmail.com" <ritesh.list@gmail.com>
References: <20250816040113.760010-1-aboorvad@linux.ibm.com>
 <20250816040113.760010-5-aboorvad@linux.ibm.com>
 <20250816143129.u2rdwpwvfhsdptvx@master>
 <CABPJ0vja95qLmJA3uRa3MhCfDX3GoLJ6MHu881Z=sZuVdBbbEg@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CABPJ0vja95qLmJA3uRa3MhCfDX3GoLJ6MHu881Z=sZuVdBbbEg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BMdd0KbawkTAyY-M_MNLlTkYMVFP4_bcSodZ991L9u8_1755418024
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EF1E0140005
X-Stat-Signature: 8yqm61iin33iou6845wme9excy59ajkz
X-Rspam-User: 
X-HE-Tag: 1755418026-308450
X-HE-Meta: U2FsdGVkX18pNeGb6NcpnaZcVz0URsKCZeqCj+umEPRcSd9MYKRJj5gqAJlI4Ubj6Lzh++sor/MseXQk27wZtlynJAoKK1AZzVrzitrf1j/jwdf+XvV/EyRcAb3HrmFSMeRsEpo2nfG+Rwzh2E8tR9Yqg2am0vKIMKl1d0CHPJ0RASecbN5bLF9cKpyVnbORVjVpO18KdhcWpqPRU7r+p2z2S1NuLhUsPh9gA2LdBoGez8Dm37CiAjFgSMBBwwzRH6zttloQpkqloLzoHcT25M/U1KJXlWStQUrr+e56n+r2n8zIkI4CgREmjClSGE9BYjCxfV4C5jguYus3V9/xYN0MLtZ8epLxfICNGCuoqwZvVvu1odYfc89B2jR2DUEIFUvhKvTSe15laJXsgoCbKgipaKdgK9w4piO0InXuL84vpo+Y2+7cjPAh/uhcwbigzSXmy7BJo4gnHY3V61JYe19L9qbbBiEBtBcUT8TgWb8zbBSqYI75PL3Hke+4zUuQTfWosKdHQJznoNeHhb3C+IrAGwCsNmHRZL1stMjDBfWN2yajqpE15SNC0jKXDHmyKXAqcgjOM9RKETKw1fBmiBO7vUYhaV+gfV6UUWdch1P2zFJF2dYo8UtVvIJqO5AuRZm2poFuE8vrckOF41Vu0NicR3t4Sj3TkCQZ0dL8caZoeT9KcgQgs83B97Sjf26Bxvo/QzcFrbt2A23tgRqM8pcPtYa47771IudD7gAIagA3Nd+Ufolh9PL3vs7jZOX4wA4zhJ7mRyMrw/Z9/Xh8KnFHrzhk3ndGObYUm4guzaIyK2Cu968mZdfQkvXKbJywfnoAIUey10cuDv61w+5bh7O9tvkIgGk17i34eIrWIeHBrWZBtcHthVGtr+B2PL8orC8EzEMAIe0dIareW/7Msf3AiZgs06KK2e8z1hoNMUqTqNXgiUmuxaim96i5gb6Wvzg4c7yAfwIzlo+YJru
 dl8vLnEQ
 QogaILQbyDTa1CkyxupoNrVUCSV/Q4/dz6bHTFRpsLh4u3m7sx+9vZrJvD4e+5KBa31s6NkYRnkeo2rxUQfWHnEDLuTTDW7DMdD+BPGa4Rs7uXyMEx+UbtpGT/UnIk2/IxPbtuzHvkJRtuSzg2UPHBu/Qq0oW6LLCo3rRgc1YpcYngDIdXyDkRtfTQ6KztGnhr9XEr9SCvsZvY9e2NCQ5TWr23kEibaL9Ds6P7eA1tHyX2TVCxEn6gvSXXtagtIPhTiYmo2y00K3FwxNadNYKfg31tkCYbTCMk7RSk4Znw8YtReaU71g/aIKmXeruwhipQFY1mSU2AgSqBWy19s5TlLV0aaPTMtmAxE2aW4ve7tbWiTeynEDJOMbh/IghOSlv79nxo33fqmg5qjdNae3EQ6ei2Jhz971Q6FrcbOtgW4FanZm8nPekVorfm1nxqD0MpmrvHCa4Lzc7CqVo9/lDxJ3arnA2ZCts2Amob64FdamF0KNt6brHw4LHCQzw69pgxXelhIe6N/DlKPOsp6E8u5Q7BIGGa3W6V7BI/0BZcF1r9ds0OJ1Q4vY5XVqejoUvXY7mGSl7yElTemBfu5u15KveGh4OS0/GURmV8qv5CtxMMi4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>  >>diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/ 
> tools/testing/selftests/mm/split_huge_page_test.c
>  >>index eadbeb820d71..7cbeaebc9d71 100644
>  >>--- a/tools/testing/selftests/mm/split_huge_page_test.c
>  >>+++ b/tools/testing/selftests/mm/split_huge_page_test.c
>  >>@@ -523,6 +523,9 @@ int main(int argc, char **argv)
>  >>       const char *fs_loc;
>  >>       bool created_tmp;
>  >>       int offset;
>  >>+      unsigned int max_order;
>  >>+      unsigned int nr_pages;
>  >>+      unsigned int tests;
>  >>
>  >>       ksft_print_header();
>  >>
>  >>@@ -534,35 +537,38 @@ int main(int argc, char **argv)
>  >>       if (argc > 1)
>  >>               optional_xfs_path = argv[1];
>  >>
>  >>-      ksft_set_plan(1+8+1+9+9+8*4+2);
>  >>-
>  >>       pagesize = getpagesize();
>  >>       pageshift = ffs(pagesize) - 1;
>  >>       pmd_pagesize = read_pmd_pagesize();
>  >>       if (!pmd_pagesize)
>  >>               ksft_exit_fail_msg("Reading PMD pagesize failed\n");
>  >>
>  >>+      nr_pages = pmd_pagesize / pagesize;
>  >>+      max_order =  sz2ord(pmd_pagesize);
>  >                     ^
>  >                     extra space here
>  >
>  >>+      tests = 2 + (max_order - 1) + (2 * max_order) + (max_order - 
> 1) * 4 + 2;
> 
> Is it possible to have some defines here instead plain numbers?
> Thanks

I assume we should look into using kselftest_harness as a separate 
effort, so we can avoid this manual test calculation completely. I'm 
afraid even using defines will not make this significntly more readable.

-- 
Cheers

David / dhildenb


