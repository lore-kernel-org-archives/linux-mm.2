Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECF4BC61DFD
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 00:47:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A63BA6B0095; Mon, 31 Aug 2026 20:47:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A14C26B0096; Mon, 31 Aug 2026 20:47:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 905066B0098; Mon, 31 Aug 2026 20:47:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 661F46B0095
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:47:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F0E5A40140
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:47:21 +0000 (UTC)
X-FDA: 85163354682.30.F253A35
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5DD8A1A0006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:47:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dMFJw5GD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788223640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LXWsMKMXC2X8nJTY0s4XiZNYUo4FSqt+7Ykdy8yx0Sk=;
	b=UT/zAjXzTjjOIJuCh0ZxQLvfhnAI7NqzRG87b0CxQqS5dB0yIS5aXRAuVF4KzVaPK58wnF
	Hvd511JmIZs4d2F5KI4CosEfYMoQAJKfV4TNd1b5zPGPjOidX99LwmZCxOj2Vbziv+VP1/
	0ExCuRufPyCowA+Iw/QQoYJzS+CTeUM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dMFJw5GD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788223640;
	b=LD/McbIs26j2/MmJd4MCK19mn1kHc/UdF3ByjUaTbm+01I5Ks429u17o0kwn4ht/0HKyhK
	PE5x1AmYUD2QvWISJ5Tgc9VLFiCoeGTNv+4a0bQpqBgRKcnatYsazHBPNKZmrZQ6vB/8RI
	6oMe85TKwwWMbF2cHf4qYb3iUlH0gpU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A9CC7407E4;
	Tue,  1 Sep 2026 00:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0112D1F000E9;
	Tue,  1 Sep 2026 00:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788223639;
	bh=LXWsMKMXC2X8nJTY0s4XiZNYUo4FSqt+7Ykdy8yx0Sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dMFJw5GDOK1LB/kthZUOEnAAk5yFHCpRNEXKwFWe0eTxnlnOlwLPa3YCrwpIhFsHq
	 AZU1yChW2iRMUoqy6emQhhL1HcXbYi4vQS+HEsm3bQnll0mx7E654PEKh9wQhK32HT
	 8I21k7vMrAcbErslUCMzEPRID7+x0DTB1sAqR04EM2ytotQM/oj1Z+oPKiVnkCKRhi
	 H+t4LhO4IUfDQnUF0jSi70J3kX06dwGYXEwSOOGPfAGF6CgWzjRfquJ6Zml7WZDUrM
	 GlVw9AP/7sBk58FlJVCULgBNlaoKs9vQ4947f8FCFGA7jOAoRqkBRIBuUXiHkqJjz3
	 HZN2hkvu8S5NQ==
From: SJ Park <sj@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Asier Gutierrez <gutierrez.asier@huawei-partners.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 3/3] Docs/mm/damon/design: Document hugepage_mem_bp target metric
Date: Mon, 31 Aug 2026 17:47:11 -0700
Message-ID: <20260901004712.89669-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <107dc6ba-697e-4b25-ba3e-8ce2499cac9a@infradead.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5DD8A1A0006
X-Stat-Signature: 8the3pec75drrxo4b47ahagdbfm9b7r8
X-Rspam-User: 
X-HE-Tag: 1788223640-982278
X-HE-Meta: U2FsdGVkX1/7/cqVQ5fKEAMxiuLOYhmwJqJCZfq/J9fDg2iWF0YWP/yETP3n16qdieX5RM7KvkAzP2JpfJ7QwSwwdP7Dx+f/DYI8vxCPircoolnwyGwKd1Nbol/A7fS8vjRnvqxV/0jIte8/wa3LNiD4Vgiltnm39yQu2GNIe5aUz2MmSY2oJ5Bx8+8fm+OwbHisfOuNBjAx68Sy+8IbV9y12temHy4V8OZp48Q0UJtc4EyPeOpENNplLOtE4iRLJHpZdRg7wxk/+h46UTJ1D58J4Yp/S0zBQ9a26Ss7AN4+3wr/mF7DUmQaku1wLFJ6E6LkIWL0AhsalqCVhkDa1wF5csm5RjxT1hNOBpJFQMdQxbuxUqA0EAQmarIXHIoFlO6I48Fzm65q6D5fU363NSyKNnAGvgQqNNgeyuNdFVQtlKNPpdeC2WyQvveZZmifsBeHmVryv0rSQq4PomX3jP9LXvITcd5GzMcXMfF4agDSGiBGd6BCD5sOO6y8HEnVRD3vGkucd3rlLkJZpnnRqgKT29Mvga3B7TeTR3D5tQjT0PMwSNKakOxdFBb9MsN2Btm4QX6/WgWCUpYsvIHiGiPjLJTWcBn5X9d3Jmzzdt2PT93O7frPypzUwm7sL5XHYyi6zTAUBHkpaLEVnmUIJqTUJiW27DvRmUczjXmWFT3n8+wahGe0jMBNvpgeN/zW8HhQlZl8wk2RkdjW+IeOCVrDx34wlIcdeCeOvL4RKK70j4WOK/kMY9sp3fk9BnAuYeC0j+uf3NzdBiZbhREMb2lPsGipekzcLqxZ0iDYFlGJKJQcbuPAFEyWGMIEzal8KhVx4OJoA+8alhuxZHxMKFIjaj3DkzUPNaZ7diUiJuC5YmuBCciv1MLPrvKDhmkCWNCu/ZXMVDVo93KYikUDsjosmrLp4QNAI2pvn+RsHmGHC5GYMZcMqsj6cvVeARZgnSfL5jG1HACzH0aRarn
 kvUgKKTr
 oAkD29jyyiJq/1XItyWjgx5OROzt4bIsca1oAf6tO/LMIiN02rStJ8gSQZ+EKETehTXjpnQ0cgL9JSBc5nTl/r427YMTysdc9Q/sDBnNcrUYnAG9hefMEcMX/boZgAjCq6H+flRu4/dsPqPIhKWVDtYLyDQy3M22EXtsJTwZluZDIIfXiltiRfEm9DDpEGy+gPKjQ7DYOoRCt62yZzuaPBK+KLMavgjkubXnoWPxCgFyxB0Ji/0bo/CzSlhq1aNOZ6UOTf7iudrv0XxWCh9rrJbgLL7BAdsOUpnz4j75Zruc1VIxSWeueBiZNzjE00kDDk8ZyoRV2nw1v7f2WYaWQ18ZulI3jKXxuD5r65ODE53moT8V4wZ+1DwrcDPrQhbZaFjLQiUVosZgprIDLPmmIN+eNwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 13:00:26 -0700 Randy Dunlap <rdunlap@infradead.org> wrote:

> 
> 
> On 8/31/26 8:45 AM, Randy Dunlap wrote:
> > Hi,
> > 
> > On 8/31/26 7:47 AM, SJ Park wrote:
> >> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> >>
> >> Document hugepage_mem_bp metric exposed by sysfs.
> >>
> >> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> >> Reviewed-by: SJ Park <sj@kernel.org>
> >> Signed-off-by: SJ Park <sj@kernel.org>
> >> ---
> >>  Documentation/mm/damon/design.rst | 2 ++
> >>  1 file changed, 2 insertions(+)
> >>
> >> diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
> >> index aed6cb1cf4831..a8c163475ef2b 100644
> >> --- a/Documentation/mm/damon/design.rst
> >> +++ b/Documentation/mm/damon/design.rst
> >> @@ -713,6 +713,8 @@ mechanism tries to make ``current_value`` of ``target_metric`` be same to
> >>    bp (1/10,000).
> >>  - ``node_eligible_mem_bp``: Scheme target access pattern-eligible memory ratio
> >>    of a node in bp (1/10,000).
> >> +- ``hugepage_mem_bp``: Total huge page to total used memory ratio in bp
> >> +  (1/10,000).
> >>  
> >>  ``nid`` is optionally required for ``node_mem_used_bp``, ``node_mem_free_bp``,
> >>  ``node_memcg_used_bp``, ``node_memcg_free_bp`` and ``node_eligible_mem_bp`` to
> > 
> > I've looked thru the entire design.rst file and cannot find anything telling
> > me (or anyone) what "bp" means.  Explain??
> 
> OK, I found it on the internet. I still think that it would be a
> good idea to say "basis point" one time (the first time that it is used).

You are right, and I agree.  I will add that clarification before the next
merge window.

> 
> 
> -- 
> ~Randy


Thanks,
SJ

