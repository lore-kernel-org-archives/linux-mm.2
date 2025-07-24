Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C449C87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 22:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A329B6B0343; Thu, 24 Jul 2025 18:13:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E3486B0344; Thu, 24 Jul 2025 18:13:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AA986B0345; Thu, 24 Jul 2025 18:13:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 739A16B0343
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:13:03 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BB15B59739
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 22:13:02 +0000 (UTC)
X-FDA: 83700559404.07.5AA7CAF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4204780002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 22:13:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TU0y+bez;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753395180; a=rsa-sha256;
	cv=none;
	b=qKPBWUDEUCtqxT5eeSZjqdriTDn1AwJSE3WWE37/v7Mv99Gbl6uNwzJBGhHgT+bMyTnnGe
	SoNoBHaImYCIUkWf2gSTRLapQfAC2LA1YDFXnZvfP6PGZezZpYlanK3/lzg85gmhOhnEfi
	aGa90GSUm90MjjQKUQYEhF70rQPHcH4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TU0y+bez;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753395180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hQB1z3Z5kcaFoXcohwY1QQ7EgSZFnKqwqqs0iiIrZ/g=;
	b=XmP7zDeM/RsO3jRHQrdSZkVYQ4OI48aav10wXM1zjoBvRIkLrG4K7k5Sk1HmoBJcDGT5E+
	JJk3A8C2r3Jg9VmfzkM67wOXCbqfVV96SD5OhHGwK0rg4ifu9AEE39iwGBQjYTBhFWATBz
	OoZ41YYQIUlfJmlJOQ+3G/0DHfGHv/E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753395179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hQB1z3Z5kcaFoXcohwY1QQ7EgSZFnKqwqqs0iiIrZ/g=;
	b=TU0y+bezeDwejqPkmsFYY170iKdo3sEqikbms+G2PJXl5iynArYOjRYxTdtEKmJ7lorqhp
	+NJH4bw/BvAzJ/r3eQU94bM6RaIaoKuicBTWJdV4OiCiLFkdx0SnB1Aq9nkWIUVAUjFr5M
	t7vIyj07iM8tjgkqmBAuLfu5aDgjmRs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-HUQhKvx7PnGimlKbnspSTA-1; Thu, 24 Jul 2025 18:12:58 -0400
X-MC-Unique: HUQhKvx7PnGimlKbnspSTA-1
X-Mimecast-MFC-AGG-ID: HUQhKvx7PnGimlKbnspSTA_1753395177
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-455f79a2a16so11221295e9.2
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 15:12:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753395177; x=1753999977;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hQB1z3Z5kcaFoXcohwY1QQ7EgSZFnKqwqqs0iiIrZ/g=;
        b=laNSf0r7mbOYDSrMDDp3HQqWJpBT+Kl5zT3cFj77zKx3AKimojqzzswNah8gVu+k2z
         K3Y5HPc3FQwuiMbI+j50+SpGMYDHCfqrxZ4cXaFcc2iuAw8E4IAm2kQIQ3mU9Cu9gNSg
         ndws+umqbOGIn19ASF4dfvnyNkRLWx2dXL3d+374QQmFRaPN92fR6ywXAfoaZvdQsuX1
         FqNikYCE+ogSwlM/ho+HG7wIveERXswxB0SKLpyloG9voZYOQnXR8fj8lSBsURynBblb
         5k0i5cViPYDnVrO43UAeNNJMQdSjRnldXI6u5AsVjoNrBENIdI7SEdyQkxhz9euPlK1h
         H/IA==
X-Forwarded-Encrypted: i=1; AJvYcCVXnSzOkMHn/PEpqs4/0s++3PKB/W4jYKQL9qN3SE8IDDmrMpIuikkd4xi33YZYIbzZLsqV/XeoiA==@kvack.org
X-Gm-Message-State: AOJu0YyMDg3sFrzCBlfnrvPmtdgWJDzHTIzKYTCboW/YtRsGPEqgkVfA
	WlF8iMg9PIStFmkY14b7l20dYhL5HFXxOcdUvc2/xGqKO66oL99/wLCblASfh2jbz14EHrdjoIi
	BIvEw04e66/hmCECd3bKRF7+qlk3l3YcVfnLHrS7mPYCOmb6lMljL
X-Gm-Gg: ASbGncsgMX+19k7TFiPL6QfrpiDxbcBpB+EcG6PJdu2Y7CPkyL0JaFgKPs+mFmJhvgO
	aKJ+XoRcGdfC+nGC1n/EHlGSFv/yTDifHsUBMAFXdHXqIHy+vQXfDqu1drud2NvG7VCGBSIuuwx
	CJ55i8ZCNVTC7PP0l2TsHosTSUdj40acM8tuOceYbKCF16hODjgiJfslt28nNcjiUCnl7aPWeMK
	pFFVsbolQyZimwX0ZNra162XUN0A3R4kpXaoXlmVnHKXdY1tlepjxhZ4uQ091hVBSudhAcUzvVC
	Z5zXsDmoT26Oh+/yBOuxWxjxVa58zBgmYEYj/nCLfoLxO08X/nBl6BtKc8cl3O+OsOqB7lNh44R
	uXqjoDn7avKZ2nVR2f3+LApua9Q95SjrCBpMQkLiojUGY+29vxmIpEpvGXR/y8Pp5N74=
X-Received: by 2002:a05:600c:c1d7:10b0:453:8bc7:5cbb with SMTP id 5b1f17b1804b1-45869ea2734mr42647255e9.25.1753395177215;
        Thu, 24 Jul 2025 15:12:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEROFhkwgqCWtdtoJL6+oZxLZCC7+h69SF6EW0ZZkD/1W4EzDWnn/aPK3tJVe82t2BNZ84VXg==
X-Received: by 2002:a05:600c:c1d7:10b0:453:8bc7:5cbb with SMTP id 5b1f17b1804b1-45869ea2734mr42647125e9.25.1753395176734;
        Thu, 24 Jul 2025 15:12:56 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f01:5500:ba83:3fd7:6836:62f6? (p200300d82f015500ba833fd7683662f6.dip0.t-ipconnect.de. [2003:d8:2f01:5500:ba83:3fd7:6836:62f6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705378ffsm32532115e9.1.2025.07.24.15.12.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 15:12:55 -0700 (PDT)
Message-ID: <4f66d89a-631a-43eb-b4f9-c9a0b44caaae@redhat.com>
Date: Fri, 25 Jul 2025 00:12:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] mm/mseal: update madvise() logic
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jeff Xu <jeffxu@chromium.org>
References: <cover.1752687069.git.lorenzo.stoakes@oracle.com>
 <ec480dc1fd4ce04bb11c0acac6c6da78dc6f4156.1752687069.git.lorenzo.stoakes@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <ec480dc1fd4ce04bb11c0acac6c6da78dc6f4156.1752687069.git.lorenzo.stoakes@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nFKskvGt3wEPC53soE-igGny56m7aYTG9g8AcD-VEqs_1753395177
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4204780002
X-Stat-Signature: rqpnhf4w9pjsmtt3q3xpcqmagbfrrzsz
X-HE-Tag: 1753395180-393921
X-HE-Meta: U2FsdGVkX1846b4PTMIv2dBFnk59rcQeRef3pjlYqEWjRu9oOo9zdhg1hTjCVEzvlB2QpQZ5x7R5kErHqq8ChzcmnAY7kPYde4/10s118fobC3Fe1ygRfKF3WQXSTn+4+h1ZeRDaGKjApnbuBRgH3MuivnNj2GNTlr+nBgrCoKXfxVOt8pFsIun0lymuJi1XWLnQs+vmq7bsv3sFRPGmbapEaLXucOB5o+D5MDeezRIgsniNuGvW2O9kFtVWl/iZHCB++XoohDhNBZs/AuPBkZI3vKtUzkrgk2rTKrqG9Lpyf0K4G+73yOPTQpMY6yhss4TPkxZorIRn1jYRrabLS01rETUQdpC9V9psttb3pgmivutrNKHfFFj9A96CZo4/5YoBJG7sNnVB+WowOue1x3PlKWH+yWbtEiaihpuylb1iQ3EXifFelrZx6x+jAq5Ou+5PUk9S6Rl0VO6gEWyt3xfoXIpQQ0ubbPu9jWDzF+CnnHDm4emwt9sEqUCKf1kaS3q/QoYZNEILJeyFmdSvKaMiKd5/K4xKYpwZCZxDcnPm19IMzWa/ZvXqT98MRuGUskU5ixjdCelfQDsHO5TpUx9bls2oyaPiCZ90sTQUdEvRMsUW9n9NXFlszwOJHLGZ3mGjGxPmkafowT3HHZOrstDcYZg0byYZcdY6gMmlULaj8KnQW1nVq41AIixYw2XofXRoa/8Gh+9Lw9g4+LDkZqGevTFvAYtaSYQVuvB63Sx1FmhXWrJbk6vhH9jo3h6wMxaH5CYdAUsWCNVk2S4KEJ8RgBG2MSqGhhqeHxxNATJU7jm2zY+FdTg/wN4/nZlTx13xXTPynU8Qt57B7soYdJ5dnLGyz6e51wKht7klOwBUhEpPGOfkqC+AaT2H1Ba8/y6MaEtuZ0GRKF/fwBKVD8sjUSp1HojazeYZFwIs9WWwFHJ1eEI3dVF973wDpYW9/wl+h4u91YMfLfD4r1S
 fTsq+MjI
 6xhiBccNIPDgWQvsjUHDHgogzw65Vsdy+cLX3W3DyCMwOJHzvEIZpUFW5QXr4MIFFO9UZfZAhYXr6CFT+TU3L+HoYMLcc2YZl7X3Vy+gcRxf6PQ3I7wQ35pSdmdM/EGMC6TQbhUxqjiQJm/3dfT57ts9R8rOiVstJyKu9f6xboBBtoLNn4ZV85t1H5/zJMp8rzgKf+gG6+C61Tr1bT7T/JkNQ+iyqzDDk4y2vMo9AT4LEZ91SJ687USgyDhV/FGemgWUZ073UU3GuKg/5MFOobI5dYNMdu3HiyqS527UtZdWVrxL7qg+IKpHTTp5j0u/K8tjS9LeyksoJiRGzGvhz16naQWRHSGBFEWPiY++RQbdmEkbbuvxmt54aH9CuhCSPsnZi6nS6AkQudDrRtN3Jeo9Yx09QQsP56JsbGKATk0DwmNDdmOCihR+xRRyQ9kGaneLD2vVHPg/IdrJMu7MGy6Z2SQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.07.25 19:38, Lorenzo Stoakes wrote:
> The madvise() logic is inexplicably performed in mm/mseal.c - this ought
> to be located in mm/madvise.c.
> 
> Additionally can_modify_vma_madv() is inconsistently named and, in
> combination with is_ro_anon(), is very confusing logic.
> 
> Put a static function in mm/madvise.c instead - can_madvise_modify() -
> that spells out exactly what's happening.  Also explicitly check for an
> anon VMA.
> 
> Also add commentary to explain what's going on.
> 
> Essentially - we disallow discarding of data in mseal()'d mappings in
> instances where the user couldn't otherwise write to that data.
> 
> Shared mappings are always backed, so no discard will actually truly
> discard the data.  Read-only anonymous and MAP_PRIVATE file-backed
> mappings are the ones we are interested in.
> 
> We make a change to the logic here to correct a mistake - we must disallow
> discard of read-only MAP_PRIVATE file-backed mappings, which previously we
> were not.
> 
> The justification for this change is to account for the case where:
> 
> 1. A MAP_PRIVATE R/W file-backed mapping is established.
> 2. The mapping is written to, which backs it with anonymous memory.
> 3. The mapping is mprotect()'d read-only.
> 4. The mapping is mseal()'d.

Thinking about this a bit (should have realized this implication 
earlier) ... assuming we have:

1. A MAP_PRIVATE R/O file-backed mapping.
2. The mapping is mseal()'d.

We only really have anon folios in there with things like (a) uprobe (b) 
debugger access (c) similarly weird FOLL_FORCE stuff.

Now, most executables/libraries are mapped that way. If someone would 
rely on MADV_DONTNEED to zap pages in there (to free up memory), that 
would get rejected.

Does something like that rely on MADV_DONTNEED working? Good question.

Checking for anon_vma in addition, ad mentioned in the other thread, 
would be a "cheap" check to rule out that there are currently anon vmas 
in there.

Well, not 100% reliable, because MADV_DONTNEED can race with page faults ...

-- 
Cheers,

David / dhildenb


