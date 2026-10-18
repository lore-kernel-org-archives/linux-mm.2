Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A4EFCCF2C4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 07:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE3FC6B0088; Sun, 18 Oct 2026 03:11:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C94956B008C; Sun, 18 Oct 2026 03:11:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA8FA6B0092; Sun, 18 Oct 2026 03:11:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E5876B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 03:11:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 06BD61C3C30
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 07:11:26 +0000 (UTC)
X-FDA: 85334876172.12.C392D0B
Received: from mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	by imf06.hostedemail.com (Postfix) with ESMTP id EBB90180004
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 07:11:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LYLyWErn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.175 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792307484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lGb4nruPMj51RONlIa9w9I0Qf0y/WffyQUyIb347g3E=;
	b=QnnnZAR/PPcYrFEBVuXRLvp/ACOoAz12NWD2Wqznra0FDNWBPrNFjC9br6+jE/Y3A1Y7vd
	5t1OpVA6+u9Y0EGveBiTUE3FMOdjkAClydSFtHplQgX5U68AAyZGXsXdedzqRs9WeNToNL
	MSJqWNdMBvc9fJsNCl0eEOSUY75Sd00=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LYLyWErn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.175 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792307484;
	b=dyBUD8f5I6ChkCmv1phxyR0kXxJbfTr8n1lVjDwCLIkN1RCFGICKOpd790Mrm6myHq1iaM
	0t/lv1bFKbQvSIy7RqawbT2otbq0KfqbAT5aUR51A/wXwivJZ9M4HKbXmrMjZYLk6veSwW
	Beq4SThVO1kDa/06hHAVGiJou+bzEbE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lGb4nruPMj51RONlIa9w9I0Qf0y/WffyQUyIb347g3E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792307482; v=1; x=1792912282;
 b=LYLyWErn9bNn7Rpo0VTkVWYu5HqNGmQcbWSCIkdQcW1Fvf+nsoVuPXLgsHzTboBz1CrxwP4t
 NDNbcI+x667eJ2oEKWBRpdkMQid6XUTidBtv6oazh34rbCJt0m64LbbyC/rxy2jh2aQ5INlJ2aO
 Lv34iDGRXXdh/ZG9rWUhCe8U=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 970df750e1cbd372;
	Sun, 18 Oct 2026 07:11:21 +0000
X-Mizu-Trace-ID: 970df750e1cbd372
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	muchun.song@linux.dev,
	osalvador@suse.de,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	agl@us.ibm.com,
	mel@csn.ul.ie,
	riel@surriel.com,
	peterx@redhat.com,
	kas@kernel.org,
	rppt@kernel.org,
	josef@toxicpanda.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	mason@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 06/10] mm/hugetlb: fix endless write fault on a leftover uffd bit
Date: Sun, 18 Oct 2026 15:11:16 +0800
Message-ID: <20261018071116.20342-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261015-urgent_fixes-v1-6-42796911043b@kernel.org>
References: <20261015-urgent_fixes-v1-6-42796911043b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EBB90180004
X-Stat-Signature: 9os3zjo6kd4ex4rwkg85tymuoph6a53b
X-Rspam-User: 
X-HE-Tag: 1792307483-219295
X-HE-Meta: U2FsdGVkX1+3++1igYnCashY+/c9hxXISYsR3PryImb37ETkuE7hNu4Pij21rzL5A5Lp44mQsGDGrLANc7obHdnvAvM8/uKLk0GITSmPCs6RpEIQgsYi+JEYtw80KL0hv+LEpnQaH9DwlP6WDBMimgUoPGQ+GwKXxdUU3t3Fvctx5qSP+VqtK90U/EPvPptwd53iD20nizKZ3BcVpoN9BbAPsHtYAFPXqYVV8/YDKqhpUMbFkkjytOFJjBCXIjcZG/eyNZ0zSU//vaVbyIJ9Qcos0Xvf60b+83mIizYUgMULr/1L9Tpg1NOcEFV9E8ZM4OOn4OXKxJlzcdQPQ6IbQQ3eT/i8BpTV4vvjwrlyxDX2crwLExnXJj6j9UI509ChoRqMXHnI82wpbDb5xmqk45unl1bkz4QA/s+avyMaKX6kYvIxUdEqb0PLgtrJJU6KCoyv3R0Wi9cG/Zjh14TdwZ6KPdpS2HHYVZGM7yTEHLOVzZyIZSGUJjDq1FROoqe/FUizSK5LIKLf2g2Kc9hHnVi3l2QuYftT4ogCbPeO7AL3JX6kZBTYFYQoo+B0YChKiJOz1fH87+NIUL/x33f4b3LTQ98KFzmc41VpVHzHhwdXrx0Opy80YZ4j9wur3kQbRK4E5dpPi4uR4hL5IgPfLoHqbpvWdOMwkgtU8twhTx+Nks7PcDOx75Ef/jQKewfiPJP5HRi+ijDhhibG24H3XPibnek7J1gn3X6GSAxKFUBV66IpNm90KJJRn1gN+yjMpS+HZUf+n4fW7pBINH+k3Lz4Nb8xMppYMz67W2dSOqumgZWT6TpeWZqx7r/848SS6ZWA97jWpRwHnEmITkqb0X18mJbShKaMFa4Vross6jqi/RwEuSQbHB7IJuBzr0oC9MfEQ9tDdN4jITLTqoAfmp2rnlUJmcLU8ONxmUmPH69kz7XVD/fTAnJxfSzI5czHu8LZXZy6UEMrYbGkOnF
 qPyO56eH
 R1WVSW15DZPb6cs8EcuM1VEk8fx4JPF3ROisWXXhlmv0HberK3ipUd0VLyTfwIFitL/JDb4Njw21tQiSwmwyz6LIbJ8F2NrRg0vPTGGYD6bzq5EhhaxWmyS6dYqRWjDPBVjp+hsRSszBx+3wyWAvAh0DRVIQ65atqrVFekBPaZjkvPcQyPS+0jOYjEop6s+meRuAmJYB52kK1ZpZjfORFqIxtjTDralyBWwKKz70eux+ksOBDwLauoZnVZeuc9JGJt9dGYpduR7pDSxvHcz3yGPREahGa2rK+/PMhpLcpiBfw4Zn7+ZG/kOQutdaoEt1+fYR2/Zx00LTI6fGuyJdiYPWlDqo4vhcOTlne3G830cOZ3cAwwIlaJjwat28bjuI0PyO/cXK0kuk1d5c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Oct 15, 2026 at 06:07:12PM +0200, David Hildenbrand (Arm) wrote:
>From: Josef Bacik <josef@toxicpanda.com>
>
>hugetlb_fault() resolves the uffd bit on a write fault only if the VMA is
>registered for userfaultfd write protection, and hugetlb_wp() bails out
>for any entry with the uffd bit set assuming hugetlb_fault() has already
>resolved it.
>
>When a read-only hugetlb entry with the uffd bit set is mapped in a VMA
>that is not registered for uffd-wp, a write fault to it never makes
>progress. If the access comes from the kernel, e.g. read(2) from
>/dev/zero into such page, the task spins in the page fault handler,
>ignores SIGKILL and keeps holding the locks taken by the system call.
>
>Such entries should not exist, but an unprivileged user can create them,
>for example with MADV_DONTNEED of a page protected with UFFDIO_RWPROTECT
>or with UFFDIO_COPY in MODE_WP racing with UFFDIO_UNREGISTER.
>
>Clear the uffd bit when the VMA is not registered for uffd-wp and let the
>fault proceed to hugetlb_wp(), like do_wp_page() does for regular pages.
>
>Note that a FOLL_FORCE write to a page protected with UFFDIO_RWPROTECT in
>a private VMA that was made PROT_NONE now drops the RWP protection of
>that page.
>
>Original fix generated by an LLM and sent in private by Josef.
>
>Fixes: 60d5b473d61b ("mm/hugetlb: fix uffd wr-protection for CoW optimization path")
>Reported-by: Chris Mason <mason@kernel.org>
>Cc: stable@vger.kernel.org
>Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>[rppt: massage commit message]
>Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>[ david: convert comment into a TODO ]
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

LGTM!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

