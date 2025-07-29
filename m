Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E248C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 09:21:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F9766B009F; Tue, 29 Jul 2025 05:21:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D0FD6B00A0; Tue, 29 Jul 2025 05:21:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BF936B00A1; Tue, 29 Jul 2025 05:21:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0999E6B009F
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:21:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 763F4805A6
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:21:15 +0000 (UTC)
X-FDA: 83716758510.12.4F49367
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6871640007
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:21:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KJNSbLVF;
	spf=pass (imf17.hostedemail.com: domain of asml.silence@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=asml.silence@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753780873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2u4rjqAF5Zc7Kz0jelPex7W70gE8IrEqV1bRA0AwlWo=;
	b=Q8U+IcgQRjSHpht60o4TN9ZkH0SnRN9TgILp24jPDWaj4kyrA3sT5+GZKkXDDc4qv+FeCj
	T8bPXhpibQQXv7Y8kHWtag6dzkmi59DK61F33la5WAbTfwsiaoU5hyTYsCAshfjati918T
	V9HcOvF4Wy2bvRdvQAO74+z0MzZMVmI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753780873; a=rsa-sha256;
	cv=none;
	b=WObw4rXCMKlrJASjezjp8uuZir9v9aWkn0mpE1fc0r3B27jPn5zuzwVcdupR7Bq2v7G1kh
	gQLG18WCvwrX02cfYubvjvHjVoqXWx2tU+SIx3R8U/9FT89Vgij1p3VDudS25oU/r/O+HH
	iDB7KkjCr61wrLrXrM9cPKS2rBRqA54=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KJNSbLVF;
	spf=pass (imf17.hostedemail.com: domain of asml.silence@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=asml.silence@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-451dbe494d6so58652745e9.1
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 02:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753780872; x=1754385672; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2u4rjqAF5Zc7Kz0jelPex7W70gE8IrEqV1bRA0AwlWo=;
        b=KJNSbLVFx57PdFKsBlaXXsMOVt82dWyzJnBtPIpZ5JHuyE1aJjjhOcNCzmMKebs9wU
         7PMjdyVOLGDw0v+92BjTjjM0BMvnYExcuV30I9Jm7nsGQJ4Mpj5xtRJ6Kr63B/UzLae5
         da7Itxemln9/eQKhuVYjZ+CWSQlDCV5s9ek21gKWtc3BVAdQfaVLCTQk1Si2+UZsRoNE
         c/Ndpb1VjENTRoYBWoP6MoGDSsZjUf6vHC6dNAQUOFp/FxMOzviKxToVMiyablW5q+JG
         MFoIQNrG0Es9EpxgWtrZOdo+jhTubtwVstE1D92h6fACoTa9dqtZK8v0IQcYSxk2Binw
         GmxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753780872; x=1754385672;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2u4rjqAF5Zc7Kz0jelPex7W70gE8IrEqV1bRA0AwlWo=;
        b=Dz8A92+MygQcSi+VW+tOecuXEA8Xp5tPHGT0zeHOrjieURJes/MrE2tGgU04yw6gdD
         mjOg6cUfPPZwfLfxWfstq3UWbeLtPgW9JxbNmEuOx72vxv5/mB+j7EIASzdU663rjqAD
         L7N9ac0D2qY303zWqUT0rt4evrEcPLFcI5j5oVFJ1oN6PGInBElu9HH6+H9TmOaDixBb
         LKEhfgUhqsCYbFGf9Csq/c1FFi/AshpNvAMf+ghc8UoYTO7zOReX6d/nNtDA4MQIpPSJ
         Bx2IjxrKB7FHScho9dC1+/eE3cNKNHPDZ0ibMPY8nx/KJyNp3ZPbf8MW4JQPlu+40R8h
         Lsbw==
X-Gm-Message-State: AOJu0YxCKFg0Qv0FrDzvszdPlnZKqm9o4VYZ7bNH82xjnv49AmiHHXvQ
	LAtQtC/CxRZQuVuvzJHx2+oi5iqp2KpEPrI4vN4/YH3KX1aXbglDCSJT
X-Gm-Gg: ASbGncttYtKnhCaF/yu0KhMf5lYfSMZv9e1diseD/ex3GST5WadNJANWe5+XpkyNr3r
	lsyuQaBVn/0xtf58uXlj6pOBqcTqY0+covp6jO+Hp4Rdv7KygWkkZTGROUJM9N5EynqRtPFWePI
	dGbaZMh24Z7rGNBfQCenTyJisOwgIk2VPlXeOQ5Kcg/bmG2fa8Aa+5NsW17+LGoZ/8ixynCZkKH
	LyEoxTtcInUR2en9BYW1qZXZYJjlv2om80zqvS9SG+KzBCm5k4X+wlqM2CwwIwC9pMRyaireSMI
	991mKE4Ouw8uzldk8WWQfVrT0uYbJASkVSHXCrBoOTKopzSaZ9fJLMcAZFeqltfL1Af9sguU1VU
	76w3kqcH310g+r0z3oIB//o+sXDsw/FE0QhI=
X-Google-Smtp-Source: AGHT+IEMHicGGzOV7QARfXRDayyJkBXpLEq9lHyvKxQ609TVgvsTQ+QeaMTZZwxl6gjtb3oKoyYgXw==
X-Received: by 2002:a05:600c:4513:b0:43c:ee3f:2c3 with SMTP id 5b1f17b1804b1-4587630a123mr108515205e9.7.1753780871722;
        Tue, 29 Jul 2025 02:21:11 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::26f? ([2620:10d:c092:600::1:72ea])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4588e5b7722sm17504375e9.3.2025.07.29.02.21.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jul 2025 02:21:11 -0700 (PDT)
Message-ID: <18eb9e6c-1d60-4db1-81e1-6bce22425afe@gmail.com>
Date: Tue, 29 Jul 2025 10:22:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm, page_pool: introduce a new page type for page pool
 in page type
To: Byungchul Park <byungchul@sk.com>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel_team@skhynix.com, harry.yoo@oracle.com, ast@kernel.org,
 daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
 akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, ilias.apalodimas@linaro.org, willy@infradead.org,
 brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
 usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
 almasrymina@google.com, toke@redhat.com, bpf@vger.kernel.org,
 linux-rdma@vger.kernel.org
References: <20250728052742.81294-1-byungchul@sk.com>
 <fc1ed731-33f8-4754-949f-2c7e3ed76c7b@gmail.com>
 <20250729011941.GA74655@system.software.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250729011941.GA74655@system.software.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6871640007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: azojzynh1r5x8ish7cd6tsmo8zpqwc6j
X-HE-Tag: 1753780873-978807
X-HE-Meta: U2FsdGVkX18Jkcye6jF+mTUn+4ZL8Wa00GJrhW8pyy8e1sgzbA/IOBYEvBAX3SrATP+6i18b35FNWZnCy8IPQe2zAX1Uyu01SLs/FVThoK0OdccfFK/Wk8t88z1yWsjbPDnAUvJPuc9chu6RNOxxBYdovmAqhhoZYncH8zS8xqkoR4pDy25b0MUZnYyOzL6rpj2Fba1E6CXK4ecM8W2W0+9OUhFjW4eskLHh3rW75YHaoXLI6jZN5do59rsNrtzH61cieumCrEXlbtuZUkt3OCclgzMUEkC1dHQ0G6J/jJLAlba73j8nQkdOTitTqaHs0e0t6FDeMtPGABwjHnoFPLhr+zkPelCzt6j04B6VM8PiOnc1yWoYeJ7i+4+cl+uobS9cr7ZjcR53inBOiy/jSZ5gT2lCozVUdZINeZisHaaLqBswwfPR9MmNVX2WivkZsd2OeS/fu/RHtz172FSEFTPUwPTQ9IsXENl1sH6OdKCe3hpQQvdJch9hpEx54+jEx5ZAu+edhXFH4qjoZzKBUVvrS95wzS3GDpaQL4wDwJN+nyZ61PQfK/5TSF7wplLLVMW4xoEbuwHY3XYMqClUW+XyOE5fO+1jlrW0gOgApms5Myoqn8vROTwIPGyF1lPRBzyviXO9NVt69cT4QsYITlrZTr+uIIFIBAlcDn4AmWW4g46MMiNJNJm0L4Bx7NbNBnXLGgHS1rKf6DiMEwzf09ZeF3j1BzLqEJK8x3nuGzTyFkNsgveTlwqiFBtOIZt0Fkvj1s2WKKBheNg1FLgtdBdEgoYJu/tYPau/QfptIXd+t+GUykzwILFnfFj2W3RcZSjdhIZwAr4u929yiifyf22aNhb2Kqh8BfzKkjhciPTR6r3aBOJBxUzZr7kMZv28KRkEo3DbILonyxm/pZBv6jM2+nbUHMVoYoohZiqLNHltPDFJy7iDrQtDw2orzotgDERwY1tP1tO78lUW4QY
 UWuFY/t9
 8q0UA39HwWI9XQayhLPX5yd0PuzGmDQj51ARgaN8dEzCVbMuAIDXSrc3giuIx20Atl/sHmCisW299lmRI6RLq+hiipmUrxwZQUxbYmwNmCEOVv+dQaGnuiQMVk3Qh7cfxy4U75IVnaIZI/+9AKkAUpKj1Ch6mN6yzdHq/fZjsCf7687mliaKglNQaOV+SulqsS/1nq4bsg8arrpOi4yDdv3wXuDGCfXIPByilcZMSyTBu6s+P98lMcqEThAeh/LRaQ9ZMdKZfstEaFXycDPFy+Fmwf1OB8njIEd2IR9eEkaNgG5CZWgpO+nhKkuKex1RecM7fReg6QbDUYGYw1Oz6VMaUOhqhqFJYlcgpA4FQCqjf92dGEKjDl4a1KzhVSAbUDNxwXtDE48X6W7nd+3zUJDzqp9DOvzt9cmxiIoIwLdR+56TKf7N/VvAhw1gAx21vrI9tWKoEzX5UdJ4GuPwP7EyjHD8PdVYV6YvxbsQdehHDx9j38YyUuZvo4mhysuQIOwOQfjhhDk8j39D2HVhO+BvhuU+YzFO14KiXQbq2Sut3eccFTB5EPC3cEa2xKxofeA1HREG6fVZ7bXkEfw0NL+hqRxVzro4tQGUru2FUnjz4gg6S655c52iIEdV1kK8qVLqjojvB3K+njdmyilLkuR1zSMoOP/E0PFjFmUVFw9uC/VBH6DVquwKgnDBl4+vK6AhAReyPW4N3LxN8oLj3zWCgFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/25 02:19, Byungchul Park wrote:
> On Mon, Jul 28, 2025 at 07:36:54PM +0100, Pavel Begunkov wrote:
>> On 7/28/25 06:27, Byungchul Park wrote:
>>> Changes from v1:
>>>        1. Rebase on linux-next.
>>
>> net-next is closed, looks like until August 11.
> 
> Worth noting, this is based on linux-next, not net-next :-)

It doesn't matter, you're still sending it to be merged into
the net tree. Please read

https://docs.kernel.org/process/maintainer-netdev.html

Especially the "git-trees-and-patch-flow" section.

-- 
Pavel Begunkov


