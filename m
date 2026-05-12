Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB411CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 08:28:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 227916B0088; Tue, 12 May 2026 04:28:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D8936B008C; Tue, 12 May 2026 04:28:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C8FD6B0092; Tue, 12 May 2026 04:28:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EDFBE6B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:28:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8A6C28CC85
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:28:11 +0000 (UTC)
X-FDA: 84758090382.07.46E53C7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4D170C000A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:28:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf10.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778574489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4xGGRlnxg7aexlglixAi3kMj3axlw5heWUP27yTL0LQ=;
	b=NlISt5ZKrfGXLdKK9X7rpuvSRTOZdvBaxl/LKdncogCcTYp0e453IQAx5hiV7xQs/t2n7Y
	Bdxql0n5kOtcIoRtJN8w4Dn3rIbaW2ARBG68kThM4Q0pi5Rh+3ZhayigFD4f7xGB0eg6Z3
	GijJMJuUgHut5aSjO+DLISSsLP1ieaU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf10.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778574489; a=rsa-sha256;
	cv=none;
	b=GjG4HrZEjFIRh3kRlq3SSB89b4NoqbzLf05fVYk/ZR5pqFE+LFRS+i4b7bsbUo9KedxA/J
	k0PLwJqIpW88SWZEjIvu+rEY4852yyrXGBjQZcr+989J9sqkA3/H7RgbZpDP00vqFFS/SA
	kVZJim8MOGOTpU5m5HpIya3gdFmAJto=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A9F1567AD1;
	Tue, 12 May 2026 08:28:07 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 75CE8593A9;
	Tue, 12 May 2026 08:28:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Uc6mGZbkAmqOegAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 12 May 2026 08:28:06 +0000
Date: Tue, 12 May 2026 10:28:04 +0200
From: Oscar Salvador <osalvador@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 1/8] sparc/mm: remove register_page_bootmem_info()
Message-ID: <agLklK9iCcV6lsSn@localhost.localdomain>
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
 <20260511-bootmem_info_prep-v1-1-3fb0be6fc688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511-bootmem_info_prep-v1-1-3fb0be6fc688@kernel.org>
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4D170C000A
X-Rspam-User: 
X-Stat-Signature: 3dq6azex544ditz3u5u4myuywukobbr3
X-HE-Tag: 1778574489-917400
X-HE-Meta: U2FsdGVkX1+x1BXRkc6TRSKt3iVgCxjWpJD/XgYGo+C2mc9May2gXR3+cqpnxeIeA9BSHQQ/7QKrRM/clxXOg//d0CuJnkkMS5f8owN9H3XD0lc/xZ3+pAHS51AEB/cXP/EYhFnsY8FAStoj+JS6Ir+ZooHpPArsQgpHjV8kU/l+3hiAzHmtv4Axyv+7FeYS9qGHYB92hq/hv73/Z5dPcwIkav8H9d4JKAUez69+4QoH3nhuhGtN+uK55eSeoxhkR/MuFN/RCVJQrRsAs65TrvE3MuPvp3Z+aCJy6u9UlLwmFv4F6ePxRtmFPNfgrJGkBkkVkfe+gJzrHhJvDZwxd+DIluRWmu1VIelQHAJeT5dRx3f969brVjTnVesUVXuygz3bgoOoemWlqVttAx0TyHDMMvdd7KBxonWe+cj7Ieg8P2r5ccTpBw+xylLH3k5qMPXeZolO/6lPyU18BImqZrgU79yaorwGX1LcbwIaLwTzZWJaF0WJQSeUhnKnoGI1UQiTMsp++9MZyrQrdBSJrsvSHKySEp4CMJcTS3TrmnrS+6ougXcNuDhX4NLIOzwxE+YKxZb8FbFXdtoRkqkuaqhcH87Kd/WmNQXPQDQeq1QH4TJ0uTCDcKUt7idHB66EeuCcsJQqhH4a6Q54TRxpBexJju219Nr56YVHD3gbmfnVluj3Tf5M/OiP/uuIRUmd2snnR3MNNpF11XJF8Sa/AT/t4M4qMKA0EdYlkeu+RKoK3joXIQ1hHGmhISgS7PLL4O04Qtd21KnR9CLxvNbMVKKTlhITd4WJkC+41kpfKgRTZmQqWI0Bgch7D4+XgtHs5ilR1dpRoq3JcPaM36rjUCOGQqR5VzPPpZKJVCRsai9kPDH2pntx3vAyWF4HDvwM66CHL7hpN/9ZWwIfa/0zJcuR/CUf8CEsBbl831oJlf6116uYTw+crSZuwb9aeMDvqUp1B0iEyl9+9bjkrCs
 Ih1ui9eK
 9e6bXudML5ukZA14JZ3mCSNEGvTN+PQ5eE7tqIsMzZhHhdQmXchTcJltYdZQGmk3F9kupkbYaiLEpUr5mq0EIsnvTPAypEKm99L9pIkrFqVpnYGOqgbo0mVswAvrP01AuB8OqkFYii3dY/ZKU58Fjqkia3nD3a15HvYmJyQX+e1WAwrswhQKj+7sdG2vCBxRh61bZ8sQkURnYd2I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 04:05:29PM +0200, David Hildenbrand (Arm) wrote:
> sparc does not select CONFIG_HAVE_BOOTMEM_INFO_NODE, therefore,
> register_page_bootmem_info_node() is a nop.
> 
> Let's just get rid of register_page_bootmem_info().
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs

