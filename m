Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92E14CD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 16:05:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B09A96B01AA; Fri,  8 May 2026 12:05:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE12D6B01AB; Fri,  8 May 2026 12:05:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1D426B01AE; Fri,  8 May 2026 12:05:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 913DF6B01AA
	for <linux-mm@kvack.org>; Fri,  8 May 2026 12:05:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 298371A0206
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:05:56 +0000 (UTC)
X-FDA: 84744728712.19.35D0C7F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7D32180011
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:05:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="m3/pKqOi";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778256354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N6wtEE3PduSsyFFmtTroeuF5GQfkGRx/69RZSt8G8FU=;
	b=V+4obSMPLLyGCZERDplTPYSoc0lYIc5yK31UOu4ZQMBZwH0XxbGJ/Qm+O8BRwL7y1GnVmC
	HbRN3jUxVpUp+e7NxEE+Wl54OYDdrssXxIP/Bqj7le+M7LpiABnREZuNznXUGYA5rnoeEN
	RBOQF7+tgElViVAyH4ZbORxsSSkbovU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778256354; a=rsa-sha256;
	cv=none;
	b=bDhOkc/yIM/R4uxd7Tq8HvwhUwSAreLso/ZNrUSFsYUvVzF5NwBBKmFdtdlCeqtTcnhZgN
	omqNESESaRxz7rbjtL+4l1VoE4eXPk1xU3ap9gpEnMITCiSqeZYIX5hDWeupjzN7enExtt
	68hrEp0uvP77WXpop+9uHccXFbqOrio=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="m3/pKqOi";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E21D960181;
	Fri,  8 May 2026 16:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC14C2BCB0;
	Fri,  8 May 2026 16:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778256353;
	bh=N6wtEE3PduSsyFFmtTroeuF5GQfkGRx/69RZSt8G8FU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m3/pKqOillhmU0om7DrpVyPKG/dmMI24o58/3HQ/JTFQMn9+LrT98y4BtDLo++vh2
	 ghgQXni+HXAPmitwFMLTFVaiBVcH0uTuL6ePmoo3FCh3QhOQeUmfOJeWODnlvz/twm
	 uDrfKf8VsUN93OjHCaxdeeWToshO7be1oCC+OThQCP1elhjn+18/uAmc+QOQzzGNRS
	 9g4o4SsozH1OggXqDb6nuckfaYib/1TJf8vgF2okDqT6GzrO/VuOs782Emfo2sf2AC
	 spGAfVI7JUBhQmWe6J0rVBKnHRZV3ZAepikc8s1qiTTwblJi+5w7uIvvhyln65x+x1
	 hIN+YaU7zPvQw==
Date: Fri, 8 May 2026 17:05:45 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, roman.gushchin@linux.dev, 
	inwardvessel@gmail.com, shakeel.butt@linux.dev, ast@kernel.org, daniel@iogearbox.net, 
	surenb@google.com, tz2294@columbia.edu, baohua@kernel.org, lance.yang@linux.dev, 
	dev.jain@arm.com, laoar.shao@gmail.com, gutierrez.asier@huawei-partners.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH v2 0/4] mm: introduce mthp_ext via cgroup-bpf to make
 mTHP more transparent
Message-ID: <af4IEwbAAIYUH0z9@lucifer>
References: <20260508150055.680136-1-vernon2gm@gmail.com>
 <af376QFXC36uf7kp@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af376QFXC36uf7kp@lucifer>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7D32180011
X-Stat-Signature: mowtqqdo18jc3fopte5axcfz4573zc8r
X-Rspam-User: 
X-HE-Tag: 1778256354-495778
X-HE-Meta: U2FsdGVkX1+v/AWX7u0fa4l5fkLvfrWvKHefADZpjBRo97gun482aVQqnDg7+POhaOtxjt2nken8c8hJ3K/SqTgF6PZVRCKRC3bu4O2UC9Tgy3VBW+DQsuB3QhyIa18M+1BBL8ViNIQLCTD+gsSQipOONugGmKEPe4UYq31yXSn6MgdOm3+pm2yr+rhFGyVX25t0CSFnK1ePc+3Bt1JuqPD87aRncrq8SqU1BwKRMZ0FfLf4+jpyedt8qJbQrfVpElCsjdlhLbk0MRstHyND27OzDnaYs3oWbtmTCRgZydf9qiB6nLNimV6a3VXyqM0FvidYOzdUsVKZ5ExIpJDAUNy0xVkLmxqSLRWjV3Thww3a/K5MDwHP+/GHeGzacVDyDzzuGMa3pTPK/5HrzQ/jMc4xXyyeLmoMGDNlVn7AZ77m4NvLgZ2DAKjB2IZfNMpqe6o/aaX4MNn890u6BGE3hNxyi3Y8Yx5TQWTGeh4+kDnPI6AoUR2bVierFPJCFkZFbFJmUKaqoP0x8tQswYJ4iI4aVkS5DA5J1YJ+XDPoBsIt9BclHkpw2vbVrSpanu4HqVAtB8MS5LkaqydGrjkfZNlrQ11zAFKXB6V++/KOphu8011IJwnRVjxsmcyDZCNYUwHmDNUIrdj5N7MdrEzU88FT33OaKChhXt2JWhDJdvkedKrwYUZJ5r+0Byy2MnVEe/PNjSlHpceKdwt164kj+PUs3ixpdcmfDsOuFdxo1Ci8g+Ld/zBrNUPSg1IxKBmP2871M4u+ncmyuTz/FIZyfgsbzQCURPB7wu7ELXtm22yMKD6fqZa3zDj+iEhiBKnXOvv5HX33klfiuxubIvH59NJJ52TpnYcb+NccQ6VfllgWX78MptbPKFhlkOE14MHfHUzdpEfRy2+fQJGsGaKyuJi/fX+JrwbDaU2C7mZNO41l5dwl2o8CoTDbwDcf0c/g3kVc0Zu0BmdfHbVV+M7
 zOp/ZGxl
 g5NQPNizsCxXnzZlySyJAz8B6lTzsovH7lzf3RRLOJyUvwLe3bKYtUo22d7F4tyOxU+ua/BC3gkHxbnruZ/tMl4oUlTCGgGlgpBJngB3KvdpFro5cl853/X3r+a8mPOQUeHBPzyIB3FOwPZheWdAIJm6gN0jK2mavu8oONQiJclPdTVtZPH1aqiYb/tdK56Hr78fwADojQW3wDVwNF/rMDHAMn4il7iXryRBonnnkP3218t7318w8zLWNgaz60t09TSAoH0RE9meIR8L3glx3ZR2BEohAYmIWuA8dN87Ugz0N42DyRbTSPJD41kOxQDmTr1Uxg9f2KFhfmCoxr2PUiqax3nhGpV487iGgx9zLxWnwrCGj0zb6NjolZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 04:15:04PM +0100, Lorenzo Stoakes wrote:
> Thanks for the series, but overall it's got to be no to this until THP and mTHP
> are in more stable shape.
>
> And this is an RFC, you're trying to make really fundamental changes here, it's
> almost... rude to do that out of the blue non-RFC'd (unless you're a maintainer
> perhaps).
>
> Right now the THP code base is a total mess and mTHP support is not even
> properly merged yet (khugepaged support outstanding).
>
> BPF interfaces are permanent, we've tried the 'experimental' thing before, it
> doesn't work and we'll not be able to yank it later.
>
> I've said it before, but we really truly need to get THP into better shape
> before we can tolerate large new changes, let alone an user-exported interface.
>
> So can we defer this until we're in better shape, and then send that as an RFC
> first please?

Yeah on second thoughts, NACK and don't send this series again please.

I was already annoyed you'd send something this invasive and massive without an
RFC, but you've also ignored the feedback we gave to the last THP BPF series
while ostensibly claiming to have taken it into account.

And then... I mean seriously... _shamelessly_ trying to take control away from
THP maintainers and reviewers who work bloody hard for this community by parking
code that changes mTHP behaviour in an entirely distinct and unrelated
MAINTAINERS section...!

There's a biweekly THP cabal meeting which you didn't raise this in, you didn't
bring this up at any conference, you didn't send an RFC.

You've sent it too before we even have mTHP khugepaged support merged... or have
really stabilised on how mTHP is supposed to work overall.

And also I have made it really abundantly clear that I want to see the technical
debt _paid down_ before we add anything else major.

And as if that wasn't enough, AI review is finding endless problems with this
series on top of all that.

This is NOT how to engage with upstream. Again, please don't send any more
revisions of this.

And next time _engage with the community_ before proposing something this big. A
[DISCUSSION] email, or an RFC, or in a meeting or at a conference, or even
off-list or on-list mail, something.

Lorenzo

