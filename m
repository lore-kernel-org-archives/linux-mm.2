Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AE2EE674B8
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 14:50:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1B3A6B0089; Mon, 22 Dec 2025 09:50:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDB746B008A; Mon, 22 Dec 2025 09:50:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF1FF6B008C; Mon, 22 Dec 2025 09:50:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D0D846B0089
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 09:50:26 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 58C345723E
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:50:26 +0000 (UTC)
X-FDA: 84247392852.06.648701A
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf26.hostedemail.com (Postfix) with ESMTP id 65D95140015
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:50:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bX2pgD2+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766415024; a=rsa-sha256;
	cv=none;
	b=IdCUu4j9ZhDnO+NkRPnYc2817mEIb5B9rNGGUiTniR5ZJiEfk9YprhhKHbW9/ohoJpQGpY
	26y5udXxHxc36w1nGKSUuL+6GVh488r1gAKPCvEgrs5jgTuWldMTnKcR4JSOgES71yOpEV
	6a640RYqtVjihwhvsXeYl9LUatpGHSY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bX2pgD2+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766415024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5qzGZr4qrIFP3xmX1Te1Vb3hc6XAzSOL3+dOKj/DIgE=;
	b=28akGV7a5HQnV8ybHGc2P1Tk6QqcjW53NAjutuSAYckpfnytxjv49G2DHl98+t0RUcndze
	s7swtrl1kZKMrE3r+8JjOL5cSszl55yjHKTNdlUN2CZaUayS2iJAKHCij2vcB02+7XI0Nw
	+5spf3gFNnC5lftAe87IZqnTtB7ikvU=
Content-Type: text/plain; charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766415020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5qzGZr4qrIFP3xmX1Te1Vb3hc6XAzSOL3+dOKj/DIgE=;
	b=bX2pgD2+ZH2mjwIE+F1nF4QjafwE0V9gHaSPSQuQqmCUcAaFPydFTPTfdho3455KOK3f7g
	XOTAqzuoydUi+uxpkHQIgWXw780Y7nHB+3AOcsVJKXJVcZ7n+Xp99Ze7i4VY6RfUORoqZ7
	phXmCUYNOqgy1jhN5otecOILZlBhWKw=
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCHv2 02/14] mm/sparse: Check memmap alignment
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <4ctnfkw5zqneume6px2wqgdgusfdricr4uuonv7bfjheknrt2g@fdb5ceiiar4q>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>
Date: Mon, 22 Dec 2025 22:49:31 +0800
Message-Id: <2063FA31-1173-4F30-930D-86A0E546FB8A@linux.dev>
References: <4ctnfkw5zqneume6px2wqgdgusfdricr4uuonv7bfjheknrt2g@fdb5ceiiar4q>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 65D95140015
X-Rspamd-Server: rspam10
X-Stat-Signature: f31mzjxytizka9dthjozq6wrmhm1nq8s
X-HE-Tag: 1766415024-577820
X-HE-Meta: U2FsdGVkX1/qQn0OmsUnpJt8sYpATbJpJj3jO4poz8xk43OWeKrVnlV5n3VkXTDmPaMcVAYXbU1xnRd6qFZFxYna/Yqu+chL/vSEnYWjz2Gmba7fLZXh2VKCA8aWPpDi/4drmJVQA4qOU3whkzZXT73BeDRCQhLn0aiWmQFE4hqUqw5c0gG7dGU9NopFLdFBl+4ndnGXojhjReCm9WKykbJP/PkwuuxnCHA4q+4BOMcrt78uWr3ES4M8HOGkkoLqKmXMbipoQ/1kU7V0YNdXMyFLW7xrHLo1tpMQufoEDkHzxrj0Y2iP3nJj6hlVrh/h9o4/ibvk013/19M2T59rdsBnOX+9rkMxz8zr0BZm6KPYWXCDYscLGOcdT2BpbJL132sh6GQfgl3Ig8/c0utVxLY/rrA50XXYtYFzmZtiVsVbRTVNTvqbcI3lULlshrF5i+uFrW0FuFyLmHM6UCIiuRBCd/h45NNwykpRR+v5A7yH8GqJ0gmmrGhu5MaHtszpGTFVXP2DWepElRGKX158F+o+lioTkRXIXHtVFdJE0YJ2+tvI/CtSZAJpSfaa8IWZSQL8z8lammnK/PE9NuHUWZXiEhOft2DUZgkH6DB5/J7IdjmajRkKgxBd9FWoQKmfFYg9wGkyqJB7qYgKC3U9OtpshhuMWzGgYMBk+3iDyeN4PfCMAsHDTGh53WRvosuM1suC35k4uWXHDT24/CHl3RtYQdcRSgcsbufh7AUZcVcPKSB2Y6r1ugUP8ZO8D0a1DymP3bAdP1f8PnW7i4qCqWMgLiKcBlzaZQEw9RWMrQ88hE7KbRMhJ95F0VJJQ1Mx7A3UPtVOjQGr56q1Bv4Z0MtTv7N6PVATNkCra+b7solQVACDvQBgVfRttAviujaFHweCyQyeDJBR0oe7bCGN3BZZuv+i1PSFB1cWp4vXzvFC+Xszda7vLX3mK5Jk6qG6Gbot9uZixW26qp7pHlp
 Bh6UP0zC
 OiM4J+zzI1RsPoHiKBN58gALCYU1Sl2mBsxUsyFiW7+l9VuO9AwLo872PHI2Q/3aBl83FJ8f5XhW/kfvSpdQ73ydjIq/4Uqlwt/74QKImaGo2A/JS0OCSb37Lpp5WDEvOkP/Ts12bsFJfXnVIXNxg5HQ5Odl6JaJtmM55iP14E9V5WKh7H8GNW7ZjFloHoF4qrxxh67hYndmiPlTZY+w4xE+xWsSElLIkBH0QqodQVhj28PpohwL7KEb9V8reRG39ak4P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Dec 22, 2025, at 22:03, Kiryl Shutsemau <kas@kernel.org> wrote:
> =EF=BB=BFOn Mon, Dec 22, 2025 at 04:34:40PM +0800, Muchun Song wrote:
>>=20
>>=20
>> On 2025/12/18 23:09, Kiryl Shutsemau wrote:
>>> The upcoming changes in compound_head() require memmap to be naturally
>>> aligned to the maximum folio size.
>>> Add a warning if it is not.
>>> A warning is sufficient as MAX_FOLIO_ORDER is very rarely used, so the
>>> kernel is still likely to be functional if this strict check fails.
>>=20
>> Different architectures default to 2 MB alignment (mainly to
>> enable huge mappings), which only accommodates folios up to
>> 128 MB. Yet 1 GB huge pages are still fairly common, so
>> validating 16 GB (MAX_FOLIO_SIZE) alignment seems likely to
>> miss the most frequent case.
>=20
> I don't follow. 16 GB check is more strict that anything smaller.
> How can it miss the most frequent case?

Sorry, I didn=E2=80=99t make myself clear. What I meant
is that if this warning triggers, it implies the
largest-sized folio isn=E2=80=99t properly aligned, and
the 1 GB folios are probably mis-aligned too.
Your commit message says
=E2=80=9CMAX_FOLIO_ORDER is very rarely used,=E2=80=9D but
I want to stress that 1 GB folios are actually
 common. If they=E2=80=99re also mis-aligned, we=E2=80=99re
quietly planting a land-mine. That=E2=80=99s why I=E2=80=99m
worried a mere warning isn=E2=80=99t enough=E2=80=94it
leaves a latent bug in the system.

If there=E2=80=99s a problem, we should stop right
here=E2=80=94this is the earliest place where it will surface.

As David assumed, if we expect to catch the
problem during testing, then I think VM_BUG_ON
would be more appropriate.

Thanks.

>=20
>> I=E2=80=99m concerned that this might plant a hidden time bomb: it
>> could detonate at any moment in later code, silently triggering
>> memory corruption or similar failures. Therefore, I don=E2=80=99t
>> think a WARNING is a good choice.
>=20
> We can upgrade it BUG_ON(), but I want to understand your logic here
> first.
>=20
> --
>  Kiryl Shutsemau / Kirill A. Shutemov

