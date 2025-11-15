Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BB21CEB2C7
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 09:42:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 734EA8E000C; Sat, 15 Nov 2025 04:42:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70D158E0005; Sat, 15 Nov 2025 04:42:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6499A8E000C; Sat, 15 Nov 2025 04:42:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 516FA8E0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 04:42:11 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E41CB1406B2
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 09:42:10 +0000 (UTC)
X-FDA: 84112350420.26.D2108C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 352E8A0004
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 09:42:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JVE7FFfc;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763199729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hI9GPURT1FrsbraIOg+c5sfJwIq07JD/MQ/pZOvc0Io=;
	b=5ksj/Eo2Vempftnhf0wQBV4j1wFJ+lkX4sQ01nIb3cx74ykCZzWyAdcnJmkjtSJjXV+2/s
	dJHh087fWZO8lVEGX52udacBfarIGrHpUV2sGvGFQQJVgcsQmEUdRhLnSJR0fwBCFXWLVC
	T4+xL7tt9Py2AmGRn317KmQz0L6B/6Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763199729; a=rsa-sha256;
	cv=none;
	b=F+i0BZMUMcN/Oj/0+PnA3HbWdOKMCeJ6NPYs9QpHg1tfzBEyGERTa2B0pnkoaWjwzrRJ4D
	mal1g+HH7YRQP5OJlPUbl6qEPjLlxz/au1vP0yW8m2Pk4daxeP8RjfKbvFtKpY+KetBaRZ
	iaD6inSKV2a6sI5lSu/z90DIdeS9Ntg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JVE7FFfc;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0724D43880;
	Sat, 15 Nov 2025 09:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D638C113D0;
	Sat, 15 Nov 2025 09:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763199727;
	bh=5TLcwJDDFiBtj7lJVJ9lPhvDhUna9We8VbF9X0zLOfI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JVE7FFfcnStH8/zqhoWCvqwopCxelotqfG4sYk/BiaxyZy1UEJbCr94sYXbNJHav4
	 Y3x4oN5eUZmh/GhUDL2b28zkgS2SIu05fnQ6STStSprGS+E1o2ohQ4DaRgT9bZ1eg2
	 oV2Fh+N/VH2TdbPJcobloEaC3F6G4cMn1Feev7xyebN+UmwsMLWWj/Up8lenQsdTFn
	 twFkMiK5B9gfWBoXnKKn8hQcW0k4WwcoqJZV14JAxtpvPKCQKm9iMdmwObnqo5HSV0
	 991oTRVul8vfpew05xw2F3A5UQbwRWcUrl4F4alp0931iG8fkbF5OnAuro2wJNSzIB
	 Q9J0OECjcwi+g==
Date: Sat, 15 Nov 2025 11:42:01 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, graf@amazon.com, pratyush@kernel.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] liveupdate: kho: Enable KHO by default
Message-ID: <aRhK6dBs6ZwEz9Md@kernel.org>
References: <20251110180715.602807-1-pasha.tatashin@soleen.com>
 <aRbag7qR9OVNAQXN@kernel.org>
 <CA+CK2bD+ZseJ_6GUMV7d=8xpUcWW6jzJBdJRy7kQmez_2sMYUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bD+ZseJ_6GUMV7d=8xpUcWW6jzJBdJRy7kQmez_2sMYUQ@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 352E8A0004
X-Stat-Signature: t3c188mcwccbo9fjt4yd7mzxprzb87zn
X-HE-Tag: 1763199728-225069
X-HE-Meta: U2FsdGVkX1+H5nJ25NjfUaf/QZb/mLSkIiGSuPGnvUknbXn62EAyA9Z8gxR3VSiXrmRjMGh8hriiM/qe0+eOljTZg0HlRlFEU4Wa92ibH3s/W0nVUBe7sWtALfiLm1kKo1XkTtpuRDeSL4V+upMmM7ckq34Y025Ry8mTfUvZy5SO1/sUhMGvwWatq/26/hIiL7FvrRDeQWYoWhGNLXvzUqUUJbiFLU7UwVVKQ8K4AUMWh5nsYcAm63SXQ24GpLfMRcA2djlOZJMhsYWv4YrFds1biAAA4pS+swA1Pr5+gKwEmmIQmB0qDtHFdiAMXNu7Fj8pKAOX3iomkaFlVrRt0VfgYpJk19eVYnyl5/pLJ0OoERNhDuXvLUamO/ouqQZA802sqaurb9DiJW41Stxbo/AWCw6kgiLPVPws5b7NdNnbxguR1U/t7kK9sMWbqzbcwoEmVuzt7KyobKfzxFUtodXgtFLPDYyCl0F7B+OMBgp6zM4imBWYa5aDabsFzsA3ST7nasf4N1+KIfJvN2/EMPnEyK9Ah5qh2CpF05eUvmCA2adxCZ4uuLgQwXd1B5xN0kknBt0jxYr44RafKoOKnni5W3uJIQbMxyAvZ0CbBwSOGUr+4Aatukrj0lktFLcDCXfpw2gbFt6uHQbv54itfo+WUdgTogoezdezK1KGVrmuXLNfNxphzI/qX5JHwzpQOIIGGawFBywtUNsHh3XH2z4HfoCky9cO4T+2FelpxKGjXwpkocgmqsJlxCVwxN0tx3sgJ4y5ucRmXiX1zmfPvEIhOKPkhyGMOyzU39YbLJmwx7zRPvfaQHQDU0alZHT/6YB07SdjVWKUZ4me9dHSYNLAb6jG8wzqUx+z3g+/J9CZvHwnF5O4qFG9GJm9xhAd+BJumweU78ZwEfC69IQkK6NzdxswKglOog8tpkO7EE3eE/+gK+GI6ZeJPl9JAPvz+2jNvAfo/HY6/gFpBpe
 Kmej7FFV
 Kqk+lRJ6LzwvOihVqhK+CA7J8o9mrerY1un3fgXNb8OfBP+b13E+FC6q1KoNeBFxd/k4yObK5X+13eJqbPwQPioi0iH8H/OggEliZTeW7kxz45JMTyTrUp3RLp1R+euuulGOyPUgRuC5nomnNdF1CRP5tN4mY5Rp4PKWcSR6Jw2GrUYe1P8RWViUHfRUdEGjjsuklBjr00kLrynFjwHRNqgMmeWT9pLgp1ESIda+O6AtvY2jmuTlxfSPeyw1DXNfUc2w9BXJmxKxXZSseIJjAJs1x+z9yNVoV/w4foqEBwokdDiw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 09:13:01AM -0500, Pasha Tatashin wrote:
> On Fri, Nov 14, 2025 at 2:30 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Mon, Nov 10, 2025 at 01:07:15PM -0500, Pasha Tatashin wrote:
> > > Upcoming LUO requires KHO for its operations, the requirement to place
> > > both KHO=on and liveupdate=on becomes redundant. Set KHO to be enabled
> > > by default.
> >
> > I though more about this and it seems too much of a change. kho=1 enables
> > scratch areas and that significantly changes how free pages are distributed
> > in the free lists.
> >
> > Let's go with a Kconfig option we discussed of-list:
> > (this is on top of the current mmotm/mm-nonmm-unstable)
> 
> I will include this into the KHO simplification series

Please add Alex's Reviewed-by as well.

-- 
Sincerely yours,
Mike.

