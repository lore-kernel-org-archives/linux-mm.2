Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB4F6C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 18:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D9AC6B0093; Mon, 10 Aug 2026 14:23:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98BB16B0095; Mon, 10 Aug 2026 14:23:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82C3D6B0096; Mon, 10 Aug 2026 14:23:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49A746B0093
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:23:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C75EC80213
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:23:33 +0000 (UTC)
X-FDA: 85086182706.26.3B1327D
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf09.hostedemail.com (Postfix) with ESMTP id AA794140010
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:23:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RJbBTrix;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786386211;
	b=KKWmGC3wPYXmEi3gLCuH6uTcEZL/I3Ohl3wFllGR8a7Ix2VQowPJHeX3Yx1rJ6nKzE0QS7
	T9fopp8imwrzKqeE1IAlS+tiEfFivcFid4Oww/V8FfhCmfPbGw94pERf+rwcjPcT+fKbQK
	gr7tHCL/YV8sMsOeACdDmWU8Osk96yw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RJbBTrix;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786386211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=78FhXUtIMPLEMb/0q40kgGbueWBdVpdNCXluWOZSpp4=;
	b=aghceg55L8uDlOdbv3g+o2zriGeMsKNFHGBI2E3QDp7IKzhi0iHw0LFtF7TosUMGhuI+Fx
	mpiBJDDr5JICIVRKtrvRLqiVUetBgauskUxujg5wjgiTzBH+8TcfXDBTJrGPNNa0yLoncM
	ncig9GtyAHH1cvtGQsJOLJD5kd+w8MQ=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-39266382df6so2386897a91.3
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786386210; x=1786991010; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=78FhXUtIMPLEMb/0q40kgGbueWBdVpdNCXluWOZSpp4=;
        b=RJbBTrixlFQZmB07gwRdmHYlYh7AZsRZoGulhPFDFdAX/2Vuak8Hxx10xs+aMCPVfb
         A4V4RPXLw+NB7S3nGpuZ+SJVWTdkpBAa+bIVh99fJPIwihx/HJi0pWHHLMAFA5iM23BI
         TXQ4/r7dCjBW2rR1aFzsR6PKDcVu0foNxZwMD2iF0VPqmHbH/05kGLLcxE3IoLNsbj5J
         Eyd8hSsjKuDTyFak+pt35ksMB7Qu9FYW1tuu22v5/mdyt8DRQ8mTMYmUhg4HJHQ+eQ4n
         nfpqqAmWkseNRT9y1EEUCzVxxtXj/jxat6CQZLp6O5sPRtp+l+lvv/plrJfAyFCZEoXd
         WRDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786386210; x=1786991010;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=78FhXUtIMPLEMb/0q40kgGbueWBdVpdNCXluWOZSpp4=;
        b=Osg4UXg1RuVYZqTGWaD3BFwtNjSxPVILpr269vIBzWEOpjyCICAeeTcxA3PWKUnkaM
         Xusg2+K49oUvbqXvyPBqlemouWb/sLLuWfqeMWve8fAr0Os/RE1kqrj7HPhsroPlzGwh
         Xn3IWzYhq/12B1JMAvFe4af4znZno5d8Vh8KfajJESlXQ6MrQPnB7+0fVE9HyQNgBQM4
         HlVizcLV8gJZLl+prsyM/xHhEK/Up4VQaL4bEi656uB90urRbvCEjBwEZVwNYQkjVEoN
         8TnnHhTJh6vRGIhdeMPnZAN2IXrzDCCjOXRp32k5KGi4Ns//h5EYBC/r3DIj+MXXcoGU
         vXCA==
X-Forwarded-Encrypted: i=1; AHgh+Rqb6EkyK6hvUpihJYzWEh/3izAQahfcp9yo5wZ0XxzrrcXdNYfn8qM89qpDkuUYx9o6wxkqZM5S5g==@kvack.org
X-Gm-Message-State: AOJu0YxNMIw2NSxr/t7YrOt5qxb/pJPLkHN5uHdQTCFJazRqsFF+Kf9I
	aU6S+dyiewrrusCbYgMgQE38v5R9sAu1le+v8f7mz8eE9WS0Hu3wAMPa
X-Gm-Gg: AR+sD12UDb0aZfTNi0xjOalFFtghn656xNN5EBUYEi9hmjLVQan64gCWQlO3tXURa8U
	wJcc3l60O0/dKoaVG6UNtnz4heFKx1g+qqtIpwo/cPjXK8r4KFDTmNj8lliR5mNVgyDDtaSE7KD
	I6oEkfjYRajww9sknnsmmWeDZTxAqd1t+jw2LEES5DKn0YvLimSqcG2VkcQ61QgZa4/6shHCejs
	RTOuNJ5l6IB+xhW92h/bxnYsNMZKYMtVwKd1pN9UwDOEuSZQMTLIBO+mPuD7lb7NvVNBVo+gGmo
	tz4Z09fQDx4j3Xdc6XP2O7chzv6wveJvpcZ7z1SpY0AH30vaChuTSntzTa8TZ4o861gz4iIhkCZ
	qejLPUEfl2cwuU/c+8Fovl9CzB0JyYwllYsDGKlj35QLnHrWbebMOxzmMdvnxlB9Slem70An47W
	zTSJS2HUFTiuSyZeysDFhodb74KM1K2exV41Ck2CBiZ3NrCyLQ6mG2uRnKv2g2PTgWaZXtqjhAX
	+1NsBMHUPm72enyUP27a8vx
X-Received: by 2002:a17:90b:53c5:b0:381:bc4c:da5b with SMTP id 98e67ed59e1d1-3903c61098cmr48757843a91.18.1786386210377;
        Mon, 10 Aug 2026 11:23:30 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-390b35ca2b7sm5822836a91.4.2026.08.10.11.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 11:23:29 -0700 (PDT)
Date: Tue, 11 Aug 2026 02:23:21 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Jianyue Wu <wujianyue000@gmail.com>, her0gyugyu@gmail.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] mm, swap: only allow swapped-out slots into the
 swap cache
Message-ID: <anoMx72kG4qVzWrQ@KASONG-MC4>
References: <20260809144559.2104856-1-youngjun.park@lge.com>
 <20260809144559.2104856-3-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260809144559.2104856-3-youngjun.park@lge.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AA794140010
X-Stat-Signature: ue7zfhqpwj9gza8di13mrjisf8m7syr7
X-Rspam-User: 
X-HE-Tag: 1786386211-903288
X-HE-Meta: U2FsdGVkX19jpZX504AzfFU4jWzb7wNkF7uH1u9MlufkbyTitq7jl7FDmUUeNdjNr/kMJsh5PRmTb9w4j2EAHA36xFmI2guPVEKT8tXGqhsJ5MC5FOtKPrD3dXXGOZ3u9r/icqp3XZe/1IIE1JqkgeGhwj+H5zyhy025vfpdlz6gRCX+dQ/Y4g4FpCPi3aCEeeV9wJW1oAMdvbmr7YRQfaXKA9arbBZJfmbAyTPQDyPg8ptxDfafFf+o9agQH3lawpxYM9X41pIIBCBNQ2ufuZDBFXuhyD2stbsaBPqx9yxJmcwXJzTNBfJ19kGfyTsVAHhdoSQi5lfwR/4VCtyDTXXjYjeIm9qWalM4bdoVvp+rwXRncRzHinqtyBg+uLdL6WoqDAKiBkZpCJhe2Bt46aNNMLxcKpcBctKVR4x0pu5ALSSOB9Fi0mhzxk7J0dyqdZUIvgQj4fJr4QOZOw83YaPpyqeoFvetG4sw+q4FqOAqqOcErucc0tLJQIWoWUKJxzYTOE3x10WezLWdyP0PD5xNlhsB963bYk8Fs3hqmn0s85TbmxzroJnjyn4EFtA4UqESSHK9Ag1aGaygNaItOWxZ1CLAO1ntuNQsdJX+8R8KXTXFxYkndNEea2dyqwADR2+j/JCs8zVvXODneNHT8lgv+1p7iAMfAJWxJl8GtCP5ssoO0Y0JdLJbiPJajmGLCLcPOQxr9oJ6vK/0DywhKRyaBPPAV7Epn7NA//Je86hNlVom9maQZq+GhEH0GHY+d9hglHgNk4g0oZ+6uYbDhDeH6Me3svZYTUOfggn9ckbToZF84RfeFSdduqex4cT1rcuubKgke849PiuJgJey8WSd09WDk0MB3RtXcbY6uFWSoXCjxPjMsdKDkpO/lP0O/ksQzdCRrhFAb7JqbbyzJkHuRNLfK8gTIOZM+L+FIcNemOzdtCdRJf0eOCJkREkySfSByEjIbgL27SoKMB6
 VR6hFsOs
 x9SR+BYI9kMgF83t/K2dWCZaAUocaQ0YlxjNriOdsyo7HAVNDC2O+Mdt+RvtK5exjcTr6g+RbWFkIxrZ415Ba7qIGYAHn6h6SwLFXgX5AL/0xbmlEQ46IYQkhGZOSF1mGrtZ3VRqZqTGFSGXJT5fEc1S71dF4gs0yJbSOfmBbpYBE5lmmxyq3nRqaECvAKhmPm+kv96F7M5DRkmS5Ov+CSxDrxjaS82MIpI0Fi4pqJuXS2gZcHVAX2zFaoSt3SvmeKd7HA4XNJJoY4odNKwHKDCxUjbJzwM+vNLStFwwj0bD/Ckrxd+RCp1tZx362+5WmNkvsR7vPtJEDf50LaGhMl1BETebCBk5AdCJ8yRSTzSEjDeAUFmbwGFOIunfXQ+H82bOTBzOdJN7RQous1Mso5Hhlseql7U0BuFkkHWgfpYd2T/W8el9bxkIIvduNviNqNyAsVP9RFhJtbuSls+kGbAt9KATR4r9yT2zG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 09, 2026 at 11:45:57PM +0800, Youngjun Park wrote:
> __swap_cache_add_check() turns away folio entries and slots with no count
> and lets everything else in.  That is safe only when the caller owns the
> slot.  Cluster readahead owns nothing, it walks a raw page_cluster sized
> window of offsets around the faulting entry, so it can land on any slot.
> 
> A bad slot gets in.  The check reads the count with __swp_tb_get_count(),
> which shifts the count bits out without looking at the type, and
> SWP_TB_BAD has all of them set, so the slot reads as SWP_TB_COUNT_MAX.
> Readahead then allocates a folio and reads the offset off the device for a
> slot nothing will ever swap in, and the folio entry that replaces it drops
> the bad marker.
> 
> Readahead used to be guarded by swap_entry_swapped(), which goes through
> swp_tb_get_count() and gets -EINVAL for a bad slot.  That call went away
> when the swap cache checks moved into __swap_cache_add_check(), and the
> raw accessor there does not do the same type test.
> 
> Require a shadow entry instead.  A slot dropped from the swap cache always
> gets one, empty if there is no workingset value.  The type test runs first,
> so the count is only read off a countable entry, and the check as a whole
> runs before the folio allocation in __swap_cache_alloc().
> 
> Reproduced with a badpages list written into the swap header by hand.
> Readahead took over four bad slots before this patch and none after.  It
> needs a crafted header, so a normal setup will not hit it.
> 
> Fixes: e1e6750df3b4 ("mm, swap: add support for stable large allocation in swap cache directly")
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  mm/swap_state.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)

Thanks!

Acked-by: Kairui Song <kasong@tencent.com>

We need this fix for 7.2 I think.

