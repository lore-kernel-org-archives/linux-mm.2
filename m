Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D922E63FF9
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 21:04:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DF2B6B008C; Sat,  4 Apr 2026 17:04:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 980DF6B0092; Sat,  4 Apr 2026 17:04:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87E766B0093; Sat,  4 Apr 2026 17:04:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7681E6B008C
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 17:04:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 400DCBBAA5
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 21:04:01 +0000 (UTC)
X-FDA: 84622100682.30.B3091CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7651B180004
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 21:03:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l7gwgdGm;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775336639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cK5W96KGksJ+r2R9HxFQK4sshY94KqWEh1NWlcu8/ko=;
	b=EE9bcWqe1sStOf8tOkfcfeqcfLOSxWa4b2w5nghe34LqbwQTein9ay9uYA2Vvv0mTblVom
	mxU/xBPNHJTNhlyt4Dk4m7lH0Q0fNglAk6GMP2mqZwKjGLn1IsPHBrVI28TQrOdCx6Ad7J
	cqERktcUy7GIkwY9CLxcyTZo/lpqO04=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l7gwgdGm;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775336639; a=rsa-sha256;
	cv=none;
	b=SgBEJEEgLtthoaevhDrNWGkqM3pGXS8ayYgovqauyucBYmhwqep3Uap2XLuIjNPDR1Sx8Z
	er3Y8rGj9JbCw1GTks4k2huPS+j46ib48TNQCIg2Axk2XjSJspTn6CcjJw+4e3OhOjaKCc
	rtv12dbaeBTSPLsI1imn5ifqJ1l4SWk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 44D8643FC3;
	Sat,  4 Apr 2026 21:03:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8FAEC19421;
	Sat,  4 Apr 2026 21:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775336638;
	bh=iQs01XvDwKT3CkjOSudgaloppKITn+Eg0BEFKBlfobo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l7gwgdGmADNUUwD/aekEvGhbZcy9Gm3bBU9ogAusLr5f7uCqsg8fNcKswtJEYoulX
	 vPwa9EjkCwIDt/WkIPejq+XZ4w3o29502Ql3nDj52KZqzDenOlDcEtHRD/+No/SekF
	 rmVq++WQPi6tiwM1iOpqg/Q2pBJYqtNqyM29LZa/BM4ciEUo162sQ0CBEjSzr+FflG
	 P1zc8pUJpknk2dDuyRX+2XNpnkFToRrrfYCN66XtwsaTEkwCdXHpBslfZwt4iqXxRY
	 PdBlAvE+eAkRrMHfUMGJZY6XxgVMQVs4LGNT408+yakhfZvOgE4lGwep+FRj+tZ0jm
	 0GtVpvKNG1+dA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH 6/9] mm/damon/tests/core-kunit: test fail_charge_{num,denom} committing
Date: Sat,  4 Apr 2026 14:03:50 -0700
Message-ID: <20260404210351.87638-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260404163943.89278-7-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 6mjcikut58sm1q7ujue7ky6d4m3wcqrb
X-Rspamd-Queue-Id: 7651B180004
X-Rspamd-Server: rspam09
X-HE-Tag: 1775336639-865559
X-HE-Meta: U2FsdGVkX19PRcAxMWwVbwW+ZAjsP1pcocSMbjryrph/ot1B/K84+qA2aOH5FmF5AN/cW7R0WNiqbW1WcAlZ9frslwBzimsACyiiSHLiGVi2VNml8GIt4UyGqOJxO4qVu6dtv8s3vuwdxw9b3gTPZEAL6yf7Z4OLYQ7wzx7E5Ce2DCVjPwu5meSr9KCUc5K79yh9MPePp69izFrAFSmEcvvGFc/abr0QhVZ5VSpE1WnshnNyGeQlM+tnPpKw6jv2t0gRxAmg9cPf7u5YqZIFL6Ntjol8rbdwtZjmJmihTlmEyJdc2voy1qWquShtIlOS+IR8JmzHGXoBFR8BDFEh5v7ZQXofMIpyVEsztSVZGQyP4QANzs7PsBB39wkd6dFnZQF0gSkdUbZfrsAn2yWIb+RPDH1AkqyNzRSlWpaH5arH6MX2tpjNX0ba/egJD4HvWsuEaljotKsgwDbFaTXkRTHsTiATzPYfLrqURyLQG9w5WqoHgSxMHhdmLnZ3NBs0syWCX9vJORLgObtKt0nYSRW5FFQTirOo88F+Dp+8sTi+gx8F1WO/WYQdLVFcv8GS6zoRKYlfaKxk/W5PyqS5kHYwmXC1vP9tT+vTX0NKLI4zTugraAezhPYl9zc9oWRvBdvwsrxM8W/A8MwwzPRlgs5mjWSGU4i9dnYzTaTFJmmT7rHy6wZZbUbPpl2Gpownyvq1Luk9eodmg7tLF6ODArKzUo+gqnGTiQ3fIdhpPAu6/QAtob6g0RZfr1rJKetLmKcpRzlYl8ArLczQRTKf/gv5deGA/MiQt/unMsMC+xdu2mjyvPm52tvKFsUnnQ5az/PRgLFWlIofeUs6BZVXCs9QMmwhgV1AXmY/SA8v5tURRqrooLr3bg88BZkvKLfY9KAnGQ0P0gJzIfsdA62k8/YkZ0MPVONDhfJ45iRYvHljyLpRpScXavrtaK5yxHN1jK2LSPVp2TxQYQ8CbBE
 ebbPqLSV
 JSFmCe/hIzLZuwzNplwS9ZsG+vlaucl6zL6vwY0JBFgybYL9SQMNZUIwA9163+Km/fRKJ8ym8qYjEXHt5TcNkhHZMvwgbn6bkWc1ssxTWvozCJl4LK/ARzoBhNPupmIIqP9sAbuzchZMvvwr1MywzTKi9oaQwVAmaIdoGF/6/e51F5PgH1xXwVDGy8em5TyTvUXcZJP1PILN+kBWY0fk0sMnthUMcTpMVNYYQvEmnuz4/Ns2laywcR/5l/JFfphDxRl4Sog266RK4SeLE2QOcv2CYt5KlCrKem/wZJ8pfHKULYeLmYAyciIyUJrpZloyYerMe6+8usGun9C9/kzb+T/bcs7ZjvMhzFbBNu2ww23/klzo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dropped individuals from Cc list to reduce the traffic.

TL; DR: sashiko made a good suggestion to improve this patch.  I will do so in
the next revision.

Forwarding sashiko review in a reply format with my inline
comments below, for details of my view and doing discussions
via mails if needed.

> # review url: https://sashiko.dev/#/patchset/20260404163943.89278-7-sj@kernel.org
> # start of sashiko.dev inline review
> commit 2c875b613d1b0d252222336af28714d95bf57930
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/tests/core-kunit: test fail_charge_{num,denom} committing
> 
> This commit extends the damos_test_commit_quotas() kunit test to verify
> that damos_commit_quota() correctly copies the fail_charge_num and
> fail_charge_denom parameters.
> 
> > diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> > index 9e5904c2beeb2..1eb70f721d1e1 100644
> > --- a/mm/damon/tests/core-kunit.h
> > +++ b/mm/damon/tests/core-kunit.h
> [ ... ]
> > @@ -717,6 +721,8 @@ static void damos_test_commit_quota(struct kunit *test)
> >  	KUNIT_EXPECT_EQ(test, dst.ms, src.ms);
> >  	KUNIT_EXPECT_EQ(test, dst.sz, src.sz);
> >  	KUNIT_EXPECT_EQ(test, dst.goal_tuner, src.goal_tuner);
> > +	KUNIT_EXPECT_EQ(test, dst.fail_charge_num, 1);
> > +	KUNIT_EXPECT_EQ(test, dst.fail_charge_denom, 1024);
> 
> This isn't a bug, but should these assertions use src.fail_charge_num and
> src.fail_charge_denom instead of the hardcoded 1 and 1024?
> 
> Using the src fields would keep this consistent with the surrounding
> assertions. It would also prevent the test from becoming brittle if the
> src structure's initialization values are changed in the future.

Makes sense, I will do so in the next revision.


Thanks,
SJ

> 
> >  	KUNIT_EXPECT_EQ(test, dst.weight_sz, src.weight_sz);
> >  	KUNIT_EXPECT_EQ(test, dst.weight_nr_accesses, src.weight_nr_accesses);
> >  	KUNIT_EXPECT_EQ(test, dst.weight_age, src.weight_age);
> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260404163943.89278-7-sj@kernel.org

# hkml [1] generated a draft of this mail.  You can regenerate
# this using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260404163943.89278-7-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

