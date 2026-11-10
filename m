Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89BF160A2600
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 13:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FGxENUEx
Received: by kanga.kvack.org (Postfix)
	id 805716B05B5; Tue, 10 Nov 2026 08:49:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7778A6B05B6; Tue, 10 Nov 2026 08:49:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 642676B05B7; Tue, 10 Nov 2026 08:49:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A4826B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:49:46 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9EE561208C2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:49:45 +0000 (UTC)
X-FDA: 85419342330.16.4DE69EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 06E10A0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:49:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FGxENUEx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794318584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kM24Iv0O8Q0JTUrX0qb/LBnPU6JMQXqIqVQiqBU/VrA=;
	b=yOtAEl1zMBenzWzHMcxXCLOs63KEbJdJinZ0nOhg02VH9IbdhKT+vfhAhPc1sHj3OwpXzy
	Hytjnqu6x+nWYIUKtlgoGQfy7E1lPEg1tJBzWvPJ3iwWe77Rq2IwUA5ml+vsDKgHZr3pMy
	ptQwaDfAh87KVk34BgtlH5Hcqwy6TZg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794318584;
	b=Ks1HWS7m0Dm6zku8W+YRJSKA4sTEDaElITpsN/8ve9O3Ex6keejdnH3JIpraszjBxyYC3s
	+OPkB7ch+iMl3Fo2Gz+kgTvJQ7NryJO+fzjhavoX40CQk+NiGCCzTFQR7dgVGaLuZDd6U3
	su/ne/bgn5/sgpkrRlDaHNoxA//Ev2g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FGxENUEx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EE88240817;
	Tue, 10 Nov 2026 13:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB781F0089F;
	Tue, 10 Nov 2026 13:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794318582;
	bh=kM24Iv0O8Q0JTUrX0qb/LBnPU6JMQXqIqVQiqBU/VrA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FGxENUExDJd15vnxkEJJOX9RFzx/yli0npWPMJNIfD+TXZS4mzFWYW4UssjxQKAgY
	 LUG1BRfLBAofJn0SGbwyr82mb4BNIsIvViWofIDjZYpFoDYFAp3ylSj1DL4Wq3Lfvm
	 jZSEk1Awn0SiCbl8jpkJA6VrVXxao31yIx4xDQ7ZwSt39p7uzjJGqN5Stv6XN+p1Wz
	 cthl7ukNH7qWaWL4FgcSl98mNRadY7vNiWB9t95FrklFFvnJi9u6VJxy+BzuyjshEY
	 Qd+sBN26cD200bgigwgEqeR3qGjnBTJO6Kq7sgujvelh5LAqaizjRMTlr/mG27bFPG
	 QMxhq0ls4jdag==
Date: Tue, 10 Nov 2026 14:49:40 +0100
From: Harry Yoo <harry@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, kernel-team@meta.com, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH for-next-fixes v2 4/5] mm/slab: fix a deadlock in
 memcg_alloc_abort_single()
Message-ID: <avMeJWO5OF4GBe9r@thinkstation>
References: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
 <20261103-kmalloc-nolock-fixes-v2-4-19167cfe4779@kernel.org>
 <DMLSN9VHK0P3.2A97046A4YXGY@gmail.com>
 <auo5G__ac1qA9JRs@thinkstation>
 <DMLVUTB5J1RJ.2QKOUW6UB04ZM@gmail.com>
 <6441429b-eff2-485b-acf3-26c3034910ae@kernel.org>
 <DMMKUQVDEM0N.322USN1ZSYMCU@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DMMKUQVDEM0N.322USN1ZSYMCU@gmail.com>
X-Stat-Signature: yn47rbwsu8kfy3t3g78uhda8hsi7me4s
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 06E10A0006
X-HE-Tag: 1794318583-294558
X-HE-Meta: U2FsdGVkX1+gyCcoa8Q1EZsExHDSl5HiOjDMFbjNms/BnkFM1l2qMVgtKmmIy/HQrcI0sWSI6BfvLNO0FLZHIjR3x+B9Tsi1Qy/vXG5YraqVFPp/g42cvt3hwFs6ZxlN1LWdAk/Jcl7xJCArwhb2YHA3rDY5i8kOZzIsNn/QfIfW70suswy3d+KcG/SQb86tPHAPzZKlxV62yPGUvJTjjtQ7dAByJjTWa5zndX/mPmEFtbZ9Tp9uEdiBHf7tPMkzrF0yKChWCk1JAq9fLOTYCFxS2ne7+GN9cn+83qf3BXvzC5duhihroNVVz8MjvPuD5zKO/9acQQ0nTZEBXC8/DxRR3uS3fGBrLdBWK4mC04kq7G19aq04cG6++Hty8hn54MOsbjVzTFHl45H0IG9tme2w1ru/YVkkazSFfWDCrynaq4nNmubym3P2HhIgzt4bsJ/LYl8QjDKJY/18LqDkTdvm7Bv8V0dpSJPdWZq4dSTPLWKv5SKnqqBBHWjN+j11z75OXbte1CTeIDxHgpClpINLoso/8QpGEwRisidrc4CSIbI6wE50RKqIPn7XnbrfEX+UxzIo8hjquu8a5FuTJ0fQZZX40eHGRCmR97PsSr9OT66JC68cYEKOL3B91gRDzHQ548C8tGCChcTswlXHwa0MI5hD4988BWueoks7fI2JsYcaHb5ctOzmszNbxjbOYhUtVufHYQHnqRu6DtpeqpJsP3VzzfPTgsG/fZ9jgJRVaI15OekrP48QL5MA7nxp25gZcg/JSt6V39Q040LpTPH6ng6/ngWiD11HgU/vlSnT5cWvGrWEHG5AkqWCSJcxiJkXNvKc3/36G3ruH6g2BP3KWbTqFvQECd2VsrJIvZXJcKRdr2vkOidLmjuCTJa0M8TWRUskVtyb0wHTsp+dZG4L5/EPdir7fwpC5vlf0pb10fOG9ZP97Y2UJ5OsETfwjE5PNS98Oao6K/Jvked
 iCjrs2H+
 qkJUo6tUh/XVmM7HhgIqaTxPWfcFZwnUKrF4iEXF7Hmzb/iuXGfwXqjQarffAsWtY01F/pI2T0uXuYB5EUpTpX7O5thWfW/pgBS9ir38MPhODBuudhvJZ41pfpsuGRO1BRq6P7gL+Z7EPHyyL29cd5Fn0JK159LSW/nHYYxxQBOFa7LvrOHFGSGH8ua17dDvh9iDajYe44g+BUfaD+iw/BXIeNIPpcneL12OzQEKiwm16OWbn+c6o5Yd8Q0GfKbUad9HNfr0oHKJvvBLpekFHR1+bYErVQFyzwjX+5znlg6d5KtE3QUQlneYylGkVgZDQoaWK2b70eFQ9qikm+4AbCuuFSlJaZNIKU6UeoihILcFIwpykFUZEKMQIJhNvVYlVq7cIRU5TbV9+RsTotGULQAn4Cw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 04:46:26PM +0000, Alexei Starovoitov wrote:
> On Wed, Nov 04, 2026 at 07:35 AM Vlastimil Babka (SUSE) <vbabka@kernel.org> wrote:
> >> I don't insist on kfree_nolock() there,
> >> but can we try free_to_pcs() before defer_free() ?
> >> Like:
> >>
> >> 	if (likely(allow_spin))
> >> 		__slab_free(s, slab, object, object, 1, _RET_IP_);
> >> 	else if (!can_free_to_pcs(slab) || !free_to_pcs(s, object, false))
> >> 		defer_free(s, object);
> >
> > Why not try free_to_pcs with allow_spin as well then, and improve
> > memcg_alloc_abort_single() for both contexts?
> 
> yep. Even better.
> The bulk side does that already.
> Like:
> 
> 	if (likely(can_free_to_pcs(slab)) &&
> 	    likely(free_to_pcs(s, object, allow_spin)))
> 		return;
> 
> 	if (likely(allow_spin))
> 		__slab_free(s, slab, object, object, 1, _RET_IP_);
> 	else
> 		defer_free(s, object);
> ?

Will adjust in v3 (hopefully by end of this week!)
Thanks.

-- 
Cheers,
Harry / Hyeonggon

