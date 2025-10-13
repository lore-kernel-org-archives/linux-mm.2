Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1B67CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 22:19:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 056E88E00AF; Mon, 13 Oct 2025 18:19:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 007B48E00A2; Mon, 13 Oct 2025 18:19:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5FEA8E00AF; Mon, 13 Oct 2025 18:19:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CE1358E00A2
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 18:19:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8779DBA661
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 22:19:33 +0000 (UTC)
X-FDA: 83994508626.17.B62B728
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf16.hostedemail.com (Postfix) with ESMTP id A4A48180008
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 22:19:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OIfNuqhk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of tweek@google.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=tweek@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760393971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ma9v2xT7M3ivg4AIw/Z8J0gsYemmtAoP3TBU7awWAzE=;
	b=Cr0OASa/P4M7vdE0aVQD7LDL5l4K8VfDuAGAHOpYwkKBYE4R2i6KRKwWh7wOmfCN96qzl2
	TGF5K3vDbEspVUJ4MfSUb6Z2TxPG8sZXjLAoW7xVymTngP107w9ZckaqHRKjFORXcbqZpY
	xk2aLhzvw9JsOj68GZBOnQrxnlvGQNU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OIfNuqhk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of tweek@google.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=tweek@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760393971; a=rsa-sha256;
	cv=none;
	b=rE63RHPh8Xt9mw2sNSdtysxA3WEa4AFr0G2R/IHPSe03nwX9wTVkMoCrinpVpkHiHJiyxZ
	g9MRksDfs+Vilz8b1qK7DfdZfZQbn0xRNv0PUnHbx80aBSoOAesk1PmI7bN4hBovONUKyv
	btN4J7TymND7FX+jcUVO1kGy8p6s/YM=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-58b027beea6so15019e87.1
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760393970; x=1760998770; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ma9v2xT7M3ivg4AIw/Z8J0gsYemmtAoP3TBU7awWAzE=;
        b=OIfNuqhkYzUMkhfCxEZ2OdFrVXcpTKplOnMXTKxybhcN1P27i61ngzyzOLf1lX4BdP
         Rd5pfX0kSF/UegX9fBvupYQrj1JqJ10NTaGn0xOrDcE9zHcBIhirHuoupPX5F/lEoZsd
         8A5TqqFQpZzaz8ogyc9EiCqYP9+NxG/vYWNZYTZ7SCjP4li6Plfdw6KokMJGSUqhuhWJ
         u1fe5+rJ1d57EhPvepBKHQkSHSfnUPuBP1NeCiVpWedkaQCoBAcJznFUZX3xJDWS5FRh
         L4fRWgbbNxX0mszSEnofYLSsGpClbQDxKuVApj3SU2WtKY1tXJhIhy7wrrnNPTquSlMd
         tJyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760393970; x=1760998770;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ma9v2xT7M3ivg4AIw/Z8J0gsYemmtAoP3TBU7awWAzE=;
        b=AWj5yrilnx2V8jjVIIE8xIigcXlB8nQ+Hd81nhSjr4vB+HGoHDhKRxNwzUAueAQR+a
         GTVGFoGvrMPfKpuOm9g8i++1mqfIqy7cgGU0/0rToereTupAmkjHcFzxOiSCKw6TMI4B
         mfXYhRduHmlD+yjMjDAwSRO/vB+eX/nBsRIA9CpvG1o1yeSGlQUf6rG2JAbaeiP9t+sP
         lsjqjRN5VnBm7BjuUrX2gi+2ygfA77SklfVKz8HARtig4RGHNZRDSl1fBorACEseGhXd
         CU1XIMSvVeMJpdio3s+7gbhuJX2QoeFinVX8+YRkAkvQ+Hb8Ss8+tBtxhjbViprg+H9J
         r9aQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkJQRhbLFiAgYdGMUf8znw9K12e2jyP/LmGKZToN83W8ex61PW4wUmq6E5KM30fOikLej2LeuiNQ==@kvack.org
X-Gm-Message-State: AOJu0Yya+98M0utDjqZrlN5sk6/3VFQdTssLrIG1jUruYj4/o3ZJ0jHt
	VATWrJyapPpEcuLSw4Feu9Or1DRcswLw7Nwq2UhlpAVZ+Vn1q6rZKwTlrfnIN/1fnLo5k8dT/i/
	surRMExHeQ8Oi7XdsF9VqJU+BJHq2+4g0OnXrZU0C
X-Gm-Gg: ASbGncsPMIsRI1RO9xf1FSEm7byJ8AOkIxdISOb9/QBWSjhWZuhs81859H228R9pYMb
	S1M4riamEjVzdKOMg6fu2kminSz7VwKRXm4QTv1TxwKnCRFvmLlONiSUf8cJcRUh1LSBxjbSuRn
	hyyz5Cf7DRj7IYFfV0UpGE0uechvCgOw/aqhLncHtV6eQ0m2DqFxSIGMuFCoMks705Tn7Jo3328
	/6GD3Ouoip45c0Rh8w88CWEcK4QkxzshIQ8XdoMAfLSNOYNYefe0XDlO/1i
X-Google-Smtp-Source: AGHT+IH2agZQNsxWmqsBYnl3fXe55usQuh642aHhP3MFbn8LGlt2Pg0yylueB2iKG4HwW6byAodCaeXty6oXUuFgH0c=
X-Received: by 2002:a19:5203:0:b0:57b:43e0:ab17 with SMTP id
 2adb3069b0e04-5906e606842mr1391493e87.7.1760393969505; Mon, 13 Oct 2025
 15:19:29 -0700 (PDT)
MIME-Version: 1.0
References: <20250918020434.1612137-1-tweek@google.com> <CAHC9VhSbWJ-8tj5BxSTxznGO8zraKRSE31a+tqdfMHB53ef-MQ@mail.gmail.com>
 <CAEjxPJ5GidA9oT_fbKRe_nH1J3mER0ggM-dBW=Nuo765JDuQKg@mail.gmail.com>
 <CAHC9VhS2TU2GWgfUOHerbfjyxb5QZMSMqLdQirjSdkUohR7opg@mail.gmail.com> <CAHC9VhTSRkP=jNw8bLRx5em6MnX9HTywBqXGsJCBPQ9MKJym=g@mail.gmail.com>
In-Reply-To: <CAHC9VhTSRkP=jNw8bLRx5em6MnX9HTywBqXGsJCBPQ9MKJym=g@mail.gmail.com>
From: =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>
Date: Tue, 14 Oct 2025 09:19:11 +1100
X-Gm-Features: AS18NWA7D3oTpokkkAvP9qlsJ0ghTq_pG4HjoY0XIByf3fPOLCDdAvWcwYRjfTI
Message-ID: <CA+zpnLcUSO5Oum8iq1S_wdhkx+1xhehpTRtxBuaabQVHt-koLA@mail.gmail.com>
Subject: Re: [PATCH v3] memfd,selinux: call security_inode_init_security_anon
To: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>, Hugh Dickins <hughd@google.com>, 
	James Morris <jmorris@namei.org>, Jeff Vander Stoep <jeffv@google.com>, Nick Kralevich <nnk@google.com>, 
	Jeff Xu <jeffxu@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Isaac Manjarres <isaacmanjarres@google.com>, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: A4A48180008
X-Rspamd-Server: rspam03
X-Stat-Signature: cmthtejdxbi1e3s9ho4bb4617ihqoakb
X-HE-Tag: 1760393971-464016
X-HE-Meta: U2FsdGVkX1+S3GEyCJ3DpTjVvp8NW3VHDTckpYnIKI7OGi3469dcLayFCqgXxJDtpmxcMIPHo959sYP7qTQCsCWcMbWc+UNtpBZFEDmjGc2sbBiJKY735SzVO8qkxUOPTE9qu70+/iItF6yZD8a8VshzBT74QCR714s9gFm/CwNnZ4+Jl8A7R4c5CWfgNmeS4IzFn9f20ODMQr/zG9GSCwnJVluQdnhCg2FMO1Oay4Zc/F2ADYO0ak3My/Z5MiMV3nmSJaZIFI8MAzXD+6kwvz0luEtMwN12RdAV6PV1pNqtOtxTvrscl2tzKCBD/QGQwWIc0Bjg+NjnPIwZikV0Qn8sGMWBCFVJvNTBulTPNHmOy68ptAJwqAPMRePO7fampdAuwa1ZHpuWtE88lejgdO1i+1AHFG+a4QvTjAGgsUp4rGUEiJzH/DrdOcUkMIYANUbTE7Cl2FcAEtw6cT3I4Wc6jIAwBepKEH1FsjgBY4M/k1bLj9+nJNKdQmvfqt+N+FKMnykZqPvB18NRDOUhAAnPWejJ2WP8FegffokRtd15tJEn4amU7gDvmBBoCi6E69XKvbPBQO/OVA6JiUDAah/AwMLm54+X4gBFJZbrPgUlwXgbp2QrARz9+jXEH5CikPHnkOrll/44oKa9zT4CEged49E2RWAN2XuQzzHw80LjEipcG13ZFN+L+fPu84yYPK0JZ9L8+SjOKvzZP8IUTLEm9arHzrUbYhpdrNRY7zVdGLXxfF7AHs5CqXu+pNZb2AmHVzrntbq58qGbJ3frthlcCDeo9mpxo5DMh6tcpJQd5VqJ8N3mmlx62OsCja+v1Cq0bLM7WMNtUAMucqc38t5yJvtf9pVHFe7VZNCbUkjo1IHAL2av2Wm3KWV5qpZyEsgTH2+nbabecMvLLFbPW8aWkgiTPwoBqjPkbjnAqO0Pjjkp8Zpu30BJ6OARNjbg1x1Yu/Q6UJHcQZCrvWp
 Gk/MhpRl
 XOKXxCjQaNG+atFCKOEl4jKNxZh+0OCnaMZIVT0UggvH63PpOegrfeiIj5Os4d6Bpf13BgEn8cvB+c7gqqZx4nPjzF7E+nmpPSMHLKpx/xussw1dGBbbgmMr8bI++wDuJRvJpJqdYHq/PPH9r177gLyRFDHUQ4CCKU72BHXrUfkDOQRS4q9x53sxtUMy4SB/JbDEHlpqLrAUJvAjhJO3oQ76SCQSQmew91Lnn4yTwT2swGJ/QLYBfqu4IhDUPZIQhpdOAdKZ8ZMe4FJh3R5DlACNPemK13rZmKMH2Lo2LX4xlADwkhMQ2igq74i/BGM6Zk7cIoW2nAQ+0YIgkG+oL9Z8xYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>
> ... and the patch is now in selinux/dev, thanks everyone!

Great! Thanks again Paul, Stephen and Hugh for the reviews and help to
land this work.

