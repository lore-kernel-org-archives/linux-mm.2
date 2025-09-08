Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 757FBCAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 09:26:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C66366B0006; Mon,  8 Sep 2025 05:26:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C16426B000C; Mon,  8 Sep 2025 05:26:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B05476B000D; Mon,  8 Sep 2025 05:26:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 999186B0006
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:26:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2C95A5BDBA
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:26:46 +0000 (UTC)
X-FDA: 83865553212.08.779264C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id 014E3A0005
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:26:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gkQEN+8A;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jpunQnk+;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gkQEN+8A;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jpunQnk+;
	spf=pass (imf25.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757323604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bGZuYnNIDfVSguR/8lyC/ChH+QGcbhNtIgbk8I2uHpQ=;
	b=yuLdljuTBcgvOShWCmpbNSpj9uvN0vNxdAHZA4veXECTRx6Y5boCRkftwwtO2rG28zoqdA
	J1jMXqfXJzqtpkqN3vliG3+mUZJJg5BBLDjyHN03ClJycJf8oJ7dTiW2/bxoAwZnUDKaRQ
	rGS0PiLUjfGuekCwtw13y/nqXYzCS5k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gkQEN+8A;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jpunQnk+;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gkQEN+8A;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jpunQnk+;
	spf=pass (imf25.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757323604; a=rsa-sha256;
	cv=none;
	b=4uzKMNKuthfcxekRQf0Omeli4TWh13QDG8YtqgZ1MnkIJQ4gIKyhLSdT9j/2TNdpLKbnnr
	aHtBR8twL4qSLSLTLNPsILTdVB8Wq0RkJPUpsSg3ZwLTGPWr/IiRMoRy7Rl/tLBzoIsQW5
	d0k5zIxzTjKi0Rhf9qGQ2AaUjM6JGjQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 983552675A;
	Mon,  8 Sep 2025 09:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757323602; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bGZuYnNIDfVSguR/8lyC/ChH+QGcbhNtIgbk8I2uHpQ=;
	b=gkQEN+8AuyMcQ2TMXqcd22eyCFpaJS36VSQv+0u/j5IomCsG5IVC21UbJgaUAxk3Jo84A5
	3+HI20amoIbaUFOjmWCnwi0pjz4miXOmKJftH8xTV6hD7maEmz+UIFoSEvTcC4v3tu/wDw
	6Qpg1WIVaSGgns7SbV066iDXdJApfTE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757323602;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bGZuYnNIDfVSguR/8lyC/ChH+QGcbhNtIgbk8I2uHpQ=;
	b=jpunQnk+HO2hO0EQTLYffw5rQBc/knTYlXH72YBS792XswfB12HbPsHFaz00wxzzRS5wti
	fJPFfPbJOXn3UwDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757323602; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bGZuYnNIDfVSguR/8lyC/ChH+QGcbhNtIgbk8I2uHpQ=;
	b=gkQEN+8AuyMcQ2TMXqcd22eyCFpaJS36VSQv+0u/j5IomCsG5IVC21UbJgaUAxk3Jo84A5
	3+HI20amoIbaUFOjmWCnwi0pjz4miXOmKJftH8xTV6hD7maEmz+UIFoSEvTcC4v3tu/wDw
	6Qpg1WIVaSGgns7SbV066iDXdJApfTE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757323602;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bGZuYnNIDfVSguR/8lyC/ChH+QGcbhNtIgbk8I2uHpQ=;
	b=jpunQnk+HO2hO0EQTLYffw5rQBc/knTYlXH72YBS792XswfB12HbPsHFaz00wxzzRS5wti
	fJPFfPbJOXn3UwDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 001CE13869;
	Mon,  8 Sep 2025 09:26:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9HXhOFGhvmiWaAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 08 Sep 2025 09:26:41 +0000
Date: Mon, 8 Sep 2025 11:26:40 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Muchun Song <muchun.song@linux.dev>, sidhartha.kumar@oracle.com,
	jane.chu@oracle.com, Zi Yan <ziy@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2 2/9] mm: hugetlb: convert to
 account_new_hugetlb_folio()
Message-ID: <aL6hUFNImBtW8OdL@localhost.localdomain>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
 <20250902124820.3081488-3-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902124820.3081488-3-wangkefeng.wang@huawei.com>
X-Stat-Signature: x95oosmkyti8mk6yrhexa1qxgnxtwd6a
X-Rspam-User: 
X-Rspamd-Queue-Id: 014E3A0005
X-Rspamd-Server: rspam01
X-HE-Tag: 1757323603-824042
X-HE-Meta: U2FsdGVkX1+5Y4IFqkXTlEVENGdzwp6wF4gMBzpS8tPk5kL2DGodB87KZEi6I0E0Ek/DQvudFdg9S1IwDghXYsU4MywAzFPf52K21S1mqCCztffu15YzpqhKefP9+pyPuSa4OL3WzmTVk9YwXiZN9nyDjf+b0E11HWrt6OPmZ5bLIJJmy+H2nvNnwudfm32cjBDpxTNte4qaHsPSw1ebT9ZZ/41PzZS9aagkoj/5DzRRA2fBE4zIMAbx1GDq3sFcOitcHEzrvBvi37iUNUXT4DracFHHpfDYllXXiVxlqr/DLObzDpl7ciR0rYf58Jkw7IF5kKzVH1nC4WZ2aJ3vCpLeHARKno9FBqhCgZEVhGtGh5sGLdDLFkogMMMTXRiD4Tu2k55KvVUBXvJVGLvvw39XQqDoU12gJyQm5tzkywUFyL4ih3M8b2hf2E3P06U2meDO29Qu8ktQVtGJk1I8U1Rae1EJRu/lAaaw6Km9g2qmGhn0P/t5uuB1t5tEPkxGvoA8ZK18KkwLEy5udgBukLVYcSWyjy/N5wKwQ3zj5RI7ucys+/Ue8KjMgD6HI5ZBxxbodYfDutbdqR8QQSl4LjZ8oD19VOVePvjrvEFxf8DXTzYjyK89OgPLEwqxnfB2Ekoq7IvpzXFmZa3pBC1VOdbsjCtbkiYm1dCFulTVXmGJ6nPm786dtU6bQEiWkEG3lM7QwfLTPOtK86rVZkC8CKCb/yaB4KkTyteaUpuuLeNKlmGEZzF8VMLfnlgeLglN6zi8+uqx1ZioNV51ajBVQlAJpSgKzZKWZdd7t14hy02JBTLsVpYKQmUMzIKHVRUaCDKr5YFRUQ2DwG3Hg0UIkh74R4/IGILIx2TUpx3k2aQA6FkW6R4dhAeEpwqFNp+N4ZrLU0MBeecl3WnmPjCZ7BBmTWSQNOf3/9OkyKm6EmKTosGJE7lnj2vJQPEuirFUcZU2Nup2h17CGxG2ck/
 7mBq1n9F
 Q+7XOTbnaNUhgEHFB98cqI1R5na+/b+ydndusJKs5Af24pG5YOZkV/g74TmN/LyLhAp1R2aydBdgnCGx4uzcJWlyVIstGO+b+xScoKFsRJ9tEc87CUc+oM4+lQvZ/kAYirxnk74TqmynGlHI6TD8lqWXIVwpewS7fPc26zvvuVy7HtmaGnuFMf07PrbAGxNvQH8yscWXlm2RgxaIOZAieovpnN/0z8PJugmiRIAhjeFklbadQPLaVfs6oxpbCcpIz/O4pxrnFNqizYAmKmkurKqgkBFLMd4Vt9uEEoCOqCsv4Z2c/+5odP1E1sSm8tPiSW5Bv0LyZmGVGfW2c3M7jiM5gPHNWDGk0h3aoVtsD/NtqD9w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 08:48:13PM +0800, Kefeng Wang wrote:
> In order to avoid the wrong nid passed into the account, it's better
> to move folio_nid() into account_new_hugetlb_folio().

I might need more context here because this reads like there is a potential problem
and we are fixing something.

Are we worried about a mismatch? Have we seen it? Just theoretical?

 

-- 
Oscar Salvador
SUSE Labs

