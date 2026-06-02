Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEF09CD5BD1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 23:07:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 359406B008C; Tue,  2 Jun 2026 19:07:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 330896B0092; Tue,  2 Jun 2026 19:07:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 246876B0093; Tue,  2 Jun 2026 19:07:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 10F0A6B008C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 19:07:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7703E1A0157
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 23:07:50 +0000 (UTC)
X-FDA: 84836511900.26.154775D
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9A34F1C000D
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 23:07:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="i7katf/9";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780441668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IvSaS68IPr55Kp5FHpvrg0n0LohiEL0S8pivrepEpA4=;
	b=MC0FP60fGW576F4kALexPK4VL85jOGsMXS5rW9a7KSuyqUOlGhM/t93Z2r/h/mx8Eg5U2n
	1F81ti2upyrOZMTnM3podHhOrtS/gvJdmFXDS8HsbT4/Fe2p3JDpgk0lM84Dyjm5YVUif5
	NrmxwnOyrdbzx9q3b5j3UvrkyqUt7no=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="i7katf/9";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780441668;
	b=P3pOGrWcnqBN9BHXmR4v4HPYyOz7SEIDx/bjVxPm1kpaY9oEwqGYr9oBUt/tmlMaQGK/9R
	E/5f5Fltlx3eOfO36nJwgxYWd66RkBvyYjBQFl2wTwZhljTuTQdAINmyBOuP2tmIsTYU1S
	FH08qbEzEadcg02/YweACitnRQi+UnU=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490b4e1ade7so5306215e9.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 16:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780441667; x=1781046467; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IvSaS68IPr55Kp5FHpvrg0n0LohiEL0S8pivrepEpA4=;
        b=i7katf/9ypqPQsDvRRskVAyWbk7fHzj7qXzU6lv0k4i5FNZAJf3xYbXbNpGqOOkrgH
         WD6mD1HTVMwz1YGYsF2k3HIc1jFNwd3GRHiAf1hhGgvRw6EIEOsDFfxYfi5yK8+0u2vm
         zuhaKZ0jfOe09C686Rs2XU0SqPP+fwk9aM4L9wpuqlQRMn4sryBd9IAIR3zqFx1rsm01
         Vk5BFNADmVrXeoMh2n+7f9iuwdkGzECvu48tW3e00g4QZq0oIGFMxBIOUMWLSwsmBFM2
         P+UC/kgD+HgB65hWSXpAkJA6aEu/PM4zVr8fd2e5BINidTYCEendjbe+e0+MI2RimjtC
         5PXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780441667; x=1781046467;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IvSaS68IPr55Kp5FHpvrg0n0LohiEL0S8pivrepEpA4=;
        b=BiYElci6Kjbb6UxGvjrllLYVmjeOYbBr2tcOnXi0Nn4yj3pmyKwfJUeRuDgXeCZFm8
         JWPCFHYnQHSR4LfIv3JJrapkEOkoFxMaTAaN9xmtJmtGgk/kFaOSfuitsY8a4gwJY5Mr
         UA0g8QC/41DyX4QJgkaEUncDbQZgOHeGGBBYBmNbfswVSbJ1wfLH2R1l5cN62PbcKDMm
         nK0B3evoRMePLNasc/tkDarT0HmYi4fEbz5CSj4p/bMb2s8VkLd4ivMJ09jLDSueWYA9
         n92gnucDaeqIvDDuYWjV6lpnwZNVweyN1u1wEpprM39RF1iPTVlcnqZ4eUQ5UDmtBktH
         RTWg==
X-Forwarded-Encrypted: i=1; AFNElJ+Dmjm8IO0Hb6DL3Hs7Q2h+j0kS6wIbZBI7AT9jOwRvjBc/yXBeiJqapr2Do9tQ6Suh5MEhodMLYw==@kvack.org
X-Gm-Message-State: AOJu0YzzHkc0Pc4MNm5EFqThxcw8Zx+bKOKXWpXEkBxAvOl1XVWp5hCx
	yp0BaLOTjetHgYF8clRROIZE6gyf3Y15KzE4PJ2WQi5CDAaGKs1lZkmi
X-Gm-Gg: Acq92OGIuQofknX9oyMDcUgWlUdml+MpgLSCNCG/jypbD5qqBfcHWso8da5O7Sp5MUp
	XuhACq3gRyV6zntJUgD4hHdSFQLw1dthcNxF1xad8M0mhtRnYPFQF0xd5FmpRAKKoU0JHqYpjOC
	cMYg3A/7vaRTCsytdXqaSNhPMWnucJHv2FL6B5M3ubjy40GSALWFhCXXLllTyCkJCu/h6Kxn8ud
	sW8PnOznXL2vYywsGxR/weAWnUW1Hdsol7CTuYWjli8jA4kvPkIyivJ7AsVqcsxwmsgcLuhws0L
	csjMkKkDWO4qC14bWbzaCd5dxoVxKM/LHILz8aTaf+tjQTFE6yZtSJJKj1uNogfWqqrZqAzGsHW
	AbUtz6t81HwOvn5GYWNTqEobhOGnx0y00vFEzGBghMLW1hX6ZZDJJUwKZ1NYUZl60CU2RsWNExQ
	mjAAqvTVxgZYo/mk7ZjgOdbPelHG1yB27HPbrwrDW9
X-Received: by 2002:a05:600c:698c:b0:490:44eb:c1e7 with SMTP id 5b1f17b1804b1-490b60fdd10mr11320095e9.30.1780441666946;
        Tue, 02 Jun 2026 16:07:46 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-490b7a71bb7sm357295e9.10.2026.06.02.16.07.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2026 16:07:46 -0700 (PDT)
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
Date: Wed,  3 Jun 2026 02:07:30 +0300
Message-ID: <20260602230730.138904-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <ah9Yle5pd6mD9Ugr@pedro-suse.lan>
References: <ah9Yle5pd6mD9Ugr@pedro-suse.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 7kqhgm5c4gd87xyfzxt71mkcmb7hbyay
X-Rspamd-Queue-Id: 9A34F1C000D
X-HE-Tag: 1780441668-942424
X-HE-Meta: U2FsdGVkX19ww5eTwqbP/LE/r6lfoeKxlH1AOBCaz8stwvK0ZFSThQ40bKhEQuXMOSjw/Z1wwF0qTfDmuehW66E6cuIecxn8JNQlZnKeVY3u7iSpdJOxEgqQaK4hle641CZUSHhStzS0ujj0W7Cxbuu1+ji52NzWaW/lomzcwgADpphCBulgbbkL1mdf7ppnB6ZlnLUb0Qr2pDFEA1n2UpHTjOAHzo3tl5bdeFSiFTjsX+zgoj11R7w27+Hl3yBusDS+/cH/M4cZCyOTtbUmY2flDEWgYFy349iKQRUslzgdu/XZpnMDzXhavbePLVq/LWblZLn0pw5pJM26098GTTFct64rf5pYR/jHot01HglB/nVE8PEnN0jKecGh9+e8TOmVpEE+tlruIokWDGWxdIzoR7qMNiGwZgcEu+Gg2iAax8X9LlcZ5ujhcMoUQgvpQAUeBa+DkH690C1n9tFk09CeH9tJa1i/CNbISIEvDO8hldz+pXk89G8/MmSl8y+spIpwkYkMJPi4FYlgadKhRkCoAze35U2IHyS01aS2qeTgnxpEJ0DSYO1a4+UocQTJ9wXQycaIPr0dPhW5rSz0HA790XyfrvNZkVMU6sXi0Wa91QjfQg4tz6Ox+VfSC7ySHa8B/5GuOZ/2YbpDjOZfqkB8M0glwofr8nbw5fJWuRcC1/3cxtv3lWyeJUn/BFreRvD76jO7CkWwM/wIRHg2NvFdyhZAcSWQ0r0nhM3tUo4lx8ZAy26NvX3Ut9sJJsdalyVHT72APaXzmVkPS38LxHWzE9UY3leH1FAzPPtgiiRHwX8Pyl8EMxqeoJpoGhL8y9yBEcU4zDXGkdup+6K889iALKYGbhQhFraq0hnjLzqHp9x1m6rv57Zgv5O7+Dsn4mxCIUu4gEaA0iKLgr6V+05ZAFQdevgVIxK7textAts7pLva65+Fq8o30KzGbE9aKmrs0qDGIy3SK0jPBbB
 9mhxDAFB
 K0yUUagRIF+ZLbZOWC0yeA9Xd4YAbKXn8On0TVvOXM7YzzZuwPapzZ5hhitYdbeXFdBzRREpBtTjIUtBkKloJqI27Py3OnOd330JK5SPndLr8OM4DWTHRTWIYhUjxf0FsiuyJijOVgF8H6vejVmC+u8rmij1zQnlP0itYFTA6P1aE04Liu2uuFUWrCZaNvaQRzjmGP+wC1C04ZDiFIC1IR46oa46L+DgSNUSkfceIkwviCnhmsUJcl8Jd3AeglrFEh5/d52+9T8Z+yFlXvHS96XExhhJzFlWRiCQDOUu7unToa8IkAuelUrBS0jMrJCc+wqR7HhuABb04kRNN2twzYHUaQiFiz5XGotKnvw2teN3oudIfdgWtgSmUL5rdS6K+24JBPdkkzGc019kGwE9yuIq084BC2+L+7DrHy2Sbf+PdulJVDXPsTQFGgbU1G/XW5kGixRHo81ADwKw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pedro Falcato <pfalcato@suse.de>:
> (Askar, if I was too hostile, I do sincerely apologize.)

You did nothing wrong.

-- 
Askar Safin

