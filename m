Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CC60E92FDE
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 21:25:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D15BF6B0088; Mon, 29 Dec 2025 16:25:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C991B6B0089; Mon, 29 Dec 2025 16:25:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9B126B008A; Mon, 29 Dec 2025 16:25:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A7C706B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 16:25:09 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3F9001A099C
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 21:25:09 +0000 (UTC)
X-FDA: 84273789138.11.96AD9A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 70EBD40004
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 21:25:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AExtGijB;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767043507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9kCsFatynB5A0849K42/FH7W+ckv4A5AgUXc8wzTD+w=;
	b=t3BEpzZ6Z3nq8h1futhYvto9fl2Jfq3btde7iW4bE66ZtSU/oYbhYFtBv2LElmDcu6XORY
	5+5A7y1EOyG1iJHvIze01zosvxd27saKgfrJc852JjVUrb0YgtSnjBvNKQD1Hhv32DsizB
	yh6D2Nbyy0khuP608L+enepAAHYpoPw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767043507; a=rsa-sha256;
	cv=none;
	b=ubr9qW9vpEr0shU35uZfMgDKOxYyGObSFgLZkMC0osaF17im7dVBKGIwZQa6yCvUND4rwE
	92U8dhzVFLBRdzoMkj52Q8Mgod+HPUcxB0TLHfPkutQcjmwh9EUtr0g7uAGRMh55MDa9UW
	y8WyhS1vwFGLf3bB4w5J8HzCucPBtp4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AExtGijB;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2073243928;
	Mon, 29 Dec 2025 21:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC83C4CEF7;
	Mon, 29 Dec 2025 21:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767043506;
	bh=q82e+byaIcXWChEnLqhJwOQExSMsHkk9DYJ3CC9why8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=AExtGijBIRiwcf0k6km3zcRvW4TlCNI/Gv/8K1uyvwCt+MmqI7n2mAEfhSwDxr7lp
	 YPyu5Hy68fYfyYpEq0E5593W4b6WJzNJJrtUMVCWXfcV9QsDT+cZZRoqzR6lvYNJpp
	 27Hv7sUpHCTtisjT95LLkJS0hGmz3yPcKyR3rQo8HCf3WaMRtC4Bs5lLSfwAmdXNMY
	 G5X3rSUjaDJrXPVLCuXBtNTVRWKgmxjt5DwDbx+ui9912NlwvIbWH3alq3ElIju24+
	 6j7CxeS7EnFinddUveciY1tott5eJo2PRhF4wLHywKTY6gyHjrk3cke9FicS0eAc0J
	 A4guRzmC53AuA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@kernel.org>,  Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,  "Liam
 R. Howlett" <Liam.Howlett@oracle.com>,  Vlastimil Babka <vbabka@suse.cz>,
  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko <mhocko@suse.com>,
  Jonathan Corbet <corbet@lwn.net>,  Thomas Gleixner <tglx@linutronix.de>,
  Ingo Molnar <mingo@redhat.com>,  Borislav Petkov <bp@alien8.de>,  Dave
 Hansen <dave.hansen@linux.intel.com>,  x86@kernel.org,  "H. Peter Anvin"
 <hpa@zytor.com>,  Muchun Song <muchun.song@linux.dev>,  Oscar Salvador
 <osalvador@suse.de>,  Alexander Graf <graf@amazon.com>,  David Matlack
 <dmatlack@google.com>,  David Rientjes <rientjes@google.com>,  Jason
 Gunthorpe <jgg@nvidia.com>,  Samiullah Khawaja <skhawaja@google.com>,
  Vipin Sharma <vipinsh@google.com>,  Zhu Yanjun <yanjun.zhu@linux.dev>,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  linux-doc@vger.kernel.org,  kexec@lists.infradead.org
Subject: Re: [RFC PATCH 01/10] kho: drop restriction on maximum page order
In-Reply-To: <CA+CK2bDvaGmfkCPCMWM6gPcd4FfUyD6e5yWE+kNcma1vT3Jw3g@mail.gmail.com>
	(Pasha Tatashin's message of "Tue, 23 Dec 2025 12:59:05 -0500")
References: <20251206230222.853493-1-pratyush@kernel.org>
	<20251206230222.853493-2-pratyush@kernel.org>
	<CA+CK2bDvaGmfkCPCMWM6gPcd4FfUyD6e5yWE+kNcma1vT3Jw3g@mail.gmail.com>
Date: Mon, 29 Dec 2025 22:24:56 +0100
Message-ID: <86ikdp7zh3.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ni8854emtrn347zpdamopafyfo3ykk9j
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 70EBD40004
X-Rspam-User: 
X-HE-Tag: 1767043507-73436
X-HE-Meta: U2FsdGVkX1+CaspoFXQ4DBnafgEgc+4ptT/6oy7dj+r4MJjkwo1++qnjzsnGoOFi2X98xe0LddgAamXWEl7OpohLnhEYHBoCyn/RdAsAbXSbO8eJQhTS9R/yuzTPzj8RsUZirQyfwuhWUMR5Ma6n9fOrnBYx7vfBP70F6bvAcP/ZUjHf/SBP1BGWa8/23n2MK04cdC/G/qBvwlxvTZBfJw11hXHE2vRFrwhMunNWkY73B4zQVOKH6YAG+cNaCHir5JvjBmMeM1Qrj/YM+znwGQ2do1ZIFrkTR5TVusX/nru/ff8mx27BHCkCHpgkfqFlLUmEMW/B7Ys3X8Kp47fAMgd8a30GO3hR8VRfi+xcofg2XL8qTODOJe3WKEo6Vf9ia2je0ploR64mn8SGmj1Ud2Jab4b0qHYSU2+nF4ktVWgwBPXvOZj/J16f387s/Bru9+bqaVMSJTDuYcHVy5x9l+kbkR7cYsC4GgsKty0ZxJXSSj2T+GYU05tYbTo8Y4aceFBsKslqxuq1qoqprwBtuIEIUz+pdElwlq10H2cnMOU1FGfHP4bHGH0aaDCOEez/6GMaRhkxsLTFjaiaTzulQbl9X2b1MQXCKorywKGUciCrRXuelyvLz1qeThUkDd+JQqPgo9LQGpfFWQp6PHPH1XTpvWw6acskyORAfhHG8CiWtTbyFBI9AgMxrIEUEDlFQrppblgAsL06QLBksxYFb7dkk3zwK3gL54Aj+vLhycjAcQ4SMe5ZEC5yFgxiiX2nZopStdzHkCQuTyIK8tXQ+NSMROio8f+6kH6225s8soYw3H/T5f4XZ1cCApTmwUXOZfvxXyQuiG8HjCMHxQT/UXuJjpm07bTFStVPWfu3dEkzyyKGl1j+uUaJq3BEmCiqkCR/X6ZvhUyeSYyL2J8jt9EdPva1Ow0HvQ9guNCekoxznCHaRVzVQ+bnGlrjaU7fNp1AsqFJXq8M5IOiWOX
 yP3mLrOV
 XYjZY4/aY7rUIdcF6glxg5IalBIIPyPLeJlVFE9WzEDcHFL6i3o28+qPbC5Zz6u8VyDZ72x9+TX2RN6jAyrQm/D9C793LaHS4k6VjvvJ4BRzR2ynUh8YalhG3nQwOWG+1CuPhMlDPqteL4JJJRPT2T9St8Q1k8xNnzjdaHsbKQz0ROTpunGyPERd5ypbK6ZVeFAAmmt6XnMVp0a33oyLG8MlrvfJ7lkWXbpWk8Y/tkH+YBH8ZeFqRE04/8w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 23 2025, Pasha Tatashin wrote:

> On Sat, Dec 6, 2025 at 6:03=E2=80=AFPM Pratyush Yadav <pratyush@kernel.or=
g> wrote:
>>
>> KHO currently restricts the maximum order of a restored page to the
>> maximum order supported by the buddy allocator. While this works fine
>> for much of the data passed across kexec, it is possible to have pages
>> larger than MAX_PAGE_ORDER.
>>
>> For one, it is possible to get a larger order when using
>> kho_preserve_pages() if the number of pages is large enough, since it
>> tries to combine multiple aligned 0-order preservations into one higher
>> order preservation.
>>
>> For another, upcoming support for hugepages can have gigantic hugepages
>> being preserved over KHO.
>>
>> There is no real reason for this limit. The KHO preservation machinery
>> can handle any page order. Remove this artificial restriction on max
>> page order.
>
> Before removing this restriction, please also add a patch that makes
> sure that the calculated order does not intermix memory from different
> topologies.
>
> I suspect we need something like this in kho_preserve_pages():
>
> order =3D min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
> /* Reduce order if the block spans across NUMA nodes. */
> while (order > 0) {
>    size_pfn =3D 1UL << order;
>    if (pfn_to_nid(pfn) =3D=3D pfn_to_nid(pfn + size_pfn - 1))
>      break;
>    order--;
> }

ACK. Will do. And I think I will split it out of the HugeTLB series
since I think this can be applied independently.

--=20
Regards,
Pratyush Yadav

