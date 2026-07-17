Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57C36C44516
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 21:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 374B86B00CA; Fri, 17 Jul 2026 17:47:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34A626B00CB; Fri, 17 Jul 2026 17:47:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 260266B00CD; Fri, 17 Jul 2026 17:47:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E3FFF6B00CA
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:47:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 75A708022D
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 21:47:02 +0000 (UTC)
X-FDA: 84999604284.03.F92657C
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf01.hostedemail.com (Postfix) with ESMTP id 74D0840009
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 21:47:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Yb4i1Jau;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784324820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AgfKPfkfc4jyNoAXQ924zrK3vmVWU/VwnFCFChfwVj0=;
	b=R8S16Bn1DmNWrjUvWFhuqdI4/E3T9c9CUJn3Kwr2EUzWNQg7co5HxK1SUQO/OkZuRuEoes
	3veIW8Ap/ZEOE3Z1spMmXB9x3kCgnZeEJhfXgjiEdjSLL8WOGMNjD7/eUoXfUlELPevumN
	LTLbBc8I+deJhyJGzo8EudEeWvKq6Wc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Yb4i1Jau;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784324820;
	b=RXdiSLn40QZ18R3VvNWkR4BeRlJo4iKM5+h8hmk5RGIgx6XKInqGKb0C5GoVpEoixX39P9
	dwt5xfdnUytECEghAMFENNe2tZtbWwJ+t+lV7CXfktoCFtpXiC857k3asRZ7kOuKBh0dam
	i/Kh2bhVeTmxghu4JgTTWn6ImCaCIUM=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-52192509869so6833781cf.1
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1784324819; x=1784929619; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=AgfKPfkfc4jyNoAXQ924zrK3vmVWU/VwnFCFChfwVj0=;
        b=Yb4i1Jauc6hD9y5RHMdfB4YM4Ik7mokaj1DD+2rdQ3s95v9lDf2v/8ypn/lE9nSKd4
         yl90Hl9RD1Lpql542iGN99RFzYke7/9jldckX7jldbGSu3VSJ7rJamyLue1+bGv2Pdvz
         +WjqDPQaWm9thrPaw35JiWz2VvQX+7uacL6CUmcR6ku+kYHWJ1QwxBRrKMql5rpFDWzK
         mzFZ7a3VTGciDB3dSRaOmzYF0yiDLc8Ygh8hwUrjh9Iuxw8UVz/SwoMx5ATQzouix3p4
         MOMhFvCikykgAq6WaDLflHDXDT7cPX0LfLxBN5tQ/JN938mPTST+ORf7UAhRmiD5Zh2u
         3EGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784324819; x=1784929619;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AgfKPfkfc4jyNoAXQ924zrK3vmVWU/VwnFCFChfwVj0=;
        b=iWSM5jP0gwgkij+KM/+EYCqO6IaOT6bkS1gKUNF1P3m8/WqXKhlURH4mYVxITKje0r
         1RAWRxJWUFtUrm3Yj6CRXx80/GhKNSoBRFDkbFRPKNMO32vCspEhdkljptx3eYrePqaf
         BE8PvfBZKxuqQ5ublZVU1ekeGtUjEreM/gDwcwF/+x6EXeY0dvhQwirPyh6mNHVTBA3H
         xZMnnoAmBSU22kFbLYPFo5SyiUBLv6OOHAfzJ4NO58Hy37psJHbOHhXF0y2nFw2L89V1
         89+Xbs5b1DtmF14QPi+C89gBiJ6chtDlT6zyfwcPeTlj/58M74P6ocJLlloaLaIi5ctq
         Gvqg==
X-Forwarded-Encrypted: i=1; AHgh+Rr5ZwXdRERAY5rquA/a+EnErtQsEfm65oS8ENDDmpUxvsUD+jOWVcX7cTXTOotDDxMWwYlJgWPQrw==@kvack.org
X-Gm-Message-State: AOJu0YzkEYrDJXv6w7eCd5KJXicGx6eNQGpxB7Vi6bYeiJ+2fEwkL7vI
	ZeqcgLHcSDphqfDOhpoWI1O0NblVJnblt2h9VYJZseGKHkigEwn/3LNAklP5BWgDyXo=
X-Gm-Gg: AfdE7ck6ceIPe0pO+y6jhSGwC4+Y5uGPYYxhhJN0Y1WxiEaItsFFTYzbrr9/nY4wW6x
	wErlr4nI4FUzkB8mnTAXuVCQBtUO8AUBJOSqdnsGq4xvHwvoXnZLVOJf1zkT/rHkzGvu1tWcpRK
	aJRpujmEi3YtizDvCJe1trUyuBsLH9FoGo9ksaZKPXxKv0KDPr4CNcJgVm5OR6tVES55V13HqvC
	GMRo9cB43zyc8XrLr5UxndF3+bDil7YtUJTSkrgVsTblMM3/TG+mVA2cFQubRJL9M3B9MsW5Ic4
	lOb8lwpaV2q7Dpuv99dvSfNWrCPfwQ9mYbjckvwO9qdjWFCEQ2S6yWFYVUk4yAv0P9g4tLvrguP
	Tmig7gxeKcZ0JekSTA7mFrqVYIMny44OjKbLskDSXkIJ8dDdM5vnmQVXHdLXUmjcuoehHHPZ2Cp
	lzm/PIncFOsitXqtN2KvofLzqf8fm9sdBXMV6+fhWOttk+aOP/WA==
X-Received: by 2002:ac8:5acc:0:b0:51a:8c97:fb93 with SMTP id d75a77b69052e-5213fc54d44mr43814441cf.60.1784324819586;
        Fri, 17 Jul 2026 14:46:59 -0700 (PDT)
Received: from [127.0.1.1] ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5214c5cc8d5sm21955091cf.6.2026.07.17.14.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 14:46:59 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v7 03/12] PCI: liveupdate: Track incoming preserved PCI
 devices
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
 Adithya Jayachandran <ajayachandra@nvidia.com>, 
 Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, 
 Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
 David Rientjes <rientjes@google.com>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
 Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, 
 Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pranjal Shrivastava <praan@google.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
 William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20260710212616.1351130-4-dmatlack@google.com>
References: <20260710212616.1351130-1-dmatlack@google.com>
 <20260710212616.1351130-4-dmatlack@google.com>
Date: Fri, 17 Jul 2026 21:46:52 +0000
Message-Id: <178432481253.189683.3297727348836286619.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1380;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=ahWVhQAgslIBwnfpmx5X48jHe/0a44QV3IQwRfGz+iU=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBqWqLRRsSwqC6u4RSv76ETLMmVCyhdUsVHiqEBy
 IzSCQuBMK+JAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCalqi0QAKCRC7dyhM23N6
 3vK4D/4oivNUuZbxrdZZJAOMVjLNn7oaWYDk2Y4dxn2IVLciov4pX+4V8SBAYA4KhEpyZKQ2mzg
 B03dHNIKdFOpoPbLkuTRk9ZGugmK2ChP6tAHjBDG3RkOkva5OLSR6JBKmrLBG2GEATEY/EOLIZ6
 eY/PqU+3F+O6j7iFegvOLxHq4AGPuXSVacvDtCjafit/axJj9LIZ8kF409sq6qgcKO5JKSa8Jea
 R0CHNLN/rrFF9+PoaDcZ3B9yBydtITA6U5LOFg19G95jV2FYfsILSxxBbZrxUBXAadtzCS2F9wc
 ojlbkyeQfKGhVsMnUf0jafSZJy8tlQ5ygLO7zUxGMxHU0yDSH9+T6zwkWpBoVu1DzV6CaJNE61t
 UznWIUm+HsrUwRRGxWKvQ4wAZb7dT86JZoYl//i+SFOHLjV+15QOw7niAqqrMwWfQasB4V2Hxwt
 eXCZu13O9+xov9pJgVNEtvYTQmPpi6xZlCFh5C0RT0QzDoNbZ/WnJZuT0M8/c8BHxvB3E/domK/
 fmKpXprZCKUC0ZMdFx+RiHls3kZs/ypakbVXPUHyzfXsnIT6DxIFfXMfg5kTylkBxQPg2GwLoaZ
 CRH5LGmNRRTuTgY1EFBAo8as9+ZfD4j3ydB1vBG6faS20lFZ3r8fycLqRoy2hUgcnWVKGbkEtVC
 YOLWzX1kCSM2bCw==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 74D0840009
X-Stat-Signature: m4z7858bshg1yb6x8aouggbh6q9hhde3
X-HE-Tag: 1784324820-135730
X-HE-Meta: U2FsdGVkX1+cEkZYcLuhkAb2sncClQilSp4zMGmaBVWarq9IKTBtpMjg/gtcvzpsd9OCnID35PJrBo1wGuqD9Aw6cGygDDwsAPfTRnQUpHYijLSEpyNz0wyQCtaKz7t8jujxvl/fCMucr7fFelNNSfrnpSif6s3hzGwWSmbWl6W+wFte3DLHPCjq9oSFZNu45I8nYhe8UQdYSGhkdLLF+mgmulboEOVzh/AtXZEmBfdiOku46EVLtKmjgLn1XUsaA1PRzTIuVZnWSNVZqGgHBSc/0C/LbpQwfK3zpVPjkPp29p2fgV0alHsYzAFefQGcSzeCguwnu3+tIISUCn1WTQaf8CQJQx/8oSDM2SUC7ypOK2Blgc7WtlFSihRL9jpyqRYeqVQeGbP0xwrBjMP7bKkDDdGWYOZuluR0hjfRF1LsTvH1+nyDNeIjfVPg8/vo5WcXoYlpLhJpjUHlO8Mw/NtYbNDavuCQT8OFn4hi8jBLRllxuejlTr0UGdNzHUuRzYNUYk4tZsKErQHMYMzI9M50jFWnruQeOKvRPlL71R+5CF17t1h+if861Cgo3lBktPYCtQs9n+cjgGCw8YXkyDcXOsvp0RaUHRRkTdyOqeqH/JAl2yaa+swM1rP5bYFTyjlDqwPQVqHrb3HZRRVU0xybxpM8xEX/fQJPUxLBfyU6SuEsMdvVGpXG5TNx2I5L7TdaEloTfsvOYctDdvJ5IUJAZ163e7Yafqp7qQCfRxt82M/QjxPqMhMAXOoyN3Ntp8KEeGT/8WwBcsULCucoihP2Za56d96Wx8irclBRwRPQWz0ZU5AwqhNuIfUtQChlSoAeFGdOUzqAjZKuNjRzVS5Uwlpa1lPIPltGRY5J5UMtRFsnzORHPRVkt2JTyvX1LRLPy2h1OBS2aWNDEs28l9CeCe7DFhN7oy1MwPDWt0tmpomV9KmXrdLj1iHEW4Rc9Zd+4ALVjKFe5C7CfEo
 gXl59ZUw
 pFdROQnOvL7KXIDYOHqc1Cb9Io+UYfS5vJGEr3Nlz5C98Rlg0i1g5NGG3qowz4MxJDgbz0tMI4fmfeANnyNNwLqmSK2rDcNqencnPDKyrIuEYve8+vqoaOCSiy14FdFFM03AZ8WmD7NeBcz5ThPBX1qyo1hlkl6Upok/76QaV+IpcNm9lXP98cGdvIyY0Y1pR1Fd/zjZ20iFH5ptYtMKmwiR2Gazsj9n57uLMUnLxg03ZY/3uPkGk/Ddfx43yV0hz6Uzn4zw7p4UqmHTiE/rlyoDUo8vAj/QQqPcRBHL8TIGzWfh0R3vbiypVDK3UvznqjAc/DA/rG4UYJ3g9JgVkrULYohd3QGjQ9hwGVMMFIWHXqPg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 21:26:06 +0000, David Matlack <dmatlack@google.com> wrote:
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index 03075ce06ac9..df6a02240aa4 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c
> @@ -298,6 +377,87 @@ void pci_liveupdate_unpreserve(struct pci_dev *dev)
> [ ... skip 76 lines ... ]
> +	/*
> +	 * Hold the ref on the incoming FLB until pci_liveupdate_finish() so
> +	 * that dev->liveupdate.incoming cannot get freed while the PCI core
> +	 * has a pointer to it. It's better to leak the incoming FLB than do a
> +	 * use-after-free if driver does not call pci_liveupdate_finish().
> +	 */

I am confused by this. Each preserved PCI device must have an associated 
FD preserved with it via LUO. I.e., vfiofd would need to be preserved. If 
the vfiofd was not reclaimed, and finish is not possible, that vfiofd 
would still be owned by LUO, and therefore PCI FLB refcount would stay 
positive.

However, if finish is possible, and this is the last vfiofd that is 
finished, FLB will be freed as soon as the reference count reaches zero, 
which I would think is the expected behavior.

What is the point of holding a reference here, instead of only for the 
duration of FLB access, i.e. to make sure we are accessing a valid data?

-- 
Pasha Tatashin <pasha.tatashin@soleen.com>

