Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AA25CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 12:19:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC5D26B008A; Mon, 11 May 2026 08:19:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9CE16B0093; Mon, 11 May 2026 08:19:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DA696B0096; Mon, 11 May 2026 08:19:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8F25C6B008A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:19:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3FD8C14070B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:19:13 +0000 (UTC)
X-FDA: 84755043786.04.EF566E7
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7FA8F80003
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:19:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=NE8Iccbh;
	dmarc=pass (policy=none) header.from=lwn.net;
	spf=pass (imf02.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778501951; a=rsa-sha256;
	cv=none;
	b=2QirqeIBvSswEZp0lBzOL6KJeczIQO8xoy12UuOJBGA/RQFMblLUJDSIHPXJCFAHPAOgEd
	wfKuLQ/ULef8bUXXsRWPMwOgXOhp2yIsF6RW1uA9DIjd7dZ8nZ1JXVv/rMOyXOR1KZyyOY
	PUBauOtKS4UqCMFt2bu0+JnEHWHp50A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=NE8Iccbh;
	dmarc=pass (policy=none) header.from=lwn.net;
	spf=pass (imf02.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778501951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zd6JYObStql70QlOFbbXZc/nE8PPz1FUhOYeRsnw8R0=;
	b=WvQBN9swHqYk1OxwL2OSzx62zBiI8ulPXIhwCA7yzOHn6Ws8MfayuZKpPLO9m8P9kNJIY4
	siYIrAb+PkpyXmRQjEpIaGh6NA0sfhDJ2AnhUS6hzvI0ZD0C4g0lgHhEGBnr2mj504Nosu
	zJoS5TfO3XcrGEEAAaP2st0BjnJtkZY=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net B1B3C410B5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1778501949; bh=Zd6JYObStql70QlOFbbXZc/nE8PPz1FUhOYeRsnw8R0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=NE8Iccbhlop5kx/SHt52Rf/geOduMGW0s25QzxYTEUHbOkhdbPL75cGB5nCBgnUio
	 1pSNbwEElvVuv2NeKLxoVtFifIe4xEigRVkh48eplDHFyEsqhWGLAKSd1uQsFnnlWk
	 hWMnXO1LkRUlwCipZJeOAMpBuWCtuwX/eVO/7We249wxaKgEsrDn+VsCrzq3Zt/BJi
	 YfslED0S1ywKWCAqGSGB+63OAvyGLWcK4ttKvxUJ1uXeHan8VURu5zqR8s5MtHpuhQ
	 vkWlLjWBWQ4m/IYIg3bPaOcYEatIgwvk/RaLkbxDF8DLgll1PeFdXk4yjxFYTbZeDE
	 V8grkQeZtgilw==
Received: from localhost (unknown [IPv6:2601:280:4600:27b:67c:16ff:fe81:5f9b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id B1B3C410B5;
	Mon, 11 May 2026 12:19:09 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Marco Elver <elver@google.com>, "Vlastimil Babka (SUSE)"
 <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nathan Chancellor
 <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, Dennis Zhou
 <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter
 <cl@gentwo.org>, Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 David Rientjes <rientjes@google.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Kees Cook <kees@kernel.org>, "Gustavo A. R.
 Silva" <gustavoars@kernel.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Alexander Potapenko <glider@google.com>, Dmitry Vyukov
 <dvyukov@google.com>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 Miguel Ojeda <ojeda@kernel.org>, linux-kbuild@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-hardening@vger.kernel.org, kasan-dev@googlegroups.com,
 llvm@lists.linux.dev, "linux-doc@vger.kernel.org"
 <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] slab: fix kernel-docs for mm-api
In-Reply-To: <afi0nQ84k1oz5RyH@elver.google.com>
References: <20260424132427.2703076-1-elver@google.com>
 <20260424132427.2703076-2-elver@google.com>
 <9c321184-9080-4d5c-bd1a-a16cd0bbaed3@kernel.org>
 <CANpmjNN_=g31Eoa+w1NrFALfp1dDBi5oHEZdr_bA_48-tS2M=Q@mail.gmail.com>
 <afi0nQ84k1oz5RyH@elver.google.com>
Date: Mon, 11 May 2026 06:19:08 -0600
Message-ID: <871pfiw343.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 9qkhcz1jfoofk7u43t3567cbo1nsncao
X-Rspam-User: 
X-Rspamd-Queue-Id: 7FA8F80003
X-Rspamd-Server: rspam07
X-HE-Tag: 1778501951-876615
X-HE-Meta: U2FsdGVkX19MsoOQotoytb7BkdKO+JFtzw/XEE92C1Vm36gvCZFpFzk/2V87Q0/Q25/EbXJcuutKu4aIndyJRwD2jlwhs9wf9R2J00D4PHZaB4uwm7e3IcAD81GLkCJ/aFXT8BC0UNh/AKvY0nwq/i2ZS/oEbqf4zcQnqJQyudlLYm3ep4MfyU/Vf6Ib8t3SISjGkOBTEreixzN76XSx8AzGV+BA13P4GNf+FXI9YDGg1qt9d/oT4w4+PBgLzeGunko1AKRVEYxzYUGQnPg5wHDyW/vx0xSKDzDEaRHklD2KhOa5r3cRSctTF33oL/+6Gfewde/0ffWbN61Ql4xgi3JrVr7t5k4ieDsSB8Nk/PyeZQH9clcT6Dpeg+dPloBrBDwH6ZOdud/Gk++ZwPhbOTvST0mX/GUJ/vnliDFDCgpdJhmVm9t12cnIXYtBlTyhc9+c2dSkVVDrwPwM676VDHl0pGmBTftPKlWG4aBXZnht8DEmO1jmc8kcEJ5VYZNMdyQ5/OTqE+HU+9pmvFoT+S/4mK9qPan1TiEWwI6KMYrC2PhNAMAcLYMohRn60onJWDdRg3kyTU+tNpuiR91wT20+q9eQIoiogPDaIRZoyGFQ1/RwDRRHJzUN93RJczWfe7SB2mntkZDCRbMCDINuXun1dLhOOsVvp4D3br4r5Fdi/6U4rq/rbQJOui0EkIRDMidLvsO8oxa34ds+vmGKNmVcbC7kPW4QyDuiDQZqoJpcLvSM8bSN49dJHJdSwwpHwzmx7DxpxO89bcFspVRqfR6YuIMjY2/bYtjHIz3QrSEHpLtXElYUIyzpJu6eul/M5LxbCSToMqfDpzak+3qPAuuoJDbHKledixArqgUFTbHs5K0jRZF6/b0rU9cb7IVF5cHSWufcCU25NZFAUrAzxhvUfC5ah1eKpcJudVSbwxlWlLJtfKvuTvpn73HDQca8DTlWULQcLHY3y7hJYIj
 97TuPvq7
 hYbXQ0ER50mjTFSVG3Fq5QJ623Dq3KpUAKFL2u0Wx89dysLmzEXGoED5pnJAPOZXdTa/mZzd6J2vWc/wRUgY00kYCdy0faQdz8aXLCF+nRPJlz9M6FBD8n69dthkyk6JuQ/37dEV4wN4Tc+HCtIlKROd9rAU4kZqrJnTpZhjizboqkkoFKkM1SXhWJwfLNAsCK1vq3lOq4/pLh20raYm1UV6nZ+eCZdXIkv1JWCiVofIZAJX8Orvkfl6c508Z+oJL3PQ7QYxmrt1EciBNMbmaJbRMnlTLhEAjbnwkgmoeVjPUnNQtpXONWkQuqe4H0Img2Chu2DyI6HGtp9/a+ql+4ux469j1Y8StE8MVgom1HHeSbm2L3BRYtR/jnXqB6gu45e8lE9mzwpKuo4rESn9HOKw+Y3Li/diWqfPdm9UDBk3rMWbRzPs1SadEeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Marco Elver <elver@google.com> writes:

> How about the below, i.e. adding type decls that only the kernel-doc
> parser sees? One complication is also DECL_KMALLOC_PARAMS, and adding
> kernel-doc parser hacks for that looks pretty awful, so this is a lot
> cleaner.

I'm going to be a while catching up with things, so this is just a first
take.  I strongly suspect that the people who object so strongly to
documentation markup in general would be less than fully thrilled by the
addition of this kind of workaround.  I'd like to ponder a bit and see
if I can some up with something better...but again, it won't happen
right away.

Thanks,

jon

