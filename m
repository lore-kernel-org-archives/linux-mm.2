Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11C66CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 07:25:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B3228E000F; Mon,  1 Sep 2025 03:25:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68AED8E0003; Mon,  1 Sep 2025 03:25:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A09E8E000F; Mon,  1 Sep 2025 03:25:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 455AB8E0003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 03:25:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DF3F45AD14
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:25:27 +0000 (UTC)
X-FDA: 83839845894.20.F8AAEC4
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf03.hostedemail.com (Postfix) with ESMTP id E86E22000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:25:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XdeYGEbi;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756711526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NsD+lKisfCr+EvsMgdQlQ9bYE75VHiYAu6VA9km9Iao=;
	b=iBF5SdkfWRzAFxmw3IBZnUgGeBAnKOXzjdM45Y4UC1Nzl6BlUpLsWTRLXz/aWPNcgdtTzw
	bJieH7Vi73AEZJO2JPE6jxdHIJ6Fee6gG6i7H1Kt88kZMczVoRndMKBbaFVdV9EurKUAxX
	jxZzMQWpvzHyNsVTvpJh7mYryQSKfoA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756711526; a=rsa-sha256;
	cv=none;
	b=4PWDqW1m3W44g6S/XDDgCwPNlL42HDR2mGTKVC/9LbJsDRpwALekMQvFv4c9ZBi0gK/AG2
	Z3oVr21sQELOVqGZPArQGuox5h0i0MBOBEDPUGaebabpAnzI/OSBtwpf+HHEGf7eVG1stq
	NPX4Kewl1mMQXRcH1fq0fKcDqgLozHo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XdeYGEbi;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3d19699240dso1243960f8f.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 00:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756711524; x=1757316324; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NsD+lKisfCr+EvsMgdQlQ9bYE75VHiYAu6VA9km9Iao=;
        b=XdeYGEbiboCi6xzOdVMrvHHLRvt61gFsYse8DbWJ5+8q3QTm1gXy7gsMdmLrexGCGP
         Um+wyTwfdgcAlPQK7szdIDwaG18vSaX2BJMp1RWMBj+WGbS3wAE/ikNQHsdoFdkIRnom
         aevqopPKhLBwd6H4Iz8WmI33V1lj9ySuuZftkeJs2SMFxBceDe3cjLh+RyTteIujo+kh
         65Mh62Qov5R2iaI2kPTO/VPyMjB7HZx7Sikf0pC0p50C3wRMKDK9I3u18W7d8xxCQxqN
         CtP105S7V2yJOuymO9jKRNCMzo5xMGhP3b0sZNJQdUPdlMA0hjvyMn19D8suaVuDL1o+
         hC5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756711524; x=1757316324;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NsD+lKisfCr+EvsMgdQlQ9bYE75VHiYAu6VA9km9Iao=;
        b=hxV8VXwHVD2KQfLxyPBSBK8uxwC446gA0i4HGYc5iSjPgEPD1/BtJGKtsgrYgg+Og3
         sgDUztSEZ+MDBBkNc/W/THvFRfHjB4yuvCK8N8v3DSH8DVwy/tGT6SzzLyxHbnyQQvze
         nOPLLdWu2/XGHwRXGKgr4N+bSQYL6IgHCejkBe+hxgGcMmsrMn7mKl4x+lqFMcpjbcLm
         2mSaHRiFIqcKRXWtmj4ibzRtYtLlnap3GJ0VqRSXKFYCU9y0X5qt6RTgJw/1jEUnnmAV
         eIK+vdPLqcYQkIigFmJ8E8Ro70pHg1ZVqTLsS3UNpdBxGPEGqQJT03wKmmuIw/47FNKa
         dD4A==
X-Forwarded-Encrypted: i=1; AJvYcCUl8kY5Ma9ROwvHsQHyv0GcQSxeIYZPSgZeVmlBE9IjKEkkkADHDMl4UEBqxLmzUWfil8V0ceSC7Q==@kvack.org
X-Gm-Message-State: AOJu0YyG9CQMauFzntt3vCeq+xzBeZzApabvt1GTuBxIQPlaL7tPpzea
	c04fZYV07sLPlXsDeDoeCzz1L+A/iqe7xGkMfGYm6GEc+hHr5opbr7UX4cQIaJeKe0d9PzrMe0Q
	HRzTu
X-Gm-Gg: ASbGncsOaPANtxZRMFfNB0xdLPkgAa9uiYKXpMeKbJ7hP2XQxeu5VGUmPnhvcdbMShu
	ej5Jn2+jIdgEFRpr/1boVc2gLHImLJvnM8UamEOd7SitKdjZLdmVqdqLMrVlhYHv3CRjoUVZSEa
	r1+CU1O5SK45hZ2tsRTv1pYULtGe02fBZtLBOQ0tbW9LvRb7aPpFFzk8oHPwA6YJFUTWfD4zWLt
	Ip16FC91lAmsmdBcrbGNIYPQX00jxckdX6tYG4wa+BYO/WKL0lVsQRCZGr4KkKhk+KWd8O7oVvI
	ArW/S6gMDAGUMGxCfMlnnoqrn5hpph27Kiiicd/cbFKZLeEnJBYW7TnmcTMYrHW1zhy35dyVtwy
	N8wfurhk6aAmCePCn/os7q0E0xtpLF4mYBZwpvfW3dGBb7NrC4EXyRYNJ
X-Google-Smtp-Source: AGHT+IEVKsTduRpps36EMANEZSQFs4JECFp/5VO74627zg25yzawH8D3jvfC4CEKLLIvyDxZ2JF5XQ==
X-Received: by 2002:a05:6000:430b:b0:3c2:d7f0:9c4e with SMTP id ffacd0b85a97d-3d1afe48fa0mr5451319f8f.8.1756711524239;
        Mon, 01 Sep 2025 00:25:24 -0700 (PDT)
Received: from localhost (109-81-86-254.rct.o2.cz. [109.81.86.254])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b7e7ef7cfsm144073115e9.6.2025.09.01.00.25.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 00:25:23 -0700 (PDT)
Date: Mon, 1 Sep 2025 09:25:23 +0200
From: Michal Hocko <mhocko@suse.com>
To: zhongjinji <zhongjinji@honor.com>
Cc: rientjes@google.com, shakeel.butt@linux.dev, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, liam.howlett@oracle.com,
	lorenzo.stoakes@oracle.com, surenb@google.com, liulu.liu@honor.com,
	feng.han@honor.com, tianxiaobin@honor.com, fengbaopeng@honor.com
Subject: Re: [PATCH v6 1/2] mm/oom_kill: Do not delay oom reaper when the
 victim is frozen
Message-ID: <aLVKYz6C5bXYG1v3@tiehlicka>
References: <20250829065550.29571-1-zhongjinji@honor.com>
 <20250829065550.29571-2-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829065550.29571-2-zhongjinji@honor.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E86E22000B
X-Stat-Signature: hxsdeaok57ksyyppurruhks839yjz89w
X-HE-Tag: 1756711525-597880
X-HE-Meta: U2FsdGVkX1/Bc+wbiJ6e1uIU1Kh8ZbwPDg6D8Yoa+ldWknMayRuTOhtq4aH0hAc+IuJUpaCkLxh+VF//tK9O9iFR+U7pkMRfKqXEASaNDcmHb41sK4aVhvXpocU/JU/QjIDwsDxrZugbfS0YR5i2NvTCR8Gysd7AWj1t6/2P6qkBihEs16XpQqryuKd4+Kjf3tKZeYVF3aV2M399MAIdOknDIL74ZVsOsP2ayJ3lZRdbUXxWfXmb3Z+1Sv5CyQkLeIGW2kwdP8UbJV9uqjaDxvudR03sd4iU1BqaH5rDvG1yV1JVePN15dC8T1/+0/0R6fz0KBClAhcUL6I04yU2ohF03hhkGQQazx8uuPelADbIALcCkBbI+LvSjjE2l/6UBujYlgPrOBKyp2KYEeviFoefhIXyvRjD7PHVE2NvXWWFCE4G69HJtMSS+HQPQXn7PwbmpK1h353cFXlQRmW1eBDCy250aHdrZLfwR/zeTR23/PLd1nceceaHxOA1Cr6lmSwfFeMzs9JNmoTbGLZca3V9Ab7IzPkZW4ygZIwfnuCLluPKS4ICDVj/LAiKD0b3pkb65ghWiOKDt701SWllOt5+IgC+6+kwmlHdst/DMJEdWjhL9ffgqhSwvhoHyleqHuAyQeXOJ/u9L5z4QdKp1darsKmrCsH7ccavqcUfkjaxxcjwxnYGGi7ff7jQum1tSoWtt/tkRU4sNgoH+HVFDVHMfQZkoulC618PEEXZXk+ERYapnNxiCIFY4NER0SDHJnkbUMzYqKsGvaOBZljoLdVW/Sgl+Nn5slFnSuLwbeWt2zhRi/cy0nVdzN8lX3D4wg4brOPrK/GW4J4Ux+9Hi6yL6TBKiHgU1+HdqL3X8G+OTohlEX9Z/Nw6wPTeDWFoFRajaz6wCVb0HWU0FRQLomB+Z+F15QnC20fLd/b66ynNwsphpfiQjeEIaWlipjwrHZheuXesrSCzhYAyKyc
 GdoT4gzW
 OHGgR6UP8eDjmTw2+dRYQCinBeJZirQbQ7UihL1p3Udo6IOn+Y/m/k1RXXVxx2AhNHS3SSvFF8XUWN8WHoc1Khr5Wj/xxkPP208sotMi29tRl02kqfYXnxcJSW01rPrRmPpabdSnvU3wIfoGN2oqJpu8wD1Qycy8Qp5n3AOIdWhvoU1lLb2ZseXoGvr+UA9766uICAOflzGaXdsBlbcRrQCNyXCg9XGI2GDkCxCTE+Sjjn1L7vaFH1xsh5X7sqWECEDgEDjNgfm2Xd/CLmntiBXtyH+ILAOSB/7yRCRcYizICD94YVxucr2BZHdzQNgjAPXeMfeUhXLkoalD+WsToXaXPzD8rkigFJeGro+pjD8iDpB2pjIT1dvIT9Ssk6Ha2bMDdMmL3SqS8FpU5qy9DnE85Zci/cEWaThtmq/8LEq2RWcyHr5FnxQAR19aE+eku345oGrr22Kv/g9qqm1JUJvp941hcMpFpCtELGl1w8124t7ggB5tN3t7j617JT+OBkP6hZxgFjx8kO3h6+6omyuMiWJa+770ZNkdmmoKf5+5LtHdsU38M9/YcCQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 29-08-25 14:55:49, zhongjinji wrote:
> The oom reaper is a mechanism to guarantee a forward process during OOM
> situation when the oom victim cannot terminate on its own (e.g. being
> blocked in uninterruptible state or frozen by cgroup freezer). In order
> to give the victim some time to terminate properly the oom reaper is
> delayed in its invocation. This is particularly beneficial when the oom
> victim is holding robust futex resources as the anonymous memory tear
> down can break those. [1]
> 
> On the other hand deliberately frozen tasks by the freezer cgroup will
> not wake up until they are thawed in the userspace and delay is
> effectively pointless. Therefore opt out from the delay for cgroup
> frozen oom victims.
> 
> Reference:
> [1] https://lore.kernel.org/all/20220414144042.677008-1-npache@redhat.com/T/#u
> 
> Signed-off-by: zhongjinji <zhongjinji@honor.com>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks

> ---
>  mm/oom_kill.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 25923cfec9c6..a5e9074896a1 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -700,7 +700,14 @@ static void queue_oom_reaper(struct task_struct *tsk)
>  
>  	get_task_struct(tsk);
>  	timer_setup(&tsk->oom_reaper_timer, wake_oom_reaper, 0);
> -	tsk->oom_reaper_timer.expires = jiffies + OOM_REAPER_DELAY;
> +	tsk->oom_reaper_timer.expires = jiffies;
> +
> +	/*
> +	 * If the task is frozen by the cgroup freezer, the delay is unnecessary
> +	 * because it cannot exit until thawed. Skip the delay for frozen victims.
> +	 */
> +	if (!frozen(tsk))
> +		tsk->oom_reaper_timer.expires += OOM_REAPER_DELAY;
>  	add_timer(&tsk->oom_reaper_timer);
>  }
>  
> -- 
> 2.17.1

-- 
Michal Hocko
SUSE Labs

