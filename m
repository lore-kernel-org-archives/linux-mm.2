Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21F26CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 20:35:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 720D48E0101; Fri, 24 Oct 2025 16:35:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D1418E00C9; Fri, 24 Oct 2025 16:35:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E7308E0101; Fri, 24 Oct 2025 16:35:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 49F3D8E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:35:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EF718BE78C
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:35:46 +0000 (UTC)
X-FDA: 84034163892.09.2E8EEFB
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6A08D40009
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:35:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=K5gTt9g2
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761338145; a=rsa-sha256;
	cv=none;
	b=zZ8zywUcLlNJMemydiRn9vBbI7EAZ2UVAwW3jhekOW0V6vCO8r3EnNui4wERWRoHCai6Nz
	fHIigGZqp2zyc3OnPRi7WG5BWHZE5ji6J+YMzsnmpGarrohslw9afOpSxlBoORhVqUWJFv
	z9QzL0SPYIpWZ+WlodJUszrGS2A/AgY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=K5gTt9g2;
	spf=none (imf11.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761338145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eeXo+CgeDN1hcJ5I7K0VElKLD4LcVB/Am22EAR79xXA=;
	b=XKvK21YCbmP2IBWL7XaLJ2jKw2wPjzwUDTWHCtQuaw0W1pFmxYyUn/t3FQ+S0NsjVWSzB5
	BL6Y5LW6ZziIw9oetOs3gxHLLJy6Ja5ggKWr6DGca3oakMtsUu4iHghYQ5IEjf+hP/kBoV
	Iky/GD9b86mz6IMieVf9z0Rkn2W1AYE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eeXo+CgeDN1hcJ5I7K0VElKLD4LcVB/Am22EAR79xXA=; b=K5gTt9g2rOXKopZUs47HB/gOK0
	3ZKOdJjFiXQwSv+L+GqvHAjvAWzXZbPe9at1Ufbeizwq4gJreYQ0IIB2NdLphzNhMyVLSZfoOnCPJ
	SHih+/nKRCjaVIoFKZr++pCgZgjVS0bT1GnG2hmsWOgSgTYamkVKosdVi96AjUMXUerIFbClVqM1c
	gjROpr8wIsOOzgAIcWwvFyvlK+PL0qHcQ6GhUOskUItRB1D1h1wHFEFaTmLkc6VG+pneTXmbFyyO3
	eGX612yp/qkmD+7uujxSopgyZZVW/0YkWdq/OnFjrSve4eIaShvesz+o72jTk2ivBGC/8ANIJCCsX
	Uv0H2zAA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCOVa-0000000A8wL-2XqZ;
	Fri, 24 Oct 2025 20:35:34 +0000
Date: Fri, 24 Oct 2025 21:35:34 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: shmem/tmpfs hugepage defaults config choice
Message-ID: <aPvjFuio9lBKf2In@casper.infradead.org>
References: <aPpv8sAa2sYgNu3L@shell.ilvokhin.com>
 <aPstDXRerYqi1O2X@tiehlicka>
 <aPtg1vUnpkaK1Ce5@shell.ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPtg1vUnpkaK1Ce5@shell.ilvokhin.com>
X-Rspam-User: 
X-Stat-Signature: rgbqhcnmz7xkbopqb5ufp9j7nqtm9eud
X-Rspamd-Queue-Id: 6A08D40009
X-Rspamd-Server: rspam09
X-HE-Tag: 1761338144-803918
X-HE-Meta: U2FsdGVkX1+fqw1gDuu+m+5b+US+onQOAR/ftTPjeEnVSAhGgPo7lcbErJjKw7hrICfK4A194Z6BK1rKFKnGg8XGvmyKMxfvNEg8NNsTybGzsWHGxYxwNJVYN/AZ1+UKEl/a419s71xcON/m4i1jcZX8maEkL9Qwni89fAPGP99s1h7iHpXLafJz8viFNM3L5Jqy6XB2kPBkBjIb6a/gHixAFbLK+HLTqXlsap8eaYy92Q886quKYu8sg7VEOFHhDYI17hfeInvwbmjmcR+1Hrm/abNgUUe5yPj6ySoSG8R8JC3rHlIyS9nyppCE+1cmD4+ufIgJNZljimrdJDi5brFyyfbK4O321rxBh9+iy4gmLA6HUZULH5inysgf49PYmX74pAhAqIIQL6HNGQ5OnxmOSNM/N/meIbfkM+Df865qCZN5LMkXQUTlh6GucX0gz/sQoF1cSqzl/1EYCgKrfP3wopCzIwlmNyzd8CZ1rHJkRF9gESjuidJCygdlN1RW6Cf3IQYDK84Gni9qD1RNok13sc5c98Z/oj5HzGXQ7pT+HB2l62DRDqV/d5wRG+XsZpg8eSABKK6/mVFeoh7jMCs0Un5wprn2Q5qVzBsAFyD2YaqBP1lPccVpsdo573M6uksdBpJgQtBtLtnOh1Bz4V5HKXZ2x1+Afw1b73CcSbapWE7Q6zaRkO/X1Pel0GTo45HYjJAJsXxA9bx1IVxAqbxIRsESvgHcehHVj0ZNCn1z7i3eKb0D4uti0YNQkIvjjJze/q3BDSDZBWH1oT0FYwtTvJloIsfYoelhw99MjIz79pJOsKRHucS/SDslJKmwvVfNU5UKmtUuLZdvmvJtSDLnYecLB9wsT2gMoYTM4e8HGZDD1CBq2MhIz0kPj2gGcArcNSDHmSumqNCGJdIdOETjFYqntkpnwPed8I7dybWBClwAhVe3VdSDJuOVMEmjmaALwwfohsxPXAYY1vG
 ea8KFUNs
 E2pSy0qF7GvORJidLm1LZpxuseoDucqey+z2nAYtR7FJMYNvVV81g9IYlSfKSXDJgfJ8rGaqwOTiEGvTtvPgTqdY9GNLd/BFCt3+ioGrpPDo/q/Zd8DCjpUHEfSimP4yMiMb2EJ3pbWPCPI9yYhxJAHlR00KHPAWmE0vpjEgDYG5jPoNRfpUHYoKcVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 11:19:50AM +0000, Dmitry Ilvokhin wrote:
> Primary motivation for adding config option is to enable policy
> enforcement at build time. In large-scale production environments
> (Meta's for example), the kernel configuration is often maintained

So you work for Meta?  It is poor form to send patches without
disclosing your employer.  That way, we'd all be able to see that the
positive reviews come from your colleagues rather than having it look
like everyone's just "oh, i'm a random developer doing this on my own
time".

