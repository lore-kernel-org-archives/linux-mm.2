Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DABCED33A04
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 16:48:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F37D6B008A; Thu, 15 Jan 2026 11:48:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D5486B008C; Thu, 15 Jan 2026 11:48:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E1F06B0092; Thu, 15 Jan 2026 11:48:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F1296B008A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:48:30 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D593C1403FE
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:48:29 +0000 (UTC)
X-FDA: 84334781538.06.97E8B14
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2CE5020004
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:48:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d6rnX8sc;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768495708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dkin0h3TKFLsGAddK7GXI4UmRCo4xtW7DIU+ftX0KIA=;
	b=v76VdoM9jHZ86lUPqBt3scDMShDJPZ/nI9u2gFNAvbwxFEXYZ0DcG1yQnw8WdoenbVUp7N
	jNrj8ZRwsScJcrLD18f13+HkJf+adzHu+ZjkXF8W+L0/7fuISugL7F2TDUuJdenygNhuiz
	DlZiuJ+eN8GPVaLXvA0c3DfD/ET01xU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768495708; a=rsa-sha256;
	cv=none;
	b=XNlT1mEXlIE7KS+osxHzzC/ST8EjuVZb/oENBRdMdez1soH6s9MkIHtsjePu5zxnYdYcGt
	tqQkeGLZUBAhNEWCo119CnFeISpJ5oU6aY9TDfU7yoXweLg7BrbQheNR2DlKSWJQ5J0L1n
	RV+C8T9Gx43py/d7dM2bw+AZwrKUsBE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d6rnX8sc;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7816360121;
	Thu, 15 Jan 2026 16:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CCE2C116D0;
	Thu, 15 Jan 2026 16:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768495707;
	bh=Y/FHsbbtc/ckGu7zda3NuoNYgKRvaJ4zIG4RoSqARBI=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=d6rnX8scxqYgKDlQDSnoVAaWLHn3BmwdpFGxB8PESwL9wfoU6sSFu6HGEqF0HUmOg
	 4w50NWmjSXgZshmAFggR7E86eYy4eS2iV9Sf5TxKhFCnGtspXSGpW/WEwh0I2sYW56
	 T3+V1EIiuPjuUibtspH6Sk/4P5sctTHJ+2X1NQ46g/78b4nr7IccxWVyYQ8QdJhwN4
	 DS4ZlxldceS7Ja3/QXyioXwlEOmQoVhdCujORDcsetapQuwsHk/rkTdxW99xm0QBtl
	 cipnartReX30SR+xfeFc73SxuESwyVEHP2I0Vi1qxnkJhRSRc8tMzLu22FCCtgMJwj
	 i5nDv3kjhYpFA==
Message-ID: <bf788cfe-ac2e-4ffc-9349-64d9c36bf072@kernel.org>
Date: Thu, 15 Jan 2026 17:48:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv3 02/15] mm: Move MAX_FOLIO_ORDER definition to mmzone.h
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <20260115144604.822702-1-kas@kernel.org>
 <20260115144604.822702-3-kas@kernel.org>
 <be57dfa5-e6fa-4ce6-93c1-239436ff6e89@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <be57dfa5-e6fa-4ce6-93c1-239436ff6e89@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2CE5020004
X-Rspam-User: 
X-Stat-Signature: peypbunojwhpeuhzmwqsxr7d9czwgc7w
X-HE-Tag: 1768495708-973818
X-HE-Meta: U2FsdGVkX18oN+ivMOqNiVQ0GJSCOgbzcFz4aNqJeIoeAhjKYimqwc/e+nv2WncRZASxgrIjRjZOzxZuyAAm8M+yS9DNF6VABYs8JAENksc71+VF0PaLC5E3+UoeDzraK8Vao5rluAYpZDxqNXrGM0YYr0eXHOCMiaDAA/sZtlump7Ke1YHHYjH1SZJMBPVL6g/Fep0vAja8THynK4lMa4n0wz59+A25btvgQEjTY5CPx2yzE7VnqIaGZYGYi9+p4V+mMC8rb/P69FpXvObUrbfvSRfwPjH7/3y+YqenME3WaBcDqR7Art+sl39ZupwCBWebLtdXPFIQlLvHevY+rWz0YH7B3/GyLFOatiwzFLZhdCUqW/ur5xP7HYbLNT1rZWLfW6MunI8PnEkkq73r3ly6mU1FYTVt/gzFo2YI3hd69LDwgDmPSqdJvNLedxtn6bMYn7jAI9ft9xfUHYp8RVIy9Jf01bbn+gqmrbWu+GS79K3NAOhe+vSvQQQojUmDUPpNz9m147kNSid0JcWWVO8aN4A4d4ImQJvW9mdeYcvFusduMQRe99s0ZjvNit1bO+UKrXBDwuQENWaObF+zOol+j7T/+7MGsgB9SlpiziEDc4rfQuDIgdbFM52vZGDyAohlxqpVmxd2K/KUdWnZ/1zR0b5LTrWw1GBT5pOP7ew22HLqicTpOD/ccaCc+OBnlJiF/bXqOY66vzGtESt37+UPvOeIzpvNM7X6Yb52tlCgYbNUl0wtn4jkqBkaTETbi/dMsAMKb0DbWQ4+krrxhm53a6obDY2titnh4tFghdcTpydjCspr+1vLAPNyhqhZp5haM1CCHdPI1FFtRE9MQOkeENPYdCYaa1dOBp6p2M23iagEwEQZiNVxKqkQx5OGAH4uHG3m9USBLY6KfyzFToUp4QF439rjshAB4Y5/vP/ZVQbiYq33o9LjkTEFkLcEXiE9vXQGJe7UdO8Bd5J
 6koIUAmE
 T7vndqhQvOyPfPzp3NcSwu6pb5FslskVW22pu6oqOPfA0aqbhqxnadiSOzfRp6gC2l4DgYXoc08DL9pF1f/cGc/5jmKLIWVrEBrXjqiaHVlUa8DoEprc1KUpvAkualdkp/xy/xK3o9UKrtHwlEQemm+lT7QrkOoDmN4Tg1T1hjW+LBLD+ScWEh5elybnOdAYlpc+bJa9fRvuwyiOnMI7cuPaG7LPd7tXPPjAl4ygF9toS5eQn12PTCEtI3TBeBxijeD6UJVoKJ3E8TvPus33ioWtxcCAcTlHqpAAFtRyrNsNvH4gdSVuUZqc9jj+jLlsI8e/pRLR8f6mKYEo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/15/26 17:35, David Hildenbrand (Red Hat) wrote:
> On 1/15/26 15:45, Kiryl Shutsemau wrote:
>> Move MAX_FOLIO_ORDER definition from mm.h to mmzone.h.
> 
> Why should that belong to mmzone.h ? Semantically doesn't make sense, no?

To clarify, I would have moved it to something more folio-type specific, 
not something buddy/zone specific.

I guess page-flags.h + mm.h are our dumping ground for folio handling. I 
would have moved it to the former.

Likely we want some folio.h in some distant future.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

