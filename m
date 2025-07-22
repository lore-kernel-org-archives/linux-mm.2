Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB953C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 15:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 759106B0095; Tue, 22 Jul 2025 11:00:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 707D46B0096; Tue, 22 Jul 2025 11:00:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F74E6B0098; Tue, 22 Jul 2025 11:00:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 48C376B0095
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:00:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07A9A1317BA
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:00:48 +0000 (UTC)
X-FDA: 83692212576.01.C115E1F
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2849440012
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:00:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=us6reoXY;
	spf=pass (imf27.hostedemail.com: domain of edumazet@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753196446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+nxKNO4a2BCMIJuvj3w0sl1mqftW1a06HRS7ZufxTrM=;
	b=qBIG1AgKgdTXx5WEmhyxu10pxY5WJHWHgA472k0Mwz6N98yqWPgs01q6fPDjuw8nrVxk3R
	PehLsvyO9YAyvbYt7iWTw+qEaoB6Ds49I5nJpUILnqu1wi+GpEzSWHgweSvA6WI09b4UD0
	vN8cX6qFPck5hc5TnBjJvMcq2qYPeRI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753196446; a=rsa-sha256;
	cv=none;
	b=PO38oxlqHtWgIUA8Mf60IuwD/OMJPXlb6YRgMe408Fk5TpUl/OlY8mjvkrb9BfLzTSdD45
	MWbobf0i9K8bL5meKO1/ZxA7a438aRL9dzIllnsERHxPlwAOVxMN+kvQNfBH6ANCsGhmzN
	GqtMXZgew4WKyQuERPHuGiY9HmK0Vgo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=us6reoXY;
	spf=pass (imf27.hostedemail.com: domain of edumazet@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ab53fce526so80607851cf.2
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753196445; x=1753801245; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+nxKNO4a2BCMIJuvj3w0sl1mqftW1a06HRS7ZufxTrM=;
        b=us6reoXYjshHHbEHff2p6or8J6DzoWfcqX8dWHPTKZmCxaZgvL+fgl+xzpVQ4A34tP
         QhOwdlBkVa+/I30Tf3sgpoKjBmn302y2uVb0A14XLyx2VtCk3JE1OhCh/cuCLK6WT/t6
         DaiyuC7+rrft+JvRiI8roC5DaePqIcq3gfKec6yZOeXNd0CIJtGZFms5YKchWqOxJZYX
         kR6qY2b7+W/89GtJ29yB7qNlCPUhxFhmVJBw/lBcYFo8o/GKsF8Q7AkjyigeuICejW6c
         N67ed5GvTltY0hMx3HGyGh0N3Xm3IrnwvkTMSZCNRr/VNyGDKlk07vvDe6O5vvfVMpr3
         lDQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753196445; x=1753801245;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+nxKNO4a2BCMIJuvj3w0sl1mqftW1a06HRS7ZufxTrM=;
        b=GsNJm/6LdvkVc2Sk8NU2epp9/CCpPPAmYpuKcLaK0q2AOVrHZH9v26kkxZGPpPrpEQ
         PcGasAdEely09OAP4Dd4FJno6znj8jExJ08bJKjA0wrHej8zrUF0ZmszYrAFmwoigq27
         EgmSana5mNpw4DAqoJms5SL0shf2ZqwIOTRnbUd9Orj3Hc+yo0K6qGup7biGlv8THy+W
         TQarhyGF4cuSyo3Wd1EQEaVmInWxfJESyNpY7MOHqXaSsDHyieNe2Fy014Zijn0VHbeK
         ea5j4awYoi75bpptQnMnAQcrGGpmmVXZ1OLsssRR8qgAMk3OemRszBa8JUGOCUA6Iqzg
         F8zw==
X-Forwarded-Encrypted: i=1; AJvYcCVNwMioyHgtHd8Pjvra0LyUH/mv7MzfG7y0SFU8zLHe16Whe5c6YUkZ6KLa9j6eoieSDTx/lhilZw==@kvack.org
X-Gm-Message-State: AOJu0Yyso/eqlMUoTPyMb6XNh7fAgL7a0KsIYAhysJZISfMUHDOLBIQy
	bwHGq3RkI2X2iJt/EBp3qS6EWq1DY5oYtH6KW3FM/4irpKdjxdMisqXgmvgWFXNWbwy7v2Nji4k
	yFd7BOjckqZSLUR74PzYeyFfXhN5LiwUWmww3sDE+
X-Gm-Gg: ASbGnct2d7EazQfi7vFlWHS+bqHiQtkkOEX51VnbMInHWRLwufz3ZdpTmt/RzIHnCc5
	w8ywLkTKuXs691FPsTiPm3YRAOFyar1os5jx1HdyAXatQvzpA74f1LDTV40Zp7STNgb42UXJhBa
	6lmb+MTW/pPFXkkjPB3Ao1VccjkE7fHnx+UIRtqL0N0xVsjzb54JZxtT5gly/cynRRXcQN7x7Db
	balEg==
X-Google-Smtp-Source: AGHT+IEAwdtOOJZle/vAWN8RPtXy4MisNzaqxiiiStWuk5ZuXoX4lqwhlAmVuPypXJlxrGh34p2aRu8UWxGzVff9IMU=
X-Received: by 2002:ac8:5d4c:0:b0:49b:eb1d:18ad with SMTP id
 d75a77b69052e-4ab93dbed7cmr385323141cf.41.1753196444364; Tue, 22 Jul 2025
 08:00:44 -0700 (PDT)
MIME-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com> <20250721203624.3807041-12-kuniyu@google.com>
In-Reply-To: <20250721203624.3807041-12-kuniyu@google.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 22 Jul 2025 08:00:31 -0700
X-Gm-Features: Ac12FXxzCSficlnnF49FJ-AwqyidP1dhOSx-V9OvnBpoHWZaDg3cQQfRkuFyMag
Message-ID: <CANn89i+mvoZ4rqtow2SRR0ZRB9gS4an9syCLuXyqcW=4-8Ek4g@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 11/13] net-memcg: Add memory.socket_isolated knob.
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2849440012
X-Stat-Signature: 9sgakwwhfmbscackopcnbz8z6sib9656
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753196445-916976
X-HE-Meta: U2FsdGVkX1+0Ets1WrMpM8d7vy/c8y7AFzKXIM1kJU4uYTOfaPxOE8ibx5bWOT+n15M3Rjhe7jIePHYutCuXDX+eTqb8DJuXIG0OmZWFKJHRE44XEQBRsQMkJbxZTyQ3P/iaaw4EYgn47agTSNsNu8EuGfN/4CYaizOzGbo19RxwmiiRS9kR7S5kxD9rjEl3xzXGZnQn9pBj5TzRRhmGdTeayML0CXLVZJ+oNgtVD4+vzJEh8EgYrBCIQ7DVgaCxVOszCMPTZe55nNk5lDHyqBBmss0qlei//INbnx3IVfTn/viOM1Gm1Qr3gHfEQ2uVRbNmauGc1HfN4ycKZ8pgy6OKqc+JmoxJ3VBdUH4bSJyNNQbBE2fEgxhScp0Ili2VWqoCjivzuv6/1OCiAH5TCnenPWZU9Sb7GMbt+64oPU+yai8ytQ1Ko4kaDxN6Vb1E3zqUmdelOkTgrCgbBH/3FEEIu++MR1uHi4njqC8VO8wp/VKv6stycTUgNu3kAOQWpikx1+F7wXrhGhJR9/LJX9SIieUWMo7OAYHYAskhDm7xfxnuGfxDaNJs1EQiSrTeQaWoYeGuZhrmQga2C1//DiqjTuPnT3yqb7kgKRL4Fx1smJmM5jBzIlqThB71Es/sRZNTBCcBeH/61TEPwpyTxzp3QeV8+RUYbjgbmHGilqQPykO2/A7HohCzpbx/w7c0VPpkUwGElLQ1L/od3aOBP59eSzlp/jCmdVl/K40a0gWIDsnwiCD81N37/ylaJcBVdEgUPxGeUrgeyGbdO+CJQ5lvTmj4YuZ1t0gzGK0/HEHi0RqF+J/xDbF8gYo6jVlbHHfwdL4XcJ1kgRj5K/07snk7GylmfUqXERPrtIkvtoGd9bMOMw11FiyzR0dqJ/Ib1VJKo18VPyA31h1htpXRthNBBQSLykVFYFygaMHRSMsrrSSOdNf9chY2XGl+DKk3RRgerBAQJ6k31CK9UoS
 OeL7agyr
 bW8bu4Q8m1nOQZXAzTVwOfEaiYaXhhdhWPgo1sO/xps+0UySKp+7zh/RFlZTQR9qn9PI8nUF0xR5mlByl7x3775F+M6nylNFAgwUFbFfMQoJvcIXEjfj5gqIZgmf/WcxQVVhIV5/quYgiEWyqYMpildV0rPgIHDKwekHWGvIwMYRN/SKKlNlULGjyxJHMJBhQjPXsKOxuHSbFQdoipcBGnVhS9Nsfgyg49dE8rHcuSRCJQfETnZc4BpbXhJvGbHV5yWXIed8TdvDcnZA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 21, 2025 at 1:36=E2=80=AFPM Kuniyuki Iwashima <kuniyu@google.co=
m> wrote:
>
> Some networking protocols have their own global memory accounting,
> and such memory is also charged to memcg as sock in memory.stat.
>
> Such sockets are subject to the global limit, thus affected by a
> noisy neighbour outside the cgroup.
>
> We will decouple the global memory accounting if configured.
>
> Let's add a per-memcg knob to control that.
>
> The value will be saved in each socket when created and will
> persist through the socket's lifetime.
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

