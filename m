Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FB43C87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 22:18:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E9736B0162; Thu, 24 Jul 2025 18:18:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29AA46B0163; Thu, 24 Jul 2025 18:18:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 189B46B016A; Thu, 24 Jul 2025 18:18:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 079B46B0162
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:18:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B5B52132F3B
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 22:18:40 +0000 (UTC)
X-FDA: 83700573600.21.8ADD466
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4ED5620003
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 22:18:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CVMjbcHI;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753395518; a=rsa-sha256;
	cv=none;
	b=r9C3BPG4ZwnJ+byRr6hNhRjJ5FJtXulm2k3WwQ2S1i8FndT8zpHQFA7kRj6u7HBq92bwsu
	yusS3nSF0I39BIjr8JPTgf+RevDDxwMu1JP0qIXN0cQP2wlrIz2E7Qvux1+PTDDHURYbJ0
	o/3co/eOUW1tWhpMuFrsmVz/4P93i28=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CVMjbcHI;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753395518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o3Ts71k9kWEbm+9MEFacjDKvVlaJ/u4GBTuIh+m8AWw=;
	b=IslyeE86k9d+/lIbkeYTrfXFh7yq97r/6bp1pRCQQyz0nA9JgKoAfyKRSQez/n11TFo3LW
	kSBap42TnZ5NujsubW+c7cFlvDoR36u/7zMz+HF73sUTvJ7AFQX8tlYv3uMOtrMF5Q2HIG
	kN6GYpdMKYexfbpBxiFMdg5CIM9/KFg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753395517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=o3Ts71k9kWEbm+9MEFacjDKvVlaJ/u4GBTuIh+m8AWw=;
	b=CVMjbcHIvH8197HtUdst0jw4c3e03WMbrG5PsNj205xdtiSHcusE3iWPIyg2TcEYtLni1T
	cI0GA1ogDWpJV3Rjcm7mUA+f30QJBGA7lHug854+j/RylRbL/VBGFe1RU6eUIfqTCYggW1
	tGYxUbWZCJy+ZIBIoWqGk0GooLYq/XE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-493-vofg8NR-N-md022ysJYUjw-1; Thu, 24 Jul 2025 18:18:36 -0400
X-MC-Unique: vofg8NR-N-md022ysJYUjw-1
X-Mimecast-MFC-AGG-ID: vofg8NR-N-md022ysJYUjw_1753395515
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a4f6ff23ccso884469f8f.2
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 15:18:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753395515; x=1754000315;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=o3Ts71k9kWEbm+9MEFacjDKvVlaJ/u4GBTuIh+m8AWw=;
        b=wXbW4pnl5UbQj8QZ8ORl6lbu3/DoEUGqbjjKnZ8jFQTeTY+kqCxRJZ2AtM0oVGl8hj
         K1eK0r3BM4ZC0MhkKQIYZNL3KLoSoPveEXSPNPhT3Le4ATNYI789YOIdVPnVi5xWsbMs
         Uz2EARRQ85oRQQhjMnS195UEvVs3k4Tz70Ed/aAdnKqb3/1MCeIYa044Hkc/nsA/EiVx
         Fk7Eneb+qUTkQ+c20BbvfFPP0FUqAHwq2BJ6VvHT7weTJ+XxifSghCVnoBBM+QRRH98q
         LV9NkYS9/M8oocx1AfYEJgZ9OYtWz+4PMs1LlTX5/E6fRWFPSd3YQDn2ZZ3Zna9118xg
         UBNg==
X-Forwarded-Encrypted: i=1; AJvYcCXHefjCyapztoLQd7IroiWPEag8dz/PM06igYrLwTGZy9Uvf6bOsZ27YGIZTQcKLCGIebogkM3PPg==@kvack.org
X-Gm-Message-State: AOJu0Yyu/YG1mTwKTILYiKF5ObIK7w/CsAmplOYMH/1ZwsmG7B/wE3Q3
	cIxBoXTMZ7l53nD6XLS9hdFcAsGNMdOuIO+JNfogkRF1EURsLWGEFoW9xMMicuNUmQLIhBzObKF
	FV7bbFdjpdiYTwdcBnqs/8OeqmB+jvl43/H+OYA936+XGOTxeD857ZIF0axwNAO0=
X-Gm-Gg: ASbGncsJdQnotKwGZo25OeIEDnpZB/1NDdB7JMfM85ueQ61USGhKu6dPB7AwYaRNilM
	SmfcaKTXRt/h4KC1HaTMmPPZFXw1/9J6N1AxN5UaACkfQB0N3AMQJxZlnhyNFO89oX1FVTdUB9d
	84VerXm1wdBmcgLeQgPoJolt+JLO+BXtpn5xXrC59napIYKeZSw/ee8Ye+m7ZMsZ4urq8XaYByQ
	BApQUIrHavNPfrRFR8cOVGW+iEGQ6ArsXIg4QMHsodZ1D/Hu7dwOsmt62hIW6/IoRnuvHne/yV6
	wQ5c7PXc29ZK3JiNcG/D9LXssxiNddXjrwjkRgGJjTssRFP1QHXQkzyd9PLCYVWlpbfybOL4NxH
	SVSx5U+ZDbDDkz2gQ8LSP89I8bliarPgTwxniXSnKAKz25pIp6rjHR4EACRk7mudpXhk=
X-Received: by 2002:a05:6000:4382:b0:3b7:5985:51f with SMTP id ffacd0b85a97d-3b768f060d3mr7168778f8f.44.1753395514940;
        Thu, 24 Jul 2025 15:18:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEW9Oz0ofFy+ZXrphC7SrO746cspr60p4D8s06ek8+rLNxlA04Z1UWxrgzuJqYYf4J4/s1SJQ==
X-Received: by 2002:a05:6000:4382:b0:3b7:5985:51f with SMTP id ffacd0b85a97d-3b768f060d3mr7168766f8f.44.1753395514391;
        Thu, 24 Jul 2025 15:18:34 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f01:5500:ba83:3fd7:6836:62f6? (p200300d82f015500ba833fd7683662f6.dip0.t-ipconnect.de. [2003:d8:2f01:5500:ba83:3fd7:6836:62f6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705684a8sm32671285e9.26.2025.07.24.15.18.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 15:18:32 -0700 (PDT)
Message-ID: <1bc456a4-30ac-4e6b-8830-e7c86f113f9f@redhat.com>
Date: Fri, 25 Jul 2025 00:18:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] mm/mseal: update madvise() logic
From: David Hildenbrand <david@redhat.com>
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
 <ab45d2f2-a34e-4ec7-8a49-03d166e6215a@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <ab45d2f2-a34e-4ec7-8a49-03d166e6215a@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _pIQo8qodjiQrUsbVIOaUd4mFi4DT67drdQWCSAOrUM_1753395515
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4ED5620003
X-Stat-Signature: ozoxabruxixwwydtbhat1krzdeh95zqb
X-HE-Tag: 1753395518-247238
X-HE-Meta: U2FsdGVkX188Bj87GUJg3hK0SDV6qKjUvzZMS7i9ZNNjQOfjcxu0uoTiWbVVFj1+GjUD+B4QKk7tLYi6XrecB+ygKYOub9txCcMX8D/5zQAYt2g+FYB7tYZeFA/8uvyBZlOOyW2nxT7Cx14a59PMWDlb0ibeysQRTSHda4VdZW/1cI4nCNPRBiX+Vi61yc99LQrpgxKZ7OVQDrJJCsDi0nolgjsYofUel8OZeIXDkyYXZd74lq2hR/rZ5cgh5jzBOSjrG5wO27QsOjw1CFb+v7gZEX7kHa3/tqlx9rla2oUkuQZQCUOfntILCOVOgu1pCEkz+lBOuGV3QH8mLgEsKJ/PAfBgI2+6n3Q97TCcTnsl7GFE5aHj2ELHC0TcucWQcU4jsvbdzwt1fW+XK5E1uCgH255HT84ry89gC8X8haU8ozdIFCFgj6MjhEGwyTXiExYa6W3qaRFlVjf7K9oiGFcaAT8fmRvQ4+dCtwzMKsL3JgWNX+EUqRjituOpPW3UXEDq+GeFJYb0ytWs7XaMZvCpvQCEsIdrGRiXJ/zXfgs/zSjYZEOfBIlMZIvtJ1jS/FyqRIH7mIrztJ7QrmUvK2U5J4n3yXQKI64uIly+NIZBQXSqnytASFIZ3/B46p05nIZinvGG7tVn/xUZcw+QJxCG5SHQcepo8o9xqKPSnjd8eUY3TIcxoFR4edu9XWxCZbqudsWpk5jISiSW1cPJViDgXMTqNZOKKNoxw37PShU+OcUVDdJ4jdHaromiyoTl3rXMKWXHAfscAWnkTlR7NyUE2Lu9TcfxmjuhOXIlpz8UKwFynzIRY9Ay98W+cbPXVDUdbBLXPm/HUCjgG8plWNhm2/K6wcUAvbjsw4j+zespYwoKMTymxBpJh1ZJ/B5vEaCRsAdo48XDGiMZfhp7GKzSdHgcN1bOhQzDtENzEp1wuBsjDKQkXen0dv8bCU5E6Kq4OmAJ4QBkHQrZtLG
 WvaYfLTn
 2SPMTuSId4068YqPglbINa76vq/oKEF8STqG8t5hWdQVp7xXrUazK7YApoGgzzQBG7lLLuFomy0Bcr6aR35f3yUueiF1d28PxFYqkPsv+jFUHfV0JZdGZQH1ON712ScKfbJgL34Qk2nKnezLcuVq55tC7iLPd96JnU9iZec6J/luXthELJG2U5ty01jyoOOlf4k7/62Cxw6eFq1hBVO8nnwheYwfabXiAECmGsj2yBf5Kq2hC3hrJ9kEckxguLhSasqOJ0Uuoog3+3MgHfREld58Q+KrAAdHGUF7aRU2/WvGANk21u5b2RcInhd1kG8BxdYRUxDZmFgiMTHgItUGqzfAkRlCsuC+Df/WiQ7UdOaLa1l1Y89jsuGsTjVDUPRaR7BeH8sGDORc79VH60E6PEBg5o8t2spjyNXmKWdYY0Djvyubr2soL8Q4wWN/mux55hefuhrJM9crefuERC8Z71qd1mA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.07.25 20:56, David Hildenbrand wrote:
>>
>> To summarize all the discussion points so far:
>> 1. It's questionable behavior for madvise to allow destructive
>> behavior for read-only anonymous mappings, regardless of mseal state.
>   > 2. We could potentially fix point 1 within madvise itself, without>
> involving mseal, as Linus desires.
> 
> IIUC: disallow madvise(MADV_DONTNEED) without PROT_WRITE.
> 
> I am 99.99999% sure that that would break user case, unfortunately.
> 
>> 3. Android userspace uses destructive madvise to free up RAM, but I
>> need to take a closer look at the patterns and usage to understand why
>> they do that.
> 
> I am shocked that you question why they would use MADV_DONTNEED instead
> of ...
> 
>   > 4. We could ask applications to switch to non-destructive madvise,>
> like MADV_COLD or MADV_PAGEOUT. Or, another option is that we could
>> switch the kernel to use non-destructive madvise implicitly for
>> destructive madvise in suitable situations.
> 
> ... MADV_COLD / MADV_PAGEOUT.
> 
> I am also shocked that you think asking apps to switch would not make us
> break user space.
 > >> 5. We could investigate more based on vma->anon_vma
> 
> Or we do what sealing is supposed to do.

Sorry for the rather hard replies, I was not understanding at all what 
you were getting at really.

> 
> With the hope that this sealing fix here would not break user space.

Is your concern that something (in Chrome?) would be relying on 
MADV_DONTNEED working in case we had a MAP_PRIVATE R/O file mapping?

Again, disallowing that completely (even without mseal()) would break 
user space, I am very sure.

Whether we should allow zapping *anonymous folios* in MAP_PRIVATE R/O 
file mapping is a good  question, hard to tell if that would break anything.

For zapping *anonymous folios* in MAP_PRIVATE R/O anon mappings, I am 
sure there are use cases around userfaultfd, I'm afraid ...

-- 
Cheers,

David / dhildenb


