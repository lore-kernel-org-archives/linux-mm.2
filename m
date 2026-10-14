Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FB92CC6B27
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 07:50:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39F506B0088; Wed, 14 Oct 2026 03:50:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 350C66B008A; Wed, 14 Oct 2026 03:50:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 242686B008C; Wed, 14 Oct 2026 03:50:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E660A6B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:50:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 727D2A7EC3
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:50:36 +0000 (UTC)
X-FDA: 85320459672.09.B7A4AE0
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6FCB24000A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:50:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=f0UrwZ59;
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791964234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EtTypnWxP6M9B1xrfyLNoNvejjXvkriIpfOMkAgmYRA=;
	b=BYm1uPfD1tLVVc4AgBYFzTbxXWqgcZbRs24ACbU5Cf5VnjwlZ3Dzxodqjpl5zw3Je4gYM+
	ZTX5Ed+jMn5aBupKEiRzej3NiNIc71V06/fuqkeRZoyEW45bO54aM82WqSrPr4lLWqtLy/
	WsRqFXgXvj2BCkvrGGfCKI9MUQopYk0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791964234;
	b=oftSrkZf9LrNj4AbFxf+trcGscp5PjrUFv/DltEgjPeigyK4MENso807QYsueAp8FFjGz0
	RABpm1cSWzsw5w18PXXFOHAFH3r63tcZxGw6cx3Vslr+Br5UaX7f0KOHhO5H0IveK5OWq5
	AYVk9GMuqKS0obELLb8wGKl5DyUUAKM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=f0UrwZ59;
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48c14a06c95so2943766f8f.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 00:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791964233; x=1792569033; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EtTypnWxP6M9B1xrfyLNoNvejjXvkriIpfOMkAgmYRA=;
        b=f0UrwZ59YmfyMHi6/iyUby2IKK5lmOZ8ZfSe+sJvUcxgrIcMd23aI03/rUkOR8Y57e
         D7rMSV1Rs2IVrCsu4gD1uQ9jBwbT6qpxetPIE6Yew2hTmqYTMhNd0wo5bkl/TfMxFYr+
         qIKDdJL0MNIMN4PG2sWEslFcPYmRMaWl8FRQgsqGMNoGe9ig6kZnnrebA8kDaQKbUvEJ
         TiZfVTmGQikiLz3W7plkTOUVVK36JmvDHkUq4CblxhPE4WMWP3jBW5dTp0C3QPFSzgMK
         HraMNLzGh9MgbL49H3q6gBGUIz/w3B2womzI7StsHlY6LOuRHK+HDiiyhCaptj+PCZdR
         IV3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791964233; x=1792569033;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EtTypnWxP6M9B1xrfyLNoNvejjXvkriIpfOMkAgmYRA=;
        b=QIQqap2pKpzWsNMrDy01f9DyMQNxWiuvEsuNmtLCyzTpcbZO6+nwYc5qGGcPKYpkA9
         aOOT81B/9FPci/hLrnNE+ijh2VxYVZDJCEAk02faQfsKNPpe65TyMfpbpKKwnCiN/qv/
         hkuwBqqdDvRp8a8Rrv9x8xwz2WiPdvIZgAPTRQ6dpfjsOaXVZGeUUPlFaBV0cEM0PDhQ
         miqCpc71ns6x5DfW1Rs6zFRUEVv4iRxin5gR4oCkwvo33kN36FdH6cg+O9GsSc5XCscW
         3vNxr/xbe8c3hy4eAmpPn6ZtQa0L1/0cdk3/IRoZQknJuGsgzPR/b36o5vLBiyUhnmaH
         udIQ==
X-Forwarded-Encrypted: i=1; AKwUvBwN2BtSsDUjwMdOVi5cEbnMnZArskoHNlLGgy8A0Vk7+g7S66YRiUP41ESgWc3CMBh4LeGe6XYF7A==@kvack.org
X-Gm-Message-State: AFq9FYJjzFmhBLbwwSM+aObm1KsS1eQ+0cQ0QnCY2DiZ7qVLkTYTH0Ii
	R+OqKkLf9FPVAlaQR640sbugpsooTuefhu6CFj0KOit7xhoFdW/e6Ze8Cr9yjPYkrBw=
X-Gm-Gg: AYBFou3cl55P4n9UI0bPrIw18lSfTb1TdRW1GVqEDSgcwgiraGzg6F635+N3i25Sxxu
	obx+A5YO2I6gMIk+Dm/9vjXLkpfk3i7bLILAvaD0UH0ltzzH0FtIQK4KAp7M1FvgHyuRLllHOB4
	nFXd6+e8P9PK1iiOyKn7FAiL+Feg5KSf0+VCTRUI1HAN8yezEGSOlsdlBGSBEBbplCVgMrCsDcb
	V98X8PDAj8ykxusWTjQgmXefBfep68UYQcNDW6Z4wuVjQX91y8tVF8y00/QqnU7zRkKV4zcxlN0
	SDoUcX31lgnF5PS7ET/HVOMzhAPCv/cfgY8Ru8jr3+03Jc/RPnXkg7SkXy8514EIdGcSrkqK4Z0
	o+ZqoNNsW3H3V1izuAu56Y7GoSo6p0Q5etC+Y1mQG29/eCuRyeVcmrHN2VOMB04EkhKe7VWCDNY
	B4oIoGao56kKN0c+74eNs9yZ44S52ahnBaA+6sa3oU+rjqj8Q32BzpGYa4VZ7l2pIa8iHhneuA9
	2HZ8Gisf04u
X-Received: by 2002:a05:6000:4553:b0:48c:4658:602b with SMTP id ffacd0b85a97d-48dbaadd05emr18566177f8f.10.1791964232830;
        Wed, 14 Oct 2026 00:50:32 -0700 (PDT)
Received: from localhost (109-81-25-183.rct.o2.cz. [109.81.25.183])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0ac35dfsm10313855f8f.33.2026.10.14.00.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 00:50:31 -0700 (PDT)
Date: Wed, 14 Oct 2026 09:50:30 +0200
From: Michal Hocko <mhocko@suse.com>
To: BouziguesAlexis@johndeere.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: nommu: set MMF_OOM_SKIP in exit_mmap()
Message-ID: <as80Rpm-VHhP14aK@tiehlicka>
References: <20261013-fix-nommu-exit-mmap-oom-skip-v1-1-cb957cdbfcc3@JohnDeere.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013-fix-nommu-exit-mmap-oom-skip-v1-1-cb957cdbfcc3@JohnDeere.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6FCB24000A
X-Rspam-User: 
X-Stat-Signature: s9xuudu4pqoown6g69c5c3bidbptoebn
X-HE-Tag: 1791964234-311326
X-HE-Meta: U2FsdGVkX18v5EbKMO3WqDlSpTxWCc8fmdmGtufJ5mtXO/Opdh3/ZI0gviE94FTSGlnZhnhz73QcvnTs2kR7RdGN+IOBRrEdmOKk550+61nOODG5QlOsZnfSMUWEDGY67Dig2BZWqomDuk87dVdg0C2I2buk2iISOATG00I/m6pm4sQ3udTTIo/ZfLPvzQYJqxZAqEbJtBhaJCeCataqS3lEkCfnC+zDZdHkEHP8kdKBrNrOAcPBRKYs2tGzP7/CGOd0dHlQmwuQf2/eajP7BhPSCZBEvFJXLjWiGTQLihs33pu6XolvX1JgF5hSKU15r1/BkRONKlMRkn0P2peH7Ynktc6qX9H9FlbbCm/HnWAX7pD/6wLgfx2T74DNULdiUty2uNN+4v0bCC+63mTGRxqfnN2WYR1HV0BcbIgZVF8X4oMdRDiRbAHmfz8G7O/TrwmFTBpWYALwMCZ5TLp8quqkogaLL3T/jsmNL8VQq9XCs3pvtgODSW16KN0YZbiy2vYxDn383Pt/cxRrjJnTfEiifySUBUJCZOUG3Jv1574B4bSg0y/+jMR0+rSITCqEQ6O9r5V+uEFov0r9TrEvoeEsX9cuqEjyCMLBJErFxnTQ3ZmvdmeSDGAn2pdaNI0JZ/DiVMigWchGRiIJB8xT3qEX5TNWKmWliN+3VN9Ndrk9NEIkBawBJweX0DlFiVHd/V1Xn0B4hA3X3H/fyf7IM5/8J4REX6+SqsUd0a+T9TqrmPVZyaEq9G+ZxW7L87q8+Sy6IQWypHrgS4dW/CQFDTtgxwzF8sYOWmxOR5k7hf27T5PqXKessQNv7Xku3KejSsqk4jU93F6z6YHim48snVemx5j2fSa/P9ueZsmpxnGu9CmKDT8RoqB02iGfEcS2Zj/746ac1nV9dEK1jh66iXs0PNPEZL4ykWpkc70zldW/AiDO6ezX2vU5HN3UhtAiCZQukpkBahDCgpiEuk0
 aPxntJN3
 YG0tYfE6J4hYMnQD4PsbeRliOamlqKqMvJhwKOe8U+5CcT+37zta056Q/89Z3t5eq2alczQdUJOQs4RRJUMSQ9jHLjbG2kmKNLr0jNniAP6hOmm4fVEnboXgyOghA0q9LVU3R+c4XMA92Ej9bOGBMKbbgC0Ido6v6XtqWmU7SdACYPp4qfVhPjBImz93pMkuNaJUAIB8Zgi+VM45NCBBdBHO/Lmb+q2P5Hx/tECRxeYVmL+e6xtxy7x9f6fo3zcUKslKdG7n2Y3YrRSdQci/eXCx7f0U25858koa4mal6sJ0obB761q64u7M7bRGNCqAbNN+75dpFs1jrrr6s5MBuomWTfOCirG80pNIBksLkmsW94ZOuZRrOO5r5AIPAvHYZFRbNpP3MqiHu3BT0pyImM4hJx42V8OKJ945qcsABxua0N+MnmbTAVVGulf7ATPHSfi5ZEQZzEOvREfFCXmj8SB32J+GnrEn7GJ7VWj8sazY13I/gx4aEGRAzvwU4kJSoc0aLRqaDS6UZUKMr4GfRrs6esoWWyaagYJRLEhEevWB8lEimL2Qd6PIUO88q30qbaqrW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 13-10-26 17:56:19, Alexis Bouzigues via B4 Relay wrote:
> From: Alexis Bouzigues <BouziguesAlexis@JohnDeere.com>
> 
> Commit 212925802454 ("mm: oom: let oom_reap_task and exit_mmap run
> concurrently") moved setting MMF_OOM_SKIP from __mmput() into the MMU
> exit_mmap(), so it is no longer set when a NOMMU mm is torn down.
> 
> As a result, a NOMMU OOM victim that has exited and freed its memory
> keeps the OOM killer from selecting another victim until it is reaped.
> 
> Set MMF_OOM_SKIP in the NOMMU exit_mmap() once the VMAs are freed, as
> the MMU version does.

Is this a real problem that you can actually hit?

> Fixes: 212925802454 ("mm: oom: let oom_reap_task and exit_mmap run concurrently")
> Assisted-by: LLM
> Signed-off-by: Alexis Bouzigues <BouziguesAlexis@JohnDeere.com>
> ---
> Restore MMF_OOM_SKIP on NOMMU mm teardown, which was lost when it moved
> into the MMU-only exit_mmap().
> ---
>  mm/nommu.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/nommu.c b/mm/nommu.c
> index 498e01ee40b0..913b2a1b5b3b 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -1555,6 +1555,7 @@ void exit_mmap(struct mm_struct *mm)
>  		delete_vma(mm, vma);
>  		cond_resched();
>  	}
> +	mm_flags_set(MMF_OOM_SKIP, mm);
>  	__mt_destroy(&mm->mm_mt);
>  	mmap_write_unlock(mm);
>  }
> 
> ---
> base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
> change-id: 20261013-fix-nommu-exit-mmap-oom-skip-b8e68bf34b6d
> 
> Best regards,
> -- 
> Alexis Bouzigues <BouziguesAlexis@JohnDeere.com>
> 
> 

-- 
Michal Hocko
SUSE Labs

