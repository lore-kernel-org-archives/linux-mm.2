Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 657E9E9A77D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 12:35:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A12716B008C; Tue, 24 Mar 2026 08:35:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C3286B0088; Tue, 24 Mar 2026 08:35:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D8CB6B008A; Tue, 24 Mar 2026 08:35:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 79B0F6B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:35:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 510455A073
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:35:02 +0000 (UTC)
X-FDA: 84580901244.07.9C06216
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id C8A9620008
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:34:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c1xtsd9g;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=04c7WcS3;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c1xtsd9g;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=04c7WcS3;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774355700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kOD5J3EgQ3eewOupxViyCrtb2bK/f0J4VPnZdwhvBJ8=;
	b=FH82CjsoJGCB1vmc4gfN5DcYef54EFXW7V57z/w3B/N7+vRXEDo0YxxeowKmZId+3p0pBQ
	mzRfzYhG6eySPXERn9XK/kaMxdjsayjaIrPnHQK5yunvuS1H0rpxScvyMi5wq8usgNhhCD
	TAmsyau3qjZpmKa5fWlmeIkVgsZAm2Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774355700; a=rsa-sha256;
	cv=none;
	b=mkcVnhG16fJFkaI4s+ONOJdz/cTNfPImuXecbhSYjidcbYq7Ncdz8yLnQ2OSme9iDepwTx
	BJsyCWphYaOnT23jbxNzPnXEhFgA+xC8od12tp4EjQ1nMvjPTPCk+NEmBZW0qa57u0y+A1
	aldTejmdfLImedc19sj/vT77A3QU2aU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c1xtsd9g;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=04c7WcS3;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c1xtsd9g;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=04c7WcS3;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3E3EB4D372;
	Tue, 24 Mar 2026 12:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774355698; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kOD5J3EgQ3eewOupxViyCrtb2bK/f0J4VPnZdwhvBJ8=;
	b=c1xtsd9gHrgpbaU/tq8WoUFUL3pyzhwgH/OnjBvkZ7vthOkASyofP3Jf1csg9/K7Xqz316
	zh/mM3d8HzS4ga0c0PyIVCXLKGqT4uTG1ps1wkDzgVuvjNaTJvlnGQib2ogbYQO6TW5ZFT
	nxPxqQAsscaJzmWuBsFFe1vrUczB334=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774355698;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kOD5J3EgQ3eewOupxViyCrtb2bK/f0J4VPnZdwhvBJ8=;
	b=04c7WcS3KaAArdHv83GxCHNeWZxVlnvpswo6/zkGMwnQHfXT3GjX9Eze8EbUi4SNRHNvjm
	REyfdEiPv7jg5jBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774355698; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kOD5J3EgQ3eewOupxViyCrtb2bK/f0J4VPnZdwhvBJ8=;
	b=c1xtsd9gHrgpbaU/tq8WoUFUL3pyzhwgH/OnjBvkZ7vthOkASyofP3Jf1csg9/K7Xqz316
	zh/mM3d8HzS4ga0c0PyIVCXLKGqT4uTG1ps1wkDzgVuvjNaTJvlnGQib2ogbYQO6TW5ZFT
	nxPxqQAsscaJzmWuBsFFe1vrUczB334=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774355698;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kOD5J3EgQ3eewOupxViyCrtb2bK/f0J4VPnZdwhvBJ8=;
	b=04c7WcS3KaAArdHv83GxCHNeWZxVlnvpswo6/zkGMwnQHfXT3GjX9Eze8EbUi4SNRHNvjm
	REyfdEiPv7jg5jBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 355E543E3A;
	Tue, 24 Mar 2026 12:34:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4JAFDfKEwmlhcQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Mar 2026 12:34:58 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EF8C1A0B32; Tue, 24 Mar 2026 13:34:57 +0100 (CET)
Date: Tue, 24 Mar 2026 13:34:57 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-block@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 12/41] fs: Drop sync_mapping_buffers() from
 __generic_file_fsync()
Message-ID: <ezdm6d34jqdrcohk7o6wycxvvlgtf6aqenwx5ffr3plfagdbzi@gibz7xwr6yhr>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-53-jack@suse.cz>
 <acIjxUzWFstarlwv@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acIjxUzWFstarlwv@infradead.org>
X-Rspamd-Queue-Id: C8A9620008
X-Stat-Signature: kz98z6y1djfekqndnm3pfxoqhyd1r1yx
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774355699-686288
X-HE-Meta: U2FsdGVkX19yqUPR1+BqMwbYBtsQ55m1Z413aH36wzboNdUaOoeFlthEoTAk9ZHcaYkMRtGwD+uh032yUf3xejNV2bOYsf3DcyNixWVEyocpd9GGD/z1YC7zihFDSXnb8dsjyedNrfxl5DeeAWr8pdCuy7ovJlmk0DJMarijcW5eg7ljW5b2k7WrX8GAr/GGD2FHUZbfZ7bTX/JXinexiAr6uAkqrHze8/l/dyfqtEKg+J2NwpklxIHCjzLU3C5c8vPcaUSRSMlMCLKPVfSmzZZrwiwWarurlpS4JyEbJArSb5YdVtuK1D1VhO1RpkbTmByjfFpIT/02BeVrDpHQAAR1YSLXmchMslv/C/xhZSWK+tvJ3MBYK27XWzjsK2R2N0ihAtS2WYRKDu1dclxDOO/l0h67A7d0Ktzc5Gxk178VjBHgPBXJDVoHM6EeZzDfci1hNQU3Hxa5L+U840sLIqg8IjB6qaZCCh8izMSaSwHl/jf4YyoStUn/EE3QoZUj2P57D5tyOJk/9nAThCDSbbpI4OhQVPtMGITYdQ1U7fqQ3O4fGlUcNEw761FDgz1/edLcmvTV4h7V96qWSMciyKMOJt2AVIdrr8i3LOz7zjrr24lvEckXFqB1xnoYcCP0RJEUpBiTm7vgOZMj2qRNiLwCe3ZxF407QXHoDSl9YNZzvUzW0b7qJnLMOBp3DUIQpWGQZ9rhOpDg9UPv2RJWgDq9ZmI6gbaoi9KpHdsBcEJfZGMMllmrc/+WUtRtX0pG5dtuLSDiVl6qdqw23IqukTyKeO4y5GZIAru2G+LtwiIhgCFHyJPcibJS2B+PjJYlEqBJDvEvVjbaqiQ5ERT+yL2/keaUw8kfE++BM01ahz+dQFRSz2rvDJPlvRRpldCaGowX9zDOjEnEvLLKj6eNIZAYI6T1BzxjVwlWVMO33+KbZew6F8F6lBwHuMOTnaxCahlfWttb7ejGUq8KnxO
 OVrdNgWW
 hbQFfTDBcgjWpwV5NgkbcgDJUI4jQEn5+evK5THSNHsWsGTPs8uCPuymX+h4cXKkGY2cyuywyOcE4n4T+anZuqjgOcWDpGpyaFxZEqTRLyrdbr/hVqkcWMZ7DJwQbLvF9vGq0uek0zTD3Pa2j4WrUDVWmQ3rHkj+JbjxziG/nRwToMXM/UVGI+ZB+K4d4tmALPqWEoLLZpG3PXV6FRBtP4Ui/tH4MstVIU5+C3iCBKhiT2yLotJM4ytG1CH6OW6T54it/dR8zvtfZJMinIiu6tt79yTIq58pOYCnqCbo8rTP14ekaDGVKYjLPUQNHCwcNzeYJmDgSD4Hw1sBNm35+/Aj53kNF306XqtPKJrMV89BQnEJDUnXUgX9LsqrClN8vBM8zNmrhRVq9+w7B4S8lKkWsL9YvVbUXsMjHmk/C5USIs1CwNprpVqOC8+JfdYC4bqjL2RUdEsNyrlg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 23-03-26 22:40:21, Christoph Hellwig wrote:
> On Fri, Mar 20, 2026 at 02:41:07PM +0100, Jan Kara wrote:
> > No filesystem calling __generic_file_fsync() uses metadata bh tracking.
> > Drop sync_mapping_buffers() call from __generic_file_fsync() as it's
> > pointless now.
> 
> Given how much this changed, maybe rename it to simple_fsync now to
> provide an obvious breakage for anyone trying to use it?  That name
> is probably also better as it's not all that generic.

I'm fine with simple_fsync() name for the helper with the trivial behavior
of writing out the mapping and the inode. Code wise this will look somewhat
different given what you've suggested for the last patch.

								Honza

> 
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/libfs.c | 8 ++------
> >  1 file changed, 2 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/libfs.c b/fs/libfs.c
> > index 74134ba2e8d1..548e119668df 100644
> > --- a/fs/libfs.c
> > +++ b/fs/libfs.c
> > @@ -1555,23 +1555,19 @@ int __generic_file_fsync(struct file *file, loff_t start, loff_t end,
> >  {
> >  	struct inode *inode = file->f_mapping->host;
> >  	int err;
> > -	int ret;
> > +	int ret = 0;
> >  
> >  	err = file_write_and_wait_range(file, start, end);
> >  	if (err)
> >  		return err;
> >  
> >  	inode_lock(inode);
> > -	ret = sync_mapping_buffers(inode->i_mapping);
> >  	if (!(inode_state_read_once(inode) & I_DIRTY_ALL))
> >  		goto out;
> >  	if (datasync && !(inode_state_read_once(inode) & I_DIRTY_DATASYNC))
> >  		goto out;
> >  
> > -	err = sync_inode_metadata(inode, 1);
> > -	if (ret == 0)
> > -		ret = err;
> > -
> > +	ret = sync_inode_metadata(inode, 1);
> >  out:
> >  	inode_unlock(inode);
> >  	/* check and advance again to catch errors after syncing out buffers */
> > -- 
> > 2.51.0
> > 
> > 
> ---end quoted text---
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

