Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A229EC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 08:46:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64C056B008A; Tue,  8 Sep 2026 04:46:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FCEB6B008C; Tue,  8 Sep 2026 04:46:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 512296B0092; Tue,  8 Sep 2026 04:46:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2FA926B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 04:46:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 87663120462
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:46:40 +0000 (UTC)
X-FDA: 85189964160.10.60D9E48
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id ECC77180002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:46:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PFVEN8Jg;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788857199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pi6DH3h9BVaC49RRQjlI0O6aYCIlCAFAZNGWG1WvFkY=;
	b=xlPmyNeWrgwNVhGOdVmPQU3jpsFUseUs3bpGBcDTQsZ0hAIrp0SDg75oZrrc0GtYsTDvH8
	lQTc77Rc7gUayR9VZgvJNeTdNn4Q5DWS+xgCOiGEvAVjarku2s7IlmratFawKh7OsXKLzW
	WGzdTxCR7JHknplMGrbT39mGFSUoAc8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788857199;
	b=FNTDAUfTld+I9xTuaT2pSAOtSQquBwwUDLx/28gEuMV5vJXXYH19u3D7ugjg5BRv4Tko0I
	DXgnqmwl2pOMkbjBELdOAm/CG1gTnu4hZtxTVxC+0knfMzZUa24cCXe0BQF3SpxzU2l0kv
	0UkW8um+7QV+l/nurrhhQ4ZoQtW0C7c=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PFVEN8Jg;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F3BF40BD3;
	Tue,  8 Sep 2026 08:46:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 865B01F00A3A;
	Tue,  8 Sep 2026 08:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788857197;
	bh=pi6DH3h9BVaC49RRQjlI0O6aYCIlCAFAZNGWG1WvFkY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PFVEN8JgyzdpOjdG910dp2qyUJAFTPtXr0iNqWNr5MagH+H0QrDfVOBmEq6qipxbZ
	 ++krRlOTWT+r0W+aWIpso/p7i548JDpWtUPeoJ33EH1oE/mskhWZ/+AqLSPidspNYi
	 Dkv//LMEhgIc1fNBR0aGJJlJPMvUIAZR5n69gc2lMfZBqn8PFIqfVk0MjJvjjM2kwP
	 tHcZLmXVCGfVFqK07+qnTf1iKO93NehQ/JPShF2pvFi+2TDN4voi2YR/aZhtQVRz6F
	 FRfIzr2sG6JwXZHfdvK6GP+pqy0lc6TPJtcNCiQI143SWohY2E+jlZWsZWNmiOZXvr
	 l1DDLcjvqttJA==
Date: Tue, 8 Sep 2026 09:46:30 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 3/6] mm/vma: only permit MAP_PRIVATE /dev/zero to be
 mapped anonymous
Message-ID: <ap_LD6lE6JTYouGr@gremlin>
References: <20260902-map-private-dev-zero-v1-0-a578c730cec7@kernel.org>
 <20260902-map-private-dev-zero-v1-3-a578c730cec7@kernel.org>
 <d6dc52e3-b27d-4663-848c-a2f270fb4c5d@kernel.org>
 <ap71GOPAeKHfHp5J@gremlin>
 <8f797f01-e958-404e-bcdf-283da960e95c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f797f01-e958-404e-bcdf-283da960e95c@kernel.org>
X-Stat-Signature: o64wuas48f6byuwtsgt3qczmgdffyiym
X-Rspamd-Queue-Id: ECC77180002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788857198-568772
X-HE-Meta: U2FsdGVkX19ngc9maZMhquZYtVNGEXeDQOTJnZ5Zd7FLzwbsYEC0+RUxA+7h7t3ZBiJV+qvgpj77CFDqCY/1uM1dMjlJGidAiXbJPQds/VEaqz5mX2BJmAQve6H1zae1XbAulL8JQXaTxnixdTFSN7UxY0MLVg6//CssNhl4Yr74iJptBV7vTSDyVVd7j+JRayIFUlYUFBvAyfUoNiqxQzFVLnXywsPS2NwBoLovLjFUvWewA1D8zgzYkTF30cX6LtHrv0E7QLgI8aOvOGXivlnHOqarhVLzTMbtKSw4lNNkZu0yIDBXyr0ADJXiWdecrR+hAwVGMkyMLuFqOdEpn148zzy9jV9o7NRrSElaGeOs79223z0O6vW/UhXq/3Za9WozqXH1OQSnX3HsZNL2/ZcW1U2pNk/YK4HEHR9VZ1NLgAOqLg4WAl+28mVD8AJ9UxrfmJUHFHE6uNOD8L6VPwCHWOxPdvbcTFZyJVoOKQC/wLisLssDtnVu/Ya8J9yNUYhVcFtveduBsJh3klvbyv+YW2gjT7oeCV9Npoi7kfJGnejWXShYi38+NMOIqbMFMTflCqT24/CbTz6Nn2hr6mmFhrn5HFt9fCce1SGEeAQMCVEPM/EPNDj9lYID38Bej6eYLQacNFqyICTo1K6hIQdpjg0zMVw0ogD3iVRNT5zpvllsUnJKyVdo4oq9C58N++gtG7QIVQSU145o4S3HAIz635QqGrLLQxLsq5/t1K8iSYb0/pB6CqNtUMYRHrWXfo6Cqhf7zdQeFRF0wDh2wwS+E8ZFDTUxKNreZnxuDNHCNKiIf64mCLPBuR/gW8Kw+cf2jPYjjMudxGqWhFa8GA+Mv6M9Q2NraNRXsCbSyTmhA12PHJ9dxfcgHv6emGScbDL2wPjYcxk7pNenq+ecAAGpmXYABDnXtinbRZshELuLzIg8c7ljh/tktsAQFAtfZMQRClbloCAzlJ4Hdva
 5o2CbGnr
 rvvbM/WxuCPtYBc/6VgsBxLGe5H8MsH2FAgzaLnSgneSb9fxpb9pBdtScKE1UFOzxFr897Ys/C1PcpNoJtiKWj7fILGEZH24RCGPfmlz1pMT18XLHV4368P8vywBzzrW7bhrx8iuDQAGvAkE1BUwkJiRKjJtDYwh6C4EtHVZEQx9XDhodQ1GcMGhQtPv9Du9LaBBJgHLB4dyDRIzdH9yJJ+crGoWJx9Dxmh908AR4wW4J0SolwLSmCQhx2GaoI9R6iZzJETOTz4Iiy1gZA01RWBlexEVP700xoFAC7MbFjmz5f9A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 09:54:04PM +0200, David Hildenbrand (Arm) wrote:
> Yes, but my point is that the comment
>
> "cannot mark themselves anonymous"
>
> will not really be correct after the next patch, no?

Ah ok ack I get your point. I will update this comment in the next patch.

> >>>  		set_vma_user_defined_fields(vma, &map);
> >>
> >> Ah, we have mmap_zero_prepare() for handling the shmem_zero_setup_desc(). I was
> >> just about to ask whether we can just get rid of this here.
> >>
> >>
> >> But, hold on, do we now even need that? Could core-mm now take care of that as
> >> well, and we could just remove mmap_zero_prepare() entirely?
> >>
> >> That is, we'd make shmem_zero_setup() in __mmap_new_vma() take care of this?
> >> Then we might not even need shmem_zero_setup_desc() anymore.
> >>
> >> Maybe harder than it sounds at first.
> >
> > I think I'd rather that be a follow up :) this series is about eliminiating the
> > one last (I hope?) corner case for anon VMAs.
> Right; having to deal with anonymous mappings that have mmap_prepare is rather
> suboptimal. Ideally we'd just handle the odd dev-zero special-casing early in
> the mmap path also for MAP_SHARED, and avoid messing with mmap_prepare entirely.
>
> So agreed that this can be done separately.

Yeah, really life will be easier once the mmap path is gone in general :)

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

