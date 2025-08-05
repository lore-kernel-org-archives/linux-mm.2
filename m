Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0759CC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 17:04:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CF338E0003; Tue,  5 Aug 2025 13:04:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87FA68E0001; Tue,  5 Aug 2025 13:04:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7478A8E0003; Tue,  5 Aug 2025 13:04:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 615538E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 13:04:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D26B6B6C0E
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 17:03:59 +0000 (UTC)
X-FDA: 83743326198.04.B7087E0
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf03.hostedemail.com (Postfix) with ESMTP id A8A7E20018
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 17:03:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Evc5G+Jg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754413437; a=rsa-sha256;
	cv=none;
	b=26R7wFFQZSGqey/UjGxYQqG5j/iqU12sSmfkx8U2xsimHoY4mLyaWIQ4uYNqatcwsm8sms
	nolidHKLFyjjWXQ95LA/pEjt+TFnPtfIH82zAfAZEtzp7bSdIIQLBlqrBCIkAFnswjykou
	izGRspEHvXMAXGkR0kehru4OTu2Zx/0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Evc5G+Jg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754413437;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ocAA6Mc755BpdMt20sH6v5c6z0jN15Kqz/vvCPh53bY=;
	b=vuKSafV0j4v7w5HpaSUkFqVpFV8D5qE8xd+58HLor5V9qeDleYXbhJse2CXWM5F1aBBvKD
	x52iMk3dcNDnCXk8jecMzdEFp6PJrUsjNYIj/z/AYVuRm2/PkWxe/fNrstKYDlQjEUFufP
	SSO2qJDmZkUXw9FGsh1V2omo2nTuxes=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-604bff84741so10412481a12.2
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 10:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754413436; x=1755018236; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ocAA6Mc755BpdMt20sH6v5c6z0jN15Kqz/vvCPh53bY=;
        b=Evc5G+Jg3Hm0CNqBzSpp8xQleSVEQoFlUMjdOTXZlWHJilXGYMPm6GLwVt4vHXzcYp
         mth+Y+g4B1UWXtCVrtrTHVsXE5u9rKGmfmLrEuapiAczEyGloas5/VAJTG8dN0vompky
         Tel3p/wu/ZONx2Dpdr4YURNv85h+TQlyx3Ld4LmKuUTx91nD78hNod5KoO+TKjW/mXiz
         fs2YgPC5bAJrY2OB6pcrbpzB68ksZ66DD7fC2rbwnFg2gOgMwISGMFuH2Nc/MfA0Iqdm
         SfR69e09t1+txHGgaFsKt0O94G3PBnK3iowJ3/pLmVliCY3BpfPCYxazJ4GlQCljUdMc
         TXqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754413436; x=1755018236;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ocAA6Mc755BpdMt20sH6v5c6z0jN15Kqz/vvCPh53bY=;
        b=VehXn0EEKfms9Kvdbwe53wt+aGvrsGRtrdJIeOXRF96xQwamBJUjEWMiy45y6SKIgQ
         9J01rJ9of29m2nqJI/yhi6lqcGClmE0BVt01odpq7JTGYu+X/RizCcYMIc4/RR+L0Dyc
         wrhi6Ys3Eq5SXbk5QtPzAONY5+7ijmVMkZ/ACWRCfAwBvqjWxaFuBJtVUlaZ61pAWZw1
         I+ckD0xQKV707thEDaoJ3w0Mun3RrgsFSnKdmi4ae3uWw+3J18iRxjj3Mzf0UbL088uJ
         UZBX7fvGCR58ehAU2QyJe8EsFmXZLxh52TIz0UCV530ZfNBXQuRtE+gRycLpNAiCcRN5
         UxbQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdnoeypQnw7KxZgRbF5l6czEfCOBjgF0U5XpxI1MKz4pv1FLOkzEmy64tHZW3Ohr7Mp4i1hHsdYg==@kvack.org
X-Gm-Message-State: AOJu0YxmWlErOzx8Qx/4PqSvGGokDm/vFo4rO+CzDs+ORrP+f9OTTvYO
	L3bEIX1GeGITY7gqpLmOxiyiPArG1hr0yhROLJE0j7UQ161yUID9sD//
X-Gm-Gg: ASbGncsicvUYJPjgXxuT73955DHnbBkrABwpKvTsNF+JrT81AD5lMFThlVYSt3IPO2o
	glRi95noroR6nSlmhCJ0B9qUTiVrwiatHhbENOA8EKJy/BuYPDPOux2M3LwonmjBVoQjB3qooMa
	fn7LoPP1Phz08Uqbmm1DWtTnh5jhVvZT5OYJ1RUooznP99mt4HrJ7ZUchTUpqmGna7J7l80VgvJ
	BTSlweeSpR4ZEjLeD8wTrwVGZl3u/i8W3DUlcwUSNK58BEadU9cn9Ke8nTrwgqVAFg3LFKcNSwC
	yxGyMtVCs7jB/5nnRNp/EfOi9wf1uPjwACTv/Ce5gHSQH8BKo/OMhWenr1cT0+5Sppf8M+3dMPk
	eOkoFmUFb+JX+F04d728TeA+GjYa6c/+t
X-Google-Smtp-Source: AGHT+IHg2poof9nm6xmGEfRIM/7L18y09RE8bRAhvnrt2eAaqx4Y2wGX6dk9nmtbikSVdZkiCToGqw==
X-Received: by 2002:a05:6402:4491:b0:614:a23b:4959 with SMTP id 4fb4d7f45d1cf-615e6ec6e07mr12362413a12.10.1754413435687;
        Tue, 05 Aug 2025 10:03:55 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615a8f2b892sm8777081a12.25.2025.08.05.10.03.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 05 Aug 2025 10:03:54 -0700 (PDT)
Date: Tue, 5 Aug 2025 17:03:53 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Donet Tom <donettom@linux.ibm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	akpm@linux-foundation.org, Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com, shuah@kernel.org, pfalcato@suse.de,
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	ritesh.list@gmail.com
Subject: Re: [PATCH v3 3/7] selftest/mm: Fix ksm_funtional_test failures
Message-ID: <20250805170353.6vlbyg6qn5hv4yzz@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250729053403.1071807-1-aboorvad@linux.ibm.com>
 <20250729053403.1071807-4-aboorvad@linux.ibm.com>
 <20250804091141.ifwryfmgjepwrog4@master>
 <20fb853c-7d79-4d26-9c8a-f6ce9367d424@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20fb853c-7d79-4d26-9c8a-f6ce9367d424@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A8A7E20018
X-Stat-Signature: 61krzfwknmnp8domsn6syyh7nwg67bmm
X-Rspam-User: 
X-HE-Tag: 1754413437-744299
X-HE-Meta: U2FsdGVkX18NjV6+RMbu0/1MWTdOhp87n9vo44OWpnpKGDPZzpK6lP0gZUJYoZ1KLheZ2zxkPjV1L3PriwjziojGih++ktAFGLzY2krnxQixFIPgtcWK6WhnkwCf/9edaqJL+XGsvTHf4+hxMd9AW0Z9PrUAqn8NOYMbE/aplJK8Nyjb7mCXpV1ICrMwEEoqzTgNs8Os87vQOwBNhXvwqKboLkNFaSZ/bAEbYhvvKYgRznt3IkK7lmbAabmM04RoEZOjc7Fj7gEBuxr7gaCvtblUMR5i31gdWM7oBFoVi1HVKUR1DQWdjnmmYPyzRnBywhjpaN3NdhCFknRB3/Ct5seYIHBfgmD+LzpP6Zt0tRPJbAWoGbM1idS+C+ypcDw9J2dfxXz0KDVLTP7geX6J/VfkQnINX0qYvJTeBojZiM3AdNfS8zA60Fof7n9S01bphYl0kO7TzRZPl5WITyast+Msx1QZs5lMABMasJPUEFZQQB7EUDXRiS9NHCsjs8MiPw37CImCCLSKNSbJ0lh/l4LNMN+MOwW8QUMBPgm9Y8F2PMWM2X1H9kogoV5X3nZUPcbmz9dcq2MEX8mOTOWusMACVQuU9mEIAF33qfpuaktxoGjRmNFc1mJZhAYiUPNpIhGdN7qjEbHRMDZupNzDxKcDeYJi8+F2kAjns0sEscemj7UaYMI9KLSizQF/ATybhk7Ebxws18O0OhBHVl3EmcTebfp/3lHhhDjF6VPhierDDE2bggg5RT83YLZv+KrYd1iq+85a16docL4BWxT6qwqRzhiN2Dz/uxAsE9vbpg0L+HmWEHTdg5evz6uTCPa6a4Zx3aAbO8NeUg389dzC/KL/y4Dn6WxqaD1HToMYWeceNjNQL79UTaeb5CMOvaHLC4ku3HVS7HkhanoNA55VLuSoRERPNFocryMNl7LPu3rNGIuY8nzmlGy9HHN6pDGfMFV876ZbKl6VOGnTYd1
 ljlH+v/T
 +LSI9Mvel+X8FeF/TqCvDQTG9G58JK1XiZ3uleswUET6Nja/+8VP5uvh+3YOX3G7TrSqhSdj2XkFaSOU0FOVcyVg+1/wMBL4jAuHYNS5XvrCjYHL6wisSbTSXQYCtXYKiaD66NHyyDwrJEKSoFtx98uuScwEuE0FbBATzXpKXa73GB+PeszWu65jhTXyd87LFNc7WL+MDoYfsLHoqxVhKakyStr1i7AOzWDSWejnojE8U//qKnTWOJVyei1PjGCw2g88b0fUtXPbDoCTXi5PYVEi1AAM/5/m5R+qdHUOdBoA4dyNruk3DFCvr/4TxdhTsgNvyL5fnGabyRA3dUf1Wo7PbY/pmnGsrr6O1QEC2Dpl1wNVNZtkWHRSbWoypiwGk9V7avhxolB1CB5N6ekejz8kGC2BulENur6rmj1ZeDejvXrirpSjZA0rQWZgBB4xTQyKg+m8ItYQ7aZxmuhBUUZNzNDSwddOnnAKwKbjqS6KNyDHCv2u6TeygTcmcxbqH3c1a9Vk7ePrNUsMpd6tJ3HBYOH8pctJnOWrb75audEeEEw3ESkz76vWqOKjQhXwSK9kBwEU6RlTh2Q2A9J5AZM/Kt7X/XFRa0JDivMLxLN5Lm5Epk1EcwDPjX3MxfJj9BTRRVSc5/vcwEHQWoR9UvRrOnIb3XLmV4jNBsEgUQU5Wo79U0u/Z+L7wMIS5AO/X0r5FXPhTWSQnhnCS6jbYoConmRMCUuW6wtvhMH60FB3om76m4tv5LKh3q3r0jDdC4KBpUcN0WtaWThQPLlgd2yJ20dB7BiOR1zz9651tuMqOJ08=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 05, 2025 at 11:39:15AM +0530, Donet Tom wrote:
>
>On 8/4/25 2:41 PM, Wei Yang wrote:
>> On Tue, Jul 29, 2025 at 11:03:59AM +0530, Aboorva Devarajan wrote:
>> > From: Donet Tom <donettom@linux.ibm.com>
>> > 
[...]
>> > diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
>> > index d8bd1911dfc0..996dc6645570 100644
>> > --- a/tools/testing/selftests/mm/ksm_functional_tests.c
>> > +++ b/tools/testing/selftests/mm/ksm_functional_tests.c
>> > @@ -46,6 +46,8 @@ static int ksm_use_zero_pages_fd;
>> > static int pagemap_fd;
>> > static size_t pagesize;
>> > 
>> > +static void init_global_file_handles(void);
>> > +
>> > static bool range_maps_duplicates(char *addr, unsigned long size)
>> > {
>> > 	unsigned long offs_a, offs_b, pfn_a, pfn_b;
>> > @@ -274,6 +276,7 @@ static void test_unmerge(void)
>> > 	ksft_test_result(!range_maps_duplicates(map, size),
>> > 			 "Pages were unmerged\n");
>> > unmap:
>> > +	ksm_unmerge();
>> In __mmap_and_merge_range(), we call ksm_unmerge(). Why this one not help?
>> 
>> Not very familiar with ksm stuff. Would you mind giving more on how this fix
>> the failure you see?
>
>
>The issue I was facing here was test_prctl_fork was failing.
>
># [RUN] test_prctl_fork
># Still pages merged
>#
>
>This issue occurred because the previous test performed a merge, causing
>the value of /proc/self/ksm_merging_pages to reflect the number of
>deduplicated pages. After that, a fork() was called. Post-fork, the child
>process
>inherited the parent's ksm_merging_pages value.
>

Yes, this one is fixed by calling init_global_file_handles() in child.

>Then, the child process invoked __mmap_and_merge_range(), which resulted
>in unmerging the pages and resetting the value. However, since the parent
>process
>had performed the merge, its ksm_merging_pages value also got reset to 0.
>Meanwhile, the child process had not performed any merge itself, so the
>inherited

I assume the behavior described here is after the change to call
init_global_file_handles() in child.

Child process inherit the ksm_merging_pages from parent, which is reasonable
to me. But I am confused why ksm_unmerge() would just reset ksm_merging_pages
for parent and leave ksm_merging_pages in child process unchanged.

ksm_unmerge() writes to /sys/kernel/mm/ksm/run, which is a system wide sysfs
interface. I expect it applies to both parent and child.

>value remained unchanged. That’s why get_my_merging_page() in the child was
>returning a non-zero value.
>

I guess you mean the get_my_merging_page() in __mmap_and_merge_range() return
a non-zero value. But there is ksm_unmerge() before it. Why this ksm_unmerge()
couldn't reset the value, but a ksm_unmerge() in parent could.

>Initially, I fixed the issue by calling ksm_unmerge() before the fork(), and
>that
>resolved the problem. Later, I decided it would be cleaner to move the
>ksm_unmerge() call to the test cleanup phase.
>

Also all the tests before test_prctl_fork(), except test_prctl(), calls

  ksft_test_result(!range_maps_duplicates());

If the previous tests succeed, it means there is no duplicate pages. This
means ksm_merging_pages should be 0 before test_prctl_fork() if other tests
pass. And the child process would inherit a 0 ksm_merging_pages. (A quick test
proves it.)

So which part of the story I missed?

-- 
Wei Yang
Help you, Help me

