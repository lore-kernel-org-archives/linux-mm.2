Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCCD9E98E06
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 08:44:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45DDA6B0088; Mon, 23 Feb 2026 03:44:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40B9C6B0089; Mon, 23 Feb 2026 03:44:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E3596B008A; Mon, 23 Feb 2026 03:44:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1C6A26B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 03:44:57 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AAA02140888
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 08:44:56 +0000 (UTC)
X-FDA: 84475086192.29.4180793
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id D950620004
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 08:44:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="f/kHi2dx";
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771836295; a=rsa-sha256;
	cv=none;
	b=MdNpBNva2hhy0AcRqQTM/iBf16E5ok/7gfR8vVRCnoptgkBwMQw88ZrIL+MoVgzJcMuOiq
	N+ijqm2AzUN404gRIicfD00GH7dUuz5jj8hw+bvz9BaBZ0I87WOW4Wbdtx9D/Hpavs9MPU
	WYVshDfScmpV9fgCcqW88pNQ8vLWTn8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="f/kHi2dx";
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771836295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2e/IHxHL2/j24Vo9ZstseLtXcIvbuGbzwd+Pn7rt4j8=;
	b=ikDRE4T+QrgJ+0V62rfpSDgmOXe6X1T62zlyS2/4wS5Q5mOcnlhS6fE2TlGK7kUiKvRhiM
	m/pulYXrz4tAllEOpqbZEBLQkxRVGjkCU5BoQKWC5t/KlHgb5dfyGZxxerlTVGOg7OMtyR
	KoBTVCCMT8BZgXNNcMjkewfBDz6/p4w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CA24B438FC;
	Mon, 23 Feb 2026 08:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D23FC116C6;
	Mon, 23 Feb 2026 08:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771836293;
	bh=YOHTRkgu15kmi4p+4SzpUvZRvBoTDJrdzH3KyrJlwAA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=f/kHi2dxkyZtsvFNz/DVLEfo8RHrRrTvH/udh9CaKEZfX+dZnDXRLt0ybqLwECguD
	 KupYYsDHFUBg2loIi6EcJQKgJNQV23W+Ceaq8r63SITdHPV6a7kGj8k7p38W66u6Ic
	 45idNlLPOjpgxTSjMFEqBCK3wOm524W2gJuet4FsdOQXrn85FpCE/iDNHrPQHN11Vy
	 eiluFqCPMIVfx8/beleS9ONbzLRmayLCSkizKbhQ5RaUB2rWEvUzPepcTn3k8mIchC
	 aOypTSEQf/kY6ARL5kw62yB/ErooinWHUamNl0h0xUtc62lHmXwYANv2svzfTnQ3cx
	 aTjucjhmPoV3A==
Message-ID: <be04863e-55f9-4789-8222-1785030c167a@kernel.org>
Date: Mon, 23 Feb 2026 09:44:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in
 file_thp_enabled()
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Ackerley Tng <ackerleytng@google.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, seanjc@google.com, pbonzini@redhat.com,
 michael.roth@amd.com, vannapurve@google.com, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com,
 Fangrui Song <i@maskray.me>, Christian Brauner <brauner@kernel.org>
References: <20260209033558.22943-1-kartikey406@gmail.com>
 <cbf76e1d-6b5d-4072-9f46-027cea4c0478@kernel.org>
 <CADhLXY5nrTXmWMPeiLg37euyVeQsNDRUvKmQaPdxtE1YhPq_jQ@mail.gmail.com>
 <CAEvNRgEoPs5ia+u0ODra6N4BdOwpYa04j8nDxwfNVyfCOWnM6g@mail.gmail.com>
 <4ed1b111-f2f1-4f89-9308-fdd9d706ca37@kernel.org>
 <8f188d73-fc97-414b-bdaa-e72032b2bf82@kernel.org>
 <CAEvNRgFw_P-GZ=Z4irGheM4O-RnXkd_bdAd0AT7fUuwXEnSqHQ@mail.gmail.com>
 <c4c06a75-e50e-4530-80e3-13724c08a949@kernel.org>
 <CAEvNRgGg245-TQn2HFSadZ7gmz-FxsAQ6=N14BUgiYGHhZeLeQ@mail.gmail.com>
 <bac19363-0705-4bb2-b022-66054e1f28cd@kernel.org>
 <CAEvNRgH6yfFtOK3E3__hCjkNTQr55y-_N=SpBBr0i9_q6E2_8g@mail.gmail.com>
 <5eb7aae7-f642-43d2-810b-d7afd867d665@kernel.org>
 <CAEvNRgHegcz3ro35ixkDw39ES8=U6rs6S7iP0gkR9enr7HoGtA@mail.gmail.com>
 <CADhLXY6zzWJnu9ZLH8jThMx=z6JpYmnB_jdxRJe=QVjEMu6WFg@mail.gmail.com>
 <f3252a77-f41a-430a-bbb5-2f6d3c8a7c2c@kernel.org>
 <CADhLXY5GpPAD-nKZq-eP284cgP9KSh0RJs+0HRfEXZgka7DErg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CADhLXY5GpPAD-nKZq-eP284cgP9KSh0RJs+0HRfEXZgka7DErg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D950620004
X-Stat-Signature: ys9e8o5b9h74yu6iqub5rd5m6fij837f
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771836294-938056
X-HE-Meta: U2FsdGVkX1/Oa3z978SbGPOUXRX8OvtdtWJ8aI3jrBN61tEc+399KSL8HUSKaeJkt++OdomT5PO0b8hHqZvwT8uStsFDPlNcrSkAVYMlJBhukHUFa1pGPhEJrJ2QesdSkbK7BlmpI4uIFNxlVIKG5Kon2gGpFT+2im9XFLvtkM5FP5+PNzMIVxzjh5CCsHuqK//Iy8OdPXRL5nv8uuTX8x+prbORkYg11vvV/rWPFFMjKQ8LR0kYI1vR3w4eqf1jpaAvDjHVfuMsN/gCS6nGj43zjmPHJkhQcW4Rm0CrGamhCfOdd8cEJn5D1geuI3kMmQG/t1k/7vJRIUtql1mwoGWQ6kcUX0vafwURXUFcvyjL4hcR298/HA3wbDWRVUUBVEiN4ciiGelR+H88zV3nSHOR36QyO9bi9JQKAQ098lxBOMrXMOmb0L2b2bveEuXkc/OWE6EYVaO23tocVrNjY17r4a4rRU3fa2d+vxmw9fCTJwfzk+MtH0r/BCuDfOzBHLXzZGPQsXXhkt+Vnmx4JmZTJD4RJ4HilTM/QVOaWGjv9Pm9pzDGCJGWtiBKPopLMaahmo1nHj9KYmP17VSuHQ7BcBYNRFe9RjLYskozyN9X4KEh8w2OMC/87W9aot4Q9zNyzOWpzNMmhYgN+wLb/GhRYv5mf8/NijD1DOkKhc5jDeO+yRn0Wl174Ij6/GkgaY0XnIwn6zt1fSKpyKZPoQlS2IeExQAnwGWoUsqrE86QxwvWZtYM9y2H22tw1Hd18JJd5e5FmK6bhCya/TPuOf+gNHlX2cW15Uy9VBYgE3PPHArN3m84MOhbU5I9X8bHC2d6ToqpPhPNfJAE/t588RezthNlNlcweXAE3RMtoBGeI500kPqziWwi6GbxBYsIRS9U4RUXmevXwRBfq5/KCb0guUqjuXBjOmlNj4h6iwRRjSFj+OMEugjvtapQfCLDypTGTXa6sT8tsnChmrY
 hv+wn5IC
 uabsq4ZIROGx6D2iRojgYs1kB6zTDp0qC7OGT9hfIHEwMBSUjZgdMDgua9F1qzJYClpe3Pb2HGYr1xsbMFESCiS06YZAzB3uG9TAiO94SJHPynX2+AZ4Wsttv3mPKsSazMs/toa3ChCdwOFXcIIGsVcOmo+Iw8cBVlhwbGeURvP7E4+srL/5wLzmUmoBdfKBdQH0V+BuGlvinzvcVKPmUW6/G86XCljAEsAwDfsliqMQO2Y4otX+QuNYet1m3RxvqzzZY7ritgpAJrzHTy1G5mWL71osks6ejrawwgxGt+2yYMdwm6iuaimixnJnkiB6bM66Pd/h8vdafM+em8zMP6U+3pkAw2syXG2EPiPxUWfHKBWl/rftOdgU0ivbCL3KvhaXZHsbR8m1hWelr0FzmodX9KNtqHg/PcNoYSYziIwAvnhch6Ev+Fxwe3l8WqcuSvE+s
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/21/26 05:37, Deepanshu Kartikey wrote:
> On Fri, Feb 13, 2026 at 2:36 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
> 
>>> For 6.12 stable backport:
>>>     - IS_ANON_FILE / S_ANON_INODE does not exist in 6.12, so use
>>>       mapping_inaccessible() || secretmem_mapping() in file_thp_enabled()
>>>       instead
>>
>> I think secretmem_mapping() is sufficient there given that guest_memfd
>> does not apply yet.
>>
>> But we can discuss the details about the backport once the upstream fix
>> is in.
>>
> 
> Subject: Re: [PATCH v2] mm: thp: deny THP for files on anonymous inodes
> 
> Hi David,

Hi!

> 
> The upstream fix is now in mm-unstable and linux-next. Should I send a
> backport for 6.12 stable?

Wait until it is in Linus' tree. As we CC stable, you should get a 
notification that applying the patch failed.

In reply to that mail, you can more easily send the backport.

> 
> Since IS_ANON_FILE / S_ANON_INODE does not exist in 6.12, I was
> planning to use secretmem_mapping() in file_thp_enabled() as you
> suggested. guest_memfd mmap is not present in 6.12 so only secretmem
> needs fixing there.
Makes sense. 19bbfe7b5fcc ("fs: add S_ANON_INODE") does not apply 
cleanly to to 6.12.

-- 
Cheers,

David

