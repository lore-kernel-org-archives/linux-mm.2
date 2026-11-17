Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89C77606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 08:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y18VBIT/
Received: by kanga.kvack.org (Postfix)
	id 9DAF96B05B9; Tue, 17 Nov 2026 03:14:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9645F6B05BA; Tue, 17 Nov 2026 03:14:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87A356B05BB; Tue, 17 Nov 2026 03:14:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5DDE26B05B9
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:14:49 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E82CC1C3A7B
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:14:48 +0000 (UTC)
X-FDA: 85443899856.16.808C38B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5BAB080003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:14:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Y18VBIT/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794903286;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NieFNb0IP7ygZn5OYEOMV6bU3WMcArc+QcS/INHFvKg=;
	b=3OoZM+lAOrq2tpTpNiy9jNYVGuEHxQsMUHt1wmdQa93s66I/F/THAwkzrgT7myoMqUhDGc
	6o3iYvy0bA2Wj0rV4pZxI51wFIUZWvLOmfGHtD/400KtNyHUStEK+MW0SY9mT38swpVAhg
	Z95gL4mpSLPUKxieH90s/1Fqzi+F5WM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Y18VBIT/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794903286;
	b=Duy1YQNPGFWvrd7o0KzV0/Mwx82elaSocP+75jPNSlntiJ4iZgnyZfPsFZFHRX+939z0T2
	v6OKiD20Px4ZoDgAMii8gH4NS1WwSK+QGYTLFktE84guvW32fV+FuxTj/h/NMGbvPXQwLw
	oncG1n943jZMNZtYAjve9cjCLqsOX8k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C4B643C73;
	Tue, 17 Nov 2026 08:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A1F1F000C5;
	Tue, 17 Nov 2026 08:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794903285;
	bh=NieFNb0IP7ygZn5OYEOMV6bU3WMcArc+QcS/INHFvKg=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Y18VBIT/pwptP8Tw7/r9hzfGtbFrrvhwK98BqYurvZcz5QaYaNQcy7qFat9EtkGVv
	 aXXtdexKiPV9c6oqjwGzsCtwO+8pT8I7IR2GGycfNy3YB2RRxGRXRUw7ftWOw3HLgm
	 Z0zpS8nHObkS1HMjfZWRurch5gcA7oypw4rMTjzT02y1WdnUVuyFKbY6GwAb7oUrx9
	 B232s4kT127IK8XWvgzbaVIeUXeQ9robOEiCGWcVYcC7pq/eQmK5KB9wEEIjAqB2kf
	 AqOqk10ekXvohQGmeuiWoYBxYjwnWHwPpHQ0C7ConrSKOxtiRHOzQEKGU0WI2t+8sE
	 0haBG3/N3vqlw==
Message-ID: <sashiko-outbox-218403@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/5] include/linux/rculist_nulls: add
 hlist_nulls_add_behind_rcu()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Max Kellermann" <max.kellermann@ionos.com>, akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, linux-mm@kvack.org
In-Reply-To: <20261116081403.216452-2-max.kellermann@ionos.com>
References: <20261116081403.216452-1-max.kellermann@ionos.com>
 <20261116081403.216452-2-max.kellermann@ionos.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 08:14:43 +0000
X-Rspamd-Queue-Id: 5BAB080003
X-Stat-Signature: iofkic5f7mzakj576msf5i8dfr7wf36n
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794903286-658886
X-HE-Meta: U2FsdGVkX18szipsJsSrBr7auMhBZ1lN7Q8FCiJgjUud7qFX5rE9X8HlM2jmPZ3x5tv/vSgcH1FcBj93pnKmCl1B9K5EVLEBDtLpBGN4DQB9eLn49m7xWmn4RUWCOSSTda7CTnnpqDjSixAhzLsRbgexFEsnXC9GUhu8EthnfFu0ICR2kV8A/mLfatV+lMulcFWiIbybCkX1NcCTFOIx4RGcIYcQ+7dGxENifOPMrQM4xBDU6UYfubUqZIAA9ZEZUKfDkDgxYDDehUwUrCb8FwAmHaz7NSNdQLEgawOK5xaDgMkvqPXdaGLZJfOJHkFCQLZLnNLixJZiERzJAyz0KJ9VwfodMxzJqii8mryW5Gk/Vhy6rVlfFxC77XEOmVbKxfiamJuByNTCGlmkgLFaH8FETeHpadkoc4WgUtHtQpjj/7+tfwMMI9Stiu6YkWrsrSn19/y6UPzTAtU1dO4A5zzXTpFONZ9EahK0cO822CZDARrGGcD/4r6MSF2sDxxd2zjsVa7FyzJvKuWDmeUtJvfRJ0okOt+r06xhwTGRIojcKQSifTSDsugy+9AEPf1IwbYmD5nFarIlVtn4TNvvnl1jz5j+QI0HVknNcRunapfwha730+nh59qVgJRxok9X6kLeLQF4zZ1dOL/jjp3PrYeVgewEBDveDhgwxO5YhZ1loCm9/4xOMqlCCcxH1sFL5nVrgHX9dJvVuKFHWhablzsdnhEniJzjvHl/wo1Pu56sjR/OF1iah8xRE17K7Kp/f+3wbqmfxGu0ZKAAiahzjikYplIlDpwT/Qnh9PvBXP3Gzyw2w/XAe98EDFm3SzcJ0zWt82Es9ILnR1CtTHL566BbR0unhCMM7i9xzswfPw871ZiAE1+0mKZkB1ktSq1zmcBN0CI+H5TGekPNi8Ahymgxt1iJ2wwF0pWjYcVnZ8gudYsts94DRUcD3DxywiV1uJpxBNGHO1LBWsqZFlg
 vVVKGYYz
 VmO7oTodp+vMztmlKGNvrb4bqqHEv6zbXB8TQX09/IPFqxQ2HskDrs46fbrOAN6HhX/587QBc9huhDsHOmovV7TIhDGmsfkePzrOxc53CMSZd6Ap/JcwV0t4PzXbt09ARORlwztNd6/gqkOD1b/W41Ucd5+lJaxX2Y981XLsot6e2htQx9l41pxAkFi81qcXYM/yHVs5twQPlEGIieBmfvWCcFCFpLNtHK1WpalJuRCOZZzauc6ADdNscJgMVbLLdSH+JM3bf+JnEBpUU0/l5RbGkHedrKKtaUQkPFUVHF1B5Tf6Oa25yUogHV//lVtBbKMKCAWNT4G49GzDqN7zSKcVPnmrLZzlm4viguRmxVgnIIj9dEJHLT/yZxw+LkUTFGEhiB7m6Oei6Gq+UOY7c5oRFd4yh2xJJ4AfYY7+EEoMllogX4KDtsId3pKZKoRz0nB3se3J1J07XKLM9SjKS+uczNiPJcbpp8yS2UGDPJqOP5oSfxDLDz1xiRlmfH5DMyXvq0A/RY9LMIey8oadeMY6LgLsyDzHjTxHaLtvAi8zun8ODmm3lL7DkQGht85+TVy7yeXpu7AAOdI/P0vYYHtSFa2Q1HQ0RfkSd0ESzD7pcMOErp3/Ng+W4yEAOAhdYsldlz1LKNZbYJPNSn8RvqxBWSgwQuvJQu1MN4HtF1XH3HHs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] rculist_nulls: commit message mismatches
  hlist_nulls_add_behind_last_rcu()
--

commit 8be860a8b1d9e4863e4165df073c841c355f9d25
Author: Max Kellermann <max.kellermann@ionos.com>

> include/linux/rculist_nulls: add hlist_nulls_add_behind_rcu()
>
> Move some code from hlist_nulls_add_tail_rcu() to the new function
> hlist_nulls_add_behind_rcu() for callers that already know the last
> node of an `hlist_nulls` list, to allow constant-time appends.
>
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>

[Severity: Low]
The commit subject and message refer to hlist_nulls_add_behind_rcu(),
whereas the helper added by the patch is named
hlist_nulls_add_behind_last_rcu().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116081403.2164=
52-1-max.kellermann@ionos.com?part=3D1

