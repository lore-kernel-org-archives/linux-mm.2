Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE84CEC1E92
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 10:51:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07A376B0089; Thu,  5 Feb 2026 05:51:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0525A6B0092; Thu,  5 Feb 2026 05:51:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E96BE6B0093; Thu,  5 Feb 2026 05:51:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D8AF96B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 05:51:41 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 742D1590B9
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 10:51:41 +0000 (UTC)
X-FDA: 84410087202.09.FEDFDAE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 560A74000A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 10:51:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZFELBMmF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770288699; a=rsa-sha256;
	cv=none;
	b=0l0jU3fCaxcUN8b3JELUiNJWPSQFaIoSIhwFCJOJwVb0jCVIjYQdnpqrGBzfilhxTUebUa
	e2gnY0/VzUhTORW6qHPu2sQCZiTPTGk4GpFkrhUOkOIbA5r1JYbVVNekHm9JZeFnOOZPg4
	BZJuYoBInpCQhrA9WFU/BeuzuugfexM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZFELBMmF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770288699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pk0w02vvALAABcu14e1X/1uL61HPJ/YQQjOYUNTVZk8=;
	b=jzL21H9Kt5oSeduTLsIjSkF0/hQX4yehpemZNyXBe8rCxabPzQd/fESxIvh59b67Bv9bJc
	GYD1pXeW5RNLSpC6Z0tHNPbyni8hNCZ3ui+GTKE7NwieEC7zDNjhz7Deiejpiv7php0Tet
	pzvAmvVAnr6Tw5yvh7LYLfntnFE6oz4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 146474449E;
	Thu,  5 Feb 2026 10:51:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DDFFC4CEF7;
	Thu,  5 Feb 2026 10:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770288697;
	bh=9fuN5USsUGF1WzrDo+pVyaNuOxLtr0Q5xXjchPRotqQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZFELBMmF5iSGzD2J5VYYW2H3R9B6pzc5j+IhnlokeXNfkFF0f6YxB0RMGYkWRlDvB
	 XORLZo/xV1lIkCTxp74jyBQpV2hcklZgJge2Sm77ZJkVdQZvK40jGHVsNeeAC08iev
	 /DvAHMRPnJ1pmYJ4OqbwNT1S6z7JPsrhxKrQdwhYF109w51/oHKrx12hdxSubhbCqG
	 SF4WJ9gcH4ATliKMb03KHtz9ui30tKljPgpSNf1UUrs+ylk9A8flowxQF9lsm++Fhy
	 590VVTL5/iBz7c20nFYiGOKzkaBLofkltWDcK4btqJr5gNN/ZRgrzu6u6m6JRDcZOc
	 5wk0vT3qOCM5w==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 6DE10F4006C;
	Thu,  5 Feb 2026 05:51:36 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 05 Feb 2026 05:51:36 -0500
X-ME-Sender: <xms:OHaEafKqpsc8ta6aeUJbuntP44wZSocgehA1wKvzRGgAy_GM0Wlucw>
    <xme:OHaEaT4-F3S3AevY6I6KM1hg6QptUUanOx_8OvZQ7PKAjanZlOpS2nXCK4_AS3G0D
    MP_JnEbJdk3mQqpo1gj907HtPsHK8O1eorj8vQ0tETek46PagW8wJIC>
X-ME-Received: <xmr:OHaEaQlkvqLhg1rUapShdAuFOH1hUCOGdSfABYsupqIYm3d4WoDDHTKFwTAZeQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddukeehuddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpefmihhrhihl
    ucfuhhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpeeludettdeigfefhffhhfelveeludeuleduvefhgefgueeitedtleffudegfffg
    gfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkih
    hrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieeh
    hedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovh
    drnhgrmhgvpdhnsggprhgtphhtthhopeeftddpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepphhrshgrmhhprghtsegrmhgurdgtohhmpdhrtghpthhtohepuggrvhhiugeskh
    gvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhg
    pdhrtghpthhtoheplhhinhhugidqtghotghosehlihhsthhsrdhlihhnuhigrdguvghvpd
    hrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidq
    khgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepthhglhigse
    hlihhnuhhtrhhonhhigidruggvpdhrtghpthhtohepmhhinhhgohesrhgvughhrghtrdgt
    ohhmpdhrtghpthhtohepsghpsegrlhhivghnkedruggv
X-ME-Proxy: <xmx:OHaEaQRE26RNnCSybKljxN8W8lncdtQSxl7KTw5A1qoUfyd6L86umA>
    <xmx:OHaEaVjQ-TZmarRLpDenGpA5D_UHLJix_dpT9PW0waNajbtbaDgLfw>
    <xmx:OHaEaS01wJGc_olWceNoo8rAT3fNHCnk9SqtNQNK-IcNpnHrZJ6NCA>
    <xmx:OHaEacDM7cs_-3yoGsInKTS04RlOvYi4q-qRNxlcH62oo5JJYdD1lg>
    <xmx:OHaEaT3jp4VA1ftSsnEax-lXbv0ie8TzuQulFNcSENn5VNkxvOMYg0ge>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Feb 2026 05:51:34 -0500 (EST)
Date: Thu, 5 Feb 2026 10:51:29 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: "David Hildenbrand (arm)" <david@kernel.org>, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, ardb@kernel.org, 
	akpm@linux-foundation.org, osalvador@suse.de, thomas.lendacky@amd.com, michael.roth@amd.com
Subject: Re: [PATCH v4 1/2] mm/memory_hotplug: Add support to accept memory
 during hot-add
Message-ID: <aYR1jHu4oq6LXKYF@thinkstation>
References: <20260203174946.1198053-1-prsampat@amd.com>
 <20260203174946.1198053-2-prsampat@amd.com>
 <aYMjjyVVax5cml9B@thinkstation>
 <29b4dc97-bb01-42fd-8ccd-f4cb2886ccd3@kernel.org>
 <550c89ae-de6e-45f7-89a2-ccc815f8d5a2@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <550c89ae-de6e-45f7-89a2-ccc815f8d5a2@amd.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 560A74000A
X-Stat-Signature: 95x4z3dag131p4his4kss6t394fxjoz3
X-HE-Tag: 1770288699-479928
X-HE-Meta: U2FsdGVkX1+eY3ApTd7N7FLllipVrxRzurJF2QDn1WjeOW8ZZBhd2Dl8Gp5KpiTngr9+2glYO/F9AIqc2e83uIH+U9CRp3nPrUXdUIR79FGFaDotvB0iVvkSggIW70q3L3N/w1WaKelUN7xCsQyrxhkiPnAirQbIerfoxSLGPT7SBESeJe0V4Y6JdDRhRiBdlyt0DfhQMjdYRqc1095kumb2y9vSP4/ocOsWtYPmfjO5BMq87jLRvFoi+/VcrisnGkHrk7QaJJHaDYwFhsreA9oW9f4G3IlN+WVRRKsAQVYHIP4LapuhrCmbaY4CGQuiYkfsVw3O7G6obwBmNVHkEgtoKX3v0zzskYzQq7UzPqwxSpnURT780fnZABQ4Z75JlFZ5yWaB6sAW4/KhHpXF3rwPdq+hyzFI+jY2lQSTwaVqp4gLEfrRopVLvy2dJV/dh2SfCg951sJUiIFpwJgv7odYBvFn0E+aZtXTqTD1HXr6Z5kfz7EltLWHXZBd4EWSwmlt9EfttQh4JfWgPl4Vwz3hfDXNoRVmmdAzgODcoWM8ausFdXldpd099hNW2mNHX6etZStHjPEzf6YA5t60ZC+hVitkrjaVY7Ts6bgTKh6SCryiWDSkNVR5OBh1pTQHnRPaY9Uj7WyIDlo8TN4muA71GYHHyuEYi6FQZG6snfkYkD8KjOxY8akFQZfE0dMF38qO2vI0X8cUZqkHxZ6t/VeoHHSdjNMBTEc9Yy4zgTNfhIDk5QExcAzwv1ntMNL7ilfW0Y9rd8VheXN+YThmLgM09eNxFtqEf9MNalrH0zZ4bHSaDrSEU1vMgKy5yG9pm8iu2wTMjsK6MrcbN0tbnLNMI5YxkRs5QcIDduCUomvfEsrsExC/P79GQ/pAayZ1VoWC8jAQ3Sny2+4OGADVSxMJGBIZqXhCye/OC52u+HtXSiuqEXWeTz0i6zjtrsK2kLtVMOH3/onre1g5Ikp
 zQQKYXou
 llz/rnbBFSwGvrzKhVjjkF8ABbrL1x5FteE7T8G9SL93Jo1kdQLnCuHh8BRwdH1sYm6paPomjg2Z6PnPGXBGphGhHQlCNS+AR69VwTazpmYyDkrHy3zs/oE3WStMlUdh93fxgFMQrv4/BihrXgBpFCt5aY2zUZN1RzG/El9pnxT7FqtiUirvslfJ56ALyBKZha+yPBR3JPwuzdufU31T395OprLMuc0PE4+DiCXws6byekAEm/KAeVmmnwXLjFZ5lHn+9xV73YLNEL7Pvbd93T1HkbdaEh0BUVZo+twHngDJs3/0UhD1GPN9fFaP3Ztc6FE0A66exgOmCldIC3t1Wy9cqsTtu+sNkE3m8I+aaFEk+Snhc+By/xQpFeA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 04, 2026 at 09:50:01PM -0600, Pratik R. Sampat wrote:
> 
> 
> On 2/4/26 1:59 PM, David Hildenbrand (arm) wrote:
> > On 2/4/26 12:22, Kiryl Shutsemau wrote:
> >> On Tue, Feb 03, 2026 at 11:49:45AM -0600, Pratik R. Sampat wrote:
> >>> Confidential computing guests require memory to be accepted before use.
> >>> The unaccepted memory bitmap maintained by firmware does not track
> >>> most hotplugged memory ranges apart from system memory annotated to be
> >>> cold plugged at boot.
> >>>
> >>> Explicitly validate and transition the newly added memory to a private
> >>> state, making it usable by the guest.
> >>>
> >>> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
> >>> ---
> >>>   drivers/firmware/efi/unaccepted_memory.c | 47 ++++++++++++++++++++++++
> >>>   include/linux/mm.h                       |  5 +++
> >>>   mm/memory_hotplug.c                      |  2 +
> >>>   3 files changed, 54 insertions(+)
> >>>
> >>> diff --git a/drivers/firmware/efi/unaccepted_memory.c b/drivers/firmware/efi/unaccepted_memory.c
> >>> index c2c067eff634..359779133cb4 100644
> >>> --- a/drivers/firmware/efi/unaccepted_memory.c
> >>> +++ b/drivers/firmware/efi/unaccepted_memory.c
> >>> @@ -209,6 +209,53 @@ bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size)
> >>>       return ret;
> >>>   }
> >>>   +/*
> >>> + * Unaccepted memory bitmap only covers initial boot memory and not the
> >>> + * hotpluggable range that is part of SRAT parsing. However, some initial memory
> >>> + * with the attribute EFI_MEMORY_HOT_PLUGGABLE can indicate boot time memory
> >>> + * that can be hot-removed. Hence post acceptance, only for that range update
> >>> + * the unaccepted bitmap to reflect this change.
> >>> + */
> >>> +void accept_hotplug_memory(phys_addr_t start, unsigned long size)
> >>> +{
> >>> +    struct efi_unaccepted_memory *unaccepted;
> >>> +    unsigned long range_start, range_len;
> >>> +    phys_addr_t end = start + size;
> >>> +    u64 phys_base, unit_size;
> >>> +    unsigned long flags;
> >>> +
> >>> +    unaccepted = efi_get_unaccepted_table();
> >>> +    if (!unaccepted)
> >>> +        return;
> >>
> >> This can be tricky.
> >>
> >> If we boot a VM with <4GiB of memory and all of it is pre-accepted by
> >> BIOS, the table will not be allocated.
> >>
> >> But it doesn't mean that hotplugged memory above should not be accepted.
> >>
> >> I don't think there is a way to detect such cases.
> >>
> >> Your check is probably the best we can do, but it means VMs are going to
> >> crash if memory accept is required by no table.
> >>
> >> This is ugly situation.
> 
> Agreed. Breaking hotplug for VMs under 4G is absolutely not the way to go.
> 
> Would it be worse if we call arch_accept_memory() if the table doesn't exist?
> The table is primarily to operate on the bitmap's entry. We could wrap these
> accept calls within an arch check for TDX and SNP guest if the unaccepted table
> is NULL. Or, less preferably convert the panic() of the existing
> arch_[accept/unaccept]_memory() to a WARN() instead.

I think you try to workaround a lack of proper design. I think the right
way would be to make unaccepted hotpluggable ranges declared upfront in
the EFI memory map, so kernel can allocate bitmap for all of it on boot
and not playing guessing game.

If it required EFI spec modification, let's do it.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

