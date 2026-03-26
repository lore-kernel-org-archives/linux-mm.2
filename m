Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 784BF106F2EB
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:03:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDA256B0088; Thu, 26 Mar 2026 04:03:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C89986B0089; Thu, 26 Mar 2026 04:03:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC7606B008C; Thu, 26 Mar 2026 04:03:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AC48B6B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:03:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 44354140440
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:03:46 +0000 (UTC)
X-FDA: 84587475252.03.DCA798B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id C083140009
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:03:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="os/wDXFS";
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774512224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Is681LQUPsLEFXcKol92/hc1x3OPimV82eg87scF5pU=;
	b=lZgrDMSIJ3l05marEJ0FsWuBvRAKW5kdTIySoGf+MLct343lpc0SwibL9wlcWMvuiNmv6C
	uiZeEmB4rJbVHLRi38+lfU5zuNjvGztXzntfFFRwHiNQdm5AEXvSX8SF285YhYyaJK7bAa
	CYTMwWiYcknD0BPo5Pu8Ilkuu3zrSy8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774512224; a=rsa-sha256;
	cv=none;
	b=gdiH/mBiXCSS2oNZXoDOt8Fa8FZ/2b4EL5qL5sI94VqMtPFNN+tV4nDPWeIbePpbJYaXhx
	NzdLu45vpYA/X2n9aNSo/WX1pLBopEWOWwd4E4mD4LrwsK4Hun+Q618CAOkFruaMF5rM5/
	qGgTUN5K1R/8owV0EEOwRyTxQ1oVGfM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="os/wDXFS";
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B4CA243CEF;
	Thu, 26 Mar 2026 08:03:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FBAC116C6;
	Thu, 26 Mar 2026 08:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774512223;
	bh=DKaiju7quAHqvOs2yPxqnK5F5PmgaoW7tHK0lx36PCo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=os/wDXFSNf5cGkdYDdYXg+FtaXRECKlpYMQpgBxI8rX+fb660ekBz1FQww2/pKysn
	 nzPgl2UQbWbNUsZsidhTlI8ANZrBtLnFtpk4VY5l6WZVNaXh7sQ1U+TABDwbCAEPmO
	 9FYx9qpVym4MKxW66W1qs+PzCqj26+yLgFktqpWB31Nof1cnbz/eM4WO54JmQ5AKsn
	 wjmrUllGjz1XCwsdpZOX9NVYIEP1QWrcJ5cQiNYZATOSwSf34y19QBN6hWL3mx6OiR
	 xOG8ouJB4cLjtypYJxnBrX5RdFGNfvIG+anjn/CsG+3IjkvhGR0zMmKQZLCIFn3zQN
	 Y/rH1niF4neyw==
Date: Thu, 26 Mar 2026 08:03:38 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Wei Yang <richard.weiyang@gmail.com>, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH mm-new v8 2/4] mm: khugepaged: refine scan progress number
Message-ID: <de946da5-a14a-4841-ac13-97c06c5af543@lucifer.local>
References: <CACZaFFPfx=y5Fy+nwT8o8TA=W0QBfOvTqbJnhVPn8B95SFxijg@mail.gmail.com>
 <22dccc17-787c-448e-a571-23c7a9afeaff@lucifer.local>
 <20260325080930.a205fca9e7e61c4a793f5228@linux-foundation.org>
 <3cf94628-3c6a-43ed-9fc1-29bd5a911497@kernel.org>
 <8d2e809c-e4c8-4d35-a2ae-62777b6dfbcc@lucifer.local>
 <0437ad42-612e-461f-906d-6757eb19a8de@kernel.org>
 <CACZaFFMb_1u7ckb5+7=wWApOx-u5kBxx-+2Y1Cjd1Qad4kgHRg@mail.gmail.com>
 <20260325115932.d2841f29f318454709fd4f21@linux-foundation.org>
 <65853d35-718f-4899-b4e2-e0d339e57e5a@lucifer.local>
 <CACZaFFMXtujt89--cWr4Wnmeais1QU0afqRrNcrr6cFZp0rxAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACZaFFMXtujt89--cWr4Wnmeais1QU0afqRrNcrr6cFZp0rxAA@mail.gmail.com>
X-Rspamd-Queue-Id: C083140009
X-Stat-Signature: 7b3owuczc1tr3m6qr5ocqyk1n7yjzeew
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774512224-514061
X-HE-Meta: U2FsdGVkX19U4RFjABu1h3gEuMZdpSqRX+nmrI6TrRb74t49CvaHIjt2qh5Dlv2MGANXMDqz4Bw1tMnh54nd+4BLe/qIhuqw+HL/WP8s+zUlb9mqrCYVUdMGoJa5mEeFNJ4S6ng/8RcEhTrtGFZtbFxxVCLJUULNsq0Y1PTQyHsQu1QBX/AufDeYbpF6lENFAm7mdcH82ec9WDlAcoXIXkru39Oh67WDPvqYYyph4GilX1/yB/09a9WuIV361FA7pw5oLk5qQOisga7wrLOBFylr3RHVBwWJF29L81Q6XWOVQz1KSljbkyAh4PBWw/ieciUB+KU4iCzMwgXmNdspNEYsFfMrEiCSjQdN6e1oUPCUc3VQzlg30lSTNyDolkscEwa8VTJO7JJGgSrninpY9pVFeHGKxwzvCQk4fqe/0DtYD+SbCK/Pih2CtySNqbsUhuOT5JjBxJ50tvY790uo2Cc+jqomF1HcciEajLrsZ/hXzqdcnvzXNxw403fEykV2JbZcJxSbtAD/sHtXan3wleFj9V5xSXfMIUm5XMBSJkgqdLiA/VaC3Cs2DRm4WWgHib6VuH88eKtk+HLTJRl/cRysC1/F+Z/icQutlwUxZDLsjjdmmGLW5j6Xn9mpIISx7nIesy5ZIJnEVVd/sFbFgGlBbGQjs/elxN3vq+Ut8EAmZKXbx/8ancVANl5cIaKmC9ukro6SBxS1ATZgML5MHLmgerkFNiRRz/QdMPDNo97Ek3DLDWSIHRtqTwx7vQL61upi9mkvdxdqr1/Mz+6q5ZjBCZBngyCfiJyT4C5XGY1O5PsfJoac/B22EcXArTWgLG3IXG6oMC0NZbYnEYhkJLX7tvbb9d6Q2sy82L/wc7ykYl1IbcTbXN/tBqtY4StPSLssZsWOwwVtu3dPlW7WzjdQ0wfvgeXUHXNb9PNvoHhtpjIoMAMZpWGOJ6t2Oj63RRHtUkjJUaEmFQjLgeB
 vXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 09:59:46AM +0800, Vernon Yang wrote:
> On Thu, Mar 26, 2026 at 3:04 AM Lorenzo Stoakes (Oracle) <ljs@kernel.org> wrote:
> > On Wed, Mar 25, 2026 at 11:59:32AM -0700, Andrew Morton wrote:
> > > On Thu, 26 Mar 2026 01:00:23 +0800 Vernon Yang <vernon2gm@gmail.com> wrote:
> > >
> > > > Although this patchset is already in the mm-stable branch, if we want to
> > > > resend V9 version, I'd be happy to do so. Please let me know. Thanks!
> > >
> > > Depends on what changed in v9.  If it's a major change then I expect
> > > I'd drop this series from mm-stable and we restart the clock on the
> > > integration and review of this work.
> > >
> > > If it's a minor touchup then a standalone patch against mm-stable would
> > > be fine, or just leave things as-is and prepare that change after
> > > 7.1-rc1.
> >
> > I think he means just resending this for the sake of reviewability or
>
> Yes, Just resending this for the sake of reviewability.

Yeah then there's no need, let's leave this as it is.

Separately - thanks very much for doing this Vernon :) paying down technical
debt in THP is _very_ much appreciated!

Cheers, Lorenzo

