Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95310CD4F4A
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 17:37:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 014FB6B008C; Sun, 17 May 2026 13:37:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F08226B0092; Sun, 17 May 2026 13:37:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1D186B0095; Sun, 17 May 2026 13:37:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CE33B6B008C
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:37:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 658DF1C045F
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:37:22 +0000 (UTC)
X-FDA: 84777618324.07.90EDDC8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id B793CC0009
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:37:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B4Z0tbN2;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779039440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zu/LWTizL3SjAuLjTBQJufmfGg+ZRq3DiDPk4KVPVUQ=;
	b=p7yVtdbvXgdJQWwPMw1Mj7ZP3RF/KlsyQHH5wej0qFpMJuiqfDPlGPs5KQFlkKwXa3bUt5
	aw10hAuah0sLdtl2KgbWjHQb9WAj7IFNa7nYeC5fBpkwZUzFZQZg4v2NngVJ/JQbj0ofYn
	oGYFlS3UTRKAkxfcGdE3+6s4sBgUY/Q=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B4Z0tbN2;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779039440; a=rsa-sha256;
	cv=none;
	b=Uh27hQhTYuawjKeEeyGHgHhD+mlev6IK/xs7nS/6GVwYDMfLH0yQrZPN2ElU9qj1+ckl1J
	z+y6d2WV8DA9oCebR5WCpKX72RlBohiflVQGN9oZZXoWpG8LRpwMmmDSEZYnGQsVtMdq8d
	tjvgUgOXo4Hqs9SOys/eqU+KaFEM+c4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D07CB4166D;
	Sun, 17 May 2026 17:37:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCC7C2BCB0;
	Sun, 17 May 2026 17:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779039439;
	bh=heISmBIXKjYA/PcXWrm1JL8+liejO4P4u/DbNOAbEhA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B4Z0tbN2A1OK22DR42hgCLTmeRx4VTbKz4jGtH+Duv3y3zMD8eOlMeywPQbDJigkk
	 44MEeSgbeqd2X9dYLqF0yonVJwYbAwZf/sUhwwJCar3JMyRiy9c8/fvAG19SCVNwrd
	 +tNl+6zcVvLhE4XlYh2Aj7AK9pOCAVHW9CO/nBPNUjIZdwjljqlVr4Q6E2EVUCHaFP
	 6H0Tl7m0pZjaz99wHUTGiWRdcsk01uHOSqHLpiNN342xAYkpxCu3O47oti0ct4ojJz
	 0Sb6x6hX07KDWMSRHD7w+1tkaloJgZQq9UHL4Zb6fWrJz0pepF+M/cgRzx9q4Av3m8
	 H8c0BE05EHC/Q==
Date: Sun, 17 May 2026 20:37:12 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, shuah@kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, corbet@lwn.net, dmatlack@google.com,
	kexec@lists.infradead.org, pratyush@kernel.org, skhawaja@google.com,
	graf@amazon.com
Subject: Re: [PATCH v2 09/10] selftests/liveupdate: Add stress-sessions kexec
 test
Message-ID: <agn8yJVcdvPw8ZCQ@kernel.org>
References: <20260514222628.931312-1-pasha.tatashin@soleen.com>
 <20260514222628.931312-10-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514222628.931312-10-pasha.tatashin@soleen.com>
X-Stat-Signature: rnc15q97sfnce7yaqeztrj4nw5tyhcp5
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B793CC0009
X-Rspam-User: 
X-HE-Tag: 1779039440-232613
X-HE-Meta: U2FsdGVkX1+UICjgaTTzDou9tDod9JxqZK39cuHXRtNjuSsrCkkDQbZXsmr/eKKjO6FEQYH5NRMhfvVs56Y8ifIXQiwLsnCXzEOtDkFsNGo98NgebiCbToS1xR2WcLaO+yulHf5zoSLpqjShjE6z7v9izSlG9QuWf+Z0bYoRO7JrrV31JktA9019mAaBdMP///0Cf26KbS7Ys6ADFQOzTcr+ryvk2sqadtHydYFm2tjpekEJngt15a1vBSrh4MAF86GHnoKT1CwVLkgZ0yrk0LYPvdNgMTWGUaY9pjIDHCwVnTikr7eIyNdkmV7kl1Re/tx7I4yQnSYbc9fOUC77ifvnGOKA2QNSEXxr8D2MjFjoMwHR0Shvg85kAIODWcwP2PIROffSeyGqJFjwirCEHN330lWdzGouA7F3OYuS0eYqn0LZiEHl7+5gEcl4sRtEPdmHqpMudoO0uvkAUCwqpAijaM9ieCM09rxAdlYiI3Qkr9oR0beezXdK58q2KmGSEVo+oi7mvUcTCpbhdxgPMj2u12xs10Zus+gXj2In0ZC2kh5lUOZ3vKdrKyAA9HBIr7uvkZPyoKypR7eL9DrB9Aeai/zgraXxaHaRLOG2hijISNvbT0jhxplY2Jx7KROQGA8X/8+C722cvSame8g+eBg4hucXLzHc/Kt2yIlWKgU9vf2Lm/LHDiklS7i6PiDolpcj/Ao3AetVk/x/CWdDlBH2h5cfr6XIquPVVf1CrpHR+rN01TiRIoyJGktLQoDFDtZAV5V2p2hOQgxNqvPilB9zMXDSLsG9hAfqh9GYBfdoODg7Z807ZHQU2cz3pWoSfbgvdsctuVss6qf8fruwwhUdk13+Rij1qrM+ODDjTJsIqlJgFwP/KnSLg905cSd7bxiBIllPzdC0GsPAn+mCBNd4tuOW9a/uFABOsq4OPLsBQu8Ma8D3p1kS2KRgeQOIo0cXG5a8N6Yzz7BYBeo
 HKldAkgG
 da3rd2g9AKXojYCNtR7HqM8ru/FUMrpZweh0waHuYg0iiB2VyS66iofOpvM4asAhiOmbmA7+Hf1Ruh+dlhm8qqM/QzE8xogMTPlBMXHq94TnS3MBbXF0fPfxTUls83hceqsS1hY1Y2PtHPrBrBw+LKxbdpUH5FShfvk9/Ngr9UNfHe5WbBb1+3XpV+FTrxtu7uuIP+eJSKhmiUwZSXUc9kuJRmN2twx7JMj/eOTcDhU6QsVQu8lFSOjDmc0CeDwoihdCSoJw0GIBu2Mb/hShFDFbTNyVGvyH5AUTInQT17IH2oIXtaQuDZHWWO08dzOvurf+MfUlIfajw7w41FTbuGFZU8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 10:26:27PM +0000, Pasha Tatashin wrote:
> Add a new test that creates 2000 LUO sessions before a kexec
> reboot and verifies their presence after the reboot. This ensures
> that the linked-block serialization mechanism works correctly for
> a large number of sessions.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  tools/testing/selftests/liveupdate/Makefile   |   1 +
>  .../liveupdate/luo_stress_sessions.c          | 102 ++++++++++++++++++
>  2 files changed, 103 insertions(+)
>  create mode 100644 tools/testing/selftests/liveupdate/luo_stress_sessions.c

-- 
Sincerely yours,
Mike.

