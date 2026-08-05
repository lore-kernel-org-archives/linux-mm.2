Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 847BEC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 09:46:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7013F6B008A; Wed,  5 Aug 2026 05:46:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A25E6B0092; Wed,  5 Aug 2026 05:46:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A0FE6B0093; Wed,  5 Aug 2026 05:46:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 34BCA6B008A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:46:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 142E1803DC
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:46:35 +0000 (UTC)
X-FDA: 85066735950.30.499FBB8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8140A20005
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:46:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hrLYDJix;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785923193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IDojFSGb+KHcW+730IUG4eAKVb7jAlmO0EAHhXPjNcY=;
	b=mrSfWBOz1HEXZIwPE2VsSsq461nxYX5VktzhG14o130QnLDHdx0mDMiq+HDOanIRDzhn9I
	kg0w2o/y+6svXnsynDVfzm9n9DlCZdR/LjnZncM+RHVPnpIX40aT0//L5SAu/vJrXL6Axe
	vvb1pnAo+5EgOli/QLkLXmGF+6+KAWI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785923193;
	b=VoQ2tRQQNYqPvPtd409Wly4BNINmaJY3nE//DzqLGrYrw26VezqCjQIdrqoPpR2uCDXy79
	l/4oONkq1lay26jKuSECC5A0rjjOhyXzzlilnNa4VEXnE534Fdjg9SofVSFPhM3HS+vZ58
	It0hjcB7wcsRKqwsYBKa2st8fo96y/g=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hrLYDJix;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F2DAA600AE;
	Wed,  5 Aug 2026 09:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB281F000E9;
	Wed,  5 Aug 2026 09:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785923192;
	bh=IDojFSGb+KHcW+730IUG4eAKVb7jAlmO0EAHhXPjNcY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hrLYDJixuxCD6onJkqUIxawsANiYi0gdwKm+tmAm/YmNkCZe6SH8g2egWRBglmjzO
	 AWE5Kx+xH4tothdCoOMC1OMtyUi6w6PMpxU/fSpx442FdmhdYBEVs7KZCAvr6cBzaM
	 bUqUPlCJq3MIebGLIQ2iotCUKkURPqMFafvguncNTW+pBi9VOtfaZYwAHyjK886+u9
	 o8Lbv1e8jw60uQSYqMUwMMSt5kk+F0BdWhfaISfVngaTbyajmmuWkj8jvQv+1gwNhp
	 f6fVBKuHM1vlqwKHfjgxZ2Yifvj8SzL/PAH3uxXG8BH2mOnLTCpkVNKofJg+HcHtBE
	 2CShtfOAHbLYw==
Date: Wed, 5 Aug 2026 12:46:25 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v2 1/2] mm/Kconfig: make FLATMEM depend on !NUMA
Message-ID: <anMGcWk2K5GGhhPf@kernel.org>
References: <20260804151145.3419768-1-ekffu200098@gmail.com>
 <20260804151145.3419768-2-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804151145.3419768-2-ekffu200098@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8140A20005
X-Stat-Signature: 38my181gjp5yz5oue4cucuefaghy66fo
X-HE-Tag: 1785923193-360267
X-HE-Meta: U2FsdGVkX1+byiaVHImrOVU1mQsuF8M2sgnLX4UDTV76npvQCC++uY9ZYhWVkBto6mM6j6NT9WIbJ4sEgFh9xBgNfg2Wxywyh0CrlrgmSYf6/ue03dFbvSPjm+1OSOZTz27i3cJ5U8b8Z5ORWW+s85LIMXl5AFLDsUN2L1Mh/Rh8iBGkvRjuiQ95IKwWMU8uHdKJf86NzriAqcJcp8YoZdrk5Uh3YQ/8p/Ckv/khNH2A2l8eh8QlIWgDITn5zn571WmhyuaIKVW6ybu2qhLLMnMbHZUEKU51jYkspCtxAjBk8AtHWRhlA+4TpZVcy9P7wqZuWMaP5tx3sAJP6cA1lRNZdwuZF9xqYsXeVi54AB4rhHigHZziMMC+4az/7C86pPHXlfEnHWBiDIaMieJyh2/YPn5a/BfiWi1kuHCParr2dgTHzNp6Dmxx30qdXke4vB2YwfHGL0IdF/7qFvBmhvXMLpIYL1yYcxU9wHl7oec+YY6yLUkGWx0NhNdk9lAhMfSkmMquuOAa5O4flPFG5xw18PcpznJY4Lj6vhdhxpFfFhMf+jboVF1rXnc6TqHwaqxpHieWXpmA1Py8pbv1UHUwLHkMy9XTmjppKqU69nvj4/IBkAkVu5zCHqqKM6lYbdUJkVyYgvB73Det2ZjMn912oCrU1Pg3eQ7K2XNwz1M4YPsrCVz7UXYmbDxLGaVNp+C5qVgMHR2VUUBZBvCiXOQx5IuPv0HsZvFMDuUxmhX2SnG9KK1LI38jyU9fleEM+4MAVo/BF0ORy4LSi3VBQ8quEZsRqvZaQ80AZZEGidk6QdLtpo3fgqPqVjqxgELI1Oim1j9wIA/fc1L9whOUSlXRoNAmVElxNxJenTvPpRUoPbIRYt3KyqJGyeOWPBKYRr7EEZtHbh4VMhAi/xsJM4kYQKgzvMXAFaZtd2vjjNrCp3XE/O4dD0uHRwfGCrpsyjIBXw6LO4STlHS+tDm
 XoSTZJAB
 RLTU9brLONM3oRl/HuYG2QpjgoE5bLmwhs8RKcEuV8tkSQAlxepE5mEn7WXP3I/VnWDlz2mWJNYFG/MeUtnufRlSIKG03Grox0wddmNa15O6MdIkgUopSR+ITNqA+k+GpC9HxUZf667AVEGUAg9AjvW6AFW54MftzOTWq3LQ6aEOaAIdEBp7/TD6tDvHxhZCiTTNEZ/Q4RtJn+iW0LELt2TZJBzDpkaYPWPrdBHJ0yDsWN4/7XFPBDyeFekUV4OeypJDLMsXGf2AHc5KPdUdJaMjPLKu9UAHniJj9Fp3iRO0ym72aXQ6DUK4bI/Sk3Jvxsu49skPcAJ/uF1B/wlDd0IaVDBZczoI0g20eW2tBfqhNXwb9SMO42xaBVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 12:11:41AM +0900, Sang-Heon Jeon wrote:
> FLATMEM + NUMA is not supported by any architecture and fails to build.
> The constraint is only implicit in the arch Kconfig files.
> 
> So make it explicit in mm/Kconfig.
> 
> No functional change.
> 
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/Kconfig | 2 ++
>  1 file changed, 2 insertions(+)

-- 
Sincerely yours,
Mike.

