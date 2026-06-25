Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41385CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 09:03:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 202D76B0095; Thu, 25 Jun 2026 05:03:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18CA86B0099; Thu, 25 Jun 2026 05:03:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 054116B009D; Thu, 25 Jun 2026 05:03:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C38EF6B0095
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:03:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2F14E167652
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:03:12 +0000 (UTC)
X-FDA: 84917845824.20.631AEC0
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4C5A5100002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:03:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cOMqfNRz;
	spf=pass (imf14.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782378190;
	b=pdBDtql9I/eJx8JSSmYpxPYqjzXHIp3l6orJ068+xsVxssnGBAemUi/CMqhGOInVe46tZA
	RIp+GpECTbag6vN/UlmqhiLTKUKq4uI7hobWL/0Ifbcmw+HcFVOG3y/3oEie4RRjABddZz
	99mJQcuBlR7z8fxi6CpzkCIDC3QhQ7w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782378190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HBSEPUdUYWVlvar6bWIrKaomQq421L3gUjBqqjys/Kg=;
	b=UZhdYHqDYTqyzziLQ4rBI2NX+oI3GCbvFEf2lmJhLgnYyQk06iZspesojdrHQMENwV1FQN
	epIaH7riaTrZ0uG0c3JNEsFmpobXVbDB7xaiLod2UW+sq/5g50MymPj9AdUigHdXaYpJN0
	mVLZLu/Dne2g9zgNqnlMwLmc0l+fIFc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cOMqfNRz;
	spf=pass (imf14.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-49249072f03so11159305e9.0
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782378189; x=1782982989; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HBSEPUdUYWVlvar6bWIrKaomQq421L3gUjBqqjys/Kg=;
        b=cOMqfNRz5PM26Yz6LGoDgS8xe1ZXLcZnLfxPqn+DppmP4maaq7z0MAl2gFBKycWFe/
         g0X54VXf3thIJG1W61POU30Nla+Fs5dwsNjLzaJjB4w4i2MdYipqKjZfapQ7P4BFcVkm
         5hM8Hkx+XZRrDKD9AnxnpgYfZv7ApLlgsqIl5Sqf04PnXscgjOp2QalEJVuIg6Z3SBGu
         sBhF55Tan7zqZKVuEUvvlDTjDX/gpNMlpiP4OoZCMliL7bHWZs96x3U7elOmqq7kQPtR
         KoZ8Jn86vxdlh+W7T/Lk24EGbQeUYSaCLDGRWIFf9JBaK6W9W92kRjMlI7M0bwb8vXHm
         1UEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782378189; x=1782982989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HBSEPUdUYWVlvar6bWIrKaomQq421L3gUjBqqjys/Kg=;
        b=kl1tZX2aTGx6Bj9SvN+1BU6GiC/PM1dPx0B8oAr6P48sE5L5ryKC8BqBcc0aFXytpc
         /bkdj+ADHOuJo1HFUMVkOSmmdRJuIOpfuJpTyrpW0vtrb+KlNpfUyE/+F6jSvdumDkmJ
         pbG7C7YzvRr3Hib2/53ZdAmIXLH+JQp3u76JKDigyTCLKjIRmqD1SqSjQ0muDquXj7dQ
         PXqzdIY0vT1DHNte6x2/vCXfPM1O7MRM6xl4R+Kq3iFD2ImodBFlTEBt8nrNyrK6eV+/
         cIg3xXWRi8qdUu0Mczxa3qWQg/rin3Lc0cuBs9OCZEkU8SeqJMwqwqyRxVJax1H/IXnL
         nA9g==
X-Forwarded-Encrypted: i=1; AFNElJ/vYMQNkn+mxRx5aNkqVq0po0SF8soMWAD1D/li0CFksR196H3+hUAmHk34jGl2nrCTGRB0/rv8lA==@kvack.org
X-Gm-Message-State: AOJu0YxGr/g+3LMieEDEEuxjX0NOVVTVMhlIFbHE22b813BTaP4eGH2P
	QvL+8N2pbqvz2vWzHxPz2vkRuuWBVmxVgIbzuCIfq9uS8sc4MxOLcEB0
X-Gm-Gg: AfdE7ckINt8B7s/gRNWLW/kXVtmUuXZLwwt6M1a+pKL9AbY/PRQ/7j7uJs9WXpjtEU0
	+N+WGaDQBVsbnKmYb8dtLf8LhPtZABLRLHUc00W3NYzlTIyXP+SPp12eyQV88GeNJ9kBqHwgnOc
	J5J7kXBp9jbz2n/q75CmTTZH4sMsHg3XyYghpQW71TWHWZkjkusAdDMiWewdE+F4CV/GOvPgq3X
	Y4eNFTlz8jHo0cIKD62Cw+QZNZyooDWfp+GQAPb5zkHKqVjkS7XJDaK6EOZYl93fGmtueuCbmbe
	Xi6t8OEG/ngT9MrAIASWK8Tb9WfO4+dta1/xWD7XrEq7yFcSKCedziTJeuphddrO9R1W49jkgTW
	NUdzle5UMNh4l5QIBUhhWjBMQaePrZkgqx767OwDeqj7hyXOsD+IeDFq2qmoyqelu06sRCPjFk2
	k9NIw4uRrzGR3H2CD0Wq0=
X-Received: by 2002:a05:600c:c059:20b0:490:bb3e:30c2 with SMTP id 5b1f17b1804b1-49266885955mr16491185e9.18.1782378187463;
        Thu, 25 Jun 2026 02:03:07 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-49265975147sm55948915e9.5.2026.06.25.02.03.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 02:03:06 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: val@packett.cool
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	brauner@kernel.org,
	david@kernel.org,
	dhowells@redhat.com,
	fuse-devel@lists.linux.dev,
	hch@infradead.org,
	jack@suse.cz,
	joannelkoong@gmail.com,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Thu, 25 Jun 2026 12:03:01 +0300
Message-ID: <20260625090303.3796964-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <83f05c55-efba-4bf5-abfe-d2ab0819e904@packett.cool>
References: <83f05c55-efba-4bf5-abfe-d2ab0819e904@packett.cool>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 3e6k43776est38gndecgar97dxa6i61n
X-Rspamd-Queue-Id: 4C5A5100002
X-Rspamd-Server: rspam06
X-HE-Tag: 1782378190-704432
X-HE-Meta: U2FsdGVkX1+OwUkABWiX9An6/a93Z7z7gkLE+Ksjeo0JO4YKQ9YlVV8v1sBap1q+/Cvhr9H0j7DxLhExNbZtavHRdWH1j3CRiaJxObmiQO4k+LBblhC+ryqofaZ1c1q4TMW1qFQYIj3frNkX1iMg/BgbVGUfw/cukiGne9SVMNZdz1+064Wax5FQsGb9eMNIWklCfGjmQO1vzbOaC5jeB80DWh+uvmeTACPTaEUdwYGUG6vKWYlkBPpFVhMjhtNlL+PFSJrBbfBYVFX8WCd5kTK/YfPXUdObSmR4A+/VdwrZieQRTnk+NTDBcjNZYuFNSXpaMUi77cawiVpNz/tHukLN/avaSgN8i7jnI6Kcl78CYKOnKCSsXxsxXSlpCQOG9wi008yWCJTXPe7pHGDNU9FIyAt8qfArBYvs9x199wjG5QLqojvOhVCl+8YZ3USbcWAzh58j82Cce0WRTKXNXQ9C7zmo++whM3wLl/RCegPchYKXbDsvkLxSrtx6OYfqp7Qo29go0YRltO2k3iXDBrpxkleQ/pemFqh5dDy2IuNJXe3hGoHm9IDS5hJsFQUTB+e9yMCiHNuPsgHwRjFmNa3jWlmGjwSTQTYecvcWO6XiGHa5coIikdmrWX4tA6tIF2CXIChlPMiRF+plQQHFPG7wiAUrZSpeI7IZif5ARrzX6vZ0qfTFN/rjTsCnT5VTlRqG1ymRyINMbpBojKouIRHKNPekbNyJcaWeSuY+ZeCrSlFiuT3EUB7/UNnQ6ju6FkVeMNalhQmZDe10wO3dkRiVSKshhi8aOElNtn/Ub6leJiVr0H6Gu3MYkGih+wnC5WtP3s7gDXlsgndcmGflMyJXhVedc38YOGXx20GYEocN4FDmJVHZb0igIyGLYzQ2QewsE9k7jVDavv/UxsoGoT9Qz6v+/pP36KhIpZ+M5IiZ326oOmAPc9gwE0qPjHAyQr9oYvllezLVj9LzkUV
 Y0pJz5Hl
 7s4lQvww1MkEjLiGWFwuA0Pf2d4XmHZtbaSQnG1mL927reVwKEjGD0P70HAClVoo45s/kRhCzDcoYyJme9Q3nnnC9nLzJENZUabJEaNVkMBj+x1lND5QfBdafG8f8uj7f9V3tKRwJ6ERO+0RxtYnJoDTV6dzan4oQDzIty9BubOPi/MxNs5MuLzxnoCJC5J3uKge9RIfGUVQmQprecjKxtb5PRnpDElzIXmhrL4o+M60Mh5OLhMy/rjCi43wfjqk7yvtYulUp0rVHuQI0qXmXxN8RvuvsK8LtG5f6WLHr9fHTWFwdSj0J23wdmhzgL4zm670g0NOMTYsMxXJWEJ+Z1DM35OkDN4rA1yQd1lycIPWKqUltGjSPeeEFRfVXmhGDnfcN0gmRNtXSrIu87Kxbgg3LUbD2Ptc5cbSl9v5qkChO+0hP8Y0kRbKVIiFHJKcUnDfWst6duRq8TGlzly6SYF8rcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Val Packett <val@packett.cool>:
> speaking of fuse_dev_splice……_write actually, this series has broken 
> xdg-document-portal!
> 
> https://github.com/flatpak/xdg-desktop-portal/issues/2026
> 
> Specifically what happens is that the EINVAL is returned due to oh.len 
> != nbytes:
> 
> fuse_dev_do_write: oh.len 16400 != nbytes 15526
> 
> (where 16400 == 16384 (read len) + 16, 15526 == 15510 (file len) + 16)
> 
> After reverting the series, there is no error because oh.len 
> becomes 15526 too.

Please, test v2 version of my fixes:
https://lore.kernel.org/lkml/20260625083409.3769242-1-safinaskar@gmail.com/ .

This should fix this bug.

-- 
Askar Safin

