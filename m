Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3E2AC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 19:39:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF4CD6B008C; Wed,  9 Sep 2026 15:39:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCD2B6B0095; Wed,  9 Sep 2026 15:39:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE27A6B0096; Wed,  9 Sep 2026 15:39:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A5CF96B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:39:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 582CE1C1DD6
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 19:39:10 +0000 (UTC)
X-FDA: 85195237260.08.14E3A52
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id 64FD240007
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 19:39:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b="b/7kytel";
	spf=pass (imf07.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788982748;
	b=fUnIWha9rzz/sFCzfi92AxpqyWrs/cYK6wwHZrPrgqK2xsW39gaPgji9DoG4yzxvTNzhA5
	+KA5Ozr6sLsN65GKtbJU6te665twOshFBm3e35aFae+fURmjXv69WTBoZ1T42AWOl/11kp
	cYaKl3JocKGUIM9+EU0j5x2Lbwt3rDY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b="b/7kytel";
	spf=pass (imf07.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788982748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1GUgXHgHoEl56pUUuNlJgXsrmqq8UKwhkWovOGCgHHU=;
	b=ozJwfbK/Me5f2Bx19ANhY0wg9mFL5LHUqlQh/qD10Qz6I7dTSybDOoOQeAhs3gCXPyLs6g
	wFWlqDIvf4dpkoAesyVZOjZ3SEpReSnwGkdKP4z0OEis7AObxir8WpjiyzyU7aU9M+rQS2
	8ofisFnwtNnp0mYiJnJ/267TzhIv2zw=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-52d8679c149so11413091cf.2
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 12:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1788982747; x=1789587547; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1GUgXHgHoEl56pUUuNlJgXsrmqq8UKwhkWovOGCgHHU=;
        b=b/7kytel+erTM/8BUVdnEWh7u9cVP7daLn5aBLNqo6C0+VIOvljGGfTCd+YVvgjCEc
         jAFFP8KSW5T27s0ythKEtrXnn5I0wBx6m1bDI650kJe/sg8Dqn6i0zm+10JoEepwKhEo
         yKQVH+7oTsiWJ0RBs3MiG1d10b3sYoPXv3+5tsiAdzuVhPXaHKuuuoH57oMsqTqAzE5m
         YN1CJN5PwG18gyn8H+zUQphDX6VQqLB+n3ooUBMVoxOnTQH/qZ87tNDimLFmZeAJr8sa
         nGas0lI7oHFuTdiBzu5IYfGl+AqCRb85KXUc2KBwhPkUNC3eDABlNYIRB+HlN+hrCucf
         DNGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788982747; x=1789587547;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:subject:cc:to:from:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1GUgXHgHoEl56pUUuNlJgXsrmqq8UKwhkWovOGCgHHU=;
        b=eXyzTyZ5xZsThGyp5UfEEid99AFXiD24Ok8Wa/xIojqbJ6kE7Hi2ZIe8hscKk5FHsD
         crG27/icDBS1LvcJtEss42w7LpSHOYN56YquOTghq0pP7ZuBPPtmjmfWD0tZyijSWyVu
         AfuVhmjiwtUeDnBIevDNGkFdIRJsF75QBHiEly0LHh0H0/gz16GIKlYGvc8fmzkbZIR6
         jWxqwOfsApq9E1zU+KBKDCzyU2pIByRUfQcxOEuYEAPnKyNJhxlPBHy+UiWHp0VSZ/dd
         LC2G+WWfEKvXbahW3pUqKPdOa6A20HRSVNMH4MH1p7z6owdPdHj6ib4vPhMoYRUgSZe1
         r13A==
X-Forwarded-Encrypted: i=1; AKwUvBy6jPg/g1+xQPr7XtErX8LOpTqM+/1olqdZSs5HpkBFQZyAyeZxoZH/Lfeggbn5M37a9+6uhptgiQ==@kvack.org
X-Gm-Message-State: AFuF++kNI8SkROVz+broejIkD1bDdb4UklKjExegvclhH/F+46T5duNt
	xa9rkrs+WeaYpRst9gKBrWkng5LXVJhGmy+X8suVV76nvX1G0rVEm71ksa/scM2/qMQ=
X-Gm-Gg: AYBFou1w6JG2Rf4/wxoWcXiKRw/ElNlDUiA7nSXDNvWC/lJ7TYOV5SBQpaNtFDWY/8E
	9CWECYL17xqM4qdJAoVKmsbRmNN5w8AKGNcEZG4Z3Q/5wiAetLIANF+eYF9GDeVe7xVgkfkUy/A
	OjzhAAZKzWyFv7QkZFNJYcKXNAqfCuCdp6Rq5ugJJ+sdz9bvSsl2WLPE5IOEumjc7trkhx6Ifha
	RYv8MDTE5gY0L/Fekg92I3VeVpOlgcpDfdU5z9IEHS6dZ6J5qm3dTNSwIQAG5csc0bNIaKrbASz
	hcg8/TSCE7piD+jUPm794nITGJDJfpLxAvaVUmeylJahpDruKO1C4NvfRPg4P3M00681h9p2kY9
	/VNCB7lLZjjbFjclIzxixe5P8182yEbytNjbNemtSI4MxpueAaKkRuIGbtlGWt7ZxU0TLLO97um
	E5B8Im2c2F9DXv5CcmM5JsTNzD89OngJP9qmA+1T8vLj9/EmPLILpkEYVYUltHeaeyoMq2bW1Mw
	aE60dUl+NLNfwjETvcTTsv6ShgVZH3xNswjEXzq359esS0j7tj5RmxSaTDHEdFTVVw=
X-Received: by 2002:a05:622a:1247:b0:52f:f472:bad1 with SMTP id d75a77b69052e-530549f9b59mr430060511cf.33.1788982747305;
        Wed, 09 Sep 2026 12:39:07 -0700 (PDT)
Received: from toxicpanda.com (ec2-34-228-114-98.compute-1.amazonaws.com. [34.228.114.98])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530541c94ddsm151964851cf.23.2026.09.09.12.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 12:39:06 -0700 (PDT)
Date: Wed, 09 Sep 2026 19:38:20 +0000
Message-ID: <20260909193820.9aac7888ba9d@toxicpanda.com>
From: Josef Bacik <josef@toxicpanda.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, Roman Gushchin <roman.gushchin@linux.dev>, Dennis Zhou <dennis@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] writeback: report a Tasks-RCU quiescent state per cgwb drain pass
In-Reply-To: <aqGilhgcEd0qaHjI@slm.duckdns.org>
References: <20260909-cgwb-tasks-rcu-qs-v1-1-967a7754771f@toxicpanda.com> <aqGilhgcEd0qaHjI@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 64FD240007
X-Stat-Signature: g49nwxjqqez1531uzqwngf3wx88jp14j
X-Rspam-User: 
X-HE-Tag: 1788982748-387793
X-HE-Meta: U2FsdGVkX1+Qs7wVjXglC2sw7OFltD4lsJm9RJXv41qzwdYqTg7pyJIrDKpgvu+kvN+SGdR2ekCKjri3rZNL5+ZYpCfNylvngVn8I0fE4jgwKi8vOeBK3V2M8p2yZ9AZOPAlZbBnAV4yooA44AnciIZbJ8+GV/fXcskTY/3cFSgnthHPMGJY9U8fGjydSQJGGfLzgQRq6Xbixd7CHnT7q+CA+9ZAd62f9RQ2K093wfh6t9ZLNVzjkXBZVQc2U9r9EARBsl4Zq0OAAM5a0prfFJHPJ49Y0E5etgI2Ti61h1ckhcvBqEjbFkCnOL56eShs1a31nKmj5XUGUHku2RkW1TmqBgM9+BD61mjm44YEst5jfz9biADJypCFImCEHdzwe7LcJKvp/64Jgdw93hJN4aYi7OoW7M8WqBJqGvDueTOJKn7DgQ1U4hA0XKp8/TL5wxU8bdEgvkCbyjp7DAwe/7mZeUqBx3BHRzhRSBBMinKqFCz0GdFBEY01Ymp0q1B4YFUGtqS2GvIv3Bt9+i/SDxwip3b9LvBxAqk9Fj8s82wjOu2TaYBgj5SvFrQOeJui6qMRvTBfqEFcxbsBk5v/sEnmWOGQMT6mPaXwFBbNcJkxayhaYDwioteXk+3puJhXKFNxBMfiyXvVtWaDp3mJJoHoMSFGZvE1fhqkfs0U2lvcKQwQS70lkD+RUFN97gigbMnyvmbcQeyaLbKFm25Wj+4UPJbl6n8O6oYsY4ppTAQzMvxiSbYIYq2wz8Y3WWdEgSYGfCphHa28yo5OnQfr4/d1A8GB+hpnaRmn77FTbnGvPeiXqAYDsTTs2nved6Xf/ZvU7K16lluIOXL58mM4i1SHpp62Jcq47ElUHUsZf/AbMiMI+gr33luuTviInnIwYfQB2LGrC4oCi6T2z2zGjAJO/AwB3v7xdunLGbTqxoqNN1Hn37+2iwV5OtKkWFaaOmHDAet54iowMNkXcLz
 T+i0JxNe
 e95sqrkUBGS7KLrUBKifV45pZHaC4y8+vQJPysXXyb58hLrmX0XogyMc2COnfLKO7/6PZMZzvuNYQwDYjmntgEffetDD2e0XyHJR8KObSDMCxsFNAE7G2RH1nEnfYUiK+8PvDMP4fGmNHxtmoy0ihmAcLidoS5YqZ+LIvKy9tqL2sgUCrlCm+1YIAU2JyrGj9ivyJ6PnClqtJf+xPBsRjH9xwkYw2rybI1Jg2Rl38uwe8a3xdPcJ+HAf8Nk2oa5ezpUpG/JnBvbXFrpQg4j1M6EE/BfuSXjjrsWumljmIwhhTsic0UCZFwN+NRhjtvSOxeoS7zZlahmqFDhm+IQUD3PL+q0Xx03SeCOlmyRKGShHGlr9c34ALxnyf8PgHvpc66xQ6rGsys7m0MjWMU1vevhT4lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 08:16:54AM -1000, Tejun Heo wrote:
> On Wed, Sep 09, 2026 at 06:01:07PM +0000, Josef Bacik wrote:
> > +		do {
> > +			cond_resched_tasks_rcu_qs();
> > +		} while (cleanup_offline_cgwb(wb));
> 
> The patch looks fine but this overall seems fragile. cond_resched() was
> already marking "stuff that can take too long" but we need to use
> cond_resched_tasks_rcu_qs() if it can take *really* long. There gotta be a
> way to make this more maintainable. If always doing tasks_rcu_qs from
> cond_resched() is too expensive, can it be be gated behind something cheaper
> e.g. some tick based test?

Yeah I agree, it is fragile.  Every long running loop in the kernel that
only does cond_resched() is a potential multi-minute synchronize_rcu_tasks()
stall now that cond_resched() is a no-op on the preemption models most
people actually run, and playing whack-a-mole with
cond_resched_tasks_rcu_qs() at each site as we trip over them isn't a great
long term answer.

I'm working on something more general so we don't have to sprinkle
cond_resched_tasks_rcu_qs() everywhere, but I expect it to be controversial
and it's going to take a while to shake out.  In the meantime these are real
bugs that are taking machines down today, so I'd like to get the targeted
fixes in and to stable while the broader discussion happens separately.

Thanks,

Josef

