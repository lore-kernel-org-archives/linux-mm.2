Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E66A10BA45E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 09:23:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA9FA6B00B1; Fri, 27 Mar 2026 05:23:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5A306B00B3; Fri, 27 Mar 2026 05:23:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C49E56B00B4; Fri, 27 Mar 2026 05:23:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF6ED6B00B1
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:23:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 68DC41A0A88
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:23:18 +0000 (UTC)
X-FDA: 84591304476.07.7AD00B2
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3723514000E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:23:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PzfRGWoT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=npb1ZL5v;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PzfRGWoT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=npb1ZL5v;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PzfRGWoT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=npb1ZL5v;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PzfRGWoT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=npb1ZL5v;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774603396; a=rsa-sha256;
	cv=none;
	b=ZqWARhFTDML5kWVyT9E4oJUt0JKVIjM4uhNHBnKzs3LDH8WG74k5iVSnu9SgNM7tX758SC
	9trgAayGQvQBHjFMcF4HwFKNM6Pi1uMS5FW2UXxixT9+LH0zJTVKCwOjASwgj0LdU69kc2
	XQ9V49bA5lr3cHgOJvN9Q25x3qy2Hug=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774603396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9b+Ql60PETfSYcon0dTMeZvn6zaheEMIwSSaNSyoZd4=;
	b=SNqGFq9Ycvnmt+qWDt+sq+f3xsnsDYP6/xUfCHgphixaxXJbdTGXAbW/IjFU6wqpy5a/f1
	WWrhJ9AxYRfl+h+AC4TV2RBevqf6LUv7BIqy/clFGydqcgLAdC9xVqLgdH4dZ1CLR0GvCq
	B0rHOwgQ+xApKK+2+Aqt2i1ONq2aYDM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BA6E05BCD1;
	Fri, 27 Mar 2026 09:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774603394; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9b+Ql60PETfSYcon0dTMeZvn6zaheEMIwSSaNSyoZd4=;
	b=PzfRGWoT1toQKwjW5zwasLdWo9TRQ28chiMd2D8xvl3bbb1AVvpL8EY1a3+oV/E/poU/rT
	vUe1/+uyrhfxddDFHfAPHeDVW0yok8B+X2+fw2WmghnhA0Af1EFjgWYJoF2tN87eEeI6aV
	eRI162iyE3yjLez8vsCWuCUw99oZD5M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774603394;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9b+Ql60PETfSYcon0dTMeZvn6zaheEMIwSSaNSyoZd4=;
	b=npb1ZL5vK9xaEB43drAlKbqRjZqP/qy0auIKM0fTCYVIrQ385s5Ksf8MJ+5ISr7k8BomeZ
	fk0iLT2t8fo/q8Bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774603394; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9b+Ql60PETfSYcon0dTMeZvn6zaheEMIwSSaNSyoZd4=;
	b=PzfRGWoT1toQKwjW5zwasLdWo9TRQ28chiMd2D8xvl3bbb1AVvpL8EY1a3+oV/E/poU/rT
	vUe1/+uyrhfxddDFHfAPHeDVW0yok8B+X2+fw2WmghnhA0Af1EFjgWYJoF2tN87eEeI6aV
	eRI162iyE3yjLez8vsCWuCUw99oZD5M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774603394;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9b+Ql60PETfSYcon0dTMeZvn6zaheEMIwSSaNSyoZd4=;
	b=npb1ZL5vK9xaEB43drAlKbqRjZqP/qy0auIKM0fTCYVIrQ385s5Ksf8MJ+5ISr7k8BomeZ
	fk0iLT2t8fo/q8Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E413B4A0A2;
	Fri, 27 Mar 2026 09:23:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pbhvNIFMxmlkGQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 27 Mar 2026 09:23:13 +0000
Date: Fri, 27 Mar 2026 09:23:12 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Jianzhou Zhao <luckd0g@163.com>, 
	Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH 0/3] mm: improve map count checks
Message-ID: <2bkj3z4mgwmobscv4huqu26cwykn57juljqf46ljwagghzh2kx@lycizofaukl7>
References: <cover.1773249037.git.ljs@kernel.org>
 <20260326224239.9052f8be3ddb9cac600f59f5@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326224239.9052f8be3ddb9cac600f59f5@linux-foundation.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3723514000E
X-Stat-Signature: wt1etq17bp6zk9hfbwph379b6pq851zh
X-Rspam-User: 
X-HE-Tag: 1774603395-837830
X-HE-Meta: U2FsdGVkX1+459rAxHzGrUFxrsh1BAbk+gdLiXQarNPvwZ1NhLZOAdrht5IQTvw86jTrAPtZnXvBg7vAWugoxhcxLuCfr3cVTsgTaZIrraEdsq5rT/7IuPGsg9pLyaQb3/Y03M+kaNhwXmijkPmuzIXbEgGJDimcqPg2NlfeG8KMgMpTC4thm7WJf1Go2X76g9woOMr7y5Xhfzevpo6iZa1n5dCeGvVHFJdVmDWrPS52I8EonUpWypqLi0zKOIjHiTlOCyEn2UKYA2cv1iNqPcjDvuUKR8GjvkvFRGtvkWxHUWDRHKr1EPiJoffPFUVxqMXAD3oxHaY8GrcXpYnsuk4zSNFSxlx5/60IxNrubgtZg8t6QheYmxX54lucly2KbJHXQQ6hNjdVcqRK+4fPNnUgTR62mmJQhd+bygucYmnu9lhMisHJGw/DYPto9fCXzyYSmntovtfiB8eCYI0UWPiYd8RkWf/N2hgQRosBFCYX+sXEtTrkukLkEO9bT3t6SOl+uhGLNaX+hUjy0YW9+aTj+yjLPzfbdCKX4JYNj+oDxdcbVkWCy9DVlDEukL1EoZ9c6Q5Cvji8nLwmLiRC7icMFyjO2RHN4V5l80VdU/4NhJILziCPDTe2FkDyVvgMAvj4b+a76zeelMOCTmBrvVxYUy3YSm4dFrA4SWigN8eBt54o1aRS1n+D/Ccajlgeozhhsgbukb8KvDwqTRGbBFPX8ip0dEC9exGARLL+x/kDIKida8V8yJXmWDce7RAXdKsNYE+Ce32I0REb4p6B1/8C8An26F35/nv9PpRDJvnvCDeaifjADa2G4VN7MpsqWPR77AB9J2otToJwnG5HBseGmpWsCAoDjH7RmvNs5Bm5aopNz9VaPpGIYyGfqAC3ogBEwRX61xISx5O9pH3qfiacaH9TJO8cZCli9Z7MwUwet6+jZruGjVSuBEEdPV9XAtZtbDpWmEPwqsjqhiH
 fbERKbYy
 CA7MxpffHAtDuLsrsYVelQe/b02ecpooozk86+JvcOfQt79JcGdKhNd9PNJR3mm6dsk6boOqoXR3mPDDo2dXzvRZ8VDMdD0rGnAqb4LMmw2ruotXUvRcj34znnAbO9TzKyURqNZ85+6ryKYGvdOjBgZUKLlQcjq5Cidx3/2up+TyEgC+ytH2yrxM0xkvvn4m3SV0ACxWzmbHNUCb0zZeia5tbRK/DwtvXi/HKoY7kvMS4t4bBd9rKaEatogYvywzwq9qDcCkzOEcR5FggBGbxO/ArR+GNWheyi4ZCF7P96nkWCCE955Z3xBt7wwnYp1c/0lJw+JydJ7KjFb4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 10:42:39PM -0700, Andrew Morton wrote:
> On Wed, 11 Mar 2026 17:24:35 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
> 
> > Firstly, in mremap(), it appears that our map count checks have been overly
> > conservative - there is simply no reason to require that we have headroom
> > of 4 mappings prior to moving the VMA, we only need headroom of 2 VMAs
> > since commit 659ace584e7a ("mmap: don't return ENOMEM when mapcount is
> > temporarily exceeded in munmap()").
> > 
> > Likely the original headroom of 4 mappings was a mistake, and 3 was
> > actually intended.
> > 
> > Next, we access sysctl_max_map_count in a number of places without being
> > all that careful about how we do so.
> > 
> > We introduces a simple helper that READ_ONCE()'s the field
> > (get_sysctl_max_map_count()) to ensure that the field is accessed
> > correctly. The WRITE_ONCE() side is already handled by the sysctl procfs
> > code in proc_int_conv().
> > 
> > We also move this field to internal.h as there's no reason for anybody else
> > to access it outside of mm. Unfortunately we have to maintain the extern
> > variable, as mmap.c implements the procfs code.
> > 
> > Finally, we are accessing current->mm->map_count without holding the mmap
> > write lock, which is also not correct, so this series ensures the lock is
> > head before we access it.
> > 
> > We also abstract the check to a helper function, and add ASCII diagrams to
> > explain why we're doing what we're doing.
> 
> This little series has no reviews, if anyone is wanting to boost our
> R-b stats.

Thanks for the heads up! This was too stale for too long :)

-- 
Pedro

