Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B7F5CED24B
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 09:31:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C5CA6B0095; Tue, 18 Nov 2025 04:31:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 776046B0096; Tue, 18 Nov 2025 04:31:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63EA06B0098; Tue, 18 Nov 2025 04:31:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4EC396B0095
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 04:31:46 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0F01D1A042F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:31:46 +0000 (UTC)
X-FDA: 84123210612.05.63E28A3
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1823F40009
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:31:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kh9QNjO4;
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763458304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LfSnUyyR+gHh/pyEYOi6VgVjJci+W/poycFy7JdBT/c=;
	b=QCme7eDHwNtfkU1/QeQuVIqOUmuBHfR51PBR9yQUFcoVMju3NOypsAuXggWkxYQZO7RU1D
	jqPfHWzhgBcWk78GioFbby/7jKZJ7T8Onw5Tr3N+q18t9f9gpBLeHZKY0Lp8VuIOBID9wQ
	8dkVamKOvQQrvBEjnTEJg/G2PCZdYb4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kh9QNjO4;
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763458304; a=rsa-sha256;
	cv=none;
	b=UFkCPybgVfJBoWO5J60HIp5nhomQFlNh1Vem5yb+HYkTmT0V87d5jm0e5BhOe45+bH8AGX
	t/5IKNkJ1LreGaRjX4YG6rXFPvlxPoicmUFE7mG26kPWCYNYuqngCv1D7L/RpYOFT5XoFI
	tWSQy9TbUeuAsOa6ilWI1e22/hQmTlA=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5942e61f001so5289392e87.1
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:31:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763458302; x=1764063102; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LfSnUyyR+gHh/pyEYOi6VgVjJci+W/poycFy7JdBT/c=;
        b=kh9QNjO4hkl7ngQG1rFgSjuTPSEHou+tUy3wp7BeIsf4bQg9KjAZ/r16Q4gqXZ7kE4
         n/9I5YYlblaepamD5rVEzHyGI6hPlhsul+pqacdw5w+gyCPq/CBYXS5wGzy/PY1UMWPs
         y9FQNd0rp4P3ElE9cVEq4Jss/p2e6g27pQdFgtwOKDjB/RuHO3d0OxUVq7oQG80shx0s
         T5VfZVZbE1vY8VbPktKviw58Bgr4bDWdLXoLa4cHdUNAbVIYXKDrqu6A7mf4FjZmPAdT
         1vNg7tIhQ0szUozpEObKtVqyFWF7g6cdwy8T+lVMv9796Gjm/6yxmLTczbqVI1ofk/Ic
         O+lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763458302; x=1764063102;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LfSnUyyR+gHh/pyEYOi6VgVjJci+W/poycFy7JdBT/c=;
        b=Q4fuqEUPVOr9yX4Q/69OIYEZWklZphf9RJEuEy3VDDQWDdWGPGCk5NE2jj6kO4eaPI
         tKuAvudgszKZjp9W62FzXYGIazY3+eD82Cgid1PS+rJftUfgy91egrdQc/vmGZ2pIGnZ
         M8rb4qdeXFJYAkW+UXDKEnCW4DdHrh2jvep4SbG+jlnU8F/hpstBT0MPnXDh5REYTbgk
         BlGW+Cw/JMc0BDJ5J8sXxqy6KSBpE1PG5JeaV85e/gRcN+D1mZ/iuDSqj3RvRwd//EiH
         Ts/sVVPce7CLZMXZxngy+cND7c7dQSEs59WtQVsCUTrEO42qOSX5a7xWsIXmpbltCtYa
         2pqA==
X-Forwarded-Encrypted: i=1; AJvYcCXxwu7s/DccCu1I9lclQ4glr4dWtV41Ow/XCaIN3HDNQW/mzGPCI58YRfSUmVbummYLp2DbRxu0CQ==@kvack.org
X-Gm-Message-State: AOJu0YxuHP257PRYfj0CORmNrx2df7pN5i0Zx1Kj0MrUQbp82vFoFZrb
	eVIrGTXXEN06hg3CO+kNoQ/EVPROkPMldT5rEkd/XnK74cdMV6J53Tnn
X-Gm-Gg: ASbGnct5jmoT5exi/L0xGJIIoycxrvB54XmP5xN+JfwWjxIoTiMbsFDQwwlOp2sk4Hn
	AImiK5a3iVovgTiKU2GzZqHk19N9XCZgSftl6K4XnbSuKfw826LbE2pO7vyht7xKa1lugHdKKzo
	pUGm/EA5NS3NGj4kFScDqHmjjc4u5W8wvf+UBvNxuwn7RbpACHKK4qvqimAjy5dR3YbFuryYqdq
	R9VUsauPs2g39bezLUi4oybVLOpqUGxNJcs/2kUVPcBT20al6nPBZLEWTMgu4Oqoz3Eui0NhxFo
	GFLuxOzqDmOZ7XMkWV5M6DPesoRozXUYSkdpxWpVz0hYBXYqEUtUExFsgUvJcR/klNxvmSf4smH
	kr8eR9+qIgq/quLAm6SU+I01JmcEfj97srFfmuimkHog=
X-Google-Smtp-Source: AGHT+IGnlKspAS2We2FABx815t9bNQvFsXJy6XwUcpIvRdQFlzF9XlXS5jEyZ/AKjBb0WZzRlZkYAg==
X-Received: by 2002:a05:6512:3b0d:b0:594:314d:ac53 with SMTP id 2adb3069b0e04-595841ba374mr5520844e87.23.1763458301885;
        Tue, 18 Nov 2025 01:31:41 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-37b9cef2bb2sm34960441fa.46.2025.11.18.01.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 01:31:41 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 18 Nov 2025 10:31:39 +0100
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: david@ixit.cz, Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, phone-devel@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc: warn only once when vmalloc detect invalid
 gfp flags
Message-ID: <aRw8-7Ox5TPewpw_@milan>
References: <20251118-only-one-vmalloc-v1-1-29f8eacb4605@ixit.cz>
 <aRvI_VU3NOUaxfvk@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRvI_VU3NOUaxfvk@fedora>
X-Rspamd-Queue-Id: 1823F40009
X-Stat-Signature: 5o6gur5zzgur5whdsnf3dowrrk4kcbni
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763458303-856551
X-HE-Meta: U2FsdGVkX1+D6dABo2oWSrDUSjYeBF4pLVCKsWixRxBh7dkav7j6G0O0NM6GEXV7/RqspNaXzwSi0PXuvCJpekn5B6p5CuKXKIZDampvRoDjeTJdE9a21ygATnUMHTMAIufbjOBdRiWVqqCmhOk7gJ0Y4LXvPVwgZ5cWizqqUKB4K2v3PgRA/AdvMqQZI8b6vF81xZGBE/E+oQ7HcnliSYCZ5s0cU5hlFSZQMYWbBd7tnd7HWys9Ef9jYeJ/+RZ4lcWocyBGO2ZUSkFUthXakv9gVvnEnPMy7v+XtVUQlThrfaMUngmYkl0Xcd7CvuSFc+njrDH3I6IUDLFVb16XXwoL7eI7H5TYTVPE/4Vl0Hi7s9zZGtk5OxAvbqVBG47xJBGD/PsYfL3VqfKtvP0AwyWTcWQod4uDVpUq60XI8SQ5jo1i4ROldgVVsRL1Ksfg224a39fI+MkSqrGV3UvLRzy1UXkYUyaPxBwmAgwlFTsb6UYm063nrI+OzyGdJzOEYOOCposHDSSTQ87hXMGNPOewBxyCGFXq46vMNXqcWkv7or43qirBmi4AwWplfwGg81NMR2rupTyIffxXnTjX4svL3Y9dvG8Tp9xJ9FDeRkWLtebzBsxyWB4eQtuidKpQNFj62GEQ6BKQ+u1+wbwAbZLQg4hu2ZlvqFj7WoKeDFAmxK25P56zeVnDtwNTcqCtviAZ6nIQKTBGQOFAGtC/kiC0LmwZCW2+Iuj5lMdoEkVIxeoAGsOw43DFLH0ROer1a7RLlb4UrYL2opdtFAlZBxtifOAjAk1vkKiWOG1lah6wlcmn03qdXhbgerNUljLtraaTrim6OuNGIcs9Wu1UFbXl2v+2763Rqlf7US5oqq8oSPmNRrTL0otbvP2+KyncX2wwIoOaU8hRb+TQ52rsFwncQg24GM/e2/K/HtKC5z2l2K+VfC78+uRj60VZMnGj3M2G6CvF8s1htGi7JER
 fIIvDHIg
 ES0uskzNrKDgz3XqdYneUb/hb10/ZarlULiJUdBgbD4JOEly2nIT4pwBNTVVE4GYgPhg2w+s55oV5XcmDGiu86dhexVHTwLgI0CCSB8tfWpovPHw38rPCYOkcv9hRTEuYX68ycqhfoRrmeht3wyHH+I+daaAfzKNtBZIHC/4hxINTVtG3DYv+T9+b6h6ohgLLoVwviq2VcRi5OWDo4ZdDe+BgqZSCCz2jVXhWkxXvils0oDQ71CET0oiqfgNHM41eD1dcBvkaGI3U0M/GaJ1dO+UNoQocA5Y2kV25nIkV9clX95p1JKyAbrV0pHyb99LgcKCkMbjqW41AU/g3R7B1EPSm5vVXW0XpLcxKKfh0lStLpHGmToEkE1BcfoWr9/1NAaWHLJGwBDEYNalbhCUowh9nxlpLWeiaoOk0z7M2P5T0lXZJRHb26yGnkxMrUX0Bip9KsuKXSi5CG1uR4huZexK0Y09JvJ4fJD8mb0QF7GKrltNPi+4VmVNNbThgRS6u+DgN5PAUyGBJLMDoCkyQnxT0DgiQl1awM5ES
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 05:16:45PM -0800, Vishal Moola (Oracle) wrote:
> On Tue, Nov 18, 2025 at 01:05:57AM +0100, David Heidelberg via B4 Relay wrote:
> > From: David Heidelberg <david@ixit.cz>
> > 
> > Without WARN_ONCE, the logs get spammed immediately after the boot,
> > on devices as OnePlus 6T (Snapdragon 845).
> > 
> > Fixes: 7179b2256315 ("mm/vmalloc: warn on invalid vmalloc gfp flags")
> > Signed-off-by: David Heidelberg <david@ixit.cz>
> > ---
> > I'm not 100% sure this is the right solution, but having WARN_ONCE or
> > rate limited warnings here helps a lot on devices as OnePlus 6 (sdm845).
> > 
> > Please let me know what you think.
> > ---
> >  mm/vmalloc.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 49e0b68768d73..2a3ee17093d6e 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3934,8 +3934,8 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
> >  	gfp_t invalid_mask = flags & ~GFP_VMALLOC_SUPPORTED;
> >  
> >  	flags &= GFP_VMALLOC_SUPPORTED;
> > -	WARN(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
> > -			invalid_mask, &invalid_mask, flags, &flags);
> > +	WARN_ONCE(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n"
> 
> You accidentally deleted the comma here. 
> 
> Once we've found all gfp the callers currently use, we should never be
> hitting this warning, so ratelimiting won't matter. Either way is fine
> by me though if you still want to fix and resend this.
> 
IMO, it is worth to use ONCE variant to suppress spamming.

--
Uladzislau Rezki

