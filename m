Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF878C87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 22:29:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5214E8E00BF; Thu, 24 Jul 2025 18:29:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F8D78E007C; Thu, 24 Jul 2025 18:29:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 435B88E00BF; Thu, 24 Jul 2025 18:29:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 34D7F8E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:29:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 65FB3133B75
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 22:29:38 +0000 (UTC)
X-FDA: 83700601236.22.6DAF6AA
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf16.hostedemail.com (Postfix) with ESMTP id 00F00180009
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 22:29:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MqbfNbPD;
	spf=pass (imf16.hostedemail.com: domain of kees@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753396177; a=rsa-sha256;
	cv=none;
	b=G2NuAyW36pxeHPG+NMaJYtlwjOM0Kn1UOK8W3kmM9Cnlz7VhdKh5xulnkmgPWf0rp+//bw
	3swXj7a3YhcnJHVjs8Ahnl0NI65R/O15n/386WS0bZkbhI39j1S1EYnwckvGOgP5Ev60EJ
	50UmfOGu4y3H8N9kFQ0KU9eyjWaCbJA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MqbfNbPD;
	spf=pass (imf16.hostedemail.com: domain of kees@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753396177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iYOjOEXV/d4hZiplRdaSSTLgcOrC+WpUd8xUFU9tOAE=;
	b=vCyKLVNeHMjqIlEaqYGQLtikw02LnOPtVaQMRSbpScL7/Vc8Kc/27l2UPCSsNaJOVMRRuA
	7INzluWn3vMo+YwuSzOLolMYpWdlPHgKNM9ohol0c/4hahjCZjcqf8Ci67+Zzps5naSYCL
	GRAcF+yhpZWfQnM+YuKhRXeFrZ1lt2c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 4B913A5628C;
	Thu, 24 Jul 2025 22:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD4FC4CEED;
	Thu, 24 Jul 2025 22:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753396176;
	bh=W+PLhvsmzTgMSVd5jUXqYnhed16MMxVnE25H0ac9/Pg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MqbfNbPDaviGnvO64ciSpBqc/ox0Jl7XneeIO8AVezVenHude+I/K2YyWwGr39t9N
	 Bc5nu38G37xNaZnUluI0HsBJqyGkKbaK9TUxmVu2DMJmYlyIW9VCQ8u3XsqOqB3TSG
	 rbcnnHQVI8ALO80+JF/kmon5qcGn6Clkpt7RYWqU5WPwKNr6rFibbeluZIqnkNC1Ud
	 8Sr+R3Bwy59Tfn/FVFetQPWlI+xFAWsxew6nKq8yJPU6F+OGd+debCHPN/clEP+YxX
	 Bu4hL+mxNV4t05wexN2LVwyT7xs0iPsKVLYrW0VA5cxR/Ndc5kh6AN0BU9MiwWHivO
	 clndEu5FCvSrg==
Date: Thu, 24 Jul 2025 15:29:35 -0700
From: Kees Cook <kees@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Jeff Xu <jeffxu@chromium.org>
Subject: Re: [PATCH v3 2/5] mm/mseal: update madvise() logic
Message-ID: <202507241528.A73E1178@keescook>
References: <cover.1752687069.git.lorenzo.stoakes@oracle.com>
 <ec480dc1fd4ce04bb11c0acac6c6da78dc6f4156.1752687069.git.lorenzo.stoakes@oracle.com>
 <202507241352.22634450C9@keescook>
 <e0a22433-541c-40b0-92bb-34b0596db642@redhat.com>
 <ef111032-e108-4771-9202-b8cdab278422@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef111032-e108-4771-9202-b8cdab278422@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 00F00180009
X-Stat-Signature: knd41csdjqet3sbus3o6itp8qefahg5t
X-HE-Tag: 1753396176-640944
X-HE-Meta: U2FsdGVkX1/TtDOkec+hQ8O3zKs86vb9S4Ptn1f6Qu1EXtXy3Wg0aD98WZkh0f80/DRdJMvLcTEQyPwsB2BEmRR6NSAC8R5YvuRVMEBZSwd7dZ7AWOEUKpVfYpIdE4HIzSm28cg4f+gxwUF2cXh+GuKY2NZxx8fW54wrnqPDGML234EXh2jhY229vLMrmRHICb4iGs3huvOGItIKe2nHKWV7lgGN1/RFv0mMr6sCgxn0wbr1i/oN6BokfZB5pw4eOLo928+H+/kmTwBOj3PhRlJmi8BCUIo+WpPCDRVhgjA4ajPlxkGUri3OJpwcRsTaTb2QuseN217FU6xZ+vuKz3+kbF9VYElqi5KORfXw+D+Q/D868RHE8l5puD6MSBSC48S/g+7+USsQE4U+o8Jy8p2p2Czwuqj6j/ut6vJe3vFo0ukY2AqCzG3m7HoUKrGq14CNtmfrPTUq2Q9PlcCGzQOFt07zBnCP3c0aQ3/H0Lm6FgzKVqe1ePVaH4ieYIKzmVNlpK9VMfmpI2Z8B7K+PUiwy2jrt6VT4QgW7PXr1ChZcogc0sv+vxQaeY4YYlohu/HuliRHPkZAG7JTPhsxUBk3PEK4zTP6wNNKSlsXJ+e0mfo87hzWFac7pgXeesNRANGtlvHhpSK7lrcIPnq6fKcRXY6bElCfAM2NHOQo6kh0Vgx7YNN1mxq1PrkktYWPgDlWp5zGXreGRyF71KJY4LZIMtjyjcwvlzVu3tdfx/+kSzCW3hB+OnXNwwyJxMXzm8Zut1uD13VcFODU6q+R+rrVZ0k4IupzNEk5XJNOWQ/M1So3R+byITG9fX9fehVhgbItTth6ES4knxg6jl1rkCcuRdWwU+NJ4hzE6kqWbuTnQHawb1dnVHff8zsEgvAaCuVqKSPIKRtayySt2yQz3Fiag2owIXNHrhz3zXcklfk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 11:41:04PM +0200, David Hildenbrand wrote:
> On 24.07.25 23:32, David Hildenbrand wrote:
> > > As an aside, why should discard work in this case even without step 4?
> > > Wouldn't setting "read-only" imply you don't want the memory to change
> > > out from under you? I guess I'm not clear on the semantics: how do memory
> > > protection bits map to madvise actions like this?
> > 
> > They generally don't affect MADV_DONTNEED behavior. The only documented
> > (man page) reason for EPERM in the man page is related to MADV_HWPOISON.
> > 
> 
> (Exception: MADV_POPULATE_READ/MADV_POPULATE_WRITE requires corresponding
> permissions)

Shouldn't an MADV action that changes memory contents require the W bit
though? I mean, I assume the ship may have sailed on this, but it feels
mismatched to me.

-- 
Kees Cook

