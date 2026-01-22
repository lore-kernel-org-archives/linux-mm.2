Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67C43C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 10:04:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9B616B0138; Thu, 22 Jan 2026 05:04:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4A356B0139; Thu, 22 Jan 2026 05:04:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B766F6B013A; Thu, 22 Jan 2026 05:04:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A36AD6B0138
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 05:04:19 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 329D58A60E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:04:19 +0000 (UTC)
X-FDA: 84359164638.22.24C3FDE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 60A0F1C0007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:04:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BpS+5mmu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769076257; a=rsa-sha256;
	cv=none;
	b=BRbkOomaxgnbiUliU06t4EQ/e01ESlLSkf3mihdFxeLbcBPEeKhjjkXD0Pbpy3WqAZfZTD
	sTvJoM09IjeC/sk5tlOjO0azoHIUe5+qGmXZb0nK2WIrEXDXbUIAmoaZauDC9iKm6h4jU3
	quOC7dhppFSAQRfv9grV1ewNbk4J2MQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BpS+5mmu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769076257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WjZeD6b4nbdVUDFjV+MNLvvnzANax8CpheXBkOJIi68=;
	b=bnK3x35IISu3MQKiv7Ma9MjKPK04TWVq88msXAeSY6Fknd4frYcOg5VJrBGZxo727wDq1B
	WdCIezuhT6TZsuJKpr886i7hQBjKAfEsx2dTTAsWhoFooxsgHWQs65CaM+PNnpRfcLR8xf
	oiepEs/UF3s1M6tQV/+0O2C7Z6Yqzzw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5CD27416AA;
	Thu, 22 Jan 2026 10:04:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AFD1C116C6;
	Thu, 22 Jan 2026 10:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769076226;
	bh=yL/NrddG1CawfKhoy4ZH1/4SsxmbBqbip9rUrRWJ+qM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BpS+5mmuQZCe173jMQU+eRlim0YQxsGfPb0rhy4QSByTDjeNk8vcjdoLnBsMQNvay
	 14sD4Tx+hYBzYuiyNWBJN+FO/l/8r5YhCtGPPaEHbFbNv/qJIlE1d3HZGTdnPdhmg5
	 j2I3/qxwfyTlw5rqZ5Zg2Ypq5sspCPJkG9zibheIhO0NyR4janbnDOFA89yShhAnmI
	 7kj42mLTLdODw95p3T+NQnWiX46ZgsffM1lsx39s3oj7TGKSGNlHg5SujnnMZUFKJe
	 mxtWDvaFp8RXaYicrJb/h09nkogt17BpUo6tISRX0nO2e9QjaZ7VlIVfXqE9SoNJQI
	 opFU4u9VTB2vg==
Date: Thu, 22 Jan 2026 12:03:35 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Eugen Hristev <eugen.hristev@linaro.org>
Cc: david@redhat.com, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	tglx@linutronix.de, andersson@kernel.org, pmladek@suse.com,
	rdunlap@infradead.org, corbet@lwn.net, mhocko@suse.com,
	tudor.ambarus@linaro.org, mukesh.ojha@oss.qualcomm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org, jonechou@google.com,
	rostedt@goodmis.org, linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org, linux-remoteproc@vger.kernel.org,
	linux-arch@vger.kernel.org, tony.luck@intel.com, kees@kernel.org
Subject: Re: [PATCH 18/26] mm/memblock: Add MEMBLOCK_INSPECT flag
Message-ID: <aXH190NDVl7JAl7A@kernel.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
 <20251119154427.1033475-19-eugen.hristev@linaro.org>
 <aVImIneFgOngYdSn@kernel.org>
 <4b8953ac-567b-4d68-9c25-72a69afdf1b3@linaro.org>
 <aVlsqdgXSBLIE9Xi@kernel.org>
 <ae85df64-b6b7-43d7-ba50-9c0525481299@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae85df64-b6b7-43d7-ba50-9c0525481299@linaro.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 60A0F1C0007
X-Stat-Signature: bigsbxghxtrtnyfr8p97tkufirueekpb
X-HE-Tag: 1769076257-797451
X-HE-Meta: U2FsdGVkX1911k2B+ns+KVjuPVpuIaIyzWpAKTZg5d2inh8z2i+ADWL84ckBQ5S8xln0hr7ia9yhqYPGCV6D+fPPZDvvRs5QStxkzgJcLGbuvtM9IL0RSOKdUzu1zYU5YLuE6miHw6M1ri/mlImuL5eDbDrRn433oX0F10XAsRTRFcsuOI/ljfA108N0AZ/Mrd3ELdSD1rSGAfx8fQ+spRBaDHOoSFuYCKEltj66/RpsB7vbU9efi1CbT/11iFaYWR8zx/Oh6tNmFREzXggBLNJYg8+wyT8qRdLBm4xfowvxEn+b+T3qYiHNfDBTfTDGg2L1sRb2/M1yh7JQnPgN2vtc3Le2HCLArqwTOA+tUwi4UEmRKtrwOaZ4r5I19B6Te+lS35/uZ7iaLQqM8kVk5Qb5Vg7Uq5G2GzEonXX2ZLhlHQdnNIIlG5GgvHY8ixEt9GBI2w5ESCoNSOUaJNvRIR9mqXj/BgDxEX6K6c2M62Fywwva9Qh71Hc0ZoMuKR4Vg7rOC/LQ1sU92MRkm8x90Dptl1NaqElPHC3YDiSPPGxM4fgrxInnMouVsu+noWta5Mn2oRzjzV58MjraZe8v+TvPMiWEHMWaz+zxQHihG18C+eFeG9wzBWflIp772xdsqB2nBq75ADegOqEPcy1ta+BDmeYIggxZYcscadGlvzWMDXob4hDdCcU+5lNNSkp8bJ4QJ3mLJN9ENb/oCZo3DowUaPj4QuGydLt1UbjOb9yJDfBtTGU6BwC2ABV5PYiCKeRobw2B0PgyqtkSji/5YItLQdZhHBvhECIArAfTQ0Iflj2qPAuPIz3pdJnp3u6hgjukT94boNxo2tUOQnvwzTNOhAqXeDb4cmiGWoHLTkkzku8sIAbcfynXQSPYkXDZQ44OQMAMFRbo+qpPUqyj5X6FFm32sqEnbgYbwrVVDqeO2GLXR4lGLYPzfhslXefpScPHwa02LxV9V93WS0f
 3FdCUODU
 EQ4J82jqdmo6TxHoNUbzJAWhbtjsW9hpcSvS7Lq05biWTp/zaJBz8cBIQSlypSLnPtc7oqlbRMoKMMedrNIly150i+og6MmCJ5t2qAcSf0dp/+TZmyl/ozvoLD4dm5ndqkqh5LzGF9tfAodXsRDrPUumpkve/G48oGXW5T46/UQdWi91UbsnFWA0DkzPke/JHl3Bjc/mkrTT6m79wmWDgUHHQ1u7jgdVWPpXLZosDRr1IFrkxSkgLItEdw/naexdmjMWi6zibLgUG/WZsHsDFh0OmjL1rWO96jndf0SiTSQxghPwzG/fDtBFwig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 05:13:43PM +0200, Eugen Hristev wrote:
> 
> 
> On 1/3/26 21:23, Mike Rapoport wrote:
> > On Sat, Jan 03, 2026 at 08:36:40AM +0200, Eugen Hristev wrote:
> >>
> >>
> >> On 12/29/25 08:56, Mike Rapoport wrote:
> >>> Hi Eugen,
> >>>
> >>> On Wed, Nov 19, 2025 at 05:44:19PM +0200, Eugen Hristev wrote:
> >>>> This memblock flag indicates that a specific block is registered
> >>>> into an inspection table.
> >>>> The block can be marked for inspection using memblock_mark_inspect()
> >>>> and cleared with memblock_clear_inspect()
> >>>
> >>> Can you explain why memblock should treat memory registered for inspection
> >>> differently?
> >>
> >> It should not, at a first glance.
> >>
> >> The purpose of the flag is to let memblock be aware of it.
> >> The flag is there to have a "memblock way" of registering the memory,
> >> which inside memblock , it can translate to a meminspect way of
> >> registering the memory. It's just an extra layer on top of meminspect.
> >> With this, it would be avoided to call meminspect all over the places it
> >> would be required, but rather use the memblock API.
> > 
> > memblock APIs are not available after boot on many architectures, most
> > notable being x86.
> > 
> > But regardless, I can't say I understand why using memblock APIs for
> > meminspect is better than using meminspect directly.
> > I'd imagine that using meminspect register APIs would actually make it more
> > consistent and it would be easier to identify what memory is registered
> > with meminspect.
> > 
> > In the end, memblock_alloc*() returns dynamically allocated memory, just
> > like kmalloc(), the difference is that memblock is active very early at
> > boot and disappears after core MM initialization.
> 
> Hi Mike,
> 
> Thanks for sharing your opinion.
> 
> David, what do you think, does it make sense to have this flag or we can
> ditch it and use meminspect directly ?
> 
> Also, for some memory blocks, they do not disappear ever, e.g. the
> printk log buffer, it's allocated early and never freed, so it's
> required to have some memblocks marked for inspection.

The allocated memory does not disappear, the memblock metadata does.

> Eugen

-- 
Sincerely yours,
Mike.

