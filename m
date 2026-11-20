Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 502BB606A33D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 16:17:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CC606B05B6; Fri, 20 Nov 2026 11:17:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57D456B05B7; Fri, 20 Nov 2026 11:17:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4441A6B05B8; Fri, 20 Nov 2026 11:17:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 26EC36B05B6
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:17:26 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BAFB8A9008
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 16:17:25 +0000 (UTC)
X-FDA: 85456002450.29.E8D01AA
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9E713180011
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 16:17:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf06.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795191444;
	b=Gf0/75NNT9OA7p26aHDwf6fZ0Ya2v5yr5FdACmml265G2gYhJmWPTQw5FZOPxpX/reUa31
	XuIcT+E0r1ZkII421JuiBjEd54MMgOivngWWbKaPdXZeDxPpluiKSXax6eGvtcVTW2dwsj
	KjZCR3r8sPaPMRBfIjBf0pdGQTnvOA0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795191444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7oWxZkJSIrIvDRuijxJDq8O8Wh3VfFr0MJdwdp0vWdE=;
	b=w0TJ085Zoj23Coa8Q4Wv2GNw6xlmfnujWka6oG/TW++qgfwTtTYQ/uxe+m0JokbQhvaRfz
	7IJisdqPnAwrWpSgYjtWeoIE0in/vMZDJ0mljZWDRXLdRxYiuM8l2dvvrNYG0IBqxS5IF6
	wwTlR6ngolHOqRvulD28A9pvN/BQZl0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf06.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 095346732A; Fri, 20 Nov 2026 17:17:16 +0100 (CET)
Date: Fri, 20 Nov 2026 17:17:15 +0100
From: Christoph Hellwig <hch@lst.de>
To: Luigi Rizzo <lrizzo@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Vlastimil Babka <vbabka@kernel.org>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Luigi Rizzo <rizzo.unipi@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, Harry Yoo <harry@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>, Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Simon Horman <horms@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Willem de Bruijn <willemb@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Joshua Washington <joshwash@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Naman Gulati <namangulati@google.com>,
	Pranjal Shrivastava <praan@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org,
	iommu@lists.linux.dev, netdev@vger.kernel.org,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 12/25] block, mm: Support PISA for disk I/O and
 scrub migration
Message-ID: <20261120161715.GA31401@lst.de>
References: <20261109182533.3594984-1-lrizzo@google.com> <20261120010655.467825-1-lrizzo@google.com> <20261120010655.467825-13-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120010655.467825-13-lrizzo@google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam05
X-Rspam-User:
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 9E713180011
X-Stat-Signature: kd7isk4crpp4ongmfxew7kwdchokx611
X-HE-Tag: 1795191443-747111
X-HE-Meta: U2FsdGVkX1/+MveFpsWCpvu4LQy0RQHJHDgZZ1J9WF41cGsDIhQEcb5ktOHQyLs++VhdLdUlLvufBgTSERFGOJ6w3XkmMJvtaYbki1otjKEUNHDHpqq8rzZhRTEw4s7UcXWvb6tk29bWIEOPgG+3HsonS/QEKerQqhzKht1impqR+GNsPrs4mIQFbC6bzYLETc7Q2ucCoSVnIjKJqgUCz8FYNKVbHiVlPmsfMnQwKjMSC08TKC3YKdvNZPhrG8+/pCumzw15dtI6ppnuQ3lGOqeI5cs9H6Psj97/45xqhjpCYEwmYtPQ6zBNkXYE+v2FCXY9ixYxovKsSbLUl3SGZsh/KLco5/VzieqZKo7oBgCkagJiwqR6eYJddYdjSaLugNiG/bR2L3J0GVo/o6DCfesAlwu3nfeY0oUrmM5jAViSJhklk2xDw7TiK+2Mec5NhdnmR4OyqLQztH/wjuc96qeqOgprM2b0xxziN/6zRbWs+G7cq8q5V6HCPylYfBzXZ45Q2EWEKNH9PaYHcu2pXJyAeQiAuJKMlSkfhLT+aEYmGDAVSc5z+gIgbUp9EECTRUIz7t/XZJ6gE+s+rbcrCLSPnNDX6gbH4hvWGV7fwNp++zEl6uL8EaRud2zJnLx2ueEHuKXERM51oA49KAUpMT/rSkZ9nWrPO0T8Fo5fE3vgMRYrIhj/HCIF3clfNFiBpcfnTyEzMJZxKM7U1FjOhbbKEtI09SK4aO7qzYKNtuSG9pvjyrlfcchZ2rdy9uYJuCIpVfovfXAvmpje21Fbr5kKTqxITIPygI6j3BYqaoevLzdtrWZkrdKwbrkDhP+MEAcrShwJZHTY6NgTY8w+ix04Svgb+heISIWUtM42Cs60ft/tURfTW+Z/A+Gfaig4xKcwG0qwLgmKz8vwlyMLD8X5v/ZOqt5pqfSEDD/zc1NCIInJqHnmgRYNc0HdosfjzmSKCTbJZ7le3U+stcD
 0UFUIgD+
 zFfIDydDuTdYoFsUQP1/WMLKEAgS+AzYbEKq7viZKDrJbqAVS8R2ZQIEd5ZUl8viOlpLwHxqhCKmGNpR7rfYENQrNnEksEJhJSVBgAncyXTRXXDTKIUU26F1ROdmfIwUyjT/hoE9WvaHoJLT6S952oqxSEuoHxRgZLWoIjvcitC33wCKVJCmDsPXwEqzHlQB2HH7qDEkv+S0VeXc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 01:06:42AM +0000, Luigi Rizzo wrote:
> Extend PISA user/page-cache allocators to support O_DIRECT and buffered
> disk I/O, gated per block/controller device through pisa_rx_bufs (read)
> and pisa_tx_bufs (write):
> 
> - Split per-node user_pa into DMA_BIDIRECTIONAL, DMA_TO_DEVICE, and
>   DMA_FROM_DEVICE allocators, promoting pages to DMA_BIDIRECTIONAL if
>   later accessed in the opposite direction.
> - Upgrade pinned O_DIRECT user pages in bio_iov_iter_get_pages(), and
>   allocate/promote order-0 page-cache folios for buffered I/O when PISA
>   is enabled on the target block device.
> - Add pisa.scrub_migrate to compact or demote lingering folios off old,
>   sparse user_pa 2MB pages.

No, doing MM migrations in an (any) I/O path makes no sense at all.

Can we all please go back to actually thinking about problems instead
of generating giants amounts of shit code without the slightest
reflection.

Than you very much for your attention.

