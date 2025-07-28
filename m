Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57DB7C87FCE
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 08:44:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D85CA6B0095; Mon, 28 Jul 2025 04:44:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D36596B0098; Mon, 28 Jul 2025 04:44:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C24F66B0099; Mon, 28 Jul 2025 04:44:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B1F5B6B0095
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 04:44:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6D6BE5643C
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:44:21 +0000 (UTC)
X-FDA: 83713036722.23.27CAA8A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id DA8A1A0002
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:44:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z7aI8LO7;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753692259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5z3VFCWPYn+gmTSxxeyfj7eJ1ITAoaTTjNvudffwKO0=;
	b=lRCg91T0JQvqTI04L4Mb8TTQYlrByT/x9r6Co9ZaUDyghlWpHHFX8W4JYGPR1CSnXi1TvN
	2MjbOTp5OkKPqiB+AwjJLei/B1jOE5jptrYthBqS1DkryEVFJX12ylXF4i1+1GbgH+daHF
	7b3tK1IyJSI3+QXSZV2RvnOq2QjTibI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z7aI8LO7;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753692259; a=rsa-sha256;
	cv=none;
	b=aIbALpbWwNUUSizYqqel9bRrUMh4DWipg27u2stVU5NcwKLOivW/PFSYPJdSFo2nm1mttX
	rJPSK/Ww0r4BJNP3ceoqq4kRrVb48QfJ7CeDmaVncUG7s4Iu4G1pfx3qV9w+xFVrSpCmM4
	UOMNyiMQ6LtNz0Q7pxMN6c5EYQXc6qw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753692258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5z3VFCWPYn+gmTSxxeyfj7eJ1ITAoaTTjNvudffwKO0=;
	b=Z7aI8LO7JwauPGPdl4A6R6xRloruLiNcXTXq2a/viUAsBDd+7pcO0fSjaxHZxg1CbAESd5
	5XoDsLIn9uke81dJGO3YYt0eLztQ+CG3M17gu2+IVWWtTMGLTLfz9uChZaEkoTO1tk9bDt
	jLdkB1TTOQ5RPVZM+I7Rh+6h4OsdRtU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-411-Diy88BMuOM6cECr7rfQvCQ-1; Mon, 28 Jul 2025 04:44:16 -0400
X-MC-Unique: Diy88BMuOM6cECr7rfQvCQ-1
X-Mimecast-MFC-AGG-ID: Diy88BMuOM6cECr7rfQvCQ_1753692255
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b782c29be3so1035430f8f.0
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 01:44:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753692255; x=1754297055;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5z3VFCWPYn+gmTSxxeyfj7eJ1ITAoaTTjNvudffwKO0=;
        b=baUYCzNuxOQ77q3Xja6UMuZYAUaN5+JkvyfqFRsbK3rzSmVsFUstPNSyT/8jz3OMHS
         tesXIP3RnXUQBLciBklMy7MiB+6qxvVsnYkIRv/sWBZqJm1p3kBa9vDrUPcB2z3xotR2
         LWoGyDjDhc7zglr1hM8w7fUaCQF282YK7dT1YnimeWywCbPb5CGIS55fUmEuLT3P6N1U
         GduzD7M/m3T0FdHk03llGDAhCByTsMlHauaKXXHtLaNkFyApQo9J8z6w78aPzqNbzop0
         zDlCKGATUi1vmJ4k3gKXjmFR+e37i5ZAEAIk3k9jVUCTfL7sLuTAhJFGaewgT4BY0ZB9
         eydg==
X-Gm-Message-State: AOJu0YxI9uGYC69SWAAr+pQJd1tUuAD+rQKmAk16SsEIzhpobo7iyO3i
	pOxkL0DMkl7GVqcOuTzFQHRqyUcdSuOJCJiFaRFxl5x2EruLUkOe3szKE4OZwgJfUax8WjKkXfS
	o4gaR1sNhU4Rg6KpcJ+Q7Bct7N01phM9dNctfLuyfsmT1FRWfVBjk
X-Gm-Gg: ASbGncuobfarW3aaPkpon3NPIqpXGSBtCovKojJPuVeqVnDnYC7SK0+frVU7FYARgNR
	+VNnb6dVTaTh+ftdvBcrT+G7sPLeIIw+mnnkThVzgRbagpT++uGcMBystWkV4KU7QKjsrw25irK
	I9SO2KIegpSzYbywIViw2dmoJizUlykd1ZrOWcEZC4AUQsRNl84fizef9cs4cjAAiMJ66zci4MA
	wGAqJr6+tJ+IZblb5Biv7eiM3xn3jDRdshu3YNxuiLcTVTlCZlW/KNzoV3tlxSO6gL9lOP+whym
	BqIQ7W/oLlCOezKqFhmvlLnwxig0coRTzehRpt3B3jqJjqLkC9ddHa4v9jtsFoijM/c2WoWSxe/
	sRC0G01MQDGURg/lPsSxJUbN3VMD51pB+yPCbdQo10HzmPn+tnjjjewqGdxX8rkUNhHs=
X-Received: by 2002:a05:6000:3111:b0:3b7:6828:5f71 with SMTP id ffacd0b85a97d-3b7767269f8mr7807408f8f.9.1753692255081;
        Mon, 28 Jul 2025 01:44:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHd6G4uLhKMUYr/Rv5FJNEPLTk3+fMSTOpDvXYMNFZlfI0HQaNGucKbuqA4Wirb9CWkg7bKLQ==
X-Received: by 2002:a05:6000:3111:b0:3b7:6828:5f71 with SMTP id ffacd0b85a97d-3b7767269f8mr7807386f8f.9.1753692254590;
        Mon, 28 Jul 2025 01:44:14 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f47:2b00:c5f3:4053:2918:d17c? (p200300d82f472b00c5f340532918d17c.dip0.t-ipconnect.de. [2003:d8:2f47:2b00:c5f3:4053:2918:d17c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b7811b82c6sm6510602f8f.49.2025.07.28.01.44.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jul 2025 01:44:14 -0700 (PDT)
Message-ID: <4057479d-6ece-49a2-b823-99748e8c9c35@redhat.com>
Date: Mon, 28 Jul 2025 10:44:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] Disable auto_movable_ratio for selfhosted memmap
To: Oscar Salvador <osalvador@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Michal Hocko <mhocko@suse.com>, Hannes Reinecke <hare@kernel.org>
References: <aIcxs2nk3RNWWbD6@localhost.localdomain>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <aIcxs2nk3RNWWbD6@localhost.localdomain>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fubghcnqVoZJ8dNxTbl6mqHPP-gpLZmqDn9L13blWcY_1753692255
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DA8A1A0002
X-Rspamd-Server: rspam06
X-Stat-Signature: 51yj41zicshhitknchtyhbucci3is3qw
X-HE-Tag: 1753692258-438556
X-HE-Meta: U2FsdGVkX1/hwmonR8e/HgzdjLIlWzm/w3FM8s/CKNH8v3jrMP+LB6KO2qL6AofTzuhI61vkyH7ycJVTCd1doxiPfz/beHxR+BU12v9j1ZAiLlkAMIPsLECh+/YGESTf12JRDaU9u/P/bt8h6tejMaUZ8cvthe73Xx4SJtVfCbHfOyuvq9S2n7ZzGFSpSVGYTFa7EbcBLPDvU+8lnxVBwtg1HIY/0ztOdv6XVoEPpWUr2DBc/leLn4rEDE9C3ylylbkeQ/WO0C6HLdmo5Fc/G9zMN0iv/MPOjCzZ2shGT6OXto1LCUN/AHUz2CcI8WSi1bNknwxA0n+f3TV3+4Ua0yI6YSwdKMmf9ybnLeQciENKgoNdReCPgP9NeOnrQdtSGHC2dsEbdxFSavf/eSJVeOrTf8aml03Ek5Pxmq+nrX+IXzzvA5DWxvRcK3xZKLAD3Fu0HByjXBY2QJBWYRwOZWLDErX4t2uDMLtoctGWtFYR/G7gvxV5G4DefmqLuqjNJ53CUkMT2i7hZP7ELCd6jJ2dmJK7lAY3gsStwlfFm3jQfOC9kWRxT7IwvwBmEejdyng/lvngV/cqgEOhbeWXlhobM5T0ncyGFB1+J+qYFR6STqB02hx0VHZTbDzL6qMLL560wtF9ZD5FuX3V7T9R3a1d5UsK2VoW0KGVc7XQTP/7frK9VnXYtLetscCYvJ4YC16ZQzHO6pAOleDNwuF3p+OICjJN5/EEM3jF/CPN2IjYgVnyuqcilOX4zSla55VWaiejCKxbdIfarJHKUrueMgqYdPz5QE34k9bHkevUPvT23WDfTjjPMasfGem8lCpo0G5rGC2OjmJcB42/qx8AEJIhO5LJ4sqF5zvMf6ne+TihkvciosLwhlAw49plI2qwhGxl7uoPd70XPIlzDN1s4mtRZI8F2YKw/7gMH9t0Hxb0D5RiDPHIqq2EdVBlJfhaRCTYElrMQvYvBp7ZMkT
 6kbtrdRw
 rBszD2nUqlhtPZYZxq5N0OESxAHoMDCXNqdDZXSUZldde9Iwg8wvUiLwa4d8gH5nXtEfPRxFfb9/WIWTdj2dpbAgZtJvRcSy5R5i5C/jx1zxt9YmSmGs/uzteZtnP5peXZmHfmRHKm9maF+g7nHVy1aG6vu3ifAhyvRyxE3LSjfvnJvVUXIinpdA4f9N4MIlAaeC5mcRDsDd46K7jW91QdAub4AJkqRFNmbEixuiEiXYjfhhaBuLXJmDIhc76GDPjQlk5qlsT6MCl0djws0+lDdUoz/8vZymNM7WRMbEsCymEbafRemLF78lnDvTxWjNlYOwxKvqSwhWuBhYPILxFVaLuCniBj7Oy6mozoegZH/LRQGXF0RWqKlvxx/mblzaGMVZGcaIaRp7ORmrETavFYA8aFoYXMDjqmamkJkdkrevPoVX4smtHzVqNzoExkll9aJVGHc6uxSaa/cZnQwCiTKwhwRoTROX+JNjYh6ZHDb69yIHxIorNxNDJztxEcI3b1Yo3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.07.25 10:15, Oscar Salvador wrote:
> Hi,

Hi,

> 
> Currently, we have several mechanisms to pick a zone for the new memory we are
> onlining.
> Eventually, we will land on zone_for_pfn_range() which will pick the zone.
> 
> Two of these mechanisms are 'movable_node' and 'auto-movable' policy.
> The former will put every single hotpluggled memory in ZONE_MOVABLE
> (unless we can keep zones contiguous by not doing so), while the latter
> will put it in ZONA_MOVABLE IFF we are within the established ratio
> MOVABLE:KERNEL.

It's more complicated, because we have the concept of memory groups.

Dynamic memory groups allow for a mixture of MOVABLE vs. NORMAL within 
the group, static memory groups want a single type.

Hotplugging a large DIMM would online it either as MOVABLE or NORMAL. 
Similarly with CXL.

> 
> It seems, the later doesn't play well with CXL memory where CXL cards hold really
> large amounts of memory, making the ratio fail, and since CXL cards must be removed
> as a unit, it can't be done if any memory block fell within
> !ZONE_MOVABLE zone.

So, user space configured a ratio and the kernel does exactly that: obey 
the ratio.

> 
> One way to tackle this would be update the ratio every time a new CXL
> card gets inserted, but this seems suboptimal.
> Another way is that since CXL memory works with selfhosted memmap, we could relax
> the check when 'auto-movable' and only look at the ratio if we aren't
> working with selfhosted memmap.

The memmap is only a small piece of unmovable data we require late at 
runtime (a bigger factor is user space page tables actually mapping that 
memory). The zone ratio we have configured in the kernel dates back to 
the highmem times, where such ratios were considered safe. Maybe there 
are better defaults for the ratios today, but it really depends on the 
workload.

One could find ways of subtracting the selfhosted part, to account it 
differently in the kernel, but the memmap is not the only consumer that 
affects the ratio.

I mean, the memmap is roughly 1.6%, I don't think that really makes a 
difference for you, does it? Can you share some real-life examples?


I have a colleague working on one of my old prototypes (memoryhotplugd) 
for replacing udev rules.

The idea there is, to detect that CXL memory is getting hotplugged and 
keep it offline. Because user space hotplugging that memory (daxctl) 
will explicitly online it to the proper zone.

Things like virtio-mem, DIMMs etc can happily use the auto-movable 
behavior. But the auto-movable behavior doesn't quite make sense if (a) 
you want everything movable and (b) daxctl already expects to online the 
memory itself, usually to ZONE_MOVABLE.

So I think this is mostly a user-space problem to solve.

-- 
Cheers,

David / dhildenb


