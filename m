Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEB3AEB7EBC
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 10:40:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31B5D6B0089; Wed,  4 Mar 2026 05:40:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C5526B0088; Wed,  4 Mar 2026 05:40:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19A4D6B008A; Wed,  4 Mar 2026 05:40:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 038F86B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 05:40:13 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C5D901B80F3
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:40:12 +0000 (UTC)
X-FDA: 84508035864.30.0AC783B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 45EB1160005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:40:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZLHfxDTX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vPMWUlPA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=caQrhDFz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="EQdbKa/5";
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772620810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rR4mFGqDHT/6JchhPqj+UuMDZU2uzO46m5RbHchsX9Q=;
	b=UjdUa8YEkyz/G3IgHEihgkjyXZpaX6zLJK6W84NOdjLw6ocUrJ/lVhdA+tigCSA4D/lZX1
	T4O8uJww+5hxbVHikqFa/XW90uTAKKTc2d3Ii4mjGnscmcOvuOn6JpET80BHBzVw/9LaPv
	ugZGUVpVanpudz+cUNuTYbty6v3iuOI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772620810; a=rsa-sha256;
	cv=none;
	b=NocdwCuiXFN/8ySbQFUv243LsSuE7RNS4s4znRWi2GU128tWNRFkZjMh6MUSm5LYyyLyHU
	sSd6m7IS/7KpFctaZN88Qbulopn3UJJlhhNK26Zy4WZYJnMx3QoAjmdf50a189EfnaLFDA
	btU0Cuseu6YRe/VWQiX39vgMF8cMm60=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZLHfxDTX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vPMWUlPA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=caQrhDFz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="EQdbKa/5";
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D8C835BDA8;
	Wed,  4 Mar 2026 10:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772620808; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rR4mFGqDHT/6JchhPqj+UuMDZU2uzO46m5RbHchsX9Q=;
	b=ZLHfxDTXd88gvTNwT3Ka24ez2S2uO+QE7DWNBCtzYbuZ7c0T0KLd7MiPrl6scYLJBzo2JX
	k2PxZEuWNwkFXfU5hmf0pfHqrus/oL10yhiV5r7rfM4FEMaeJBBb07HlTZTM9D5KJByV8L
	rDDb0BPWWDzgziPy6DPJQayZDw8jwpQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772620808;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rR4mFGqDHT/6JchhPqj+UuMDZU2uzO46m5RbHchsX9Q=;
	b=vPMWUlPAvMcKnCjpWaRoY+5IIULMdThDQh/E/phutN6IJVmtAnfdhjsxaJeP9e0rMPJWXO
	fImmX3aUuN9KD3CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772620807; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rR4mFGqDHT/6JchhPqj+UuMDZU2uzO46m5RbHchsX9Q=;
	b=caQrhDFzbGKavIUQi1sqVT+7pZYAf8DcTE7/5PJZEzHbOy1ah2uO7h7uodxKaXMw7J5ohI
	9rNzEZWTkz4grjQSopVA0NT1eHaLZzUbJb3vCLR0NaEolmI9PF3DEmdjRkVH/uxVjyOye8
	6n1hLyU9N98qligXwpZRghTz3MISPmY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772620807;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rR4mFGqDHT/6JchhPqj+UuMDZU2uzO46m5RbHchsX9Q=;
	b=EQdbKa/5Zs3pYrJTTSDEqpLQN/0KujZA3iVGrDFUIUiIMswYPnTf3LXaIlnuGM6UOSZm/u
	jHyKsKAXtSpSzjAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CDA883EA69;
	Wed,  4 Mar 2026 10:40:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Sq0rMgcMqGknGQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 04 Mar 2026 10:40:07 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 93D53A0A1B; Wed,  4 Mar 2026 11:39:59 +0100 (CET)
Date: Wed, 4 Mar 2026 11:39:59 +0100
From: Jan Kara <jack@suse.cz>
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, 
	Ted Tso <tytso@mit.edu>, "Tigran A. Aivazian" <aivazian.tigran@gmail.com>, 
	David Sterba <dsterba@suse.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, linux-aio@kvack.org, 
	Benjamin LaHaise <bcrl@kvack.org>, gfs2@lists.linux.dev
Subject: Re: [PATCH 11/32] gfs2: Don't zero i_private_data
Message-ID: <yeexpqj7bu7y4wxfdnhdpmcb3zq2qyre4vuot6ecrkmwrgqlx2@odyk7234usmj>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-43-jack@suse.cz>
 <CAHc6FU61tUwnFf4pXWun_nLnL2jyUYHLKAN7C1hanbKk0GTZMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHc6FU61tUwnFf4pXWun_nLnL2jyUYHLKAN7C1hanbKk0GTZMA@mail.gmail.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: 6gpk68t56b7u76rw5cjfuc1fmsb6fp9q
X-Rspamd-Queue-Id: 45EB1160005
X-Rspamd-Server: rspam03
X-HE-Tag: 1772620810-660363
X-HE-Meta: U2FsdGVkX19hLggDb/+IWbglPpDKBIe58LALUd8ZZ90In7dJuxykmJ3ksi+z5P7WOG+4cabyJMnzJbPiW52p2sp569F0Wa1DaZifVX90BxQAHUfNv8sy9IracLCViAbiFwy89LmvqsTB6AYjHNTVjQOAZw8y9kz5o/5NODNgv5QJZmzbbr8EHtShxaE88wCoF1uaazEZJy640dQkm2u+zfRTEi0+Me758kq2MosqtHgbfv1CgKzZgz/9ERSGpPFM2FMUoonPqRxxYMDbcLzomFXEltE61IrPXkIJ23DD3DverGSjCa/DQtg5auF0FQiV/nQebmwtHqkcl5BEkBjHA4/RsRsKPhhlULfz2v5KxujR+45P8Evolj3Hd/W504flPJTyIx/qFYkGxOK4W2m2y+5Ezep2YDr25Wh0pR7I5+ZLD6LQMM3cWppoqxzNpkXzMxu+jSyyRtvk/d8rE+vpXVdFeso0TdtdoSluqkVyn/639JSBhzPM+h0Jn/ChqME+Pz4r9oo+4qfeRexC1CvdANccgrreLAXeeDSjAJxXpuaej+a6hm8iXJL4HbKpIW5AgpxG1CWQVbo2tp0l7Dwvw364QJyqw6D+ntzG0Q2L/l3S7xOqCL2v+lSJLxd2xza+DarhbIYqUixYDJPzFdJQHV9AAZ2+WX5u+VC6PTuQ3dRzmre/Om7KHTza3rOZ+Nekr6Bi6bLb5bFizVT/YV3Ir6tKapssLnzVDyilRNSuOHsEXlPsVQTeJG1euLyEjPtpZ4i19+TLEqspGC14QPkI8DduOCwUPR4rfXcXSMbMi4ysImCnUYSKOLM+UJeYxHVYEmQCUqv/lr5TezAlx8MzOsulBcGiyVwh1HUFifWeYutwM8my817riF00QkllrXu/ZUZ5gSJV8tt+JOp0TMUJl3qfoY69yIv7MRwRCQpeXfm8kNvmFWXQpDim32QDYGVhrMQKTbf9iFGFfropo/e
 U3ffxzxe
 bZ6tf74wsTkhZqifQa4O1sD51FAZy+cccbxgKtoNzo11P8IYcsjGjg0M/nkCJ8tzm3lBgNSguSopVHnWgkV6cOgXuAUuRQsl9F6bGB7u0LYDpo7OPiSZpyBGKZBguLtVjZ5fpKrWjlJBnsewI2bxp0oohjxexltJlHtyaxIftkqcMrXzny01NiUB6W1t4vvnkkA3HFVtp881pewKAIeg8Jpl1kXXbYZgT18//RwwCo/CNlO5iFxLjMKB9Wrrh0oRjMDVq/oB0g+AL14ICCdoKLFrEAFh1OS9XYrXakJZUZTZbkjULhklUo0EXvmVwbhcWMr5HBldT0It2pwg0KOkwYWY3nBkxIoSqN+S8/dszx+PP/Q/A9zr7fhALYhd9Eub42v334fkJCzD784TfplvDPD8bCxXkTGUxYaGBhlMeE+OzsG4mqjqVdRCrQhOdDz8IjsAAHk7cmSeEmVwhKhCcL/2CgztEGl2IHiRPp6I2EC+hn0u6mjrYGCW/v8/jW5RPuQ54
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 03-03-26 13:32:31, Andreas Gruenbacher wrote:
> Jan,
> 
> On Tue, Mar 3, 2026 at 11:34 AM Jan Kara <jack@suse.cz> wrote:
> > The zeroing is the only use within gfs2 so it is pointless.
> 
> "Remove the explicit zeroing of mapping->i_private_data since this
> field is no longer used."
> 
> Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>

Thanks for review. I've updated the changelog.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

