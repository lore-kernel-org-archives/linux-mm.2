Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92C98EDF04C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 06:49:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD7E06B0005; Thu, 12 Feb 2026 01:49:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5BBD6B0089; Thu, 12 Feb 2026 01:49:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B67846B008A; Thu, 12 Feb 2026 01:49:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A3AE76B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:49:03 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 54DF5160750
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:49:03 +0000 (UTC)
X-FDA: 84434877366.29.23613EF
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf19.hostedemail.com (Postfix) with ESMTP id 62EE91A0002
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:49:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zz2j4tkZ;
	spf=pass (imf19.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770878941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Ot7GblroqfhRvvCGazSgl6OpA1N7kN5v5XNMPpNBHk=;
	b=vfyfQUtalMnbm2Stdljn+g13dHAuETXDNSfU+GYNBK/Jeh3LRi7TKxRheKe1bp3pyTRyk2
	JWAnkOcDDSXnkGm1RfiSkdF5OzQNx2/QxLCoZXYOhDj57t9Sn6j6Ty30MAaR9Hf9UWDfOO
	uQ83L6UtdwFb0HWiSKj3iNuJAS+43fQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zz2j4tkZ;
	spf=pass (imf19.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770878941; a=rsa-sha256;
	cv=none;
	b=OglHzbwxAa3W7gC/Bd0PBmzfhF+IgO4hVL8vhqmlXLPBzv95V0PiaDt+ECXimbpXes3Uqr
	37w2L7WZWSjtftsdccWTCxbrxLwovTBmm5R2eZOFdoaDsXytb6NoXzK3DOu5X6Xpidc0cC
	WfExpJ1tFPmvkCwpHP1uapo4TzcQ6DM=
Date: Thu, 12 Feb 2026 14:48:49 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770878939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2Ot7GblroqfhRvvCGazSgl6OpA1N7kN5v5XNMPpNBHk=;
	b=Zz2j4tkZn3EO9KTs8o36BNi+FvDlJyJoxDnaRAGoZG4uIWHDrGDAGqKC1vzLvsjf9ooxmG
	1JEyP/pRNQzsvGm+tyYVQ+2o/OEcDdE3rofE0ETYrEpmwW6h4O+h2YeSR/lm76X+bFk0uk
	TzMu3qArighy104CJVhCVLrOlS7IPps=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, 
	Marcelo Tosatti <mtosatti@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: distinguish lock and trylock for sheaf_flush_main()
Message-ID: <6ytkojy77qhla74zo72lodx7kh77jgcgemh2cvzdc36kxo3dxi@273gjcgu56zk>
References: <20260211-b4-sheaf-flush-v1-1-4e7f492f0055@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260211-b4-sheaf-flush-v1-1-4e7f492f0055@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 62EE91A0002
X-Stat-Signature: n8o8c1ffjb96phjeu9xy1x1ubqqiyqnz
X-Rspam-User: 
X-HE-Tag: 1770878941-123547
X-HE-Meta: U2FsdGVkX19wng2m8a6UD4qZKBSg/W6ENNNsuBXJf8OR7kmIJ+i8vPPUYfu8o+bcHFUK9W5dljnKScSGGuDFgr1RrPOIhIraH1ansGWC9MuPggpeN134HXNney31i2tZRA8irNCunvPooa9SgmlHrj4QSexWg21FbXBMt3DDk65xQKIw01AAiWCh9iXRZapcmsPqarU6zGdh93a7wOgJtMk3+1hSddVQ6G9WAOnagxR52E9e7We9X6Hmn4BuS28wXxsSKgfCiy75joPUk6qVqfMt9jUcryZM2ZElA01ye87ELcsOL3mWFwhtCUjlmK0sN8s/KUB4YnkTDZK6VAwwTZc8pAZefIkhVIv4M3fBFlcfvcGYTVPzz3C7YpBNdw134uHIoQhzXFCO9DGaz7vpFYz6BUbGeRkF0VSHFO0YFsSp1DmzUvvisQEfkF4fHr6d33um7WZ9lA1wINuA375eNq3f/w8iZvL5KN8VbIhF9inXVrQrgicgagkGGbXOk4HUeSvIKlRA1CL+tmq8MI7zujIO75d0/vO0VX8VZ+q2/TAOa8QsPa8gLv7iy7fElDaHY3Hz7H9GYYJHJAeGtpb0EXDChFzzoegwcsSpO6C7xqovuaiUN8TcGiwMqm27JYV7yUPXlO0fd4pv6joQmF34NWzYRTBvV4kNImI00GDrYZlCYpASA5+79CyCtd3yjXMC+rTd8u6LNMcw3+xngRVd+MMXZmYR0iXTwzXkLeOoUVeFx+7dXYEEcdjR3WtZ547Q3p1PIQoaXFdK3vBwoSsoPujO0atTLyF0xITkk2ZY6TX71/8We518chNomsNVslMjyAAG9SvOswWHEW1ivEps3h6HFtvwu34Uoui4CXm+MWgd31U/5G055aN3zNmDYabqm4MDJPFb9LzfIsi12ee0m39d0Ud2Jf8vC4ue6NzMVN4cvFDELIdWzUjZjn5gsUw9/AwdE4XPLpARzZ+PORw
 8QkfWRKb
 3rRtQoE6Xvgg7OrgNPYkKRXVHiquZzmR5D85EnZ9M5yS0IcT150+xTx5LgcjnfCKk6oMSmAID+2CJbkak1CTYSb+zrfUNlFk4N0yrk4o1eNfb9d3J4UBCMDt+hUJyIbhN6V7ESH0Xuevf2S+rrT/ldRjZH1jVgDd9XjHCp0njM6Ig79bRgdBi3B5s3DwkXTZZmE1mUPj3BF4Ye8u9eeyWlsGnMXsNb28mcL2Dxq5NWecJ3wMf8t6abfbPApa6bUbVHtWvTLH6sl5ei+i05tKkEO9L/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 10:42:30AM +0100, Vlastimil Babka wrote:
> sheaf_flush_main() can be called from __pcs_replace_full_main() where
> the trylock can in theory fail, and pcs_flush_all() where it's not
> expected to and it would be actually a problem if it failed and left the
> main sheaf not flushed.
> 
> To make this explicit, split the function into sheaf_flush_main() (using
> local_lock()) and sheaf_try_flush_main() (using local_trylock()) where
> both call __sheaf_flush_main_batch() to flush a single batch of objects.
> This will allow lockdep to verify our assumptions.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 47 +++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 37 insertions(+), 10 deletions(-)

Looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

