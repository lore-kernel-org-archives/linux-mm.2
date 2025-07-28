Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36B56C83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 12:27:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2ED96B008A; Mon, 28 Jul 2025 08:27:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B07006B008C; Mon, 28 Jul 2025 08:27:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CEBC6B0092; Mon, 28 Jul 2025 08:27:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8CB566B008A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:27:38 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 05B4E5797C
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 12:27:38 +0000 (UTC)
X-FDA: 83713599396.04.CA89807
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 982F1C0008
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 12:27:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h8F1O7+y;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753705655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nhndmh/mYDlCWe6LknGjpTmGbUX3l48dYqfaHjSz4Cc=;
	b=4G/b+CQSXKcjETDLY5pCZoPF2R2Xbw6hSRyDbn4xx+zQDgG8ojVSmU0m+L8cFJdV1vlvW5
	+dljYZpirf0fmaXncL5LkXcGLCPKV9hFSx2hOMQ6gYBM+FbPwtdoJ0hAkSHzH00ZOIk85p
	eY7Yjfj4cJjX3uV1CHZOhuTqroDZnqI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h8F1O7+y;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753705655; a=rsa-sha256;
	cv=none;
	b=FSlGzonN236ONHN6QYbldpZWYQGJkatxOLdoZ5bTsIg0/jOuX8KaHipikhjQqWmbSmus5i
	5/svf0shqA5Kfie9OULfNJNWFW7QBQWLkwU0hrpQcGK+jp+cp9exn2UsjSLTwFQG55KXqB
	yuc8CQb4ULUc/qGXEm/akoYgnWi7zEs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753705655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Nhndmh/mYDlCWe6LknGjpTmGbUX3l48dYqfaHjSz4Cc=;
	b=h8F1O7+yy3huR/pBuT+jzyen3HGO8KXUVJ0kRW9XsdTmRA6OBejI1PJW5OqHjjxZElO5VR
	8ZUOqKIxiPusOS0e5wfPoTP6OVrwbN3fnMLW0DV/I0YmybSNEEIDYvwKvrXg6xO9OAu6wS
	9DtGygFBNSFXDKF+ZQgO2/Ylvkvu2Gw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205-09Bcoat9NkCPOM9NVJ9i8Q-1; Mon, 28 Jul 2025 08:27:33 -0400
X-MC-Unique: 09Bcoat9NkCPOM9NVJ9i8Q-1
X-Mimecast-MFC-AGG-ID: 09Bcoat9NkCPOM9NVJ9i8Q_1753705651
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b785aee904so709058f8f.2
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 05:27:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753705651; x=1754310451;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Nhndmh/mYDlCWe6LknGjpTmGbUX3l48dYqfaHjSz4Cc=;
        b=o6MoQIfVblN7uykrHYCylSdVh24Msvx1wxhSWpvAoT+LrhsZi8g/ShMUAcHYPpft2O
         kdKiniBEhWjVFuHpVHeNvjSENCI0QxqnOsTfBQtqq99EYX4XO8ybXSfEl2iKt3GftBYq
         aRSnrX0kecTqxkE9mhQtBJNxG14PF//eJ+rIWdMQTT6ryRgg9h3pRPVTgJRvs95r+3Cl
         3oZ3kesu6p60mW7iy/oNJLMJe+jm+bm0GvbqWKCWL+O4ahNTZt7aGgePv410Q8xSWeTL
         c9zM5GATIEAmVx+VkU6lrhkJbF3ey8WxKGzbuKXbqtG0QpYd9KV35pVuI8MTChRc45gM
         NLuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXGEhNK/T56hf7QNm5scZuO7endhd0VyK8rO/BN65xW+fmtPpMNfgY5QhToumM39dPMeByLxdJ7Q==@kvack.org
X-Gm-Message-State: AOJu0YwJSQPZNo0WGy18HFQnmkBn4T4vqsaRgzNAwyyMYMB3Hjd0R85A
	0dV7p/QYt/firIXJKO5snIeKiJDcj81eknxZFLwtwCNHEsRNElTlxiqI+CsNjEyR7mF2ktyPLeP
	M3F5qiTc4XPb7qV8gQsTwV/xZyGJNlBv1OucugQF5k5V3RpQDkI4A
X-Gm-Gg: ASbGncs8fyH9ezH+7iW5vt3M7DWAdvweGxJVm1vvpR/+s2lGqAiL/rf+JjjGqW4dMuV
	aiSHAoXx//cfnsL4EM/fUEpHwkpqBupWe2gEuoduHJAZ0lYOZaFph/s9DKHz0ZPg8b9PbPaWeTx
	TxxC+fd8AYScbQ2SjrKBl1j+foWllWuyGjo/x3sZCRIb1B45FZdktVurjzSWyBitSUJychhppnZ
	d9Rmy3wh2t+A1CcfutQ0HR3gh9ZLJdUvEtGzEmejicJsx0RJQzHLrm12mbkyF7w/1WwvulTFowU
	z0Vg1vxhTmYzbgqht7w+TZ/PNratL7V/95vzryihWOOs/CN65tipccyToIf48JqESkIX1dlzMpE
	0EgHlhueZSRxofeaeBJOSoue6z4najUff+LMz2zWUMVKG8gMapC3LACWMMSja5xpw8l4=
X-Received: by 2002:a05:6000:4026:b0:3b5:e244:52f9 with SMTP id ffacd0b85a97d-3b776763a56mr6925078f8f.40.1753705651376;
        Mon, 28 Jul 2025 05:27:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFifIQiKDQs73iiVRO9b2dDYen4CTUw0MtmSxVaPuUV0RwNn2LG58Cy75mVAwqs1jz0/x8p5A==
X-Received: by 2002:a05:6000:4026:b0:3b5:e244:52f9 with SMTP id ffacd0b85a97d-3b776763a56mr6925052f8f.40.1753705650797;
        Mon, 28 Jul 2025 05:27:30 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f47:2b00:c5f3:4053:2918:d17c? (p200300d82f472b00c5f340532918d17c.dip0.t-ipconnect.de. [2003:d8:2f47:2b00:c5f3:4053:2918:d17c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b783454d65sm5807523f8f.1.2025.07.28.05.27.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jul 2025 05:27:30 -0700 (PDT)
Message-ID: <a06922c2-9dad-4449-991c-913fa7765bc2@redhat.com>
Date: Mon, 28 Jul 2025 14:27:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] Disable auto_movable_ratio for selfhosted memmap
From: David Hildenbrand <david@redhat.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>
References: <aIcxs2nk3RNWWbD6@localhost.localdomain>
 <aIc5XxgkbAwF6wqE@tiehlicka>
 <2f24e725-cddb-41c5-ba87-783930efb2aa@redhat.com>
 <aIc9DQ1PwsbiOQwc@tiehlicka>
 <79919ace-9cd2-4600-9615-6dc26ba19e19@redhat.com>
 <aIdqVNCY-XMNICng@tiehlicka>
 <1f8d924d-3554-43a6-a75e-66a08d1ce7b9@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <1f8d924d-3554-43a6-a75e-66a08d1ce7b9@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WP-tYitoyF0N6EIHM6I7tD1sT66K6wYf7BFlHHueZIs_1753705651
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 982F1C0008
X-Rspamd-Server: rspam06
X-Stat-Signature: iaz1nk4xywjama4zw46fzpxqotk6c87j
X-HE-Tag: 1753705655-390348
X-HE-Meta: U2FsdGVkX19Up3otqcCeKNb0/62fu1Bk7Pr/ijFk6CXLnobYedR8mO8xxM9C+coL8OcXkkvRGTsVvWzf7VBsofCaPtOh3aI/XwagHZcz1jlP3AKk8Ki3NztrYk5WC9KsBtKOJTRAxI/gldWYB3/IURIKU5ADuRRCH+14XqtAIFeCYPDCIrqP+ng2zyHsq/lH3kNImFgg+8goVqmBo/8mE+QATI7p8Uex33esTjjFb4bGcX5LxMMvI9+jHfj277buKk1A2NK0ze4SAGDHy9RKBA44k6R7vOxw2eGnlRFPSAqouO4ue6ixXF46SDlI2ZeBIa2+gKz1j/OGlcp/S2reifp4GaAAogFh0T6CXPLygM5Y3ujYbrRwwxU48zlTwCrNbVhdp7ZAGTfocd9W2aNmBYKeegp/IdX5EqXWVZA7SeqGTFlDKLRK9O5XA3vCY9tLNT5lOyELJ/WU70xx7tsBiElLcY4Q0ofAoZRBB627US8dX1TYRVs9PpdcH7ESNmZIOkYpYQ2GrYFtExRIQMNB35P13I2jJrv4ziCnXXNatO6eNsHlqmE/WtAa9G6mnnhvzdwBVKj9yZe6woK5DWcOxLRAMjwMtSBHYlJQ1sC/QzoOgCRL9/CwhwdaxlsQMob2GydObcr7ZrC01mH31QN5S9+oa0dnT9HrKqybmgi3l5Gap+0++xJ0czZ9o9Z2Wmuzlvrc6nGKN1J7WKbozbwFZYU2v1gD9jS5LLjzr8x11RNGZYg9FxTMN29q1e09+xHW0XFlP3WXm0G7ckG3lEWbJsowJMAXvcQq0uCTvo1dTY87IAvsvw92XlaTq/4vGYLuHx+luy5vWxHTm20MU9exJemm5YKx3NHrB6j4PGAvR+0wEJgSAlTiffSHsAduTNoHbY3rHqZlJb1tfwZdI8ykfh2dF8TGySYmDSjgGb+KwvhoGB7IYkU9C6ZEXHo+y59NY0Ue1rtnrubUWCwBUPt
 R1aR531Y
 usdWRUeRIFawD+lnQuiXwZgge1QvtUwGkZUU9DuVQyv209JVQFV0nX7Vjm0j5SU4gOhWwuGrLrHWUBk9Bt1csVTEjZ3wjaptq19kcbYHl0DR9Kz8jmdqp9uqN8loWuFSfST/2O7bGTqOHXBn9xjoNoBkzGBWE7XxQJJ3rQhieeR667mAIoPnBv+Y/IAulANDmQJeL7eZ0FTBaSeWc6pb9ZeUji7Q1WYFepGUoQod0PRy5CyOLLA2+VDEHj2KaljTnjzLOUNoAjxhthQG9Z5fb6zG0xsJn5i/JFExPXf7nngFEAIrsCsWM26GoXVnaYRL8vv19cxvcBTm18Z+YRBs2c7ea026q6q1Uvj1dBiEXDlSWcgJVWjQKWDrp74E6gK9qQ0tj8oUcGJ+pZOCJIR0wWCFefRWDDOb1Onwrv26Vd0hz8OlTE4JsAfoJQzZZTCW0heOrpyK+uPZivgVaCfz+xI0TyZCHeEM3CXebj41ZAI6v+7/s4/UsFfnavay9eFK8VHk4bP7vCpfChEQpJjH9ZmdP+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.07.25 14:27, David Hildenbrand wrote:
> On 28.07.25 14:17, Michal Hocko wrote:
>> On Mon 28-07-25 11:10:44, David Hildenbrand wrote:
>>> On 28.07.25 11:04, Michal Hocko wrote:
>>>> On Mon 28-07-25 10:53:08, David Hildenbrand wrote:
>> [...]
>>>>> daxctl wants to online memory itself. We want to keep that memory offline
>>>>> from a kernel perspective and let daxctl handle it in this case.
>>>>>
>>>>> We have that problem in RHEL where we currently require user space to
>>>>> disable udev rules so daxctl "can win".
>>>>
>>>> ... this is the result. Those shouldn't really race. If udev is suppose
>>>> to see the device then only in its entirity so regular memory block
>>>> based onlining rules shouldn't even see that memory. Or am I completely
>>>> missing the picture?
>>>
>>> We can't break user space, which relies on individual memory blocks.
>>
>> We do have userspace which onlines specific memory blocks and we cannot
>> break that. But do we have any userspace that wants to online CXL like
>> memory (or in general dax like memory) that would need to operate on
>> those memory blocks with that kind of granularity?
> 
> I'm afraid that ship has sailed.
> 
>>
>> In other words what would break if we didn't expose CXL memory through
>> memory blocks in sysfs?
> 
> I think the whole libdaxctl handling for onlining memory is based on that.
> 

Sorry, forgot to add a pointer:

https://github.com/pmem/ndctl/blob/main/daxctl/lib/libdaxctl.c

-- 
Cheers,

David / dhildenb


