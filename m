Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FB91CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 04:44:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D10966B048D; Tue,  2 Jun 2026 00:44:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC1AB6B0490; Tue,  2 Jun 2026 00:44:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD71C6B0492; Tue,  2 Jun 2026 00:44:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC4376B048D
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 00:44:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4FA6691ECD
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:44:55 +0000 (UTC)
X-FDA: 84833732550.17.0B9AD6C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id B89A4100003
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:44:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dscgPlEN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780375493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HBcSho0hyTBOiz46tMOdOloLT1LDWsfZliq97z/1xao=;
	b=h2cqEneWZd4Z9LYJzp0+eM0mfmwe3WzFI+TWqwWBAUPaCFP1ePywsl3N5v7W8M/vtqvM12
	/u/Rnb6OgU8xEqNnDIDnPRy8n2ArlKLmClf89ofVrGW+Zz23QtmyBVboT3j94XFcRPj+bS
	l1WB3aydCp4aSAMh/FCd3/34dxPoxuI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dscgPlEN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780375493;
	b=PkjB5/ByoDqtr8NmPIGo2dIPG3PhKOgr6WOEfqO2RDMWJ/eY0f7R28NhXLmJlyNTkIu1U6
	7ebYLpEbOC1VbAs/ymmQgwqW5awJHfrNY4YK/LZe+FMMIlseG/yWyzhLMxGSvXVN/6+v8m
	O/MQH0tvmFZb/fCUok1nEYGq/YWXClQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DA99243951;
	Tue,  2 Jun 2026 04:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F821F00893;
	Tue,  2 Jun 2026 04:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780375492;
	bh=HBcSho0hyTBOiz46tMOdOloLT1LDWsfZliq97z/1xao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dscgPlENCGbnky2yH/Uf26BENDpdZmCNYagwcRFJUhTkMydO+/0JasfnOfb6k/Pz8
	 5Kzg5CgZ3DbhA3mk2MbFQw+6FBTCNen++P5Ul6oWqo4nLZ0F8LX+Or0ibTfPSHM5q7
	 VfxD+jIYyPQaIgwUc0Qq+IGRrA8unrZIUZ/goWhu4AnrDEtaHvsU8DR4APQe89ehJI
	 Ef7lCvRcfISQj6222jsW7gGQ3StuP09wXeRJcybPZyOM3plqWfZQkRzqMEQsgXqOBp
	 lYD3IJ9ivvNM271iJK88fZ/7GtgwWeYa7TKfKYoD+b1skZ4AZdek6Gtue2J4+n5NIg
	 jja0YigGJim0Q==
Date: Tue, 2 Jun 2026 06:44:42 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
	Andreas Larsson <andreas@gaisler.com>,
	"David S. Miller" <davem@davemloft.net>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org, loongarch@lists.linux.dev,
	sparclinux@vger.kernel.org, Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>, WANG Xuerui <kernel@xen0n.name>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v3 3/5] riscv/mm: drop vmemmap_pmd helpers and use
 generic code
Message-ID: <ah5fusGeBmwsZuIm@localhost.localdomain>
References: <20260601084845.3792171-1-songmuchun@bytedance.com>
 <20260601084845.3792171-4-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601084845.3792171-4-songmuchun@bytedance.com>
X-Rspamd-Queue-Id: B89A4100003
X-Rspam-User: 
X-Stat-Signature: rp41kqf948fp39f7mcbjo3tfcbfsbu7y
X-Rspamd-Server: rspam09
X-HE-Tag: 1780375493-787809
X-HE-Meta: U2FsdGVkX1/HRcJkp8LzBp724l6z8hW6YbuJNhf4S8Igjft6Yas7YN6gb5tOAVSIcGRNG0pxDITGDQWcqTou0rHSW55o2B0tlDjOyURNbmBUZu4fvIFHR7sv36h4NEyEyGERvVHqkZrkNLDy1nvVaoU3bCUA24dKMuD5M9fR+Tx3+WWmyc3oyaWn4j6dHWuvIshM17jcrDgDupU/DuRLgBM7lrJ9rNF9P5AGoTLNTTuMQYJhOD0ZtPQBZ4bD9vhVvn38jcHMk76m2DsNmI0DQY7XGunZINQdpldShkKJSypp/w9TeCMH3ajX4jqd+gCfFwZD/cZ3ZKpW4IN6wfuNjTkhj79k8LM7/SjnxJ8sm2gVzQG5Sqa+7FVMegufhkQFPSaiMCdwH7wVDQidNhT40AakDehVvDDem6DmJLn4oufybHxN/Qz1aVXkk4gldHvn+667hQ97IfhJFLfdkDqfWCbynHF0D2osoyRX3kE0ZdHcbfKBK1CPwcaNCNECxTZdg+F5GnMjcG++RcZrJrppgoGdbv9xm+LAGThdl84NqroDFqcOaJt9jem0MANpKEZajMxGwUbA+2R1ZsXduUfXonatfvgPm70BFUixghCKHt/rLsdOgnVjeeI+ghycN9puEe4H0zI6o1DJEind/aoHXcZITDba7R8NjA4GaMWGn3e4+owaNz2Z00YGlOyFbKJ1UWgm/Bntfsvi4mLASsbSaR52zaNW0DWZ0YIiQmmPRDd7sR+oUVfJ9PDBT4PEw4Wpd0qhQ7SzutOH9vc9YUocEWFvy4iTkI2dHdySdDxq5m9ZLQUoDY4UUMO8rcifAM2Q92Ho8x9vPYUYL9WmQAMX6KQkFbpT9oo5UigTvn8bCxcI+ssks4MlreAsp4efe+tGtTQh7OcOUThcCCXphC+GwuOv3Ymp+RrjRmTqB9FqiOpDNrr1zWAKLZ2d2H7HHQW3TVG9l+8BjSEtT/fxR9q
 0X75vHoc
 P74W2xJEBgPiuprSTtEpWUXFsdFsFw89FRh9Dc47/t/UBpG9HcYQS4FHGGRxKbG475CJy1jV+sXg1CyzZ48yxIg06/3dSK6SFJQHCa9aqolSo9S8iUwfdqzpfT6UE1FkcwoBr3eE2NRVasNLczml+GQZu3mlmRXEvKiBQBA2jP/av+OOU4AU2kFMbcjiZwisrd0tlZMbVzHEfwi7s+buJKdi9kYygvVieiwVOdls0q6JzXUz2eKUjEnhEcSZbSgkIGLZsXhAOvCNvyGH0yOuODlZ0KHjKBDQXbUfLzUsCroNj0004W2prgbHgKmwVeb2GNs5DssHO4RnigPGCtVNhcjBffw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 04:48:42PM +0800, Muchun Song wrote:
> The generic implementations now suffice; remove the riscv copies.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

