Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B4FCCD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 14:18:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7531B6B0005; Wed, 10 Jun 2026 10:18:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704156B0088; Wed, 10 Jun 2026 10:18:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 619DC6B008A; Wed, 10 Jun 2026 10:18:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 50FC66B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:18:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D017D120144
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 14:18:10 +0000 (UTC)
X-FDA: 84864207540.09.4F4965C
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf28.hostedemail.com (Postfix) with ESMTP id 960EFC000A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 14:18:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="J60w/vow";
	spf=pass (imf28.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.216.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781101088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TtsvHh9Pn+Rylz6+XRT7TQz3RFIWkIYkOyPrXmDgVAQ=;
	b=lE8o9AT6n/Q2faKOp3pqQLB+Jw2uI+nHtjZj0TCGjzprypmW7AL9Wmywcu/DTpc8oKxD6L
	XlJgtfWigch0xbkOvEUzyr40NAHLdFkQWMjNQMlDxhOlHvST4/oYhnktYQuysbkOw+Opxp
	P6viZN6g3JwxtGtO17NFQvuE+gk5b+0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="J60w/vow";
	spf=pass (imf28.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.216.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781101088;
	b=BpQYWeY5gxoAsXYuWyl7tjMVM9ZfQHFJVNl29q0pbss5y/SjoPGKz9WVVcM46LHu/26oDX
	SvXVExNnrTh4VW4icX2LpT0F82yMBqFqYZPsxlDIPPLFDs10w0fxDihIC0eIv4IWl2HWNq
	xNY6VZvtoCHs7feLrOPCV9jCRsxVfvA=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-36d630c0e35so7368103a91.3
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 07:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1781101087; x=1781705887; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TtsvHh9Pn+Rylz6+XRT7TQz3RFIWkIYkOyPrXmDgVAQ=;
        b=J60w/vowbx3gKmPrDWmljvjMF7AbZ1GBqYQO5hgZQHbV9nvNWCnyomax7VMTjmKMvL
         viYuk+9s9OmPEmhDqF7DpeoWUY1GjTqccNuOGZsWnKeOl6Gvn4F2N7SRT7rM9RgKo0GW
         9QvDZ3O2oqP8/JOm79k8VlXcXACQK0JC49V7w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781101087; x=1781705887;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TtsvHh9Pn+Rylz6+XRT7TQz3RFIWkIYkOyPrXmDgVAQ=;
        b=AuiZaXycZZg6hbNZ3ZVdItwJqFzecAGQLEdp2uP7EOPaSWs5nFUAmhjj1psUDnI504
         YkwIrdv7zSkmllvr+EIENjZwp/9b42gLPkX4mjScY0fY4VDOhiaTTQZthOB2H2en1pSN
         F+GAqmOiZDxWH4P7yLOkga6prQoTJaj9EaMp1ReDAPWxTD7V09lFMsqQwOtUrjKqWLvQ
         FGl6CiJpcP/p2yhQ2d3iwuFb8JuKjr/vpdib31d3iLLxsblDospa7ga9LBetoilT+G+t
         GZquT8A7GaSq/KxUKuRO0awCuk7laETSswPiB2cZyuWeqZeS20ogYUbt8bA7OZFkWUd1
         9tug==
X-Forwarded-Encrypted: i=1; AFNElJ96o1EJO+vkH8X2upGsrgiFe/tZVVNE0yIUsp92ekiTfvfNveF9SbPkWeIwOLxX4ETW5QzjII+1Bg==@kvack.org
X-Gm-Message-State: AOJu0Yy/gpuS9mUNnTbZv+q2x53qv/g0kB+t+QzcORjJGmoJbnEJbNtX
	ipEjN/74t1/W61aiqRK07KAs1uJxDZZjC16cQsfLDM8LP/cdCNdVOIFEdUAUIBYByLd+OIkBbx/
	gtOaWFgE=
X-Gm-Gg: Acq92OELrldlP43USgmEy6Pe9HeqHLQew7NXtH/eFapYfvZo8hOyLaSTbffWAKGOTEz
	rJXn8EfM4ZWo9OKQ+kwWAy1p1HZSgSjwVwR4AwlAa6A9qd22p30KT82uexISf0qfF3Jqu+ozjb2
	Bx1O7WC+BPERSCxwFDNFk+v+Hy0jnFbP57RtkZ3+tYAnWW/KqyTliNNGxf90qTHiBEz4f0RFlwu
	jDU7gDOjczIT4k7MZD7HL2Ep5xfpDcoKbO6IpGNR2W/Qjkj15bHMafJ+NNiTVQiJ3mIdSgY3XYu
	Y7d1P6Vf99XgKmTlV1qxx2g0xYYNthc/qyTNg5HkOet7YJCvKXURjLKgnefbemjoLk4dcGawl+2
	dMp7sC95gVA8dw4agRRohgrsNybBdvcN28mx/UhoUfbYqd6P1GWI/6/HPr9uMaIxR0Y3t+OIMNe
	bmvhkn1W56INqx+LGME/QMfxuOk/fUDhtJGfJGWwoBl1H/dmdcmsYZ0XsWDWeUNYQZkRYG5GL77
	tGJiTclntz1e+8=
X-Received: by 2002:a17:90b:5787:b0:36b:8824:d7cc with SMTP id 98e67ed59e1d1-370f057a115mr28498615a91.20.1781101087384;
        Wed, 10 Jun 2026 07:18:07 -0700 (PDT)
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com. [209.85.214.169])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6bf830b2sm21445722a91.4.2026.06.10.07.18.06
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2026 07:18:07 -0700 (PDT)
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2bf30d530bdso67883535ad.3
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 07:18:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+K1xnUEiQ28QlGgAWZ5QehY44x85vRZriPKeAb6eBvKLPHkTEsY543RqG1qaB/dO4xkkcng/zVqg==@kvack.org
X-Received: by 2002:a17:903:244e:b0:2c0:ab92:584c with SMTP id
 d9443c01a7336-2c1e8209b98mr287326215ad.25.1781101086478; Wed, 10 Jun 2026
 07:18:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=whL0oLvmh3FO9SapDhgrXMT_d6qkP2V3OBjysOWXod2Og@mail.gmail.com>
 <aijyuX14ahOf53zM@gondor.apana.org.au>
In-Reply-To: <aijyuX14ahOf53zM@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 10 Jun 2026 07:17:46 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjeLy2n9H82_THob=wzOEfsQT_yP05ZH9qY7NTWgj2R_A@mail.gmail.com>
X-Gm-Features: AVVi8Cf89LEbA8IWp6kUXfdfvHtLXSvqRDQpEPExTR6LsZaq3LaagKRbHX8i3Yg
Message-ID: <CAHk-=wjeLy2n9H82_THob=wzOEfsQT_yP05ZH9qY7NTWgj2R_A@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: metze@samba.org, luto@amacapital.net, safinaskar@gmail.com, 
	akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org, 
	david@kernel.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 960EFC000A
X-Stat-Signature: kqsoyto7yqpsnxhhrj3ks95mn8ibq9pj
X-Rspam-User: 
X-HE-Tag: 1781101088-448694
X-HE-Meta: U2FsdGVkX1864/24AVoAoh+7tom8LJHXtzwt9gp1GB0kFKPtNm9o/zTbzyLe1Tpd6pGiKFVOFMT+RNubeepnurm3Lk7XzGtG8E9Ek8kdGZ0gILswtS4bIcTNMFz+r7ZwO5hUpOxZIWhOXN/3jlPPQCY4kja1CB+wUIOeX2Hy+Cl6VKL7AABcK9fSCfsx3+2ULzqGJgpCQDdypZPx0qjE34QaJlg8W5M0Ri9rpvgDl6FeUuAggd4SbrgccPe0dVIDOqiXQ0K8UKaEZJ1mMbasmwM5hTUMQAZWi0/A/scqo4Efm23WFGK/5yf7zp3aLqEEyTGeuXRh7e1vL6vS4M1NPxDH9MDRYsrsTokWPst5X5WHyOraAJoqdXoS1MiAJ1fIySWSbgoOZEElSOgO0E//IYnXNesrTCpmcOH93LJBd5ytlzxgUnCcDU59KQqUV5mB9tNulBcZi6qsgdjTVcOi60W2/MKYYv8M2XC61fpCniYA+eDMlAy7dsO/KILRxY0/8gY5yYEsmgboWtoQ9H0RIaLPNIeynjUXKCZvdYuJoylGDgmYvLqSNKrkoX74WcArqs4KGfvWVjW7rM2zHo5CQLXpc9OidAv6ZcvTjSBLI71W/0frWBtKhVwbDnfBz578NtvZHLNnRALfKFBOAX7sPAPI2Zf6mKfssbUTib+C7JWhTCPKpd2Zy0OJbFZaljeZ10AfavkxwVwZsuFLMxltxZbeyw5jNn+4hoKN6OKfs6968RApDF7M0U0oI62JvA/yeRuAz/04CWDhKEfJHG7e1CUx1d7r5NFS0g8W4MmDbnrzLx8Bf8M3msr6MR7gZ6WXgKsDs9UnejEpa/H5jsnNupdITsqvdOssWEz05TIWRTtjdCShO2gn226wURppAa+IuTc5uZjSt/Q7F5qYXsR0iRz2IpBWXdNBOXKQEudQ0rnQB9MEc2u7TGYnX1HK0cUbx0cMFPsdZvdrxogHmza
 s4GvY35K
 4Sr5rAzYkTGpSifUBtDOUgNvVwkMdjDpG+5Cmu4UTdg2sV3/KFj5NuY6ygDKV3cOQFVR9L0BSHLchWLjyteLkXSGCrE7Qb4J54/tcodkHAdgMB1jcQDfvbBYGdQeWoDgPyANDoXko+BSEbjGiZXab25IIpw9AO6yPFV3BBRswiipuMsQHeEQWaj1T/z0KMFcPcPmMFJZlxO9r5uhKr5UJWZxP9Hhv0t8uE0X/1jJmnli6if9KphPZcG8uGzp4Q6U023fVhFTecSrkSmFl1qL2rg8y9D/xI5uuI3m1eMd2O9ohFSTsvPN/MxlUBx0Fhy15emSifns2RFlF07NCFJaUjn8Yq6gvD40vh4KmvEc5NpdSQ3eBwA6p8vxu3SREg2VUyQrmFGtYOz2MX4jHWIVeqr/gg1iM5jMWPYEKdMbT1dlCFxY2clGgF0H4IlTL2+hwACNBvuDTBmuOk8V951g7dsBVP9RcL6LdDAPcCemrXKwso+PBb6647nrYQAUJ8DbEw6l7P9O1eZG9GNuipv4Nrqo+RWRRfRlL2UduIjdz4lIGokQgNk/nDS3F+yQ9QtUqr0pM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 9 Jun 2026 at 22:14, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> How about using write access as the gate to zero copy?

Well, it's too late now - no sane user would open files for writing
just to read from them.

And if the file isn't opened for writing originally, it won't show up
in the fd. So we'd have to do some after-the-fact "is this writable
using the credentials we had at open time" thing.

Which we do for some /proc stuff etc, but it's disgusting, and it
isn't how any of this should work.

Plus honestly, in any *good* setup, the normal case really shouldn't
be that the source is writable anyway. In benchmarks, sure. But in
real life? Hell no.

If you're doing web serving of static content, your web server simply
should not have write access to what it is serving. If it does, your
web server setup is simply hot garbage and probably riddled with
security issues anyway, because you clearly spent absolutely zero time
on any kind of "minimal privileges" model.

(I'm not saying that splice would be primarily for web serving or that
serving static pages like that is an interesting load - I'm using it
purely as an example of why saying that writable files should get
better treatment is crazy: it's not how *any* of this should work at
any level at all).

So no. We should not treat writable files as some kind of preferred
model for performance. We should discourage that kind of behavior, not
encourage it.

                  Linus

