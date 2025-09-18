Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8FC2CAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 19:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC6168E013A; Thu, 18 Sep 2025 15:00:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4F9C8E00F6; Thu, 18 Sep 2025 15:00:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D17C78E013A; Thu, 18 Sep 2025 15:00:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BAA2D8E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:00:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 60CEA1DE19E
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 19:00:41 +0000 (UTC)
X-FDA: 83903287482.27.BF98C97
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6250CC0011
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 19:00:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G0ne3Av0;
	spf=pass (imf10.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758222039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F+i9iHMrfZSNqoivyx67SGEamkAUPDlF91tqODtRDok=;
	b=JfqhFmvlTkVPsyFKqWGPpdufXEkAAEPnhVOy5AJuskDnAqVYKVUUCbcpFhaDpbKrWSwa0G
	FlINKhniWqKZMGKOw4ifAboZp7j+QKFp46yhfNL5/7x2ixufJ1iX1soa/YteEpPqnIxZcN
	RhHcZ4fD64ddQSd+y1RyKDZuvSQROgY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758222039; a=rsa-sha256;
	cv=none;
	b=rz1tNSAkq40V1xcjFESKgZ8MzhI4UUff1MvfyuzlSucs3y4IkbTLsAputaUXxIwfYvvT8j
	V58oD00bK0W7DKh6wCxgcWUiTno2RI0bV84KKX65zmyQhIyEZxjeJhkNCC2C/hvkPpvakj
	MBQNZSNADx8/BvfBbPEREpuhPmIabXU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G0ne3Av0;
	spf=pass (imf10.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45ddfe0b66dso2492705e9.3
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 12:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758222038; x=1758826838; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F+i9iHMrfZSNqoivyx67SGEamkAUPDlF91tqODtRDok=;
        b=G0ne3Av0BGEJfvhMzXVd7MGVV0xLmuuqauMvt8lSjS3wHmV0+MpiQPShpL4uooqrPo
         4f1NOAgol1ollkMhoc+57ksdoF1cNO9+JBj/dOkJ/eW52vRviU10Vsm1yTjsMSDU0d04
         D2issbGWEto6Cp5v7xKXUmWBqnRFEI05t4GNwXeboOYlNC20Da4XzhsQMj/g6H/As7R8
         TTBp8fl4VmU5metvJmI/dVl4wQWsb8TUIwLB3ZdTeFNlTmc6Y81agkiKzq+FoQjzQ/jA
         Ynw2OsA14FErXU+JK2doLMBXCiUYPfZAAZz0oaTDMphC4fEQ4oUkO+bzC6L1K3cqsrFl
         61MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758222038; x=1758826838;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F+i9iHMrfZSNqoivyx67SGEamkAUPDlF91tqODtRDok=;
        b=uuZWKsrEzA7puMWgmTg6soG3Px1+tLanFAyq8g2+XF6pApAREC97RRkzp6xFKY/a4d
         FC9HMwNV6gaUk4ylrj/866QiFxPpw3Ib3dXqTEereZoXP82MGHn6U0yllTyqa6JLmW4w
         iKChwJ21TatAZXPDfQ6HhhJWbQJvguqF9ZFJkz2PS+M3xXZaHQcDtVHPen3sZPKjDvXd
         yglzomIOagDWh21CuSUMxSObEi5johqJp5GosSIG6u4rTvEGVu2RzTZtmQMq+N9QHk2d
         PeZr3M0VSXHLEuedADMTlpTMo0AnY9RoVjBPeAAlINyqzi2IHpgRIurzsIcVXFeVKQXW
         jLZw==
X-Forwarded-Encrypted: i=1; AJvYcCXmGQ66HvElr3I1BFBTD63rSzkFxOcoWZ3UGB1IyDIoF7R/Wklhae8w3W6K0OjyFDG7v9l1Ht6NzA==@kvack.org
X-Gm-Message-State: AOJu0YzmwpaWx7za/K1E8ZMzHD49x6sQY9LvQSiHpeLx6BKN9xAkw4G7
	Utw5pcJ+jvoeVSKEa08u9tPSFTgmTrMIj3nG4q/f7D2EbhpbKHQtkrEo
X-Gm-Gg: ASbGnctX/rw3/i1ks5N0cQKWaMA1Bt9zWHRbQqoAQ/BJ34uXqYvFK3e2t10REr13HYn
	3xwFitDACJeMTnU2QaLPA8s73p7FO9fTK7wTlTmQStHYWEwKA+E0ruNTfa/qip/Gw2ybAzCiMtC
	tn+y90gPL/24CeYWVltcQS69ksDp+UoXP1NzxeuxAknAsau+1jzgP68ER/7+8iATJLXZTDhBeKN
	wea+ft+ONK8IRMX0DwiL1rSXSbAsDiW5yUh5QGJjUoZODPSZ71jc7rYcM7JytrtEwpd0PeiiaEW
	6HSxgvXEHRWrNHscKf1qKWWEMhRoaX+vJ1Tk7pwGQxKRWsfQnJIO80K4uO/sGMTYB6WbgAukvZm
	gtoESZB2vhYG9v9QjnZUzXpo71e5IinD6ewU55Mc79Pjt5db1NfXBhCr1L29yzDBcQITJGDZurL
	xNE+sFMqVn
X-Google-Smtp-Source: AGHT+IEufi4ClRY4a9e7yea8huaXiy4yZ519x4gYdFB4Nd6ggMP2w+e76/E+j0H8SZ+HE/JV9NrWKw==
X-Received: by 2002:a5d:5f95:0:b0:3e9:559c:13f6 with SMTP id ffacd0b85a97d-3ee81959333mr151172f8f.2.1758222037501;
        Thu, 18 Sep 2025 12:00:37 -0700 (PDT)
Received: from [192.168.0.18] (cable-94-189-151-62.dynamic.sbb.rs. [94.189.151.62])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee073f5387sm4558160f8f.1.2025.09.18.12.00.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 12:00:37 -0700 (PDT)
Message-ID: <893401bc-4754-4c67-a82a-0c49c8e7f447@gmail.com>
Date: Thu, 18 Sep 2025 21:00:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/7] mm/memblock: Use KSTATE instead of kho to preserve
 preserved_mem_table
To: Jason Gunthorpe <jgg@nvidia.com>, Andrey Ryabinin <arbn@yandex-team.com>
Cc: linux-kernel@vger.kernel.org, Alexander Graf <graf@amazon.com>,
 Mike Rapoport <rppt@kernel.org>, James Gowans <jgowans@amazon.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Baoquan He
 <bhe@redhat.com>, kexec@lists.infradead.org,
 Pratyush Yadav <ptyadav@amazon.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 David Rientjes <rientjes@google.com>, Pratyush Yadav <pratyush@kernel.org>,
 Changyuan Lyu <changyuanl@google.com>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, Chris Li <chrisl@kernel.org>,
 Ashish.Kalra@amd.com, William Tu <witu@nvidia.com>,
 David Matlack <dmatlack@google.com>
References: <20250909201446.13138-1-arbn@yandex-team.com>
 <20250909201446.13138-7-arbn@yandex-team.com>
 <20250915114707.GB1024672@nvidia.com>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20250915114707.GB1024672@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gxk4tinkbcnopndx6oo5p6i6b9nsopqt
X-Rspamd-Queue-Id: 6250CC0011
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758222039-238160
X-HE-Meta: U2FsdGVkX19+c66GE32J1Wm+aWVoOs6ZKgID8BS17mLozc0ViFnJ8oMmuZytQtTBv22MwtnhGp3IQICEwoK463c/azRnnTN5ZxpQzPo/K5B+CIEOAa9Y9a/eEYJ3LHyJrJ47VmrsmMm5PDLEZDJZ+pnORrjiDUvMXM9bUwRvL5W6AJrFGv+h986aBAaKdz9/AizYrL1gfg6JlfVyhVPUTtyPH1f5fH6siZe7PQK+CPZnGhV+7CLJKEq/KkjWEHUVgHH+UTZ/zjiEW9vZM+6OfqRlYB4m01ULHsciKeJh5ERq/7Uy6tJrhgaJCiaetP8bl2Hazn/KlH2/E3ExN4XL8Rs9w+80I/3OOuhzljrxCTYh7j8L/HLGCDspIx0IopQ94dO60i7iFvKih9IDMAZt2b+VZ8eaZR+z+2i01AFYz9wk0LGyeZTJibRA98Wtf50GJtCiEPoXeHYm3EXny8Lo8dVuldvp1NctgJ8T5rmpGM+d3P0qndOZQV+n8ZxBqwUVFS+F0itOj6joUhjeNXJgWRkFr+fQxJbAhHGfF4co2wVB++CrWm24YZkdeihOiO3MPrruikxDwDME6qX5ql6DHJ6u0RBo2T0ZzyszrbM81KJngTNV3wet8ZbKNlQ0453hkHTc+oWnbXzyiRnrG7k68SPnNXSFQ+DfzE53TpgLJASCtcGNLHh1rp/dA2519e+BTr2EJdVSeDeiTdJpC7zObLku+O0xL9khTB8ULm8upD8W71OpAs4glsQxlHo+eO1xEsTT0R++23NgMULRXpHADRwZVl2E54DAKA0qFdZBNDC2QHAtpOd9sTZC9z6TuVq50Hru3SAH7kbn87n5NHjhZnE0obkvFV5REeArSkMc9+0gjii+CsaTtwjpSzFBuFdazonegWtc+40q0Y4qe4Wt9hO/FcotANvfOuAA9UQhgn7PNSXx6qgCA/GYqkJe8qeeZmAohn/GcrzqHUXV/z2
 7EzSa/nU
 Z4c5woK/d8+c0J6yJuaWQyYS7/numEUrNHrmic+OEKbGWLWnxrFji9W/ksLxsfePVLfmALdl4m/W0l7biEW5XrvIXMMJcVeJ10rHCLFd9vAIsx14fTrcofiVv6ikMEu1hjeW6ynrvTGAxhWevTf6VOnuWaDI76z7tqcgP6zqVo52tl70DXmlFQqTKDE3WVBa3QH92Val1KNGIlbpZ0vghF+645cYFJgD9QXl7nL+jaNXayrm5cy0cC/TBu1uCYOb+i5HjCievNVGfzHuJRr89yO/+2Z0Ul3nxP1tzljT2rH5M3qLt2CgKyUBjcMnhb3EqEg3lRfSQiFMDhrX+1rq9J/oBFkkHnvreV/RMzrX0piGZ13anQF44vrmFH44re7SYefhjiyym0NEplysDFkPnV3dbKMGQpXuJMPLxjmwlbc4oi4aTTUl5bAatMucwGODzTPDooVBL/aIMyWygE/VraRxThrbz+DdK8e8WF3E1LaSGQpILkbJMkO7rFYp2JmjkbPS0HFoHUAD9hynQ1PPjlrpRbAf9lXcOdA5O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/15/25 1:47 PM, Jason Gunthorpe wrote:
> On Tue, Sep 09, 2025 at 10:14:41PM +0200, Andrey Ryabinin wrote:
>> +static int kstate_preserve_phys(struct kstate_stream *stream, void *obj,
>> +				const struct kstate_field *field)
>> +{
>> +	struct reserve_mem_table *map = obj;
>> +
>> +	return kho_preserve_phys(map->start, map->size);
>> +}
>> +
>> +struct kstate_description kstate_reserve_mem = {
>> +	.name = "reserved_mem",
>> +	.id = KSTATE_RESERVED_MEM_ID,
>> +	.fields = (const struct kstate_field[]) {
>> +		KSTATE_BASE_TYPE(name, struct reserve_mem_table,
>> +				char[RESERVE_MEM_NAME_SIZE]),
>> +		KSTATE_BASE_TYPE(start, struct reserve_mem_table, phys_addr_t),
>> +		KSTATE_BASE_TYPE(size, struct reserve_mem_table, phys_addr_t),
>> +		{
>> +			.name = "phys_range",
>> +			.flags = KS_CUSTOM,
>> +			.save = kstate_preserve_phys,
>> +		},
>> +		KSTATE_END_OF_LIST(),
>> +	},
>> +};
>>  
>>  static int __init reserve_mem_init(void)
>>  {
>>  	int err;
>> +	int i;
>>  
>>  	if (!kho_is_enabled() || !reserved_mem_count)
>>  		return 0;
>>  
>> +	for (i = 0; i < reserved_mem_count; i++) {
>> +		struct reserve_mem_table *map = &reserved_mem_table[i];
>>  
>> +		err = kstate_register(&kstate_reserve_mem,
>> +				map, crc32(~0, map->name, RESERVE_MEM_NAME_SIZE));
>> +		if (err)
>> +			goto out;
>>  	}
> 
> As I've said to the other proposals, this doesn't seem to be bringing
> that much value compared to just using a normal struct:

We expect to have many such ABI maps across the kernel.
These maps will share common elements - simple types, folios, and preserved
regions.

With the approach you're suggesting, we'd need to re-implement the same
preserve/unpreserve/recover logic, error handling, and unwind code for
every individual ABI map. That quickly becomes repetitive and error-prone.

By contrast, KSTATE centralizes this logic. It avoids duplicating code
and lets us express the preservation details declaratively instead
of re-implementing them per struct.


> 	for (i = 0; i < reserved_mem_count; i++) {
> 		struct reserve_mem_table *map = &reserved_mem_table[i];
> 		struct khoser_reserve_mem_table abi_map = {.name = map->name. .start = map->start, .size = map->size};
> 
> 		err = kho_preserve_phys(map->start, map->size);
> 		if (err)
> 		    return err; // Should unwind the other preservations!
> 		
> 		luo_preserve_key(luo_obj, map->name, &abi_map, sizeof(abi_map), VERSION_0);


On the versioning side:
With this approach, introducing a new ABI version (say, abi_map_v1)
would require us to maintain restore logic for each supported version,
and carefully handle upgrades between them.

With KSTATE, versioning is built in. For example, adding a new field can
simply be expressed as:
 	KSTATE_BASE_TYPE_V(new_field, struct reserve_mem_table, int, 1);
This way, the framework handles compatibility, and we don’t need to manually
write version-specific restore paths for each ABI map.


