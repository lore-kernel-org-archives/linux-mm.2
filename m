Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01E2AEC01B6
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 09:44:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A0A56B0005; Mon, 23 Mar 2026 05:44:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0772C6B0089; Mon, 23 Mar 2026 05:44:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF6D26B008A; Mon, 23 Mar 2026 05:44:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E0F7B6B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:44:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 865AB1B8FD8
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:44:39 +0000 (UTC)
X-FDA: 84576843078.21.2F1C63F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 451AC40006
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:44:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DuoL+M4r;
	spf=pass (imf12.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774259077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2LcMB5gIX03eono8rt37+6BTZoTufylHEu17I/eh9tE=;
	b=gbgBa4yuku/iWYQTGjn+R6N358AV3NnK/W5ITDRtFKaYAd6IE99IS9lSjpGTjVxAr4QSCC
	PVKVxQcSGLFcWgMFclLFL8xocVMpmANA6vWG1cY26elrwS9gVpxXNSjrv4EXKsYRLyGxYe
	F1K9jC7sxjeuG0knltCp57Lum2X1HIE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774259077; a=rsa-sha256;
	cv=none;
	b=e4dKeZMLCo6ae58nLQhJulxoEoDpA9QsSVLcMUVUY8KQZVwl9j+Fn335l31z3jgDgWkG3j
	AIyHvVojjRu0vzg3ZoJ1wPStuExzEMcy6+rgP0y8EyYzvaog96VC2aducGVUPrdR9Q1jpg
	dMJG6HRlG2aW9HoGJNKqisJn0Xyv140=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DuoL+M4r;
	spf=pass (imf12.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774259076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2LcMB5gIX03eono8rt37+6BTZoTufylHEu17I/eh9tE=;
	b=DuoL+M4rpNnsY485WkmpPP/v4w4M4yYopCGHGIOGHmJ8aoeI0MmM7Dcz//PoltaF1dfELT
	0HDOHVfuIEaY2n3xzFCzsBlodCXr910MXE4lfK3f9nXwG4Mzo3oi+iPJexdXW8t9b0MVoc
	Povb/PZeoFxuF1N6SoOAYe0zezgJIis=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-466-wL5LjyVLPxicSGuyHh41hA-1; Mon, 23 Mar 2026 05:44:34 -0400
X-MC-Unique: wL5LjyVLPxicSGuyHh41hA-1
X-Mimecast-MFC-AGG-ID: wL5LjyVLPxicSGuyHh41hA_1774259074
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-829ad972df6so2557845b3a.3
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 02:44:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774259073; x=1774863873;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2LcMB5gIX03eono8rt37+6BTZoTufylHEu17I/eh9tE=;
        b=lGyxh8SuS3gnmEnBIOeutBPPJ68bQ1ms0OI5a1LtCZvjcqRc7nqXoAhugXuxC3IyEF
         ydQRQiAr8vbFEiA/aDwOdYizW399qeU3mch8pswByTZ2N39ewDzxbSpivEJs7qwCKWRa
         FP6SdM0cySZ+PZjrHB62N9plDILVVFUCvaapZGC1FVq1rAoVADMMNONsbJul/G4MPdBb
         CvOyn258A4gNcNAhJjkWhJv5IkCDPYeQpaUEarb28ZnxB7k42ofhDpOLKGVIYtIAMo7W
         8VSOjcNc8HrvdUOnRbPJOJd4smrho0kpMtHKinp+xjzYWNCw1SSqBMtZWkkdyiqeDP4G
         fXDA==
X-Forwarded-Encrypted: i=1; AJvYcCU5QSOZJvzehLyIVvblWpPtgv6ghBWfwdITk6wwHZzQSLJSjOa4YNjDjPkzo+m2E5rmDMrFS3kOQQ==@kvack.org
X-Gm-Message-State: AOJu0Yx0fKQ7Pvk7M9QqWe8xOQ0lwCw4LMACr8UIbqL50LtTgAs9aUgu
	exBS8ubgpH99hHEfk3PK3G04Y6bz/f4+ZsmGjD2cU3UVf77K2NNEbs3YHXTZhaHZFdXUNbx1eJA
	cT3AZWRepUMTF8oMD57qRtMa2vvapSNqU5EF7TQpz6Ctag3RY41rd
X-Gm-Gg: ATEYQzzcPg6+oiyMbdBnocq6RQ+Cz5LuPSg7ZhsKNYWutJkPNXbpsV3gBWwuznsINdz
	sAyOBHtuPzTJs6vQZW41HPbtXtDZURkvJal5aS0CJpAU8H/2QxFOBTSmH3/JFECILX1zciDSCu3
	ltu5pSj0wlTPpsPhSy1Kw3OsozbnZzo4uDdWpqWSihTMpDfi6g/hFZ5J+I0LvOsp+95ypFVSnAH
	sRLKtHaXQDUVyx+o9DUOgqtvjy0KGbOOw0frSzEf+/iso3sGO3TofE3n0k4IaLAgnnqYseFe2gq
	xsIu0xRlIzXjVSwWzQjxv/byXoGtDaK5BhR4fCF7QUmzl0RVaTz5ZbBdR/8dA8BuVYsbgF6avOZ
	+P361/4alpNu2HwCRmw==
X-Received: by 2002:a05:6a00:12e2:b0:82a:7dfd:9757 with SMTP id d2e1a72fcca58-82a8c2525d6mr10198862b3a.4.1774259073577;
        Mon, 23 Mar 2026 02:44:33 -0700 (PDT)
X-Received: by 2002:a05:6a00:12e2:b0:82a:7dfd:9757 with SMTP id d2e1a72fcca58-82a8c2525d6mr10198855b3a.4.1774259073192;
        Mon, 23 Mar 2026 02:44:33 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b0409c681sm10471814b3a.37.2026.03.23.02.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 02:44:32 -0700 (PDT)
Date: Mon, 23 Mar 2026 17:44:29 +0800
From: Li Wang <liwang@redhat.com>
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	James Houghton <jthoughton@google.com>,
	Sebastian Chlad <sebastianchlad@gmail.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>, Li Wang <liwan@redhat.com>
Subject: Re: [PATCH v2 7/7] selftests: memcg: Treat failure for zeroing sock
 in test_memcg_sock as XFAIL
Message-ID: <acELfUqXlKVWFcDT@redhat.com>
References: <20260320204241.1613861-1-longman@redhat.com>
 <20260320204241.1613861-8-longman@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20260320204241.1613861-8-longman@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: c0SqFEvCzhLFBTDE9oRNRGHYtnSIbMZEkY5ZfOvKzS8_1774259074
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: kex1mx45ir1edabqwxon3kt9omnseid9
X-Rspam-User: 
X-Rspamd-Queue-Id: 451AC40006
X-Rspamd-Server: rspam12
X-HE-Tag: 1774259077-78794
X-HE-Meta: U2FsdGVkX18sXEtGzJura6Oy9Xq4aGfm7x+agtLD+nrw1dy9Beir/WCr/5q6G253r3YWXUohG9hjaltb7G1IamMNPMdn24qF6npD+UXg88ZYGKdVAfx8909WDUSNeY/U26K3NASS8tvEWUCogB7HfhDd7J8NxPQ+VNJDxh49BGsC4nDx1Y66D38rwEcI5fyXKFmYiUI7xgGRGlZGhfpL0QhY6aYmQVUdGVzw1UKudzFcK51tJm+mt3m0/pOi7q5mq9JsVeN17DbuBmoU8tMqBb8WXcKi4RG8bXadjTiQzbObufG9ODuK6jmPpVurU9ati/8HsJDgmLAG+lhww8xFBPWacCxiRPxXFbjIpq1p1eZmRERcSjNWtShfqmFoL+Gn1qSOYl38QG8TS6dR3DUSnE9aOZZBqO+IAi4osxGXYAtf6lI97kwfhAOOwBd9LyN1ZcprjGuYXuS7wY9waBuTZDxM6DPShL+rsFl2Fw2NBYjrjECbW2icCsKTfb3HL1yfwY1ShKmO4WghTIDDsZv33sRbsTl7aNpGRAK7regzHSQ2PDkLpDen4H4cTm/mhhi2GTlTUv/8hRmFU+28gJczYropocOZBJJRvD7pCTAA02QowoVLqbtazrWnUGrm9gs6Y1JLnwx9S6LWiKkNVKSne7RaDzfS8Ng9vSsUCH6UkktZYlpgIfjoOAedIS0h/iAwUxvRZQLH/lQUc4uuocGUCr44AysZ+NqfApdqjxNucPYjyvQmeFVjF1ZnowZGtgOPewoSgRsyYzH87rPRY8Z08toSbHUGdYQ4R8MNdfAIhnA4wAemEhOmyOuPhLxx+B/hczPh8n4BJI/6jdftzQJjQUCIlIcTMsPcZ7voGIFZR1i0T9BaNYLMows297YVI7rTcMlFB+qHJN86O6iSCyGVYnongeGVNclSIYn9eED96+uUNu7u5uVsn2QF5GVUUdR7EEMaKXd20mHmrj9Hu2E
 qLSIYimU
 8YeQ2rOykIZ5jOi57SIoX4Jda4BKiE+54W6O47wg5SBh570K4ZvN9GovdMDr8QDDM7RQsYj6CPZ9Frepe21Ocatb/84n1ZjUcrhN6rOmiSGb++OqXSsD5HSU4/AVNsdcenKq3Fpwfh1pYdbbLhfMBr5hKs+GiOkJUWOybTIIsbbbouvSMJWu2eB0B7ACny9dQDAwLob3ks2n2v+bVCs+QsYnKKPwIszie0UsP1SWAYr6OqjwxXUsosODWDPCtiDwHkk7VgqZ8nR7HmLhrnmPRU6pPWn6k1dKXHixo8oN17894dCJpAtS666/MHpS0LlE7bb6XpMNpCmbAXEKOc0sqeuXlx2iF75z8L24V4IP9S/ig8kYdPo1Yv/VrqkEVU48t5rE8LVxOa2//O1kJRuV4SO41fCbxEWCPf/7r3fIwLqndHZ2Q1mGto1N5nNpkR3zpJdxRq/hAAATS/O2vqix4cEk4K56XyeIj8S8rei3bMKXTJWDI6tIeQ/uHkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 04:42:41PM -0400, Waiman Long wrote:
> Although there is supposed to be a periodic and asynchronous flush of
> stats every 2 seconds, the actual time lag between succesive runs can
> actually vary quite a bit. In fact, I have seen time lag of up to 10s
> of seconds in some cases.
> 
> At the end of test_memcg_sock, it waits up to 3 seconds for the
> "sock" attribute of memory.stat to go back down to 0. Obviously it
> may occasionally fail especially when the kernel has large page size
> (e.g. 64k). Treat this failure as an expected failure (XFAIL) to
> distinguish it from the other failure cases.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  tools/testing/selftests/cgroup/test_memcontrol.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
> index 5336be5ed2f5..af3e8fe4e50e 100644
> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
> @@ -1486,12 +1486,21 @@ static int test_memcg_sock(const char *root)
>  	 * Poll memory.stat for up to 3 seconds (~FLUSH_TIME plus some
>  	 * scheduling slack) and require that the "sock " counter
>  	 * eventually drops to zero.
> +	 *
> +	 * The actual run-to-run elapse time between consecutive run
> +	 * of asynchronous memcg rstat flush may varies quite a bit.
> +	 * So the 3 seconds wait time may not be enough for the "sock"
> +	 * counter to go down to 0. Treat it as a XFAIL instead of
> +	 * a FAIL.
>  	 */
>  	sock_post = cg_read_key_long_poll(memcg, "memory.stat", "sock ", 0,
>  					 MEMCG_SOCKSTAT_WAIT_RETRIES,
>  					 DEFAULT_WAIT_INTERVAL_US);
> -	if (sock_post)
> +	if (sock_post) {
> +		if (sock_post > 0)
> +			ret = KSFT_XFAIL;

XFAIL means "expected failure" and is intended for known kernel bugs or
unsupported features. A timing issue where the test simply doesn't wait
long enough probably not an expected failure, it's a test that needs a
longer timeout.

I'm wondering can we just enlarge the MEMCG_SOCKSTAT_WAIT_RETRIES value?
e.g. from 30 to 150


-- 
Regards,
Li Wang


