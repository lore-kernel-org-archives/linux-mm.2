Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9523AFF60F7
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:35:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A4146B008C; Tue, 31 Mar 2026 05:35:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 054926B0095; Tue, 31 Mar 2026 05:35:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E85CE6B0096; Tue, 31 Mar 2026 05:35:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D35D16B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:35:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 715FA140C5D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:35:30 +0000 (UTC)
X-FDA: 84605850420.04.435BBBB
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf27.hostedemail.com (Postfix) with ESMTP id A88AB4000A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:35:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WU0OlCFU;
	spf=pass (imf27.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774949728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lid4xA2I5RpvLuwKb/5kSWHVsAUfi8ob6hCwRrdpHiE=;
	b=pLYOlUQanJe1enLTueOrDOHpqCdoaITmm0oKlILda78Z3V5NAQ5oouu+nsOEnzzZttvFcv
	TsidiEx/TmAYjgjQj0u5Me5KgVshet7JzXZiMmSLus5C65YtwbsFpx2M4dAuS3K17uL6h6
	Qp2Dd1oeLI5IajI3qoARfGIVEW8MEvA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774949728; a=rsa-sha256;
	cv=none;
	b=rZuJJmsNFAy7Rai2HGi/TeiyZEWuMLfJfuYbB4WZPEaSy9PC6k1r65gRSazL4jcabSake4
	e+bY2nD2g7rn+OjpBX/cABQVe7SnaWL0jfndx2xq2ckkqZYd0OlCUgV7PNHlnm2BhpKaR/
	1+pOnInmMxgqQKPZhpr2GgvShNJqgfo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WU0OlCFU;
	spf=pass (imf27.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-59dea72099eso6731914e87.0
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 02:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774949727; x=1775554527; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Lid4xA2I5RpvLuwKb/5kSWHVsAUfi8ob6hCwRrdpHiE=;
        b=WU0OlCFUXC9gJm+34sv/MwaJCdvnBBnH4Fq2PQ4JPzYiVvDw0Pr1YslDiy0ePQ36Lc
         ViNFQ9caY9dzrTo+koN+LD6iY+GWmepVo2ejSfnQu/9hV0VqWsNGPNoKlp0e+RdBxKar
         bVHVeF6DiocmM++PmU2/ZgCNkkW2IDGTc1eX6oekWBRZd/KMRCosz88sv56Ta4OK9697
         lFjAGB7Mdlmx3vnj8hglOQ2mMlx0cTsWNc8BccEgDR0RPYS/8zzQ8na5tAWiOLccn79i
         qwk1VzahUm0tLrutqtR/2ApHNuB/6TlzCcSWvIhRWQzDvxjgNnjEuqa17G2aa512S6P+
         okoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774949727; x=1775554527;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lid4xA2I5RpvLuwKb/5kSWHVsAUfi8ob6hCwRrdpHiE=;
        b=Znnh/Vs/JUGwiQT6HpfGqgoUDxJZfGRA3/hP8CR7e9GKR/YymSshKx8UhIo8Odm3t0
         /9UfAy2urGnS/TluOJMwWJ/u5dBmS17g0Dpg6TjvIsGPuUb0g3rSviDmhhKS5vO1S7Ky
         mWUXrn8GWkF6HTBpcCYZNTL3O+Qs6f1D/v0kGTsfRNTeModRUgh50Xll1L6ukR/N8YmU
         DqOOynElEWwuAKzPcA4mOQ/sBpDmgLR/MphIc095VDmomCqQN7YDCZu+i7jRgT029zOy
         EVDjzt3fHjM/O6cb8LgSahK0IjsW91WSitFGc9vEg7VhW5a8Qv/sjyNBAGWski60gYgG
         +PEQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3VHuTzDN5bIMfQzxcVPFFqCx1HGSoWQHyw0T57S1AG4MqiG1D428ElePjR6pJNgEOmTkVDQd10w==@kvack.org
X-Gm-Message-State: AOJu0Yy1dI0nu6TYpNCKQqmveSBdikxS5xDPOxIRTNoYVasXus9WMGIk
	oKg3j9VIMjIUQV7AFfItwpN68MPhzurh/yi8BhVsajCFlVfFRP+zIKqy
X-Gm-Gg: ATEYQzwXiB+NUeOEfdu/NDT8xmFWYTBrLbrT4xKV59tNNzE/7XfjZeI1nPhawIOLSHa
	VKY4OOyPflXjochDV8Wr2w2kVNay4toyU3aDw42A+u/VBNzEV5pe+6DzExLVpxsqo09kuLAOZja
	d3Ar1sOjGV+DRuYTa30GdnASilwucwJH7BA1pqOZWqCMiCP9FNkYZsfm/CKKXDnQqDuv/u7IIxJ
	Xc8X7cXIMEuD8hWJiswzE0NZYuz8nyutrHM04SnWaIckv9JL+A8EEkQ1rPUCxyVzgGFmt/4snZv
	XnoPpOjJ6nJ1gj8mvYZTKpBFXTxWkxmdmSv4I17UkZShpVew2xEFpjZVuKAqstKT8SDtVl3zYvV
	8WMZdMdpGd+41ZFH9gvc5dlrX6CTETpCYbTHRTb5KRK4zxp77G3StXQlhLPdpU3Qfsm2RMUu9nn
	4=
X-Received: by 2002:a05:6512:3053:b0:5a2:b86c:f2d6 with SMTP id 2adb3069b0e04-5a2b86cf38emr1680912e87.11.1774949726405;
        Tue, 31 Mar 2026 02:35:26 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a2b1403c4esm2257320e87.26.2026.03.31.02.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 02:35:26 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 31 Mar 2026 11:35:24 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
	lirongqing <lirongqing@baidu.com>
Subject: Re: [PATCH v2] mm/vmalloc: Use dedicated unbound workqueue for vmap
 purge/drain
Message-ID: <acuVXBglDLnnspgL@milan>
References: <20260330175824.2777270-1-urezki@gmail.com>
 <20260330115618.62fb0d6bdf89cedd453035d0@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330115618.62fb0d6bdf89cedd453035d0@linux-foundation.org>
X-Rspamd-Queue-Id: A88AB4000A
X-Stat-Signature: 8ktsx7pgq4e61nfq3suwk8ckon6frz69
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774949728-862490
X-HE-Meta: U2FsdGVkX18MPGdLootgfLS5D61zOrkbramawABF+HwlNaIFuT59WcjUWTi6uuLs+R9+FxUNGkfca1EJ8HNCTplEk8wvkDX4pE+tDBm9mNP6mceuueBEEJ5Qub9q3Hu5wFmKNntFHyo3Lllr6kdxVOg6IaKUB6VkH+CeVTrIOP0F8q0B7LkRYvXhiC720Ed6mrG8rvHGxYlDu/QPfuFIiDB3YA6tIKHDIDVaa7/k1XlNPmwkd5WBZwscoavEhomTCzJLli0ikGi5eXjy65h9WjlvzN6G3ovrAibyJ+XyIy7ORkdkLK3G+GuXxTMcVZNO8+PkYxIer46qZ9BcbJIk5rC94/fY6vi/jFlyjU7ohqjntFPagZVeUo40kh/vMUtX3I21mBVLmSMD6WAHRjXzAIlwKtPDpAWhSmNOJbVLuPHSLHOSD8Xpr2sASTj1JAZIg3PbpawtH+xTLqtm7YdfkoQy+hFV2i5JV7GOPPkX3ATLWJ7V9Vk5arXNblWlPNA4xGL/Ndx5fA/+14dn/B0ZmAawFaXu9zL3ZyopabpleBhAIrBWz7UyZBhRxL1Mnrb7vdO55OKX/JsDaPtzSwHaJG5Fj/705WRVu/suIh7EtdRVqYK8COpu703xABat1D7PCfXhU/sP3jKY7hylLI+r7tSH9qCvWhSxLqFmuS6ak6RHY+o5s09zo1l8/qKSTVro61UI3bYhZnj/ybN0qKUYatxyoaijR1SanMIHDfJEZC+m4sh4u6GH51iDpErx0JCkArHLfvzN8/5gzI5M2rQZCQQr5OCChQS0PSXoKvZybTWn75pH1jwg3lZX6ssnX0XnlBDcJJfeLJQ6bh6OsngJzO6pDzBYJAtSvGc9b4mDj0fo9XBsLJUIvepodcS8+wXRrTmHzGe2iLuIAwSC0DpLsVQy5JSfw8ACmpHyZgoUi+aMXbVp4vmK3usjN1ENxUrkD+1kAPRz29DCrkMUody
 MptjTpvK
 3QreaS8K0F0XbA2auhjqiJkmcrN4aVuxv27wikKrhlQi1Vmc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 11:56:18AM -0700, Andrew Morton wrote:
> On Mon, 30 Mar 2026 19:58:24 +0200 "Uladzislau Rezki (Sony)" <urezki@gmail.com> wrote:
> 
> > The drain_vmap_area_work() function can take >10ms to complete
> > when there are many accumulated vmap areas in a system with a
> > high CPU count, causing workqueue watchdog warnings when run
> > via schedule_work():
> > 
> > [ 2069.796205] workqueue: drain_vmap_area_work hogged CPU for >10000us 4 times, consider switching to WQ_UNBOUND
> > [ 2192.823225] workqueue: drain_vmap_area_work hogged CPU for >10000us 5 times, consider switching to WQ_UNBOUND
> > 
> > Switch to a dedicated WQ_UNBOUND workqueue to allow the scheduler to
> > run this background task on any available CPU, improving responsiveness.
> > Use WQ_MEM_RECLAIM to ensure forward progress under memory pressure.
> > 
> > If queuing work to the dedicated workqueue is not possible(during
> > early boot), fall back to processing locally to avoid losing progress.
> > 
> > Also simplify purge helper scheduling by removing cpumask-based
> > iteration in favour to iterating directly over vmap nodes with
> > pending work.
> 
> Thanks, both.
> 
> > Cc: lirongqing <lirongqing@baidu.com>
> > Link: https://lore.kernel.org/all/20260319074307.2325-1-lirongqing@baidu.com/
> > Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> 
> We don't want to be scaring our users with kernel warnings.  Do you
> think a Fixes: or cc:stable are justified?
> 
Probably we can CC stable.

> And I wonder if that workqueue warning should be WARN_ON_ONCE.  That
> would mean that other, later call sites wouldn't get the report, but
> we'll still get to hear about those callsites from someone else.
> 
I can switch to ONCE version. Below code:

static int __init vmalloc_init_workqueue(void)
{
	struct workqueue_struct *wq;

	wq = alloc_workqueue("vmap_drain", WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
	WARN_ON(wq == NULL);
	WRITE_ONCE(drain_vmap_wq, wq);

	return 0;
}
early_initcall(vmalloc_init_workqueue);


implies to be called/initialized only once.

--
Uladzislau Rezki



