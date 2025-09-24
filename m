Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE260CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 10:46:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C5828E0011; Wed, 24 Sep 2025 06:46:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29D6E8E0001; Wed, 24 Sep 2025 06:46:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B2C78E0011; Wed, 24 Sep 2025 06:46:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C2458E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 06:46:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AE0D311ADBF
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:46:23 +0000 (UTC)
X-FDA: 83923814646.19.B5A8772
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 42776C000C
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:46:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bWV9XGoL;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758710781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qgD8ucCUUYFMmg2u8cfnHO93saNGNzb3fowMQ2xbAZs=;
	b=iXMpAYJi6+GOuoqmA+VLt/IK3ArdnyMGQjzlCUXOZxezmaenktg/WRkDZhWNP4vMZeGYQg
	3/D5C+QYc/QXtv1HlLYRCC/s+wl6CQXrV2FcJiC7RNjevnIWA9YTM2dKyojWjh11S92tFb
	EtPmf5b/jLN8fKWDnwTB4pYR2PuhLU0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bWV9XGoL;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758710781; a=rsa-sha256;
	cv=none;
	b=Bk/o1uQKfxzUfHlm/5a5iz2sHnauJptKLD72XO861eq0foZRh25nzoEt6QPy34EArhxOMB
	3gsFxAEnJHd/dXJNIewuRgbPJwTSfqUC8ncgFhOh6wYgrX6ESbf0eKnLFVFyKq/oIFseig
	Ic2EKomEqROQqJhgj8CHZdfOx5rpBvo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758710780;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qgD8ucCUUYFMmg2u8cfnHO93saNGNzb3fowMQ2xbAZs=;
	b=bWV9XGoLA/8vUohZFpmmMaD4/WBcddCZ+rJDuJE0JLzqDGvYPiANk54XveHdfX+stqWfB1
	GNJlpuA0dEd29KLyT7DVuJhzUHcy/6w8MRKR1q0mxogZuBvZhLcvyxtT4/QgTh3D5/h1bh
	XHtLw59W71KbFe3oNySFxOCxblbUxjU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-155-_FtnpcGRPkaCtpbkPEz68A-1; Wed, 24 Sep 2025 06:46:19 -0400
X-MC-Unique: _FtnpcGRPkaCtpbkPEz68A-1
X-Mimecast-MFC-AGG-ID: _FtnpcGRPkaCtpbkPEz68A_1758710778
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ecdfe971abso7271420f8f.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 03:46:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758710778; x=1759315578;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qgD8ucCUUYFMmg2u8cfnHO93saNGNzb3fowMQ2xbAZs=;
        b=iyfQyGpt0MHM6yjvu/n4AJc908CVXYBwHx8+LAbqZcwVTUN7NUklDpOF9b+in8qAce
         c3ldWSbxWG8SB+1Krr/EI07avuNeAokngPF/stJ/rPpjKDdQTMXmp2IRkgh/tUK7iGHV
         lpydZ1r+S/S6dq9OeOg5b2DuQncDsMRvQxOJFsRKwlcmLGnPRy7p12HXvDJKDNHTcvV1
         5Of9vyAcCrQ6f/FgQeCa6HQMAf9JsPXNez/7SL1++/B9rrTe3BMV+13KH6buSef/RRtO
         o5bVSb38D9/khVYvAK9IJFVcGKp4DQ+WWkdgVmtEpLw1bdFHRnWqSlAmgx+8CnDXuVrW
         +VhA==
X-Forwarded-Encrypted: i=1; AJvYcCXOq6EibCtyCwFz1VcypwFs6c6vGSATzleecfCS3i2q68L2VHaeeU+BYdPtGrUv4hRygjQ+lEpi7w==@kvack.org
X-Gm-Message-State: AOJu0YyvdUej2vsebYkPlpkvVm2GnHxMqC6zEfusyXrR4QRCh4AV45xG
	EzGShbqLSuSHmHNS9CBpUMt545yT4KFh3duJMZmqBy1mdiBb1DX5DXWGf+GiEKCrxcy6tep7ydy
	sZvsfDbcCY6JAB69Z4PcjkOtCpgaukVW4lGgQVnb07+xao8UfwDka
X-Gm-Gg: ASbGncuxoHsCW9olpPZEf0barvocHhnnc8xMD6lPWV8dZQo+K+ouUXP9rjH9cWgEETn
	m9Hq8lhHWPCa78xWFz/0T3qzLwMU0uZvi5h0AGWXjiaT1IJAa6DK6WWEV0JvtH7z0Z4TZIc2abz
	zaXQpVZFQDJTde5ne+E1gnqBVB7P5rLKNTv+RjRbyZ36Z+UDNdaVVXRCRqNuanEYTsuSf57+K15
	ihbtAcl7JFvcTmtXfr84CMHLfwsnVA5a7Qs5fMHJSeTs5heaZa3IfNbyZ1xV6MlkKyGk622oULQ
	e4rmVQ4xpabeTCy6eJlumu8bfuptUiRXLpKCsGMgvbXhCzA53HbQ07QoxaxBX4w71ixB9rPTnLQ
	bW+7y0twDBrXZFm7Dv07CMdJu6pBmXtbKzYDwh4T1wvv/wYW0fgd1gOcSRDXBk8D25g==
X-Received: by 2002:a5d:40ce:0:b0:40d:86c9:5c9e with SMTP id ffacd0b85a97d-40d86c95d49mr287808f8f.40.1758710778100;
        Wed, 24 Sep 2025 03:46:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE1z5A9gGfOB4BPaBPx10lxb0eBipD/XjTy7i8GSxVaO2FgZTrlGe/MwQC8lJQLa3HUOJX0sQ==
X-Received: by 2002:a5d:40ce:0:b0:40d:86c9:5c9e with SMTP id ffacd0b85a97d-40d86c95d49mr287774f8f.40.1758710777676;
        Wed, 24 Sep 2025 03:46:17 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3f0e28c83d6sm22849574f8f.56.2025.09.24.03.46.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 03:46:17 -0700 (PDT)
Message-ID: <5844893c-66dc-4cfc-9a23-12bf24b55ee4@redhat.com>
Date: Wed, 24 Sep 2025 12:46:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v6 03/15] mm/rmap: extend rmap and migration support
 device-private entries
To: Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, damon@lists.linux.dev,
 dri-devel@lists.freedesktop.org, SeongJae Park <sj@kernel.org>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250916122128.2098535-1-balbirs@nvidia.com>
 <20250916122128.2098535-4-balbirs@nvidia.com>
 <D4440A30-118E-40DF-99BD-6F58B708E597@nvidia.com>
 <1b896491-d9c0-4c8d-bc60-47579c773dce@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <1b896491-d9c0-4c8d-bc60-47579c773dce@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6bFrpgwAJgJsQJjQqLPff7SKwlrob9xF4srYP-Rqjdo_1758710778
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 42776C000C
X-Stat-Signature: ujnp911oi74zsyrusafbkz8sq1exznua
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758710781-310362
X-HE-Meta: U2FsdGVkX191724yuTaLXsqlfLh5IAR5EG62DrvRWhRtLNVO65dN7dzIxmy+ttWkmjESog5go0R7DePkohHodpslV04oCjc6fcDLm1CNuLBirZgVWV5cUuFVPoP1DktqIclCzGH9lcqC8Z1wg+K8aDTj3M6t0iYEokvfxosIrEjJcNGHS8KQCUFAkw7ImN08kw/vhWCcmHHlM5cMVEUJxJAVzaKAZvDqg8bT+wH/1xerJCKWNgzgeJwp0EoA1YC+AQyhwNt68zTt4y7Tn/Knc+0At/kl+na2K3M1MJLhhaTaLVaEAQiXexY2CBeGZtEAu2RLjaCBXR5lve964J5lRf7yqjvRkA0L/GBE21/Ar5eDwHk+Eklj44IBJDdpJdSfcHbKEKZQRNBqhqpDF8HUAgVPZPJAMhDFrBBuGokJm2y45Xuc/OLjM4xVqj/yKY/QLn2qPWd5KLKWi+7R3Zak6I4F3awT/6kMwEgOIwZsTimux2PIBs5O03/kOB/klhIZU3YMhy4XGEHmB/mDXc34rhHb+ChR8OW6oU7ILNZkcufEAxX6/pdgPEGneYUkRsCVIHUcsQJuWZ7mFJp8K4N/brAROwsGuI0oYhI1MUFWTOqkZaPuqXnhBufeNIN5ySIeBWOfMEvR0MdbXLYfUamquYxpk/giHoxm4VX9JoS44tsPUmyDsLtrpJ7GhEG66OwLe3Ost/FWEVcNLUzM3xjuN7gynFINcEbUJSLOz8be8mbBdcPOIpdAxbBy0FQNa/ohsknVwGJJAF1gm2HWEP1QxG0U2Nxl4joOBTMswSpak46z7e+ZVPbhYGc/ZwfjM701ADrdsqheeTSRdL+vRBPW2BXd0wTnP+eGFoT+Wkojs0w6MzAsuqI6Vs71W/83ftpCQp1v9o0VYUPZ86CfdhGNrgY1O9qMr84pNmFiOw3klqwLyB7Z+00fevEQQ/uSw9tVA8U0IbXAwl4/sa4n2H4
 noM9fCRO
 gYeuPVQU0jUY31qJvJhlzBgcx7vARtofUajFyUnz4BdzARfa8I/IHOzC+KsirP0Es1aliG3UBFn03aOXfuRs7Ox0qZfMiJoCF6rnvnAw9WV8Acgx3aJCwvnSP0Tq5h8Fl+6gI2eidH9DKu7yos3AKNTywyqet81amCM0/o9YjA9PXQGuwjavdQbbcujkqc84WwLUdOju+0cVz1m3JQME4gluP51Hx3p7EaqnpM9Av9b5osUiNmmyUoTjPn4ezMfB/lMa3TBSbXNeBxuyCetV8XWLhV2K/jOggYqo9aMX1VHjG+2Mx6CwcD601LIBSS9GtbtbNzv7V9AIAP6O1WHJtqC2NFs0UCZ2NiBgdXGVxlIcS90MS2CaytU72POTyZKwU/Ltv3V4dcznZyyyd7H9cBcFPlTzM2f+1pTTQEt3WL+JqpJakNG93pW9oXX416K/4W32vndkmJYxuz/8CoFp9Jgo9qUT7NSxZut0Ip1GyHO8TVMw1l78O9RVYL+SbrJXdq/rZKLjg28KvKTHZfZ+J0uivVIxjIxTJsD82f7n724+KrhtZUDBvMWfDGMRCrlKVXoDOj2jlC+3O2YFyKleyBWwbpw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>> +			if (!pmd_present(entry))
>>> +				continue;
>>> +			if (!pmd_dirty(entry) && !pmd_write(entry))
>>>   				continue;
>>>
>>>   			flush_cache_range(vma, address,
>>> @@ -2330,6 +2332,11 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>   	while (page_vma_mapped_walk(&pvmw)) {
>>>   		/* PMD-mapped THP migration entry */
>>>   		if (!pvmw.pte) {
>>> +#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
>>> +			unsigned long pfn;
>>> +			pmd_t pmdval;
>>> +#endif
>>> +
>>
>> This looks ugly. IIRC, we now can put variable definition in the middle.
>> Maybe for this case, these two can be moved to the below ifdef region.
>>
> 
> I can't find any examples of mixing declarations and could not find any clear
> guidance in the coding style

Rather not do it :)

__maybe_unsed might help avoiding the ifdef.

-- 
Cheers

David / dhildenb


