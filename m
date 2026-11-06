Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69317606A332
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 13:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=uNyLqImD;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=CbMIDbjG;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=Gpzlf8gB;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=1PCIbXGU
Received: by kanga.kvack.org (Postfix)
	id 744B36B05B0; Fri,  6 Nov 2026 08:50:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F4B76B05B2; Fri,  6 Nov 2026 08:50:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E4D36B05B3; Fri,  6 Nov 2026 08:50:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 38E0F6B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:50:21 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BFDEBA0D76
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:50:20 +0000 (UTC)
X-FDA: 85404828600.02.8247B39
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id B09A1A000C
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:50:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uNyLqImD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CbMIDbjG;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Gpzlf8gB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1PCIbXGU;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793973018;
	b=elP8P6d5UfKjO/jtbiEJrVJRmrN7PsTyOijfjOGslHYlozDQdQ2vKLUmBPWcINE62R3eAe
	hK9pQ7Wu3FMC4RYq6GKOz5bDNkT5NviJ1LrVVYBmCn4tQoXXI1bNLYtjccBzW+5ndwuOQi
	lfI52s37THOnT33YFxG1qREFybT9e4U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uNyLqImD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CbMIDbjG;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Gpzlf8gB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1PCIbXGU;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793973018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q9ESeoxc2axeNsRXLbRhvtNOs3u64Vs/IsR+3Ogm2vY=;
	b=Ir/WGtFgUDM61GFOIqVZDERuzjnPiSClYhaws6N1pjm++hiyR862T8BYqZrsXQqtFlg8DK
	8JaHBOLHcvhDB3EOevYcRHTpj4X9+WOnyRikv+CwT1cTJVkMewcDYQts6EL7E5tt4uyB71
	Rtqw0vGIehVVIJPjYTMfKf5mzOfYRag=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1F25C22154;
	Fri,  6 Nov 2026 13:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793973017; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q9ESeoxc2axeNsRXLbRhvtNOs3u64Vs/IsR+3Ogm2vY=;
	b=uNyLqImDHX5uOVHWzgeMclZhQbEhpse/Z2vmgRqvrp5T6T07d6tkR2t1stQFxUA3EhOC6r
	lpeuo10ir0ehucz4b1zWpIU7fQjhHHJ5t895N9mi5dEFKYGHh7bJdJC5yN2h7kH5+2bsi+
	u6ZCJYRpdr4ItxW5JEYexZnc2or9XC0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793973017;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q9ESeoxc2axeNsRXLbRhvtNOs3u64Vs/IsR+3Ogm2vY=;
	b=CbMIDbjGYYizk2NtlAxWDcCK/DL2ZKdH4cwLciH/sTjQCuKLF+hsp2giK8raBgUYwm15dP
	SKl5t7Uafqv0jXCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793973016; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q9ESeoxc2axeNsRXLbRhvtNOs3u64Vs/IsR+3Ogm2vY=;
	b=Gpzlf8gBupkwuEjLYZQim2/w0Pm1DWe7vX27mrWFwxFX5Nm/U1MbOdnF6x8z2smK2DAUWY
	A9EaopU20S5XLe8GQXAxN3qDrmh6ua6I+BovvBnIzjti9ELEfAE0eIgKo5lmsSej/nM5/n
	vBOx0TW0lxl8RXmscGS8S4o/ku2ereA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793973016;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q9ESeoxc2axeNsRXLbRhvtNOs3u64Vs/IsR+3Ogm2vY=;
	b=1PCIbXGUsJP/R+j/iM9waFtP1LQvuSJhoIFrgr57FV2V116bXLSY15leCUqZzwgmVVkNgr
	nOKpwWr0IfLvXvBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C7106136CC;
	Fri,  6 Nov 2026 13:50:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dNaYGRbb7WpeSwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 06 Nov 2026 13:50:14 +0000
Date: Fri, 6 Nov 2026 13:50:12 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: don't map folios that are not uptodate in
 MADV_COLLAPSE
Message-ID: <au3bACuJ8BBg_le6@pedro-suse.lan>
References: <20261105-set_huge_pmd_uptodate-v1-1-a78d8a1b7117@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105-set_huge_pmd_uptodate-v1-1-a78d8a1b7117@kernel.org>
X-Spam-Level: 
X-Spam-Score: -13.30
X-Stat-Signature: 5m9hpomshgtfxesptnfpotcth8kh93we
X-Rspamd-Queue-Id: B09A1A000C
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793973018-2873
X-HE-Meta: U2FsdGVkX18N9hVHJQ4zDraR1PFllE4QGJHcdieIe6qh9Zki6WirqQGe0/Y4LufJUDcv5zaiZE33AD6HGdvZ4/pNEzvfwk5D/k9pbk1X8Vilne7AS3sp7DBKJghlN/LVV32A5MahBa+TwoEXRoF7SlqRIMy70wyh41c4zmw0DhuMVVOBgYjhe9wlt4/Ro1pUGIsjUOt0FhYsjGfwLgoTUa3Q7x2FK9dQn2RzmCnBnbK3b7dJsKhIIvv+McvHrxwch1qCf4VZVrwqnF4nUHJIYwE57rtonYRDv8/vJlj671uTN+3uj6Bfo2W10UvmPRcTq9kQto6FziYK/bnJPLeJl6OKwVfPWbn6Hi7tdM4nmKYuBFtFDfMsuUsPtaYG7K2Fdsn40KXdik+si0iHfri4LXumy00RRM3okoA3Bsie6JyPYrgj6OJW2HYCNJnFgXnc9qCh6Yrfqez8UZHJLU7jmEBlPmetpWJE4o6c6OWniGIPOTYxD98DiGK7EfW76dZgic153oN8UEArAtNKEUnWK2GPqDmCFVCKTV22iLglQZptPHxEmn3TpKZiQThJcDDFQ+WYawasnY4uwT/2dOm/E54ekR6zE4+2LZJAal7tTDXt/2XfOhdYEVW4L2CfK4FWmkvTbLhJHbVAMi+Bc2bJLajwIbJuip2wUbfHcrKrlAbNgKR6gTCviz5229zB+2ay1f1rLZlH86oYo20dIKrs52JhHYphw28jz/voZUBJdjhInLV1Yl8uBbXU5ixr/w2NL/zS5x0l4VrIsa+olIJuJd+aySsKNTco7Q9oReXgvXbq3hL5OmyM3P9hJqZa2Ct0FlAIxuDSHKve98YBAbh38ak6bynLKnDM2gVFpghaoGaGm3sTyo+M8a72gLLLLb1L9E6bF+mG5uSm6t3UwFCVstvwvCOsCuGl4X6CkAWn4JtV27gZfeDbfRzKzrxHJ9iCCwcY1dUMRr2tDpDDApM
 BydhsW0Q
 oNHP7j1Jn/SZVnwnVLUOSBNF5auvExc6CKRNyxmletmDMVfQzFfEeWhSXcO5R5qD2APyDKEBr29hFlBgKfT5266Zxe8FG19ddPoWWT7sgOBXAbeh48TCtpixJmyPpzk0c7kynioGNS0jPo4gST5Qn0frX1YZoXmcIGleKvAcL1RS79CMl4AU+k8MtY+rQi0g79BS8CFzcyB0IbSmmA3II1GumgPbRsVf7PkdZaS0YtKXFtlMESfY2hh0ltWkxopbwRZGHzTCvUeI/YnVkU6FeqA1M4nIeXYhC2bade8oX7cIX97D3LYBBfX0rGRqQkbf3oImYhiiheENmUBQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 07:16:44PM +0100, David Hildenbrand (Arm) wrote:
> madvise(MADV_COLLAPSE) can map PMD-sized pagecache folios that are not
> uptodate. For example, shmem fallocate() can put such folios into the
> page cache.
> 
> collapse_file() already refuses to proceed with folios that are not
> uptodate. Let's just do the same in try_collapse_pte_mapped_thp() and skip
> such folios, leaving handling to the page faults.
> 
> Note that collapse_file() effectively clears shmem folios through
> shmem_get_folio(); let's keep this fix simple and simply let the page
> fault path deal with that.
> 
> Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
> Reported-by: Chris Mason <mason@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

