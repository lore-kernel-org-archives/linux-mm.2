Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68DA6CA1007
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 00:29:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 834AF8E0003; Tue,  2 Sep 2025 20:29:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E4E48E0001; Tue,  2 Sep 2025 20:29:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FA8E8E0003; Tue,  2 Sep 2025 20:29:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5CBCA8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:29:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E2FCB13AD28
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 00:29:04 +0000 (UTC)
X-FDA: 83846054208.03.0A34994
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5659740002
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 00:29:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UHxl1z2M;
	spf=pass (imf07.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756859343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ERR3eAUcklFTTBqjF7jv7I1yKckhOM4LnlQPamACus=;
	b=LeeJnrLwLnIPRXPRp3uPny3rRatxoqF/LEYrTTS6bVNRkG8M7jEjKXmfSftVbdr7Mz8GSE
	JroSMuHGSLDqW7uEJR4wESOVtbQFWTWdtge7D+0r3FiRie4i0/PsJjHI1UGIsvMnRRsUhu
	VGGn8xBcySUjXzdMvFSq0zDyG5XevwU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UHxl1z2M;
	spf=pass (imf07.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756859343; a=rsa-sha256;
	cv=none;
	b=Q9hrJT/BtWIprZq3yO+B0kkoM8+ZNnTWqZRAk6YWkqLruEJuoDaFRL4X3EMcYsCxrRRwJG
	giQvA7/pYtWZIdnaYGs/2I2/QlKRjTWW3ogqzdvlI1lFx6s3bYBCYJG6BWW7+9QIyj9lEB
	3Lsjx2u0hPpZEv+4Z8ozltqiD8m7vAY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B24AA6022A;
	Wed,  3 Sep 2025 00:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E84BC4CEED;
	Wed,  3 Sep 2025 00:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756859342;
	bh=U6crchSx22A1Dkt0nN8K+hqbGunsTXrVtw8pYSSnspQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UHxl1z2MauCod22FbWqCkY6B5xkLKi5v1sCfCih9PmgDeWl6ShYcQ4PqJQC2fCBDD
	 ejCgibNuovMVGUJl/ISP88p2mUL1tipGRboeaDkwOSPjYKxdz+i9BLka2e5meyuAl/
	 iLaiOyimIXhQ7f29wZx7a8laO0//URfaUDDKqgjSF/wm+mmFDuyqD8TbWlmqO/3Tpu
	 PGvi2PYP7h9YI6Vqlf64fLXbkhHKbL/HxBZk5aAmFE3BCpMZR7geaUzPGagj7gSUQT
	 vAYVUEOO8JtZV4uLblMB3kmx6TDPHaYTR4hYT4Tq00dk1eVrdYNIU113DI9qGSfx8j
	 yLyDyRnl1PwIw==
Date: Tue, 2 Sep 2025 14:29:01 -1000
From: Tejun Heo <tj@kernel.org>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	linux-mm <linux-mm@kvack.org>, bpf <bpf@vger.kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Song Liu <song@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
Message-ID: <aLeLzWygjrTsgBo8@slm.duckdns.org>
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
 <20250818170136.209169-2-roman.gushchin@linux.dev>
 <CAP01T76AUkN_v425s5DjCyOg_xxFGQ=P1jGBDv6XkbL5wwetHA@mail.gmail.com>
 <87ms7tldwo.fsf@linux.dev>
 <1f2711b1-d809-4063-804b-7b2a3c8d933e@linux.dev>
 <87wm6rwd4d.fsf@linux.dev>
 <ef890e96-5c2a-4023-bcb2-7ffd799155be@linux.dev>
 <CAADnVQ+LGbXXHHTbBB9b-RjAXO4B6=3Z=G0=7ToZVuH61OONWA@mail.gmail.com>
 <87iki0n4lm.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iki0n4lm.fsf@linux.dev>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5659740002
X-Stat-Signature: rtm5jex9kz16estih63suwtyyyr47bsg
X-Rspam-User: 
X-HE-Tag: 1756859343-790322
X-HE-Meta: U2FsdGVkX1+DoOXnZxAaDC1AbFEu+AG8DgM6vcNDoZp7YHFJu4hwrcEMdePbAJipbQSiS5U3BL28mCnVFnbLtf6Sv7rpQIGoN0mHmiXgsAFOh9TT4aMOy82iIq/7MkUZWCbZ9lPFNHDTToKbBO5X5LZEkd0Rd+3xRZbpwQmFxWvLgooXsIfbuLLadyLPX5+MerNUcK2nYFs6+2iGH2rPQrKLoNR1BceLY21yqM0FT3OTvMJTnd7ks7Ercmz4VflFnw7eVcag7rFe5/Csxc6c82+W1QUt7Qwx47GMjnUbxp6I2O5vLun1x8E1oOhqVG7pIe984iEGeUQLrO1YzU+G14rhl0XgWJqZgQuQLJsgdOmgH5iuPi8Z+jUFxGfP2JVDWkvQT8+CE2J4vkI0swwLUZ6r+A59BBsqcox++T1pHth8Jul20aLsfVueOlSlw34DloMPZqXgVlPHgTIQjrEQounZmMWIN+GITDvTjeecof3GPcglqnsKoWBXtxgk1jFYr9BdIajMrKiSNrzS2wiQl5O/95bH3HpyfEm1+qMQZb5mReExKUeVOak0vdA7PH+AfbDF8OIYjsjE4OGwTiKY8WUWHNRrM41CyUp/8LCPjBErak4tL2XbGJg96Qqc0fOqR/QntOOb6h0h9t5ZUo2rEraUlmo+5c4LNDGGMGU09Gjaxh54cOduhwD9iAbuq486+cdOECQ48+y1GHpJqHP5bbwhCQmZuZ0xdOKfQVX9qdjFJT7cmziJxMzATkhxwMV6OHrUGTpkT/CW4hmuvhs+ZpipMj6TALTcAtu6dtn6nuZ1/nQ2QPODQ59XgY4YyRyKFfWgne2x0t0RO5WvvgSDLhw3XcJcyMEI7eimaYHUdRH3SFEjyTYfNRtT1jrwbORz5Dsq5aCnl8S2QthnVP5q0fwCBAtp1zZTiCRLCpdNuAAOEWS2fmzug7tZeDxpk9bmOzX4ygwjtDk5+3/3IgP
 24NFRS3+
 jVyEnpoiDU0C9hDfkddzLtzx+sLMCsclF7/hDp2DHupAKU6cAiFExcINwMbwh7rSWDSorD+4CBHjE4p+eSXjOMfZDBAK4EmNZO2mGQ+KUu/6n2WgHm/A22j95t60yvz2M6jqVTjfMBBoQXAPID8+JBYPEdVekKqCzURy//AMRhK3P1Mvic6L+2z5iIiUVdgEJ+1RgepWO6qEeLQORCSymwnpVXQgK9Ko2M4Iho4cn3rFF0V1RKm87ui3kMekLdOgrpnvjXMohj+w0U6r3fFTixMg06MW6KDznIoy5uyBZIeVjfuf0BMpUWkNwKQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Roman. How are you?

On Tue, Sep 02, 2025 at 10:31:33AM -0700, Roman Gushchin wrote:
...
> Btw, what's the right way to attach struct ops to a cgroup, if there is
> one? Add a cgroup_id field to the struct and use it in the .reg()
> callback? Or there is something better?

So, I'm trying to do something similar with sched_ext. Right now, I only
have a very rough prototype (I can attach multiple schedulers with warnings
and they even can schedule for several seconds before melting down).
However, the basic pieces should may still be useful. The branch is:

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/sched_ext.git scx-hier-prototype

There are several pieces:

- cgroup recently grew lifetime notifiers that you can hook in there to
  receive on/offline events. This is useful for initializing per-cgroup
  fields and cleaning up when cgroup dies:

  https://git.kernel.org/pub/scm/linux/kernel/git/tj/sched_ext.git/tree/kernel/sched/ext.c?h=scx-hier-prototype#n5469

- I'm passing in cgroup_id as an optional field in struct_ops and then in
  enable path, look up the matching cgroup, verify it can attach there and
  insert and update data structures accordingly:

  https://git.kernel.org/pub/scm/linux/kernel/git/tj/sched_ext.git/tree/kernel/sched/ext.c?h=scx-hier-prototype#n5280

- I wanted to be able to group BPF programs together so that the related BPF
  timers, tracing progs and so on can call sched_ext kfuncs to operate on
  the associated scheduler instance. This currently isn't possible, so I'm
  using a really silly hack. I'm hoping we'd be able to get something better
  in the future:

  https://git.kernel.org/pub/scm/linux/kernel/git/tj/sched_ext.git/commit/?h=scx-hier-prototype&id=b459b1f967fe1767783360761042cd36a1a5f2d6

Thanks.

-- 
tejun

