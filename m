Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1589D3B7E2
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 19:05:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DC1C6B0006; Mon,  8 Dec 2025 14:05:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 465DD6B0007; Mon,  8 Dec 2025 14:05:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37BD36B0008; Mon,  8 Dec 2025 14:05:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 21DE46B0006
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:05:40 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C4FD1C02D0
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 19:05:39 +0000 (UTC)
X-FDA: 84197232798.23.26E7DC1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 598D04001B
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 19:05:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QACm7OBe;
	spf=pass (imf04.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765220738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=XpRjNn1mmaqAw8tIi+jFZhf0YM5j0DVMLFx3PKlmFl8=;
	b=jZCeks1Myu2PoHLhh928BNNWP5ss/Y/nRWGB0yxZg6jOMLHqcAMCwBIuN8bJqnkk2o3h47
	ZZiRnkCpzU3vLRjPAxeg6Tu/CmM/TJVTeWi3hBsOQb+ydIpM/kQdDBzDv+/RRRqgC63ZM2
	xy7IebLZNQhj66zmxt2jV5QoPLVaolo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QACm7OBe;
	spf=pass (imf04.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765220738; a=rsa-sha256;
	cv=none;
	b=YVah8WOTviiuwOEhng2IKjPOFL0nqedDApe8UgDMKZEEz+H+L1eJp3KDHREONI1TzaATLI
	NPq7bNGYP2q5TC2pdCUbhEP93zQ/5ADGTN6iD7PHqcj4MDe9CpSkB8jcm9U0FMXbn91xxO
	TG2TFtdzD2qbibVqRWgvoneSEyBbMLY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9290E60172;
	Mon,  8 Dec 2025 19:05:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2207FC4CEF1;
	Mon,  8 Dec 2025 19:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765220737;
	bh=XpRjNn1mmaqAw8tIi+jFZhf0YM5j0DVMLFx3PKlmFl8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QACm7OBevOVV4m0vcaLsyRIJY497hfCEdAtXJ9Hw9tpy7nt611ZGd6Y+jdYcjYhmD
	 fQRyagdHpRPobnSD0EwwwxJdMM3xSr4Bd5jDRBz9qyRcac5De/rV6cOn2mngL66dSJ
	 MpHi/OUL3ajC3l3R0RvuPeIcUBSdAXW9/6KsSHHRcGx5zY1AzGkDe5Vj9wBqP2wQ4S
	 TlSlnf4PQ69MrImqRM+vFJx1ptef7oJSWE7DAejN0GkpcjzIrZ59p4z681oMUdhjSm
	 kaCTpELiotFu57HQwfV2tbPPj+dL6ohrqGy2CCogoQYjgwp2ytRlmipwmeBGYK10Jb
	 kiuhs9LhCdsRQ==
Date: Mon, 08 Dec 2025 09:05:36 -1000
Message-ID: <258843c66b112a2d3015f0a74e09bd60@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
 hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, mkoutny@suse.com,
 akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] cgroup: switch to css_is_online() helper
In-Reply-To: <20251202025747.1658159-1-chenridong@huaweicloud.com>
References: <20251202025747.1658159-1-chenridong@huaweicloud.com>
X-Stat-Signature: s3a7xnr1g5s1crmukbbzszafm99bew5a
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 598D04001B
X-HE-Tag: 1765220738-962787
X-HE-Meta: U2FsdGVkX1/ocqAMb/A2ejOEN3wlvNutrDPOv+PQQiuoHCfLUQcesy23r6NtLZnX44IhHI1RWi+yCzsPQcX5hX0CbLz9ODPEQwVQB/7TUEimSLyu5OU/Nqa8TStJGqwfZ9dGtMeERiKhefCgQvZ5+ly/0UXp2yv+DFGkLycCXZ6nV4SeiebzH3yzoNb7bppcrkNfJ9adq2tvxkqpd+OdmWmGhZ2Lw3ZUMSG4MZliiEZ4NJZRsbzcAfeNd9H2vx6TOCpgwF+/v1xNS3lVqLHi9NkOrjEztQcz0wV9H5l8S2n7Y7Knorj3YUtS5qepGC8bAvLLBVkU3hK3+smRwUs+i8N3NGWd948WC6G8gUZPvSRTTM6GzaQpGayb00xeTk6KFhxrkzi2xeARVFfloVPImzLxXf2PeEVAN8gW8a1gAUZb0QGNdUX4HkunyIL2Ad2FId7Vf7v+vrCX4oyK58LY7RYqUVl0WZCOMKUW+OKQrm6G/f7WKWqCfq0d1K21qf/TE5GEHHLnQv5dCiyLgyRhZXugqO4+Re4jsC6lFf8mXG7nUAq84KdO3GTVHG5zQu15K/ZeP6nZedD3ry1nmB6IiFUTj1KaNdxXe4VK5djYc/5QeMLMncCjPhAi3yqC0Qo+JrGsb7W6j3r9aw+JAPdlzd+wBpwGDjxAXr6ok3/bs2qPRFF/mQD4hIVb3vSGFwrK/p6G55mIADDlW9b/OBZ4P+D7yt+PceQj1WeMQFB9+lrPLijcBMVa7C7g6hYo9GQ2V2hhvFSSnTDmAqeBNp/kcb8YZlBhRBgULyqG0/dnNcksunwXEkZpGXE9/106rgkAMjRjLLYvhG16XQjTOh+nRNKpY2czUgmgX91KeIYlcrq/Epy5owBD2U4L75bW4yEnRhGMIA5ManYFPDoe9XpXNtDNWS7fAu2aeC4bcHGDcgbTaZeibLGRmj0/FX3DEmBiJhGvIW2u/AnJoi60LXL
 OTIpcEV6
 wzrEfTXrg+ulxWHdHGRpn+qkSYgzCEnBwzfDonPFREYHYbneiEesD/uDy1xkrRWISiHPwehxJM9b8wDeDcTYCz+NZ3tS/SGCg8SoECmrITXOvo+VhAxAiU3EsIrHftPXf3yuD2EKezoDKR43piWF1l14Y3whBpZxpsFwuLgp8Nn+S/tCJVVbHARyRsg/WpK84JaU8PqSadTOm2lNQr1JCl8V4FtaEdnDER25yXZTe9AWg5ADcvPDr8scLd3KOShKVg0yfp70Hq0mxB7mK31QPjRpkz20//EJHphQC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Applied to cgroup/for-6.20.

Thanks.
--
tejun

