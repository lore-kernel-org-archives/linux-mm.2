Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D9D4E9126A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 06:36:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58CDF6B0096; Thu,  5 Feb 2026 01:36:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 537956B0098; Thu,  5 Feb 2026 01:36:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 419816B0099; Thu,  5 Feb 2026 01:36:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E2656B0096
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 01:36:34 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D1C401403E9
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:36:33 +0000 (UTC)
X-FDA: 84409444266.06.72BF091
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2A956C0005
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:36:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Jeu09bjB;
	spf=pass (imf22.hostedemail.com: domain of nirjhar.roy.lists@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=nirjhar.roy.lists@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770273392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vH999gu9cF8Ex6UpWJyf9ehfO8DS1HfN7WwuwJxfEkk=;
	b=Cv6Vt5cIe7266SbNR7gs95lCS+Arrowe1DSZshG4i149QDKUiPr+BaRdza+b+V+d6nIVM1
	y37IwoBotrkypUxZplJBsMte73i2OqobWl/0eN41Z2zFbozMyrx+JL35HAzohUpYv0PpX/
	HB3LxIpMo8NFcrKWQgtYxkNZDxPkI+g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Jeu09bjB;
	spf=pass (imf22.hostedemail.com: domain of nirjhar.roy.lists@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=nirjhar.roy.lists@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770273392; a=rsa-sha256;
	cv=none;
	b=dd/Ka7k5FaOhMjl5EnAsnug6p0ZCJ+Pca6wnNAOHPaWwqGQTew4jZn0LxMFO1tWvQzvRw4
	nj+lnN5zF5AOSPw2pDBb5VTMpQoT39nnL7xRuhe74pxEhNUSuASpqjxd6GuxKUZAB55jJ6
	/euPEg4di33orb5E0CfPxqluhNoFIm8=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-81f4f4d4822so345921b3a.3
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 22:36:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770273391; x=1770878191; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vH999gu9cF8Ex6UpWJyf9ehfO8DS1HfN7WwuwJxfEkk=;
        b=Jeu09bjBWVAEm0b9XkQe3aGnxJzm8khwzfiHQET3bVRzwJOMl6VgY1D1lfr52k5jxM
         5Chs92PshUsY/c6/dWMLHA/BFdIKi3a4KhwzJRHsF3/Hsq+DU4yk5MfjqM1x9ECb+E4S
         RCkJ4n2ZGrMT1idCYBArYnBFZMrH8X5esv2lkVmJEZoZeaMPY4cUvd69GWQe6nnADeQw
         e4jqXlUQ/GVz3KOVvxYJVyH8AYPrPzDBQklQMyPuFPmnmtXrlNIEyAIduHe8zQsquBFb
         kjypKzCSoxYCic3QRfwHGYdJd/KQu4d3VA3fTPcYB+IBbuKDPjxDTfPHe8umgp5IMcER
         Z4kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770273391; x=1770878191;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vH999gu9cF8Ex6UpWJyf9ehfO8DS1HfN7WwuwJxfEkk=;
        b=IegtA3GW1vmMZ2Z8MYexrJIBU4fSE2JPuc3isbhfbJWyrvhK0u9ehMCEt7eCZXCEXY
         FlFXQQVCskfGOhn6iVFRBz/PUTET8tVFiFvqQVYDX9Em0fgXdguKW59wfxN3kppS5ZWs
         HUzf0YufUA2XOdPznsdpCv7K/3ict4cIIJxv2jawGponjRg6HlU+Z51ns9emhFPcIbZz
         6TCqEt1cPLA6xIy40mYQIy3ekLbD4tSM1ugPoqzDvAVphOXZLBDQyokdvj2Cxik1JER8
         EkfdQ+CjUMeiM/85WzN4swQ/NThJMR5qyXoZxCaJPIVJW1hsHvGe1b0o9JX/a1PV1NDk
         M6hg==
X-Forwarded-Encrypted: i=1; AJvYcCVUPz8gs+DuJfUDAuiPzFRQm7x76yz9Eikk6bX7r1mzP4ecgdRBuEsjfrP/Ln9PrM+kgJeT+5p5ew==@kvack.org
X-Gm-Message-State: AOJu0YyjAZP9+iU283yUGFUpsuzCPqOyJ9OgPTsyckqiR+bh/A0zfs8U
	1osnAWvW1i3Nbp4KKo4N/q6da/97yEo1Lm11ytQSTjByoGf7itqQl/cs
X-Gm-Gg: AZuq6aIFkzqXNskvNVvQFuyo9NdhOwJwSP59s0r0DHgq3Hmi0Lq9ynN+MwvoqrIz6Js
	djHtIlBtXeTMauOoF1pQvfaDYnNeqxCH8454SPmyDRuwi7gGCZqZjaKM6UHm01oOOt6VrqaDJXJ
	6cPKRAUKBOJ6uPuGuaYPzpAeqxAjI8zQ8O6DDr1bvvCFx+xrrdzWLmEx8NdF9BrRvBHLG+4mJDj
	9TrL72me0O5KtaptsvJUqS44awtmlJ6K4Vltm/+wc9uuza0ohZ5ri+VoSVD7PxRKeE7uIkHTZel
	uIEZJqZJ0KnpCpRZs7zERbvaXXENoVfGvBZRM5swAta6d5j6iYruCqvig8hBiL9AKg//t9VbrOE
	9kNkxBsQnEKZv5tBVAEmJUWtRpmIjS7dqP+9IoOY8sCUbR6lTMYeUiWXu9b49AJ90KHmJnG4iUT
	wnQ+GaS8EPdsWZ0jL6CAXigonsKnddK5ya6yS1sb0GvsTJE9eU31dLOtwb1L6zLqw0
X-Received: by 2002:a05:6a21:150d:b0:38c:627f:873f with SMTP id adf61e73a8af0-393723a5662mr5102313637.45.1770273390885;
        Wed, 04 Feb 2026 22:36:30 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6c8321cb78sm3885009a12.8.2026.02.04.22.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 22:36:30 -0800 (PST)
Message-ID: <87a16d4d9c1e568a37fa07a97dda5777e14e9a8b.camel@gmail.com>
Subject: Re: [PATCH v3 3/6] xfs: add per-inode AG prediction map and
 dirty-AG bitmap
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Kundan Kumar <kundan.kumar@samsung.com>, viro@zeniv.linux.org.uk, 
 brauner@kernel.org, jack@suse.cz, willy@infradead.org, mcgrof@kernel.org, 
 clm@meta.com, david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
 hch@lst.de,  ritesh.list@gmail.com, djwong@kernel.org, dave@stgolabs.net,
 cem@kernel.org,  wangyufei@vivo.com
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-xfs@vger.kernel.org, gost.dev@samsung.com, anuj20.g@samsung.com, 
	vishak.g@samsung.com, joshi.k@samsung.com
Date: Thu, 05 Feb 2026 12:06:19 +0530
In-Reply-To: <20260116100818.7576-4-kundan.kumar@samsung.com>
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
	 <CGME20260116101251epcas5p1cf5b48f2efb14fe4387be3053b3c3ebc@epcas5p1.samsung.com>
	 <20260116100818.7576-4-kundan.kumar@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A956C0005
X-Rspamd-Server: rspam07
X-Stat-Signature: wb6e17ohumhuuohugeh4tqefxbaaw4o1
X-HE-Tag: 1770273391-661350
X-HE-Meta: U2FsdGVkX18p3nil/eUc4m89yilTBkUBxa0OEdp6b0voixu6QwVdRAxNmnE0oFmY6iLrvv8LCseM33kyoi5tDZiPf4NhBO1sTaHX6iH8R5mYI2Fy8u6aXjlshDcru8I5KwSU+87Mtk/NN/baY+qjujKhSXnDqWr7iOaLd9WxuBtBwBRuqgvoA6WW/vPe2tKWIn2wECqpqF44O3ryB0z+YcSMysNu72LGh+KiEU3eF1FTmiJeJSJrLI1RbvuBJGKvTPJMyGdhgMfr2WtUdGVshHQYAP5QyCK7o4xElQxzLznQt+/Z+BZIdkrGrITaKcVpLn5tllbW2dIPTlmuZpQCwVUIsgAK6Z7lAl1r4nIzwGcmP9QFMcwOxt5Kjrcn0C5vUAeuxQic4mjlv9ogM/bpmguJtmD9eoPxZisCFqEKGrKW4vFRz6s4sJHQsHpuiPlO3tkjvSiYQWdWoQvpfym6V2QIe6GFKxIWyrPadtsLGnnEp3e9ACd54SO0lC9k35F2b3IxP3sodbunhMYAHwucLhm6vkN3NoATURcffxe7pKT/4TOLGOGsD4rdY9/s24FDQl0YH3CHnUUXChfp9+F7U9Nl4CJorj0cKIK3n1y0GslRQeEnr6GO6uzv+cjaTOfRcB6T0qYL7auYoP8vMWN0kiedWK+DZ89zURDgQm1XlOFkyDH1TetuseqWvqLp06LBJHWtB3wX4QhsjlXuY1yW3gr/Yg2G7pRFwMjLOOaIZeoHIEsTSCIOvmaO6vVxj174XM/fTSGSH9qU4nZ0knI4tGOH8TCaPS8hVNE0IIDgwnxa4rsd4yRPBRHjL1RDz8IoZdZHfdAw87ZameqITJJMewlGAF5XCezBLCG+pUOmCEHhsxlyx2k2jy95381YvIdggWeudF1t+QS9qWWdNVYv26vU1thKiSWxZLD+v6AShI5TF7FhmjhaRVdf0Lg+SISuTIJBclwNDEXrV0vb6L6
 CIEG2+if
 RRa6wQbVSolLLfE4WtxZBs5xKyWlxhAKpE0+R+S48DsqseEb+eFK/Hqk090IZufrfEj0H+yPluysaedHTrYool58CYGqNacxhKUcrqLdXXpR5Jjx0UXzJ6C8JZP/SD01SDUA+xZEhGBXzqxoMq8rkD6AjZHJ3IwLIo6TrnwQWdCz9wtXG5NnPKVq/AgMp+CRAYlGkUhdHJN22VDr9sQSqflyGsKStPTP6LDuhcf9HDwAp9b4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-01-16 at 15:38 +0530, Kundan Kumar wrote:
> Add per-inode structures to track predicted AGs of dirty folios using
> an xarray and bitmap. This enables efficient identification of AGs
> involved in writeback.
> 
> Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---
>  fs/xfs/xfs_icache.c | 27 +++++++++++++++++++++++++++
>  fs/xfs/xfs_inode.h  |  5 +++++
>  2 files changed, 32 insertions(+)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index e44040206851..f97aa6d66271 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -80,6 +80,25 @@ static inline xa_mark_t ici_tag_to_mark(unsigned int tag)
>  	return XFS_PERAG_BLOCKGC_MARK;
>  }
>  
> +static int xfs_inode_init_ag_bitmap(struct xfs_inode *ip)
Similar comment as before:
static int
xfs_inode_init...()
> +{
> +	unsigned int bits = ip->i_mount->m_sb.sb_agcount;
> +	unsigned int nlongs;
> +
> +	xa_init_flags(&ip->i_ag_pmap, XA_FLAGS_LOCK_IRQ);
Nit: The name of the functions suggests that it is initializing the tracking bitmap which it does -
however, the above line does slightly different thing? Maybe move the xarray init outside the bitmap
init function? 
> +	ip->i_ag_dirty_bitmap = NULL;
> +	ip->i_ag_dirty_bits = bits;
> +
> +	if (!bits)
Umm, !bits means agcount is 0. Shouldn't we ASSERT that bits >= 2? Or am I missing something?
> +		return 0;
> +
> +	nlongs = BITS_TO_LONGS(bits);
> +	ip->i_ag_dirty_bitmap = kcalloc(nlongs, sizeof(unsigned long),
> +					GFP_NOFS);
> +
> +	return ip->i_ag_dirty_bitmap ? 0 : -ENOMEM;
> +}
> +
>  /*
>   * Allocate and initialise an xfs_inode.
>   */
> @@ -131,6 +150,8 @@ xfs_inode_alloc(
>  	ip->i_next_unlinked = NULLAGINO;
>  	ip->i_prev_unlinked = 0;
>  
> +	xfs_inode_init_ag_bitmap(ip);
xfs_inode_init_ag_bitmap() returns int - error handling for -ENOMEM?
> +
>  	return ip;
>  }
>  
> @@ -194,6 +215,12 @@ xfs_inode_free(
>  	ip->i_ino = 0;
>  	spin_unlock(&ip->i_flags_lock);
>  
> +	/* free xarray contents (values are immediate packed ints) */
> +	xa_destroy(&ip->i_ag_pmap);
Nit:Maybe have a small wrapper for freeing it the prediction map? No hard preferences though.
> +	kfree(ip->i_ag_dirty_bitmap);
> +	ip->i_ag_dirty_bitmap = NULL;
Nit: Usually while freeing the pointers I prefer:
t = ip->i_ag_dirty_bitmap;
ip->i_ag_dirty_bitmap = NULL;
kfree(t);
In this way, the pointer(i_ag_dirty_bitmap in this case) that I am freeing never points to an
already freed address.

> +	ip->i_ag_dirty_bits = 0;
> +
>  	__xfs_inode_free(ip);
>  }
>  
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index bd6d33557194..dee449168605 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -99,6 +99,11 @@ typedef struct xfs_inode {
>  	spinlock_t		i_ioend_lock;
>  	struct work_struct	i_ioend_work;
>  	struct list_head	i_ioend_list;
> +
> +	/* AG prediction map: pgoff_t -> packed u32 */
> +	struct xarray           i_ag_pmap;
> +	unsigned long           *i_ag_dirty_bitmap;
> +	unsigned int            i_ag_dirty_bits;
Not sure but, I mostly see the typedefed versions of data types being used like uint32 etc. Darrick,
hch, are the above fine?
--NR
>  } xfs_inode_t;
>  
>  static inline bool xfs_inode_on_unlinked_list(const struct xfs_inode *ip)


