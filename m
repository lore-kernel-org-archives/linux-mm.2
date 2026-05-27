Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 690BACD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:16:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD1696B00F3; Wed, 27 May 2026 10:16:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A818A6B00F4; Wed, 27 May 2026 10:16:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 970106B00F5; Wed, 27 May 2026 10:16:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 84EE96B00F3
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:16:09 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4E1D1161AF3
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:16:09 +0000 (UTC)
X-FDA: 84813399258.09.1A505BB
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2C69480015
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:16:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=koHGdcCb;
	spf=pass (imf02.hostedemail.com: domain of shenxiaogll@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=shenxiaogll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779891367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GzVcryfU9QxZddocswZazrJnx5GUut5UQLQcVR/qt2o=;
	b=Dg/M9468BZs0JC8n1zB6rPDH8cQ9UoOZ0XDTeR9fsfJFcTJHL044+AmlIFQRyrCuUchK3W
	+ZT725Qy/SJUZp0VD+Tf/Qw4UAjTpBMMtn+Y7wZHFZ8l854Vk0q7ezdZvBHjHuHLZuO8BP
	2rDfFr3ikKRR/o6FMqGToGxMb1Rt+es=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779891367; a=rsa-sha256;
	cv=none;
	b=0ZUz6QJI9DyANrwqPVdf1lnIqoiVa8mmDQYHf9ljApEmX00i5LWHgDzNCt9jGYnJkmeen5
	D1TVvSctt8B7Ylv+mP8dUUpJKAKNjNPbz4gmUXlhpCpusFPo7L6dyPRtc0ao8u3/4miys9
	dj9bCEsBSeD+FWh3s1kHS32ljrWJ9kw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=koHGdcCb;
	spf=pass (imf02.hostedemail.com: domain of shenxiaogll@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=shenxiaogll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2befd7eeb46so889735ad.3
        for <linux-mm@kvack.org>; Wed, 27 May 2026 07:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779891366; x=1780496166; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :mail-followup-to:references:in-reply-to:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GzVcryfU9QxZddocswZazrJnx5GUut5UQLQcVR/qt2o=;
        b=koHGdcCbMZR+RUOB285l8Ew5HyEGJUVhN0WyDdoepG4D0z4JIiaviBRAwcXnX0n5sA
         HhnsQD7B0fW6IkJlSvE1QVuQZv2Iiknb6/XrFVIgD+kQt+HP/xofx5aNq5lNVXuyUAo5
         r/Y2VJG6SX3pF7FIdo7yPK/p3Lrqq3CdNfl89gD/c4t/Q7PTc7swUTXa4n/POlpgZbeJ
         fMkgfFStxKYkRU7n8wbqZpmBI0DzgultQRLogonn0tThfws+ILoENzOB7DQh7Mz68jZh
         HV93y9LxT+sEZ+B0bFNsRm9QFqtB7Rgk9J02cTOLaYW/W4L9edNnIgoXdmmUiUo9EjD4
         tLyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779891366; x=1780496166;
        h=content-transfer-encoding:content-disposition:mime-version
         :mail-followup-to:references:in-reply-to:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GzVcryfU9QxZddocswZazrJnx5GUut5UQLQcVR/qt2o=;
        b=R61QLlOyeDPqammeKOPDbzT1wnubye35knAdjjazkXAoln1a6X0TCkCrZ4b1h07Eaw
         h7DomCQbbIV1g76ySMuI7W8goOzwMPpCMBX12GGbv59a2y/isrcBPJstWBC7jCVePKSu
         YXr0M8c6nnePcsgtjmO3z4kXSN7P3egwcofb46LeQT+DtodtDGOOLoACBBlD+kwAH95N
         ZEkOYb4LxgyjBoOnOnxRMwBXgY3HHx7gGfc0bPgQZFBI/L7ke1HiRQic8fO+S7IP1g/a
         QrnzINPxDRtk1Habz5GAbN+lQ8g6QyX9/UAQ7Ezky046C/oqvXAtgMgzsRA19Q4+KAJy
         gT7A==
X-Forwarded-Encrypted: i=1; AFNElJ+m3RUW4DmMhausmxNSLCRpUTJT5gJjc3yAJEvvvgO1JmHlISjHLTEacH/FHNEhu32jcPmreuULQQ==@kvack.org
X-Gm-Message-State: AOJu0YygaBp8RlGV1QGagyqoYBmsSiCQ+ZuauMWAFTpPSgbfdz5kZVKx
	S1XXKmOcJDH4HeYUFRxWm6zhbuLrBc0ybM0Iq+B8nJkY1ZiE0JP3rNLP
X-Gm-Gg: Acq92OH1MtqOL5lddCMEXTlkIMlhj7bZfOAwHWz5xtOlPnMIvlrVxsmXUDuKhP8zat5
	o/skEwd9OMseDhmr1vwH4UIr0KVE9VbC4oXbbbSQsCWgzrY+Kd6SWrLbioa063S2NKkKo85+rEY
	pTl+VbjfywQ3xHjZRQrr8zn/ngIWpf9MdOhMtSS2S23ojJUlYBXUicnLbIKu/d0KyVW8ICX2bPh
	5PFoj17OSJYNj1nrZpAoeKuoc6X1bNAoKNakA4dnkDZ0l6sPfUgwJB+6STzksOpE4f/CVRSVi8V
	x3k1A10Rz+AFZglPZ0VM92sSoaCCUcMXaLiwHEq/be3MlvpVPoGO4fxi+3OIYm8hApMPOEjErRl
	Hhi5fXfp48aWfSGASrx0Adu5mmtu5ZkWCFU4+FX/qNjmvPjajQzY4RCuMEzCc1I+0ADN3VZrslY
	WFRIRw2RSNLEIM3AThOGoCXnP2ciDbDBTtog6dgWRj6Fc0DTo=
X-Received: by 2002:a17:902:d4d1:b0:2bd:a5f:1d04 with SMTP id d9443c01a7336-2beb05bf787mr246093385ad.9.1779891365968;
        Wed, 27 May 2026 07:16:05 -0700 (PDT)
Received: from localhost.localdomain ([116.80.91.208])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb58b3085sm154156885ad.53.2026.05.27.07.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 07:16:05 -0700 (PDT)
From: Cunlong Li <shenxiaogll@gmail.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 0/2] zram: fix UAF in zram_bvec_write_partial() and drop dead bio plumbing
Date: Wed, 27 May 2026 22:15:59 +0800
Message-Id: <ahb8nzeug80MJ8Pw@debian>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <ahabSU6QcGJ4T4ZP@google.com>
References: <20260527-zram-v2-0-2fb84b054b5c@gmail.com> <ahabSU6QcGJ4T4ZP@google.com>
Mail-Followup-To: Cunlong Li <shenxiaogll@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, Minchan Kim <minchan@kernel.org>, Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C69480015
X-Stat-Signature: g6zyqgfmbb6jr7c5rk4ncstw6bu1s3oy
X-Rspamd-Server: rspam06
X-HE-Tag: 1779891366-853612
X-HE-Meta: U2FsdGVkX1+JhYkfdl0r2qotPjQGk4OEPV7NPLHaCteTgIOqgTW2DMF7yyWidfPDBH3cra8UUQzElQPg7p16+MgxjwQS09iPGjShaaedl9USFJgCY6xHc++ZSr60jZu3w6Zp5S6cENIiG6vH/rJdtFYE5gCVt+fTKoa7f6sqhpM6Arps9NHR0ClgSsAeLXq9l6KS20bHRPrRDRcJHsklg/85b0GIB5WogQE3vH7ciTsLiHv38IXxWTN5u9YA+O13m/7YFTFrJkXIIVAcExZ4W28tlo7emYz7smUxoFuvwUx5PR0zEOEYxwTOAT2NlTX3P9MGizetOu/r1P3vJALPJeZQ7Irv+z2KT03tPKkymGbPHjNfZLxyyFQooMKzUVM8sA61o7JgjgkeOHUeCP5W6++AYG0XgT5037+A87p5E70DZ8qMD57Id7bUcN0sPieIamkvnrfsQSvIYkFjE2IZo/xqfmP+QQoV73GWNwSsfr/0zPYNS/L+aXupG4UnRcNuoqc+uhWCsQSE57GNTVDocXHsXuiv7fM0QSAeL28SD1MwvFZz4c5osk0u+v7XZhNt5+eoqlYLbdkdDkgog+0aZLLnXxp5rZwyFzTKGLzc4vzTpHJvxUmfGKyi8AJJoDJUMOo4+KKhwaqmi/CmSu8m33WfKgDAp91hzVrR2r6YnVlndjYlFgGHQTwoWDNM2HiEUQYnurOSdjTJcs7I1IgYtqJzQbXXy71cwL060kQXee6QWVLszIgk3T67cBW2cS1eopnWQmXZikYcuzGb0UaNbe7MUwIEnch5D4KlZ0RdjR/zJlmq7UX/foDwYTOY0UCHa4Mg2ijy2sot8kRDJLHGdnqnerOl+JESsOSnQmnh8/de3S1oESz7/6xul0mCBQ3Ubb+NCWPzcnPRBsX8HIf2xm4HrZLs41Aa75Sax8s18lF7+PTd/7kh/K4C65ajAFAEbdW7eiR3cxirfu0eXZX
 nrjKBXBe
 +GJp9A52h1DH/kDyzup/VlRuFWhwrjBPN+Q8UuH45LWGYH0mishj72Z7avsmEX/MPDnriKyiujmUMwPn+4WxEtkPEo/T9+Lwv+WVyVRVxK8zjyVOX7j1eAPZnINmweh3g9E10QNnEtXToKTAXwmEVeD4el3Fjge9HQ7vIn9UuXdw2XGvYJu8+oDlbkZBByWsGfYN9sG1mRPD36a+Pw6q8tC7cODWxA4E8D/0oZhr4BIR+l74nfF1Cnflxzuya1DMisbdvfJI6yr8ihPmPjxFcvv4PdDFXDpZsAjUS2+LkEKXKUDxLc+OhFkUow2RKd1Kl597dQ6NQvm7QtZhnHhHNKVEtxRAYw087losVGiobRJVwXjZgNXmBH1ZDXLq97oqpcrTC+BrS2DxsXZd+3BdFb6G5mwRRZPl+/whRh5CD0lvZGbsGNuQsAQzayRaiTFfFHxrBFAlIYRmcCkOxDj3Nwl6J/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 04:21:53PM +0900, Sergey Senozhatsky wrote:
> On (26/05/27 12:49), Cunlong Li wrote:
> > Patch 1 fixes a use-after-free in zram_bvec_write_partial() that
> > happens on PAGE_SIZE > 4K configurations when a partial write hits a
> > ZRAM_WB slot.
> > 
> > Patch 2 is a follow-up cleanup that drops the now-unused bio parameter
> > from zram_bvec_write_partial() and zram_bvec_write(), no functional
> > change.
> 
> Did you test it?

Compile-tested only so far; I haven't had a chance to run a
PAGE_SIZE > 4K reproducer yet.

Thanks for the review.

> 
> Looks reasonable (unless I'm missing something):
> Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>

