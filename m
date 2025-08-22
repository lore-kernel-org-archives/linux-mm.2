Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0FC7CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 12:07:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 575296B00D9; Fri, 22 Aug 2025 08:07:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 525C26B00DC; Fri, 22 Aug 2025 08:07:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3519B6B00DD; Fri, 22 Aug 2025 08:07:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1E2FC6B00D9
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:07:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D0C2416014A
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 12:07:29 +0000 (UTC)
X-FDA: 83804268618.17.E594E43
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id D6C8D40003
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 12:07:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=COwiMmP1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755864448; a=rsa-sha256;
	cv=none;
	b=0FemOTn94GMib/S3ZBpaF7gECf9oWKgctOziews+IrXJZtfFV5b8OtyQlX1KUrbjKBOt8A
	oE5iwhYO28npS2SxsRbI8d3OLNNuDH91D29PsDX2YAaMPBVVcsvzgkKZo1kt5k+d9jIhf7
	XnvAGD/qP+WR5zMI8QNn588TXsCAwiQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=COwiMmP1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755864447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G8l8c6RdN9SEwzhMIPJOr5f2j416dT55akZSctyPtco=;
	b=r/ZS5CNpqyZm5exT/f0ARBXhQM50PyjuDY+LNcQFEPWLSj4Ep+oh3uj2+GdZDCVwt9ZFPs
	r4GxEM2WgBxC/m45ZdX0q79IViSqLDv2zR0jet/2LeSRe1sV2Wb8zUcGrKfiM+7+xvJUmM
	74zy70lkHgAubAGwT36MGQl3PhdC+G4=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-45a1b098f43so15211425e9.2
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755864446; x=1756469246; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G8l8c6RdN9SEwzhMIPJOr5f2j416dT55akZSctyPtco=;
        b=COwiMmP1cqoKJnI+rUbFIq/E3KKnqGphM/alBBPrdwUVbZN9Si6qRDGsA/f/kx+iqr
         q+CzUM4bHtabGq9il0MEffWgjOObCq0SgPKrntMuG5+gYOHKoUfZ8hWR2hi4L2Q0DNEW
         WgN690u6Upx5s75EX2mf5/9mcrNMhdAffyx2JMznKmcYP9XGVFu1v3XqxQq4YWf1s0+s
         UpTKzauQordIb9W2qx1/EH3ynbhSyOXFYJl7cdicrYF95ERHbo/YjAgqvdiIUdbGpX07
         G31N8ZbgLMVkqJ3+PQ/DSeldavrLqe61WlZCnuW/Y1PLXFSMGPaALsxuUr3WnapuDh/x
         xi+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755864446; x=1756469246;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G8l8c6RdN9SEwzhMIPJOr5f2j416dT55akZSctyPtco=;
        b=byUYOzmIREZ65y2LUtXj/H0xX3q6D8kbjmBuJSjNKKq6UrBpQzjCkHPVI/Hpm9SbFz
         yFbVObYngF6P7PcgsWVPM8V7Xg9lVnU9LWkz1P925m6PXWVpAMypMjauo4c+sAy621Ru
         a4Jz7ViZuud7Roh2Mw+Yf84RNMu5voea8uCWbRaWdZPK7OUydMdRZjPbR206zXxju95I
         5nnUCWl6G7n2pr6pnbpcLjp694nYehETWXbuo7y6qK1E5hYDh+KQOYxpq8MNld3cl7/6
         zZwr0+d01YLUL4Eb/8UIEfw0vNZFTXoazihKDV46F6Jn7S7g4heoKklDTvDCIlmmDyio
         BF2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWQO4SD0ylGN4Hq+tmAAiX3laI+yzqoMO/n2j4FWARlTo7trhJ1s01UcXPQVdoEGe4XlMS6kJamag==@kvack.org
X-Gm-Message-State: AOJu0YxT59Caz+Riie4/TyKpXWtBNsCS0uktiaY09ckgUAcshN4P16+N
	6XKvLzsiEatywBox/26hWdx/gZCPUSJ6YhScC+om1ts695o9N5LdpP3H
X-Gm-Gg: ASbGncsj1Nh+pPDravHfKKXCRdIRJQn59FgEk6r7KVC5GGq1M9bioCcq8YoF0/Pcjal
	Q/MQm0aTMPIgMenaA/VTWyE3twc6Qu+SagqEuoSSwdA1SZxHDiEPSVUPmUtMmYRF/e7BJZU8AZt
	9We2HGytgp2w4KF2WdzYoDwKYW2F7YwQ2/KKPEgmNZ4HUm7Ff+zw/k5G/SEl87kxwSwJL/Zm8c8
	RiyQc3926IvVQuq+XMGegLXcW22Fk/YsyG8qImEs2jrv5vY7/sGTwI4YmKf09pNd9GWVTSHtlCM
	Kp1I4BVPKs6oKzoqH8i1e9htyCF0obLK/ikpE0ab2HWsK//RUbDJLnYPwGtJlqyM2vp1RyiOqNj
	bPrQetuz72+66a0Of7XOcFX2HtE/pqbAhMls5AJnPr9xWHzIjXzifdjTb6Q1bkzZC
X-Google-Smtp-Source: AGHT+IF32esv8LZscvwNHgYR6ljsLtgAqraMmy0VAs35rpd70926148m7dEBX/SFBT9exOpIVVtZSg==
X-Received: by 2002:a5d:5d0f:0:b0:3b8:d0bb:7541 with SMTP id ffacd0b85a97d-3c5dc5426ccmr2223990f8f.40.1755864446093;
        Fri, 22 Aug 2025 05:07:26 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c5393b797csm5054822f8f.39.2025.08.22.05.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Aug 2025 05:07:25 -0700 (PDT)
Date: Fri, 22 Aug 2025 13:04:20 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin
 <npiggin@gmail.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, Alexander
 Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan
 Kara <jack@suse.cz>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
 <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Darren Hart
 <dvhart@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>, "Andre
 Almeida" <andrealmeid@igalia.com>, Andrew Morton
 <akpm@linux-foundation.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, Daniel Borkmann
 <daniel@iogearbox.net>, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-block@vger.kernel.org
Subject: Re: [PATCH v2 09/10] powerpc/32: Automatically adapt TASK_SIZE
 based on constraints
Message-ID: <20250822130420.6c6a3fce@pumpkin>
In-Reply-To: <db7f9b12d731d88ac612a27e2caf4d99d76472d2.1755854833.git.christophe.leroy@csgroup.eu>
References: <cover.1755854833.git.christophe.leroy@csgroup.eu>
	<db7f9b12d731d88ac612a27e2caf4d99d76472d2.1755854833.git.christophe.leroy@csgroup.eu>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: D6C8D40003
X-Stat-Signature: did1yrxq96is8rwtewy3q7iboza99ebe
X-HE-Tag: 1755864447-393251
X-HE-Meta: U2FsdGVkX19pFnGK6pYdiKoNgA6Uxm4/yxDYWPLcqeiwgtQRmDk5xbsBVQoJSmDR30jlSF6PIa8Yyz7Z9iOUHNICQPqLlReDebE6/6BC9F380viuDx0WtW2mwqiX14FGVR3Mhh1Rv27TJszKv1P4/53kkF7yxGn7ug9rSY8B9X3Cwp2cr5H16SPlbYIOuy8/v6BTYrsdh9pK60WUcr8TxBq4ucOaR3QgJu+dOO3ReQcrx3xc63WfkuOTtexkOSxsrTi/A2nG5TaG6Iewpu2zkg1YUydTf72FwsRXITgd+fS+osHnQKuvSUAx8k+10jAxDCUkjiwXXz4hY+nMXm+Kdu9k2FpbPvvIn7f8sm8J0fy5lqfi63fW0fQOHvgZw5HSfQtuyOCIZ1EvFxc8zEYoB0KaRi2Au3/Dt7OpM1KwsFWFYken13i2aNvcpVtmopx1Ow6PlBeLHEmRQFwOwemLl0QYx3lq9DWwntGv/ELm/XgpUnTOAxbvqO1WVUYdG13guqgMWxJSfaeY3vBZUVW9x0WVIKvZGu9uBJM+Uum+HFS4q6XtcwPZR59pQPyGif9m88d0AGDtewbZgKCidQiJCl4ymQolCzgKzxdp91Fd93YbZIfClX0C63DX+zTLPK6X8SqzFMMnh6S692+cUqnS5wQ1XQrrFSlJbZphHHxUpCR0FeU1z8kYfwrkF6YVA6L1DI2N3ZiecMe2USaeEMYhZRmyOmON52OEyvD1ZYDHYOKvwwHXs3APXjrysg+iDvbcsWHYTnAWCmIcY9hjEwdU1bLtkJwWWLBzXOeZXqOvjXHppztweqVVJH8N8jNqbJOMbqp/pWKS/TSOGeaepQSl4tTJMA6awSTqzuijNlwFqqLED61jZ/vGDgAz2HKFLZPTY9srn/jhz/lLmRI60K6+vhL3g24/TkJxMCJndznv6sU3oNsQFcWS28GW+MLmTj1W24NkKp8IU1CGsWz1+kV
 mI2VIPmF
 xNFC2E1ss0zdwwd42l4DGNLqi4ulGagUFGqp7UbrC50CHnJElxQUT1TAr0Xbldbi7DpzbYOKzBzlEkaA9tJDJgwc8eYjgwYbvSsjBYZeusejjaVrCzesRw34JS8RdH/jOU55M1df4UvLOzJwmdQaisPbW7hkVeBZSK5GO9HeW9QAcyCihsPeLPqg74JweBJzmf6yrbXsnrHTVaVuenPgv3uw2LKE0v+3Mz1HkBfooqoaeagXtW74p5FTRoDoFFfQK6VpEZCKKXEzf0IYOp+VhcYIrBhLR6lbJ80nfC8giiP4A0LlwQ9zBs2CwWd6y9YlG50KJ27AQ9KVLEEcFM8EfrC2Zhs54wyT0ZiGca5CiqZsm+yWf7MkDKz8zHxE3SHFpl3qWycVrHLWQOv1sb7YErjTEBHhBhiMi/0UCTwoywgvkz9zThiRV3s1/F/tuDGO/Kozvq7fa3mat8Jvlltja2oNJNSFxHiViv723ehxVPyqtgrjIn7c8PTMkcvaTmr53b3WHsmEk4H11zmpW/38Y/FypZosSVAg/0QQk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 Aug 2025 11:58:05 +0200
Christophe Leroy <christophe.leroy@csgroup.eu> wrote:

> At the time being, TASK_SIZE can be customized by the user via Kconfig
> but it is not possible to check all constraints in Kconfig. Impossible
> setups are detected at compile time with BUILD_BUG() but that leads
> to build failure when setting crazy values. It is not a problem on its
> own because the user will usually either use the default value or set
> a well thought value. However build robots generate crazy random
> configs that lead to build failures, and build robots see it as a
> regression every time a patch adds such a constraint.
> 
> So instead of failing the build when the custom TASK_SIZE is too
> big, just adjust it to the maximum possible value matching the setup.
> 
> Several architectures already calculate TASK_SIZE based on other
> parameters and options.
> 
> In order to do so, move MODULES_VADDR calculation into task_size_32.h
> and ensure that:
> - On book3s/32, userspace and module area have their own segments (256M)
> - On 8xx, userspace has its own full PGDIR entries (4M)
> 
> Then TASK_SIZE is garantied to be correct so remove related
                    ^ guaranteed

> BUILD_BUG()s.

