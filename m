Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79F29FF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 08:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D43956B008A; Mon, 27 Apr 2026 04:13:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1A766B008C; Mon, 27 Apr 2026 04:13:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0B456B0092; Mon, 27 Apr 2026 04:13:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AB9A86B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 04:13:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ACB90A07A0
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:13:54 +0000 (UTC)
X-FDA: 84703622388.19.5FD9FC3
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id 75CCB20003
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:13:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0z0jaFwz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1mckzUnH;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0z0jaFwz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1mckzUnH;
	spf=pass (imf03.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777277632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AuQV9jJyH30aDM2Bz1IuN9VTNix0UN5WEuQpT3Fpupc=;
	b=xwv3xwzXMpdQ8Sw1RPs8SosoEibhVS7cBkmHiTAcy+lgmxmZmNAoNapiAuBuNDHLBvP8xL
	agIfQOv6FwJoFPd6tmg+9Dfg4NyiBel5M2AlEzwyxf3kAuk2dMc+nWc1sAYLQ/5XU/+PmY
	6T8rZxbsshmB3KxbQXtwlSEUP8tC4fQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0z0jaFwz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1mckzUnH;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0z0jaFwz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1mckzUnH;
	spf=pass (imf03.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777277632; a=rsa-sha256;
	cv=none;
	b=bQVAKjnX1mgggm2XbdQy+bRuqdImDLwoV2vLH8zJCIgJ+PcIjCHtJe4XzTm7uH2+/M4W1U
	QjfIolhi1Ybih02leUo9Bbw2IeAwn0r7SQa4UAyJ8KgTo1hhbIVTkjuiUuKbh4x6MbRacf
	Rm7DOCW0lfNUL1fd9DgJgEpoSHSzpg0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D30B65BCF0;
	Mon, 27 Apr 2026 08:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777277630; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AuQV9jJyH30aDM2Bz1IuN9VTNix0UN5WEuQpT3Fpupc=;
	b=0z0jaFwzAjjEyKQxnVCt3DilS1qh8AVcUTdjyNX9unVq71cORSUkjbaygEJPik9LIzf4bc
	Z8SuT053SuJrTslUBIKlc/x+7oM3wj0eXJKPhEN3JNP6wTyYIWhvCfw0Ddfw41EHJHuAif
	jEHll/97pqpvBeKOeMxbUae/Tdvx3eM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777277630;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AuQV9jJyH30aDM2Bz1IuN9VTNix0UN5WEuQpT3Fpupc=;
	b=1mckzUnHukCKa96Ks+LmlW+gcWarB1YUDjcdhkHHVovufNMZltT1GNl9/Yv2OiTSp4b2em
	cmpT65Wlnu6oQTBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777277630; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AuQV9jJyH30aDM2Bz1IuN9VTNix0UN5WEuQpT3Fpupc=;
	b=0z0jaFwzAjjEyKQxnVCt3DilS1qh8AVcUTdjyNX9unVq71cORSUkjbaygEJPik9LIzf4bc
	Z8SuT053SuJrTslUBIKlc/x+7oM3wj0eXJKPhEN3JNP6wTyYIWhvCfw0Ddfw41EHJHuAif
	jEHll/97pqpvBeKOeMxbUae/Tdvx3eM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777277630;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AuQV9jJyH30aDM2Bz1IuN9VTNix0UN5WEuQpT3Fpupc=;
	b=1mckzUnHukCKa96Ks+LmlW+gcWarB1YUDjcdhkHHVovufNMZltT1GNl9/Yv2OiTSp4b2em
	cmpT65Wlnu6oQTBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 25062593B0;
	Mon, 27 Apr 2026 08:13:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LtDpBr4a72nSCAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 27 Apr 2026 08:13:50 +0000
Date: Mon, 27 Apr 2026 10:13:48 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Ying Huang <huang.ying.caritas@gmail.com>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/memory_hotplug: fix memory block reference leak
 on remove
Message-ID: <ae8avFsiMx-45ZOW@localhost.localdomain>
References: <20260426144447.817722-1-songmuchun@bytedance.com>
 <ae8U73RyTE2a6bdp@localhost.localdomain>
 <7887915D-E598-42B3-9AFE-BFFBACE8DE2D@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7887915D-E598-42B3-9AFE-BFFBACE8DE2D@linux.dev>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 75CCB20003
X-Rspam-User: 
X-Stat-Signature: iu57fe3j5nrs6yo74hw9znpb9wcdsgsc
X-HE-Tag: 1777277632-525646
X-HE-Meta: U2FsdGVkX182BE728LgJ9x5oDJ1t+vk/Qua0LLdAu8hZ8L1pbncTV5czXZMBfE2BO+M8bgtjxUSxYxGkQpjN2Vs5BWDqpXegoRkBWnaKym1CSNPSBPppT4V7ug4oUongWln/IvHR5CChuBUH/dQjBr1Vvfkbvn53NKVsGAJJt99BMbYvTW8WakR6OB6CzFC2305pjqoJhcopGiQkALj3vSYRNqR/0PxNH8j6aWjM01C91gluGd6ec1wCqu3R39qnCmGPF5YAMJYdyuyuS5O4ZCmJXXloHQ13n5hmiUHtMrL5rxCBv5n5lN3gQSAaEuKomnZIjigC5lWp4EcuE8RNb8Bx9Nr0CpyulnL2N40jnvYo0X/IFvGUCd0Dq1k4m98Bavv6GLZPc5QaVmNbtzQDMFEIJB/wr7Itw1sWlG5OeRPDH91sUs6miuSjWhTBC0j92Ns2J1t00IhMuxPI3iugkAm27O1CyfZxL3b6ZwD2hQdRaou5JhjaBtdTUxkio9uHP87HwXOhItKN0pq3j2bTi2GlJQjtlQu816bSxgMi88q/bWMLERlgFQAwH0q3mWjR0NEUUT88J9bQK4/ntrdC9N+Gg/pC2FgLQiHDQu6u1Qin3vY4x9rH/kdlA2+8O/6eB6GfG/zyfRrQmkqRhcNM+sM8scEmiAYdbBAUrXqXr72unXOXKAQtSz6pc5yWJyW6W9C4cCpBsFeCCR3HPQlDDeM+mWoVrZFFIpomYZGte8nHJFUtB2RDFZ/Er6GDxyN4McVE4im31mGewtBO/C+WBAjcunL09+nrE1Ld6C9inS6fIhgjinA2RCtxsQo6MrTOHpL9N+gEaBIObHc7+854mJe2z1YeqhCMNQ43NI/FFsuuFsFN4OKBDrLLAdfb9FtjQ8s2tsNDzA/JNps7HlK1tg8MnhaQqNLleKazV59E2eUQ/7Yg0gsj0ryszJIvf2pJvU8ZQl9yrFcSSba0a3S
 J2qqWvLt
 TN8Z0LkJIeQhQOpGWhFbZV3D7NiKh0YP7XjDFkENOXIjviF7pc6xCQRlr/pcd4u5BzaHRMNe6nm9oO3R/VBeUHLKgaOHlVEJPjWm2SAPTyvt6LzYLmhx8pN4HmZUK0aTP3v1nobGECX34jXuNzlAsMFtDQbRlTKS0ahm5GA8BRAHYKz14dEVpFjVyHBX6p1ZsH0hZMpM4CrXClKNtLexycns6wSL6F7Hlwk1gk6MBF/RytlwM4Vm7fP0ma2M7E+VB5o8mFPplMh2no4ukDXann8OzMZ+jtd3fNdCnH9P7Z/VsTHOmL0BV2nTVyK6C1evuNJmmQCfr66W5r7/2Z3NbSes3CaTtXSGf7h8Zb1URb41psTXkSD/5tl9+p/jD4ETHvBZr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 04:02:17PM +0800, Muchun Song wrote:
> 
> 
> > On Apr 27, 2026, at 15:49, Oscar Salvador <osalvador@suse.de> wrote:
> > 2) I kind of dislike having an internal put_device() lingering here in
> >   memory-hotplug code, it feels like it does not really belong here.
> >   Ideally we should have a high-level function in drivers/base/memory.c
> >   that calls put_device itself.
> >   Something like "put_memblock_dev", dunno, names are hard.
> > 
> 
> I share your perspective. The current naming of find_memory_block_by_id
> is ambiguous as it fails to signal the internal 'get' operation. To improve
> clarity and reduce errors, it should be renamed to memory_block_get_by_id.
> Pairing this with a new memory_block_put function to wrap put_device
> would ensure a more robust and intuitive API.

Even better, yes.

Thanks!


-- 
Oscar Salvador
SUSE Labs

