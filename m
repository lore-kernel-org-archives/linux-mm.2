Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6242C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 14:57:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 988056B0107; Tue, 30 Jun 2026 10:57:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95FD36B0108; Tue, 30 Jun 2026 10:57:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89E166B0109; Tue, 30 Jun 2026 10:57:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 623FE6B0107
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:57:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DC2668DCC1
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:57:34 +0000 (UTC)
X-FDA: 84936882828.04.E7E7849
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5685480008
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:57:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mKqN86No;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782831453;
	b=VJgE+4NDEaVyBShRiXY4NZjYprk50Hv3YZ7ljRCurXKljsS/tDTB5dX6dqiFPZzLuTXEir
	/PvD6pLpYP9mb9bPvLwTU03Y6vxlX5oVoL1idyNS50x9sAfBTCgr23THvGhLTDqNcOr3Ny
	9XM+dDSOQsmM1QfPVywyrYl3CS2xYng=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782831453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rt/iGbOFCZMV9bCDf5rxqRe3XsLLEE61YR1XtIhNQok=;
	b=2PZBMMb3MSsKAemE9NHyuC5V1uXSe7qPayz449ywBQZhPxmvNANdp7tmlU9Yp7G32paLDu
	SH04RqpV9ZIDifc+iq8ab4zyYFayqcNLLm3PjWNObRgbvRQim3WVnpcU/zLHaW05N2bGbB
	sZM8xzsYPMGPajKp8f5J5YYIBJqzCKE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mKqN86No;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DAE8A60018;
	Tue, 30 Jun 2026 14:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35631F000E9;
	Tue, 30 Jun 2026 14:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782831452;
	bh=Rt/iGbOFCZMV9bCDf5rxqRe3XsLLEE61YR1XtIhNQok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mKqN86NodSgPmPa0daU/LTKKagv0DcFCeGMhS6MgVwObdnzmatyb5UisR30Aa67Xk
	 UF8Yikd4V0jvra1ltipSVud//K1T/IbdgT0XbO+HgUp9mX4tyeXS3/nNd0FXWYurSb
	 GeFtNYI1dABj6rRvj/tn6uBv7VbcA+YNI+vCD04myI1Sg6Svkd0+P2ENuvY//ghV1i
	 0uW5zDuVnefztjVi8KSuS5DqaDXi1RgNx+np4UHs+Lcj4U/Rl1ywlHHxoKE+EnF5/d
	 HyQ1jyi3BzKD6JnuwYd9olgGQdLoHVj/hjNNwDE1tSYfGEocOE4Vgnc4fNc/dJMZAB
	 LHuQYbCiN4W6A==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 00/11] mm/damon: update, optimize, and clean up doc, tests, and code
Date: Tue, 30 Jun 2026 07:57:24 -0700
Message-ID: <20260630145724.93141-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630141726.92246-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4e1fo4m31kugkn646idgyhjy8ex4pww1
X-Rspam-User: 
X-Rspamd-Queue-Id: 5685480008
X-Rspamd-Server: rspam02
X-HE-Tag: 1782831453-624822
X-HE-Meta: U2FsdGVkX1+UkutgmqkTIfQjnDr9wtqy7MfEiGoN/oepKwUXhxzjF6KlVemrISsKLid/w2JAKgXg25wb6oaeKgvilw8yZ4/EDPMUmVsNySWV5hKhD6DRNo6UAfo2ZjbeHt33VJnwDlv8OKH/+VktQw2xE3hZSxyNjH/uKx93QzhlEe1MtDpNuV1UZ4KxVTQKauViGz53HukLRI8ALQEXFp2/GogS/ADoGgzFqVyZ42xMCLlIeVz87Q+cykUFcDcNZZC6JuSispqkNEzl4s5LDe0e67Np2pbsBTUdU8Vmijyjb9mnq6xncQCTot9GBFP7bt9VH58apzk579nCImRq0ueyEXR8a3DKITAKGnDppmN6ud3te/iH99mol6aidWDfP82m0KGXRBPCeQ/JDsffllP2XWnzhi/Xe3J1NJXpD8uQuhz/OVwJHm5JlbidPaMuL8y0tDXT9tx+PABfZRuc0aexcDEe4yeBzx3BbSJtadG5LGsWm9Z1nwdq3WNQmKFt324tPe27xf211vxIG0dPCAVBR9cDGySmRm0kSH7AhP4vVFThXDl4tHfSHX3HIBljOK5lbt2kHORhHbMqRwNLuyqkoyToTLQwWHR8dSUarGVwwJQ0GDoa9zQ62LhtzCry/JTM4WXsKdxuLOM6RtGYjWeB61fU2bYi1+CVX1ErkUFAj3tLD2WJNOerkvMwaCDGSiLSPM4O3GLaUMDKllNvncyaoK+2zzLzqYnSqYfP49vA6IjyEefV1K5EC7aOIY5OhlyGbWogKDS6ZyBISWpuxselCQYH3WyP7Z/UE40jlpSyMF9n+yGovAFUPulCBbc+vAAxYi+LeCVRIZlCO4K6q+uT7yScgKT57ZoKwjcAm7pNyRcVDj5fff+YLZA9Ji2lkgNYAPNLlgg7AHHoxsDnjTQ3bCInbcX8Bd8onrCL5HmsVRXzMMXbU0u12B984xhQLNosb1zW76HLgtNI9Hq
 hbNcjCdR
 ny7Efq/kU1FvctfmnYVqQ5rmO5s75Aj/hnx6RbdK3zHI0DRnTEeICaQK35s7XJXnnJDNZKKzg+OxQmv6F1YxZNtNek1LHBkBUtxkGYXQOm1go62MgSXgTTzj4dRFS8yZdCi9Nw+17BUn8cgLm4FML+jptXga+fyS6KC+UQ5AlxCbFRzFhDrO7uR+bmZCX/W8ytVlbEmDoo3carLFGMhsudBhTHyyHuXnd1nndn4zoZHuuGkc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Jun 2026 07:17:14 -0700 SJ Park <sj@kernel.org> wrote:

> Patches 1 and 2 update the design and ABI documents for recently added
> DAMON features.  Patches 3-7 add or update more unit and self tests for
> DAMON to cover recently changed or added functions and sysfs files.
> Patch 8 optimizes damon_commit_target_regions() to skip unnecessary
> adjacent ranges setup.  Patches 9-11 clean and fix up recently added
> DAMON sysfs interface code for readability.

Sashiko found a few things that could be good future works, but none of those
is a blocker of this series, in my opinion.  Please read the full thread [1] in
lore.kernel.org if you want more details of Sashiko findings and my replies.

[1] https://lore.kernel.org/20260630141726.92246-1-sj@kernel.org


THanks,
SJ

[...]

