Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7BB6C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 17:07:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98D9B6B018D; Tue, 18 Aug 2026 13:07:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93E016B03CC; Tue, 18 Aug 2026 13:07:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82E326B04B9; Tue, 18 Aug 2026 13:07:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 49AD26B018D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:07:45 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BF691C02A2
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:07:44 +0000 (UTC)
X-FDA: 85115022048.09.E576CD8
Received: from mail-pj2-f8.google.com (mail-pj2-f8.google.com [74.125.227.136])
	by imf13.hostedemail.com (Postfix) with ESMTP id D0D2220010
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:07:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ojb55U7m;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of foxieflakey@gmail.com designates 74.125.227.136 as permitted sender) smtp.mailfrom=foxieflakey@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787072862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dP/aZf31v1msDK69AtGE7mSlWZPC9m3u1xHJq1TQO/8=;
	b=T/iyGVTQs1NKuLdDUfie/3qa7bUzar4xY3EfJKySdORIR1XmkWr02HezRsG9GmBRH3/SlZ
	rlL6kKPyshWZfTSQnmZhZBksHofRvboM9BPiiKRl4xk7dqo+MLw4NvwIhI0Ppji9wSQbgn
	2lnuKhr6hNzjtPqh1jURiyhg7wkpWVs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ojb55U7m;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of foxieflakey@gmail.com designates 74.125.227.136 as permitted sender) smtp.mailfrom=foxieflakey@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787072862;
	b=zNe7TU0v9iEjQvNE1oJjKHOX/pTkGi84MwUYbYT0rGVQr76JgVvur+M8EOqLimgUO6W06n
	N1ulZbvkJmewKmMtfsuTsNrOzHgtTcm7WaSBEXKcDNZO4noWrlYmVQqD5Ezm5IAGaKWfHM
	WVe9THfsjlfEvT1mOqm6AdEnw7HMC1A=
Received: by mail-pj2-f8.google.com with SMTP id 98e67ed59e1d1-392a608284dso78815a91.1
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787072862; x=1787677662; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:date:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dP/aZf31v1msDK69AtGE7mSlWZPC9m3u1xHJq1TQO/8=;
        b=Ojb55U7mnDx18BmiaDCfgIHW5ySsEPwU3bcV6Q/clEqCXp6Co0IUXUkligmudMJZed
         PBVYPnT0TPjVZoe5e1vrgZhT/WxL/G7LdbvFKO2kNQhMzz0DlGMH4SEmb8dcVpN0tqV6
         8UOpym4Qqu8rh+CTi+Jk9KgpCWgXf7hNHgnYFo9ljjM+UGwFNQiur4bgn+ggd2DUta0u
         lRQR6eypz0vzbK4HXnMjLID6MvUKowPuHPf7+GKwk89DlsAoLv6Wzb4sa6xkvfZlo6z7
         LlmoDQ8fAb4o23obHjIHW76L/IHDcmDyVQus9lQS11cGlgCrWMIZyxvRMUc9Itd0GsLX
         GBZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787072862; x=1787677662;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dP/aZf31v1msDK69AtGE7mSlWZPC9m3u1xHJq1TQO/8=;
        b=kaHy2msp8EM0958MYNOewI1Mq/PVC6KXeBdas9ugkUqf98XTPMAuVmg6yiGNUwfHA5
         2a/O+mEypgPpHtAWeZSkA92eHhS7QAVvYx7NvxD6A3dZjureTpDitjb4VOoW3MAOVvyw
         Mv2HpwgIyeQ5zTTaYukYelX8hJDyeQSURm0JioThmfu2aPJqp+GChHE1UliH+xWiRiDF
         ZQbU9zjTFHIGIL56yR2w3Yp2yskzuBczxjosu5/ZEJv0ku7BwOkMRtccX7N/VbLvHaVi
         j03mNiW28DU9MgUpBvhI7D0rB8QWE4VVpm8Za0nogEMAEy7rIoKNUEHUZNWL1uGZ9MiH
         8T+A==
X-Forwarded-Encrypted: i=1; AHgh+Rr03EptVhIgvGeKOnwNIP4g26s45jQQHw0jmmrOeReDoFFaGntqkQO06onLNxWCqvlooTpmkxxnIg==@kvack.org
X-Gm-Message-State: AOJu0YxkxRTrKDd0kApiJ410dqTgQO315M3Sv3HUfS7Hh/GnfbSU2Ctf
	DWS/HO72HtfbcuCTmtEA8jDQO6UmLxtRqmryDOkFMms72l2an3e9G6Ei
X-Gm-Gg: AR+sD11MJQkfH0DAkDrSMACF9mcqoAXuB5RZ6U1YMZbsMqHkQQ9X9+xVCdHajqoYWfo
	hoPl8rURD3A+hmLUDlcPoojbIWQ5nrTj9Qqy3+QFrE4Yj/SA4r+GF2yI9ZPJdM+ggOnpMgZYp65
	AlSs1M/4PiK8mov2Ju5O20zuq+IfgYKaG2pC3gVjMTki4hLYyMB6XdufMxTST4hexPiNsD+RzqH
	PVD0pplFKPARFrfwzhNpd85togYatDHIiGre3ql1wzerN99BGdHjQjvKzXSK5t+2PAHLt1ybvbk
	ZEASnrLDFYThYgKQa/NxxKsz7MkoqnhqPU1hZchw7059sRkS+hYJ+07dbIgmwx57fslMPVTmzgp
	/+aQuNzB4CZf5Lq/Swe8Ub9PLpfb7sx4Jz7Nqyz3XzDBkP0YASI3UUOPMPB8RjWUAsFbvksomZd
	F9o5Nli1nGtYd/e19NuXO0n+55EhcuKR+RLejA/WarzfCpBMWjcPcEEXsR
X-Received: by 2002:a05:6a20:a109:b0:3c3:954d:278d with SMTP id adf61e73a8af0-3ccda4754c9mr12341390637.9.1787072861409;
        Tue, 18 Aug 2026 10:07:41 -0700 (PDT)
Received: from 192.168.1.6 ([140.213.202.182])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32678dd26a0sm22800953eec.2.2026.08.18.10.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 10:07:40 -0700 (PDT)
From: Foxie Flakey <foxieflakey@gmail.com>
X-Google-Original-From: Foxie Flakey <foxie@gmail.com>
Date: Wed, 19 Aug 2026 00:07:37 +0700 (WIB)
To: Mike Rapoport <rppt@kernel.org>
cc: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, 
    peterx@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: reset err to be 0 when move_pages_ptes
 succeeded
In-Reply-To: <aoGi3g9AlcG9EiyG@kernel.org>
Message-ID: <b38cf4ac-77b1-fd03-75c1-ec9df28b579b@gmail.com>
References: <9c936a9f-ed27-e510-872f-5b3b8c680975@gmail.com> <aoF_qmSHiEgujaH5@kernel.org> <69522f38-7e5d-ebdf-d42e-11d822bce662@gmail.com> <aoGi3g9AlcG9EiyG@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: D0D2220010
X-Stat-Signature: r9z7ie898nzzf3wteysyzoaabxhisoqn
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787072862-723683
X-HE-Meta: U2FsdGVkX1++OXQ0AEwXHVk8zhjxZuXJNa1gG5u64+sVX+UxIEbL6XkRkHp24bUMTWLQfK4TBzTwEBP/KcaS19O9OMSBoBT8KdFf1yOuX2aq5qe8B3xup1KZ1cLsYumhg+bo+G0WhO1R++ocfC5etyZTcpqce6R5Lp7PTyc06KGw8R5rrVv38gr+DMkjOJKHZ4eXytbNNruyqRvrZA9C90AquJqi1nOZONpQGfHl696fkTeWzvajcX2uKhJxFyzJk8BEoSv8BVm1cbYKady/z6oxNse2vJTh00wPLfMeliKHnJrVcGAURVO9HVm2gfEMwXlobhIty/j+eTHRqO8jke3mLXrkbNNepVCE99x+0Gxooj7VLsw32jC6eV1FkOxIjkt++4QBzprLM0U+dlRdDI6yDyK7lQVSHvNxBF9iJD/c/CjpyBSxPiAO3/jGlxeAuUQSnqcvbNR449g6a+41lDKEEH+Vt9qj4oD81FjcHVGrSCw6OGMZe7coq5SADDUY+FLnXG49LTgdh6YeaxFi1q7fLFAlMhWKht1nvL3qZLV4ccLxJO7wZbn/bDmB2m1I6WN5Lk8vVqbFmXOAyBNQyBhyEHoGR/PUvJKDUYzn4lg2yLYGH7e8UNmfBzsKYCCGesnwq9AmeqenjDxjkTDYDUDHAd0ELXeqllnimHIY4piVEk5z/vh/+NOXiVFvXniwFxrO2EVHKCj830XzMVBgn1bFP3ofbgOV1JCY+xBql0YskX1ZSiQwQsxrznwscAfHnohaSTpueqqSbe4X/d92YUyc4spKR9VWKcfijTmx8Rnfbib5N7RcNXoof7c7S4t+aFmvqTFTTawbylO7T8KWqEQuQCDxO9kEs+PssluzjosavzvzZhwJMNBRt5CExQfUaEOEVRe7ZnIjHh9JVx0x2nHI9xxPM8VXSwKMXcpA+med/VdDMp+x176Z1LpdnLAtu1KmHk/EPmqryVK0oVq
 blU6h7Ka
 GTr6PN2eHoHgkP7qvyPXjyjl5KE81ybn8zVds0fpv1b2MomOVIpzs0KL5mlQ3slA+dmlt6flxGG4mBk0l5RC/es5zP6usBZonnEX1zxNaxQ4FwVb77BZcEFD7lv4bV1cHCva7YNLiBuZngQpmxIBfpjlWEeWj5/HURjurSirwm6sgZLFIoTxNsSkHudtgEKaEc4wcY68tzP+78Kvn0MPMiLxfTh4wPpd0S8livL9s05HlLKUokLbVAccAO2PCGH3iRHcxp+3ni14iyeADTrxSD88HsvPRNRzyyjnkRIFJYpD/B50UQL1yeLmHzL8PdMBpL6Lh5E6eynGdRA1UufTR+NsCo87ayRNG4RMepdmRkDNFa965U4DTHEH34goLqH/G6VITDj1jkDYTGL3uxifEO8KXGbMEzptLB1wpcMdHNBqyntvTyaI+7K/LI/MFg37L9F/oIfUuogu4+yTzxyGliJeqdWOom899QVl126kk4IDYu0A25qdcVN/s+GHbpsKeasnvntwrYmmikXSu5ezUw0xdzDtQ1a/u2lkiasjLs4KDkGZm4e2xyZAlxeV2do4l7Xqz3qgMTGErFahNVMKJhy+tOgbyf7rnBOgKnEkLTlUCaLJgHa+N9b2H8lSXnQ/JWMp960C4KJqNcrOshoooPaKZPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 16 Aug 2026, Mike Rapoport wrote:

> On Sun, Aug 16, 2026 at 04:41:07PM +0700, Foxie Flakey wrote:
> > On Sun, 16 Aug 2026, Mike Rapoport wrote:
> >
> > > (adding Suren)
> > >
> > > On Sat, Aug 15, 2026 at 05:42:12PM +0700, Foxie Flakey wrote:
> > > >
> > > > Fixes: 50944692052b ("userfaultfd: opportunistic TLB-flush batching for present pages in MOVE")
> > > > Signed-off-by: Foxie Flakey <foxieflakey@gmail.com>
> > >
> > > Is Foxie Flakey your real name?
> > > Signed-off-by should be using a known identity (sorry, no anonymous contributions.)
> >
> > Thanks for response. Sorry, no. A question, by "known identity" there is it
> > means my real/legal name? because I have read a document about Signed-off-by
> > and because on internet I'm known as Foxie Flakey in multiple places, I
> > thought its fine.
>
> It does not have to be the legal name, but we do prefer real/preferred
> names over nicknames:
>
> CNCF's clarification on DCO explains it well:
> https://github.com/cncf/foundation/blob/659fd32c86dc/dco-guidelines.md

Sorry to ask again. As I haven't received answer (I think I accidentally
sent to wrong email?), Should I use Foxie Flakey? Following guideline
wording from DCO you have linked, Foxie Flakey is the name I convey to
people to identiy me on internet. Once again I'm sorry if I sounded too
impatient.

