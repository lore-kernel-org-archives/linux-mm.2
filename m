Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A208ACA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 09:16:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C6B68E0016; Sat, 16 Aug 2025 05:16:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29E928E000F; Sat, 16 Aug 2025 05:16:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B4158E0016; Sat, 16 Aug 2025 05:16:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A44F8E000F
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 05:16:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A53A01603A3
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 09:16:47 +0000 (UTC)
X-FDA: 83782065654.14.E7F5238
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 37DCD40006
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 09:16:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MRN3eaqm;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755335805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IifW0U+JIIVFIZLycwRc5xutdrMY0GnkYxaQl65d4Jk=;
	b=t+q5qeLyL3eLTXgokHvNd+6pCHMhmYQKUHsF9ntpiBmiFEClmpegapXoT+KMCanh1lDbZk
	hrddGI/dZF0OhD37mUjD/C4gyvk9GQq3DHczN/AcXRzrGoJZZDlse8uJj3Id1+oA3bFMjx
	aR/yIVegdumoRCTDGvIBT7weafbTCQo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755335805; a=rsa-sha256;
	cv=none;
	b=CYLD/jB66AVYNA3WTE+ltEQV0WpP/Vep03RCnrh1Aau2MDHVWDE4f5m0PzcYFraY6AUhwa
	sY5q6H8gKX3JHRtF9QGHTw8iye3U/WwY30eJkDDf60IU6nTwtPFai0npbvFJcs+LcnZHmK
	F8v5C5KHRKk7cdrdWfTGb1Blx+gH440=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MRN3eaqm;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755335804;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IifW0U+JIIVFIZLycwRc5xutdrMY0GnkYxaQl65d4Jk=;
	b=MRN3eaqmU9FyX4IyJoPAWmBwtQhxpzjEuJTLsND4MB0h8cWzrwIQyEj5p6Q9oiGWLMeKSU
	hQeoRkSl/JKKo+NN7KXzd2MY/MPEN5TpDPw5cYdQOhbfc3bdvwNo997uAX3RWZtGFZVoyK
	L69gwKbrlvtGPr32qUi5rqUUVm3wZI8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-336-sjwzgg0GPACqJQoBOQH1XQ-1; Sat, 16 Aug 2025 05:16:41 -0400
X-MC-Unique: sjwzgg0GPACqJQoBOQH1XQ-1
X-Mimecast-MFC-AGG-ID: sjwzgg0GPACqJQoBOQH1XQ_1755335801
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1b05b15eso18295295e9.1
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 02:16:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755335801; x=1755940601;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IifW0U+JIIVFIZLycwRc5xutdrMY0GnkYxaQl65d4Jk=;
        b=UnJH5NR2lL7tGWi1b7v8WmOLXsyeF+qC0z6/og/yrvs+AkzYNAejNVIE83n5V0IimU
         XqhhEIZN+vu7fPe44dngcshSgKWWxYhD+OqfyZz5C4VGCfFvARWsNIDPKI8L5I2RL7Pn
         rlLJ/zYGM++NNc3N5P24sH3+WiSFlspJg7K+JnEgQN1bT+ZrZiiyAThW5/VcZaw/Y9E1
         u8Q68Msop5/fMjXJLMj3ZK5ggBVUnnhxTOPqT+W/zky0kXH9wdMM5lknnTnV+kfYqKrx
         K+xYx4UsXwylqnr/Vfrqr22rl96tDhvBqaIRC96hf/fCWlbyHEydfuogh9kv9wt+djRe
         yBPQ==
X-Forwarded-Encrypted: i=1; AJvYcCVl+bL9wRysfbrBRu6KZaM+ryKrGfACDwvgNheWi/VhbFRDiFr1165UD4VkU4150uH3otT1R7vARQ==@kvack.org
X-Gm-Message-State: AOJu0YyTuYDGrHXKMFocb0RBeSF8H+5V7p5H2ZEFI+bP0WC6h3rwR6jV
	CHU1rNSOrTRMO9M+yeKnGcmiSRnB/Moy+KDZsN0pr0tETct7p4jjnsqpKonomDQbZzVDUgbUWCK
	0IBIZ7USe7J3Ev/7YyvFCilfjkhFUOoJH+E965+GsRfr9Qm5uctTvBy3agZc3
X-Gm-Gg: ASbGncvjt3SeFefwE8opAfW3XPf7TkKpcM4lH8xSdXP5I2edeZdD61G9k6JRftz7cY6
	2SF7T6b1+VFnK2Z1GVev8y3I6B+G9MONDckoHc/i2xNCQ1O4Sz9PpA3cyaLE7io0qh2SVB+NFin
	dw+ucWqzJPIbzF4mwsF4dRx6+j8TiWoL+UEwjmnRbC9soaE9Oec/4w1ifKKaLrJmtxbINfcX4ko
	9Arl9TAk0WDpNH0VHBqwnchC6/N1Lh30lVXjCIn43r56xp74gIcvvg5QdycXwYYGEVYwqTDaINC
	rJXQ+RpPqwKrxq1FSxmRScRg4CW65cyiRcVlWjwTOrEkBrx44eCrSIy6O+pfZJlf217kzy85qDW
	bGR+iJ+mlVu+EDyh9BCoJHdc7e4uV94dzbRgCXQIfEo8YanC/p+1+wnTla4lWzsbKxFY=
X-Received: by 2002:a05:600c:4743:b0:458:bb0e:8cda with SMTP id 5b1f17b1804b1-45a2677e324mr15804025e9.17.1755335800622;
        Sat, 16 Aug 2025 02:16:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEsSRaPWIYAU9pr8Z8Zb6D1kwkHVOcIIzDoDi1eX68oviM5dXAAyKumkk479S49NuKTUlt5cA==
X-Received: by 2002:a05:600c:4743:b0:458:bb0e:8cda with SMTP id 5b1f17b1804b1-45a2677e324mr15803775e9.17.1755335800173;
        Sat, 16 Aug 2025 02:16:40 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:c700:d8ae:41bf:492a:9e4c? (p200300d82f23c700d8ae41bf492a9e4c.dip0.t-ipconnect.de. [2003:d8:2f23:c700:d8ae:41bf:492a:9e4c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1cc22739sm94270665e9.27.2025.08.16.02.16.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Aug 2025 02:16:38 -0700 (PDT)
Message-ID: <88117e56-6b81-4601-a954-26d5f630aabd@redhat.com>
Date: Sat, 16 Aug 2025 11:16:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm/rmap: could be partially_mapped only after no
 entire map
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, akpm@linux-foundation.org,
 riel@surriel.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 harry.yoo@oracle.com, linux-mm@kvack.org
References: <20250815084943.23063-1-richard.weiyang@gmail.com>
 <20250815084943.23063-3-richard.weiyang@gmail.com>
 <458c4ea9-1e33-4159-a545-6ad2c5b81add@lucifer.local>
 <15ccbbb0-8ebc-4c50-a1c8-fbe5416ecf46@redhat.com>
 <20250816090654.u5eoys2vkpswe553@master>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250816090654.u5eoys2vkpswe553@master>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mKyhUir1zcGD-3zolHrv5v-p-zTB6RHkXsCcvdrqgaA_1755335801
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 37DCD40006
X-Stat-Signature: ysj7irmn88ro5kzb9bmfcc9pyoi48fkw
X-Rspam-User: 
X-HE-Tag: 1755335805-724240
X-HE-Meta: U2FsdGVkX1+h0cjscQC/7NnOfbDp6XC5xxk4E6YljItLEFRA9WvH59yX7nYxjqdXTSxrdqXfgFbOvaI7D/bqQdhqua7IX3LCwzj9sDhUqPLwoRj7Jz+sxeJ6Dz92KqyhVJ/ujTN8UReZv9q47Wcqo7/p6VMjmsgt7rG0K3K7fswY7NdfWxzdwxBL13E1cdawAg/UVB2ZDbx6RsgBFTxI5MzUYGgS8arWajjOt4GcmPezqH06aeZEWWpxZYOdxQzBMFosVY28mdrPjUgKrjy7ffIgFCWZFbgHOxVBHafG0Tb61Zw844Rdg/cCbiUt8zr/QM5StZO1g7AbV51OIIW2aPIF/pM5OAonT5JO6L4bqh6biNvUyq0gyrho/cI8BXcTmMQ4JCVhG5cL++PIImpbJoipc6VqrpgkYxPDKofw5IUYmxTyWp5U8E1V3F27xtyspuu03XYjUv3Ja/RhWPs3SN9pvZMZsaA/ENowoKl+DoZJCTsotim2Dt/BuevUGYYyvPvwYtjbExMS/jLnVDrGihTCHOrlSEdLw95o7GxvD4JGimdWY8K0Gwr0F9jhX5qYoNy1Re6i9P9CgvrJhE2rqJAl8hvv8KaRiX4tZWDp/wPH33FSB6oFsljD2mT9JbYn5LlKPW0LDrC9A7eal9GcjL5Bir+oWEP461jXHPa0/0QRpu+T8sFLL4I1L5LZOO4PkNhyk9zzKH3E7CvSme2E3/r/qkPdlO72b01DaRlHHT9MT6lJwBYY3IALIDCcJqnJhdTKlyDd5Yz59JcNhvPP9XgVYuqnqDqASOCXR3Tcy0WYQ0DTiNjIHYKyqp0yKWovBcin1ht9HyBtZvaVvPjTdC+LwnxUOc/tUIrOIdUf/bJbuBDC/vPUgZ26OFIf3dozs7ixkMeLknJnEJkHuIyPdcaZHjeprQkX+8BP2EH50kIK6vW/JKCGhr4KiTPftK7obapJotMXfNfHJZRURvr
 E61wCdFW
 z4tyEUxsbr2r940oGK6yREd2I7sz/4oem2e6p//VHTTwGRteo/LugrqdK3OdbDMF7CSD+0xUcqJD+Bxd3SyvZhd46Ge4GjY8WUQe7c2HhBTBdT36WPprXP1Sr4NaIqKFNUwuBLFgE/8+MRyadYPQf5cc9zdv0zcj34GYhieu/z2MLdfA5wlHK13W4lchfkYCLlebsnCUU6R30Na2boB87zMXUK92enJ3jH58hE9wmLXxIDzFSdFc3AA/vCb63mnFPiCZi2wtE57q+3mmMKcjkl1NTQ0YmyfG99scWLjWLynmCKb20YPZUYn3Un/JTTOorol7drdz0/wwv6ijGBqvW+ffswKE7XOmLvoOzIcSSBMUcwn/MgKAmyCgdSqd4DA2ASQIu6DzWtDQj5AiUcs6YhjIxlNtQwlmEtK+5ZXTdBUj5qtcw7CEQzL9nkhMJgCOf7yTr7cUtg85nG7pFJ2Bc9tSPAiSDxM2WVl2R1yHtLOqdV6qB8w4YWSgMl+LU5YMcsdosiJJYCV7K0fO8VKUe6MEqpWnnrQVNTNL88qhW0W3utlSjENUsfRcnqERYiC9+mJb/fdzTraCEkSyc8KLhPQOESJQXslbfi5B57rTNALw1MbYwQjLHXrMie4sYxTC/e2DcAGsbvv52jmAvyOgRZ9BLjRG49oQ6UnQu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.08.25 11:06, Wei Yang wrote:
> On Sat, Aug 16, 2025 at 08:31:59AM +0200, David Hildenbrand wrote:
>> On 15.08.25 12:08, Lorenzo Stoakes wrote:
>>> On Fri, Aug 15, 2025 at 08:49:42AM +0000, Wei Yang wrote:
>>>> If it is not the last entire map, we are sure the folio is not partially
>>>> mapped.
>>>>
>>>> Move the check when there is no entire map.
>>>>
>>>
>>> This one I don't like, you're having to sit and think about why it is that
>>> this would be the case, vs. just unconditionally doing it.
>>>
>>> Again, as mentioned on previous series, just because we could do something
>>> doesn't mean we should, unless there's statistically reliable perf data on
>>> something real-world indicating we _must_, code clarity absolutely beats
>>> everything else on importance.
>>>
>>> So yeah, sorry but no to this patch, please resend with just the two
>>> reviewed (unless David radically disagrees with me :)
>>
>> The compiler can figure out that "nr == 0" if the "if (last)" branch is not
>> taken.
>>
> 
> Per my understanding, last is a run time value. I don't figure out how
> compiler could help here.
> 
> I may miss something. Would you mind giving more hint?

The compiler can figure out that it can move the whole statement to the "if (last)" branch because it knows that nr == 0 otherwise and partially_mapped == 0 already.

Best to see if there is any actual change in generated code, though.

Note that if we're already moving that around, couldn't we move it further in?

diff --git a/mm/rmap.c b/mm/rmap.c
index 0e9c4041f8687..fb83db88cd1fd 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1753,13 +1753,13 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
                                 /* Raced ahead of another remove and an add? */
                                 if (unlikely(nr < 0))
                                         nr = 0;
+                               partially_mapped = nr && nr < nr_pmdmapped;
                         } else {
                                 /* An add of ENTIRELY_MAPPED raced ahead */
                                 nr = 0;
                         }
                 }
  
-               partially_mapped = nr && nr < nr_pmdmapped;
                 break;
         default:
                 BUILD_BUG();


-- 
Cheers

David / dhildenb


