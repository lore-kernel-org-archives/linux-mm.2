Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CF08606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=BXsujX2M
Received: by kanga.kvack.org (Postfix)
	id 906096B0813; Tue, 24 Nov 2026 12:54:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DD896B0815; Tue, 24 Nov 2026 12:54:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CC086B0816; Tue, 24 Nov 2026 12:54:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 50F146B0813
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:54:00 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CCE5CA8B1C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:53:59 +0000 (UTC)
X-FDA: 85470760998.20.A85891F
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf23.hostedemail.com (Postfix) with ESMTP id C02DA140002
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:53:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=BXsujX2M;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf23.hostedemail.com: domain of nik.borisov@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nik.borisov@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795542838;
	b=agFlCGVTr3GaWqeq3wEh3maI4qfc4Qcy09Tju1aL80bn6uv+r05evI8EUqPLolqoubPkRJ
	dtnZ695Zu7cU73jepkxzkzRcaCeH3XxTIRsYcx6Qsy8BUV8APccwlTnMfo8QHNFCUlfa/w
	z8EvOwpj7HY5qWepVLl0ydharIlO7wI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795542838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=29+XiIufhNHRKilLwg1As5CARzR+PGkJ4UIDPlIl84M=;
	b=BHvEPkLyJFXfPVlw+G/69cE24Ko5kyO6QSCg/IlLeFncgRJQJrzUpPIIwzZGYDFwKX9o3y
	tb2CUd8VMOa+FWr12IHnXFKcuL05WoTXApthM4I53pBt+eQtcXuxckUDWMa+LBXsU6HX6s
	qiZQspy3rtRkKXWNfiRJhdJvycpPQ9g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=BXsujX2M;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf23.hostedemail.com: domain of nik.borisov@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nik.borisov@suse.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4a7b8abe209so3729098f8f.0
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795542836; x=1796147636; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=29+XiIufhNHRKilLwg1As5CARzR+PGkJ4UIDPlIl84M=;
        b=BXsujX2MtJg+kibtKwz/tctLFCp8EbfobzjqF/JeBdeAmBcMqvqAY2CsYNDQ45EIss
         4ATUKurdPzP/QBmkXe2OjdVD+jthFfN96VkYYMXkF7YWXocOUPIFFrLZ/J50EHwV07Zm
         D4PwJMgp+trQ4mC64t2yN6yuRkaX09cVAuIfx6ZUFkkaWN/MR0G84x+PPUbaxaW2mJmV
         zXH8ICqJLwAM7L12MLpG09Fmjs2Yxr2bhhc4E4c6BHSNu97lgcKRENsaS+d6g+c6ZvgK
         Z0qt9J/xHWmHmtI9pHR97zuCZbnqcF1Sop3Nfvkt2w4TtBS4D69YtBclQFWyXLjKZofE
         J4Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795542836; x=1796147636;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=29+XiIufhNHRKilLwg1As5CARzR+PGkJ4UIDPlIl84M=;
        b=Mpv4Bm3f0TZ7W2B9LZj/XcNc3Ot/heFTzsRlUoDC0JxwoCaSeArZVcEanvSJYWuCCQ
         lu5O+Rs7PNXOMUNc3r34YzbjYczzWShMY/bp6uO88Ge+uE152gFgPBB+F6LsS40jtfm7
         cL7VqTBY/TYXtMgEm1pFcKiS10nqHhHr9HPEsqBNvegrHrEnn5jp28QHztvdZfNtRHc/
         wzDC0YsG5BaUxWCBgRQvkUnCaDDSLB3WayJjHcNSn20LgHZ4aHOhG82ltPoRciDquRCQ
         ipDKM9AiZfHTC9fOMn2wmLogJGV2cOTknycg6eF4XFpvvSzE/0o7QqW3/35RyNiNrd7O
         NrnQ==
X-Forwarded-Encrypted: i=1; AL+hErG6/LmP3YKKA5eXg5tNNLGAsp+hSbN05tL7vdWNw/071jlP59Smjyn18nJOCMYebSQRwLq2t7cr3A==@kvack.org
X-Gm-Message-State: APuU4Z8Dce4Oj2FqLhzKR7JvoNx/G2/9wE/vFw5Vd/646HhweOJUUVdB
	HGHFZJ7T8L3/AueNQ0a8n0QqBk4HFpUzPHJj32s8pbR7GB3v/ZKB/1id1VXJgObK5+E=
X-Gm-Gg: AZFdTZdBC/MnPoINP42oEKtxlv+c6WaFkYPKXSn+tDeR7z6E7x8npwgpnDxI35XifMa
	mD9dJ4Br0QVbuSviISTVgljhfDrSTeC7F0slGuFNXsBL6uYDB1yO5GbTAM8gRvkY8RNkB8A1enw
	a3TmkPmhvYahzTMc65YWPj+2TusUj+DB31VxbjmTlFCoEn0qVkSrBUKMgCS6E3AsiEfikjXCfc4
	V+1yRJMhdy2+KYmJCp6cvxxFzK1pWBwU9sCVsFBluTlH4K/ctRm/cWWjK0+JVVlZZ2GQVAJWynt
	lJKGpKMh5CR/gULeCDfyKGoCCSawawPCDXXot9TfT/7eK1nqSv0qX7Nd0fUO5tygHqZpnmjS/O2
	KbyZnmlJn8Kcf4h8rZPqRH8TCsY6D9RG7oX9avGzVyAbTnWq/Htm4q5wYcwwWjfNldu/9detncm
	u0yf3KFwjnPm746IcM5jwgJ45Hre9v+Msp4ZpvlFBF2M9YqHNqCfj1UiNfp5rEKEpsPD28roDVH
	6JO1fvHapcfoRk+ndjZjYl1Lm9aCS5G4TBUcoH1tRtIGBJyvUbejH/62rdTAuVLAueYLAjkF0Eh
	KGB6BjULhw5FkX4bYiuL/iTIEOw9nQ1G
X-Received: by 2002:a05:6000:4616:b0:4a6:d298:832c with SMTP id ffacd0b85a97d-4abb31ae4e9mr28436124f8f.31.1795542836258;
        Tue, 24 Nov 2026 09:53:56 -0800 (PST)
Received: from [192.168.0.20] ([212.21.133.162])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6b9add26sm29661068f8f.44.2026.11.24.09.53.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2026 09:53:55 -0800 (PST)
Message-ID: <15d9c032-a8cd-4469-9272-0964e8d9ac9d@suse.com>
Date: Tue, 24 Nov 2026 19:53:53 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH] x86/devmem: Drop /dev/mem access for confidential
 guests
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Pedro Falcato <pfalcato@suse.de>
Cc: Dave Hansen <dave.hansen@intel.com>, x86@kernel.org, mhocko@suse.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Dan Williams <dan.j.williams@intel.com>, Kees Cook <kees@kernel.org>,
 Ingo Molnar <mingo@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Kirill Shutemov <kas@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "Naveen N Rao (AMD)" <naveen@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>
References: <20261124160025.738362-2-nik.borisov@suse.com>
 <0dc6759e-ada2-461c-85de-809c170abd6a@intel.com>
 <awXBtrPSHfs51Y2f@pedro-suse.tail5790ac.ts.net>
 <2026112404-hyperlink-widget-ff36@gregkh>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
Autocrypt: addr=nik.borisov@suse.com; keydata=
 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
In-Reply-To: <2026112404-hyperlink-widget-ff36@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: C02DA140002
X-Stat-Signature: ftizux5hwi1ef11mfhduzf7f9qxtacy9
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795542837-20041
X-HE-Meta: U2FsdGVkX19mmJNi2YH3YfOjfOSGSJrBkJzXmXIKECiGrm38dgJK3ssq5dqUlpMySH0bCdwBcmJbUKDE0tgnFcJEsG94DGP3yXfT4RVIVLrKNOG2WS7jGIxGh6GMOJanry6fClhnpq1HBqUPUlExrMy1KEEY4RIpBRDNhw6WKAz/1XEPRdTd+2FgKiF4LAEu5H7myv+T3C7mNJ9R1O3RG7Pj6lo8lUxC/ACUmlFEpDPav7l+YRwm6D4Xk4nTIZb44845TF74Uxv+F++L1k5E2zp/IiWzP6tusECeecSD3RzeAM0PGXEv4UU2M5ZL8RDTw4ebkrCCEZb2Vg1q805IFcm5syhdSvTlv7E6RL2ADw/ALeC/uIWzO2nz2pDMQrprFgF9y4HhHNqYckN0X8ml73v+lv7blX3zWqhCT4NJnh6JHlMiLr3oOUrgIgSo7eausgAls3Y3WZH+CGeOsToUmkJ83kcFnXvK2rdlPz3oNdDi2BR+k5dXyZq0qGMrzx8MP4lKyvXH+YNinEOhhHO8vlyiSN87rLNGtjZgItSveM61nLZ8HKfcRrid36pbxKeHgAnfPV3mhlIm7FkkG4WEAKQZggK1GJl2U5JZyWgtxX/L/evpHkY8v9dcNfK3utzb45qwHsH72HCfezWllBCvBunGax+A293TM+Jb5M80MqqSoC/VBOfam9ry6mxmLjZa1B3HZgWUcqvUbRU3MjYAo8p1qx1LrWyuNXYI0sS7wRWdncq0KT6SGthHyWOMq4jlzZTGKMCFj4XAnuoHTPHaqnS+AhP0DpQ5O3eDrpIaZ3cdFTFfszRhGpSsUq7SLeI5hCN3GuQ16uiI/1tA3OJVpxbganCuKho11NN0VTBQVW4U1uT3fmjKh6huwIbsfR6zsY0q3WibQlGecY7lCDcdnhUw+P4/K2/AVKkck0x6pAuahiX8oLQq9n01WbeQNvBao2GAzUYQVl2wT+J9WYd
 qb65/K7I
 R7lQIizOTtQ52gWzOdUYOwN2aPUmSZ29P63vYf5PUNLYdWNCKfnSTOdfqeQnVY0TC1wOqo/GLnLTiVHCiRGSGN+yyAC0JHee9Z6BSSYZhx6tDmy6IRATdt8D1M9Z6w4R2fpH7SzQfg0z+RMlnDt2LPxjMa/JBmxZxGP5LH90U93Fv6eKo0T5LLs7bPzgfmLghoH0BF+MS3lRqCzI6NZjYZgNgALy8IaAJSt7RI8tkM5h19ad8ifrz4I7uXuXK+NVkH4pyFTG63VxAMbNzX/bMjOecPyodA958g+ruAhV1+krHqlBwrY6VxDsuPsN7+jwZtTnkTskeN1uNIFfk0ZrsUl805jASmnvcMalXsm15DLB1KMcaxP3qRgpI5KB0tYHKekDrmhRyuAAikxIPQYBcUSeEVXBKu4v9Yjbjsdqkwpe6F50SJlOu9DQ/tLC1Z0A1qjtxDROKeB3KeHkRVdmKZlzuGr/wC9hU/PuchbFlY4l8G67c4a4vAxtOIIFKYpXW4jTL/GeGW65t8VCnRoGYHQ1iF+KbAxd/1BujjqssYKGSTkCyLwskw3+uGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 24.11.26 г. 19:35 ч., Greg Kroah-Hartman wrote:
> On Tue, Nov 24, 2026 at 05:10:21PM +0000, Pedro Falcato wrote:
>> Holy cow the CC list is stale.
>> Fixing some up.
>>
>> On Tue, Nov 24, 2026 at 08:36:45AM -0800, Dave Hansen wrote:
>>> On 11/24/26 08:00, Nikolay Borisov wrote:
>>>> Resending this with the hope of either getting it accepted or
>>>> arriving at a consensus what exactly is missing so that I can take
>>>> it from there and eventually get something merged. As previously
>>>> mentioned this results in real problems for confidential guests both
>>>> on TDX as well as SEV-SNP.>
>>>>   arch/x86/Kconfig |  4 ++++
>>>>   mm/char-mem.c    | 10 ++++++++++
>>>>   2 files changed, 14 insertions(+)
>>>
>>> I'm still OK with doing this.
>>>
>>> But I didn't want to sneak an mm/ change in via the tip tree. Any mm
>>> acks or naks on this?
>>
>> For what it's worth, I don't love this fix. Yes, it fixes issues in /dev/mem,
>> but it:
>> 1) skips any other potential problem spots (I don't know which)
>> 2) open-codes random CC checks in mm, which is kind-of regrettable
>>
>> OTOH, it's unclear to me why that CC check is needed. If configs select
>> STRICT_DEVMEM and IO_STRICT_DEVMEM, shouldn't it Just Do The Right thing?
>> in iomem_is_exclusive, etc. If not, could the CC awareness sit there
>> instead?
> 
> Yeah, why is anyone letting a CC system access /dev/mem at all?  That's
> ripe for abuse lots of different ways, so I really don't like this
> change either.

You are missing the point, this pertains to /dev/mem in the guest. There 
are a bunch of libraries (libhd for example) which reads the first meg 
of memory. This causes the CC guest to shutdown in both AMD-SEVSNP and 
TDX world.

> 
> thanks,
> 
> greg k-h


