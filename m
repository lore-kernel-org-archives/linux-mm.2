Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5781EB28C8
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 05:41:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C1796B0089; Fri,  6 Feb 2026 00:41:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16F906B0092; Fri,  6 Feb 2026 00:41:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0509C6B0093; Fri,  6 Feb 2026 00:41:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E8F8D6B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 00:41:55 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 893778C47B
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 05:41:55 +0000 (UTC)
X-FDA: 84412935390.01.B3CC9E4
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf06.hostedemail.com (Postfix) with ESMTP id A5D96180006
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 05:41:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NBeWTp+D;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of nirjhar.roy.lists@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=nirjhar.roy.lists@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770356513; a=rsa-sha256;
	cv=none;
	b=CJLOTdbSaTHuASWId6yRtOBl6+z5rk6cwYqabEohhtGW4X8Nqo9IYRh5qCRSFJKwZRnqgg
	Ffuvq4v82C5cW/0M8obDp76LsmrP5jHSszNpSdcuj7y5Mwy6hTuiNMxYfUWWayqG0O/OUk
	cLMx3jqjr/j6Z4W/q9EJBCrPJsVPp/8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NBeWTp+D;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of nirjhar.roy.lists@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=nirjhar.roy.lists@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770356513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MACMIIoQrOmHwo4XgAmQe5Pv+MCpYfJt20up7XQ2jCM=;
	b=HMJ1g4gInph41iNmldci+KkN2IxSM4zhD52WBpaFTFj1CXTt6YGSq8hJy2viAn43lNpC1s
	TAETwHSYj4Ftm2xYivpsTgcIS98zN0EdRvvsa3wVRU7A3IinTcCsY9FqFbZoG2MbPXVW3i
	D+UpSttzrAhlUUteMVlrtFDpl6DYLiM=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-82311f4070cso1239110b3a.0
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 21:41:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770356512; x=1770961312; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MACMIIoQrOmHwo4XgAmQe5Pv+MCpYfJt20up7XQ2jCM=;
        b=NBeWTp+DprERIrcHrnbD0KyvenEfdf/rcHWHcUgVTc80leOzU3bz9VkEcMg6cY3z9s
         IiSCQMZW7g6ZT57Nko5VbjMG75NxiaImCRLhHZrjLgt62j1mZEVFZHJc+b5i9AiEVOUz
         CslhPYS8goo725Zm/7Wf6fPZZMoUkX03IM3dkOIAaLDNdcwkvQLBR20Xo5F2fJbSy8Oc
         3VidjusvKoFTKNTF4cvjvGnTeaWaRhouk4jplrf5hBgJ9UXLQCqIcHVHgWSoB20fPb6Z
         BrkitK+W3RW0EM//Fxlq/GfM6bGQ9vst/OlPlh1rahWcGbye+dCaNBkIhnGdt1SqXrtI
         0CmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770356512; x=1770961312;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MACMIIoQrOmHwo4XgAmQe5Pv+MCpYfJt20up7XQ2jCM=;
        b=rfw6ZXgmiYqnDtyNR4rJeAFeE1151jcdEfoKNSjdRUx0LW0sWW6CVX1gQKPrSU4e6l
         nOmS44ysiXyDUjeSOGJQZtxTh/9nMKOiMUTclrF9/tA3M5aVn0bMRa3jZDK7Yaa5akMO
         M+dtBnISucVU3yCWfRkRJ0mqiYRN097VspmMY7l/aMDxeDIOPtgUYrPkCX/SHda0mvwB
         PZuyH8un5qCFC1CA+ySG1zcDyFkEfPI5xsniTB76i00wzfGX8h+wEedcegMhoEDXoJFR
         zG8/yrXwWI2Akp5wTkQAEjQCWAT1by0c+NijNW7+HRFeqY9zC2wWrz95BGaTFdkh2i1i
         uD7Q==
X-Forwarded-Encrypted: i=1; AJvYcCW5DV7zGnkHc8DopzDoQzo5hQj7O8QtoBZjS/m0YD0hSF5wLgZYOv3agki5UHx+7ftf5Q1fhTqHYA==@kvack.org
X-Gm-Message-State: AOJu0Yw5HuUZeT0vhg8QfYJInjjgxDi6cZlXyuK3VIWV8MiDLK9IBvpW
	wt8lpWuZB+oiGbn72Uk9K6JT74++lmf7AGcAXrMQDkAxeSMTvo8fm/Pv
X-Gm-Gg: AZuq6aLRw3aIFeEq46pPH7v0pvkkJpnzezBRkhW1NIR3MvH9mFYCerKkc/QKA/GRFn3
	6beq7Ce0XxBS/Z7HpU38rmBQ819TLeJv/Ozm24jOfC84dHDMRt2BEQRt/GvVURTMqSynUruoBsL
	/CyKokg/NZ96hpcrg1vjwSO5DnNXh1xKlYY6kH4ZABkNO2pXillLAfu9J3Eizki0zHuz0rH2V40
	wKUhlbqOEnQzEKp00HC0eweQ6TIvagQeW+Lkit1VSd0se76bYWGyZknnWP3uJPZrh2NfLLbRd5r
	8qZmgtMmWWRXf4Cs0Z7x8rtc3LGWlVUA1yHwaOQ0J5tsppoDgbFEcIEvZsBF69RhkU++GS6XgF3
	j9yFFo0UbNmFWq4HspF+QTk3SGkpPxH7GF3LF83JDpV+DJqw8vqC9qGDDV0OvKu7esn5WwcQOWT
	Z0F8Aeu+fOzSGC9pky/rPahgrTSW+51E9IsvcQY5HEiTnrE0Fooggwfmlhf7BgPNMID4rGiVUvF
	C4=
X-Received: by 2002:a05:6a00:ac86:b0:7a9:d8a8:992a with SMTP id d2e1a72fcca58-8242d42ef5emr5239630b3a.13.1770356512310;
        Thu, 05 Feb 2026 21:41:52 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824418ff231sm1173972b3a.69.2026.02.05.21.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 21:41:51 -0800 (PST)
Message-ID: <c2a090bde81de463d3e2cc88f9ba06233e97cf5d.camel@gmail.com>
Subject: Re: [PATCH v3 3/6] xfs: add per-inode AG prediction map and
 dirty-AG bitmap
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Kundan Kumar <kundan.kumar@samsung.com>, viro@zeniv.linux.org.uk, 
 brauner@kernel.org, jack@suse.cz, willy@infradead.org, mcgrof@kernel.org, 
 clm@meta.com, david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
 hch@lst.de,  ritesh.list@gmail.com, dave@stgolabs.net, cem@kernel.org,
 wangyufei@vivo.com,  linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-xfs@vger.kernel.org,  gost.dev@samsung.com, anuj20.g@samsung.com,
 vishak.g@samsung.com,  joshi.k@samsung.com
Date: Fri, 06 Feb 2026 11:11:43 +0530
In-Reply-To: <20260205163217.GP7712@frogsfrogsfrogs>
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
	 <CGME20260116101251epcas5p1cf5b48f2efb14fe4387be3053b3c3ebc@epcas5p1.samsung.com>
	 <20260116100818.7576-4-kundan.kumar@samsung.com>
	 <20260129004404.GA7712@frogsfrogsfrogs>
	 <90870969cb6f04346d6dba603838abf993a42f5b.camel@gmail.com>
	 <20260205163217.GP7712@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A5D96180006
X-Stat-Signature: 1kow4s5ibpqsm15o3s5xoqtm64n18y5h
X-HE-Tag: 1770356513-675434
X-HE-Meta: U2FsdGVkX18mg2AOrDhWI0GXRetZeEu21AciRHnr57BBGG0JpcDr5HTyk/lqSVZR9e/nm5YBKtFzM+2vPOiFhQhBuRt9/FMKlKWGM5QhiT00oT3ULAauPQIfXCk4nWSd9WGCYNAUSZTdW8qqMeXieEnf0jr/p1RIWeIN4Q39AjVRE2O9e09xxlYDcYMVc6ldldylCBGmfJt7ooNEbN9Hz0Ngw+WX5oqU78CJk2OYL8KHvQMT1ZlGXySzDQzIC2Z9VvpLyLGNuL6HM7t019NQTGZyHNE7GSIH7rO6KORk8EOJaOMwGR5xcx2+9s2a53gP1pAXUmI5mfMCrQU30xSD36ytUZnSObzZz6g+a5Ix76qSg7UlvI2MteKkZRfexnV2K1JGGEEghakINi1a+8M/N3j9pOQDkDC5MGqFlKUSM7bDBUECzZVlJPbQlA1z1sjVbyQ6+BlGDnKW0ZkV644I0kMhJoKPDaElMxxgMdw98hzqLlq7QZ5gGYsYKP+4CWUP/Xupyua13B8TBBY8Jba7gTIsLUVne/duOqwqBrm/cPlCvv85rxhidTp/k0BalXzk8A3b9qJ0nODMBJtrC9rUo8A6OkmNLDMu4U6xXYI8HtcO+V2wL+A8hKrIAVn8sbEnn+7g43DaQDEBdZluBafzWdn9pmljo/XmemrXXSHVRaob7yCopVqqG356LRyypVcylbyhQ7Y3Lqr+PbCLiScbGnQbeMoNsQnmYoLY3L41J0nny5iSLtagmTFUYx6W9/6binx8Yw4XG6NKbq1N0q7IgIPwpbGANhyrBXWXxlf6d4JKeF8uUoZazBfJwvvM5ldOIxBsUskoJb8nKn25n4l7NcRPFpQ7ebbL/1rBb9/CD6Lu3rmIdwvgWnsOr0Q8KcF0rqjocE+tZnMFyURRrO5Iq5pDlNEnUQBtoMTzGl8+tmKVOetKbnkz3DWOzIGeUF/bvRi7qCc1L10cPSxAoq8
 qPFLb2I3
 77u0VFr2hh263V/rmH1uAOIBqYA3mgS4uG0KK81YOSKk4OW9PVVQMOxdo4swFfSWzUX7smNvNOfiAHBEWPM4Gwe8TWthsvE95K8R4MgHa1ugkgmQBt1rOXaysP6MuWv5mZxdsNmKBSkBfaGk3K7v3XqWG20J11sC6nGZOplxbCS+RnGvVhSi/KOfHjRCKV+sfVmK8tuu0lPVig6wd7mnBhU5n3QGKW4exgV0aGgSejIQPJzK/MytJcOb0KqOOZ0zP3DSjDj+229DprKDRxB0xDrkBQ/o56SQgrNoYzR6MdBFmgUHhzogHCSmrNJ5vX+kOQhEIBw1LtpRnDtutGsyjTYkOBu36lBZcZE0z/Wjqm8NRbX0qiw5HhqozRIh3d5+mbNmzU5ihPDHXRlZwjpIe22qJfyJZu7ounpG2uAN1e6i3lG37FyQkEGFw3PYsw76YWJDje4mddSgPY6oWSXWntl+F35A5vDPpeREdHOXQWMf61HZWMWUzfwu4Lpc/Hk3HeS9CsRNZ9vO0FXFPDhyM9pCGkRThjH73EuvGOndHJXWrw8tSXCVk6TBosNJ0vIJoAGq2XpCyL+KUt5VaEw/NBuW60aCAaqFXrX9qkSRBU5J39k0kXY6XAXpFB6esW6dhDAQupbxJotpBjBNXtqhtw6iWVd4bobODDPnIEjW1alHm6yo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-02-05 at 08:32 -0800, Darrick J. Wong wrote:
> On Thu, Feb 05, 2026 at 12:14:35PM +0530, Nirjhar Roy (IBM) wrote:
> > On Wed, 2026-01-28 at 16:44 -0800, Darrick J. Wong wrote:
> > > On Fri, Jan 16, 2026 at 03:38:15PM +0530, Kundan Kumar wrote:
> > > > Add per-inode structures to track predicted AGs of dirty folios using
> > > > an xarray and bitmap. This enables efficient identification of AGs
> > > > involved in writeback.
> > > > 
> > > > Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
> > > > Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> > > > ---
> > > >  fs/xfs/xfs_icache.c | 27 +++++++++++++++++++++++++++
> > > >  fs/xfs/xfs_inode.h  |  5 +++++
> > > >  2 files changed, 32 insertions(+)
> > > > 
> > > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > > index e44040206851..f97aa6d66271 100644
> > > > --- a/fs/xfs/xfs_icache.c
> > > > +++ b/fs/xfs/xfs_icache.c
> > > > @@ -80,6 +80,25 @@ static inline xa_mark_t ici_tag_to_mark(unsigned int tag)
> > > >  	return XFS_PERAG_BLOCKGC_MARK;
> > > >  }
> > > >  
> > > > +static int xfs_inode_init_ag_bitmap(struct xfs_inode *ip)
> > > > +{
> > > > +	unsigned int bits = ip->i_mount->m_sb.sb_agcount;
> > > > +	unsigned int nlongs;
> > > > +
> > > > +	xa_init_flags(&ip->i_ag_pmap, XA_FLAGS_LOCK_IRQ);
> > > 
> > > This increases the size of struct xfs_inode by 40 bytes...
> > > 
> > > > +	ip->i_ag_dirty_bitmap = NULL;
> > > > +	ip->i_ag_dirty_bits = bits;
> > > > +
> > > > +	if (!bits)
> > > > +		return 0;
> > > > +
> > > > +	nlongs = BITS_TO_LONGS(bits);
> > > > +	ip->i_ag_dirty_bitmap = kcalloc(nlongs, sizeof(unsigned long),
> > > > +					GFP_NOFS);
> > > 
> > > ...and there could be hundreds or thousands of AGs for each filesystem.
> > > That's a lot of kernel memory to handle this prediction stuff, and I"m
> > > not even sure what ag_dirty_bitmap does yet.
> > > 
> > > > +
> > > > +	return ip->i_ag_dirty_bitmap ? 0 : -ENOMEM;
> > > > +}
> > > > +
> > > >  /*
> > > >   * Allocate and initialise an xfs_inode.
> > > >   */
> > > > @@ -131,6 +150,8 @@ xfs_inode_alloc(
> > > >  	ip->i_next_unlinked = NULLAGINO;
> > > >  	ip->i_prev_unlinked = 0;
> > > >  
> > > > +	xfs_inode_init_ag_bitmap(ip);
> > > 
> > > Unchecked return value???
> > > 
> > > > +
> > > >  	return ip;
> > > >  }
> > > >  
> > > > @@ -194,6 +215,12 @@ xfs_inode_free(
> > > >  	ip->i_ino = 0;
> > > >  	spin_unlock(&ip->i_flags_lock);
> > > >  
> > > > +	/* free xarray contents (values are immediate packed ints) */
> > > > +	xa_destroy(&ip->i_ag_pmap);
> > > > +	kfree(ip->i_ag_dirty_bitmap);
> > > > +	ip->i_ag_dirty_bitmap = NULL;
> > > > +	ip->i_ag_dirty_bits = 0;
> > > > +
> > > >  	__xfs_inode_free(ip);
> > > >  }
> > > >  
> > > > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > > > index bd6d33557194..dee449168605 100644
> > > > --- a/fs/xfs/xfs_inode.h
> > > > +++ b/fs/xfs/xfs_inode.h
> > > > @@ -99,6 +99,11 @@ typedef struct xfs_inode {
> > > >  	spinlock_t		i_ioend_lock;
> > > >  	struct work_struct	i_ioend_work;
> > > >  	struct list_head	i_ioend_list;
> > > > +
> > > > +	/* AG prediction map: pgoff_t -> packed u32 */
> > > 
> > > What about blocksize < pagesize filesystems?  Which packed agno do you
> > > associate with the pgoff_t?
> > Sorry but I am bit unfamiliar with the term packed agno? Can you please briefly explain does packed
> > agno mean?
> 
> I was talking about the "xfs_agp" numbers introduced in the previous
> patch, which seem to contain the bottom 25 bits of the ag number.
Okay, right. Thank you. 
> 
> Really I was just asking about multi-fsblock folios -- which block
> within that folio do we map to an AG for tagging purposes?
> 
> I think Kundan replied elsewhere that it's the first block.
Okay.
--NR
> 
> --D
> 
> > --NR
> > > Also, do you have an xarray entry for each pgoff_t in a large folio?
> > > 
> > > --D
> > > 
> > > > +	struct xarray           i_ag_pmap;
> > > > +	unsigned long           *i_ag_dirty_bitmap;
> > > > +	unsigned int            i_ag_dirty_bits;
> > > >  } xfs_inode_t;
> > > >  
> > > >  static inline bool xfs_inode_on_unlinked_list(const struct xfs_inode *ip)
> > > > -- 
> > > > 2.25.1
> > > > 
> > > > 


