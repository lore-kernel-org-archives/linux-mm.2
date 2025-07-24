Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42242C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 18:56:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE0408E00B2; Thu, 24 Jul 2025 14:56:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8F948E007C; Thu, 24 Jul 2025 14:56:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B574C8E00B2; Thu, 24 Jul 2025 14:56:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A2DF08E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:56:29 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4E69EC0444
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:56:29 +0000 (UTC)
X-FDA: 83700064098.11.4E724F3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 98DACC000D
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:56:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RCWSnRqi;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753383386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z5RE8ieixVr1FZvK/cEBWikusS31nqX+pPuAGM1SJ/k=;
	b=W/lK1bP2Yu+BUjxOZOEYJm4cT7F7y3IEC08X7NN5Yk76HfUtRFuRySJKUwBmJHKzQoQve2
	SMN0S3nV0oVsH8LwkcdpnuCEDuqem+oRiWZLxG0aIj2Ygj4nR9SPjYBvanAMi7FJT07IJm
	2gfQXcZ2wuWDHI58wiQOJGZGuCXLCT4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RCWSnRqi;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753383386; a=rsa-sha256;
	cv=none;
	b=hSjEEWIogoftHLmJuvgKjo+tu0FwUsXnzexADHFV2wSaBxyeNGX5a8kRnFqs1KFPy6JFtr
	0U/GxbRO2l7AHksbQ3K04TNOZLYObjqOiIIwCkHPt6IUUHi636hCD+mM0iD8yJomvufDUz
	USuiRxD4BhW7Y0GlEvSip2CJAuBr7Uk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753383386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=z5RE8ieixVr1FZvK/cEBWikusS31nqX+pPuAGM1SJ/k=;
	b=RCWSnRqiQeEYi5/NUeoZHBUhJUcAkIO+QZ5xQ4S2ijXOfv6X5AKYCQgIzkS4FR0OAE+Vqu
	HviC5sLUE6bRkAz7xCQQod3PMIOvunkXhSSe3k0w98eT07quQlC0tV5ADKxxaJpbzS8p09
	Dn7bwHM2EysmzMlDcgEOKNIGySHGn3s=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-265-VIwiVSEBNz2PxdMJDJdu6g-1; Thu, 24 Jul 2025 14:56:22 -0400
X-MC-Unique: VIwiVSEBNz2PxdMJDJdu6g-1
X-Mimecast-MFC-AGG-ID: VIwiVSEBNz2PxdMJDJdu6g_1753383381
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45624f0be48so7059065e9.3
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 11:56:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753383381; x=1753988181;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=z5RE8ieixVr1FZvK/cEBWikusS31nqX+pPuAGM1SJ/k=;
        b=THPq5yJOsrtmtnBbsjER2fP0muF0WMSbyP5JunWvt5bZ5Z8ztOvJd4gx3j6Vc+Cbx4
         n6FIWtxmVYMX/yHHKYauEmJB7ZFlDg5ghGg21hI1bLok2AqbHnUksFpx6nNFv/CutrBe
         1KhFgpoY8hzo7RoDDpd3acudUXOiVTK45YNiCKnuN6/iAwbJuB9ABkbj0ZYmkrOEVm6q
         3pA6ZSnZJwSvAaOUJ8QIEhp/AaM0fDH7zKDvsi7/k+fhhNvxGTi5WOGL54q8kcfF5Gi6
         72ATzRi3udyH7Pi69MITs4Slua5bYrL9KjS/UPvFsp5SxJkvHnAqFG5uSeJ+ZuszZfl5
         IAVA==
X-Forwarded-Encrypted: i=1; AJvYcCUsE+N8Ndj4ckI8YdlWxwe4iHDUV8ECyl/C2SvX3YTghOrnKvLEIbR5Xr09jwN5v3+HAYwF6iOMfQ==@kvack.org
X-Gm-Message-State: AOJu0YyCjjZpOxCrVFsKXwBAtQUcZLTLJ+lqVehK2D3C6g7fOjJ0yTwD
	KdviRkIJMwDxXC9+TZ0obPAwNVXFKjMihEnNWBQOy5S2fsc2h3jmp/U92z4+TZyEutYHiXTLf/7
	dB/N67LGJesOclP7H6HiHfdwEjdwbv9R3rmI2nmCiHzTCy6OCrCbS
X-Gm-Gg: ASbGnctKIBbKYmWli9Ht9xOEQPJ7sp4E5RAETp5AxXB1EanonWqfZSngHNxwSM71Mvr
	yU8vrkNp/aNfGNG2kRldVV9eK6a0lwJmsmoZwadau2RAY1drGQdV3LRFi3t2jgnqmEuNlmdt7HA
	/ML5gNoYG4aIiO7ZkcVTerhbvuiTpuiRKPDwx9YutAxtYuyeGy2vtRs1UVEjbJTgjx/EP014qn5
	Lyrhs82NbH9ZCVAwmrIeNCAoDY2pyhH5P6DYqaJeZ9BeDEC2t0N7oK24e9pt9KYG4rHX8B01PE/
	vkJFQtKZRcBl+DgBA0eV5jZCBkpTFjGMLl5QQYFTfT05kHmzz+2RU/vSKIWxIGEQqCLRCHGMEn4
	doyxu7NGsaMpa+7aLOMNTMkcL99+gIM44tSv6r7QB6FjGHuACNV6suKAxhlJiNcm09PA=
X-Received: by 2002:a05:600c:811a:b0:456:2142:7fa6 with SMTP id 5b1f17b1804b1-45868c9d30emr69908225e9.12.1753383381318;
        Thu, 24 Jul 2025 11:56:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGdAyXbzNe22IPRDjuVXzdwdHtPaDK0O9XtZTaXqXhWLNbVy9ZJqhMpYUuuk34Bnx9LVuwZMw==
X-Received: by 2002:a05:600c:811a:b0:456:2142:7fa6 with SMTP id 5b1f17b1804b1-45868c9d30emr69908035e9.12.1753383380769;
        Thu, 24 Jul 2025 11:56:20 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f01:5500:ba83:3fd7:6836:62f6? (p200300d82f015500ba833fd7683662f6.dip0.t-ipconnect.de. [2003:d8:2f01:5500:ba83:3fd7:6836:62f6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fc60501sm2970578f8f.2.2025.07.24.11.56.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 11:56:20 -0700 (PDT)
Message-ID: <ab45d2f2-a34e-4ec7-8a49-03d166e6215a@redhat.com>
Date: Thu, 24 Jul 2025 20:56:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] mm/mseal: update madvise() logic
To: Jeff Xu <jeffxu@chromium.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kees Cook <kees@kernel.org>,
 linux-hardening@vger.kernel.org
References: <cover.1752687069.git.lorenzo.stoakes@oracle.com>
 <ec480dc1fd4ce04bb11c0acac6c6da78dc6f4156.1752687069.git.lorenzo.stoakes@oracle.com>
 <CABi2SkU75e7tXcpgnLbDhqSJBWVPOvmfMh2uPsU3mUjMUhhYqw@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <CABi2SkU75e7tXcpgnLbDhqSJBWVPOvmfMh2uPsU3mUjMUhhYqw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HKKixx6WrXaS8pGdMGtmQxZHcMOXMJaXDGO_kRhBguA_1753383381
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 98DACC000D
X-Rspamd-Server: rspam06
X-Stat-Signature: 7wm9h3mwjbztjgx4qww1o653mef1qerg
X-HE-Tag: 1753383386-809343
X-HE-Meta: U2FsdGVkX18QQoqfnE/QGzDYqfPZ8TnCGoOv1f1lRv8CCMdD9MGDXPuPE5+32Q4oaorkNhaP22c9VQrvysmnv7OxpTksFeR4pZfV41ku88I4nKhkUN1bNZU2GASG6gzbNEYxJuXqknfH5IB7UDQJe2xOHDUbFow14Vfr52nQ3EvqNFnPGyeritoM7vA6LH0M8Lb/gy1BLZtXRAZ6JTpxuZmvyZ8oVrCqqpy7qvyDdkUgrS/bhIRREy0JNMKDDEpu9DDY4PXK+r8hZAwo3spsWY8Jpd8M3FeP6Le7Rk0Sao3JYnG5BCs0UrM0WJW0bxfrao47tWUt/00phNlVfzVv+K6F4ZgdPYRjJ6RXTjWdbbOMCUUuZFa9m1ev8AJs4fTyxH2drJET7i3NJsqVJpapF+DIbtFk8LgU6XnukKTywVEhFjILcOQFmO1+68XWqgn0LgUyxRrt7rgVgjDQvHZA7FJ4tGmy+iWpLM1y5GjVuZPmmqWTEvQhSkaEQiaMuDsUwFBb77ePtdyxkVEz8tK6tZmAPdbgwziO3vC/0yOXZ+luOyxJ9hergmAMpmWilrTibz8aUqO2yFuH2RGgIcCMd58biD+jq3P1vbPglgYMRyot+U700QG5AX3lMS2YQw1qwQmeO+XJg9NZ6X1tFBZO/JuEZMjN0JcNNOJbN7pP8LsHwwCJqhHJWmpiOa+YfgjNMQCqoZOMJ9JLwCp+Km/3UaQCkdO4vdLCjhYLwZwvxAHIHQscPixI2oBRxvhZxCYpOAEurolxWtJYQX4Cj/QaHTffD54wxCNbPipKmFnQeM/XeTRuXRRwN4HZoO8UuOgMV4eaTxlsKcFJ4H6rQEUtBdzlF50YMIPQHXcQcb8/QOxXgXfYFvGsFc9zvQ8WYDphfwUGIu+jEcxsOPJQUWpoMw/khT/Zg3KXlY9/M0G3jKbOK1lVxlMaXdL+qpvhxZnNS4A1kOesVljkHOZqwqb
 T6mt+zju
 cNOKwsyGAjbWGJBPZbj4vwk7pD/BKxYVgVuLmFKk1U+Q62EoEDSxaXtQS0oyAtdDvTJLuAAcxYGh/fyXBjP4FU47IzZbHZMxE2ATjYq5LPwys149tmn2MZxLRxBsNUrE7UVQUOlK0NhgnwfAdPio2Qy13Aw0Ir3jWuHovJVcmi7RNNStgNmqlXLt4vCnZ2q0q7yOzYi7KuH+o8vKJVCsbU0zE6SSIVhIua+BEU1GzcZsgbG+hY9zKCR7RCyhkOV0YYy+VTtnH/zpZEFQAtCb9SGZ9wEdiyRCa8KX5pxwK0YKj21Z5ewnDhrAqwCQES7e5DgitqI9hPfOvwGUF9peBKs98+vW+XtQtNdXgW1czQRedgFfxkElIWVvlroFHcJ8qgwM0zqUFo8foy9wPn1tfZuICSDmXw6lmBh7ucHxDZaVWxZdLR0pI+ffs0W4K3Iq2s5lps2DKAIV7oU+h3K9/gt1elw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> To summarize all the discussion points so far:
> 1. It's questionable behavior for madvise to allow destructive
> behavior for read-only anonymous mappings, regardless of mseal state.
 > 2. We could potentially fix point 1 within madvise itself, without> 
involving mseal, as Linus desires.

IIUC: disallow madvise(MADV_DONTNEED) without PROT_WRITE.

I am 99.99999% sure that that would break user case, unfortunately.

> 3. Android userspace uses destructive madvise to free up RAM, but I
> need to take a closer look at the patterns and usage to understand why
> they do that.

I am shocked that you question why they would use MADV_DONTNEED instead 
of ...

 > 4. We could ask applications to switch to non-destructive madvise,> 
like MADV_COLD or MADV_PAGEOUT. Or, another option is that we could
> switch the kernel to use non-destructive madvise implicitly for
> destructive madvise in suitable situations.

... MADV_COLD / MADV_PAGEOUT.

I am also shocked that you think asking apps to switch would not make us 
break user space.

> 5. We could investigate more based on vma->anon_vma

Or we do what sealing is supposed to do.

With the hope that this sealing fix here would not break user space.

-- 
Cheers,

David / dhildenb


