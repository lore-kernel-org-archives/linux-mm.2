Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 389FEC624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 20:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2CF06B00C3; Wed,  2 Sep 2026 16:00:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDD766B00C4; Wed,  2 Sep 2026 16:00:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCD156B00C7; Wed,  2 Sep 2026 16:00:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC2A06B00C3
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 16:00:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 263D114038E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 20:00:23 +0000 (UTC)
X-FDA: 85169889126.04.38D773F
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3FE40180006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 20:00:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TK5oyqmD;
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.173 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788379221;
	b=JR4Ht+1ACro1zie9G79+oC2ENwuy4p3M5Z7i51fYSQWW5tA9M389COHaksblsTszMpgTnb
	MegQQxYFyifvXiMcOBugzKwuSkjGLqmYI6HuEPW/IszSRXznROOI5AaEfjohlBcxBTdDn5
	HN0VQ6V9efS2yjeRlC+huFK4N2cU4wU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TK5oyqmD;
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.173 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788379221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=InDs+YF8Rr2GVIXpPTwQq2qlM5wTAldEfN0J2IQdGYA=;
	b=xnnSrnmjPib+qMM0WveoZD+03F7oWV5aGDVXkstmb4J5i5WOTD4fuHM3YxKy2q99ybrVHt
	xVetGKdYg8KmNK6sIYf+R0HK+ZkUtkG2QwjmIqVa2WaYCf+YlYpxneXaNANoO/khTSXPG/
	Va0rM+vjSbxkblawtHw614CPLlplx3E=
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-4a45b3f0becso1068432b6e.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 13:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788379220; x=1788984020; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=InDs+YF8Rr2GVIXpPTwQq2qlM5wTAldEfN0J2IQdGYA=;
        b=TK5oyqmDq/J+sW1gOiSKtIw3QI3r4i2dub9zANpfXg8uL6TQKOggAUHkYsKEN0pq5h
         Lx7SPaq5UxNziWQbprj5j2Nrmz/lwsGnY6CP9+kBwyxEOygzArSbekoCvrG189MGDjtK
         qZQn1G/8B7l4KX31T6CpCmy+gHObOY2gGMi7XWIN2p7OT7Im8t0Zw/IiKuH2gkRhBaBv
         qtP5HCVUcs862ilVF6HClaoo/ZaLXQgfXvn4WMSQdWCxjFtrt8ZD3XxM5PyrUUh4iAk+
         lptfLDc4qgHzv1BVbRiDL7oehqyOn3VlShYyg43UiLqdDjRkaNcV2MKjTiS99h8hoDj+
         wGoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788379220; x=1788984020;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=InDs+YF8Rr2GVIXpPTwQq2qlM5wTAldEfN0J2IQdGYA=;
        b=EFsp5AOxubVh+ksTVkwZYa4bLC8K4XEUDPE9vgcemgLfM3HINBIvZ5l6NUuzZCrEKD
         Uqb319qtLG6/I9SSQzUhW3+Z7UM30IIAnTxo0/gmA+Sf2sDXZ1Pq+v78jiA6ZH/yuTCi
         Akq+6aCw1d+xAv8DyI9l/AsWIllAgSGYRdxAH32uxAxdD7EW34YBbvs/CDNsnmYHHmiy
         VSCPjjj8S5YnfqRsu7TrN4/5LvPdfeCUf2fdv5g61kyAo87KMm81JO4E4imc1Z6mdMsz
         S8mQMhudXbAMRrjyiEB7yq5GrMKGDb9AKtzEpzlpPSVrBkZ+I9uAqB/jxiit7AUWVOiU
         EA7Q==
X-Forwarded-Encrypted: i=1; AHgh+RqUbRvvAWX3wT8Wm8ZlLzaRCxv64oCa/voZnrfFi3RlGjCBKEzqDDW+euzX2qAiwP9yBivrHOW5Gw==@kvack.org
X-Gm-Message-State: AFuF++murdB4DTZF5bMTNuxrsiBblQr5ckFtOs+eJMq2N81hfQ1l+y57
	Uk493a76ct+AMtOYfmfg5fmbbo/w5xPwR8HiehA104RtsOg+jqkGKNEK
X-Gm-Gg: AR+sD11XV3TXe5To95Y4DmfANzkuKHqMFT8/FDXq1dXizVpsqZ4tSemcRm0WwbEgedY
	6juICZYrwTZ95WxphOzShX+wKnwQeLpfWN9yTwGRIuYBDWy/mM7xpOCmSGsA0Y5KrivWGUTHz8y
	++yYIO/2yFfF854TB9Q86AOMmjXEYkL4ZhgOfBJLI9p34JbjGFJIUtua3dOCPgr2fDC2fGUKAC8
	zjHVeCmRBlTzv34Z/FtOeqHCKDe9BBR3jEVp5+v8gWCyOeK7RBAfFBLHBdZCfRKEc1n1wYlS73E
	gYNNGAo0nXgnvV2/Wg/nn48klq4dKL2tDzRt2iSN+o8ze+ls4m1vgJfu6BpP6c/GbMWZ5eLNv9k
	qVv6mmbxt4VqhvTGFCfsG0mudFNFA8UOVJD4HGZPjqLxxunGkWqTadUnEJrhjT6+jSSeIKG79Ft
	UlFmfv1O8MX8Ih+t7RUx9zUeyXH9tdDucHNYaUcROOLIX5hAqpIBo4h0jNU7KCQKKmEemSt5YTi
	V+2Q/Fx3B6QNA13oQ==
X-Received: by 2002:a05:6808:1512:b0:4b3:79ae:1495 with SMTP id 5614622812f47-4b6bc65c863mr6085404b6e.5.1788379220030;
        Wed, 02 Sep 2026 13:00:20 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:f::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b69b214817sm2976454b6e.12.2026.09.02.13.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 13:00:19 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	cgroup@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] selftests/cgroup: Skip test_no_invasive_cgroup_shrink if zswap shrinker is enabled
Date: Wed,  2 Sep 2026 13:00:15 -0700
Message-ID: <20260902200017.3847858-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAKEwX=MD_EcAaLzMGnMytVJ_KTGmv=hpR2h-DD+w0oJRjzkg6Q@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: s7qmbniir6pf8qi9cb4hzqkpafm3dgym
X-Rspamd-Queue-Id: 3FE40180006
X-Rspamd-Server: rspam06
X-HE-Tag: 1788379221-151994
X-HE-Meta: U2FsdGVkX1+1FJn1BZiSpdZaSPj8+EXnGCLC3yW6kA0YaAYjc2By3xeS5h5iFS9ANpwE4EXu6eQElY8NqO63r1jHF7ciLeAt58hsPkLzZUxdasZf7oGqFbUQah45eY5JGeaSzU/W5gdkQ3MBbIUUMPveZog1mtTYRK2tmaMFjZEu65qXjKBGTFGo9lufU8v+Yj88y5pELWjfb+TD+1CqGs8vxpTJ+gqxFdAHdI4+0zTCJuXoUUyjvChFImmAKvq1qPWhxaYA/4ODsB1xL4oVqiBMbTp94ARwXdOv00PBkBwXU0ACly1lxIBmIWW2bvD9QE1fo/RlJpfePUwUI/vgJSX1r02o7Rb/ntfby4uHvdNEPVpfUwfRbzM3pB92zkyqXhAtjhrxTSAI+oucmuQPVRUXPuJ7Jyly4ePQ+UoXCK6qvLcmU+EJwpOX3Co4cNVejcXPd7lRiWrss2QyW8MX0VELKXFaBGnnhjKfptWGUTgGYHA6LPDZ5Ugc7G8WcKI4iPoAuUc6Yse6FjTJEi0Kyk5P8S9be9M6apTFWM0gx0PaSfE+0PGFu9ZRRG11m0sy4c1B2FGA682KQryWPMhbgDLi14ycbMvjYXDYe3keiHY4jzFWWJ7HguGxdyT1gLi80VbQtCWR1C4bKlbKKpkD3wYYqNG/JsA+KduHLcgdkTBI32AaFIbceBCEDw8ZBesz7E+ckWv/k3iCeNI2S5Rgs5zi7juTlxFIXwgyxJafpmuN/pzKoI+tScE2hq95b31jS7NwXvBtdb1yvpgO3LJR52riDVPLUdFPklB/5Wf9eP7m6ZsgSiTaAhebk/5ttMm3bWuHYqizef5RqQA6EPYilHOXOuASkG4sZG2jDtIZRBBlPjNdVvxayJewy8QXKRmE1sEW2VT+f5zhwaJAX4GMihdpIujMuvpUsLCVCJJ4wx1euvjhf4k8H43l1KEgjH/lupiKI08ZpLAO5kb66El
 aV5aU6gU
 U1uubKnuJvufBOYbNVNtna0XK+4FJtPNfamX605F4rdhnjovxtOJMWPTaEDefrVc5g3vN7y1U+Ll27H2R2WZXSk7XzJD7j0/WJooeXxRdJGcAJ2eUy2YHznL65GwpNaJ8oJyAnu6YG6Vz9ZkT2OZ64UHZZRtvxHasFNMvEmGsgxBfeokaVc9DbInOkmX7M+Akj10t7A6sEQesAQi1mp6OM5DA6f/iP9YggDgXdwAxKv6Ibw4+7JCIuHtX+niHFKQsnG0CvK4oAj+vKEBM/qCovjF1LhaJ/NeZTuetJtl+0zTo5xP2ISsOgDuC612tcIw4ux5KI19RFsHAsWXlDx4Qp256pk9PITyK2UlUcvwKh1PETLX0SlLDJGv5Q63ilkikgSkHeaCtAe8PUOMIvq9H1MFXcU5QDVVxRekRynZvkGkDzzmcUi4J5ji9GN7UMMWHB1+SMDFeB6S3DEelXHpsqJnvNiC0LgO1CasYIWNpvaKjRPUsJTuQTgrMb2TJnp5KyInqT1AWB4D2vaRDL7nhFV40ZHq4vxJ1nvdlrYaH3WrOO3XJc3oKLoR77GaozTCIUlxv3mlkbbT03W0jaYX7ESMR+iGHhz+s927mJi8/5OHAlko=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 1 Sep 2026 14:04:22 -0400 Nhat Pham <nphamcs@gmail.com> wrote:

> On Tue, Sep 1, 2026 at 12:13 PM Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> >
> > The test_no_invasive_cgroup_shrink selftest checks that when a cgroup
> > has zswapped out more pages than memory.zswap.max, that it does not
> > trigger writeback for other cgroups. To do this, it compares the
> > writeback count in a control cgroup and makes sure that it is 0,
> > and compares it to the writeback count in a aggressor cgroup who
> > does expect to see writeback.
> >
> > When the zswap shrinker is enabled however, there is an additional path
> > to zswap writeback, which can happen independently of reaching the
> > memory.zswap.max limit.
> >
> > The writeback counter cannot distinguish between invasive noisy-neighbor
> > driven writeback and the zswap shrinker work, so the test becomes
> > invalid.

Hi Nhat!

Thanks for the quick review on this.

> I think writeback in the control group (zw_group) happens right during
> the first round of memory allocation, but there shouldn't be any on
> the second round (as the second round involves writing to wb_group
> only). So if we read zswap writeback counter of that cgroup (zw_group)
> right after that first allocation round, and make sure delta = 0 after
> the second round, then that should work for both shrinker_enabled = Y
> v.s N.

That is very smart and much better than just skipping the test, I'll
take your approach. I've sent a v2 in [1].

Have a great day Nhat! Thank you again!
Joshua

[1] https://lore.kernel.org/all/20260902194521.3652178-1-joshua.hahnjy@gmail.com/

