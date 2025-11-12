Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 664FDCCF9E3
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 15:36:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9AA08E0006; Wed, 12 Nov 2025 10:36:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4B788E0002; Wed, 12 Nov 2025 10:36:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EBA58E0006; Wed, 12 Nov 2025 10:36:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8824E8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:36:28 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3A6D3896A6
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:36:28 +0000 (UTC)
X-FDA: 84102356856.20.E9A52D4
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9C300140011
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:36:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=w2crCEKj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xFf6Np5s;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=w2crCEKj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xFf6Np5s;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762961786; a=rsa-sha256;
	cv=none;
	b=2+lBniYAXRZsVP1oTMWAEqKh4grUQEXdrq7UgubY/2AWKmDr4gkZhWFmPA1I2iTTEjnUs+
	mvLDCeVEppg+a4s1SorMPEGiR2UtBElyr6b9FRklHVfwl5ni+eUB1Vfi/NOB//1Ul7Ft0s
	psUBqrxs265V7gRQFDF3sIe+mUc/0wY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=w2crCEKj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xFf6Np5s;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=w2crCEKj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xFf6Np5s;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762961786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fX75i2Lzln3IQeViFhX6j6HYzx6F1grw7CrmIOYT6+Q=;
	b=PREMMkoVwQtaUpi9sAQdAKtpdtWwVnvQetKk+mllA6pgVI7deyJc5ECQrfrpK6Ou4moHps
	QhT15u9TQa7EQIYdO2NINHp6QRVM4bFA6fOY0NtAeMYb5hiq+X4uUJmzebarLSwbgXQjxf
	T/O4F7dLiUSVp1muIvZHzVW2ox+C2S4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C86E621A0B;
	Wed, 12 Nov 2025 15:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762961783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fX75i2Lzln3IQeViFhX6j6HYzx6F1grw7CrmIOYT6+Q=;
	b=w2crCEKjf1IrBvkcD5xtuIDkn/eWpDJpJ8PKOyopv36Uw8bEXLQfrEzHo+xSBU/sgiHdwT
	VAzkAK5NGN4ATcFPK402g9pH+aMgaP0XPOGnMq4/oY0/1sK24WCKst/MQ15XRw83QOI6FF
	4QaJI6tzzHuf3mfFlTQnAisRGhSstwE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762961783;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fX75i2Lzln3IQeViFhX6j6HYzx6F1grw7CrmIOYT6+Q=;
	b=xFf6Np5sU8Sjx5YYWaAvEKqQNHrxz9oza/tTX17ktO7kM2YA8KYZtjiMHZfwHi3FVImNbc
	b2+D2fNdxWt/ckAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762961783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fX75i2Lzln3IQeViFhX6j6HYzx6F1grw7CrmIOYT6+Q=;
	b=w2crCEKjf1IrBvkcD5xtuIDkn/eWpDJpJ8PKOyopv36Uw8bEXLQfrEzHo+xSBU/sgiHdwT
	VAzkAK5NGN4ATcFPK402g9pH+aMgaP0XPOGnMq4/oY0/1sK24WCKst/MQ15XRw83QOI6FF
	4QaJI6tzzHuf3mfFlTQnAisRGhSstwE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762961783;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fX75i2Lzln3IQeViFhX6j6HYzx6F1grw7CrmIOYT6+Q=;
	b=xFf6Np5sU8Sjx5YYWaAvEKqQNHrxz9oza/tTX17ktO7kM2YA8KYZtjiMHZfwHi3FVImNbc
	b2+D2fNdxWt/ckAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 63B5E3EA61;
	Wed, 12 Nov 2025 15:36:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tIDBF3epFGnsdQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 12 Nov 2025 15:36:23 +0000
Message-ID: <c113069a-8581-4e44-b7a1-7bfe9de623a5@suse.cz>
Date: Wed, 12 Nov 2025 16:36:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/16] mm: introduce leaf entry type and use to
 simplify leaf entry logic
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
 <c879383aac77d96a03e4d38f7daba893cd35fc76.1762812360.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <c879383aac77d96a03e4d38f7daba893cd35fc76.1762812360.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9C300140011
X-Stat-Signature: wr1xdncuf5se74f4b89mc41o5uyattsh
X-Rspam-User: 
X-HE-Tag: 1762961785-646177
X-HE-Meta: U2FsdGVkX19xoeE4T4VEAu6DCW5jR37obOi+CykXsgdARettG1Ljj8l0bSh76clK7Z2SJiiiRBOSoE1YA9+8DDy56Tmys2/MaH4uhlKtUsSSXPEXN1GC7yI5l4Xq6TwzhCcd6ogSkAyh5CVXcFZO7ac4i/fbbPdiN/IEE6vAs/ggEl8WBDi59en8KJ4hMZvzH4L6cHFCiyA3CE6DVhuBKIO2SAyECa7DG7ST2TpT0ttY7EE8jz6324gG9lB9/j9mMl1B2PdXKzWA5d9LIJHqPjavr2vYNVKunL9+PUsdiaYtlGJne/mEHgOcxTaRSUCYJ1R3YuZWDJyxIgKEAvLlZYKaQqfR8BgHXIUgJwRiJ4EeJA69GkVy7QnjcDp7AXmPHdiPF1AdBUdmPesIn+J7JuA3MQ18UUSb+j3Wo+EWzWOqiCsZmz/QJ9SEPqSlWPnmgzUrg6ed5PBvtQGdZ7q3dvg2YSg28HAect1d+eobN0b2l2/JJWY+1A/liBpI+r5jhmdU/OMq9BvShwQv/QvvrK5znFj8PROkcwDkBa7JOLQP/Kz02h9XXPWMtfrsu4zBDd+HeHy03e5QZXa0HhV/PeT5Iz82o6sl2VutwlPYIfgFwA7g1t24m06zSuSLSQFlk4OV5szoZLy6SGme02pbfB5UmkbAMbYmTkwuhkm/t0Zo04L4DstwmIVgP0g7Y7Lok1h1GoFlrPAXXpjWvvbbWM+zKEIdRztlPTmIhwRgU2zs/raF3MSpCJMT+1RMnVMgeZgHsvPhh3X1eEodjMgC1dkNQ8I8PloCjnSNhPg0vGFlDJwOTUjJ36LUtgkF6tonkN7fajmbMcZ3XvquWKL5kq8TcmaG7SPa8Ja1Ig3DhI7I4zruA2/vyA2T8/vPOG/oo9WamNTnWEIdQvoRBmlrbOudYELNsNAidOtmjB3AmWhpI2zZz2zdZDO9C8e2BSiB13Ha7ubOWuccuUh/81D
 L8My4vkP
 zdIsSHIhqfSmRXTgVdMkG1xE84VDbI81YIaorSqlDOz5J2CVaTAqdSyApSCoECi4bM2IuPHn+pIuq6tfuaJZPdlFFJXu6/jDEqbBWN5BDnjI8trASQVVSdU5ILrovq1aWUtXUUquZ+mz4j8xzVy+54IwllsN3AAIZOl4ZZuSASlcjAer3+GnyjDiqnkBGQScr88HJa+2FwHeUS4kTY7CjXuNHgV08dSUZxR72KmGIeXy0MePvWpR2b67400VrTLBbLhxQ9hboJx3lHu++r1Zf+SpK9dgPr77Xon8p/TlWMLVGzXqBtVVTVNc0eu0TxPsK9Ma/akge3oVekXKRclgReknafAiF2acTxC/TrTpGpELn/DT/Pbw+NKdtFT0jsBX78enZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/10/25 23:21, Lorenzo Stoakes wrote:
> The kernel maintains leaf page table entries which contain either:
> 
> - Nothing ('none' entries)
> - Present entries (that is stuff the hardware can navigate without fault)
> - Everything else that will cause a fault which the kernel handles
> 
> In the 'everything else' group we include swap entries, but we also include
> a number of other things such as migration entries, device private entries
> and marker entries.
> 
> Unfortunately this 'everything else' group expresses everything through
> a swp_entry_t type, and these entries are referred to swap entries even
> though they may well not contain a... swap entry.
> 
> This is compounded by the rather mind-boggling concept of a non-swap swap
> entry (checked via non_swap_entry()) and the means by which we twist and
> turn to satisfy this.
> 
> This patch lays the foundation for reducing this confusion.
> 
> We refer to 'everything else' as a 'software-define leaf entry' or
> 'softleaf'. for short And in fact we scoop up the 'none' entries into this
> concept also so we are left with:
> 
> - Present entries.
> - Softleaf entries (which may be empty).
> 
> This allows for radical simplification across the board - one can simply
> convert any leaf page table entry to a leaf entry via softleaf_from_pte().
> 
> If the entry is present, we return an empty leaf entry, so it is assumed
> the caller is aware that they must differentiate between the two categories
> of page table entries, checking for the former via pte_present().
> 
> As a result, we can eliminate a number of places where we would otherwise
> need to use predicates to see if we can proceed with leaf page table entry
> conversion and instead just go ahead and do it unconditionally.
> 
> We do so where we can, adjusting surrounding logic as necessary to
> integrate the new softleaf_t logic as far as seems reasonable at this
> stage.
> 
> We typedef swp_entry_t to softleaf_t for the time being until the
> conversion can be complete, meaning everything remains compatible
> regardless of which type is used. We will eventually remove swp_entry_t
> when the conversion is complete.
> 
> We introduce a new header file to keep things clear - leafops.h - this
> imports swapops.h so can direct replace swapops imports without issue, and
> we do so in all the files that require it.
> 
> Additionally, add new leafops.h file to core mm maintainers entry.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Seems like a reasonable first step of the conversion.

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>


