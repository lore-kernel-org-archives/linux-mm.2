Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3903C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:17:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D985E6B0088; Tue, 15 Sep 2026 08:17:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D707C6B00A7; Tue, 15 Sep 2026 08:17:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C892E6B00A9; Tue, 15 Sep 2026 08:17:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A38116B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:17:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4B0CD160389
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:17:47 +0000 (UTC)
X-FDA: 85215897774.26.B53E8E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id A99294000B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:17:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T+YTN+mc;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789474665;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DwzX8JNIUuVMxDXzFkUeKbOg0dKKxVjarPGggP7ls3E=;
	b=5Th390cYyjHwFrF6zzHFZ9xK0OIbjDMql/5e4vEUxAIKfHOMCF37/pqNlZEu8nmkmqIrQ3
	PKoUisB45Ify7etDP9XmYMqrbmHKlsZQuzkG/P6Zrm0pCRnZjJDv4BzM5rOouoC7IYiVPJ
	19A7pBJi0PBrdPl5fLMYpGcTk7BELVg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T+YTN+mc;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789474665;
	b=KPq5+zNMMTr5YI0X63gxv3ZBfwd3Wti0CuINwIeWXQZXdrCdtA+7lNuS6aEX9q8tD9vWDq
	vUYapKe2T+XII97rdczsrJmDWE9/xYp7ujDYpyCbV+5DnoSEFpFdH/dsF0Zwa2GQFDc3vc
	+NuPs0+3m+QUVDZ0rNX99f/t/DazWM8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D8E1F43247;
	Tue, 15 Sep 2026 12:17:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00241F00898;
	Tue, 15 Sep 2026 12:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789474664;
	bh=DwzX8JNIUuVMxDXzFkUeKbOg0dKKxVjarPGggP7ls3E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T+YTN+mc0FREo7pxVue32qEB7jpbaic9tPuOqusrLGz+h61wQ9mk1jbsp4T4uum+o
	 PyFcrywxhBL6lkrZRNcnpslokzefZeAzR3ILqmBsMGWMqYv8jIXs9vvVcxYbK2/0GC
	 eaxftvggM2rbYvLpD33hv5D2hCTVmB4HxTZAux7lFOj7n37ELzTfsQdzy7w4+7zax2
	 OOhtkPuMszdn+0PFv34fTrYHBBJ5CYYMe8NNjn6CDmjHaFQhZDHc4EM+U9KZ+/UGbq
	 UKCjWQKVffzLeaWI/mu8BEh57NXEGpdr4xo0iEchfSB7vEOpEOZ5gcwVOziN4Vzm0b
	 J0urwnVYa8Mjg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 42/50] drm: stop unwinding descriptors by hand
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: sparclinux@vger.kernel.org, linux-openrisc@vger.kernel.org, "Ingo Molnar" <mingo@redhat.com>, linux-csky@vger.kernel.org,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, linux-hexagon@vger.kernel.org, linux-arm-msm@vger.kernel.org, bpf@vger.kernel.org, "Peter
 Zijlstra" <peterz@infradead.org>, linux-mips@vger.kernel.org, linux-fsdevel@vger.kernel.org, "Jens
 Axboe" <axboe@kernel.dk>, linux-alpha@vger.kernel.org, kexec@lists.infradead.org, kvm@vger.kernel.org, "Jan
 Kara" <jack@suse.cz>, linux-sh@vger.kernel.org, linux-um@lists.infradead.org, "Jann
 Horn" <jannh@google.com>, linux-m68k@lists.linux-m68k.org, "Alexander Viro" <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-snps-arc@lists.infradead.org, "David
 Airlie" <airlied@redhat.com>, linux-hyperv@vger.kernel.org, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, io-uring@vger.kernel.org, "Michael
 S. Tsirkin" <mst@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>, "Oleg
 Nesterov" <oleg@redhat.com>, linuxppc-dev@lists.ozlabs.org, linux-gpio@vger.kernel.org, virtualization@lists.linux.dev, dri-devel@lists.freedesktop.org, linux-parisc@vger.kernel.org
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-42-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-42-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:17:42 +0000
Message-Id: <20260915121742.F00241F00898@smtp.kernel.org>
X-Rspam-User: 
X-Stat-Signature: gb31sj1pa38b3sxtq3skcwdkkgidyjz7
X-Rspamd-Queue-Id: A99294000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1789474665-184037
X-HE-Meta: U2FsdGVkX1/IS1c3ijSUsChNp7M9uMFB6YwSCjdwxQAyNWkvxHsnUXsXkYtdk0dHkCfkyokyoXIe4X4XJ3VaMmU/gERXmR4Uvx7L7iJIv9GBF8JnL40BojvFiIMPJCWfCNul1YTvugZO8IDWNbbkOeMJkolrl0WOpWBAu+4eSuxrlge40rEkvuPKVhmivvaODjNnk8YFxsFbXV30D78/cp6tdVBmJhe6oxdYXd467P9RS7ZgCrMxleelimFoJbdm6s+t1xSGukEfbOVe3ed0q2JK+fiTT6WoHhh+EWXwPmUTMm5OQJhEoainxPlMLSvuxG1zmPKBsjEUKbjZdyKdLehRubYSmbkpx/2cHpVAudvLRwhPW4ehWF6KNVt9KDzn0KGxDeAGgElBaDF9NzlabgQA//JqfKgWBvDGWTEhvw0q8NjY/NtSGrfPFAOHESReHAdGApxwWg5ZMukuoIYw1HC20eM5oORDhKknYE7u3yXxCi1uZNzcZandu1qEUu0p7AArdin+KLYGAyEgWrXviujAYi7Eroiu4ulhZPGa2Y9fML5DATIowIUPGy3Ho6pJgcedErlrJNlLSoUftDl4HI1J455eEOhzBw3j55L6Io0gYxP57rFAAKerfQPZIC6eml2P9Pinu8ZKeP9TBfyCvTRItg+ZZazMoyc7tT33/3q8R3dqMCLKbrKPZerxuR5Hnnz6eypjRngpfrODVrhLEs6G5czm7JWimhqxTvZdhnmHeH3/kgGLSUkf/x24dwAozO7jFSTfKAIqqiUzJ+u4QeCui/5wdC0ZgVENfexk+T9k5fmvQnqH9egph+xMywOHbU2hLnX86Ne3U/kclqjjEgOODMQ/L+mGpqgbDqO3fFYornyJ67bHpJNOP2mrBPYkjk+TQaio1ZS5BCtSewUPU1AWZhu12nDdwog5OqX9DlD9CP59dUmv0qLCPxPBANHKKLjBXJW3MDRZMXlWOrH
 4M6cG3Uj
 Upl7AtTVHc0brbubXG7RLj/ZjzgIMlfS0PoJS46HmTtBUJgxPFUEPfojt/bAOV8101IovWcvD76s9m29E++hNvox3BWC9J3SmgEDYRHcypyNNjo8cGGJ0SiVD2BWpmltN2fLBjdR4xGFKA1Up2G7zgjiQgPTRm2DSdS9qy7YAeLJFnwxyKKig00/63f2O1yhqCwaec9r879b7efTWt0Z241JjrPV3PZ1pVdEhH+jCTL8dd3QBGOKfSgGIX7F6FU4Fnkix45uQH2WDBXbUkUFpNis0glrdzGC5BMpEzlg2+ICUA/I/KA5J0oXD7sb3Prz8ThHnHoyZSzDMYbjvAiYkQMLjrtJqyjb7y+1P8hKRwcoHOULdTyjoorH+08Ouf9pZTG+3P05MS5W7lhlFi8BcQIMgIpfBr1seG20OnqVyxOXD+9Z3f3a/LjJQ/zsHaNKERFjZa8GpXuutMuc5ey1YhAgxEagKBRmsy/iz3DiPobn+RcsSh6xavcLuV5bekiRM5R2vdLMNx1LcXFeoPLqG67k0PT8q52dcuyT0bLae0OVhy8YhJ9OrY8XnhL7mDMxDd8egBnfrc/Ebxe3s5wRA8cFfG1zZVkS7Yb4mZcYtuc+EvUpBqAHU60MKWxI8iL/h5aEvZWpg9Hsgm3Hsf4omRWNu9GBc2FqZfcLjS7oz8G+K9t1iOmfd/f29o4VWtECoripc
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
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D42


