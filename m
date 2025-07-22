Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 370E5C83F34
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 14:40:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C87926B00B7; Tue, 22 Jul 2025 10:40:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE9DF6B00B8; Tue, 22 Jul 2025 10:40:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD93D6B00B9; Tue, 22 Jul 2025 10:40:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9A49D6B00B7
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:40:43 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 494B958E3D
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:40:43 +0000 (UTC)
X-FDA: 83692161966.21.BA78765
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6B83BC000F
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:40:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=M0iJkhde;
	spf=pass (imf10.hostedemail.com: domain of edumazet@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753195240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4mYD7jOdcf5aFysRdnyjEGsG+qd6blmLlEJCLBef13Y=;
	b=wX08mEJQibrIXENJvQ1ywfl+PtYEUrptyVQWXhrk/rtdK3flmjeAyuEj7kQn8QuHJ/VFiB
	TpPkSCHq00OY0dRwLntZf6IAnOUzbTFlOaqlapwPaMcMU9jXYBruepLx0fxSwNGuiIDGxI
	BKfayMPRDjeSK+xSibAV47mbZbA8D2M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753195240; a=rsa-sha256;
	cv=none;
	b=MAbVy9MBH8dypJ/lWkdM48ek+EHPX/Dde4/+EqBk988DgGBq7APc7CfaLEhIGEQy6tv1Jy
	E2Gdmp3XCyLCtSEIopW/GNWnrYVA269Dof9o5SuPDf9uLzQ+I0xNzFqF6Vj8dPeN1gXjR7
	adaPKFmQZ9Z/nXemmZlVIXyHjv574rU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=M0iJkhde;
	spf=pass (imf10.hostedemail.com: domain of edumazet@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ab60e97cf8so71458451cf.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753195239; x=1753800039; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4mYD7jOdcf5aFysRdnyjEGsG+qd6blmLlEJCLBef13Y=;
        b=M0iJkhdeHsQMoM6psXtYOwelpI9LZhilEd45cIcHXRKHgvhlr68SkAJJtZbECf/MNu
         i+Z65MPFnERQqtTMRacp25HqcUFAnFQbZ+eRAabr1zTh1RPHAxXXpmhlx2JZ+mVLXGoH
         KWTicf685kKvu3Tldkyz6kpg8i0NP+bkIGbxg7pB07DHPQdhBaJwsQJ4M6BSC3ST6EPm
         6ocZxdX+FOmH2spwlO/GJ4i5UObWgW/uaIufvAPXDqyonZ7Wyqkqn1SqY+9O0cYcX4D7
         hiAN7Nltd3IAYK+ogVH9j9Rhku1aPcgoJ+JQoOaASwo+ETUaSsfxOfhTbF+3FA8aStiY
         ubpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753195239; x=1753800039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4mYD7jOdcf5aFysRdnyjEGsG+qd6blmLlEJCLBef13Y=;
        b=heYtW7SMx3Vj9dCM9B/8wlFxq+1KNOvQ2ckoNz1jjGqgy0R9P1BDDsraubU7Zott3D
         gvDdA6xkVJ9VN8u9DDsDP2jIXTF+brtTOMnFU8Hgo4rTQPihwIMnh66EQ1jPcJ/F8b3V
         t/A8i7f4+HxydPfz1kurkQcCSBm5pQlNjxeL4OHu3vccYwzRVDP9WqFRAkwet7TBFsqW
         sw4eePOXZoqos24/4PrUnWuuECLuSwR+GTW34leQkDjnSAj3r2K4E1/QLwIErLcRkYxu
         Q9vy95PQRWPw6eCEIJs5Ea2sXUceWfxEDA4yjqcbfHtCCDzUzUgLQsXn2zLSyVlORrgm
         bEKw==
X-Forwarded-Encrypted: i=1; AJvYcCUfHNh2mf6psV4AssmY5bwFBFJ4JAjnq2PoHeHvVa97X6FCQecwsKtkGXONGkyV+Tgk7Wk5tnWHCQ==@kvack.org
X-Gm-Message-State: AOJu0YyQifBqKgi+S9mY3Qrqwwbq8vJc1UHjWSe3YjE1dhlVzejuQ2d0
	MUMrGq0NQglvW70bPyDfUw4i5asY4NqfPVgIuYRsZKwYXXRrIc5ciI9mdeZKu7jZBCgoAUXZR9n
	WChOxwievR/xdR4TnFLPD4MyyuUQrMCCT3W2ckbMV
X-Gm-Gg: ASbGncv2QdCJBEy8NdBwBB3XE5rxVR6JiLJy+7uUEr6gJMceMEcFaJxjI9pTsFjUTPj
	1m8mQDaQqIfCLzlJAjUl7gIOQOtK4s4vp1KUrpIxdfp94r7tIaXirbyt+3BU6YnjGQkCKXRsnQe
	eqiYTZAsL0EQ34lq0L+jWze0TKIgOR0//tgMYfBcpWBWlxIlEnJVEbXo7E1BYgliKXam0ELNrxe
	bo0qFUM6UeIzp0O
X-Google-Smtp-Source: AGHT+IFZ5x4jrTTIZ/sGd3+42jtNM9vA9GRL20sU2/Os0v7FJS5rj0L8KeTwvfFJmKz+wiHNsfD/xtdlAAVmvq93h24=
X-Received: by 2002:a05:622a:250b:b0:4a9:a90a:7233 with SMTP id
 d75a77b69052e-4ab93c9cf1amr314039221cf.12.1753195239084; Tue, 22 Jul 2025
 07:40:39 -0700 (PDT)
MIME-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com> <20250721203624.3807041-8-kuniyu@google.com>
In-Reply-To: <20250721203624.3807041-8-kuniyu@google.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 22 Jul 2025 07:40:26 -0700
X-Gm-Features: Ac12FXzTeElONnU3WaxKpa2K4YFqUCuJ6KHpalFp0jXckJ9R0eBW0R2J1Duwmhg
Message-ID: <CANn89i+XTkEfrLdJJa88n1YWPapFAc_OY7L0kAPO-z4hsqjHhA@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 07/13] net-memcg: Introduce mem_cgroup_sk_enabled().
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6B83BC000F
X-Stat-Signature: hwm8q4cffqzg8tc9it35uu54yghx1csz
X-Rspam-User: 
X-HE-Tag: 1753195240-175781
X-HE-Meta: U2FsdGVkX19CxRbALSgLtl7buppnP1h3iS3Eb8jEH7Q0q3TzVfEL/blVbYd2o6uiy7DcV2lcysekPDAEnN40CRdiWflE/Blikp4LKVgNrg/8LsOTJwe/oj2ka+8ZzJArZzaUDpCJ/FXd9npLBPacxZEw60hXYvCN1kFqIwbB7K5bh3+3pmYCBFyw6dxW4k+KDQd3upp8Ezbf8YAmzoAVBexBEeLXQrcp9LeTCGw/W0bvsiFuO9YIkAOV6wee5Ls74AeM71GmdHvV5gRf+fSIMei77MdZMQvI6q4FnDJJUQ4r2VTdn7r2RnvUtkRXVsDhijoM07/dYad9Xu86cPlYaR4gvceuYFbB6atqsy/p43pxR7RBAsgnAaPgTLelena03pecf8XMvl3msH+ocXg8HZTi6ASMhiLygdflsrvyeJUar3KPN2kpXJbmJa1d8RYYffIE1jZu/swF4BR3Dlt4Vm11Ko3FovXywzI/+L5LY1jxV0ulCxdgj0Fwzx9T4n/zCrR22vDr63ItqErCufqjSZFDMQEfCBf0q38obK5V8VAdg+3hWnJa3V880Z7SgSaThnawpSXWe3tGsGfSRoH5gLe6KEnA4VKpgBYjdo1sb1F4mwvqFJj0RvXjADLK6Rmc9wd2qsVbgWSIb0uCYrERi39BPxSSsMgJjFtm9BnD1Wf66x5TPDbnCHSnaR0VNgBxkZgdfzR9j5eqe4uaYch4pCc7jgKSeHbSzrQ8G7yhqcaEK2tuSdtzDk355NjiGUcZSLCpqeN0J6rjkDI40nhQBLpsvTs7CKIWivlM5EbU5G8y3Cq/YJ/Z26KmYNkL9yJCS8hnbwDdNUQuPXW4z/HgHVPBM0z7LZFCns2WcJkRVuuOIJRNmj6kWR3M6TjUCl5Xksb11kIcbSOMWfPtI/7fvJTZkqaG0JQi7GXXSd4Y3PFMX/Kq2VTWKMb0w5lQocb5ptUBp/WOQDYy4/m042l
 CVy33bU6
 kbLPm39JEa6BurBL7hK0VH2fRh5ezhQc9ZaOEwGaC3ADaF/2TEIPuBPMlwa4L49rChD6B3dH/4k9ri78GR+csaWEUOP+ofQahAzxiL3480g9bNWbQyFkYdAQESZ5J5nqlIo/j2hgwb+THew+w/hdIZzzt1rxaxUuLt5ULvWJtWD6RHQC7ejU4Xts+g2lbjXzI0F0ct56EeMUJ2iOgdnwKfbSrZg+9cbvaO2O8KNjb6MoF3qyqYLD8guCb1euigmdZsRj67T/M0wEBnxc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 21, 2025 at 1:36=E2=80=AFPM Kuniyuki Iwashima <kuniyu@google.co=
m> wrote:
>
> The socket memcg feature is enabled by a static key and
> only works for non-root cgroup.
>
> We check both conditions in many places.
>
> Let's factorise it as a helper function.
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>

