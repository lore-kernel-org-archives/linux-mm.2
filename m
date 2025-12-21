Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12597E67495
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 02:10:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDB3D6B0005; Sat, 20 Dec 2025 21:10:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5EAF6B0089; Sat, 20 Dec 2025 21:10:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C345A6B008A; Sat, 20 Dec 2025 21:10:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B2F936B0005
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 21:10:49 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 512AA8B407
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 02:10:49 +0000 (UTC)
X-FDA: 84241849818.06.E89D64F
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id 49D55180012
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 02:10:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kyxL1zfw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766283047; a=rsa-sha256;
	cv=none;
	b=Go5MzR2H0yq4VcNYgDqfURzLHap5e/orHlaQ3H4jN1LsSLCVuEHtirBp2TrgFKTGOQnTZj
	bDNiJNMrzPclnh9C3VOGtI5fwXZ1JXokqx73CRpMkzjuTIYolIpXNIaAyUHNhWquyeFA6I
	F65/6zyWMykbGFa4QnDXacCBhBMdzPY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kyxL1zfw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766283047;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D1IALJoem7ouE554nQQ0FVgOHYidFgLlzbJ1kR8CnYw=;
	b=b7AdTfqeYOAUmG8HsDD4n7oMZ+iPvaxoBc8B0HdiBzSMOxgKjtc9y+mI6D5LwnaX5wTEuL
	dygTwPMBor/C/snrwOEn6Udm2kOMtTd+n/2eDe8T7pNCZvIdGtUZvHl9KL+LbOb5kDvbHZ
	QyiRBnyfCjVP4fVFa0M8eQySV4kicO4=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b7355f6ef12so546558266b.3
        for <linux-mm@kvack.org>; Sat, 20 Dec 2025 18:10:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766283046; x=1766887846; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D1IALJoem7ouE554nQQ0FVgOHYidFgLlzbJ1kR8CnYw=;
        b=kyxL1zfwYyIp1X2QY/oFc2hLD7SRiARw2/pu6khwn153ctYkIymOXebF//W09b2epf
         XNw/ClD8O9mZqh2jyZz1WIMtVBHEox715Wp0SlAPrcgd2Ts/UZcJ4IlzTY9i4hviLW7w
         Z8eAfsRfJllmIZf/sxgwAEHWwEf6n5Akq64Xae/HCIECe+HVQJ/2Sp+IJvJdthUyQ0HO
         aAnF9LvPrAm3KEAZg+MItEiGi626QtnyJORnSSmuFzD5tN/1KMEIIaGS8hT06YLYEHjG
         lcyQ/oSE5uZ/vMDpmgG9YJMbS3DhG4JTayL291lAxJbg/7c6g22UdpUog7Zb9TAULidQ
         XmIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766283046; x=1766887846;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D1IALJoem7ouE554nQQ0FVgOHYidFgLlzbJ1kR8CnYw=;
        b=jF0vO0THlMCAVsHZtp8X2K9p8F63FU5Io0Yyo4Q7M6Qy5jg3NoTE7FYCpm4oduqPi1
         +h7HS1k7F+/QeUwK9h3tWLM4hTRmLO+K8js7Ey5tNDuuE+nfiVbTebkNW1zqjFUMpwbM
         FYXVFv6hjxt5VmJAR4TSICqmVIfNTH8re7yv73aSX/1ERnCjRhxNEFU7zebuixX15hX/
         14F6lEtMHL2wgTcPtrkXIt2iM87n+/98Q82xY6DNJ/2HabHOjlNKHx/ZM8YUEtiW9yFu
         Ci+BLhenwbVxt15LIwD7uoU2BfMfPCwpqv/ORLkx3G/RzVNmndHrib5ba1FwFEzjq0UJ
         RGaQ==
X-Forwarded-Encrypted: i=1; AJvYcCWpX07oujzy08e9SFCjwI5dVFHZ0mI7XQBbbNYt1QFjpEsdZ4wLkUXdm5e03yZultP+/C8Vd23NdQ==@kvack.org
X-Gm-Message-State: AOJu0Yz8i4wy4wmvxsEKYM2k+m87yprLZ5xds/IPSM5uFur6w4ozkn3e
	H+1ePgMcV0O2hziVROpIF3dpj/gkkoU2I3SkbQeFZ/0AAP//UK5xa/1a
X-Gm-Gg: AY/fxX5KSD9Jc8yFe9oAHf3SuNBG3csnp329qY0Xcy2+KTOV2b6Ltg4zA1arLWFJQKk
	byKVrOI9N2Aqhc2LvSXKzrvouR8L4vf1OIqGyPL1C9yrHoWKS/HRHmZob3BwtG1n0YIfb/yh3Ii
	7uNzzfRY+liwyOXwClu9PVBBwfm/YoABjiQRlSnzI3zW94NS5QmBXXIwjQn+OUpVRISptdTysU5
	OmtSHRahJBwogQS3F76BhnQjI3dDhRASgeqM8KL4d46A9viBn1Z0s7IRNi/3VkycffAW87SrJh1
	/VDEqSzzyIcFFG6iK9nAUUVJhhmOdma/9as5JbGAsC5DOHYvGRNBgrHEWXBRM2mqRbpNzqepUMR
	eSjoCrYKxvo4gPVWmIAaFGMyI36gfWnuEcP3Z8+coeGip0vY9KuFkoKiof4ua/wpBvxl1aIPkv1
	ohfYvuo3bUreHRzBDRa/OB
X-Google-Smtp-Source: AGHT+IF4/pDPAGPL8ps7I03GKKyl4mXVQ7FCC68KL0NGqUkYi3qeo9Ix8Rj3iK3veky8o7Cb9LbRFQ==
X-Received: by 2002:a17:907:6e91:b0:b73:8639:334a with SMTP id a640c23a62f3a-b8036ebd999mr686070466b.13.1766283045562;
        Sat, 20 Dec 2025 18:10:45 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8037a604f5sm653526466b.11.2025.12.20.18.10.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 20 Dec 2025 18:10:45 -0800 (PST)
Date: Sun, 21 Dec 2025 02:10:44 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, baohua@kernel.org,
	lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH 3/4] mm: khugepaged: move mm to list tail when
 MADV_COLD/MADV_FREE
Message-ID: <20251221021044.2r5fhepiyyhvuo7h@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
 <20251215090419.174418-4-yanglincheng@kylinos.cn>
 <3c75d915-5d7f-4e80-975f-4479393e7139@kernel.org>
 <tnvhnikpfxyjassrdsnqmpxlem3hnoepwxmp4hysfzqzl3wltw@7utx5hxc52th>
 <6e8684a5-1f71-4be6-8805-9b047a2bcb78@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e8684a5-1f71-4be6-8805-9b047a2bcb78@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Queue-Id: 49D55180012
X-Rspamd-Server: rspam10
X-Stat-Signature: gmnrfajsqukgcn8nhwgaegmha98xi918
X-HE-Tag: 1766283047-495473
X-HE-Meta: U2FsdGVkX1+G/X52CkcFO9wVhfi0xnT7lm3ORmqrr7TYKGD8t382LzNB56SQz9sfr9jjQ1q7n3wXc0m02hdvuvMOjax2x1dSrqK6D9e1GDkg2nsSaOn8bIbk9/2VuNBkHjJoakQLnAtE123gI8Iqqy6++HxZAQpqPPu3vbCI2950dcWlTO0DsK9HGDHMzu8H12XyRsbMC18NhVhsKtGr9bnFAXATYs81PdYyzBAxtAKZF3N9DXVgD+vOseQJm6kX4YH1ek+cSEmycUFn9gO674taYR8DOgW0X7zWLaS99xzAXDJqdtN36vPCdT7zByOkwwv/97kRriaKEIQiH2HW8Cyw4ardeXXppXkqc+HWIF6Q/2GD8qm2bekeoOzXrRZl1VECXoGVp+dAG488FxfgZyF3Ny9iX384Sd7Rcg8SP9Nyr3uXXcQfGqVn4FfDZEGMT6+7r/4sAcNo5pyJry2Mk6U280sCH4BmlLtfqoUNAThma2idPBM9O4OgS5kJBCzWUp5jFlxbb73OMQHb6c/Z11NgeT7VegzWk5dyertFFh9mJrC46mSmVuGBb5DFyea1fe7D9y6wPx38c2wTBYl260oCKsEhBDyJuiMEVhgoeZD4On9Yn3TObmeSESE3ZOP3rN/GHVTZC+7nXfynt7/fv6WmLWPzaelmBOzHVP+Z6kvWGvpIOdiytGmOozexJh2ijlcu63cG9h5Y0rn2HmKDwL9AqmzEQ5s0vMEF1sBk2togkMxsWXmalx7O/6X7mgnMbMOCWfUNftxCMRLKpn/UndXHWcui9biSJMo+PwLmL544uF/M32KdayC4MztIpGSD1Oni4KFJQ3uMG1EF0GpJF+3mQ8p3XeJ+X4i4Il4MtUHhnHjc78xOwRZ4rWU8usu7ZoI1K7C2amb27TOiCCkTO9uEyNC9XyNLiDiwM9ohuBNzEbzLjATyFvU2vwBMbtXt2JPgDGxP8Z3QbS3axDW
 MVxByuaN
 ojxq2MBZNMRWSfPobHTWgvOF6PUwjq+St7zBqSywU1J05wYRQ1wCRvlCzKCA8+2x4EUQ5YQxlhtDmq0YPPACElwJ1e9hVuWck9wndBtE0r/UskwSnfKiBc4mtIQ4+2xUKL9aVDeqjtBSfrwbAnADvUYopmAOhlv4QgQx/TU297+CTP7TLoSx7EE0MZQlKdMyDFkRoMTPRYbsFzwihZwyTaa6zQ1UeyrQyF1sjwIVR5mlqv8gHwLVOVljHcvwebfBG0vuLw4febHVPlUmHwNIQW/JPN+kaG9Wax9PR13fF59R0ZFiusqzg/Xlb07tJQGdMqZlR4kCho5ZO/uwXb1+9HjvGaItC/P+4tEmrtQNoal+ubdX6fah1kmtwtvd9abr0OxNMxTj/qNLcWORN8i+o4jfJLXFwL17ujvjLgRMbu8faD6RF6bCcYD65V2EnFA1FnSTBfWMLKm6piLl7v57SafOUs5ySlu2zJYiUax7+28DrcChF8Rb/vPlLdS7OO/w3fM3F14uOydtxaVnpYBqOXZ01JejtaraqqMwMeFQ/E5KD9zPWVTO6MJO8KSJZvWT0Bvi3RDe3DWq+SF//+Rvs8wFTXBKuQw1XmWuMC8DJnVdF+rVTX30eOF6P53ZEjnk8JiiEMrkohwax+rP2T0hZVY2VuWH1USU0QDA4Q7NOSzIH0kkZH0ArCDh3dg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 09:58:17AM +0100, David Hildenbrand (Red Hat) wrote:
>On 12/19/25 06:29, Vernon Yang wrote:
>> On Thu, Dec 18, 2025 at 10:31:58AM +0100, David Hildenbrand (Red Hat) wrote:
>> > On 12/15/25 10:04, Vernon Yang wrote:
>> > > For example, create three task: hot1 -> cold -> hot2. After all three
>> > > task are created, each allocate memory 128MB. the hot1/hot2 task
>> > > continuously access 128 MB memory, while the cold task only accesses
>> > > its memory briefly andthen call madvise(MADV_COLD). However, khugepaged
>> > > still prioritizes scanning the cold task and only scans the hot2 task
>> > > after completing the scan of the cold task.
>> > > 
>> > > So if the user has explicitly informed us via MADV_COLD/FREE that this
>> > > memory is cold or will be freed, it is appropriate for khugepaged to
>> > > scan it only at the latest possible moment, thereby avoiding unnecessary
>> > > scan and collapse operations to reducing CPU wastage.
>> > > 
>> > > Here are the performance test results:
>> > > (Throughput bigger is better, other smaller is better)
>> > > 
>> > > Testing on x86_64 machine:
>> > > 
>> > > | task hot2           | without patch | with patch    |  delta  |
>> > > |---------------------|---------------|---------------|---------|
>> > > | total accesses time |  3.14 sec     |  2.92 sec     | -7.01%  |
>> > > | cycles per access   |  4.91         |  2.07         | -57.84% |
>> > > | Throughput          |  104.38 M/sec |  112.12 M/sec | +7.42%  |
>> > > | dTLB-load-misses    |  288966432    |  1292908      | -99.55% |
>> > > 
>> > > Testing on qemu-system-x86_64 -enable-kvm:
>> > > 
>> > > | task hot2           | without patch | with patch    |  delta  |
>> > > |---------------------|---------------|---------------|---------|
>> > > | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
>> > > | cycles per access   |  7.23         |  2.12         | -70.68% |
>> > > | Throughput          |  97.88 M/sec  |  110.76 M/sec | +13.16% |
>> > > | dTLB-load-misses    |  237406497    |  3189194      | -98.66% |
>> > 
>> > Again, I also don't like that because you make assumptions on a full process
>> > based on some part of it's address space.
>> > 
>> > E.g., if a library issues a MADV_COLD on some part of the memory the library
>> > manages, why should the remaining part of the process suffer as well?
>> 
>> Yes, you make a good point, thanks!
>> 
>> > This seems to be an heuristic focused on some specific workloads, no?
>> 
>> Right.
>> 
>> Could we use the VM_NOHUGEPAGE flag to indicate that this region should
>> not be collapsed, so that khugepaged can simply skip this VMA during
>> scanning? This way, it won't affect the remaining part of the task's
>> memory regions.
>
>I thought we would skip these regions already properly in khugeapged, or
>maybe I misunderstood your question.
>

I think we should, but seems we didn't do this for anonymous memory during
khugepaged.

We check the vma with thp_vma_allowable_order() during scan.

  * For anonymous memory during khugepaged, if we always enable 2M collapse,
    we will scan this vma. Even VM_NOHUGEPAGE is set.

  * For other cases, it looks good since __thp_vma_allowable_order() will skip
    this vma with vma_thp_disabled().

>-- 
>Cheers
>
>David

-- 
Wei Yang
Help you, Help me

