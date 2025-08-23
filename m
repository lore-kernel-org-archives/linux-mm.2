Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDEC9CA0EFA
	for <linux-mm@archiver.kernel.org>; Sat, 23 Aug 2025 06:18:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DE736B00CA; Sat, 23 Aug 2025 02:18:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9683B6B00CB; Sat, 23 Aug 2025 02:18:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82FDA6B00CC; Sat, 23 Aug 2025 02:18:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6AC446B00CA
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 02:18:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D8D49B9AAB
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 06:18:28 +0000 (UTC)
X-FDA: 83807017896.22.94EAFCD
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6C2A2A0008
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 06:18:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=OjrDQgMd;
	spf=pass (imf25.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.219.179 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755929907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fe9B4QogL1CNYXei3YboAYYKAny2QBbn+ipsHUDuLLk=;
	b=FXY6brh1WOqC4AB8k+gBCVJdUP/SyLKDK3ilJBUWamUt3IFNxUSDBEP91hz6HTRfXv7xb2
	HMMmpeGIVu/QyaCou3mr4XBtz/2wrtiDmgfNpQhS/nkbLrCFX/V6TDUyN9wwNpUulNHHO8
	5e6ksSvjaD3nKVALMBA3TtXMoPPjrG8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=OjrDQgMd;
	spf=pass (imf25.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.219.179 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755929907; a=rsa-sha256;
	cv=none;
	b=qFB4hBI8l0WsCVJhNwl+L0m+qxYMywORuXCSWBx1p5YRHh2mM2E6h7CBld6koBf/alxp4Z
	0s1Uvs9+wz+kftvMxC051LQMMd79WVJCZn59syLZm4UtpPHg4ZLiEU4yPGwwhkcFUBpPyq
	xFNJJEQ85Pn2YbQuP3Y2aZkEWdK8cqQ=
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-e951bbc14c5so1661477276.1
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 23:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755929904; x=1756534704; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fe9B4QogL1CNYXei3YboAYYKAny2QBbn+ipsHUDuLLk=;
        b=OjrDQgMdNTSgOiK6sScMYq89/PnilLU8+ZgwxRwUq1h1oojm25K5/darliVREzXprC
         miCEFzcA5TNvEpg3c2UevWyMoxZctUfb89aec7Y8cOujIWxG9riL1XHmmt4gs+WnecOT
         v2Q8fFOY5LzHewDUCnfCaM3CDeOuKlpTKaEr27Uk9EK1IA3m1L+dWb4eh/giqrCl/vbM
         +uTRNcXqIKQlL4DdSSeEbFReQNinvyT7VR/NGQUXEWQ7sCup0Wcxmk6ZzlDHuUnXPm6L
         m67x18mow7SCIpFt+/HHycZU6lE2g+ebPg3/P1PakMXGrZ1Xy1RVzqKnobe+It/rxlsv
         3jpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755929904; x=1756534704;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fe9B4QogL1CNYXei3YboAYYKAny2QBbn+ipsHUDuLLk=;
        b=sEfyrsqGxmxaq1lzuk8oU3/7rm/ty9MXQX0FB9qOxNlbiIGfBNgqaa6gV8GuhPrD2K
         j/IGRxfEk8DWffHTQJMw3pYFT9Cf/WN1fcInj2OkMs3YzKiQKeNdLtS8vJTe7PlpN4zP
         w1tbaeYeuMlaWZ3GqKRhLHOny4rGFStjYXjeyzKJVUxZBG4pxGHKeepQcGbLw4fEVoeV
         JPTZRYL2GgjrXhvJNy7EWRHg7Yw1Y1kphOLyyDqPgKPx3Cgq5CYfcdqtyWJ3XIQg+riV
         oLpi/zO8q7Mvu8PeLibT43FJHdBOPtG2jHphLjBMOGoY9T4zhUMCZGTyWwon5Pp8v8ax
         8j5A==
X-Forwarded-Encrypted: i=1; AJvYcCWfCINsvtmQNhHSz9ziyEePOL9S+eoOoOHP+zd/e/+De4zTrbk0WLNZxBSPWceQR3x+hs1yadCJqw==@kvack.org
X-Gm-Message-State: AOJu0YzK58mnz+bxA9fKPYFwWghFwD7XQlJlfhXOnDd7IFnn9ZQeFq8l
	SL2eV0sQqtvzaVt6jBDsnuDoivWVEe5op83nI7wBomUYGJDPFTTNlRoTpW8lrRcWMNpT+POGKpx
	QXOziQQogAgy8ylUdfxN1oRBOA7MZpI077R2X8BDo7g==
X-Gm-Gg: ASbGncvfnJ3jY7Rw2lFIH29oDIcN4s4agDzjWNrAY2eG7rpCqOfxVlzSvbw4s0rAkq7
	doqlShz4wtJU+hkSimOsHW8hZ0AhoGGaSTcrvHIuxhtV1aiygW0OrVgzmYUN2+Jwhcuyva25s4S
	ojWy/6Q24BTxIS35FOvKWbtNZNWzrnCaIdqvA0Gk5VIsRqZiSVf+zgVC1O+OYhlKebSIOJJ7iLw
	eyzMIJJugyi
X-Google-Smtp-Source: AGHT+IF+4VwJabSmHqm1OuJrLC1EunTidnKe7Nj1y/1G8DjRIDBILmH+4G2nb1e4//UM1cfwf01YJ8iFcUXks3HwKOc=
X-Received: by 2002:a05:6902:18c6:b0:e95:2702:6816 with SMTP id
 3f1490d57ef6-e95270268d0mr3510223276.30.1755929904301; Fri, 22 Aug 2025
 23:18:24 -0700 (PDT)
MIME-Version: 1.0
References: <20250820111940.4105766-1-sunjunchao@bytedance.com>
 <20250820111940.4105766-4-sunjunchao@bytedance.com> <aKY2-sTc5qQmdea4@slm.duckdns.org>
 <CAHSKhtf--qn3TH3LFMrwqb-Nng2ABwV2gOX0PyAerd7h612X5Q@mail.gmail.com>
 <aKdQgIvZcVCJWMXl@slm.duckdns.org> <CAHSKhtdhj-AuApc8yw+wDNNHMRH-XNMVD=8G7Mk_=1o2FQASQg@mail.gmail.com>
 <aKds9ZMUTC8VztEt@slm.duckdns.org> <f1ff9656-6633-4a32-ab32-9ee60400b9b0@bytedance.com>
 <aKivUT2fSetErPMJ@slm.duckdns.org>
In-Reply-To: <aKivUT2fSetErPMJ@slm.duckdns.org>
From: Julian Sun <sunjunchao@bytedance.com>
Date: Sat, 23 Aug 2025 14:18:11 +0800
X-Gm-Features: Ac12FXyOfNLp8q4yZni7XXqfZzc-Xc0uBvm0JA-Rlo4tH5dpdniIQM2_tzLTwkk
Message-ID: <CAHSKhtebXWE5m0RcesWe_w2z1Gpqt1n5X0wuE9oD1tX6VxztUg@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] memcg: Don't wait writeback completion
 when release memcg.
To: Tejun Heo <tj@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, axboe@kernel.dk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6C2A2A0008
X-Rspam-User: 
X-Stat-Signature: 95wykenu4fmhxpd45n53zw6r47mpzeaf
X-Rspamd-Server: rspam09
X-HE-Tag: 1755929905-138822
X-HE-Meta: U2FsdGVkX1/fzWrIESnHY+k4oFvCTiEz+vcVenX2DlktYxpFixg7f7RpwK0WRZLZkhdi+IyaLZn5RE7zPBe0uFAD0pand6ymRKYXqMEOG8AkG2rTQn0euPAzTOdk2kjvs34o/tIvpcVhvKQzg3QZdPlQ6tJhPFLDehTxBEYgb3/VpU7b1l37OxcTSVb6BPLLPR/0K4jtAdfunTgNy+j5IPeq1HrDZQM8IaUF3tQ80cGq9fccW4KhomfYQsl6rEQqFyH9WWO2upnadQ1rAGz7w6tRgfZBjTT7ivDjmkj82BF+zPRxL1tsgJXL7yoslbGPKmS0itgZ2W83de//idggcATOeRiXju98CdCq0gQ6PjnGI1Q13PlSlUlE80ooFmcOWgZhIMccUJHSO9mJ4N2n0XxwtFW5vChIcRR9swSM7tPQ16fK3qqZeKrAFywk6fjgFcvVhdd86dnKBOecXwCWxWoiCNR1Fxq+RRLrrIcHrede7wUeolDYZLWcgt+p5seKH1wMstibkYTiBQuXdC37oo9bY1rIxuFMtLfqtEs/yoMvPpEPME3HcMkY+Sx1pYwoBqCUuAFYwKZFJzsG31/oAcjWGPcFdj4V966IFI1uQ/Q9MBn0LMZTLqXOiGjNmI5qFE9om4Koe1SGVyV6BjjCb0vb1MfMc4PRsTRLenHiYro/2MYMcY3FLdTqCPDBuKCp7cu/oJm9RS6u8V6+LjVLNXsGEbYguktZ4Nu0ftb5eoXz+qTBIo0dnlFXCmqP7NfTI4lHoEqJ/4OxXAbhws4QFoq3vje6EUL6tVKNICjF+HJ7t2M7cSYSQDfPNKSAcVQZZ3XMQB0hG2J2p7iEdL53AYoogRlZg0VnsllKUH471zo6uywIK2LBy3BYru8KLrlbWO1wJBnTAnIDyt80rQyUh6er0W9+J82BDtoq2P9KXkVFgN37wM+yXt5w0mnCv0mcfGuM78MzBGfgq/XJgpJ
 1nVFwGok
 JusZz5WVARMBsuZ8wj8J0fSDhc3/tpVP7CU1w3do3QNfQ83PhpiST80ookTqZUOe2cteEjGfu2nb+6dRpDSHDb9OCHILhC+k5p1CZVfBT5E7VaifZ388cEo6JKr3oFpIlrOpwLkcz3hoEJupLR3UOc+y2CReS0OLGhibV8rE6QtAD9vkdChfjUSMgEBSa58iDfZ3otuBN+YRoum4YKUUT4mU5OJ+h25iGdJTvq/CKt+/2jyBYKPD+7IXDwW2QoJeI8I1u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Sat, Aug 23, 2025 at 1:56=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Fri, Aug 22, 2025 at 04:22:09PM +0800, Julian Sun wrote:
> > +struct wb_wait_queue_head {
> > +     wait_queue_head_t waitq;
> > +     wb_wait_wakeup_func_t wb_wakeup_func;
> > +};
>
> wait_queue_head_t itself already allows overriding the wakeup function.
> Please look for init_wait_func() usages in the tree. Hopefully, that shou=
ld
> contain the changes within memcg.

Well... Yes, I checked this function before, but it can't do the same
thing as in the previous email. There are some differences=E2=80=94please
check the code in the last email.

First, let's clarify: the key point here is that if we want to remove
wb_wait_for_completion() and avoid self-freeing, we must not access
"done" in finish_writeback_work(), otherwise it will cause a UAF.
However, init_wait_func() can't achieve this. Of course, I also admit
that the method in the previous email seems a bit odd.

To summarize again, the root causes of the problem here are:
1. When memcg is released, it calls wb_wait_for_completion() to
prevent UAF, which is completely unnecessary=E2=80=94cgwb_frn only needs to
issue wb work and no need to wait writeback finished.
2. The current finish_writeback_work() will definitely dereference
"done", which may lead to UAF.

Essentially, cgwb_frn introduces a new scenario where no wake-up is
needed. Therefore, we just need to make finish_writeback_work() not
dereference "done" and not wake up the waiting thread. However, this
cannot keep the modifications within memcg...

Please correct me if my understanding is incorrect.
>
> Thanks.
>
> --
> tejun


Thanks,
--=20
Julian Sun <sunjunchao@bytedance.com>

