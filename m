Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 259F4CCA471
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 05:20:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4821A8E0062; Thu,  9 Oct 2025 01:20:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 431678E0002; Thu,  9 Oct 2025 01:20:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F9578E0062; Thu,  9 Oct 2025 01:20:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 18E1D8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:20:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AF708160A01
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 05:20:41 +0000 (UTC)
X-FDA: 83977425882.25.EB8A746
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0CE321A0007
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 05:20:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="EO/xg1I5";
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf19.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759987240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=De3VqLpqj2CiqrZMFK1q7cE9ACD3DwJWFkVMFXD3cds=;
	b=f8WXmvHTnDY/Ojdzf3xAwY9EHiMaDhoclqIB6B6wj0mZP1c+oWTbC98HY53rNxz0ew9P1a
	IOZ950Uod/Bo62yhs6SCBgcIWKt64iR0+I+Hp4PyrYkc0PzkUDq63OpTgBPp0xQUMQ5oiO
	sTK+HCjOQ96Nu9SDlNMs9zDGINyu0h4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="EO/xg1I5";
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf19.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759987240; a=rsa-sha256;
	cv=none;
	b=5DVpvS/rU//g71SMaSgr1wVdDR8BAq7yNtlAvr//fbOdMiv1ZPzWgDWsJTi9N0XsGi5znF
	vYeGxareZ+jHu8sS63nRZNgoOe5Pc9WMninfWO56Ir4tHx30qeLP2xc8vyLk6KslpBn+FD
	9W0/OBSqxByV65snicMeZLO7lVOYq3c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 97913621A4;
	Thu,  9 Oct 2025 05:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBDDC4CEE7;
	Thu,  9 Oct 2025 05:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759987238;
	bh=OgkTj9432fZmlNS0UH+uhZjP/yq09nzN3kBXCzSELF8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EO/xg1I5JxJ6Gng6yPKjQlyZ9RssCFhDlylg693XLeMCae87nGqGQdAPxdnk8nFqp
	 tGbZ2uEepHWq8ACteVrpxj3i53VzsVaJrIn5BN4RwNbKOGlLS4fHBgH090sMdPb0K2
	 5VclVGHelHJoTEyjNpjKhoyN0Eu+X/Xlw7KJlSIQ=
Date: Thu, 9 Oct 2025 07:20:35 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: "yanjun.zhu" <yanjun.zhu@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, pratyush@kernel.org,
	jasonmiu@google.com, graf@amazon.com, changyuanl@google.com,
	rppt@kernel.org, dmatlack@google.com, rientjes@google.com,
	corbet@lwn.net, rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com,
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org,
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr,
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com,
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com,
	vincent.guittot@linaro.org, hannes@cmpxchg.org,
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
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com
Subject: Re: [PATCH v3 19/30] liveupdate: luo_sysfs: add sysfs state
 monitoring
Message-ID: <2025100953-plug-acting-9530@gregkh>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-20-pasha.tatashin@soleen.com>
 <a27f9f8f-dc03-441b-8aa7-7daeff6c82ae@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a27f9f8f-dc03-441b-8aa7-7daeff6c82ae@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 0CE321A0007
X-Rspamd-Server: rspam03
X-Stat-Signature: 17wrjzy3simyxmbuu49337xi1gz799mh
X-HE-Tag: 1759987239-744386
X-HE-Meta: U2FsdGVkX19XkTM1CeDwKrOYLsbEtJAziuyl+CHl67kZ3Jrr1jKKMXIPkjO2S5YePLH/Rm5kbc6X7Wxf3c59MHMHHixbW7n8BiAHDDnfGTAzb4P+yGMmi39bs5jpOUZ1QeN+aCgU2Xo/RK2XhGiM//oMfSfe8lL8EYf4qdk4zib+s76xIODa8Qq2g6gPp9pcfkJODfrBPd5w+AGkJ8Cah2UMzFdZmqLiYy0sQE2+DlPt0XUvR9/CL1a+97eSyxPtOpkI99zHjwbDZeU+GI3oPrJ7rvA+mx+fWPGHrvWkUQ3K7VPlzJydUcs7z/VO+HqGSL3425NyfaHO5k5pfrA/3EUW6jvFl56xuUOWdWW64tPYsqX7BfSktTVgZWwBpaX5FbUxtFMPnQ0kp7ThNB/A4q//op47usPvyA/EkZp/rTjXglxqHHV5/KXuhgvvMyv5fRAi9e99l/UOQbwd8nEzI2w0CYOYSbTXVU0Kf5VtlYdwmKu8+jgfIDZzrVRojiMX+9SNXcD5IzKOJSOw41h1wc4QY2fbRvfP5lUV8HRZLBuysxpzrMLf5g6phmwP0W4e5NI6dNzhUMzTtjkkdz8Em9PflUp4HodNDBHUcEGR5pqpPmbXeATWp8WWXCVMzbSMTSWWbRl04SqHrTmWBmb3j6yrmppADKvxyUZu50oxON870t/lph7LMq2eU70fd51wC9jv33amfJj4rz1Yud5EQ31feIjM6XG7IGyjbUuIDVRZF8WAejbeejyEwn+J94cPQhZ1+758a+qjJ1vGyBF1CQIDFNXl+6Zi7uht7ahChGwUy36513tN1OpOoPaetaO1HGB0kcm1BUhRyUm2at8HQYKrWFL5e2/tWAz/uYSG5PnSVcXYIRoG8bYoChEFhyM4GGQDllK1HSEUCVVoI+uNB26amBq1vi1Mq2A+fcTFp7ONtBGYRv/SP1LICnI7/Im/cltaYjJ7wFU5QYEpiW2
 D0OeYzop
 tZMc/ae+SdeHBs1Ze+w/CYU8iCZNpqMP6oHp4vmFQMfu3Nr3boBUOiQBh0HA3cySI4tmR7cbJ7uxjIUkK06wN8pkQTSddiBZVJW9QYrGWOYVIZCfO5ShQKFX9/ML1JLhqW2oRvGMOCbt9sqgCOrOedvMEzTDc2xk1pyRLu6m3Dn1DwaPm9LB0TvooTpza2QDWSPVYDFUZJhBkEde/s4cv02w0pJyVBDHdktbKr32hUdBNpc1lWDCV346TAQ0oxkUTjkrRFmyxUG0cdKlB0SJPtoLFgB2IlubvkrGLnuzHZmZQNX8S9ASgb2QefAOWKwXabDx8L/yjF02RJC+/aPhLrICzKc8aiBSNBaoOrzZAfDl9i9wW3AiFfjO3mSklx/zbMsmx5spQbdRKx4Ikr7PLhEFun8zHGRkR+Kd6ixvwP8pYMA0TFmN0LYwYgQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 08, 2025 at 06:07:00PM -0700, yanjun.zhu wrote:
> > +#define LUO_DIR_NAME	"liveupdate"
> > +
> > +void luo_sysfs_notify(void)
> > +{
> > +	if (luo_sysfs_initialized)
> > +		sysfs_notify(kernel_kobj, LUO_DIR_NAME, "state");
> > +}
> > +
> > +/* Show the current live update state */
> > +static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
> > +			  char *buf)
> > +{
> > +	return sysfs_emit(buf, "%s\n", luo_current_state_str());
> 
> Because the window of kernel live update is short, it is difficult to
> statistics how many times the kernel is live updated.
> 
> Is it possible to add a variable to statistics the times that the kernel is
> live updated?
> 
> For example, define a global variable of type atomic_t or u64 in the core
> module:
> 
> #include <linux/atomic.h>
> 
> static atomic_t klu_counter = ATOMIC_INIT(0);
> 
> 
> Every time a live update completes successfully, increment the counter:
> 
> atomic_inc(&klu_counter);
> 
> Then exporting this value through /proc or /sys so that user space can check
> it:
> 
> static ssize_t klu_counter_show(struct kobject *kobj, struct kobj_attribute
> *attr, char *buf)
> {
>     return sprintf(buf, "%d\n", atomic_read(&klu_counter));
> }

But the value can change right after you read it, so how do you "know"
it is up to date?

What exactly do you want to do with this type of information?  What are
you going to do with that information?

thanks,

greg k-h

