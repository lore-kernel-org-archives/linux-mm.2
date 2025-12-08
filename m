Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0A29D3B7E2
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 18:32:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DA046B0005; Mon,  8 Dec 2025 13:32:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48A6A6B0007; Mon,  8 Dec 2025 13:32:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C71D6B0008; Mon,  8 Dec 2025 13:32:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2D55F6B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 13:32:24 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 04D531A026D
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 18:32:23 +0000 (UTC)
X-FDA: 84197149008.01.A75B326
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 91D2D80005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 18:32:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ESVown7v;
	spf=pass (imf02.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765218742; a=rsa-sha256;
	cv=none;
	b=rpfCaTILq0/8uPnN8PnGVEEQmbPxIyF85evTdr20D5xWZ/CMcD8xiD63NJhjOpeNNhMAbV
	+as9YEj0dgl2ljxad5zlVDpEx79o39z2nHyGpVU1BA044cdh3UkJk3KNHS+x8fCfY3gpOA
	1UG//1uu/Bl0O5QBaQ0l4WPIsRJMWd0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765218742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=lwyd3jUPEWR/OhT7XE6gIc1zvmU1w9/veXbWHF1vMDg=;
	b=dJMlu/2yRPX8U1aUlsYAznL/cZdpODsH1hrCfXWJQq3+OmWEwqNDW97hynE74v3MXlbAC9
	Zl3mZBGTynx0qlzZGcoZ7r2I8v9kpFX+QAdNrHzFFWbsODdY2ngVkMjfgwkcCXK1vPNphi
	tZgDiHnx2BOo4MvkoOc73HldldH2cqQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ESVown7v;
	spf=pass (imf02.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DEBEB60173;
	Mon,  8 Dec 2025 18:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A85BC4CEF1;
	Mon,  8 Dec 2025 18:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765218741;
	bh=pCrpHr+5nP6rYJTv7XfOJuqw4MWXOL0/IjDzYaKEs/M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ESVown7vYFsf/+ZVQt3bYja9Uz0eFlRxif443ije8LEY2I/bZu0gl7cwBVXAt5dMh
	 kUoo+8H24YEWehD8j6z2wNQjFtCdps2adg+OWR/r3iKgpqB9H11autCk2IIQc8Z9Kh
	 s7OeZz1AhJ1nuKin1uBbcpE4X8C2oClaqkBiwVPzaIIeI+WVlU2+dG6TCF/4gs4C1y
	 PJYE7J4CiH10gEjYHlacSZjWlSQMCgIB5WSMe4Zv+ARTA2f4hCaDnVzyEmZZt7v+o4
	 QjamIfXPlnBX0YC/aGbZZgPgp3za2gqMGJWv9cpUehdGTgKfFIddpFf789CCINE72G
	 kLdW21k3V/RMQ==
Date: Mon, 08 Dec 2025 08:32:20 -1000
Message-ID: <6a075882857f0be33ef8361c18f54a76@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Koutný <mkoutny@suse.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 JP Kobryn <inwardvessel@gmail.com>,
 Yosry Ahmed <yosry.ahmed@linux.dev>,
 linux-mm@kvack.org,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH v2] cgroup: rstat: use LOCK CMPXCHG in css_rstat_updated
In-Reply-To: <20251205200106.3909330-1-shakeel.butt@linux.dev>
References: <20251205200106.3909330-1-shakeel.butt@linux.dev>
X-Rspamd-Queue-Id: 91D2D80005
X-Stat-Signature: u3du34hx6j1yfyqe7cxh8e8qspstznns
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765218742-184024
X-HE-Meta: U2FsdGVkX18CS6dl5od6eEzQ9x28NiN7NdggD22LftvmLvOu2915Uzu/xZGwiIQaPeY0yL3geUrofgJ9wZRELp4dfeR278Udo07xp+Zn38iD8r2uG7vlBvgxFQRgUH9iiT1qiw58bbLf3t6TEC4FGygjyQ8GM1tv008MAfosUUComfua3+qJeTr81Dhfu+h95RtXJ2Ub7ce65ZDxYtlrzxM26d88Rhx5jWdHJI4XGgSrxAjhKS/Rwr6c9Fo7JYMoriVOjKR5W47zzqVfgKJRnWWCURgk6RynPBJeKR5H6+in9O6z/1++ZiV1y8cwy5KG36FsNoOXe5xT9ZE2zbor9r42z+GsJKJVTRd+PnUfqEKijKN8OcZAupTFawwpN7w0a0JAl+ny8X4ib3gGPketpdzqV1e4ObAASSRgCxPSwHej9rX9jdiWI0T05Rdy1O75lvoOgmZkvKnHiLwinzMhvx1j6OuC8lkEPsrEBoCXzfHQRe9jr7a25edRDYurivdA56IfqQ/G1FKLh2b900qNmUw3Yf4bgcBj4djvTLKSWtbrBAo1LD31vVbiKHzWRMJCQiq/BOMVAcAJvR3DD1wkisziJxqTLpQpFyL/Xyp5lF5nk5eh8YMvJ9cKGOVyz+3d5JAMc/Ku6jqH26qZkq3UNCKkxcVcQ9DAxivqUZ9Fcp5+ITno+X5z5oETMdbYhkA/ommaROdx7ihRd18mxQVaXltQwf0j1EJuH2YFQejx3ajTPY65Vq77LmAQso6xq9o6oN0RZf2t8aVOJp2i7Pnf+zKFiRDGJe7WqC/RYreanHqfvL1ROVIiKo9WHCzF2xHjGstIXHRYrdVT1poFOimi0SVU1jR6N+YvM6t/RhwHvD9XZMzI0YwsPR5Y/QJbovh1plkRheohfffRO1d2QbgDaQSJuaHsUoMo95kz28nSpj/tdz7OFkg9heetDQR8qVPwaNmFEm/S+ZCwdm86WB+
 QML5mZYU
 UPYqgBEYTon9qkoIXTT8Qh4evHZRMzDSSl1kPWKYr+EEqNoFbbTgSm4RrGgoztVZte7KCeEH0NF9c1GTuYgKkllf3JfpEdG6KKLMLMDhrX19wrAreAVs6XZyUy8OmszRc+pXpmnt69W2q0LKq4Nh6MFnipNHck6CJ75Di5E/8riCIwvkDAHrb2EfLoKBPYmMlFqPP167+tt55twqZ6bmqU8IcO8Jfr1Zd1hSV30J8BqOtH0kUjf5U4Yajpw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Applied to cgroup/for-6.19-fixes w/ stable cc added.

Thanks.
-- 
tejun

