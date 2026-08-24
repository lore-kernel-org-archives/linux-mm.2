Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7C81C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 20:01:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F07D6B0096; Mon, 24 Aug 2026 16:01:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A1346B0099; Mon, 24 Aug 2026 16:01:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71CE46B009B; Mon, 24 Aug 2026 16:01:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4109A6B0096
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:01:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AEC9D160268
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:01:55 +0000 (UTC)
X-FDA: 85137233790.30.818117B
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf31.hostedemail.com (Postfix) with ESMTP id DFD9020004
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:01:53 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QGsRMTfe;
	spf=pass (imf31.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787601713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RLVkVU6ts+TGH9dPTmESJlrY5y1GivISoEDjr8mjxtQ=;
	b=5ZVbHMZvL7F4ROEnLXQ5yEOn3oikGKkWgMgKj8+j0pvgWdOqovCsnMOSccJOYPF52xCJBH
	mRTdvQ0YLrSidd+M+NIJUmJv0xrHvr+lWRW9IeJqORxNjC5dYMn+OkijRKwbVt3GYAumiI
	MK1nP1zjIS/hwXWvkdntTjaYWMM7nV0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QGsRMTfe;
	spf=pass (imf31.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787601713;
	b=qysebElcFivGZCdvst7BomKkDzoJZstfkeh1xVICsllHXjgSuvG98bX7cVvM5WQh1BRz8c
	whOBKRsE+TPnuXuqDxZr3hlqefFn6wTRbBhm4X2Hm+ihwy8Ilzqx5geQGt0BsiYp0lrDgz
	WTbQzs5JzHCQAp2HtTYKRpYjS73ARBY=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cede6375caso34155ad.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787601713; x=1788206513; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RLVkVU6ts+TGH9dPTmESJlrY5y1GivISoEDjr8mjxtQ=;
        b=QGsRMTfehJyA0FEV+s4MFuYfvGST1baIZsUwgVrfSd1jcZbun6QVTuTsvz1SRNRZpM
         hPyORv6Mnzo7rzNYbaKn1lu19RJqPsFSMYBkZgWH0mmPLCWFnihW/gnTVPQCVUwUCsFa
         V6ON/eIQV5IlpYEVMrRughLufpO3yfCL9oRycywXfMTLdVrqkTCBhz9YguTaK5g3Fy5D
         PQCQDL9Qt5ryWzRb0I4KQ0RgNcVEhhLfaNyntc+2Aid3g0h0VOCJrsg5PApU5LT5/fXW
         dKoayQYl3Jtavb38/UAl8aZGngMCZljhjK+8GKSaC4g1elach+Wp+wlq1todZJvW4HrH
         nmpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787601713; x=1788206513;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RLVkVU6ts+TGH9dPTmESJlrY5y1GivISoEDjr8mjxtQ=;
        b=qnqN5D52FQq71BTE5r1ygnHT7gDVfQKsXrP5Xq7eWe0i/Pby2PACuycy9AwxjMAMHJ
         KsbdFdcMySlAOP49NAuHFyHykyPszOWi0iryxFpaEk7EDXwh4kKv300TcslGYRBuUqNC
         3aYUZ5Q47Ht5wG2m0trbHSRt4qh2+9tNacmpjhfzDPhvhIkpwy6z4Peljs3qNMkWY8sN
         pWtPGpdDCSf/lfNDv/H+QkKMK0JrDinC9NSUpO3M8Rp63vz5AmMFGcCSXuHd2VWedJPH
         Oc1wuNA/Rn5M3qnvt7lywiQwGqEq2x/fia6/jgXD/pxDIjU/pBSBDRAG1mTT2jkQl6cC
         7pnw==
X-Forwarded-Encrypted: i=1; AHgh+RqxSKyo0jZiFhuIQIwvsXcIHEKA/Mkd0xT2e/7b+00KWfjZDCyhMkIOhP12qw3bXkP35FwlSrXYwg==@kvack.org
X-Gm-Message-State: AFuF++m/A8qLK+V2pQ++48HBAe4/yJbzWz8zX+wJnKh6VKZz94BOwFQi
	G5RmxAmeRq2pDl55Tl0eqwEQ0VNQTmTbtmoryqfpUwZCesTohkREePTvfBMW5D3b2A==
X-Gm-Gg: AR+sD12f02D0wevkHNuXI86yyf6ZYz0jcf6L2r8aB5I/zclgoe/Y/t3i/f49gNv9dJH
	I5MQmmd37rrqComqBzK8/6469+7PPRQnC5xi7iWTmdsB5lqACeHrV+7ScFYpbY0RC8aDqvXYPOh
	zGisk9qIyj+0a/PRys+8PPmh2VD5EJVVQl8RnZAQrT6rnuym6OBQx5wRnvKm/dGA/BJ+9ccEeMV
	GhjfkgL43kE0RZUl/XK5ldve9YprzV6bE8oDCIQ9TpKUohEYZD+GMl+lAiaTVyXIhcP3g06HB3O
	ZlSsICc6unD9PpsmJT3uSWRE5DcE0u2LjFKyVWWP/to2XCm3bFTxD2teWCdCzTQWfqApE+tKZz7
	IkF+bgniX+S6Q5Kq4+3vcb4JOatH6Iv5DRFz/CF2PkyuwoSch0tVHmsRyTO+0NQ7/b/YrrPpsiA
	nulFDcmJhh21dW30n25GsrK9UV2RTDEAMdaZ9+Tj1VkcFONfwn1RUF1K8vAkSFy6Qy2YaN13xid
	0LUhq7PJREpuBAv/1kD8yzUA0asbxLwJBnr+INOsXMUBpflNoO3gE9WkZ0=
X-Received: by 2002:a17:903:2f8f:b0:2d6:3c22:994e with SMTP id d9443c01a7336-2d6e083547bmr879725ad.11.1787601712132;
        Mon, 24 Aug 2026 13:01:52 -0700 (PDT)
Received: from google.com (210.87.127.34.bc.googleusercontent.com. [34.127.87.210])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8520ef2ffdcsm2379917b3a.25.2026.08.24.13.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 13:01:51 -0700 (PDT)
Date: Mon, 24 Aug 2026 20:01:44 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v8 12/12] Documentation: PCI: Add documentation for Live
 Update
Message-ID: <aoyjEftPTSs8GDvo@google.com>
References: <20260728221007.2098560-1-dmatlack@google.com>
 <20260728221007.2098560-13-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260728221007.2098560-13-dmatlack@google.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DFD9020004
X-Stat-Signature: wh46bmsdeinhnp5y17ecj5yfbjesasm9
X-Rspam-User: 
X-HE-Tag: 1787601713-203831
X-HE-Meta: U2FsdGVkX1+g8m23Cfa9qHhStQUmDbPpNihX05MFQrdlOaDZAD83JzYCOBnT+L5hoXlWmrB1Ykhl21/P23sG19/P1ZGgzCITpGfXQ3BY/8QRHIkYKMN4SE67Ua8OIJpuPpnyQmUxQjyyE4wMrjiVtWbTIZ8KrChrhZ7Pty2KOVZyvsEHiWXCIKRcqT8FJ8oc8P3V8VBL+YcqW60o70RutVDBtXJwEgwDQvgtemJw72aFxgmssxWPMnlOEgRlAOD1VF+ldexh3YV/ImQbajBv7oM1evRUZj7k1qybsTqy4T9PXImSQmInMME9xswQu2XwKme+PbK1WwCRZsp2z0gZbgYCtUatcjOEmC6aZfpg6TV8sftiW1dSVRVYEAajko4dVA1Y0N3CpiYrtVlRSMwQk13Of2x/U1FhNWh+U07lvZArni3ywfCdiKXhcphSnxlj0hAPbrcPKhHxNt/w8kaNi3PdYVI1RcUPJx+n8KFtjMq81XA3J7SBKXPO2nC/eOeDmwjYbtYJie4id4WBbn9fVUyEyfcUUQbHYnPDq7fRLcqVcGj7kn3Yb5hPNapcig3e88R3MkToLmApxBUHtlOCF6pHdhrtUKXyhtPYmRhBcFg2Gl7kkeo+L9HOoQKcUfeIN0Jv9V+0MkOLrdbN8IteB3Jegxt13j2qGdRTP8Nmx+D5WvwEKYyk+K8x0ymQY6pwqK8M91bCL+N3B0Dx6srMyRfYqIXXG7EyF3+hnJHs2MhRsxbBoMVx5Qq5N/F3F5jgPGAAblICwQgdIQuqNkC2P/9h3FzCxjHVf93dMXfYpBUFTdFsZ1KIcbePIU4ic91AcxqFE2OjsY+/cYFv915EijLNHm1e35BQuREq7dqJXsIG/RNdFsHJNrT8xuMxVu+Ms0znWL2zuwjTXAKJdy+2ka7jVKp6seVPrr4Tz8PEKMwGXRRqQ4fx3+ae8x0kpztHlaPh6hphp8tV0V8A5/B
 /b5Mb3vJ
 XtNdSP6bw2oKpyewALxSBOywphtMYcksEL66PddzQ/oOnMHbFXhwBBbS4ma90mubbKbZuOuZH/5QWXshno8YdMcUgInYUCr9tVZg34jOYFI3bwIhOw5gYvp7grKXxkCFm/cOuWGgevr67XQpjclXeIzxArPRn2b8eWa+dFMTZI1TWnEJhqOT4JA0APBCbrOicX939T2PACZMCK9kyeEowuYKyw3Y2w/9aLXBr11LNVWN/Y5pYPR3Q5ds9JCjN8cu4ewmo1OAUCkBsEST/pFWxv3Mi4ZhrKoHjG/ei+tvSC6kB3wAQTVcPLA8AQ58iXnpbn5JT62jt+NY6syhy5lv0EZtmA7quEV+E3lFT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 10:10:06PM +0000, David Matlack wrote:
>Add documentation files for the PCI subsystem's participation in Live
>Update.
>
>These documentation files are generated from the kernel-doc comments
>in the PCI Live Update source code. They describe the File-Lifecycle
>Bound (FLB) API, the device tracking API, and the specific policies
>applied to preserved devices (such as bus number inheritance and bus
>mastering preservation).
>
>Reviewed-by: Pranjal Shrivastava <praan@google.com>
>Signed-off-by: David Matlack <dmatlack@google.com>
>---
> Documentation/PCI/index.rst           |  1 +
> Documentation/PCI/liveupdate.rst      | 35 +++++++++++++++++++++++++++
> Documentation/core-api/liveupdate.rst |  1 +
> MAINTAINERS                           |  1 +
> 4 files changed, 38 insertions(+)
> create mode 100644 Documentation/PCI/liveupdate.rst
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

