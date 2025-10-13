Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC526CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 04:28:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A2EF8E0007; Mon, 13 Oct 2025 00:28:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27A818E0002; Mon, 13 Oct 2025 00:28:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 190248E0007; Mon, 13 Oct 2025 00:28:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 063C28E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 00:28:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A1FB216022B
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 04:28:20 +0000 (UTC)
X-FDA: 83991809160.06.3925952
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf26.hostedemail.com (Postfix) with ESMTP id 989F314000D
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 04:28:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760329698; a=rsa-sha256;
	cv=none;
	b=WCw/HygMF0fNuS7NglXLhvubMZhWU/6i7WwYfWb9rItJhhUJje6Tcd/TcKHyXW1dbcH+aA
	MdmsH3RciDPALvL4oxpzFtW+M7I9AgxBbSV5Z6fz8PPORTRwWrieHi6Klor62SVDtiZbzN
	sY7YH1stwYETHJfIM3ERR8T9D7Rgwps=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760329698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nDqjQIr1werD03wEz8iRQcqL0fbhbA8wNvKC4m8xXdM=;
	b=gRmNrvuJyBz7c8MpC6ZAlgmpU1AoNsH+jb4wPq5D8Vd6tkPNNroWQO47iVj0N8ojVUOTPz
	djUChdBX8OK9V8lApaSozI5q80FJbOSGtdNxcj+6p/RR9gVxnhL6VSI+Z/HpHSYCE9/T2L
	v3TAAAf0Dq8HUiP58B0XRlORPn+C3kc=
X-AuditID: a67dfc5b-c2dff70000001609-b8-68ec7fdc6e98
Date: Mon, 13 Oct 2025 13:28:07 +0900
From: Byungchul Park <byungchul@sk.com>
To: Mark Rutland <mark.rutland@arm.com>
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
Message-ID: <20251013042807.GB6925@system.software.com>
References: <20251002081247.51255-1-byungchul@sk.com>
 <20251002081247.51255-10-byungchul@sk.com>
 <aN_fel4Rpqz6TPsD@J2N7QTR9R3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aN_fel4Rpqz6TPsD@J2N7QTR9R3>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0xTZxjH955bTxs7zgoLr/bDTHfLcDpd3HhY3C0m28lwcXMJHxgJduPM
	NkIhBVFmGBUpwSmsuhRCi6yI3KuwUycC6+LYwLFLrEJGdbSIVDqyFqaDEjJod4ox89sv//+T
	3/s8ycuSqkZmA6s3FAlGgzZXwygoRXhd02ZfWUi3tXkaw+JCFQUN3U4GqsR6GiYXqxAs/Wsn
	wdwXo2Bh+Q8ZxNzDCJwXjhDwT0+UAetUgIG62SMUzA69DeHJARpiviAB45EQgtZAlIDV2v1Q
	Z/UgaJrykXBh2I9gNPAojC3OMzBiPc5A+FoDAXM9DDjK3TTUnhYp6LvVL4OJ2lMEdInvwi+W
	M4T0BgO1XyeDve4oAdZzAwQst3bK4NfmCQrsv43SsDK1DWKOfBjuCsrA94WVgvPhqzSM+H+X
	DrlSSUOv6ZYMxBtD0vonZkgQp6XCfXMT1DdOMDDa38CA3xmjwWRfouF6l4eC7qCXgBFbBwVX
	+8/R0DJ+jYBIjRo8J6tp8FruIPhybga9kcMvmWsovtN1keDN11cZ3tnoRPxCy1GSN1sk+iE0
	T/IVroO8O+Kg+J/PYL7P5pPxFd/dlPEO8QBf8WOY5l3tKXzzt7PEe5szFTtyhFx9sWB84bW9
	Ct3tmctUgZh0qP3YSdqEwgmfIzmLue249/i47AF/1VtBxZninsZtkbY1Zrhnsde7TMY5SeIT
	/QtSrmBJrkmN3U7PWpHIZeOVjjEizkouFU+Id4n4kIorR9jUXUXeLx7DI/WBNSvJpWBvdFYa
	YiVW47YoG4/lUtzU9zcd58e5J/Hli1fWPJjzy/HdOTO6v+l6/H27l7IgzvaQ1vaQ1va/1oHI
	TqTSG4rztPrc7Vt0JQb9oS0f5+eJSPq1raUrH15C9zwfDCKORZp1St3AXzoVrS0uLMkbRJgl
	NUnK1MMhnUqZoy35VDDmZxsP5AqFg0jNUppk5YuRgzkqbp+2SNgvCAWC8UFLsPINJlS9983s
	V7LuZUxmvmNK3Ply2cb1cKeydVfm9NDu51MyDD07nxrPHpUv1Rx7HSWESlejRQmVrtOB6vLP
	yiqf+cTu7T7vGXt/Y2MgTRfanTaf9lFBerDouX2JHX9Sb/lte3akcq5HnuBb1D1jP5VmWFZv
	n33p8KWsG1vTs4Lpm745pUxefFVDFeq021JIY6H2P46klOixAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTZxTH89z73Bc6ul07jDeQJUs3Y8SoM7p4Msxi/KB3LDP7sMTMxGAz
	b2zDm2kRxcUIFCI6o7SzdLSKFEep0AkWlCHpJBjrgFWpVGWOipgKVNoxWYtDSvGWZZlfTn7n
	/3LyfHhYUpGg0llNQZGoLVDlKWkZlu3M0q8dORZWf/T7i9XwoKwHQyxaheFcq5OGKlctBYOX
	WxCMxqoQvJy3klDZtYhhwehhIDr3BwOLbg+CGp+RBGdHGQF/tyVomLo5g8A0FqTBHCrDMG0/
	hcAybmUgdGsHREa7KVgMTBDwcDaMwB5MEBDsOY5goSYXLjS00zDvvUuC2TSIwDYWIGGyTTI7
	PI8RuB3lNDyrvkrCUPBt8MemaegzfUdDxHeOgD/baKgvd1Nw3mpEoL/YSkPNeReGrifXGfBN
	xQkYqTES0OL6Akbt4xgGqhsI6X1S6soKsJr1hDQmCTD91E3AnL2Zgd8ujmCwl64Eq3eIgqcO
	CwPxsQ2wWF8InpYJBgJnTBguR+5SW01IeFl5GgvN7dcIofLeAi0465xImH9lREK0UU8KldXS
	ejM8TQoV7YeExoEwLbyK3acF92w9FvobeMHgXSt0WQKMUPHLI+bLT3bLtuwT8zTFonb9p3tl
	6qfjPfiAK+2w44SBKkWRd06iFJbnNvEXOitwkjG3km+abVpimlvFDw/PkUlOk/jU9aiky1iS
	s2XwbufgkvEul8PHL/mJJMu5zfyI6wWRDCm4csSXtlaR/xrL+L7a4NJVksvkhxMhKcRKnME3
	JdiknCLJtq6/qCQv5z7ge67dJqqR3PJG2/JG2/J/ux6RzShNU1Ccr9LkfbxOl6suKdAcXvdN
	Yb4LSb/SfjRu+BlFh3b0Io5FylS5untKraBUxbqS/F7Es6QyTb7527BaId+nKjkiagtztAfz
	RF0vymCxcoU8e5e4V8HtVxWJuaJ4QNT+5xJsSnopavznkR+fyDkZOHtcf+f5j1lnFRMtX7X2
	RTfKfP2h9DX+eXJLaNuRnbHs3u3esgann+Ft34/1v0cdelY3MGNYvudewKCd+GxyTXnEQXm3
	vu/+nMlMXWa+6nqr88YuWx16/uuxBarzccfMDxXZDl+7L27+8ODXp4n81LmsGY/PXlukxDq1
	akMmqdWpXgMpcDDEkQMAAA==
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 989F314000D
X-Stat-Signature: dyaoyuj8jamrap33qaufp1i8oqu65x87
X-HE-Tag: 1760329697-575920
X-HE-Meta: U2FsdGVkX1+LVNuFsdcpal5vt26ZoGQ7bU/p9X9Mver86Xv0whn5dOm/bg/+JOrQ0EEbt0i3vgv/MTvADYNAMZ6IBGgZps8IKMTqamqZMid4KZxm+e3coQl8Sc0QtksB0Qa16fqV42SHWBhaadt2r0QccZsKLdEKn5f4eHbcD0UZyf09hAMAHFwtgeGCiEDzjCH/T3jHRhP/Gx35yeyswlQ4oealUzN0kR7SD4GfTxeJlchpzBg2nbd+I3j2HLBoViorlH5rLQ0nYMTCchUj8JcTMd+U9MJvkWBsVZjd+yLTCFNPJhbZc7DPR1r4zk2XsjkjuqlVnCZpu4RxVuSzMQmAvYmyDwlFuT4yiQTrI6dE0kXIpC5w0EHXloBTKGZY9iOhOyDlWMasHYqbNnsDlzwHAemxBlSeacyDVJkHSGZprDze83GsWVEcbGFR8GX/o9iibuAxEW1trPiVeXN8R0TV5x7YNkuF07HtZ0jUSVMVTxBo8E/fWgVAmJvlgQLPSvtaeEmnoNgHc7yeVg4JLNsHENyeWUQD7uiDD48u4JhEBTMPayveodG7VOtT31TYSO7zEXIsvovo+NynTRXe9TRakwPGYNT4QZEJyyy4Dqx2q+SZqE4elUaNdd+LZpKJQEpeyUs9EgrRz4Dxlhml2Xy/vjnbdFUemiC3i7VNagddM/8zYrvJOwRKh1jZ6xynN/iZe7whAf7zWqdx91pzSHEkrXQBDrEvxgny2DbyFfM83BEVII8GYrRpOyaUmqXhOMBqiY2gNOMEhK6BX3gF6FC+/JF6M6fbhn9NvFqGsGaLo7X7NcrjgVo3xujm1AXmzQT7EG8TY8MGWFBvsRy/RcvvBp7fStbOlVeTwmN7m8vhVC8GjZZjmEmA9D6dl8yWWVGgYrwX7U8UeuhEBTwtFTLzxrK8B9+nEK5YqyMeDAAsrw9paCvvWMqfEsnk7TUHw+ZQL9RwDLYSz9HKibX
 1+pMjUc/
 Mg7ryMQ4ikkDhUBDRY52clh4kBjKYEZiG6wIBX7IrLupW19twtFFWvPKbRIflY4zUjQCxZZJETpc2BvmlCfijrweaTyCp51e9Yckt6vaxAPY66tT6R43vaIzUaH1aUerYauzipQAP2qz4/pM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 03:36:42PM +0100, Mark Rutland wrote:
> On Thu, Oct 02, 2025 at 05:12:09PM +0900, Byungchul Park wrote:
> > dept needs to notice every entrance from user to kernel mode to treat
> > every kernel context independently when tracking wait-event dependencies.
> > Roughly, system call and user oriented fault are the cases.
> >
> > Make dept aware of the entrances of arm64 and add support
> > CONFIG_ARCH_HAS_DEPT_SUPPORT to arm64.
> >
> > Signed-off-by: Byungchul Park <byungchul@sk.com>
> > ---
> >  arch/arm64/Kconfig          | 1 +
> >  arch/arm64/kernel/syscall.c | 7 +++++++
> >  arch/arm64/mm/fault.c       | 7 +++++++
> >  3 files changed, 15 insertions(+)
> >
> > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > index e9bbfacc35a6..a8fab2c052dc 100644
> > --- a/arch/arm64/Kconfig
> > +++ b/arch/arm64/Kconfig
> > @@ -281,6 +281,7 @@ config ARM64
> >       select USER_STACKTRACE_SUPPORT
> >       select VDSO_GETRANDOM
> >       select VMAP_STACK
> > +     select ARCH_HAS_DEPT_SUPPORT
> >       help
> >         ARM 64-bit (AArch64) Linux support.
> >
> > diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
> > index c442fcec6b9e..bbd306335179 100644
> > --- a/arch/arm64/kernel/syscall.c
> > +++ b/arch/arm64/kernel/syscall.c
> > @@ -7,6 +7,7 @@
> >  #include <linux/ptrace.h>
> >  #include <linux/randomize_kstack.h>
> >  #include <linux/syscalls.h>
> > +#include <linux/dept.h>
> >
> >  #include <asm/debug-monitors.h>
> >  #include <asm/exception.h>
> > @@ -96,6 +97,12 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
> >        * (Similarly for HVC and SMC elsewhere.)
> >        */
> >
> > +     /*
> > +      * This is a system call from user mode.  Make dept work with a
> > +      * new kernel mode context.
> > +      */
> > +     dept_update_cxt();
> 
> As Mark Brown pointed out in his replies, this patch is missing a whole
> bunch of cases and does not work correctly as-is.
> 
> As Dave Hansen pointed out on the x86 patch, you shouldn't do this
> piecemeal in architecture code, and should instead work with the
> existing context tracking, e.g. by adding logic to
> enter_from_user_mode() and exit_to_user_mode(), or by reusing some

I will consider it.  However, I need to check if there are not any waits
and events before enter_from_user_mode(), or after exit_to_user_mode()
since those functions aren't the outmost functions for kernel mode C
code anyway.

	Byungchul

> existing context tracking logic that's called there.
> 
> Mark.

