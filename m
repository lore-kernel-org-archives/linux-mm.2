Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42BE6C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 16:42:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 612296B00A6; Fri, 18 Sep 2026 12:42:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C3006B00A7; Fri, 18 Sep 2026 12:42:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FFFD6B00A9; Fri, 18 Sep 2026 12:42:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F9A16B00A6
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:42:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B7F981C2F87
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:42:00 +0000 (UTC)
X-FDA: 85227450000.24.A27EBE6
Received: from mail-qv2-f43.google.com (mail-qv2-f43.google.com [74.125.230.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id F391340009
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:41:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=YKRiVmZV;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789749719;
	b=XTplpZxeFWHGHiJ/pmxbPb0pqVcxCVDpQUTSVKXKiQ5EM55+b26auYozROfrBR4gP5lnnp
	cCRz8kBN4/8Y7c1w3A14c+uWzkAomSlBjD9N2M2EfM5qf0wvGGhQScpGE7I27kR3MGZf3y
	vexIFLxO2IYXWPavxgWVcqV1HGIORRI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=YKRiVmZV;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789749719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Umk/S3wlCI5JlgRsrkI0MpvZKU0Mb4rhS9gQVMO1YuM=;
	b=b0B6IfFcv6StVtsX9Ct8nhjUFgTqIAFxB0RQ1HuJt9mf9+OnG5zoHK6uiOTzZLiQzFvsVL
	XzuT0ka3rfy2sYnmd/SVlL24eWNglh5Q7XxbifIwcmjlrzSNndN5eoHcFc/1j3ekk2kb9B
	vgiVMpwrJARMdZ5ecaibxiNSVUPWM2M=
Received: by mail-qv2-f43.google.com with SMTP id 6a1803df08f44-910537b51a0so8658586d6.3
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789749718; x=1790354518; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Umk/S3wlCI5JlgRsrkI0MpvZKU0Mb4rhS9gQVMO1YuM=;
        b=YKRiVmZV0CyxUwT6IIXaNqPcm4tzrl/0oBIKn/QVARZr9LqIq5qUOudbOZN1jgHUJo
         ad++rPtau7dQ3BtlUfziXkZHacjlNWJ7v5/tvBdrV3z8HZNQZe1nNLPFoJ1Z2z2SNZIv
         giei7VotqVksahVknFeNIHUBAW4b9+4QB2fnvB5TQcPd6s0SqkfZqXW4r/yKPOf4MZz4
         otus/hs9+q81x83fINQ2JrtciTtwNhw6MIhWiI+mf4smG/QegSiVoZdo1dYlk4UtNyUc
         pQX7UQLNjKzdZweiWkG95U6LkbMQnskwmQAqjheMB5SdtMctC3lx18Uu6kpZ5x8nw2vW
         FHDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789749718; x=1790354518;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Umk/S3wlCI5JlgRsrkI0MpvZKU0Mb4rhS9gQVMO1YuM=;
        b=Y645lj+D2ZJNyNXvtvd7jhA4DKFGO0WfIM6WKT4FsKVJNDmODBgDgUo57kKjUvX9Xk
         56FIWA4t2B28w0UsqzsRijz/3B9xtOkb3KX7LEMqIi1xVZlvkWCJLhK74rJYdqp+ukkb
         jPqEuwaEfYeEiOYkmqzgBDGPv1YspauCQI5Z+S1XW2BT38VLfolvX/zlFHbGp/28o6Ti
         AI65NgAj21M1Wi8TVHBM2SH9FxjRj48ZLen373vWhWocn3IySSTB7iobO/bP3PDSrXLs
         eJppoZ+gThsUaIdrGHtvPUnuEBSVTd7SSVBFCPWPQcG7/iuaPQSwqci1z8FQ/7p9zQBC
         3drw==
X-Forwarded-Encrypted: i=1; AKwUvBzATieGyKwbiL0WkoQQbjmbbFJbLueqkNItL3JHKwglSexzeIBmTrIlKpVP0VximCoZO0wpEi4QQg==@kvack.org
X-Gm-Message-State: AFuF++ly5Qjt1q7z8EIuTvK4zf/pFGjAQOVMIXhoNcXJCbH8ywj6Qz+0
	UwCz/VyEo/JFU3Vilzcpt+tpCFcUUGYtldbKCtu1i8n+INQ50dXgLdWQ2//QeU/U3WU=
X-Gm-Gg: AYBFou2mGmuJoZpUPkYJVi1m4Ko5uEavp0qAiBNZC4fTvpKmD8AMa9PEwvRb/aKbUh0
	5ZJ+sQfbxCeiD0DnSalH//1szMb2OHYPBrDDGUB8ni6biiPyZn8d9/dRQXU0fpljI5bA0yHdWEK
	hVHZ4U+hew4Rj8aWaQnAlTkBS1dkmuVwQrkupkFwK/mnFeeRpPpDjNh3yyr+FLkm8s3Izzro6hU
	0dRyoN0RQg3/gDkpSv397m9fhA2nKcFbxnJuhxReGc5BMBay24SD2RUU0ztZS7WnvhBUeJKUYOG
	FS51DLGvkHx+Z4s5T/PEbmSYtg053G7kWnD3TYTiXG364crYx+qQy+ipHE8hngt+hJL8IWnIIHA
	tsfDB/IRUHouHMxq/Mq1RwbWnSXSNN7JitBH5xnDQnMwCR4c6JfAktK3M3KepiUdtYfKdeFMaf6
	EQ/iBtQdqujU/gs/6S6gOsRbMn+8y0x+1ECXctZZBCLQUqoxMFWi1+G1WnhQ5/Sd6DUPjnEuEYO
	9+9l8p6masBVEzN+LdbPahuWevrqgRiOxZ36w89v0UBaClKlSr/tSc=
X-Received: by 2002:a05:620a:d96:b0:939:3571:bb90 with SMTP id af79cd13be357-93bdc6ae669mr459306385a.24.1789749718205;
        Fri, 18 Sep 2026 09:41:58 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93be0f0a202sm179495885a.41.2026.09.18.09.41.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 09:41:57 -0700 (PDT)
Date: Fri, 18 Sep 2026 12:41:56 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Rakie Kim <rakie.kim@sk.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 3/3] MAINTAINERS: make Gregory a co-maintainer of MEMORY
 MANAGEMENT - NUMA PLACEMENT
Message-ID: <aq1pO6KRR2CMov8D@gourry-fedora-PF4VCD3F>
References: <20260918-maintainers-mempolicy-v1-0-9a94cac6d135@kernel.org>
 <20260918-maintainers-mempolicy-v1-3-9a94cac6d135@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918-maintainers-mempolicy-v1-3-9a94cac6d135@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F391340009
X-Stat-Signature: hqqji9es1w97jgtc9q6ahct6h77w5phg
X-HE-Tag: 1789749718-93172
X-HE-Meta: U2FsdGVkX1+JfCKXpqOnHvwyfRLLWxZ9WYJIMjvPxUy/3nlPsAfQaM5zbhXzrRxCbDqdZhmJbQNVtaUI0PKIDCuvqBnTEdor+JjBObWYNUIKSUQfoWi+G4Mhr5LfpSxvk3Pk9qJT7f+p9TWtbYxkL/j41eDZJHKNhQ2yqojKg1vtOjp1ThnryNmY8VHYjVZjEW0+QWSZXO5gkur7B2kD6FOPdPIkcraPj8ckPRMLj/BcbNZG4OMTksGIJ2P+0HAqbguiNPf93E+k8Wl4hNECvqKnUcoVyncsAMMsQ+IsNt/BHzlO2+7PDOajAcENw8tNjisPFr00qHYyNrODZ8CJ4wcJF3dBRGOWRf4j+kljBsYxQv1X2TVnCxdVV6ixulk5gHUW1sjvnZYCI9BuBbs52J/xptZ60K9LfiYM9Vy/cuclL+met4aIGz9Mtd2GYCGpv1BRF6u3vAIo6dpK9b1DhuTnNkCJxrayGl3Zxm7GLy7D57Q1Xqn1ZIslsc713KCVOfuKNNJ2CgFPy8eBe9YM/vOnOSCx0mIlsr34Kx2w/hJH8vB5/eQmgh6yfHnf5rnSRyF6xy3snx1H7QXddE0XYh0YUHuseiIDI0/NkN67ed4elmwaixWYE61KiFbAHiKB5paBrUPUZC9L9nP0IChd9rlU66ca4a/ydmWMwyd9SYKhaIXtDxpY+VACy6KaiPaOdWgV5DT6xdP6hwTV91g56pGqMBEXuAEg9si6xUBy7HTrX0Fa6M1wu3ZSHQzP0tcCmqQoE6DULwuKLyIiK7b7Qczj8zvotdGGCfE8wWnxXLaTOXadk3gTSkYdSQCP0jto4LM6oQwo352KEbNzm85Xt5erFWLm7bToONdloWhxLef5AgVzvJauM+5vpxFLYoJMbi5Kc3bLLAtry6KiL0Kgkbk+N3WpA0mmQIt7sU0JKA5iLS8VOfxDHqf3AWJCFYg22Zhtp0/1zbxwDUR0243
 MVhlcgoa
 XR+pe3MDike1ZTAX7X8B56rS/DXUuFIGm1dgpsSYV6++LbQFMK/pRUa1vrrejejyKvrgiY7EDU72o8U3dA6blGNtP1uiczsBCFW0JFa5U3r6zhY6sXCrij55gzVQ54K5mETZ8JFgxv5+irORjnT7wojdEZoQaMXShJVl3TT1YsbYZgcbJ52X8NcPAdJ1I07HfKMx5EiTFhoJOFfwcMEj7s5HbZRHufBOGsLQFsNCpl41MoK/KckKkPU1PsQ0vVjoBBUtX8yx/I2qnmc74uQIrsTZwYytderXiYbWfhIgVywPUjO1YznxdsZa/kFfS5UFEr78qHoS5ytTo23Z8lzR3951mQZK+n55VhfXaxiM5OgibrJHX/b1sQXwclNphDObINev/34oYONQIENUA+qBszrjY9Dce5JjFZu4Bvh5TzjwlpMzWTLGiwX23kOjhhy44DRSzGQxArsc8gOZj7zAXaMbntB6KMBpF9BDpiK6fTK4dmMg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 06:34:26PM +0200, David Hildenbrand (Arm) wrote:
> Gregory is extremely familiar with NUMA placement handling and volunteer
> to help co-maintain the numa placement bits. So add him as a
> co-maintainer.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Gregory Price (Meta) <gourry@gourry.net>

going to take me a second to get used to that.

~Gregory


