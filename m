Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ECDAE7E361
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 10:01:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66A666B0005; Fri,  3 Apr 2026 06:01:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6438C6B0089; Fri,  3 Apr 2026 06:01:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 581A26B008A; Fri,  3 Apr 2026 06:01:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 45C3C6B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 06:01:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 636D3160593
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 10:01:22 +0000 (UTC)
X-FDA: 84616802004.20.0701BC0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id AEB2B120011
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 10:01:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oKH8v1zs;
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775210480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kC437FZ28/dmK/b/RRN7l4LCBGZyIecJtnj1c7YP3Tw=;
	b=URAtvp58p6vJPZldh4/osZ7rJFSH2s+oBQj5rXmST9lc2jQM2bQswsapaBZm9JM25A6r5T
	SgW2px1etFo1rBUBvjCpmhG3MsHdEVbgnUCVq/O3xmtzzF4CjhaRrv5jz/DzQa8Q0OgPjk
	JDgTL46n7zA4Q2yJeDyslyxBxfrmTrA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oKH8v1zs;
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775210480; a=rsa-sha256;
	cv=none;
	b=zuIFYIy3jUaeEhjpvWXgB+pD0Kq5kpYHzDbOKhy1XvUltIGI7ywOZUKBsMnUXt92m1NbwQ
	3pmPY9A/FNdZLYkmCGT8xSHYYNcWU7Jx6BkX5j+fCfu9F3mHJWBlRIr8gsrQZDeQf4paHP
	obTFdWZZ2s4xoIXpQMGClN9wL1RljnQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C581A44259;
	Fri,  3 Apr 2026 10:01:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478CEC4CEF7;
	Fri,  3 Apr 2026 10:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775210479;
	bh=nSCRqLQnM6uFzcHt8+OMxjPYivIsJJkDMf1sy24GPZ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oKH8v1zsyhD+mcjNRFIOjLFDK0MSXlNzvKI9BgeiburBCk1IfEIhL668l8xWeVVmc
	 P7xneHP5f9vcfK5kggJAmFrMRb40j9kE0/sW63ZEiu1fJs+iGDBOKyhRfYbhpNKIgp
	 gOsNTLqbrYhW77uNHbbyJq0jYfyEPeIIv+K4hem8g0wNT/RuEB4xMyb7tk6vRUT6qu
	 3ctZXOD5mKvnBgbeprlsZraJhajIsPZTPUHGGA0eoIPz+ODcC1GIH+4Ol0otJugL0Q
	 cRpWUSnhiHqsoUQTeaGZxnPaBxODyTA2bQYtTPZYBzUVQgqRRq3z15GJVaNKBk4rT0
	 G1wCEj7k+DqLw==
Date: Fri, 3 Apr 2026 19:01:16 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH V1 2/2] lib/tests/slub_kunit: add a test case for
 {kmalloc,kfree}_nolock
Message-ID: <ac-P7LlFgbNTBxsc@hyeyoo>
References: <20260330120517.104743-1-harry@kernel.org>
 <20260330120517.104743-3-harry@kernel.org>
 <26e81ffe-08ad-4c3f-a360-d45c3cb32ee2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26e81ffe-08ad-4c3f-a360-d45c3cb32ee2@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AEB2B120011
X-Stat-Signature: 9jgb97i45otposy7mkiosg6keqiqpi7n
X-Rspam-User: 
X-HE-Tag: 1775210480-508563
X-HE-Meta: U2FsdGVkX1+yEIN9L8kh9VjDnGRIzS+DoKvl9kOLfH3j88cQFqbmvj2QBXPleuAlRXYYHwqwlYyiotwE1GrmBYnVMm736p7zk678CRCRcXgrEZPPFBphZn/Df1E7oh/Z81HAHWld5YvCHJKSoYExm4NvCMXPE5xqc1MiRmm5N6MJbSsAOmk2nssd70S/cWvwOiDYV4hce7xjged43Ueu8GvaMHnpE8z6KohmXZO0MyF4xrvdAWAnCHl3z714JKSDcwBdOf4qPQi0XhTQgWPA8hTJ7vwDvKPpVPfCdc8XRExSgUdxi8W7aAGq1j4VgQhjJCW0wes55pSgOUwMlMjjsJWM2RVtOCZedUY8sYo873uhFAM4yPJ7SjNUl5kMZAJPq7PnaInIcoeGmaIKD70OdWFXL7OovXGmCiaPGtzzPBRt3DFhnQRh7/J3BXkK+sJz9EuBS7T2A/Y4xmFmWHpB8YhHA8wW0vxAjwVOZciRv0hBAsHCO9tp3pYsSQfpXZdemd64+3rmLSVpZXrt72UnhUCEMRsIGhRtUliTov1SrL0Dm13qLfTT8Zr44svXQr8CW3/t/fyTJqExr9edN6ZWepw8iG/2czY8lQnRcmGn8xEEFGeNPYRV41/k7lHwtd4Cx/FR35ME6CwC33TSnOLzy4Ks+Lf64PJ7FABVDIdjOlbjkOwHXI8klNkXVXuBhCGBJcVZWXXhQittA98e+C5xxK6r+VZbXcqxxtUn3wYViEsDDnswQLt9uc6aOtxJ8gIsiO9OGsyRGbYr3dkNkWQTNyLuYq6R5QGwiRHNAom+ZJzX2DLCXyAegrshHUO9YfkYLYOJmNfkgxLfuB6FgH7uAGvuD2q3/7+8gRiGxoUq2biLCMx6zVhsgbIdm0JJL8Veu2DLUWdAzXBH02AzuFDWQGgTH/Lgq+Tm3pm+RDl6n9xFar7qleFR04hUgSn6ct0ReDcrogOs/3nM0QoRzCV
 Ju28ScMX
 L7syVFpKHIfcctx73JMUFShTJLDhOPow0Ki/hmisRTdIBGxwFylxpRZvPiRtunhu1IKsvL9AmyXaWy5Vkyn8doJ7iYhrevtO1URZKWWxZTBxbJAh0JZpoKmKy7enVT1Wcj6OL1yNOS7p5ldsyNjmNfF4xveeSR7mfCY4RjJaqSxNTDkZ9GVzicRxErdRZl2KbwgrJS9tBBXAwwuQlCmG2d8cNSa865VrNo81pak+5d/J6iYz7WmVFxpmITNIr/7EEKdjN11YwVtDY+HZSSLqif0dFfjJMuJXsnxi3NbYoFuSfve1JjbcVgQWHT4BCyV5Sq0UV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 04:36:59PM +0200, Vlastimil Babka (SUSE) wrote:
> On 3/30/26 2:05 PM, Harry Yoo (Oracle) wrote:
> > Testing invocation of {kmalloc,kfree}_nolock() during kmalloc() or
> > kfree() is tricky, and it is even harder to ensure that slowpaths are
> > properly tested. Lack of such testing has led to late discovery of
> > the bug fixed by commit a1e244a9f177 ("mm/slab: use prandom if
> > !allow_spin").
> > 
> > Add a slub_kunit test that allocates and frees objects in a tight loop
> > while a perf event triggers NMIs on the same task, invoking
> > {kmalloc,kfree}_nolock() from the NMI handler.
> > 
> > Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> 
> perf_event_create_kernel_counter() seems to only exist with
> CONFIG_PERF_EVENTS,

Thanks for catching that!

> there's not even some "return -EINVAL" skeleton
> otherwise, AFAICS.

Right.

> Didn't check the various other definitions, but guess
> we'll need to put some/all of this behind #ifdef's then?

I'll make sure it builds w/o CONFIG_PERF_EVENTS and send v2.

-- 
Cheers,
Harry / Hyeonggon

