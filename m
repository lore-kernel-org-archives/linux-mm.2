Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 139EFCF45C1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 18:30:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 737FA6B0005; Mon, 12 Jan 2026 13:30:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E5A06B0088; Mon, 12 Jan 2026 13:30:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E7E86B0089; Mon, 12 Jan 2026 13:30:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F3AD6B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:30:04 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 050C6D1B30
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 18:30:04 +0000 (UTC)
X-FDA: 84324151128.18.28B3102
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 11D6FC000F
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 18:30:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zzVnZrOK;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768242602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L4cDU1NowQNzgKUbPEkmBg8eSmoVUqiQeSeSb+NHqgs=;
	b=llns28moW+GMfhElsDbWF2FtTLlZZvYGxAqhRC7T/bDLyrqdRtbhi2+VfPe+hF7WWmRlas
	vRBogmz5jIdiFxkKutsAVVRddb/QOMJSr3mqRvBCdBDsCO6ywgZGLT2/Wpt1H8cRwEqiNa
	lnmp+zHnaFKQ8NUnkbydPGBGk/UAoBI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768242602; a=rsa-sha256;
	cv=none;
	b=hRxuD0574us4v3rOzUFXjI0bqVDET2yr5qjjvUB5/aJEkAubg1Pw3UCnNu+eMsaGkhMuj0
	CXdfvS5KLHZFZfXrM6sr0H1++cBHE7elOleyX2v5BpjTDa46YmqdcLr/FnscOfq0HAtJ5L
	cWl7jRC7Yl0RQ2umfi1eYcTRXQaVRj8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zzVnZrOK;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B931743463;
	Mon, 12 Jan 2026 18:30:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1E7C116D0;
	Mon, 12 Jan 2026 18:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768242600;
	bh=pb/tVCd1nrZorzc3OQJ5GZ/GnwX25D91HAoQwYjWh9A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=zzVnZrOKkI5LQ7+XAL7zuJbCgfgnfqQ6c//ayo6FMiYjPMM5GN0thTTLoC0v3HytI
	 0hd6ThWdQnfX/79qVJ7TSOIicNp0Obgssj6CPfZw/oqr+6R06NeTUnIJO72B3djMq8
	 W03ZnqF6oZOrCYz2QoGo82heKOjO3ypVyeIonYME=
Date: Mon, 12 Jan 2026 10:29:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: corbet@lwn.net, morbo@google.com, rppt@kernel.org,
 lorenzo.stoakes@oracle.com, ubizjak@gmail.com, mingo@redhat.com,
 vincenzo.frascino@arm.com, maciej.wieczor-retman@intel.com, maz@kernel.org,
 catalin.marinas@arm.com, yeoreum.yun@arm.com, will@kernel.org,
 jackmanb@google.com, samuel.holland@sifive.com, glider@google.com,
 osandov@fb.com, nsc@kernel.org, luto@kernel.org, jpoimboe@kernel.org,
 Liam.Howlett@oracle.com, kees@kernel.org, jan.kiszka@siemens.com,
 thomas.lendacky@amd.com, jeremy.linton@arm.com, dvyukov@google.com,
 axelrasmussen@google.com, leitao@debian.org, ryabinin.a.a@gmail.com,
 bigeasy@linutronix.de, peterz@infradead.org, mark.rutland@arm.com,
 urezki@gmail.com, brgerst@gmail.com, hpa@zytor.com, mhocko@suse.com,
 andreyknvl@gmail.com, weixugc@google.com, kbingham@kernel.org,
 vbabka@suse.cz, nathan@kernel.org, trintaeoitogc@gmail.com,
 samitolvanen@google.com, tglx@kernel.org, thuth@redhat.com,
 surenb@google.com, anshuman.khandual@arm.com, smostafa@google.com,
 yuanchu@google.com, ada.coupriediaz@arm.com, dave.hansen@linux.intel.com,
 kas@kernel.org, nick.desaulniers+lkml@gmail.com, david@kernel.org,
 bp@alien8.de, ardb@kernel.org, justinstitt@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kasan-dev@googlegroups.com, llvm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-kbuild@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v8 00/14] kasan: x86: arm64: KASAN tag-based mode for
 x86
Message-Id: <20260112102957.359c8de904b11dc23cffd575@linux-foundation.org>
In-Reply-To: <cover.1768233085.git.m.wieczorretman@pm.me>
References: <cover.1768233085.git.m.wieczorretman@pm.me>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 11D6FC000F
X-Rspam-User: 
X-Stat-Signature: ypudgrapbonx5fayz1yje6bo7u8kf9jb
X-HE-Tag: 1768242601-75913
X-HE-Meta: U2FsdGVkX18ovVKT6R6rvmRz2IUs8wvVTkCB7+CMLOyNDGoqh8oXPPKvu3zuB6a7tfucXmVSQwDZClhAsFFDz2Leczz7ANZwCBlJPKp0TEoiTzy0pOhTL7BnUtcGFUYKQZVUS9flp8+yqwobZKYiHKOYHtoXGZdnF4BlRf/UsLphYoYS5M3dt1F4eaDndU1+Dk0TXr/DvKCi/SlOag2ddUBfFjMQH3PwEPIYut7xqCyZ2Yw+UbKQv0/PiP743oBq2IubpfkIJjDljpdVTJ4zC52yy88Vtp+By01BfxsputLgYGCCZ3fwevgyyBNueX5Ajh7VHpSH75aW+bDBIi2h1a6ykShJ/uZeeAQy7CWQku+VrV0UfKeXqUPiRY6LOhnxS7FluJBKcO0AUx4kSStApTLbjkSlN/mM1L0XMjawxCgO3d6GgjNkUfK9izTOoIcHyVLVneEdj/j9BJL8VpeG9QKdcEhUu1cZygJw1yNlDnsbnZzyzkDiWdFe5vpvrUu2L/593QGxLI/L/I0sgDJLVedQ6gzNzYpOaOdLkKfVd0V6Aezl8oKyojW1XAp0725sWk+URBx9JU1AEbxQGsNSiMFJyRgddRfxvCSgCIyIpSi/czbWb8cxz68ikQ9z3ug3T6eQkSf1fshE/WlY8iaGHZLCvrPHqRxgKmH7n28FN5P8OZ+34N03I1hMUUhJAsVXu4Jx9zf1e7Xxby+xWjJDXH9wnZgFWGYi3yOAcZDfBXW722uicg03WmsHVonzzRIEpw2I7OLOg6/YPTT4gmAEg5QpcSeDaVMOFP7jVPvjNnymbybvH6HUqXRPVIlJF/3n6jgPF409eNZChpzVUR9W59YpP8WKY6iliWTg05gWVO2qiUil++gmAKOM0SeHtA9U2pSwXmfz6Qk6jnQRZzvzOqcRcjjmDhtUmiftLCUbzq51oG7BdYTpQokcJdKZtAVmH80tUlq32prcubxjzSR
 JYq9EekT
 /ajpTr4+jBSGJnCygKeO1MN/TIhGoRHLxn1WBt3f2b5ULlxFC0yeUVspDOGFZEXGeZVlEnD6GAjKUImQ91OQ9IN9O60Val8pBEHWYda/plp4MSQKJNGjXSxTSVUtCcrVcge2GJiRa741+a8NrX9dIGfzliu9esqmoYkVnO4I7vmwiWh2vuik678E9Ww0MGh9DH+3fL2nQHoqYHByUkn7jvcB1QzT9WqDvBPN6PKfqHHj34OXLxKElX0t0UgasxrLl5PjbwB9UBEiN2iZnhS8PwXVSweIlkTZZqdzLQQM7QDGk8EmfRlpruZdEC+Y7J63jh1jDdJmiNf5uEEk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 12 Jan 2026 17:26:29 +0000 Maciej Wieczor-Retman <m.wieczorretman@pm.me> wrote:

> The patchset aims to add a KASAN tag-based mode for the x86 architecture
> with the help of the new CPU feature called Linear Address Masking
> (LAM). Main improvement introduced by the series is 2x lower memory
> usage compared to KASAN's generic mode, the only currently available
> mode on x86. The tag based mode may also find errors that the generic
> mode couldn't because of differences in how these modes operate.

Well this is a hearty mixture of arm, x86 and MM.  I guess that means
mm.git.

The review process seems to be proceeding OK so I'll add this to
mm.git's mm-new branch, which is not included in linux-next.  I'll aim
to hold it there for a week while people check the patches over and
send out their acks (please).  Then I hope I can move it into mm.git's
mm-unstable branch where it will receive linux-next exposure.

> [1] Currently inline mode doesn't work on x86 due to things missing in
> the compiler. I have written a patch for clang that seems to fix the
> inline mode and I was able to boot and check that all patches regarding
> the inline mode work as expected. My hope is to post the patch to LLVM
> once this series is completed, and then make inline mode available in
> the kernel config.
> 
> [2] While I was able to boot the inline tag-based kernel with my
> compiler changes in a simulated environment, due to toolchain
> difficulties I couldn't get it to boot on the machine I had access to.
> Also boot time results from the simulation seem too good to be true, and
> they're much too worse for the generic case to be believable. Therefore
> I'm posting only results from the physical server platform.
> 
> ======= Compilation
> Clang was used to compile the series (make LLVM=1) since gcc doesn't
> seem to have support for KASAN tag-based compiler instrumentation on
> x86.

OK, known issues and they are understandable.  With this patchset is
there any way in which our testers can encounter these things?  If so
can we make changes to protect them from hitting known issues?

