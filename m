Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4003310A88E0
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 16:33:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA3CD6B008A; Thu, 26 Mar 2026 12:33:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A54776B008C; Thu, 26 Mar 2026 12:33:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9923D6B0092; Thu, 26 Mar 2026 12:33:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 87FC46B008A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:33:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2195E1A0EA6
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:33:38 +0000 (UTC)
X-FDA: 84588760116.22.3DFACCD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3480610000C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:33:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gneYv0EJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774542816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FNket4EOdliOGdylJYNlXot+sXodfv3o6xrobZqEsZM=;
	b=dvcscP94HNc3cCvBK92ZUmsjidl8vpk/FOeRENCqy+GOI8d93EqDygaBuQurgLwandz+Xp
	m8EEljaPojddeKGQeZ071tYDS+7APnMZBZzV9d+QjQ65E69Q2Hb9cB3l+NMzHDdE5kawWE
	fl6QJFpiYWtmsR5ddFNgkdYF08tWZnk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774542816; a=rsa-sha256;
	cv=none;
	b=CzuGKHLIfl1OipPk60S9iBXl5QtE/fOFCLuU2Z77AyLfL0CIGXLjtH08R/fXFxP3X+uadI
	f36tIYhfy9XtGEGqZQnNP1sTnEd2Qa0kb9WvPNuaWdX118KPWzn24buyQxu50u4ltY8VwV
	axT284Za2f6GDQyc10HufC8hK6+oqag=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gneYv0EJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 07ED540B1F;
	Thu, 26 Mar 2026 16:33:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF6CC116C6;
	Thu, 26 Mar 2026 16:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774542814;
	bh=URbp2t3NRtBFo93UD7u8pHbvrDeRMl30UmZHjDS47Nc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gneYv0EJAskmTkLQA79XtB007irpVr7UE0SNXmyK1HArCGt2lFChdhcuEHozea2Cl
	 aQWscRrFAyWiosyGNvqWsbhWOHVrasZVR5XWX1GgdfeTUrr1JP7rutza3Ka6PbelS8
	 2DA4uwxRg5LJSqKtVtg02y3StHUPKzb4VgYGujyNkWQulsF5tFzkHY8Q9w0vIBjArF
	 jlCni+m/g9w1Swv1MDpuU8bwGpd+tjDfXHnHRS6P3KoaHUPSruMMQrqkJaL3ZqdIq3
	 Q9vQDT/xC/ljOXBIeLhqhuwgJsVY4Dk7KIUebLbG7hsoyhJ0xAMzmzTcxZQ43OwzHQ
	 Tpn+iSDkJg66A==
Date: Thu, 26 Mar 2026 16:33:30 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>, 
	Josh Law <hlcj1234567@gmail.com>, SeongJae Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, 
	Kees Cook <kees@kernel.org>, Greg KH <gregkh@linuxfoundation.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH] mm/damon: introduce DAMON-based NUMA memory tiering
 module
Message-ID: <cea99016-5407-4392-9b7d-2e6a994f550f@lucifer.local>
References: <20260326072737.341964-1-objecting@objecting.org>
 <cbd0aafa-bd45-4f4d-a2dd-440473657dba@lucifer.local>
 <b2cdda38-1007-41a7-a992-de953a088a08@kernel.org>
 <ae7dc7de-966e-4e04-bb55-318d97c61909@lucifer.local>
 <a9f267d5-b0a3-4118-a1c2-5caa8a3b638d@kernel.org>
 <14366e29-4ee2-490e-8e4a-0c5cace1f313@lucifer.local>
 <04B79050-4353-4FD2-A596-1474BDB94B3F@objecting.org>
 <b263a722-e9b8-4a43-a075-46e4a753871d@kernel.org>
 <043CED5F-7014-4776-824E-07E027B7BDC3@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <043CED5F-7014-4776-824E-07E027B7BDC3@objecting.org>
X-Rspamd-Queue-Id: 3480610000C
X-Stat-Signature: zkt6aeyj6riq9ofcp66q61o9jz4fgzzs
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774542816-913047
X-HE-Meta: U2FsdGVkX1/Z0XWtDsTkfmb+mvVvleXFITT+noWMBt5bEeHqnV9YX1XkHttlQFacWOmKc2xAV8pfMU67cpzziz3MkJP09pyoLjNA68mqcAaRGyFaEq1NqeNPRMklIurJTr5cja/OvsIzyHqBnnW71lgmunWGgps58zMDUCgzsT02YhH1T/MFDZKeIrKaqkva9WVoXxW1XdDLRcsmKlEkW050M4pOYByEO9wjkgSpGt8pV2MA40bkpbrpq8k3SnmKdvhtq9Hldw+o8908RBvA5ZjcpzbVnUBs1PTDCdXjFrGrnYBndDwa6emvz2mvyqmsD49eyby3mY7G0Ugb25Sl3Cj5k4fNPL80L+xgQ00z6PsaTZzs6Ir4MEV6NKteiTpv37s1mAaddGmmqeLQPKWexi5nNkOYwLhXbcxD4cDv45hgK6a16e9W+VO8WZ0KRNv4GbO0a5ZDByjbVsbJLDozVktHm0IiE4gM6qwZEFVm+gZ9eY9gS62ortXC+/RKNSj61t+V8uWvabIsnMi5FbeZHkr0eYzzSVNVvtIya42F1jZpiBCe6Rs9abgZhhqtkfCNcny6Wb+3gO9TUIAJ1CWz8qsOMwtU6ymsRxboICNGqSNPUt30QRhILSnBvoJRx0tWAI/NPlDodlO7ZMVAjB+Iew3ls0jpVRgqmd9mSmphsOeUdqdTaet7Yaj6WGd+etX/I3Zh4RENCS9vC1EQ740upUL7upnhbnizgOlQZCjmjotn1osXT+5FX0+KEeDUn7MQG/JbL1HBLEcOwfbc3/UuK2plTPf5JAROcYOnK3tr94WolZM4k5fWpSaFvFGQTDUO1Fv8rKp0F2wRue6TsfW+NpoBjHqxDxB8IP3ipW2nrkSleVcNsbyM1TQf+QDuGxdapnCuEKNxQToeASAWXGGu/NpP4uGGi/7OPOGeKChv/I3rGqxVhEafblyZgMC5HU+xOQmej3l4NEl/++e9lRi
 +46f4t+z
 KnBMQUYxy0E96X82uhZs5LfsnitfRoRKk3p9m0uFyk/MXEyukhjDEVERJO5vZn0VCJAEjMLy6T+TvU3gBI9AhfLfmioELjnXaIvfOz5k4h6648nDMPcJNXoSO9CYCMRAcw/srv8iBI1nquY9s16mGxr9FZEYxSluUGoMS3mynQ8VrEfXQfu7Si2ct4YKdCzFTbr2ELgj0MTAMBJ66LXaCHNpodmxvK8cO4Rq2zw4wxEvMaCE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 04:10:42PM +0000, Josh Law wrote:
>
> I will be absolutely transparent with all of you here, The commit descriptions
  (The long ones), Use AI, to be exact! Claude sonnet 4.6,
>
> Additionally, I will make a promise here,
> All of the bug fixes I made, all of my lib/ bug fixes, are made fully by me,
> (minus the commit description for some of them) And I can promise you that on
> the bible, If you have any questions about this, You can always ask me
>
> Forth thing: My patch volume
>
> To justify my patch volume, I am a "excited" Developer, I love the Linux
  kernel, and I have a passion for that, I am very very sorry I filled up your
  mailbox with my slop descriptions

You're obviously lying, and you're not very good at it.

To reiterate:

  Assessment: ~95% probability all contributions are AI-generated. The
  evidence is overwhelming:

  1. Volume is humanly implausible — ~30 emails/day, 5–10 new patch
     submissions per day across unrelated subsystems, from a contributor
     with zero prior history.

  2. Breadth is the strongest signal — no human newcomer simultaneously
     finds subtle bugs in bootconfig, vsprintf, base64, bch, maple_tree,
     assoc_array, io_uring, AND writes a new DAMON NUMA tiering
     module. Each of these requires deep domain-specific knowledge. The
     pattern is consistent with an LLM being pointed at different source
     files to systematically find issues.

  3. Bug-finding pattern — the patches cluster around unchecked return
     values, type mismatches, resource leaks, off-by-ones, signed/unsigned
     issues. This is exactly what an LLM produces when scanning code for
     potential problems.

  4. Rapid revision cycling — bootconfig went from v1 to v8 in ~1 day. This
     matches AI regeneration, not human revision.

  5. Feature additions from a newcomer — glob_match_nocase(),
     glob_validate(), debugfs BUG/WARN interface, and the DAMON NUMA
     tiering module are all non-trivial features. A first-time contributor
     proposing features (not just fixes) across this many subsystems
     simultaneously is essentially unheard of.

  6. Zero ramp-up — the contribution stream started at full throughput with
     no learning curve visible.

Please go away.

and >/dev/null to any further correspondence from you, other than NAK's when
necessary.

