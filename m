Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D403EB48EC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 09:24:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46CF06B0089; Thu, 12 Feb 2026 04:24:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 417516B008A; Thu, 12 Feb 2026 04:24:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FCEE6B008C; Thu, 12 Feb 2026 04:24:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 226D16B0089
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 04:24:38 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 81B0E140749
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:24:37 +0000 (UTC)
X-FDA: 84435269394.25.BD35E5A
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id A0F0AC0007
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:24:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Npp24l8w;
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770888275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IHfM322lH/LyDcBMVSzA/ceWo3O9i3yzGij+OBaFHZY=;
	b=AOXVFbSPsuBOyKOQsKOurpR0ZnV3wschsgtGmpPKSJbbbA0t04Nk7G/ewq/dJDtrCEFcQ+
	8M6hBjrXRClawzHZl++xRLmgyZF0cNoKaGQwmyJaqOzhE9+MD9JmXofy5C7Lv47n9KzF78
	Jes8umDu95otXgQF6YgRhD1yX+rbUQY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Npp24l8w;
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770888275; a=rsa-sha256;
	cv=none;
	b=gYBYynOTmAqtjXNRIFt/lxb3P4vvM0+K11/j62UQZu+nZPCK2lzfBBedDnydgsLrRYXpUP
	i1XmTdEGGNJrLdVzwel5jhZnPLMSeFX3jGjN0flTgJ55atkYwMajPDIEmn6VnsU7QFD53n
	Y/yPFsjbQoE1En5L96hNyACrzwKdIpE=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8220bd582ddso1789068b3a.2
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:24:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1770888274; x=1771493074; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IHfM322lH/LyDcBMVSzA/ceWo3O9i3yzGij+OBaFHZY=;
        b=Npp24l8w7RDFW+5gajnx8t5GbmJXiiatkKk/X1otYI4HfolF8CSZxEbHgVdxPxSVFJ
         LRl+rmyxcyEsw7aokuEVmbvKGKVIZZIrgzXOKjselR9mTdy81y7jHfFee66pa+lj9SrB
         vbeoueeZLbwQdhqsBaFttg+LqIrWe2vyFpIa0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770888274; x=1771493074;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IHfM322lH/LyDcBMVSzA/ceWo3O9i3yzGij+OBaFHZY=;
        b=u3T+R99m4nQ9X84ZcL6ec7FGqyTjDJee/wqxGHqbTAR1UZ5mRBDZUKbqSqpIzHWJWt
         Kc65F/Odv1c16yYLrOqUX7dWritKaOkyczE0x3qADpT7tscWYv+Bg04kvW31Aj9gRpyd
         bvFnkpvwobdea8QP341M0Qui4tOEWh8B4xOcHcuF5OglHem1YmZc9cha0ih5N0VKPSPG
         IYC2g8Dxw+rji5U2au+whPlhnDkzc3nXpOF52zjMn6L96QoCq6C42xCVPOfWkl8ue/xp
         JiIYy1/SjKpirT6tqroVD+/LwQ6v5oDegD7rvPMCdpENolGFzvOryIXGDbliXDJjboP+
         J6sw==
X-Forwarded-Encrypted: i=1; AJvYcCV02aEZv0duVbfzBooKHHOoio4csbI3aKJkSocGjPeAEPdx/CBl7TlzDe26lHsiY2vGkLsXeLeepQ==@kvack.org
X-Gm-Message-State: AOJu0YyAS1x2MEt/6mXdympP1uJZ4jUOh87/OGv2J+2mLIDqL/SHZYny
	6hGa654nmiw2mz4U2BENN4cmVCuigN6LVgqtT0V2fxfLOtL8btv2gE2dp6fLYYsXY77KEMAXQHb
	CT60=
X-Gm-Gg: AZuq6aJyS1BmTAoudWPphN65HVHxQiplFNR8xM/RLlOj13q0IEsH7cOZsC06CKRq75N
	PoowAkuKNqZlQiA/dOUoYjeSz9Z7EsQBSLvYRXiT14m4fzZsF7pGhYqrombNYzcXauhXGI1TPjr
	t6DenCRJU/ZLTwcD5ciW2XyVprP1I7w8o3UMn8TGki0Mwr7gHU8BBjLQPdGVY26ek+FbabrXH+t
	pnsqn9C4U4Wyvm1lC/b+G34f9cx3YqRQsZlc5B9p0HhqlHqZonTZWAh2eXReFVzK+3g9LJA8A70
	isk0HN9ad+S+qPEtrnlPRUlPC8OlC7K71MGcb5dLgW7PZ+uyt2KK3Fbmc+p5bYEjxFu3h+kKtjn
	F/zyJ2FuRvoWgOon7zbTgtX6rXWtR9C+grn3xYPasOA9S4Ez/RGNz/LbWhSVj3uVq1K5schXdOY
	FBFLUGs5MvGmDLrU9SzJ7x8ypnQKQt6mXy3bN2gT9OWe8THr57ge51dHeaAZqgoQ==
X-Received: by 2002:a05:6a00:4c0e:b0:821:81aa:add with SMTP id d2e1a72fcca58-824b2ec2b02mr1389609b3a.31.1770888274530;
        Thu, 12 Feb 2026 01:24:34 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:725d:f34:4b56:7316])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8249e3bd5cbsm4588352b3a.20.2026.02.12.01.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 01:24:34 -0800 (PST)
Date: Thu, 12 Feb 2026 18:24:30 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] mm: khugepaged: make scan loops suspend aware
Message-ID: <doodb7ywppxukrqgoyq54ulpytvejvkmamr44cwy6xjmhdcllm@zn5iaos2aivj>
References: <20260211031512.261127-1-senozhatsky@chromium.org>
 <104bc764-5a20-4ac2-95a8-b31f41255766@kernel.org>
 <jftqdosilzfkd4ku6pjuevkvuwmhlqtua62jwsmmgdfcseitb4@gopt2xzqhyrk>
 <3571cf8b-9fb3-41b2-a402-a8537ee2c399@kernel.org>
 <r6m6vdhbqada6i3gugtnj3lytjrkyiretihwebwci423vwslcr@ysrgdqvvno6b>
 <16ce9ce2-8081-482c-a6ea-0932ebd081f1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16ce9ce2-8081-482c-a6ea-0932ebd081f1@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A0F0AC0007
X-Stat-Signature: pe3qqohsp6kaxtu657ggio3aaeadtygb
X-Rspam-User: 
X-HE-Tag: 1770888275-733948
X-HE-Meta: U2FsdGVkX18BiIn4lzmfw8J6UtBXlVrVURupPP1V2fMPbV5vuA7XMQrE3xanXVDTHqXiE2vzH+2TsGrBn0E87FdCQPWtkFmqBZ2fnRre99Td74zMg6qSeTwGtN/kPagHmo81p4gH/FfnScy9RDfjdw72N36pglEUvvauAo5Pvc3jnPxfOdd+DezODTxZWrd0D8td4KA1QrYoreu0iOJ6a7ORapdtt69jZsCX3jnJG8D1bgoHVbyBxAkK4FOm6akmLE0p9YIagJ/wJRUSK0HzY+Po7LmWOQV/3RneQhL+BNKcRdVnHD5RsB9nYxRlULlEk36cPZjF1JvrPXfZl9OdGL87uVHbxOXypn5XqP2Ho+OdY6xzxNCi444jRzHPw5CqTT2ukiyiV1AdwZZVawQ8qtpoM28Z1iJmdIZycpxy5t6g3rml2iFS/UoTN2il1RgxYDPIgF0hHsrWHFNrjOXr6vda9Q5Bnl3h2GFnupcXErd7d0mLybdgwsS6lyJ7azZyZDfzcKZiiliDavoP+u/hRS0QKZN5v/M53xGgg/PxRTtp6aqh7oJqsvUentuZjPZkcgnYHZn4nAiLx6HId8NXHBobmw7QFZLnjhEuxVotBiMWj6rsAclNqfG5thlKiyJ2saQXYFSt+BLU0MnsVt/mxlPnwqQ4rXGopv0T+wzpzqIcRef23iu8GQKcY1Mbp0k2ytjwDjkXswncLnNJ817uMWdYgytcBVsiWabZxJIMSry39FdfHWKDsr1g56Omj42q/3Tv8pgCbxHks/iS9wMQi4vdDLSMVhiULAOTZszmXRLvLa2E55khK8xRdHRxCa4HOT9+3tOqKbTCfo4DngxTtERxRfDElx4VYI5TeCaXRdBr9eCwM6Z9yhvBvxQhXSfVbnfNVxzJy/xWuxdJZCPdv0kKSQiHjT50dkrJE5b2lvzN+miJbueDnhGoX1j2L7igqqC5cH76O8LvO4Z60ld
 KJqsLtJF
 fXDkpImbNpzvKMpianwvqopbyqkzAbDk/EqtBAkvE0HXL+8xzzjcTegwUOzIOPs97cBVn5BVrXh+f3lrPjKZiTgrI49db9Eo1AkULfJU0CHduZ6oYvy9RMJ9lpVKgeZFAd5JOlDI9hfd25CVscfkPrS/EpIIuXyt47eZ0453Tw/So4OQB/qbIPn1bsdQrZW5TmxNqrFajs7QayDG4sbjE0hfVKkHo87hRnMqLFOl2LbakQTXD0zFCvu1zN58s4GtQE9ChjucC8xS3bgZRSWxixvzorjv500XmoPiP4zN8uGFssXEnuyNUJN/PUvTYzHrR4ux9Qybml9uBLDIu/WlnXsOSb/wNw4JrlyR0EssPFUAJGnM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/02/12 10:10), David Hildenbrand (Arm) wrote:
> > Interesting, so 1dfb059b9438633 and 878aee7d6b5504e fixed real
> > problems "khugepaged can sometimes cause suspend to fail", but
> > I don't see what exactly b39ca208403c8f2 fixed.  Sounds more
> > like an "optimization"?
> 
> Yes, a cleanup. I wonder if it caused harm.

6.6 stable doesn't have b39ca208403c8f2 - khugepaged_do_scan() checks
both kthread_should_stop() and try_to_freeze().

