Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00B5BC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:41:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0CF16B00EB; Tue, 28 Jul 2026 20:41:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E97986B00EC; Tue, 28 Jul 2026 20:41:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D688C6B00ED; Tue, 28 Jul 2026 20:41:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A39136B00EB
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:41:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 29002804F0
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:41:56 +0000 (UTC)
X-FDA: 85039961832.29.0B782FE
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf18.hostedemail.com (Postfix) with ESMTP id 469671C000B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:41:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GARkdxsL;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j9nli9m4Bc7pFK4IHJyjckwpxfCqeOd7xuoXeRuq6Jk=;
	b=LHbbWMd2HPb+o1BDgyrd3xrMRR4M1nshQNE6PCv/d41Dzqd+HkEwWK8KYW60svvnjddMGe
	Hl9qBcVaXtRZQj1Jg6iP10y1lzQm8A4l6XahDPEZOpTOg8vgBvtL7yRdhAijNloVFK3EoL
	lyazAPYdk0YsRuU/TLrgZh+pVBkuNPA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GARkdxsL;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285714;
	b=fyTkQWlaH/E7aHbdyUW0OnWmJtSidqnjFm1YIMHhUuwMEnHJbz3jF4qUnCsjoZHiPcbqUe
	54LJTP0GU0Yz4KqHkypZQ48kz7I4cvbygek1u3nM73CJI9+w8a0y2g+TVaQlY5IKjDWpMM
	wEjmDezCN2nexZn+yyo030DNDvhKc7k=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8f23e851626so2748886d6.3
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 17:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785285713; x=1785890513; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=j9nli9m4Bc7pFK4IHJyjckwpxfCqeOd7xuoXeRuq6Jk=;
        b=GARkdxsLoovZvhmfNTxSknnAFMQ2SQ2Qa/VfIFgvQoNfvb2p1AIxONqBYTiamAHDeI
         KOthYnANnEFN4H7T61y137c2lqr2M8tcXoLcCX6Kx3ZRIWWxtdcbXPX3Qmew+BoNlNms
         YMkIVVHBOsTatSHpVD3NPoXR4hb+vt7T2Xlfzjy/4gwKo7fj98ibvRg/M3OtjmqObw1Y
         yKbjI5G4QCKiAijs+PTQkuSSZHhptUAOWj6xXfK20y/dZe9pFUoT8nMn1Jshe3z7aNFM
         js30FCldUDq7CD4fsnb5orfBRyL7p00WGJxAVV9KbMqVgPT3nMihsvst86ZKAEG7s7hj
         f3nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785285713; x=1785890513;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j9nli9m4Bc7pFK4IHJyjckwpxfCqeOd7xuoXeRuq6Jk=;
        b=H/LsMez6DNWrH/NwbZKYJrw2rgeCw2iSmL3fIdGPKqSgC+AAQANEY4ryDbKxVgSfgu
         +wdJGQ0KkDJ6R0or9PbsgUNx9D9gwmkAYAAZQ+12epY0WFQfyiY//LEh0fFzCLHAdem4
         /gskhYr1Kf0x8hUTuM/oBQI+rSp/W+F4kdsABv0OXaLfWR4r5/TVfXxMck4QRlDCvsi3
         CWRAYKkZD6W4q2l6gDnHaYBnEGRLjw/FrqDWJkQ+RXXfTKxq3BUxyRqruIUOTF580Jv6
         6T2UA15VNAJ7Vt9RlavjRfHUauhdwc7tqdMl1CNmqiQNGpmSFPp+ox0hsH3cWaMADlkD
         essQ==
X-Forwarded-Encrypted: i=1; AHgh+RrrAGW5q6Wu+hW8EsDawweyCjEcphABPp/mljuOBkIuBbzZtgrYxEEY6k/UERZA5DlordfMdYtYtw==@kvack.org
X-Gm-Message-State: AOJu0YxOiX4vktQTN+L4Tv1uhaolNcEhFsnDrdKCtRpXnWW15BEzzgRX
	YUq1psgmZqg3F7glfnxEiV+deffi2qah8HQltHdXm4cvret4biaYcAd54zwbVYxDHCg=
X-Gm-Gg: AR+sD13renVAUrDRfWEYyWozaFaAb6uHyAiw6d2zYGwxYGbwQ5BZebF4fjGoLfx+1zX
	RcJ4kVkpajAfe0vOUVUxQCFKEkbQAbadL13fNGeFBYTn7OtRJTasIFCiTZ42X5O+uSwDl9o6pfE
	IgwJkRv4QKZZxFI4fQJU3Unq4VuGOFm5/gQVJl6gPAX02BWz7uyRbmyWsfTDpTURnRkbZ6dS0BT
	72x0oQRmrGGKPFMgmYouRZrF1hcfYZyG1qLqNqx7oku8BKVIWkgmzk4AOTieFufhm/oAQ3cDF9n
	NhN6prF/sTfeGAh6TfM21Y093Rc3T/ANynGTr4wLrytbq1qAfEP4MuLkT7YKLjjIjD7ECp1aNTc
	ULj1Ogf/J5AiJe9CET8xu3/jsMLO46B8uRVe3WCaJQAXxpnKTLl97y5mipcY/ltgop/yxqy1Zk2
	rG6dPkQ5I9G5dFmV1xvl/yi0EOL46g3gN/goVh9djgJRgFyMXMTWWp5kHhXO25fqkzaTS/3DpNy
	mLYAOGtT74byzEZ5V3OzO3XJXf0CwWZe6A8ne8h0l3/
X-Received: by 2002:a05:6214:428e:b0:8dc:40bc:b593 with SMTP id 6a1803df08f44-90816fa80edmr57286176d6.10.1785285713351;
        Tue, 28 Jul 2026 17:41:53 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9081dd6c599sm11500206d6.34.2026.07.28.17.41.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 17:41:53 -0700 (PDT)
Date: Tue, 28 Jul 2026 20:41:50 -0400
From: Gregory Price <gourry@gourry.net>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <christian@brauner.io>, Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v7 05/13] hugetlb: Move poison to pages before clearing
 hugetlb page type
Message-ID: <amlMOd_eTbqgtS22@gourry-fedora-PF4VCD3F>
References: <20260728204409.3396238-1-willy@infradead.org>
 <20260728204409.3396238-6-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728204409.3396238-6-willy@infradead.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 469671C000B
X-Rspam-User: 
X-Stat-Signature: 4dky3ded4hgqbxb7f5mkzu64wma5yqt8
X-HE-Tag: 1785285714-497763
X-HE-Meta: U2FsdGVkX1/LNhbu/Y9C6OmxwWN9jTezxaGEQ1L9NERgG/X3np2h66CyqnuZf2qO5dYsYQlTzdDpALJgZVlfDy4PU1MEqGS5nIBXPNpxhAhk9bMWyN2+6liGX9weHqPXGJWLJoAUkHYAzI/5un9QfuGP9ntGVHa9F+wTl6g0mKfj7rATK12dUdSuWpPftAwEHUK/0+xaxxzQXW/74cIcxboL/27M9hWjcsBoo18EBTTzG1UIYSBW0ZY5N0SN+vx4JndneS+xVSPMfzuUZE5C+87l8gR7KGFd5a+rXmkikBhnKuVS8KqDD2QvT/z/iW1CQzNv5VkwXL6qfJwH6Ls/6adW4D8JJnL9BHkHwV+5VSJAm04lUfEisNH80akXIHTFi8XzS5FCQWNxYgCJhjgA5uDcErbXsI/95BMSFPqaTqJpsVhzbCqp/Bcj5VYh8oSej/DjZZ2Yw9Q2TCjsnM/oke1vTBR9zI51dZNQ4LBfomCtqSKMEgYkIAQK8CSPgNQWV9luktlt6mzf6oeI9eW3Qc5YIk0P0aWXtmyFJYrUtc8CMAos9xfyuKf8FAaHusKNBio1lOD64yj2w6iUNnptpH6VE+BvWHUzDBnxbOswsNBtfN09IAPaaZvPmEz/D9YN56cKht+SdCkIFx6Z98KMMV/XZrVGv1Yt7saPWZyXs8mlOekNFdpTiGEIX3/VRKDjELoHh22CCZeDKReey89NzfSgAU7bWPpYLaKpMRCsW2viqG6x5N1TIZrjsMUIrWmfym1oGUHVzCb8RU5hCa4ILg+outq9BgPtbRE5e3f56ziemdcIko/8GZlBaxAIkQ9zp9JPLxoUSfWeBbn8Nes4LXZEDVNEMYnyO5tp6XX6esbE/xlryj938xsrMunNJJpEiLZ5Pg07M2sHgG6k7aPntmdfqc8QD/+5+K3f+ddob6kKh1jx/6THRKHIlGj6KrIdsc2aeCk2s3WyLSUVRFD
 vJG1lW1c
 XPPTppMqGItY1q/df8KXnBILVhpLb3B/CDzG0FpwsWtXnycv4OkhYNLKjWfVV2+H3hFIHdj1yWom/UaGuULu33Jf4vjfFzhz2BRqaWaRK5dUsoyEaGkGIZh2AUBxO6VI98Vhj1doUXtYu62FrO14FAxWWVdZn2pnJo33DCH+W6brDyT8zSXe/pad+XF/AWJLk6j0tjaMXddS/cW/oyLJwEaJfNYFaZgzKCg8895yQKXfyeamvPCFmNLx2D/1/YtD4Uvd9miUmRW3wq75eCSwa4opAEDZA1cL86+ZwAEZSZiq2TG2oXo5FFhpo6uS1uU/PRNY2bOHdBENs58U1CFNSNukr0nHOHnsYMVvYYZAaq8kDloSnGMZVsNHtochlVz8YPzdY4Qtf3q5HtUm3PmyVJ91xOIWYvUxZcc8QfnvqM0G6GOFPGRVJxkrlCdIGFYIt8owSMtKvvsy5dHZ54e77IPOBnCFn6VQ9h9nRz7zRqIU2Grtcbnld7SPIKJR10OfQxW+F9FuNjPP7GwE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 09:43:57PM +0100, Matthew Wilcox (Oracle) wrote:
> For is_page_hwpoison() to be reliable, we need to set the hwpoison
> flag on each page before clearing the hugetlb flag.  Introduce
> folio_clear_hugetlb() to make this easier.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>


