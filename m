Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6017ECA0FF9
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 02:15:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DD626B0022; Fri, 29 Aug 2025 22:15:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B4A96B0023; Fri, 29 Aug 2025 22:15:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F19B6B0026; Fri, 29 Aug 2025 22:15:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D9F36B0022
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 22:15:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E785D85A03
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 02:15:11 +0000 (UTC)
X-FDA: 83831806422.01.7428D34
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf12.hostedemail.com (Postfix) with ESMTP id EA72D40002
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 02:15:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QUW3s+Uf;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756520110;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IbW8yA03bKLcMTZU8xuLw+CaeqZfBLjJOer3Kg/k+e0=;
	b=VYVNABvNMHpPC54FjvpgkGEK4giiiniamxQrwo2Mhs47wfH4xVSY0nD7N3eCPRqwEQKjIw
	IS3fVKJSR502PgOtLflibrfF+fwoD6ph6EuP0zcGGWGhPk1V1O0mQdYPiCHQ4TQBjqls4f
	wrBdRtdSuppAyiLDkyasPpNtBnJPnBo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QUW3s+Uf;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756520110; a=rsa-sha256;
	cv=none;
	b=26MS9wimiWLQzEdRzVgqhzJD3XJyP3MtMhJ1TbVvAZoLjVqNstvY1v4Vd2b3XMFp16Lh9t
	/xzWddtTC78vxqCPPthLt1cfmakqdGtsTOPa0apx/bjvpN49tjB+eekmW2ynbTKl6A/dQn
	YCnE7z73yTsQuTEj5gXi5GFljl9LCQM=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-45b77f59bd8so13650115e9.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756520108; x=1757124908; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IbW8yA03bKLcMTZU8xuLw+CaeqZfBLjJOer3Kg/k+e0=;
        b=QUW3s+Uf8VO0VWjy+kA5jTD7maze27nSltYCarQZNxGfeUn8Lm7GPoRqlXW2ij3Hr6
         v5nWpU4kLZ+RSyxZQHVt93vf8ZfTJLvhDPlBT8s9guOllQCcpAHOFvhrKGZI47V0Vm1X
         RMjXzUHWDzX0SaJp5VAE4IIbf8OlEuXT+32VKk+PZ2xv2ZSiELgclm8JLLsOYfK+G3mQ
         /tEhTDGg57bENXwi+coyoHkGT6BBB1G1Viezix9lr1TsNtL5SEGhlnFy/YFJWocMsd8+
         tSgIS1SQJx/vFotfaAXiXntgJUfNhyWYfb2+ndMvll/1QuT20nh8iZB8C+cpdJebMVeX
         exkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756520108; x=1757124908;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IbW8yA03bKLcMTZU8xuLw+CaeqZfBLjJOer3Kg/k+e0=;
        b=CzNEVmqvad6N5mhGZWIFQ5LoEvEnq/7M7IHItxczZD81x0f4c4NVhDlKN3lZZEkn+m
         y6D+fEFksQD5+7AVrWgWHBgJI2OpCuO+qAah2TIMDffYCXxrC4Wo9DJRU0ZWwr9pLbI2
         UP0obSbAkCnyLZo760OUkQ/QwXOed/8gNZB2hhxj2kNoXb/i0LokTzLXqlCgsJCaaEnD
         qqKIMYK0f0aupsi4c8jP210go6WnMrfwd1Ar4bcPGIBzA6544dEOyz/dQClGmsd6l62O
         wGXHXhC/VDPPCl2cc7TlCh/PqPTcu3fdztuk5gh/Cy63h4HjIAvtweORcvIidL+jkZP5
         e2HA==
X-Forwarded-Encrypted: i=1; AJvYcCX3vG+gYqq/ueCrdiaaLsHKQJpGwm0ShdYryT+xG1Fs1dOi8p+7Y4hXvJNV6DsIwvEAqSjNXQo2dA==@kvack.org
X-Gm-Message-State: AOJu0YzQRvRx8rYvg6kkWbCt/hLNmq0DPSzNhg1hw4qMy/XxSziW+Sek
	TaPqspn0BoG1Ay41NMplDTnkELzbbp2zKBTNP+LcAib2ykvPhn5gPOiQ
X-Gm-Gg: ASbGnctbr+3e7DMPbuxSzvpJzHfkuETyZh9MV76pvvMXOJotuLMwHJDrGOjqAtHZjaQ
	UirqKn0n75hsMh7BpNSqKUYrG2sZqk69WjiYje2WsnAZnI8hKCfzF5PWmNE8pkRrXiCUON/DZwL
	4mP4GK+1GOAQTT0TiN/I8BC7K8SG0RrtkkBQ4BUf+865A+JluwskxKkaTa6PS+8HV6u+LjdnihZ
	I5vF85P/27h/yCXVDNcDloYDbA9MCCJs/btSyfSO/guejgk2DWxTw8E/SkJ6/ykdCGxZz2cW+sm
	5yF0hYi0S1F3TKkSUeXXIstITWUkw2azARhugTxr3hsqVdrHdam1t24lFMNRPmY268AiJpwv1VY
	rg2D5Kz1dBnO8qwzfOKGQBKLRiw==
X-Google-Smtp-Source: AGHT+IEZ2xFlU2ogeDVnDCaG1GcpwFQhH4uXS3OA3m8V+IApCgexhyPxGxyko+OJwospCM8rYhx31w==
X-Received: by 2002:a5d:64ee:0:b0:3d1:abf7:e1d3 with SMTP id ffacd0b85a97d-3d1b1aef463mr566337f8f.20.1756520108168;
        Fri, 29 Aug 2025 19:15:08 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf33fb9cebsm5308064f8f.46.2025.08.29.19.15.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 Aug 2025 19:15:07 -0700 (PDT)
Date: Sat, 30 Aug 2025 02:15:06 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH] mm/page_alloc: find_large_buddy() from start_pfn aligned
 order
Message-ID: <20250830021506.q34jktg64h74hux7@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250828091618.7869-1-richard.weiyang@gmail.com>
 <489045AD-70D6-4167-843D-50A8DD19870B@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489045AD-70D6-4167-843D-50A8DD19870B@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: qo8yj5mqh1e8jqybfix3mcmfwu1pyoq8
X-Rspam-User: 
X-Rspamd-Queue-Id: EA72D40002
X-Rspamd-Server: rspam01
X-HE-Tag: 1756520109-783741
X-HE-Meta: U2FsdGVkX1+2/RBQ78E0g0MV28Ft8bNt2AR3/1RUGG60v9XuQQ2HlzNXGQGuSB5K/sK+Fl6ge+g6g5JgfHbTeshG5Kwwv3JeziPxjwAchFgC/kODYPkjRa5qfq3XmRunawMY4DxHEjjqWox48aAZwzYm92LLM6OtcMfWJ5l1kf2eIne3EzuMQwIQir9lzBhXl5ClT2i+rTrbW/XpdUbRV3d/QjWPymjTLnWPOAJ0U6pPrFIStE7y3ID5RrWTSuH8RcRC09hJbnGNmT0+z09oLFOMnBgYOMf8HPV4wyheIgH3URsWH+eHGHn7gQ49fJIubYNzGWmof+MI5dxW1nFzsSfizqLtsavvNR9ysRpYVUbnVcKWEJNW88dppAtHASE9NgOmW94OxJfLP0nlMXo+t0hmRop+XKhNFZamEzRkaU2/isvP346//e1Ija5Z13cHV1GdkS/Tp9H4qeQfbqP4fllhUJZZ3U93Z/OQdE9pXmYvko4j82tGqGSWNpEzhzqF0iAUUiIQS8p7msHLdXegn10LBObEhDVQ3vhBad3C8/Yq28VMDCGP3qnPOkYKIUSaLHY9pnkF4NIgV38pVZGb5tjlXKKcPdiAEYWrkX0DYLOfRpsh+BTUWP40jPpmYXe1WEPh+TlVt0LquH8SIh0k+G2u43QLhaTKF2U+4j6N9ckHVR1U1/35vd/8eKTqhL/kdr6ijYW9YSNrORT3ktNcoyxUBWDMQqohUcdtN8yP6w88WPqmDHrIQwnfhthGF3ugnJT/V67CmIwWgy9QNb5iXAReAMwH+CXfn2TFg11XzXrUlKRvLF2nXPvxSz0r39TvhqqB2Ozr4OrDRjKsyOHgYecyoum5GYOHveV1zYOOzli8kxRfSSnTTeD8u5ZzfI+x2iBS99DiUsYxqSv4Dl6Y/Vo1shUEpfWnlE2AtZ6DtWeTBAlwzbcadIQsiE1oInpLNHKkZdxx8YOXo0rvhTY
 jEINSwHC
 ljz86KMWCcnnIyFjX+M5okQnWyhwZ4TcFFq4/5HpAXFTtX8tsdg3aqUG1e9Qj8aMdzGVA34de8MODTgPU+3P2PClNUpqFp5lRKhWaI3e/r18XzF8ej7rsoJrX5f1/SETt3S3fQEX+5EP8BTft2QjiIzXbUfkmen2Kb4O4uduew+hP5AVwSnjtV2G/7rjd4xkQkXNYIot6CqNtccYv3b3+N8zCWmZ+YsKnjbs4wGoEknDieGcQvXvgMCE7db/KjqS7pA2/2XBz7HqlimAq6iv4t/a6C4ipXh5YWGdme7mSL0aTzVygAs83BPKC4ZkN9IgCrg7scpTbhzeXwD0LBWLYQKHuz7vWSn28F/gYmGrlVMpkmYKqaSlTv60FECQzuM3vDU0xiWlziVCYDcrYsycB4WFKUmx63JH1C2Co303RSjcg+4r/QD7x1ObTu+HQrUGmkm/auJXnBXFErMQ1JcLr4tTjTkinORqAC31i3KZA8gOxsXy7n+aHoPcdwRFgFQIMUJyTI1/v34oxWKdKjF2rJHynEn9a8thWx0XqfpdRKJtZwZznjcRVgY5f+9+X6V05TWi+8ALZH2N/vN18DXXQxpgFhUFZaPYvXChMybfjLRTKqpoP7qQNttg74X35uoD5wEHHFF58ys2TzOhUn23gkSYvlTs4T685D3N61il8yCYCgKMENsXGNDlKPNZ5wa+YOekr7Q9DbDiKiQjG7YKzuLBDdUcy1sjFBepTci2CxOGuDwWWc7faHzw70w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 11:02:33PM -0400, Zi Yan wrote:
[...]
>
>BTW, I also notice that when start_pfn is an order-0 PageBuddy, the
>"if (pfn + (1 << buddy_order(page)) > start_pfn)" check below would be true
>even if there is no buddy straddles start_pfn, although "return pfn"
>gives the same results as "return start_pfn" (no straddle). The original
>code before the addition of find_large_buddy() (commit fd919a85cd55 ("mm:
>page_isolation: prepare for hygienic freelists")) checks start_pfn == pfn
>before the straddle check, so the correct code should check start_pfn == pfn
>and return early. But since current code is functionally equivalent.
>Maybe adding a comment about it would be sufficient. Something like:
>
>When the found buddy order is 0, the check would give false positive,
>but the returned result is still correct, since pfn is the same as start_pfn.

Hm... found another thing.

In __move_freepages_block_isolate(), when checking "We're the starting block
of a large buddy", variable "page" may not be the large buddy page we found
from find_large_buddy(). Since prep_move_freepages_block() set start_pfn to
pageblock_start_pfn(page_to_pfn(page)), which may be different. 

-- 
Wei Yang
Help you, Help me

