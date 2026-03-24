Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48F42F532C2
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 00:06:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B29426B00A8; Mon, 23 Mar 2026 20:06:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD89E6B00AF; Mon, 23 Mar 2026 20:06:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A1586B00B0; Mon, 23 Mar 2026 20:06:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A21C6B00A8
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:06:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 39E1B160DD5
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:06:10 +0000 (UTC)
X-FDA: 84579014100.06.000DE86
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4F35720007
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:06:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X2HD3rX7;
	spf=pass (imf03.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774310768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MaAPKugqDqodvD5nfGMcExHZcfYC5GJ2oq01drG0C6w=;
	b=XiicysHOGcOM4DI1pZpfrF/LZMc0LLMGLz/s7BuleZppme1gWSPSrmOHGlJ18MvBCWeJ0F
	aEI1jpuF4sVHxwR1ovRqYIZzRy8naQccBig4AgfzQSEZmgqwYgv6lFZKwyy7IAUAY+8SR5
	Z0OGrg01Nu6Vnh01ssSUXZpNqIMNl+4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X2HD3rX7;
	spf=pass (imf03.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774310768; a=rsa-sha256;
	cv=none;
	b=uSJJDiC5A2DsFEKe4URjj5eUBJcVg2eYMd4ogRh/3VO4InZ/qIp++yw8zb7wTPj/ZsrsBW
	8KuRtVlH1Fl5ZS0dh4hDAsdTQQ6mu2dA6ieGx+HI5DkTDe5RnCMpP9IzHPQ0oFZRKoXQrC
	666hxafdXfCSMCoFJ+9YzAbxuCZO69c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 77FC343F8C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50598C4AF0C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774310767;
	bh=MaAPKugqDqodvD5nfGMcExHZcfYC5GJ2oq01drG0C6w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=X2HD3rX7Stftvw/rF5B2bhz52615w6sKe4xNmr4e0mrSMG//80RBokOF2CnGLFr9M
	 3NKhzoN2K3BuYETUwuuZwq16hdKIMdYycLtD3T0MKBXrr7X4s61TPIXcuFju9wW+uF
	 /rWhci3P2IvNhRPRLmY+ab++VzylLY7SRThRFLus2+mL6WXxd3YIc2y273DY4je35g
	 BQfMu/cUQL/HuLTZtvjyakLaBnAVutOH0SEUdP5AVgnot8V27PTNLC1uBaEsn9I41D
	 r5r+XNIbAteEgmpaF/5CEnNv2e7ePUk/E9nJM02LtO1vV0gFb7JDANDsPnAXUSCScJ
	 Bn7DWSnNnZYrA==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b983ca059a1so96204066b.0
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:06:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXnWOong8CFElv23+6HoF7vvYkcmVMin8mSvzigluQ5QTBs4fsSXXlHx89o3gUFK3hEfqCUk8LQxg==@kvack.org
X-Gm-Message-State: AOJu0YwzVvvSwCSPvFmQ0Lpu+tXFYrxxN4sl3ssJMn6Mu4VKNccTNYFj
	ZJzxZDH/2BuaNs8AefI1L84rAJH7o/PQz/388nqT770SwX9/wavYE+lu44e+Q3W2orGDaGUpT8m
	uInTol65O9KVA4LZKD527XOfGQuPnOTQ=
X-Received: by 2002:a17:907:e10c:b0:b97:9130:659e with SMTP id
 a640c23a62f3a-b982f24517dmr643307266b.3.1774310766076; Mon, 23 Mar 2026
 17:06:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260322061038.156146-1-liwang@redhat.com> <20260322061038.156146-6-liwang@redhat.com>
In-Reply-To: <20260322061038.156146-6-liwang@redhat.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 23 Mar 2026 17:05:54 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNCTrKBwDZBiequ6qY9R649H983ACqhbXx1BM=7++G_OQ@mail.gmail.com>
X-Gm-Features: AaiRm52ZVutXfSJTDOeT7WDCsAt6y8LXJOUTwVDAufe4Y2AugS55tTO1NYysUPM
Message-ID: <CAO9r8zNCTrKBwDZBiequ6qY9R649H983ACqhbXx1BM=7++G_OQ@mail.gmail.com>
Subject: Re: [PATCH v4 5/7] selftests/cgroup: replace hardcoded page size
 values in test_zswap
To: Li Wang <liwang@redhat.com>
Cc: akpm@linux-foundation.org, yosryahmed@google.com, nphamcs@gmail.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, mkoutny@suse.com, 
	muchun.song@linux.dev, tj@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, longman@redhat.com, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: dr7u4s6p57iqbgjo85hjw1b9nfstxoc3
X-Rspamd-Queue-Id: 4F35720007
X-Rspamd-Server: rspam09
X-HE-Tag: 1774310768-415502
X-HE-Meta: U2FsdGVkX19EH7YJio3fKowg7CDSHt5y6s9fAHr9s3J2dO2+M5ceqy/iL9zHJP5Q+6P3OOHVLkyIk2WHDIYBwmE3cgATKpltSst2WVMa8NLENRicKe3ifMUx0SER5YjZakSq7Z2eltfMh3/yZ3w5QUyNBCdNgGxoD6q6PaoVrjpdCfCssSdL51Wiont+4PSQf37ImUa77aZRt+jvsQek2SH97yj+4prlZbRVu1yMloSCwsinDXX8H9oynXfJ5Yuq0UO4fT/sGOU/FvZs6nnnvMeF/hn9cr8DPdn/EbBdbuu1vVQiQOqvETUzm8jhjTnRwyHdgKhcjWDjSMZd4s9cBIf1slalRieHSGNIHZ3Ib2MYRyJHaFsOh04rdWi5wcpjE8Qe8tX88ayslh4jDPKT+vBVIZzMDFEy7CrdpD54O3KOSdomYtgdwsbMwhdAlTdgZRhOs7i2772I3XThLiHGFZwyEZ7Nq4McZ9ZokdMoashR3wTJEL0r3AyQ3SvqprxS0sKVs1/t4OY4nCoVbF9Gq1ImoJ3w7F1fCHclT+Iuh/PIIyaUlrY5Ly91UkusqOXsnwLaR6a44GxleixXkpRz89jHexpQz9hetZKpls9dOyp5oj6Moo6yJgKjukxefYhrr5EHTdirWJsTlNbQoAMdEZ7tBfgsrZpHrL2jpcvh9kL1kY6at+feXr1HOs5NikpB/HaYKkxWk/Fjnj7n409JYFGIFI1LHGVLtkP9UuI9a9TPlBusyPSh5LEx3DbpbWBot7CakKWo53NnJy2gMJgK5SwhLLQSCfFuDattoqk4mGt8PbYIau8JkMcC0RFqM97ZvT5W7K6lLL/YX04PlIdDdGGQIMDsOutB68gJmtYSQvSfGmT1Q7qv9MxmS9lQpTDv57wRzMyzyRkOwpv3Uz+2rKXS7jw3hQNYLuFQUSM2CTg8rsNM5F91xoMdmq1sbG3UEvhDcLQsTaPU1cuSzPy
 1gNbr3Qv
 RgAcY9H45XKyS2YAJN33oDyE2nhu4FE1N4RF4nWb5KGAgA2SqIpgY0eDW5rzUwvrwgL/Yg4dUIWB8dR6V6Lew8s77trapaLREcOuHK9kJMmk6jZqeJv+UqqY4NkEHmlksUOZgtpnnyqBip2WlqpwiR4odPrmad73Tlt3mBGEOEpLm7CPyyPodw8LJ1aGnwo9QgG52Bh8yGInc/Q4INSOtX6nDxICRr4o4+m1unfjzoZaGcwgqe2kYu3ApiI3n1lfLuM0i8e5hhnHBwPCnp1P/M5RqSZDLd7fSeBqIUKezI79qYjWCJpl0VxFF9WthAcN5IExtzblmArbOsE+DDkopW7zfQJWG/mhPA4I6r+sZIxcVqea5j/mkWbzGbyNT0d8GlxUuI2MQ5bZtZCt9ksxWkbf/p6WMvjfiQt6hQrWqgfijvMviiopS7W7GCnhaxoIHdRS8q87DPCzON6P8RHayT/uWkMG1ElmAja0Fv2Beyvo9Map4BbNIIHkM7BwartDNbkWJXkQUo4oCb+NudE7MSxVYspGQtU9Xx1Bu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 21, 2026 at 11:11=E2=80=AFPM Li Wang <liwang@redhat.com> wrote:
>
> test_zswap uses hardcoded values of 4095 and 4096 throughout as page
> stride and page size, which are only correct on systems with a 4K page
> size. On architectures with larger pages (e.g., 64K on arm64 or ppc64),
> these constants cause memory to be touched at sub-page granularity,
> leading to inefficient access patterns and incorrect page count
> calculations, which can cause test failures.
>
> Replace all hardcoded 4095 and 4096 values with a global pagesize
> variable initialized from sysconf(_SC_PAGESIZE) at startup, and remove
> the redundant local sysconf() calls scattered across individual
> functions. No functional change on 4K page size systems.
>
> Signed-off-by: Li Wang <liwang@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Michal Koutn=C3=BD <mkoutny@suse.com>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Nhat Pham <nphamcs@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Yosry Ahmed <yosryahmed@google.com>

Acked-by: Yosry Ahmed <yosry@kernel.org>

