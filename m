Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 410A5D35154
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 20:27:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89F9A6B0088; Wed,  1 Apr 2026 16:27:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 877486B0089; Wed,  1 Apr 2026 16:27:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B31D6B008A; Wed,  1 Apr 2026 16:27:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 662966B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 16:27:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E91101B6EC8
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:27:25 +0000 (UTC)
X-FDA: 84611122050.29.8A7BA73
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3D4CB20009
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:27:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Uws9wjJE;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775075244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+wRlZga6UVBdQUfvWB6uS5UqMQsGTmZhX1Om3RCm+fU=;
	b=wJPc2+/5/1wTCSJz9gMUw9T2QWq8gf539sDB9Jp6XBzC4aTkNVuoLEegkMihnW/OKzu0kB
	hQkx4e7smxeXp6tXu5GNWT5MhvENFH3VebiWcgWFwJVtUvLjqhy9oJRtRx58+ghUgkLTqp
	YYYGdoyIjYeWgwXNaPNqo3AZ5I/F160=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775075244; a=rsa-sha256;
	cv=none;
	b=3SM2sg2bHzioXUXBpQFAGJWO9MdLDZ3e1ofqjXxURMYd3CLkWQxlf17Bx/jPpqwz6EyKOp
	L9Cd5tEMmWKhDj/fBWB7cuc+yTh54UeJPlLlom8U6pXsVwuwC2D4n0HcynuOB/wNyUwtIM
	cl5dobSqtbM+by3N+SmAqn0w4yVjq1Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Uws9wjJE;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E5F860120;
	Wed,  1 Apr 2026 20:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C92C4CEF7;
	Wed,  1 Apr 2026 20:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775075243;
	bh=OWtKm95laT3U6i3fhcBOR5W+DKz0FEB3jZZILO5nH8A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Uws9wjJE8a6LUlC1K75cOrahSIa88MlVL/cOcGuUfmc1fIrG9KUDszDZkHNbCl0c5
	 7fg+sHAYKj2SjgOTbgnX0K9/5vfXssNMrRMlEuipz5giV8UMy0BiZsnKd9TrQ7yX2U
	 0FS7eKqnC8rVi0MtpnmgZSNg+gx/mfFft9Y/l++c=
Date: Wed, 1 Apr 2026 13:27:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: Anthony Yznaga <anthony.yznaga@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 jannh@google.com, pfalcato@suse.de, Jason@zx2c4.com, shuah@kernel.org
Subject: Re: [PATCH v2 2/2] selftests/mm: verify droppable mappings cannot
 be locked
Message-Id: <20260401132721.ef6c976eeb5e50b0cf6bb635@linux-foundation.org>
In-Reply-To: <d20a7a98-2bc7-48fc-b467-21eba8df89a4@sirena.org.uk>
References: <20260310155821.17869-1-anthony.yznaga@oracle.com>
	<20260310155821.17869-2-anthony.yznaga@oracle.com>
	<52bec9ea-5627-4ea2-8f27-f1729957fa47@sirena.org.uk>
	<20260331141714.b2f4e41b494060e55610a5f3@linux-foundation.org>
	<d20a7a98-2bc7-48fc-b467-21eba8df89a4@sirena.org.uk>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3D4CB20009
X-Stat-Signature: wudbzbuh9fqut5t65ubszzxc8xp6fyfr
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775075244-481395
X-HE-Meta: U2FsdGVkX18rXAzvgwDgfrRTnKtRZja03+DCGexgVGCi561fSRgD5KbFJmTQEG1vBp2FVEAV2Zh/FeuznG0b5M2bGIHeTf/tR8uoJJ5bIJ8XH6Z9soEPoaF6uc05sf41cYmDIrTnUP9qv9eWroiJ/lMZYnsS4irGVU/U/O4oZ2DYKiC4EyiUUrpmPJT8wZqXpqhJHOyTydrVgOEBH446uAXAB1ljrV3ygbtzbK34BxrdFYHiIUSAC5pEmBAQBqzxkVSLK63sY433o6ldt37QbOTZDXyuDUDeqZ7t2R1da8ivIEEvzv3cPNLsXDHxLEUFeBWdtgMjRS1JSifxF8SMTlQVebOSyIERfgTJmf66jp3cKZTBoflfmjoHJI2lgz9yrWEkOAzm73Y5Jm55tMU5vmfl5FvHPVtMbV4W7iXmhYiPbDC1jUpK3nAYyGF7MldgRdtROu3bi8RFJIbcwXNJKXEqm0/L5rhhYH5fETEQ4wcDD2OouOQsIses2J84TAfox0R6a6ILG82eyLjTlZLRfJOWX6mJOpAhp5m1Dih7nte7nI1njtm0LD3UA+Nkc0nereumKCUeWso7W5EaL/y6nI2ACeILD0ni0baeclLpcuwALBrlsGcUMf1SeOf5Q9DWh2IYsyLzk/EXQlumVCv4tHE/NdEsrdplU4a6bucxGI9zK3g02hOLnybxy4GEpO6MNmAxJ60mls7LMb6S/3kkqeFjUmTFGQV9yhi4D0FrF+BG1MBh2KV0jzIiBYgea7Tlx7fKGfHHBknQcTMX7CBWcNdbAuWiUJCRlR63ayAWO3+qvmC1mQhJYtHhFEpgj4zNEHWXhUNcQWN/YYQBT4uBxlKOKsv9fKyuiCncH+U5/2DTUMTg4c0DM0pwRIQ2BHLrf2zWeMDXa5aCVkJR9Ux4nZ8uPQtM62isDPchv60sxoYs5JOJjwEKDArXFGtr8mIGARToCZ0X/X6uivQ2m7e
 DcM9ye/c
 HTAyyMQ4BY+NcTbdmndx0M6YZf00f/vGH1ZpPSsbnhi+ee4kyesaHAtvFQYRGhA+qotprzdz2DDF7Ft5XRWDKP1DHTkUx5QAkIGmu6C5GF+PG3AZqm7qsR8uTWOIkqjPKIH4i+X/arzOOMKLl5xt1NUwv7cJORi0aFKqOsVRHPfRHkSHdxmr881FDf3VFvILTvtnoqlmv7rLOx6BI8Oszn47Kn04ZGbW/eh6RAfu1Q6wt8nJ6ecnwSBdOGMRcXBmNAy2E/l9KKe4FKOP35yeO15jKGpdqaInigT0E3Mq33X7f7esFp8qFhWlfckNqGV81dBUKoBV4DHH/H7s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 1 Apr 2026 12:17:30 +0100 Mark Brown <broonie@kernel.org> wrote:

> On Tue, Mar 31, 2026 at 02:17:14PM -0700, Andrew Morton wrote:
> > On Tue, 31 Mar 2026 14:17:50 +0100 Mark Brown <broonie@kernel.org> wrote:
> 
> > > All these failures which cause the entire test program to immediately
> > > die seem exceessively strong...
> 
> > Well, is the test code incorrect, or is the patch which it's testing
> > incorrect?  That's 5435ba164b0d ("mm: prevent droppable mappings from
> > being locked")?
> 
> I've done no investigation on the actual failure, sorry - the comment
> above is a stylistic/usability one about the test program.

Thanks.

Anthony believes this is a problem in the test code, not in the kernel
code which is being tested.  He's working on the test code so I shall
drop the current test code from mm.git't mm-stable tree. 

That's 6235dbcce97f ("selftests/mm: verify droppable mappings cannot be
locked")

