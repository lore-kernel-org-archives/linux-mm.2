Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F989606A33A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 16:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=etms+rmi
Received: by kanga.kvack.org (Postfix)
	id E10A86B05B2; Wed, 18 Nov 2026 11:41:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE7F36B05B3; Wed, 18 Nov 2026 11:41:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D24366B05B4; Wed, 18 Nov 2026 11:41:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4C446B05B2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:41:35 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 183EEA83C1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:41:35 +0000 (UTC)
X-FDA: 85448805750.07.4DB0DC1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6DDB1180007
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:41:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=etms+rmi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795020093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KpCOWgYItNRFdCHLthVjrjZj9hh3G9ExdOPVMRYpXJw=;
	b=5FnosxqBMj2KJO7yI95/pcNovzisf+xRDDy5vFIfGTf8R3kfwDynUsmwVSpNp4qgZ+z21u
	Mw7xHqkB/yc7oSVkXee6Uz0VkAp/zotg7QlYPzu5ZUIfZbGbkk4jLFmTMGFegf8lXE+gPF
	8STaKAYy4drEmAdf2sEvx6ngvcMaoII=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=etms+rmi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795020093;
	b=nwbyb4e8p4gUkLt9S6JAJnXY03n/4ees6Yed7EW4yx/U9DMnxMJ60ycIYp/iUMV0QjnVok
	cq0nCR8759Zy8OJIbfdv9CCva6VOElYk2q4uuqzTsVrjgXjAzwYHWkkIVEOAfGsavSb95X
	HriRYJNC+//vyAiQ2c5Uzpw8M6bvN9A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9581B462E9;
	Wed, 18 Nov 2026 16:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E0B1F000C4;
	Wed, 18 Nov 2026 16:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795020092;
	bh=KpCOWgYItNRFdCHLthVjrjZj9hh3G9ExdOPVMRYpXJw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=etms+rmi+8L/OLERxU+EOMiH1yzh7QvrCedbLLFvfyOXftr1190X213cLfSMIdQhc
	 xktDkWAsGluc5sjs6Q+0xPnu0cRRv8WL1LtgbH7hhvypFoq0KCjcNGSmDaySPjxe57
	 KSVCR2Ief3MVz6qMcEC3A89jIrfeeEJz4Oisdraf0VRAKp9ACtii9Nc+6p0hWsiOHC
	 cOA3QRG4XS4ZJ0/KN+/71smKz//P77MiR2wPC2xQXa/VFXn7cC4W+hKsihDTtUOf3q
	 FbeaJe4k0/kwhoD/wk2H7C/C6O6Lmm8fqXI0k6UkmMQ6tQVBRU1FPwwdFAJCOA/i5u
	 /z3SJ8YKVa3QA==
Date: Wed, 18 Nov 2026 17:41:26 +0100
From: Christian Brauner <brauner@kernel.org>
To: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, 
	Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 03/13] tracing/uprobes: handle errors from resolving
 the real inode
Message-ID: <20261118-beenden-wirken-halsschlagader-00aa2083c904@brauner>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
 <20261116-work-ovl-d_real-v2-3-90564c4ae347@kernel.org>
 <undine-1794965448776121119-595ee1289c37e7d3@undined.local>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <undine-1794965448776121119-595ee1289c37e7d3@undined.local>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6DDB1180007
X-Stat-Signature: 4huasq8wy841ruxb8eqd4co7cqw8ei6p
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795020093-678864
X-HE-Meta: U2FsdGVkX18n5F5gNUl5cjLxsohmVdEECRetTWVjVq+Vs6A13dkLRgekb/05LJZ4Ix+TfVC5u+y9ir1afx5Mb9VqrUgbUjFMiFrNNk3m8eW5xLuTt1V3KgfkGXAblBat87oM9HC4P43dxoqv00nRWsN9TI63B6afW5muhRoolbRDLWAUrjAJqtQnOTE3jrvqQCn23lKDwwgZBGZhJyZYk/jNc5Izr7I3W+cSL2naFZrcoNM2IjAcS09FZlhb4tg5cmuu8JEgCGGze7jB0JOrOsUSx1VLt8y10166qSzKpUaj+qpEu57ac+JjiaI47I3atC2qASxQMRsBRGTxCL5TF065byr+QIMPp9B2g99PPi5UaZbTrnCp+t0EOfmuEIKiC+pogvan+94ySXbqsXIe6wTX0dNeElx0zvwYh6GXeYu87GsHGfS/95KFrsRsx8IvYSEWQfkTDW8UwYd0Z56GcjrpjQfbIxK9Aw9n3bAC5bl214YPD48Wkj2/ToQYCTgf4O5wT63IqAaOxtzvyQoV8TlDg3Z91vBx3SIJ6ApnvtGnZGdDyxmzQ58tBlwh/+/Udq2EPhhpY2o6rLo6Enz/6Z57jpsqsd76OxmQmfyOAwE14JS/QUFGKCdIB1V6J342e0f8qDO+FrbrEJTxOoqyU4eN8uBIAjy57fTNgt9n12bcC8T9Z5w9VxoRnaV0b/laplujD4w/3QtQ9BQdSVA6qH1fu6Ed7xMNMGgUXfg0G9fBTf2bOeM4pnfA8ryCN8o6MwwTEcAUDPkHpyG2Ou09shDKuHvV7PRPrfsxlR6oiHsiZ24QWtAP3AJsr7n67tH9XpNaid9abypPfw586OKirxErEshb9To9YDo+hbYdUFdYo+aG/qc4T8MEPhRIO2U4PZf700C12GL4LpBlAOtLMxQWsNC5srX55szwmaf49iaFa1xCdsWpBAKbFr4jtxzi54jzixS8csTjTzY/MBo
 Boplapi1
 0lBLjOnXdgzdQd8Q5Tls2hcAZ64wGWhkM+Tt344IdUaIGjQpswxjnpkhw8CUNFFNKmKcQfo0iTHprlDN5G7NKQWK/WIUJNlyh63iVRAU1UrtXV+bggvwkPTawGlhPtjVVE1XZcH8vSmEKyub8lw8YEciKOU6p3spMJKFSissUB1WKfeYmPR9jCnpwbDlcYTGHeGA3yp3PMqdLZvsMg+Z5x6N6sVUtD9RHcwstPdKAwI1vq8dFdYwcte7aqVYk6NDoZg7GeEcJ7KDRn9HIEmAEH8MSFjD4fNnLts9AnlG1J8/PZ/4tfsPv5V8D7cReHObUdWjjg4HmrcMbWMk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 10:30:48AM +0900, Masami Hiramatsu (Google) wrote:
> On Mon, 16 Nov 2026 10:44:00 +0100, Christian Brauner <brauner@kernel.org> wrote:
> > d_real() is about to be able to fail for D_REAL_DATA. So switch
> > trace_uprobe from d_real_inode() to d_real_data_inode() and deal with
> > the error.
> >
> > Currently, nothing checks whether the data can be resolved when a uprobe
> > is created. The first resolution happens in validate_ref_ctr_offset()
> > under event_mutex and the last one when the event is enabled. If the
> > data of a metacopy file in an overlayfs data-only layer can't be found
> > the event is created just fine and enabling it fails later with an -EIO
> > from uprobe_register() because the overlayfs inode has no
> > ->read_folio().
> >
> > Instead, resolve the inode hosting the data once in
> > __trace_uprobe_create() right after kern_path(). That happens outside
> > of event_mutex and if it fails the write to uprobe_events or
> > dynamic_events fails with the actual error and a new NO_FILE_DATA entry
> > in the error log. The resolved inode is passed down to
> > validate_ref_ctr_offset() and trace_uprobe_has_same_uprobe() so we don't
> > resolve it again under event_mutex.
> >
> > Both functions still resolve the existing probes they compare against.
> > If that fails the existing probe can't be on the same inode so we just
> > skip it. For validate_ref_ctr_offset() that's fine because
> > uprobe_register() refuses a mismatching reference counter offset for the
> > same uprobe anyway.
> >
> > trace_uprobe_enable() returns the error and probe_event_enable()
> > already unwinds the probes that were enabled before.
> >
> > While at it, resolve the data in create_local_trace_uprobe() as well.
> > perf_event_open() of a uprobe PMU event registers the probe right away
> > so it would fail in trace_uprobe_enable() anyway. But this way the first
> > resolution happens before perf_uprobe_init() takes event_mutex just like
> > for uprobes created through tracefs.
> >
> > This is a no-op until d_real() can actually fail.
> >
> 
> Looks good to me.
> 
> Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> 
> However, since this conflict with commit 72d3a5cb0cd7 ("tracing/probes:
> Enable newly appended probe when target event is enabled"), please
> rebase it on v7.4-rc3.

Yeah, I had already done that.

