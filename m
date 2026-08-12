Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16E64C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:08:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB21A6B0180; Wed, 12 Aug 2026 08:08:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A62C06B0181; Wed, 12 Aug 2026 08:08:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97AEE6B0182; Wed, 12 Aug 2026 08:08:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D1B36B0180
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:08:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 391971402D4
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:08:11 +0000 (UTC)
X-FDA: 85092494382.12.1A41003
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8AF4E20009
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:08:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=jssfigmq;
	spf=pass (imf03.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786536489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ei39ELWB+Kc2pXETi/HNp7tTiIPtqt1tiDtMwuQJ9N8=;
	b=agrDmNjj8bzeuIQ8Po7BKfnh64er27QbNrREWcAaVtTRfmgvj7HZB1XP4epFEN2Br672nR
	bPZG7MfoACV6X5mzgiMfBLTfGfjmKSlmVTjcL91xMaM8gVa10cDgWdKxhZMe1gMnw/sjac
	uFLsTVRRKKXrbM02/9eq+tZ8Q2rDvNg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786536489;
	b=buPP2W1XPhSH0FQoJIaiHBb7urQlX21cGvbNgWfRv4Eb+ZrZCu2uV8/r3nUeT+p20slNdu
	/Fs8/RHCamDKMkceJktIi1yWqwEgzX6XbmM2vwpddGYmkkaBn/55VolOx+yFp9zGihnNhM
	mP5+Ab5UD6bFcsDKnMee70ktJpNQoj4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=jssfigmq;
	spf=pass (imf03.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Ei39ELWB+Kc2pXETi/HNp7tTiIPtqt1tiDtMwuQJ9N8=; b=jssfigmqnFP6RQjRsa95nGCxas
	STpZHA+b1aSnASOsdnq+4BF0SqVKtQekWaRPFD57vLFUqII0Bl9pp6l/xzit4V8StWxg7O+ojX3un
	SOWW/6/y2tNR714G1y/SuI0RPQ+sgzS93C3F0zUARseVO7wGYlI7sgkCIZ3qFHxCZ2kvLjw/4EWOC
	U9C1Mvy6R94Y1RRNGqKkCgJFN28nx7P06iuLC6JNzqalrL2eVO89EG/P/uyqIL06pVcGQtxt8QF7l
	DNEh5a8yUNyKOEnrh9zUQotJX7fup0S8DmFrM1/nQlowms9MWj79qR2YWZm+7odN2wttgQdKnsUw7
	vuS/sD2Q==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wu7kR-004KSI-0L;
	Wed, 12 Aug 2026 12:07:56 +0000
Date: Wed, 12 Aug 2026 05:07:49 -0700
From: Breno Leitao <leitao@debian.org>
To: Bradley Morgan <include@grrlz.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Baoquan He <baoquan.he@linux.dev>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, rmikey@meta.com, riel@surriel.com, 
	kernel-team@meta.com, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH v6 0/2] kexec: keep the next kernel off hardware-poisoned
 pages
Message-ID: <anxhWTKwMvkVHBPs@gmail.com>
References: <20260812-kexec_posioned-v6-0-e477887086f0@debian.org>
 <6D17A62B-3124-492F-9593-63F857DD475F@grrlz.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6D17A62B-3124-492F-9593-63F857DD475F@grrlz.net>
X-Debian-User: leitao
X-Rspam-User: 
X-Stat-Signature: kk76wskixxm6a1acs9do5urtheietsxp
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8AF4E20009
X-HE-Tag: 1786536489-574629
X-HE-Meta: U2FsdGVkX19ZCdiNFyX9sexS7SXiQmYd7dhaLOB+dwKshFbPPaLAJ8m2oyNRUKt05z7lUb2ogEzbXMDjXCGvoFgG9+APJm661e8TU0fQg97Zw4NNCUANnwJidKWOUqz9fJ8OT8Gy0hMEO1qHrZyEYFijwVpdtoBbjBtGlB0wCUU9LFNzN0NnaYOspp5dk8JqqlM/CvDIMGKEZhbf1IoJa92FjfwzGRbgF8Rqld32s8+/leB8kkZaEZqzPsJ4ahr8A5NopktPAjWwFgBiZpjKh9+ujEQXblGTAYfzcb547kyGvCInv8ln5QCVRyeB+ZYfP3zSr7x0Qe6nU8364JEXVnSOoGESbixkO3Wp763SBpb+jvhrreFYdt3/ffM/DppWqwAnxnCLV0GHCC+gxlPcIlhDVuaQy9i2RU4kui9GRDgI3IQHCko6b3xZEq39kLBeDvISigCt/fFiYVKue+ZkMPoXYf2T2XUWqomhqDFU/ISPVqF6FN6PCa3FSz66BNJcvE07kya9XMwDHHmzzMCTEgkCxWeTTuuVzSf8DzC7oSYuQmJnjIUz//PnkUh6V+9ADawydruTeSX+kOpi+bwPZoAgmKMYvKzBmUoWTm+/47kssnapT8wrtTU2CD1sMwISYkgTwvlDgVKOXcVeq8v5vwCRrObuqSwgyAxG6cvCSaNBo/k7Aa8SHyzlPcYjOe5nckxvmzbJ8iqmOsd6ExxYEOMKVtogiNQNTgj18ylJm90T8UxzEzMFDHE1C+nYroT1jFtby0zpcUJ7LXCzve12EWjzyv7TGgGD71m9vn+VlzZkg8my9nvu9MjedZy+LWaWPDvCRyVU2recxIvXXarYt32TBTp6iuiI8r4idj0xfH0dK5ekh/Tcj7NstwMoTLYamZz6PuBrcGhmx2GoGyhpZ9kqbvNzhyj9NEJOosKmnptPzU87nxu11mrHe4bVQuGtt3kb7FqM+PgXVO0xitq
 /T8gtUDk
 yhQ7ThbOI3HKUFDagyHZjQB1fJ2AnG2+6DD31v3pN95TlYus/KgRZJJeaRoP8+MNGU+cls5ilWiquZYeF9+a50vOX1wsF0KSOSteLzoby+okJNs0bnH7bJEUTCa0mKsXsf2y5PuO/v0wvVkwfGvUsED+jXwB7uu73lWYnHXMCAWNQc9elpm/LJvyBpKT5mvHLQ3v1XW6BQrOxGPDq2K9txMDksbMzj9+O3qjdcMt0eNB/gjuSwRubmEvLoy6pIK5H4yrw2DCTApiVr5lrN+yxjkwveNceXaAR4aJGvyQ16gBLryYTWUf4McNCVwB+bcfGnTnjXeTKGcZWG1XfXZ30yLw6mq/sIX5bcWp31yI5y1+s15SXdypaNABAVitSTRGbKMsWijAkrStx+HWepS7pqEbfUpPVEmxxTCoz0OArosyJmWc2ePxcyvVRWaefHThHh4XCkd90CAnNYK4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Bradley,

On Wed, Aug 12, 2026 at 12:36:59PM +0100, Bradley Morgan wrote:
> On 12 August 2026 12:31:50 BST, Breno Leitao <leitao@debian.org> wrote:
> >Changes in v6:
> >- Split the pre-existing top-down underflow out into its own patch, and
> >  drop the "if (poison < kbuf->memsz)" guard from the hwpoison hunk now
> >  that the loop bail-out covers it. (Mike Rapoport, Sashiko)

<snip>

> >- Link to v5: https://patch.msgid.link/20260810-kexec_posioned-v5-1-95e1b5e2e656@debian.org
> 
> This is a two patch series with one patch, why?

This is a patch series with _two_ patches, isn't it?

	[PATCH v6 1/2] kexec_file: stop the top-down search before it underflows
	[PATCH v6 2/2] kexec: keep the next kernel off hardware-poisoned pages

If you asking why it was split, we decided to split the fix into
a separate patch, and keep the "feature" in separate patch. The
discussion happened in

https://lore.kernel.org/all/anskyrEVUlnTVEgF@kernel.org/

