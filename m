Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76C27CCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 10:38:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68C3380033; Mon, 27 Oct 2025 06:38:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 663738000A; Mon, 27 Oct 2025 06:38:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 578BF80033; Mon, 27 Oct 2025 06:38:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 47AA48000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 06:38:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E1AAE48240
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 10:38:45 +0000 (UTC)
X-FDA: 84043545810.03.046D53C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8A1EBC0008
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 10:38:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z2PjwMs8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761561523; a=rsa-sha256;
	cv=none;
	b=pf+Wt8phUoiVO7sU5y06w8a+cSdcGpM6p4/YJ1B8TYXZtZR697mouyEV+mDgDVN39T14xm
	FQxF0Y5JeI13eM4kptS3YkG+HnmxhN2dtbF5cSXctowd8pTvGiKShdyZhRQoHUnDLn7GbR
	/i8bmCGo/eItIDG5XP7eRpCe+JkHYy4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z2PjwMs8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761561523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oel4G3cPEuo2MmKUJIoS9kEtL79BAE03caQp/0wRCy0=;
	b=5xd5ek60LX5irr/b0/dee7/O1H5Khy0wv5BfVFWASVW6srpBX4fO+EQSkAdgnThbxtGsm/
	SE8XHVR2NkXpybgXJA/HlZ90Dy2yFLHfp/7/WYMGxwOWf/JRdTkil0S6b1xsSXplczLOdD
	fP9sQKd2RzWlAAmI0ybJ1GGl7ncJTIA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761561522;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Oel4G3cPEuo2MmKUJIoS9kEtL79BAE03caQp/0wRCy0=;
	b=Z2PjwMs8HRf280AENkTzlfABLcit+RcGn1m/bUC5D7NdagwqLizbmvtC+0cL7nFxS5frbm
	Rtrb2Xb9H1Z7vFm9oBoBcIKB/r9F6u7Cyo/59JPhBdPib03Wdqi9UV1w5OzRhWYMD8NXud
	fptfYJ8E+DfzAETrZzCZtMGdHn1iXuo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-8Tp8VJ4pMuaWnI-OZQ2UIw-1; Mon, 27 Oct 2025 06:38:41 -0400
X-MC-Unique: 8Tp8VJ4pMuaWnI-OZQ2UIw-1
X-Mimecast-MFC-AGG-ID: 8Tp8VJ4pMuaWnI-OZQ2UIw_1761561520
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47111dc7c5dso26445145e9.0
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 03:38:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761561520; x=1762166320;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Oel4G3cPEuo2MmKUJIoS9kEtL79BAE03caQp/0wRCy0=;
        b=xTkupfhsFW6O8IKV0/C0Ip+aIuZgTaC7lXr3fAj8s2uO2rnogUdqMZSSNRzRZDMEKl
         Wlv3kLaocOmJ+LJgjC5HHHOglxSozADx60ova4SJF+lPTDAFhIF5u7wxicKDY+Cba08g
         HbJbidaE2gqW7Efjf16JN8LI/L8dFuHxrewroTE6Zq8K4YI2NnLyfsgubqBWdv08dDA5
         aBS8Sz2A9Kz3HxA/bZv3qGUCiv/mUBDvM6aPHS2DEbEsqwol1wYGH3bFzwhCw4AZ4GGl
         I2Cboj6jUck0ZQJpmAgZVk4TQyBOkuBMEsMyyKHgtG6pt3Q/5fcfH29/XmlzNi9NZ47M
         yneA==
X-Forwarded-Encrypted: i=1; AJvYcCXIn2d1UUlzbLXZeiAPblBDOANjHRuBqUoRb9z5ZSMgaLNunyBKStBkrMpv3BrMAMfVZMEF9yF8Yg==@kvack.org
X-Gm-Message-State: AOJu0YzfOpr8TR/u1Lo7Rv/RWf0xZCa8XRXfL5pNbYKF33qvURyYFDDl
	1+EcECgi8fQXc5WzltZEyOCU74SAhz8eRZaiTU30mJigyWTtWFRz2821du9Xw2mKJsQ6OzyNT5S
	y5Y1y/36113MgXRl2EhBySllWXcbvJoaW9QkFrV0SGrtAPTUsJ3nv
X-Gm-Gg: ASbGnctNs6oh1TYcDSOjeXKFNSJ6wu1JjlSP8Kn2Wpklofhew4kp2F76MG/VvTkTBEZ
	uCYkggyyoKEUlYbYnxqrRP6A4+iQ8yCmwTgRkkgoeQ4FtMySeFy49L2clr8d8xoJAOsktohwaX9
	69izbiAIB1Rnnab4U6Ezn3Jvu/oCd1e/RKZIR2+sKFyzD7FTnha/lxv7pmpFgUXGct+E/zIr4hv
	jJ74LqgjfnutRn0hwnPjF8ROn0HckXsI4gcwxIhaMvBrJRgx50BOWL2YXQW025WVwjheMTtnL4U
	gYEnZO2ARO00Toe7LxdONTBZGun08vZsJcmLpaTSSXeFuuJVVirO7xyRAm7FQk3ytqlh0UL4uOr
	+lY5wtcfYxtqczPEMvYnviBexZSHJx0czbYTzXYpDnLQ+25YPStNYIAw3pTy9vC9imlRepiUZ8R
	rJV4P2bCsoQuYRQAJkpH0FILl8fOU=
X-Received: by 2002:a05:600c:4451:b0:476:8ce0:a737 with SMTP id 5b1f17b1804b1-4768ce0a95dmr50410255e9.14.1761561520292;
        Mon, 27 Oct 2025 03:38:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGEn2q3gNAE8tdvOtiWdSqoFcYYI2LbctFUWA3TJur1mAMDCjIxd6GkkJ6jfNxpspik62KNYg==
X-Received: by 2002:a05:600c:4451:b0:476:8ce0:a737 with SMTP id 5b1f17b1804b1-4768ce0a95dmr50409835e9.14.1761561519853;
        Mon, 27 Oct 2025 03:38:39 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475dd4e30f5sm130097035e9.17.2025.10.27.03.38.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 03:38:39 -0700 (PDT)
Message-ID: <c519f6f8-37ca-4016-b8f3-aef9b9bda9c7@redhat.com>
Date: Mon, 27 Oct 2025 11:38:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 2/2] mm/truncate: Unmap large folio on split failure
To: Hugh Dickins <hughd@google.com>, Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kiryl Shutsemau <kas@kernel.org>
References: <20251023093251.54146-1-kirill@shutemov.name>
 <20251023093251.54146-3-kirill@shutemov.name>
 <9c7ae4c5-cc63-f11f-c5b0-5d539df153e1@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <9c7ae4c5-cc63-f11f-c5b0-5d539df153e1@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JVuvLVrPBCQeuynhTGweee-XiBEFbbHAV9W7eM69caE_1761561520
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8A1EBC0008
X-Stat-Signature: 6imwze5auoo1ku7jqhfy6kh8qph9ed7j
X-HE-Tag: 1761561523-167670
X-HE-Meta: U2FsdGVkX19CPopSZ9wOSPevPQbUxqP4CgY3mPiXDXQ8SnvRvVmgxF3bNUKdK8o7jU5Kf8kTcKQpu+m9dsWM5G4+ACjXKMLpdyVxzNWOk7nH+zWWSUdABpJPaxCcQOvodk8CVnqh2k5i1QXX6R/sUhgcdxszGOZYNFyNa5rvJPeMRBGooEBYBhEZNKZvLCjVLYrrMdtDq83O7Bl3hSmcbyoSQpAjI35i0CEEmW1ormlfskWLk6bz38l9jRJ4KNHRBixz7UtGm/4MxhD3vMOVbwbi6ksGrpWudigWFO/fJBM3iYYFbTbwEzsV45abAypsI//y8C+gcxZk2gU0PIKkRrQFzkOkudWLywFwPZVsXQUrkwD++qn0n6gO5JKS1dPezO5CW2/xCjr379SgBpaIkr1MVjKJThwBwSArRbNFSX1vmbix4YtvCMgzrtWb/yFP7DTpa5lQYCVn+ep8J0WUxVOId3gpD94t85Rq5b7Vdhls89N2J8DOQtuc1+yIdziHFpqrNdEcQFuNpXfDnikD+0+TO7znduJ7eST75G8Q2NsX1auik4RKaWSbFmjyYbPuIK+b2oWgAM4+/wsw9wVmy5qt0hfH3T/wEvV6m9iK2eN67hhBk3pahTjKwWXInkDDWHIAZppeXG97iEkB6mQLH4VpKImK02A0ylikyJ2x6JY3XEe7C7HrbGKSHBKANjXQgdlYYDufpmx2vkSB4y2hDI7es196K5UzJ+nb8TgvfQTrRmq5yU4mmip67hq7KDBMFVXhHq2dXAH0TD1Qq1F4vuUBDIEg/yMxC9mkUTsVIkbIU9zUpGw/pMGcq+8Dh8z0RwQgLDiAtktp/sLY8bpjGiQQbxpIn/wY7Uh+eeFvsYvga3cigZOD+ijEOmMSzXcuq2nRAmyT+3T6HSu/ZAlKsB5gqCbIEggQDK4hDjaN1XAswopykC6ipiA88LXtV0wdwbF+PYUx258zfXHhJtQ
 IcBzONKO
 9Tsxi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> And a final nit: I'd delete that WARN_ON(folio_mapped(folio)) myself,
> all it could ever achieve is perhaps a very rare syzbot report which
> nobody would want to spend time on.

I think that's the crucial part: what are we supposed to do if both 
splitting and unmapping fails? Silently violate SIGBUS semantics like we 
did before this patch?

So far our understanding was that for file pages, unmapping should not 
fail, but I am not 100% sure if that's really the case.

-- 
Cheers

David / dhildenb


