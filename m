Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87737C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 13:54:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28E7A6B0092; Fri,  8 Aug 2025 09:54:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 266F26B0093; Fri,  8 Aug 2025 09:54:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17C716B0095; Fri,  8 Aug 2025 09:54:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 083846B0092
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:54:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 853E8570A7
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 13:54:21 +0000 (UTC)
X-FDA: 83753734722.12.0FA1EA9
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 79DED140004
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 13:54:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=THnMjyPL;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754661259; a=rsa-sha256;
	cv=none;
	b=LIoOujUrro3PPeQ8iFdnMG2VuNsSYHwTVFrCFeTFBbmiZIozzwQAUzpKreufIRSWLQXW4T
	9hrpU25rJXF7a5zItZfUGCzqY0lgRKpfQxZaUMMomOC6OPEJ8tBTsUO+iNsygnYFlc/cN6
	qRZclg77/IU6Oe2hOSkBXTsdhGH+whk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=THnMjyPL;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754661259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jzUwRFYMwe0kkKb7Wpg8iUyhHURaS0YrhVvgitXw+xk=;
	b=AP4Z2M1nYL6D6RIj+JuclOHEVJxlwQcRj3ZqFl1/k10uZ/hB6924bYnZMl4H8PQ9tCISkp
	cz/UKD685UUniT1pLl+G+lD3PS3lRWZ/Y7MrZgV8sh/45es/AvKkOe6qRTiQbHSbrSUW9U
	m/wJgsYgIz/JIA5B/JHiQOx2XPOVRzs=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4b0a13bb0b7so23950951cf.2
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 06:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754661258; x=1755266058; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jzUwRFYMwe0kkKb7Wpg8iUyhHURaS0YrhVvgitXw+xk=;
        b=THnMjyPLxAJn+cHMWOmDsgUpWX493YlGwfvNNjt0OGvJWQDBoFFSbVX+DZXGOTXSyU
         uLCY5yF1nEBmb950Iy+7AcKQaIivEp4fGI4P9pkXG7My8dtEdGrcnvKkG3nCLNFdNLhV
         8WMZj8dGa8CnHCZO++pPdjQMTvzvJjV10Al5HyvgF7oVB6/2BsIEkKTzTfZEl/Ubtao2
         m9KmwuPpQVwF5d1+s2EfdCEQjtRGDpevkX2uz2w+AgQLIGmaETobEOrc5Oxen3D2jmK/
         50gyhOcGNgzUFAYq7Fqo87lJrsQWggi2LPizJrpm/Pk/JNs6JtIs+QHuCjMmSnrdBM3Y
         3csA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754661258; x=1755266058;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jzUwRFYMwe0kkKb7Wpg8iUyhHURaS0YrhVvgitXw+xk=;
        b=NvBOli9OVu1h7Rji57s22SFdwlM5SGohjNJ+eCRv61xylxPe6/yM7LkNer/5BHqd+a
         GioNUBX3VvWu5H0Bq5oRWCz/OeNpot+2+L3wbLI6HyD+PwH/FRXHIj0T649J+M/m2Tsy
         aVfW7vHLLApiUeLWfo6ON1XxDk3EII4MQjPKcHeoJHiy4xsCa8VsiwHG8+bpe01k2SDv
         9nei+Va9N4Bt11oKLWPUvsY/rbNo8S3B8WAEhXYjWKFA+oNXmguQ6h6RQhMOC5zNzfc1
         A6966SuKc9h/kXECMLH8LWUASN/dbgIX3dhOz5HdJvKclyOGD6Cx4pvlVhhHb7Xr4FdX
         hlxw==
X-Forwarded-Encrypted: i=1; AJvYcCWu3nxPe3kM9DGlLgxpSJ8O2w7OOtV1DlY/qZx68aElMzAuoee+8OKcyiztQbDhdFKsF8tLnaC+OA==@kvack.org
X-Gm-Message-State: AOJu0Yzhd+7psGHlZnWeXSSCFRcUe2v0t/zs3aVo5X5C2HyukkzBACB6
	atGwrqOnt/H+ebpoLIz13kbyA6gmG69IpqjOR/f2QOJo8Ptpb2n91lJkgrGgra/tRWcYOZkn4Cs
	5g8UmiAK/zDdaAIi0bcp1m9rk4h9hl7KoVE3F/D7GPw==
X-Gm-Gg: ASbGncvMGOzrKZHZp9ItZvgqdbFPvxceUZbwjHpPxAnEPGucXsrf2YY7uNp0LFKHMqr
	5a40Z4rYaiE512585lEuUrNS8pRxdslhWal1E3fpOzMjFojTzKDI7FjXOPMX3cAq7zoNsWlgTqf
	HOr10hqBQOsA2z7Q+54S6BfoMmsuI78IOB2qPl8kxryqOQ8RYOxPix+lxY7f+sJHwYBsHAgZ4Bi
	p2J
X-Google-Smtp-Source: AGHT+IEJmYietSH5VpR6RMJMP415b7zyz18sRNUfhN29PGY7yEn2BPdHDpMV3lyr863RZFGEM9NfgFIb4ZTkLRTpI/s=
X-Received: by 2002:a05:622a:1181:b0:4b0:7620:7351 with SMTP id
 d75a77b69052e-4b0aed29dfemr44241331cf.13.1754661258448; Fri, 08 Aug 2025
 06:54:18 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <b227482a-31ec-4c92-a856-bd19f72217b7@redhat.com> <mafs07bzeatmf.fsf@kernel.org>
In-Reply-To: <mafs07bzeatmf.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 8 Aug 2025 13:53:41 +0000
X-Gm-Features: Ac12FXzC2ItcrNrnqIm-RSLWTwNqS2AX71-Cg7eUT1NgfRdHm0ajR1sU163K8_s
Message-ID: <CA+CK2bCd9x0KA=cO8EauJ=_GJ-GzO+0Z7HXN5=cObxuGzFDzCA@mail.gmail.com>
Subject: Re: [PATCH v3 00/30] Live Update Orchestrator
To: Pratyush Yadav <pratyush@kernel.org>
Cc: David Hildenbrand <david@redhat.com>, jasonmiu@google.com, graf@amazon.com, 
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, joel.granados@kernel.org, 
	rostedt@goodmis.org, anna.schumaker@oracle.com, song@kernel.org, 
	zhangguopeng@kylinos.cn, linux@weissschuh.net, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, rafael@kernel.org, 
	dakr@kernel.org, bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, leonro@nvidia.com, 
	witu@nvidia.com, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 79DED140004
X-Stat-Signature: 17etcaf8gaq5ej9kiswgnhzcrg73nc6d
X-HE-Tag: 1754661259-85939
X-HE-Meta: U2FsdGVkX1+Og8sBeJn4oRhyrVjvtUWJn5cjxY+tVx4FyuEYby1kuWlePaiBi+rST7huRDOOFZKb7iZfx85j/Bg9VoI7sfLUF++kTPd8PL+BE+MkJQm1bZfBs7S66VrraHfBMPCv5tBh7qbANs4vzg2R11NQScoHdzJiGClKTxe6EakBolcaBkN9ntWbVn65BAIkdY5k65ps14WNtbRs2WGsiksCKvqwILnmybH5+DIjtOeiuXUfZoqquQ2QExw0EBBmbQFMJ2LhD8B/ZGZNxEaHOfFWnvfhyIiUVAi/3pdnE7zPSjvQJjPLNPjQhBy9T128pJ9ajOtvQfq+VEUVZslisWANkeXSrx5nPzMuxpGbraEZ/eCnwkE9V0i3YQUG38m2efmASXDTs7YY/eaD8wwrn75++Y3PXxq8uhjOm2uYj9ddWi9cYAvNw+6nErTB6V+mIxdlgNOLaKyoxeoZyO1j1HTECOo2zW2XD+Qmlan/5sYQwBgq83Q8uWIEQuc3MNvwPrGvdYc66DE9nUG7R7odoDmNs30bmKQ3U6uE18qKKlf/WYcJzQNVQM8L3rqyFT2a9JkUEVM0h3ozAxapByd0qJ3mg2ef0+aStEk5pMptsas/T6vDCrTaecHAw5k4ooXmqEUZynMKEQtULP/i21pvB7bDRsttTox62/lI4UuS9P435M2C/Z3k01YhZo6ShSyfc/B1ieIhNEePb+Hova1pxqd7UI1iiFip/c3eM35sqaTMKn4iQ4Ig5SCTYJcxo8LZlM0h/5QI8O7Yei9FdGmZvdlNSfKNgIQQdTRpB6qbTS2pR608TBnKJpqBsI1Yp7BRRKsWgSlSI3+7GSpJ+wzYrJfC+9M3C4s8QoXshIcvhyExqm9ueiweUbd1IfSLv7hd78JRO5um4tru7dvTBVb63hZS2wefflCvq6jq5dEluZMt2NnJ0ws5frLDwM7K1nGukzB6Q9mvkw5SN3j
 idZBkLl4
 YDrM1YH8un7+29udS32AR9NORtYAePS23d74c077Ed9sdmQVoJbC2YQsrO1f+SuijNNePz9Aw/0OMalf9ngAyteyL8ULrsCsqKJZnJtM9FHLWvQApbQcexkGm4h+ex6LlyIxK1hCVsPNEWI4GWqr+k2mRN/4+rbU3Bfw/NapvciLxiT1zG3FAOAztz97MC7FwFVb9Q0uEptiQAbCvdin0FJVm0e516wUIWDNgtaRZXlLvlB5KzZWZ2G3cFFtA7Ejs4Vkk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>
> And now that I think about it, I suppose patch 29 should also add
> memfd_luo.c under the SHMEM MAINTAINERS entry.

Right, let's update this in the next revision.

Thanks,
Pasha

