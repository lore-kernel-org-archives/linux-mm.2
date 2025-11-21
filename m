Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CBFACFC296
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 17:57:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93E1C6B0095; Fri, 21 Nov 2025 12:57:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EE476B0096; Fri, 21 Nov 2025 12:57:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78EAB6B009B; Fri, 21 Nov 2025 12:57:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 638A96B0095
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 12:57:05 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C2D8188436
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 17:57:02 +0000 (UTC)
X-FDA: 84135370284.27.9832057
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6465D180012
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 17:57:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KECmMDBc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1vnXRATd;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KECmMDBc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1vnXRATd;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763747820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bwjaaZRgdo0ekJYuHPCFR92memqv4p54KYShK2kI32k=;
	b=pijrvMeG3X8OynbkyTCeDF7AGor6VSR9XZ1lghq76xVJL2NhlpdJUvy1hg1Zj16ZdKPXtO
	IborCiB50UE3jlUIEPO39ctZt7otZxqdTwNz0NR50P1eQUXShKz7uk5ubwmDXCH5/pY3Pw
	Db+/Ajw/brOSe6bF7Rn2knkeQHmpzjQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KECmMDBc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1vnXRATd;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KECmMDBc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1vnXRATd;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763747820; a=rsa-sha256;
	cv=none;
	b=536vtSJmZvw9CMBGJgpWZBYiyEgLizTuwkvOr8jhORNLGcqSmC6KVCqwlIz62nNplX6KUo
	PgVv7coLT8q1GHcy6P7X5aU1K5k/FesYFzitX0Ta2D2uhxi+ZiQgB9EgLrQas1wGtdxXZP
	Du45Kt3uJ9/Ri/nZGBlh2L1IqHj0dng=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 12DB1219A6;
	Fri, 21 Nov 2025 17:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763747818; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bwjaaZRgdo0ekJYuHPCFR92memqv4p54KYShK2kI32k=;
	b=KECmMDBc6hDhv73MtTWtgoveGDktVN65RXLfJ/sO49lcxmolEC3D2jDlTVnCbmdGohYL6y
	cx7Vk498a7xrxAs3HGbRDVOFN/PAnrdkqiXUhVr+Tqdvz6oBbNsfrYgyfEnrsYgy5KLcCR
	4bFGcSfe9pKvIcXa03uBlACyZ/YY9JU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763747818;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bwjaaZRgdo0ekJYuHPCFR92memqv4p54KYShK2kI32k=;
	b=1vnXRATdl/jG/6uR8JzKY09/0yr4KHhpcrFpNYemVkVz/F12SQMBQig9Nc3Yj3k+vklXJ6
	jX4j+gXFwB7y34Dg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763747818; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bwjaaZRgdo0ekJYuHPCFR92memqv4p54KYShK2kI32k=;
	b=KECmMDBc6hDhv73MtTWtgoveGDktVN65RXLfJ/sO49lcxmolEC3D2jDlTVnCbmdGohYL6y
	cx7Vk498a7xrxAs3HGbRDVOFN/PAnrdkqiXUhVr+Tqdvz6oBbNsfrYgyfEnrsYgy5KLcCR
	4bFGcSfe9pKvIcXa03uBlACyZ/YY9JU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763747818;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bwjaaZRgdo0ekJYuHPCFR92memqv4p54KYShK2kI32k=;
	b=1vnXRATdl/jG/6uR8JzKY09/0yr4KHhpcrFpNYemVkVz/F12SQMBQig9Nc3Yj3k+vklXJ6
	jX4j+gXFwB7y34Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 929D63EA61;
	Fri, 21 Nov 2025 17:56:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xFK0IumnIGnFXwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 21 Nov 2025 17:56:57 +0000
Message-ID: <06f1b371-971a-458c-a5c2-0c7c5d618e12@suse.cz>
Date: Fri, 21 Nov 2025 18:56:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/16] mm/huge_memory: refactor copy_huge_pmd()
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
 <6eaadc23ed512d370ede65561e34e96241c54b9d.1762812360.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSBWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBzdXNlLmN6PsLBlAQTAQoAPgIbAwULCQgHAwUVCgkICwUWAgMBAAIe
 AQIXgBYhBKlA1DSZLC6OmRA9UCJPp+fMgqZkBQJnyBr8BQka0IFQAAoJECJPp+fMgqZkqmMQ
 AIbGN95ptUMUvo6aAdhxaOCHXp1DfIBuIOK/zpx8ylY4pOwu3GRe4dQ8u4XS9gaZ96Gj4bC+
 jwWcSmn+TjtKW3rH1dRKopvC07tSJIGGVyw7ieV/5cbFffA8NL0ILowzVg8w1ipnz1VTkWDr
 2zcfslxJsJ6vhXw5/npcY0ldeC1E8f6UUoa4eyoskd70vO0wOAoGd02ZkJoox3F5ODM0kjHu
 Y97VLOa3GG66lh+ZEelVZEujHfKceCw9G3PMvEzyLFbXvSOigZQMdKzQ8D/OChwqig8wFBmV
 QCPS4yDdmZP3oeDHRjJ9jvMUKoYODiNKsl2F+xXwyRM2qoKRqFlhCn4usVd1+wmv9iLV8nPs
 2Db1ZIa49fJet3Sk3PN4bV1rAPuWvtbuTBN39Q/6MgkLTYHb84HyFKw14Rqe5YorrBLbF3rl
 M51Dpf6Egu1yTJDHCTEwePWug4XI11FT8lK0LNnHNpbhTCYRjX73iWOnFraJNcURld1jL1nV
 r/LRD+/e2gNtSTPK0Qkon6HcOBZnxRoqtazTU6YQRmGlT0v+rukj/cn5sToYibWLn+RoV1CE
 Qj6tApOiHBkpEsCzHGu+iDQ1WT0Idtdynst738f/uCeCMkdRu4WMZjteQaqvARFwCy3P/jpK
 uvzMtves5HvZw33ZwOtMCgbpce00DaET4y/UzsBNBFsZNTUBCACfQfpSsWJZyi+SHoRdVyX5
 J6rI7okc4+b571a7RXD5UhS9dlVRVVAtrU9ANSLqPTQKGVxHrqD39XSw8hxK61pw8p90pg4G
 /N3iuWEvyt+t0SxDDkClnGsDyRhlUyEWYFEoBrrCizbmahOUwqkJbNMfzj5Y7n7OIJOxNRkB
 IBOjPdF26dMP69BwePQao1M8Acrrex9sAHYjQGyVmReRjVEtv9iG4DoTsnIR3amKVk6si4Ea
 X/mrapJqSCcBUVYUFH8M7bsm4CSxier5ofy8jTEa/CfvkqpKThTMCQPNZKY7hke5qEq1CBk2
 wxhX48ZrJEFf1v3NuV3OimgsF2odzieNABEBAAHCwXwEGAEKACYCGwwWIQSpQNQ0mSwujpkQ
 PVAiT6fnzIKmZAUCZ8gcVAUJFhTonwAKCRAiT6fnzIKmZLY8D/9uo3Ut9yi2YCuASWxr7QQZ
 lJCViArjymbxYB5NdOeC50/0gnhK4pgdHlE2MdwF6o34x7TPFGpjNFvycZqccSQPJ/gibwNA
 zx3q9vJT4Vw+YbiyS53iSBLXMweeVV1Jd9IjAoL+EqB0cbxoFXvnjkvP1foiiF5r73jCd4PR
 rD+GoX5BZ7AZmFYmuJYBm28STM2NA6LhT0X+2su16f/HtummENKcMwom0hNu3MBNPUOrujtW
 khQrWcJNAAsy4yMoJ2Lw51T/5X5Hc7jQ9da9fyqu+phqlVtn70qpPvgWy4HRhr25fCAEXZDp
 xG4RNmTm+pqorHOqhBkI7wA7P/nyPo7ZEc3L+ZkQ37u0nlOyrjbNUniPGxPxv1imVq8IyycG
 AN5FaFxtiELK22gvudghLJaDiRBhn8/AhXc642/Z/yIpizE2xG4KU4AXzb6C+o7LX/WmmsWP
 Ly6jamSg6tvrdo4/e87lUedEqCtrp2o1xpn5zongf6cQkaLZKQcBQnPmgHO5OG8+50u88D9I
 rywqgzTUhHFKKF6/9L/lYtrNcHU8Z6Y4Ju/MLUiNYkmtrGIMnkjKCiRqlRrZE/v5YFHbayRD
 dJKXobXTtCBYpLJM4ZYRpGZXne/FAtWNe4KbNJJqxMvrTOrnIatPj8NhBVI0RSJRsbilh6TE
 m6M14QORSWTLRg==
In-Reply-To: <6eaadc23ed512d370ede65561e34e96241c54b9d.1762812360.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6465D180012
X-Stat-Signature: 8b98ur1h16175oiekfhf87ozwj7c1dck
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763747820-814171
X-HE-Meta: U2FsdGVkX19Gj7hW39FzC1Ydsok7oxPBK4HZLGMbYfi47PpX73aHNcVvNWyJQDmFtnF5CgtVktx3cQXQxOo67oRaEo9GCZFnPzuacZrmDTIuMVPLa/gUQEsB6qazf/CTDKIWffgLsiY9b1/hHIqiECwOvFPi/dV9hIbIYtJnKGeZWafx1YerCsOOrAhgU/rQc7t3NPDml/3j2tOHRz3BhLchQ3pVqRH23DRd5X3nwpGAzq1+gs3Ps/ozFCSUaoq0P7+0hAeZg8mdSo5zuD7MzCBP7mYSCa2R+uA1VmJAItvKbmHtJOa2sH0nfGr8WxEjCijYGFiDl/iQsp/ILGBVYqDavA+qQB5D+UIoCvjKIrcbHCasVlljNDshc9AalZsff5UvEMi3AgsiReLHdE5tguiMkQj30Mx4Gq+yXRKDFTSKBc5I7HFmNq71hopC9IGinGtO94NZXxwKA7AqXDIq6jVXwrxCUnniaeWyFvKYv5AXEZadChi/BUaI+UF2IPwLHIjS7PItiWlsDbCUJVSgbIFWavrSke/AIBQnXEJQokO+5Ow8b5vOro2Uc4EsrA4YtKAUn0hfVpJ4MfQhY80LAWVFM4ACbDIJ9CMrm3R1IvxSf4Ubg2gdvbn1q9P+OmqRKaXi200ursYdKeVVbUTF68hNI5StuooAL62z9eRFYbvZvfGfZPj+An8s2PnY9uXnbTEyUJ4ws2JE7Y9Ho8rnzQSQt8BosGfeLz7DMw+jk37r+pX9ktrQtLgs1GiAuW11nLbEOMOlXp4cQk8cuH+wYfukNtfTM4S4EQPEueu6ut2u9hZt/jXhiGCphLI9IGitsEpPQLFfzw+VG/AcBBKIodVC9Pvh/gUewQzCFBA+eh0nasjWfFZ6c3cPP6+S9LT7N5Y5U3tnr0FZl4qtJZvWaRYKRAUEkwrBwS+ou3Iui4hYmT909/DLI5FGMQQ16irJ1+9RFmM/awA9wpq71cv
 LYLVNMbe
 kM3sXk1OpDBaTksEDul17rYtCFGb+j4TkuLQUiGJCkF26ycREEgwGy6kKNyuzyjSITIOYZYIrIOO0QODgqRrWD0Jiq4csMKK4nMGLh9Yfjsxsg0UuYpLJnAX1nZ64rpymugoC9Hg1V8uzB7JCppD8Mg8O2LN8v6pikg6s8hS9PGk2KixQkYlPuyGqiIgakMhLCmDm5R0m/gRBqPLoO2pghf7amZ24yaz4Y3PF0tM+xIXRnD/Ftb28zBDS0xFh/aRQ3apfQLUeUTynJu9m8YsP8fwDhyTDe99dkgGLk+MhtOBRAT6PdbbT341UXQmZgCJTDmp6RJ3ibNPSdwYfWyK3U/v2fMc0DOv60UIuzqgtSLNmzSuXJUg3+gLvr16aNcn5od+Btq0CdcZsJ3hTIOI/4PTOcA1m9NVK6SDh9rQyy+GbyN0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/10/25 23:21, Lorenzo Stoakes wrote:
> Right now we are inconsistent in our use of thp_migration_supported():
> 
> static inline bool thp_migration_supported(void)
> {
> 	return IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION);
> }
> 
> And simply having arbitrary and ugly #ifdef
> CONFIG_ARCH_ENABLE_THP_MIGRATION blocks in code.
> 
> This is exhibited in copy_huge_pmd(), which inserts a large #ifdef
> CONFIG_ARCH_ENABLE_THP_MIGRATION block and an if-branch which is difficult
> to follow
> 
> It's difficult to follow the logic of such a large function and the
> non-present PMD logic is clearly separate as it sits in a giant if-branch.
> 
> Therefore this patch both separates out the logic and utilises
> thp_migration_supported().
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Yeah much better.

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>


