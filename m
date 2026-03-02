Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EF4CEB3625
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 17:18:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 982806B0089; Mon,  2 Mar 2026 12:18:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 919386B008A; Mon,  2 Mar 2026 12:18:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 812396B0092; Mon,  2 Mar 2026 12:18:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 70FA06B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:18:50 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 45D4C160242
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:18:50 +0000 (UTC)
X-FDA: 84501782820.08.0F72CBC
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf25.hostedemail.com (Postfix) with ESMTP id 76143A0013
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:18:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=s2lsXKO2;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.45 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772471928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9jiAd70OQeRHoiPXbEJ51axrqw+4XgbTYUr4MIjZbMw=;
	b=jXaIIpr6ezAYl5CA+g4WlGgnHDtWkvnv7qsiahQfbyiXBOrsw2xTXYrbdUrbp6bwSoXc2D
	HZDPlRDC/ypjfL5NsuYXwmQx9RAefkTqZB9Nol1+FnzgE1d2r7i4czb4VkxesvnB4YVWca
	dOebxeyqVjjfA2fvVS9bnjQz2EZktyI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=s2lsXKO2;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.45 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772471928; a=rsa-sha256;
	cv=none;
	b=DXZ66gw4jzuDfoMGtQDi2UEce7x70KdMvWQ2YwExBEkYoV+JDgqqnFAEsVZGrIREox8iND
	SyOFz1RNkHn7aPb262fp/VcmjlihkRn/H+4s6ctShU2UqIc2LnXlTjxfO3JB0OV1SPfVdE
	3ft0rGMSbVMwWOR1UAlNm/aGOJjdpBw=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-896f4627dffso66175446d6.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 09:18:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1772471927; x=1773076727; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9jiAd70OQeRHoiPXbEJ51axrqw+4XgbTYUr4MIjZbMw=;
        b=s2lsXKO21HT6BsxIZspFl6cFmn9BECPmN3DdNL4NqNybzFyALVwlFynEiSKh9ZmtAu
         QkAm+SDjAKndoQ6V3C3pIhuRrxxmjCmkhTciXAi8tQEkNUH6Xkd0Y+wvITYrQeonzlaq
         uxSr1ibY8mktvDLtsx6vgH3EOQuSblp8IXDB3XcF+l+KvOobYX9C6R0V4Wswfl4CHig8
         rmqAjf7oBoA6g5yKI4SIpYQPSR3dY7Iq5OKp4cnGWcRjMLpanbfPKkVN2xCEdAuRxU7d
         rMdD4SCjmMmGO+lMHeZAmEmyZIHAr2g3+KoGUHOgohLFu0yNMjp7o03cr93hlbNBf0ow
         5n2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772471927; x=1773076727;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9jiAd70OQeRHoiPXbEJ51axrqw+4XgbTYUr4MIjZbMw=;
        b=Q6LvLjlwYa+z1iDzutXyglHWrEu9PYoN0KYlG7jGPZ3SSogVzixA9jktYh/UGwBUg7
         ZpzHVVm+oG/7wGPLmUFFEB5nKyQqreYbUc/Rz7+7Ct1ZC1BX5q6JM3d3Kj8KjkvZSTkm
         8OLHC56tkQdqQKr9bhtor17Bb20ViBDChnz0a2nVIpZnSKsF414Ky3KxKXqSM5oelUuS
         VPvjexiat1kuu6YvdXQ3MeRJMm0jWe4T7r+R35KGJxoB6nMhbp1ZmFRIO+dtOzQHHZna
         jWSPk9/++3NoFiAqnuvf4yGvqBSkMLHcugfachDj1Od71ZCeu7WS3wX08GaGPNopgMlR
         LUCg==
X-Forwarded-Encrypted: i=1; AJvYcCUS9piRpS2XBEPZLA7MDTPQ7KBv3BstKhTnRqJAnfYkMAAF/5IVtNHu6rrkiuWHUHIYuOX7FdqHpg==@kvack.org
X-Gm-Message-State: AOJu0Yx7oNk/jkShdtSKLxhUFcE0u4fl8Zd8XxGdHqXEOl9Vq6EndXZW
	QejVbTO1iV0550YkRGMvTq2hEE7ve8AfA3wbybD1cS9rR46tCsp9kOvrx4GLbj5lxk7ZkTt68Dq
	5w876
X-Gm-Gg: ATEYQzzBNc9sG7lv9jyxmlXawrFw2EANQCltbfFGbpIIhYkGIszaWUbbTU6d9bMZHQn
	QqGPXJ8gPTGzPSCgz1zJLgiCiT/ZsIO5hYx0NHS35+DbxLgzZbgMiMGVRJ+Ua20pGVilaMWXoR2
	zFz7zaNBWrV4mC2EFfMJiVyv0HKolu7zbFnUdYfpjx3jB9ab1wlb5tF7pTHMk5Hd/B7VOKvxL3+
	lVSmRkHNI+T0OqCLX7Zc36CD5ZjCVLc/RT5QLAqNVHXJgSrW6rRdm3aiSAVDpV9u+e5bFOG3b6C
	vxexEIkNMfOv8zey0r2EI+Rv4nIoOYvjFdOIGFbm4kBjmmhR2XGXBpFrbbaN4E4dXDGyJI9MyXU
	2QUmqBEKt43Sa3FGWrZcgWDrXEjkSd/f2J+ubFllQN9l3RBmsGkRVfQsEuZrcKJ+9mYDvLCsKhH
	gocvvhayZiDGhubwBw59XrCjOZ13FCbsBZ
X-Received: by 2002:ad4:4ead:0:b0:896:17e6:b3da with SMTP id 6a1803df08f44-899d1dba572mr185242286d6.26.1772471927483;
        Mon, 02 Mar 2026 09:18:47 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a083a95fbsm982926d6.38.2026.03.02.09.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 09:18:46 -0800 (PST)
Date: Mon, 2 Mar 2026 12:18:45 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Matthew Wilcox <willy@infradead.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH 3/3] mm/page_alloc: remove pcpu_spin_* wrappers
Message-ID: <aaXGdccssMyvmz5R@cmpxchg.org>
References: <20260227-b4-pcp-locking-cleanup-v1-0-f7e22e603447@kernel.org>
 <20260227-b4-pcp-locking-cleanup-v1-3-f7e22e603447@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227-b4-pcp-locking-cleanup-v1-3-f7e22e603447@kernel.org>
X-Stat-Signature: 1nzotcqwopopwyx3gf6umc1j18wnukhk
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 76143A0013
X-HE-Tag: 1772471928-419665
X-HE-Meta: U2FsdGVkX1/lomCAngsIAiFwSrYb+xb0EMlpEjmnu/H/iZeLzNpgN+gbXouPFVPdbGDsiG37iAjBRfEiqQaSNiBFMI7XKmjET2dlt9uGBKzuXLHumnL9cpogW7s+nmhvhTGNZudGhEXpXQToEkKRdtWGs/X7MLPKGnRK1a1+u5xIlrTu43dMgwHshpPlyhZ6I+9CvDuAmH5RC+OEykfLxwuIv3qbMp3B2o+6scL1NBiKpiPOmgvTCzTHmn7xL9j4ZScX1CSlzracsG1c11QzxGKnly1usuo52+JoSO/gtVsujY2b56KT5h6hIF6rRYUCsXRkMtlvcTJBX/zaMIQtT9coOGzxGXzbV/KC+hTFS8O4oW7M4VJhqGv/ExeT/GzHe0dCQnbu6hpQzPUwzwZ2kylyqRtSDh/Mt/XDd3OE4M5Ko0Xn5kJq/uhJHrZPktpJh1FnwQCJu6Z03XDZmX1uCP0oNK+TlXJixPyF0nWQNcAe9BwgaAmShA1iyUpICNWGVB/OoY1Hw593BuAW29hawiEn25xsSZH+xPlfEUK0OQVAkuhH7VxvxNz6Uh+EH71oPqhbpGM9xs/fqMX98Jav77dLtxL2+jvwJwaHNVJRq/yVFC0LCDz5MiDi+BOJHLzC6+7fxaJ+oO6HVCO0N1M03IcPLI46z+w0+z0KmYqlnyus1j3sufZu9mCZAP/MplnnOQBEVRtG1TQ17JuMseIupPmfV6uVbs/+aWWJ9SATE6EAqfVAEYaBAHIOLwJD5pQKdXEIauIzsa8tFFZWgp/s7c/qp8EJsxZgsiSQ+k1Zb3ClSbeNG71P+AOd1OdBNwR5mAZzkvhBDC9Lm50qt6aaYhwVchQW2cqKZ55fKswQbV1Zo9zJKC0tgvlzBdFv0vSdVzAXu8kKisovxA3g8sNpF0TjVc+3vPKVbcmiUykNebOL1FGE6yAfSzgTKQKqu23SCRRvaFV9eB+xmMKBihD
 V2/TQdyx
 fGOCuASOtYFJEBZi8XLONLASxTx+4Eo7rtygYJdicYo2tYoqSVticCUrSHnTw2CbiceY4/MNwazro8JyOc+yUDScIOKU0KCB9O4Q25AK7c4OHMe1N0xaeqD0hcQaJibJJ4mpNwJZQdm/AXZ4/p0DXM4PoDQekkdeBFSb9ohbujqXvLAENwXZw4yim7KjNGUE30ZWmep744PPtNe2bWi6/ukCqoQF+Jdz4OMDG0jVJmg81CZ02SJg/o40rrhefD4nNJb9Qz81Wqia5meejceJaEE0rHluFgPLRA6VU5zyK3DKcZsX9Ua6lXdLNBNHyYcMtAi2nBjhH6WKSehW+rNKuxy6LZCJDHPDLxwD6nbEKb73J/XanhtPkDBHXxz+1Up6scQbnQ7Ht2RkTjGrPGE4m0051rLtXryNLeW034m/YLwPETWtU0KIzOnA9IaLZY5XrhDYQz9Indlc/ieYmLoupQtfhiRMH4GSvOFEulrkL22QSJvT3Lp+zHtivqE3fdHsGongnl833AAbEPM2rcR1Sp6kFtbzBfwpZhFy6VNtlSCcSjsr2UEb25YmcGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 06:08:00PM +0100, Vlastimil Babka wrote:
> We only ever use pcpu_spin_trylock()/unlock() with struct per_cpu_pages
> so refactor the helpers to remove the generic layer.
> 
> No functional change intended.
> 
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

