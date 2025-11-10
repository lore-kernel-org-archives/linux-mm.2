Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC590CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 17:28:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DBE18E0020; Mon, 10 Nov 2025 12:27:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B3378E0003; Mon, 10 Nov 2025 12:27:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DEE28E0020; Mon, 10 Nov 2025 12:27:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 47F1B8E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 12:27:45 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0562A572FA
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:27:45 +0000 (UTC)
X-FDA: 84095379690.10.09965A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3BDFDA000D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:27:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kOEmXq56;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762795663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mFAlVWiKYLdPJ/T2toy6isqwv6/KtbnO149SK8FdfDw=;
	b=UreGpwWCzklimnAx0BcJ1gdf6ETCspOvXXK5U0vhNsKArLvoGvuYBuPjzXhCVxyTSkNTyT
	O5S9Ia1Fh+rNyQ8VH8bqdFm81k5gFcst+sUpVf1XQziJ35RPNVuKBu0YRp1P73muxUWG9k
	YaK1qnHm0WbkSxiLa7/vISTloQ9tduU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kOEmXq56;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762795663; a=rsa-sha256;
	cv=none;
	b=pUHqsiLJWr/15hHSUV4cIrzLdTMe266AAG0FD0LkfYOZN6laUFRp/gq51l0gF2kU2jCX+v
	kYaPDo4cPqvErDLDLKq7BRGejqugcMauYrut9mcKBLCSUSw+tPPYE1M2bbSAaN3JRlcO/6
	eaU0OOqBozvvFSIyxccN3RBsqIkJqEQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 05EB742A19;
	Mon, 10 Nov 2025 17:27:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473ABC4CEFB;
	Mon, 10 Nov 2025 17:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762795661;
	bh=HHttyIN4ZrA3AcpdgGnhsSW/6Bj+qI781YjC1EPK/3Q=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=kOEmXq56QEOhYKVDYg3pmTTbZaQ3owW/HDKwcBuDdC82JmIqyrI0H+yxc99FUcDUL
	 fwXU81C3GkaANePQ13/nt1UtzHQ8MyPYe22/hw6izEBVPomnOaNifH0nL2YjIuoVqz
	 bFDQnk/vsnnCJkXC34jzPZvxkem36m07cBLE0RclncJ9pC8+XMc/avvKcXYiGT+kXB
	 IxJB+zIQ1WdF4EG+YSFYbws5XOV+2UNYGXQCOLRsjYTSDn6n0KjUr0PPbAlCviICtC
	 SXhBCSgF6rWyM5byi12R1vmT5TvXzSZLCbZ+DnAFyM+S/lRmxXR0TspGUHGzkxmBaW
	 qPOuJVi+O+KYQ==
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
  hughd@google.com,  skhawaja@google.com,  chrisl@kernel.org
Subject: Re: [PATCH v5 08/22] liveupdate: luo_file: implement file systems
 callbacks
In-Reply-To: <20251107210526.257742-9-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 7 Nov 2025 16:03:06 -0500")
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
	<20251107210526.257742-9-pasha.tatashin@soleen.com>
Date: Mon, 10 Nov 2025 18:27:31 +0100
Message-ID: <mafs0ms4tajcs.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 3BDFDA000D
X-Stat-Signature: in1ofuoik7scwetfozcenwiixobje45b
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762795663-661490
X-HE-Meta: U2FsdGVkX18AosXrLUSHjrW52H8i96oxeo16aK1EBZ6n7bwua1oMyz1JwoCXs2Z8R07B71nWQ9VSnHUV3TEpmdhYikzeq4Y9X9SRi6rU8DMX1Dfmek8W/CzQXlm7YxlCmzsE7TCKjXrxqLn/cHbpxN+Hw2bQyj9rM1ArSl/icwuCrLBkkkCb+8GtddepVS6lA1gfZhDWEza9W/rWIPws4dNWcyvJvS79EOwwW4ThK0DU0BdVB4al91esb0TK5dzSiuzs2bnYiDsWNjPAW4haVkNqc8DN5Zxo8BB0PgoHoUZRvpH+3A7iJYTToXRk8rwa3QMQPIFIvD5VieatXPmJ8VNblo/N/EIdz9wYkQN0h1RlO1J5cixB+BVdZpTXHOK3Z3MfLWne0TvvHNkKUaYRlI9/Ap95Ljv22Uc8zxkSKw+jBYymPotz8QE5VLT5MFAmVIkhBl204tTLtoVxJfqo6/nZoA874kJR8cwl3VCeBMDC1ovG7uAVzLIQPhcsnpJ5ubfPwT79Fq8qAVNkpXcXrvIZyYQMeYHqp1Ikj5Vyv5GtVL1KF2k2/V2Ye0TPbjAfinLaDEahU0ySUqXpCMpLcIINMOLua660pa0KClahQaVDaE7ggHuIY6fTikknGGgtHgGh0846dxfazP05lfn2orr43NYt8YdfQNt0jYlR8lLsGWfJYeVLufE7c0EwlHoaI0xCQORzgPyo1mkyxK1UERtXRR/+Ny0DsDvacUgUrdhKJokUhqR5fundIVvtQu8IyvkO/g/tQnejOOvp9HIiLW9C95Zc7BQs9RwqjSbuQe9kYpNLbWBSVJMMlOftIXsKMF/pNl3wfdN+yJ//X4OxnHGnNpLw0dwq76bV7bbaWzBigmaCko5yO1U8uaaJYBAJ2D9EGZjhQDea1XbayiWaWzZ0/KQEzFSzZoRMWi06fl2kVDgflySM/9gVwytDcLIigQ2Mr8rsPpdAZNwG/vO
 S055i6fF
 4wJ2zd/8c3Tauq/Ox8pDbKMdHOHQmu7apCGwsriqJcv/PppHrUFe6yd/hfD4bh+gFuEYXx6wncjpEVIe05BydSPU6z6Ku0tJ9GiWdabBMjtQGJ5DFP6lop9iapulIRrVE78tf5De+gwPJqNttrDCrrq4oTrzabWYlBqpK+on4ASy640GMeqwI2PJ/EkeRyXs6vGtGmEuRAPeVa91AEn4TBnWxU5aRgLfeGrJHTq8zRxc8L8mWZHLSC2N6ttZBzxDsGo2stsKmtB76SOzHmWd0Zi+oTK7n8cujOmcM2fi2bld4IgRrYAzF4gXOSwGS2spYr7U3m5TYsc/7Pi3ckn0yeE7fp/7O7HAi0mM0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pasha,

Caught a small bug during some of my testing.

On Fri, Nov 07 2025, Pasha Tatashin wrote:

> This patch implements the core mechanism for managing preserved
> files throughout the live update lifecycle. It provides the logic to
> invoke the file handler callbacks (preserve, unpreserve, freeze,
> unfreeze, retrieve, and finish) at the appropriate stages.
>
> During the reboot phase, luo_file_freeze() serializes the final
> metadata for each file (handler compatible string, token, and data
> handle) into a memory region preserved by KHO. In the new kernel,
> luo_file_deserialize() reconstructs the in-memory file list from this
> data, preparing the session for retrieval.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
[...]
> +int luo_preserve_file(struct luo_session *session, u64 token, int fd)
> +{
> +	struct liveupdate_file_op_args args = {0};
> +	struct liveupdate_file_handler *fh;
> +	struct luo_file *luo_file;
> +	struct file *file;
> +	int err = -ENOENT;
> +
> +	lockdep_assert_held(&session->mutex);
> +
> +	if (luo_token_is_used(session, token))
> +		return -EEXIST;
> +
> +	file = fget(fd);
> +	if (!file)
> +		return -EBADF;
> +
> +	err = luo_session_alloc_files_mem(session);

err gets set to 0 here...

> +	if (err)
> +		goto  exit_err;
> +
> +	if (session->count == LUO_FILE_MAX) {
> +		err = -ENOSPC;
> +		goto exit_err;
> +	}
> +
> +	list_for_each_entry(fh, &luo_file_handler_list, list) {
> +		if (fh->ops->can_preserve(fh, file)) {
> +			err = 0;
> +			break;
> +		}
> +	}

... say no file handler can preserve this file ...

> +
> +	/* err is still -ENOENT if no handler was found */
> +	if (err)

... err is not ENOENT, but 0. So this function does not error but, but
goes ahead with fh == luo_file_handler_list (since end of list). This
causes an out-of-bounds access. It eventually causes a kernel fault and
panic.

You should drop the ENOENT at initialization time and set it right
before list_for_each_entry().

> +		goto exit_err;
> +
> +	luo_file = kzalloc(sizeof(*luo_file), GFP_KERNEL);
> +	if (!luo_file) {
> +		err = -ENOMEM;
> +		goto exit_err;
> +	}
> +
> +	luo_file->file = file;
> +	luo_file->fh = fh;
> +	luo_file->token = token;
> +	luo_file->retrieved = false;
> +	mutex_init(&luo_file->mutex);
> +
> +	args.handler = fh;
> +	args.session = (struct liveupdate_session *)session;
> +	args.file = file;
> +	err = fh->ops->preserve(&args);
> +	if (err) {
> +		mutex_destroy(&luo_file->mutex);
> +		kfree(luo_file);
> +		goto exit_err;
> +	} else {
> +		luo_file->serialized_data = args.serialized_data;
> +		list_add_tail(&luo_file->list, &session->files_list);
> +		session->count++;
> +	}
> +
> +	return 0;
> +
> +exit_err:
> +	fput(file);
> +	luo_session_free_files_mem(session);
> +
> +	return err;
> +}
[...]

-- 
Regards,
Pratyush Yadav

