Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FF92606A324
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 07:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A/hzQNo+
Received: by kanga.kvack.org (Postfix)
	id 948F16B00EF; Thu, 19 Nov 2026 02:36:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FA596B05B4; Thu, 19 Nov 2026 02:36:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80F546B05B5; Thu, 19 Nov 2026 02:36:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 60BF86B00EF
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:36:13 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C87A5809B1
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:36:12 +0000 (UTC)
X-FDA: 85451060184.15.912B197
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 37E1D40007
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:36:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A/hzQNo+";
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795073771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TYXQVdddJMJhgchsWgkvy/MvJAjZnwkHSiuLmFLtt2c=;
	b=ZBwWROjdliIhqRtxtr80uGmbPkV6QPd6ZG/IpSKlQbRORSht/jKgrmV7bL+sjqtSENITvE
	SS3IDJTet9gTy5FJQCaUVY0Xeoiw4CN0/JXLqzOLuM8GZLRAAP9mQpb/tcP6al9cUyK4I0
	jUdhacDWEyG81F3l+lvLrx9Vv4GHWxs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A/hzQNo+";
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795073771;
	b=MoaswlYmJ40tQkfjganCX7LwZINSpxVd1EMnro8v1LDLvNNFskyHF/rbt68IWWabczbADx
	EWXMvSy92EFbfD7pcF5eMU5U1OMs3u+r/1GjfM/ZzxXxlji+B5C/x6ndsV/eRxAA5AIUFg
	JTDDmkQtVXXhBtFOJdgTVMRB+EuoTJA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E93C62556;
	Thu, 19 Nov 2026 07:36:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F0C1F000C4;
	Thu, 19 Nov 2026 07:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795073769;
	bh=TYXQVdddJMJhgchsWgkvy/MvJAjZnwkHSiuLmFLtt2c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=A/hzQNo+xCwvXgKK2H7WPL+/+TuZkNqeVUTjGQ15SgSf9JQR4byzRy+16HIRYORcR
	 1nHKUf0MWnl+LiPIxK286nvsMFhM0O/9HxRrdYhboemO7RrusvmZ8HldFWHfcv4cZ9
	 WMGbTIXTNG76T+MJdlAaudlQ7lD4Xhi5HXV6SahVqmg9s+hom0hYSrgX9PTuqdKIkz
	 Nl7TXTBtVpusPvzDuMLc7J9i5yOFN7f2bYSOPR3REHGVfmm5U5j4aWeN/hkc4KYhl1
	 o9tf/GsebHCqqeZ3wRzUUfs7mI9GU4nJ7VZ3NxXsYbOI3xltdpRsFUUKlYKfomWsrF
	 HqpNyOvDVnq2w==
Date: Thu, 19 Nov 2026 09:36:03 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Lorenzo Stoakes (Arm)" <ljs@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/secretmem: Keep locked memory accounting until inode
 eviction
Message-ID: <av6m4wU7iDOGviIa@kernel.org>
References: <20261030152407.113568-1-pocj8ur4in@gmail.com>
 <45ce0b42-d45a-44e3-b300-607989e618c5@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45ce0b42-d45a-44e3-b300-607989e618c5@kernel.org>
X-Stat-Signature: 8exhbbgri73ke5gzyiw3gdanizsygf8e
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 37E1D40007
X-HE-Tag: 1795073771-805675
X-HE-Meta: U2FsdGVkX19MLBbXL+oQvElDRT1hRs89nVAmMDPn/7GmYmo4qrCgn3BzctsHAcaQemAG7YGACAMLCfyxWWwU8xhExo7V70rU9xOcOqtdA4A/KDEDWuw1gRQkqYnaeOXTD7Yr09mjr90nc3fC8CnkxuP84CAF2hyejKAuZiXm3YSO4BqNTlHmtZaLCvrFkujA4FWmDQkfeWXozXfQYKj/H+jXcpQc67OlZCXO/8iI1oFE6dgFdLKAa2MDFWNT0uAVXjmcD5s45dg4ckMPETAeH25NfGCqDuF8CjhmRWlXYFz0WMZcYTo9P0hNxGCo4Uj6pluT5CRuRvLR17RPs/8/LBwUxGt4Vl9zZRZvzIaFNUDClL/vjmsisw7pJRkrmdiwCohwoaJCYVgS6o+2+hjAKiCf1aWv8f0e/dszs0skk2PXTrnyXM76kSpBmgvt8/hclSN5TfhEdTlbjF1AMPCVZjIXs5DtI5ycwVmg5TGnQ4yhG1PAFwCGq8s9TrmPwqzlIpGLXqcenKwjDj3x3hvCiwkECs3KyIqEhqN1zBEJcaZi9DuMkG5qyKcc0xwFcbHF5Ma+XUlBfRUZWK+EJYbjokekte27k4BHho/urrRKkOYY4EFqLy0oXl/oOLtrdlw5q0og64YDtBMlJZQbxJ4ihvvKeNIN/Fl+08KwKb8oYK1EpEZGcYUg6IEelwfyzJg3w7d3opWNEEGsPisKDs2XADN+PypP/PTTx+nos1V06BQQV5J0kCUcM5lQb/iQs47wCdj1J8xoSXGSNKT+slzxKsTKKoOBzYz9g4gkdvBl1/XMquvFjr4SF/mLI2QgVQAoExxOiv7zXV5lCalUj/nfUdFREPTkvD9/GoY0n5qm9Xh6IVCZ2I60Jivuf6C1Qzpqte+yFM9qVNGRpqwDiD+gsjWmcjIOOr5sdICY61MD9sNrgPrWOEgEC47IccTGDYYaKD/jxVPsqVf3N3IdPJy
 jTp4ru6H
 yFn2dX417plCx2W1FsLgxT1P1mzwOmcG/QbEUUve4hWlOyjLm3RfLs4OmgfC+0JY/zJ34NnkaNsVXhVyRxNqvRorTTGHL/u77oIP6FCiAtp4RJKcvuKbA4dqw+vZmwkRJA21A/Z7KMEeU/uzhKlvVf5omCcK8pFswV9th94oOMGu4qqvFy/jDNHGLkpi2k/lRD5kWZ3qrgSftvlIs+4HUXobDS0ueH2sHSAMsZCi2MRTQGGW/OT+GcmoX+phITPxj0QNNd5hJYGxc8G2VuQ/k9DTSxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 11:59:57PM +0100, David Hildenbrand (Arm) wrote:
> On 10/30/26 16:24, Baek Kyu, Kim wrote:
> > A secretmem inode can outlive its original file. An O_PATH descriptor
> > opened through /proc/self/fd keeps the inode and its unevictable folios
> > alive after the mapping and original descriptor are closed. The file
> > release path nevertheless drops the locked-memory charge, allowing the
> > same user to reuse RLIMIT_MEMLOCK while those folios remain allocated.
> > 
> > Move private-state and locked-memory accounting cleanup to inode eviction,
> > after truncating the page cache. Keep secretmem_users active over the same
> > lifetime so that the hibernation guard covers retained secret pages. Let
> > iput() handle file-creation failures and tolerate an inode with no private
> > state.

I don't like the last part, see below.

> > Fixes: 97d34aa65c29 ("mm/secretmem: properly account locked pages")
> > Signed-off-by: Baek Kyu, Kim <pocj8ur4in@gmail.com>
> 
> Lorenzo, Mike, this problem seems real to me. Can you take a look?

Yep, it's real and the fix is correct.
 
> > ---
> > On an arm64 QEMU guest with an 8 KiB RLIMIT_MEMLOCK, an O_PATH reference
> > retained two secretmem pages. The baseline dropped the charge to zero and
> > allowed a further one-page fault; the patch kept both pages charged and
> > rejected that fault until the last path reference closed. The Image
> > was built with KASAN and lockdep. Hibernation, other architectures,
> > and long-running concurrency were not tested.
> > 
> >  mm/secretmem.c | 31 ++++++++++++++++++-------------
> >  1 file changed, 18 insertions(+), 13 deletions(-)
> > 
> > diff --git a/mm/secretmem.c b/mm/secretmem.c
> > index 384f5cfc457f..fa8be360bd2a 100644
> > --- a/mm/secretmem.c
> > +++ b/mm/secretmem.c
> > @@ -185,18 +185,14 @@ static void secretmem_destroy_inode_priv(struct inode *inode)
> >  {
> >  	struct secretmem_inode_state *state = inode->i_private;
> >  
> > +	if (!state)
> > +		return;
> > +

Its really not obvious how we can get here with state == NULL. 

And since it is needed only for error path in secretmem_file_create(), I
suggest rearranging the initialization so that we never get here with NULL
state. 
Allocate the state before creating the inode and adjust error handling in
secretmem_file_create() so that we always get to iput with valid i_private.


> >  	secretmem_unaccount_all_folios(state);
> >  	free_uid(state->user);
> >  	kfree(state);
> >  	inode->i_private = NULL;
> > -}
> > -
> > @@ -296,7 +292,7 @@ static struct file *secretmem_file_create(unsigned long flags)
> >  				 O_RDWR | O_LARGEFILE, &secretmem_fops);
> >  	if (IS_ERR(file)) {
> >  		err = PTR_ERR(file);
> > -		goto err_free_priv;
> > +		goto err_free_inode;
> >  	}
> >  
> >  	mapping_set_gfp_mask(inode->i_mapping, GFP_USER);
> > @@ -309,11 +305,7 @@ static struct file *secretmem_file_create(unsigned long flags)
> >  	inode->i_mode |= S_IFREG;
> >  	inode->i_size = 0;
> >  
> > -	atomic_inc(&secretmem_users);
> > -
> >  	return file;
> > -err_free_priv:
> > -	secretmem_destroy_inode_priv(inode);
> >  err_free_inode:
> >  	iput(inode);
> >  	return ERR_PTR(err);
> > @@ -335,6 +327,18 @@ SYSCALL_DEFINE1(memfd_secret, unsigned int, flags)
> >  	return FD_ADD(flags & O_CLOEXEC, secretmem_file_create(flags));
> >  }

-- 
Sincerely yours,
Mike.

