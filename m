Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27B27CCF2D2
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 10:20:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CC966B0164; Mon, 19 Jan 2026 05:20:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78D4C6B0166; Mon, 19 Jan 2026 05:20:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BA886B0167; Mon, 19 Jan 2026 05:20:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55BF16B0164
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 05:20:17 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F4197C24E4
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:20:16 +0000 (UTC)
X-FDA: 84348318432.14.366E7EF
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	by imf27.hostedemail.com (Postfix) with ESMTP id 27A294000D
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:20:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.161.42 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768818015; a=rsa-sha256;
	cv=none;
	b=q+6FFLP4dhKft3Qymu2OL2UJBrIzmIQ0MJ/inalPm8JFELLNGOPLgL3Kk66J0QHVFxZKG+
	PoLCs5YCZDZUIiJ51g1F6iMjibXhuBB4Fz38nr96eSEgXR/aSBJBQ6AlFdsmrz2LrvYcbH
	5h6tB9BICgnp49+W1rJzHk+wm8jIPQI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.161.42 as permitted sender) smtp.mailfrom=breno.debian@gmail.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768818015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uufwEcA26X2L64ykZaFMsbyH8luZYH3uk+bytmn50hk=;
	b=UtM0APJtOv/pnW062gkUG3lxtUN5cccVRm3mDxXdy/K4s2QteWrK3jJvBRIOOgzetkloB3
	KtwTps05BIoLKHUks/++Sp1u+2Z2r1GGlAi65On5+PY8ioGblUzXQSc/OtAYrs6Vkal6vp
	lh1w/KV+uqte9FMhDzpqjOPc0h36JUQ=
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-65f65538a90so3065714eaf.1
        for <linux-mm@kvack.org>; Mon, 19 Jan 2026 02:20:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768818014; x=1769422814;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uufwEcA26X2L64ykZaFMsbyH8luZYH3uk+bytmn50hk=;
        b=lMlWOX6+NZLGkUAKo+wqgDKxrd9wsXFsWJrw9S1Zbv4atdIMcQNd+k0YPCk3vqcB8x
         9sZdzQx//mc4RXjeoJgbxM1kAf6A839JvK5Q3igNcEo0addXnKqKV40gHv6DgrKqnFsb
         1yCHF/7vccg6omJnDoxLTFmlG14wzj7du0RwnTQ4rgh94dsU78KhhLfXiTA0HpQnKlVV
         SOpgwH02DmUdWDA+Y3cFwLv8s/NPSRjxfssjkA4vQVjXygaOuMBV5tnnwgVUBZSp1Rln
         ls425XUbvIqLPaU5/K40Qt5AzH7XlQQgS6yeFH9X9A6sI8o8CJnOOy5I/3852Q+H3RRn
         uyGw==
X-Forwarded-Encrypted: i=1; AJvYcCVqJrmavMmpki9WGg3g1xpg5Jpl3mMo4wRwI2WQpf9WTCl7W7pRUxYj+MlIUzKdlKKx1RJa9m2zSg==@kvack.org
X-Gm-Message-State: AOJu0YwMp8NrpeUjTvCI54BQEkX1mc/A/jD+w+oBtbbapLEgqFpSCz6C
	Er/5Sa+v9LrmkX8AJd8jhuEETiom2Ey9eMT35k+JskKzv67/QOLwhX+8
X-Gm-Gg: AY/fxX6gJoZrkiPro5blc69yiXzzN3vOhyLYzDsz5GyH2Y3190mmKlprlkgsF/AkKhg
	ioG7J0sMYk6c/GOUcdw62Jv8gtEOOhwUZTr1La5oubObXOc31D3thnXAYeujDoh0RcvUEk3nRSX
	PF7qqRMa6ZwWVuElSHqj0YTP/T6uKIMsy2NeVI2ub0qwumXhvxK6xq/HNg3SCTFtaCWI+wOHVpe
	t9BnXPBci3VHW3VrIiw0P+IneKkB+evtJE68w0rtYQbbTUAPeCJNcUXL0JeZHIpkDPHrflVYitA
	HCQ7wrrdd7SQ6z8peFID2wZb8DmTYkQ8ZklCTs/gEvUmmy2rwRjq+iAm4qcBhxQe1do9w9GLfPV
	c8cNcH2fOw3vCvHEW8og39/KOZWYcEnlEw9lRFZQMuRFJHVlUEOEMgeLVYFPWDIYoO6R/AcBxDf
	cMUw==
X-Received: by 2002:a05:6820:4613:b0:661:154a:c289 with SMTP id 006d021491bc7-6611812574amr4202939eaf.31.1768818014192;
        Mon, 19 Jan 2026 02:20:14 -0800 (PST)
Received: from gmail.com ([2a03:2880:10ff:41::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-66289e3af7dsm3342356eaf.14.2026.01.19.02.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 02:20:13 -0800 (PST)
Date: Mon, 19 Jan 2026 02:20:11 -0800
From: Breno Leitao <leitao@debian.org>
To: Marco Elver <elver@google.com>, akpm@linux-foundation.org
Cc: Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, clm@meta.com, 
	kernel-team@meta.com
Subject: Re: [PATCH] mm/kfence: fix potential deadlock in reboot notifier
Message-ID: <i2slhi24qpy4u4mtb7edm3sqqcazjfiw52xnz44i4o3vrhvoqe@d2qy423tdjly>
References: <20260116-kfence_fix-v1-1-4165a055933f@debian.org>
 <CANpmjNP5R3ALvtuMyLVhHGZpyZ2MoR7hq07jJFcSAN62Cnig2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNP5R3ALvtuMyLVhHGZpyZ2MoR7hq07jJFcSAN62Cnig2g@mail.gmail.com>
X-Stat-Signature: 94t4fg698buuw71fzqhq8rzsgbxyqk38
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 27A294000D
X-Rspam-User: 
X-HE-Tag: 1768818014-891984
X-HE-Meta: U2FsdGVkX1/8IrVXz96E2nBLy3rHBHE9+C+Yos/GzemdEpt8FxzRVn6xMA6rG5AfB4W2PH99MIU7sdry2Y1ItoiPbB2QiDrbKEGgm4Odhh0/7gOnKZi5ONXoc2irbD4m1yvOvKeZjlZ9QZ4kVOO/2yU8FJXhkvg2YT6pOHqg8dYpzhw4CqxHjh9o6lLUoRzjB09uQimXC7NK6PtUGFYEK4DlFvaHAcGzehQEJpDX8nKU/UWQj6Ck5ZvkGBHgKnPFBSyG5QmpUcwbwD8rZMnnf4qYevfZkpdQBr2t12rCIXji0rKRR0tdNR/2zn217i2IJf8wLWewqHi49a+FiWt6bM5+mVELNW4YDWHb/4+ZB+8FhFdl5vO92rm8J37QsGUAKModLjbzogdEQA2sTd9AHqOnUNQJXqCoeCkyyM9ecVKD7GUTRcKk2EQD+MHfTQVWkpGH98hmUSh3w/VQv77lr3fLzVKN0vDkdBMg+lycnThXCuzvPcSVS8R3CAzuvssOLwNVAYJtszbtqgTQ38H8AxaTZuRBvFOvgjq6iJaCeJeV4M8DrNnOInqRj5n2esHXDBX7xjp4HWc8LZ0XHlhbTomh3mwrXO76nnZAAP0qU5/ef4vI6Nhj5YUfCiB+AOjF7wTn8FxxJAvGrnV8wbi7zSyiLnrLUs90MVzKNqU4PQesM8b4xrenKBd6EgmqU8iCxNqwEh9EO3dxx/u0pRsKiHjKMSRTWYwlJSWT5Jx3p05PhL+eBLP3j78S2qjq11Rv2cjWYs/FolqXAhW3EvHp421/Z4+nMrK7eoQtfZ0v89t/KfvrxqCFspip7+BMn1fhHT0CkWd+DxllkLXk+eFlnhdE9Ez7f/OIKWKPPrij6XVAtPLqr5AilJ+C5Gi92oRFiJ9feLycdz8rCb7phQmVJdVMfBhW45gaEfCmxcXlr2gL0imShiOBoXrteTm4LZURlm8oMjDSzILEPziN0r1
 FDsffXe7
 d/HFg5K8ZUaWwdY7acrUVybkSX2gJghQNyMPOEuYLvcnN4Iei6gaq7zrB4plLBsLfkVZDy/ObMxjfTpnTj2fDpSVZQ/Ap0Noa+7TgGKcZjSCaAG6cblsd4Nv+VYfN8cnLoCek8E/40XINMvSqt+q8jDYQUMySkhCtwEOytd7tcAW+bvu6E2Ptwy60U7sZdIoVOCpp3MAXz2o8u4m5VfdKxXfyexIts10fMoG+Y3kBCfEuDWvOhcBK5uLVImsEF9FD1KJcw9+EEvVrs+D5RI5ZLuZDNWR/x8QLZMri7sTLJ/kwACN71hCqCUMSaRCtuj8KA85hfP17OBNH8s6L/l+OibcA7jmjcvjB5uw4BIS2wyaNYTkTKgZF1umgvv4VeLrBAt/jS6HmGSnFkErpdW+WUYu77aZQZuQRAXKZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Marco, Andrew,

On Mon, Jan 19, 2026 at 08:00:00AM +0100, Marco Elver wrote:
> On Fri, 16 Jan 2026 at 16:49, Breno Leitao <leitao@debian.org> wrote:
>
> > The issue is that cancel_delayed_work_sync() waits for the work to
> > complete, but the work is waiting for kfence_allocation_gate > 0
> > which requires allocations to happen (each allocation is increated by 1)
> 
> increated -> increased

[...]

> Reviewed-by: Marco Elver <elver@google.com>

Thanks for reviewing this patch.

Andrew,

Please let me know if you want to send me a v2 with the typo above
fixed, or, if you can fix it in your own tree.

Thanks
--breno

