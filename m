Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85AD1C44512
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 06:50:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D4866B008A; Wed, 22 Jul 2026 02:50:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AC016B008C; Wed, 22 Jul 2026 02:50:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C2966B0092; Wed, 22 Jul 2026 02:50:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0655A6B008A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 02:50:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 77AB7A03AA
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 06:50:29 +0000 (UTC)
X-FDA: 85015488978.12.7F46003
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id E4E9C40003
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 06:50:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U6R84Ps3;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784703027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XnxogIQS7eoD999V7HLL1Y7l5CDp4hmKICTpMm/zYng=;
	b=YloTN/SCjY02TJhyCf4yYuM3qy0UnTPTmIO313maYYwbX9fxp6Fk6C3QdgvfMeigB+6fqH
	qttoOOV4hNMVQt4jjEMYn7IO0QIbIS3CzeUv/UyEDIUBO1nec01E/BHNlohdjrvgTg8iBF
	NRvxmQHEKF1aRNZX0Qv3mV8TZAzuGfw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784703027;
	b=M9LgOXQHQWs0ph56ipd5+Y7zksZH2lv7vFSrWS/b3d78mXCjx7qdrgnnrGcBAl7iAQms7h
	GmMDJl10KYpP3UfVKwPbTcsdi12E0tQ2A3pZn0t6C1nby/AawOKLrtRfDyv1SainoeOcxZ
	vPpF1XKHIjpoehtOc9OMge7SV0YiG6g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U6R84Ps3;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3BEF760A6E;
	Wed, 22 Jul 2026 06:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69921F00A3F;
	Wed, 22 Jul 2026 06:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784703026;
	bh=XnxogIQS7eoD999V7HLL1Y7l5CDp4hmKICTpMm/zYng=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U6R84Ps3/o94s4otuUkA+xNRsB5SBqBibOFkn3ZUnHYqT68BNhN4Q6nc4CuniP19I
	 zYEnJ1fmed/32oOwBB71rH0FjI5bExSFo+zlkkxYGw3sCWwij82ZJ8uclZpZQlVyo8
	 ebrxOKEISusfcf7TJmWKFvFZOfZqSmurjyLJks8m+sX/YHFgL7k4zBlJwb1k5wn24E
	 1fk9q3Vcd4xS/QdQVthkdevDIv5Suvv0pRY9ose9471KFU3cykS+x/qOOCj5ZB0GIO
	 /+an0VbZVI55lPLsc1ki6evJDFzMwpChtRqQkvtAM7j5el32I4dCakfifpWOZP5Wpi
	 LVRtdVoJ6XJEA==
Date: Wed, 22 Jul 2026 09:50:09 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-mm@kvack.org, Albert Ou <aou@eecs.berkeley.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org, loongarch@lists.linux.dev,
	x86@kernel.org, Dave Hansen <dave.hansen@intel.com>,
	Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH RFC 00/18] arch, mm: create a generic
 set_memory/change_page_attr core
Message-ID: <amBoIXBYKAhToIgy@kernel.org>
References: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
 <20260721171943.GEal-qLx4p5YbocQNV@fat_crate.local>
 <al-6aLMJONOMfW2v@kernel.org>
 <20260721195446.GHal_OhkuBCWQjmLQW@fat_crate.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721195446.GHal_OhkuBCWQjmLQW@fat_crate.local>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E4E9C40003
X-Stat-Signature: 7czdsjzoizw34k9qqkexp74w3p4ndznj
X-HE-Tag: 1784703027-199406
X-HE-Meta: U2FsdGVkX1+GnfOUEjzhem69YfVqVADoiF3i0dJuHvKBNZlMa5zkbbMq9825KUIHtkyGwPWdSi9n1ySdNr31MOrkkcE7fDy4NFvo8oW89Du4wPo/NO8m5o5NxQbWODT/SaY+hFFvLwzTReDNlMdhH7uOykTzo4Fe0P6feourR2bAbwD1S092lGBiSBT4Ncl5JU2VKYtHSM84yq4TPEHtJIMbNRnsUa92h4ctXrePSECIONO3tHcHbSQDFiN2HtFjA9WbP+Tm6uQQkIJsN0oFJJ4zmaKFemeuRauAGDTfGIC+VJYnHQP36/x4VVF4xb11MNDSoSEBJ9nKQnfx+Y+yGYSMZklOEtssIJaEbl8Ex9+4XVDQNyLzFJ0B8r+n4M3aerTCX3e+Jeq1/gH/+b8K58K8nboAEbuSv56zXKjzzutL1qy/fLjSbr8dimdss3K6WuusTB9fxeB8qEB0e/B6DT3dz3XUUFvyYcvJj2OLHRCoEpYyjGVLqx0+SXkznHSt2814/z7itjMRwv5us7fxgTsuDmGSV6K/ncNOtHhwxG66qGzojWHEwZpuV7u2RDm5WdTrUIo6aJkXqzmOYzRUNrmrkkzIyDoqmaxyodN9dVDJ02mmW+EXWxdIi+sukprsE069KSWDn0XoUBXUpemn4qhYZi19b+tKPyBcZBCkQIAx8FL9Gwe4wOAV2xFSIR0dgcQYFzWb+fMinTD4RaGCYknduj8pBtzkOR2meZVutzYVB3Rd6I6eJTfeudgncg7U7i6cwIaqMPX47fLHnCTJSa2GoRiv0eoBhI/VDukQtoYERK5iFZN1OCYniaf8h2LSbmZafVZc4wgE4798R/ztXaeWKPzIq6gN78vGqEJDcW9kvLADnKJ3A+kptI4Id+Hd+VIgTNNISTIqtHIRqMi2FE4g6CENM68YEz+MNsq4MTKAUz3EhlbHtAz8dEzRmjNeV2fNaJmz0Mrno1n0LnQ
 D/97kBiQ
 hkTZSK+FDZEkHacKpHXd+majl639j+UOJ85J1DjRH4d3ZxZ961nRTZYirhrk/KA3e+t2/12blnPi8Nbnb5P+3wvjKqryTDoWmN7D3oE0D61WWQZSLf4XSJs3U0YWCSlVT/Fvj2eWGzBC2WZ+pRlZ6S6wgQLDliMn4Z1J8LLobv3Whq37WokNOgzxWPPo7G9+J0zB/SZ2c3PU3lVeN7UN/lIsLrSyNSUNEdPH6Z5gx1P1Q6mibez6fWzO/7JdxqYATh2Tc/KGgxjEK3XghRXvbdVlAcjDVMj+7P3uGdGYFhS71q3wOsr7K8HvOOQ4zatwYp7+bG9E1ZAreNxY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 12:54:46PM -0700, Borislav Petkov wrote:
> On Tue, Jul 21, 2026 at 09:28:56PM +0300, Mike Rapoport wrote:
> > I'll take it via the memblock tree? ;-)
> 
> Definitely not.
> 
> Unless you folks want to carve out the bits of set_memory.c which interact
> with core mm and mark it as maintained by someone else. I personally don't
> mind too much.

Well, in essence that's what this set is doing:

 arch/x86/mm/pat/set_memory.c            | 611 ++++----------------------------
 {arch/x86/mm/pat => mm}/cpa-test.c      |  66 ++--
 mm/set_memory.c                         | 396 +++++++++++++++++++++

I just decided to postpone MAINTAINERS update that would add
mm/set_memory.c mm/cpa-test.c to MM CORE section until non-rfc version.
 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

-- 
Sincerely yours,
Mike.

