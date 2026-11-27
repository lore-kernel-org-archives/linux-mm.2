Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C61A7606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 08:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YYJjFLaZ
Received: by kanga.kvack.org (Postfix)
	id D45886B05C3; Fri, 27 Nov 2026 03:52:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1CFA6B05C4; Fri, 27 Nov 2026 03:52:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C32E26B05C5; Fri, 27 Nov 2026 03:52:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 94B146B05C3
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 03:52:05 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B30F3C0281
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:52:04 +0000 (UTC)
X-FDA: 85480281768.27.332E4D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 187B6100005
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:52:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YYJjFLaZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of naveen@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=naveen@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795769523;
	b=iPcPLdShbz9ercuJt8wnVZERKKFUNGrtenrHYIw7namfjyCDuwgXEfDrDk15OEfjnzR0Tr
	yDJNV4YchdD/q6UqPrWbEplIq8ih1+6KeP+MbmGwASwF9ooSa9aifdMDWYVEi6ROyrdgZr
	Mfwrz8zCbaR2A8AXzFzm2SYLZgfBGgQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795769523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Az5My2Vhz9lFn8TPP5jwgIX1srC4R/ukf0qyT9wQ/eA=;
	b=ZC7EkGZ6xl2BMIWDcWcF17FZBZ4rz8cJwijLuqw+iW4upGm6iSupS410OwB9KfOwieeydX
	JQ1ZGXEbdWPLghBlHKPM4/IryovF0ydHt+HgiyCa4w0gydbHmMCjgMuVI+WCc/y0bDCmCg
	JLqKJUwN1hmpp1sgPu6/TmDxhcvTyO8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YYJjFLaZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of naveen@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=naveen@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 044D744937;
	Fri, 27 Nov 2026 08:52:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC821F000C1;
	Fri, 27 Nov 2026 08:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795769521;
	bh=Az5My2Vhz9lFn8TPP5jwgIX1srC4R/ukf0qyT9wQ/eA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YYJjFLaZwHwd63Uz/wXb6h08h8pIpRPW0RSBo0PiRLxl4x9pk2hjDtwvfu/2vOpOU
	 vucIPBC89kKlrCcLuYZ9nCHMSRIuIG6cEYn+etqLqPAfQh8w1cAgYNBEIQvvMicRHa
	 OyGQhc55e0tQkZEpYeL/sQluV0WJUP+5ZoV5zmmcaGVSdQA2bkt+z7V45M7H4pI1fg
	 bU9xvw/jVTMl5qxy1hanz3skstyxFtUUiGCC4MkStSOaWC9sppHe2sZ7n/BVmSI9hD
	 f+mk7P0Cr2hUL2OBf3Lpc6+O0vXhPtC7A5+Gt4Cellvy7uZRFyN/dJeTxbbQ5tQjfv
	 wIX36FHeCoCug==
Date: Fri, 27 Nov 2026 14:15:45 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Nikolay Borisov <nik.borisov@suse.com>
Cc: Pedro Falcato <pfalcato@suse.de>, Dave Hansen <dave.hansen@intel.com>, 
	x86@kernel.org, mhocko@suse.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@kernel.org>, 
	Vishal Annapurve <vannapurve@google.com>, Kirill Shutemov <kas@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	David Hildenbrand <david@kernel.org>
Subject: Re: [RESEND PATCH] x86/devmem: Drop /dev/mem access for confidential
 guests
Message-ID: <awlC1qLOp31OL1iD@blrnaveerao1>
References: <20261124160025.738362-2-nik.borisov@suse.com>
 <0dc6759e-ada2-461c-85de-809c170abd6a@intel.com>
 <awXBtrPSHfs51Y2f@pedro-suse.tail5790ac.ts.net>
 <8500860b-d2ff-45c1-8604-28a2b3d66382@suse.com>
 <awcMnXKDWjTvxumG@blrnaveerao1>
 <d642f950-6423-420d-927c-991cbb5c2669@suse.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d642f950-6423-420d-927c-991cbb5c2669@suse.com>
X-Stat-Signature: 6us3wih3ftdet3wi9pn98trr9uutwoe7
X-Rspamd-Queue-Id: 187B6100005
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795769522-726378
X-HE-Meta: U2FsdGVkX18W8XoCprnBuLGsLf//gTuF2x2Ja7+c4ntrWyzv2Ju9Cvrq8RiQlqwT2TfM+Tb7apUnA1yki5fxxUULOjY6LneYyGfrwIGxp6FaD3kCBzvqj3/RchDRcqZb1fx/GkPTFZITc3x1ZClJjSM0zX36KzK5Xj4ApCtBg7Yj4dAtwa3JxgIzYaiRMs/WJF1aI7BOSxOxuJWFZDGaf9kXztICX+oR0ntlX+jEV3o+JW/d3FEcN0xzwqUru/nXt0zrjWmWNS3bx3H8v/34BjNi0mm7ganD5lk2kYOB1mcebdalN21UiUXyMjZX+eSn8mY4WlXx1MATr2Zw043p/Ov8ueKUWl886IBhRDTezUAI1bAswDcYWQ1wn2FxOozk8deEfG0IvOvzXG4IGE9Cg/W0XFoO2svqRFTreMEYe6bGTIe9g11CfhRyMqZzN0DeS8HVIQEcvzcFKiZSgQtxMER3i8i9iLFVyB+QhcDkiZ2mb8iyNaobKZlnIJMJn0JH9Cn33BtzH9pMBlktDRfCUxN148Bo2gLAKaE7Ap8Pgc3sD2pHjZJDf9OqD6pnLf2FGP0aqni02bFA2F0xx5DGmLOJrnQ2LeY5bRQHi2vFr0h7hfHT6M3TZtOJ71ByJMbvl986vkfFsvR0B5JWRoWvN22Tx3YrporXQJf7jClM/kKOsju04IpzTamOh1B+2ATVCV6uMfooirgswXPHiuOg/IcnbV1F6c6QZommwcIFvJOrlw6cuXnpC8fWNz7O4II4seRhvopPb6lgixx8jLYfrIIKsI5Rz6LfG1Q4wkuSyo3JA46bx25fOQ5cDZZ6BAPZoBrXBIOlMAD9s0zMPExTio8I0r/RNaRDAC18d/OezqWektUxc8DwCblmm7oWZg/EyWcXYEPX8reVKbD1AtIMj4LjqRSHl7P0JX8/ivrZ4lCO5XLV441TSVCF1G7Adlu8i60ROCxRTDaxBT/1c72
 sU2FN4iq
 Tn6MHsANKZSxrfOgiIaWdNBMKzpivV5O6cxCC9e+OEcxJSfMC4kFn0IaNHUSh7TjCyP0QnUosYkslpM9hwEUNQqwq1LsZTD2+pMqvimJTVw6/virtwRgHA6XJTMCy03xoQwQhzj6nEpcV84eC10uA4PDAHNttRgyJp0IBd9s/McS3aDJoQJrWqfGL43+rj0tzD9OtpuPztl1mPE7s2PcSSzQKkOYDrO58EKhm5IOU0SDSS2r28uObDC0QDBKoKHVRJC+JpgbdwK1lbsmQJXBmYk9P+YGNACoxShbDkh42SQLxezfYfLcIAhnfr+oKgxbuM2f6hwDnHArE+KmSOd/l9WNjUW9BcG38kdYcQWxthwmT9O9m5hQRrF6a0kzB/reiRr5zoSFcj4LuEQnn0Dw+RLE/ymGUZBdpVKcwCudvr6o8x8l7uHjkxVvvdu78tMWGH1PohoAfsF4UcCloMOBdLmeCCo47CvQ2VN7O0+TpsCdxEPf1ZxEPS8A4UsRZ8IXSgBZl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 26, 2026 at 09:17:49AM +0200, Nikolay Borisov wrote:
> 
> 
> On 25.11.26 г. 18:51 ч., Naveen N Rao wrote:
> > On Tue, Nov 24, 2026 at 07:57:05PM +0200, Nikolay Borisov wrote:
> > > On 24.11.26 г. 19:10 ч., Pedro Falcato wrote:
> > > > On Tue, Nov 24, 2026 at 08:36:45AM -0800, Dave Hansen wrote:
> > > > > On 11/24/26 08:00, Nikolay Borisov wrote:
> > > 
> > > > 2) open-codes random CC checks in mm, which is kind-of regrettable
> > > > 
> > > > OTOH, it's unclear to me why that CC check is needed. If configs select
> > > > STRICT_DEVMEM and IO_STRICT_DEVMEM, shouldn't it Just Do The Right thing?
> > > > in iomem_is_exclusive, etc. If not, could the CC awareness sit there
> > > > instead?
> > > 
> > > Well, you are right that if we retain just the select
> > > STRICT_DEVMEM/IO_STRICT_DEVMEM it might fix the immediate issue. I don't
> > > know why eventually Dan decided to also add this check, I guess it's an
> > > instance of "fail fast".
> > 
> > Actually no? On x86, devmem_is_allowed() allows access to the first 1 MB
> > area, so STRICT_DEVMEM alone isn't sufficient.
> 
> For the first megabyte of memory (BIOS) is return 2, meaning "Just return 0,
> rather than trying to access the address range".

That applies to read(). For mmap(), the accesses are allowed causing a 
#VC -- though this is taken in user-mode so the application gets a 
SIGBUS.


- Naveen


