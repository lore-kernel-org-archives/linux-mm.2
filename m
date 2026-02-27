Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50FF8FD530A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:46:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B22FF6B00E2; Fri, 27 Feb 2026 14:46:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0E3A6B00E3; Fri, 27 Feb 2026 14:46:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A45006B00E4; Fri, 27 Feb 2026 14:46:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E1F66B00E2
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:46:35 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5C191BB748
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:46:35 +0000 (UTC)
X-FDA: 84491268750.08.9585074
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf27.hostedemail.com (Postfix) with ESMTP id A4B8040004
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:46:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772221593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l5T0iL8DI1nGNFuwO3l69tcGuHXN+8usnX63z8h89mQ=;
	b=J1tIAFo/7vH3uLRgmfd/PjcJXl/pzePIkGA7WGs9Y87YDD8Pb441IkALBetnE8MuW2US2I
	BmUlrbshNGMBHLNHgitwS5F1XdzdBwAYyadn6QnqZdpZzQ0nn6X1SpNEsdy7GC/48kN6Ua
	Ul+BmHkWQVfz0+bFYiTI4LF1RuBKLX0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772221593; a=rsa-sha256;
	cv=none;
	b=U1x906USstV5ZbpSzjS+jhdj34COeOQvA6Piwzr6Nh7TjpuDj4ji5+mfvG2+WQiXREvRbK
	oJt+2BgUER1bPJQG+cAS/o17pP1xvujfpV0sidQX0t4nEV3N1M7tF6mgHH1RQljRUbpVyw
	4jOTmUHGYGfSMcCtDazJWZKgZ/FIKAY=
Received: from omf16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A64C8C2DB3;
	Fri, 27 Feb 2026 19:46:30 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf16.hostedemail.com (Postfix) with ESMTPA id 73BB720016;
	Fri, 27 Feb 2026 19:46:24 +0000 (UTC)
Date: Fri, 27 Feb 2026 14:46:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu
 Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Len Brown <lenb@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Oscar
 Salvador <osalvador@suse.de>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-pm@vger.kernel.org, "linux-cxl@vger.kernel.orgkernel-team"@meta.com
Subject: Re: [PATCH v4 5/5] mm: add tracepoints for zone lock
Message-ID: <20260227144649.3dbff742@gandalf.local.home>
In-Reply-To: <ae145fe890f028409f727b4921904b547346fa0b.1772206930.git.d@ilvokhin.com>
References: <cover.1772206930.git.d@ilvokhin.com>
	<ae145fe890f028409f727b4921904b547346fa0b.1772206930.git.d@ilvokhin.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/tqfZb3BP+WqZirC6uLCguAOnl9bJ5e/E=
X-HE-Meta: U2FsdGVkX1+Ubmu8sp2dODz5b7SCRkSYEMDCN5v+Sc8RVUFnTWMyKXGqiKeiHhzkb2b1Dt/LC4TG2ySWIbTgjCHFE48LoFDsaEiICe/p8YN2/aPzcJqnY4OY5teYzActk2juaAd+qIppoE/NFDJjLbtNhjOKa04i3NUWuE7O7t9k7DBa3wPcVD/96J/S3S56BDlMtAEH2ZhsHViBS0zvjZ2m5MGhBwQ/3htcYvpQ5Camj+HNfnlj7k03cLgqGqiR5pfViHhEEPD4H0s2EEStIofDRZ+V41gzV4ABYYm5Qzx6r4lMEZFm+F36k0XQZ2gkUYizcUfjlEX3hLaZVHTupY1zOu+4rwAQlFtkxnG72c+Z0v97kHyhCGdUcY3IPgqS
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A4B8040004
X-Stat-Signature: 75z95ye3rzrmfdo81wu9y48dgd3xrfx4
X-Rspam-User: 
X-HE-Tag-Orig: 1772221584-850844
X-HE-Tag: 1772221593-768876
X-HE-Meta: U2FsdGVkX18NfDTDuIrOfUVsGFETEVi6nOAVoncRl28PLJOs+1eATalq+w3PcMaZyCgxqxH1VlgpN/pDsA9/yGMCVsKXNuPxdXaycH0cBR8FjOfn98RXelePdtV/naXOTq6WRJDubfUcAtvbO5PdwJL/Y9dm9xhCcCylC8LnRJjaXB6GD3Qkgx3xJT7gHCDj6EdBn9Wx0VXTWL+Vb0q04SibmNYhc3sT/FyN5a520KWPaZ3fXT5xdApqzXJlEK5GsgWEoafN5uyw9NEBa8L8YBbDviDyHe/o/WPmKHClBDk37ctzAiyyj0ho4+DZC8sIABsNOMrFwjFnEYipid4BNX4m5Q5HwmR7uOsgkyylGY9OVDJWIhhuN8aKcLCv9pYB23THHyBpol0d/kt+N8knjsbWtREc0/MjH6ld5fGav1Jn//ga4dS7NhMELAK6Pjz06LnFXzu91DV1196c0qH5ajcre+V/UGSC6n3e4M5mYeYUkwG6qwO/kUS8PwErbB21QcbvLuTimWZaX6DaC/D2Nc5+TnvgGYbxSwofxpv+YpgQamCPJ62VKHWeJvUzza7VmIX6r0sOte10vVVze+BqwsuSIZhQHSDf5aj7ptkz357egMezW6/HwWSKL7UaTVkVoRsEeYGtEqoJ9kttGuKpJrKV4Pi7TwwMSynvSPp0SuISgBLZ3hhFLx324GkTI87OBbtGi5i5fo5SBdkYbwmP6nCY+NTSB+ieIKHy3DRMZzH3DSRpGrCokfutT7qsHeVJlvVpX4HT9WiS9DahDHoHR6EuR0Mc5ydgZpwjycfeBQ0Yl4uSWfZav2cfxr7oR7FQzmYaeUsrQVPfx+bkWDoFw89WwpM1KEadpJFte0L4zr+lVkSOb41/eHNxdeymAkvIUcVVLZuSZ7yt1Cq2HluRK8dZ0cebLEv5Fp3xvPoDvSrJid59ZjdmtycBzCbq/RdMORxUF+e47sOTV1OI7ZH
 hwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Feb 2026 16:00:27 +0000
Dmitry Ilvokhin <d@ilvokhin.com> wrote:

>  static inline void zone_lock_init(struct zone *zone)
>  {
> @@ -12,26 +59,41 @@ static inline void zone_lock_init(struct zone *zone)
>  
>  #define zone_lock_irqsave(zone, flags)				\
>  do {								\
> +	bool success = true;					\
> +								\
> +	__zone_lock_trace_start_locking(zone);			\
>  	spin_lock_irqsave(&(zone)->_lock, flags);		\
> +	__zone_lock_trace_acquire_returned(zone, success);	\

Why the "success" variable and not just:

	__zone_lock_trace_acquire_returned(zone, true);

 ?


>  } while (0)
>  
>  #define zone_trylock_irqsave(zone, flags)			\
>  ({								\
> -	spin_trylock_irqsave(&(zone)->_lock, flags);		\
> +	bool success;						\
> +								\
> +	__zone_lock_trace_start_locking(zone);			\
> +	success = spin_trylock_irqsave(&(zone)->_lock, flags);	\
> +	__zone_lock_trace_acquire_returned(zone, success);	\
> +	success;						\
>  })
>  
>  static inline void zone_unlock_irqrestore(struct zone *zone, unsigned long flags)
>  {
> +	__zone_lock_trace_released(zone);
>  	spin_unlock_irqrestore(&zone->_lock, flags);
>  }
>  
>  static inline void zone_lock_irq(struct zone *zone)
>  {
> +	bool success = true;
> +
> +	__zone_lock_trace_start_locking(zone);
>  	spin_lock_irq(&zone->_lock);
> +	__zone_lock_trace_acquire_returned(zone, success);

Same here.

>  }
>  
>  static inline void zone_unlock_irq(struct zone *zone)
>  {
> +	__zone_lock_trace_released(zone);
>  	spin_unlock_irq(&zone->_lock);
>  }
>

-- Steve


