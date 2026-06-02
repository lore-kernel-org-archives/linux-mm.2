Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E274CD6E5D
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 21:12:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47CCD6B0088; Tue,  2 Jun 2026 17:12:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42D866B008A; Tue,  2 Jun 2026 17:12:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31D576B008C; Tue,  2 Jun 2026 17:12:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 242366B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:12:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9FE2B8AB58
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 21:12:54 +0000 (UTC)
X-FDA: 84836222268.17.3025956
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf02.hostedemail.com (Postfix) with ESMTP id C02128000A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 21:12:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S1wEzQCe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780434772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z9XdL0UcpSaON9fzpANOcoqtpqZ13Zvjis5WLumIDqM=;
	b=PWdkj3Lz9aNwLmPtnoqKL9JrUoW4kPOcDQW7JP4pFvZQLUwKXy1si36ZW+m3MexhGggSwM
	Nmvum6XuIN7hryGD2RUf8NAvVHkMxQuREt9pLUR5Egh8sDIX6Wxm/dISc84mAwDYodA/FD
	F/Tr5Iv4cxnKLK5Mfju8pe49ymLachg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S1wEzQCe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780434772;
	b=kYOg3tNfBtXtYOuQ0bCWCvUyE46HPfB1+xa1R9jONF9Iwg9zeScwSOKfiA2X7exRxnSqwl
	8aD6Bh5oZhIQGbipa0MvnlwKt7wh1Qo3zjENhR7BCr3/5yYZ0ggx+1I4Xw8s+CYnsKBh61
	XMZUWjLExpPF7N1YG7aOu9KhMEaZ7ws=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-490abf12f0fso65935e9.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 14:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780434771; x=1781039571; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z9XdL0UcpSaON9fzpANOcoqtpqZ13Zvjis5WLumIDqM=;
        b=S1wEzQCemNwB24hGf7aC3e2Op+weKuM8+GZQXkOri9bJOeIK3qwa68ILIHDqXHP0fJ
         WjWS5x4q0dOgCGhdQ11vSHJ4M9RibUEqYBLRIRRmq1Jxo0VDWFyzpcfWQXWQNzJwfyrM
         hgDMDm4wknp0NyO2HxDs0QVuXFuox33lhyNcEc73JE+JNdL1CXyyL08Ry06M+kcMbu5o
         47f/4nXLcQAyK6fNQnW3L9lxF6ZgQhlq/+F2mVHXj7m4E2ijVzDnsM7dM11yS9m8rbRO
         ZvGsoiPP5Lnpz+DE45zXCvODEckXJTTN0Q6Q4lTe3PhHqnFvN32nuWMgTzvyvEUCGpB0
         HuAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780434771; x=1781039571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z9XdL0UcpSaON9fzpANOcoqtpqZ13Zvjis5WLumIDqM=;
        b=bEHhR1X9xtIC8XdE2pjIFnCBnPa0NBmFO4sk5yf8YtascpjcwWArENGuuYxy9D+y9w
         SUZ0eaFyDhlCeLOueIgf33INuAX2c3o8kkvnR5HOB2Qy0ZcIv4Tu5ZZBqywSPq771WZT
         YziGXlDF/WJT/+fd27vA71WGEgdsqXtO6TJ41EZReHQ6cT+1mnP1h/QbRCKgMmLm+HEi
         eAHuG1gNKgBdgHFg1VmGOnJZM/bEevNi36x3iTQMFwct6nOf+nvOZaMTOQUb4dwvsiwY
         hzzxA6jy7f3v03cko3wq5Hik96FAOfKLvW58Segzaq8zmHCi+ya640V4Sm3Tyg+ciBYM
         Yc0w==
X-Forwarded-Encrypted: i=1; AFNElJ+7m/1z+DhYgyQhiqKLS2kTfTyXb1+ioLFTwNSNRNWgOSD3PKsFwBA9Rm8N7ZI2U9o4knIdm0szkA==@kvack.org
X-Gm-Message-State: AOJu0Yx+LeRTYG1ELlCaaqPxbu7PNBlY7uUOkaaYnuSh36UOBrQHbMTe
	TaVE2LbE5UXRXw1vZ1Oo2yw7suzB8klJrbt6waC7lwg5cWNaqdstBkfa
X-Gm-Gg: Acq92OEUAnXzC3LNUA0+2SjtbfkwUMkuuY7RcXR+fNH5Mv7KMpeNNltZ95p7Hd5HY44
	q2cMzEAJuslf57Ntd9jjDQbOfkYhMyT2PnkxxVaTvATBu0JhDUGY0W3WcqrO2w9ViI3rorJUC6K
	CwD96jQZ5ECwEawnzkWQO833zOakUzC26Hl3SGr79di/Xk/vhbGfDVCTmaciLQoVylkl1GzbHhv
	TGqid7/VWJvR33bmjfrnYZaSOa7wReRrKXZtkuMaK5hjJw/yznSllQP0Oqz9H+2LrsGtL+4oRvI
	mgZnBcjsK/XX0Frc90XIHztadCy7YKKSzUm9hIQoHjDdip6iyt7deshPN2DRwrr47w2FFiE8W/I
	EsJJScJJqnem3AxAH0MBXiIUzqGJElJKWJ6oZVLXpugPwgiH7W9r2xfwY0NsdOHxuuHKmJCMVL9
	F1WU7sb6Eoq/89ze9a7884Ai6TTNp7cQ==
X-Received: by 2002:a05:600c:3b98:b0:490:b11e:e4be with SMTP id 5b1f17b1804b1-490b611105bmr5959595e9.3.1780434771026;
        Tue, 02 Jun 2026 14:12:51 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-490b0e13f91sm111429715e9.3.2026.06.02.14.12.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2026 14:12:50 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: pfalcato@suse.de
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	brauner@kernel.org,
	david@kernel.org,
	dhowells@redhat.com,
	hch@infradead.org,
	jack@suse.cz,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Wed,  3 Jun 2026 00:12:42 +0300
Message-ID: <20260602211242.13870-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <ahv16ogY8Zx3Rtox@pedro-suse.lan>
References: <ahv16ogY8Zx3Rtox@pedro-suse.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C02128000A
X-Stat-Signature: t87tb5iqxbs1u4hdtbtpm84baizffhhd
X-HE-Tag: 1780434772-679991
X-HE-Meta: U2FsdGVkX1+jT0akI9j7KaWVC27HCjxQlCsCD203Qq14cRXskz64cQP9uKX/ziyBQ2Mqz8chxC8LNuWBN90R/JaTQfyP6k5yebOytS8kgLupYy9FgGJ+HSSHYXbpeoEgSwJM+QTctp8DUbE9u95clOe9s/+yrefPqbCS7Y5aQiRksAUGxiu6XJMyR0QpErgakXVomlopBuFzLR9STKGTTf32fYGs0smj47q3Co50dLadHfDDTAi3IoOgH4/q4vNrt6Abrp+kpS/NIE+9WYr7cJYkbVs1RdwHc9lFKpm/Z9p74H1jQ52VVSOTxEvp8wKBmOHz6jXxt+ykYieqGrqlVUSbJzPRbMIeniwTEn4lBolw66cNZC7LPeifCGkgNASf/kIV94bNe3K5IX0JdwdAUQsk+rZ0LT8VinZTeS7/GN+5HLo+7fn+Dpudy3YfxntgW5l8mpuSTCYm2iRYCmk4zGS9WXOwMjqNcc86WfWSbOQai6bYfA7LkQ7ILZFQFSphc6u7QhjzUOBzZx1mIVfhCZNvlcKGq4GHz1rGbxG6OVNijVPHzw4VTmuX7zoO7Tr+3Rm6z1XtbfgZA+zXjvrLqUdQmt29cUMIvihH+T6K+SN4uCFOMEqZJeyzTz+Q5OU9Rd9VQm7EKua1URJI+7u0lvSSZZ9LtvkgaEjGjsL7Ge31Luve+NPECj2o958E4NV651/3Ioy88kjvx+n8DHHV4rczucmCVDUtCYd4cpwKE3oBBQlciIycmkGq4/sVDAXMuUrxD5DSbCH4Z2dRKG1Jh0ebgt88vnb3Yf/LDAVGwO6XSJIm0MKuXzaFPnqbvrpd9rdnDFRMXc99aRNaOJIT6nLOKztm2+kiSzWAdyXjEgTQ6m6JnlKik+wQlXJfteJVrjeaJmM9JgO4ICiPI+y6RlAX7F/v9P1ywFfHwIkJcWGM1QXjSc24vjvCkAkgckr2D5nEIh8RT92/pZe7Td+
 Whp+k2xJ
 e+1/uIo3Y9kNFunViVQOGXXCT3ClX2nd49vxlt80GZofaqGJCEg6Nl4RXVJRpl37X5BW19PJTaC2AInfY4wogFNh57DVnGd2L7ow51hJO5H82tF9NMBVb+wZW7Rx6vOC7J1Vwc3jDlt6rDa0ScJBlMQd72DUitbuuIbRCrAwBda051TBgMcYKczPRRgEolvJ7L5TXeMRbcM70siUz4+PCPvTmPtzKxGQbIWuW5tzgdKYUcG/WvvoAM5x2/Ar6FjYd/wgqQh6RRnFdKzEtDJ7p+FsuM6rGN+2FgAsgi8A3NbyqDldL2RzXrDWjRRlvTOyoE2viFSbsSZZoMRhSvmBh0Hy9J7ulQKmLuwsmTigaJ4p/eRx8bQpO0SRWkqLiWn/fYWSBHprS3o9/y4wMExnNnVhP2VsxY0eVjN6M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pedro Falcato <pfalcato@suse.de>:
> On Sun, May 31, 2026 at 01:01:04AM +0000, Askar Safin wrote:
> > See recent discussion here:
> > https://lore.kernel.org/all/20260516182126.530498-1-pfalcato@suse.de/T/#u
> 
> So, you took an ongoing discussion with an ongoing RFC patchset, and you
> decided to reimplement part of the idea on your own, as a concurrent patchset.
> 
> Riiiiiight.... I don't think I have to NAK this, do I?

Okay, possibly this was indeed inappropriate.

So this time I'm asking explicitly: is it okay to post new patchset?

I want to post patchset, which will remove pagecache-to-pipe splice.

-- 
Askar Safin

