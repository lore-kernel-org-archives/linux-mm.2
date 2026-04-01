Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EA9410F6FA3
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 14:36:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A5316B0005; Wed,  1 Apr 2026 10:36:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77CBD6B0088; Wed,  1 Apr 2026 10:36:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 692BE6B008A; Wed,  1 Apr 2026 10:36:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 577646B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:36:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0290E140927
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:36:56 +0000 (UTC)
X-FDA: 84610238874.26.E9BCD35
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3AF934000F
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:36:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mh1uVFU6;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mh1uVFU6;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775054215; a=rsa-sha256;
	cv=none;
	b=jwBZoZP7MoXN2wpUMoZtpLe4k6LiPjkUxg5k1ZRMtur6/g5v8kHe9LUNjysPH9Bg5Q9H2n
	TfuXjB+sWDBzmcvzGPkrSw54YNYEIZmkirY3f0GnixpIO0rx8VN2yZzT+kQG9tLUt63bKB
	xL+OPEtR4gzv1ymwZGpsG32Jqf93gNk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775054215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8h0ChXywYOozRzlTLLnCXSm74OrmWHjAXIktN37FNBA=;
	b=om2AkOb5a6m1d31nxVpacNiEx0a8JsM4JP0pKRv6aam0JzB1dirIrYdbf6ouGfwsDrD17H
	QovA/zi60WSH+mDBX968/TFIYIZgpCfJZx7RBM5VzjexCO/K3BEPDKHaoywL4JMzdljguC
	Q7Q7z+zm3iU3cAvZpl3GMrREHupaCsA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4757640ADF;
	Wed,  1 Apr 2026 14:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA7AC4CEF7;
	Wed,  1 Apr 2026 14:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775054214;
	bh=RihWe9fQIxmIgwDhwcNSbhkpSL03nKNn1qbJPB0J2+U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Mh1uVFU6JNai1F9LdjWZbPPl7KJBJc8d/UReYXUGnDCRuxJaxSzbVyb7uI1yVk0eY
	 z4tCaC1+/jcFn4w7FOqjQ5BcWgrcLvdBZQzSVhYpDx26G+zrVLqFu14gCt8nS+Vi5h
	 Ifn3lWC0ydfzvZHrDwRLhJVy/vnguhYMQZ6l43sez2ujouO57nd14+jJqIsNMuLjTZ
	 qsftSArXs+pzZFPBoUFoOUWsuqKUAjQ/4tInVAjNM80oBXZLDQZQZZu14Wg+LXTNBF
	 ChHo0rv201AbzjEGvwdUL3WGHrR1zPBnYNTp0o7SujROuhxgfybL+8NoXMIyzSXYsG
	 8x5XQRwJKsnHA==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>,  Adithya Jayachandran
 <ajayachandra@nvidia.com>,  Alexander Graf <graf@amazon.com>,  Alex Mastro
 <amastro@fb.com>,  Alistair Popple <apopple@nvidia.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Ankit Agrawal <ankita@nvidia.com>,  Bjorn
 Helgaas <bhelgaas@google.com>,  Chris Li <chrisl@kernel.org>,  David
 Rientjes <rientjes@google.com>,  Jacob Pan
 <jacob.pan@linux.microsoft.com>,  Jason Gunthorpe <jgg@nvidia.com>,  Jason
 Gunthorpe <jgg@ziepe.ca>,  Jonathan Corbet <corbet@lwn.net>,  Josh Hilke
 <jrhilke@google.com>,  Kevin Tian <kevin.tian@intel.com>,
  kexec@lists.infradead.org,  kvm@vger.kernel.org,  Leon Romanovsky
 <leon@kernel.org>,  Leon Romanovsky <leonro@nvidia.com>,
  linux-doc@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  linux-mm@kvack.org,
  linux-pci@vger.kernel.org,  Lukas Wunner <lukas@wunner.de>,  =?utf-8?Q?M?=
 =?utf-8?Q?icha=C5=82?=
 Winiarski <michal.winiarski@intel.com>,  Mike Rapoport <rppt@kernel.org>,
  Parav Pandit <parav@nvidia.com>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Pranjal Shrivastava <praan@google.com>,
  Pratyush Yadav <pratyush@kernel.org>,  Raghavendra Rao Ananta
 <rananta@google.com>,  Rodrigo Vivi <rodrigo.vivi@intel.com>,  Saeed
 Mahameed <saeedm@nvidia.com>,  Samiullah Khawaja <skhawaja@google.com>,
  Shuah Khan <skhan@linuxfoundation.org>,  Thomas =?utf-8?Q?Hellstr=C3=B6m?=
 <thomas.hellstrom@linux.intel.com>,  Tomita Moeko <tomitamoeko@gmail.com>,
  Vipin Sharma <vipinsh@google.com>,  Vivek Kasireddy
 <vivek.kasireddy@intel.com>,  William Tu <witu@nvidia.com>,  Yi Liu
 <yi.l.liu@intel.com>,  Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 06/22] vfio/pci: Retrieve preserved device files
 after Live Update
In-Reply-To: <aaDZ-ffs4kiUo3GY@google.com> (David Matlack's message of "Thu,
	26 Feb 2026 23:40:41 +0000")
References: <20260129212510.967611-1-dmatlack@google.com>
	<20260129212510.967611-7-dmatlack@google.com>
	<20260226155222.5452a741@shazbot.org> <aaDZ-ffs4kiUo3GY@google.com>
Date: Wed, 01 Apr 2026 14:36:44 +0000
Message-ID: <2vxzjyuqhhmr.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3AF934000F
X-Stat-Signature: ymckspop4mddey47obmg8za7n5a7gnz1
X-Rspam-User: 
X-HE-Tag: 1775054214-619504
X-HE-Meta: U2FsdGVkX1+1w4ubbIZLY3/8a4mld5YGV6Nu4/xHCwCEiRcwC3EWiDnHvbWHkBXSyEvDkbsuNDe1sBv5wlNgKUIULGNzYVO01+Gl+F1r3Z3lie4i6V4wzLHA/aqYN6CqNlLxSp4YC4Iap2rjvR9i7SO7F3SRcmXDMKZFJJyhxf7WaG6XY/vFnnNMj9Et7j3rogS5gWD/rswlJ6a7TtlyzyKEiiOhCGA+IdABjw3sKu6vyZ22zLdahzTxYoYE20MyOC15eIezfWO3+Mhisp/p2Sg9GwFL7jJj1a9LWzgnRccDABRYitBHitSRnv+2fTvfzb8h2i7qIFHD+nVU/ETsNJqHwoOa0cXUNZD9EXAeUDa9USpdY5I5tkS54MfUVuFYIl77CnOXugJjoI7SONQHj15RQjGpS8CkuMVpoGtDA0v/TEQst2zO659aHcdSaeTo5m6jRlj9NwxrLqoHf1r5pHhnP54ViyF/lYYPhP4dxan+uhdNDBu8NrckSlZVCI8eEB0fJNLBFnSGGIB2HG1ts9W+yB7UfJlww2R2Dp9Gwi1fHsbJtcvkS6ULxUeERZz2pnZwG0n7Ni1QaLIsaOQJ1brrLD9Xf7baRXCoMlVqVPbpN6ZAmT3uFyoOm3REG2eSEw9YrF1BkbNQL0D+7ygh0F65BagR3aW+sPsJT6obZXmrZsoKlfulmk9XyUllaTWg5+F/L6G7UhWvkXc46tfKwH1fPPemdxCHUaOIOzUWcIEr7j2fQm6MoD2GGA4MtzKANDU8cZa4qm7cAGkK+F7j9rhVmLsw243h7OGt80Ot7jWhpTWv3xBZQPm+eoGlDgnJYf4pfmpbJ2b89TgV9LJVqGxMPkkw+cdO4aw+XAWoO1kMasXmwb/NLzv7MQ8kFi5QbLBCJjmH3pUClzh7YzKwTMGcUqEa+vEhi5uqdRURlso/oB3S1uMVfgY6kOFzKSkT4H51GWHRc+cGRbSCUe9
 P2LcjpTI
 6O1bqGPooysqOAJ4+eo+qN94uyxricZg7OVYY3i0d1cAS9dx8fEgbrAIYys8/S9/5meRF7gv8AT4+tu2eSiL+RBvJ4wxw+QLoxbUbf/035H+xKV88MbiLGlArR0bAt68voefdkPvBJElWOoP1P0l4e91D9NHmjA3c0r3lUXilO0f+/xM3TQqcqBuQ/Q6yza5kCfIb76PU8ff2VoiQp9Y6+dCTBaWHTnposqZo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26 2026, David Matlack wrote:

> On 2026-02-26 03:52 PM, Alex Williamson wrote:
>> On Thu, 29 Jan 2026 21:24:53 +0000 David Matlack <dmatlack@google.com> wrote:
>
>> > diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
>> > index 8ceca24ac136..935f84a35875 100644
>> > --- a/drivers/vfio/device_cdev.c
>> > +++ b/drivers/vfio/device_cdev.c
>> > @@ -52,6 +46,19 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
>> >  	vfio_device_put_registration(device);
>> >  	return ret;
>> >  }
>> > +EXPORT_SYMBOL_GPL(__vfio_device_fops_cdev_open);
>> 
>> I really dislike that we're exporting the underscore variant, which
>> implies it's an internal function that the caller should understand the
>> constraints, without outlining any constraints.
>> 
>> I'm not sure what a good alternative is.  We can drop fops since this
>> isn't called from file_operations.  Maybe vfio_device_cdev_open_file().
>
> Ack. Due to the bug you pointed out below, I think the changes in this
> file will look fairly different in the next version. But no matter what
> I'll avoid exporting a underscore variant without outlining the
> constraints.

I haven't yet had a chance to read v3 so maybe you already solved this
problem. But I dealt with some similar problems for the memfd patches
[0] and the hugetlb patches [1]. What I did was to just use/add a
internal header (mm/internal.h or mm/hugetlb_internal.h). This lets you
share functions within your subsystem but avoid exporting everywhere
else.

I see that there already is drivers/vfio/vfio.h so perhaps you can use
that to avoid exporting these functions outside the subsystem?

[0] https://git.kernel.org/torvalds/c/ed6f45f81bf9
[1] https://lore.kernel.org/linux-mm/20251206230222.853493-6-pratyush@kernel.org/

[...]

-- 
Regards,
Pratyush Yadav

