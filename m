Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D1F1C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 06:38:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5956F6B0088; Thu, 27 Aug 2026 02:38:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 543E66B0092; Thu, 27 Aug 2026 02:38:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45BB76B0095; Thu, 27 Aug 2026 02:38:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 24DDF6B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:38:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AD3CF4033B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:38:06 +0000 (UTC)
X-FDA: 85146094572.11.B9F5C91
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id DBAEF120007
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:38:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I8bLN7iL;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787812684;
	b=L4OyekheTP83dqv6iyR82ATmEaF7tVHWfwbu6nzof0P4leokEFMhQBFZaU4PSUbr91mktS
	e3rAso3uAIsO5gbV7whnuo/9+Zf3kFZGhH5ash6ALci9QpMAGE163GALjlzNAnGOWt9Zxv
	7mdIZFcfb/nYac9RHo/d41D+ox8yMxM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I8bLN7iL;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787812684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PDX7fTqa9jO07UgQMS3Zh+rMDt02D74EyWmNn8TVu8M=;
	b=8VEs8JTJJXnNS1qX77ing29j/pS86vHWPEQij/Vix0sYeDtCN4kH8ykes+aZz23asgGCNz
	AZISp/gv3sfoi4qf/emHDgdIH/KWDUsRfMDAszNP5C4GpYjKP+U+s6axMsUUkRHS0B5/9V
	3jj+k8yfZS8ZhZWtG6QeHzWRDb18wMw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F2564600D4
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:38:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98351F00ACA
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787812683;
	bh=PDX7fTqa9jO07UgQMS3Zh+rMDt02D74EyWmNn8TVu8M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=I8bLN7iLSRN0WOuTkRUkCAI5TRDmMrsz2qJup/5/JWXmAt89NyrtQUfCiXp1IJAhe
	 s9FhwEXuKn/UGvGWTgdi4Lt6omdwZNp/DMSN1UHhCRZ74Lv0+Z5zhdEzwzilSgntft
	 L2ziaRsoVUY5Nkgire1zSYaH3amQ2OuvTeHqTOEFZ+st/wHSCfWDjRRd7y5JmdM9Sz
	 /AZQxzPFta1hxvU36/Ha7b2+kPTaWHs2jBITYaxAgEBxb+ELbq+JgJ1MMSZM1S+pAc
	 yZuL3tWOeJiSwvVeyK6yNbB542gtxGayK1owEhgRKE6k8lCMLxi2OZIQqAsn412vK7
	 B2kqyRmAzPGQA==
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8ee43b3e5abso1701086d6.3
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 23:38:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RovmZKwP7eXOWJsQtmSRYOdSt9BzOpWCX+DwcBPU2H+X2aFNG29BM67dLkXYV8LPYRJinguYtq3+g==@kvack.org
X-Gm-Message-State: AFuF++nerTkIjFHjn/2wVLQdlnzUecIt7UIf0rWm1pENTh/RXofqh8Wn
	MRbMScG5jdg+ygtODhA1suRLGpCJXfTrj1cSt3g3r3u6XPAR0pFA7kyZTC2hEsNjytU3Zx2ynCU
	9jhvgCKazNXZtlc1MCzgHSxMk5JKnOH4=
X-Received: by 2002:a05:6214:20a3:b0:8f0:3b2c:a9c8 with SMTP id
 6a1803df08f44-90cc796a085mr128225816d6.12.1787812682974; Wed, 26 Aug 2026
 23:38:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260825-remove_str_dup-v1-1-0ba2121a820c@kernel.org>
In-Reply-To: <20260825-remove_str_dup-v1-1-0ba2121a820c@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Thu, 27 Aug 2026 14:37:51 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wfxttrKgwRBpprsES_vjzYsmLzkd7buCkYR8HoEJqCzg@mail.gmail.com>
X-Gm-Features: AcwNN1Vn7Rb2kkRVf6ZzDIKB7z1HE49FN6Lv30_rkBq7LV_rDlQWRjcC3ksW1oQ
Message-ID: <CAGsJ_4wfxttrKgwRBpprsES_vjzYsmLzkd7buCkYR8HoEJqCzg@mail.gmail.com>
Subject: Re: [PATCH] selftests/mm: khugepaged: remove str_dup() usage
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: prsgfyfys3eba961n7gxmowa417ruz5m
X-Rspamd-Queue-Id: DBAEF120007
X-Rspamd-Server: rspam06
X-HE-Tag: 1787812684-516243
X-HE-Meta: U2FsdGVkX1/QoenBPgLpehblAmb9TOzrkQzZN5ht0gOZrzQYbudj4BSvrp8EdArHfUfiK3lMfogDipaeVEDMN2WXdlYag3jcJ6od9YPbHIsKYahsI/lgb37l0PiZMHjgYKBf1HPSbvkgH15JEhQms5puSM0Kzd4eNlQwOIILoBWysC8WDnt9p1Pk+QEVU9hyPti8CMPvkpTcABjzoIS/CuIIYzy8rYBnxUwDEQVvc82n8/r1l6X8SnMlrR6YXOYmpT4/Fw8C4Dq0T2nz0kEzuYpgc5j+Clow1BH37NMk1sRawpdXdf13e7IKsccoNUu+Mkk6FPmod9S3LvIy6mI1V/6S/XZO9lZk8c2eIGSiWeKIn7B5YbuQUZSdjD9UBlWdn7463Ysn9CrMs9cQjWfWUzwgn+b7aruG/EMvQaiXfYURM5PrjBynTqk2VxdytXUtw8vcqrznCslMvu5LtEh84RkveKfqUNiND2TIb7MpllpaFtCgO/HNW2Z9Z4iReoSiJsfqeTRyE+jKsjnQ7efqTrmmj9JfnMlDQivxg+L4xMePzAAUS/0HABCIXxkhGg041IhIGicHKxr3um0T+E0INVRCpvYIc3pXdrvVvrFo/6R7kxImFAnl5BzGYoS7pOf66zNUpax9LI6tNLka3FTS5tK4C4jd7Ws3Ctdtu6cZ65TbIlidDvQTntNYjKvviU86GmjH+7pk76GGgNd59bqGSUnxyitBeD8Ackp2Plh82Uwfb1AetL2y+IUOlZwAvD7CweZqCZUbbMfnrFLHR8rB6ZujdJV5AFcrG7zDK39TEjoEt/+Ipizv4rKhHtdEuOA9ZNolHW1qza9vKznMRyOsy9tPxVvOAGxtuq5KdinUV7d+JZQ0Z+memZYBlHlvp4mjytnVeU0gnmNlhhCzt7Sp1ZyNkLfmyAAAU1S44jV2eFJLyBMOo1kp4lAoBNQfdXwHtRPWIRoJpj4ml2N7AqU
 GkztVKYB
 9TxdQphOyopjSmIshVxraDguzNyi9EMz9ESXum7QohxVXXS+TZ+8osIXCbXV/M+MM5/vj3HYG8pMrrVwlEhJFjSHDGRkMQ+0wb1dBedyylI8WVsNaPOpXsLcYQz9SC+tpW/k0ywpIYa/edHsdu13021TpCqc5NQ4AJ0tKdRSK6CE9BXPWzLHlVJ1hx703+WiGY8cychZlVMZkKCSj9BwheaVDR88+hVCYxyXDl9c6ngDxhqbYorjmqLNboqnmAi1Mc6Buo3zFi7WNW+kkHHR8wn9PXRzYuwJlt3G6sWmsPRyqRYiRo/DNK7hgGzKAs0Y+ECFZa1NmHhafWlFU8mnzhCFx5mN6YXS8518RmA3FfI1ii6m+zNWepEg42w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 7:21=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> We don't check str_dup() return value and never free it. While both
> things are irrelevant in practice, let's just clean it up by working on
> argv[0] directly and avoiding the str_dup().
>
> Nobody after us needs these parts of the argv[0] string anyway.
>
> This patch is inspired by previous work from Anshuman Tewari [1].
>
> Link: https://lore.kernel.org/r/20260821114416.12255-1-anshumantewari123@=
gmail.com [1]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

LGTM,

Reviewed-by: Barry Song <baohua@kernel.org>

