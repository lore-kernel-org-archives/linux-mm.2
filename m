Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BA9BC55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 21:26:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08AC86B00C7; Tue,  4 Aug 2026 17:26:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03A4D6B00CB; Tue,  4 Aug 2026 17:26:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E94746B00CD; Tue,  4 Aug 2026 17:26:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C86CB6B00C7
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:26:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4BBC3C02F1
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:26:51 +0000 (UTC)
X-FDA: 85064871822.13.7B60A7A
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6A898140003
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:26:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=aYUNQQV5;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785878809;
	b=gYoiaxQDTOC4P7DZ+ijbPK1MTRFCjlSK8ZK3tqn6bPAXpy9b0U6dB6Cjo7wmQawD6KTLDU
	14YpCKLzAKAXDtKcOjZuuoT/ucg1ulhb4VgDx/WeHotdFfb7hwCs7xx2j6d51/pTbI0nNb
	YCSCPlkouvCCGRwKOtzc9BZbfJq4rbA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=aYUNQQV5;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785878809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8E0jAVHN8ZtyJncyypOkHVI2p3kLARZRTEYAoWDJwJY=;
	b=neXrkNmAK+Zxw3r7OzOSqdSgbaQwJbv5QInjF+gas2IDaFM6N3lnVMNXRAV/h7Uro/596b
	1yS0bvmspTzSOAACAr206bwZbixhoUlyisHAuiEZ7ZH7Eq8/gjF2j4t29BqDAtIGd8bSMg
	KOr8ZGrwVCAB4c6fs1v6mSgedsg6ZaI=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-930f4e5eed1so24004985a.2
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 14:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785878808; x=1786483608; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8E0jAVHN8ZtyJncyypOkHVI2p3kLARZRTEYAoWDJwJY=;
        b=aYUNQQV5zNUuTUuNDy1Qu/MqjtvfQDBTodltzO7AJcq2dO1b2907AS/GmMTGRYdsaZ
         icmH6jzPwQPeW/9cpOQ1ympnoGiRpcJTCco2V3LN1MfVuae/i2U9u42de5YENgzMNuT9
         ulWxXV5WdDgTSmGIyCBYCoJ/6koTMMKV8qw8ZIuVQ093GUJKOecRVb0aLzJ42g6sgdrl
         tgfTzVdpqsRWWQfj0WPJl1xwMjfXEaSaPjNL/NXb4tu+9+ooUrcqsftqSQfab9z66KuL
         qHo+mEFM2o8lxj2DFefHQOYBIdS7bcjmlFQY7PGZC3J3JYvDtfyl/Bo1exP3Jh9QYoCC
         rcnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785878808; x=1786483608;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8E0jAVHN8ZtyJncyypOkHVI2p3kLARZRTEYAoWDJwJY=;
        b=AETnpEAF8l/raSM6N6Ay5wil+Z3NJlfLsYEk66VWhSnV4/Hmt6zogKyCyH+zOcq0Nn
         3UxEd+7KMxs+bQQpWYX2XKGoHpuI0qCzhXPoROdJiWXu//zKnvysAkiTDWDvb2Xrq84/
         l0N+Ho5Grx/7mtYveWI5WbFRYi2dQmT7B4s52U2FB49+Tp7pOHAWSZIaX5f45rw2CT4b
         WTsA1UCAaWpG0Mk+5X5PgCgji9lFC/GAcZicAb16catI6M+g4HUwKVS1UsGCL8w9hwID
         ZumH6FscxM8aK8nVnuGFGd6tpycZL6RW4FDr1AtolK/eoZloEf87pZtzR0Gl6ZTlehh8
         We7A==
X-Forwarded-Encrypted: i=1; AHgh+RpgOy7dKet1xQcrhV4HJIiDMQG6qSGnj3j/3s2XJGOer1q3CSCyPIJCtH0VcaCbSRBQOyZz7zuNlg==@kvack.org
X-Gm-Message-State: AOJu0YxceQXgzUGvBkqLxBo1lRBOYe/kZ4OVXCfpR0Ko4STnl7Mk5ozo
	w8JEbO8iI4bKADFUYW1jHVdgTGQBT5W/d2oeRsP300GJKhhJ65YQ22ZVy4ChW76513M=
X-Gm-Gg: AR+sD13cUKuiLwqeogaTrUAi1wcK/ySVZPXJsfrV7blnJYJNVLcXzk5cxIYxHCjn/WR
	ENmY3UcvLPmvbhCnFMueSk1g+v4HJptYFGW4jCRC+QBg3dJwsALuYR6yPq5K7tznxR9oRSVeEbd
	YPFA2ji6DqUx4zWHJmg2/aWzANtfr0hW1kyTjbN0XU+DrhR2Jg1cTG1b8x4bFcCmY+R8tAX+RzH
	t8rBYSMd6Dyve1BHaZdFd+PeGFNwBpWE81nFAms7bhiMCCZ5eFlkhCf9rJ9vGhyDkodvP1iCA0/
	neuVi2QmQ0JKr94jiDqBBRcdGxxAiiBtNi7KJBIBFay/vDEw+kt6yyMuZ3p63EQm3aqZwRJUipk
	4OHNhWAudAMdFpjVkm+Nxa9/YnFUymxACVpZQrNFO17A7C3v/8LDSOK5YHvHfPooihDfWgcRKf1
	lmBCayzyI5o8Fwkfv5yyhS5xmy1w5dEEwBKZ9YKsq2UOtTAC48omS8ydNDIQVVwSUg698P1P1rn
	rDd0sQUOih54ZBuaZDQhMX2ZhPlxy6DIA82Fm6aqrqx
X-Received: by 2002:a05:620a:7101:b0:930:9e52:2b05 with SMTP id af79cd13be357-93649150e9amr130786285a.15.1785878808478;
        Tue, 04 Aug 2026 14:26:48 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9364a5296e3sm19453685a.26.2026.08.04.14.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 14:26:48 -0700 (PDT)
Date: Tue, 4 Aug 2026 17:26:46 -0400
From: Gregory Price <gourry@gourry.net>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <christian@brauner.io>, Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v8 15/15] hugetlb: replace hugetlbfs_read_iter() with
 generic_file_read_iter()
Message-ID: <anJY2zu_7J-ewVES@gourry-fedora-PF4VCD3F>
References: <20260731200802.574821-1-willy@infradead.org>
 <20260731200802.574821-16-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731200802.574821-16-willy@infradead.org>
X-Rspamd-Queue-Id: 6A898140003
X-Stat-Signature: agze4gbdgebfnux59m1tftf4hdbdjhzd
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1785878809-297446
X-HE-Meta: U2FsdGVkX1/ApD5B7fVYneUEKyI2DzfUzSYIB5vO9FSYSmekU4RBrdJ4fjX4eromQ5RfSZxzssg7TbmKjwWdq9jvPPn5vjoH1Ex9AJyJ6cvgYcuhq3AOqmUTWRA5MMHt5XPOctIm7peb3V75gpB9D1uh2Ux0AfFxsuZ59BgTxw80LAhUcx4s77LR5F3+mz+Yw3w/TYCedya7oXyKGPXHmddRa7J8Gl6HEdgaeOcmcbkOAsIc2baWf/NE8RrpTWqHb2VKFyEW+TX1VdENyTniLLsZikRjj9yGwVA0tKyMOkgs685H9cu26a0E90IY+5YklAzDYLZPowbQMn7Lpjajb2RNym73AD9aUodakyn6LXC5e3E9sL6BjHev7Y/syIw+IGVvcSrPd52p+znOQFJut1FCUfsxI48liOM5f3+t1iQfEehGhQm6P2LwrzTINlBUlGEswwV6KnqKWKxpkrcPQNFwv4JoT5ELD/XoKum3iwEkVRMw1P2eOakxvVp+8C+2dxcRq4vDGPJlThw6Rhjn47MzrGvKLNnlyblR9kWIx+HIJpZBnVUqMXVt4+OixcX360BhztZX5aX0SKVeUHIz/8LQ9tqToxwA7CS8SiivFVkYixlWWuLwe9HVbYT4sqmZ8J2FSACAnBRvt3p9g2qN04yGce0ChmG4J/pj2RJ6zAAqLVJpqCq8zIHBarZAmhJrAhqT8fLfSKiF2gTMowPJaGhipv+5x6W49DHioL1yj8QE2ojH9/Rs7Z/sVbbXuxOZQ3N23GBWBOoepvgmBG0+UNj4qlg/3X23Oyz81fjabaf/xBEzBKt4ZYVJlT7X9rdIvL4uUzKx52DwJvlYII9i49VQ9AcD5xi2gYQ4g3ZNtO+TC+MGx+wHJjaWMCmnMzl41hfB/DoQ7p1CsQoHEp8ivxxyU3V4+OruG4RxmOZ1jJ3ksY7nmcbuucu4K9eX9kx5UwMHDVOMcWOgU8anXxv
 E+mEX1Kl
 adhhdr9E9Z5B64YYKNODxf6DNoNSBFG4GQtultNlgKhtiKcysgqSe6FIfi1dZY3szTMyRmXXXaZH62adDz9/CFd2Hau3TYpVJBP4Impo33NfZ1oUJKivpC/MuTjXsqZlkejHHnTIs6IunSweFhrelAK6VOAmVdN7KJbKUDsZijq4Ud/megEWy/S9GjAFhfTQyeIVcYa/cAlQu7uUGvWiYd7/TayI1nfKiEA76k1xib2SABjps+j47AgGBfZEtpN6p21mgePImzPcUIYdT42Jx9ozQ5INi3soG82QA2nKatMGZDcs/nBuGYA5jKyTxezc670ZSlS7Lnc9GrrAC0lVhCQRyUZqH3Xf3iY+nJpkT1WPIJHvClSrP+46PBAdStW2OqbQDbjl/+H/6MzQ23rXS5u3irE75W1lBQe8E2JmzuCO8q/cBZYsQ8pxy9zMH+IXbE4/qA7E+pcluxuOVxYPlcSdqv3FyOlpZvoFG6I7Wdrus5c+W+Pj6DO369TLQUCOsN6Rt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 09:08:00PM +0100, Matthew Wilcox (Oracle) wrote:
>  
>  static const struct file_operations hugetlbfs_file_operations = {
> -	.read_iter		= hugetlbfs_read_iter,
> +	.read_iter		= generic_file_read_iter,
>  	.mmap			= hugetlbfs_file_mmap,
>  	.fsync			= noop_fsync,
>  	.get_unmapped_area	= hugetlb_get_unmapped_area,

Still trying to wrap my head around 11 and 14, but this is nice.

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

