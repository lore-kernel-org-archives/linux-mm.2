Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55401C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:10:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EA336B0098; Thu, 10 Sep 2026 07:10:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66D996B0099; Thu, 10 Sep 2026 07:10:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55B3A6B00A0; Thu, 10 Sep 2026 07:10:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3455C6B0098
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:10:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 99959140486
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:10:14 +0000 (UTC)
X-FDA: 85197583548.26.EF11E38
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6FF3D180004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:10:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=FlFsF6Yv;
	spf=pass (imf16.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789038612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rvYgWCWqn9o1wKFP8qdaR/yG0XoyGPk/YSg8atQ0Jb8=;
	b=3pL6raxqo5HXSKFLJTG378r/Xd93tuMF4ana/bDTq1S7T+fHTRL4r6UsRwNknYUI9+DmZC
	y7pJyEIsZaXgGYeH6Rf6BopvmcD3t6E0g+gVR5sUf8W6llWrWZvQnayirI3Eep6SVYdaIe
	Qy7YwoKS91Bt3QpvmXZf96xlNMoDM1c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=FlFsF6Yv;
	spf=pass (imf16.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789038612;
	b=Zdz+xmQZ5kngoAmlLzNpYsjz7H+PEVGFULDa+HBSZ9UfMSwvTjzDXWbEMMQr7UroafW1Ny
	WTKntc9yeFXu5I70qG1OCRjCQtBrR0GGcZgqrGaXVNqidzXCYxdWyDdePGjjhRwwD2dm37
	9e039xV5ZjeWisx6Hyr+xWgXFrviyvg=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=rvYgWCWqn9o1wKFP8qdaR/yG0XoyGPk/YSg8atQ0Jb8=;
	b=FlFsF6YvU4yyCMNuxlaOu2M4Ek6gWY4fYPOzoVUD7qYGHZ37JVdoTxOGBkZTH4DBLBtTAkmxy
	xLVJD8z3PVx/X5PTl7ggTY1hF2IsafCWUpqfjqqEodOz4Ae4fP4cExjNgBAyOL+Jzm/QuZQNBGL
	dYKv8sDteo3N2i87W53yjEE=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hgZRk0W2xznTVd;
	Thu, 10 Sep 2026 18:58:58 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 967934057A;
	Thu, 10 Sep 2026 19:10:06 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 kwepemk300003.china.huawei.com (7.202.195.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 10 Sep 2026 19:10:05 +0800
Message-ID: <ea608517-49ce-4a9e-83bb-8687a139c4f2@huawei.com>
Date: Thu, 10 Sep 2026 19:10:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] mm: zswap: skip zswap_invalidate() in
 swap_range_free() when zswap is unused
To: Yosry Ahmed <yosry@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>, Chengming
 Zhou <chengming.zhou@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Kairui
 Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed
	<yosryahmed@google.com>
References: <20260910095449.715183-1-wangkefeng.wang@huawei.com>
 <20260910095449.715183-5-wangkefeng.wang@huawei.com>
 <CAO9r8zP-bGU8Hr+0ah9vpxWJBdbw+wTGMuC8+pTOHa+9XaeU+w@mail.gmail.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <CAO9r8zP-bGU8Hr+0ah9vpxWJBdbw+wTGMuC8+pTOHa+9XaeU+w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Rspam-User: 
X-Stat-Signature: uo1t8snf3gxym6in7739g67pwfs4obzo
X-Rspamd-Queue-Id: 6FF3D180004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789038610-529847
X-HE-Meta: U2FsdGVkX1+gpjmoS2wM7qUlbPyTtn1aQ3Av0DAubEzXwAqgIfIHhPuecdqN7b8PMUgC8xb+GWYwM695C6ZZDbK4FN3gMjdw3GAHIgbG3WtDA4ihU3DIh2pyYYcs81JEsg6rX7BdiQ4W54rOAxTB/F/MVv2/vMWSwFHdRVc4dHhE+v4igNBc6bMnT751qUefAbLL7u9z7p8USMHBCLdMoiQbT363WKtCH9eboZcfpjhpRZF4IIZibnTDu/NDB6ifhVqp32VA7X0fT/JxeG1f44TzHdzcWDxgHyyEP6VnKBuaOW359/aM99ASoE7K3wezXmeBzUq5hpn/IvOW5rRb/8RmdlG2oiGtBkD+oT9ZCmXX6LH/8ANr0+EeODz/X7pgfVjc7jbAkVnpWd1WKVIZ25xWi6Rrzf9t5x8ydcKZJgLBW95op1xV8gHny7Jfemzd99v0YLPoZrG12r+1Jl0jDZUIyDiJQ2Ifoy2yO7BZJV9LYwTI41FtPFp6LwCHqMtwxBf2CSlUIp/IqxmXK0CtIRn1k1xUlU8/0e9+Bl3bNjJNRtfuy5r89PSfbVLLfdaIZ8ATNRPbaQj/D8JsrJuDFUcbSeyXYjPSMBeg+JKJ1/CcuRXmEiecxaRa5ZiDjHAk5I+tr8EeyurYD2oul88lJemaSpe/btIRwwwax41P/3MT3u1/HGxyuCFevTw2eBxqyTkWakXbpJ/7CPJfXpEwaXnPI+cT3pHQtX9DrY9phRTTjVQ4OUfVkZ+q8dafjP23ysOeYlsdKJqFFd/Z9GRNJVi2RZ9oUwf5Q1aXE0IVPVXlEntHQDi+uI+9woxYnnZSyF/UDT54XMPNSHPir15Lxdy1cF213uIzRYetkuA3sJZYWSEXMF/GVZEYPdzjipUcUzU9O1/iZ+vXs0JigvUzL0getVb6kZu1YsylvXnYgOkT6cPeyDcVeK3CeRFIw6ZLF9/pH3gi20rbyM5dAKw
 ktmBops6
 MUEVw73v6YZ6ZNc84Pp0LTa6dGHt4wJwK7+wXaO+vYH+IPZEMNUQKYWOYSvSWMddvp03FZcV4ROFlxMdFoCWaIbud0MgqONqj6thHuiFQnzyUvOo5vcV5+jrKLEvJG9q8tXVK0YVXS3JKLlPSakrLhPXFm6TBaEF0yc8Phrpgj6yeZ7wasrFYAqO4wvg10uSNA5wC8z87R335YzgKKQ5EtaQhQC+dc+XmxRhTGJLYk7aQuY87PnGa3omoUq4aXYzRH42Hzb1F785dRKFrb6nfayx3/e/8Fbo8n6gPycibGAAr8x0KqrHLsgRJDIXnT0QBK/rFjpKtpMVYazncAv3ApZkhg1kW0GAaaxau7iTUOsq574PrJD6HicQzp8F/U4KsPUhvPcxISmlke/VLVRUXWRYmDAoJZ25qUM6F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/10/2026 6:29 PM, Yosry Ahmed wrote:
> On Thu, Sep 10, 2026 at 2:55 AM Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
>>
>> swap_range_free() calls zswap_invalidate() for every slot being
>> freed, even when zswap has never been enabled. Guard the loop with
>> zswap_never_enabled() to skip it.
>>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   mm/swapfile.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/swapfile.c b/mm/swapfile.c
>> index ba71905e4d46..505592051924 100644
>> --- a/mm/swapfile.c
>> +++ b/mm/swapfile.c
>> @@ -1318,8 +1318,10 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
>>          void (*swap_slot_free_notify)(struct block_device *, unsigned long);
>>          unsigned int i;
>>
>> -       for (i = 0; i < nr_entries; i++)
>> -               zswap_invalidate(si->type, offset + i);
>> +       if (!zswap_never_enabled()) {
>> +               for (i = 0; i < nr_entries; i++)
>> +                       zswap_invalidate(si->type, offset + i);
>> +       }
> 
> What if we add the check in zswap_invalidate()? I understand we'd
> avoid the loop here, which is nice, but I wonder if it's actually a
> measurable difference.
> 

Skipping useless instructions is always a good thing.

> If we keep it in zswap_invalidate(), we can probably also skip patch 3?

Maybe add nr_entries to zswap_invalidate() and check
zswap_never_enabled() in it.

diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index 463bdee5c1e1..313c2f1b6c2e 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -27,7 +27,7 @@ struct zswap_lruvec_state {
  unsigned long zswap_total_pages(void);
  bool zswap_store(struct folio *folio);
  int zswap_load(struct folio *folio);
-void zswap_invalidate(int type, pgoff_t offset);
+void zswap_invalidate(int type, pgoff_t offset, unsigned int nr_entries);
  int zswap_swapon(int type, unsigned long nr_pages);
  void zswap_swapoff(int type);
  void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg);
@@ -49,7 +49,7 @@ static inline int zswap_load(struct folio *folio)
         return -ENOENT;
  }

-static inline void zswap_invalidate(int type, pgoff_t offset) {}
+static inline void zswap_invalidate(int type, pgoff_t offset, unsigned 
int nr_entries) {}
  static inline int zswap_swapon(int type, unsigned long nr_pages)
  {
         return 0;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 505592051924..891379c95a01 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1316,12 +1316,8 @@ static void swap_range_free(struct 
swap_info_struct *si, unsigned long offset,
  {
         unsigned long end = offset + nr_entries - 1;
         void (*swap_slot_free_notify)(struct block_device *, unsigned 
long);
-       unsigned int i;

-       if (!zswap_never_enabled()) {
-               for (i = 0; i < nr_entries; i++)
-                       zswap_invalidate(si->type, offset + i);
-       }
+       zswap_invalidate(si->type, offset, nr_entries);

         if (si->flags & SWP_BLKDEV)
                 swap_slot_free_notify =
diff --git a/mm/zswap.c b/mm/zswap.c
index 6197aa71e33c..0e72cc9a5415 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1549,13 +1549,8 @@ bool zswap_store(struct folio *folio)
          * offsets corresponding to each page of the folio. Otherwise,
          * writeback could overwrite the new data in the swapfile.
          */
-       if (!ret) {
-               unsigned type = swp_type(swp);
-               pgoff_t offset = swp_offset(swp);
-
-               for (index = 0; index < nr_pages; ++index)
-                       zswap_invalidate(type, offset + index);
-       }
+       if (!ret)
+               zswap_invalidate(swp_type(swp), swp_offset(swp), nr_pages);

         return ret;
  }
@@ -1661,17 +1656,25 @@ int zswap_load(struct folio *folio)
         return 0;
  }

-void zswap_invalidate(int type, pgoff_t offset)
+void zswap_invalidate(int type, pgoff_t offset, int nr_entries)
  {
-       struct xarray *tree = zswap_tree(type, offset);
         struct zswap_entry *entry;
+       struct xarray *tree;
+       int i;

-       if (xa_empty(tree))
+       if (!zswap_never_enabled())
                 return;

-       entry = xa_erase(tree, offset);
-       if (entry)
-               zswap_entry_free(entry);
+       for (i = 0; i < nr_entries; ++i) {
+               tree = zswap_tree(type, offset + i);
+
+               if (xa_empty(tree))
+                       return;
+
+               entry = xa_erase(tree, offset + i);
+               if (entry)
+                       zswap_entry_free(entry);
+       }
  }

If no objections, I will refresh all the patches.





