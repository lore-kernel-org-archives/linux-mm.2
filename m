Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65BE1606A335
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 02:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=y8wd4QIg
Received: by kanga.kvack.org (Postfix)
	id 91D906B05B1; Mon,  2 Nov 2026 21:37:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CE196B05B2; Mon,  2 Nov 2026 21:37:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 796126B05B3; Mon,  2 Nov 2026 21:37:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 375106B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:37:49 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EAC141401B0
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:37:47 +0000 (UTC)
X-FDA: 85392247374.09.A898C54
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf14.hostedemail.com (Postfix) with ESMTP id 18275100006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:37:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=y8wd4QIg;
	spf=pass (imf14.hostedemail.com: domain of danielmaraboo@gmail.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=danielmaraboo@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793673466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aEZiUdHtVe6n866bPKhnP+/zTxBd9R2ODjgeXi2Z0Tk=;
	b=GGEBYyNnfgmyoGfBvi2VuROoOa8Zf5kk1tOLi82Wva82ROrz8FgXUdPonJ4RUYULD1rPnD
	KbQNi4R+6nr2ewn3GwZzprYvTfolLQOezZlGrwg9wnzqHOQir9npjWype5vf2ImO2tCXLu
	/E/+WftjJzLC3U/lg7qtf5pCUq+jpVg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793673466;
	b=4OMDDpWufmyjF1Fa/Sk7VG5dG6HSzsn0JtYv5MLSmkFa2Wcfg1Gi+btnZtDS6KgC5tzySG
	phnu31tPrWkMYyS9RiVCnmtLUzSh5d8INE29shVmBckhvV6JOYevt/7qSgj3NJeBpCwTJT
	NYBnsTcO+DzLGCLbfYaZgF6GPuU5C3s=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=y8wd4QIg;
	spf=pass (imf14.hostedemail.com: domain of danielmaraboo@gmail.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=danielmaraboo@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-53fdd2fb171so46820841cf.2
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 18:37:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793673465; cv=none;
        d=google.com; s=arc-20260327;
        b=n+Oee1qB5pURNDUlyEH8o4803LznBDBrZ+o5ORw0EOOsnpQSA081Nn0bp5LRriRb+G
         OStqxmNCkg/ydGvT9A2rDJJbnnPLW2vOmsSOjJHQUlbwvRxBSFC79PEM31pTtEKLtaHN
         yoknxUn8nbkGzvioxaIRQhlrK1ZNz2k0dK3gl58UXpqHleyhyfdGRxJ07MglqOUq6VY3
         OpXJxzVF2murj2/OgrKks2xj3yYLlQwCim1aZcTOAdbWMorXYppJcNWCyVY9IlaXz/Kk
         pua/sh1764f7V/rdAp0y+7kUKaE/MvBOIWk5qZNZ59wgJ/lypb/fFYKkFuLSyWN0kqE2
         w7Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=aEZiUdHtVe6n866bPKhnP+/zTxBd9R2ODjgeXi2Z0Tk=;
        fh=Udx08PamDqeoTxOjinghdu1xK8ta8AhnITKO26QnCGM=;
        b=gwxGXvefgr+cyIHyCAUn5We1dFsMkRhqN6UsCt5k9GJnNEPv+xnUxbMQ+QWjdNKDAl
         q0MFgoYi7NJXTi4Q+/nKgaCr3Agp4d2YwSqcrOJgXcK4CHTzdeTxpbXLI2cRzLtityqO
         L+NAOwmXRR3wj2ySfdbVHA1g2o0XU+5CyWIBW4WgEyiQ9aEynpXFrQwoYk0QkR7beSS/
         8gx8UCEAQPDHt9NaEZm4exUIK32snG8K91ib2TuuouuVRC5UHUiHRTAeeKYUWlqcyDS9
         7kLFT2ly8d1cXoVyb+YouJQws+jXXkVPx6oohxf2q2t0NGpnTBxWRbJJVM8ZcnwbdIlk
         mYVA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793673465; x=1794278265; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aEZiUdHtVe6n866bPKhnP+/zTxBd9R2ODjgeXi2Z0Tk=;
        b=y8wd4QIgxNFLk+wjXEzzwSvaxHsi6R2yzUsBfOBElET4E3ZmqKEnhG3R1JG3RVAHl9
         kHztrXLWTtNQsaQg2YN0Prfa5asL93gpcCi2pVdrXRT4sqsXbYFs9Fvu7/j+GSW16sb4
         MxarrGbG0To+LHRFYhOt7+mIgUVB3R/D0Ht21OwTDzfwfsCViUtKYnAjWBtZZIemQx16
         RL95N7XLSUlMs2AMUGq3s8uTIbp4xTMd0HoYRaDr8myofZNOybhwI39DRCVr6avwvqHy
         Gz5g2+i2+sJu8zgo21mP3xS1OpVWPtlb300dRPXfqgYf6UXc3zjXQj7BtLz3/m4AlLen
         M1Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793673465; x=1794278265;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=aEZiUdHtVe6n866bPKhnP+/zTxBd9R2ODjgeXi2Z0Tk=;
        b=kQO3wffItuWzoFSxSADVLtnO/AemvIGIEM7zIjwsyXcyK2IYn3FO4GgsEYkYG6yibB
         6X/cHRs3QGMacHp8xSemlMpa5Glf+nOADTfzyKvLh01u1UhMoXgSvPhukzhx4Y+PvEhb
         Sv7c4n9Y+UjAwRmznYdH9lV9jiiHURKf86hVJUelt7MeHVe+yabl7QyJnE9L6XqjEMro
         DA5LcT26cyMNIk22JE/ibf39Gu8/EdAPrTAopu+1rkI8iCoX+X15Un+LIMsasHn+ifDW
         1K0sV4PRVha/5+ibNijW3MsJ3kYTwHLSxiq7HsqrcB926Rfd0wLc7T6BXjHT157fBDmy
         xMDg==
X-Forwarded-Encrypted: i=1; AKwUvBwBC8VdbX7g2EdRe1Pb/NpIksEpxejOBnDncnuohY3d3NwbLuF6lRWFheF8F2wvxH/No4QzfK0zsw==@kvack.org
X-Gm-Message-State: APuU4Z8bMefXViAsIXe4YIhzXQ2tfSYKuML7gbk8b9E9Qh2c7xxV7dPV
	Jni/yc4Sv3SZKB7S2IUeylq7dTs9tx9tFL+GKmgHWJCLj3KqOFufNSvwFiuCimTwiIeStWZp0HF
	TJ4oxKmc1Q9jQnElfqSKVsZ9NpVv1sSG+Hy4pIr8EFA==
X-Gm-Gg: AYBFou3mbfpZGP19FL05Nn7DLf7JCqqfhH+puYcSkL9P5hdcgvZva6oWi8nN1ZfLNoT
	16SfO9tc8CEPj+0Lubs7bq/hX8TA4nACOwT9ezykLfKhla5emxHs5cuVupl+tYNstOa6JbgGLuj
	Xs30/Eujny7eooWnPwCKAfHIfyp7a1YgyqwpnpH9/S9jfTY8/p6YBCxRsFQlMTX+0BVOEl+PceB
	1E0CElmJWdYpN+SASSXSb684vrEjMTLDEJM0f0/FgZNaDRpYRL/5U39vOUgV+7BZbo1vzkOmtd5
	NLTwJPzXd2fI6DAM0Z/pkw10FLasHHL1ckzZe5cSPTXl1lOE4/TnOFXDSDN6jXfRaVFYJivLvJx
	TLofQqPuI/yb+nTntYloWwgINu9yZoU0XYZ2yXrwLkXT8yeYhmZgFIBDRtc4407nTb898gtr+pn
	UeJ6z2kjRJfDFIw7nF7t5/rh6Gt1TPLeZpSNVKOY5vB7D+KS3Bj3OSPgejE0GQmhoGKVTihKzSD
	kYaJYMQf6O/OYtRKHbUxcl2d2Jj0+76r0Q3nZwOu0YNbXs=
X-Received: by 2002:a05:622a:1b09:b0:533:a8fe:e430 with SMTP id
 d75a77b69052e-542b6593777mr202082331cf.14.1793673465209; Mon, 02 Nov 2026
 18:37:45 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261102150757.93058-1-sj@kernel.org> <20261102150757.93058-9-sj@kernel.org>
In-Reply-To: <20261102150757.93058-9-sj@kernel.org>
From: Daniel Pereira <danielmaraboo@gmail.com>
Date: Mon, 2 Nov 2026 23:37:34 -0300
X-Gm-Features: AclHuK-Jg7-xraD80qWPaNaA0iIrhVFnMpsq1hNuG58d2LObr6cS1Stfw00xqhY
Message-ID: <CAMAsx6epLXuUjaV3J0=SWAuLvajr4h58DTM9gL+LMmaCyjcxUg@mail.gmail.com>
Subject: Re: [PATCH 8/9] Docs/admin-guide/mm/damon/lru_sort: fix grammar and stlye
To: manuelebnerli@mailbox.org, sj@kernel.org
Cc: corbet@lwn.net, rdunlap@infradead.org, skhan@linuxfoundation.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 18275100006
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: hr8jpwwfqs3r9ftnfummaau98jddxh3r
X-Rspam-User: 
X-HE-Tag: 1793673465-372642
X-HE-Meta: U2FsdGVkX1/zifbL42EKwrRpWoEli6IO69ik3BhsnyC+2b0o6EZWDAwp6wmMOusGwRn67J3mJ3zyTVOsw3SOn1qEFyyzgOcEt9yCFLBsvjNRHb/1H5Lvw+Zi6NiqHj4bJAFLftUTnxkTjAKvv3FJb/+ULTiQphcMEmvGK3C8h1wsT+D33FIq1lbr7KV42K65LMje6ksd4A/F/Vo+zZ19XEL8EoJY0W6jOK4+jVOFaPgEHxLxyghMgFofhxisD+L1qjrIxZtjOfDcvIQ3tNYvnKBc8MtpHzTBdYUYaDu3Y2gQrAqhVsIpN3SRfIA6iWtznClp4CP+dndIgRPrScEIOt/Fn39rrtDlRr9W+/pQzGUqXfKXM2C9dF/qF59ZczBIUAaczf+QxhAy5XBeLp5VHOTD/UmTtBxz8ijamSUqNV8xvIK/WjU4+Ro8zOQvb7gKGfBsRSc164+VE+B0FKcUJ/8KTDJi07MmgXNOVjYUWTL8wrTIZD7t8YuLUXVIGCLr8mCtbvdT7qa6cegAjhkjRlfPR2Wkrev21jsfqbLz9hsDxNgvvtwMKcB8KI4BkQKMYsdmvfaYQBBH8GQSTmeldvwpzRLNFdvr6uGpSRsOv4MIUHSZZVoEbWhaTzzGOuYoOYDXqy5Sn4CeqsBSgPRsdnNVZ/LLTxmzi+BjsiHTXuaDPpk3/2OlYn+o7C51ct4oqfOW0CBnlMm/4QvymYZaUvNQS6ib4PPPfwI3ojVIPR5ysKa4Ct743sjgwHpc5s/t+UsZpwUeGDv/wmR+cYyZxkidg6jE1Wpx9koVz2964QN2AOdsODvUP3Eo2vm0+O1+754pkekcGQuQD9geYzrSVOKWTChbIwaP//bSTq4bBjAVk3IjpEEQ3/TEg8CiLmWCpZlYicGGiJrk8+pM6xTGP3f9hxXZoksoDgNiyJ/AINadlaq0rCrwQUOke/Wt4pxrdGZz8gwzngPCipHXWQn
 hN3jCgrs
 TFY9VJ9AmMAyyz72P5nDpKEqh/hyeRJ6XxIQbyka3yr3gvNlk6tZFiF12FWLld5AYulpmygU4nkoSm9jtF3T2X4QC2xkxXMvDQvzQrk60g5qH8CeIW/UF9Duvi0bhw+4VaGqZCjCJ1nV1PhulIPLmlC90B+/KfeomK6VqWCDJTjiesieiwGecQMl75d+6EK18mQsukwJggMGrJ/WXisZ7a0U5kXJgttPt/zB6VHcv9Y90HX02LPxWAvA/C/Tn9jo5GUf0eA3OGH/+F+QrOEi4XLfWEP1ymgnLtMGpcZQjFI5Uf+oDinzuah6LTC9d89fU6PhR7C6tDxL38ivADExRd2/mc94+3cSt5t4cU6zE4ked2ndDiJOzoeBCLoY8Z8z18cBoWFTS+c8ysqcnce9b6APi/K+VTtbWKdYWzETM0b3XlkTEL6nwzVjh62SH5uG5J/E5Nb0dMcUJnVWRM8UJmJuRgUG5SlP96fHM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Manuel,

> Docs/admin-guide/mm/damon/lru_sort: fix grammar and stlye

 "stlye" -> "style"?

> Fix tenses. Split long sentences thereby imporove readability.

"imporove" -> "improve"

> +suitable to be used as a trustworthy access pattern source. These situations
> +including reclamation target page selection under sudden memory pressure.

Shouldn't this be "These situations include"? As written it is a
sentence fragment.

Thanks,
Daniel

