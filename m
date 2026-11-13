Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 931D1606B473
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 17:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aNTbB+EJ
Received: by kanga.kvack.org (Postfix)
	id 6DEA56B00EF; Fri, 13 Nov 2026 12:54:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B65A6B05B0; Fri, 13 Nov 2026 12:54:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CD226B05B1; Fri, 13 Nov 2026 12:54:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A6996B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:54:05 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 843A6A7B15
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:54:04 +0000 (UTC)
X-FDA: 85430844408.05.25EBBC6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id E11DD40004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:54:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aNTbB+EJ;
	spf=pass (imf07.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794592443;
	b=iM/i+icqkcChS7yvDZXMmwhG7nmmnCOaceH5saL/OnkEpsXl5JYMLSgm7vRm/AntE5KrX1
	JRmaECMOE4Br8SHkajCiXQ9V/Il3sanKWX0zrNCQnUiFiozTpHLDHU+Ql7ZY+Ya+h2DwM7
	5hP/iHWZFQ8pCrE7+IWhE4hg9X1zyc0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aNTbB+EJ;
	spf=pass (imf07.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794592443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YOhDE1A1NoWSc3HJwwDv7rAFd3isHMa6WzPG0AjLim4=;
	b=X1Co2JRlIrp3niU6ZcFsg8eKMWnbDd/vOt/jx1fLIfuQOujMJVODyQeHP+1pwjaZEDTj+8
	1juFhD1/zAmjJm0KMRFaFLLzJcvggPwcVfqWs+xUC38pktndouE26GVYReHIpBY1cxR32d
	IO1/FL2hk8jt4eBjITO0rsLtGJZbPIk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 25C8642DD5;
	Fri, 13 Nov 2026 17:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12FB1F000C4;
	Fri, 13 Nov 2026 17:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794592442;
	bh=YOhDE1A1NoWSc3HJwwDv7rAFd3isHMa6WzPG0AjLim4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aNTbB+EJz4n3/fVzL99OxKi/yQ7LVSH5J6kc6Jo9gU+zr3YPO5nCdRI7Zzcd6gYZv
	 Yo/mOVlnPijDK3bwYnF7YKw8z3B7jAT31Fh5qGtC3xYdcqh1G1W+lEi8yQ0ap15uLg
	 G50OnTuSIoXaO5drPd4o28nKQThc+FTZJqTQDYhwCYz3Ug1NZvDrAgiXRUaDRWHkId
	 tYBF1spAr4DG+g6tzrfafOd7CnXkOHDj7qgA7jGuWmZMjVe6m3u8pRSHGmSMCd3jDn
	 w+V2ReHymkGyG3RRc9V7uWs7OdQbfNuP0xshxE6mhTjhNrno1Jvi+P38MozjWubqgx
	 K1ZAbQgfIDxqA==
Date: Fri, 13 Nov 2026 09:54:01 -0800
From: Kees Cook <kees@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Marco Elver <elver@google.com>,
	GONG Ruiqi <gongruiqi@huaweicloud.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 5/6] mm/slab: Support disabling
 KMALLOC_PARTITION_CACHES at boot
Message-ID: <202611130951.3B6741770@keescook>
References: <cover.1793253633.git.chris@chrisdown.name>
 <617bbfdce4fb2689c2510f0cd7f9adbb3ab8edfa.1793253633.git.chris@chrisdown.name>
 <202610302123.687A961@keescook>
 <20261113005212.556c6f234712bdfe@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113005212.556c6f234712bdfe@chrisdown.name>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E11DD40004
X-Stat-Signature: mw7jtayj471pmrdaksy97nys9s4i3hza
X-Rspam-User: 
X-HE-Tag: 1794592442-400924
X-HE-Meta: U2FsdGVkX18pMeb+LlMx3IWlFW4lsefZeEKRkN1iD1i4yKwYkJri4o1/14eGXov83ydkbm85/POSbTlU7wZMDlGD1cXfJLJ2fLJXZabOv4kiVN7Dt0cx1odIXdVLQoqsGx5iV9z4BhE4Uy9lLSsHBC/GKEYDgacxX/96XB+KHzVSYwaonb4rCv+CxpTmnibw6q0B8G85l6xvpxg/mRSAunHUus2UW8dTeeGpcdS0nyhHPjF+FJ2VCp+hpppPwurbk0/1KGd74xU/lrVXrybuW7gEc2JeNZ+Y++XdXoTxh7l4zJOMA5JDs3gKq4YcU4uGjaLzoBPJaOOz+2T7ewNZqDWUx0C8eTT7Vv4IAuU9iaBlgExSnxZkMGp3nEuaH6hZTIMn2KM9eXhxyG4i26Z95v3nPudWbAB4GVdwuHBNf59XvQ3hhlfD/3Dr7hiUIGsU5t1mYT46TBDhU5KLfabHtcrM/t/y+NVaVh5+yN0l3qXY9O8k9mGE2xhdNWtZFiOSVOFs8ksGgbAY8qr8kM1W4NTJ/wdAeu5mwM2S0IjW4PYicbvlAu2Vd9Xw3ABAxsNRwlJeTBM/JajRYaXizdg8TNEC/2PGpxDEblBCylC51GwpMfkMnYh6knMKDWcBc8IFbi+En49PPxhbS701vfUvmnrVawwCyHaWp9p5lr/IOUSGFo8bjPXRhrk/Hdjxk8WTNWmhF1CkpMG8AKypHfkwQkdUpge3X/grO8wLmdNtzPSt8wRy1sMGoM2eSvSBIIoFJYktxqG7X2dAYquo9d8spCQY8e27dUCpkqY8gaQrLalBuTc1qYoFAJUVrIpJkw7gfXFMUYgGVdLPfE9XjvbX22VLKgvUxFx+Gpef7fXv0PnZisUYlpePdCjm283jQnX6fxrWefm0o3hTKPvDGYDhIGh4cyEuyjRPTXufFh4LrW76nznwIRQIPSWw/VOIXB9VoFIwmHJMPf4gQEmUBPS
 Re67xWsc
 seaa8Em/OTPck7LpH5PmKXWgIGMsC+MMMz4OmZuZBKoFfxRhgkTo4lMFKSqgHOGikBFT/PA2a/XYK7ZbGaXsjVE8evFbEwmkSrQlv9TfKPtG8rXWugCYbuJbtRr599gm59RzyVyKwnwbULT9lEdevbmN9i1+iSxAg6ZnVptVk/N8ygoQt98IcGyaA39x2nUe+tyXeYEHVjANYwdAmemoW9NttbZgBoo61W4UZ8JpufTIeb6VN4SmQ9ABSV/h2fp8xICg4xjqU8XQ73Op63ciNaX81aqP5uVG8bQSfDgZZFjDhUCE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 12:52:12AM -0800, Chris Down wrote:
> Kees Cook writes:
> > Swap the ifdef for a CONFIG-controlled static branch that defaults off
> > without CONFIG_KMALLOC_PARTITION_CACHES.
> 
> I've dropped the #ifdef in v3. kmalloc_partition_enabled now defaults to
> IS_ENABLED(CONFIG_KMALLOC_PARTITION_CACHES), and kmalloc_partition= is
> ignored without that option, so new_kmalloc_cache() doesn't need any
> #ifdef.
> 
> I've kept it as a bool rather than a static key, for the same reason as
> on 3/6: the only reader is new_kmalloc_cache(), at boot. When
> partitioning is off, kmalloc_type() still picks a partition index, but
> every one of them resolves to the normal cache. So the flag is never
> read on the allocation path.
> 
> The one place a static key would actually help is kmalloc_type(), where
> it could skip picking a partition and go straight to KMALLOC_NORMAL.
> Since kmalloc_type() is inline, that means exporting the key to modules.
> That seemed like more than this series needs, but if you think it's
> worth it I'm happy to add it.

I'll go look at v3. The goal was both immutability after init and
avoiding a branch in an allocation path.

-- 
Kees Cook

