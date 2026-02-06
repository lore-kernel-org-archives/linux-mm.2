Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 425E3EE20AF
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 15:39:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AC056B0089; Fri,  6 Feb 2026 10:39:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 659246B0092; Fri,  6 Feb 2026 10:39:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5859F6B0093; Fri,  6 Feb 2026 10:39:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 46A646B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:39:46 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E8F86B7310
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 15:39:45 +0000 (UTC)
X-FDA: 84414441930.22.DD00464
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 68DD0100017
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 15:39:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jMtjddz9;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770392384; a=rsa-sha256;
	cv=none;
	b=3m6auvB4vUeK0LhmnnU20Gm5dOGW5FgZPzVtKj2DA86GcahZBB0GVDRdSUMQP93ZZSibAo
	EZI8kZzMGhVTHs1vurFGgeCL32Oi6zT1UXwwMVnYmM7kYzzEYAR9Dau5g6ceCMbTmNG0kX
	pNYWuIUtijKISdhc7V3Leg32KyKodt8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jMtjddz9;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770392384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YrGY9M4cXXS96KX9gUvIi50yWxDo45tAIdXHDfT0ufA=;
	b=TUAzSF0rBPF8Q17ArrotQC+bmubIaCM1knTJ8Hd7u7qH+0NaNFjkUb8O4t4s98a5mCzxjV
	jswcSyOuE4Oi844iNPF9275Ugk0T+tBM6a2hw9ppe8KQM+Qd9HDUauTvc2KR/5zpnTGwJ8
	qbZjCn3JuehZuKHyScd5H1ZB3ns4drg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6428A60010;
	Fri,  6 Feb 2026 15:39:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA066C116C6;
	Fri,  6 Feb 2026 15:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770392383;
	bh=bd90j/sd92aTHdoa8ZXxYROkAssOxPPzV9TCcpN7/4A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jMtjddz91a+R+jFPilZwkdFBMlS6c4CBY/QXiK14FqTKlhaC6lIrzAb9esL+/V7mN
	 CPatgbnyQ8VHIxZon3FEua0y7JDCG8fb8WfJSAnVBEbcadOS1XwZJXtyoE9W8GWdUI
	 YcNcVtGqnsPXhMzOF7Tq7aQWX8eB2FjLcMIB0R3M=
Date: Fri, 6 Feb 2026 07:39:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: <xu.xin16@zte.com.cn>
Cc: <david@kernel.org>, <chengming.zhou@linux.dev>, <hughd@google.com>,
 <wang.yaxin@zte.com.cn>, <yang.yang29@zte.com.cn>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: ksm: initialize rmap values directly and make them const
Message-Id: <20260206073942.e37ce92b81f0a0c51a1f5b82@linux-foundation.org>
In-Reply-To: <20260206163850402hEblYPDgLSG4M7CT1ju2G@zte.com.cn>
References: <a1d5bb75-3222-4863-a24a-4343b25ca6b7@kernel.org>
	<20260206163850402hEblYPDgLSG4M7CT1ju2G@zte.com.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 68DD0100017
X-Stat-Signature: iz1b4je53tfytu995anht8p3c4ym3cw3
X-HE-Tag: 1770392384-120943
X-HE-Meta: U2FsdGVkX199lsMTxfot/ZcApJu32rxQW/eRuXD0NY0EoU9ik6fk+6BE3CJiJjBIr4BU+1unijXSCO9OjYHJj9cfoD41cvUzlxDQTKRP2AWeaYlUijzsfP5M4V2iaSEvLBUdajsUXopzaqLXdG11d99YyUn0H6fVQnHWPnGBkVozJvTpWd9xQE71v0Gg1KR21EX8B+/mzUzInf3nI38luu/w/PdsVKtzVXqBJS43ctyGGShiIY9CZE3dF5w55WsDDbvpoix0pnqS4Mg+aX9KwvrCUbN4bACkkBffaIVckNL8dCJVuJsshZdpZZOx7158XFGFUB6sgH/Rtah8PPCHYkMnjjcY+gSo0gY+tgLEe2y6P0X8dTfvTM0kv2muhUmjS8sKoEv2bfubUQN1jIX2xD0QBkT4GWBxATfIVljiJP1gjKbZ48uz+sq9xxF5SoPOQhdnFHLT7Q3kPxDU7BJ0pabbE/5+lA8zHGO/YHRUDGH6Q2xU0quQalPrtxOC8vqRHfmmgAjzmPkJQL8YIHnA+TYxYRwXgEwXtQFEGnAMyIwQIrJfYR0ol3WOA8FiLqmvPIrRcG0incqYB7H999laGcsUGgiptZx0acFOPCCFAlvp+fdfJNTiCLgqQL8KEd0nIhAltpNom5iiFnL6Yok2CXhtBNwf+8gUspXYtnnBSnT4aNbAT2KOX6+O4eo1e7TcKg0GSwvnKyyp0SQuhsMmNTifvLzh3S2VsjRSKu/T1A+CI2IBysExiH2KESPCoTcYpIXlPCHe5myuH5MBpnObgLeTcFLsGsNVh/XXsqy+cE71bDIMJPQnZ1RNp5LomDNPHNe30sk8miWcCYCkmCKMQLryHqYKn4uWPS2Am9NGYSHEmba9wzv+0zHeNw6JozRgHiHgbhMD+04H5C+xf53SrOQ6IIYDZ9pCmZ89Hlzy7zk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 6 Feb 2026 16:38:50 +0800 (CST) <xu.xin16@zte.com.cn> wrote:

> > > 
> > > Fixes: 06fbd555dea8 ("ksm: optimize rmap_walk_ksm by passing a suitable addressrange")
> > > Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> > 
> > The patch does not seem to be upstream / in mm-stable yet.
> > 
> > Can you resend the original patch with these changes included and the 
> > reproducer referenced in the updated patch description?
> 
> Sure, I thought the original patch was merged in linux-next.

I've recently moved the original series into mm.git's mm-new branch, which
isn't included in linux-next.  Because it appeared that the v2 series
wouldn't be available in time for the next merge window.

It is a wonderful performance improvement, but I think it's best that
we revisit the series for the next -rc cycle.  So can you please
integrate this new change into "ksm: optimize rmap_walk_ksm by passing
a suitable addressrange", rework the changelogs to reflect the
discussion thus far and resend the "KSM: Optimizations for
rmap_walk_ksm" series?

