Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA6D1CCFA04
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 13:46:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E62308E0141; Tue,  4 Nov 2025 08:46:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E39E38E0124; Tue,  4 Nov 2025 08:46:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4FE88E0141; Tue,  4 Nov 2025 08:46:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C37548E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 08:46:06 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7EF7712BE02
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 13:46:06 +0000 (UTC)
X-FDA: 84073048332.03.911BD2E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id D07A580017
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 13:46:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZtxIfP8O;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762263963; a=rsa-sha256;
	cv=none;
	b=mhpYdXgEY8Z9Bluko0D2VRy0eO1g2rBomPzF7LtbM4lZReSpzSmi3W7NX4xFzbO6ee0lKc
	qrLZp/8U/Bn43IQfQ2yTrjQkwWGoVE4oxDf61AhRqv2QQi8j57qmP2WfXzGtCM6y6xidRc
	tqokMeuQW0GUx0fITx2h9nFDCLX5w/w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZtxIfP8O;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762263963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qBb4JYjcOHMwFtnHDJyHLJFdY3oY5dMhkeGhI5Dhsqo=;
	b=o6zS/vX0yOeP5MKHERlPcqMzOGRgWjUA3crR08xcDvX5cxWcfLw4DoaLYGCGikg99zcfDt
	VqWeSdIyF2UtusBvPJI/mhhMe+ImRSzuyV65aHgIZvBRcc3scKwtcWnjJ52s0/ZrM95kbn
	elKbhgnV0zEZ8BvyC6XlNo9ymNYirZo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762263962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qBb4JYjcOHMwFtnHDJyHLJFdY3oY5dMhkeGhI5Dhsqo=;
	b=ZtxIfP8OxR2qKPS62sHuMJsx9psPsSPwgIOqjuInzzGFIGdoOUp3a766upCpkD1jNFSTx9
	JxPug4bUSeS81NC0Xp/VZwZN8SK7liM3pgDNdS6DqAkoUuAyNOBkIryw2UzkNLEWmVj4MR
	kChaJtVrLxtdvLYf8U/le0fS0YGJdeU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-519-50sFmkbnOx6zBl1FgU7W9g-1; Tue, 04 Nov 2025 08:46:01 -0500
X-MC-Unique: 50sFmkbnOx6zBl1FgU7W9g-1
X-Mimecast-MFC-AGG-ID: 50sFmkbnOx6zBl1FgU7W9g_1762263960
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-429cdb0706aso2420519f8f.0
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 05:46:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762263960; x=1762868760;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qBb4JYjcOHMwFtnHDJyHLJFdY3oY5dMhkeGhI5Dhsqo=;
        b=O7xp4Ls/5/gB8Mlmk3LbJDDAq2NzI9r5G1pKWBIe2+oNmO8KQQSh6+LZ6cLxQpB8VQ
         aAnK4FNZVwE6nviZwIBxYnW/Mbno05Fxw0H+KD2tQDzgCLpQl9+mJnl8r+UsT/0YMHEG
         Zf7x62Rew7umoHLzw4xA7bLOM9F3w9wiON0RJZyvOY4N6ILDW014j8Lnhb3aW6sQFc69
         dRsdow5LOZeA4oZ6pqVa7k1bQFsrnT4Cd0qwN2uRAn7xLqq/Vr1xsgzF6oQK4bNTyz42
         wTvSig5ObKzd7/1FeU7im9SbODa9oxgaQ7pWHO0bb69g3y0VVU8j8xvVNfnSZFHOUonm
         lbmg==
X-Forwarded-Encrypted: i=1; AJvYcCW7oZbHYk5aNt2j4diQZq2BDVvqRgOGhBwltmwufYPn13kbWURrjlfZoqt0XAoT0U9V5RKHtlBF1g==@kvack.org
X-Gm-Message-State: AOJu0Yx8tPNn22kZ6WmmaW6JN3876u9/XADFJLiwG+VrWsZqCzir7/JM
	SAe7MPFgCj1yfe6fQXO10G6CQv8pDiAwCnMwrYbfGeRSke/yc+Wa4cpXdoo4lBCLMOaPIEFSGwn
	Yq41NZXJB34JOVoBE8ZdW6+m6MIPAdQmtr9EGX6GKOAFF5M83LEq0
X-Gm-Gg: ASbGncvRwj3ttdKyWfqKaIlcVoOjyb0jceoTygowFdFz5rEkaCw60cxhTAqGWejyrET
	QTzVSuRW1SlEflsMZ+RMo8kqQjYh0oY39s6fwTWuppZ+b3mdxoBvJvSAL/dmSm8tyRhn3a+cNZz
	JBvvaxZVZ9gIHCnCI4ZgYma6QaeXEq1loA0c02XnE1ln6xxacI214Ih6rd8teEqLOU2AOuo5+Or
	BCP6fgXxpDTYoyvu9l6HLCZZQ1RZOfEXOGcdYZJ47w1V7UnGvwVq9U8QD5eUd+4LQd4MjTFz2i3
	61CUlN7orAAuTKPmsA4z6c+zvd8EXFfhXYMcPv1bVDlkSitWRbdumfotmPs8Vpq1kaTqTxS41pe
	Cn11qgJlO6pL+HrREqxEYrXGT22ebUR5F0tU=
X-Received: by 2002:a05:6000:22c9:b0:429:d11b:9ec4 with SMTP id ffacd0b85a97d-429d11ba360mr6284612f8f.41.1762263959581;
        Tue, 04 Nov 2025 05:45:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGRnKz3y+r5XoY3ls/nBZPt8sht5PzwdeS+jf9m1q52xASXswgB53muxrTyL7Mvrv/sZwgkKw==
X-Received: by 2002:a05:6000:22c9:b0:429:d11b:9ec4 with SMTP id ffacd0b85a97d-429d11ba360mr6284574f8f.41.1762263959010;
        Tue, 04 Nov 2025 05:45:59 -0800 (PST)
Received: from vschneid-thinkpadt14sgen2i.remote.csb ([2a01:e0a:36d:2b80:e937:44f0:a96a:94f2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429dc1a8528sm4959089f8f.21.2025.11.04.05.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 05:45:58 -0800 (PST)
From: Valentin Schneider <vschneid@redhat.com>
To: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Nicolas Saenz Julienne <nsaenzju@redhat.com>, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter
 Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Josh
 Poimboeuf <jpoimboe@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Arnd
 Bergmann <arnd@arndb.de>, Frederic Weisbecker <frederic@kernel.org>, "Paul
 E. McKenney" <paulmck@kernel.org>, Jason Baron <jbaron@akamai.com>, Steven
 Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ardb@kernel.org>, Sami
 Tolvanen <samitolvanen@google.com>, "David S. Miller"
 <davem@davemloft.net>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Joel
 Fernandes <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>,
 Boqun Feng <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Mel Gorman
 <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>, Masahiro
 Yamada <masahiroy@kernel.org>, Han Shen <shenhan@google.com>, Rik van Riel
 <riel@surriel.com>, Jann Horn <jannh@google.com>, Dan Carpenter
 <dan.carpenter@linaro.org>, Oleg Nesterov <oleg@redhat.com>, Juri Lelli
 <juri.lelli@redhat.com>, Clark Williams <williams@redhat.com>, Yair
 Podemsky <ypodemsk@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 Daniel Wagner <dwagner@suse.de>, Petr Tesarik <ptesarik@suse.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, rcu@vger.kernel.org,
 x86@kernel.org, linux-arm-kernel@lists.infradead.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
 linux-arch@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v6 23/29] context-tracking: Introduce work deferral
 infrastructure
In-Reply-To: <dee4dc13-b187-42df-93ce-f738cfab32ea@linux.ibm.com>
References: <20251010153839.151763-1-vschneid@redhat.com>
 <20251010153839.151763-24-vschneid@redhat.com>
 <dee4dc13-b187-42df-93ce-f738cfab32ea@linux.ibm.com>
Date: Tue, 04 Nov 2025 14:45:56 +0100
Message-ID: <xhsmhjz05ud0r.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uu_k1lsp1Kyjzce0qm7_4Bgore2RIYnf7_SgoWi21Ps_1762263960
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D07A580017
X-Stat-Signature: fzd8915678s373jbdc3dbm9grbioh3m4
X-HE-Tag: 1762263962-968243
X-HE-Meta: U2FsdGVkX1/FSP5SANOhw5JZir1gmK8Ih++FQprhwBJ/upZY8c2MB7cQ5bwFvv1HPQVvkwaUuBfS+ztkrllzs2JhNUp6+A3B9Kn5yM7Ylu0ss4VlIyOPrk5njZcuarc0nDmwIDKvR/ExrW1AY2H28Ob3w6q+ycWBl9w2K/hMZrQDQb2+twNtMN6O/taBDGw2sOVgvXJww3YMsB0m4PD8zT+Qz9W3wnnMqxV6VDXfjt0dl9OhrNXLqPvn9WVko/x4k9Cs3opkZMNNEGxCSO2H+BOC105mB+tmuQ14GGywDoQd1rINN7YDX6ddNlB7qsHAXVLWjBpnSkOruX4mZk6GjeWqlcfp1fPKhH09+lMDca1X6VuO/4vCfs2cjx9qVYhCwdsJCZ/npt2wtW4pU2nv3TMdqsEtXM0ZkFJUa/N2Hl/4CrZmW15Jeunm9zIe29pLl75XM1rvKWF3NIdXJLBomy2jmN0szLYr0qYvW2hAer4A7RZM80LdWVMz87jo78vr56hdKIQ0EPjHGqG/m2UQJDzbagk2OCJ269tPbLb9riKBnygZ8bfwWs4kUlTIKelDml6bMzdzbWgXXAzndHdPbHzdu4LSZOWSi5RT81R3zmMJLFjnnFUBotnbHwKw8rf5YrLib00ja1Wq8964kTMhsSyKzz3SBXhKEJFlAfJUeRAow0YCDwKK9urCPVqT8wCPyphT21tiZs7SBBseFSwqFllFO93MbjAAkjYSuIU9JxVzvqHn0yCzq8mNlKYY4DpbJ/Y+791Ipxi0y0dFHJ5bEn1dnJginIZn1rFg6IT0TVxEhkgYOdzCBYfHXMbuXKC03yKHbiJ/h/QtCKvr6tNXS7uHHZ9qFS8lWyQP6lw9dwR9MuLhy1IASQJEQBOjxr8uuCaGvtxlzdG9ROJHKp3jFfFFsmNwZ+DQJnyWDCgwVLNqeblfmEu2om4Hc7cIG7dx+f/EP1gNSBIrFp7DYEk
 B1KSpaGV
 aZgnG1cm93e5M+5j9t+AeHzdQG8ilEgc8YMSPl/FFs97hmZr/8xkUEBhcB9dPuPxoDbEIY7UVT4EA7RO/LNen4qo4wqo7igrohLqjPdOt7eLHc3yai1G+3IiRNsJQDUY/EZFs6ynt86M0s6USC4L1SCsnA9MEK6ih6uLqZmHjx2Ev/9xnloUAyEhWrP7wgqw7y8GCyiu+nOYnZvNcGSXnTd6A8TvujnEM0gvMtWs4u8g9zH8ykYhgTEJLCoSdbx2CXELzgVqkyekOl3IesbBiznrJrmGeQFLcUG7N76LK/YL1x3MzadVKV6DiobN75U4OAwpo8Qh8hCq7QJ7LfUoosDk1uTIgWOib823WEP9cOMJUY2ZlzblHiw4a/MSTT6vHeXj4gRkTGg5YQI5rBywUbyAX5EecxYp37CAhceyyayynFUM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/11/25 14:02, Shrikanth Hegde wrote:
> Hi Valentin.
>
> On 10/10/25 9:08 PM, Valentin Schneider wrote:
>> +++ b/include/linux/context_tracking_work.h
>> @@ -0,0 +1,26 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef _LINUX_CONTEXT_TRACKING_WORK_H
>> +#define _LINUX_CONTEXT_TRACKING_WORK_H
>> +
>> +#include <linux/bitops.h>
>> +
>> +enum {
>> +	CT_WORK_n_OFFSET,
>> +	CT_WORK_MAX_OFFSET
>> +};
>> +
>> +enum ct_work {
>> +	CT_WORK_n        = BIT(CT_WORK_n_OFFSET),
>> +	CT_WORK_MAX      = BIT(CT_WORK_MAX_OFFSET)
>> +};
>> +
>> +#include <asm/context_tracking_work.h>
>> +
>
> It fails to compile on powerpc (likey any arch other than x86)
>

Woops, thanks for testing!

> In file included from ./include/linux/context_tracking_state.h:8,
>                   from ./include/linux/hardirq.h:5,
>                   from ./include/linux/interrupt.h:11,
>                   from ./include/linux/kernel_stat.h:8,
>                   from ./include/linux/cgroup.h:27,
>                   from ./include/linux/memcontrol.h:13,
>                   from ./include/linux/swap.h:9,
>                   from ./include/linux/suspend.h:5,
>                   from arch/powerpc/kernel/asm-offsets.c:21:
> ./include/linux/context_tracking_work.h:17:10: fatal error:
> asm/context_tracking_work.h: No such file or directory
>     17 | #include <asm/context_tracking_work.h>
>        |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
>
> Gating works for compile, but no benefit of the series.
>
> +#ifdef HAVE_CONTEXT_TRACKING_WORK
>   #include <asm/context_tracking_work.h>
> +#endif
>

Huh, looking at this I wonder why I shoved that here. That include belongs
in context_tracking.c itself; I'll fix that.

>
> I have been trying to debug/understand the issue seen with isolcpus= and
> nohz_full=. system is idle, even then it occasionally woken up to do
> some work. So I was interesting if this series can help.

Is there some ongoing thread for this particular issue or is this just
something you're experimenting with?

If you suspect stray IPIs hitting isolated CPUs I'd recommend tracing with
these events enabled:
  ipi_send_cpu
  ipi_send_cpumask


