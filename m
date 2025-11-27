Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B5E9CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 17:03:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9E3C6B002D; Thu, 27 Nov 2025 12:03:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D752C6B002F; Thu, 27 Nov 2025 12:03:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C63E66B0030; Thu, 27 Nov 2025 12:03:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B413D6B002D
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:03:34 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5A096130B1A
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 17:03:34 +0000 (UTC)
X-FDA: 84157008348.23.5B1F3D3
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id DEBBA40003
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 17:03:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2EUbAYca;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/L6cDWlc";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2ksZ0x8Z;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JDaDWeBe;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764263012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kOxP+4sJ/rrrnW9GypwNofQ+BkHdHzsAohtqE0E/6Vw=;
	b=t72uViXo/9eBo51ytxyTMNAFhOUiLZUnWtK1oYfUKPP3sJDMEertDkI7p7xdY71BdU0wMC
	r2VryPBrr63uVr7AlLQPZ0okK5N3kQvZJkhfDv9wlwTGaBNN7u0pWZGLrz+9tCEmogN2yp
	gTdMIFShW5nF371UAmZbFc7OGwvyn/c=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2EUbAYca;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/L6cDWlc";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2ksZ0x8Z;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JDaDWeBe;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764263012; a=rsa-sha256;
	cv=none;
	b=DlOH0PHc5hYswY/WhFiK88uDIlQbv7S5ZrBu1prSBa3Hf8EF0PxbmfGXMXDcz1+xbycMkz
	0CnJv3BY+4c87edtuUBSQdNc01ayjhXpabER0jri8dzophS4YO70jOxpp1T/vJPIX2/E8B
	eKc7rLfVN4N8/svybB4Kzg0WgW+x9HE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0AD0521B51;
	Thu, 27 Nov 2025 17:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764263009; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kOxP+4sJ/rrrnW9GypwNofQ+BkHdHzsAohtqE0E/6Vw=;
	b=2EUbAYcas5pDDm06Js+QDftByBaiw5E7dLdPeQ7e5tnwDMtoXfN6AQL1wd9tdUPkAvjWjU
	oE8ykHlg3aBsyC359ow9RMJmQ0d+iHGA5bFC3kqXLISxNEjEohO/4qEHB1I/iRrguzyu5G
	UqxK+sS0D5Vq0AG5/MBOSqTrq75GaRE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764263009;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kOxP+4sJ/rrrnW9GypwNofQ+BkHdHzsAohtqE0E/6Vw=;
	b=/L6cDWlcRAd5WfPimjpDEKC+/8eru1sjFGmfM6VPUi3ZzqTj+OcjA9VeFWlCpv3n78+cKe
	j6+zlp7Xs7H9bzDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764263008; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kOxP+4sJ/rrrnW9GypwNofQ+BkHdHzsAohtqE0E/6Vw=;
	b=2ksZ0x8Z0WOxT2OAc6pt62cd69D2oTffZpCF9JA87/gUHDoO4FHpBN1wQW1zmdtA5WlUSD
	kV8HCfDEzwh4ZpgnHqlio1z9Y7e4dmM0pmTJIBN2KfSGyIg6hAEm0dYee2DRWjyvtobxBU
	b9ZuC5TR/HLIPp16L2OHrb8joyGGvvk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764263008;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kOxP+4sJ/rrrnW9GypwNofQ+BkHdHzsAohtqE0E/6Vw=;
	b=JDaDWeBe0uB/rv4Ta0iYA/LnMcHRSHzkN9pXRDcbVfEgpFmSg8jJgwFH2l+4otCOUM+W8F
	B2cm7ODG8wwnJQAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 844953EA63;
	Thu, 27 Nov 2025 17:03:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XQj8H1+EKGmTJAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 27 Nov 2025 17:03:27 +0000
Message-ID: <160170ad-cf3b-4ef1-a77f-91980eaaacc9@suse.cz>
Date: Thu, 27 Nov 2025 18:03:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/16] mm: remove remaining is_swap_pmd() users and
 is_swap_pmd()
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
 <1628b00b00c8498bbd2c20b82117ee87845fb738.1762812360.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <1628b00b00c8498bbd2c20b82117ee87845fb738.1762812360.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: DEBBA40003
X-Rspamd-Server: rspam02
X-Stat-Signature: 49os61387g4hoa5rj85b3pm1pneed4u3
X-Rspam-User: 
X-HE-Tag: 1764263011-220343
X-HE-Meta: U2FsdGVkX1+d0RIH54CAvVzXSuGLwiUgIPQdu6Ylqhd3rX+MrIgu3QLkf+HP9Len0rk8I9iCYhCa8RPiV4JDIfpnRjRnnLNhAIUUJXIG/gRzYVgGOVvWKbMgdRM9WrGirSTmwYRdHG7MlW2QGIddKIWVshW5U/oonMPe0RXO2MEtncSwkv5J1D3PyfBSdWO/uIvum9pyEcwW+KCur9y6aP0oNNo6vIlys5RmuD95HcB84p+pXfPIH6KW3sgTiuzSjEQtB7BKKnW0NT+a+RgO9XgJwE6gyC932m9zhey6+gzVUtnJFs0imB3jxGyr+iGGyjUEGDlRkDueKwbruZ2D2W4wymlx0zVBFXhlS2lJm3ywzFtJ4qCxp8Ot96rzYf7InuBGrW3uhuPiYuLxmCqPHWVbgztHZ/KuF2usIa+2CYePpDhrBc56OJK/qTLq0IrjKe5KpKt1SOPn3NxyPaTkvgo0o0hXvc2mBtnRoRo5UWBNAwBUUjaDCVaU9uz7VoYSCvKCHBBczPd7rGlTKC3SyAILC52xNlWjJVh3X5YtHGaOPG+wOdE8fWrqwSrnChMRRzGWRkmQeCsPex/Xhao+zXqYcaE3dduPd3fvFmnkWFJ0Jw5GCI2LsK7PPI91VhdKZWRwCGJGjBsZvxXqeL+YuizX6NzsI4XRzsBn7VEAoS0hADl2u1dbRTYuv+SG+76MwBaxxLCP+xoM6/pKEAi/85lJPU3PNnZTlNSpyD19tmqbsWDOPlRiuaWfCwS2mxZqAfvjhlUZxi4PSFmR/V/COdLp+dohqE6ZTX+GWYWsctTuKtrTv1WD9JLAcF5tPM2Q/RzvJeDEiJbqUzd7oO3iaFZbx+LBkQ3kx2FvJ6LkudzvbEFx2le4enwdvfRwTva4Ly9y/6e0iLCJWfA8K1HQtNhOvnx7c1NYElOJepjmZAT7BVK4NANZKZllbCzILqtl0WchQWj/UG3zgHXWq5d
 JaZ5eDHj
 QiAyxzQgMSi+j0gTKykqeXKp2bbaW1dFGun++1Evjmk2igmwHmo50J9y/elHal3z9VMh7BRgYlVkjqNQPFQNsvk3Ww3V7wS4x39w1AUdQZA2HD5rbt8lsMG3Csb5Ie6dMdkVnRix6IEElvGHmCw5jgOpUH5C8MpzEtY96s1Y11KeCX9PeDdJks9Dx4RfiBzfKW0yidG+SbxWBabNkCii+HepA0dfw0Ak0AaWfSsR6sq/dZ+uK584zl9jtt19PJA3DOgg0qnDEQ9l49tgwSnOnryX40Xe/h/vliXKzZ0n3qAnEtnQs3du1QyKNo9eStDg9X4aNxRlplV3QtjtgU/Ngi8QKQiA2MQAu5W5LkQE32DmJ8hsblNKAfhLxkskHx4JbdK5s7C1hd9tS+FoQnL3fnaK3S5Bpl7aGai0EtGQPxeEVYwo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/10/25 23:21, Lorenzo Stoakes wrote:
> Update copy_huge_pmd() and change_huge_pmd() to use pmd_is_valid_softleaf()
> - as this checks for the only valid non-present huge PMD states.
> 
> Also update mm/debug_vm_pgtable.c to explicitly test for a valid leaf PMD
> entry (which it was not before, which was incorrect), and have it test
> against pmd_is_huge() and pmd_is_valid_softleaf() rather than
> is_swap_pmd().
> 
> With these changes done there are no further users of is_swap_pmd(), so
> remove it.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>


