Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08E69112583E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 15:02:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F17806B0005; Wed, 11 Mar 2026 11:02:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC5946B0089; Wed, 11 Mar 2026 11:02:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9D746B008A; Wed, 11 Mar 2026 11:02:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B494E6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:02:46 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 35ACD88E0C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:02:46 +0000 (UTC)
X-FDA: 84534099132.05.FC98666
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4AD2214000E
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:02:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Y9yMLl6K;
	spf=pass (imf23.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773241364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cXQ57kKM6BGHnOjMhBIqOh965QFWXPvn5ljLxWRi0mg=;
	b=Sdp8KPMes+pzYp2EZeawwYAwS9NBoG763dZfg0WvE9KuwdvcB3U818CZxY64xeOS8rFM3l
	/aOlgUAeQx4SuoFPEGVHR3TsSSnvzvM0RdiLPq9sHmlubZqE/QbwqwNMsAX5RoBP3C5HLC
	gOCZPYW7mmxwZJSfbOeSjcj527Vzrno=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773241364; a=rsa-sha256;
	cv=none;
	b=OO260okrywc3FTmBGoaXB22QAa/y9PC6V1uM02NWCsLW/osBz37OuFH9ZPfWdQSOvExRCv
	og/VflWR9SSiBfKjIoJnr1voo0k8tQ8575O0u1MCFhai9wjn1zy2+6LYSNBL0pvvghn/k2
	WVXOcUGbTOTx6QFc01lNQzbe6gcyLgo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Y9yMLl6K;
	spf=pass (imf23.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7d75ed779bfso7302a34.2
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773241363; x=1773846163; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cXQ57kKM6BGHnOjMhBIqOh965QFWXPvn5ljLxWRi0mg=;
        b=Y9yMLl6KXYO1VtXKavbxnb4s3ThhDIvDV3z3iuhPDodTetgCj4Yg4OVWi8QxfNT52a
         OhDtpe1drn3ibUJOz+pw0Yz91MexPfbp1WgorWb+QWkBQ1D3gxEkNduAex/sJaguoCwx
         bcyPDLcp1JKXxmIaxxYS6QzogFBg92ps3urk5p6pXPOXqpL4ya7lpGzLnhFTA8X+jKUK
         ZsEFAzMEo6e2rrAGtfdVGyuZW3C9LnfYEU4ZB91/neBbj1nQAC79EEdgqR0xJHaT3Hkw
         zokdICJqJgV+G9mRVwbS6VJCgT/a1GdPw/8mIjP7qflhAWZmc2GyQjtdcTj/QyNLa8MC
         LSyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773241363; x=1773846163;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cXQ57kKM6BGHnOjMhBIqOh965QFWXPvn5ljLxWRi0mg=;
        b=OkHzcdoF6gGNQO2s7RflqncOwcuOgPO7iy0P1+duVe/QFkOwL9/Km/WyB2rV2braMi
         6dXHQwBAxOFQPOgi27pm/ocM0GuUpEYNsgQW3mN06hClypNtq87F+P9p+no56RuZv8JV
         q+bPAsbbpOYNg0ogj2fowqvk/uafRGbiVd+H17Y5aRxy+BoLp7BEYXXC6HHiQ3xVY/ww
         1HSGDINkKxrVtedIvwC1BC6oBXQdB7B0piIg4haV7jo6uudlkkvNM/4SVZiyEmOdt8WS
         kWcgP/RoGWGedJUe5gg5Xu8H84UBwPVv8dogKpETH5cGJ4n3mZDN2dfA/c40zVsHvYkq
         ALQw==
X-Forwarded-Encrypted: i=1; AJvYcCWGz9oxOrI8b4MnoVdKt8cOjqH2VP4vsvdJyYDn6sjzVuxZPOwHm+E1rEYgyh8n3cNKjnqMVh0frA==@kvack.org
X-Gm-Message-State: AOJu0Yz2Fmi2Cp8+Q8sS8PIQED7K0k73Z7IeG/Ofyr6H3O6pB2Zpv0XQ
	9BMLm0zM3OjQ8tJ0LemyxTTuLmCRmHKkplqKlR8zFmXRvj2Jnqh1i4sn
X-Gm-Gg: ATEYQzw2RadDV8O0C+q/JiLbGllIaF3XMxtsNSSjE6JVVnwzZD92Ah6evNYprHgD2PO
	IRP29dwFhMwa9AqAIvHT+4LrK/57rbWXclr8Bpdeiolk3gomWVn8rkfEQB1VFFj3EVWKlPiMj9Y
	UMHdAPXsBMZ/Yk4Q+vnsOyFxJWmk7o1XPmQaNDrMPyFnInJK1oGmRDbqn3tILcR8eQ/adywU1Uq
	yEe4SiHndtqUDZzuksyVHlC6YY0qaKNPEiHe36hNR84u+0sfSxQIz9alkv2ZiQR9fMBtvFStZjE
	/GtQwVmSPq1ksa5mJX+ox5zsJH9my7EMyfVyTzmNPJ5z/ZCfiAqv9hSqP2ZJBrpVDcoOMzUPq4T
	DAW/QBR/PkJv+DW3Ub/El1rAaWEDj4B79fFqTaBFGe5VzUF69G3DMr4iYn911PKr9/81EZXZy+t
	Agqgh25Gzl/W6g7Z8T0kjJjw==
X-Received: by 2002:a05:6830:91c:b0:7d1:93e7:cd6f with SMTP id 46e09a7af769-7d76a77354bmr1856158a34.13.1773241363016;
        Wed, 11 Mar 2026 08:02:43 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:70::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d76ac8975csm2026328a34.8.2026.03.11.08.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 08:02:42 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: akpm@linux-foundation.org,
	alexghiti@kernel.org,
	kernel-team@meta.com,
	akinobu.mita@gmail.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	gourry@gourry.net,
	apopple@nvidia.com,
	byungchul@sk.com,
	joshua.hahnjy@gmail.com,
	matthew.brost@intel.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] mm: Rename node_get_allowed_targets() to make it more explicit
Date: Wed, 11 Mar 2026 08:02:40 -0700
Message-ID: <20260311150241.2579851-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260311110314.237315-3-alex@ghiti.fr>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: jqy6mwpjnen81ognydy1j8ey8fumpis8
X-Rspamd-Queue-Id: 4AD2214000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1773241364-13577
X-HE-Meta: U2FsdGVkX1/b2wILWKAjM0O58cBt9l1Rn4ehI0q7dLuWQxSZpcNSRUO8Z6LEVoW6mQ9ZEIEBzayG32wygQ3N/PIDcDdkInRxfk6JJYYn2GAtjjFE5pztv9RTu1yvxz3zDw3mP+2PftjZ+Gr++Y0OtruIV5L0snw2jpUOSwUV6/Begogwe4mn9+8eR23DzDwE7sIzX/tSS38faYy9/euPKdHWod/TTm/M+9jVvoAGFSVpvtZf4UnbjMHUT28ppXdFvxW39+uuuuCCB0UuyxShM59amkM5C8u3O73DJ6TpW0TXaPqzQa69AZow09MPbUVyNU9au+jhL1ooImUOo0BMj5lZN4umH6qSAbnp8kWIu0AneAWjkJ+/KdTJdqU/RH0yOr28DUm0V2Dotbx9x6HK0yeIbtkhyNim3lua+vrgWzqPmllnIAqEaDUV+MswArZn6MSoH8UeG6B+fjAGH1c3wvcR1KFmffm8Jszp9m8zA3d8BQxY/+5/0uy5BJDpjqEPd0qPBI845eTpPmbjt8NDsih1f5zrka/z20VeI3YRc9sq3/QmFAp0TASRZuoKpUe5YldlEfO/7rXeG03JD9crNNNYenXUkNOZcmeUzqidyPHDQSkIck+weCqSLEReh92UvhLKkzWylH40/YP+LmqAPYdHKWIz5n1D0WXyZ76QCjP97aXabMfh8HWffsKkzRFOLqzB9QysWBnCZgYB0vmGEMm7NHdIgDDcybbjThgHKqlcIO9qc4eY6P/4/n+MA1q0n85Qy1YuA6giRGvRqq7q90bA/4VttS5OAuqmLBKkItODy84K0lrBb3Rmcoc/LHfzYRoDogfHOfmvlufEBGyu9/6Q6pnbc5/xPOrqLtSHErBbrQ9tB3XgtNufzQbzRm2N4VcCY68eThgNH1oV6RP+GwmwHJQ/lzfAYhIbuGalnrjawBQyrlXvMu6gxHT7Eh4OYZdOXFurklGocAVaJ/6
 kjwInSDf
 8yCkmJJPC9JO35wt2H+7TRDwpPWDVQml3IITeaO+HtLXbe7AGHmNds+i9xyhBhI0c5QYzl+TdUGvBGiSfN5vkylDP0Pl8hf8M7XcS0r6PhVz7+7SDD/dkzyB3Ol+wM0TDaVjgexp7lgRbQM0Rs2mjH3QGVtPSv42MGxqlJRc9DAC6wJdVsZbMHiUyC1rWL+Fs6xjxiDh2VffJPbnTtDv27/DvfpbGs8uJ/HKRzBe/esq1c3wSJFK08ImfrPKY3HHdGix3L+MVF3MCPi5NTgtIGY60+lrwZvk2t+zB1+QqJuYE/bDPTfUK4unXhrHSv3FMWdzamS6cvys7/xO0Go2dEZv+2ISKTodY15Es1xt+mcU218peoDwpELHmLrUqscvo0BAOeE2DKU1uKhDrWZsw6oULHmBteJ2zjVi2hAVXRFCyVGD+XwKTUNo0+YuYPlBQRssF4/0XCwhB3w2ZyxNlHSoqyUkq5Vxyr1E4kzJQIl1EPyQyefixfIeSpt5gSBBiGui/Bouj9/4tBAYabsK9lYTX6JhFEN6/TtebXrWjev96fzX/EiYUtAkDFMeKGtl0BwFyJfIh5STzuu3YLct9ZD4Pn5ZmTyCZRSBQ9nyv8G0cM1k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Mar 2026 12:02:41 +0100 Alexandre Ghiti <alex@ghiti.fr> wrote:

> This function actually returns the tier nodes that are targeted during a
> demotion, so rename it to be more explicit.
> 
> No functional change intended.

Agreed, node_get_allowed_targets is pretty vague ; -)

I do think that node_get_allowed_demotion_targets could be considered
a bit too long, but I don't think it's called in too many places where
there would be more than just this function call in the line so LGTM!

Please feel free to add my review tag, have a great day Alexandre!

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
>  include/linux/memory-tiers.h | 6 +++---
>  mm/memory-tiers.c            | 4 ++--
>  mm/vmscan.c                  | 2 +-
>  3 files changed, 6 insertions(+), 6 deletions(-)

