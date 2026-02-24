Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D577EC1133
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 01:54:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA4246B0088; Mon, 23 Feb 2026 20:54:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B27BE6B0089; Mon, 23 Feb 2026 20:54:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A33CD6B008A; Mon, 23 Feb 2026 20:54:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D7336B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:54:58 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 21FBE1603D1
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 01:54:58 +0000 (UTC)
X-FDA: 84477681876.30.9812AE3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 812044000F
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 01:54:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MiBDSnKh;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771898096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=053QcXJC/uQlfXZjQIgtZ/z27bhpKCuDgtj1qJalpic=;
	b=FGoN9wl+FTJtUfubPKyZDS29NIINnwE1NdxH533que0Ki8lFAupezRAQTnWAwohwXnvn9r
	dSsOSrin2uGbcdmBmZXreW5Dyw4eYJ9q3ZCkI+zZ2Zamd4XJVB0U5KzocWZri6RoP9xu+7
	xSpUdWAq+vOUyetrpEM1xLfjLdofXtE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MiBDSnKh;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771898096; a=rsa-sha256;
	cv=none;
	b=fL21MJiAnuDEnqJG6Ou/MBu8oCera2/FUE7/ZITAP/fQsc7ESUmjO++7toRa1ZLsLvJKK6
	ViPGtMXoB+Y7mxzKBQ0ti1g/UEmTxt/qDLefokL7dnOMHi1LMB0g2/LAOdm4+LLyaX8Mwm
	GsOdmfXpEHj1vK7b6/k+smrKhv1e40U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B91F6600AE;
	Tue, 24 Feb 2026 01:54:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1202AC116C6;
	Tue, 24 Feb 2026 01:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771898095;
	bh=ShmNycpJjFAr5FPie2HkibrMbfPM533UhWG1r/u6bq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MiBDSnKhOK5Qq9mmcTFXukIsQdfDvtLh8mSQqgt9uK3OlV8LqQDSBys2Z735Ss7e+
	 GcZScbjOca8l0KHbX4je9tDYvzulXti1ltBnOL6JktwVd8/QHMkFxC7c26w1f7ZnVn
	 2ISU0ekUzUtFLBZUmj6aS7jYWZ1K3JRMZSHSAvqlowuDVuAGhWCPi2AcBGFADhqjGQ
	 kuj2uUv8u0s8Zvo8day3Z1/fv+EFYFL8Kc2lRX34dCq3bNRrecNQeW4l/D3oe97au0
	 QlUAQ7mSqQhBQcb7cqK5P9IOTMaDKK0FPWLJrPX/OGf6HtyBoSyKclkJ6V34WYhpW+
	 eaPmTs2kheVtg==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [RFC PATCH v3 2/4] mm/damon: fix esz=0 quota bypass allowing unlimited migration
Date: Mon, 23 Feb 2026 17:54:52 -0800
Message-ID: <20260224015453.56879-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260223123232.12851-3-ravis.opensrc@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 812044000F
X-Stat-Signature: 3fah7zn48chgusoaxj99jdjp9s1auy4g
X-HE-Tag: 1771898096-507133
X-HE-Meta: U2FsdGVkX1+uycyxBP3UoDoIabXbj6SJT3lm+5j+WtE1al0W1cwP115P/WsMBLNPHic5SakOzdMB7rkCkZdZl66xQiIqCRg9TmCtWO4IzamBXHhTmN5uIUJ9bnNJjVewecYRHu4gm3KBOoYEvVPRtcvNOgSIROZ/DpS4D/j3MR9hy0b2wqt7MvdV7uVAGd1y/vKk46MQqL/WKtT8bvkF85dBEDklirCHiON0h2i9mVn1cMELVv0OXKZhen2I37QpB+X6SzV3Zhe7sTZmqS2Lb+skdFdMQ5+LOCtZNCfq34fbIfNqG9YdcmfdjU+irOUBWtCeDKa1w8XlELGrFNtMUNUDAKcUTqSZpERRjpBV6POmWPfw6CgFkssQJWA60QrjkaLb/q0q0EHfxljpZLUj5q2pE3APQy+aRU5dEUqsOuvdyK0TJpyamaZE7Z6ea0aJFw+C9aRcWNUmZYvADKFwBiDNVjgJdSXN4iPKVqzrr8COHKtbHVEGFAxJAzOrdoac4V64DvdLfN8HsWIvfQJsEb/yL3/jR9xMxnUd4Tck91O0EZSRKTvUZAbrEMUeog5/cTz0Wu5DdnykzjcGYMWvRvgHlyNSRdmw+k25o0BL6Ym3ceKt/6VVnyubJc1SBFG3LY1bZS2i8soPkPpWCMWVSecsoQU5UaGa3o5EbDQE4MEJI4cbdKuizLT/32+CU8/mapZv92BhXogCgRGgdbV9NQTgk+RcmZlaRlQfT1hwVEllz3AbTQizlIpB4eh+rmuUvCxfPfWCnGCYUt2F2hvcVZQBoM8nkMWhU3XqrnKjlzRH0SqEfznERRWn1eJ3YrCM7viW4GWwOs+/aGgLYDcrEl10TxO9d14gM6efRCZYC81pNJCjiYUaJ8HR4uwQ6MUdsi/pEAne7LgLVikSpcZKtT84uWt2sUGAgf/w1cO6ZonglnauhSdYk6yCTB1ACLWODpO4S/UHe1U2a0D9yyE
 q1L9+l20
 TZCdpuxHsQFsrE9IYLuCo1BInNRZSW39b6Y4txZUc8sUl9QNk3JL4Vxksgl5MUsd+dYY2lHHD1qQWgimdZWswkKox+1o/g/PEFr3q5LiYyEdxvO1GRGJfLww7Dkn6W8HncCuabMuyp0uJKgs+dMjyZKqdHdcy1uxdcdedPLGvMVxL7YtmSkwqdXG9paoUtDspXM8rHgRlYMGSVjtKMxcZXZ5YjRfe9cd44jWU1Pt2PTSQAjNbhipXVL3Lx58kptHHLoES1LUYTa0ybVu50VBdm7OO+cRTOiSlJ/xxYViWtd3/Y/W5R3fDIc0u1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Feb 2026 12:32:30 +0000 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> When the TEMPORAL goal tuner sets esz_bp=0 to signal that a goal has
> been achieved, the quota check was not actually stopping migration.
> 
> The condition:
>     if (quota->esz && quota->charged_sz >= quota->esz)
> 
> When esz=0, this evaluates to (false && ...) = false, so the continue
> is never executed and migration proceeds without limit.

Nice finding, thank you for sharing this!

> 
> Change the logic to:
>     if (!quota->esz || quota->charged_sz >= quota->esz)
> 
> Now when esz=0, (!0 = true) causes the continue to execute, properly
> stopping migration when the goal is achieved.

But this code is written in the way because the current code assumes zero 'esz'
means it is not being used and therefore be ignored.  This change should be ok
for your use case, but could introduce an unexpected behavioral change for
other users.

One easy workaround would be setting esz_bp with a value smaller than 40960000
instead of 0.  That is, esz_bp is the bytes in bp, so setting it smaller than
40960000 will result in making it effectively zero, e.g., like below.

'''
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2623,7 +2623,7 @@ static void damos_goal_tune_esz_bp_temporal(struct damos_quota *quota)
        unsigned long score = damos_quota_score(quota);

        if (score >= 10000)
-               quota->esz_bp = 0;
+               quota->esz_bp = 10000;
        else if (quota->sz)
                quota->esz_bp = quota->sz * 10000;
        else
'''

But maybe there is a better way to cleanly fix this.  Let me take a time to
think more...


Thanks,
SJ

[...]

