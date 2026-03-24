Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE0BAF532C0
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 00:17:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34A766B00B3; Mon, 23 Mar 2026 20:17:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 321F16B00B5; Mon, 23 Mar 2026 20:17:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25EE06B00B6; Mon, 23 Mar 2026 20:17:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 142CD6B00B3
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:17:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A9E04BE0BA
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:17:25 +0000 (UTC)
X-FDA: 84579042450.20.2CC6602
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8A8994000F
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:17:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rsogh3ho;
	spf=pass (imf27.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774311443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KMa/FPTvOK/dRPbAgxjP2GtzNpM1gPI9sCDOsYwzXJQ=;
	b=6G7Wp595/xiOClRtMTmi37dvoLnzsvp3o0uG1q9A3psszOSmA+0AhaIQUmLb5CWXnvEiXT
	iy5v/3n34qCBWEP/0I27p+kd4JK9s3KwAAtUI9IEQZ96IIBk8Em+bu3udm3zoRUF+aHf67
	h2B2AXffHsQvT0DldXnzWCZncPj/u3w=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rsogh3ho;
	spf=pass (imf27.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774311443; a=rsa-sha256;
	cv=none;
	b=i++C8rnToFo3nJqUed486k46Foch0Fh0bRmMOmowu7AWLseUR9A7XGCLW7F4GtZw9dd9YT
	J9MtfCDT/kRZVa2ofav+W62hZu9ORmwqQmG73gJejMthxSQgQ3pC2l49FELm83qs9V9wch
	22aGnxfhLBEmrnSxTiNNjvFqznE46Yk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E792443E5
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:17:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526B1C4AF0F
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774311442;
	bh=mkPMr+Ubw3gE/jNPJ4cFqrp/19KQd/EAePHNoJi1hak=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Rsogh3hoyoYJmf99kdqKt6lBJDTP+1xdPyj5kVS2IlN8iHQ3wzE8MkGQ2vG/+vCIQ
	 jglMKyhVHQJLdfMPDmwTBMOYPrv3+D+zxHavwso9XNlhtALMMJjzVyWn1cyTquak5J
	 eYPMoo4H9FNyOu7lRZ4j9CFL0iSDN1ty/nOFJ4CcUJFJDOyfvelrs4EnK/wpc3lDi3
	 vUn5cGfhk9lLEhPwXRKx6PF/rSZNgL8Nn4GVPiuqcdjrhzR7kqcTLKCBF6Lk5unZeU
	 brDDMtaAqTyg+Z5imL12U3VK6iprVbhLo9pompG9YcNDMsaP1Af8EnYT7q/u04edCt
	 eUEztT/Te8+ag==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b98133bdc4bso571172566b.0
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:17:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUKxoSH3dSiZ5PbJ3an6cCIb84hjur+37/eIU/1Gs87PG3CPI4L9wbNiQL4aSy0PhSqCiFrFQXS6w==@kvack.org
X-Gm-Message-State: AOJu0YwZiTGEA7iikoHKu9tuju+wVz30LiU+iK9pHOwryE4KsfY58brv
	9Vni9aHuwAlAE7LZVLhCUifM1tum40QZnh5hOK6lJaNZhL3zfj2k06m0djV8InHLDivWLovYRAP
	RVQC7+Sxh8w2zhKyt4jP+kSJbbF4wRPw=
X-Received: by 2002:a17:907:3f28:b0:b98:4e9b:7e49 with SMTP id
 a640c23a62f3a-b984e9b9366mr668007566b.33.1774311441088; Mon, 23 Mar 2026
 17:17:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260320204241.1613861-1-longman@redhat.com> <20260320204241.1613861-3-longman@redhat.com>
 <acE2WDuto9cdp5Lx@redhat.com>
In-Reply-To: <acE2WDuto9cdp5Lx@redhat.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 23 Mar 2026 17:17:09 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNqHVCOYcun=WWwF3CROi-nLAsJUSJJtcsrQGUKF-CKQQ@mail.gmail.com>
X-Gm-Features: AaiRm531iQ3S4jGCxOVHcyk6sudkGI-5HpMDYVgYjNPDeV0yeExZpsLA0GLu9_E
Message-ID: <CAO9r8zNqHVCOYcun=WWwF3CROi-nLAsJUSJJtcsrQGUKF-CKQQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] memcg: Scale down MEMCG_CHARGE_BATCH with increase
 in PAGE_SIZE
To: Li Wang <liwang@redhat.com>
Cc: Waiman Long <longman@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, James Houghton <jthoughton@google.com>, 
	Sebastian Chlad <sebastianchlad@gmail.com>, Guopeng Zhang <zhangguopeng@kylinos.cn>, 
	Li Wang <liwan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8A8994000F
X-Stat-Signature: roigeeyjkg5gsxdy8kx7jymy9zuqgmkt
X-Rspam-User: 
X-HE-Tag: 1774311443-50859
X-HE-Meta: U2FsdGVkX18nusY9IXhtcY3SDsbcnQMzf+vXDfkvT7ReJP2OYeDmP6NfooU2yFyh3DTscVC/oS2hfaxpFwbXDBsIjPbF4S7qxhnqX9fLvjdTwqJen9ov6VMwsF77En3/1xCqFGhGdXmXLLUUSrlwtjP9DhmPO0FfSFouxh8hNgB3p1XLnL9/dr8T6f5oiYyHUIod28BjLWLTmfdlFVS6mZjT8DojRUGyE9gyzXKDwzfMZwmjf0LwBoSO3OqO15We0CK1zQQB0y4VO+kfYdUyhqv2YDDFkhL6gB3c+auKBjWRnxJ43lXodr4HqunvtOTZNe3HLzrPn55KvYlyTYsJ86Yi9Ena4d7ZUsXpd29E3uyym11spDsxAPVTEVlTlG+DLgZBLbbZ5oh0qCqE7p4TsKLajchXRtHpKPpdf+P6joIpDeJCNwVB5Wy7hdS65/1hCouHL6EDpau4IYX9lI+KhXHaKJbQtvPd2J/nj5IN+bSW076MnBDPWrr3JuVDEh6eOLi6qwgxdxo9eUmofM12hziO/OmdOn3pAVvSXUnjn8V2XVbFS8VJnoRGXzI9nkSbIYpM+svhzutOJRXX2VTSdVcH1gRm+FpLuhnitm8MUYLzZA5e7lmgoI/0xsuTISvdxoOLlAc2W6hcRNj0ZK29htZNL8198BaUvdOhA3bm3tqpJTBSsCq5EeSDpgohydYGujA3K1i6pXqUORlPsBWsg6LD7QA13ruHH3PhNzjTiOJBYj84TC9M0iJ2zqn3vsBQv9iKz36zuQ6i+Wza8ncHme7ludpcvueDG0W4sn7fy+2qZ+76Oe5wSf1U0rLeVamAETr8Wb9LthAKhHNHf01ALjhp+ZnyMQ/zxa8PRDxHw7qXXwkdS/Yro0ucNEBebbzuQEJA9NSccfcdwltaVHc5sPw9TfmehsdSDI34vSBNZr2peiVl8dlybjlrhjHkgOYoxzyL6CgZmJjrp9EBswp
 YTpo6L1X
 0Dbq/zz+7sDte4/zbJ5UU+TxzuK9h9Zp0bikhjvdgIRe6+Mwhz0aRRn6eZ5DK35JKhpAEhm/Eg9mOu/oT/RoHS9n1tAcxJbexmSc9KQR3hKT3CsLQSBXcqVkNGfgTQvO/e580lM4vJj/qm/Gpn0xv+BhI29GEKA+csSry2LU1mkvWtkXxfkCbE7KucYiaoNk2RBSH9ONj+wsclHhuRyQ9ythmU7VnOq1n0Tjbf1wbN/ppzaNZrgpq36EA0pG6CJt/aLZBwgC4aGve4Ut6YCZOmC4VoK7ZEWSnOOpVRLamPH9TlTJNiVCMkNBnkQbzoCs+OXQs7i9VSR4uAKNAWSiFQutjwuYx69e2qC5t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 5:47=E2=80=AFAM Li Wang <liwang@redhat.com> wrote:
>
> On Fri, Mar 20, 2026 at 04:42:36PM -0400, Waiman Long wrote:
> > For a system with 4k page size, each percpu memcg_stock can hide up
> > to 256 kbytes of memory with the current MEMCG_CHARGE_BATCH value of
> > 64. For another system with 64k page size, that becomes 4 Mbytes. This
> > hidden charges will affect the accurary of the memory.current value.
> >
> > This MEMCG_CHARGE_BATCH value also controls how often should the
> > memcg vmstat values need flushing. As a result, the values reported
> > in memory.stat cgroup control files are less indicative of the actual
> > memory consumption of a particular memory cgroup when the page size
> > increases from 4k.
> >
> > This problem can be illustrated by running the test_memcontrol
> > selftest. Running a 4k page size kernel on a 128-core arm64 system,
> > the test_memcg_current_peak test which allocates a 50M anonymous memory
> > passed. With a 64k page size kernel on the same system, however, the
> > same test failed because the "anon" attribute of memory.stat file might
> > report a size of 0 depending on the number of CPUs the system has.
> >
> > To solve this inaccurate memory stats problem, we need to scale down
> > the amount of memory that can be hidden by reducing MEMCG_CHARGE_BATCH
> > when the page size increases. The same user application will likely
> > consume more memory on systems with larger page size and it is also
> > less efficient if we scale down MEMCG_CHARGE_BATCH by too much.  So I
> > believe a good compromise is to scale down MEMCG_CHARGE_BATCH by 2 for
> > 16k page size and by 4 with 64k page size.
> >
> > With that change, the test_memcg_current_peak test passed again with
> > the modified 64k page size kernel.
> >
> > Signed-off-by: Waiman Long <longman@redhat.com>

We need performance testing for this too.

