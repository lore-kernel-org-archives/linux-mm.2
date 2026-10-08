Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 809E6CA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 12:09:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 784FA6B008C; Thu,  8 Oct 2026 08:09:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70FAD6B0092; Thu,  8 Oct 2026 08:09:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D6BE6B0093; Thu,  8 Oct 2026 08:09:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F0E06B008C
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 08:09:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BDE80A5E34
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 12:09:17 +0000 (UTC)
X-FDA: 85299338754.19.3072B40
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf30.hostedemail.com (Postfix) with ESMTP id CF3F580015
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 12:09:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UpfrPTgk;
	spf=pass (imf30.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791461355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZpMs8OejlQaJGDNhMC4YaKq4cxnZ0droSQ5wJkH/ueU=;
	b=0TMeGVs0CQARXNivDw1yXBlGsbCezlAANNZCLuWGj7vdESi4HdGz5KbPDIXkjQP+TJJ2mE
	j+NFtmQzYu9amLX1lakXGSmWrpTDJALEAbpzV1oi1jXmM85fbyEkN97+xHfB8aBr7I0VEw
	RNjlmoblYZsOm06V/GdHIwG1Y3qlj5I=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UpfrPTgk;
	spf=pass (imf30.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791461355;
	b=wi7ckxuUehdDxRXi2MK5Jk1eLN45le5RwMwVmCxoz4TAtgBS/oSTxFuCXIsWNTktkoGLvn
	aoJgLghWSE1og4X2lGbscv8ObcCHo14Wunt+NfrAj1GJezDPmXAlPcKyzQjR1bcgLD8Bzr
	qcihKnfzbMXATd1HXVQbkLXy3Et73AE=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cc4aa18f9afso2475206a12.3
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 05:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791461354; x=1792066154; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZpMs8OejlQaJGDNhMC4YaKq4cxnZ0droSQ5wJkH/ueU=;
        b=UpfrPTgkJlLkaxdjc/p2XqXXEQAIhVsL7NtrrZROFj8ZSOmk0uIHb8MnlORdC2XpYM
         xKhB4Tb612iICsBvlUb6L0HxZcKQQ8D0Kb5GAmKUyNaF7TLFIDrFvFthpfomTJSWCRgS
         VL3cGQrrtIVO6jWJXFJgmdB81ld/EUacGLGpZGvNj3wTwFd8W1LR0Yax76I5ei2XQ6z8
         diCTX4Q74X1CU942K16e1i6ww3bD/OVq5xJwTwp9ckuJ7mLVEU7+pRYjiybSbLb3iSfX
         G8gBLaDKTHop4wsif1fHLV1t31C30aSQ/J4mYEfy15CIHwc4zSp7PNSzStDo/F33sjpK
         bMwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791461354; x=1792066154;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZpMs8OejlQaJGDNhMC4YaKq4cxnZ0droSQ5wJkH/ueU=;
        b=ywCL8c6yRUOiEPwWPks3vPskNvUiqVK/LMUKRT4kGbirkdUXBnUPk3zOyjRWLGFIpL
         gwQvYfDWJD7Az05nosjigj7IRqPbyRfMPAL6v0/zmdijrjexw79ZdgkUowJDKlJYp3i9
         UPzPWoP6klJlHKqMTjEgcfZON/n9KyjYwdwL1qQcSh78BRHxu+BAznPHF/RSxoLb8QCM
         m373d7J/smQxcjTjhMvaNdjI/LQ6gHfVywQBZBU5HNiIllc3oA0/UfhXo+M8V/3OrrNP
         GlJ+MlzYUA4yL0TjEywFx7yqyMlNZehJdLq/grAifrGLqxMIlZZdRyLUiumq537Wfo3H
         Ii4Q==
X-Forwarded-Encrypted: i=1; AKwUvBxR1DO6UpKDjn+m+78oCdOlUq98vNcDImlNAHJDql3MtRSPqxFhyGBWBR6m7E+PYU6QTkm0akTP9Q==@kvack.org
X-Gm-Message-State: AFuF++mIKsFrGNZy0HmQj9FMqiykGI4UhEI8G6WiB5p/mjWIubjfi4Oa
	CJ1hwViOEvUy8QrXHv+jI0GD6Z1/y9CQM2XFsFc9POKw8dU6HE1ORN0l
X-Gm-Gg: AYBFou0L9700x41kAz3ZvwF/+VyQSD0jVhW0BKPdO0x5Z6YilwTQ+XbQkDvoxsAdBCJ
	+jo48zlYl6W8AAudVhmDKrG0oNbr+hlYeCi28DwcSODbyL4oKiXqCEKrATGEEH85uY8naLmIaDH
	IXbef6VlkYN+Ns7xj2hUu5b/2ZUaAczwzqa7Fuo3yMlPjXArnQEEeeY2/Gh+urtJVHZDJAIBMgn
	h7CejC2xmtJfXmQdd1zMU6VXer5KOlpmUUBmDyj8Sk2yKiRVizyl6PkQkpkghUkkW7HI2h7+U7M
	Kv3FlPlwO6LJ+wuXKA2Z8jXMc+6EHukf8SQkuB3y5ahSGuHkzaqAn6JnJso1nrMzYQJVGTJ79Ih
	YSj1oCKclgWOksqnZkYibLbXTfBbHKIvF2H1XWaDbUsmbgouvAEM0wPn7Danzqrs0wak4HK7GNj
	yphJmhHqyyEr1tAGwS5/WDWpjjblaY6dv+aP0uQsDZ3syu+u/VRZEBxTEllRYOyCaZULq+fdxlN
	p+dFqw/qtX+/+wnkUQQvMKjcgsH7Z/MnGVD
X-Received: by 2002:a05:6a21:6e84:b0:3de:5a86:9dca with SMTP id adf61e73a8af0-3e13401e966mr4271507637.19.1791461354483;
        Thu, 08 Oct 2026 05:09:14 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2001:d08:1334:29ed:db11:2c4c:ee4f:606])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-892bb2a5440sm1480111b3a.31.2026.10.08.05.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 05:09:14 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	SJ Park <sj@kernel.org>
Subject: Re: [RFC] mm/damon/damo: saving damon sysfs configuration
Date: Thu,  8 Oct 2026 20:09:05 +0800
Message-ID: <20261008120916.4612-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20260930100031.7338-1-aethernet65535@gmail.com>
References: <20260930100031.7338-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CF3F580015
X-Rspam-User: 
X-Stat-Signature: 5ptiq1nsgsnzkpnbapnmys9naxm38x11
X-HE-Tag: 1791461355-950201
X-HE-Meta: U2FsdGVkX1+zmawccClN8AF3Gw8Y6TwR/fBEk9eub4Ex6znHnve2KWFfe0EQE+9h/Vf2e6lji3FHHP2WzW+0XEoaEnYPREj7X2TTJNwMTxbcxtYPNcYApqmq6lhV/qUIE4av/oRYhk4gwodjs/+YFboTCKfOWzcFKxWlQ3kLJ8xdzbYrNrTQ3q/HxIMwebiCXwFs6g8j1HHxojHAvyc1hZ6jzgBaLtdEB12NIBZeuOigf1EjulX5av7YZ1GdINwOrnSsAJYw1SWoN7b005omTg31h1pdrvz2GFz2YEX8T3rlxke0i2exjC1TqD+vfKoHO18BeKAcf2RF6oUQjptZEfl2kLwTapezVHXzLlp3tX+JtH6SR+sYx0R+EU5VS1B7wt4x1UaMcbzUj3VmnGmnaO9ZnHpMqVuvcNwEytej3AypAuVa+TQOJyTP7mmSSdicYJ2zLzvQEuVXAx9DtY+zCYl0TG+GjbIcYWXuMvIoiBou9ohPHvScK92G7xrPEDNLQkpDVcR4Qmsl4mGO3hFG+JQoQPJqcKDOANijIrBpFhzoJxxlYZpr2MH/3oKreCNbLO8SRNnY2rQv/K6RJ6uTVyaUBrVWJGYXlWCiWBORz0HWG+zVfuJ9CyDqugHSDJU5DCAxkCFzgW7mg/FjifFvmt2aMHtMyy0xTu5RKo6umxBedvBkhUs21JA07XGHCLlGIen7Lg3+m3DWYUuCoYud3tA9rXcW+kWLX+sKwyRvIyKor8scnJtlqBHNmgOXqIB2AJrnrf/Q9RnVQm3cNte/BC350iNiOfkNGmndL6ePkFroXn4uPBfnvTmwCt7MJdmI2WyGW02jiZxyAKWIzZ4qY8A1FZgPdwspx+XGioXgqqqwRkrfuTTfkVhog6SCNKNJIdbvBZVOSweUCD7u1vSyy7oOcc/Yl16mbZ7pktTOYzzhS/4HaudniAFp53bIBaEGfUIVCv9kqwdWjRdI1sz
 LlwizTtM
 AVRQf+7nO4d1sb0gl6XunDVQ6h3jzdSQ5jnRDcTI3aJREtqUb+EwnMjCuzR0lVxqiTMyzGpdCwNfcYE2/CtE16c8Qk4rGdkKvFKR+sN9BmOb21vbf86Qv8dX0M2zorMTF3cn08uJGItXpzg0tAiJGG+NsubryxOJWeV6OAOw9CX5MzZ+362Bjk1LNpGWp7DYC+PEx6gQeloUIXAjZLAQogbN7PgIcPppbmastn1X54aXNlQBbcQeScRKn+4mLAznlJqTaI5udFnCrS6VhnCK3JSg8Jn4nRTQ5zwkRu5bV5OCAVapfEULvzdKmuey21bx920U0Eh/F3Mpugvd1t7O0r1lPdhW83rrMLV4sl3UnhvOoVYm4KbcUL+RUrkHRktg13ncrqILex2EXP4OpEyOPhSTW5keqBA4ReApMRsI71SjaG3IHqFkyHRunDpZ5MFI/rKAKdsJyUkbZlQ7FENNM6tnqEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

Just a reminder, I think you might have missed the question I asked.

On Wed, 30 Sep 2026 17:58:54 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Tue, 29 Sep 2026 00:43:00 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > Hi Liew,
> > 
> > On Tue, 29 Sep 2026 03:13:06 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > 
> > > Hi SJ and Community,
> > > 
> > > I've noticed that damo [1] doesn't seem to have a feature for saving
> > > DAMON SYSFS configuration.  I tried 'damo args damon', but it doesn't
> > > save the DAMOS schemes information.
> > 
> > If so, it is a bug.  Could you share more details including how the issue can
> > be reproduced?  Directly sending a PR should also be fine.
> 
> Yes, this can be reproduced easily.
> 
>     # make sure DAMON is started
>     $ sudo ./damo args damon > damo_args_damon.json
>     $ sudo ./damo report damon --json > damo_report_damon.json
> 
>     $ sudo ./damo stop
> 
>     $ sudo ./damo start --kdamonds damo_args_damon.json
>     $ sudo ./damo report damon --json > damo_report_damon_after.json
> 
>     $ diff damo_report_damon.json damo_report_damon_after.json
>     4c4
>     <         "pid": "4959",
>     ---
>     >         "pid": "5582",
>     16,17c16,17
>     <                                 "start": "4,294,967,296",
>     <                                 "end": "15,807,283,199"
>     ---
>     >                                 "start": "4,096",
>     >                                 "end": "15,807,283,200"
>     25c25
>     <                     "ops_update_us": "1 m",
>     ---
>     >                     "ops_update_us": "1 s",
>     46,159c46
>     <                 "schemes": [
>     <                     {
>     <                         "action": "pageout",
>     <                         "dests": [],
>     <                         "access_pattern": {
>     <                             "sz_bytes": {
>     <                                 "min": "4.000 KiB",
>     <                                 "max": "max"
>     <                             },
>     <                             "nr_accesses": {
>     <                                 "min": "0 samples",
>     <                                 "max": "0 samples"
>     <                             },
>     <                             "age": {
>     <                                 "min": "60,000 aggr_intervals",
>     <                                 "max": "18,446,744,073,709,551,615 aggr_intervals"
>     <                             }
>     <                         },
>     <                         "apply_interval_us": "0 ns",
>     <                         "quotas": {
>     <                             "time_ms": "0 ns",
>     <                             "sz_bytes": "16.000 MiB",
>     <                             "reset_interval_ms": "1 s",
>     <                             "fail_charge_num": "0",
>     <                             "fail_charge_denom": "0",
>     <                             "goals": [
>     <                                 {
>     <                                     "metric": "user_input",
>     <                                     "nid": "0",
>     <                                     "memcg_path": "",
>     <                                     "target_value": "3,000",
>     <                                     "current_value": "7,855"
>     <                                 }
>     <                             ],
>     <                             "goal_tuner": "temporal\n",
>     <                             "effective_sz_bytes": "0 B",
>     <                             "weights": {
>     <                                 "sz_permil": "0 %",
>     <                                 "nr_accesses_permil": "0 %",
>     <                                 "age_permil": "0 %"
>     <                             }
>     <                         },
>     <                         "watermarks": {
>     <                             "metric": "none",
>     <                             "interval_us": "0 ns",
>     <                             "high_permil": "0 %",
>     <                             "mid_permil": "0 %",
>     <                             "low_permil": "0 %"
>     <                         },
>     <                         "filters": [],
>     <                         "stats": {
>     <                             "nr_tried": "0",
>     <                             "sz_tried": "0 B",
>     <                             "nr_applied": "0",
>     <                             "sz_applied": "0 B",
>     <                             "sz_ops_filter_passed": "0 B",
>     <                             "qt_exceeds": "19",
>     <                             "nr_snapshots": "0",
>     <                             "max_nr_snapshots": "0"
>     <                         }
>     <                     },
>     <                     {
>     <                         "action": "stat",
>     <                         "dests": [],
>     <                         "access_pattern": {
>     <                             "sz_bytes": {
>     <                                 "min": "0 B",
>     <                                 "max": "max"
>     <                             },
>     <                             "nr_accesses": {
>     <                                 "min": "0 samples",
>     <                                 "max": "18,446,744,073,709,551,615 samples"
>     <                             },
>     <                             "age": {
>     <                                 "min": "0 aggr_intervals",
>     <                                 "max": "18,446,744,073,709,551,615 aggr_intervals"
>     <                             }
>     <                         },
>     <                         "apply_interval_us": "0 ns",
>     <                         "quotas": {
>     <                             "time_ms": "0 ns",
>     <                             "sz_bytes": "0 B",
>     <                             "reset_interval_ms": "0 ns",
>     <                             "fail_charge_num": "0",
>     <                             "fail_charge_denom": "0",
>     <                             "goals": [],
>     <                             "goal_tuner": "consist\n",
>     <                             "effective_sz_bytes": "0 B",
>     <                             "weights": {
>     <                                 "sz_permil": "0 %",
>     <                                 "nr_accesses_permil": "0 %",
>     <                                 "age_permil": "0 %"
>     <                             }
>     <                         },
>     <                         "watermarks": {
>     <                             "metric": "none",
>     <                             "interval_us": "0 ns",
>     <                             "high_permil": "0 %",
>     <                             "mid_permil": "0 %",
>     <                             "low_permil": "0 %"
>     <                         },
>     <                         "filters": [],
>     <                         "stats": {
>     <                             "nr_tried": "2,000",
>     <                             "sz_tried": "1.801 TiB",
>     <                             "nr_applied": "0",
>     <                             "sz_applied": "0 B",
>     <                             "sz_ops_filter_passed": "0 B",
>     <                             "qt_exceeds": "0",
>     <                             "nr_snapshots": "172",
>     <                             "max_nr_snapshots": "0"
>     <                         }
>     <                     }
>     <                 ]
>     ---
>     >                 "schemes": []
> 
> > 
> > > 'damo report damon --json' provides
> > > more detailed information, but its output cannot be read by 'damo start
> > > --kdamonds'.
> > 
> > Maybe this is also an issue that we could fix.
> 
> In my opinion, this is not an issue, since there's no documentation
> recommending we use the 'damo report damon --json' to generate
> configuration for 'damo start --kdamonds'.
> 
> > 
> > > 
> > > I'd like to know if there is currently any way in damo to save the DAMON
> > > SYSFS configuration that can be correctly read by 'damo start
> > > --kdamonds'.  If not, would it be worth adding one?
> > 
> > I believe it would be useful.  Please feel free to send a PR.
> > 
> > Nonetheless, we added the json/yaml kdamonds config support mainly because
> > there was no good way to flexibly configure kdamonds with the command line
> > interface.  Now it is much more improved [1].
> 
> Thank you for clarifying this!
> 
> > 
> > I'd recommend using the command line interface.  That is, you could copy your
> > command line setup in a bash script and modify/reuse it.
> > 
> > Is there a use case that it cannot work or suboptimum?
> 
> No, CLI (Command Line Interface) do very convenience.  I can write my
> configuration in CLI and it is very readable.  Thank you for letting me
> know this feature!
> 
>     #!/bin/bash
> 
>     # update-damon-config.sh
> 
>     ./damo args damon \
>     --kdamond --damon_ctx --ops paddr \
>         --monitoring_intervals 5000 100000 1000000 \
>         --damon_target --regions 4294967296-15807283199 \
>         --damos_scheme --damos_action pageout \
>             --damos_sz_region 4096 18446744073709551615 \
>             --damos_access_rate 0 0 \
>             --damos_age 600000000 18446744073709551615 \
>             --damos_quota_goal user_input 3000 10000 \
>             --damos_quota_goal_tuner temporal \
>             --damos_quota_interval 1000 \
>             --damos_quota_time 0 \
>             --damos_quota_space 16777216 \
>             --damos_quota_weights 0 0 0 \
>     > config.json
> 
> > 
> > [1] https://github.com/damonitor/damo/issues/3#issuecomment-5655965736
> 
> [...]
> 
> Best regards,
> Rui Yan
> 

