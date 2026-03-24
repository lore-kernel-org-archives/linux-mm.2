Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7200F532DC
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 05:40:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02C466B008A; Tue, 24 Mar 2026 01:40:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1F9D6B0088; Tue, 24 Mar 2026 01:40:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBFB46B0092; Tue, 24 Mar 2026 01:40:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB3906B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:40:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C86A1A1581
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:40:29 +0000 (UTC)
X-FDA: 84579856578.17.F4E14F6
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0D88C4000C;
	Tue, 24 Mar 2026 05:40:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="UVOVo/0l";
	spf=none (imf27.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774330827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rws42ckkqTkzgDuxRUNY3njePEBRVGzgiYWDAJf7PBI=;
	b=yiSA9CnkayZcnjLFPlvQwphvQewv8dMuBhFhWCgzx57V2xImWduQqWvno2vORXcnyq/QWI
	lH17jp2y4kUXgNKCgsV6jcY6t9oVnkMjAVp1YGmiPF7/19XRNuIuYkDzp5tEDkb7+AzD69
	JC/m3mVhImxd1hxUaUMWEKBkbOBJ5Pg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774330827; a=rsa-sha256;
	cv=none;
	b=Pf4bf4V2nAjQ/UGkw2XHcwl25wHzeFQX5hBx6rFPBrS32xVKn+z3vHmVO6NWOreXAfy5c1
	ex9ArMJP18/r0mw32dshTHAyGdk1jCi7ORkzs7LyYdA4x5ZAS/B4EiHg0vMkPvAf9CPff1
	pYqi/FreWkBRF0dJ8Ony0EQfdd0L45M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="UVOVo/0l";
	spf=none (imf27.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rws42ckkqTkzgDuxRUNY3njePEBRVGzgiYWDAJf7PBI=; b=UVOVo/0luHBqwmh2QZx1wxwIY/
	hu58zpUtJw0wGB/QWwp4cdHOgHDAlvSY+NVY1LMGInsfWZRFLmzOU0F5BFEz31QSzEj8fC7o472w9
	hCuQP4DV9/pBeprydJmGaiC6z/NK2oPohr8PVbxN9c2hRf75abGI9xyh4bXx79qCM8vEvQKXuagGr
	+DPYmzKE++y2Pt99Jp1QEmFMYBoO9Fhi+rhAJL1O148lSTE8cVzGB9eklaL1jrQfzLKQzCXizqp16
	VRgNQq5FoiL+RflBRkdGV1CAgIVShlFYCpCrAqu63+vKwte0Io4VTvrj3PG/RgJSM70v4chBpuoiZ
	DgxT88vw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4uV3-00000000bOf-3sgy;
	Tue, 24 Mar 2026 05:40:21 +0000
Date: Mon, 23 Mar 2026 22:40:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 12/41] fs: Drop sync_mapping_buffers() from
 __generic_file_fsync()
Message-ID: <acIjxUzWFstarlwv@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-53-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320134100.20731-53-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Stat-Signature: ekm1yxsnji57oqfsomejp1964c4ok8ne
X-Rspamd-Queue-Id: 0D88C4000C
X-Rspam-User: 
X-HE-Tag: 1774330826-292345
X-HE-Meta: U2FsdGVkX1/wiN81RbpPw+BUHxuuIftHWUbIJdu8Fk9WA3rgpIXAuL2hd3zVlcxZpe632TammLhGuzMfam7EgRVMuBxwr0HrvBdO5Xtv07JOeISQqAGOawGA3vb1qq9rDz4STgak0KtlmAH3SYIPQgzz1zhtj2JdZBimsO7hi5R1f7fajLpzWLzwnBWo6ojI4m8DlkuDDm30eSlb7pTVcLbPtfDsZVN6ikgZ5JcakkhxD00arR/l4m6LJeKhV9vi5bZMOYV00cAxMemPr/xnwVDfyzuV2GtWX4X2E/KXIchXJGEXKafREpsAJtXUTKeOWkFXAU9m3w9sS2ggbqvzW7td9ybMGKFY3aLWC3Zts/lyKykgwLePUzg7sFUznc5SL4iiu6OyZeFH3EMfH+pl5D19PoHCvYCK6SDLpMXlmAj0b91Rxcy1TxLVa+vqXEJ1nOXCSESFdj1xe3rKaQ0DBL82nouTtLZcUbyzUEegEwAhqP9u8Dxg6YOApnbPvdbUq/pGHue0RlVbqV/0bxyQn18gYLnDgWCEw28pH8a+SPrs+Ns9n4pJgqFpJotJxs0N3p9Jcg6esh81THfb349TkhTmn3l2RjfVb48dGXV0V1ponQ+oXd32C+JtmxCmO403QupHA654SDFGZG1ucoLvPFL4VQfExVennhZFzV0wWizccVflywXMspsX6wFVE8iGdg5+qd1tJ862dbhcqKMimBkmZ6TOAXwY/lsodMljavtu9i5n2olsY/L9A+tGj9NNRipS7psp2nw39j3Rixm7UpgWMCDeRGYnglVnOEGO49IUY23cQoVpvNGw6XxZ6Toq6A1AXRwHxsGLdWIHgv8nwLBdHdKUOqJp4v5UHm/RaWYE9vt9QRAuXGDg1cec5bnuqwuOvg2DxrBFXi+ZcH48cYujIq/ky+kQpKC3Njnkhju/mfxzdY1hmgQ+D/ylq9wdnxgJqaGKfRlo750tm88
 Lf/Y9tIM
 R88kRqa/7qZUDE3o/B9mSGvO4CSDvUP4cEKfdfIVoGoYGxI0jaQiaq91p4eY6HciTbcs24Hq9v/zZeM25B6/5dQ36LP5CA82zX43Jh62BA6AjXQVEwSpwAH2TcrbfdfdSu93TQ7YlYCVVfaodgxEXCv7+4c6ubqWr4mpV8/UH/oxXg5DW9Fa4XKEB/cW+r0441rCwCTPwBK5Ej+fz98cyHLZ5tHLqETD9VZvsIQKIb+FTC7oaTp4mOyjlTkx06cPfgz742AYgWIALf6C1b4iySKhTDIN5GVinATvvQltmM43r0iUg1RvWr7mda06rvZxY6BqS9N45EqkrDfGXysyElO2ug4fgQWDXTpA0H3n6h51/BaZq0TqSBPkL0ABe+S7QDf2wOhA1PS8aJ7SLRW0oz4WBDife8zfLptIsBRpBM/KU6QvKybLMCZdgpsDdniYQn5OgkOtwb3e3ZKlLx9Y9XNWYq16uaakONVuT6BER+D41Xjix9MuKQEvcrnSVBbbcHBnBXTGriWfP5oHBZmsmBrHwxCuA7zxEiiwemfIAc11K7JEjGyee6PCQBMUl0IFpt0GzVinEjfHhAQXYJRgpeBIWSBuv4DAPXqlSVLdjPk4C43ZJHNHDVto/XA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 02:41:07PM +0100, Jan Kara wrote:
> No filesystem calling __generic_file_fsync() uses metadata bh tracking.
> Drop sync_mapping_buffers() call from __generic_file_fsync() as it's
> pointless now.

Given how much this changed, maybe rename it to simple_fsync now to
provide an obvious breakage for anyone trying to use it?  That name
is probably also better as it's not all that generic.

> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/libfs.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/libfs.c b/fs/libfs.c
> index 74134ba2e8d1..548e119668df 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -1555,23 +1555,19 @@ int __generic_file_fsync(struct file *file, loff_t start, loff_t end,
>  {
>  	struct inode *inode = file->f_mapping->host;
>  	int err;
> -	int ret;
> +	int ret = 0;
>  
>  	err = file_write_and_wait_range(file, start, end);
>  	if (err)
>  		return err;
>  
>  	inode_lock(inode);
> -	ret = sync_mapping_buffers(inode->i_mapping);
>  	if (!(inode_state_read_once(inode) & I_DIRTY_ALL))
>  		goto out;
>  	if (datasync && !(inode_state_read_once(inode) & I_DIRTY_DATASYNC))
>  		goto out;
>  
> -	err = sync_inode_metadata(inode, 1);
> -	if (ret == 0)
> -		ret = err;
> -
> +	ret = sync_inode_metadata(inode, 1);
>  out:
>  	inode_unlock(inode);
>  	/* check and advance again to catch errors after syncing out buffers */
> -- 
> 2.51.0
> 
> 
---end quoted text---

