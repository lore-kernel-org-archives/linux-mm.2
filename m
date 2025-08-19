Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD11BCA0EF5
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 10:08:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41E1E8E002B; Tue, 19 Aug 2025 06:08:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A80F8E0002; Tue, 19 Aug 2025 06:08:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24A7A8E002B; Tue, 19 Aug 2025 06:08:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B06E8E0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:08:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A29045AD8B
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:08:51 +0000 (UTC)
X-FDA: 83793083262.23.DF240F7
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf08.hostedemail.com (Postfix) with ESMTP id E7743160004
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:08:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sGUfOUlY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of jlayton@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755598130; a=rsa-sha256;
	cv=none;
	b=wY/f94AWt66lq0qUpwFu/twH+UK047LKQ+LSeJ4e769Kn0FMRMhAJCSp5QUT35TpP3mcHm
	NNCWVr1eryAy+txkdJDxr9fQxngMXIq2NcxyUAJLROoyjJObGXndz1MBmN+TVGxqtVy17D
	T6IWnicFkPW9nY4rGF99noYtcwtTk3s=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sGUfOUlY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of jlayton@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755598130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Vg8TqfggEZroib3o4tzWAuKdLDw/JwpWYm6IMSCVEs=;
	b=7Qh1GE2xjk9EKWk5YyBluf7tuiADaJ14+LAewu8D6p8qB8JSK/cgUVOPYyu4IL1nDFbT/u
	vinDeTFBA137kRegW5Si7S7wmaMIMkJZzrqWFNDcuk41X6oYKU89lyiFHnw3f5AbkRr2G3
	PpyooKi9fh4cbCeNKAaJOHIecOhHjU8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id CAC8C5C5C3A;
	Tue, 19 Aug 2025 10:08:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19147C4AF09;
	Tue, 19 Aug 2025 10:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755598128;
	bh=737a7gXy/T0JRvCPCsi7SuPm2Di5qOsTwyUNcFvqQ4s=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=sGUfOUlYN/Mn0Zsh4uuzrZh1ZP6AWTBOeMXkmBp0O0DD/NVabVFQIDkcOiU29LCH4
	 NfjT1HT+kRJtVJnqtV+1iq0xzWMJELIAzL0pG+yqBh0p9YARdcdbX2/btUdHD5eaiP
	 8XsJAE+M+nLpqfg5S2A2LU8AEhvq7iKxoV+D9ardpuzHfejvxJO9Rq7EVu8GH4GelI
	 cpbp3htQscMsCpLrikXb7q6wJRXzc2hRp/gRtcNUJWxHxw0NoerwqFFhQqGe684Vq1
	 Q2Cd5bo1DYyTqphbFy9JeXsb0TnzzTV05M0C/D2bEIhrGtEj42wXthnzvz+ZEaNCat
	 c7ZxZmS/PJ5Ew==
Message-ID: <0a5c4b7deb443ac5f62d00b0bd0e1dd649bef8fe.camel@kernel.org>
Subject: Re: [PATCH] tmpfs: preserve SB_I_VERSION on remount
From: Jeff Layton <jlayton@kernel.org>
To: libaokun@huaweicloud.com, linux-mm@kvack.org
Cc: hughd@google.com, baolin.wang@linux.alibaba.com,
 akpm@linux-foundation.org, 	linux-kernel@vger.kernel.org, Baokun Li
 <libaokun1@huawei.com>
Date: Tue, 19 Aug 2025 06:08:47 -0400
In-Reply-To: <20250819061803.1496443-1-libaokun@huaweicloud.com>
References: <20250819061803.1496443-1-libaokun@huaweicloud.com>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-1.fc42) 
MIME-Version: 1.0
X-Rspamd-Queue-Id: E7743160004
X-Stat-Signature: 1a89wxd5cthk4kauri9fm94nmjfx919h
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755598129-363057
X-HE-Meta: U2FsdGVkX19IyvInynRJyvFIz9VxkUmJv28R/bteqLAi3llJ5TRpgnzsZTDQZ+CaSIlEm+o0GTKVigyBRMCm12fujpVeMagYZrrF1PM5IKCFVjYuyR5RZHzi9oKpz4FmgXor+kpDno3Z0H/v/wIqyFrw0o0rabpwOjAlA2gKvDU1vO+VSXOcI9GekJtsxTi6wudR2KErZWq3aE0Zy06dcSo6N7xE+h7aw5WZkuk3yFVBJ3RXYAWhpy2dJ6LsPR8dLLwuOogZS4A0hoe2Vab9c8bvVUQvVNlxXQ9VQSbVmSrvjOeQlpnz1G8cjGNDosQI8gZJMdIrJ8rnT5V9RST/ZnWuYc+cgcCgPZlcwmvqFl3O0+kEr2nDLfjVDyRsz16iTpw7WNSsSR8PXVf+12Jo8pQNCx3gT9eAY4eBNbLzN4ytMe8bXQvdtN1+XvbcdFWB6Wlp6OJkOrnXum15nsSBOrhzCnClUJ/SaX5xO8T/+tqMsFUroTzozM2pZ53o4qShBUkWsRdyJSb8Oly4FVl3LAVC+pMhFusBv3BJiU9NtAsKe/3g/DmeM3Q7PvYBu0bey9VkxliHPkl61AmSbOgdDNP8zXJh7zf8S+0D5HrSR4r22Y+qzypIYC4NXQv/kzjz4HSAPB16h6CctM6zTt0+JHbsRRYG74Z2/kF3bSaMBNQ7anplGmEhsdDbIUrXgCwig3Doj1FNot2Lb0sLAj/LpZqXtoIBReIHUQkM3jiXpS39TcAyOTKSy11vVD/MubBG76/dT85VtpphGZClLQMDCNhdMf72h9d8mdfTFfh2IfjrFQZo63pwv5YEgRUlU7Ow3PaV8FV9r1g2jp72QgOZodZqC1pOyOPVf6bNYGDI05A9rIwF+oJ3K29+nsTT5acFksMCu0WBLSIwGBBqCq5cXuzkmc1ouCaKNKh+XxOcCNPu7tkG3NDeZWB8Tw3Rvnd0LF0lcIP2JEmKRg2KSn/
 fPYFsS/8
 VHFEAg3hAul+h3rpuTC5j2hMqC9Au+AStn9WNDiilOxa1UFuhbMzt/HhUMfigriC/Wpf7ceXSQ3Jbjxsd1OSsUNWZlIcgPjJjPjcQqskx8Dnglus/pnFoXwnWO9lbcRPM7rLfOvDNQ5/6BP2hlU7ZJ1CaQiu7kKLbpUyjSrL/N+n4YVcE+9gpx/+82zuoCCqj3UK+qtobMG9cVPNpuFewYiDNQxQD4hgXUd6u/0preZMVUCUzzQ8bZjQGoR8PjRdWtH5nTHTUed/E+wSYVLCNcUdRT9DtFj2YdvhdI4wbZWJLznDQQTanDidWw/jVzTh+QHalHWJ52vyI5wwK41WbCPfdpw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2025-08-19 at 14:18 +0800, libaokun@huaweicloud.com wrote:
> From: Baokun Li <libaokun1@huawei.com>
>=20
> Now tmpfs enables i_version by default and tmpfs does not modify it. But
> SB_I_VERSION can also be modified via sb_flags, and reconfigure_super()
> always overwrites the existing flags with the latest ones. This means tha=
t
> if tmpfs is remounted without specifying iversion, the default i_version
> will be unexpectedly disabled.
>=20
> To ensure iversion remains enabled, SB_I_VERSION is now always set for
> fc->sb_flags in shmem_init_fs_context(), instead of for sb->s_flags in
> shmem_fill_super().
>=20
> Fixes: 36f05cab0a2c ("tmpfs: add support for an i_version counter")
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> ---
>  mm/shmem.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/mm/shmem.c b/mm/shmem.c
> index e2c76a30802b..eebe12ff5bc6 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -5081,7 +5081,7 @@ static int shmem_fill_super(struct super_block *sb,=
 struct fs_context *fc)
>  		sb->s_flags |=3D SB_NOUSER;
>  	}
>  	sb->s_export_op =3D &shmem_export_ops;
> -	sb->s_flags |=3D SB_NOSEC | SB_I_VERSION;
> +	sb->s_flags |=3D SB_NOSEC;
> =20
>  #if IS_ENABLED(CONFIG_UNICODE)
>  	if (!ctx->encoding && ctx->strict_encoding) {
> @@ -5385,6 +5385,9 @@ int shmem_init_fs_context(struct fs_context *fc)
> =20
>  	fc->fs_private =3D ctx;
>  	fc->ops =3D &shmem_fs_context_ops;
> +#ifdef CONFIG_TMPFS
> +	fc->sb_flags |=3D SB_I_VERSION;
> +#endif
>  	return 0;
>  }
> =20

Reviewed-by: Jeff Layton <jlayton@kernel.org>

