Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB060CD8C89
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 00:15:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3452E6B008C; Fri,  5 Jun 2026 20:15:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31CBF6B0092; Fri,  5 Jun 2026 20:15:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 259C86B0093; Fri,  5 Jun 2026 20:15:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 133D86B008C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 20:15:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A28C98D280
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 00:15:33 +0000 (UTC)
X-FDA: 84847568946.20.35D222D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0E37E12000D
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 00:15:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bzsbv/Is";
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780704932;
	b=HgwAk8+8/Y4vNbPHR3ccBcUvIBfkkPGMyuMfv8x88oKcP6p7zH4HX33i0FO8f1gePvxMsg
	ZbNC3PitZ+CYw66QxBDw5TAIMhbks7sd9bJ5qwAUIkqVXUFoPXwR/bgztOnoYLR705OHvi
	sd1NYstCuwP8gAaKs1kk3pb78rZXDEc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bzsbv/Is";
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780704932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q21/N23xnTWt5KQrxm+P61rbnPXycWl3dQ/AY35648Q=;
	b=PFB/HINqgIX94TQD/5JBom2nYmZuxZk0nEFfjANKvm+Fa40bWyaAeQKtQG3Ct7sQ/izbhJ
	07M0NUqgyUMpCptZNpFxl+7NS4SD8sf8IR8DR1uDzclSTeVR+eME9ETiU7NFPDOinyngNm
	3QCictanYC7Beb7FIsaNgqqpKSSLa9M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3EB7D419EF;
	Sat,  6 Jun 2026 00:15:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49B01F00893;
	Sat,  6 Jun 2026 00:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780704931;
	bh=q21/N23xnTWt5KQrxm+P61rbnPXycWl3dQ/AY35648Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bzsbv/IsDaorrjh/e4WXwy/3FE0jWFrn4HX7GRVwyLx4TLK8be330nHKnmR93fwCE
	 6KD0jq9N9i2m40MWCuSQsWrt2hNoLur9q2KXK0wfDvxb83y64je9NJWJ6vt7iZzZvA
	 wwrHVUCGgb/sE5U4c6v89Swb0KIHJHgCB3i0lCZZiN81+gQqfM4gY6SSUhAQXapuyX
	 rcaNrGG9+RuPQ3dG+7YBduaFMWy5wG3WBOqdHvVOjEGJfUBkEOaYI3mWdNVMYP+DNN
	 FxsyGrRMagvzLKWGLKdqgkj+rMJEjJJDraAJKtVxzpbenD4Ex8J9WT2REhPNQms+SM
	 SBux2YqJzYC8Q==
From: SeongJae Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 2/4] mm/damon: Generalize ctx_target creation for damon_ops_id and add vaddr support
Date: Fri,  5 Jun 2026 17:15:23 -0700
Message-ID: <20260606001523.88590-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <a9269eaf-a567-4dfe-99a3-cee4b13946de@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0E37E12000D
X-Rspam-User: 
X-Stat-Signature: zmmuqh46n8qqajoyhq6a8oyxnb58cbod
X-HE-Tag: 1780704931-356379
X-HE-Meta: U2FsdGVkX19k5uqBQdZqBDHcsD8/xcWBGkrcPlOPuNbOv5rerIt6WUG63XU8lBoQRKuuMj7ObRggaUCoL4sOG4A4pbBaGf98dIGJjEDpQWMBacOxQpLIfP67289scwWnTjf7hfdRRYF7lLcRBuI6hHo+ZPs1MC6BQeorUmfZSv0pakZJ3dfGZ+CYI8aFiQ2g9gL6Px2orF6zrbWf2Pukp1bPjqH6OuO3vfDkNDQD/Kk4Mw1+p7sScZKJc1ASSex4dqVnlEU8tIc46K0QOxp5pFipkgWz7XR0eubnL7A6B+7dsBrHZMPbMoKQMIpB8lfTuL2NcyCc320Sx/0LyJpPemUfFOWJlGMHb879k4WZXCcodHG6EKFEHbMbtlrP45v1zgfgAzuTBAXmE7ZW0ZUSRTcan/lviuLEfSEKRRmabaQ1K2bjxdPPUkZ+pQ+4Hz9Y3Y1d09qUFxC2+sROD7V3h7Cb+Ux3+mxojM3+DR0QIjMq5/G74df4yBQUuu0S8ba7N844YXNhquxrkKXM+LGBlrMWRDKLJiv9atadEf3mitT+fZaxwkrvriEhtbPmsV7UuUaM5GTLyUmeJ7+7S0rngdUFvVoLS9ueRz3gYwaEzYBiJuZD/6YXDSdqsA22DMvUrghtCWfSUSiaUZsgO/53UcVQutGBGVXKVzW9ohddwsCRDDr1qJHuIudgpSvXAOv2HF5POxcUMEhI5G4NKWSsgN1G5ectweJkzx5lsHSgUUZ34kaFjztP6YffO8dVH3EUGlGxL5qN0ziD+qZVg0CFJJoq0vvTB7PoKZr/IZEN5L0I+2w2KZa9YAKNdD1mjpSoseE7adSbfL5A6pNC+H+crmjkbqICs3PSgphgDpkcGdu+6JV84CcRb6eM/M3wAc6mnvEyU0b6p9JjioKOLguK0FXg2El6KH192Hxf+/7JDAlTG6ghI7ppSymIh02WEEd35lTSsfmF/E4+NERDflZ
 hbl8RI/Z
 b1LYRX+Lq2YcONnK73ettzLd2lZ+Mu2JDUUP4mVsH1i30yws8HKlgzDOjBAAVV0CmiAMt8WfxWgZ8393tenzLeuHXT/Ugt8Ti4myn0TUD1VPXI5XwgY36ByQqPcpCWmbIIya3RrUWapfivzhyKfqwXScw32BXodCojZPW1cSpvmuGnEun/pfvU1Vpds+Rehw/acj/+OB/7Nv6MrH8C7BY89fu6TRV+QkaF1Eo2A+YEaES4fNEazBcHfDfXPPLXU7WgD44Z1K6OSEr3C2xQ//wm7/dxgvI+peDxSj1MehZwiVoYCo3pBYofmLgt6YJJQXo44IOSkyW9zofX4C/wq0DD2Ayxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 5 Jun 2026 14:13:01 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> 
> 
> On 6/5/2026 3:50 AM, SeongJae Park wrote:
> > On Thu, 4 Jun 2026 15:03:35 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> > 
> >> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> >>
> >> This patch adds a new function damon_modules_new_vaddr_ctx_target.
> >> Since ctx_target creation for vaddr and paddr is almost
> >> identical, the logic is extracted to a new function,
> >> damon_modules_new_ctx_target, and vaddr and paddr functions
> >> are left just as interfaces.
> >>
> >> This change was suggested earlier1 and it is needed to allow
> >> developers to create DAMON modules that use DAMON_OPS_VADDR targets.
> >>
> >> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> >> Suggested-by: SeongJae Park <sj@kernel.org>
> >> ---
> >>  mm/damon/modules-common.c | 31 +++++++++++++++++++++++++++----
> >>  mm/damon/modules-common.h |  3 +++
> >>  2 files changed, 30 insertions(+), 4 deletions(-)
> > 
> > This change is for the sample module that will be introduced by the third patch
> > of this series, right?
> > 
> > I'd like sample modules to be simple and completely isolated under sample/
> > directory.  Is this change really required for the sammple directory?  If not,
> > could we please drop this patch?
> So, just create the context manually in the module without a new
> damon_modules_new_vaddr_ctx_target interface?> 

Yes.


Thanks,
SJ

[...]

