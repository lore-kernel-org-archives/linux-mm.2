Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC479606A334
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 08:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WlbJGa6r
Received: by kanga.kvack.org (Postfix)
	id 21D5F6B05D3; Fri, 20 Nov 2026 03:19:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A6C06B05D5; Fri, 20 Nov 2026 03:19:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09A7D6B05D6; Fri, 20 Nov 2026 03:19:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DAE226B05D3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:19:22 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6C9E540D9B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:19:22 +0000 (UTC)
X-FDA: 85454797764.28.8F2E52B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 883791C0005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:19:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WlbJGa6r;
	spf=pass (imf21.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795162760;
	b=YYaF+10lTuJry4LxgrV4rBD60RN17rn340zubB5E6ECDuUwh3fMRx9BUDnTldwevhnb5RH
	KPxHUMPaB56g2NAJX58vfbPRaFzpepu6JE1XbvbWny1KS1XNgsMlDxIHIjiGb8UBu1kPLt
	hcXFnNiy9mf+aKcUbK8A4J0MkYNDR1M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795162760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZLVZJxESS8nh61KH4gKvJ6pqCiTggJl/NDFsKtAxWgY=;
	b=TwTF7x13ebyNtj/CNihb9w9jm5gqJgbM8/x6APAqxI91hyCi3ZsdRLKQ2w25IJswjZBAEL
	QNHC0MFopJGilXKe1l5nTFFiMgupHdJf5ZlCr2M+E+h26wojVXfP+DUSsHhX1kCBimjhWN
	Y8PGlghPq9CqU6kI0AnwJKcF6JkbJnI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WlbJGa6r;
	spf=pass (imf21.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D446459FC
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:19:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F521F000D4
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795162759;
	bh=ZLVZJxESS8nh61KH4gKvJ6pqCiTggJl/NDFsKtAxWgY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WlbJGa6rvPAEL9wEVmhuqKwq5b9PQsHofUWiHjD6MEyvzikzfKGtxbqPGelKuVxYs
	 m5p9pRMK/WjoeetJ4SxALT+BhcI7SlSoqL30ucUrC7oL03QyMUNNTtC4p/1UFpHGE8
	 MX+wFnOe21Je8mXXfpJ+TZSot7025mlXytCgoxP/yg70OdLx/aoNnpP/g7pkk9Lg0p
	 35jxfSqJAb8gLSUUS7L4Esc/tpH27jCLNA6poK8j5LY5u4Z5WZKT/fPV9+K398+OQQ
	 ahs+Rid6qcYr9FlHQWxDJChtd/CB/HxmAWcACB1+HKdLeTUevE+FoNLBSvP7meyu1o
	 y20qAuljNqCSw==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6b408f2d936so904747a12.1
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:19:19 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHi5VMz9WPNJ56BlnNemp0XM8Bgq9hfkVpiscBVdBRZfKgL3lAI9LhL6E5niLmFAcpG9sqGxo/k4Q==@kvack.org
X-Gm-Message-State: APuU4Z8g6NiqNaZRNRBVqJpShQuHT+h0ZtVBa9ZC3uMutoptXNH2dYyL
	w3VJCiX3jwrAyW05aVYsU9XeR+WPbXMR7sp4PZ0qw2Nj/p8WJEvAUrnXZMZpWfXpcFXK+xJN1I6
	OydZA9nrbGFdJVxbsMHnSB+eltZJ1pdU=
X-Received: by 2002:aa7:c0d0:0:b0:6ba:144f:ae43 with SMTP id
 4fb4d7f45d1cf-6ba37c7b138mr1080749a12.6.1795162757947; Fri, 20 Nov 2026
 00:19:17 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <CAAhV-H4pmcV8hah8sPyQn3nR9cO-NwkXMPLeSABAO-VEnS08fg@mail.gmail.com>
 <20261119125221.11897-1-dongtai.guo@linux.dev>
In-Reply-To: <20261119125221.11897-1-dongtai.guo@linux.dev>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 20 Nov 2026 16:19:08 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5ZZxa-wMovPdCEhzwPaxkcEac0uwBgV2jdfY=6jUrGYg@mail.gmail.com>
X-Gm-Features: AclHuK_s8BaVf06BT7xe6EODjiMXez_Tr3nUEr-rhXoD_pDYy5cCCc3-DaMT3_A
Message-ID: <CAAhV-H5ZZxa-wMovPdCEhzwPaxkcEac0uwBgV2jdfY=6jUrGYg@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: Allow memblock arrays to resize
To: George Guo <dongtai.guo@linux.dev>
Cc: kernel@xen0n.name, rppt@kernel.org, liukexin@kylinos.cn, 
	guodongtai@kylinos.cn, loongarch@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 883791C0005
X-Rspam-User:
X-Stat-Signature: zbbzpuwmrwkf53chknzbrmwkogeyne5w
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795162760-37125
X-HE-Meta: U2FsdGVkX19bOP8QPMqjXR6jf56E3lhqdTBt9xNA4DFuVFLgLtXbuPjpz7h1d/+D6nZqyYEwx4IZNCARkHS5l5YbJKrfcFYmoDkjcegqHgpyRzPuA2hSI0v0MGj6V7FnFOMwLC9tXTDDcXrsFvSY2pb94eEMjYXkIIr1cHQ2s6G8izNG3RswAwywqvLE39J7Z8w7pZljEGp6ey7Wx48IiSyamN0jjNZ6wsQBOdp3ABBzWjj8IsheQFAsK2uIq9syZJGdwpVmi0x8haT9NZUQE0iEH9G79DvHCZig/5eNVgxmfuu6c0yx5sMU9m+vsZfwsPxQ3fa0/R5FR32eWg4C3Q0iBOgkaXRTjcrtg53EZ9gOCRf/f65pps88Ol0U+aLsbAO5E2hrc/VPIztzupYMQvTJEf3uGya8L97d75cmEvCZk+5R3H4UghTNGBVGvSfmhYIQMCbS5dufgJSROu2B7v10ZjzFmU8L18eytddPWU5fWe0A2DIbOnL19ZQJw1GWbR++90gmKNLQVjtB3WzFCIITlWo0li4GCemBe0160YQucS7nOVY8iaEP+j5N3pH5OSx6beaQFCdHfE1rGZ4+IShhNTEXZTmg04DCQa20rkZ+Q3iCG0CrZcBe8FmWILzmbmMDrbPZz0nDIAj4AeCP/xR9b4EdB4v95fFzRkoOY0T8+LzlOJjOiME1EeQz3qB1EI4COZZHg5TEDN3FKG569YUHQYdg8ewZIOazsrjFmM00RHRHaHps4PUQbz9sdBBAVHh0tpD+SV1SAaPHPUvEA24jr6GQPy0OCryuc+V5WEgM88btJB8bb6wxwIOqUtBe1+/mYn7osc2XQ+66qSi/XFnAdHMyyVvzLfmb3mcR7ipoflhbCP59dwT8kho0vxw5fyEiUIe3OETOlTluP6AesjODmZ+QpH/iXig9f8xDlZJ+SqQHvlw5DpT5/bkd5xS8AhjV9ly9q7kqwiYYOaN
 5aGKka9X
 mr3isa/qy6bsdmsqKR0aYqNt0Ctx9upXsMFJBN9UDWctbkZ67rD49+ifWLhvaXMXJnHFlN9gdxE9HnfE0EkEevorcq/EFNzpqM6aiJWrp0SFmf6SJNMd630J+HV7LwN1MZux16BXsycfyLdIM7+2o7qZ8HTwzOJBJsHvNjf9/N6AXXYSiqlLKDxEXnYWE1Sq9thG0GvqJBhPtrMQDytv9LK1VPVc95f8PLggudtyoC7BeGtLu2iz5+G9tN8CUXxk9ybm1ofush6iBUWwCCrKbZ1Ar5n46jyAl0XMOGfohzAJLl7f8vqSrlCVxHC2GkPiIMZwog6Xwaf7KjSZ8eHZ9Gq1l5NeXhgyikwfR0TV+bY7ovxoTyaVMT+Duc/e7VCe0zI/Z5ffaqnMVeC7q8yIbKgF2jwugoyDnJ4gdvhVbGi/5ZCrwjsr4GpnFegGx8kPiGpXJkj81k2CMjz7XvP3JzIKT2sUBaNf5JbI3K118W9078uOuBFk8ZqSoFEVWKdnKosUSNo7xaanGSkGd+PJjlcn2vw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 8:52=E2=80=AFPM George Guo <dongtai.guo@linux.dev> =
wrote:
>
> Hi Huacai,
>
> On Thu, Nov 19, 2026 at 8:05 PM Huacai Chen <chenhuacai@kernel.org> wrote=
:
> > Would you mind if I move it between memblock_dump_all() and
> > memblock_set_bottom_up(false)?
>
> Not at all, please go ahead. KHO still works with it there, since
> kho_memory_init() runs after setup_arch().
Applied, thanks.

Huacai

>
> Thanks,
> George

