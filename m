Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED736C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 14:49:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BA566B0099; Mon,  4 Aug 2025 10:49:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 692036B009D; Mon,  4 Aug 2025 10:49:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A7F16B009F; Mon,  4 Aug 2025 10:49:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4776A6B0099
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 10:49:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F195D1DCA9A
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 14:49:36 +0000 (UTC)
X-FDA: 83739358752.18.6FE211E
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf09.hostedemail.com (Postfix) with ESMTP id F397E140003
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 14:49:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=milXuC2I;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754318975; a=rsa-sha256;
	cv=none;
	b=llF66WVQOpiCWb4UWsZfpL/AKRbd+s00Sqz3IFeW32n9pjnm3s8Li2TElkb8q7zJXI8gby
	xs0eWgLl/ugJ1Nn1N8gcO1OMl19S4Jkhp6Vm7S5BjQSsepdI3srv/rgFndQ2Yh824sTUqV
	ad3hkDImgL2JKYbLs7HRg27uGxv8VjA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=milXuC2I;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754318975;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=epoP8sq6ZzXGsjqp9Vf5bycC7krezH4J6H9syRshsAI=;
	b=3YHkUJyl/2GKkvoGQppO7A4U512KdS3C6v1man30YJH0a0JY+G2PYtna94w4zJeFokD7rk
	1menJhGyCLI5zBe3uj3LEYcaKOmMY2MzFxFT4gSnLYJwvpNgURMfHR9Q5/R9hrMC1Twodn
	PNAbwbdzI/KuAZlhaAzJF3f1AFUDQLI=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-61553a028dfso4288384a12.0
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 07:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754318973; x=1754923773; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=epoP8sq6ZzXGsjqp9Vf5bycC7krezH4J6H9syRshsAI=;
        b=milXuC2IiLGsoLaJ2mngmgHtT8TdGyWlOrXriW/ozZ/e6Gd/LZnas+73STYrRVNitl
         KvcVuIzlFj4+tNkOHw09jNOy7CWUgWMaW02Jmf6sYUogDvnUtJgmJBtJzh9ZOqW4GiK4
         Dr2CxTld1vmRTf/25lTDrllMCn3a4YCOgRcr3lazDXVy+7TFOg8wukN2YlI7eoESSO8s
         bkCVs+SyYGnIJDhKAcJiWl5bhy8opp5boyhKBhTdNig1CMORtUHHAa1d1jShztISyX39
         Y6vHdJx7/rok4F1myuNgD/fodr8TSUaNRGvRkBX3nDpZNx6UFuQ99o8bdKI1U1IMXDdA
         2KtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754318973; x=1754923773;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=epoP8sq6ZzXGsjqp9Vf5bycC7krezH4J6H9syRshsAI=;
        b=Rk/aWDylO2XNUgUg0kunaP7ndJVI8cCVS+qu0tdhIQWc1OxCfordoDexw6yySCaEZb
         j51nas4L69VTbTLiKkbW5gId7WaxjGYpCTMmDAnhP8+zueNwo/s/PoELBRnSpyEWDXsp
         nkIX0SfAVBIU/DylmgayEy71/E3EtqO4P4/7dPZ650Ivi68vxumo3zsl730138fIfErN
         B4lgZVd9X/silhJsfgysb15rlt6w6+EHqLMX1lGiP2C+pTJ/BJvOobW7Rm6totTXNKei
         U+OJR8XYhMhpeKXoLc8+6vf7KUif8SYE49z3gPLgG/U5ibYo4xTZgwjQGEFjXn5z4quR
         OvKA==
X-Forwarded-Encrypted: i=1; AJvYcCU7lJPpIYWR3K1qj0yODBt7cZWILJsTNBoNmPhedMcnaiwUMmEt0Yx0AwV4zWfBi2NeD6q0iYy52A==@kvack.org
X-Gm-Message-State: AOJu0YyHu9KfwXP4dcgsCyTtwYzmq0ZF/fzDDimU8OOvPUzwX6d5KYa8
	5kX145UPyIuvN675YX5f9llNTzaIonK6LbLacySr1j7J4HvuNwG5MZgh1+HcbOxp
X-Gm-Gg: ASbGnctyZtrqCYykQG2Md03yZ+ZHMt1Bdr1QbDC/+rNLVE56sNedWcmgCz6YF6smtqV
	zbr6iyhMWTY4ijlwLVK8iH1sdmYmbV5oqjCVz4zEHXx8ktP3gTotxcIZYhljHKw8uCr9r2DjnHY
	w+V8WQUd0ZznO051zweOBnJZXO6nIzmTcwx4IXlWR4DIeeNtPZOupO06Hf5nbhOpQcryq3NrXj/
	5ZmoIsi0rKiYI/7fx7JkwbJsbbn1ZL62TksmznP8JkbFkfsz/fkrxRP0mu6fqj9Nzjm54Ofe46+
	sPbSGac+yomlf0/5Y8GbdDx0kulHO5yYojxyj1WBWIbK7DJae91VQoaeWh+VP1GX6JwWXvA+n4N
	v0mQOa3N2sWldOhKFgzzlMg==
X-Google-Smtp-Source: AGHT+IE2ci4iWmrg+FMq6iRk1evDI6e7iUTGKuKN7nRWDwdgN7sB8puNaMWxbs4XMQyR0gfQKmvWoQ==
X-Received: by 2002:aa7:c855:0:b0:615:4146:72c2 with SMTP id 4fb4d7f45d1cf-615e7178341mr6838033a12.31.1754318973213;
        Mon, 04 Aug 2025 07:49:33 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615a8ffb8d7sm7036966a12.47.2025.08.04.07.49.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 Aug 2025 07:49:32 -0700 (PDT)
Date: Mon, 4 Aug 2025 14:49:32 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Qianfeng Rong <rongqianfeng@vivo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	linux-mm@kvack.org, willy@infradead.org
Subject: Re: [PATCH] maple_tree: Remove redundant __GFP_NOWARN
Message-ID: <20250804144932.dv7zhlr75ia6il3r@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250804125657.482109-1-rongqianfeng@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250804125657.482109-1-rongqianfeng@vivo.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F397E140003
X-Stat-Signature: xr11k1ri1a45a4ztzsdw5q3hpi8uena5
X-HE-Tag: 1754318974-717040
X-HE-Meta: U2FsdGVkX1+MJHh5BxCYOLP1dV75HY+1NsCrnOBT8spzoAuySMjjtxSpDzV6JBa1EnbyMMFOxbMCXJ6tKdzgIDGiRG8GshMWbcd+q/8gubGoW7U5+bvyaK2ZoCKWNCH/laPDy+N19NPKnAOjg4craivK4+TWrlVxntSTW1FCAgcyRbnbK8WFqqKu6e/SKPUauL38Nupg9KPnqQi+UADzSJU/tpeirlSGCZcr8eF5DZAa+FqpzD+Wxg4+pWsCRQVB9Hm3I+1Q/H30hKa5iTpygVXGyZN9gUpumvV2Y08qtlJQeBtdHoyzKN/bLgEYAShaTIuKudp3q5tI1TCpbdMgFG4HZkB80StBExQgGudp6S+6ooP2KLR/JLjNFkCVzvMerv7826WFGDZ3w6Pv0hKuJtvkG6lAXR2ElZCZSp9G6u8RKyn4/44FLnLaz6q34yM/stm5nX/JBw4JmgxUnOClhRYDDaJ54oUuTVS0W3fansNXkJ842Hin3gtIWtrgasNKvg4eI5BeRsPZeK58tgdSCOrIlbvtpD9CLKPArMd3F/PyF4wYVas2ji2u5a3DAnPkEP56bA0uqCN6zRCHtWsXBsrREmtVimuYaU3tdy70OuDP6Kx0//jM4zosxx9HLbM/ZjiBNFGoXo0Dmee2awoO8PwwI5VHQris/tJj9U2ZFNcUGQQbjx69TatdXwx3e9kj46KiQQ3ygI9dnyjofv0TS/aVo2gvZsW/+9G8kizWEufKAoPzTv+ujRp/1VbzihvGLnf9hI3gVTRN69Rf/0IwPPMyCKnXb2l92CvBjwQ0DfA0zewrUSs1tuDVkbwiOQ+Nm9++bQuRtJlFztNSFhhAgHm/JZ/V2eY5PDzK78nmHOUNXeUD0kae3774UofmRV334N2sSZReAEQ+eUv3GCGe7VDBeQgizHbtjmHjrkmVOeTJCUNiYb4vIqZnCIX1aUdSKkjfR36g+5rcKKVC6/G
 K55D3qjB
 Iiw+8Rlt5TUCbg0KvQvE+wGXnadrfFtwiwKeb1SYKuvrwVBszZhLmYOGrmtO1xbti+KaZty6USzXglKcZX4VB150SbnnpRwM9Fab9onWN89wbxbLltwC0xeBbqYSDs/xDTgOdwGa8Ft6a/U45zICJhgBQBOLwdRSzUYoB+bdE5pPKfgOovzgLmd06QdAvI2PK1M5j74qLUNgLROIP8bdh788UltfYl2oDdfDFgX4Y4bQdF7pQzB97yFi7iYGfh55zhkbHTT8JvFuNjm8EYPzmXNqgBB7xNX1V0FOyZpHY8UnBM7ANaZb1GeK5tgHAdjq4rv3DJT5DdYtHTHPXcrk8F8q3mH2j4bo350/rltxaAgHV9FdP8OwLfhEWR0V2NZJ0Nh2BXYbcdGibX7wh9rsoQDHC5HKCBXTz7AjbpwWCyV917SQjEwLuUga3QvGgtqYM1Wf0k5I9l6hDFJgSzzjbcputfUsX1xUcYC+qvv9t+MJItJVDpDI2mGp/y0UAteJSYRxV0U0+w38KaN0ct9Gv5FLtSIpmqtuK9yzSyPGf2SiO8NY3Tju7o46mG4TV0uPz2/TI9gXs7O2UpmHZ9QaSQAM3DMe0ZJuerJ2yVTI68crsjOhAVf8lR2ZyXd8P2gUdAxKiuKXk+JyeAmMFypeaSIUBsBxhr5WvRi0SGjjetp++kbhuzDbioEqKIiLREycLy43W997X0a0aGPVZtQd+gOffIPciuARHSS9o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 08:56:57PM +0800, Qianfeng Rong wrote:
>Commit 16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT")
>made GFP_NOWAIT implicitly include __GFP_NOWARN.
>
>Therefore, explicit __GFP_NOWARN combined with GFP_NOWAIT
>(e.g., `GFP_NOWAIT | __GFP_NOWARN`) is now redundant. Let's clean
>up these redundant flags across subsystems.
>
>No functional changes.
>
>Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>

LGTM.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

