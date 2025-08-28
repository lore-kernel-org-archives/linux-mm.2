Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E8ADC8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 12:29:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B7A76B0023; Thu, 28 Aug 2025 08:29:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 968396B0024; Thu, 28 Aug 2025 08:29:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 856546B0025; Thu, 28 Aug 2025 08:29:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 721F56B0023
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:29:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1DDF414015B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:29:07 +0000 (UTC)
X-FDA: 83826095934.09.D0823B3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7A7FA120006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:29:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jE8rIba6;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756384144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A4aU0uEHOZFRgEo14ahRrdffnM9KY2ffZbdFZGoZwIU=;
	b=I7eH04q0xUGWgaZr3zm8SNCAuUKeIN58gS+q+XnuAElfuhykGkUtYz1vrBNj3VWDIEIYFH
	HlPIpkLbhYmhHhfRB3e9iwKFx3CwUYdUZm0hm5nXN3PMGmp/Zy4n46yfnZUNCiVffVPA6t
	JBGfhhQuk5idD7PsImYsHMDcjFQ3xMg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jE8rIba6;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756384144; a=rsa-sha256;
	cv=none;
	b=0IU9PZo3vkeBMtlSd2DIjaUNFQPi28LBIw52TMiIa/UnU78Cb3f3Ght0YSzpmkMP2pYfc+
	3855Vt+fM0IwUUev5QBhRgTIwmrLDyydEuyWvhCZhD1azFDlky/9NZbakJfrseGA5t1FVC
	G5tTasQNkt+iYNrYHaeo+LZunxUP0UI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756384143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=A4aU0uEHOZFRgEo14ahRrdffnM9KY2ffZbdFZGoZwIU=;
	b=jE8rIba6KPjW/23HodOCu3H4CEVUtm7Qvhf9PlaoGESi0oaq/+CKfiJXZx231k+RcQAqnf
	ZMgTZASvszsmCu02VuqkR3eI6kHnnR61sZVp268SzQjZJKOXyKx4BQm9sc1vpe/t2qC3rh
	6FbeU4c1uNBLrkUsu2zho0kJEo2kjNo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-359-iT_F6lfTNOqzjiv7AxLGZA-1; Thu, 28 Aug 2025 08:29:02 -0400
X-MC-Unique: iT_F6lfTNOqzjiv7AxLGZA-1
X-Mimecast-MFC-AGG-ID: iT_F6lfTNOqzjiv7AxLGZA_1756384141
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b645707f1so3963545e9.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:29:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756384141; x=1756988941;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A4aU0uEHOZFRgEo14ahRrdffnM9KY2ffZbdFZGoZwIU=;
        b=sBS4fG71ouWEoxdTOqhxTQrRYqHfdkipB+J29+GTXBwyrzO41YRJnkaSXbmGNPq0+6
         K04vK6OABaHox5VYveiC2zwJ0FeSX+OzqmdidSEX9fc0zzVoA6EHYuD6s9Wu3fXVgGsi
         U+mw8xj4qJkBFbnndn38vEDSs+PyoBRCwY9DXtpsx2825c8emUxIt3ZcAq/wgk8pOxn0
         6j1/OJihf/V2N8RIrdyicur+57gzfF8OCz3ohX3BiQq3GTZzXRZWbVqBbus/bgjIIdxc
         T0bAWMsNSMJs5ENswctcjST5rUlg38RXO6GTsXTEz96qNSy9gjWA8cSNgffv4g5tWy09
         L7BA==
X-Forwarded-Encrypted: i=1; AJvYcCXGW3Zl0s9+yGzyE1jyrAvyr9zYJvBTnQ8ka4KuBOz0l2wjczgjB3gSk+bHI3uKccY9G2dHm1LTGA==@kvack.org
X-Gm-Message-State: AOJu0Yw0PjNV4Qx791rVz99jVpo/tFSzsV2zG14lpz8EsLhNgRbidWrX
	3ui0N1QR0V9fnTWE/zne21Bk4u3LM4O33zzqjDm9Bwgg2I5VkUZu3T0urPkujpnVZLJyw9T6y1u
	kRncMthAol87AvS3XQJEQ5fCabZkfZiWlFSTokz8k6ZSii4tHTYiR
X-Gm-Gg: ASbGnctnxo63tcCAzUuM3ooWsYK8pc2NciODFOzHg7M0afMTSTewZhc/Z9g+k54VFjD
	qyzc1C779i5CIYlhP7UMldgJbAeh3IHZUkG/CNo9ojLoX8N7W0isUISgzt91Y/sAJZtIFepgVXs
	WyxfjORsOS6FP3x/G/Okc9OReC2I1ilGlW0YJG3D28Th0N4myiXwBc82hTq3NG1+aH+uoiqLFGl
	I/qhPl32hPHgRtZibI/CkrK/8p2SjSdoX4tnbkQnnzAUlsP5BiW2iOlSKf4xtAXxjWGVl59B0RQ
	Y7Mb8fgIbROAZgjXTV8dZiO+IgVZ7QRU+vmBjEV9zckdUq3UX0y3diRynffJxfCerfUvp1shzJg
	yus0GKAEmA2ebr8y1YUcciN+4QX7uiD04M+//0s6vv8Vgj4c677pn7sPITGn1lZoDPVQ=
X-Received: by 2002:a05:600c:1f95:b0:453:78f:fa9f with SMTP id 5b1f17b1804b1-45b5179cfa5mr199732005e9.11.1756384141035;
        Thu, 28 Aug 2025 05:29:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGK3MX5lHCe0T4jC6Xgyog17ATNhq4neX8rCMwBOuVu2rIRWQg/r6Yth5zxxMIPiF4hGTLSlg==
X-Received: by 2002:a05:600c:1f95:b0:453:78f:fa9f with SMTP id 5b1f17b1804b1-45b5179cfa5mr199731685e9.11.1756384140573;
        Thu, 28 Aug 2025 05:29:00 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:c100:2225:10aa:f247:7b85? (p200300d82f28c100222510aaf2477b85.dip0.t-ipconnect.de. [2003:d8:2f28:c100:2225:10aa:f247:7b85])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f30fe02sm71235425e9.18.2025.08.28.05.28.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Aug 2025 05:28:59 -0700 (PDT)
Message-ID: <27a21510-e9e8-4eb2-9e26-618c103d49c6@redhat.com>
Date: Thu, 28 Aug 2025 14:28:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: add `const` to lots of pointer parameters
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250827192233.447920-1-max.kellermann@ionos.com>
 <c688a2f6-375e-4a00-8d44-6a833e3d30ef@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <c688a2f6-375e-4a00-8d44-6a833e3d30ef@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ivgJoaTouR3lHleTlE0mT78QNjm8KbuonKzPRJVwvLQ_1756384141
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gto3sxz6fpxeqsoz9aabao53g9sjua8r
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A7FA120006
X-Rspamd-Server: rspam01
X-HE-Tag: 1756384144-523580
X-HE-Meta: U2FsdGVkX1/oM8qA/CDTnWtrnQTXnRBXMtF2YiDmCUwOV4fGABGMIQv8UYRL/3ZC5ahJ3YBIZRi04XwxM0wpG767lG3mPQ1sLlyFb55FhejTNR/wcGY4JGVu9a6NHGI5aDDVHvLLpM35KcA3yKd8CVwofj1k0qqW2IYb/RO5E98onYxQJgnAtG9utkznrDs9vDlQNHEDqFZk96JZoRXD487fPXaXIRqUQmGNhMU1Spf2owqZc7TBy+akIsJBAlbJvPeo5siEUDtXDnFB9fXIb5nUN9m7k/gkAtpcuIgx6Zs4sHHIkh29c329YDX7XRYsOAVbtHoZIBZr29LAju7OrhzgYxQCU4TF4hOdfLkMwl9sxw2mD/SEGfTXDa6FmoWTZtylMfhvTE6ZfzB3eSqHhDP9H6tEz6AD5KHa1b2y5ag02VTbuVxV/j7a9r+MpJYUOBiWoayuzCft/MM9liLjMYQgd8qjvaaEx6FzgPGFzTjoUskClvvKItZtaQLfMO5u69ZNpkCIS9L01Ot/sPnWYrpQyNju5WfRxSkReb9iQ/BCw+26zTriin2H1BkAS4RM1kiCyyhCL62lMULA9YZJbfCNA2RC2oDepvoU+KQ2kRkkhFN5apH5Zds7dBAkF7ONqE8ueH0Wz6jMV+onreW8t+ue9vfckKglqTnB8/94dRiMMuhmYSMivBZQs4DFVkYLNE6JJ01WCRkwk/Rz6NqAIpvwtRWjyE4mVxhvW1BonxoftQfL7aPUPhPoHmx0JJS9ze7sN6DUTepApX9TU7BSt3YC0cApRNLv0FAH7cqcKYDEp/JToqP1OgqbxjeVJC2/Qcbj5D0wVerJa2LOVlJ7h7I/cNsIqKN3ossNHE7LXLypydrpOYyRmSaGLcvwCYptflkkP5ccXXQGru7eMjN/QqwH2c+gVRL27AIGg6nUnEa11y45LnE85JW5wR6uyyd/F5So2I7WqmhpCgyIeAy
 Y14UpQqW
 Mf0t17z+LSK8hd6jR6GCTnK0r21YNdYyeKxnY5cBZZAkTkN0kHcbVRGrWlHv3LTLQEpRVewBLsyIXtU7o2wnOSmhMaTZm0Kf3IGzYvfGd8wd8sLWlzrlKOR+6xJbvJx4hFDrdWY4GfJQDEtjWdmXZIOXJE6d11xbt1P+BcdLjGYnvAefCpF96vesH14RViEVdlyyTO9Sbsq76f+MMiOvvyifnfFK0YaTDgJVn+JvW3It8+puetQf3yFfmlYCzgXMQJMqFbOUHjsRy3EqKiWgvZFzWJ6HLlpJ9RjppUTMiiEYIz13ynGTTuK4b7j3uK0Rp1DygRWoS4XxHiSFRMjcRBWnuXMJkXwtB3Ew5PRzJ2fa6mqNdnPOqZlExdAmc7EJrbDT0h9POGKwLlZcPrAD+wKjWIx/nbrwtpBon9bZ5cE9UnkjTz7JP6fB0vYC9LMrtYpri6KJ+ZEk/6Lhq50BmV81+bY34F4DrlizkmJAhEd8to+11QW+He3wwQau7ffutGewNhq4onkNax7iSnuMoCAmt8eU1qfVmpatMinwUKJ09D10nZYKf19mRlMZVOjBX5MdsQST/4maSLgoo14F2Zy/2J35wV/a7yxdRKTDb6kixb2Z4Olb5iY3oNq6uXVTGM6XxXFFcovbRuNDU1i20SdbaQboC2PYJXAYvDi63mE7FuUBAnIQunblCLL4TujF50XaeVCFbg1JaWK/jWwxUN73ExZgNWz2HbbaFx5aI97jCnruHq3sbATPVJ6sFDEMLypXTVn01BCFtttIZIjA2xaSIIJKlhNHSTxfi/k7EW4QV236Qhfpz8+Rrp8rC0HxmDRyJ6/l1jEs5eVMKPFKjY/9vegr5ap55Rw6loNt0Mm3sZlc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.08.25 14:24, Lorenzo Stoakes wrote:
> You've not cc'd the right people here.
> 
> Please run scripts/get_maintainers.pl on your patch series and cc all
> maintainers and reviewers on every series please, as well as all of the mailing
> lists referenced.
> 
> For this change you needed to CC:
> 
> Alexander Viro <viro@zeniv.linux.org.uk> (maintainer:FILESYSTEMS (VFS and infrastructure))
> Christian Brauner <brauner@kernel.org> (maintainer:FILESYSTEMS (VFS and infrastructure))
> Jan Kara <jack@suse.cz> (reviewer:FILESYSTEMS (VFS and infrastructure))
> Andrew Morton <akpm@linux-foundation.org> (maintainer:MEMORY MANAGEMENT - CORE,commit_signer:1/1=100%)
> David Hildenbrand <david@redhat.com> (maintainer:MEMORY MANAGEMENT - CORE)
> Lorenzo Stoakes <lorenzo.stoakes@oracle.com> (reviewer:MEMORY MANAGEMENT - CORE)
> "Liam R. Howlett" <Liam.Howlett@oracle.com> (reviewer:MEMORY MANAGEMENT - CORE)
> Vlastimil Babka <vbabka@suse.cz> (reviewer:MEMORY MANAGEMENT - CORE)
> Mike Rapoport <rppt@kernel.org> (reviewer:MEMORY MANAGEMENT - CORE)
> Suren Baghdasaryan <surenb@google.com> (reviewer:MEMORY MANAGEMENT - CORE)
> Michal Hocko <mhocko@suse.com> (reviewer:MEMORY MANAGEMENT - CORE)
> Axel Rasmussen <axelrasmussen@google.com> (maintainer:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU))
> Yuanchu Xie <yuanchu@google.com> (maintainer:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU))
> Wei Xu <weixugc@google.com> (reviewer:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU))
> "Matthew Wilcox (Oracle)" <willy@infradead.org> (maintainer:PAGE CACHE)
> Hugh Dickins <hughd@google.com> (maintainer:TMPFS (SHMEM FILESYSTEM))
> Baolin Wang <baolin.wang@linux.alibaba.com> (reviewer:TMPFS (SHMEM FILESYSTEM))
> David Rientjes <rientjes@google.com> (reviewer:MEMORY MANAGEMENT - OOM KILLER)
> Shakeel Butt <shakeel.butt@linux.dev> (reviewer:MEMORY MANAGEMENT - OOM KILLER)
> linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS and infrastructure))
> linux-kernel@vger.kernel.org (open list)
> linux-mm@kvack.org (open list:MEMORY MANAGEMENT - CORE)
> 
> Usually I'd cc for you here but that's too many :)
> 
> On Wed, Aug 27, 2025 at 09:22:33PM +0200, Max Kellermann wrote:
>> For improved const-correctness.
> 
> 'const-correctness' in C is extremely weak.
> 
>>
>> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> 
> It feels like this is a bit of an arbitrary subset and this churn is going
> to make merge conflicts much more likely.
> 
> I mean, if it's just that all this functions accept non-const VMA and for
> all callers _from_ these functions most accept const - it's not really
> accomplishing much other than adding a bunch of noise.
> 
> Any meaningful change would require pretty huge amounts of change that
> would be horrendous git blame, merge conflict, etc. wise for really not a
> huge amount of benefit.
> 
> I feel like the ship has sailed for this and I really question the value of
> doing this in this way.

I recall that Willy did some more targeted conversions of that kind in the past regarding folios.

E.g.,

commit 68158bfa3dbd4af8461ef75a91ffc03be942c8fe
Author: Matthew Wilcox (Oracle) <willy@infradead.org>
Date:   Sat Oct 5 21:01:15 2024 +0100

     mm: mass constification of folio/page pointers
     
     Now that page_pgoff() takes const pointers, we can constify the pointers
     to a lot of functions.

I would appreciate similarly doing it in logical chunks.

-- 
Cheers

David / dhildenb


