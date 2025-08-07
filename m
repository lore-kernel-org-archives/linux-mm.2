Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74E72C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 10:26:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 174D48E0007; Thu,  7 Aug 2025 06:26:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14C9D8E0001; Thu,  7 Aug 2025 06:26:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 062B28E0007; Thu,  7 Aug 2025 06:26:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EB61B8E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 06:26:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6C4921407CD
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 10:26:34 +0000 (UTC)
X-FDA: 83749582308.09.6C2F12E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2820D120004
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 10:26:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dYnrNXYQ;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754562392; a=rsa-sha256;
	cv=none;
	b=Ga9INprDRDA3zlDaEen+O1ujZOoPVNKiucLL+y7BII+ppyzLbUA87bINzwqEHZovu7PF3j
	wpHdbg1EcGlMxdYZEwX29Jou2CNGKQ577FzsGvlxAn8ct34O4aBTCFlcpwq2FP/dvym6PQ
	lgqauaSqCEPoAbagm4uPLPFgRd2zCIU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dYnrNXYQ;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754562392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZVGQibavMITRGZMUXMYks2pQwACDsPgQ1+QijdprboE=;
	b=Xp66jfIouKJ7ybsDKh5AsZOp3wuEDRWlozSfRW8bFeJx/Ogl9yzbCn9himEZpcdJLRh0Km
	4O7bBG9UiqRh+3ZXx6/Q57FGG3ZCePHNLe98t34avPj3M/+zaYv7ZNCcpzwMFrGQDTDC6l
	dGiBaay9bvIS02s7tdOFIQpZcvHmqIQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754562391;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZVGQibavMITRGZMUXMYks2pQwACDsPgQ1+QijdprboE=;
	b=dYnrNXYQlvF/9tBskmcUPSqIr0JlS2HDxlIX7aXMJ+6QJ1pCmVstT9oizzTeF2fzTI+xFb
	NY5cUljomuEAarr/zybObGWC+tiRwRGWKVBV90w0CGS9WexrIN34f/j4xmUCIm5Zco1BkL
	4hDCXAWQXCNVkjhDtBbTYBWLB8oEDww=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-6KC8uEtMNv2wfMUHyjQ78Q-1; Thu, 07 Aug 2025 06:26:30 -0400
X-MC-Unique: 6KC8uEtMNv2wfMUHyjQ78Q-1
X-Mimecast-MFC-AGG-ID: 6KC8uEtMNv2wfMUHyjQ78Q_1754562389
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b78329f007so452921f8f.1
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 03:26:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754562389; x=1755167189;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZVGQibavMITRGZMUXMYks2pQwACDsPgQ1+QijdprboE=;
        b=ZICfoAVlCIW1+seLTSS6XIabSS2t1BZgMr1w4TR8KYJi/Miz1ggwt9INHNR34OkfY7
         InXXo/jJ7zdfQA8rn/Js3ZVCckhe5PntTnsWHbPXvU2bN0XfBeEY/i5wEv/pDNOfY5Em
         9zlwJb0ERDDo2mfvzWevrK+G98fBudegwq0OvCsoCrlPzuewthHj86BOsQFuBxmHTdO6
         InD6HOUUSU8+yU7K6CVR9KSvTD7YlT/EwOMYxcZ4fnu0ccL2R5QN88GjwBDp6BoK34dS
         H/M5oCUNmWg/qHjZf2d/Cy7s+LXNJHIPfVddidlAMI80+ro/thRatQRTUbyeQDqGQS5I
         MPMQ==
X-Gm-Message-State: AOJu0YzH6iYb4ArPJbZvZbWTrpySidUVGbLtHou7rwhV9RJT6oE1Zoqt
	qcwCvXMisDKhZB0Mmb6MqtB0RQULefS43BAt1ivCbkFYt6rtpM4lywk39wjLtXg7TAlhXs4RArq
	0/vEiFJHQK4YPTUbwO7BijpCZIJV1stS4lE5GdMvlpJeMWusawGNc
X-Gm-Gg: ASbGncsek1ayUS0XE4nDajIxeKGwjV2z5ic9jT6bCle9v+K3fBlUYr77vbrTNMePIfP
	HrKS+xsvoC0dLl3JwzBapG/t8IADq6Hig2ELzDTgmXFR5zgbWhPcKBIonEHHbw8n0SP1+YJPPhS
	7BRyu5T56Y74FHXUCRbMEckaZF0eRJQPtxIZK8Lp4zZ1ff0z2wn+Psvit7E3bweTJOTON/ZbIRw
	gPraWW0xBgfQyNC1NMFUD3hrjjqCrLiU+z0jGqGxws/UC0cvXp3nH1CUkSd6spX2Svkc6hPBBv3
	gFBuWAOgWk4Ys9NgpHiEttq0ONT3K+UFeTzVGnKVVC2g6fHWmusQR/19M40x/SMXkr+5DeXAjSq
	7qcQXJQ1/0Ee2tHr/9CL/hOb4+dRgqug3ThxnnfqPBv9gI2Vx3Ey1WJ4Rx5wxxc1wdlw=
X-Received: by 2002:a05:6000:40db:b0:3b7:925b:571c with SMTP id ffacd0b85a97d-3b8f492a9f2mr4770284f8f.57.1754562389147;
        Thu, 07 Aug 2025 03:26:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtRcixiHQt1T6HKtGZCkxOcdXhJODvpNxCQwLp/FeRmqHQKU+zL/VdHlQ5uC55jTnNQBdoXA==
X-Received: by 2002:a05:6000:40db:b0:3b7:925b:571c with SMTP id ffacd0b85a97d-3b8f492a9f2mr4770264f8f.57.1754562388673;
        Thu, 07 Aug 2025 03:26:28 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f49:bc00:12fa:1681:c754:1630? (p200300d82f49bc0012fa1681c7541630.dip0.t-ipconnect.de. [2003:d8:2f49:bc00:12fa:1681:c754:1630])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458b8aab8c0sm219909625e9.19.2025.08.07.03.26.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Aug 2025 03:26:28 -0700 (PDT)
Message-ID: <fb8216a0-8f47-4129-8b8c-f5d215abddec@redhat.com>
Date: Thu, 7 Aug 2025 12:26:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: do check_huge_anon() with a number been
 passed in
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20250807082707.30647-1-richard.weiyang@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250807082707.30647-1-richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jDJKsz2wv5Umikh28T6po0rbhiMEO8JKbMMpxCz0OHE_1754562389
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2820D120004
X-Stat-Signature: w8bpqqqircuzrnn1kx3txfzy6ukpcpgh
X-HE-Tag: 1754562391-888724
X-HE-Meta: U2FsdGVkX1/elAyc6GV+/bM5tI6kxHouoWDp3kghI+dRW9RdIHvTkUST4lbHcojciSfwx3dLjdTxLcop0ICfuG51dfVV681lepQ9kx+gKJXdDD3NPg5dwcgeT4Bzx7wOyHZWZOqD444Lv20sJie/15CAQkgxMqfI4s/4BV2KT0y+q3gNh9qZFOYcE0MNKo5thM2hQZiHBRrMndz86jENQ1499ASplZrXtXoR9SAk+uaDx3kKMJg0dQcU95sXonHwBJuhTeZai+8HLnAKcrQvxNco4Cu92Y7QCyXeccpi0lcJywJAFqCKlemqQX5TWtWFiENsrjuSOWhok9T1Vbahw9AFG6aUuoUyoFrvqFc2qLWJskRE2J++n35A2+fFM5CsdbvRiLFzrDje/Jd/nl0J35xBUP+Wt5HAZ/udDKP1RbtKUTBeuFz25N+hvfBQKGP2jtXuJ5CxCXpAHWRqE20kNrhoXDd/Iz5kEFWYw4++iHqNokVEX+WIEJSKqwWW/OSC6ezqChVT2yGT/+DaN/CGmm7YkgYEA0IZKR06XplzRmLX0/u6oeYj+IyzWge2L6aQL5/s4GNUAC8wypwjJSBdVxqoiQ3UbAAYa0R3XotfOAGEG5EI+/vZ5vyeaufrTM3JOPtiSw5fC18UNsa8EIXJTMBlq8f9mP3bIRT5vQXBbrFLhVC3CPMicpNN5K/xd9GkDUTsR0io2QdvUg6qBon3SrpQLRyFx2ELsiddXvrRiHxZ03NrBLPzIpluwi8WiWXtF5cWDFwRIupylwXipX2pwe3Zm0YP+2Je/ZQHHo1CQ3uI/9+Pz1IvgsEYbUbFI5hItu4l+nq8AMAMM67wjY6kcYdTJoMDnjvHI+OXMva2/PlLEOT/TkLXC/HtNgCX3SsxpJO2/dXvdvpQBurXDyXtgpTG6ZwFKVJUJ5VQ7Mh/hyjBDcjGFyW1xPpkHRG1pMbunzZk/09azjNxKy0Ewbe
 /M8XpkgS
 Efh7q//H8towJXL0Ng2MjBqnenz5kbjER4uUmIkdYfjm6U2XADH4tavDvlYVnqWT2WE89y30sLoOEQ+5uSuIkuR/LptXVpyQ+FYVn5b0/7hmvy3BtvX5hlGf9EaNEXPg6bzlcOCeqvyv5uslr9oQaTsVt7nfX11ayhw7pNOe90sBFkE3F+b7ezZnhjeOxUqwPXtSrXKlFpDCUpyistf2jSGAIE0hokdgKDhJYcAlDstP8C0YYZazitEizPqPHdeMm+10XqHbqvXWLQCFzST/QOfw0Yy79PpCmN2fmsXU4zAp1sHhqDIvOhUKoA4Jvmvw0kdHFF2AmFMb4+QmElTxNQNBz7T03FB+/3kDIbi8aGr+3BFdMKkrpy/aXy/PHdJ6KiGYJs68GrpIZT/tTueDrH9zoR1sJNZSPqWYcDNBYkAj7FRBq3MTskthWab3wb8dCYBliWbdsoz2zbFdrTlLnTiuKD9EwUDFf9LW/ulQhlHMetwbalw5iABXtO/KfWCbcIg8AnwQ7ikr0cNyvwuGLSY2tpQfn8L/xydaJwz+ai/FTqpK+rPmI4h0Gdr/ZybiOBVtBT6BRxLE8K3pvtxfEH6rrPA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07.08.25 10:27, Wei Yang wrote:
> Currently it hard coded the number of hugepage to check for
> check_huge_anon(), but we already have the number passed in.
> 
> Do the check based on the number of hugepage passed in is more
> reasonable.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


