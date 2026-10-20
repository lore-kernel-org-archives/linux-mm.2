Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E364606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 13:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lFTWJhfX
Received: by kanga.kvack.org (Postfix)
	id CCADD6B0164; Tue, 20 Oct 2026 09:58:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7CA56B0165; Tue, 20 Oct 2026 09:58:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6BAA6B0166; Tue, 20 Oct 2026 09:58:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 94C066B0164
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:58:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 219D51A017E
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:58:33 +0000 (UTC)
X-FDA: 85343159706.02.EEDF829
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 86C7E40005
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:58:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lFTWJhfX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792504711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IBGuiP0nGAo3Z3FpbYxcVYUnONq26JoesatN6Nk3lmc=;
	b=rwk94zthd8Hqdkryb19mEjcRoBz31vzM801Z2v7zawKiSg7KOTmM/XXJnmNhnlRXqkJ7BQ
	+PbF3H0A8mLR16KTUUHzBHgqtxiiZOvNNFygTrOmvyHiIueGkQIOqeWsMpQBNcJUSNKf6F
	zC9FlP4xjWpuIZ87HELNVaU2Ak0PLp0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lFTWJhfX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792504711;
	b=Vhwaudel46TETG5JpiUQ9ACy+UrIiyFmpfz4767MLECPOQgh1AOZ76GICGO8v3JZ/b3/OL
	LwZhAntSeORU0nu9ov6lo62mTRMF1NstUG8wuCnqklN6qpGLf5w/AwtD2Al5/bxmN1F+A4
	LL1jHeprEr1ei2IXRwQboB9zb2BYsH8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 79CD34342F;
	Tue, 20 Oct 2026 13:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C82D1F000C4;
	Tue, 20 Oct 2026 13:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792504710;
	bh=IBGuiP0nGAo3Z3FpbYxcVYUnONq26JoesatN6Nk3lmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lFTWJhfXpNhqkTYblYQE3A8qbRavY5KXYaF1+xBzq1BuHNn44ClyG7RVJNYgH5s1K
	 2nG3zF7BQykI5QG858eRRKzmhyerFraTYWkZ81LI38ORlg5Y9dCRRdSKWlKix2TyZa
	 Pi2qKnM/QraAXsrmK34Dvq5Tj6yZMluzp8gAydyP3F0L02aVQxNEmFXWUSW7DqCiEd
	 S+3jj2tUirDxTyehFOpEIG4AfYrrZMGbyw0HEtTs8WoAnAwzfDKcCVY8/F+IpxFAOj
	 9RNiI7hBGls5SxXUxRqnLOAgkh0/3stphXA3E+n5tzBUotz/SSK+s9dPdUcRTDzMZP
	 atu4Lz6Azjbkg==
From: SJ Park <sj@kernel.org>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm/damon/reclaim: allow disabling watermarks to force reclaim of cold pages
Date: Tue, 20 Oct 2026 06:58:21 -0700
Message-ID: <20261020135822.85334-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261020133233.3920818-1-ruanjinjie@huawei.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 86C7E40005
X-Stat-Signature: tozdtknuyizrcjnfcj1ewktotn8puniq
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792504711-333445
X-HE-Meta: U2FsdGVkX1/pxb10oLKjNuWKGex3gTwO90Fl6oTzlk7BYNhnOdZjtQcOhw39+oFp1ZQFrsxgSME1PPnDj97u95Dklr0fVwJq0GYiM9Uci4/e6nJsB4snZ1yafT+/tS2njK1G1iPFxNl4wq+lG3gr0oo567VGaR4PfHi2rS/fVy44l1WY+5nwQDIexrOn3Mq41bAp8BqtkR2m4NatZI/M6Lut/P+1sna2x8HmkVL0GmFDcum8cLqClCn5cTXjnl9eJ3ki0N0O/dFWft3N6+vSoVnOmileo1kWUv04f7CwvhjuDuWanIvlwPjN0zJAzXPZzgYD+wO3xk0IjhrvGVNenAsrjH3artGvTJLek5YBDkNYyWRapzlIk6S/gFO+pYHz/9QRGgGjC4aIo01P/a98dukcbdGAGaf+KidxduDR4m1w1JQJ1jeHdDwMS6lt42HKHh7qKB/k35hxgQVQaeLKWuaWPBO+GE4jPy93BX0T6nqrnMGoEdGZy2VTys3jKKAyiM5dpOMKZjfvz8Ws1o7WUp2lCPEcfYvKXz4g5Il8RurYS4oo47+zaSAEMZWK100bNn+5QPUvKFjDk6ONhgGHy10c55XuH9NU9rsMt1LDi/5sGIgD2wUjvz8ow3twDbFKkS9B5xGoDWCgb0/4xQQAhhZaYHX9krJ01DW7WNKXQejYVmjeouVurMEuO2KC4+LcLY9g3gK9mAezDrzyu+axxVfBWjef/j+RfqY5sSQ5ypTQifOKVJTLzNjF3Z3gkqsjnbADleRIsAsZv2VDvElsury5UpVqUH+rQ32+0Lb2f6lO/m8ycs2YfXqR42fKf+WoKnzzTpjwqo0oq8j7DBMqqBy9NqSTq8ZR7chIoBGNKIxcXBPiWdwRlWcxQuCPkj7o8Hudte+NLbyEqZ6BEcPhylttiS8JNHZa7EPPVKBE6fgRaWK4N0byATQ8+Blhfgwza9GSQDejxLgbqHbYnVW
 PQustEM+
 iaK5wHNriZmmKFmM1j6BCEujY2+5n6BCBy2D7g8unuVCIS8f7PP4TRFFJwS1wP/s8jEYB8Lbxn1OJKHCeulh0iV6FyrB5qtPs8vSDxm2FRqqfZOxqzV3bxcflkTwVt9qK1Hf/mV2a8GRRrcsnVgdM34oqmxQvJ5evQgxbzc9i9oJt/cxZrSsm7zkL8FfdSlhaCQueF15/SELyIXW6ahReWGAkPJdCht/PkOyD87x+4X/2eec=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello Jinjie,

On Tue, 20 Oct 2026 21:32:33 +0800 Jinjie Ruan <ruanjinjie@huawei.com> wrote:

> DAMON_RECLAIM runs its scheme only while the free memory rate is in
> [wmarks_low, wmarks_mid].  Reclaiming cold pages raises the rate, so the
> scheme self-stops as soon as memory looks plentiful again, which is wrong
> for a VMM parking an idle sandbox that wants cold anonymous pages
> reclaimed immediately.
> 
> So add an ignore_wmarks module parameter. When set, the scheme uses
> DAMOS_WMARK_NONE, so damos_wmark_wait_us() always returns zero and the
> scheme stays active, bounded only by min_age and the quota.

I agree there could be use cases that doesn't want the watermarks at all.  I'd
like to avoid adding new DAMON_RECLAIM parameters if possible, though.  That's
becasuse DAMON_RECLAIM is introduced to let people use it without complicated
setups.  We will of course add new parameters if really needed, but I want to
see if there is a good alternative.

Have you considered some other alternatives?  For example, could respectively
setting wmarks_high, wmarks_mid and wmarks_low to 100%, 100% and 0% effectively
disable watermarks?  Have you tried that?  If that works, how about updating
document to clearly explain the usage?  Also, have you considered using DAMON
sysfs interface instead of DAMON_RECLAIM?


Thanks,
SJ

[...]

