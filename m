Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ED85CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 10:41:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F40828E0012; Wed, 17 Sep 2025 06:41:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F181B8E0001; Wed, 17 Sep 2025 06:41:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2D7D8E0012; Wed, 17 Sep 2025 06:41:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D239D8E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 06:41:53 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 810D3B9B60
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:41:53 +0000 (UTC)
X-FDA: 83898401706.02.7046950
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4DF4D180011
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:41:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DukI9feJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cNqFvcTO;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DukI9feJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cNqFvcTO;
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758105711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ofj744S0hdgV+oqudN+JHGPXOpDjYVMC07hCO7WqjNw=;
	b=BRseOkGhECmHFGT3kLfw3cSAXZfS6YPXcO4oe56HbKjCMnYSrhqazZBJxBuNDTT3ReGyYs
	SXfiwi7KuIbFCkF7mV2VdG4yWwi0o8bhx9/sIY+GsxUKicOX9kjZijV3LcZKtZslrdJG0D
	el58kcgt0OZujt17AK9r52UEUTZ4PJI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DukI9feJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cNqFvcTO;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DukI9feJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cNqFvcTO;
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758105711; a=rsa-sha256;
	cv=none;
	b=N2Sy1/gOpb5nd41/LzhBtdP/GsMuk5Fz9WNShambjq6aIQjvIWZK47Chal4gZ7wVQtzI4V
	DHgw8UZbBNYrWKJl81uw5quzXqsC6qCibXQxbH64511Y1TtmRT2mT5kHnlwgznqKZ3w0BL
	8UUMMoMLraDBnfMp2jf7wrOvqc5XuY4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id ABBA222096;
	Wed, 17 Sep 2025 10:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758105709; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ofj744S0hdgV+oqudN+JHGPXOpDjYVMC07hCO7WqjNw=;
	b=DukI9feJZ9PHgr6VTWS5HiVn6jlBgHPZpHg9NAZaFM1yw3drJVaDQdEhCoGEF+xCybfKQi
	KigTRbEqW8N/WTK5cnGsrUK8yI1e3tSEiEHWYw63RkG5+wJoQRAlGRnyBLdbAweJqhkvFG
	K+M9ZwPSAHpES21BjOxPwep1vHqojMs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758105709;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ofj744S0hdgV+oqudN+JHGPXOpDjYVMC07hCO7WqjNw=;
	b=cNqFvcTO/C5yxY1VCi5d3aNqbq/TGtGlWg7DF48yF4jgUx+6Nw9p12MfcKeo18wD1Fyfa/
	aIyR+xrwgNcBRQCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758105709; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ofj744S0hdgV+oqudN+JHGPXOpDjYVMC07hCO7WqjNw=;
	b=DukI9feJZ9PHgr6VTWS5HiVn6jlBgHPZpHg9NAZaFM1yw3drJVaDQdEhCoGEF+xCybfKQi
	KigTRbEqW8N/WTK5cnGsrUK8yI1e3tSEiEHWYw63RkG5+wJoQRAlGRnyBLdbAweJqhkvFG
	K+M9ZwPSAHpES21BjOxPwep1vHqojMs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758105709;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ofj744S0hdgV+oqudN+JHGPXOpDjYVMC07hCO7WqjNw=;
	b=cNqFvcTO/C5yxY1VCi5d3aNqbq/TGtGlWg7DF48yF4jgUx+6Nw9p12MfcKeo18wD1Fyfa/
	aIyR+xrwgNcBRQCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 33E9F1368D;
	Wed, 17 Sep 2025 10:41:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gAoOCWqQymiEOgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 17 Sep 2025 10:41:46 +0000
Date: Wed, 17 Sep 2025 11:41:44 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>, 
	Guo Ren <guoren@kernel.org>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, "David S . Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Nicolas Pitre <nico@fluxnic.net>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@redhat.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, 
	Dave Young <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, 
	James Morse <james.morse@arm.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Jann Horn <jannh@google.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-csky@vger.kernel.org, linux-mips@vger.kernel.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-mm@kvack.org, ntfs3@lists.linux.dev, 
	kexec@lists.infradead.org, kasan-dev@googlegroups.com, Jason Gunthorpe <jgg@nvidia.com>, 
	iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v3 04/13] relay: update relay to use mmap_prepare
Message-ID: <jrxexcuzlxpnfs2jhm7ecdh4kak5i4a6e5od4cm72fn3twwzms@vptu5rfimbez>
References: <cover.1758031792.git.lorenzo.stoakes@oracle.com>
 <ae3769daca38035aaa71ab3468f654c2032b9ccb.1758031792.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae3769daca38035aaa71ab3468f654c2032b9ccb.1758031792.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 4DF4D180011
X-Rspamd-Server: rspam05
X-Stat-Signature: qzf1tq8txs8y5xtacmkdtupgq5f1r7b7
X-Rspam-User: 
X-HE-Tag: 1758105711-803503
X-HE-Meta: U2FsdGVkX18+aseaFWOjBiVQJMhGPeHrPEJ7PKjXt7b8IjWkibEEijsoowf6A9Fpj0fRsPE/U01qHrDGVNPvaJSVSfsKIVqD6YyKFLMHIgQqDu9PLXofAKAGAX/Jlk+R6kWqPsDH7TOCq/sciQujsU/rGaniLrWfAJl6Q9upS+72NprLY0tSZJ3ovrR7lXl+KGB+d/AKMa/LOjsxMT1jGbCuTDANPCz79cbpA0xMCN3TAoqzXVD+js/7sExKlghorC/5RgKTvrUrMTliRAOyWeacLd9zXPfazjc3JqKXo32yKQgmbpTREydU1IJnsaB+6kzfxT5cY0r7c5SPsQbBn7PYPEMlnzkd9slPB2PI4uzUUJjYlmiIeJvtr6V+6Lou+BwTWWaVoPismzOscTSFd66QY3fyNBMtxySRIphwJH8YUPBIkZtmdqrrGWYntLK5HpadSlsiPiiOxNkdq/C0WD4bb36EXk7kYMncR8oZXah/VlvrQnq0jkBSbFpsPuI9ShEq4Nf+nXqrG2uOXMKYeIh4w2mzLKU+jQANZdFpPSNmQUU0ERKppYJPVsKOk5iFcVBNuZCTKQlTPZQQw60VPIPUgxc4lIHIGmCJQ9mzD2HIuz5PFYVuBwSGp55dZwk3ofiKqUlj3e5TDalDI06hUgxMGZfaz5iPv41z48JrhZW6Wyhoknp4eBB18t+ww11aY0fY/gvoeXB9sdisZ2jrQxrfNMfQBlQZcUawdUBvWsL3ijpWVP7cBCzwwf6uXxGGLcgkAfnnvD6TgEQzzr0qeONOrwf31x77qpzTTOYn0Qtl3n39hbqhXW67uw0H1VQqmVmoeMTF7WfctMZ+ErIeDHp7uL40l33GXGCW/RoeAqRcIA1mzyvnz60oddHkKKfSQEuS1AXI6YOch3WPRbRfFgpijkDhfL3ZbFG2Z1v+Og3GEhK1oxQ0jwPH3fjZsOqTN5LS5hNDN+l08uFPpo+
 yXEH1cRs
 Z4UsYSLVpW109aGuAv4MSMwmJiKQavnVzjvZKA7yLXySmpmj2aBDDei/iDciAXYe/lM6zZteNLdTa+6JxeYXMx9IYWvkx7TvU+BUsbWgfAoxt/2TgL7lVXJpTDGd8/YusQ29UXb4CGYmFJNRxzmhHjDdbBWN3sHcRvR71NsSbP2fX7rh4yuGQ6H3jWUE4JR+XQgjsvm9cirCSNcaPo9ylfGnE22++2hava4WBk93CP1G564qF7IHzfKkFDdGU+rvKSj6KZXNRYjamkoxOvfpw8JA8Si4ff4n5DruDb5sInTBhydPwi06cIqtU+AqjQH8rk1IOV6hLRjbMT/i/JjUFSGDlK/R1MV3W2Jy1ZCvbBPUzViy0xXOoJr0PmN0OUjQrK0OSqah1JK/diF51GxxmRCZ9rjy332ncBf16C+XFzFa6SmT9zkGs6gIVXA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 03:11:50PM +0100, Lorenzo Stoakes wrote:
> It is relatively trivial to update this code to use the f_op->mmap_prepare
> hook in favour of the deprecated f_op->mmap hook, so do so.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

