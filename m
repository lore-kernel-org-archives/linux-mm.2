Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09421CA101F
	for <linux-mm@archiver.kernel.org>; Sun,  7 Sep 2025 23:53:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C25F16B0005; Sun,  7 Sep 2025 19:53:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD64A6B0006; Sun,  7 Sep 2025 19:53:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC4F96B0007; Sun,  7 Sep 2025 19:53:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 957CF6B0005
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 19:53:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 367791A087F
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 23:53:37 +0000 (UTC)
X-FDA: 83864108874.03.F678AAE
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5926E120006
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 23:53:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mJProFy6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757289215; a=rsa-sha256;
	cv=none;
	b=Evbkefhu0MzD7J/HzlKXBDQh9vv9ADEewvaMjfMB0igXkFaF2E6XfTRRGEb1PSjmAzgUoy
	vi1cQnQQR/NZJNj4AmmXVwrqzm/AIBvgRgF0JIPEpkuYBcgr680g08jmz1GP3gWR4lXPRL
	p2nPjzRX5kDv/51jaa6s3cWYMcT7LOA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mJProFy6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757289215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iMHej19+bbRiGvdkiB2p5yaTRh1Z3yRBnJ9zIpV6AGg=;
	b=YZNc8TYUVYhm3Iw8yqBG30Eoa17gpqv7ru0uR9URxsAW6Z88cRxr4Qzli/W9VG/NIrH8Na
	QvqUaDqKov65w0SgRQz4yHWVSJMGkWNqlwtZsexmMESmRGhzKW0ux/igflXeW7A+zb2uLn
	AEhHjwW/mukSiwGJxbGH7eTj1ep65/o=
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-71d60504bf8so37013617b3.2
        for <linux-mm@kvack.org>; Sun, 07 Sep 2025 16:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757289214; x=1757894014; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iMHej19+bbRiGvdkiB2p5yaTRh1Z3yRBnJ9zIpV6AGg=;
        b=mJProFy6VIpaYcNX+7iKJ4/M7l85XY5zrJ5W7Ak7pjIsMpEi17tkeGK6uocwM8UYvL
         qbbArb57Og6r5MjRyW+ZK7wQHpESI/LO/eFolb2SfzqHcIDKE9mXOVoMb9suYAV3SXm2
         ip62PA+4dyZtCd6lZLAX9SekZMqEmE23fHZmM2UpPhGo6xDj9OzmVdiDwsdXLDBX4zF/
         Hy4CJkUeS2JeudTkRUJzakIUIHBfkG6DfK0jRw9gJvwx/TrJfGbJyvHChWhXOlZfqrk/
         G1SqKRLpPP4B4Bjx1a25rj6cC51JQ3NRzW78mQI/7Bv1ooKHCCiNaOoEJ4zqgUegTJ3J
         iaJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757289214; x=1757894014;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iMHej19+bbRiGvdkiB2p5yaTRh1Z3yRBnJ9zIpV6AGg=;
        b=GnRhGnYCOLfgVEV+uIeF/jP6ARXjNfG4tCBa0bGyct191wo4lsYshUsleq6uEYaCML
         DHIFPcAxqJR5AAWnl/pPWBDHMjw2wCU5nQ99e3jaJNSfeUotIFJRdeATAOYPwucXrYSQ
         dC7DEhdcTy+e0g5ZbWvTMAFeOKoFNxUsW46mENszx4BoIlMtCtePdnjS2SdrH0FQ8FFq
         8yXOdtFU1xF4mzHMX/9C5Glln/xFfyZz0vUszvjjz6Vcm8TQ8+J/imuOpkvtjz6e81OD
         oiJLyWJaxnRSsI/8wzTJ+3e0EZ4DEDD1Ey0soctM/xiujwV2F1dH/mCDCwUsgScjTS+Y
         CPnw==
X-Forwarded-Encrypted: i=1; AJvYcCUI1dAvCB9xvyYc8hS3DGr2VOvtkrlBr69bipnknyEYfsGvxP9in4tbpKgjVYIA+cbtN4fVhLdtYQ==@kvack.org
X-Gm-Message-State: AOJu0YyBqTABPVmp8HvUHyfJ7/bjW5OZXdsk7FI6lTi1Pz2lUl1yApvj
	rfdBOWdMw1c9USe44Tr0a1j67CfIr4biI4TxS0bj0Nm6M9L3bBwz+Den
X-Gm-Gg: ASbGncv0Jwk0ut64DzFdAM7J3BbnmgEmVnpA+NaB9//l/5Pf7+PtBaNs8X4Db1/fFQ1
	zvcuH92SO0InibVdltfXKjSgg8ZJk90WY3l0l67Cd/Tj9hyrssgzlsljBpvvX8RhYA0Ii3JpCWg
	RvXRBIC+tb+NmYpKkH/GzrU4HhqI2Cqo7e98DmTMCv7HoYyTbGprolOb2wDpHMwGoUygBZfX5kc
	/J1MqpN2GxyMdwstRhfCCmaftPLWSWBLMKU08nfaymdKOzs7nZPRTO/jIamE84vWlOB1NbvMuJL
	Pd1Ig1L4dmouKSPYNS5qGxy34V9hupjwFGm68v+VuFRjHtjhIU4Zlpr4zfoAg9IDmp1Sae/uPhx
	EYpRiQXH4rqY0kttPAwUCRK3zb4WKIJCFloFdhfGibfTPam3gP6BIFLDcngvMCKZD
X-Google-Smtp-Source: AGHT+IEpu6QZfFLJHGF2kOjvkUSt3rcdARfVMcNb3qxEOMGfRpQjg6afnJIPRstWXrZYfYYSjN0spw==
X-Received: by 2002:a05:690c:4489:b0:71f:b944:1000 with SMTP id 00721157ae682-727f6628345mr53689367b3.51.1757289214270;
        Sun, 07 Sep 2025 16:53:34 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:70::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a82d95easm48406367b3.4.2025.09.07.16.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Sep 2025 16:53:33 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
Cc: akpm@linux-foundation.org,
	david@redhat.com,
	joshua.hahnjy@gmail.com,
	ziy@nvidia.com,
	ying.huang@linux.alibaba.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/mempolicy: prevent the risk of division by 0
Date: Sun,  7 Sep 2025 16:53:31 -0700
Message-ID: <20250907235332.931050-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250907160829.91628-1-chelsyratnawat2001@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 5926E120006
X-Stat-Signature: roe93wqbt9cpzjbi4dcif7imrjnkemfz
X-HE-Tag: 1757289215-864222
X-HE-Meta: U2FsdGVkX1+ZiiyNZHSN4VNqxoD5wqZGyvkPVH6+m66FLAp/SKQ5ZnxnvMF9ZSAUFMUlWrMdqF9WnIu7hGmydlTVAZQKAvKhyiZ1FkC9lVgvv490AqOMSMGGT8t3kxItw62hVG3PrsZHrumt7B6uFN44H8/jswWGS2KbeRj33B2iTPIwNPDlU2ZrO7x8cM2wxlOBTzXeA65/YuYwI8XYKkPJnP2kn41luIW9Pkv6JsSklQhPBAcX8tNBII4JO9wye67TpmCHw1VypXJd/rAycf0fMOghNRqxoH3xDSv2x3ryMK0DIdWeMsNZEkYnBsoi0eJt8+40ywS/kqjShz9Q3hVZbYdFuv23qjNWjNVE1YrP8ZU87VuJ2n9yksD9I0yXhrAF6Hq+95cZUEGi7X5uy2N4uv5k5aOIgcUa99Bt4DGI41trmX71fOeGHzHlBUpBDIRG7Z85aV6eYOVj7LjfBOEgVH+NgTBwzFLQc1yRMT8p7dmz/oQwpKNGxMSp90G8RyKOzp4JDm2N44ML4VgyCtUZ4bU/MT37TbZxJGpEyMD9xGl+3lyAt29BtPIV4H8iKG9wBKvWNr/C8XKruFbPYQf3d7yJKqYbjHn6+WSDSnGalJKHNO9YViSt/AH4AWpb0Pu+VnTjh9pOjPKUuToMjx4XyKbwyrrRUHHyNrYlWV4DSpNEzFKnAu+LV9PIi6G6+6dfeRv+ePM0/OoFFgsFrz4N2bObcHyXVfar+L+K1s9CCSLK6t5hteSxiTOSgJrjyCVqTgAUhvMu4Q61r36JhDDlgE6qn3jOTLDhXQcc3HawFHM/ma9gfTI8sjsqdocz6mYMbrgJK+c+mvNi8mpQjG4otWIBjgwU0ysodUfxM/lJrOcrg05+ch1+SNrQmh2O9HJqhZEmY6M71HL/S37yG6aw3kIFz2UDWhdmlsVtJrCfpod9gcczNWOtbQ6zuZVO2Yjv9+lx+mDkJ0RCbzW
 QRa8HIgi
 1HJyYwNrRKvUQCfPdIrr5YzccsB088TJcnW6jXzi/uxc5QyeEeCoCTZyPZKNKjA0M6y6xMl3CG+zaHORLbQmE1tyHJPcrgUnFS0MxXmYsOdm4Ca6nPOD/vIcc/lRR6x7kQnbKUcyNpVPa0O0HT37HWNQkNy9Iusu7OLKIDKFW+6MVg15YI5J80bZF3jQJYwlbmAu1gs8jdYuUnFnPYWlx5LmWdGZA2udNx4a0V5A/N33dYy3Us+/JcBFGPPbaX/D1B2uKlhvhZVnJfu+K0nRxzFPyKDUoB7goMuwK0yRLkbrewMfpjYYfE8d/bx6PZMiTmMbfjmWOMPvj68zNolKqYaJkzOrZySLUFe8bGWT2MxWbRZ0IbWwlK6dNhYMM4TuW0/2a/Ghb0PYKWbEIt2udkxQmOGjzQz9zXvSSL20aPqcHCqCrFT2zrlewgqcUbMuPd9l4hHS20AHw19x9sVoPEF4n1pSGRpLcajEX+XIyXu2yfroAiuiJKa8cG93jaW3xzUd9QSRTaMEognUm4iDP1mU+Hoghea6pa2E55W8PY1OlaKZO896cmLrBYOYoZRXj/q8TjVCZypDtw9+VuQxlpHi53w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun,  7 Sep 2025 09:08:29 -0700 Chelsy Ratnawat <chelsyratnawat2001@gmail.com> wrote:

> If no bits are set in the policy's node mask, then nodes will be 0.
> This patch adds a check if nodes == 0 before dividing.

Hello Chelsy,

Thank you for the patch! I will start off by saying that it probably does not
hurt to add a check like this. With that said, I think it's best if we clarify:

(1) Have we seen this happen before?
(2) Should we add a Fixes tag?
(3) Do we expect to hit the nodes == 0 case, or is this just to be safe?
(4) If so, should we do more than just return 0 (i.e. WARN_ON?)

From what I can tell, I think it should not be possible for the policy to be
interleave, and the nodes to be null. If we look at mpol_new, there is an
explicit call to nodes_empty that checks if the nodes are empty, and returns
an error if that is the case (of course, excluding MPOL_DEFAULT, which actually
throws an error if the nodes are not empty).

After all, it doesn't really make semantic sense to allow interleaving across
0 nodes ; -)

But as always, it is very possible that I am missing something that you are
seeing : -) Please feel free to correct me if you believe that is the case.

With all of this said, I do agree that it's a bit scary to do a div0, even if
I am confident that the value shouldn't be zero. I don't have any strong
feelings about adding redundant checks, so I will let other mempolicy reviewers
chime in with thier opinions. One thing I do feel strongly though, is that if
we are to move forward in the patch, some explicit clarification that we
have/have not seen it happen before, and a WARN_ON would make sense. 

Thanks again for the patch. I hope you have a great rest of your weekend!
Joshua

> Signed-off-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
> ---
>  mm/mempolicy.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index eb83cff7db8c..faacc604fc16 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2530,6 +2530,8 @@ static unsigned long alloc_pages_bulk_interleave(gfp_t gfp,
>  	unsigned long total_allocated = 0;
>  
>  	nodes = nodes_weight(pol->nodes);
> +	if (nodes == 0)
> +		return 0;
>  	nr_pages_per_node = nr_pages / nodes;
>  	delta = nr_pages - nodes * nr_pages_per_node;
>  
> -- 
> 2.47.3

Sent using hkml (https://github.com/sjp38/hackermail)

