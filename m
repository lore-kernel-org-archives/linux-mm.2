Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36178CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 14:49:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C2418016B; Tue, 28 Oct 2025 10:49:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 899868013F; Tue, 28 Oct 2025 10:49:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D5A18016B; Tue, 28 Oct 2025 10:49:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6BC7F8013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:49:20 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EB9EDC04CB
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:49:19 +0000 (UTC)
X-FDA: 84047806038.05.4D74F1B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2029D40002
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:49:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=huHQXCvp;
	spf=pass (imf01.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761662958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iMhlL+awlNfW9A5jmBo0UeSJ8e6xIZTWAHrMjd5ojNE=;
	b=idKlVrWM/3cqiTNdQPpqszmpPaY+1VeMrENoxb/ANyZrHNU9fa1RzYwY7DB6ykvFdhhX8w
	YMl7nBXDRXNkNcYfCdPecnOVcVzg93TZQuCWz74NC63ZAuEp5BMZk4lkfdIp7rmIwP7ZMA
	NuEKBzj4qrN3seXThVy5CdcVqkzBIcs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=huHQXCvp;
	spf=pass (imf01.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761662958; a=rsa-sha256;
	cv=none;
	b=hLGVVg+ct2bc5QGvqBi3S+s7j3pP9xUlI1Yfp4V4sp3CkKike6H12Q35o0VKp2pBznrd/a
	HZmyPLAW9S1Ls4bfCGEoxUlVZfbPqHE0RxwgjKEhMtU0XtJzpaakZMtTMUOg61m+pk5+vM
	UcMY1qdhpnmpnwX/8LBpjqEGyKgoz0k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0969A45F05;
	Tue, 28 Oct 2025 14:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64951C4CEE7;
	Tue, 28 Oct 2025 14:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761662956;
	bh=/YcbY6Xd39AsABVLZZYIvhdW8ivhFU4lURFGb2RCZr8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=huHQXCvp0W/S5F1ENdurMkw2WwJZbMBNDXAh91iSKf/vrNDl1NLBkoXJdUx/C19Qv
	 Z4qNcGgTCDjqG04Q8z3Gw4n7Ol2Hs4TiC0IGtfV35bwyLcbAG4VH3lZOOkEdiJR4uv
	 98GKb95kopcHzMuvU3H2025SulpKC226+6+rZMUmhwVvLSkelVU5+Fv/hfF6vOYswZ
	 XcZScHHzyBVq+mz32oPgQ0NUDZQKpY6cLjssBtvUS7RZby1k7TivV6VhaUkRZyqa69
	 4+Ez+WRvhuVyLYG73RXpS/ughenkh3oUdmNmmth4K/glGp+Eu28p8jOe+6mgl5gPer
	 pCdjOFhzrTR8g==
Date: Tue, 28 Oct 2025 15:49:14 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Valentin Schneider <vschneid@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rcu@vger.kernel.org,
	x86@kernel.org, linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
	linux-arch@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Nicolas Saenz Julienne <nsaenzju@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Jason Baron <jbaron@akamai.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Han Shen <shenhan@google.com>, Rik van Riel <riel@surriel.com>,
	Jann Horn <jannh@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Oleg Nesterov <oleg@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Clark Williams <williams@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>, Petr Tesarik <ptesarik@suse.com>
Subject: Re: [PATCH v6 24/29] context_tracking,x86: Defer kernel text
 patching IPIs
Message-ID: <aQDX6hHV3b1-_wuF@localhost.localdomain>
References: <20251010153839.151763-1-vschneid@redhat.com>
 <20251010153839.151763-25-vschneid@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251010153839.151763-25-vschneid@redhat.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2029D40002
X-Stat-Signature: qxttbujxu6ut56uwmsx1jbhhhugfnkgq
X-Rspam-User: 
X-HE-Tag: 1761662957-222751
X-HE-Meta: U2FsdGVkX18tLWQjnWrMroQB5lMAS6MWfQsn/yZsBKipAZgXHu9OdmyHABa1jLAtLgxJOWxkr9Shvo2EX6I5IEgc1zhEfWV4LfRLoel0IurzGgXjATKuqVBuk5HJpptlbdNdMA4OME5ffhEHiYA6eMaqy8FWfmUxsOuQ4BgwKyyr/cnJocNGfH92hEYHbuWVDyV3/XH8mPb8k+q5Z5Pp3ZMkfBQnlH9BXS9vHD4jQchqYQO+oI9csV8YaUS/bQKHaglwQ+r+VpQ+g9J2g2+o1pA4e6bMgRlyBgGJyT5aAEIj3NtqHYfo3Zhz4y7sqf4hcfQcUYXg6xOI2o0rprqU4dkC5nY23dTdEKT14ukhv4AMMtZIwQm1eAr/D6Wnj+2ra9QVyYu7GSNW5Uc7JBrQhIchAoX5tlKaZ/iPOrX1SjkzJdx2cnfNvCaF+9gF02N8yUxfGnYmo8mqhVg6BI1syd8sK1i23WEtWMp+l1lTul76zUdyQ35Q2VCLpmYwgzfwsfI0LcWqyopUR/0C3fw0xdO3TDcPixHIoo32C4+OOIJk0hTV0MmSOWLB349smd7JfpDnjDHbt4Rhjympd2hdBGfSBqRzORqUUzFtbbkF82PFQG1Lk0dUiiXw82HeQVbFiTqSaSCs4cAiaAf1QypFj4twhvrN1EFcxhaIjFRB17a1XSFr+iYWHFJgMljjBkaMrTF41TOHiojQDZh8hm/18fFCAwLs1Y8FLc9WPKJS4FyNz0QF6Myq6l8Ay2ktK8F9iFxB9nuW6p/E9pVEyqQhZ2oAr7RmxlFtDJAX9VHMHYh2D1Iq69T2BSBq0Dm3awmhYjHFWUufkdiP2dVUHenVP/Pn5fH/lz2BrudElPr4GJqtQ1prqZjoBOAhFfxIjklcEDsl3G7kxZNPB30ucQeugOGrSP3Rx20Mhi7Msix5qjrE7HiYgFCAV5phxdz0ozk7Puf980OtPmqCjlp1iqx
 UlgbWQCu
 N6C9lV/Yty3h8NIOXDo0m8I7fSAoCikFxnDbkneATIY8V8VZ9UlS1XllJCN708VrUjUAK5NIBpaTrbvDebUVzJOZlnhyl4ZhYGnwNYoNzlDRdrwLnO4M4G/TaOcbSxpuFxx2PAHrkDl9/IuGzNF49JqgjjddWSGgQq2aRc0xpOwDB6ngQfS/uuG3Za0o87GF6+VFOIaYe2YwgcmRVRFgWraxqxBYCjNQ+Ip8xnMpgpaQdOCCKqXoIt2P5/Qdo0PRihaaHl4PWMD9vWP4iCOKFJhD0iir8cRv6eIh8QSv/RU5ttuCI9v9B5mBalx3apL98umXXFxBfwPhI9/j7EayjH2L12/AspEVvPAtAeRGoo+2gChtScHnRt3jt1x6WgAb4c8UfsdrNciSCCDa1777rMyzFldUGQIYMLMpaRUiyeY83do4IVq0Tnp/GDWMlJFiEMvXTKsPqxmYMd9QI6jJP4qfFgA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Fri, Oct 10, 2025 at 05:38:34PM +0200, Valentin Schneider a écrit :
> text_poke_bp_batch() sends IPIs to all online CPUs to synchronize
> them vs the newly patched instruction. CPUs that are executing in userspace
> do not need this synchronization to happen immediately, and this is
> actually harmful interference for NOHZ_FULL CPUs.
> 
> As the synchronization IPIs are sent using a blocking call, returning from
> text_poke_bp_batch() implies all CPUs will observe the patched
> instruction(s), and this should be preserved even if the IPI is deferred.
> In other words, to safely defer this synchronization, any kernel
> instruction leading to the execution of the deferred instruction
> sync (ct_work_flush()) must *not* be mutable (patchable) at runtime.
> 
> This means we must pay attention to mutable instructions in the early entry
> code:
> - alternatives
> - static keys
> - static calls
> - all sorts of probes (kprobes/ftrace/bpf/???)
> 
> The early entry code leading to ct_work_flush() is noinstr, which gets rid
> of the probes.
> 
> Alternatives are safe, because it's boot-time patching (before SMP is
> even brought up) which is before any IPI deferral can happen.
> 
> This leaves us with static keys and static calls.
> 
> Any static key used in early entry code should be only forever-enabled at
> boot time, IOW __ro_after_init (pretty much like alternatives). Exceptions
> are explicitly marked as allowed in .noinstr and will always generate an
> IPI when flipped.
> 
> The same applies to static calls - they should be only updated at boot
> time, or manually marked as an exception.
> 
> Objtool is now able to point at static keys/calls that don't respect this,
> and all static keys/calls used in early entry code have now been verified
> as behaving appropriately.
> 
> Leverage the new context_tracking infrastructure to defer sync_core() IPIs
> to a target CPU's next kernel entry.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Nicolas Saenz Julienne <nsaenzju@redhat.com>
> Signed-off-by: Valentin Schneider <vschneid@redhat.com>

Acked-by: Frederic Weisbecker <frederic@kernel.org>

-- 
Frederic Weisbecker
SUSE Labs

