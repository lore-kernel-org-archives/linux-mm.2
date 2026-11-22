Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA32B606A327
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 20:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FIlPxmeZ
Received: by kanga.kvack.org (Postfix)
	id BBB036B00EF; Sun, 22 Nov 2026 15:09:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B45026B05B4; Sun, 22 Nov 2026 15:09:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A33926B05B5; Sun, 22 Nov 2026 15:09:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 798DA6B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:09:11 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0034E120710
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:09:10 +0000 (UTC)
X-FDA: 85463844102.09.585F36D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 68B9780002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:09:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FIlPxmeZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795378149;
	b=WQxChTk6RtAd80FmdVDdK/aXyDzq861wR/BKlAhS8cSZ6OUeHZuPNLPAj0K6vtD1yqLn2+
	+gTkw+qVu22NNwhjFxGO6ZpQz/uqY44UFziIpM2v0cZQHAy6quI/QOpCen1LW2FdOYiPL+
	6Q+gvNTya8NLSffr43z5ctW227+lkQQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795378149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NJy4CQsDbbyrrux6ubIkfBdJ2n5S01Da1nbXLZiKzpo=;
	b=BVrAkdIqyD7Y2T/cnfmD28n5LBDA8UDc8kfWE1fZt7yHztK8bon3HcARx6PodlaSCDrauq
	tNXLMvHK0XyT7czObGkqrCLX4dBTLLAUMWahC8hwhaDbzhR2ebV/RYHmZdPCmwZwnB5fd+
	OGc6Kq1ka+OIipU41Dn6QsDa82YhB4k=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FIlPxmeZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DEC0C609F3;
	Sun, 22 Nov 2026 20:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4051F000C0;
	Sun, 22 Nov 2026 20:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795378148;
	bh=NJy4CQsDbbyrrux6ubIkfBdJ2n5S01Da1nbXLZiKzpo=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=FIlPxmeZXnL8jfb5igUreGcXeqBZ5IAPhfnC7/RLkwm2fVCUhGtqYHP5GbDuKZpgf
	 Rs8od4A00WVlmjWBGKGo1JI6rWCj5nnH1+0NbFWV3AkaIsmYJrE12X6iTuN/k1eFTU
	 qHOpyuR+Nwcq5ZCDMRP2gPk/h2EmJ/v9lcQ3KUTC29USZykod1aZwlrO8DAi15a4hD
	 zy5bQ3zQMmT/1KHgei8EgDoFnJTGd80G72XxB2rHkKNj7Sn4cPe3Z8gnlDNJs0gwsh
	 vuixGezimNtBC0ibmSBuA8VN6JWScZv4O78XVT3q/w0OUhL/QoblIvZBsuRCzQUuQ9
	 hDDVSB3o1NU7w==
Content-Type: multipart/mixed; boundary="===============0817330899429733780=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <777039b970038567305cede50f71dfed0a1a4a5616d06298ec2c7c6298cbcd9e@mail.kernel.org>
In-Reply-To: <20261122193539.3334213-25-jarkko@kernel.org>
References: <20261122193539.3334213-25-jarkko@kernel.org>
Subject: Re: [RFC PATCH v7 24/26] docs: Document userland uAPI
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,ebiggers@kernel.org,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 20:09:04 +0000 (UTC)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 68B9780002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: an61xkkp84f44k6zpsetz3nqeicsny4o
X-HE-Tag: 1795378149-49572
X-HE-Meta: U2FsdGVkX18kjfvEYWLmzcCaSf0fpo6hT/8Kh674glCm6YCzfFa6ldH7GtihMZu7PLE53hP1MhwCFdVS/qEEfiaTXivhgMQLzIj9RJndHWfItAR3JvXavsT1BJqs1EZuyB2ETo7U7JNwmh3Ln7H1oGxOtYFr83v8eT8t3M6nZiB9cLhmagURbvEsvs8IqucRP+vjjzAQP6iDxAN2NmkpXQjMMl1fezucob5HlC296dTNsU5W9mPl5yKUeIBSUmCyVzdSQYRlMIWi/KQT6hfiBXRHlTj/br1M/fQmPnSRqxMV7D7VE79+OYVhvEcVRY4DE4SsRvhp+bGDQc++7K6AaHcA+kjwYuJYtY1w0UW3IV1Krd+ATd4X16G64TH8G/qjYt6ScIUnFyaCNRmp4eXKKmEYboA5s001Um0D2c5IqbeOQ3SyeCRAviPJ8Dvdd1zFsVfro0oIbwu/ySSuB2E2HwQy8F/8txAAmR/oKKygVKB88ELfIGlM+IbLK6f3w3fqC+tkinpg8yOdFfpXIaMGsPLF7UrTbgrlv/ClfWXELPL0ffz3ffohQub8h61PbDiYeWe7H9YIhMl79ILmCp4yyi24iUGIXsoXPcXg+d7LPsA/dZ4WrHHv1SAyvHzCECp57jJUAvxgMh2GeilgbkbQWUyr/ZdZp0jd9hll27dVn2Dxefj4HtN40HEOp4C1fR+g2i2xGSwz1ZT6u9RTujStPF8IwsGfEY12C7Iyv+/tiCIXYgWxGD4qIEnv+/uBD/ZNILfHZE97U2WCYzI4mO0DfLitEDK4xPXDlMGPjlBABzVy9b4Jrq6cmtWX4BPsFlZnYaFTAb2cjbOtvdGti8MPHMhcwk0HE0CeW3sMKIGowFAq+R631JmzL4BCAwqryVbfmaB4bMXpSTKKw+F/efoo/6tJhjEYuwv+/R1s3HGUdesvmSTpRJbSSg7/wAyQhA7jWtzBC8TNZO574qXPfaz
 HnkH9QIs
 iOdBmupP8O6vghvXaDFFbZpMW3Yj6KT3H4J230Y9Mf9k+DZ6ieMgG8GfQ/HIIlaK8gIINw8d0NAb5hk1yIKEYwLQnV5pX/HGGdmJXhq00lCf8FE5Z/FphZrjiAl855Nqz3943c+kLRjJplRy1bPPIl3wSwCbxsm2BJplo0lJ1t9ju0RbywSyCPg6L9mDdLCV7Ac3VXMsm71/5tFBJ5czfCr3iB10K3Lk3BplEpiHyaOPQGoVgYW3DthYiQw/F0r02Bnogqv7PZOX6X1chg0CsDvLuIZ8WvjPLuw0psBIbay3O3x8A0ts9QJaiJ/aTnfWoSA0IQ2E8s5OeOoBMx4IHdzFoFbOyyEXupuyWE+BP0jlJqv/G2rmacnRIF9qatnW5vm4nT7rv5E9UYMRA2bo+zfPw/OqbfdgJPXHwb5NHTeKc7RrmKftLkZ8AoEjSwLVjBbw/7a0IObciKSfJUMFXdBGvFTm/BFB0JAvEmOKjrox1ftkzxR/fcuV7bf4zB/euDzAquKXTtjf1RMYF0ydLlWmvwasg1/3VWMXa+c7JsBVfvmbe5NsWKRXRPMWeYMAoVwNYO7GLojWosfgHoWVcEHNa6s9B9rmPnlQSjsl0e2dZ7fSt2SBR2C1HGi2TgRzw9QJFzvgvEan/S/+HVyCfUXOSkN/fW1HCSVkPV3KB/+0a0yE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============0817330899429733780==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> docs: Document userland uAPI

TL;DR: Docs nit: the sys_userns_set_idmap() kernel-doc @size text may render
with stray raw backticks around PAGE_SIZE; rewording the source comment would
avoid it.

> diff --git a/Documentation/userspace-api/userland.rst b/Documentation/userspace-api/userland.rst
> new file mode 100644
> index 000000000000..e32ea3501472
> --- /dev/null
> +++ b/Documentation/userspace-api/userland.rst

[ ... ]

> +User namespace ID mapping
> +=========================
> +
> +.. kernel-doc:: include/uapi/linux/nsfs.h
> +   :identifiers: userns_idmap_extent userns_flags userns_idmap
> +
> +.. kernel-doc:: kernel/user_namespace.c
> +   :identifiers: sys_userns_set_idmap

Will the kernel-doc for sys_userns_set_idmap() render correctly here?

The @size description in kernel/user_namespace.c reads:

  @size: Size of @map structure in bytes (%USERNS_IDMAP_SIZE_VER0..%PAGE_SIZE)

and kernel-doc turns this into:

  Size of **map** structure in bytes (``USERNS_IDMAP_SIZE_VER0``..``PAGE_SIZE``)

Because the second inline literal follows a '.', docutils does not
treat the opening double backtick as a start-string, so the built page
would show raw backticks around PAGE_SIZE.  Sphinx does not warn about
this.

Would rewording the source comment avoid it, for example
"(%USERNS_IDMAP_SIZE_VER0 to %PAGE_SIZE)" or "between
%USERNS_IDMAP_SIZE_VER0 and %PAGE_SIZE"?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45063222848
--===============0817330899429733780==--

