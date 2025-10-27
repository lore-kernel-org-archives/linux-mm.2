Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93297CCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 11:38:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EADF680037; Mon, 27 Oct 2025 07:38:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E368B8000A; Mon, 27 Oct 2025 07:38:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFEB080037; Mon, 27 Oct 2025 07:38:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B8A6D8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 07:38:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 631CD1A0549
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 11:38:01 +0000 (UTC)
X-FDA: 84043695162.07.FCAF58C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9BF6BC0002
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 11:37:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="IOWTV/CE";
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf22.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761565079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=1XXd1E6adw1mAT501j+9jaMjADtEFwARDIcCb4bfwMU=;
	b=tjM2r2TTzhtUDfF/cPzEDMkJY/mdsVEaukGDZZCCRETNrErKqk4vvvfv/4kbkU/Rf8rIum
	8gk1Wyj+g13HN2dk5C/Ujjvi/oxm8sevN8Rg/pTUwAIyEFyb+ScEXoE3FQYgmyu2YFwaDy
	qb8B/j7c2zFoHUB9Wy5KWv4ETUNeAkI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761565079; a=rsa-sha256;
	cv=none;
	b=tl84OvDoKj6GORU0JCB9jJNfDeZTrhdQf6zP0+6HlLnlkCy41DbkAU2kIghMYhXG1u0nxx
	P4VQMC5Z+yJibKKAW6+xOHQPqv4hXTfKOnEhlC6LyjgyOVLHYYHe89hg1mnA4UCivii02E
	0EvWg1eayVQbBChEaer1uDVm2pWVoPk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="IOWTV/CE";
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf22.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C9312438E8;
	Mon, 27 Oct 2025 11:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50003C4CEF1;
	Mon, 27 Oct 2025 11:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761565078;
	bh=bMN3fuj8HMpUw27Rgszzdr2o/0myHcOBcqSRrjK/4sE=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=IOWTV/CEUSA+4ZquJXg5F8AHrkt4PZvT6DVdptN1qru4hW697ANYZOlJATjI+KThj
	 9T6c+THhAdudRld28q3Y0HUihhBP47mOvxO+Qjsq5IKLpPLzxZ7P5rFmN8fJb1JNvY
	 0nBAOwIbwPCSHZmezwXKaQ1gj1SLCABGOdL+CAS4=
Subject: Patch "Revert "selftests: mm: fix map_hugetlb failure on 64K page size systems"" has been added to the 6.1-stable tree
To: akpm@linux-foundation.org,david@redhat.com,greg@kroah.com,gregkh@linuxfoundation.org,lance.yang@linux.dev,leon.hwang@linux.dev,linux-mm@kvack.org,lorenzo.stoakes@oracle.com,shuah@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 27 Oct 2025 12:36:02 +0100
In-Reply-To: <20251023014732.73721-1-leon.hwang@linux.dev>
Message-ID: <2025102702-narrow-rockiness-34fa@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Rspamd-Server: rspam01
X-Stat-Signature: 4kec6azmzcodqycdgpokbjkduj97osir
X-Rspam-User: 
X-Rspamd-Queue-Id: 9BF6BC0002
X-HE-Tag: 1761565079-263805
X-HE-Meta: U2FsdGVkX1+uV7mCosykuAJXAh365BCmPlMVvcsPJ+BmXfB0hUhVCo272TvLOmF3FUB4wRRCMxm1G2EveNVwpJyVLvhPY8VlEYI2BBfWwOojn3GUSPi5JtuNGsBAsCniNRQZgPUOzZNKCtt8G2tkeN8nUCZ5lC4Y3NBQlh4mWeiawyxc6HOwRBU97zBK81Fy5WyWZOmkNmnDs/xclexYCWWufeyaNWTMjtmBjBIGrINtfeeCvvTUjangtzHmA1/0NjvglwWHFFwrWrQ7ozG1PVZ5H1CzU+vR1FX+AtyQbbEClYlPV3CyBlu4LwuSflwYargFtTqUwa2Rl39WR1SfFEFT6R6qwzOc/RV8cjA+afeoFhROC6iDtM3IKxb9SjSCb4joHEGb34n4FA5tcv2WSX/2zrO0QraeMCiVZ3MEgdnbZ6e4B8+FCuK5eAUxr08oDg4K7bPFrkdoU+rDFllOlzbDse+WXJWaJyNH8kddTNhYobWAJx+E/Brb0W3fRxjtbrFw7T41TeT9O/9oz/CoeDteFNYD8E4lsDbQAJ3uf5SqIJJrYVhBj8PTvz1UDRcff8kGernHNBgFcqysDxy/CB1c2/CIxZ8vxVDvCcWaAllIDa4nfFeN2jUS+zD7HPEOjol+7X+wHUeZuQVA1VhyxnrnvzaJjOTUeABw7SE9KfexkAB90JsYJIRFhGsGdlxeRo6XYVitvVw7KZxGA94XvP4jxpLIllRb4cJMPw9nwYwebbIo+3VJvcgqKbgsH5qktWtyz82F0MrDXemBqiej6WsM52qH3AuEmLa3A31Xyi0NyIy2e18qmA/PaMuiE7pvHIYPnLUvKGbukHDMZNOXGcncWDdWeTf+jiYAytrS5auJZXVrwyHGaD6ZyOGEW2TZw4e/1fMlYqRLVfjMvdibalKwvHEEhcc8mow7rXlAKi17fZLnAccwWovpff1rUK9uTCLNkxGRqdNGgMQ+xLr
 tEd2kYXC
 uy+CsOzkcJcn2HJXbu9M+CJSxB0VtrZZ5mE0d7lryyMDQiKlD/OfM4Je+8kjpMUWyaSwgzeIV9Ea+c94pBWQxnQgBS4WilgUWFHhsmu85TOwWvysoJlWUsOW0xxwYjmzAUiVBSBPyYy3fDPMCV9FpLp6brToNd3pAsmNbdY0ruOUP4mH3VTtCc/WEwYmhSAgmov9vVWyBzy3UzpJUmtRUnWeFbg+189Z7iohS+670rPw7CRv3Kr0bRKc04eA2MevxQ55o85vM0WA5WITXWvoXYsbHwPJNsg2h52G+CJ8/DXyaO4fwV0WXJ9Yd0E+gMugRbVj/DB2lbHiOhmo6Ks/eRnFIUtmeYM46nkGKNmjcDudmOZAPb7Pl5hlEWCzbKWJJpV/RIFKrwB37H3zYhjJBPTYuzFhbzWD5AQ+UPg5hbeda7gtm2qU7oz4oOkJ13/j6VDktSeO787GLe63nE6YSmSFCX4+hHv3j5pElBF5dwABQAz7Y4/2V9LbwJB7hm9gZc9oNxZywY+xw+TmvNqs0Ex8l+vySztAzO6+3gaOKscxQ5GgC47wIRbEWHqcyodtsGl0bARNWtv4PqNa18pGNzsWn3jrJAYy4yil5a/VGwHM/Pd5ut2nSCwx91khKn17T4scL7MAJWtaKK0bikKxDUQqu02eWZ9hBhnhKQ7M9FjkEMdZC8VOZdpfslFuYW7yGlPOk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    Revert "selftests: mm: fix map_hugetlb failure on 64K page size systems"

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     revert-selftests-mm-fix-map_hugetlb-failure-on-64k-page-size-systems.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From leon.hwang@linux.dev  Mon Oct 27 12:22:10 2025
From: Leon Hwang <leon.hwang@linux.dev>
Date: Thu, 23 Oct 2025 09:47:32 +0800
Subject: Revert "selftests: mm: fix map_hugetlb failure on 64K page size systems"
To: stable@vger.kernel.org, greg@kroah.com
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com, lance.yang@linux.dev, shuah@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Leon Hwang <leon.hwang@linux.dev>
Message-ID: <20251023014732.73721-1-leon.hwang@linux.dev>

From: Leon Hwang <leon.hwang@linux.dev>

This reverts commit a584c7734a4dd050451fcdd65c66317e15660e81 which is
commit 91b80cc5b39f00399e8e2d17527cad2c7fa535e2 upstream.

This fixes the following build error:

map_hugetlb.c: In function 'main':
map_hugetlb.c:79:25: warning: implicit declaration of function 'default_huge_page_size' [-Wimplicit-function-declaration]
79 |         hugepage_size = default_huge_page_size();

Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/vm/map_hugetlb.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/tools/testing/selftests/vm/map_hugetlb.c
+++ b/tools/testing/selftests/vm/map_hugetlb.c
@@ -15,7 +15,6 @@
 #include <unistd.h>
 #include <sys/mman.h>
 #include <fcntl.h>
-#include "vm_util.h"
 
 #define LENGTH (256UL*1024*1024)
 #define PROTECTION (PROT_READ | PROT_WRITE)
@@ -71,16 +70,10 @@ int main(int argc, char **argv)
 {
 	void *addr;
 	int ret;
-	size_t hugepage_size;
 	size_t length = LENGTH;
 	int flags = FLAGS;
 	int shift = 0;
 
-	hugepage_size = default_huge_page_size();
-	/* munmap with fail if the length is not page aligned */
-	if (hugepage_size > length)
-		length = hugepage_size;
-
 	if (argc > 1)
 		length = atol(argv[1]) << 20;
 	if (argc > 2) {


Patches currently in stable-queue which might be from leon.hwang@linux.dev are

queue-6.1/revert-selftests-mm-fix-map_hugetlb-failure-on-64k-page-size-systems.patch

