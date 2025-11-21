Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE53ACFC28C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 16:47:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4612D6B0006; Fri, 21 Nov 2025 11:47:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4394E6B000D; Fri, 21 Nov 2025 11:47:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 327CE6B0088; Fri, 21 Nov 2025 11:47:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 20D776B0006
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 11:47:00 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CD23459D82
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 16:46:59 +0000 (UTC)
X-FDA: 84135193758.16.43E0C7D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3C09D100018
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 16:46:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=owZ8TKE8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5bqFyex+;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=owZ8TKE8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5bqFyex+;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763743617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BtvP/Bv21zIJUn/ckdTnSK9vSZ3KC0jdHLL8cUGc008=;
	b=71JzOGkfQLZD+wknVcpJ4pcUhlAc0UQNJahuYJEs1DLO80YOVExmED4OAlEI1I8kb3zL87
	1DVCbIR9/ej3IehMupginln7cmlR6VYnPL6/IrnQmQfvZQWJknOwvE6gm3GYxSq5aNZvKv
	uraT2UlD87rm3VVjj+msKIte4WhQCy0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763743617; a=rsa-sha256;
	cv=none;
	b=LpX8tqw3jIxeAXvYZqRv5ynja/pkxDJWPEnbg5V77ISaQhkRCa1RulMstVSg5S8aXVLttR
	HEoTeakoTjSwvRTIezYAC86x6FWfTRZfaWlAasA3ZuIL+hwQ4v95GRJ/2fyVQ8cs0s0ZB1
	xcw7zQ7ueXtyGD7ph+y7LAfrQ2XZkBk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=owZ8TKE8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5bqFyex+;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=owZ8TKE8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5bqFyex+;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 01AE35BCC3;
	Fri, 21 Nov 2025 16:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763743615; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BtvP/Bv21zIJUn/ckdTnSK9vSZ3KC0jdHLL8cUGc008=;
	b=owZ8TKE8Co04AWk/cw6g+Z+e+j7trgA5vvEbVKBTTFF6L2NUiWWtDca2BfsTo3Y13ZTREI
	eP4tGlsP68nyzhNx+S8CMq6lpvBDi0Gw4cfVcVBMmwVA6vyOr5exSnQLAD9e3S9FUFuXn1
	fH/eXQNDUwctqepqYen7/lzDGk8AUZA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763743615;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BtvP/Bv21zIJUn/ckdTnSK9vSZ3KC0jdHLL8cUGc008=;
	b=5bqFyex+miGqXTsQQxOschRQshWw1+ggMbZ+ie9Y7UzNONOuRzdjIZoE0yiud9Y/CAVSxc
	11OUhTc5VgXS4DDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763743615; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BtvP/Bv21zIJUn/ckdTnSK9vSZ3KC0jdHLL8cUGc008=;
	b=owZ8TKE8Co04AWk/cw6g+Z+e+j7trgA5vvEbVKBTTFF6L2NUiWWtDca2BfsTo3Y13ZTREI
	eP4tGlsP68nyzhNx+S8CMq6lpvBDi0Gw4cfVcVBMmwVA6vyOr5exSnQLAD9e3S9FUFuXn1
	fH/eXQNDUwctqepqYen7/lzDGk8AUZA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763743615;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BtvP/Bv21zIJUn/ckdTnSK9vSZ3KC0jdHLL8cUGc008=;
	b=5bqFyex+miGqXTsQQxOschRQshWw1+ggMbZ+ie9Y7UzNONOuRzdjIZoE0yiud9Y/CAVSxc
	11OUhTc5VgXS4DDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8A7D53EA61;
	Fri, 21 Nov 2025 16:46:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aSd3IX6XIGmhHQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 21 Nov 2025 16:46:54 +0000
Message-ID: <ebbd8d9b-03ca-499f-beae-7e8c4cc16300@suse.cz>
Date: Fri, 21 Nov 2025 17:46:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/16] mm: eliminate is_swap_pte() when
 softleaf_from_pte() suffices
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
 SeongJae Park <sj@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Jann Horn <jannh@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Pedro Falcato <pfalcato@suse.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-arch@vger.kernel.org, damon@lists.linux.dev
References: <cover.1762812360.git.lorenzo.stoakes@oracle.com>
 <92ebab9567978155116804c67babc3c64636c403.1762812360.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <92ebab9567978155116804c67babc3c64636c403.1762812360.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: 5isxy9mmu663cqriz9tzgwcd9eaydjoe
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C09D100018
X-Rspamd-Server: rspam10
X-HE-Tag: 1763743616-679444
X-HE-Meta: U2FsdGVkX18fe+fbUCq4TTy7Ahwyr6AxqtAj5W7N1JxzXBA4uAxWSiyjup3YsR5oNc5LoKr2Xfoj1cIkL+mb+LdN3nlNnHUG5xKSg0x/sY7gSsn89DWubx0wNRGDlhUAQS0+3R28tX8G+hN+I2+Js9rfz8VWnVefzJSV88mVOR/JMUWTnh8hFXqLoiR9HAOto2EQDv7bdyD5MFGFAa5neX8ClwESv76bOpsICY72nk2h63LxuBrDm/2mWnjoFu2fDCOwOkEXbmRlgTaEB6i1W+oDZmhuhw0ErymodN4lqRrFGjuC2fkmWs1z4FIfy495YV06LRKbts8ZfsixI3WiQRKmNf0+kUp8AiSf3O29yxQ3ODfkelFaUuDpbtd1dQmamUnF3q0pg3eevQ2FI1ebzKQZDMV4tTSFP2XHFD9fAsUx10T5Cx1NVp2pAkhKqRVK2ta/MJWrOcFbS9K4T3f3FdPWRjLjqbsfjfTqdfXCX+Om9ulAYUBJah0bx8wNTARVHfOkdHksWz/1SwyRicuHe8E/WLwaR0Z8OtC5n6uRrrec5LuEppwVpiJYPGHlV6PvRBGYLsL53x4j+qHe/oW4OrYUtvZr+OSgA5izrq7BrvNR76W297LAfiLMk+mHll5HXFzEJDwD6CkOfqa9yXJr5DfLRZbnIH5CJyMHYtcneEwgSsjQlVG6tL9kGLQ42cFOE0NplqLvEXmPbLVkOjGEc6HSPvf3D3tGTbCA1dyRW/+hSxp79q1OI5YccIU1qVwA47jQTZvoFSbxLRzexWGNMe32f/8s0d0v7IEvgzDm/hZm07aRNRf5g8jFy8tbtRsXsk4jIf1unH80ITlP2vGG6ECFuK8canKGxrF1bx2zuwCaTzK5vemF7Z4VlxfFw2SO5+ERt+HSISvhwmz3HH8eWf11QJN/r+KRA4zektawe1sloGnlJTIBckrUJGdzRAMdQ9VIhyLP+Rf9nA77lYs
 Kl5pySPU
 l8fOosloSzsri/TQIhghmqse5JCaiZFiTzvyAF4T4N4N71hfXbRVu4HeaAo2ayeOwLP8cBhum11WcGhUajS97U4/K+N7LPoT+W3VFq+/VLg2+t6QNLuu9+tukTbPFmeUhr9SqmVStZe01BZOOKTpMDQxY3BD5qQzMuYnlGjfahHudgx4Ypr6xLgkc6o5MLYER0DL5TlVrZHwnPx04oZFIN/OfocCV7GPpCxorW3IGDJN5XAnkzX+GC158W24UwyKB+lIwBOb3955FQPUKf69/JmxTDr6VOlBqwzVYa/caaDvtwLjbuYCU+Nle7/dzT6f2VNPPBecYneOFjdmMoRmnftH5P4QRFRM6zUQcesidFY/AuvjQTz66V5t6/c52MBePBV6oANtinPq++GROaXJWNbC6T2NdQNbCzvyEwQokGFGzjrI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/10/25 23:21, Lorenzo Stoakes wrote:
> In cases where we can simply utilise the fact that softleaf_from_pte()
> treats present entries as if they were none entries and thus eliminate
> spurious uses of is_swap_pte(), do so.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>


