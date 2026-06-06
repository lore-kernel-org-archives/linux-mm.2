Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC47BCD6E7B
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 00:14:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E42D6B0005; Fri,  5 Jun 2026 20:14:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 194EB6B008A; Fri,  5 Jun 2026 20:14:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AAF96B008C; Fri,  5 Jun 2026 20:14:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED4AC6B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 20:14:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2F8221A022A
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 00:14:37 +0000 (UTC)
X-FDA: 84847566594.19.4F3A776
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 91CCD1C000D
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 00:14:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hkWA6tH2;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780704875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2J96v+2qYDpkIgFeGdx7Pd22ECpoED3Ti9QEkLALI7A=;
	b=fTniqHgyQBlsgQbcynoIjMvOtUpl4W4f/CEN1A/P06gcg63ZpK5G2SVlvXLa2tYy+f82w/
	/TCNxMBSJhqgzh6fQlnUqwt06P/cgWpN+320xRGjfc3/IVvAC1CCvnN5Sx/OliYloUKdqJ
	9y3NQ1MT2hUtoniXPbGNTCLpgCG7eEs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hkWA6tH2;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780704875;
	b=aAoN+NdjabrJxC5YiComFYBYy/RKP+Lzm1Ad3s25KFkgazE7PY3PbUdLAUfCCOKBW4zsOT
	cyuWulC6Ek71sTKDiCV59PWXl+jQ6GRiOoDfUWwOxCntTaToF5jPqSB2AHtu+2EF9bGgAl
	1oWOh89PAeNizrRw3Sw+bwm9+jeBB4M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E1E40600AE;
	Sat,  6 Jun 2026 00:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 401851F00893;
	Sat,  6 Jun 2026 00:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780704874;
	bh=2J96v+2qYDpkIgFeGdx7Pd22ECpoED3Ti9QEkLALI7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hkWA6tH2aJAACRpgfCpLj5xYmf5yi3+m7zVtfAnv4YUpe/dByCjyjhQighgfqYSz/
	 0URRiAWvfCFrPXEDC5Amv07ReKrpnNVRFzIYCjX968cS/mXdItTAp9K1Q2KKYySoBB
	 0E21ounHpT7VUzFUbagRp+sedEk+9qTA4y1bCF8LRCOPSt25UpdPyJSkbtkBd+9s1p
	 VV//wGshhVuhjB3KG+xi5NIBrC/zffOycHkV+oNhT29I+rnXMWgIBJkkYbfkTr5hsm
	 m4/dmryJtEm7M3aeuHP3ljH6Z7bKDTfe0Q+EGqU8gDupY/q45s646hIi9XklAcywh2
	 VFh2eDw962Fvw==
From: SeongJae Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 1/4] mm/damon: Introduce DAMOS_QUOTA_HUGEPAGE auto tuning
Date: Fri,  5 Jun 2026 17:14:30 -0700
Message-ID: <20260606001430.88471-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cc60cd6b-d841-4b5f-b3f8-b5dd39ea5808@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 91CCD1C000D
X-Stat-Signature: qy5nk5y4i3t8afienzxzzgxmgo4cfxsu
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780704875-890201
X-HE-Meta: U2FsdGVkX1/FCvHecXjtNoYzoD2LCyCfWGZuRYg1KJzBxeVJUrz6rvn2xUOD3MWFGNpFCeptzzzZOfTu8d5tG0Al+uu2P2s4Ojfu+ICRHuAsUItymXCaAJOv8n4IKx/ZENpqhdE5U/M3DR9fNmPXDF7RWoH/TCv5y2LbgS9SO5SV0CeCJpcloYFz/Qo+VZptXoC4jeJXkY2MgqM4f9wBJ5WSD0T7nIjnjjatJ8nN4w07qvVaZ/5Fbt9PSuxFVNtUkt9uuX1Kn7Dlxl78FvgqByLDlOHbw3qNvxsJaXWzW8ueGMHWxcfenoy8N5p57go8X5FIXNIUZSKmPCWX+yIV23+v9bYhJBJDCawFnuTGxvszhLQoqLc1bNc/B9+6eZ096+yLXfd/8M5pZUHTAv+YTNdMKt08Eq0L25N7nAFo9slMaPt/loEAsgR4L/f1lWWTBA2EAwF2itm9QMbxa/uTnAJskaMx/QcZDG8uSJ1K6wEE47NfFS83OlazGsMPGZwV1J6QECRXwGXfcQnohgSDZ2tcReXy2phhleXM0RakB3YCUmNWegNd8keDsLTgWSZidPicctveBaIv1E85ymXMEV5/ZJoIx3cqSU/N1S2HWD6rSRSl7gYsv6BWeELCNt5Lceo1dYZEWSAtIIfroYegzgptF047lQ7KQCN8aESmqvLItoqa7sp5zO841b1qWMYLTUlf83u75m64v+SFpUzVV2NqI2oSrLD46LnmXRLaVH3ud0n4VUKH3gRQWiklQEp2YiJKXHruL+N3CRUAWO+bBAGqbNmaFOuYYzsZKkKQ6kDD4XruaCyoL8XwJXyt31w0TJc7j6PyzUADL+L498vY6SobFhFTNycH+q+l3NLACJzg17GfdHczB1zf9ws7BW7VdUgK/e1NqRP/XWZQ2FJEXiDW1A0zgdBz4LoHmvQWAQmTRUdxIPgNvQOtS5OZNvMiU0/zAkDsy+Dy9ZOYHQJ
 YqSl2qY7
 73tb/e3QYnYwpekUspOjwquwefvA273DBrigr7regJAZ6GibWl+rvNFK3Nxrd1jx8ypb8mbX+Xn1BQ0+HSLKFPlgr0z8dExDaFY58BIL1SP5sMC5kJM4C2s7Br64MdQCy7I66thk2ldRIup7QML3ZsbdWleJOxL+gpJ8CU36YITZOQwDsI6YRoV3WY3p7T7BVHlP3R+tNIgA8aaxVWPn1iF47dAux0dMk9Dglxw767RVdRO4XQDbT7zDpYTwDkPiH9b8J/5hXUE5I45lXUjkyxzbTJnEoanoFlosojTyAYM3UGPpqBVZUqmOvV9nX0qIe/IH3CznjjPE5FOpA6FzdzBuCQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 5 Jun 2026 14:00:09 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> 
> 
> On 6/5/2026 3:44 AM, SeongJae Park wrote:
> > On Thu, 4 Jun 2026 15:03:34 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> > 
> >> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
[...]
> > I wouldn't mind ignoring Sashiko's 32-bit concern, but do you have any opinion?
> I just answered. I can cast 10.000 to unsigned long. I don't think many people
> using 32 bit systems will use over 1.6GB of huge pages, but it makes sense to
> be safe anyway.

I'm not sure if it makes some change.  Let's keep discussing on the Sashiko
review thread [1].  

[1] https://lore.kernel.org/20260604151932.93C431F00893@smtp.kernel.org


Thanks,
SJ

[...]

