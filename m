Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68472C87FC9
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 00:23:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 095D66B0092; Wed, 30 Jul 2025 20:23:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06D0F6B0093; Wed, 30 Jul 2025 20:23:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EECD26B0095; Wed, 30 Jul 2025 20:23:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E134F6B0092
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 20:23:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 61F091A05AC
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 00:23:05 +0000 (UTC)
X-FDA: 83722659930.08.39F2FBC
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf28.hostedemail.com (Postfix) with ESMTP id 793D7C0005
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 00:23:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dOf0hJ9j;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753921383; a=rsa-sha256;
	cv=none;
	b=KX/LEVncs4Njuhq5rjI3tkEk+Tkzy94BaQH8eeCYKj9csIwmJhNT8r/fKEVImpucjxsJlj
	1dhnDsmFJPKUn8/N/LKVcmKMlEd34Cd+2xpwWIbBPeKDLv+pvraiZ3xIG6UBNl3UIuC2EC
	YEh1//+1rO++lVdXd+OTThwuvwoykaA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dOf0hJ9j;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753921383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JUOcYwsM2Vo3v+H7B4giah3E0XAl27sfIduBCpqMtM4=;
	b=d9nNLol8lIIgpBQCu3DqGSGlv7tqNdivbnu2VrYeNxj+nJbttjCiYQCTkqL6S7SgbaKAWN
	tgS7rEL3rwlbA6J+Zx9eShCdZTmGRq4VZ/oVvzFq1f0ZvUdaDYIioi3zhgD1O6vXdOiFt/
	LSflbx0hQgMyKQUWAaN6Mo72uIZFZU4=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-707453b0306so4237556d6.2
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 17:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753921382; x=1754526182; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JUOcYwsM2Vo3v+H7B4giah3E0XAl27sfIduBCpqMtM4=;
        b=dOf0hJ9jowbv/hyyfcq++intng/nZtjrYseWPp9rAq5qU5TU2dr0roIpsnEo3KM16f
         G0NPLhjTHPIBZcAXl+NMzPJXOuKcSdZKaYUT8sfa8NRVGxbMfhJd1/E9qL+rdNbNn6bY
         canSR/pSDSXHS3kuahYskx/JHtM0WVfnU0LUUz74SUHSmTphfBIDj0eXQNVHblFi6O7M
         ZVz9JSwmsEV7n9GUJglc/BYCnFoltgNWblxfR0MbQQJw5zfp3e08720eiozS5a+fIqBZ
         HiMmDdRWncYiExLLZtitJ+PA+F+T6LPUcU3hPaniQ+5+ObwFGvoOGB0nqd5MZNk/vlvD
         C6sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753921382; x=1754526182;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JUOcYwsM2Vo3v+H7B4giah3E0XAl27sfIduBCpqMtM4=;
        b=Fpnpge9qo2U0ys3ewK2gi3uvTxAPMy1SNdbmQvKFdpPT7tRQoM/OTuyWOVLshPJumz
         1cM3kj2x60lf+Iouk/+mS72gH/tzR+bqN2v43CSet9o48xreXAcNEr1M1MAGadvHPJCK
         g/DQ1sFGSNMIS8g0n+7u0NxVF+KHv5F4VuKIgr+/GNOpiJwfJT1E8lsSRGE7jnSRZATN
         WhUASGgxnlRjx376btmGe++7HNjabx8vjRZxWafKxoN+LsOI3E3heDrS9OOYqTb4RlbU
         zVH8DulytGP4d+0iEOzjPHYOEqSYGM7qEXxWXZtSr4drWLkTWOZcsA1v590vq8xJx7CB
         aQIA==
X-Forwarded-Encrypted: i=1; AJvYcCV+WxEGpRgIKckWSNXAvW/XW8bOPgSpzoN5YzXsa2leUS1q+xE3TdL6GbUcI0Rl5tvnJLKWe5jojA==@kvack.org
X-Gm-Message-State: AOJu0Yx40YKrX3n4Qy2n+mtp6tiQd8LfZA+aO791LdZAtJgvk6nUbTcC
	pFjtdG5rQFQU/55XhkePxf3mEAYPrwH64v3xdLOucgRHT0LxWMPeDwNyDaFaq++bDfYSmI9cMPN
	l1wHk0QTfk3qrIDRZswkH/SKWrnhcm5A=
X-Gm-Gg: ASbGnctx3CQUBuP+0Mv8yu907T8GwA2RCNI7oKV6OkZzRh5Hm0UfOHuZ1gEkBSOTr4J
	etJUyWECbP7lN9v15tcpUAwjHTaR8Zz1KbmfOCxnMFE8KXuxea+S5b3RW+9xs7n8fv0FnBoNGdp
	2klP74ERx5PX8BwDgjAh/ESrIvTxOk4XTsZm+NQogIR/HBP6e412iW4QP/29jwJJ6O6h5T4M/MP
	ZkOK1jf8v47X9ODLIIjQzQ=
X-Google-Smtp-Source: AGHT+IFN/GBILW5gq2qTwP+JQvZwsP6ofG/UGo64fdhGel8rnmkBWdqLor7rZi2YoFrVVCm4Y3s54Iq3+zcxE5PWlFM=
X-Received: by 2002:a05:6214:2626:b0:707:4daf:637 with SMTP id
 6a1803df08f44-707670af0afmr68367656d6.29.1753921382496; Wed, 30 Jul 2025
 17:23:02 -0700 (PDT)
MIME-Version: 1.0
References: <20250730234059.4603-1-sj@kernel.org> <CAKEwX=NC65XCkmX1YzivEJtPc+sEJ3pLHUsYhF60QJnk_OtpVw@mail.gmail.com>
In-Reply-To: <CAKEwX=NC65XCkmX1YzivEJtPc+sEJ3pLHUsYhF60QJnk_OtpVw@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 30 Jul 2025 17:22:51 -0700
X-Gm-Features: Ac12FXxG9F8doOzHE0g2D-VIdiKuBG3pUU6xe1gaj53cRFrIK09S5oOr9nrF46I
Message-ID: <CAKEwX=Py+yvxtR5zt-1DtskhGWWHkRP_h8kneEHSrcQ947=m9Q@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/zswap: store compression failed page as-is
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Takero Funaki <flintglass@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 793D7C0005
X-Stat-Signature: pyeaiuqjuo3mw4uzj9f48ok4rnxkotct
X-Rspam-User: 
X-HE-Tag: 1753921383-806202
X-HE-Meta: U2FsdGVkX19PmZ2Nn8EaGeWjF9HYlwCaH2vsZ6r1uf2O4p8lYuM+FFuS/nMDsaAqRUAV8i/aGwPYGecS2KTowx36ebCYIj7hfVxPD7a+upiT+nO65JFJXWKx7YjybVbhimSMdGbf52gXRX1OCV8Irb6WyDjZNdFoDj07mRWj3jxgeZcaKdrzE15FPUg0T+5Aa/529aPLmir1ZyEZQN8QsZRZH9hJqp/qg7m1jxQ8dmUDYXuo22O48cQOi1+tYPREotciNH9BXua+qKPgX/C2yxjMz5z26YePPxHQka+B9eHYctKVh/+xoVugbVbJzAjfpKLK19lMBss9QoU+QdtDvSPuD9khZuwnQPPydpER3IwD9SKh2AQ0uBgFPYJZD22Bj02We599j1j8d5lmHLmuEsvYvvk+Qz48xYVKp/5PT8pLHeG1UfsyON0uxCf2PzmpY3rFBDKEGiJB78u0O9ARFjLcdP0xJCP7aVFs2ek9atMMZPk/hsuqMnAG+boTvW33nnFZpSmGsb+dGtYuGXkc3lxbROBjiODbGCpYSoQWwjCNLosjHPe8UD4kSRYEYSPM5Oz7cT2bSb7J/ydeYEeqMtjzT1a9Dokl34l/yJS2P1CkbNpPu1g2b/Q2NR0PFg5Qze4N5bsD37wUAI6EKSh5GSvNihxhUcRC3gAsAbyKXSK9NSMeeW8vnQJOl6MIk1fxCA+kwXzz5esAtScefPVoMerd/g3M1PxN8saDymKU6/vNIAH+voRyE7/RLZDtuR9Wi85C5pnIhtmpTuVjrR173ePj3GsTRVvXTfKkVf+oU0tIhVmqezpIuuJ15dtGIhZE29R32K0de7Nioy27/BsR5KwYhAsJXEUYfwEv0ehd/mAWBaEvt/uMsO/rUsHDAORvnSRpVKqgw3EoHSzQkwqE032MM/o64Fq6eDPCxFQLZExkNTqAOcnl5EnDcsVwk/sfpJ5E/UIi0yk0gSnInjh
 i6nUJpsp
 knFMaNGFEFNXi9z3XDEltwf2X0Ba0E91XzLBtW9nE+g/omTeHdb5meP6+XJ9TGuZF9DLN3YqBx+8Rg1V976MxkeMAB0McGEb3k7Q19rNqsQsbJfTsRGHqSe3qGe8AeRMDKl0RDqd4bOlxmzbz5Rnhq7QaSR7V0mT63lqu0CvxCG32crAkGMGOgnCNf4nWusDrHz0MujHH3fcoUm10tewJXJvCSXuBw+8znLtbuynUxzIpMuOSOwFN2pn+0eaZeRWREuYI/NNBzuxmy1BgU9CU2AAjmyZOpa+KIs4JPelS8ihL/mo3yxAInx5XYtAPe3sWb/Dq+lVgxrkxuJLoDstWZbKUnJjdwkjfnALo4LnFqZLvxRemI+BJrtn4Pm9PG2PDfiWg4L/uZmZX5JzejNEJXszbX1TABUdi6Z9ib2nsjfFX8O6yQ5pE4jSrhIjXsjLdWG0h
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 30, 2025 at 5:21=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Wed, Jul 30, 2025 at 4:41=E2=80=AFPM SeongJae Park <sj@kernel.org> wro=
te:
>
> This might not be safe.
>
> It's conceivable that in zswap_compress(), some compression algorithm
> "successfully" compresses a page to the same size (comp_ret =3D=3D 0). We
> hand that to zsmalloc, which happily stores the page.
>
> When we "decompress" the page again, we will attempt to
> memcpy_to_folio from a bogus address (the handle from zsmalloc).
>
> So, in zswap_compress, you have to treat both comp_ret =3D=3D 0 and dlen
> =3D=3D PAGE_SIZE as "compression failure".

Meant to say comp_ret !=3D 0 here... sorry for the confusion...

