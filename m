Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6954EEE20B9
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 17:03:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABA596B008A; Fri,  6 Feb 2026 12:03:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A63856B0092; Fri,  6 Feb 2026 12:03:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 911516B0098; Fri,  6 Feb 2026 12:03:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C02B6B008A
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 12:03:01 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 467CD8ADC1
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:03:01 +0000 (UTC)
X-FDA: 84414651762.28.40FE82B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id E5F1340005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:02:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=orkqlvE9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EE5crKCo;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=P0Te8zeS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rMULjRcu;
	spf=pass (imf17.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770397379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CUYqtP7ZgHQdQC5vBnzVZXDXwlg+QpNEKhaQm5ovGbg=;
	b=e5HpjZro9Wi9NurPZeRqBIuU87T05qaOElbUDCql664HJ+MHFThX6wBdVdhhYlDU3gLLcg
	8uzZ2ujswv3o1OegcKoJJ1Ak/WqpXrXnLdKF6O9nT8goEZQUrDHZndpLHzsk7jGpj8qC5A
	Pk5OIzo3XDiECYNnY6n1xe457HNhmQ0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=orkqlvE9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EE5crKCo;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=P0Te8zeS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rMULjRcu;
	spf=pass (imf17.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770397379; a=rsa-sha256;
	cv=none;
	b=bAbyhq2V6C+aJeTb0D7H4jVa6E8LOCuhlaS1G3U0tiBKQDToHmdv6JPTdhlcAfTuaeZ5d6
	hYNqZ/6KH3uY5hcsQMEezLGzDEA3IiktkFByKPwUr838/MVKO37IdWsja+Dkj/y/BILQDw
	BAGWBskiypla7O6nwKrPeXqqXD39Ues=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E62653E6E5;
	Fri,  6 Feb 2026 17:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770397377; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CUYqtP7ZgHQdQC5vBnzVZXDXwlg+QpNEKhaQm5ovGbg=;
	b=orkqlvE9SwTuzg1vUY/b9kRBRSLpHcoYbkm9JOzNPXV3xUCu71jskW4VC6PYgISH5dAKeQ
	GnxkepJWMc9d5s492frW0onGpnHzB+rf+OT0PoaQHLS9zG/MfhCdsTS6jTxddG2endGtrJ
	1XF6Cbi3kAHbaCBgf/9/TTJmGw1Khg4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770397377;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CUYqtP7ZgHQdQC5vBnzVZXDXwlg+QpNEKhaQm5ovGbg=;
	b=EE5crKCoft9WjyIsphFaJSVj0dj3WisFlTa44mrS3a0w9C5UIZO139v5AfnUvd8wFoAV/1
	ijvnduHOW12+fhAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770397373; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CUYqtP7ZgHQdQC5vBnzVZXDXwlg+QpNEKhaQm5ovGbg=;
	b=P0Te8zeSLjKAlYkAT+2RbICPhrTFBetL7skyodk5FaxxibOH9vtxvMRNfPFjuWF/D3BvCO
	Twi7tlKa2WiGRW6KQFw0PMJvt9zlPkCAmXE9SqS2hBuQwUn90qdevnQOf1MeWIHxKS8xjC
	uYOazmxOURU4PzyXqg1pSF2T4sjAbr4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770397373;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CUYqtP7ZgHQdQC5vBnzVZXDXwlg+QpNEKhaQm5ovGbg=;
	b=rMULjRculEo3SDhtOcqpmQ/l0s6TQHipK7lfBzjVqqjjFBs2ZAH89Z4OkmL0BIHHr2y7hh
	+YBebsQbhnf9GdDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B86A13EA63;
	Fri,  6 Feb 2026 17:02:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dUHUKbgehmmudQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 06 Feb 2026 17:02:48 +0000
Date: Fri, 6 Feb 2026 17:02:47 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, Christian Koenig <christian.koenig@amd.com>, 
	Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>, 
	Matthew Brost <matthew.brost@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Benjamin LaHaise <bcrl@kvack.org>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Tony Luck <tony.luck@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, 
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, 
	Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, 
	Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Jann Horn <jannh@google.com>, 
	David Howells <dhowells@redhat.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>, 
	Yury Norov <yury.norov@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, linux-erofs@lists.ozlabs.org, 
	linux-ext4@vger.kernel.org, linux-mm@kvack.org, ntfs3@lists.linux.dev, 
	devel@lists.orangefs.org, linux-xfs@vger.kernel.org, keyrings@vger.kernel.org, 
	linux-security-module@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v2 01/13] mm/vma: remove __private sparse decoration from
 vma_flags_t
Message-ID: <e3qrulshyfrqkpihfb7prx2xyp5sn37aobccihw6r7vwwj2zm2@fh56mijhhk3c>
References: <cover.1769097829.git.lorenzo.stoakes@oracle.com>
 <64fa89f416f22a60ae74cfff8fd565e7677be192.1769097829.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64fa89f416f22a60ae74cfff8fd565e7677be192.1769097829.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: 1ubomso5y7wdouf8u4gbx5x1acon8wou
X-Rspam-User: 
X-Rspamd-Queue-Id: E5F1340005
X-HE-Tag: 1770397378-396192
X-HE-Meta: U2FsdGVkX1+MQ1RwY+Z+ZAyswF+IL3g8anp7HuJQ/cIWb6Qo/u0RIn+b9q6ejKL1s34wm22h+a68ZVhmWlMO6zjbLCdvDdr3P8dhLTNT3Et1men7oI39M7OkWGP2ibmVACNZhkNLT2v+9tqMdnHYwjiG/EsczNQTuJ/2Un7N9Jgo0htkcukGkuns9sgo7zW2V/VbVictzE2j5I5WuBlSX4YoX/71hdgWFb+zckE+ad5wPT4ieKotgb3SItzF6ZfCIINazuKxdDeaFvMJAQ58MoZMSOR8w0zdrllXc5fbp9FNciXFwjZjkBpd5JRoa2OVRKIfrUPo/bB3/lQtPIDJ4kVNxXiZm06pYw6fDNg5Itax2GcAWwOCHhzsE8EEKyW+EDtOxYuMYtbFIX8kyGiV1vRIPtkov6l7cNxjZrEJ5wVWAAZtSzkf0kV5GeGGNj6oiurpWJEP7uCT4pr6lNL5MaAKf01UGLt5O0qTUUXtLkLoWHxfwd/X8XkI/+w3nVSA8c/FCn1TRjEVK9cZgiY0hek/jvNKphElv6JGf/9hLHdAMP33g+ADyI0E+laBOZm3qFEfQYtZ+wJEYgmTaFpQlyrTA/rMnTRgxQ41WdVvR1REY9gsgpIcf8QKm5AwYtvwRSiWW855L3yEU6Fr8O/y0Ti8wPGidMHroYrY0dahI6nIUki6bsO7PHNsQKx94SD+t90MYvgm49OwKPKV3e3PVjpg4LdpGCVOGshrpcbf9pT2Izsq8x0vMvbzB+/3lQXYS1ysJ3A3ccUlUmrrIBfbWlse2qoZ1knw6u2mNUn53zDQtzajZKkcU98G9UtMFhUVr8nzyqbUdzpbNb/3WGQJSd6iuTKTYq9OOh9SPnE7ZoMdDVPPO1/Tf0OwpLAGQCSH/mBOkcHCjt6mUhOO4uxyWxnls2CqoZ2iI7b6AlG5xmiFzP1iIXciSqLfjyjwaX1t5pE7mkU6ylp99qLWBrp
 HBOhiNvJ
 aZ2cezGi7CZW6w50aH8El5rHVlrYwU2QsRTO27RmIUrvS8N1AjYmRmgWlMXvmgPHxDs6T2KqMHmfKKBsrPeJbaHygANwyAA1K2Ovnhiap3uqvIwUvV6cm8/TTGjwalZMF/S7DPBoGZsosYezFh/COFQwLysvvoZTxHnIKqo6qJG4PI773cC9jNS8b3MeLhClQoHuR+zY9yFfhqQFYelVTRWM35WJHneY0QtuH+Kdp/3ujS2YdXkvLvUiZHIvRQIqj9E+K0HbfeRz+WNxApFN9dz/5lb1lRMXg5L8KKMV5aN+NPIrSUcaliqNAzDUTwgRwIF/guxOCSybNNWaTlfBtKmcniPTuQGTkmdP2ALYmZq/MoHEVAjYFyXH07J2x3znC/fNm4VYTzvDbK6Ags2WydlEjk3pX+4DmIsEFLp8Gx8DWRCTlGa9jBdEwcJFG4rid+2fRbC6KdrZJblXtLIpUwTBkwA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 04:06:10PM +0000, Lorenzo Stoakes wrote:
> We need to pass around these values and access them in a way that sparse
> does not allow, as __private implies noderef, i.e. disallowing dereference
> of the value, which manifests as sparse warnings even when passed around
> benignly.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

