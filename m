Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29C48CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 19:01:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DCF48E002E; Wed,  8 Oct 2025 15:01:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68D248E0002; Wed,  8 Oct 2025 15:01:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 554E88E002E; Wed,  8 Oct 2025 15:01:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 436AA8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:01:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ED784C06A9
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 19:01:17 +0000 (UTC)
X-FDA: 83975864994.15.8E3E8BA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8551B20011
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 19:01:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E3Vh8okr;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759950075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xbDB48GoIfubfhUk0lRIFFeY6aC6AxZ+kgHto7K7Oxc=;
	b=0HjBmgj58S4+EpVAnx5qYGTC0IgGOOxNLzuyx2RQ62A2BJBLeRZE7iB3Ifli0s2+cuW9yM
	fOuWdrD8ApOuAj8hdo52M+pUWw08+QOcctXFKzSvEGxZb5caRrmTUO3tGMYemk7HlzseST
	XZGNpxuduHkIb2YNMKSUfqwGaKDK1YU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759950075; a=rsa-sha256;
	cv=none;
	b=3vII7+Bhax/rDeJW6jHGAyJMhg+XQ8yOKpyRfu1fD6STHrEj2kVMvMFfikM9N1XxCmDK6J
	LVKZeSI98eFNE5qa218gDPIRLLdVFVoc8h/f4xmWfXlyTeu1dtWZ/ZoYXyGKgf3xzjjO3I
	HzmabvGs7LjhfSmL4O4J7KcktLSl+H4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E3Vh8okr;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759950074;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xbDB48GoIfubfhUk0lRIFFeY6aC6AxZ+kgHto7K7Oxc=;
	b=E3Vh8okr7GrSruWQ+1WiyU+HbDNJuqEcM5YbAXvDtuB+56slsIGXx9DssTutrTrp1Sbi5B
	MpXK4cXKbU2gpVhiy4eCnL1IiK6zPcBZ0TGFIbGKQDqYzeswxo31GeY63UFTZT2koWZvkp
	mn3SXxeX5MwrCfbEFbZL8PBDGOMiEyw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-4XdcHK2aN7mpGZzS4UVwxQ-1; Wed, 08 Oct 2025 15:01:13 -0400
X-MC-Unique: 4XdcHK2aN7mpGZzS4UVwxQ-1
X-Mimecast-MFC-AGG-ID: 4XdcHK2aN7mpGZzS4UVwxQ_1759950072
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e2c11b94cso1508465e9.3
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 12:01:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759950072; x=1760554872;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xbDB48GoIfubfhUk0lRIFFeY6aC6AxZ+kgHto7K7Oxc=;
        b=ZGg050qKsA3CLfSB1G8k1ar1mjKuXPyTrKu6O1P1JyJ8Z0e7OknqBGj7GUpwHurqfT
         h+UJwp8TyLS7ivBxum+nI4BQ/fDItzuxUdMbGqOZNNQ0ZPJjEJcVPkrMgTFyyE+QzBsg
         6PW1d06AERwfNRHrR4LPZZCEc8tKrKrQ48Q6Z6fcoSVoWtcbr3TcqxuQio0bI7ezdO65
         SX66z6vt8IFMWjyjoqzntHoLO9b4/r/VlO+KqaQg5MmGtE2anQEL6gZPqbr6b53BOKSQ
         BfoxQMTE4RyIMzFfs+n88ns+NnGapqWPrqywUjO6XMyV0Y3AJbEkRe1NbZBW7XTBIYHg
         rq0A==
X-Gm-Message-State: AOJu0Yx3xbF074Jdk2t9DTfqIiwKbQdg4MxHw6uU8aDg0W3nqGY0bY5p
	CCwCiOQ/h/YwaFljCPqU8G6drghGDL8BSzIp23hOLffISSRx9S79lq3BcUGh67e8kxXJUjf6YMc
	Y8LDcUmIyBqzcKPebBeiBWnIwWeh0gEoVARU1y5PTy2RuKVat8otO
X-Gm-Gg: ASbGncvJ+qOAsrzhgiWCxAlcYzDcWmST7rlr4KDNzYIXpPZt3oeQoBC+G6V1U1ylTAo
	BvxdnJ8n/cg+TyJys54drKOlzWnm9OneckNgkGm85r5VKTES+DXtBAyaN4OzAixh73XA+c8Map8
	S8H9v+1ZLDsbLkrycy3SMTx7ZfpjpckcBKHI/3rYny5mS+p0B22OeO9/qjTLmCXf6dAAAA96SMy
	3aNhDb3C7HIDGLNtfAehVo3Ck4IVJ75VjCEgJEkFJzsYVh5IfZgj256CeSk1UejAZobvRuH80Yg
	lpY5tJJg+jM3qrm8OUKDx5t6mI6zUhQGsLSPlTDM24GkunxEyIe6HOE0NeUy8CC2OkHJGX7ALsu
	WcRPciyIf
X-Received: by 2002:a05:6000:4201:b0:400:1bbb:d257 with SMTP id ffacd0b85a97d-4266726c2f0mr3059264f8f.26.1759950072432;
        Wed, 08 Oct 2025 12:01:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH+eGTotVGiFRKomIEq6GkpKr6FGrcxlMRZd7jUbDDAkTfSgQerCvnSBP6CMzqlbSkIjvKLIg==
X-Received: by 2002:a05:6000:4201:b0:400:1bbb:d257 with SMTP id ffacd0b85a97d-4266726c2f0mr3059240f8f.26.1759950072025;
        Wed, 08 Oct 2025 12:01:12 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8abe90sm31001480f8f.23.2025.10.08.12.01.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Oct 2025 12:01:11 -0700 (PDT)
Message-ID: <b6d472ba-e6cf-4c96-935d-88c842ab3cd8@redhat.com>
Date: Wed, 8 Oct 2025 21:01:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "mm, hugetlb: remove hugepages_treat_as_movable
 sysctl"
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, corbet@lwn.net, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org, hannes@cmpxchg.org,
 laoar.shao@gmail.com, brauner@kernel.org, mclapinski@google.com,
 joel.granados@kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
 Michal Hocko <mhocko@suse.com>,
 Alexandru Moise <00moses.alexander00@gmail.com>,
 David Rientjes <rientjes@google.com>
References: <20251007214412.3832340-1-gourry@gourry.net>
 <402170e6-c49f-4d28-a010-eb253fc2f923@redhat.com>
 <aOZyt-7sf5PFCdpb@gourry-fedora-PF4VCD3F>
 <f4d0e176-b1d4-47f0-be76-4bff3dd7339a@redhat.com>
 <aOa0UPnxJVGvqc8S@gourry-fedora-PF4VCD3F>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aOa0UPnxJVGvqc8S@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tTd1_xCUAQMJ1vZlp9-XPYkH_nKCKLAWiC5ZWMsXQwA_1759950072
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: jkke4aizuquaccoii7m865qa9rncxc33
X-Rspam-User: 
X-Rspamd-Queue-Id: 8551B20011
X-HE-Tag: 1759950075-617991
X-HE-Meta: U2FsdGVkX19lUyckF2N744KkTqxpW3ItjE7py1d+513s9vU4RoQmr+HrJXs2qLA5XtEXWnh6gHndj+KK91+TRzphs3nZdoROzTg9DkjUoeAw/OVQK3yAW0CF5q0quJnv3jnRFWIViOHNfrTby5k0OD6tGzzpy+phJvfiHzpb0k7AXkoPDNsfqpzERPWgvxBQpDIkdEzvgY2XOg69iO52qKqlD9PX/vWjrpRVYDqUJpUakl7nE/1CaHCvLoteIeWlFEdqe9aZP6WSwTynbWcYCCXF4KIlWGR+PLv+ZN7SZooGHng0EGvBA79GfvC8JwN6wzAMiA1NT9u8ZLfVk/8eDjmWf9WHMqn6eAxR37UTwcDdDqi/QShFtVqZhfwuVYdYXNWY8rM2GdMZHeeF1cXDW+c+yPxSMFNHNd97irBc9DV4bwr/EioLuiKkkY/KvA2ia5dS3/eSgEoMhw5JJoTm2l5fZqJd51CwyzQZ/D4xwFS02CWxkV2R24LGsXQwWxRkBxhxrZtjP+dlg+cwZaQ+mdxCID43dhGgEQRRGRZdtGgyqR2WtYDc9RfQzHq5kTTYqhsCb/yFr/6e0FH5eV+jvPf13PWobLoyYm1OaSSuO2sg2koKfverj8+6vYBjuLtgpbcNuGZeiNhqSk7F2VtG1wD3SPrAtuEG8sF72f7zCXNML5EA/mfzOHkOYJV2fQ74sBuGmEl1KHQuNZHpPH99vfIn7y3xAS4MypKiKJkJuGtUepiwR7Vle4Cm3BmzENx+PTT18p/oXt01oaKdDhcmTvokAqRLFi+u4vY3acy8B11mxaDsTfu1UT29SVnQ8OzKPeJA5B695OTMwGF6dwAuP88T/vurzFPTtaLf7cUGBUI54RVJpJAv17AGeWJA8OMGB0+hcSaykCwHyfEgXp0foBZ15vMJchvNccp5FYturYCOkceMK/s/Y+6BNHk2HZ2eYI58KfuoYQLD7tueJxz
 hV2gqsFk
 h4awD9NGRJIhr5IqPdIQanRz8ic39JqNyxMA8lQFV4hAL4NEMa7KOK7I9YKeglQYpyjztMQ1zb/sHbXxxFDe/dWPzicXm+CM1RuoC2d5pmmyAkTvDSIeCkT/ERAD5Djc0kYaoiMcfq4d0Gy2d5DDqYLllmDtdwtKdxTodxtBaRpEj6D0Gr/xznDuMQLaEOQOCxqDXtxBTcZc7knT8psfWBNn2AroUgWfzCI0FuoBDCUTrZ+fNEWLtXajOrhywEeGk+T1zpGiue27m5GVnTbJYiMPK1LVhEaUkuzyVzUE1WsCJSZo2PDH/tqhoaVbzPU8NK2oqs/6j1t/tOZghLrusSeWsN5N1izNuN5VLgiEuaC1c6RQHrWU16tKXvLQgA4TkXD3T4YQ1rCX9vGY0+FL1USL0eKammTDNRt6K8PlaD4Hqy1eNLFWr4X2gMo9FT+KBPNbniPpuE9MBm46+19jVB5VejDAV+CKVnQNybu0pC/0boPTyaQKuQ7Nhkl29CNI3qzgkeCg1N8a1LXaT/y8P3RRHUNMzoCGdeg/E1HP+DOp8YYlJXgAdGnyGV6v3OQlvcm71no/eUKoGyd7il1K36N3voqrzNTarQCpOwqqRJGeuw6gafE/fHmlwwg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.10.25 20:58, Gregory Price wrote:
> On Wed, Oct 08, 2025 at 04:44:22PM +0200, David Hildenbrand wrote:
>> On 08.10.25 16:18, Gregory Price wrote:
>>> On Wed, Oct 08, 2025 at 10:58:23AM +0200, David Hildenbrand wrote:
>>>> On 07.10.25 23:44, Gregory Price wrote:
>>>> I mean, this is as ugly as it gets.
>>>>
>>>> Can't we just let that old approach RIP where it belongs? :)
>>>>
>>>
>>> Definitely - just found this previously existed and wanted to probe for
>>> how offensive reintroducing it would be. Seems the answer is essentially
>>> "lets do it a little differently".
>>>
>>>> Something I could sympathize is is treaing gigantic pages that are actually
>>>> migratable as movable.
>>>>
>>> ...
>>>> -       gfp |= hugepage_movable_supported(h) ? GFP_HIGHUSER_MOVABLE : GFP_HIGHUSER;
>>>> +       gfp |= hugepage_migration_supported(h) ? GFP_HIGHUSER_MOVABLE : GFP_HIGHUSER;
>>>>
>>>> Assume you want to offline part of the ZONE_MOVABLE there might still be sufficient
>>>> space to possibly allocate a 1 GiB area elsewhere and actually move the gigantic page.
>>>>
>>>> IIRC, we do the same for memory offlining already.
>>>>
>>>
>>> This is generally true of other page sizes as well, though, isn't it?
>>> If the system is truly so pressured that it can't successfully move a
>>> 2MB page - offline may still fail.  So allowing 1GB pages is only a risk
>>> in the sense that they're harder to allocate new targets.
>>
>> Right, but memory defragmentation works on pageblock level, so 2 MiB is much
>> MUCH more reliable :)
>>
> 
> fwiw this works cleanly.  Just dropping this here, but should continue
> the zone conversation.  I need to check, but does this actually allow
> pinnable allocations?  I thought pinning kicked off migration.

Yes, it should because longterm pinning -> unmovable.

-- 
Cheers

David / dhildenb


