Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07EA2C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 08:49:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D34666B00A9; Wed,  1 Jul 2026 04:49:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBDCE6B00AD; Wed,  1 Jul 2026 04:49:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5F0B6B00AE; Wed,  1 Jul 2026 04:49:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 819D66B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:49:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 050161A0295
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:49:03 +0000 (UTC)
X-FDA: 84939583008.30.BE299AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 37C3F2000E
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:49:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UHHaODqK;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782895742;
	b=6dZQXF+N3/Q5s4WhZx7njYtse1rAq2DC7W0SGaVsh9AyOFl42p33m9ZeHObis5wAZvq1oB
	3FSnZ6XU5x2O+/nWOPj57qGok4WARS8ncXlIvAV83H8hmf5QELzM+LXF8qVNou2evmVrAO
	VY/jcywsOsprswoQcAE3wy4MKJjM434=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782895742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qwh3iCvPoscNvLdWAClhJFPVit/GjXCDqMIF/PB2xCY=;
	b=vZV3AsQXJA1WvLikBEw/r3h/LWGRO+YjukaMDrc9EmPNKncgTWBzH/10rMdSjSvqBB3+C6
	ZHoJAjiM2ebZctX+qqqSjSBoT9w8ANE6rt8via+hJrI8jBi98ivk4gqTBXliKlU4K+B/Nt
	3HVsWSmtX5bVJbwVjTiXpsTN1Ux7Fc0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UHHaODqK;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3184D4406B;
	Wed,  1 Jul 2026 08:49:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93CD1F00A3E;
	Wed,  1 Jul 2026 08:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782895741;
	bh=Qwh3iCvPoscNvLdWAClhJFPVit/GjXCDqMIF/PB2xCY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UHHaODqKt/7I9kXLn5TRk/fGFrTWSf+1LZEkQYk+MTXMVHcxP82H+QCE1Q4eJRcV4
	 ASOoFiFBROJEEEqNF1rVfK9VdTGcwlgUdmZzWiXZoCqoEu1Wi6o36I5lzUkAywYgot
	 t7axQEnnKW2HBT98BSGCa89fsvXVNaBwyuYW4znYMpISemm7MRb90bgvv1TxrRKBbM
	 em+fjdvJ7SYMrdhRnFWhGQDCzNP3ZH5nLCIEXNtwn3N+65hIlCfXa9NmJc4GrCbl4K
	 rGiwqMy6MYajD0EfCPwhZ+tNtN7YzoBE76wpWB6b+3JfTckZTOnz6L2ti/RA/UmALH
	 mIoCtChly3Liw==
Message-ID: <32a42e83-3e5e-4b00-b78c-d762094b9d76@kernel.org>
Date: Wed, 1 Jul 2026 10:48:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] selftests/mm: handle EINVAL when configuring
 gigantic hugepages
To: Sayali Patil <sayalip@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>,
 Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org,
 Miaohe Lin <linmiaohe@huawei.com>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1782811071.git.sayalip@linux.ibm.com>
 <3d394c8cd59fe380d4e2d13b051544f241918f07.1782811071.git.sayalip@linux.ibm.com>
 <ccba342f-1ed0-43fe-ac59-9b8bbfb168d4@kernel.org>
 <968b496a-a83e-491a-950c-3f6f975fa5f5@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <968b496a-a83e-491a-950c-3f6f975fa5f5@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: tda3jppnjkfs95o94oe531c96h637aq8
X-Rspamd-Queue-Id: 37C3F2000E
X-Rspamd-Server: rspam06
X-HE-Tag: 1782895742-249483
X-HE-Meta: U2FsdGVkX1/p8FWbi8Jxmyv8FeC3aGqyukEsmd9uE9ldJstHdVxlXV3NelaH25hdXyNor1r1S4uHDv1MFRV4LzXFv5p48KlK7eQfq5fFQwCS12OPmekAo5V+8cptfQ6l31BTzuNk8j+VBbwdAqy2uL6WzIw2483C1/55otVqKx0n4vH74mQZssRU2HV8trixacXglHd/OwACbAGhIoFSUlwvmxv+XF0sYb3Lbch0NoZ7gvlNUxRVG+zApjPzIpKBYvF3qrdMBREB1GPXH1AmyWZlQv6P+ZxhuaMb9AkMzzSCVhx1QKU22g0RLJI6SztQknZnDM2SbPv6wc7UExH5r2AB5pMuls57FAqwQCOW0VyzTAy+HH3sB0QBV7E0ioW4LGYbULAp0upgyTvzdmgfPuiFSkgeOlrlkFtcCXS6qI5/KV7203xaQmogbSX6RRrvXkzXPp8pFFXZ8TIPuTmhjTEy4Td0BamkH+KAq0rF6q5JXI+5RugTOtpeyE0DjwQIqCRBRGRVyEnNetvbUMdrR+48nwXrrbRE1Cy6GCjB6aIwwGdkaneiGNsyJfD7stLXC0BUvfntTjLBHtMzWecfkb/+Ewe/11O0U+NSj/qIvP+v/A6rbERFJ+TwYuI29L48wASUuHwaIbcdlnhwYfq8MAlM1tF8yJPQclofKCmta72GyUwJ3QwXa15aeDGjKIxfZNHg/xZDr2ejLEhzIOM4oCSk49Lo8tuh8TUU7P0YI+lBjpJUvJMF67PE6zgu6z3tfSwunxbvpoNy/rijmrxol9WAkgt+akLkLF11ZcBXw3Ul3kSpu4+/94cHxtrNcu2G5v/FlqGAwPoO5cqF9t2hNX3fogwYfWJRsyoFlcasVuFDgWeJaU0KSMeRTr+SArSVivHRcZtIBAhbynHeSqGy+mg1wwfZ0rtbpa+IaKiL6rHYASvuWXJKM/h/ZA2VZQp27xOQaKkSsZg5SBwOAfq
 pqhVFc8a
 6RucIwltyH3LT36Iaf3+t3esomc8vMccTVN8kHH06l7WNUoc41S8eTFHscLCgq2wK2rDCe37qtfcT30VvgrKdr2fgks5CRtO7PWW02kMGeDlHDmP0rtRwzzteNgGDVgratV5w3l9e35B8faDTphYJdQvC9n6XD0BdmAqdyFOwwtSGP580UYRa5u0562LbRGOmWBTTX3j0pZX5hf4mwqyrnIVzIE9hoPzc1U/Ounn0faTntiELISk7aiqbr7nBydcqWlrV22jHNit0LB+ArmqgwnzPh2Wjq2x1jDJL58Fue16+hDf4ilSvx/HKZCCdpJvLPWIMuwlirkbXy4S9Y0UUKQ+N6GRqvMVnoaYHei07X4R1CwdN3HPTqF3LfBxuYQaWnmXmpBprmVsNx5scurj5i/ytXi4UbkZFe/1H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 22:20, Sayali Patil wrote:
> 
> 
> On 30/06/26 16:15, David Hildenbrand (Arm) wrote:
>> On 6/30/26 11:32, Sayali Patil wrote:
>>> Some MM selftests attempt to configure the amount of
>>> HugeTLB pages of different sizes by writing to nr_hugepages.
>>>
>>> PowerPC hash MMU pSeries systems advertise gigantic hugepage sizes
>>> but do not support runtime allocation of such pages, writes
>>> to the corresponding nr_hugepages file fail with -EINVAL.
>>> This causes the test to bail out even though the failure is due
>>> to a platform limitation rather than the
>>> functionality being tested.
>>>
>>> Treat -EINVAL from the sysfs write as a skipped configuration request
>>> and continue running the test instead of failing.
>>>
>>> Before patch:
>>>     -------------------------
>>>     running ./hugetlb-madvise
>>>     -------------------------
>>>     TAP version 13
>>>     1..1
>>>       [INFO] detected hugetlb page size: 16777216 KiB
>>>       [INFO] detected hugetlb page size: 16384 KiB
>>>      ok 1 MADV_DONTNEED and MADV_REMOVE on hugetlb
>>>      Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>>>      Bail out! /sys/kernel/mm/hugepages/hugepages-16777216kB/nr_hugepages
>>>      write(0) failed: Invalid argument
>>>      Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
>>>      [FAIL]
>>>
>>> After patch:
>>>     -------------------------
>>>     running ./hugetlb-madvise
>>>     -------------------------
>>>     TAP version 13
>>>     1..1
>>>      [INFO] detected hugetlb page size: 16777216 KiB
>>>      [INFO] detected hugetlb page size: 16384 KiB
>>>     ok 1 MADV_DONTNEED and MADV_REMOVE on hugetlb
>>>     Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>>>     /sys/kernel/mm/hugepages/hugepages-16777216kB/nr_hugepages
>>>     write(0) failed: Invalid argument
>>>     [PASS]
>>>
>>> Fixes: 27477b28b74f ("selftests/mm: hugepage_settings: add APIs to get and
>>> set nr_hugepages")
>>> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
>>> ---
>>>   .../testing/selftests/mm/hugepage_settings.c  | 32 ++++++++++++++++++-
>>>   .../testing/selftests/mm/hugepage_settings.h  |  1 +
>>>   2 files changed, 32 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/
>>> selftests/mm/hugepage_settings.c
>>> index 2eab2110ac6a..ce38ae3da01a 100644
>>> --- a/tools/testing/selftests/mm/hugepage_settings.c
>>> +++ b/tools/testing/selftests/mm/hugepage_settings.c
>>> @@ -422,6 +422,36 @@ static void hugetlb_sysfs_path(char *buf, size_t buflen,
>>>            size / 1024, attr);
>>>   }
>>>   +void hugetlb_write_num(const char *path, unsigned long num)
>>> +{
>>> +    int fd, saved_errno;
>>> +    ssize_t numwritten;
>>> +    char buf[21];
>>> +
>>> +    sprintf(buf, "%lu", num);
>>> +
>>> +    fd = open(path, O_WRONLY);
>>> +    if (fd == -1)
>>> +        ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
>>> +
>>> +    numwritten = write(fd, buf, strlen(buf));
>>> +    saved_errno = errno;
>>> +    close(fd);
>>> +    errno = saved_errno;
>>> +
>>> +    /* Treat EINVAL as a skipped configuration (e.g., unsupported gigantic
>>> pages) */
>>> +    if (numwritten < 0 && errno == EINVAL) {
>>> +        ksft_print_msg("%s write(%s) failed: %s\n", path, buf,
>>> strerror(errno));
>>
>> Should we even print anything here? Rather confusing. It's just like we cannot
>> allocate anything (no memory).
>>
>> In general, you are copy-pasting a lot of write_num()+write_file() content,
>> which is really suboptimal.
>>
>> All you want is an option for write_num -> write_file to skip on -EINVAL,
>> correct?
>>
>> There are not that many write_num / write_file users ...
>>
> 
> Hi David,
> 
> Yes, all I need is to ignore the expected -EINVAL when attempting to
> configure gigantic hugepages via nr_hugepages.
> 
> I looked at extending write_num()/write_file() for this as in v1
> (https://lore.kernel.org/
> all/8bfa921e30eb94072685103f6496784aa23bb166.1782365671.git.sayalip@linux.ibm.com/),
> but these helpers are shared by several other selftests.
> For example, write_file() is used by split_huge_page_test setup and by
> khugepaged tests for drop_caches, and is also used for various THP and
> khugepaged settings where -EINVAL would indicate a genuine setup
> failure. This concern was also raised during the v1 review.
> 
> Because the expected -EINVAL is specific to gigantic hugepage runtime
> allocation, I kept the handling local to the hugetlb setup path rather
> than changing the semantics of the common helpers.
> 
> I also agree that printing a message is not particularly useful in this
> case, and we can simply return without emitting any output.

We can either convert the functions to use flags, or hide it in some internal helpers, like the following:

From 1b1b8ad51f1f0be469cb191736300254b9521fe4 Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 1 Jul 2026 10:45:16 +0200
Subject: [PATCH] tmp

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 tools/testing/selftests/mm/vm_util.c | 28 ++++++++++++++++++++++++----
 tools/testing/selftests/mm/vm_util.h |  1 +
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 311fc5b4513eb..362070f817e9b 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -719,7 +719,8 @@ int read_file(const char *path, char *buf, size_t buflen)
 	return (unsigned int) numread;
 }
 
-void write_file(const char *path, const char *buf, size_t buflen)
+static int __write_file(const char *path, const char *buf, size_t buflen,
+		bool ignore_einval)
 {
 	int fd, saved_errno;
 	ssize_t numwritten;
@@ -735,14 +736,23 @@ void write_file(const char *path, const char *buf, size_t buflen)
 	saved_errno = errno;
 	close(fd);
 	errno = saved_errno;
-	if (numwritten < 0)
+
+	if (numwritten < 0) {
+		if (ignore_einval && errno == EINVAL)
+			return;
 		ksft_exit_fail_msg("%s write(%.*s) failed: %s\n", path, (int)(buflen - 1),
 				buf, strerror(errno));
+	}
 	if (numwritten != buflen - 1)
 		ksft_exit_fail_msg("%s write(%.*s) is truncated, expected %zu bytes, got %zd bytes\n",
 				path, (int)(buflen - 1), buf, buflen - 1, numwritten);
 }
 
+static void write_file(const char *path, const char *buf, size_t buflen)
+{
+	__write_file(path, bug, buflen, /* ignore_einval = */ false);
+}
+
 unsigned long read_num(const char *path)
 {
 	char buf[21];
@@ -753,12 +763,22 @@ unsigned long read_num(const char *path)
 	return strtoul(buf, NULL, 10);
 }
 
-void write_num(const char *path, unsigned long num)
+static void __write_num(const char *path, unsigned long num, bool ignore_einval)
 {
 	char buf[21];
 
 	sprintf(buf, "%lu", num);
-	write_file(path, buf, strlen(buf) + 1);
+	write_file(path, buf, strlen(buf) + 1, ignore_einval);
+}
+
+void write_num(const char *path, unsigned long num)
+{
+	return __write_num(path, num, /* ignore_einval = */ false);
+}
+
+void write_num_ignore_einval(const char *path, unsigned long num)
+{
+	return __write_num(path, num, /* ignore_einval = */ true);
 }
 
 static unsigned long shmall, shmmax;
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index ea8fc8fdf0eb0..7799154b67eed 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -168,6 +168,7 @@ void write_file(const char *path, const char *buf, size_t buflen);
 int read_file(const char *path, char *buf, size_t buflen);
 unsigned long read_num(const char *path);
 void write_num(const char *path, unsigned long num);
+void write_num_ignore_einval(const char *path, unsigned long num);
 
 void shm_limits_prepare(unsigned long length);
 void __shm_limits_restore(void);
-- 
2.43.0


-- 
Cheers,

David

