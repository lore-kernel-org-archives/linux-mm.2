Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AF19CCFA18
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 05:52:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C96CA8E0006; Thu, 13 Nov 2025 00:52:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C470C8E0003; Thu, 13 Nov 2025 00:52:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5D378E0006; Thu, 13 Nov 2025 00:52:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A3DA48E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:52:33 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 611BA140851
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 05:52:33 +0000 (UTC)
X-FDA: 84104514186.14.97CA72B
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf14.hostedemail.com (Postfix) with ESMTP id A00CB100003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 05:52:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf14.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763013151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZiMmZiljnz2/uXNiRaSdXiBK2zytex92fcOCoLPOE+E=;
	b=p9CakOhKPiQE0bKAvmSVLn8XiDGlH78v2mcwcEQZofu60jcvmiBZd35NdgYhj1KayqhlAu
	DRQZh6HlWUyobeeKVNS9O6LsQjpBR0UVOfTCpEdcFaPYQg9tW2tTRjAKfDvaDTY5U+TReP
	jhqv29ImIPTacyCu4DaMklAjcIG2IWA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf14.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763013151; a=rsa-sha256;
	cv=none;
	b=PUtnRgIf1jkIITLdSYOzG6WZ5AL6rXpt+k6w3EjZ5cbhDz+rzpmYirKL5ep0Oy73aNsD+A
	tDnaYNtkAVmQoRhM4yliZ8MYjGrlEfqn5fawv+yFhDumshjrGOssP4m3wQex490cquRVgK
	rawtZGflS6RYtfUITNP5zMDQLI9GaGU=
Received: by verein.lst.de (Postfix, from userid 2407)
	id CADC967373; Thu, 13 Nov 2025 06:52:25 +0100 (CET)
Date: Thu, 13 Nov 2025 06:52:25 +0100
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: mempool_alloc_bulk and various mempool improvements
Message-ID: <20251113055225.GA28909@lst.de>
References: <20251111135300.752962-1-hch@lst.de> <48e45106-f76a-421d-8f9c-645469076ad4@suse.cz> <20251112155011.GC7209@lst.de> <20251112173405.GA2935281@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112173405.GA2935281@google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A00CB100003
X-Stat-Signature: mgy7zkins35x1s4r6ahekajfssi4n1nh
X-Rspam-User: 
X-HE-Tag: 1763013151-523959
X-HE-Meta: U2FsdGVkX19mK/emVI1LXegoaOEdEIY0fSCwq2oNnYDlZYgiqomu1fjWEP7OsXNuPlhCrL0Qyv/BUG3KyLVY4qQZ372KbLjEfLjlBJvpGBDAs572J7Kn4W5RF+Nv9guzOx8gDvRPhbuwuwepYAoN66PIXr69QTL7vhTZyqEwVKkoLw+uBkkdmpzzqBdGxl6RKA7h/DgO5J6aiYAbM6JMjRXokeQSXJMJ42KZQYZPrcC3sx+HiGq+O1qWhGxEuk9WudcFh0gYw8h6GT/jFhjZuPHDaFewhiYGxFHe+M/6bCZcFDXJcMseNYyA0ujnFPg04txcMGSBbXte3BVZWqmEDI038SwpMtTKxPGHRePS6/dGFi9hRQonZMEil9ZMY+EZ0Lwl96YuxzUmpWgkl/R7KlmZ2LmTDhbLoWSR5eJsOa4EjH2JCBFyHLPa1dU6dMCM+X1BSsWjU+jASgqoYj3O6hT6pkab43nA9OPwHgbQBVD9LP39BBENcyx4RHiiBrMG90mW8N+OrAitDd8kCjWwZK1ymcoPtCLhuO36qL4JOFMluXKAYVY6Q3a/R0iS4/2Aw22qeuZ5h2kOIQzgeIFo/Kln1mtZ8avS8jRfNlMZ7vfJXHUzwF46kzXM2zCiKDn4QHBJDRjUPU0y+hqEa9thQ7koeN4Ti2iarduEByvRVfQ9YFAA8vOgSF5figsTTiH6o+7+Kxp3PjqRUVVZcIVmSoCmLz6E9Ndie/9wjrO1YUcUS1+1oDraBcLU4ZbwnLs8R/RSaaWJ3r0rya/ZM8c0RK20A5o+zd2+XGwe1tjiyObzZLbiDMCkxY0jaPUacFcxM+VOwbEka7f3jyTHqNH1rL7gpxsmoqSHPsFkbj+Ky2txS6QsLQ8GkrhbxxOcFCl3dXTThQwiySjU7bHQ/lsx8Hbk0NSP5JkgjWqDWTmNsmEdIFqZdG755Ygp/2KHJnPU/OAWPw6o+nL2m6dGW+1
 Vf6Mf+DH
 BHOvacdevvDSOIRQmXjxNvqqtQtFRxyjfAyC12Kei1E204vfnfWhbsudjcNACjJ351LM+0ApT1N7soRMQhJteGNNybWj9v7wLfa5wBKH3HzsGV20F6NvP78fEyfo4SXMH+j+ek3GWLTmKFOo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 05:34:05PM +0000, Eric Biggers wrote:
> That sounds good to me.  Sorry for the slow review on the
> blk-crypto-fallback changes.

No problem.  I've got enough on my plate myself..

> How about I also take the two fscrypt
> cleanups "fscrypt: pass a real sector_t to
> fscrypt_zeroout_range_inline_crypt" and "fscrypt: keep multiple bios in
> flight in fscrypt_zeroout_range_inline_crypt" through the fscrypt tree
> for 6.19 to get them out of the way?  They don't depend on anything
> else.

Sure.  I'll resend them with the review comments addressed.  I'll also
see if any other of the API cleanups from my experimental branch might
be suitable.


