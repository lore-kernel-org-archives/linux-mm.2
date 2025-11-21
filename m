Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D49B7CFC29A
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 19:16:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3917F6B0088; Fri, 21 Nov 2025 14:16:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 341BC6B00A3; Fri, 21 Nov 2025 14:16:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2312C6B00A4; Fri, 21 Nov 2025 14:16:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0D7FB6B0088
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 14:16:02 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE83ABADE2
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:16:01 +0000 (UTC)
X-FDA: 84135569322.01.8DAB6BF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1DC23A0004
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:15:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZcVe5ZNr;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763752560; a=rsa-sha256;
	cv=none;
	b=CJGXewXKp4Su3zqlAbZ7zVepScsU86Uh34LXM+37kS8FTXRQwrP6cYBie0goUGlkTLN5+/
	p17dbTS98eLekUINc3FBZ08u3cbWibdKDXdOW7qEsJBwD8+TF07OpzdHTGi6bBLuX9wSfA
	B0eMX/clfn0oviz0jEI25LswsAobNb0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZcVe5ZNr;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763752560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vKL6JBLuGgynTe6YEPFiDrmT7xLvyogmUEo4BTmRooc=;
	b=zfrOEZP1O45+Z5X6uqjQR967AupPmtndBKUzbto2ukK9o07V8CbKVE9VkPt3duJSodwBpd
	M73Q+9SCXzD2Ebx+xhKB2eHrHrdkwErbqeXFaUPjHI4r3g1gCHGsd2nZnLLDES/Jw25lMO
	1t1moZ+jDqiGd8TtViVehtBzFu8iNpM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C29460177;
	Fri, 21 Nov 2025 19:15:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988B3C4CEF1;
	Fri, 21 Nov 2025 19:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763752559;
	bh=EOILtIomiYe9hohchBEBy+GQl6qJMp3iLrDFRuG3+y8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZcVe5ZNrDBSOddTRWpwE2GsQDkDsDhXEEC4HDl9P6Mhg//2P62k2vQ6Dmz1gtUQpG
	 IfwNfXnQIgyRSZRNMRQ97fqPQhQe+u/T5XwXL84SFByQetEZMlml+8S61dQivYdcLv
	 F0kcm9uO1JCj3DMFwaH63DIhgWqXUFQZw0HvtDDs=
Date: Fri, 21 Nov 2025 11:15:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, david@kernel.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org
Subject: Re: [Patch v3 2/2] mm/huge_memory: merge uniform_split_supported()
 and non_uniform_split_supported()
Message-Id: <20251121111557.78c60ba96f6478f08226d34c@linux-foundation.org>
In-Reply-To: <031D24A1-5E0E-4A34-8333-4DBA31987784@nvidia.com>
References: <20251106034155.21398-3-richard.weiyang@gmail.com>
	<20251117012239.lqm33uu4vl4y5zqc@master>
	<337CD281-F5B3-47FE-82C3-ECB236450F60@nvidia.com>
	<20251118033339.7rukw7vvjvlbj5jb@master>
	<51358ABE-B0BE-48E1-95E3-C778D1F44622@nvidia.com>
	<20251118103220.bd90932096d4e36f754de21b@linux-foundation.org>
	<2AD36673-231C-41B9-905D-35BAB4CF63D2@nvidia.com>
	<20251118140658.9078de6aab719b2308996387@linux-foundation.org>
	<20251119005248.ddlbhokgjdmlkhkr@master>
	<20251120131621.486cbccc8a713ddbd30dcfe6@linux-foundation.org>
	<20251121090048.3n25tjhusu45xpoo@master>
	<E7C2F025-4CA1-4739-8661-343D60D82F7C@nvidia.com>
	<20251121085034.d8092d312da961b23c33a22c@linux-foundation.org>
	<31B02667-2F69-442B-AD91-6C0A7823BA05@nvidia.com>
	<20251121103945.13934959041672e76dd34ecb@linux-foundation.org>
	<031D24A1-5E0E-4A34-8333-4DBA31987784@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1DC23A0004
X-Stat-Signature: y7y4dwjfayim6tofhyfexwrwwrs7de7k
X-HE-Tag: 1763752559-36955
X-HE-Meta: U2FsdGVkX1/zeSR6++G6V79l/KoVuaFePvOW49dS61N4tetEJ/syNzVe4EiG6VUUEzBaTKT54e+MLyUHRxP2kZNyb+HYzSLXPxZt2jpc1ks6veKhysCgzY0lX7nwdmcD8E60LtZVa4FkpikeBPVTMx1gUEnmxljvDGQ7wlPHPkiOGnJQPrWoay6Npkpee76a6TN3RMqT4LGTSTZU82IW9774bcPdGAASFqnxqqlQu8Ak1f9w5R50vzKd3qukcofMYUvbMUDDoPLhPzyuKgo5Hip2EHCDxHNpH2F3ouUoCPqchcadTs079GKR1j2kPngcNNvkAdEzI9MKah79JdljwlPvA4fexBqdcfVjXHG2s9DB/+NzzbVz5gxs0qp3Xa5PMKTirUbFV/MlAXbNuJ093X6LX6F8o45qKsoSnS89H1F7PCRGvcTtMISi7nZhHKb0MxdrtWAlXys8UuXERK8NlNEDjvSkXXNcuuBN2VSbbyflkdpnpwThB8X2GZOSY4m1Xmxp84TTENLHEuWrl94J2pacpqNi1KZm5r16PSLdBGHc2PyItLxIuY+tTCWTF0+GPXL20wCvnWaqCeVOcsn4+kVvXsnPhCj4ZbmaqkzKQOuy/0Tvjja+RuV4hvlUQ6anRLECLLQV2PELv8KU9eG0Uf0Y9UaqkWKQax1agseNEoh8paZheuT63eunR/5x330j9RnB5mDNQMR5NR5X9Y8CO6iwH/MNfw/ndAs1s3CgmwXF3pYFpUibZG0kSFAlpi7lz3HGMgfvSBKUtnKCXPokkEkosjdWZveRigzH8R+U+pAM6c02WJPSm+SigT04LaIeHMC8sJCS0d/+ngDn+hOaRNmIhlbpABkVKFfk7iwXEKYJFG67kCdyMGjI9SmiY3u+YeAI1Xb6FeSJj8C8K8yZwH+XTvFwvfAmbEbimVcpYxFjwULV0fV456bY9QVGnKM9di5waSCTIBHJJLexTd5
 XDqnKl9d
 LBGwljC63qFB0L78wG08KDsfyW0D+EJh6kFL1miXEbD+EP2aKY/R9JRyXonkU5Cc5E/TcDLIykKjZk/L6yYSwvy3aB1YXQECBEcsRq2zrAn9CecfrCSwXOwsEvOYnZ0HrFvzxkXjCFsoD8wv5yeXXH5MWjDlAjL22t+4NTIwMCgrOcTu6LcruUKWoJVtN2QLo5lslXnB30xkZhhaMbC9xWRE1H5EBGHwhFSaqD5cyhKLb65hjtNyz4k8BBMV7WbZm6OmdBEZTyzfku2H+k/BdX9uoMb9D4KKJUU/jY9dcCRoVpE9Y2BxLMBSMOsKWClLMgTqeMiuxT8sV+p2Zgu7s2lQdmUCmgtsLE07ZG6llJrsn3a+R1aTVckh+KrzoOhtyEqXW2I8Y9m/cdc6XuxCYtVuvtoJBb+X3F2k3I3ZOopfvybbZJq++aY7lWe+Lzc6rHqSpg99yj5HEpyHq5EJLrvohjQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 21 Nov 2025 14:09:39 -0500 Zi Yan <ziy@nvidia.com> wrote:

> >> Wei’s further cleanup patch can come after my refactoring by just moving
> >> a code hunk above.
> >>
> >
> > This is coming down to the wire.  I'm considering dropping
> >
> > mm-huge_memory-introduce-enum-split_type-for-clarity.patch
> > mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch
> > mm-huge_memory-merge-uniform_split_supported-and-non_uniform_split_supported.patch
> >
> > and
> >
> > mm-huge_memoryc-introduce-folio_split_unmapped.patch
> > mm-huge_memoryc-introduce-folio_split_unmapped-v2.patch
> > mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix.patch
> > mm-huge_memoryc-introduce-folio_split_unmapped-v2-fix-fix.patch
> >
> > and we can revisit after the upcoming merge window.  Thoughts?
> 
> These patches are fine as is.

Well that's good news.

> The patch I asked Wei to hold on sending
> is “[PATCH] mm/huge_memory: consolidate order-related checks into
> folio_split_supported()”[1]. The current mm-new, mm-unstable trees
> look good to me. Sorry if it was not clear.
> 
> 
> [1] https://lore.kernel.org/linux-mm/20251114075703.10434-1-richard.weiyang@gmail.com/

OK.

