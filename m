Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CD41CD8CA8
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 02:46:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8554F6B0005; Sun, 14 Jun 2026 22:46:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806026B008A; Sun, 14 Jun 2026 22:46:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F46D6B008C; Sun, 14 Jun 2026 22:46:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 537366B0005
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 22:46:02 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D50571208AC
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 02:46:01 +0000 (UTC)
X-FDA: 84880607322.23.6E7B148
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id EC6F0180008
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 02:45:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=l1QrTWvs;
	spf=pass (imf16.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781491560;
	b=gP1mtPkIsMkUmWtmEB/jDbgNIkFeIsp+99m1xEKuGkksApDHecrG0j74ywWEQpI1YTIpw/
	D8gItWAUjfXvkXxfO8X49sODdz3Nn3GNBhGRh+SibMogTqaHcPYNREwpp03GSkqAP7zZtN
	fYjvORbL8l5yFkVKOusKFwyMEZ1MZ2U=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=l1QrTWvs;
	spf=pass (imf16.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781491560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e8NLHGVjFApYnrN7TuvQPcE5946BfMaA9XvCk6482m8=;
	b=aYW5X60Bk+NMWywHhNmLkyszogoR6byElifOIcM73d/DpKzNKWqFkl7ur2nRMrRtqwb+Lc
	lpF0a5mxvqQa3CIoqOGJixDfMr3w2DY1/+K1O1oKZXPRMMvAZogUN5tBR2dv2G9N/AkLoZ
	B+6Rh/PrYdWweHnC873qMDR7AUARNBk=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-842338c18e0so2025411b3a.1
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 19:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781491559; x=1782096359; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e8NLHGVjFApYnrN7TuvQPcE5946BfMaA9XvCk6482m8=;
        b=l1QrTWvsmpvR0UMR1RmNE/0rfBLfI2D9CeU+BUKgf93CBwTC9G14jzC5TjcvQs/ptv
         7Qujhd6jSpqAOTYCN9WB395wSq3sTzS+lRv6z+h01X+jA5TIEcx13tqmACB6co2bTIIf
         ZQKRfoNhnKNAnQj0bgeMawgeS2oKkeF3fBnDR6LN9NcM8Be5E0eAycHoStt+JZMHfGSh
         W/IKZcjlvVbmEjgrNk6o9kPwIhz3sXJrx0/+GEKVj6ylnY0UpmXf5xYvNLbiv9+UnMlK
         RivqrC2fvNDy8GCh3jz3inZJp2G7m7Yu9r+Ty+UsrKkQzCgDWuOz9M/nju/O/Hyqckts
         fLqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781491559; x=1782096359;
        h=content-transfer-encoding:in-reply-to:references:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e8NLHGVjFApYnrN7TuvQPcE5946BfMaA9XvCk6482m8=;
        b=kJ1WgB1Y69G3cFumlvZ0FXge/BpLtAxTKopFsLJl/cvD2gRKw8FbDfjwA5ZpUsJyU7
         My3uAYvS1NNddjtJSBJwxYAgYYGLvGnUBvPwlC88ockybMvlciRfaRc+xoBdaVF3zIoR
         8F2PWdMA0LTXQBCa5cVZWPY7wpxNKSgMhreBTqK11GEs7dQw1O1OfLlPMehqHQRbS8Cx
         h9z7a4h+9xCWFaMfSp7Z2cy1enQNmojkrPztzUy52AroLeeDfuLa81QS1aibFHA50s47
         V53BinaZf0qcpGYb2KRicld3KFBiHiv5e9en3ggVGxQae40kekEWtxewjCbqfiAMN6ib
         AHjA==
X-Forwarded-Encrypted: i=1; AFNElJ+sM6sxOEwoATAS8P6g7V+xxs+Ua4Zz0HFbgBV/YBVzRmuZ8yfX6XZTsbFQvkAjuOeTzU5wB5J7lA==@kvack.org
X-Gm-Message-State: AOJu0YyKjeAyAbv9+KMX/l2BSA5276U2HQ2Qahc/K6c4XvoMHaFESuOb
	cE3EGqLth1QIk2NxTLwGtslj0EsiSwHQtJ4Wd3lY+WMIhU9Oi4FS9nDR
X-Gm-Gg: Acq92OHkcK6RMECXADUyF2aKJe+JPwb8X7uy6d3V3wMGUH4hCyd00FjMKScGK/zPa3N
	FCsyvFy0CfhqyEX1CEaFb+B5zw3Bj5OWcSmRe2lThnCYkbVlxficsF/wwK9Sl+yl+REwB63A80D
	fEvKo5RanmXw/RL5+4zHULHyp5/CZTzbLNFyRCiEcdW4J+hdkwdWVILGE+jSZva+du940+KTffU
	4xlXI08owFHLHVlCjkSsjf+eoSOlDpvZVQRna4nOcNS37zpvvHOGVNqQskdcX/G9czEPxoIkkmz
	PEx1WY0Wc4BHVeKFJsAoJmWKRKYYWCAuMiry47Uc1HmfQiz1lCQNCWca4To52p+8T+KswfhhXpB
	hJSQMwMbh5DyupVZyNyswznzKwebrKFWCzo6/dv99RitQiiaa5IfWgulN2w4jq1i4/GI+4uMdPp
	mDxbhXD0TXSbjeRlU48JZ5CNcoPSPTrY1rqgfbdvkvnYM8crd+tg==
X-Received: by 2002:a05:6a00:400b:b0:83a:3135:edbd with SMTP id d2e1a72fcca58-844e1931335mr9663347b3a.7.1781491558659;
        Sun, 14 Jun 2026 19:45:58 -0700 (PDT)
Received: from [10.125.192.102] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434b05921bsm8343847b3a.59.2026.06.14.19.45.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Jun 2026 19:45:58 -0700 (PDT)
Message-ID: <128c28a1-71b5-d435-fb1a-9882c23727ca@gmail.com>
Date: Mon, 15 Jun 2026 10:45:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
From: Hao Jia <jiahao.kernel@gmail.com>
Subject: Re: [PATCH v3 1/4] mm/zswap: Make shrink_worker writeback cursor
 per-memcg
To: Yosry Ahmed <yosry@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, tj@kernel.org,
 hannes@cmpxchg.org, mhocko@kernel.org, mkoutny@suse.com,
 chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
References: <9898f83d-fae9-e284-6b85-c7f4089840a0@gmail.com>
 <CAO9r8zPBH6-0SQ6-_ZOhTQeyu=rz4F=ugikCrU-JR_skm6fEWA@mail.gmail.com>
 <a60eedb6-f3fd-4092-b726-04a17a695ace@gmail.com>
 <CAKEwX=MQ3xXBAY-2H8vA+XSX5GHNBubJ2GCYAXGD+Hra++ZM7A@mail.gmail.com>
 <90730fa7-62e7-d5f4-b638-23b22a8509f2@gmail.com>
 <CAKEwX=PF9hfERC_QMq+rjkSc-BsJyawMgTe+EhwR_86HiQKm=Q@mail.gmail.com>
 <CAO9r8zN6VVZz7dpjNrh8n7wbLkqcrsROPm70MQQxO49HJSmMFw@mail.gmail.com>
 <CAKEwX=MCFbsh9ndBtR0-bGRr_=v-6bBwTo=muzd9ZSD-LAK1nQ@mail.gmail.com>
 <1c25650e-bf98-2863-d505-9b94c385668b@gmail.com>
 <airypNnKrJJ54k_0@google.com> <aiw2JB1lZV9xuNSp@linux.dev>
 <CAO9r8zM=CMtUfV0RX3YyztqMNcw=s8M3WX6Q0epR5YHUvwTTKw@mail.gmail.com>
In-Reply-To: <CAO9r8zM=CMtUfV0RX3YyztqMNcw=s8M3WX6Q0epR5YHUvwTTKw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EC6F0180008
X-Rspam-User: 
X-Stat-Signature: 6188e1y374oajop1fhbgkxco8q3yf9mk
X-HE-Tag: 1781491559-212270
X-HE-Meta: U2FsdGVkX18Hhpm0sRkH4/qNJTw8DU8Y92JwF8rdmj4yjDbjsO4rUWCaGmEgshX8bb8h1pXrlKb7Odl/l6vfPwOo7+9zP9j9vDAF7J+03YVLNLrW/bR/SfG36BhA4VqiSGSE45Zqatee3AF3RvbFOjZtK4vvoJqN18BLAVFzLYhR1fBLVxZq8YLefrn09CivyRfe9WaTEeEV5iY4iXUa6Xc2e2vBPu/DOnabEdl/cL5Q6Dlxx/0iWpNWDYZYUbL7NY3X9+Bx+NgcnLOiy3ei3DO2z00g6Dnv/MgG7aaRvQbRMNFm713NCIjF7QuWXYrdE7//Dv6zFt8fxixb1eIaoXkSOTSxn9iryLQUE7U5LjNTn52pgaYflX4E4hGa43eJDZJvRyRilin5Cdk/O+ZPU3pOgPXV+FtO+qfGjUrzHVJFxXPBqldoh2vrSvZMd+NXINBkll4uce4z65U8twRfmf9A8RUFxGjPFgcBMfqYRz92yGC0ka4h1FD/b6QfTakmHkpFa45yfSdxsRVNVzMOKRApDJ9oiqQNlneVW6wAIwwGwICnElnGdgOOXkbeOAozhFDF3dyeAjXIMtmKHxrAjOLGjg9LmelRtXTxGPhJ1iDFswpnpzKKEXa/C9kUCCgIS9cbB3eRLuQ0q/33vxzZTMUX5yNBRD3mL2aA4opyxSgDXW0+2ZjE/VV6V5SxTKBMYl3EspCC6XfgT1bpZz3f3jQJM/ZkjVfh5BQCR8U/6mTv7ul3YH6GgpkY4qiTBDphaEkhWkkp0LdboshsQVmc9Mgz4euKSQSaMNtRRaX+wSyrkHxtGwsJhbaDpJZYmXS7ShgMBgrG6HYG1LBhf8OarmnBCuo4cektruHbxgvhs+wj2nJVnTQWVHKxpJKRDWE0QpbXe2y2ag+i/NcIk4iYuaZQoFQKoIMRiTjJz/36+prNSfVHUcPKozvI9jhYOS8sPUXy4EVphaEZjxqxL57
 IoFOHlXz
 /jMqCc8wpCs0vODes2RNGFq3rS21uuvlUfCy2uZiYrccYlhpGWlDwSYGOc3PIJbeqxL8l+IzMqCGZOoVGDVFN7KBOYkGe8ZyHPCxFDS30GD/RWCs2t0JqKEb9EvawoU9ViL7trJfjYMYhXepaU+Kpux+uJz2rXkHriuAIw8JmMm2cVKcNd807wTWYr7PGUuYe3JWwap1tIhjN95x9yihLq4OY+VmP88BBhU2iskWknk6zy/wj6SibHbvyFgT4hds4ADTmmycYdxO6RWU9xaAzYv5/E9igA0BPn78kVI0YGc15tNnSnd2Z/Ew4g8CTwjkfyc++1N8DuxGX22boZpqyE2wVyQlfO6igIj0ovnOoQvq8TVVZ4ef1I/JtQ9j91cKZSLveD7tu9nxELWDpj9pbSBhVgaB9FZudQgdRxsA5nngWfdsUB+vPPxZFPPxGoHVVuOAob+MsSkzwORMHrWrDLMvGCASAEQS3USeM/FsuflYPZZHaasoiSgJv+SrIjfhc1fuWxgSGqmWrm2gUbYjCIkfjcVuXTqc/BtfmfhCMiZWWzV7QgNIjs0EDsbwVlwgeU2fs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/13 02:15, Yosry Ahmed wrote:
> On Fri, Jun 12, 2026 at 9:40 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
>>
>> On Thu, Jun 11, 2026 at 05:39:16PM +0000, Yosry Ahmed wrote:
>>> On Tue, Jun 09, 2026 at 11:18:26AM +0800, Hao Jia wrote:
>>>>
>>>>
>>>> On 2026/6/9 02:01, Nhat Pham wrote:
>>>>> On Mon, Jun 8, 2026 at 9:48 AM Yosry Ahmed <yosry@kernel.org> wrote:
>>>>>>
>>>>>>> But OTOH, this does seem like a recipe for inefficient reclaim. We
>>>>>>> might exhaust hotter memory of a cgroup while sparing colder memory of
>>>>>>> another cgroup... But maybe if they're all cold anyway, then who
>>>>>>> cares, and eventually you'll get to the cold stuff of other child?
>>>>>>
>>>>>> Forgot to respond to this part, the unfairness is limited to the batch
>>>>>> size per-invocation, so it should be fine as long as you don't divide
>>>>>> the amount over 100 iterations for some reason. Also yes, all memory
>>>>>> in zswap is cold, the relative coldness is not that important (e.g.
>>>>>> compared to relative coldness during reclaim).
>>>>>
>>>>> Ok then yeah, I think we should shelve per-memcg cursor for the next
>>>>> version. Down the line, if we have more data that unfairness is an
>>>>> issue, we can always fix it. One step at a time :)
>>>>
>>>> Thanks a lot to Yosry, Nhat, and Shakeel for the great suggestions!
>>>>
>>>> Let me summarize what I plan to do in the next version to make sure we are
>>>> on the same page:
>>>>
>>>>   - Drop the per-memcg cursor and keep the root cgroup cursor
>>>> (zswap_next_shrink) logic intact.
>>>>   - Stick to using the zswap_writeback_only key, and change the proactive
>>>> writeback size to use the compressed size.
>>>>   - Consolidate and reuse the logic between shrink_worker() and
>>>> shrink_memcg(). Enable batch writeback in the shrink_worker() path, while
>>>> keeping the writeback behavior in the zswap_store() path unchanged.
>>>>
>>>> Please let me know if I missed or misunderstood anything. Thanks again for
>>>> clearing things up!
>>>
>>> Sorry for the late response, yes I think this makes sense. However, I
>>> have some comment about how this interacts with swap tiering, let me
>>> reply to the other thread.
>>>
>>
>> I think the swap tiers interaction will be figured out over next cycle. However
>> Hao can/should continue to push and we may decide to let it in orthogonal to
>> swap tiers.
> 
> Yeah I think there are a lot of changes we discussed outside of the
> memcg interface, so maybe keep the interface as-is for now, work on a
> new version with the other changes, and we can finalize the interface
> at the end?

Okay, I will split the non-memcg interface parts into a few separate 
patches. These will serve as the preparation work for proactive 
writeback and enable batch writeback in the shrink_worker() path.

However, I will still send the complete patchset using the 
zswap_writeback_only key approach in the next version. This should make 
it easier to review whether the preparation logic is reasonable, and to 
decide whether it should eventually be merged independently of the swap 
tiers.

Thanks,
Hao

