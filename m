Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E770CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 19:53:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E07DF6B00CE; Mon, 11 May 2026 15:53:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB88C6B00D0; Mon, 11 May 2026 15:53:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA76A6B00D4; Mon, 11 May 2026 15:53:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B80146B00CE
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:53:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 60870160151
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:53:17 +0000 (UTC)
X-FDA: 84756188034.02.168A36E
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf21.hostedemail.com (Postfix) with ESMTP id 578C71C0005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:53:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mTnVp6Tm;
	spf=pass (imf21.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778529195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZP7FByjj/MPynW/2rM7ALpiB4VnbDXXIxz16fcl4k6A=;
	b=s6qdWGMxptrb6kkzoulOUB8NGnl+2AAv85qgWkDiDBkVQJGj0dmyJNOwki9UF0gL3zLYtc
	uRC/JX23ryCi5KR3GgBcnHoc5YyHLyzD3Ja8JZlmlV4eD4JgMm7XprEwo+4hBkq79JFUc/
	lTgiypbPqDNy/Vj/3hb2U2OZH72tH9c=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mTnVp6Tm;
	spf=pass (imf21.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778529195; a=rsa-sha256;
	cv=pass;
	b=j/IyYbW7GRccFnpb0QHD0YHwiHsSk7ct+D4ga1UeT/CRArFAGijGBtJ0o76kyItsXVhCfj
	rRtGXlDwGg8zGExhqVI5WR2NtBHJeMsx2w+dKkRc7jtrnlKnVtiUL3uuLbzhWubuqRr0VU
	hkhjUxRFnVOytdA+vHqkI+OGfmnZkHQ=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-44e1860558fso3086775f8f.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 12:53:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778529194; cv=none;
        d=google.com; s=arc-20240605;
        b=bsSZ3r8WSxpLSFdrW6HLPdQvfDJmxQ1+kUsGQTPmq64tNLTzJ/0RTGtpzkm22klVRk
         uihpxI9UhW8FwHCniR1nyU/LY7fT0B9hSaujCVax9nkesQRWxCQPl90xGhLu4I1UtveU
         T2oOLH5P3KrwYlmRaLkmtkpMPdzyxk1QKvhBcd30N+D7x9MkpcD+yNZgfKiWguqNt5B7
         efld5mSxCKJmtRne3fwXsu+4vPKR74EgJxoUImm92TRwM0b3sEANIvV0/LptuMqTg7QT
         ACt33glEUJQGmgHXf49+kUmDawHSzLqBqSWCkFPUf1nFJMczX8S2++gtcmTDDmhhrsRR
         LbtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZP7FByjj/MPynW/2rM7ALpiB4VnbDXXIxz16fcl4k6A=;
        fh=NGMZ1Rel761B9qflxIpwftAy9b4DyqkyQm5E3QNbQno=;
        b=a5j6wEoizolsacnQNLAIPOg1jK6XvrseM5c0plPuJF5p+vUIRr98tO1T3ouy/YBbKi
         0LDcfTzU32D/6+tlCUYsmzCm/g37kBQknP+8C4cptuEaMlce8gS3E3zUwEh2JBq6kbJy
         dQMShw/n3PixfmkuLSzkEzYaUrti3DvcLjbFYhHXax41KEbgqoMz9FrswIFdRjhX1P2P
         CiKlv3f/AjCdoNWPfGjOqAmnWBlxjCyiW2mTYqNU33Mltt67oF/4CdDoAmEa1aqbs1vO
         CYexU/w2drC1jrrBwsQ0zZWfRm5s1p8Ow9bX1MQ6ftPsAHTrHoRAq/uhYhK1luYAitA8
         QBkA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778529194; x=1779133994; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZP7FByjj/MPynW/2rM7ALpiB4VnbDXXIxz16fcl4k6A=;
        b=mTnVp6TmfheMCkL8YvG+MnEeGDe6dL26DIUn2PAAb8IyG1lB9pg8BmpJu62J4o+J7e
         tDFLt5zG5Y5GCsBUhH2nKFueIw1eMlgl+hZEOu5rdU9cB+xOcc/NMcBdHomMyz5G+Cex
         vZy/NgD4EAbACKxK9nYkHmLRQDZSwABYwaMoZdc/wki4X2xxUlAvY6Jyy5jgdROTymhe
         EVeT/Xx03JJYUIqzWRmcSUHCfisiPo+b/WCPiXZapKNBLnmHRmxIWxkUTMA/lIOUFmQL
         o4vBmez98SQ3WetbLa0hBu9w3h6/Za565HXCbdYtdXWvvo+6wErGoVsdTkJY5C3nob3/
         4zhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778529194; x=1779133994;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZP7FByjj/MPynW/2rM7ALpiB4VnbDXXIxz16fcl4k6A=;
        b=RUF8TWUZucUNJez1VNUVrZrCRTqEuy67879FyhkHMd43dbdjWIAmjTXcN+/mNxwRNC
         T6x3xFwb2flPAlfFwLLla8MPetLxzQ/3Jd0C5lH/QqYfO/DVey77EHrBBycBQ4+Ffzeh
         AeOtWK5K2EvTkvQo3SQH8Mbhu/IN0VLyVMPNuglrtqvhMpa2/ju4c42nlGgTLAAdO0Qc
         WDh1OvbueY/Mu0NlIYqXbB1Nhx9zipORZY/x1Bm+wWAaqZ4zx58iJB+esfD+Rv35wzC8
         3kM8oXx4AOF9elHx2HYFDr/pQHb+bxs7xRRzRSZFA2u4zdAJuFi+L0l5MX7ltSM0/TRk
         jRYA==
X-Forwarded-Encrypted: i=1; AFNElJ98+nYJzd2ZugW+O7GG+RlV01CJUrZD2XYjk3fQ60sRmH+G2JzXunbXTTo42AkbAWQu9mtx5q7NZg==@kvack.org
X-Gm-Message-State: AOJu0Ywa2U1Hmh13OSHj/ozhmQLWNvWwwSEN7obGRPffGj97xm4W+2qQ
	M2DX8vBAOBP5a8Ja67fGW4Agh7G7thJak+w8cuQc50A5obTH308GsFf5v6cPc+BO3+O0Jv1cWdZ
	mBmX94OfznFSbYZyOiI6adxLzlUi2TLQ=
X-Gm-Gg: Acq92OFNFo1eYXz2ZLNKBqSJupyJs1I3t8dDyQo2mG0XgLnxSIWTC0k2axxbuYJOY1r
	QhxvbmohumNsTMp6Mw2DDqgPtzmOG6qnGpPKKKGkVWpHV2kf9kxSQPISFWVlGE8ATjw6x0NfdKp
	p5OGCqeHCvCsma3lB/gH4lgplk4DSs/qTw7uTIxz4OBd84cJ8qipuAnCqvUsUx7SwzbovZn08j+
	dCId03BrqDIMYKTFogym753LNPtiN5aUyFOjX0U6m1mPISnMGGU4lZBGxvjiqAlY80Ck5i27SIL
	ZyyNbTQBZMaCYBO3ea136/jnbSeituGI3kVFqEg=
X-Received: by 2002:a05:6000:1e46:b0:454:a41f:d082 with SMTP id
 ffacd0b85a97d-454a41fd125mr15238153f8f.3.1778529193707; Mon, 11 May 2026
 12:53:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260511105149.75584-1-jiahao.kernel@gmail.com>
In-Reply-To: <20260511105149.75584-1-jiahao.kernel@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 11 May 2026 12:53:01 -0700
X-Gm-Features: AVHnY4IvNhdPdYI_KTABXX79UzLYn38l9ZW-nKKsalLOW5HyYORSIzprVHs4vdU
Message-ID: <CAKEwX=NqOzcbSyuipFvpPUrBQuB0mLBjoboM=LrijkZAfyamxg@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm/zswap: Implement per-cgroup proactive writeback
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
X-Rspamd-Queue-Id: 578C71C0005
X-Stat-Signature: mkm7imsaj5q1a7aqfr4b9egmeesie8xm
X-HE-Tag: 1778529195-33240
X-HE-Meta: U2FsdGVkX198Vg/lMsLZk5rZoCrA5laV8VxEnpemL4yLQbFNbpkxeR5LVEKM74HBAnhe9z2oYf5ue9OiKMe2Tt8f3IODcA+LoMZ9vYtAqZNZW8fJhWyTEoLumbypPYCmy8ADvv4XvG6bQsuQn80iDpkfKKUMHruBpEUL6pzh/Ci3EYaRqetRXxvzfGrwzQBje9nbRM8liWsx/JNfbySnxEbxYWSp9NV1r2lbh57Rxw6p1T42oKkLUHcnAjPqKTY6pZZG2cyWoB4OoR+FaD5ADS63y2giw/iYUoMarFLQRTouBlmwYdPA7Hh3gDp/lSofYo5VzNf2KE3K51BWzRerMsr4I+SlpZZNusoL8fke8BqO9oRx4iO7ZRPIrYhLYE/17nk2jtkqcv5Pz4ObElnne5YqDdtcD520GpBRWUvPdgbv+6gAf5q0rDsydkDKgt6xoGnwdA4EbOQhiGPP+ojUVtWz4BYzd75yEctwKjlF6RlZu7sP8BaS2or+UPfDx8aDXTcbrOIOXaiTLdoKVGT5qQmYxWW3CH0rHnu6urV+PEWXETmxaGXI3kbVvDD23PxqVxZTU9JHq+nzNqOrxVvFnN5BJiUpS7atXBIq6rlhlXtSoCIhWTYG7+xPBwqU6CaHVUDYtzIaPnP2yIMnG8KYvjUgUmV8MEwjkjecqbg+6c/22Av4XVXVFQ6bNzQdw4v+P4ZlvRaCfu5d7c2iUIY4hh52Y1n3InM1a28R7QdWmhL+6jYyddlCIi4Cqm4yln2Sdb4aAmLL1G/3OmiOaOtgwzNyDNajnVHycLhzyJ4wKgjKbXQeHJ662aEeWPN/yT2RctNE9k1ObE/2bvtmjBqz7zdUU+WobdGZ9SQjU6U6GLoU05rJy1Xxyd5bSCa3PHU9fIEhV4ETwNMXdcvptx2sh/T5Y3Urt8ngrMcfF2d65ue5q6+kJ9uhi1yB1H84MGWA1GtndB/lFx/SAn7flLF
 LYXZmR2H
 VpVqVi6SOmd5eYy89g2xiOhHy/WSKn9pAYUFbgfnItYTpPXuo23M/fjB3m0zg+h0pAD9AJeXFGOUaNKxGCdb9qok7brjird0tbo/1tfhkf2qbevmO5BLSi7fqKLQvX9+Zc46sGlguqAr/faBzFcjmPAoDd5aUhLZM0rvmtEjunzUxbL4tLWhSWoXX2HQzSJwUYdzeMCyJMO+jLPt5dAHZ47JiccCLkJYAebFRxFn1vkvkGtJdyYqNIYEp195ywLtXJeLYhJw9UEgFBlDrttSF7PcAjd79fkJehDsmLHHzGCCTWU5RU9LCEEX9bjyAC0FZulkcSIg+4a8vxhOru0B6G5k2FwvrSHadJE8MjjdulrNjo4r2Gy5Ak293vZNlw6jl05k3AsS8rLj3N7wZ6XrtAqbpjCvEwzZXUqE1qtJEyBs8ZQOfq4nYJAx63CDlWrDUntIN+YtpA6Yfe7rJQfbmAz4SldJJdQ1mkGtmQ7xANUlGlv8L07i1OTdywWDdiBtKWPAs9VPgy3vl391lVWY72GavSOC+FIGsS9Z1vxN4vAQ6GLjzBX7RkDhDPF5lSB3+Anzd0wD9dWE3iPIaC1V5cIFPxOzm8QvaUfGACu0mHHAL1nBrJOIDjjVcuEOdaOuhHc5i
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
> reaching its size limit. However, this reactive approach makes writeback
> timing indeterminate and can disrupt latency-sensitive workloads when
> eviction happens to coincide with a critical execution window.

You can make the same argument about ordinary memory reclaim :) That's
why we have kswapd (asynchronous reclaim ahead of time) and proactive
reclaim solutions (memory.reclaim), which would all target zswap as
well.

>
> Furthermore, in certain scenarios, it is desirable to trigger writeback
> in advance to free up memory. For example, users may want to prepare for
> an upcoming memory-intensive workload by flushing cold memory to the
> backing storage when the system is relatively idle.

Would memory.reclaim not work here? Why are we treating zswap memory
footprint as special here, and spare file and anon?

