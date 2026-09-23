Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EBC1C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 01:38:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02B0F6B008C; Tue, 22 Sep 2026 21:38:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1EA26B0092; Tue, 22 Sep 2026 21:38:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0CF56B0093; Tue, 22 Sep 2026 21:38:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B6E006B008C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 21:38:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 46445A06A7
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 01:38:12 +0000 (UTC)
X-FDA: 85243316424.01.9D68303
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 03964180009
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 01:38:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Iw0RKiC3;
	spf=pass (imf24.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790127485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PxGCM8xxwnmehx2AfVy1IEcUOYJtD/f1L22IPBat84s=;
	b=pkAXDpDUjZI7LpoZiLunwsiD+8PvQc40i2WOzjf/SKVQ6TH7PnZ6wjQdxhWQPiVPlISs52
	qAwYLmAZKn11VFenyCGIniNREbVdI1sgqaiSDVYDfvyx/xxoEwc+PlPfyk+Z0NtorKQ8TJ
	Odokdn4mfeXnTSmbid4SyKTG4BgjKJc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Iw0RKiC3;
	spf=pass (imf24.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790127485;
	b=cxB13VuvXaTXJ8l6Grz73rulXkPigaFQ/OTovh0Ez2ELOLYaHAMQxKVkAeKs9wllMmYDAH
	EnCdZHNz+zbvlp23rXtNH8isRKpBHfTjMRJN3PajIKzbZGpi4aVxYKEU7Zd7XoErQlfJAk
	Ep0SrRHzp5zBk/F+PQHaBXTnwGhyZBQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790127484;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PxGCM8xxwnmehx2AfVy1IEcUOYJtD/f1L22IPBat84s=;
	b=Iw0RKiC3/oZ4TY/KeWoXVfpKn+F9K7jT+japsbOf5Ru7OLHJddI/crxlmktQ400cgnDydn
	oy+F93MfD7H/+LYminJKb1ZcCpEvFwd7zQvha0t8AkKbMQrQgNv7/RwcDDvcG/Inl/hbNh
	nHlQ12NCYH8rm59guXb+XZN14XbeiOM=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-531-8mANNKkTNHalIvsP-m0NUg-1; Tue, 22 Sep 2026 21:37:56 -0400
X-MC-Unique: 8mANNKkTNHalIvsP-m0NUg-1
X-Mimecast-MFC-AGG-ID: 8mANNKkTNHalIvsP-m0NUg_1790127476
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-5328cdb38bcso9244761cf.3
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:37:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790127476; x=1790732276;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PxGCM8xxwnmehx2AfVy1IEcUOYJtD/f1L22IPBat84s=;
        b=Bihfz8LVvRijfwrZW5CHhRPQBoYy9VT0sOXWXg9I+l57bzEMtDJQCXMvz5/Dd3nliD
         oWwawBV3BZ8GWYnhavo4/viQ0Qmz6QZW2M7IHs5ZnEqw2jXwFSYo/xnDdvy687jP2eEb
         ZQKZICLrMLWM7e9TKSFhLIhTjQ9UwRYkrUi9bfDmtZiZ4coxrxOFzLIog+tzaxbot1zu
         0KJ1r2AGVqFSE6s2pTEUhZGXjQyBHFZYLKQ4NiAw0lL0hOYEXS3Hm5rD1MyFi7BEMrwc
         p3+g2Cd5V6IA1RCttcCJRiRFltmXwUMho0It5oRlkbgKeAr2RcoNAhiJJF1FlBbhrcNo
         GwNQ==
X-Forwarded-Encrypted: i=1; AKwUvBwIVq3/vVZDZW6qjx5WiLrk9AWnBFzyAVMMbaz51A4+Z2tMoVifmChxt4E4tHjnuWgRu5MWq4MZDQ==@kvack.org
X-Gm-Message-State: AFuF++nvfnJX3BW5TJaqKY2s0vXl/eIi3/Qaf0C52NJEbLg36N0BtqPC
	f9CO01HEmBH9UB5wYrBz5UbjjwsipZi3tGEY8nR1UDosLDYLYZmOlZYhoSqRRWLlbZb8I5HbQ0g
	MN/6aiTENx8YFLNfvxB3emdJPP6ze3XMX3ERNnv6rz4GZIe8gGUQ3
X-Gm-Gg: AYBFou0W/m710GRlDatYA4/wff5W+lzpxmGcP1V9s/yu0MEwCLKgoSTCoJnqUjfbmwx
	UhSGFvZhPIfaNWl8brELHc+w7G+fDqM/ait3yFJfjYEVk2pcw7/BuOHBnCytjw4sh7ktizCc8dV
	GhkQtP+QBBnBCNSp+jr36wrALKQd19+eU3LwhCSeLz828sTw+oItvqOBKhdRd3WXnC/0iVhdl9H
	98hve2AIZb7ek3TnJ17kxRnVpurOKYItQqbVeiFkAFsW70UrntiJdhc7TPGSYyy3SXyMhclHveW
	0CA297Jsj2k5KylPkVAE0de3FUm42/rr/ZHZn8FpU7LJh0Z3iYJOeLWuzH2WBSezAIDmORdq81v
	lQSg=
X-Received: by 2002:a05:622a:d14:b0:532:f0a2:ee3 with SMTP id d75a77b69052e-532f0a212femr1998421cf.68.1790127476102;
        Tue, 22 Sep 2026 18:37:56 -0700 (PDT)
X-Received: by 2002:a05:622a:d14:b0:532:f0a2:ee3 with SMTP id d75a77b69052e-532f0a212femr1997961cf.68.1790127475647;
        Tue, 22 Sep 2026 18:37:55 -0700 (PDT)
Received: from [192.168.2.110] ([142.172.30.162])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532eb399581sm9358311cf.28.2026.09.22.18.37.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2026 18:37:55 -0700 (PDT)
Message-ID: <3d914185-ac87-4fc7-ab21-de184bfd4e57@redhat.com>
Date: Tue, 22 Sep 2026 21:37:53 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 07/14] mm: shmem: allow THP support determination at
 folio allocation time
To: Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, david@kernel.org, baolin.wang@linux.alibaba.com,
 lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 dev.jain@arm.com, usama.arif@linux.dev
References: <cover.1789695931.git.luizcap@redhat.com>
 <f74ada750d1910f8ea7e55955eb0c330747b93d4.1789695931.git.luizcap@redhat.com>
 <DLLHIE1QXVF2.38IQWBL11QXIQ@nvidia.com>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <DLLHIE1QXVF2.38IQWBL11QXIQ@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cZ8EqXdZxHKj5M8494jea6SHEN0nzcW_IdH0XjBIbkM_1790127476
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 03964180009
X-Stat-Signature: sk97xiz3nbxs1hphin16ortxjwrntygq
X-Rspam-User: 
X-HE-Tag: 1790127484-912341
X-HE-Meta: U2FsdGVkX18ZwR926LTubSJTSQXny5XRm80j0Oq8zVhpjmRBsGoQnzVF6bmg+IKsshBN4e6zDAf68xq0l7jz6a7a6aCmgo3++wzRt6Q2Ja31rYetD6Sw68gaphOHQk6Nx5i7rC9YZiXoGvVRNanFx0LnsU6rmzBWkjEKbURR810kxNPQtKA5DUpg7Qfvks595Ny0jfsObLOx2Vheht3ZAMPzU4cDdWdhBLuHNj2nrh1DQwJglHf34xae/Sby8pvgst7uHrfuhgTSkVKzvLFyoankae1gy4CuRvr0lLoYSJhgtPXQalflO5SxNSTcI8GbTTIG6+qfslw8DnKJnIsujSPB1fxia2gjR7JSnlQxJ7fGQoytsBW9SzGaHu5W8m5Np8R9Al0CCWPfGFLFLg3R+JOWqilCYcdtZuAle1mUDxOlt24w8qZrmlSQ/FMyfxBt8bbFFSA5lGneR2Nn+yk5NE3nYH4hk6NXXoL9vqVaUgplGQoMpg+wQKXs27DgjKyeAm7x+a0chva9rEnO1raklj0rhkXnco4cHMu8x2NSN6H06HbCIcTk2PGptYcCym2p04FWM8cSYABBY4gLpABTcnYzpyWehVvEXmG6PLePTrFYSLr6Od1EtWbHLUkGyFar7t+3uyuV8cYcB7a0tr3Qqz2RLmQ67fEEI/qcxWuVuiMTXLeuMSeFb2X2lPfmCSag+jMl3kttsXtR5VGQDKzaCibo7HtEJz8F15WUxhp1uO3QU5V4zMXC9hFGzIeUgV5VHLPwBWbhsCvIdG29uuqNkXzjQSzqYxhVadnOvbtqsACfZtUhdbKwdlJY7YrkVlFHnLq07xb/J71TDi20001B6xXTmmrr6//UTxhvIzTk0HVMoBAvf0N0mvmMkb8vH+dD+ip12Qd6812N0F7nKjXFwf/D+9OloLyuTkNX+J0XXkgOr1lL5J3zCtHiiankeeGFQwPrmJWi5MiQEdJYx7p
 b909rqGM
 f0c8E5ZYDaXEaYnDC8eWLuvBPdP8Gcl3cDWG6Mm3ClbHNtMeX883Xe2terLvVcVbqbsB2Ci05HDgy220Y8bkqBS43PF3YvhxWC+PQL6UgAqKwzZwSepxwNcMNYcU3dTG8XRn3b+jkoNuuWTG7MxBHBlyXef5hY54BiRj15aWf8+ZrMKYMrHsADHSY3iToWd3PD3fNCTGziPe5XGydMxT9lZbO0+YJH2rlBbVTh8UO0RU1VQ3ybUfNaVJ2nnCgyvJf7onyA9kVSIzCXNeHK5IDtPepeBoc58xBygtVIcSH9wgUkSvyRKfTzf6fCRC1kjr3BTIEbk+F6jGE7ag3/5mC93sMqvtCcgMB3+GvQXO0BQtZmd7BhwxG/oEYGkGltf5iO7Y6N2XieRJep9vtDh2+qt+vVt48QHyZUvXP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/21/26 10:20 PM, Zi Yan wrote:
> On Thu Sep 17, 2026 at 9:45 PM EDT, Luiz Capitulino wrote:
>> In order to enable THP support in shmem today, besides the user
>> configuration required, the CPU must support PMD-sized pages. This
>> is the case because of the following has_transparent_hugepage()
>> usage:
>>
>> - shmem_parse_one() and shmem_parse_huge(): Check if THP is built-in and
>>    if the CPU supports PMD-sized pages
>>
>> - shmem_init(): Since the CONFIG_TRANSPARENT_HUGEPAGE guard is outside
>>    the code block calling has_transparent_hugepage(), the
>>    has_transparent_hugepage() call is exclusively checking if the CPU
>>    supports PMD-sized pages
>>
>> While it's necessary to check if CONFIG_TRANSPARENT_HUGEPAGE is enabled
>> in all cases, shmem can determine THP size support at folio allocation
>> time. Therefore, drop the has_transparent_hugepage() usage listed above
>> while keeping the CONFIG_TRANSPARENT_HUGEPAGE checks.
>>
>> Additionally, we need to check if PMD size order is supported in
>> shmem_getattr(). Use pgtable_has_pmd_leaves() for that.
>>
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
>>   mm/shmem.c | 9 +++++----
>>   1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 776dff8a848e..930657d05375 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -690,7 +690,7 @@ static int shmem_parse_huge(const char *str)
>>   	else
>>   		return -EINVAL;
>>   
>> -	if (!has_transparent_hugepage() &&
>> +	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>>   	    huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
>>   		return -EINVAL;
> 
> This can be deleted, since shmem_parse_huge() is guarded by
> CONFIG_TRANSPARENT_HUGEPAGE and after the change the if is always false
> under that guard.
> 
> Otherwise, LGTM. With the above code deleted, feel free to add
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>

OK, here's the diff:

diff --git a/mm/shmem.c b/mm/shmem.c
index c00bc1829fc9..d12995d41846 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -690,10 +690,6 @@ static int shmem_parse_huge(const char *str)
  	else
  		return -EINVAL;
  
-	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
-	    huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
-		return -EINVAL;
-
  	/* Do not override huge allocation policy with non-PMD sized mTHP */
  	if (huge == SHMEM_HUGE_FORCE &&
  	    huge_shmem_orders_inherit != BIT(HPAGE_PMD_ORDER))


