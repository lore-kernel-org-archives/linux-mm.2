Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72C96CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 19:00:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D168B8E0011; Mon,  8 Sep 2025 15:00:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC7838E0001; Mon,  8 Sep 2025 15:00:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8FCC8E0011; Mon,  8 Sep 2025 15:00:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A0C258E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:00:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4D01D139810
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 19:00:50 +0000 (UTC)
X-FDA: 83866999860.22.E91997E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id D08A480008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 19:00:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FSktK3wi;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757358048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=unHbdgJ8hQPcjPvcUtr7fc3p+foQbqVz0oNWcBChLeA=;
	b=agDOE97T8wF6oCIS1BeFUR0yKUQ6GMhEBvFS3aC0xAKXZaHKys1QDyze2kXEKgLqY+s7VT
	uZDsY9EkNE78BLKU1mWlWGd7siGLWcs0l8MYqwP8Kw5J66Dv8EZSTKzW/vP999yAjR91Ic
	I1gMBESOfae1QsEChaB8+fQTxXPrgQI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FSktK3wi;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757358048; a=rsa-sha256;
	cv=none;
	b=P81haLMujlDy2SnkYUR1XRNN/prWWKLmnobNr/jkMovCB+baccYyO13ofHXjTNWzELU/q2
	9X+VgX2nYWkK0/sML/nAdLIMbBPeP1jOkBQQxOqbH+5fp6OqXozCi8NgaPyGX5LFRitIbK
	UZ/gKVi+UfaD3+hmfwsR4SvbB1Mkl5g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757358047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=unHbdgJ8hQPcjPvcUtr7fc3p+foQbqVz0oNWcBChLeA=;
	b=FSktK3wiY0mwFRjN6rJ/l+Ae9q4cg68PG1VBrqNyZ2kiAe9Vcy0Z6pVXcjWNIOhZF9GGrY
	N3Szb3ktzxMJ6wusXL1X9lTMvLKfx+yVg953PBRo09gKSAsLdoxs99ZKs6r4iLwMPiXLhS
	zrohZ0hmltD7G3D7l6t/uh1Wlyll5Do=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-216-Xx0F5y4FOTeHuto4jMe1RQ-1; Mon, 08 Sep 2025 15:00:45 -0400
X-MC-Unique: Xx0F5y4FOTeHuto4jMe1RQ-1
X-Mimecast-MFC-AGG-ID: Xx0F5y4FOTeHuto4jMe1RQ_1757358044
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45de5fdda1aso6212395e9.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 12:00:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757358044; x=1757962844;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=unHbdgJ8hQPcjPvcUtr7fc3p+foQbqVz0oNWcBChLeA=;
        b=OzeYUmZxilpH7qb7L7cAXUanpCCHAY7x6VRLE8Wrrfj2a+Yy6azR/9P1nhqR2dEV8t
         iN0yeVWWaj+f8oh0MYdbHRe1wNuQaPRJeFYHfjcqsZ543NrpOwu+LjyRZntjuKxqJ6TK
         VMpW/jwcUD5HT/ATf9zy8lcQwJW2TaKGqos8UsE/HA34QV8RjSaiitrpvaqJLx9lMwxt
         nJSdYGhR676WiQj6cIEY7WANb73eTCIxrBKs+ZGh4DkJPWeXo5S3UTZy4ZsyuI3nwIpo
         Jc7r9HZ9xRpqP1Joo5OknkLARu68B05E6ENlWEXqDEpWffCCX8sip+eJPt0aTTjGkyJO
         SPKg==
X-Gm-Message-State: AOJu0YweKBaZLDVOnVanackpZqeUumLxQNXUNHfAPhEGSGRc3nDICRtE
	v0g4ag9TrKSXDqtP6y7ITDzNtfq8JRs0hc3PA4mFuva+6NSIuxgr4AW29AMO+qKWU54Gcd/98Rv
	z6S7jbsArGTvSqTGUoioJwZbBrDzDQQAK3OrMGn3TxjVUr1jKHebfziQzWIAw
X-Gm-Gg: ASbGnctFIZDwHSNtjIdrt+0rjiJ03n+jQYJoDhq2muj7UoehwkcWGwDr/g8xDytbQJL
	iZEv0qJwvTeintXF00jr5japdpLxglg+Y1tuadn3FBfSX2OP5nH0dI/8SFGvwoQwKIE2bEuEEt2
	potBprSUIhk5berG8QI8dwgDdGcs5YdpjHwMKEm60hBDUPlGWVuVgTj+0rUI9MbDbrjYf5bOXQt
	v1Tabpki5yq22NJ+xqFt/CnpboUfD2FaSjOFYVKp1nTLqL3Oi3ZNXvLWveYWfqc+xNbVGBsfwec
	zdIeC2Z8Kyi6BZKtrzJqkw1jXIgvqizRS86hBXAe89DdZh8pewduq+50r0NXWZM7DzRduU2ne0d
	/DZD1ursJ8OwZYFdrOEZek48BZcLs78SzzYyqHGc5YCMYPdlBgOX+KgoU+zNTKpAK
X-Received: by 2002:a05:600c:1e8c:b0:45c:b6fa:352e with SMTP id 5b1f17b1804b1-45dddecf506mr90010695e9.18.1757358043709;
        Mon, 08 Sep 2025 12:00:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFqTVEY3JavhAEOyuFob/nTOEfjlR25CcLP4B66Pb2oeZ74bhFOyCame3bg7EGNhJ/VSnvlFQ==
X-Received: by 2002:a05:600c:1e8c:b0:45c:b6fa:352e with SMTP id 5b1f17b1804b1-45dddecf506mr90010485e9.18.1757358043358;
        Mon, 08 Sep 2025 12:00:43 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e50e30asm457435105e9.24.2025.09.08.12.00.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 12:00:42 -0700 (PDT)
Message-ID: <785bd891-fece-4cac-b067-1aae9f27d7ee@redhat.com>
Date: Mon, 8 Sep 2025 21:00:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] ptdesc: Remove ptdesc_to_virt()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Vishal Moola <vishal.moola@gmail.com>
References: <20250908171104.2409217-1-willy@infradead.org>
 <20250908171104.2409217-4-willy@infradead.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250908171104.2409217-4-willy@infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dufBoTgfZZfqrtGeMx6mtNK4peRzkTXbmZJUk7EFEUY_1757358044
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D08A480008
X-Rspamd-Server: rspam05
X-Stat-Signature: oyxz3wf4tb3ww79a866de6797tzt95r7
X-Rspam-User: 
X-HE-Tag: 1757358047-933033
X-HE-Meta: U2FsdGVkX1+lmpAaL2nXgBVIAWtowF5bm9gtCSq0YSZ89mIUCceD7wxCLCJjb8V/QNpJuOi6C5KYvRmjF3I4VuQx1c6+RMuPvyzTrT9aY1OqNZVoIqVEF1Lga6g09hs8Nfi9j57gr9fsbVPyaDhLjCkDa55Hd0IIMo2nr02JM2v1WS3Y+elVBZwD+llCC7sYAo2qqa7pUUubDUWlA5E4MWU5bvwrXSjibO7Sjmpp68A9YmCvp3qh/IH6yM+/YoCnNxWtRYB/86o3rKaIet1oHGGSUNvE/0wDIo0qAsApRZB5BUxfZ74jh/s4/s5lvXL72b7WSBcQ7gWEcsZlGv2fXkON0PE8sTH2yi/qeCzgxPTaCKbPuwGhWgKVihUA6K2EOKRxVue6aGGJYtCzgbXwVfJ/U0N3sZ/JZB4FZmyj9lwbXm/WWeiuyN/LtrP/mP07PxWVS+ThBL0g4hZbgIkksgsmgbetbgilzdjg7/CEaa/wHzIzOVnvx4b8SzcAYteH5WsOc0fa2pPjPnPXRgfw4DMBAR+VC7VucrthQ37xOvApmJeSN4QNu5woh8kkU5YfgOJL1fsxekjnt403OIiej8Q1IoNEPq9gWTwN4OUbwAgTmN9o8S5N0w3v+YG5MDRISUeHkRbMT8t2BfOobR61PO9IaLEqaxI5CIPW7LnSXhaq2plQ+v2rCpCCvILRJwvQ6jTMnhzt5aCfVZ9eohUXhfHRWL8Fopjjg+oAxyptZvvXs39p532a8yyXqPFnUh3zFlrlh80NorvuGKLEmeSFLadYrYxFdb/8N7BHlPulGX1P0gRITFb+FKaeQX0SwiHkUGB0zpSbv5dI6iMzd17eOoNueU3S96+vP1jGD7V9Sx9uDhvYf1qIu6MVnLFOD2bzuHC7Xyvg2Int89w/SJDj20qj8upgSUSMwgGz04L/kZIh5iMNbJjxbW653REyCZAsPD8QDRk20uQaXoEQqPF
 3vW7hzkG
 KEebf+B4UYkzMWZpJeEJEnsHLcpKtB9PluDEj2ivQTiwfMHrxISwjAYDL9mAke+qTkYF1cMUDGQRMxtYtLOU6XGs+VI5Wk7Vy79E3eFUSSOQ1hJCWA/sBaAj9FjnUp3VI8Xqf5ohFA49IJhqsjieKukxwF/7V+yRPmyaSDfyKArW0mw0RpSqNVmyamfCDbGcoOJ6UZpAcf0XHx276fEs20OMSA5kdsJAvchCjGY/lYgXqkdC+mjtHzyAfwDJeiOTHffszo6LaOn4mmR2gEtjZ6N9yDDtwbBdZta42vE08+nIqXfvvZqlv5yMj53INxtAz9TLv8vUSf6bOXgkM4VjBmd2Zk9EXAbWY9GaBPzKorZGs9d4BDcufea61OxdpEw7piexbwdY5RgbqRYFLoigMc1ORu1+GCduPSsetRsTepfIsqzoMAapTr5NJTYB8GFYOjDETnLX9eAthajR7ZYQS+lAd3Rtz6g/yMc8WoKke2ITT9KKbI9GZGOJB8zZG0pG3kkg2qFoHoTunUHr1dgWeqpyrKQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> -
> +/**
> + * ptdesc_address - Virtual address of page table.
> + * @pt: Page table descriptor.
> + *
> + * Return: The first byte of the page table described by @pt.
> + */
>   static inline void *ptdesc_address(const struct ptdesc *pt)
>   {
>   	return folio_address(ptdesc_folio(pt));

I assume you'll tackle the ptdesc_folio() stuff separately.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


