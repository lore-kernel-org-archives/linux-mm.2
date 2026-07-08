Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CB77C44501
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 07:53:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 621746B00A3; Wed,  8 Jul 2026 03:53:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D10E6B00A5; Wed,  8 Jul 2026 03:53:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C3536B00A6; Wed,  8 Jul 2026 03:53:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F6F26B00A3
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:52:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7CDE91A06B9
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:52:59 +0000 (UTC)
X-FDA: 84964843278.26.D32C045
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id E615F140004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:52:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H9YaHWQr;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783497177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7K4NCcrN3IVlK9BJtN3q7S9JVAIiJu4qBDxqNODXPvM=;
	b=fiEkzPUPJuKkNaP+iXkpV+Uaq9+PX+FuI0Z4aH8VnNYwx7UcDXbP2ECS4KpjO6H60vZJF4
	F9PFY0n1y8vDJYSuOT21fmWvOEbduap651+HyBnoPGnshArERT0MkhP9n8O4IK5m/ub//q
	a5YYvuO27DKcIPXhtYjqvo7REtY62uU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H9YaHWQr;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783497177;
	b=2bzqB2LWmxG7gdoPH+4my/jcaW88Xf2USG907W77i4xuIYFLcbjsYE5FdUolQnQDQVk+i5
	BmuQgEA5LdXdl0fTu/yoDu0I9CUenJikJooU44PPZR7RYldfS/cljHVMiHuCuLLt0+ZGQt
	tLQMiQSHsFAtgcX3AT64hW3vujhBPdU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 63C9860008;
	Wed,  8 Jul 2026 07:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFF11F00A3D;
	Wed,  8 Jul 2026 07:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783497177;
	bh=7K4NCcrN3IVlK9BJtN3q7S9JVAIiJu4qBDxqNODXPvM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=H9YaHWQrK1YujDYyV6crTr6KbOYfjzzQIBWVR7KE/419stnNd4ED/M5LA5tCOsCDB
	 36pgz7R6/0Zf0am5FTTAZXpKWlctvMKmZ7IhwGjLLqXMEVSXpZhmILwnH4MEgyImci
	 xzlIxy3qsNMJBRt4Oq1ZJrXCytH2i2dTNpcM4K5lcVbdc0zu9bAvOnVZCCZG+e2SLU
	 9DOmhcPONM14BRhrGKxlKlMgTPA2Xm+rELQNHcsW+T2I5NJtH02mPB/JjN9IUBlicR
	 lL7B298F3VYVAPUZiBiv1DGsnNqp2PefONaDjlqtIKu6Fyr1mMHbRtPn8CKsuiTBVI
	 FvJ1smPFQdcEg==
Date: Wed, 8 Jul 2026 08:52:36 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Cc: Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Eugen Hristev <ehristev@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, Frederic Weisbecker <frederic@kernel.org>, 
	John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, Kees Cook <kees@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Petr Mladek <pmladek@suse.com>, John Ogness <john.ogness@linutronix.de>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Bjorn Andersson <andersson@kernel.org>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Saravana Kannan <saravanak@kernel.org>, 
	workflows@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-arm-msm@vger.kernel.org, 
	linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 14/26] mm/init-mm: Annotate static information into
 meminspect
Message-ID: <ak4A3u9VfmDZA4-i@lucifer>
References: <20260708-meminspect-v3-v3-0-7aa5a0a74d5c@oss.qualcomm.com>
 <20260708-meminspect-v3-v3-14-7aa5a0a74d5c@oss.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708-meminspect-v3-v3-14-7aa5a0a74d5c@oss.qualcomm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E615F140004
X-Stat-Signature: 7yois8g4yccrpngnoowr35bznid9ec88
X-HE-Tag: 1783497177-303355
X-HE-Meta: U2FsdGVkX19f18wOrm9N4tHd1+6f7tYd0bK4Htgr4C+PuOKND+KfUm5kqR9VFsePPz112Mi7nFij+t7Jt+NoyBew9HllMbAVsqO3XNn2/Mj0mUEkxRhwQ6n4r2lhdFC2NwoTTWSa1pn8dniDu0YojtqbeQwdKBnaP6EhnUHQPrEthgmAqNVMdfM17QVtkVVk2iWoUEImhl43spfSbB94PE69yu6+OxFs4EvamiarTCMcaXBdFSwuaxhInYNsgXx3fbh39PP8N0/4xw+yUGQwN25v9GoFZrcnwuMeJfXen6gaFL44Rod9+WKf/yoYWb1jE8RBE7/2KLtq7sMlIcuiSugB95bIhyXiiSZ5wHB5078R9cpUPYiFyTt3L78Qs4wpXHu4oGTgpYkckur8wkv/3J8ffUjuqL7NchfV7Ul7bXgg5txBTzdCf/OzJpeIE2ipDvrNgD2iFexdTUiOI70rNhFiST/J9dfGenedrWip5AhMr1O6bOAQhIYrL4OPbcVU5OyTD1NTfwdEFVi2lZaKwtuz8/kqoaoyuAM3cX4I2/d4G1zzHChw5BUN8ZMRIGGgPJklI3uboF16TqbhWVpBFX9vrqcx+zHit3dHvYvxGCvWJlYtTOZPs7nq2yeA3Fd7x0Nrn17PYYXlCf8iR8cdw1MXMnk8xrF66VLCeopy80oXgQeJHfbgoTZDhK1yW9kEhWbRs0ELdolpzdCbj7YgmtPgAEU7/ZxPzA+k+DglQLAglfiVSv/vpeRU8k/GcgL8EfHhqTlfh7/ACY8o4PaOf8b8HwonjU87pnRFdh0xN0bffS/ykoVs1+3y4qEsUfJ6jhrA2a1CXYzvH+9csr23A3NwqF++FSQFuq/L+Zy50xoLlA2t9613nufUdh8H1vPo6lIdgy+UEQuYXfL0bGgYxmQ7m00atIJ68eHuW4f2yQhTdfFv+XMb7daYgHDGnuRqBn5QnBXXO67r9sMMFeb
 B5ZJm1RC
 wkkfktvxeex8AiwOyVoJ+LylUUjE2w/xztY1a3DXMwsPSQYwcBDgNzxwzOmQgmxf+28q4G82JD/fZhPU67qyCv/pslggP8BGDeTepxeLMVAUkUQNIVyW/5PVETGWqB+FZivmb8NrmWBac0TmwYSr8z6OvBHbulJ9SArPRRpV/BLx+jenbOHbQQOdabP23xr8X9mdesYpssC1j6UAS4NePvhQDTFQtJ/R7liGmeR0dFeYT7mBdexa1jYiYV49vRXJMl4pDfhulySpPNt37Fsev9x2NZOInnXWaV8C0RPJ9nOAvgvmRDwTmfoVn6Y9mOs4tJlhePjVBK8AdmpKMR3WDYkU+dJsnI1xHketkhuPfbDllGRZ47wtkHzonvvbZBx+p0q6WJzR+yAQtRGanqiERYqAv70jzSKH/yaPgwNDa0ltCdRibJwZWpX5tEAp/9lyjuNEBRjPnrnBE9NUqQgHXsVC03Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NAK.

You're exporting internal mm stuff to drivers, in no world are you going to
do that, sorry.

On Wed, Jul 08, 2026 at 11:01:53AM +0530, Mukesh Ojha wrote:
> From: Eugen Hristev <ehristev@kernel.org>
>
> Annotate vital static information into inspection table:
>  - init_mm
>  - swapper_pg_dir
>  - _sinittext
>  - _einittext
>  - _end
>  - _text
>  - _stext
>  - _etext
>
> Information on these variables is stored into dedicated meminspect
> section.
>
> Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
> Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
> ---
>  mm/init-mm.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/mm/init-mm.c b/mm/init-mm.c
> index 3e792aad7626..cf53058410b1 100644
> --- a/mm/init-mm.c
> +++ b/mm/init-mm.c
> @@ -7,6 +7,8 @@
>  #include <linux/cpumask.h>
>  #include <linux/mman.h>
>  #include <linux/pgtable.h>
> +#include <linux/meminspect.h>

Hate the idea of a very specific inspection mechanism hooking into core mm
initialisation in general.

If you thing needs to do this, your thing is broken IMO.

> +#include <asm/sections.h>

Err sections? So now this file is now a dumping ground for meminspect ELF
section declarations?

>
>  #include <linux/atomic.h>
>  #include <linux/user_namespace.h>
> @@ -19,6 +21,13 @@
>
>  const struct vm_operations_struct vma_dummy_vm_ops;
>
> +MEMINSPECT_AREA_ENTRY(_sinittext, sizeof(void *));
> +MEMINSPECT_AREA_ENTRY(_einittext, sizeof(void *));
> +MEMINSPECT_AREA_ENTRY(_end, sizeof(void *));
> +MEMINSPECT_AREA_ENTRY(_text, sizeof(void *));
> +MEMINSPECT_AREA_ENTRY(_stext, sizeof(void *));
> +MEMINSPECT_AREA_ENTRY(_etext, sizeof(void *));

Is this just a weird way of getting ELF symbols?

> +
>  /*
>   * For dynamically allocated mm_structs, there is a dynamically sized cpumask
>   * at the end of the structure, the size of which depends on the maximum CPU
> @@ -50,6 +59,9 @@ struct mm_struct init_mm = {
>  	INIT_MM_CONTEXT(init_mm)
>  };
>
> +MEMINSPECT_SIMPLE_ENTRY(init_mm);
> +MEMINSPECT_AREA_ENTRY(swapper_pg_dir, sizeof(void *));

Absolutely, positively not, this is totally insane and COMPLETELY violates
separation between drivers and mm.

We already let drivers access FAR too much.

Exporting core mm internals would be like giving up on any semblence of
separation of concerns.

> +
>  void setup_initial_init_mm(void *start_code, void *end_code,
>  			   void *end_data, void *brk)
>  {
>
> --
> 2.53.0
>

Thanks, Lorenzo

