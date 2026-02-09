Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 477E1E81BD9
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 15:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B6A46B0096; Mon,  9 Feb 2026 10:21:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 974036B0099; Mon,  9 Feb 2026 10:21:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88D1E6B009B; Mon,  9 Feb 2026 10:21:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7AAA66B0096
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:21:17 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 120081601AE
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:21:17 +0000 (UTC)
X-FDA: 84425281794.26.64306C4
Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1C4B9A0002
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:21:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MVON1+yW;
	spf=pass (imf25.hostedemail.com: domain of chmh0624@gmail.com designates 209.85.221.178 as permitted sender) smtp.mailfrom=chmh0624@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770650475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CzEgkhzt5xOodhN+SSSPDZf/L8KCSTMOudC0ptwCdYk=;
	b=5oEwECpGLIk/rA88B2yOU7ag56+MTqxKyjuVFl+DSVtX5Q9PzpF55wTjkc6xRTONOCfKZc
	nLn13pM5B/M/wClCHn66MASLs3EnFLtKGh2FDy+4Y9YTn78Hu7Tu2L2pGO7vZF6cWQm4fi
	fqE58P93cvwuGbNUC5yg7aWPc5c2z/4=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MVON1+yW;
	spf=pass (imf25.hostedemail.com: domain of chmh0624@gmail.com designates 209.85.221.178 as permitted sender) smtp.mailfrom=chmh0624@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770650475; a=rsa-sha256;
	cv=pass;
	b=uBSILIQDxnqdvUFtwrABI4iFIwJkWOPzdPsC+MbQahwoiKNbsPcIElMgCat6LMn8oHl3ao
	ToX4Wwc9ICQ1zklyGUpdnlONmj9vTdjw3ToI80bVFLt80F48rDhXKddpbYYr/huCCoWlkS
	F2efiHFCL+1MEqEbqmizfdWS+Y0UDag=
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-56367a388e5so995847e0c.2
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 07:21:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770650474; cv=none;
        d=google.com; s=arc-20240605;
        b=YpAdW0dhpvu3wOGJNWVBA8QhT10PucFuNpI4fQK3Jpx7u1D3SWGC54wBNM2VRJS11y
         XdWu5CLOkmSHhQ4oGtXlp0LFTzI4PEh0vN/Ld39SSDQdmNnCFLD1QDWA9te547Bb3Kjo
         Isg7ckJwZZlMuB1SSDixQvGkf8Qzd+dcnDKWVXRdGgnhaBiEw7+iR9SUAq9ZHl54+XaI
         z0lOnOax2vxZg17RD/rHUnJoWaeaWZHHLKBSWp8+lyzYnrYiEpNiBTS1Svt2ms4MgDG1
         yTJJo2qjrzTEyNe9iNH3kNV3TspQQ6b4tyRulJoYhvegUVnhAO9fEpb+f6ouc4PnZLPQ
         acfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=CzEgkhzt5xOodhN+SSSPDZf/L8KCSTMOudC0ptwCdYk=;
        fh=QH51dO+o3pC9TQibMc/XmulYUSpeaMTyvBMxiOkvX94=;
        b=BGWkAtdJ0tvPIM81G2nSzPUWtjAQG+Ghg2acpF157qyL1XjJHrPxE6CCNEzHzNYgQm
         +qh6vasZssxaJXYOCDDS5+5OsAokcaBLiyechtC2b7W7El1hdldOutBHaMXCAaP/1Blj
         +rRBpMs3/R4ndhjcQ74RQycIt9sTvbcz7eZIsxDKurtpzdHeeRlyvQBJblodFv14+hBi
         bifjsc09v+DzaUx9KZpnKWWqcreOuTkfx6oOtZEcw+KYLnSocDcgQAtXF5ksWU7UQ8bq
         5COiXy8OpsDLPumkHk1WXcAsA2ZabYVaD1+uSau8PeFyU0feNRa/4YLmr/j7xIR4oOBw
         FagA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770650474; x=1771255274; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CzEgkhzt5xOodhN+SSSPDZf/L8KCSTMOudC0ptwCdYk=;
        b=MVON1+yWK6sZb7kzaFaf2jpzViXEKxvOHQy8fcrzQpg1f3QXFc33+bjhas8ryHbWwc
         ckS1iMk+gb4o5h3r4KNUWD+NWKil+SVTY7AaFgeAFomuthDAhCxi5kUsDHjb0Vu6IOE1
         55+O0fLXaB3iSbAS5oBm8gaUOGlUh7x2wPxzITh/8s2aRcBboPk3bEHuDkhulLTjZdD5
         Xz1FRziIOQBKPLGBbfHOb+NoXxZqWYQi9hGfjlCmMUjzQUyk5CkbAo1CR24GZgrD5XF8
         58alpo5Prwww9MMN/8OYRfoR6sxSDDqfy7yujfgh0YKCgi4OodqjrPlFua3a81G7s5f4
         wpzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770650474; x=1771255274;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CzEgkhzt5xOodhN+SSSPDZf/L8KCSTMOudC0ptwCdYk=;
        b=J1dxi4KXfUm/lLw/pwz2WjDEqDaQDz//QofON89wYTZ8lIck7bWjrXwEmyKvys5iaJ
         ZHxA+jOG3oGrbRt1KYOQivNFDl2CI6P4r09xI5T6pchZ4GTVgWToReidXJzF6E3mX6Ly
         DPcrhkd/AOlvA6N7GpRvJScwqJ8jZLXgEtbreyoBi2v0UjkYl5F19A1PYQzzza7hs2jD
         JXrwJ0H7aIJ6a9mF3Uy/WyxNvjCrLua5aTQ8YJxs5Vvkw5wwKcjNlA+ZXVMdZHsllkv6
         byvPIQkmzscH82aI4cG/GVhZY2PJp4301hp9cgQSecEssuExyMk2paqVJ+diWa4q9v+P
         1M2w==
X-Forwarded-Encrypted: i=1; AJvYcCW6NbuLkhkb2AJ/5KEkcK07b28HcP2JkHDAOp+CEIsKuofunIPLbYMQjG7u8UBWCDvV6ULPAsSKQA==@kvack.org
X-Gm-Message-State: AOJu0YwTi6Wnw9Eg3iL4k139Q2D6L8BR8sprc3JELghQV42GHhGyKBoD
	VSvCLLmfWyPv82LFdSvJ7Mfr/K83YK40LtMEJuZFzzS9Rqld+BeeQPk3PkRywhnWD2AASl3ZKnd
	XLQFx9xkTxu0XeutyKF/APO21265hgicNFA==
X-Gm-Gg: AZuq6aJyQMtZRDqHOav8AFGSHyWnzA4jJC33tvwftn1iSbeAHAKMywKGM1UyZ8JhFS9
	pCY59ddm0bN8tK3/u0vTrL2kGii5ujvHjrEQretyClFDTtUou+9J/xN9NsHWmAsMTK4XxF296kn
	6gUZzpSxO4/aKZr+FokCa2YsEIiF/IT8ad09wgz0PxpLSGKHAO42LJyUORTBqMQV+K143uEO8lc
	+07cmYEB+d1qmZhjtFkN92UoAeaMgJnJEwk1Sf06OvuCJtwg3KvYhPvERkSzMSjdYZTg1w1
X-Received: by 2002:a05:6102:374f:b0:5f5:459f:9860 with SMTP id
 ada2fe7eead31-5fae8ba8026mr2979003137.28.1770650474093; Mon, 09 Feb 2026
 07:21:14 -0800 (PST)
MIME-Version: 1.0
References: <20260209081323.68339-1-chmh0624@gmail.com> <87wm0m9dn1.fsf@trenco.lwn.net>
 <CABzB-hZpQOR5uxjUKGf2DcfcNXSwpaBf3mmKdmCU0T5=uDVz1g@mail.gmail.com>
In-Reply-To: <CABzB-hZpQOR5uxjUKGf2DcfcNXSwpaBf3mmKdmCU0T5=uDVz1g@mail.gmail.com>
From: =?UTF-8?B?5by16ZaU5Yub?= <chmh0624@gmail.com>
Date: Mon, 9 Feb 2026 23:21:02 +0800
X-Gm-Features: AZwV_QjQtB8CakyLgAcnNdduNhbYX3xfuqNQ2zE0V2aPgIsvvIiBlBwIebLBdgo
Message-ID: <CABzB-hab1V2oKCmnpYjY-FDXbVoMbJnXjXnnU8YqP-CypkXdng@mail.gmail.com>
Subject: Re: [PATCH] Docs/mm: fix typos and grammar in page_tables.rst
To: Jonathan Corbet <corbet@lwn.net>
Cc: akpm@linux-foundation.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1C4B9A0002
X-Stat-Signature: 9rz5bx37jgmjuug7ca9ajmy65mynhnk1
X-Rspam-User: 
X-HE-Tag: 1770650474-223704
X-HE-Meta: U2FsdGVkX18IVL3PgBDn2t8XajV68En1zA2urA58O2fiERpRJuupUIZLErDdCi8F5tq2xGBKzS4Uuf+eomKZfE7R/KLUj9q5eJLhccZwvO9s5mash23V1mb97uRQlzLnF6Q7Qr3lzl4HL+xzVJctNdx7GcC2uBm5a7sLqgbi5knPMCijHCapVal7zWam+dFKA+wFDpuFtTjSl1q6Lj3ITsBo2cOLoNpr0hiWCCkL0O3M2nZJIJyd0V/C+CnUVxm1NAKdEQ3fBG+Le59TrxXd5ToupeZ4JmR90b5SLG60M5kWl/s674sOArKh1W7euJb3uW1/Nu4f1cDD74+NJg2OH+7sxRp7OodThOe2vS/VhhOTDI11aFp39hcDp8F1CBdqWk23ZtoOr4GO/Z0qHRK5U3pi2AFp8fBS9F68JffYCeF3qauj7VpqlWsMajkPh8zf5Q6nHbrcZpuUiaD46Kwr78OYteRcK1WZFZWoiga35UhOGGdgdu0WYbY1Ay/kOpsPjBH9P/c1sPbjAxuUOGNX2vOf4aTU28tnf+5o7mGbgHnqjx6+EZ8Zw/BixznQlftLfGsMlCBjEukjwP/eTzg2jUs5WE5Zl/fyp77D6S7HiUQnsbuJE6TCoDKEzUfmDUuB30CtQHxp/5XNtoj5FKacRrg23FjBgsaJhDN0DtnR5DhUVqrpCseOliB8Hxou/Oxc9a2FOhn5qjFoEm7bQRXotV0JJrymJadmJYnO+7bMNVa7JCjNlYz2KdY4j1UuNebf1bVEihEwpK3dGIt0mY3jWZ3ihCfVzmbEZWIetpLPKZrvzC3so0c0Zx310iCF4SKXoJ0gTM0VEGi58VzkhTGil/DwtnfPlgOmkIDdHCFi5gWuwfsADksJXRgLscjosrnv1ZcKOT17mWudCfLGeJjUvci+9FKjU1Ga7Xx77QB58dAUG4FhECLwiBLRASkfanV2zeoJ+e66p43sVS6qpqL
 9BqHeEZG
 AP0zXOKzzXQGiPBgKa1aoG/EbXAWyrYso64wSVWkC5uhaRDIRiWPdnif+tom63JfuT3Yc1ELZU9oeLg2ajwhbSLtUambdgHik+nA2D/3/OubEJDoxJaPd/RTJb7Eunx1Fqmk7VsDcLRw/7boP/vjJ9scZ4fquTO0B6tJf0yFCSW1LeJa3LofOXAt4mV0EMvhDvNCW9+dQhxwcrTGvv0HRWupENiu9vD6J/RJZhrOE74eGpwGUen3Kx7ox//HkR4yVLMF7yj/UsOLB1V2UtayhAyQHd07Kg15qf3Mejkokd/MmtYgHfJsUkcbXy2XLy21rGF7WKA3JgoZR7ET0yau5M9kE2wALU4Cc/QEgmJWDKazbqNF9rZQqbqsjbUZuM1dHbfFFllHuA0kyFMoKlEJi4CTnQJcr++9FoWOc41cBOcEX5Ius15837k8gbk4DLOs8ChT/qJKkMZ7Cn1nYGsOfCZXijg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.187813, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the feedback, Jon! You're right, there's only one Linus. I
have just sent out a v2 with "Torvalds's" corrected.

