Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47277D1D494
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 21:26:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B6CC6B0088; Thu,  8 Jan 2026 16:26:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46ABF6B0089; Thu,  8 Jan 2026 16:26:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3394A6B0092; Thu,  8 Jan 2026 16:26:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1DA786B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 16:26:50 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B2F1457A2A
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 21:26:49 +0000 (UTC)
X-FDA: 84310081338.04.347FE5B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5B67E4000D
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 21:26:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=l88Epeje;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=e1xZjJeS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=l88Epeje;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=e1xZjJeS;
	spf=pass (imf17.hostedemail.com: domain of dsterba@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=dsterba@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767907607;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BOWbTcrH5Ad3otKJSd9OvtWawau1wk+iAn0C1RMT1CY=;
	b=FO5IPbkJHQkydw2qtaSzkGXceQaas6EKhlShZvDwIj36Ioet5BETurPF5EuBfd+Vdeznyx
	oqN51V/kV+suL+oo1UIjrED8VNmmrRyZFRmBLYdK02f7oyaYmnlLzwUxyzGokYTKGhN0i0
	bgI8b5zAu9JZ6A/qo5kdw4mnTPacy58=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=l88Epeje;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=e1xZjJeS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=l88Epeje;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=e1xZjJeS;
	spf=pass (imf17.hostedemail.com: domain of dsterba@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=dsterba@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767907607; a=rsa-sha256;
	cv=none;
	b=mDjN43OaVOzHQvEaRCI+238nQwMNzI+skGLSaIZrsima43/yBHTNSwRoy/zBGV6enQNm66
	4Aczw/F8L+ccVEukvKxLRbkchj1r8Lx3/dI+1GDDS+dHPsPM3s7jnnzDHkIWOZJbPM/Ze9
	5tAQVRGLqfoMU/ZzWYev3dPcXGGi0Kg=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 102445CF7E;
	Thu,  8 Jan 2026 21:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767907605;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BOWbTcrH5Ad3otKJSd9OvtWawau1wk+iAn0C1RMT1CY=;
	b=l88EpejejaK25eZEEIeyHEx7Lpzes+gyU2qGAtCcRVL2gtRcmRcvJ1vXdEokN8HjUGNWjV
	DcGBpYLyY8aFYJ2RCeAOO/26lu64BQ80WDDjzGJJ1R9zotMy7UmsKqqovM+UkI+ZsjBdsI
	vxjYcJzIKl0vxrkE8RPAr5TyH+ve2FI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767907605;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BOWbTcrH5Ad3otKJSd9OvtWawau1wk+iAn0C1RMT1CY=;
	b=e1xZjJeSzuGMeXIOwR/ZWct3E5ZmNqrlgXULYw8XwiG91u5mi2hH8Oul8qo6+fR0ITUmqm
	EWTKah3+viPrRqCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767907605;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BOWbTcrH5Ad3otKJSd9OvtWawau1wk+iAn0C1RMT1CY=;
	b=l88EpejejaK25eZEEIeyHEx7Lpzes+gyU2qGAtCcRVL2gtRcmRcvJ1vXdEokN8HjUGNWjV
	DcGBpYLyY8aFYJ2RCeAOO/26lu64BQ80WDDjzGJJ1R9zotMy7UmsKqqovM+UkI+ZsjBdsI
	vxjYcJzIKl0vxrkE8RPAr5TyH+ve2FI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767907605;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BOWbTcrH5Ad3otKJSd9OvtWawau1wk+iAn0C1RMT1CY=;
	b=e1xZjJeSzuGMeXIOwR/ZWct3E5ZmNqrlgXULYw8XwiG91u5mi2hH8Oul8qo6+fR0ITUmqm
	EWTKah3+viPrRqCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9E95A3EA63;
	Thu,  8 Jan 2026 21:26:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id G+OGJhQhYGlPWwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Thu, 08 Jan 2026 21:26:44 +0000
Date: Thu, 8 Jan 2026 22:26:39 +0100
From: David Sterba <dsterba@suse.cz>
To: Jeff Layton <jlayton@kernel.org>
Cc: Luis de Bethencourt <luisbg@kernel.org>,
	Salah Triki <salah.triki@gmail.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	Anders Larsen <al@alarsen.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>, Jan Kara <jack@suse.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	David Woodhouse <dwmw2@infradead.org>,
	Richard Weinberger <richard@nod.at>,
	Dave Kleikamp <shaggy@kernel.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Carlos Maiolino <cem@kernel.org>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Alexander Aring <alex.aring@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Hans de Goede <hansg@kernel.org>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev,
	ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org,
	linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, gfs2@lists.linux.dev, linux-doc@vger.kernel.org,
	v9fs@lists.linux.dev, ceph-devel@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: Re: [PATCH 02/24] affs: add setlease file operation
Message-ID: <20260108212639.GL21071@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
 <20260108-setlease-6-20-v1-2-ea4dec9b67fa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108-setlease-6-20-v1-2-ea4dec9b67fa@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5B67E4000D
X-Stat-Signature: dkmrgwb6czsw4ykfd431hdrs5z61uijk
X-HE-Tag: 1767907607-972406
X-HE-Meta: U2FsdGVkX19cq90hrStoRPLSa2Un2FoAsW6ckF+2u3nofhue1XMUhGYLCSjOor5nFISyOwOAahu/WmQOSncxn27X/bKl8GUMl2g+nLS6Tsx5tK2jSKVWVqfoIj4q/aQ3AYdMZT74aZX3JO771bdTA+uaJ4C0io+9j+Y0cgRdh0C3PSa9gf/FNRdDcmsmlYjZxKB/XULEOqAc+tXMPdGgsVPbT+hOQdM9K722RB/xwgsifCWV5ooFfitwtkd/SVISqUBmf9Fr6rpHl1Gk2qz5vxAG6g1S+JsVU6Rf2omxDXhn5ccf4EWLYdgoW8RFwGzWA/8oVn8785BkVndtkDUXby+9cs+kAXtmqx6gnTiOZqUCArFQriBQHVs09N6rF+nsuYrZUb10xi5GIVxRzw0xNqmhWnQTdyO3053O/KBzUWdLpFNYQI3wsHn5zF6J6H0ZhlgoJ53ntDVaY2R//lPOR72ZBRCeXd6k50srjrfJtooJSy4tHtT0s/Opq2nK8TJuqqCgLZ8+GZvr4wgrFUmsKwkoIu1drNb99EYGfcozggrgmsK7nnL6Y9rpjOo+FvXVttHjAbAYxp1pCQG1v74iqB1q+UyJlXVDyQBBLrZ3ksplJDEd3Vvi+5miKJw//Vyq+IuSXfgQ3MVaHuTP3zk0q9RTzbhFyRvPtLxNoiHuZadJofbwIHa45kenw5QkGHJZ2L5wTCUt/lNzLcsKCMIApNN/u22moH2rkeanuVaswtekTT94dBd50Ojmb4eopHI1AUA1BXobugsxZsYYtXrDltk6nrDYp4UOiSjrqEETNLhsC3E0ea90swwNJ98OW5yCsvJ5Hp2G0X+jBQkgHlio/BH7lGUlBkprEnlpkhrVPxJVnVVrUMrI11LPGvju5gIDd1NrDWHhuqIJ4zLJn42lIChIS3Z58YDMrQ7bGFisgcJQDm/zpWI7/EHGRSCG8fMb6NylrFkwCrV48viFRLK
 EiSBuz4h
 yG2RYTxQii86njlex/PLiJr8oVojfiXdECFAy4s9gEvpCAjmZ1ILM/Gd5yABjH4XrQdtLU9ufgGLPoncgfG9DdsNgnzECHUXVL78w9NHlYR6XOfE8V2mXGtkXzRGx8vcLzrTgoGWvMn2rii28goXiPh6K9cOa4TMHSFVqtGO0FBWzKtdT2acu+49lqM1hCbk1nsrFRSylRQ3bYAHrNl/Ho6UvqBrbioSvUAFjaBEERbDvYHwDgeczxEcIwZ3G3uNqiEaySh52wlVt/IJt1pHxdy5DOx0wiLNQTnGhiccZRnmGqIqnVi6kwwTxHwGNW2qdeVTOYwmzvjVitll6ti2wtMAEH/LYM9KvooQrwGpK4qJ6aJ5rKs9Egj6EFnTKKnt1qs7MGBUbcgxqgX/GIwz8cxuK5fT3rOYX5BAIblaXwawxFuIc7mDngIUq2NipIK9JNQYP3cs/NyuCbI+gYvWZ/jWQxzycg+hAkUM/4vq+5SwVbzWStkOBBkmevA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 12:12:57PM -0500, Jeff Layton wrote:
> Add the setlease file_operation to affs_file_operations and
> affs_dir_operations, pointing to generic_setlease.  A future patch will
> change the default behavior to reject lease attempts with -EINVAL when
> there is no setlease file operation defined. Add generic_setlease to
> retain the ability to set leases on this filesystem.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Acked-by: David Sterba <dsterba@suse.com>

