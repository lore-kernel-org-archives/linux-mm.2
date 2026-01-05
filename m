Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B29B7C2A062
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 05:08:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 226DC6B00DB; Mon,  5 Jan 2026 00:08:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DCAE6B00DD; Mon,  5 Jan 2026 00:08:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10A6C6B00DE; Mon,  5 Jan 2026 00:08:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 02AB06B00DB
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 00:08:32 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A06D31A1F98
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 05:08:31 +0000 (UTC)
X-FDA: 84296729622.11.C573CD7
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf03.hostedemail.com (Postfix) with ESMTP id F306E20002
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 05:08:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VQpPeVlS;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=bingjiao@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767589710; a=rsa-sha256;
	cv=none;
	b=1ikr8s/D74kX7Sn3icq/ObIRV2WhSk3Tw7hscmbEatQloS16ApepQqIOYx9aB6c2VPQaqy
	+xm3lnULv64XgcSAhXwwF/8RIqeDSn2Wu83iK0GObcI0z76oAnI2BfZmaBqQSgYKPUbkvM
	z0J24ar+a7kghOBnyYtMYHRC2K8kt60=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VQpPeVlS;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=bingjiao@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767589710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cd/jk1OYxxJI0FgFMQ/4AyHrYlkj9I7IC7MmkMckJUw=;
	b=Uhl/Prg16s59ZypkINqoMZkLng9aEXzeD5A5iG6MMcQAx59/pjQdA1Xrn7xXvxQN4qiaj0
	Ttd+hvlAPhGkO5Ra+XL1RGr1q0QE0FYyI2OYCW7rbw/Kg2aLMCHclPgUK0TqKy3291VZdB
	U4HlgGao7AskgECJ+VJKCycaW1xRO+k=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a35ae38bdfso147835ad.1
        for <linux-mm@kvack.org>; Sun, 04 Jan 2026 21:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767589709; x=1768194509; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cd/jk1OYxxJI0FgFMQ/4AyHrYlkj9I7IC7MmkMckJUw=;
        b=VQpPeVlSbRDRmTl/qvTUMOcgRhjqlyqnc0jfqDB0YeWoU94rVB76LSZWnfKnyi6KRG
         4RE+loGDgQW4iyy58Rpo7T5tPQuLtnuPSkbQPYlhTvdVUef4S75MJKQ1dJr2cTkAtkxN
         fSv45ANH1qaoyomp8LYvarFBv/7ueOrvrjWGmDQE/hxIzg/DspqxtLLX0ko7S8SuGBuU
         +byJzqC6XkNGPyK6jPesKx77XPQEJcIyl0yE8onS+6ky/e2H77lA6aOVQzWUpc8hQhvw
         3x2ycmoLNcvVY067vM78hLfJy9hIwI75QvGsyjBGpS/lt4VujqUbLN+kqBELuaw7YDax
         HGGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767589709; x=1768194509;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cd/jk1OYxxJI0FgFMQ/4AyHrYlkj9I7IC7MmkMckJUw=;
        b=v/bcCq6EqAKR4dI7enbIs0NbUU/4CkrpkuhbHtKLnHD2Na6rqsNnppR2RMtZJ71kgn
         lreJbmhBrfQvDdOZx4RquVJjpQ4b8Gbi/zrxcWPnAc3ei0879dzaGQoaVN100Y4DPZgQ
         vopKOUqdhj7ppC3Z87zo7aYptVj65Ny17ko5Ti02LT98gCx4+h9+qJKVbhTKrkAkn2pm
         w0vTspYBPdK9d9tJLOj4VAv2xvDM77CZxyyG3Rd6tl7Bnk+/s76f/f9ypJCCOy7W9Gmf
         12PW4u0R+wcOThx8SccpOTEo8O8ySFRoVsugi1z7S84eT84BXf+iAPjRD1Rs9j5Kz3lI
         3few==
X-Gm-Message-State: AOJu0Yw6hHvskhrMChH0rCtSkY1tfk/a3nQHZXBQEmHegB/CJs4eF88e
	k6oZ/bmGXwabwiLfWrnyN61hPilDYS8Ez0BMco52ZI4nSl2QHG8qeqJYCKzbHHVu5g==
X-Gm-Gg: AY/fxX6RL4NHJp5FCzXOUwwK67ciFj3HuAtsEMMpz5QXvXiPZAfoH+kgjkJIEszQr4v
	Q3PFFqhTX2HkMGcyM7I59PvMPiutaSdB1yqhX3mPLqaTgJ0VMHK9gC+RlwZRX3jh/NW8zTMTM7b
	HnhY+3RWPIOAb97H21LHUKnkMPP4YSfCNqu2lGr+KfSdzViGbO0TIRm/n9jR5dkVHRW/6mtIpep
	jQMNo0THrq1ni2LEj1II9GDjIH5x3mgEBrEYnolvfhPdo3K9EBO7Gnz7rFO26hOmWp+zr3PepFn
	KzrEY7AoubysuuD7zKzpF75LapbnlUcnlWt3cGvW7QMx1f0kOWrytiMI6IkT5k8FerUOc7Fz46y
	QM01CNMLO8YXLS3/AMdFsuWQlew8Kuvv1Htt6EhI8q68Awq82HMJ1Ehg2GJDzTF2iXUkLfDnxrJ
	Mv41/aWvsSFJBBM1WxTfAIagHmC4z+MkYYVZWkRl52C0RI826tj6Sn
X-Google-Smtp-Source: AGHT+IGk8Jm8wNCmyi1j3iw6iak7/1We7ESwQmtL7zKxxPgAfcDGUZnYJOZFjtq1xd+E+EX1n5ZlNw==
X-Received: by 2002:a17:902:d588:b0:29e:27f4:bac0 with SMTP id d9443c01a7336-2a3c1c161d4mr2381045ad.16.1767589708401;
        Sun, 04 Jan 2026 21:08:28 -0800 (PST)
Received: from google.com (248.132.125.34.bc.googleusercontent.com. [34.125.132.248])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f45bf6f1dsm3187814a91.2.2026.01.04.21.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jan 2026 21:08:27 -0800 (PST)
Date: Mon, 5 Jan 2026 05:08:22 +0000
From: Bing Jiao <bingjiao@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, gourry@gourry.net,
	longman@redhat.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, tj@kernel.org, mkoutny@suse.com,
	david@kernel.org, zhengqi.arch@bytedance.com,
	lorenzo.stoakes@oracle.com, axelrasmussen@google.com,
	chenridong@huaweicloud.com, yuanchu@google.com, weixugc@google.com,
	cgroups@vger.kernel.org, Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v4] mm/vmscan: fix demotion targets checks in
 reclaim/demotion
Message-ID: <aVtHRi-D3iSb3ZkQ@google.com>
References: <20251223212032.665731-1-bingjiao@google.com>
 <20260104085439.4076810-1-bingjiao@google.com>
 <20260104102745.cfd4f6bd661e8e817afcdba8@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260104102745.cfd4f6bd661e8e817afcdba8@linux-foundation.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F306E20002
X-Stat-Signature: aqbr88z9abt58g4jepwko3bfhje659nm
X-Rspam-User: 
X-HE-Tag: 1767589709-525092
X-HE-Meta: U2FsdGVkX18ELbxxuCaxmn7VEU7dC9Y/yWJzDisYJw6asXkh7bgPx0VrlRLcjHIy1utmJCsLZxxxOJzGiU5vBJVudU7yya3S5yMyhf3Kadlr46o6d7ODwv/C/MFsBpPs2Xuv32fJyfkrO3/MsGq69UgpfqsjByfMe3queuOZtT77EdsSElUIvnsld32aOby/NETEJ/lQl0H7pAvQ/LMIjTeoOvknPQDLe6Vkce5FY3tT06brCk5TJuoxd/CPXZrAwOk7/v6K5/TNHkABy9OFQSIrKoDv1AdtcuWJjht1eE7q5PnaJ0EeQaku09hylVnkMsJiFkzcQmO/Srt5wIRZGftL/d6RIdKAq02EQEuVOTLqqVZ/T0iC/kbdc15aELh6OlJT1kQOHbzXLsimPl5j2MeudTTpUUm0mLWnpvZ87kK1dz6Af7srD7+1ZnGtgRp8KNz6WNhekDkpZ7PIWmJri9/N2ghjEdG9GDLbi+KJKppMt/h+1LdZ6csQurfq7Myjh7+b4FaIbQDyL8mYlV5BhUq2tPzixhCvPLTv6fpOTqJu2LNe7OefkCllx0djHilcVuSWKP4ZiLW3P9pPDnXJhtMaPDCK9mP/ewjk7Dw3xwZlI2rWFVCzbqo7uavPtxGUfbdo09gBwUas5y51+bam0SE9bdnc0pGPHk7FKgGpwgd63PrBy01iWYWKAHqhjWe7ByISFXoiKCOxcVpSRi67pRR1MGWrPkL6sKwgy0UfgZXO70vMEbEtUNTqYLlgZYq5LIncngqkGyZL7IoZSF8g5Nlqs6zWni7AX8B/sSQFVrMSf+BMejVefZDUEU8VwRXJ0nnviT492Wg36jKvl2O2/wVGGOwZdtx6iNOlQX4mnzVBvYa6DeL80zciQAN3IgHLsVENnUIKfOy0Ys2zluRfsp3XXEeRFLNXlHDKlUflgwY63Fpc21KdhLDJkfQDjgRVrTWalaoNJQv11Fwabl7
 nNx67mPC
 9qfgViIk9jLbbO0W3VojR2zpwqYxdXnqGnXpfCsgq2GAs2KBnY4hcZtjIatpBpNePJ+4r6zeqdzu/PbQZKcXa2TpIHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 04, 2026 at 10:27:45AM -0800, Andrew Morton wrote:
> We'll want to fix these things in 6.16.X and later, but you've prepared
> this patch against "mm/vmscan: don't demote if there is not enough free
> memory in the lower memory tier", which is presently under test/review
> in mm.git's mm-unstable branch.
>
> This seems to be incorrect ordering - this fix should go ahead of
> Akinobu Mita's series "mm: fix oom-killer not being invoked when
> demotion is enabled v2".
>
> So can you please redo this patch against current mainline?  And please
> also review the "mm: fix oom-killer not being invoked when demotion is
> enabled" series to ensure that things will work together nicely when
> that time comes.

Hi Andrew,

Thank you for the detailed explanation. Patch v4 has been sent.

V4 is patched against the mainline. Tested on both the mainline and
mm-everything (after Akinobu Mita's series "mm: fix oom-killer not
being invoked when demotion is enabled v2"), and passed.

Best,
Bing

