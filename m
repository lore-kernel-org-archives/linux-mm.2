Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DBD5C44536
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 00:22:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 606036B00D3; Wed, 22 Jul 2026 20:22:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B7226B00D4; Wed, 22 Jul 2026 20:22:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CFA66B00D5; Wed, 22 Jul 2026 20:22:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2852F6B00D3
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:22:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8A03F1A0375
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:22:44 +0000 (UTC)
X-FDA: 85018140648.02.3517B2E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id E4C31140007
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:22:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jDuMU6Ck;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784766163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s+EUYRbTCsafx3NRNiOhqGf1CkM1sXhNleIDSv6QIi4=;
	b=18pfSrq/Fk+YnPtTPYpH5ocypFpM2BhsesJ4CMHEZNqCDkoP/iiOc4BplFKkl4ECqnSeoc
	j1Ljll6sllg4A2qTV7ouzvjnp4VoqULCapSX4RpE5XYgyLVGx73+8TMmRVBmFiuMYZ/BiI
	J8vGKwYBx4F2CJVAZIC1acx5aokwoCo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784766163;
	b=s4uAyN0qNAfJbcQ9+p4ePlvGWPuiotmDP4iyKBzh+a61zVPszumhoyxXa5tDWU3ACo1M9y
	AOx11mchjU4K3a5IYOkGgTd2CYfq8cugF+yWtkxz/BDIrMg/n+OlGK+z3GSWfd63WJdiUE
	TzxU1mrhCnt2Ts3MLwic5Eei3Rro2D8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jDuMU6Ck;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 31B0542A3A;
	Thu, 23 Jul 2026 00:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51341F000E9;
	Thu, 23 Jul 2026 00:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784766162;
	bh=s+EUYRbTCsafx3NRNiOhqGf1CkM1sXhNleIDSv6QIi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jDuMU6Ckhmka3jN+SkZfzLxTv5XpdG/Qio3YBcXwyikvGNSEbWITRENjrCgxVsTHr
	 qGsgyMpjal3mm8QyAzdV2dypu/cmZ5yS8kbiZ0zoRZkNEhakkccDCnoAp4PAxClCmJ
	 jn7Re2ckKUV7SIcQG2NSob9glzsVBqlltDu+nvNg4RrFs6HHNSKJSX9b8jkgjtYwYQ
	 QJ+Dlz4dBdXVYcmBKQZPeciicDxOY80tSrxnS+XYNiREArFhUTWjhfgkD2eL2qsUfG
	 9DboB8nljRaybFb19I+cG4YRUvYOUiB3oyvtdZhl2ocd5ur4RA5Ts1L7m8bcl50lCV
	 qWBfhAdivTWOw==
From: SJ Park <sj@kernel.org>
To: Hari Mishal <harimishal1@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests/damon/sysfs.py: clean up sh processes used for obsolete_target test
Date: Wed, 22 Jul 2026 17:22:38 -0700
Message-ID: <20260723002239.95987-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAMmC+=BDZ6thHptTq=yGvfygUQb+0i2QeGbKXH+OFcXpnTXv1A@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5iehiqos9fkbyo8my6p9es5w89sp15io
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E4C31140007
X-HE-Tag: 1784766162-206574
X-HE-Meta: U2FsdGVkX1+S851iEjkEt9yXR5PXTpzAVI+DHiVj0T1pyLjr+v/UGlzmnkJqlTrxhUJNlp2YDWNBoIKnHDLEtNiJ99hZJ6bck5iGwQQYFL6j7YQgqpDsrJRyBdWh2ec1arQZDCeBlZMQ9KTpexxy0Xu/vspifnyrN3DlUkclkwi6Cu67DOdC/DPau7NHhXVtzHXlF//EgmuHusDO1gQYmVDVEaZepYF+Kj0RKgp7EiPD1nbZTqFSu9MX6wKpVtMauWYRgQCge9y9KYLwau3p+d8883sLLx/J6vO426cBfdaVjcgOmao/AXy55S43dVBrs//3LDYwmJS1LJ9WvllujCr0jFxz5b+HFtMZJCMBfXp13KGx6jLOOFRKwR8qXcj+2H5/wGHqsYCJ1svm1PtCcmmsJnSrYBGrwM1CJErqVerbNjZ//lZNgJNGV0Oxz7xOvhUeVFqnQ3AWaRC/ZJ6y865JAJt81ZH1pL0hPOQ7HzZL2lCiFFimCyFMVPHO3XyX1q3Dz7qby01qZp5ylay0MrL9e1LVlU7w7zoBd7Soio4I3d3JWBx7DCOYgSODi4fQ0XHUv7JCrXsZ0sjOnva0US/pwJXKiylbake8CuoKWlPycB/4HxwgJ4SFqA0DzWjbTFoy/ASUe1kqctyyCaME+9pdyXiaJWl1VhMMhWXTiHFj3IdlV2gjxubwDH2GcWjv9qIqpaBGH+LmqVhr/g+e2fzsu2kkkS6815XxbMbiZrf5Rw3zj6VMTf9wc4FYv4uBwDXI4PcnhxO3QA3p/L1JejHDaa+ka6lc1Voz7pUIv0uyC2SNRjv8ZBzDy5AaL4ZBCZ46xWBflJ5DXvJOzpAgIOtccBudh+k0tLHaf+WcjdnwD5eTO7Uv/942cnmPw/tg7S44i385OiYNW23vUM/YzrYvFx9wTohxSRZlxcd39oYxjYTi39bG2awI0pbpY5GjRV8dqnUG0C/2AgUyK1+
 0GkLbpnB
 /1L0e7ahRPKawXkfKkv+NaDSfgFYSjV9IuzMvs09Pe/+uMHRqxYWXO2We7xz++6Eg8ocViHMrTf0mwjM8rN2vyz4Z5uaV1KJgJzd+35aR/HuajEgloGeCd5oYJhVed/+B7BbYBLpKS0iOoFpoY2HJP2efmcwmkG8kXnS7fab7GQ1GNnBNNDeuREoaNjkR1p3XQOIP1eoQ0dYpZLD/1jJOT8Rp61L+yxuUK32FF+VtfDkXP3rF0FmW8DGW6c+LX3ImN1zbDegQdV181klWWtso0BOCmevNfq8qdkRIosDGNSs22jk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Jul 2026 21:15:56 +0200 Hari Mishal <harimishal1@gmail.com> wrote:
[...] 
> > We (mm community) now want to focus on making mm.git more stabilized and
> > therefore ready for the next merge window, rather than adding more changes that
> > are not really urgent.  I agree and want to help [1] that.  For the reason,
> > unless Andre pick this first, I will request adding this to mm.git only after
> > next -rc1 release.  Let me know if you think this is really urgent.
> >
> > [1] https://lore.kernel.org/20260722133829.87607-1-sj@kernel.org
> 
> Definitely don't think it's an urgent change. Anyone who is using a
> tool like damon would be able to debug this quite easily.
> Thanks for clarity, again.

Thank you for confirming, Hari!

> 
> Accidentally dropped reply all AGAIN, sorry about this. Resending to
> make sure everything is public again.

No worry, we all make mistakes and learn from those :)


Thanks,
SJ


