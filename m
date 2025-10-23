Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 928D3CCD1BF
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 20:06:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC8B08E000C; Thu, 23 Oct 2025 16:06:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA0328E0002; Thu, 23 Oct 2025 16:06:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8EFD8E000C; Thu, 23 Oct 2025 16:06:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C6CE68E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:06:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7BD7688D27
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 20:06:24 +0000 (UTC)
X-FDA: 84030461088.06.060662C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id E86C4180004
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 20:06:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RZu4D8NA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761249982; a=rsa-sha256;
	cv=none;
	b=B3i0QY1A8gbidpjtTZ3zefbXH1A658369YdvtN+eekJMnO31lNHy99n6J2gR4T4K9qbEgB
	xxtzHxrFBwfa4LpENsUwthTQ5xQrghq8QN5XjOEAAr4X/1JH6Iz7353Hp2fSoqSxunz9aM
	fAXJUQkkM9Lshb6rZvSedqHngsgOc2U=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RZu4D8NA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761249982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fRPhH8Afjh5WRImY9rdVIeUYAC30QvosEDEcq3KVJj4=;
	b=gJTYarh/PWFj/jveEbgWcYocq4SoPfVtW+6gye0PvTq9Bf+69OPqbhAi5GLxOn0jaA/Rle
	rUqwfoUxCOHq+stnRDk+/wD5OPbT6yNpdVMcfgfHuRvx7UeJrjO5JOkk7Ux6qyvO2enquA
	kTn5FPyCk+aKiWlyqdzCevnaB0s47bk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761249981;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fRPhH8Afjh5WRImY9rdVIeUYAC30QvosEDEcq3KVJj4=;
	b=RZu4D8NARXj2u9zikFmFkoEjWp6ztsYsmnJrDj+HUFbpEq5021IgjozGLe6bDMSmmsXStc
	UOtH5lUhk24VVT59RQMtliI8hCNPiD3ZppHxyjPj+O2yBAeLMcJ+BRT9rohVo1dPajVOH2
	rxfWi3wF02Vbz1/WIqTvs7N3zjfmw4U=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-618-l8mRT4i8NsKtyXmnrerjzQ-1; Thu, 23 Oct 2025 16:06:19 -0400
X-MC-Unique: l8mRT4i8NsKtyXmnrerjzQ-1
X-Mimecast-MFC-AGG-ID: l8mRT4i8NsKtyXmnrerjzQ_1761249978
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-470fd49f185so11924805e9.2
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:06:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761249978; x=1761854778;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fRPhH8Afjh5WRImY9rdVIeUYAC30QvosEDEcq3KVJj4=;
        b=eGRZvXfTAUqwZLDcO7BuLj3lfDpGU5ZkDyEIuq2TS/LknQty/0M+Rh1A3Apup+888X
         69BZl5RiXjRNJ6Ll4EDaaF6OXxLeewhdzfPCxpTPd0OjIRcS46o1UB817UjpTaWYtTEY
         HZA5J+FCukn99UpIjf4KCbsoXDkhFooM+N2c97C8diex5PLV/5wFYXJqiKpyzoo9+XTj
         DB6qIRo/6P4liYqu85v73f/3gZNR/BznDP6vZcwDEF5Aa4JgPwsdFWOHafv6bbWALwzX
         R+kAMwTqNVuzcQX6IvTT6+JTaKjeGNKF3yTZE4VGKNPplhrDUDRtE2YxoJE2p0bf0SG4
         U+Yw==
X-Forwarded-Encrypted: i=1; AJvYcCV5HqnITKdsDvx8T1PmMo5E0neArEoyRjkDRs0+RpqZQ1ovk/NeS1Xf/jlWlq590qDnXwz3ho64eA==@kvack.org
X-Gm-Message-State: AOJu0YwkrFw8GugSGo0k3g8ic8nIhOlsZrv1msA6TZOTV136C5g9F568
	a0K/7DBOx2AbYYV+eya4/9V4m7lCushUnUW8+AFEsCX4xhboCriF14FU5szGSxHWCmDyTdCYtgt
	WsyalprIuCWcVJXeTfhSr9q0i1W5daE83mXBwhFzxASBSDhq9BXoEEdhNX+3J
X-Gm-Gg: ASbGncvQ17ngP6UEMqeLPpNna4Ty3yXqObTa/UonCuZaMElJlZKYE75EhE0AM4rRKWr
	m0nejIuAVDJ2xH9gXYDlJ36IkRJ9kS+WjG0W57XA0YmBWoj8rTvS0rBAT3KazD649g4OxmwaFBY
	FwhbDnDdDawKTrFGq7BeJ54D/KFfLGgD2LMvNPsmpBg2ijeJoA0i5tYFG0ZpaAM5nHEm83oB0ba
	Lg7OfkZDU2H3H7YCXipumTbI7V8FtDCv7dWtjQOWHlQl7IjUcHZH69A7bIreqN7lXsXJD2bshpw
	qk/Eo+NJ2cBrdorq6VMaDi1eRbw1I19SGxZbr/9GLeu/yGvGWvl1+HqDcsRvVOdSVDnn8oigyKS
	mAc9MSkWoybkkHdpASruDIWpyGpmOyclnEzs47hf9bMgjVDZyW8C0ze6LT/27aNH8uaTmL/YZYk
	4jU1XXiIbRF7gUlfy/SK7gqqPrcDY=
X-Received: by 2002:a05:600c:3494:b0:46e:4744:add7 with SMTP id 5b1f17b1804b1-47117870715mr207116415e9.7.1761249977736;
        Thu, 23 Oct 2025 13:06:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGGeb2fa1IYwsGJ0pSctmwGPF6xvoGIek/oRMhJoppZNw0DpnIDJSoz1KA7a/k0YpqsgRr1qQ==
X-Received: by 2002:a05:600c:3494:b0:46e:4744:add7 with SMTP id 5b1f17b1804b1-47117870715mr207115995e9.7.1761249977327;
        Thu, 23 Oct 2025 13:06:17 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c4342946sm113034495e9.10.2025.10.23.13.06.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 13:06:16 -0700 (PDT)
Message-ID: <f0067f35-1048-4788-8401-f71d297f56f3@redhat.com>
Date: Thu, 23 Oct 2025 22:06:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/13] x86/xen: use lazy_mmu_state when
 context-switching
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
 <20251015082727.2395128-12-kevin.brodsky@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251015082727.2395128-12-kevin.brodsky@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: I5yBmVJBRIO3OIlzMYvJJoWHFPoJP0FscrEEo7BTcAw_1761249978
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E86C4180004
X-Stat-Signature: kti3aen1myyrqkgn3ixi41pwn4zwqdwc
X-HE-Tag: 1761249981-496074
X-HE-Meta: U2FsdGVkX1+NATStoPxez0Xn7rCfjlnpG7N0iCvkQpb5RyKHcIIgYNfjYJmM60zb72NJk34KPX4XMhR7dabpKdKG+npcfrjNZ9LFp2cHdEgz1BkbMYM1vDbYJ5ci0CAguOOOnHj8BnnrY3P0+Vyjjhalt2zethFn/6dxQCjp1M1Bj7V0e73Ltwd+1UDPyCAQ18oVw2DjEetkcee7qomY1LeE0wWUlzTU98HHxEV+an1upnWRil8uQGoTP+GQossDuNRPteDO7M6gagZGTgJVuZ/CwNMuQJBZgQZdqZOC3/yP4BN2UqfYEIMlhQ0EGNZYh+d5SVNelQp+/EEZWGMxb7+Tqq2UT04dI7STTM+dP4DmzY9qPgM2obDRbddIHC8XH24UkLQBxQLdk5qpB7t4c3nu2szicxnpX7b3iHj2xyKDCw/iiurl0oKd7UHCTS29IMsOQsTvTJRwFk8OUwYlhYMlJwM2XcTBwhqWwsNX1kl54xlKKlTcNvZj6A4KmNmXIw3bRxipVhRb4hh6OGuWsejgpQFDTFFufHmi9JCqeMwLCSLGau3/JXPkgfI9CAcIdqvytJS2pg3tKgPGvtlu5PzPOBnj9+dYOtyB2jJbFQswUAh3mRMMUpeQ7mMLEak4LxukGZpGogl8qNiMM3KCiayfaM9BLsj7rxGQErZO5R35PC3aBaEztkMTMMmKQ0zNajVh+z7XSSdEwqkZq/C7LtHtFexhQcHQAxxIk7IYsUcfv1B5nv4258vODGadOBNunpR8U2Hp7qt5EzNCF+o6vEFWFO8jmad/ZFkCAS9F8wLBFj4voDPllyykspHHk6DHO7jXrmo5eEuBmAV/4OZqlz1LHBtjS+MmmDQHex9Mf/KY0XMuTc5h8GB7PMQfIHatHE4S4BnjYnwEPCSQi/3I6DTksTK/J+7wBuce4LiJfAMLtV8r8/lL2+1IF5cLFcsn7JgRjtJ0rR1sNOn7yuE
 +4eIjGE9
 6DFWMKrZ/mfijrwXH8GVrmsemPH6ZER63Gzzj24T5PX2NZWfz7qMUbn7ehDtK3IbthYuDzt+ui3EjMIuyvlmbb1zjzxTv+Tc7NOHFZtrcT08HXuBf1JuTDl4Yi1mgZ9MAqagpqWhuyyez3cyex+liIFpL4867cHE3cCeuUrCxMC+8CTjcRdoUgki9lNJmvdJh4rUXVh+Z+zIP0bKYsEvXIIjmx7aZqNE/lsZ+RA4Xqs3FCdH+1s6L8QYOohLvlCTkesY4UnpmA1xVWpNvEjy+xULCviAI2SwHGoUfrDoTJwNgR+r4TqU/DMdmoOr23e4qeOCP12xthL45z5Qocv5HQB/lKrqCmsm0mOV6LEfb9UOw9SO5ZU6T/Jvc0ZnfjsxpEpGF6v/kW1ncHOwDHTD6tr9fvQyLu2BjZnbmSPw5xvYq8zX4zxblbFMfkZFmVs98JTegxmOSUYaBdVhGjPz8foOb5BjdiaFAQEB7333QDtcZ/pxloOyofaWeK/GSAg4P12QlUxT9rBtee7eYtXo15MvF5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.10.25 10:27, Kevin Brodsky wrote:
> We currently set a TIF flag when scheduling out a task that is in
> lazy MMU mode, in order to restore it when the task is scheduled
> again.
> 
> The generic lazy_mmu layer now tracks whether a task is in lazy MMU
> mode in task_struct::lazy_mmu_state. We can therefore check that
> state when switching to the new task, instead of using a separate
> TIF flag.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---


Looks ok to me, but I hope we get some confirmation from x86 / xen folks.

-- 
Cheers

David / dhildenb


