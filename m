Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41BA3CD343F
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 18:49:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 871318E0008; Wed, 12 Nov 2025 13:49:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8226D8E0002; Wed, 12 Nov 2025 13:49:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EAC38E0008; Wed, 12 Nov 2025 13:49:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5C5A48E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 13:49:04 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E595B13B610
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 18:49:03 +0000 (UTC)
X-FDA: 84102842166.29.12444D4
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id 69A9EA0009
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 18:49:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Pmm2REXr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4UXI8DMY;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Pmm2REXr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4UXI8DMY;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762973341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/12U6SR7WkQgyj2k+NmhedtIT7x+SNnjxUusuTSQA7k=;
	b=c5JPOKHGWi/743l8DWbxWlPLT8fOA/9j06olyActzVMrvWrISdSN/SYfAEYGVl7uVyI7o0
	wPAqcgdb3xmNYFA4L/4BI21twirycP0rSNxv+Zzg/mhhcJ10JfNXdOo6DIwXJ66SxB+EP0
	gZsRDGTFWCTiPi5NP/R6XI1TjtafhoM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762973341; a=rsa-sha256;
	cv=none;
	b=3vuj6qkn53tkEpIb58HUtFmFZY14IhFQII9K/vB/XPgPVWrH1RwTF33cCm3wGpchxX09NV
	Vv4msRC+dXUvtqgCL4vKnKEKjTIKHl6tInIibdddPQSzH7ngSbNk/9ldeszOFoYSgryrHP
	3JDvcZJ3WyfUnnZUn0GDXocC+mXVMXs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Pmm2REXr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4UXI8DMY;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Pmm2REXr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4UXI8DMY;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6F9C521BD9;
	Wed, 12 Nov 2025 18:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762973339; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/12U6SR7WkQgyj2k+NmhedtIT7x+SNnjxUusuTSQA7k=;
	b=Pmm2REXrw1avWrBH+xz082qOSzPsytWtjS+uiwtgQHpTK+SEAHQwFa6VeDIk8oSgJJMf4G
	7b/b0+HXynbZXSrqE3FRplaG9dxCTSDXEhupy9yHUiHvWzfxUciyh6svHFn8l1IZtpes12
	VxEWNIDMso6lVfKLVbpC63dN32ixUTw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762973339;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/12U6SR7WkQgyj2k+NmhedtIT7x+SNnjxUusuTSQA7k=;
	b=4UXI8DMYPhNXKXIhfaBTaPhH4Io+ehEVIOk/BV+5G9jRf1H+FIMfYKEFJj+sS/HLJSVIAi
	PxJhju4cEI5v4eCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762973339; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/12U6SR7WkQgyj2k+NmhedtIT7x+SNnjxUusuTSQA7k=;
	b=Pmm2REXrw1avWrBH+xz082qOSzPsytWtjS+uiwtgQHpTK+SEAHQwFa6VeDIk8oSgJJMf4G
	7b/b0+HXynbZXSrqE3FRplaG9dxCTSDXEhupy9yHUiHvWzfxUciyh6svHFn8l1IZtpes12
	VxEWNIDMso6lVfKLVbpC63dN32ixUTw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762973339;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/12U6SR7WkQgyj2k+NmhedtIT7x+SNnjxUusuTSQA7k=;
	b=4UXI8DMYPhNXKXIhfaBTaPhH4Io+ehEVIOk/BV+5G9jRf1H+FIMfYKEFJj+sS/HLJSVIAi
	PxJhju4cEI5v4eCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 02ED13EA61;
	Wed, 12 Nov 2025 18:48:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8rFgAJvWFGkCNgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 12 Nov 2025 18:48:59 +0000
Message-ID: <dfcf8c59-e836-4e35-8585-656b64149ad7@suse.cz>
Date: Wed, 12 Nov 2025 19:48:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/16] mm: avoid unnecessary uses of is_swap_pte()
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
 <17fd6d7f46a846517fd455fadd640af47fcd7c55.1762812360.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <17fd6d7f46a846517fd455fadd640af47fcd7c55.1762812360.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 69A9EA0009
X-Stat-Signature: iondxtg4ruk9bn4raic9tfiow3sqyjwc
X-HE-Tag: 1762973341-241181
X-HE-Meta: U2FsdGVkX1/jSbH63lpx/UbbtT0wrWnAMgfrrXggEhhJlQJQok4She3/yhz1l4yZ76rOBVqNVkhjq+fZa5sxHBYl6BEMl8wlnewT2/xboAvYFDH7QRTQrLtO9CGPoE5WVlzpuSaEvJz+SyrJymLKd2LQ8FL3pVTDPlXWtmyAIM6dHfAP4pLdPwk0PiR9Np9axqzXCMk/LQKQN9+69TWIbiRYV33ZkOlIff+1DkfjWm/dC2njjgCWecJvST4bC8MaO2MlNcBVKXa4vvHPNg3FgXO6CWCtWTnhwaoIk97byWUZeXltsMG31VqTEL3mV3kJIWy0MJj2hWE2k4T9ekq1pn6As5w74cOUkNI8XMNPw7BuI+17jCQTG11IDNuEx6ZaE5GaIjZuiPRmBHbH7maRi/S7JX5ulzhoYeTUqYyRWd0rsCkpwDz5R0orF3vgYxp47IFrpFuZ/Xmk0uXIT/6OLjEk9xxxj4Sf+apW9IfLp1D6VLTZwAmbFnL2nLv8ZgBjPwPXjqNnNBm3cPzafj0bQ0KtWRfmpSBTvKaOqCedWJdWaxg23kXTzY7A/1vEyhuK8VUHjbyNuReOsBEIBq27EB/RDR7a3086SDkGgG3cpVzsqxbwDyHNsc0SQ+Y99tu6gmogcZScKNs7RM9Jkh2+8XWievJ9399FaCXuHcJlo3Vb1K2vMTYfwWdnhfHr/3YJzv0g3qMsKilBDSDtAb7S8MNCjc6kD4wYqjSmW4alaVbFzVgPoLhtWH25zjRiRe6+iQ8qOXfg3UIgQGIf5ZSGyyj15ZBPIkUFywdQr3AfpsVNRbThEWeKboWqEm37zEIQlkN3hx0MUKz4mso2uMIS/TlLDp1PrZ+iORcYnrpB27/0uN5S58gcy3dURIHymdpEMF//+Z0XodmQBVWm8q6pkhlSuApAQGCjZmL8CriV57TlG2Nul8H8PfYpLKg8doXlCBGmpfOWHhmgFJ+DogI
 QjOAf6D5
 lekzU2yo70inSHAXrUxFl1hh59nEfJHIkhdCEkW6COL5bWrln8RhfI+VGzBv8PlbDtPO5gMXlGgkDCkwsThLMUf9jd8UGbaJjfApgRD6jaUWI2mOcqrnchzOehYp8Yx5nC5YDsZzj9ZT4dyfHoEdQtDdGRXht+70LkXolR4/JaOxQeb/0sbRNf9tOgqtj7nT3i/8/TbM5MasNJsqvvjMvuQxznH9aGhdY3lcWvqnuzgCCL5YiBe8pN/at1hcXdHUs+GcBt2C0pbvRI7grLuui6vCQwrju4xf1a6KhfZr5ntBA3lmNNsaQGYNU1NntZC1aiJv7m8YoH/s9oKdhiL+a1opAuq2dEdJdntDUH/lRTlTaEahS0XWrPaLOO0ne59sGndFxw4y8bQCY18qx4dDy9kN/vNSGWyNDB8PkREMxW8Jo0Jop/C1bXarYqqP7nyLUoJQO/orI6xQc0Ng6WAiYVUuS1tAwRrnaNKvQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/10/25 23:21, Lorenzo Stoakes wrote:
> There's an established convention in the kernel that we treat PTEs as
> containing swap entries (and the unfortunately named non-swap swap entries)
> should they be neither empty (i.e. pte_none() evaluating true) nor present
> (i.e. pte_present() evaluating true).
> 
> However, there is some inconsistency in how this is applied, as we also
> have the is_swap_pte() helper which explicitly performs this check:
> 
> 	/* check whether a pte points to a swap entry */
> 	static inline int is_swap_pte(pte_t pte)
> 	{
> 		return !pte_none(pte) && !pte_present(pte);
> 	}
> 
> As this represents a predicate, and it's logical to assume that in order to
> establish that a PTE entry can correctly be manipulated as a swap/non-swap
> entry, this predicate seems as if it must first be checked.
> 
> But we instead, we far more often utilise the established convention of
> checking pte_none() / pte_present() before operating on entries as if they
> were swap/non-swap.
> 
> This patch works towards correcting this inconsistency by removing all uses
> of is_swap_pte() where we are already in a position where we perform
> pte_none()/pte_present() checks anyway or otherwise it is clearly logical
> to do so.
> 
> We also take advantage of the fact that pte_swp_uffd_wp() is only set on
> swap entries.
> 
> Additionally, update comments referencing to is_swap_pte() and
> non_swap_entry().
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

LGTM (famous last words)

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>


