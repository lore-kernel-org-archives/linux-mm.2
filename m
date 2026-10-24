Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED774606A31E
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 00:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cmvIrT1u
Received: by kanga.kvack.org (Postfix)
	id E1D966B008C; Fri, 23 Oct 2026 20:35:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCF9B6B0092; Fri, 23 Oct 2026 20:35:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBDBA6B0095; Fri, 23 Oct 2026 20:35:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A8A726B008C
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 20:35:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1633C1A016F
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 00:35:13 +0000 (UTC)
X-FDA: 85355650506.11.EF8297A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7259040003
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 00:35:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cmvIrT1u;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792802111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d+HNJ4xMxnEgTTUQcyEb0YV9rSrW2aczwrTwMqYQtlI=;
	b=CezitpNweLR4/9H6/gErchOD3IcTNdO0GkwNk2rFwY9aiR+kFF8C2mPfXi50fQBwM43uUM
	U31FuHxhKCxH/WqzJBRiDMAEWIF4EVYl/2z8rPwXsUkvwdBARaKwibFUNwd8BRVkJ5xSm5
	5h0aaWaIiNNH5GD8yrjk5RKsbECyVos=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792802111;
	b=m8TIGTPVioa2v/8y+xmeuwhaBnCR2XeIvxFtfMbwXhn6sotTuBf8KanmYghjVM+6FBMJWk
	E1LMiAn0fgJJsSJ6YRPB3dzNOf8LJ6Hofm4lxeFiHt3HaboDnh9NSdXJLpWBRibnfQCrdh
	le6znTEszCz4x/VpLgT5MocfG+sFRiw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cmvIrT1u;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 927FF436C8;
	Sat, 24 Oct 2026 00:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0A11F01825;
	Sat, 24 Oct 2026 00:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792802110;
	bh=d+HNJ4xMxnEgTTUQcyEb0YV9rSrW2aczwrTwMqYQtlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cmvIrT1uP+vfGt8oq5aXJwbRrrFCuvn1u7jXRvf2Xs8Sc6u9/gmtT/Bcj/TfYtn5O
	 CY6U/hnLuxanrG+c9GuWxDUsPjV2zXa/pJ157TIqANKa3zghRvz7M2G5kebTppX5Eu
	 wSkl22zIrfwMZWQaGeWHmRIzUgWcVINsPkgkVQTV/xyWkU3e+tgiq73U9yb0GehyaL
	 D3ObsRXnx3LttwY8jM2zga/a51ExMomg7jX4f01G683b38e4erPEQuDDeIb1pcD509
	 Zpta62Qd8fE1/ny00/C/w2iLsP0+yIJVTQBQumGyHmNsPOaCEDAIwSXsZ8LhsfpOQc
	 3tHloDDnDBhbw==
From: SJ Park <sj@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uaccess: fix some erroneous kerneldoc comments
Date: Fri, 23 Oct 2026 17:35:02 -0700
Message-ID: <20261024003503.87171-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <87se1ww4ld.fsf@trenco.lwn.net>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7259040003
X-Stat-Signature: d5biw1rhwt7ptmxfumu3tm94698dk9db
X-Rspam-User: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792802111-745822
X-HE-Meta: U2FsdGVkX19HZTc0wXKSRNhY8pT0zgnt80pXxI1ymeKAXPyuGn8hjb/DtPImO3h/J2/WvsGPW33/8zu5qQCdqjkKp4dPCPEnwCt77RB4D/r5RuI1FnDw47WjGBRBzZTYBR+vecgxgenkDYHHhTcQ1CxPr/n8I6TwW+oecWvDkHVIobj1MIis9Fcju0UaDTANlDpUOpX+VaRZ95FG+gFUNOoWue77yIG4NQDcO8TotblaUegYdw2fxIxiOwi90irxpEssHv6apmfs/6YX5MSLzisUWkiHL72V8wPtJj5hJr3sD9oOPLHQkU1lhixAtwiqBH6woJFQ6eRFzbq11q7hT0xN2g3v14a1Cy07ydYPRaWK3BHDqHnl1meK+fdrSZ2AUwI1HvOEfdvx645wqe7zB0MRljD4DYxHLbF9exNhrBu8kFP5a1TJAt8Q3wV2AqR1onpOOJoSkj+7O0c5bufX+tFhj6LNnY0Zxdx38VqVA9N07Z7rtmrMoM+lhTW/YAtoUrx+UkIHR7OZ0vAbI67CvzMyns1+yddrsb5ffqzzFgmHNCi1nCtCUa4uVZqpX/oGNKmWsfwfP4v3dYsJ4Kv9T1hUAouKFZtKztzc1mpLBRxlxCmkfrV5GO6/4/sdnouOviXHP/8eJuVCCVC2gVv/6wLfHfOKkpRkCLui+hs4HbsfCHd6SZkMkasBdrjLTL1rgTYkVxAHGUkn/hrTlD5Ju3SU5PTTrKg+z/XfRtDmg3hIS5L++9/ya/3fNbeCYVa8p0MbNDBePVNJpikohoIoBno+xYWoqkOagLslel8T8v7wUPiPPK9rK8AR6NnM87Knr/g0/AX9WrHQx33TQD7D5+kJD8roXxNxXtTh8g5bDy0Za5SgO+I9QjH326nx46VHBrD9XVe5nSbLdebR2XPBHLXALy9J5QdYgUthTTIAbVh+ArVNxZfFYjwmhKE9a2yNkj/TSgsjBtq8rvjUC0m
 VS7w3Ayg
 0C6PMHmcS5WzLVEZupZEm6XAsxGW5RDPZArrk+aKh/o+Hy0jYoPh40gDLpYqElXxYJ3KZV5rALRbSGjbS0twoES7REdBItk41baxIAvJhOxJYeSCg8vtkaIa2O3gHSZ0/3DSh61rqGlbQoyuz4QyU1UFEexwnLwbDuyiBX26LHB/j5Vn9Wm21gusNnEhsxVx7ugawsAXjyxYPw8yuRMJqz+5tUo+LtPPY0jn48dDYWJP1BcLu9P320bNJBlfsz2s+IluTQlsU1prxM6Azihg1DLtbefNnGboOG/mC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 23 Oct 2026 14:21:18 -0600 Jonathan Corbet <corbet@lwn.net> wrote:

> Several of the comments in include/linux/uaccess.h generate kerneldoc
> warnings due to the use of "/**" markers on non-kerneldoc comments and
> unmarked literal blocks.  Bring these digressions into form and eliminate a
> number of docs-build warnings.  No changes to code or documentation
> content.

All look good to me.

> 
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

