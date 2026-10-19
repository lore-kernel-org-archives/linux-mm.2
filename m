Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6268CCF2D3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 11:09:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFD446B019F; Mon, 19 Oct 2026 07:09:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BADFD6B01A0; Mon, 19 Oct 2026 07:09:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC3946B01A1; Mon, 19 Oct 2026 07:09:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85A686B019F
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:09:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1E719160719
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:09:13 +0000 (UTC)
X-FDA: 85339104186.05.CADD18E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id D0C4A160005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:09:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uBSHOhtp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kCVNaaB7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CXRSV57l;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=68FWpfje;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792408151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=11z2qWpi42Rwu8TO6o4vcVqXgXps69LtjAEf/dfd4gs=;
	b=e0A5nH3yUD+oELOSW5L2POEs84MLL9+Kw22wOaNMl/ivbpysRbWCnMIOZsCsGyTK2EPPf9
	BIAXkpN4lbq4nve5ZReYnLlmFDJgt0dJhb5eWe3cW8B6o/NirHOLf3VC5q9WuQdVfVmaI1
	wZIvm9hXhFKOLQSXRcPlGvOMYRhzdEo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792408151;
	b=PSbkYoZ4j/5WrjOvYqudtnIof2F9ABR457OahV5/2acrSavNzcBiK5dhh51nrl7u7CpZEK
	i01Fty0TKqihiNJszylEnuUU69BVVWgdiTeMmLyH897CBd+6TK1CYIaPcTlFDbhwLrECTS
	Jq0RIEgMWAXnTALAZ5eyQuCVODULVIY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uBSHOhtp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kCVNaaB7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CXRSV57l;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=68FWpfje;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 28DDA21C92;
	Mon, 19 Oct 2026 11:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792408149; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=11z2qWpi42Rwu8TO6o4vcVqXgXps69LtjAEf/dfd4gs=;
	b=uBSHOhtp3N7zzu3OgYJq++zleXKxOfWKjoAcx+1adMUV32u8cf/syk7A1pQTgWe/RqbXJw
	OsY5yJUHMKn3ovxDw2CQ8zSCZahYL3r3P6P1uOVxmFT179ii8QAbJsj7bolDLMjSNbfKnd
	7p5Nnx6jV2pBSCAk0gSg289OTex6NTw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792408149;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=11z2qWpi42Rwu8TO6o4vcVqXgXps69LtjAEf/dfd4gs=;
	b=kCVNaaB7xxJF1vWsrl2M4Xd5XpSBb6HmwIA34PJkN7xKQLC0udKbkUcAsIMQ2Ss9y7deQu
	AAo70dVcO77nlQCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792408148; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=11z2qWpi42Rwu8TO6o4vcVqXgXps69LtjAEf/dfd4gs=;
	b=CXRSV57lKvfRhATV4ut3Akmw4hB9UONE1lZXC5L9sfHFMzUY0V6Ii7C/var7jbJhNeV6QI
	3a1v7F5tuBMRw78zrxJFdWJklOTDZa2gL/exbjmNLfYO+KJxfOKSMszq5gDD3JwBkoH0H8
	x8YJemM+a+0RM7ofEavbbSLJMMFlBNE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792408148;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=11z2qWpi42Rwu8TO6o4vcVqXgXps69LtjAEf/dfd4gs=;
	b=68FWpfjeq6UcQMaP3zVS3ajhrCp2oNgj+QGpTbM8zPio3CAqV0Fyr+x5Q33EL1eLvxbRfz
	PsvkCEiXB086MSBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F1E7F134B3;
	Mon, 19 Oct 2026 11:09:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id O4YyM1P61WrlFAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 19 Oct 2026 11:09:07 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8311CA1413; Mon, 19 Oct 2026 13:09:03 +0200 (CEST)
Date: Mon, 19 Oct 2026 13:09:03 +0200
From: Jan Kara <jack@suse.cz>
To: Nikolaos Karaolidis <nick@karaolidis.com>
Cc: Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Zhihao Cheng <chengzhihao1@huawei.com>, 
	Mateusz Guzik <mjguzik@gmail.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] fs: rotate inodes whose page cache could not be dropped
Message-ID: <n6urwkuqd2vr6ednnp64y2a7tbgobbdwmog5i3plxtidb2goq3@ph52n25jnu7y>
References: <20261016102515.111285-1-nick@karaolidis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016102515.111285-1-nick@karaolidis.com>
X-Rspamd-Action: no action
X-Stat-Signature: aghribntb6s9trd1wn63977c5z5fcmzs
X-Rspam-User: 
X-Rspamd-Queue-Id: D0C4A160005
X-Rspamd-Server: rspam10
X-HE-Tag: 1792408150-48214
X-HE-Meta: U2FsdGVkX18ShfRaaQAXuGGhtifxyCnHxNLGf6D6eeVFOtfuODpTNImMBoCw6C9P9wdMjbUrc6PlKSTDTc0G1zqdsict/1CkaqjgYRgpLFUNFQf9wWtfD4hVAk7pzq/EbhurbdKMy38dqeIocnvkzZtkrRZGN/WTHljWxObREu2uICAJgnFHtZGfNZ46ANcHqAOcjGWjWMmw1CShWsPsfq8pSm6b+Y10Eh8ZBIPMe+4N9yZfO9yLFHctvCU5HnspNpManz7rd8vrmAI2kY6HM7IsdMiJZNLnBwJY9ZW+5Pqt6CpVVpn9mYGyy3WrkdDNyuAZFlYvS+NbsHVmHIlMBloAYoFWb4gqrdBOd6XDcOefMP27HFzDhji9HQGiL9RxVDkA6bkknSSd+UvxnzXkp4RkeR5+eI4Vlx6SrhBnItkAJaePqTnfVSJgW9fSuDDyGvtCsibIF0QBuFRaM6+laMpY3QeV9keEMeA+/KA7RZepZzByXqLatwSNht1knhH71+A1IUosffhnFmxWQ7lTlg7bMHP/EyKfl+zzSeP35MCJkCPqosgOPV802glM2LridAmb/t4ruMmZ39vl6QgUqcYi+Nj0kUlAl8/C+mnwO02L+S3TiVfpa6iqXpW8d45hS4SzLeEV+paCTfZoIim7LN6dn7fg1vK23ikuQ+yu6uNWyB2FpR8UQUgPOzKSII2xI/SrxMvbaQwdoIpv8FV+4ZuD8PzVwNIsf4AVoydlOURTbBHi8vF7npcAXn5jO8yp5gNZP8LrPStudcGTn+afMNOvfVZp4GXP3oBzdd8rfTHji30dsgfg1f39Hu62FpiUr17P8kcYp36fZODMaG45grTkKjwyqQHTKhyQ2zS8N18JLiREahno27R1q6yiBoKuRlSwdHci6yoFDiBV9pwsjiJW0ng+PKRKpQNA+gvdU7IA41U3PK6l2RrxXjjoGROQHg9op9t7N0s1h1caxI1
 r3j4pJRq
 glRGiCYvBTYgks8GQV/kpkPD/WY25o1fMtG7sZOwQx1S29u70zv+joa6peN9fWtJcfxSTF9zVOVhV9WW9ehN23A4NSo81+s5DoO3lBeU4jbtBF/4Dak11fPJLuu85RF2wLbEiy0CDgw+WCnX42SLzDuL0HwGxxXbQ5eBOXCAm6eUltOS9rYcyijAJ94q8tH+0VaI98jkGfsEnFbECbs2Z8MAChSuRSpcZPCYyEG1x+hyqTKLwSZQrkj4lrPvNKJm7lrIEdPIOpLVy2MdHG7/0nrn/yE45UepQTi7H7nihLYRZljeR+Ew2AxaUn1WtSEWv5VYJDgoLIzkaKoZOCrAAvzpBN4rFNkYDc/xxxjbNaUDWg7QCyaVKPv+17ZUTcqLFMi6Ej0lg9cYx651RiWsTDhf/gsgePO60ELuOSVnmz4HEQ9k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 16-10-26 10:25:15, Nikolaos Karaolidis wrote:
> When inode_lru_isolate() drops the page cache of an unused inode, it
> has to unlock the list, so it returns LRU_RETRY and the walk restarts
> at the head of the list, where the inode still is. If
> invalidate_mapping_pages() could not empty the mapping, the restarted
> walk strips the same inode again, and so on until nr_to_walk runs out.
> Every walk of that list then ends on this inode, and nothing behind it
> is reclaimed for as long as its cache stays.
> 
> Before commit 2a0629834cd8 ("vfs: Don't evict inode under the inode lru
> traversing context") the walker pinned the inode with a reference, and
> dropping it in iput_final() set I_REFERENCED, so the restarted walk
> rotated the inode to the tail. Set I_REFERENCED again when the mapping
> is still populated after the invalidation, in the same i_lock section
> that clears I_LRU_ISOLATING. inode_unpin_lru_isolating() now expects
> i_lock to be held, like inode_pin_lru_isolating().
> 
> On CONFIG_HIGHMEM kernels this can happen to any unused inode: a folio
> is left behind if it is locked, under writeback, spliced into a pipe,
> or still in another CPU's LRU-add batch after being read. Without
> HIGHMEM it happens to DAX inodes whose only entry is at index 0, which
> mapping_shrinkable() lets onto the LRU and invalidate_mapping_pages()
> never removes.
> 
> Fixes: 2a0629834cd8 ("vfs: Don't evict inode under the inode lru traversing context")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Nikolaos Karaolidis <nick@karaolidis.com>

Looks sensible. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> diff --git a/fs/inode.c b/fs/inode.c
> index a9d37be390a1..1614a97ce953 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -593,12 +593,11 @@ static void inode_pin_lru_isolating(struct inode *inode)
>  
>  static void inode_unpin_lru_isolating(struct inode *inode)
>  {
> -	spin_lock(&inode->i_lock);
> +	lockdep_assert_held(&inode->i_lock);
>  	WARN_ON(!(inode_state_read(inode) & I_LRU_ISOLATING));
>  	inode_state_clear(inode, I_LRU_ISOLATING);
>  	/* Called with inode->i_lock which ensures memory ordering. */
>  	inode_wake_up_bit(inode, __I_LRU_ISOLATING);
> -	spin_unlock(&inode->i_lock);
>  }
>  
>  static void inode_wait_for_lru_isolating(struct inode *inode)
> @@ -981,7 +980,13 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
>  		else
>  			__count_vm_events(PGINODESTEAL, reap);
>  		mm_account_reclaimed_pages(reap);
> +
> +		spin_lock(&inode->i_lock);
> +		/* The walk restarts here: don't retry leftovers right away */
> +		if (!mapping_empty(&inode->i_data))
> +			inode_state_set(inode, I_REFERENCED);
>  		inode_unpin_lru_isolating(inode);
> +		spin_unlock(&inode->i_lock);
>  		return LRU_RETRY;
>  	}
>  
> 
> base-commit: af32da41b0327b9c6a37856ba82b6760d6c8d10e
> -- 
> 2.55.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

