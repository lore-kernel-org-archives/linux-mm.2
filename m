Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7EE7CAC587
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 00:30:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4065C8E0005; Thu, 11 Sep 2025 20:30:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B77B8E0001; Thu, 11 Sep 2025 20:30:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F4A18E0005; Thu, 11 Sep 2025 20:30:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1F6728E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 20:30:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B800611A844
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 00:30:15 +0000 (UTC)
X-FDA: 83878716390.15.5DA628E
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf06.hostedemail.com (Postfix) with ESMTP id 22C9618000A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 00:30:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757637013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KHFP31aCz3oRP/gHV9iLS/61VQ6KgR2F3qDygqdrds8=;
	b=RmIxVxtPoUv4XmvvNd5L4DIcEZEgWms4/2hJywa8udwMH1JdUfc/db3IFzIWEtsqZeIpVy
	vOYz6QsrIJPLLaQFwBp4AxoAdZaCAB18kmfX6BtjXl3JI1ktQZCP+nwB+qKVbtWUTeeddP
	SJoQVSLfRvyI/RzaIIl3h9+xUYqydnM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757637013; a=rsa-sha256;
	cv=none;
	b=0GeLk//snj/+VxV1Or/rq9B0smG9G0kVyX0doYjWwj/PiziZW7U+9Ub32SnEzpq1eprNLP
	wdbV0Ru1rU7Zk49ZunwqRqzgfs83V3z6Nt/Q9Vgfuhg47x9RDO0W6PGhoq8V4ZYIeqEKgg
	fJOWuqd5zC4hvNYBH9bRO6UbvQlebuQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cNFbs33SSz2VRgn;
	Fri, 12 Sep 2025 08:26:49 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 648161A016C;
	Fri, 12 Sep 2025 08:30:07 +0800 (CST)
Received: from [10.174.178.49] (10.174.178.49) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 12 Sep 2025 08:30:06 +0800
Content-Type: multipart/alternative;
	boundary="------------hjcqecDDOKTPJ2g2SKaQB0CJ"
Message-ID: <1e9a5b96-d9da-440a-8161-cc458ca501c9@huawei.com>
Date: Fri, 12 Sep 2025 08:30:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: fix folio is still mapped when deleted
To: Matthew Wilcox <willy@infradead.org>
CC: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@redhat.com>,
	<akpm@linux-foundation.org>, <mike.kravetz@oracle.com>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>
References: <20250911130848.4087211-1-tujinjiang@huawei.com>
 <aMMRWMpTx6jjZunV@casper.infradead.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <aMMRWMpTx6jjZunV@casper.infradead.org>
X-Originating-IP: [10.174.178.49]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 22C9618000A
X-Stat-Signature: ugpqc9fks3fshcphuc699dtqzpumc4kd
X-Rspam-User: 
X-HE-Tag: 1757637011-777558
X-HE-Meta: U2FsdGVkX19X24oHmgX7h5SugLZJkVoZktlxjfaRdAaIyTmZaEgjNnzqO8nzbEmTACqEZmpaSoj9Mm5S1wprVHQ7Wq0x0ZekQ3fZrTnesrZWMVjcZjOWUWNdrIM2lON95+nT3GrDt493Pi+49nciCuQLBOzSIJ4MuTGcCtuSNkmyvv8YzoCJzZ4X6gcrNfL+uwGbejHHMcs4EivPoEAq7D1YQlcO9LD0cesDU8jFU0eMxfM/RlEuimElOqX8BxPMAhNhtDdPkqwIV+sK6n0kpMGGm6S9ZeBg3K99vGu0EEPMqc+p0WSAUUqtD3QSq1uX2/pdF3cgykRLVTsxvsOCdt17r1Bi39/Eer946F21wywIAdnJcmOVux0Qg0Us1DsyFDm/5SOqj5PnKFHznN7EkiaaMgzc/JqDlMZJ7uoxga0NnjQjPP+M+fBk2tzYme4zYNMDWZXlN9wadUYnQNWoG5PWEudGsX0rQqEqOchH5S9sW2vPTo1IECpMIcFN/qUAJFj/EhZACEaJ5jfvCLoCnpyvwrwBsaz7yd0im3SxIo7iCqv4Jnx4Lqih573S0Eu4wo8dWptMd4rX05a1hd+8ec5JWwufmxJqM799gZbDM8Xw7gOlfYV2jmlje5AhRQgcxt7LDAYyDywbBzBOn385N33dLFpvn3S7zQKFDY011rx+RN6YtcigJF/J+57kHoTW2XOXvMellL2kRJjdnM54QU+X4Mikf8ixhbBMh2LCA+DwVcGTxz4lte/UE6R564i7x3XBusdh//+AyuxTGnO39Hma9QnC4w1tQRhtHdFw6TRT/Acc+1P05axG4jLfR9TosvgSl2j/jvPhFkaNrmd+65T9LUH3EaJRoEjt78Ju3gst9sCMKfRGXZ2gyTeCrtC9pa1fPRDcXJ10m2FXpkSvwfNNXvjvcyRjqey8uquV3NkHifpX4PbYo5leMyLafymaxvGqtXfKvRNClBxl8js
 Kp1q4fF1
 IgJL7A24mld+UnUfVU0c8MJ8AiwfNnQmcu/FhK3LnScfu7xABXi9OWe4+ZV5rT3vzmSF3tE1ImrVPaPZnJeMyTyQ62am+ZtuOVqkZh2Tf6jo4nW74zs1xCwtzv1YczMEQsocuB2/JLtqQqOJ6CeaRT5xMZ3sj+ThqMHh+r1MFwaI0BpAljUTQeAu7F+xTNdyt0zv32IpaIxfyYIsO3YVFFnVRhgZn51RvtBEH9GUYhSY4fZCPS0FgoQ/wcUT2i230bWVwNTfqRyB4zzY5ySVjEJz96IuS4qGlIpkPIaUmTzCH+42IsoVTIQmpaa/15HByaslqt8OORub5pmIbpEJalmaQbh5H5xMSPmlwoqzuu/Vp5pW60ZqN/LvK9Yswuv1E2dXOBPawrOrecSqA1T7Rd0+doTQ4p5EhH8YGlTVqKI3uHIWT5wpE9Qzuck7ui3jUnH1x
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------hjcqecDDOKTPJ2g2SKaQB0CJ
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/9/12 2:13, Matthew Wilcox 写道:
> On Thu, Sep 11, 2025 at 09:08:48PM +0800, Jinjiang Tu wrote:
>> Migration may be raced with fallocating hole. remove_inode_single_folio
>> will unmap the folio if the folio is still mapped. However, it's called
>> without folio lock. If the folio is migrated and the mapped pte has been
>> converted to migration entry, folio_mapped() returns false, and won't
>> unmap it. Due to extra refcount held by remove_inode_single_folio,
>> migration fails, restores migration entry to normal pte, and the folio
>> is mapped again. As a result, we triggered BUG in filemap_unaccount_folio.
>> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
>> index 09d4baef29cf..d21865d0178a 100644
>> --- a/fs/hugetlbfs/inode.c
>> +++ b/fs/hugetlbfs/inode.c
>> @@ -521,10 +521,10 @@ static bool remove_inode_single_folio(struct hstate *h, struct inode *inode,
>>   	 * the fault mutex.  The mutex will prevent faults
>>   	 * until we finish removing the folio.
>>   	 */
>> +	folio_lock(folio);
> The comment above is now nonsensical.  Can you correct it, please?

OK, I will update it.

>
>>   	if (unlikely(folio_mapped(folio)))
>>   		hugetlb_unmap_file_folio(h, mapping, folio, index);
>>   
>> -	folio_lock(folio);
>>   	/*
>>   	 * We must remove the folio from page cache before removing
>>   	 * the region/ reserve map (hugetlb_unreserve_pages).  In
>> -- 
>> 2.43.0
>>
>>
--------------hjcqecDDOKTPJ2g2SKaQB0CJ
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
    <div class="moz-cite-prefix">在 2025/9/12 2:13, Matthew Wilcox 写道:<br>
    </div>
    <blockquote type="cite"
      cite="mid:aMMRWMpTx6jjZunV@casper.infradead.org">
      <pre wrap="" class="moz-quote-pre">On Thu, Sep 11, 2025 at 09:08:48PM +0800, Jinjiang Tu wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">Migration may be raced with fallocating hole. remove_inode_single_folio
will unmap the folio if the folio is still mapped. However, it's called
without folio lock. If the folio is migrated and the mapped pte has been
converted to migration entry, folio_mapped() returns false, and won't
unmap it. Due to extra refcount held by remove_inode_single_folio,
migration fails, restores migration entry to normal pte, and the folio
is mapped again. As a result, we triggered BUG in filemap_unaccount_folio.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 09d4baef29cf..d21865d0178a 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -521,10 +521,10 @@ static bool remove_inode_single_folio(struct hstate *h, struct inode *inode,
 	 * the fault mutex.  The mutex will prevent faults
 	 * until we finish removing the folio.
 	 */
+	folio_lock(folio);
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
The comment above is now nonsensical.  Can you correct it, please?</pre>
    </blockquote>
    <pre>OK, I will update it.</pre>
    <blockquote type="cite"
      cite="mid:aMMRWMpTx6jjZunV@casper.infradead.org">
      <pre wrap="" class="moz-quote-pre">

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre"> 	if (unlikely(folio_mapped(folio)))
 		hugetlb_unmap_file_folio(h, mapping, folio, index);
 
-	folio_lock(folio);
 	/*
 	 * We must remove the folio from page cache before removing
 	 * the region/ reserve map (hugetlb_unreserve_pages).  In
-- 
2.43.0


</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
</pre>
    </blockquote>
  </body>
</html>

--------------hjcqecDDOKTPJ2g2SKaQB0CJ--

