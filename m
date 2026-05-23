Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66A0BCD4F54
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 03:50:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5436F6B0092; Fri, 22 May 2026 23:50:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51A346B0095; Fri, 22 May 2026 23:50:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4572B6B0096; Fri, 22 May 2026 23:50:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2FDC66B0092
	for <linux-mm@kvack.org>; Fri, 22 May 2026 23:50:46 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ACABAA0444
	for <linux-mm@kvack.org>; Sat, 23 May 2026 03:50:45 +0000 (UTC)
X-FDA: 84797308050.25.5CC107E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id C677A14000E
	for <linux-mm@kvack.org>; Sat, 23 May 2026 03:50:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TSkBVRf1;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779508244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ANd8XjbmBFe5KABDeJm0oSjcuQYcsksOmyFJnc/iJmQ=;
	b=OnmgTf43PhpJAHf7TYUPJV0mvOm+m19Vzf8Ylcrrcmwp6txQq2z1xKiaM8wza5XJNxOjpY
	4CXO1hlLdXftxB6YLmY0YKHBtFw5+WnowoMi4rND7zJmSx31l2u3NEBT3pLmcU15B34BHZ
	JwS4Pj9weF4NaRzFZ8QaKJ40fk70i6s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TSkBVRf1;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779508244; a=rsa-sha256;
	cv=none;
	b=4oZd2o+ZOlgAyivgJ67fshiFRvmrm/Jb5i5dqUFGj67Ru+ggPQm+xxxTM6cpdog2VJcZui
	Fmui70BYdcVPBZ7zbFTwVK3L3XZMlFsprIEDa5vHoZ7V3x5pozyE1ZQ6Rcwv34DXhR910y
	yxvjirLWzgHZA1HGbZ8pUFKNlVQVxa0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D2705438F0;
	Sat, 23 May 2026 03:50:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420F11F000E9;
	Sat, 23 May 2026 03:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779508242;
	bh=ANd8XjbmBFe5KABDeJm0oSjcuQYcsksOmyFJnc/iJmQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=TSkBVRf1BLibispKAaE/lAtO9RdSMBWxhBG/oljs6ScFAE3P6NI9vu0FKf/o8Fh51
	 8tNtyejcQ1vsExes20KUxbEXVTBncLKLonZHJsx9uo+XXJHXPVKlZlTBt5KfUjZflJ
	 5paKNWdNx8zIZUN0hGe6rQQsS7onBORm12gVxlg0=
Date: Fri, 22 May 2026 20:50:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wupeng Ma <mawupeng1@huawei.com>
Cc: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>,
 <ljs@kernel.org>, <Liam.Howlett@oracle.com>, <vbabka@kernel.org>,
 <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
 <linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend] mm/memory-failure: fix hugetlb_lock AA deadlock
 in get_huge_page_for_hwpoison
Message-Id: <20260522205041.a85237b104d74533c13745e4@linux-foundation.org>
In-Reply-To: <20260522010305.4099834-1-mawupeng1@huawei.com>
References: <20260522010305.4099834-1-mawupeng1@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C677A14000E
X-Rspam-User: 
X-Stat-Signature: sahfndafb4j6smgpga11dbc6jzyouqwj
X-HE-Tag: 1779508243-30368
X-HE-Meta: U2FsdGVkX1/WlsPEj9psDSjUWW+eBGFS9CCaUQrJnpa2BLDvkTd8j2uHyACwQVMi4nyDwc2KM23Sf8D9sYBr0MGLMPQGc72JiAprRmB853aMKTArWiVFvgAZ/r9V01G6hZYz/As14wwE44CweUajH7akvTJD9GFSCOMpZdtX5EG3T5IXQbCDIWqkb9yZqHV/akOQhXeFi/Lb525XEYiYKhiGGqzS6SxYFvctyQvPYbZ45Eng3ByaxR8o8CG6135pQAn9rlGO5V4de0eGjkazGH5GRQYaeTXA5LUPfXdGEL7LD8JqowvdlSBgkWcPeCVMyTXlPrxbm1EtE305ZezkwZTpht7JyYn9rCQt41d0PfnNIeaQ0IChs8mOBYbWT3idiI0BplTDQq1S3auYmsVu2y2M15cQX2z2JuRhP0RpHHs5KudWXDlc4ox0V5It15tXvIc326jvMea93x6v2AkeQTmMLz3dlIqZhqu/5NKCbOHh2n8wKDOP2G4KLF2VLGlTFITrNISCHfs0HOv5v/c/iVWSYgS6GunIseDX44H2JCln7JmYCenY3Dv81nYVRqCiKGxTRiA6g7rjsXog+1lCNQBWZBIPk0u8lvvtiSSVs0S0Jm+CkBhGpkQ3Bwy2FHJ0KXiLva1DCHeykfz2NwwnPngO+l4lqorAbQmQQSpDrY6YRkDk66BrCYxXjnEIs8/i4gfcozcUpGHNa/vkWNOpi8huLghHW9SiaXn5pMVUdrKZ5VREU2UBLPg8VNLTcL0su5bgBgZvbntI4O6bIzQ4ZECAtcY4TX30YpzI648dw2Ze5Sz1K6Gf8Ipm+thPPRQVpu+j71Vcb2eD1AqLbeR669H9nQNiEgVkHIzNf8hEUmZII9MEqyx9CeSFEA0hMlizARUICd3D4hmJkSUgVNH9lQkIg/XQxMcsJV4FAYrHivxcgz0O2VN9+6tyjj0025pOY/MDohwa1B21GtEq8mA
 cU7ArJ54
 M26D+p+yppXcCeuRcYPRBG3aMTLUkg+CigqqxsNsjOcmcmcQKz+n/i6mAm9DxwRhdi560s5zUYSqzNNttiv/XoLqvn2kZLQ0YaMnsMefe8sV4AiG8oTk1MgBgyEs3p+7iAckfuUSEJ7vpOFbwEZUfCvpyomjXnlfbs5f1qFb8QlCna8oumlWirM2GB+8+/26bIN8YuNqCVNurH1TknunBwk7DK+RE+T5eBRoXabx8KRl2apDyxQZZ1Uj/1NDn/7moFQtmbhc82Adxw0c7eOhzMA1x0yo3PUt/0+3j6mcDSwsSJia8cRw/mQuDn2idjq0l5+Q/ITcsQJI+N8oNWOA1pGTMswU1lFdV3drKjw3zs0rxkyesHQuYIZYlVoIt5knq9SIccgRX8BWI5n1PBuHUTHYHYCu0hHvim4pjoa1a9c1z2uLKLl2ddKok9eLuK6qryu06qUr3V7I42tCFWA3SNrMYsJDo/60HcHwE9kyZxvEWNiz8PjSyhD7OAnaljgzlgyMaiZyIWGny05Sz43jUYGLKaFM2djXmwDBhLRBI3IU7mntRIxY62X/zxZKphmqqpBCUsdWJu1WDlQEPkW/s+tgCS39ayHAzzubdH50poQShXSLjC2BYGaMcS6T0L39Qdv5bG7NA+2+XoUyQtav/7XQkKCuT9rRGLsrU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 May 2026 09:03:05 +0800 Wupeng Ma <mawupeng1@huawei.com> wrote:

> Two concurrent madvise(MADV_HWPOISON) calls on the same hugetlb page
> can trigger a recursive spinlock self-deadlock (AA deadlock) on
> hugetlb_lock when racing with a concurrent unmap:

Well we don't want that.

> Fixes: 405ce051236c ("mm/hwpoison: fix race between hugetlb free/demotion and memory_failure_hugetlb()")

So I'll add cc:stable here.

AI review didn't like the unlocked page_folio():

	https://sashiko.dev/#/patchset/20260522010305.4099834-1-mawupeng1@huawei.com

So I'll add a followup patch which addresses that (and which addresses
Miaohe's naming nit).

Please let's check this - perhaps the locking alteration isn't needed.


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison-fix
Date: Fri May 22 08:44:25 PM PDT 2026

- address possible race identified by Sashiko

- s/out/out_unlock/, per Miaohe

Link: https://sashiko.dev/#/patchset/20260522010305.4099834-1-mawupeng1@huawei.com
Link: https://lore.kernel.org/f39f405e-4b4b-8f79-70fe-a2b5b62114eb@huawei.com
Cc: David Hildenbrand <david@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wupeng Ma <mawupeng1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison-fix
+++ a/mm/memory-failure.c
@@ -1970,14 +1970,15 @@ static int get_huge_page_for_hwpoison(un
 				 bool *migratable_cleared)
 {
 	struct page *page = pfn_to_page(pfn);
-	struct folio *folio = page_folio(page);
+	struct folio *folio;
 	bool count_increased = false;
 	int ret, rc;
 
 	spin_lock_irq(&hugetlb_lock);
+	folio = page_folio(page);
 	if (!folio_test_hugetlb(folio)) {
 		ret = MF_HUGETLB_NON_HUGEPAGE;
-		goto out;
+		goto out_unlock;
 	} else if (flags & MF_COUNT_INCREASED) {
 		ret = MF_HUGETLB_IN_USED;
 		count_increased = true;
@@ -1993,13 +1994,13 @@ static int get_huge_page_for_hwpoison(un
 	} else {
 		ret = MF_HUGETLB_RETRY;
 		if (!(flags & MF_NO_RETRY))
-			goto out;
+			goto out_unlock;
 	}
 
 	rc = hugetlb_update_hwpoison(folio, page);
 	if (rc >= MF_HUGETLB_FOLIO_PRE_POISONED) {
 		ret = rc;
-		goto out;
+		goto out_unlock;
 	}
 
 	/*
@@ -2013,7 +2014,7 @@ static int get_huge_page_for_hwpoison(un
 
 	spin_unlock_irq(&hugetlb_lock);
 	return ret;
-out:
+out_unlock:
 	spin_unlock_irq(&hugetlb_lock);
 	if (count_increased)
 		folio_put(folio);
_


