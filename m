Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6A6ACA100F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 17:21:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0758D8E000D; Mon, 22 Sep 2025 13:21:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0269E8E0001; Mon, 22 Sep 2025 13:21:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E30178E000D; Mon, 22 Sep 2025 13:21:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CA9F08E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 13:21:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 812231401B9
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 17:21:46 +0000 (UTC)
X-FDA: 83917553412.13.FB48D40
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 31B8DC000D
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 17:21:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Yn7pL96g;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758561704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eLkzTTJCYz0S7akYKEm9Ho7z+dvhxeYlXMKoN34tPxw=;
	b=PYfJxMQzv8qVIiRs1l0krisdyKMfi07ZHIVdrf4pu39IVCWLFeZzxtUNSzYGv+ic+0JsGv
	IMpw+mcluJBV3FvxyQyHHa36ZRkMrA/pdddi34y5qlXr+7Hwwk4Aaqa2ACvNhdUWBG8CKX
	MDHoIWPmjH1i3HNCr7oPljh+0sUqaQA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758561704; a=rsa-sha256;
	cv=none;
	b=FKrNn+OlHqzdecOC8eZuDeQCzdAy6u2c18qJnvJD6yYuaLrkrJozjUCyJ7A4B6zC1Qpwf8
	O0DASncZnbeBYQcKeYwnMPYsi/fL04Vd1dCtK9ayYutnTWVWnkRwudjU7+sFqLl+EJu7OF
	G7cqjFLrYXHlm7TClVVMoznS/ZJq6lQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Yn7pL96g;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758561703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eLkzTTJCYz0S7akYKEm9Ho7z+dvhxeYlXMKoN34tPxw=;
	b=Yn7pL96gdTXtjEor1mSwMbucfmkmnE9zXqVxnOoQVOlEImbQUXmh7uaDsFAav6B6rnlMRO
	vwNMDySAx31Ww1XQq8K5qT/efudPlBvcfVC8YxMFoeLhH97hlbYqCy8rfisZJ79BF9d9AP
	PfIUjKhjVvdvG8ykvgyGB5TUdi0n9jA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-imVARXgTNNqpdK4WNf45xg-1; Mon, 22 Sep 2025 13:20:54 -0400
X-MC-Unique: imVARXgTNNqpdK4WNf45xg-1
X-Mimecast-MFC-AGG-ID: imVARXgTNNqpdK4WNf45xg_1758561653
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e19f00bc2so6001215e9.3
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:20:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758561653; x=1759166453;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eLkzTTJCYz0S7akYKEm9Ho7z+dvhxeYlXMKoN34tPxw=;
        b=bQ1YXmgYSiM8ifUkAQ25wU0CEgOVAHZmv0zJwqIHzr4Yo0tfUgY8uv4hJCJQsW1KAd
         YiYwfZHCuV1ttISdLCKCV6fRaMAXVWWOAhIiCX0JGoMvnsOg7FmqwWAx3cFSl8xttNJh
         SEMeUjCZVywWLzMNO1AZqmDv7yp2Ah1m/fGpz9nsQD0LsYnecBRD1eV+VPfGqRMfIQx7
         D1K08QnYXdGGXQ+vNQYCQWVKMVI+FHDXwNFNL2wg16MpS6+YanQXMawlCJ4Aw3sMFlYo
         FeywBTIRnOfBxS9jv3HuByiYBQOAx3k5Xq70ED8h2NNlDUbhO0MjZb8zd+qJpsjC363L
         fYoA==
X-Forwarded-Encrypted: i=1; AJvYcCWut0HttA5jPT62exVpmvxR+jLJ3T3Lcxg1GOuiKHcCUCipjwSYnn3lRxy2encJj3C56XFdR9WjPQ==@kvack.org
X-Gm-Message-State: AOJu0YwtWQRIkqasfxazy4P5mrmXS2sjsDXkkbyDMBXkkmdQk7DRNQb4
	RO+6E3Jux/Waf954JjFGk4HVJLZj1nc2Il8A8ktwqKA1lGENoINjbEK38TtSaXbBt7RuBJif8Fp
	+IFW5DbEFygUMzdyaHReyT1Rw8DKG9oNjtpVpPGF5pcEl6KPGfufz
X-Gm-Gg: ASbGncsytOPmO8Lk1uqlJ7kSQb7zjm2JKSvSxv3pKzSE5+QH894XnfadPfE09CfSrxT
	vYlM5np+r/7Tbz7G3m8jYbPOdbRCDza9WoT5C4nFAzgP7O0kqiyeUGdNgQ2ehkVCZwulhMj0oVv
	xhRfF+BU22G04zC9129nUsZAOewhd9KQxVpHIjWHniwKZrO5uXv93ME19Iy7ekvwxnnKRYmhXta
	M6b/wG4FUXmf2ShytQoU78OKw1FCw1ZJIyveOdDuLdypvMNvnBjLFvW9U2I20YudQMpae39zz+A
	Ccm2a9coQK/Mblib/noVTE4Y/Y5UujOMuNHiSbE5aMA2BBzaX8reXQ1c3FD1Umqf4ysYU6iq68o
	E4sadi+yZQCZ5LduMz5exMX6/nY45Ao6jjx79sa0GvMPe6BrmMoHUFQGVfhFP6KQ=
X-Received: by 2002:a05:600c:4f0e:b0:45b:6b57:5308 with SMTP id 5b1f17b1804b1-4686ef84790mr131223855e9.7.1758561653329;
        Mon, 22 Sep 2025 10:20:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGz9q9s0IUnjOjMxVJn3jUACO4XmXNV1b0nQZiphPuMzMbWxDcUmCY8o2I+P9YB6nyWPSm2iQ==
X-Received: by 2002:a05:600c:4f0e:b0:45b:6b57:5308 with SMTP id 5b1f17b1804b1-4686ef84790mr131223545e9.7.1758561652874;
        Mon, 22 Sep 2025 10:20:52 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2a:e200:f98f:8d71:83f:f88? (p200300d82f2ae200f98f8d71083f0f88.dip0.t-ipconnect.de. [2003:d8:2f2a:e200:f98f:8d71:83f:f88])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4613d14d212sm275273325e9.12.2025.09.22.10.20.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 10:20:52 -0700 (PDT)
Message-ID: <6a6c8b42-ed13-4fe2-9ef4-5641b81ed2d1@redhat.com>
Date: Mon, 22 Sep 2025 19:20:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm: Introduce vm_uffd_ops API
To: Peter Xu <peterx@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Nikita Kalyazin <kalyazin@amazon.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vlastimil Babka <vbabka@suse.cz>, Muchun Song <muchun.song@linux.dev>,
 Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 James Houghton <jthoughton@google.com>, Michal Hocko <mhocko@suse.com>,
 Andrea Arcangeli <aarcange@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Ujwal Kundur <ujwal.kundur@gmail.com>
References: <e7vr62s73dftijeveyg6lfgivctijz4qcar3teswjbuv6gog3k@4sbpuj35nbbh>
 <930d8830-3d5d-496d-80d8-b716ea6446bb@amazon.com>
 <jxekhkhbn7uk23oe24svxrs3vfuhseae57sqagndqgh2e7h33o@kfkygmrvjb5n>
 <aMp-kW3OLqtZs8sh@kernel.org>
 <du5pzxmfk6lile3ykpaloylwz4eni6disj2oe25eq6ipzqemiw@ybcouflfnlev>
 <aMvEu9m7fJLnj862@kernel.org>
 <4czztpp7emy7gnigoa7aap2expmlnrpvhugko7q4ycfj2ikuck@v6aq7tzr6yeq>
 <a1a48a0e-62d3-48d0-b9c2-492eb190b99f@amazon.com>
 <7cccbceb-b833-4a21-bdc4-1ff9d1d6c14f@lucifer.local>
 <74b92ce3-9e0e-4361-8117-7abda27f2dd4@redhat.com> <aMxNgyVRuiFq2Sms@x1.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aMxNgyVRuiFq2Sms@x1.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3ZReWiILCmbBj_8ESrwjkWuG3DaZkICdYxjmXsms3q0_1758561653
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: q98hfqtrotahogxy7o45df6x3n8g1gag
X-Rspamd-Queue-Id: 31B8DC000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758561704-129015
X-HE-Meta: U2FsdGVkX18G1vz7JcjNRPY0QHraI/AsmxjZW75mCM7Pxcjoj+h1IqwM+Dm6YzoqHabFkfZ6blfoYoWElJuB3Szy1/+l2RtwF/vEA+WDkVxmlVDXPEh34Vo8tNf1fQUz7w9KZVf12CWc6iplvd7fwVbQoSQqraOjSh0C1emw6NmNTSDmZ9A+exqFvyhT1r6dYDagaS5V5/KEcGX3clCkADX3uL0q4stiorXjCZtPlRpPKLvZFBMkuVn8KuRzanZzWSgCPCV6sd2InvFbW0XvXa/AGD6KjJV+qmDh97Ye/EDzK85G2NAQjTMRfz3ggeHLF5Xi5ZTE9I2ZpmkHzp4CuFaMIbAms6FLre0e/y0zYjGFeLe2KYztDTiTOkhEUhkXczIbiT6l/GzIIlWzpzyfwuH2xolf4KGaXnupx4gGzTIEz+Iz7774NVTzmj0lsaQtjmIPOiJEZYeyEeVUK7FdY7UQnEF3Pf+fpYmEwpMfUA/Qk8Oh2+o7cjMxD4+BY7EvHsuAFDb2lSX3PQnZ0/qryLkvIed/bAvD9YjWDSROKdDGADNnFzfYgBDJmXe6MV1nH77bzdkasCbFEqeqwTIv4XsIb/OnW8wS4IjrhxXKLjEbeRbQTVis68Idqp39ypT5IRemtngXHY5ZGSLXIvPFIdkyJYeDO817hNiEd22jO2HhBtl2a3VB3962tVkpqh0uJ2TCdWpm+jnC5zgecEgWt0VCoVcujW/yxa8G2rNP+lHOW5URu5ONiXb3ZvPs1t2eX5LA2WP5S8Tk+A0aI6OMNFFqYRRau4Glos+P8JtZHMat9wlsCBMZvgf1pa0AVpcOuKQcXM5l3eOoh5Ma5fMpnDkyDOLL9gUrJent9n/C1QQ97gly0MBs6BTTezC7uaRX0HLP0RIrX3nh8hwbz6fKXftzYLPkTXx4YKdFo7qDC/+VyxfI5SFybA6Jt/p8QKaY1F9Qufjki8k6lHtcvo2
 D87yttiZ
 cVgySaGyk6oHqGHUw7nkEFUve9V1uYfLv9WQ94LmNlNJFT1Kssu/be1oO7BqMvUBgF51MBeu6adT9Vh4dyFbUQDXChC5vxsP5mtI/gzR8fQDsmVrjbdr3iT2DUJllkQCBocrkt5LL20kwlJeqmjnmXJnV+O9cjIljdz6T0Qmxs09zBtvOpUksZEVePGE7lQzkCXi44GJYF63D1uTDscZcsX7HhquwiM2nHhx543ebdoduIVJ3OptQySk48s+5x+dsPCfgaBg0QcXXODzjWu0E32SrRkLq/1dVvoiervAubopj1fnTIyIfmWiL4HCtoyl1D4Lo0t0qZTJgNElM+zzM6OBGxzNo9SqOrVw99HOnT5oknWZzs4hb/EKrRhFsA4G0LQ8EMT7WXt33B1HoGnIIbVRxZAMp589OMtlPOdvSfr7fx20XD3ZGWnknFj1kvtXEFayE8JlevQ+97V2eL0rOAYSg44G9Unx5CLlTpxOOmZoIY66dudSDFRLuFYtBZRZWpx7Vt/1pV/Yr6d8g7JetH4nOPUXNCcxev02H3Jau7mWwWvqhrhRqQ1gPjSPOGR7sffhVIY/PBH9psZRFcKXZbrcyaRoBJnVH7C/zTDXalaMmvskrIEZb1+eM4KcLjsvSlD9UVyuBjD8lzX6nS51Dm3wvdgfuCdiGH94fYn8HoBsP6tDGLxpbUIX8D6cgL8GgKorb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.09.25 20:20, Peter Xu wrote:
> On Thu, Sep 18, 2025 at 07:53:46PM +0200, David Hildenbrand wrote:
>> Re Nikita: If we could just reuse fault() for userfaultfd purposes, that
>> might actually be pretty nice.
> 
> I commented on that.
> 
> https://lore.kernel.org/all/aEiwHjl4tsUt98sh@x1.local/
> 
> That'll need to leak FAULT_FLAG_USERFAULT_CONTINUE which isn't necessary,
> make it extremely hard to know when to set the flag, and comlicates the
> fault path which isn't necessary.

I agree that FAULT_FLAG_USERFAULT_CONTINUE would be a very weird thing 
to have.

I was wondering whether it could be abstracted in a cleaner way, similar 
to what you described with the "NO_USERFAULT", but possibly taking it 
one step further (if possible ...).

In your reply you also mentioned "whether we can also avoid reusing 
fault() but instead resolve the page faults using the vm_ops hook too".

So it kind-of is a special type of page fault, but the question would be 
how that could be integrated more cleanly. And as you also point out, 
the question would be which other users it might really have.

In GUP we achieve not triggering userfaultfd by not setting 
FAULT_FLAG_ALLOW_RETRY.

But it's rather that not allowing to retry (drop+retake locks) makes it 
impossible to call into userfaultfd.

So not sure if abstracting/reusing that would make sense.

> 
> I think Mike's comment was spot on, that the new API is literally
> do_fault() for shmem, but only used in userfaultfd context so it's even an
> oneliner.

Right, special fault handling for userfaultfd.

> 
> I do not maintain mm, so above is only my two cents, so I don't make
> decisions.  Personally I still prefer the current approach of keep the mm
> main fault path clean.

Well, as clean as things like FAULT_FLAG_ALLOW_RETRY are. :)

In any case, reading Liams reply, it sounded like that there is a path 
forward, so I don't particularly care, just wanted to mention what I had 
in mind regarding FAULT_FLAG_ALLOW_RETRY.

-- 
Cheers

David / dhildenb


