Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F304CD5BD1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 09:07:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 767466B0005; Tue, 26 May 2026 05:07:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73E956B0088; Tue, 26 May 2026 05:07:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67BAA6B0096; Tue, 26 May 2026 05:07:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 597E56B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 05:07:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 014B48D568
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:07:12 +0000 (UTC)
X-FDA: 84808991946.25.2098B75
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5051418000C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:07:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RbEXU9/u";
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779786431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X4dMIY6FGLg34QRadG1/HG9iWSvS0YAF4MlMdh2Kq3c=;
	b=cVYxtuX9dulFrtbA36fGyAKQolKXRAEZ9/N2IghbNdFIn3K54QntHH/3e1Z108sycVfP7o
	8jmWY+OyfaAULfiLHzENn0LLPdBcUdZ7oGI0GOkCIFaBrDBsl1lfge4WnPJxOkLqR/UwVt
	OSfmwLzTuqILuoThGCYWdvrzznNDyGI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779786431; a=rsa-sha256;
	cv=none;
	b=0gNAa9Zmop+VYVXpxRJ2f09VV5pnQAccXd0eaNXUbPs6TeUC1LbqGOGS4GHjdbPvjbgQsb
	aTLl0mITUiOFLO1iT46+JZHiyW4TCx/A3MyQmCkp/tA8Vp/Zyl7ci6oa0XW6dSVQJhkIkz
	eLLAMNAqZCN79UcjKiJ7muFbVn1S2ic=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RbEXU9/u";
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7397C4175C;
	Tue, 26 May 2026 09:07:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06EE1F000E9;
	Tue, 26 May 2026 09:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779786430;
	bh=X4dMIY6FGLg34QRadG1/HG9iWSvS0YAF4MlMdh2Kq3c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RbEXU9/uZCN+Vwwr63QjTBV/FcuhwVfwE1G+xkgW/pj9WZHp/LQdAuV3xkOBHeSVD
	 AkVVQtdnRcNWv1Bw2/evi6mIuYT8M6sdvUP021zd2BviqBaFduuPTu6GVcAaL1kq+a
	 yKhCJ/vtQe57mGf0+XB50jud7L1iGR+3Nxbqn2wdPXOcyof2MefuGY6uRaRF2CuJg7
	 WMCo9eaUxvKLIqX4WPVlUGktTPR2+4NMiJFCzGRIAyt+qpGqLdJcQVrkOFkTQH14+C
	 SjFKDsC537UZa+0+zKQpAXFjuIC2XAnLkx7R7IqX94mMj62X14Wy3VSmaRPz7oaMOc
	 6AA7mo4wiYdoA==
Date: Tue, 26 May 2026 12:06:57 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dave Kleikamp <shaggy@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Breno Leitao <leitao@debian.org>, Kees Cook <kees@kernel.org>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org,
	linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-ext4@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 14/17] fs/namespace: use __getname() to allocate mntpath
 buffer
Message-ID: <ahVisehwQGXEoM0g@kernel.org>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
 <20260523-b4-fs-v1-14-275e36a83f0e@kernel.org>
 <lwnrjpmzbv6swapmnmb5jki3xxxzqsxuks5vykniwhakvhqh7i@rhff3qrwfnoj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lwnrjpmzbv6swapmnmb5jki3xxxzqsxuks5vykniwhakvhqh7i@rhff3qrwfnoj>
X-Rspam-User: 
X-Rspamd-Queue-Id: 5051418000C
X-Stat-Signature: ainj1dwb9yddmjo6mjr87w44y3k181dd
X-Rspamd-Server: rspam06
X-HE-Tag: 1779786431-891212
X-HE-Meta: U2FsdGVkX18YhoTWmy3w+5Xek05vnk4N+XaLGtocQdVlNo//tbQwppoZCDirGjM+6WpvyXpEkEjflrujrqttIluEnGrzrpPT5rwFuLLN3ejILUtNnhwDCdxgLiCoNZnsVUQeaqlDYkNNLWy9rf6xGGbSbfZjDt6hjOmBRoLmReGszMHMapEHI6XGAEtAZwYi88ZKCDYjF2W3FdrjSONGAVUyE4qwx/+q9Z4CE2ts398UaqjY3eTjaKh4ngdaHv7eizGtQp+R9LBy44o/JRjn0cHlnL6ImuHKeyC3sLF5U/mse93cxXiK0mPx6sqzGYm9DK+2IUkOOLY8WB/01pbgORQl/qJYP9zDiPq3LGfLhQhQEtgXYVSknnCcyi4tBJRrNjz46SgOarYP4FM7H1ufr+jJ9fPaiZyIHgdpXPxjk6ONlgmM8jZwZVH7sNk5aa1yiHKXuhpdmQ8TfCtyhHI8wAI0tTl1Pq92CrJjd9/i8xlAdyNkY5rqGk4rVeuZAQG53rW5A7wuv2zhGzfAa5IgSafKdYIV7vyYwvZc2wUENXpRwZUp3GrqZ8eOdVMSPfpkSTDTj+0JNfXi7ljM7jYY8xA0EAj/8r0C/ZNWPZlvOqnu2p/FigPPfOSHjgaCfV3OMDuduiyX31Jd/S/rQJ3+JMigxbf0d4X9siGR2NI6b6NCvV5UbODxq8jek9iMTP1SnBs5JpvmRgZonxQZ8xKrTjdMLiUQwV6i2yb58SWF/Y+91qicJCzIvNRwDQOXSIgnlq4Tyo5jPiB/Wiz3hUvQo0YXyG8XQcMx6Qikh2/0Tr+tNxAc38pByhXOq38TgtFcPZPpY74GI71dNXnYji9cuAXQ6PcxQTtBYTLXIbMBVE2ILxSVlKf3q+tiEdt3cavBYzOucRZVeDxDwhOpRWmMuBbdoH1/nQC/sV2OhdxYf0KfSKK/LtuQpUc3VaD9kCWRgIlho+WMciqQdupv4M9
 Yz4RvO10
 Ga1ETiQuZaWMWGyVgLYTfA7ltOfZ4wIpCAmxYavd3DtDxgj+PHaZgPf5E0n4lNLsDPuU5T7v+qSy20zs9ydjLG13gY9T7l4PXdBKZW6pbNsAoeKgN62ZnlQllLeccsRLQcQngHWyFh45nYJkCgV7D0gR4p0Rd5IunecmHdrWQIdWGPewbDgL5UXCnOwZ4d66XVti84xv/m6f63DA32mwrOk6AaG3IMMikdgCPDdGPQcwj8QwJXHfZScqF5wp/BKUh49kad1xgRfS0OvHyWJgBP9gayiYyTXWd3+CytM0pYKgLIaqn8grziwBndrQPuiumJ0lfCXiEZkTuUbVetl96Ax7c3YHpMN+Kcsvl6FoQXcxzH/Kb9W8gv25A+gIWfUpbbw6l/+vSc+RIcXg48kZRgtyCyO7CRETXJxiBfq5+VNyxv/LEf+q1NSMYVbd3Yt9t55hNN8t54aIjK8g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 06:22:13PM +0200, Jan Kara wrote:
> On Sat 23-05-26 20:54:26, Mike Rapoport (Microsoft) wrote:
> > mnt_warn_timestamp_expiry() allocates memory for a path with
> > __get_free_page() although there is a dedicated helper for allocation of
> > file paths: __getname().
> > 
> > Replace __get_free_page() for allocation of a path buffer with __getname().
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  fs/namespace.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/namespace.c b/fs/namespace.c
> > index fe919abd2f01..2ed9cd846a81 100644
> > --- a/fs/namespace.c
> > +++ b/fs/namespace.c
> > @@ -3303,7 +3303,7 @@ static void mnt_warn_timestamp_expiry(const struct path *mountpoint,
> >  	   (ktime_get_real_seconds() + TIME_UPTIME_SEC_MAX > sb->s_time_max)) {
> >  		char *buf, *mntpath;
> >  
> > -		buf = (char *)__get_free_page(GFP_KERNEL);
> > +		buf = __getname();
> 
> Fair but d_path() below should then get PATH_MAX and not PAGE_SIZE.

Ack.
 
> >  		if (buf)
> >  			mntpath = d_path(mountpoint, buf, PAGE_SIZE);
> >  		else
> > @@ -3319,7 +3319,7 @@ static void mnt_warn_timestamp_expiry(const struct path *mountpoint,
> >  
> >  		sb->s_iflags |= SB_I_TS_EXPIRY_WARNED;
> >  		if (buf)
> > -			free_page((unsigned long)buf);
> > +			__putname(buf);
> 
> And __putname() is fine with NULL so no need for the if (buf) check here.

Will fix.
 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

-- 
Sincerely yours,
Mike.

