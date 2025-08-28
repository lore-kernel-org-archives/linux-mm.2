Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C239BCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 04:27:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1332C6B0025; Thu, 28 Aug 2025 00:27:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E3C36B0026; Thu, 28 Aug 2025 00:27:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F14DD6B002A; Thu, 28 Aug 2025 00:27:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD8A36B0025
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:27:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 80FE85C003
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 04:27:47 +0000 (UTC)
X-FDA: 83824882974.13.87D8D73
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 024BA40008
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 04:27:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MDOpy7Q7;
	spf=pass (imf27.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756355266; a=rsa-sha256;
	cv=none;
	b=B/smCEQ3XOSue5nqDN7d3oNEOooUdcY5BJ6eZNE1irmo18HBjz/KacBUFRcyjXlwq5qEmt
	Xw4fc37iXDJSZGSJt1rvkI9LiJdoultk9KJkEcdW5e4FDGOjtEhIyQVr6nrCUjgV00Vjdi
	AQE/ukv9aP1i5CuZIMMn4u9qlXrVplU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MDOpy7Q7;
	spf=pass (imf27.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756355266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/EGtfRPpOEF/pcMPNuO7jUOw177R7tpiZ1QWNeD8W7E=;
	b=3nWnBKLUQNAoiMmo+zM+CU6Cxxi51UMjSF+w7hgOcJg8GSHL4oqIhKHhywXsMPXMoP96C6
	ot8WlZQakfceXwRt+Gl2OKquYUc6RpU5i9PbnxrDX10j4BqM3lh5A5u2p7EjTA7re17sZo
	AKwBk5++gJ0EO5UOIqs48xz010+nfS4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EBB9A60204;
	Thu, 28 Aug 2025 04:27:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33984C4CEEB;
	Thu, 28 Aug 2025 04:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756355264;
	bh=hUnNfjGCPEWmiNNGGLZKDOsScYWj511icwVWbnrMbSE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MDOpy7Q7+PtjV9ZnI/+71mkZCJrWQwTtFvdW0afXONz8h7wR9ImGTrV4WCC7mXn2B
	 7EbOn3HGpIWLqjjSjwF8rGcKZhPtc4Gfky+zbxOUAt8Kl+cAXdXSfuUaya8Zvy1ya1
	 F1mYHsgG9WcnDg0zKq2bACZzcl/UPORrd7FsCsy3qdsnuRy8wAbqlzxL98joSNwLF6
	 w9WMn87Hpnp8f8IF6pk5vnsO7wQiX+Ib8XV+pManWrp62VQ4CdQPenZjvMUQSDERoQ
	 eOJ33fQuGDSZ49Qcix6/vKNOIhOhF/f6epJTEq5OJkbiyKYIE1xM/FteX3oGbk+Ymp
	 Up7jZQPpsB0CA==
Message-ID: <c39104cf-f066-45d8-a13c-cad558312b6e@kernel.org>
Date: Thu, 28 Aug 2025 13:24:45 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 24/36] ata: libata-eh: drop nth_page() usage within SG
 entry
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: Niklas Cassel <cassel@kernel.org>, Alexander Potapenko
 <glider@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org,
 Zi Yan <ziy@nvidia.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-25-david@redhat.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250827220141.262669-25-david@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 024BA40008
X-Stat-Signature: wm9ee7nxwfmtp4jfzr8jijhaoam4ozja
X-Rspam-User: 
X-HE-Tag: 1756355265-342779
X-HE-Meta: U2FsdGVkX18wIJuXRn8Mf7DTDCDU8RYamp1sfYroMKbZeln/gP4Kk5GWzsgHuUeFJLg1AVL4Buv+1llDoJfiwv6ZTD47JcVqVrpEc5fFOLFlDWyp6s4pqIQymu5gYBvoY3BUgJ/Q/mBay7Oxd85pueTZOU4TmrQr0J/VS9tIKQCcVvhAKbR1ltG7RL6ZV464ccepbhjMei+23FaVigVxSuCxBK3VnAt6nw1IQl7DYmq5ZvlwOSpGCx+cEAS2zrZHUf3Wso/Z52pcOrh4ga9bkWqKmq2BEemEYUEPGUIkLyDQg5Zpw3tmK2t7Di211OyKzO80/PBNgbucfeL4p1kdEojAAXIly+y90tM4TM3sZnRXwQ0V6wpLmaVXgDeShoIGFyy9lm3lGLxU648rbMbmTZQSehSQIEsfaowb8PE/9DHeib7TrK4nfRA5AjyqKOfs/pMv7vg0W0PLwZssjMeDKG/n2bCzqMo5uzWCsbHptaluAvuySh8/MRkS26VC5qaRSDlzEEfp9lRwO+Bhc2pVsYmcnGAJZXZDD4+WXPO0NG8X/4SHPiGDDZ9q+oGconxMQ9rKow2J7WrlBXf9EqnB8DmT94k65739wtyHqgta2V+/25bxXRCvvOVkdo3AUFAx/LecGRlquA+ODhWQ/gJ+tHi5f+6pOKEiy2IcNkHMqF9BXBXX/Sin/DNX2+P+/kGtIcnSBl94Blgyr9jBpdCiSmN3eqQCWDlo1MzH7HGZf0KmZ/Tnvhw/uKIvHO2pOdAr7HaDva5hqa9Q1hFlS6m/QBysE9ercebe9RcvFpk+J5DQbPSx881PjAMeC/DTc5YyEP9q8Gwp9oe7k7kEYVb6zqtquKtIgyEQWWeqVeMJuOFI4VZaS5+NGi8OjsW4Li9IEePeEMHWXhjxlINguWleDtH6ONyk+JsK1o7C48hS0sXoPqhu5tmaUt96w57h5zgZyb8LZ+U41W1GLeh4EJK
 +mj18RSQ
 WQvRAI40gMSXGJfSHr33O3cwRO3MDPTCBxaMmvOutKLM2M8dBdfmC4z9zS+Xs6eCZtY7OEUbTKITvkMY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/28/25 7:01 AM, David Hildenbrand wrote:
> It's no longer required to use nth_page() when iterating pages within a
> single SG entry, so let's drop the nth_page() usage.
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Niklas Cassel <cassel@kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Acked-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

