Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DF3DD3B7DE
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 10:07:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8A936B0005; Mon,  8 Dec 2025 05:07:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B62916B0007; Mon,  8 Dec 2025 05:07:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9F646B0008; Mon,  8 Dec 2025 05:07:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9976C6B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 05:07:42 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2698B5C0E2
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 10:07:42 +0000 (UTC)
X-FDA: 84195877164.29.4E983FE
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	by imf20.hostedemail.com (Postfix) with ESMTP id 278681C0015
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 10:07:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=Yq1FcK78;
	spf=none (imf20.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765188460;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T2q3qIpB2rZdmxgNfQrdMX7fXgjlUn1FNnbk0gfok3I=;
	b=bhvu/6IrfDp/VQCc8B+uPFwKkNyGWbQepuUBigHTAPPhM8NpFInbmKIQ6N9hzFu2PQNLYc
	MOOpBkU7/qF/TXNW0kU7xwOFldJRMGWOPjuwSFWjUYUgWTP/a2xvvUoWT/z4a8tGGnMn9T
	snJDZTcZLC/4gWzAOuLZOAogBzp5Le0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=Yq1FcK78;
	spf=none (imf20.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765188460; a=rsa-sha256;
	cv=none;
	b=MfEQuu3sID19atoCv8YSCVKFDU57swl2FdI8O+ZImEVTAym39At/fQUOeJ+LEzHYHaojF8
	mK+jLenYPJxJteUV3rWW79RwOZw2QoRFwsKaTSae3OIQOvSv1HZdrDNVtQfO0EjD6vcFvb
	jKkpF0KbU+fxpn5H3y8ZKgIkgH40slc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=T2q3qIpB2rZdmxgNfQrdMX7fXgjlUn1FNnbk0gfok3I=; b=Yq1FcK78y3w6nkgHfG8T/MDxrk
	IxPuchTO5iIOBoYJahU8xB/t/TBjpRAjm/4AFYdSRl6UIeQ11DcKzstMyYC6itiWWr6tdIPLP5Y7H
	oqkVhHPMfM+F4oWLKsC9B0VaLXpMAwRhWiAV1s4LEV2C3JSjEkHE7Kgc003Hh1bBk4X6AkWRoEpVW
	oT+77Xz6SycoycRX1c0LeynFqnbm7G1n5TtAHY42t4W9I1dP7Iese3Pe5JIL2yvuHdlvtUE0NKd53
	Oe9oqVQJa7G5XePlJlodhUKIs/7elRd9CSi08xcHHqeO66+yWWWAe3BmmTNtZmFjbpOl1VDVCQCzB
	svgD+L+w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48358)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1vSY9S-000000007bR-0fW9;
	Mon, 08 Dec 2025 10:07:30 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.98.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1vSY9N-000000004vY-2kGQ;
	Mon, 08 Dec 2025 10:07:25 +0000
Date: Mon, 8 Dec 2025 10:07:25 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org, brauner@kernel.org,
	catalin.marinas@arm.com, hch@lst.de, jack@suse.com,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	pangliyuan1@huawei.com, torvalds@linux-foundation.org,
	wangkefeng.wang@huawei.com, will@kernel.org,
	wozizhi@huaweicloud.com, yangerkun@huawei.com
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
 sleep in RCU context
Message-ID: <aTajXdAVYh9qJI6B@shell.armlinux.org.uk>
References: <aTLLLuup7TeAqFVL@shell.armlinux.org.uk>
 <20251208023206.44238-1-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251208023206.44238-1-xieyuanbin1@huawei.com>
X-Stat-Signature: koymdn3rjjbofxw693e1zbsj8gj99sj7
X-Rspamd-Queue-Id: 278681C0015
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765188459-834024
X-HE-Meta: U2FsdGVkX18OW/I6YgEjHdf+vrJ4Xnw28E3ACHr26/p4dTKzBHCFGqs7JsiNtxl93TcyqJlnHrf2ovwI7eseemg+zOBHYumHlzgsxJtq7fHJ4QOkWMIi4caxyDbzwzrWnoT97Vn2yca2FRqTL58P/PpHLEMzursGGeCdK9LEt7GHWBxqTlSY2Kci2bG9mrZ1cw4L2TFOLbBbP7jeZuZhWJILTnAhaMwP2mWxE+AdIdkYiA2jIhtZ9UT+EHZaPPBhwHIo5+9zoC1EJAf1PWphHtdwnXx6DT09WW7yILpDls4qd5QzaWtL14eSNbypwnyiaqBIvxtU2+/wVKCmkDinhbfBLx5St0lj7qafXP/cQdUyY47L8f8vjxnStIdsxinyHRU3CPMExK9hbv7IIwSYyq7XfxKfTLR0PZIZqox3LCUlGsEbpxmpt7tYUb6M7ChiEmnKWR3g7/SYQXNZ8WOiXDV4aYHw3XF52zBVRkYw8/dbhSOxYKMONfMCQCYQcxkrabPKpIPcmET+n7P57eWHbwtF1YKeqFks9LRJvbPfLwzek+FjV/XRCwUQe23lrTxqsYY5I6aAM+nI3j1KQ3negpE3r5UlmwqtCQtP3VUYob1hAe43v75R3KP74arRiVIn3M7wXUSHdyPcDlIG+NS/CbbWDqy7gvYI9OizgBQsrNy4mnSlQobfnvDg1CfnJw9faYxqkqNp3B7rTayelXHGFCZQ7bVBvC2KRatOBkrnqYfpVO9YAYrYM2nw+zFn9rusnl0VN2kd3kFO6mGHEQUim5QxaG6oy5A/Th94rLIioMFLEAlagejN6g/77hjQ8X43iNcLj7ROJlYuMieZ2vK4N53S0S7QOuUwVNkEeU9dOhH8R0OrY112g9WCQXsal8zc4F88XzQr7KUukJYsJkmwyDSA8ioOS904hlAThCzoLV/CIw48s9wCOK1LqzaO+1zVdP4S96A6hFNOUU/36+Z
 ApbFGlQ0
 0CUv3vfexQHSaml/vJwNweZu7yr1+Ji6JwUjkoavJwTavu4wHJKbNzdcYHDF/1+vRqmBwbC8/CIvXMbxgAOZMcoP8u3h7JRLnZ0/rpgegyRbKy2+ZL5/62oVWg6d4lUBYVw16KASdZ2mPYRHyJQHTRqbOd8bONJdDRc88dbRBLmsQ/pp/9QrZFn1spsDz5THyn7aOYKmBAGA2Xyf4AkkqkZrlMWjiPLIB8PbxEHj7rqpFep8dMMokMKjQyi6+QGDuQ8u7ilb9o5KAiwsS4TRyzt/DHeFusUspNVugeacCQaSvI/QGhW7OcjvCxOI9rs/NihSV6pqasMuZBdpJ8pvJRGb4egi9F6u77YH7CArh+Lot7T4qBMIrKG07Yt0cdbqZqMG5pm3TvUd6/LQxjAYWRsGiC1zZkmyDUG3ofnVEEDpwT7Lzrzuxi31EZbHuoUdEF5faBP4rMMNWRruq385kTqjTp8bRkAXU9w11N0RzFDQLnI9Jvzo5vy+pSer8QfJgQCP9GZDUYjMi/xL3coKNYtFzlhMRZyjSMvkbMcFbfaguH/Zw9u2ILOdPqEu/C/ezQxIQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000206, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 08, 2025 at 10:32:06AM +0800, Xie Yuanbin wrote:
> On Fri, 5 Dec 2025 12:08:14 +0000, Russell King wrote:
> > Right, let's split these issues into separate patches. Please test this
> > patch, which should address only the hash_name() fault issue, and
> > provides the basis for fixing the branch predictor issue.
> 
> I conducted a simple test, and it seems that both the hash_name()
> might sleep issue and the branch predictor issue have been fixed.

This isn't entirely fixed. A data abort for an alignment fault (thus
calling do_alignment()) will enable interrupts, and then may call
do_bad_area(). We can't short-circuit this path like we can with
do_page_fault() as alignment faults from userspace can be valid for
the vectors page - not that we should see them, but that doesn't mean
that there isn't something in userspace that does.

> BTW, even with this patch, test cases may still fail. There is another
> bug in hash_name() will also be triggered by the testcase, which will be
> fixed in this patch:
> Link: https://lore.kernel.org/20251127025848.363992-1-pangliyuan1@huawei.com

That patch got missed - I'm notoriously bad at catching every email.
There's just way too much email coming in.

> Test case is from:
> Link: https://lore.kernel.org/20251127140109.191657-1-xieyuanbin1@huawei.com
> 
> Test in commit 6987d58a9cbc5bd57c98 ("Add linux-next specific files for
> 20251205") from linux-next branch.
> 
> I still have a question about this patch: Is 
> ```patch
> +		if (interrupts_enabled(regs))
> +			local_irq_enable();
> ```
> necessary? Although this implementation is closer to the original code,
> which can reduce side effects, do_bad_area(), do_sect_fault(),
> and do_translation_fault() all call __do_kernel_fault() with interrupts
> disabled.

It's to keep the behaviour closer to the original as possible, on the
principle of avoiding unnecessary behavioural changes to the code. As
noted above, do_bad_area() can be called with interrupts enabled.

Whether RT folk would be happy removing that is a different question,
given that they want as much of the kernel to be preemptable.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

