Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5E14EEA876
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 02:26:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15F776B0005; Thu, 12 Feb 2026 21:26:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10DC16B0089; Thu, 12 Feb 2026 21:26:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F31626B008A; Thu, 12 Feb 2026 21:26:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E3FA26B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:26:26 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 644C91A0223
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 02:26:26 +0000 (UTC)
X-FDA: 84437844372.25.55CF6AC
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf19.hostedemail.com (Postfix) with ESMTP id 31D2F1A000A
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 02:26:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf19.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770949584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wRtVqibGYFencaLnUXeG7VvlmRl1Ip7zzoNL0W4XVSs=;
	b=tW3LqJk5nYdh5aeAQw98PzG1Xel/uEbyVYhn6umeA6TkulUwM1upZGJdkfDbZHSziYeSDB
	KhmyFcuEbo3BdZo10AWCiL4P92nNMlbvuPI1m/kWYQvE7DeMETQsntYooi+190pxCL9pYc
	4lrquUUE00PktJYXLsC8m5EWk06aDhI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf19.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770949584; a=rsa-sha256;
	cv=none;
	b=rpvTmrxd/jwWB65LD0o+Hq9l3qV+WS/1Ng73TQj9geU8weAqj3VwvCzyoT/F/s/wr8qi9o
	RK+/bYGOlvmnYoVhCroC03jLULsECWN74J5524cWJOtLbDHYzV3wCwxhjraEN5Zir7jvhw
	z6dZU/bJ9s1NxKDlN1dZEyxsaY2UWT4=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 13 Feb 2026 11:26:19 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Fri, 13 Feb 2026 11:26:19 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Chris Li <chrisl@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, gunho.lee@lge.com,
	taejoon.song@lge.com, austin.kim@lge.com
Subject: Re: [RFC PATCH v2 0/5] mm/swap, memcg: Introduce swap tiers for
 cgroup based swap control
Message-ID: <aY6Ly/0OcWFJEQ1M@yjaykim-PowerEdge-T330>
References: <20260126065242.1221862-1-youngjun.park@lge.com>
 <CACePvbU3OoGg5-dHXOJk=62AkBxJCLmzwcHdHuPe2nnxfzMLBw@mail.gmail.com>
 <CACePvbUicBa5Oh4Vz4qX=SV3M3CegCgSJ2GjogN6Cbrkkc-uwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbUicBa5Oh4Vz4qX=SV3M3CegCgSJ2GjogN6Cbrkkc-uwQ@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 31D2F1A000A
X-Stat-Signature: 13dx4k1kyp38fwuw7twhy18di5rf4p9i
X-Rspam-User: 
X-HE-Tag: 1770949582-152867
X-HE-Meta: U2FsdGVkX1+ecvzgK5uzGYX//2ADQQygaz3ZidaLTHVlkLQum6i/Aw3Mv3Kr9W3z1kjNqBTzJCoSfwZNm35M3jOhU3sSqZ4ycseAd5gu06DivR655/AFNjEiwHfmK2UAvGjn1rePwcgHP4Khs2qswonR/Y8Xr9vemaZ7fMXU6eNHOa6jNmytM10CehRqu3P4tC4hHuFlMjl6OC9XoYDnkE9Dfvrjq1jtRixz9MWCLzhjdQTMlAnVjKBg0dknn0V4FJVv2bSmuD2wKcQSmw/Ljl8SHFqQS+zre3L2CUp+JImFS9bpeNdZ3YMkmqkDhGZ8uAFkTwCxmqu/4ciI7AyIl2GXShG9upjQ8F/MoHuh/i8rNEMtEjoBMjM5vmsaZeKgrYYyczA8QlK67fIXiNWBOUqhKl6ee8FLHx1F3ozN4Kt0SlxHV6GEccB4yNlAOc2BuSrzymYKBIiXlGyCPkP1NexOTIUvu9da/HNM+GdhnUoh353jK643Hf8e7vFcSsHfMTaY0KQGelV1InA+Luymc1Exd9N+A0IAGjuKVJWiFyiPLAn9Yh8XWkgPTqaavEcH/+TMcmxojaD356Bjx1FGF5RhwkgPZCS3j1zqBy7Vd27A3ZRh4Qyf6XMtKOIY6mb2P7SZ8PAfADhIQbC+96eokJzzD96UAr3sQ+f1jgPD+5+ycmP/whYlaDckgYyBMC6HbOccsPse9elVU8m6coAvb3ANYf9QgO0/kHbnoQZYtMMgo8ZZKDhz+s7pRdWlIEK22kcM3Bt4vrJYrW+DQLtCgBln0hv3cipItbPZSfYO7AuGoFM6xGVNJBcELmerswn+OUiLmZyoSNSTx2yCaOwPsiVhdVsr4pNAD79nmi2TN22YO6YUVppFsFlpgPsF0bfNDPinqMELDV7gk1PY0V1lbYat9TOVlx6xo852VGaFAzAXxSlAMTfcOJfwrG0H2CuWn/OxgO5B5u/0dXd35aF
 aEiceTTW
 HF22vHaGrAwdr7cQecfC3LT+UDMeB8WAVo3HQtUIhMlLgmj8ZZ/cgb7pdPnBZ0DAuuuEG5FfWSYBM5u4DLw5ee7xWtt6HIU5+hQVFLwZYKj5iCI1OVItF+lv/TK91WcKhCyYWF1+adRFJPxlCe1Idew6kpVUBuxD2WAl65NJn9SCYKtMkq8+0uug5QNrTUOGUSzMqFbNVEckg+dwGUoQ5+u6LEzsHf0CX6zD84yhilpVyQdPEbs8KYGh5gEzO8oIl9LGLiMrHHS1Ox53iEf0e9JTIxPDYrQ8AlFLG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 01:22:04AM -0800, Chris Li wrote:
> On Wed, Feb 11, 2026 at 10:12 PM Chris Li <chrisl@kernel.org> wrote:
> >
> > Hi Youngjun,
> >
> > On Sun, Jan 25, 2026 at 10:53 PM Youngjun Park <youngjun.park@lge.com> wrote:
> > >
> > > This is the second version of the RFC for the "Swap Tiers" concept.
> > > Link to v1: https://lore.kernel.org/linux-mm/20251109124947.1101520-1-youngjun.park@lge.com/
> > >
> > > This version incorporates feedback received during LPC 2025 and addresses
> > > comments from the previous review. We have also included experimental
> > > results based on usage scenarios intended for our internal platforms.
> >
> > Thanks for the patches series.
> >
> > Sorry for the late reply. I have been wanting to reply to it but get
> > super busy at work.
> >
> > Some high level feedback for the series. Now that you demonstrated the
> > whole series, let's focus on making small mergiable baby steps. Just
> > like the swap table has different phases. Make each step minimal, each
> > step shows some value. Do the MVP, we can always add more features as
> > a follow up step.
> >
> > I suggest the first step is getting the tiers bits defined. Add only,
> > no delete.  Get that reviewed and merged, then the next step is to use
> > those tiers.
> 
> Just take a quick look at the series. I take that suggestion back.
> This series is actually not too long. Adding the tiers name alone does
> not add any real value. I actually need to look at the whole series
> rather than just the tier name alone.
> 
> Chris

Oops, I replied to your previous email before seeing this one.

Stripping out the remove/modify parts is also feasible. Do you agree with
that direction?

Youngjun

