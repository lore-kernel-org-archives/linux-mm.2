Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 047B7C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 14:28:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 148546B009E; Mon,  7 Sep 2026 10:28:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11F1E6B009F; Mon,  7 Sep 2026 10:28:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 036116B00A0; Mon,  7 Sep 2026 10:28:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D8A436B009E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:28:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7337B140199
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:28:25 +0000 (UTC)
X-FDA: 85187196570.30.B86F7D6
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf29.hostedemail.com (Postfix) with ESMTP id CFDAA12000A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:28:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Umw5ALif;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf29.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788791303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rztXTxArE4kzHUFZdIzTTHMPPaOeWfni0CGbnXtVrRk=;
	b=dYMYCyXjnqgT1wEDtsvZW3eHA68Gjfu5PmBEKTBP0plar8hG7TOSgaWIDjqxzYgdwIZFVJ
	+r0M0JCn1QRghWsJpTiaLHDV/IWR7ebgtfUqff9bidvO49Dnkjppgug6a0vas51uZLBVYR
	/FSdbR0ASNncnBtIz5OBguxDxvEtU+w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Umw5ALif;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf29.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788791303;
	b=fT/cZyjEpYxhqpr1tDLL5cQnK2vQB4cuk/Kfvrmd2id5ljlHvCOzc/RoMuTHIR8pu9+04a
	vsVWVw7gBnyFM/ZcO9R/4Yorqu7eLyHNXlGXZdIBmeMNqgMk40I2WNQWWCvfJXdschSEHb
	N8TgcuJSw+5mOWCQB2MH3AH0zocijA8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rztXTxArE4kzHUFZdIzTTHMPPaOeWfni0CGbnXtVrRk=; b=Umw5ALif/GaeXHkSspbhFvoHpV
	ijLLQm+T/BV/rHhk0gvAwCxMVRwRTOMtx26aNAEHtJIKbdhQM3WxgK4MokEQAWyeeKWPCAJTVlXML
	bmc2f/MAzn+EgE22BwT5eY0Is8BLiPfaf1n6kzhQdx27HssCtRhiyNcPcRoU9gHy+ibvVg0M0nioW
	3IuJob4fpt0JUH/gtsGGD6qsBZRPB705AgrGraAsrtjCn18wDiA9nrnJsMkZcITC2MHW5AijAEs0G
	Ijk7UlL2EHiQ2VcO5N1WnjmfJ2soy0YOdupGKE5BNrIOLkbQ2wmdqdrBHZfhCMFHJJjpUuKqfX4Ts
	ceKTlfCw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x3aJu-001ZS2-1N;
	Mon, 07 Sep 2026 14:27:38 +0000
Date: Mon, 7 Sep 2026 07:27:31 -0700
From: Breno Leitao <leitao@debian.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-efi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
	kernel-team@meta.com
Subject: Re: [PATCH v3 1/5] mm/memory-failure: efi: add the
 LINUX_EFI_POISONED_MEMORY configuration table
Message-ID: <ap7HHvF7tXmz4Nsz@gmail.com>
References: <20260826-hwpoison-kho-v3-0-6f79c4b605bc@debian.org>
 <20260826-hwpoison-kho-v3-1-6f79c4b605bc@debian.org>
 <apGOr0BAFc1DMQe6@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apGOr0BAFc1DMQe6@thinkstation>
X-Debian-User: leitao
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: bd85j5457icus1k3m6ehpwy1sz4sgesd
X-Rspamd-Queue-Id: CFDAA12000A
X-HE-Tag: 1788791303-55904
X-HE-Meta: U2FsdGVkX183PnP1NFd336BlR78Q3C5VbcevLvVLWISX9n0lpmXOMe2y7jT52j/F8VqOSKIjJJababw9aX+FdhUUrQp07ROde6tzCQLeuBIFD0IGYkWIQGRa9v8FBN4raAxWMBEaTLP+48Elcl9ufGy5Ej1uynpn79KGvSZgj6eB6yhdU8jDr3+5cyH402qAncgWem6xr1zhTdB+Lok5qpFO915l6yxNmBdfqj39G81usrJjwz3544KYu9dXnHpJXao0GWsxyhMvSlmNvgGZP2i7dFRCOLZW7ZJls685RIoNMAKsKFRtosr102rP67nCa+nL3VnSmwtjmI1WFowsC8yVdh8EucD062BlAuShcnKIx3zpGPTpzVM8Be84rsBWvw/aDpP9E2vIQTeEOjKDdo+SbY/e4Syn0gD6yAm2ZWPRahDK3mfJML4kVhrs46IaTln1rekUhPK9uiuL2zi8XCnwFdob2VFLpQg8V6dISdDUiPf/F5XfmokpTciUJn37/8MbJ42XQ4e09/hTANItIKAT/OD4t/Ij0OngAaiMRz8imz333ES/FBEYymTx5G3419f/V48pJ7Vb63vVN5mZ5clVa2msRLLlCJl9sOq7xQcCFOqeE2m9GAZvcizFSVw4ndmx+VgdyZkw5ziRM7fN5CbtoOyCVNT4zufCnC2cxl9YwhBTjQM7xDECm31bzkJVmuPMtQfCncHL2RJenDoYFt/DA202P7mN9ZjXlTpH24saGYVmxOG99Wj/0hdBUAGglX/a9hy57N2e/bxRyrW7E/QtKTw8AtaYpLx+bWMc4V1X1y3QPvwXWhm6gVNF2Av30rwrXfrRPvJAskupFe6FacUpjbHSQwpKjVh9UHGfjGxVhLPUkUV/XgXk5WWZ/z62PrAQvBd07oG/3IU5u8jxjJVMxh9XJeykf8v+VhsoM/ZMIWy5sRBlEN01Hkolu6cT3Ze5B2hWD9oUdWj/p3L
 nQTzZG2F
 MR/2DSI6cTPdNUrjWUDYitleeOHgAYMxgu7MSLqjaf3pD8rueXO5KvoO+QlsMr4j6WVCWqouB+bHOJ806VDHWUZQ6GeHSrkJLh9BlEZ57/A+Nh5TPDNRuQ+0YaHvX2U6mF9JYpGkk869MyqxGJerJK1oiGGu8SPIxH0i1J0wTxoQbebSEEtPiHlQc2/06A75gtNMbqdys5l/rJhLxAMUGbWJcql6GENkf+BG9qXof8na+tC8tzoZfEbvGjugxYJkbtzXLdw7LXRPvjAWJXXn+LomiTvRLm1A20DrK1mgil8ABYch+xDMaaXay+VkY5MHpQp7HVDaf0v5dghsbpQcLkoC4RVYrT5yHsP9l7te5buzcXvHlKQeanXl1Y7MTnbdfkzuo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 02:47:39PM +0100, Kiryl Shutsemau wrote:
> On Wed, Aug 26, 2026 at 05:03:52AM -0700, Breno Leitao wrote:
> > @@ -1271,6 +1274,16 @@ struct linux_efi_memreserve {
> >  #define EFI_MEMRESERVE_COUNT(size) (((size) - sizeof(struct linux_efi_memreserve)) \
> >  	/ sizeof_field(struct linux_efi_memreserve, entry[0]))
> >  
> > +/* Bit N covers unit N of physical address space, counting from address 0. */
> > +struct linux_efi_poisoned_memory {
> > +	u32		version;
> > +	u32		unit_size;	/* bytes of phys space per bitmap bit */
> > +	u64		size;		/* bitmap size in bytes */
> > +	unsigned long	bitmap[];
> > +};
> 
> struct efi_unaccepted_memory has 'phys_base'. Do we want it here too?
> 
> It can be helpful if physical memory starts very high for some reason.
> I believe it is common for risc-v.
> 
> Tenstorrent Blackhole card has 4G of RAM based at 0x400030000000.
> Counting from address 0 that is a 4M bitmap for 4G of RAM. :-/

Sure, although this won't be used much right now, it will prepare the
structure for future expansion. It also shouldn't add much complexity to
the process.

I will get the structure like this now

  /* Bit N covers the unit at @phys_base + N * @unit_size. */
  struct linux_efi_poisoned_memory {
        u32             version;
        u32             unit_size;      /* bytes of phys space per bitmap bit */
        u64             phys_base;      /* address bit 0 covers */
        u64             size;           /* bitmap size in bytes */
        unsigned long   bitmap[];
  };

and then offset the entities in the bitmap by phys_base.

Thanks for the feedback,
--breno

