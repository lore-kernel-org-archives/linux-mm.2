Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 601A2606A32F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 01:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l31FgM/Z
Received: by kanga.kvack.org (Postfix)
	id 707116B05B5; Tue, 17 Nov 2026 20:30:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B6D06B05B6; Tue, 17 Nov 2026 20:30:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CD626B05B7; Tue, 17 Nov 2026 20:30:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 34C756B05B5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:30:56 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AFC43A063D
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:30:55 +0000 (UTC)
X-FDA: 85446510870.19.90D0757
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id F3BA7C0003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:30:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="l31FgM/Z";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794965454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SYxJl/ui6AD3kajNhdADlMAkHr2mk3aeY3/59dkg6Lw=;
	b=hSxIPM3Qs3uo6puGi3xv2TwiQpW14gDXd5YQfmFGfT4GUnrZcJQuWpSQQ9JPbW4rMXaVLR
	aunzDpo260FhzD5TttfLPWIXxfG5dlyJZ94a4tSymyP3XmARyUIGXyVHUpzGK0S8fBzABT
	abri15SoSqXCOE0mVkKRJnqh/CcwK/g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794965454;
	b=URaBaiGR0doKWYSODmsFsJrvX+9nbpVC2zIkTouEmQxEbPLgaDZGggenUAc7JZIPmBd6xY
	RuSVZkk7b4IqQDFsg2f92239re/K8AMh9rufpEUmi3wfQ2aTBE8sxq9Z6n2ou7XG6N8nol
	raxwe1Mg79M3I3zJspeXSXvV7LS1VjI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="l31FgM/Z";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E939F4166F;
	Wed, 18 Nov 2026 01:30:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B061F000C4;
	Wed, 18 Nov 2026 01:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794965452;
	bh=SYxJl/ui6AD3kajNhdADlMAkHr2mk3aeY3/59dkg6Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l31FgM/ZjLtH40ctlLvybLwXbLE+3+wF4z5UuiB1y8c/cjf0fv3wl6rF6n8KnN00d
	 hnUYi24/uEvPi9j1PoaxJo7QXsbljWERK8J3Pc4lC1vUqjBjU+X4+fVvpxWLH6ghV8
	 WwnA3+sKuPJVToL9ZSeUx1LXDOnLQVOaY0Q5YZXLjWCI3q47MgE1PM/Bs7SEvvAzAI
	 QYF4ReA4rdx6/PLLUv0uxngeIAnagio6XTnN6OxkehL4g2143roOX2nHEbV9XGeF2V
	 3AHqznVQbcbhmgY0SdLmZPe8v+YS7UkwMFkXZoYLaUes5Q5QvXFmYbEz2UANpRbPOS
	 VU2pGfAAJOFJQ==
From: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 03/13] tracing/uprobes: handle errors from resolving the real inode
Date: Wed, 18 Nov 2026 10:30:48 +0900
Message-ID: <undine-1794965448776121119-595ee1289c37e7d3@undined.local>
X-Mailer: UndineD 0.1
In-Reply-To: <20261116-work-ovl-d_real-v2-3-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org> <20261116-work-ovl-d_real-v2-3-90564c4ae347@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F3BA7C0003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: muubhweaqzxcepqaw693xk3oowq7fu75
X-Rspam-User: 
X-HE-Tag: 1794965453-865988
X-HE-Meta: U2FsdGVkX19AxYoQ0qggnN+k3rzMSIBGr4KXFnrye3Ve6jADUS5itG06WNkTLoJ0if9LqetrOhOaPUYYloefJTFNyoFF3Nrr2uuq4MPfc9YflYY6eXoOxSSOgcMQrhpTT9aZGcT9WdLnkvPUHY68tGNpRZInwcAJcj5/dxOQJl0g1kGE/vVuNXfQ4FHvpZlVcR/wfeYxp4EQ6OLwFrDrRVB+6kWAWDA5I8YqAU6eSc+cf8wlkrgbQnot/cmFA7AMrRIisq0Rl6BeEV9iupnl/Shar/VUGR+YkFerfM6Z6jvNQ2HCEZ2GTiR0A1qnX5XWkSfjgsxYBfEKz47t/oRCIT9JXcjM9Rapyrd/G318jFuqH+IB/zlx+byQgwo93G+q2/tWbDy617ptGZggqo4qVpTsYiHWkiPJ1ciEagI1O9f0TiK8rYh5R8uG/7ZZZj6vSAmtWjDcWJAOG5CZVO3BEXXnHcTKMObUk7Ta0XfSWZVw/4B4VEFIhsMShwbomgaipg9mzcT0vCz3OOYAqf/nZbMLaYVsBo4iGwrgCTrGyDYrSIvd6HSyoGgwZZuFuTdvdkySuMcfFxsLvL+vNEVsZyJSDVGWoxM5S71apar1EG+nrjzH1fcV6xM2Kxwvquf6RNQXwzG/nWdjx6ag4BpY4HChanoj+fakxReOnVIeOPDY2vQTCRXQ2NeG0dA+fYzbBzQ43ZGuJ7KRTjSub+gKsokTvsGWXsWQCXPQEkhEncTA2ArhhkpyQo8nXvy1zlM7yY+Tq1e4peup8UWUky/viyvV21da819Z+/VXA61Wg5gvLMYkOfnL0xSBBnb8PRAGB50Q7COJr+knbjXbx3cCT0UvvPRpA702VnewkWE1a11exk44L8B1YAHD+Lh8B6T1mqiiRyu0AZAwhp9ogN/U55kFDlXNPqlSR056tTIuiNc7pjvpdHLLyRsbgxVkq2hjOXiWI7cNExYTrtPrQSX
 UpPc2+Li
 kolhM1xnLNf6BKeFfPvH5O1S5Yoy0v0FezLFqd54WJvoUTxQXm/PUR8xCoyE/MJ1A9rwwsFCES7DlCNy19I6gsHPiH0/3v4c0BK+sdQZcfr/k1zR8CElUd52eUwlNERMh03eN7yk2PHo6WgM0I0yEplpvf1MSHxvq7IlCAUYu0ZM1HyUdmfiMhjhB10EbzSG6WBiQ891Ou2VA5QtCxXHm+g/vH0RF+UgjxTDk1B3b5iu+PSk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 16 Nov 2026 10:44:00 +0100, Christian Brauner <brauner@kernel.org> wrote:
> d_real() is about to be able to fail for D_REAL_DATA. So switch
> trace_uprobe from d_real_inode() to d_real_data_inode() and deal with
> the error.
>
> Currently, nothing checks whether the data can be resolved when a uprobe
> is created. The first resolution happens in validate_ref_ctr_offset()
> under event_mutex and the last one when the event is enabled. If the
> data of a metacopy file in an overlayfs data-only layer can't be found
> the event is created just fine and enabling it fails later with an -EIO
> from uprobe_register() because the overlayfs inode has no
> ->read_folio().
>
> Instead, resolve the inode hosting the data once in
> __trace_uprobe_create() right after kern_path(). That happens outside
> of event_mutex and if it fails the write to uprobe_events or
> dynamic_events fails with the actual error and a new NO_FILE_DATA entry
> in the error log. The resolved inode is passed down to
> validate_ref_ctr_offset() and trace_uprobe_has_same_uprobe() so we don't
> resolve it again under event_mutex.
>
> Both functions still resolve the existing probes they compare against.
> If that fails the existing probe can't be on the same inode so we just
> skip it. For validate_ref_ctr_offset() that's fine because
> uprobe_register() refuses a mismatching reference counter offset for the
> same uprobe anyway.
>
> trace_uprobe_enable() returns the error and probe_event_enable()
> already unwinds the probes that were enabled before.
>
> While at it, resolve the data in create_local_trace_uprobe() as well.
> perf_event_open() of a uprobe PMU event registers the probe right away
> so it would fail in trace_uprobe_enable() anyway. But this way the first
> resolution happens before perf_uprobe_init() takes event_mutex just like
> for uprobes created through tracefs.
>
> This is a no-op until d_real() can actually fail.
>

Looks good to me.

Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

However, since this conflict with commit 72d3a5cb0cd7 ("tracing/probes:
Enable newly appended probe when target event is enabled"), please
rebase it on v7.4-rc3.

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  kernel/trace/trace_probe.h  |  1 +
>  kernel/trace/trace_uprobe.c | 57 ++++++++++++++++++++++++++++++++++-----------
>  2 files changed, 45 insertions(+), 13 deletions(-)
>

Thanks,

-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

