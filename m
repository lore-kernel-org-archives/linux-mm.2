Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAB75606A327
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bxyWOX6X
Received: by kanga.kvack.org (Postfix)
	id C5E616B05B6; Mon,  2 Nov 2026 20:41:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C362A6B05B9; Mon,  2 Nov 2026 20:41:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B73CE6B05BA; Mon,  2 Nov 2026 20:41:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 967466B05B6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:41:34 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 26E47120307
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:41:34 +0000 (UTC)
X-FDA: 85392105708.08.9350AC0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8E62780003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:41:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bxyWOX6X;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793670092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EFfsUw24ICsmnAL75V/w1w9LO9fCOi9ofFCSWn0tGhQ=;
	b=aflNQE6+f0vjwDSkiL/aMicEXPycmcz3Lhor7wC6CCc5b4n5qEBARpjdud2GQwfeAeaKC5
	BjH4saM6sSmcYRCrJ2XXdKL1ZrHrTkHA+oa5n7FFVK4Aozl5U9QT6G76xVWJwD48vRglQG
	fyw0TSXMOILqjl4i5dOCjXnUWFoGn3s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793670092;
	b=TZ3I2J8nhy9LOJPciLzp6usVz46XuaXKpkxj+3HfyhxKwRLBQga4+9V/786raIIivRn5K6
	QCJM37sedX1KHhBw4UC/pvUWSkHvuSzdxRPiqQwypM+PhhthLTnzwxZfJXFzS0xHI2CDe7
	9EU10ePs01RmzSJ/D1v9WSB7qTdGSQI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bxyWOX6X;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 113476022B;
	Tue,  3 Nov 2026 01:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FBD1F000C1;
	Tue,  3 Nov 2026 01:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793670091;
	bh=EFfsUw24ICsmnAL75V/w1w9LO9fCOi9ofFCSWn0tGhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bxyWOX6XyQ/qnDucB3bGiC6TJRCggvC87Gb8LL7HDwTOvv6P8UG84knXubYWSvcJ6
	 d1WyQju2KmSIpkWzU1Z5tzLWP84prqOyqR5VYg9Psg19vLZGvGbRQwe3pwJtACet2u
	 qqHgKSGkQun1iXCXQ4knBTmhpZKYp/C7NDS7PSPBtn8plsJ0/uafQJJbmXkcpQLcKT
	 vWKYlo1JlnEUoy8aa4CLUE5BDiU98kYtNGA8hX91ZSgZUmjoiZ5XCjT1nQbD9VBEK5
	 xnt0FrVQ72DuFhGAf0NXmq16ADHmCwJe67+SZodec020ldjJfzG0qZYZyzWK5soaXN
	 FRV7zcEJLck5Q==
From: SJ Park <sj@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: SJ Park <sj@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] mm: remove find_get_page_flags()
Date: Mon,  2 Nov 2026 17:41:23 -0800
Message-ID: <20261103014124.94701-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102-page-wrappers-v1-5-e7280bdb31f6@columbia.edu>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: oz4q163gyq35m6bo9qbgrdwrjdj97pqo
X-Rspamd-Queue-Id: 8E62780003
X-Rspam-User: 
X-HE-Tag: 1793670092-561103
X-HE-Meta: U2FsdGVkX1+52PEwrjxYOWh43GhATLd59RR1TJvWuFoMw5V8JPDHC7WX/Se6svx+jzhtPAAElW35x0BDM80ow/acrCFoA5L0p6ecUvjGdN+CsDBP8gunXD0oooJplVrc9+DcdKH+AyeTwrE0/OVPbnlXR+srVeK40AlKOXD7RfmREnzl+f1JlUZzUfmHSYAoE3XERtW92816bxtnuvse5dN6T3AguUy4fyhSq+Nk5jtsHLDAL+O5wYlsSec23sifc6tyANLXi39HV0KohOokMYuI8+WIdUYDoTGw19112mXTcwVFlWM62GPO/erZHZccDzYdyK1qB5BuOFCNneEW1DOD2YiGvezMjWaXSo99yZ1MNTJ2oUO+k7DXoGRvg2ok6D6XS/N/sp3wej6XyRemkDumTkat0aUkRHCWzcVxeqhBW70RaV/RmcgrQ2f9+9vL1giud1I/lHoXNHxtoIBidJL5oAvStB6+kL1No0D08I0ORf11u9sMYFuykxdKo1svDlhvXaYbmoYYR8Hxj+iTfiAXLRSpEbkPsHlwqxjL6fQW+4Byb3CwcRsLPLYJn7KyGTqLo3S6HYWOjcbXf9rWd/vCQ5ie79GiJKXgBD7iMIM6ZR4vaqY0pzChFGd1WJs+W6v5kqwPUy1vgdrOch+IwdcVMtfu9cWzXx+StkVUUbJGgrA/p9iJ80WhspYtTTMzZwwr/cpxSTKaUdO5WFlxFr0XBHgq9rQ8XccSmoeEuVcJlXwc0WW8XCL2V+s96m1LGiYVleehNCbEcNhxNVeBGGBpMPF7xoZM+f+wNYR7ZV7Gq3HHoRbdS58d3S7lHAoJJQ44rVMvcWkNHF3XUTe4WcXWR39nNjaASAxvWNG5EGNk6xVJqBAitSOFDlm91z9WjRjXo035MZZitctIQwmXlSoTjMSJiCgTXbTeszdkXuCWAoS4Mn30mDAemwthR1X1Wh83I+jmxP76S73prez
 mUWeDZ4z
 sEMWedp26OM2XfXREwrJ9lIW3Bp2lW0KHSeyKIz8/cQIAzx0q4sSHeMKbrYr4BjH4anUmYsCI/PsAeyCOspK2CWcF0epb8qQWVwn1SyeZdPiCpjn9R2L1jq7j8EkM+y8I9ZTncoSHGlz8Srihj9jPyJmpaJIXly6Q7PGdzUg1V59pf8ImXbWoKQd2eLeRclFqItXXCUnA2WODsoHFYCQDzEpSawNX5YyfY0IEieXyg10tFtiEjkXgqZ/+RuQiZKRAZXdY5pueo/PYBut6l7JdGVpiLWvqFHXqiQpe7zY6FrYWR96XwDzV9TDocT03d4VBp43YudICXNFxoF0O2RhVNwoR0PPWlWf8Bplo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 02 Nov 2026 17:54:10 -0500 Tal Zussman <tz2294@columbia.edu> wrote:

> There are no callers left. Remove it.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

