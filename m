Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97F6BE674BE
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 14:56:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E58AB6B0005; Mon, 22 Dec 2025 09:56:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDC686B0089; Mon, 22 Dec 2025 09:56:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDEB36B008A; Mon, 22 Dec 2025 09:56:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BD4CA6B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 09:56:07 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 86196877DE
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:56:07 +0000 (UTC)
X-FDA: 84247407174.03.60F86AF
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf11.hostedemail.com (Postfix) with ESMTP id B75A940009
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:56:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mR0ZYIay;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766415365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ug6CF6jCTPeVAFS2QI1pQi+kiqg4TBi7NpuKWEmGN1A=;
	b=W7qbfG8vVv19N8SiRkJRLeP8Xb5AbFlzT3cE74FNaN73TZipvgal8emJx51xGhPXa6F4qx
	Z311XNTW+kgD0iDLu1A0mF2R4oARGLA9KBYPAdPQB/2xAUs6H+gubj786z64MWp9tQH9Qm
	v2eKEhoX3hwU0Q07s2I4fhXRkwKLjdE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mR0ZYIay;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766415365; a=rsa-sha256;
	cv=none;
	b=r7kj9HSEdWAdlR52xmdn8mp/LJBHC7pgYf6DV27nXKO3tScxxz4MKfyAnrIIVYx1augziW
	JV8wQPGkyUp1YXEko2AWsihlkzXaltHcIuiXF9dFji0/tqg4zRbTLsqksEBefEZHGHUoc3
	LrI9bSV94h4uDOPK6Z7OYGL4dkEGwtE=
Content-Type: text/plain; charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766415363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ug6CF6jCTPeVAFS2QI1pQi+kiqg4TBi7NpuKWEmGN1A=;
	b=mR0ZYIay0khLE3eWzfTfMrMUBSfzPivyFLCYkJg7umNNHmi1J+CWjiGZd5hgbuhCY4VByv
	bwPiRmnU/E9MGfwey8vGWPmFmFp+7HIigwWdGxEs7jK1Ehu7BWDxBLRxU3ii55jZXrk4TD
	3rMA+8byHGekh6B28hIX+XG4QKisfRY=
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCHv2 02/14] mm/sparse: Check memmap alignment
Date: Mon, 22 Dec 2025 22:55:16 +0800
Message-Id: <CDAEC896-E3EB-4EAB-9F0F-70BC448B3B9A@linux.dev>
References: <3b758468-9985-49b8-948a-e5837decf52d@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>
In-Reply-To: <3b758468-9985-49b8-948a-e5837decf52d@kernel.org>
To: David Hildenbrand <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B75A940009
X-Stat-Signature: nukkq1588jfzs4x84rc6t45pz8fk4its
X-Rspam-User: 
X-HE-Tag: 1766415365-282829
X-HE-Meta: U2FsdGVkX18mR6Q/tor2WxeulSCvliSEXEAwhMwmFTAXIsFn+kzfOIXWtcdFFDICsfPwtcWK0WM3d0W/w4Z0pZgpoadTEMrb8UYL5QQwmMyxKC3RyYqpyz8simQtP8bXxyc7DqyBF4BkgL/WjBwLOYZsyJshZpN8pLLkuw8l6vYpGBNGDbd37mu+dYW/KDPcMXI86nWm2hRqqmNRvcWkdOvOb4aUBCB1h0hczuCBZIz5n1FEKdH8aupQyXgQheK9GRuaTB8fPCweocQX25YcF/v3FCJimqt1PVQqF8NJj6QfREvt0HCqoFAvIuh9cr+OuHyc3X5hNyHwMuVCckkZMQrzTY7VbYvsD6shh7HPoX4sHvySN6UxVf52tjQByQvFK6WnG+yqqmF2IJSUvGbbGAonS+Aoj0A5JazqSK3FiMc4+gBunTa1RgBqVRNT07f9xSxl3rVRxG34CVLZMZnNAc1sPb+oW/aPAtJ+1NBe2P4QH2Mps7Ajfp4ZgzbBCHsI8kmfGN4ZaedMnKhLv6zQx+dw8DRT1j08IHSkmbsgvO55uWbBKY33nqlY+x/Hr2W+eWzJ8shMMJTRlB0bO+5qnVqOu39MKINf/FPXy9vqFRbxMAb1QzeZbtsumf7/5Tm9waCsLoZBZnMxWJzcwLtFSrEmf2DaDbh+qoPCxPEFAEIcvfZ6xD2+F0nujZU/SFg/EGCSLAqJFKU65nv5CBRjgIXiV6BbHmWq3qf8Fp41LKRfyOxOiwQPM3nW1UIaoxHwNEYxr5UAQVZhNOl5bGuppN4t1nrB69ovJqz+czHiB4l1K6WDm4Fb2akyB+7dCfpWpofk0uOa3zuLU9wTqPgygqyTWMjG9Kp4g5qKNju6d+gCZr798BQGh0+joFUmJrlBa9loH+3Q4TU9lIuJsuUw5TQOsdyWO9XHm9xVdZ1cIpigpU4excOQyFrCjKbiuzilMDbY9aBDZw1GHVyVanr
 zUBw/KFa
 k7fsazwjF1P7C2h5g0aJZroIXuU9y7U68nuHFTpA3zy1svQ3O/9myCL912P6n6GJyklvRnoxO1pTfTZzaohJWzF4o69dBdpoeAgSuL8OM3X+xQhCxvz4r4YEeVuEv52JiQ+iTezOpNef4xyc25THEBg97wyWAEqCjt5bx1Ik261CTs+VY2XLkAez82vs0q07aWFdQo2BFu1OXk2xXGmPXiM7HB0fHrbQmn+i5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Dec 22, 2025, at 22:18, David Hildenbrand (Red Hat) <david@kernel.org> w=
rote:
>=20
> =EF=BB=BFOn 12/22/25 15:02, Kiryl Shutsemau wrote:
>>> On Mon, Dec 22, 2025 at 04:34:40PM +0800, Muchun Song wrote:
>>>=20
>>>=20
>>> On 2025/12/18 23:09, Kiryl Shutsemau wrote:
>>>> The upcoming changes in compound_head() require memmap to be naturally
>>>> aligned to the maximum folio size.
>>>>=20
>>>> Add a warning if it is not.
>>>>=20
>>>> A warning is sufficient as MAX_FOLIO_ORDER is very rarely used, so the
>>>> kernel is still likely to be functional if this strict check fails.
>>>=20
>>> Different architectures default to 2 MB alignment (mainly to
>>> enable huge mappings), which only accommodates folios up to
>>> 128 MB. Yet 1 GB huge pages are still fairly common, so
>>> validating 16 GB (MAX_FOLIO_SIZE) alignment seems likely to
>>> miss the most frequent case.
>> I don't follow. 16 GB check is more strict that anything smaller.
>> How can it miss the most frequent case?
>>> I=E2=80=99m concerned that this might plant a hidden time bomb: it
>>> could detonate at any moment in later code, silently triggering
>>> memory corruption or similar failures. Therefore, I don=E2=80=99t
>>> think a WARNING is a good choice.
>> We can upgrade it BUG_ON(), but I want to understand your logic here
>> first.
>=20
> Definitely no BUG_ON(). I would assume this is something we would find ear=
ly during testing, so even a VM_WARN_ON_ONCE() should be good enough?
>=20
> This smells like a possible problem, though, as soon as some architecture w=
ants to increase the folio size. What would be the expected step to ensure t=
he alignment is done properly?
>=20
> But OTOH, as I raised Willy's work will make all of that here obsolete eit=
her way, so maybe not worth worrying about that case too much,

Hi David,

I hope you're doing well. I must admit I have limited knowledge of Willy's w=
ork, and I was wondering if you might be kind enough to share any publicly a=
vailable links where I could learn more about the future direction of this p=
roject. I would be truly grateful for your guidance.
Thank you very much in advance.

Best regards,

>=20
> --
> Cheers
>=20
> David

