Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AC701099B5C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 02:21:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6A7A6B00BC; Fri, 20 Mar 2026 22:21:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C42076B00BD; Fri, 20 Mar 2026 22:21:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7E8B6B00BE; Fri, 20 Mar 2026 22:21:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A76816B00BC
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:21:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ED33E8B974
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 02:21:57 +0000 (UTC)
X-FDA: 84568469874.26.34A1222
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2C4CD1A0002
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 02:21:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ck2Vz6iE;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774059716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ws242O5xah0xoOzUmyRDbXa/fc9T7bUDmUjzPUeaeDo=;
	b=voe0Gr1FSToTH9JQ8udPu2tTPvOWepmKz7iHa9Dr+spIScVIbd4IKLXWVN6tr66yMpoEQo
	yNx1qGWocMqNieYh8HQDSrQHN908BU9D3qiiZ9qLkOTC+9aBOC8toQBScpPIV3FEe1SXRD
	FhiOcHRkB1eLIBRCVul3Nx83737tu5E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774059716; a=rsa-sha256;
	cv=none;
	b=focT3/HO8hr8ocN8g64XVoT9VWdJu+JUGCzPSAIiCn7AW2HTtJJkewgOw/ledW5i8JHj7p
	ZPSa50YxJ7gXFNJ0Y8AI5+HA8PHVMhkCkjOWqA3L5k6nw0BvDkBWfESIdVxBCHSQwEZqxP
	X/7xI0z4TpLvsKzCwi4cI/+NVmxOX3w=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ck2Vz6iE;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 30B7F437AF;
	Sat, 21 Mar 2026 02:21:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F2B1C4CEF7;
	Sat, 21 Mar 2026 02:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774059715;
	bh=Ws242O5xah0xoOzUmyRDbXa/fc9T7bUDmUjzPUeaeDo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ck2Vz6iEhaK6Q5BPLU95zOlkUyMZHVsCVcsQ/QCu3AgfEoL+k8ri/Lqo5NHpjLuFx
	 eiahSHamyqEBzIQLdplojEK/CjwMzfB6Eq6QPo/DeCkWyrIiZS0gD7OYIvgh6onRCp
	 0pHXWrgLNc6JIWfLF6+sUUlD0PfUaX7zV4qq8viI=
Date: Fri, 20 Mar 2026 19:21:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "Harry Yoo (Oracle)"
 <harry@kernel.org>, linuxppc-dev@lists.ozlabs.org, Harry Yoo
 <harry.yoo@oracle.com>, Nathan Chancellor <nathan@kernel.org>, Thomas
 =?ISO-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>, Michal
 Clapinski <mclapinski@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org, Srikar
 Dronamraju <srikar@linux.ibm.com>, Madhavan Srinivasan
 <maddy@linux.ibm.com>
Subject: Re: NULL pointer dereference when booting ppc64_guest_defconfig in
 QEMU on -next
Message-Id: <20260320192153.759d6fec57f04fb653a0dac7@linux-foundation.org>
In-Reply-To: <h5qax9x2.ritesh.list@gmail.com>
References: <20260319233745.GA769346@ax162>
	<abzKcGiRSR_E8lLN@hyeyoo>
	<7780a471-9d99-40a7-ade7-0c4594ac36c7@efficios.com>
	<ab1J9ODkX5iChu-C@hyeyoo>
	<7458d8fd-5922-4e0b-9cd5-91880282aaa3@efficios.com>
	<7a8faee8-0eb5-4e58-a6d5-ef711791e3f4@efficios.com>
	<h5qax9x2.ritesh.list@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2C4CD1A0002
X-Stat-Signature: 8ceemmkapiczud3rtzpiscz465b1s1dh
X-HE-Tag: 1774059716-581798
X-HE-Meta: U2FsdGVkX1+8elsCD62GjlXcYfGzyf0sAQ1npRdnlFE9hJJ1ekzoTjW7YYsgBBFnN5GgxLy9Dxpk/RBmrPjArtLsCL675wa2IkgewGAZRMkQYjCprlziKVrwhO8YgWhEuTHYBZ9ZOzt84RnTzeLVL1ETZQeLSvDrjMruC51iKfOnnpEhP30lXWswuolq2A2w/lUQjTbb/lQEBpWx2Xq6QJ1B2eKY+ZdmaBYR+YZwHIJ6ErRRdwo7OVznOBv1o+8RMZdjdNCNg8Zi7tH21A0PBJDoUsPjW0fW0jn8cJDV9smSd9KTDcdhJXTj8oeDHHNjwDQvPK+Qy5BP1i1fFuyjWsPYIY+Pfr4cxxwhfeo7lOQtekNNb3vJYu+j+KCjLyLFY55PAztC7B0Raqauo6lU/JB+uiX72x88bM4pN1FQl9PbCoAX3Bab+rau0BEdx++4lTXSov+tfBUFSRxygZJpzLoSYHULI5i0OEI0fer/V7kLmQsGIY0jz2EZTZwoO4fGT/OsqvJtpWefWj9GbcO3Y4KGH0vjJ1dYjq00EdDc2RzufqDcyc/WSijeVMpYZGb7WwZ6QM9A5cxwBz2nC1q4/gr3NUzp3BBcEAm9jbaf9zaHv9WJr01wFickWdB4/hW16R4HvAT0dZSy26Ol9mDLMjdlc3cJXSJ/OwqvsHYKPspVqj+hE+BZYpFXtQv384C8rdIRTo18EO2Otf7wZzeEjC2DEvIT8t6ItQ9EdRWm1w8zvZVgwEHOeIKAx0CaQqPlnxc4fwsLCrgRsYOykXCG14/WMQoMEQvBLr5EumFaRSG7o3YlN1PZ1mEU2ZInulJxsKh1OcKRUQ0Ah/j3LQnYSDwT9hGqUrMuhZAiwhIERyhL/yRnMGoN1n/j3lLw7lP35vMZsTY4lqPslCzwsbt/clQK5pQBjmmfdDHGNHWssN0/KH4akxt2ZrG+QyEc47IRoH1qiAqetVjEGcLD7C7
 phr4+7u5
 gb7JiLgOjO0v0Eo1wSjJiVvo6Ap9QYs5wPQnnaEMp61PTLEMUvBtyYWyyYccMEQd9AEN4oKvW6jcUoOTJTKQ40bXk9bJIk2HJpuNVYbkNBWJVCaNObK2gBhE8m9d1XPjL/X3w9vMA7Cl6CpHsEGQhfpGBmGl6oPNHG/S9skoBSe8m2K1VfeSK8zk5NCNlJkscy2r+mUNxsq1XE1r0l8v/p3I6LG/EOGXmhZEjtfRvWeDSM2nBlapTyDbkBEvEJlwC6rxToVtWlr6YweuB2nhxz0tLCpO8dglo5zzYG+ucMkzjfXiHTluT0fpuMvigEQKs3d/IbbtP/PkZTMU2EXhVUExJtsbYxbgUciTmY32zLprEvjKdl+ELugOgx263cpLOnr4I8c5Luo6DQ/cbGjiPWlvnXJ2h+NHmgBwV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 21 Mar 2026 06:42:41 +0530 Ritesh Harjani (IBM) <ritesh.list@gmail.com> wrote:

> Looks like this is causing regressions in linux-next with warnings
> similar to what Harry also pointed out. Do we have any solution for
> this, or are we planning to hold on to this patch[1] and maybe even
> remove it temporarily from linux-next, until this is fixed?

Yes, I'll disable this patchset.

