Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4068DC44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 13:48:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BAD46B0096; Wed, 22 Jul 2026 09:48:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 292606B0098; Wed, 22 Jul 2026 09:48:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D2156B009B; Wed, 22 Jul 2026 09:48:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E377E6B0096
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:48:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6BF881C014A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:48:18 +0000 (UTC)
X-FDA: 85016541876.24.3FC4D95
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id C55D1180004
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:48:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ihF369TR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784728096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hqr52O01QL+8rXNjOIialVzyWEy2PL3xs2YZI1bEPWM=;
	b=r87MxLJXrvQ0/qAfTR+Xdwn6l5c1Cyll7fDLH9X74MrhkpYrdgkDRvqjaS7Krtqy1OVDcr
	SHKYFq4+XJVzeKJwoZGzY0gWiR6mF+aS9GqlxQQe+H/sCXsN0B7dz9Q/QyKTzP2d0G3rTF
	dmVxpBBvgDHMOP7OUAVbHIlWIuUB/Cw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ihF369TR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784728096;
	b=8kHMpP4LfJZkHC1GUGnhtTLram2RGZ0L/1mFJsFaM0osG26uw7dhGXrqi/ab0vUUk/FS00
	FGgUw8BtebG11eV2V9MYJiEfzNMAfi/fzNJQSeyHwvALl/EJj+yuzEmKEz8sZZpAbG1WQM
	FcCzAHvS12qjCZFwXZfHZ7MgFzvnHSE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D2B19418CD;
	Wed, 22 Jul 2026 13:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728161F00A3A;
	Wed, 22 Jul 2026 13:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784728095;
	bh=hqr52O01QL+8rXNjOIialVzyWEy2PL3xs2YZI1bEPWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ihF369TR/bVoyo4aQ4voUjIhvMp+kJdM2NbFjPI1N2Y1M1Py8Z3uq/lL7/c3XjN44
	 q1bCRhwgo4SIm6wtaFjlgc51+qHs0UWfCggqAvGi9PZkLfaF7uod/UJR+tWB+o/TSf
	 1gjg9Nlmc7eYMx6bPli/E4tGYSECBXUcG+M0bhJL5omH/aEhvTLFOXzNaV1j2UM71i
	 so/EwXeZiMaYJbaECrfRSiJaFl0VRWAqjyZLhrcBhazpROxKZ5J8eG85o+xhKDYvay
	 VJELNGidvBpI4Bx926JGTDoE0WStjicUuyIGffziGn45uTUanJbppeSEXQBbWkYlcA
	 DpW1ItKv1m4qQ==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Hari Mishal <harimishal1@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests/damon/sysfs.py: clean up sh processes used for obsolete_target test
Date: Wed, 22 Jul 2026 06:48:12 -0700
Message-ID: <20260722134812.88133-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722033844.65932-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C55D1180004
X-Rspam-User: 
X-Stat-Signature: yky6hy691a6qgzd4ehsx3bjrse51455y
X-HE-Tag: 1784728096-315141
X-HE-Meta: U2FsdGVkX18Kr7YnO+nVq9dczyR0fcpjwTxOT+gezhUdtTpnt6lu9LLe8/PI2YMK2pqJF1C7BTBJM4FsLT57S2sUsEHw/VFOwa4fK9rbm8NbWBYccdAYdPYneVXS8DxWOKG8Q6mCLY8HZXfnHovC6hmhyXwR8thB+zH6rlLr4Ajo3lNHq0Hwe9vFdofOWF2zER+2Pinw8AawMHiytzrjvKhTH9w89L0VGO9eePJvzZh+QceSEAXxi/SRLYPk19aFqjVc9o3hhFnb6G+OSRDDNKRbSyEkNH044Xwd5mNz925neoExKqdzTCxR88PMq1EPb9gHrIO+4nHcv1Q/GqKCtZ0TnyHv37mqd+xN3vtFafBZZrVWmZbCRygdyqzzOUa9WSLAKq7h3Dqb92yWrZdhbGXjej+cXfHc1mZH1CtGKFpg06iABbjU8i2xjfHCl/Nhe/xG0zorks7kT2aO1zftzoL6l3OxJS0Wrl1HbMu2SyHZmvBvW8qvUkk43mGRUWydrLTnLZMGXF2IqehHmbVHi9kENN4dMPLUhPT8FScdQoTB490Fnw8ptklKQ3P5xUXyQeScNfjvSAhRwnNMrnulRsfb94LADh6xTa3c9HgdcQ3ogIQcEfB1p4spii4WggoFiDjC1DNu86PIqBeMmP3AKtYpn2x+iHVocgO+ryz/ChXI/F2f3jxJlf/WlvtrgR48lZ4tu4PkIb2hb4+O15ZtP163v2mOLuHDzeYquSLmtqG+aENSjyCTvGqCaWW858yngTdTyPPOlBkSH71Kau8GIqkWhRMiX/myHWJow+kfBfhYhXEPjXyUBCznerj5XRNRwRZe7k/S8mRwKMe17mciQjEt0vlM93mvNOfU9GvlZz+HTCOCyrhfnuRDB4H7PNKCv4RWmYwXwCnqVIExi+Auj2Qd2WQOhOIl7bPILcRw04gjUs7wvIDjkpMpW3cA0p9lLmaHcm41HJQXLq7j/or
 O4qTB3oI
 VyaAPapJ1caQ1/9nLjuLWQwb9Ptc1yI/i5Jfu74JIO2PD/1ZcVsthvDa3tQIup4lOGbJOG2mf8hU07oGQu9swpymbwqxnUQgYFKtxe2qEfQnB4rE1kLXUC5P4uxEq0h1IN8IzxLvOwxZcNlzou7P9pMtIfm5ve12jT2gUTkSFhfrKFEAPoZ6o6F07che4JRXNKuMaKHbiKdVT74xAuLslgpAE8DTyNhloR8z02X8vA45dpUym26YglN1/9kNjt6TRlmphEfno7w2Zdb0g0/Kzi3finQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Jul 2026 20:38:43 -0700 SJ Park <sj@kernel.org> wrote:
[...]
> This patch is applied to damon/next [2] tree.  If this patch is not added to
> mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew Morton)
> to pick this.  So, no action from your side is needed for now.  If it seems I
> also forgot doing that or you cannot wait for my action, please feel free to
> directly ask that to Andrew.


We (mm community) now want to focus on making mm.git more stabilized and
therefore ready for the next merge window, rather than adding more changes that
are not really urgent.  I agree and want to help [1] that.  For the reason,
unless Andre pick this first, I will request adding this to mm.git only after
next -rc1 release.  Let me know if you think this is really urgent.

[1] https://lore.kernel.org/20260722133829.87607-1-sj@kernel.org


Thanks,
SJ

