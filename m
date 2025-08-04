Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63526C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 08:42:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E554A6B0088; Mon,  4 Aug 2025 04:42:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2D516B0089; Mon,  4 Aug 2025 04:42:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6A1C6B0093; Mon,  4 Aug 2025 04:42:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C70526B0088
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 04:42:04 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6E9E21DDEAB
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:42:04 +0000 (UTC)
X-FDA: 83738432568.14.92566D2
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	by imf20.hostedemail.com (Postfix) with ESMTP id B878E1C0007
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:42:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=d3ew3y4C;
	spf=pass (imf20.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.152 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754296922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h5cvOoIUvXoSA3YDvNmkVTraImUN1coRcGDWgmZ0ku8=;
	b=Bbc2bWm24XmP0haSaGiifo/BaTQOm0IAjFRmMhgv4E0XwxMvRVCa/YOmKQ1wZBuNwebXtf
	VjsUId4OPScSb2k8EMXZxY4eqxPgqPd/XkTMD7ERjp4n1t4xiast2zVb0giawFzcI18zlT
	6ZCYX1OUpryZzwOhG/TjOHV40YSa3Sg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754296923; a=rsa-sha256;
	cv=none;
	b=Twi3iFfijSJJ8Czbae1hl3gtKj/yhk/7hMDvw3tj0/JgR3WpTANT6Q9+FhW3eqeoA0j+58
	SI7qF5caGknJ6SR8u6NN7xODuja43I6QGyPUz/sF5zx+Y/KAek6wtr28/f2lLUrL+2h6Nc
	HSCy1vYdeqTvli13ucZefRGhh0W8/IM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=d3ew3y4C;
	spf=pass (imf20.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.152 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4bwVRC3tJPz9tgT;
	Mon,  4 Aug 2025 10:41:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754296919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h5cvOoIUvXoSA3YDvNmkVTraImUN1coRcGDWgmZ0ku8=;
	b=d3ew3y4CFKYZ+VyhNFbndX+TRRbDqEyyOElvf8iYszezLZcjM4iI59HEe5ORk8OvsLOEpS
	WikS6cICQGDoEVQuAj3pfdaPq/TcRJmue3XirL0NjyC9KNh8k3hJPDaz3RBTVJf1ip6ibg
	VBRQCMBbi1b4MqAutC4q4CEY94wl7eSUpI1MQtpnagSCPLI7Td8wTC5KOKNDY8Dn4l0ENJ
	RC4QkJWB3NqKa6JyL0sTpubQfiSInAJRb4T1eNOJ6AoWsYdZtQQEmV8/myQtaz38Pdn5vn
	29RaegynYI9FqjOl7OyBeaMUlCo/leLxpqJsCoR2ZvJIae653f2ijMpYB0TuVA==
Date: Mon, 4 Aug 2025 10:41:49 +0200
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Michal Hocko <mhocko@suse.com>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, 
	willy@infradead.org, linux-mm@kvack.org, x86@kernel.org, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org, 
	gost.dev@samsung.com, hch@lst.de, Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [RFC v2 2/4] mm: add static huge zero folio
Message-ID: <6inodp2wabvb27ecfpqu7mzyxb6tktc4ec4sc4yatksfbl45eg@ndyi3ucvj5r2>
References: <20250724145001.487878-1-kernel@pankajraghav.com>
 <20250724145001.487878-3-kernel@pankajraghav.com>
 <87tt2rr7oj.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tt2rr7oj.fsf@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B878E1C0007
X-Stat-Signature: 7gzmhp1kasyh89pnd87wtiafdedhtt6m
X-Rspam-User: 
X-HE-Tag: 1754296922-77365
X-HE-Meta: U2FsdGVkX19AzXHCnGsL+zNcJy0UfNn2DDXwKRh4RVp8cdvSe3Yh7Gy1bNjbfzdT3Gsw2cqXJW/aSasfyc+JPvTiLbl958wXvJh5rPWIKLzjjELlQN8cats3dvVvzPpCUK+JD9vdmDpcq/RfEmIH2y1UEf8AOGItEfLj5uOYf931WgB4fLsKtLR7JhbIGFvl6b6blW0KFuFk/lKVQMOvJVg7msZFO6YYgcJpbNc+714XytIE5tmCAobSrB13t0qLCRCil5VFKZEthXUUSVTS3ebqOltcXaYAOvsMDTP2e1635WtU1F2i69GqX13u2DDOY9tcVR0zSHbxsp2wnyat5VLpS961FJ6KsvhyDfYiXl2p7go5U0IP+KkQ8N1Kc1hQIpMve0uo5MsZzY0kUVT15tGuB2ruGhERisV6z75g/jF1c6khWDNCf2q8toqTsEKiRk0veLnle5zPXNXWhpETW1qBwy7trHTO944y8qXUP8tyi4/hCuWRQRCTbu7lxK4lokuESieb4nNivQl8oFerPEIYu4SPGAapJ8Z70yt0LLQHvWD6Mrs1ybQROQR8IJxEbVmHDf8FYmgG7YsT45VPEAbeSHuyfvgL2lGWegrHnbmarnkOwwD3TaNUnvU/3ixO6rbxP5UXY29WDn+6CD+PbD3lKhvAu6+Mm8+L/jGd6nQzzdjG6xrMhUW3pTstpIXrfYJk8halsXECp0d2GSOX7qMV4QN1+iorQXSfikqgzqmxSHx0jIkbCm8RVM1UKuHTa+FZ8ogoxr7LPyc4tpL0yiEFSHllLM249ENvBDhPUloM2aBXMEGPA9sUZuz4qaxTovAytOmwWyxKs78J5xMQlTkOG9LuSDNr/oP48GekV+rwe3ZU0YFBHHKPlDH07V3xNNWye0p9NRhwCNkU60eAq4crdCMIwQmGJy8JsPI3yK+YAbDvD56jTFrOeYhwo+psToHZwq+ql35GcsDXWWK
 A0iFFZla
 sbEJ9ahJDXIy4rFaAHASq+VDLSIm/n46B38FUCCZpJ2Zfvi4+EN3z8HjhMo7AmeLXXrLqyRgUyA1kOy474OBRWOA0zh7d2y7Wgn6dIJX6MUahwDvkegRk/v+STx/SBRyKS5Qlp5XJYr4TduGdis3f9wNAvXzGOCx7cHe/WNeJmnUZ72Nef3xyk64Y2ZZUu2cgMzCGd2M8nE+IzQrykhzHXPfSiQg/WsCe3e9/xd/n8ivfrRcllE/HJ+JB2m12I7G29ev0KT3zOEirWHLvokRdT3EbTcJAzqqbHNKs3WcqOq750+pKF9nIdHYKvcEMVibYMkdUm4Ysi7U6k4gb1joNxwbfB9nC0JgP6NI9h/ffBxbjNNb8tdastjv/ew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > This option can waste memory in small systems or systems with 64k base
> > page size. So make it an opt-in and also add an option from individual
> > architecture so that we don't enable this feature for larger base page
> > size systems.
> 
> Can you please help me understand why will there be memory waste with
> 64k base pagesize, if this feature gets enabled?
> 
> Is it because systems with 64k base pagsize can have a much larger PMD
> size then 2M and hence this static huge folio won't really get used?

Yeah, exactly. More than 2M seems to be excessive for zeroing.

> 
> Just want to understand this better. On Power with Radix MMU, PMD size
> is still 2M, but with Hash it can be 16M.
> So I was considering if we should enable this with Radix. Hence the ask
> to better understand this.

I enabled only for x86 as a part of this series to reduce the scope. But
the idea is to enable for all architectures with reasonable PMD size,
like ARM with 4k, Power with Radix MMU, etc.

Once we get the base patches up, I can follow up with enabling for those
architectures.

--
Pankaj

