Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE371F3D32B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 16:25:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D7316B008C; Thu,  5 Mar 2026 11:25:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 300FB6B0095; Thu,  5 Mar 2026 11:25:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D2BA6B0092; Thu,  5 Mar 2026 11:25:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 06F9E6B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:25:36 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D2B9388BD9
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 16:25:35 +0000 (UTC)
X-FDA: 84512535030.02.A6B1F7F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf02.hostedemail.com (Postfix) with ESMTP id 88BE980012
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 16:25:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SboluI84;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Gy8yt13D;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SboluI84;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Gy8yt13D;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772727933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bsjlUJ/oFS4TNjkXPGzAAnIHdkWC3Rf5TrIvhsGPzhY=;
	b=jIM+4z37YkAngsNQ1xVZ7UZAYbTkB5lHHT1PWtnF6pXSPsgemRy5c6L69DwHjUrapVtvmI
	VXgtfqGqgfbZ/uraQ7OAp5wPnuBsUDTsA9Y4+Rglz6wLzA92FcIFn+rNA9EtmB7h1OyGBC
	ATzGJr0lk66OZlOHBNzb7DkXBjm1gO8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SboluI84;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Gy8yt13D;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SboluI84;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Gy8yt13D;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772727933; a=rsa-sha256;
	cv=none;
	b=EIlNusY52BpndDopzseIPC6YeUoJCSIvy0YxIZaAa050fu2q6AZz/iThVlt5qWvoJ+mg7Q
	8ylJDmsbTHzILRq7/M91VOa7JgbvJSDTFy4816ZbUwtRGXvkkuDMWV4QGSXpqkHB3DiR94
	kOS4qNbbfwUyZKGlGviYzh3szBLSb5Q=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 112053E772;
	Thu,  5 Mar 2026 16:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772727932; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bsjlUJ/oFS4TNjkXPGzAAnIHdkWC3Rf5TrIvhsGPzhY=;
	b=SboluI84xt3BVro1Qrfv//gEBdxpuyvOrS5zv9/1UlMb4heq9BdlRXi75vYfAqxbPCcEt2
	NMAuWyoFffEHapzyrh/Yy25gyoE4suu0d281hlJ3xNG0Tl9NhztMU0HhknRDHDlLDPeJXf
	jSZim/T6jUhymxio+fYxWI+a2Lo+B5Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772727932;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bsjlUJ/oFS4TNjkXPGzAAnIHdkWC3Rf5TrIvhsGPzhY=;
	b=Gy8yt13DSrWYD4RnUxIQRMPyTp6tOsVvzBR3E4qeCRMM7AA5rcdCgF+Wu65+nz8+sDyDyQ
	RyKJR1V0wqlAW9Aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772727932; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bsjlUJ/oFS4TNjkXPGzAAnIHdkWC3Rf5TrIvhsGPzhY=;
	b=SboluI84xt3BVro1Qrfv//gEBdxpuyvOrS5zv9/1UlMb4heq9BdlRXi75vYfAqxbPCcEt2
	NMAuWyoFffEHapzyrh/Yy25gyoE4suu0d281hlJ3xNG0Tl9NhztMU0HhknRDHDlLDPeJXf
	jSZim/T6jUhymxio+fYxWI+a2Lo+B5Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772727932;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bsjlUJ/oFS4TNjkXPGzAAnIHdkWC3Rf5TrIvhsGPzhY=;
	b=Gy8yt13DSrWYD4RnUxIQRMPyTp6tOsVvzBR3E4qeCRMM7AA5rcdCgF+Wu65+nz8+sDyDyQ
	RyKJR1V0wqlAW9Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 08B923EA68;
	Thu,  5 Mar 2026 16:25:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tksdAnyuqWmXcAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Mar 2026 16:25:32 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id CBAABA0A8D; Thu,  5 Mar 2026 17:25:31 +0100 (CET)
Date: Thu, 5 Mar 2026 17:25:31 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 31/32] kvm: Use private inode list instead of
 i_private_list
Message-ID: <norxrkgyn2t4qzcplhh7y6iat5ljhaexc75biwyqshq362yuor@etddmzwqvtht>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-63-jack@suse.cz>
 <20260304-mahnung-ableisten-50d5c4e71013@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304-mahnung-ableisten-50d5c4e71013@brauner>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 88BE980012
X-Stat-Signature: ezcrwaxw5hk7i9ommwchntf7ixijm899
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772727933-29308
X-HE-Meta: U2FsdGVkX18YzBDtK0PKlxFvkd6MFzAoRxiISDC8pKSXRq86ey+8S83s2WeDSRAuxO1ZDhn7XWPAKrJV+7ykIVX0RSybOsZe5Fdj3zRYfAZd5UFIJwDurcY97I0OVfiF02jMVGf/ffF+5sTl7r84sIVruI8OROWx586eGKFLcEDMif8oiJQbHAsE4zsYGcDq/22kBLh/EVjnrD6B5PleJEr8XNAtwk+X3xGS1VidxMYaJcs6GeTyMRrFasjdUhlXypm9rocOxrjm1R8ixS/t1amQtd9pWuBHHeeUA2nIBv6ytb7VcBT5yb5vHw3rvf59uCXp+qS5koux8Gg8GlQIyngB9ZwCBj2+w8NZmKQc0ahQSh6zPtfBid7Mx7DaOYvE2RLwNywb746pLBMlRQ55iw0s87v2NqvHqL3vbnn9XQo9WzR/wHJNCwIDITFYpvrPeJ+FBKumTuNnmBzgC30B0sgkaRgjBbaVMjqxfooGRgFKIj08B+Us9xDmaQOb2H4NpR+oCwXbMg+kYPUVFeXg23HblZcXKIwrJwqW7GSm0JBonLHBFsDXzdJe+H1+U4NlQdY9iB8fLz6J1vrNO/lKXoYhtYOoh/whaa5SVofQCP1H2030u+HZUR2eC06S5GrgvCRi9YGzoKHfDYOS726wwaqrpIOOGU4T2Dg+J/hzZOap0RqSoAVDowNdHrMOzvQiiSZXdfKGiNnFGXtB4t2S9UlV42VxU2xEndITf4WczzKOHhBEN3Bhe6LjclFF2oI4gbQjJ7RkO7cCFQi3RoUg2NHUZ/Jp8lwl0/COr9yTPE16V7stzuroQX79Gt/mlbHCQoQsJPzLG89YfMt98/0xNB9abnMVw06LYSzeDNFdjAxP+kcSU+k3RaRCvkSb3LWwDlRaX8UDFPU0EogkuceRI2I3vd/DJKx52sNeEIUtgM0+74Or/WxEGue08OtSDqizcVH0xsA+9LvAsnAdy0u
 8Y9nS5tr
 SeUNG8gZQDQq7CBKcOX8hEdWIyECdk2fsGlQS1Uj8VByrREO57hGy8tBaIAyjetPiRtpWK04oY2OJGXjkflw9c4V26j93iksfEjRqfWxvurZ96YojezNr7GMQR4epdd48JHsu8/IEm7VCj5c2Z9E9YXz05GDJHyRL98lzQye/NBTEMEQU/r7IhhU4/nMfix/fkOCIBQ7xwlSN6DahZahkvWvzEaBIWlMQx917U6jUUxPzj/VMTmPJNf8IwfN/4Sj2JBzjuRdN6XOLxUswi6bwGe1W9zkcBkPz6E6IfIKU9eCX0IafzHoQyQ4kOuCkQDtBV2oLolMdnxbL3dhOt+m+KT5lTxZkS5shgHJoLhwfVEue/aAgtUHHltJExHnVUWQodSeKSgTwoIUH1taj9ML/F4sFKAONFoqtL7Ewkz0YjWZXBzgebXhmzu7nWL8wK9DiDQk3TlK12L75NlQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 04-03-26 14:40:33, Christian Brauner wrote:
> On Tue, Mar 03, 2026 at 11:34:20AM +0100, Jan Kara wrote:
> > Instead of using mapping->i_private_list use a list in private part of
> > the inode.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  virt/kvm/guest_memfd.c | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> > 
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index 017d84a7adf3..6d36a7827870 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -30,6 +30,7 @@ struct gmem_file {
> >  struct gmem_inode {
> >  	struct shared_policy policy;
> >  	struct inode vfs_inode;
> > +	struct list_head gem_file_list;
> 
> I think that needs to be gMem_file_list not, gem_file_list.

Right, fixed. Thanks!

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

