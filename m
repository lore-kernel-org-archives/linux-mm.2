Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53254C982C3
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:54:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DE5F6B00B5; Tue, 15 Sep 2026 07:54:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68F0E6B00B6; Tue, 15 Sep 2026 07:54:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A5976B00B8; Tue, 15 Sep 2026 07:54:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 363B76B00B5
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:54:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 81DD3403DD
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:54:09 +0000 (UTC)
X-FDA: 85215838218.22.7085E2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id C7BC44000A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:54:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jxGdVbxm;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789473247;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AG30xjDiMKCtDyqoUWBdTqe2A6YC7BdfmCSY6YO8TME=;
	b=pcEC9rujPyQoUR13QVlWoQcX1NjU9utCo6EHfhn9vS6tUurqvM2CWnXtt1bxcI2tfTnuGG
	3EEtWorBczPwN0DQDT8rSezLMOCxbwAs9JV0K+bmW2VuP1DCsS7xEi2TdC9XD3EvzoOqIG
	U+JMPCi0McMrwVfhYolL8Eo6YmFXpLI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jxGdVbxm;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789473247;
	b=5G5cynFs+kYSeRc89K56hv5sBP6GteweZedXx+FCWh5bOfyVNWLK7116Be6BKLW7o4gj0m
	Owvi5XDme4h109VRQsHupBP3u/w9QUnsn9juoKLJC0SyYu9lREQsk9cdIuoME187kjaumH
	wjf4SQ19/s35acP/aGrIDGNw7fd00WY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E345643BD2;
	Tue, 15 Sep 2026 11:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0B31F00893;
	Tue, 15 Sep 2026 11:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789473246;
	bh=AG30xjDiMKCtDyqoUWBdTqe2A6YC7BdfmCSY6YO8TME=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jxGdVbxmN8Kp7YM+vv1k+Lwtl83KHaJbgpKLbkY5B9ndglNTkZCcuaHvygk/C/p23
	 gtc5IvLgRXflsaT/JbeYSUg8MT7dnkGaEESjkiYYG1vk2eMg5A4bJo85Hl9wv/nzeS
	 eGLkK/gZnGZt5sYUblxipqPSDfZOU6WkQWeqEOXj7sSr5LV4NAo/AueirSWL/XnsKl
	 hRst8P2ASZag12PNEDM5uHg4yR4m5hctoI8grNV4iMcvJNyl1ZXEvQ3SkS6D43rgW5
	 SD5U4o/63gzEV7FOsh2ZQJJdmW/ba916cBMFpTju6k1xEUWXrbdXF1KZviyBg5srWx
	 +dlhemDHcpIKQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 12/50] nios2: commit fds on syscall exit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: linux-arm-msm@vger.kernel.org, linux-um@lists.infradead.org, linux-hexagon@vger.kernel.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, virtualization@lists.linux.dev, "Jens
 Axboe" <axboe@kernel.dk>, linux-hyperv@vger.kernel.org, io-uring@vger.kernel.org, "Michael
 S. Tsirkin" <mst@redhat.com>, linux-arm-kernel@lists.infradead.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, linux-csky@vger.kernel.org, sparclinux@vger.kernel.org,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, linux-gpio@vger.kernel.org, "Ingo
 Molnar" <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-m68k@lists.linux-m68k.org, "David
 Airlie" <airlied@redhat.com>, dri-devel@lists.freedesktop.org, "Eugenio
 Perez" <eperezma@redhat.com>, bpf@vger.kernel.org, linux-snps-arc@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org, linux-alpha@vger.kernel.org, linux-fsdevel@vger.kernel.org, "Jan
 Kara" <jack@suse.cz>, "Peter Zijlstra" <peterz@infradead.org>, kexec@lists.infradead.org, "Jann
 Horn" <jannh@google.com>, linux-openrisc@vger.kernel.org, "Oleg Nesterov" <oleg@redhat.com>, kvm@vger.kernel.org
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-12-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-12-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 11:54:04 +0000
Message-Id: <20260915115405.0F0B31F00893@smtp.kernel.org>
X-Rspam-User: 
X-Stat-Signature: 3jy1fbg6ji6trm7i3fyrg6xgf616mhub
X-Rspamd-Queue-Id: C7BC44000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1789473247-527032
X-HE-Meta: U2FsdGVkX1/wlEg1thaAaO58COApeMfKZ1PlOyfs3cFN9iHimoN1aaJ8bYbwgzEqEwJi4ZJjo7mLYURGDKELUg7Ez8UfHCk/nY4uAn6qOespLuIaR+u+nZ0q4BFJP3k5h56uPthnVdVSDXldriqQJ0cmGoB5WZDdetdAwxAURKojVCPiRrF+6NFDvvZcBCA7vx3LswRHc+p9Q6lWWAtdGCQo90dCC7xziA6sHZYA1m/ODQM9vEXemEaff3EOGVA3z9BLfrkQTggwQAkbAF73foZpLGchxtC3EbxEbmpDIuGmyIqsQNHOIMtIM4VjNMdXZLX1p433L/fwd5vERRo4AZpasWLhxmp6EMnDQj2BEHuwDuJhRJ3By5tJwSg4HxNOAogB/u6DAxnwfBtk422XdTK3e+puxXbD2X972oFNpL2iCKbuJ9nhhbBhm5KprN0zzxJYtqYiqWSPTuxN2powKzIs9Ju9ObZ8w0XQQrywRFk7FJuTn0m3f4TZdqdxulWD0BuDHbmtYRAGPrprAg7CyM+wxjcfjGJBjoXSTxywByX3bOomtd/eoAG4m/IEFao6WzXsIvwqN//WQiS7Xcfs3+osHzAbSwfjftG4bmmnMnKCE3+srLXkw1xw5Poyz1Oib9m2SeKe3HZkvZmS4goHv3irIT/7rtuqF66pObaSgCUPhFgnkgCvoIZ4yvqQOD6VkNqxSQI+onfBR/LFJGzf4BYbizyAAez18DvLGRAk6qL4OTStpdxpBlzpgLNUNMteuUmEIb2BFKuBuGSl3xA0SN+Jy0jKRULoPZoTzRkAgzZLD2zqSQTM+pFIujhVW7LSLj7EHgtCXfTJ+vLhVlzT2CAk1dO5NPoelfmtmVQcZJ7uiKqfkBpJZAkagwus6oLK4Im6imL0NfYzMh0xmGanuWk/l7RTtz98KMJFDCAofi/eIpuLIjgo/RRbljoLXAyjca2dQY7lroABLGW+sOi
 9dyxpwFk
 J3jG1yS5xRcdAse5f6VvBHa2kjdLJImRRYSu5RoqUMn0zLbxyzlGPfmGPROw8M11/vtlFl64x5SwNZeH1OF86AupwRiuZgbSWI5/ntIZqHSJI1O+XsX5JnXeTqafHMI6LMX6jmcmkOIYd48TUQXWai43wOgkHW3HlZTpUVqyzJPw1BTFW5yIqV0PSouqU161XZq9d9ucecuX8L8MTmBdLgYYmvpWXy76RN+hMqmlFX/qcv8dWyQYRnA2v5Grdj0QVULMv7m3wmz4N/SJZhlfHPKTYTsyuhQx2Lm+UofS3YobiEc1obFX/KedTnR2Zq27FdXybQGYmn0vkg1r2jf+9MAQz1Fg7hZmmLJ7jtq44mq1vcYQHbFVSMyNP+zcEwLQUv9RtbjZyh+bO4UfU7l/m4otyURzJYzOFnrMWnyijWH+w6QOWU5+HOOoHC5Avj4hoeMkuRQVyqb5qZdfjjHcK0SsJ+HKjuTQAy1ahz9uGH/bdMCeBtvVGFsr1NcPgz+v+JPpebnQWr67cCR/6fCV888EzcJwz6hO92Pdjm2F+Fg72S2/74SMOB3WHzgbhcrg45huHep8+X5EAmst75wlAzk1RqruGEdVkA1vSF3yXgVYwlpuiLY03BOKKteG2cWEyInJIwxndqrRo0zTYt4ahvIlDDXAkWvFoT1UUppfwWA3VMM4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Add TIF_FD_SLOTS and test it once the untraced system call has had
> its return code translated into the r2 and r7 pair userspace sees.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D12


