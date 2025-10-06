Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 254A4CAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 13:38:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BD0E8E0005; Mon,  6 Oct 2025 09:38:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5949F8E0002; Mon,  6 Oct 2025 09:38:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 483278E0005; Mon,  6 Oct 2025 09:38:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3823A8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 09:38:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D056587AF2
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 13:38:13 +0000 (UTC)
X-FDA: 83967793266.18.5B3486D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 734F714000B
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 13:38:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QBZjNF34;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759757891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J9Vslcj5WOkRvo7kWCjBKDT3O8gP/5DZEooiRG+rxc0=;
	b=5Q7XoI7m0tnatoT84jo2GAZwXQ2cM1zDu4b8hJk+B6nY2XiGkX1CvEiWEjwfNH7OdILFnK
	ppVBJkg9eDOl3EX6b5vUarClmNMHqIxZwd4GphOwazARl3pW9DEcFC3mzSWa3enl6J71O0
	iiHeIAkLR8xdc89V1sn+ckzL0ZBMFPY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QBZjNF34;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759757891; a=rsa-sha256;
	cv=none;
	b=OlxTbAAG6/ZQljU3ySobtShUvblRtgXuzbZT2pGvm1SLWFNB5knIVNtfpW9UPP2uNbAUO5
	B7FtckwzugOIsJRM331kAmwHiDS0FoIwkCD5CJd4NL2dHC4HGkk9pUKWiJYWxy69RThx3L
	+at01nfGQlBnAHNa0YevoLY0sw+hHPE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759757890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=J9Vslcj5WOkRvo7kWCjBKDT3O8gP/5DZEooiRG+rxc0=;
	b=QBZjNF342ibee/JifsZZGWZ4ZMyeMBPBdzAFKY5nqFQ5o7a+l7bAQc2/kHRuCHUv9Vm0z2
	HD6xLw5Mo6v46d+0XRLfjozkRtAMpvKFktITsSN4HZWfNDVOYx0JdFCHXdPBJWAK01aV6B
	Zv+QHvo554R0arIlIhUMknmnzpP7kbY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-M2KX7ppHNmi4R4z-hMQRXg-1; Mon, 06 Oct 2025 09:38:09 -0400
X-MC-Unique: M2KX7ppHNmi4R4z-hMQRXg-1
X-Mimecast-MFC-AGG-ID: M2KX7ppHNmi4R4z-hMQRXg_1759757888
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46b303f6c9cso33047675e9.2
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 06:38:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759757888; x=1760362688;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J9Vslcj5WOkRvo7kWCjBKDT3O8gP/5DZEooiRG+rxc0=;
        b=M/gChWyi0GcDyYmEUXu1ggizoiNO+w38BO437IUzSuf3Bc3L0FHOGDrJ5psAa9DHHh
         xewVhZcUMSkrjAU7VMJ6UEY5pnQiSJhX6XMt12jNUyJo4NP98KnzXrE4/dhvO4qTZqJr
         RbGThamoz9dMuoClcVhr7TmZC0spjL6rgv6miXf2BJ4hWtDIncnyc7fAb8+lCrU35LFh
         HaTHaTM1McphZbulSpj4nFuPfWFGsRw+YO+1DhMgoamXNKD+Q664quMZPOGNYmH4J7MU
         RT1aszF/BUSGNnZM9sPhPwRUGluKiZJKdtYbjpuk6PKPbOuxQHblvYu/wLOJzB70dEfi
         Rcxw==
X-Gm-Message-State: AOJu0Ywd5Mw800CC71c842nIgiaO909sHnpbAwA180ffF/pkC9qO/VRT
	pQ9lxU6Ch8wsUQKqVV2CjwCG9GniWJt6UV7BqyVpA7AZeUgORgByjro0JUTcxAIN7EYQm6Qgo+A
	N7JGaa3qBMkdfQY3Gc3YwUyagX7Tql6GQpLL0NGZqhAJ6NsOc0LwP
X-Gm-Gg: ASbGnctLHqoc9NCXnLDGHhvEVK3qcDjfymr6GFE5jiv9j80XYH746vNjpnEOKwRWyvL
	7638D5+19Z0uwo0yzfl3CMfNXK8L8h/yyZ/zEoIg4Xnu9IM/GDo4aGH9CrzkJt3BE1B0lORk452
	ujxORKa97/eJAKD+U2236BBRNYIEI3y2rxaoOaLRnIOmbfx02SHg4Ypr9NtLqtsZowH3/SXA/kR
	GGbkacabxdf6jH5EQ5zpuipJwke9km9Q+Y/YVRG67c42uUFO/X7hFhYvKNfZXDysMi2xVknJ3sL
	IQNidDKiMQWlyQ6OPDPoFS5v1+Oc7d/wL+Zlfu5ZPmU3W1YXXfL1NXyrDi1zjAIhsRYdCw5mtSH
	bkJ2f6Bmk
X-Received: by 2002:a05:600c:64c4:b0:46d:45e:3514 with SMTP id 5b1f17b1804b1-46e7114310amr100732255e9.17.1759757888258;
        Mon, 06 Oct 2025 06:38:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE076+Qj5FIN1G3sNZQZ/xD8YOyGPuPaWGZHYbFqbRLs6YYMiCNULxQdvp715NneEIF4EDA4A==
X-Received: by 2002:a05:600c:64c4:b0:46d:45e:3514 with SMTP id 5b1f17b1804b1-46e7114310amr100731955e9.17.1759757887791;
        Mon, 06 Oct 2025 06:38:07 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f02a8sm21300590f8f.39.2025.10.06.06.38.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Oct 2025 06:38:07 -0700 (PDT)
Message-ID: <ce32090b-32b3-4d7d-b1c0-dfc7e1c70202@redhat.com>
Date: Mon, 6 Oct 2025 15:38:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] mm: Introduce vm_uffd_ops API
To: Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Axel Rasmussen <axelrasmussen@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 James Houghton <jthoughton@google.com>, Nikita Kalyazin
 <kalyazin@amazon.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ujwal Kundur <ujwal.kundur@gmail.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andrea Arcangeli <aarcange@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>,
 Suren Baghdasaryan <surenb@google.com>
References: <20250926211650.525109-1-peterx@redhat.com>
 <20250926211650.525109-2-peterx@redhat.com>
 <f1da3505-f17f-4829-80c1-696b1d99057d@redhat.com> <aNwmE11LirPtEuGW@x1.local>
 <f409cbe7-7865-45ab-af9a-6d5108bc5ad4@redhat.com> <aNw_GrZsql_M04T0@x1.local>
 <43d78ba7-8829-4a19-bdf3-d192a62cdac4@redhat.com> <aN08NxRLz7Wx0Qh4@x1.local>
 <ad124fb6-a712-4cf5-8a7e-2abacbc2e4be@redhat.com> <aN_XZbQjuYx-OnFr@x1.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aN_XZbQjuYx-OnFr@x1.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HX65egYaqN94vOPy_TKAGTg3xPE0Pccv8m_E8dvcxvc_1759757888
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 734F714000B
X-Rspamd-Server: rspam03
X-Stat-Signature: hxbjm77uwqqa3k6prxjhg3eaz9ygarr6
X-HE-Tag: 1759757891-553276
X-HE-Meta: U2FsdGVkX1+e0RiQc9OtV35/Bwkx18/Mn7N16W+xBqs9soEyAa3FgbnrfRPs+5WyGe7cxBu5bmb3cOqAhfUzaN9R3PBipYO60lEqk8V2TlKhpwG/yekPN8n/UjlP3SRnhyYFjKA/Lxi4F3rdz4lSwQCxczTKNC7IafyEuETT+Z4oZU0N6/Wt5ytPZQnUpBHRIYToQDdzhfZRF63cpOKxAb2FM3vAUglDRs0m+efj7LhSzGl37reLeMkLrzH939l52dmtruOMtatAV8u/IFl54Th6zucpzgerw7dUvQ2HnzkDyhOxnRYRuL1Wp95d4rMfe445Q3i+7f1j5Tv4uUZT/3KzRVeT1WrBfBsEyQd4094Q48BPcDF//6gmYvSXk7+8cIBL0SHSMSe0WsBSWbO0Vg5+eIfJKyL1b3yBl93FAsYrmDPtrra9Tx8HCXlnMyDyLb0zVsiubVknAgNgd26O8KLnM1yMhSoylWFfKL4aGKM8AKUWFitxqo2e23zWZJCTPPBbvbQHoKyM58+zAQfbE3ppbi/rU+KCw4zqbD0+FgT8VZPFNOfKY/cBj/0pHw+IjU43gtQyUf/rRJipqNNsJXDMXl45Rbhc2AVDJODgpKPFpOifNmRMM2ucc7iVqQz3Z045JBFQUHXzAow/ynC+px0+Ws8dUGBuQov3aeYM3L2AjLVcbEwVOwPNZldMOQDUgBkUCUwOvMdVK034Dk5HDkU1VCUxqGuxitd1qd6Df5IouJsiJD1sz0JX6qugFZ7I5gWbjFvDTxfCjN2kyY15WiNcHX5mzXJUmH2cX2uX/2U/547DejfxMuh39LlL80O7yL0RlWk67XuQkVhbBHwoiijU6PUNdWfSI7ZTk7RW4zjPG3M4vEVHC1TiWHkln7VNUKwUgtz6p5qQ5tiEis2QTr/AMDF0NPOdQXRqSD3vdmswvGYWdfrx/WHXVd6IvjqmpvXQuZ4v7OVRHBQuGgH
 JwiaRX/0
 ZwbUElfSNKjd6Bw09zNdmjJSUzEWMldkZYHV3pjC1EXkRnNqBAlSX5rxPMjdjCRCBtZe5H4Yx+pGwzX/LSr9gDTCYI1hE+i4dmpYVTWoMJ+vAZXffssKTwn/VLrtMbep/UUHTDTE/HtIeN2k5+DS1rXMO+XMxSwOmt4GKax2cO6QZXz3aiawVIvW7YTHNvUoFWv+27kpCeKKTB4jLpmu8JkJcRfcPk+SCCk+b7muHhOKUhBJFy0m8RJUhMGHBiynCsJqbxDnNfg7tH0glpqb9TfZKR3x8iR3NqnTTtjpoBKuEevF3NygCakPYYpx0XGrNDz8q7Uez9qtowAhzaMpeN/Sj0OiWIQasr1fJEywSkQTkzDc+yOtRB+G7Bu0p3+rbIbT1NYzJAO4rppvsMC/tMkrBwBnDlU8umozk3RMw5P/euzjtYWpPEBOz6gzMiXAxlegX4aE2rTn8hF0WPpQABRaxBlLcZM38bRWcupY8VyVu7svjnA1LchtNGFZEHLT40d5wuqyW5ff3gG9dacrhpb6xx1j7F/nOl0BrJuqHwtIwBbToHyOUK09OAfcz8wjTMVm3KRq0uPSSTr2C71Et9jATXWCf9Kgi4/9vVexGnn1MCl39fjG1ionRQw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Peter,

>>
>> Agreed, while making the API cleaner. I don't easily see what's confusing
>> about that, though.
> 
> It will introduce another set of userfaultfd features, making it hard to
> say what is the difference between the new set and UFFD_FEATURE_*.

That's why I suggested we use something like "BACKEND" as part of the name.

If we can come up with something better, like talking about capabilities 
than features to better distinguish it, even better (UFFD_BACKEND_CAP_* 
etc).

> 
>>
>> I think it can be done with a handful of LOC and avoid having to use VM_
>> flags in this API.
> 
> I waited for a few days, unfortunately we didn't get a second opinion.
> 

We are currently in the merge window and many people are either out or 
were attending kernel recipes and are on their way back.

I'd suggest waiting a couple of days for more feedback -- right now 
there is no need to rush either way, we have the complete development 
cycle starting in one week.

-- 
Cheers

David / dhildenb


