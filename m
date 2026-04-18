Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF5C0F99C73
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 09:07:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1958D6B01A7; Sat, 18 Apr 2026 05:07:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1465E6B01A8; Sat, 18 Apr 2026 05:07:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05CFF6B01A9; Sat, 18 Apr 2026 05:07:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB39A6B01A7
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 05:07:32 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 690458B937
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 09:07:32 +0000 (UTC)
X-FDA: 84671098344.30.706D4CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id A488320008
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 09:07:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TG7KWcuZ;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776503250; a=rsa-sha256;
	cv=none;
	b=zz3OyCLELbQjUD8ch3sr4U/WZAiOx8b+qHGCMJAkjAG4uDZ/5ttM4QS5DqQ9Vt8IhDOKQ2
	No9hzNww1ucxoZKDgsE0myEPo2a/71Z2I4RBe/lSwZWVSC9wrKgWG2I1Q9SXogdsUkFxtI
	XDVn9Uo+dfRHSnM3OzLh861sSnqPh8c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TG7KWcuZ;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776503250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Q4bTA6DrWmENn3a8iZ4OeXQSCWOyJ8804E96amTJpY=;
	b=moOw3ha/z8kDF+LNbuG4eB/xO6mysqbpCUvlfXiMOCm0ojRKJGtGIOKpQgkE0FLtOWJvjz
	uRNq8sNufHzsDQcLr+9jyNoQcyX75VclldHTI0EbQFkqERoleowN+QPt/9drA4VRdxB3be
	4u/d7remdh0tcfF4iHNYtALh/o5aprM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B4BD743BB1;
	Sat, 18 Apr 2026 09:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736CDC19424;
	Sat, 18 Apr 2026 09:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776503249;
	bh=YA5a7LW/8SIrN7QzNwi1X4GpsR9ltQhDlTH0dSO7vFg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TG7KWcuZ4i7DPajHSII/lpzC5PZ4KQUeHsHChwpJ1RTY6ap325/2WSvpnBZwKP/QT
	 JcPyTwh0zZCMKaBTNRIDsOKvBeC/6ZX/6tyzFxi0TEYLCGqhjW70vI0NW0xfe4qCRl
	 LHK0ordRGNSG6KbAC1PPjahDiUzUdqyut9xrWdCG7nkU3PA3T1pY8TlZwIXqXf9L5y
	 pE0lggIZby7ILLId6Ff/EKWvMCE+E2gOk7JnXKwj3CgIaXJkuVxEfp9rE0+QA39LgT
	 UTfGP8jtZZ55qxBERh7/5KdkPDJdea7UBcA9T+HWRVC1X+uPWmrqgzf5WUvee4SVtz
	 UUqxsEIGmb/Ag==
Date: Sat, 18 Apr 2026 10:07:22 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Nick Huang <sef1548@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: Add overview and SLUB allocator sections to slab
 documentation
Message-ID: <aeNGbNyPxJssnkbO@lucifer>
References: <20260418000635.17499-1-sef1548@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260418000635.17499-1-sef1548@gmail.com>
X-Rspamd-Queue-Id: A488320008
X-Stat-Signature: c7jttomt3rcjt1iqs9rfmxf4bbdeajta
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776503250-762176
X-HE-Meta: U2FsdGVkX19L86i9Qz/LHT4xy1eQZ1WL1U0C8ZRArrFM2kaA40q/VOrUFg5hlz7FutGr8xAGYkuJkGP8e5ZmOfhtxTAu8bT3PQWg54nyJUZkedYBIxmMPvPnPhhzs53TFKjzYJbc2Y1YuCkMf/79mURwS1sOU2vRAhzmU/0/njJoSCN1/bsiwJzVb6+YedDA0RDBviXnxZj3Z284yrzj7+sjdED+6YZAoMt7rQ+DYLXOEeaTfmynbgFi6aD3KO8mQDYMi5w+xKXbGjgR4oVcWAdq1XqAkKBsfF35lrWStnvIthcqLJUBRz+x3O+ZF0ldiw4LyWzFXjgL25npM1l+koUf0C6DvDx1xE/uelLgTxxTN4M/fPJzGEpMhnElcuve7MTYD/AmseiqJft1nJq8E5gHKDNUsygo1gFZWWJjTUhJ3OnGgZmUYZud6lbISvejeATYkwgNVZyjvqPdbQWzXNp0XWoMOr+RIhjZY8vumG7Mtu7FAyRgEA7YbDaNQG3ft0pDK5avHROCvtXux+a6VqJMUnA3r2rXFjdHx2xocPyNb6q4yLpApLHWDgLibbZsE9bAmQ1djBGvpMjG2fok1VfJA1l1b9KZofmO6eUZ2a2ewVLr1JL7VngyZoiD4tazVCnwP8Q+uK2QXs3XHG27a43ftOT2DwcjdzsoUWqKYct/RQDZSRKUpXBWJIHfeuSGqScL7NdKV7flEqjVrFk44Wax3wusaTK/RIFav0WF1WF9KsclEOB/CTsWsNQitcsk6RfEDL1MNRosFwX3AbJsFYSbIsNRpf4Reha80L9R+mUJ4yBiBuro7YAroTTuLQh34/NVResCOArrPls6p0qu8S9ZsANXOqz32ZXmQ7ToVpHu0daXxSSGGW8tM9gVGqrEgjl7oY6n5lQ7QzmjzsOTp9oWXEfJ4xnV2w0pj39TI72rgxGuT+m3xjpQrq5glTWnXiyml6aZyiruaCxYni3
 d2pCcbVv
 NXLO/nXHpC9RBKFzsO1fAMi1goQADfKECN1cq/1/hLlJWQIeFMc22QnnzI3GqmuQyNMFIRCjEYArl0WTOR7NP7nNdsgNtVfaoEwIVLkcA+kisT8f/asLHcarPcCIDCqvKjGGivw2n4KV760JJnlenOjZ+kattO5Onup4KBCdDSXFsyjoIemIIomYM6HDwzAanVKLUZAA5G+vI6re/EOf4sdqNZTDI9aULkXJtDP/bRG85aLRDumfa2gVuwneMG0aILWJNMCelQlmy7fFlQcJj3Vvj6jPF1jtGAnIHcca0ZcjHUqpyRnM58z/9Ab+qYwCdeK6ht+Jj1x9dYVk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NAK to obvious, disrespectful, AI slop garbage.

Go read https://docs.kernel.org/process/generated-content.html - especially the
bit about dismissing crap like this.

On Sat, Apr 18, 2026 at 12:06:19AM +0000, Nick Huang wrote:
> - Add "Overview" section explaining the slab allocator's role and purpose
> - Document the three main slab allocator implementations (SLAB, SLUB, SLOB)

The fact you're insanely wrong about the current state of slab only makes this
worse.

> - Highlight SLUB as the default allocator on modern systems

Not default. Only...

> - Add "SLUB Allocator" subsection with detailed information:

There's nothing detailed...

> - Explain SLUB's design goals and advantages over legacy SLAB

Irrelevant, SLAB doesn't exist.

> - Document its focus on simplification and performance

Who cares? This isn't linked in?

> - Note support for both uniprocessor and SMP systems

Uniprocessor? Seriously?

>
> Signed-off-by: Nick Huang <sef1548@gmail.com>
> ---
>  Documentation/mm/slab.rst | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>
> diff --git a/Documentation/mm/slab.rst b/Documentation/mm/slab.rst
> index 2bcc58ada302..2d1d093afb7b 100644
> --- a/Documentation/mm/slab.rst
> +++ b/Documentation/mm/slab.rst
> @@ -4,6 +4,32 @@
>  Slab Allocation
>  ===============
>
> +Overview
> +========
> +
> +The slab allocator is responsible for efficient allocation and reuse of
> +small kernel objects. It reduces internal fragmentation and improves
> +performance by caching frequently used objects.

This sentence doesn't even make any sense.

> +
> +The Linux kernel provides multiple slab allocator implementations,
> +including SLAB, SLUB, and SLOB. Among these, SLUB is the default
> +allocator on most modern systems.

WRONG. WRONG. WRONG.

> +
> +SLUB Allocator
> +==============
> +
> +Overview
> +--------
> +
> +SLUB is a slab allocator designed to replace the legacy SLAB allocator
> +(mm/slab.c). It addresses the complexity, scalability limitations, and
> +memory overhead of the SLAB implementation.

This is useless crap? 'X is designed to replace Y which doesn't exist but let's
mention it anyway'. How is this an overview?

> +
> +The primary goal of SLUB is to simplify slab allocation while improving
> +performance on both uniprocessor (UP) and symmetric multiprocessing (SMP)
> +systems.

This is meaningless noise too.

> +
> +
>  Functions and structures
>  ========================
>
> --
> 2.43.0
>

You've wasted my time, your time and other people's time. Have a think about
that.

Lorenzo

