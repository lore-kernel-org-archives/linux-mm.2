Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66F2FCD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 19:31:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 951556B0099; Fri,  1 May 2026 15:31:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 901D56B00A0; Fri,  1 May 2026 15:31:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F11B6B00A1; Fri,  1 May 2026 15:31:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6B9C36B0099
	for <linux-mm@kvack.org>; Fri,  1 May 2026 15:31:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0F93DC0DA4
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:31:01 +0000 (UTC)
X-FDA: 84719843922.11.A5CD64A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id A7AD0A000A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:30:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BOqqLYg1;
	spf=pass (imf15.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777663858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=axtkg8lWUKLhKh8btqTTKn3GGcdeBh87rxcslGFSOgo=;
	b=U+xBwtRyHWdaWn/3HQPJGa/cpDcQO3haVnLVAFsGjG2AyOCULLLXKwK0mTeUMJZEG3FA58
	IqumK2nSNVcrA9eQodH08igea+WmX2ErYKp5UWHmMcGVWhc+xrgZ+uzGIRLvyffzpbLlXp
	cy1AgJ21TVSjxsp+wVno4Ka6UfUiYsw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BOqqLYg1;
	spf=pass (imf15.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777663858; a=rsa-sha256;
	cv=none;
	b=lu8opMbylXqrQCXHrm8a0T1FDSUPzOOmCI5mn5CyJgfJsU+JTlCkn1GCsJ/uEfBx5Jj4eX
	I0rWrwYKgdUbXY9g7UxqwHoSI80plcJ5McLcX4VVzDu2AszKZ4nqnwlzLuRauzNMoJzu4Q
	A/NJ8Nls1MuaVqP8R1RCT2JyK44d8uk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777663858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=axtkg8lWUKLhKh8btqTTKn3GGcdeBh87rxcslGFSOgo=;
	b=BOqqLYg1vZ5Haa7GDb9yNL8qqT8mF98NffjNSfzGcN255GMp2SOHcRb9JVwguDVqcWjZJ5
	h7Nil2cjpgD9EH+N/StgDXaDmWlJKoM3h15hIuJaRhO+jfnTDeP7fL0EN3Wfj74yyz0XkB
	9eyY95ibbwUeZieOKqw6PHHpJlsfQG8=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-284-OxZsV3DgOpeRU3ywY8nZ5Q-1; Fri, 01 May 2026 15:30:57 -0400
X-MC-Unique: OxZsV3DgOpeRU3ywY8nZ5Q-1
X-Mimecast-MFC-AGG-ID: OxZsV3DgOpeRU3ywY8nZ5Q_1777663856
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8d4c2906fdfso302069285a.2
        for <linux-mm@kvack.org>; Fri, 01 May 2026 12:30:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777663856; x=1778268656;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=axtkg8lWUKLhKh8btqTTKn3GGcdeBh87rxcslGFSOgo=;
        b=gkXCgYXiUdkRNNyeGSuA8rHMrh5Kz5j52J97ghSj6aHrlifWOx7PmtkqRKMm5MJ9mO
         rHsxGr6pjzabAImhRgBx8OOKCARVzlbfmTS/4cVlx+e0bAnolFvTu+qlSxVvbW73qyDq
         gzpTuBmfpYUyg3Lpo0sExBORR/GbPNq3wWPzJbDbeCyLveNMqscNIRD+3+Jidhu351Eb
         zC2mEhkBp8sj1LCIziIFVm8Us/DN1jlsxTAotkFb+y6yg3AbtMksZKrBSJGm9eAviQoV
         MpCnU0mLUzlRcw7fOacwme7toCfMAm5e6dsBDBCvM1UbhidR629LKY8cFACMj5uTMjsD
         5BeQ==
X-Forwarded-Encrypted: i=1; AFNElJ+eRfy/gshBBU8i5i7ssv55jok0vkNC9jGQvx0x338GOqBC6LoxCywYr4U0jREBIxl2mdD0C7voTw==@kvack.org
X-Gm-Message-State: AOJu0YyAxzRv0z0bR2Z959jUyDfUFQkbrrL5KIoT+hCjQbbcolsTk3T0
	sdshTt5OTCCgNqh1dduDjhr3kCMcE0hMVXO64Wi1FTfNqIu+NIQi3fVpAsb5nQ/Y3EE6nAFQbUF
	zcPbiLJSo/T19lj688hmOVkCcyS7PBtM6UtPtlV6BkDJjLCrY8vk+
X-Gm-Gg: AeBDiesl6Zs5z+TulZnmTvdQXoJlnsKQsa296WRxuVGmxpdSq422MzvYaJzpkHPwzej
	4cusqTOtlKBpR7+siAS0RSu+aIHxlK5HzxTkaF9Gors+RV3fE9RLt5b9rOmOl0IqYAZt2MNiduP
	clLrLHoKGUFgLFZj5FDLS1ZNXn5kdGdUYRjb/mNq9wBRM+ZpN/WdsTo7CWTl5DP4UK1AYccOo7b
	IN5jjkM1kFtLRnlEZwLsWIbs0POZtZfIUSPbUqdoBSNxg9ekKQK3bVF4HyaVNldxNcECJwVXzeO
	dlik0CzY3t6OcFlRdmyVGOuesgMK3KKnFrVB8OofTpuRW4717QReO8GI1Pts2cL1bPfUWdfpVYF
	OT3MsQYxOjOaiQf/y5a//sf293MSGe6ivEB/Ee/WVZSC6z8K3H3wWjtrnyi1crb0LRZ102NMRPO
	ndnu/FLOmVm+rTvF5E6Mi6/L4=
X-Received: by 2002:a05:620a:28c1:b0:8ed:2b66:9ebd with SMTP id af79cd13be357-8fd15ecc8b2mr102076885a.9.1777663835984;
        Fri, 01 May 2026 12:30:35 -0700 (PDT)
X-Received: by 2002:a05:620a:28c1:b0:8ed:2b66:9ebd with SMTP id af79cd13be357-8fd15ecc8b2mr101915285a.9.1777663825495;
        Fri, 01 May 2026 12:30:25 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-22-70-53-202-134.dsl.bell.ca. [70.53.202.134])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fc2c91fb3bsm235197885a.41.2026.05.01.12.30.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2026 12:30:25 -0700 (PDT)
Message-ID: <22b1cadc-4b0d-4e2a-987c-e7a7bc2265eb@redhat.com>
Date: Fri, 1 May 2026 15:30:18 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 27/54] selftests/mm: hugepage_settings: add APIs for
 HugeTLB setup and teardown
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Donet Tom <donettom@linux.ibm.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lance Yang <lance.yang@linux.dev>, Leon Romanovsky <leon@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Mark Brown <broonie@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
 Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Sarthak Sharma <sarthak.sharma@arm.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-28-rppt@kernel.org>
 <2f443474-4448-462e-bc1e-55bc657d70ba@redhat.com>
 <afTF9RCy8eBoWYaj@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <afTF9RCy8eBoWYaj@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tB-qAkdE48cn2NqB4QTZWIpfYGHUiM-cImO49EhooWk_1777663856
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A7AD0A000A
X-Stat-Signature: 63u5afzk87wprq88h3buph8yt5kw6bqo
X-HE-Tag: 1777663858-311354
X-HE-Meta: U2FsdGVkX195KSOB0OX/phTY9KhsIRRH5zhugxibpnJvTQ6vpMSCQktgIa37SsK30kI2mHWm5L/MT7kRbHBSxlEn1U4AaaWCDhyjxKpc/qI550gZTWNaHJZs8nN/ys+s7Kb1HW7bqAlzks5JgmteN+yjua66U+7uGTt3Ll391D/GF0CJtQj+dYOG7aGGJvh5ZqP6srSxHkJqtdouBk7ndUf0FQFR/ZaQ+hN4HqeqcJ61tXDALPrqHLEz4DM2KsKgs2kipFsMXRnSMCjrrdXFBPsbhIZK5gXHwfHn8V316gIS6MbBBro0u3Ae1CrWhMoNnq0FzuKQJq4MX1FZvZQs3Vww7OeYRraOx+yM9Gd7pCjKAOXz1KyukFdOgFe+YvPClBNHavJ2DxyMJds3ZXR3vVaHGAYfxdcJ3x2bGZmOSfvXmVzlOUUpJEf3QRqM+ICL8BeY9ydSIyiMIaB5VXE3/oNTSovzboCnsHwbxsE9bU9iTiFyxKdY3rm27hF24C9U7iZ3uHqeF9wjv1L06Sx8Ktr3Wn2qCcayMYHO5nOlyv1AO71aJkCG9cOLhfT0A/ven4DnIjKne/0QYtZoih1RJYH1ZbDyKIZp7muUg8el9qv7tJrZcJJKc3ULQg3Ary4dHAxsFUdnogsxWC+slQBeQydZmb7rImXNxxXpvhBVzfEjC7m2O/109Ps480AZ6dSpXFskgmrnqut/obUmBeSY2Ws+eYLSTSg/03eaSZHzc+t5ZWcFW8/oFd75ouppbiqtAAMSZd/NAXM7SiwOylPU9c8e9uNAUoeraunI0Duzw0cWJXuK+t3i8rKVzjgsHfysYTKbo0eEdMSiAYxBLToikvdYFKg9t9zZvwO4h6fxnjhHvgjaFPbLnIgjVR1CaElaBj2aPrnR7QWJiWyY5AE+/uPLJ52Z4A7jLSP8rqI8LEKQwawuvY9TH23VzcUG/87xUlkRT+1u0K0qQGH484T
 mnhyjh+6
 VOT5UwCR1aArYey7NV4xISYrLDVoudyY5f9ZKBplvqGeOcuVCnvNHoy61WiGUEHKlMg3OZKDzTWpwAbnUvVsT3WLYfYYndkr4M3XrVm1HOxPP+LN4dD+SuT6xjhHG/vuFcJbfX4MfHeS5akt+W3Bju8zf3Cvxf8zD0tcBx3427gl/lXWZLUFcPxvBPKm2d5JBNOUCxTI04+OkVUHhyUxUiyk/5LRXa2oSdFCThIyF02bjqTg2A38VcdnaxOSk18mA/3QdWBVWQGKaJ7ENWAWJITTnbyZuycFsCD6MvxfSLjVKsOqDCEZmss/Mn2desBY6LPEaQ0byybPvDTmVJdzI5X59GHWTqeLuQVdDxHGct5ZPR2i0ROm0Irk7kpWFHMNqPX1LdUpMqSOXJr9KhgfkqSaQhVAJEZcTph/KQBQYOY7lJzTO1zXZ+HWLkkLQCRuoyVZXrY84LdPpUWbyQ5f5WUwKeVwMymhFr+Y+x20xanxed99kfi4ws47hLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-01 11:25, Mike Rapoport wrote:
> On Thu, Apr 30, 2026 at 02:31:48PM -0400, Luiz Capitulino wrote:
>> On 2026-04-28 16:42, Mike Rapoport wrote:
>>> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>>>
>>> A lot of tests require free HugeTLB pages. Some need just a few default
>>> huge pages, some need a certain amount of memory available as HugeTLB, and
>>> some just skip lots of tests if huge pages of all supported sizes are not
>>> available.
>>>
>>> This all resulted in a huge mess in run_vmtests.sh that sets up some huge
>>> pages, adjusts them later and restores some of the settings if the stars
>>> align.
>>>
>>> Add APIs that allow saving the state of HugeTLB and setting up the desired
>>> amount of HugeTLB pages.
>>>
>>> Saving the state also registers atexit() callback and signal handler that
>>> will ensure restoration of HugeTLB state.
>>>
>>> Since many tests use both HugeTLB and THP, the atexit() callbacks and
>>> signal handler are restoring both.
>>>
>>> For kselftest_harness tests that run fixture setups and test in child
>>> processes add a constructor that will save and restore settings in the main
>>> process.
>>>
>>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>> ---
>>>    .../testing/selftests/mm/hugepage_settings.c  | 178 +++++++++++++++---
>>>    .../testing/selftests/mm/hugepage_settings.h  |  30 ++-
>>>    2 files changed, 183 insertions(+), 25 deletions(-)
>>>
>>> diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
>>> index 4ae7332b5e1b..9d31b53dbc67 100644
>>> --- a/tools/testing/selftests/mm/hugepage_settings.c
>>> +++ b/tools/testing/selftests/mm/hugepage_settings.c
>>> @@ -306,31 +306,12 @@ void thp_restore_settings(void)
>>>    		thp_write_settings(&saved_settings);
>>>    }
>>> -static void thp_restore_settings_atexit(void)
>>> +static void __thp_save_settings(void)
>>>    {
>>> -	thp_restore_settings();
>>> -}
>>> -
>>> -static void thp_restore_settings_sighandler(int sig)
>>> -{
>>> -	/* exit() will invoke the thp_restore_settings_atexit handler. */
>>> -	exit(KSFT_FAIL);
>>> -}
>>> +	if (!thp_available())
>>> +		return;
>>> -void thp_save_settings(void)
>>> -{
>>>    	thp_read_settings(&saved_settings);
>>> -
>>> -	/*
>>> -	 * setup exit hooks to make sure THP settings are restored on graceful
>>> -	 * and error exits and signals
>>> -	 */
>>> -	atexit(thp_restore_settings_atexit);
>>> -	signal(SIGTERM, thp_restore_settings_sighandler);
>>> -	signal(SIGINT, thp_restore_settings_sighandler);
>>> -	signal(SIGHUP, thp_restore_settings_sighandler);
>>> -	signal(SIGQUIT, thp_restore_settings_sighandler);
>>> -
>>>    	thp_settings_saved = true;
>>>    }
>>> @@ -399,11 +380,31 @@ bool thp_is_enabled(void)
>>>    	return mode == 1 || mode == 3;
>>>    }
>>> +#define HUGETLB_MAX_NR_PAGESIZES 10
>>> +struct hugetlb_settings {
>>> +	unsigned long free_hugepages[HUGETLB_MAX_NR_PAGESIZES];
>>
>> It looks like we don't actually use this in the API or maybe I'm missing
>> something?
> 
> Yes, it's used only in later patches.

I don't see it, the patch below builds fine (again, sorry in advance if
I'm missing something obvious):

diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
index 097ba085f423..a023cfeb69c5 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/testing/selftests/mm/hugepage_settings.c
@@ -341,7 +341,6 @@ bool thp_is_enabled(void)
  
  #define HUGETLB_MAX_NR_PAGESIZES 10
  struct hugetlb_settings {
-	unsigned long free_hugepages[HUGETLB_MAX_NR_PAGESIZES];
  	unsigned long nr_hugepages[HUGETLB_MAX_NR_PAGESIZES];
  	unsigned long sizes[HUGETLB_MAX_NR_PAGESIZES];
  	unsigned long default_size;
@@ -509,7 +508,6 @@ static void __hugetlb_save_settings(void)
  		if (!sz)
  			continue;
  
-		settings->free_hugepages[i] = hugetlb_free_pages(sz);
  		settings->nr_hugepages[i] = hugetlb_nr_pages(sz);
  	}
  

> I felt it would be too churny to add users in this patch.
>   
>> Otherwise, the API looks great to me. But if you allow me to bikeshed :)
>>
>> I think I'd do:
>>
>> struct hugetlb_state {
>> 	unsigned long nr_hugepages;
>> 	unsigned long size;
>> };
>>
>> struct hugetlb_settings {
>> 	struct hugetlb_state hstate[HUGETLB_MAX_PAGESIZES];
>> 	unsigned long default_size;
>> 	int nr_sizes;
>> };
> 
> It might be slightly nicer abstraction but ...
>   
>>> +static void __hugetlb_save_settings(void)
>>> +{
>>> +	struct hugetlb_settings *settings = &hugetlb_saved_settings;
>>> +	int nr_sizes;
>>> +
>>> +	settings->default_size = default_huge_page_size();
>>> +	if (!settings->default_size)
>>> +		return;
>>> +
>>> +	nr_sizes = detect_hugetlb_page_sizes(settings->sizes,
>>> +					     HUGETLB_MAX_NR_PAGESIZES);
> 
> ... this immediately becomes more complex.
> 
>>> +	if (!nr_sizes) {
>>> +		settings->default_size = 0;
>>> +		return;
>>> +	}
>>> +
>>> +	for (int i = 0; i < nr_sizes; i++) {
>>> +		unsigned long sz = settings->sizes[i];
>>> +
>>> +		if (!sz)
>>> +			continue;
>>> +
>>> +		settings->free_hugepages[i] = hugetlb_free_pages(sz);
>>> +		settings->nr_hugepages[i] = hugetlb_nr_pages(sz);
> 
> And this as well.

We'd need a little more code to handle those cases, may or may not be
worth it. But enough bikesheding from my side :) the series is great as
is.


