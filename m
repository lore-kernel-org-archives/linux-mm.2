Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA8D2D4335B
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 22:37:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7D756B0005; Thu, 11 Dec 2025 17:37:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2D106B0006; Thu, 11 Dec 2025 17:37:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 942136B0007; Thu, 11 Dec 2025 17:37:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 807BD6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:37:19 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 00D16881AF
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 22:37:18 +0000 (UTC)
X-FDA: 84208652598.23.661FF67
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1460D4000A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 22:37:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ipY/bRwu";
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765492637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KJEGhZja2twCbVG7Aresado6HAIuC1IA3/9dOAgfW6c=;
	b=heDsPu5udczP2CuxDQS+u99GYyEKTrKs6EwXHyz5Tj/5RYivPc7j4TlhblGwR4ob72FXlL
	zZjVw1kYaoN9W3BjBV7J509IcPmQH2cWgwpdkG0Gr1x+bB/5Xy4pBkWVZ4jPJ7mi0E3eUN
	xkU5M7r91/nnTFC7pxEuEuxN6k4M7zc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ipY/bRwu";
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765492637; a=rsa-sha256;
	cv=none;
	b=dQpC6Lx6xUvKF9+3wyI8fh50zWJq+AwXtsSUnLjC5NTFn93AUhrFb89DwFpA85RBbFZaKY
	yg4SM4rGhb2xuBno/d49Blc+Vkki85n4bnopk0YWU3zO1rR1e3L427D+W356gVI6U2RGIX
	az+D5xNcfXhBRINV9DK7UE6F6kJEhlY=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-42fb3801f7eso39767f8f.3
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 14:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765492635; x=1766097435; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KJEGhZja2twCbVG7Aresado6HAIuC1IA3/9dOAgfW6c=;
        b=ipY/bRwu2FlhEo/zmA44hPJ6enJTPQoKbxHp9kVdEAvh/Nn8DMgrVDIItzMSrkoTMW
         BkZl/On2yxP9mQvH94Yp3Bg2hmgOoTQi2z4KBkM7y+Sr4DjlHlVW/1eMEmH0I/L6Jd+4
         Q9si2EU119SrcEHP1w0bktjzPeG22cTdOS4GUwSaVd3xvwW4ERCPeEupHcuqWWEfWBWF
         NpF+NyGpnEIMLoPgRAhGUsPiluhzBxQ3sbowTy0Eq7CrvibwjShNcfPhaoamWUJm3DAJ
         zaUbhbtILtSVv4DJIjhTQBbPBMmXHmxmudGt6cXYAqIgG3KW8bSC5dL87l64P2RDu0SD
         mW6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765492635; x=1766097435;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KJEGhZja2twCbVG7Aresado6HAIuC1IA3/9dOAgfW6c=;
        b=Hk0vyBmGXrt9BIhOT6nvo6Dus0Qkh1xCrYcntjO9R4Tjfh09GTCqkttrYlDXFamqRy
         eWTX0vACDGkzhAaFWTYM6jbRXp1lr0mSgKmrepKb/I/8Fjrk8vZsG9bbYanmyXeuJap3
         ti5e18Dsm2dcS7NDwHZR7eH1MZeJ9iUGEkDsZrxtU4dzkSTYmtocXAln3145gQTWfglQ
         uvnFlmQrfFJ1iIugMnLmmk1TmywDpNBsQMpk1Sgmo8kKaXusNkfNZktRs3CugjnI9wU+
         fdHAFGl1Lr7tZvrSIf2RYKZctjgNFzWJQMPU/87Khad/c6dzsfLoxx2uwocO0sv5ed2a
         EDmw==
X-Forwarded-Encrypted: i=1; AJvYcCVcMrigvkYRUxaC8eEBJ6V4l5NkFj7RrYiSB0GIwd+4XlAkaXOHQxQF0zjb2ak8CEGnTpAKzeqK7w==@kvack.org
X-Gm-Message-State: AOJu0YzZl/OLHlJEi4/thlJHRpc2TtmazNicNLXaz+CBG2SFUpT2QjKX
	2tX4V/U16gvlvdgBdcxzeQmB0jOcGOQ2+2cIGRT2MiD37m4lyXptKqglNdCNYBBqGAwZxG0N3I5
	mBNSaIiSFKuCE4Vzm9RBa5ll0mIa8V6A=
X-Gm-Gg: AY/fxX7B4N5+B5PYhjcdDSon8cO+A8LH4U5orABcKqkvMT0Y0Sq9/it6YALdCrj7vzy
	Fx6y9zqndzWk5EiZZL6GMkYObAYbTAh3hRYOgu9hv2m/vYuGba34HEIOE46yXhHkWIHxyXZ2W6M
	Is3HJLrA78dAmJb7D4aRH9HlMQXfBzUrH8/2KatPE9krdIBvns9WBFX/cRCFsebFXJhBwIZ/CXi
	xK6hSBvlQsArBS16Ub0z+AJ29KuNf191K1T+0keDgrjovie4zoL2UoNr760tWiB+X4eiMU4
X-Google-Smtp-Source: AGHT+IGn3nNzi+SN/Tqq3D++DfH+BZ2ofH6h+ccLn76LVvt5BT9E/B3jzPFlGWReKsZbxv12UN16l0WftogcBd0tMYw=
X-Received: by 2002:a05:6000:2c08:b0:42b:3806:2ba0 with SMTP id
 ffacd0b85a97d-42fa39d94bamr6942297f8f.2.1765492635335; Thu, 11 Dec 2025
 14:37:15 -0800 (PST)
MIME-Version: 1.0
References: <20251211025645.820517-1-hannes@cmpxchg.org>
In-Reply-To: <20251211025645.820517-1-hannes@cmpxchg.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 12 Dec 2025 07:37:03 +0900
X-Gm-Features: AQt7F2oGQPsKVEmj0KPB1g6Fz8AFums3sLf0zB_1Njfd2BPTAWkZaM1Lx47N26A
Message-ID: <CAKEwX=Pq1Chb_0gU53_=Ea0=i6TSH5TJrRnBxLNY1Y=3CHPLSg@mail.gmail.com>
Subject: Re: [PATCH] mm: zswap: delete unused acomp->is_sleepable
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1460D4000A
X-Stat-Signature: oiw65yk3bc1m1pz3eip7qcrw6oc5546r
X-HE-Tag: 1765492636-745908
X-HE-Meta: U2FsdGVkX19L0OkW3393ArzO7GGIhUYVr/S2irlJdVS2b0aLlLlJU8D60eupxPSFfvJx/bkfmQtq4x9vqrycX8Hej33bU7xnwZ8qtXGRpz/8Hzmt1RHn0VSQ+5jUDfB5DWE0GeWlmLu/l42XAAS96hCHLxARLjj5sAxRFUcFCbD2e+zyPp2yX6jisaPSk83lzecjN9s98fVGOPij8oZmEFHcxd8jEQtJ6+DeuhpLjQlTN1PsdOXHAxavXHfzaglmMms8RJF6YgoyTjtpPVJfKObT6GA8GSa8r1VHrF9Udd+NG344Od9Hwa5vmXQwg6JDOOTJftXsoXbzVRHXIqsiD68vLZHrLF8zMj+xECL6w0bgEs1A5PZf9F10p9mO2Onz9WMHX/iTfDEQNjlI/pgWAyjHA0fkEjwxFJkeHTqyyP//rlf0DSOuQjJCFBP0wmmG18a+Ug8O/MZjSIlPYtC0QETqFUqf5eClcIHEKOV1DGz+3eYhuYej7Xq7KUZsb3R5+yVjqxeon62DtmQGVmq0abm4jHwObUztbE+1/aNDJFhMcy20Tip4iFVVsK1RQ/6GGZIQkLVs6HCaecMSGAR3znPCx3+qrEbKMfXCzBzMIyXc8etSwMPL0Em5lHMo/3BhhS/hSyL7nsT2DpTKSWO/ANwdblM6wZCfcuyqjZWQJyEZ4CXu4fRDWgfbB86mpLkakgJgQShX9IB9fgyMXRgdJcJeJi9bYa4CKTK+0i0hPs27foR+0GqyfYWredNrK9ziv5IcO3pV0OJFTBCdiC0n9XRZlC6eY9QKb6MgSA2F6v+4uu1FIbhqtNzeQ9jGRpRQjEBTHizsGj1sviqG8OOZ9WJ/hli30O11tOZMNs5sjAL3KgxkNtYKX2gExOO9RlnqdiRFSAL5/FOexchXCyaYrHfLHBgjdxhD7XIevD3tN2eKkwvRuTvGvfErVF5oDJgV/+EYdmsLYOrS4eWgtU5
 Acvlnm9z
 UEd8vOLZXEj6/CKtwiwVFp+e/qK8arhY5xS1gOc+OUYQq17GAJudIq1EWgjUGkIUIZszoAIxM9gMBA30An5Za8Nlzdrw+D84qLSYfzWQ+c7gs06nc8Tg2ctHIcAtO6y0iZVzQqg2w71/Bd708OpqL+mq4QtgvNKETUiOwzMDx0TkX7B7yurGO3o2Jm0gyyQ9/i3aP9IkKAlgXJS0PGy27MkihgLaZlr8ZgVh5gyERKnuMHdlg315U6NzdxIp5ncXP5s65QUoWpoAdc6Cf8AeYDtHmWxGo4macMt2pPJcFsRAZvmaqsZ4m6dL1luNvLbGDsH71DZqL6HqI5hshpjjy/vzfcZd8Uc4T3p82+05KF85xgMTnnFtWlNz+53QATQklipjEB0BnagUI7C/qY/BzSvslqzMBpTHwzNOTPjVw5w7emoTUdgdQqPLEWb/cQKxx4XgJO/DJdEe2DVR/GndB3wesg4owv1cquss0y2JU/kro2PA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 11, 2025 at 11:56=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.or=
g> wrote:
>
> This hasn't been used since 7d4c9629b74f ("mm: zswap: use object
> read/write APIs instead of object mapping APIs"). Drop it.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Nhat Pham <nphamcs@gmail.com>

