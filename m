Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5319CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 14:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3571F8E0012; Thu,  2 Oct 2025 10:34:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E03B8E0002; Thu,  2 Oct 2025 10:34:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CEB78E000C; Thu,  2 Oct 2025 10:34:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 03D9A8E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 10:34:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8B3BB1604B5
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 14:34:37 +0000 (UTC)
X-FDA: 83953420194.03.016D803
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id ABC9240011
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 14:34:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hviAjhFO;
	spf=pass (imf12.hostedemail.com: domain of 3eY3eaAgKCFwD46EG4H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3eY3eaAgKCFwD46EG4H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759415675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ccAYPxe52zBmW+CF4aFxuUujdoprfZQhiZMBpUVmHbM=;
	b=IECDSZb7Oi/8SXNP9AtG/DabvrovoV9cvT9x5fWzHG505yq5vVoCyRlvCxWwRuVNjhW4iB
	aVzm0oe5IuiN5BXl4/piYkz1j164h+C58C4SFw4Y7A7iRaXbJOjzDBo1wT4LPCuuFn8gex
	AaCfPUdB/C+BcU1WoNzyklxlsBE8Myo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759415675; a=rsa-sha256;
	cv=none;
	b=n7mCbT1EGKOcET3htjOd8kv6qHad8mO0CJbftGBCYO1MBnwf2uH4jVbZZXN9Ud6jWBJf8N
	Bs6F7+gXQ+ImCzKFfwQ+btR/ZZlgtrEfYuL2A+xu3sKNwQtEtr45vNWmqKXkanjAu7x5hC
	V1DEbdTahnZfDJ+WX3HZRO2a/1ganHY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hviAjhFO;
	spf=pass (imf12.hostedemail.com: domain of 3eY3eaAgKCFwD46EG4H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3eY3eaAgKCFwD46EG4H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-afe81959e5cso158530866b.1
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 07:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759415674; x=1760020474; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ccAYPxe52zBmW+CF4aFxuUujdoprfZQhiZMBpUVmHbM=;
        b=hviAjhFODJoPxbOATORG2YUsqtEt1KW8WzTPb3GcIjh1oJFQbJkflUuiciF8c6x3cp
         /CQOGCe2CtLDbIfxol2ihPahXWrdvENcNOtNxPm9TJGJ334Zug+a5/pDRWH3RYUwp2vA
         nIV7l5HJK850y0i3e3J71ihlH+rmamFUrAmi0Sy3r+veX4qKC7k5lZXXK3jfPK2W3wO9
         v9vTw9j0zdUrhzxFZGy7SzuK6+JEPbo1MJb5cUzGTSttdjAw7pM8MjnhbZ2dD4MAVudI
         MljYzkXY+AvV/A6OwYcYXCMfrWyEw7TDkpOQr3PA956MOED/daw1Bzw6RcA2t97xZX1y
         /0Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759415674; x=1760020474;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ccAYPxe52zBmW+CF4aFxuUujdoprfZQhiZMBpUVmHbM=;
        b=wITlOo+KSTGq8kQ1Yjcx6jNA2jN+wPorOGrllyxYXeGjHgfIX6b7e1/941pg0a3lRh
         3nGQrF6Hwka+ax+X3U2oZVCDgPuFlRFw2yw5sD7ivxqWcTb23Wb+r9V+Ehmb5O75NlMm
         AJNFS4BuBf6z4r8QJN2tJK2b2oSJk8LxN/MbOFdj8n08qHRMAclXntt5VrAe15cv0j2p
         IYNdzqxmohijtUAz6cG25IWPFRTgH9oqUYwfrggX3oDXSec7YWBavQ2dmZamdeoETIfR
         x+zaIqiMDtOfnxf+r+gwloEKjWqQkDK1N+nO9gEUMciYMPsjKQMK5j4+eFHyvLU8CXqA
         ZAbw==
X-Forwarded-Encrypted: i=1; AJvYcCU/cQRMs1WxTPFFSVTriqKD9zyw/IMVK9pR0/HGv8enW9l0eu7+o+r9a8P6iObYeVT3RXejPdN8Tg==@kvack.org
X-Gm-Message-State: AOJu0YxmXgMvJSV4/GjmQKHQYyEsLkSvwZo4Au66kehBczvqVLWvCHh0
	d4onzebdSOIaxeZtJYJe6HLe/LLJ73WknL4od05txm5wdXrt+ucGZlYQdBbK/IA5VlTjMqoAOKy
	Zx1X3zX3Lp5vTNg==
X-Google-Smtp-Source: AGHT+IFdG6GPcaMbq+nXyD4vqbM1JFF0Ehtb9l8N4ZAbsP4Fg7J26kq4QoNXh1x8rjPxUFgXCopP4kBq7GBFoA==
X-Received: from ejbbn6.prod.google.com ([2002:a17:906:c0c6:b0:b41:568b:f49d])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:c14d:b0:b46:dbe3:e732 with SMTP id a640c23a62f3a-b46e8c7fe49mr988799866b.48.1759415673921;
 Thu, 02 Oct 2025 07:34:33 -0700 (PDT)
Date: Thu, 02 Oct 2025 14:34:33 +0000
In-Reply-To: <fb450443-07c3-438c-888f-30540935da15@intel.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-6-2d861768041f@google.com> <fb450443-07c3-438c-888f-30540935da15@intel.com>
X-Mailer: aerc 0.21.0
Message-ID: <DD7WSY2PPABG.UK6GJ98WZS79@google.com>
Subject: Re: [PATCH 06/21] mm/page_alloc: add __GFP_SENSITIVE and always set it
From: Brendan Jackman <jackmanb@google.com>
To: Dave Hansen <dave.hansen@intel.com>, Brendan Jackman <jackmanb@google.com>, 
	Andy Lutomirski <luto@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: <peterz@infradead.org>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<mingo@redhat.com>, <tglx@linutronix.de>, <akpm@linux-foundation.org>, 
	<david@redhat.com>, <derkling@google.com>, <junaids@google.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <reijiw@google.com>, 
	<rientjes@google.com>, <rppt@kernel.org>, <vbabka@suse.cz>, <x86@kernel.org>, 
	<yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: euudpgp9umwyo7jj5jb6fzmt1akemo9f
X-Rspam-User: 
X-Rspamd-Queue-Id: ABC9240011
X-Rspamd-Server: rspam10
X-HE-Tag: 1759415675-815886
X-HE-Meta: U2FsdGVkX1/49m93ecEXkNOM2jJN8iEDMDDrL9JmEBiADCtvQohNS7e1h+EictYSTD+stZFffLscaUF9KiAQQ0Od8VvcmYXkcutxr0QBsleIyTUf9kCVPic/DtHa9DmJ3AcAcX2UXwrPG7pqPayxkTd9A04acBZoqnAJWe0myczNJby6hKWh2M9fxwFhbicaKaHaGZmMpjbQjKUKSIHeX13yt7oxkGpX62pX9nfYnTT5fa7Y9TTy3hJVU0VOE7CxRe+/v3aassORX/rpONyPsXD4TPISq/VG7BENq/kmhkcomiRlkW4qBu1Y+hzdNSrrNEO4ynYa3hO4sLH6ffKIBesjOxOJP4S56BEAvDfVDFDDADkgZS+WZvmXO3J972i2K5gYgK6m/4O9KebbwSyYLu95FDGnBEGi39fhoMYgdK6+RYhoSdv/Z53vci1KU1dSyGDxVfAsbC66TIMQPYdA+QWMgf9g9LiMCpTk999jGZFBTeiDKF84XN30TRB6x5ZhjFNZQCFb017+sJyTT2eDKUKkt5hW2hIeIpqSCFiSbdM9gZC92bPfrq1IjK+f+HzC8w7igjHaqwMm5JOjQo7/JXvXUSaBVfvgD7sC2jInoO/XWy0cfQVy/2Uffqt3/6YJ2l5WIszGOC/4DlrFqP9hTsqWYYY5TWodC/ZZ8+VDmOszLyfbGfEk5IImzr6HC9ZTEpuyN22hQ7YL+//voHclB6Y2cwt0BaEshumGvQMqb0Kalu8vmZcviO+Ky9PPU8s9PD/dyLdwz/V++1BCmiVabrKkhWhAouHlpfS918fDZHNGRa2wrPZncbm0Z0lf1M3IrifR1YhPPndQ5/rZj9bpiLK5ZLACV4itNvMlALO+ChbtqVQwHPfgftcG1BPtxYuIr+/o9v+Uv/GyRfWio5Gh30KBFU08uLHtVKWfxIQbD2Mbr/27q9lYwi0gDbc9rzGJ/nyCuga347PkBziNlPv
 X4/ZpIWP
 GWgsTBOtTZQEvgQfY5AG12l6WxBdva/0EUlKA7GEOdYcFXwqyWwIK+8HdQaXippPuTpD7AfrXE3fFJcwITr3kw9m2UJXwpISrZ21qwUBfWD3cph8kR78lb5lZW2CnUSWxfmP8IHreKEpThnXAy+kGm/1r7zOZz2U4WIUE8kzp7NL0jyiW0+NqCxyWK7P45jScm0Pu0c1wsJEAFPqg6KMvOgOvC8S11Z5DJ1TdtlLgZ2BEDJ1msHJkNpgf/640O5voDzCFNjLOFu8DyCx/P6zNZ5MEWS//BkWDUE9ORdSft/VTJHDcW9y1vw/gCL/RpYThtDvOpD4vChycSwKlCixifVcpAnxk0Mvck1dP3151gUBrDwqJVWs8Tg5WNnxxevxDRI3k1fiOTdaFu9hFUB5yC1BiTn/E59XEZr1drU+JqZgQNjFM9igoUnuuSHQ8Ru57YHiEhDtDtUesfz3oCW9TJk8Gz5InqvYp4zut8YsB51I0nEFWYjqygm1uH+SuQyGpBZKzmemDuiSbzCIYnsnzuiFeQfbL+bqgCbsQFZ4iqM8Ypg0w+z8VZ0IaZjkTtZcllYbCpCd9R9N5pW6xwcBK5ToAqiXk/vSR9qv+rPrv4fm+1DKBBkegoZ/vC1e88AkmdZjbaTI1DiPxlUy4m38o7r2NSbFotUtRjXJaZwf2vTWRVSUZHA6McRBo3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Oct 1, 2025 at 9:18 PM UTC, Dave Hansen wrote:
> On 9/24/25 07:59, Brendan Jackman wrote:
>> +#ifdef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
>> +#define ___GFP_SENSITIVE	BIT(___GFP_SENSITIVE_BIT)
>> +#else
>> +#define ___GFP_SENSITIVE 0
>> +#endif
>
> This is clearly one of the inflection points of the series.
>
> To go any farther with this approach, I think it's critical to get a few
> acks on this hunk specifically. Well, maybe not formal acked-by's, but
> at least _clear_ agreement from at least one of:
>
> 	MEMORY MANAGEMENT - PAGE ALLOCATOR
> 	M:      Andrew Morton <akpm@linux-foundation.org>
> 	M:      Vlastimil Babka <vbabka@suse.cz>
>
> ... or this approach is dead in the water.

Yep, I agree. This is where the chicken-and-egg thing I mentioned in [0]
comes into play though...

[0] https://lore.kernel.org/all/DD7SCRK2OJI9.1EJ9GSEH9FHW2@google.com/


