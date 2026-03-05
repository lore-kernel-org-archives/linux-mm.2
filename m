Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB115F3D32D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 16:26:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FA4B6B0088; Thu,  5 Mar 2026 11:26:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 218A26B008C; Thu,  5 Mar 2026 11:26:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 119D26B0088; Thu,  5 Mar 2026 11:26:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE0F96B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:26:06 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B23C313965F
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 16:26:06 +0000 (UTC)
X-FDA: 84512536332.12.97FE844
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 753C91C0008
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 16:26:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="O5N/ugDf";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9pOq8IWi;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="O5N/ugDf";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9pOq8IWi;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772727964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VGezUwpGLCZyfFsnbu7s9tP4TEmi7eYjBzsMCkw+Gog=;
	b=tzwUiwCZHaQcU665KgAjtxyk2qaVRzsMVz5YZ2/WKWBQyc3QqyZ6BCRMdLTwhWBcCjmgU/
	OqkOh8mWKgNewNgLVFf1R/ecKrmJiVakK+Z7CXcEA3I1UNLj0vyKClKm+wY34uVLawGyPp
	zobwISRE8ptaJIhcIk3aT30ECrOlvIg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="O5N/ugDf";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9pOq8IWi;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="O5N/ugDf";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9pOq8IWi;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772727964; a=rsa-sha256;
	cv=none;
	b=7CfYPtYNu4ftjR/z8irzwQtX32GO8lM0QKgKKVCJd+gash6xAWi7rJOScVnLq1ifnerQRD
	wmRh6gdaz8+Ym14qmCqSXUIulAvTFWQ75nRB6I/mH1k6doM3CV1jgkjS6jE9bA4yZn18oB
	6bMvQnIn6SvgJLGVBU6r0S9hOBXXsgM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EFDEA5BD0A;
	Thu,  5 Mar 2026 16:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772727963; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VGezUwpGLCZyfFsnbu7s9tP4TEmi7eYjBzsMCkw+Gog=;
	b=O5N/ugDfDf+EKx4H5We7WyyuAbOI6DVQZfA4VZS3BtBKV9d1WOUju5wFJxoyIpnRFW57/A
	8DHxy1jWDRurrt2p1Iw6YjxrtDBiUwonQ9dpn/Zqg2tDTtnXwUzzVR2cpzF4r8wuQq/g37
	OdpFB573MMG2TC7cykRZ5rKdf+Vb0hM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772727963;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VGezUwpGLCZyfFsnbu7s9tP4TEmi7eYjBzsMCkw+Gog=;
	b=9pOq8IWi3c4YFHD/3lMN0Ti9PI1JTmjf0/uqQG1n/wuEQ3bTb05RZlf4KSgIxT9Z6i7CcR
	6bNutGvPV6j0YVCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772727963; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VGezUwpGLCZyfFsnbu7s9tP4TEmi7eYjBzsMCkw+Gog=;
	b=O5N/ugDfDf+EKx4H5We7WyyuAbOI6DVQZfA4VZS3BtBKV9d1WOUju5wFJxoyIpnRFW57/A
	8DHxy1jWDRurrt2p1Iw6YjxrtDBiUwonQ9dpn/Zqg2tDTtnXwUzzVR2cpzF4r8wuQq/g37
	OdpFB573MMG2TC7cykRZ5rKdf+Vb0hM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772727963;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VGezUwpGLCZyfFsnbu7s9tP4TEmi7eYjBzsMCkw+Gog=;
	b=9pOq8IWi3c4YFHD/3lMN0Ti9PI1JTmjf0/uqQG1n/wuEQ3bTb05RZlf4KSgIxT9Z6i7CcR
	6bNutGvPV6j0YVCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E24023EA68;
	Thu,  5 Mar 2026 16:26:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id C6o0N5quqWlDcQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Mar 2026 16:26:02 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D2CF4A0A8D; Thu,  5 Mar 2026 17:26:01 +0100 (CET)
Date: Thu, 5 Mar 2026 17:26:01 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, 
	Ted Tso <tytso@mit.edu>, "Tigran A. Aivazian" <aivazian.tigran@gmail.com>, 
	David Sterba <dsterba@suse.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, linux-aio@kvack.org, 
	Benjamin LaHaise <bcrl@kvack.org>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	ntfs3@lists.linux.dev
Subject: Re: [PATCH 19/32] ntfs3: Drop pointless sync_mapping_buffers() call
Message-ID: <e6fzrub3lvas5uigxiwgw2qpukjlfj5ifikqvvrn5bttgigvoo@riarrr4smkgs>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-51-jack@suse.cz>
 <aag2nTROMNra7t6l@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aag2nTROMNra7t6l@infradead.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 753C91C0008
X-Stat-Signature: 8j4qi9fot5643tqckr3s7khaf3ars7ij
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772727964-928191
X-HE-Meta: U2FsdGVkX18ZjlK5LrFYvcZc3gcpQJF0Vbz6L5q43Pu4G4MMuhYwMhGFjkvxO99fRiRUM8B7OONPagHuv/4vBYjevY4Bd21rtlGl24DUnT4KPofgOV1cfqCqzwfP2cyPbV7jBmS49R1rPCUfI4Kj0viZQDlBY7hHggB+Rp2zySoMpwE9tBq+0AEif8Y7Thdjw6a1OO06tWXD14CI4rU39IcKG8YtmomRWe0vKSWkELVjbpG25lWsYDEr3fMMmKKIL2S/4RL+uRT9cGv79w9PBMZrKyxsVSZH27jwovWf0Shku8j3TLgf7FyfhvuycjfOpKMWVCPo+1OogOurDfKn4zbdPoqTrmnKWja8f9I+DBMCR4dhMJnrdn8sHoPdK5ILs1rrgyfdmh3G5ZSpCPVYCNDIvD23Jzhxet0XeAeXEGJJD0EQdlRm+o/WZOsg+ubbj3f4yVLMebzdIzSAuvad4R1sV+wKhxHRgw0qlQeZSNs3duJs+aEJjv6nTRgk3szwWhiOBCfnEF/8Xf2sBt2u0osvaF13/CwhmyVp/06gW4Psr6VCyHigjLi32uR9YN+T96QWX6JtVg+JLMm5An3rlibUPLRM8pjrvDJgCfpjGPZBDI/Y4KY8pz1xBFg32ZFH8t2ABKbGciB+7TCy+UvDtpeQhI971mBvLP2SeoRNL1wA3KynCiSoDPZ8yrITSnMtYHSefH6uYlIa9zSjklP9sn6AqgNuQ/fWzxanPnRY20naD5U7ByzvySi35Y+8YQjSHtgj01w3TsKC908MZM3zZ+HpiT1Pdv+Tt+jiqtksdQFcuaO+K77gBOevSDvq2b2z7W6bD2U3p8LS1DfkGeUwNTTl7BBC5Z4BEPhVj7xUmANnabdJZkg5aE06WX6cbOtUynLf3yp8VWFE2d3ctTh+1ak5mJIY1S+s0tkOFlbGakw8wRdx4fzFYDRa/NGdgA62793ZhpOEPGEv3pdIjbj
 YqTEEouz
 YZZHCkrXl6IzUljk3587YdmoS2EhcAeK8D2xnh9/MOHPZLrU72lRSuOYdvMYF8pKVN28EhORMvfrSNyRIrJCKxGKR2DmW0zMhjaA27ca6+wNVinct3W5x1QIp2gF6Y3hiq9KRfwUTaKCeEk2QfM/LxOhqfiaJRVuBfssyQ1Gjq0/w6HRLk/zoraOutwdp/x/hrR/6q/s8MFjncOuaB80xkuKWJUyYah/YUV/OP9Q9aV37Jdj4/K9zvr6v9c2ITf0W+XTXsm81GBKFFou1oOkZ+IenrfNVcobG0rZjTpQG5I+8igpbOE5stT8crySKmn9QpOQtGmuXqRr3n6faVmVjxbye3y+eO0QxQ45Z2asps1PjYrj2eygUFHIoNqz03twOdk1BB8M/EUhDmmaXUIOGnz/0JVt2t+6MrqKYI6qTTrgbGAeYMPelJ+MuPUtYGWm3VzeOBEM9IHBZMak=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 04-03-26 05:41:49, Christoph Hellwig wrote:
> 
> Can you move the various cleanups that don't really depend on any of
> the refactoring to the front of the list?  i.e., drop all the useless
> code first before doing real changes?

Yeah, good idea. Done.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

