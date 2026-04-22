Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB110F94CA2
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 00:35:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC8286B0089; Tue, 21 Apr 2026 20:35:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E79326B008A; Tue, 21 Apr 2026 20:35:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB5E86B008C; Tue, 21 Apr 2026 20:35:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C8CFC6B0089
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 20:35:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6D7EA8DA94
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 00:35:34 +0000 (UTC)
X-FDA: 84684323388.25.CBA4A41
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8452540005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 00:35:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EaB5mkUt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776818132; a=rsa-sha256;
	cv=none;
	b=3hppy+fWkUwKEn0d2NCt2oGB2F7Jxk++5gZGcXLM8C7tlDEGwGxiI74aHVN6a8BRe5gEWy
	iAh+31h22VkSYff6k+WOYXammqmkKn05+T7f3jmfhQWzY5DR3TDMpZckPn30P0c7w02BBe
	V9QJpuWQPcl0Y8LyDNGI2wFGfnOemII=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EaB5mkUt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776818132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lVYBYcbMKP9T66v2BVVHPkUpnYU8ZtQu2qMfVc8wIjw=;
	b=1iimAI0RHRckB6v6R/0cAulmS2ZSKuWeBmGokSGfUQwzRQ0b8Msz6t5FXsMYQ8uPa91YlP
	1TYXfnIG8Ju8XRhBitYTterr121diPCfYrAnCgsLUM+q+ShOGWuhqq/OlYPnl8reNoEh9Z
	WjwRWN1VXfPR2/2dd2TGul3fwhmbaWA=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-35e57611113so978036a91.0
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 17:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776818131; x=1777422931; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lVYBYcbMKP9T66v2BVVHPkUpnYU8ZtQu2qMfVc8wIjw=;
        b=EaB5mkUtzed1153UgR40DXW0LF8T55wJxepRU0prVlSVWYC8perzgqcvJZhi7wyZMa
         AygOuTyg1ogHJ2LtLakidmishZdw/r408DR0lv03YH3geYXNnEUo96bDJRvdz4Z2sFZ5
         jUmtMqlFC1HXBvFPmDlqaSidcNvHDy/PkirMfhWfT7GODJpbScUbFZK64xHo2oNY5Qvr
         l3xs9+gEBoapWcLDMibLXLJDvT2gyjfd9VtHntO+cBqrzA/8npDD5Z7XW+r9WWe0B5y3
         M1LfCvxmcC5e6MXCGq46yZfZhYq7NO/fo2QJuG7OKLL55Wh2ij0L0P+1E7CRU5ZbybMC
         aI5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776818131; x=1777422931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lVYBYcbMKP9T66v2BVVHPkUpnYU8ZtQu2qMfVc8wIjw=;
        b=AXWjm5bxWwn9xv4hlQdeMHIx5y8SHvlmwyFTFBbc89n+z6PnWXir/Dqc8ACpM8WI86
         XOg6aMj7hJxq1qzaKpcK57ONjgzxDMxeuEi5RaBp9pBgKXddnCvRXcUun2nWXerFM0lS
         3nbhS5vUrp1B0zTks5xr8XORF8lWfPWdYiPG0n1YQPgvcnbQkGSHO7g9NEku/QccdECN
         zAZufuCatlljfQvlhokJ2mXTlPnvZOJ198+fAcBHE8JtMNnGq8Lki/Dn4hFS7WVmErzN
         MRqGqMLpzVsALwT2lJI+URmuIahIUTrvoB1WcbCNHvJY3uFi15tW+K3owGA6DYyRW75e
         6pYQ==
X-Forwarded-Encrypted: i=1; AFNElJ/Uj23/cM8gcEWLvOfJUlNXQ6m+CdXJmc66AcV0/SxClIEN1lbgyIJXT2FZk10kosJCf0uQr0/4TQ==@kvack.org
X-Gm-Message-State: AOJu0YzQ2ULdsxt/AdLwpYzT62zsVsHB7XAt1aS/pyvhzhW1pL3xMEUe
	kA4n4kp1XmfQFZzEKGKnePP67V8eWGNISdEkYoQhFKIUQrwvXs09daHf
X-Gm-Gg: AeBDiespQCMj3fZdtmGhNvyJ2xaeQZ6EHYRWKrULZjD+SEDjKmGkwpLpEkbe1jBmzI9
	V1qOz8+n8z9BqwA+cRK/T95kuhiAAff18927HPY19NzXBhuhMsrWSxtO6f2ItU+iTx7N6Z/dni5
	DM5RX7JcDwuMZcosdw0ivpr4pQaoLXDf0OWMeiHxaFCqAPoa27UDqrXi892DMguL3AQRNdfjl5n
	p3Q5HSSORb/lLKKPNyCaf4mZQuwnt3e8kwNDLcy6DswtZ4RlP88GUaKxOqQ2PU9U/3cTIrTt4CF
	5XNoZ6Bbo3mDVD8+xUfjcj9qWG/860tLcXmfJznlDALaIHpvAe1NuTWPZ0w5D97RaucvYLvV8sq
	zov6GId9ZTQl9MAhuIZ/kq9a+h/5SYOvK/Rvo38htAqyJ6XK27oCc3lJqUg7X2bsFgMLxVINazc
	ZisgRwoL32uB7K8xxb4WV8qMRJ8SOsx3ZggAvRtu4+HlI1AX5YP2rtR69eXIsSYi4ItDcy0wJXk
	fYeuLcmXDL2RxZV0Uo9MQ==
X-Received: by 2002:a05:6a21:62cc:b0:39b:91d1:6c10 with SMTP id adf61e73a8af0-3a08d916aa1mr11415454637.4.1776818130499;
        Tue, 21 Apr 2026 17:35:30 -0700 (PDT)
Received: from fedora ([188.253.4.228])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c79770512afsm11597247a12.31.2026.04.21.17.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 17:35:30 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: nphamcs@gmail.com
Cc: ryncsn@gmail.com,
	haowenchao22@gmail.com,
	akpm@linux-foundation.org,
	chengming.zhou@linux.dev,
	axboe@kernel.dk,
	hannes@cmpxchg.org,
	minchan@kernel.org,
	senozhatsky@chromium.org,
	yosry@kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	baohua@kernel.org,
	xueyuan.chen21@gmail.com,
	haowenchao@xiaomi.com
Subject: Re: [RFC PATCH v2 0/4] mm/zsmalloc: reduce zs_free() latency on swap release path
Date: Wed, 22 Apr 2026 08:34:12 +0800
Message-ID: <20260422003412.11678-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAKEwX=P6L=CeJCXkC+cKbZKYk_ORho3pLy476c8=BbDianx=vg@mail.gmail.com>
References: <CAKEwX=P6L=CeJCXkC+cKbZKYk_ORho3pLy476c8=BbDianx=vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8452540005
X-Rspamd-Server: rspam12
X-Stat-Signature: w7mot9m5uxiyfrrjgep1q37y6oox5mgr
X-Rspam-User: 
X-HE-Tag: 1776818132-560258
X-HE-Meta: U2FsdGVkX18SEqwYmANNFOPb2pmNrt3Wt93FIou0TOtayUVCvLgL4CBMebymFpCLLm3f7vBtd8cTXuqtMdumO/4V2a1J4PCcR79A7MyqTTtP901FQ7D3VGJ59NVAUQ4pwKxIE13gBeWtexHIfkeAFNF5M/329YNca8dcjQ1jn0pOAt7R4GHPJxJyJflRCXZTB9vCFd/SECi4y55Rp9FDFvXXDxkYAxoqGNMdhohLcZDbtfUMp6m93ou52VEL9JvRYL4LJg0QLSjvx+wJFkyCqNNZ9LhjYUD/z6hhIX5O+f8wzmQJgKyE9uVBFxtJuhgnxogHxNUj4kZkV9yIzB+OywxcJLZkAIGAKsjMp+WGIqqyUWC56hGpdU7czLe5yk5rNqEvAnDVhQ6w/ZHpW9ZIqUSRY3zDaHWDyv8X4wL9DTNBquHib0U+LKHe7BJDgZPI63QPR6tkNoMrr95ZiFmjvJrHkc2OQkq0BbM5qzeKVC05yEsZ6Wq9yfQv2Wj8p5I5I2qYDQ4f33RXOaXTPUna+j/s3uCt5OYu1eABnQHfQGl+a0eR2b30KldFn87QlXIbNyREzsYD//DIOFZUpYgDi8+ZPQRVjUv+C7rAcPkYkUDA90fQ2TledNA595SrhHMWQU0cbdbqP1iBSV8n7fC8wLxXN15nAnf2wLSEDwGYhbRxIHFzVVsNB27TD31VkDcjJwqx11BC7W+nmAYMTCVXihzeM6FpdX8arzzTa/yTuXseSzDJUdpxqG6NKUP1D14+kHzK+RyIQJsNBXGfveQiZEAsd3PDfinSnJbXAYfvRqTQuyDc02yxFIgOiQM+0WVr8GuZPqNvbbO2aWhtioLuVhqMO66TNNVN1bCfNs64WvpvG3XfIZQKNN7rFkfDmYj0HB3iCF+7XEU7JJH31AB/0DszDV+1/kzCPAAJGyT7eRPngRcV6SNxrCWThrHJ6HUHj+hlo9nnKOknYztiUFd
 GeEeMwKY
 ksyimupWMmsss8plMaBAYSFDAG4l3l8Ba0+xGa7grndKVn2pJaEqw3ynNX6bkHfv/omTj3arYrstLdTCMgyOfKB26l1HuhquuoJJcFTyEi6JmlGtLSbAWwJr6pMErkw2sM5Kr2GXxRY7T7wrpOr9w1OYiog+RkKathOuGSau4OjbLI6jOMET/54tsKCrpwBJM93VJ+j9XwWNBrWn0YuYi3RmZnjV1klxWdN+v5EDPGGRaJBDTQsHQPgN13uwSKKezR7ZVMajns6tx8ltQF5gz8kH3zZyookGmpdM/b3BhMypGpt2qEJ7H5KsXnc0urWinwwyCMpjb9hramDupQcKaL/M7jvGsV+DXkeMkDhdS9r7DLrJ0o1FxaFMp7qAauzJiVpTDX86auSQvL7Jlh6EYExWYCSB5cNoElhQLPT8EwHi2+Pgk8GFTPgtiJNmUAoXkkIGFj1teuhRwCDjIYEPB2gIzZb/TqBOOFOco5mhEvGn5NNl+PphBnqhrOo61wOMjReYq5Ujb0GzvzU8GA+A6ArPx9RBFVSjh2KM606SuPhAqACY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Apr 21, 2026 at 11:25:17AM -0700, Nhat Pham wrote:

[...]

>Hmm, free_zspage() and kmem_cache_free().
>
>* kmem_cache_free() is just handle freeing. Bulk-freeing?
>
>* free_zspage() looks like just ordinary teardown work :( Seems like
>we're not spinning any lock here - we just try lock the backing pages,
>and the rest is normal work. Not sure how to optimize this - perhaps
>deferring is the only way.
>
>

Hi Nhat,

Currently, free_zspage() is called while holding the class->lock. 
However, free_zspage() eventually invokes folio_put(), which may acquire
the zone->lock.

This creates a nested lock dependency. If multiple CPUs contend for the
same class->lock and the current holder is stalled waiting for the
zone->lock, it significantly extends the hold time of the class->lock.
This causes other CPUs to wait much longer.

Here is the ftrace data showing the severe contention on class->lock.
Under contention, the time spent in queued_spin_lock_slowpath() jumps 
from ~1.3us to over 30us, significantly increasing the total latency
of zs_free().

  7)               |  zs_free() {
  7)   0.220 us    |    _raw_read_lock();
  7)               |    _raw_spin_lock() {
  7)   1.320 us    |      queued_spin_lock_slowpath();
  7)   1.820 us    |    }
  7)   0.170 us    |    _raw_read_unlock();
  7)   0.170 us    |    obj_free();
  7)   0.190 us    |    fix_fullness_group();
  7)   0.150 us    |    _raw_spin_unlock();
  7)   0.170 us    |    kmem_cache_free();
  7)   4.610 us    |  }

---------------------------------------------------------

  7)               |  zs_free() {
  7)   0.230 us    |    _raw_read_lock();
  7)               |    _raw_spin_lock() {
  7) + 30.100 us   |      queued_spin_lock_slowpath();
  7) + 30.600 us   |    }
  7)   0.200 us    |    _raw_read_unlock();
  7)   0.170 us    |    obj_free();
  7)   0.170 us    |    fix_fullness_group();
  7)   0.170 us    |    _raw_spin_unlock();
  7)   0.210 us    |    kmem_cache_free();
  7) + 33.850 us   |  }

Best regards,
Xueyuan

