Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DF34CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 10:12:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A496D8E000A; Wed,  3 Sep 2025 06:12:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A21568E0001; Wed,  3 Sep 2025 06:12:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90FAF8E000A; Wed,  3 Sep 2025 06:12:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F61E8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 06:12:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 22FB659E2B
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:12:40 +0000 (UTC)
X-FDA: 83847524880.04.252F07A
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id 419A7100009
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:12:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="OYI/8nZ9";
	spf=pass (imf14.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756894358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i8uhAjylvoVrHqyo5ZUv42JCVbxiwoWLZQPmGOY7qt0=;
	b=vRbKq9aB4oHv3mrAcrAs1CpKxAdEOu9TRaQdgIT3osERpAixV7EdIDOpnvl2EXdXqtDSNs
	Gve305abpM8+iSkSHnA0Kqxel9agqKAbHnbzGqna4qOZfy6U+NrWYODFxggRS4SbdH9R/r
	X4vWx1s3SBvmuOdTyOK5t06KBwfJNvE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756894358; a=rsa-sha256;
	cv=none;
	b=TZZrIbC5yCqw3wdCchX8+uWfafg/9CQKdZx5yqIKgQywnw9CgkBVgjNWUDdNaNtO+UaEiD
	b8MtVVLjoSxSTnyFyq4L89AoP9y3ED7Ba8QH+4FKhfQWiUbfQV8/MFth59ATq/UxJ/YjMs
	j2p4fgpDITsCXXvSqQD6D5INB7De5mY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="OYI/8nZ9";
	spf=pass (imf14.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3df726ecff3so166891f8f.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 03:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756894357; x=1757499157; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i8uhAjylvoVrHqyo5ZUv42JCVbxiwoWLZQPmGOY7qt0=;
        b=OYI/8nZ9ox5IVQHXSOA1mTYahAnE/BlVU9TX4hHMdGk6YHugZLfWDQoXfNN22/CD8M
         a8mUStWcXJ3gr5GsEySgz+QYetWeqM06oHBB/6SkkomnfORbqVzMmzMVOZ7c5V5BDvP5
         Fpm0UdsN4XuoMH0ktDDhtNBzmqClCaxd7lA2zE8u51d+Z0NaIa5JkRffa/EZmQMA193a
         bhGP/j342gxavvja9oKzyA324dvvfbw1h1zWcDNq5LPRdV7tka3IGfxLqAlZBHZmXDDC
         Yg6wNJq5y0afwAMQeBJC/gaD73w/MxRVQjoCMT74sUvQISH6QvtVB2zg+7HDOdfcm0SG
         HrnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756894357; x=1757499157;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i8uhAjylvoVrHqyo5ZUv42JCVbxiwoWLZQPmGOY7qt0=;
        b=tafcil4WAUzt+wkJq/smHfaBYNU9e2i2H3IbKvZS7jRYwYIA/npefW17ZWHLoPoPgR
         SG5EK5crGl0dwNuG/P2RnYpb+kq44BvArKcxBEV2uQq8G6NivDPwVilaqcEpQw5JvdRP
         ygdj2aLClINXONdoqQZvGi/s7AZp+lvlGeUaQy+xqWO0BtFYQMbV5c2/cy3YYJa7/XeP
         4Bjl3rS2l9A1p3AcBnt5GRVGX/tQivlTXLK8pDqAHbYJkhlQ/fbMtw5ri4PDxn6cgW58
         Pz+hB5ngIvb+6ZpfIi2Z8tGWj4GJXWXblXmc3blk20kBmv+2hL78scN280r27MYWuM0Z
         EdmA==
X-Forwarded-Encrypted: i=1; AJvYcCW4jW0CXrzXrncNq549dPa4KcUJtNZoyOROH/IHTr4W3pFbr7sRnKip/WPcYHdmUQt/U4DIWREE9Q==@kvack.org
X-Gm-Message-State: AOJu0Yzd6kEJ/K9pX8iKhp8ji47FaAhJgYUmcUftzWHeFlrmuzl3h6SO
	lru/cBMP9+N1XqxnmI6rTzdtgnFJCvR2LPvfNnSb1p7O6jY+AAxfUnYG
X-Gm-Gg: ASbGncsiB+txz3aD8HunY/74iYfCxmej5RJ2u+GTRGZy9HQlgupYeRddG8LIaqPpQ7J
	iKGFZQKz8OZTLzVD7zXvWRTlxNmZm4L8C6ePCZtpe/J7h5+ef6OmJTrteATQRE20sZVsy24A9Me
	KY4qlyxptDxjsKsR+rsc0rQCXSBBSkudE6JCHQMDmEFLwGQNvIADJyQJFtuPB7x9F5rkPbKJfG2
	2YS1TKF7N9cRegOEmQiGF8CnisjNOJbv8cHcAhf443CID9n8ZNe8BH+wUFBRU/3ZtK32g6GaLBm
	KaN+AfwD74ZE3UyeAfEmWEXmN7xntwvgJFaIT5oUrrS6KEP+orf5IOrhbD7Gv+b9x/9+HN7G81e
	zdY5QjQxMDVnx4Tifbhhszcb6hmIemwGOqGdtQWn6cadia5UZxZT5yJdcAjs7mPn2M1BWkCOyLj
	84vnQ4Lp0TGsGrT6m2upg2Co/DZAgV
X-Google-Smtp-Source: AGHT+IE3yDc0JkXnbZqFC6e0eSS+b5+7EfRLakK4b6SwX/VLFPhD7NsTncGY5tJmDk2PfOW4gerV8A==
X-Received: by 2002:a05:6000:24c4:b0:3d6:3af4:7cd9 with SMTP id ffacd0b85a97d-3d63af4818emr10067725f8f.12.1756894356454;
        Wed, 03 Sep 2025 03:12:36 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e759:7e00:1047:5c2a:74d8:1f23? ([2a02:6b6f:e759:7e00:1047:5c2a:74d8:1f23])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf33fb9db4sm23054884f8f.47.2025.09.03.03.12.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 03:12:35 -0700 (PDT)
Message-ID: <b0d0ac81-0901-4ef7-a40c-bc3f5022c6d5@gmail.com>
Date: Wed, 3 Sep 2025 11:12:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/show_mem: Dump the status of the mem alloc
 profiling before printing
Content-Language: en-GB
To: Yueyang Pan <pyyjason@gmail.com>, Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Vishal Moola <vishal.moola@gmail.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 kernel-team@meta.com, linux-kernel@vger.kernel.org
References: <cover.1756827906.git.pyyjason@gmail.com>
 <8dc71d31de53afa4c0bb25234807b1e6ead5ba55.1756827906.git.pyyjason@gmail.com>
 <ef1b79ab-15cb-4720-ab05-d77617143a26@suse.cz>
 <aLgLoal9q7Zx7Yto@devbig569.cln6.facebook.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <aLgLoal9q7Zx7Yto@devbig569.cln6.facebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 419A7100009
X-Stat-Signature: 8hkkfuh3j8tr4kxsm4f4qi1artpz4d7o
X-Rspam-User: 
X-HE-Tag: 1756894358-63931
X-HE-Meta: U2FsdGVkX19KF1dJPp0oaP4zjLQJ2CipQZOGzCt1yHx0uWzpJlpQkOOp6cb9bJhmC1hQMAqPjcrPqz2JGMy+Gabx/t/6JGR5qNScRmR3P0ApCrb8UXyP9E4M+AV+noASge6CKbfFCuez9JgsDYCxxNcO9SNhuqJdZVOnc1Aciv/Dr0Xb1+UzGzlgXZdXFXtrdvVbViY5Ovra6KHpgLB268bgvvlB1OPwE4Jmza1w5gCkz/baJfGbixaPfZTfJMVso95m9WVJSLa4z6ojuwktLCh2bp8us81xtSFW+0OstafRtg8akyUCHYKukdbr46mbXq629mbmAeQeJMXL7tYjyReG6phcVHGRrseR7CN+RnewITNt7VlJKx+JdNYus7rExxua4M97g+/X/Iz6lR+4bZB2jqhYpww0U5PEE5bB2dsE6xLnc1qIg5TQ3p5RZfW0pALHAWriPaPgWUn7YPqbQLmd7wC4O5Pf4gcTc+In68e4r6pu1H2EC09jUpywT79Ywk1Ef1UmfTlGEneO3d6VYjrS15SucvQbeZ3hvKrWlEKr43rpJQlDBM+B2V+knBZtcgOThjGa2ulRHK/rv2ZamMuCOMHQ7SBjA/U07xGoV5pY99ybqErQVnTSsy4Xvq86GtnWMLykQPX71fR45StdCh+Gp7o3TXnpKNGZTDpY92sYisjqxYvAxGQhfkFDmOYBJt2ahqI7O7IoagueWZZdTLl9OD2hxHghAmMiJgBa3/P4EE/xcsdHhF/K0AC69DGPa2TYa0LcvY0X97YZn1OBasOhw0Njrz2t+oSt84lm+ISYPm5NmZ7qZGSVi89pyarypi0QGgwKqM/1x1+vbAvOiuPgoPCYfF4WkaF+qeL//43WhP6dlq4YtMhkHQqQAkxLBZNorqhXDT98TaWJ1h8m4jKYw2OK+R7wXz+mY2N4dYassC3LeEy+bJSAFxUxM6lZ1km6HraQUU848OnWf2l
 iXRiRXMM
 TOzuc816XKRWT4eno97OC7yGZ6CxJI7p+jP11JD8C7710UytPNMIqIUwBWS0A4ZkiAziv9WELQrnZbYE5SPOegqIbC39QAmPo7ILumuDOfN4o1AX5/nw3bx+eO6boDGP3DMauZsGUnmVslLgVaJbTi0i0nPsOkO1o4EZel5ia3hopiOk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 03/09/2025 10:34, Yueyang Pan wrote:
> On Wed, Sep 03, 2025 at 11:26:01AM +0200, Vlastimil Babka wrote:
>> On 9/2/25 17:57, Yueyang Pan wrote:
>>> This patch prints the status of the memory allocation profiling
>>> before __show_mem actually prints the detailed allocation info.
>>> This way will let us know the `0B` we saw in allocation info is
>>> because the profiling is disabled or the allocation is actually
>>> 0B.
>>>
>>> Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
>>> ---
>>>  mm/show_mem.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/mm/show_mem.c b/mm/show_mem.c
>>> index ecf20a93ea54..51892ce2efc4 100644
>>> --- a/mm/show_mem.c
>>> +++ b/mm/show_mem.c
>>> @@ -427,6 +427,8 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
>>>  
>>>  		nr = alloc_tag_top_users(tags, ARRAY_SIZE(tags), false);
>>>  		if (nr) {
>>> +			pr_notice("Memory alloction profiling is turned %s\n",
>>
>> There's a typo "alloction".
> 
> Nice catch. Thanks!
> 
>>
>>> +				mem_alloc_profiling_enabled() ? "on" : "off");
>>>  			pr_notice("Memory allocations:\n");
>>
>> But I think the message would be more obvious if it said e.g.:
>>
>> "Memory allocations (profiling is currently [on/off]):"
> 
> I can change it in the next version. I saw Andrew gave approval. In this case, shall 
> I send v3 or create a new patch?
> 

Send a v3 as a change is needed in both patches.

>>
>>>  			for (i = 0; i < nr; i++) {
>>>  				struct codetag *ct = tags[i].ct;
>>
> 
> Thanks
> Pan


