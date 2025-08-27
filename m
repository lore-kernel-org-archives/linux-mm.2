Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E548CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 14:02:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 814856B008C; Wed, 27 Aug 2025 10:02:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C5316B0093; Wed, 27 Aug 2025 10:02:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B3DB6B0095; Wed, 27 Aug 2025 10:02:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 585C56B008C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 10:02:03 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9FCD1118EAA
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:02:02 +0000 (UTC)
X-FDA: 83822701284.23.2D95F5C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0931C8001C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:02:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VoKwCtSZ;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756303321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zp9u03Zd0ARKY6ZHzbWzXRwXFPt6S37L+dqZxpn4MF4=;
	b=2WOisrSWv+4Ubon6H/+BC7nzalr1cRNEAIM120zZmnhI6VlYaajMv3yZv1zLqnAUKtwIvn
	7jsJRIVuPCCqIgWHBdMba9BctZ972G6d0NN0oJsBgOAIda4tPQDQJFUmlXo8OLwUqRSy7Z
	9+SMq7FCyn5AY3qobAuLRHp09h59Pyc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756303321; a=rsa-sha256;
	cv=none;
	b=gv7xghNg6TyYolw/qpoRSXToFdzAxHu7dtmE2P8XP3WSRb/sVXJf/6zmyzvZkdOHdkAzso
	RcwtZUu23bC8CCW0URlUEEzoWvSa56cEhtWGoxUIBICicNGniha0TPdLYD6ybA76z2Umjn
	/OA5/t2Kg0E1X8FU9L8/GcScDtooN+c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VoKwCtSZ;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CFC5B60280;
	Wed, 27 Aug 2025 14:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02845C4CEEB;
	Wed, 27 Aug 2025 14:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756303319;
	bh=rrLE6VNYaV1/todpYtogxf/XlET+/1DTpL2efIVhb2s=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=VoKwCtSZRI6dLK2wXJrBsq6FBKn+MgCUTrGFhttvBg+W0g+hVhbO7RY19OdOFnU0F
	 wHT05QXXsO9xXkWaU0ITpHRpolLXz6UTO6AoX9p5znLcFhOqQotcxjqdpqVsX5FOwm
	 SF1kuJWCWGhc0yH2ORFzT9k5txerhwMYorKV4b+OoVLcSPgIb3+j5pb0P0lAD9+oua
	 S+qpKa/ThKfCDu8LTnuQrPTO/QTMFwherQZbng0FTmr5Ib73VnIIf9za9302Ya0ZC4
	 WW+AhyHMTwTOregtvQlZeMDhr2B4nFoR+IgCJ6+GX6WMezBSIG34xzzP3rNcqvcJlA
	 ouf7ZD2nrKcXA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>,  Pratyush Yadav <pratyush@kernel.org>,
  jasonmiu@google.com,  graf@amazon.com,  changyuanl@google.com,
  rppt@kernel.org,  dmatlack@google.com,  rientjes@google.com,
  corbet@lwn.net,  rdunlap@infradead.org,  ilpo.jarvinen@linux.intel.com,
  kanie@linux.alibaba.com,  ojeda@kernel.org,  aliceryhl@google.com,
  masahiroy@kernel.org,  akpm@linux-foundation.org,  tj@kernel.org,
  yoann.congal@smile.fr,  mmaurer@google.com,  roman.gushchin@linux.dev,
  chenridong@huawei.com,  axboe@kernel.dk,  mark.rutland@arm.com,
  jannh@google.com,  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
  dan.j.williams@intel.com,  david@redhat.com,  joel.granados@kernel.org,
  rostedt@goodmis.org,  anna.schumaker@oracle.com,  song@kernel.org,
  zhangguopeng@kylinos.cn,  linux@weissschuh.net,
  linux-kernel@vger.kernel.org,  linux-doc@vger.kernel.org,
  linux-mm@kvack.org,  gregkh@linuxfoundation.org,  tglx@linutronix.de,
  mingo@redhat.com,  bp@alien8.de,  dave.hansen@linux.intel.com,
  x86@kernel.org,  hpa@zytor.com,  rafael@kernel.org,  dakr@kernel.org,
  bartosz.golaszewski@linaro.org,  cw00.choi@samsung.com,
  myungjoo.ham@samsung.com,  yesanishhere@gmail.com,
  Jonathan.Cameron@huawei.com,  quic_zijuhu@quicinc.com,
  aleksander.lobakin@intel.com,  ira.weiny@intel.com,
  andriy.shevchenko@linux.intel.com,  leon@kernel.org,  lukas@wunner.de,
  bhelgaas@google.com,  wagi@kernel.org,  djeffery@redhat.com,
  stuart.w.hayes@gmail.com,  lennart@poettering.net,  brauner@kernel.org,
  linux-api@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  saeedm@nvidia.com,  ajayachandra@nvidia.com,  parav@nvidia.com,
  leonro@nvidia.com,  witu@nvidia.com
Subject: Re: [PATCH v3 00/30] Live Update Orchestrator
In-Reply-To: <CA+CK2bB9r_pMzd0VbLsAGTwh8kvV_o3rFM_W--drutewomr1ZQ@mail.gmail.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
	<mafs0ms7mxly1.fsf@kernel.org>
	<CA+CK2bBoLi9tYWHSFyDEHWd_cwvS_hR4q2HMmg-C+SJpQDNs=g@mail.gmail.com>
	<20250826142406.GE1970008@nvidia.com>
	<CA+CK2bBrCd8t_BUeE-sVPGjsJwmtk3mCSVhTMGbseTi_Wk+4yQ@mail.gmail.com>
	<20250826151327.GA2130239@nvidia.com>
	<CA+CK2bAbqMb0ZYvsC9tsf6w5myfUyqo3N4fUP3CwVA_kUDQteg@mail.gmail.com>
	<20250826162203.GE2130239@nvidia.com>
	<CA+CK2bB9r_pMzd0VbLsAGTwh8kvV_o3rFM_W--drutewomr1ZQ@mail.gmail.com>
Date: Wed, 27 Aug 2025 16:01:47 +0200
Message-ID: <mafs0frdcyib8.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0931C8001C
X-Stat-Signature: whmb8t4r536xgunk8swic41yffmdgdz9
X-HE-Tag: 1756303320-337498
X-HE-Meta: U2FsdGVkX18CIKxi+guhnoNeNurtjoh1nriFJ8IgXSOnL98Xgl/tGZvlpwXuW1KerTatvvNkB84dMIDfxQcAA3/Qs9LPpOXqun+ZSeK5gJTI4wB6aqph6ohxyNdF4i/WyF8Ntc0riFDyC5gZ4Hcba2jGFvP5QXXmIhLHbAm0x5ve1xDg0FxSpQVmlpOIJQgY01mRHbM9IJMGWClUVGTg2liUffxRxitwB6PI/ni7lte6R/auhNOQ/YUBBBCVHUx9vY8eP5e20K9rFXb1Yp3iu56lJh1TdWOUoByojzIwjDuys8FDKChs7URIeR506QqK0XU97LSL60WWdj7bP4LOmUz/gIww9cCYG/HPpsBcopHD4VOiYxJAe/GWdWaT0n71iKCIjnQFrQRcKN82u4XFrjPXmD8BQ2yMYqGPX2rbUqhqlDVQx204OtBYnocx33KhEzTbB7ZQcczMTy1x/Oxhf4OWH0IAZWwwPNRu4N641ZAh0I0kyCYVGupJTx7dEogGsIcTyyG+WBH0sm4/dKJCbvsPbgZm+ZUT/hah/RdbS+XVPP16LolXrdAmErlbAXuQMh5176vD3mYHXi7IWI336ZsOIZvVhVUtJ1NKAL+hc5dWbB6LKSR9K/pb03BTPYhfrrxPnFLIrHJ+waD2NOzExEoJZ8I1XVoPBrIDKrcGXL4cqUCjHTv5ub9byAFKwQRLL82U2FSKBgQYDJ4C/PVpXYP5FH19VqHlbvAMyIpsIV4PEqBldCZx1LQsKVfjJ5O1ew9erj6J3psZRadAdowWIs143bctpUu+mp4hFLY4xraLkwpvA2D1JBkUwpjOw9vJE3qBtPOQsMEJOWNllQfkNIh058BhhKcOd44XhCfBD7l3QQOjYQFFkX8BD/L4Cn2Zfi0m13reOY754oNoWIyS1e/+/w44Q71EjcM5hE14wjgfMn0GopkT/xuL8qWLjorntPO2oM92LVVL0ZPd0gj
 A+qD5Nc1
 u1yJWf25q3FR2Pn99lT0+chZsKKV/jELU2Ddi6h4ujKbJ0zbSvspHtYqt3D4DzgzugEiSLOCLtOa+ZpiblyPVk8I35SnD9E9Vpnn6AAa9Ss6SWFKpBe3PYCJNaVFo/DHlBkFw/5EjSVq7i+CK4wxmjd27xkkW83PEuxcrM1x1XZqpWprWy2oZTM3FFKXkwm64o3e9rtVpEablmD2rh79Y++T2Qva20JYwx61vjNZPM7eZlZc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26 2025, Pasha Tatashin wrote:

>> > The existing interface, with the addition of passing a pidfd, provides
>> > the necessary flexibility without being invasive. The change would be
>> > localized to the new code that performs the FD retrieval and wouldn't
>> > involve spoofing current or making widespread changes.
>> > For example, to handle cgroup charging for a memfd, the flow inside
>> > memfd_luo_retrieve() would look something like this:
>> >
>> > task = get_pid_task(target_pid, PIDTYPE_PID);
>> > mm = get_task_mm(task);
>> >     // ...
>> >     folio = kho_restore_folio(phys);
>> >     // Charge to the target mm, not 'current->mm'
>> >     mem_cgroup_charge(folio, mm, ...);
>> > mmput(mm);
>> > put_task_struct(task);
>> >
>> > This approach seems quite contained, and does not modify the existing
>> > interfaces. It avoids the need for the kernel to manage the entire
>> > session state and its associated security model.

Even with sessions, I don't think the kernel has to deal with the
security model. /dev/liveupdate can still be single-open only, with only
luod getting access to it. The the kernel just hands over sessions to
luod (maybe with a new ioctl LIVEUPDATE_IOCTL_CREATE_SESSION), and luod
takes care of the security model and lifecycle. If luod crashes and
loses its handle to /dev/liveupdate, all the sessions associated with it
go away too.

Essentially, the sessions from kernel perspective would just be a
container to group different resources together. I think this adds a
small bit of complexity on the session management and serialization
side, but I think will save complexity on participating subsystems.

>>
>> Execpt it doesn't work like that in all places, iommufd for example
>> uses GFP_KERNEL_ACCOUNT which relies on current.
>
> That's a good point. For kernel allocations, I don't see a clean way
> to account for a different process.
>
> We should not be doing major allocations during the retrieval process
> itself. Ideally, the kernel would restore an FD using only the
> preserved folio data (that we can cleanly charge), and then let the
> user process perform any subsequent actions that might cause new
> kernel memory allocations. However, I can see how that might not be
> practical for all handlers.
>
> Perhaps, we should add session extensions to the kernel as follow-up
> after this series lands, we would also need to rewrite luod design
> accordingly to move some of the sessions logic into the kernel.

I know the KHO is supposed to not be backwards compatible yet. What is
the goal for the LUO APIs? Are they also not backwards compatible? If
not, I think we should also consider how sessions will play into
backwards compatibility. For example, once we add sessions, what happens
to the older versions of luod that directly call preserve or unpreserve?

-- 
Regards,
Pratyush Yadav

