Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26547FED2DD
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 07:19:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E05D86B0088; Thu, 12 Mar 2026 03:19:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE6966B0089; Thu, 12 Mar 2026 03:19:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE98D6B008A; Thu, 12 Mar 2026 03:19:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BEC686B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 03:19:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 21CF58C839
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 07:19:03 +0000 (UTC)
X-FDA: 84536559366.26.CB310F7
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 19D2B100005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 07:19:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ElVaOABY;
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773299941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0vcH1mt67hFsXfPkIkUKs7oLbvthsnnwfQHS4UvLaUo=;
	b=Qe3dLJuAUXOt6ftyrpNfXonarE2VlHRfz1koN0Yb21nZZ+pkCg0rE8WCf3GgMgBkw30qXf
	weWwPFHlpkBHlgoRlb6YPzsKV1cJVUA61kLGI24v8X68gLXEU+NnzrSwrs3IrK8K6vnJ18
	eun2N875WkDoPBMIKZphG3rs1dMNBSk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773299941; a=rsa-sha256;
	cv=none;
	b=FVzL1fRq0wRsVpPqEj/b2rovSrjiygrhYQOaOXKRnuBGsVfw7nRvmyQegrIaMXNS2te77r
	Oua1v0V7FoGcRePR5bAZQxkfI1ZTxVlyTQv+tbbdKQk8nQAD043j05HpuwvxgG8r3nY06B
	B7qhFWlcK4avrio//CYqdRm1P5IFx8M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ElVaOABY;
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4853aec185aso5225955e9.1
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 00:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773299939; x=1773904739; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0vcH1mt67hFsXfPkIkUKs7oLbvthsnnwfQHS4UvLaUo=;
        b=ElVaOABYXOvrgX80l8azg4XPYH3LV4x22CW74JX8fp3SvrGeydKBFEYhpelq4hgh9C
         OmoNsS2p3/FaA6g3WXpNgzI7x0mcueMtEU3vMZCEeqR87aRQgFw8Ss0PSoOdfEVMINjh
         WSlMl33TVyz46KMNbkl61bYaHV7TsNjHqMcsTJ/uwMz6SCKo2quKI3BqzbRqLo/pLnLY
         /O8sumhafc8pC4v69QMMKtaWv4cx5fZh9rE73sImpbzusUGV0M+TNE7bzl1PDppjwC8p
         xhANYSpKMwQJprhJ+ikRp6IWbu+OeglgOBqdzWoxE3gIBCKjuMHQplaokFh/PirmO96R
         FcIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773299939; x=1773904739;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0vcH1mt67hFsXfPkIkUKs7oLbvthsnnwfQHS4UvLaUo=;
        b=sd3yI/DSB2YxZsX4y7UB3fmowbaAnqGrHEfQyX+6WBvjhShC4vY51BZcwacyqoQdWp
         ir1vzUfLFNRUNicqzulI0T65BT0ntPKj5lnAc+kl9IIiW/BAaLTxHPBByRX2NRLtDpbl
         xuVTKoH/NseDyHIL8U9kc79GdCQWGecqRpCJ4mWzqj4eQKv8Pva2xQ0HVkX+k8c3qZwT
         4sRxQg48WkraN0Xjm2WxLJUiLWI+9WA7x6pWO4evXGEflRozmWXrTKG7EqM1GQvr5sgY
         /JJF1o4V+ut6HOV1i/gGEwArpUp0OQGlJzf+VMJKZJZCWV+sU1hNf9M0WQhJkSdUxRn2
         BMIw==
X-Forwarded-Encrypted: i=1; AJvYcCUxVH9pmQFF34hqDeARo+1XS8D1KFBDndZ9JoOBi2Qo7GtqQpWf9/CrndvekFYHT8amxJtfwKb4Cw==@kvack.org
X-Gm-Message-State: AOJu0YwLrx9jb6cp3Vj6IOJnK7jEv01oTxfqblTr+w3XJ/Yo1+YZxCi+
	qAeipfDGzWilYOAIJ8j6oZFQOhaPTmPSXQeelR3WQEzBWaIUAb/JRa9StP85dEyJL58=
X-Gm-Gg: ATEYQzz2bxNFXaKUJ+kvdIquE/sKCBhMz3JTuoT8znYLW7bokxuxiDWQdeHxr1MSJyG
	trf/MQecAQxTGTcSfxa6RTk7HGzV8CLHTwckZdzFB30bDwuVZ4IoBMlJxdTsm5nf1GqbLKGHauI
	pTMlpAeZX3cZwbf2lg3Rc+7d0cebNvotJXSgKJtEINKXgc7ovHJMR0kpu9cqkoQ18rzr37Vem4I
	iPg6O2NG+t1A0H0V0FAdjHrumISbzCXTzcho8/tabj+z5oZuF01YCUXbiQLdlwZ1Odg7ZjJU8rM
	5y8gJYklCZkvTcO5LzF5umoowvW+nifQXl7BsiSjuhm4ojlgbUaI9DNlE+hVsXL47mFtTGwva6G
	upifQYrbySovhCtaKvFEcNDbn0I6IA4bMeDIQ/6G0uWB5gPS6WXKpI435qClLwtwlJAB4PaH9On
	CR3H9YEJ/xoBu4rwO81EM1APTNwnzrd/zgHoKx
X-Received: by 2002:a05:600c:828a:b0:485:4135:5c92 with SMTP id 5b1f17b1804b1-4854ad770efmr84403845e9.0.1773299939346;
        Thu, 12 Mar 2026 00:18:59 -0700 (PDT)
Received: from localhost (109-81-21-195.rct.o2.cz. [109.81.21.195])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fe20b4dasm5786136f8f.18.2026.03.12.00.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 00:18:58 -0700 (PDT)
Date: Thu, 12 Mar 2026 08:18:57 +0100
From: Michal Hocko <mhocko@suse.com>
To: Benjamin Lee McQueen <mcq@disroot.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3] mm/vmpressure: scale window size based on machine
 memory
Message-ID: <abJo4YQLucQ8zOdM@tiehlicka>
References: <beab70d3-470d-46ad-a890-76fabe49272e@lucifer.local>
 <20260305043038.2176-1-mcq@disroot.org>
 <aar4T90zjolmTGFa@tiehlicka>
 <31c4680848b833d53b1979b45d5a368d@disroot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31c4680848b833d53b1979b45d5a368d@disroot.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 19D2B100005
X-Stat-Signature: 6d3hkb6wobus5z3x73a91cbqsxj6k46g
X-HE-Tag: 1773299940-990898
X-HE-Meta: U2FsdGVkX1+mNTx2be29R1yyVPssuPrR5IB1QsYeJHGyIW0R3wGzBRmPdTS07FYUnDQh5/ghkO7erqGqdCnij2V+E6OgmR3wO77p3OXr1dutdtxMlXiFe9Rkjo4dCCG4yzyM/OSftYtnSb2taCbr8mGHttGlDh7t/m2vobuO0MO9+R+MM00XTPpmEjVq1gbqEEw/cMxoSFeUht7C7YTG8A0pnIGBIDe/D1xGwJrg9VQ+y0qjfRMKKm7Trj2LF+lUzxzLrAz+4cfJ23mzvMbPXAIusfMzkeWDx0M3Zut7QXf5OEFik3rSA8Cp2CQNAIYjV/FM5VVfGSyaAp4W4vqG5fAJ+zm5RLnp+N0Uo5ZkoYsmGwy2zA+SPZzVPOccOkjfTG6Kr+f10x3ZLNAe8/KrHMKCr6BJOo8gWA3N99aq57Wg+H+EU1TGefs4793ePwEfu6rM0AAFeKwW6rz8Q9tn5CffxTp01eM8iPezbJv5CZ+vOzVx1JmlsylIS17fqmtp9xOPZYu6KP1Ow1dqMRwyp1tIFwcb+/yZNwISWRwfi96l27dLgCsWQAK74O+jEWsPWBRe3qmwT9T1/SP39cwRpYHc3JU6ua4F1fEc/0VUsIgZcy9kBPRIUCmoy/NR6h3r5MLivl9eVUc5EehySr1ZaStailCwzT0ZuabtouW5e6JfjoQUQISiJ4VciHgiuLKvqG7laExPM8D+yoGhnq7U+rMcjblKz6ST3N/aA+E6XqmBZeCLNKRkuakEdfadDiH32GWYMw085wOrpGyZjDM3LhrQkZ0PeP4bpuDr+cU4vLf2cIoS6iOiOG4QRf5CXvwh+/xrsyh2FZIbjdNAFPQokrRmTMiDscRzQjjzNVGE3cCs5wZRgMic7fObbOHeuG1ThDXYxQQFzoWyxv6lE0ryv/oQcORLuVMX8Hl5OicE8uMWEA14OYbJeNngvKp9fz/tfNPbJvebmC+78dRpDAa
 anV9VmUz
 ptt5FaZLp38voSU7O3RrpYG9NHNmXe+ZyIj6QigJPeI686LVEs1GQGgWGb2/7l6qKn6RVp1Av0s3vuaZLxjdmGrpA3ihOFXN2VcC940uVbz8SPnxoL2SMUa5CI48eAC+x4I3lmP0DnXOr0Wx65Z028kdZ8n/ZbjzYI6q38euGbgdIMN6m8Fm5NR48ZYwGt27JbQhI4eM4wO/sIxJmB1JU5rYF53gaS7uFjK0G0xK+p6av0fSSvWc5WpHHOpCj8df79/omKUy1DIZaN16TQkVviqAPAWP4RllfQO6bq7k5B7g13rBIUhuikrCQ29EWI1hpV0UG1Bsy13SXMP6liEOSnU+JCWG+XqArAUDN8e5cc6Mrvns=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 06-03-26 17:44:08, Benjamin Lee McQueen wrote:
> On 2026-03-06 16:52, Michal Hocko wrote:
> > On Wed 04-03-26 22:30:38, Benjamin Lee McQueen wrote:
> >> the vmpressure window size has been fixed at 512 pages
> >> (SWAP_CLUSTER_MAX * 16), ever since the file's inception. a TODO in
> >> the file notes that the vmpressure window size should be scaled
> >> similarly to vmstat's scaling, via machine size.
> >> 
> >> the problem with fixed window size on large memory systems:
> > 
> > Thank you for this much more detail insight into your thinking. This is
> > a good start. I am still missing an overall motivation though. Are you
> > trying to address a theoretical concern (the said TODO) or do you have
> > any practical workload that generates bogus vmpressure events. 
> 
> yes, as i don't personally have a workload that explicitly requires
> vmpresssure to not generate bogus events, it is still technically a "bug"
> that can still be improved.  i believe many legacy systems would benefit
> from this as they still use vmpressure notifications.

I believe we need some real workloads that have very strong reason to
not move to PSI and need this to justify any change in this area.
 
> i agree PSI is the preferred interface, but vmpressure is still used in
> other production environments, like Android's LMKD, right?
> 
> -ben

-- 
Michal Hocko
SUSE Labs

