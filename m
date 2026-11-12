Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ADF8606A330
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 17:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=Zhd0d2MG
Received: by kanga.kvack.org (Postfix)
	id BCEDC6B00EF; Thu, 12 Nov 2026 12:48:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B59296B05B0; Thu, 12 Nov 2026 12:48:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A47686B05B1; Thu, 12 Nov 2026 12:48:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 851306B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:48:13 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 25C37405FD
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:48:13 +0000 (UTC)
X-FDA: 85427200866.29.23135C5
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id ED408A0008
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:48:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=Zhd0d2MG;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf25.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.44 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794505691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nLM7EJdjaO037/pI6q4xA/LTKNh0utgwqJExJ58n90k=;
	b=2VbiSQKlVa2ALPf2K/MXA/yq4QiellA5QHeABoS6lPex6TSb1M0toXbKoETQ3zSDytJ0vk
	7DGtPQbyLMH510TB8BRlxI66P27qc6dA3SWzF+LIY8zpFO65aCnEQoZtwV/TYza/rMy6v6
	JDGR8JmrXAlq8CSHvrG7W6hUdpbhPIE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=Zhd0d2MG;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf25.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.44 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794505691;
	b=dZfd2+9NB1CNUbl3rl/ZXHoOwAEfE4i2iDaUmQojvujkLn4qbGMbVIF9L0GeegaCYJmGjt
	lZAC3GUSBBGhfHGfYmFLwPRoOQWqgWTryS0Wd/whBTfBDFjfCC8MZH1JKkVb+MLBbEZogh
	KrAM2vAzfDrMluB5CpVUWZ/caZW8P00=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c506a231b88so272609766b.3
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:48:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1794505689; x=1795110489; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nLM7EJdjaO037/pI6q4xA/LTKNh0utgwqJExJ58n90k=;
        b=Zhd0d2MG6CHcUxGmAfq5COSTIYiSQhAxAarIVtdQvQex6kETlqIklliQjZ7DWtrxxT
         MN3d/zj8DllfxBa2tVR8DPVA6Q92ZcDx4n2j1Hh8XMjEB43jYSsz52cDFeEASvEXIdwK
         lCrowgzICZJeSMYqmEaWz79+tJmJgsRq0xGHA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794505689; x=1795110489;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=nLM7EJdjaO037/pI6q4xA/LTKNh0utgwqJExJ58n90k=;
        b=FFfvj9di/EJ2tZW3dpqT1ILULYWJ1xdUBunv1O23Ut5mcKqU+comHuUv0Q+lL+Q2wp
         COxkaI4hFUUsDQkRQd5YsSiw0cjoUBW3Z8dribCMNmwdOixZx9bOudbyXhsYvktVNcgF
         A1pjdN+I5AuUbuMEvyJ7jtOdyH7DJkbGGDzISW0V/8x8/tZZ86zFyynd6ADDbB7uxzoD
         DM0vTSGq6pQlj+Seet2Ko+fzq5dF3J/UU2OEVw+K8mhy1E5Q0B6FaaFnznYzYR7HSalY
         pf/0B1vLEMzo43KWL+Q+Of343fd/tkE0+NLhxSx0KmSvouqUUy0cJ2NypXHh/s9tszh9
         5KDg==
X-Forwarded-Encrypted: i=1; AL+hErG3WrGP74tcTibni3eFNkT6mnJ+ZN7HdtuWEDNu8VtDD/oclQ7TVsi97T/E8bORwBsanBcXDEg1MQ==@kvack.org
X-Gm-Message-State: APuU4Z++xmt40IFsGBqaC/Hnl0JXQnr5aJ5dNo+Ig7f17v51H2GEHBi8
	VE3L9q4KyLMAzVbtNHS74dhHkUs9y+4gFi8M7KYlFtcta5U9MIj1L6QyA80uUgf/v1lgDItn8m6
	An2nUY/xl8Q==
X-Gm-Gg: AYBFou1MWgVStoYir2Ko8W2juL2U3vKHspe2QL4oKRrLQgbXKBAnxTLKlpe/gpBBbF5
	Tezj0ZOCglYv4LVryhUM7aKpDHh0hIjRZb8apckYYPZvWSORYk46Yjt3MCra98kK0o9INo9B/1S
	C/ikflPaWqztOeZVtBYahilWcWObj+BVPxljQjEpa2A4xuu7TgP9mI8J3JNnY0K1iQ63dgF/zcr
	Fr3sTXD3K7mFfCbXvd+/XiEo4aDXocxrp4VRiiMM/H62Lpq+5lycTeQUxRkcsaxFeSQO4azfsbP
	xck3KPALrZAOX7t+bDOMaBLByqnTaZOVa7t47ybxJGlujzw/VDxhKsQs1X//NShGL2qXAYmFY2q
	wtN+fbBF6lbuy5SXjCESIwF2jh9QszGLEFTNsBySvwojzhsmz9D38itplxHrkdy9PW+zczvz21w
	29tV5oZOweewnaNWM31tA9rVxlaNAitYQ96rrgWkejIjGZ3Y4lig8aBkaTZpzrtF2FSnsBmPv1W
	WgVP4/WGf+oaHQFqy0a+RCBt74/W3mG+GdRhs0eoIYAx7wNDHvbOf73+Kk6BvG+J5STZRTg7DMM
	YJeJcR73I4fviN5eIKJ3PQIlxVMjsxndiZPiIHK0JfYyJAvmHV6Py+Wiy+n1JGRm0iyqNQALG7Y
	xyA==
X-Received: by 2002:a17:907:9815:b0:c46:9876:e9b1 with SMTP id a640c23a62f3a-c5066d748d1mr726602266b.43.1794505689434;
        Thu, 12 Nov 2026 09:48:09 -0800 (PST)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com. [209.85.218.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b9736bsm2145966b.87.2026.11.12.09.48.08
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 09:48:09 -0800 (PST)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c5067a2411bso327962666b.2
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:48:08 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEZ+1EllC0AnciZ8MLqfYGgLOv0dfzsLBfPUJ8ijjyJyhFB+lQdFNqhW6zqyrLoXh/niZbwX2Zn6Q==@kvack.org
X-Received: by 2002:a17:907:d86:b0:c50:62ff:efe2 with SMTP id
 a640c23a62f3a-c5066b2da47mr541451166b.21.1794505688483; Thu, 12 Nov 2026
 09:48:08 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20260914223212.i.829-kees@kernel.org> <20260914223219.901347-2-kees@kernel.org>
 <20261112004039.GA523044@killaraus.ideasonboard.com> <avWNCC3_Ff0knO6J@devuan>
 <CAHk-=wgYBrhvo2NAG_Ja-0ovPf=xO20Gcopv9Yrr1u=QVxECZw@mail.gmail.com> <avX3Y08tF8Z0C4LH@devuan>
In-Reply-To: <avX3Y08tF8Z0C4LH@devuan>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Thu, 12 Nov 2026 09:47:51 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi1U9ry+MmK2_z7E=0KPpNG9zF212t-YmB8gc-qsUvp0A@mail.gmail.com>
X-Gm-Features: AclHuK8TqtfSnV8lmNLmK3LZjOEY1Z81GA-4LECZ876wsZ5FbRi5al1rfBz408g
Message-ID: <CAHk-=wi1U9ry+MmK2_z7E=0KPpNG9zF212t-YmB8gc-qsUvp0A@mail.gmail.com>
Subject: Re: [PATCH 2/2] devres: Provide kmalloc_obj*-style API for devm_kmalloc
To: Alejandro Colomar <alx+linux-hardening@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Kees Cook <kees@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, driver-core@lists.linux.dev, 
	linux-hardening@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ED408A0008
X-Stat-Signature: xjz5xnxpdqmrnuw3dzne1an35c6383qr
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794505690-337742
X-HE-Meta: U2FsdGVkX1/kWaA1ZHEDiL6cqRjc7lWE2KpIss+VXoyzKIR5/HRuoO6j84mWup43Eii5taLPF6Mp75djkOkFqCULv8vaa8ZvU0naY2ZJ0T8LzRygMt7ZmiFTzRFn2itXLDvrkZ7lwRwZskvtCMDY664zsIrVsjDu6k4g43QtLAdp6jcTN1SI0lHdU8c018WOzoOu2GcY1nAH45YqTxFBxETZ8gsAasaBxkLaMDCtwPvseT/Dw0907jLJv6d/DdOvazeakT+f0MOG6tC0T9s0H7btleoJw8x0zZo0Fu+sEJR4KqsUz7JXIT1CkZirsQVraSMy7nt1i4zUzJGsBTlNwgswYzbI0U9G8jz1nQD/tlzc95EIr8V5n6VoML+lO/dj0dHYKAK9iB8UJMH0uKYK/8yaWk48mMY7/CJI8sAqdlxDKgZ00hKn+GWg0KyzlCVfdwM3Cm2mGKebYy8uHr1mll3q/eFTQKMThk+FgkVhMzCpBnZg4kpbXJpT2yW4SXJ+FI3WXOYjCSy+tuiWFVj99q8ZJ2Fe6RPDsY8e14JeA1y/3Kbvn5fnNIbebJryKrfLTp8mFhb++HFxEN04fnwktsxHRg/DeR4nuK9029JoSh3o6dINXuRdTr04KAXVjNmHcjDevuk7EPPVRYYw8ME1JNE3hFTNWtUrpMYoPfrwDjmLv2ZgkjKpKMrLDolV7fZCXylUdERneUejYqdpnVnBXyaXoQdxYd9lht1tnS6T1wU+a4n8aGgDymsOUxOkUUQPkmOoeH1M1nR6y4zSuBZVqULwJI5JQ+JHaai2zJq18nKGVVvQh9GIMaA2eDHTcHW4rZx/mpQP/UDmSC5C7FTsEle9NE4/ie9QV7Hj0vQjXPNvGzHywDgzNmBwyUEb6RC7hUCp3k3lM2P49kGDYP2q8nfLSfcNqaNrTTgSss8XL9E3usXrpAkYoKntjxCwQuKxNcW6Hyh7lBAmNLD79Y3
 cTrC4/YA
 y3VDH2Qt2mtEH82Kr+McxofWoSPmI6JissqzrSlGQ8vucrTtZ6xjS8xqMobPlnZo9r1vo/u/prYfsyampA60tdqt5gd8RjQuPtls/jSxJESR5OUq9XehcLEvsUMRG5jM1jKVOT8HWUby9/ROSixhA6kn1MHbnQNprKPj9Kgk6qJYLLhlRwYhi7smiMWk+YNGrH+dnO3AKcy5x/4NtjRo1RXL6FRChPtmBeKJ+lGnemMhkb1pfPKiM16EijNNFZwddXyIDrVE9m61NbOZkvP9d8lI4Osbm/t9I0V07mlWpCDeG2Rvs856xI/lG4JwY/lz8Je+UQhhEyw9+aTkFtMiTw+Zlcc+uWvfUAmBQoH1aV3cmJT3HGPJ4DBUgpfJx7hSivYsMBaM1h3F87UXjJPgwr6367TuD/q34bteARoRbgZwdWMhFcfmf8XvQdb2fK+2RQ4qGhdbTn1uld7HgE5ufIqStExsZs+5uVN3+az/Lj9dlzvwgCXXOxF28qjaraL/ccKUZT8IYudi+5mvpprqcpvO4jG8fFGVqhvMo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 12 Nov 2026 at 09:33, Alejandro Colomar
<alx+linux-hardening@kernel.org> wrote:
>
> I don't agree that the code is worse.  It's _different_, just like Rust
> forces one to write different code

different *is* worse. We do not want to have random strange syntax
that differs from all normal rules for some little unimportant detail
when I already outlined something that has standard C syntax and is
superior from a technical angle.

Code needs to be legible, and that means that it should follow a
pattern that people are used to, not have random single-byte markers.

The goal is to be readable to *HUMANS*. And no, removing the (more
common) function to allocate just a single object in favor of using a
"1" is not human-friendly. And adding a pointless "," to make a
compiler think it's not a missing argument is not human-friendly.

And honestly, I don't think Rust is a great example of human-friendly either.

              Linus

