Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3882C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 06:19:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80EEA6B0088; Thu,  9 Jul 2026 02:19:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C03A6B008A; Thu,  9 Jul 2026 02:19:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D7056B008C; Thu,  9 Jul 2026 02:19:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 483956B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:19:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CCE301403E0
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:19:21 +0000 (UTC)
X-FDA: 84968236122.19.BD1D487
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf01.hostedemail.com (Postfix) with ESMTP id 05F7240004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:19:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="OK/1L5Mr";
	spf=pass (imf01.hostedemail.com: domain of praan@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783577960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sVwokARvELpibyxJ1Yufay2/9dNo2BXnunlPaasxpXQ=;
	b=Xn33uz1hqEIb0uX6D4fnTRtGS4cZJoNb7izUdm87w2XE2quZZGzCeif9WAouyqPWDVqIK9
	MUiRybf5Y9yRJ0A4pUgRvGSOwj2lC7XR0e5aMW9um0zVTCvxn2gSQu7AhzCk5txhQM5w/5
	ctxN4tmZ3wUxvV1zwBw5w2YjeQvAzhQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783577960;
	b=ZRkQaPhA/qqk1oalEqCa6Fqb7SgP6EsWnRT5hMvWLpemdxvVt80sgf5ORx7lS+qjd6dzGB
	ijsE4PkUl7NsF39FQN2vD+FFWgmwH6eOvEH0HeW92KkRhyCNakxIetSl0NSa02hKcpJoHP
	Sbh/iWuK/YrYLu+UTZrl4RCdQwddG8I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="OK/1L5Mr";
	spf=pass (imf01.hostedemail.com: domain of praan@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cb59f6ba26so70825ad.0
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 23:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783577959; x=1784182759; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sVwokARvELpibyxJ1Yufay2/9dNo2BXnunlPaasxpXQ=;
        b=OK/1L5MrZ9Pov8GLaZxb/v6acQDuuo/bx7dR0+Fsepo6835Qnjrx7+DcyeM6bXQQZ8
         q6nQjaDAeXgFmx4SlhmM+hf49qHcQfM6KakPDQC2xElWusqJrZnqZvSoBluz/BIgWUfE
         srdCoxRvJk/ISc57/cuVsbEtPfF+Evsn/RUSt1GD/57zyk9yTQ9HGfEMaNO6bZTj2mPN
         mm/ScsSkyZuEVkzsW9s82/o0OL7M4i3KtuiC0JriLlY+e2TIBgt0oxOU96uW2eemcwMd
         ORjLzur6QNyWcahTUTw9YMRBQVXO2O6Eyrsbea1zXvNR7/Og59GF/SnMUKQutAe8eUDe
         6vDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783577959; x=1784182759;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sVwokARvELpibyxJ1Yufay2/9dNo2BXnunlPaasxpXQ=;
        b=fJj9xdDo9DQd0M54Ki1R6hGkXt9wCNvWGX9ikluBbUHqLoGfF5KJ6EE5uKuIhzIVBM
         uLw7fRGS3oiK33dGyo+GDJes8TstgTk+y8fUg0QjDWCn1vJjNFnIx72k7KpJtTAMm3W1
         ifibB2DLervTfhMkPHIJKfInpFuejCqGxPjpMgS1HZ46/rj9F3Bt+Q1U1kMIXLvidbbw
         eX88FvTpKO4xTnxngZBXDwr3A1sA3hXOQiOTB3MorttgfY6xL/usBdzqEEehFnJSurjD
         IjX3LjibNxApwE6+GZUim2KjlfJR3u8lQ9PqG/nNgvSIOgZ36cfp58s0+45fjU85LxUg
         Q7XA==
X-Forwarded-Encrypted: i=1; AHgh+RqoZ5njWuWORR1FDKWgyQrY0C0I5QKp6wSvP6TWYroqZqhY/6i4d7+jQrtxKK/1eiHWlMVTBpKqqA==@kvack.org
X-Gm-Message-State: AOJu0YznUkrd3dCw6Oqzog9WGtGF8tTz2RH8BX+oM3xOgF56bn+vBulZ
	60TUMSrS0N7uIkoglLjowtdkaJ7sU5D+KUDuQG8Uw7LLb6BjKY3b0MzpzgTngRSx/Q==
X-Gm-Gg: AfdE7clfrEmRBGQE9nRNeiLTsfbOtyzN7ZCMLb/7z3ocevZd6YJ0tJ8mo5xq3UJ6CtU
	SiTVCl5WBlycE094c2TkFi2oX9ZEcCbgTuYigVhNpgR3P6jgzmXYpXXXBUtNqmNE4mGwAgxKHoi
	E4G5sZwns4ccQbtiOuzGWtOB0kxdpMVm7MGkQZQjvRetfTH2eu+8tMpUHU10U4dZH5wobYpYiDa
	zWnOzgygdCkMh9+dV/TJ21fufkMVDg42RY4qcTbPJw3G1JihuGqFMyYEY48ff4MVOzHUwMigC/Z
	sV7gCIxARr4EkTxVrYNlr18jRETSD9HAY58SZPE20CCaLiiiK+3XReKkGNLKVoNGVlapJ+hfSLu
	RhWx2RgzpuZz988TjMvMEBMuYPwKGIprWU2sjxfJwZ3NO5UqeFSIHt6G7srHRbqKQub9ROe05Hr
	B6JV6WpgGInoxZ8zbxRAY2cBthIWzT6btyCR649n+u5GFIWIk=
X-Received: by 2002:a17:903:3d10:b0:2ca:ed25:9c2f with SMTP id d9443c01a7336-2cd57365bfbmr1755705ad.16.1783577958430;
        Wed, 08 Jul 2026 23:19:18 -0700 (PDT)
Received: from google.com (10.129.124.34.bc.googleusercontent.com. [34.124.129.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38a5574ca88sm593811a91.7.2026.07.08.23.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 23:19:17 -0700 (PDT)
Date: Thu, 9 Jul 2026 06:19:12 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>,
	Trond Myklebust <trondmy@kernel.org>, linux-nfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Anna Schumaker <anna@kernel.org>,
	Shivaji Kant <shivajikant@google.com>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] nfs: Optimize direct I/O to use folios for
 requests
Message-ID: <ak89YF6BS-iYf_e_@google.com>
References: <7ee3bcfdd6126c93cbb1c219bf601182b95c10d9.camel@kernel.org>
 <ajGGpDvzZdkGtSbN@google.com>
 <ajP8ZTTLYkICFTO_@infradead.org>
 <ajQ21kH1ZVajS2Y7@casper.infradead.org>
 <aj4iiD5C_yyLeb3U@infradead.org>
 <akevQfFVteCOD6LM@google.com>
 <akfAgy52s_Gch2KG@infradead.org>
 <akzsO_vmYX_7Umjd@google.com>
 <ak4A6IEmWNi27I2d@infradead.org>
 <ak44z-X-SKKhkBkg@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak44z-X-SKKhkBkg@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 05F7240004
X-Stat-Signature: ejwjps7awi887d5upa487uid53e87q8c
X-HE-Tag: 1783577959-751455
X-HE-Meta: U2FsdGVkX1+FeeTc0vohze/9zdlXSus9Z8xdBG+VBUddhE4S/ZmVLe8jI4wrLVvFiDRNiN/4QM+BV8KMTwKnYS2u6KYnt13R1CfITn0+VhXVSuoOjRsHR8eWFkgPrbO0G64BeWLowyc36L91h3imaLy2bqIV39/CmWjhsVP1RKaXv1Tf5ibuJ983GAumgl44H5cpkK0v4neozEUyTToQy88BS7cOA1YEagCVQgB7T5lObpQYOJJ2WFY7PpGtp+Oxng+Hk8U4SOUFykYffFhTBx3ECfgLHQf3DJdwE2vS8F6aCFEWsUzyb8c1czUwLXZDdCSSSxRtrBVygojWd0BSpahn2eaovgwsLVJP6t2ERSmA9ZPGCyopo0aO13Ci56Uy2AhzeC0FuwxZE1f5DAudSK4Cy770nXB4CLi+duFoETjN47kVE5zs4NpVP0BVx8i3fmykFmhqR+86IG4EBQbPMO7km4SL/Q8IUwLLvROuuovO5Oot0PBlchmuaOpoL2g20yw64hRY50PrrRBkE/ga/QnZXg2LCvJWhYRPlBlVhQ2wM8vhsnEyoG/tT4zGyrHi0RGv5af4eYDdVZRHcOxAf0KHRlUwer2Os0H1/lNCiBHfvG4ClbCJUdRq5f0T4bxHTBuGTypIOQR14BVmKx2IypBr/uf33UV2ep5iI28ipenm7dLq5TFpAoIfI9oaebQ6BsCzXYe7GZ65s9RdCiNKIik14Stp7LZTARE9jQf3pAofIPhYy3Y2dAA/LKVdW1ZhUL0eP/WHr9FJYH7u2xQ+uL0culQJYECU/Z13qBj4XiZabaLUN118zU4bzEIj9rWOEht7JBX6HgxyTNfKL3H6XYxlbgoBnxKZJX4ZD9G6BnrnzDSJR9ePUP0Ymp2ytHGdLLqA5HyTcz5RCN2ZvXrOmkhMCwBNsmthMQegnm65oxxrTIKbpwHaSXn7zAwNu8/uHHLJ5ETcUz+pI02g5Vn
 VRvru6gi
 VAXnqN456KtuCXhSCoElYJB+XtOpvoxvWkBFZDPU9R54nLCOUqYCl/Xuftd0JU1zDAx8pIWP05lw64BmtT1OkvrDwA51SxxkENQyaQsK5qEc1GoJfvKjSIkiAfHrFZ4vs1YjNgqyt04/UhK3pe9AIXebm9sYyDwZTQJKbmkrXX7kvKMFvE6RTwzECT0jzeslSJKp1hEAllLiVm0+8TD7+5tcE/9FilTQ7ZH3BjPV01eMNPPDTHGBfShZCMPY22TCs+PC/Lf4fdKf/UL8Qq5Cj5pUHjBR8XAPsRs/yxPJbOqNYLrDnHkRFJM/mtxD9JnoojvH8HIy2fwr9fm/ItfvNXPRnJPSESoOXCNXxJ0phlkLoI2U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 11:47:27AM +0000, Pranjal Shrivastava wrote:
> On Wed, Jul 08, 2026 at 12:48:56AM -0700, Christoph Hellwig wrote:
> > On Tue, Jul 07, 2026 at 12:08:27PM +0000, Pranjal Shrivastava wrote:
> > > Ack. I see! Thanks!
> > > 
> > > Regarding the page_folio impasse, how do you suggest we proceed? Should
> > > I expose and use get_contig_folio_len() from bvec? Or should I move the
> > > NFS helper into the iov_iter lib? (or both).
> > 
> > Sounds like the best way forward for now.
> 
> Ack. I'll reuse get_contig_folio len and move the nfs extractor to
> iov_iter for v3.
> 

On a second thought, I guess I'd try taking a stab at writing
iov_iter_extract_folios and handle the vmalloc / slab cases for kvecs. 
I believe that would be the right way to go, unless I'm missing
something obvious? Can I take a stab at it in the next version?

Thanks,
Praan

