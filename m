Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AE5DCD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 08:45:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FC8A6B008A; Tue, 12 May 2026 04:45:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D3946B008C; Tue, 12 May 2026 04:45:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C2AA6B0092; Tue, 12 May 2026 04:45:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4BD1A6B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:45:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EAC5E8CC84
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:45:15 +0000 (UTC)
X-FDA: 84758133390.12.EBA6115
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id C6EE74000E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:45:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="0DIAw/Lb";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wlS+ubs2;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="0DIAw/Lb";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wlS+ubs2;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf04.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778575514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VVhUu+lg1kvYAZheHCbKtRrVHTg43eeZOy4q05OgGw0=;
	b=Tp9NRSofKieQtjDAZ6x9JE7ymPLyNjEITO6x5SN2XB8Heb7h8GIN52MSpoZFAyRNbMYmvR
	3YE3z+mG+vYKKezWiPjq9Pufh2mU6YW/6k4Bq9324e2fjKPAYjkqSY3t/jIfU0XgVJKFwW
	Yl3vXjxd3EqOE2j0aOkr7UNpu6I8rFI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778575514; a=rsa-sha256;
	cv=none;
	b=x3ZQYuCKiaG/E6q5teuCU4K0+aYMh6oEzK6JcboWjcjuiuxVcFsCJMGdhW4C1DqhEBePsd
	R9eO9tWSO3n6Ts5765zUSCHhcS+iiv96ITVPmQ/vNMFcJF1bImpI4FSoXmlv6Z+W5cbduU
	rBJ/nSf1Oz/FnIbNIo2ykIbbCLWWX+s=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="0DIAw/Lb";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wlS+ubs2;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="0DIAw/Lb";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wlS+ubs2;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf04.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1EADE5D634;
	Tue, 12 May 2026 08:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778575512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VVhUu+lg1kvYAZheHCbKtRrVHTg43eeZOy4q05OgGw0=;
	b=0DIAw/LbkWRCYPpD3+i1wnlozxRda8gJxf0kVkjNTDXsTbOdeGH/d4BBCo6imoUNbuN6hC
	A+aBChhNKHHqLAz+qr+5HJ/EO0w9hc6E3Euu0JajBE6G32rTNIRLPKJjnBwwRBLnG/raic
	dzzpDPMWy2jOOFSnfNkzfdC4jyKQCdQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778575512;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VVhUu+lg1kvYAZheHCbKtRrVHTg43eeZOy4q05OgGw0=;
	b=wlS+ubs2D6Ep/tmUl0C2jTHAHUUW9og+1my0meSb8uJ28QcnzxeTrdYUZof5QUj/PfTmeB
	6ZtA3N0+klZT+5Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778575512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VVhUu+lg1kvYAZheHCbKtRrVHTg43eeZOy4q05OgGw0=;
	b=0DIAw/LbkWRCYPpD3+i1wnlozxRda8gJxf0kVkjNTDXsTbOdeGH/d4BBCo6imoUNbuN6hC
	A+aBChhNKHHqLAz+qr+5HJ/EO0w9hc6E3Euu0JajBE6G32rTNIRLPKJjnBwwRBLnG/raic
	dzzpDPMWy2jOOFSnfNkzfdC4jyKQCdQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778575512;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VVhUu+lg1kvYAZheHCbKtRrVHTg43eeZOy4q05OgGw0=;
	b=wlS+ubs2D6Ep/tmUl0C2jTHAHUUW9og+1my0meSb8uJ28QcnzxeTrdYUZof5QUj/PfTmeB
	6ZtA3N0+klZT+5Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 23421593A9;
	Tue, 12 May 2026 08:45:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uZmDBpfoAmo7DAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 12 May 2026 08:45:11 +0000
Date: Tue, 12 May 2026 10:45:09 +0200
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
Subject: Re: [PATCH 0/8] mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE (Part 1)
Message-ID: <agLolRUSzT9gnMZn@localhost.localdomain>
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: C6EE74000E
X-Rspamd-Server: rspam04
X-Stat-Signature: yw983ny6ixhqpzjf9fhfh9qmskispk4q
X-HE-Tag: 1778575513-83622
X-HE-Meta: U2FsdGVkX1/jo6bj5uKWtJZK54C8je9vU4mV1kjppYBDJM+GACJtR1q6MDjc4Vlg/08ViNEez7VAyUsUmvsIG2IeXpXtCM7pGclmwGlB2b8mnHJMZivRwMHdweB2Ledd2PzkTtsUlcrXRO3uWMwH7aLaTb0JTlfRNXMpiV0IaZmyatP+GuCzxqsROnng6SfbgLcaOIuOf0LxqJvJYgULllokw4EgDX0THxhgPCgCol36j+a1n5MCssb8m7hbGKZKlaHhJLU478lOckt5sMpn0l/BJR2F5hrfTUaOF0UtH9Py+nvNLi71nf7Si1M8I/G2kJ6R6Uk8Kb0b8iqIkB9ZNOMzEBW6ZHKPAXv1H9S2LZ10gJxlIaLA/JX9a6gg6svTQ5EwCoIUQx2+tXdWBWFK+SXZJGS3jBXyhp0dtBQ+Qzv3KHtw5NV+3+kvkHc92jt8dpi2ITd3X0l7yLM/qX6P6psPwTy0iI1XEzc4t6Z5ZJ+tHFpvADIxj88wCyLfeWKORu1Z4N+Yrxr54EIBDeM+IV6UTo0rnQLYipFkAVF2dDJ65nYVoInA4bv9qbpZTzi+7i/Y+p376PTVz6bAoRMd/TT15s3LLx7RihyKhQwofAE6UB2SGGwWBJZZB6uM4xzWXu80uYDdebJi/+f4o2lfxIxiwZshlPC0pGJN6W6qkUfMJngJ3Yn9OXtlSQMs8X0kcoR0oalzu6+Aewy60aDPaE/EYtuEJHy5vL6jzkNM/sRcxD3hwPQXUM4aqdKTDZskyd/2cGyDVbh98oECqCtbRt/bVbPRc7fATNO/CxhEotdMQcoV406xo9l9jZqsf354Agng7mkbs2ByLiCoZwIvIzZDWDJOSIdW8dxJ48GQ2bWayXdourrwGtQQS5Imou0oOQTFpH5xIIY3MheJ37oVRwSbtzmhgeL6iPJoCNuYbRVwm4fD/7OZpwJmwwPV7G1QQRAsRgaXkf9M7dU3LJW
 vEQc+GFz
 pljPJ9qtzCjd2GfUj4Xd7kncnvktWAJnUtdNjt8r7H9MhdkEN+qnveD7n81sHStOmAiIUwIAaNecmqjqKbI1YzVFdvUtHDPaqMWi8a4Uh5og7gpA+Aqm5w9qv1215qK5GvJCsD3TF/A4EOZqEsMT2ruJvS9kEqGAQokWZQV5bPn7gAQJt8tIAx4+ms5mq4GLnHPyhTuCuo5b7WUqkLoQXYU48ziIh9cHLJIqVCbdRbg4hCs1n+rzImfeMtfKzJZMxP8EldkM9/3ECrjtMRb1wbxAFd2XbZgWXksZu5gPxiN056QbGT6Q25jEVZYTqw/wvnLs04n/C2Qe0fXs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 04:05:28PM +0200, David Hildenbrand (Arm) wrote:
> We want to remove CONFIG_HAVE_BOOTMEM_INFO_NODE. As a first step,
> let's limit the remaining harm to x86 and core code, removing
> sparc, ppc and s390 leftovers, starting the stepwise removal by removing
> and simplifying some code.
> 
> Once a related x86 vmemmap fix [1] is in, we can merge part 2 that will
> remove CONFIG_HAVE_BOOTMEM_INFO_NODE entirely.
> 
> Tested on x86-64 with hugetlb vmemmap optimization in combination with
> KMEMLEAK, making sure that the problem reported in dd0ff4d12dd2 ("bootmem:
> remove the vmemmap pages from kmemleak in put_page_bootmem") does not
> reappear -- hoping I managed to trigger the original problem.
> 
> Heavily cross-compiled, but let's let build bots run on it for a bit.
> 
> [1] https://lore.kernel.org/r/20260429-vmemmap-v2-1-8dfcacffd877@kernel.org 
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Awesome cleanup David, thanks for doing this ;-)

 

-- 
Oscar Salvador
SUSE Labs

