Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ABB3C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 14:07:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 652C06B009D; Fri,  7 Aug 2026 10:07:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 603DA6B00A0; Fri,  7 Aug 2026 10:07:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51A256B00A1; Fri,  7 Aug 2026 10:07:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 312266B009D
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 10:07:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C48C1A1D40
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 14:07:49 +0000 (UTC)
X-FDA: 85074651858.09.79C121A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2CFE880012
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 14:07:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hmX4tl3M;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786111668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DQqH9N8cRtNFukXaAbTPupUZURdwJwhrhW3sLeMpOdk=;
	b=XTEb5Y9NtSfSKBk9GQyw8rfE1VqEadKYHuY3q/WsW/h0otP4rs9tm1PyBI+2TNOOPzv5Ua
	FMRcVtJ4TYQuJfK5oOJOKi0acqH8E4XMDCLvQdfCentWAULunrk277oihi8sfd7S844LEh
	iyBIWZz4o0/F8TlNvI4rIevEDOMtZYM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hmX4tl3M;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786111668;
	b=ulHwMpBQrLzApNIgVhtndvCI8LFpMgzxaGgGuGLtIdXRzugPWbcoik7TS+xoW3ozqvupAJ
	VY9pomUVdNq+13s8FglDbT/Ppns8eqghX3//7vHHrlYEeOksKLm9wfkfJUEMxISDilZALj
	44PjMikVp50PlAA8Ci0gQYdQ3M3w5+c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 69D5342AE0;
	Fri,  7 Aug 2026 14:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E59A1F000E9;
	Fri,  7 Aug 2026 14:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786111667;
	bh=DQqH9N8cRtNFukXaAbTPupUZURdwJwhrhW3sLeMpOdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hmX4tl3MKGsF9m/+hq1ZYLMiEusVyRG/sxJXQhGQIfDXHZ3aKnHgAAk5mLU8U4Evk
	 4B9xWCJIZoEU29h7oq3RtU2ZNw62xPI40xgq4r/sdkOUZqLmf4Emq3cxVuljcHYLEC
	 O+uE+ZWL1QB2sFDY+uxCd3v9YGArQBP7yKn9cdgLHihtM6SAj/vFscY1XkfiJ/f16P
	 U8B8w+RTVwp/G3RmKUJeFFcDB+yUlnBtWO4wNTCb/M6IpYZudbsWmq6bDMHUwefc/P
	 nTxWREoGIlCQ8gFsZ70ACBvApQ5bV7x5+rGCHL1lYtZwb11qwuXipVSWJsVqQ4fFRp
	 Cr98S2n6yIWUA==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/2] mm/damon: skip deactivated schemes in watermark checks and add fallback sleep
Date: Fri,  7 Aug 2026 07:07:39 -0700
Message-ID: <20260807140739.91238-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260807093526.183009-3-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: sijcsznrep7s66itb5umzyrw53zezz1h
X-Rspamd-Queue-Id: 2CFE880012
X-HE-Tag: 1786111668-552010
X-HE-Meta: U2FsdGVkX19t0F8NlcANeYwAFJtqYJkhQnvhgG522JzOzYJGFuhAeb1vXuqXT55VBarHeyge5IQGi/S+yzkXH5PDWFRas0BF3wnw1p6D9GZcnmSpUCHNhVjZu+Gbt9CDA8ujaE1ZMY/GRTIHuk/KU+UbRjOdhHwWVvLdtMseWpz83Gi4MIe8unAmYxBRfH+bBnBwMmHRfYdqHvz8lBqcHmDkkyYxPDhmdjL2+fb+uJLcYHJJO50xcG3q9nY2KPa3KfXtRUFW324+riYQDa3ZhXxoXWJbyxU1ZH3+Yl2Jojo6J39ec+5cAAZoKRCvCHVWQRYypzR47OgS3iwpL4GmAp4FJ3ipZp/ldY1fAUGS/KhICDoacA9N2v9tYNmL73UIsPqqUl4pxK4GfQnKrVur8lcM0ZOufVMaFBz0iocwxAbdTb1pU5G/5QGGGpujWviS5ytxb/D48LjrkqDK9IGjEaYlUaf75lQCYkSLq/VkI23SPXvMJNHtOJT4hFKzX50jRUFtA2JGumBFqateB9gdnqWUPS2xQ2ltJuGSXENMK4zdESLXuskOAfq6S2eFgVZQeNwHvV+niU98nu5BBGVUSPKsDD+cJi72O/5ulp8sP5IN8coOSClw9ydgY7T1sfQ/suJvaY2BfYtP2ZUdCzW6wpRETl83pW5XccXKtIbyBArB6VhcfAOCNxGvOx8lIrMRsGjoQPn7Yvuv9dsfUYp0SzV2/xNy7hWG9EQg4U82JarKXeK2jscSdNKKCFqdtcNnRyOB0enYXxvF0h8EoGme/m8UXXLjib+2YIiH3O2ndz3T58Qe3/1HItQtFtJkrAOeEBLNwUzAzyS2sgeRXPok7WY3Ff+VEN7OV5BgQhU+9/BC/06eOvmhgnh7DEVjOky3xw6essQ9JSDyk698EJaLTzKSZM9IdapGDXuJ8cUG9ESKtLo1iP51N/r+Me089lYwiE+371s0o5kMeTod69z
 UWwHlcHm
 Ko6lUk5p0teRdLCIQXZymV+11ziNSkcbEiZD234C7rcbApPBTv1A40CmVcKPOmmTLe5Zzvn/FgU/nFnOj+P0QQw9xkjq0TJu4RwYz1pgdPMStpJmSONLt26q4G5yYNz8yNBIDGpenCY8Zyqrm/SgwPSQGzxywn25EuYjNkBax6znMVzDo5hn1uekGmDd+m8tIix6bYFvVTNs4IRUAeG1pbkmwUP6tq7lVvYS+1Bj7JNNkAfE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Liew,

On Fri,  7 Aug 2026 17:35:26 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> According to DAMOS design documentation, a scheme is deactivated when
> nr_snapshots reaches max_nr_snapshots. However, the previous
> kdamond_wait_activation() still checked the schemes which nr_snapshots
> reached max_nr_snapshots.
> 
> This caused an issue - when all schemes were deactivated due to
> max_nr_snapshots, but their watermarks were still satisfied,
> damos_wmark_wait_us() would return 0, causing kdamond_wait_activation()
> to return 0 (activated). The main loop would then continue without
> sleeping, leading to unnecessary overhead since all schemes would be
> skipped in damon_do_apply_schemes().

This is an intended implementation.

When all schemes are deactivated by watermarks, DAMON stops monitoring.  It was
implemented in the way because we didn't want DAMON consumes system resource in
the case.  But, later it turned out DAMON's resource consumption is really
negligible.  Rather, it is turned out that it makes DAMON runs with stale
history when it is activated again.  Particularly, regions have 'age' and their
start/end addresses that was emerged before the deactivation.  Those are
meaningless and could even cause wrong DAMOS decisions.

We don't want that anymore.  For a case the user really want DAMON completely
stops, we introduced 'pause'.  For max_nr_snapshot-based deactivation, we don't
intend to completely stop DAMON.

Maybe the documentation can be updated to further clarify this.


Thanks,
SJ

[...]

