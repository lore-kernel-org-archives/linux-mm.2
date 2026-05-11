Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 644DECD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 19:49:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63AC16B00CD; Mon, 11 May 2026 15:49:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EBAD6B00CE; Mon, 11 May 2026 15:49:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DA2E6B00D0; Mon, 11 May 2026 15:49:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3909E6B00CD
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:49:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7DB7E1C06EC
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:49:52 +0000 (UTC)
X-FDA: 84756179424.10.0E0D0EB
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf03.hostedemail.com (Postfix) with ESMTP id 83CE120007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:49:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cxOoN4Rc;
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778528990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sLtCkaQgWPkzthxnv5qVsmODrG8dD2rCKuHgHNedMWA=;
	b=itAQSsSxxbIF3wuducTnB16nmOx9kPkpMKZEl5W5NU6BJt2FSNJZ4OaJlZb6PEGA2jDU3A
	y8n2LSshnAQnrxt2ZeJwq441d00/j2Ja0GnEfP8wgJRq5XtexBs9RfvEfIQqdKjVYkRPYv
	IOvl0BHahyYKPSuaYWWRNfPGj2xFVRc=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cxOoN4Rc;
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778528990; a=rsa-sha256;
	cv=pass;
	b=SlOrymAWt0KQ6NGZUIAMSk2QZfeHI/mZ7EyMDcvZGxESx7c62zQfpUweQUDbPrXBw49w4X
	UhWlbUJ797Dn6t8gi5djnosrHsOjst2Rd868mHDncSvcLrxj5bVfHmTUlPAco356+yyY84
	ZcjUgObT3ad8cOBrt7Z7FGv/EibGH/c=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4891e86fabeso55614355e9.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 12:49:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778528989; cv=none;
        d=google.com; s=arc-20240605;
        b=c3hrv9zZkW3+TC0baWq0KYna+VXzVZSyFTogLJuePAuqaBipYM0KBv/cwhlF4/Rb1I
         qRdQheJLziCbBTPfLbyOsa1Ah+lLUZe9Jo95Si43Zu1LCW+ch0idbjSY5/Xs6KGJpf9t
         GjJNAi+G63t6+7PG54xr+vwiyuwa3UzKSPAvzHrLf3IcI0SF5++57X31550kP9NneDx2
         t8d0lnUjpnYVPQ1CUH89cSv6tHAa+JL7Hi7EIeqshjXOUgfYx8DFd2X0qlbpF9bMeqUy
         JKWJD86o9XVSRskRA2FiEeBpx1g3o6ltZlxWi6zSsvf7V2u5BSyEAKnx/voUPrnVzU0T
         6VuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sLtCkaQgWPkzthxnv5qVsmODrG8dD2rCKuHgHNedMWA=;
        fh=g2y9lnKS6r992WzPMreIxDr0PQBGFFALMJSSAUnfl+M=;
        b=iRRQVjAsRXcsf8EIESmxJt/gRVqcWPujf8TeQMyw80ud3mpNwmYT5xxyc7pyWZJezq
         xwinTv9ZuERQQkuSkbDO6CMfijhjF5WErUTe6y5bbUb8L7CKtKy2rWEHBKOfz6THI4zR
         awVzeBjNe6yceZniXvt3a9feBVhHrLsE1ekLFA8A37BrOMeLBYoOH68pyopwwmRWKTok
         KwOU1bCTiT6RTUSYfXr4IsrNddqVMeR0FqgB2FmQL8stpyMO8vDksnUDobiFPVlmrXqW
         BgBR8MgabPGLFBAgoHfpQNvOzU9s2lUSDbsq0lZTIZeKUMfxY5vG37rOfUgH28SFRy9y
         hkjg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778528989; x=1779133789; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sLtCkaQgWPkzthxnv5qVsmODrG8dD2rCKuHgHNedMWA=;
        b=cxOoN4RcvPS9DcNEdYjRfmJASmwI/zwy5Du5qk3fQtXeCSHn5QYqkxpspS4SHIltoZ
         lZ8FTNLrLHvUubNnXDascz4q0+QdnPoSU8cU1mCMpsZxuBopqTvCaD/WpOnmdRciH2oP
         z7u4q+4xgl/s4bCV240Ec8THrO/e0oV4F+ieFFKQokVP74COFyQptslDAQyY135V+rDa
         vZ253abTQ9a91icc+20k3mj0qmnd1SdnOuZ4MYw0/ZNERtQWlnf09H1YON0ceuNF0yjY
         rkAALE50nHjhN4nT1e6N9Qdcgv1x0UKa4fFSvBOXS2Iz8+zhElMkqnb/673c3nBPHars
         h32A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778528989; x=1779133789;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sLtCkaQgWPkzthxnv5qVsmODrG8dD2rCKuHgHNedMWA=;
        b=MKIUzSEWxk/54l/t2hLloVwxdYTYr+ncV+MU5J2WY5zpqQ/Ou1rfoaETpjfJdJX0OM
         ZCZBaaMMDafbgkvjDons4XQwbyCpWucdQtla/OGqYok2zRrmFhzKiGXJyi2cnZfq2ood
         GJe+vmG/y3Aj6pmu9r9IKw1PyEJwwQDPEMjYoCxSkBllgu2Uu5jTFMOMovATQ14i+Qzt
         Wn+Vo7Dv2na1k6/GB2dz7y1qHqx+W4x1GUGe/jQNODq3tV7kftuL8WXrz4tQWV/QWOmj
         L0c+jWf4zAKfKDby9n0nUaLx77XBIJvOncbx5bITouIpdYj54/2ylc5BB3k1+hhppsCK
         up8w==
X-Forwarded-Encrypted: i=1; AFNElJ9QnhurEJe2Y3pLhADghcp6Qaul27vqYXoDhea4rszaN3Vxadcb4gJp4D4qnWUkcjLMy5cwjfwkng==@kvack.org
X-Gm-Message-State: AOJu0YybzzE+uQxghXb66ZrLmD0FFRwE3tD2xVJCx5VJQ9sDIRb1N2mF
	a8ZDV5iekcmQ4eyY/hRy3dZq+W7IPMCB3PG77fLlKW6V50VxqFnEXGOmqfK8jO+qguT6tjbfL4Y
	AVTLTqDd1rtBaoUl2E2bp7ChFBwqEqtE=
X-Gm-Gg: Acq92OERNinJepr0ClIUahxB33n789O7DjN1wrXhTaWNHSjm6g8n/Dtnk+6x8kmEuTo
	vIguk1LLJ/n7RKoYy4YLeHXjFjyh2xTm3HnTRVcaCts7nuSJpmQ97IOHcfOLxM7FRXdJWpScqTN
	OrDgXabFkuyMi1iQnSwq5Z2BX7Mqqmv/AVJuQE0Tnj8kkjkP6aWQ+NIDDdvvkwlyvvhsPl9hu1s
	0FerKn5PEmczIbDb80hV1gA2UqYuFmqQmi1zT+3XASITAFKyVNUL8uzJ4Faz8Fw7bsiNb/kKAHr
	UyL4cVp717tY0BrQ6DSjwy1gTpMWR//oPlegXoA=
X-Received: by 2002:a05:600c:811a:b0:483:7903:c3b1 with SMTP id
 5b1f17b1804b1-48e51f35d0emr397154915e9.20.1778528988744; Mon, 11 May 2026
 12:49:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260511105149.75584-1-jiahao.kernel@gmail.com> <20260511105149.75584-3-jiahao.kernel@gmail.com>
In-Reply-To: <20260511105149.75584-3-jiahao.kernel@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 11 May 2026 12:49:37 -0700
X-Gm-Features: AVHnY4I9GBoH8u6REGeCnHXPx0lUVTypdoFFrsJzoLRc-jRCyv8oiTQYgsYV84I
Message-ID: <CAKEwX=PLFRkfUvZyaYfwBv0QJ-8KAktvZvGA02Hod04H-RsS-Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm/zswap: Implement proactive writeback
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, yosry@kernel.org, mkoutny@suse.com, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 83CE120007
X-Stat-Signature: oy61d8kx3ba5qkgh4htz1q5pcfuagkpa
X-HE-Tag: 1778528990-125843
X-HE-Meta: U2FsdGVkX19E8+Ml5h+Vl+BN4a0U6pOYwd9pLa84DIcojdUOvE6rXroKiP+by4+6/eX92J99RAj4MHwYBDZFaxUIHXCXWiM7s2FZVaU3b2d6Hkp1el0oXLYKzz1JPul1e/0jyggdCkcvSvZl9RqOESt2Oc47hsEnq4AKM8MWmuPuNUxt6GKToyFh8mWBsVqM8SFiTmy2FsOvWG+mQv055NZ6+fFkmMZQuhh2o0gjsaQiyvo0cHau1Lo96ct0v+wikoI9AWvQbE+ZQDpTgAFgUOZ0cWJAQfNleBj8yOvCmb1JXl9m7T7F57qE+eX3HR3u5gOgucuvSMpRVFdhn71gJwf/ncQttgq2czP5dcCVsjr5a7f8HHZWmjXEkShJgBZaCY8qVE/aIiG9hzX2GXd/UayOuRSLXFgMCYEV+WCQrh8h7Tg0ouj62eR61Q1JSj8fgu51hk5UUPRnVsaXwm8eMNt/m47kuKVacwFo9CkXAiTEavjdIkrWfBS8OFYAWQ5ZPex7gcj5qqIvHn0fHgobXQKmX/AUncpfj4Z5XtyW2rEqWn0DglHkC/Yqs5VlFyeOjUlx1ZuSoCBe6WQgqUAVwLBGIRbh2F86HSoRdq2VBFabC7NtowCjnw97gSl9xs3w5Fi3rhGYJw+6pq+ST40cS+mx+LGc1wkjXH1Uba4iColmun6R9efpoECocrtuOaSY4OegGO1ioJNohxVDxFWubSTuV7lrDIrf5m5X/Hp6HuchpZimKuDp6VLmD5ZSp9ZCDfcOi7R55J2hzDPjad5ijkpTqg2NaFUQvxpcqydG00TOyGlPW+Qf02YlqYoMh1zEUctWSIMMMBWBR0S3vuqKVNBWJ/gYFvQPg0yC/ikPq3p1P6p1V78GQ0/NqprYFbiKxk9qUHit5meSEbQ8f3lfjNMzFYbaTCDSJ3UF2L4ya0TY9sIIAiwtAPDOijOfZMXA0dLUnWe8a2jAPO5DMQv
 f7Sbi1Hs
 ffWnEbWfsBNGdTpAak1YGYIu6ptdwR7rLFKS86YbQvE553eKi7wWd5OiI7Ysv5NVoSv1O2qbmZX8q+EiR6LhsxjLmpOxYSJjGpzuk4zYFvLftroxlxqRC0bf+6EmhrLx4MSy6ELtnictpTHLD5WREgdsdWQc7TAfRHoQcKJAfWuSKmVj5C2QBFHu0hmssK+VUWm7iaH20uKI1wE4EVr5nixBTqO/qQDxhSHhgD10hLAGAiz80aW1cgzZ8NBUGXteP36f/wKxa5yzpbpLQvV38NsJUCKuEnoH5dyNf5G57T+KWt6sRget1B+0v4FSoYzi3sSBMkroYH/02xbYAt9vNpvg5e/11b+mNIb9572wQxU+IAEBA8q3H2r8/xxOY1PoBFQp3wgeOcOAHWPGda+GEByJd1pdxAHdEo8gMrC7ekRImcDzRB11CkBuwxJZfLu4i54vqoPCq/D4sNyew2P/+BrOKTd3wJxqnDdBq8ul8g5YJQg5oRWD5xJ3w1VIHps43C490nVeCWeobcanRCGSq3+w6Ex9hp2qS59rI9S31DF5zOIM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 3:52=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.com> w=
rote:
>
> From: Hao Jia <jiahao1@lixiang.com>
>
> Zswap currently writes back pages to backing swap devices reactively,
> triggered either by memory pressure via the shrinker or by the pool
> reaching its size limit. This reactive approach offers no precise
> control over when writeback happens, which can disturb latency-sensitive
> workloads, and it cannot direct writeback at a specific memory cgroup.
> However, there are scenarios where users might want to proactively
> write back cold pages from zswap to the backing swap device, for
> example, to free up memory for other applications or to prepare for
> upcoming memory-intensive workloads.
>
> Therefore, implement a proactive writeback mechanism for zswap by
> adding a new cgroup interface file memory.zswap.proactive_writeback
> within the memory controller.


We already have memory.reclaim, no? Would that not work to create
headroom generally for your use case? Is there a reason why we are
treating zswap memory as special here?

