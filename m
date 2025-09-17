Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A4C3CA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 10:30:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1B1E8E000A; Wed, 17 Sep 2025 06:30:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF1CD8E0001; Wed, 17 Sep 2025 06:30:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE0718E000A; Wed, 17 Sep 2025 06:30:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 99DDF8E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 06:30:46 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4B327593DB
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:30:46 +0000 (UTC)
X-FDA: 83898373692.25.077E853
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1AB934000B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:30:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DqGz99zL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TvBdrFOG;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DqGz99zL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TvBdrFOG;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758105044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1zHHraw2A4XXMh05M5xDQ/FIBzoxt7xagq0j6ASLE/8=;
	b=uG0bRpYCwtUcK6MhGhIiMkrNbIwzUD1nfd9xcwFBQycx+HHMT71sBRYkat6XcgHBHXH8IK
	8/DN9UzETW0yYgVQwQvKdaPafGVSSIZNh6DNnM7sRsKXP4oVloHNYg9ychu/Ov6/+E5LM4
	5G0F9W7n4kWAANfDiDjwbI0KMK7Z1uA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758105044; a=rsa-sha256;
	cv=none;
	b=isyTxNjdzLK1aLIqn/d112KYMC9Rd7oPb2vfx8AD2iJGo/ANiHZnyvqBzdU1KFgg3JmuKm
	BzmEdPx5UJY8Y2qXOPaQqd2I/gKYbyZcWZgRTf3VBRDsuYRLaLe+nvZL8E5qwE0MFY5h8C
	E2vWJKsDxk6Ion6srjqW5b5zSLsUnXU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DqGz99zL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TvBdrFOG;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DqGz99zL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TvBdrFOG;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 698CD1F7A4;
	Wed, 17 Sep 2025 10:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758105042; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1zHHraw2A4XXMh05M5xDQ/FIBzoxt7xagq0j6ASLE/8=;
	b=DqGz99zLZi7gBVK2fSpkmcFDQp+G3N1rsQtOWflY51o39LFUbbat4CrXeIS9F5/IJ0cXSf
	o+geSvjpoF0ZXNGAs1g7+dAtLkl/Tv7OkTkU5kFSZlOAD62xQTFH7ZCebde3coO4ZyZKMQ
	DDpAbzeqLk3TQWOx95Sxs7A/BO6tyzk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758105042;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1zHHraw2A4XXMh05M5xDQ/FIBzoxt7xagq0j6ASLE/8=;
	b=TvBdrFOGBW3c3Mtg0Mty8fKLlQApRtpmeFJ2kHvCrO4Oa93K6SSguxvDOL3Hma6jgZ7/bh
	ZMvCmbgDAYSn9ECQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758105042; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1zHHraw2A4XXMh05M5xDQ/FIBzoxt7xagq0j6ASLE/8=;
	b=DqGz99zLZi7gBVK2fSpkmcFDQp+G3N1rsQtOWflY51o39LFUbbat4CrXeIS9F5/IJ0cXSf
	o+geSvjpoF0ZXNGAs1g7+dAtLkl/Tv7OkTkU5kFSZlOAD62xQTFH7ZCebde3coO4ZyZKMQ
	DDpAbzeqLk3TQWOx95Sxs7A/BO6tyzk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758105042;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1zHHraw2A4XXMh05M5xDQ/FIBzoxt7xagq0j6ASLE/8=;
	b=TvBdrFOGBW3c3Mtg0Mty8fKLlQApRtpmeFJ2kHvCrO4Oa93K6SSguxvDOL3Hma6jgZ7/bh
	ZMvCmbgDAYSn9ECQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E6B6E1368D;
	Wed, 17 Sep 2025 10:30:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pYOYNM6NymjANgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 17 Sep 2025 10:30:38 +0000
Date: Wed, 17 Sep 2025 11:30:37 +0100
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
Subject: Re: [PATCH v3 01/13] mm/shmem: update shmem to use mmap_prepare
Message-ID: <ixvivcg7sr6twekgyfgas7yl23nv7zi5bmn6xyqjvsvuituc4d@usfryzkaf7dm>
References: <cover.1758031792.git.lorenzo.stoakes@oracle.com>
 <cfefa4bad911f09d7accea74a605c49326be16d9.1758031792.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfefa4bad911f09d7accea74a605c49326be16d9.1758031792.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1AB934000B
X-Stat-Signature: xopxe1qjmz8aam8z9e6j98gf9rn16gea
X-Rspam-User: 
X-HE-Tag: 1758105043-799895
X-HE-Meta: U2FsdGVkX19t1Row5foysxRx0jVAf1b/rJmJ65j6/N6lB9A2TglLnDnUR71m0zPjpFeveHJ035eB3A+QaUZJ06O4ATBAtKcqkORKoq79AII7jkE5aOTQnHjsauJsj0qgZ5EJltze/4fVmwnwMv3E6+zPtfSDii0hXBiIhArIOqqmFFtpx2K0UZ8FkCOvh4mvTdyVunZFlxa9pvbAXT8RGBgemfF5TXSIkGAuGGJFGqg6sZCApXq3aip3GLgJufn3mSz+WJGMEsk6vjfvaIPE+g0NM5cAy7pw6UcvzJGfq8TMenLMQIcRYy1cgPSWWPsCGftlPmHJpyyye9hKV2PgK6k0320uQwhnD9R07JG/9TqyzPcgtRgd58WurLZBjkNYmrZ7Lo1tEa1Kh7dgk4C1Um0HbeYjmDzJlvrJxUZ/+pLEwHPoKHS9vnEsSdaBH25FUgZL+7mLcJ3WXji+xaui9ijte5YJQUZ6YWS8vcGRewifSOQPK8HVNzI9ZoeyiixGOHXkqPDn0Qr/Qp8dAN+o+b95P2o/WueyyZj+phX3KhVjaRy3fkYM0XyIfD4bxqbjAVCeX9GqYWasMC8K5ZcXiQ+GrYm5b4mxYVDPKtGcuMmZw4QfDUX4V3i90TMSLChEwF+iFCZC7LG/KREVN43eXVsXpaAfUzfLMwzRAyIoCmHi19FLlBL8yM9QDSjyEJZnQt05+o03/s7343t3NxeUQVp4Uv6EFdL6cMvojM9KfF1+fWx6jSQC54vdR3pqa4GDCgldjb2DAQ1mW3XFtWERaeCCBpTTQdmsX8criELafKjC2vvo/WiiHQzPfSFRiBrUIRcZs5TOFBaAVtKvSn60q9m7crGlHpJQhtR8zaRpvAm6kpo1KLEQOcz+BrSbOGZgcso89jwWApMNk2+PbdfMEzsmPZBuA6unWuh8ZWvzI0CQzEQiIKZ22L09iWrYFBdMXR+MQOc13jPd1M7igF3
 rr/W3TG5
 gBBx6Hxtri+2pZIrL2d2OtjN0C+inVx8DdcKImAEP3Qt2XYGMsKOZbFxAHZqn/fx3mzazixC0OtoTWMtzC67aw9P+u5SZuuPmTiFDmjvh4gahIIRGgxF/w7S3G6zw41BZVptXrGxmzlOmiVUiBJXvS7DuCEj2Sh9HqKBhZ7HPiyII9L8BLSBGtBVRc2JCB0w9aLmszo3+INxbNJ6+r81PkLLceFORiRq18PDEo5O3hWBjOw7MYnjXtG26yoCUIW2DPXNys6OMKJFuM/qG4R1QmGeXV2QrXTgrcLf6YRuCVrtMffv79RGY/gJYVpy2t9X57LWfpwukLydGr7fiund4Dx/vRDUb9TPQTJX4iNqgKV0qvTb7sIrIytA7+MHFZ+7waAuxkV00bGqg7djnx26DrluOJAJu2fTlyduV5qgBAd9+leV3lHTLd10OsPUqrvct3XNy2De3nQIVvxE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 03:11:47PM +0100, Lorenzo Stoakes wrote:
> This simply assigns the vm_ops so is easily updated - do so.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Reviewed-by: Pedro Faclato <pfalcato@suse.de>

-- 
Pedro

