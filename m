Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7346CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 11:38:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 231B58E0005; Tue, 11 Nov 2025 06:38:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 209C38E0002; Tue, 11 Nov 2025 06:38:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1465B8E0005; Tue, 11 Nov 2025 06:38:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 03B8B8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:38:14 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A1803140533
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 11:38:13 +0000 (UTC)
X-FDA: 84098127666.23.341047A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 026C140010
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 11:38:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pehIauIK;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762861092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pY9L9xK8wHxLuQ0NlG7Kk9xA/OQKorl9t2XGjBnL5Eg=;
	b=nYaiPcjz5kCpKtM8Z6X5pLw6MWNHEDHJGODAdQSPCYNBl1d6L11NLJgHug9baH/0C1qWG9
	HkCTete7kk3oKDDxqxwZdpHY01inViMMPxMbOt3H8fTzCoZwigVqz3xmUJnM0H1M+GVHfD
	gGAcAdfRrRdVTwSiebL7MdHcjrq/pD4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762861092; a=rsa-sha256;
	cv=none;
	b=IO6Mzcr1UzXDvDUgXXVGebtmikxSpBWSp6+c8NIeY4nIPUvvnve9ecdA28Bp1Sv+PaoM+o
	Ig2G5P5uN4HhNcUYLHv83AxrKsGnQa2Ez5h5/dW7UvkUvCJqxCrle93iAtLm1GKompjOAV
	JG1mOVPQJcPcNuJSyHYuZ1NJwLfw5ps=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pehIauIK;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1925143A3E;
	Tue, 11 Nov 2025 11:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F297C16AAE;
	Tue, 11 Nov 2025 11:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762861091;
	bh=S5ADycSWwbo0oJWVKz2x3KxEOZjqckRPgZDiM27t/rQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pehIauIKsvbG2Zaq34KTP+At5gcHBNcZbQobMUyuKcOxAdDZQDOP354dlL4pEJ7fp
	 gaCiwaZldy/pbEG/0s4HzQKCYKX32zOmCuPXvsyun5gS9Gm/POQumZkf2tNu4rbfWj
	 KDwHoMeUsKpfTUr2/bStcGQ3mTOrbx6apq2IT/axS/bTLCdTuoNHUMxH8KZVbwyKCy
	 bvLApif2hwTDRRBDOhHt6BTci3bIiuYHkhBCWaMksEE3/Gtd41qx2NIiQQTkXwQtVD
	 F6N1w0xfHL708CF80dEG1rkteHA7tKb+HsilhNtknYFOSPkJBmvsMam0SDsdewC9mC
	 +cmbb9FXIrilQ==
Date: Tue, 11 Nov 2025 12:38:01 +0100
From: Christian Brauner <brauner@kernel.org>
To: syzbot <syzbot+0b2e79f91ff6579bfa5b@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, bpf@vger.kernel.org, bsegall@google.com, 
	david@redhat.com, dietmar.eggemann@arm.com, jack@suse.cz, jsavitz@redhat.com, 
	juri.lelli@redhat.com, kartikey406@gmail.com, kees@kernel.org, liam.howlett@oracle.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, lorenzo.stoakes@oracle.com, mgorman@suse.de, mhocko@suse.com, 
	mingo@redhat.com, mjguzik@gmail.com, oleg@redhat.com, paul@paul-moore.com, 
	peterz@infradead.org, rostedt@goodmis.org, rppt@kernel.org, sergeh@kernel.org, 
	surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@suse.cz, 
	vincent.guittot@linaro.org, viro@zeniv.linux.org.uk, vschneid@redhat.com
Subject: Re: [syzbot] [fs?] WARNING in nsproxy_ns_active_put
Message-ID: <20251111-covern-deklamieren-ee89b7b4e502@brauner>
References: <20251111-anbraten-suggerieren-da8ca707af2c@brauner>
 <691317ab.a70a0220.22f260.0135.GAE@google.com>
 <20251111-dozent-losgefahren-0a3a086b293e@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251111-dozent-losgefahren-0a3a086b293e@brauner>
X-Stat-Signature: z7gj1yj9bmjr6uixrgzbyeqpr3rjktee
X-Rspam-User: 
X-Rspamd-Queue-Id: 026C140010
X-Rspamd-Server: rspam01
X-HE-Tag: 1762861091-388396
X-HE-Meta: U2FsdGVkX1/VGKhMBZc5Tudisl6+tKRuSga81XeV9L8Ud5vlczX1TkMnsAgEduDGkUcoCrwTgGFamo8ekziKj+A+sRq2EXZM0wGaBFRg6JLhGuiyEpUgOxL05ZFCAkEX946xYE2PijcP/uAbRmc0emsg8kQWP2lltkmIPnZ1LyubRqHwzxJAPaLpO0jMdbpyVx7KVcmy0gos6k9ytETA7exet6PZj47Qbyc/o4+ydoPC8btBWql+zW3YERgjyjmTcSiWCvHqwk5Ee0GdFuBhYMnX/Z9keppYjhAAvNovnO/INp388QrzFTgvEtCVQca5dbs7FEf74uRn/VBwABJ3HrLKg1DWs5B4n4rnW/MXrGcX0B1zGAovBNGoctshanHE2GSgopbwMTeR075Bptt+Zog4t0Snut2eTD7uuEpDHLKC95nQEHdEUoDeQt/dex/bkoDZVJiTBq4pfdCS1qnj6BK3JanR2141WxlJ+KLiPNtNtMWD0Ml4WEIPqdG8oJgDrHRV49vzJkaU88GCh4kDd0xd5snvtB57GdZ82bTPQ734DFARkRTc+kxw25F4mnrTR2LY58mP6Qe9dMt0cXstknX14vPullo+C3CMWANLAqE4Cxw9iGVDLklgB3fbwbIJ4Qf+UtvgxjMVkDCJhftSE1BTWE4xuCf3Fz9nhJPOOUjwLrDUoZBJUDjJZc1f6jrZwQR6Zcnw6vc9fiBS8PpOC8RstcRCXZsoyHM7d6Wuh9pSFKoXG/EhkD+xlNpgNd6Q/JWwgkQGWBURtUC1OD4F7vqL3yjEOemowLTvW3Op0pAa3u8Z1YGa+LGeHMFJB0LvvXY/45T5vSOt9n/OCMcvDshz8XBJxA8HGs2ZUJ/yS9YdimHMWqVRlDFea7AnkoxxKxSTebTyu73qyxGdAlOihuRv+vtrzuPqRfdHqVp4Fc7alWFBHfJin+wcgN/v4Ce01LBYmTPgafegdXKxHvo
 eA6IuRtw
 t+fZw+f9JsvIZ6WSLBQpa8T20dK25PO5nest2WqLQlnvS3x8TWlR/teh2XqWBq6eAyHAbLx9sxR5PevGjukxT6JAFNZ6PTtSaIj9Rt4y9W78Tdsrk8YvTgILDNJy80Qfto2+dDcFXbe6pG1J0CGPCKYSbPiKWk8JATx21BPAhrNMQycjdpTAlnX8NeUsRDAvztq1DVDcJnxw/LjXBmXldA1C68nCOJvuxPb21iO2+m5vtGoNSH4YH9uQgjKlL8qc2ZxJ/3v0bwWc4Z2XHGKb1BjqoD8gRT6hW1rVF6iJ0pWVZj8UIB9Fa7fisImoapXCp+YI1yhqtTtObTe9WmA26JAz5lf5nB15H/YpWRY/xmqFdUFWXqNNQfUiwm42I0SPf5a76IAuvkeRveEYhberx/Cyt4jkadxjvHcSDb5cgKvCuShI2EYn9N+q4BEvZOdooz1Sw6Xx/d0L2oS0XbAEXxaCK4KiBFpZ6AvKSGimO+sr8+roo5oNZzWFui7dcCtKsj5s34H2ACHDb1GS0zX4HuEb7WnjLg2OwF/ZJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 12:23:18PM +0100, Christian Brauner wrote:
> On Tue, Nov 11, 2025 at 03:02:03AM -0800, syzbot wrote:
> > Hello,
> > 
> > syzbot tried to test the proposed patch but the build/boot failed:
> 
> I think that's unrelated. Anyway, I managed to point this to the wrong
> branch. I'll send another test request in a bit.

#syz test: https://github.com/brauner/linux.git namespace-6.19

