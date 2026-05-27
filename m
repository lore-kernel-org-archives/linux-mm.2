Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 285E0CD5BC9
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 23:42:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78CB86B0088; Wed, 27 May 2026 19:42:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7644E6B008A; Wed, 27 May 2026 19:42:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 653576B008C; Wed, 27 May 2026 19:42:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 57EE56B0088
	for <linux-mm@kvack.org>; Wed, 27 May 2026 19:42:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2641D1C1E67
	for <linux-mm@kvack.org>; Wed, 27 May 2026 23:42:39 +0000 (UTC)
X-FDA: 84814826838.28.25D67CE
Received: from mail-qv1-f68.google.com (mail-qv1-f68.google.com [209.85.219.68])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4F52B120006
	for <linux-mm@kvack.org>; Wed, 27 May 2026 23:42:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b="M0n2/WWh";
	spf=pass (imf29.hostedemail.com: domain of paul@paul-moore.com designates 209.85.219.68 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779925357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HU5mpIp08+v7UC4VxJJIUTVB47HlzTm6rBp+W/xs8cI=;
	b=BFoaFAfpI85hx3zoD9Pj0pY2yVP3kQ4DF68eXZsdFNZLo/iXM0XoKKuPab2mwC6tQBexi8
	IfM8c6Pja219mRVxbTH749psHZLoPEVVMg+gbjHUR2m8hFmWaIbx1mz7NFhwj9bnxWD+tG
	BbUQP/8nDnnu2ovVe7h4km/mwYYA4/s=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b="M0n2/WWh";
	spf=pass (imf29.hostedemail.com: domain of paul@paul-moore.com designates 209.85.219.68 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779925357; a=rsa-sha256;
	cv=none;
	b=8k+KoYhxR1xlmp2FNUB0dPamYSTz2qPXYZCUo1eQ6C5QMZLaq9N/160J/bGX6npARbkFOh
	DnsAD85pXKbSUdTuhXBGVfpv+YdwY+CZq7+KlvY4+bDXDf4su9kaxRB30zoBUP60kVNh0k
	gMT23U6VuHE2h24ot37inOBu8suyj0U=
Received: by mail-qv1-f68.google.com with SMTP id 6a1803df08f44-8b3fe2f19a4so133970076d6.2
        for <linux-mm@kvack.org>; Wed, 27 May 2026 16:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1779925356; x=1780530156; darn=kvack.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :mime-version:message-id:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HU5mpIp08+v7UC4VxJJIUTVB47HlzTm6rBp+W/xs8cI=;
        b=M0n2/WWhdR7I2HbDW3GhPOw93Ko2MR47rotG/D62sw8Ktumi5qGwMI9c2u4V9Z1SEt
         77ZrSA3HnPtd3uFZtuyDbc23ceauSR/EszjO5aVueqT4071QLRi3sNdw/J31GJUtOLKk
         ykr4oEdG39c64LrFf9ifzqHoBJEfkI4aBDqHKRfqNHqnHXJK6262fneutON5Jb4jSPhj
         4jEjBzBwt4az5LJFW5XgQwNZxXiMIxg/Nd+GO0PgTcBq4rC515SrQcUWDRLU2vqZZflh
         8Ed/O8sPlQZexHYhedGHR9usea27Ufb/l4rJPjo0+0dGcernWIkpvRST9R4x10XXvC9u
         8MlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779925356; x=1780530156;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :mime-version:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HU5mpIp08+v7UC4VxJJIUTVB47HlzTm6rBp+W/xs8cI=;
        b=aRvIw78Zd9WpzWAsz2+d1liDY6Yyl0QStDGHP2hZsP1IC+9CAnHiu8IUCIxAzhAJ2F
         ehmJeu04BDLzg9AyUW1LKPzdlaPN4a9YXKkFROKKJf06Rp+tqHGDAeSJnsCOHCcolSeF
         qXtIyh/P+IvAB+rtG9LgCC7mP3LPBtnzOkRouKoPwH0zP2vgkXEAfi8ai08DtNxzvoHl
         A9hv4RVido6mekmo/N/IT0/CDXg9oYgkXEzdThfAjM9xNTX+3M2ebElxyb9tGbNwtF9C
         ruRcYzKBiHpvD8WHjQVBk3BF1E/VEQDpg7jLV0LqNKyFFr2WWrjuAQW/VWCxKD43FhYF
         mBSA==
X-Forwarded-Encrypted: i=1; AFNElJ+aPrd9/4k3oDGCwHD3796fr9VOlfFGFIEJ2wQFoneSZRkFnm+bStI8Nsfp++TZFzs7PdlxzTDVSw==@kvack.org
X-Gm-Message-State: AOJu0YzN8jVKsmbcB9PxIoHQsvIkJQ1qT9/U3yN1PiHv4yOjk6GG6/0m
	sPQ5SYFql02sM0rqyLC5fl/akAFJMKbh7DSyyjUSTLlnNtR+qzuLBSwJFuXZfy9OWg==
X-Gm-Gg: Acq92OGvkw6tOwdXmK4AE89lN3LI4PrTBybxal5uGXLj4uCiXbmv6bLfiKKSwelCMQc
	VbGrokS+Lcus4/uL9hYVAw41R3TIbZvf2ziOVt16M+H6hBiS5h9Cu8agukoJCC77W/z0C6Swwde
	VH30DhbCYT3HSK15IyBbIkbzqj6If/FRSjW8Zv6O54xz9p2Tu3J9ueZd9JoeyTuroGOE1JJXZxi
	lH7drv8A1vzu8jNkvIrSZ2ALeJROeATQlU/m+IYYmjEsvJQPzymAPjgGbZ2kxaG0Ag4UBUvYOpx
	+pDdbX4Ir3xVmp1+ZHz8k8IB8zDRIn2091y5gJOz17gCQ5ud2DytxZITE+v0ye4ynA5CNCeVaSo
	zZ+ghwHo0bzIfNvq2V4iTkXLsEEMXojHqgdbs81yqY8jrJRk0a8NDHqrC4atG6witlGSycjmHYq
	bJJIAl2qtL3/lnTDX84hXLyP1J6dmsxCt3Si6TPVXfTPbXdZ0venumVPMHRtJMA5UfzRdcvLbrY
	W0SGGE=
X-Received: by 2002:a05:6214:3bc7:b0:8cc:15e4:1208 with SMTP id 6a1803df08f44-8cc7b65aa0dmr409956706d6.32.1779925356424;
        Wed, 27 May 2026 16:42:36 -0700 (PDT)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cc80ffca70sm181789696d6.22.2026.05.27.16.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 16:42:35 -0700 (PDT)
Date: Wed, 27 May 2026 19:42:35 -0400
Message-ID: <4aac8924f51f66daa69acd50d8b89f3a@paul-moore.com>
MIME-Version: 1.0 
Content-Type: text/plain; charset=UTF-8 
Content-Transfer-Encoding: 8bit 
X-Mailer: pstg-pwork:20260527_1931/pstg-lib:20260527_1608/pstg-pwork:20260527_1931
From: Paul Moore <paul@paul-moore.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>, James Morris <jmorris@namei.org>, John Johansen <john.johansen@canonical.com>, Ondrej Mosnacek <omosnace@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>, apparmor@lists.ubuntu.com, selinux@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/3] selinux: hooks: use __getname() to allocate path  buffer
References: <20260520-security-v1-2-831bd8e21dd0@kernel.org>
In-Reply-To: <20260520-security-v1-2-831bd8e21dd0@kernel.org>
X-Stat-Signature: bcdzbxwkrqjgyg1iywgmbzccqgxu75cu
X-Rspamd-Queue-Id: 4F52B120006
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779925357-158009
X-HE-Meta: U2FsdGVkX18KCSY7RA9e7Za2/HMEC3BqZejV4DBSW5zU8FnVQhhb6BkiiJTzo9NdljeWdkZi7LoeEWLjCatKzowMGahMnxapaYMG/qH+3mZmTpw9vzm6VAOzCWqxwKlEejKHb83vk/igTQ+XyCIVDGxbOKZe04JO3VehLw/XiNuwltz1X+zTpJppgytBTka99j7CjhdJj3ma3cWA9SLftqPimqL2kAQu4sWKCEVZ31Yx/DbMMndfuFpq+bMBBTRg3uioguPSLtAX5MtCEkJ1DWRHHvApYfo28ZbLpI4FJetZrWFu+VRtYfsYK0+omq6G2Na9DjOBZPbp3zQjO90wW9i34Sylo2yQMN7u+1fIiLKSVojrvUo7ROwz0G+f6n2SMQL5HpG1iP5jmenMQA4ERCmfC8BaQZmv7+FxeA1K4pMeTSsoAEUnSHQ5PIxbSffbCR4ySqGZH5f7c70shdVDB5Cjo56dpicoVycFOqj0BWHKcPtWt2goBhTVsYn1QeZmeBji8ALFnywaigfLwqJ9Q0s/UTd7sFtCRYnVnXYyad7xrJYlSMeLylLj5st+2yrmSCDiDcvhGtGcftv1hf+vekAawFQqmTlN4/3xsMcLf16TMnAqRw8IZr4T3lACalwPbpMrkIliKKI95/c3eKXm/6RlY2sTFhRElen+17GrnNavOBGBXeQrov/HzIlA4DecL4t78M/XHuNHki2XI1ed9nzlO3an2LCg6PUm9lgIAXCOvUUAYpjzz9d1E4K6s30UcOZvpzeyr9bHXOKhmqAS3zz6xEgCrZitlH9w1SHjn/rnvnUNcDm9is7j5ZiE7RP6uoAFLwRKHEhR+ck3MUw/3CrkNucajv5U2hZnlQkixXWfbgbcv3BtqJ1FVFGRxj+KyrJ70uSkoMBO3YnyJoSwnB0pc7WK0BtW91m/5Ia15kfeT1PGwqVReITmdKWqth1+Lnsw3d/jbXtn8cQxWkk
 +ZwsMgsN
 BLJK9k1V4GZot3FpRgqxYPuwsbpinM8+e86r4PJmyG5Lfe49rl/ZzTEaaLdvjkjLqbwkTZ7G0r8r9ZWSyhHZ4RAzvWJ2deqaQWudqXC1AAmTNkqeVi50onOElsPnxP8gThe5FXkPhbC7Ps4hfygZuN6Yn45OmvKZ7KEC5mXwWUo8Krewa8CwgQQLgP+CQiNZZxo5xxJXB5oW15zs5ogCvWeQx+80g1AO6n1GXvk8+sYjakhS8uYgUqkxZZKEDXuo9IaZn+DU+Db6bcZr+M7jvi+k4lVwBUzbx/yoY5U5QMNj2F3KEepv9BvZr+aUFvaJtojh5VkFUKf/gauPOeIYgxYl/z7vqSaWgCLJefK7fSJLySSQ556+325LID76ixhnu/jfsY727Qh2xTxBwuoZnsOMb1e5vArcqOika725j5pY8ZhL7E3tWXpBcRJS3nHjABzd9a9eTszO6hR29mVNqfoGd7qQ2JxRO+hEyYMKKuNgp0x+jf+TD1CJBxQNNyBFWnvIwEuw3WnPJ8b5i17bVM7oieGyNujYp6sZ1lp1I83JtnczPKVxwVZCZrEOIj4+SdP4C82pyhFGRkEpbB4i/aU8UFgKboY+4UtaagkZZXLUOeq7saGULOy/K6cfk2Yu9bpmvYngkKxUULXdz5Tpnpq6qY2ojteYLZCq/n+sB3YBxQrY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On May 20, 2026 "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:
> 
> selinux_genfs_get_sid() allocates memory for a path with __get_free_page()
> although there is a dedicated helper for allocation of file paths:
> __getname().
> 
> Replace __get_free_page() for allocation of a path buffer with __getname().
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  security/selinux/hooks.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Merged into selinux/dev, thanks.

--
paul-moore.com

