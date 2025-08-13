Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48C82CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 02:46:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7E298E01A1; Tue, 12 Aug 2025 22:46:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C559C8E019E; Tue, 12 Aug 2025 22:46:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B92F68E01A1; Tue, 12 Aug 2025 22:46:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A93658E019E
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 22:46:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4F18F1401FE
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:46:02 +0000 (UTC)
X-FDA: 83770194564.27.0F52F11
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id B959040004
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:46:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HfXzH+Oj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755053160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fGlFjBlKx9kPDFy9HaIH+mfDgXmnqL6e3C2KpiTJUMs=;
	b=2uwIiS1wm4iAxoOkagiEHJxVwY/CN8bVZjen7uCmRK2S0mHwL/UbEheBMuoafSlKApTsAC
	nXL2oUwMsfhQTn3ux4coB1jczB9puOvESigJ0YHIBRgErsPilDpwSe/RshL5mjlOcwBowX
	2X6jGMy0A6fzWL29agjeCBtQap9StvY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HfXzH+Oj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755053160; a=rsa-sha256;
	cv=none;
	b=mEJrgFWNCtLAZxEZLAyfceE5ugOYqwouj3My5Fp26+gF+fcir1ABonyFF4NeUj1HQjAWZ3
	EqVOPaWhvB12ncLDH0T8COcA/WmyUBFbreKDOEJ1Fkzal+oUL/OOo+5VyjQ8V+5Wt92KsZ
	p2595CFu1cQ0dhFkTa5xRg/k7aSUNQQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 40F5243D01;
	Wed, 13 Aug 2025 02:45:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12FCC4CEF0;
	Wed, 13 Aug 2025 02:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755053159;
	bh=p6dvtiP+ZDxCLTpTe4srs33mURr8kn+OBoMUmqddGrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HfXzH+OjXKR2lFjnlWkQIBEwb3Kzig2Ax64rdsR7Cav5CppOwUSvmYHf3qs6OC4Dr
	 778Tn26yLQbgj/pPVCxJHpUCI6hxvIcXMiQ9YeWPzQeZUaW6lPe9DfqhN3P7HzDYko
	 L86i+ee5RrJzNWiA6dwgk2c5tR8SNxWILk9OjLT29H82JksxjP5unhDKywOIgFaTQT
	 wsAave6mckLLIuarTFXCNhxMx3Z2gW0ud0YbuIbZNcUY7N5k4gU/uKjBwPt8ff4Vx9
	 4g5+tfne+9OnEMbMbKyi585ZbSJhhzcV/1tIOBbUm259SBJm+YrS6Wph7djuXQ3R/q
	 ybSJNJQ+jla7g==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] selftests/damon: fix selftests by installing drgn related script
Date: Tue, 12 Aug 2025 19:45:56 -0700
Message-Id: <20250813024556.52376-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CABFDxMF=-Fb56zSnGVvqXRrDXh-3vFzQmhuLNDYEzFv4z-bsuQ@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B959040004
X-Stat-Signature: 9hkux8gc6suixuspmwkuaeawdz8b6uas
X-Rspam-User: 
X-HE-Tag: 1755053160-560737
X-HE-Meta: U2FsdGVkX1/6QbPI1zepZdhqP+y01aubkquV/pX1g4TtNWTNVxkxCQUaMLBQN5BfmZMm8Le64q3JqVltFMbWxwCOaRhdMJoe71/Rz3brjKaGzjQLnFLBnn0eWqMYN2vzWmZAUDMbu/lt4qlntsE4+tMbWubU0zKpQG+Uh3s7sPZB7dALxS8EcUlvZE6+5/nSUj2tD/lF/xQlbeAWyHDivVJ6M7ZBv/BHKci0bAyfNOUO+1cIIPbD4C4FBs63tv5GdfJSJiF0ii79uwzlkT2YEhC7oce1x04s6H/j3Km1R8JyTvmqMzARn/HS64Nl0ZM3kZ6/r0Yvo2ycfPiHJ2VY1kEanoJYUnd1o9RdaDzPAwDUaxuvaSFefWjlyTIM0PwQnvYIY3eL6DFZrhoKE1cluHIKDXF4D07Dw9GGykORGitSorpwht/S3UKSv9L6UiXC86D6V6SNmQZ8oEeYfSHp5JddMfbLP5ShjCyuCwwFf1RkehbqBtB1mS6JCpBh0H3XoOgr9RlP3un/A0hBR13fgs5NpMVknbqNL6BNWj87c8tbsic/to/0Eo+Jri2nC/dlmQ3gUvCwGCfMka+Knp5fBpparm4sFfIHagvUUD5+t1olr34JbIP64wCalYj+gPNadoaqbE84zt5xmYMHVJJeEkOMT+zDK1hPncPxAxu4QBAEPBdpgAKC2PUArumQEKlS+Odz4h9LhwwzLttVJNONPYTqNkCwwjEFMEt79eW2OhG/k9rsw0x2Mp0ec72qqaZie9Q5/GOCG1RgSPnb1WeyXFWz3GpCgT8g816+AdbfmpzbjOR7a4HjtG0Absmi8Slm2yICPQcL/YScb4rMKkogO9WI+wWOiSeaHLdP3BQt85qdRR5OmLhprehaSkWcie0+JSF+kAKddJE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 Aug 2025 11:24:27 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Hi SeongJae
> 
> On Wed, Aug 13, 2025 at 2:59 AM SeongJae Park <sj@kernel.org> wrote:
> >
> > On Tue, 12 Aug 2025 23:00:46 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
[...]
> > > While setup kselftest executable environment and test this patch [1],
> > > I found similiar issue. Honestly, I don't know exact solution for this
> > > situation. So I just make a new patch. Sorry if it is wrong direction,
> > > then please let me know how to do next.
> > >
> > > [1] https://lore.kernel.org/damon/20250812-alex-fixes_manual-v1-1-c4e99b1f80e4@rivosinc.com/
> >
> > For patches that you are not really confident about and hence not insisting to
> > merge as-is, but wanna ask other's opinions first, you can ask questions via
> > plain text mails, or post patches with RFC tag on the subject.
> 
> My meaning of "don't know exact solution" was about conflict patch
> (Now I read again, I think other people might be confused.

Thank you for clarifying!

> That's you,
> sob) I will use the method mentioned above from now on.

In the case, another (and probably more common) approach would be sharing your
finding of remaining bugs with the original patch author.  Probably sharing
that as a reply-to-all to the patch would be good.  Then, the original author
could revise and post the next version of the patch in a more complete form.

[...]
> Thank you for this comment too, and for your always kindness.

The pleasure is mine :)


Thanks,
SJ

[...]

