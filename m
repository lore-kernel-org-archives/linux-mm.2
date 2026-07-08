Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 710A4C43602
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 11:47:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F2FD6B00A5; Wed,  8 Jul 2026 07:47:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A3CF6B00A6; Wed,  8 Jul 2026 07:47:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BA7B6B00A7; Wed,  8 Jul 2026 07:47:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3AA7E6B00A5
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:47:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BAA1A91405
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:47:36 +0000 (UTC)
X-FDA: 84965434512.13.3A66B04
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf27.hostedemail.com (Postfix) with ESMTP id EC4AC40003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:47:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OzVWildZ;
	spf=pass (imf27.hostedemail.com: domain of praan@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783511254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yQthvAmb6mZfzW7rEXSGGNwecmdXpDNmUVxAWD35bFk=;
	b=dnnf8766XUK9hBdc3Hbm4rt7Zr3mOfLN0cjHMoD0tnRjWvaUio79WqN15gyCn+mIMakYCR
	QweRnAnSuzH4RfIf/Br+z2IPFjX3kci58vUuzftgP5pL0Wf2UNQ2syeZmV4e5rPprkhhdv
	TfbwiUIGEyDs++mvWZ59mZo5AsyYLU8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OzVWildZ;
	spf=pass (imf27.hostedemail.com: domain of praan@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783511254;
	b=D4e6X7KF1eBxli0hK6INsdycHMa1Ug9SPeODkJAq1uhEowp0d3U3odVhV98Fqi0kE0uwNr
	Dv9HDryOjy6wZJRk8COEpoxwAMV6+JPJOK1w+1MS4haCUYtblLbdSXL7E4zcudmtx19krp
	xkwAVOjZefSoPxlRBKZuLuyLGOd6PyI=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cab97c86bdso76715ad.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 04:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783511254; x=1784116054; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yQthvAmb6mZfzW7rEXSGGNwecmdXpDNmUVxAWD35bFk=;
        b=OzVWildZPWSVOwFhHsNIudOIAsA58vOpoGzKXkPmHSfqPpBNxudlqsGFizI7DbkOwJ
         7jsz7ugPiOAxV4t+BlFTpTjh6rl+fLFlC57Do1KFtMf0aVo0nKJOnICYb4tXFD84Ebe4
         tdiGznIpbA5tng7ZXF1U34YGADfvG6UREoWd9jyjOJ/PXsFBeY/XMekbmGmdV4RETRIC
         DT6uPNTVXwCtf78VUGhkZpAvlpDwhkHWkj8jlLIci8mMRbse7nQQI0UWui33mK9uSXj8
         H9PL7WDBq4FQJhJz3HwhNlpIAS4r3YPkMlKGBLrduJOcAG1cGdDqp4AhWaHyqTJBFC3f
         FP1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783511254; x=1784116054;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yQthvAmb6mZfzW7rEXSGGNwecmdXpDNmUVxAWD35bFk=;
        b=UHNSxNI01wAErSKKIR9JxoBc0Y8B5A9nFNVZkXoK+9BsVPTe6ABVPl5ZQ2geEzm5fh
         6VvQOzYVZt0OUdp0WmNUK7qlti3XSEx0SpV6Zqu/ILDLl1F88pp7hH+K5LBeJQSwtpe6
         G0oNy1aGSeGJj+wDOZHyoZZppoTyOuA9mtQRdHLV+0ppyNBOhnPVUvKnZch7g+of75Ni
         QDFVbqUmwdy71iw9nGwB8sa+1e8LAYwOCKG9rohvWyGp80zRvnWAywtfJR2dJ9Z3k7yw
         dS3NUgcXYz9PVp9jXxSHtMBgw5/HGSrgwULJDgawt5rtaxJGwvdbRmoLnW3/mp+c//40
         3eLg==
X-Forwarded-Encrypted: i=1; AHgh+RpVpKQm4LcaSMbMfyebjnEinPjCh2Wkr1gvrFGfH573w60bnNn4r+4HH8LkFFHlgn4lU9tWlvRetg==@kvack.org
X-Gm-Message-State: AOJu0YyhcQTBnd6QLodW4Kefi/M3h0r0FEL+vqBqPmf7P94STe8Jo6Gw
	Mgrc2t65YE66mBnrpDir3Fbwl9LDKr0ru9gIHoldQcxGa4cf7x4egrcv1m5GMFx4Fw==
X-Gm-Gg: AfdE7cnPOxYsqWcfm6MTk9/a0YE/2RoYC0FaJfASTMvh4IJc1zzditiRNMFbQ0IMibp
	cgKd39M4MNuAhHLbkW52bQS/b2zfg+98p9TzeFoTvA8stFiE4AfH0M1e/df3UH6yUSNKQtuczNr
	jcNMGeBDWf1DaQR+f8oGWSeSi2gDzF92npTAC1u+xyNyeoM8aTXXoW+8PPlbbdYiN/5OArrv2jR
	h6W/WP0YjkWj6oTYNG0A6wX/w/hNJDShJZ6DAPSd9RvrCtjdLc6tjYZTmIXpQhIuo3QYWe29kaT
	lEpAmWPd8vltgfD0D6rQ5xZofS0TSGBcBxnHoSql9EFx6YIckAwJ/ICvvWi0CCjZBCyWXR8seGh
	GsYy/c7PC/NWQwmFLNgbzRKUyMgz/kEE8Ek41wlZRqeZLRMua421mz9OjNlRViGVlsJGjsDTVfT
	PtnEEebr4ZL7xBSvwrwRg/cF2mIVfVa/8Sw15kK2faEdSwtxI=
X-Received: by 2002:a17:903:2442:b0:2c7:a13a:7fe6 with SMTP id d9443c01a7336-2ccc9c48162mr6446945ad.10.1783511253251;
        Wed, 08 Jul 2026 04:47:33 -0700 (PDT)
Received: from google.com (10.129.124.34.bc.googleusercontent.com. [34.124.129.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-387d36676easm2656833a91.9.2026.07.08.04.47.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 04:47:32 -0700 (PDT)
Date: Wed, 8 Jul 2026 11:47:27 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>,
	Trond Myklebust <trondmy@kernel.org>, linux-nfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Anna Schumaker <anna@kernel.org>,
	Shivaji Kant <shivajikant@google.com>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] nfs: Optimize direct I/O to use folios for
 requests
Message-ID: <ak44z-X-SKKhkBkg@google.com>
References: <20260616134000.2733403-7-praan@google.com>
 <7ee3bcfdd6126c93cbb1c219bf601182b95c10d9.camel@kernel.org>
 <ajGGpDvzZdkGtSbN@google.com>
 <ajP8ZTTLYkICFTO_@infradead.org>
 <ajQ21kH1ZVajS2Y7@casper.infradead.org>
 <aj4iiD5C_yyLeb3U@infradead.org>
 <akevQfFVteCOD6LM@google.com>
 <akfAgy52s_Gch2KG@infradead.org>
 <akzsO_vmYX_7Umjd@google.com>
 <ak4A6IEmWNi27I2d@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak4A6IEmWNi27I2d@infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EC4AC40003
X-Stat-Signature: 6qajhxas5yotzphyfawwayeu99gk48on
X-HE-Tag: 1783511254-269271
X-HE-Meta: U2FsdGVkX19GqwLzIfl4aiNNhAqDCfkzM7ao+Y4qBZ5hUuASaVI20YNt60QrrwRuBWyznIkF0OG2HLX4OICcWg0e1H3OiEGjR0X4gmTGNfDTab/weUwdxtRf506rSDMdJqyaZ6aMTQYpfp7j9dhy1iubfYgxe7oFvDqm5Z76UhQ8B1iTpQpsxe2hSql2tyQI1ibeJauAnA7QIINhEcVJvZ/nMjaltRJPkYuORIkdqvo2JavknG0jRQCOTq2N6Jpj9j5webzoKlQ8LgwzS2xPM/4b/uCNlMQtTjJL8s5t50zX8J9mblSfAqoou77MvxuyXAV3l2DBr3JKXgCCt/NZJswmJ/OX2feM82FqQdwQuEeGqt5/mdsSEQF9SgTIGpv6y7wnCHwdZuC/h/+2Kzg8EQmLggnEgS6Fyt/uzx/LRdPY4uJ4SC2hFoHIF+WvURNFJzvqRn+E8BpfOo1oeVx72mo+hcYUJAbNSODEtxkL3tXue+5dI6UAaqUnEFtP6//XvDG1XSro4Y4gSS3xT6C7RWC68o3drBfhKYoH0+YvLNaNW2ZZEAtD1IP2Sk+UomcJVB8ULxONTZ85IwUYPloAQr39OIHEqxVlJrz367xCVylakrIGMNzKqf3MtLz2MFhcwIm/xXT5W/9yaJqSD6b5jTfYQK2dYWNfuowwoaxCdlOucHoxW+0P2Rxvb46VoYsdEN3JUIV8pEUOtsJHC2bU+s9PKytHgIWps5DE+3NnsndyJOh0/nAjf6MlxzjmdY9qhqzumf/pJvazNWn4Z+5FPMQVSr9AXHp4+DMh4Nd2aTFx88saRRc9QNiMUX6wa2Ao7rw/XbO7UpLj7D2TdsPNO3LkOdzYJzwQbpviiCqKsMFmPByATsfkov/jMnp7i0f1yKhIapTOnhzDz4WjrzthS/nEkUmuBB4l9STqeoOqJxnzujKlHgdFSCSvKc9f3noGChxJ3ClbGwawSqj8Y80
 xCjZE9US
 V39W0Uyzz5bC2CzrGyPWOESOd7yQMttEhcm4Y8Z/ZWuORaM01vWeroIsKy7p8wD3/1zjSgXHa9gCE/7HUcPlw1djZMJ89QvRhmvwk6j8LOdlCECByfAHttsFs7pBqgGzFoz66dBdu4sc+NCLCWjzgWMQDODcVfW03wGJPmy2LH4a6n2cg+RMp9LZ4k7C4eeEjTVjwQGHNqWIcQS5QaYf2xbaNRrvkX0Trbh8dykIRYPDV41zz63jJd6LdTMQx0zVaYpwt1a7x4OyVjJUCcEU27LulXr5JPnur2HIS7Xa6o6Nbbzr40EBWfI8DJ4qu5qiNg32uq4F1COXhNEYtV95qBSJIUw46/u+aVyz+1RGDqLMLhsA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 12:48:56AM -0700, Christoph Hellwig wrote:
> On Tue, Jul 07, 2026 at 12:08:27PM +0000, Pranjal Shrivastava wrote:
> > Ack. I see! Thanks!
> > 
> > Regarding the page_folio impasse, how do you suggest we proceed? Should
> > I expose and use get_contig_folio_len() from bvec? Or should I move the
> > NFS helper into the iov_iter lib? (or both).
> 
> Sounds like the best way forward for now.

Ack. I'll reuse get_contig_folio len and move the nfs extractor to
iov_iter for v3.

> 
> > Also, do you suggest sending the Folio move as a standalone patch if it
> > is blocking the rest of the series or do we prefer keeping these in a
> > single series?
> 
> Sorry if I'm thick, but I'm not sure what "folio" move means.  In doubt
> if you think you can get a series merged quicker without a later part
> I'd split it.

Apologies for being unclear. I meant I could post a standalone series
that moves NFS Direct I/O to folio, i.e. break out Patches 6 & 7 to
another series, if that makes sense?

Thanks,
Praan

