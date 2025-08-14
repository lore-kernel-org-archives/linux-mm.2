Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B5E9CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 15:41:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C83090019E; Thu, 14 Aug 2025 11:41:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17902900172; Thu, 14 Aug 2025 11:41:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0128490019E; Thu, 14 Aug 2025 11:41:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DE56E900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:41:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9140F5A869
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:41:24 +0000 (UTC)
X-FDA: 83775777288.27.D131E84
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf24.hostedemail.com (Postfix) with ESMTP id AFC41180009
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:41:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q14lTV0i;
	spf=pass (imf24.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755186082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Snu4TW99vD6eKnQ20z+tTcXAXQFZQCSrz3K4OLsk2tI=;
	b=DmYx4m47+Sdw1ncRyeOj6aoximUZHwQ0ZiGH6nyM6ewkYI0FO7jpZCs2rnWa8qvBehS640
	acIXSREkv5JWdoXHy6CnakQDuYbsBKjmbLhTJBM3L8ChMK6Pw9mEHhpQsqsCv73ZOtZiiI
	58kVqX8eD7/wrjWcZ2bJ5HiwuJijuYA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q14lTV0i;
	spf=pass (imf24.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755186082; a=rsa-sha256;
	cv=none;
	b=DG2lL8hXqd4nShWhSn6rFow2tIu06EEeMUQDwKmF7fka04LEkKLfJCSJbkBmxvYcDstOkm
	/efcXzhcmvuP700rXL6Wr0UZ2x2kQVkk5FtJ2wTwFNZ52iu720jxfWCp5h63f1alkALy0O
	BnsTKV/IwPHn9pv+s7zG8rseYEo1sHY=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45a1b0d0bc0so7241655e9.3
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755186081; x=1755790881; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Snu4TW99vD6eKnQ20z+tTcXAXQFZQCSrz3K4OLsk2tI=;
        b=Q14lTV0iE6GRKDtWDWfOdQzoRHvutKWf+XssOYJOo7I3Jkr0OkyPMMVQYCj9tLVPOU
         D7crdGFOFWrpXCKDB6SAA0pbdmqjNgoTodaQI9H7HHQBe9RTzFppJfY0RYO0sQuBrZbV
         /ZZtNPYzsGATWwJ1yVEdLd245vDvNnba4E2G+cQ2lA5rtlkgG33fGUxlgUJHaohabtUc
         ji4BVGQ7CTPchjP9jD1ZoerFyw0EX069k7ouYVXUmCJ4yLNUgpM2s1I+C4KCsGj6cekE
         MeZolSgwLRs99N3NEa6KO46QQy5HYKVIsr10/Nsw1u+AM5Yr7aFvN51xbVum+LbDwaXp
         rBHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755186081; x=1755790881;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Snu4TW99vD6eKnQ20z+tTcXAXQFZQCSrz3K4OLsk2tI=;
        b=qGnLNWWhnpFPBI+HQfrokUNv8Y4YEX3E7JJvzyWupBeNBWYpw4SM3qqvtfPzNwllnS
         5xRx2rRisIPOSKyufTq3BLnc/PmCVivfjZKJbpVcTVO2l1ONdXXhkjrAESb9k7XCGlx7
         m9055Zw5hFaEHqOW43NXFFj5aOvc9kMPS1MbkIVkp1HA2yXBLZLd4GYaoEWOzsjFUkyy
         VTTB6LNwCW5j+8U+xP/Egko1+Rm1vqp8Fl9lrBW++Lz95rjbO0FvyakXhm6iy2+3gvfJ
         nJcKjz5JTSD+3udyTCE/oF2LJOSeBSg7riGjFAOewtxFGeDZGIlZlUIoQmTANzH7X+xL
         y2Kg==
X-Forwarded-Encrypted: i=1; AJvYcCV+XXon/ekYesV09gnfkSORzRxeyPrsu5KKqw0xsXp21mv41lF5NE8ePZwEtErzC2wrCPo6i128lw==@kvack.org
X-Gm-Message-State: AOJu0YzecZzc5B0QomNGPajRfpqLpILMFq3QT8jTLIxZi/bTXPDjYqx5
	YxTVhnVOOEd6ut5RhjOna+zVlyG0lLZJ0o2ALsn3NrV32nIZTpSWHtoa
X-Gm-Gg: ASbGncuDL7N/OWKPlfPQiIb5Y5/lOshfueBeCj4spBKA2Bp7/tCU3U6CM9SjnZk6Gfx
	UILh8Q6nN7yS2IypW+gi+wz0Z/ffOLChieYWjnsaNPVzFa8wB1M3TFov/7sSOEAg1pZLzTQvcSu
	suiedFxuODQ/Wk1UKlN/6VTkpUUkZfP0flTzzg3snc8/I5zwqColI2bW/hoB1ddnVMb17ba7aiB
	PQgxd+AZ9YQdXARf9uDzzRQmat+8jIGNKluYX5D3lKrVJR7DBmhfY5k1kWGsjxse+vtgme6FGXE
	3TeKS/+D9plnLtUHGhoD5vN8gATxhvs6D2pJwkhQ6ubC7RbyuMxzOkIAJoqB8N5K7k3jIT6T9t6
	e3AHr8F4xtloRf0ki6zJQEvwa9vLuB3PrRo3VerQsHGLl1G3bkOw36RAHELzVy6/ua5aAo4kvJs
	DUGlWwsQ==
X-Google-Smtp-Source: AGHT+IFR6kyS0MwCFXecgpL+CkpUW4A1Qwi/ZDuTfTRfuJxCm+OLfkLiLdmsUzftuDIX9sgmP/813w==
X-Received: by 2002:a05:600c:4e87:b0:458:f70d:ebdd with SMTP id 5b1f17b1804b1-45a1b646ab1mr37271215e9.16.1755186080861;
        Thu, 14 Aug 2025 08:41:20 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:14f1:c189:9748:5e5a? ([2620:10d:c092:500::7:8979])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1b7c18d7sm16194935e9.2.2025.08.14.08.41.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Aug 2025 08:41:20 -0700 (PDT)
Message-ID: <0879b2c9-3088-4f92-8d73-666493ec783a@gmail.com>
Date: Thu, 14 Aug 2025 16:41:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/7] selftests: prctl: introduce tests for disabling
 THPs except for madvise
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Mark Brown <broonie@kernel.org>
Cc: David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 vbabka@suse.cz, jannh@google.com, Arnd Bergmann <arnd@arndb.de>,
 sj@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kernel-team@meta.com
References: <13220ee2-d767-4133-9ef8-780fa165bbeb@lucifer.local>
 <bac33bcc-8a01-445d-bc42-29dabbdd1d3f@redhat.com>
 <5b341172-5082-4df4-8264-e38a01f7c7d7@lucifer.local>
 <0b7543dd-4621-432c-9185-874963e8a6af@redhat.com>
 <5dce29cc-3fad-416f-844d-d40c9a089a5f@lucifer.local>
 <b433c998-0f7b-4ca4-a867-5d1235149843@sirena.org.uk>
 <eb90eff6-ded8-40a3-818f-fce3331df464@redhat.com>
 <47e98636-aace-4a42-b6a4-3c63880f394b@sirena.org.uk>
 <1387eeb8-fc61-4894-b12f-6cae3ad920bd@redhat.com>
 <620a586e-54a2-4ce0-9cf7-2ddf4b6ef59d@sirena.org.uk>
 <de8da320-3286-4639-8f61-b99d1186ca41@lucifer.local>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <de8da320-3286-4639-8f61-b99d1186ca41@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AFC41180009
X-Stat-Signature: wxa6dqmug57jj67dn3w47foudzi474ex
X-Rspam-User: 
X-HE-Tag: 1755186082-289106
X-HE-Meta: U2FsdGVkX1/ZjSug2ElJ+8nWigAPgaCofmUuxh0ZaYNIkS9l/6cEVKy1vtI9dOqHzqA3rSBV7Dryl3YUUSKl2YgqLi5kSflKP8wVIm6zGJDR6wBstQQ7j7hqzrGwKNtgZBeap/Z40NbfCGtqF+xlxgjjADUO8H0Sk8lrrP8pxAxIljl+9GsmnBlYhQWZtc5TszBGhe6IQXAGvBIaY5F8e7vWJyVycr2B9X4QyJi/3w+ytvP2xCozoGjq9+zZJJBzce+6C0oy2ljddpk4PvVTNg0otzo+ag2fUurSuVBjAZvlrPFCksLeRBQxodLDMv/TB4nXSgHHX4ghKqJI7DK00KTC26kRuQjU4U8WID6IvIMod5NJj8z+7O6nzI+2xJeSHw7pW5d0fMHwMEVxbrmBiDdKMn1hXcyrVBCnxV6dBl2UqY/4tQEnEISZ2jranRRRjypfOmqGw9NJvXToXQlboYctDCUx2VrUmHnwyi+/pAOIXrXmE8Cp4IM7FmjPqVhkHqZBUGGvJFf/2HHuPvMKWyZvnTC1TLResvoZxxALBediVKE/NuombRnIix8ueoR20SNp2v3VqSUad3N5DioOC/fAi187hYDwQoPXSapmgx6Fh+SAge7YWNSWJKTpn1zzRcA0cwpsSW9wseMedv46FtDpm8dk6CDkJK3USh6bUVlFkQxeC3ty+ZJgoM89P1IT7JMM/v2cyyTiLR4JWVs9xGKkTLfGb9lwfAgNODwoaHiTgzDZutbh3/Ozw/JpjvqGBFyMZo/YKz2rS9ezbQft1/n2NmhqXnwHtnpqn6xz3GQn/obot5GHhHgthvSb0lc0ZRmu1lV3ukUVXBDxxyD4XGYzBb0dnOZGi04yzhAyPwd+0YgbJFcM25/vGSw/7LlYjtXkufSAFtA1VRqn5o5EVv2ju8xWvbjKtm/eij80500r7IlgYljldCYhqEcb/HlDUuSZRutX65GZDNX1CYr
 sWAut5a8
 MR8n5V5TICG/1EOEKD86/8TdYcwdwMj+b+qym5MuFs4vNwzNzd2QkVtbFijahXGLefx9Km9MEzPAlnCKogVrQSvWoDhmjSi3MuHp2rVD1ZywfRKkwzgS1i09EyippicniKicN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 14/08/2025 16:02, Lorenzo Stoakes wrote:
> On Thu, Aug 14, 2025 at 02:08:57PM +0100, Mark Brown wrote:
>> On Thu, Aug 14, 2025 at 02:59:13PM +0200, David Hildenbrand wrote:
>>> On 14.08.25 14:09, Mark Brown wrote:
>>
>>>> Perhaps this is something that needs considering in the ABI, so
>>>> userspace can reasonably figure out if it failed to configure whatever
>>>> is being configured due to a missing feature (in which case it should
>>>> fall back to not using that feature somehow) or due to it messing
>>>> something else up?  We might be happy with the tests being version
>>>> specific but general userspace should be able to be a bit more robust.
>>
>>> Yeah, the whole prctl() ship has sailed, unfortunately :(
>>
>> Perhaps a second call or sysfs file or something that returns the
>> supported mask?  You'd still have a boostrapping issue with existing
>> versions but at least at any newer stuff would be helped.
> 
> Ack yeah I do wish we had better APIs for expressing what was
> available/not. Will put this sort of thing on the TODO...
> 
> Overall I don't want to hold this up unnecesarily, and I bow to the
> consensus if others feel we ought not to _assume_ same kernel at least best
> effort.
> 
> Usama - It's ok to leave it as is in this case since obviously only tip
> kernel will have this feature.

ah ok, so will keep it at skipping if prctl doesnt work in fixture as is
in the current v4 version.

I only have the below diff and its equivalent for patch 7 as a difference over
this version. Will wait until tomorrow morning incase there are more comments
and hopefully send out a last revision!

Thanks!



diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
index 8845e9f414560..e9e519c85224c 100644
--- a/tools/testing/selftests/mm/prctl_thp_disable.c
+++ b/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -18,6 +18,7 @@
 
 enum thp_collapse_type {
        THP_COLLAPSE_NONE,
+       THP_COLLAPSE_MADV_NOHUGEPAGE,
        THP_COLLAPSE_MADV_HUGEPAGE,     /* MADV_HUGEPAGE before access */
        THP_COLLAPSE_MADV_COLLAPSE,     /* MADV_COLLAPSE after access */
 };
@@ -49,6 +50,8 @@ static int test_mmap_thp(enum thp_collapse_type madvise_buf, size_t pmdsize)
 
        if (madvise_buf == THP_COLLAPSE_MADV_HUGEPAGE)
                madvise(mem, pmdsize, MADV_HUGEPAGE);
+       else if (madvise_buf == THP_COLLAPSE_MADV_NOHUGEPAGE)
+               madvise(mem, pmdsize, MADV_NOHUGEPAGE);
 
        /* Ensure memory is allocated */
        memset(mem, 1, pmdsize);
@@ -73,6 +76,8 @@ static void prctl_thp_disable_completely_test(struct __test_metadata *const _met
        /* tests after prctl overrides global policy */
        ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_NONE, pmdsize), 0);
 
+       ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_NOHUGEPAGE, pmdsize), 0);
+
        ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_HUGEPAGE, pmdsize), 0);
 
        ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_COLLAPSE, pmdsize), 0);
@@ -84,6 +89,8 @@ static void prctl_thp_disable_completely_test(struct __test_metadata *const _met
        ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_NONE, pmdsize),
                  thp_policy == THP_ALWAYS ? 1 : 0);
 
+       ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_NOHUGEPAGE, pmdsize), 0);
+
        ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_HUGEPAGE, pmdsize),
                  thp_policy == THP_NEVER ? 0 : 1);

> 
> Cheers, Lorenzo


