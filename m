Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5D83CA9EDE
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 17:54:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAC456B0095; Mon, 12 Oct 2026 13:54:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5D7C6B0096; Mon, 12 Oct 2026 13:54:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B99FF6B0098; Mon, 12 Oct 2026 13:54:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 905D06B0095
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:54:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 18F0D40F24
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 17:54:37 +0000 (UTC)
X-FDA: 85314724194.27.4F826F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9FC321C0006
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 17:54:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o1FbeeFF;
	spf=pass (imf18.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791827675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=I9xvBB0EtKpUtLwHcLsg7GSToVO2MIO1az/h4fxZuAE=;
	b=uWNMaY9GV2ZSetImN8vDBKMRDMLzk4GLZUpbhUZpCkhwjOIcu/07x8bqEY+o8yw5wCDvrk
	ScLMQkQHe5WhCPZEuj5EG5rwkn8dzqbiLF00G0Fx82vTWW+5xdQUyT3d2pM/uFLc/xRr+/
	4iNnhO56PBOzGU5D/Zyxv4segYxbV6g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791827675;
	b=x/eTXt9Fo7E7zf0qXoK1FY3dSfonasb6O0wKc8qhtLwLdgiFAu27vZfiPbfaAimQVap9TC
	DzYUbsKhDC4EmOnQlHboy50OMamcL97ZaJrCQRlvzas2+g2hmiFH2m+jHuXdyzCDCK+lzI
	wzgzr4kPJNmHFx2Bu9KlU0vWJZ6dwl4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o1FbeeFF;
	spf=pass (imf18.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EB32941E4C;
	Mon, 12 Oct 2026 17:54:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C5A1F008A1;
	Mon, 12 Oct 2026 17:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791827674;
	bh=I9xvBB0EtKpUtLwHcLsg7GSToVO2MIO1az/h4fxZuAE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=o1FbeeFFWmxOOA5cl2s9SM+1Y8td8Gx3+QJtIiSilityfthUAzLTcM1/H0+s/YNXt
	 Wg4ghxMw9pF9ehwollFtfq5218JUI+0v35w952+mcQxLWY3azT6iZqYOhTPvVMPFzG
	 fzVMQ2Wr2d54uW9g9+jEhVZSgJKlDD+MkafTMjg36rRRE8sjWpbLv4Fiahsrp+5Hhj
	 rZN+O2+vkO87Axs632TnLkmvOdYI9/XuGNsqzkTbQ7jURCGvVjYqkqsc+2UoLTse6G
	 xl2C8RsHS7EZ3DBEn+mxChgZEyZosOEWdjgfFZyVIH7Vfn64TmKprHy74TAU1am3CZ
	 BWFdpT42HwY7w==
Date: Mon, 12 Oct 2026 07:54:34 -1000
Message-ID: <a8c28761bfd1fe281b7ef4225464b708@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Amir Goldstein <amir73il@gmail.com>, "T.J. Mercier" <tjmercier@google.com>,
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] selftests/cgroup: free the paths returned by cg_control()
In-Reply-To: <20261011223358.2327625-10-sashal@kernel.org>
References: <20261011223358.2327625-10-sashal@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9FC321C0006
X-Stat-Signature: qh8cek3tjhpfs5k3yt5exwu5qf5ugahf
X-HE-Tag: 1791827675-50572
X-HE-Meta: U2FsdGVkX19pnfHZiv6rlctqh53WJdNWSLL5vyogTu41X5b1lxx2wUbSqtLPseeXjhGLWr9n5eMFceFv5IYnG+xxXWm7wZFmGNvXjwEEV0frh6zFxacrAh+HdxikJcHGM+6hbL4ApgC+wUE2KBgOPBpatfR8rKJJpHvutJBMyrfew6fW8NxZ6hteenhGv2G1vVNc9adEzv24TuxX25LwJ2LrHvNPSdNVmInsenKRox9ikN141Gq6vcz/TCYLvFexInKYRMg8MPyBcuJ3BLolpGJ0cXOoJCRSgiC85KFkaCvMEOLukUZADObA8FjQK0TBkTJMd9we/tLF7oOwp49kkMdOY/O2fqxnTv6wCeNN94MFi5EF+81NFs3roEzviXlXug/mdUWTxo90wrUt6eNF5MZCv2btkn1hj5AyJDoop5/qRQynRNvI1o37e3/KjvDlMDXMwAW7wLm5qPXGepoR5JLkmRcaqz6AW1HcB1yFe/8Y5wvC/vFPtC6R20rQF5ZU0tiK2yiVwtok4+notMWX9zxlx9FcRKLSRaPwpiSe0cJyh6g2PGodosuGaJK3TB4+E1uj9hXiNSDFoHOf6exzbDUb1HDwgppQEL+6euvhmhJ7S492qknjbQLQIwo5hyM2GB/mB2UpgFWzhm4neKY2sViyva8C7wfoe9yiSMzdunKEx3VUqQbeI5KYUHznhd9tHcSsCatcNQWyXieFet6j7sqi2idXfNfb7ulOi9fqEqBiLsExVQUi4gtFxP2CO9CGRR1NzUV4Svf+a0TQ6ccGWdJt4jjjW14TvRpPtilve9ZA7jj1XWZYLZIzca78KjdM77qE3QS9OpTXQBSYZc1eF0qm0N7Dp6ttH6yUkeNDPd7kpSOxgNJ4PkIwuCFxXPmNi0kyRO4/DOSWXBXAGpXgPeaVOxvG69pQzBILabgg6s/hVgobenmHlCwsShqOWS9P53SoOaSGGyufEY9Iobt
 Rb5YquFD
 rEz7+9X2r6O/ed0kAUJom9uDev3+7Jnw2oWt1ZC1XT3Qh5Fdky4ghBpgp4QObZlBxHc6myY5IwzMu4HUlt/nqMta0Qvk8gHMtj9a4/e4lFZcanPwe+rpP9I5NrY7MF2A/B5Ud5oCT7QnjmmqDSk8GIsYipm8/jQUp/LVqJwBmWXASbKi7RY+m5OTI/Saqso5vNEijdOykVTX6n+SSMM7EA6RNPYUym/YVfFnehuCAhMDVDVMI3UPbdkFbFcbBQIgAEvBSqMIlOc6MLINBmxITYdni+DtLnyAzX9/X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Applied to cgroup/for-7.4 with the subject capitalized and the Fixes tags
dropped.

Thanks.

-- 
tejun

