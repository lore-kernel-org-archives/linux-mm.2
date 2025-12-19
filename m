Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8A6FD7494F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 03:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAABB6B0088; Thu, 18 Dec 2025 22:56:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E40E06B008A; Thu, 18 Dec 2025 22:56:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5C3F6B0088; Thu, 18 Dec 2025 22:56:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C66CD6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 22:56:04 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4E8F91403E1
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:56:04 +0000 (UTC)
X-FDA: 84234857448.01.71EADBF
Received: from mail-qt1-f193.google.com (mail-qt1-f193.google.com [209.85.160.193])
	by imf23.hostedemail.com (Postfix) with ESMTP id 81B95140006
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:56:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=MCMRPmaK;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.193 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766116562; a=rsa-sha256;
	cv=none;
	b=S5Gdo3TDXAJtcLfzCmjwZYq5ATz7/XMlJ2zZEWQNo+Egbv9apTctXIi0qYpYhnN1iGqmt9
	smiQIoR0EtqcYNXf46E/7CYmdyw0jYvN1FvpOtm46aSAhAMjMN9NHaGvmin94qFvAqg0X0
	y4O6tf/vU7bksgz3gngQJL+cjwlqG6A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=MCMRPmaK;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.193 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766116562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VTtfle4/MykGQYtmzDysxCuwpMvHg0hiZkC5ebsS7CQ=;
	b=l/y2UW/SpEvQDLnJIIMJvkA5xfQvETQki1RrbCXddjyNAsA5eo68yU+zqvqooVxF8EAMhQ
	b8lg6JmetlQWSLT9JpU+L8hBlrxmQbV182FsrsJacOz6uMzCHWR6x8io1hr9O1ltNnTRq4
	Rj/QEpucm5PJQer3W9rH5Wcm9jLfu7k=
Received: by mail-qt1-f193.google.com with SMTP id d75a77b69052e-4ed82e82f0fso13581031cf.1
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1766116561; x=1766721361; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VTtfle4/MykGQYtmzDysxCuwpMvHg0hiZkC5ebsS7CQ=;
        b=MCMRPmaKDuHUof2WLOv1v6NNQIK9oStYKZtmJrnQQli/pU3TCPjt6m20f5oFGIeCdw
         2MwAiW6J1OvS8t7E2lx7HjS0j6cSbsJ1slObdy93laeuP0QfiEgk8xI8r10zIDvnMLFc
         bwHpS9RP9KpafcQ7ioYLELR6ZArOVsrNIVNps4iH8KnKNdJh7RYeDurYC/p1dKAiUcdM
         Np+cuBsCdJ16Ad0+avsi/W2ChCFniPCcMLuZw9yGT/UStSnFqBneK+zMArsfndDNwpZH
         EHzaeTGv589m9JPHSSysP09N1BDQyTWrBunVtApiudcIJpL+T6mFBSqKdpJHBJ8CKQpl
         FAzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766116561; x=1766721361;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VTtfle4/MykGQYtmzDysxCuwpMvHg0hiZkC5ebsS7CQ=;
        b=tPMYO41lAWcnFYMrR5tAGE1LJyMJ96PAqCc0k1pEjEiY3oGM+5nksmWkcDHxw66gVE
         c3a6us6mjXjQKQ9QzbFRC+GUCdLYEM5x9P46fIh7jHJWqLXLwYszLcMwwrEypmkzMewJ
         0dY9A6nFxt+RpGl4KqSdbthlfyVSdgiJVhcl+R6W+ffqePz455aXS2dFhMBWPJYvJKVX
         bv5qyeJLz3vQkqun2QmCh+/hDbdZB6PMk4lKIsPUsf+V4FosSltltHafNN3VCKwdCEn+
         ubkRtnWwQUaiu2mJPYfaje5KBd6iDStyWh0xUT7nbrI1n4Q/6C/AB2RsBnGdS3rdw3wY
         ZeUw==
X-Forwarded-Encrypted: i=1; AJvYcCWLkrPRGQqahBrWASYvRBztNIJ3sNJBsKTBM6H6gpWSXFfJLAx2mr8PzKSdB/C/hI2kw+Rwho3qBg==@kvack.org
X-Gm-Message-State: AOJu0Ywx0E51LVlC3ZUxkEjocOe0FSWVGqTByKxdd24bAcvrXcFUhhqf
	apVlFNpAOSq1+/Z3ytFLHM6Bh8HXHGB+4rG+wKdwGEdQL1yNVwx6NtOdgu9kb3U6hVc=
X-Gm-Gg: AY/fxX6U6rH7KJF6JyUL8ZW6jVPuwWdnduxakiRuLFWNHcJoxjEYmO8w5i9omuqlrVQ
	mqDWD8QF4jP2KpCljbX/4ie9ih0I+GmrXJnZsqRsuUxHkyRpGvj9DbAStc/ToNJf70FpUj0gdF/
	MEl3CgrtbWan4qLr16ivq9hfY166swLN/0xV/Va7CAKSpOiixBDCB4QWDE6xmArI+FBznQTEQDA
	tJDmolnA2MRiontxWOVDeDqejaQWGUCwRfZQEmrGU1vnzaUOYfZTecyaAj6X/X0QU+nEJFnrHsH
	0fqrYMj4DHdl86OgqYGSWzbcOv+W+jYAX8FWNv5RLzC2LhvtDJmuX6XPY45mSIEChmvUOMk4PFJ
	RMTd33apNXNt5P+96mZhwvb4MJ01OKAe/Bi8TgY2j8Mk/1k/1Bb+GnYL5AZwxFT0s29ScwNOiS2
	6WALVbBkVvGXLMLT0P7uNJ
X-Google-Smtp-Source: AGHT+IFb5/BXn9GeXqAyeNuOtJbDxjaPRu4NM7Bq86/JmBGVvG42Er/O0lr+BnQiTxNW6EgE2U/MvQ==
X-Received: by 2002:a05:622a:2c9:b0:4eb:9df6:5d6f with SMTP id d75a77b69052e-4f4abdbe93cmr23315421cf.74.1766116561499;
        Thu, 18 Dec 2025 19:56:01 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88d997aed21sm12322946d6.30.2025.12.18.19.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 19:56:00 -0800 (PST)
Date: Thu, 18 Dec 2025 22:56:00 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>, hughd@google.com, mhocko@suse.com,
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 08/28] mm: memcontrol: prevent memory cgroup release
 in get_mem_cgroup_from_folio()
Message-ID: <aUTM0MdsAbpcH9GM@cmpxchg.org>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <29e5c116de15e55be082a544e3f24d8ddb6b3476.1765956025.git.zhengqi.arch@bytedance.com>
 <aUMkYlK1KhtD5ky6@cmpxchg.org>
 <ot5kji77yk6sqsjhe3fm4hufryovs7in4bivwu6xplqc4btar3@ngl5r7clogkr>
 <aUTMUKEkGu7cEgb2@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUTMUKEkGu7cEgb2@cmpxchg.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 81B95140006
X-Stat-Signature: stpa6zb5zj1qxsohh5bnz7ef6j41usfu
X-HE-Tag: 1766116562-781882
X-HE-Meta: U2FsdGVkX18vegeIU0hDpZL5mYn6KyRa5vYqUnpM3C9lh3QlJRUILxvtKVY5i4xv8WtnJm0gCJ80ROHnZaNZw9NrAhsgs4wuarVcRbij0WwjyQz8AWDG0hY/bVVm7c0w/3uQM/07qeuRzZ9Wnl1atshzZNEaUBOz1b9McRLm73NCsqvfEpPq68Yp8t26ntd2Gw6XOuBeTS7RwmY0laW5gqpfrCBZwoaKMmal/FpzioetjWtEO4xLtSZUwPpPI+EMTJAT7BCOs1Q++QiYWUESLG9JVdoCnbMtRtYbrr4ivv1tar0b01eo6eAq/BvRjzcdtxyHw8poMwuVKTTvN0qs7Z930EWHddP2uDdEJdKiNhSotgeFiNs74u1yvRqr6OISzrvKNdL4oaepj/UYkhLI7PfF4X2VynyF4mdDoy7wUM4OD/2XPI78zXHzTo/dv0rRN215JxaIUz4p9RmWzqRsguThMtP2TeMkXo6nVu/BFQWy2ozMssafmyEEJsM1c3p/arBTBjySh5LSXBVc6z7V7CQka+g73KJlSpJA1id/NVXGZQsNsaq1LGvx8WhNeD/D+9LYvBVg+x3J5XXgpQozTmWTpiPOPGNdNb17Vh9JDo7ttFZGa5U8n8/0nl/D1MvdITmnCihZfCzPEInwuVE9XE6NT9u+iUGDxdM4dsPwPl3D+kjC4dFhZXJc2KjHubIi92EG22t2Xg90EYY6ljmAKoeWWfipNFUAJl/T0h3/BDFgrHgZjp4x+A4YSHn7WZP8dzUhVvFwol/te/hO7fsxh2BBvd4cq5IY/O1E77cORBtEBcPKkbdE6jEJxDMdMJMjyBaFkvG7x+aTXoW8sTi+qf7lauK/OaMysVB8onymWSvIm5imyYcLPWVVAjSBXuW4jaKtimLT//WCscQIN87vqNgzkqt54zNtXH5AYSPCX/8DWD7V/rkn3wwNEx+VnNbE+JZBDmQb0yH3c1Bhl3d
 c09lBgjw
 oQPF1keaTHJQg66dOt/Y8sS6QIRtWGu5roYX9BSOYgYosm7feGKCyJ1mylMLbl9GHZLU2rnIiqtLQ4eMjKsZ5g2JCR8i7+/ll5KQ8FKbfU6EFQnE6DEkfR+7X+ayo97ZL5dAKCRRzycMGgHxLAlfhoVMhZoDM1EHP6GE0yEq9XaoT9w/8DT/IL9CbQX4VnrJ/MttLwd4c9zqImpI6E7s/DxdFr/0b8t1lgLmfsPuwFsTCLE/1ptEd2i7TkAwYd9ePqzfXw0W0WXABl1B3Xq6MuIsgItmaBrSJE+I7m1UZYecTC4468nu+ou8/Kyy627PkmmP4DnWByJr6CNPCC3kI9HbF3lGaqw+kn4ginISJTSlRUO4KkEhwodNcSgD6unDQy8Ku4G0fzm7/AkS7fucQbOHbw3FwpHy55Ag716ppqL7gU9437kxzrdA/SSyK2fucW3GbXKCT9cj12RVUQaL0xGSI5s/InHNq/C1E3QJlYhqK1gJJ7EC5WyEOTdIoHo39dtQaD7+cgpQyx/Y6EY+bxHfwVJPcUYSNyu9B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 10:53:57PM -0500, Johannes Weiner wrote:
> On Thu, Dec 18, 2025 at 06:09:50PM -0800, Shakeel Butt wrote:
> > On Wed, Dec 17, 2025 at 04:45:06PM -0500, Johannes Weiner wrote:
> > > So starting in patch 27, the tryget can fail if the memcg is offlined,
> > 
> > offlined or on its way to free? It is css_tryget() without online.
> 
> Sorry, I did mean freeing.
> 
> But in the new scheme, they will happen much closer together than
> before, since charges don't hold a reference to the css anymore.
> 
> So when css_killed_work_fn() does
> 
> 		offline_css(css);
> 		css_put(css);
> 
> on rmdir, that's now the css_put() we expect to drop the refcount to 0
> even with folios in circulation.
> 
> The race is then:
> 
> 	get_mem_cgroup_from_folio()	cgroup_rmdir()
> 	  memcg = folio_memcg(folio);
>             folio->objcg->memcg
> 					  offline_css()
>                                             reparent_objcgs()
> 					      objcg->memcg = objcg->memcg->parent
> 					  css_put() -> 0
> 	  !css_tryget(&memcg->css)
> 
> and the retry ensures we'll look up objcg->memcg again and find the
> live parent and new owner of the folio.

But yes, none of this happens until patch 27.

