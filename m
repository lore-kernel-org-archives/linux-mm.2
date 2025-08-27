Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73631CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 15:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9AEB6B0010; Wed, 27 Aug 2025 11:34:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A726E6B0011; Wed, 27 Aug 2025 11:34:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B5446B0012; Wed, 27 Aug 2025 11:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 89DD26B0010
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:34:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3D9CEBB321
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 15:34:44 +0000 (UTC)
X-FDA: 83822934888.12.B3E791B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 718A018000A
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 15:34:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e6v+GpFx;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756308882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fmJBZQv42HVCGPEvA8cfxESd+YMYRejwuN3HV6o/S1E=;
	b=8YkkuadpED1RwcJH0d3f+UUSYG1gTiIVzl4dojs58aRL+fiU21gnVPoN6N7C17v/yK+VDy
	jemYMa1Hb7YQtwDtuT05uSWeq+VvAuiRq0A0OJQ1xQyc+Yxd60jn4hvk18hy+6Wfi/ScFd
	59jO64AJRMu9wgL9zH+IvdfRUD0wpVY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756308882; a=rsa-sha256;
	cv=none;
	b=lI7KBYbHFMo++pvDOFbtfCFD8nKgMSbRUkVRER/ddfrtifEGYdw9ktvcdFnVmbg3rhT0J4
	MDOLrpWIkYYlSwk/ZoPOS20m8uop3krTwRCoWZPhc1mUfQUxI2uOgKsZSw2IuFPB4rRcYr
	MiYVCQIlMdNnIiMxX0wiO4AHGnpe1Fc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e6v+GpFx;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 06AB943416;
	Wed, 27 Aug 2025 15:34:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC4AC4CEF0;
	Wed, 27 Aug 2025 15:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756308880;
	bh=/hHoYvlbaeWmt9yGXT8TP2XYUsiA//N6BuAAiOClRwY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=e6v+GpFxja9vW9YNrveOO418XZOPc4iSrQvWmcZAoH6Mc4PKvw7UBBQ60MGplx8OJ
	 aoiC9hnqMNugU0Xj0H2VpaLaqrXLxVMtj8qdu7PogapUHHlTYMMod3aNgdyrNzrJN5
	 jmtfsaPmnSptrjABNdhm5J1zvmRLRd8pCh/OOhD0fxETxQeHxFSOe/nlKZg2fj+ZoT
	 KD7gSbtqY7kjdvRsSJUwACMaSJ2HmJZxOU9clnPNVBzB4RssvVAWJHfsVm2f/lcqsn
	 wrDmCM6GjAFmlZobcWtXrgwFnEWMrVvQ5xDd1fvmkcjujpbQ9twhauEaGtD+wOX4CF
	 q2OX9DZbgo5fQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org,  jasonmiu@google.com,  graf@amazon.com,
  changyuanl@google.com,  rppt@kernel.org,  dmatlack@google.com,
  rientjes@google.com,  corbet@lwn.net,  rdunlap@infradead.org,
  ilpo.jarvinen@linux.intel.com,  kanie@linux.alibaba.com,
  ojeda@kernel.org,  aliceryhl@google.com,  masahiroy@kernel.org,
  akpm@linux-foundation.org,  tj@kernel.org,  yoann.congal@smile.fr,
  mmaurer@google.com,  roman.gushchin@linux.dev,  chenridong@huawei.com,
  axboe@kernel.dk,  mark.rutland@arm.com,  jannh@google.com,
  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
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
  saeedm@nvidia.com,  ajayachandra@nvidia.com,  jgg@nvidia.com,
  parav@nvidia.com,  leonro@nvidia.com,  witu@nvidia.com
Subject: Re: [PATCH v3 17/30] liveupdate: luo_files: luo_ioctl: Unregister
 all FDs on device close
In-Reply-To: <20250807014442.3829950-18-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
	<20250807014442.3829950-18-pasha.tatashin@soleen.com>
Date: Wed, 27 Aug 2025 17:34:29 +0200
Message-ID: <mafs07byoye0q.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 718A018000A
X-Stat-Signature: 6s3penw19wh79yjgufh9d9cfrnwhjwpu
X-HE-Tag: 1756308882-510379
X-HE-Meta: U2FsdGVkX19vFCLmg1RV2Ng1osR7oGSRGnbeEhVm61+2qc9VoG084Zg5vPTuQbOxkj+VrPLijZ8WLJQX3lN7xkbSqUoSQxcweK84Z8GoVoOAn1q28NatCVcbKDqMGXTxUwmzAzL3rh4u9ahfFDj7PlSX9Ed+lIRI9ycCWURIVdbQWl1RbhUpwZLVglQPS8UbztcM8abMiVYSputQng30SDXM5ThCNNHn2zHD3d1mNPah3uPMcCoCVBlU0AkcxXNPXjQJneBZc/IkF3OQMFedyWGtQm7sUvWDijnrYQwWCDJ05CtM96BBxdrDDeVDIC0MrPfn4bfEv0SQwZh6SZk42McqIiFOxv5NynlP9lLpRnqltPnPQ/0alAPEHyR8jdHbjhcE8GSricdayAagkx5bfvhtFFKA5rosXGxDIDE0U2ksuTCVqYOEG80J7dgpr35S1mf8FqMABWRGKS8iWGu+OskXdHFYi825zKAMT213UfsHOxjuYckPGbkLVIrXzo5NWQ6RAilgpw+k0/RdgSHKtSC2CkkVEylLChtmEbyI+iB/hpfPxf9hsEb6uRRM4hBFfeFTRApIFticH2fQmMAfP49rTu7mFUuWk5c1hLb+693S2lTsfO/75uiGNm8zhGLmu0F+gbapgvf+0XyCNQa5OzjPJ/IxKacwcj8WIIoDGqn9XLsQYwCXYYVacR0CBLSCVlnTFDCtyJSDnttxRbsr1BllYy2EE2NIhQu2wxYtZuaUQfl6Xrsgdj3rg5vCNhYnibZRQn2r2UIy2Qc0Yo2ZjLXu3tRJytIM307PloAzoedZxzW7OLJFgHndQTaTpLliQlVDzZMnQYbOHEFFyoJREy8rXYOIqca2hiHnTswY8R8q2QLExRt7dnjyrxo1CZFq/7XjUZ11XtW2DgdhW7opYyHv+tLS8t8ltfXEXq5aE9Udk71JTVh2QSnO4oAZh3vV77n3OLR3NZbW7nwXSR2
 HumPOPnf
 EhQ+c5MZBmLjfJOeeoNI6wYw50eM8pu1PMZcXwlByhr/LyoeNXAUSHcHpzJobUZox3RUL3oCVJlRn8GvUsY2XY0Btj8MADNGnmrh5AeAeSM4vwHNfqrzym0E09J0OWJgZgmPOWvSutz9yv2gvvqOi3nglM1ALGhqyoRuAfR02szE5g5VuklvXI91CCfuJbgiiJj+gTwByxbrb5tUUXZiKRmb5ZXY5xwUp9GKkiL4eXAHFw1ifNouOlo7tSOMaHh4VbgQ7k6WdjgJe8LDtmxZ8wWmPfudzSyhpKhrI3iF6HjC1zqAQCQZU9JMnVGdlkFkiaw7KpKMmWr3T8UXs/OejY6RN7fgZDRYGAuDk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pasha,

On Thu, Aug 07 2025, Pasha Tatashin wrote:

> Currently, a file descriptor registered for preservation via the remains
> globally registered with LUO until it is explicitly unregistered. This
> creates a potential for resource leaks into the next kernel if the
> userspace agent crashes or exits without proper cleanup before a live
> update is fully initiated.
>
> This patch ties the lifetime of FD preservation requests to the lifetime
> of the open file descriptor for /dev/liveupdate, creating an implicit
> "session".
>
> When the /dev/liveupdate file descriptor is closed (either explicitly
> via close() or implicitly on process exit/crash), the .release
> handler, luo_release(), is now called. This handler invokes the new
> function luo_unregister_all_files(), which iterates through all FDs
> that were preserved through that session and unregisters them.

Why special case files here? Shouldn't you undo all the serialization
done for all the subsystems?

Anyway, this is buggy. I found this when testing the memfd patches. If
you preserve a memfd and close the /dev/liveupdate FD before reboot,
luo_unregister_all_files() calls the cancel callback, which calls
kho_unpreserve_folio(). But kho_unpreserve_folio() fails because KHO is
still in finalized state. This doesn't happen when cancelling explicitly
because luo_cancel() calls kho_abort().

I think you should just make the release go through the cancel flow,
since the operation is essentially a cancel anyway. There are subtle
differences here though, since the release might be called before
prepare, so we need to be careful of that.


>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/luo_files.c    | 19 +++++++++++++++++++
>  kernel/liveupdate/luo_internal.h |  1 +
>  kernel/liveupdate/luo_ioctl.c    |  1 +
>  3 files changed, 21 insertions(+)
>
> diff --git a/kernel/liveupdate/luo_files.c b/kernel/liveupdate/luo_files.c
> index 33577c9e9a64..63f8b086b785 100644
> --- a/kernel/liveupdate/luo_files.c
> +++ b/kernel/liveupdate/luo_files.c
> @@ -721,6 +721,25 @@ int luo_unregister_file(u64 token)
>  	return ret;
>  }
>  
> +/**
> + * luo_unregister_all_files - Unpreserve all currently registered files.
> + *
> + * Iterates through all file descriptors currently registered for preservation
> + * and unregisters them, freeing all associated resources. This is typically
> + * called when LUO agent exits.
> + */
> +void luo_unregister_all_files(void)
> +{
> +	struct luo_file *luo_file;
> +	unsigned long token;
> +
> +	luo_state_read_enter();
> +	xa_for_each(&luo_files_xa_out, token, luo_file)
> +		__luo_unregister_file(token);
> +	luo_state_read_exit();
> +	WARN_ON_ONCE(atomic64_read(&luo_files_count) != 0);
> +}
> +
>  /**
>   * luo_retrieve_file - Find a registered file instance by its token.
>   * @token: The unique token of the file instance to retrieve.
> diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
> index 5692196fd425..189e032d7738 100644
> --- a/kernel/liveupdate/luo_internal.h
> +++ b/kernel/liveupdate/luo_internal.h
> @@ -37,5 +37,6 @@ void luo_do_subsystems_cancel_calls(void);
>  int luo_retrieve_file(u64 token, struct file **filep);
>  int luo_register_file(u64 token, int fd);
>  int luo_unregister_file(u64 token);
> +void luo_unregister_all_files(void);
>  
>  #endif /* _LINUX_LUO_INTERNAL_H */
> diff --git a/kernel/liveupdate/luo_ioctl.c b/kernel/liveupdate/luo_ioctl.c
> index 6f61569c94e8..7ca33d1c868f 100644
> --- a/kernel/liveupdate/luo_ioctl.c
> +++ b/kernel/liveupdate/luo_ioctl.c
> @@ -137,6 +137,7 @@ static int luo_open(struct inode *inodep, struct file *filep)
>  
>  static int luo_release(struct inode *inodep, struct file *filep)
>  {
> +	luo_unregister_all_files();
>  	atomic_set(&luo_device_in_use, 0);
>  
>  	return 0;

-- 
Regards,
Pratyush Yadav

