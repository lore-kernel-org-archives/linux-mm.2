Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3FE4CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 09:39:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25C2E8E0019; Tue, 16 Sep 2025 05:39:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20C938E0001; Tue, 16 Sep 2025 05:39:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FBC08E0019; Tue, 16 Sep 2025 05:39:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E81C08E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:39:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8345214095F
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:39:02 +0000 (UTC)
X-FDA: 83894614524.20.F00E200
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf02.hostedemail.com (Postfix) with ESMTP id 993288000A
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:39:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OSEeA2Qm;
	spf=pass (imf02.hostedemail.com: domain of glider@google.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758015540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UMmgtmyqL3pSVlf5uAfBg8YLZnU4eepFksA8tWxfUtY=;
	b=suHb+4K6uG63XdYS/GC4BVy8lBhIzKwYqwS/SIeYa3w/01YxIyPJasQW7Jcqsm+DL+oGiz
	cSpCY0Bzas+iHazwX2l9BHBIOdGAmf8lE7VbijAskfQq4CXEcwnYIh3vIYCPAUdLeLL0f/
	0LpY5e17a7jRAbY9y6rqgmUODpWorKA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758015540; a=rsa-sha256;
	cv=none;
	b=0pe5jtzRdrwcLRa4s+r6ZQAFk/iLGFMBX/TTU3kogRLh/lr6qKNdTGuxuUEMQVoP9brRQH
	SPRL/bQ2xbdvGJUPWOZ7IRR6mLH4cSZwZQPTAJiHxhSh1hftf/GH3kZSPVgSUodHowwiN/
	0LmCJ2VXWuyp0keGwPterH7qMXe6Ggw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OSEeA2Qm;
	spf=pass (imf02.hostedemail.com: domain of glider@google.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-82884bb66d6so277157885a.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 02:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758015540; x=1758620340; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UMmgtmyqL3pSVlf5uAfBg8YLZnU4eepFksA8tWxfUtY=;
        b=OSEeA2QmQ6zjp3MphwiygY4vGmt3zHWi86enJ83WWe/eI0WlrHA6T1nu91orq5Sb4h
         HzzalP/70yFeVm7o9a1Bs0wX86b6dXwWGtz3uCMV6W7CYoHqYbKriLyy9EbjowshUUaR
         PfxAfxr5N7MY++BaGzOnG0ebrp8NdwfkQiylI4zqhf7HIt2qK4ZI2ZJdGWTj97dXJmIy
         AcPmdrFauTN3n6zLDeleWuODMCyd4CCnnwwZmcya20xT946fCa1Gicn6SFs0Xd4FY0+h
         L168+lWAOITvVRoRZ0Ly+Yo0BT0ROPITMyF83r71SbX3xQE61tQl3lzLabAfY9YrL9jd
         nulQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758015540; x=1758620340;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UMmgtmyqL3pSVlf5uAfBg8YLZnU4eepFksA8tWxfUtY=;
        b=rBIvEEid3JD/B3Jcxav1on3vbEM1dcB87JXdX4sJWuhv2Q2K6YlW7An5QZcuvIlP7j
         dlcfvtBBt9t2uFBkowUeEz39gxtaKSILxbO+aHKCv1YXcA6zt0tB1SztVBSj/0Hx/2Ri
         +GaP0pwHl0zWmH/DNFBbbDAQk131UIolAw4bLkQnAt6OrzOKLXJe7WmfMBJqMjQSaR79
         t+be8y5Q6glchO3/TmL9zRG0xU4MrwpBzmGcX66r98/jAdMKEU+7o5A/brf/OmfgjZvD
         UjAVH18dQRdOPUnTe+5XAe9sgL0qTeZ9v3B3E1oadiZYNN8hQhmSt2SOFNwvHnh6GHix
         avqw==
X-Forwarded-Encrypted: i=1; AJvYcCW1RqJX3KgFjzx8DB3ACG3ltDm6licKykQeRaPrtD/YZkuQURE4hnGJwlz3gA3sm/UiBV6GuzTK/A==@kvack.org
X-Gm-Message-State: AOJu0YxHHINoijZ+ufJBXxRHRZe39QhyOxUVevHbqFQ363QIWP6C8Ubm
	YO0RDs1T+FBKz1vCn/kjkekRkJCadNMz9GgfpuVSQ6GEg8GL+1r3SUVN2TF22Aw4iT6ieTFkLjl
	J7fnuW256TA6AfdmOfTgrG5lt7ss/YvY+qpBXcYbg
X-Gm-Gg: ASbGncviRd5EQRlriTdsLtxKL7orUeguBXI6WmVMxNmAy5GsMHJ4U4FaBOFfd3RfTlA
	u6JWuwJp4q31Yq5CPhF6aY0QYZXlYZLS/cIjNZtyxlB+21OGxdJ1n8oq5N+6RtvKeTiv4DF+fGp
	9frbv5bwIUmDOrUvLtqOYI67P6V4ArfQPzh8cuLqyoneLqF0AGAMKYSvB5UXvW97z3nOn/qvapR
	ELeRcrkqT0EOf/65OZomx9iEd6zys8jyDTJhZ7903b+N9eUcVRwCw8=
X-Google-Smtp-Source: AGHT+IGpUtzKURh5f5eNEdht+Fw3FifoSxUl0tHxuZWY/z6ZGb7OmyvobO6UGWMj43Uq8+koYYCVKrSUCM9X3xc1Gas=
X-Received: by 2002:a05:620a:17a8:b0:805:d2df:54b2 with SMTP id
 af79cd13be357-82b9be9cb55mr140912985a.6.1758015539317; Tue, 16 Sep 2025
 02:38:59 -0700 (PDT)
MIME-Version: 1.0
References: <20250916090109.91132-1-ethan.w.s.graham@gmail.com> <20250916090109.91132-11-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250916090109.91132-11-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 16 Sep 2025 11:38:22 +0200
X-Gm-Features: AS18NWDPNjOn1tpd4dh2PjA_D9sETIOVojzQySxiayXszkU2oRRijwgocF7cJt0
Message-ID: <CAG_fn=U-pYHi7R3Bq0zd_n7uzaw1vkL1RM=oyF1Or1Ovx_q1Tw@mail.gmail.com>
Subject: Re: [PATCH v1 10/10] MAINTAINERS: add maintainer information for KFuzzTest
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, andy@kernel.org, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com, 
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, shuah@kernel.org, 
	tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 993288000A
X-Stat-Signature: r46r1ze1hy4s75d4wsq4nprsgofe7189
X-Rspam-User: 
X-HE-Tag: 1758015540-48365
X-HE-Meta: U2FsdGVkX1/CDz8r28hTWsVfQWQsSSe8Xmas0hu2L9NQSe+RrRWM73zKZKZBn+1bCvE2QeSdCMgSneNHBvfA3AmnAtQW6ieXP6OKAbBUWMb+wFmpUZP+bTGXzDtH2IfDfRkpsBWmCz40zRF3TI8dYbrmt3hTNkKZDGg8JMhToEdEFicvvnQrYMhRhFV1eUx5b89Au0W0FclLJtFa+hpIGu8bQ7j36Gcbo9NVl5lCKNSQ464Iqj5lKhtZKnU9t+5qoxpwrC7Sl0VkI+cIxpA5dewKavDiL4u2i04VuXuOtdnhno6AODPdRAIA99SZKVqVLNF06yMWiQlNQSgd9zey98c27D88ufNyeRm73mXt4WOZG+hZ63exHAyotKKECNC98TyJ9G4lsotmWOqnCf8zcWLB2rMwOE0xabzcVsK/FG2VqFGOMQcvp27UdCf1odiRdTQELpYojHAokUcc+gXBBuuWitzFLDK1g+rXETWFqKcy3F3lHfOUNT5+nus0zpJZnzrrnLgW3oCISaHdeyflPYOLbxPhbfB8oZiYZ6RAfh6xBh92LwvHn6Exz/TuxjM4rol82E+0kTcbr1uzcbHP1DB8qTy+gjKSPRym6ByOSvq8dFhmHetHgaxQVIwTk/mnitZJ4abFWh8piZRkdFCFC8jPwiRQpUMwR7dh/BPSwmRejSJ+2KOUgkuaw+lIoDuhHg0QUZlwGaPHsohevAIUGTilDNALmQNfRQTewFJVb/s3rJMLtYV8REgAqovwd3Dr+Qu3maEQcOU9gcFl53CzwnGpfWfHN96idHbKKKxxvvvZUutZ1TwRyayxAJbyWuByyzlnsB5xY5ZDzzCLEswCQ8HeHFukCkZ8ABsis0PaWUGYPfDxG1EWom827yMaIcvLlI16upFt782MEFWXmFQjgGo5RIKu+Qu9HzCbrFi4jy983GejnshcH86wNYQmGUbVpAi/QJU1461wzvHfi26
 i5hnwULb
 4HSGgrgjvdRaT+kaMo6g/WsaVZ6ExwpHlkh0i/wuEuA0RnExTJ3H3gq4eoX5SC6uifYtQsgLdb2yJ0QysIHrfQxdWJbqRWyOTFgzwYRlMF+4JVUR7wwOf7OGiQ8/tDitvoc5rt1o4zjiky29rkr0FCLsDYcXjPYockrkoFaB45yTrgkXr4ssgdPr5ChBZa0gqzP/RuRBVSnQJZpW+NE0xAh41O9E1JGhsL14kofXOSX5BDEB84Vb7/GD+Xo3JFwo3JsTqSDEZt7V1Fo7VNUxcn0n8LrFh6vYHvqqgig75oGHRgjPUVeSRK41D60pmVT9eJYWzSYFEdLAtCfIM62KD+Jw2hZaitGgjU9UTzXz8vS9LSZlzQw2VdneYRi8KK+9Ti+NpsieRpT4COcI1CnOLDbqO0F+B+9zclEhFQgdfKc4r2vI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 11:01=E2=80=AFAM Ethan Graham
<ethan.w.s.graham@gmail.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> Add myself as maintainer and Alexander Potapenko as reviewer for
> KFuzzTest.

This patch is missing your Signed-off-by: tag.

Otherwise:

Acked-by: Alexander Potapenko <glider@google.com>
> ---
>  MAINTAINERS | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6dcfbd11efef..14972e3e9d6a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13641,6 +13641,14 @@ F:     include/linux/kfifo.h
>  F:     lib/kfifo.c
>  F:     samples/kfifo/
>
> +KFUZZTEST
> +M:  Ethan Graham <ethan.w.s.graham@gmail.com>
> +R:  Alexander Potapenko <glider@google.com>
> +F:  include/linux/kfuzztest.h
> +F:  lib/kfuzztest/
> +F:  Documentation/dev-tools/kfuzztest.rst
> +F:  tools/kfuzztest-bridge/
> +
>  KGDB / KDB /debug_core
>  M:     Jason Wessel <jason.wessel@windriver.com>
>  M:     Daniel Thompson <danielt@kernel.org>
> --
> 2.51.0.384.g4c02a37b29-goog
>


--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Liana Sebastian
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg

