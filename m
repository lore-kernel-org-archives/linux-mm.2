Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52594CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 10:47:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC58E6B0030; Mon, 24 Nov 2025 05:47:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9D1F6B0031; Mon, 24 Nov 2025 05:47:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D9BE6B0032; Mon, 24 Nov 2025 05:47:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 86C0E6B0030
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:47:29 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 27B5913A6E6
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:47:27 +0000 (UTC)
X-FDA: 84145174134.19.3202546
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3AE1C120004
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:47:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B2ko+iEi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763981245; a=rsa-sha256;
	cv=none;
	b=EdbQVE9nZ8qNdgSIgbFwlWouDEGAeEFxkewwCVOB7/G8GihAkHBx7ebHMMI0eXU9IuNRFv
	cQ8h99j2HVUuscV7bm3XHRYGPFtBSCAeXIsKMimEgNgr9ixNYlTotWZQ1vbnM8/Vszyxif
	+2sI3AD5KxkDHarbc+z/cJmgp2Dhzcg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B2ko+iEi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763981245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=erCP42Ues7IwAtZI9frYnWc1XizqKFSYqil2kbK62iI=;
	b=eXdN9ciP4/51ROXugZTVC350EAhycpRPAZseGx+MWmAQY0lybTASKU2lCZIhdwV21ENLni
	PHenwyC3f7vrsR9S2mDoHNCBTaslL6ynXIv2u3O3O9A4Dj84HLmNZQpqUv4oSHOoT6SUvA
	sNZ4vXda8/KkpA/5b50XOO13gMROHJU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 97A9D601B6;
	Mon, 24 Nov 2025 10:47:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C77C4CEF1;
	Mon, 24 Nov 2025 10:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763981244;
	bh=6nxKEIZkVhailrIiW3XSVoQ+gWVPu3eKDnFphZtX1us=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=B2ko+iEidiYGhvL3YmKCCuGt/1FAZGeXdFxjG6LTjNuCRFsjNc6VR40iFUsFsFuf7
	 vtXLMwfFBgw8gTF2AgGo/NlhU9LF8iHWcC5axSVGFSapMdg+VC/Lg7kjnRF6zOhyua
	 s3Se6r+3s4koBGppGnlbPoGOENiYWAykiE6wrK7Sw4v5RgWG3mZysysonlHbvnq3tU
	 B10Cn5j99q6ZRrVpMhK6d+le2etUfRyWojoe33smrqjQQD9IbwBDexOfGr1xudZvcX
	 lxa0fdPSP6KQQeMcDRYWzwL2ioy1UWsVhwtM2JPMipUCQQEdHYoqzJ/17iw6I7NZ8g
	 y+ptXYfDRaCSg==
Message-ID: <1a2329ef-50ff-4e48-87b4-3adc70ee8833@kernel.org>
Date: Mon, 24 Nov 2025 11:47:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] pagemap: Update BUDDY flag documentation
To: Richard Weinberger <richard@nod.at>, linux-mm@kvack.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, corbet@lwn.net,
 mhocko@suse.com, surenb@google.com, rppt@kernel.org, vbabka@suse.cz,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 akpm@linux-foundation.org, Vladimir Davydov <vdavydov@virtuozzo.com>,
 Konstantin Khlebnikov <koct9i@gmail.com>,
 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
 Linus Torvalds <torvalds@linux-foundation.org>
References: <20251122211920.3410371-1-richard@nod.at>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251122211920.3410371-1-richard@nod.at>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3AE1C120004
X-Stat-Signature: ctstrs1qr5mkxjcqsfhcctmfbbujx9x8
X-Rspam-User: 
X-HE-Tag: 1763981245-243608
X-HE-Meta: U2FsdGVkX1/ciOhTAl2O+3Sjhj+n9cHUuqzs6+5TTfzawCgCkyKZQQ9RG0vEhTyUpCfR/8Kduj7Xexj8GhuPd6eJ1iYj71y3IbymQ2M1lplhZeIMY/VJFwMXXBxKoFxQEXcKDyctwF5MK5XVR0bP+yXU+3sU4NQQOG4L0dcgJ4CJlmOpC0TYT1hkLumQ8flAuuzbloNhdCIVf97rf01ZBEKGOCzu8M2q7x2txDEw3EEfrqmfUQ8qoEBiQdllj34H6w3HADxTrz/JQ90oLkJDbovxACuSuSDGdA/fJTsdzwzdLAGi3FyzC8MX6xt6sYzdXhB+p2NrQvNXhBvFjZ/blkD2N7kvXgR6lE1ApwX1roNOvnWKGQ2l9GxoxKhgHpx7kcDulUsFNvzqv2AwyyXIGDpPW979n96cVKgt4pQTCtMFTST+8LvKDFFXZ+uo3+OsCoNE/GOG0O6mEvrf0ZEAY9N9Zprl4azpNb7y7S5PGUdvmgHgFaIXxkvAyLgF0KqPIvmrOxYJrf3f26BeRyDhKf1NLIIjLV8+Ie6tVcyeoTHURWpptMNO/PiIJRW6tCN1tjoMha6PSC8uhp3TOuJ48+ZwDt0P4fdGC/SO/ET+ptyjlGtw8CsHaco0POA6TuFR+XsXoG0YzdIx6IAi689NyPBpRaaRqBBcJxLCOICNqlrjXsB7t5x0NAklZp0PtEoDxLd2in2bbMtAeDiJeBRQLPwSMevBv+rMRFtmuR6jF259SqABPpbAK4m1RfLXPqRh/cFyjQHnI44N9Uu5n2WiyKs9arFe2syIp2XtbitvNvJbEvmUhIrsKrh0VD89j/D8O5X7TwyZLxK3ZoLYrg+xrhYYX113nsMuE8DOYi28abwlVSpj6pLS/r8eRS6rcaC2PmxYoHWcYPubm1qeJanGNhLAgy3mDleCYSoXTX8K4b/JAQnSx/wJkwuuJxcjkaSFEGLu01JkZ/YN67+TwjT
 ZtJLzGaa
 eehq/vVXuHunV667W24U4H2FZy0RGIG9M9oP32XOMJR38dL0paIvIYzYe8RjoN+SrpHbiPgdguzGF6Mf0rQY/zrNx/y63N5BVgkl6anXIebfxvsSCqZjWBzUiYocnwwkQoGNT6DVHhQihbTu4yGWPbahIbnm7d8K8M0/Tp2CBJpJKkf+7HSFdThNcE5ciuIO7zHk7jRiRWhJaYnynhB5dxCTqbO8s+RkJpoAATIaSQ3rzC1zMfIEyyEDq0Ah4G5cqKba+DSnh4jzsA3eTbN0v+2vXUZkNQ9L1fneCvnPsKVjl2C+GT2znSNH1Lt79KE4UeTC8Qpm5rtTmhCl8R8ZpV9pt7QZJfhIY3iX+LndNoFHprhDoprIZRQxRI5NKiCs3OBZd2/Z7acz6wLofKMGPq4IMgww3pZNpvIXASepfXl02b0u2L0asvoy3Qo1Kmw02vCsq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/22/25 22:19, Richard Weinberger wrote:
> Since v4.6 the BUDDY flag is set for _all_ pages in the block
> and no longer just for the first one.
> This change was introduced by:
> commit 832fc1de01ae ("/proc/kpageflags: return KPF_BUDDY for "tail" buddy pages")
> 
> Strictly speaking, this was an ABI change, but as nobody has noticed
> since 2016, let's just update the documentation.
> 
> Cc: Vladimir Davydov <vdavydov@virtuozzo.com>>
> Cc: Konstantin Khlebnikov <koct9i@gmail.com>
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

