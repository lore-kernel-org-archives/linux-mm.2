Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E51B410FCADE
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 21:01:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3B436B0005; Wed,  1 Apr 2026 17:01:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F12AB6B0089; Wed,  1 Apr 2026 17:01:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4FA66B008A; Wed,  1 Apr 2026 17:01:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CEFA26B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:01:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 474A6574ED
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:01:25 +0000 (UTC)
X-FDA: 84611207730.26.86F7EE1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7A588C0018
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:01:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hUYT0NQw;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775077283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=69lXlGdVKtDyNP4ViKefdZVTEtj4mCqE6l6FtKX+v1g=;
	b=OAcd1Us5xxYSXgBdZdYTnT9WooqvSGzadPiPg9R/R48GApKseKQdnS/dl6nGyFs3IzSYZa
	IgOwVTri+2MmWtMVEoTHaNi/27jzUBhvbaqO3bGTs1hd8LwnIvUmzZJIBhWSAc8SKfc08l
	t8O2v02kQfax5DerZ+o2uAMOEc6foLE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775077283; a=rsa-sha256;
	cv=none;
	b=1iACJ0XQJeodWT3sJkqo70YJWhckLAdBv+FWi11PMBwXwWyAO8bItvTUDLfv90884d/Ewz
	tli2UAD3CPR2+araKS1U1DaeHBbghGlDj075y7Y2miS/tF8FzqqOb1tuzTJkj5sFzcsC+h
	PujzKAjwbjTo1sutRUSRQqwzXQloKo0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hUYT0NQw;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7751C61340;
	Wed,  1 Apr 2026 21:01:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32BFC116C6;
	Wed,  1 Apr 2026 21:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775077282;
	bh=O8Vo4jZDWqqW0uxQ2thCeW0mz8X2oEjk8T/VgT+wO6E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hUYT0NQwE1/aqyZL6tnYr8vsofwQSlwRlkfoXcyTUN7oAj4RVLQMrS7DjPVj93Yih
	 pk1v5NE3GBqu4oRB//kra+8WheLUs+YSTYiuz5GCf2burXypwSe6dfdDANy/nq5Nyh
	 ne0uu0GVYVP+ORus40ex+AQ5AP0IHcZUErLCWTN4=
Date: Wed, 1 Apr 2026 14:01:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Wang <liwang@redhat.com>
Cc: rppt@kernel.org, david@kernel.org, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, aubaker@redhat.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5] selftests/mm: skip hugetlb_dio tests when DIO
 alignment is incompatible
Message-Id: <20260401140121.23643cf9784ae8dafd9f0ab6@linux-foundation.org>
In-Reply-To: <20260401090520.24018-1-liwang@redhat.com>
References: <20260401090520.24018-1-liwang@redhat.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: urs1rhat7kd16fo7oyzroq96nyijige1
X-Rspamd-Queue-Id: 7A588C0018
X-Rspam-User: 
X-HE-Tag: 1775077283-239918
X-HE-Meta: U2FsdGVkX18rS2A3Es9CF9KjXUG04SCHTHHMT6sNvy0Ac5RlOfzWpvRspzCvePV7H7KzxX+eU1UldeYYMQhqpzKmCgNDAsdwzpcuourOEuqOOP+t3Vx0E8O0Z8tn8ACOFp04tO94xZQ40wdi/yP41M3gzmri19MrjDa3JzQBl5ZcS7mkUH64xWG0xAIEiq/7GbocBIxY9WaPovliCNgbLn/7vLxngOhriRcIpxJSLNksyjK1zCfYoL4kWV6C/p7cxEE2FmXsN4rgs8dVjwNCOiAysIDxc+WVBmKWR77eYzPNFp2h9CI12NIIgGsJMTUY7v6oya9XDhql8KA0vuVRMEQy7tTqbA0TfUmFqDjyxMyp91LSLkTlvp0LTsO1o/EK7gdVYm9DAWEn1i1DSS4SUgz88Mf8L6d3ZPH+wz+UgvFuIDnlZtmjqyhorMgui+bVwwzs4LMpvQ2udsZ4qGPF2IknLwiZkUXA+QSzIOm4n4VYwEglTVaBm0XG/1aeeXmlmfcmLoLbFAY3FCJ6PVqprxgrBMEwTWvpTcIhcpqyxBXqYfCZH0mSxxVtMvTV8QHnDvXFIjRdV9vycsJKMiMLaUcLBadPxMOu7UwYUgJSUHVkHu4XSmBYoEcY2M2W1mKIONSScdnYlPfRhYNxQxVJW0nx57iGkFPPo98hJS6LwxGdXx3/3qv4XaL/14rh8dPJI8VcM0SoCkhT7r2fAvFLEslQmhpbSvLz1yFLoqF1INLV4EFIhVYqryj1RDwERL611i9S7mtqA+MBYuw0JND69Eg/UbDVQtcRf2KXXrF+QBJN5E2XRWCOcQxKIVfwK7+y2MLQmBRKk+e6PvoG6R6wO71cmn/imIiJckAlXGUzqnfPABIeysWPcoTjDrbp0Q9FEOzQhS1idkyMTPUhzh8sK80SQPQJdUf/WxfbbjFGoBE/b/eDf9OI9ucQmsCZB1o/mdZN6vZFhJfQ5SiRAlr
 iLrtjnHm
 mkaoqet4tMv8ZAsAuWobuajzgJ9kB7VH2j7Rx+QIWF5UAzTk59IH9F+YgPI8KXuZHLowCqnL8fEahX3m+qOc0McHuqY3Nis+j6DhQEl2cjEd3NPxT0xrDuVoqNly5Y2JOrSLlegJ7s8niZqoASxZF/1jbIPqefAuI6s858PJrxUmcHrz8a9bdS4nVkkXac1Lv+NFCjppMsrtc5NNJvpD3sNfiDj4ut1kxdx11BdX8yNQYa8CtsLra1QUQBuQurmE3lf5Fx0J2qbwLT/8Dv7ITfugLZM2LycVK958uiiil/OvTrQJhdFK60b06WgrdBKBLUVZG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  1 Apr 2026 17:05:20 +0800 Li Wang <liwang@redhat.com> wrote:

> hugetlb_dio test uses sub-page offsets (pagesize / 2) to verify that
> hugepages used as DIO user buffers are correctly unpinned at completion.
> 
> However, on filesystems with a logical block size larger than half the
> page size (e.g., 4K-sector block devices), these unaligned DIO writes
> are rejected with -EINVAL, causing the test to fail unexpectedly.
> 
> Add get_dio_alignment() to query the filesystem's required DIO alignment
> via statx(STATX_DIOALIGN) and skip individual test cases whose file
> offset or write size is not a multiple of that alignment. Aligned cases
> continue to run so the core coverage is preserved.
> 
> While here, open the temporary file once in main() and share the fd
> across all test cases instead of reopening it in each invocation.
> 
> === Reproduce Steps ===
> 
>   # dd if=/dev/zero of=/tmp/test.img bs=1M count=512
>   # losetup --sector-size 4096 /dev/loop0 /tmp/test.img
>   # mkfs.xfs /dev/loop0
>   # mkdir -p /mnt/dio_test
>   # mount /dev/loop0 /mnt/dio_test
> 
>   // Modify test to open /mnt/dio_test and rebuild it:
>   -       fd = open("/tmp", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
>   +       fd = open("/mnt/dio_test", O_TMPFILE | O_RDWR | O_DIRECT, 0664);
> 
>   # getconf PAGESIZE
>   4096
> 
>   # echo 100 >/proc/sys/vm/nr_hugepages
> 
>   # ./hugetlb_dio
>   TAP version 13
>   1..4
>   # No. Free pages before allocation : 100
>   # No. Free pages after munmap : 100
>   ok 1 free huge pages from 0-12288
>   Bail out! Error writing to file
>   : Invalid argument (22)
>   # Planned tests != run tests (4 != 1)
>   # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0

Thanks, I update mm.git to this version,

> Notes:
>     v5:
>     	- Perform that align checks at the beginning of run_dio_using_hugetlb()
>     	  but not addinital run_test().

Here's how v5 altered mm.git:

--- a/tools/testing/selftests/mm/hugetlb_dio.c~selftests-mm-skip-hugetlb_dio-tests-when-dio-alignment-is-incompatible-v5
+++ a/tools/testing/selftests/mm/hugetlb_dio.c
@@ -66,7 +66,7 @@ static bool check_dio_alignment(unsigned
 }
 
 static void run_dio_using_hugetlb(int fd, unsigned int start_off,
-				  unsigned int end_off)
+				unsigned int end_off, unsigned int align)
 {
 	char *buffer =  NULL;
 	char *orig_buffer = NULL;
@@ -77,6 +77,9 @@ static void run_dio_using_hugetlb(int fd
 	const int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB;
 	const int mmap_prot  = PROT_READ | PROT_WRITE;
 
+	if (!check_dio_alignment(start_off, end_off, align))
+		return;
+
 	writesize = end_off - start_off;
 
 	/* Get the default huge page size */
@@ -130,15 +133,6 @@ static void run_dio_using_hugetlb(int fd
 			 "free huge pages from %u-%u\n", start_off, end_off);
 }
 
-static void run_test(int fd, unsigned int start_off,
-		     unsigned int end_off, unsigned int align)
-{
-	if (!check_dio_alignment(start_off, end_off, align))
-		return;
-
-	run_dio_using_hugetlb(fd, start_off, end_off);
-}
-
 int main(void)
 {
 	int fd, align;
@@ -161,16 +155,16 @@ int main(void)
 	ksft_set_plan(4);
 
 	/* start and end is aligned to pagesize */
-	run_test(fd, 0, (pagesize * 3), align);
+	run_dio_using_hugetlb(fd, 0, (pagesize * 3), align);
 
 	/* start is aligned but end is not aligned */
-	run_test(fd, 0, (pagesize * 3) - (pagesize / 2), align);
+	run_dio_using_hugetlb(fd, 0, (pagesize * 3) - (pagesize / 2), align);
 
 	/* start is unaligned and end is aligned */
-	run_test(fd, pagesize / 2, (pagesize * 3), align);
+	run_dio_using_hugetlb(fd, pagesize / 2, (pagesize * 3), align);
 
 	/* both start and end are unaligned */
-	run_test(fd, pagesize / 2, (pagesize * 3) + (pagesize / 2), align);
+	run_dio_using_hugetlb(fd, pagesize / 2, (pagesize * 3) + (pagesize / 2), align);
 
 	close(fd);
 
_


