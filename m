Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8D56CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 09:43:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41C5F8E0018; Tue, 21 Oct 2025 05:43:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F3938E0002; Tue, 21 Oct 2025 05:43:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E2C78E0018; Tue, 21 Oct 2025 05:43:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1BED78E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:43:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E045814040D
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:43:13 +0000 (UTC)
X-FDA: 84021633066.29.4592BFB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 96DF720003
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:43:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g1xABfhx;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761039791; a=rsa-sha256;
	cv=none;
	b=g/xlna6a54JvYbIlAc+vkt+e/HYReGTksZCcQAE/HV0OKA11DRlWf7MbapwmRL1eyoBKrx
	5hVt60jxDXWpFiKkahfu06+eZ8o3Qvq2VeGw9T1nDnCA2tQaJvKL5IP+9rAOAMb59gBJbO
	x6RgDSX2jtzvT+G1ntcyTF7GVAF2eNs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g1xABfhx;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761039791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7N+UUsWkh/PxB+UVb+bOzD97AQ3e4XfF6EAoBhVIUg4=;
	b=nG/oySJYmagJOoKtBLkZwji7aDor0aCHmQhol4LEIMOW7hG72a2WonUQ4PUMfMojE/oHcw
	bfm8o6pNXF+VpXD0hFYEe7Yj5qsGc7yiX+lBkFYwGHrYer1CmqyC9ADpD7eDiigHRau+SD
	uRO4WIn+ySc9173JtPUGcSEWvwt9NwY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761039791;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7N+UUsWkh/PxB+UVb+bOzD97AQ3e4XfF6EAoBhVIUg4=;
	b=g1xABfhxzyrKP6ikXuP1zTqpiX3ePpk3eT7vAUSNSJ49XnTbcpH5Ze6CTMuOx6oG+bleP9
	Q3x0eKCRekiuUENgi49tuliILI/nu1W9IRUky5fsGNYCCIWfw8dvNWlEbtu/sjpLRvG3RW
	Q/UfeYKoZdTwUjPpF+L1W9ySmeSF/Xw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-367-IZpDM85kO8qv5NyhcaINYA-1; Tue, 21 Oct 2025 05:43:09 -0400
X-MC-Unique: IZpDM85kO8qv5NyhcaINYA-1
X-Mimecast-MFC-AGG-ID: IZpDM85kO8qv5NyhcaINYA_1761039788
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4270a273b6eso2825083f8f.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 02:43:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761039788; x=1761644588;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7N+UUsWkh/PxB+UVb+bOzD97AQ3e4XfF6EAoBhVIUg4=;
        b=eIs/hjiGLO0w1E0icCxfuVwsmPn2AWrY6f63UIIK15uVHb0lgnjkvFtdyHIaN19vkl
         jFNUgY+qmYLdZ0yd/A7CPAntldXe7OSx0nZKmdjHZC55qetmNW63P/FF820/f3CFebnL
         yYRFZgDSSpZdKdJwQ3SC9OmCKtTFedpjJ5ceLpjx97SxYOn1eOVlwvNqhx8Y2Tcie05u
         cwvAyZswDP8SJOUGOUWtlMgK+hhzsyWaJ+xwTr/xUfwmPbVTYwXComQmmYHIVp1PNReL
         mK9ThP9Q9j1ElljxtSARGXzDhbjZPFmVqYM/RAwDrn+5/qQpRB/2JU5W8SEGfTDOmygx
         XqvA==
X-Forwarded-Encrypted: i=1; AJvYcCX0rexZuRmGOy+WoqnTlWMqQ41zhIIS39XdbReltEHha75iR+ZEZT7UlypLOwKtTfBzAdBDlVS4Tg==@kvack.org
X-Gm-Message-State: AOJu0Yyzpk3cUPitMxFXVOoAAgJjYAXpXClBjftTorF6JHZGkc1PvWBn
	pnGtIR7ikzFYjLmONPdLAOrELNiGaZ/gv/RrFZvPTnnmkV4mKSTaZf+dZaS3rMmswLWv/4xAdhJ
	Q3sBl/sxD9/JRB1BvAVhZM82i5lzZ1KjLXN4Isp1pZ8LA6WKmWULP
X-Gm-Gg: ASbGncsHMo1EXSRgbbvTYCYHihyDtJLhshiFIM4R39JLymmQXzILkiRVt6wmD24vxIQ
	Pw4DVtBdOacrVF+9SixLqxYv7+ZUZcQJa4JFTYj+it5C/lTRBuV+jJwxsiLITXUFmuybVUTM5Er
	A7ZTscQHFAvPylCf4IqeNnElN40wUe8iY9XHdeYmLopKgMrPev1IUUKNoocy6oeM9K6hfPEVqWP
	kPLK573GxqXt/TsUuOdnSchozzs5zsYUUFRTE1rU1l5tv8R3ua/0daRDQeVlMtRIsZOG49wA7hQ
	UBkMYmI39/wJcPWwDMt4kaI1oIAwp/0D7IQuzItbOAx8A+9GdA5m+gPIC+FQCu+mP7VWt4Jpw8y
	YkMrQBy3z8M79e9+HjtNb50Beg8ueqgsRMMz2C7F4sZS55zAtaI5mwqRKOI7A3aP9O1moNsOVgl
	DppkumKZC0rxDU+BS4IeYDt8UgMYQ=
X-Received: by 2002:a05:6000:4024:b0:405:3028:1bf2 with SMTP id ffacd0b85a97d-42704e0eeb3mr10685017f8f.62.1761039787951;
        Tue, 21 Oct 2025 02:43:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGKdZ707i2yTNafAh3yeT5ocRi/+Z46tBstB8jxkIB6KoBbNLz4cy9huv2TFyZ6jk4HqWigdQ==
X-Received: by 2002:a05:6000:4024:b0:405:3028:1bf2 with SMTP id ffacd0b85a97d-42704e0eeb3mr10684990f8f.62.1761039787436;
        Tue, 21 Oct 2025 02:43:07 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f00ce3aesm19874869f8f.48.2025.10.21.02.43.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 02:43:06 -0700 (PDT)
Message-ID: <b31b7abc-69a2-44cc-9e30-0baf03f45a29@redhat.com>
Date: Tue, 21 Oct 2025 11:43:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: O_DIRECT vs BLK_FEAT_STABLE_WRITES, was Re: [PATCH] btrfs: never
 trust the bio from direct IO
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>,
 Matthew Wilcox <willy@infradead.org>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-mm@kvack.org, martin.petersen@oracle.com, jack@suse.com
References: <1ee861df6fbd8bf45ab42154f429a31819294352.1760951886.git.wqu@suse.com>
 <aPYIS5rDfXhNNDHP@infradead.org>
 <56o3re2wspflt32t6mrfg66dec4hneuixheroax2lmo2ilcgay@zehhm5yaupav>
 <aPYgm3ey4eiFB4_o@infradead.org>
 <mciqzktudhier5d2wvjmh4odwqdszvbtcixbthiuuwrufrw3cj@5s2ffnffu4gc>
 <aPZOO3dFv61blHBz@casper.infradead.org>
 <xc2orfhavfqaxrmxtsbf4kepglfujjodvhfzhzfawwaxlyrhlb@gammchkzoh2m>
 <5bd1d360-bee0-4fa2-80c8-476519e98b00@redhat.com>
 <aPc7HVRJYXA1hT8h@infradead.org>
 <32a9b501-742d-4954-9207-bb7d0c08fccb@redhat.com>
 <rizci7wwm7ncrc6uf7ibtiap52rqghe7rt6ecrcoyp22otqwu4@bqksgiaxlc5v>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <rizci7wwm7ncrc6uf7ibtiap52rqghe7rt6ecrcoyp22otqwu4@bqksgiaxlc5v>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3m1ScqK6G5X6n-auiUr-TiyomO9NkdyJbkb5TMZr4xo_1761039788
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 96DF720003
X-Stat-Signature: qf3todejkgnr6zsbpqgq45nn5f97acpi
X-HE-Tag: 1761039791-765320
X-HE-Meta: U2FsdGVkX1/VPgMjHyaSbrp7OdkzlGczgDhboqYrP2nD7tgBoieV9iDewTkzmXgODmK2kxPrnA3c1dFMNit/DWiWp3uw6tGaJZZDgo1CIrJs1u36M4p9UKmDJdYBHhcuIHea8u8P6ELv8S72ePKIAOn7bA3/MmyD7VcgPuwN3GMsgMAzaWnfGEJY/YGiyvpYxBvWYMpDGFOtaFLoD1aecsBZmkLsyB8bWZ1YrjmFuJUEyJKfsIGLyLBzo6apo6Cfk3jgFHo+SrssnSGDSek+8dkS/q5RRaD7msjt4kRXETzVP97e4GtuBC9xPeLlOGRHsuhoBQjdZz6FMjAwfveZQWD6wciMZdCNiichn0umKZ0kpdOl4HqemCvn5awUL5NImLQNABDKkKS/omF1nKJgELIWjUMYiIItOqHF2Qogvt30jY3AZTG0OgkCiiWn+Seg3mbA0FTTNg604C4slhNLInBJUILa9REzWmcCsCeB3jeCTF7RJBbkBF9I00owlfp86jWjB6HOlX3+XuNiskL3S8gweOrfiXbNplUJgMGowyLtqaKXyE0n4gnBc6oiolQBTRPOC4Wi17v0jX9PX0mC6NKMMFaU8pl3LWcsQlIhUVfZCjIrffEqWofyurGrVv1n7KH4L/99Zy749C+KIXeDvjITCbTKlht4mICnCTNxhID3bnhbpJRxdLnt4S+dFzv1CRSFL7tR2AMGD171a21vRgNV5KdV2/y1yTzadNrs/BkFUt7hMN0zEwgRiIXwjQKwsc8fkVA3fbmOqGWxFqirf9khyLtMAgd3/416t0M75FugSVwa0WabaGohzUkEn8WE5jVzUgMpw4w6MYACY4hJn7P6v+TnEwGhQAjtgQhw49paogjAKeLsqv3CJ3PcPgn1ER0FnSBm1G1fqS804oZ1OYO1avNyackY3OV4AQXAx5rOPyhF/3scrAofzCLOfp+GVBALCHUhni2mndTd9ZN
 KnEzHxXg
 A7EcpcuVarzDFi44Y3wLbPVku2BkWpD53TG2sV5tFRLUFgFeQnZ62ul+FFVvOQsYV4ZvbvQ9mXyhl94Z+EjSH0ror3UoJCQg6FoFMcdaA6fwlU29SGWy40qoCpJCq36DleNO4uGFrBfNyfZS7FY0JpmtFpqamZJ3+v6xaQkKKfj5IttoJcq05Dtu2O6SU2d98uVO5qg7SY4X2/xbClKAfalJvpVeWuf00xR0Plu+qGgc/+VfYw5Y6fdWg7bHWqrEvbVIy0YFzBhOatO6B5i8YP4yGJ4t3/y8aJ5oJ8kAbeYzoRgMNyAWaC+o2aQk+Y6JnEXvcZTdx4KvSOtkpzQ49bCKIgtzIFW6g8txGzxP2ZBVlPW86vP9+GOjs8KO1GKJToiGL993NvRPVMOvcZRy3T2EZs2/tL4BpCV/VkKYOTznZfNYygTuXIB02kQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.10.25 11:33, Jan Kara wrote:
> On Tue 21-10-25 09:57:08, David Hildenbrand wrote:
>> On 21.10.25 09:49, Christoph Hellwig wrote:
>>> On Mon, Oct 20, 2025 at 09:00:50PM +0200, David Hildenbrand wrote:
>>>> Just FYI, because it might be interesting in this context.
>>>>
>>>> For anonymous memory we have this working by only writing the folio out if
>>>> it is completely unmapped and there are no unexpected folio references/pins
>>>> (see pageout()), and only allowing to write to such a folio ("reuse") if
>>>> SWP_STABLE_WRITES is not set (see do_swap_page()).
>>>>
>>>> So once we start writeback the folio has no writable page table mappings
>>>> (unmapped) and no GUP pins. Consequently, when trying to write to it we can
>>>> just fallback to creating a page copy without causing trouble with GUP pins.
>>>
>>> Yeah.  But anonymous is the easy case, the pain is direct I/O to file
>>> mappings.  Mapping the right answer is to just fail pinning them and fall
>>> back to (dontcache) buffered I/O.
>>
>> Right, I think the rules could likely be
>>
>> a) Don't start writeback to such devices if there may be GUP pins (o
>> writeble PTEs)
>>
>> b) Don't allow FOLL_WRITE GUP pins if there is writeback to such a device
>>
>> Regarding b), I would have thought that GUP would find the PTE to not be
>> writable and consequently trigger a page fault first to make it writable?
>> And I'd have thought that we cannot make such a PTE writable while there is
>> writeback to such a device going on (otherwise the CPU could just cause
>> trouble).
> 
> See some of the cases in my reply to Christoph. It is also stuff like:
> 
> c) Don't allow FOLL_WRITE GUP pins or writeable mapping if there are *any*
> pins to the page.
> 
> And we'd have to write-protect the page in the page tables at the moment we
> obtain the FOLL_WRITE GUP pin to make sure the pin owner is the only thread
> able to modify that page contents while the DIO is running.

Oh that's nasty, but yeah I understood the problem now, thanks.

-- 
Cheers

David / dhildenb


