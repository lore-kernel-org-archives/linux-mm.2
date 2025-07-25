Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A638C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 15:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DAEA6B008A; Fri, 25 Jul 2025 11:48:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 964B76B008C; Fri, 25 Jul 2025 11:48:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 804DF6B0092; Fri, 25 Jul 2025 11:48:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6C1E76B008A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:48:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D7EA1607EB
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:48:36 +0000 (UTC)
X-FDA: 83703219432.28.E27773B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9A680C000B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:48:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZW8quNII;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753458513; a=rsa-sha256;
	cv=none;
	b=CpcXFk0QW3/XVVmBVLlB4cJrPpN+z7ulAtf1GsiHA9kjUAmd/0AO21MJ6riwnUneGBwpbi
	+D2Dq1HQx57f5WxYDB7/gcguIshN7ZC4MBPlSaZkKf8zMnxuXIQefduA0EVYRVHH7tnCPv
	29WDdvZ5lNZvOUUTCA21SfmV4fb7Df8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZW8quNII;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753458513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D43V9UfnJ9beNW4Myc909yITG0QNPmMDe/++TWeD5tc=;
	b=kZanGNvdFX/MqDGlSBDrOiazXuRZxDj0JH2DWZQ/mY0IjMosBFernB+8K3oUNSb6ed1wiZ
	2Sj1UkMwwRUaseS9qOTGHVT21zqBa67rDfpknZPZlKLPZYTwq/a3Ivnb1SqBLe3YWwKyiD
	Y/rhg8PHhN4DfS8Csruo7WJ1UgSOW1E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753458513;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=D43V9UfnJ9beNW4Myc909yITG0QNPmMDe/++TWeD5tc=;
	b=ZW8quNIIUQysBZ3h7Au8BjzVi6FvlD/JebbKK178/RNQf/QxHeaAL8EADpX8X8IkZWmvJk
	SHvPMB5tI/bQFQNFPRTMJW1cl6hCMv1T8/PT3MHX8+HNStbpPdFerGEX2wL/0XfgA9q02k
	2YTawilpINkjM4kPBfkamxedyaLE42k=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-62-UWuDBGzfNt2mnQA_L-ePpw-1; Fri, 25 Jul 2025 11:48:31 -0400
X-MC-Unique: UWuDBGzfNt2mnQA_L-ePpw-1
X-Mimecast-MFC-AGG-ID: UWuDBGzfNt2mnQA_L-ePpw_1753458510
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a4fac7fa27so943014f8f.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 08:48:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753458510; x=1754063310;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=D43V9UfnJ9beNW4Myc909yITG0QNPmMDe/++TWeD5tc=;
        b=hF3hIG9lG2EmZTymldmH5rDtfAEIl5Dtfshg+pxxnu/g7k8+0rVs2ZQ7KT4m/Ti6xL
         wcyjMBPhE0CLWP+qvkCyctQoYUIXRKTNicRPHBWGXDnwyIxY8l2mY1xY03iCS6Ty8ApL
         SqDwVLPnH8Ie02A14EpllgwlqITowsgltkHjAFJCww6JEfINgyPHISQqoZcU8yYLW8vl
         PMiKqwFJoZXFl/Yxbg7Eg8KT0e+zA5R9sxftP6hLPDdoLbN7is9RYIE6oy8nWA/YWgd0
         vhmNaIl+BOuPkViCKzo6mVwtmgEdJYzAP3bHe/4EPXS0eOdknPa1mpPiqQtIOAP9HkNE
         vu5A==
X-Forwarded-Encrypted: i=1; AJvYcCX1yEOKi6IQcGqhHEvTHwewbttsJbZLhIfSmcYKjthdIN3dF82QjEcss5tFSBzFMF+VEgyB0f9V+g==@kvack.org
X-Gm-Message-State: AOJu0YwwSN7Qnp0CpTymu5Z53/GmkBGUzyk1nYz+wRf9gAV1AQajrNYq
	0xN3diliHIsYVIwr97WBIBSCxr+N1IUuN87N38Ac/OXdg2G6ft3BerQD8gD3CwAVV/Jyxx1efZh
	MeY/4sMHYrJwnAa4qVp/+5YYj+DpXj4dsmzQpRYTbxnFpGF9t+bCa
X-Gm-Gg: ASbGncvZu4vS7aEcHEddymrTkx/ULPnppztuqSW4MpqKgFVYv4GGE74EYajUBRXYXw4
	FhNX1k8C4VfAaqfA2Avsyc6wRkwysn4nhKvQQWYSYh/u+f/4qL1xSD28VMuAzU0OsHTAVhj2spi
	Gw4rC2rPEt2SLvKoNhgUVdKQIbsYBOiUlkBXs7fRKbcYXM2T7Xgi6z1qBVQ3+eLTtTOghP9vKo5
	E4SQWWivV5lmwZyoXTBeHs6uIure3Y7AYiMWmXKF6fQC5/le44oUEbzXEJ2/5n2D7zGK+Rfu2e6
	ViAUKhSP1SFkQslhNC717W1/zaQocvAnJW/5WrZOacOu9qq1pS2uD9oJeOdyH9SY8WVoStK0WhZ
	p1xz0VAUjO25MUGZHjFB8zx5p7oUee6+9sYAXJ6CtxRH0epRkDV/UT2hFkyAtW0kc
X-Received: by 2002:a05:6000:2313:b0:3a4:eec5:441c with SMTP id ffacd0b85a97d-3b776675e67mr2256716f8f.47.1753458510406;
        Fri, 25 Jul 2025 08:48:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0ZAVKFUqQOgbGeFysjtfTBUiHYA1Yhzb8si1kEq6UhT0fzhe8mrkpTrdH4Wvrzpw/yXF7DA==
X-Received: by 2002:a05:6000:2313:b0:3a4:eec5:441c with SMTP id ffacd0b85a97d-3b776675e67mr2256681f8f.47.1753458509935;
        Fri, 25 Jul 2025 08:48:29 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f34:ae00:cf93:b0dc:6bed:abc? (p200300d82f34ae00cf93b0dc6bed0abc.dip0.t-ipconnect.de. [2003:d8:2f34:ae00:cf93:b0dc:6bed:abc])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b778ec2b63sm243491f8f.36.2025.07.25.08.48.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 08:48:29 -0700 (PDT)
Message-ID: <42c65168-1be4-4c7d-b459-4082574b3ef9@redhat.com>
Date: Fri, 25 Jul 2025 17:48:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory-failure: hold PTL in hwpoison_hugetlb_range
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: akpm@linux-foundation.org, andrii@kernel.org, avagin@gmail.com,
 baolin.wang@linux.alibaba.com, brahmajit.xyz@gmail.com,
 catalin.marinas@arm.com, christophe.leroy@csgroup.eu, dev.jain@arm.com,
 hughd@google.com, joern@logfs.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, rientjes@google.com,
 ryan.roberts@arm.com, superman.xpt@gmail.com, thiago.bauermann@linaro.org,
 wangkefeng.wang@huawei.com
References: <20250724090958.455887-1-tujinjiang@huawei.com>
 <20250725033112.2690158-1-tujinjiang@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250725033112.2690158-1-tujinjiang@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QjtOkfUh89Tz3J4xt9mkhlzOdoaNvM5EkqWTYMdOOY4_1753458510
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9A680C000B
X-Stat-Signature: sad1ifi31b9htgtquw3xdy3ujd6cfnq1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753458513-307480
X-HE-Meta: U2FsdGVkX1+WLxEx4B5R4Y4YnxO/W4AX5t7WJGuHNAX8E4BUMoyqiIA35Iwcrx3EwH4gcOxgOjC+SrAGj2Huc1gavdbPwvXUdu5vCXY4JObWGeqYtpN1J8yF8LVOS7iKg+p5XCgr3Q9SzTAp0PC+4ShmQngcTH63ECtXNVwuXheAb8p5eYlu3nUMF2WT2ic2tGo1BYzcB0JGWMsD6i04BdzfeXAPkB/a61cp0hyI+MAB4QxgnxrgvW37G9iFI0M4B9ran3U6Sv5aUlG/il0XqpOtuE6y5FgHjJhT2ED9he7tFu+1OhM34lOJbmzIfXpy7KDxjVVcz/o/d0+3RwucvFQgeyzHaC146KlplF8q8M8M+NHOX2piEBejCVI9gl2ngIC6ErxMdbuFXN4f7RUTy+zxULomJgc9HnxfDEkw0DH//CPYDWByut544on7+fprH6kjxQcoUfkDRijJvO61MIJ+BN3sRQXIfR9AK5sdaI7MSZkr3tKG1tDkx+OFJTqId1gDMkuxRWUZv8tgsPLx9CFkTxFjqaeW0lgqkH2dmk62qCu8S1gJe0cIlwoFbu60Y6pxo4iWdmxeqx82gWFLf16tw5CZsZUj7b45nm1KdF0/7GiLZMzzU87TeHXjLAPQui//b6fgrQTe0lk37A0ukTTLo6zQ7JZaV/EerKNmzto4US5tPKaxUsGR0QTWDW8n8/s92gE27SVBbLjf3fX7pPxFj6o3BRngzugqfbF+xB1Mh3l3B258TdkOVpXajEY8OLsFNhr0Ga42VnPJ2mmVgyguJwffrWmAAT3MnlJuErkWaNiP9tnW6it+nG4cZgjBIdSDVx4FDPL0P7uHBZWnW7T6RHzKZwzscuQAXEEc7Raz+mUuAxx7eq7mKa6HTAvzFWNgMrzUq3PVm8upoSV1bU853Kaqj52UG6tcOIGNZ32i5DJS5Tsub7vwlDKXFw7LT5sNaagSbcoDGlwDzhz
 01172s2G
 /3uMexe4urpbJm44O6D3YwpNLdGtcmL36sy3T1+N9hoz1QbdZC7MGJa+rHuEzM6nYUNdC2KxqJUId149BWyCsDsH8eJh7JMp1qr5nIaK3swyiSCCpVwNJkN6+V7PMhXlRyRwMaucUxleb1WoEKmWZJ/6Z3H/ey5xa3aV7mCW0bTIxeYaKCxRFFlRnWYttiXW+Xa5G/CDa4cEebxRIB+gNXPf+Lajv23/wcy5lNdHqnTUK2+AOZCz3aNylhNJIWNjjoP9dMgi32M+8XPl0c9Kz6tsu+6N69ya5yAcBWEBaMbYI2/oUAdT3ry3m9JHirLoe7z2zA8KkgBP3kFO6tkJ1j7sY0s76xQHwJUOQ5x58PV+6174LfjATDM1G8YuqiwXVfjkntTAaQ84LskHREajwePzHlUiptMW3lrkvUkiD6NqS35pJI0gP4SShPw3nKmrFZcoKHGF2D3Iq4pURwIC4NGr0teRCfwX2fbTDWn4pOCApiu5wTUHB50BKmBoxTtWUewTZFkcqxZpQPY1JOEoqP2qdFGlsUH80p29osSLbh4hwbk75H3i7QDepLnzVu2k9ZPvof4zkFyzlM0TlUvWzID3X7nPk4/EWN3t1lAoewVyLlrzBqlpTLPIl+dSEHDpqOW/l1whdgdk7jU+0QUX9qQHhPGRdw4v3UYSr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.07.25 05:31, Jinjiang Tu wrote:
> Hold PTL in hwpoison_hugetlb_range() to avoid operating on stale page, as
> hwpoison_pte_range() have done.
> 
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


