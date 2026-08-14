Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D6DDC5CFCF
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 03:18:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F3726B0608; Thu, 13 Aug 2026 23:18:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 584A26B0609; Thu, 13 Aug 2026 23:18:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46E5C6B060A; Thu, 13 Aug 2026 23:18:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C5B16B0608
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 23:18:31 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3FBCA0353
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 03:18:16 +0000 (UTC)
X-FDA: 85098416592.19.6063DC4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 36E7B80003
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 03:18:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TJz9evUq;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786677495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LsgWn8sG7KwPcJHSK2CgogemlhdZd4bBu7Jx3POkoZA=;
	b=vFJsRoI3Vja8lRFSfncK7ZzUOdpCWWqq2dCh9sgIfh17mzfLmYnrS96JqQkbHTLfu3eldi
	FCMRbqfYDsNUesq5orAzJQo/E3KFOdunUYtOBtQx55jc5pp3x3E92tiXsNy99NGyUKijsm
	2EVou+fAHck+XpySdAAGiU788wDKWdo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TJz9evUq;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786677495;
	b=DPOKAy1urBLVKyOAm/9I0Sw0Wv4PtS5X60hh2kezLo9MVL2GGJoYgqVlJIfjTZG3HqCYCZ
	8HrkEhYW9RS0EteLcTy4t9ohpPBhtgYpGn5ckzWldOUBuXVnei+SlElrBIL/5ItdStqCe9
	NToYHy2SKUvQSIItGh2M1XYVHF+WULY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BE3F8600AD;
	Fri, 14 Aug 2026 03:18:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C261F000E9;
	Fri, 14 Aug 2026 03:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786677494;
	bh=LsgWn8sG7KwPcJHSK2CgogemlhdZd4bBu7Jx3POkoZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TJz9evUqTStazAS2hs+GEFRo2dO95zacLioKESOh/64Gdo1mZOppeX26Vfv9cBonO
	 UrB99vNLxkWx2+On3R8N/AL3lsEZq16lOoF+N/JJL4okKtYbmrQ0QsVpDh+wCWdWFt
	 1Q5CSmAwU1Ebq180oD0vSnTH5Q3hnQ5/jEYmZY89pF+PRiAfkXRw5B81IAo7XkT3HX
	 S40aWVevme9sUAlMQ8D5KJtAOGRdFr7TONuUt/URwsnA8VnjjKMn3KNOU7Fc1PNghw
	 GYt72oh7Kr+c1QikCWm8I6JsO8pRU11XHtRITb5MkIYPTGfJ79sYZwoglCJGL7rNnw
	 MCM3mIEl6zLyA==
From: SJ Park <sj@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	kernel-team@meta.com
Subject: Re: [PATCH v3] tools/mm: add hwpoison-panic tool
Date: Thu, 13 Aug 2026 20:18:10 -0700
Message-ID: <20260814031810.88417-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260813-memory_failure_rewrite_test-v3-1-f9fb6542cbff@debian.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 36E7B80003
X-Stat-Signature: fh84wfk58q1uhn6pan5g8a3hwh9si98q
X-Rspam-User: 
X-HE-Tag: 1786677495-168794
X-HE-Meta: U2FsdGVkX19Khds2Inptz1jv8c78MrmtSWe9WYeCyrV1sjzVWdPMYsiVUeLxHpNaNUmjLBO3HhMeslfwt3UvAodA5S5OYjuPBG4s2I1PNuhcGJWjr0AYbcG6PzgwpbTkNWa6QVuZbRcwt/T6C9CC7YppIW5baxGQ4oHivkZjT90wHwSI/neb9lYquLnJ4PlttDoERtkttUzeTAaG0Hec3ZOn3avHi+asLQrXJit3vWzdP0/q1pLF0ynK2bAAXCB/fYdWOm9TWQ+lhVrt8qB4WdRhVC4Aa9ZjzHHq1SOgKrcLyiDpr/YyM/olHFzu1nM6fhoGKpkYvpcuEQt2hfxnzVvzSuXu6UaiNq18klNLrjFyav+YapkKJLMvFE12rpp0eNLxfDM61XEokTBAYErnvhY7pyASwWonNfWw1zs7MQSGJq6No6jbNv2YjCfdF8VaIVWu3v1bV8nGLmmAss2gTA4AJYRlPgY8DhM7K6601VHNvGhk3O4rtpjYrYpD1zSZyNKwiEskg/O9ci+Gr7pplWK8/kzuhb4bs4CgA417i4KNmOryrXqEAiV6r+C2yxfZE58obomirTVgJhXmLTMounjYcHtjDxWH8fvepbPPg0wqn123nyNymgsqVF6PG6ImsmN+ESlO1hMA46hH336XaWMIWnak8a9qVVJnk6wCFJaFLWIPYG3D1oZ4/e1dQEbQQbMc+JdYtZZJVIOjCAtESlU9MU+yicosIzEDufWdavBeh8QVWencObv2PTH1OXQrjCL6AUK0BXBh/YnVuRKKMZIjpOa22ngnAEMoc5xHagJ1WjKKhb34aulHz7Emmx9qs+nSAVQdPz70qeM5mZpvp941SzpRefpV2RLNNIBeJ85KxEVciIIwnbu2cNEOrMGurSJ+RlNcX5MSw1xE+fSNQsTBAiRL96RAQTWFkr032DgF5B17lmTI8nNrbhdL3YN7UeR5F2tqVCZC30QSOp3
 aCBRECgN
 BII1B7zidTOMreALSXG0G46kk9/oAKDsoYbgBSo8EhLu4UrEF9UUdU7uJzzfmXYvWXfbwg0e4kkRKK0dmO1SPu//DHEBEzQ2T5EXjWgtm7sm8Xpqj9ea48gb6lsT7SOYDhNer/dOeFF4DtMrIA3RY86Pz04XWumCJfRRlarH/VLHT4tOvK8MV4PdxZgcrHlC8pB1VC+vPFlX2LJIMphX7Nbrp9ocaZLFG52NBFEudQSTC/eiVaknlWyMEuEh8wK5a7VdtdfOpnYVBaU9d3tLHK+lW2O/czs3aWhvQAimzW26Cj1Pa30NgN6qewVaKiT4A1ybxJC7NOLtfXB8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 13 Aug 2026 04:45:15 -0700 Breno Leitao <leitao@debian.org> wrote:

> Add a tool that enables the vm.panic_on_unrecoverable_memory_failure
> sysctl, picks a kernel-owned PFN and writes its physical address to
> hard_offline_page.  Three page kinds are selectable with -k: rodata
> (default), slab or pgtable. In all cases the host should panic.
> 
> Example:
> 
>         # ./hwpoison-panic -k slab --yes-panic-my-kernel
>         injecting hwpoison at phys 0x100032000 (pfn 0x100032, kind=slab)
>         expecting kernel panic: 'Memory failure: <pfn>: unrecoverable page'

Too trivial nit, but I couldn't resist.  Why print '<pfn>' instead of the real
pfn value, while we know it?

> 
> In dmesg, you will see:
> 
>         Memory failure: 0x100032: unhandlable page.
>         Memory failure: 0x100032: recovery action for reserved kernel page: Ignored
>         Kernel panic - not syncing: Memory failure: 0x100032: unrecoverable page
> 
> This lives in tools/mm rather than selftests/mm because every successful
> run crashes the machine, which is not something to run from CI.
> 
> The --yes-panic-my-kernel argument is required so an accidental
> invocation does not take the box down.

Looks useful to me, thank you!

> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: SJ Park <sj@kernel.org>

[...]
> +static const char *inject_hwpoison(const struct page_kind *kind,
> +				   uint64_t phys_addr, uint64_t pfn)
> +{
> +	char buf[32];
> +	int fd, len;
> +	ssize_t ret;
> +
> +	printf("injecting hwpoison at phys 0x%llx (pfn 0x%llx, kind=%s)\n",
> +	       (unsigned long long)phys_addr, (unsigned long long)pfn,
> +	       kind->name);
> +	printf("expecting kernel panic: 'Memory failure: <pfn>: unrecoverable page'\n");
> +	fflush(stdout);
> +
> +	fd = open(INJECT_PATH, O_WRONLY);
> +	if (fd < 0)
> +		return "cannot open " INJECT_PATH;
> +
> +	len = snprintf(buf, sizeof(buf), "0x%llx", (unsigned long long)phys_addr);

Yet another trivial comment.  I'm not a big fan of >80 columns lines, but I
understand there are various tastes :)


Thanks,
SJ

[...]

