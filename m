Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D335CCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 22:33:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 583CD800A1; Mon, 27 Oct 2025 18:33:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 534DE8009B; Mon, 27 Oct 2025 18:33:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42330800A1; Mon, 27 Oct 2025 18:33:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3515B8009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 18:33:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A38A25800F
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 22:33:27 +0000 (UTC)
X-FDA: 84045346854.22.08F5E12
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1C18020004
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 22:33:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="cnSO/D1L";
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761604406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5E+W3t9hIxyqv+0zJtWLf2oHfnEucv0VMf+QiFthhhE=;
	b=DP7R3tMf1wXdeEetIlM4TrTNinz71PBtONFaK50kxpaST+uBuZv6HH36gQ6m+KW6nFEJkn
	EKhJ0PZGG/XPTdwOQcEY7HDPs+eC5vnEsFACKj30qBHaTZltKQ6GAQarUH/mgXvwnkj+iS
	81+T5TroUA3GxmT1kRarBIFIMpNFOy8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="cnSO/D1L";
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761604406; a=rsa-sha256;
	cv=none;
	b=ZoLmLls1GmCHurOrojcbYkaIETzqLXQmBjSH11b3AX4a/TJZABCw/jgy8gnQPpzPc7b9Bk
	6JmzE2uLPRlDZrE5EWFi/Mu2QBXTRFBPGt9HpYmnYGHbXjdDLbo9aZQr9VCTgUqWGUGhg8
	XGxm69ekmJ90t2SER74b7Q0N+zAugEw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2BD0960205;
	Mon, 27 Oct 2025 22:33:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2ADC4CEF1;
	Mon, 27 Oct 2025 22:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761604404;
	bh=fLsY2IaNWnElQm8sDAaq+THCaLKaSE7zFkFyiMd/pwA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cnSO/D1LcebBp6Cvsxk9vKxyPgcagZU6mdww6XBNtxYkyCiMfAsT5j4lcUVeAnhfC
	 OWW6vW1QACOUuuIwVrW1DkbWyM+MZBf87+OD0yON0oWFpumPZCD6Q4isbVVnibzLEe
	 Yud1wYYJ6PuguEptiBR7VdwBj/F23lsh6Mj+2D2w=
Date: Mon, 27 Oct 2025 15:33:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>,
 Matthew Wilcox <willy@infradead.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, Harry Yoo
 <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt
 <shakeel.butt@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCHv3 1/2] mm/memory: Do not populate page table entries
 beyond i_size
Message-Id: <20251027153323.5eb2d97a791112f730e74a21@linux-foundation.org>
In-Reply-To: <20251027115636.82382-2-kirill@shutemov.name>
References: <20251027115636.82382-1-kirill@shutemov.name>
	<20251027115636.82382-2-kirill@shutemov.name>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1C18020004
X-Rspamd-Server: rspam03
X-Stat-Signature: 3cm9nks1gqh436erf7moudec6npqag99
X-HE-Tag: 1761604405-617911
X-HE-Meta: U2FsdGVkX1+J6p5L9vKYQSCa0pkm/hT1YT+fvpbbdoL284dNtTOQr/j5jE6z8KvrxA/SlN0oWTEhKzNShCtlLH7LCR5jJcCAkR4DWqCuJPIrIgfWIbNsFjrurq4kjQnT9fEooRHJ3hULuv2dcXxiW6jTSHsIYD5GooifOQzxU/EuKfHwIOEmrP/kMa9sjX6yIWnrPE8MCDVaZ/SO40vJIAZX8W+sXdB0utrlPMkYaPnpgz/0SUkfl1XbbBRWC9VY2RMdV85/SMx/g23tEZellXyy5Zx3nOVfNWA/zfUcZ+UlAsZi3NINW0ydMrTfp/q9hd2uyeRpCzujVyrTnYD1LhrvPdeS0cZzhcjUVad+1pKuGTwcu/im4/UBIiXPS9dmjC6+eDSkW/mnwcfOLUUJHmjgHzl3v8dXRvbj8g3YVHUGlYq6wMmEUtrw2bOE0gYTjVvnp5JBU/4CzKm6w1Cy98LznrJtYqQvxtzocH0h9pfL+Cv842jtktjPfimFRJOjNMffsIh9Qgu9u0sLC3G2de1u4uVAA+uevKU+oaqWH6cX6AACuD/qXNwwXhai94qQVv9urcCvGqsoWy0rhJXd40WyPinQaE6K76k30crQcLF2/0BLAkWXOceQCYfmspTzRpGD1SvKf8SjTCp7/yZjslrvSfVGpN6VO56k+UC6oDB95UyvzCDvjuxSV77Ls03lOmNOMAy+UubiT1yyv4fYnQi8ULqgLkU7RMn4qDenUsMzqwTBceCT+PDChCgSib0zDMeutTeVz5re9o+nTRnbkHbks05mN7sjiOBJDe0eW6iISnPbV4zcmRzoXAC0LJN4ixyoW9CREfeuXQDtGo9KgBKU2pFHZ3LYmVBALCdq0rd5NVViptwW2nkaCguS8klHZyJ3TNuPD+kdpgtmFhDP6pntTZtj/XNmOAxEUy42PHQgFBJWfbfj2JFbDR3lqY+JTjUhIughCC5/Xnq5JvZ
 1GIiDV85
 wiPCB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Oct 2025 11:56:35 +0000 Kiryl Shutsemau <kirill@shutemov.name> wrote:

> From: Kiryl Shutsemau <kas@kernel.org>
> 
> Accesses within VMA, but beyond i_size rounded up to PAGE_SIZE are
> supposed to generate SIGBUS.
> 
> Recent changes attempted to fault in full folio where possible. They did
> not respect i_size, which led to populating PTEs beyond i_size and
> breaking SIGBUS semantics.
> 
> Darrick reported generic/749 breakage because of this.
> 
> However, the problem existed before the recent changes. With huge=always
> tmpfs, any write to a file leads to PMD-size allocation. Following the
> fault-in of the folio will install PMD mapping regardless of i_size.
> 
> Fix filemap_map_pages() and finish_fault() to not install:
>   - PTEs beyond i_size;
>   - PMD mappings across i_size;
> 
> Make an exception for shmem/tmpfs that for long time intentionally
> mapped with PMDs across i_size.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Fixes: 19773df031bc ("mm/fault: try to map the entire file folio in finish_fault()")
> Fixes: 357b92761d94 ("mm/filemap: map entire large folio faultaround")
> Fixes: 01c70267053d ("fs: add a filesystem flag for THPs")

Multiple Fixes: are confusing.

We have two 6.18-rcX targets and one from 2020.  Are we asking people
to backport this all the way back to 2020?  If so I'd suggest the
removal of the more recent Fixes: targets.

Also, is [2/2] to be backported?  The changelog makes it sound that way,
but no Fixes: was identified?

