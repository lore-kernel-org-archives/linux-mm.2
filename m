Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3BDD606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 18:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hLm3dxmD
Received: by kanga.kvack.org (Postfix)
	id 068D56B00EF; Sun,  1 Nov 2026 13:34:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 018736B05B1; Sun,  1 Nov 2026 13:34:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E70246B05B2; Sun,  1 Nov 2026 13:34:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD70F6B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 13:34:14 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5253040AD2
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 18:34:14 +0000 (UTC)
X-FDA: 85387400028.09.78CC3CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id B253D1C0004
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 18:34:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hLm3dxmD;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793558052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mdcb8PA8Fd6Cc1lT/iQNz2eYhuJFQtFMCUvyRyZT5cY=;
	b=ZhyeSBhtVvPW7g6lhzXHfDeRjDoONRnCnEVnpGLdZ+khuBdFTWxXqsUXdvQk1bwgQpSi3Z
	Uu1ch0eufb2qf89i2VThXdsYIjki32SDFtulFvf0FywsKIkB68nAI3pgaTRSo71i15Erqf
	3grUMldHj/XsgiYaHJbXuvCpC1YAGT0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793558052;
	b=MFRmXkaMSTpWk6oceGshq3lxkGzJSR5SDFwFiJOcqd+qpOiZUsedMRV0KHWf6WZ2G9bvjD
	6ePP4TV9cVMysx5sOv364oHqhjBiNj47NhjyvbEHzB+lMFlV2mjnJnz+Gq6Ee+PSOxlFZe
	8M7/NwCweVXYdcCWBkYyyH1PFfzRTG0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hLm3dxmD;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A55560054;
	Sun,  1 Nov 2026 18:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BAE51F000C1;
	Sun,  1 Nov 2026 18:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793558051;
	bh=Mdcb8PA8Fd6Cc1lT/iQNz2eYhuJFQtFMCUvyRyZT5cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hLm3dxmDedMrL0uJIydX4V5pvwijynFBnvMmkO6AIa0gsNMiytEFTqd9cpmP0BfeW
	 ZGWcQpNCYUIqDD7t+eNji1CYS0nnQLYbFzUG63Fm7Lb5artoBEnMRWXTJZNQw5q8FE
	 E1ZVVghFjQeJSsWKS+GmlMNUhWXooFCdo+pMWFxy8XomwZ8J655cLKN/a0++FZrsL3
	 ReT6z0RPW/G+APAN9gLEKHp3PUIXWkUJVAQF8gQfyxNz8I69AEv7RC1MdQJg0KuGMF
	 FbrTg+FmcBnCO58kp4sOFyUhd+oVWYjd7vSmMYWrDwigh8wLQ3zXULhDszeWbUu86s
	 Ck5iniqhfHDlw==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v0] Docs/mm/damon/design: document data attributes report infra design (beyond page table accessed-bit milestone 2)
Date: Sun,  1 Nov 2026 10:34:04 -0800
Message-ID: <20261101183404.85322-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261017195747.89961-1-sj@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B253D1C0004
X-Stat-Signature: 8wf7zy6jnadj3661aofaok9ajkhpmhhm
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793558052-641088
X-HE-Meta: U2FsdGVkX1/2fcUZTpm8janua/Ze0LQa4R8vwJH5j5DSLUuHlD0xfpSLuaH2RG0CbhAEzwDN0RaGWgBmb9eYiz3QP71Wx82eB0sOZ1avbxGDNWzyvNYdmig+E2eiTcTFxBN7cYTl0yQmASbWigJ44yoI4miMs0X5NQyPgxFaZ58CZUclcu8xXZuQLCgs1OcHd18ySrPjnVlhfjK9fUVV2ilbPw22U+dwy2ir78Egtbyru41EoLOpRcZ8Cv6C4tfmn4plFbO4sjzl4aOq+NoN1j4JuWZFsQb0kczctV0gBiSc2v/FE2+U79Q8T0MIydbi9CLf4vbh8rPzcEBu9WbE5g6xuzKHjuLtK/SoTJIv5yNLtmOlyu2gnhtkh0dx33nP85G3vPUtHVkYwgIZZqvT3OFaUQGsLpOghGnap+BRssBIzcfEfqj/2VADBDa6jhfhMGMtYsb/SeAg7mlnUmfHeCJux+uGK/Jsba34uyLoU0WKjmTar3AxTvK02lkGonzfiH5N7bvr8kAKhAvNndLXdZz0uUJCL3/yZbKBAy/OjsoDOZFOd7jq/WpTBdZfSJ/EuhCAw5DkdzxJGev7/dFRQTKBBjfI/WreorHit6WePXgRsLmdX6seFf3hhwX89M2RBVUvpndaPhXiINEUlqk7k8EENCVXR0ITgzXjvdq2pyHRfC7mLgijKQpPk2+ptqIqQsXZgM2M4QKeaW952z3ZbEFogUljokt18yvjxWL/J8t8xWrIjtbr2SrMWqdVde4BF1Re+xU/8USOt82Rd0LDCYXbn/Dr/qTzo9oLP9Gf/fmeHHK4WDOhSaIabfT0FX/poCXpaooM12QyVMEAbU7QjzTakS5RH8doQdMtyU5awajuG28E9WpQo+iUmC7a0oBQgTD5RYeo5Pf8LJnrB+gppJLmacNcVDbOQ6E2cExsQjN09tu0yApEszUN6zBYSsnhfqH8PpfMKrJ4LvloaPT
 fcR0AkK6
 9H8igbMp1k8XhXRwggSraMr/VsxCzYntz0WzqvB031aC5OsCr8sYjwqI4s6kRxzh+5BV5zBsF4uAJbqY+CeGLnX9Say7nBe63wtsgIY4GmAV47s+XQAGB7hs0G2/9W900qm3fK/yVNpdRT9CxR0tCftvYqs2zx7FqJG4Fr30Ys9iPVvp/aYpsWtBU0VyA2Jjd0I514xK9V78gapRb1YtHvKzywDVkFONkvYNXPTqBORVOQzpu0tHLcYmaa/aP37eiWNly
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 17 Oct 2026 12:57:45 -0700 SJ Park <sj@kernel.org> wrote:

> The "beyond page table accessed-bit DAMON extension" project [1]
> milestone 2 is for building the basic infrastructure for continued
> extension.  After starting it, I studied perf event little and found a
> few demons in details.  I therefore spent time on high level design.  As
> it started looks like making sense to me, I'd like to share the humble
> design first and get feedback from more eyeballs.
> 
> Add a blueprint of the milestone 2 as a high level design document.
> Describe the API and ABI of data attribute report infrastructure, and an
> example use case of it for per-CPUs write-only monitoring.  The API and
> ABI will later be extended for more data attributes reporters utilizing
> AMD IBS, Intel PEBS, Arm SPEs like h/w features and any possible
> DAMON-external reporter kernel components.
> 
> Request for comments
> ====================
> 
> This is an RFC for high level design discussion, so no implementation is
> provided.  Comments I want to receive include but not limited to below.
> 
> Does the idea for perf CPU cycle sampling based access monitoring makes
> sense?
> 
> Does the design provides clear idea about how it can be extended for the
> future extensions that already scoped for milestone 3 (AMD IBS, Intel
> PEBS, Arm SPE)?
> 
> For the foreseeable extensions (AMD IBS, Intel PEBS, Arm SPE), would the
> required change minimum and maintainable?
> 
> Next steps
> ==========
> 
> I will start implementing the infrastructure and perf CPU cycle sampling
> based access monitoring as described in this patch.  It will go through
> the normal development process.  Delivery of it will be the completion
> of the milestone 2.  As set on the initial roadmap [1], ETA of the
> delivery is LSFMMBPF'27.  No delay is expected so far.
> 
> [1] https://lore.kernel.org/all/20260525225208.1179-1-sj@kernel.org/
> 
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  Documentation/mm/damon/design.rst | 44 +++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
> 
> diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
> index a465e34bb1d9c..1e699e3f8a496 100644
> --- a/Documentation/mm/damon/design.rst
> +++ b/Documentation/mm/damon/design.rst
> @@ -433,6 +433,50 @@ monitoring.
>  Refer to the :ref:`admin guide <damon_usage_sysfs_probes>` to know how users
>  can use the mode.
>  
> +Data Attributes Reporting
> +~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +Infrastructure for receiving attribute information from DAMON-external kernel
> +components.
> +
> +Because DAMON is not hooked in every place but runs in its own worker thread,
> +it cannot retrieve some types of data attribute information by itself.  Many of
> +those are available to DAMON-external kernel components such as perf event
> +callbacks and page fault handler.  For such cases, DAMON provides attributes
> +reporting infrastructure.  Using its API, any kernel components can report
> +their finding to DAMON.
> +
> +The API for doing the report is a function, damon_report_attrs().  The function
> +receives the attribute information and saves it in DAMON's internal buffer.
> +The function is safe to be called in any context including NMI.  The internal
> +buffer has a fixed size and keeps only latest reports of the size.  Because one
> +buffer size doesn't fit all, multiple report buffers of different size and
> +rules can be generated and shared by multiple reporters.  DAMON provides API
> +for such management of report buffers.  damon_report_attrs() can specify into
> +which buffer the report should be saved.  DAMON user interface (ABI) for doing
> +the buffer setup, and enable/disable reports of supported types is also
> +supported.

I allowed callers/users to manage the buffers because I didn't have a
confidence at maanging the buffers in a good way.  But I now think it was not a
good design choice.

First of all, it is offloading decision to users.  I also feel like this design
exposes too much internal implementation details to users.  It would be better
to let DAMON just manage it.  If it turns out to be too suboptimal, we can
later consider optimizing it and even let users control it if really needed.

Letting M:N reports:queue routing makes it quite complicated, too. 

So, unless others object, I will change the design to hide the report buffers
management from users.

> +
> +The data attribute probe supports the reports.  The probes can be configured to
> +hit for a given memory region depending on the existence of specific types of
> +reports that associated with the memory region in given report buffers.
> +
> +For example, per-CPUs write-only monitoring can be configured using this
> +infrastructure like below.
> +
> +The user sets a report buffer and enable CPU instruction sampling report for
> +the buffer.  DAMON will enable perf event counter for CPU cycles sampling.  The
> +sampling callback will save the sampling time CPU instruction and the id of the
> +CPU that was executing it, into the DAMON report buffer, using
> +damon_report_attrs().  DAMON can automatically adjust the perf event sampling
> +frequency to minimize old report drops due to the buffer size limit.
> +
> +The user further sets a DAMON probe.  The probe hits for a given DAMON region
> +if a store instruction for a memory in the region that was executed from a
> +given CPUs group exists in the report buffer.  As a result, the probe hit
> +counts represent relative frequency of writes from a given CPUs group to a
> +given memory region.

My initial plan was to implement the above per-CPU write monitoring with the
milestone 2 patch series.  That's mainly because we don't want to have an API
without its callers.  But implementing perf cycle sampling would be no small
amount of code that require extensive tests.  It may take time and make the
patch series quite big.  I'm now trying to make it small and quick.

I find this report infrastructure could also be used for direct user reports.
That is, users might know which memory they are accessing, and want to ensure
DAMON knows that, by reporting their information using the report infra.  I
will expose an ABI for such direct user report, and connect it with the
reporting infra.  That would look similar to that of DAMOS quota goal
user_input metric.  I will continue implementing perf cpu cycle based report
producer implementation on top of it.  But maybe we could also just call the
user report as milestone 2, as there will be no more blockers for other works
like AMD IBS support.

Unless I get concerns on above plan, I will update this design patch and write
user ABI documents.  I will share those as RFC v0.1, and keep iterating the
documentation-only patches for continued design discussion until I get a
confidence in the interface design.

FYI, damon/next [1] tree may have hacky changes that could significantly be
changed in future.  Please don't rely on those.  Don't spend time on reviewing
those.  I sometimes regret I should named it 'damon/hack'.  Anyway, I will
share things that ready to be reviewed on this mailing list.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

