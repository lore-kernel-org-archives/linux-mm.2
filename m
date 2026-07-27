Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81536C531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 04:20:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1212C6B007B; Mon, 27 Jul 2026 00:20:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D21D6B0088; Mon, 27 Jul 2026 00:20:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2D466B008A; Mon, 27 Jul 2026 00:20:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA0456B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 00:20:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0991B1C0D94
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 04:20:44 +0000 (UTC)
X-FDA: 85033255608.21.582219F
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id 17FF6A0003
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 04:20:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CtJP6dUD;
	spf=pass (imf15.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785126042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HRtjz77w8Vz7f1z3O8tUeRdMvuT4xbXaziStD0dymQc=;
	b=3s+UPhua9jV5q/4ILHs217MvDBW2FkZB6tjdgvIwbwu+WycYp+c0/meb2vvf8o3q2oC9tZ
	AhYiVpbG6Kwwqv7Wqvc1V/JW2zRmKS/MfdvR9p7JWaCBp9gIvC2aBzQz+4ceFiL6/DEOeI
	RprgWWaT1Uw32C2sA7dcheqM+YJdQQ4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785126042;
	b=EB5pE9C3wG98p9adAN9ojKMXCimt7v4/vXjtU4c9Rv6IY4K1/iwi8fopMJxg/P8P+0l+Kd
	jQUOS/6xYGT5aQCcR5Qoyo7kl6p18kZ3aa+LxfcAPbGRXom5ibTURTN77xD3Rv2wwkS1mV
	jSpODeEe/uvqGQ2Z1+vpIgFq+rQGBKg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CtJP6dUD;
	spf=pass (imf15.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51bfad59921so17674331cf.0
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 21:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785126041; x=1785730841; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HRtjz77w8Vz7f1z3O8tUeRdMvuT4xbXaziStD0dymQc=;
        b=CtJP6dUDq68sfB14svCv4FKWb9puYyKZUERboJgGcf3JA3wgTesGnsMqoxydexlEsR
         wf1mHbqcjmODA3ywnfR7XSItIYfnuEqTC8szDLmeiVOEI79Ol2j3qGvSWrI76FZJidJZ
         yEx6Udi4sKSYw4nm/RNEXzuM7fJsIWQ06BQspLfCki+IWHXYwjLEornncyjjKEiDtA2W
         8LjqDBXSe4tmC334dZAcrO83nI6THIiKQrCta3f0nZno/E7WgC+XA4UY1j9Jrff3Xgr+
         +B4PnKbWQh4gh3L5Fbyn2pqydtIxQ6+3+MtVI1PPSZeCEPehxLjrKjfcgafYD4MvVLBV
         X2Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785126041; x=1785730841;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HRtjz77w8Vz7f1z3O8tUeRdMvuT4xbXaziStD0dymQc=;
        b=OHUchi1Zizb05pbCf4bUsh4SawsZ7qfygBS0kx37wJGTmSHcvmLvg2vk/bmOScZsEC
         OJls9SLtHXbDDZjOZVApsaizC+I8xbhOuOo+jqWjL/Pqm0oVb7To5Zf5tdmpO/6Tz6He
         e/l1Q0+lvVSe9SXVdqaqgTij3rThlm0wa2Mmaslmz8QxWlom0M0kgr7UCnP37BBrDGsA
         tWIRhyOMWU5dT8Ybu9V1/AcWqLIND5/LrMBe3ucTJESjhLaTyYCbqKWeZn6khi7aTBYX
         mP9OC1my/6qok8cFLAxtba/hFChZtUdMNSto0u1Eb35X+21s0wREba/MSjqEHutVwFVv
         h0/w==
X-Forwarded-Encrypted: i=1; AHgh+RpKHPaTY6J6flIZ9Z75IWeUjSNjWBAn6VzdQN8zGT9JiN+Qx/Klhe7XoqYkTgnKsvq9QA3I9XHHAw==@kvack.org
X-Gm-Message-State: AOJu0YxGH+d+3dOxcGiIJamiVw1NwcgTvB8BlgyfdCzFlpzXiynPXk83
	sb6Be8qz0z32YxwRZ5pfk669iu7r17LNSxFH4D+MpuEKAA0UOuNU3sNp
X-Gm-Gg: AR+sD13pktCoT+AgUBEL3+MshadJ8rJrhR3eLEbPtM4RAfoWpEjXtYXlxPFyTnJV+W0
	GCcREqa6LS8qslHrlRX7PqgEk7qGydIfO74IWO3yXBkOZ2eblc6b7ie1knXiEuTBcghfDX4mqN4
	Zm0L1l9XBykz4gRqGkoE6lKvdKYzMkXHx+EzH4pag2aMYRTXyTp1HLnQAZN75HVueox52qAnPck
	ZqKFGP7uhyagzsngvXduCipy5HQvehNz6E9I+Pog0iCPEC0iThnpqhGwHXutZXCPwzTeJLbAHM/
	eijCI6qdgKtKuSy2djFUrfw31AEgiVvHabU03EG8av2HDdYOdJKVrrzzBDv5+R3DKFIOg1I/cbs
	ju0dVEsWuS08CUIRW7Ad39mg0u+jWs/RxPoazK/1BxuMsbP04eDUV6K7Fx+COzlmmNTuZHnu1A1
	N6GMAMStgxEWvwVSts/pVwGzTAb+X0clWzBQ+C1SiVOCHTujHjM4Eapq7S62PuDR4YZt0q1rj6w
	gJfIChhrvfwJdAX
X-Received: by 2002:a05:622a:120b:b0:521:5c5:f986 with SMTP id d75a77b69052e-529a84c3c59mr70062121cf.33.1785126041192;
        Sun, 26 Jul 2026 21:20:41 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-529a27cdc4csm46594951cf.2.2026.07.26.21.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 21:20:40 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: oliver.sang@intel.com
Cc: jack@suse.cz,
	akpm@linux-foundation.org,
	david@kernel.org,
	fmayle@google.com,
	kaleshsingh@google.com,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	lkp@intel.com,
	oe-lkp@lists.linux.dev,
	surenb@google.com,
	willy@infradead.org,
	baohua@kernel.org,
	Bo Zhang <zhangbo56@xiaomi.com>
Subject: Re: [linux-next:master] [mm] 7b32f64bc5: pts.svt-av1.Preset13.Bosphorus4K.frames_per_second 45.8% regression
Date: Mon, 27 Jul 2026 12:20:22 +0800
Message-Id: <20260727042022.3503727-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <ama/sQIK2O0MphL1@xsang-OptiPlex-9020>
References: <ama/sQIK2O0MphL1@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 17FF6A0003
X-Stat-Signature: q3u1gnaai6bsbo68xybuxtgrk5oxajcz
X-Rspam-User: 
X-HE-Tag: 1785126041-434018
X-HE-Meta: U2FsdGVkX1/xsmYZaGHsjBKBj+dm7AEfl1MYazNMXS7+YiM8Bigo8+Rs9KLVFYBqBDg39Iviy+M8L0EYbQG701ZRcao6d4c6lSQXXAb3/WSMeLTer9EMwFMnh6MXbfxVCNjbCczDsBJ1mQFS4oPO+RVT450enU6nSOx9gdexJ9KhP9MxeoNJ2OgIF2SqWXaYRJSYdZXUzb1gN+B2ID/UUYC9YuR2Y22YeEOYkgxbgq0Mea3ohJdUysiALjQMNKU8sV/bGS8HpsXio4hrNfUt43RTv4WH5krB7jX8eGll9WuChmFuHrbjtD9+GVaI0HfPilH6uPLihvpMBEQyBofa4R8I/YuuBqnPO6Wl0p2aRK6Ms8t2creWlQcpx2oyBm2pbGdcRkgu8u6VUvh/0rcCN9oGO8IHrEPdWiZpq0+wNrzVpXI516Ik8pxKvTDUSAc1JY0KLr7rj9UdimfvAf3NJdaLxTctmqYdMD538MCiJLayUCftlgR2IpXKHXYQzj6o88YRpnG+FI9roHla5qslAW5tknpopUnifBVaaBK7UQEeqm87CZ8MQUcfbAUyRmYMDq8DhX0b/rgaxrdmSfdUDOnKaJdp9673jvw2mD4Ldobrm2GNyXWpwXBqtIXu/DzR6Q/iyq5hfqZqz+8+iL3RrmXP8QISPTABMryX91GYal4cgF2kaHN0WxyfouDsZ5Fr8IcyU1GuxHin7poBf7PwhSFUqQ5plR6p8PIggcg+/uMODdNpkC+aCHTFwrkBxNnxMvKcPro+IA/9JwF85VEkr8u2lPAr1jkMlrOCgp/qV1F/rjT3/xQvWcItyCBr6Jkdr26f9o+FuyKEIFNDeH4kYAiS1XOs/wu9XFEeiojyQxQPObx7Tv4qnxxKEB2jjVpSerJakNPXoOF/l51wgRL8T9LUSrjskrJo9VgxvJcetL4idgoQahc5MlqHTBQu9zoPnsS9GlzOhrAnN3r2Nrr
 y5S6f+jy
 R+wIeTnqX1DlHqYbkE4pPKjw5cWX/VdOlSI/2XEymMoM3gETJAkxBNzbrZb5Pb4KR9da6e3YGIlfTIdCfn085Ac5XxGZC9zibS3FdTH56srDZEQgHYMP4aVXd2nepjkEFn+2vfvK8E615D9RUTaVcgh5KA1GgIPX7j5HRtzqGuOdNqqudTxQkZ7l4QwMXLMEVAcU0CLY54Dgaiu2P6Gp4tGGUC+SV4rP/HfPV1bzyKoDfcsGTak/9Aww5LJZPZ64+411NNxTlVzn2ZuEBTEi0JPdc8QYUxEO0DSvCxD31M5U7I5/LKZAVW1T8lkpyNbE3SiS4cMfeoeKuuErq/wxRYZaAoSI2aORe5ZlXEfp8/U98UOJ/wLK55fhSEtk5a+M8jgXqKFDLG0hd9XyW3T9HEy5CT05Faj4uTbgX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 10:17:21AM +0800, Oliver Sang wrote:
> quite sorry that we lost the machine we reported this regression, and since
> pts running need some specific settings in our test framework, we still need
> some time to setup on other test machines, we cannot start the test soon. will
> keep you updated.

Hi Oliver,

No worries at all, take your time.

I should mention that my patch may not fully fix the regression reported
here. It is just based on my analysis of the code path, but I haven't been
able to reproduce the exact SVT-AV1 workload.

To better understand the issue, would you please share some information
about the memory access pattern of the pts.svt-av1 test case? For example:

  - Does SVT-AV1 mmap the input video file, or use read()?
  - If mmap'd, are there multiple VMAs over the same file
    (e.g., from mprotect or partial mappings)?
  - What is the typical VMA size relative to the file size?
  - Is the access pattern sequential, random, or a mix?

This would help us understand whether the regression comes from the
async readahead blocking I described in my reply to Frederick, or from
a different interaction with _max_index.

Thanks,
Bo

