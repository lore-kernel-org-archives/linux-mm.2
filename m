Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 716D7C982C3
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:16:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81FFA6B00A5; Tue, 15 Sep 2026 08:16:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EF696B00A6; Tue, 15 Sep 2026 08:16:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 705326B00A7; Tue, 15 Sep 2026 08:16:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E7136B00A5
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:16:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB2DB1403E7
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:16:18 +0000 (UTC)
X-FDA: 85215894036.26.AD8F48D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3061E40006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:16:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CNterPT/";
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789474577;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NXoYVTwqvD2Mc3uJ8C8rBTgBxVVEvgW7tv7MPPRhfTM=;
	b=iSJXdWnUsLwYiLlr4hnjVe7bTsT4AorFCtJ0aQGJ7c7YROAzuCQcJu5bpk8SNi8fAqDxEn
	Y110v8edKKS2WcPcRrIEE4isVOHcyG8Rh0Nn89FxbKHcmek0tN9U2PCFuO0NFjW4s6oKlt
	tO9HjGi9Uoh2o4uTeRpOTri06NSL8pU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CNterPT/";
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789474577;
	b=VkTBCtVsMDnlVLhZWg1dHEP/DaZCuXRxkp4Gcw+2Aj155M3mVe0Z9PNc933u1hUy0c3W+U
	g2SHNYHjqR1jM9Trz9ioeTEn+Auc7HQO2gks1ut9BpZC4aXbo3OfQD9lAPpyGJ8NnHm69I
	7LY8tZgZ4+72k8lfElcBU6zB9sPqRVs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C1B07602A8;
	Tue, 15 Sep 2026 12:16:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99711F00893;
	Tue, 15 Sep 2026 12:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789474576;
	bh=NXoYVTwqvD2Mc3uJ8C8rBTgBxVVEvgW7tv7MPPRhfTM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CNterPT/ZD51jedu2KNQ9rOU/4D4o9j+Aviy118d7ID4ZpJ7DN5B0QTVxpbOLDEcp
	 WjkOW+IygybTEM7hIhEUp9B9F8q2tKZJbdjojW7c1kYBcsALaPVXdNvNpseaoF6sxz
	 d08hoYd15gcHpNwA06y/3FcZ6xOwqFvsocjr/EGRM5cC9tuus0kDJdaqEQg3Qm4M18
	 ZeSXiq47TwxgervFWeMWsQkRc5DykbFskWfeoeMxtxMfVCAG1jD+nF5Voy10SVLA4z
	 9vITY1nHgUqKUhmEPiCFbTS/22e9+k7WoslJgfuFNfW4pirOY8jtykHYXqI9jsapd+
	 +JW1ZdYPtifnA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 41/50] KVM: guest_memfd: stop putting the
 descriptor back on failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, sparclinux@vger.kernel.org, "Jan
 Kara" <jack@suse.cz>, "Jens Axboe" <axboe@kernel.dk>, linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, linux-gpio@vger.kernel.org,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, "Jann
 Horn" <jannh@google.com>, linux-sh@vger.kernel.org, "David Airlie" <airlied@redhat.com>, "Michael
 S. Tsirkin" <mst@redhat.com>, linux-csky@vger.kernel.org, linux-parisc@vger.kernel.org, bpf@vger.kernel.org, linux-snps-arc@lists.infradead.org, linux-arm-msm@vger.kernel.org, linux-hexagon@vger.kernel.org, "Eugenio
 Perez" <eperezma@redhat.com>, "Ingo Molnar" <mingo@redhat.com>, "Peter
 Zijlstra" <peterz@infradead.org>, dri-devel@lists.freedesktop.org, kvm@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-um@lists.infradead.org, linux-mm@kvack.org, virtualization@lists.linux.dev, kexec@lists.infradead.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, linux-hyperv@vger.kernel.org, "Oleg
 Nesterov" <oleg@redhat.com>, linux-openrisc@vger.kernel.org, io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-41-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-41-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:16:14 +0000
Message-Id: <20260915121614.A99711F00893@smtp.kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3061E40006
X-Stat-Signature: o6qfn4yj4htyuh6e9rsbq9txxbpas9sz
X-Rspam-User: 
X-HE-Tag: 1789474577-445715
X-HE-Meta: U2FsdGVkX18Tqh3tJh8yRLFIA8QpgJhKmW57zf5x7l8CMoZXP4k9+QEM3fDXtA4Jkoj9Pxu7xXCg/1GCIyMkFZpL6kmIajXrQAiPcVsQ1AEQBVEZnWxp1EfHYRyfPhuuvpUI7RJBMvqJRYEzZeY1qi/w3WU+NzrZzmSLJifc1QPltK1s9vgUDa7Ic0f/fBDvMHYKd6l1qrUi5Al1sBHoZI5MzIQUWfeTb/HqePrrelsef62cFKAECpaVlLb8p9uKmzQwRove/haoDH+bthnKnx2Gx43kV2vRwlzbuG12JjCGTo/BY3cUerzRcdoC606z0X0bCYdfolzxupkB8oeOvwF92iIipJV6DHyCgzYnFuwCa8mx4RXLRQR05TyV/d+usvkGzqGm2FRZSkmX8zviatuuzhg45U8OBy6q3ebvJiMW0x5q7PG0LB5CqUbfyZJ11i4ANqqBNZU76v6xQZDZS8xpuLNOmpXbnMN6eJUEyPU0hUoWi5y77qc74hWBBkd3R+gPYPjRWwHG8z6Lht4XnAB25Y0CBpPPMIHQzv0mdwvW5tPPi9yvQSw0PZqOrHrzOrdlMwB3+C7ylYUbLyK/ktCYMRZKpdDJGEYdLdTWF4Q2mrvYzCUXCYOIJkcGGKdqtGdnfH1l1zktEdy5T0++l/Mt+VoWu/kV3dCtV+k1RSQyvxYFhx09S6hU15eTHYWPyPhSEYiqSFNmVZETeHVTjgkjtJ9CpQG1+7SjUi1YnIxCA51anxZNq+c8XE+/g3WB3qsh8Ku8p/0bPhpCef0ktayfjm3SDwuv23rRQHMaUztvEzC18ADdquzx1rMgshXQeH9Kf8d7oBN7kKT45YS0EWDiDzn2h7RsDU9pbsZ23q0e6ypX8RKYcD+UchKKrMuN1+Hr4sXOy0j7zA6R2oJo8itDtHjaNKV0tTvHYBsFgVo9ZwpbsIzw3Z/oYgz3D9Ut/LCcGnxWHv/dvr8c8yJ
 gP8O1zA7
 j6vuy5PmfEgvRgta9cBMrdx1QR5wc5ch48UUWfpYOLZ0FWUq5zfUhRfvvoQeUSHTtI2l6WMKSRpHqRAGXiCSXeWuhQE2IQW+EdIg3JyBe9vrZ5RHu0sTqfkwan0PbxhutXa0PAIsORZeYygb8YYtIBxvbu81VStGmKwmGi6myF4YR/1DhhsuROfrUnso33CrK/B8z+hCL62adkAY2aj2n2qBC0Rk/f7EW/pY198xDyz1p60EIOHQs5Gkkp/jFcegEZ3TGqw5H9D9FTPvoPFLsTLtuvqjtWVs6WIPu2DM0w1n9A+N+SI34Ly/J9XQdvbeELzFY3VqO+1i08o9e9MU3cRtqdSLIPvptYQZhGCPGNw43EcosWH7kOHGnaxC5SsFTKqljR4puIvmNg0k7/n6kE0tMzgQvXmB5W9mgAGqvnaZW9w+WJ+Qeo6Rolq14GqmLYmvCl8op7h93LJsbxNBxDKgyydqTYQyxp0sYdCOQFSaJ9A1ZVAmW8u68zLqkQ1hK28yIECghrvWptv8HdWkPHXA/ZI5+WYSnS8hzHwXVUn5StEVcSFYHy4jlp/KfQY1zo9V8EPToy1qe4NIhEqlVNznR3++Dr0b4iwLKMqyh7PoSZBq/JM/l8ZbOsT4THQQKBFNEVc/teGNdjai18UBDKg+PGaT6HW6YKk1SrfU1Qxrtwhm/hgYMprbLmHY7OXPaefJZNZ68qNoWZ9tDsk7usTPVjO8sCCbr6pBRWtlKNNlDXXs=
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
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D41


