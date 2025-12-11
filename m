Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C10F5D41C2E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 12:37:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11C536B0005; Thu, 11 Dec 2025 07:37:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F4426B0007; Thu, 11 Dec 2025 07:37:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 031456B0008; Thu, 11 Dec 2025 07:37:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E7DC86B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 07:37:08 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 92F4F131170
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:37:08 +0000 (UTC)
X-FDA: 84207140136.21.755ECD3
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	by imf12.hostedemail.com (Postfix) with ESMTP id B3F9F4000D
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:37:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ULzGzf/g";
	spf=pass (imf12.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.46 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765456626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qb7w4dEkS/WJYKdR+lnZ5LKlEUSJP7zUGNH1/GVMobE=;
	b=AAy9W50hzVEtu0leCrqSh3JdHP0wVDf1v9c38r/jD128uijbQ9NJ4d3JwuT5VXdFOxJmZW
	339R8HiE1WrfodF/TY7uzFkxiXDn+FnG9NoIwtdOUafCeVs2nadVzogxSrgTZ4IjHZGnQ0
	f3UmlJ9ICtlUUeuixzxIDwnwpaqQMeY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765456626; a=rsa-sha256;
	cv=none;
	b=d6LpNKzsEEENqHFTFO1vsz9qPgNfJJbXFDLgv1cVKwNDW8j9t0xFj1YyM/0W2T50qJ9DKw
	Ln3DiWnHZcDHJHZgozGqhzs4RGmfUV0MI5cm5XlBDy1hn2SLIkv4FkBSE+mzxpBVN+vPoV
	VCs/rBLuoSfTZFsa3WCfsxJdaNYaJ8o=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ULzGzf/g";
	spf=pass (imf12.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.46 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-93f5b804d4aso9213241.3
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 04:37:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765456625; x=1766061425; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qb7w4dEkS/WJYKdR+lnZ5LKlEUSJP7zUGNH1/GVMobE=;
        b=ULzGzf/gHiig6hDnF41M7NiEf63U3+vnzp+hzmphrtvEjW+JCGzcP1a52wMbP30L5Q
         adIrBLdckObWv1KKkQEiUmqrLyDJM7mdpes1DlONIWxz9U4IlqYFapSbmSSXn2G2+q46
         UlT65qJw3DXf9CxWRM2iYY+SLSklSs1u0E/bzSa3z/hv9LEp44qc3jc8tXFvpiGMRsO6
         Ni2WPNMpXRZRfesu6ppsuT7jzyhKY/uCn70KMPCw7LOFDDJMoS40DW2Uo9EMQJSuphIe
         aRNPUBPPNvdRikBAGUpp10GIWnbZAVUKYDVmhpfC8EOWqusCryilD7Z1Aawb8HoiPHGW
         557w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765456625; x=1766061425;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qb7w4dEkS/WJYKdR+lnZ5LKlEUSJP7zUGNH1/GVMobE=;
        b=EWVOKvKoxKkK2bkaCVpPzz4fVehyL+HntEdJCusO4ZB72mKhx4o/SjsURfOg3Tf2hJ
         wWA92toJieNRJIbbGZGiI5mDkEf/NGWuPACpbwngvz1EQI756hHb+4cYqbHUkMAMU/Yc
         rNc1Mxs6Tv5KS3Af2u5/aC3TR/6Gx+JhKxNYxqSHssvkszlusqL8k6UYOU9OYf5e8WdO
         n+dq2a3dOHESgkAGPLh53qWpBRq9LHvShFiF9bI0Zav30rqQUXUDtUY8KTXnHDLFVa3+
         GhaIBtf33AZDmzSB5CV8bo9p9FGU/J2zI5vezmyyPZUkdXdnaeq2cliZ9tv8lfZo8ZoS
         +pWw==
X-Forwarded-Encrypted: i=1; AJvYcCXp42z1VKI5ATrhFfkJWvcOKRNxRav10w90MLsTbsOaLqW9s6u+UuBAFuIbXCYhjUkCr+WUQqE1jg==@kvack.org
X-Gm-Message-State: AOJu0Yz2DX6kD4fyFwEa1LNsfieP+n7EkmYUwsl6MqGf1gniXYbJAIKB
	m3AFvg91e3uD5CqdvOU5vK872w4u3tGdyaxAiw9klpvcpeeedNAnksGlxz9MD1paY37sLn8llzM
	j3DN0MuCQorP+lXIl0cyDeDxtaEf8Uos=
X-Gm-Gg: AY/fxX7nsT/weDwKFDsuhAbiGM4sqBNSngvbtv7LTcH4pxV4y1aJmosSiI0NsLV09eP
	54KT32a/HUSZ2frXmP4qKOpK2CAMIK4T9jTxBw3RUrMEqSux0NCUPGHBKTB8z8MB5PWAtzJ47C9
	nFkEl0smmCZHs8oiOX+Toorw0IXIs4UxVt7Vd2rMm7PedvfojKWIaYhKWFXbEyvbXKgiQKrv19Q
	pKG2H+qWzn5FS3sZNtZ56hDWfZvtgWehBWyBkO5qEf/uO3qtnt5TzYtj4Fgr+Mlj46UxmPr24tg
	/yFhCQz9
X-Google-Smtp-Source: AGHT+IH6QD73T3CQ2JBAUzE15s0jML3qHw16C343Rh4nwXrF61qHiGoVQrgUOlxSDKVLaFHRU4/Fj1pnToTM924tNUc=
X-Received: by 2002:a05:6102:50a6:b0:5db:f031:84ce with SMTP id
 ada2fe7eead31-5e571eed9b4mr1779282137.29.1765456625268; Thu, 11 Dec 2025
 04:37:05 -0800 (PST)
MIME-Version: 1.0
References: <cover.1765439380.git.baolin.wang@linux.alibaba.com> <af330c9ea188bd0f28189b1e6e5803f6de9d2abe.1765439381.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <af330c9ea188bd0f28189b1e6e5803f6de9d2abe.1765439381.git.baolin.wang@linux.alibaba.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 11 Dec 2025 20:36:51 +0800
X-Gm-Features: AQt7F2o2oQ9UqEmkEwhl5rOFyhajnuLd2K2hl-pbOyh5rDa7buD-_5Vc_9Xr_KQ
Message-ID: <CAGsJ_4yVCbP9EJ2KZu-83PL-LViB+zn3NPC5E61LKf+nWWNsWw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] mm: rmap: support batched unmapping for file large folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com, 
	will@kernel.org, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com, 
	willy@infradead.org, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B3F9F4000D
X-Stat-Signature: kk5dgeopqw973h54shsjinpqobh8hn8h
X-Rspam-User: 
X-HE-Tag: 1765456626-715802
X-HE-Meta: U2FsdGVkX19Dh0OhGZDRqjZ1ky8S3buJRy6PuA5s2gcqIJYJ+IQhIvETwZSsEa2UYSCB7lgYPjOepltU+C7EdvE2kDbknB+VNo+KxgKnU6ZWGtJTB48M/qQQk6MkDhJ90HQePDJuCgyHPqlutIHt88b9iR+YZtkw9QCy12p1TKaBe2okKMwdH36EF3Z7fL22LhVthSsRYzOarMTasrvuRKe1vB1KUztd1NWu0h3U1trZTLJYmgD1aNZGIiehUFwsogIG0P4RGgDiCvSsu1V6Jqr5DZ27/3ESUAIm9eyTci+yjoZeWQJXDaiouYN3zKEsAhy0L3Yak5iGk7R18ULfACFgDKjXapj4pafEvZhqIHADty20SxWU0qSQgaRju0V3eFDGzl0hGhwp41YIGCnj9/Bn1YjoH5wwxHtTrAgsqSt5NZxVyFu3wDbadyG0s2n4ejZTSe87a6OEeNY9NwU2L+HqqBRQtQhS80GeXidjWDly1Gz1Nax+xXr0ZZSyKfBguwOncTUR3/tO+zYb/KUdqKzn0kfwpDNRE43VoQBjTsk8fpHz17ZG8LuX4i0I0oUSaBgSKSyJO2ZgYhk8sMBVg4U3087drLJvyAQVhQ2zp9FRpvN3AwOU8q5+kb6sRaoG413l+WMKDyvR2MGPSTWb9J8UQO7fLLaoAEmJP7pyobKe3OUXXCLvjwmNBlfmQbXDcpC/FdwRxNTBhS9chMKloXGy5ZS0Owru1rVbasFyD+xq9CfDVhW/saAf6dmQLaSxi6G5chOiAvF3fOrqCBCdQhZ3wXdjR+/S84JiKde+1SoK6mWJsmXnwdxIvt05Ffqzb97PfgxhF0PFVxn/Xu5taeTXyx1joF/jmS0rtLnT2PLH9iBHMqPXasDFyDJ6F3jaWOOwGLn6ofjrFOwphd0uEdjqEirQPswpQRsYds0UY+twaL/ECdYs8R3ouMAMzuZmmxmw3CZGBFAw7/eAVy8
 ZytGEqsr
 KuHgiSLnjRppKDyXsKi1klYeFUkX6TsakCftGD34Ced6Vqet15jKalSUduHJ1ubSqHiY5iYPJsc5/1w5/0kxa+jEb/GBoV/yR/o2yorZLU2HxlCOHQy9B/7BSr5YluxxsVM0kseVGsqYsseoC2SZYyHeTRLB2mo68S1WJdQmxjfCvNkR8uAw9SGPTpZ+J5Kw8F+TOilZDO+FKco4as66W9NsnpngS5t3VnD8zDKh5g4u0jr3uqrsZsUf7zm2mOW9jv+X8O7ZxmXKKBcD/G8qFCof3WnZcHfs2w58+Q112ffgLjCjYjvZqiVC1QBxvHQvWXckjk48VjYGjBOe3SWgXbSp7lUUhDFCmf3YxumFkDwuR4tosFe5HX4oR9iFhM1+HZr55kYk6gGxQ9I8onzbqUPuMcw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 11, 2025 at 4:17=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> Similar to folio_referenced_one(), we can apply batched unmapping for fil=
e
> large folios to optimize the performance of file folios reclamation.
>
> Performance testing:
> Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and t=
ry to
> reclaim 8G file-backed folios via the memory.reclaim interface. I can obs=
erve
> 75% performance improvement on my Arm64 32-core server.
>
> W/o patch:
> real    0m1.018s
> user    0m0.000s
> sys     0m1.018s
>
> W/ patch:
> real    0m0.249s
> user    0m0.000s
> sys     0m0.249s
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

It appears quite straightforward to introduce file folios support based on =
the
current lazyfree implementation.

Acked-by: Barry Song <baohua@kernel.org>

