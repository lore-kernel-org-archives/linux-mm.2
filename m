Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 617E2C87FDB
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 10:21:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3C0F8E0034; Mon, 11 Aug 2025 06:21:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DECDA8E000A; Mon, 11 Aug 2025 06:21:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB4448E0034; Mon, 11 Aug 2025 06:21:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B3D8F8E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:21:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 87917C07A1
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:21:35 +0000 (UTC)
X-FDA: 83764084950.08.17F3392
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id D67098000D
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:21:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W68o7ghb;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754907693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LH3iRZK7IeDS4TzLmHxpdhHsh5vYYAvHRC+uGiYwcF0=;
	b=sN6XYX5Ct+XTC8mpTmgdmnVzXccoxNorXhmMlH1JiA0yOEW2EMUKlNffN6FWpKk+oygDSE
	9woU4OHzGCeCM0R2a2OjSAZpCdqMvp1dhIlkbZRdjtT6pU5H3JXB6aUns/cImXdi8R5tBz
	oNAB4oZ4QwEK3ils1JsM3LpQNVUQO80=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754907693; a=rsa-sha256;
	cv=none;
	b=H2n1Ebyiv3AxRAfzFD0pNurZ8Wnptgjs06OxbRup3iK7vJHmfvOpD3SqbOwtN58lqd4Nif
	EEuyLv8LL+3ANA5uoV1y45oXQ6/Vq8uWfM0JGM/KawzfGeHvLKY5ZO8vb68V43S2BnwJ4x
	qAR1yuK0JpM77WOP/CBf0Iq+bBuWygQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W68o7ghb;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754907692;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LH3iRZK7IeDS4TzLmHxpdhHsh5vYYAvHRC+uGiYwcF0=;
	b=W68o7ghbQEWRA4oblSr/KJW/UHS78B2odqWVmlk6H94Er1B/Tq/mzkBBRXr3Xhv1SMwbIQ
	lEQGoG6bOZeFT3ftQxRxp5kGDnBgq6W5dq/v+lZYO8l5MwXzjYrhkX1jlaxW4wcIDLxMgT
	XygXPCOWojzZk5iU43klbro19uJtges=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-_xQZ_HElP1ysJ8fNuVROHA-1; Mon, 11 Aug 2025 06:21:30 -0400
X-MC-Unique: _xQZ_HElP1ysJ8fNuVROHA-1
X-Mimecast-MFC-AGG-ID: _xQZ_HElP1ysJ8fNuVROHA_1754907690
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b8d5fc4f94so1738205f8f.3
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 03:21:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754907689; x=1755512489;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LH3iRZK7IeDS4TzLmHxpdhHsh5vYYAvHRC+uGiYwcF0=;
        b=Q0DU77cxSM/hDzLHMbTwnigoKVtM71hJcD7m9omcpKfOcq2oNoklLW6kVXFwYh1ZXs
         T8DH2sdPJySGcHVW7CJEuGuO2KDBckzPM4OHi6h/xzSOobKxbk3zWXja9hLB6Ig7Wy+B
         jGZtaNrU99rwHhDA3pKoUjbv24m03RzgUtlksZhiZW/h3eWBDWUO+CdvB73falpIEqDw
         Sm2dakXLMpLRyYxEYbNka46fVf/BG9SgP03mWfU5LjLqzktoKdTaV6g8WUsX9c2L4z1C
         664VogRtOV5tFFeKEpe+pjRc4xthb4bSVvuCup+BEV1/AXLwRMvtv038mrZFNasMpoRs
         BgiQ==
X-Forwarded-Encrypted: i=1; AJvYcCVFmz/+ey87ZZ97wDSav6uXR5oDI+i/hr53Cg4fcm1qhulVFf8HbQjqWJQE1fyRTC9LLhAXzDm9xA==@kvack.org
X-Gm-Message-State: AOJu0YwtpUT2Cl8vLybPQ4fqvv5WpanKektlnhKsagRAUwfISU6/A32F
	VF5uQcC0bZPoF1cHgARWfr1kfFKr18kuVNZLJl0vancuD1wF8RXarrBdLp8zh0VOWxuAXY6zcEJ
	qJxahfxXevzpw0BOdxab/YftJlHb+v0h2bpxAbXywdWIIw1dhlnMJ
X-Gm-Gg: ASbGncsfzm9UPyhp7DvoqoFJYq7IS/QjtlxNG6i8LWY0QGZSjxZ38M60xyzV/Cy/Z5/
	c6ZTJeEYNonQbSRZj5HdmNvh+OVDaiOkMrDBdEJtpck63KwVf4LatBFLVBhe5oQPbf6+wX7ykBB
	GBwEIZsBP5ARTqm6ZvKw0pQ3WM98D4+o1RsZsGnYwFgkyvbxf63qKwF27ryUN33GyAjsygKqIJ3
	RirqjZPRf/U1xbut+Cbyb6LZsszvw0ZcfZV41c+sGbdV3b6DVNZZmtkDA9zfWjDnlF+buyY4UCN
	j9+1xcUK0iWCFEAVHsK+MKlCnJAWKXC6I39pF92o3ZfvtqAJfuwgSXhTEDscbKK62bK7S2w+ZI2
	e7HWXxgzvaa4NXbS6WpB/8g9rUqXvTHh8DvObWKowJskGRu0/eFmR4i8lwWRxmfEcyCM=
X-Received: by 2002:a05:6000:4383:b0:3b8:f887:c870 with SMTP id ffacd0b85a97d-3b900b3243dmr9367037f8f.19.1754907689601;
        Mon, 11 Aug 2025 03:21:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFe9BiKofT8pklvpbhpv0YQsdaHNqXbde6OX7E3hrFNquhTSOBxDSVsC4PHUt1yybczkNcsvQ==
X-Received: by 2002:a05:6000:4383:b0:3b8:f887:c870 with SMTP id ffacd0b85a97d-3b900b3243dmr9367002f8f.19.1754907688990;
        Mon, 11 Aug 2025 03:21:28 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f06:a600:a397:de1d:2f8b:b66f? (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459c58ed07fsm345483105e9.22.2025.08.11.03.21.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 03:21:26 -0700 (PDT)
Message-ID: <57bec266-97c4-4292-bd81-93baca737a3c@redhat.com>
Date: Mon, 11 Aug 2025 12:21:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/5] add persistent huge zero folio support
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
 Suren Baghdasaryan <surenb@google.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Vlastimil Babka
 <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, Mike Rapoport <rppt@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Michal Hocko <mhocko@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, willy@infradead.org,
 Ritesh Harjani <ritesh.list@gmail.com>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
 mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de,
 Pankaj Raghav <p.raghav@samsung.com>
References: <20250811084113.647267-1-kernel@pankajraghav.com>
 <hzk7e52sfhfqvo5bh7btthtyyo2tf4rwe24jxtp3fqd62vxo7k@cylwrbxqj47b>
 <dfb01243-7251-444c-8ac6-d76666742aa9@redhat.com>
 <112b4bcd-230a-4482-ae2e-67fa22b3596f@redhat.com>
 <rr6kkjxizlpruc46hjnx72jl5625rsw3mcpkc5h4bvtp3wbmjf@g45yhep3ogjo>
 <b087814e-8bdf-4503-a6ba-213db4263083@lucifer.local>
 <lkwidnuk5qtb65qz5mjkjln7k3hhc6eiixpjmh3a522drfsquu@tizjis7y467s>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <lkwidnuk5qtb65qz5mjkjln7k3hhc6eiixpjmh3a522drfsquu@tizjis7y467s>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: l-5IypARMdxFBY5yqc1Yexj1QS7v6bugfgjLGxsq8Pk_1754907690
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D67098000D
X-Stat-Signature: 1eq3m3zqs8p497eqwobcmzt65eqbkij5
X-Rspam-User: 
X-HE-Tag: 1754907692-856197
X-HE-Meta: U2FsdGVkX1+RSWuB1PSwbP4edPk+31eB2u2dLYuKrENLEQ0YqVDCE0W0kI7R06+bcVrsncUvB13sQCP2TuPeRHLHNywFVBcjP7fXyUaPBe9OfwIrpv+o+J5Cki3ufvPgVOucylx7tdNHokDe7Nel354eokdxt/z5UhqUexkkPfRLlSNuMBcJDC8+YITh44w3WHhVtMBsugzsZw7rk9G3VomHvQo5DEkAAiBv+RLMwWcsAF/YRYXeEqCCcrMJCweDeW2RfWoz021JxNypj+XsaA4yMP5IDaH5qYMixijRsP45+kt2JH4rUyGii1+Ygfq69KjQtXbHkhVYdeBHWH8fpFjSUCOY0YCEH89GTHsd1GSNwolU7rPSsdELaGh5yDLurU9VEErvkQkHvuZa8i1iNH48xKLpWeZBMbAq+EkLiuXaJ6UKrGKve3VwYLY802tp5GjE+jQMmfbbUYtnCuLeWnGkTzFcpv0SpzTc3Axg7DIUnYGfkjSm29B3C6PjthvofyCubNnTEogLaSh9jd5dw/TJBl/Owklt7hX6Da9J0J1G5iZgWcunm1x5cMX2YJ7Ip1j2bPrZP/EjEg+HTJNohvBFsXfRJSGF4g6yutASNeB8JGfVKBv40kNireCzHgLTXf0tltr8Bvf4iH4h+kT1EkEkE82TFiWnMRdwYPjIku9E2+3cf5YG/NxlWMIl8QwxppZi3wIDPrn/avtwtFbo1U3A8lxeiKhFVTCcq1aRm9m4FwrgpgwKhYn339hyU486Oy+qzEvMDsVwkVgeTkZO4UvBRnLS3Jli8C6yx7GKJq+njykgP54Fn3eCzsMh7F4HBYK7nlE3LUtEK6UUdPATbGRVsiUHOrGYk9yhkz+50AwHkLj8U/Kg3JVsifvZ6GaZ2WrQM/mVjyip/Gcjw0Ack7fiJa9PMQqXDflimkZVd/0MyehN/EO35wax+7fh6Pbdlz/l+FzPzt8OBpHgJA5
 ob5kW6WM
 CLdyh711mYxjiO0FupEL5FqQ98KOFvBGJ4l1+YvAENeQ0UyuMntyWrKH0I57pmPPNS/IJSGnLxl0enCPnFEtMDROEyfPmCyRBlucjMTY74qbLSZOpGnTD5p02787TOpQieuuqDkW3emGdpMKjSvki3MyuwZxw1kucDwbg3E9+9+2m/2j/g5wBL94kGjl/3vnPuYOA4ZG5r4PX3auMjszWfaGZhjNGB8ICy0aTaH8AScg9KvcHIPLBba4AVP2xNOhBslqa1s8zl1IDZ2CFnYY9VNTwwYLkyyM78PHZXlHIrIa+BqQ65jbft8+HexToNsqRDlRuK0rH910gZ1zYUTkekZqdRR7j8n0gZTw70JMGTU5bvl4dbfTDAwzhDtqPcG7I1Lw6Yblaaubm2RkQihn4z3QHZGO0jhqn4DgSh2SZnvmv9xbKKmha5sWFvHQGzTbbPdZ9TG0zJylm7kgltzqz7bhBDsVm74t4AOx0M0OGa3magBg6PjULUe72Zg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11.08.25 12:17, Kiryl Shutsemau wrote:
> On Mon, Aug 11, 2025 at 11:09:24AM +0100, Lorenzo Stoakes wrote:
>> On Mon, Aug 11, 2025 at 11:07:48AM +0100, Kiryl Shutsemau wrote:
>>>
>>> Well, my worry is that 2M can be a high tax for smaller machines.
>>> Compile-time might be cleaner, but it has downsides.
>>>
>>> It is also not clear if these users actually need physical HZP or virtual
>>> is enough. Virtual is cheap.
>>
>> The kernel config flag (default =N) literally says don't use unless you
>> have plenty of memory :)
>>
>> So this isn't an issue.
> 
> Distros use one-config-fits-all approach. Default N doesn't help
> anything.

You'd probably want a way to say "use the persistent huge zero folio if 
you machine has more than X Gigs". That's all reasonable stuff that can 
be had on top of this series.

-- 
Cheers,

David / dhildenb


