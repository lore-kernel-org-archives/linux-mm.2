Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A457CA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 06:15:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B96E16B064F; Sat, 16 Aug 2025 02:15:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6EAD6B0650; Sat, 16 Aug 2025 02:15:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AABCB6B0651; Sat, 16 Aug 2025 02:15:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9CA596B064F
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 02:15:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2FC7083084
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 06:15:54 +0000 (UTC)
X-FDA: 83781609828.12.B6071A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6308420007
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 06:15:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eFFcWNgi;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755324952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mvfn2XwYS9DPQargZ99v6D1br+JVcZeCFAIpSMHK/uE=;
	b=L327P4BdIJFTsBJ/C/XZlt1xlfcQ/qmTwzghi3pZmSgjJRgqLXyS1Qxbm/dHhTZjvwtCGW
	V9FXjLK5eLbtrnu3qKapvJFCUHH+ty52K2cV4fKBnlcfha4l/13ZEhVLMQyfXXg2Sdu23s
	FRNcCtBev+XLXFiqBX0KbH/LVINz0vo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eFFcWNgi;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755324952; a=rsa-sha256;
	cv=none;
	b=SAQu4b4O3Wzt/hCS2SNxuaZ/lyozSwbUeC0ODqA7zVB4ziCbj8by3LQMOr6nb+Ry7a5Eb/
	TWNKAVJkIgWXYDM2+1k7Q6gTTLqJV2qHfbs3Fc41GDPHg6GamtHiKvAbVEQvPKjajBAWw9
	kflDZgUd08puLfpLMaE9wbBctQkE+Gg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B898E43C1D;
	Sat, 16 Aug 2025 06:15:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7758C4CEEF;
	Sat, 16 Aug 2025 06:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755324950;
	bh=jheQbrl6mo7J2mKnNzaTKtMrCR9vMP2nmVKMbKRV5Ik=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=eFFcWNgiGcxyOJzwvTV+O8epT32CN6pMMrHQrTBnK47ltJ3kaFTY0YfDu8vbZ5l0E
	 Wo+IYTPEnoW9T0YtNcGyuIV5s85/amVROP+WqbjMtBCJpaF9eQycl9gpzK6QxUykxC
	 bWBY0jYi35xQg8n2VLrVqTZNqGDs6/nZDfBts/Kg=
Date: Fri, 15 Aug 2025 23:15:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: david@redhat.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 corbet@lwn.net, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 hannes@cmpxchg.org, baohua@kernel.org, shakeel.butt@linux.dev,
 riel@surriel.com, ziy@nvidia.com, laoar.shao@gmail.com, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 vbabka@suse.cz, jannh@google.com, Arnd Bergmann <arnd@arndb.de>,
 sj@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kernel-team@meta.com
Subject: Re: [PATCH v5 5/7] selftest/mm: Extract sz2ord function into
 vm_util.h
Message-Id: <20250815231549.1d7ef74fc13149e07471f335@linux-foundation.org>
In-Reply-To: <20250815135549.130506-6-usamaarif642@gmail.com>
References: <20250815135549.130506-1-usamaarif642@gmail.com>
	<20250815135549.130506-6-usamaarif642@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6308420007
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: rowg883omn6w3izb9q75nyi1g6qwgz4r
X-HE-Tag: 1755324952-450231
X-HE-Meta: U2FsdGVkX18DqZVYp2aA9yXvDRkmPE05uS1+z0pMGWAvsdlPt+wgLjO49iGPkEtmQeqHp1w+rIHCPbBnWMM0ZTAJbmtoxbLV8P06/DRHnqPX57lAztvJCmI6RaNZSTe5FmmDX6nyQjB9j3+4piPalEvzQkSP8LfCa4vmGOUt1yV/UEPOzzGJOSpH9FOi/Q7haozsoa8ahxTWsmkbSH6ZLUnImSOvxCILCYYzaVCCJpBOf1KAXXGpUbVcrZ9KNUajxw1uXcwr9erGO7EPoZkFhLpTgAODaDCVqP9IP3/9Q6bPazNb07YUhke/RNKTZ59ALOxixHsTldaq0HRC84ET2EOrPMMxoV+WFPlSXTUM9goDxVuyOefZdPMzap9ugZPHIFg2MVywyG9T8HAMxRrnnSlLOsgVatGsaWNXIgnOmsaLUMG5Ol0rZWhkRUMIkc3uSKRS0TxWJ8GzbtJMVcqrCzAnr4E0XCwQ7wv6uwX7rGVDVliL/7R0rUjgI2Rd6rjR46HLpHb/Vr1T687H0DQ19u0BkoaUwMv7ScZZypMdvgthdSQXe4weRh7cpGYFbRgdLtgdDHbTzVivoUa2FhkLFbUonRssAegmnlq1dpwbr4WRAEU+5q3QEe9PFaPTdFhApY39xTODpkVYH+wnNqNwv1Ev/77dMMQCbn1JHLCrE8enovuviyEIrnYwzDnQcTmlxAO0VNYfoH4IgYwN8iXXYZpJwPuHkHaWhmOnfkqyy9T6nTGGrjXq0LvQTKCiKe4vO1SA9i4TU3cA3knZEqN0hVw2pzMXIbqXgy/mMNzQnwtdWSB+1fn7UonHDD2MhfujnniL9REKc0/Ii+yLTk26DPTri43He2zYF60xANGYsd1AuN2ZS/m2+NbcOZ2/XnjjKU2iAzbWOXRavV5d3/LKhFTCGalDnDX3N8Wfk+/AiwxJsWSu5xoQp/KMpjPzytPta0vGwvaGLj2aOAovLHn
 NPAS0iTa
 KcLDM84WrMacBawc1G9VOFoBbthrV9jaSPHohF0GY6PtqoVlTQ03vnSa+I27JAKl5DZRNz9+kvLSTPYusRokg1/Yv1qxwMS0o1F6gLCet9wtfLbCsKiZAt64E4YieEGSSbjy0sCGxAvSOS5tLVJ/4ooyBgncq6PociILRTwpyVTDHOqzeCz7JkZfUKYrB7zwgNgblRdq3aJU0D64Vnc9rOA2WpSI7q5VeXNgO9VRHpXy0m0KAIyIi/wAZoEHa6o+0UujuZcF33znOOtHf2EFJta9oER/DCEg5T0/DE5ds/YRlxOXFCPtZPCYlBOLPJOie/euLUXCz1jdCNvkrGIoF0CGgNMgRpqqhpU/0KW9dzdSJqSDfDu9bocLXU3qmc9b/v3ZM9iMc119YDyKLWasOm6GTWMb6/Ie4wh0SjLOTcM2tXH4kWf69sga0N5xUpPzDuP49
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 15 Aug 2025 14:54:57 +0100 Usama Arif <usamaarif642@gmail.com> wrote:

> The function already has 2 uses and will have a 3rd one
> in prctl selftests. The pagesize argument is added into
> the function, as it's not a global variable anymore.
> No functional change intended with this patch.
> 

https://lkml.kernel.org/r/20250816040113.760010-5-aboorvad@linux.ibm.com
jut did this, but didn't add the extra arg. 
tools/testing/selftests/mm/split_huge_page_test.c needed updating.

--- a/tools/testing/selftests/mm/cow.c~selftest-mm-extract-sz2ord-function-into-vm_utilh
+++ a/tools/testing/selftests/mm/cow.c
@@ -52,7 +52,7 @@ static int detect_thp_sizes(size_t sizes
 	if (!pmdsize)
 		return 0;
 
-	orders = 1UL << sz2ord(pmdsize);
+	orders = 1UL << sz2ord(pmdsize, pagesize);
 	orders |= thp_supported_orders();
 
 	for (i = 0; orders && count < max; i++) {
@@ -1211,8 +1211,8 @@ static void run_anon_test_case(struct te
 		size_t size = thpsizes[i];
 		struct thp_settings settings = *thp_current_settings();
 
-		settings.hugepages[sz2ord(pmdsize)].enabled = THP_NEVER;
-		settings.hugepages[sz2ord(size)].enabled = THP_ALWAYS;
+		settings.hugepages[sz2ord(pmdsize, pagesize)].enabled = THP_NEVER;
+		settings.hugepages[sz2ord(size, pagesize)].enabled = THP_ALWAYS;
 		thp_push_settings(&settings);
 
 		if (size == pmdsize) {
@@ -1863,7 +1863,7 @@ int main(void)
 	if (pmdsize) {
 		/* Only if THP is supported. */
 		thp_read_settings(&default_settings);
-		default_settings.hugepages[sz2ord(pmdsize)].enabled = THP_INHERIT;
+		default_settings.hugepages[sz2ord(pmdsize, pagesize)].enabled = THP_INHERIT;
 		thp_save_settings();
 		thp_push_settings(&default_settings);
 
--- a/tools/testing/selftests/mm/uffd-wp-mremap.c~selftest-mm-extract-sz2ord-function-into-vm_utilh
+++ a/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -82,9 +82,9 @@ static void *alloc_one_folio(size_t size
 		struct thp_settings settings = *thp_current_settings();
 
 		if (private)
-			settings.hugepages[sz2ord(size)].enabled = THP_ALWAYS;
+			settings.hugepages[sz2ord(size, pagesize)].enabled = THP_ALWAYS;
 		else
-			settings.shmem_hugepages[sz2ord(size)].enabled = SHMEM_ALWAYS;
+			settings.shmem_hugepages[sz2ord(size, pagesize)].enabled = SHMEM_ALWAYS;
 
 		thp_push_settings(&settings);
 
--- a/tools/testing/selftests/mm/vm_util.h~selftest-mm-extract-sz2ord-function-into-vm_utilh
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -127,9 +127,9 @@ static inline void log_test_result(int r
 	ksft_test_result_report(result, "%s\n", test_name);
 }
 
-static inline int sz2ord(size_t size)
+static inline int sz2ord(size_t size, size_t pagesize)
 {
-	return __builtin_ctzll(size / getpagesize());
+	return __builtin_ctzll(size / pagesize);
 }
 
 void *sys_mremap(void *old_address, unsigned long old_size,
--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftest-mm-extract-sz2ord-function-into-vm_utilh
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -544,7 +544,7 @@ int main(int argc, char **argv)
 		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
 
 	nr_pages = pmd_pagesize / pagesize;
-	max_order =  sz2ord(pmd_pagesize);
+	max_order =  sz2ord(pmd_pagesize, pagesize);
 	tests = 2 + (max_order - 1) + (2 * max_order) + (max_order - 1) * 4 + 2;
 	ksft_set_plan(tests);
 
_


