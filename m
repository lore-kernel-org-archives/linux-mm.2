Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46822CDB466
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 00:09:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 310A56B0088; Mon, 22 Jun 2026 20:09:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C1AD6B008A; Mon, 22 Jun 2026 20:09:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 164A86B008C; Mon, 22 Jun 2026 20:09:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D7B9B6B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 20:09:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 63E5C166BFC
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:09:07 +0000 (UTC)
X-FDA: 84909242334.21.E72FDD6
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9661D140002
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:09:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IU+AoP2a;
	spf=pass (imf26.hostedemail.com: domain of 3n845agYKCHwxjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3n845agYKCHwxjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782173345;
	b=S1pkNyv+B9jS68FiN0CkrXoxweNgTPku9EpIw2zfB5TGAz7xamxeKmntc+Db0DFln7M4lC
	V5MgNp4skvkt/fr2AKam6l9wViet3IFTz/pBVbymleq5JB0+6SFK6oE1Xprx1TnULCBZKX
	mXnELq6daBn5DGI+aHwFxwWGzm5sqt8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782173345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TDYTMQB3fQDmgyevIQsrlSuuHRIIVN5YGJEE9Jzg0yM=;
	b=dmToZTHgPUsUXHjes+mc2kLLNLFbvaQF8l9QACnNQ8Qu0F/yhgwR4BgKexITJoEMwQp/Cz
	sAh3cCaN7Tcj+9ea0e3jOSKgLsLC2pQUuMAWcS760laI8MrO6hNWTGTJgn2qAfWBx5I/qe
	NjgbgaCiQR5gHJ/Gse5UVQRqPiyieQM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IU+AoP2a;
	spf=pass (imf26.hostedemail.com: domain of 3n845agYKCHwxjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3n845agYKCHwxjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2c6af282daaso74535985ad.3
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 17:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782173344; x=1782778144; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TDYTMQB3fQDmgyevIQsrlSuuHRIIVN5YGJEE9Jzg0yM=;
        b=IU+AoP2aweK9MTDP3+0qgC8HQicazaMwlGLtmqM/AnHQMFwpqWmFs/wyLlRp4uPwJ9
         JHnQH7fWmYdu6advY/ke1Ud+igJtteATphdsfi6Krur0LVQYqY/wMY67+vk4OVSFTFH2
         5TftwDevZuoeiLTC7YAcmI0JLPjhK8oDjf4KzhFJfSlg9o7mvNGWkZHuMvTLJt5lObaZ
         leMfKuXpc9xZX3RvkDyL7u/TpeIc2ibT2zo3wm0ZG8vnmuIyeRe32af2uejyDwTv5at5
         3wf7kbeUaHz1R860k1kJJBZCqQHcoSMwXWnGftZP3o9jLs5tNfpKiXH+bb6K6QbAFOyy
         7gWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782173344; x=1782778144;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TDYTMQB3fQDmgyevIQsrlSuuHRIIVN5YGJEE9Jzg0yM=;
        b=sNetxJ4IObtYFsY3nwNAs7h2A4cMw2q3mkUkgEvqf7QRVoDF2IQXMUp/MH+4NJ2kGi
         Vx+p6Gh8CtTeI2kDJkUm4ZFC03UB76MdtUWoozzpkhX5XFdslP++Trpe4BOkurMJsx9M
         LTADlfYSsPPAJHuqQpELGQVrDIVeX9/6liVN8kNfy4tNkcZVvAawuvcL1Ovb8lSFEUmf
         ZaSACfHk8yFQnl+LNNb5OZTV5ZjUDQtO/X1EowTaej30wVMZ7sL8zw+plFDvDGjumVR3
         kd9CkOC0HUBt8HI3qgCWmNlTRY0G9o8DJTpJMK0BN8iUCXvxTnM1XoLAIuptNG1Rc9Tz
         dwPg==
X-Forwarded-Encrypted: i=1; AHgh+Ro0d7kE15dGMCOlXoVjMkcW4nlxHiE7wiF+iPygwhLXI+/qYuG0ApVbF1d9Pbv3p5NkUBRo4u3lnA==@kvack.org
X-Gm-Message-State: AOJu0YxvhkA5QjXZLKbiuCgLYc2ZCa4p9nRRI/oT9G0+AaZUwdh6XlFN
	azmd7S86QbvsyhzzJKeISEKe+8s6v2pHepIscEI+IoP8+BB9oAxmkchIGRly7wSnBLl/TkDPXrk
	jtOOe6Q==
X-Received: from plae21.prod.google.com ([2002:a17:902:e0d5:b0:2bc:bb08:92dc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e881:b0:2c6:cd96:6a8
 with SMTP id d9443c01a7336-2c718f3fa54mr191868605ad.30.1782173343880; Mon, 22
 Jun 2026 17:09:03 -0700 (PDT)
Date: Mon, 22 Jun 2026 17:09:03 -0700
In-Reply-To: <CAEvNRgFEHciT3T9y+qEYRvXhDwfrggoU7Rm=f9hT3OrV+wgpNQ@mail.gmail.com>
Mime-Version: 1.0
References: <cover.1780676742.git.tarunsahu@google.com> <48777f4749fa43d5648085dbb2037aa99c144a88.1780676742.git.tarunsahu@google.com>
 <CAEvNRgFEHciT3T9y+qEYRvXhDwfrggoU7Rm=f9hT3OrV+wgpNQ@mail.gmail.com>
Message-ID: <ajnOnzdknfwbuJ9g@google.com>
Subject: Re: [RFC PATCH v2 06/10] kvm: guest_memfd: Add support for freezing
 and unfreezing mappings
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Tarun Sahu <tarunsahu@google.com>, Jonathan Corbet <corbet@lwn.net>, vannapurve@google.com, 
	fvdl@google.com, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, sagis@google.com, aneesh.kumar@kernel.org, 
	skhawaja@google.com, vipinsh@google.com, Pratyush Yadav <pratyush@kernel.org>, 
	david@redhat.com, dmatlack@google.com, mark.rutland@arm.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	axelrasmussen@google.com, linux-kselftest@vger.kernel.org, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: mfiy8gfwxoqs69a1puwgzd76wqzdwr19
X-Rspamd-Queue-Id: 9661D140002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782173345-228050
X-HE-Meta: U2FsdGVkX1+s1n1mzqwlc48OK4K3Rw0g5aBGN0TQLBQJjAnbSc3rQ/delLcKKsNzIL4F1A5/DmLF2ccjKOll7BC/z5Ocjq5uvUTiFi21R5Bz6Ljxg8Knhs7rnsxgXffqIYnKy2ZvKVGSZoPv+AVoYYaezzuH9TVirvdXNWzL9SSvqhxFW/ofJzY/Zg+IztD0SIt1XR99CQcnZsoyySADjTrJggatNWUvH3FkEPHoZKVV8ZtEaXVdFnAFY3NTLrnffKMyTm+XCenZBKYws9q4rIcm7XQB6WJfvyNDsQHFHsYrk3CsgewhYzgTkzs5Xs/EIX+1cDA8YxyWgpYX/sdRUqTwSg310OOONFfJpI9kDu4AE1lmy+EzwaKmrSt7Ta9WDi0BrqBUtNvNDDpnjlvPKNLzdrldFPVcnl1pNzlBih9Q4e4PLEoE75AFXCcnauJmqqI02Z92vFxzrcQw+tmHqKcibV1cx8mExivuPgtHe7Tvf0qtyyEewBp6kFBjEbapvj1p23VyxCRJBgVzJFGV0esPJGSVGKkrUsZ6pggDfPYw84S7az9cjT9x8ha5zzpgQmfwzwzXSqLQ0CAY3T+g0MkTwTvhB/i5rWZ2UvACNMBQTDN6baFCUKcg2UxaMQ3TyaMM/xaJySN6AVUVIac+Cn06pjuxwOclQLD9cq9f1eYSdYskjrM8Xf6zzYfWJ1kVQyq8QK1boWpgOExuc2i0XHQHzS8TJaXD2H5hj9fV2YupS/RiR1MOPg9eGtMsN4KLG+9Df+TeS5BXwx9I1U9HuWZExevFO8gUL6V1k8XCJZ/1MuZW4Df1kc/O0NNNP3DOQPioQvMNEPevuCJFqcbbO8OqwfYUrGm5Pk6/s4L3PoyYLIyijL6rzBan1Oy0tDbUm9pN7TchVFqxYqQObOALGOKPvQ0vptuQLIG13/z+UskVuWBhrZ1iUu+Tff3JIfuLgKvLKO+vN9yvSvfMyOG
 YGW4sGIh
 6wSk+E979ZWfYmgaS4/fq7PZI+DQlDETuMGzVcxrALjUZM3P02ZM3+rfvz0sjAve1VnD6kIKKkTJn4S9tLEjn5H/dMVSxaIoZvC9NqO7cy6qsPgOojTkl2MLJuyDoUTJodyuBDdXjGf616amms30HK6sbLO267RsG+CnFuEsRRQqtaQPcilFTGAz4ximitkg+v1DVy3QgifSZwF786D+2dOlpgsdhZj1J2W6y5DMbb5yIv+ngfxEpJuICltzBT2qXn7phCol/mSllt3OrtmNfsbjyeAM8IC1uT1hXNoZjwfDdbUJbNDUxKIgoePktMzdpTS+OgSqq6XAAPs3E4v7tHXsnhogYi81zyDoocER9pOBoi/NvpTDXxkZBzmfMCBatAZdj+/NoIRfK35FKVZv/LCX25m4FCrzK43Kud6F+UHsmPjoU6VI9KcpwpTTgwWIK4YYJpvYeucT1uOl66Sry8sGqhjWne4/F6vJGz7DMqoQ04JkAkh5tBeFK9XqcFZkfXMqL8DK4gB9n8C0QXS8jN/rxnzpcJzoCcZkcqVdzOC58uEbYTNo1XO9HDqtkYThJdKyNj+kFENc2lpYLabJj1xPtUEO5/bw35G/s1ZOMr0wnNn64dkiN6Glbwr8OKwKcF3cHDnVpD3g+p+ryOc0EI9dHcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026, Ackerley Tng wrote:
> Tarun Sahu <tarunsahu@google.com> writes:
> 
> > This patch introduces the freeze on gmem_inode which prevents
> 
> Can't find the reference now, but commit messages should take the
> imperative mood and avoid "this patch" [*]

From Documentation/process/submitting-patches.rst:

  Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
  instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
  to do frotz", as if you are giving orders to the codebase to change
  its behaviour.

Documentation/process/maintainer-tip.rst and Documentation/process/maintainer-kvm-x86.rst
elaborate more on the preferred style (I do most of the guest_memfd maintenance,
and so for all intents and purpose it's bound by KVM x86 "rules").

