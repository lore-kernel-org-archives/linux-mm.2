Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F29C1CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 08:57:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 628F28E0010; Fri, 12 Sep 2025 04:57:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6008A8E0001; Fri, 12 Sep 2025 04:57:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 516EB8E0010; Fri, 12 Sep 2025 04:57:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3F18F8E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 04:57:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EDF415AC54
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:57:47 +0000 (UTC)
X-FDA: 83879995374.13.024C02B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9716540004
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:57:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LmX9aJ0+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757667465; a=rsa-sha256;
	cv=none;
	b=SANuPJ0zPtNCb0UA5J/ju4PC7CkXAALBzxhm/oi4cgWlYcxyvY1qezC9aYC7DNGBoqJYFr
	prA6nrLTDgp68qKfSZWIUip9z7tvXqog7OtYSxZEBpWRbiiNQZNrPDxdx+9v9z8gShPb2A
	QA8PXb3aSQYPhpeX3kVz4YPD9nQwFo8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LmX9aJ0+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757667465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gvh2Zb5LHN8KYqKprwhbFHUr38VnGteS2eUYfgfDSpM=;
	b=idcHoTs4WmMfAkGv1gq8o2jqToECf10CftielByVD9iYVfuymy7PvOJqQEOtcZ7+m9k2ba
	rVinC2zp0nhcWWH54O+YIASThPHeO7Ei7Fd1/NXwAtIiUn16I6aWGTCQxXlrCDtz4u/+FP
	z/wsvIXYdVZiLr2lBsEzBzqoLJy2GCg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757667465;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Gvh2Zb5LHN8KYqKprwhbFHUr38VnGteS2eUYfgfDSpM=;
	b=LmX9aJ0+iP/7JO26juR/Mmj2LVVY+UUXDePycp+vRCF/7jAstEioHFjIr/fg6Hvb9AKwj8
	VZFhx0LeSZ82TmmxhJVV3F9RDyeLVHvdwFvvaSCvMOZ5m1FofAZFuTo4nq8jBx3nHAuwmp
	CSk1h12xwafJej3fFmxRalz+I+IHG7Y=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-Y26LGyhePkKOI-wLR2seaQ-1; Fri, 12 Sep 2025 04:57:43 -0400
X-MC-Unique: Y26LGyhePkKOI-wLR2seaQ-1
X-Mimecast-MFC-AGG-ID: Y26LGyhePkKOI-wLR2seaQ_1757667463
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3df9f185b82so610932f8f.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:57:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757667462; x=1758272262;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gvh2Zb5LHN8KYqKprwhbFHUr38VnGteS2eUYfgfDSpM=;
        b=AGWnLtzbcovKYG//KaAUrODfZ2HOs1kFNeUBGLhjk14d8mdu0jSopHzQIs7JQyqgMM
         6xoM++MmcwY5j5oUzsNSuWAzKjB3h7CfcDziB2vNHQmW0L+2AzMiQBq5XliS1tNMKfpP
         HXv5qrl6YSwdVtH/jMgrzl6OZJxdbg8NZo6FMnxrDQwW1bRlXDC2fI/sxA501un9RSO5
         J4iylLUH2o4FFO2a4cqZ9trgwg0WZUk7SpeDAFBBd3eOy59lblBBn8Jyq+mwbe5Cbur/
         eexe2kIGAgw/np5yqw91bnYKls7fo0n3vL2TOHTWZAxsUcstZXjT7BT7cViAfN8iCJAi
         lRJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUiZwp31KaqebrxAoVAZgSOiVRMbKf8EzR5IaLA/K7mBvEpSVqhup6aAYnaDzjivEySB+FhiHQn5Q==@kvack.org
X-Gm-Message-State: AOJu0Yz911dn5YXgr3BlCBiwjXj/Lgbm3bjW2SIPqCfyPAbBBOJgQ06S
	VRRWr7+w/hSKHfLKTMb4jpQrfQsHOm3q2bk+aj0jYs8OQ53l9kmq9burERXv0KKrdayReHvACsn
	GdEL9rIP9GCF2wrII/x26pmwRJmfIL4guIYqub0QebUymajLCUTD/
X-Gm-Gg: ASbGncsXDH821PIi3b8VuX9mSBDyF6CKEBSwx7KjR4fytkyTzdFkne7EvhbjlIl146V
	WfpdS6hOtAip4OevP3DuSmVZ3zijB0FzuQc+nEyV3cTCR6Ck3tMXgmWYZt0zifWbG0epFxvYU80
	4phkuussPLF6nvBeLaP2mDAy/WozjD5sKcCOSYPaom8LNiV4OnUVv5CSbFxnKLbETo1b9IUMDt3
	nYKsnKX22rYOS4KDyYq6U5PiRZhz1NJ9oNv7xUMSx27j1m538+65S0DJTBm2I/0Q7QuLAKd59Bo
	JX7HPmVCuISIyEjDALfkU5SrlwIiq1z7+U+UMZRyfSCfqHgcGgVZXJGANNkf+7HCZc50/BYcgNV
	sM7O5ctrnMlWNo+xnB6fmLrM8rzz02U4M8x1Hu9NgvlQnM7eP+zN8PGXKJF7HlJE9eHE=
X-Received: by 2002:a05:6000:186a:b0:3d7:618b:2923 with SMTP id ffacd0b85a97d-3e765a26619mr1969476f8f.48.1757667462551;
        Fri, 12 Sep 2025 01:57:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtpTEH8ZF0pk5VHVw23WjjC8G4J66w7d/8+zqmiDSw8BuA65N1n/WplO5cXk5Q2FqiT8TxDg==
X-Received: by 2002:a05:6000:186a:b0:3d7:618b:2923 with SMTP id ffacd0b85a97d-3e765a26619mr1969454f8f.48.1757667462122;
        Fri, 12 Sep 2025 01:57:42 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607ccf88sm5755903f8f.33.2025.09.12.01.57.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 01:57:41 -0700 (PDT)
Message-ID: <1bef69dd-7308-41f6-ac0f-5f171609c1cc@redhat.com>
Date: Fri, 12 Sep 2025 10:57:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: vmscan: remove folio_test_private() check in
 pageout()
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 hannes@cmpxchg.org
Cc: mhocko@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 lorenzo.stoakes@oracle.com, hughd@google.com, willy@infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1757648598.git.baolin.wang@linux.alibaba.com>
 <b8c0fe71982aa1cafafd59d8e71064efaac16007.1757648598.git.baolin.wang@linux.alibaba.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <b8c0fe71982aa1cafafd59d8e71064efaac16007.1757648598.git.baolin.wang@linux.alibaba.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jtyNxUMBfDQJ_Hr_2BW4cqV220EMYZpTntzyvvSVWhI_1757667463
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9716540004
X-Stat-Signature: htendbcagrp3f8g371usbxyojh6ihkep
X-Rspam-User: 
X-HE-Tag: 1757667465-7043
X-HE-Meta: U2FsdGVkX18TRsI0EvJBm3DJe2/zYcio8c79m/s41BReDJy+C2EywYeLwRQQfmx2kCzBUvqQ/yC60rt1yHGC3txS1p3GXdNin1ln2I6tJqEwPxHKaCc/1VofVdOY4xVe3+8bB+FSrFqOrdqQTJY+skqpeGmgVWP5rOqOXAuzzN8jXRGpZwAfN+4N5/5z82GI/Sk6tRVaAAduCsdwampPVlHHgBDSO7iRYBDERBW13FaOD47CH+C6I4Y32mNNNSGNb5AZfItth39rRlfW7DvnqmuhpQHMj3bmGs5oJZd8HZWs/b0yQ5drYm5dGseYmixQUF63T1k6tcy+joTkWIUzJRmXZ2W+8GcBF5fKKIl3qV+HPQTCqwWK2JDDp0REmvdiwH11Bd3aY73LvCM+vmDW9mRCuRbujXfxUxpQ6OW4qLD/82Kz4p5szQHbDZzv/LFD8Ti5/8Nwe3J0pJYmltjbp6EpocgijZv8VNm51m90sIkiViGAnAsF6C3W4nVIGLf8OYZCLDnHJ+c7D2EY+BB8VhrfRQLVkYb5OjKKx+oINzyjb7mmmLmP5l8IpWQ0d995Z9zbd/kACnw2xQIUO5kbou7IygNj037RiGxRPfMa2hlfp3bdL66fM+6SpDqXlV+Y9NzUfN3c49yu53kiHsqsTVOO1GPb30t9yrATztEM91aZreZZE4Z68QGm6W8DDYfaj1kXQVG4vGVB3nqfj0x6YKMDI+UrcZsqfoRAU60EQURQ6YPfZY8OgXoYXiE4tVIm4RI+iFZPUX+hI7VIKvzRZZdwEUstavUuugNiB9Xa2ZIXIftFItXD4zlzMc+jRSdBV2ipHrbsmyeQK2kHBibGzcjEUt2jK3BnReU6uEDhzIGg1jbq5HYxC2Tow+ldX4O2+An/QdQz8szZ3LTwqRphUzTrjF3pHGHUT+z60Ti4GzwM9+5uMLumOJYBrShwtEoQmCxCar24cRUXfC7QInE
 oXdcbf9z
 i8Y6og/aC+/eGeDXlN/zf75GnGeTvqS9hFpGOLIKGF5/E7haFUt3x6inpP+Zkh0hlbd33sesvoEEtNebFWlWyB8L9DLESvQJgv9kTrxeVs25DInonLVBWaKgwh0NB1/cBtAJXHYwSmFbcCwenEB7Bavx5YRsnKenzvW89dgGDAgs71PvRvtA5zc/qr24EMGIm7r3d5U3juWtyN6N6gjLbygEywtK+E0OtGdC9/IQVW+ZSdtZRtoVzvVHpdais5bYx80ribdVPLfxYWkcl3gyC/cvqcpNTgt/wAWuhzTgYiH8g4fjWsFjcFqFGVZyAt7jJ0Y3x0LG9kR1BqC1spy8TmF5W1eshVAVrDtS0ACPyzVioz7OK8fCAboiU5NQet3Sfn2JC0ZanQwtNecvXJkag/Rgr54mlQYD5ns90hHxlEtVIJsGaT/ATJMjjDBcEyjEm9ipJudl6/44YliMJq5tinLauMsfrzE5Ne2xE/PfSL9wRfz+qUo0YkgjVQEqDNiTq8FSTLo9a6GdapfgysnwOJfZoyjhnkmusi96L
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.09.25 05:45, Baolin Wang wrote:
> Currently, we no longer attempt to write back filesystem folios in pageout(),
> and only tmpfs/shmem folios and anonymous swapcache folios can be written back.
> Moreover, tmpfs/shmem and swapcache folios do not use the PG_private flag,
> which means no fs-private private data is used. Therefore, we can remove the
> redundant folio_test_private() checks and related buffer_head release logic.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


