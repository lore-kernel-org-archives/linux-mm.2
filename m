Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C9FA10AB82F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 23:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFB8D6B00BD; Thu, 26 Mar 2026 19:13:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAC356B00C2; Thu, 26 Mar 2026 19:13:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9AF96B00C3; Thu, 26 Mar 2026 19:13:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A56FA6B00BD
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:13:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3667113C396
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:13:03 +0000 (UTC)
X-FDA: 84589766646.29.7BB51DE
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4083DC0006
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:13:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ExLIWgtl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774566781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jQ71j0XJntFgJwNhav4Ldsylgfk15393wSbfyYOBmK8=;
	b=v5bqvxK1dhFeX1krS68nFC4AmNOSRYfZnL+IyBuHMzCBU4ZlQcUQlNHSdfHs0NcSJF6VDv
	ZPNt/x3T4VzsY5cwFGZcJv8QTTG3Ypnt5bTtwv/qssqSzGbwLTxBiE3Cpv35nm8GtnEeLu
	PVeBmhqyS/VfOsOFIOB2DaIloeeLLjE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774566781; a=rsa-sha256;
	cv=pass;
	b=HzJtD6W0HgfH4RRcl00aJOZALEihyLtHEZ7RetWr8k0M9DCAH8iu9bSp7xF1pRsPSMT0Xs
	PM19FbioJHzfyVnbK/Tct4yUaijGUOgL9Uy5RehTsghNH/RVo8l+PI4rhAMeLo71rlgKBG
	o2CDokiikVNmR1gALAenG3XeP3lQufQ=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ExLIWgtl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5094e1d17d3so14960921cf.3
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:13:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774566780; cv=none;
        d=google.com; s=arc-20240605;
        b=UPySO7eFvpWvcYp/CkAmolw6GCKgpA6hVWb5CyQ8wclxibDa2zCQAyfTlw05gAIFUA
         n52ovF1kcZsRVLfzWcB48TmNWD48qB0Qra4CePYKVmqy14OdyigQWA9YP70Mw74PTQnd
         xrUGGX5y+WeTnxue+Czhg+EGksYpSmfl4BDBlfooplYxH+w5wpgo2dYIrEgN1HBcD43o
         nCnwAcB4du9rhhNnCaK9BvQw+g01DiEZrEuUsci0p+b0mKZL5mKOjnEzSBrUpxkPdhjp
         z1eDNV2AgEYunLs5mmfiisssT3o0xGVNDCTPFbvjqoVoQ5fb6ErjnVNUXB4k/yLNLCm4
         S88A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jQ71j0XJntFgJwNhav4Ldsylgfk15393wSbfyYOBmK8=;
        fh=17hY+THTCAOpsm7yYKHstgebtJgEur3VtwotAjHiVm8=;
        b=eIZUFIbpJqUjIOvtNqwLsLdHuHXUhr1wjwYLfZIQtsMYu5I+kce4w4CEUhGYczGSNl
         ofFexRNFD2c0NWYaA0fuVu3HC5vUNt3wJp3ErhuPR0xRxqwBLzqZkJUNDh1ZaGEBsjWB
         X6Tj5IgE8kPKd89PygO9GjbK2lJ6oft+0EczOKDcvcioqXQXuAO4SY/4iGrj6j5I+wfQ
         A9YfJJ4i0cYr2Xv/tzRdd+5gsCsANixZ14jrU7kXwsVbRYrRKiA0hM69yRPkLPR3x/HY
         S4vpm1LNsuBq75j1J9dZ9LgNEAYPdWCCk45eTMYzFrclubw5Rc7t4ZepuH1CsMKg0Wod
         gl9A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774566780; x=1775171580; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jQ71j0XJntFgJwNhav4Ldsylgfk15393wSbfyYOBmK8=;
        b=ExLIWgtln1b6GJkjqFOiKoV5bqyX29k9n982fAB6hjpgMXvjiToWe1a7WwtLn464Lr
         PHeIhnjmkzifOvBo/ZjKsK3CEFtdN2NwdWsLMyvLFxHyWZhg+K14Uea0vDZDJJIfV1hA
         0nvWqzox8habZeSU8umOAg6VPilUFCtpapbn89U+QzET6V2rgoDv7OTdedC4vlxCep4A
         G41cG70kBNGK6YpXdqnwcHkesKVBTxCJnw+Vlsgzo6lCMnCAdAeJJXr1EF27+aXf2mMI
         2QGsJKcjWnihSQGOiS96ra0ybJlMPrv+uggJGOmfYR33MVKNJmWHeZG4TQwcl4eKUszA
         BO6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774566780; x=1775171580;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jQ71j0XJntFgJwNhav4Ldsylgfk15393wSbfyYOBmK8=;
        b=NCNKNVvnWIg+NtakwBMvhTb+SnmPL4t9VAwPM0Wl4QywHVxwJ2RSKJ0BdVWZxzbDGz
         Q1SsfRYcWvX3gfsjR4YAstPwBw/HpZuVXlv+1Kp4ATE2ZUN9Q8ViXhKqhQ6/tw5q5w0d
         IL0H614iisfkLkDJJI7IemvGDAi0QLB3AFXmC8OL29QZoDpZWkemZ9+/HBZlI/gJr1/l
         V4HbU/S+3ADVvl4m0KPVxpGnLYvDjkMca2PO2JH+5uGHe1+vYBnDJxcwsXwR4iGFZVdN
         dFoO6MR39eraoROjCbhqmgFOIxbEjmtz3rhKAewQz1ybd7SLz8o1XSsLNPgdANZmvt0c
         dDdg==
X-Forwarded-Encrypted: i=1; AJvYcCUoK1v5fqQ8KHmBjRiNM0m5EaSyCPeZu3oHLlA13Eagh8QdDhvsI+Br1vHcSd2OjEJJPLImQrqdXA==@kvack.org
X-Gm-Message-State: AOJu0YwCfcMhsBzSTMM6nkGXEvV+DvcaYcaqhxakk/OQUSFhomsXT4Eg
	IyQYvBw0eSpCIdQ470RPACGJ3YbIQpJn7KCU59hRxGh8QH5U+RYP1xgiS9rc5AcWsPLlzMMlDl/
	3otXa1FpPcWvQqYObumpH2l9ACrBZR/0/nORE4Rc6AQ==
X-Gm-Gg: ATEYQzx11FY9/T2alF7tbWXiOMx2wOZFJHT9DBOZbBX5WQf/296uQ3sT8GnjaAG0I1J
	2DyyGUGC07JXrBGo+fIPDHlwMQCZICQ9gK54dQfuxJNdU0cRRLGUivhEEgiuL6vOIHKCWI4/ZS/
	m5YDwbLiKgKZatvcENysM1eiVTWmFsverUeO2S37EIgHiUu31+TpqMUv6uCM3DXVSVtH7ShNKjf
	hdHvJAy1cFAmQei7bwXzJLkiqFWapaUi1SWVDytz8xBZC2UIX6rDfpxzomd4XU1RpDwDr9aETul
	osZ9QkZ4xiuF/0LxyDOE93oWFWzcFsLvQVBxbGw/uR+Y/TPcInSEtsVzm18HBU4xfISsezsUQA=
	=
X-Received: by 2002:a05:622a:4812:b0:509:31bd:3de4 with SMTP id
 d75a77b69052e-50ba39780fbmr6194181cf.56.1774566779779; Thu, 26 Mar 2026
 16:12:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260326185629.355476-1-ljs@kernel.org>
In-Reply-To: <20260326185629.355476-1-ljs@kernel.org>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 27 Mar 2026 07:12:48 +0800
X-Gm-Features: AQROBzDWtmGuHyTAVLNjdgvosAE-X5FzIYF4Z1xpQcLS_XcNeBXNo16LCUjjHpA
Message-ID: <CAGsJ_4zmveWi1XSr70XbcrjR-wVqwKKTAAES5Gpvo0wp2O=hGw@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: update MGLRU entry to reflect current status
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>, 
	Kalesh Singh <kaleshsingh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4083DC0006
X-Stat-Signature: erbjsdzgmgfcfayc9krcqjt9f6cy3mh1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774566781-938478
X-HE-Meta: U2FsdGVkX19DEZuNTRk+WomBHGHhLhnkII4r71JbmDE1+CH1E48YZD28YMTUMsu+bWyCkxD/JGBoXyOsoaGRXobWiXip3yUiPnR5W/Wrjn8xzNYYwohndSXEX13RSFYLonzWuZvxQ18khQNzZxeYxe0HcKpPZR1uvA+w0MIA/jdlok6OTSUwT8afHHgHgq5KZH1d3R//m/gmcYkOAE6wNOgwEKYjxvCuSPTUHKHet9dlh0KkMJjA47EtGwEsv3Jlsvd6h5Y0WaOAcZ7Jtf7+pJtVBmJYg37oJpuYJ6jA8SkFEmRwniIVD82bgXzs/qPnfYj1vlTIGzzda/VwyGQq4ectWC8dqCjF5CM2wNK9ynsK9+pxtcHcQTu9zgXMeI8i9bqiM9FRxurwhDpnZaa7Z1Y92yxZ7P5Tav58toEkZlL1S/pdwZMosXJ+zrWCMp99PrTw88rp2HdXbvaitHi9eWSmTFNiPT1B+IhYVjS5od+19zzn8hR9PCXM1yIGI4mUwHRmXtsRzuq9CYco2BX3WSoJNiGELsRyqTRBHEI7D30EWu2dZaJi2LoO2fdbQ7AQsZjO6HS276wzyHP8ZBOt8yJWEjHErGGSGJB4P0HihnuYwLlcKkuUIOOxubaBtR0NRuwbr18myiIutcVeD4LrX1z/PF6cqBuEg6J1vlOf1LLNIHY8yGbIHy9l1RFvUBdZyyHfQuDDrHYfmFgb+edbhR+o3glF+jBCCTH8Gp3HtibeAPHFL7SIQ4rUZrMW9p64g4WeBIjuW36yUEkuOTnbSI0v2HF0a2hARsB/EVHP9XQuA9h/vIuk78FMAW/7/xCYtS51Pi1f+xdxXmbFHzD4pxof6bdv/YI1fgeh8+dJmxiToQeltkeRvk6qgMVnMymDQd1ew2RAkxU3RagXm3DYJ3P/7M21bKSQ9Y+5Z4S/A3MoSD0kbRHZOnBXrpu8m3hMMTPZ60POdc+j8Xbhq8s
 /8Kvq466
 7/OrllzkhK+tAYuFLlh/7W++wXeXTS9XqAvJBLGhXFB0YuGLjPxeq4PBlLiEIWyyn+lTy+RVfHOp5INSSMOD1gOdpW+oy7x8nJGyzXdafiI1/3M26Nd+ruzRxTJRSCl0hK9HnDFBWKLrOMQaLyEVvkGLS2y7wWhs3i6/DEzM1l23LT7Lv7/VT7eKIk+GNl7RfHd0NaoaUhnKmUVudc2TEoglz8a++1u/5d4mjmbJKAQNQBi4daCWDAuh9NagkNblQkC946m/rPeOCcvuxBseHrsk0YvDIJJ6Vu8WZdhk4FqgoUnCCq2q2laq9/j1kTN45Bi+vTGizXEry2Zzk1UuHnqIpT0M3JSJRO5foQv0ULa3YL2SKytQa7NxMleGX9vmbS/iLvlef7aJJPx6FD2KO0AYZHBrH/8zFpgtX0FwvMT8UYEk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 2:56=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> We are moving to a far more proactive model of maintainership within mm a=
nd
> thus put a great deal of emphasis on sub-maintainers being active within
> the community both in terms of code contributions and review.
>
> The MGLRU has not had much activity since being added to the kernel and t=
he
> current maintainers who kindly stepped up have unfortunately not been abl=
e
> to contribute a great deal to it for over a year, nor engage all that
> heavily in review.
>
> As a result, and within no negative connotations implied whatsoever, it
> seems appropriate to downgrade the current maintainers to reviewers.
>
> At this time nobody is quite exercising the maintainer role in this area =
of
> the kernel, but there is encouraging activity from a number of people who
> are trusted elsewhere in the kernel, and who have contributed relevant wo=
rk
> or review.
>
> Therefore add further reviewers, and at this stage - to reflect the reali=
ty
> on the ground - we will not have any sub-maintainers listed at all.
>
> Each of the files listed are shared with other sections in MAINTAINERS, s=
o
> this doesn't reduce sub-maintainer coverage.
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Thanks so much for the trust!
I=E2=80=99m glad to work on MGLRU and help drive progress.

Acked-by: Barry Song <baohua@kernel.org>

