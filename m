Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86E2B109C058
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 19:01:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA82A6B0089; Wed, 25 Mar 2026 15:01:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7D8D6B008C; Wed, 25 Mar 2026 15:01:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6C916B008A; Wed, 25 Mar 2026 15:01:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C40156B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:01:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 73995140A47
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:01:51 +0000 (UTC)
X-FDA: 84585504822.30.F19051B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 33B8518000D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:01:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZqfbS5nR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Jaay/3zL";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZqfbS5nR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Jaay/3zL";
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774465309; a=rsa-sha256;
	cv=none;
	b=11Enj/vbMMVy/ziDQXo1+FeeSRo4uQ5p2DY+i54U4McjaWJ2OQgBR2FbazdwVsXQ1tM/zC
	sxmIJ8ahGaYqmt2PMKdw+XAIdJ9VKznNTMunpQs3SnEfxRObQHYQaLbLO+csUbvwHbQ8v7
	63guoFYq6P1tFye+AEu9Q4LCpfuMA4s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774465309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G9vPzHvujrmlL6/Ao060FToJBZOtkxBhOjJhl9zBg20=;
	b=Ma3xJbWqb8ADDI1mk5FZBak4t8/Tp+k76akIvC8ZFgm33K03puTCb5KeKanUHLGy1JuRIM
	kK3szyNhuy0E60itCF8Fi8PGHwAT4NLtn7ujyNO1aUGAxacDOU6bs6HE81gtbQd+4rimZw
	6BSUgM6kf/WITG+yEtnt8d3aYnhXZ2I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZqfbS5nR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Jaay/3zL";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZqfbS5nR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Jaay/3zL";
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D19024D255;
	Wed, 25 Mar 2026 19:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774465307; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G9vPzHvujrmlL6/Ao060FToJBZOtkxBhOjJhl9zBg20=;
	b=ZqfbS5nRqIQN7ASSl0tgAsD9CEkLOQnUb+PvE0wNdq7++pSuVvlHaBk/4UeTmCnWh19tK0
	n8rv1ktVgAAw84Ui2Z68XWP06mU5rM5jKROPenQ7i3uvlRNdC5SmobEqu0rVnZQhiAD4yX
	3l1P3LNgAvruQzq7zRPOer5Zqovau/w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774465307;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G9vPzHvujrmlL6/Ao060FToJBZOtkxBhOjJhl9zBg20=;
	b=Jaay/3zLY0xMJOls20zL1o8DHuoGtyADynyPTsvFa6whl3AX7CVlkqhmwD27FiV38Fwn37
	ALx0zRt9HkZiExAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774465307; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G9vPzHvujrmlL6/Ao060FToJBZOtkxBhOjJhl9zBg20=;
	b=ZqfbS5nRqIQN7ASSl0tgAsD9CEkLOQnUb+PvE0wNdq7++pSuVvlHaBk/4UeTmCnWh19tK0
	n8rv1ktVgAAw84Ui2Z68XWP06mU5rM5jKROPenQ7i3uvlRNdC5SmobEqu0rVnZQhiAD4yX
	3l1P3LNgAvruQzq7zRPOer5Zqovau/w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774465307;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G9vPzHvujrmlL6/Ao060FToJBZOtkxBhOjJhl9zBg20=;
	b=Jaay/3zLY0xMJOls20zL1o8DHuoGtyADynyPTsvFa6whl3AX7CVlkqhmwD27FiV38Fwn37
	ALx0zRt9HkZiExAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C4AAC44559;
	Wed, 25 Mar 2026 19:01:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ogYUMBsxxGnNYQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 25 Mar 2026 19:01:47 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8655FA085A; Wed, 25 Mar 2026 20:01:39 +0100 (CET)
Date: Wed, 25 Mar 2026 20:01:39 +0100
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
Message-ID: <dqvxks5tdwgcumkucwmrz7ides6li4cjeyglghdidhljeq3sax@6kukcgubwx6d>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-53-jack@suse.cz>
 <acIjxUzWFstarlwv@infradead.org>
 <ezdm6d34jqdrcohk7o6wycxvvlgtf6aqenwx5ffr3plfagdbzi@gibz7xwr6yhr>
 <acKO3NRw852FdGUO@infradead.org>
 <rsftk7gdlamfryksv63vhmewdi6etvvfyi6as5m2zs75ctvzkq@fnoiwumyfdsv>
 <acKzrqjnKFNK0xmh@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acKzrqjnKFNK0xmh@infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 33B8518000D
X-Stat-Signature: 1t81tdc5amxub41q6nobaz1851onqof1
X-HE-Tag: 1774465308-674736
X-HE-Meta: U2FsdGVkX18d3nK3umL7fMGSjdtEd+dqqL6y6sN/ZaFn17TKE8jSKKper0xPmgHe7s/mEXR6Hy8lg5cj3cFHqdFO2j96ExLPVPyFATd5kgP1PC+BXTcOsRG4AKoyjKFSPE5oYJe5fXluxZGsYhpkUMfehnMQ+8lgohtkYByludSenHr2AHv5U1MUFH1yORrZvR9FtFzbarPPINRSwjBwTHjsIj3QPkWJzHGKgJjUswljwlw+osCiHgsXhspuZr+6ibAOX/dK4E2DtYva4jcMsAdwHoSa5oNNL5Pfq/LRQkIn4Ds/ohamEBD/QQ+jT4r0a00zfPc1BFHW+0+uQ/cPeQAQGv/lGalaS4z/XkX36KuHP9u6JbvKHd8HdTNEINf8G4M3+l/n+8xA5t21zasGxZeRGJ+Ye6h85OTcpfn8FHqamojgSdQdOp4yMGRuDrY2bz9T5Ur6nYsjCesS4goOOB1JKXmaFxB12866Hwm1sS61/npJZ+5unTC+IlqyFs61alMB7JO4qJCopipZCEihFTXWa/4dWJWnOZf6L22BWjJYzfnIanLvcpH39sWzdJmWOSpCMT1QXKYeilAwwAR8qQ0vfkVhLrSK3XZ5NIWYJUNloLZVbKvI8iMy1aG9OajwoIpyxmYpGfcdO8SjNWdakPsfK3s2SoJv5UbNy512U/VsSMvJNj52+uXbA2EYAVPTMnU4Gc2K+dPd2IdGLediejzWuiteJleMDu/62ogjAWuU0acoDD3Rkr3r+WPkTJaH92QtHVCthqbVUVEbZ1zvPdewD+Y/hzeYGwxYTDXzP1dGGMFxjuzxFb7qL6o08XsL+JBhX5eWeK7UEnHivKGCwNseNqUkObTrBt/Hs5fUi5HNcImKA+c2ySvZ8pWsJMz3nGv1G40tPocLwSIWMJa3/lfD62/3YDU6YS3tucawZCRKBUy8y83Mpi+5s5E3DAlmtB92ZdLiF/kXlxNgCWk
 GoUmrz+j
 sqKgGJEoetPqoSb10iDcV1QY7ff/AEyMqALAvj7+MbnP6HzcxofR8KDuGHbHHVSRM9iRmhPyIS9JELog=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 24-03-26 08:54:22, Christoph Hellwig wrote:
> On Tue, Mar 24, 2026 at 02:36:53PM +0100, Jan Kara wrote:
> > Leaving the two implementations separate certainly works for me as well
> > (that's why I've put that patch to the end because I've expected some
> > discussions around it :)). Just the amount of common trivial calls you need
> > to do (fdatawrite(), sync_inode_metadata(),
> > file_check_and_advance_wb_err(), blkdev_issue_flush()) looked high enough
> > to me to be worth merging the implementations. But I don't feel strongly
> > either way.
> 
> I don't really feel either way, and I really should not micro-manage
> the series either.  So go for what you think works best.  The important
> part is to have the fsync changes early and to avoid hardcoding
> buffer_head knowledge into libfs.c.

After trying with the callback and not liking it too much in the end I've
just decided to stay with two separate implementations.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

