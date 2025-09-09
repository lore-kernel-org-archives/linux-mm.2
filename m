Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DDAFCA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:22:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B0BD8E0021; Tue,  9 Sep 2025 05:22:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 660838E0001; Tue,  9 Sep 2025 05:22:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 528B58E0021; Tue,  9 Sep 2025 05:22:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 359278E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:22:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F3DA8C0448
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:22:02 +0000 (UTC)
X-FDA: 83869170084.20.99D8378
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9D1B140008
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:22:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HXMzpmxO;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757409720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yZ7mpSu7Vyx7D7KzsRAEX4kah9GPWTLG09gnV5krCYA=;
	b=qgM/mQLmXj4uYpabpiRcA/65PtX5CrYj/exCtm7kIz0x1+WLf2L1OTr5A3UMNIKDlp1pap
	1scfl4EJ9XC1UZ1XBeqjJSTOfzSptZwJHZX2AD0TirMzAvC/aJ8XC90yssQLoJ6oQp7VUL
	rQr4koepvk3Lw3G/Fc4hwzJyA2hcyao=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HXMzpmxO;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757409720; a=rsa-sha256;
	cv=none;
	b=LbZ28YbRkCzfrl36541DRWIGgVUKN5EyjkhzmbaYxkGdMOIbUpu3K5NqA1AqJhDNZ7WrO2
	oGVK6I/WpqH/j1amUsTOWQburEBDE0VtHsQnIljWcsDJLUSSaXF9oA/7zOUihZ1aAaze49
	6PH2jp+ci8tXOdbgjTJcOXRzuCY5gPA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757409719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yZ7mpSu7Vyx7D7KzsRAEX4kah9GPWTLG09gnV5krCYA=;
	b=HXMzpmxOTvAigGLsL8O/NthyQeVfpQF/Q8kAlpt4uK/BHZdbNKJCgzE0X+YpDZsSF0xDzX
	c0IPslZhRbu1BJX40o0cnS8euUi/hMijuQyPNjhZZzw5UTG3LvrzrqZ15MnLUsw/ad93gH
	Eut/F4887mrXrldhTP4IDLHOxi+rkVQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-54-H84y35WjN0qhuLmT_0PQow-1; Tue, 09 Sep 2025 05:21:59 -0400
X-MC-Unique: H84y35WjN0qhuLmT_0PQow-1
X-Mimecast-MFC-AGG-ID: H84y35WjN0qhuLmT_0PQow_1757409718
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3df07c967e9so3327345f8f.2
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 02:21:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757409718; x=1758014518;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yZ7mpSu7Vyx7D7KzsRAEX4kah9GPWTLG09gnV5krCYA=;
        b=Dg4frmIVejlEnIG105tyhNrVnJD7l9rqtEP1K6E8EteY3MMrALZpwOcyFxu6e1GNVa
         saK6CWoiEApmnPZh3B2DzHlF0PDxC8ikF9Z2gnlmBfQwMfeRP8mEbmAqhHkq6+8L2dXH
         pKm+wrLzkZmYGBuZI+DmzD0c3iWNBTabXUZT20/cWRTF8Cb/cdsrTO77OfTvTPMCfxOd
         id6KitfjQ7n33dTVFamLJf3JNl9RqvDAcmjjX2RcJhV8qBbGA18bz2GUy73mTmVFd2kw
         B8PUatrmHFVPkygMy6vPlJdrdTzZlpgu69mk77DwRV9xpFwIc7NlO7+I8s8O2IyOHw8O
         ntgg==
X-Gm-Message-State: AOJu0YyyhLza10GQGZFEZHvZZhykw0zr1bInhQGg3KIDCfF/dh1Wrm6D
	wWeoRzcUX7ls4pBgwwNK/m98EuqtWxw8ay0++MYf9SreRyCOpYANbYAXcY2V7yEbRxGhFp/YFAI
	CuX7YxdzLU2MLBhMARRK2zB+/bBp52nm4NQFiJF9pC4Qo1AMDToFj
X-Gm-Gg: ASbGnctwjiRLLdSoVtBNUVqboJds/VMBoyr74c+GRaP4JTPQyBtAtoboxIkELtJx0vh
	kl0vuD259hLOicZ1kfMniNFgWt4ry1/8LTj0hYMyeJJC84bbYhZhqOKNP7CyceK6DTsHmW5800I
	YS3jf5FeIud4AdqSglyCwNQWMswisCnxVsfxQfh/mCgvhp4Gn8ODGIBQudWE9pE8hw/EHUXLEAC
	1kYHbfyzWMSbZxSVknaKbV8MiMB9TUi7kGGn0rWbLSCCXhznTQJ6/XYk55P6mvtDVgdb6WzfwVF
	K6AeMuSOyUWAM4rb/fmFnItSdkMRD9B+4cmfXdPUxVOVWGeBvo3n7GOsKPytgbUOjpUngHZhJn2
	/8Fe+jTmYLTQkLaoRZyJ/5L9fmQ6BDlhEM6Q19OpT5tRSzqHwtXPDPHKsBqLnRksJ2MI=
X-Received: by 2002:a05:6000:d0e:b0:3e7:4fb7:4e9 with SMTP id ffacd0b85a97d-3e74fb7050cmr2433450f8f.47.1757409717591;
        Tue, 09 Sep 2025 02:21:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFHaiuV2XNAb2KzSftztUT7DW61EOo5r3IILYTR3cBriEgdDR9uMZbXOjouMq5dEBDNTmzUKg==
X-Received: by 2002:a05:6000:d0e:b0:3e7:4fb7:4e9 with SMTP id ffacd0b85a97d-3e74fb7050cmr2433419f8f.47.1757409717177;
        Tue, 09 Sep 2025 02:21:57 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34? (p200300d82f239c00d1f6f7fe8f147e34.dip0.t-ipconnect.de. [2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b98e77231sm303120095e9.12.2025.09.09.02.21.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 02:21:56 -0700 (PDT)
Message-ID: <d1b4ff2a-052f-4556-91ae-273962edbed0@redhat.com>
Date: Tue, 9 Sep 2025 11:21:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/7] Nesting support for lazy MMU mode
To: Andrew Morton <akpm@linux-foundation.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
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
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
 <20250908191602.61160a7990b9ea418de758c7@linux-foundation.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250908191602.61160a7990b9ea418de758c7@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xKZBug1IFDELyMXg7yiLHP8j5Bxde46Z7Zhl3mv4Sq4_1757409718
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9D1B140008
X-Rspamd-Server: rspam05
X-Stat-Signature: jnubkue11pf1xs49csi6jz33w4w7b5xy
X-Rspam-User: 
X-HE-Tag: 1757409720-36687
X-HE-Meta: U2FsdGVkX18sEGkFnS3PNm7eplz5LWiyuVA0TiWcYSTlXDItxSehKBDTb9jt5yVKqH0ZTPaNyQEo76HWERMk9IrwYCSy5BYUZGm/51JkmwFedgGwUQiu2P595QHCYwH8Qr8dVhtViUbXMZka/+TuF6gBUdlyte+yf1o6ARxC0LiACknECfJFOlYBCiCdqTlrVM8PuopjOffp0hdghxV9YE58dKITXldo03bnb3+KndNa2v9XCYB939pfOywtjnMjFghKFR9W3x0vgJ/H2fkFe7FDKq0wg5VnX0t1fUnvjnZXt01eST9UURAR33/8RBJraPHese51iuHwAIsOl3Du+XsXgBQEg/Z3BFRNzzNi3O5ItN+NUO/rfyE14WNLU3GXb9ay2SnWW/Z2ntswlNHoXerkPnQMdBuKptyJbn5BklVZWuFlgd8LlpAFi98e8UJU9kgXFqIrtRo1XWJVAHcKoGQfIvC5hYbGCj3UCeA6Mni/2WsXrLQ5RwC/bGHBQH9txO3nYQektOJtWU/2j1/5LQA6NXm+f/S29w+gurv3cyD5SjwcQDRkzVarbkyxsxkSQUj5ldaOSUqcYoZCSrMqC+Ndzc8Z1KvFV/wZpCzKdofnrkReyFibFWKPyTrXlM1Hx2N58evqch7ClaEsJk5tLIj3Rd1jPhWGZXoU5ZXearMJIHolcbjhrneuq7EyadEU35VRn42SlcRwkbq8nmfzDkQNzUH44uwYaKIe7XovKF6eJsi4nX5E/IS7KlH/Uf2QgCwKBz+KsSHhb15KFyAa+UiMOvElrLQTGJ4x7lgWp+l6xvwESzheQxxC/CEqehFjGwl3pvFimrSZfiuISaXDhGVtgXUtdpttEGYlDWFFnBl4QwQlXJrFqJ8Ak6NMZR7iqH1UHfpRoq2yJPaQTfZeRRBtKzheNWXxI3OR35njQFI6zs2dxyALJam8ZhvNLjUmhZx65PsmaBBvX9FJg2L
 q7IofIHI
 rn2ythJtElJ5s+1iWzM/MJT57zMfh+DTWxfPS7yL13XAmIHHQ0rqqX7PaPQgcEsgW3NibkWdyyr+cI5eNaOJQva9Ahngg7mBjH7E+qAPljC8FEYOyZhA8d2vfhcKMlp2swMaF0WIvFU9aOH/Lb9o3BwrsrBpGaEARTYrYO6SEEaGyyGKFeAh5iXCRdhqjEPOaTIqnUf3X/llXVUGLHyPXl63oNwmdjlaogK4PiY+Fo3LnMR5lGL+3+TTqixHzCOBfu4Jzg4PyGtafIotefpP0BsDp7XkX/L6ypIgyNc+an4Ds0B7Bjf3Ep7zKpPZ0idQJeuAfPSgQ0zm1XdKxlXa/eTEU9Pk0OU+DxT8zYRYfoaur7Z6wMJYXlirH/vTEgn0cngEBPPQ20gzAOIQRSgRA7YUyeDL79Qsi5x21bB67MqXaggkLKZU++uryGqNxS2TXMw9SXC3gJ+ReafJ2dHez62hdsE3cLUhqmicRVpcjl9j1Qg8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.09.25 04:16, Andrew Morton wrote:
> On Mon,  8 Sep 2025 08:39:24 +0100 Kevin Brodsky <kevin.brodsky@arm.com> wrote:
> 
>> The main change enabling nesting is patch 2, following the approach
>> suggested by Catalin Marinas [4]: have enter() return some state and
>> the matching leave() take that state.
> 
> This is so totally the correct way.  Thanks.

Staring at this, I wonder if we could alternatively handle it like 
pagefault_disable()/pagefault_enable(), having something like 
current->lazy_mmu_enabled.

We wouldn't have to worry about preemption in that case I guess (unless 
the arch has special requirements).

Not sure if that was already discussed, just a thought.

-- 
Cheers

David / dhildenb


