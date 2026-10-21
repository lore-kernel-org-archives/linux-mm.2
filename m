Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B05B606A31B
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 12:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=DYC3YpNR
Received: by kanga.kvack.org (Postfix)
	id 767E36B06FB; Wed, 21 Oct 2026 08:28:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 718A06B06FC; Wed, 21 Oct 2026 08:28:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6074B6B06FD; Wed, 21 Oct 2026 08:28:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3DFAB6B06FB
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:28:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D25BD1C3228
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 12:28:09 +0000 (UTC)
X-FDA: 85346560698.18.ED75A20
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0409F140009
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 12:28:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DYC3YpNR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792585688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0eU6RtwaBGBVUdLrxzNH+pMOcJGbeX6TyDSST0DZFlQ=;
	b=xGkZBptG95aPUHH41iWNeriU2VER68xfxoqfz6vK+5R4II4kPM2/yVt4n6l6skyRvapA6N
	4PcGg1ESXMyc37bbDG1gHbrxTuTk1l3nIuT0jc33jemIb+qB/xXb8MNkuWZAlnA/xMNmdb
	222cTgfQS0I1lW4A/gTCe6I3XWpJDTc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DYC3YpNR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792585688;
	b=WLVJV133TWxB0tcc/QNd3oDrNMX1SsWHqm+gaicqAoQwSlQm4OCIDsW0xWWWpaZVnxR7ZB
	XgoMsQ/BlKwM5TzW3tuhTZ7UpQSfVIleVzJsfE/qSy4iXwtDC2W+MCxoP/0oMYIBJu7hxw
	rzt2AwM4a0R94KaZYXQ2XOILn2VKo5Q=
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-14388db1a6bso13915c88.3
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 05:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792585687; x=1793190487; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0eU6RtwaBGBVUdLrxzNH+pMOcJGbeX6TyDSST0DZFlQ=;
        b=DYC3YpNR82AyCNSl7pz29SUuYO2hb2bzaIpe1M8YQlDyCeMwmG7sEcC6QSQqIIVuD5
         yB4OBFtwzmEaF4bLY+pZF/7dhnEA+RuMcYCSBaRG5ggVVidj0OrwIJC70VaDAF0nKRaM
         Ar1oVhQudC5thyZKYod//nfZmgEJxyj9hQwt/lHUF2BW3TffV9eY7C60A/Aak7AS31Ib
         wRyVBiAW8sKpXu7Sk3kLXqEgwBFMvANhCIGg8AbSA5ifXqmguVrcrWqeK0LaRQJEcT1w
         Q99V5BYUnbj4kvHU6aBrkgXHWBd44cjSzZElx6fSbl2sx0O2C0JJ5mlYmMEqxLopVUnr
         z+Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792585687; x=1793190487;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0eU6RtwaBGBVUdLrxzNH+pMOcJGbeX6TyDSST0DZFlQ=;
        b=bi3hYpCSg34AtrWRouyZOVAlABYXS7EKizf2YwrtGWxlYRqUIABr3sDSHNuBLmfXsX
         PBwgSZtth2vr4lOg/sCxeTNJ+WqTH+S3FaouFKoJVgki59n98fnLpropyR0LUAfEmsRp
         dJuox+r2DHocGFmyBJcjzTv8QJzQq+CJE6u2ivj8Bz+frz9Cr4hS6EeQHNhs7mPEWske
         mTQmJQYgA5tH3+WUA6tZUn0AQ5kHzqseyoSHJcvaDo8pAwo+R7ey0+afrswly/LcDtlj
         pMie7/E9MMSqyo+1lTTpBB2jsm8V/L+sqUNB3z0wdLU6un0uPsXkTy/V+QmgtIPXsfXd
         8BbA==
X-Forwarded-Encrypted: i=1; AKwUvBy3u6BLM3CKAu0EkRFLBm9/UvJvLf2ArctOHRw97DWLieuXZ7NyIWo4RP1lwN5s/9lEf4gcQjQSpg==@kvack.org
X-Gm-Message-State: AFq9FYJP2hZRgfa/zNYcAzwCZhB69ZvjbxcDkULOdWeXJB1iOlEiN4Zz
	bO8UMhlFCAaknf3+HZUq6cPQIxW9/XEyCjcTbmA7jCXilwoto4ICMvbA
X-Gm-Gg: AYBFou0LDFWK85tHUbivSAbNzJpfUO4GGTb3jfWLGNT2tEf45FPMpZLUsjX5+arftrf
	hQazgSzaYzAjR03v+e+T6vcksTAnYIDOy9UP0OGmWckk4rJZdeG8YGpiNtkGigWUaxGuV746sR/
	65LxPExBaZL1QwlTdAXkWFO3Pt+0NpfOUBlHjutDA9tK8343R5J4XUAsOjbD5HEQTSgG1EUIAEw
	IwyS3WoVcISTWZxDgxikNuiMbQde8a1InTYDpTTU6uCW6o6Co5Bdwm+gVgv0E/Kp5EFuMO5ulRX
	2a3/LZ4ezxyHyeg9L6/mLns8fAz2MRLunq85/LqQyymtZt6qM09bmSf8xEWV2xE59pVbvIXp/CV
	FDoEnsCVe6TPh3z2es55d0yeyo651MkjLr+fy2/ZHnY3r87heE9Agrzl8lYwpAOS5y9ERHMFvxL
	7TFX999k/vUIQ6/NWZlqGJU/LSry6BjVXVeHA9WdxF+AFHEbky16a/azEv+ubFPP0+r1eFslscr
	8AvLq8DBeTv4VDFQ5G2xZJFt1wFFCBRA4jtCtdWhjP4rM7/0xoL3CtH9/6a6rDmj2pPVSP6qJUa
	NEGfVOVybo2W2P1olQ==
X-Received: by 2002:a05:7022:f519:b0:14b:edb2:c3bc with SMTP id a92af1059eb24-1909acc857bmr3334418c88.0.1792585686379;
        Wed, 21 Oct 2026 05:28:06 -0700 (PDT)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-19035926fe9sm4935059c88.2.2026.10.21.05.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 05:28:05 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: gourry@gourry.net
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	dave@stgolabs.net,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	stable@vger.kernel.org,
	weixugc@google.com,
	yuanchu@google.com
Subject: Re: [PATCH] mm/vmscan: reclaim every zone in per-node proactive reclaim
Date: Wed, 21 Oct 2026 20:27:56 +0800
Message-ID: <179258562954.2.15216681747698947501.node-proactive-reclaim-review@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261019185002.3428594-1-gourry@gourry.net>
References: <20261019185002.3428594-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0409F140009
X-Stat-Signature: xzirojtxaj7eudwdyuduofc7rprwqcr6
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792585687-201641
X-HE-Meta: U2FsdGVkX1+01Mj/zSZz27FZgP3JvWoGOt1SJwMDGiEcl5NuK5ifbViNV614XfqDwxodr/tZM4aX/syN0CBnuKzUc+2wkdgActKDnj5iE8SiW0ZR18k71AwUpXbjsvfoG6mVzQPSvpbFUqlsWGlIdOtG/7TATlsBnq4Ecb+89udSsuwGlGgRDLg6Il1tZzdYOx9YNteMrJh2X6w0M9AkGcxHIIeUTARbFVfiRYNx0muiYQkpW8ofvJQKRzcIZfe3T8hl37YARKIMr5DZyPWubmM+vm5jMkb4NXpGCQ+mLldygig/YjNhfroLaeWZXfma9wsQ61hbfgeQeFrv+yCi9iUKLKwAuvMSLCpGHOIOmJmE8ZxDfQe+BAT6DBXyNMtpIkm+cvEVBEY712lG0HxU657aSUhW5ucYd/NRzKMNTuowW45QmHZIuQbN4CBOByrQIECBREMLoK0OJbjTWBhkQ9zBEviKhrPBBDg3m/IJknEJpLhHgJHusAB/5PS2+YYPPKJsHg3mM/3yPfJKFXLlJhgvkHtxunEMJM4R7xxJZQUbTkbrpx+ncvjo/qQYneHsaIsf63bK1/9+a9Wo33FUpfSIkd4p4hJnaE8TqTAj0ir4bCPu4ccKiiI+vnXu7TOj+KU+NSIT+MJ9T+eUEIGxz7B57tKebdvnjAzIV+v8bjwa4pbzFxeQFzzNqoWk0BY059XiyBqP3mcm7PIgr7diwJ5tRgLKL/J9N2+ArReW3OkCnBbH3WX6hkcloOHwnyR99K7sfEc0r3bPRYFaoM4oSY1off6Sojc/SjtNiIaIBZ8ruzVRrXpxf+xYB9LjA4RJ7yIYeiSxxg05uvLpfv7A1KTpx6X1zJ58kttMLWSmrKl/0uByearjndoG/1Bmpvg3sTZRc8SuvhUx7Dm9TLxsJlaj96dSSkpV9mktbwQ3kvw7gveMZAQ3w+/AAD9K9jWg/H97blBMAOGr8cMA5ly
 nw1HiLEi
 8hrxvPt4r60e0T+oaNPFu1xiwxziUkPH9FUdinyXV1AxH+aPjmiVCPfIq3iyPZM0bi6Osj8F+CMRvEBdSq9/GaFkwwmC6FtjWpAIh3IOosNrPpXztsmzBk8ki3SoJfGeXp4WxAF7E5v5GMxx4dQ7fy+jYZaR9c67gDrZlzdhz2i/sJ7SPW1XIzMXxLot05sXPnkVQygKkzQNblOKtj641dy/VAiUuj6kYfWWjUX3LLl4nS81rNndhfy/DCyel8HlE6LewTXjnzzAbo9PUtKCAT5/ereuTLmQoaJOtE6VKbmZH3GWh09QVFI3/et0J4lbSs6aYnwPb2uGRubDjimwF7n3SAcv6IVbeKVjYIcZLKfc/9VsiVoNtEwKQk+qcKxkKG0Xa6+40ZgwHthflyd4ha3mVfy/JHX1NvqHi5y12QwgTGr0jU0In+DF0WdeCtlHgfPMWpZVjuthMudinQZenvVc5oo45e6vLOikUNjiBvGpwycc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Including all zones makes sense here, since per-node proactive reclaim
is not serving an allocation. The existing GFP context restrictions
and folio isolation checks remain in place.

Reviewed-by: Xueyuan Chen <xueyuan.chen21@gmail.com>

