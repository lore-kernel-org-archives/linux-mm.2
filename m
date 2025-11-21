Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01CFACFA47A
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 07:18:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44AD66B0022; Fri, 21 Nov 2025 02:18:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FB986B0024; Fri, 21 Nov 2025 02:18:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EA516B0029; Fri, 21 Nov 2025 02:18:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1B0A26B0022
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 02:18:28 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AB22BB9AE6
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:18:27 +0000 (UTC)
X-FDA: 84133761054.25.EFA385C
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf11.hostedemail.com (Postfix) with ESMTP id BF9E34000A
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:18:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="JKXoNe/Z";
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763709505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bLVy4PqtSP9d08BCyr5MQS6G9NM16pJbK5CN3ue32T4=;
	b=LdIjZB1G0QPo1vr43wqmmv46Zh3HN1arFqgI3AC/RWkpgkTLO/wNR7Iw3QAQr3ws2ddm5m
	GvWfp4qAzmyUxjDWx3oZfDb6+dO9JvtOzQyySPuaLQYKbfhAofcSBdkIdFBSvwbH97a12v
	mRuIDYrPFmFl8YE1yByTIjtYhJLh43c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="JKXoNe/Z";
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763709505; a=rsa-sha256;
	cv=none;
	b=q8AsZQ5OuzdTp83QJqE33ohmGLrbOlERvFcvmKvn2e5i0vZUBcc7d9I5MOyK+E6ZtjqmjY
	SSBQ4I4TsD2He0I+B5IbSTXngJxnp+XCyYJLIwnuPWUjzePnquS1fd7tb0Dwzp80FQAM6m
	sFTYk6FH8OU7C5PyJpgT6eUAKQpngCs=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2984dfae0acso26967935ad.0
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 23:18:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763709504; x=1764314304; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bLVy4PqtSP9d08BCyr5MQS6G9NM16pJbK5CN3ue32T4=;
        b=JKXoNe/Zpp15UXi/dmbBeAzBo4QibhPmf/jDT2GyN2hIQqsQxlZHsHs+eEYJ6nBkeS
         hvoNQw+TCK0A/Ft+461dP9aBq46bwZru6VjP/JPG16IDCcgKq3KOgVIx0XLMcVcHtwdD
         PNydaNF7oRjelS+Bqtw5nfeIczXOg307Prfgs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763709504; x=1764314304;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bLVy4PqtSP9d08BCyr5MQS6G9NM16pJbK5CN3ue32T4=;
        b=XbL5Ct0gbL97FCYT1xDdONjZZ7Y0OCS96HbkPsyIzU97fpKDeOHEVp2YM6qla5iQrR
         nSyz65rDifTVlB1KJ9h06fcPGt/S+mT36Uo36s9oq0kGuk6Eo7k+hyrUvISSK/JmS2rQ
         J8Mzpr+RwTYCxMY7m7gz6bkNJ4uDZowu7MBIGTrPmaxNqBfWgdm4K5J+5945awL/tjCp
         G0B5XvHmfrYQxY2nGWdv510C7D2ruXHuvFbxjYSbn8hYWHfYNxEGNcoDzSw8+vHVlo0a
         DEPYw9wPhPzIjXCKVBp7VwPbCf0BWJYP8tDieLqw0MkMirWca51K+yKkSynfJaFTkqb3
         V44Q==
X-Forwarded-Encrypted: i=1; AJvYcCUUoYnRFnkcxEHPiIMGegJu4wPJAatyM5+U8erk4ZyC85zaVxhT3Fd20P3QVi9kLqIkCIVbNH7ymA==@kvack.org
X-Gm-Message-State: AOJu0YynAN2T2xJ4WxbrRtXM1160jHwU0CNnYcDcccigKCnJ9ehkm9pm
	OGRMAHNV/l4dO0dzgEOEqSh3ywwvuVmEgIj1gjSXQBhJtHYx8aEaaYrXl+V0/Z29nA==
X-Gm-Gg: ASbGncvwFMGbl/b+SxKZYTiXbdGzkukqfCRh+OV+CVN/7MaYfnTJGer0XTpDPyBOsY2
	LybnvVH4mhIbf8iTVqqft6qQ+ZiGedmFzhgHBnV/hmyWYReBZ4LMQD+xahnAO/SQ+afblKUzriT
	qER62gV/MMUIWQG4f6sE8L80GQFB+2k40wwH6ROcyI0WJ1AhyeyB6lW8qz4lVfFkAAI6F2VIP7b
	Lv+WFgJ2UrODetuF9oIXxihGAqmJjKt5cYi4iPsZrCmWsBGQGscC9Slyo9gkMM5XLiUQopiA/YX
	ybnF8g5z3CVzTqC1IWFilQZRbKp0OTivr3d8VwUKlR2JihhM70mkUtilX4zmD4FLJvNxxOeqsVr
	8rOGvBAIq4oXGWgelOprwDFhcJiBNaER/n96ZRiXZrHZfyBxvogpW+RSKeI/4L5r1I1rid1Vabs
	shqkP2JMEZGlasdw==
X-Google-Smtp-Source: AGHT+IH0iPbPk8WqFVSMBUDAjWKZ19pwNO2jNUWnRPqVPFMVDfJcWBYAmp1qCPR2gPCRKcs7y+CAGw==
X-Received: by 2002:a17:902:e950:b0:295:96bc:8699 with SMTP id d9443c01a7336-29b6bea56bamr22043195ad.20.1763709504342;
        Thu, 20 Nov 2025 23:18:24 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:b321:53f:aff8:76e2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b2a6b22sm46552195ad.86.2025.11.20.23.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 23:18:24 -0800 (PST)
Date: Fri, 21 Nov 2025 16:18:19 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yuwen Chen <ywen.chen@foxmail.com>
Cc: senozhatsky@chromium.org, akpm@linux-foundation.org, 
	bgeffon@google.com, licayy@outlook.com, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, minchan@google.com, minchan@kernel.org, 
	richardycc@google.com
Subject: Re: [RFC PATCHv5 1/6] zram: introduce writeback bio batching
Message-ID: <b4okc36gfk23jbkba5ar7rsrgjvlicgpacf4ms2qpzhhjv6xyg@vgftkihnkx5x>
References: <20251120152126.3126298-2-senozhatsky@chromium.org>
 <tencent_F47110578F73D23CE92FD0AE86A27F6ED507@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_F47110578F73D23CE92FD0AE86A27F6ED507@qq.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BF9E34000A
X-Stat-Signature: ftm6jdx79npgchofkuxmnajnj7siwk7o
X-Rspam-User: 
X-HE-Tag: 1763709505-96156
X-HE-Meta: U2FsdGVkX1+gD+JcER9NWKJ14/dffLMnqx5kFitJX5QWje+NILR6R+wKxHbEem1F7aG95e+60DTvhnRWGWQyS2hXeWFo8rB+QrHNwrJ09+vcVNhNC9sYETFbt0vbJ4QoIFm8zpwhdSCA/MkQsvWMWuVL+RLqlnO1YAqbSS3EUm0Z94j/Qoc5qOd3XoV4Y7mpwTMiRmn+MWJziwGoJ+JL4glLp+5po7FIRTqeWh/KCGoPI2sr5p3XSHbBpZT2RJ7E4bwXkRbs5q/8JqtaXEvNY3YYN7m3zpn0fQ2vkMCVv361hvneBCJWbRM4ssu+zWC5zMvhBOn3/X2Z4PfzNSyOXCcPq98WUidSAEzB81Dj62L8Yf9dCxrQODUQ8ftwCnGjkBQUzRkOcSCmmDORVAOFDRDvtqKLMtmXEA6NrZyfZjptzYXfxjFbr1Em8bLdpxOgzEMGVpSL9HyK9zSb2RJdq8LNU5jEpwnpMIM+rnyjuyGGUEyL10ucvqCgtF/Jy2r8WBb9yYyfGFxUHq8araKWPqSd3Acxi0+rXzMX6Wj0I6uBAEl6S+ljYmd5iMMcnKk1EgAAZtAXEtszYqHXLY/7dR3F9yC14cRqa0N817/kAA/N+0C2m4rpT0eYL9w6XlxQy2XCToSY0rMQptMNjE/efyAzEnof9j7vLqrosv4Tg6kTRu8BoE9OWlr0+1R27k8+zgwnNMCo+iajyTV7ovgGu7XlASzB1ysVKQj3bFE6BECfRKO95iBQ4NG7rgTPraPuP/vrBMNcXsJH9vJNEHGmPmTKcqxNsescSeCF4Jgsgni9rzQPU548Mq2Obls5ePJprqEo5G6rXl0lHm0ZkzGFUpAgwAbG0uAEN0ppl9EM5RJsZhsqOi5sgGwPKDbUUm4ncY29QEleFMQ/ZgLrrdDORABRuZPm4O4PPnyfkIuKX7tPcUMBJBJQmRRlOoevrSM1l4XNbSx2iJbZu65L6Mw
 3nxvISMJ
 zLZnJt7lir5VqtF0Z1g2stFDNSudlE7mWxUqXdsTpGxtKCPQyV2ogD2yo92D01L2JZ6B5wNkQJ5BsmHf0bOcyxV3k1m1Zq+07qslxJjPe62MA4k0zEOfjinJXwmtEtNJ4csrOnnR6tmm9NpLewoEVDDi/2RqECxaG0KpuKnNWqfv9ennPZ9FmGbVOtmWiWVz4SGMh0QiJd4xhoQE4fNoCRmdbV1zjgP4hn5vM33f3XPDHN7BdO2WT5tuWX9HBZ3xx4T7opKrP51IqBij/E+VWSx5A0mB1QtPttDbUBbhWzNbeO0b8VFsRe+aa1aE9B1idfl5r8leplC8fkDwznM6egK7UN9gFuxJ2xAzdJP5KiI2KD3uVFkg/+6ocxsRXo6ABNDVbKGvPdB/USS6igW6CHSq4SADPlgMcUbZA3U63i/OXJPs9n+BTCGGJwg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/21 15:05), Yuwen Chen wrote:
> On Fri, 21 Nov 2025 00:21:21 +0900, Sergey Senozhatsky wrote:
> > Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> > Co-developed-by: Yuwen Chen <ywen.chen@foxmail.com>
> > Co-developed-by: Richard Chang <richardycc@google.com>
> > Suggested-by: Minchan Kim <minchan@google.com>
> 
> I rarely participate in community discussions and I'm not familiar
> with the processes here! I hope the community can be more friendly
> to new members. Indeed, you wrote that patch all by yourself.

I apologise if I was "unfriendly" to you in any way, that was not
my intention.

