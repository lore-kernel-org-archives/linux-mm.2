Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEA00CA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 06:30:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD97A6B0092; Mon,  5 Oct 2026 02:30:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B63736B0093; Mon,  5 Oct 2026 02:30:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2B186B0095; Mon,  5 Oct 2026 02:30:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F8EC6B0092
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 02:30:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F1A19A3C16
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:30:02 +0000 (UTC)
X-FDA: 85287597444.11.D759365
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4F782C0002
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:30:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gFHs0RI0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791181801;
	b=7VeqbTY+u33sHOn0bUMaJB9JlcQuf6jRo7iq6KWTtxGM39iz1SaOdnq2EYNMxqX3g/gE4G
	YWUf4HZWHjIUbCAbMtxesWKY/Gh9yNx8BPkEhROncrVjdZ2M69iJm/geXbkSWFnwiGQAI9
	mp8SeP8Nv3sktwLSh9KjN4STPlizD70=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gFHs0RI0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791181801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NMXP+3HOcHF428TlVrg2cs9+rmnJKLTevmDSSnYryBQ=;
	b=k7pqdHcq0oRGzs0ETg9C8aRZU16X+NPMLTPgd8S9ipZ8LtE0U9q39WW3uBWYhUiUmWyOwm
	xeOA3xCgPickxCv4nj09Z5e43UlWCnurvQcc4MnLIlcC82/kOt4ygTtsr46oDq/nbtzO44
	GTYFTLZjhlBVOkLqV7Vo3b5wk+SfCno=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 71BE56022B;
	Mon,  5 Oct 2026 06:30:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E65B1F00893;
	Mon,  5 Oct 2026 06:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791181800;
	bh=NMXP+3HOcHF428TlVrg2cs9+rmnJKLTevmDSSnYryBQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gFHs0RI0vQiYN70xLjJK6AIYAhKscdvLrr5shld7PhX2KZychrY1pspfUyGMIyjgR
	 mbkFt9Cb7WMu6rmV0YK7D6FB1RqQpIwcnjbvH/a8zwzdISBXeDxfcPXSds6DBbys25
	 UPDLmNmI5IR8DhAvnAxyD7B0lABLUqOm8rN5+XVq/cKEJprw7em17Xe35a7kBMxQnj
	 2nIkE+qQq91I2LBKt5owi+zYqepp7uqZU1R5dNPMIPeduKfGwHtf9JvyuvaHBtbPLX
	 oSWkiCiwB41mvjZxskSm+7HDZWrGWb6aVcllIiebe2luvrsOd4VQUN7q9UO4HkfmtL
	 EZb5je/2vyG6w==
Date: Mon, 5 Oct 2026 07:29:51 +0100
From: Will Deacon <will@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Kristina =?utf-8?Q?Mart=C5=A1enko?= <kristina.martsenko@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-efi@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Hanjun Guo <guohanjun@huawei.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-mm@kvack.org
Subject: Re: [RFC 00/12] arm64: Add support for TLBI domains
Message-ID: <asND3-Wnb2hiDAop@willie-the-truck>
References: <20261001110655.461473-1-kristina.martsenko@arm.com>
 <DLW95E2XWSVT.8W90FW4WG6K8@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DLW95E2XWSVT.8W90FW4WG6K8@nvidia.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: kr6nkppax1f1rfzi9757jnb9da7i9dfy
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F782C0002
X-HE-Tag: 1791181801-937802
X-HE-Meta: U2FsdGVkX1/5AquVRT8FdcmgIIEOQn4QmW2NYIU/BhpZ9pGlt3WZsz2808RVmKiYPrqnPAgQp/aYieOmsU+ggKWod38M27w57AF+hL4OZM2AnhueaKbmznZjJbwYyYVWgAQ1vY1F1ZmpWT2yIoHcT7TLh4Hcut5JrRfDqfU60fcoCeUtsU72e5lnoM06a0Nk7atrBaK2TmNGPZyou8B/UqgwDPJJQVbWoMibR142na1KG3yXcnGc5Fpz3yFBBbvt/GtoPOT4fwZZK+EXbm4gDNf26wvTKTZWrVkhsPCS0jxHaE7RzyqkWtUf8mYlwaL1KhdCIRxrUiL1cX3w7XelbUZTQkVCHL3HRQ0Xo1TMSSxM4NsiceVd4OboaFino/ItZ4FiUTK/VSnAP1C+YdhUMWoCVn0d6brrcgSvqnbWgz9yVIVolvMmmevwZEGTRu06UlpehgrBfTD4XVZo6/6SVHBycPvEEd0eY2aBY8Wec4/R9Xs+l1f82jU/ksZv2hJLYBypwc1eJBnu5pUxfGuCqoQHu4E83It/o7VqTPD710wpemYwELM68gX9WMJ3Qwbq24PANG3FxU76cvHUJvjVYxVL7eGhX16eE42ugOwoHS2hf4NQqpz6/nffzAL6Ps409XVrFCg3waSEWnOgdChs2wIeOzpB8QUuymoq21iGFzzv/tuVGCwWw7i1L8YorBGTSwYbYM9eZG21Q4jnh7wPyQza/wJkYBj2sQxEKVeXMyNh+/h/vSdX8J7D9X5c6Nl02deZZ4rctu7MmVqQc7Rwqo67Ec/SvxN0dN6taLR+cqAsqt/4ujcpqWZj2EwLtR9zVuIbusbT2QDaeGdkxtuyQcMfPRQKHHVxqv1xS6yjre6iIEvyavuzdznpcjVk/AY3jFzObvRmglqY7JrdQJpn/nECL1X9tnd7e7AIG6uznvUI7GoxPuzNmY3XCryXUgsoHRVulhSnAogHdj3dnCb
 bwqU8v4n
 RPFymlfpdXqrRv9dj1S/lG2Bo7HcYdVZTFBYE0PDYjDWHYTT30zB2elScaQqjieGiGEaVi3HOiCOIon6y1vzkubR5O2NrpQTCL5Gmj2kNZ3TORRp0b2XekFV2U+s5WphB5cr2A8UYO50Hu9Njx2+wrUXYRrZ5MYjPXjwyEMkpyGZlis0j4JANjnzEHDC4LTZhZNzsl77MogKDurf567zCHP0zNc923w97MJuh0StwYjcMG+5+9LT8Lk9j2JelviLbSFCOKAifI27LDV8eFreR8Zs0jg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 04, 2026 at 02:06:48PM -0400, Zi Yan wrote:
> On Thu Oct 1, 2026 at 7:06 AM EDT, Kristina Martšenko wrote:
> > This series allows the kernel to use TLBI domains. TLBI domains (FEAT_TLBID) is
> > an Arm architecture feature that enables a TLB invalidation to target a subset
> > of CPUs instead of the whole system. It can improve performance on systems with
> > many CPUs. TLBID is not yet part of the Arm Architecture Reference Manual but
> > some of it is described in the latest XML [1].
> >
> > The goal of this series is to send TLBI commands only to the CPUs where a
> > process has run (i.e. where its page tables have been installed). The last
> 
> IIUC, mm_cpumask() is used to store this information on x86 and other
> archs. I see you put this information in tlbid_domains of mm_context_t
> from patch 9, although in the form of tlb id domains. I wonder why not
> make arm64 also update mm_cpumask() like x86 and other archs and derive
> the tlbid domains based on mm_cpumask() and a cpu-to-domain mapping
> (added in patch 7).

Historically, maintaining mm_cpumask() was a horrible source of contention
when we looked at it in the past. Maybe that's no longer true, but it
would be good to see some numbers if we want to start keeping that thing
accurate on arm64.

Will

