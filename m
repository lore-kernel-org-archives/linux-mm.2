Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADA49C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 15:08:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 940886B00F2; Wed,  2 Sep 2026 11:08:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 918036B00F4; Wed,  2 Sep 2026 11:08:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 807836B00F5; Wed,  2 Sep 2026 11:08:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5C8BE6B00F2
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:08:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 02AA3120190
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:08:54 +0000 (UTC)
X-FDA: 85169154630.21.0AB2340
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf26.hostedemail.com (Postfix) with ESMTP id 24B7B140015
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:08:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QKLX1l0W;
	spf=pass (imf26.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788361733;
	b=qXTZhZub/c3/YX+pEMP/zks7bxYutzwpwNhalQsbPHxfq9avTWkDewr2iqM8JDxFaSeDa0
	sjMdH3x9rAEtQyy+mmUtb7cUb4xtl+7m8PBYaijxBgD4Q84KTTCiN50Q+zfXi5a8zpXApD
	mM9OUUDY30yWayeD/AxWLd1i6Lr+QgM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QKLX1l0W;
	spf=pass (imf26.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788361733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EIdbnMs2RBr+E/C3ONkDjLCzcgL/LziyquabNv/nyLY=;
	b=t0iTjirOc6j94EniQGCX+WIVHpgQLb5KGg2shJNlI5Oi9NKVQSdNhCeLCeoYQkdgYRTu+a
	o9i+kj9w7jN7aylvXKe4zsmAybv09cF+Nh78jZxt6mNcpr0w3SCpa/hE3UhUQvGLtJfZpF
	gt3Dg/Uq+0gsZSSHOCbuUDNsil49UDE=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2d01663d816so10314795ad.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 08:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788361732; x=1788966532; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EIdbnMs2RBr+E/C3ONkDjLCzcgL/LziyquabNv/nyLY=;
        b=QKLX1l0WAHDRL4b6aYKfG3DQhppCF6kOmzipacsnmntoIZAEBeKEBT4QrjrEk5s6gP
         toGrUNenyU0voYL6mHEdJTPucQSUcwvCN+v/StNrs1SD6rzTZu7VJQqevnvq1pk9Adns
         k4Gbg0/REGuKzY+5EnIyHL2hoNcBNfCmmMGocF9ViwQMP/XOPxYfGtL4wnJ28fc1fBO/
         t4ICorTmneUqRi5mBom9YsvVfAygjdiK1m8Esx2/vTyL/h6C9nB/8/pL8+xDPrQJ/OGL
         5sgvrfHNQ3gnKs/eG94eH5CL5HNvJoVq4+MyCnoO9XitHcCDVnPJPDbwmFJW6HpnwCZm
         gBlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788361732; x=1788966532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EIdbnMs2RBr+E/C3ONkDjLCzcgL/LziyquabNv/nyLY=;
        b=ihpC4Mqjd7HVdvFOPpRBbq9hLVdo0oJ5QjCAP+cMIZzSqNGCczm15Gqfr59zfRZCF+
         S+t21h3oGvm1KjZ4FKGFDf9eh8b55/BC6qPrE2DcR5hMyeQt3lRRKOdK82zeTQsy/AaI
         +5J/kqEkmQPREWFDs734fR0BV5IlkTl5O26RBV2Ie+1vUxI4uOb29Crd13I5e8rx81mR
         nhnFaUcRPBJOyT/0AOjfygJoqfLYOA3nUjsta8Jj7PIbHeTv7Mon7YddhjBjFG77F61/
         TVA8KYO0ouWHBAmvCqUxtQ7F3FAonI4EGeaBTwSpIsL34oHTJcsAg+7fNq7AIZnrPheq
         NtSg==
X-Forwarded-Encrypted: i=1; AKwUvBzYPaQ/lBbQBn95il19UWHQZxjh8JX2NVZ4Jwd8bDQGi6HquGbmNywxBWP8VCOvFz+21fqg94yXxg==@kvack.org
X-Gm-Message-State: AFuF++kfTGgp4njp1xqxRnZcGFsTXSvt85xvERkSVBGBbs6nlS6xXrgX
	ctj0Zu9oOONkiHx1xqlxfdpVIpG0ssufr1FFmtp4EZrnuIz1Tjpmqp5R
X-Gm-Gg: AYBFou0BZCeMGBxr33i8Wm2Iycscc7O8XtWRRbBwLJxw3v5wFdbCtDIoPIF0m4nCWFM
	GtvMp85ds1xe7ogaa7ImipmLqMURQE1e3SR26tsOFyLKt/ECapqm1APNCIApQrt5u/XxO5Q0njF
	JOqTk/CqIC2Or+l5GRCvoUVG1XijwMsOS2XBd4xdBqh32pt62iCMPBn0UrQRdWpwCI0i9qT0rd8
	XRtQgBdiI5ibdbG7iMUe8FqVPN+s4LSqbC7RAZuYG4mL1r7qgNqpom7Lm/8jKPacyqA3j0Fm9qw
	JR8mcTqcnXVOTB4n6WhlsgK48n1m+ixhf3VejYXF0qp3u2VZAqqE5a+tiMtP4FgxqrJzd+7Krt3
	hb2xeNrwxbGHr7jVZJXnTWIuWTJbT+lLLL+gC01WSqc/5/CeXtZPs+X/AjBfvH4VBKvwMeiwTbl
	P7Xk5rE35LPg+ZvbmfazvC2zg/cP5BmEm2UGJZpp121ek59+nXeXzz+pgAy2Yd
X-Received: by 2002:a17:903:19ec:b0:2d6:e4ff:9cad with SMTP id d9443c01a7336-2daec5ab9c5mr86317615ad.3.1788361731078;
        Wed, 02 Sep 2026 08:08:51 -0700 (PDT)
Received: from gmail.com ([185.220.238.35])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dadd488d18sm15030855ad.45.2026.09.02.08.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 08:08:50 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: SJ Park <sj@kernel.org>
Cc: Kunwu Chan <kunwu.chan@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 09/12] mm/damon/tests/core-kunit: test damon_nr_samples_per_aggr()
Date: Wed,  2 Sep 2026 23:08:41 +0800
Message-ID: <20260902150842.4033320-1-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902054747.99370-10-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 7r9dj9je3buguzqtha3pc11cg7dwgk4f
X-Rspamd-Queue-Id: 24B7B140015
X-Rspamd-Server: rspam06
X-HE-Tag: 1788361732-453116
X-HE-Meta: U2FsdGVkX18xuefHNBbtLI3LLi6PjbrmSDmEoBRQ517A/nxpUL650ylw7Zu08/BE+H236rPyZ0MueCFZR/dppO2JjT1b3tBDgcEdKtLKDpPD/6mOq9PfhGglonWjK+TdKW0z9dNaHzbt57HWR92p+6hg669raNa56UGbV7RrL6F5UnORawtBasZnmq/aOwfMnz40yZvg6q+S7lIu2WhUxqcfJLCXgPX/kBODBp4zVTDSo1MJZyC0wRAAZbucS+yXjcEIyhOW1TMAT18YlNs1iO7trJQrx0H8dVSrzLCPuSe65eTGHuE1VmcL0afDNRalZHMrGug/h8TZpq9H00/lSGoP9dA3zAglvDoyQVJqNdG3rIt/k8ysNZbI444et9BG+/8OMk5oHb9LkudIk7lK3de3Kxit2u31+JRH6EIIC3cVfYTat9SvmGmlj+PdvobJl1M4gGz9UX8mLUeV+nU5Xy/FEGgJ0ooqF3VtmU9qG0HJOQq2EPmXuF26oNnMabR1FQb1POmvLmTTTQWTrZDaJO0Ye8qUktxUSu/9iRZvADbA8Il/WEY4+hcqroCL26AbGZaE2JvPwlWi2INbMmjkPi+TInMrAV2I3ZOOeuVJOTknjetzjQG79WKlZ0r47YCQYQ3ou5GLu88lAVdkaMMbTBhaA/BeanJtauzFtoCbWfxnwq3RzBEMAI5SUczZVG9dj4cAUkSZsedC/fyGe4CwuEIjYWAvwSXskVRdu2BekjW3ZEx/OhWIubG7M5mzpEalVRi5Ln9vPIufjHOfL2tZTuIvHhz9tu0eXkJyF0UzoggJQSuYGpwVWz5HGe8ePJ/1avXnFMh/AJL7zWAfj2tTIM/XHJpN2z0Tw9iz/090jlh26cHzdvG0baNBdkhx+E5hXyYZxqcueNfMkl+T/1mSfQoOU0GwipA2n3SVXFhjUiQbvDBsIs4qX8AxpKdjf1a2lBejULAukwMEZPoDrKS
 YrNfTxJr
 Yd2G8s2mhCjSKb0RCg9IyKWLcgj5XupsZ5W3GryfdRF7SQqBeoTV816m8K7C4QxhjQ/HSVLF3LvfMx1uxmL5Zk9Nv5+AEONWPgdiKdvHyUMtAP/sQF0aqRkXPuO3M/wwcCPktC3yz+8guFlXyOO7RE/s5AcIngTuwjP5sWbtJaDAmoe8ASmJtyiRe94qRG/XvlgikCFrtrqd9JE3rjbOmw2XGKJr3kIFGT+5+g1rCanlt39AVng/z8BM6jnAt+QEI1uy1mlpy0Zh8wefNY4/NNqy2znT2JG/81blYg7ki1PjrON5uVV5pqLlr/TE9FGGgUZd/8vYy/So1QCpwn4lfGi4dJ7gJd7Ug71jtEyRKUPZ7mTVseqeFSdh/TxS1wdPX/Qa3oMgkiFSeMmB7+mQbnq8t2tELtHItVISougd2rTZGX8dQIE/uTMy/2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  1 Sep 2026 22:47:42 -0700 SJ Park <sj@kernel.org> wrote:

> damon_max_nr_accesses(), which is a previous version of
> damon_nr_samples_per_aggr() before the renaming, was wrongly returning
> zero or random overflowed values for extreme intervals setup.  Commit
> 35d4a3cf70a8 ("mm/damon/ops-common: handle extreme intervals in
> damon_hot_score()") updated the function to return correct or more valid
> values.  Add a kunit test to ensure it is working as expected.
> 
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  mm/damon/tests/core-kunit.h | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> index a4164ac489a61..d0bed01a5b7fe 100644
> --- a/mm/damon/tests/core-kunit.h
> +++ b/mm/damon/tests/core-kunit.h
> @@ -625,6 +625,27 @@ static void damon_test_set_regions(struct kunit *test)
>  			(struct damon_addr_range[]){}, 0, -EINVAL);
>  }
>  
> +static void damon_test_nr_samples_per_aggr(struct kunit *test)
> +{
> +	struct damon_attrs attrs = {
> +		.sample_interval = 0,
> +		.aggr_interval = 0,
> +	};
> +

Hi SJ,

A small question about the first test case.

Both `sample_interval` and `aggr_interval` are zero here.  Since
`sample_interval` is the denominator in `damon_nr_samples_per_aggr()`,
would it be better to keep `aggr_interval` non-zero when testing the
zero `sample_interval` case?

This would make the test explicitly cover the divide-by-zero protection.
If the `aggr_interval == 0` behavior is also worth covering, perhaps it
could be tested separately.

Thanks,
Kunwu


> +	/* Zero aggregation interval doesn't cause division by zero */
> +	KUNIT_EXPECT_EQ(test, damon_nr_samples_per_aggr(&attrs), 1);
> +
> +	/*
> +	 * Too large aggregation interval on 64 bit system doesn't cause
> +	 * overflow
> +	 */
> +	if (ULONG_MAX > UINT_MAX) {
> +		attrs.aggr_interval = (unsigned long)UINT_MAX + 1;
> +		KUNIT_EXPECT_EQ(test, damon_nr_samples_per_aggr(&attrs),
> +				UINT_MAX);
> +	}
> +}
> +
>  static void damon_test_update_monitoring_result(struct kunit *test)
>  {
>  	struct damon_attrs old_attrs = {
> @@ -1736,6 +1757,7 @@ static struct kunit_case damon_test_cases[] = {
>  	KUNIT_CASE(damon_test_split_above_half_progresses),
>  	KUNIT_CASE(damon_test_ops_registration),
>  	KUNIT_CASE(damon_test_set_regions),
> +	KUNIT_CASE(damon_test_nr_samples_per_aggr),
>  	KUNIT_CASE(damon_test_update_monitoring_result),
>  	KUNIT_CASE(damon_test_set_attrs),
>  	KUNIT_CASE(damon_test_mvsum),
> -- 
> 2.47.3
> 

Sent using hkml (https://github.com/sjp38/hackermail)

