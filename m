Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77B8BD29FF0
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:37:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E18966B009D; Wed, 14 Jan 2026 06:37:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD5DC6B00A2; Wed, 14 Jan 2026 06:37:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEC326B00A5; Wed, 14 Jan 2026 06:37:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BEDEE6B009D
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:37:02 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 81AB558ECE
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:37:02 +0000 (UTC)
X-FDA: 84330367884.01.0953FFF
Received: from sg-1-100.ptr.blmpb.com (sg-1-100.ptr.blmpb.com [118.26.132.100])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0637BA0008
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:36:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=J3Hu6HiH;
	spf=pass (imf25.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.100 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AVL3G2HCwqKXubnC+JHqAJYzRl85r2kRNuxfLhEsKlg=;
	b=QD62DhC0iM4SVwhE4hcuqv6lfrX0t1sMABQ9WSDhe/iktmFXp8BHubT6T3ENYRdWSvJI8r
	cYpy24ODmTaptdNG/YwDSB62y/0NKquoZ/Kq5I0PFApnI0Cuv9GkBeIY9ZkRVVc9Q/paTd
	prFT4zL58fyDbacXcVeLNzAudwoHfZA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=J3Hu6HiH;
	spf=pass (imf25.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.100 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390620; a=rsa-sha256;
	cv=none;
	b=nsN/au9daUWfERoQpethz+r8PHAsU3lowitgOMZMJPEkJXjlSk6HQCMM9lPBwEzaIMN/XD
	dEj8ObP7ib+f0yYyv9E/Ip0EuCPKGrHSh+BL0FBPVvUhGIkZ1E8i60Wxy/JdLKSPrcB9Rp
	tmVRssD+clR2E2H26WqhDMh8xetCOPo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1768390611; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=AVL3G2HCwqKXubnC+JHqAJYzRl85r2kRNuxfLhEsKlg=;
 b=J3Hu6HiHQzginxMXsD8KBlJCTUDZ/0rIYf+T1beexrLwCsWJw86qLp9UBp7N6nvHIzX2mp
 vQ8/NMdGQ4ehO3YdmZlPRE03gWeIokajaJ9fqz7617zddSVB1ysZ6kPwRiWv6fSXhphA1J
 VQQa5TSOz9FLrmxpeZG0kR8cEQY/ror4o4kAMB5lSS++8H4T9Czk9vM6e3me7yPVB+C33d
 Bta0h3vpy7IxDAIxEV44NLWdq++k5B/wnjajzPrdB2vGkd4QQ2S/O2m6Dku5loaP5reDJx
 8syTttNUFAFufRkuOd4gSSx3u97xq3VkdDKxGRx12gtit2s2EDlr8B8lri/7MA==
Cc: <akpm@linux-foundation.org>, <ankur.a.arora@oracle.com>, 
	<fvdl@google.com>, <joao.m.martins@oracle.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <mhocko@suse.com>, <mjguzik@gmail.com>, 
	<muchun.song@linux.dev>, <osalvador@suse.de>, <raghavendra.kt@amd.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Wed, 14 Jan 2026 19:36:35 +0800
Message-Id: <20260114113635.97621-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
To: <david@kernel.org>
In-Reply-To: <3d8398f1-0130-4d3b-ac54-d23877811747@kernel.org>
Content-Type: text/plain; charset=UTF-8
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.45.2
References: <3d8398f1-0130-4d3b-ac54-d23877811747@kernel.org>
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
X-Lms-Return-Path: <lba+269677fd1+18e522+kvack.org+lizhe.67@bytedance.com>
X-Stat-Signature: unc8ipnctfix5koa3wwzxhkxibu793ib
X-Rspamd-Queue-Id: 0637BA0008
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768390618-502024
X-HE-Meta: U2FsdGVkX1+vWZYdNGgiROOVBM5mYEUn4x5wVKD4KzPhwT9Il0LbH7z+qnRymKT2cr2Ahta93Zl5/J1WXM4i8juTqKKeSKcygSLQcm30NIQ7oURKKyWYpn7fIbHJ0ewVro50quZjM+3BbSsvai9cpFY2o7G1NZOwUYx9r5Y2LV1FFehFr3XPDYj58LArvcI8vXfQTSKVopoqn6QvZ2hR7lAxF0Ev0BWkJXDGVFaY7oeQBqAJkyAsUD6iCKQp39pU3fdADMaCIXWTGnNJk8bjpjf4exulFQLQ/5u9+360xZCjqxSyA1yLa/ocyRDJQVC0blHdVfwRfyi2zndU1ucWnuLMlG+cXd9dRUqgaHArhWHQwCX6kH+WCdYcL+bFqkmuPs9wjE/Z1fALvP8O4bKGA53j/rYvafNV9DcP25avWZ0IhUrYkTKRfWKIJcMu39zHo13+LFUCwcoWfnlQiPuPPmPVC8eUE7DSNOh2DMMw4lu6C8PtbBIP5a0TF7puVzyz86JWEgpW8Lk3FNTRZN8gD21XBRQKfZqQQ5QZgjJqW64qlhHsmKbTHVfBBF2p8AjXtoV0NkO3Mi+IPBIM+R+bAhaLTCyOdASZvxbCCw07wLHuNHba6Y/JA+N7Jt4cMJsgybGeGOXPdLuThlzgi6vGhPhnrZHo60C6OVjOwosHGIsYHWSTrTKUE1L92nf3u+38SmDsCHaVNAlDDQPHVP9rzpGNJJhLW9fgxY0OPQRLy3K8zDtSMQZij6jPezPC9d3ZgecpYOi2m4BaFFggHZTl/7v0QAV/MgrXer/SA5vWJs7wdiNqAeFckLgtWSzgh/l16wa0bPnECYRBjnnJi85GZqiAwgmyXwxjtBAIW88pdxiWWabqI/kLc0br3BXhzqYsavxTKoJjikltBkTImBx6ieWkXxNojSyNmVdBskOJWpPWmhSHMmJ+IGDZO6AejmygtsxQ+V+LJ/KYExfrAOm
 l0POaV/C
 vYod9pvvmj2tZLHml2WoDBJ8SBd0YAzsVS7iDUJBIFm5kdWltw+cq3OKR7kCzcuhB3JB0JW/HKcfrqhZmlXitGY3nT5YTBc9X6LPDPKTJxp0VcfsEEB0Dgatukg4LwJCxbFRn0vD1vpDN2ZxFueLlHRTccMjCGg/g7dqTe2wmz12RsXnz7ixiKSEkdMZvQocadkAJD9gFLdmmtPLtEaUq4p5cx6V2YgVTqQe6xuLv/j0/nkjzhxbTw9tqMkJOy120JlYU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Jan 2026 11:41:48 +0100, david@kernel.org wrote:
 
> On 1/13/26 13:41, Li Zhe wrote:
> > On Tue, 13 Jan 2026 11:15:29 +0100, david@kernel.org wrote:
> > 
> >> On 1/13/26 07:37, Li Zhe wrote:
> >>> On Mon, 12 Jan 2026 20:52:12 +0100, david@kernel.org wrote:
> >>>
> >>>>> As for concern (4), I believe it is orthogonal to this patchset, and
> >>>>> the cover letter already contains a performance comparison that
> >>>>> demonstrates the additional benefit.
> >>>>>
> >>>>>> I did see some comments in [1] about QEMU supporting user-mode
> >>>>>> parallel zero-page operations; I'm just not sure what the current
> >>>>>> state of that support looks like, or what the corresponding benchmark
> >>>>>> numbers are.
> >>>>>
> >>>>> As noted above, QEMU already employs a parallel page-touch mechanism,
> >>>>> yet the elapsed time remains noticeable. I am not deeply familiar with
> >>>>> QEMU; please correct me if I am mistaken.
> >>>>
> >>>> I implemented some part of the parallel preallocation support in QEMU.
> >>>>
> >>>> With QEMU, you can specify the number of threads and even specify the
> >>>> NUMA-placement of these threads. So you can pretty much fine-tune that
> >>>> for an environment.
> >>>>
> >>>> You still pre-zero all hugetlb pages at VM startup time, just in
> >>>> parallel though. So you pay some price at APP startup time.
> >>>
> >>> Hi David,
> >>>
> >>> Thank you for the comprehensive explanation.
> >>>
> >>> You are absolutely correct: QEMU's parallel preallocation is performed
> >>> only during VM start-up. We submitted this patch series mainly
> >>> because we observed that, even with the existing parallel mechanism,
> >>> launching large-size VMs still incurs prohibitive delays. (Bringing up
> >>> a 2 TB VM still requires more than 40 seconds for zeroing)
> >>>
> >>>> If you know that you will run such a VM (or something else) later, you
> >>>> could pre-zero the memory from user space by using a hugetlb-backed file
> >>>> and supplying that to QEMU as memory backend for the VM. Then, you can
> >>>> start your VM without any pre-zeroing.
> >>>>
> >>>> I guess that approach should work universally. Of course, there are
> >>>> limitations, as you would have to know how much memory an app needs, and
> >>>> have a way to supply that memory in form of a file to that app.
> >>>
> >>> Regarding user-space pre-zeroing, I agree that it is feasible once the
> >>> VM's memory footprint is known. We evaluated this approach internally;
> >>> however, in production environments, it is almost impossible to predict
> >>> the exact amount of memory a VM will require.
> >>
> >> Of course, you could preallocate to the expected maximum and then
> >> truncate the file to the size you need :)
> > 
> > The solution you described seems similar to delegating hugepage
> > management to a userspace daemon. I haven't explored this approach
> > before, but it appears quite complex. Beyond ensuring secure memory
> > isolation between VMs, we would also need to handle scenarios where
> > the management daemon or the QEMU process crashes, which implies
> > implementing robust recovery and memory reclamation mechanisms. 
> 
> Yes, but I don't think that's particularly complicated. You have to 
> remove the backing file, yes.
> 
> > Do
> > you happen to have any documentation or references regarding
> > userspace hugepage management that I could look into? 
> 
> Not really any documentation. I pretty much only know how QEMU+libvirt 
> ends up using it :)
> 
> > Compared to
> > the userspace approach, I wonder if implementing hugepage
> > pre-zeroing directly within the kernel would be a simpler and more
> > direct way to accelerate VM creation.
> 
> I mean, yes. I don't particularly enjoy user-space having to poll for 
> pre-zeroing of pages ... it feels like an odd interface for something 
> that is supposed to be simple.
> 
> I do understand the reasoning that "zeroing must be charged to 
> somebody", and that using a kthread is a bit suboptimal as well.

My previous explanation may have caused misunderstanding. This
patchset merely exports an interface that allows users to initiate
and halt page zeroing on demand; the CPU cost is borne by the user,
and no kernel thread is introduced.

Thanks,
Zhe

