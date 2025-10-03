Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99017CCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 14:37:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6BAF8E0014; Fri,  3 Oct 2025 10:37:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D43468E0006; Fri,  3 Oct 2025 10:37:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C59658E0014; Fri,  3 Oct 2025 10:37:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2EA98E0006
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 10:37:15 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 732E1451F5
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 14:37:15 +0000 (UTC)
X-FDA: 83957055630.05.6BD5E77
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 54D3916000D
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 14:37:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of mark.rutland@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=mark.rutland@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759502233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0LtpncgCfs+SwUIbz4HS3dmqnzX2hJfu98hTgs+EJKo=;
	b=TKSuHw5L++HU4iDJXNLBb74ACxqrl/nfRzusFld3AGTiL5OEj/aqvkwS1c3ZHdmiCTLZL4
	0rNQNhY6SeTrEMq9+Cf8V039Vo85Za3VyCQ4FM8P9ulqQKz/D/DAE4TVhY+mTdBNTyHhKm
	QdHfoEqGSW6UrAXST3P4rR7ZXoXRi54=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759502233; a=rsa-sha256;
	cv=none;
	b=XT1/JdJi8S+z++z7KiVMo6dC+BlTxUI8WPi7ds0QRiYVmHSHKfVnCf3xyBAgZUqzf5bcZc
	loc5YtY1P3427gntQvgtvUcapyy56pW3zRBwYRpMltvrp7nuz83fw1KvLV4eymaHsodRBh
	+P+mHoChKp2bW6zEjeaOP61VkwM7mKE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of mark.rutland@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=mark.rutland@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 08EAB1688;
	Fri,  3 Oct 2025 07:37:04 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8693C3F5A1;
	Fri,  3 Oct 2025 07:36:47 -0700 (PDT)
Date: Fri, 3 Oct 2025 15:36:42 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Byungchul Park <byungchul@sk.com>
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	torvalds@linux-foundation.org, damien.lemoal@opensource.wdc.com,
	linux-ide@vger.kernel.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
	will@kernel.org, tglx@linutronix.de, rostedt@goodmis.org,
	joel@joelfernandes.org, sashal@kernel.org, daniel.vetter@ffwll.ch,
	duyuyang@gmail.com, johannes.berg@intel.com, tj@kernel.org,
	tytso@mit.edu, willy@infradead.org, david@fromorbit.com,
	amir73il@gmail.com, gregkh@linuxfoundation.org, kernel-team@lge.com,
	linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@kernel.org,
	minchan@kernel.org, hannes@cmpxchg.org, vdavydov.dev@gmail.com,
	sj@kernel.org, jglisse@redhat.com, dennis@kernel.org, cl@linux.com,
	penberg@kernel.org, rientjes@google.com, vbabka@suse.cz,
	ngupta@vflare.org, linux-block@vger.kernel.org,
	josef@toxicpanda.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
	jlayton@kernel.org, dan.j.williams@intel.com, hch@infradead.org,
	djwong@kernel.org, dri-devel@lists.freedesktop.org,
	rodrigosiqueiramelo@gmail.com, melissa.srw@gmail.com,
	hamohammed.sa@gmail.com, harry.yoo@oracle.com,
	chris.p.wilson@intel.com, gwan-gyeong.mun@intel.com,
	max.byungchul.park@gmail.com, boqun.feng@gmail.com,
	longman@redhat.com, yunseong.kim@ericsson.com, ysk@kzalloc.com,
	yeoreum.yun@arm.com, netdev@vger.kernel.org,
	matthew.brost@intel.com, her0gyugyu@gmail.com, corbet@lwn.net,
	catalin.marinas@arm.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, luto@kernel.org,
	sumit.semwal@linaro.org, gustavo@padovan.org,
	christian.koenig@amd.com, andi.shyti@kernel.org, arnd@arndb.de,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, surenb@google.com, mcgrof@kernel.org,
	petr.pavlu@suse.com, da.gomez@kernel.org, samitolvanen@google.com,
	paulmck@kernel.org, frederic@kernel.org, neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com, josh@joshtriplett.org, urezki@gmail.com,
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
	qiang.zhang@linux.dev, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
	chuck.lever@oracle.com, neil@brown.name, okorniev@redhat.com,
	Dai.Ngo@oracle.com, tom@talpey.com, trondmy@kernel.org,
	anna@kernel.org, kees@kernel.org, bigeasy@linutronix.de,
	clrkwllms@kernel.org, ada.coupriediaz@arm.com,
	kristina.martsenko@arm.com, wangkefeng.wang@huawei.com,
	broonie@kernel.org, kevin.brodsky@arm.com, dwmw@amazon.co.uk,
	shakeel.butt@linux.dev, ast@kernel.org, ziy@nvidia.com,
	yuzhao@google.com, baolin.wang@linux.alibaba.com,
	usamaarif642@gmail.com, joel.granados@kernel.org,
	richard.weiyang@gmail.com, geert+renesas@glider.be,
	tim.c.chen@linux.intel.com, linux@treblig.org,
	alexander.shishkin@linux.intel.com, lillian@star-ark.net,
	chenhuacai@kernel.org, francesco@valla.it,
	guoweikang.kernel@gmail.com, link@vivo.com, jpoimboe@kernel.org,
	masahiroy@kernel.org, brauner@kernel.org,
	thomas.weissschuh@linutronix.de, oleg@redhat.com, mjguzik@gmail.com,
	andrii@kernel.org, wangfushuai@baidu.com, linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-i2c@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-modules@vger.kernel.org,
	rcu@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v17 09/47] arm64, dept: add support
 CONFIG_ARCH_HAS_DEPT_SUPPORT to arm64
Message-ID: <aN_fel4Rpqz6TPsD@J2N7QTR9R3>
References: <20251002081247.51255-1-byungchul@sk.com>
 <20251002081247.51255-10-byungchul@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251002081247.51255-10-byungchul@sk.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 54D3916000D
X-Stat-Signature: eagycsyw9jqsnp3rgra1ij18f4mxd6ij
X-Rspam-User: 
X-HE-Tag: 1759502233-451582
X-HE-Meta: U2FsdGVkX19MXvc2BlAxnScUp1rx31rxom7ekaRUthFBRg7i/YmNSixLwndJevA3ijZyYHXHXv19kMfv994p0ns+gt2tjf4nQ97ogc98A1CZcVjzWDbUXuLyzuQ1f3A8gCCJgcTCMLCLdxWoE1YNc76SjyB3V5xs8FPg9h6SGGnphxtC6Y/VL1nmQEOnGFfgXC58UmGumop/Li3OB7PHnsot/R5QOFRSZCW4UAZ4InkWM6+FcGEOp955AYTOx1UnKVOnf4GYlVQ2xPTfBgNVIJGmYakEjYmgSHagWQdQ7cqhKMzSnDMKRDKCBQsPT4YOjqv8c1n3TeEfH0pMZEaTac11g3jo4CDq8AM+nvRcSov+fcsNqui5JYEdPm/RwjvAgD60mfeXp3HextExvD2dlI++HwxHIRhQARdzXIdYCg7q/BBblIeJQxTYl1ngBYzCQkIAD81qHV6PHgB3A4FojcDbTJnkSmu02YfaqOkNN27DbU4fDsK3Oi5/TpK4gxitJGb+IAt1985fH1tK+8I+KZ2air6BlUwkHyrp6ca2a5EEVHn32f2MqMYvizxalLXv/6YkRsuJWcYOyFEu5ZDQUjW78QDyUMqKOrDbnJhG4XkDzkxFepv4Mp4lVu/XQ6rI8gxPC0o6N0lPJEkqs++nlOdIc5yoh8OQtqiOSogacN+8FMRGmwB2XEvFYtZq1zcd+Q/Eu4Ac6n2Wod6L9f5KaKYL4lz12qa4di+EM2D8w0VCMtnsFP1cbIoKIdn/g6rbgswzjxiqZkwRnDHtqSMqFjV60ptW/BKPvjS0T9N2739hUBolNdK+Hl82IMuXJ0zHORJADtwPMRtGqZYUFE4ylQopN5sOozCFOz/fQtTFYAVmJfN1xmFo1sBf0NmhtX0hXc1O87WPe1xMCy7APzZt/ZmiUComKyxqRLWIkhZzSisSgXyLqql9Q3YIr9NlmJIADsmaV3NauxTZGIJL7QR
 XlxPV7eu
 /ZwkoRGDXkpQnX0sWwGAzny11tLdhTMaTd35CLhxpd8cJ2IZmPXV1OrtOPsDcLmEaMuNrwF+4c0flMYL8ex/5qOSz9NdKjfCPSbc/CSs5KbIKqV7tRUpwCztVfpZI3f4qFro6Nk15KBorN4X5KJWe4Sh0Xyg6/Aw0awTT/QS5lgmiqNf6yZJhM3tUil1rvX2a+vOPty6eNZpDSyz7W2JijnockocJTVvJ3/XM1kqJuDdHjDd0LpFR+skj7zn4WhtG0asaF/fkDJi73fbohqj8BoWZwSWGI+UolqPDMYZk7ug4pPn8DbvgrtjOi1TbMdv1uOW4S2u5Qeq/LFoHJNYdHiBfZq697frbfHNGzgSUjWkPccrDTrMn0A/gTkpsA8n5xBa7OdL6+zmxiHbXwlb8RysPfA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 02, 2025 at 05:12:09PM +0900, Byungchul Park wrote:
> dept needs to notice every entrance from user to kernel mode to treat
> every kernel context independently when tracking wait-event dependencies.
> Roughly, system call and user oriented fault are the cases.
> 
> Make dept aware of the entrances of arm64 and add support
> CONFIG_ARCH_HAS_DEPT_SUPPORT to arm64.
> 
> Signed-off-by: Byungchul Park <byungchul@sk.com>
> ---
>  arch/arm64/Kconfig          | 1 +
>  arch/arm64/kernel/syscall.c | 7 +++++++
>  arch/arm64/mm/fault.c       | 7 +++++++
>  3 files changed, 15 insertions(+)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index e9bbfacc35a6..a8fab2c052dc 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -281,6 +281,7 @@ config ARM64
>  	select USER_STACKTRACE_SUPPORT
>  	select VDSO_GETRANDOM
>  	select VMAP_STACK
> +	select ARCH_HAS_DEPT_SUPPORT
>  	help
>  	  ARM 64-bit (AArch64) Linux support.
>  
> diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
> index c442fcec6b9e..bbd306335179 100644
> --- a/arch/arm64/kernel/syscall.c
> +++ b/arch/arm64/kernel/syscall.c
> @@ -7,6 +7,7 @@
>  #include <linux/ptrace.h>
>  #include <linux/randomize_kstack.h>
>  #include <linux/syscalls.h>
> +#include <linux/dept.h>
>  
>  #include <asm/debug-monitors.h>
>  #include <asm/exception.h>
> @@ -96,6 +97,12 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
>  	 * (Similarly for HVC and SMC elsewhere.)
>  	 */
>  
> +	/*
> +	 * This is a system call from user mode.  Make dept work with a
> +	 * new kernel mode context.
> +	 */
> +	dept_update_cxt();

As Mark Brown pointed out in his replies, this patch is missing a whole
bunch of cases and does not work correctly as-is.

As Dave Hansen pointed out on the x86 patch, you shouldn't do this
piecemeal in architecture code, and should instead work with the
existing context tracking, e.g. by adding logic to
enter_from_user_mode() and exit_to_user_mode(), or by reusing some
existing context tracking logic that's called there.

Mark.

