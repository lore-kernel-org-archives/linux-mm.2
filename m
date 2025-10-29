Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CE95CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 20:39:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 083688E00F8; Wed, 29 Oct 2025 16:37:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 032EE8E00B2; Wed, 29 Oct 2025 16:37:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E65C78E00F8; Wed, 29 Oct 2025 16:37:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D350A8E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:37:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 836951A0454
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:37:20 +0000 (UTC)
X-FDA: 84052311840.08.01BA609
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id C6160180003
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:37:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n09xHDXm;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761770238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NIPSWLPCR2Jm8kTQ0SAvYTxm9JVxRWM8IgFinS+qmxQ=;
	b=2qleW+6FbCRPp3DcEEXJbRKvnQXauVMjK/2g2JbhFujouesy0j7fVv1Mz4bm3RmK3oB0bk
	7EcPBDtYUPv29GT7wi+MGqpZVq6wb2RX9NlTiZ5n5vlOo6Zm/Lckk9YQVVhcdJoMDYpNt7
	pewzuBaPCyGOZpbt3dEwuNinOhC7Ry8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n09xHDXm;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761770238; a=rsa-sha256;
	cv=none;
	b=6fZbu4DXNzCVIqzXPxXJ8iGxAnlXpomffTqyBPZSy1iY7dCZ31mVpue7RN1iCDaaK9B2Bs
	pz50sZUdxGZVeDTNiwTaAjrLqkKpJtNnlJLMLoQ/1P6DxxHeIHYTd2kZ7DazD40FgBVVj3
	tpdDRRAvEna/yqbjEmWi5Yqu0iV8Um8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D5DFA4098F;
	Wed, 29 Oct 2025 20:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0922EC4CEF7;
	Wed, 29 Oct 2025 20:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761770237;
	bh=IpX/Efp/7aa50ROsEckRQKklVIBMT4CdHzNQdUOYZSM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=n09xHDXm0NQvt/2Ihe4zZw4wfbyxmW01sr5F8oIz0+NnVpvOvmas9ZSUBNZuoBGN8
	 yEUJexJrt6G+WaI+v6LoH9gHjUpBA5BgORDfuZmGBbK3TrpvucNv6D2Vzm5utrHI4q
	 pBUL8cT3REaEsOervShr6BCXoflf/q4Zf7hRGKWQfXn9qeY6JQuwrG/JnTCqUmOgc5
	 hT3dN0/xAkSwkHPBtLgg673vpsvLCHWXvgFnnNtDwNVoukqqWeY37QF3Bn8d4S9NOe
	 mYI5z05LwzeakeUjJcmVfE5NKNLhG1ADoKaEcjy+z5rYJLGUcRLtFsViiwUYIno+Xw
	 B2KC49VWJpNWw==
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
  parav@nvidia.com,  leonro@nvidia.com,  witu@nvidia.com,
  hughd@google.com,  skhawaja@google.com,  chrisl@kernel.org,
  steven.sistare@oracle.com
Subject: Re: [PATCH v4 14/30] liveupdate: luo_session: Add ioctls for file
 preservation and state management
In-Reply-To: <20250929010321.3462457-15-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Mon, 29 Sep 2025 01:03:05 +0000")
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
	<20250929010321.3462457-15-pasha.tatashin@soleen.com>
Date: Wed, 29 Oct 2025 21:37:06 +0100
Message-ID: <mafs0pla5cuml.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: C6160180003
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: sk867ttmxxhwfninab5pndsunayp46gj
X-HE-Tag: 1761770238-433439
X-HE-Meta: U2FsdGVkX1+yzwCwdK83x/j6fY0xvo/vIB2LsXfAQXcbe2Nex5kj7hzZfzuGEVtlPJmSCcdK+p4xh5hPYCq01x0hKvFTnsHCNXv7gfiA2Uto5DXlY7xJZdIHF3D3li101TXHyY7DeApZmMzWf6O3rWBq+mBpeQUQYRK23We8hdILBDtMBKET6zReaeb/ciYKWjLqliRK75fWzZacH8zF0Gp7wPGWVpUzR25o6A29lThefPqxxOKlx4nHR2HZQNn/9Fqb/OC4kiYZ1dt9bdlY/kMZx9aYbVSNFohFr+Sp/WivgOaM6tGiJ4uBUVzxX2Mo0TXS+lWUyYQqZiGe6FnviyiDss80arUt2w40n+x2VaGXngXSgdANw3UrfxU1VW7DCuFx8OlIwsH0KGbeb5G2reUgWY00v6jCl0+UeNT1Bu/rnPwVnS7gbykzDqgxEnuNKUIVU7VZh+Ju84O1gw/5FIUr5DC6MvROj4w8R67efFKVUdkKkBnesoMPg+MXJdIT89jkGrdd6D9QACLZ7SG+Qjh2bfIdn1xB8P6Yp8o9d6uTstjkd/Q1eGCvk90g0UZKiOEFFBCgQEy5X3eefItkVel8qR0gB/2ufnU6EuRLWwM9oc25qQdcrc7jwykyvRmilXaWxiUw0Za5wozm1rysvfiNIlC0JBgqyobjS/GGTVydgwy0VHyAe+v3cIik/FMBLjoDMavh/gynq56a9Tn6TyODSMFfTUxS8mnOMETktHiIb78uce56TpeL6tYd0O2fI9A1+acR3AccftdJcZlQTu5iQtp/IkQpO0eXP525OeKIivYomt8xSLE+9uiG2JRqtQSOX5RADFRAVl8z0vhUR7lVwsKZzBQUnwWZQh5YwsONGhaUoPB4vWd2EWt8+IZZ0fKWclmOz9f5QVsIoOJj+mKduPhKN+w7/q3vPwesBU8gzYcDxxhSMfa98ymsqpZwquHLnoz6rBl0CD6kMO2
 JQa5OaFD
 iFwN8Rb1O7daucL+i0Xq0zn2TBlgiBAOv6GYj5uVwjpyST1zxsN8zTSDPCQd15c62FcO8Ui2CGNa2EKr67ikQNAbM9zLnxXexEsD9NS7OE+lgPHTOlixplm8FB/icpqE8ysQZMmNgun7KJREUKtGB4GXE55Nm4e9GDsQxK4kgSiUsqMDKRiLqC7ZrweC2GK68lY+8h7+0EJufvwReH/lgWaBvH5XD/YSn9AFcHLBJst4hhWt24lqTHlw0ls3XxWELrW9uTu/oK2gi97zkLi+U9gkhyoXfh7aeafCzZf9ojcy5qJlfGyaqDPUr/f+AgcpJEtlnGYH0nRFe4soD61E2NC0NCRuXtWWF+1yU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pasha,

On Mon, Sep 29 2025, Pasha Tatashin wrote:

> Introducing the userspace interface and internal logic required to
> manage the lifecycle of file descriptors within a session. Previously, a
> session was merely a container; this change makes it a functional
> management unit.
>
> The following capabilities are added:
>
> A new set of ioctl commands are added, which operate on the file
> descriptor returned by CREATE_SESSION. This allows userspace to:
> - LIVEUPDATE_SESSION_PRESERVE_FD: Add a file descriptor to a session
>   to be preserved across the live update.
> - LIVEUPDATE_SESSION_UNPRESERVE_FD: Remove a previously added file
>   descriptor from the session.
> - LIVEUPDATE_SESSION_RESTORE_FD: Retrieve a preserved file in the
>   new kernel using its unique token.
>
> A state machine for each individual session, distinct from the global
> LUO state. This enables more granular control, allowing userspace to
> prepare or freeze specific sessions independently. This is managed via:
> - LIVEUPDATE_SESSION_SET_EVENT: An ioctl to send PREPARE, FREEZE,
>   CANCEL, or FINISH events to a single session.
> - LIVEUPDATE_SESSION_GET_STATE: An ioctl to query the current state
>   of a single session.
>
> The global subsystem callbacks (luo_session_prepare, luo_session_freeze)
> are updated to iterate through all existing sessions. They now trigger
> the appropriate per-session state transitions for any sessions that
> haven't already been transitioned individually by userspace.
>
> The session's .release handler is enhanced to be state-aware. When a
> session's file descriptor is closed, it now correctly cancels or
> finishes the session based on its current state before freeing all
> associated file resources, preventing resource leaks.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
[...]
> +static int luo_session_restore_fd(struct luo_session *session,
> +				  struct luo_ucmd *ucmd)
> +{
> +	struct liveupdate_session_restore_fd *argp = ucmd->cmd;
> +	struct file *file;
> +	int ret;
> +
> +	guard(rwsem_read)(&luo_state_rwsem);
> +	if (!liveupdate_state_updated())
> +		return -EBUSY;
> +
> +	argp->fd = get_unused_fd_flags(O_CLOEXEC);
> +	if (argp->fd < 0)
> +		return argp->fd;
> +
> +	guard(mutex)(&session->mutex);
> +
> +	/* Session might have already finished independatly from global state */
> +	if (session->state != LIVEUPDATE_STATE_UPDATED)
> +		return -EBUSY;
> +
> +	ret = luo_retrieve_file(session, argp->token, &file);

The retrieve behaviour here causes some nastiness.

When the session is deserialized by luo_session_deserialize(), all the
files get added to the session's files_list. Now when a process
retrieves the session after kexec and restores a file, the file
handler's retrieve callback is invoked, deserializing and restoring the
file. Once deserialization is done, the callback usually frees up the
metadata. All this is fine.

The problem is that the file stays on on the files_list. When the
process closes the session FD, the unpreserve callback is invoked for
all files.

The unpreserve callback should undo what preserve did. That is, free up
serialization data. After a file is restored post-kexec, the things to
free up are different. For example, on a memfd, the folios won't be
pinned anymore. So invoking unpreserve on a retrieved file doesn't work
and causes UAF or other invalid behaviour.

I think you should treat retrieve as a unpreserve as well, and remove
the file from the session's list.

Side note: I see that a lot of code in luo_file.c works with the session
data structures directly. For example, luo_file_deserialize() adds the
file to session->files_list. I think the code would be a lot cleaner and
maintainable if the concerns were clearly separated.
luo_file_deserialize() should focus on deserializing a file given a
compatible and data, and all the dealing with the session's state should
be done by luo_session_deserialize().

luo_file_deserialize() is just an example, but I think the idea can be
applied in more places.

[...]

-- 
Regards,
Pratyush Yadav

