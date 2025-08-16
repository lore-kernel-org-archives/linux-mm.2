Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC0A7CA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 06:24:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31DDA8E0236; Sat, 16 Aug 2025 02:24:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F4898E000B; Sat, 16 Aug 2025 02:24:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E35F8E0236; Sat, 16 Aug 2025 02:24:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A7B58E000B
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 02:24:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8B20E1177DC
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 06:24:17 +0000 (UTC)
X-FDA: 83781630954.22.853AF2E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2246210000F
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 06:24:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NXDR3NjA;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755325455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p1AiogaXO4KDpvqOf8z6X8E09Ih613U1kMZd3r/QYjs=;
	b=1F/0r9yDpLgz1HaMijQArsdox+PxnX8zCPKsFZAzKVSGsqVI+3va7u/blKY3x0W8wC5Qpp
	welXoP/USHvqcNuhTmlJkIxfF/FZW0Y5vRzBO1FJs6h9d685wSyR5+S22B7dRu4xerQqCs
	/mXdQiqAXJHKqXeZIh4U3e0pMHieIHU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NXDR3NjA;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755325455; a=rsa-sha256;
	cv=none;
	b=feywkMgy4hH6Wl2gOVF/kcehtlmZRWgdzRUw7xLmAMZNfRUzzFjah9fi6M8NPd0EpHoPEM
	RCq2ocnSKYV/q1vwd3RcbdVTzvnTLcJ7zYn/h7I1t/PoOUhMAM9jFaggQnGWDtCu/Xqz9k
	XEsHoFqVJtlhyHP+2hbiCU/yTVzZb4Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755325454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=p1AiogaXO4KDpvqOf8z6X8E09Ih613U1kMZd3r/QYjs=;
	b=NXDR3NjAK4DcxiK/Vo8Ll7mUFw15t2LbBZHQEh7Vq6cxWo2x2LoPD2hrrnb6ShjjtSo4BF
	EkGe1I2jQfY8qtSgiZYTuCgZ6pya6XMnSyFQSDTYUKqWJAyOkPx+SpQf0lRWQMB2qj2DxN
	GnVzhNjdNOSCh/8CF/wfy5ABOrTA0ms=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-220-cNwbDtRcNQKMEOYV_awHMA-1; Sat, 16 Aug 2025 02:24:12 -0400
X-MC-Unique: cNwbDtRcNQKMEOYV_awHMA-1
X-Mimecast-MFC-AGG-ID: cNwbDtRcNQKMEOYV_awHMA_1755325451
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b9e418aab7so1319295f8f.3
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:24:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755325451; x=1755930251;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p1AiogaXO4KDpvqOf8z6X8E09Ih613U1kMZd3r/QYjs=;
        b=YvwQEgRbNYqUf/olp7RQLUx9v/6kDW//PynbPG+5eYMP5IljQl7lN6l4RxzNxaNo9D
         6d7xRuV6h/UnO+jjjN6x/D8HmG3cGC29jGYHuin8RXXtDeLpBBUIsuIG3n1t0TO96Grf
         sJlEAvq7elXsDoSIE5KDjeM5lZBaQ7f7S8CoVLam1fFkRoK514ZG6g6ukDlPKBs1eHJi
         6YSgehjZDP3pkdpZV+b5gJKXBIr+ovsYv8i4OQA2pm3XUQIf6dNqUA7G8uXBCul5Rdz5
         oNGNN841vQySKxoNXdgrgIDFvbdxC+T2HeHCy3bvbTehq+vpmZFUMSQOT/yScDEUqu8X
         34Sw==
X-Gm-Message-State: AOJu0YxJEgLT5bNm7NvQ/Moc4MOw+vQ/qghjoeBr3UzYHaoO4b1tKdQj
	qgxMgHzjNg8oNogWg/vnD6VgUwFoAsH9MeZnaUGsFVTQytf+yaaUrQPcKL+KZr51EguPfzcUk6u
	J6fFckz2pKVHIMlXrDY5A88mTlBZs2qMXBXUYTchf9EMhJm5Zqffr
X-Gm-Gg: ASbGnctHj+eJKw7vAO0uWWhtJBfkGwJuitzeCFnMWbZTnzQvZWpiPR95D2jPbOSDskl
	93Vfb4Bt5LPyBn/DSDSfklHN2+2w+hPst0bnGfrEbKW/VUkcMBThwj5VjQu2dVmte+rSz4sZ6dh
	hD5p4RxSHCV0NWzM95V/A8zwt+Ye33C30LsHhqRc45Sp6njvWla1eujFfW2VqXb6R08UO9NizLT
	lkvDwvIitoa+9JhENkUwuJ14KKTUEm01XwzmZ7HINbtZGbh8BN6zHrOJbAoMG7DPpSuxMnvb/M/
	xhkK9F+b8e0MDQWtO742//5ktodtKz38lwuif5h9rlyiCh3iKTGXMBjIQ241RDJCowsUWlvrHR7
	efPxnN7WwFXfGHLFne7ghjvbkrt4T0ARWUib/hDo4oCGOXTX4jFZZJDn0UCN05UIHpmQ=
X-Received: by 2002:a05:600c:4f91:b0:450:d37d:7c with SMTP id 5b1f17b1804b1-45a2678420fmr10232385e9.21.1755325451398;
        Fri, 15 Aug 2025 23:24:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFSIospP340Ezkww18kd7aUrmmiQWcd4pTR9W4fP9PhEqEg8ffXiYj3nkoM5w1sMGhQv7pE/Q==
X-Received: by 2002:a05:600c:4f91:b0:450:d37d:7c with SMTP id 5b1f17b1804b1-45a2678420fmr10232105e9.21.1755325450984;
        Fri, 15 Aug 2025 23:24:10 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:c700:d8ae:41bf:492a:9e4c? (p200300d82f23c700d8ae41bf492a9e4c.dip0.t-ipconnect.de. [2003:d8:2f23:c700:d8ae:41bf:492a:9e4c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a223197fbsm45975695e9.8.2025.08.15.23.24.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Aug 2025 23:24:10 -0700 (PDT)
Message-ID: <2aaa9982-48c7-4461-8be8-1427d9ed3f3d@redhat.com>
Date: Sat, 16 Aug 2025 08:24:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/7] selftest/mm: Extract sz2ord function into
 vm_util.h
To: Andrew Morton <akpm@linux-foundation.org>,
 Usama Arif <usamaarif642@gmail.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, corbet@lwn.net,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org,
 baohua@kernel.org, shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
 Arnd Bergmann <arnd@arndb.de>, sj@kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com
References: <20250815135549.130506-1-usamaarif642@gmail.com>
 <20250815135549.130506-6-usamaarif642@gmail.com>
 <20250815231549.1d7ef74fc13149e07471f335@linux-foundation.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250815231549.1d7ef74fc13149e07471f335@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xEhA_yo5DG3xxklVxlRXknPOLwyiP175RWlPBJ-WPYs_1755325451
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2246210000F
X-Stat-Signature: zsuyruadkikqttesuexx7opxraqb7f59
X-Rspam-User: 
X-HE-Tag: 1755325454-459541
X-HE-Meta: U2FsdGVkX18coZdlEWY7314o9atkLkHkkhHZ2KebqVoM84K33njheVnnnQrmxkgyvfPGWvH0tLVakZE+j+y6T1r2HjTwUMSL7VO6xCbtBKzv28GUIXOC+pz1VK3PAyJ9k3MidzzH4E41GV/uSdA7Glve1RJMb6lrIr4kPZZJSFXolMrEjlwM9xUotYDzdXFTv9NwpNdPFD29Y2AElFczZHBfFdZF0sP0sNoMLqE3CixaRvBkBpObpxrLQLsylg1W81N6zsNhmVzANmmMqMDY+6mQpJCqJfKqa88qOKliCdnQj8pw9d3aCZj9dnjQEsooBjYbY0eJ1Nk9YZ9KeCul1GjjMZ6xixih8rcnKji2JAF/c/iWze7gJgA2nHoiDnbzCAW8hvSvDrnIBPpFUCfwVW4hPoiL/ZyXSnLV9MaLg2LY4F/CpSPY5giJdIKyq81N1HdBgZN4BpTi+R4vSiOJJuxOExoOSm5Q3ip+CfQfe8LsdR80Xj8Op/xdijEHnfK7i+VQODtS7ZQTLNgy9wdzk5Z+UGAMoRDi3S9NI7v+Q5ezOCCYNF1ZP/3Bz7lexHYtSsvJcaNUgxAowRSl3o4NujnaWETtZkO8K/BhI4aWK2/dx0/NJhDo90h7iCvb0gHNRrJl58rhJOrKheGgsYIz7UiOo65Pwqy/N0a+oydMwY6j5mVFFaaZTikjEr6WUoG0lN8fZMmhVoX4ibexqmAEJjFyPQ13EY4aBtNT8LYUNgUxH+xQpsqHpXB55MnUmMgkkx8dhcS/+LaNUZus3gtY+UP4srSGN5EhbULkpRbhHr0MNvFPxPXKUNokgMWJ0CXLXsT/sGYI7+fq3lQ0GlGR8afrnts2VJR7r4bASpufEoUiE5RhqJcHikXZrAr3PkSSgDANOCZynI5OkNBUqOZnT23dZTZe0cOWErehkx+/ThJzZWyPG5VOIGM+/ARtbKF3PqojIzPgafCeJ6ptdo9
 qn+zPDPR
 MQpIPj/QI7L9imX69K5G+LuLut5PaxgWzMgTn6wgy1ck2QyyAnLtgty7r9wY/PFtoj9vtm10E7PqdFKv6gJ4+BfIWJoZuwCED7ldh4ON1SOL6KHXs+x7jC3cO0i/KgcHKYc8HbI2bvDNZoljM2erlKvBOiIBGMbn1nXE1DOwz0MfWRaVPT99qc6kmLPzZwmWLxhNal5dpheioze/tby1HJzHBH1dRkqJdDzeA+4pd9Elsr7TFNac1x3BvI+mNwLK8FbwuZn2CnYpX2Zi/BAUZHbIwCwODw5qxMBBuDKQJpiUmkNOdXCuevUsoETP3es4Nzf8DnGMrkR018iGejkZkP+YAoTN/o8/hl9b6X3biNL08G0yiXvoBRxKV3mwZK4Jcju3o7HEKxX1b3+7Zrth349bjF4cAef1whb6lbJt4naDpAlFfdXkqFZaq6yMuOS4FoSL2jfJcFzSkfa3XzIJPxRwxFIooy8Ze+ZZH0cpmgvJEhJ6IiNLZATlf7txmnmKnR8ZrU9mRsltxjQBH5f98+DZ4CF7npIWrwttWoyUukr13w+jkvXi3+Q/lLQUNuC+fYovBblx57iApmc8dwNPoJnBdQWdzo7YLtVPbSIEzObkqTMA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.08.25 08:15, Andrew Morton wrote:
> On Fri, 15 Aug 2025 14:54:57 +0100 Usama Arif <usamaarif642@gmail.com> wrote:
> 
>> The function already has 2 uses and will have a 3rd one
>> in prctl selftests. The pagesize argument is added into
>> the function, as it's not a global variable anymore.
>> No functional change intended with this patch.
>>
> 
> https://lkml.kernel.org/r/20250816040113.760010-5-aboorvad@linux.ibm.com
> jut did this, but didn't add the extra arg.
> tools/testing/selftests/mm/split_huge_page_test.c needed updating.
> 
> --- a/tools/testing/selftests/mm/cow.c~selftest-mm-extract-sz2ord-function-into-vm_utilh
> +++ a/tools/testing/selftests/mm/cow.c
> @@ -52,7 +52,7 @@ static int detect_thp_sizes(size_t sizes
>   	if (!pmdsize)
>   		return 0;
>   
> -	orders = 1UL << sz2ord(pmdsize);
> +	orders = 1UL << sz2ord(pmdsize, pagesize);
>   	orders |= thp_supported_orders();
>   
>   	for (i = 0; orders && count < max; i++) {
> @@ -1211,8 +1211,8 @@ static void run_anon_test_case(struct te
>   		size_t size = thpsizes[i];
>   		struct thp_settings settings = *thp_current_settings();
>   
> -		settings.hugepages[sz2ord(pmdsize)].enabled = THP_NEVER;
> -		settings.hugepages[sz2ord(size)].enabled = THP_ALWAYS;
> +		settings.hugepages[sz2ord(pmdsize, pagesize)].enabled = THP_NEVER;
> +		settings.hugepages[sz2ord(size, pagesize)].enabled = THP_ALWAYS;
>   		thp_push_settings(&settings);
>   
>   		if (size == pmdsize) {
> @@ -1863,7 +1863,7 @@ int main(void)
>   	if (pmdsize) {
>   		/* Only if THP is supported. */
>   		thp_read_settings(&default_settings);
> -		default_settings.hugepages[sz2ord(pmdsize)].enabled = THP_INHERIT;
> +		default_settings.hugepages[sz2ord(pmdsize, pagesize)].enabled = THP_INHERIT;
>   		thp_save_settings();
>   		thp_push_settings(&default_settings);
>   
> --- a/tools/testing/selftests/mm/uffd-wp-mremap.c~selftest-mm-extract-sz2ord-function-into-vm_utilh
> +++ a/tools/testing/selftests/mm/uffd-wp-mremap.c
> @@ -82,9 +82,9 @@ static void *alloc_one_folio(size_t size
>   		struct thp_settings settings = *thp_current_settings();
>   
>   		if (private)
> -			settings.hugepages[sz2ord(size)].enabled = THP_ALWAYS;
> +			settings.hugepages[sz2ord(size, pagesize)].enabled = THP_ALWAYS;
>   		else
> -			settings.shmem_hugepages[sz2ord(size)].enabled = SHMEM_ALWAYS;
> +			settings.shmem_hugepages[sz2ord(size, pagesize)].enabled = SHMEM_ALWAYS;
>   
>   		thp_push_settings(&settings);
>   
> --- a/tools/testing/selftests/mm/vm_util.h~selftest-mm-extract-sz2ord-function-into-vm_utilh
> +++ a/tools/testing/selftests/mm/vm_util.h
> @@ -127,9 +127,9 @@ static inline void log_test_result(int r
>   	ksft_test_result_report(result, "%s\n", test_name);
>   }
>   
> -static inline int sz2ord(size_t size)
> +static inline int sz2ord(size_t size, size_t pagesize)
>   {
> -	return __builtin_ctzll(size / getpagesize());
> +	return __builtin_ctzll(size / pagesize);
>   }
>   
>   void *sys_mremap(void *old_address, unsigned long old_size,
> --- a/tools/testing/selftests/mm/split_huge_page_test.c~selftest-mm-extract-sz2ord-function-into-vm_utilh
> +++ a/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -544,7 +544,7 @@ int main(int argc, char **argv)
>   		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
>   
>   	nr_pages = pmd_pagesize / pagesize;
> -	max_order =  sz2ord(pmd_pagesize);
> +	max_order =  sz2ord(pmd_pagesize, pagesize);
>   	tests = 2 + (max_order - 1) + (2 * max_order) + (max_order - 1) * 4 + 2;
>   	ksft_set_plan(tests);
>   
> _
> 


LGTM.

-- 
Cheers

David / dhildenb


