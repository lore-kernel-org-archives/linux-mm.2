Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD9B8D6ACFB
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 13:11:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 413696B0088; Thu, 18 Dec 2025 08:11:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BD106B0089; Thu, 18 Dec 2025 08:11:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C0466B008A; Thu, 18 Dec 2025 08:11:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 17DB36B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:11:47 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C96D284F64
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:11:46 +0000 (UTC)
X-FDA: 84232629012.23.A09BFAB
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7D1DC8000F
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:11:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=6cLqtNJT;
	spf=pass (imf30.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766063505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=528aVgD62tAeoWmxi3NG7bQOpC5mgLeV7VV2/UxXL2g=;
	b=dJj49Ln0Gpj/BtZP/0SNv3MR5QFVvXhYKd67RKE+clAHTHdX20ocFweVn3y7oJI0S/AIvu
	mX40X+5NZJHHZDq66KZ3VNKv8mwHLYOkvc1j0G3MmJjUbX7HOJw9HfaWemRNEzFrbQsygY
	G78urMzlh2fI293r96dltcH1U42su54=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=6cLqtNJT;
	spf=pass (imf30.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766063505; a=rsa-sha256;
	cv=none;
	b=6rOcxhQYDp50oJCeTlqLqfcbu/yfJIB8zO7XegL0q3BgPGm1SRh7kALF9WlUvGkmNns120
	IOuwrgVCjgka9nLt8lSLhgf3+1OjpyaNmiueQfZ/zYDCU6Xhrm5Bd7vqK7ok9aubHyimme
	g1ltX2JjUu+isYuyfnnwtsHJ3eP2H20=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=528aVgD62tAeoWmxi3NG7bQOpC5mgLeV7VV2/UxXL2g=;
	b=6cLqtNJTAxDQEWqYHVSkPYAnDoabtjiA+ROeAJHgzQeO82Qm2MVvtEl2O6eHm9SFop0rVhB2M
	Q7JubqJXZmx1wQeI0N6djWTk1/nI2/r9hkwixEh1GtMzHbJitAsw/Ycow/L1WqJ1BN/hr46MdxZ
	1Juz3R3b45UOWq0FRLCRHuE=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dX9wN3M52zpSvn;
	Thu, 18 Dec 2025 21:08:52 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 9B96B1804FF;
	Thu, 18 Dec 2025 21:11:38 +0800 (CST)
Received: from [10.174.179.179] (10.174.179.179) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Dec 2025 21:11:37 +0800
Content-Type: multipart/alternative;
	boundary="------------2B4uasab9eNkoRBDVxBP06Hv"
Message-ID: <a629d3bb-c7e2-41e0-87e0-7a7a6367c1b6@huawei.com>
Date: Thu, 18 Dec 2025 21:11:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] memory leak of xa_node in collapse_file() when
 rollbacks
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>,
	<ziy@nvidia.com>, <lorenzo.stoakes@oracle.com>,
	<baolin.wang@linux.alibaba.com>, <Liam.Howlett@oracle.com>,
	<npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
	<baohua@kernel.org>, <lance.yang@linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>
CC: Kefeng Wang <wangkefeng.wang@huawei.com>, Shardul Bankar
	<shardul.b@mpiricsoftware.com>
References: <86834731-02ba-43ea-9def-8b8ca156ec4a@huawei.com>
 <32e4658f-d23b-4bae-9053-acdd5277bb17@kernel.org>
 <4b129453-97d1-4da4-9472-21c1634032d0@huawei.com>
 <05bbe26e-e71a-4a49-95d2-47373b828145@kernel.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <05bbe26e-e71a-4a49-95d2-47373b828145@kernel.org>
X-Originating-IP: [10.174.179.179]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam02
X-Stat-Signature: 6zuojdm4qeb4eqthjw7t4n4nqx1d53u7
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D1DC8000F
X-HE-Tag: 1766063503-204792
X-HE-Meta: U2FsdGVkX18QMz9gch3OsTMfz5JiY1UHBwbVwS+wtGcEr9A94aTA1VOfQetxWI0Pv/YSIfPrY0VBVwKnXGM6pT1H9XlMfXH8Q0w21YolIxYlvYF4ze9uP5IE6DC4Xzas636jv2hdjD6mTbkMLtYCyaC69c0llAIwsBAPsytWQiIh4lQTJITT/a7FUT6nUqaG6GZRD5n6mbJDgYzpYrHNrGaJrufSm0LhKkD7/vfpnXXCZp/hLNfVFUodwHjQk3jzomz/KpIfqyei0YlJ95lDrS5aOuv6MPbQq8KRn190NRsycKqR7hRyrqDj2rdb+2zjIN4WTiLOmypMHhHOBETvXLOlEYnVE17KibMkk6Eh6YdMzgBJ4deYbgei+5+nnvl68YgrPz+tLN/7wUGtFP2Qyv0+rYaCJHsrQpafuSRg/BKif/jk1KBl2UkSKg+rU8QPgEpAt7Hz7CO/Y70diS4lpSwai8LtfVVBBH723e8PxfUzuh3OJ3TFtuqHUK5AtcrNJ/QJNC/lQEF+IKb4kZqMGYmgxAJd6PAqbECPpaSDVi0+eCxqv59KIkHSj24yKjFXNDSPy9834KVLtUqJr42gOpwkDRtzt94+kZl70Wkxn2q83OizWE0TgBUNJHRgBHL95fgwYVDButXr/wy/LfwrCTe9O64WV+Jzbc9F/8pCvwLVR3+ajYcDEXl7UE1u7T3X0XVVR+KGYCyj902Ov/imfI6NE/OtKYTizmG/sSmfhH/9MAKP/TLUGSF4M6lE+S1J+0+iqE0Cs61qOoQQQwL28TXf1JIeiEPwqd426cSAqH/+ejmjNafXFAc7xw0pdh3bRfga3mzas3Sz/o/YGNVxZZ8HNDlGjZG6oIXraB0tSjuFLeQp0J1nKQudLK1K3KkYqQmfyboEH35urmiDV+HXHELra3gjwbKyLtOppFLO2JoQwQmSJo8crlLWBGcwVA0OK5U+VuwpCccxzNdnwAB
 x9oM9+st
 9uqMiIMgRJk/b7zF59oPjhqaoikhQvu7705HeFh8umZwUQVvYSgACbSexQvevUTgStGrzXIRVI/xSr+QpCZkdIsHo5mlpD7Kqx9G1R8TwxUgEuwl96HL9gw6UgARgYaWl2xuPfVLNRYpe+q7Qbs3VqzJSw3gtrXpBAJlO9IYH2/UB/jsfdeyeL/cp6o8Su4PpoNma+jIKpCVFlasbVGYquQmYRiFs2FYokp8wdyjeW+HR3idTMZLHV6lqfVEzXx7MBgqBLM1eDukCM8uofURsY7tbyI1B6Ds/3UK8ijeLoAhO7eMT/PsL9pHqVXtHEa3iDRfTHVM6agFPzHaHql8i9d3CPa14MCtyFpeA7ZINuTHvjnPe5lz/aB77H+QyK22gw1TwFeMMEyVM3Qh3tPDjTvWB/UwSb0pY/Mlou9kHX9DAyUzoJXbNRjva+5942M4c01S/6tffc3Pn5Mx05vGupXVTTbGqOvYtMJeo3SYmMHz2mNGcrn5J1+N7S3H7U5CZBXdNSrUwPfO3l2DtGacYRJHEH/ALnZkbng/HRP1yXGi8Oi7uSATP0jk+2k43gAL616W4OX7FJchHXLXmmxav93JyzfHebYyOwx/V
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------2B4uasab9eNkoRBDVxBP06Hv
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/12/18 20:49, David Hildenbrand (Red Hat) 写道:
> On 12/18/25 13:18, Jinjiang Tu wrote:
>>
>> 在 2025/12/18 19:51, David Hildenbrand (Red Hat) 写道:
>>> On 12/18/25 12:45, Jinjiang Tu wrote:
>>>> I encountered a memory leak issue caused by xas_create_range().
>>>>
>>>> collapse_file() calls xas_create_range() to pre-create all slots 
>>>> needed.
>>>> If collapse_file() finally fails, these pre-created slots are empty 
>>>> nodes
>>>> and aren't destroyed.
>>>>
>>>> I can reproduce it with following steps.
>>>> 1) create file /tmp/test_madvise_collapse and ftruncate to 4MB 
>>>> size, and then mmap the file
>>>> 2) memset for the first 2MB
>>>> 3) madvise(MADV_COLLAPSE) for the second 2MB
>>>> 4) unlink the file
>>>>
>>>> in 3), collapse_file() calls xas_create_range() to expand xarray 
>>>> depth, and fails to collapse
>>>> due to the whole 2M region is empty, the code is as following:
>>>>
>>>> collapse_file()
>>>>     for (index = start; index < end;) {
>>>>         xas_set(&xas, index);
>>>>         folio = xas_load(&xas);
>>>>
>>>>         VM_BUG_ON(index != xas.xa_index);
>>>>         if (is_shmem) {
>>>>             if (!folio) {
>>>>                 /*
>>>>                  * Stop if extent has been truncated or
>>>>                  * hole-punched, and is now completely
>>>>                  * empty.
>>>>                  */
>>>>                 if (index == start) {
>>>>                     if (!xas_next_entry(&xas, end - 1)) {
>>>>                         result = SCAN_TRUNCATED;
>>>>                         goto xa_locked;
>>>>                     }
>>>>                 }
>>>>                 ...
>>>>             }
>>>>
>>>>
>>>> collapse_file() rollback path doesn't destroy the pre-created empty 
>>>> nodes.
>>>>
>>>> When the file is deleted, 
>>>> shmem_evict_inode()->shmem_truncate_range() traverses
>>>> all entries and calls xas_store(xas, NULL) to delete, if the leaf 
>>>> xa_node that
>>>> stores deleted entry becomes emtry, xas_store() will automatically 
>>>> delete the empty
>>>> node and delete it's  parent is empty too, until parent node isn't 
>>>> empty. shmem_evict_inode()
>>>> won't traverse the empty nodes created by xas_create_range() due to 
>>>> these nodes doesn't store
>>>> any entries. As a result, these empty nodes are leaked.
>>>>
>>>> At first, I tried to destory the empty nodes when collapse_file() 
>>>> goes to rollback path. However,
>>>> collapse_file() only holds xarray lock and may release the lock, so 
>>>> we couldn't prevent concurrent
>>>> call of collapse_file(), so the deleted empty nodes may be needed 
>>>> by other collapse_file() calls.
>>>>
>>>> IIUC, xas_create_range() is used to guarantee the xas_store(&xas, 
>>>> new_folio); succeeds. Could we
>>>> remove xas_create_range() call and just rollback when we fail to 
>>>> xas_store?
>>>
>>> Hi,
>>>
>>> thanks for the report.
>>>
>>> Is that what [1] is fixing?
>>>
>>> [1] https://lore.kernel.org/linux-mm/20251204142625.1763372-1- 
>>> shardul.b@mpiricsoftware.com/
>>>
>> No, this patch fixes memory leak caused by xas->xa_alloc allocated by 
>> xas_nomem() and the xa_node
>> isn't installed into xarray.
>>
>> In my case, the leaked xa_nodes have been installed into xarray by 
>> xas_create_range().
>
> Thanks for checking. I thought that was also discussed as part of the 
> other fix.
>
> See [2] where we have
>
> "Note: This fixes the leak of pre-allocated nodes. A separate fix will
> be needed to clean up empty nodes that were inserted into the tree by
> xas_create_range() but never populated."
>
> Is that the issue you are describing? (sounds like it, but I only 
> skimmed over the details).
>
> CCing Shardul.

Yes, the same issue. As I descirbed in the first email:
"
At first, I tried to destory the empty nodes when collapse_file() goes to rollback path. However,
collapse_file() only holds xarray lock and may release the lock, so we couldn't prevent concurrent
call of collapse_file(), so the deleted empty nodes may be needed by other collapse_file() calls.
"
We couldn't bindly cleanup empty nodes in the rollback path.

I'm trying to move the xas_create_range() before xas_store() and always under xarray lock to make
rollback easier, the diff likes (applied on 6.6, haven't tested yet)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index c3f54d2eaf36..5ef393011a61 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -1548,6 +1548,7 @@ void xas_destroy(struct xa_state *);
  void xas_pause(struct xa_state *);
  
  void xas_create_range(struct xa_state *);
+void xas_destroy_range(struct xa_state *xas, unsigned long start, unsigned long end);
  
  #ifdef CONFIG_XARRAY_MULTI
  int xa_get_order(struct xarray *, unsigned long index);
diff --git a/lib/xarray.c b/lib/xarray.c
index 32d4bac8c94c..724a7f35a26f 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -745,6 +745,25 @@ void xas_create_range(struct xa_state *xas)
  }
  EXPORT_SYMBOL_GPL(xas_create_range);
  
+void xas_destroy_range(struct xa_state *xas, unsigned long start, unsigned long end)
+{
+	unsigned long index;
+	void *entry;
+
+	for (index = start; index < end; ++index) {
+		xas_set(xas, index);
+		entry = xas_load(xas);
+		if (entry)
+			continue;
+
+		if (!xas->xa_node || xas_invalid(xas))
+			continue;
+
+		if (!xas->xa_node->count)
+			xas_delete_node(xas);
+	}
+}
+
  static void update_node(struct xa_state *xas, struct xa_node *node,
  		int count, int values)
  {
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index e8cb826c1994..36f0600ef7b1 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1832,7 +1832,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
  	struct folio *folio, *tmp, *new_folio;
  	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
  	LIST_HEAD(pagelist);
-	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
+	XA_STATE(xas, &mapping->i_pages, 0);
  	int nr_none = 0, result = SCAN_SUCCEED;
  	bool is_shmem = shmem_file(file);
  
@@ -1851,22 +1851,6 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
  	new_folio->index = start;
  	new_folio->mapping = mapping;
  
-	/*
-	 * Ensure we have slots for all the pages in the range.  This is
-	 * almost certainly a no-op because most of the pages must be present
-	 */
-	do {
-		xas_lock_irq(&xas);
-		xas_create_range(&xas);
-		if (!xas_error(&xas))
-			break;
-		xas_unlock_irq(&xas);
-		if (!xas_nomem(&xas, GFP_KERNEL)) {
-			result = SCAN_FAIL;
-			goto rollback;
-		}
-	} while (1);
-
  	for (index = start; index < end;) {
  		xas_set(&xas, index);
  		folio = xas_load(&xas);
@@ -2163,6 +2147,23 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
  		xas_lock_irq(&xas);
  	}
  
+	xas_set_order(&xas, start, HPAGE_PMD_ORDER);
+	xas_create_range(&xas);
+	if (xas_error(&xas)) {
+		if (nr_none) {
+			xas_set(&xas, start);
+			for (index = start; index < end; index++) {
+				if (xas_next(&xas) == XA_RETRY_ENTRY)
+					xas_store(&xas, NULL);
+			}
+		}
+		xas_destroy_range(&xas, start, end);
+		xas_unlock_irq(&xas);
+		result = SCAN_FAIL;
+
+		goto rollback;
+	}
+
  	if (is_shmem)
  		__lruvec_stat_mod_folio(new_folio, NR_SHMEM_THPS, HPAGE_PMD_NR);
  	else
-- 
2.43.0

>
>
> [2] 
> https://lore.kernel.org/linux-mm/20251123132727.3262731-1-shardul.b@mpiricsoftware.com/
>
--------------2B4uasab9eNkoRBDVxBP06Hv
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">在 2025/12/18 20:49, David Hildenbrand
      (Red Hat) 写道:<br>
    </div>
    <blockquote type="cite"
      cite="mid:05bbe26e-e71a-4a49-95d2-47373b828145@kernel.org">On
      12/18/25 13:18, Jinjiang Tu wrote:
      <br>
      <blockquote type="cite">
        <br>
        在 2025/12/18 19:51, David Hildenbrand (Red Hat) 写道:
        <br>
        <blockquote type="cite">On 12/18/25 12:45, Jinjiang Tu wrote:
          <br>
          <blockquote type="cite">I encountered a memory leak issue
            caused by xas_create_range().
            <br>
            <br>
            collapse_file() calls xas_create_range() to pre-create all
            slots needed.
            <br>
            If collapse_file() finally fails, these pre-created slots
            are empty nodes
            <br>
            and aren't destroyed.
            <br>
            <br>
            I can reproduce it with following steps.
            <br>
            1) create file /tmp/test_madvise_collapse and ftruncate to
            4MB size, and then mmap the file
            <br>
            2) memset for the first 2MB
            <br>
            3) madvise(MADV_COLLAPSE) for the second 2MB
            <br>
            4) unlink the file
            <br>
            <br>
            in 3), collapse_file() calls xas_create_range() to expand
            xarray depth, and fails to collapse
            <br>
            due to the whole 2M region is empty, the code is as
            following:
            <br>
            <br>
            collapse_file()
            <br>
                for (index = start; index &lt; end;) {
            <br>
                    xas_set(&amp;xas, index);
            <br>
                    folio = xas_load(&amp;xas);
            <br>
            <br>
                    VM_BUG_ON(index != xas.xa_index);
            <br>
                    if (is_shmem) {
            <br>
                        if (!folio) {
            <br>
                            /*
            <br>
                             * Stop if extent has been truncated or
            <br>
                             * hole-punched, and is now completely
            <br>
                             * empty.
            <br>
                             */
            <br>
                            if (index == start) {
            <br>
                                if (!xas_next_entry(&amp;xas, end - 1))
            {
            <br>
                                    result = SCAN_TRUNCATED;
            <br>
                                    goto xa_locked;
            <br>
                                }
            <br>
                            }
            <br>
                            ...
            <br>
                        }
            <br>
            <br>
            <br>
            collapse_file() rollback path doesn't destroy the
            pre-created empty nodes.
            <br>
            <br>
            When the file is deleted,
            shmem_evict_inode()-&gt;shmem_truncate_range() traverses
            <br>
            all entries and calls xas_store(xas, NULL) to delete, if the
            leaf xa_node that
            <br>
            stores deleted entry becomes emtry, xas_store() will
            automatically delete the empty
            <br>
            node and delete it's  parent is empty too, until parent node
            isn't empty. shmem_evict_inode()
            <br>
            won't traverse the empty nodes created by xas_create_range()
            due to these nodes doesn't store
            <br>
            any entries. As a result, these empty nodes are leaked.
            <br>
            <br>
            At first, I tried to destory the empty nodes when
            collapse_file() goes to rollback path. However,
            <br>
            collapse_file() only holds xarray lock and may release the
            lock, so we couldn't prevent concurrent
            <br>
            call of collapse_file(), so the deleted empty nodes may be
            needed by other collapse_file() calls.
            <br>
            <br>
            IIUC, xas_create_range() is used to guarantee the
            xas_store(&amp;xas, new_folio); succeeds. Could we
            <br>
            remove xas_create_range() call and just rollback when we
            fail to xas_store?
            <br>
          </blockquote>
          <br>
          Hi,
          <br>
          <br>
          thanks for the report.
          <br>
          <br>
          Is that what [1] is fixing?
          <br>
          <br>
          [1] <a class="moz-txt-link-freetext" href="https://lore.kernel.org/linux-mm/20251204142625.1763372-1">https://lore.kernel.org/linux-mm/20251204142625.1763372-1</a>-
          <a class="moz-txt-link-abbreviated" href="mailto:shardul.b@mpiricsoftware.com/">shardul.b@mpiricsoftware.com/</a>
          <br>
          <br>
        </blockquote>
        No, this patch fixes memory leak caused by xas-&gt;xa_alloc
        allocated by xas_nomem() and the xa_node
        <br>
        isn't installed into xarray.
        <br>
        <br>
        In my case, the leaked xa_nodes have been installed into xarray
        by xas_create_range().
        <br>
      </blockquote>
      <br>
      Thanks for checking. I thought that was also discussed as part of
      the other fix.
      <br>
      <br>
      See [2] where we have
      <br>
      <br>
      "Note: This fixes the leak of pre-allocated nodes. A separate fix
      will
      <br>
      be needed to clean up empty nodes that were inserted into the tree
      by
      <br>
      xas_create_range() but never populated."
      <br>
      <br>
      Is that the issue you are describing? (sounds like it, but I only
      skimmed over the details).
      <br>
      <br>
      CCing Shardul. <br>
    </blockquote>
    <pre>Yes, the same issue. As I descirbed in the first email:
"
At first, I tried to destory the empty nodes when collapse_file() goes to rollback path. However,
collapse_file() only holds xarray lock and may release the lock, so we couldn't prevent concurrent
call of collapse_file(), so the deleted empty nodes may be needed by other collapse_file() calls. 
"
We couldn't bindly cleanup empty nodes in the rollback path.

I'm trying to move the xas_create_range() before xas_store() and always under xarray lock to make
rollback easier, the diff likes (applied on 6.6, haven't tested yet)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index c3f54d2eaf36..5ef393011a61 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -1548,6 +1548,7 @@ void xas_destroy(struct xa_state *);
 void xas_pause(struct xa_state *);
 
 void xas_create_range(struct xa_state *);
+void xas_destroy_range(struct xa_state *xas, unsigned long start, unsigned long end);
 
 #ifdef CONFIG_XARRAY_MULTI
 int xa_get_order(struct xarray *, unsigned long index);
diff --git a/lib/xarray.c b/lib/xarray.c
index 32d4bac8c94c..724a7f35a26f 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -745,6 +745,25 @@ void xas_create_range(struct xa_state *xas)
 }
 EXPORT_SYMBOL_GPL(xas_create_range);
 
+void xas_destroy_range(struct xa_state *xas, unsigned long start, unsigned long end)
+{
+	unsigned long index;
+	void *entry;
+ 
+	for (index = start; index &lt; end; ++index) {
+		xas_set(xas, index);
+		entry = xas_load(xas);
+		if (entry)
+			continue;
+ 
+		if (!xas-&gt;xa_node || xas_invalid(xas))
+			continue;
+ 
+		if (!xas-&gt;xa_node-&gt;count)
+			xas_delete_node(xas);
+	}
+}
+
 static void update_node(struct xa_state *xas, struct xa_node *node,
 		int count, int values)
 {
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index e8cb826c1994..36f0600ef7b1 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1832,7 +1832,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	struct folio *folio, *tmp, *new_folio;
 	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
 	LIST_HEAD(pagelist);
-	XA_STATE_ORDER(xas, &amp;mapping-&gt;i_pages, start, HPAGE_PMD_ORDER);
+	XA_STATE(xas, &amp;mapping-&gt;i_pages, 0);
 	int nr_none = 0, result = SCAN_SUCCEED;
 	bool is_shmem = shmem_file(file);
 
@@ -1851,22 +1851,6 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	new_folio-&gt;index = start;
 	new_folio-&gt;mapping = mapping;
 
-	/*
-	 * Ensure we have slots for all the pages in the range.  This is
-	 * almost certainly a no-op because most of the pages must be present
-	 */
-	do {
-		xas_lock_irq(&amp;xas);
-		xas_create_range(&amp;xas);
-		if (!xas_error(&amp;xas))
-			break;
-		xas_unlock_irq(&amp;xas);
-		if (!xas_nomem(&amp;xas, GFP_KERNEL)) {
-			result = SCAN_FAIL;
-			goto rollback;
-		}
-	} while (1);
-
 	for (index = start; index &lt; end;) {
 		xas_set(&amp;xas, index);
 		folio = xas_load(&amp;xas);
@@ -2163,6 +2147,23 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 		xas_lock_irq(&amp;xas);
 	}
 
+	xas_set_order(&amp;xas, start, HPAGE_PMD_ORDER);
+	xas_create_range(&amp;xas);
+	if (xas_error(&amp;xas)) {
+		if (nr_none) {
+			xas_set(&amp;xas, start);
+			for (index = start; index &lt; end; index++) {
+				if (xas_next(&amp;xas) == XA_RETRY_ENTRY)
+					xas_store(&amp;xas, NULL);
+			}
+		}
+		xas_destroy_range(&amp;xas, start, end);
+		xas_unlock_irq(&amp;xas);
+		result = SCAN_FAIL;
+
+		goto rollback;
+	}
+
 	if (is_shmem)
 		__lruvec_stat_mod_folio(new_folio, NR_SHMEM_THPS, HPAGE_PMD_NR);
 	else
-- 
2.43.0</pre>
    <blockquote type="cite"
      cite="mid:05bbe26e-e71a-4a49-95d2-47373b828145@kernel.org"><br>
      <br>
      [2]
<a class="moz-txt-link-freetext" href="https://lore.kernel.org/linux-mm/20251123132727.3262731-1-shardul.b@mpiricsoftware.com/">https://lore.kernel.org/linux-mm/20251123132727.3262731-1-shardul.b@mpiricsoftware.com/</a><br>
      <br>
    </blockquote>
  </body>
</html>

--------------2B4uasab9eNkoRBDVxBP06Hv--

