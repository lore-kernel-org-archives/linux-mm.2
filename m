Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F3CAD39008
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 19:02:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5ED36B008C; Wed, 14 Jan 2026 14:02:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0C426B0092; Wed, 14 Jan 2026 14:02:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B361D6B0093; Wed, 14 Jan 2026 14:02:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A23156B008C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:02:49 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3336713B5F4
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:02:49 +0000 (UTC)
X-FDA: 84331491258.30.597AC0E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id A1E64180012
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:02:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MDy3xT6j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768417367; a=rsa-sha256;
	cv=none;
	b=XkOhxubeaLugqttjvN97BrJv8QXwWOWxp411rPs2bs07WYTVZfQRm6NZoI+Do/mOsnTt2y
	2QfiSN/NyjMA4/9mtry9IgLTBbleyfRqhrUqFmL9Zi0HCQgG/jF9Ge3Lr68t34nyNVod3P
	yummDDnq6eLhtN1SJF/eqyMJt6v+PfY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MDy3xT6j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768417367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K6LZNNkSxE9Tb9HUp9nc6tRbG87lkfFbOQymF4sZ0mc=;
	b=NEVmMwVHfruEcPM4SPC/DpFVUxxD6ETNB+6oHaAQ//0cFH3nhq90RKAREw07NRJi1OjnpY
	6M1Coj7PEYo5f+dmkexvIImTv9RENhW3WtwGNq0BXZkmj08peMHmnpXT66MbPg/056fyG8
	avty4j6zfjQHtu33QznizJIUuFaJjuQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CA04E60138;
	Wed, 14 Jan 2026 19:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC1CC4CEF7;
	Wed, 14 Jan 2026 19:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768417366;
	bh=/g7znYFrTNdvW4RKWutiVFghMR5mmCYvmvOEw8ACiRY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=MDy3xT6jPzV3ToLQ0kmCeUKluxH6b6eqZef89YSDaEdyPmUTF25s0ngTuJRsFWG9I
	 926T/0gY2RTddhgU1TCiaRmd4sCjIUiNFcQZzygn8PStwkaslCSJiBbriS+MdR5RTj
	 B/PYWWzg6p+l/Y98krWhmMK6Cvrgw3f+JfcZjWNbQbYOpPZCIpFUDsjnIux2zFOsUM
	 qS7dO+juVkXHGmH+RbP66XAuWNKf+qL0xFihgSLD8kYJp9N3hKv0AHG50sCTOIyUas
	 4CvfudY0fUeQnlrTe8OQZdiqGrDg83Wff11I/f/gUsKjJYUJf9t8TrQqO0WQYrdSdM
	 CP8ErjTmVxEUw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  pratyush@kernel.org,
  jasonmiu@google.com,  graf@amazon.com,  rppt@kernel.org,
  dmatlack@google.com,  rientjes@google.com,  corbet@lwn.net,
  rdunlap@infradead.org,  ilpo.jarvinen@linux.intel.com,
  kanie@linux.alibaba.com,  ojeda@kernel.org,  aliceryhl@google.com,
  masahiroy@kernel.org,  akpm@linux-foundation.org,  tj@kernel.org,
  yoann.congal@smile.fr,  mmaurer@google.com,  roman.gushchin@linux.dev,
  chenridong@huawei.com,  axboe@kernel.dk,  mark.rutland@arm.com,
  jannh@google.com,  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
  dan.j.williams@intel.com,  david@redhat.com,  joel.granados@kernel.org,
  rostedt@goodmis.org,  anna.schumaker@oracle.com,  song@kernel.org,
  linux@weissschuh.net,  linux-kernel@vger.kernel.org,
  linux-doc@vger.kernel.org,  linux-mm@kvack.org,
  gregkh@linuxfoundation.org,  tglx@linutronix.de,  mingo@redhat.com,
  bp@alien8.de,  dave.hansen@linux.intel.com,  x86@kernel.org,
  hpa@zytor.com,  rafael@kernel.org,  dakr@kernel.org,
  bartosz.golaszewski@linaro.org,  cw00.choi@samsung.com,
  myungjoo.ham@samsung.com,  yesanishhere@gmail.com,
  Jonathan.Cameron@huawei.com,  quic_zijuhu@quicinc.com,
  aleksander.lobakin@intel.com,  ira.weiny@intel.com,
  andriy.shevchenko@linux.intel.com,  leon@kernel.org,  lukas@wunner.de,
  bhelgaas@google.com,  wagi@kernel.org,  djeffery@redhat.com,
  stuart.w.hayes@gmail.com,  lennart@poettering.net,  brauner@kernel.org,
  linux-api@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  saeedm@nvidia.com,  ajayachandra@nvidia.com,  parav@nvidia.com,
  leonro@nvidia.com,  witu@nvidia.com,  hughd@google.com,
  skhawaja@google.com,  chrisl@kernel.org
Subject: Re: [PATCH v8 14/18] mm: memfd_luo: allow preserving memfd
In-Reply-To: <20260107185414.GG293394@nvidia.com> (Jason Gunthorpe's message
	of "Wed, 7 Jan 2026 14:54:14 -0400")
References: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
	<20251125165850.3389713-15-pasha.tatashin@soleen.com>
	<20260107185414.GG293394@nvidia.com>
Date: Wed, 14 Jan 2026 19:02:34 +0000
Message-ID: <2vxzecnshvat.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A1E64180012
X-Stat-Signature: bqdp7w3oeby34ccg6g9esijjz5nh4ipx
X-Rspam-User: 
X-HE-Tag: 1768417367-808447
X-HE-Meta: U2FsdGVkX1+IyZg1dgXu1lMqpIJtBnvuWY1ja8VHwkr13oT31MFJvcqNsOLSwQD+X/jIrUeJXBb2Lx1/ARv3clDuRQC4cHHegPC4aVcML8szO+SgZsYCBWtpVjnY+WqcSUl5m/9jdxMUfiU6SSybECKH6mEk0PMbk6dvoeYxifSQEFQK7WxTW3G1NRryuQWL89mg9jFFn9bOijvSh7lW6cjJksEZAq3xte5m6tiI9kob7VQPRX9wG1hC4ad/50cL3kmIEobbZi7eD8omYX8BuJT91jFA79342qJOsVwE0w0nCowME/YjfF14O0bRdrbh4HnxP1TBD18AumACnDg97pZiZJFW5tCIGQT1UckLCmtyIHdya1yXcZFGtkV8D08lKZGagYubrLrbYfXFIz1/B92JCfZoS7cfUtuIRxBn9xGloIJvXSNjQGGqMZXUZxbYu8Jw3rKEV7aEFTXzkOgAqN3OSt3fhoimyz7RGYNYfWXVZxZ00i8L+CltqXnUQdXfQgDN1xuv7xKvUyNxvgAT6WAKmc8OMAgRM66kPEX3JVr9bh9e1nx77vg6dxeagpWTCyA25cu7Exq7EJk0+WhZtatFF6axChz0Uwa6GrUx2BtbnkHCnB+PAGmWiRiVB/u+g2hFYn0AhDJYTBVnL915OhChf0uO0MZE44OYYkk9+DIn1BC1treqA3LpZviD7TEZ/xAkr8ZpI+3d5S2wxe5kk8dC52bqNqSmfy9WrRZXrHp8XsUEmoRmXbTXRsslI98GzUWMIKh8nVBezDu+4ExALrGEvGwbZ/B93P+241cf4SGWG4rc4Cnt/lt121zZIMItSxRS6bDUsQdeT9VzyVLFaZfm9zGrSRHTqz1qfFV9P+edAxxSIrdysMSKpmI5SUF+/lkQT89mWADBnDREKjg2YZKrkzRtje86waNjUJkRjt/rEjgVjqBF+6TQHhP87wDyIPkABmL74D/9D5X0al/
 rBGVjHit
 ZydhTXPHcXGn0oBobI4CnWBQXtK82GPkh150PNC3YzPjS9JbQ3xpLklSQXX/fqLacDtYu8ms529YTqQdEPr8WIlRgHCyGnpruceL2K0ykxjGQnjt0uRQaxulPQ+1GIeJFcKiBEzRT2+7ZhJKhPJvT+TyETKGuzJV7Wr9dh7Zgig+PKj5vrd3fqbeali3yzNPw8qbOpEEqqKXeH2XvdlYkllXz2iVdkxrVV1E+usjlHXkjT6xdoC9QqKwLoLG1CrbadcmrFwEeWg06C8sQVoQBMHROsd9pQ9u00bRgIFAE2hHbAkQyYv2BlgQxWQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07 2026, Jason Gunthorpe wrote:

> On Tue, Nov 25, 2025 at 11:58:44AM -0500, Pasha Tatashin wrote:
>> From: Pratyush Yadav <ptyadav@amazon.de>
>> 
>> The ability to preserve a memfd allows userspace to use KHO and LUO to
>> transfer its memory contents to the next kernel. This is useful in many
>> ways. For one, it can be used with IOMMUFD as the backing store for
>> IOMMU page tables. Preserving IOMMUFD is essential for performing a
>> hypervisor live update with passthrough devices. memfd support provides
>> the first building block for making that possible.
>
> I would lead with the use of memfd to back the guest memory pages for
> use with KVM :)

I would assume using 1G-page-backed memfd is the more common use case,
and this patch doesn't come with 1G page support.

Anyway, the patch is now already applied so we can't go back and fix
the commit message...

-- 
Regards,
Pratyush Yadav

