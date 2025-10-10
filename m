Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6966BCCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 06:39:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DA048E0003; Fri, 10 Oct 2025 02:39:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B2698E0002; Fri, 10 Oct 2025 02:39:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C7C48E0003; Fri, 10 Oct 2025 02:39:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6B8498E0002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 02:39:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1507184EB0
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 06:39:47 +0000 (UTC)
X-FDA: 83981254014.16.0727FC2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 55975180003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 06:39:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="E/E4XC0O";
	spf=pass (imf24.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760078385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7F3semd1DicSpX/Uh0XFyLtxDOVKVv9cLtfJqZqr310=;
	b=i7dn744azTuXcLuBX8OWy5n248fkh157V+wkTxl8IzGMm/qgtyr/pmySNBp2Yilq2Qa9CC
	YthnmfkVAwS4Z36zxgWmRZmCBzla2fMkZB9A/Fx70NIJiU5j0kgtB1/5bEPBIzt8Obidye
	LC5t4ujjHhVKkSRv1P1ZpQmp2czxRFk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="E/E4XC0O";
	spf=pass (imf24.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760078385; a=rsa-sha256;
	cv=none;
	b=qsLyzNfRYkMKNXWyyHgRIq9/WXjmXkgUh13NZbOPZGy4u+F2CM5BbgCANa3KaQztaVQZJq
	qMB+u6IFgeg2l26mwQMVE8kOHJPNOC72YaWd3vKVJcNZHassKC96V68qMEgo7UEjQZbmQK
	S3uxb3zv6do+PEBU32P/1AElkInOO/I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5AFF56020A;
	Fri, 10 Oct 2025 06:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC42C4CEF1;
	Fri, 10 Oct 2025 06:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760078383;
	bh=f275Z6QBP1oJ7FjNXnqjQQ3arZ+vlTTlgIAxDsW1u1A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E/E4XC0OPvNpqewhJaQ4nGbxL62esjMmVSltK67IIVcxdGmwf16INSfid2uo26dGR
	 963ucB1qo46+2lEPEd8aGn9IMZVMQdo+3Nh0mpr8weqS34CQPv1YYWugKh2Yv1Gp4g
	 sL2c6uu2EtJaHZ8tcsdSndMcHFBEBMyTE7XCuZh8=
Date: Fri, 10 Oct 2025 08:39:40 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: "Yanjun.Zhu" <yanjun.zhu@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, jasonmiu@google.com,
	graf@amazon.com, changyuanl@google.com, rppt@kernel.org,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com
Subject: Re: [PATCH v3 19/30] liveupdate: luo_sysfs: add sysfs state
 monitoring
Message-ID: <2025101001-sandpit-setup-7424@gregkh>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-20-pasha.tatashin@soleen.com>
 <a27f9f8f-dc03-441b-8aa7-7daeff6c82ae@linux.dev>
 <mafs0qzvcmje2.fsf@kernel.org>
 <CA+CK2bCx=kTVORq9dRE2h3Z4QQ-ggxanY2tDPRy13_ARhc+TqA@mail.gmail.com>
 <dc71808c-c6a4-434a-aee9-b97601814c92@linux.dev>
 <CA+CK2bBz3NvDmwUjCPiyTPH9yL6YpZ+vX=o2TkC2C7aViXO-pQ@mail.gmail.com>
 <d09881f5-0e0b-4795-99bf-cd3711ee48ab@linux.dev>
 <mafs0ecrbmzzh.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <mafs0ecrbmzzh.fsf@kernel.org>
X-Stat-Signature: wm7abbr54ctpt3ojr37kmdrccguyqx9z
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 55975180003
X-HE-Tag: 1760078385-732994
X-HE-Meta: U2FsdGVkX1/Te0BvgrcVqd7rlINOhHT8NhnLLipysQRyM3Vq3MmPzy+TAOG0FLAem4WB5NqxJoGFX63/X9U9qNDdvhjayo+ioB2VP1HcWCoyrOlgNR2Du9VE/e1ioQn7K3kbblJevoRKyPInQL4+b2DzTGpXtoXpO5bfdHyUW6nbHgXhHjXN3Qez41JwTgH+/5mh+lAp8Tf2qNcC28EkpYC5jdU/MCfe9IRugg9pi7dDPCImxvnLgorW60HK834DrOi97mCZknTRzRXxJvDW8eOIQIvXU5yhpxXOZtdjRHkoZixNVJn9xSIBOpLFFblDnqHhyevFOzbJmaXr8K29M9jaziHObJjjlFrYKXl4VPVVA4BsDrQ/NDi5VFDlur0TTiBE7aT4gVLSpHWj9EynyMJx4jL6ZSt8sEHI5G/X3F0rx29LuZJbI34G8HxXVtXmLQFBje3jrkZdgZqMUaULEXR17X5/g3J/eZWQaCx0cAEQNzu1PaGwTutLwr87b9p/w28tAvYnxZ1EgxoAUOEwTWfwTZ9qnqWxu9/OBM7gJdi5PuBJqikSSkWOX7QiUlLSJZ5g7aEBkRhfA5WkzdJ99+VLtAMzapDwNg5M5C5TiLni6vIUD32nj6wPPQz3kJz0vXXWzAHbl8f5AEgt1Gs+RT+lAF/b+4a3y2g7E0TlAl/RKDOkkjdce3mTDSpqlEDmVZZS+w3NXFqOgM1zJNUKqsNJrPGiaLjRUz4NAyLnmT24Ix9+8DsvrgHYATX4F0ShKyJIffpcAqcBeucQBCtzF6eSE3NlRd/vJP4ZpIabMI29lIGin5Ix+rAvLx2Ymatm0JQgwJdqzD4QAlomd/lXyV26ymNL04R3wTHt2aIY7fCZoxlZHU3k8CHVWI30Qumm7trC0i0wZgw1PlXUDiiBFXEG+aE9oosb0n3h64QkWI26JvybKXmFg17uZ/lanbCk2Agy9dPFOfMYpxJlM+A
 a5Si7tMD
 33FWe8omTMv6j+DmgHPJFU5oJpqKXLBekFyHS5SwqMoffjxRkkDSY/VzAqRa+JcW/kWgFecZEBmx+xZ5ZF9lHIqsLHzr1IAFLcmq7ZZp2FHGQ/O2VFKZya4jTBJsI/WTlX4RdUZ354sSXgUxYxmYA4yQrmR+LKlVEGaJK9S0oqaoVl12OmYQVm2W0Jrynoi8cpWwGdBW4DoQaFuLDDjg8rIYjkdQrLAsiQTajF5ngAU+qiDPGGj8aofQGaabseUqZfubqMSgLwuNwcBTTWVqdgUNzLG5Q4Xc9n7MDpFTDUpbAENwErWU7er3fg2yC8vAcdX1D7XjkrTHv0DR0n28E1dNChZxJBuig955X0EfkRAefXP4g/wNjoKj1cItKKKrpaGurLLJXCNW01a76Ff3w7OT5vEqannX8MVCuE5lpbSfs367kJCakDOT6jpPlOvkiLK2OHWL4rWTA76cb815r+UPFlg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 10, 2025 at 01:12:18AM +0200, Pratyush Yadav wrote:
> On Thu, Oct 09 2025, Yanjun.Zhu wrote:
> 
> > On 10/9/25 10:04 AM, Pasha Tatashin wrote:
> >> On Thu, Oct 9, 2025 at 11:35 AM Zhu Yanjun <yanjun.zhu@linux.dev> wrote:
> >>>
> >>> 在 2025/10/9 5:01, Pasha Tatashin 写道:
> >>>>>> Because the window of kernel live update is short, it is difficult to statistics
> >>>>>> how many times the kernel is live updated.
> >>>>>>
> >>>>>> Is it possible to add a variable to statistics the times that the kernel is live
> >>>>>> updated?
> >>>>> The kernel doesn't do the live update on its own. The process is driven
> >>>>> and sequenced by userspace. So if you want to keep statistics, you
> >>>>> should do it from your userspace (luod maybe?). I don't see any need for
> >>>>> this in the kernel.
> >>>>>
> >>>> One use case I can think of is including information in kdump or the
> >>>> backtrace warning/panic messages about how many times this machine has
> >>>> been live-updated. In the past, I've seen bugs (related to memory
> >>>> corruption) that occurred only after several kexecs, not on the first
> >>>> one. With live updates, especially while the code is being stabilized,
> >>>> I imagine we might have a similar situation. For that reason, it could
> >>>> be useful to have a count in the dmesg logs showing how many times
> >>>> this machine has been live-updated. While this information is also
> >>>> available in userspace, it would be simpler for kernel developers
> >>>> triaging these issues if everything were in one place.
> 
> Hmm, good point.
> 
> >>> I’m considering this issue from a system security perspective. After the
> >>> kernel is automatically updated, user-space applications are usually
> >>> unaware of the change. In one possible scenario, an attacker could
> >>> replace the kernel with a compromised version, while user-space
> >>> applications remain unaware of it — which poses a potential security risk.
> 
> Wouldn't signing be the way to avoid that? Because if the kernel is
> compromised then it can very well fake the reboot count as well.
> 
> >>>
> >>> To mitigate this, it would be useful to expose the number of kernel
> >>> updates through a sysfs interface, so that we can detect whether the
> >>> kernel has been updated and then collect information about the new
> >>> kernel to check for possible security issues.
> >>>
> >>> Of course, there are other ways to detect kernel updates — for example,
> >>> by using ftrace to monitor functions involved in live kernel updates —
> >>> but such approaches tend to have a higher performance overhead. In
> >>> contrast, adding a simple update counter to track live kernel updates
> >>> would provide similar monitoring capability with minimal overhead.
> >> Would a print during boot, i.e. when we print that this kernel is live
> >> updating, we could include the number, work for you? Otherwise, we
> >> could export this number in a debugfs.
> > Since I received a notification that my previous message was not sent
> > successfully, I am resending it.
> >
> > IMO, it would be better to export this number via debugfs. This approach reduces
> > the overhead involved in detecting a kernel live update.
> > If the number is printed in logs instead, the overhead would be higher compared
> > to using debugfs.
> 
> Yeah, debugfs sounds fine. No ABI at least.

Do not provide any functionality in debugfs that userspace relies on at
all, as odds are, it will not be able to be accessed by most/all of
userspace on many systems.  It is for debugging only.

thanks,

greg k-h

