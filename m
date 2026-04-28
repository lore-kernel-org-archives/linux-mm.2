Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BC7DFF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 09:14:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C70996B0088; Tue, 28 Apr 2026 05:14:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFA426B008A; Tue, 28 Apr 2026 05:14:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC3326B008C; Tue, 28 Apr 2026 05:14:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9522B6B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:14:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3649B1B960F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:14:06 +0000 (UTC)
X-FDA: 84707402892.24.88B717B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0CD9612000E
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:14:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="SfSXql6/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=63pBZFqr;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hhYoRYt0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=o8agQQ+W;
	spf=pass (imf29.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777367644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oa54dygvQ7e1WMzBvT0E6vQ7uFcWNMOK0rSl80PUuQ4=;
	b=TYWw2wghONvL4GpMsODPfNEnQM4TSVLfrQoGp3pr3rCzEcVQKO7xv2pYXZm6J0X2CtVu+O
	c42RnT6HRRhYgACDRoMyB4GDEYEYUChJOLfHEqtO1jLbDoZNaYx7I8w3XXUnU/nHmn+FPp
	HW8LrtVyALQHuzrH9x3U7wUFrMsbWZ0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="SfSXql6/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=63pBZFqr;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hhYoRYt0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=o8agQQ+W;
	spf=pass (imf29.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777367644; a=rsa-sha256;
	cv=none;
	b=U2tmQ+5vZ/ofctqsHYQ/t7nnHExsTANy07Rc63Zr193+JPvNCH8+SDYDWWIqJ3iJgAduR5
	zoBlqo2XxkC+aKSmIaeOi2YNCBLYMzNTEeM1R/FH4oib7oBzJGWcj80IRQKWczuX3gVFW3
	Mjbh1z6VQiaWU3BHtB8tbEHj0VLjwvI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0DF286A7E7;
	Tue, 28 Apr 2026 09:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777367642; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Oa54dygvQ7e1WMzBvT0E6vQ7uFcWNMOK0rSl80PUuQ4=;
	b=SfSXql6/ADqv1mmrAcvNAD2fVa/7oNjp5KqdI0gurwAhE655uJA/ACz6h8PkXmB+Qz2pss
	DkJQe1O3wstOno4e/pTYxj0egdoQvBqWXgj4sTTORzMgME515sMG7mA3B9maWgF47BmdVq
	fjBez3/Ky2HJWa07E9EZFtTOZSpytdA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777367642;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Oa54dygvQ7e1WMzBvT0E6vQ7uFcWNMOK0rSl80PUuQ4=;
	b=63pBZFqru3aPfGK4CMZNXrthBm5ESnZqWt2FXDgufav1luqClxSnCPXdr7nxd+1EtyXO8s
	d7itJdzH0EJ2LfBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777367641; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Oa54dygvQ7e1WMzBvT0E6vQ7uFcWNMOK0rSl80PUuQ4=;
	b=hhYoRYt0FdBOl15l/k6ZYXGkFGP1iiCETZvpRPatgdFGu+MzVu+BAu03SM5Yzeo6TtT0xN
	3vDC0MoXOMmdbtLp8cJBHIkbXdimTbs2+BEFvC7bPbF96SlVkqRlhRrmud5x8ZY/BYY0U8
	ry4Y5vddJ1Oo/Sh5RlR0FsY1msxsq00=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777367641;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Oa54dygvQ7e1WMzBvT0E6vQ7uFcWNMOK0rSl80PUuQ4=;
	b=o8agQQ+WsbKPzMbJZEsSG9vfXU8liYCM1F3jCjGCfKXBPmj0Yk510OWOnEIKJh0HPs0His
	VgoDB+99ImRVu9Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 34833593B0;
	Tue, 28 Apr 2026 09:14:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xl1PCVh68GkSZAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 28 Apr 2026 09:14:00 +0000
Date: Tue, 28 Apr 2026 11:13:58 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ying Huang <huang.ying.caritas@gmail.com>,
	Dan Williams <djbw@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	muchun.song@linux.dev
Subject: Re: [PATCH v2 2/3] drivers/base/memory: fix memory block reference
 leak in poison accounting
Message-ID: <afB6VueAvlhMSb7Z@localhost.localdomain>
References: <20260428085219.1316047-1-songmuchun@bytedance.com>
 <20260428085219.1316047-3-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428085219.1316047-3-songmuchun@bytedance.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0CD9612000E
X-Rspam-User: 
X-Stat-Signature: ccaa81um4d78jztp4eazup6kw6g7ajwn
X-HE-Tag: 1777367643-414308
X-HE-Meta: U2FsdGVkX1/QekR7qfhAYdYomJhjgeW7Yl//KGA9JJ7SOmNu3WedqeOEgrkPrlkN0JS2BNX25BV6sZ4/g7AZ863S0Jsh3/kKU6UVP5We6HuC9tkVNmtPZ0DI83Zgvygm+EDnATbB2hlMWC8bz9Omf/45RMCiAOdCh6+T6Uz2o6xkvmCkJJmDa8m3PDje+TDc5ax4lGrEFLuu67jZaiyMqIc8yNSYdbQIR7RC5463l35CsYvPGJ656nLS/bOtylfmWlnVVvGMAbf9LSI/G8Pr0Rj9GoIEKanX+xuPQje7nl3MuxDyTOcvflFdJMDVEzZzp3OuldWZiMhx+tDJNIq2rMfm+KMTnA9VMD1SN5v0cIRhDME0H3neoE+RJlqSFtxGk+ZMhPr2EE2vsWEiRkNB2O3KOH+GtwFESIObyScXhumiiSQ3Dj8TpQKjpbL+pchLWTa2yAsX3TDtu/hUUgPyDXsqGfTkb7bpI/XEv4JOzUUkC5BWJOOuY45WL7QMg7I567QS2lkxAh/hB/E3NrPNNcI3uXt8vf/7Oyl4hpD/dPxcz8kzoQ7RYjTbwZDdJ4CTZuD3RX3UYKoBWZ5wT6/GNUy5BuG0gIfoaiGyYoy25qLpNW3KKH7NQTREJKay0MuoyBV6No9N1cdbpqaJ4pUZ19TLXe4afDRnrlYnGse9gQLGz5xDfrb2xmWKMhS2bIhwoHTIL3G7ly0UHsnLRC7J1DryOu3aHGCHddTV1hW2OfSo/ts2gW/AZyvNHLkxYygqRmW/fiQGi9iuFRmCwcmyi2NNcRHutFycz6+pMWHz3DmiZSvI+ztKBfLQe1uywg6n9pmcmqXikLNeB69YR0Eic7h9DbFlanf+7jahxiWo+V/PixjBlJYDpwgzWuAFU9p5MZvFjwPbmEEiJWS8Vh9iZB0wZeb+MdcmKbNRJbVbA4O+GIvYqlof5lVleHEhfa94VT3dw61PXZGkYh5QAzB
 gC4gHOU0
 /aggTQXSU4dEpzhpPUNXNhVidGVUES+zSyPtWTn3QR+74G73U38/TsYCM3ZRIseCz7O0bemgJqtwDgOuoBfQSZYCsOx+yzoOCP57ZcxgI26VgvM81a5tIb2tUe1CfLYO7m7BlNoGcIU4hzaTczcp6O+EJdIdSyz1bqf01xrZW42VQTGiHZoBO2wcbWC7RWPUNXNarWlLskcGjQcD5yLLnr2EKMGlJPGQRmganTW0FnzLRTkUOVHGkzImflxms2tKHmaFjTaHu3vL2FtiLPiwzLWVxAw97oCpX9rajeJvt3PTwEIHV3kWQJf5TBrgOhvilncXMiqNO+ZYg/KIF2y1oHYWOL0HbSuyUCl0P+CGZbAgWAeK7zGtosYXwnOgzT9kMIQEsrpFsJTCqvwmJnweFplSD6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 04:52:18PM +0800, Muchun Song wrote:
> memblk_nr_poison_inc() and memblk_nr_poison_sub() look up a memory
> block via find_memory_block_by_id(), which acquires a reference to the
> memory block device.
> 
> Both helpers use the returned memory block without dropping that
> reference, leaking the device reference on each successful lookup. Drop
> the reference after updating nr_hwpoison.
> 
> Fixes: 5033091de814 ("mm/hwpoison: introduce per-memory_block hwpoison counter")
> Cc: stable@vger.kernel.org
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Acked-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

