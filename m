Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51F15CD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 08:36:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A24096B0088; Tue, 12 May 2026 04:36:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FB7A6B008A; Tue, 12 May 2026 04:36:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 911BF6B008C; Tue, 12 May 2026 04:36:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 851E86B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:36:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2AAF6160409
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:36:41 +0000 (UTC)
X-FDA: 84758111802.17.7A8CEAB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0648320005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:36:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OxABjhln;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=L7RAFmAT;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DfeZqqoI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=RPxKI++w;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf03.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778574999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qeFPBZ4MeGkkPKzW14cEWiFa5q6IagaEwfD13UPfREs=;
	b=Mbo3oE2xG4y5a3F7anO8FpdaV+Ym8Ve5DX8ONKXYoIZPCV10T989FkNbASDotnzZX4ATlu
	DeqyOrquULM7KkUO1ZxXEDF89Y20PV8hny9MXwjKslQlfSjQuv/IzaTDp/ZLgByMTTHg4J
	aUHbdQBqF+rMp8lQC85v96coR6imwUs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778574999; a=rsa-sha256;
	cv=none;
	b=B7mWBj1R2I5UfnMXT7qW9/+OMUeNqKvoAXuU98FhEdh6yFDwTW5FmczDZTef2Aq4yRHEpl
	YW4AtNa7vmc4Sj4ufNtzZrmKDczJaVkLSw4l6Yf7E7pITNh16RUOlASOWGp8ESZzlUBfda
	0+gSZVPgSyQHomXpYkbsrC23vA+d4aI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OxABjhln;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=L7RAFmAT;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DfeZqqoI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=RPxKI++w;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf03.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6A4EA759BF;
	Tue, 12 May 2026 08:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778574997; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qeFPBZ4MeGkkPKzW14cEWiFa5q6IagaEwfD13UPfREs=;
	b=OxABjhlnjKoPqma/DwnCh9ytg1ymqNAtN/sQ9nMfbNfSVVpO1pG0mn4USLcQjgr7xWMLG5
	Ty0gqf/eauSaqpxetjhSr93gpbJ6JoFGw/oPkqrbLXvnRauqb6yT/sovIsNiX4Eijxb8L6
	RWGveaKnKqRXk6euaWwZp8DaWlifR9w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778574997;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qeFPBZ4MeGkkPKzW14cEWiFa5q6IagaEwfD13UPfREs=;
	b=L7RAFmATKRu5J9cmTOV37Ybl7z/LrRpErCEHSPmy0c6dVYtgZaBPVe5X5XWAf6wbSYGAqU
	020Pexc8OaYtLcCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778574996; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qeFPBZ4MeGkkPKzW14cEWiFa5q6IagaEwfD13UPfREs=;
	b=DfeZqqoIT4ioiv6VHsaqCJQ4w2wWbcF+goDiMNScbajtWamahUFsQ4SLfSfRL9CKUtBvcT
	O5x17wC9q+mHZWkVkUVwWf1B5Z4G/yx6+cIMDNk9PjAy6GV/Pn7EU01aEEpC7ONl8MlaBU
	P3dMQd3mxA9QfMgOZEdbUZlA+NLdcHs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778574996;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qeFPBZ4MeGkkPKzW14cEWiFa5q6IagaEwfD13UPfREs=;
	b=RPxKI++wuNeC0Ia2Hjv4TcWo1i+E7zCF1qOWkpMPqs3WUzf64ogYfQrRoR7xY0z14vKqI5
	UxMNPadIOZomMPBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6E7FE593A9;
	Tue, 12 May 2026 08:36:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id P8jkGJPmAmrTAwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 12 May 2026 08:36:35 +0000
Date: Tue, 12 May 2026 10:36:29 +0200
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
Subject: Re: [PATCH 5/8] mm/bootmem_info: stop marking the pgdat as NODE_INFO
Message-ID: <agLmjW41Sn254z_G@localhost.localdomain>
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
 <20260511-bootmem_info_prep-v1-5-3fb0be6fc688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511-bootmem_info_prep-v1-5-3fb0be6fc688@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0648320005
X-Stat-Signature: 913ynyxgz6a6yfxrbsu4ywijhgxkgt5y
X-Rspam-User: 
X-HE-Tag: 1778574998-650913
X-HE-Meta: U2FsdGVkX1/3scaKq7LSJMeYcA0kqVniZ1xKJVzlZGD4vPH+1DcWCgDUarhd+NMqwWnu2yScO/MV32kFfRc4JBc6gk6Pzm4uXbnTfpwryiOS7x75E8rbURJ4+ER4yq8baLVfwDVq2hOahMKjvWE0IGeGy2akMT1fTKGle9OCobS6DwjS/+8d5nx//FvB2TV36wjefJ9Uzp9glXD5r8/9eaAsd0xEYvRGxDHfni50gr4b9fNmcmhR4sH+Dzzbm3/7/kz5bq4GUOO80ZClbbk+wMq6qC1R+hqic2tjvBiQ7rkWorQiheID1Cf5b8w08eLw+GZ4h8uI6/woeTPmfbRo6+oPO2YbekgrFPI4qGFnv2PdegHQ3/zdZNh5KhcJH4Xm6kxlKi75zh1Zk/16UHU4B+l/ibyrQSNhaIrjYKugo67H65BjeUaXHhddTF1ANWL44/IyXApHJHjssfUFlwjngyIEtfLtJqb9MFGWA15UsRIbVowBd96WL6EMrPaAptmFoO8vsyXVZAWV2LIHrYsBP8ufUA7HUdN9ALWkTNLM632cnpAI5Ihg44ka9eYxUvdnuYWUuRrkr+qp56SQRhVK27dfjOG4yK5gSB+0qpZssxwRi1v5OUl0ql51j5EUJkPJ8JYuNRzyjSFeM/W1CpYBVtehww4FB3NztWOEQWvfWjRf0q/+h+wrTxHtmRQhSA/Ws6PmKTq6OAneLbrmI6mZC3TZTJPgQdvfWb6Wc8Su/B/WQU8odp18CemLbzi9V355e3xqk9yBPKdF0BdKO9ms4rTodaYwaJLvXQi73Fvkr5p/be0utpJnv4QgwOsGn5uDuv6lfE2sA2bQRT7xtskAzRV1TVtwU3dIWbWUFAmzS/VDrwp/VwmnOzZ0xWbMxfVX4uM4U6LnPCnwywzetMeMnoWrRFReNM0pNnun8fD4uFF+kApYnrIXeNap/XfOUuLL2/lMkJ/CyrkODKHStQV
 A61+u/B6
 wEl4cn9dovm3Wfdg1WjtRX3V4BbFNqyk5UMc4PWcBQ0eCPUxFZE6ClX2PI8gXuGH0a5uTqKKRwI7X9vcdfiWwJAmuFfef3unW8EoV+HCC+z6YykhlJeJyNkWRfzCFmY9AFb+C8AxeD1i9QOJJBbtJx30bD/ZwEStNquyzR2pzB6zx02//gOzbj9gLMzeAwZPzojG52xCvD4tPhRSh4++u8DoviQOvc1ZIfzTw1g63o0z7lpL1Aql1UDjEU3Y3TXY7m4z8uLK7Y9GvvKTC1Rkj3gKhz/T47KgA84hv0/7DuGdvNQJU/xyOYlxgBp+LQKj9EEoSUJ4D7wQt0Z8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 04:05:33PM +0200, David Hildenbrand (Arm) wrote:
> We removed the last user of NODE_INFO in commit 119c31caa59e ("mm/sparse:
> remove !CONFIG_SPARSEMEM_VMEMMAP leftovers for CONFIG_MEMORY_HOTPLUG").
> 
> But it really was never used it besides for safety-checks ever since it was
> introduced in commit 04753278769f ("memory hotplug: register section/node
> id to free"), where we had the comment:
> 
> 	5) The node information like pgdat has similar issues. But, this
> 	   will be able to be solved too by this.
> 	   (Not implemented yet, but, remembering node id in the pages.)
> 
> Of course, that never happened, and we are not planning on freeing the
> node data (pgdat/pglist_data), during memory hotunplug.
> 
> So let's just stop marking the pgdat as NODE_INFO.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

