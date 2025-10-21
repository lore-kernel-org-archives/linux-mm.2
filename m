Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5366FCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 11:55:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B12CC8E0019; Tue, 21 Oct 2025 07:55:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEAC98E0002; Tue, 21 Oct 2025 07:55:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B2568E0019; Tue, 21 Oct 2025 07:55:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 878BF8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:55:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 18FA113B032
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:55:02 +0000 (UTC)
X-FDA: 84021965244.06.D187DAE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9060840005
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:54:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Zh7EGHoW;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761047699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UjhTzDfDRfRTb0ujoYWqdsfQUJ32BJBRRtMqD14uvto=;
	b=bab8ZpPzLLgAYE5TaooMEZG1CARp5+s18BfmNCi7rhmWk/GceWOWXhpPkSOx4sbtGbdcjr
	/1TERz2qwpSMYwwld0LG7n7OptO+w7IOEZwb9hgAmPcuUmw0YcV3OO82ypy/qtIvjzHMtj
	i5u36UgkuDr3BegAerlRR+fnOq/RE3Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Zh7EGHoW;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761047699; a=rsa-sha256;
	cv=none;
	b=zfEI2DOWY0atgZ1p3C7xAEtHELYp6srEbHRqxEmsBTccFLkMjgD/Kud+B18W7aReuuPfrr
	VHqwqux+lmy1wPe8+urPsWHHVZdpUhg4INYSMFCJ5JPaLeoVWIJFpugW6SVRKduM5WnjE2
	q/H0VmBtBJy8rbmLCWC+c+zaPsysvIc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761047698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UjhTzDfDRfRTb0ujoYWqdsfQUJ32BJBRRtMqD14uvto=;
	b=Zh7EGHoWE1QNyEc7Lqpt6Z8fJ4HXKBHAt7wTzpI3/1TK6KkcRG1aLB5MYnHTIY3SBpdL8I
	viRB2+9diLEcwRyfRkE5tGos1uZ481mpNW6/FeHhrR6B77tycany0md+uzQJPnVnRFGxXk
	3PRPZNxGn2MHEbUf0PaU8u+ijSmc7u8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-138-rQFe0yHTMr2y_J_U9_pA-w-1; Tue, 21 Oct 2025 07:54:55 -0400
X-MC-Unique: rQFe0yHTMr2y_J_U9_pA-w-1
X-Mimecast-MFC-AGG-ID: rQFe0yHTMr2y_J_U9_pA-w_1761047694
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-427091cd689so1978736f8f.2
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 04:54:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761047694; x=1761652494;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UjhTzDfDRfRTb0ujoYWqdsfQUJ32BJBRRtMqD14uvto=;
        b=UMulWtHFNqPKwLV2eXMR4XUSWnmlCbK7c+3/9i//O/ji+cvuQg3QZwuVRTlFJ/tz9t
         dSHbcAaTd+YGvVsYof1p3P5M4xdmgc7DV3kbwlPrDp1WBKFPKg6F4EaUXBPVVY17Jiz7
         6G1+gKroQSeWnby9YkDAdMqxXa4QuiTkXvP69tlThhj3QoFK+BNfU0s8WMB1eZ43uyqI
         Ja7fvEGfw3FPK+MG7fBZ28BFRfVmvrDh0mdouQv/AOg5wHK21PCKkx/+6Fi/nbNtR9dD
         TaMMir1XaC6bBU/6MOTIzExaBQqhPvKXlLoFR9buoaztOlw6yxuv6nkHMLuA6GqtZ2yC
         rFSw==
X-Forwarded-Encrypted: i=1; AJvYcCVcd0NkK2BAlm/7jnauOkPOc6um0GRkI5ZW8P8VC9ZtO03TBsbr1PwtIJent5GwUHHL21/aOA3IfQ==@kvack.org
X-Gm-Message-State: AOJu0YyZ6ZQujOEjEll/CtwQ/KCsemZZWUAGu0AdA1UaPQTWOv4TkWmo
	rwqTAOXiHD7uMJhQlP0XClP9PrgmdMnfJwXebETobdhT9tfh25wNnfa6xvnqONeyBmAzXtnbUDb
	c+S9emui8HrVXRolkCR8qhiR+bDMWyZ0/0orZjqi6PhDpG3NYm6BN
X-Gm-Gg: ASbGncvNc5KH+pZ/pAOIYBNSXFZIJC7n+u1zlLhxeCsymtAByDhSch6Ys5x0hQjc2YR
	k1Pa+OxN9MJQhCYNpe3476DBCfTUrvxwOWMsHxO73JjXEvAmQYCElhzKSpbEdrsXjE274uXPp+n
	d5Es4GCU3e+kyzYU3r2jN9Ywx/+OkDRvtkr9WK932RZ/PEziEJvocyYIW2wGj3rjqGml0XaVdrn
	uibigFermc51DDJCXSE5O/7pun6aL5T7MZezaKbWvYVuHBzTPTZDoBMF4ah+emPKQsvhmYVHpRH
	hHGGaogmOhJyb+YkK9yUjTVlXo8U/wcl/gceUz4wXVJmmch3Kp/2YoBHaEmU744cKPQaQEuvgzk
	8y+EGVYf2QmJ3lSor4RtrZidwBL1zr1cIue2K9A3cMiW7rE/7eki6W1a2SQ1zKRszoYVpFjxjrr
	XZ490yXLoacRRQDufwfJckugdSidk=
X-Received: by 2002:a05:6000:3105:b0:427:64c:daaa with SMTP id ffacd0b85a97d-427064cdaecmr11329367f8f.44.1761047694116;
        Tue, 21 Oct 2025 04:54:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF4hoS405o7SL+OX0J5tYiis8Ib15FCEt5fy5LSf9ht7t7QJikfAXYAkg1xAnP6qrMgvDH/9g==
X-Received: by 2002:a05:6000:3105:b0:427:64c:daaa with SMTP id ffacd0b85a97d-427064cdaecmr11329329f8f.44.1761047693656;
        Tue, 21 Oct 2025 04:54:53 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427ea5a0f88sm19307889f8f.7.2025.10.21.04.54.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 04:54:53 -0700 (PDT)
Message-ID: <e4349d5a-33e8-4b8d-b1ad-6192ba00ff66@redhat.com>
Date: Tue, 21 Oct 2025 13:54:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/truncate: Unmap large folio on split failure
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins
 <hughd@google.com>, Matthew Wilcox <willy@infradead.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Darrick J. Wong" <djwong@kernel.org>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251021063509.1101728-1-kirill@shutemov.name>
 <20251021063509.1101728-2-kirill@shutemov.name>
 <a013f044-1dc6-4c2c-9d9a-99f223157c69@redhat.com>
 <37ceab54-c4b2-449e-aa46-ffaefe525737@redhat.com>
 <eokncpih37zm7ypt6gn5xyetx6jlemhvvfdzpmdlxleqlsqcr4@45h5w5ahwugs>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <eokncpih37zm7ypt6gn5xyetx6jlemhvvfdzpmdlxleqlsqcr4@45h5w5ahwugs>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: q9CHk7-NNqtXtYlFdRzEIcvD9YlPxpoaKjEVd4w2318_1761047694
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9060840005
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 4f644qk5xo5873ixe4ufbm4fyeghffw8
X-HE-Tag: 1761047698-35134
X-HE-Meta: U2FsdGVkX1+t26uAVr02Q9CLA664V5XYPtEldKS16vvSx98ARWNOuwbPv2SoMJBFgZ//6lisPu1ehvUO1tMZW1O41RdqHgDLbMFgor5cCI8ApXC6oIpvDWfx4q+2V443vF1TdTmtKInfZU7CMyXMTrm0uWgjICvTI+YS6WcpHSZBiqbN9nkHZHX/XZkAhLDwclKrFXkGgN4z552JOjkqhDtcEkFsgVDoMXTU1zD5fQPhjGpIp8LCyBvoXjeKQRM+9qklL3wvTc4U4HU8741+uSSlQDP3VOpybcbNytADNGIvX+rJwyNWANP4eGoEoeAErzi35ECkfet1+h4vrvFW5HXD34X4SBKgY7TJSfQnSwkLgblv641U7HrR1rFXTpSC/MfnMA/Q+TXPZutEXWyJ4nbcwMfPacw6tUP3kYJpb5lQRJzD1XZv8gST2Lc0LKphvaIAIA4Q0oDg9on+O+RxCAUK8PxwMSSsIEcG3uIZ6al+s0nRWes2xyd7nWstZP9iS6MrEP3l+/jtGLBzc7mLtFENxHSu+8DDf0K5Tl5olU9iHbAsRqPG/dGFlH9bML/iY3k0wdifsdZbsodfj4Xlf+mLux6oFKgPCigocqRJS+iuyt7uc8tQIeOLUsO1Avm32EwS+xaZsXIkjwcFNFElhgXPkXvwms7Uhjdi5ptDKH5iG7SzKIhJf48+X4iabiRLWVge4CYzXqfymrUcfPHgizKa84clRvJG7GrXRiwFane60M5E5TSnrSCMCTaFsNpLQ28fuI8I9w4CMPpCu5jA8iSf3cZCTdCz1SQgZMGZYDyEFVf2oFSNU2Y6QZeOoumQYpMsP3Qhy6fboGCYU2d+Xux4ZPWFOATQCSDgjm/uuC/hT93+4k7DvdBHrPLXEummjqkljasz9W4qQ7TGHprKu56fxQ0C50mwlLjKfD7JCnpmMc46grIiZNW7WcJiqUgPqzKxhSj7EeH+m18yC6m
 7q4Gp8j/
 U3muGp2Dr8Xyf1icBKXaily6vJzFwr1XQ/HUAOFfb/8qeCcEbF5D4Y1isMJtSlLQ0rRb0i3AqhOqJSK58lnkDY4LfJti8EscGB/+KDhvBD4VbtNmvWSgP26nWxnF1xwdPgiWgI1ugurOD16DpfKTCxHXA97iicCsQqcBTObUgi1EbNM+lxSFJh+Mzc84B5OeqoIFIcFHS8EHJDkjKqbjOqQ/xo6qB8q/UXRuFiflYf7WlnsuJpxO7oZXwbdRKjiQHIuEqAyfhxC6TtTezw6t71R39+60gkNSqcdXQqHEq6EXDxh3u/NbX4sf6ff4Kulbxk6v8L+LQFwp3lIYGydsnphyOqzqrj5pVzujDhnQKtOjItJo344Sbe6WLjT/1QTNMlRNW1L41Ys5u37faInQHFl4hXZ1+ptDBB9uk1RPI4I2+YlJeOXBWj0E6g18qJ5WHRDtyPmxJ7xepRgo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.10.25 13:31, Kiryl Shutsemau wrote:
> On Tue, Oct 21, 2025 at 11:47:11AM +0200, David Hildenbrand wrote:
>> On 21.10.25 11:44, David Hildenbrand wrote:
>>> On 21.10.25 08:35, Kiryl Shutsemau wrote:
>>>> From: Kiryl Shutsemau <kas@kernel.org>
>>>>
>>>> Accesses within VMA, but beyond i_size rounded up to PAGE_SIZE are
>>>> supposed to generate SIGBUS.
>>>>
>>>> This behavior might not be respected on truncation.
>>>>
>>>> During truncation, the kernel splits a large folio in order to reclaim
>>>> memory. As a side effect, it unmaps the folio and destroys PMD mappings
>>>> of the folio. The folio will be refaulted as PTEs and SIGBUS semantics
>>>> are preserved.
>>>>
>>>> However, if the split fails, PMD mappings are preserved and the user
>>>> will not receive SIGBUS on any accesses within the PMD.
>>>>
>>>> Unmap the folio on split failure. It will lead to refault as PTEs and
>>>> preserve SIGBUS semantics.
>>>
>>> Was the discussion on the old patch set already done? I can spot that
>>> you send this series 20min after asking Dave
> 
> Based on feedback from Dave and Christoph on this patchset as well as
> comments form Matthew and Darrick ont the report thread I see that my
> idea to relax SIGBUS semantics for large folios will not fly :/

Then I was probably misreading the last email from you, likely the 
question you raised was independent of the progress of this series and 
more of general nature I assume.

> 
> But if you want to weigh in...

No, I think this makes sense. It's a regression that should be fixed.

> 
>> Also, please send a proper patch series including cover letter that
>> describes the changes since the last RFC.
> 
> There is no change besides Signed-off-bys.

Then point that out, please. It's common practice in MM to send cover 
letters for each new revision.

For example, Andrew will usually incorporate the cover letter into patch 
#1 when merging.

-- 
Cheers

David / dhildenb


