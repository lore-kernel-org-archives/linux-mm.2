Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5465606A33C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XiGp388F
Received: by kanga.kvack.org (Postfix)
	id CE50A6B00EF; Tue, 10 Nov 2026 11:28:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C942A6B05B1; Tue, 10 Nov 2026 11:28:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA9F36B05B2; Tue, 10 Nov 2026 11:28:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 929F86B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:28:53 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 267631208E6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:28:53 +0000 (UTC)
X-FDA: 85419743346.12.F63C0BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 878D9A0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:28:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XiGp388F;
	spf=pass (imf25.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794328131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jqTdiGrgVttSAor12rHHo7dssn/lkPOpavFY9gHvLGY=;
	b=5FRSkbGuh7c0h1KfyjbRbqKaOt0/+E4LjQ+J5tPmJuGcmSwXFzl29f4DXP5zpj/UXJsm2b
	qcb046CQVBt5frA/VHlEY/9SCaYBogKHU3wVhfhA3gaVOVJaU1m2Ikp/43I5Xbr2BiVeVi
	IoYvMx8QtiGKF85SjrvjqjKJYW7Ec2M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794328131;
	b=QSFgHlHRLR3LA8ZPaG95WLuC608YdOZ96kmAdkusal1RR1ONHbHKF9GgQ9M43owPpMB1c3
	J+hUt4HlOJHztyJtmdQGEl6hSS6QKiG6nTQsg927s77Zoj3gOtjPlwdYn43hA7Pnf6hSId
	s+sgZfkzIRHXFKicZoLKhFmqoHLYVNs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XiGp388F;
	spf=pass (imf25.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 103F863A6C;
	Tue, 10 Nov 2026 16:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58DC51F0089F;
	Tue, 10 Nov 2026 16:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794328130;
	bh=jqTdiGrgVttSAor12rHHo7dssn/lkPOpavFY9gHvLGY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XiGp388F+LBQoDPScHe38P94OcaRfL1I/7LCZEV9XQyhQBfrObBCRp2tOJVWf17CM
	 ajvv9s+2VWt9TLWlm/rvE2/TldaCEcMwPw2EVG+4CtTmOQDB//wCthK4k8z0VRolEY
	 3ZgxVclLmiFLksiVRA1czkoxbd4OcHnA+nfewp0+XKrwaKPgg/ljMP0VTbJq1eVGbP
	 V8qkn1egKl314eFeaajKU/lFCMsqTzA2aOzLE+3ODPs6a6L8//epSU8jhWx8CL4uQu
	 kuZV3NrP6f9tU1UjqTCwQzPsJI2kPFvCDdJSDHopBOxDsE+HsGG+ob83L+TRnTjOL1
	 pQPa0nsEy4gBQ==
Date: Tue, 10 Nov 2026 16:28:49 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Richard Chang <richardycc@google.com>, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 03/11] zsmalloc: return handle from obj_allocated()
Message-ID: <avNGMNpCP5rNT-Rc@google.com>
References: <20261110054836.1515030-1-senozhatsky@chromium.org>
 <20261110054836.1515030-4-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110054836.1515030-4-senozhatsky@chromium.org>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: aj4j66dqujcytz9fgmcctdkxkujr1ef9
X-Rspamd-Queue-Id: 878D9A0005
X-Rspam-User: 
X-HE-Tag: 1794328131-113
X-HE-Meta: U2FsdGVkX19/ZRNF4zHxd4awb5pfHBiDA2mNnZ6jpwydRLMfNT15ZRBPmJsVkvHttm1anM0MhJoFk2JRYFZFB2+6OnJ3qmbRjtPssh9N7+5dFExCy4eKAWnHWW92sz3mDcSvhpN5+D9oPz1AUfkorCoybY+vw3J7VwUOelXYUSpSFcuSQgkn0gbYZhyrI5vpcIxkuH3cWbL+Dvby3vjujeC0diUkmVIrEehfdyx6CSXxJU1h/jdnlm1pH/sfTRLQAIthBMltxa/fesrVUIJ2sUVl1n6c3aOgwchdymO7QR76Ebfhq4UvnYCn1r+bx9g2n8vQODl0v7KbQ44zNQZDCNqWargfrPkt4FrJLeViQnQVz3GOgQOO9uLMsn5keLGSDd6H96A9B1UQ1EW1oewLXLYscJZ5ZR6IVBPB4RFmM0z/KpuRZPDuQCLJqupQ8wCKKB+PcK+a6nMd+suZ0z2PA2zEmznQmLXu1vYK7E7VtIrCEftIRJliLgo2TXsMIdUWyXNJH0yGD1uxma+gLJtoFMg10tzh9gxBFwZyaCwnz6jAXL7jvnQ/1cJuXOycS7d7UTMK0npASvUTL8MfxbznMNds6CMGKzMIeuSCzSpTJBDLJuJnR/1xLhaDe4c2mDmUU+6G9NJI41tyK609UakJTrl4xMBJIqog2CApG0B9ZCvZqC/PZ+1m2MtrBPJalya5T9XlwqK6c6F4r4yHw1bj9/CDxV+605H6Fy0CXglrRVvsK0NGtp1Mbb6JtTB0QtXzZcQqdEogbtrGXsPR26+317n68C/dGzWvZ56jbWYKlgEMAz5ny3amHX/ImWJSIjU4vjfMFCXXmWjaHfnKJ9tOVxiTTy1K1YuQmOfXzwY+0s3Ve7rDFBEc9OssnJ+5G1cdIADajr5AsNtF/sqH/z8UyxMtzBEk9DcudDLQEMLV2lesQ+0s40CZMUUjhZyvo9X2rgF5h79AjYdFLAqnhOw
 Sf5zqNBc
 oENW3XHOxUxJpo9lvE/3WEqwKtbF7BYtW86HRezv3aArzpBBFrkRZoUgewl6UKOm6Fseh8N/8WcQvYbvuaPfyZKtNirBvQMqdXL50qCfa/FrE7yYm6Skhi9tApwPTS+gYarZkyh8F/M1uPqrOEFO3m2iGCfUiMT/9b+RCXBirY3xwmZpldjGjTX/ke1skbvWF+ERW7NRzUln5tlKo9gzTnM8ssWF1sYJCPgV5HHlYcrK5b6Ztbse0mctrSh+dVOW58UA9q+Xo4N7Ar5ho7N3J+mtC9rrle7RmZ0zFApJSNTVN+jQXlXOS3NK0JiwjsPhhrnH7wUq95geQ8ZaUPyikNiMKIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 02:48:08PM +0900, Sergey Senozhatsky wrote:
> Allocated handles are valid kernel addresses and never 0, so let
> obj_allocated() return the handle directly (or 0 if unallocated)
> instead of returning a bool.
> 
> No functional change.
> 
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Reviewed-by: Yosry Ahmed <yosry@kernel.org>

