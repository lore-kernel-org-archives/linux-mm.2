Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37098CA0EDC
	for <linux-mm@archiver.kernel.org>; Sun, 17 Aug 2025 07:42:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CB806B0342; Sun, 17 Aug 2025 03:42:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87AFA6B0343; Sun, 17 Aug 2025 03:42:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 769F96B0345; Sun, 17 Aug 2025 03:42:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 61AE66B0342
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 03:42:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D79E81405A3
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 07:42:19 +0000 (UTC)
X-FDA: 83785456398.26.81C218D
Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	by imf06.hostedemail.com (Postfix) with ESMTP id 01DA8180007
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 07:42:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l7ngRu9T;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of rampxxxx@gmail.com designates 209.85.222.44 as permitted sender) smtp.mailfrom=rampxxxx@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755416538; a=rsa-sha256;
	cv=none;
	b=56W2NRb8XTev7cwY5/rJ2W7TbJcSChYwY9kkX+I9pHKTVWGNWojw/LdkPECLEzxOUdY/R1
	w1eYZD9bu7G/aYJCYXC4VnU31o6IiP75x8JJMhjxl3LwQHpyUlFydi9EKMUW63WKlP8uy+
	uhEnL6yloWfiytXb2xWExKZZ39yS21k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l7ngRu9T;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of rampxxxx@gmail.com designates 209.85.222.44 as permitted sender) smtp.mailfrom=rampxxxx@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755416538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GjSk5VRdvKomb6mdzBClnCiEwN9IeEsY1qdY5nKEP/w=;
	b=PqZQwv5TSRHQ+IQBb5oy9wZNROgG9XhFu6HGPhj6WyKODwdHUNSFujT7CfNSKyj8zsoSWU
	7tw9Tms9/mtOagLSJIMAlSXaraxf/rgX2ZVlu6B1Mb3EKXUMZOtivfzXEFQizxqsXWOkQk
	tRbTgLx2VcBb5GmOTFbuzvyCY3rjlIg=
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-88fc1e7b9a9so1476045241.1
        for <linux-mm@kvack.org>; Sun, 17 Aug 2025 00:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755416537; x=1756021337; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GjSk5VRdvKomb6mdzBClnCiEwN9IeEsY1qdY5nKEP/w=;
        b=l7ngRu9TAgfNAON0PN1+CP8uXsJR4VLEohZasxfGZdOFTSN7tTVDNPBdg7aNjXahzL
         orZfhEfHL9VAb70fVF7dOEziBxf1Y6RWCPaJIbX1K6oMOono1TUf/rwd2tdhtw99ORth
         wEcPlD/QmHPsyY40+t3QuR2ixHI9+VdjLaf2fq02VlTjrLZ00l1PrLFZ/Zr9/pf3Gm/Y
         wcUwuoVSMwSvRuCsjcMlnNxkRZOh+sn5qPXa9m6HHHnCA/dWVRIptph3N3uv8Ddu7hSr
         7SSIRW91dMPI+NRYFcLTQCYeHVHJ1IbfZ3ZwEDczOF17NM0ftBtC2841Jkwrug4VpjSf
         TgsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755416537; x=1756021337;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GjSk5VRdvKomb6mdzBClnCiEwN9IeEsY1qdY5nKEP/w=;
        b=Ph7NcmREAS0qbdiFSa3Mat0C2P7tAW1FDPT6y441mZl/BUkSMlrvboGfBMX4KEpYQe
         NY74HmP4VVDvqzu34ZE2/4bbTRNceezCIGLCfgMjgbEKvRMHj8Aj7HzmRs1Bo0VK/p/o
         kh4JVfUzpE5r4tpY85qZIPa6iaxy6qJN0P8iG+DdZ7Ozz7EsLg36uRK4by5MpGZUsQ14
         j8ClNEUwe/Afyo6gt2NGKL+vBsTGadjgOGTQxLfZOyeofNRk4hS+vPK4nfXqGw7DGp7D
         tEUBvzUqhWeVVXxaKIb+0R+9RHeacYA5//Cxc+xoz6jYJCfAaShvSySeiOkRqY4tzUyZ
         mjcQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5TLmE6cAxfILjqmrYIuAMrgWJmHb65/fAa7wYAKIJ3Px3RLoDjoThmKjR2Z0shk53zt9NOG+m7w==@kvack.org
X-Gm-Message-State: AOJu0YzjYM1zoa9FVT8Ki6G7YCpGNQH/Ubg0EzzT7ZeNOSCPSJyq6SkM
	CLkxUSkkhDLirTLmcxN/1DA0ENP4M+GgJ8Dpj4NqlU2fejVMnlpRCQodNYJmib74zQVF4Y3LB/y
	3iqrwFuXXz/hCmaZxeGNpZBgpEqc7g3HwHPyd
X-Gm-Gg: ASbGncuWghzTwsBB4kNsVf8iS7ayFnPV4tQXolj3Ufx77pLseDqCKLUokYWMDZ6VyEN
	WUS0TchIhN5XoQ7gWBr6w9SCrl2MEc0DefVcDwBc1nc5Pmo/mz4kKGwwwezJ86pwz4noQmsUW+H
	aL0dilTD9JMTUMUdNolWaHBOaXoqBse/Q62wtM+I78mhb7LSPG0I6h2RQdMipGhrt2tWERc7f2v
	Fq6qwul5Vypw4s=
X-Google-Smtp-Source: AGHT+IHN0MFYkmh2grTGNSZOLBMHeOaKlUGi9BSAOyJWy2IKMR0ry4EY5Iryj61iC36+0Tm5EFtjqDHkfiUffrEOE44=
X-Received: by 2002:a05:6102:4420:b0:4e2:a235:24d1 with SMTP id
 ada2fe7eead31-5124f1d0fbemr3138711137.4.1755416536765; Sun, 17 Aug 2025
 00:42:16 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:612c:6c0d:b0:4eb:ab80:b2af with HTTP; Sun, 17 Aug 2025
 00:42:16 -0700 (PDT)
In-Reply-To: <20250816143129.u2rdwpwvfhsdptvx@master>
References: <20250816040113.760010-1-aboorvad@linux.ibm.com>
 <20250816040113.760010-5-aboorvad@linux.ibm.com> <20250816143129.u2rdwpwvfhsdptvx@master>
From: Giant Sand Fans <rampxxxx@gmail.com>
Date: Sun, 17 Aug 2025 09:42:16 +0200
X-Gm-Features: Ac12FXzlUeLUc1iIDvljkIy8XWqHwyqjpvgIVWKdlKol8rosPinuM5zcnTUyFB4
Message-ID: <CABPJ0vja95qLmJA3uRa3MhCfDX3GoLJ6MHu881Z=sZuVdBbbEg@mail.gmail.com>
Subject: Re: [PATCH v4 4/7] mm/selftests: Fix split_huge_page_test failure on
 systems with 64KB page size
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "shuah@kernel.org" <shuah@kernel.org>, 
	"pfalcato@suse.de" <pfalcato@suse.de>, "david@redhat.com" <david@redhat.com>, "ziy@nvidia.com" <ziy@nvidia.com>, 
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, "npache@redhat.com" <npache@redhat.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"baohua@kernel.org" <baohua@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"donettom@linux.ibm.com" <donettom@linux.ibm.com>, "ritesh.list@gmail.com" <ritesh.list@gmail.com>
Content-Type: multipart/alternative; boundary="0000000000001b5b05063c8ac317"
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 01DA8180007
X-Stat-Signature: p4339x9w9mccwdtb4aasy4qmzf5iae13
X-HE-Tag: 1755416537-900197
X-HE-Meta: U2FsdGVkX19ttelj/V6KRtVyy+9PxpIyw6MzRQFUEsOcaOcdJ5TTOi6MXAydDexORHOpNKrkPuDZ34f/b34+U0T8WzapqV5C/b7+jyLjkHLGrVr0M3MEcJn9799KWkX0QYoGLZEMHgUkyQeGyNBfHoXUCzTZ6aMLH26UDs/nRNwb7pneiSZr67XuWI04FKytcnuyzMo+2SJ+uB4x77fmJRHQgKWAxWgHozV7TddvDMS4aSWjkWnJz50Agk+YFeuKXqXW+G19dBpW6Lea5SzNVwO2tBmYfwQo08W6xZhZUTbXsiqRGwREDVK5d1vwbgjIGC6PuopSh/35ZQAS/p7JOHM86tZxDEVMo3VTiInO4FymEV0NCnVWcVnGoi7PVZ9QoASuTiwj4YFFM7BkwmkPj4J5nW6J+/V9U2VsMfxrSWjqybS9aV+IbiZhDUbR7KE5YM55BjqpOmSnT1aeFaZj9XC6Ki4JUv9/3fmIVy4ZuFGM4VjrsfzZzWRTVTrhJTvXPZEQx0N1whnTeTTjqg/zW7QDYcEAEz9uefp+WRqas/8wSDe/U7c4L17ShNzAOFFY+KPfmK34zVnGmWz0+AXPUUQxXgo1yZFq6OjFYsdZr5WhQZB9qYYD6FOk7LbD7/mlb+1abJIqyhRyXwM5RWcMXMkb06t0m5/2wPXXlQWufQMHz4e32aPKlBemz7qO3DOn7MUUGlHKgCC1CrzyrVZhdiQb31ztR+3IgTmDGd8HRe1N6ggCToGfoAwAf555/9tkELGEM6up+7yKllTEPAeHJ4oAg7Stq7RBBDNq4+f6lCvq/OQ6/I7gDge0eLc/esg71fRj4noKe4zTmwKZ5cpqw4jNLDeCH91pA3W9rZeQTack+efUPjQNGcYxS2/e3ur3XoBrfQgQyKMGTCF3Hd8npLNGILj/rKWCcaZ0MMn8+fLQkpXuVjNLXtHqsVGQ+c8MPi5ezHUJ0njvj3QZ+lr
 9Jahc6X6
 NTac258KOVHIIAhXgdPVYxTeK9D96kYozFLOlYIx8xcuDqwQ+2Wa12byR/ojMS9xB07fkJUmi9ylmdjFFssJx0M1nagcWdjrinT2kNF5tWtUF5VFaHA1soOSUFbFo6Ho6VU+VoWPLlIeBAexNuGlehQHa1eSIgqkzTzbf+A9553njnccLIXbLuUmnpqEWjueeL4GWYXYQSp2eKUXkf8jFJ4fiDySrE/z4VRf6BbLUHMKv50i57pCvh5JF9XoHLJo0gSQlePG3f19+7RkHMXQkEScvrbgXEClKFlIt/s+HxhWjDuPTCsyM4Q+aMGA95o0tUFSHYBDdBTIVk2Ub/zvc0KvsmkHuCbNd8AFCMkpoqh81T0ddaeKY5x84XwrXC1OLv5Tp+iaUEOznnx/MOi9f2QRQ5PX06cvB/rBSIV4HM6fOWDFRpvSfpGnalBwNvvJPnxwlCiUAu3vI5REjS0WNjpiE7Tr4KvmGpNZtXtCq7ALPb+rcULKD1nvyj8OXQTa2tx+CgrEg+upr1/fT6IhVUXcJt+03jsAjkKkaLSQkVQVgxKXZ0QaGLI0DT93Y1IC74PDf4YzCn0JFPIw+62a35OmFKVT5xh7AadexZnI0QOxvQwFIb+nmSc6ZnahkFJLKltazjcOM8+SuRHtg+POy5nb4OTa1HSbkrAEZkb2dcaABRgb75l/3c+W8TFVVrimhe+c5SIyRYpEyWVHi5EzmLjoCnywZ1NcXoDRpmPdYXfqeJz//UY8ja60iYLZhXF3Kow/p3nXXe6HXisdOYtqi93rUPPuKytd+aoDwXs9Iy0jn0nHc0F56ZE0dVY5EKALhh5+q9zwoKFgscyVIe61DQ4qVbKw+MsnPZcEV5UvVWcwZQbEPxU3j0EnYpH+ROCrM+wvi1+3wX901nVw+V9XaNpz2xA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000001b5b05063c8ac317
Content-Type: text/plain; charset="UTF-8"

On Saturday, 16 August 2025, Wei Yang <richard.weiyang@gmail.com> wrote:
> On Sat, Aug 16, 2025 at 09:31:10AM +0530, Aboorva Devarajan wrote:
>>From: Donet Tom <donettom@linux.ibm.com>
>>
>>The split_huge_page_test fails on systems with a 64KB base page size.
>>This is because the order of a 2MB huge page is different:
>>
>>On 64KB systems, the order is 5.
>>
>>On 4KB systems, it's 9.
>>
>>The test currently assumes a maximum huge page order of 9, which is only
>>valid for 4KB base page systems. On systems with 64KB pages, attempting
>>to split huge pages beyond their actual order (5) causes the test to fail.
>>
>>In this patch, we calculate the huge page order based on the system's base
>>page size. With this change, the tests now run successfully on both 64KB
>>and 4KB page size systems.
>>
>>Fixes: fa6c02315f745 ("mm: huge_memory: a new debugfs interface for
splitting THP tests")
>>Co-developed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
>>Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
>>Reviewed-by: Dev Jain <dev.jain@arm.com>
>>Reviewed-by: Zi Yan <ziy@nvidia.com>
>>Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
>
> Nit below:
>
>>---
>> tools/testing/selftests/mm/cow.c              |  5 -----
>> .../selftests/mm/split_huge_page_test.c       | 22 ++++++++++++-------
>> tools/testing/selftests/mm/uffd-wp-mremap.c   |  5 -----
>> tools/testing/selftests/mm/vm_util.h          |  5 +++++
>> 4 files changed, 19 insertions(+), 18 deletions(-)
>>
>>diff --git a/tools/testing/selftests/mm/cow.c
b/tools/testing/selftests/mm/cow.c
>>index 90ee5779662f..e742d9313798 100644
>>--- a/tools/testing/selftests/mm/cow.c
>>+++ b/tools/testing/selftests/mm/cow.c
>>@@ -41,11 +41,6 @@ static size_t hugetlbsizes[10];
>> static int gup_fd;
>> static bool has_huge_zeropage;
>>
>>-static int sz2ord(size_t size)
>>-{
>>-      return __builtin_ctzll(size / pagesize);
>>-}
>>-
>> static int detect_thp_sizes(size_t sizes[], int max)
>> {
>>       int count = 0;
>>diff --git a/tools/testing/selftests/mm/split_huge_page_test.c
b/tools/testing/selftests/mm/split_huge_page_test.c
>>index eadbeb820d71..7cbeaebc9d71 100644
>>--- a/tools/testing/selftests/mm/split_huge_page_test.c
>>+++ b/tools/testing/selftests/mm/split_huge_page_test.c
>>@@ -523,6 +523,9 @@ int main(int argc, char **argv)
>>       const char *fs_loc;
>>       bool created_tmp;
>>       int offset;
>>+      unsigned int max_order;
>>+      unsigned int nr_pages;
>>+      unsigned int tests;
>>
>>       ksft_print_header();
>>
>>@@ -534,35 +537,38 @@ int main(int argc, char **argv)
>>       if (argc > 1)
>>               optional_xfs_path = argv[1];
>>
>>-      ksft_set_plan(1+8+1+9+9+8*4+2);
>>-
>>       pagesize = getpagesize();
>>       pageshift = ffs(pagesize) - 1;
>>       pmd_pagesize = read_pmd_pagesize();
>>       if (!pmd_pagesize)
>>               ksft_exit_fail_msg("Reading PMD pagesize failed\n");
>>
>>+      nr_pages = pmd_pagesize / pagesize;
>>+      max_order =  sz2ord(pmd_pagesize);
>                     ^
>                     extra space here
>
>>+      tests = 2 + (max_order - 1) + (2 * max_order) + (max_order - 1) *
4 + 2;

Is it possible to have some defines here instead plain numbers?
Thanks

>>+      ksft_set_plan(tests);
>>+
>>       fd_size = 2 * pmd_pagesize;
>>
>>       split_pmd_zero_pages();
>>
>
> --
> Wei Yang
> Help you, Help me
>
>

-- 
__________________________________________________
Linux 30 birthday!
https://www.linuxfoundation.org/en/linux30th/
Choosing Firefox isn't just choosing a browser. It's a vote for personal
freedom online. Here's how you can help
<https://www.mozilla.org/en-US/etc/firefox/retention/thank-you-a/?utm_source=desktop-snippet&utm_medium=snippet&utm_campaign=FirefoxBirthday&utm_term=9594&utm_content=REL_ESR&sample_rate=0.001&snippet_name=9594>
.
Please avoid sending me Word or PowerPoint attachments.
See http://www.gnu.org/philosophy/no-word-attachments.html
Happy 30th Birthday, GNU project <https://gnu.org/gnu30/>

--0000000000001b5b05063c8ac317
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<br><br>On Saturday, 16 August 2025, Wei Yang &lt;<a href=3D"mailto:richard=
.weiyang@gmail.com">richard.weiyang@gmail.com</a>&gt; wrote:<br>&gt; On Sat=
, Aug 16, 2025 at 09:31:10AM +0530, Aboorva Devarajan wrote:<br>&gt;&gt;Fro=
m: Donet Tom &lt;<a href=3D"mailto:donettom@linux.ibm.com">donettom@linux.i=
bm.com</a>&gt;<br>&gt;&gt;<br>&gt;&gt;The split_huge_page_test fails on sys=
tems with a 64KB base page size.<br>&gt;&gt;This is because the order of a =
2MB huge page is different:<br>&gt;&gt;<br>&gt;&gt;On 64KB systems, the ord=
er is 5.<br>&gt;&gt;<br>&gt;&gt;On 4KB systems, it&#39;s 9.<br>&gt;&gt;<br>=
&gt;&gt;The test currently assumes a maximum huge page order of 9, which is=
 only<br>&gt;&gt;valid for 4KB base page systems. On systems with 64KB page=
s, attempting<br>&gt;&gt;to split huge pages beyond their actual order (5) =
causes the test to fail.<br>&gt;&gt;<br>&gt;&gt;In this patch, we calculate=
 the huge page order based on the system&#39;s base<br>&gt;&gt;page size. W=
ith this change, the tests now run successfully on both 64KB<br>&gt;&gt;and=
 4KB page size systems.<br>&gt;&gt;<br>&gt;&gt;Fixes: fa6c02315f745 (&quot;=
mm: huge_memory: a new debugfs interface for splitting THP tests&quot;)<br>=
&gt;&gt;Co-developed-by: Aboorva Devarajan &lt;<a href=3D"mailto:aboorvad@l=
inux.ibm.com">aboorvad@linux.ibm.com</a>&gt;<br>&gt;&gt;Signed-off-by: Aboo=
rva Devarajan &lt;<a href=3D"mailto:aboorvad@linux.ibm.com">aboorvad@linux.=
ibm.com</a>&gt;<br>&gt;&gt;Reviewed-by: Dev Jain &lt;<a href=3D"mailto:dev.=
jain@arm.com">dev.jain@arm.com</a>&gt;<br>&gt;&gt;Reviewed-by: Zi Yan &lt;<=
a href=3D"mailto:ziy@nvidia.com">ziy@nvidia.com</a>&gt;<br>&gt;&gt;Signed-o=
ff-by: Donet Tom &lt;<a href=3D"mailto:donettom@linux.ibm.com">donettom@lin=
ux.ibm.com</a>&gt;<br>&gt;<br>&gt; Reviewed-by: Wei Yang &lt;<a href=3D"mai=
lto:richard.weiyang@gmail.com">richard.weiyang@gmail.com</a>&gt;<br>&gt;<br=
>&gt; Nit below:<br>&gt;<br>&gt;&gt;---<br>&gt;&gt; tools/testing/selftests=
/mm/cow.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 5 -----<b=
r>&gt;&gt; .../selftests/mm/split_huge_page_test.c=C2=A0 =C2=A0 =C2=A0 =C2=
=A0| 22 ++++++++++++-------<br>&gt;&gt; tools/testing/selftests/mm/uffd-wp-=
mremap.c=C2=A0 =C2=A0|=C2=A0 5 -----<br>&gt;&gt; tools/testing/selftests/mm=
/vm_util.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 5 +++++<br>&gt;&gt; 4 =
files changed, 19 insertions(+), 18 deletions(-)<br>&gt;&gt;<br>&gt;&gt;dif=
f --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow=
.c<br>&gt;&gt;index 90ee5779662f..e742d9313798 100644<br>&gt;&gt;--- a/tool=
s/testing/selftests/mm/cow.c<br>&gt;&gt;+++ b/tools/testing/selftests/mm/co=
w.c<br>&gt;&gt;@@ -41,11 +41,6 @@ static size_t hugetlbsizes[10];<br>&gt;&g=
t; static int gup_fd;<br>&gt;&gt; static bool has_huge_zeropage;<br>&gt;&gt=
;<br>&gt;&gt;-static int sz2ord(size_t size)<br>&gt;&gt;-{<br>&gt;&gt;-=C2=
=A0 =C2=A0 =C2=A0 return __builtin_ctzll(size / pagesize);<br>&gt;&gt;-}<br=
>&gt;&gt;-<br>&gt;&gt; static int detect_thp_sizes(size_t sizes[], int max)=
<br>&gt;&gt; {<br>&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int count =3D 0;<br>&g=
t;&gt;diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tool=
s/testing/selftests/mm/split_huge_page_test.c<br>&gt;&gt;index eadbeb820d71=
..7cbeaebc9d71 100644<br>&gt;&gt;--- a/tools/testing/selftests/mm/split_hug=
e_page_test.c<br>&gt;&gt;+++ b/tools/testing/selftests/mm/split_huge_page_t=
est.c<br>&gt;&gt;@@ -523,6 +523,9 @@ int main(int argc, char **argv)<br>&gt=
;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0const char *fs_loc;<br>&gt;&gt;=C2=A0 =C2=
=A0 =C2=A0 =C2=A0bool created_tmp;<br>&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0in=
t offset;<br>&gt;&gt;+=C2=A0 =C2=A0 =C2=A0 unsigned int max_order;<br>&gt;&=
gt;+=C2=A0 =C2=A0 =C2=A0 unsigned int nr_pages;<br>&gt;&gt;+=C2=A0 =C2=A0 =
=C2=A0 unsigned int tests;<br>&gt;&gt;<br>&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=
=A0ksft_print_header();<br>&gt;&gt;<br>&gt;&gt;@@ -534,35 +537,38 @@ int ma=
in(int argc, char **argv)<br>&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (argc &g=
t; 1)<br>&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0opt=
ional_xfs_path =3D argv[1];<br>&gt;&gt;<br>&gt;&gt;-=C2=A0 =C2=A0 =C2=A0 ks=
ft_set_plan(1+8+1+9+9+8*4+2);<br>&gt;&gt;-<br>&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =
=C2=A0pagesize =3D getpagesize();<br>&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0pag=
eshift =3D ffs(pagesize) - 1;<br>&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0pmd_pag=
esize =3D read_pmd_pagesize();<br>&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!p=
md_pagesize)<br>&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0ksft_exit_fail_msg(&quot;Reading PMD pagesize failed\n&quot;);<br>&gt=
;&gt;<br>&gt;&gt;+=C2=A0 =C2=A0 =C2=A0 nr_pages =3D pmd_pagesize / pagesize=
;<br>&gt;&gt;+=C2=A0 =C2=A0 =C2=A0 max_order =3D=C2=A0 sz2ord(pmd_pagesize)=
;<br>&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 ^<br>&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 extra space here<br>&gt;<br>&gt;&gt;+=C2=A0 =C2=A0 =C2=A0 tes=
ts =3D 2 + (max_order - 1) + (2 * max_order) + (max_order - 1) * 4 + 2;<br>=
<br>Is it possible to have some defines here instead plain numbers?<br>Than=
ks <br><br>&gt;&gt;+=C2=A0 =C2=A0 =C2=A0 ksft_set_plan(tests);<br>&gt;&gt;+=
<br>&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0fd_size =3D 2 * pmd_pagesize;<br>&gt=
;&gt;<br>&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0split_pmd_zero_pages();<br>&gt;=
&gt;<br>&gt;<br>&gt; --<br>&gt; Wei Yang<br>&gt; Help you, Help me<br>&gt;<=
br>&gt;<br><br>-- <br><div dir=3D"ltr"><div><div dir=3D"ltr"><div><div dir=
=3D"ltr"><div><div dir=3D"ltr"><div><div dir=3D"ltr">______________________=
____________________________</div><div>Linux 30 birthday!</div><div dir=3D"=
ltr"><a href=3D"https://www.linuxfoundation.org/en/linux30th/" target=3D"_b=
lank">https://www.linuxfoundation.org/en/linux30th/</a><br></div><div dir=
=3D"ltr">Choosing Firefox isn&#39;t just choosing a browser. It&#39;s a vot=
e for personal freedom online. <a href=3D"https://www.mozilla.org/en-US/etc=
/firefox/retention/thank-you-a/?utm_source=3Ddesktop-snippet&amp;utm_medium=
=3Dsnippet&amp;utm_campaign=3DFirefoxBirthday&amp;utm_term=3D9594&amp;utm_c=
ontent=3DREL_ESR&amp;sample_rate=3D0.001&amp;snippet_name=3D9594" target=3D=
"_blank">Here&#39;s how you can help</a>.</div><div dir=3D"ltr">Please avoi=
d sending me Word or PowerPoint attachments.<br>See <a href=3D"http://www.g=
nu.org/philosophy/no-word-attachments.html" target=3D"_blank">http://www.gn=
u.org/philosophy/no-word-attachments.html</a><div><a href=3D"https://gnu.or=
g/gnu30/" target=3D"_blank">Happy 30th Birthday, GNU project</a></div></div=
></div></div></div></div></div></div></div></div><br>

--0000000000001b5b05063c8ac317--

