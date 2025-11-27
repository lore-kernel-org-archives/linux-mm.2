Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60DE6D111A8
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 17:53:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A34FF6B00A6; Thu, 27 Nov 2025 12:53:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E5B86B00A7; Thu, 27 Nov 2025 12:53:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 886E36B00A8; Thu, 27 Nov 2025 12:53:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 75BD26B00A6
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:53:27 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1F341139D88
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 17:53:27 +0000 (UTC)
X-FDA: 84157134054.03.4CD2632
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id A235E4000D
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 17:53:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AQ5DC0bS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=01W7Ha6Z;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AQ5DC0bS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=01W7Ha6Z;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764266005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I2bxBx6skjNN8aQa0tymzrXdTrQlYavUe3kOLFFhVPE=;
	b=wkkZAu5EmoJ47stVJNwGgLc+F9T3i08QFilkcfSbfBsK/9geHnD/6aPgw80mE938X5C1dL
	e9p5y+fUNcWTXMn/R3FWukJnsmcHdPSlnCfTNg+uKilFDCbqhWQYxiifaKplPfZk+jh5DK
	+8O6LrDhKSGa3zWVDMzLnjaYYD8SzB0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AQ5DC0bS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=01W7Ha6Z;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AQ5DC0bS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=01W7Ha6Z;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764266005; a=rsa-sha256;
	cv=none;
	b=xookPd5GfPjEKmRcWDrq9Pn7VVD1KjU3BB5nzesuGb3MnBCBXlqI8zQNaEtvU+TjrvG2dL
	tKlRZ2fapqi9ZjtSnAbZ6/zsxsGfAaSGhUMecZVyK2fsaFh3RL440KU7DqagINYIJIiXX4
	4JQnr0E4cSX7DzLlDDgYkNyzkPwrqt0=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B32CA33682;
	Thu, 27 Nov 2025 17:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764266002; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=I2bxBx6skjNN8aQa0tymzrXdTrQlYavUe3kOLFFhVPE=;
	b=AQ5DC0bS0XgyDufyx+PVfcG2PLQl+2mkmvEFga6us7YBx3Ye8x6nZoTwiiUy3Df2H0tOvl
	SQ0kZ1m63BXX4udtthNhhw7uOu7jMJB8wmqNqgGznt2J2EQmknHEFa+ek9grnz5yLnVsOa
	7np1D08fHTUb8BW6nLMqw/y5PJupkCg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764266002;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=I2bxBx6skjNN8aQa0tymzrXdTrQlYavUe3kOLFFhVPE=;
	b=01W7Ha6Z3q7kvqGz8qs050H6fFlJr9ncC8y1BBnU6xECt3uODNUA8MfBts4Ki93CRotYdP
	U6rJ3Qs2LVp0kEBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764266002; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=I2bxBx6skjNN8aQa0tymzrXdTrQlYavUe3kOLFFhVPE=;
	b=AQ5DC0bS0XgyDufyx+PVfcG2PLQl+2mkmvEFga6us7YBx3Ye8x6nZoTwiiUy3Df2H0tOvl
	SQ0kZ1m63BXX4udtthNhhw7uOu7jMJB8wmqNqgGznt2J2EQmknHEFa+ek9grnz5yLnVsOa
	7np1D08fHTUb8BW6nLMqw/y5PJupkCg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764266002;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=I2bxBx6skjNN8aQa0tymzrXdTrQlYavUe3kOLFFhVPE=;
	b=01W7Ha6Z3q7kvqGz8qs050H6fFlJr9ncC8y1BBnU6xECt3uODNUA8MfBts4Ki93CRotYdP
	U6rJ3Qs2LVp0kEBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 39FE43EA63;
	Thu, 27 Nov 2025 17:53:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tmbODRKQKGlcVAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 27 Nov 2025 17:53:22 +0000
Message-ID: <f2385065-cdd4-4e87-872a-b5e83014e590@suse.cz>
Date: Thu, 27 Nov 2025 18:53:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 16/16] mm: replace remaining pte_to_swp_entry() with
 softleaf_from_pte()
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
 <d8ee5ccefe4c42d7c4fe1a2e46f285ac40421cd3.1762812360.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <d8ee5ccefe4c42d7c4fe1a2e46f285ac40421cd3.1762812360.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A235E4000D
X-Stat-Signature: oa7h64jfirm57xuef9byp7s6ky5dimxa
X-Rspam-User: 
X-HE-Tag: 1764266004-848104
X-HE-Meta: U2FsdGVkX1/gNvhpYVRyuH+lUwx+yebKJI24ZJVHARylvLD/X0NhAkTxlWZ/S7DzxxOem2xf+cwV0wgfchrYTdKgdJmZAFVD2YaP2DRmZ+g9kdSw6EgQ3mKqMkRTPAy+87rNmi+bdeXW7hLbzXmXyoDA+J2vn9zilLdE4udttr6FtxbdvYeV8zckSBwEKLhvceMAbsXHeu0tkQ8JuR7ksgTP11qD9lC3aTLv2lBcb1ISU43W6Wx2jMRkGrvF88Moe6q05OAAbhYZOR82yCp99Ha953c2MdjKTuOQWol1gkB+4Q6rl7HQ6HGOnmGskhQ6EE07OIhoIcce4Caf3efVpebfPj66Tw52RP185ThJbCSFMujY+k+zSdrVu5t7avpHue2XKpJV+qm71Q6sA96O2LnLzcOoxcWzMlJgoOBMOl6oU+YFSYi1hD2ZGH/cvw/v676FNjq1gC0eIiAW8q0qMLR+ALoTSPzmjqaGfcSqcAs9Pl4QmdiNDxD9tHA8tb4O8Mw67GFjrQhj8dafKP+1QV/U+0C4KfduaYbdQ0fPPTmlFotSsgw1awW+onZ/FeItFFcpOJVsBo6O1Sz1Ttnv365SuF++XqywF6Sr/jE9oTMJHi5EtqDdi5+Y8jKMDUQ0O15/VNtpoaADsTFj2jV+tbf8jBRgmB4yGH/NQO0IT5Ay0DTLtSGhHbt913FAac90iPCNE4Puqyg95/g3F4BND5J4b8F872lPY5BHJrBA2Hb1S1K8yR0BBNSSTxy4xDSg3tQzoLekRFJYaEwAULJVfiEJNAEkSvmku/qCn2Dtxrr2RjWfI+qEd1PYn0AK/UjY4t2XSkuZgFMYMp/xO3QqMp+ytTBdDR/yypU6yVdFvtmSY9PaFnooN+NoJ2r4AdlFSfHx29OOZsfw0w9LbDkrE1tb/oaqdOkMxpGnNHXcKYQBu+s3lzT2U3EjV0+9hK7uiwuKOlbcoJR7el3XPSo
 nzwQNlWT
 ChRoyY06FsNr0rwAqjqWm/Zsp+XrOhEkpM/h0SPbPDfhTZIWqApYOqdYxIfASFGeTDAEBm0b7wkVxSAiY0obDixDtRiAT983Muti80+fqYEFPV3j0ltiiGY/rwm1ZVysY8pCoUsMa6hgQA0NEJXtG1Fc0o5+neUqh2C0iM309Fm/O2mnNo2yomlJ7e0QkhMVtP71a59rYQAOHxB9LQQddFvKhW/PrMlOMLsVuxmMil8wEhmFyp8HAVsAL+4nT8JHyd34xRtdELX8FN7TyNLZBdY50o3PbgUCeUD/YbQHCPa0ESnr6oTlJTvLuxHZ7YpqWMmr51etAeodkdVyqOdwAeNOSawzu7UqJyYmKWTMqOG52MYyBbZzgs93Opk+fgYqE1/jtFym+/zpnQ6qTdnVvHjmJ2pQIRb4EnjrJlHRI849yWf4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/10/25 23:21, Lorenzo Stoakes wrote:
> There are straggler invocations of pte_to_swp_entry() lying around, replace
> all of these with the software leaf entry equivalent - softleaf_from_pte().
> 
> With those removed, eliminate pte_to_swp_entry() altogether.

RIP.

> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

Impressive work, I hope it can be promoted to mm-stable now. It would be a
pain not to have it merged in the 6.19 merge window. Still plenty of time to
fix up any hypothetical bugs not found until now during the rc's - overall
it looks solid.

Thanks!
Vlastimil

