Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3BEE606A329
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 18:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KqB57ZyB
Received: by kanga.kvack.org (Postfix)
	id 93BA76B0640; Thu, 29 Oct 2026 14:43:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C4636B0641; Thu, 29 Oct 2026 14:43:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B3CC6B0642; Thu, 29 Oct 2026 14:43:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 556716B0640
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:43:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5D3EB804EE
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:43:39 +0000 (UTC)
X-FDA: 85376537358.19.E980D7B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id CDAA940005
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 18:43:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KqB57ZyB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793299417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ba2K0yn4sXATn4PEJjhjICZlb9eDtb5zCcKhX6D/8TA=;
	b=mjYo0PNSOB9rtgQDPU89mrX4f0AO3sO+itbzxntqA8XpO5fO3qWMkozf4TvJvkClD0rvCg
	207UFzyLnrImN9spNd0PFwj9JX3bIsPNBXNn38dXkIo5XHBj9KTeuR/Fxnv1inFgj0SEcL
	Z9C3a1Nf7zJ4QZrIWvFsd+iVqZx/8Yo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KqB57ZyB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793299417;
	b=qL7Wi/mEYdyRr0+Njl2VjmIxz/Oa8wm5A7BERux5Qq8Mn0aL2wR0MTOrSeB3/grE223ZVk
	DVGpOdE7rgIymzwDY5u1VrQMZfWs4ts3Nnkk5zcuGDbr1DGwJCtSqKl0KyrT/Rb4OBvhtN
	a4GqFoQlkSj12zbCvFbo9NEa088J5k8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0958542D95;
	Thu, 29 Oct 2026 18:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85401F01816;
	Thu, 29 Oct 2026 18:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793299416;
	bh=ba2K0yn4sXATn4PEJjhjICZlb9eDtb5zCcKhX6D/8TA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KqB57ZyBl+rNWmzhaUl88koNS267T6znjRZInstBkbc7Ck2//RGFluJirsbumaTiR
	 ty8Eiku257jINNacFaeg/brLMVaR3rx9pu66kXv8JNtb2yCEBDpOkd7HuZdMuWMETz
	 GJyytL/AmBMOXjwaZWIkPhGYDug/AhUu5zt93aRQlgunkDyc2LiNaEcczacBs+gsiW
	 cgukT/h+BJ0wBDNHjbcBz77nhq5Lyaad8VB9yP99NZlexuXhrr5V1ixKD2KU2UUCKv
	 Q1XFlN0n2PW0JoONgoYODoc8nd9sDEzusSps8ub2CdsmcwUFlh1azXnr+k2sgPbDNd
	 vD43kwovx9apA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	gregkh@linuxfoundation.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org,
	ebpqwerty472123@gmail.com,
	paul@paul-moore.com,
	stephen.smalley.work@gmail.com,
	yao.zhang1@amlogic.com
Subject: Re: [PATCH 5.15.y] mm: call the security_mmap_file() LSM hook in remap_file_pages()
Date: Thu, 29 Oct 2026 14:43:10 -0400
Message-ID: <2026-10-29-1-daily-reply-0003-remap-file-pages-5-15@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261028080719.1821-1-yao.zhang1@amlogic.com>
References: <20261028080719.1821-1-yao.zhang1@amlogic.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CDAA940005
X-Stat-Signature: e8ggb9iekm4ihrwdfejjmkqbz6joyce8
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793299417-209714
X-HE-Meta: U2FsdGVkX1+Sktu8hHHsoduWJIu8Q+aalSNaSAR+bcZGYzzJkHRTDxnreUmJeaMazOaZWqw9UEP1UB7q1t5ApjEbjjgUjuTR6whlEH2/nULC6nG9ejPm6dDjo/ALrKPRRQubeuE9bwktcKL1k7Q78ZouEkwsG1CWsfyveGsn0Ks7OKGR6BObGdCfGpqn5JZ/q3ThtKTLw30tBAnrVBhKy5bLCsuOcmU6PJUj+knP26x60LO0cqPYScQNAS4Ukn0scnVVguUynOSepqhzrNV4w5JuymAeRAVTb/AVhxphYsgRoRhKbSWAFkkKg9fQWzyjd1/6rfM+02gRcZfi2au9AlyhUETUct9KC9D1VR8fjv2EAgjtMuDSD8aNvl63uGIQQTua8SmXUoSUVRDsy+XoIA61k5291ZuGVSkoDHQxr2QFhHtSt+Wcmir4amr3eHzEVwvC/6vJPZfEYn/MMFRzFx1rFWyn7+0HMsxWzWqhxFuCfFMYOBDvqtBEw5z93h8J2MeS3CNc/V/EgardOqotvlsTWyJoK9+3P2YXLQMSN7ckFG5xb3RaGd5WLuFlJHwv7mlTBDDCgQXSjXb7kfm2tbi1X6Y2LSBIvqtE38TCVPYuA9oaajBt2tyI6aETbD8/rdXia5xu2TEVmIeyPcRCxS0wZdFyvUYigloUVleEau/LEuqmy2lnjI0z6Rxq0S/++d4BhgIfwHI1fN6H0o33H2WK9BWmoAUFrY8rJgifyFEaXqkWTaPQbMNKWpsOXioOgvJ2Xt2Sd8Y+5zaisSn0y7TyXSfKhtVfHdPXeb2XkimsJshH6FFbL9Bxgw80uYL25cTeOGxtITG2FFIIqzW2yiaXH9sfcQTQUN5yZMeGxBY/kiEDfg8XFIC69Aidu8Zcaa4LcU9ajDOz2Nnxuk03oemEFFO5f/NpLH4PazdFe2vjvdQXsBT2F/DWrJj3WDyN++nhNfxulWpSCzoZp3Z
 8mOhT/c8
 PQe7XiFQ2iyYZL+XllKwK/Ug/d23ts6fenA7h1y4JC1fRVbm8juR1Y1sBE5X/N4UlNV1e/svHKbgFCo6dcbK+tBFVa9qjVUPrQctC6xWm68Oz53Be4iw+As3x1bJ+R9A7gbofrFrnx6Fi6VZFMJMLky7+0AJT0ZYyViBXqEl9uh83c+pJ3EETPpVKQDprwltGmfIPogoGi/WVzEWD9ZF6zMDl6vD2xhyFsnGxQg5tIcNnlIzqwaaMiiEox9eW5AUkXQ587GPM+wTwclhZ0MpAawoMSqYzpy4YrXOYX7idB0PnUBHGouM1RBP+nHuiGt51BfB9gxEbRA3gHWo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> So we should check prot by security_mmap_file LSM hook in the
> remap_file_pages syscall handler before do_mmap() is called.

Queued both patches for 5.15, thanks.

-- 
Thanks,
Sasha

