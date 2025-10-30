Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1517CCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 11:36:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BFDD8E01BD; Thu, 30 Oct 2025 07:36:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 270B08E007D; Thu, 30 Oct 2025 07:36:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15F0D8E01BD; Thu, 30 Oct 2025 07:36:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 01DFF8E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 07:36:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B849C12B7DD
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 11:36:17 +0000 (UTC)
X-FDA: 84054577194.07.12A58CA
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id 93ED94000E
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 11:36:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XSuWC1xZ;
	spf=pass (imf01.hostedemail.com: domain of ptesarik@suse.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ptesarik@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761824175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bK+xN2oi25pfNhkbHeqP+Lhc4lHkzppS0DihgpAOqTw=;
	b=XaEC41sGDxBTWXed9YSOH3BwsP3TsmXnk3gE0mZJwG2Qx7iS1GOj8RieQjcpciFm+pYSeK
	fMJGJCeqpq6/s/nE9+kDsVw/TTa4TwcTSuCrclWa7Y3tNJSP/3bfgat21R1QOgWKaZirj6
	Fh3xHNCZU04FQ9iVmMr4Hc28T/4RKAo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XSuWC1xZ;
	spf=pass (imf01.hostedemail.com: domain of ptesarik@suse.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ptesarik@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761824175; a=rsa-sha256;
	cv=none;
	b=dXmCH3fleT8hahIdBkBLf/bOxgcg4HJIoj4yXvAdxZhjhMqFPVfxfrqpOG19EAXH7PUs7W
	AapUq6uq9MyHYZdc0ee/cRRkVdCt1qziXhOc+SsBtuewA/4zZFmiw/Cgnod+Y7qEQ+sQwZ
	ohlb4CQRc+IkFADMk8oXIRMYxNOO1mQ=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b6d4e877915so13414766b.0
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 04:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761824174; x=1762428974; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bK+xN2oi25pfNhkbHeqP+Lhc4lHkzppS0DihgpAOqTw=;
        b=XSuWC1xZyazisacY80r35oc1LuDZfTXMMtUQUiAXpFYmIAF10YYNk7YNCnHWHPma4p
         n/4UpUGDEg/IaQTZM43Xpy1Uhf+es3aazf7Tp7ijT884y6NvEH2sByMxe9IG8EnPO8tN
         7OR2/pDGfDuPXvtWPKChZFqQANLN1/35QhscBt1o653zfmphCIHjVatrb5xka7/Ldy3N
         jtcQwParWx1Zbk9ubVyjsaDGdDtLodRibONvxlRcY9UyjJfEk+IEwTbzRMF8acr/x1Xe
         TzVNeLNlCHAuzNUIa1XNjcepr010v+9RK5DDznhzrGu9jT2Z0vyen9uPl+KuthzStccc
         ZmWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761824174; x=1762428974;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bK+xN2oi25pfNhkbHeqP+Lhc4lHkzppS0DihgpAOqTw=;
        b=nVc6S7bjfZevEhTEvN+O4s2G34dc1AmIBvSjbsAcgcbUDcxO7KV5pOFP1FkyRsWcMT
         7d4TkxMGKa7PsFSJAFFpm1kQ4DWj8BqqYo/xcNUzRx/r9cwcLzzs3QBxk6skwLMcwE3h
         2v+85JGAXZno2d9aVzMDbz5Dbi6dW2P3JKiOLHbWdy0J4G4+PtBrzWO1zJb066H3pGU9
         Wr3xlBx0yiny6X9rmuuy3MuL6g7mBov1QLF/SwUNpIZ8Vrl/5meCpFc7Tby5Q74FqXqY
         B8QCsiSA0PFEwM4l70dod/RXCRa1z8rpRNipVkxV7xIsPEGGabcssiFiISHNBcoPwT3p
         Ppxw==
X-Forwarded-Encrypted: i=1; AJvYcCW7JxeVsBkMI/5GxUzW566P043tuoyw6lKdaoZo5yKzyiaygPdEmAUWGm4W6PxpL71swfJ/LqLpLg==@kvack.org
X-Gm-Message-State: AOJu0Yy34cpPxCRcHllvq4VphUnpimcLUfmbKahF1RC51+pNluioODiq
	2auvFa1dMyEFOSpz6AEEZmcTPtvMWqAupc6fE8nz5Q+XrKc+dyuuz7RcwPdG0qYnN00=
X-Gm-Gg: ASbGncvf7nkXKJBjGGY7B9t1CtVNdlp3LoyapUIJu5KX7FAecuULTtCwzIizgIOBNI3
	MJ+yZw1rdePUMhZyrVGpc1GVaanQ0u6W9oJ7ybNCL+sOS43GHxyzEIC6lVCD2ocWLYj3iWkmtIC
	KOzuiomcn9mmBaImKQ5Lw4KtgSpTn33TFRegeiieFJsAuhtI7rsEpiBi5h4aHYWpYGqqNGrMV1G
	H65BASEJAU0HgMys/WYYkGunXe194teM/M/RB40cB2OVus3ZmZYWk0mDstqqSoM1It5GnxcAJ6B
	CnlEKIYv+WkxissezW5IOoNGW2xf3PmvsgMbJIxPP1zl8zBmwx/+Rzw3lTCg0kplxsRsHGtR5EF
	N+Aln7IhwO+gwpudqijfTPMRou024Bv8tjneB3Sfu5WS+zXddFRPseibW4SQGQqgx8xdljBafsQ
	4TK8e9W8XIDZO/PNrbGbyvOaMUNqFp0A6EA/62LlN7I1e4jOqFP2G/oBJt/kHeEdAf4Q==
X-Google-Smtp-Source: AGHT+IFj9ZpM2DdqZcpwsXqHdAysTt/TBVGsjkwzkXEBmVWTbZUal3znf8YBaAwZI6eMSQW9iDxpEA==
X-Received: by 2002:a05:6402:518c:b0:639:e56a:86e3 with SMTP id 4fb4d7f45d1cf-64043f48007mr2792028a12.0.1761824173886;
        Thu, 30 Oct 2025 04:36:13 -0700 (PDT)
Received: from mordecai (dynamic-2a00-1028-83b8-1e7a-3010-3bd6-8521-caf1.ipv6.o2.cz. [2a00:1028:83b8:1e7a:3010:3bd6:8521:caf1])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63e7efd116asm14938765a12.33.2025.10.30.04.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 04:36:13 -0700 (PDT)
Date: Thu, 30 Oct 2025 12:36:07 +0100
From: Petr Tesarik <ptesarik@suse.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] slab: switch away from the legacy param parser
Message-ID: <20251030123607.714bbaa7@mordecai>
In-Reply-To: <2236fdb6-4616-4b9f-82c9-eba3ce5d371f@suse.cz>
References: <cover.1761324765.git.ptesarik@suse.com>
	<2236fdb6-4616-4b9f-82c9-eba3ce5d371f@suse.cz>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.50; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: c1gpkrwhsn8g613j5biurirtx4mx6xhh
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 93ED94000E
X-HE-Tag: 1761824175-264630
X-HE-Meta: U2FsdGVkX18wjUKgeJJ09r6r3DQvB8uPqN+55XcG95HzxfcM/f5sctmTEsJQjxPh0ZkQWiHzu1OxRAiB9W85efgkihO+0gNEXJSO6fUktpJCSewZhJW9QqqOjpnNkACheJpBgyArjobdtwharxifWYERabsZujwbFQzsVHl0a9Hay/5zEh0xE1JpNVZtwQ3JWoTVvksdcQSNnM0hP2JymoNVe01dAdRWGFJgw7ENtwWZN2zhrrXzTN/Df1AmU6CBfap5rGhRuVXMMyk9HJstw5RW0IH/ZJXAbXd4IFZJmsip+5gsV+RG00SwKfeiWo3tx/fqKwrvBtw/xzAmgzDcxOmrqtFO1ulbimZKP7bFbl0HNWqXCLdt2qGS4nrAEClWF9BfylHPqP/boxLfDlKuJNN/n8kh43oGDbIQnPFHINEWVFOv17GlNtOD6rrm3hl79VCl4npBQp225IrdNMhzm0L9W46es4Q8LwM25dTR73v+5AsHqmEk07Tyl8zxhZ0QKrU7tRXoBFwSmKlE8ZFP75jfImbseeeajjlxVEYB4hk5cj2WZBYxNNIGes+M5GvJgkaH1vd6HDudAqjNnyoh5nKFjPNjrU+RKaY3WLK3wf/0sphCSWndTiGG6X91cJrv5ILRZdR/x3Pc3dKp6KFntWXyiib1Liud4EjaxB0dL31NoPD10znaf1L1kZj4CkLqSo53ziH7ziM0Z1fLeY61PJwc+yX6ziwIDWHW2+1NLxgaOUd9bCRJv/3PfKs/Q/ZHdemkjDcItQ9+5Xm9jRgGBEvxlC7Mg1dj//1rhS5RRa+okJuS80voXYOCbRmYn0J+0OjgGbguzwPQ1s0kQUZNWcqoQCHC+ajr8AnRtA3KefPTcJQZXZ/V8lbohlOhT0u4XSlvVsc5wOE/DTj7JDkEAGoiOoyZ6uDMFkZuaRmm++zZ4mo/QT+cJXQ5tNyg5XyP3A8ffFSV8J0O+fVbtH+
 VKKWHc/B
 fFV9R2Pvzha4DtjNzf4wUn4hUiXW7k2wZynZzh1WSVWqXvF68/5UlatS1ipx1unawumFbL4bYbPV2iHgzN+7PSaQQ2eqqDJb51GpwX0QqyCFgwahDHYZko/xWDdOTJCq9jVTVjejM7FKAq3WPjCotHTJ2oRwFgntZWak4Fx7TsIImqbPNJBdRwdQFQv6F45b+YSb/gvsiasU9qObP+locWmYMkfMJGga+FhiTmtefmME8p9tgTyq5qtwIAYIZjgrge5Cnyx6mYb1HpP3/6LMgsAgUYQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Oct 2025 16:06:21 +0100
Vlastimil Babka <vbabka@suse.cz> wrote:

> On 10/24/25 19:06, Petr Tesarik wrote:
> > The handling of legacy __setup() parameters has some confusing quirks.
> > Instead of fixing them, convert the code to struct kerenel_param, which
> > is a saner API.
> > 
> > Note that parameters defined with core_param() and __core_param_cb() are
> > parsed early in start_kernel(). Do not confuse them with core_param_cb(),
> > which are processed at a later stage.  
> 
> Thanks! Added to slab/for-next

Thank you! Appreciated.

Petr T

