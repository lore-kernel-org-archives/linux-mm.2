Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2E09C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 08:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E224D6B008A; Mon, 27 Jul 2026 04:16:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DABCE6B008C; Mon, 27 Jul 2026 04:16:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C72FE6B0093; Mon, 27 Jul 2026 04:16:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9D0556B008A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 04:16:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3B9DB120673
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:16:52 +0000 (UTC)
X-FDA: 85033850664.29.E8354AB
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4CEFDC0007
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:16:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=V2C9TBE2;
	spf=pass (imf28.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785140210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xyS0tG8v2Hcb4VXfsGP6gPVBE+5XXuuxqiihsyJcIEM=;
	b=1YHO4W19t3W0ydo067k+rT52grBX5t6nPHbyvw1/+OlZlU9J3Wm05r43781YiHPcuEWeZP
	SuoY4G0iO1LJuMxp+azQvdz5hgmSWtBb9mdu9QGRqpO36b6zmnbCz4TVaO53eTQd80gA+r
	djOKPvwlPIQedUU6AOVbwILs01y5apw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785140210;
	b=LbnLa9uLchp0synsqFR3YdlLttbT+puya7ARTmR8H19iWCL/bEzobinFzXTnDHPLeBmBlh
	Mlm0hahat0GsdKXPBQYSPkhx3nVYWMw3KN8eQ63MiY6O6VRSEVYDmIHDNqYZWDGhYWU+og
	/mScYjNSM56/0/DecU/zW3hMh2Ff7DU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=V2C9TBE2;
	spf=pass (imf28.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47f93b2fe4cso1764517f8f.0
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 01:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785140209; x=1785745009; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xyS0tG8v2Hcb4VXfsGP6gPVBE+5XXuuxqiihsyJcIEM=;
        b=V2C9TBE2NnwWO6HL+2SbefsvwCky/kvUWFusVfo8r6r9HId7nu/H2duUWAcKPf8RAW
         bTJk3Y7Rx8HtawBaYjxu779ZTFrtek7F2vjBypgUvURw8aPcVxO0ZAKdWM9zda4Gqz71
         2jz9e/yPwCV0Nv0jx/MrIz9JYW5aLVEjzxKYXan8nmhOv80S4/VOf+fMNVS5tH475eQe
         qQCv1ykKFTWWh8ShcCjAtoHSN3eS7/EpJR22iLYkhReU008RjzxBQSSp2+GxtUcZljzY
         itFQL/aNgu9ELKeuVNuMECzJoUzC+Nu0/uyb4ddq9kkYgOA9nS1+is+HwjA+hggqZJLk
         vcOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785140209; x=1785745009;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xyS0tG8v2Hcb4VXfsGP6gPVBE+5XXuuxqiihsyJcIEM=;
        b=mwlcQcTlRevEriFhNpIoCSOUXRYs9VjzcoXJlLfL2xSj0TADjhR3I4lnlKBGWnZF8w
         NamVt48tcp8SdeRndKtBFpLgLMaVkcKltbszpBO/8nUPRMQJBuU8iZIBnh3GmIiA/zaV
         DR+YZvxf9MCX1qfQPPwsRT60On+NJ4uhX5/aUzTjT9qub3iPOzozyLfpEu3jHMrqZeTZ
         O65JMk54+qK59BXWlFL1YBIU1wRHZgbuRc8hXmeSkb/xpIHS8cviJ8OxDdj+5sqRiDM8
         eoVr18nSuiIjyBz5lS4q55ypSjqTSReAFBaLqsEeNZ7ptSdyoVVGQQWDysWqvqRm95VQ
         ZpKA==
X-Forwarded-Encrypted: i=1; AHgh+RopmTpCZfd4WauJXImhUS3CTt1bEg+Mf1Ut+RHZXnUom+I2T5+pLob4slEowmhZKGcbNdr4lRLUYA==@kvack.org
X-Gm-Message-State: AOJu0Yzng0i/lZ1Fjlg+2eIQExEkT+8OH3+ex+/gITiGGeBJkp5eyZTC
	Db9uYuAz5LXgwxCnBnEA6c1XtNm43v8Es4aD8Zr9FwVcaSCiiCeXawFlBMp7Ob3PtQM=
X-Gm-Gg: AR+sD13BmraMCe77x8ueAF9mmxRYzW8QfyonuVUYL2QNKcJ+MdR4xtdmCxkIqPSc9YB
	BfgBFioXLnupXd6ZZVl1iUzxOY+4HneJ5N8j7alnSODPNI16rpAgkcToVZqnM2fjtesVPaWLywB
	kMr4yc6xYFCr+/ZAp4c4s8qL8NMa4EQafPPrxP8Y3XYE+sWUfl9YKyWi5WgAMaFtFyvuYbIHYC1
	sF0gYZZ9NLUbwamKCK1whHBdxKJGvdNmC1/U7MfWPls2PeRiuLU/feHuo+4OoJmwPdJzUBZf6GL
	g4O/W8LAwtqWrhae3SQHljza+aUvAHZbHS8Uildk/z3PdgonLKmfeHDZkeAFp+ArcvDztGl4wcg
	0s5gALzoISVYIBJ21o966NM9nnVOulHa3zJyolntAeM0eLMl1tPn+V3Gw5bZtWSqzW1lxYqiM7Q
	UdesIQBR2meA==
X-Received: by 2002:a05:600c:1f8f:b0:493:bacb:1341 with SMTP id 5b1f17b1804b1-496b5710e30mr91785715e9.4.1785140208888;
        Mon, 27 Jul 2026 01:16:48 -0700 (PDT)
Received: from localhost (109-81-83-7.rct.o2.cz. [109.81.83.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b52eec24sm196028765e9.3.2026.07.27.01.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 01:16:48 -0700 (PDT)
Date: Mon, 27 Jul 2026 10:16:47 +0200
From: Michal Hocko <mhocko@suse.com>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg: stop reclaim when a limit update is superseded
Message-ID: <amcT75pLmA0hRUm1@tiehlicka>
References: <20260724021805.1234583-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724021805.1234583-1-guopeng.zhang@linux.dev>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4CEFDC0007
X-Stat-Signature: kf5tnye6bdy5kwqwpg1mh1kw9cpb97cy
X-Rspam-User: 
X-HE-Tag: 1785140210-69504
X-HE-Meta: U2FsdGVkX19BM3VK0BYD5yr2yhkNRcaEdjZzpO12Qp90t+3lqUK3J/5IQndLFn7NCYUN3uSefoizYxFgK/3sCy9dvCdtxNjjSyk6AU+AEkdqsNczu1kkksUtjdmQxb08N/6evNFniOuB4svAjn44RF7IVQj7MjnoCkNqLyU0VPifxAYP6pCdADUfkW+X/srYe6kKXaW9/xMPgJwGLBEhCQSWNwpowHmx3eK6qM3FouIgaIoG+06nOMmLK+7YpJONb7blsLsvWjB0zgD0gKYePCi5Nm5DvnSC3JqZsxgKHvEr0KlC/Qy14Za9xdmb0qacPLyqn8DjBYGw5fu4jyUgG1Y1sKCRkvXOTBUncK6EpsqHhQ8myFyr2WOChBIQffNdt3x01wa5dEfAC1J3cQclMDz2NOwF8nWTuoC5cQi+3EkrqHZA2ps0qsgxhx+slWmABOnslueTciOEp6OjLYiQySosJVM8nv+W9QhY2ajZELRYAHMD5XCGQ/0pzRhOuqcbzViT8xGObJmVaW6e4qZNtbCTF5iQRyH56LM85sdUBDz6hJupM8a6yP8j/BohmQIi0gUIV9C1agDZGwosbFypDfiHe0ejnaIeLa4XPPN1LhTcq3bOfhKsu1Madyb+JUgCGAXPdtj2L7K7nz+eKzKJ+QgymWBJDMAqbKgzjmKzwZ4RlBMp4E9mHPmorW6KnEYyxYanqVkIWE0uDMRioT7IXWXrNKqNYQ7IKylJTORf0yyPs+OshwUH8RplizBapMLZEKFh9o7e4r9rkQwxEWBgmCXLWmEYfAbbPsjjifGZbjxqhgjICLg4rVsOmJevr+R4nmcfpwrJaNmIwYEZ45Wo2xwxq5c4NOXM8U4Cw0MF6mPeXXlFQaJhr0/NTpxzJEyxgJMMvFY7z50rGR18HQpcUaQW/Et1sf09CRzXpwkXxJgbAgL61hoCEAS9VaJIfdGvqdkpSxpVwMxgJ1Hp7tC
 KqG4su8M
 OZn0hPsP9ibT1AbIsPikTlWxQZ0E4vdKhE9a6olaYfpQrXFD+1FxkzJqH5O1L9uHNuu8eXlcbNXBYt36nZ3CR8GasoeBqMI8EUkYPUQl8KLTm0OZJrobIijlid9voImJa2V+8A3AKqTX0YAuvzcxFiNA9fBMel4/q0sdi6UE0gsQDb3AH3Suh6HS51V4bVFvxLB+oNqeaXEJk9ohF42SAoK/GdUsw9+GPJklGaFCSqQywQqDpOKDkTchNs3Qat+a6HAqQvXwRjHo/e0IqxDqnABLmxUqiAqQ0k7IM9In9XlalGr/Rs3dwaGHL2erunTrX31VJO7hRjuj5VL1JRZKu7jamkH4UKzaYkPAghUxoQ4L/rAE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 24-07-26 10:18:05, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> kernfs serializes file operations only per open file, so separate open
> files can update the same memory.high or memory.max file concurrently.
> Both handlers store the new limit before synchronous reclaim, but
> continue to use the writer's local target in the reclaim loop. If another
> writer raises or removes the limit, the first writer can continue
> reclaiming toward a stale target.
> 
> For memory.max, this can leave the writer looping indefinitely once
> reclaim retries are exhausted. The OOM path sees sufficient margin under
> the current limit and returns true without killing, while the writer
> still compares usage against its stale target and records another OOM
> event.

The current behavior is deliberate as described in b6e6edcfa4056.
What is an actual problem you are trying to fix?
-- 
Michal Hocko
SUSE Labs

