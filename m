Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 816E5606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hcCpM1qM
Received: by kanga.kvack.org (Postfix)
	id 9229F6B05B2; Mon, 23 Nov 2026 09:28:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FBA06B05B4; Mon, 23 Nov 2026 09:28:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8386B6B05B5; Mon, 23 Nov 2026 09:28:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5CBF46B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:28:07 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E5AAE1608AA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:28:06 +0000 (UTC)
X-FDA: 85466613372.24.07474ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 56C68100007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:28:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hcCpM1qM;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795444085;
	b=yPsUYrGe0QGVktx6CeB5farb17+POliNFypLh6fFa9i9Hte7L1F/XawftaFDhDEg5u5Un7
	Ns4wSmk0m7NXYnJu9Hs61EQf9srejabDhB+2p+tYEjZ6yP4DNRHJtaWXvsFaRO2VK/GhPE
	1XkVaxDJwWYzgn8K5v0RAw0JfzWCKGg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795444085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kUibffDJu+NILeHG7932dLRGDC9WduDU2Wovc7T9JVU=;
	b=GjWDSnGIHvq0P8X8jCk02EWOravGrnTwET76XANkOII7c1O7ltqDlfQrrfyow70QNQTfP6
	ga3cSq5dneOZ1z874FSFAlmLeGeYHIynHt5h62LJ9F4bCdHRiDEkdbKV09kbTyFrQobahT
	4zCjKkqvqQacwzmspAdclQ9zLijfUmw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hcCpM1qM;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 98E62611BA;
	Mon, 23 Nov 2026 14:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A213C1F000C0;
	Mon, 23 Nov 2026 14:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795444083;
	bh=kUibffDJu+NILeHG7932dLRGDC9WduDU2Wovc7T9JVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hcCpM1qMfibR4i6H9L8GR5F8FivmKW6k3htnsn86kOZtVqPGRZzL0Hm3QfznWjirT
	 JbSkX87kAQJz9Qus6xK0zyANrpLzXt3imH2BbbU3Iejm+S1ftwt3Z6zommNMkCj67T
	 U+I0AjKC6y5iGGEb/rgWr6hl9pesr2famgSNsLVjexeyxfIHWX/ncfjMwb6elE0AC0
	 AST+AUhm+gt2ktMARJPMePwYwGbPRTxKjOkfdf/qq3o99H0GQFo1RbE1R+AkA44kzE
	 K56tDOM5YYswCVLcJqxNRwLbv0WIir8QpbHlPyOezQv3lKrERjcEe1hmCWm1pL/2nI
	 IYmbGYHxvBrcA==
From: SJ Park <sj@kernel.org>
To: Lian Wang <lianux.mm@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	sashiko-bot@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 14/27] mm/damon/paddr: support REPORT_MADE type probe filter
Date: Mon, 23 Nov 2026 06:27:55 -0800
Message-ID: <20261123142756.84068-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123120009.9120-1-lianux.mm@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 56C68100007
X-Stat-Signature: cw7a9frgu785ci1ehritfgabexx9yh8s
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795444085-314524
X-HE-Meta: U2FsdGVkX1/tSSmQ+WGBvuZzIwgfO/ZZjtFXGFn0+hdc9FDsGiAqWW9tcsuuIRsM2hkk4ujF2wZ0c5d7oY3P14+vZ17oOxrmRUcS8BG7w718HujFZjm/7d5gmZ/B1dQHtHunnEYUPL6U/oFQqJm7/F1k5KOWZtunJpIHMESk5gstbX5FIQ9T4DfNV5h8ljqu2wMaDfeZjZ5Hyig4qFE6u0719XP9SzZcPRsaCqnMDj4XoHVdHpUQVJ4FqsxHeMkX+WybLonDIbV9A+Ra/0bdyuWi7OU4QgLPpg7+mYZ2LbwDiR3LgsEtMZ/HisyqgcNq+1Q1Sr7JPa5m5tkgcXAy68cWrv3QFclPAPV8dBEU3z5Hi/QXlG+iQJPP+B/gnGe1yc3QEffgOy55TEhucl1TwEIykcq0tYaDilnZqYcgrj4vxqOWFw1UuFrbagOCOssOH4lkj4+x5GlODH3hSDnOEcQISRhKze5mygUvyLu0qug/a9gg4vR2ruPWn6N2zCL2KUMkrvPvQPUoryJQw4v1bSnuAxsyCP38SnPQBqSu5OvkiMYOPQ1BxzWbwJ2yuO1d1AN/JxbuafFd1UvkZ4knGmKRdBZcENIrffOazaZAyGZuN/Fp/vuotY4ZBvGdd4VCOJj44IFSysqmkIMuTBjPqZbmiOy0vOwfRjUMGcfHLscfaFTcfU4EQq4kAIbv2Ay7aB/vhHrN+qPMbTAnyxVBNHRCfLL6wi1E4Y2Y/pdVt8c2me+8zvc/o8LubcV/z+zBfaWC5kvO6MfN3TU/Ah2GF3hMUN1YTcCh3UJzOjMIU/huOb5VIV2YZ7Q5nkjw8H6L/Uiu4JckJCaU1IJRzxyPwXOVn10cnO0NMJ8+UOcj4mbWPybfzwj4YpKAnZKCr4qnbx0fIpSllx8I2ORfHGGZ7VLlvzYkdmchF1hsyjj/Q4Jmo/BXdctf9bes77QmwSiXZFlZlcsCtkwJyeAxsSI
 AqGmyMQR
 Uq5p6i6KyGIOMZ7UbvMOdMyqTbDLelKFrlmL3Kbh316VnE5JlQICV8r073/RwdbZ5U1ILVha2MYNRiZfaGKEJjrcBuvfSlW0k2EgbNiTclkK7u5lXgICt2BJ0qaSr4ignw1SdcURv2m6watEeXAQwzxO3GGoMkpPO2vxtu1hZk5SQUq0QrUE6AF1pW9mepDyklMKSVN3KZSzO9DdTrq82wtChXrhFBABQ5jqRr6AICUxzLU0na06i8R86O73S2Hit94s+NwmF47Z8cvki9DnAhuAqvsXNqSBUBEIXQtKG80h09xQFsZohXbkh6jsSi51Zjdfcywmowd56/UUWBbzNE6++hKZjGIJssiM4LjrvKZ0jAhsnFGgd4WXLSRdZApDyxFnELtYhCE2sDOA9dyYYFnB0oX0uA7Yiqz9W5IWBNFSOOAi7tvidHeRqGOB5LpPN2059eT7XP6h5Slg7tiGw26SxFUM9DRtyvlCAnbaISXXO39Wg6yCcQnFHDvLgCdP2zbXwrlgrA5I/Fza2+FfUv1UMkNda75+KPljv24HATdFhAPvNL1lhmadzSpXnNWiOK1dyR2LJocVaFlLZv4MSRJNlPnn2HX8GmdNW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 23 Nov 2026 20:00:02 +0800 Lian Wang <lianux.mm@gmail.com> wrote:

> On Sat, 21 Nov 2026 13:19:20 -0800 SJ Park <sj@kernel.org> wrote:
> 
> > +               addr_range.start = damon_pa_core_addr(pa, ctx->addr_unit);
> > +               addr_range.end = damon_pa_core_addr(pa + 1, ctx->addr_unit);
> 
> Hi SJ,
> 
> With addr_unit=4096 both endpoints round down to the same core address.
> Could you fold in the change below so the lookup covers [start, start+1)?

Thank you for finding the issue and sharing the fix.  The fix looks good to me.
I will fold in it.


Thanks,
SJ

[...]

