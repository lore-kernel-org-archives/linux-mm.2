Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8EA7CA5FC1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 10:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A69276B0088; Wed, 30 Sep 2026 06:00:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A19D66B0092; Wed, 30 Sep 2026 06:00:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92F196B0093; Wed, 30 Sep 2026 06:00:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5ED4F6B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 06:00:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2A3BA06EB
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:00:23 +0000 (UTC)
X-FDA: 85269983526.14.F124FF3
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id E9FD0100011
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:00:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Oy4Hnrkc;
	spf=pass (imf05.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790762422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uY42P4Ky+ruFRmU+eZJWwX/D5fQMOFLbNxI4/lZCJAg=;
	b=vLSLVEvN9p65TYi/8+WiQc/p/ClIQRY5a3MXpc6ZwQ/xKUukAYl76ZXpiCmTFHpZn5fk8n
	QHpGeyf0EIv7uvalgZKBfJ64w5zA239Vr3Lfh61M28rTraW7vBWCdMOwTM8AHJtXG3Kurn
	b3fNLltWEzkU4VtAXwlgFN46NRFmX9Q=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Oy4Hnrkc;
	spf=pass (imf05.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790762422;
	b=BP2MPAIY+U3mvNGjnEGA+R+IHsI4KpGRD1xuFWSrhuAeywC9/8j11r9x3+6s9L2KiLjh6j
	meZ/VQi1+4KZkGVTVyozzh3hsx0EUtTM1gmOARj9m4LhWl3mxo80VHUmWhtGBFZE+gLJl1
	Dpi+L4X85nVk6t0tT0kxMZpsZTna0T8=
Received: by mail-pj2-f43.google.com with SMTP id d9443c01a7336-2e2e35ee682so1442375ad.1
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 03:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790762420; x=1791367220; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uY42P4Ky+ruFRmU+eZJWwX/D5fQMOFLbNxI4/lZCJAg=;
        b=Oy4HnrkcKfyT3hwMymimCND0dJ82bXPp2UTfEWl+GSbIRTmBjOcF48mnJhEXHHJk9H
         oGVKUHcEC8jOUw1roSnd/pK94LyDFtndyjVN6EuQEIXphhNW1UY6JcJsQ2SbeksE+j2v
         44euVzNtsaXjL7Kgkh45MRwb5i1obuqcfGnRqI7XaOh1VT3Y6dtZuVyZfDUuwkSKyxQV
         X/yIb1SeIrqksigqTY4qiC6xTlKmuQiYX/16KpOy8iplKGdI3mZpsHNlTa7PUHpW/UmV
         x6H1gjAEIZBwqUANZk8wTi+LC8b8j75xZTnySe1eXpnOALtqZv5xXCgfqm+fyenkJiME
         FobA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790762420; x=1791367220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uY42P4Ky+ruFRmU+eZJWwX/D5fQMOFLbNxI4/lZCJAg=;
        b=sATlYfiQTBpl5igjwaIe3+xiZ2YLYhoRvSg4aNi6L14Guev4n2p796/Qf/HmwKpUsy
         et0we8/h9rmzZ5hzPXayfQCgmL1Ra56x6LGqv695Nlfd7Gl+2A6t0oyi7Y8GAd9DY0DH
         5Tz6sRaOHjvn8jqI6suMMOIbN+rgBMASpQP/wkFyGp+lkGvYfqYGVeivuopS89b1naai
         lfHdsEYX+TzF7V8/yKseolUJ5U6WFPofKtvMNcCbxXRL3lFuSxF4cWStnWYpKDju2Ja9
         kEp+1goKqc4lcrDnwwnA6mo4Z3nTVSsYRANLRB2E4CgL8SOrrw/1FoXah452dxUkLTdA
         6eZA==
X-Forwarded-Encrypted: i=1; AKwUvBzyYUQK+DWiPg8deU1UPjUYF7tsFMyH+DtlrM4dDGKmsJ/6Sg68hDs+1+TQspV2zIhzXczn5aU4jQ==@kvack.org
X-Gm-Message-State: AFq9FYLUkcejZ3tsCM2TEpnC9wTYfEE58pD3VPvsZ2eQqL0eewO8VxIv
	hbzy56rcv5twNF2nC41E409JJPi279laq+RpAiQ0N2fykouC9uF4koBT
X-Gm-Gg: AYBFou0DpR3BBgG2yTz8vFDdYHdbtOMYJu6gBV9w/ti2YgZGFE4bTSqfH7pHFCuIToJ
	fTkigAWAN6f7VfBcUFjom4vpkpZwL+Zs33G1xLBnl/hkI4UkY1NCf9g67uiNA8wvbM56GntMvHb
	jyQaaoIDS4KmjtbYZyYyUzAAWKPp8TqwhwoFzv9XzcN33zkmbSVfF/pHt9Y3jD8gAhIe7I3sHZo
	wL5epbu3FE4tLMBlsXPrLqhqEGUupswyL6NO0zUpIm2RWnTMHrX/71cQePYtd/jkorFIfYduKZs
	yigu96Sicl5an+9rUCi47pvY/pAKuEvElvM6Z0gVX0oARe3Qrc6lpadnWeS/Tnk/r/2ZaopduSl
	wENfxTNsgq8pw2gzhzvLCgVbF4Et6LYr+NazwvY76ktCzwHsPLpSiczs2BDtXyPmLISSVZzbe1T
	Ulm6uXUK2QqjKPH7RiNQrQclPvf3fqvm8pNZchls6Z6dVyOfPmsJAqdKkiCPMzRhhKGHVtI5QV+
	Tvot8jlx1nOHEWRwqNFJQl2
X-Received: by 2002:a17:902:d54f:b0:2dd:c100:4248 with SMTP id d9443c01a7336-2e2e4b7d4bbmr8415345ad.44.1790762420172;
        Wed, 30 Sep 2026 03:00:20 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:867:387a:70b:38f1:a1dd:9303])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e2e5c32c66sm4583335ad.74.2026.09.30.03.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 03:00:19 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC] mm/damon/damo: saving damon sysfs configuration
Date: Wed, 30 Sep 2026 17:58:54 +0800
Message-ID: <20260930100031.7338-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260929074300.40012-1-sj@kernel.org>
References: <20260929074300.40012-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E9FD0100011
X-Rspam-User: 
X-Stat-Signature: cmprs1wo7hezmdnggjhb4hijjjmjp1y6
X-HE-Tag: 1790762421-427763
X-HE-Meta: U2FsdGVkX19JCHbaBaCCA8Qnrq7HwL0+MifbhhZHytSnAkFBfpKpQ59gHQ1Xe3i9wGNCm23lBI2zwBW1yMotdp4oIz1LV2vH8lT/jg1jSUAqSZW0POt55/FsMr/iiB0jbbz+xMwfXJX/pkGn+FhZGHBYSb7gLlF9XEcLtkMklNGRziar6eyDPMumKGK62lnFjJcg12Gr7F7qcoBlpbBtHbLWXZLOMZJcJ7l2E4s7FZHJi35p3ZBitLPauXfsvG6+8e3jR++liw5GnTWfuj24pSJhU0nQOdRlwQcj/na5cWDuDFdxHfluN5L7s/qGW7SqParBjoU9MA7L5EZJR3VgM1KmDY6xORcDwW0a5XlH7/Op89NhXapBqhFO+4wIRc1gT01ZFkpllzp3fKfRWuuHLUymjti70+TmpifRpH4caklk/HY7/ZTep1So9td2b3+lR9p3YAsk1azVvn9GkdDGPEzyY5dCal59gbEDBq16LGO8cYKea7WaFq51npJ+byDzhVgnNtV1+mI1Q3v2pOwE3hEmnZefl6DHjeE5IGwrp8LmzxewxXiEWOENaMCrbXUbLpq0kNjS8pGkuxqdY6LhabrDhOROJBm23hHnaOj98gGh9kG7Wh+iqEoBW72g3MEiIoOc9YgwuP2fsP/t6rxWWHrxD3dTVVJgjHViKOR6xopjk+UWPt/L9AmAvT98PiOuK1PMMYeI3CUZHoleg0k6p+f/cs3zrwTaQ0hx3BLpAoepKyWLMNBtR4zH3niDESG5c3x9OzMabMsDIQCuL1L7jwLM8zJpD+LpF4smpf8KetRfutbEwtUKsPR2TgBr1vkKQqKA7CHeXiG65fP+gBSM5Hp692QIhfwq9guzgVn5SvvKKCwm+0e6pu7ExcMItGv7EpImnCnXvHgMyQIJjfXoPH7Gq/9LawIm8vzsa2y9taUNYgsc5BhF7khHf//G+RG48sWBHS378EPE61EQQ/A
 fUo7shC+
 bNnkU5OrFWr0Kc2ZmA+ubYVtVw8UGJQp9zsc+NczyVNontES0mV3DQ5dagWZ4B0C2aQs4kD5fzGS08VE1fhB1XQhc5jW5ApkxFotwGLGZsTP6w/38v57ahSbadaWMxm5alFovQTvH4OJiBXZ8wINM/ibwITvAOHOv5UvEeEQ+X9LP8alo57/m+zOHOKcB/NQHq6b4JTWx3uaAgNC7iP3m28kJN03oZaGonwuG5NWo1e0qFHIx0CCmCbmTM0tt4w8lMn6P95+UJKgJ34oX3dAU0/q0dTwYxDagEq+6Ghexb5bJLOaGOV86XtPAKHHJ6fQt9VSzyelKia+a06U+ROyU9GxySc46RzywSMw9ztX0nq47Si+gMASpfrFmHySSQUl3dOtG5e/7CvIgZ919g0mDRrNDpJXuBV/LtAFcmYhLjf9PcxV0p4JjwaDmuuCmVUyZbKfe1y7Cpj9UHCtATgEwY/9yzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 29 Sep 2026 00:43:00 -0700 SJ Park <sj@kernel.org> wrote:

> Hi Liew,
> 
> On Tue, 29 Sep 2026 03:13:06 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > Hi SJ and Community,
> > 
> > I've noticed that damo [1] doesn't seem to have a feature for saving
> > DAMON SYSFS configuration.  I tried 'damo args damon', but it doesn't
> > save the DAMOS schemes information.
> 
> If so, it is a bug.  Could you share more details including how the issue can
> be reproduced?  Directly sending a PR should also be fine.

Yes, this can be reproduced easily.

    # make sure DAMON is started
    $ sudo ./damo args damon > damo_args_damon.json
    $ sudo ./damo report damon --json > damo_report_damon.json

    $ sudo ./damo stop

    $ sudo ./damo start --kdamonds damo_args_damon.json
    $ sudo ./damo report damon --json > damo_report_damon_after.json

    $ diff damo_report_damon.json damo_report_damon_after.json
    4c4
    <         "pid": "4959",
    ---
    >         "pid": "5582",
    16,17c16,17
    <                                 "start": "4,294,967,296",
    <                                 "end": "15,807,283,199"
    ---
    >                                 "start": "4,096",
    >                                 "end": "15,807,283,200"
    25c25
    <                     "ops_update_us": "1 m",
    ---
    >                     "ops_update_us": "1 s",
    46,159c46
    <                 "schemes": [
    <                     {
    <                         "action": "pageout",
    <                         "dests": [],
    <                         "access_pattern": {
    <                             "sz_bytes": {
    <                                 "min": "4.000 KiB",
    <                                 "max": "max"
    <                             },
    <                             "nr_accesses": {
    <                                 "min": "0 samples",
    <                                 "max": "0 samples"
    <                             },
    <                             "age": {
    <                                 "min": "60,000 aggr_intervals",
    <                                 "max": "18,446,744,073,709,551,615 aggr_intervals"
    <                             }
    <                         },
    <                         "apply_interval_us": "0 ns",
    <                         "quotas": {
    <                             "time_ms": "0 ns",
    <                             "sz_bytes": "16.000 MiB",
    <                             "reset_interval_ms": "1 s",
    <                             "fail_charge_num": "0",
    <                             "fail_charge_denom": "0",
    <                             "goals": [
    <                                 {
    <                                     "metric": "user_input",
    <                                     "nid": "0",
    <                                     "memcg_path": "",
    <                                     "target_value": "3,000",
    <                                     "current_value": "7,855"
    <                                 }
    <                             ],
    <                             "goal_tuner": "temporal\n",
    <                             "effective_sz_bytes": "0 B",
    <                             "weights": {
    <                                 "sz_permil": "0 %",
    <                                 "nr_accesses_permil": "0 %",
    <                                 "age_permil": "0 %"
    <                             }
    <                         },
    <                         "watermarks": {
    <                             "metric": "none",
    <                             "interval_us": "0 ns",
    <                             "high_permil": "0 %",
    <                             "mid_permil": "0 %",
    <                             "low_permil": "0 %"
    <                         },
    <                         "filters": [],
    <                         "stats": {
    <                             "nr_tried": "0",
    <                             "sz_tried": "0 B",
    <                             "nr_applied": "0",
    <                             "sz_applied": "0 B",
    <                             "sz_ops_filter_passed": "0 B",
    <                             "qt_exceeds": "19",
    <                             "nr_snapshots": "0",
    <                             "max_nr_snapshots": "0"
    <                         }
    <                     },
    <                     {
    <                         "action": "stat",
    <                         "dests": [],
    <                         "access_pattern": {
    <                             "sz_bytes": {
    <                                 "min": "0 B",
    <                                 "max": "max"
    <                             },
    <                             "nr_accesses": {
    <                                 "min": "0 samples",
    <                                 "max": "18,446,744,073,709,551,615 samples"
    <                             },
    <                             "age": {
    <                                 "min": "0 aggr_intervals",
    <                                 "max": "18,446,744,073,709,551,615 aggr_intervals"
    <                             }
    <                         },
    <                         "apply_interval_us": "0 ns",
    <                         "quotas": {
    <                             "time_ms": "0 ns",
    <                             "sz_bytes": "0 B",
    <                             "reset_interval_ms": "0 ns",
    <                             "fail_charge_num": "0",
    <                             "fail_charge_denom": "0",
    <                             "goals": [],
    <                             "goal_tuner": "consist\n",
    <                             "effective_sz_bytes": "0 B",
    <                             "weights": {
    <                                 "sz_permil": "0 %",
    <                                 "nr_accesses_permil": "0 %",
    <                                 "age_permil": "0 %"
    <                             }
    <                         },
    <                         "watermarks": {
    <                             "metric": "none",
    <                             "interval_us": "0 ns",
    <                             "high_permil": "0 %",
    <                             "mid_permil": "0 %",
    <                             "low_permil": "0 %"
    <                         },
    <                         "filters": [],
    <                         "stats": {
    <                             "nr_tried": "2,000",
    <                             "sz_tried": "1.801 TiB",
    <                             "nr_applied": "0",
    <                             "sz_applied": "0 B",
    <                             "sz_ops_filter_passed": "0 B",
    <                             "qt_exceeds": "0",
    <                             "nr_snapshots": "172",
    <                             "max_nr_snapshots": "0"
    <                         }
    <                     }
    <                 ]
    ---
    >                 "schemes": []

> 
> > 'damo report damon --json' provides
> > more detailed information, but its output cannot be read by 'damo start
> > --kdamonds'.
> 
> Maybe this is also an issue that we could fix.

In my opinion, this is not an issue, since there's no documentation
recommending we use the 'damo report damon --json' to generate
configuration for 'damo start --kdamonds'.

> 
> > 
> > I'd like to know if there is currently any way in damo to save the DAMON
> > SYSFS configuration that can be correctly read by 'damo start
> > --kdamonds'.  If not, would it be worth adding one?
> 
> I believe it would be useful.  Please feel free to send a PR.
> 
> Nonetheless, we added the json/yaml kdamonds config support mainly because
> there was no good way to flexibly configure kdamonds with the command line
> interface.  Now it is much more improved [1].

Thank you for clarifying this!

> 
> I'd recommend using the command line interface.  That is, you could copy your
> command line setup in a bash script and modify/reuse it.
> 
> Is there a use case that it cannot work or suboptimum?

No, CLI (Command Line Interface) do very convenience.  I can write my
configuration in CLI and it is very readable.  Thank you for letting me
know this feature!

    #!/bin/bash

    # update-damon-config.sh

    ./damo args damon \
    --kdamond --damon_ctx --ops paddr \
        --monitoring_intervals 5000 100000 1000000 \
        --damon_target --regions 4294967296-15807283199 \
        --damos_scheme --damos_action pageout \
            --damos_sz_region 4096 18446744073709551615 \
            --damos_access_rate 0 0 \
            --damos_age 600000000 18446744073709551615 \
            --damos_quota_goal user_input 3000 10000 \
            --damos_quota_goal_tuner temporal \
            --damos_quota_interval 1000 \
            --damos_quota_time 0 \
            --damos_quota_space 16777216 \
            --damos_quota_weights 0 0 0 \
    > config.json

> 
> [1] https://github.com/damonitor/damo/issues/3#issuecomment-5655965736

[...]

Best regards,
Rui Yan

