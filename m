Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75AAEF45A0F
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 23:32:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF2B96B0089; Fri, 10 Apr 2026 19:32:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA2416B008A; Fri, 10 Apr 2026 19:32:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB7A26B0092; Fri, 10 Apr 2026 19:32:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 979CA6B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 19:32:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2850B59CB4
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 23:32:35 +0000 (UTC)
X-FDA: 84644247870.12.6FB289F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 56781180005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 23:32:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E3Q+zmtD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775863953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YHfrjeewzvMm/U30Jn4M9dlG1MAkW5RT6TZZCwkxTaA=;
	b=glz5MxKwVmF6JdkVPMZB2hH6ijLhTMRQdaph/eTLi8p8/D5Hq99H4bRqcm6xOGyOVyGjrm
	R8+9bJvmxctOmulXRyf0XZf9Uozt7bkBYiE3KxMCk8E7LTtACj1TIqe5zmWfcyZA1j5QFo
	BMbKxK4MpAv24vM3UcDtyYKSFj/Q9FA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775863953; a=rsa-sha256;
	cv=none;
	b=ttqLmsp6MV/9FkdRiPMkPKXNJp7ahSD1sTZWVUWvToTBqpBCjDH4P78J7Vh2hD+OD/MM6X
	liLxsb1C2HwJGuvdgvu+Eu8yo0pYk9Yo5wUwFd4sadR3LsDcG7ne0S8zBaQGbIlg9Fsdcp
	R5RHOU7N7IjI9jcDyBikBBFVhsJsLtY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E3Q+zmtD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3ADCF40D71
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 23:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8310C19421;
	Fri, 10 Apr 2026 23:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775863952;
	bh=IV3mFcV+WfFE+K96xMEd38e94LBkkMv8FaH1PhoHLYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E3Q+zmtDNgVMUah+YlSf9vBbWGR6tTqXsD9qISjT7L1McGuLeEU6YcOaYPV8E3vMo
	 5FxdvHcTC02fshJ9kTRpZ9KDik65jOwROJa8Lj44cTMExkR3yGGmIvX0WqE/Zxbfy0
	 frgu0+dy/0Wv0wNOEUGHD4G0xAT9Pqi1pGfSbfjDbavJZuWHd+VA+CYkULJDVYJeHn
	 eCwIKuwJWYdQ2mRc4+z7suDS8x+EMBt56MyoCTk21xa9uX82BVwmnLUdhUmLds2wHm
	 vIpnnSb1eXBQ2FtKcw4jb0+Z5uba9PAIvnrj3ZQZyIhohRKDQVPUtQVfXHT7nuhQw5
	 jbyPAC7ALE2Ig==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v5 01/11] mm/damon/core: handle <min_region_sz remaining quota as empty
Date: Fri, 10 Apr 2026 16:32:23 -0700
Message-ID: <20260410233223.88212-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260410142034.83798-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 56781180005
X-Stat-Signature: 7tuubbz8q6zy8yb5cm4eqejaa5defakd
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775863953-594808
X-HE-Meta: U2FsdGVkX1/1TYjjrgxpE3pY5Br8dF/a0qN05LfG4xZLxnI+CYTRLYT3NfOxvYsDRhsFDErmKozse1vuSjNK/LMwWeE1JdQTArBMKAS8XFP88sTu+32p9feZZb+isA7lFqLa/Mji8UH0UUiQwOB01Vm5MNlde8beW4VHYIJ9Eey+Rc1cvN8rZoNwmrPV45yoL0oryQaB0JSn4XD+vV78x0RMqvh8aDcl8HdbQ5VQ1c+xpE05chbTVqTEBSzaj4aT2xxLXGz6AGQX8tJrbH0tNV4uItOc+8r328Cfm21W2UC8a57gyhumAQ/wNNtr+ml9a8Fyh74O3eOKKFWBj/OzMX5Ob1O5cZHeFJEkTFdouOletuQHrXTA7wFGX/XY+xm5DR3c37KHohpRChvHHk+u8kjtsrVjhluPK/13RYl8X+p39Wc11JK4w+NFDz+1Tc8EOEyf6Qrr2pPtYjg6ot5fBBXUXv53yszGgWXCNfcErV75R4lkK4Rz0ehFFQJpyf0nOOJI2z772/zihbKgloBQkeqsIePcdstqvw+m0vfcaMsqFUQOOIPUFOBCFq9m166CEnoK4rkbDsSiH7lEZ4X2WqfuH8OkDSVepWa5Q07jdp0U6tim59VWpXpsCyfy25cXhebCJJcBBXc1Vjxqy++ED5xi1VkuW1fswD8kwIj9MBFBWoZj3uX70y3P9p6pjKrGTIqPWjTaaT3vdXhxjTYJ/J/3+shmstqYHpcUKGziTpkM1Yn8XJpBWOZDJtbCl7/Z+uEX2gBt+JuoKt7I5SF2RWR/5yCUJhGR2hVoGZr/kmvF5oMi495Vm5hQu1XZAhOyCo+H6DChI7w/+thcy3TnNf6G0C3olW3uq18uWel7rhmfz/wsTHuZk3M6kVrlRCetXQ6ravIcJXo7goEYc177G7BGsm6JzP15bpWtqmpX0vlAhspZ/LEQtebG6WvL4G6hM2BDpXVnkeYqu/Pwgq8
 KKrvq1EB
 zxFuIC25n4W0QdLWsGApeZos2HiDEkvZSu3leAKrFeL7c6uWamlwxwIUKbAYywpjbZsfmfW3YEpfqnQimT7hbF5MVxsLdk02e9VDpJ3ltBBiWQupMcXDfFadqcwKMyo25vxPPCdBEu1wMPbW13pnPDGudwZEjBqLvBHrhC/YtTCmQiOgxhItMTJAiU65vszILygtCYt1GlnV+Sm6VvxIThduqU9RipaklkU26FRuvoxdcugAPMNBwHWZwjy0b8tGkBkoxRRLu5K3PVrWmHmRYvfOd8j6/Qzva+hOvxbt7JJgM2V+9jarzobqzDVDQxdXhf3wTomTTWvVHczHLGu8sj5Wz4LBfqWw8lVaM5stxTzCupk2hRUCv3TjxblMnHSGyT+AtPrtbTgOnOaVeFiLKNLrnv8LN8T7L3bISgsal8bIEoMI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: sashiko found a good finding that better to be done as a separate
cleanup work.  This patch still seems good to go as-is.

Forwarding sashiko review in a reply format with my inline
comments below, for details of my view and doing discussions
via mails if needed.

> # review url: https://sashiko.dev/#/patchset/20260410142034.83798-2-sj@kernel.org
> # start of sashiko.dev inline review
> commit 2ab7d52b1eb10efa95d43a8eee7c50fd9669d56d
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/core: handle <min_region_sz remaining quota as empty
> 
> This commit updates the core DAMOS logic to consider a quota fully charged
> if the remaining quota is less than the minimum region size. This prevents
> actions from being applied too frequently to specific memory areas.
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 12544c60531d3..8dbc365bb8e97 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> 
> [ ... ]
> 
> > @@ -2127,8 +2140,7 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
> >  			continue;
> >  
> >  		/* Check the quota */
> > -		if (damos_quota_is_set(quota) &&
> > -				quota->charged_sz >= quota->esz)
> > +		if (damos_quota_is_full(quota, c->min_region_sz))
> >  			continue;
> >  
> >  		if (damos_skip_charged_region(t, r, s, c->min_region_sz))
> 
> With this new check skipping regions when the remaining quota is less than
> the minimum region size, does the truncation check in damos_apply_scheme()
> become unreachable?
> 
> Because damon_do_apply_schemes() will now only call damos_apply_scheme()
> when quota->esz - quota->charged_sz >= c->min_region_sz, the ALIGN_DOWN
> calculation:
> 
> damos_apply_scheme() {
>     ...
> 	if (c->ops.apply_scheme) {
> 		if (damos_quota_is_set(quota) &&
> 				quota->charged_sz + sz > quota->esz) {
> 			sz = ALIGN_DOWN(quota->esz - quota->charged_sz,
> 					c->min_region_sz);
> 			if (!sz)
> 				goto update_stat;
>     ...
> }
> 
> will always result in a value greater than or equal to c->min_region_sz.
> 
> Could the if (!sz) check and the corresponding goto update_stat be safely
> removed since sz can no longer evaluate to 0?

Good finding, but doing that would better to be a separate cleanup work.  I
will add that to my todo list, but keep this patch as is.

> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260410142034.83798-2-sj@kernel.org

Thanks,
SJ

# hkml [1] generated a draft of this mail.  You can regenerate
# this using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260410142034.83798-2-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

