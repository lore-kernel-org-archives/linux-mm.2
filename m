Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3173F459EE
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 15:06:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0E5F6B0089; Fri, 10 Apr 2026 11:06:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE6566B008A; Fri, 10 Apr 2026 11:06:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD5886B0092; Fri, 10 Apr 2026 11:06:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F06C6B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:06:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E51CE16027B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:06:28 +0000 (UTC)
X-FDA: 84642972456.06.BB6078E
Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	by imf07.hostedemail.com (Postfix) with ESMTP id D39ED4001C
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:06:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=anarazel.de header.s=fm2 header.b="bePCmxT/";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=KYDpbxLf;
	dmarc=pass (policy=none) header.from=anarazel.de;
	spf=pass (imf07.hostedemail.com: domain of andres@anarazel.de designates 103.168.172.152 as permitted sender) smtp.mailfrom=andres@anarazel.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775833587; a=rsa-sha256;
	cv=none;
	b=eOgpJRAGSGOlqRr2TjZdPUAHva8qDtfIEaH4+B8jL+E/47INHyksO53nN2mucCfHJx2mNU
	tHIVu3vUkmqp41jlr9ZpbOHJxdfhVEY4HoU/0fFgx001545KxOKTfEjVMhh1nX2iXslvA+
	ndQcizIPRKFlkb24AMr/H6wdmMK3zls=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=anarazel.de header.s=fm2 header.b="bePCmxT/";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=KYDpbxLf;
	dmarc=pass (policy=none) header.from=anarazel.de;
	spf=pass (imf07.hostedemail.com: domain of andres@anarazel.de designates 103.168.172.152 as permitted sender) smtp.mailfrom=andres@anarazel.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775833587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=akpLVJx0UzSKDAGrU14pFNxh9AN2Pzvbw74VPbTkYmA=;
	b=WoSsdC8uYeP9ECXwDX3ubXNus7ZfAQ+/jSvlkS4+pKC4CRHHalWLKaeq/X3MvnPaAddSZE
	fUZwFJP4ABa8k4VdWTXuWoLw/BzdIZgVJT/sZ3qSfCMRHZwnGFVvTdoBPB4pjVtY5gAaeU
	iEJ4/R5K0WpdiUsEjJoXDhXFXuglYeM=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 2472E1400016;
	Fri, 10 Apr 2026 11:06:26 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 10 Apr 2026 11:06:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1775833586; x=1775919986; bh=akpLVJx0Uz
	SKDAGrU14pFNxh9AN2Pzvbw74VPbTkYmA=; b=bePCmxT/N/H1MhH+hoi/0R1h64
	bi/HFepnAJ8DY7KUS7nx6tbqAanucsJpWG51m4ZZMonKrO7fjQUhF6CMhQ9ArmNG
	Vf561iWQQ2nyMS1SupWgkyDE8FCzMUp+5Y6rcO/okkeLkOSjJs9M02w8n7Orp4i9
	5umoa+CdKQ/m0LQ/LDmlxwDh+tgdtJwfxItAaXqcOs8q2KAPpELM8QybsCo0Wr9T
	OSZB/7DE/m7+B9fukaPVuBrwxsQrjtbyvR8j6qJ9JBsqH2kBEu3PZptPTlK9EgJY
	AfmYUTytxmW0u6I5ujGqBi0MDy05Xs7hv5GhVnKHF8iK3gKAsks1m/QfJEHQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1775833586; x=1775919986; bh=akpLVJx0UzSKDAGrU14pFNxh9AN2Pzvbw74
	VPbTkYmA=; b=KYDpbxLfgZUnUnR8sD8FmPQqZQWBYKGiZyQ4Nuu3gDm7yVKa1l5
	oU9BaLd4aACROIPfKsoPZL31Q7VAbLxy+LhDEhd7POtcetSdH6GWJ3jnbFice32S
	xAsnSd8gvdarUEugjLJiUEor55xB8ubl9V0eNmfKNOfgtHHTMo5sXg6lhIJtZEuI
	IjJEsSYvwuBUM6YGjYJWdKjERJ5zOzH1J/q5sjmA03KZh7bRqyC++jJ7F2zkTDcM
	Kf3g05ClJB5dtqLdRE2PJFId3tvjbhH/++ZVGZC602b3FrHZvi1fPEpSdGFi7cAj
	/Wlo3NXTh7Fn73CPcjEbXd6mQuhgrWEL1LA==
X-ME-Sender: <xms:8BHZaRZWE8uB9sk4nw4WSr0cLxO_Gpq4yxFWU6nwLNmLb-XpgwWTpA>
    <xme:8BHZaSDvJsNv1Mp_JMHCOdkHdw4tHgAgG0vRZ0uf-UkPzxHFiMVhDgnTKmBW_ECsL
    Epjwd4LUSvc9v4KYMVvij31eZ28wQsFzmWPvJxuoqCcFdnWix48>
X-ME-Received: <xmr:8BHZaXb4T3CkRMSfjd0GOsjZ7KfNW_jYC-iXml0IwW0jt9tTwN7lqNMM_nvRBU2bIJ0FZQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvleejfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpeetnhgurhgvshcu
    hfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtffrrghtth
    gvrhhnpeeliedukefgveejhfetfeetudfgfefffefhgeduvdevheeuvedtffffkedtgeet
    heenucffohhmrghinheplhifnhdrnhgvthenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpegrnhgurhgvshesrghnrghrrgiivghlrdguvgdpnhgs
    pghrtghpthhtohepvdekpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopeguvghvrd
    hjrghinhesrghrmhdrtghomhdprhgtphhtthhopehrhigrnhdrrhhosggvrhhtshesrghr
    mhdrtghomhdprhgtphhtthhopegtlhhmsehfsgdrtghomhdprhgtphhtthhopehsohhngh
    hlihhusghrrghvihhnghesfhgsrdgtohhmpdhrtghpthhtohepshhurhgvnhgssehgohho
    ghhlvgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhgpd
    hrtghpthhtohepsggrohhhuhgrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopegsrhgr
    uhhnvghrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopegurghvihgusehkvghrnhgvlh
    drohhrgh
X-ME-Proxy: <xmx:8BHZaWiuFnrmiJcbgqjYx5Jwx6KiLsnEF2RDyhYx8REuoUmPxSunwg>
    <xmx:8BHZaXwQEE8sskDChz9Knu-eb79O2kNvt1AK3OTXxRsWkQWdVO8TCA>
    <xmx:8BHZaR6s62boMLuTfm4hSrccj3m6eYSoy_LU0-Cuscuw2Wx51E2nEA>
    <xmx:8BHZaQ3rvJguxSGxERwmQDm6d80va9z6fdjrC4qbBdoUnkIzBgiYag>
    <xmx:8hHZaaSV_t6dZlVVenZsQ2wO0diHoh5qQ_aF_h6mYSl5lDZXgxgfQfur>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 10 Apr 2026 11:06:24 -0400 (EDT)
Date: Fri, 10 Apr 2026 11:06:23 -0400
From: Andres Freund <andres@anarazel.de>
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 05/10] mm/huge_memory: remove READ_ONLY_THP_FOR_FS
 from file_thp_enabled()
Message-ID: <s2dr4cedsmqby6e3ijauv5p55vrde7c4ldyk5gxdw5iku66rbc@x3nipjpgqjh2>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-6-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327014255.2058916-6-ziy@nvidia.com>
X-Rspamd-Queue-Id: D39ED4001C
X-Stat-Signature: oj4eu7i39aqa57x8xyw16setxwapkcrx
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775833586-876098
X-HE-Meta: U2FsdGVkX19bQd8v9QbFNdWeE6FLpQ5qExLAtWakFC8jvWHGifC6a2jjDc1IVxWDM4/mqDlh8fUdEiRxdNFDhqLBLd7fsLUgUWvCinQ/Ux2G6uz6N5PRdauFU6derM3IR35mdyj317tTAvYcsJwCOL3PIPCUKtzqYMjlcpaY79ksc9fjlW8QiFoa2h/1xgHCjTVzYG91rs9Blo406zXdriH+TiAa7/BbQdDcQVIAoqftradGhkbocDIg9t8xYHx2JR3bjJABjLUeLanYjze6QKVmc50OZHpU+HespggBoxiy9CfAFaOgg1WNDEITeIq+Ng9iBljwWhKaouU4ISj1aOlrsGS8jiOTyQFg0XbrEgVjBi3JSCmZme6U327FpxlRK6DBW1DZrKN4QxkSe0W9p8zWD1wwsYHD3ZCDjl+mcCy7raT1M4IWhqro6h10ylYhXum4aW8tNyz70a4OXAUFx89yxA99VARjTJC8KEphj27ioeeIc8YA4mtE+R1CzijY92/OOEC6hhzppkiuowXCGOP+8C4vxKk0cjqZMdHEnP/BQyE3aGkW1KQRt4PHBkKvFrvVqHFoNu/Guu/i6Gu1y092rt+1a9E5mN9pJs6iYXF2SupH9oTbtcV4/y6s9e8slCFNErt/SnUfculrnGyinEwV+QIF5fpHlTQVwxfIqVzUKR9juuOpPJmFr4gcojzByeQv9bs0OhpP4HoGTt77Cl9xnFWr5BIOT1iYJgeWRHpk8yKkEzP0IrUnn0yb+Dpy23WQ5ZZepI/wJxLcTkxPA32nviF9e0MQPufZ8aS1aAJ0eOlB/DYJ7pC228Q+F9GHx2lXPDmzLnOc8+tV7QHwz5XJ2w+Rw9FKfJPWMWmWsdOIohq02+SAzBLNZEH7Q0d/9zcVjES0/soP0C5oCxZEoO6rde5dgs8v+XbzIl56nKQ55Xxb7qsAna3CGKmWs0f/1PhZK74XODfTIqSkwnA
 z51KxUhR
 Zhw+DtuzG76aeu4PG2f/sCb6VnxJ2caxtsHDdo/FPdptURRYhoBs+GRENFe5Cdomn+1vsv5ZmvKAyDnLJF0y54ZUU6+DvB1aIBN2Gkv4CPo/2t5/pkuHCff0r3I0GuNq6bHn0aBbSBhOmwzqVqSYo/zW4snN4lfFnQcceWbJanNiH4dI/po0lL5uye6TutBtysIlSINK9l+dpDCRPz9MRkVPhQsrYk1hTWBCSDWeMEuaLZoGO87396XbtCf3png08KPg89GjZWbylfYV1e0IHc2CaZnLaPRzEm3B8EsP8EdXOlVYzuP8wer5k1sNddV/BPFhnA9FEwXZ8i4FPFo1hz9h/OYk51YnEkRRTf3DdXmlg/8rS7e3RkQv2jvjWhHaL/eVC0t5+tefhSBNIbrVrxF7yT0GWunaQaygxC4v6muZ98dZvluokcWuTVMD2E4ed2p0Ec0VCeRDcyH6FXIa+dG9ZPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 2026-03-26 21:42:50 -0400, Zi Yan wrote:
> Replace it with a check on the max folio order of the file's address space
> mapping, making sure PMD_ORDER is supported.

Question from a user space developer (who learned of this via LWN [1]):

Right now MADV_COlLAPSE on file mappings appears to only only work with
CONFIG_READ_ONLY_THP_FOR_FS.

That's pretty sad, because I see quite consistent gains (~15%) from doing
madvise(MADV_COLLAPSE) on e.g. postgres' .text - but because
CONFIG_READ_ONLY_THP_FOR_FS is not enabled default (or at least not commonly,
I think?) in distro kernels, it never quite seemed worth the fiddliness.


Do I understand correctly that by replacing the check here (and the
predecessor commits), madvise(MADV_COLLAPSE) on file mappings might actually
start working in more situations on typical distro kernels?

Greetings,

Andres

[1]  https://lwn.net/SubscriberLink/1066582/b92de1d7595a01e4/

