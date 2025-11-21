Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 215FACFC294
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 16:45:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E4A96B0022; Fri, 21 Nov 2025 11:45:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 594BC6B0031; Fri, 21 Nov 2025 11:45:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AB176B0027; Fri, 21 Nov 2025 11:45:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 399106B0007
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 11:45:33 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DEE921302E4
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 16:45:32 +0000 (UTC)
X-FDA: 84135190104.18.974BA9D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2EBE1C0013
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 16:45:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IBw8L3QS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763743531; a=rsa-sha256;
	cv=none;
	b=sjajaQEK79QgvNkpQCCvHt69VktwuSD32QOILOtIJCcnrq1bM838dfM7NUqvkr4izwyAsY
	CPKLxP66Mmce9d8DNzn0SpmiUtqgZnYTNTrMDSbyvcyTrUD/b84WLi+DuHukvurvDKu8Mx
	kCgS2BvDzN+yIh/quJ9Ixu24/RIgKw4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IBw8L3QS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763743531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k7zZWe0B8ipU03G2z8sKu72PeS6bpZ2Fc7nIWV+fgoI=;
	b=6x2yukkjMoOS7JyXr1sApBji5BWJUDHQU2ZIgqXTCmoVPuev0zC2m3PXKq6C3gXLKtfTA8
	PSbW8m3jpcMdNpwYBxx7Bazia8rgAGYN6Jw1I3orYVNI4X0ZHo2r8jnB6bF0lh0YKYc25Z
	ELqmOFBppQgOlQmpk3/xIwZS8NGXGZs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 19F4240854;
	Fri, 21 Nov 2025 16:45:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65F5C4CEF1;
	Fri, 21 Nov 2025 16:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763743530;
	bh=uKqlbpbWZRrKvI6snBLWA76JEhH3myl0WqefytuKsNo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=IBw8L3QSRDawIjSxvYdXP68CTt2ce590ZJcwdoZ2Jijz94Ey+jenn+VooM+tMuzu/
	 7OY/Y7/5mFacc9/raDz5D79GRf94kp4F6GGYHzpSCYsv8yU/pXMVEpNmSQ3dubQQns
	 KJdkJP793gTvJ2KdaXNFKVqn2+gL6lyH5xwCh62A51RWLBz3cdk2trhxyizwkcadmF
	 Ulfe9QhNq7K5YhvlwxVwWUctlUnulpiW1hGfgU1Ff1oTa+etifkU80qyZrYhttWcL/
	 VdDiv06qRZpeFblFV7JecQ44oJ1WIOkZ6IIs+LNwh+K7PYn1nDy7fpSPj1+FKo+oaw
	 3j6rWfC6PXb4g==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org,  jasonmiu@google.com,  graf@amazon.com,
  rppt@kernel.org,  dmatlack@google.com,  rientjes@google.com,
  corbet@lwn.net,  rdunlap@infradead.org,  ilpo.jarvinen@linux.intel.com,
  kanie@linux.alibaba.com,  ojeda@kernel.org,  aliceryhl@google.com,
  masahiroy@kernel.org,  akpm@linux-foundation.org,  tj@kernel.org,
  yoann.congal@smile.fr,  mmaurer@google.com,  roman.gushchin@linux.dev,
  chenridong@huawei.com,  axboe@kernel.dk,  mark.rutland@arm.com,
  jannh@google.com,  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
  dan.j.williams@intel.com,  david@redhat.com,  joel.granados@kernel.org,
  rostedt@goodmis.org,  anna.schumaker@oracle.com,  song@kernel.org,
  linux@weissschuh.net,  linux-kernel@vger.kernel.org,
  linux-doc@vger.kernel.org,  linux-mm@kvack.org,
  gregkh@linuxfoundation.org,  tglx@linutronix.de,  mingo@redhat.com,
  bp@alien8.de,  dave.hansen@linux.intel.com,  x86@kernel.org,
  hpa@zytor.com,  rafael@kernel.org,  dakr@kernel.org,
  bartosz.golaszewski@linaro.org,  cw00.choi@samsung.com,
  myungjoo.ham@samsung.com,  yesanishhere@gmail.com,
  Jonathan.Cameron@huawei.com,  quic_zijuhu@quicinc.com,
  aleksander.lobakin@intel.com,  ira.weiny@intel.com,
  andriy.shevchenko@linux.intel.com,  leon@kernel.org,  lukas@wunner.de,
  bhelgaas@google.com,  wagi@kernel.org,  djeffery@redhat.com,
  stuart.w.hayes@gmail.com,  lennart@poettering.net,  brauner@kernel.org,
  linux-api@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  saeedm@nvidia.com,  ajayachandra@nvidia.com,  jgg@nvidia.com,
  parav@nvidia.com,  leonro@nvidia.com,  witu@nvidia.com,
  hughd@google.com,  skhawaja@google.com,  chrisl@kernel.org
Subject: Re: [PATCH v6 05/20] liveupdate: luo_ioctl: add user interface
In-Reply-To: <20251115233409.768044-6-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Sat, 15 Nov 2025 18:33:51 -0500")
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
	<20251115233409.768044-6-pasha.tatashin@soleen.com>
Date: Fri, 21 Nov 2025 17:45:19 +0100
Message-ID: <mafs01plr1gio.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2EBE1C0013
X-Stat-Signature: 8k1rqmsi1any19kgfh4d4phzijk7uxcy
X-Rspam-User: 
X-HE-Tag: 1763743530-777095
X-HE-Meta: U2FsdGVkX1/3PjK4HlQJniY7+vRfQAvlOdar+6/fcWeGFk1niRzhoNJVZMhrzhq9FF7geuf8gSjMOJYGmzwqv2VkWI45CPL3CDhkuz1mi9+vqBhrJ13HdKMc+NTnJpbvJR/kGd4cUiZDfRgp+N7zwf6XNuiwN6Wy3+UkYvsHK7vaRzo/83aTVrUNCrZ+0kRqj/AbfyjAEaFHqLrvWGKIG6u78wexsjlPzXlwro/i6SDCmDSroXNUJ06gR8Pk2S2G98yZwt8WV1MXNee31atxrBwh42G9ebSSz7CYEo4u+2NOAUaRueNMWbGwvxf8c9hhGqAVseO5QlsVCv4Tnv+ByrtsTrAt5DS5hGAtf+Cr3IkrdsN/wTMK7nyGgQSbZ+2dD2iXGTA2rUGrHkEfhWXU8AzZwdJfjSbD9vZgq5DDrIJQG6Dq2vDnsXV0ZeBF1llZeKHROh+Zg6YVA5jJjH+LKDd+PzFVs5MZ9VkD9+xCDw4xDdwfSiYcWR1Kxup3M7B7J554Vtzvmkuk2Vmh4ZSr92YSLAvgBTRKoEmF4RViXQWSwf+iHzr4gic/Kq3jv0pfvmqP9c2TpZ9KwYDieaELrLqO1T3dh7kGIWJ7M48up2gWhla/PegZBGtajMd05nEG/ubVop6c/uFvzFo0qKLEJ4ObElrYgBtHDHU4T2xwrhpJjaYi9MdYokmn56L/ZErDjmMs3ufBHntD0xyvaXHsgC3Oj/kDQ9xUk+kRekcmrFNKndQ/Uu9cF2qTk+s6GhfuFI5y1WJwCXC1yNebeUv5DX2wTqifImET1Fy7zCqkU2LpV1p4kO78aQQRrgsXjdnL61Q4JPCPsf6Mwl4SwBK9pkt7Br21rg9XphI6xhdWw0/xolu8+HXIKdksep8bAz5HTy6x06elZ+ThrvAbmRTZk+3D6C9kIBgDH3ku9NKMSJx/l5oSCbH9bUGhUvXNmlHZezynr+y8VNJ+lXMlcy6
 Jtcoec17
 q5ZhKbqorQf9vRhy26ehnZWtHzC0WXbwcmAnmAnJIU+XWJphN8cQ1QF0jscPHeFqIXMn9V90KppCxbiW5Qzw7jcT5l+joCi7VktjCaMqAoH4pVbnikDNyvzEOCInQ2JKiTdzzM/HdHfoRw2wzXpuiuXAt4DkrAfdlW/M7LaKuO22SCFiclIl+E7XmaqU7uA2j9uAlZBNwsws1oeHYGAUWIZvS5mC/f9C6xIs30ujq/7bVkLBIEphtgX/B9s9JgdrFqJFa3ACcMysbgXnUME6WAP1GtTcSTiyfBKfihfH/7U64gpzZ4q+82Aiaj01wSBVyNe6VD88ve2oMVs2wm9sp8w2qWUQoaNlsHO7n0+rYM087sARs768pH4Ax3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 15 2025, Pasha Tatashin wrote:

> Introduce the user-space interface for the Live Update Orchestrator
> via ioctl commands, enabling external control over the live update
> process and management of preserved resources.
>
> The idea is that there is going to be a single userspace agent driving
> the live update, therefore, only a single process can ever hold this
> device opened at a time.
>
> The following ioctl commands are introduced:
>
> LIVEUPDATE_IOCTL_CREATE_SESSION
> Provides a way for userspace to create a named session for grouping file
> descriptors that need to be preserved. It returns a new file descriptor
> representing the session.
>
> LIVEUPDATE_IOCTL_RETRIEVE_SESSION
> Allows the userspace agent in the new kernel to reclaim a preserved
> session by its name, receiving a new file descriptor to manage the
> restored resources.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

