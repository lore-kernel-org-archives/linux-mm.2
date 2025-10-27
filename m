Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43623CCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 09:56:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F95880031; Mon, 27 Oct 2025 05:55:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D0AD8000A; Mon, 27 Oct 2025 05:55:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E63780031; Mon, 27 Oct 2025 05:55:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 76F928000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 05:55:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 250AC16056C
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:55:59 +0000 (UTC)
X-FDA: 84043438038.16.F6E5621
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id CFB43140009
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:55:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hJhThr6T;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="ncxeZr/B";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=o+PNqcrg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5v2b7Iyf;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf23.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761558957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+TESXJivhsVzke6gCi9MxzocOEMcQDQbrv8+ih2jzD8=;
	b=8K/ABWFholpZMqVoBYklYi/izY+bPvDZvWtzSAQdD8d7apAYE6StGe39dAwd7UuNpcK4NW
	SOZmk2waXjX8Hl2/jzWK1BtIVcIF9YxgfJuhaHzsFv39gG+swLBI/POk7q1OYaEPjv9hSO
	6be9E5AhZYtghkfQWZDBarPEff6nWkE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761558957; a=rsa-sha256;
	cv=none;
	b=T2Qj34IrR36OW7JeXdFKwbxyQH4785CAMu2Gg9KXMvFSxU8uDRBGHuPRDX7+Em8HEoxSSb
	gkNd7e1CAzwnrU/umqFoJ1CyHjTNNQMq35R2HrPDriQoH34f7+Rgo4DWgvC87iRfN1s5yw
	x66SmkaL/KcTmFgpzLeZblv+O1AiquA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hJhThr6T;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="ncxeZr/B";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=o+PNqcrg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5v2b7Iyf;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf23.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 23BEF218F8;
	Mon, 27 Oct 2025 09:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761558955; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+TESXJivhsVzke6gCi9MxzocOEMcQDQbrv8+ih2jzD8=;
	b=hJhThr6T29fzVREluqb3hIvyxRa7ZFpoBH1rzIqnaqF/e+uPZeJ658pOM6rmZaTvWMhhLl
	2YqvpxJzwxmxJ7M7aI29PmM9M5COPkwNuoCeJWbMmfBueV79sTdWc0Sq/26cUtLa+AsqPB
	OOZYhbBqU0Vp7uLQFTLCgguKziz1KHE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761558955;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+TESXJivhsVzke6gCi9MxzocOEMcQDQbrv8+ih2jzD8=;
	b=ncxeZr/BP5AH59oDaQyNeCiyZCMKqNQ9apFx+yUld0ikRHW8ZbeQeHwJGYRof1i63NH1DM
	Pu8lV8oziMIB9PBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761558954; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+TESXJivhsVzke6gCi9MxzocOEMcQDQbrv8+ih2jzD8=;
	b=o+PNqcrgTPKZwZkneY6s38vHrTrY+zFw5l5oink1F2DPPpVAa2kUQwHz3JxEmmIaRDKTh3
	9K3Mvo5hspGHEcdsNXKcPGeMVh6hWMujdNy4dO8QIEYmREgkP83wNxTGYm2gAukKlAXuVW
	MFDEZx2HTauA8iayTBZ4WUqCAyVqhmU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761558954;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+TESXJivhsVzke6gCi9MxzocOEMcQDQbrv8+ih2jzD8=;
	b=5v2b7IyfNkSKtv5HjNWUqzjFlVTbs3nE3L6zbSBnhnEaqMyv5xpjVsPBCFjVxCobcSQC1n
	s7apbN2iCAB9HTDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5C2CA136CF;
	Mon, 27 Oct 2025 09:55:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Yv24E6lB/2iNeAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 27 Oct 2025 09:55:53 +0000
Date: Mon, 27 Oct 2025 10:55:52 +0100
From: Oscar Salvador <osalvador@suse.de>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, David Hildenbrand <david@redhat.com>,
	Wei Yang <richard.weiyang@gmail.com>
Subject: Re: [PATCH v3] page_alloc: allow migration of smaller hugepages
 during contig_alloc.
Message-ID: <aP9BqHy3ksstIxfU@localhost.localdomain>
References: <20251024192849.2765667-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024192849.2765667-1-gourry@gourry.net>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: CFB43140009
X-Rspamd-Server: rspam02
X-Stat-Signature: 5t3gq5o7c95yrjiurj7isehgnko386xy
X-HE-Tag: 1761558956-56954
X-HE-Meta: U2FsdGVkX1/f5UkM6sJJxQty8Y/ruR35e4fZgawTaJUPqq0IgyuFuGYKElG514yVLnufjJrqdDwiShP25sY3eFtvLBJvSBUWXOYrbh1eaWIt2agAWvp2sLvFs0Sdr/wKG3MJ/Ac5h5NwIdy/DofJiAv1sK/5e4uyJUaW6VY2Sr1oofwRlRF6ToFf7TZ7FmTkezS7BLX5FdqiRau81SZyZ+XpU8S4xs8RW0o682hnNhFvLXeeYXgJX8ZVqujf+7eAEUos04/V49E6h9EA4B09uliAaETMDPeS91ep7CI3eOmRHaCVJyukwtX8dgnrPKZQXcfP96z0Z55MSO0KNokq9W/jNcgtVRoaYTWxkoLSJLfZwo3Kb/TtiQnk2MR1R3SoC8o7xCEauX9MQk+cHtMc1EebtzhQ/FAxB6npEjwiaxehRPTcTmLVFggC2mxeJNqYFIOnvNUXc1rkxqFeMruGPXV0MA9rXtrzJbaCu63Jrj/9kb+eEjrp5Rg2mkDtUltleh8Bcl6JO1U5BTlQsnZRoAmJTY5N4YUlW71AMC2HoSJC5AynFVuKBDkKo3Pn2sxpzEwPsQjRAh3FcJw03d90tsrLL6iCHQHNgo4uVolUTJJ71HdZqfkro7MSiE9qoUheS50f45ZPdCA8oWX5gz3H/ogYU3raEY9rM3bunNClp8M7Wjh4L5wiunPVLIIVCpRySgsw1DeUQ+oXoIqJLE0tBDkfPOdz0CoD5iQk6QJXVZYU3bRCAaEyUD0EqCurMnbhoB8u9YoUb0dLyLBgeML9EDimV6f+0IMN4EFgJfoUau0NOfYvMQ2x7JdTMSvdC2VSTVXAGnzMfzFUeJwNg6DfNiQsOUO2z2aa4bWtvJuqxzI9Z1SJJwx3BtSvKrcxVZGsOs2cqI5+XZIfCJ8vQrg5ZGJNWJFGtrcECwCEwlkmwWkKIEguFRgiFIKIANHf3v+zwoI878bfzIgLL3Wm4jf
 Pu1pGmUD
 k86LzdXa30ZEbIT4l7jNHfD5dprBIhqKghWuqQkkf1UYnQPTGjIJdnH5EX2wqFuSt0lQVoozj4UvDcGglTeLNegc+2xUpokfcPEoZ3w/2cRcLilwcKxW5lbg9FROpkGv/ClGfOEX0ZV68gWhFEDkA51Y0Ob1xK9JkMQO3e3zeR/Fa+h4T34PE1WdIJ1EhZR4O8cgQi5mSqPhS0YNQD2tW49kIMTnFCXVhg78xHyCRLQQst2WqbHqzSG/ci/5tNqdKicQjewUZy5fcNFn3CfqAm2qFaDw0t4QIfiBE5dDvdrkrYXltntZ6cOiB6teX4K8ED7D+kT1I0nPHdm+aPD3m+JKg/dUkmY7AhyS4vT9vezoahTN5eyGbovEbBYWbJmxwU8CJn2Y3YmcxyO5LfLx45eqd994aAP+jqrYGS8kij/Sel3esWEDyO6kDFhvjx05KVlNhgUwJyr9LqkzH3IUBWhhC1/2Gi/2xAinc5YdSjuooxSh+X81FDPP0Uz0ZeykBg4vS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 03:28:49PM -0400, Gregory Price wrote:
> We presently skip regions with hugepages entirely when trying to do
> contiguous page allocation.  Instead, if hugepage migration is enabled,
> consider regions with hugepages smaller than the target contiguous
> allocation request as valid targets for allocation.
> 
> isolate_migrate_pages_block() already expects requests with hugepages
> to originate from alloc_contig, and hugetlb code also does a migratable
> check when isolating in folio_isolate_hugetlb().
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

