Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFE0DCD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 18:02:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EBE56B0092; Fri,  1 May 2026 14:02:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C4696B0093; Fri,  1 May 2026 14:02:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DA696B0095; Fri,  1 May 2026 14:02:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1C50E6B0092
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:02:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A4ECE1C0100
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:02:38 +0000 (UTC)
X-FDA: 84719621196.18.471F66E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id BD9271C0016
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:02:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uuYupSW5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777658556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lKq61IVZIm4Yb02QDgIwH+SIALvyu9Q+/uRuFATbUsI=;
	b=N0jdJnldxm0AyNEcrs9/X/2DIQlCy8+5BtzT4ti1Fjs56Kx2oj4zoqqVMhO0bVfdKy/Gc5
	9/WPUD/lIlPcYr8NEDmudWra/hcJvwVYl0bKH12Gn0IFXR/eWQtiJJvKGWYY/LjLCgsiSQ
	8r2CcPUWPR80D/3IMyqqrRq2uXFjnN8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777658556; a=rsa-sha256;
	cv=none;
	b=5LNhOZ6GN6lSfmFPyQDbWYhBJqZZoebpU2tSaUZkgA7FPAwcrkF5HBbyTqGC9SvBPjiYng
	dUbieElthfnohOm6iv1vYJLxdjl1+1xUQqMofGP0KpPxm3CI2uZY1CdQWhrlzH/jAHGUvx
	v5b9VOmWI5i6yud51aY3r+s3x7dHrPQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uuYupSW5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 069C0600CB;
	Fri,  1 May 2026 18:02:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41920C2BCB4;
	Fri,  1 May 2026 18:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777658555;
	bh=cISpscXftIVW35927MGW1f/hoEuL3QHhaFwXy0DNSo0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uuYupSW5k2LpfC9iWHYvQnjtXdPplnUCS4zZH0iwWWj2qk6KRSbIdEP64j2gjsR5E
	 PxTGZOGIG0K6SOQOGUJxZTd+XoNb519TwLS2rXPgryJntDsNBFzVvkdY4Kc6PPlDXp
	 JSyIzbmPfu8Kkk0QLjDLn0hg9bjkW9LYdr4By3XdsBrTB1mQ2w0koM1pUaAPNLGo2+
	 4cQ8T4v65CG0S1sSi53Ze4TrNiw2ZkH7LdqQh6CBwtpok6NDcZRMBwH1T8LDxfIKlE
	 9G1clGJsPsd7PH/6rDTvsKZaZIIvUYuHBMrsXq8zeJV809CyXf61ox18x0jZ2EuVr5
	 BD5sIVaRbCo9Q==
Message-ID: <01ea8acf-69ee-404e-8785-59fb0a527253@kernel.org>
Date: Fri, 1 May 2026 20:02:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
To: Kiryl Shutsemau <kas@kernel.org>, lsf-pc@lists.linux-foundation.org,
 linux-mm@kvack.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Usama Arif <usama.arif@linux.dev>
References: <aZcmlIF4bmG0twkp@thinkstation> <afTjKnO66Hl-XmfW@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <afTjKnO66Hl-XmfW@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BD9271C0016
X-Stat-Signature: ie5cyqqt4h7n1w8rbdwdztusd1cxzz4h
X-Rspam-User: 
X-HE-Tag: 1777658556-741266
X-HE-Meta: U2FsdGVkX1+n6GhZqOW0iU7KDUcPyU6sgw55r/XiroaIc0EWeANldWpmF1y6jK+plXbavhClP8Fr21t+/5r/aDrOkEZ1+u0PBA3DX+8esjgOfljpmrNmWGby6HyxsoXFDia1QOkXj5p+aWGg/OQ1kQ55h6yls+zqjX5SCmL1Qv7xSCX/a+20W/Bpxf8/6bfiK5Tq4dKp0XI7qi+yOMb30VP9TtFokrGbLis9Bopu2OVltzZmUYFG0XofZ/0HFaze6GNXYCMDot37h+h/hXX03Mo9k4TqQXlxLFUPkPNIQuh528AumsTyQ4D89UpJ4396Ip7PynVZuSHVOCDBpBuDYQxO1M0GiJBcFikpqjybdRzGHJljpFLXqqNNbgt3TaCdExX+jE3KVnTA9GKoIsdFisKRw27udPrtYOdnbCVouWLUgMK5K/tB71UNowfeqypE+tT26c8bywl4DS7ycpw19SaGIUbKdNrSe1RpRwAsPyG+8PbR4ACNsaZdsSjhq6vu+w7VZt4U1f7vRFXK7FzO4r4XGMlLMTBpnHNxfSltrWqSu6rZ9laNxIGopRtTAqzmiy/C+W5RyP7wxo4GYziZZTIh57WFrAWu+ikllcf+LMoCCKhVQGnd3oZ7icuuugagqAU97vXy+51JnU2td17yeDlqRyZyNX9mMBZMrYJSqm+FWk3kBF4hHA98pYxYCNLd73VzQTt7Jf3Ia9xndV2XaMn9CAxCGECwJz11stRXr3mgBHWBvA2PgldWRFLxKgrtMb/tZZgtm96LfvNiUd1uyan8Tav8++hVVqQuSoI5IP9Bgq44xWkZ7ORuvbxgRgI1Rw8TLEWR1MdxR/9j8X4kTiSTOcP8mt7N8yHmx4jSITDrDfGv2IhfWQhR/OsuJLqiaTHh58wd35tntOxF3bUhAIGazmxV/J/a/Tw4e1+eKx3E7fFejDwIo2haC+R29chqmdZb5bP+hTg56Ei7FRG
 rdsKPNzH
 QHUJEMhgx34ZdrnTgAJmgjxaub/NKWaRmAQ+BW7dtFP2E0kQX57Fp2HazVJVmQQaw+E7VgNMuGwQpoKRnzMB8w+7nYhr4ZE8FyY0DrZffDr7hqkY3tzSWireCo/vExAm9oE+VfVol9POfFSEXb/4eBxn5Cw/fERvkoqWu+vKg2W3kxv01ptRQpDk5oGs0/onway/0HxNEkZzfsUQ4qZHcLgj34kXgr548NheExyxjD44LJRtCAC5T3sltgUUCpLNIWDXnhaP62eYGwT2gnm/mueiPOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/1/26 20:00, Kiryl Shutsemau wrote:
> On Thu, Feb 19, 2026 at 03:08:58PM +0000, Kiryl Shutsemau wrote:
>> == Status ==
>>
>> I have a POC implementation on top of v6.17:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git pte_size
> 
> Just a heads up.
> 
> I've updated the tree. It is on top of v7.0 now.
> 
> I can boot my VM fully (not only to shell as before) on all three page
> size 4k, 16k and 64k. And it doesn't crash immediately.
> 
> Page fault handler is the most challenging part of the design. I wanted
> to flash it out to RFC quality before the summit, but it is not there
> yet. But it started getting a shape.
> 
> Volume of the code changes makes it hard to deal with the patchset:
> 
>  1530 files changed, 12675 insertions(+), 8669 deletions(-)

I think you know the answer already :P

-- 
Cheers,

David

