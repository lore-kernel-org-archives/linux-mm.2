Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2DBDC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 12:30:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C38D36B009D; Thu,  3 Sep 2026 08:30:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE65B6B00A5; Thu,  3 Sep 2026 08:30:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD4D96B00A6; Thu,  3 Sep 2026 08:30:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 885436B009D
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:30:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2679D1604E5
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:30:54 +0000 (UTC)
X-FDA: 85172385228.21.9D039EB
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2419880015
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:30:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QLcyF62P;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of eli.billauer@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=eli.billauer@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788438652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=444nNZztaKWrtZLx1q7kQKh1w+9LbHm/QlTHTnrzmNI=;
	b=P1Vqyriv4dmQonh2UwUUe4GclTr/5YUhgrLx+pUHz0mxX3tewklA8ZO/k02mZPM0EVy0rR
	QihD2b8M2XY/v0JxTJCyiMeSZhr7qMiGqhcnX0ZlJ2mCeflTkIEyGFlPw0Qc40GiwhzGw2
	bAO5ThhJm1TmmmRgDptjrsP9i24aaBM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QLcyF62P;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of eli.billauer@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=eli.billauer@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788438652;
	b=KijQnWGHm6WcH6wNsVgwZN/bEuN2StnxRlT/rEUqEWWX88Cb/vCJgffHXjvvC9HQdzrpJN
	wyWUWHwda6Rf+jaLu4u0EdNSQ/G7agCaGsTC4tOIN0Gji/VAVVFN4aJDNRq2sl3oLswihT
	Ce385j3mS86VFPUS5HpAZgkEnCaU7cY=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c20ce3c118aso204181266b.0
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 05:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788438650; x=1789043450; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=444nNZztaKWrtZLx1q7kQKh1w+9LbHm/QlTHTnrzmNI=;
        b=QLcyF62Pv5OTm8WkKErnnqQt84vu7nL42EggLcgjUdRklGeZc7kZZZkTWInQ5rR/Kf
         8cyu2ovBf8/qU/cQR3Q91UCpZzoRucPN+ndSxe99BZTtbL384tmK8/v3ReNaooXUh0zG
         BnkWSRfBjs0SFukl12G+ZgW+BuLU3cBx4emjqsT2gVqTibVG2d+vv0L8p1JXwGa/a6BA
         2LjLeHopyfS9BMrZOeF4ebAqHTF8IxJafnGhwVMy1b9gPup7bNPLjafQYzQILwa3cZ5q
         ss0sPnjbbcnZ+yv1ZVEKnXVgBbxVNS+j7ej3dq28MZNRW5dkPeCpduTccS799qHyRkVm
         8EWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788438650; x=1789043450;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=444nNZztaKWrtZLx1q7kQKh1w+9LbHm/QlTHTnrzmNI=;
        b=HfZxeMFbwEy/QH/53zc+9bN+9PkkfrMyfUovkYbCdUv78YflIBCxUotzPHNf8vGuG5
         Wvt9uhRvBL8Y4+klcNKORymtOq/shyMrrBt9wPZHUYiv/DVdw+lKzLjHG1RQ8u+ZPIeR
         k7k+g8oMuTipYaTdFxvqjxuL4xaFr1TOQ33r5AytQBfBUYbQe8SFPaKWRRoVS2Lxpfbl
         DuEF9BNst9CWVSoTh0Nqg52U0+36Z+RBVtgIJKKRXwsX3DmvmFic8iU5+6pLPA+B9rua
         z1ZVx1IURmL1vOEaS0PCXPnylu5+nTNQHVn52Dhi6AcotbaeK/JfQ0J0P1vSf9/08d4Q
         jivQ==
X-Forwarded-Encrypted: i=1; AKwUvBx/K3BCiYUXcXfhEXMdi2saUvi0t/e4r4uM1esaThB2QBVVJkA6FgNf0RSoQ4LppDN1TMEheO0FwQ==@kvack.org
X-Gm-Message-State: AFuF++kp4/gYyzOiuI3Y3T/4JILPZa55dLxG0DYNf/K6gIBOUNgldgm/
	xC7bSESEt+1y6lBNPo44sXBte1pjP/HD6QgdQDykcGGNT+vUotJU7kdx
X-Gm-Gg: AYBFou33uhUbdgt9VcmIBuQDtqlmjPjzIjFcgy9bllFPzmSk6gA2lt5C40mdu3/XFtu
	7HN5eEG6ZFi7P4cIZUBM1D5gBvL9M/pm60wvaCNYOz1425zqCYTIOYdnLpPYZoV2a08XYL27ZFr
	g3xVtJibEIlTlHSICxd93ekjgkeI8CgdnShpxi6db+y8TKamkfv1ADet90OUt127rZmnojSdKoI
	jAbqmw2n5muSegnVkT0g27IFADyuScR4lb+Kb7fW+ORBlVIsxLKZoM9zS3l6/0JWEv9gyY+d4W+
	TMYJe/9eKWI+p5xAmXDuakEGVmfI4vaQLXpILGCrnpSz34XmIejWTNRY4k0SuEemahcna1S4tme
	2WSO/qN+4T6yPP5nQwSsOQvKeZ8lTEkCuOMFsBMrZgvQnRHtzI6A3HPPI8+ZwfO8Qwv89hcRwBj
	9f9AeRzZ66wtCSUPgyZpRgFUvtVX7RZJdba55G005gcfZ0dqX9zRX0lsk9HXomuB5ccOtLQWnMl
	UsploYPygyMwqZvTQao1I0=
X-Received: by 2002:a17:907:8323:b0:c25:f7dc:2e0 with SMTP id a640c23a62f3a-c25f7dc0985mr85901366b.33.1788438650154;
        Thu, 03 Sep 2026 05:30:50 -0700 (PDT)
Received: from [192.168.1.89] (c-85-228-45-68.bbcust.telenor.se. [85.228.45.68])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a67f895d68sm2265294a12.4.2026.09.03.05.30.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2026 05:30:49 -0700 (PDT)
Message-ID: <1d7f8806-f4a0-fda0-a361-a011460ef308@outbound.gmail.com>
Date: Thu, 3 Sep 2026 14:30:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
From: Eli Billauer <eli.billauer@gmail.com>
Subject: Re: [PATCH 2/4] char: xillybus: replace __get_free_pages() with
 kmalloc()
To: Mike Rapoport <rppt@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>, Arnd Bergmann
 <arnd@arndb.de>, Brad Warrum <bwarrum@linux.ibm.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Michal Simek <michal.simek@amd.com>, Ritu Agarwal <rituagar@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org
References: <20260830-char-misc-v1-0-05e2ce44f291@kernel.org>
 <20260830-char-misc-v1-2-05e2ce44f291@kernel.org>
 <f6001085-9234-4025-ff34-6cc4a66c293a@outbound.gmail.com>
 <20260831123937.32255a49@pumpkin> <apaF1HUtJnstuUN4@kernel.org>
 <1729fb06-6beb-f8ef-3e71-47fc3f00345d@outbound.gmail.com>
 <apcPg_y-HsMki7we@kernel.org>
 <9a3d6a08-339c-3315-cc81-46907d0836ad@outbound.gmail.com>
 <apgSCyj-h2xVc2ss@kernel.org>
Content-Language: en-US
In-Reply-To: <apgSCyj-h2xVc2ss@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2419880015
X-Stat-Signature: tes77anq6jj467c57ngu8y1e4j8zsxnj
X-Rspam-User: 
X-HE-Tag: 1788438651-134678
X-HE-Meta: U2FsdGVkX1+Q8dqKpSCbB5aDz45rUbYGBXk+IKawfbpBaH/K17k1a0vTGOd+nc9SOvgtrRj6t4fxOY95xvEP7MtoicFz+pJnTJKEgOFA1kZUGoj8UXrPc0SGWRT/GFG9eGfnU8Fgz8EXUJ/uHWk18liDkkXE+5S2X4qfeakfWEXsVz9EUg8Ewd4Gd8fsgFFdIYP8THz/65n4Xev3OByEAursKFkTdH/E6111tts6laAmK3emnsZ+KGj33jMCaTQusLiQG2QXpdmfyYXsjtzZe2H99cS/1p2EG29XQ3RdnC1s62WNgDe2EQMEPYqro4i3UVxswzpaIBqZt+eW5C3pOav7Oe+Bjh7O3ZTkSWafGgVdv9IxuP1CVH5b6TzFQ2aAwztfcRhmpUHB1hbYgAld2ydA6mmDCkUPWGT/NT1MJkLPMIc51OBGp8M18Y95Q0N1inArpY5eJHkWIIwPEDCTDcQVIZwpzNrd/qAlVVzynUXWixKcuLpCgeV4bdUC39u5mMbANVXePdLuggt8l8Vj/4+Y8Zxp1gVN7h5CIVhNpP1P6miLxA0Cicq9PgOFFeNZaLVEG9BDRKk83IG/s/OJ/+2tj831gh4gVsQPNAXRU7Q5rvi3txHZVEvJv6vO9oYiIW5oFJ9DgO78m6uH0kPEf4IbDF82Xi5V4BxUq1+wMZnH9UvC5e5hMpxRGh4IqeYlJL+ZfzrPuRego9RhVLekzthvly95YmwqUoI6vnM8lnpwl+ZKP3XLVsgzMVsPM0IPta19hqPByzjaLnzMFrbTdBpLgsmJ5YyQuJHztGTQQwRYwjyluRPw1AFu8fnwTU/bY3SS+OiHA7X5YbZCCP0EMKsehiK3yRvNAtuIr2tk3kpl06ACEMSb+/6qbK6lT6y8NAiSMzZHcsKi6psmDN1ZTDZsTeDi6Bc2h6N5l24l2jv/NMwxxTiZ0xRzVth1N7eC/4kQJKltZ/z4v3iMeoz
 WVXoBWD0
 MBgo7s+bmT35rNlVj27WDnq4QynElLoiHl3yhIJ92bmhvMYIe7Eceij+dVF0ng7KMwkuJGlfZfQqT+vXGl/1cICEbCkIv1ImFsb/UbmZtaSd91YU3+ZI7dApahOkaQa6DK8K2s06AR+x32cba0Yk47cSbP8ONojdvm77FpJQqktwvQUiy93U02abc20QO7P5NT6jNl6AhnpeWJa72nfRUyWe2SqyoJ49YsAo4LiRvEkZTw4anbE42AY9490EEKN6G9H+QZBgQIpt4fnNg0miV2P+68AeNlrNeWlXrKKY2e7ABY3H4pbiPIIUMyCwGpvPJqOrItJtB1g/29eot3pv7bMD7XqDenXwG4xm8AprJNuW3EJgAw5Q2fh3Lp7kLxX9AlipxyUW94Cc4TN+tVHnCcZ4nmUwgfJVksTOS9trHpLnAPWmmCeCMfe8iI3TeUN6BsqDFmOgj7TWlfhpLbpVnnUxIFQ8nZVsBxD6s2j5aqm1L4PRwwHS0QPl+SFflw1MhgdId41LiY7g7e/fHKfMijjmCVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02/09/2026 14:09, Mike Rapoport wrote:
>> So using vmalloc() may result in a malfunction in the data transport where
>> the __get_free_pages() would have been successful. This outweighs the
>> benefit of a somewhat higher probability of success in allocating very large
>> buffers, and surely the improved aesthetics of the kernel code.
> kmalloc() still works, just like __get_free_pages()
>   

After these few days of discussion, this is what I make of this topic.

The memory allocation in fifo_init() is somewhat ugly, but this driver 
has been out there for five years, and no complaints from users.

The vmalloc() option may be successful sometimes where the current 
allocation will not. On the other hand, there is a possibility that it 
will cause real trouble with page faults. Plus, a large allocation with 
vmalloc() may be a weak spot on a platform to which the kernel is 
partially or poorly ported.

With __get_free_pages(), there is no doubt that usable memory is 
allocated right away, and that it will work that way on every single 
esoteric platform. vmalloc() leaves us with "we're pretty sure there is 
probably no problem".

So I vote against vmalloc().

As for replacing __get_free_pages() with kmalloc(), it's a matter of 
taste. I think that if you're after a buffer that has a power-of-two 
number of pages, __get_free_pages() is the natural choice, and using it 
makes it easier for the reader to understand what you're doing. 
Replacing it with a kmalloc() is confusing in my opinion, and requires 
that the reader is aware that kmalloc() falls back to __get_free_pages() 
in this case. So we actually want __get_free_pages(), but call kmalloc() 
instead and let it fall back to __get_free_pages() so we don't have a 
cast and don't need to save the order, and assume that everyone knows 
that this is equivalent.

So I vote against the kmalloc() thing as well.

If this patch is part of a larger kernel cleanup, I suppose my votes 
don't count for much. But for the record, this is my opinion.

Thanks and regards,
    Eli

