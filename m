Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1328FF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 16:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 275E26B0095; Thu, 30 Apr 2026 12:07:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24C7C6B0096; Thu, 30 Apr 2026 12:07:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18A076B0098; Thu, 30 Apr 2026 12:07:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 070F46B0095
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:07:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BA73212A0DC
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 15:32:47 +0000 (UTC)
X-FDA: 84715614774.11.F96EAA7
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9336120014
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 15:32:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Wp9HzLIi;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777563164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RAMMBWlxuC5VTMg7XRzXOnsHoZnowd4Y/GYGwSPMbqE=;
	b=NEfQ5OYn5hJjyVRhK3AiPuxUwWme3c0TDPCyxhh1C1F7JZap6avO2Vn9l84Af32Ss3BPqN
	ty1SZnLXvE0iJ4DWhkKQvV9ZUyqpI3B82B99h2Uf3sfQsMMd/tBuFITSc7DSD6h0zX1ZvO
	N07lnLZEmjMaDhZdS9ipIAbxUikmoHU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Wp9HzLIi;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777563164; a=rsa-sha256;
	cv=none;
	b=URB/G3uNESIV1BxR3hvljYjZscHhc2t9r9q7ccNAkfNg4GjT/GgTkpWxoTvT5hZ263iM6J
	YYie5SXf8UsevJbr9wDp3PAff7h25Buzb1lCr6lYNkOb2VGihzrim539OBIOGsRVnW7yu8
	QZZX8rfP3eCfRWJ1JhOirXVic9+eO0c=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-483487335c2so12235505e9.2
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777563162; x=1778167962; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RAMMBWlxuC5VTMg7XRzXOnsHoZnowd4Y/GYGwSPMbqE=;
        b=Wp9HzLIigx7BjQQEb2ptWIYK3hRS+0HikwmpE59xA2ZXlomHE0UIYI0GKMuAeXqHzD
         IWoXV6hGcucAZxRE6wYVBdu01FQBXrrUYNsfEbCuf9pOkDlnIB9xEPQIykfQ5Ut/OvEq
         MMKtgOM3MKE0y46iXPFHnEip8He8judIPU6eWPujI9zhr9GL2ZAuGUp+89ifgp3XoREP
         oSUYLufATCbFS9RkL91tcRya3oIof/+7N+4YmuGIonvuNEbE/xRxC5vC7nAFKU7gIetC
         pChq1YPbqQGnDgg1y0ik/FPrqQkyOlHwWFfliis/FBQQdmxpydqIi4UXfdrPSlDKbIVV
         6IvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777563162; x=1778167962;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RAMMBWlxuC5VTMg7XRzXOnsHoZnowd4Y/GYGwSPMbqE=;
        b=U08lwvKkXTUkLG6Srlvvc2R7hbMS8eQZbIGvT/gHpoQNTjUL/guRawVb7nI/33KaoA
         HhK5wAu3gm92lws0e4sHNu46bybtKwf33afpGcfsmfuo05fVxg8CYaQrE/2YfKbTYzNM
         JOid9r4kosm+eE4R0zhfvtKftRCoB5/OgFPcGKhmkPLAoDV8uvj7dZFYQSBvljyMoyuV
         q0IrJYQV7Cxw+czpVpAI8UJ/5NIeNLvekM4XjmgZyHLR0ZJkx9lUHncAxF8Uy+7D79te
         U2vpE9ONn4JGH2BcpzgcgkUiEfEuKvY78i6QJiQp4wKup5MPrLKWgPSXZBa9UbVsqk5v
         /ATg==
X-Forwarded-Encrypted: i=1; AFNElJ+JnbSdsQ16A5CRPltjJAU2tsBFQUxuRH9I5jk08D5pIXGfONhLBFLnUGl0X/EKGRVaV3/Q0dPYaA==@kvack.org
X-Gm-Message-State: AOJu0Yz3Z3b/bj08bn18LhiUFYBYCPYuegFg5U13CM0OnsNMHuqjVfKT
	aZK4VlyU+en7q82K1r/SGOlGskQ2/tifenXAiE9RnUgzYzAvABSMXLio7gsvBnngPeQ=
X-Gm-Gg: AeBDies+JM3RdRWEMlGru3VBk21Fu9FjYVCdG3i/PeXyQLCfDjKdJCgu/xfYcc5u9gm
	sZ239igHVZEGUmcrr+weyS7PG4AFaCOZpNONjvxY1J4O18G2vTmtWMCH9nzauZi+DTvd4t/rVB0
	oY2/Ox5tbSSVdFsVWc840j0mPOuDnX6UnmsGxepMP++qRUxEzsePMFdsTWUyiYp8Gf3O03QdlLs
	t9KyQlQJ5obdxYIDsj1OLjzS8gwuFs0zx+cWuuVcCwMP2WHwMilBw1Ecfxf5KgXuxW/uj9ahLHa
	4wasNB/nuHtpSzsFy95758nt/PREblHJiSkTB5HUjuw5OoUpRVmQzeavO0u95k8YopkKgpfE9qX
	lEcjddanGZfaqUVV2CUliLOdX4yaDkKnBleitWJI1mGcOGJyrU59WhEGNceZwTXcQp1Q8ikBpRb
	XzFYNAITO/uKY3vDu22nnQPphg07RD/qKUfd7LD0tQnWfvbTaghQjGYPpT5Q==
X-Received: by 2002:a05:600c:8b22:b0:486:fb0b:ad79 with SMTP id 5b1f17b1804b1-48a84524e1dmr57699945e9.20.1777563162217;
        Thu, 30 Apr 2026 08:32:42 -0700 (PDT)
Received: from localhost (109-81-16-145.rct.o2.cz. [109.81.16.145])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a81b99127sm70429935e9.0.2026.04.30.08.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 08:32:41 -0700 (PDT)
Date: Thu, 30 Apr 2026 17:32:40 +0200
From: Michal Hocko <mhocko@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, david@kernel.org, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [PATCH v2] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <afN2GBAjBSGlTgvA@tiehlicka>
References: <20260429211359.3829683-1-minchan@kernel.org>
 <20260430074305.9d3389ed71af040acfe222de@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260430074305.9d3389ed71af040acfe222de@linux-foundation.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9336120014
X-Rspam-User: 
X-Stat-Signature: rbschyohkmt3b179cu4zrp488i4w9cph
X-HE-Tag: 1777563163-150701
X-HE-Meta: U2FsdGVkX18RBfsOee7nIqwi/CAJOcOg9YMT/2DT/9QhP7yMkp1lhXzCPUV/UM33t/cwEw4DGPb1tA8JBQF6fRxn1ksS2b5e8T2KHbPzVJzQCZIICg57uVb4TaDRz3Ot5T27L1K3WkwGxP+jZg+7KYHLjxS26aZYBrIe4gH4lLcxsIAf9V+psTcvRw1pRQUhLNGRPwXLVBG+dw5U835WqG0FcJB2waSj8xi9tzu8bLLC/1AbaPHG4hERwQz7X8wcKXPGOTJ8ua4TzRryGc1BNVChMOH8EfU3D0QEhGKy0RzjClbXWiBLEPzElRWj6SXBHTnJjfbJshT0lGf0PQm/mUv/tt60/74ws0TLRNMR416zFNxcXjaOnII8Zw/bKXz25b4qQha9k/aRkLovoleNnW1h6dhUlP58D33udI3rw2Fo/5oQ8pGG1fUqmUaQ9JbiFlcddgn4WUUa9+7z7wLVyzMzFUmlzB/lm213iK5TW7zh62TzjsKeVZ/L2l9o3USu+DfYzKux+QDtQKuy9t4Pn1P4sV+g/YkKkyNTYQW9Wiqburu2S+oRvqsYg7B/3Rw8vdYLNsNo0qyLOx/ScmmFxs2qDMzic8BQvjQC9M2kUexhGg/3OQzZoDxs25/X1H0wir8e5e4jvMyUAog5nCeTeONukijfR4tFyERoJXbfrg6RigQrvm94b0CWKFyC9Mj9S/oiKk3qkGllH1qahdnaVD7EogFMJ/dFF2Jz5t3dqVTI8Fb9bfW+QgzdYXVOwalfC2pgqrSxzg09Aj+aUSwGIgwjYsCC61VkUyelx82uYlEVDlXVCpTnDq6ABaARjnnhe+ciLAAuKZUjxD39LGHoG0M2lHaWbnW8hL2eRyl+DfBMcdZ8GJKrkmI52oa7GGbzIQiTc1HiN17gfuWYgTDzL+mfo/lQUfM+0OefcMOp+UecBlp775Ga6quyo8R/vuSrAX0/KEVPp8sRnZoahot
 n+biRbUy
 GVwEdnatc04Unf2C5F3XAdVvac25P4BI8V/tLUMoJSf0t1eK/rackjoFqdx0rToxAmv8XIbfO8jCHsyXzaJhyQrDS0AZI7L6NYL7/QwSZLsaFKBHXOGz1/xnx4OeYJcO5i9GmXExjejQ7SrWbzVeENb8k0ryZVtdThOgWp+XAkjxJEuFlVRhG847U0FPyjPifgJsS1gWgRI6Xw2UlO1CMI/dQJuGRFL0NlTWIjwnNIBzATHRFUjGLk7w0dBkxryNBXfYf+k42f8BHRf6GQ2U3RgYZmNo82DLra5IFC/0PW/uhOoCiaN8fctBjwm5L1Jn/JY1eA+UWcnWEUHjswU/JrWkrDgwPJa82vGsRX9F5MshIq1p35JiqDEwIw3+J3zQg/czQoi2XN7QHfmQrZlQy9ujK5Q+92NP70ghmpxybInY3YO8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 30-04-26 07:43:05, Andrew Morton wrote:
> On Wed, 29 Apr 2026 14:13:59 -0700 Minchan Kim <minchan@kernel.org> wrote:
> 
> > Currently, process_mrelease() requires userspace to send a SIGKILL signal
> > prior to invocation. This separation introduces a scheduling race window
> > where the victim task may receive the signal and enter the exit path
> > before the reaper can invoke process_mrelease().
> 
> Does process_mrelease() have a manpage?  My googling was a fail.

It does. Very well hidden in 884a7e5964e06
-- 
Michal Hocko
SUSE Labs

