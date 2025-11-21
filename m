Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22520CFC28D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 15:55:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 104EB6B002A; Fri, 21 Nov 2025 10:55:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DD896B002C; Fri, 21 Nov 2025 10:55:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F34856B002D; Fri, 21 Nov 2025 10:55:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DBD906B002A
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:55:53 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8A87A13025D
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 15:55:53 +0000 (UTC)
X-FDA: 84135064986.15.C359AA2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id CA84C40014
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 15:55:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WES5sOMj;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763740551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8tYnSUWc2mbeJ4ZRBcyi/dtQNT1sZhBRsgg8NJNqx10=;
	b=kpQ0bS3UDA/CRNkx+UQlKDXwK91mcagY/KqHYEpkNkcwu14PE4/8yt5lsGT+xf9vUN/lvo
	Fy5I8q2Q+ZVg39DaUDp/29njDjXR7nrXCfcKrvB85Y/Dc3WPV7c/hXKG/LFq9wAuyg8arU
	MBJMVweMjc4xvMiOE8Kt0eg5D3pKUOY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763740552; a=rsa-sha256;
	cv=none;
	b=lpStuDMYEeumB1s5//QDwaHbBrEgQtLsS10MfrRzBtX7ppGJWFLO3MQNv3VlMqT6D5Krf3
	zxnl5kYQxkTl/x+A203CqkCtUK8ENX64gxUId+RBth0ZLFQTpKY0haFlynYAB4Kl1LP8Av
	Y3qm3AgoZP4tbrXjC6ZVTM2ln6aMAkM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WES5sOMj;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 47F5E40BB1;
	Fri, 21 Nov 2025 15:55:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F28C4CEF1;
	Fri, 21 Nov 2025 15:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763740550;
	bh=8K8v4Fqc1uPGUBC8powdKMrR3iKxfMCptCFO6IAuuh8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=WES5sOMjmeBJGZu3nYtoQyB/m5dAzcI1PJuJTRFO/cQh1YV4bi5dSqlMG49+TkMWQ
	 6FvKh4HBeQE3QxPBe5mw/rXyTiMb3cVq7HGL63h/lRTHjmv8SuCYviUw5oMCb5qq5E
	 0E+wJACBqr/CzkdoUnErDHRT7Tg4hrVh03tbKuHi/Ql3dNMLlcIxoTjn6q0NSEuDTm
	 oiaf2kQYhlZXogOQGlGhRolF+d4xYE4eZ7588U0oURn5bcn7SCd1bicigyv4ENdImD
	 iyiZ315qFHzYMbuvr986pS9db9FLhsPyPXvC0M+qREcI1bRi7VidVVZlhHaHpiNXVM
	 69dMJFY0/3BTw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org,  jasonmiu@google.com,  graf@amazon.com,
  rppt@kernel.org,  dmatlack@google.com,  rientjes@google.com,
  corbet@lwn.net,  rdunlap@infradead.org,  ilpo.jarvinen@linux.intel.com,
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
  saeedm@nvidia.com,  ajayachandra@nvidia.com,  jgg@nvidia.com,
  parav@nvidia.com,  leonro@nvidia.com,  witu@nvidia.com,
  hughd@google.com,  skhawaja@google.com,  chrisl@kernel.org
Subject: Re: [PATCH v6 03/20] kexec: call liveupdate_reboot() before kexec
In-Reply-To: <20251115233409.768044-4-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Sat, 15 Nov 2025 18:33:49 -0500")
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
	<20251115233409.768044-4-pasha.tatashin@soleen.com>
Date: Fri, 21 Nov 2025 16:55:39 +0100
Message-ID: <mafs0cy5b1itg.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: itfwqz6ny1ne3y9d5894xqy6c6imjkeh
X-Rspam-User: 
X-Rspamd-Queue-Id: CA84C40014
X-Rspamd-Server: rspam01
X-HE-Tag: 1763740551-434113
X-HE-Meta: U2FsdGVkX1/GoCyiMv0vs3iupcEceqX3qBxwWdhwJHOQhuvA4DoeAscvaHicS7EDRTJyhroGHiiu3KvPrrd8gz3vbkipJFVJ2RwM4Qi0P8C/N3ToFbqSJEOkftd0iUtGC2P9TAOG3atk5eNXR8zLFLYnlF2TNQpHkdbgWnU4fz9hI6HO/NA5hku4PjQ79kBjmyo0o7+aQZ8cR5zJlb4Ovi6t5StzmhGyEBs8M5O7LRIVrdvlFImC0tXDggpIZEUVY+TVVkRseA9jo4oiparaEgL0gzuABVMdh+Kq0GnNt30659vhCgcxf6hrybudSO25MrVWdnBBJWkOyb2ERkbukFswEZA5ftQ3xDVpJj+C0MgagaozVWNgII4GzJlsKiVTKGXWpz6t42T57Q9UAqgjEFrkdQKMJLccYZmRwC0pVVAShENQblPAQqhhJH/+geYmdokI1gSrVCCii4K/AihLgjh2+4GHZEMa3ix6RSiFd/bLPXU6qDYz5/vgq6W7jLrBIwWtYCctJvfhE1vXSCa5IPpUciIKD2T0RTiVJYct1mIqd57DcSNVQiFwh1qA556PiIeDlbVn7M8MQyffGHAhR4ge5jL1FyDEeAR7CxQmOsjU0nuzHdEdT1cWsLSxYOU6wqUNs8VWiBw3dtc1fvXWxaNJR1TZRws5hp1f+Rr/fw0NoSuq8SgoAp5Etyx8KcM6V1ockmFh7YY6C+JaYrYtHgI8IsvZsVm9mEQGLpv+OxPXyS2Melw8P4d7iMMo2VDQAZgz4Wb7LtSIzKjI/kfBfiusJWFdtJY7NimM3kh3E7PHHc8cplKUf6wYQz5H2X6y3fkho/6lGj9LIq0E8upPo79px6qzLIXcVGQlD2eKexlugvZ+jsm7NHEV+gmuFNK9GNhQmyEr1SVCKu8Klzu1KoT6XUuqaNgYGwCE/0U/HBORdwzKrC54nUFPjEnviBVhZOabsCXw8MQrKiCz+jA
 sB4ZX7ID
 7ho3YrMv1Nk8MelZjPMFC2pkgXnl+26+FkVD6ClW5ptVxKjS71qQreUiOpqnea+84ZMWI3ahdhnkZjvaeuYit/77k2y807wyl6asDwOguj3PS5mMYz0QzfTW4BXBVWaLenyfOgSOeuYnavCvKf5blDXCvxSamNOkB/HHHew9ruj9NpGLJGSj9hERxylmdgXETEo5VLboEDUzME/hAgNcjmpUuf3ggWkvjhGkxr52CmTJoSSiDUnq47C/1HZEvlOgu14R/2FtAkeAv72dUxl7VpeHSp5bpnLts0PE+fzDlTQ9ICXb+0FV+SgPSJE1bIwPWQlHLUfvUyvrQprwJg2x8a14gOfC455FHqg5M0UijGZxHWAXAyDmEkd8P+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 15 2025, Pasha Tatashin wrote:

> Modify the kernel_kexec() to call liveupdate_reboot().
>
> This ensures that the Live Update Orchestrator is notified just
> before the kernel executes the kexec jump. The liveupdate_reboot()
> function triggers the final freeze event, allowing participating
> FDs perform last-minute check or state saving within the blackout
> window.
>
> If liveupdate_reboot() returns an error (indicating a failure during
> LUO finalization), the kexec operation is aborted to prevent proceeding
> with an inconsistent state. An error is returned to user.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

