Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA4CCA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 07:50:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8B056B00EE; Mon, 18 Aug 2025 03:50:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C62866B00EF; Mon, 18 Aug 2025 03:50:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B513B6B00F0; Mon, 18 Aug 2025 03:50:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A42576B00EE
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 03:50:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6D943C07FE
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 07:50:20 +0000 (UTC)
X-FDA: 83789105400.28.4307718
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 05A4C40013
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 07:50:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NHBHMuDJ;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755503418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bFkLpPVTfDfXaiDMBc53qFxi+JxlXWFzy90aTQ3R3F8=;
	b=lLBpYz9G5UIgCIA78pCI5jnv2OuXETbUAkwb3bqKEk7BbSKUFWiIq2siVc7v1Sztq3IGyZ
	/0FQQV95BE+IUh55PIosFpyRN+t7P8oisFk/B+rii/udDgz8WKkDhMYL5UV+0eG9/m/RIr
	JiKNL8gxoy7EmgI0e0SP+A0bUsl9Emo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NHBHMuDJ;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755503418; a=rsa-sha256;
	cv=none;
	b=3hPOn1YGbLW3NwbkndC9uJ9/OM1Erk6x+zu9E3q7im4uwM0d3NnQentMpPLAQOKSOK0e/R
	No7LqD0JQB+TKjJVePVMlYQ5DSHX/XmRzaxiOLSKiDA7wsL1BKji2PvwKw3CZC7MlqsQ2Q
	baGdVM+HDr9820tsAVnKeQNcxpOxcLA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755503417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bFkLpPVTfDfXaiDMBc53qFxi+JxlXWFzy90aTQ3R3F8=;
	b=NHBHMuDJSw9HZlpE3ojFqeRAk8YXof6nhOhXWmBoqzXLikpxWbnyAk2MaBbisKLoxzmTW0
	IqOw6Sh+M9JFomtzRry19xSPSBZU/63HNr1xnymzOpByCP2tuA+hykTKkM6nx1HVNYeB/n
	cLvihmGdMq1ZrBXuM7H3fIV+p8pSCjw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-Cbx6Td4EOLyjDMbKyun6XA-1; Mon, 18 Aug 2025 03:50:16 -0400
X-MC-Unique: Cbx6Td4EOLyjDMbKyun6XA-1
X-Mimecast-MFC-AGG-ID: Cbx6Td4EOLyjDMbKyun6XA_1755503415
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a256a20fcso6276085e9.2
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 00:50:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755503415; x=1756108215;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bFkLpPVTfDfXaiDMBc53qFxi+JxlXWFzy90aTQ3R3F8=;
        b=MGFAnsK41TvbAPJyzAPgTNLiFMWqW/CkJ8vtPv0sAKUyR/QurPxKmW9NtzHfqEbHT+
         ftj1HjsXHpLzSJaI4H+KQXdjF3+O7Q1cnaEBQXQFWGlYMxRUOxAKvXuMFsFVrpxCzYXX
         +CWxyt8XEJKX5klh5iN2sAz65Xj6qTx2rbvp+jNbj0yfDAfkmDx9iTFolnNUcD08B4R5
         b16lESp9W+hgj3WaLhS4EmmIGDdEQxWtLqV1ggsGyGaXaloWtmnhZ522qdc7QHfC0VWU
         7rGniJyH4cqK/A7aeBioGnCEPuGMNAW3bPqKFv9PdfozqKEvsH1Hsqj2KfVtzusDxdgI
         y/BQ==
X-Forwarded-Encrypted: i=1; AJvYcCV7/dNaCiX+nex+HlTTiXxUqSDzpK0xUTttXqxrrxHcGA/8+fx/bpXDsandtjVUqWi2GNCHHnDmGQ==@kvack.org
X-Gm-Message-State: AOJu0YyxnXb8q0C9KsDfKrO7L5MmNCjd252v/tN45s33nOhKHx4gfGwQ
	SZlj5EIEYAPSl6t7Cj24z8CIbPO+R3Lwp1gvt+l/3zbn1Y7dJus6UEOgkLxPpspO5QecMcrcli2
	QGRV7GsUJRxGR7a2dkX1P5gLgXUBNdTtXYY9QdC8IyvCdeWipkbfX
X-Gm-Gg: ASbGnctzTpjnsveaAD7ea7U22Ms/EI891QiNXJcKXJySCPppJYOvNHK3ALeUEBM1ATa
	8VI1Tcq9GYVbWFY3u8VeKL81VkaQu2yiVWSgjBHo/s8JDI8eh97QIrGr8hGHIiJ5IZ38N6KE59x
	dGlM+tixnbOGLuqOMfgbwW9HxKhYIBkPAKfU7cBzErPNEkCyX+cZBM4zVoKLV+dvJjtpjwGq6LP
	/aSr9kHg0dFAXaUaozfOrAHQAGQFo9YvZXS9Si+GJIXGr5pkncROX/nv2z/YN2e16Mkxo1AxvPI
	3YazWG0LzS7XFf+W0Mil6VgyYPySC+fbw5FbQzNLlyMCBJon0EKs171qBR4gbvce0ptrxTX22r9
	WwYyXBQl7XKhEGM5fZ57ZtD+MFMdFFm6NCPuYSEjtBVW+K35UxpQ5Bquqze5BXo1j
X-Received: by 2002:a05:600c:4ecb:b0:459:d3d0:6507 with SMTP id 5b1f17b1804b1-45a2679f1f3mr53181495e9.32.1755503414685;
        Mon, 18 Aug 2025 00:50:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG5/ZkYd40NXxBUsenlW4nvTNivFh4cXL5D6Uw+nYUzKzPp0UEOmyZASZ3TdBetNcyeNoqKUQ==
X-Received: by 2002:a05:600c:4ecb:b0:459:d3d0:6507 with SMTP id 5b1f17b1804b1-45a2679f1f3mr53180835e9.32.1755503414096;
        Mon, 18 Aug 2025 00:50:14 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f22:600:53c7:df43:7dc3:ae39? (p200300d82f22060053c7df437dc3ae39.dip0.t-ipconnect.de. [2003:d8:2f22:600:53c7:df43:7dc3:ae39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb64d33340sm11975742f8f.21.2025.08.18.00.50.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 00:50:13 -0700 (PDT)
Message-ID: <72704edf-7b6d-4953-8d78-c998362acd0e@redhat.com>
Date: Mon, 18 Aug 2025 09:50:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 mm-hotfixes 0/3] mm, x86: fix crash due to missing page
 table sync and make it harder to miss
To: Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 "H . Peter Anvin" <hpa@zyccr.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Juergen Gross
 <jgross@suse.de>, Kevin Brodsky <kevin.brodsky@arm.com>,
 Oscar Salvador <osalvador@suse.de>, Joao Martins
 <joao.m.martins@oracle.com>, Lorenzo Sccakes <lorenzo.stoakes@oracle.com>,
 Jane Chu <jane.chu@oracle.com>, Alistair Popple <apopple@nvidia.com>,
 Mike Rapoport <rppt@kernel.org>, Gwan-gyeong Mun
 <gwan-gyeong.mun@intel.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@linux.ibm.com>, Uladzislau Rezki <urezki@gmail.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Ard Biesheuvel <ardb@kernel.org>, Thomas Huth <thuth@redhat.com>,
 John Hubbard <jhubbard@nvidia.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Peter Xu <peterx@redhat.com>, Dev Jain <dev.jain@arm.com>,
 Bibo Mao <maobibo@loongson.cn>, Anshuman Khandual
 <anshuman.khandual@arm.com>, Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org
References: <20250818020206.4517-1-harry.yoo@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250818020206.4517-1-harry.yoo@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: T9OG7TTtuVMy9VWA6VInRVHkaVJDs0qhy-ee6fqwv2w_1755503415
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nwa99kj4ge41ik43pncy3t7rswhq9389
X-Rspam-User: 
X-Rspamd-Queue-Id: 05A4C40013
X-Rspamd-Server: rspam01
X-HE-Tag: 1755503417-229631
X-HE-Meta: U2FsdGVkX1+KYrazSe6DhypaqGQoUnADeAxnCoBEb8PDsKvfyLOBuLVuS7DCBQAh5SGrraUNArT2BAtTX/tgi4ZC4oUVBNNO0fwjP6gP7qrLQhV5KdCBjmUE1hG7TYsGnTv3iuufDAspteNWiTCXoXKVTVCou87fU0fVOMl0LTBzNAAGOjODC5fhBCq2zU9in+RukWor1Opa93OueABTQf4mKI1CW8pQzSiZb9XdJup7KeZ8s/DTuFVV1XvdnCk/ZZI1DCGFZZWotwWGkdhVqMKhU377Kh5BEFcEHgxnhWwjCtU/hu1A2uHW5G4Drvy4UQqxKRPoWG3HE988bTiqml1ZOkO89UlOYfiAb0mbVigSCuBL0CKPqjvo7vXnOy+1K6tJMqHbOK0zS6T5QjXAM7vZ74A03AfKfFRwQFAqu3IwrdY4I3VM4F0e9g1PE1Y/xsbCk8kHK5faaDSN98yx+vnzGsPpevH2hUn2CLHR9DjeTBESmYYJcPFYs+GX77kja/xfc/vTudlxwQ1XzkHEEBsFsU82LZNBYQ+4/vlHUxmqWcqp89kLdpqfVLa7D0oQIhZWrtKMCxEoPiIlYVyZ6NllfN81IMVLcObU9yVZqMIzy5/CdswAZgvdKZiS/UQ+KZeTfWEhsY5h1oMxJz0hkVXX6e6d6fBYUBGgXNThF6a4Qe5I+bIyJtyUwT/q4X3HowLOWN4xfzVd1Bx5IGyVNr0AYHGrfPRJRDqXygkQCspA/2FoZPxuYIA0WoIlmJS5T2A1RyJ2ckJLzhHNYa5yzGorHVR1CcE6NXMAognUeDUJeC+2dGqdgJJsZQlOPLOaYW6FYgv1dkta9JFvPylHKxKcCDCTI0bYFIuzgpT/6ttU2LgSu1m8R5Z/fP/Q7woGJl6nErKh4T6TvzuvhrCfG8A+9xZ871S+BOKw7bvku/itKN9UHXFUWWUNqT5WBnNPi1LMU9sY1TvgHeymZUD
 fW6HIxE5
 qZTFJuMr4OSgfiTHq8BvSFDitoLx9EtitBqvyFoBnp5t2ygNnBdfkZIlVZeDfzLhTuTFSbTcfZQA3oY/c4JI2fzX6Wo79YCr75UI4/W+VU33RgHWw2+MqGnwWmMZsA0slUw4MRyhtLVjIyzR3fUNXpMG8SCbqe5+tq9+aJ5hH9VmnOYXsmPVp4d/o+14EQZkN9rGv3svJ+3Vovd/5s8gDjXmz4ccphKGcPxZOqOElImgD0unaCTCpp9K9Mm/V9wyt6OQvVvi0sL2Jvr1Zbz4lpQAQOBrtlnl7iS6GMOS6VX7t2QCA1AoGqoGMSsGLMmwp9qFnfylAib5A7+KHCSP6GqMw8VTIKMPOCyKIKip4MFN5BJoxmTflqOybmziQt8fmg4U9F/x70/cHv6v0z3mlGrfQm+IdtU60tvAErtFCZCtsXEbJAwe6r37KGyb6J38dzE0+yMmJcATBuk+ruTyNm2x1WS08d7OhEdpnXmvz9EKz9lO7hQe+q3Ipu171dZOS9f5NSEUfJ38/3Mgh20nZD32H6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.08.25 04:02, Harry Yoo wrote:
> To x86 folks:
> It's not clear whether this should go through the MM tree or the x86
> tree as it changes both. We could send it to the MM tree with Acks
> from the x86 folks, or we could send it through the x86 tree instead.
> What do you think?

I think this should go through the MM tree with ACKs on the x86 parts 
from respective maintainers.

-- 
Cheers

David / dhildenb


