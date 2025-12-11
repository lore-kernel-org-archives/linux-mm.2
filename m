Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43327D3E784
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 00:33:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 856476B0006; Wed, 10 Dec 2025 19:33:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 807B06B0007; Wed, 10 Dec 2025 19:33:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F63D6B0008; Wed, 10 Dec 2025 19:33:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5E21D6B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 19:33:50 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DE746135000
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 00:33:49 +0000 (UTC)
X-FDA: 84205317378.29.1B6B7D6
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id E5CB0C000B
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 00:33:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=Hhcu72m6;
	spf=pass (imf28.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765413228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3QrmlcsyPJfUCC0ZcW/aA6sfMqx5l+Z163FBQ6ysu4g=;
	b=40kGYdrCm3153nBN814Yzz7hkZIKiwB2aeeAw8plRjGTslpXvG1Kz26Qyi+lOhKS9zYnAy
	5PBi7gkYKgwj/3ecfibp+TjrQGs9ERZ/08cKXmNoYUIBlIAAS7TKmvF9u4dnkgLcClFirY
	3anLd2fxjT3qvP2P7+VWlPxBrlX8aIw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=Hhcu72m6;
	spf=pass (imf28.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765413228; a=rsa-sha256;
	cv=none;
	b=wH2/hlg7p6w97WP4Oq94baEJTLDqKI5ywRNXrTvuq4PcqJY+oH36uLgSt9hhkVUh54nr2v
	w1/gtZRPanfPWdtdYZCnTjsZm/6aG6ITOnT/IphL85mEhsgvL+SDqCR+On+XebVug2nlzQ
	9xhqZwZgSyITmXpAi8VLTl5qpf0LqYE=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7ade456b6abso303884b3a.3
        for <linux-mm@kvack.org>; Wed, 10 Dec 2025 16:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1765413227; x=1766018027; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3QrmlcsyPJfUCC0ZcW/aA6sfMqx5l+Z163FBQ6ysu4g=;
        b=Hhcu72m6TvYvCgCalPvVw31mAxg3PBYRyx5mRlVe5ANchGAai+6o8zMcJygbAtjpWs
         fDVPpBwCP9keZEKoxH+Xl74IXySvH2JwAGPdrVEQKFMNW9n7KOdh2e5bOEit1J+Nk87A
         Vt8TabMNdb+rVHxx5/IdiavqqUDhuBzbylR08+/TDOw3ORXoKSYAgS9WtfurFlUwEHcd
         MUS/UU+OuyjYETWTYahpCmdCczOR5bSF8Ffyxjfm/CIqNgI2Q/UINZ1anvtyjoPhozGq
         PIzFfFjywXZnlnHJbGVpv1vO9/4fwnr3xGsWHMAotuED0oTYZUIPLX1Bj1bSQZGHqrHE
         rnPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765413227; x=1766018027;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3QrmlcsyPJfUCC0ZcW/aA6sfMqx5l+Z163FBQ6ysu4g=;
        b=XWqruj0kATRR3GqIxXArAl4fIWn/Ti2KjAlv5b1kSeQelSG3HcCNvBhq0NXP/hcEaQ
         hO7RaKSMXp0VhlCD1N4X+fJZvYmxNa5dpLPFcZMEXkYGEQqJUuzbsg3OvgYjfzvFz8YG
         cRCI+jOr9/kVzY8xfORC4/5iiGMeXU9HMbG3DJzwLz7Ku/diXwy8lobIV03gMRZ4PO8m
         OoTw85FtKsNuYNZfB9ezJCzPtDAmji5hm3shTEb+9zdEoKa3kDPjvkLdZqqFW+81Zy0h
         WY/dJgPokO6Bfz1MgDkzRQkldk/np7/sGysn5EwoHOhofnQbSs/GTeLpB8y30d6QDjR1
         G3Mg==
X-Forwarded-Encrypted: i=1; AJvYcCVT7P0LHd2hXCOGab55YI6bWz7wXUViILg+dpcb3wfoFhCAj/k0lhMU00JS3k2PqHwOsCDIodwpXg==@kvack.org
X-Gm-Message-State: AOJu0YxPGmCJiWUk7xA+F9eM1mJOC2YCTE1hitkWNHtU6pmXAZ5IuBv8
	2x/ddR4lmdRx55h8eUN+U4C9W39A6gRTzub06VOPhN77wut+FykSgAi+/f0VBWAkOIc=
X-Gm-Gg: ASbGncuunJaOjXRpSK7LqrCmP7jdu01Y7pLzsyH9kcnoOm45c+rzCxfdvW6uEht1z2Y
	+Zl7fj7mg9u8aFkPdsJjyaXu0c0qB6OpgC5iuH3BLoTsU3RK54xgMxjy8RBzWG//pYesBC4po1Q
	7pb/YL2WAbosrH8/fMbvBmduIYgKs4X1r94JH5tFqJA7LsTpOA+GddwoLY9xfxGxTlhkv6Pmkl/
	cSUNzudZdEFJTVAa6uDouhW7szRj+BtAiVhEbitGoIO4l3TVCh91Cpf51aK+DNtZmFctwfWl655
	mn4BmYKOL0LWYd388ju2vqGet2d19qhbKMa41yQ7RXO40QGnOfgqYDtr5fUhRwkU/VYHgyeZ1tt
	tWA1r9tHHkHgUCn73C3ZkyO4WzDh89D5apfj4+l8o5JSm/jRz30fNJCJf75bHUMArc9q1AYMjLU
	dbTPFck0OXHxVjbQ==
X-Google-Smtp-Source: AGHT+IGjk/exFuz2Gv/i6l6p36w76njH4yBjUre8KbL1otNzyBmhPQsg1E1fJ2rghGyT0+Ekep5ekQ==
X-Received: by 2002:a05:6a20:a10a:b0:366:14b0:4b0e with SMTP id adf61e73a8af0-366e3acee69mr4438378637.74.1765413226713;
        Wed, 10 Dec 2025 16:33:46 -0800 (PST)
Received: from [100.64.0.1] ([167.103.29.104])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c0c25b7d59dsm580312a12.6.2025.12.10.16.33.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Dec 2025 16:33:46 -0800 (PST)
Message-ID: <af8fd275-a34d-4b2f-8834-9c85dab2bbae@sifive.com>
Date: Thu, 11 Dec 2025 09:33:41 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/22] mm: Allow page table accessors to be
 non-idempotent
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <pjw@kernel.org>, linux-riscv@lists.infradead.org,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: devicetree@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
 linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Conor Dooley <conor@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
 Emil Renner Berthing <kernel@esmil.dk>, Rob Herring <robh+dt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
 <20251113014656.2605447-9-samuel.holland@sifive.com>
 <fbfef7fc-4030-462b-b514-498eea6620aa@arm.com>
 <c2597d43-d909-4259-bb5b-9294e4069385@kernel.org>
From: Samuel Holland <samuel.holland@sifive.com>
Content-Language: en-US
In-Reply-To: <c2597d43-d909-4259-bb5b-9294e4069385@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4zrb6irz5qy5jrd4ypw8txbkzz9g4sqj
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E5CB0C000B
X-HE-Tag: 1765413227-680616
X-HE-Meta: U2FsdGVkX1/8sYe0Dp0evoI+TMWuZU4zIQixgi0XaIMvQgDZwgDA+PCdl8yHasvdsC9MTKy5vuNwOpQmZfqKbzFVZjPfY64uAe0o2BWZftNVybSNKCfCXQ1EnWMsdwNrlcQV8d/JJ6PAXv6dIglEfyRXMsczTcBtLGKtlF8BW+RdI3KbL7PrMuQrIGQDxz8rCx/4qgKyglKfqJrjCgY9uwHVasaBIzZrvR2D7xnaKmyqRFskJ38/YnxJReH3YOaRkvy1gqsVKHp27gGfDXBbwWMRXlosVkDkk/Eop+mG3xmp/q6YxIklQO2SAmK2Ln1wNmVUQJPLrz4aF6hm3aD5ITveltHXXrFnZuebUR+fhZqq8rL853MUrv+ijHbyzMP9opE90VsMtgGR2ZnINrJS2AL3qA0mFegsdHWn7C1EBAdHFn9PTUN5M4Us5yfriqPg0QWr5+fohb9HIOESTFpU8JYZAx9Z6c7IVEHwhwBrke3q35B27Z2fk2UFUn/ZLgK0pmOoVCzkGsUGW0XiJ30n3xPgngsw13q3+PXe3Fw9tvZujzsUDWTISjlBRbdxvYJkJY2l/YEnjyaopq+HHf0sqlZLolP9AXZ1nXJ1GwPlG2HGvvNC5BbYNvOCKlX7F0aHzOKDzoe9R95TCm/T3GHzrdXqF3SSRkPSG1F6St4OcXaZDH96U3mO3HfAwR0/bFivNpiAdpI4OpmGWdnUvveoGXWfR+cmCA3gVLavxJEKiFO0HFrGG8M5Kn3orsakEmB9DnAr5n8Orl+mraNs7+DIsANNfwZRoXTY32G6gqfdFGaoRa0FA3F3UpkLIBgeZnYC2Fo9RsZ3BIQG5tUHhpCtd6ZApbUrTTn3wjHjoz9G63GBzlw5ka51ZVlW/lStdn8IjRcXNNpt8l1k45r4oue+jD7e5SsghubG+0jQg2TgLscP7Ss+1mnYyhSP0zIqcXHv1ajJF3d65QYFVeEbRA+
 006U7Vt/
 HlaITsd8ZMzwuAJe71+2GBjGiHaclWyPtjIrr5MOPiVnwY7LS/fbeikI7lAe3oK3vCV7XoCDgKzZqw8cPuXILbplZCfLgOPqTtRjcetnnuXJD7jtYIOGpXR1JAUeOkKq+35wlg34wKxBp6oaQPn46DKqw/z2UYL0UFtWtxKmSLVaMrfR01YEjy96kM2UtmsVP7MOpbxnoSGq4uc/z3FNlqGvRuAH67jqB3V7VKfRNoMZQVniOnEWapmiFcqD7ZkSTGtNxS5wSg/J/Zs/r/sGkYtT3btFV5KZc/Hv9ccUwpBhJFOWT6YygrTnXM3Ko2+nvFJDZmPf1VtqCqvyB+3kfu+n1vzFj26sW9OnPoGMsf7CjGF9+C9sn664ElhLa8ThTNAfeR3HJLO/qIFhyalzaw/fVwxfZaIODcudB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-28 2:47 AM, David Hildenbrand (Red Hat) wrote:
> On 11/27/25 17:57, Ryan Roberts wrote:
>> On 13/11/2025 01:45, Samuel Holland wrote:
>>> Currently, some functions such as pte_offset_map() are passed both
>>> pointers to hardware page tables, and pointers to previously-read PMD
>>> entries on the stack. To ensure correctness in the first case, these
>>> functions must use the page table accessor function (pmdp_get()) to
>>> dereference the supplied pointer. However, this means pmdp_get() is
>>> called twice in the second case. This double call must be avoided if
>>> pmdp_get() applies some non-idempotent transformation to the value.
>>>
>>> Avoid the double transformation by calling set_pmd() on the stack
>>> variables where necessary to keep set_pmd()/pmdp_get() calls balanced.
>>
>> I don't think this is a good solution.
> 
> Agreed,
> 
>     set_pmd(&pmd, pmd);
> 
> is rather horrible.
I agree that this patch is ugly. The only way I see to avoid code like this is
to refactor (or duplicate) the functions so no function takes pointers to both
hardware page tables and on-stack page table entries. Is that sort of
refactoring the right direction to go for v4?

Regards,
Samuel


