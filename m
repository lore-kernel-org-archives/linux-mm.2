Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7A6F108B901
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 11:35:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31F4B6B0088; Fri, 20 Mar 2026 07:35:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D0206B0089; Fri, 20 Mar 2026 07:35:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 197FF6B008A; Fri, 20 Mar 2026 07:35:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 087716B0088
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:35:31 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A6E741401A0
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:35:30 +0000 (UTC)
X-FDA: 84566236020.21.9A5A64D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 202DA14000F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:35:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t4ETvcgG;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774006529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xycleNK2sIci1vynO6W7JkfEo0hraNqpapd6SkyQhBI=;
	b=SURn0Wx46ndrldTAHIWTXbpVq9lW0Zuw17E6S3EndACUXr6WgdGAT5lSWcJfIpB+pivwrn
	cAkcLPxMIqmZrNr5q6EDAnAnE7y+Ak/AtdmjZCaH9XkOUB251qwBNIVwQuZpG/Zawqs3qK
	6jfIk1IDco9met8SsDU0YqwzjaF2uts=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t4ETvcgG;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774006529; a=rsa-sha256;
	cv=none;
	b=Mq+xeeb7i/py/vvqT43IRoZ72N7za8NSxfrHDm0GubzJ97rQC7Akb4ZbueZ3zPtcJVh9Uv
	VBPzHAQAe8vjdKdJIQs9QZXsBYxfY+6VqFQ697htyvkgmgrU+xYP0opDz+yFj3avY98ARZ
	G1fMYXxF/FkY3/f3x3LsQTSzfIy8IDY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 80D4C60126;
	Fri, 20 Mar 2026 11:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1331C2BC9E;
	Fri, 20 Mar 2026 11:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774006528;
	bh=9pNvu6S6oDhM5h9WgjMrUwgzjvJ+ZdQO7AyPrErzbh8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t4ETvcgG+DtBZacynsUwUuZzc9gslv6ATrxqYuzM5SYDxYfMTJwJDAsaphiO+bvvO
	 OICL23t3UAxusfjHjVPExe4XEhAXpYpoOdlmD5QaRgAoXbGt/+EU1rx4kdZui/NOSJ
	 oEGXus0qrZn9Mu47YVU9qp2UUNi3kVi2ss0cmW8LbGfxEz4wc4/HRpost/ZSflILHB
	 rD3hTQAh7fiymU01Hv+QWJg80hKaQ4b2uEY3XwFrWPkHiOy5rBU3msgnspXcikMgT2
	 VMvXXysLtGhQ6LOTSijog2x7X8hA5lpL2caBJ588S+wvIMyL8V7pF3NM5Gfy6SCArG
	 b5FdpcagKWM+A==
Date: Fri, 20 Mar 2026 13:35:21 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Chenghao Duan <duanchenghao@kylinos.cn>, pasha.tatashin@soleen.com,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, jianghaoran@kylinos.cn
Subject: Re: [PATCH v1 3/3] mm/memfd_luo: use i_size_write() to set inode
 size during retrieve
Message-ID: <ab0w-XnXgosQLOKc@kernel.org>
References: <20260319012845.29570-1-duanchenghao@kylinos.cn>
 <20260319012845.29570-4-duanchenghao@kylinos.cn>
 <2vxzqzpebzi2.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzqzpebzi2.fsf@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 202DA14000F
X-Rspamd-Server: rspam08
X-Stat-Signature: chr5xfhrzmw6xuuprfzytuschs9ietc6
X-HE-Tag: 1774006528-844027
X-HE-Meta: U2FsdGVkX18hAFtNI9QhcPWCn/E+MasdGzTm8MtPhrqFlWZLX/pQIRlqqshBDpm+7ect478MyHX+By8SaFpmJa+O6q7A3mQIOaxjF9bn+/OaIK8Kf+6FZ5bSuywrX87o/AsH+as7DA0rbID3Mulgscvu+Ne9zNve2x5Gq5MJltLb/i0sXzChm94vMesbhkHHRH+4kCXKycujKQ5eoy65vcXXiMzt+tlYk9dLSFq+cLBADNTRa+4Wh5gkccjvs5K7t4z3sU/EONqNYewslzoE3CjM5l5EaZ580Ojg6lKlPuvHpdGSjewzCBi2TztZmSnB9dJ2uNGbtg8HehCPNWdlnMjtlDPMdaE5StIXSdJV7Nrb3ehIxPQ3fJxXhLTPZWeizX4/UFynYsSRSDyVqlXnrej/ZIyQEX2eCmJKakgMOrzd9E5BdDK5LWIFBjYqeMgauUVxMb1pMXJQsNOWqD8ZI4VxEtpgVAo7iVEvvqh0HvZO4VuOAovXWXPl5ocvqNMpIWvPp8DXZZLSpaaM+K8lUd6jtPmXNl7krZUhmwxw8KTfYSXbEZ9YVYlTzV46al51aenWcV0c9UpXtj3Twed8iih1tVV5oD6hucGt5Us4cZYhbIg7A86m08rUtpGBmFBqCfcI1LpcM+pwaclsTO5ZdweMl6hSufE+7p1NOvDqmBg/tTZNr0Daf7Zx+qAj5vV6ErbCktISz2SQSKlRdIhnnvFAKGFypbkJMX/IOz+WSFxwLA5EC81wUS5PTUkSqX2V04hTz/JyLu0bbMHc1Khn1d/XJzz7BNT+XjoASocJnLwq0Z5+9K5Tg7fnqLk2H17k9tQBou08YHC5NV5+m1+sipHg40TgZ6/6KekBJhHIextVcSz80MQDpgpUbXW1XnqRUMApkUiOllY/+6FfhLk6sPCSizz1lKiL8nLbvexO1gHLnpWrcL91FG5kM2qhoizTjGJ/RcVX3fFxCcbFfC5
 vehJ0aFA
 ZzvOjgjYhVD6vnDcJHUF2yYcZE1fFamRAna3KKUQf9OMuZ9yOuo/V6QcQQERAlBOUeaWZSaYlCfjbYBq2auI8uUwr0/U5BeN3hx0c1iAUfw3YRzI2tPr1DbxsJLOkw7bNBoqEI+v6c/eN6xuKETINo33iBb7USq8RE6FrJSRlGeLyQZ9E5Cj8W+Au3p1cB4jMuy25+2t8WFXA3LO1hj1gBEFgQUgyGbJFbNX2OTCiLJG5wk36WQG648P5ylI1GbAJximpVY0Unz3qokhKqmxUEstz9DzwycucoupMM2pV8wHqJzg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 09:51:01AM +0000, Pratyush Yadav wrote:
> On Thu, Mar 19 2026, Chenghao Duan wrote:
> 
> > Use i_size_write() instead of directly assigning to inode->i_size
> > when restoring the memfd size in memfd_luo_retrieve().
> 
> The commit message can be improved. It only explains _what_ the patch
> does. Readers can see that by looking at the code. So it just repeats
> information that is already there.
> 
> To be fair, for more complex patches explaining the what does make sense
> since it might not always be obvious. But what is almost always be a lot
> more useful is to explain _why_ this change is made.
> 
> I intentionally assigned i_size directly here. The reason for that being
> that no one has access to the inode yet so there is no need for the
> smp_store_release() since there won't be racy accesses. So my first
> reaction on reading this was to check if I missed some sort of race
> condition. I don't see any, but this is exactly the kind of thing the
> commit message should say.
> 
> So please, explain why you made this change. The reason can be as simple
> as "for consistency", but there should be one so reviewers aren't left
> guessing.
> 
> >
> > No functional change intended.
> >
> > Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
> > ---
> >  mm/memfd_luo.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> > index 413df8c75c1d..5e5971f25c68 100644
> > --- a/mm/memfd_luo.c
> > +++ b/mm/memfd_luo.c
> > @@ -500,7 +500,7 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
> >  	}
> >  
> >  	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
> > -	file->f_inode->i_size = ser->size;
> > +	i_size_write(file_inode(file), ser->size);
> 
> For the code change, I am neutral. I don't suppose it makes much of a
> difference, but if people think this is cleaner fine by me.

I'd also add a comment here explaining that i_size_write() is for
consistency :)
 
> >  
> >  	if (ser->nr_folios) {
> >  		folios_ser = kho_restore_vmalloc(&ser->folios);
> 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

