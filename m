Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3ABE106ACF1
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 22:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD5006B00C8; Thu, 12 Mar 2026 18:44:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B586C6B00CB; Thu, 12 Mar 2026 18:44:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A63F96B00CC; Thu, 12 Mar 2026 18:44:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 93F006B00C8
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 18:44:25 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3BD301C38E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 22:44:25 +0000 (UTC)
X-FDA: 84538891290.29.C22D784
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 48A7E20004
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 22:44:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FEs5j9oS;
	spf=pass (imf03.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773355463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MagPqVsbkz0mIL5nlBd9cVPZ7LxdFHiUc+nKZ0NPEYs=;
	b=S81yh0ebeaMyqtQ8DRTd7zuYXosaeQ8aZp0o89Pc4Rjzs63q04dA5l7WAspdVVIwD++ClE
	Nizz3gYwpf/7YyR6QEIE7KRUW4u6Ax6MIw/wgoUn0WV/+RWUwKfCCk8dXND1eTb9aQVHKP
	5tLrfwekFng4g3t3SpiisokkUpiW/oA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773355463; a=rsa-sha256;
	cv=none;
	b=jTHjbPSckq/79+hb+iFzZGyY4oqlDwQl/RTTvQQSK/PHsCC/mUXZq8dBBpOLwjoXvNjgpq
	OMfr2dXDugUEEM/pyGCVn5Kgl358jAZVcqRpLLuS8pq3BOn8mIguhNI40PanEtB7hGYnaX
	DpI2U8WErV43lDOatOdK756fbh1AxAI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FEs5j9oS;
	spf=pass (imf03.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 601914434F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 22:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34383C2BC86
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 22:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773355462;
	bh=MagPqVsbkz0mIL5nlBd9cVPZ7LxdFHiUc+nKZ0NPEYs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=FEs5j9oSSv9qmxXAP7HGJxCzg9zFwU/bpRr0BDh7y+IlVktt/8vxoHm9F8SWod3yb
	 xN/huMkckl9svPCk8pfPZ9MpKEuQ6M0sclA5uYSzmrbEKf6TIvVdSqpj14nwTiqU37
	 GnZsIrcyB5aWUa6EWJ9USMzFzEfkn32KfJGneuxxHhsjfAPW4Ail4Sq/04Rmb89xip
	 XImI8Np9mUufFLG0oFAE4mnYpgGveztlp003GPJwJsGYhAxcqPBldnzD4pIe5jXun8
	 F1/Y2XVE8r4zI8jK/iMOc0jCbBbNoak02rFAvRxWDLEXWry2y4TZv2A+8cbcJFxEaA
	 Ut+LA8AHuA/ww==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b96da7b2e2eso233537166b.2
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:44:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXt8BrdsaRMszxC9lA/YQziUVabTtxzGJSyU+0QwYKJNLqfgY9TD4WXcnAczckKCqAd0NHSyAXiOQ==@kvack.org
X-Gm-Message-State: AOJu0YxpmcZenMTUWdiyOYtg2O9Z31EMBFOyQYCz7Rleyi6endJ/Aevd
	I+AuBqOa//HSoFlDRMjDR+Z+BYPVArAg6ZcEnQzL9b6vkcdDrgXlnkPpChYr5c+lZNhZ5Mz9LsZ
	6QiL6x+mOB9KT8eHn23DBoKTwy7/kfhw=
X-Received: by 2002:a17:907:3cd2:b0:b97:3bbe:e42e with SMTP id
 a640c23a62f3a-b976514cb8amr58819066b.33.1773355460946; Thu, 12 Mar 2026
 15:44:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260312040627.55257-1-liwang@redhat.com> <20260312040627.55257-6-liwang@redhat.com>
In-Reply-To: <20260312040627.55257-6-liwang@redhat.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 12 Mar 2026 15:44:09 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNfR5Z3g=SkU9-eEeA-DDY=rp0Tcw8sXKYDpkZtJtQ0sQ@mail.gmail.com>
X-Gm-Features: AaiRm50vDEtOUq0fV0iULrsrYBSyRiSP_BhVBXrE0buJ28vyLlqKpO06m_wmxQg
Message-ID: <CAO9r8zNfR5Z3g=SkU9-eEeA-DDY=rp0Tcw8sXKYDpkZtJtQ0sQ@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] selftests/cgroup: replace hardcoded page size
 values in test_zswap
To: Li Wang <liwang@redhat.com>
Cc: mkoutny@suse.com, yosryahmed@google.com, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Nhat Pham <nphamcs@gmail.com>, Tejun Heo <tj@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 48A7E20004
X-Stat-Signature: zph34c4qrc5z9s8iapfqmq18uxr9zsxq
X-Rspam-User: 
X-HE-Tag: 1773355463-194297
X-HE-Meta: U2FsdGVkX1/jc/icQUPi8SofcnIBsohJExHrGXzf+xmOpc2Bl4L/znJN0VMviRnDhHCzeXiUXR6lvftKSIaHgHFxzg3NhKb0TiZy8pumkan61wbwwm8OXMWRXhjS+4evqFkvACkZhGSbD6gPMuB2cZII2nMZeeNClhDg7+fy8M/74WsR9Xp0iLLcWyoTh7OlAn5E5ZOZ8BAowbUghBheqTLM9ASEikgeIw/ROw38Bu9dBiiq0mQBTUowlX4lH6o1ELYoJRWsCD643+q0BnG6LkI6HxgeKJ3HuW/wE/Rp4yHAFGC2zGPMeLSRwUZkAgbbfmhTTnTag+gOe3obK+1cdPatqNgt+FoSqp9lQ2ASAqksIC9NDeQ7w5OEpnSQoPtoir/fPxQGh3ph/JLPG7Njpz4tHL7ZOi0Fx++TAng3+ZdAKUPqhuLZCva9xDpT1Lk65UwTTHp0dJ/FVPbwE+PNFPUpnFrGfw+r5DbIrQrBOQ0EzttUdn+Nxt9EBc706PkkDAZASsW6AogWPyFVMmkhVXQ9okjYYKlI5RDDRrGlL2L18PC1JB7+MqiTiSY8bmYaevYujHDfjh+b84rcN6q5u306HSFrTCGusclz8Vc6+Hy7rzsJwvgGyCB38Hu9N+McNIIFzfl7cjYUnsyLL6ffn6BaHQ1II+h6KKKLC0tgrZXvvxSXDcCI8S60Gdg3W2P5QrkcBPMbC0OkCbDWhIKLIFBa1PmNb7oRdvQZAUwpTjUkp+/zTWjbxK7UL9ZwloJo/lK2MGobtwz77zDp0Jf/+kA7lugKHOiYcfaebOrscFzrtCvB3povBVwUPMvJTBucglXTSZMXf4slbUW0Ie8IrdmFl5MlbLZvU0iMxvZNU986GHG2cLkrnkaK/cP8vZIfeIWL/8q0N4lc2DliuBJ4b384WGARtdT+z6bSNExUbfMX1HT8EmYrlp8guNmIxsDDd6820UJR6lSmnJwm3Wk
 9IiQLYwU
 sfh/dwSabYqve/ckq5wa/p5RidcIdjxiJUpDesb3ksTSGPXgQx/yZOMUaUN32rgbfkyoxLRw1U9M3N+fdav3VgnrPif65uoO90G3Ws4VzsywL/8oxZLJ9LzrhuX4Gowdgyu7+9JUM3P+ooQWXW5TvCCFuSMPNg/UX/9AIzQGSsq/GXLuOf4ZMSqmPVZRajIiNvBz2pMSmZbec4NsPdRdodcgOfcTOVEvDb+9Ibh528LafEEtA6Ng8GUU4hC2zYgwbdvRNhdsOAwFyB17sPS8bB8ZvTk7uQivc+7k9MXuz5ph/qMT1BysrdtLqzOKq2ddUPznXb/82yhVJ62DS6XveT9CpsyBiJOu8jbpd8BZUjF+Tz8tUgMkK4h3IahzN65AWNwziPt/nxvN0rFzOahtcz9t2B4TxWhHGDHjLbnZBG3zX8Lio8Y0QVAOni7WpaB3dJerSObO/FtUtEfCbiQsrYS+yZy3TKrNAJxn/1hjjdnIg6whLa1lprdKOryQhcseaCaxC6cTIRtTu7yJo6IB6HvxDHWJQNvuXOI90
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 9:07=E2=80=AFPM Li Wang <liwang@redhat.com> wrote:
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

It makes more sense to have this patch first, replacing all hardcoded
values, then patch 5 doing the necessary changes on top.

