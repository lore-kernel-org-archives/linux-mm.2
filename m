Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2A8C606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 02:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mYJWrpPO
Received: by kanga.kvack.org (Postfix)
	id AA4026B05B7; Fri, 13 Nov 2026 21:21:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A552E6B05B8; Fri, 13 Nov 2026 21:21:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96D506B05B9; Fri, 13 Nov 2026 21:21:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 751EC6B05B7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:21:41 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D74EAA0345
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:21:40 +0000 (UTC)
X-FDA: 85432123560.02.9695B5F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4C7EB180003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:21:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mYJWrpPO;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794622899;
	b=8eJmVPWnzyuktJZPg+wkD7K4usoRuMYcasAJUewqk/2pnKxjtMddx2lT6svI1uJhqSKCIb
	chWS/EH3YOkkS5bYScRHac9sn7mTf5GPjPzyoZJyie9i2he7OsG4odTdqKOXBylipZiCld
	Hfr2TwuQYZFQ2bu2E4/sECab2GDI3Pk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mYJWrpPO;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794622899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LNUYU7pXy4dPQv+n0/00gK7Iv0h5927fuy55p2uNzJs=;
	b=UYEKUsohCCI6NEz3ihwKZvT1RknbAjShvLxuq+iGyWGVV8+nlOdDvxDssUS/CyJPljaLcS
	S0Q0RtSfgwQZPTHVq9FGBm7aShY1L2EQ0jJbNEsqE7ywv7uUmBrNYyZ49mZqQwJDzrsJWt
	2+78pLOBZQmk5YzBMt69eU0Twxu8wUk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D8EC408E7;
	Sat, 14 Nov 2026 02:21:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E971F000C4;
	Sat, 14 Nov 2026 02:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794622898;
	bh=LNUYU7pXy4dPQv+n0/00gK7Iv0h5927fuy55p2uNzJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mYJWrpPODuJU1uwQd2fjcZgTZsCwjPpp54gSH3BU2DooVZjdSeMQ+TaX6vAc7QKyJ
	 OcB8opfbkOMLLHlhNvIiMvSw2T8h+sKA1HgSI2RRtv4/L9vZgA3oNUBwpk0j9o9DqA
	 s/0qGLmpOYEYQH6gi8+4feU5axeZwyRNa6FIgGClPVZc5gExATbuy+rHI68qeR7Dac
	 jJTCL6t2INh2nPv2mD5UET5BH4DFfrPffdf9TujQfaza4FWM7rnVPHLi6OAycZD4dy
	 1Dk2gIPO/LggKZh2OLUjp36ufjRjV8R/JtpXr26ikib7vv9V6PGxCh9e6aHZy0C1oZ
	 QUiA27aa34MmQ==
From: SJ Park <sj@kernel.org>
To: Jason Angelov <jasonangelov@ucla.edu>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] mm/damon/tests: add KUnit coverage for age_ms filters
Date: Fri, 13 Nov 2026 18:21:30 -0800
Message-ID: <20261114022131.110196-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113-test-age-ms-filter-v1-0-b99eab2f71bb@ucla.edu>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: woa3wcswmuqnznsjpdub75xo8azwzwcb
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4C7EB180003
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794622899-376086
X-HE-Meta: U2FsdGVkX1/7zYZWx6E6jeTsjPpXUHFGguvX7zagNHJXXhHnAr3Rx1otTpLI9HV0h7cAv2B1GPTUlDC1s9sOKSYkUlf2Q7swfV5SBW+c0jJu1UYnjoKOg7rJ528hURwpk7EPDcyt3iROFCdzXHT2n7EhmhMeI5dvpTW9DDE7SDPRWwZHlwQ3LUMdaGAuaf3Bn4Fcxzq32rEZCUJSEnFavaFxQo7AhKoQKK8xVRXkUmNAB8k5PwN04eAoCr++IedQdLfdS7HA9UROBa+zsduQlOXPxu/Pzh70RkXzx+uWuCSmSkHAeW3jPUmfep/KzW2s+8jJXAJ5LZmgdvd9cNyALtPYjvzRxNHj7iCTEECRVCe8J/N5bg3EIAMaWd6x2V6QB+d3xjeytULMJoA355ofRmCG88EAY5LipF3JweTCCBCSKveR2W1rWrgQmD00IOk/Q44fh7vmkI+yXS8oAg5W2GVFN8yZh4QpToyvtAlVgEEUedtZpjdg8q860YwyynLMn/AdJBEkmMDyVgliAln1I3fWjezl3KeC8r1o+dBhTDya1Pv3gNX2JabDdsxQ31jKIm0SLH82HjuRneafyd71h5Fi+2ja3hj6NICoEtCvOUAq+Yj/oQuCoozmjHmeAhn6+gGFQ8T4/3wLyVNXhVwBDqxGmHP+mG66ciH1lc0755Us0IaTVy1EubzVO5icG5oOB7Xl9dSATwdyC3Ov5gqJsMJ92fbtD2LMjWxPBd0h8zVAMHcXexkEyQUkl2Rpo+ZOvMX07XpJn/Oyjv+SwcnntncQtyxgjOj1s4yPXZ1bk7NQJHwXHnyVEw1lGdRzNdgjOdatKOltZrxxLBOuJqtq5Uc/clJCSh4cSrTrRoriq9PNRki1EOf6BctkwR0nR/ATq4VSRkum+6GYRnAVF2G8OzjWPEXSke97ThsSweb5RVPvehLnYK0hl2MwAsaIUU/gjBYiCynGSBDG/TSmFs8
 nx762Gc3
 fs+EqSU85SeDnGtGvRQk7U1F8FchD47TnArKYVTCHpQX48obvFyE3JGhMs8IuYgH1VBGSR+DueWaqPKbAJ5j2JsO56FKSzDQ4ECFkiUjyJqFi+nzVbxuloEcRMK6vDdyhVCPldxFQJ4Kmg46/HWwK44fgECvu4YaXPCX+JRtqtX1oMLo9IK2ZT/ovlYUrg8Abaj7Ys7aDe1Vo2/v3WnFSNhV9TAQtMxEzFsIMH7nBxU9bgwC2fcQZkq6eAn72gPQeeTQT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Jason,

On Fri, 13 Nov 2026 07:58:54 -0800 Jason Angelov <jasonangelov@ucla.edu> wrote:

> The DAMON core tests do not cover DAMOS_FILTER_TYPE_AGE_MS. Add tests for
> committing valid and invalid age ranges, identifying the filter as
> core-handled, and matching ages at and outside the range boundaries.
> 
> Region age is counted in aggregation intervals, but age_ms filter bounds
> are in milliseconds. The interval-change test checks age rescaling and
> filter matching after both increasing and decreasing the aggregation
> interval.

Thank you for this series.  I show only small nits in the first two patches.
But the third one looks a revisioning is needed.  Could you please address my
comments?


Thanks,
SJ

[...]

