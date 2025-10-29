Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7315CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 21:04:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26CBE8E00C9; Wed, 29 Oct 2025 17:04:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2447D8E00B2; Wed, 29 Oct 2025 17:04:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1821B8E00C9; Wed, 29 Oct 2025 17:04:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 071C18E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:04:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 959C189029
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:04:39 +0000 (UTC)
X-FDA: 84052380678.22.5AB70C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 98AF6A0019
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:04:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sXPTQ6NN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of song@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=song@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761771877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IeQrdhbzJtSGHs4OR0fhELCzRR7fb17Ll03UxCVXOf8=;
	b=tlyxueLXcX9L6EjKxTj8zjVdA46/eVJCgh0cvcIpn7omZIaIdlsmIyZikkK37sF2jxjzG7
	TRrMA15b+gu95YJghmofdSI6EcLRN4PCtnzwXuuElsOidojyh6t6K6X55px0NGzKLLAueK
	0rWgnz8h/tOjpn9xw9EDkpgdKXzS+cM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761771877; a=rsa-sha256;
	cv=none;
	b=yvckqbymCF8d7lAs7Z5l+sUS3Tr9j3pT5Gp5bMw09w/L/zO1DhsXQMSBc2OmOLXBzV3sgG
	QOzJMM7ySx/Smh/SvYgozStfAa56oX0I8sKcOX14cvCyjCQLTZT3zGU/OgEo60oTtuG6iP
	UAJxyIcOM5QgfNrWohoFYxX8SnnqFRE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sXPTQ6NN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of song@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=song@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C60145349
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66AD1C19424
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761771876;
	bh=IeQrdhbzJtSGHs4OR0fhELCzRR7fb17Ll03UxCVXOf8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=sXPTQ6NNfN9LetKeBdJ4sOKxVBj1JnrICO57BRnyzpnOMSb8/f0Rs4pO4m4c0IwXw
	 kLhIPCj/l4G4Zt1Zq2LC09krLSQBhMVdt35eYTS9eiwNNCqygO03elPHDbu97vyNjj
	 Bt+dTTGcvx0Eup5gFYbg3DV14axVEhms9uICsONWcPS8BLPDlVDLJ3cpnVeWNz32z2
	 zoWWUBZSqn0Z8Y8dnZTnyOS0DN6ZL0s1ruZuJYQEtIgbFQVKFP9kSa2TXPLxZHjA7n
	 REfez8IDzuewVKhuCitUWJA6vpx7RRt7eMhXmitFlH9BXmf/EmYd7eysALggY3vVR2
	 EtQDbaGuUftmQ==
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-87499a3cd37so2728346d6.3
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:04:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVTyrJh8TjHCNFpFTmHrCIwenvjaBZrlB2RJ4l8QSDKyH4zejsPk9DWppLMlF2A0dE2LeGhySq1HA==@kvack.org
X-Gm-Message-State: AOJu0YzbSnoEGKfIlD7DBswUyV2WaRNCidulzE2t7N4PPgaJ8JC+pM3D
	qM6RXE66adtinxx6RwozSm5BlOedkKxuqRika2Ax0rvVrbBWUW+l82dzANb8S2vIjqUTmT2EDna
	AJE6o6mBbtCwL7wlFCvR96rHVTPxpcZQ=
X-Google-Smtp-Source: AGHT+IEqf3PIOchyUqoLcawfwjWZmR/KgFNBHjNgX4VqoOPf6lJnxW+Lti6nor6ugzHgDbmIf5F9oXMuNctmihwhxfM=
X-Received: by 2002:a05:6214:487:b0:775:1d3:d07f with SMTP id
 6a1803df08f44-8801b0c5fbemr13858946d6.11.1761771875408; Wed, 29 Oct 2025
 14:04:35 -0700 (PDT)
MIME-Version: 1.0
References: <20251027231727.472628-1-roman.gushchin@linux.dev> <20251027231727.472628-3-roman.gushchin@linux.dev>
In-Reply-To: <20251027231727.472628-3-roman.gushchin@linux.dev>
From: Song Liu <song@kernel.org>
Date: Wed, 29 Oct 2025 14:04:24 -0700
X-Gmail-Original-Message-ID: <CAHzjS_uagf3G4hAcJK0QWao88a4sRzXjdkQGgRMH8RZYd_C4Cw@mail.gmail.com>
X-Gm-Features: AWmQ_bmwLAYqjY6FqVrt95b3pom6p-BA2r_4lSQbeFy3VWdjR4QavcuPY05pP8A
Message-ID: <CAHzjS_uagf3G4hAcJK0QWao88a4sRzXjdkQGgRMH8RZYd_C4Cw@mail.gmail.com>
Subject: Re: [PATCH v2 02/23] bpf: initial support for attaching struct ops to cgroups
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	Alexei Starovoitov <ast@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrii Nakryiko <andrii@kernel.org>, JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, bpf@vger.kernel.org, 
	Martin KaFai Lau <martin.lau@kernel.org>, Song Liu <song@kernel.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: oipsetjw8pxjngk9rsf1g5w8zg56q6a8
X-Rspam-User: 
X-Rspamd-Queue-Id: 98AF6A0019
X-HE-Tag: 1761771877-949756
X-HE-Meta: U2FsdGVkX1/AU8xQUN3XOOORY+m3ZeGR9o3v1DIGKUvxuc+vyY/qxn5tJ2XcP9p3sJmaf3b69dFlER0fhKGdTxyMSNb5Lk1tm/7TdilM8V6pmmvcNHCjYHdVnsuMFSeAF/T3+vGy4G8FqCH97P1OFsCPXQK7Gw4nSTD+G4EshcmkJ5vNjHdNESZljv/YRAvu50CRXM7IPxX63aXmWiKzc/00UKTs5qQvQThTRD6A/f+2MYQMG1nZYz7hCS7QAu+AXNIoMknnmff5CofWw9wu27yD/6VUTYxZWYN9dU6ntrkhcEDUzdFFKIhx89pBQzZEGGrrFdJw/Wl0TxQQkgnz5F5UppU57iPIL3LjFD06pG1riRBCGVEiGNnQnolHawcUgPii0M21LuH7PL3cx/dsGbiqM95jYSAdCyyb8xmluaOmLOuxokhnCAC1Wc9h42Sk8+bMjTNBE7yQjL6La6X0utlyURLlmJuQPzGQJYz5SqWS4yHjJfDCiAf0F6MYcbnbABaqbOQD7mBHawCQLllHsjvMLaR63FdGoaYyQ0Ma0Ad7g4N+5Jcz288a0LrEfdvCSId+dXTuNtDsqmlRJKIl2tI3ai8EQFpTR8D9P6y2LJMq+CEHyT4HLrNZUXRS/Q8mY+91eRUKZffObTTTefe0CrGOyi8zfI6u77uZHQfWgrstCZ87X8Dlr0CH7lrOklwG0QUZ58plnrVOIQF1fpVXHUlc4d29ufkm+3HCQOs38M68i+CnUmtrlFO26eHixbm64mQxAl2vWbyWyfphhQrBkbEGXVxzqksFpJV3fqdftFpt4bOm4lyUgtjoqYl4d55+p186RhiFwICQ0bNjiQmFRuYnwljXCY42YHuwVkGVOa1b+HRtc/eV54ce5gQQXSIdKY9wLHZj/CFgf52JOhmEIf/oDH+qMh9LXEyf+WMsQJFdxSStBVMSQZXVnpA93ESQiY6+dzWE49VMqRHCuPu
 for8ZI7V
 0mCtJId+1A3KRvGD/qroa1HggPPnIhuKUJ1EZ/l77HisXG93YvyI3zp6MseSOanGLthdBI/glDD8QLi++OG7hcoe95TORNkBzElrVYOsw9aHh8DJpCoC4OaQQW6scuR+UOvETDZaVi+zZqNgcrzq9xHLyy+zKjIG/xoKGurXvRw+1uq/ezMv9JGZV1dRKzWrZvSvL3aM7xRk5gyAJWDC3jga434eddA2FzExALlDkggBMnT+MCR62ADlbnn7iw9lbY6bF0fzsVjhZwDekJRkxYJKdWF5MTafRmi0qRZsqlXzLArEEhhbz9vecEA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 4:17=E2=80=AFPM Roman Gushchin <roman.gushchin@linu=
x.dev> wrote:
>
> When a struct ops is being attached and a bpf link is created,
> allow to pass a cgroup fd using bpf attr, so that struct ops
> can be attached to a cgroup instead of globally.
>
> Attached struct ops doesn't hold a reference to the cgroup,
> only preserves cgroup id.

With the current model, when a cgroup is freed, the bpf link still
holds a reference to the struct_ops. Can we make the cgroup to hold
a reference to the struct_ops, so that the struct_ops is freed
automatically when the cgroup is freed?

I think the downside is that we will need an API to remove/change
per cgroup OOM handler.

Thanks,
Song

