Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A157ECAC5B5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 23:17:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 048878E0002; Thu, 25 Sep 2025 19:17:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 020BD8E0001; Thu, 25 Sep 2025 19:17:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9F558E0002; Thu, 25 Sep 2025 19:17:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCF948E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 19:17:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8B8991DF8BE
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:17:30 +0000 (UTC)
X-FDA: 83929336260.01.3ADCC80
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id CA2661C0004
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:17:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zEu5uNbk;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758842249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9JwjX2RwaINYBVQON1HAQT8B3J+75lBCjkHNZJp/nFg=;
	b=IqTsplOu+MZ/xFcqhJpFtYX/T/eN/9QHmMINa/p8e85vIlMWeBNaucgL+gtt7fQ9KjmzHk
	SBzhxXZwJC5tdhuxG2CGCzNQ+nbUt7+n/VCOdBvrnuXYob8FcM3tLQCPYWF33NS6bDzRd/
	OymPpPz9JluopU4HLsFj79gfWJbIeXU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zEu5uNbk;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758842249; a=rsa-sha256;
	cv=none;
	b=ioMsjdM3Qd9QJiOOYleTSPZZZJYPFwqddSpC3GDuDGvtSjZIw399mSgKHq3l4EmTC6JBYe
	51qdqtjo8s0OhfkhwEU7oZTAmCvLW/y8bWylGU9pKliRlJ/0yol6yv4ldqBsiE6MHp56MG
	uEiSJ2+DHZJllpYxBf8jTb2mcQDvnHU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 93B444044F;
	Thu, 25 Sep 2025 23:17:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17829C4CEF0;
	Thu, 25 Sep 2025 23:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758842247;
	bh=UwBJHVT+vWTJwWZDgObwFp0nU7Jl8uwGl6zSa7Yy8ow=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=zEu5uNbkHJ/tF/idnqJzhDukNEJsCLAt/cqSv6tmmHekUCwoTCaP46y0WDQiNW87L
	 ipPmAS3ipMBid93CHivs8o7CJ8NPaK7SW3j3hOyNv/GBxiPdQBauzCuvQGhxuJj74A
	 Acuptcch5exZ/orzwU4SsPt32okZe7NaXtlVer38=
Date: Thu, 25 Sep 2025 16:17:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrew Donnellan <ajd@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, x86@kernel.org,
 linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com,
 sweettea-kernel@dorminy.me, nicholas@linux.ibm.com,
 christophe.leroy@csgroup.eu, alexghiti@rivosinc.com
Subject: Re: [PATCH v17 00/12] Support page table check on PowerPC
Message-Id: <20250925161726.2b34890070e6d8dcf8ad3ba9@linux-foundation.org>
In-Reply-To: <336c0402c59363956d0c4eefc1b8a059e1fcc8e4.camel@linux.ibm.com>
References: <20250909091335.183439-1-ajd@linux.ibm.com>
	<336c0402c59363956d0c4eefc1b8a059e1fcc8e4.camel@linux.ibm.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CA2661C0004
X-Rspamd-Server: rspam05
X-Stat-Signature: ky147exixpz4pnbucmhqeqhqk8jy3pko
X-Rspam-User: 
X-HE-Tag: 1758842248-111208
X-HE-Meta: U2FsdGVkX19WNHlqDBrQf0lsq8HiW0gN6/sHZP1aZbjVSlBuJR5mAwCeqAt9TCJi6sFPlKhgS9GUEViDQ1JTFjC4pW2CMgVg5sV93kFD6NhPbax992SwSnGacQrLc8FNKGjxBh41fiXudRrMJAPmMT1U4FcnSKzT84azXGVEys/PNFW2JZibNXy/vETqIT8GtU37cY+F1vQo0UwyxNIAqSq+Xj1AYqmEmeKJvNs9xJJgcGlLa0pEaKPInduwC5t7aAe71Ld6pPqcVkNZ8tcxYktg0mkLjAgH0YvUVzSLiDrK5soYh9URdV6lSTzgzQ8KQ23cOWEKhFoQAGq8pvdwUl8p1ACGmu583v9q+wpn9K4pOAPqR+KrPNQr6LKXzy8sQR4GGRHQ9yoGuHsXbtcZh+GxaVX0MXAq6IxHCZB6A4w3osjFaLQE4ysBa3qIbIJRsrjlOZ6y+7T7fHGqt0ngsEK9zOAGHnSAmFJbUyUoub35VBXZn01x+vuDjMpt/jM8iDn7xnkJ1JaSbSSvcK/uyaa1WZ1SG/cbtcZ30++OdHYgNrGsQlEmZj7sAI+/Bb4USO30IxksCcOxCQK40Hir3/ZxJCgctg2e9kmyfe+Oq81+vgsSGJRMeppVXjZQ/FeUZQY1gpkCzl+xDTGL0gX7dz5MYS8JNOh4HKcK7rWJrEwMau8lD+NvOA4bMGmSDwM8aZE++xcKsi6+JDx8iwmcyWBV/xGqzbQuG8OaN8U+b/bg+4mJw8vl7HkFltzT3SdQLwdvStWq0ZFNvZtyIdVfqdggu8pr3ATHXA1DvkF8onjM94HTO6mADfYN9ZyO/GTuAV4IjbR41eCcCfVDsWcZFOGQxEChvrxZEuPo8ut+i1FsqJZunJ2/nEjaQpiS1JYElGo7conL0XotNHQVporcwQeQ6Pu4o4aPNZbT3Ki1jZYKL1Tzb8Z3LRR8xOramMBTOVB6iUDC/KNozs/Lzv4
 uGx3AXWR
 v9/Kg3KlbnsNKibOWbub2B6EIdlFeZQgyMpJl9ZCa+aVrS0w57U1UHmgj2NxlWjRgVklc8BavkTAh35YDXjSXDd6c1NzJir0lmWeeY0ie2uejLYd1eE1DUwz5yMll7uJkXC9eeUjZkGTe5veLfOw1IpKYijRpyzdH86lCPkP6oOse4wYmMqs6fgRnjxcRMoWhl2k0+XDJ41z4Uf2dEjrDFnU7QliNaAEwQj4rYoTYMplL/xfRUjBEDG1CsZm1f01qPJmv2c5tcg5m/Mpf0Y7RM/o3Rw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Sep 2025 08:42:35 +1000 Andrew Donnellan <ajd@linux.ibm.com> wrote:

> On Tue, 2025-09-09 at 19:13 +1000, Andrew Donnellan wrote:
> > Support page table check on all PowerPC platforms. This works by serialising
> > assignments, reassignments and clears of page table entries at each level in
> > order to ensure that anonymous mappings have at most one writable consumer,
> > and likewise that file-backed mappings are not simultaneously also anonymous
> > mappings.
> > 
> > In order to support this infrastructure, a number of helpers or stubs must be
> > defined or updated for all powerpc platforms. Additionally, we separate
> > set_pte_at() and set_pte_at_unchecked(), to allow for internal, uninstrumented
> > mappings.
> > 
> > On some PowerPC platforms, implementing {pte,pmd,pud}_user_accessible_page()
> > requires the address. We revert previous changes that removed the address
> > parameter from various interfaces, and add it to some other interfaces,
> > in order to allow this.
> > 
> > Note that on 32 bit systems with CONFIG_KFENCE=y, you need [0] to avoid
> > possible failures in init code (this is a code patching/static keys issue,
> > which was discovered by a user testing this series but isn't a bug in page
> > table check).
> > 
> > (This series was initially written by Rohan McLure, who has left IBM and
> > is no longer working on powerpc.)
> 
> Is this likely to make it in in time for 6.18, or should I respin it post merge
> window?

The latter, please.

