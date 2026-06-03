Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95E50CD6E56
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 10:51:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 051026B009B; Wed,  3 Jun 2026 06:51:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0288B6B009D; Wed,  3 Jun 2026 06:51:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA7626B009E; Wed,  3 Jun 2026 06:51:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9FB76B009B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 06:51:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AE97A1C07EB
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:51:43 +0000 (UTC)
X-FDA: 84838285686.10.3AE1AE7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 269682000D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:51:42 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GF+TVx3G;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780483902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4irt7zX8prA5wvAeL79Ke1XWIsw0l/f1Lgz8zInKjmc=;
	b=M4EKDjE0vXcO/Nh/kUCCkqDoQEz2KCdbu2y+Vhd9/mpKXC94Yi/RPS4GcPZMsxnMLZ+N19
	ABwuSgEtZa61h8YsfJEH7sOj4WD3gusIJ2cxw2/dDDpICJ5xSyMX9RNJbX6qneL4joyjNE
	tUG7TPqqfoEjbjIx400WU3u5PRKXrIk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780483902;
	b=rCVDoK/sOQUaVdvFBC8SuUnspicoIjx5vPtFMU6Lhycy2scpfKLrdpOXUeyEhtcqIkl+cB
	SvP+anzhXImSGNkxSjdOFafixTt21w5NHBr038+t2AhnKsklgBHgXUTd+uB7hvO7hW0k6t
	esO0o0fNvl7WnOfiLF+xzLh+HZJZKcI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GF+TVx3G;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C2A540A67;
	Wed,  3 Jun 2026 10:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68671F00893;
	Wed,  3 Jun 2026 10:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780483901;
	bh=4irt7zX8prA5wvAeL79Ke1XWIsw0l/f1Lgz8zInKjmc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GF+TVx3G57KdADDZA61/dqiOtUrc2bL2alcbqR3o/frTCX+ahMZCBHyukTBh+n1uT
	 srwQfUMaia3i7df5TIZPOOrRgapj5ek9SjQVH/Cx7JwZRDno2GNrQhB8nFXfpKut42
	 9xMIbL2n9nAbPhuvwtqo8deyov5xoXARYkwEbZNAR7yenNMKYwZqTOmpXWD10Ge+5H
	 ZPJsv+p3Jz5feMqTWv/cfJdMunuvrQbRHezZDqhSpq7EH43klcUP+BvEf1jiHHUUsO
	 wkLdZcbULfv1ROfg3+hwR80gLzcOdeRvw9DTVl5Xb3WoO0e3Q79UDla/F5mhC1zaIp
	 cVIdiGFaEjjuw==
Date: Wed, 3 Jun 2026 13:51:33 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Nico Pache <npache@redhat.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	liam@infradead.org, mhocko@suse.com, vbabka@suse.cz,
	willy@infradead.org
Subject: Re: Process (was Re: [PATCH mm-hotfixes-unstable v18 00/14]
 khugepaged: add mTHP) collapse support
Message-ID: <aiAHNdrejP-iIOpm@kernel.org>
References: <ah2ndruO3RQGtePP@lucifer>
 <506fed6b-8954-40fa-8b5e-c8bd8c0d004b@kernel.org>
 <ah2uDhs3a0bFcRNG@lucifer>
 <ca37b7ce-76b0-4825-b238-b504dd499d3d@kernel.org>
 <b5b1a7bf-de6a-488a-a011-673c37bd24d1@kernel.org>
 <07334dc3-79ba-407e-96be-21ceb2eec00a@kernel.org>
 <ah8Tflgn50DTMvwl@kernel.org>
 <ah_ML-Wm3B92ZniC@lucifer>
 <ah_oJEODZJp12oDl@kernel.org>
 <0560f9a3-d8d2-4f9e-a7e8-9da3512ce9f0@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0560f9a3-d8d2-4f9e-a7e8-9da3512ce9f0@sirena.org.uk>
X-Rspamd-Queue-Id: 269682000D
X-Rspam-User: 
X-Stat-Signature: s13tke7n7s47qnyziyzw3yqw4pcd13j3
X-Rspamd-Server: rspam08
X-HE-Tag: 1780483902-180112
X-HE-Meta: U2FsdGVkX19R51W8KsTWd79HljhT8ZzZ5p23goFUKH4fPdI59U3EbtukEU1fAKXJYTSH2ZW4KyG0cx3k7b80wBvJrMiXoRrmvPzgLb6HGLfAAwi4hRfMhhk1S3+FFW5ZhA/ZbRGIO0BYuvZ11A5gs9CLr3i6qzzz6Hh45foqxybBF7cwahtsmqE5VE7AbQWoQKMzYV1PPgmuXjJbuBDRaAhbRlgx931u5BpcMpvrxAANxyf1LYBLZvAMirOhU80dJ2KXRN/dAMvDtp1RcytITqJ4bZy5Iuf2wIjiK0rEMhvjQ6KJHxYQa0zm43EpnQwAK2StW10bmt49AkwEEjyGQywJfeDhZrShHcTqcT085uGuICrwHXTw9nZBL7TfLEXUBSPvKUcmwvrcQIUqWwW1KJlNB/Lrs7piUhQedtjFFyYfJUifXFVttoX4Xdz+AUO0IVO+AdL2R5fwCAJKB6BpjWZFa/A9XX6mNy42cz7uihMvQDXmoHxjyedeXwVC42etOdi6kTsHuiw/e0pmP9jm01EKFPiOBHztHyWNCRx1QFlOMzsUxx37f+2+wGl0TKlZiosi9ROp5E2lAxmGW1RNJfoGPDjTdDjZoKcvwXAR2buF3DZVjmoUGJoA3+8lbcktivRdJ4TbVhiJULmEvVIaTvlJRka/mBaQ8d8xkcILBldQlghvUrGkxBr6wdYLN5YcJe1RK4mYB5GUkxnR1dKeBwbDzEwoXky0zIfrPTbCfd1Tn0vMm9gcHkcVE2VT4wuYebbAvZ5TueQprmouv4c5qMsWGVIkzBr1Xc4bTGslh4H3JcKp560fFTyvridDwtx+9YwXUyACVpSHG3tZ8/1kvmzV7ruDPplSkEi2ttTiDmcvLJoN1+m3hFjsPSKFM0OLvX3rxzRKsBHsiJpAWL8Ui9ZumNpWi3T7iaRFzVtRTLF/kp8449Fmy+Id+mcfj7Lz7S88A1n3u2h8B2MF4Ad
 Idq1q0rs
 5zYUevTxnI8YG9zmqc2SA5qX0mxLpXvvsdVehW29q3kga2mlHmHY1ZqnEt8G1cJ/hgJY6xF+ZJ4aLcrFxWUtgNFPexOVcD80KndW/YyOJKHZQq6vhPDj+dM4ZYTjl7f2MNok2Veao8mvVqXNVTER01zeHnMcVIvNvvJ2P2OnUAjqPtwV2s48sfUdBh4dBd0eEYJHfS1VqSjXiGiwHcgbh7JeZMDT2fUO0wmrnUn5oYIBtx3JKVSUk3Z0cIsN5nJZHwMbi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 10:57:11AM +0100, Mark Brown wrote:
> On Wed, Jun 03, 2026 at 11:39:00AM +0300, Mike Rapoport wrote:
> > On Wed, Jun 03, 2026 at 07:48:46AM +0100, Lorenzo Stoakes wrote:
> 
> > > - It makes it more difficult for us to yank things
> 
> > git rebase -i
> 
> Remembering to add signoffs if you're rebasing something someone else
> committed (probably the most frequent cause of missing signoffs in
> -next), --signoff helps there.

We learn as we go :)

-- 
Sincerely yours,
Mike.

