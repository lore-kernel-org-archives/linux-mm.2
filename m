Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4571C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 16:10:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E7A76B008A; Fri, 25 Jul 2025 12:10:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BBE16B008C; Fri, 25 Jul 2025 12:10:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AB246B0092; Fri, 25 Jul 2025 12:10:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 367FD6B008A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 12:10:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D28B61A083E
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:10:03 +0000 (UTC)
X-FDA: 83703273486.19.CDD63AA
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id 82B7580004
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:10:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XVcwjVWw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=joLBJxms;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XVcwjVWw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=joLBJxms;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753459801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RzzmnXod3F0xmGwLsBojXwSu1vrDZ6qn6GXPgitsM9w=;
	b=qg/2sczYwNRnwqSzbcyfO+IMaCAkes+rTMxsx2IQ+bye3c6m/XGnAthlO4Hj4zGiXOFJFR
	wi/xxvcVkE0k133eiYSvzjAhzMgRgVb2RexVltDTX4EIRRVV4m5vg4NQbUHy1CjrslAKhi
	YHzzcEOg7fqpymXrnDZAWPKsdRT7/MI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XVcwjVWw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=joLBJxms;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XVcwjVWw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=joLBJxms;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753459801; a=rsa-sha256;
	cv=none;
	b=0yUsQXMPHUA29aDwvYISWv59yiGKp0gJaKTbCYttZV06Bq1Z7GbQmalN2f29ofc1g8nRd5
	DNdWZPY4rKNoamJpI18fymTtdt34MJMFes5zz2Ja72C0hSmf/zCiUdFivKd49kPdBKu8mN
	ZVdqzCMK1gV6xRnq8zF34kn4l2zgnvQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A23131F795;
	Fri, 25 Jul 2025 16:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753459799; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RzzmnXod3F0xmGwLsBojXwSu1vrDZ6qn6GXPgitsM9w=;
	b=XVcwjVWwLOmuPeyvvzcKu6+bKkyqBF3SSTuwP6rxranRakJapb9n748pYq5hVlVpvF5qSM
	ddOYqQbDH6zXWpwOaBzSN0eKKyhK1r1fPcZVJyaop+d5oKWaARJYMQHl+WIOVoUrT93k4t
	33DvwIcRyZOmQ3qwB4vfh0LjV/FLLtc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753459799;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RzzmnXod3F0xmGwLsBojXwSu1vrDZ6qn6GXPgitsM9w=;
	b=joLBJxmseqJsd02nTj8ecCUWc37VgYFtYN97kNYGAS2ICUJuEIyy5BXLyEO7igU/iVR3Rt
	3JCL5jlSRC5zL+Dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753459799; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RzzmnXod3F0xmGwLsBojXwSu1vrDZ6qn6GXPgitsM9w=;
	b=XVcwjVWwLOmuPeyvvzcKu6+bKkyqBF3SSTuwP6rxranRakJapb9n748pYq5hVlVpvF5qSM
	ddOYqQbDH6zXWpwOaBzSN0eKKyhK1r1fPcZVJyaop+d5oKWaARJYMQHl+WIOVoUrT93k4t
	33DvwIcRyZOmQ3qwB4vfh0LjV/FLLtc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753459799;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RzzmnXod3F0xmGwLsBojXwSu1vrDZ6qn6GXPgitsM9w=;
	b=joLBJxmseqJsd02nTj8ecCUWc37VgYFtYN97kNYGAS2ICUJuEIyy5BXLyEO7igU/iVR3Rt
	3JCL5jlSRC5zL+Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C96561373A;
	Fri, 25 Jul 2025 16:09:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VA5fLVasg2iecgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 25 Jul 2025 16:09:58 +0000
Date: Fri, 25 Jul 2025 17:09:57 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Bernard Metzler <BMT@zurich.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Jakub Kicinski <kuba@kernel.org>, 
	David Howells <dhowells@redhat.com>, Tom Talpey <tom@talpey.com>, 
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, 
	kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH] RDMA/siw: Fix the sendmsg byte count in siw_tcp_sendpages
Message-ID: <l5cavrkmzvebjqz62ttdajqc24q3fksxogiibv4tiee7c3j2lk@skxdyrnsqgmm>
References: <20250723104123.190518-1-pfalcato@suse.de>
 <DS0SPRMB00679C99808A4D85BAB6DADF995FA@DS0SPRMB0067.namprd15.prod.outlook.com>
 <nwtutmewgtziygnp7drmhdxpenrbxumrjprcz7ls2afwub5lwf@due2djp7llv5>
 <DS0SPRMB006759C349217E60D43F923B995FA@DS0SPRMB0067.namprd15.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0SPRMB006759C349217E60D43F923B995FA@DS0SPRMB0067.namprd15.prod.outlook.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 82B7580004
X-Rspamd-Server: rspam06
X-Stat-Signature: wqdn1nw44r34wsmpbtcpcbe9poudowje
X-HE-Tag: 1753459801-815046
X-HE-Meta: U2FsdGVkX18r39Y6LoBBIWr4jx+iKl+h462o9aal8ZNgwJarkgFjVTKpcaQDPX39fKrSzkYOX5gBNwbMUVjCbhlgCf+JOECpal1hnyHLuasT8HE6CpwcudGwfoevLEAx5snh6azS/QXRfoxvPcJmp2kLnJUAcaJk9KOh3HxL4NMUasuiPFouNTMpO6gLfOrNrG24+NT4BzOOBFX0y/dppJPsRWRSF0j+AjFAmJi+b9AXQW6AzIqYCke/VIMn8nvYUSnl+FgfrQ3JeZybUPaSPWTZWaKiq7rCArIlvdaXpTuzSJ0OwTaw18MJnsUk9UpIGB8vY+ESBqOTrc3HBpDUXTFO1IDdIVU5GjGRLn1tVsfTM8T56y9nP8ee5kdtubPfM2iW2ErE3MYt/6UCEpPb7zRBuXVmBWVLpZNG6QX8Oa5HP79wr+RijXp7YovyAhSzsvR47yeJ4Qd09QioYCL+cNri9htIhhd2VLV0S7T+VwrJvlK3XlovMMelPoav37WgHAkb1R6r7oOwuzDHxFJVrzWjbCEAyzt1VHKSMW3joEBxDHlqC1V/gRRTxNIdL3ewVlhlE3vtPVdY6TSbzyy9m/DKGVTbSCaPnjo8e4toMJRbo8Q1B5A73xMljuZb8KfTK8l9B7JczgEMllpOfaL+bxdXtnqRibdxZszSslJ0E2vr1VrJR4SXB0IaJ1dxmQ+vcPXb9z/ScpQAVPRdFzRE9xOTa00HwMY+JhxtervQ6vUqeJ7S5bT1w5zhRDCTZBDMwn7CLb0lmrDohFcVGA6OCXIVIpNejFSVLzuALNZ8Ii7yyq8ksm5hhyCDUoDvkvnm5YGTtGuigU1JmVehEdWhLH5OG122TZQp31E3qSfp2yPlVRNvZlK9Tuax+yd0+i8NwO5+xZ7gq9wUj3Rbg8LyuoEo/Gl2Am7uV3fW9K/Sm5SR0U8Eczw4uQlPQfY83yr0pKl6l/MoPw8VRoOMnVT
 qHyk/9Cx
 KVSOPSk+y5WvSXOG4iorQ7p7bHVHl++sz8+6P4VgGOK1T6X2feXaahRRWQnQFEomawl900ANxYt3V2sMTkBzHBcutG7ZtndBEjOQQMXz82b1ra2SY3gitjGVLPlWf+UDz/FtYF9ImxujnzHBT8oJiUsl/kZd/z687XOvfseYLiYAZ2ocS/bcNTfpzyT3SSfzjwgUuTBHaP4FhgaQkkQmgo319vPC2qDh70AUgg+G+hdzF6ekDjgAW/63lpwFkx/2oqE1IQhFh52615GIfVN/WCaFfDpsuPyrqd77aG1VywsLHK8BcofxPjz1wbi/GJM/ubVNb2YDZ3K19B/Kl9CSvUOf3+YipEe7x/f77Tx8Lw5HaHnSCsH6j5oLStkurCTjspzE9fYYHKZqlhMNs6gyMY4vTB5coHPNU9OQWGJ44tiTDM4TcO+H5xTdlepFBoLN66NnCu8Aqc2CpvuD8m/NiJzc0DOsD0Gtt/xMY2FcJJYfg9oexPKZcYqxFBivpEiXolvQFUuRt/GTQRXn7ZYfxDLMgzMdOaqX5yNVIihbhFgnJ0cIwwBkvmHAMM0hbBOVTDU2oa1NJl032SPHa/W6zPyX7yCJQ7JF18HDzClhCmd2nb6nwBV3xW3MgJtPrQ/iZVK8yjqSFvk6Fit5lGryKmKu4HA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 04:49:30PM +0000, Bernard Metzler wrote:
> 
> 
> > -----Original Message-----
> > From: Pedro Falcato <pfalcato@suse.de>
> > Sent: Wednesday, 23 July 2025 17:49
> > To: Bernard Metzler <BMT@zurich.ibm.com>
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>; Leon Romanovsky <leon@kernel.org>;
> > Vlastimil Babka <vbabka@suse.cz>; Jakub Kicinski <kuba@kernel.org>; David
> > Howells <dhowells@redhat.com>; Tom Talpey <tom@talpey.com>; linux-
> > rdma@vger.kernel.org; linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > stable@vger.kernel.org; kernel test robot <oliver.sang@intel.com>
> > Subject: [EXTERNAL] Re: [PATCH] RDMA/siw: Fix the sendmsg byte count in
> > siw_tcp_sendpages
> > 
> > On Wed, Jul 23, 2025 at 02:52:12PM +0000, Bernard Metzler wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Pedro Falcato <pfalcato@suse.de>
> > > > Sent: Wednesday, 23 July 2025 12:41
> > > > To: Jason Gunthorpe <jgg@ziepe.ca>; Bernard Metzler
> > <BMT@zurich.ibm.com>;
> > > > Leon Romanovsky <leon@kernel.org>; Vlastimil Babka <vbabka@suse.cz>
> > > > Cc: Jakub Kicinski <kuba@kernel.org>; David Howells
> > <dhowells@redhat.com>;
> > > > Tom Talpey <tom@talpey.com>; linux-rdma@vger.kernel.org; linux-
> > > > kernel@vger.kernel.org; linux-mm@kvack.org; Pedro Falcato
> > > > <pfalcato@suse.de>; stable@vger.kernel.org; kernel test robot
> > > > <oliver.sang@intel.com>
> > > [snip]
> > > > ---
> > > >  drivers/infiniband/sw/siw/siw_qp_tx.c | 4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c
> > > > b/drivers/infiniband/sw/siw/siw_qp_tx.c
> > > > index 3a08f57d2211..9576a2b766c4 100644
> > > > --- a/drivers/infiniband/sw/siw/siw_qp_tx.c
> > > > +++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
> > > > @@ -340,11 +340,11 @@ static int siw_tcp_sendpages(struct socket *s,
> > struct
> > > > page **page, int offset,
> > > >  		if (!sendpage_ok(page[i]))
> > > >  			msg.msg_flags &= ~MSG_SPLICE_PAGES;
> > > >  		bvec_set_page(&bvec, page[i], bytes, offset);
> > > > -		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
> > > > +		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, bytes);
> > > >
> > > >  try_page_again:
> > > >  		lock_sock(sk);
> > > > -		rv = tcp_sendmsg_locked(sk, &msg, size);
> > > > +		rv = tcp_sendmsg_locked(sk, &msg, bytes);
> > > >  		release_sock(sk);
> > > >
> > >
> > > Pedro, many thanks for catching this! I completely
> > > missed it during my too sloppy review of that patch.
> > > It's a serious bug which must be fixed asap.
> > > BUT, looking closer, I do not see the offset being taken
> > > into account when retrying a current segment. So,
> > > resend attempts seem to send old data which are already
> > > out. Shouldn't the try_page_again: label be above
> > > bvec_set_page()??
> > 
> > This was raised off-list by Vlastimil - I think it's harmless to bump (but
> > not use)
> > the offset here, because by reusing the iov_iter we progressively consume
> > the data
> > (it keeps its own size and offset tracking internally). So the only thing
> > we
> > need to track is the size we pass to tcp_sendmsg_locked[1].
> > 

Hi,

Sorry for the delay.

> Ah okay, I didn't know that. Are we sure? I am currently travelling and have
> only limited possibilities to try out things. I just looked up other

I'm not 100% sure, and if some more authoritative voice (David, or Jakub for
the net side) could confirm my analysis, it would be great.

> use cases and found one in net/tls/tls_main.c#L197. Here the loop looks
> very similar, but it works as I was suggesting (taking offset into account
> and re-initializing new bvec in case of partial send).
> 
> > If desired (and if my logic is correct!) I can send a v2 deleting that bit.
> > 
> 
> So yes if that's all save, please. We shall not have dead code.

Understood. I'll send a v2 resetting the bvec and iov_iter if we get no further
feedback in the meanwhile.

> 
> Thanks!
> Bernard.
> > 
> > [1] Assuming tcp_sendmsg_locked guarantees it will never consume something
> > out
> > of the iovec_iter without reporting it as bytes copied, which from a code
> > reading
> > it seems like it won't...
> > 
> > 
> > --
> > Pedro

-- 
Pedro

