Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ED63F3D31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 15:58:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9531C6B0089; Thu,  5 Mar 2026 10:58:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E4286B0088; Thu,  5 Mar 2026 10:58:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FBF46B0092; Thu,  5 Mar 2026 10:58:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 499DC6B008C
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:58:52 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 13AB41B69F7
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 15:58:52 +0000 (UTC)
X-FDA: 84512467704.08.F21BCEE
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id B72E414000E
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 15:58:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JkhDxXPl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KsPUrOhx;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wrtCN3PO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sfQacGrl;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772726330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LJXg+vftnw5Mo5x2ZpT2g9xazC6UHz2LjL0K5+lD4wM=;
	b=b+COBju7YUcCqvffpodMFplBTdKiHLfvZKYkETZPP4HCIbTuT3xJmJTyGUYjJsfvWWJWa2
	U7V+mWo0NoY89zcrz2pC0rfREZaDCyf3RuPNQ49MsIXtjJAWtpKmf/tPnPtK5art2lW1R6
	x77UFPALioFkfqGfmI3C9HHK+6MqMqU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JkhDxXPl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KsPUrOhx;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wrtCN3PO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sfQacGrl;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772726330; a=rsa-sha256;
	cv=none;
	b=bd+4zfxuov8naBQEL7EwwHIq8rTn0ttquGk/T4EPf+/QGgumtoQHB8B0D4vRpxlx7vsEHR
	jEzHg7E9it7NWl8krbw3QkPcDhCUhkDPjO7szSIM/QNcH2iZBY1gaHV1fecWiEk99RxK4g
	Gi4S+K2JUV9dmH7kZsdpZIuyk7QTffA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E9DB83F839;
	Thu,  5 Mar 2026 15:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772726328; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LJXg+vftnw5Mo5x2ZpT2g9xazC6UHz2LjL0K5+lD4wM=;
	b=JkhDxXPlgQjJmb0E2pzqpJk+LHkOYZTnOY1hzyRJ7q6s6cGnoJndBVbHPfFrBh4zgQHmkH
	08a/tBUE881S8g7p8TvuJB21fz7aIgIStdkUbtpCr/Qb6Jo3fkErL75cxLXy8q2YuPuDDu
	t2medxKN0PnV0HFATuWgmEBJplIRG0Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772726328;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LJXg+vftnw5Mo5x2ZpT2g9xazC6UHz2LjL0K5+lD4wM=;
	b=KsPUrOhxtzKsyW0tgrmp3p/QJhaca7rZZ2nW3xXIwr3dOnsHDa3RlbuyiCxrhxMOVO/wq6
	enNiu4fOyq+cjyBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772726327; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LJXg+vftnw5Mo5x2ZpT2g9xazC6UHz2LjL0K5+lD4wM=;
	b=wrtCN3POPAThilnI14sAsV64KYlG2/pD/S3/5Dh3i6d80z2PpcBZQs51MWzSbKrRldd2Q0
	+UmwndBhAOUeg5kQHyxDI9pZptVHxTIoRuxf3eibQRzfICnXUnDWDHct8VqMmla3zSpzSf
	/ix3bOcU1sUfD2huBx0xELUm2R5Ebzw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772726327;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LJXg+vftnw5Mo5x2ZpT2g9xazC6UHz2LjL0K5+lD4wM=;
	b=sfQacGrlCFPc/m/Qg1FzPsVgjbVlfWlphyvQ3s408m5HYKbVLdItQ9XGqpD3Bwy0gKcnNk
	pA16lG787FEUv8Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DF59C3EA68;
	Thu,  5 Mar 2026 15:58:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PAd6NjeoqWnwVAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Mar 2026 15:58:47 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A1CC7A0A8D; Thu,  5 Mar 2026 16:58:39 +0100 (CET)
Date: Thu, 5 Mar 2026 16:58:39 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>, Jens Axboe <axboe@kernel.dk>, 
	linux-block@vger.kernel.org
Subject: Re: [PATCH 21/32] bdev: Drop pointless invalidate_mapping_buffers()
 call
Message-ID: <b62rxpzd723jve3pqbjbmuzuetkebbzppelsuccdw7r2rmcblt@uea3ktei5jzw>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-53-jack@suse.cz>
 <20260304-dachboden-minibar-620c6f7d69fc@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304-dachboden-minibar-620c6f7d69fc@brauner>
X-Stat-Signature: i9guut78ahhspwntkudizrd4ny6itudc
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: B72E414000E
X-HE-Tag: 1772726329-32038
X-HE-Meta: U2FsdGVkX1/mqKZ/HWzqabj6bFaH31WjNtsmz1UetpoIPd9WHsTH1J4Qya6m/sFRW3x9lbDUZzSDLm/j90+ocAEraKFRuH1gEiSTwv/i4um2G3fkUX9o82nOxtr5RYRRK829Vv6EjAb1PamiR5OcZQKe7CxsLkDOruiCcH7zTfc0Q8sEpn5HXa7Egat07Eryj9z3/eJIzkfgoaXw6aSJa2K2mRUs4ckcEpX7PYewOJENzM480F+yJUUe+wHH6z7bjQljsL08gwJT0rIVDzm49/tT0BMTHZEUAJwbu4IChBOgwmUS0cCuVDPAX9PbcmANUYvsGewtaR67fSIkHhLlwDCbcRVNt7I0oMMYNma/0l8UmzMMMM+zKK+AxXKwIbQweGRoMW3t9QM04R+VGVce1NZBf3dyrySgHl16oeSBEDtXgF9/fn31zFe9odEt8JYJVsAwQ+vzcVEel1LCwMPYqg0Kdw3o4LwcezPYTez3xsPtNRu1xvehVw34YA7m9iPIu53ii5fw/TfK87wEjVp8Wl4yP8VwXXVJIdVxvqqUZoDitRm0efJy1mZGNhKdpCKe1cPR85TNp9vzFQC/fktMA7vPNpWi90R7tQSNYQ8Xy99THMfzSms5w+pLKy4xF9uk4s2UmTLC2gka+z90PP/CoumO4Uy6K0M4ZwSmChTowdSMOjHGyeQcolydtAnNGEh/yN/laR3Huqy1IJJagQFoXGE3F6ky1GCP+tgPmhntuDc+PjfQzL+n3/P9+EQqft3NnW8ZTClw6dq6BMYyGqU2es7N/4bRg0R7K1pAFGGfneXbroiQwz7ic5UFQrX56z2BEoeiMD2KKBmGgORD/svluAgJePjPNDes7l0n4P0TbO/vtl0o5CkGVgWhhdKCs3KgexZFSmBwMIOMaHWq/qDqcAY4WTIqs24hjmjkFblpWQsNJoQUkWtFmge60FBNaRB5lKkoumIHuc2egbwqCAE
 fXbKXQoq
 7gA74ym4PBbZN1MQjBN5oDC/gULyNnSPTyj6dOBLIXfvOSrjP4Ug16A17Fikl+l8CpqQSRm8OO2wbVNCbIUkEUy4kYZeU1Wxsf/DicDBqv73+1YTAeV1kT610W5z5eEmOl+iwCIZRvLjXgM44NB2IOlg4V6de59O9UIsd7lrgDccWqEg/4NBrTxrofykGfD1wXEnf1AxEUcRyX1KXOxWEq/739yTrJqtjzp3uvPOMazKkFQXOzWDR0R1iDBC+Qm1k0y4eaZEF/lbdx0tb71eTYpvG7HwTwfkDbRQqd8W5jT97JdHiPZJ8WjrFSeaQYRYiz5KSmK3g7+/k8au9H0ioK5o/NRoViJvXF60gZuN4u/59y/2H/aEMqJNgO28GotsY01vp+OalLbeIjf44XNMYSCh/HBbP6th3J1JxZDuEN60IW4hJzpLMiDattw8Ht/m0oeV905DagXIZfhT1qbS2ZvrOgznpA1xBaEvE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 04-03-26 14:39:54, Christian Brauner wrote:
> On Tue, Mar 03, 2026 at 11:34:10AM +0100, Jan Kara wrote:
> > Nobody is calling mark_buffer_dirty_inode() with internal bdev inode and
> > it doesn't make sense for internal bdev inode to have any metadata
> > buffer heads. Just drop the pointless invalidate_mapping_buffers() call.
> 
> s/invalidate_mapping_buffers/invalidate_inode_buffers/g?

Thanks. Fixed.

								Honza

> 
> > 
> > CC: Jens Axboe <axboe@kernel.dk>
> > CC: linux-block@vger.kernel.org
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  block/bdev.c | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/block/bdev.c b/block/bdev.c
> > index ed022f8c48c7..ad1660b6b324 100644
> > --- a/block/bdev.c
> > +++ b/block/bdev.c
> > @@ -420,7 +420,6 @@ static void init_once(void *data)
> >  static void bdev_evict_inode(struct inode *inode)
> >  {
> >  	truncate_inode_pages_final(&inode->i_data);
> > -	invalidate_inode_buffers(inode); /* is it needed here? */
> >  	clear_inode(inode);
> >  }
> >  
> > -- 
> > 2.51.0
> > 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

