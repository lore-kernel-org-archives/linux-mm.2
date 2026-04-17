Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F5D1F8E4B1
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 07:04:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D8EA6B00A0; Fri, 17 Apr 2026 03:04:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58AA56B00A1; Fri, 17 Apr 2026 03:04:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49FF66B00A2; Fri, 17 Apr 2026 03:04:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 39CE36B00A0
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 03:04:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DFEB38C66B
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 07:04:36 +0000 (UTC)
X-FDA: 84667159752.28.EB04665
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id CE85914000B
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 07:04:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=IiYmxiy1;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776409475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wFOEVE0hfa2qcWI+N130w2OV805O19ENrrl1tfur9Jw=;
	b=Pj6s7A2CRXaOtNDs0ci01oJbCCqH81oHJHcZmGZpRxCQpdmrE4Eky2QZumbgxKpmnem64M
	aJgvzFEPvZODM7OqxtwcBvHY4fCqT8kHa9XPK+TOJWyNivTl11OM69KkdvpvAIiTYtbX4w
	ICVFOB/7HJ0SovI3cNZkhl1hPhXPFnI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=IiYmxiy1;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776409475; a=rsa-sha256;
	cv=none;
	b=4mQAJhZaDtpn24kWmr1M0DFYVfH8eTfZzh79mgDEozCJ2SX7XO56UJeND+oXrwvN5LhPjs
	EDxx5A3tRiAaubAbGphIsuqxfvd9VUPgVCBvysUVjvxOldgU9MBxoK9v3MkuaZlmngriMw
	3/xjCeoLB4HJSKz6g8jSMIjvtiL0XNw=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-488b0046078so2946095e9.1
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 00:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776409473; x=1777014273; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wFOEVE0hfa2qcWI+N130w2OV805O19ENrrl1tfur9Jw=;
        b=IiYmxiy11V2FVhAugEqRXzPVCltKUtkTBhY9MZ2IgAeLoBH/2OUDy+hZSRn83HgPO9
         CHh9rIrGgXjZCKpVXaVBmjeSr1AoANJOmBkF0gcpeWH+X6mHhewWL04Zea6TFFL9Ok57
         5AaPTscbO44z9F6iT6b0xW6DFxEiVBmx/DjtUbb7g9YZwStcPlkfk/VuXh41OhvIuFj/
         qG9oQxCCVMNN31kyyaPFMa1YvPpkZ51KAtSLGcDrYmG/B7AYX9aAnmPk3oinEom+0thW
         n3taVGLdrOukG7iJM5dFYNUklKfh7CZbsLbj2SQnRw0oxjBj3stePxgzAst2QtkzBqwe
         QodQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776409473; x=1777014273;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wFOEVE0hfa2qcWI+N130w2OV805O19ENrrl1tfur9Jw=;
        b=LktVi1cvrsfQjUMxgq3n+IyuyM1a2rrZZoaN3DclW5V7ZViQxDBNttGF58WND7Pgf1
         Xq+2NKOr3U4ccT8d6n7ywRo6r1cVYele8+/1yfZqp8cuqsvP+Vx4BXhWVcgyHERN8Qac
         082p6FoEUUp29A76Yo1tTLaOx6QISKPwCal0oRfMHV0fxa5O/mxYgI4y9NKwRkOWW4Tm
         tOjhp3xmVdJp1Uj+ERZVc+tbUKhPezbiMRxv3z46pingXO8kLn8SF7E8AkIU/ehAWObk
         5b3Jlg9SH1FiZ/5Fm9qzBFosM2egQHV+dpoq2Nu+VswkbMLY9lfJ1D0dlNMzJDIrBBcS
         7meQ==
X-Forwarded-Encrypted: i=1; AFNElJ9/wIJrPFFADfkVxaw/VCewZ7uKXCq7EdxD7mXXdzcVbaH2Nxe0ZOhDW7Hh16WlgEv6nt1JhIzfaw==@kvack.org
X-Gm-Message-State: AOJu0Yz340DJ3wlY3BkPXIXvlkSDbR0uNZOVsA5oJ8yog9ybHLtnHGhz
	4dtIdiAWFcrHbEvBNMV8VUVjSBdT+RYXH848RzoVq3weaN0EMmgLkOETupz7URAvI0Y=
X-Gm-Gg: AeBDiesI/SkDlhFw80LnP1WuWZSLxgfFG4EtRPV2uXW/QWcYLGw34DsPNbCNzYJMxhV
	m0GfEBJT01hU3Ttg3rV0Q8ACXJ3GjUvrtatFZ1VvwjCz3ELnNSlx8mWeN5ygMbtQNZeFO9V8xdR
	mX5VQ4CASVYm+wGMHWI55krLoLcNlFIG9gq/BrKHk+sc0swRylz9aHztcAdOCdNc7byXEVO5uuB
	IVCQT52vVqNXxkbzm8oSo+u/7f12tYww6ESGHjOU5rXRGhF5hPdNXP+EMfYvmEx9miJIALeVpjV
	SjQa6+So1rcu8vCS4hUFzqCvullAYDHYicw3KY8mr4pMJSshA7vXGh9Ce1+Gm4BcHEUWLNMpSDs
	RHQv/tcqeaO1khjNPqhDR4KD0f9OgmlZ7L8GcK5suG0O4MKWLhH8wXjksQZ08AKY9IsfW64oq2K
	twsanpnHR7an18PhYwRMXX1c8S66HWasybpVfHaqaoARuV8b40IKPwEysG1Q==
X-Received: by 2002:a05:600c:4515:b0:488:a4d6:69ad with SMTP id 5b1f17b1804b1-488fb790b84mr21885355e9.27.1776409473089;
        Fri, 17 Apr 2026 00:04:33 -0700 (PDT)
Received: from localhost (109-81-20-115.rct.o2.cz. [109.81.20.115])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb762f56sm10333105e9.15.2026.04.17.00.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 00:04:32 -0700 (PDT)
Date: Fri, 17 Apr 2026 09:04:31 +0200
From: Michal Hocko <mhocko@suse.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, akpm@linux-foundation.org,
	david@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	surenb@google.com, timmurray@google.com
Subject: Re: [RFC 3/3] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <aeHbf7joGitRz7rB@tiehlicka>
References: <20260413223948.556351-1-minchan@kernel.org>
 <20260413223948.556351-4-minchan@kernel.org>
 <20260416-planktont-abwinken-b9499483b939@brauner>
 <aeHTcXfCyCED4WSl@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeHTcXfCyCED4WSl@google.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CE85914000B
X-Stat-Signature: qqt8gk9o8ai3hf6wrqd1dtai9tw1dq45
X-Rspam-User: 
X-HE-Tag: 1776409474-530363
X-HE-Meta: U2FsdGVkX1/JaMrefQepYP4X/W/iUB+4Rc9QjBNibtB2FkcrXiBas9v9TdDLuerdI3voO9/aE6pFl9y69FnMvfLxC/OMnOr2sQ63ZdNkuYEDZa1WCgW+0F1KeGnU+F/y0WVmeeFAOR2+77zu/QNgBgzb8uBJQVdeHn/DCmxm6cvIkhRubjnhj5hdEXZjfIrwaDY8AwRnma3FPOQ9irocFxwlR1QCVPrqCzLu/FwiyYJoBlOm+zKZf12xCxKlXWnP6fjosbvDdX/f9UUTgx/MGsu41FndgBFUTt32GE4Bo1hHLHel6IeOHBpeZpRyAbL35pj0E0FX7pOA3mk/e1MXWKtuy7tAB4mnGWYtm0W8S9VGTmtkKs7ZK72pa1uf9lyMETihrUWnSROh8rSbcz6QyzYs2qDsbVO4FeCU//XI0AaAjY93d8FAcAtkVn/McX9rbd/GFhmc3th8VnUdsy2xXdXB14jiSugGmDoh0PmEgfkdeAIy8UOxbkpZo6DFoClABnR2L2HzHlpbIkknQmeQ5D6yknTkoLsff7Uq8X7RW0jArJraip3Gqarboc0fEA8LshBevPa1NwcKrIf9yybnK9FqkyOqJy379VZfYO8EdIdkP3gY9rYnsuM6yRwFu7IuZ+LbY8tKXsxNaq0PKA2aqz1kKHeOGKnEYgB2sRIbDs3NVdg7xZfI9WBKGUg3oCRvIwtJDqPjIqtJsVw7v5IPutoHs5F9i0hVZnupVvuGk3MjE2pUtUXAtw24lkhjivd5tiCper6R0Xw7/M0SBIZ4a3GO+PZuq1wBVnS8KNBAnC1hTnbwbi/2jyMb78+RGCeIucD2EUt59uZJGI2upAMzLGuDrWco02HGUFWnOZQ2V2Yhh8cU0j8PslDAYVyt6F/IqTX38M/wnfnc6z0AbwpI40DLajXJCrrSm2qHqlUvTjfnvT1Y4xxuwjDhLS6tzeFra/stUrRuAIWajl5guC/
 nCs3J3Sz
 ukXz0/3KxeyPjZHitWZofSNBCQdEMysJLmYvn3lhBnHpwn5AZsAbsPV3LHgtVug+lm2UE3T8BCmXtZP3qjw8DplYDyGyOlPRV+2IVF1T40V1k6RMyGXsBjAQKxLLxlGONc7GPM7Pv0AUaIWff3iAV71SXifxpbRfBJ7zo6dv0Z8xFiQLc0HyKBDzKm0WFWtwyUrjVQyqZo4FdfSu9lU3VrA0jY3e7w3J/XtFXIiWplY4elhKnnBX75SOsVb4pSGUaGF3kqdys58IQUZNhXp6QjTa8ZfQxEyQH/S5XHCuJwbiMQM6aboOvme2bAQtyS12N4dPixAOPkNtvx5XQyDslZ/VyUgqZOHUM11UAwnWxUeuN0Xkl9iyHqnaMqlr8qBkV4Vn2FPliwFknbG5wGCrFq1H7BJybBHtqqXbfWFJogFzIcTY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 16-04-26 23:30:09, Minchan Kim wrote:
> If I send the SIGKILL first to satisfy the process_mrelease() requirement,
> we immediately run into the scheduling race condition where the victim can
> enter the exit path before the reaper can set the flag.

Why don't you just grab the mm before you send the signal and then continue
with reaping? You just want to avoid a race where the victim manages to
process fatal signal, start its exit path and mrelease path losing that
race so you rely on the exit path, right?
-- 
Michal Hocko
SUSE Labs

