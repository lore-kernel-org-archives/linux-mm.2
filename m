Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0BF7CDC165
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 11:53:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6520C6B0005; Tue,  6 Jan 2026 06:53:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63DBC6B00AF; Tue,  6 Jan 2026 06:53:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 532FC6B00B0; Tue,  6 Jan 2026 06:53:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 411696B0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 06:53:46 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E962DB99CC
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:53:45 +0000 (UTC)
X-FDA: 84301379610.28.1C6C5F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2F599C000D
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:53:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mpWa0tkG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767700424; a=rsa-sha256;
	cv=none;
	b=7PZ0qzFsNgA0EBzkuCO9uIJsBsykHGFfbXE5nkUr2OYmEUdkKNkp38y6B+nvER/4Qt7vAK
	V5Cun2VRd8wT5hRjhp7hUwNmdKXgS4LEWVhfzF412IOhMseO+1p/ytlqG7Wf4s+xuCbOVH
	1gZ3oBlX3H8mMxE/7SPjvK2FjTrsFtk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mpWa0tkG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767700424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zB04r8KlgQGhuegiaiZFqUY3G4Ol0Y1xiXaAvNuHe+8=;
	b=kaQF6HT9a4WGs+L3cr/eNbbwlvXfSIcXg/16BvzKYd2sjTi8uAc+FvlIEA/K0HNrOFQY+h
	TBEBzulfmuTgHzbAwR42QZlH9Zx1KfPkY+fE48TBfQpUq5ISiqAekJxxh3qXrPtxg55vfw
	viod910XUjNXEb6yx+DgvygIVvJYzWo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 10A0A438B6;
	Tue,  6 Jan 2026 11:53:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8EFC116C6;
	Tue,  6 Jan 2026 11:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767700422;
	bh=Xvn0KzHIQsQJ6c1k2KNmeqFTL3hrNo5vss3Rvb9PW70=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mpWa0tkGKJJZcUU3PuFjeMR/w4u/o/WnuY5JZwNftW24ZMVIAH1rUX5AeBEAhwk+G
	 5FH/DgK5ZQpwuAA1JpxnW1WkYQHNNXapqhx+i2vJnP44dxhugTeSPcGb5gfHCXEEcd
	 8+7jWpgOnkoE1gNPD8GHpdpsLrJdUYMJCUWvFIdHAfpCZUN6M7VI84+I8fUNPtnBSp
	 UDQgttD3jejLWDfzwXhHTLSaOAH0lkle2WsEWJ/dAmyh00V63xrekOvaD9nN3Vz8XB
	 F2BI4Ff7TEM2WNYd3v0cJaFyvLuXWxyK6m80OiMxckLMMqH0sNml2VqfWc0vR8hxto
	 8WJD8ndFbIg6w==
Date: Tue, 6 Jan 2026 13:53:34 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>,
	=?utf-8?B?bWluZ3podS53YW5nKOeOi+aYjuePoCk=?= <mingzhu.wang@transsion.com>,
	"kees@kernel.org" <kees@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>,
	"mgorman@suse.de" <mgorman@suse.de>,
	"vbabka@suse.cz" <vbabka@suse.cz>,
	"surenb@google.com" <surenb@google.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Jiazi Li <jqqlijiazi@gmail.com>
Subject: Re: [PATCH RESEND] kernel/fork: Update obsolete use_mm references to
 kthread_use_mm
Message-ID: <aVz3vlG2PlQ9JX_Z@kernel.org>
References: <KUZPR04MB89656F6F10537974E46766E08F87A@KUZPR04MB8965.apcprd04.prod.outlook.com>
 <aVzVVTS3gjtz4XNB@tiehlicka>
 <cbcc95f1-5039-4fe3-bc7a-c8edc29f5b11@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cbcc95f1-5039-4fe3-bc7a-c8edc29f5b11@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2F599C000D
X-Stat-Signature: tr6sext5k8nh56nnnqfu3wmxwwjyijra
X-HE-Tag: 1767700424-981637
X-HE-Meta: U2FsdGVkX18i47zrDgjRFvIj8yl8er+8hlUvklGtRbBI/eq0q4WsI12dQ7ONSFCSN7r8B8wFJoAVesq51O2OgRQ0z8Pl7rKuKelkL2AfXTKjtiJ7kS9yM5qlg3S3fa9Hv3PefaTy+OprwF6BC0q4iS6Lph1fCMvXoVsE9AfNIwZziDqKY6M/pcLWUM6R872aOHixIP2WfZeawoDVMpmHMeRXLdjYZk2I16cJMlFxGhVsFXMV60M8UgLEBZAVGFZmxjA873CsYnD6GgSILaYULvZ26UPdkf8V33yqoFcS77xpqc0A4urGY61RlVVjiwxLvWPwSfpaUigT7n2JbiLp75t0fvrLhbLHC7V34U1sGmS+C6IsU2t2/0qfmhV7KkQKIjIWVREmszrCHOjslRBHepse/sJoICCfIvl5FmO7zA8B8HXrq2mid3+qtgdSAUkINbeWtrmjaP2ZtUnO0cJvmhUSyd32GbY4Ar9c42mcv4WkmCYv8yQHCDSY4Znr8WAgFmoUg7MblVwyKaH5inNjZ3ZRgq+2mull4fMScPko56QUFIax/QxbX+mXyVpeorCXDLJL9taVmIbOgZSkT5q2T7HK8PH4vLfrp/ISXnye3i1NoQYyFUyGE9dxjsdfTw6gAN4WacU6+Jg900zoHcxmzEqikfBWp73YAufYB9ji8/HJEPMX1sEIozlxvBOIW+eCSRk7c9HpJxrA8LaSycnDaec5EqXpMIxJ8MlOJQYeSHf+1xyUmF3ClRF0146CpgQJtTOQjlrgIT/oIFjxs8kCTAhtVecF/Br0omgmHrwHjZU/WrJ6ULAxxfPSzS1J1jaEct7JDCQ6H9QcyLI6zqgHegiYI29+3zR/QvnnS0FSoh9pBOuJgg6XqPjY38Bg7N0wIbJs6mscYrReHSj/cibZdd0+tk08KbkwWuMDupgeC1jwM4I2TuNNskNWQofZ7wXgLR0JodB/E8f0sP0Jaac
 Y0yDWuPB
 NyrcEqgssPcE1uQdBxclcwizyf5I3fHpX+VA0WmJSxSrGH+0zHPyLd47TPUgeZJcvNRM7c54gYZKyOZzPmeHWuXcbtesKgyf2T5QAKL54ZuILKYyLg41nJqMd+Qxdl2rxAQury7rwZclgpfWfrZLvJ2JyR7Yi6tGKhvd++sHlW32M8gNlJ4Pn0RusAwmxBvQeyyyh/jU4QG8LbEOIjVMsiaKnkCF4ntd3xryOFF/jMerxEK8hnu0rJyx/9hYcR9wczyw+6IqgMny4rJImv12h97A3Q/nIauIGKGfhW7bBpYenPtH0NdViSlgFin2fmT5XCKDPeaOXKz0mPcLWA6vx4FsnxuA6LNYBwE5HC1kSGuryggF5bjy4LdyHFECj8pTFjmUFyjrR94g1gCPRnJLfNmgIwMXsXN0M1drqJ4LXED/VvDhrwiZwKw8Xb7CTs6DBMmTWcA5IPI7VUlBaPQXD0cMgWL2dQVv/CFV0sO4JrpX7O1lxY6wODGJ47o7L1LpjJnu9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 10:29:03AM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/6/26 10:26, Michal Hocko wrote:
> > On Tue 06-01-26 07:05:28, mingzhu.wang(王明珠) wrote:
> > > The comment for get_task_mm() in kernel/fork.c incorrectly references the deprecated function `use_mm()`, which has been renamed to `kthread_use_mm()` in kernel/kthread.c.
> > > This patch updates the documentation to reflect the current function names, ensuring accuracy when developers refer to the kernel thread memory context API.
> > > No functional changes were introduced.
> > > 
> > > Signed-off-by: mingzhu.wang <mingzhu.wang@transsion.com>
> > > ---
> > >   kernel/fork.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/kernel/fork.c b/kernel/fork.c index c4ada32598bd..64e228c541bc 100644
> > > --- a/kernel/fork.c
> > > +++ b/kernel/fork.c
> > > @@ -1312,7 +1312,7 @@ struct file *get_task_exe_file(struct task_struct *task)
> > >    * @task: The task.
> > >    *
> > >    * Returns %NULL if the task has no mm.  Checks PF_KTHREAD (meaning
> > > - * this kernel workthread has transiently adopted a user mm with use_mm,
> > > + * this kernel workthread has transiently adopted a user mm with
> > > + kthread_use_mm,
> > 
> > Please do not wrap the line here.
> 
> But please do so in the patch description, where the maximum should usually
> be 72 characters per line. :)

75 ;-P

https://docs.kernel.org/process/submitting-patches.html#describe-your-changes

> -- 
> Cheers
> David

-- 
Sincerely yours,
Mike.

