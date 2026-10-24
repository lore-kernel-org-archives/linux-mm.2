Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E638606A31B
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 01:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B025dT8I
Received: by kanga.kvack.org (Postfix)
	id F36886B0099; Fri, 23 Oct 2026 21:22:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE5746B06C2; Fri, 23 Oct 2026 21:22:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFB956B0BC2; Fri, 23 Oct 2026 21:22:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF9576B0099
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 21:22:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1679180213
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 01:22:38 +0000 (UTC)
X-FDA: 85355769996.11.D3D9EE9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 633CE40006
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 01:22:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B025dT8I;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792804956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wYR2M2iVhPBLmlpr1xOyUZypnHKQt/AYQu7IBgbQBZU=;
	b=qkm0tRU5RAhtgyITBH/gzimjfd118u0N+LH31jR2Dr8FXg3GEP6NUAm0SuoI6uw2j2KaPH
	7yHBrLNlbiwaREt0XTtCwXraiqwIC3Vm3Elv7X36WsIQU4Ucwf24AntwvJImeOe6vZw8vo
	BxLjYKPiP+ZnZHcoxnF6h7N7rVFKPek=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B025dT8I;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792804956;
	b=vVrWrei6HdIVPicaNmB6OnrGIz/5K7cLZaUgZuJyhlxfzN9PdTExJjbkA7u91ZSNjQ+dQu
	CpzVdbxYsu4KcRdlhP/D6ZQ3wmQ0yeW2VctV126RfsW+rH+ZWVkJrhCtRYssUjZdjH/FQm
	NpKUw9ZbR4vR9/hm0US1h/0HhSYsif0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9049043C11;
	Sat, 24 Oct 2026 01:22:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC7C1F01825;
	Sat, 24 Oct 2026 01:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792804955;
	bh=wYR2M2iVhPBLmlpr1xOyUZypnHKQt/AYQu7IBgbQBZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B025dT8IqnKo9J9ah00/inNxyi1JmmsDJJJ84SWS51C1yg2CHTP2TJ9S3DJ9/6Vn/
	 RQmLnqeHRn1yeUpspA5wQAgRVT9y1tNjL1JUW8CuEDzDK/JROD6+0inGu7yUMuiuFg
	 uk2qy+x7R2Y9P0ug92ptKFpmEd1YiZNGS2cCJ9qpN7oAo4G/+S6opzTkpb6ho7bnpa
	 A+mwAdsN1WsteR72rOzaIFWayrfMoQntkqSDKZLoQTgRxNAu/b3lAzylySiKi7+bB/
	 mPRUP/sbknkQuYdtSxDm3xpAyGogKgZ4KZDnZ5aIf39MgYzeOyawsS0CXYX6h2dNOH
	 A46vVSWT75AXg==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/damon/core: reset watermark wait state on each iteration
Date: Fri, 23 Oct 2026 18:22:27 -0700
Message-ID: <20261024012228.88920-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <179277129124.2.16132047926074873101.damon-empty-schemes@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 633CE40006
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3c7um7xjb7cekm9km3myfdayxzdz9tsi
X-HE-Tag: 1792804956-281595
X-HE-Meta: U2FsdGVkX1/3LxZDHOz1j9W3wvh8A8ukFrEr2v09gJFaFDpKw611IRW8c29/r6LcJmkeOnaUXswb0y0LKVgYTApuPPltyjEjdNJtTkw8+eIP4ib0hcvgoAFEexySo6eIj5fBRQ4M8TbQb3d0iaLxMe0EAYnFU7DWQsL94iErg4IFDlyCZxpxWACW3gBGtgvHsq0UMHGWP95HB2IpI/3NgA2k4RIe+AB6gd38Jw2IleaCYVvuIJAIJ1HEQs9rUsznhN3YWpfKyaLU885mG19VLZGvXLWTtW527a5XC6+OSJsYfMSbKWPpNmtAIdXc4NThviWPXFpivNFhkMDX6E2q0kx+DtfX4WgmpUaqMp/bTnxY+h0qqJOIzWe01e1smTrQ+SYfmu6Ya1Hb4bm3qgRdbmwr9MVyPQHxJCeKLvBZYhv6sxwTCkITjZRoVgiGEi9n9UIz7GNaEXlzJJH2A9BgPzzQc/6hsyGq9Q+Ys9dhXlZrlD660re1+2Gu8sUnQbzNmy/vhp26EonsYKrBYjYnHtnnbL9Y6Nu3CfwrbX38JJaWeIRmTZ26XsqSLrZf9BFS2dN23lOllQTIZoLOtVZU1JR+Rbk0ri/oaOOjRQB0gFgJw4X22ZMv2w8wfFJtBCvZxD3aq5xQ8CcFxsB9bsfMMKRt1kPVYagoKabvUlvi5a/szr5CKfbJXgloAFcPu3XQzzgBlQg3Cs17RxmjNAEeJI07yzWk6yH8HK4oXeIShgwL8NzHBPqvKtpsfbVkfuWR/Xvd38QJdDN2JwT+FIkpkgCwDpGbblDEXA3gjmlQzLXKFRFew0poqkJ1SaYFSf5zqWhfPZsPsQGXdf1QHJNKo5/7x5kbKelGnYBcFye+YVkfkxdLcBXEu4chZpmfIex53PX19VCGOCRexE85qQ0m/T+ZFsrw8ZHiQmE1OygXHRXKFNfrAXBt//Bwh3NTJ228wW0Gq6OgqKy3xBOTWfg
 RPlk6P7B
 X2HhtFv4YRMiT3IPf12TggMxXo0uMswrE0stxGCQKIVKWHB5bE/6mAOx7hm09Ew7NGYX55TZLWX0KyKeYNPjoWQfEc7qDqsBeFPkGhlSlbiQisAnBuc0GhbOm1OGAsbrNVdMxbIgEltRQtc4/wMFl1DaZSqo8IiZWMhDTc/VIKOYnLzgGnHh4mj/faBTtreCGDHcgGqV/WOQQ36cNFyzo3UpskwckM9de10yh0yuTiqLAQy+D5ADcFY5y1tEQU1qYRKl1dj6CrOV0dygc34i8oRwzHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 24 Oct 2026 00:01:31 +0800 Aveline Noir <jm5905938@gmail.com> wrote:

> Found while reviewing the DAMON source code that if an online commit 
> removes all schemes while kdamond is waiting for watermark activation,
> the scheme loop becomes empty but min_wait_time keeps the previous 
> positive value.  kdamond then keeps sleeping instead of resuming 
> monitoring without schemes.
> 
> Initialize min_wait_time and init_wait_time on each loop iteration so
> the wait is calculated from the current schemes and an empty scheme
> list resumes monitoring.

Nice catch and fix, thank you Aveline!

> 
> Fixes: 6e74d2bf5a26 ("mm/damon/core: add a new callback for watermarks checks")

But, this is a preparational patch for online commit support, right?  Shouldn't
the Fixes: be the commit that enabled online commit?

Also, this bug seems nasty to me.  Users could work around the issue without
restarting DAMON only by installing a scheme that has watermarks that activates
DAMON again, and then removing the scheme again.  I think it deserves to add
this to commit message and Cc stable@.

Fixes: da87878010e5 ("mm/damon/sysfs: support online inputs update")
Cc: <stable@vger.kernel.org> # 5.19.x

> Assisted-by: LLM
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>

> ---
> An x86-64 KVM test using free-memory watermarks reproduced the stall
> with nr_schemes=0 followed by commit.  The same test resumed monitoring
> with this fix.  DAMON KUnit and selftests all passed.

Thank you for keep adding this useful test results.

Assuming you agree to above suggestions, I applied  this patch to
damon/next [1] tree after applying my suggestions like below.  We are in the
middle of the merge window.
It may better to let mm.git maintainer (Andrew Morton) take time for pull
request works, rather than adding more changes that are not really urgent.  I
understand this series is not really urgent.  Hence, Andrew might not add this
patch until next -rc1 release.  In the case, I will request adding this to
mm.git after the next -rc1 release.  So, no action from your side is needed for
now.  Let me know if you find anything I missed, or disagree to the suggestions
or the urgency judgement.

Changes to the patch file that I made:

'''
@@ -8,6 +8,10 @@ the scheme loop becomes empty but min_wait_time keeps the previous
 positive value.  kdamond then keeps sleeping instead of resuming
 monitoring without schemes.

+The way to wake up the kdamond again without DAMON is bit complicated.
+Install a scheme having watermarks that can activate the kdamond again,
+and remove the scheme again.  Doable but cumbersome and complicated.
+
 Initialize min_wait_time and init_wait_time on each loop iteration so
 the wait is calculated from the current schemes and an empty scheme
 list resumes monitoring.
@@ -15,11 +19,15 @@ list resumes monitoring.
 /* TODO: move below to commentary */
 Changes from v1
 - v1: https://lore.kernel.org/179277129124.2.16132047926074873101.damon-empty-schemes@gmail.com
-- None.
+- Collect R-b: from SJ.
+- Add how to work around the problem.
+- Update Fixes: and add Cc: stable@.

-Fixes: 6e74d2bf5a26 ("mm/damon/core: add a new callback for watermarks checks")
+Fixes: da87878010e5 ("mm/damon/sysfs: support online inputs update")
+Cc: <stable@vger.kernel.org> # 5.19.x
 Assisted-by: LLM
 Signed-off-by: Aveline Noir <jm5905938@gmail.com>
+Reviewed-by: SJ Park <sj@kernel.org>
 Signed-off-by: SJ Park <sj@kernel.org>
'''

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

