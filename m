Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10C7FCCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 13:57:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0106A6B0005; Fri,  1 May 2026 09:57:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F04FB6B008A; Fri,  1 May 2026 09:57:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E19116B008C; Fri,  1 May 2026 09:57:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CE29A6B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 09:57:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6E1D241A78
	for <linux-mm@kvack.org>; Fri,  1 May 2026 13:32:52 +0000 (UTC)
X-FDA: 84718941426.23.FAEA2EC
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf10.hostedemail.com (Postfix) with ESMTP id 42A95C0009
	for <linux-mm@kvack.org>; Fri,  1 May 2026 13:32:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=jTKGB8Ia;
	spf=pass (imf10.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777642370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IszU0JG/WWa2O3f5MsRNZrb+ulmlJxnxUGQwsmnwYmU=;
	b=slOeBvP53TiZ3tcSN8rKoPV5RqPfARmnRFAGNd3fHd58+EluS1et0/NUyJa/XVU0mCCinh
	XNAnBX9gifxagjQuak3wBqt6xaL+P55dal1Np7VEc6Y0bl+Vouz4fSbBxggIFuzoBi1msx
	yIljtO243qzeGepbAn3k3sSJn9w9LAg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=jTKGB8Ia;
	spf=pass (imf10.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777642370; a=rsa-sha256;
	cv=none;
	b=FqJ7UaSIEWGmuUxIOU1n1UkxqSf4MO6f2meI3BSiosa78nDjvKWqx1qrWZLuO0jMKlP4DV
	nncYtCLckWsS0RDvJHWb0bmjwd5DwxrO4ipDMzRayULw3t6DFVZ8WF0jeqCKHtapcfbKiG
	nnkKHRB2JI2NrUzdQFQwrSeOIV+hkgk=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id ABB84C7B79;
	Fri, 01 May 2026 13:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1777642368;
	bh=IszU0JG/WWa2O3f5MsRNZrb+ulmlJxnxUGQwsmnwYmU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jTKGB8Ia7D3+Zec5q4aruW2aznDUx+x2QbIxrQuVAh+HqJGpjaqhURhOBdhrZQbag
	 IWI5DhN3gDaOvxMrnc27MCpjJCByfrwPcadWoUrn575D9wcu8ZvKMjWZVZYlBfomtK
	 3l6KDosr8VPVi27Gi5jVQsMZxMlTisX765e0Z9hk=
Date: Fri, 1 May 2026 13:32:44 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Juergen Gross <jgross@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
	virtualization@lists.linux.dev, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com, "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH v5 0/7] locking: contended_release tracepoint
 instrumentation
Message-ID: <afSrfOyn90vGC6ER@shell.ilvokhin.com>
References: <cover.1776350944.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1776350944.git.d@ilvokhin.com>
X-Stat-Signature: 6iji4pizsg6cteqakyxeszzoxjmyxca4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 42A95C0009
X-Rspam-User: 
X-HE-Tag: 1777642369-558731
X-HE-Meta: U2FsdGVkX18rg3YcAmaUyAjxWwqTDbEWdyaj+mARGe1A2cm0fqccSLU2A7lUls3ToilHamTdd2yZNnTbbBXR/KyIhZ1omAS7f0mGqAtuNu89jzUoO55cjMfuMjbEw4esowzftoxjvM4V2DnOFTHMqmWBMCfM11EmsSp2QuzCC2XjNyc96yLiZ6rYqy9ZzcSgPfzET71McwbO1+1k4XK1TyBQzrRCRYzA9S9y8eNG/dB1eNBHjqcg7Zoh3hpHkwav1uAGziBIms4O1glIwAzxnS+kPg43EEwXmhJKFSITfKfsLyyCgGz8IaHOb7KuLbqQo6kZN++ER3dXfDQfxaS4WcBvS7+ChmTx03xWwI8SHEJA1HXRCi61slmZN9t2Rc9lWQJnRCG03hpxlXJ6pFQ5/+KmQ3+b93XpxEZ8up7okhtlHgRVA/jupmrjrLwUHiozNqwIwSZ4TiPPQs0ydHVwE/eBVeyszrDtMVO3A60Dsv8rnXFSSYXGdD6+sNgbnvzeYY+h24eRBcteYX/IJ8dRxSy1DFDYtdLBRdUsnEL+oyr0xmIg52J54zSYESOxAT3+hFH0vcRKz+TEAkTEbNrxoZluFIzE+6FeVUn6DAFYkdvDkxrjJkhA3P0cjRoN22g6k3/FK/Hr9GeEm7uiThEppl7xXR/7qdXtY03z284QHJcw5OjI6r5ydfZiUbauVJslwg1XihGc7BUj+uY5hWwJZjQtu39eEgwPU+geIdior5JvHwTYxvH1mZiZygMonuRoRS7E5acsyiWR4UzKuEI6p5TI89x7DHCRzre6N3s9ih0NSLCN5On186+sHc2RKXY4xxFxvxrgsQeoaKm6Bvxxq0oLLV1+UBpw7jgX8G9E7jcvXcn+v7Y14j66ZXGxVXrP3AdAFCju4/liSG0AkxNzXDJTb+GzOzrOo06O7mZfML8QC4482IunoqadfORKlSr4M8zUHotzrAdhImi66MR
 vdPDL/JV
 ViPkX9ltq1+hhHAia9cwAb5aWWkNdmxY+FRJ0ADfzQx0g+OaZCdGVE5yeCFeIDuVDDAb7EUi0KtoEUwwnj0P/NsYurItNiVSB7TLFo8nTm0xN8zIAItaugWYrC6/aTyALd012jSCH7zgqUM5u00v8/yTNmYHe0PhFlu5aCMNDKUHZuNwS/qYprQVBj1YmDSs5siakUJ7+65S5umqdB1dzHegBZXe3hCrSCto7IQ/nZB/1hFMhAAC20plrBfsm56qunf7QaO12whXAovUX1dIAnJgmXKXsrg29zgxO9Hwe/J24d1Rv+7oQNgYvNfCT9Jg1U6bP3LLHmc0XGA/ls8XoDCuNcxvzN0oOLO/av4KtKjTlYS4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I plan to rebase this series on top of Linus' tree to pick up Vineeth's
patch [1], and send an updated version next week.

In the meantime, I would appreciate feedback, especially on: 

- tracepoint semantics across different lock types
- overhead concerns in hot paths (e.g. qspinlock)

As a follow-up, I am also working on an RFC to extend perf lock
contention to make use of the contended_release tracepoint, so feedback
in that context would also be helpful.

Feedback from locking and tracing maintainers would be particularly
appreciated before respinning.

[1]: https://lore.kernel.org/all/20260323160052.17528-1-vineeth@bitbyteword.org/

