Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AE5DD116EA
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 20:00:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50AD76B0005; Sat, 29 Nov 2025 15:00:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E8D96B000C; Sat, 29 Nov 2025 15:00:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F8EE6B0010; Sat, 29 Nov 2025 15:00:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2AAB76B0005
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 15:00:45 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B2D04512A4
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 20:00:44 +0000 (UTC)
X-FDA: 84164712408.28.08C8002
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id F25881C001E
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 20:00:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QBh8QjBn;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764446443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ac4e41J1no2A/yAdSNT0nB2JpY8ZljHEPM/8bCvPIig=;
	b=qZoyOhuqTQVzT8FCaJxEcURpbyh9Bu/5rQhJpD27f67PB8voSJrkyOT/IZuC4POG81NEM6
	TkUbyYNw02hUOMCvGSrDMqNBbHfWW86mag2lQwobduhGcsP6pSIKtcNbJqhOy2Sa45j4zz
	xD3s0CsSRvLjVp56sR9YgiegVLV+Ckw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764446443; a=rsa-sha256;
	cv=none;
	b=NArWDP2B+zhjL1Y6hriheei7enlvni+f30JbTXA4Eub1UUgkmkVXcRLes64j5PwnIwgGg+
	ew5wwL0qq9Gh1gjxtAV9Rkq505b6z+nTOb3oYtDqTzfSutBhlrIcb7cq98nNofQC3gJ7Fr
	BeAAp/kY4A8H5yEtxvDr2YC0ThDiHSo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QBh8QjBn;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E397B600C3;
	Sat, 29 Nov 2025 20:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D178C4CEFB;
	Sat, 29 Nov 2025 20:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764446441;
	bh=IPHHTKItiB7WTnDJDqoos611O4zAvsigzBDkYQSCbV8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QBh8QjBnetjbwykZ0IYWtUs3fXqA3ZrRMXZo393ybqK2p8QA2u6zTj1+OwX/jCoz1
	 ruJ9UVbY+C5tepMqbMynOv6mlqVbj6lEYJI730Ok31ZzRp7j38YnFM3LYWrNWmv3d3
	 rVgOINYxbN+Fv+OBgRFbGFgEwBw9V+o5A+YljZ64=
Date: Sat, 29 Nov 2025 12:00:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, Linux
 Memory Management List <linux-mm@kvack.org>, "Mike Rapoport (Microsoft)"
 <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>
Subject: Re: [linux-next:master 12118/12398]
 kernel/liveupdate/luo_core.c:402 luo_ioctl() warn: unsigned 'nr' is never
 less than zero.
Message-Id: <20251129120040.fb60e8a35d54d66c0bdbdf33@linux-foundation.org>
In-Reply-To: <CA+CK2bCmp4gjpyND2=Chdz-EfRAF20unYzO2dwQb+ZTEihgk3w@mail.gmail.com>
References: <202511280300.6pvBmXUS-lkp@intel.com>
	<CA+CK2bCmp4gjpyND2=Chdz-EfRAF20unYzO2dwQb+ZTEihgk3w@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F25881C001E
X-Stat-Signature: uf5yaeqbhg4oc6rj6mxxzk5zwuh6z43e
X-Rspam-User: 
X-HE-Tag: 1764446442-560891
X-HE-Meta: U2FsdGVkX18/MOKVXi8P//L5TKS8SsB0RwvHKro+LbxSSJopDkmKLW0JPcs9R2yIuGen8G3i56HRGxuIR3WBlnKAj6sJAeKLP3GDmqnRQhenYdTfVoodeqSdTa3OgZFw+RA1L8CCbP1mH1uiH/C6b8Twx2fJdtHkWhVIoMBgB/quToaXWx9vxiHz7/6lBmeOvPTdED2zDTUimZ1KGkUOghJA3av/veuWNYlpjStKlZD5lMM0LN0qfhFnNwW1pk59ArHmQA/NiHpkuW5agKJO4HStsDpCyG9FfkXDPSM/0dje3BjnjssmBt/iPzd/zU3AJHvzyz/XhkRfZhkLIjTgmjTR3jQxqbbYrs57lJjVVjpQGi4BFy2JNkGEyHrDmnBoLiPfncGd2yVccPQfOPQCegVq7WKva9fOCIgnPG1IlCJ9Zkiaig00/eop6IYJ7xZEjXyZ2jz74omNlDm4KX1MTCJl1Icn37KpHA7nJ44mbQJkkbspfE+grQefAOBuM3Kf5s8M/A+nHO5eiOlOLwhqzEwRg8mmRwNG3FwntB9DpZ0/llEZFbNblwMZDRiskJZ+X+21mzcWxWxDtcANSLWGGSxOGtLOc6XrNe8oC6GwomKb4Bd0Jv4hILZq/4B4TmHKnM2FXeluRpZvAzQRM24g/T262jssqJ2VhIn/cc2VEiR57qkPUQE1w2t7ZK4eZmJSbXh5LBoatnAwdWbtjf5gEIHcSOZFeVBzCsT05OqHqObzIHOP/bKcqI5f9GLf/2wyqifO3Q2Xep7iAV7Eg6lb9ga2W3mlPBZbVn329zVaqHXjBDtkU9y6hkjHMKGj9fJCi0sZZ4NQb1OXGypJPNsA1KqTzS3e4Iu+D3t1udR7uyIyqrOyqtNP1gPh6hAfBO8yO5F3rxlOtr24c1oqoWqklbGiZhnz6MJCkYRFcHulUhyJLIc5clwpLaMRQSVh9Iz3saWj5BqNb4RKOoXhiwv
 zrZEE2QL
 GMM7Xhn5ILK6mXVbjcpUiUxYqg2CP8S/1OeRiQOSWPv+YW0P5FlqXZ42VUS9nvjq7v7T4b8zew3NGbc398oancwxfNREDBKEHYXzMuUpUSC1dHpXYifJu08aSZDsROIdIRdzKQpXv9N+I6Y+kabsjAclreaefbN5K+VRNBzLxFGMrtxI3UyXKfRSVJdIWtMcK46AcxVJUNy8zaOrCWOEZGxcerwhLFNJLDjh72IU+3D77MEMMD0q8MzMx/XIYrYsLmg5ThruaHsGIO2j83GcWE8uNQBHU5qxHKEHaCyjf6/IthsK1Io4BqBmZHcWZOGYuBJ5uYuEbjepgAzo/TD1u8F4ZUpf+drL5sGG2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 29 Nov 2025 14:51:28 -0500 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:

> > smatch warnings:
> > kernel/liveupdate/luo_core.c:402 luo_ioctl() warn: unsigned 'nr' is never less than zero.
> >
> > vim +/nr +402 kernel/liveupdate/luo_core.c
> >
> >    392
> >    393  static long luo_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
> >    394  {
> >    395          const struct luo_ioctl_op *op;
> >    396          struct luo_ucmd ucmd = {};
> >    397          union ucmd_buffer buf;
> >    398          unsigned int nr;
> >    399          int err;
> >    400
> >    401          nr = _IOC_NR(cmd);
> >  > 402          if (nr < LIVEUPDATE_CMD_BASE ||
> >    403              (nr - LIVEUPDATE_CMD_BASE) >= ARRAY_SIZE(luo_ioctl_ops)) {
> 
> This is a false positive. The logic is designed to work generically
> for any base, similar to how it is handled in session ioctl and
> iommufd ictl. The warning only triggers because LIVEUPDATE_CMD_BASE
> happens to be 0 in this specific case.

This is a difficult situation.

In some cases smatch has found a bug, in other cases it's just being
irritating.

I think there is value in smatch occasionally finding bugs, and to
support that we should try to rearrange false positives so that smatch
doesn't report on those.

Perhaps there's some way we can do that here, without uglifying things?

