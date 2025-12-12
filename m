Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1FDCD59F44
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 22:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2596C6B0006; Fri, 12 Dec 2025 17:47:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 209BB6B0007; Fri, 12 Dec 2025 17:47:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 120B16B0008; Fri, 12 Dec 2025 17:47:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F19D66B0006
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 17:47:28 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8548713A878
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 22:47:28 +0000 (UTC)
X-FDA: 84212306976.21.136853E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id D6A3EC0008
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 22:47:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Okg+GZKq;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765579647; a=rsa-sha256;
	cv=none;
	b=Bgu5YUkEnrdqdNonZlGgZU4NR5PDscgKOgIgmwV5+FxJUqKD3snFEbVZ2LQL+MgGU+P1IF
	7Ev3PdWdbBRYyX/atbNHVGMyfHWUW56xVeHypf4qnxF4Htp6tRiRQEQXU946fBoopCLedk
	4ykBJFmiSVknF8UtQ3TRetY2qawnAZA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Okg+GZKq;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765579647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xZFs8dOIMHoNoD1srIapalVRBd3Rdyj+mezU3inrBS0=;
	b=EVZGxSCz4Z0EBPA7c8eyWuinf0S5UvpRAB6/QHKOt1HBMRGS9hx1QL9xb1ZHoDnxAsCEsi
	IyO4JuyfJNAfRhXXxu8IZ0mOzXg6+8fegTpEgpkU/S9xdgE0n0dMdCtaRP8wPCMN8wbTrX
	OXjzw0N1pLrHn36WVbRfAAgxXnXFTbo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AF55140265;
	Fri, 12 Dec 2025 22:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A64C4CEF1;
	Fri, 12 Dec 2025 22:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765579645;
	bh=muNvdJh95XvWZIrWV5VMXpKvKw41GsGGnqJ9f0fd/iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Okg+GZKqOGHd5KuaRLLXMIirPVwwfuiyJcDJSnPIMgB5xI7/pqhrhmHojFaeLoXhs
	 zNvQ65kgP1wyeoUBwlB+VxJugwwojefnlZbhtfkCGhn4u6Snmx4xYjkx6Hqy683baX
	 WdavakkqYhIgvWoA5qaITXPQOW8+eYthYvhy6xlahYwipnfdTkRzTlIOyRITba1k78
	 Wj0ayfFEheDTkw4GUXSOSmwCnxUvLTp+gTLNjC9QWutQJ820ANbsdd9avbglbLXR5p
	 8i5KXAokdfdNwTgXQ9MsF1WrFBVKHAfnsd2S7GYbKexysDAECIGOJpcEgH24ay06r0
	 m1EmMycwYERtQ==
From: SeongJae Park <sj@kernel.org>
To: JaeJoon Jung <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 04/37] mm/damon/core: implement damon_report_page_fault()
Date: Fri, 12 Dec 2025 14:47:20 -0800
Message-ID: <20251212224721.49478-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHOvCC6B1q+1TLEw5WAQM+E_L2tQQArgq=Hy5JZ35m4_H7s_5Q@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D6A3EC0008
X-Rspamd-Server: rspam04
X-Stat-Signature: q14wwwim17quio14bu3ucmrpzdxezo19
X-HE-Tag: 1765579646-302479
X-HE-Meta: U2FsdGVkX18W7fAZk0yzCpCZ6lywoJO9ieKYh6Xe3IR68Qp1asZ5aj0AwgDgQ6ix6B1K7pIyQG1QkdRQ9EMPkc/uXBbwCeM+5TKXWT3gllnZdquQsNfYIIYE8zlKcIIc1H3rhiD1fr6X7uiEfN4BMi3DcjzQXME4aquPXXQXd9aEDOQk4WaBaH6+di81qek5jkbIcs2fZigKzOZByblH9IszM8QS7l0JddxqB52Br7YmqqYNfGg2aR1Ee8jgcKvgz+AKEOktRoRFSoxkFyy6yD6pJjtGBvJMZdXyFr9Ys1f+q8a0BGHD5FKleRCa6T5/Y/YKqe/VDhaHXtkc18afb9G/uSKFD74Un0Xr2nM0bgFUfluzbEZbrkpUrAi5KzkfHdVPXgBM9Lr+kt5VZ/BVRgOfbFSU3BNPNiOkNkfj+AVuQ5aiLlxS6Gjk5CF0ZHLeEx7+i2H5k9eC2iWj2QZTCd4gaw94UHTkodqRU2ynRwqfohj0NpbE0r8Zhn58k81MjuRCT/wuyyE82/mVTAOlsndwJrbwFMhogDjMQwgOi5GcwVmhT6g8XArVKRbjkGd43poyg6aFKl6/y3a2MiHZozNLZK+zeSVoBImahouEtAObq88VO0NFrwNNerW7UJ6JCJq0cQG7DIzHkdSJstmb6a0CIO7JG3cqfrM3d6Af8ZGLRzHuGtYEe5P3oq55GlSCq1C4CQTY3Bityo8RgualaDDRghxnRDoZvTwpk76V002x1ykFYhX7CQ4ClUwU5jW98JGXCjOjW+HSz78AbwNMpVuk3ZmZWpu1VxPO1z7b740P7jYArVX0JDZX8Cb8MuHhsaXpHvqaEP00cvSk9jiYw7pHYrsdFoqZqvhHYbln2zVmwEtk5gBR69R3pudsOgP1Y8KVaaD4PyuvPT0ndiS8LbxFVyVj08XXhrNKKi7DywZeUlCDcYsDq2EljYnvvbGWx1HTWNOzIkf6E+qXOsp
 YbIrSvoR
 bOhTJMwIngeWv5AD+1+AqrsATFNQ5l6rlEwuxvdZwYY+iu2oBsskzd3oHEdnsGfqceqsAQTgaSxm/WthPW0wJxjMM8fAfa7FH8yk65lTkaIloTpJixcsy7ql9UbK2V1o7dgOZ0YGnvefV2FzTJpD56ls3q2PH5czmyUwrEgcZopsRSpEYGUT90EAVa1gGwtLVkse5nXkC2Wa0Jat/hP1pBlFISU2Cns3meAjGO6qoSmPkY6HuV3K1wzg4jU8VOQz2NFV966+Ff6Y580yIi3oWeTAlQCGGV/CGH/3jbx7vYZxYne0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Dec 2025 21:46:03 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

> On Mon, 8 Dec 2025 at 15:33, SeongJae Park <sj@kernel.org> wrote:
> >
> > Implement a DAMON core API for reporting page fault events to DAMON.  It
> > is a wrapper of damon_report_access().
> >
> > This is a temporal hack.  In future versions that will have no RFC tag,
> > only damon_report_access() may be used.
> 
> It's a minor, but git am throws an error when applying the [RFC PATCH v3 04/37]
> patch file.

Interesting.  I can do 'git am' this patch without error on mm-new branch.  Are
you using something other than mm-new as your baseline?

> I am testing it by modifying it as follows.
> damon_report_access() is
> called by damon_report_page_fault(), so they depend on each other.
> 
> #ifdef CONFIG_MMU
> void damon_report_access(struct damon_access_report *report);
> void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd);
> #else
> static inline void damon_report_access(struct damon_access_report *report)
> {
> }
> static inline void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd)
> {
> }
> #endif

Seems this is not for fixing a 'git am' error but build error...?  Can you
share what error exactly you are seeing?


Thanks,
SJ

[...]

