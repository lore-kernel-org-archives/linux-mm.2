Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05856C44507
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:39:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E484F6B014D; Mon, 13 Jul 2026 12:39:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCF0F6B0150; Mon, 13 Jul 2026 12:39:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAC3E6B014E; Mon, 13 Jul 2026 12:39:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8025E6B014D
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:39:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2B4791401C2
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:19:55 +0000 (UTC)
X-FDA: 84984113550.17.83B2C53
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 55EAFC0009
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:19:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EH8kAIFx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783955993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vM1i1jZoHTS0B7SnDsHk8BQVDep0PXFLMf+X+qdrULM=;
	b=rQlLG1rv5E2UsoRUy9jg8bRMATi3mWujjVysrHSZDAnUqX3dHMBtmSGVIl9/ZwajHxXLmO
	YgYJIPL1B2E4NxGTSdpwgAQemF9qSqhsJLtJ3xRsrBaILZ/fwhjP0IMsNnIgM/w5kqlsAj
	sHbij6dIytBDf/x7HpxIsaA/h+Y9gJg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EH8kAIFx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783955993;
	b=nFY+SPkiIAT0/WzbGz6bE0xyFZdJt359e/cc/cRtXX/El/uiec+NjtNrJnjRNNkZ2PJVTN
	IwYNioJVwltdmZcgB3TOV2FqQQC0LY9y/BI9DDU8l/rEaHgIM+XuPPbFTcWR7GPKCTTSVy
	2N/Z6yybteJnW9nj/CioqlPnKKk6wx4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7A0D8418C1
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:19:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619C71F00ACF
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783955992;
	bh=vM1i1jZoHTS0B7SnDsHk8BQVDep0PXFLMf+X+qdrULM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=EH8kAIFxWGapnEQirdcM0epSv4NNBvFRggx/mF+i8Y8y0TlNYzcm3mzEgsozMPnwd
	 fSCjg/Bx++/kGd2Gad71M0We/sHEKx9NPjvQAUJsCppYQxqDkb0O8cOnNDSDfbCdTp
	 xWFkCcFqVmpTCPX8rti5oor15s3IPoQuM0Jg7sz6i5KWX9MqHKtVKRjjygJ6MEJw7S
	 SjcyxoHv/1P1BAsv8w8EHxDpZwrb6f1xdaa/liHxJ5kd5XPSjAy6SbpRviLOYWNtLZ
	 +TVRyVN7fe1NBElg8d4U8M+xNoIkxOvoQM2kqwEgzlzBMj9oe1OcQQWRclNY1gUznR
	 0FGYoPELuHpCA==
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8ee43b3e5abso26746276d6.3
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:19:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rp5cYVO0y8D5f4HRT8J8W4TW8dLdLjvnC7NzTCRqRkXkBqXzYRSFC8hC9mdmVd3+O6meWEem8F3Og==@kvack.org
X-Gm-Message-State: AOJu0YwTj9UTftO6oShV0be0jNKKgeyEHJbLOJnRP8PoMf27PLVTiHnC
	9kihetC3n7n8QB/ctl4vovLIDFQc8rnlyWLgX7BIc+/uuDX+Gg4ZQR3xwsX3EiqYLYtFGvk6eQQ
	5HIJNqorv5Bcn6vI4GsjBq3Tfs0fuvCA=
X-Received: by 2002:a05:620a:708a:b0:92f:e23:c45 with SMTP id
 af79cd13be357-92f0e23282bmr301731585a.60.1783955991561; Mon, 13 Jul 2026
 08:19:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260713143534964Cml5-QLfcPMDtbbq_j7tG@zte.com.cn> <20260713143707966lCkTinO0i9zYAc1K2ZmqZ@zte.com.cn>
In-Reply-To: <20260713143707966lCkTinO0i9zYAc1K2ZmqZ@zte.com.cn>
From: Barry Song <baohua@kernel.org>
Date: Mon, 13 Jul 2026 23:19:39 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wpPqYdd5P4h0vT5EuchQNr0+cU3TTuf4doCpEBqGUfmw@mail.gmail.com>
X-Gm-Features: AVVi8CcRKxUImzl6LfiBnwEMDoKu6qAm8hC17QVKyl4E6WKSshZCOaCBEJpgHUg
Message-ID: <CAGsJ_4wpPqYdd5P4h0vT5EuchQNr0+cU3TTuf4doCpEBqGUfmw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm/mm_slot.h: add a helper function mm_slot_remove
To: xu.xin16@zte.com.cn
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, lance.yang@linux.dev, 
	usama.arif@linux.dev, chengming.zhou@linux.dev, qi.zheng@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, wang.yaxin@zte.com.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 55EAFC0009
X-Stat-Signature: rmkbon68xo9skmyixzdm3ud38paqoudk
X-HE-Tag: 1783955993-745042
X-HE-Meta: U2FsdGVkX19ewaJT0dZS4ApHJub+Rx/ztBSwL6Cx0TQCfqr4q4/dk9RaY3PWWivRct/2m8sELoZ1+K7P/hDxrPi6Q+rRXX7/7URX/BXe5jSAMWPTiIhw0NsL3TgRhmQjti+P1OTIHXLojFzrml9gcMeSw5OMBlxWnCAxwGBD07XCFq5GrJKW/dNZUq8t5LoaosGDPSOJky16IksIc+6jXe5ogtiWpJ5+8oIfhg/GoyjdusvxdphLrR0JSgLu/UI99uYjfTGPBQ4JZxcPz6suTIemnvqcGYL9cl/mqzJdafKmKtD6RCatnUR+Z4G6ViJCpyfEQotB592ziOIsFUGo7a39EDlYRiW/33vrwXzm2c1RNRl89eAcgrJkrHChfF9OWxRmITYoHKZBWXQk5Zj98VhS1eLuLdiHukk/luY/Znzzv/Wvn6IK40bFnJsRQME3y/2GuZaRdTZwQhCJlbWbk0OYk0cW3Y8ljzp+WH9VcouXAw7FpdXYUOlns03S9DRFoFIWJTUwaF/evyVgip4hqNG9l7jdGeLHSLkg+/qcLoy/aLLAiJPBVHfU5QwB2l6hPzhLzi3BJdJp0b4yIePHSDku0IP4XonwOxE0+KAb03hk32UOcufSMRiCzk0xPfj022jSv7TQdovKIRyXa5Zpap73+DQYqEo2ezGLZZGNvYylCFqJ2WfzVvzgULzBaNUc3tEmypu5G/iEYTZQuYYwMY7ghgif69CvrGW3bQT8ZdaIeDK6DHT8U8YBm/P0mOM4TshA13Vld23ThWoPvJ7pLlEV1OR9SjY0HFQfea048bn9VhyrbvIFDF4OZlXCNf4/g+DK9+X+XbJQjJL4b5AzMcj6m7Zce1CfEJjeECsdoSNm2xjxZGzwUB/PjQCcizM1D1XySls+qhtajS5/PYFj++Qnx3K+KrhG4Q30CBZRRzCRqEDA5se+HwT3hrvTicjCVD45CQRanVHUYLaW/pb
 pCbU06qk
 jfqOntpjTxFUIQmghXGnbMpDogEzt3N4lGZ10GGwG1BZqnQ6JNGvD6faNTVsKWbtFmaUJiwRvtUc8SQMSv2SaMWDZAkMEOmVmHRF3RuXgVKu3gxJbPO+mR/3xMIZYCk2iLM7iODtEJrwmwpJxqA+xvIHniJKG13jhdDchlDnkqZenkYcl4qYQpC5ILfP5mMbKIXWjeFBuh/a41Zg9UHr1L+DH9Qz1QzxQp5hzebYu1y7BHl1B5+8xXaGD1v1Pgl5/R5l6IA5LK84qkSpntrI9pYAdzie9GUC0Jo+v3mqpFQdqxYWHva5KTXjmAHXCuNyJgKSGGxpoFnOq25EX9nJo4B2S9m0+xx1re4BD318jCu6pVhD+wZFktXxj2sJQsfHXRdxEQuaK6Nad0EqCniU6eVtSyrl1nTWsm5v9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 2:37=E2=80=AFPM <xu.xin16@zte.com.cn> wrote:
>
> From: xu xin <xu.xin16@zte.com.cn>
>
> Both THP and KSM manage per-mm scanning slots using the mm_slot
> structure. The slot is kept in a hash table and a list, and removal from
> both containers requires the same two operations: hash_del() and
> list_del().
>
> Introduce mm_slot_remove() to abstract the common hash_del() + list_del()
> sequence used in both khugepaged and KSM.
>
> No functional change is intended.
>
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> ---

LGTM,
Reviewed-by: Barry Song <baohua@kernel.org>

