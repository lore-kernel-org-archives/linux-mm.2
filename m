Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93F06CA601E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 11:57:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72B7F6B0092; Fri,  9 Oct 2026 07:57:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DBBE6B0093; Fri,  9 Oct 2026 07:57:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F14A6B0095; Fri,  9 Oct 2026 07:57:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CF0C6B0092
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:57:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BCADC1C345E
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:57:07 +0000 (UTC)
X-FDA: 85302936894.12.C76FD17
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2A78B40006
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:57:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QH3fiBTo;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791547026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=48jLovzU9sDOmARCH/bhpsr7OGGaWHZHCuYj5YOTiJM=;
	b=559eMmvoXv8UcLZagmL4ygIGLZRJ4RlB4D6TylvTvzLTZvjc9kq0ylLTEZVjqfppSJlJfq
	Jx/gyWutXg1raHh5RiSMK8CqaDDxdcv9qrbfmMB9u8eBRRJxRdW1JTF1nhpvQefUTCm888
	HAhhDYqEzKxUQ3BJx0WYgZMF+ttGwqg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791547026;
	b=E18WbffTvx6y7Uze92/m2AhzMtw8/xXPvUYEYWuT7UsCRSrmCa/YwnhsL7MrOKkZfPRApu
	6XmKR384yIYfIJO0C+lQusEo7wkF9qmjTChrLCgRIA6JUYOEOCQB+GdhpRbrNa2S2DtQMf
	NQ92FZ84eTNYzhFNo3fhlZndo5mhm8s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QH3fiBTo;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A6F7860534;
	Fri,  9 Oct 2026 11:57:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399A51F000FF;
	Fri,  9 Oct 2026 11:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791547025;
	bh=48jLovzU9sDOmARCH/bhpsr7OGGaWHZHCuYj5YOTiJM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QH3fiBToKGh2utYkFO6TLH5i8kObVvKBj6ZhRijieTlGZO3XsIs9Q1/n+IKqEZK4N
	 qKne7nLlSx+/5pAdPjCx7AREXyMAv8vTNFWaCzBWaLMzwfiKlXjAHUUjT6OsQAUkmn
	 v7VAdfGlLG0x0NsRrER1auFt31TZ2H9/YSJXFuXbyZMXTEnjD4spdwIMRDGSCVwCsS
	 jAnZziYtSxMGNME0FJRT1rRPgLdSGb/XnoKvQCW7xr0T7WD8UQ7Q+0GDXW9JjlZ+3R
	 p9ZQu7BJf0EtHwkhIIqzddqA+DSU15q0Oyftd6reKmDjj8vX3W5bEpMRkNdY1hGLH+
	 ooL/QkyMoUpbg==
Date: Fri, 9 Oct 2026 12:56:57 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: rppt@kernel.org, peterz@infradead.org, akpm@linux-foundation.org, 
	david@kernel.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	linux-mm@kvack.org, linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	regressions@lists.linux.dev, stable@vger.kernel.org, 4ncienth@gmail.com, 
	alexander.motin@truenas.com, caleb.stjohn@truenas.com, ameer.hamza@truenas.com
Subject: Re: [REGRESSION] secretmem: SIGBUS on memfd_secret() pages while
 perf record runs
Message-ID: <asjWUyFVbq4fhfLu@gremlin>
References: <20261002175651.811343-1-ameer.hamza@truenas.com>
 <2026-10-04-1-daily-reply-0001-secretmem-requeue@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026-10-04-1-daily-reply-0001-secretmem-requeue@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2A78B40006
X-Rspam-User: 
X-Stat-Signature: 585u1g1ai6iygqdurn8as7z38wuzi864
X-HE-Tag: 1791547026-135514
X-HE-Meta: U2FsdGVkX19EVoM1zC35KlcOsYhY+r0n7go2UrxGA3Jb/aIU/ao92VUVq0o5nWUGsK6YvsgjKv9b6Qn2PMKuSiuz77M0YceR4xtOa0tUxCYXhQ98JiDOV/ZGFHr76+JEyWbdVsNnJsObcrJrYnBvReB1kItpUJ6yUJbiFPaEL2mqqIhBnYMlMngjYDoJ2IG+zJwfyzR4qRjXvKVwLls6toEnPqJxUPgOM0SHGqCaHhU8djQW4KKq6qBVnNLU0VFyWpWdodQYECH9oDLzB/vqvab1aEb+NqcjRSvuud4AIvEwKYTANb0ZO+rj45QRMk0fUHtkoSa2NVMUAfwcXGclxJGHL8W2qzNaFdHnV0uMwMSWlZRIzYcPlCgCCOLNg3F5dmAe6/kP1XnstJNk25RGj+fa9ik4xauFwFdPcoZzrmIqzxVk+YxQdTSH9LxxhDVLQoyI2WFN8vLBUWo+qC4N+Jn9vKXHc9dm/JsK5ZXPdzOA621WxNVKI42kqMWQ/iAH0gUcJCiH0seXPSg8tpsgoArtQk4fH/C+Zp1MxPlUf//N+yWKu1GiDkER/bnubz21VV/iFYhCyusicz5sdD424aLcFiQNbWbCR87LjnFKy2JAIrZObxgG4ojqIyOd7wxYyTZ6OGQhH68iZhqtvsPBQOV9LoNMShD/x3SSasjTAfxdJOfHJWXYkcA/sW8r2z57BssYk+BIeO3o0k/ILLDwvieoxmqNJK3LZ5+b4PgMBo1O0EUyWlIJyAezxNU7wCGpYhnqdjN9l/mOf5RXTmpD3c3wRg+/9DPxzQsQb5IkC0eV5vZCkNbOwinKnmdc3lHXvsdA4mKU6t6khPFKpgRXv4VtC6+x2NdOWapU7bTctLay7+YZOh2krLF0Ty5Azq7HwajOZcgdal/gC9vZnLwpcZp/8AQvs2i9T85AE+BwE6Gj3aEPo7TI0ZX9YseHSgFghAPYIrG5TR8RT22mgcG
 O0JjlQH4
 a5ov3Etj6fB1Kf1Vu/4yjaiez6nPlhuytrHnXDVy1ZQ+hy60u5l2cW3P+JO+4C3X7UNHPf/7G1g841Ayi26bWVIkmNf6ppHZNROzX9Rj5qpFsQSoeC/v/BRMOlAHF6toSEjecTKjHASzd8vGoKKdcucfZzMnmERG5kWWQgkVEU69rbYRA05GEMI8SLVhgGqxgO4cBxFTXJ+9xTtDjUNu/AIRj7ABdYMc7SmpwNuNZCTFQoQybBz6wJGHlSmzQOF/C6+xBPrvNUoJWfHMAWIH0k3AwoZ3bmLvW3P3e0wtFr0GE7jPPsXHMpmePsmYORBtr1n/Jb2H+wIsr21aiwAa+aOoyKcl3IY//w4O1lQWNe4gL9449d5vwWFzZeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 04, 2026 at 12:29:39PM -0400, Sasha Levin wrote:
> > Since commit 97d34aa65c29 ("mm/secretmem: properly account locked
> > pages"), in v7.3-rc2 and the 6.18.52 and 7.2.5 backports, touching a
> > memfd_secret() page for the first time fails with SIGBUS while the
> > same user is running perf record, and read() into such a page fails
> > with EFAULT.
>
> Re-queued the secretmem accounting fix for 6.12, 6.6 and 6.1, per Lorenzo.
> The perf fix will be needed on these trees once it lands.

Thanks!

Perf fix sent at [0], LPC will be slowing everybody down though I expect!

--
Cheers, Lorenzo

[0]:https://lore.kernel.org/all/20261003-perf-locked-vm-fix-v1-1-d214dcaf0d76@kernel.org/

