Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70A02C5AD4E
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 14:25:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D1FE6B007B; Sun,  9 Aug 2026 10:25:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 083226B0088; Sun,  9 Aug 2026 10:25:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDB346B008A; Sun,  9 Aug 2026 10:25:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C8DF36B007B
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 10:25:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4BD50A03F9
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 14:25:44 +0000 (UTC)
X-FDA: 85081954608.13.6401706
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id AC8F840007
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 14:25:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VMy+Lg+b;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786285542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+mUtOVgyzqDU/k3Pbcj2HKLEv+mxt8OFSMeHs/bRNlQ=;
	b=6PVL+4xxkmIlpL4Rq14yWGEZ2/Ghb0D9GrS/b7xnu+TgNRxmlH0HwsGNn4vjJ6iqozOEbT
	Gi4wAyubwP2fCTqCN+qSwN4WNtntkBEHi6gjsXnqjhV/HMRwffkU37VlINCLKSnnBSVOr1
	MUaB/Vp1Ej2YHaCkGyEYtsnb3bmalM4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786285542;
	b=Txnary9eawn0fysCDG0g80rxfBLwh2Jl/0TGUWm0cCoA67fCXhbX05iE1dcteNMiw7kNFS
	BaCN/t1xSwrqxnzdiPsqku3guJwLAdDU7Q8RfLvicjtkru/RQVGYVki5yqZ5MYsuS9FqdY
	jm7ct9C2ukKCm/L4P4ZvTfyrhcbhaRE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VMy+Lg+b;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F0A643D25;
	Sun,  9 Aug 2026 14:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4AEA1F000E9;
	Sun,  9 Aug 2026 14:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786285541;
	bh=+mUtOVgyzqDU/k3Pbcj2HKLEv+mxt8OFSMeHs/bRNlQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VMy+Lg+bZfaZP8oorEjOei5gN0ErIP9YRQxC8p71GVD4YUPW8rQ8czAeQETBAcUee
	 sBxZHH+PJh63GSlYQmHUww4cNgRqCvX3soypbcIzYZ54s/nef2TZmvR6638Vvl3Kpj
	 liY8bwwM8rSQ97DWoGRwzL9CN3YeVH2y2+ddaXVPxTJsZpXb2uy3mhC/bq8d8q/IgK
	 p3ceXktYG5V7bRYWW1JuHaC6HFUkOUXeb4FrCGQmAapAJawX7J7grmiXPPHamPZUyI
	 PW0BFkZGq470qpfMYuiFI78hJAMlXLXV9qsU/VVoepqaolqLWZnX/C2lEPFZPYoXDs
	 WuuXAVtB0P7pQ==
Date: Sun, 9 Aug 2026 17:25:34 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jianhui Zhou <jianhuizzzzz@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, peterx@redhat.com,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	syzbot+18d274a59b87cf80e86d@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/userfaultfd: clear uffd-wp PTE state when
 re-registering without WP
Message-ID: <aniN3qiwJkUOkmaD@kernel.org>
References: <20260601082609.170076-1-jianhuizzzzz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601082609.170076-1-jianhuizzzzz@gmail.com>
X-Rspamd-Queue-Id: AC8F840007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: tqcq833gfb8xu4qg8pkw3adus3hzuqh9
X-HE-Tag: 1786285542-101094
X-HE-Meta: U2FsdGVkX1816LH/LGEAEce+gs/69bQ/2RrKP0ns/yHe5+F8/Ecqk7K3mnvWlMIO1o/DUaqaApN05ZlcXPwSq+ixtN0p0h7T5/A48O2faHmBxmnZmSi5Ecq2RDg4pMqlqNg27P+2rP2QHLMU9n469Cadv7PO0cfEAidzGCR7zmIpogOqUoxAeNTr3lRxHQoFOFZ0Wy8LjKDpYeURxleeNqWfFHyiILtW++OGgFa0NdYn2ZhFUoZd9bhp9vxAuEVERMO5nqRb3hLtlcJSHxe/FvTXMOzn48eA570x3/PHEAD928b9ATNfeF85prRf9KKt3nSo1yr8pgHtMtXbVzV9OJ0UxGio48MU69ApKyvt6XTqkHKkePd+G86bEvAYdI3nlYggnWhDtBW++JWYO1M+3haf54R8emmnneil0ugD5B9rCPB+FFfJysYhXdxoUvQtSpF3t2V126v0EF1VAI0jYP1BhtVfHDJ7LIeMB1krrrwXNkf5QXUiuDdOuY4x2enPpWBUIdCLDyX9YPKuh80TIdImiJwuLabNlYImEwzLVela+Ohi5oYh6Su8OPVARzEuzRaU177bhygosCGE+PuDyFTUslbEwdEgWWJ1gX0rp7rwNa4Ce4bUxcyeCrtQU6Z2XXH/VYR4SW2Q6xPjE/Qmuni193AvGzSFBqvf5cwrPBxYwr8xm4jn7cfAi+WB9oWPA8sZa5c65JO3ki8B7rSzHg1k67d6BK1SD9PBYuRppg5Zgcy8MtMyye535kEfH+W1lwrebEvWqmC95snNwkNef4uzCxpy/Wt26xY4ZrI6rAnt6KkIOPrKvcY371R/R6t1tj3fk6NjqatIj7UO+OWPqFHhWD1KD0pldsIegKokOgDK7aOetscqVBz2tbl9o4mVbSmCw6zmwoM9ZAgazGjaE3wGjW8rlti02jMc5K8PAvmy3Op//Tn6o0NFW/fbe0lasjHYc6EaF3EZ/QHq0QZ
 DfEKQ2S6
 194mcsETvU7gSzHXUtnW0AbzXh4EqlaIr6KG1JkWJL2F/pNhhBcspqBagjbazSIFiOmq1fe+i27+quMd3nUoWKt/iMV4nDWFDzT97zEB/CPt7Frsg/YFBO513sGCcwJ8tkeKmxRh1JbdwOdmhymZuw5mu7MURybf58zNZwABezqm0pNOA3mu2BYu+XWBIusr7TzGRSBaSruRtdgHnfG4XkbKMET9jmZJRUjwiu2k81Tm+sMCsHWD6xOoFXL1ygVCBUVRgtOd4m5QEErV04JMEDGgagw3LFG2/4ugKoArzu3dfaE9Xx8Wktl2g+jl/xFi/W6Od7BTqozeLT64o8z1MEr8SwUpMr6Du2WIyFNsf5fRcRFekNWWvvy4Dvp4x9QNxZC4sGwnd+fcXYu8z3uQh9YGcmAdkItynFofaIzr5DnWt/NtDHkvJVcQf49o07xhbZ1jRucbC0wt8Cx2IhLSIzNUC7OmP+hyzdGI+PEga9+KTNoggBHJ4L5MxJyicgrXRi8K/YbCA4TNsLqI//IXBTgpKtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 04:26:09PM +0800, Jianhui Zhou wrote:
> UFFDIO_REGISTER can be issued on a range that is already registered in
> the same userfaultfd context, replacing the VMA's userfaultfd tracking
> mode.  For example, a range can be registered with
> UFFDIO_REGISTER_MODE_WP and later re-registered with
> UFFDIO_REGISTER_MODE_MISSING.
> 
> When the second registration removes VM_UFFD_WP, the VMA flags are
> updated but existing uffd-wp state in page-table entries is left behind.
> That stale state can survive in swap PTEs.  On swapin, do_swap_page()
> restores _PAGE_UFFD_WP from the swap PTE and can then install a writable
> PTE, triggering page_table_check:
> 
>   pte_uffd_wp(pte) && pte_write(pte)
> 
> Handle removal of WP mode through UFFDIO_REGISTER the same way as
> UFFDIO_UNREGISTER: resolve the per-PTE uffd-wp state before dropping
> VM_UFFD_WP from the VMA.
> 
> Also make the same-context fast path require an exact UFFD mode match.
> The old subset check treats MISSING|WP -> MISSING as a no-op, even though
> WP mode is being removed.

The recent RWP changes prevent re-registering to the same uffd with a mode
that clears VM_UFFD_WP or VM_UFFD_RWP. See commit 6eab8f2cc646
("userfaultfd: add UFFDIO_REGISTER_MODE_RWP and UFFDIO_RWPROTECT plumbing")
in the mm tree.

Andrew, can you please drop this patch from mm-unstable?
 
> Fixes: f45ec5ff16a7 ("userfaultfd: wp: support swap and page migration")
> Reported-by: syzbot+18d274a59b87cf80e86d@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=18d274a59b87cf80e86d
> Signed-off-by: Jianhui Zhou <jianhuizzzzz@gmail.com>
> ---
>  mm/userfaultfd.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)

-- 
Sincerely yours,
Mike.

