Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C52CDCCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 04:38:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 284E58E0008; Wed,  1 Oct 2025 00:38:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 235C48E0002; Wed,  1 Oct 2025 00:38:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FDAA8E0008; Wed,  1 Oct 2025 00:38:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC5AF8E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 00:38:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B470C140894
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 04:38:17 +0000 (UTC)
X-FDA: 83948288634.25.28A3060
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id CCFE6100010
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 04:38:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MbnIkHmU;
	spf=pass (imf05.hostedemail.com: domain of jinji.z.zhong@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=jinji.z.zhong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759293495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=orjiVwk9jVmakZ54G1xSOOUArCKwPbL4DFcsMOqI4MI=;
	b=AN+CAKIEOk3RDR1kes02rHniriN0q8tEuQhT2glgGZ10vQwNTrHVTFZskMLHiylaLXj53K
	RiZ5ucdzICYwXH0WG3dBSGO3dpEybMRFDoO+i1FoEta1EvZhxuJbmB/zWZ2eCJosnGt34G
	CGg1FAyV4dGhlW0oxf6e4Wie+jfQliQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MbnIkHmU;
	spf=pass (imf05.hostedemail.com: domain of jinji.z.zhong@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=jinji.z.zhong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759293495; a=rsa-sha256;
	cv=none;
	b=C8SQGYXieDutIw9GBwhP5l3JAJxjVbWCCKUcyk0AwYioIUIhtsDlI8rmaYFa8sMGog2IF0
	Ki8x1n964P0QmjNiOYdFY4ecE8zNfstYEXewLAiSMQyXM13N+3SVZk9B0T7yHG/xG+SDRz
	K8EGdzr2b1kfkxK1fVudY3yd5jSoU44=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-789fb76b466so1170818b3a.0
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 21:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759293495; x=1759898295; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=orjiVwk9jVmakZ54G1xSOOUArCKwPbL4DFcsMOqI4MI=;
        b=MbnIkHmUR/uWxfJ6DcXLVLD3tc/BdqSm4UnR8vCVIcirET4gMKNCH4ZkWz8sRJMbW6
         UBSz7aSSEx+D1+rXyFjWWkbv1BhKfgUdxC8PJvZ7pIFnq5GrtUSXw04ul3B1oaKuTrs5
         /VF5w3Q+1kjifWssxNT2/tRECUBAH8k79rgd3h8Cqdvw3MiSFKfMfzuaFhYtQeMt6a4e
         aWH657TYqZMeKbTxBgEYcQg6MmNqT5P6RG/HSDtY/nUtwphWfdCd5YQIwKbQXBH183Ao
         iA4zNyU5bXnL5254A1WOjUJUU6XAfnJGHYRW9vE5LbEoehmES3TdFd/SxZn61uIWjE+r
         EWng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759293495; x=1759898295;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=orjiVwk9jVmakZ54G1xSOOUArCKwPbL4DFcsMOqI4MI=;
        b=OZYYTvnt2JHjEcZjsUPuH86ZJ/ruJXb/F+O1YBITOry92gmPx/4fC9xpsakFqoeibh
         1fZZYS3OIUr0ZUFCoPy3VOuhHrE5uH4exrsSt/ozqjyVaYu3yTAxMvJZBqiNtcMnfUuH
         wb0jqdyR2Emyj+pYV1LhcM6UiSEnasdLeNNe5uRdGLwgAgV3kLerlxrf5As71N7ce8BM
         b52uK9dLDbHfAtfVdc6NDUVeCrVSqRw9j1IxzjoWm8vytON7kNytlyKRpg2hahTX7fIv
         suDBfas7+68aDy6F6tyCw03DMRPd+tNmjzN21o7M5PJkPYFRJ+7iqRLFp0lhjSgVABlN
         +Zog==
X-Forwarded-Encrypted: i=1; AJvYcCVIaowZbJ2eZdmKat4ghmebSHQHGu9r8v2rVym94WOcjmd7gkxh7PthGABS2kaDctfhiEXvwydlrA==@kvack.org
X-Gm-Message-State: AOJu0Yybjxe43l2+BLR8szOJ29wXZC3cE0D6N5ujbg6Jcr6v2mG8EPxP
	7VD31jpTH2NQaTv2Hfv0EN7tx4vTfEvJCD4toYNye0GfINDGsW8FBLRt
X-Gm-Gg: ASbGncuoNrYwd4y3S+r+eFbCOX6m7a819WadFPe3s8RVEX2xO0NAcfZ720c6+390uRA
	BC+KkxcgKe7WfFriJMxr+e166nDirtDaiONJETbb1w8DNuoDaSdDOrJ+C5S7dGJZdvnf8D303G9
	J2C/BwbpCB1JQRZfJ71sOf4VhOqLhSZtYvAgvdXa6LjuE1/7WwE572oAER3aPxTpD6aoBqs+Pk1
	V8SV5ytOTYfUXFMR2Yso8tlWa7coPsr8xDaQAHhd2BxyjWnHASmXn/J7LEiw7w7HwWbtmjQzw3F
	ORe/9MmjPVAxkn32NnpbEN+kPG6xI6zbdH8CCZmUX09KWmQ9IGA5E8Fk9WWzyQGwq4QlNuBpJeA
	hNAZDnG9F52AFkGQH8I2PcPFZtBSHw9sA++Gx
X-Google-Smtp-Source: AGHT+IFs5bZFDV04o//0C2oYnOx72aMORXDwifOEjRchzNZn3UoLmDmaq+PUE6cX7sUUJbBmPCgC0Q==
X-Received: by 2002:a05:6a00:194b:b0:781:1a9f:aee7 with SMTP id d2e1a72fcca58-78af3fe9a87mr2377050b3a.2.1759293494640;
        Tue, 30 Sep 2025 21:38:14 -0700 (PDT)
Received: from daniel.. ([221.218.137.8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-783ad5e99acsm7912871b3a.22.2025.09.30.21.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 21:38:14 -0700 (PDT)
From: jinji zhong <jinji.z.zhong@gmail.com>
To: ziy@nvidia.com
Cc: akpm@linux-foundation.org,
	feng.han@honor.com,
	hannes@cmpxchg.org,
	jackmanb@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	liulu.liu@honor.com,
	mhocko@suse.com,
	surenb@google.com,
	vbabka@suse.cz,
	zhongjinji@honor.com
Subject: Re: [PATCH v0] mm/page_alloc: Cleanup for __del_page_from_free_list()
Date: Wed,  1 Oct 2025 04:38:08 +0000
Message-ID: <20251001043809.11019-1-jinji.z.zhong@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <F1AB428D-73B3-4E40-939C-2A7BAEA1E73A@nvidia.com>
References: <F1AB428D-73B3-4E40-939C-2A7BAEA1E73A@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CCFE6100010
X-Rspamd-Server: rspam05
X-Stat-Signature: ch44oud7aykj4pej6pscertfpstn3nhb
X-Rspam-User: 
X-HE-Tag: 1759293495-88607
X-HE-Meta: U2FsdGVkX18RoH9YPvsBhkcpe4zqycViYA4sn0U/ErzJW0A2D3+sVMFxVcq2c3GX+VWJXmXOn0h4Uix2M1J3dx+qutBN36BOcw2+TMwCt0yiRjrzKdXialWyPe1NU02+n+kPgtnaWVaIu+haYICFpizGVFguV7Jid8jClKjjjF466ecZDfi0bIDbFu3QMzHn9ZMiSscRFlr6JxSgfq+11iK/2NM2v0N6ONzYMhOcnbknORBm3YbB/K3TWC8zs3tBEthkaX6Lh9+/ryA3TxJLecD7Sx1XI3znKopMh29yzrZSlH8aThKnF5eEuBXPQPLo7HPxO/0SaBQfPkExdvuTXTyHFa+WOVK7bJWiKi/6nwhgTqHgI/0ZfMchspswPubGbCSVdt1EeGvUsaJFz8NRKtfmBl0CWkt1KHQsdi6KZNv8wsYuGcSv3xdrrGmjOC/wmU12YQwwLQNC+Hpsz1Wtr5oOUtlMceBkjT9CEYI8IHu5XDWVu1iv2NSKcV1KYvxQLk3L5vFNhC+sLleleJIKkknUOxpvtSadaXZJqW1ySH2/WvGwmVPDHT3499yjylCZ6cdUfrse/0T0SVwE+j77b+kO4fNBUj0SvD81VihqTULI4DXxDPvJA9jY0xr02QG2wd1j+N9ksp4WbrELvRk8LaCSzeAWGMDC4XYM+yWn08jrK4h6C93LIbQEh7smvMxyQGXcS8Z/dWjaoOKuFDizvAklfua8pMj7S+/RJf9Bp6hWmyDwdUW0Os4B/1pvI9/FXHOLmuegX1otW2DuxnZGlskqI8ZKShEOOHhEYCD8JIIrrfSfhX9oCCfdOq3SfNqLKU70Y7z4lJZLfov4IPHjUcJrWykoxKtql0Pr9NZdQpmXWEoAo7Etk4uCYPQXlnx2k/v7tDQSPSGMbEMdjb22alOsNog2V0hnZGzOXBo8K/n/w3bKEa0ZpeXweBjQbPdvvZIWqSC0ph90MWqm2y3
 4aXZp1Sd
 QmifpzmooeqBE5DLcvqrzLZLrtJAhEgjmYsD2Y93DWS9jef6Xo1RQ/0uTsNtx2Onej4cMl4OfxiDAR3TCHNtnmQM2TLFW/Sin/MpoHpjLS/9+9E6NFt4SksCqQVSt2fKQc/MiOr+SJSAAXeL/Jz5ZGZGYn4ka3hGJfJc4KyjFCYpGLdEgbhzKn+oWsU6hyXZbf//zlNiBp6Z4/KVAmpK0vFiIYzTT0PRHI9wUiKstr6wZs7+PNVtYYOdX1++vTaoMDRUhT0JR1w2IlVXNn5Sywcgrjouql3yK6ECYkpbLwwR1vNMPvpbnhiiRXrBiLeeq4PYYTKau0/bJzyLmrnPXE4xSMcr3c2JLswQkPtPEDpFVZ8EPwUbi2KhqlpFm1O6zc4orGvS75kzeqlHxLJX6XNxVrsVDHs2QV1GfP+Coj93XQnTeZcikNGdgUCkuWMnT+LJlnzgSDpCY9YYwYkpXE5JPhblGgEkQTAUQjUe55kokiYfskHGcLyQe/HICMD/ck3Msk3axKvk8WCvxABeGRLKHi6wQ4WHdqOHdMKmBnCy2o9yAqUztXlZzBQSTG0J6InP3XmqvEqSrZKPoH+H9oWpFjgextd1yXcfrE4rij4ougLmT3Lz23tuTWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On 30 Sep 2025, at 9:55, Vlastimil Babka wrote:

> >On 9/25/25 10:50, zhongjinji wrote:
> >> It is unnecessary to set page->private in __del_page_from_free_list().
> >>
> >> If the page is about to be allocated, page->private will be cleared by
> >> post_alloc_hook() before the page is handed out. If the page is expanded
> >> or merged, page->private will be reset by set_buddy_order, and no one
> >> will retrieve the page's buddy_order without the PageBuddy flag being set.
> >> If the page is isolated, it will also reset page->private when it
> >> succeeds.
> >
> >Seems correct.

> This means high order free pages will have head[2N].private set to a non-zero
> value, where head[N*2].private is 1, head[N*(2^2)].private is 2, ...
> head[N*(2^M)].private is M and head[0].private is the actual free page order.
> If such a high order free page is used as high order folio, it should be fine.
> But if user allocates a non-compound high order page and uses split_page()
> to get a list of order-0 pages from this high order page, some pages will
> have non zero private. I wonder if these users are prepared for that.

Having non-empty page->private in tail pages of non-compound high-order
pages is not an issue, as pages from the pcp lists never guarantee their
initial state. If ensuring empty page->private for tail pages is required,
we should handle this in prep_new_page(), similar to the approach taken in
prep_compound_page().

> For example, kernel/events/ring_buffer.c does it. In its comment, it says
> “set its first page's private to this order; !PagePrivate(page) means it's
> just a normal page.”
> (see https://elixir.bootlin.com/linux/v6.17/source/kernel/events/ring_buffer.c#L634)

PagePrivate is a flag in page->flags that indicates page->private is
already in use. While PageBuddy serves a similar purpose, it additionally
signifies that the page is part of the buddy system.

> I wonder if non zero page->private would cause any issue there.

> Maybe split_page() should set all page->private to 0.

> Let me know if I get anything wrong.

> >
> >> Since __del_page_from_free_list() is a hot path in the kernel, it would be
> >> better to remove the unnecessary set_page_private().
> >>
> >> Signed-off-by: zhongjinji <zhongjinji@honor.com>
> >
> >Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> >
> >> ---
> >>  mm/page_alloc.c | 1 -
> >>  1 file changed, 1 deletion(-)
> >>
> >> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >> index d1d037f97c5f..1999eb7e7c14 100644
> >> --- a/mm/page_alloc.c
> >> +++ b/mm/page_alloc.c
> >> @@ -868,7 +868,6 @@ static inline void __del_page_from_free_list(struct page *page, struct zone *zon
> >>
> >>  	list_del(&page->buddy_list);
> >>  	__ClearPageBuddy(page);
> >> -	set_page_private(page, 0);
> >>  	zone->free_area[order].nr_free--;
> >>
> >>  	if (order >= pageblock_order && !is_migrate_isolate(migratetype))


> Best Regards,
> Yan, Zi


