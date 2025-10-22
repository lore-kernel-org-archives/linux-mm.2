Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1302CCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 08:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED4EF8E0006; Wed, 22 Oct 2025 04:38:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E84E48E0002; Wed, 22 Oct 2025 04:38:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4D5C8E0006; Wed, 22 Oct 2025 04:38:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C34088E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 04:38:05 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 71FAC88C25
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:38:05 +0000 (UTC)
X-FDA: 84025097730.15.2838D19
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1BFCB4000F
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:38:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ln9gJ4X6;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761122283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HORYs91dLQQexQDsveH7tAbNx9ev00vg3VpMbAGTK3I=;
	b=h7FOvSLvpD34Wz1me3xxPkIUgE1ZzhPbTGjsG0IfT6ino8H2Q/XbZpyevdvxi7F8fDpEhr
	MP/CbIek6MEYac483EwmYfJxvBm5xWVfrDcFNQLHq7K4I0ri13+CiKRRnIGZkuUhhBn+1y
	E8FVE1xHmEMpV2/B8L1wytFPuDLt4Hg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761122283; a=rsa-sha256;
	cv=none;
	b=5Y5eT7nNLnnYWtlTXyRDcHtJ+hR6dMu4LDa2S5Hu6sKhQd89pqoUjh3epznDl3Omi/kPx6
	l/PCkzCpUQP23X0pAC3iTMuNAdW8KbjUX8QUcL9tYvzcvU4+i4VbSLI6rmA0NFBHm8WqdQ
	8Q8Q+hgMFbh+Nyb5OuQJQby0e6PWTkE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ln9gJ4X6;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761122282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HORYs91dLQQexQDsveH7tAbNx9ev00vg3VpMbAGTK3I=;
	b=Ln9gJ4X6O8IMGvpDRX2rxiZy+5hp2YlPlkl2NfGbXgC1CjcQqgmc2s1P0voQhFkHSVic0O
	ZVojtXYO0u3pLtJz7JIQfX7V7dUyxQUETrMJcjh9Arb/0SNWPL232Ot9ho6h0EAX0qbAGl
	chv416zvOMwG+KlL+VRLT+PuMsaYs7o=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-qKUqI1KrOduS3ZBXLqduqg-1; Wed, 22 Oct 2025 04:38:00 -0400
X-MC-Unique: qKUqI1KrOduS3ZBXLqduqg-1
X-Mimecast-MFC-AGG-ID: qKUqI1KrOduS3ZBXLqduqg_1761122276
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47111dc7c5dso3601305e9.0
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:38:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761122276; x=1761727076;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HORYs91dLQQexQDsveH7tAbNx9ev00vg3VpMbAGTK3I=;
        b=jZBkEZyztIMBPoeOi7lluePGSroXALZEFIDwBw6PvVY+yeDjhfI0wejvRDY+0oQWJH
         M2xJYySKC8t35sE1yOF09dU0kH/4KYQbSefSRMha/CxhIfsT1vVdrnbuAqYqr8DDDDFb
         0xZgua0thR4Sbk83FQYorY8gj3rKPOqI3xpl922vEJTx07kaenb97d7B3IwrSkep8MnW
         fDAGDhvd31DJWCn1Ko7Syx5Qp7iOAUop1pKIJRAIz6IkH8MHq1PekO+zV7+y1m1hSF2D
         cWvSE4RLSzfK9nWBcZGiD9JKrV4N+oJoM0oU6zIX6zy5tvP/uu4bohCZzUIWCXE2vMB6
         g4Wg==
X-Forwarded-Encrypted: i=1; AJvYcCUJYObBH2S1YrNLPQEloQB46trg77rZHVZNIfKZTgorQibKJ2BYhib6bngWtO/r+4qq9duQ1DLNbg==@kvack.org
X-Gm-Message-State: AOJu0YzxceNHX+e52nfM3jrKkXzxCBxiOPH38TPBz4ewHxaWk4qEfTuB
	MJrDA5Fd35CwRSqfnWR1/tM1130HEdThWceQBQF2QaD4eA6pN1CwzRMVW+pH/ZFtRqRRZxU9wNI
	BPjMG57NhkonKkwjTEhFnOS6oX9nAC5Hdo6JIj1FJkvj3d99CM8Q7X1Dp9UTw
X-Gm-Gg: ASbGncvPvNpTjNVFaV3gIvwqV7oJf5U7WezfE5p+/jEcaIP3+xJui2sY6IvEEhKDt2z
	65RnV2Uk/eZEtuImU568DJR2oVr3zRte//C2MDufJv07BI1pC5Zewyhbs4SZJIyMUMCI6guREVN
	kBik6UzsDdcYe3O5hr13Z7AtaijKo24S/on0S5k5g1zubW8wyJl5hlf1yfrTKhmn63jSv/ES1L+
	J7o2D5h2z+Iq4Hya1P6peuvhldgADdsozYiL3xj2XDD7SkSL68dNp5d5CTRi863av8k0L/E6QYl
	fogK/zxYH2eIqklu0YuewkWpC4hBzpBYjpWzaMCvQui0Ro4lIXt36+SVFRRfLuvt2X5b6O+tYKb
	oCviYOCQvkUXNQQ6AZOYbLVgoaKp+vsdU7U1l2bJqwJgKaocch31TlWsAjMJsS9EivyPnGMmxPE
	zFkRf0rsl0U6cBtZtZ/n3ntEmYXN4=
X-Received: by 2002:a05:600c:8b17:b0:46f:a2ba:581f with SMTP id 5b1f17b1804b1-475c3fe35f4mr18215355e9.16.1761122276475;
        Wed, 22 Oct 2025 01:37:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGZox5bLuD2Cm8JqdEWshafSicQuJ3K5TI0WpKQPM9/qTM/uKldxHeAV/RdhcTW+7Drr2Molg==
X-Received: by 2002:a05:600c:8b17:b0:46f:a2ba:581f with SMTP id 5b1f17b1804b1-475c3fe35f4mr18214965e9.16.1761122276037;
        Wed, 22 Oct 2025 01:37:56 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c428a534sm37256955e9.6.2025.10.22.01.37.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 01:37:55 -0700 (PDT)
Message-ID: <2fa9f196-12e4-4c1a-a1f7-cfdded93cc94@redhat.com>
Date: Wed, 22 Oct 2025 10:37:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 04/23] mm/balloon_compaction: centralize basic page
 migration handling
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, linux-doc@vger.kernel.org,
 virtualization@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Arnd Bergmann
 <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, Zi Yan <ziy@nvidia.com>
References: <20251021125929.377194-1-david@redhat.com>
 <20251021125929.377194-5-david@redhat.com>
 <20251021164916-mutt-send-email-mst@kernel.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251021164916-mutt-send-email-mst@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EUX31vQB345Hy5C5G94Am4S6b92_enGFuNdQmu7lQTQ_1761122276
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: 6ko13s8myirbiu5yy913gbnw1499j7cw
X-Rspam-User: 
X-Rspamd-Queue-Id: 1BFCB4000F
X-HE-Tag: 1761122282-393572
X-HE-Meta: U2FsdGVkX18wxs0PIp09fYAjpN7D3gFLo++Pil0JXPCiGq6/gZfOxxEo+YTtOj62siHlevruJGSZ/MmrsOpQwgF94yGBI0RukGHV9RANB7xw3/dXv3geiW0L4dfA6t2I6K3vWLNlSxZkGFFxXWvDbyFw8rGxTXaGxBTWe7/ZQyha/Pvan7TULvPRRJLYFVQe51/BznlUDDVbCUhiziH2Q1zBZttKT3JdEHaeIzOzDbqrrrocXhUnbNz8LmYjT/qtN6IDn1bstB/S+GaS4fmJLGJSWmChgTZz8YH9sM8jkuEfgiuqwjpN/HLfWGFNj7nANPu6UiWYr/MKQkQHfnCykgbJQviTIJp1sYUKpKGRTAsKmuLrUyxUEXmQeDpUowaDHz/5MTYb9HCMm3MuL5Az/B/yTGBGT6sFAFJa7IjYWsOgHBybrxgI2IKHMY3qZPIoCHxGOttll8PZL8gluRbbjolOHGHfx+lzdqTmTB7LmPEpZ+ryGNiRq4eivtpB9jkxiPQJR/v9wH7knidTdvb7PcLYPaCzRkvjcmjv9yIXjLDtmaWNvKCNvMSySBLDZyqH0WjJkPTjXNSxXHFLOy1c4jeOPI/BlDF5mwTvIXnQLN6kX/1GTDacKFe4IF8x9E2e2CO8ETFNXBgF3d/yhbrx9NxRQ3PI89nTjOOSc2v0JfnCAp4i2iGNOiqu4IVovpDxsXmtQN3OZKEhzRzPuxpzOZA/yt+6oywm65L4XUBIlDsWxyK5YhFVcQaXgVUSb+shd1YXtwYTssPGYDjnH/Vs/EEtR8yB0Upc7aRpWC2vTrPSgWFDVi9xykFW24JIsgp7+hbjEBFpyw9kVa7cASJdn6IuOukA1J79D1T6NIDts8nRKf5kAqNXKGhbe9TLUcyRNxhwrUTLT5PYw+2xnhUmdBpRuLzyraY3Aa2H6mXSvNpDaGHH/Hy04rROkSSkBH8wAykMZj1r0EUdOyhgQKr
 ztTeD8V2
 KPEC+5iJ41EtfYySDR6vJck3e06Mayaf8jUuAQqSFiHpgyRO0P1ZZJhSpQ+vmZ2XlmPQmCWbFtIulCrCIcirMMKxuuwMBJI9x5QyUpSlvBTooY+lsM/O0erYiMR88HQLt/oY0owpP5UFKf1vFPD35dKsUK4BXhxIV2Olf0wwl448taplq9PM3cx4xG/NjgwA4QE06EvijoEYJbHpu2aEt+r2LrOEZJZErCbsl+Nnr50kkDT9Q1fn+7l8v+ZmJJEsQH318Cx8JoRYluU6Xhm/pwVtpkHB4ohDVG2XjkTIvBE9vqflC0rOhbl0jIXOu80x/ywtMX78EM0b6cHmgbvz3OXYDljKy7YriJRXWkY5BbT8KeYwD6dAQlVAAFAdu39i7MwurGafEon/yeJSBL80fAxYCs+W9TdpiSzqxoEzBNYS5YALvs6loyTfLx2vtBfkyM2W0gDH60nyLoVOoq433OiGJGaRhBy/EWbchchWQKsN7ePRZRQPDLzYQdhJQGb4+3I3PuYWZOCJhgofH/0jj05bSgwqoSAp03YEo8vDX2g5ZRFGpKU+7a4L32n0Bo52QZ3paDeO8sgIJ9sDwl8OqqJtdKonqpni+EhAy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.10.25 22:50, Michael S. Tsirkin wrote:
> On Tue, Oct 21, 2025 at 02:59:09PM +0200, David Hildenbrand wrote:
>> Let's update the balloon page references, the balloon page list, the
>> BALLOON_MIGRATE counter and the isolated-pages counter in
>> balloon_page_migrate(), after letting the balloon->migratepage()
>> callback deal with the actual inflation+deflation.
>>
>> Note that we now perform the balloon list modifications outside of any
>> implementation-specific locks: which is fine, there is nothing special
>> about these page actions that the lock would be protecting.
>>
>> The old page is already no longer in the list (isolated) and the new page
>> is not yet in the list.
>>
>> Let's use -ENOENT to communicate the special "inflation of new page
>> failed after already deflating the old page" to balloon_page_migrate() so
>> it can handle it accordingly.
>>
>> While at it, rename balloon->b_dev_info to make it mach the other
> 
> match

Thanks!

-- 
Cheers

David / dhildenb


