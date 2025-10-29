Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A9E4CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 17:55:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3AFE8E00BD; Wed, 29 Oct 2025 13:55:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EB948E00B2; Wed, 29 Oct 2025 13:55:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DACC8E00BD; Wed, 29 Oct 2025 13:55:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7BA728E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 13:55:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1C3E1C0745
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:55:13 +0000 (UTC)
X-FDA: 84051903306.10.3F9409D
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id 236C11C000F
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:55:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=ZqaowaHD;
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761760511;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hxMUsVatKbWhonDVOdoqCw+QvpkWu6d9zu8seRb9LV0=;
	b=w2bqJVKyyC5BZ1ns8ZNaECucyx2sAX6XYX4P9woG2Ed+8afyWr0HKVvJ4CteAXEOCQykUN
	x/XkOXfGSf6KgwJese5YmKz0r66mFPkciegNaA5Dpdr5kcx8/WyUqO3G5rrFf/O7TB0ea8
	4nBA/6AsEO9gZB5mFBWfz9cWjv2nDk0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=ZqaowaHD;
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761760511; a=rsa-sha256;
	cv=none;
	b=cJuTSIiI7hhCwkPiuufC3I4Vac3wykOfIxb8sy6IQ2nMrzODFBsfpY13cO3tna7szfdhpP
	RyWbBhT8xmiElC3enAf0WXEmySxGm0qVvXH8aNxQVlLsMGuC5B+9E9JF9RInlLMqIzCw33
	Dl7zblvS1q+CI7xVq0r8NBY2/f8pQOI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hxMUsVatKbWhonDVOdoqCw+QvpkWu6d9zu8seRb9LV0=; b=ZqaowaHDIWj01NIds+0TIejsHt
	XNcqF3EBDGWDHrewmjlpyIq2j0AgqblkrtlOkNOTt0EWqIzLaIERrwPKq5f9eNXMv1aTIGZLrQ1HH
	rg+ZORmt81RyG2qU67dv5WXr9ri4iBeQWNdeCGFu2fJJBw6MQcvPU6Grbx5t8CCUE+O3sDZ3z4Rll
	aINFtyxUrztNEHbgUWxk5lOkAAe1TpMz3bbiONo/ap2hMi1ciYOvoU4Vv8C738OFzygsdk1MinKCa
	dWoo2gHYZrrQJ6fr+RoKVyeWfb/xKGz1vuqhGzuDHVmJn/TDzmK0rUjeCaSxWOI8aYuDR7FgWfWEr
	uT4IVvCQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vEANx-0000000D7rD-0xCn;
	Wed, 29 Oct 2025 17:55:01 +0000
Date: Wed, 29 Oct 2025 17:55:01 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Mark Tinguely <mark.tinguely@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
	brauner@kernel.org, jack@suse.cz, raven@themaw.net,
	miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org,
	linux-mm@kvack.org, linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, kees@kernel.org, rostedt@goodmis.org,
	gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
	paul@paul-moore.com, casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com,
	selinux@vger.kernel.org, borntraeger@linux.ibm.com,
	bpf@vger.kernel.org
Subject: Re: [External] : [PATCH v2 07/50] convert
 simple_{link,unlink,rmdir,rename,fill_super}() to new primitives
Message-ID: <20251029175501.GS2441659@ZenIV>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
 <20251028004614.393374-8-viro@zeniv.linux.org.uk>
 <3ec6f671-c490-42f2-b38b-f1fa20c60da2@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ec6f671-c490-42f2-b38b-f1fa20c60da2@oracle.com>
X-Stat-Signature: e1zam4gxzj69ewkd9rrwb4ccmazy75xk
X-Rspamd-Queue-Id: 236C11C000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761760510-742062
X-HE-Meta: U2FsdGVkX19EWtSbCWeltVOXXmTwc/FrkqZGF/3BlfyslY1ISEE9fPW2YqS6dsaNvR26GLm58JOdElytqidOUlpakLreodtkdeuAArpCe1Ry1XIsHokxqqY31R9zMCRtuJYG/uMUvPaDo7k3ppdeYkbiDx2cUf0+SaV7mZ/RWJJ8KV2tUDsR9CRPAs+kgcF10AjZ+tSAirqAtGEenGU1VyxyC1KP9nsKyO/ECMmqSxdlaXUDYOqUxcyu3yJiSOB6cLb8u/J5mHJskN9xnIDQFy4aNoRR0MSvk6T+DavMQnbMvCYUeCesFS5Wu7Nixst30jTLHnf4qyJ0+G8Isyv2ZGZgpT57h+WlHa5GZETYGyEgKFSpkC2j0S8hS1s0levAeayxhW4Z8a5R4wwOGgm1mTHjZXPpVO42leHYi8uGflZ0zEddbH0slE6KehQDp0u+kaxsMDE1CVBXStdssJw1i0HiR9dGaRpL/+joC4KMYD85qrc+73fS3u6WLt1zrgTdpfc97a7EN1wSRqC9m0FELFk+xcW1t0BegMqCKWsapzf/VVmE4UxpBfJetJqKKS458Pk4hlMeFr71TiXzfTj672AAVjtcORGA+ShvNq8JDYT1qwnRwEReE+5BNswcb+9bJzYVw6zo2bLbj4sPp5QBywisFiXcmPHbR07dkI0pvuqM8pDL3XfcMXy/a9/Mo/jgo9VxORYSCYmJkCuOrdJHdasKRgvfdVcHiaHDnwmebx0XNsJlh4g8rXd/Gv2ofh4ca0NghwzftBMZc7R5ckHYaN6wpsztXeYXXqCEj5UtDJDjwpCXhEqNCKt/pofVmpChbVztEbiun/SPkCQtfDslAFsCxqpZmJnXUMAyiMxpJDhnKNahYRV0uWPX3HOshkh5TImYGeNP2QNjQF6SZbS9P0qeaJ7niAMZXTIaYLi514iUnWDQ3Mec3xb4jyJ7Tx3fL9yqn3DB9YahHoXMG84
 /nv8oJvM
 AawxR3Sn4a2wQ8RGGg3ie68shc0u+rXK7LpFWD5mTjI9CQd02wd0Qpe9iFXTrIge3qTRAclZuUKD/HSWQAiy+Sl/AhykfJxM1Uj5hOPQtht+DTIWhf7bVSfs6WjNBGFEIpteT06Cr53bBDM4E2tEYunV4AUzVmcIQqdtsKdJSLoxDTkS7Y/KQXA5OGzjvHapBkHYDwETYWi7UJ9/Op0ay8dhMN3nl38yW2JBDSfMVlTlBioq6rRNuUdhaqz05R3ICjn5eQ+mqjbUJ22YH2WhcVHu1hJCdo33ouYeZ+7sU577qE8Beh+lnWNPC6dMl3ORWHKp0iKtL2CPBRPP6SbN9h5alrH9WMLix95JJ1gs0BIaWftgvsoOx1oowCvqTNijXESSr4TNNF1XcBfwtkKW3aLtrl1rB2hmEwgVafNO/Y8iV2c9YZmTD/xnZd4G+A/Wotq7XVc9tpyV92/I14Ks3zqy4tP2eLR5t1Juu7LjUgoV48L56MMgCY4QG7a3MhP73g+c/n1dnSzAL6rHTB2gy3KBox1EItkgZ6KXF7IcfvPalLmg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 09:02:33AM -0500, Mark Tinguely wrote:
> On 10/27/25 7:45 PM, Al Viro wrote:
> > Note that simple_unlink() et.al. are used by many filesystems; for now
> > they can not assume that persistency mark will have been set back
> > when the object got created.  Once all conversions are done we'll
> > have them complain if called for something that had not been marked
> > persistent.
> > 
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > ---
> >   fs/libfs.c | 10 +++++-----
> >   1 file changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/libfs.c b/fs/libfs.c
> > index a033f35493d0..80f288a771e3 100644
> > --- a/fs/libfs.c
> > +++ b/fs/libfs.c
> 
> ...
> 
> >   EXPORT_SYMBOL(simple_unlink);
> > @@ -1078,7 +1077,8 @@ int simple_fill_super(struct super_block *s, unsigned long magic,
> >   		simple_inode_init_ts(inode);
> >   		inode->i_fop = files->ops;
> >   		inode->i_ino = i;
> > -		d_add(dentry, inode);
> > +		d_make_persistent(dentry, inode);
> > +		dput(dentry);
> >   	}
> >   	return 0;
> >   }
> 
> Putting on the dunce hat for the rest of us:
> 
> I think I understand the dput() for d_add() changes, but it is non-obvious.
> Thinking of future maintenance, you may want to make a comment.

As in
		dput(dentry);	// paired with d_alloc_name()
or
		dput(dentry);	// that would've been simple_done_creating(),
				// if we bothered with directory lock here
or...?

The thing is, d_alloc_name()/dput() instead of simple_start_creating()/
simple_done_creating() is a bit of a shortcut, possible since we
	* know that in this case nobody else could access that fs
(we are in the middle of setting it up)
	* know that directory we are populating started empty (we'd just
created it) and nobody else had a chance to mess with it (see above)
	* trust the caller to have all names in files[] array valid and
unique

And for simple_fill_super() that's pretty straightforward, but in other 
cases...  Rationale for taking that shortcut needs to be good.

