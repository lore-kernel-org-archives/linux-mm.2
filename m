Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF7E4CA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 11:16:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 175236B009A; Tue, 26 Aug 2025 07:16:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14D2F8E00A8; Tue, 26 Aug 2025 07:16:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 063706B00A2; Tue, 26 Aug 2025 07:16:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EAE8C6B009A
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:16:39 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A751FBB33A
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 11:16:39 +0000 (UTC)
X-FDA: 83818655718.17.AE860AC
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id 396F4180014
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 11:16:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=IRsdJO+P;
	spf=pass (imf06.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.221.180 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756206998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=13+ZKZHSBSlxWn30sItlJ+MHDakals4QsmIVvRoAzjM=;
	b=W/rl5BnzPFPmj4PoeAD8stYMEhOiZRoI4xHN6xPqtGLVXPoLrtfjo31RUQgTLHX8GCyLE4
	RFkRzbRNRniLW2a3UmMivIJJc3yrPz+pxhC6NVdKSpsAWImTiOnWE2jD2XSTF2sDYH2lub
	tTPuiX/U0J75yPzlxAoPo8apfVmwSXo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756206998; a=rsa-sha256;
	cv=none;
	b=tbpzORWh4uhLkguIk0F00YcdwDk9fEaWldU/ZZcykpKB3HNAX55G4E0cofqa1cCiOEEpTm
	XHJHcsmg/b6ginooimzv8Ci0W6n+MxhSAd09Fqo7n9lzfxtKuYplPP77A6BsnVXYb08y+z
	0+P7HsRxCRcVkVBFhRBO+nTB2kb4184=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=IRsdJO+P;
	spf=pass (imf06.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.221.180 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-541f5f6385cso602460e0c.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756206996; x=1756811796; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=13+ZKZHSBSlxWn30sItlJ+MHDakals4QsmIVvRoAzjM=;
        b=IRsdJO+P2b/KEw+ZSlLK+5uSPtEU5XnLpicOwIYpmDxN2lGEHx7S4e4SfT3DCSPMJQ
         2HqL1MrBpDcensudLLPtPIi1S/+3wJkFS+XiToT+tYfCdHBaauMsJ/h0VMJNToNFqtq9
         6tIUt6RNSkGnoOdCadllFuSkYCq78+JsvnVmHibDAGYhj45/hokgOogu4kB4gfxqMHn9
         CEFnvEAfUMnPPILXdPOdmUy5wLi8VvHQ8mXC+KA98pewTjc7KnrE3shEj5XKEIFKRxGG
         YPD7j8+WVSUB5qxW1io3HkqyZgm72YWcNza/GQkAXJQ4DaUhbbktbXnik1WU6Bm4isCY
         5++g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756206996; x=1756811796;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=13+ZKZHSBSlxWn30sItlJ+MHDakals4QsmIVvRoAzjM=;
        b=PLRSHbrxYtYWEVQLhX4F0BEQ3xGVOoWwXCuZ4Tj2OdVcyNsNlNkCa4VJBnWjtYi5U7
         UKmEuvwo4UACh/Sj9tD8oPXzo7BaFOTKeQoTGJjrZeaH4mZGNGe8CWwiOAzcexI03m5s
         hhiFcL6U+d60YJ+Ab96c2KGP5Rh8MlbU7t/I4qxpKUJIdoFkyWZZbPKSBcaYJ/Q+vafM
         JDgxo07dql/ZIzOdTkAOVqXIu7DSuw+3pd2SYnPkBBp5FOVhtzdCxhAwUiUuDIoAHEqF
         2tw0juh3w6iXJm+0ABhhh4fXrJi7SykgSnymTZ7cXHTLZROSzq32caUGDwZNBgQ2fS9m
         6t1A==
X-Forwarded-Encrypted: i=1; AJvYcCWxVx2MFJlgIQYZdbZnseF16zv/ibGqezraw0EZILS6k2dVFkqiR9o9GxioFXV8wwx5YwBN4CEohQ==@kvack.org
X-Gm-Message-State: AOJu0Yyd3cXRUnOpPzEIqePQlW5EsOUOO7ksB9ueazdDK8DhGjFCJ/Ou
	9btexEu1hnH6f2zhcn9w/RDFYM6EII5nKcaM6MWZcmIIekQ4QeJaGb3Z7iZ/gydIN7e1FQ4r788
	TGkQj0Nvd0AjIApEpl5lHBlhJ1hSh5mkZZTsDwb0pGw==
X-Gm-Gg: ASbGncv/urbcMIPrYoS6wc0UdwkBDxWRIUYcsbzAP1Ysf/R44aGCI8o0+4+w6CEsaEg
	TaUYZxzIIabsqErQfYFHqvT+sY4xbPrb24kUAzp8VTlkGQ44ESuCllLaluIEQBXt8vNux5nby37
	MqWzWUe4J5t6/SEpm0YuPKOpglBnwbGtoPrv5Qm2oAJ8lQhooHlvMMu85TOPV2kk10RLozKzuRr
	9S8XvTp/iRtnsUOrOe6BQdLG0rv
X-Google-Smtp-Source: AGHT+IGLaaBqvt9XEIIWuswTMJEBdxRtANkhP57jHYijW1XkWUKRdvmPkMfPUDOxuY2T7Sa3m41LxDUj4QvUufum+Qo=
X-Received: by 2002:a05:6122:181d:b0:531:4041:c4c5 with SMTP id
 71dfb90a1353d-53c8a31dcbfmr3724012e0c.7.1756206995825; Tue, 26 Aug 2025
 04:16:35 -0700 (PDT)
MIME-Version: 1.0
References: <20250825145719.29455-1-linyongting@bytedance.com>
In-Reply-To: <20250825145719.29455-1-linyongting@bytedance.com>
From: Yongting Lin <linyongting@bytedance.com>
Date: Tue, 26 Aug 2025 19:16:24 +0800
X-Gm-Features: Ac12FXyevGRiMRbSCI3kYQcBRsrIKMzDdG8JNBs40u_qfXYdnjAXQlDzDqSNaHc
Message-ID: <CAFuXZ_WHC6XtzuiuS-VBpAotOs+e5Z3toHY0jES3+hCXC9AUgw@mail.gmail.com>
Subject: Re: [PATCH 0/8] Add selftests for mshare
To: anthony.yznaga@oracle.com, khalid@kernel.org, shuah@kernel.org, 
	linyongting@bytedance.com
Cc: linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 396F4180014
X-Stat-Signature: mkd3abdo53g8nez969x9qcaiw3c4zkmt
X-Rspam-User: 
X-HE-Tag: 1756206997-358100
X-HE-Meta: U2FsdGVkX18ZSk3dBIVPrG8Hx8w6cW5MP5l/A+qf5JjI/4xwsG8dxxTfN0wBYTLfjIEQvSW+IJf9v123nZN7A2+POBBW1iL/hsWW0nxIsSDIwECbEN9CBUBuGZiM+JQ9ichZhgv+KYCHHODaLrSOGzP5rtQefmleUKq1px0YoqSbN+hBkAd78gz4UloPMIa2jVCKxbviKqqFicIUuSnqN5UBULBfXyQhI+nNV/+4HQ8GColkcIX7PV42hkVQT9xeOhweGtf4eHeGDcqc3orJIVwzJWO2s3JomRhHA2D6nQAqBVu8kbsNK0xcYuB2hDHEEZQzUywtEAMvI16QGcSNddK8vyylHz0jdvr8Jkbg2Yt/GDW7eag8iB0rk9hMtyX7QWLea7T/tmQj+PmaVtDXn7iQMaWZ/TwsZC90hsBKbwt4n562/UUJkjB5H1OfpAvRC4JAYRofBp/VNdvE9jrRveEqaq9hILHDWjsusb7/qA0rPtTlikhkBW7PVRXlSWpltZBwKxPiRasvQC56BgBgY8JT+kyPGsTI7NbFJqq8dq+pPb1ql54Ms3TbYq8zAdovDUFxrqQT8wr2rZ6xDcDF9jLhVPzJgh7Zf0vK4Avm4Z0sE5C/lhWs8bO2LNKQPgzKzdvYlPRxo7F0/fufItk+iebtZqPuoOud+AHf0rNNyes2I9/nfRfs7slkm3asi1hnDoUsl2hm41cadFpC13fTUM5GbFsPzhYT7Oqp/ii01w8MsBd+rtHpJP2nTvQh2bHLsvH3UtpfDgbNNAnIZiTQwQSfM/XatpXq4ZHSt8YvkWeoy1iDgUO+BvcHJkD0aK+XN2Qkt6DhDU8MF3BzEJQ5nG/IbZN9JMsmyKkjsmALpn2z2eAeWsH9RSmDbvL6rsM/mJw86jRYxT1JoPxDqPAihHbjUweFiZ2pn38CzUc21ag=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry for the mistake! I accidentally sent each individual patch twice,
except for the cover letter. Please ignore the duplicated ones at the
bottom.

Apologies again for the noise.

Yongting Lin.

On Mon, Aug 25, 2025 at 10:57=E2=80=AFPM Yongting Lin <linyongting@bytedanc=
e.com> wrote:
>
> Mshare is a developing feature proposed by Anthony Yznaga and Khalid Aziz
> that enables sharing of PTEs across processes. The V3 patch set has been
> posted for review:
>
> https://lore.kernel.org/linux-mm/20250820010415.699353-1-anthony.yznaga@o=
racle.com/
>
> This patch set adds selftests to exercise and demonstrate basic
> functionality of mshare.
>
> The initial tests use open, ioctl, and mmap syscalls to establish a share=
d
> memory mapping between two processes and verify the expected behavior.
>
> Additional tests are included to check interoperability with swap and
> Transparent Huge Pages.
>
> Future work will extend coverage to other use cases such as integration
> with KVM and more advanced scenarios.
>
> This series is intended to be applied on top of mshare V3, which is
> based on mm-new (2025-08-15).
>
> Yongting Lin (8):
>   mshare: Add selftests
>   mshare: selftests: Adding config fragment
>   mshare: selftests: Add some helper function for mshare filesystem
>   mshare: selftests: Add test case shared memory
>   mshare: selftests: Add test case ioctl unmap
>   mshare: selftests: Add some helper functions for reading and
>     controlling cgroup
>   mshare: selftests: Add test case to demostrate the swaping of mshare
>     memory
>   mshare: selftests: Add test case to demostrate that mshare doesn't
>     support THP
>
>  tools/testing/selftests/mshare/.gitignore |   3 +
>  tools/testing/selftests/mshare/Makefile   |   7 +
>  tools/testing/selftests/mshare/basic.c    | 108 ++++++++++
>  tools/testing/selftests/mshare/config     |   1 +
>  tools/testing/selftests/mshare/memory.c   |  82 +++++++
>  tools/testing/selftests/mshare/util.c     | 251 ++++++++++++++++++++++
>  6 files changed, 452 insertions(+)
>  create mode 100644 tools/testing/selftests/mshare/.gitignore
>  create mode 100644 tools/testing/selftests/mshare/Makefile
>  create mode 100644 tools/testing/selftests/mshare/basic.c
>  create mode 100644 tools/testing/selftests/mshare/config
>  create mode 100644 tools/testing/selftests/mshare/memory.c
>  create mode 100644 tools/testing/selftests/mshare/util.c
>
> --
> 2.20.1
>

