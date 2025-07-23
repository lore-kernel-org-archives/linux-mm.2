Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07636C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 15:49:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C11C8E0035; Wed, 23 Jul 2025 11:49:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 899278E0002; Wed, 23 Jul 2025 11:49:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AEEB8E0035; Wed, 23 Jul 2025 11:49:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6C1098E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 11:49:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 849A110C42A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 15:49:31 +0000 (UTC)
X-FDA: 83695964142.29.BC06214
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6796120009
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 15:49:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ysV8DPur;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="mmI8SqH/";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ysV8DPur;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="mmI8SqH/";
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753285769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RBoIe6DOYwbo/ooXZzBNUXT2Ob0AdnhJHRYgqQ0Ppd0=;
	b=wRfpreqb2pvdEQujKDaMvhpiYQ2oO9Jj+Jsv2Q6/pk+guxKTrxdb2rPqx6WeG+Fd5E2RYy
	oVRx3LJ2cw34qcd0lHqtqaF3DdGpQXRn+C+yQZPNCToWSjrf7ZMRqMgU2z2VJBYDMn2P1o
	qRq9kgkaSy9IrTLQUxMG7vQV+1dXwaw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753285769; a=rsa-sha256;
	cv=none;
	b=KPDMxRMpLHGS0ovEQT2v74natPWrWHgz08Z1HZBexP8wnMvGHg6og9ygpnof9B3P4LSh6l
	QqQ+ZxhkQsQI47SQP40PMqpsYtG0Z7EuUUWgmuz/IB7FZ+4Jrl00cjWIf+v4wzWOKIf77W
	N7Fh4PfuuKCMesOKxQF0LnqYZxo4lzU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ysV8DPur;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="mmI8SqH/";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ysV8DPur;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="mmI8SqH/";
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C0C90218EE;
	Wed, 23 Jul 2025 15:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753285767; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RBoIe6DOYwbo/ooXZzBNUXT2Ob0AdnhJHRYgqQ0Ppd0=;
	b=ysV8DPurYfiv0QrH6gi+mTpIEKrDb90juAZaWo64TfLZ9KG3oxoV2XIMoAgsm+uN1oimSU
	I8k8LAq7H91w+5AEfH2kY1UUPntZaTupm/7A41WR90NznJz3J2pkE6IWaCPS/bzBr2UrBN
	OtRxSDJXNMnowMhb00b4TfP70HFn9zc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753285767;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RBoIe6DOYwbo/ooXZzBNUXT2Ob0AdnhJHRYgqQ0Ppd0=;
	b=mmI8SqH/z1aA4BQ/COyObuJDZpcluUE3vaOIToK0US1+EbhoKsoBi/1rnORM6VK6IpCZ3y
	rW3NyLPSSiYZMQDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753285767; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RBoIe6DOYwbo/ooXZzBNUXT2Ob0AdnhJHRYgqQ0Ppd0=;
	b=ysV8DPurYfiv0QrH6gi+mTpIEKrDb90juAZaWo64TfLZ9KG3oxoV2XIMoAgsm+uN1oimSU
	I8k8LAq7H91w+5AEfH2kY1UUPntZaTupm/7A41WR90NznJz3J2pkE6IWaCPS/bzBr2UrBN
	OtRxSDJXNMnowMhb00b4TfP70HFn9zc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753285767;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RBoIe6DOYwbo/ooXZzBNUXT2Ob0AdnhJHRYgqQ0Ppd0=;
	b=mmI8SqH/z1aA4BQ/COyObuJDZpcluUE3vaOIToK0US1+EbhoKsoBi/1rnORM6VK6IpCZ3y
	rW3NyLPSSiYZMQDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E8D8613ABE;
	Wed, 23 Jul 2025 15:49:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1Em5NYYEgWjVSwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 23 Jul 2025 15:49:26 +0000
Date: Wed, 23 Jul 2025 16:49:20 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Bernard Metzler <BMT@zurich.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Jakub Kicinski <kuba@kernel.org>, 
	David Howells <dhowells@redhat.com>, Tom Talpey <tom@talpey.com>, 
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, 
	kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH] RDMA/siw: Fix the sendmsg byte count in siw_tcp_sendpages
Message-ID: <nwtutmewgtziygnp7drmhdxpenrbxumrjprcz7ls2afwub5lwf@due2djp7llv5>
References: <20250723104123.190518-1-pfalcato@suse.de>
 <DS0SPRMB00679C99808A4D85BAB6DADF995FA@DS0SPRMB0067.namprd15.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0SPRMB00679C99808A4D85BAB6DADF995FA@DS0SPRMB0067.namprd15.prod.outlook.com>
X-Rspamd-Queue-Id: 6796120009
X-Stat-Signature: nkr7h4p6aujrqpnsfi48a5dq7yw1xhs5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753285769-113891
X-HE-Meta: U2FsdGVkX188Hy7K2qh5UgkbKRT2UzUg5KebEeCzgRUrrSetAzB+rdB/m6bb+pcvbKyE+KdMaMRuONxO7jzJk8+MuNkSHeZfvbIQYglvI0SK0yHP/mPi4V4sMEM4D6ioT+HIk6nXZUQhYiei8WIetdiKgQVrlkPCvWe/Vmq7ysn3M+bcuia+qJacAnfeCNxw5dMlXHx6HKrGbmUDAYh/f68ymuu8L8bnjXNLFQlXIRWAm/dTCA6dq8mjO2qxUIl60QCz7BbZf442qxb4m7n2TGF8+T3LWOYmUPd0Ydag8vVJkiF8PKis9BBQMeWSdt64Jrc1EHyrBzaK6tepJXbV7arw1rxvjjovaOTvOniw56KgTCZLR5bwSM3ekiqJD89EZhVrnggt87WXOa9h52ta9xDytkTqt4A7mdHs+8l0S1nZLIMfNe3GdeYVAPX0txgThKFscivVvJT5JPzvyDcNYsj70szfVJMBvTp3C3CVPyA6v2A2Sfxf6aTOQgFfR1QsV+xf4/1VgTLesTbGUErAvL7T2QzNj5WYcWQ3G/C98zGm47ZULhIo/Drd/L+bzQPbmOgbkyD2rLsBUFn6V2K60OprhVruKO1PQMqdyFcyvXyW2vSH/7IJ2nfJ2BOcXSHMmSMdRvyN4HT3ZVZuF1O6lATUxyMXqOTf1FHr3CE9Bl0DGPGYN6in+omN2Wk60Gq4ex+7PXq5hiG8+ykKdUbN0KgsBXi+iYxQEyPw29z7bo0/gFegH3XtL07PAJuCSjVDNbChz9VE0P96f6SmltaZyZQkhw9wLurqZ3Gvoa8rxPz/qjzy4Qk/5kPloAvt98ph2BWzUaMNkpMuKd3KTOpeG3adW479ec9N2G7Lmsz6xAxbqtNCAe3uA6BQ4aI/V2b6Kvqg1uefO/jei2bZNrTZHoOnUfSOLOG8dvQcNP/su9rC9W0YUWwmVganUmr8m10RbS9bvXfvEmMKw5G35lD
 WEm1XNnr
 16WWCtRRoUiVPwmJJiQIxIlnXeXz65IgqJZjd4KlEB+NwqY1reS3Ki2WqObmJyCqlaPCU4zvPw+ou5Z2kgVkxeEDzZ/keYyZRdT2S6690p/X4O7vxASugVQ7XguDt2KzC3PASbPUNZ6ky7T87k2wT0Y+57kuLO4OFMgaRE87ypBnQnmi21alLxSYB/cIqetoy6YsQavCEtkMnRRiWj40JrzhKONwwtjokqcNH3uX5D3eVyh6T3sIF36czcFHnqxWc7Lkj82UvPH8xEW6G4uDcr7UcZFzDZ53uttf8fxVS/EMBpBZONQWbMYLOzddeygi4OGVToah9opltEGvt3tFXy/g3lGu3U/7fErUivDwFAbKdZ/erppx82aBJdarBhcOZTh4OKI6Yt8ep5zTvIF2E0CgfV2lbN+4eoYgPzsl93uxFvzWrmfZGZhi+zDirdYDqczQ7lMvTiU0wd/OJSnnIs3uEIcgkzkrOtfcR3qeZzah/LH4Cvub/UM+5C0QTXqeA67z3OQlh2UcU1anbGoQsg/ADkCBlSn8ozUFW4gZcxvcHREC6sdmrto4Hno+SGjOUlGU28XqX/D9pa/sdAsSsEjKGssXTjGV3i/gaTdO6qlxuhf1gnjLihK+DNWVOeC6iQorbgihaj7IleBhPmPsABUqsPIXvhS4/QvPl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 02:52:12PM +0000, Bernard Metzler wrote:
> 
> 
> > -----Original Message-----
> > From: Pedro Falcato <pfalcato@suse.de>
> > Sent: Wednesday, 23 July 2025 12:41
> > To: Jason Gunthorpe <jgg@ziepe.ca>; Bernard Metzler <BMT@zurich.ibm.com>;
> > Leon Romanovsky <leon@kernel.org>; Vlastimil Babka <vbabka@suse.cz>
> > Cc: Jakub Kicinski <kuba@kernel.org>; David Howells <dhowells@redhat.com>;
> > Tom Talpey <tom@talpey.com>; linux-rdma@vger.kernel.org; linux-
> > kernel@vger.kernel.org; linux-mm@kvack.org; Pedro Falcato
> > <pfalcato@suse.de>; stable@vger.kernel.org; kernel test robot
> > <oliver.sang@intel.com>
> [snip]
> > ---
> >  drivers/infiniband/sw/siw/siw_qp_tx.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c
> > b/drivers/infiniband/sw/siw/siw_qp_tx.c
> > index 3a08f57d2211..9576a2b766c4 100644
> > --- a/drivers/infiniband/sw/siw/siw_qp_tx.c
> > +++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
> > @@ -340,11 +340,11 @@ static int siw_tcp_sendpages(struct socket *s, struct
> > page **page, int offset,
> >  		if (!sendpage_ok(page[i]))
> >  			msg.msg_flags &= ~MSG_SPLICE_PAGES;
> >  		bvec_set_page(&bvec, page[i], bytes, offset);
> > -		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
> > +		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, bytes);
> > 
> >  try_page_again:
> >  		lock_sock(sk);
> > -		rv = tcp_sendmsg_locked(sk, &msg, size);
> > +		rv = tcp_sendmsg_locked(sk, &msg, bytes);
> >  		release_sock(sk);
> > 
> 
> Pedro, many thanks for catching this! I completely
> missed it during my too sloppy review of that patch.
> It's a serious bug which must be fixed asap.
> BUT, looking closer, I do not see the offset being taken
> into account when retrying a current segment. So,
> resend attempts seem to send old data which are already
> out. Shouldn't the try_page_again: label be above
> bvec_set_page()??

This was raised off-list by Vlastimil - I think it's harmless to bump (but not use)
the offset here, because by reusing the iov_iter we progressively consume the data
(it keeps its own size and offset tracking internally). So the only thing we
need to track is the size we pass to tcp_sendmsg_locked[1].

If desired (and if my logic is correct!) I can send a v2 deleting that bit.


[1] Assuming tcp_sendmsg_locked guarantees it will never consume something out
of the iovec_iter without reporting it as bytes copied, which from a code reading
it seems like it won't...


-- 
Pedro

