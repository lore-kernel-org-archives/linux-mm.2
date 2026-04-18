Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEAFFF8DFFF
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 06:19:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A1956B0199; Sat, 18 Apr 2026 02:19:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5564A6B019A; Sat, 18 Apr 2026 02:19:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 441AD6B019B; Sat, 18 Apr 2026 02:19:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3007B6B0199
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 02:19:19 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A2FE18B488
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:19:18 +0000 (UTC)
X-FDA: 84670674396.05.634BBD8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 04B6C80007
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:19:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HODc1NWH;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776493157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cP3eZjgsZQPUbv/Ji3KcPplEwmyDjdqRzZ689haQ3q4=;
	b=rqsMfGzI4N/4UD5ZM5jwwfdQOMHRGvywueqHfx//wRL42eh8Wikz5iRFA4qbDH/bSXgAhx
	B55XzTp7o3d2DsTrAKiiETyfIWCtkgeALprcSWqLMIPfbeome+Godqk0rwvYXPC22QBXHS
	V/wEPVotLV+Al3NhKSJL77rayqn3ofw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HODc1NWH;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776493157; a=rsa-sha256;
	cv=none;
	b=b7sNvpX5sIIOwoazSrkYN/puKSG/SlaE6FO7RoxOq9/g1Sl/VbuKaDg595m9h3VjB44tsJ
	oSlRYsUHMg+vyEWSLFiHXPqFwwUdwAK0LMYNJx/37rTxZ/HlWQ+PA48ab9ylwSwwYYwj24
	WRYjGHmwqx86KJVe7TcnlASYQEYyb8E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D8B860138;
	Sat, 18 Apr 2026 06:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB04C19424;
	Sat, 18 Apr 2026 06:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776493155;
	bh=7bwfd7Wz2cA6AAEntwBa/cdRZlg7gvWncrrHlcEwoPI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HODc1NWHzwxT/VimCpckBa0AcH1O1C0eO9At/6LbFXnk/ARfnMekp09ppJHs41Bin
	 on7+qc2ga4uN7/1sHNeOtzE7S8HV4afiplJFLoLb+fYQ/+xhEasYfI4ebNJzCvxjPD
	 KPAjIocEZq1Q/NhkAA0T4FpB6+Xd7hn/bGXztJZBW+spPAYAATbTo12XlNjFji05f5
	 X2vmhr8oy+eao2ucRnZGxWDyawd3Kxcr30J1CkzeauVH98ekHCPMUUBiPYcnJyt5pd
	 5ZKoqsjV4GoL8+l+0SRNEid/IcTXNm1vir2pVSbkYd6js9VnhqeUYz648h/FTPf0Va
	 lXA5gJM2NSTdA==
Date: Sat, 18 Apr 2026 15:19:13 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Nick Huang <sef1548@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: Add overview and SLUB allocator sections to slab
 documentation
Message-ID: <aeMiYXOXuZmB1Tje@hyeyoo>
References: <20260418000635.17499-1-sef1548@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260418000635.17499-1-sef1548@gmail.com>
X-Stat-Signature: azgizxtiq84h4c9o3j8e8e3bcznmt8cg
X-Rspamd-Queue-Id: 04B6C80007
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776493156-36792
X-HE-Meta: U2FsdGVkX1+xaHR0iFQ/tLKxev6WUrNgkHiygYiwptAkHWQ8tfgvbPeCq0tgeBLk6hxggOuma9tWxtvboBmdEtgDNHC5DnP9fAumkpfxVV4lQGoOLZBf9hGHtLDE555ct8RF4TJ63J9UWWivvHFa1v5lS3AASRd/CavIIxbgD2F9cBP1Adm9zGY0UA+QYY/VTaYEw0h5Cee2mbUMoULtIZws/holp3VJRp9l0ZhkMpkj8DbQqTrvIhtA+W3DCCXus4O7fb7RhFI7wOWApydl6vd2S+c6LIpIOs3IAQIk+b0GyY8SygVjnDF7br5sgApRsPKQzVSunSKviTnmTjY8DtQ81hXyVsYlXaPU/ekhzwQlyNs0msL/LSBV35JQoEwdGWFY62vFHiSfgoZQxzO7PBpmHfLKJXOLRxvMJ25tGmN3rJjc0NB872YDDzLWUITAFeyS7TUwNjdM5zz6dZDzVY7shFrgSVJfo7tbCyFqfR0D6uvexD1SUzhwwecvC92lceMs/2NJyoltca2P9Rzh9PsWrlcdQe/GZcM7V9pdWaQJr0YAyu+hjacZnU6BcAX4yIUoTKOwS3ovYcDo1c6tWrkCCNhNAgWZrI0j1pA68dqsxAaWyBukOSS0U4AhmA69Ech2l+Dfi/HwHWiktHc0ciUd6i0mBpfhO4qDO2Hw9HZCydCPJzdNnNl6a6ZPdLEUNI0BeReF5/hc4Y3GrcYotFwMeAy5kj+4Z7cGK6frZOAa1W6QwvzHAM2lRhWlEf1nB8xw+VOTNrCxjriZg9tkJyp9jnCKYhGdooJU0fUEVSYVoAAFuWDb6D20Sc/c2lbhomywbaaBpe60E2vHVrJNqFoIqTonoGXmXKaxdpUS7V/udIFEf5n3YZAPDzJAU4Q7HpdY1lUCOC9NzJalNZtdssq9EvDe2dApAM17pMYRQUaaLduW8Fsx4e+plKEnEI2hd3vTGqHPwwo2B029Kxt
 sBIrE+m7
 tecCDd3AwZvcJcaaoyc/GP8g1xB5qAhXNRT9naOFk6gs7sC16lE+PQ+Hk4tKYYdzdn9ilCSXVEMa3CsVwEExV+r0uXr3JHrn1XbVSG0RCunrDmuOwMD5HuFqeNbAV4jq03Ry3Ww++vVsrHAzIVnkg3fy27HgF3ccKNiUWTZ4r+UTKl/8bOA+HY3LEuWjlrOf4Z1dA2DQ19vO3vCWsNDgzN5h2hupfUoGZR2PHrZbqKjkctdhzfXTEw5kvjTZVjp24FDUn+QoLOQ/9gBHkWijdNPMk9HTqP7e4R07GfwOa9EtHPUqDtezeFWM6bZ0z0hCZM0lsXgVXftNWCs1EiDX1fxCL0XYRR52GIv9C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Nick.

On Sat, Apr 18, 2026 at 12:06:19AM +0000, Nick Huang wrote:
> - Add "Overview" section explaining the slab allocator's role and purpose
> - Document the three main slab allocator implementations (SLAB, SLUB, SLOB)
> - Highlight SLUB as the default allocator on modern systems
> - Add "SLUB Allocator" subsection with detailed information:
> - Explain SLUB's design goals and advantages over legacy SLAB
> - Document its focus on simplification and performance
> - Note support for both uniprocessor and SMP systems
>
> Signed-off-by: Nick Huang <sef1548@gmail.com>
> --0

In case this was assisted by AI or other tools, please disclose that
according to the process document:

  https://docs.kernel.org/process/generated-content.html
  https://docs.kernel.org/process/coding-assistants.html

Mentioning because some people using tools to develop/document
the kernel are not aware that they need to disclose the fact.
It's better to remind people.

Tools can help only if, you, as a person, understand the design and
tradeoff behind it. I don't think it'd be useful to spend time on
improving document if this is driven by AI tools or something,
not you.

If you're using AI or not, the fact that you're not following recent
changes of the slab allocator worries me a little bit, to be honest.

Well-written design documentation is hard to come by without
understanding the current design.

If you're still willing to improve the doc, please do more research.

>  Documentation/mm/slab.rst | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/Documentation/mm/slab.rst b/Documentation/mm/slab.rst
> index 2bcc58ada302..2d1d093afb7b 100644
> --- a/Documentation/mm/slab.rst
> +++ b/Documentation/mm/slab.rst
> @@ -4,6 +4,32 @@
> +SLUB Allocator
> +==============
> +
> +Overview
> +--------
> +
> +SLUB is a slab allocator designed to replace the legacy SLAB allocator

As Matthew mentioned, SLAB and SLOB were gone.
Also, it isn't really the traditional SLUB we have had anymore.

> +(mm/slab.c). It addresses the complexity, scalability limitations, and
> +memory overhead of the SLAB implementation.

Stating "Compared to SLAB, SLUB addresses X, Y, and Z" is
worth adding only if with a reason explaining why.

If you think SLUB addresses certain problems of SLAB, please explain
what problems are and why they exist, and how SLUB addresses that.

Please make more solid arguments with explanations to support.

> +The primary goal of SLUB is to simplify slab allocation while improving

I don't think traditional SLUB was particularily simple compared
to SLAB, to be honest. It was probably simple at the beginning,
but then more and more complexity has been added later.

> +performance on both uniprocessor (UP) and symmetric multiprocessing (SMP)
> +systems.

SLAB also supported UP and had features to provide scalability on
SMP. Why do you think SLUB particularly improved performance on
them?

> +
>  Functions and structures
>  ========================

-- 
Cheers,
Harry / Hyeonggon

