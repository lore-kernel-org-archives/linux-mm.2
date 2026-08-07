Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37F3EC2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 03:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B88326B007B; Thu,  6 Aug 2026 23:56:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B39CE6B0088; Thu,  6 Aug 2026 23:56:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2A976B008A; Thu,  6 Aug 2026 23:56:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7144B6B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 23:56:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D2A6616021C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 03:56:14 +0000 (UTC)
X-FDA: 85073110668.23.D6735EC
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 083EB40003
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 03:56:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=UmkRjk9z;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.51 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786074973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pojiAuU+JBgHULOsiFmekOD8q3fMu077wXQ7v5rNalw=;
	b=JeSz8cDV1G9VHTnPMjLue+yQNenrP3mqDKKC9dy7LT50TDG4jOqsr/CzIl7nJg57jbwLzM
	2NrVltxrNne7UfXyjCmPZL1Ub7XBIx35KWFYCFx94zTTOL2Di7SaUe7Dp7Yvy8nro8LmtU
	dtU6OriRi7aZIM6873zYSDC6s/F5NK8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786074973;
	b=eWHlUFYh49dtpay78IH8ZySmTCpzbcmbBw2uEBTsGTP8zIWgWoY5HxaLPjLiliF90IOiUY
	qI1ourebIVrH9V6W6e0iqEfeRNMJ+LDciIrUSzizEoLHsANgJFf8VDnp9H42mLumqnClqS
	+WAIXn228FWi8ORTGWhygnoYQFA6fNY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=UmkRjk9z;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.51 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-38dc4553f62so3173103a91.0
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 20:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1786074972; x=1786679772; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pojiAuU+JBgHULOsiFmekOD8q3fMu077wXQ7v5rNalw=;
        b=UmkRjk9zrTGc0NbfRZz06ygVkpNjEDNwrvvUm/G2TExNH8sRZV/7PdvhSJ4ho7VFrE
         tRPPfJBLDihtuyXxdcgSDaOSGXQhm9yv1J7/P5KTK1cRqsUDawOnXADsgLjXdGnxN5vU
         +b3ovnwdMKeEHKGgQfme50d59Gu4Lgyuv2rTk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786074972; x=1786679772;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pojiAuU+JBgHULOsiFmekOD8q3fMu077wXQ7v5rNalw=;
        b=h7blxhhHu9OXJnUj3NoxCt6xc6Ic655eAyTlGV3e8S4UIW5iOqDmvVZs160+vuK+Bx
         vDEQKJRdW30+hNchjwk+A6NjN0ZQHFs152/QxjOxxzymi4h6bBrSN3CvGVhr13I+1hNG
         eA4sWvGKPLQ81hs5VRw70Vpa4qCTTkNrJznQ0+XbhOfjogncy7ylpCwMR0SpkH8G0J9j
         nZ4CLTEzVNUgIBBIArU8yo3yLmFgEaEQ+2Op6Re6SMMQlv/DwI2Fxr+Ocs3qdo7VuiS4
         bLvw0k4/KrWHuyAVCh+aeSg+WmujqUYAQvE4fFXtnxLg2MhC1qQRap5qizaPJiGQClfe
         EA9w==
X-Forwarded-Encrypted: i=1; AHgh+Rq4J6GagiQPuASTp4lFeSQ9qmrgEhBLktWqJ5DA9T2PABB07F0etuWi9IpaUv3pEowtu8GZQ4yhBw==@kvack.org
X-Gm-Message-State: AOJu0YzurgsezXgigZuOzjFZVFgFOaFEHAzzEeAqNQg6LEkqsvSlH0k8
	4eL7aimnSv3Fxlkyz3WdfNlM0KHLiG0FwC5ss2PRbggWB2G/qa//Q8xsfOUkshWl8A==
X-Gm-Gg: AR+sD12mUIqmEPPGC2ZK4XMri2AtMDThuYncWtcpmWYQJIb0Kd3coDYPty5wiQ1G6M5
	Stl08vSCFe5tZU+N7MUyW+WXi72Y6SF6zt06HgPYBUkOG9ue9ZvAyM7eMJcLSf3fbWRuEB51K5D
	TsQQqS/alvi+SI+lH7VdIoVUBmdpRYFNaeUY86PPNS6MLAzhLGUvG4pRsGqUZBXYXhDZBM7vWFq
	v34WmFGe+crhPTczVFMlR+sJtkyIb83/ipNmiWsi/auk91EcsodIWDu+akkND2XtPje+w7Z4uaT
	i1kbQIrzVWlrMywfK3c7IeWB0R3CbUemS2CWXiRjPiannWhdbVYSqjSRpbBaPmivzOiRyL+M4KK
	bATcDYdllXIJnb2j890qv3ajE63S6VAfrulxUU8SuuXJMprpNqGGtesXxWfNtj3kqI7En4QMnVE
	L+pAjkTNS/lu8nzkdjfoDGxi2TsN1Cog6s5yTFVoajK70Hv+Y+E0u2y0OroZZLmSmsLtUZww74c
	79+vshVVCv/BtOXYmwbo3iP8VNQ
X-Received: by 2002:a17:90b:224e:b0:38e:2524:724f with SMTP id 98e67ed59e1d1-3903c5b353bmr16932787a91.12.1786074971850;
        Thu, 06 Aug 2026 20:56:11 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:a1fc:f8bf:142f:6d3c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39085de9f6asm2890356a91.7.2026.08.06.20.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 20:56:11 -0700 (PDT)
Date: Fri, 7 Aug 2026 12:56:07 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: xueyuan.chen@vivo.com
Cc: Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, xueyuan.chen21@gmail.com
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction
 budget-aware
Message-ID: <anVWZVOt-xeD0dMH@google.com>
References: <cover.1786003779.git.xueyuan.chen@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1786003779.git.xueyuan.chen@vivo.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: kdg78bbxa8pua6i4y6bmskic9xfwtqym
X-Rspamd-Queue-Id: 083EB40003
X-HE-Tag: 1786074972-385643
X-HE-Meta: U2FsdGVkX18FoLxlSs6InCWmHCu03tNsD0wLdm7u7EQMx3L4mFr9OjBEKn8cDZL9WEMNOFXploKGkUOyAMmbpLMw2JL71juhj9irDRNhoMLtdIGvP/trsa/Lxjfyw51iAp/y72CIkt3MaBWjYHrIBZEyQ+zpDWff1JFupj6gwZFuRO15XahPu4b6DUTJFVfMbvdRMMrseJB7fuWfZVU5qxK26A/piHX7bRoQjkR+IxSSzxKSp/UtzfhR1X3+FnVcQaFfet82qLiKU0in8U3ISfy367KJ8y5hSgixWOEGz6w2IfDPFNWHwDPDGIVtQJX9PA+20fmYo75D86knxiCDs6Ae7X+3aPiMxyFINijgaE56o7QGBt9+5HqZgG6AEtSYWUcADHKhyU0NB3qCq0m8AxtTL6PUfM6wte7lJl3YkudpIvOf5fuU7KOit4A1Fkd2KoyJ6QjOern2+rhFlOafuqQ2YDcHGUTRHM2nxMrvLCILKErZY3ZJ0nIk40O8xKOVKeGKyVxjiGNlthlrI3/kCqEJTg8aHGomctyU8c8bC1etX6VgYm/fwhAqkkMgSY7p9zvoj5DSB/M/S8WdNm0cV4Ws22dDy03/pYMn5g1sIf3h69mEZgdnJuT5gK0UnQKqxSXAmCxU9Qtj/h4/Qi+HHkn05jfw7iQBrd1klalllKigPb6SHLGZ+kxPac38EoTwThB8YLEnGGlN3r4dJDSWCG0GVSA91Xca6hwrHJv/7k6LmK0jCRy3AVP62XBu8QUBlTHpzPT7g6hK2y5v4lNR/8ycSnEiWrR3RKNm40yVet6MHks9pdvYOwSWiYs2JRzmlCzEPfmhTZA1LJ1KZbPdnGOlAgAvuZfCQ2e3s3mOoVFuao2+JAox1lwigGXYVt8kVQn5n1pGF/qcpze9ex4GCJarrYJnLH1bVpO3JAdGwoPdZSdQQkkKnCb0skHPLBlFzscsq0NmjbSu2/xO9Ic
 JeVYdstF
 qiATxnQVji3BxfeS5a787WwsdFy30rGxv3+4Xykl5kB+5N6z/3bqsj5O/0Le+9Klq3CjyQBPhSBmzhTtot3zip9pV8Febflih8jxiB24z3VkrnpvVZBzGGEvdd+pjGze8Flri4Ayo9B9U4ZuqvsHpEceijx/R0opUm0Dx0oeWYy7TUxnWzyYeqvLbmhfTnL3I+zbTY6XUG3xcOkf51LxkWWiBdVa0QO7SW8slXhR9SoaheBbRrGq0fkjqcIxtmnjGuotosv5PK7CL9L2nK/mSsejFNEcP62IOshdSe/61zMZgXjUqoiZn1Zu8EoWzNHrz7qTymw4I7r0PuQTQsMeV5v9n0XyGNdA+zCZhRCfxl24qOyhKcbww9eAs9mWxLDPRoZX6zYYhVYq1l8QDjRuGoDCJrIgt1XePbRz7no5PgW189rY4rHR7LMg00kgD/cxTL9X4uv8FBrw7814=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/08/06 16:27), xueyuan.chen@vivo.com wrote:
> On an Android device with 12 GB of RAM, observed zsmalloc compaction
> durations had a p95 of 38.86 ms and a maximum of 269.68 ms, motivating a
> per-scan reclaim goal.

Would it be possible to give a little more data?  What was the
fragmentation ratio, how much memory was saved during that
auto-compaction, etc.  If possible.

Somewhere in the back of my mind I was thinking about, maybe,
disabling (removing) zsmalloc shrinker callbacks, in other words
disabling auto-compaction.  We have a sysfs knob for pool compaction
for system that still want to run compaction.  So I'm leaning towards
removal of shrinker callbacks from zsmalloc.

