Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C638C982C3
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:09:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8596B6B009D; Tue, 15 Sep 2026 08:09:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E2E86B009E; Tue, 15 Sep 2026 08:09:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D2206B00A0; Tue, 15 Sep 2026 08:09:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4893E6B009D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:09:53 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D4CF7403AC
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:09:52 +0000 (UTC)
X-FDA: 85215877824.20.96F4876
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3AF43140007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:09:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a4ZZV63E;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789474191;
	b=nNObHMxi0ovi+4tgh+mpST4q5FXa4MVUTDw31fjfAFzyVP4440GfUOw/DGpDs9Sehf/dNB
	GgBPmw5cmPxvcGE6fPAWtJ3zuF9jEMNLm0DylOW2HZwktpus3LRCOUhfetFpUnajUqMInF
	YwLLcRLxPcLSQaDAqVV7BWm3bIEp/FU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a4ZZV63E;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789474191;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zv1rNZvSCHkzISCnzIgvhR1XdclekSPPoj8rLv8Qezg=;
	b=rrGfEPUaLIaEF4V6a5ySPPXnGAifLbww9hHLyzkNR26o1mKlu2KPFxTw4XWIkQnKjZaAQX
	KWEqkLohnBTNJB34Nw7U8/9ykHBHk4DexT4EHuJ0/bNEC0ubXhfe1jm7g7ao7V2YbPlyIC
	jIqaA4rcw9svcDRIoKYLDCTXmjlS/pg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CF82C600D1;
	Tue, 15 Sep 2026 12:09:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464481F000FF;
	Tue, 15 Sep 2026 12:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789474190;
	bh=zv1rNZvSCHkzISCnzIgvhR1XdclekSPPoj8rLv8Qezg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a4ZZV63EloWFTnOUlHK58XwOK2rkeCsu03ufhBV72Tiipl5qWiGg8pKw75jRnalat
	 Px+Ej4QbTLpchvWen5UHVg+abfR3qMIoHWKRq5zOfC+6fvUdhpGBml50Plsl14BxoA
	 MD9L1UkPG2s8tttZuNhCrGp0Ac838MyFzPadcw7MIZBEqZ9CQQXdlYMZFCITTIwQVR
	 e8ZVbA+QeVGcVPqWoOLbEKnwhY2HpmkZP6Db2SJHGUaetI9dgl3FBXgJQQpNHkGFqv
	 7oyl/HjPvr3DAOtUTzbk2i14RAaCiMZAvTqJbij4737kik3jJY1RQy1e4vJFFsF6gN
	 uDBgNLmQTLN+w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 32/50] liveupdate: install the session
 descriptors when the ioctl returns
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linus Torvalds" <torvalds@linux-foundation.org>, "Christian Brauner" <brauner@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, "Jan Kara" <jack@suse.cz>, linux-gpio@vger.kernel.org, "Oleg
 Nesterov" <oleg@redhat.com>, io-uring@vger.kernel.org, bpf@vger.kernel.org, linux-openrisc@vger.kernel.org, kexec@lists.infradead.org, "Eugenio
 Perez" <eperezma@redhat.com>, linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org, linux-arm-kernel@lists.infradead.org, "Ingo
 Molnar" <mingo@redhat.com>, "Peter Zijlstra" <peterz@infradead.org>, "Jann
 Horn" <jannh@google.com>, linux-hexagon@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-hyperv@vger.kernel.org, linux-mips@vger.kernel.org, linux-um@lists.infradead.org, kvm@vger.kernel.org, "Jens
 Axboe" <axboe@kernel.dk>, virtualization@lists.linux.dev, linux-snps-arc@lists.infradead.org, linux-fsdevel@vger.kernel.org, "David
 Airlie" <airlied@redhat.com>, =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRh?=
 =?utf-8?b?YmxlKQ==?= <brauner@kernel.org>, linux-parisc@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-sh@vger.kernel.org, linux-csky@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-32-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-32-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:09:48 +0000
Message-Id: <20260915120949.464481F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3AF43140007
X-Stat-Signature: iohhk9mqcr44i1pzsqupf3jf58efo5fi
X-Rspam-User: 
X-HE-Tag: 1789474191-320882
X-HE-Meta: U2FsdGVkX1/pRL9RJixhgWojtfe4oM4o3w8rjjCOgaU6HpG3mQ3sxauhVlp1PtJdekwRcTSdJkT9a5r5+QbpCb3xK/iQmJMXZ8QxQuodOzZS6tLnGyrA1dMyQD1F45Gn5uYmDesIZaZ+ryJwGdU4HAiIQCPoYcWnhrlEPQl17nE4thIsAg/QdlT3e50q5Z8n/XizpGf1CbcUHfHjuzquxnH/1obx1trymlhZf9TmZzOkDZh/6/x9JO9ToDkhzTjTmPKHiQAMrKrMA4Iyf6R2imctF03WNYWUvsEMjSfDYQJkKrwrkhP2kOnJcPlyA2airNej2jJGuQJ21wyS9GMQvYKetRYBjojADdqGIV+31m4mWNGkgZaVMmmkHvRaQsI63OjqJHDXqLZP4lxYfl44xg8mIJ4tnBcFGf6MZMVCu2jaURkVm+pCaFhb17CkX+p+C8jGaLsJHorNzSqIL59tjFY2BEMHTb9iQpflJnHRAxiRFd3DQaTerPNplJ8/2HRhv0e7LKa11oazeboqMvwSui9q0sqiV0LLS9zg8bDBTuo6FHdNjw6KusZv4kH6zOSUO+Ob46iCs9GipybtQRsC0grzvv6FUyKepKBwIU5Y9nll4foanoA7S0Th/kG5wVlIpxmkjnjcp2SwhBtrALAfAzynVLcONKn6sg979ECdmCYcIgHraF0O8dEgnXlYKV/Q5LhevgKK3vBmb2yuBwbmkUevcatG93Jnro63zcik5mkkYcRvdChZymY8pN3hIvxLqSv05gpXiu1WTn3Tro0EbfVwNu5ODxmIHRpdLZEuvFf2q+TsPXWWv85qakPCFN4i7wUpsicUsGpZs3TUtM4ECBWXFjCNkcsi5QpFBYcY/O0lIkMNb5EM3WESnXPOWcpzAvlWY5UxJuiIJfWo8MZDp6Y5yTcrb00ifaa4pctAjDcakdl4jexDt0PYwULnLAuuT9mOq2n2D55i+CqAnx0
 J/R1PJqq
 3LfdYJ0NTHvtGvrPG3U3YNZdY2p4tQ/7KVCX+7fdqlJflMeJfFsQayrIgsKKXEmkks3Nj8TJX42nbdwcwuklh2z7dn5maAXwMIQFwPi3gQRked21dVt9va2ve2hu/0WvM1qI5a1Am8DrQvZ2aHyK55Kjp+wp2KwQZSZevmPhq7bSPjSkgR+Zpde5CHylgTu1u9BW4CCWW4PENMVvsGKUGTci+OjboGZ4TPb633b43svPU24Pr0CD3gECYj+Mu46FL/VhojVBZqTzx7xqYHrOP21eELqe6w8vtO9ekhM3nO0S28YhiIlC0d0KiTcrBMQrlCJZZ9SbADvJ3WkHoIwpKOPaubkjvqli0XBlj3gLKyn/CO4z0zyXIQOZCw+pRl4KGB4SM09jRrA2fVlqfqawkDPAfnILebqkx0brCXdurlvBaXpEeN0vbSd9T4qXVQl2LAOR6CX0t5jup0rLHo4mvaCogo2Q9uXb5mPHpPRzODltgllHgVZFBYmpARzvUJRMfv+Rv4PO5IxtzyRAjXQN1RPbEoIGJ+hwjmCc4bDRW5tMazcwJJ49EwMPmhVz8z8WLoa6YQREL/tDByZdgZyqYivNNTBB0X9D9ANjI3vPSCHCw4AFxRrZwmVi5AVLyb3tqHgVUHle91/isGs0BNTyWiOrQDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Rely on the fd exit path machinery.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D32


