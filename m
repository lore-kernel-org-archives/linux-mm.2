Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A962BCA1002
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 01:39:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB5D68E0005; Thu,  4 Sep 2025 21:39:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3F218E0001; Thu,  4 Sep 2025 21:39:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2DD28E0005; Thu,  4 Sep 2025 21:39:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D66F8E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 21:39:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3388D1A0132
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 01:39:45 +0000 (UTC)
X-FDA: 83853489930.16.D66DB18
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id A9A2E40004
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 01:39:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dbFPG/w/";
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757036383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uutruk+r00qHtF8jy2x56yqGYlcLdZ/878xv0eNNYn4=;
	b=VWCAdU9Iss8j5ky8c11meTnB2W9AQP+vb6/FeALi/S1kHSpDlxr+DqToL8KHkDBZMZob4Q
	m4npgGzm+K1w/FEhS0kKdDTWlAAXPgfacSX//ypsKortI3HWUrE3KaqqhhZ05z1QL4Tiib
	acYum+pNWinNkqR6xGYX7SPPMYxp/nA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dbFPG/w/";
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757036383; a=rsa-sha256;
	cv=none;
	b=eKDNPSXZkdD7mbrG48lh/+8nzQ+VUrm31L/Gpr3i3HgDuOUfjzG0pgX5n4h/YB0OUR9j83
	UrqExrofcwKO8q2wQSP+if7Rw0y/p7TfThXPRP6rxdGY4vTtbh1UkbkbNYJclWCr9gQada
	BUFEUQTKPR3RPEVxiIGcuaaXvEiX8mQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F37B06028D;
	Fri,  5 Sep 2025 01:39:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820A2C4CEF0;
	Fri,  5 Sep 2025 01:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757036382;
	bh=gBxt9yJz2X4rnYGw4cOMBTPWUl+ly8t99jMd8+Q6yuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dbFPG/w/wasGxE4JyWYdMLVevQhqjjL8DiEB8HyzOADOoZfXx/q/CD31Tbs1oZQE/
	 MrOMmlMejI+JVmjuunKLMWDqz76GpIrhFTn1WWiZZ3cdNWXo9gxEg7SiyIgUvgVDxW
	 TN++c3hMjuwAAeHjyzAX98RHWKyna0EuhShjcGUBUAc0kQJxvmcpOOl7LnTQAezrp0
	 s4dNFmyxXU424xbbKJHoWGSMDc/bL2TC7+bDGs//kVF8unwXKIm5OwIzwRoGEW1OfG
	 5CrzodZiFYxAOY8BgB0kgjjx59pB1Vk++SBvTsL4OrEuApZzyHCD58RdqM3mlNPXr6
	 LEsHA1021uj9A==
From: SeongJae Park <sj@kernel.org>
To: Stanislav Fort <stanislav.fort@aisle.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Stanislav Fort <disclosure@aisle.com>
Subject: Re: [PATCH] mm/damon/sysfs: fix use-after-free in state_show()
Date: Thu,  4 Sep 2025 18:39:40 -0700
Message-Id: <20250905013940.94255-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250904175549.88928-1-disclosure@aisle.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: farw6zuichtyxbq6mhoq8i496pbomzkb
X-Rspam-User: 
X-Rspamd-Queue-Id: A9A2E40004
X-Rspamd-Server: rspam01
X-HE-Tag: 1757036383-502005
X-HE-Meta: U2FsdGVkX182Gn4i3pArD/L37argU9Uvmo3K81gEQx8oqd8uD96k8eougTYvK5QOtBX6P0FHFQWiYeh1b3syy9XQcdXNEV97AXm/Q9lgQT2MEKpkoMogjUDe2NeCUacPfy2tfrXrL2Yk8nTCaWUczsNQE5NWZCpqJnPIykEuCu6526bY1AeX6sHNgyMxT8MBCsv/qrMnC69ZkQ/GrX3agxTLfb3SmJZbB7f8H13mcwM4wrTU+eRaRULXDeA+rfFwMq1mOKaAbQK66ig9NBjWQ02Ni8Pf5z8jMOdmUwfdVVNdcdYr7Oob3iL18aP2RoBlAYv9p/jPy4jRsL4tkEEv2mpEd8zd/BpoFjLBo1qgH87Qs/muGRPoIA7yF6X9gorqGi4YQGz+4dwFfti9JcRPUFjEPcrYIYzb0eplcxAteWbokr3cVyK8kaxN34V2tqi6KTcYS3JaQgRLE/uInFEQU/hHlEu/Vws56TVqeZsVpB4UuqkaBwiUZ6vpoKPSAl1Yjg4pLdkRbBWHwVnbH+O1RlSKihZYmYqXRdm4l0UvFtfkjQwOrQLmwVp/oPhDfPUFLAH8qDDEvaUPPA+cjtOiP0kFy9vKwv1u7Y0tIwukubzyW2dpxDwqHNW5P2DPbx/KBY+rstSyE4QzY7IvSmRc4hhcs6D8wre3RRaR4asKkBsELg7opP2yL0lSu6w57W6MnOvA4Sp4bIK1nYshJCzhVei28jygc7UKmWKNLq3ei7fmm20lN2wttsiFaa23Z2P6EmC0J6STfAAeBMYEHL1Pi2xwyNGwxlzDX7TbuOA6njEDXUzwjvTwnG6W97IwOCoKPtUPPVEg/9jlZOZfS5BrArtMlx8gjzgtIf0I6ano+pEK4V+bjhJapFOcVdPCGrpjxNPIgDxBdt9HL4lIywVoOsyn6QI4UGjrCIAZydoQoY8o/8L/KBNm4BymBhz682sCdG8OaYSM3ELDkDv6YxG
 HMSAuMgp
 nLpbMs4Bd6sTYeRKSbbiAVqppgtxAL++JkKwYQC1XClqsk5J8RDbkzWm+yXar/jxGJWIYB90CbsGz/p+sqYKBu9Xh/2EN84lPu/YReTL2qUyocU7Xh/5qJLN7th8+BSQOGIhQ9UEB2jlpB2TSNjWYNVZbdffbY36W5mRHvTx63QUywOR8gCaappDOCDQDHjwsHbSoD4oHA+myYFs28JMD7sFpLqV1sqXQHkLIBtDRT0qJumnKvfAUo/uQPxvsRw4d+f1JZlgs8xKvnkefdMqpKD5kT721wFS2uXDRO+MWm1VC4pDLPVp861L0iw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  4 Sep 2025 20:55:49 +0300 Stanislav Fort <stanislav.fort@aisle.com> wrote:

> state_show() currently reads kdamond->damon_ctx without holding
> damon_sysfs_lock. This creates a use-after-free race condition:
> 
> CPU 0                           CPU 1
> -----                           -----
> state_show()                    damon_sysfs_turn_damon_on()
>   ctx = kdamond->damon_ctx;
>                                 mutex_lock(&damon_sysfs_lock);
>                                 damon_destroy_ctx(kdamond->damon_ctx);
>                                 kdamond->damon_ctx = NULL;
>                                 mutex_unlock(&damon_sysfs_lock);
>   damon_is_running(ctx);        /* ctx is freed */
>     mutex_lock(&ctx->kdamond_lock);  /* UAF */
> 
> The race can occur with other functions that free or replace the context
> while holding damon_sysfs_lock, such as damon_sysfs_kdamonds_rm_dirs()
> and damon_sysfs_kdamond_release().
> 
> Fix this by acquiring damon_sysfs_lock before accessing the context,
> mirroring the locking pattern used in pid_show().
> 
> This vulnerability was present when state_show() was first introduced to
> access kdamond->damon_ctx.

Nice catch, thank you!

checkpatch.pl complains as below, though:

WARNING: Reported-by: should be immediately followed by Closes: with a URL to the report
#34:
Reported-by: Stanislav Fort <disclosure@aisle.com>
Signed-off-by: Stanislav Fort <disclosure@aisle.com>

ERROR: patch seems to be corrupt (line wrapped?)
#77: FILE: mm/damon/sysfs.c:1279:
2.34.1

WARNING: From:/Signed-off-by: email address mismatch: 'From: Stanislav Fort <stanislav.fort@aisle.com>' != 'Signed-off-by: Stanislav Fort <disclosure@aisle.com>'

I know the reporting was made in a non-public mailing list.  Could you please
add a context though, e.g.,

Closes: N/A # non-publicly reported

The second and third ones should be properly fixed.

> 
> Fixes: a61ea561c871 ("mm/damon/sysfs: link DAMON for virtual address spaces monitoring")
> Reported-by: Stanislav Fort <disclosure@aisle.com>
> Signed-off-by: Stanislav Fort <disclosure@aisle.com>
> ---
>  mm/damon/sysfs.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> index 1234567..abcdef0 100644
> --- a/mm/damon/sysfs.c
> +++ b/mm/damon/sysfs.c
> @@ -1258,17 +1258,24 @@ static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
>  		char *buf)
>  {
>  	struct damon_sysfs_kdamond *kdamond = container_of(kobj,
>  			struct damon_sysfs_kdamond, kobj);
> -	struct damon_ctx *ctx = kdamond->damon_ctx;
> -	bool running;
> +	struct damon_ctx *ctx;
> +	bool running = false;
> +
> +	if (!mutex_trylock(&damon_sysfs_lock))
> +		return -EBUSY;
> +
> +	ctx = kdamond->damon_ctx;
> +	if (ctx)
> +		running = damon_is_running(ctx);
>  
> -	if (!ctx)
> -		running = false;
> -	else
> -		running = damon_is_running(ctx);
> +	mutex_unlock(&damon_sysfs_lock);
>  
>  	return sysfs_emit(buf, "%s\n", running ?
>  			damon_sysfs_cmd_strs[DAMON_SYSFS_CMD_ON] :
>  			damon_sysfs_cmd_strs[DAMON_SYSFS_CMD_OFF]);
>  }

Other than the checkpatch issue, the change looks good to me.


Thanks,
SJ

[...]

