Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A234CFC296
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 17:58:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E71966B0005; Fri, 21 Nov 2025 12:58:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E23006B000C; Fri, 21 Nov 2025 12:58:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC4D66B0032; Fri, 21 Nov 2025 12:58:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B49416B0005
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 12:58:47 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 50E5C13B93F
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 17:58:47 +0000 (UTC)
X-FDA: 84135374694.21.6A66C6A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id 075C24000F
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 17:58:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="PNf/GEz2";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BA6od6MC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="PNf/GEz2";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BA6od6MC;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763747925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u4u/nMM+KNkjjkTjIpcny8cl0z0ryRicvd/zDPGEOSs=;
	b=gFj0pnqQXOJ4EFVclJa45iJ+n0MQn9kamulC9hbq7u6AQBqvPTZKfS7LwAQCidVCVpSD5B
	18WkVJLuE6NRMM6KYw0LDZstSwKnMR3E3js5k3x+kgQRmn1JoRxmduZDGdgJzdhikeMnQJ
	bu67vFMnjOmhNkUH6eYykspaPpIFvfU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="PNf/GEz2";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BA6od6MC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="PNf/GEz2";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BA6od6MC;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763747925; a=rsa-sha256;
	cv=none;
	b=3BfrIKZM/qYvXBkpwxM7QfHXjBVx6PDIJqXAIMGG+7t7nBWT5NCk7WvSV+9KPaipNSU/MY
	FeesR788iwLZbEbWXzmPalFFwcHhzm95+tf/Gvhqx6LFi6bcGwF1kfgq1YZTZli0ciaVY4
	yUxJg3yQ2mNREdR4Z4JE/pwdYcJNTFY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C374C5BCC5;
	Fri, 21 Nov 2025 17:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763747922; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=u4u/nMM+KNkjjkTjIpcny8cl0z0ryRicvd/zDPGEOSs=;
	b=PNf/GEz2AfAl9PN7kljSM47+pWoLj/riChRqrJQJiVWBgx+VBW6bbjtyTb5mpzHNzk9eL5
	xIx9qXoci04ogBP/rTerIwxIUiXMgtTKV0UmQhrNa1Lxv9Rv51B9LgU+Pjk4AigPhASx6+
	lj6FnSfZxQ8iT9RNeSvQh1a0TCdN/JI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763747922;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=u4u/nMM+KNkjjkTjIpcny8cl0z0ryRicvd/zDPGEOSs=;
	b=BA6od6MCv7fGYdd8JUjEdbBLZ4bw0kTt3dYnK1UMw8UDIkbzMj1fPB6zD+rKzhyaqxJn0Y
	d4bgo5XtAg5WusDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763747922; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=u4u/nMM+KNkjjkTjIpcny8cl0z0ryRicvd/zDPGEOSs=;
	b=PNf/GEz2AfAl9PN7kljSM47+pWoLj/riChRqrJQJiVWBgx+VBW6bbjtyTb5mpzHNzk9eL5
	xIx9qXoci04ogBP/rTerIwxIUiXMgtTKV0UmQhrNa1Lxv9Rv51B9LgU+Pjk4AigPhASx6+
	lj6FnSfZxQ8iT9RNeSvQh1a0TCdN/JI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763747922;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=u4u/nMM+KNkjjkTjIpcny8cl0z0ryRicvd/zDPGEOSs=;
	b=BA6od6MCv7fGYdd8JUjEdbBLZ4bw0kTt3dYnK1UMw8UDIkbzMj1fPB6zD+rKzhyaqxJn0Y
	d4bgo5XtAg5WusDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 54F8A3EA61;
	Fri, 21 Nov 2025 17:58:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +ExXE1KoIGmOYQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 21 Nov 2025 17:58:42 +0000
Message-ID: <38461f6f-6e47-49b1-90b6-1649dc39d5cc@suse.cz>
Date: Fri, 21 Nov 2025 18:58:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/16] mm/huge_memory: refactor change_huge_pmd()
 non-present logic
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
 <451b85636ad711e307fdfbff19af699fdab4d05f.1762812360.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <451b85636ad711e307fdfbff19af699fdab4d05f.1762812360.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 075C24000F
X-Stat-Signature: m3qsq3mmaeff3gt3gd1rkxjs4ipt8q56
X-Rspam-User: 
X-HE-Tag: 1763747924-532177
X-HE-Meta: U2FsdGVkX1+HrLKK6A8q8pJSsZ+Cd836CRE2sof4KLvwhd5IDTpCPHd7yJUsb+y/snU5S9R3HLdBcdfcXRMG68mC9vv5dYol8idv19jTSmssNaDu58kyehW73+sya7AoqOQcD5AHuUazl/qkXtaXMQHhlASef0xswvx529G5j/sxIS2Px7wUk4L/YfCy04KaGuGhZNI3j+qNQdTpDP2xFDQB41/Cw+SaqwrfgtThPLxzBe3Y4LOjH/wKlKJTYxh+RhlDZiA1WM9pYYerG0/Xwe1OOi23D29RopHj08juQ6LC1tbtOIhyn4oqOiNEPIPxujp/szhkX+A986Ytxb518fKiyRfBelBMAJBRpWBaFEmrAJdIePSwhvPucA1kb0/D0xVn3ARUVvxByObpvXJu5VO9pjN6tSDeI5Gu8uEnFhbwzO2jUK9v8fCjxY9/6aO6Njs/WF8zX+Nlt9jmtilff1LRb667z1T535j0pYpqkn3HciXyvVuaKTH2Sm3/9UpCAyEHMMhpODoxPxgmrur8OAxRaC/HWwXvLzyd19+5qpD+41NzqUj1t7lNt8N5baiAkoKZEpnPVLWoysOGQ4WhzFD9JT6BpEu0YxzlR8ffI2rCj4Mcp3vQ1JFxe1yDYzpZtfUllrkkQvSphLH2jczU7UjMEikxHC7qsxCsu4W3efNBgswQwB3OmmIz2GxNk6tpDFMyneZuKhFwOan0157V5GNZONYQ1dsmsGk0jw2U9iESNWOpGEF7s7K/IIscRNXBVBr5ddRzg7W4Xxey5W5pYyiPFlSlw+NqqqfjlTeO0Rl5Xe6xV785rpd/Yp8EQPeBJXZiDwfo8gYskzH68EBK6e26SybCdHu3TPDsabRrdnX/+LILNI83WYpi7599beXMw7KBIjRomNCWW2lSrEWu1XywTJfKnUc3R6eVLoT0EdlHve6VG+NP74DmId7+v1d7/doQf6NU7T/j9yvYxsg
 xl7uQECF
 elJ6L3FNbH3Ba2Wkb15ISpEqWVl1oQYB6cE7UuXTD9Ugfi18dlhtymVvZo4ZzyO1SvSk7T6N8JR1JeGCIgQWz+dahRpbDgdCCzfVNoql6zcwQINnrZhc8HmPgOdTTa2o9SzJuX73k3AkhnTy+QpMe2tPKjE75n8ES8v3THXpQS7q7A6+of+fezsVvI6SJ0v+1BRxQhrk91q3N3N4NUKL/GnBtt4SGBt5yOMaQW7lB7/ILcC+s5ibxG+vdgGuTUn2cifPUbEdx8C9YDHhIN3m9pnfEldCmqJGL/4BUapyrhY0oIIFBXhdvt+YnO3dyog/GKdaHoIcKp7CLia2A7VRI1mh0cSP7QU9cfcOVGbLpLfG94xF3mFhsyO3NOc7KBQ29vUhYXR8ljwcV5xyI6NtVe55PmlYpgeLUMfwMFvo1VRInJWk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/10/25 23:21, Lorenzo Stoakes wrote:
> Similar to copy_huge_pmd(), there is a large mass of open-coded logic for
> the CONFIG_ARCH_ENABLE_THP_MIGRATION non-present entry case that does not
> use thp_migration_supported() consistently.
> 
> Resolve this by separating out this logic and introduce
> change_non_present_huge_pmd().
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>


