Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7039E606A329
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 16:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=POqSR4uA
Received: by kanga.kvack.org (Postfix)
	id 4F4926B05B6; Thu, 26 Nov 2026 11:32:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A5336B05B7; Thu, 26 Nov 2026 11:32:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 394EE6B05B8; Thu, 26 Nov 2026 11:32:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C653A6B05B6
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:32:13 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4BAF840177
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:32:13 +0000 (UTC)
X-FDA: 85477812546.01.4351640
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 59C7F1C001F
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:31:55 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795710715;
	b=kq88OgTVF3pzp6I+yEKfI7xtkjeOBDRvJlg9NiskviGPfaDxZwnwtoYMvQrD8gYBzw6L++
	jlvO5d6qCYDJmjKw8YZsxMEx7GAAXClyclaiRkBabOpALDweaYKZzjm6PqdPLxERrKJuKN
	MjutBA9VRm372YEz4k0bLKus4UJkdsk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795710715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t9zuf6AtiZX3yOJGNCRqBvoPw6Ll8AmPwZKNUXFPImg=;
	b=ey48qLuzT2oVeRMIiiLrqBB/qQLZt2FOlCoUlWmu2jxk9fNEivMLdWMMUEkXb5biZzRPUe
	aTBPeRBJzaDY+HmH94xGAh8ztHrRXDhw/z2bK74izRqAR8SoUwvzxYOIv2CLmfT3JQq0r6
	LUw2dnp2MB7D6dKPJ8m3iwkRWcIjbwY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=POqSR4uA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of pabeni@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pabeni@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795710714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t9zuf6AtiZX3yOJGNCRqBvoPw6Ll8AmPwZKNUXFPImg=;
	b=POqSR4uAcDxXpmxSNPRQ1hz3U4QYC8bybUIMt/Yz0Mqxh66CQuV4CnfM5IFuExdrtvNIjh
	Rj9eZtAl1uQEXkNbi9yVs003xHBRiruE0DMrwHdxmBRJ1ej5VeArwcbmED79PrXIJa0sxG
	23gSOfl/YPJIpZU/IRTYuSIA39Nhkvw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-nsqtXyvkOhOr6VihWGI0sQ-1; Thu, 26 Nov 2026 16:31:50 +0000
X-MC-Unique: nsqtXyvkOhOr6VihWGI0sQ-1
X-Mimecast-MFC-AGG-ID: nsqtXyvkOhOr6VihWGI0sQ_1795710709
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a1f03f2e8aso62838495e9.1
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 08:31:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795710709; x=1796315509;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t9zuf6AtiZX3yOJGNCRqBvoPw6Ll8AmPwZKNUXFPImg=;
        b=p89ZpEcDvVcdxPbgGsrVx9cR2AP0Ji4FZnXOKaBZAK5/HdNG6HZ10b+Vz73rCiz+Dd
         CPRQ03ENKcSpGswWCOzyl5VIMCxoqlkUgMLrvwGhf3Ge6Y/6F9RnU3zt9XkVn9rTyizj
         Nq0RUCkZPg2EV6IKalCRzr0hu1wR5OA9hTyYuuRDo7eUN5dSqAsses1rUjN4QoAmkkv0
         0pQodU5K1Ud1IvO15DD3DuJ+U6BfzzxyWbVALEbgVYvP7d0v6/nMDAeobii14FhTgD2t
         ts8WQgMS9Z91HiqGafltxRlgJHG6oaEv9YCN3//ROBRE+veIQS5UFK4y6d339f9dO8+v
         tQGQ==
X-Forwarded-Encrypted: i=1; AL+hErFI0Oa9CAiNEtYsuFVOMHaCIu2t69bGUSyShNop9tUT6aCHwYhbF4mU83zLR6avatxLPwuF6QJQQg==@kvack.org
X-Gm-Message-State: APuU4Z/ONyscbTEM8lDGQ7YY41BSEtTea83SV5tS/IDGDB7OmseYILYC
	0hD5VOdrKKOn4vgJE64NtCzgDWiZSKsDU/1sUF5zvVKAhaAQdYaF8JWBz574kZVfZlqKtyG29db
	cI8nCvsBXwVZq+pOwQCn46t5gsLmIlPoiV3Uq5Cx83YLNhUt4hmei
X-Gm-Gg: AZFdTZfe+ERfkOhjSFo/xjv275XzJvTTPVgHI9qhVRKRpHcV+nE9t58Y/ZvyFlPDJcO
	zxbwV3nQ6gjfvAvWnREPr9To0r8R/pScZvzNAwor/yIwzGQUurJ6p2tyTb2Pi4HkKyavvnlVrfT
	nplLNwx0eD2+r/bcll44kuEAtw+DjmN//u2+oQsJ5eGgHbeBzZOxkkdjQAh0eXZPk/WAqbgePoB
	zjP8T+xCtadcancAobl3vwBUJjJ6uY3aRg5FDrM/ipbecHKrWP48LE9XHZ6Fqy1dDu7ja2Fh6Ds
	HTeG0T7YBKXIrOOidm1DI0W76ETxYzxKHlxJPau2PFkYjFuNRyvSaE6PBY7nYWkb3UUdE4nR2Ea
	UpQdcevpz07iBSFoBP4Uwi/9yhMbLXy3z03oF/mkcQvBHFeHW0PeZNmRyKXRtTJwIbiiBMUQ+aL
	4UdvcIOF0She2BpLqenrA/2ReF1om1tLlRe0obBoF/xou6
X-Received: by 2002:a05:600c:6749:b0:4a2:1867:10e8 with SMTP id 5b1f17b1804b1-4bb8881a294mr421918815e9.25.1795710709182;
        Thu, 26 Nov 2026 08:31:49 -0800 (PST)
X-Received: by 2002:a05:600c:6749:b0:4a2:1867:10e8 with SMTP id 5b1f17b1804b1-4bb8881a294mr421918405e9.25.1795710708737;
        Thu, 26 Nov 2026 08:31:48 -0800 (PST)
Received: from [192.168.88.30] (ip231-128-192-82.pool-bba.aruba.it. [82.192.128.231])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6b8b7888sm41448852f8f.42.2026.11.26.08.31.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 08:31:48 -0800 (PST)
Message-ID: <72ec342e-18a9-4b40-ac3b-a20e4e9608a6@redhat.com>
Date: Thu, 26 Nov 2026 17:31:46 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 4/4] net: skbuff: limit folio refcount when splicing
 from sockets
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Kiryl Shutsemau <kas@kernel.org>,
 Song Liu <songliubraving@fb.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Rik van Riel <riel@surriel.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 Pedro Falcato <pfalcato@suse.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 stable@vger.kernel.org
References: <20261118-skb_refcount_overflow-v1-0-5551b4954c3f@kernel.org>
 <20261118-skb_refcount_overflow-v1-4-5551b4954c3f@kernel.org>
 <14059088-7992-4d89-ac6c-1e6d1f61b3c8@redhat.com>
 <832f42a7-1d44-4138-a7f5-7cead4a28e57@kernel.org>
 <bcbb57bd-6447-4faa-a56c-9bdf1c7bc90a@redhat.com>
 <b36f40f0-3f9c-4ba6-8c1c-a76f99623944@kernel.org>
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <b36f40f0-3f9c-4ba6-8c1c-a76f99623944@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vugRh2mXyJQfp7o-J4zy3iRGbUdziWkeH0IaaEiBHtE_1795710709
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-HE-Tag: 1795710715-776698
X-HE-Meta: U2FsdGVkX1+JU8vlEVqX14EzCio0I/gqHBeoEeWvKawsfnb7nc4A7ZUGUwBIZIDKFWhFwPqbuPFKgZlThKVvVYnGO8Ea81wXeZvz0Wsvt++53y//IKSilnHm+7lemIi8lYoQoNoqZRJQQXWuVlflcYnJ1OTFaICNz+yzTCG3mad3NLfFrPy6o0bnc3ikS78HP5koUmC41OE2FhJ7x9aC35Bzw4JR5UW2gQVBZfydBVy0wllKDJV4sNy0fuFJUWj2ZwXQhQ2Wot6T3oSwzfO7dM1koUJzt5ojGrN99x/GlrlqDXJbZk86TOYMZBcu2kAFaaqIMSDzl2QR31TVHGXL0xBElAIwXwFCKXBV032sQHKuVgfONUzOYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/26/26 17:12, David Hildenbrand (Arm) wrote:
> On 11/26/26 17:10, Paolo Abeni wrote:
>> I actually prefer what you suggest here more than the current patch.
>> I suspect Willem may have some other option avail, but he will
>> not back for a few days.
> 
> Okay, just let me now whenever you want a resend with the proposed changes. I
> tested them a bit and they seem to get the job done as well.
Please, go ahead.

Thanks,

Paolo


