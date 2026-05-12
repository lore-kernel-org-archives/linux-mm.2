Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4CFFCD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 08:30:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 475126B0088; Tue, 12 May 2026 04:30:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 425706B008C; Tue, 12 May 2026 04:30:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3621F6B0092; Tue, 12 May 2026 04:30:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 272CF6B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:30:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BEF8D1C0FC9
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:30:25 +0000 (UTC)
X-FDA: 84758096010.05.FDA8EBF
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id B90454000A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:30:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf12.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778574623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lDhbRDb0MfFiEC6PQVFnjMeZZT5pVWem9K6uyS998CY=;
	b=DmNzqkLW+NIb1Kvj/CzdrvGxTIZcX4PI3sEF7YuMIa9P+ljAOrsQ2f+c9L/NZRjAQhtKsI
	+O45wPfXqWHDfzDkTc6TdaRCDvkpPc1EDbJzHcO6/YEMZvzDlIwHAj2vMbZLKk9CbTmmdZ
	7mk05BDHayT5WgPDJ4N1ZdtVB3ghP1k=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf12.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778574623; a=rsa-sha256;
	cv=none;
	b=K+rUhEVtI97ERYLBYQHl9J5OfivgI4k8QeUwQUOeVF6rAg5MyBLfo/F+ddlulmYlEyJdeN
	MPsJt41Y8yYBmOQ2XwbJnE97gUeyIE3DGE08RvmYhnqZAIjg8h9xmI7gBkIIuYYFcxUCnx
	kTai9sY85bweGhGpysvSqacW9j04joc=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 713D86BFF6;
	Tue, 12 May 2026 08:30:22 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 76265593A9;
	Tue, 12 May 2026 08:30:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DXrKGh3lAmpwfAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 12 May 2026 08:30:21 +0000
Date: Tue, 12 May 2026 10:30:15 +0200
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
Subject: Re: [PATCH 3/8] mm/bootmem_info: stop using PG_private
Message-ID: <agLlF7yCgagRt11i@localhost.localdomain>
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
 <20260511-bootmem_info_prep-v1-3-3fb0be6fc688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511-bootmem_info_prep-v1-3-3fb0be6fc688@kernel.org>
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B90454000A
X-Rspam-User: 
X-Stat-Signature: czdpdzakmxybnyixfu9p6iouiw66r7a8
X-HE-Tag: 1778574623-762584
X-HE-Meta: U2FsdGVkX18s55ezVXsvr/Vh3bJm58UZkrLZhsbrbDFgIfjuZEknhITbyDF44WtBsVoYn0uiEvE4Cc+VkNjs86x/B8dTFQC25nKr/I3MjbY/n9PzWIljA3Cw+b8sFe8gpLzLsDlluFMvwRYcRQyKhrzjNRm9tnaMkWxWP5pRnXqQvgDozzeK2xC34Q2y/PZriiJxGfM0i43wh1QInkF4T2co/iCUnYuE6BmCrDkHnUfx/3evFEiwaHffCMoLoMHDUs0o+6DAHJCRaqpgw9W7ygm10FbP+RR5wUCapMolNcZop7a7qccnatvki8Xb7jWBe/QhHoE1T7GsWMisJF2NVSGr65eHn1o+zDDSZY4bKVNyljrP7RX0wKTJG7XulesCiYIBhh+634TX+onIcKB3o4LYcLtR0lpT8+Vv5SxqCNP63T0M+8JRJCICEuNweKCdAgJPTrgoAiU9XCvbYDq3oTqYAcQhwht1krsz/F8Jzedn+W9xook2sezFg0xSZ9W5BF28MB9ORe1tM33K/LixCdCb8y/Hv1lLRAnJII4M5+kT3FZjFL/Sa0q0/MepcrCQiRG/0rdKwOaiFN5V9cUFgGinoFOhGm+9pTY69pEQYLTEUuPiKZj88OA/xr3Fh3eWRbP/IL4fhVQ6RwqDqQXq7Elzdnq9TdwYPMmBw9yMKzjjKcU9BDsI2X10Q00PQ9uWD7OoiqLU0bmBw4GnIUkC+CXO2zkZ2rUp39Bb1xQ3z+t1aVYtkMArFJlinPTALO+dbW1TlZa2LT8elCvctZTM/4gE9ehUW1qQKy/GdWYAdVHvlswQJH8CKcGQdvkCt2UJ0CF5peqNDSUNvDTqE29/tXnJp6SEyVI60IDSa2T+sNqnfWHOd3XajjFtDsfwIKrCacs58C8anjnOGk3PPpNZLPCJveGz2Shk+EM7rfWNo+D0wydtkIhf/bswg2QKkj3zYhSov3mlEkt//QeuUnz
 Shay4Snv
 u8UG1k1P9+PlbyZOHbZDPyQxNpQcQRuNux+ubt+4BxFVE+zMkdeoAv+LQIkms6u5AcMemuCvgFHzoJncPlwknfEkKNuzmEgHJ4toZAtvfgPfvXeHZd64riq5KdQn+IQVgG1xv6oLyDUVR5xKEeQfjRL6IvNh2GWWCgC99b9fdd/yi/xwFSjC/y2bvw/2yU/ZlxVaPNIPLkjsLeME=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 04:05:31PM +0200, David Hildenbrand (Arm) wrote:
> Nobody checks PG_private for these pages, and we can happily use
> set_page_private() without setting PG_private. So let's just stop
> setting/clearing PG_private.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs

