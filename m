Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4421FC5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 11:20:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CD1E6B009D; Fri, 21 Aug 2026 07:20:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47D806B009F; Fri, 21 Aug 2026 07:20:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36E796B00A0; Fri, 21 Aug 2026 07:20:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 160B26B009D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:20:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AA84C160411
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:20:23 +0000 (UTC)
X-FDA: 85125033126.30.428735C
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id A56C4140003
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:20:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=cJi0VSpl;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787311221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S9DzUHhXqeF8/l/paW9lK4zwpzVJ/XlGGskrQialWHo=;
	b=rTH4kON4E/j11IQJg7OMMkyVK7GjjcyxnkNQPYbzzex9bnV9+26Un/xz0RXeppgSIBt0DP
	03Y7QtFUlJPjr2mrWB5kl40XelV8ZXiY/sxMQSS46XFfDNcX/u92derLcy1QPqp8V5vu/k
	cPckHqHACbQytcSEaft/FPqCXgR6xF8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=cJi0VSpl;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787311221;
	b=7WW0XwAGL0IL/8gWk3p5kLH2WoCu3We8vLkGZnn4rigkNrhpjpA6fc13ZP9nQ0I1Gk4jLK
	mgDGVkm7mU2h5uJdqf+lOWGA4asEScWIzJGT9mOtigIHbz2Ep5kvHFp36qKlS0LkGXkivD
	xPf7Q7pEbBbWu8s2sgFRu75PKA03AIs=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c2020421077so151001266b.3
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 04:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787311220; x=1787916020; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=S9DzUHhXqeF8/l/paW9lK4zwpzVJ/XlGGskrQialWHo=;
        b=cJi0VSplAhiuFgpgLLKGPXqk8Pk1akBYu+qhtvDbmybSITveuTMlOQ00lFI+1LOeBh
         Cyyloc2jHT6kxp7zQpcCpe3eW16FzOqzTAu0iE0g7LadCryzWWQeHy7g6lQ3LD8lWA2x
         Codj0Crs0B5sZhuW9X6+P42dj/3tW3AAxB4iQsTNt0t6eG12k79iDqcfffuqxGl8msaT
         ZuBB/zradWdhqzYD8UJ78fZhC/YNakEDY6Kti2tH8z7v75PiKL8bJ2PeravhC6LIBFbN
         w5YRHw4URay7aKhJC1kAnNh1nvrseEjc6umtdA8XP9khhQ2Mead/h9lqnIGgOZNIhIVE
         nErQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787311220; x=1787916020;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S9DzUHhXqeF8/l/paW9lK4zwpzVJ/XlGGskrQialWHo=;
        b=HJcQJZV1RXVeixgCfwKrkQtKVU5x7e9GtCrtgnKF8eq5iWY+IojqAL72TIgGu34066
         oPlyygm+xaNpUHuPaPtk04w69H11Jc5dqNMpC7aqH0/bXVR2+naRzGR7Q+LJROk23r4w
         aklofR8W37Qs5CsLHoC61i7leTHmEFG9712IS4otWiNVKOCVmkNFGWcXWXikeRYYcTRl
         C1cDZZPCIl/49AwbA0RtzAzyEYmB558pe/58INWLbSsPn40JabxGqoGRxnfeSdXe1FdR
         6jYiXcVtf6rYXvIXlIof7KQwJfKoeTZJKeLhlx08CEeWD+Ga1XAAcYF1viIbCCeVUSES
         9lLQ==
X-Forwarded-Encrypted: i=1; AHgh+RotlR/3kxatibQfszhNlXlAgSI35ZPz14cp1YfTDJAmYlcyCaOwVwzdcmZ7arQMECqd5zuJAWWomQ==@kvack.org
X-Gm-Message-State: AFuF++ns5SIQ+nWMF4d1QLFyKcEggNfvexu6f5bS7KHyEuG8OXscwG/8
	tNgrKota+xIgRGOdOaAY4akjaMi4Tp2pufo/Ac1OguPWlQ6p/iv355kQb6gJCsWpg7A=
X-Gm-Gg: AR+sD10rgGZL1lnc1k6z3C+5avMtkShM+j/U7d6O4KT5F7hxbZzA5Mr4K5owiCXC/C0
	zsPPBSdqjK8q2BBADf52rLQuhaEZKP4UpyXeijmZeIYEA0FQpLxh9S8yP3GBg9p+t2DASfyu1gW
	CvvLSkGOcMKb+/dJdJSv5kzXKLwGf0FyRDLnZ79UDQwYbZ6jAa9UooRj37ZrLCrBrXIfHSrBAuj
	NvHHlfejw9/Ww75Sg+boiyo6EswqYVthVUpT3ziszNeYwc2cD7K/VIB8oKPhLs823TyAzYtpSXP
	PuDcCqVgqT700asLdRhFEyI+n1+/0853Br351pffUzGEKJQ75jKovkEDXKqW4F0qMU+sYATDiOv
	6zV4tYJeD+0ZFRQRo7ge9+4iFwPc68Y8LT/kwCAwlQnvbCu3nMWDNkb8Kai6PEJy0JLwXJJJM7t
	JEST3skWkd9oNfkKpB/u29JBoynZUUEAGQTxEzcV8kq49T+PjJKVpLKsFdJsNgjYRUMGooboC91
	+1605W0yVgR
X-Received: by 2002:a17:907:da16:b0:c20:f4ee:7c97 with SMTP id a640c23a62f3a-c246a4aa1bemr550696866b.5.1787311220175;
        Fri, 21 Aug 2026 04:20:20 -0700 (PDT)
Received: from localhost (109-81-81-112.rct.o2.cz. [109.81.81.112])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a3ff16c2cbsm6285973a12.22.2026.08.21.04.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 04:20:19 -0700 (PDT)
Date: Fri, 21 Aug 2026 13:20:18 +0200
From: Michal Hocko <mhocko@suse.com>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [RFC PATCH 0/4] mm/vmscan: honour node reclaim limits per type
Message-ID: <aog0ch0u8BtkR-a1@tiehlicka>
References: <20260821081741.1340277-1-ridong.chen@linux.dev>
 <aogMyu5R_DZRqp2J@tiehlicka>
 <f45848da-9569-453f-b0c0-8aa984e1976d@linux.dev>
 <aogZZsXwCyOXISaw@tiehlicka>
 <bc9c3de9-17b9-4ba1-8065-3270bb455630@linux.dev>
 <aogwUac-sjfcs7Vi@tiehlicka>
 <dba83897-9bbb-4a44-9021-8f938bb6a12f@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dba83897-9bbb-4a44-9021-8f938bb6a12f@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: A56C4140003
X-Rspamd-Server: rspam07
X-Stat-Signature: 7s33xdwyyzdjrwwkaxd6x6bgroazwp8x
X-HE-Tag: 1787311221-816851
X-HE-Meta: U2FsdGVkX1/dldvFxxkAWL7y+onaxwfEtB45id68Xyuz/r0ZmUJFcQ/W62w4fpKKnV/TkSP2v92grmOjaCc9trB9wmQul4AH0JkHHtT0dIDpYLPysCtKL1dIwwGA3k66hwHn4TiwfrGLJm6IFELV67O5SxaZWMPEEKWKQeEUdhdlEdYjUafa3ecduCVWWT1ZZbZ06qo4LKA9+iCj3uQ/zbcCzn2LthFSLiboWr3TAU7NINK2KWWLUSbdkyeHvkZtx3W3aiJQre8e1ordkU/tilidzjr7K6v/aB2X+IUDpKMmB7YitdEH5ch3tfWEQoZCwmdNtmjmKbDWq8shIn+3RDXU0qWco/wDiAI5ExaS7t4vhz0Qg7N6mTgneh1gpBr6J/QeQptonKyQgj9GQkUHdweG6a+AVNq3UK35l1xAF8lDGIv7EKiEDg2ed3juwj6ZQmcT39xdU8umKBJ8mA44GS/V42ozQtTVCd4OADPJCgFRuT+OtgXN8DwXcGjA6R1jLb7ihFQLz87UMjwCiWMd4z9PJoxwHEHMsZG5gyhoQR02iiw+Eli3LA8XLyZsIZiy0OyDCzbpn/QrRT08XrcH+P+KPnrQu1iDwcycQgCfkacFSdua9LWY1J7j+rTu7qYGi0VyoyYSqJAwsKnYylsb2PX9+Zw123RFuuTrr5STZ/hlCZKx48Ymwayx5WP3SY7DaGMhZ0T6COqQdsHjtj4SdFzus4xsvaXS14jWqapij8Vv43meZdrw3SNsrr3GglVwsbBqHeWA6IAX7w2C/fFXpLk0E9rLbdU6cVTnvW6xgU5CyYiMGwb4vMtnRxSPdSCb+sqE11lQate1auUU4pUwBbeH9zdwX3tBjTYbhj5gcgoEuvtn/zn+Z8+3D9LGW2MV40Hjckk9IBf/aHAyT1DDFzWZO1ZUxrWRW9Td5JYhWMyv9Gj1Qrug8porcxksPwd23bvRrnFaP2f6JJvLIw2
 PHVj6R7U
 66vX8LyP9EoDapnyNDRWJtyeOMYWk4jKb67XTnywe0+0ouxvsWS1a4lXKS4Pl3VUyi24J8mzLkqWFSWru8wQyNL/V5vNUCfXzAEr5rQkkAzZ4laMuMkG3KvvjNs95Ms8VMLt3XrJPI6m3Cki+ojLVblIlhMMd1K4kdhU+TJawCTLjf/a6Pj7Etj+HNIzUvNNunJQlqJviNLPT4TqhEcb3KTqlD9X+IVfvKgXTfkdFwEi0AmvT4cBZO5qHaj/5O4o8eUQUwDIX5tsV19Yd8QMiToaM6J4DZbKdjc8Z7Mt6UK8KORJ9hhfMtPBNTL3aU1eVW4FmkuzC0T9lXAzfph88tC23pkdMw/BhWg30vOndRI9QoC/clzPZx+6E/TqPWEoOOLfO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 21-08-26 19:10:45, Ridong Chen wrote:
> > > Did you mean that min_slab_pages and min_unmapped_pages should influence
> > > proactive per-node reclaim?
> > 
> > Nope, exactly opposite
> > 
> 
> I would really appreciate it if you could clarify this further. Sorry, I'm
> not sure I fully understand what you meant.

pro-active (userspace triggered) node reclaim should completely ignore
all those historical node_reclaim tunables.
-- 
Michal Hocko
SUSE Labs

