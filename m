Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D9E4EB271A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 21:30:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D8F66B0005; Tue, 10 Feb 2026 16:30:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6872F6B0089; Tue, 10 Feb 2026 16:30:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 592DB6B008A; Tue, 10 Feb 2026 16:30:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4418C6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:30:15 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 028B01C8B7
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 21:30:14 +0000 (UTC)
X-FDA: 84429840390.18.775D9AF
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 13F59180012
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 21:30:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="BV/YMBJ8";
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770759013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CK8De2d/erFzHUPFoy/Rd9TefUOCN8ZZOFUkQMvFVF8=;
	b=s63aIzgnt+8NaDMiBTFc5hYug86F0Dx0X9FVGZt+ZO7i7+wEIkTp9fvwDE4Ic2Xoa5z7uI
	igQQcV9MpnlCHOiKU+iRgXDdUKNa71IjcLYiwg6jdiTINckLUrSpfk0SB6VPyhfG3BLF/C
	e6DKTu/c5SrBMYgL8DzeWFFN7jZFG0E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770759013; a=rsa-sha256;
	cv=none;
	b=Z8jXLo41mlQpaoDvL4xrZmlnqHhNvHCgBcFW4fVROoT1qvyDZ22cuL8UY56LnzceDt5WsI
	PThnzcyRvgiEmY8/0lgp5rYLRy093t75HqlS4gZW+KZl6aHW/3oj+YolF9TLbzgSRI3V5z
	UZTAiQN42QTijIZ7S8B9SQ/6dqmFsIM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="BV/YMBJ8";
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 10 Feb 2026 13:30:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770759009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CK8De2d/erFzHUPFoy/Rd9TefUOCN8ZZOFUkQMvFVF8=;
	b=BV/YMBJ8tbHLUhRmxOpeod2al3Nw3/i2930wbCeo3QhGqxsnaAq/aehMHreve5V9/y6SKv
	Uvdqlflz6eST4UOFMxPAK4JJp7hginhzTbgCbyd0J8jcJFEgJuJkMRB5RWlvzR+vaiHUv5
	4yCY8TKhivkjvGVbGGZsSSx+iY6C9Zw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrii Nakryiko <andrii@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org, surenb@google.com, 
	Ruikai Peng <ruikai@pwno.io>, Thomas Gleixner <tglx@kernel.org>, 
	syzbot+237b5b985b78c1da9600@syzkaller.appspotmail.com
Subject: Re: [PATCH mm-hotfixes-stable] procfs: fix possible double mmput()
 in do_procmap_query()
Message-ID: <aYui6BgekgRplVka@linux.dev>
References: <20260210192738.3041609-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260210192738.3041609-1-andrii@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 13F59180012
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 8bgnibfq4c36atnz9gyi8z138kb1kfq8
X-HE-Tag: 1770759012-672658
X-HE-Meta: U2FsdGVkX188nRAFBFTCArRCamLQ1PcugGU6xNL55/vf7SSkM5iVh6Ddx9vaZ1GqxKO/JXbce1ZCVKgFjNa1mbwAeBZl2gJol1RB5TDUqW8OXAI8M8WFbBUkNwMQCAHRBXSQSDd1n6HNnjaqHN8Dz9OWxrd3WNRJzkFllBLXoWPCgvNEpqltznnpTlWa1A7JGVHY1WM8DIjlthZ4KFx7h8NZSCCftkzLfDZLKocFRJqci4jWTQoZ9eFhu1w/5752m4RVLd4UUojHdGCqoZ4SV8JQMaCP8wMsN2NKezZFxKwCO9Rw/hxm6FVGkWnYAIJ0oNh2nGi8vnF7Ri8xpOFfBbBQ3C2clf/Z6YWZ+cHfBAKNvUrC1EezQ+25LHXNVhXhnMexxPmLsE94+zuemxRfcCk7f9a6CwlEn4Iifke0MSx4y3aBxUFZk+y8ydW1YvteO/U/nEotVECj3gdGT4uuEwcXgKBB36jHIWJ7w8tpsIvQv7pKh8I4XvSe/Q0TUSfrdqmjLF8okYBYPjDWn+rxek8+k0Y79FfrnUUVFa6l3Ie/6zHLzZzGPQVyleialD+YTq1HyN76uk4dgATnO//2S6tn/SeWy868NHdrW5sg9UJzVH12GIraGI6NSJdWY7jBgjcXeJK6nByWX1ianyGElmumG6nD/1c3V54BCnTN1gn68tNOci0NV+ll6OdghkQQxbVt2mbDuF2sGZbAoWt0rnBy3tAg75Vfz6Abu83cyDKJEgk2flx1Fvn4SgAq2AZ99kBF50sJb18TS7byuD+6zVSQqOuIuRkR2dUIOTfhEZZR8lo+Yv5AGITWyjmCVy+5zDLethyB6FGb6DKxpZUvo4o3CqhRggwF87QQZWbaz01CgsItmbWglnfff5LV0c3hSgusjic7qbWiB3pZnQRUrr3kdCa1i4Z5dXzrfY2n+M4JGSU1fxP8Bcf79aFrSV8D9tdTTMgoI8aMuO3jzcf
 EJSRxOoV
 lNbJVkMgdO8Yar0GVp050+C3gPcGZEzix+A8xB3y8ud8ARtiaw+JrhM3wYE8rCRBBQM0zFNEwIIoFqIBX57tHJIhPxzLpv798bUWfSasThfbAmOOR19ECDsETfhziuxsiA2sg3IV8KrRWtW68UK3Kr8HSZElUMF+tXssLx3gnmvpJlNeFB8Hf8rsfQAGlwTYvaYyOC2lrpwhusPeQyUsVs5kwJ+LecLXslhZ4SgZPFwXZM5q6tc7raLxKhsvyVO03PuUscK0Wff/+JbRejMV83z7gWepe4JwGI36gCZ1eew+crGp08ZfMDilPnEO5qOv11JUsMg9dJuNRvuJSr8S6Wpr3/I6LKJvP0j5hj3zI55XH0C5G2AIHc/uSvrR5PLpLpKTnXx2chgNH2xVkqL4kIN9kJ8vVpm/77P+m4k7W1u4oUKhIgu4XfYWnZUPd5koIMiWUmJkmad/cGtE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 11:27:38AM -0800, Andrii Nakryiko wrote:
> When user provides incorrectly sized buffer for build ID for PROCMAP_QUERY we
> return with -ENAMETOOLONG error. After recent changes this condition happens
> later, after we unlocked mmap_lock/per-VMA lock and did mmput(), so original
> goto out is now wrong and will double-mmput() mm_struct. Fix by jumping
> further to clean up only vm_file and name_buf.
> 
> Fixes: b5cbacd7f86f ("procfs: avoid fetching build ID while holding VMA lock")

Why didn't the BPF AI review bot didn't trigger for b5cbacd7f86f?

> Reported-by: Ruikai Peng <ruikai@pwno.io>
> Reported-by: Thomas Gleixner <tglx@kernel.org>
> Reported-by: syzbot+237b5b985b78c1da9600@syzkaller.appspotmail.com
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

