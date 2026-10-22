Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E7F7606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 07:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=WkysQsHy
Received: by kanga.kvack.org (Postfix)
	id 27D696B08B8; Thu, 22 Oct 2026 03:04:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 207356B08BA; Thu, 22 Oct 2026 03:04:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CE5B6B08BB; Thu, 22 Oct 2026 03:04:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D66716B08B8
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 03:04:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 58BBE1406EC
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:04:20 +0000 (UTC)
X-FDA: 85349373480.14.2B4C34B
Received: from mail-pj2-f1.google.com (mail-pj2-f1.google.com [74.125.227.129])
	by imf20.hostedemail.com (Postfix) with ESMTP id 748371C000C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:04:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WkysQsHy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.129 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792652658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ByBpVD7FPTufElpNoOF6mqXMOL+Kv6Ik0YaJGkEPtg=;
	b=F6Z6QH7AtnjXVXpPo/4Rx87ThNXnqBAnT9h6gW3r05uw93SN4YX1in4KmIGNbbIdOV21k2
	ebUbFXNrJXireUhqXzKbZOig60ZysfAUveG/fWf+dBXZlfEZh+x4Wb/HXe+bPGeZZXqaNu
	oIzvajbY6MkB+yrGG8i7bsTRveNHa1c=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WkysQsHy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.129 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792652658;
	b=Mtw07z83rCK17iEwNiNHZYDN1a9O+tgx2NsIruMpui7Z3XX0jR5zTPBQZgeKtpFZsp3C3y
	5HmHkMhG2zFi0j8y0IeteCfVgfW6DstsbxweS3nShPS5esTCLawaaa7fWTLmxYy6Tx4qj4
	bHTlXPhtY6fp5OIIA1VjOoJd/ZPXkLU=
Received: by mail-pj2-f1.google.com with SMTP id d9443c01a7336-2e876f468e5so5077635ad.1
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 00:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792652657; x=1793257457; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+ByBpVD7FPTufElpNoOF6mqXMOL+Kv6Ik0YaJGkEPtg=;
        b=WkysQsHyTVcQtyxYBqKTjtCopE2UeClglqWwHOg7Qug37KU1eAS7EpMHDP/gLW64eV
         +mWuUQVwWotVjtCtfaji6b/afWvvWoBtVJM5Rx2q9U5q1kEwEJQAmEJNBeBPzFzuNoI8
         Nj6qibj8+F467M3vNCRZd7oAbCqJx4HYefgWB6yvblEQkjTjCPgVL2zjE4dAFGpfCOcQ
         C8NqveMb1+WbbS7wGBlbrzVjS+wnlVl9UExHvWTYa1GPaf22WANy8vgY7huNVDhjYo8z
         AG50goV1fIKD0H02lpG1GhUYxiksr13VQH2jem8h0+nv+9YIxekYZuOp6AyGgD+kkclq
         l/rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792652657; x=1793257457;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+ByBpVD7FPTufElpNoOF6mqXMOL+Kv6Ik0YaJGkEPtg=;
        b=co6Qb9YCk8LFxB33Ak4ITrkc6R61b4aw9QfJdH0G8bauhSBykCPBIuoLlVCDV48cEr
         kNf9UlAl3ZrU/VT/S9Fmg4HEJtP9bjfEHbbP2Zt6g3nRGq70gviDWaPlCDLHJFAccpQ0
         qwEYRrHXViE7TD9Mi5h1DNI9f4VlqtbV3CZsJKs3bylMXLni0stOwlp9OZOE7IMV6Ux7
         G6tnpY1itXXZ+sEOn4uAd91OzdpykYMT+yqVE4K3092F1G6fLrNDWezGTkaUurZAchHg
         VclphLC8Hq5cVFV306z4DC42DyMCHLZz1yQg75lF6TchSIy2pW6jMA3EdRA+9Hwtd/po
         zulA==
X-Forwarded-Encrypted: i=1; AKwUvBx2TUQbJsXRHfrtE9fEF8lN4Nkmrze4QBSLDxz/DjShPZSfthKQcluwVtn3Uj4RnbLCuLwyrdO8jg==@kvack.org
X-Gm-Message-State: AFq9FYKBLxjbNJn0VJ68lBKZixzItcpe3oUT/Zx1UcoIAXY0kLMnV2aZ
	X7Iks8KCruv7HTo/X7JkxMIUGDQIeSuR9yTUi0qAzxIt/tScdyNk24Ni
X-Gm-Gg: AYBFou1G0Pz8VD5sXUJsbqHcGXGfbo1bNyp83FrFDivykPLOBNKVvPKkC45yeUxmUpD
	fi7AK5IDiA3Q0jOdS3xYEc+I28ibT8QGiYtKj0bd1WdmNypKSnH2V2eIqo/BK+9qws5e/Lpw7Gc
	Cs8+rVxAH9qGx4HScdsgY7G6mLMDkA1zxvaLZtIx4v+/Z7EEFX8yZ+CI540VJAh7RSRMP1FKBUw
	4of0eE+E3geocdT3drM9UKMnR1ziEZITL4k3/nPTyRbaK0lzLk5h40U9K9HJ3sEUpFBl44Uc45G
	wjtv13f4Hb1Gi63TwOeQX5/UDE9cUvtgNiRj16DELe+mvGDLYvX2v1bVO/D+4/3ESdk0cuHBKwn
	bYUAhPHSg20eaOjGeIKK02zlpYK3TCCPikMsIx8WktY7YONQdJ+lNqwml9rW8+ezgmm0To42jP/
	Bees5UWA6tOdMeMH5eornxtXr54pwrZVV/omhPAvbkA9l+EcYNHUQoGEoIoqdkk8BYPhhmQaA5d
	yxWpxRfohIlj4cxWt/g/sXCPzY6da1hBRVRhPz1Navb7U1X2C8GOoGVLXgcSso=
X-Received: by 2002:a17:902:e947:b0:2e9:9bac:2e84 with SMTP id d9443c01a7336-2ea43d3a8e5mr34417885ad.66.1792652657298;
        Thu, 22 Oct 2026 00:04:17 -0700 (PDT)
Received: from [10.125.112.22] ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea3b43478csm19901295ad.28.2026.10.22.00.04.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2026 00:04:16 -0700 (PDT)
Message-ID: <95f18ef2-8fda-447e-bc64-1732febea363@gmail.com>
Date: Thu, 22 Oct 2026 15:04:02 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 0/8] kdump: reduce vmcore size and capture time
To: Rob Herring <robh@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>
Cc: baoquan.he@linux.dev, m.szyprowski@samsung.com, catalin.marinas@arm.com,
 will@kernel.org, mark.rutland@arm.com, chenhuacai@kernel.org,
 kernel@xen0n.name, pjw@kernel.org, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 saravanak@kernel.org, akpm@linux-foundation.org, pasha.tatashin@soleen.com,
 pratyush@kernel.org, ruirui.yang@linux.dev, robin.murphy@arm.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
 devicetree@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org,
 iommu@lists.linux.dev
References: <20261021083011.2170525-1-chenwandun1@gmail.com>
 <20261021132308.GB3667411-robh@kernel.org>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <20261021132308.GB3667411-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 748371C000C
X-Stat-Signature: if7nz3snu91cmgcq3fd13s5fjxry6769
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792652658-332134
X-HE-Meta: U2FsdGVkX18QfGJipFWkfOHl2RY8VRFZygeSdHSJffN+lEgPajuGfNq3exdZPbumuiktBfHjGBn+z247Wn1JqO0CQ3ttv920IWsTiWY1bM9CJ483+UiY4nOEkHPr9gorBiwxPomnqSShkT/lXKHtVJ5zEr+7v4W2r33LQomdPDjpMs3gDDj1pfsM4RO4StYIN/XWmTD7r41oWu22GFbrzxnClLyTckePTQX99M2XNpTVwt+y5xF7tP4Fhi67yIpZYQpCxkHtCQMMli+eK0qqZgK1nBQVdpqb+iMknULDcX/g+G910sarlni3VP7mcwKnkc0Q9FMA+mDCishb2aF92RLKwQ2p3Fq6NpYLdgyHg4qFVm88xxXL/3EmPz6TnK5m672ZwRqaHuvVUCodtaUShf3N1705V3NQyfuVwthvT2qwLgJk3TBF0gf6OKxWX+UJ1RucXQ6XSTexhJo6UEVuDelS6aQdFDEKzoLsH0NNPaYhSacYhPr77h7EpRy/lo7Nj7r9cD34oYpwb0S3ol0mwX8Zoq27iVWJt1gq0WRYZJHD4fEdNUFE2hbb9HJxDYCKBlDCn86VOX7HXsatYytV1R0XIg5nnRcyOpZkdyxbyNzpe6KLtPqdgxBLLXWhFnB27smVdAZl4yfB+vBbB9E4uCX52UETmTaD9VVRnAYVBP9UCtJzfO5mpoGj13pfnSVTP+nZbR6ihjZpOVUCkkzGlbq4HT6NIU1Tp0sO+aQIniBFbgNwycz46bYdkuL20kkxPd01WCMNmNIktbNKsVQly1lFYy1oLu5Zs67w4akOKUeFaCWF0Bb0kQPOBRx2Sho0bgHHAtKnAOxjk5WHU5OTGQsNAkShzd8wvvwf47iqN+JJaPwClFwRAkaUnOeEf/bSPP8OQ2+sem4mip1vzhOlvBxZADsWAhDCxGDLt987H21omJguA8tl+YI9WQSyyVF6KsqSXlKbFT7a+qbgfN3
 hz/OC1Gh
 lV0BWIoXUpxTUYy/4LbBTvzX/nKtwXpsydwwAC3eG9JQRzoIAtXecveAfzWvripjWRpdVQtW6peX4PWNNi05EIzaVKA9/ht5UTvf5CpAPzB1H6pwpeQHKyvmEgZpYbzome7B+5rRs2yQytl6IpM6RpzurnyA/PJEhfoOneRhoi6pIWbc5QjZklOjARoS2m469BkXbRToeKfmj2MIq5ZPAnYijxrrkrriEH8CT6P0qmK4aoHb/jAVr2mU/fBZaM5kZ17QJmp6e7RPLSYhwgCvJ4rH7F2dT/v7yrqZ0Nf6ZYgnblV0TkeVDKxctXcNpzA8zMjrX5CCNz9834zc9t562nUkj6IricO5x+nh5BBT0FWBUOy+bKp9Wi+gw/Uw62UC1uRfINvjiu3T402TldLoXGY0U1ozru7A+JPx42p3C6zEirW7p6eINYHgd6LLClCdzGcrhot3YD7nV20zJfQVAyoa5cCBpTVmnMvBwLuv7cI9tHzV4KErU7Jz4zRLIo9bnUUZloMHQlg7jALvVg6ceAgxJXB6HSsr/3La1OuKOgwpXwrfonpusWOOY0fyPFHjPCLnPKsiNJ9/PsvQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/21/26 21:23, Rob Herring wrote:
> On Wed, Oct 21, 2026 at 04:30:03PM +0800, Wandun Chen wrote:
>> From: Wandun Chen <chenwandun@lixiang.com>
>>
>> On SoCs that carve out large firmware-owned reserved memory (GPU,
>> camera ISP, ...), kdump currently dumps those carveouts as part of
>> system RAM even though their contents are firmware state that is not
>> useful for kernel crash analysis.
>>
>> ACPI systems already filter reserved memory out of the vmcore through
>> their existing path: firmware reports those carveouts as unusable in
>> the EFI memory map, they get MEMBLOCK_NOMAP set in memblock.memory
>> (is_usable_memory(), efi-init.c), and the ELF header builder has
>> always skipped nomap regions; only DT-based systems currently fail
>> to filter these regions, which is what this series addresses.
>>
>> This series introduces a MEMBLOCK_NODUMP flag (suggested by Rob) in
>> memblock to filter reserved memory on DT-based architectures. A new
>> flag is needed because MEMBLOCK_NOMAP can only express regions without
>> a linear mapping, while MEMBLOCK_NODUMP can filter regions that are
>> linearly mapped. Reserved regions are marked MEMBLOCK_NODUMP by default
>> so kdump omits them; reusable CMA regions are different because their
>> pages are handed back to the buddy allocator and may carry crash-relevant
>> data.
> 
> There is little point in continuing to send new versions until Mike 
> agrees with MEMBLOCK_NODUMP being added. You didn't answer him on v7.

Hi Rob,

Thanks for the reminder. On v7 your reply to Mike stated exactly what
I wanted to say, after a week without further objections, so I assumed
the question was settled and went ahead with next version. That was a
mistake on my part: I should have gotten Mike's agreement on the flag
before sending a new version. I'll hold off further versions until then.



Hi Mike,

Sorry for not following up on your v7 question. The reason a new flag
is needed is described in the v9 cover letter:

    A new flag is needed because MEMBLOCK_NOMAP can only express
    regions without a linear mapping, while MEMBLOCK_NODUMP can
    filter regions that are linearly mapped.

Put differently: today, whether a region ends up in the vmcore is a
side effect of how it is mapped, mapped regions are always dumped,
nomap regions never are. Nothing can express "mapped, but not useful
in a crash dump". MEMBLOCK_NODUMP decouples the two, and DT is simply
the first user.



> 
> Also, I intend to apply this[1] before any further reserved memory 
> changes which will greatly simplify the code.

Understood, and it makes sense. It removes the two-pass reserved_mem
initialization and indeed simplify the code, I'll rebase on top of
it once it lands;


Best regards,
Wandun




> 
> Rob
> 
> [1] https://lore.kernel.org/all/20261015082315.56876-1-m.szyprowski@samsung.com/


