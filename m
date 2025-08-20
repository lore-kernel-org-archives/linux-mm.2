Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC139CA0EEB
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:11:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88DD28E000F; Tue, 19 Aug 2025 21:11:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83E7C8E0001; Tue, 19 Aug 2025 21:11:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72DBC8E000F; Tue, 19 Aug 2025 21:11:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 60B9D8E0001
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:11:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0348AC02FE
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:11:03 +0000 (UTC)
X-FDA: 83795356848.30.7F3C1C3
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7D8441A0006
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:11:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755652262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KPVFoHuHWSeebJAHFlYHFm46TzLeP5X9yj8sbVp6cng=;
	b=ukwc1XIAyqTlNzXB+AuFpLX/1ff9oR+8rAV8lSTjU2aIkw9XFgyfDWUHilCbD/tVI5TOmJ
	vT8aK8Z5rzhNYLcbpnDPp5BJ3Laehh80h4PR8CjUIdGfml4LJAFa9rvkeU5QzxX5vlXk+G
	AXikTIt9uqpfGqf7ktIACl3AL8KmVLU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755652262; a=rsa-sha256;
	cv=none;
	b=dqAw73qsG+bbujbL1Hg5M+q8BtnxNkqMF4YVKd+jMTLCcykT5a4CyB+IkbMFz4Rxbxh+HD
	vVEcRIndcREeea0zVafXfIxYJPgViqhcfZCP8VKW7v/Yw5xWk5CcwoXBbGWHG27LiW4syc
	nZxx2ovwUCuvouBcNR8+gZLfBkVjVYg=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4c67fG4z71ztTMF;
	Wed, 20 Aug 2025 09:09:58 +0800 (CST)
Received: from kwepemo200002.china.huawei.com (unknown [7.202.195.209])
	by mail.maildlp.com (Postfix) with ESMTPS id AA54E1402C8;
	Wed, 20 Aug 2025 09:10:57 +0800 (CST)
Received: from [10.174.178.49] (10.174.178.49) by
 kwepemo200002.china.huawei.com (7.202.195.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 20 Aug 2025 09:10:57 +0800
Content-Type: multipart/alternative;
	boundary="------------9Y2i0GqbxFa3gv0kgTzB0mzj"
Message-ID: <b7a1100c-2302-4781-97c3-1146ed2b44a7@huawei.com>
Date: Wed, 20 Aug 2025 09:10:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] filemap: optimize order0 folio in filemap_map_pages
To: Matthew Wilcox <willy@infradead.org>
CC: <fengwei.yin@intel.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>
References: <20250819140653.3229136-1-tujinjiang@huawei.com>
 <aKSdsH_yk69EvkMX@casper.infradead.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <aKSdsH_yk69EvkMX@casper.infradead.org>
X-Originating-IP: [10.174.178.49]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemo200002.china.huawei.com (7.202.195.209)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7D8441A0006
X-Stat-Signature: kp6u78twczuhy8m8z517jubz497bzsgu
X-Rspam-User: 
X-HE-Tag: 1755652261-359278
X-HE-Meta: U2FsdGVkX1/aJDY30x4/WLHjpbQoGJoeBUvlkKt3S34dytiNQIWsgPOCJgIfuogalSWsuRoxReVLuOJnhHLlArmaUiD3srJmdD2uPj6PIqo1PJ5i3EmRY/9ChBxYUAqL2e3FXAPZdfoYTYks0Gkw/yAKuyden08XBeJqP/aHGIAkgv85MlBXYcW6GWKyO4MR+cJ2fScWS0NFTXW7pNr2ijIJpjW+WSOaIOgW1EARTXqJPFgVbZadRQRoBnE6kGdrr7jF9yHVrxP8LF6Sl0cps+DP8rLoaO0yA5f55hsxCW5GMXlMFEgDJtpD8o5V8T4RuYCNnM6SgkPE9zqw0JGait19wrG7kFjMcAIT1XnORL9SczjZbNOQzBtrCZk/U7Mt6/w7MXapwxWZmeYibjBZdpd0E4hT5L/rdvoCfY0OZksAj6iWpcq3CU2Vs+SAWHHG6Hm67IlGwrWp4XupSYCsFC+0VnOCNwRovmFyN+XZLvOeZ4+nyru93En4G8eX0X4b2mKxjMhLbaNAM1bZ/MnYmp0URlMPHw8YxzSACYEh5bP/fscsO7J8Fky7h6/XVUY793LRthc+qbM3kPVCyqiLA1ibHer84fSnlGncq28Zb19s9AT55HObwxooCyy7P7gPBLdO9bLSRcL2baCx/3S4ApkxUusDNv+ekoUGV9B7DjTg/ett6qqvUKlFOS6MOfHGlcgA3WLaJXSYA6ID/Sg0e2HL4EFJLe8Pf+BnrDogJQ9zrkqLG4aZ65YHtkrlKNGyJBvnyPEIYA1VhnXruB7hr38CMQt1pFlhUuOctRvVSF9QHt6K+iWwyzdUbJLMGHZJlm91EYnjCJhaNgae550JiaV0SCUPG+VHPrwI8NAVVXvaT6xaSqqO7gB7NOJQI5EGgxflwpEaS0oGVaSvNSl6w8yosAsA4HsAxGClB/KLki6x4msTXP13NcnqvDPIfaa9Al3eDcGtbZz5EvLTba8
 ohqhFbD6
 rcqHIRY3WV3a9ZJ2NPBKT4fyCwdyvOFQHFeug
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------9Y2i0GqbxFa3gv0kgTzB0mzj
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/8/19 23:52, Matthew Wilcox 写道:
> On Tue, Aug 19, 2025 at 10:06:53PM +0800, Jinjiang Tu wrote:
>> There are two meaningless folio refcount update for order0 folio in
>> filemap_map_pages(). First, filemap_map_order0_folio() adds folio refcount
>> after the folio is mapped to pte. And then, filemap_map_pages() drops a
>> refcount grabbed by next_uptodate_folio(). We could remain the refcount
>> unchanged in this case.
>>
>> With this patch, we can get 8% performance gain for lmbench testcase
>> 'lat_pagefault -P 1 file', the size of file is 512M.
> You don't explain why you move the folio_unlock() call

We should call folio_unlock() before folio_put(). In filemap_map_order0_folio(),
if we doesn't set folio into pte, we should unlock and put folio.

>
>> Signed-off-by: Jinjiang Tu<tujinjiang@huawei.com>
>> ---
>>   mm/filemap.c | 15 +++++++++------
>>   1 file changed, 9 insertions(+), 6 deletions(-)
>>
>> diff --git a/mm/filemap.c b/mm/filemap.c
>> index 751838ef05e5..5de52deab138 100644
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -3693,6 +3693,8 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
>>   	}
>>   
>>   	vmf->pte = old_ptep;
>> +	folio_unlock(folio);
>> +	folio_put(folio);
>>   
>>   	return ret;
>>   }
>> @@ -3705,7 +3707,7 @@ static vm_fault_t filemap_map_order0_folio(struct vm_fault *vmf,
>>   	struct page *page = &folio->page;
>>   
>>   	if (PageHWPoison(page))
>> -		return ret;
>> +		goto out;
>>   
>>   	/* See comment of filemap_map_folio_range() */
>>   	if (!folio_test_workingset(folio))
>> @@ -3717,15 +3719,19 @@ static vm_fault_t filemap_map_order0_folio(struct vm_fault *vmf,
>>   	 * the fault-around logic.
>>   	 */
>>   	if (!pte_none(ptep_get(vmf->pte)))
>> -		return ret;
>> +		goto out;
>>   
>>   	if (vmf->address == addr)
>>   		ret = VM_FAULT_NOPAGE;
>>   
>>   	set_pte_range(vmf, folio, page, 1, addr);
>>   	(*rss)++;
>> -	folio_ref_inc(folio);
>> +	folio_unlock(folio);
>> +	return ret;
>>   
>> +out:
>> +	folio_unlock(folio);
>> +	folio_put(folio);
>>   	return ret;
>>   }
>>   
>> @@ -3783,9 +3789,6 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
>>   			ret |= filemap_map_folio_range(vmf, folio,
>>   					xas.xa_index - folio->index, addr,
>>   					nr_pages, &rss, &mmap_miss);
>> -
>> -		folio_unlock(folio);
>> -		folio_put(folio);
>>   	} while ((folio = next_uptodate_folio(&xas, mapping, end_pgoff)) != NULL);
>>   	add_mm_counter(vma->vm_mm, folio_type, rss);
>>   	pte_unmap_unlock(vmf->pte, vmf->ptl);
>> -- 
>> 2.43.0
>>
>>
--------------9Y2i0GqbxFa3gv0kgTzB0mzj
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
    <div class="moz-cite-prefix">在 2025/8/19 23:52, Matthew Wilcox 写道:<br>
    </div>
    <blockquote type="cite"
      cite="mid:aKSdsH_yk69EvkMX@casper.infradead.org">
      <pre wrap="" class="moz-quote-pre">On Tue, Aug 19, 2025 at 10:06:53PM +0800, Jinjiang Tu wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">There are two meaningless folio refcount update for order0 folio in
filemap_map_pages(). First, filemap_map_order0_folio() adds folio refcount
after the folio is mapped to pte. And then, filemap_map_pages() drops a
refcount grabbed by next_uptodate_folio(). We could remain the refcount
unchanged in this case.

With this patch, we can get 8% performance gain for lmbench testcase
'lat_pagefault -P 1 file', the size of file is 512M.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
You don't explain why you move the folio_unlock() call</pre>
    </blockquote>
    <pre>We should call folio_unlock() before folio_put(). In filemap_map_order0_folio(),
if we doesn't set folio into pte, we should unlock and put folio.</pre>
    <blockquote type="cite"
      cite="mid:aKSdsH_yk69EvkMX@casper.infradead.org">
      <pre wrap="" class="moz-quote-pre">

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">Signed-off-by: Jinjiang Tu <a class="moz-txt-link-rfc2396E" href="mailto:tujinjiang@huawei.com">&lt;tujinjiang@huawei.com&gt;</a>
---
 mm/filemap.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 751838ef05e5..5de52deab138 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3693,6 +3693,8 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
 	}
 
 	vmf-&gt;pte = old_ptep;
+	folio_unlock(folio);
+	folio_put(folio);
 
 	return ret;
 }
@@ -3705,7 +3707,7 @@ static vm_fault_t filemap_map_order0_folio(struct vm_fault *vmf,
 	struct page *page = &amp;folio-&gt;page;
 
 	if (PageHWPoison(page))
-		return ret;
+		goto out;
 
 	/* See comment of filemap_map_folio_range() */
 	if (!folio_test_workingset(folio))
@@ -3717,15 +3719,19 @@ static vm_fault_t filemap_map_order0_folio(struct vm_fault *vmf,
 	 * the fault-around logic.
 	 */
 	if (!pte_none(ptep_get(vmf-&gt;pte)))
-		return ret;
+		goto out;
 
 	if (vmf-&gt;address == addr)
 		ret = VM_FAULT_NOPAGE;
 
 	set_pte_range(vmf, folio, page, 1, addr);
 	(*rss)++;
-	folio_ref_inc(folio);
+	folio_unlock(folio);
+	return ret;
 
+out:
+	folio_unlock(folio);
+	folio_put(folio);
 	return ret;
 }
 
@@ -3783,9 +3789,6 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 			ret |= filemap_map_folio_range(vmf, folio,
 					xas.xa_index - folio-&gt;index, addr,
 					nr_pages, &amp;rss, &amp;mmap_miss);
-
-		folio_unlock(folio);
-		folio_put(folio);
 	} while ((folio = next_uptodate_folio(&amp;xas, mapping, end_pgoff)) != NULL);
 	add_mm_counter(vma-&gt;vm_mm, folio_type, rss);
 	pte_unmap_unlock(vmf-&gt;pte, vmf-&gt;ptl);
-- 
2.43.0


</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
</pre>
    </blockquote>
  </body>
</html>

--------------9Y2i0GqbxFa3gv0kgTzB0mzj--

