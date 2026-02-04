Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48C1CE7FDCF
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 06:10:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6098C6B0005; Wed,  4 Feb 2026 01:10:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B72D6B008C; Wed,  4 Feb 2026 01:10:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C3176B0092; Wed,  4 Feb 2026 01:10:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3806F6B0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 01:10:48 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CAE7E1405C2
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:10:47 +0000 (UTC)
X-FDA: 84405750534.06.1159A7F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2166CC0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:10:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NkI4bZWQ;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770185446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bNEA1oSRUNJBdfcHa0bvP3GyJoxS4WmBiJF2RkADonA=;
	b=owMfmRknh+idhL4Yz0IV/l0TsrMD+3rt9obcW1S5Xk4bqaXr5zxApE/DiYn7ecbeNOkZJw
	llEF2Ro6r4cyiXamVIZQ0WYs5j4CN7fbf84GApfGpUtwbryVctgmwyWBpqr9nsRGoideBg
	JDj6KAqsW471iTyHbZq5F7cCUOEBR7M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NkI4bZWQ;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770185446; a=rsa-sha256;
	cv=none;
	b=Ut9sZwVKHT5VWPXSX0crhhntL9X5sRYNd4f3R/pfCQQ2FpFsihfXVeaCUIYjDCFC5GqEyJ
	/Labo5jD4vR4uvrxveuCUmhq+LlNz21kP2DNpm1c/6h3/CRG4r/ufSRO9XwszvXyfLbGT9
	iyQFDxj7jieNS1xA/d7g8qg3yCiX7VU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E10F24324F;
	Wed,  4 Feb 2026 06:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39EEC116C6;
	Wed,  4 Feb 2026 06:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770185444;
	bh=2+7q7BAWTscPnESAI1LjsqopjCDW1jQb9dSdY9Wkwi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NkI4bZWQ3WayfvQHAVZj/nT4OxlN7XmXWlB1ZLqEJfDEeM6pg4LU3E0D3zNzgL2ag
	 5zbyG5FyLGe7jx6/DQjLasWLFWjs5WS92gzftiDZg6oJ5aX+MUay0dgF1bUFHFzYFk
	 ofiBs/L9TMr9Llfg0fZDelXbmuXEEOUSvbuMxGh1Qy8CrMJRV5fR0n3b3PjZFffRB4
	 /U3fjrzyjRD7CSTBAHYyPLbTUt0c7OJH1MIVUUzc8kUZglwIBI8BwFEPmYbRXQGeGa
	 UpInk4M5q2E6lo2kN/vVu6jjGVIWtru1MJvcWeojMqERBiRCH2dkXfgQm5IPv6HRXw
	 9zKVRN1yD7RCw==
From: SeongJae Park <sj@kernel.org>
To: qinyu <qin.yuA@h3c.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/page_idle.c: remove redundant mmu notifier in aging code
Date: Tue,  3 Feb 2026 22:10:41 -0800
Message-ID: <20260204061041.112298-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260203102649.2486836-1-qin.yuA@h3c.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2166CC0005
X-Stat-Signature: fkosu49awcfsy3wrbffhakyyoybebm58
X-Rspam-User: 
X-HE-Tag: 1770185445-226721
X-HE-Meta: U2FsdGVkX192Y6M206RS8yJXGt5nv3OaFfE0dcyxOvQ4J+s31lm5/QIoSvixhCGMucvcfsdmKJxwqprqYl+DNDXauQDn4sShe7/CrhA3pIDBq7IHHsrMkvfrsgwsts57MvlWW/rH1wuSwLC5wM8Bs2S65vfF1U0yQiUNNsUyA3b+inpbyDPPkp780FZgAs5dPANzZHob4PVwig55lV0IkAlAAIMLI5CFCVaze5Gg0+ZJdr3QcaBsW4Uy18Mrq5oJGa8stIpHvpVwdkmObTFzggl2FR3TeM4WXgEskctoBbmsk9SZIRhk23XkdEhifimmS20GqtZ1UqF3TRl6DGSepYvQ+F5dgFWbc4EbUcBBLk/JvkabM8ByRzT/UKCSDPz9vLFFvqNFL5W6AOSWZxr94sFmFVVOiSinOjutMZj4GVjuPlbNls3viuZkLMUNimVq81kN8mNGF/apcyJqUOIdxGHyvNg2hIs+mOtWXYukUJTpI9yWz4qkO3ubFGPveyDEyN4iJ5SR1Zcecx8CaSf/PhoYaUyXJwPFZXAXo05fVO8mzvviROwKBvM89uvSzo6EaOy8w7s2QEEYkWJ9pq6U5+HftM8LAw9+snV3xU48rao8HbJs1jU9DGNOPjSxdN+bZ3YkcQCJFHaa2SOxkVVb346gmeapJAqfNJMstHQvMBMYG2ygEgIqOQEJhH69oJ68UUSFxGFQV2qtciuBUuD3a+C8hiiJJe1nbDAPixrTZWDY8IBd+68AGVFtx/mqr9HnO3zp5Njhrbh+2fuHQbZOBMIdY/Css6KcIPAckljkI7v2YZ3he1aJPNl8bxFjuoN4+qaBoT4ziW6L3jwt//C1CYiiQKgXBsW0Ssdc2R01MUpWGBslHT1TrvErATUMZVTcpz5+BHpiwBfiavEhKO7NbVnYoHGQuZTutcbdEwDp+QRxJFirQx37bN/ahTf1DyhwQdLDcr7zKS71h6Q1bDH
 M+SSfo9j
 6EsM230kONnfd4+WfT8XN1rdxm3YkV0qB4BICW4RTVVJO0x+AtUbQr4/G5YCp/tHze0vC7X8IRfAlQh0NckP0MYFWjfx/7KX6R6drtCi7orpcjEKqVasKP0DNKajOgGf95HwnV2C6ZkfL+7nwILEixLmQ4GZyGqxc3AKsJ2kzEUOnXBcy5MpsSqx3QqKMm4FDBXUQ3rCKGkDo/Oz0F5sMk0BecPCp/apatJXPzlg6lr3HhjfHOLsGYwBCy4d8O6kDlfKKQJm5mQwm57FaKwrzEe3K9NCIlOJUof7MOdM4Uy58KnL3dN2w8kZHtxauwYXCpeBPVsvOG/qQhXI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000018, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 3 Feb 2026 18:26:49 +0800 qinyu <qin.yuA@h3c.com> wrote:

> now we have mmu_notifier_clear_young immediately follows
> pmdp_clear_young_notify which internally call mmu_notifier_clear_young,
> this is redundant. change it with non-notify variant and keep consistent
> with ptep aging code.
> 
> Signed-off-by: qinyu <qin.yuA@h3c.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

