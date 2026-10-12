Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE83ECA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 22:53:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 933396B008C; Mon, 12 Oct 2026 18:53:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E4466B0092; Mon, 12 Oct 2026 18:53:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FAD16B0095; Mon, 12 Oct 2026 18:53:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F0276B008C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:53:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BF88E80AF9
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 22:53:13 +0000 (UTC)
X-FDA: 85315476666.24.6D7408F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2B2B640004
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 22:53:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UHYk4izD;
	spf=pass (imf27.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791845592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ra4bGU5hjwPdP+O85KwoDbWT6OIIoUm9wMyIS+2xy2s=;
	b=G3fCKLK9wh7fY8B36GX6AZlZQ/F8KbXE9js0VBZMBrqx50TfYogOT9xPOoEKvWC5v5E6fO
	SLX9ou5wWjiQ3l1UitgkcxCRItaUKd9xalxhxBmCD8iJGDAv3uht+mY+2QZdgNPXJ+0eUq
	foext7CDHV1I9NlfrpbeDWvEiegcuSQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UHYk4izD;
	spf=pass (imf27.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791845592;
	b=JkoUIYIdepYqRvnpyv5h4FEEFdD/92q0uOgVQekYKl0A08CmjKy1riD0TD+u516mz/jMN1
	Eaj+xHzK9EfLtFlQR4Pw67YV7Fd0GgGDff9f7wMluuh5EmLhfA8n7zzIPJxbdvacF33foW
	zMywz6Dsomqqvmh5rLUVGufTDKNHgWw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A9BD40DC8;
	Mon, 12 Oct 2026 22:53:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87511F0089B;
	Mon, 12 Oct 2026 22:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791845591;
	bh=ra4bGU5hjwPdP+O85KwoDbWT6OIIoUm9wMyIS+2xy2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UHYk4izDt9ut7uMMQpqWFwr56Ny20zA5aNpsnVE3JP7S146WcTtj8NZLl6qrbCfcK
	 I30FzqJsWyw9VgXv1XREvExc3ExyDxAw0a0tLj2vnTLYIsWl4b3/i7PLj0CrmyNggd
	 Sus5H2PWC9+0wvB2SMO+Gtet7yb13kbMBTPWGpmHQ5YJBM/J8N3ZGUtrDTGMnrlZ+P
	 l8LV7e71V3RrMBBQjfdepLAjRWT3VYZt+FM8cv40M9nk++qpcWhdHwNbJbVonkFd6u
	 BRxahkrflxFkJvj9bPfYnG+vKBXN02SGU6+RHmpXjfzBmq2WtIEoiJxmRxagD9IWBW
	 6MsljsI7Rr3vg==
Message-ID: <f9a890bf1642c63d27ce516cde0eec15@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Shuah Khan <shuah@kernel.org>, Guopeng Zhang <zhangguopeng@kylinos.cn>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] selftests: cgroup: fix the flaky and vacuous test_memcg_sock
Date: Mon, 12 Oct 2026 12:00:55 -1000
In-Reply-To: <20261012-b4-prep-vstor-149854-let-test_memcg_sock-compare-flushed-sock-stats-v1-0-bc864b1950ad@virtuozzo.com>
References: <20261012-b4-prep-vstor-149854-let-test_memcg_sock-compare-flushed-sock-stats-v1-0-bc864b1950ad@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2B2B640004
X-Rspam-User: 
X-Stat-Signature: 5rwxapb8df4h61edzn5ziirzt3rukab8
X-HE-Tag: 1791845592-603705
X-HE-Meta: U2FsdGVkX1+NEgBayUIhiif/n824lCImOBAx1hXsCH9BXkJSPE0doHkxsVspZHQfVvaZQoRPzlt2wQmBfgFoiIlZS9Pj6Jq974bmnaPeLsvZrswNrLwcU8kd4Tsj1CHDSYXgO1fIF7Yt5Ue3L1smRZ2Mxk3L99ksE1YHFuaeEPhWVmXS24haw+tj3E7VsmAsEl99ZdVPAsQVDlBRN30cqGPwk7kW3Q3h+Gqc8ivPnGG6dapHDxbFF3GVwI5TgdN+lqFNRS+4euwRVF+6xCrMsEf4PnEdjMgbSz+cjWrEm/Qiq18nO9TlauapVNjMRspP67+XjM7GlkomuPyGnlhblavNocmq6Nv4YeOFSvlQXJ8Hbts/V0IjTglSowd0FiYDV6zlSj7ZFvHTXqVlTg7XAWDSvcx/NYhGp6/lUeA9mSUX2wLd9BR1BDZ2nm4FtGCrJmj2GPxDIJAbalmwWm7Ua7UCcnsWreuMwUfdeTAR5cSqZXXCXcj6skEZszcVfm19zSfD705k2+xiJLiD1S2STYU//Ty65HQwur8OJfnbPjR+/pi4JJq+aMnriSwubYm64Foh0bY5K0X0n0tSFhjo0QnZjxFOWJBMSBa3/8Be/qAxEFYDHH0kSyuBlcWA3q6Snp5LdrmxDzl18CoVL5rtnNz1mJbZozNHm3LVEi2pyhXDPOGzUB+uMtI8mQXlcVepR7b4qP6Jd012BnWTI90m62WcKjrkWVdUgG851NIvG/Ei+YfKwT5bJ39DgkiwkIUtHoPmlRSz2PXsJAG04ytVZOW7i/1v+WPuWPWjx/68mi/iq4Wm32MNnjRPvVAqBxkqxaaJtkzCDTEAChxBfo1Jv1bZKdvR3W1dYgqwjWXd9wt6MrVfSu4nbjXTswMzS2X6yg438nwI6Rz7ZWVH65CnOmxs/WDI/3EYP73zstRsCdUeZ7vyZVTFr88Or2JNTiNg758Rzu02kTGKBtalbjQ
 mxXCn23k
 R3tbSGOuzAoTZevc8zHoSsY9rmPH4wWXyUp4fmc5GBmlhwE+ut+vimiaLmTlKEu+wHfpzU3iBrArlz08HVMQUx6xACbph7vPdDUosqO59d6Qa4TciOfXSEDcwP5EAINineG339IFiydEW0QcTUEgb3aOReXoFw6rDafUzokqUhgm0kQ30hMiazlEG40+Y5g19PJ9X0/AQJ2FeG9ih+wfm9OXhNpLld6Gzn4NHDivJS3Yba9gesc/M4PP9EB90vOCR9p4K3zXZN6Vtf63ODG6Bgjlx7wiw/rj43cGwyzMJtNZ+KfS1XMIZDgbHgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 08:59:04PM +0200, Konstantin Khorenko wrote:
...
> Konstantin Khorenko (2):
>       selftests: cgroup: skip test_memcg_sock under cgroup.memory=nosocket
>       selftests: cgroup: make test_memcg_sock check flushed sock stats

Applied 1-2 to cgroup/for-7.4.

Thanks.

-- 
tejun

