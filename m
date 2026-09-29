Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C2BCCA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 16:56:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 090C96B0088; Tue, 29 Sep 2026 12:56:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 042826B008A; Tue, 29 Sep 2026 12:56:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E99AB6B008C; Tue, 29 Sep 2026 12:56:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C569E6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 12:56:13 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 380F3A0573
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 16:56:13 +0000 (UTC)
X-FDA: 85267402626.24.968A102
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9902A1C0006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 16:56:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HXMJ4rbt;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790700971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JObT0OREbGaoxND8X7X5KvjjaI/mO0enYNHTriKbuw8=;
	b=t4JlFF5DmKukh/pK1GMoqVfZuwEaCRw3k2Ln/I/VMr2gs7pAGB6+0NxOf7Y8giYZbUT5fb
	w9pR8dfG6wrTzfIGscojDp0dufOwSHTsM6PiVNZrb8d8wrqSjL/y9F5gLpwi9YoiVDFLck
	ty0CCPvsDtjhUI7dwobaOFMgmpppwww=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HXMJ4rbt;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790700971;
	b=RDbUOjHt4HKM/j0w3Z5Ag5yaYT26BJ7D2cacgSKUwddltNAGpUYkBzH572YmTDwhTQCUqK
	CHPmD5dB1u01im5Bwkx+eRqQFz1X75Y8JO1BfmVwhkCHq2kkbgU0CnMYt3w0bUilTjpy5R
	h5C1KaHMPoU1+9HGljQIOy2wftyjwrc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F34DC6024D;
	Tue, 29 Sep 2026 16:56:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80FAE1F00893;
	Tue, 29 Sep 2026 16:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790700970;
	bh=JObT0OREbGaoxND8X7X5KvjjaI/mO0enYNHTriKbuw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HXMJ4rbtSxjHcIVMOCN+vgFI1FVUqOnLCQ2ZEeXIyPnSSlH+OgnRdosevKXUItt/l
	 MoMgKYlJrjRUPMZBEiDY19fsS4W/tkgxFcO5n9CsJeWMQK7X1UrddnbzSPx2uCtixn
	 awYB2+tvvjI2XVI1XgS8XyUDBKU39mQubmPnoq4f94Le+qhRQvUc5Un+1tY6PtnTqI
	 JgG/OMqY4NrXNlzc19Ls543As+r/LP55URHCm7sdopJOHonVSsO/NdQkEQoO+equq8
	 NAg9jqUScgr6lE1EnUQD5+vIRUf51vmB3t1ZByGeDD5lumhZivPTH4KMA69fmcRQC3
	 jfbWsH0Gwl6zA==
From: SJ Park <sj@kernel.org>
To: Jialiang Huang <huang-jl@deepseek.com>
Cc: SJ Park <sj@kernel.org>,
	lance.yang@linux.dev,
	baohua@kernel.org,
	damon@lists.linux.dev,
	david@kernel.org,
	kunwu.chan@gmail.com,
	lianux.mm@gmail.com,
	linux-mm@kvack.org,
	mst@redhat.com,
	ryncsn@gmail.com,
	virtualization@lists.linux.dev,
	xueyuan.chen21@gmail.com,
	xiang@kernel.org
Subject: Re: [FYI] DAMON and virtio-balloon in DeepSeek's DSec paper
Date: Tue, 29 Sep 2026 09:56:03 -0700
Message-ID: <20260929165603.49436-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260929123241.1408414-1-huang-jl@deepseek.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9902A1C0006
X-Stat-Signature: 9ap1z7j5wntspra4k8kqm8aqfm5di8ma
X-HE-Tag: 1790700971-446334
X-HE-Meta: U2FsdGVkX19CMlXJgxXj53mZrsP0fCgkWbG6PUK8IbziBAEwgLZTVopuAYvbiapsp5UH0OG+pi23aetRFtOo13x3oyZKiF+GLkcZXbLqXTdXHcD/7BpLRwvIJqs0WIC/dWQrZuuLEybjcYljYoCpZ6QYLly0mGJsbcfSbIl5nB0RQKnQtNgajdtGO3Oxt1E6GzcY8yoIIZ29KDtloWscxTtAHpPQO3RlgGx7bGZRjoyObgLEOlCXpl2MmplTEu4AFwMzGvJitf6mlg9k51k0UDF2lP4dMQCZlL3uQ8ro/Se7Bswj9/GhWz0IVL+PSU+nm+LwRxE7F/g2W83+lSteKKrUY33ef69AvzLLSZK6LN95dIapvjMy8ZWAH+o36s611FXpPTZzG9g5+7pt9sZQzTmLk9VG6+ldPNqR85vHVknVkVEOo9O/nv9XLe0SeoUJ6EYn2VV8M2Vw9dzSVo9OZNcrW01fafR+43u0gqRCeglcdSZCcDHkTnmGByFbSA8E7gS31nnWspmHhQzzcdJSAhlE5Hj1gK2sSZq/aJ8ip5kZAKfa5VnrSYHNbzREyLDg2tVMjdsilpTJ7EfmKXFJx6KBT4AiakQr7khy7YdehIUGP7lSKakIq6S+hfgIH/576RFxSbPtGmbND0/JF8Pk8oEdBhedmSyMOzTvvaTD5biB0vOz2uMp3OAu2D3CRNE8+3AXiEqAvTLbb5+vgjWJGGbv5/8Q32ywSTVTkdroQq04GIxU06SOMV5ligY2IMJRUWd3bnwkd5CdptBeIRF0dL8p184jGZNpTee5YDS8BF6V0hIK7xP1xo2WAJmAaKLpS65EkYEOHBgKTpvv5fVi1mz/gSBJpYVJ32U/b9i2fsk7e4EGH0H6Z3/Dv+Eq3UhhDYgNo16mnDBMJGDTs5z/nulZ8L8P3GrfoccoXTRe0lRVJptd9WAHAJJdBukQdpSP/OIlM5IwVR6hpu9XimT
 DhWMt87E
 I/mXHaW+lDdmv1gCF8xWGD25TWQWF6qggEF+/8IpNf+CZkdkkC76Uy08YEeKjxqP2ijbgLsOAGXv7aftFwAvYke+iahsa8cpM0c7gZtCbFI6DkSXZP+DwyXWqJrA8tzzS5G4Z27dQXOSsixgxzUqHZS2K2+Pf9dNKikrTYM7bhpQ9Gib2rqIvnpzFRs402oLicKFxiNxeDtHnLRPqq+rTbeLvf/wapMU+UlDJ7nKOnuBVGGm+ZkR3GtMdMd+hY9iEyh2ltlpDU1dXXY0FJ0Pj4jOFulANoUnXBDETYzU9gHRDfpUlH4D/3TDIq+Z9fbmYpbHdXMrOgj7pMZf0r67f5WA1iqTHyfI8ATOXRe8j5mzJu48=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 29 Sep 2026 20:32:41 +0800 Jialiang Huang <huang-jl@deepseek.com> wrote:

> Hi all,
> 
> I'm an engineer at DeepSeek. Thanks for the discussion, and thanks
> to everyone working on DAMON and virtio-balloon free-page reporting.
> They have been very useful for our workloads.

So glad to hear this.  And thank you for sharing your use case!

[...]
> We have not yet fully explored how best to tune the DAMON and free-page
> reporting parameters for our workloads. For example, the kernel's default
> free-page reporting granularity is 2 MiB, which is fairly coarse:
> reclaiming cold pages does not necessarily produce free blocks of that
> size. We still need to evaluate how finer reporting granularity and
> different DAMON settings affect memory savings and workload performance.

I agree the reclaim-reporting granularity mismatch could be a room to improve.
As I also mentioned on my previous reply, this was one of the main motivations
of Access/Contiguity-aware Memory Autoscaling [1] proposal.  As also mentioned
on the previous reply, the project made no much progress yet, though.

[1] https://lore.kernel.org/all/20240512193657.79298-1-sj@kernel.org/


Thanks,
SJ

[...]

