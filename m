Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0819C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 19:39:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A54316B0005; Sun, 28 Jun 2026 15:38:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A04116B0088; Sun, 28 Jun 2026 15:38:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91BF76B008A; Sun, 28 Jun 2026 15:38:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 683C26B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 15:38:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C40454048E
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 19:38:58 +0000 (UTC)
X-FDA: 84930334356.12.94BC823
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8680380003
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 19:38:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Z05HUhdD;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782675537;
	b=fo33o6AXHaT4vj2qfcsY71/6OA44bOvzBXc9K3mJoMqWQIzFqfLLee0bG4iWNlKQZ0eObk
	2OqN/XD2TwOIc/q0nNhJpjxTleUtNwcxOOGsn6HAr7jBsQDLxHs87nmgc6MZQRdU9E4bOr
	SuCIlzzwKWbaUkeT8ryU7DBzfSE/Tn4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782675537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CuTzCncB1dSE/gH/AIAOqd09rcNMzjDsf7JAoAwCjrk=;
	b=V6hCHuDPAkC9+iUn+MeIE2pYR2hQG7xz2Q36ihPYRMiieFuHBhRzUpIeQkTTi4mjCuaxux
	Txj3rD3NnV9Q/aL5pxi3GYgbAQU3vBLTzRYo/R4YeG7kF3UiC9p7fUk8x8jlYxh/vVB+z7
	O49WzuQS4gbwMxruLupHWWAmmsBJhdw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Z05HUhdD;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BD284160D;
	Sun, 28 Jun 2026 19:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A081F000E9;
	Sun, 28 Jun 2026 19:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782675534;
	bh=CuTzCncB1dSE/gH/AIAOqd09rcNMzjDsf7JAoAwCjrk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Z05HUhdDYeLWuSpWdVqthRJCkd2YEuESciZULtAVFpQQQVWrW5D/AUn/d8OkI0gob
	 QXfvNiQagEL4yjesc0PXEwstDXkfJL9SY9ULCpX3sksUC/gDebY8MXxxfQihGeBf8I
	 GQiI142Yka5uXrMWjukYJC/ZkHhrR8UYxwkfFyws=
Date: Sun, 28 Jun 2026 12:38:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sourav Panda <souravpanda@google.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
 surenb@google.com, fvdl@google.com, gthelen@google.com,
 rientjes@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/hugetlb_cma: support percentage-based hugetlb_cma
 reservation
Message-Id: <20260628123854.862fd5d430894fe451b34323@linux-foundation.org>
In-Reply-To: <20260628190155.3655895-1-souravpanda@google.com>
References: <20260628190155.3655895-1-souravpanda@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8680380003
X-Rspam-User: 
X-Stat-Signature: d759szcpcynxbnna54mazzpidnp77rqg
X-HE-Tag: 1782675536-142257
X-HE-Meta: U2FsdGVkX1/kezVgEffsR+C3FE9Ggzftu9CVb9/H9TSp7W9g11sMZlWlHzxmPXef0bdl5kplwNDscNzB3GPxKG6SH9tQdqUsU07uWsOBPiLMdnpuHwucbvX9XZ+SI+gPLbo9qRJttfyAMRcjodVBiOTI5QYeBueCdXIJzTCdLDmZqkN80BHAn7Wz/0i1s9Ncrb1ZfeKXvzaV5btMD0kM0+ERqDpIG797r+5R1OdoP9SGMgRKEJsWlaeNQqxfI+lFhXIFzlmgZMh8IzyB+sbg+jjbmAc28P8SQlFgAEG5si1WSqo7rAugkHT6cMfmCEmUwE5tg0QCf27vOxCZdpBFY4DQExUv+J5Ypn5Bp4dIOrwyGCrtwNutrpT+pr+Z9VshQciwa5ri6BiCeyHbSM9COoyOEzUepATLxeX4fjjPlzRjQ3alwWDIcwkI1917MZmOmF5vun76y+/JVPG4IRkdT3VVMgpXSftp+FoSg5lD10LehzFL2v0iQlmnmdIH/a+pxMHp/1EZ7Buz6jXSo6vMU2nl6sw/hi8tXR8EQhFx0+pEX2YMB1vg0pudvV37dTDrL17Hid1ju9CNnO7tsYTtr69EvEv+WlEcCAM1IDRT7ZbaxKiB057VDcDpZVEMPseUpf/wHjVrbSzXETyPsdXZopI5qSdrfN1HSl4b00uR7DMHA/jM+h2PPkK+Pc8QUj850dUd7b58CRPOMEc2/Vq/ApmaRK/TnvWgZHDFsyfgbWjz9KH+/5PDwPTqqCwOX/5DZDBRkXChKxY+cXxSEyDllgwr14cfwAOgSrKb9fL8hZG4bG/N26ylifQEve19zk8OHc9s7xbU9xi7gaDcCPtzZ0iJ+TwcmKKTebDSaOwTCEFl8Lz9xFBSHccFkymAQKt4dayNZ18IwrNl4JsqkWSdrhT0/sY4WH58MYNGeLZyFPaYGsmtcC9gK/Fnk1L93CWaezeD89j1alpwXAJv3zG
 OwJuW0z/
 UpXJ/b+/L1BT9Qp9RujSwIj+5ZFgOD9PYRwYeQ291pOEFLJgUynLZYVlwsi+ArtRdD/XKK3qQIoygOlegntMf4/m6SHSLjnzyRKx69bHS5bIal/WStTvJUs2EwHSaAB2064CUcJJvcpqeBgjmPwGHzgaFh8kxOGT46IEIlQqImf9TUocscOvAb7idDiUSSyXM48FYinPDPuOKiEW1kKUJPfggKZrl+k2Tw2uqoQILuaz4l61J5EaN/jrrQvEADL5T4Js99jrvEbCSRTKcC+cuR7TP09sUI24MFCkH+M56qEsmkTQRroyUdKR4rKX+b8II1e5ryVp9Ocko/yDdM6FVEorf4ZWcd6Elvw0g7qi0hEKowSmXXf1Y0xjp5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 28 Jun 2026 19:01:55 +0000 Sourav Panda <souravpanda@google.com> wrote:

> Currently, hugetlb_cma reservation only supports absolute sizes (e.g.,
> hugetlb_cma=2G or hugetlb_cma=0:1G,1:1G). This can be restrictive in
> heterogeneous environments or when deploying common kernel command lines
> across machines with different memory capacities.
> 
> Add support for percentage-based hugetlb_cma reservation (e.g.,
> hugetlb_cma=20% or hugetlb_cma=0:20%,1:10%).
> 
> The percentage is calculated against the total memory (for global
> settings) or against the node-specific memory (for node-specific
> settings) using memblock APIs during early boot.

Thanks, I'll queue this for testing and additional review.

There are a couple of pr_infos in this code, to give people an
understanding of how the kernel has sized these things.  Would it make
sense to enhance those, to help our operator to understand/confirm what
effect the chosen percentage configuration had?

> Signed-off-by: Sourav Panda <souravpanda@google.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202606262023.IKUrn01I-lkp@intel.com/

Robot found issues in the v1 patch.  This development-time info isn't
something which we (at least, I) normally include in the permanent
kernel record.


