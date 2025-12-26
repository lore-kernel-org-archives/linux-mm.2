Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F0A6E8FDBA
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 21:42:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCF336B0005; Fri, 26 Dec 2025 16:42:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B529D6B0089; Fri, 26 Dec 2025 16:42:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A35EC6B008A; Fri, 26 Dec 2025 16:42:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8E5716B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 16:42:29 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2DF4F5969D
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 21:42:29 +0000 (UTC)
X-FDA: 84262946418.26.073A450
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id 58FB4140006
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 21:42:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CXsBrtnZ;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of fvdl@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=fvdl@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766785346; a=rsa-sha256;
	cv=pass;
	b=6RA3aUzS5aSIb6tXOYhAS+wWU0oi3HEEuTPrmlBy3aXXNfjKtQMdwdn76Nwpix3QAY+u4H
	2i3nVAaPCuY6tT+rUlxKZFIN7SgzlEgTw6BuIHt2Q98ZLSH+E0X/vHI50hwEiRAVwOgQnK
	+c3rc0RdTHo3ZszuDwRPigOh7D+lGYk=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CXsBrtnZ;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of fvdl@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=fvdl@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766785346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6WR2F1ZrePTcmnHV9KEqowqd6aapnTiuDv43ltA8jmY=;
	b=gBuITDXE2r32acjklQpdtidFvaB7CXtmoe9E3D4CvIQ/VlJBuwi0LUgy/Yvs5AYL1V6zSI
	z2s0K0jLyxURQzCHuXUzw2YYADQ0BE9WcskRP8tzwi3w6yJrAFEj+aKE27Nvl1I3FXAUap
	Tuz3lEZ42PtWbfYkWTpTiHbCukPH8lk=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4f34f257a1bso2507741cf.0
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 13:42:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1766785345; cv=none;
        d=google.com; s=arc-20240605;
        b=hNCTPiXTbC/69YjWyq+Fv6ANAm+sDy2PYcdPWVNOZCT/w8GHIGTHaKh+rVWRUaeVxc
         Wb4zcWBeYg0hsicr+f/OHAQlQbRQh2G3pbF22E1jGn/vRefRpDawD8LQrnsFlcH/DFdL
         Y1VW0V8UGcRsRvp+GHVHYKmosbnTo+fJrQf6v0LOKMBhySY2ArMGCCzqYT3uZkYoFt9p
         zOBk1QoPW1/WSRob8RyhLUPdX9aJ4vxNVRKM20YUiDC+XIRI2kmPYAXHxeOZEUKrSRrM
         7bunF05h+/0Xhx3IJ4ke4IieNCn06LSA2O3YtfoA4sueiDZWNuzif5CVlRKfpaUFcZDb
         NWhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=6WR2F1ZrePTcmnHV9KEqowqd6aapnTiuDv43ltA8jmY=;
        fh=fjCMyd9Z9llhUDW9oQVvPcXXp7G4rWMUKZ4hHfc5bjs=;
        b=cNI9qwQYRLuiy3bFMDEnKFlTUFrx2eIzm3rLWxBK66ej7h5yCNAFg9mzJnheRhW6e8
         LiE4V2Sp61xPQA2vlxiqpDez4OpXeUr0Otb7r+l6DN07ITIx3zGIoT9RYKR6/IEt9j9G
         Y1v7IXX7v5jt813ucBQ1ExLQNg1Z5Oj5s9Rk3kXcvF1g27ApPUJG+pOp2umcjAMa6GCI
         f4gHp/jBysLDRdqP/hGhmEC9tIcjIJQNSADqbk4hXFR1o398Wl+MRi7AUOBU2nDYHgTl
         3X69rP8lEvAqT+2CbfAGlFG52fisMfoV8z0WVZE21aV7WtElolj20jnmjLE9MsQCDCLZ
         fbFw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766785345; x=1767390145; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6WR2F1ZrePTcmnHV9KEqowqd6aapnTiuDv43ltA8jmY=;
        b=CXsBrtnZZh3GQq5oznc5EvWetam8sBa2o7lMojZKr5ZeDoHhfOjAWVofYC5GgUhsLo
         xXk2KLGEqFWEgD2nS37Jqv/fajY0QwH3MJABGYzR50JUmdUMgRshZxfHXsPcqjKSPZ2f
         aUneKWywE49KOaInZU3BI3UmTZNx5aarSEL+NaOmttaP4gPFmKqCZ7pEffDXxhE7ABV4
         ZAY5/kMyPKob4smaeNMNR4016FkBsCyvlohY6Aa59PyTBKeiTk75+77Da+JYxfhFRsKq
         07gb7qs+/aJ18KOIDoFegT1E/3qH2swaj1q9m7fWxPO9TQD3qOetB3Hasoy59Hptg/N7
         Jogw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766785345; x=1767390145;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6WR2F1ZrePTcmnHV9KEqowqd6aapnTiuDv43ltA8jmY=;
        b=kOqxZ07n3wC1jVTezIQTejqkAV1yk9sxfWSd853L9WmZMBdH5X5A7oPsFNc9hpNxuw
         nhm9nNgDhOrGLUiEdfcyxKruRDbmVBnT2mSUBTcfSaL6gKIvDshC9h1bHCQaWNJR+kBS
         nPniE8lTPacQG3mjYAfH21gnx7WKEvlGmOzpOne3OzZkKlDIEav6eb6SGrRm2EeY6EyJ
         rS/jvW/t6lWcIpk27iGgvVK5GomEivArRgvDN9nMgxlOtYjeSpEZPQZY0J7o6znn3s3T
         A9kO59HP0F0mTudHcfNQVcBebUssRniSriXqQBSiwqhZCvXv9UxovHkp20qBU/LYzgZk
         gwbA==
X-Forwarded-Encrypted: i=1; AJvYcCV9alRtlqP5eHKfi7G1wzzUJHKu5U9Da4WoHQFjEHnlUPqY3ocH1FjJhQ5CSC9rgZiye93s4ZNxHw==@kvack.org
X-Gm-Message-State: AOJu0Yw+/Sc0T2SNRKhNk3/X0Del3Nx93fxnA3TJ9nsVJOQDPZwOJkRy
	D3m3qLKzpPupApup52B7wD+L8G5/9+l2dbRdW3QpJao5q7xigOpnYr3BojC7AMR+0zxWdJjLD+H
	00dBSNvYwhpf65MB/fGVS0L4lutqz/hx8jHA92OsV
X-Gm-Gg: AY/fxX4igk/i3lm2u/XDTDxckOaTiplmFUDJhfrLgK8pTW9TsnFwuSpedHVQci885pb
	crcPhkO5P4hSJ+nlHD+xXmuhirmGwyk7IjNCCtD47tmPehvaoHEixGgYpnl/WaX970WvepZjF31
	a/sJXRPj9IIOWS28hCkjn9vFiw3kOcC4IT5wUfVvNPDOsIAiNz6Vy8B/igweNxhCrqy4S+GMsiU
	8pX78lisQ3+K3xjgYkCz/B+g+D2dzk5PP2Gdu31nDvYq7aba3EoakmpkNwS/p/t++8sI/cMJo1j
	YhiPtw==
X-Google-Smtp-Source: AGHT+IHABcXjU8y8Rwgw7BPceYDvtQCETEIQqoZzekW9+iRfX4/0QmYNXqwveZ7VJ6T29IDzphOTjfD1/EkHQvqYuic=
X-Received: by 2002:ac8:588f:0:b0:4ed:ff79:e679 with SMTP id
 d75a77b69052e-4f4f34012aemr15324141cf.19.1766785344580; Fri, 26 Dec 2025
 13:42:24 -0800 (PST)
MIME-Version: 1.0
References: <20251225082059.1632-1-lizhe.67@bytedance.com> <CAPTztWaiDDvgq1Q-GQjGO75Ujy30qy+m5wQXuFiTPmRLEm3aPw@mail.gmail.com>
In-Reply-To: <CAPTztWaiDDvgq1Q-GQjGO75Ujy30qy+m5wQXuFiTPmRLEm3aPw@mail.gmail.com>
From: Frank van der Linden <fvdl@google.com>
Date: Fri, 26 Dec 2025 13:42:13 -0800
X-Gm-Features: AQt7F2pug0ed-CJl5e_RyFwcPvTckQ20OW9Qv5e-I0tTFpmCtEoYvzqtIjO-up4
Message-ID: <CAPTztWZroGx5AqB-2+EmSnqsCRtRjw5uvrNi_h7=JefZURB6Lw@mail.gmail.com>
Subject: Re: [PATCH 0/8] Introduce a huge-page pre-zeroing mechanism
To: =?UTF-8?B?5p2O5ZaG?= <lizhe.67@bytedance.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 58FB4140006
X-Stat-Signature: yeuy6eykmanb49gfd6gjbrbq851quzf5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766785346-823164
X-HE-Meta: U2FsdGVkX18cJlVg2XqIsgxyhVoX4ed1MzBvO+BnNNcr/umWbigOukNoxg1rjxUmlAG3chyIhG3tkGhbUsrY7EoS5Y+5oWqaA823oDXOpVF0ECVxxj3+A59hplPz36GLk8fDhVFV/N3WR10DpvVWx4VAV9Jqzkc73VnEb3mOy2uskh9Id2fe3Ox5b+GgjqnQqp3UVFs14NcWts4YKnn1RUtypUk+Ole3pyxCnefUaqz+tbDNGFZ6zJKiMe/yZmG+6nXW3dcDivViLmWWKkk5ePZCgg2z0tv1qhiWEs9iLRAk4y9kiTFUCOjysLjWYmyNVF672qpbINXJcw0Hr4aP6pwNVdb1U/KunmLIJ5CESU5UvWuXYvYQwcNFisw05HqaAcs9xc3Tvmxw1oOwfpm2TCl/VU2S+AhF0IEc8WhSp9vtzK1RFRV2wulJ22YjclgVdpQVjVvN+4jPno7e72iA+H+dwNRz1Xc/qC+HyzbMT7iqd6JRREV4eRtJVjfsEE4fWABHCf/RhWVP+Zks76gX48SoPsYZ2OtncsagxYJZCW+ZDR3ASFUR8KYm1O2Q1it99TXtIz96YGbfLpC9NhW5kRW/xabPzT4rB2LiRsTno7QN+ANDLBjEK3hN8T8nGWrJxUM4kLtXhhYW3Z0V5xR3kXyZPudtIjbaZCzGhRehUbEc9BehBO+EAb1VEcI/iL6Hxn/dIyUFvv25N/J2EhuAqdAr4rkSLmnqcDEaRj+Iww96ObWdpG1XMFzmS3jivSDYks8hZwSZbm3QaOeQwm28PPZeEuN96ckZzU0HDdb3MyAQBCCzyqkeShrAxfPassPxqF6iXrtlM5pktMRncrfe+nTqx+NqgoTNAIUb49uSEdgL8FBvW6gseWm97cm1X+nFqc4igD+92iw81uJiQ9OISxdoMCFhQ4JcLt5A0zc8uuJDzjzi6BPJ1Xd9x3Kc5WrpUOZ9BbfxLzM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000016, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Is there any situation where you would write anything else than 'max'
to the new sysfs file? E.g. in which scenarios does it make sense to
*not* pre-zero all freed hugetlb folios? There doesn't seem to be a
point to just doing a certain number. You can't know for sure if the
number you read will remain correct, as it's just a snapshot. So how
would you determine a correct number other than 'max'?

- Frank

