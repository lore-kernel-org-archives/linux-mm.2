Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADEF9606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 20:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NdHnt/Zr
Received: by kanga.kvack.org (Postfix)
	id B575E6B05B0; Mon, 16 Nov 2026 15:21:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B081D6B05B3; Mon, 16 Nov 2026 15:21:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D07B6B05B4; Mon, 16 Nov 2026 15:21:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 66EF36B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:21:28 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D2B5916020D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:21:27 +0000 (UTC)
X-FDA: 85442102214.02.0A64332
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1506920005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:21:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NdHnt/Zr";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794860486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=udvGyc8qs7eDmCkZPOwNgWencCurPc2vHfow8Weymbs=;
	b=19pN+5S/xGBcjOvE/OE/5o4noT+LmKbCFGs7mg7pGD0SlyETtugPJTOOuiuiIqbjs8STpQ
	5Rj39LCo61sXgyQxOBLMsOL9dPGwDnwWqTD8L1O3GR6Wm+meW6zFCEWidReQTdy+HCPkFw
	GnK90RW6wL+sa79l+Nx66HWVJDESKRw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NdHnt/Zr";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794860486;
	b=3vZLw2dOjyEvIIfJw9LNdUsrvhM3U0tcE9NHCGMuwL75DIuXaE52WID5SiWG4FxP+EYyDS
	IhPewfdwEFLBrU8H54vNvSSyZJyTxuFaVnkMmy1qZkqt1WSnEIk+MKP0dY9mjA8UKHVKXk
	0b36bfiCxE7960YM+ZzF2SMcTe8vcHE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 804D661278;
	Mon, 16 Nov 2026 20:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756921F000C5;
	Mon, 16 Nov 2026 20:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794860485;
	bh=udvGyc8qs7eDmCkZPOwNgWencCurPc2vHfow8Weymbs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NdHnt/ZrGkTJKLGT6boQkYmr5hZWrnkKFG39XbeyqlnIrlOXoyMTn/RU+HxI6sO7I
	 KYpzLNpBliBkZHAeMhOkHxHEyfpqzuUGSciggMRkstONQK0cMmHSS91h9KkbH78WZ4
	 hW6VEK2xuDFgphM9vROT0Ntv4/4ddSfFupNPsoq/8W1uU+QMTME9mJXDRsaU3MP7mv
	 Tc+GCyr6oOBSAmbLK4jdujNTR7h0K+Ve4nyjk+KqzcnPUvFvyR+uTMx/wASGQrrIau
	 V/yM1p2OJaYdaUprgh6SiL35fAJEKB1aYl1m9J0ZnBUoLYXIwO0yowCQbEB8C2JECS
	 ToeVnPg6Ij4TA==
Message-ID: <2dfe9686-f138-41dd-bca5-89d65adc31e1@kernel.org>
Date: Mon, 16 Nov 2026 21:21:11 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/9] fs/proc/task_mmu: downgrade writable migration
 entries in PAGEMAP_SCAN write-protect
To: Tal Zussman <tz2294@columbia.edu>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Peter Xu <peterx@redhat.com>, James Houghton <jthoughton@google.com>,
 Andrea Arcangeli <aarcange@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Michal Hocko <mhocko@suse.com>,
 =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
 Andrei Vagin <avagin@gmail.com>, Muhammad Usama Anjum <usama.anjum@arm.com>,
 Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Breno Leitao <leitao@debian.org>,
 stable@vger.kernel.org
References: <20261116-uffd-state-fixes-v2-0-4397a0196479@columbia.edu>
 <20261116-uffd-state-fixes-v2-3-4397a0196479@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261116-uffd-state-fixes-v2-3-4397a0196479@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1506920005
X-Rspam-User: 
X-Stat-Signature: jmfo9pd44o5giis6mq6cadmmnskmz4hc
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794860485-892228
X-HE-Meta: U2FsdGVkX19zlZDoyoGfvFk8LdqEjt2RA6MWJHsFJ+g6g1SCpgSma5+ROLUyXQ6PN6gNf6YH9/FZNoXMYbpSuqUY3ZF/VhIu0TgBCNJSiAaCicB8YmyttTFgfI9nyVDok9LTifdPauSveeM9zDfNQ2uuimpyb2uhK8zyhijBDb35hhwyre+xQepwGinGDu218A32+DGdLMAW1OgL80nliPLG0Nga+J2pxquCbDZf0eaa7b7uVEk++zGNCZKZDVOQyBIzU+gYSNv1MyP4dUzdTD4rwDD06wgBNauualDXwFFU9O031eBOIP4c9IE0bbPJ8FWqVQz8X3U1Za2v29ehNLD7pGv1TstXMW7sNYjIOrKwxj+TAaPgot0hUmWqWaiMNGCBT+46WY/Sg6b3h1gxgrXo45k9TfylOcEk8eVXlmCEfBxB94X3EyhfqU+z1tUscUF5gJzAfUDsGPwNfpm+r6bkOg1EZfIjYnn53oRCUlhLn9FcBQ9f0ZNzx02LUDrgR7vguIZ8v31V6cv0MyDrYIuKyHwcyyUG+5O+imiDKkApI9BMJE1NVj28ZMaPnfeYmh3KMLsJ8lIDDIXrKNlhz1pvXNJyFJxK3EPqND2PDaZ17GbJ737a5AThyF4ukgMWnpEMpTUvAa+IKi3JaK7oi9V+GrEEBrYUXAb1ZKSnq9x0T/zuF3o+0DfUURV6MEQz2C5ILRM9HYa68+/PmFrLRotESgKjyI0IYe4YkqZpyBcsAMN6KfiJ4Ux9/bX6R5ldqCtVFHiTaLe7frpy1SJGnsECiRPAezEIDcTKJdplr0wx9CuaSX/Zh/fhMYJvLVz1pOBOpEwgdjFQpmKVgoOd4xwdJsSgwtGkUL1KqDeQiS4ZeM226Wql67G4k/vlQ5rzvNAVRJBKy50OFK/rBQ9pezrBmxGE2nunreU0jToMo80YcLgdxfu6qJv++OKtuAjnaX1zsZ8nwF5ajrHlMjx
 B12E3hN0
 VG/2qv9lrCQOrUWo93WGigwh+tzk1uWWxERNAAlDDvuRl6oHaJR4tPA4HWaS2sfPcFo4jjqUcgclT8is/+zvsbQiD51AuQQrVZ4n1s7z/2/0npEbmfo+t4aGtsodpHYdF8PBSEckVXaQlWpvmgD/bjh1pu7lQuv1+/h7t7FTr9K2b1TMiJnUQ914I34EIUXlxjYLJoXxijNXiwIUtHtFa7qOrHPv+s8fcr9LL2aVoeO1IM0irIfPoXXya/DZj00qhdSEIfwzlBRjHvDWYVLFrihC7y5+o+kgvKlprvRVSUP7eYXk1rmTTuQGXmJq2qFQ7t5fLpDA9HIrYZnM5VvOy/hqsBwerbR766dJGXDYTp/2+caht0vQbKdKA2nen0hT//ZTVQVeO0DQ2SV+CdAqtUZYCcZGyl769Xdy/hFiDlHRanpE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 21:02, Tal Zussman wrote:
> PAGEMAP_SCAN with PM_SCAN_WP_MATCHING write-protects pages in a VMA

Today on "things that should have never been merged": PAGEMAP_SCAN and
PM_SCAN_WP_MATCHING

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

