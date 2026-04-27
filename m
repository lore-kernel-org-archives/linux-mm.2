Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 055FBFF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 07:49:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BD876B0005; Mon, 27 Apr 2026 03:49:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 246F96B0088; Mon, 27 Apr 2026 03:49:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10F0F6B008A; Mon, 27 Apr 2026 03:49:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F0D926B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 03:49:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8A37B160783
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:49:15 +0000 (UTC)
X-FDA: 84703560270.14.5FE0179
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf06.hostedemail.com (Postfix) with ESMTP id 56BA7180007
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:49:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0zemnqdL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=flHFUWs1;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bdH024rO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="QmA/N/+b";
	spf=pass (imf06.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777276153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=arplvSPi2JFlECX/+/+1OAM+U1qZByH2H1+6yaAluqQ=;
	b=qyVCMExVC/t8lzGyKhvVNUiS9UIcJxcwdKaH1vHPNdukucZ3/M+PB94sQF3OLE2S89KvAj
	3E7Ozt4eir8oTiOf/UrkLHZcYQpfVu+6GN7C8uXY+n5Q495y8Unm0u3RX4cbdDMszrwvWS
	KNVxqn0IVfPiC65HvTkfLjMtixpH0kY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777276153; a=rsa-sha256;
	cv=none;
	b=rz+Y2c/Phzr+BEMKO96LPI/iOsVIWcPgLvNkcOQRASlSutKgkjNXWoi3pVEnZNQeCA5N/P
	NzCKpt2Y/+7hYSZ0pJU29ALCMDQawM/uoRHOT2DhG4GVGbKrx1WHa0Zkw2qwnOqnUfTaU3
	aD+6s+FWxw5g9d7VXCOkW2Rmv9iFR3g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0zemnqdL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=flHFUWs1;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bdH024rO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="QmA/N/+b";
	spf=pass (imf06.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6AC896A817;
	Mon, 27 Apr 2026 07:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777276151; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=arplvSPi2JFlECX/+/+1OAM+U1qZByH2H1+6yaAluqQ=;
	b=0zemnqdLbFzIuiF6POubYzCgnUdYGnENR6z9NkwoYCGp+fkx2UHmXv2x81dag/ZfORCL8i
	2XrznKWKZ/avFNycDXj+W71too2CV0CW4sTNiTcRob0hkb6s90EZDkxJ7VOKVCWjsJ50Vr
	ESpukY4GRDk+8UrH85E1P0wQnLT2p7o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777276151;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=arplvSPi2JFlECX/+/+1OAM+U1qZByH2H1+6yaAluqQ=;
	b=flHFUWs1SEZyeXMjuj6GNmcSL9G50Lha6N+QAValj8e1sC8qo4sMedr9dn4MDTURQqoA4a
	AwdIIrsQY2Ek4gDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777276150; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=arplvSPi2JFlECX/+/+1OAM+U1qZByH2H1+6yaAluqQ=;
	b=bdH024rOeWnBryCQK53sX6ziBaA1h2RmcW+LhYa9OwCDd5bPDLOZfhceikcf3BGA7SzK+4
	vMYDEXtgBUqDENyr2s+koaIc1AgiSX9iP/52tdpnCfnwaKY1HpRmqzTpLI4VSXcjtSEfW2
	Xtcg82Nmm0oFgAD37JaAYypqBRMP1JE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777276150;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=arplvSPi2JFlECX/+/+1OAM+U1qZByH2H1+6yaAluqQ=;
	b=QmA/N/+bhu33buru0WCSMhITNsx0qoAHm76iR1WJ6RjitDrfJVENulhibZrVyUIzNhrxrF
	L/y1t1+xVnoVGQDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8035A593B0;
	Mon, 27 Apr 2026 07:49:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UaCCHPUU72nrbAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 27 Apr 2026 07:49:09 +0000
Date: Mon, 27 Apr 2026 09:49:03 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>, muchun.song@linux.dev,
	Ying Huang <huang.ying.caritas@gmail.com>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/memory_hotplug: fix memory block reference leak
 on remove
Message-ID: <ae8U73RyTE2a6bdp@localhost.localdomain>
References: <20260426144447.817722-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260426144447.817722-1-songmuchun@bytedance.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 56BA7180007
X-Stat-Signature: oxfskroe7bbyhjw41us4c4yx3mgbeo9z
X-Rspam-User: 
X-HE-Tag: 1777276153-320452
X-HE-Meta: U2FsdGVkX18rYPHQUs1z/Ut7ibpPM+av9+LUPnLDUgrfixbu7T2gqmphmzjelWRg685VYa5opLvdP7i8blMrWIPcQE2jVSeefLUbuQ6PXZta/V40CN/XtdBdsBVYsdNDhR9dBrMQFqZoteQqESddQ73FYELL2bLFmrXImqc8a8CbgB2qv8gTV5vi+AmWgoG3a+Zy3fxqx8IHiIc7enZOqMhsZ2dVwr/2tlzdjgCbd7JX/fOOw5ITz6xys01inBuK6Tndy0yck+QR3wrJvcG//p5shVpufihZXyO3HOaLhsNw5wThfpA6hESLpgV0oY+N6RF6QsBGlykO1XlAG7sHCIsxfM/ijFNf0v4uq2LHRgyzrulMOiPSnr2CyW+2b9+Ft58lrMUK1wLy8mrh/p6adj5ArOkg/+JumVecRYYmqwbX4EABUww9tOtF6kJE9QvrULXnu035euPxjimx/uQ2w5mLFyy7FUSzwRh5jNmxxbFookGyvzmId3Acj43JE4GnW6yjugUpUdUu6brADtiEbJH2ihXtLdmnt2dlYQNhO0pJQ6yIQ5DiKxEd0Dq4JuRSTNUXK3fFZHbC/SUjZvUD2QnkgGkSvyTYcHNs4BU1kX3Ci7iTQA3bHdi61y20tofGMZdnYjiOV1qD6asfgxlafZPALQaeQJ++uowEyhOBDrodQ6tlVEWxngaQSyrhWumomT/83vxu9QbYPvtM4wmlwNWh00sTHdG3DF9hK3fhP8fJ2qtkjU7s4wQM0ToRV2fF2G8RfUUFN3OzCZQoNawueLqvTsRtH5NnicgbxjPAu3fgZOAz+4b7jLDJ+xbbaJt0EsXyZpYbq/w5XE11/9warCwzn7HA2wdRQDgh/5ETuLTfHmXcOeJwf756tOyVgsPOHenBV2O7ZMAwOYiDTv6dEOnxhYRjLw5ckg8TyoW1EytMSl93EWIH7pXeHkLf4KwskdLP/fRHjFha+gLAh7S
 iHuzjm/S
 GFVAQzryBFUHe8MRn2SI/s8AMmU/nV3rsneaRaS6kwDr0AtS8STgMrKgdjRchxbyNOm/SoavNqhDwKxirG1S9yZ8A8nQ2oWCXsblTYp0Nmd4PKqUJWymSUaNWDn0/4m6YvYEtjXBwjYgcN/034OLkrfKQ/lC43/SyDQrmXqiAkXNh6OYG8UoyDy6F9o9j5KwidRp+xOCgDhCBNUpLKpJ0EU3y5MmeFHF71uwCihcYhGkAMUHteoO36aYe5fPNLec9YlJiQ9W4QujRfGDDzIV6zEQpVtCD1DOF6V2IlXRX6t9P80SL2DpS2uZLo2+X0Ezl/AkJ5BNMK+gj8TSDJovM2JX+HqfkJC8+YDCnmifGyZdTiKgYEqPQf0LWr9qHtMtQm0yredJQtr3624beSO6xXtIPQmrqtF63GE+6b1Zk1swkFjAYGKryBjySSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 26, 2026 at 10:44:46PM +0800, Muchun Song wrote:
> remove_memory_blocks_and_altmaps() looks up each memory block with
> find_memory_block(), which acquires a reference to the memory block
> device.
> 
> That reference is never dropped on this path, resulting in a leaked
> device reference when removing memory blocks and their altmaps. Drop
> the reference after retrieving mem->altmap and clearing mem->altmap,
> before removing the memory block device.
> 
> Fixes: 6b8f0798b85a ("mm/memory_hotplug: split memmap_on_memory requests across memblocks")
> Cc: stable@vger.kernel.org
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

The change looks good but some comments below:

Acked-by: Oscar Salvador <osalvador@suse.de>

The outcome of leaking the reference is that the final call to put_device()
in device_unregister() leaves the memory block device linked in the
system under /sys/ ? (besides not deleting the struct I guess)

> ---
>  mm/memory_hotplug.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 2a943ec57c85..4426abb05655 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1422,6 +1422,7 @@ static void remove_memory_blocks_and_altmaps(u64 start, u64 size)
>  
>  		altmap = mem->altmap;
>  		mem->altmap = NULL;
> +		put_device(&mem->dev);

1) Six months from now we might not remember why we need to call
   put_device() here.

   I would put a comment like remove_memory_block has:

   "/* drop the ref. we got via find_memory_block() */" or something like
   that.

2) I kind of dislike having an internal put_device() lingering here in
   memory-hotplug code, it feels like it does not really belong here.
   Ideally we should have a high-level function in drivers/base/memory.c
   that calls put_device itself.
   Something like "put_memblock_dev", dunno, names are hard.
 

-- 
Oscar Salvador
SUSE Labs

