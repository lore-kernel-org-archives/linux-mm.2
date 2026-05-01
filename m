Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4F89CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 13:13:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A05F86B0005; Fri,  1 May 2026 09:13:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B6C56B008A; Fri,  1 May 2026 09:13:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F3DD6B008C; Fri,  1 May 2026 09:13:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 82F936B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 09:13:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 11F898C37C
	for <linux-mm@kvack.org>; Fri,  1 May 2026 13:12:14 +0000 (UTC)
X-FDA: 84718889430.25.FEA5C48
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1C5A81C000D
	for <linux-mm@kvack.org>; Fri,  1 May 2026 13:12:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XHOZWyfp;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777641132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+llHKaWUBr9+74VqmItuG7ITbvjjlCSCFNpqVjn25Ko=;
	b=0P74/vtN2LIDF5JvMxheJTYqB2xmenMBPHpGBJQiAlt9Sw+zIe4QKUv7VkUrIrCChnx33H
	ktXXC1iwXHA32w3nd/RgCYdoAgYs84DL2w9ZllCghMm3NgLp1uLdqM4416U4V5Zyi3R7bU
	Yv0ZuSuOz9GyXXhD+vGiht9TcFLICyc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XHOZWyfp;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777641132; a=rsa-sha256;
	cv=none;
	b=eSQww0kJwW65cENY/976wofJdmc2gQ3dPTZSXh4/ce5voGPoQFeFtw9M9drsB4RrR+MlRE
	gKUOHrsRnc0GG7pucpjJEhzrQbPhdVolVNpP5rKh1yNtIYZNd6d4ghhLyb+BnlQaKIq5HM
	Q4CUGIcCK12qrvtyFIASWoWiZsZfraI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 893A660142;
	Fri,  1 May 2026 13:12:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D574FC4AF09;
	Fri,  1 May 2026 13:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777641131;
	bh=rPY6kpU0k2x/r+Y5vurIQbKrBbLh1ktKKLy++xxDRJI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XHOZWyfp/mCR6Px6qXMz9bAhRrRNKNfaUrZLr92WGzjhU5+ZD1HguQ9Y3zf/HM2CF
	 ING0+AfXfn4kDPc5x2uBTNvI7zCbPfMuKpXbYAAi8OEzsl2QVVIMv+isnIlWUg+HW/
	 xM6JTb0dcYH2RKUDP49boYGZDv7s2GZFK8LGyFIzn02ETafhtg6uI2N6+M3EIf/xI2
	 BE6Jzgy/GAbwfChY5kjJoV3STuzVSX0a4+cK7PkhgRPIYcC217OaSRl87qAJLW2e9b
	 Eo3cgSsQdRWPfvn75RbdCGpts/o6G00Qy1sSFFfhfMVqEEjyvnl4CMhoQ4Darvr1Sb
	 tELR0d3vPlwEA==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id DAB1EF4007E;
	Fri,  1 May 2026 09:12:09 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 01 May 2026 09:12:09 -0400
X-ME-Sender: <xms:qab0aZZ4lmLNO5LE8pviXf6YBxnkbKewj-zXCrnavZJbivsPPh6_BA>
    <xme:qab0aZbhJsDTscqH55SYr_OEFAwzsgNjg7sBPCrdUYW-66rhcJAAMeTZbxEEhGJKj
    Hmt6Egs2mZe8Q_M1jOAVb0eQiM7QKHFLTfa8h7WPEyyvnetTmzZgl8H>
X-ME-Received: <xmr:qab0aVrkX4Bbo0Q6l--ODLheZLKc2hOtjBXU1_HfQMhjypegpMpmi1QJbluuUQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeltddvlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggujgesthdtredttd
    dtvdenucfhrhhomhepmfhirhihlhcuufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgv
    lhdrohhrgheqnecuggftrfgrthhtvghrnhepgeetuedtjefhkeeuiefgudduvdfgvdeiue
    eigeehheehudetuedtkeelhfeihedunecuffhomhgrihhnpehsrghshhhikhhordguvghv
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepgeeipdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    eprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehpvghtvghrgiesrhgvughh
    rghtrdgtohhmpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpth
    htoheplhhjsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhurhgvnhgssehgohho
    ghhlvgdrtghomhdprhgtphhtthhopehvsggrsghkrgeskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthho
    peiiihihsehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:qab0aellQYNT_R3fN52NGkYyZEn9mCcboTG8efe4UUa4xZvIjmghYQ>
    <xmx:qab0aXXW-mbF5hvwEoNxPCMKoYDCFHu3nt6c2smZz8Vk1gQK780nrQ>
    <xmx:qab0aVT8bhREa829ct_FBCqcDdAvlwJ95mcAgBiFkHkE-FJLxXvqbQ>
    <xmx:qab0aUn6vSQB25ybLkc5R3M2QJMF_5HgjWaudrlMGx7p-UFnWnJSjw>
    <xmx:qab0aQJhjaQAJXOfWCBO_ZYZ2jbBsI4emal1EOnO7LoIoTINtPTJhE9Z>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 1 May 2026 09:12:09 -0400 (EDT)
Date: Fri, 1 May 2026 14:12:08 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, 
	david@kernel.org
Cc: ljs@kernel.org, surenb@google.com, vbabka@kernel.org, 
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com, 
	sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kvm@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 12/14] userfaultfd: add UFFDIO_SET_MODE for runtime
 sync/async toggle
Message-ID: <afSmJ4LLuLJWdI4A@thinkstation>
References: <20260427114607.4068647-1-kas@kernel.org>
 <20260427114607.4068647-13-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427114607.4068647-13-kas@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 1C5A81C000D
X-Rspamd-Server: rspam06
X-Stat-Signature: 6c4cg5xzkwc1fk6e9rg6xsrbd45wnnxu
X-HE-Tag: 1777641131-421530
X-HE-Meta: U2FsdGVkX1/9hQBMJOKCQD5Z8Bl3+vAGBTyInDoerua5I642sfN5dokxnAXN10vgZNuA0A+JYW9RHc3tugJ/+p9ROBSiWFKrzTqsH21RZzDnxlt2uIvCS+z8F2K/ULnbTdngxZA3/FnR5gxyIQXhEFSZJzU85LoaDd6yZNfC4yyqkuLCLezF1E1OL2rbXyYcZLaU9uYSPPXD3uZk/9elNov7qwaRELO9QMFrbBkyoXoP99yV6O2TXfh3xKS8RO8PWoIISlUn/U8oEs6Hh6wKhY3XMeBvHKF2wUUrfmi5JdiRq/eovM1rXMz0/ME08tRnT0Qub4r4SNcTP9i7EJKNqsMzjGfZaVGl3d/OpRXRf97Dp81IeMkzHiXTJtFML1Q59scOpKDBYEYb2SlQv/7UoPqdMDsqSolwiSl9XMv0SS+DOduSN5rd8ZCtkF2jX5HOPiBa4yv460l2atVLDXDAbpcjzWApXxzhT8ngsoM8aLe0jxzMmCDzVLEEPCKYt0AddoU5+Z/7U5IxySpb2H7MP1sdVhKg5GjjJn8Xvd1o9DNipv+0xnFD5qfab4XWSsBbz7r1W0773WqiuaGxfuwgpeVSu8eSR5ua9MdOOgjQi3taK3IgomNeSr5XEGb5UhmX1w/lDfN7WoodlWWXhVSmVqJORapnMptJ0NXwa74YhpSlslkcAt8KOzujtnnWj40vWNsPRsf9EN+kAJQze1eT8nWwwRIeOVVH3nBQ/m/ihSlbAdi1bdg7esB7x9xVfTs3MppSFqQdtONfuRk8m5M1OAM4ZRf1P45OU5iUW6A8nVSO4CyhPoEyiGU0IZ7l5XTB1rHGL/w7K+oWKKSHhLWUGraY+gnU8PZDu0YtMb7naapMAsObi98CCQvGpzjbmUUnhr/fhMIYL08vpebhEvd4qZLaFVDQa01IvPb1JR43EOljINqvhMcLGPeiuOgzHWvnwcT4ePLHzRQ+pGFBgzX
 yuBN8TEI
 4qBUEjqZjRbjcCT+fjz+KEDtVMx9fD6zCSIrQuG3oqwhqMZEBdRkNX5Kq7U+uIezNjIgXv4xpbOTKEbDasmUcpNq2dsPSoe+R/oG/PTgYhnObtLAnwsW98ph0wxYzxV1HCUStAdgojBNp409RAyhCd70EyslMWcHn54huxSWtwVrUfeq2Xj6MaudOUWSiG0dZPM+moBDVFRlKxvIE8VhnXihY7XbkAfb3VZCeP78StmIK8nUbSvPzPveDU4I4ArMisYwyC33Xs/dce5/YxDTb8HaBTdFn/9eAhuL+L5KKOrVyy9qqMf+ulW9/9E9S5Ptbrex2Zhz3BlwsKeVUSPOE1s3/aun0Tjwg1XG4vVCwOqxT5mkCpeIVpF3pqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sashiko.dev -- https://sashiko.dev/#/patchset/20260427114607.4068647-1-kas@kernel.org -- wrote:
> Since ctx->mm can be an external mm_struct, is it possible for the target
> process to have encountered an OOM-reap or a failed dup_mmap() and be
> marked MMF_UNSTABLE?
> If so, should there be a call to check_stable_address_space(mm) after
> acquiring the mmap lock to avoid iterating over a maple tree that might
> contain XA_ZERO_ENTRY markers?

This is the same pattern as userfaultfd_register() and
userfaultfd_unregister(), which acquire mmap_write_lock(mm) after a
successful mmget_not_zero() and walk the VMA tree without
check_stable_address_space().

The OOM reaper takes mmap_read_lock, so it is excluded once we hold the
write lock; failed dup_mmap() unwinds its partial tree before returning.

> The commit message notes that fdinfo reads ctx->features with READ_ONCE to
> avoid seeing a mid-RMW intermediate value. Are there other lockless readers
> of ctx->features that also need this annotation?
[ ... ]
> Could executing UFFDIO_SET_MODE concurrently with these paths cause a data
> race on ctx->features?

Confirmed. userfaultfd_is_initialized() is reached from
userfaultfd_poll(), userfaultfd_read_iter(), and userfaultfd_ioctl()
with no mm lock held, so SET_MODE's mmap_write_lock + vma_start_write()
drain does not exclude them. The INITIALIZED bit is never modified by
SET_MODE so the value is functionally stable, but READ_ONCE pairing is
still the right thing for KCSAN.

Will fold into 12/14 a small helper plus conversions:

        static unsigned int userfaultfd_features(struct userfaultfd_ctx *ctx)
        {
                return READ_ONCE(ctx->features);
        }

with userfaultfd_is_initialized(), userfaultfd_wp_async_ctx(),
userfaultfd_rwp_async_ctx(), userfaultfd_wp_unpopulated(), and the
fdinfo printer reading through the helper. Hot-path reads inside
handle_userfault() and friends stay plain -- they run under the
per-VMA lock or mmap_read_lock that SET_MODE drains before the RMW.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

