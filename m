Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8838ECA0EEB
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 13:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABACC8E000B; Sun, 24 Aug 2025 09:44:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A92D68E0001; Sun, 24 Aug 2025 09:44:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CFEC8E000B; Sun, 24 Aug 2025 09:44:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8B9D88E0001
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 09:44:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9BBAC135616
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 13:44:49 +0000 (UTC)
X-FDA: 83811771498.05.F603F78
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf01.hostedemail.com (Postfix) with ESMTP id 04A3F40005
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 13:44:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ggc0AYSo;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756043088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O8d5UA7qfeVh1MWkREe3yO6C3a3TC2Dl86FLMTLWMGk=;
	b=r3DRX4QMcNhcFu8KWVUKLNjNQ3Xv4dKHt3f6vW2oHH0LJYck8/UfV8i5RdTK3+k1HpOwUL
	oyqLnbazWnymOGwFP+T9cNuG/xO6jXgM9ubnENn+ilncO8N5Ej9+t5YsXqKVOYqpuWw/QO
	ksqq8uj+WZ0A3d/xC8TVPyVa8eWcVEE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ggc0AYSo;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756043088; a=rsa-sha256;
	cv=none;
	b=nspse3zpvfVgKJ5CqfMxICp3XBBZkuQ8dCkfBJuLF3AcGgDeJMfuY/aJjRxL6MZDtOEQZm
	2u46gLVNwg2j+Z5LDAxZhcdmt34M8QOcpTTt2D/M9h1F+1IF+IrAu2DrPoiRMR4E9rpMXS
	xx245ABzw3eumAZzaV06fnIhexanc8Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id CF5B05C5521;
	Sun, 24 Aug 2025 13:44:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56EA2C4CEEB;
	Sun, 24 Aug 2025 13:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756043086;
	bh=lqMJ5yd3r9xmUYokxKE+QAgIXxKUod3pGT7ousJijDM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ggc0AYSo+466AjM774D3VmGKqtFbpB2CG4c3U1bUw10xqrYQGgNq5LPuXWY1VE/0B
	 LcU5OYZCEmA1E9dWnKjuRD2e3kNnUd3HhGSxuLe8T8zcf+6RSyOJp3bso+n5X9V0rF
	 yql9y/XMsOJhfLKzLS+0vxE4O3ub3ITwCFGZMKGXHD5mmKi6qTKHCSQ0s1bqxvd7dR
	 vnyBP3m4mVL3/rIwOVj2nUhsx/Po8lXiCs4Ub8biTYCuL4ZICrnrcwVSzVv35p+FA1
	 dt7rdfPzN4UBWcSTFhSNyqRB7Q0bTUrrN1iRTZjX4EVenjAbRXpTlHCwLOrw/di7Ls
	 9BiY2kSpyavfA==
Date: Sun, 24 Aug 2025 16:44:38 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH] init/main.c: fix boot time tracing crash
Message-ID: <aKsXRq3WQuQS-u6t@kernel.org>
References: <20250824130759.1732736-1-rppt@kernel.org>
 <20250824092150.0543aaa0@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250824092150.0543aaa0@gandalf.local.home>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 04A3F40005
X-Stat-Signature: it6hu4jatsicm3r8dkp1zfh3xd51wndh
X-Rspam-User: 
X-HE-Tag: 1756043087-755741
X-HE-Meta: U2FsdGVkX18Snx6nu9xDg9Zh1JeORLhHAhI0VJotS15ocVzK/uFHb3vUviut+JfGJCbeIzbHOTrKaRcT3A9O53Ktj7Xi1thE31U82iDvLDfc0s7Dm1OlpQDCywJLPtgfCggnVfkeHVAzlzkQYVLPub2ublcdBoaOi4HvihrD13WidCyGZAW2zaPFncuauzS6SXBQoWb75GMxb6Bv6cy2d3AMnL6i39+0DEBpdaInVnblfWxpJYdO58EVh57MJd3IQ/Gza2qIpnZSXtORE5yiX6evNeqho9/7EI/jbMCJvUO7uh7sKivEI4hQ5S3D2aZ1SFUQOMTjkxVTDl39XJ2RBpAlX5lCFhohFLF6HXqAoq8Sd4ZyFCQoQzYySVGnvTkdg35n1qWE7MNfWd/bOkwO1Z0h8vdvjcM/juNubUPG5uM7s9SMgL2DH3AAvYkEWs+s5AvvWiHQ9ui9Qtc/UrrFjuHqptsKRnuDNnKOz2t27j3FGBgrGHV2MgnWbNu+ZiAiJgqdzopN0LqH+wcBDymW3pjNXRjMO0IC2Za/glqk5X4TrinypOpAt6WkimMJLk5N/GkfgPlSlliOhM0GKg0inZ1+UwyXEf+zjkGv/qVNkUIFPajwBjuy1L1cSDwCD0IY52Mh9hQf/ZgMwX35HQxpRa+pVv9Sbals9O/OV0ENZ3BO9xawp24Gbn0vy54o2yqRbyo2AZoWwHCnSJSVHNkwqlRQCEOifAll9eyApyfYtuVLuOGpPKGiQKjiZD7N4sDc2+mPongkDpMi75wiqxFY87RnKMSQxOjenZl0A7AKS3U32X0Jg91qdvyyEZHx95vy2T0ucQ6LBLfgPn2IvTo7SB7WOpnfvRhMXYEpoH7LZXZGniHMwmHYiPgoNhj/g/K7tfn4B8Jr71N5e7qz+Gxh+zmiv99TavdbJ7cLtY0cVtxLmiVNqUYUIWw9qSlMgHoG1Jln9Ls5nz4PE2oxYkj
 T8Q6keqO
 3GTGYu9e991OM2EmVWkfNhovga4hPhfY9MVi8uVN58MZCz9M3mHoXPO4aP5/5BYgCM+5ClGoMxIylx8OKMG6pMZjgKK1Lt7H1uj1wTAW9koR/9Now6zinvQgL6hjFKfIQ7xFq+nVcXqlZ6EoBeYv7JGALDY8ioRY5ZEayAYalPoqPHpQ0oWanPWqpTuyNYLkIrnpjLzsGizaKfGUGUTHJVYqTyqT8xauaNaIsBAc8SkDYr7gMYfZLKSN+9TQSCj+F3lFDUzviL/kNQoJG+m8qqDqRN7hZR16pgR32XtprBrB85sEjVMXz3uWLeaXw/STcAMWpTwt7mEM7iiSa1Q80cpVpEA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 24, 2025 at 09:21:50AM -0400, Steven Rostedt wrote:
> On Sun, 24 Aug 2025 16:07:59 +0300
> Mike Rapoport <rppt@kernel.org> wrote:
> 
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > 
> > Fixes: 5d79c2be5081 ("x86/ftrace: enable EXECMEM_ROX_CACHE for ftrace allocations")
> 
> Reported-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> Tested-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> Closes: https://lore.kernel.org/all/20250820184743.0302a8b5@gandalf.local.home/

Yes, them :)
 
> -- Steve
> 

-- 
Sincerely yours,
Mike.

