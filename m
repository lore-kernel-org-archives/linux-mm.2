Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95AFCC83F25
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 03:09:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B50C6B00A5; Mon, 21 Jul 2025 23:09:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28C4A6B00A7; Mon, 21 Jul 2025 23:09:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C9CF6B00A8; Mon, 21 Jul 2025 23:09:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0EB836B00A5
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 23:09:26 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B9B3D160263
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 03:09:25 +0000 (UTC)
X-FDA: 83690419890.25.F886F94
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1DA0D40008
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 03:09:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UDrsL0hv;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753153764; a=rsa-sha256;
	cv=none;
	b=UPrNeHqivurGTg0oWEGpvIHJFGD3O5yGyit4lJbeLhULTDeXrC63v1gnfsMhfFyBGQO6jI
	6GJsSpEml6n0hKEkEDIpP/zyFpEFEgIwxENrKEmMX0ljaLQ3IvKCpXK9j0YgoF0cYnpZjx
	l+YZdh6CtLiqMbd/Ye3cvx0nWnN1DNs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UDrsL0hv;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753153764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=knP6yPGiV0jD5nIrcKyChWTvR+bLXkdJSHgMkdOIZYE=;
	b=qHcCDEsW/xaDkrL7YPMKby+pqv7Gl3IWYwC7VHyj2AJoi5NPksi4d2KOQ2IxnRNekVrVcf
	RUeJxo0ygyAGsEBHgyLDHvtzMsqdvgf9AoMH4NDxmjUjSsPBZrh6tQ9+cmXkqGBX3dQrnE
	hitWexaJ8mqoZxZ+xIkxwZPn3y8Qz5o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 845C8A55ED4;
	Tue, 22 Jul 2025 03:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0117DC4CEED;
	Tue, 22 Jul 2025 03:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753153763;
	bh=3DA3Y3JFxdB7JXAPsUmGUF8PlIivhZaQxaEto41YdUs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UDrsL0hv9J71Vwcbfl4jjyWauYG79gPGqrXmYRC87svaGRTFkItr/viYPYhFcj98g
	 nUNLDVZSp6VKZyBz/mtE91e/ZfMqrVchV70GcxvyW0PtgK94eoPewmvWtcTJN6PPOE
	 dsua/pWhWGb0hLaHJ99E4s/6xVBjvwUvqMLloQkw=
Date: Mon, 21 Jul 2025 20:09:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>, damon@lists.linux.dev,
 kernel-team@meta.com, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 16/22] selftests/damon/sysfs.py: generalize DAMOS
 schemes commit assertion
Message-Id: <20250721200922.79b34a049af4a02947c716ee@linux-foundation.org>
In-Reply-To: <20250720171652.92309-17-sj@kernel.org>
References: <20250720171652.92309-1-sj@kernel.org>
	<20250720171652.92309-17-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1DA0D40008
X-Stat-Signature: m6ytgqz14ec6e43tf59gfokpd89jdatg
X-Rspam-User: 
X-HE-Tag: 1753153763-363996
X-HE-Meta: U2FsdGVkX19/gdZ85IhZ/jWftaJiHSvfXWoljIuyTaEQ9qMWzpynTLGhIxmg1A7sGpZBN8xoU1z+M16t0hEMbB8v+gKEFzY94wGeEKvz5R8YXGJOEoLNjFK1qE4fBTY+9Vh3VqIlk7EzuVrALDSfDoRhYvu21tuqdmCbO36yICtjT1X2gJhrGevs5v3buXt4hDibAcYu5dsOqpFwdIypq9YUwgxIAOSPZwGcXANq9UOWzV81UUBXfonFRV74g60CQzv8jk89G3ICn3F4p4WkaIISBGHB+HTCNSrWWmdsb7a4DvL3xF0qX9aayV8MCaREMgk2OG6p0T5eUI2D/eMiPfha3sBykZDlUgpiqDk0XEzwbLfy1oOmkI1X36OmwwKSh5363EgNBt/i3vcfHQGjDT/lluxtiQfPm6663PBVLPdOIW59VPBkjYttyT4UDfb308j92/ox4GgJHkxZ/K48yjtXN/3w8iO/tGr2DcIz7ODI+XrNFHvqv+THMYl97mugodJ5Z2KL1o/DO9JioDXvD02Zp/2+/kAigZ/0OgQJPugS6Bw+whPIHSNCkiJ8aw0+L7Un5GRdwWS8HByA0NaRsqo+TByvylxnWAg8O6jzP3gt3zaCK6JFsokHbno3xzGb+s8g6dyX2eQpsALE8jHSA6/hf+YLlvqh4DfAQbdtsPGyTq3Nvnme7yALUmykHIVpKzu67jWbxR2N2EPJAwl5BorNrEiDqu0P8ryce5eb1JVfEECH4o/eIEJB3SU8hsud2uPPwFbqKSLFbxFvg8XLIWSu4Nwc1a1+Us7f/FPJBGLPeadWSWUZwhXLMMlDqc7apXinhlIaUEx6ukatksvJvnCtUkf/7MwgQdHURWoSt0ZV0m10A1vyQ1IhYYzkl8sJQdNWr4Z95w8ndqz89aB85P/Dy95fFYWAm1SdlYiTcy4wzTZBet1XM98YT1ycYCrhQ5Fr3gk+9EM59kc6vYl
 iZ+q/TeI
 6u0fEfO6u3Xvo334yJIKIIcwhb5lsnaC55p5rE7DeVy839Vcu8gvumTOgM5G3ZVcF6gymXZa14UgLTFKiSjm2nt78uLpCfEp9ObM4D1g9VpmI8OB5xYkGYHz14ODICryUFU5F/CxNPARBJvb5qfbx/oIeR4cvzy9hu/wSydqKm3U2JJS5OdCXq/hPG1Z0OaMBPQTqub83lRTUv3rJ0Sd9E2eVaXrTOIj44hwj9jCL5hy+x0mRqNnU3rXOgl60i+IW639mwhn1IRBZOV5/vA/b7FAZjBO2VUWOl5hPcEdLIc0vDg8mOBBtnJGDxA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 20 Jul 2025 10:16:46 -0700 SeongJae Park <sj@kernel.org> wrote:

> DAMOS scheme commitment assertion is hard-coded for a specific test
> case.  Split it out into a general version that can be reused for
> different test cases.
> 

This patch has the same name as [18/22].  I renamed this patch to

"selftests/damon/sysfs.py: generalize DAMOS access pattern commit assertion"

and altered its changelog to

: DAMOS scheme access pattern assertion is hard-coded for a specific test
: case.  Split it out into a general version that can be reused for
: different test cases.

> --- a/tools/testing/selftests/damon/sysfs.py
> +++ b/tools/testing/selftests/damon/sysfs.py
> @@ -76,6 +76,42 @@ def assert_migrate_dests_committed(dests, dump):
>          assert_true(dump['node_id_arr'][idx] == dest.id, 'node_id', dump)
>          assert_true(dump['weight_arr'][idx] == dest.weight, 'weight', dump)
>  
> +def assert_access_pattern_committed(pattern, dump):
> +    assert_true(dump['min_sz_region'] == pattern.size[0], 'min_sz_region',
> +                dump)
> +    assert_true(dump['max_sz_region'] == pattern.size[1], 'max_sz_region',
> +                dump)
> +    assert_true(dump['min_nr_accesses'] == pattern.nr_accesses[0],
> +                'min_nr_accesses', dump)
> +    assert_true(dump['max_nr_accesses'] == pattern.nr_accesses[1],
> +                'max_nr_accesses', dump)
> +    assert_true(dump['min_age_region'] == pattern.age[0], 'min_age_region',
> +                dump)
> +    assert_true(dump['max_age_region'] == pattern.age[1], 'miaxage_region',
> +                dump)
> +
> +def assert_scheme_committed(scheme, dump):
> +    assert_access_pattern_committed(scheme.access_pattern, dump['pattern'])
> +    action_val = {
> +            'willneed': 0,
> +            'cold': 1,
> +            'pageout': 2,
> +            'hugepage': 3,
> +            'nohugeapge': 4,
> +            'lru_prio': 5,
> +            'lru_deprio': 6,
> +            'migrate_hot': 7,
> +            'migrate_cold': 8,
> +            'stat': 9,
> +            }
> +    assert_true(dump['action'] == action_val[scheme.action], 'action', dump)
> +    assert_true(dump['apply_interval_us'] == scheme. apply_interval_us,
> +                'apply_interval_us', dump)
> +    assert_true(dump['target_nid'] == scheme.target_nid, 'target_nid', dump)
> +    assert_migrate_dests_committed(scheme.dests, dump['migrate_dests'])
> +    assert_quota_committed(scheme.quota, dump['quota'])
> +    assert_watermarks_committed(scheme.watermarks, dump['wmarks'])
> +
>  def main():
>      kdamonds = _damon_sysfs.Kdamonds(
>              [_damon_sysfs.Kdamond(
> @@ -122,28 +158,7 @@ def main():
>      if len(ctx['schemes']) != 1:
>          fail('number of schemes', status)
>  
> -    scheme = ctx['schemes'][0]
> -    if scheme['pattern'] != {
> -            'min_sz_region': 0,
> -            'max_sz_region': 2**64 - 1,
> -            'min_nr_accesses': 0,
> -            'max_nr_accesses': 2**32 - 1,
> -            'min_age_region': 0,
> -            'max_age_region': 2**32 - 1,
> -            }:
> -        fail('damos pattern', status)
> -    if scheme['action'] != 9:   # stat
> -        fail('damos action', status)
> -    if scheme['apply_interval_us'] != 0:
> -        fail('damos apply interval', status)
> -    if scheme['target_nid'] != -1:
> -        fail('damos target nid', status)
> -
> -    assert_migrate_dests_committed(_damon_sysfs.DamosDests(),
> -                                   scheme['migrate_dests'])
> -    assert_quota_committed(_damon_sysfs.DamosQuota(), scheme['quota'])
> -    assert_watermarks_committed(_damon_sysfs.DamosWatermarks(),
> -                                scheme['wmarks'])
> +    assert_scheme_committed(_damon_sysfs.Damos(), ctx['schemes'][0])
>  
>      kdamonds.stop()
>  
> -- 
> 2.39.5

