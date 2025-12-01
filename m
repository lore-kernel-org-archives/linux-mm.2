Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAA9DCFD376
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 02:43:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F334B6B0010; Sun, 30 Nov 2025 21:43:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE3A96B0011; Sun, 30 Nov 2025 21:43:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD2B46B0012; Sun, 30 Nov 2025 21:43:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C45B76B0010
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 21:43:50 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E4F8F13C3E1
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 02:43:48 +0000 (UTC)
X-FDA: 84169356936.27.76FBE3B
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf27.hostedemail.com (Postfix) with ESMTP id 182EE4000A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 02:43:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gTvtstdX;
	spf=pass (imf27.hostedemail.com: domain of shiyn.lin@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=shiyn.lin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764557027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FgKmQ565+fVLpdIyWDHQSOr7KTCq34T31zq3f1iCjns=;
	b=pO1iNRxmmiEjyQpl+9WDuTc35NkSbUKV5WFHKQhPIVJKiZ5xX71u+LuR8HJebQ0wdGAqWE
	HG496DF4nIiPLshHFFWnzKkXEe/5YIAOMCCs//25wFsrqXBLbFqN3VIMbSqYPB8GKsTclH
	rL4cfmf/57LGwkmC6YIiGg+8op6h3Io=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gTvtstdX;
	spf=pass (imf27.hostedemail.com: domain of shiyn.lin@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=shiyn.lin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764557027; a=rsa-sha256;
	cv=none;
	b=pQULgppCU7Aq/VvLnPoCAm0+vKwDME8VisklWbenZFcL+l8KNMmJXXgltMsPBaqwgsQM53
	canbREzGkDDsLEXaqx9a6mPBGWS3LrlBqXAyw3pExgU6xedjUflxTFKy7tBOcJIRtfM0TZ
	qCqbFke3X+ap41VGc8qm8QNqsB0x4qo=
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-640d790d444so2876285d50.0
        for <linux-mm@kvack.org>; Sun, 30 Nov 2025 18:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764557026; x=1765161826; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FgKmQ565+fVLpdIyWDHQSOr7KTCq34T31zq3f1iCjns=;
        b=gTvtstdXjrTRNDjYaAPcmuq7WeHOyZD50SOI7+lU4hgeK6mk01TndMaqrejNlveOKZ
         PqnL332fMRGJ0ZfxhSEeaXgKMnngHiOygHv+BAbyUWI7eiPis5kFhuKSskzUsPRB1o+S
         Fb8UHBBi4X4nKb2rmoSA6y33hMVOkU/cngAnJLF7dIgU5kpmXwdv4+0xpQ+abzueeIxj
         wws5HI00j+f8bzKDDncyTwJiYgUFFnnM2L3n0Yg/bRaf3MjYnuFlROfeWXG4GaHsD6eK
         WskwxxpLH+unaNPYZqMTr4WKoAXRlY/iNTPPldQQLe8TIP3bEVKFyP55PqQJtxfmNcQO
         DP+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764557026; x=1765161826;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FgKmQ565+fVLpdIyWDHQSOr7KTCq34T31zq3f1iCjns=;
        b=mCZkAO48nHP+zOQ4nxUZvRuAS//5DWVPbj9+d8qvCfjJaLsaz00lr+NShf8qJREvgB
         Ms98MdV99Cm9mA0sYegnfJgjUPksa8MCCcMq7HkbBVJelTq654yFhaGSoqh461hLRP3g
         wUG5ogA8ABBPhMCNHXLasaKk8jccYSEnoVPzq1cuK9E0j2Jv14jt8lKNumzFCKEhbGFa
         f+9dqncNB6nR0PDOJEotDZVy7iop/DP1HN9sul87AETRav6V/0RSty59xkP2wAcNvk23
         DNUofWu9yJUhzUcEuzPFq/OthAezNN7tp0JGqddkUGHd3x6i1NDlE7w1lgpKut4vQHBY
         oxkw==
X-Gm-Message-State: AOJu0Yxxn8eZzlu8ePUkZsvk9Dcn2YS/btHqRKHld4kFw05jlydksWNo
	Qr+ZmzdpZJSZdayBJTlkrIqUGcSx9g85/ae0EhyyNNwKGoG9rHePWqmG
X-Gm-Gg: ASbGncuqeShw8e7JM0qijxwyC6k3HP+fBNX25QTZ3r0KeG2w+bGMUmHvDQ2ImUw1PPz
	WCu45K4ICpUUMNUCZgINg5RCoYfBKThBxV06iP6dLAh+ncNtUj0EG6O+h0Js9Y9GejC3tZvzJWB
	EyAD7DRyEPAPvfR8ANkikd3EGvZAysyYy0sDeRSG0vouuw9pz/NKKdJFl23r25ZQcEmimxftW3P
	DAobDS7JlsWPW38M6Zh1hFiu/OgqyCq7n2rK9aba5keBgxfnnsBVRHknyRuWrf+dKpqrX+t+8lD
	puWRnVQn6cfgrlVpd2kBeBA5da8k3kvyZAcJyyRoN7Nfc1qo+EVdc6ZNNrGxFkp7w9haWH/igcM
	Wd3To0Wcqk/zbesZW58YU5aXdmHLnykCNoU2vO4GHu2/tgYvrwKTEJ9VWCbSlOpqXywoWaguTV8
	8Pz0hDbE8g+nHg/ZZA8/3EdfI5mRm0hod0Ib8EvSwe+iPPu2g9ayYBzXk=
X-Google-Smtp-Source: AGHT+IEftPLm4wwxMTV5S8HfduywFkxnzNagdp0uZjRVeMizo1texs4FhkEpOIkFK8yvV81AVPnx9A==
X-Received: by 2002:a05:690e:1519:b0:63f:25cc:112a with SMTP id 956f58d0204a3-64302ab83fbmr26144911d50.54.1764557026026;
        Sun, 30 Nov 2025 18:43:46 -0800 (PST)
Received: from laptop01 (2045061-002-static.lfytina2.metronetinc.net. [149.154.21.178])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78ad0d3f616sm43906407b3.1.2025.11.30.18.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Nov 2025 18:43:45 -0800 (PST)
Date: Sun, 30 Nov 2025 21:43:43 -0500
From: Chih-En Lin <shiyn.lin@gmail.com>
To: Jordan Niethe <jniethe@nvidia.com>
Cc: linux-mm@kvack.org, balbirs@nvidia.com, matthew.brost@intel.com,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, david@redhat.com, ziy@nvidia.com,
	apopple@nvidia.com, lorenzo.stoakes@oracle.com, lyude@redhat.com,
	dakr@kernel.org, airlied@gmail.com, simona@ffwll.ch,
	rcampbell@nvidia.com, mpenttil@redhat.com, jgg@nvidia.com,
	willy@infradead.org
Subject: Re: [RFC PATCH 4/6] mm: Add a new swap type for migration entries
 with device private PFNs
Message-ID: <20251201024343.GA9270@laptop01>
References: <20251128044146.80050-1-jniethe@nvidia.com>
 <20251128044146.80050-5-jniethe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251128044146.80050-5-jniethe@nvidia.com>
X-Stat-Signature: qfdkwa3j7tk57ydg4ic5qk77gy5n1ewy
X-Rspam-User: 
X-Rspamd-Queue-Id: 182EE4000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1764557026-497017
X-HE-Meta: U2FsdGVkX1+DgEmr7UKRLWhnzvd9hxFYqCF601H1rWLoHOwpYIcKx0MRSt0TJ8ACo7c9NmSC6JtvAbjm1XyEQDJCMQlflcJc+/Z3t8ChyNbg9j6V0nhJGRy07cj76VocztsnqvVa/CYwNEucbVqwIxvLwOwyNi3hT8tqUWbHXbrzG2nzYUGgxWuGzVmdhJrcXt8DhPp7e/eGmcyO9QFx2wMuk6YZ06LM9wmEUE72lbnGIK2qWtgq3MeWEejwjNFEEFWQhErkwwyRND2oA8z2rbfL1Al7IrXcwq3Bs89/SVsuyYoOuvt3C2VCETtAqYsSow0lO1rYUsxg8fytkbNZ7Jhtb65Oj2weiCLGQO4Es+THGNohpmo5MS/EB0GkjYssM+PdD+m6kpOCClMpDDik0aNkkxCTBgMs1ORzJ64GvJjJRB8KlxBsHwCU8poPrIrydEoQRK6zcaV0zUA81JrFLOK/isvP09X2pTXeUm9l4jFD1MAWebHMlA/Pkur2jzHCNKFMY7FxlGV3toDfNy+Ex4QYQy9EyPhBvvjeswY8V7WOVU6hZdck/u5pIYFVlLi28ywddhn8ZXZklYI0KQu1WYcnqcIx9cgsAhJ7Bdf4ly//Z9pCIsLneLbABV/hYXacQx3pq0R7kWuA+e8IyC1MPPN8+hGjoHTAQHs1H2YeTLHbrJZGutAytQsBWYYSdSma8nHLJdRujvu8C9oixCj7Vw5GWDZoUW5aYIrxOAPeFCDWXqzQaav8rjFf441bE6AqXjRFfdiYQhZ+oi2VNajiku6h/ZkbzjvWHIS58nGL2e9KLVA7ml2vx0uaX9ihHRFUkQ6Now2YAm+cyGeXv0XAu3HDd82WSYoTDRsuHce8VaQkqRjMOCwqfepn/vEnRk7EHM8zqd8PgmDAklM+/h3gW5nZlvaXuEwf8U80DfoHlbpp002udH8prcoQ3UKH4zw4rMZUwpNmFAKqdYBcwmX
 VLFZnWzS
 D7FrjEb26DGD3SiqU2tY8hFgotTpmhJxldpVq2HwtygESqOBKFTMhHoMSbv9FXV1icz+EoVb3PUw9CqLy82MP03qe8/JnFGw9leep75FUuwAUgtI0xi/DQh0gGS68tgs2DsypGiQntQV2Ivcm8dHIT0lUZNq9oB4vJTVsqLSwUF8Jq2bQIzxuodZumT97HAEdsuuA2h5CtmNyxeZoeh8QJGBggnf8kd8lR8EY0VG3+i9+6Iya5cHG7ZfFE/Y/U8X445YA34a/W6F2s2QFFuWUSoIm84EWrhaGEQepP6LdzqxWAGWqcOcBhmRM5elVpxvWKTHPy6saqF5sS01Z7m9bgUQ24Gbct8KUczMPzdpPClBRYivvIQRCe+UY3juCQL+4w5OJuEFXjlXmDYB+g53wDsKpZWu1rmOMI+pxIC4d65raVGpFW9jm5W0Tuf44SghA3iz+v2oMkt1/wJWzMjML2taQ/U5d2djoehBwjoFXIvR30pIA42Ohj8O7al66659UOZfZGMLVnXlR76I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 03:41:44PM +1100, Jordan Niethe wrote:
> A future change will remove device private pages from the physical
> address space. This will mean that device private pages no longer have
> normal PFN and must be handled separately.
> 
> When migrating a device private page a migration entry is created for
> that page - this includes the PFN for that page. Once device private
> PFNs exist in a different address space to regular PFNs we need to be
> able to determine which kind of PFN is in the entry so we can associate
> it with the correct page.
> 
> Introduce new swap types:
> 
>   - SWP_MIGRATION_DEVICE_READ
>   - SWP_MIGRATION_DEVICE_WRITE
>   - SWP_MIGRATION_DEVICE_READ_EXCLUSIVE
> 
> These correspond to
> 
>   - SWP_MIGRATION_READ
>   - SWP_MIGRATION_WRITE
>   - SWP_MIGRATION_READ_EXCLUSIVE
> 
> except the swap entry contains a device private PFN.
> 
> The existing helpers such as is_writable_migration_entry() will still
> return true for a SWP_MIGRATION_DEVICE_WRITE entry.
> 
> Introduce new helpers such as
> is_writable_device_migration_private_entry() to disambiguate between a
> SWP_MIGRATION_WRITE and a SWP_MIGRATION_DEVICE_WRITE entry.
> 
> Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>  include/linux/swap.h    |  8 +++-
>  include/linux/swapops.h | 87 ++++++++++++++++++++++++++++++++++++++---
>  mm/memory.c             |  9 ++++-
>  mm/migrate.c            |  2 +-
>  mm/migrate_device.c     | 31 ++++++++++-----
>  mm/mprotect.c           | 21 +++++++---
>  mm/page_vma_mapped.c    |  2 +-
>  mm/pagewalk.c           |  3 +-
>  mm/rmap.c               | 32 ++++++++++-----
>  9 files changed, 161 insertions(+), 34 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index e818fbade1e2..87f14d673979 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -74,12 +74,18 @@ static inline int current_is_kswapd(void)
>   *
>   * When a page is mapped by the device for exclusive access we set the CPU page
>   * table entries to a special SWP_DEVICE_EXCLUSIVE entry.
> + *
> + * Because device private pages do not use regular PFNs, special migration
> + * entries are also needed.
>   */
>  #ifdef CONFIG_DEVICE_PRIVATE
> -#define SWP_DEVICE_NUM 3
> +#define SWP_DEVICE_NUM 6
>  #define SWP_DEVICE_WRITE (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM)
>  #define SWP_DEVICE_READ (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM+1)
>  #define SWP_DEVICE_EXCLUSIVE (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM+2)
> +#define SWP_MIGRATION_DEVICE_READ (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM+3)
> +#define SWP_MIGRATION_DEVICE_READ_EXCLUSIVE (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM+4)
> +#define SWP_MIGRATION_DEVICE_WRITE (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM+5)
>  #else
>  #define SWP_DEVICE_NUM 0
>  #endif
> diff --git a/include/linux/swapops.h b/include/linux/swapops.h
> index 64ea151a7ae3..7aa3f00e304a 100644
> --- a/include/linux/swapops.h
> +++ b/include/linux/swapops.h
> @@ -196,6 +196,43 @@ static inline bool is_device_exclusive_entry(swp_entry_t entry)
>  	return swp_type(entry) == SWP_DEVICE_EXCLUSIVE;
>  }
>  
> +static inline swp_entry_t make_readable_migration_device_private_entry(pgoff_t offset)
> +{
> +	return swp_entry(SWP_MIGRATION_DEVICE_READ, offset);
> +}
> +
> +static inline swp_entry_t make_writable_migration_device_private_entry(pgoff_t offset)
> +{
> +	return swp_entry(SWP_MIGRATION_DEVICE_WRITE, offset);
> +}
> +
> +static inline bool is_device_private_migration_entry(swp_entry_t entry)
> +{
> +	return unlikely(swp_type(entry) == SWP_MIGRATION_DEVICE_READ ||
> +			swp_type(entry) == SWP_MIGRATION_DEVICE_READ_EXCLUSIVE ||
> +			swp_type(entry) == SWP_MIGRATION_DEVICE_WRITE);
> +}
> +
> +static inline bool is_readable_device_migration_private_entry(swp_entry_t entry)
> +{
> +	return unlikely(swp_type(entry) == SWP_MIGRATION_DEVICE_READ);
> +}
> +
> +static inline bool is_writable_device_migration_private_entry(swp_entry_t entry)
> +{
> +	return unlikely(swp_type(entry) == SWP_MIGRATION_DEVICE_WRITE);
> +}
> +
> +static inline swp_entry_t make_device_migration_readable_exclusive_migration_entry(pgoff_t offset)
> +{
> +	return swp_entry(SWP_MIGRATION_DEVICE_READ_EXCLUSIVE, offset);
> +}
> +
> +static inline bool is_device_migration_readable_exclusive_entry(swp_entry_t entry)
> +{
> +	return swp_type(entry) == SWP_MIGRATION_DEVICE_READ_EXCLUSIVE;
> +}

The names are inconsistent.

Maybe make_device_migration_readable_exclusive_migration_entry to
make_readable_exclusive_migration_device_private_entry, and
is_device_migration_readable_exclusive_entry to
is_readable_exclusive_device_private_migration_entry?


>  #else /* CONFIG_DEVICE_PRIVATE */
>  static inline swp_entry_t make_readable_device_private_entry(pgoff_t offset)
>  {
> @@ -217,6 +254,11 @@ static inline bool is_writable_device_private_entry(swp_entry_t entry)
>  	return false;
>  }
>  
> +static inline bool is_readable_device_migration_private_entry(swp_entry_t entry)
> +{
> +	return false;
> +}
> +
>  static inline swp_entry_t make_device_exclusive_entry(pgoff_t offset)
>  {
>  	return swp_entry(0, 0);
> @@ -227,6 +269,36 @@ static inline bool is_device_exclusive_entry(swp_entry_t entry)
>  	return false;
>  }
>  
> +static inline swp_entry_t make_readable_migration_device_private_entry(pgoff_t offset)
> +{
> +	return swp_entry(0, 0);
> +}
> +
> +static inline swp_entry_t make_writable_migration_device_private_entry(pgoff_t offset)
> +{
> +	return swp_entry(0, 0);
> +}
> +
> +static inline bool is_device_private_migration_entry(swp_entry_t entry)
> +{
> +	return false;
> +}
> +
> +static inline bool is_writable_device_migration_private_entry(swp_entry_t entry)
> +{
> +	return false;
> +}
> +
> +static inline swp_entry_t make_device_migration_readable_exclusive_migration_entry(pgoff_t offset)
> +{
> +	return swp_entry(0, 0);
> +}
> +
> +static inline bool is_device_migration_readable_exclusive_entry(swp_entry_t entry)
> +{
> +	return false;
> +}
> +
>  #endif /* CONFIG_DEVICE_PRIVATE */
>  
>  #ifdef CONFIG_MIGRATION
> @@ -234,22 +306,26 @@ static inline int is_migration_entry(swp_entry_t entry)
>  {
>  	return unlikely(swp_type(entry) == SWP_MIGRATION_READ ||
>  			swp_type(entry) == SWP_MIGRATION_READ_EXCLUSIVE ||
> -			swp_type(entry) == SWP_MIGRATION_WRITE);
> +			swp_type(entry) == SWP_MIGRATION_WRITE ||
> +			is_device_private_migration_entry(entry));
>  }
>  
>  static inline int is_writable_migration_entry(swp_entry_t entry)
>  {
> -	return unlikely(swp_type(entry) == SWP_MIGRATION_WRITE);
> +	return unlikely(swp_type(entry) == SWP_MIGRATION_WRITE ||
> +			is_writable_device_migration_private_entry(entry));
>  }
>  
>  static inline int is_readable_migration_entry(swp_entry_t entry)
>  {
> -	return unlikely(swp_type(entry) == SWP_MIGRATION_READ);
> +	return unlikely(swp_type(entry) == SWP_MIGRATION_READ ||
> +			is_readable_device_migration_private_entry(entry));
>  }
>  
>  static inline int is_readable_exclusive_migration_entry(swp_entry_t entry)
>  {
> -	return unlikely(swp_type(entry) == SWP_MIGRATION_READ_EXCLUSIVE);
> +	return unlikely(swp_type(entry) == SWP_MIGRATION_READ_EXCLUSIVE ||
> +			is_device_migration_readable_exclusive_entry(entry));
>  }
>  
>  static inline swp_entry_t make_readable_migration_entry(pgoff_t offset)
> @@ -525,7 +601,8 @@ static inline bool is_pfn_swap_entry(swp_entry_t entry)
>  	BUILD_BUG_ON(SWP_TYPE_SHIFT < SWP_PFN_BITS);
>  
>  	return is_migration_entry(entry) || is_device_private_entry(entry) ||
> -	       is_device_exclusive_entry(entry) || is_hwpoison_entry(entry);
> +	       is_device_exclusive_entry(entry) || is_hwpoison_entry(entry) ||
> +	       is_device_private_migration_entry(entry);
>  }
>  
>  struct page_vma_mapped_walk;
> diff --git a/mm/memory.c b/mm/memory.c
> index b59ae7ce42eb..f1ed361434ff 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -962,8 +962,13 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  			 * to be set to read. A previously exclusive entry is
>  			 * now shared.
>  			 */
> -			entry = make_readable_migration_entry(
> -							swp_offset(entry));
> +			if (is_device_private_migration_entry(entry))
> +				entry = make_readable_migration_device_private_entry(
> +								swp_offset(entry));
> +			else
> +				entry = make_readable_migration_entry(
> +								swp_offset(entry));
> +
>  			pte = swp_entry_to_pte(entry);
>  			if (pte_swp_soft_dirty(orig_pte))
>  				pte = pte_swp_mksoft_dirty(pte);
> diff --git a/mm/migrate.c b/mm/migrate.c
> index c0e9f15be2a2..3c561d61afba 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -495,7 +495,7 @@ void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
>  		goto out;
>  
>  	entry = pte_to_swp_entry(pte);
> -	if (!is_migration_entry(entry))
> +	if (!(is_migration_entry(entry)))
>  		goto out;
>  
>  	migration_entry_wait_on_locked(entry, ptl);
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 82f09b24d913..458b5114bb2b 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -235,15 +235,28 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  				folio_mark_dirty(folio);
>  
>  			/* Setup special migration page table entry */
> -			if (mpfn & MIGRATE_PFN_WRITE)
> -				entry = make_writable_migration_entry(
> -							page_to_pfn(page));
> -			else if (anon_exclusive)
> -				entry = make_readable_exclusive_migration_entry(
> -							page_to_pfn(page));
> -			else
> -				entry = make_readable_migration_entry(
> -							page_to_pfn(page));
> +			if (mpfn & MIGRATE_PFN_WRITE) {
> +				if (is_device_private_page(page))
> +					entry = make_writable_migration_device_private_entry(
> +								page_to_pfn(page));
> +				else
> +					entry = make_writable_migration_entry(
> +								page_to_pfn(page));
> +			} else if (anon_exclusive) {
> +				if (is_device_private_page(page))
> +					entry = make_device_migration_readable_exclusive_migration_entry(
> +								page_to_pfn(page));
> +				else
> +					entry = make_readable_exclusive_migration_entry(
> +								page_to_pfn(page));
> +			} else {
> +				if (is_device_private_page(page))
> +					entry = make_readable_migration_device_private_entry(
> +								page_to_pfn(page));
> +				else
> +					entry = make_readable_migration_entry(
> +								page_to_pfn(page));
> +			}
>  			if (pte_present(pte)) {
>  				if (pte_young(pte))
>  					entry = make_migration_entry_young(entry);
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 113b48985834..7d79a0f53bf5 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -365,11 +365,22 @@ static long change_pte_range(struct mmu_gather *tlb,
>  				 * A protection check is difficult so
>  				 * just be safe and disable write
>  				 */
> -				if (folio_test_anon(folio))
> -					entry = make_readable_exclusive_migration_entry(
> -							     swp_offset(entry));
> -				else
> -					entry = make_readable_migration_entry(swp_offset(entry));
> +				if (!is_writable_device_migration_private_entry(entry)) {
> +					if (folio_test_anon(folio))
> +						entry = make_readable_exclusive_migration_entry(
> +								swp_offset(entry));
> +					else
> +						entry = make_readable_migration_entry(
> +								swp_offset(entry));
> +				} else {
> +					if (folio_test_anon(folio))
> +						entry = make_device_migration_readable_exclusive_migration_entry(
> +								swp_offset(entry));
> +					else
> +						entry = make_readable_migration_device_private_entry(
> +								swp_offset(entry));
> +				}
> +
>  				newpte = swp_entry_to_pte(entry);
>  				if (pte_swp_soft_dirty(oldpte))
>  					newpte = pte_swp_mksoft_dirty(newpte);
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index 9146bd084435..e9fe747d3df3 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -112,7 +112,7 @@ static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
>  			return false;
>  		entry = pte_to_swp_entry(ptent);
>  
> -		if (!is_migration_entry(entry))
> +		if (!(is_migration_entry(entry)))
>  			return false;
>  
>  		pfn = swp_offset_pfn(entry);
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index 9f91cf85a5be..f5c77dda3359 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -1003,7 +1003,8 @@ struct folio *folio_walk_start(struct folio_walk *fw,
>  		swp_entry_t entry = pte_to_swp_entry(pte);
>  
>  		if ((flags & FW_MIGRATION) &&
> -		    is_migration_entry(entry)) {
> +		    (is_migration_entry(entry) ||
> +		     is_device_private_migration_entry(entry))) {
>  			page = pfn_swap_entry_to_page(entry);
>  			expose_page = false;
>  			goto found;
> diff --git a/mm/rmap.c b/mm/rmap.c
> index e94500318f92..9642a79cbdb4 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2535,15 +2535,29 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>  			 * pte. do_swap_page() will wait until the migration
>  			 * pte is removed and then restart fault handling.
>  			 */
> -			if (writable)
> -				entry = make_writable_migration_entry(
> -							page_to_pfn(subpage));
> -			else if (anon_exclusive)
> -				entry = make_readable_exclusive_migration_entry(
> -							page_to_pfn(subpage));
> -			else
> -				entry = make_readable_migration_entry(
> -							page_to_pfn(subpage));
> +			if (writable) {
> +				if (is_device_private_page(subpage))
> +					entry = make_writable_migration_device_private_entry(
> +								page_to_pfn(subpage));
> +				else
> +					entry = make_writable_migration_entry(
> +								page_to_pfn(subpage));
> +			} else if (anon_exclusive) {
> +				if (is_device_private_page(subpage))
> +					entry = make_device_migration_readable_exclusive_migration_entry(
> +								page_to_pfn(subpage));
> +				else
> +					entry = make_readable_exclusive_migration_entry(
> +								page_to_pfn(subpage));
> +			} else {
> +				if (is_device_private_page(subpage))
> +					entry = make_readable_migration_device_private_entry(
> +								page_to_pfn(subpage));
> +				else
> +					entry = make_readable_migration_entry(
> +								page_to_pfn(subpage));
> +			}
> +
>  			if (likely(pte_present(pteval))) {
>  				if (pte_young(pteval))
>  					entry = make_migration_entry_young(entry);
> -- 
> 2.34.1
> 

Thanks,
Chih-En Lin

