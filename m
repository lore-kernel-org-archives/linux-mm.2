Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B236FCCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 20:28:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F39EE8E0112; Tue, 14 Oct 2025 16:28:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F11AD8E0090; Tue, 14 Oct 2025 16:28:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E26E48E0112; Tue, 14 Oct 2025 16:28:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D19318E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 16:28:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 81C3C160A7C
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 20:28:32 +0000 (UTC)
X-FDA: 83997857664.05.3CE7A0F
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf03.hostedemail.com (Postfix) with ESMTP id A193920015
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 20:28:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="WA/mF824";
	spf=pass (imf03.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760473710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pBzO/qxwMFiuodUwjnNSTjmJpn49BdXukWovp6AjsAo=;
	b=pBJnnfX0hE9BJK0qHh2yHOfT7QHAGe7gQjy5v2XfBSbVJrnJ3KLvUCJhCG0X86TWQvYVsL
	li87N66TbWTSyhYIDWDxQK/nfUlcD4GKSJRXKeBb4Vx2x5MOpmSdNIiYhL913YG+oVtrP6
	a2Kx/qt+0iFdEFWfKWSoG3Y7JpQ+HHg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="WA/mF824";
	spf=pass (imf03.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760473710; a=rsa-sha256;
	cv=none;
	b=qmTyG5mPLzTU3r+s9JzNz0u1GbKkcVB+NAPPM+SUJDMMrfHprvCVcWhqd9ojrtvHGkhiDd
	qQY5p+7kRFAMRZgsVcDLgrHd83H9cRHn07s+XJljTyF9px5iipUrzUHWcHWtDSeYrCSZdg
	SuLP2zbWIsD6sdLj561Ouz8ACaZIL3s=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-84827ef386aso562395485a.0
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760473710; x=1761078510; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pBzO/qxwMFiuodUwjnNSTjmJpn49BdXukWovp6AjsAo=;
        b=WA/mF824GimBLOkwRGIe+9bDgytVpP0nEFonDLnpHEB6Ud/TvlOXYbXUNELitmX6ZS
         IWARO/FeLgNEad1eAeQxNim/RWb3gA3Wb3hgZ5GyO9fi2TRFAjTQoSoKABOKIZxcQVXW
         Ku9ECMTDJAXb2li03kkR+3dt8NxrVCFQZM2+4CH1oKVPrgqk5VUNvp6hKgG0WvhtYIRP
         r+KIK/+PeRUmOAj9R3mvHdDIpdfnBzQ6tDmXFAJyGOMi9sXgnujC8e4vjAklwzsh2GKy
         +pCSaBtCVZJ6Y6eyyVCFmr1MaqMrBV1mWNktpQpImTdbOjZ69QeeVh/ei6rAEtM8rUbc
         Nx7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760473710; x=1761078510;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pBzO/qxwMFiuodUwjnNSTjmJpn49BdXukWovp6AjsAo=;
        b=lC8SwCoWrufA9JyQL+3MLoRb6SadXcWOk4pH3kRzenQa4WM6SV9BdFrEWR/G//QKed
         5c09CNEO478pGsPFngZM3AEXf2V8/i4wxMV7cf3tMd9ILdNSTCmRQME3oFicfK5NZ/kp
         fjzOHtD5dNgdtwSn4k4zXhOStw0G2rlmOrA52SbKE5QtjPHy83Pgh0OUsRIY0n4xkKni
         yl0p2dJscIBayHS/oPtshz2e2YBOs18bHPn1pZcz8tswHoKJaesD/KuuKnac03kR2Cxl
         Rf1w4/OBxTQmAz1Z4ynrThjH6/jJNvB2SfBqM8G7VN+Vk33Nu0v+uJuwykNEa1J9WLRv
         1R/A==
X-Forwarded-Encrypted: i=1; AJvYcCUCq+fFW3RGvSjQ8pzbPgRKto/pSm3wBihx8f25i53E/0hUHNOKDiDUIWzwPcnGcP54q+Q0mwfdlA==@kvack.org
X-Gm-Message-State: AOJu0YzGL4/b2rACaRvgzoJUddFBKRGLVoxwCXzrmYdzvOF7myJm6jQN
	mhHAPOnNzrG9rMw63j4yVTzrM9O3p7FMsR/yAWzMFHCNivx4sW8wwPUG6z+YCxzyYHjDzJyTkWQ
	9mw2WsobVU8VLg7J2m4f7uo9nqV4jq4c=
X-Gm-Gg: ASbGncsYee51xg7ShADyl1Z+MugbkhJGuai/ZEi7/7IBORnIoG6YLy/HWGeyNxvR8NA
	yq3hjCkP3/Ymoo9vqMk5WhpWIbc++In6/Vq7tiE4kHWHqXkaMhAVASqjc8XkKu8GgHWNuraoZSV
	g/Q2JhaWnDvEa3cB9ywqc0544In13KQGEkvlYuv+EVEY9eOClH59pwUMzNyK4LCfw1ea/psZA2q
	L4mj+HxlDW90SxWAtkM4s5UBRAc1/o5yBb4M55s/k+DMfQATuHH1TK80Q==
X-Google-Smtp-Source: AGHT+IEHWtgmhT2p78ndsLqREi02CoamLTiJ6OeM8OKrYE6vz8/hYR3ehoD9cuCKSfGARp+UWdPDUVymrBOFs0luCz4=
X-Received: by 2002:a05:620a:7010:b0:85b:cd94:71ff with SMTP id
 af79cd13be357-88356517355mr3325050085a.48.1760473709638; Tue, 14 Oct 2025
 13:28:29 -0700 (PDT)
MIME-Version: 1.0
References: <20251013101636.69220-1-21cnbao@gmail.com> <aO11jqD6jgNs5h8K@casper.infradead.org>
 <CAGsJ_4x9=Be2Prbjia8-p97zAsoqjsPHkZOfXwz74Z_T=RjKAA@mail.gmail.com>
 <CANn89iJpNqZJwA0qKMNB41gKDrWBCaS+CashB9=v1omhJncGBw@mail.gmail.com>
 <CAGsJ_4xGSrfori6RvC9qYEgRhVe3bJKYfgUM6fZ0bX3cjfe74Q@mail.gmail.com>
 <CANn89iKSW-kk-h-B0f1oijwYiCWYOAO0jDrf+Z+fbOfAMJMUbA@mail.gmail.com>
 <CAGsJ_4wJHpD10ECtWJtEWHkEyP67sNxHeivkWoA5k5++BCfccA@mail.gmail.com> <pow5zt7dmo2wiydophoap6ntaycyjt2yrszo3ue7mg2hgnzcmv@oi3epbtyoufn>
In-Reply-To: <pow5zt7dmo2wiydophoap6ntaycyjt2yrszo3ue7mg2hgnzcmv@oi3epbtyoufn>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 15 Oct 2025 04:28:17 +0800
X-Gm-Features: AS18NWCDtdWGykNnr10kVKpaN-UFlp7dIYD7B4uot-LSzZLpylUZVkd3ymutVWU
Message-ID: <CAGsJ_4w-=MNAKyNk6hvAYMbi_tdiehM4dFtz3x0-V-0kCh83PQ@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network buffer allocation
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Eric Dumazet <edumazet@google.com>, Matthew Wilcox <willy@infradead.org>, netdev@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Barry Song <v-songbaohua@oppo.com>, Jonathan Corbet <corbet@lwn.net>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Yunsheng Lin <linyunsheng@huawei.com>, Huacai Zhou <zhouhuacai@oppo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A193920015
X-Stat-Signature: g7fik3qzjzs5okin88d4pma8hhotetf5
X-Rspam-User: 
X-HE-Tag: 1760473710-62238
X-HE-Meta: U2FsdGVkX19w4C10ih0rTO+LcOt6041MlV4T+pwfj1TzXQ0giCslmUqiCJbcH6uL+IeHdmHQbyPCXwmNSdDpeKe3BU7+J3SiQOluT+tUqApRreAiEd8JA2Hw6gWkft61/IR5SLFDFrddoNwn6VGeR06qdZocJbXQ0vQmtS7q2vv/69gLeRNjF6qjA9CZTlRMy+03vzf/bC4++VhyzCXjp9Kg0rZCNkNyzKzec37LlcPyRoG+DC5F6LN/RELGRb4rCH9PEObFVDg7j0Z801sC0YDkXaS9/8dV90bvP3kX9uLi2VGW5b8tTeEGdhRnvNo2TINxIV6540rXPRytzrC14MWHVHBrBYT+IgXhxLj3acPPZKYECIkuUTXcerrNF9lvIeXqiwT8zB1YJjkMU33NneywUq8aVg0CeAQexl3/bJhUiY81t53jKZcMHjYpp9/ds3IlqMLgbuhfGDH1yDfFvMR5oI7B9otNXnTuLeLDEmtDrx39Pj18Sf0joTFP3QQM5sENtNUieXzWVSKQ+nEqp6H00Xoo1cYvnInwLVGqbCd1wZ+VO6iVv/PbfbYXXkwYrKc+31El/oPouplMy03uAV2ot9iyZfec9MvT+VFBbgQzkXp5r/DthvagseS+IMVjoOGc86df60NqQuBMzxSEpAAQ+W27hQBHTIFpDUAADpTOiZp5w9dnfLKPw9wBHytCw+pdw91adiRzW4+E44KuVug4bLWg6Ksn4Y1ALqfortHJGNiRJUHHDgVB6GrLpojPhXh+yfBMbnrRvVjnbKaCmOwcv7wX47aO5n0uG5JjroOVsL5rSm4SKGLDPxjpowi5jp3bvvKc04nqC+YfG4w4il87+GuBjLX0qm4IPq1hy/R8OY6dxO745s1D36X7p7WvjDYTXZhfDjYlSxD8nI3RX9MpU7FADcD2H7/W9Jfr5BnOT4qIGyKNPyyQQ5c4oSHw1A49ZYC8eZkpWNC1Lx5
 RvDfINNk
 AZl3gZkBQnsIOd6o9xG+IgfQ69hCeOyu4RhNzz4C3HEkyuQQZZAwta6NdUyAIPlyUccFYR2vKCUex7QkdmrT/xIu0CxF26+ARicx0Jk9VsoI5lFzsTVeI5SMjSX0acyr0EbC9GHtyFYmQx3LyYLWWKfAZGTBDmpwmwQg47KaxEENRaoxq01JBqu2cqdfhQehKN6nN/CYxL26FFo0vYuVJciNlhTMe3Se/j6nhKgQCOfXygNn+H9cJQRrB7j+YOoo+ZBmdjMR9MBljbPXX95OX7i8Omj2zdVb+MpuRZt8VocEqj/G1JpwDLtVMv3mxQzH0JFQYV6r57SPg+KU9bCqA1g0CY+NjDSQPJcUUI0EIwrpeZ2/OqloNlHJqZSS3qaWbZk62
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 10:38=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.d=
ev> wrote:

> >
> > It might be worth exploring these settings further, but I can=E2=80=99t=
 quite see
> > their connection to high-order allocations,
>
> I don't think there is a connection between them. Is there a reason you
> are expecting a connection/relation between them?

Eric replied to my email about frequent high-order allocation requests,
suggesting that I might be missing some proper configurations for these
settings[1]. So I=E2=80=99m trying to understand whether these configuratio=
ns affect
the frequency of high-order allocations.

[1] https://lore.kernel.org/linux-mm/pow5zt7dmo2wiydophoap6ntaycyjt2yrszo3u=
e7mg2hgnzcmv@oi3epbtyoufn/T/#m9b94a1c60452551496738e4e15235329f860d1f9

Thanks
Barry

