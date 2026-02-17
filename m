Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEEAEE9A02D
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 18:19:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C50D56B0088; Tue, 17 Feb 2026 13:19:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFF276B0089; Tue, 17 Feb 2026 13:19:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE0B76B008A; Tue, 17 Feb 2026 13:19:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9BBC76B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:19:14 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17AFAC1427
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:19:14 +0000 (UTC)
X-FDA: 84454760628.14.4F4B35E
Received: from mail-dl1-f68.google.com (mail-dl1-f68.google.com [74.125.82.68])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2D1E6100009
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:19:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BzPMEpUF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.68 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771352352; a=rsa-sha256;
	cv=none;
	b=zmD3rmlyOLAWhuyTe7TxEGElioDx46faNbjNHOTBMPExrhpYn89PBMHwI3xNacruhlGMy1
	JVU2o+IAjzU28sCBITWhmmibdWWNLFBzH7QX235Q7EWIXFT2z1fDT4vk8zbAdGAZGzctjd
	46c7QfQgPzWffCjX32D4zuVTfVyGY8A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BzPMEpUF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.68 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771352352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dh1AV8MM7TPE9F/5A0BmsGHV5nOWLB3oW6lLOMLZNVw=;
	b=GVZCFsLGUoZVXYG/qdfdVL/XfgRBb+E4qsSihDIuTaPWCGe/kWSd+f15fTjNQecwlOIL4G
	eigcEhG3ReyDMKRmbc9XFWZ4jH1gGeuZhQnlQol25dGVGeFW3CwhpRlW1gbG9rW+YghkAi
	ClicUVKOtrvg7zfnpTAcVIWU4RE3kZM=
Received: by mail-dl1-f68.google.com with SMTP id a92af1059eb24-124899ee9d3so76493c88.0
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:19:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771352351; x=1771957151; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Dh1AV8MM7TPE9F/5A0BmsGHV5nOWLB3oW6lLOMLZNVw=;
        b=BzPMEpUFI4SImytXgPf0P5FCXxsrzzqtvcPsTejDKe0cm37vAjNZXULQw3xLipapBY
         Dei4UiM1GDvKMmtf9OWFMOZOIuZoSPAz1x3ImFNt6K0yaEziY+u79zL0akFYdmUEEZnB
         9Uh3ML/uAz5iXBMLdWd8H81n9Vvsm9MoYn7dp5OiTZNao1gUWFXoWaq8A4PKigk9iWPb
         D7iwJS/fDNIl0mAxIhx6Rn4PjqpvUh1wC4cwPrqdXLVBvJ72Qp2YDicrOQGh4fmC5QCQ
         mqUh6iBIyuD8ZY4pv5r3voa+9nF/4/Yr3TV2gonzAtBuwKyn0a/GXsbysoe9tif8frK8
         Oi6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771352351; x=1771957151;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dh1AV8MM7TPE9F/5A0BmsGHV5nOWLB3oW6lLOMLZNVw=;
        b=dWU58vEbeIMsXHmiu9Fs18cgWTnZjyi/T4P7zg26Xm6h7WUrYxzcpMVkqUyHqFUoeN
         2ZuGH2kxWn7qdjMYZtCTxEp9CAKwa1+4/kGu09ym1GdeI9NSJznVku3zyh4KxF1mhGsp
         Xfs7JSIQvNrFJHn3jNOOYQB48B0Zgz1Q9PH6l9dhk/ycWH9PK1iUQDqX9Qp73qKL8or5
         TD5vjTxVD+yXqxAfKnvTrD1SZuitoOkzzhVyyhzNm+j5ZfmQhnZcga+GjZEtnT9FR5GP
         QHYzyFuAIXuXn9WRi07PwJn1Iti8jjE1rKb/FUmLBz2LtXUrdW1M1i2jty+vQM+TZrkf
         RI2g==
X-Gm-Message-State: AOJu0YyWJZjiQNEU0YkbX6fxXH2crUGq3XM6AfrBZ1cgvCUl0zLkZJce
	opVDPtRo24TuoDzxwY6bW84SPwu02zxxGDH+O2SKM9YsIOKM0PbsTgN/
X-Gm-Gg: AZuq6aKlbmeSkzrsHV9LT7kOJXP2R7GPhwE8KHZKYguz+KhYMg18vn1qJvTFdhZoGh+
	VMGaAyaBSM/0M/wEIq49Xm3bMzwgMZhWZmp8VMkBxHRgWfu4olFYZzJyCOT/mAZnokIPtjJ+uzz
	VnK1vSOhqTWqJ6kJ2YxGYRkOd7fLzikopXfK/hTtQesb0NoiJG/DMJoWMezhQrl2vUwCOyVY7vt
	YfDQgPg3nxeOgjxXfchaFAxalUeEP32N3At31FUxN61NMMK+pET34e5UwTLY++aO+MdwEQ/lu7u
	qillWnVnyazIYSMpC9afL9/Szse5mrYX2DPcbYk4gzlRToxKQpLC+AalvmFZnArqq9hXpWX2xFf
	tkHjzdTeNPLkt5IxyynC7mA3if3MyOrjRQkAe8vGRUm9zO8Ag5h68bQ0tog0DrEGaIx0R30AAve
	4joVk3eXccem4yn/UuucAXNAVn1Kjx1Yqr
X-Received: by 2002:a05:7022:6709:b0:11a:fb0a:ceca with SMTP id a92af1059eb24-12741015280mr5221990c88.16.1771352350552;
        Tue, 17 Feb 2026 10:19:10 -0800 (PST)
Received: from [192.168.4.196] ([73.222.117.172])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12742c64282sm19689943c88.5.2026.02.17.10.19.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 10:19:10 -0800 (PST)
Message-ID: <c71f5dc7-d337-4510-96c4-38a83fca29ef@gmail.com>
Date: Tue, 17 Feb 2026 10:19:08 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/mempolicy: track page allocations per mempolicy
To: Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, apopple@nvidia.com, akpm@linux-foundation.org,
 axelrasmussen@google.com, byungchul@sk.com, cgroups@vger.kernel.org,
 david@kernel.org, eperezma@redhat.com, gourry@gourry.net,
 jasowang@redhat.com, hannes@cmpxchg.org, joshua.hahnjy@gmail.com,
 Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, matthew.brost@intel.com, mst@redhat.com,
 rppt@kernel.org, muchun.song@linux.dev, zhengqi.arch@bytedance.com,
 rakie.kim@sk.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 surenb@google.com, virtualization@lists.linux.dev, vbabka@suse.cz,
 weixugc@google.com, xuanzhuo@linux.alibaba.com,
 ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
 kernel-team@meta.com
References: <20260212045109.255391-1-inwardvessel@gmail.com>
 <20260212045109.255391-2-inwardvessel@gmail.com> <aY2BcIHIARSwwQpo@tiehlicka>
 <eca7a8f9-173d-4cb0-93b3-df082b8d0c08@gmail.com> <aZLUm95Y-dKkdBWI@tiehlicka>
 <3fe7c5dd-b184-4421-a21c-bafce6aa7b09@gmail.com> <aZOHIQj3pJ-9dW_0@tiehlicka>
 <9ae80317-f005-474c-9da1-95462138f3c6@gmail.com> <aZRg_ZSDkbGWv7Vq@tiehlicka>
Content-Language: en-US
From: "JP Kobryn (Meta)" <inwardvessel@gmail.com>
In-Reply-To: <aZRg_ZSDkbGWv7Vq@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2D1E6100009
X-Stat-Signature: tn7jatifddgwqzsbr8jcdxiwcthhtjdn
X-HE-Tag: 1771352351-270065
X-HE-Meta: U2FsdGVkX1+/1l4y1MOCrG/ykOTeheBWsFjpnK8eKHmv5Cm/H0Nko3/7l28ADJcZWBT8B6+M7QDTX4gmVBIV1x6vVt5AHvWB6wZ3mnBbHCZf/hnJB0kYbtPjnxVxXk+n1/XmC2JbvyVO62zaLV8Jq+RcJbfV6f3SaK5vvsX7DOEGKZyAHSycsH+dDoq28fcKX0knz7VFUnZ+kI95ffP7bp/NPujhElflrTI+hkq3fd97db33HuEfJWCE4qYfDlRdeclDv54noMQ1lkGJ7pzNu+HZU7/OA2fvXklVAxQIxDX8XB6PAjfW6TgmXg6B1U8epG+8folhdGWrlUSchmve/XDjARcYkaHsY3b/XX/fOOJZy3MUshRCcSWSwFaNC1Wv5KqxtT14Jc52kOofcF4EQuHtBY+hhRxy4JI/ttSuf5r7tCXNRKhvIbz5YMIOBccIaZZPvA86r3birJ7wouYCNRVZpCp+L18uC5DzWjt/hEVqHo2MZ/1UgPD/Lgg66P3jm34ER/fFw6GXc+x+M8dkEhxKIGtVM2o8riUqls8XeFgXKPTcnXszTlnYRUMsb7QG882oOVhvg7n3D/9kROR3eEkKWIDxrrF31Flx9xviT8GicmaCLBr5U9rgyfG07mz5HlBBpWx3WQo+x4BV1yGjGmDmneKPjChM9waWT14U6MrQb66eFeL7UIHAmbY3AGiy1jDDBcfilIrRKgSw7axtqKhZb1Zc14FDGSYDVyZqH/AtFdZD1oIfOhfffR3I6s60XEYxXZVhx6A6amhrbiqBcIwTvbTt0m6CAEnbXEHpiPQ7E/MptEkttg0IMgmLkcJOSu86oj2jHAtIybaGelWEK/vO23Y1cq7mSuEdetCojnzUpQBvFIczN3nEA1h3pePVypC6nDQlHvqqJDrYTqr1GFSHmhUApJkxcHe2LH1NhTcDQ55XFnWz5ZQxJpjnOpF49PSyjUJBACAut5dkaEy
 vc3Tphip
 GQ1r27RiB3ckSs3UJr390FpnsNGc88r2mlZuIFoePDMObai7eiIj2rwfpYAXfPUrsyjqViolZl1arMiqfLlTSu68hPjinIrTPxnbZjNGL+ZmxqGPnK+JD2+UxPHLSmV7M+n5CWSsIHA10QHt1BagYQemeB1nNeIqYL597RujAB/rdXiQofHG3TnWxqgZmk5wXWwxFjoYP7lSsFyNM8IsfcGZbGFDXI5EVzZH9KBVuLXxdYU21CrhA4lmqBIJn2d6H036S+uJniY50Zt/93Zfa5Pofsi3HwTxtIkEM7RqgPVECcawp/5lqT0+h0WonwgA6I0mQidRpGgyxwuxwN/2nzduVSDimYpouJjKSSz2eEiQ3QsJZ8qgSmJioFV87G1fdHDfP+0TpVAFfIGjJtF1XyJrHl1Z3+8wyWSSfCRfBg6q73WPBHPdLq3DS1skx28BPR2hDKz2atSYUJcMpeTMqbPPNxwWgmz6Qwqn56Vrt0UQ5wzFZ3Oc8k1OjjKsAKx/ImduZGYHy1F4N6qdPWKCdq+qmt+b+YnR0q6XSCJUelVcGBhFHCVkyZKBtSObXLLfmajut1CBNd7TqzAwopnrIVVDHrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/17/26 4:37 AM, Michal Hocko wrote:
> On Mon 16-02-26 23:48:42, JP Kobryn (Meta) wrote:
>> On 2/16/26 1:07 PM, Michal Hocko wrote:
> [...]
>>> [*] btw. I believe you misaccount MPOL_LOCAL because you attribute the
>>> target node even when the allocation is from a remote node from the
>>> "local" POV.
>>
>> It's a good point. The accounting as a result of fallback cases
>> shouldn't detract from an investigation though. We're interested in the
>> node(s) under pressure so the relatively few fallback allocations would
>> land on nodes that are not under pressure and could be viewed as
>> acceptable noise.
> 
> This is really confusing. You simply have no means to tell the
> difference between the requested node and the real node used so you
> cannot really say whether the memory pressure is because of fallbacks or
> your mempolicy configurations. That means that you cannot tell the
> difference between the source of the pressure and victim of that
> pressure.

What if I excluded the fallback cases? I could get the actual node from
the allocated page and compare against the requested node or node mask.

