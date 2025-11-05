Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F183DCCFA04
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 08:20:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 562CD8E0010; Wed,  5 Nov 2025 03:20:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53A558E0002; Wed,  5 Nov 2025 03:20:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4775C8E0010; Wed,  5 Nov 2025 03:20:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 367928E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 03:20:01 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D5CF21DF6A4
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:20:00 +0000 (UTC)
X-FDA: 84075855360.22.0EF21FA
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf26.hostedemail.com (Postfix) with ESMTP id C2FAC14000C
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:19:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XYszZf7z;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762330799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qQrBXNgrEH7DGm+hsPHKmGk/jGaaI76D+GIvDvjNENU=;
	b=p+5wt98QB55lScxi/6vveP3+OTZFs7bsxn6ida5taYaFcUHqcrz1XRomuBnfqptYxuok47
	v+V5DgKOQsbJpYaOVA/4vSJXnKEJbSOqFLI4Yb97N9Lp92Ppt9u1Fn77COYsnMPH5NG3b5
	dbOAA2I1G86csE0GRnI9Ay3SSR/2ZhQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XYszZf7z;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762330799; a=rsa-sha256;
	cv=none;
	b=0mIL8ZaKhU1kJTykmMr4f5K4eWgaMQpiCWhHZ/Xv2xQe+7xBZ+E+Z2Vtme+AM9A8mYmhfi
	BUIGg373B6HVEUXbzPVgd38upPTDbmH+DazzV3bWOY6WuMXjhw6DrnMuT3vwkbyfTF4IpV
	WQg+CpCNvtdE0RnqKQ32ZaVLpZ6H9e4=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b7260fc0f1aso205509266b.3
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 00:19:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762330797; x=1762935597; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qQrBXNgrEH7DGm+hsPHKmGk/jGaaI76D+GIvDvjNENU=;
        b=XYszZf7zp2h0mivZ10++hV2u/Dv/z/jr1YFUxIlY44CFBHk1V271fM/Ttqqmw6mL4R
         P5uiQqSsHU5qK5a8+r0mv5W8nAV2TfUVqOZRguoGa2JyuFZ/lRnYC5h1wKT+R8g/L1yG
         mD9Vzb1jybLLE4h30gRnViUjWv7O/WgkcQ9GreV5NZ4jYnqei58qIEkrfM3EJMsHEfJr
         zZ1afva6G3U7pMkFWjFMRR6GXTs5FRQ6HtzAVRQb4ea6L01PfCfAU/WtzCK58CDNVYOv
         3hkzJ1SDym+ajcxQovadgx5IBTY3/eKDBjHYgGoQna3dG1gD4uRMpdUYEMB0c2cMyZkc
         a8YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762330797; x=1762935597;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qQrBXNgrEH7DGm+hsPHKmGk/jGaaI76D+GIvDvjNENU=;
        b=XrK2NIJbMg0DerMo3pgQSP1SFw7zhsx517zdrqQ7Jwxz8MBCL3HYdOu9nf/aSkC6jj
         frsVMTRsKD8Y+wIR4d9AMR3jpA2522rXTr3cdIJoR9q6+Aoaaion5BdQklfzSoH8fPSH
         RGf2HDBZO1TSwpI04oFG8lQf4HgZClm1pfNcax6qqsvuEaqBpMajX/skTJugrYVZCquN
         knXxL9QQ+wNGTZSDDo59Iufe73e4CNreE1MfokyvBtXTgbjlHLsc0rYzL2oYf3r1qAWE
         izHHjx9843e+XnATodiuXmEbH8Slph1a1QWUiKzs9uLQmyNeJjW4I3r0COddR8lOy5IV
         gcpw==
X-Gm-Message-State: AOJu0YztMhIEMAcVe0zd+kjIKun/IiniQSmSeN510ozGd89aycyG4jkl
	ttdQy4tthZ60hpWS8VSxZT3/nwbRgKYjy2on11RFa68kM35I55NLKtnpfytxuY4E6QQ=
X-Gm-Gg: ASbGncu9t0eArRIMrttnmWGLHZV9Aecb/1Czvj397THHxh1z/iTHoMFngHt4Ip7vUyr
	cP6N0NMFWkk9/5ZP75ES9W7CjHZgPINrygs45PBKUJe21yWIfkV/fIbJubOwXyeo2/OFcAnZ/Bu
	+Oz81NobZ8eM6WE33V4Zp0JPT6VAs+C8Fi2peHpGo6zOqzLZ0tlemA5qJaxo6sMdxU8Q7pS0zcd
	Pxz+Fxs1vCvOZv+qVIz82J33HB6U9flJnxwLX0rA5QxlpQ1OcEal7LCu82V+ZLPC2y5uF8fUUm7
	2hoctOpZo6EGxG7IlKeXFzoKjiwUkeGo1twLbqZrgwQIfk+fYKrEC2tnCKVKsrdHE+TcUHRnvUx
	6YZSAlaedektzKesqpwmbyOPDUd1sz7SxGk5L94Yo4THKew6dBL1hxyOxZoUeh5aQZBT+c8yCWI
	b9HgqxmxVyEGPqeg==
X-Google-Smtp-Source: AGHT+IEXHVZLvJt37T+Or0zq36XdlBJ5vgi75Kr1QEZUdY14YccQtqD44O4+t6LmVKBw9ksebwzytg==
X-Received: by 2002:a17:907:6ea6:b0:b6d:8e29:8f67 with SMTP id a640c23a62f3a-b72653eac19mr201927966b.26.1762330797054;
        Wed, 05 Nov 2025 00:19:57 -0800 (PST)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b725d86b9b1sm269126066b.25.2025.11.05.00.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 00:19:56 -0800 (PST)
Date: Wed, 5 Nov 2025 09:19:55 +0100
From: Michal Hocko <mhocko@suse.com>
To: Leon Huang Fu <leon.huangfu@shopee.com>
Cc: linux-mm@kvack.org, hannes@cmpxchg.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	akpm@linux-foundation.org, joel.granados@kernel.org, jack@suse.cz,
	laoar.shao@gmail.com, mclapinski@google.com, kyle.meyer@hpe.com,
	corbet@lwn.net, lance.yang@linux.dev, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH mm-new v2] mm/memcontrol: Flush stats when write stat file
Message-ID: <aQsIq_zQXMfNNo6G@tiehlicka>
References: <20251105074917.94531-1-leon.huangfu@shopee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251105074917.94531-1-leon.huangfu@shopee.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C2FAC14000C
X-Stat-Signature: 3b1ny6audo3gbstjgxabgs3rf1qy5nz3
X-Rspam-User: 
X-HE-Tag: 1762330798-948010
X-HE-Meta: U2FsdGVkX19XiplW6wGw8ZWYa53RKj3hrx3bgAxF5aZY1sguqu3io8XeBlB/iphPstphH+vOzkzBoaEDZ0QzdRl1DJkuvWJ12/spQRwBowP3beQBQnS/iGBoFjF1hV5+XKJxVEFcdPEAP0eWX1fHLpOre+VOKC36v8Mx1Ymbq9U0hcnK4Ljpa+Obu+miGwHKN9KpeD2qo1KyrKKYZUcYrfrUb48R+60XnIf2jh4xEExmU04SR4HGRs18vl7KIiJI6wKhS8HheM30Vn+GQuzIpmI2BCV+5v+rVmb8XGr5lesFr6Z+fqZQlctJKRakwCcgK6cdWB3ijeKvzw41RlUTNuWNXlhBzx/iZRwEjRMoy1kHHHAED+TCHRF24m5sG9NOd11pVdfDB1R6Dd5ksaeqzZGht5tfR+ONG4Av1GMM+H/6q8mDeFACDjx2b1u+u/GpwjVwnxs1KW6ijLvIY1lyMGfi9JvN+LH7R+7jrHJvaiqT1TgPsJxGkdsMitV2o4ZcMTiiiF4lyJvy/ymn9tG58dsxQrTCQP3H0MJv9PkL0IxDaq8hsbYVkpnsQG1NPRKwXUyoa1kRVHSKEjbCvxcmKTFrujvmLiMJYaeDpPsasut+NICiupxn6QBRcfrbp5gLwfKBzDJGFpGVs5HWFlpfsmEWoTW6Kf3VWDsZKJnBXDkk2LKMB1noNkl6ubsCaDnLzHd/pr2OHn0gN1Eh0rsN/jjF09p7f1hEvtee1xWUQX5vqbf/hRIIdq1n9EHafMteDBFcRBP7Pon12KRHhwsUwLVBLRKtYK/GXKhCxbhbs5uoStBe2a9tO+BBzAg/nlnfK7eSQ+/W1VJsX/iXkSTYBtLJ1Mxf2RsvQSSE354dVwPPpNSaeUO5j4j8eqAFkPqMZYMnlS4yAqKCKrq67Ngmb8L+Bz0tz25Rcd0n6xtYt9W4N33nuoL0FkgPEIRPqTNmnSQEZqDEU7bFw+3IhXv
 mwjA/V6K
 jHEK5wHaHvvn+OobaoBy4NkkpC2kRTDHPwuQqVhLaCU5YLJFzrtGZ+hIZ/Jr+yDFvpeWhkmMnauFXWnMBSVCinyXwSGH2I/jNShf1O/gBiikGbAvuOFHssAzInWmQ9HttAeMaNFETHzdne/NWcUlKNnt2l4SyykOgdDQ2JF/SijXu+9oQWqpEXfGOeOhzetmkQLwoow0u3zUz8fkFEszS1WZ6ZZ557TeVOe1Qktj5wpB7iIQEfh03aHC4YNKaevi6peakSVIGWbnDECBWNKpMlBXKooR6sr3KpmCqLUVIc3RRNV+HczYjqxSYAUyEFm3HVodXuiy5XIVfcKdwt0udx4PXPKyIJOLc2P9PcsjufH5QlrftIvIAvqHyVDdPLsJ6BIB5R/WblnQ4Yfv0ktgr7V6Pjby+hwvIKy41m8DfyZJOYMo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 05-11-25 15:49:16, Leon Huang Fu wrote:
> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> index 6eed14bff742..8cab6b52424b 100644
> --- a/mm/memcontrol-v1.c
> +++ b/mm/memcontrol-v1.c
> @@ -2040,6 +2040,7 @@ struct cftype mem_cgroup_legacy_files[] = {
>  	{
>  		.name = "stat",
>  		.seq_show = memory_stat_show,
> +		.write_u64 = memory_stat_write,
>  	},
>  	{
>  		.name = "force_empty",
> @@ -2078,6 +2079,7 @@ struct cftype mem_cgroup_legacy_files[] = {
>  	{
>  		.name = "numa_stat",
>  		.seq_show = memcg_numa_stat_show,
> +		.write_u64 = memory_stat_write,
>  	},

Any reason you are not using .write like others? Also is there any
reason why a specific value is required. /proc/sys/vm/stat_refresh which does
something similar ignores the value. Also memcg.peak write handler which
resets the peak value ignores it. It is true that a specific value
allows for future extensions but I guess it would be better to be
consistent with others here.

One last thing to consider is whether this should follow
/proc/sys/vm/stat_refresh path and have a single file to flush them all
or have a per file flushing. I do not have a strong preference but
considering both are doing the same thing it makes sense to go
stat_refresh path.

In any case, thanks for considering the explicit flushing path which is
IMHO much better than flushing tunning which would become really hard
for admins to wrap their heads around. Especially when dealing with
large fleets of machines to maintain.
-- 
Michal Hocko
SUSE Labs

