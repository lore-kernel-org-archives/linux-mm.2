Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C191E9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 07:09:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9EA16B0088; Thu, 19 Feb 2026 02:09:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4C876B0089; Thu, 19 Feb 2026 02:09:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9783D6B008A; Thu, 19 Feb 2026 02:09:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 84D076B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 02:09:39 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 219BB8BA04
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:09:39 +0000 (UTC)
X-FDA: 84460330878.05.8A2837B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4F34F80007
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:09:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p3p5Imrp;
	spf=pass (imf30.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771484977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=MNZZ7xFU8qIbmRGeiByK7XOVVNgDUl8tD1byb+37r/Y=;
	b=yy6F2z7LR+iRNUXQHTx+T5Gh6uw6K3eFJg/ceAieRYlcU3WhdfZRtla8qKh0WM22ft+dIT
	Kls46CHS3L9azXHCab9mzBlXOfBU49zHH56FjS+Z2Nxam3qIzTlMbrHW0NlnQWIZY44/qQ
	4v+Tkd/04WGglYvsLD7XwG5TEMavZps=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771484977; a=rsa-sha256;
	cv=none;
	b=xuhPidudjuB3oOMtxTiOKnu0pz82WmNlt7nCPmPR6cd7M1bdox1yko3MrgLOVbbI4+/eES
	SbeoXM88S5V2+hLZ5/mjqh7jHcCwfRu4ByCpzjtR/zeUUNSXDXZYSamSzQuEdkABi6kaTi
	tHYBLxp+ubtOcgbhpNladvyW6R8uvfM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p3p5Imrp;
	spf=pass (imf30.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5503C4051E;
	Thu, 19 Feb 2026 07:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3184BC4CEF7;
	Thu, 19 Feb 2026 07:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771484976;
	bh=80HNN+Ktu36EddKK6+i7GfuUWmvXE8/CMclew4WJTT8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=p3p5Imrpbw9SgaIbKw17FXLhjanK1O+EEmBslnfZaWz5ff2bfOSq3X1WyhlL7sAA8
	 DUPzVHHJuGUMdlJKSg5oZdp25KRfg43F95bEOCz3Ep4bIowl6QNt6HbttXcTZdbmBX
	 G4/bxPOXy7r/3z8hl6SI9b2NmSyDHHCXZ3yKOTpCdyv5CuwARo9t+LDaXk9XHZIJgz
	 Pu9jd05HvqCwj5OLsh15h01tNX/0XITcGt6it6d5KR/uxt8k+pK+nNpkqKfu/Su1KH
	 wxc9ZIyfIx6OBZzE8WEw9IgP6AuZ3xFcmPe9Fz1iIEjOQmbh5UqatsapsjdoLBDxF4
	 Vygc4lFzwU4GA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 85261380CEE2;
	Thu, 19 Feb 2026 07:09:28 +0000 (UTC)
Subject: Re: [GIT PULL] additional non-MM updates for 7.0-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260218200029.835bc4072e58269d27599e62@linux-foundation.org>
References: <20260218200029.835bc4072e58269d27599e62@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260218200029.835bc4072e58269d27599e62@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2026-02-18-19-56
X-PR-Tracked-Commit-Id: 90627a1e08e602b8b7bea970d7d5007626be7527
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2b7a25df823dc7d8f56f8ce7c2d2dac391cea9c2
Message-Id: <177148496708.1707664.6851903123215314911.pr-tracker-bot@kernel.org>
Date: Thu, 19 Feb 2026 07:09:27 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspam-User: 
X-Stat-Signature: yy8cc8sboqqzryei5gcd7mz3xfngpfxd
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4F34F80007
X-HE-Tag: 1771484977-408377
X-HE-Meta: U2FsdGVkX1/i9g4qBnI+0QVY//f8goGqDiduBAKPiLxHc/aPljmBdlKTtnV+pVtTTN+Cg1jD5iK2IEYzoAC8+gcqB2yX49AdWhNEVfki/uSQOAyU6Mx9oZPecIbCS7w+P1YQBjhW8jCHXTREy+4SsidlNkX/6AWS2RTfQZqhG2waZ2P+b0z3R9xN1knpf/imcAR4lEKKSs/pRl60tfpp69YLajvVpF3ETEP0CnGo+3lq8dRvHSsRisv1fYiHCVJoJBXD2axq9Yt2BLGYiT3wz3vXtYlkSTIKWuLSXOscWZPnbcD1SpxnZEldK4KRBPyxIImdZP/5AugIah3MVvQ0JxQ96JlARB2S3J4TB7vE1/GEYkwffpVxkOVspF/FfyddGMqVe4a0I5sVGawA0YKXxD+0Fps7FIIbjYgAZ8cB7cAwKPktTI++G6QQMz2TbRLKFlru/dXkYtT/oDZGwud/aOyb5jHTVea67ECs+IJFUrviHGYtJcUPA3HCl1nOSmuZW6YGwjbIDf4WmXk+i4e+v0+nNvAwQcBaI1DsoB6g0EdvRLwqKw8zhRvZteKhW3t2lDsBibdPeskjGPKJqreu3cgwtQyG8RcfqM/QfidlhFC938u9aoQyV5OGU8PPcToTTtUm/JWoLG3DVw4qvMb6Vc7fauTGe/WmjdJvaJpEH5VcI7CsJvV6+K0Hg/OMVZd+IOxvXGETYryZFHZMkdbC6E5reTbxheMRVsP14nJOxJ/ktxnbTf+nrnoJMZFUDlqtwk5+YZsQ6PPQy64xFOqWpulvZErfTrgU31aFi9qfNo2tMowSwgoTbsk5PJlgMe2upCHxPd82Xtep145ot/EDUOzgfQZlt4xOC92iBhpCsjLz2kOgvwRyAFAYyoomJuQwdkYvEpqwRJVCv+tNmW+dl52B3V3PxMIPfMd2l5v3q8+LsWTBMSEI8F0aeDbmb12p11naB9ygQYPugjh5d+h
 3r6gpOw/
 528868LIHKUigv1YAFhlH0J27UWheSo0pVlURv5daMgluIwHvrGGsQh0WbqaZhjFSlI923UGxozXsLBbel0CaDs+VJgNAlyGwrZnY6OZBmHO6/scXvi+3vOLLd2IqKqj5keCDmIzKcnONDGuDrl6g5r85FlOc12JydKn4XPg+vCaT6onoA7eHqSNwhm88UFGrQ9TcTOFm8nkNVmZOssB6P/PB0/wBUceumQXtD8nMY/x0eaIxq1AOSPgnd0mf9GeOz8PDFAw/EU2HJZnqLPfjxHmZplTdirs4V+dkwvtM8MJXnI+V3Y2QFeXVKEYzLoNOHZ7CepyhYnCS12fkVAcsH6c3DrSEWucLHosZLF4X7n9cGiAXBsf8krr8JCBLMG5h9ibgQdPTSOSCbZ4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Wed, 18 Feb 2026 20:00:29 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2026-02-18-19-56

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2b7a25df823dc7d8f56f8ce7c2d2dac391cea9c2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

