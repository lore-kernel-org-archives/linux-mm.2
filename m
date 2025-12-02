Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCA56CFD2F6
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 16:00:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AE136B0011; Tue,  2 Dec 2025 11:00:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05FA26B0026; Tue,  2 Dec 2025 11:00:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E907E6B0027; Tue,  2 Dec 2025 11:00:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA0B96B0011
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 11:00:14 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 85BFE12A70
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 16:00:14 +0000 (UTC)
X-FDA: 84174992748.26.938D2A9
Received: from fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.74.81.189])
	by imf27.hostedemail.com (Postfix) with ESMTP id B944840012
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 16:00:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="K+u/JhNX";
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf27.hostedemail.com: domain of "prvs=4244c82db=kalyazin@amazon.co.uk" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=4244c82db=kalyazin@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764691212;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=at/judjHhIUd9hK8QdYJp4ATA/L1ojrlyu29FEks1XQ=;
	b=gWWd7dDtwH3EEzlPfc9Q3tumrpdfcvbYvyI+St8cUDq7DL66lvtpzC/lgoBkD83W8QPVAq
	qvMHINCQhWhYhO0yCewaZpYFTSvkSP+uUK63iCgrsQJTNfE3kzpZKGI3VIXjTmkiFEQqUI
	rzUBTDPzgA4MajqAeyxt96AA3kHoydM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="K+u/JhNX";
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf27.hostedemail.com: domain of "prvs=4244c82db=kalyazin@amazon.co.uk" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=4244c82db=kalyazin@amazon.co.uk"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764691212; a=rsa-sha256;
	cv=none;
	b=b/dIimkAeiHWf5a5kUjhQ/1nw7McaG2Zf7zKvyV6VqxEdd6XLTu8P/y9xVt+PJgFGWkTXF
	Jt2djcIUMAgqt4icUztJ1Wacbd5CsoNmLcQLPvFrxRxSEfjL0gXGr8Ql7mlxcX8j+M2kC+
	zxLLA6npk3l8txlwTjpDTbshcvMpWHc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1764691211; x=1796227211;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=at/judjHhIUd9hK8QdYJp4ATA/L1ojrlyu29FEks1XQ=;
  b=K+u/JhNXYTBmudAS9UmKXunUSoB5iruTodFJSxrOWqV2AbM2W3Wt+NmV
   aNMpKXG64lH4pCfloK2paa3cAoxy76sNoszrhYPJrA2kBAxc3oKV4XesI
   UF/7fMO5Aw47j/Smh+Z9mXGHemVlbdBvX2aHGCxIO5AN7anbmwsxq9jrd
   axuZdLIiMmp8e1kwotBNFzzry0Fi9fkiIfnr92KeG4rc5FMGpIOAp8RVD
   GQsbn9sxA3GmyXDEzjNRLxAZpvsaeKJXjsZQgk5XnDkQVqyENuav4kqnh
   2B/s77kpnkkyfxT9IS9753jm46lWbM1E+xxKxfJvWR3gQojzhVwHYzgeU
   g==;
X-CSE-ConnectionGUID: 59VtwPqHT+qpAYmOgDwhIQ==
X-CSE-MsgGUID: W+eHlDOAQLWZbrDLalx6Og==
X-IronPort-AV: E=Sophos;i="6.20,243,1758585600"; 
   d="scan'208";a="6139170"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 15:59:54 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:25931]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.33.168:2525] with esmtp (Farcaster)
 id 3129eee9-83fd-4b7f-9c72-6442127ab572; Tue, 2 Dec 2025 15:59:54 +0000 (UTC)
X-Farcaster-Flow-ID: 3129eee9-83fd-4b7f-9c72-6442127ab572
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Tue, 2 Dec 2025 15:59:51 +0000
Received: from [192.168.12.25] (10.106.83.17) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29; Tue, 2 Dec 2025
 15:59:50 +0000
Message-ID: <cd354fc0-e500-472d-ac33-0bc43c0d898f@amazon.com>
Date: Tue, 2 Dec 2025 15:59:49 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v3 4/5] guest_memfd: add support for userfaultfd minor
 mode
To: Peter Xu <peterx@redhat.com>
CC: "David Hildenbrand (Red Hat)" <david@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, <linux-mm@kvack.org>, Andrea Arcangeli
	<aarcange@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "Axel
 Rasmussen" <axelrasmussen@google.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, "James
 Houghton" <jthoughton@google.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, "Sean
 Christopherson" <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>
References: <20251130111812.699259-1-rppt@kernel.org>
 <20251130111812.699259-5-rppt@kernel.org>
 <652578cc-eeff-4996-8c80-e26682a57e6d@amazon.com>
 <2d98c597-0789-4251-843d-bfe36de25bd2@kernel.org>
 <553c64e8-d224-4764-9057-84289257cac9@amazon.com> <aS3f_PlxWLb-6NmR@x1.local>
 <76e3d5bf-df73-4293-84f6-0d6ddabd0fd7@amazon.com> <aS4BVC42JiUT51rS@x1.local>
 <415a5956-1dec-4f10-be36-85f6d4d8f4b4@amazon.com> <aS8HaDX5Pg9h_nkl@x1.local>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJnrNfABQkFps9DAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPOpfgD/exazh4C2Z8fNEz54YLJ6tuFEgQrVQPX6nQ/PfQi2+dwBAMGTpZcj9Z9NvSe1
 CmmKYnYjhzGxzjBs8itSUvWIcMsFzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmes18AFCQWmz0MCGwwACgkQr5LKIKmaZPNTlQEA+q+rGFn7273rOAg+rxPty0M8lJbT
 i2kGo8RmPPLu650A/1kWgz1AnenQUYzTAFnZrKSsXAw5WoHaDLBz9kiO5pAK
In-Reply-To: <aS8HaDX5Pg9h_nkl@x1.local>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.83.17]
X-ClientProxiedBy: EX19D011EUA001.ant.amazon.com (10.252.50.114) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspam-User: 
X-Rspamd-Queue-Id: B944840012
X-Rspamd-Server: rspam11
X-Stat-Signature: cc9qq5qeeh1w37w9gnsgx4fxfmyasody
X-HE-Tag: 1764691211-369166
X-HE-Meta: U2FsdGVkX1/K90/KsDHjaIvMvXpWmwRRsY1+hM9yCbdRcSB2iYsd6EUjOMmrNCdntubithgXTtsu1LAKT0fEVx2DrU7B2aDvNr+MSjIA8w8F6M2rcqVzCrDhgr3MSVq4c2Crwjt0ZWFdXxPWqL0hykI3dWQDHuDFY7XabJyO+wz1nr9Y0dMnScdLQ1SHT124AQfnRlaW5UtrjHDIUN1CgJBV2GkyX5faBaAeTiNHjTIdG3IeiYERCTIAcNpNdvb4tiygd75jLBiAl4jJ7U7RbgqMVIUZe2GIHRG/aNrf+MoTfDo/xP7SZmYRDZZD7Y8XQ1Z/XMIFnZrI/PAJVJsqCrcOKAh69BDNEc43ggmVyJZ6pWw8L61pecoR6ah1z7jgnb8/NWA6nTH1yKKiiwEdx0XaN7dGHD9lqyhoRJ4BurMvkhvcNuJZgOB2H22PiUbmkeHwGk2V6258rE3boeWEUykFrtVOzj1hOvyj/8ylNQh/L70oVapo8rIFQR0+6m6b6oviYYwFXEkplKKyYJnbUoSyaEaVF+VU+droXnkBt06qAKq/pVcPDAKr0dKhNdqUmx41MUwZqoI3HwbNuo9ExDYuLI4nmcB9J//e9coQvEwP6fq4LDA1Q2xQuCWCOJ5IaaJq33d1C3orZejqRMiIyP1sE5LlYU7olzwxS4//g9DqRx9A7A/5gC5Q31MYgpA0xzlSUmu4B23YRzrtZwI+TW1xmBzsh0/Cel+qA+I7VC6GZjI8XT+5r5i9dnYKqIjsNfGfsQ1+fOF9r379wNyNo9I+2V8v53CNoljfmrR2FfUIbfFwOg1vNVEWluQkVqBdGg1Me8wgSrw25RvrDil5BAER3TQYReRarxjUOarbpuABRBqlOFQSflyacBMekkXf+sbtXr527m0qK8gaaBIuDH0bjWf6MtPk6ptrfaGHAl9mvJS6Lp77q4T1ckAx2cR+i3EZ43P66a0C/kmOzy8
 tP+tTJHd
 5MFtbcznFk4QwQFMdnfMCQuhjtA8o0Rr3FBhMoOK/FNaeCVo1p9lOXIn9N/Kl9SMWOuwC1GKg/hB3FeXE6a4XIWvXDUdXNW4wdcq4sfDoFdW8ShWxCUBuMMYclYyoJTbTFo8N1iUQ/TRRfxXQJZA2Q465PM38j8uToAAS7MyBIx0C8Tz8OOznQQF3ccj01EaBWqwn430T3amYxM/nK0FNP1/ttk1A3Q1TnEDaT8Rwf/7lEpEMzzzTCLqwdoy64biLXHIFQgifqq6qbzjJqlR6UTKlUsIzhApKDbxoJ71YGuAeY+0OBldyqiRO6eSQF1Am1peBa98PQjzSPzZvJ2aqc04rchdDTM9vNE6hoH3ByC4/q+xVtwSaMIg+zoyQNAk2KawmyKfP6+Co/BMP5aX77rRoONKSvs/4x+NM1m3bzqR2gXUFyIoB7RlUU8vbtgBJnRMDlgbMkEgGMsvL6sCNRTG+TnXtJe3LGlWPGtFUmwMvsqO178+09vwAop6bLW2QnXsVRBcJdFVU5SC//wJ4R94FvOifo5wnA2w6A31r53ruISFgWVtkKhn+QY4k8iXf8vY8QVl2v+nOw5UvDjSe98DH04dkIO/EoC7YDAVs4mUh1qAwnIdnhtrTc89LmiKH7XS15dFMcvx6aZKuXLZ1KU446dA2HtxEgNoi5NKTkEpSAEIsWxp4rKbovnyrvPbMv3JGHC+roweRkcr/qqfv4iB5D+B5SAdA8gDgZE6DkpiImXgGGy9Lej3nz0QfxqxM52Erzds93egXHQTGLDAxDZGPq3u1tgYQeBrWMWSWn1bQ/Q8h9zED/+l87iaiFOnbZkl3vRYsKQsqFqCW/o2kFO+pPYcFkheIAFF24hFefapAIMYP1DS8N9ULpIqBZ8dAesTtYF1tTkhGMqCAWTTBKNzd1bTTvDUIneDjH2bDEzB0dgN3I6HCTHvisx5mkEcaOvDC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>




On 02/12/2025 15:36, Peter Xu wrote:
> On Tue, Dec 02, 2025 at 11:50:31AM +0000, Nikita Kalyazin wrote:
>>> It looks fine indeed, but it looks slightly weird then, as you'll have two
>>> ways to populate the page cache.  Logically here atomicity is indeed not
>>> needed when you trap both MISSING + MINOR.
>>
>> I reran the test based on the UFFDIO_COPY prototype I had using your series
>> [2], and UFFDIO_COPY is slower than write() to populate 512 MiB: 237 vs 202
>> ms (+17%).  Even though UFFDIO_COPY alone is functionally sufficient, I
>> would prefer to have an option to use write() where possible and only
>> falling back to UFFDIO_COPY for userspace faults to have better performance.
> 
> Yes, write() should be fine.
> 
> Especially to gmem, I guess write() support is needed when VMAs cannot be
> mapped at all in strict CoCo context, so it needs to be available one way
> or another.

write() is supposed to be supported only for shared memory, ie 
accessible to the host.  AFAIK private memory should be populated via 
other mechanisms.

> 
> IIUC it's because UFFDIO_COPY (or memcpy(), I recall you used to test that
> instead) will involve pgtable operations.
Yes, for memcpy() it's even worse because it triggers VMA faults for 
every page.  UFFDIO_COPY's overhead is lower because the only extra 
thing it does compared to write() is installing user PTs.

> instead) will involve pgtable operations.  So I wonder if the VMA mapping
> the gmem will still be accessed at some point later (either private->share
> convertable ones for device DMAs for CoCo, or fully shared non-CoCo use
> case), then the pgtable overhead will happen later for a write()-styled
> fault resolution.

At least in Firecracker use case, only pages that are related to PV 
devices are going to get accessed by the VMM via user PTs (such as 
virtio queues and buffers).  The majority of pages are only touched by 
vCPUs via stage-2 mappings and are never accessed via user PTs.

> 
>  From that POV, above number makes sense.
> 
> Thanks for the extra testing results.
> 
>>
>> [2]
>> https://lore.kernel.org/all/7666ee96-6f09-4dc1-8cb2-002a2d2a29cf@amazon.com
> 
> --
> Peter Xu
> 


