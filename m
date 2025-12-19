Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8D5AE668A0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 22:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 123F46B0088; Fri, 19 Dec 2025 17:47:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C9966B0089; Fri, 19 Dec 2025 17:47:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01F7C6B008A; Fri, 19 Dec 2025 17:47:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1C106B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 17:47:05 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A09EA134915
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 22:47:04 +0000 (UTC)
X-FDA: 84237707568.22.DBEA54A
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id 023A4A000E
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 22:47:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v+ESlIex;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766184423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oy4hadatsvYWxENzwt+xKjFz8JiU6Rcr59bQ6PfeQ9A=;
	b=xSmfOUL5F0qCVFXJ4TwIdSW4Rg70ctCuUWwuEKgTZu463Ug+jndavhMwFmvDQ8owB06uGK
	QrDWbouwEaKoycTDOIf3kmjC/um2XvpaxEL7YQhnT1+YwFMvyxWmXdDXsHMpmDGaBU7H2T
	uye65LXNXGI61Cyhk4EKJ1zatO5a/kk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v+ESlIex;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766184423; a=rsa-sha256;
	cv=none;
	b=7BIFEJZMpEnMJpuFwMECWd/cXvsdmeABi8j75eD3QV5gTfUTyPiBianp5AQmkn1pKe+yhf
	9JDzDZo2FciGLbc1ZiudQpcE7yu9eYj8lv6c9fqeKCM5MWkwo7O9Gp+W5BvOpSnhxl3hzE
	B7ponm24WW7O+mFlTuo64cwny4uh938=
Date: Fri, 19 Dec 2025 14:46:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766184416;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Oy4hadatsvYWxENzwt+xKjFz8JiU6Rcr59bQ6PfeQ9A=;
	b=v+ESlIexGbzGvTFY8u0qTO52uw/9pfdgJuAtppdMwJLAHyU7B8/qs61vGeEO8CKpxLFcaO
	JBKfTE5P660Zcj0Aujch/paPfdHjiY57DaIUGyyxjvWCm1n/2mnOd4ZVloERWcE08MV+3Y
	Kr07LDdfWyntv4h7FO+KjQUNQNTuJNo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	JP Kobryn <inwardvessel@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Michal Hocko <mhocko@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH bpf-next v1 5/6] mm: introduce BPF kfunc to access memory
 events
Message-ID: <imjniqyf6rbyla4hhgpxetw27wxsqpvt7zskdytov2by7bkt6k@yza2vuhvczmi>
References: <20251219015750.23732-1-roman.gushchin@linux.dev>
 <20251219015750.23732-6-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219015750.23732-6-roman.gushchin@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 023A4A000E
X-Stat-Signature: wadsdw45pbrquukff4jfxjnpreqs5k9r
X-HE-Tag: 1766184422-709146
X-HE-Meta: U2FsdGVkX1+WaH4NwHuaOkqQdo8JWBAbg8pQVMDcUUN8GvvYJg+PGz+KaDr2JemVE9p1/t4obg1/zmHe0AB+Z1NUFcPz0tboZEmrDBn5PtlOFpDWhx8Tw9ndq6wj3FuI9UJRaVD9pIE/S78vW8J4LN7jkxaNXB1dTVDfeaQC0mPmt+gpuxlJlBPNoVF/MWMPdWLAYKUYA2aoj9eBl9vS9hz9c/pdvBsccgSopvLcu0VQvqy/WKPRLZOpr99AmzYJwHVuT6NeO61BP7QXsXvy8F8BwzuakM/Yh8sQHC7ZJGwuJM4NFZNdIL23o6aJpZrbx3AiP107BNc5T0dx4Jfsz+fQiJOspKsvfDN/iHH2uOOFrjYbvUo0gEyw42TeBJm/GbE0NGcVaYu62q2wqEyzlyiTgNO7Xoeq7W36hCJ3cz69EZLM/FkuvydGyTyYuyGOLTLnpHJSJMT9zg6FMrzx9rC76+EXGBMzr/CHHMrhR9KJl6i6o1KSWoBhlnYy9ZedRJ3OLQUHTIagZwuAym8uUPRO06svCWDk+ZaLVcHptPlz+71erV9haFkZ1pnkofsWFYzpGBfLhgM3R+xVws3lbPjUXK8TVckxRQE2CvposevLq2s6ixr4LsKaiqI0x8tDkTB+ZI1R+MGxdkwmZiQRvvFDIsXwNY2gNYASGEDqwhPOAq11ggielsCkLVkpkd3aML9aeBBJaNchezooy0I3WB5COEeV8+Ky95fDd7yxMqmXxe5SdGxVIqsMewr8zwWA+otvarN3fqDkxcUmy5NRfXclAfM9CdWghACtPk0VWftrVED5vTqCBcC1NvXTIPgyLuhL25qXIhv9DEm1VVg8S/UdB6FjC8a5Hj3YmP6AYV+YXESkgqk8VQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 05:57:49PM -0800, Roman Gushchin wrote:
> From: JP Kobryn <inwardvessel@gmail.com>
> 
> Introduce BPF kfunc to access memory events, e.g.:
> MEMCG_LOW, MEMCG_MAX, MEMCG_OOM, MEMCG_OOM_KILL etc.
> 
> Signed-off-by: JP Kobryn <inwardvessel@gmail.com>

Roman, you need to add your signoff as well.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

