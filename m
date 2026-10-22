Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 110C3606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 14:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AmZMQS6I
Received: by kanga.kvack.org (Postfix)
	id E8A876B094A; Thu, 22 Oct 2026 10:02:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E62766B094B; Thu, 22 Oct 2026 10:02:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9F5F6B094C; Thu, 22 Oct 2026 10:02:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF97B6B094A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:02:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 23354A37CD
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:02:43 +0000 (UTC)
X-FDA: 85350427806.04.E29E621
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 32E83C0016
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:02:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AmZMQS6I;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792677761;
	b=P6CDoYABzGTMHqjjmowpELmOLccVuaPpyZLGUXy4WRPyVTvBKlO6bKHxduJ7wxIQcUsgmr
	nL79vF0ienFdpB81dyn/Xe4Lmhm9qCQux/BGTiSNeqm0El+FSEKMcVxK9O9ojB9Y9Pwzqa
	O3pQIcw/+io8GvVUA/0enVM41EKitLg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AmZMQS6I;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792677761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sbNemcwZ2jC1Uc7605k/VmRdjgt1QXoYjX9veU4w4sg=;
	b=KNckhg2pnyI4zxY4nvpmefRVyDGS+XSh6gY/ZOUX5r5ENzEm6Os5knvPK80Qyfk/bqCtK1
	KMvHCrSlw41HtciNgbTAbzG2RnKJa0SZYjaBpmR4jztRr61c9IYP23m0Ujyx94qI/A6FqO
	MqTbwXk7MWB16Z40fgzIlhhXPpxmhRo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EABBE60A89;
	Thu, 22 Oct 2026 14:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45EB21F000C1;
	Thu, 22 Oct 2026 14:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792677759;
	bh=sbNemcwZ2jC1Uc7605k/VmRdjgt1QXoYjX9veU4w4sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AmZMQS6IkrbnfBT7rmh94KaapbRI+T4bPXW5CLrWD95W9hDFLpbSOXSkpw3xXQo/Q
	 JYxbCN3+IRkhfvwGbKgCVvGpsM9JFe3wWNJGlkRGMQA8ANaf9+k/k8xlBIbAcWnzPp
	 Gu/m6krdg/kpRdIkq5YulAXt+UH8IoI0/ZzjF63qWP73OIbZYob0g17timLVgd5BY9
	 qL1SDa2n9NHAzqyNmZU3icOaKvdcHz1y30fvMGOMzo/Hy1SlheQVwh6rxzfGOQ5vtU
	 IaQ5DJGIKcl9/aAKwhsqjbLGlEgU37FyaIqXZWnYggqAyaYAm21ybJnZiBUcAHUWfa
	 UUVl8+gih695A==
From: SJ Park <sj@kernel.org>
To: "Shubhang Kaushik (Ampere)" <sh@gentwo.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Fernand Sieber <sieberf@amazon.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sjpark@amazon.de>,
	Leonard Foerster <foersleo@amazon.de>,
	Shubhang Kaushik <shubhang@os.amperecomputing.com>,
	"Christoph Lameter (Ampere)" <cl@gentwo.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon: align MMU notifier range when clearing PTE young bit
Date: Thu, 22 Oct 2026 07:02:31 -0700
Message-ID: <20261022140232.93962-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261021-damon-align-pte-young-notifier-v1-1-d0365ac45b66@gentwo.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 32E83C0016
X-Stat-Signature: n9gqg9h7by8zt8up76jq5f3wfck3s18m
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792677761-100109
X-HE-Meta: U2FsdGVkX18Htcly+1HLZqbO1Jfsz86ztOzht2rNgnMVQ5MP2jr6mqQRnrceMRdQevAfmrJO+xB6gl5MQuerSfnCjBHlz5Q0FAXVu716ztccamoPETjLCJmDhN2asihH7eSdEncGqEJRSVK3OxENq833r/rL1gNOym8ZJSsDqWI/1mObTsHx4XjUS664X6M6AXEOFrLzoTKaHLNWYPQjPqLDk6HHvYgIWslrQwI+9dh74cR6cNKtVWvAnL2XIWzTN8xZG1Jfa+CZcmwYpaCWhkJsY4az9px+CRyXiagPZNzKzWPYbKQdRRZ9HkpESWHf9IFu3L3Gu3ClQgYhECgDgOsBONZqZ6LPboioyJ6xRJxttTcTtCbk1HwRKM8jBC6alnlZrq9jf8pdrTwK7oD7HYRZAA1lE9i/HOGh7WJ4bcp/QuQfFch4b3CuNq1sA52Inxa0bDtFb3BXxUFYhbBeX+lwfZrAJrdkxAWiLZ6W2hZ5FIJZNoihDntF6NNLIM9803vkhB6AilMrBY/WrUeAtdXiObHTu2gKqUR3CkgTHifS3F/zp6+fXZaxsJQNox0XwaLENIsD80Ygzn9EXKlNj6FGN9dnQ5EQt0XKWANTDWEtfaV/nLndeWNG/lPLLQsUrFmN7Tp7aByCOry7AEMxrH+z25oqxVaibkRBsaTT3imGoTmgADWmNU+uBSV7bbb6lY4ynWj7OtcJmVafmmDnj68sQTy02DPscFauXnc17UDzWEF/d+QM36wVe/8wUdkKbTLHYYJoPfPWVrhMJd4O6T3APO6S0sb7CfQvzBPuH/s5+yiTUhiULto2Tu7/O8TRJDFS6s3OyC/imE9oGLiyZ06tRzU16ZJwAKRvA+L3WWarPesdNCdc78fnbmht+/i56vW9iD+Kery2YyupYBAY8Q27tWfZlXMH+DkD4htl3+R/Jr9e/E3jPfS8aXyNi2HPBikOzF7lS4Nm7KmJyFv
 C45qNExx
 bEuN7cnUSVRuPgoeCMOfWntc4ApieIvt2CucIz6EyXlOL31Pdz6aq3ZFVHVuAtpMZnO6c6Psme95MI/RORdxL0daHDRkRgIk+myH7GZNdSb2KN8Io3ScE1Kk3IGszrbEdS3aXsD5HRRAHy5WUlt65XfYp2ptcr/QHLJBe2Qauk0flwsjAaumOKSV/08ya2LOStfi/5AF6qeevvqJZXt6i4pHP5dFy0v48TlBkhz52TTwyirbmGAIyZY5Cm/B9L2QH3Zqnq0+R60bv4oYnzy5n0xpQvd+Wxq7pj8XHG8Xi7FaSRHQxG56kaSXB9JKfVT/3Zi3a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello Shubhang,

On Wed, 21 Oct 2026 23:36:19 -0700 "Shubhang Kaushik (Ampere)" <sh@gentwo.org> wrote:

> DAMON selects a byte-granular sampling address.  damon_ptep_mkold()
> clears the young bit of the PTE covering that address, but passes the
> unaligned range [addr, addr + PAGE_SIZE) to MMU notifiers.
> 
> For an unaligned address, that range extends into the following page.
> KVM ages every guest page intersecting the notifier range, so it can age
> a secondary mapping for the following page although DAMON cleared only
> the sampled page's primary PTE.
> 
> Align the address before both the primary PTE operation and the
> MMU notifier call so that they cover the same page.

Thank you for finding and fixing this!

> 
> Fixes: 3f49584b262c ("mm/damon: implement primitives for the virtual memory address spaces")

I once thought if we need to Cc: stable@.  Because this is only for monitoring
accruacy improvement and DAMON is only beest-effort, I think we don't need to.

> Signed-off-by: Shubhang Kaushik (Ampere) <sh@gentwo.org>

Reviewed-by: SJ Park <sj@kernel.org>

I applied  this patch to damon/next [1] tree.  We are now in the middle of the
merge window.  It may better to focus on making mm.git changes pulled into the
mainline, rather than adding more changes that are not really urgent.  I
understand this series is not really urgent.  Hence, Andrew might not add this
patch until next -rc1 release.  In the case, I will request adding this to
mm.git after next -rc1 release.  So, no action from your side is needed for
now.  Let me know if you think this is really urgent.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

