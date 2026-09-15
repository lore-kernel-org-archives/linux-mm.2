Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A368AC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE5F76B0096; Tue, 15 Sep 2026 08:14:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBC8C6B009F; Tue, 15 Sep 2026 08:14:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD42E6B00A1; Tue, 15 Sep 2026 08:14:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9196D6B0096
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:14:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1761C03F5
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:14:44 +0000 (UTC)
X-FDA: 85215890088.05.498D32B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 34D3A40008
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:14:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o0i1edZo;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789474483;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sF9YfaIJizyBPu4rwmr1ugFHciRiaj3rpWpmWnplm2o=;
	b=1cJx37jqddNj6j5a27dDjcb9EKwGEgoFLk+2ynXEgHOhWQgWJ4rCB4XnCxKGT7TumeUaWH
	B+InMz9DxqMd29QZCyajDysoH5TyJPpsLggnynnQWS/dGxoajxKQ4NEnLbCq7FdBcKaIFV
	UVNaZdsdLiucaCFM4eQetRzIF1rhiTI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789474483;
	b=frTB7VccJyNQjcvQ0Z5DMwe9XUJcAJwIhfq5bIJvtegSpO8zh88ZwgFol3K/b91MhMrWPC
	vjw0eHY89cJ+Qid+VjZJxxv79XhNwAjQTgMu78ytOnHJsJlhK5I/whEWSEvkQtK53fJNpO
	qHDEEa43H2Hk+ua9w531bWW/YHwEmys=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o0i1edZo;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A7309602C4;
	Tue, 15 Sep 2026 12:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908681F00893;
	Tue, 15 Sep 2026 12:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789474482;
	bh=sF9YfaIJizyBPu4rwmr1ugFHciRiaj3rpWpmWnplm2o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=o0i1edZoSZwfTDuavjm0jvg5VQXWhP0dWUGKIGTr8VBvqx0/C7n4xowvx9OTeZtCR
	 qz/PxHeE5NmuntDwErr/shj/5CjD5MPN3WutZ8jsJiT4+HZ7bYopL8U2z/U+F471Uc
	 sa15k+HBxjI1ws8oZIZWAKZYm3G/E31Ge9otNWzoXAUQ+Ib0yP/MS1/m8rv3aFEZmu
	 VV2JzWkAUzQkLxzgSbSwLB7ttoPZ88S25QNgaYCRv63tBmcFXoL6Vo+uFNON8iAfJn
	 gV8IlZbIRL7RHxvrFsH/t67nJiWg9k/SjrxxaMsoIiK6BszJu6OO6xdUylYjAEyJcP
	 HyYV4oBdSfuLw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 43/50] drm/amdgpu: stop unwinding the fence
 descriptor by hand
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, "Jens Axboe" <axboe@kernel.dk>, dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, linux-snps-arc@lists.infradead.org, linux-um@lists.infradead.org, "David
 Airlie" <airlied@redhat.com>, linux-arm-msm@vger.kernel.org, linux-csky@vger.kernel.org, linux-gpio@vger.kernel.org, "Jann
 Horn" <jannh@google.com>, linux-alpha@vger.kernel.org, "Jan Kara" <jack@suse.cz>, linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, io-uring@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, kexec@lists.infradead.org, "Ingo
 Molnar" <mingo@redhat.com>, "Alexander Viro" <viro@zeniv.linux.org.uk>, sparclinux@vger.kernel.org, "Eugenio
 Perez" <eperezma@redhat.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, "Oleg
 Nesterov" <oleg@redhat.com>, linux-arm-kernel@lists.infradead.org, linux-hexagon@vger.kernel.org, linux-m68k@lists.linux-m68k.org, "Michael
 S. Tsirkin" <mst@redhat.com>, "Peter Zijlstra" <peterz@infradead.org>, linux-mips@vger.kernel.org, linux-sh@vger.kernel.org,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, linux-hyperv@vger.kernel.org
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-43-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-43-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:14:40 +0000
Message-Id: <20260915121440.908681F00893@smtp.kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 34D3A40008
X-Stat-Signature: kg6j9zsf9frnm4pur9ge5yy7ztqco9kc
X-Rspam-User: 
X-HE-Tag: 1789474483-940030
X-HE-Meta: U2FsdGVkX1+MNPy3hgW5JN6LE+UQ/v5aueydEDJILGZJf23nhB+zKzQyKAmUIC1ncTUNAIdEZpUoiD6dBuBjigycKiJ5eRUT4qPY734Cj8RCmiQOUNt8r31V9wqhBzLeVf8Pcsy4cz1pbFPm7QgyaLXpa8gJ3KuVMXfLfDnqnXKSuBm0SWUVYRjDkPxmGCX80xoEWZcvN/3Eqq5vj7y43ApcCjQmiZtJ7DRLH70vhWRfiV/ibx5qsG+AGN0qvc1ErlLiDevvkpjY/oMQKQ39igmnFbAaLPaIivdBMdvkFnH04iG+9bf5hjH+iCOQ8ennEQ/vR4R4yM5wpupm5m2wAlOPfbPRXRcz3yfjYmKm3WE8HeEuWjYziPPQdI0ltxWMnFZQVm4FrGLN0BxQ6qKj7fQmx9Fs4ACctbC2uJ9gVg1+GzCLYPlDlXo/FbEedxVsyqFFslmIl2T07LSQnrEExXSc1eE00NUILxIlfFY8cPpFpy7tEH+eguIi2spQ3kCAMHxT1Lnb9gCJj3yD3Mt/cLOUXUDj29+b7YtVZRRtzHY41Z1q6fCZWMEw9lGdbAzHHlFwp8OX77AIO+myYBMB/S81x3lCKJh1aiDsijA25g6HKSVkwuuUpzHh88E1el0wmzMufM/B83fRHBTV1Uc2eV7oUNCq/NroRcetN/LjsEr3KH/XphNA+hEmio73dyoSwL+4RmCTTHw3BORfdQe1WbuM9/yGyzxktcZj7w2EOqLHOvfBjjOo2wFQRoqemy0J9/6xVZE7klKHI2b2wj4ejLQ+nQELov9dr0LcW+6hXEpdD65F1JOkwHhr68mIGHTFYn8SIYyDh7lZ8tZD4fz66SkCXduHGuDyy2Ro/uBxDCNCzhAHYx7DyWAW6QoPQLhm+sEZUKqPCOmPXdU7M637W9qjCXmhWwKIUCh5dFci81RmAGVTVLoOZQq1PNCKMKbLFU2II7jWmaBP9ln0FFL
 a/A19yAn
 ogFAb8fRxxfVgWUIYBCXvXamNLAUenmF2oaO9GNrqE2guq4pvw7o3SPLZ8YipWx2s3WqoKgu/v89Bo++KFnUMqknikYikeLogdKs0qKs+KL1mNGQEFWBL+mYz9pBc3HEqssIa8RoQC0ijKuKkXUUBFj3YYVwGvzvCusNimyHr7+Qa4x+bn5OzcM4T1mt2VQp00H+8Q2/CBMfuwMtNSA395+VKxt3zHRsmJ6RhfG3nVWYHfFEkCvYN3ee9jmb5EpsUy6iFbgbLGon6R5VovHCmU8xI6vsW7sJ65qei1eJ6+OmoCvBnKUtSeBXhG5D/2Doa7XTCI7u2TT24FADR7SRgRUh301bJGvPeNvUeMfCGI7aLPaRhlF+smQMBpQzd2iTMa054JP/AWmSlVWm2anrrigDfJ7ca7V0oDj/gwcZ854qfXW8BBn9W+4ef83cY17Nr0yL4I+Uq6iM/ygKEhXTM6hFinDCV8pcHCjo+BFnks1RhZyeTUsme0h+XcEVclOMzzDtucXmo232tWrVy7R7pW3rQb57h8kfyknTRYFxyIN4qDLl6gLO0kob18v3eZk46SQEty3Y6srEc30jqB8dVmh1xAypXCwC1WYTPWahrBkvWcY6zg3evKWTKZNJIiqQr5pKAXiEJBwLPg4hrygQEQIZ6cb5gceHyu3j2SHGzWlpLTO+oKMx4GWlgN/kKJQc4OMc/
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
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D43


