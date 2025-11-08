Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DA70CCFA13
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 18:37:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F13F8E000A; Sat,  8 Nov 2025 13:37:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A13D8E0003; Sat,  8 Nov 2025 13:37:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2916E8E000A; Sat,  8 Nov 2025 13:37:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 122268E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 13:37:01 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9157B4C0E8
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 18:37:00 +0000 (UTC)
X-FDA: 84088296600.23.31F641A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 229C814000B
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 18:36:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="u/TU0L1S";
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762627019; a=rsa-sha256;
	cv=none;
	b=ZsVe/VGajAWz7H2lmiW0cLKbOUg6KssYJ4FqkzYIMOuhftb7bzi37SHeEfsXLWapN014UT
	RJEjX6Q+edmLDqL7pf8roEVnAED/YKYfrwA7sPHtvqXHS1y9ASh7KxxT5RA5AFVOFb3DoG
	ar0CtbD8MegMAR1QzRNp0575v8wtyBY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="u/TU0L1S";
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762627019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sZa17wdt0V2rTG6pp4DbzKC2CLTc7UItr0vMnvAz+Oc=;
	b=BtyWg0dhDZc6uW+U6/rswOhk0g2GKvuqq02prLXptpC8qEymUtZgTXO7enEdOTvBxWt19I
	rgX3lhAIAXgAibYcDGSE5jglE2Km9IvBZKg69Z6MIbWa7TQxAQPcIGpqJjjE5Vg+BnvOHz
	APfjFBrFrlGXtcuMhW2EUqFdAMxPadc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4AE3360007;
	Sat,  8 Nov 2025 18:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1045C4CEFB;
	Sat,  8 Nov 2025 18:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762627017;
	bh=oc4FD2p7G8kSBSZo9gfGH4up/tQYQo2yArK0ExY2vhY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=u/TU0L1SolBld/Qum5lsMKpZbK303fBFh+JGMRdIeDfMOvxbOvd+sj7Fet4RquTqo
	 cr0T/Q6PmBtaHDm/a/2DhALFhxViIEeD3BFEO87SZoNwY5zk2o5w/WMRME4x92bMaD
	 UalR+stCBKRCmBJBbBCrq0f0nnaqV6uMag1h8qeI=
Date: Sat, 8 Nov 2025 10:36:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
 rppt@kernel.org, dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
 rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
 kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
 masahiroy@kernel.org, tj@kernel.org, yoann.congal@smile.fr,
 mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com,
 axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com,
 vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com,
 david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org,
 anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
 linux@weissschuh.net, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org,
 cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com,
 Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
 aleksander.lobakin@intel.com, ira.weiny@intel.com,
 andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
 bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
 stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
 brauner@kernel.org, linux-api@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, ajayachandra@nvidia.com,
 jgg@nvidia.com, parav@nvidia.com, leonro@nvidia.com, witu@nvidia.com,
 hughd@google.com, skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v5 00/22] Live Update Orchestrator
Message-Id: <20251108103655.1c89f05222ba06e24ddc3cc3@linux-foundation.org>
In-Reply-To: <CA+CK2bCakoNEHk-fgjpnHpo5jtBoXvnzdeJHQOOBBFM8yo-4zQ@mail.gmail.com>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
	<20251107143310.8b03e72c8f9998ff4c02a0d0@linux-foundation.org>
	<CA+CK2bCakoNEHk-fgjpnHpo5jtBoXvnzdeJHQOOBBFM8yo-4zQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 229C814000B
X-Stat-Signature: taswko4qhtrjktk979ssb8ecxpczi1r4
X-HE-Tag: 1762627018-121950
X-HE-Meta: U2FsdGVkX1+oZDSETPgblQRaCZ2T1TPf2Qd4P+14hMlrhTrhUFhFokbum6AnyjilEgNmoKiybJny1aKKxcMphGZXKyNKzRv1zYwCP76UBiX98QJ1FdoZU+5rA+PJNQnk8wFW8rZmSXXWmGzgCmZ385OKq5pwPfozUrLqTMp+MOnqTuC16hZbglxhqEtAWas0pkVdHv+JnCHOV6IjHrrt/LACT7n6g4oWaYHhq7uCKKDlRBT98fH7DsoR3AhasHW3+XkHKfZijyW8oqPkyJ+SpUm9lEXJje8o0aDsg/Y+UtD70RZ4uwDU2c2Y6Wne1WyYIIign06vcdOVje9WcAIk9Q3xS7JAIgiNV3iz+wL23ANbB5FaTXpyiATafOgoF8oum3Hw9MGLe6D+ppyMRlXcp5Lv0pCPAR5tD56gf7Zt9SRAULCDJuoZQgHdj2huNWbJOl3mmGm5uvHCRVpbh1fYHQAvp7UnZvaO3CiL8ujG/Fi540g6ht1V293fgEtDP+znKnk9ra0qF/Eh82VY0lJ3l0/uB0H1nOpg/M1KUZn9r+qLbqrhlox6Ag3zicsdDFicmrZZ1oRynKV0Ol/DX3mjQzOKP1l1PGLiWRjrw6PC2MxCk52orfuqhsijsv6nYn96G9jEjL8g3ZpNy7/7N7XPPk2F1CCtNoi0R/Cwy03OcLrwc/N66eINPNN4HUHKAIwrCGBEevFcJmaeVud53HQGpJHuabBXM8RS2ZzJuyqIsGJCWX1062838uDaFq0OLqbXUt9Wsu6GzokZDxISy9tHjI7IVEtrF/yEyO2POjMlSMOCDSrkSzT4THAGUpv0bKimr0TbGNTgYuYt1bc77soCQRq1idUcYJLJM98jGkFNvXerL5LV/CTt+njpUJHKY86/IuOCp7U3iWEXgEGgVz9sRguS4rOanP+MH5eugXFoBWwEZxDdbPP2kjkV8vW/YBbu91Y/rRVK7CwbflNLlB7
 LNGZhW54
 vxvQ4Pv3A/kD//01mEdJG15w7lA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 8 Nov 2025 13:13:32 -0500 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:

> On Fri, Nov 7, 2025 at 5:33 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Fri,  7 Nov 2025 16:02:58 -0500 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> >
> > > This series introduces the Live Update Orchestrator, a kernel subsystem
> > > designed to facilitate live kernel updates using a kexec-based reboot.
> >
> > I added this to mm.git's mm-nonmm-stable branch for some linux-next
> > exposure.  The usual Cc's were suppressed because there would have been
> > so many of them.
> 
> Thank you!
> 

No prob.

It's unfortunate that one has to take unexpected steps (disable
CONFIG_DEFERRED_STRUCT_PAGE_INIT) just to compile test this.

It's a general thing.  I'm increasingly unhappy about how poor
allmodconfig coverage is, so I'm starting to maintain a custom .config
to give improved coverage.

