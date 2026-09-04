Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FDC4C79F80
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 08:13:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 135716B0088; Fri,  4 Sep 2026 04:13:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E80B6B008A; Fri,  4 Sep 2026 04:13:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F17146B008C; Fri,  4 Sep 2026 04:13:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C56596B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 04:13:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 62AA8A0A57
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:13:17 +0000 (UTC)
X-FDA: 85175364834.29.C4A07F4
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id 95178180005
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:13:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gIsMHlr5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788509595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0pDAJ5Zbgk6FV/+bTUIcqCISS5VxMKMSD1bvgwX22t8=;
	b=RHi3YGj0r3wBeihiOZX31agETT+78HkYoIZxVAVdvB7eIdfESugZosrew9tOEkR96r5q3e
	b7gcJLt6EHMuL+1ooQiZGRJAZFyE+Mp5EEd/QmBy9B8jBmQ97/rihHXIcYTzUt1DK2tVzG
	I0How1m8OH6q5uJ7Xc5M+oUQ5pa3c9Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gIsMHlr5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788509595;
	b=kxeafqfAWRK5JkT1YwMLjOoKcjnAqdae/a9ErRgPAGWJCD9cwxLN3gz3V0GAPO7etvIoKV
	xKT+qg0+U7EsdM+hzMRBNyoblKbRIMrQIsG6G8scym1Dy8brMkCJ7js29a8QAkxceBB7CL
	rFdiAzNaIgOqrWqcXm/F65NNmyKBrgU=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-84830c774a0so771506b3a.1
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 01:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788509594; x=1789114394; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0pDAJ5Zbgk6FV/+bTUIcqCISS5VxMKMSD1bvgwX22t8=;
        b=gIsMHlr5fjTWlzKJp1jgDQ3oZhdyasXEBbsZBQk55HgB62xnjgi59sM1YovQ/Qi3qU
         1/KflEhgN8j93j2DxntPwmqq9Bc4LP23Bmb6ECs4aGWjuqXPWhopq0MgJTP/5enoDuBf
         qheE7D/r2U0485HvcesJBfBO/nlXIvgU1/NYU9Vk+oA73zXNOIpO0TXR6s0ciAcBXy4r
         iaUs7e1C6T+fDA5GF+wamSaItmLZKOmdGjh4v8MjFggi/7hDoALwASR+LB/VLaCbdlN3
         5Zgy4LyCiCPon1T2NDzHi1zOqokhKFc9tPWMHKNlCaVHrwB5mAP3zT2nVHYrNWIsF40y
         7Csw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788509594; x=1789114394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0pDAJ5Zbgk6FV/+bTUIcqCISS5VxMKMSD1bvgwX22t8=;
        b=dnnTcieCUqAhOKXToD5M8+3oNY3MAxlWK2+AdPcLPT/ePwfFk+7qmk5qKb1ZyCgo11
         RiWrRwWLYF0mkppfld5WfnXvDlwjs0QSfy7p0lJHWmoDZVwcnCnBxQwIQ3XHjBo7ZF81
         tfLi2azMGSzWaxX0oqmvUMCWROIEhG2TqD0fU+ASLNtMYZmVovEyRRl49XGs5tmtJoZ6
         XrHHgReRswsaHxyuxbMKtCKZaWhZ/NT9DFi/JKIqPOFisMFbsUWVDDMZicogK+2A6ZSw
         hcA27a9OYrkpVX4LKofK9QEblPSiDdEWZxoc1TcqSIIgQC3Z0JGgxOOOEGZhZXPWzEHO
         c8yQ==
X-Forwarded-Encrypted: i=1; AKwUvBzb4gQZJrr0uGj0AdSBehwl7krCUHgfDhjOVHmm6WRvqvhkZBHf0B331eTudaAbkMQyrAuOgK1f9A==@kvack.org
X-Gm-Message-State: AFuF++nS/XGGh7UrVAqI62OjSngO+FhJmguzNNM4dsll1QAzBoYJ46cB
	HaqcgT5dgKXinBGa4jUZf95zDjHNOx5DoAT8Zyn5znwnXsPNxwWw6oth
X-Gm-Gg: AYBFou1uSufPh3ecGlNu2OzDzapOnHHUd5u1K1oYAMjfRyCJzdtIihRgoMe9XRRh+00
	1jI0XXsBJkb6CeKrngq46ZndZLjadwIs5aRpPYMpjp6OyHPqRoRQtRixyVid5PzKgk5l9bfFSf6
	1sBFex27taJsZMdX3oCaE73LlBqARubK7k8a7ldjR1z+TMztl+dojIMj+BQmYJ8R9uxa488Y2in
	PzUXAZ/3XGS6DVt4DvJJ/9epyVSzSwVxrcy4Urc5vK3j+4So8jOd7+KZFeBkTXCTpgIjRmPnFGZ
	PdvHYc3QCbACJ1Iog5XsBMFw7mvICDIIA+KqLAGtYkFgjKbHOf659mZgROBhkoCSE2oOOEQN4Sz
	RbzHeNrr5ziU3WGDH67BVah3R852+6B5eI/MpfwvkH8xTFbxZ0lADBsKpMRfNXezxf20pxj+A3P
	sV1xUyYlvnyb90vBED5AE9Yui7UjvX4GnVYQ4rwxnoypP8Mk06JfHXBkaKax8rBGkMnMPHQJ9bE
	z6Hx/EJfIYUQ5E7ybg=
X-Received: by 2002:a05:6a00:4289:b0:852:38ea:3fd with SMTP id d2e1a72fcca58-861676b276dmr6641062b3a.11.1788509594279;
        Fri, 04 Sep 2026 01:13:14 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:8929:bbae:36df:3680:44d3:b5e1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86152c2a52asm862512b3a.30.2026.09.04.01.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 01:13:13 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2.1] mm/damon/core: fix false positive in damos_quota_is_full() when esz is zero
Date: Fri,  4 Sep 2026 16:07:41 +0800
Message-ID: <20260904081324.3972-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903140521.98604-1-sj@kernel.org>
References: <20260903140521.98604-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jtciwg69p66czymj7ctaait7611515km
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 95178180005
X-Rspam-User: 
X-HE-Tag: 1788509595-221676
X-HE-Meta: U2FsdGVkX1984T3hbua4a7Y2V+0lNSTBj2CHpPN52TxZN44qCPaBx9i+PT7ZcYVq0Egd6bQd9qoRjV+V3TDNLTeJDIU59r6BLQF/BO8U5Di/O3lVi5xl7faZAYtlNdjphLEcSxQxVJThh0KBywwFx0dEQRo7i72y//g1lrGdoXx+Vt4XqcAabkxKApvKZ5oNYBGBF9rdDDUSSyPtO/yU0QQrDZ9vqnSwzqyI/2DANBrdyfFZi9e4y6saOm4k8gS71QlcriR42cy5YZOusU9nu79RQo16w/GF3P4Hr1Lz5JvR/Uzs7vQu1CY+O3yI4cqQV0hgveBb9DvXqttUIl8SZzHaKT3IXOZfA00UFzgVq2T9yjdyQ1XD+/VcsQKOI17LVoCOyC6HtGLZEdaP834lawX3deSWv3eQopqtUMlSerE/65/drN8KhLWFe9fNAqohhB1Py3/xU3GvKh3jHD1renj75G0Yr6CWtFUlJnFyHR98Cr7bD076d9e/2r3x0o7eKhjp5u5XI3PLyUfFrd92cqE5Rq7dXvO7eqnW+DXwlSOcfHzPlLmp7A4Ls6b79Y2gcrAkw75WZVM7c3w26LmSD34siJTnqHGLupAzNWoW/iUSTI6u1xt2cIU9cPlf6AXseZg2ggLH1fAcqtGvR2bNSTM70PlvyBJ4Og1c/2+bW90gOSQs8pde5zgi6C0ikeyuOahAoKqOGXlXXagY+9OCZ1ujzrFz29nBXeZugS8fvKB71fQYcBannQ/mQFM8SarTBVvbvz+lJA6GtnWSbR1rWIpUoiS7HNR5fmWLXDbzo2Pxa0o59/97T8HIJCJrEeMPr0zpIaiJvJv9Pgi1GO245T+nKE0eFxAFECRSGCp+pkBi7SHPGQ1Z8BvLcYlfBUxLtD2hR4w8yXLx+bEoMH+1PeDD86Ey2oE2zBhNrBdIRoVqTzrf2eMMND8ihTo2IbcTWEiV9ES9Yu5pviCCg6E
 DStocxVK
 8CNVWl92y8q6kqkLjyKlgJ8Qh5457Qk/0GBfwptGxXJY7seoXTjd72uKvLunjvldgK/Bq7bB1RlpnOGMa5ZG3q6oCecRwbcpBTqm841StsOFjCZJaSCgxDLmpMi1IT8VhGPoMBpYkPXiSpw+uX5U+AiQaHSZibsJ/wRHykkOWz20KTwLDCzizLEtx2V6oUukUCXKjIFmbzVpeihTIYTiWo59lTLxfsjq0Dz78I+vEFa6mqXr3NkJIg1c4AGi1oBkDiNPRhM6HlOZMF1tmqBz6iTizmdA7thPzdip2ip6x3vKOvrlOFfbVxOJ4mSuET8s8Ck2I0b+Zcj/NL36HCFU6qKzrwmG0T7QvMLH+R+autFkHvUuKMFss4lOiC7jPqP5irex/zIKwsSt/xOhqxjv0jArH6Yi4HcjqomMUQlP2Xosp1jlCe2JrdsbJr3T5xxseqxu3l0gJdWig1c3Xgk6rKjkXKB90iIB1PPRABuuaYl7zdiE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 03 Sep 2026 07:05:20 -0700 SJ Park <sj@kernel.org> wrote:

> On Thu,  3 Sep 2026 20:41:48 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > On Wed, 02 Sep 2026 17:33:50 -0700 SJ Park <sj@kernel.org> wrote:
> > 
> > > On Thu,  3 Sep 2026 06:31:38 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> [...]
> > First, I would like to clarify my intention to avoid any
> > misunderstanding.  My actual goal is to fix the semantic of the
> > qt_exceeds statistic, rather than necessarily changing the underlying
> > logic of damos_quota_is_full().
> > 
> > Currently, there is an issue with how qt_exceeds is incremented.  When
> > the quota is set very small, qt_exceeds increases frequently.  This
> > produces a statistical trend that looks almost identical to the
> > continuous increments caused by the Temporal Goal being achieved.
> > 
> > The original intent of introducing qt_exceeds is to let users easily
> > notice if the quota is too small.
> > 
> > Commit Messages [1]:
> > 
> >     mm/damon/schemes: account how many times quota limit has exceeded
> > 
> >     If the time/space quotas of a given DAMON-based operation scheme is too
> >     small, the scheme could show unexpectedly slow progress.  However, there
> >     is no good way to notice the case in runtime.  This commit extends the
> >     DAMOS stat to provide how many times the quota limits exceeded so that
> >     the users can easily notice the case and tune the scheme.
> > 
> > However, under the current behavior, users are forced to manually ignore
> > or filter out the qt_exceeds increments that occur after the Temporal
> > Goal is achieved.  This adds an unnecessary burden to the users and
> > contradicts the core goal of making it "easy" for them to tune the
> > scheme.
> 
> Still I feel the problem is unclear.  Why the users need to manually ignore or
> filter out the increments under what situation?  Knowing specific and detailed
> case would be helpful.  Are you or some people you know doing that and feeling
> it is too much?  If so, what is the real use case?  For what purpose and how
> DAMON is being used?  Why and how the ignorance of qt_exceeds is being done and
> how painful it is?

First, I'd like to clarify that this isn't a problem encountered by a
real user, it's just a scenario I came up with.

1. Users sample qt_exceeds periodically (e.g., every 10 minutes).

2. Within this 10 minute sampling interval, the counter aggregates both
   the real quota exhaustions and the increments caused by esz==0.

3. When users notice a high qt_exceeds value, they eventually realize
   (perhaps by reading the code or documentation) that it includes the
   counts from the esz==0 state.

4. To get the actual quota exhaustion statistics, the user is now forced
   to perform additional testing and implement external filtering to
   separate the esz==0 increments from the real exceeds.

Even if we explicitly state in the documentation that qt_exceeds
includes the esz==0 counts, it still burdens the user.  The user still
has to figure out how to filter out the esz==0 increments externally to
get the signal they actually care about.

Honestly, I struggle to imagine any valid use case where a user would
actually rely on the qt_exceeds increments caused by esz==0 to make
decisions.

If the only purpose of qt_exceeds is to let users "easily notice" if the
quota is too small, forcing them to manually filter out the noise
defeats that purpose.

Best regards,
Rui Yan

