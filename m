Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85764CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:38:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E05E58E0016; Mon, 20 Oct 2025 16:38:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB5848E0003; Mon, 20 Oct 2025 16:38:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7DA58E0016; Mon, 20 Oct 2025 16:38:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B47F18E0003
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:38:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 66E871A02CB
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:38:43 +0000 (UTC)
X-FDA: 84019656126.08.D245D03
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id F06F910000A
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:38:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="NpKFdoG/";
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760992721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D5jtgiNQKtt7bQjGv+ROHYK7+SN6WSehX7RjoGcdUeA=;
	b=U1DfAIPhUT8mL+kdT9e6AbcWJC0uPBA6hUDU1HBclZyqY0Xsg6z8UXKaH+GkRj7abkvFA4
	WqbAr7sl9o+B3EvcDxbtJqCrA5JYHF4zYJAgvnJVIddkgXWcASCOco1AFN2QIY+rTLaWgB
	Z0QYfMDFWZ0jcFbtp1gMNz058WC4s6Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="NpKFdoG/";
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760992721; a=rsa-sha256;
	cv=none;
	b=YAMsuruchZWzotQGBQ4kZwhVltyPSY7rRoWw4kfl69QJs7bFiyveMPUOaHl6DKuvLJAPWL
	5PHdggyzPrV2u/CXmx1lrHk95a8GWhpK3RkhwtTYHoY/qiJVk4r2FlcHpZ+ihkzFf8iz8J
	tqlWrnWOQTh6l01AQS+T065uPxHV5gI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760992718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=D5jtgiNQKtt7bQjGv+ROHYK7+SN6WSehX7RjoGcdUeA=;
	b=NpKFdoG/ov86GftHGZ2tjjtRKEJ6yMwD698jHVIsN/VpwYZshl7AcvdUbH+mP9HqZ2LlRT
	uHDXocIxUQ2EP860Mpln1T1XWZPFutIKB7mSSn8Ic4VKBr/I6a2f3AaMEHzMd5nR+Xuu8h
	j1YUQDn5CIwcIyA4sTBAKKGiVhA9E6g=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-wxul2IqaN--pY3visN2HNA-1; Mon, 20 Oct 2025 16:38:31 -0400
X-MC-Unique: wxul2IqaN--pY3visN2HNA-1
X-Mimecast-MFC-AGG-ID: wxul2IqaN--pY3visN2HNA_1760992710
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4711899ab0aso37393855e9.2
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:38:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760992710; x=1761597510;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D5jtgiNQKtt7bQjGv+ROHYK7+SN6WSehX7RjoGcdUeA=;
        b=FMxGPf9tPN9Oo1psbnQ/xiwHsx/s4BtQSWCs4r4j3STzaaTM1UCZSO+hLeM4FDUKBD
         JLRlzTmCJe6gwJmly9VNWwuDjvX1blKTFdc9S3CBx9mgBSlrU+g5gGZdONjvNgNcLaa2
         C+Jt+yJWqy3bIOfjmcXj5ykWiTGUt/jq2LjHB8ni01zFkucwmpKRlpCSJolgHi2ScMuc
         Y/BFdNKHq4rsZWtD8iRdnLICDv3tvClQcFSUP755p55e67qgVWANIX6w/sWtJbO1USxh
         EJry0atkiZ2oZHoNVn9B30DNvVR+TRlI+wOAw2csrdX6g+WI60nW6694QuX7M2syNgeC
         FKOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVsQfWhigSiPbq1lXV2W2wql/LQmOsnbKOXU+pckQK4FGuCrDP/Fyq/uO8ouI3kUOuXCi0T2TrNtQ==@kvack.org
X-Gm-Message-State: AOJu0YywoQGqp8OLQLooapX2fVWofxtJ333Y2/HKBXkfyDUp3x4RszjZ
	RQFOvdr2PaPd2Jevf77HTBTnsncw9JlOJFI/PkRQJ7h4htSa+lbTVt96XV9+xhtUCXTnY+R+JaR
	DYOVHQu39SQwBZkmaK2On+vDBcYyZh4BYvfCGGHOZXkGPufrEfqTl
X-Gm-Gg: ASbGncuSprXNFyBxbvOHbye3+tUrymRjJTUBXxk+xvBhd3pKwv+ouySDUQdnNHpi6j1
	FvK1s+PN9qgIyhIbNG/iUN34TVA+9XW8v4g3h1/8ZKxu8ZzJsy7zYICOxVe21tn9lXnxR3JVs79
	SB82DrXTCjZHvRM2D+vJpYgJHonl5aAleQlPEt8WbP9t/vi4Wh3RNO6l8hx9jJ2i/kVUHZIg3DS
	+sML+z82cx2zuuR+NpAc84bZSuAkk93QDMb+6Vn8qa5A0l9HvkBLaVvr8XmyOJSUPNXvzNeAtHE
	ngg76d/UXSfMPgH2Pai90p/TRqCLNIW/3RPiKBs1J1qlOqRPIXx1I6Cn6BbA+0gIJgFyJol3a2c
	ci1MxQ1TAw8jkOqvovAtkfBSiMNsC2OVnS7yt9hPfE0gp/BL0fT6Cbw9KkT6uZZ+FhsG4UCxcMF
	Qc/hFNxFCO5swsEN4aCLYMtDNXQuo=
X-Received: by 2002:a05:600c:4f89:b0:46e:3edc:2811 with SMTP id 5b1f17b1804b1-4711787750dmr95395815e9.14.1760992710001;
        Mon, 20 Oct 2025 13:38:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGnEWMc3NmP1WJ5DHbx6j4Xc0PLLV0NUCeNENs0xEpvXat4apazl6zieh1n1aWJhgADZRpngA==
X-Received: by 2002:a05:600c:4f89:b0:46e:3edc:2811 with SMTP id 5b1f17b1804b1-4711787750dmr95395605e9.14.1760992709624;
        Mon, 20 Oct 2025 13:38:29 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427ea5bbc50sm17086818f8f.21.2025.10.20.13.38.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 13:38:29 -0700 (PDT)
Message-ID: <57b5ee51-db68-4106-9e3c-cb2518457e5d@redhat.com>
Date: Mon, 20 Oct 2025 22:38:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] page_alloc: allow migration of smaller hugepages
 during contig_alloc.
To: Gregory Price <gourry@gourry.net>
Cc: Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org
References: <20251020170615.1000819-1-gourry@gourry.net>
 <487730c6-423a-4a03-a668-9b9ff92a5cfb@redhat.com>
 <aPZ0OKx_VnQ4H_w1@gourry-fedora-PF4VCD3F>
 <609E7E01-33A6-4931-AC89-1F4B2944FB64@nvidia.com>
 <272c425a-b191-4eef-af6e-2bca1db7a940@redhat.com>
 <aPaQNYsN_YPDOwQG@gourry-fedora-PF4VCD3F>
 <0d92a675-ab24-4b1c-be71-956f09a9e973@redhat.com>
 <aPaUZm0ZfIEW3gUr@gourry-fedora-PF4VCD3F>
 <451b72a3-8052-4dfb-84e7-1e97c3388db0@redhat.com>
 <aPabPH_6FxPgPKM5@gourry-fedora-PF4VCD3F>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aPabPH_6FxPgPKM5@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: q2nWTo8qXRdSH06_2C1Bcj5alBKattYmkbyYlyuiiyM_1760992710
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F06F910000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ujtxqw3p6eztrs8mz7cdsqwcp6gpggcs
X-HE-Tag: 1760992720-115307
X-HE-Meta: U2FsdGVkX1/1EY1OrlDizsghfGFCHx363V/aCUth+f7q8o+D/SaGgSB6IsAF5xCwGXqqgWu7LkGgYniPdT58heyCbCQxtIxr91rxiRE/bKBV2tdjvQ00CysywXeg4iUzI9H3/jXY7rE+7btHIVF9hJQoncd3SpTAXnxxX9iYyn0SPcUR8UFOnkEO+h1EnHVHSesFCqRuRL8z5DMv5PgoE/2I+miK0kIpSPOQEMlZG0rrdC9mlSgwRIcUjd7utCmZe/dbtKrJwkbG7rRjDLRfTf3iAdqcqaorq9ukRla8BRppjIjm7369PonR02LWbWAP7mpAxFDqONB30nMGEtSJsH5ygoSJu4IHjDL1iB/5jutwqMr6V9r9vRfBjzz+S6ycKS8jxer2iJUAo1qYgJ/Y06WloruVRchLCh0VWoduP8Wxc9iRftorsb5DLgAffYlX0IWppzOxTwVRuCPUneH8FHaf0NXlKaeIHg/m3B1MhJwXYqiG/+BqgPUoLYrDok3B1rfiumRYmjlNdHkK4hDRhEoVGwo4TH5t+mGJ/MB9KWI1Du0PEDnmYEtHp7cfAHE4pTXrZXMjYCQWE/pwMnzrGLWby2NRmhERb99t+pvKD0tsO+82IH0xONJYnMmp6FRyCIiKUX7E4dCLCEIDiznJEYQPbcMqrM4NhJ7zr/pc4FZwdORf70yufodiCOlqjSlpY0bcLhLs4kEw1Z0dKhmwuDQU4zEsxKle/UsYtUEgsr1071YIHp6e1WE8uOtanrfVrCUhK7pKEzRW6wDVzfDDeqo92JWnnX+V9RFsdpS8PkOKHYpM2qri1xcbcxYbPjISoB8kOTZShEJckerAYehj1G205Z0zm1HMfHt6q33zNx1ZvrIGrTGQfeh11IkoujKGejiTAK63/2WFxsfRoVgCjFA2H2S78VMhoiser3tv6yj/jfK1rPeK1F+w0LBBZkFO50wlfEZeOXSo8FzbSuw
 SiBWuFDX
 91Ehyn0wNZBHSu04mJ0nZKvS++4zvcM+DiifVeMN7FWCTAk5F6dTmtaz8sIz/Mbwla2Yi2kKcuD32tjqkEj4ddq9mT4orjRiA8sG2VC0CgAoFv6v6ea7fTxXryCv6KaRTsycxsLse/ku4e6e1SBB35G20J7Fh0B/8Dlne+jLXFjqFl4oTJMeqw2pq2wkHOfqYv5ucr3W6ytlrjJytQ+WRisBhkcrtvWICCYOTlZ0+sPp0ATso4Ewjm1+PFXV1Rl335mmRM/sG4++B/hG3ZytmWfA+enhPP//ToRG3jBBv5ffEPcvKIT3I01WgwHopgeVCmpqlpxvYti+hQM/LBeGMYFHW7Haq39Uq3VN7DgYw9N8f4ZgnVpBQDtkzwUmO/KYXO2kp9dJ7y/a161k7o0ATcrqmwMb8wUfYmZIMw90sdJug0RQaQBDI5bvDC89BkpVbcjWinsswh2tNBN8T8psO5CHRZmqje7VX1BFv1Xo72PTKm/SKtlDVShDEgw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.10.25 22:27, Gregory Price wrote:
> On Mon, Oct 20, 2025 at 10:17:42PM +0200, David Hildenbrand wrote:
>> Yes, it's completely racy.
>>
>> I was primarily concerned about us calling functions that will VM_WARN_ON()
>> etc due to the races; not that they would make us accept/jump over a range
>> although we shouldn't.
>>
>> Of course, regarding the latter, we want to try as good as possible to avoid
>> jumping over ranges that we can actually handle.
>>
> 
> I'll go ahead and add a snapshot_page.

I'd say it's probably good enough initially to just use compound_head() 
and filter out crazy values.

-- 
Cheers

David / dhildenb


