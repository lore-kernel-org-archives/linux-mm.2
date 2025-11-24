Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2031CCFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 15:47:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A6226B002F; Mon, 24 Nov 2025 10:47:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7568F6B007B; Mon, 24 Nov 2025 10:47:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66BFF6B0088; Mon, 24 Nov 2025 10:47:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 568B26B002F
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:47:44 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 13CA21305F1
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:47:44 +0000 (UTC)
X-FDA: 84145930848.14.DDEF121
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7D4C8160007
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:47:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tD8hl6p4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763999262; a=rsa-sha256;
	cv=none;
	b=Epx3fHKklb7O+obBhcM6m6ro3HHM5lD9B4QpBh5K+G/T4dlViUOV5TbQCvI0V4JFlJkmUr
	USd2lcaXm1r5Fw9r1n6CBiXqhKcRv7iNBzn6XxKZTq+a2LiLq7jkyndop19SPba1DdY76R
	o7M7EzzuSiFZ6tznASNSOMxfw1+C5a4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tD8hl6p4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763999262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KpOfr9yOHs9gJtwYnCv0kcin/SlRaskbrAQkcKVEjCg=;
	b=tAvEqjFx8t+Q5HH5aNPa9ALs3Bzw+D6UnFRv4ojBSoDF/qeQAe69NCroEYxZwCOHOx3bwe
	1KfvGDvWCirvoH14SBKyNDJ8OCI7tbo3gIE94vRBDBK3zvmB33vRDSEu8lAz4BMakRbruB
	N8kAwJ7UbBG0oPJEyH80JfMUbQMVPC0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ABA8860166;
	Mon, 24 Nov 2025 15:47:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B471C116C6;
	Mon, 24 Nov 2025 15:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763999261;
	bh=5ty/fBZCjmHJEhbLI4jansFNLKgSe6N+QAK7tw6dIws=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=tD8hl6p4EdIqmbNvRouc9XEPitGGBST3KvBxD9jDy3whnYM/8QW8jb+Z1nUb0dBUt
	 5txNckatOwxXFdgnCm4EXk8hgAz9RdybMIan+uPcYKEf3DNBs0QOm/vWqK2wOVIxKc
	 iAcEwkSnrL5xCFc02dOxaSgBKxQcXCfBt+/iZx+ZddYEWvHeSKW0IpvM2fBg9DbQTC
	 gStB8ufMnWYeUMHKdCmRrvMJVJwntRtlqTLx+0RqidnqmWgxlELS0z8LVMJRgIThg0
	 cKmOgnls7csGca0V2+bOouvFPuSz4MqRat8hOBZYImbUCLwn1xC1SvwzzeEJfeWiSg
	 wUgLSJnMWqP9A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  jasonmiu@google.com,
  graf@amazon.com,  rppt@kernel.org,  dmatlack@google.com,
  rientjes@google.com,  corbet@lwn.net,  rdunlap@infradead.org,
  ilpo.jarvinen@linux.intel.com,  kanie@linux.alibaba.com,
  ojeda@kernel.org,  aliceryhl@google.com,  masahiroy@kernel.org,
  akpm@linux-foundation.org,  tj@kernel.org,  yoann.congal@smile.fr,
  mmaurer@google.com,  roman.gushchin@linux.dev,  chenridong@huawei.com,
  axboe@kernel.dk,  mark.rutland@arm.com,  jannh@google.com,
  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
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
Subject: Re: [PATCH v7 06/22] liveupdate: luo_file: implement file systems
 callbacks
In-Reply-To: <mafs0tsyjxwoa.fsf@kernel.org> (Pratyush Yadav's message of "Mon,
	24 Nov 2025 16:44:21 +0100")
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
	<20251122222351.1059049-7-pasha.tatashin@soleen.com>
	<mafs0tsyjxwoa.fsf@kernel.org>
Date: Mon, 24 Nov 2025 16:47:31 +0100
Message-ID: <mafs0pl97xwj0.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7D4C8160007
X-Stat-Signature: 69yeibjqrh93qusp5t9gaxmf5catgequ
X-HE-Tag: 1763999262-551737
X-HE-Meta: U2FsdGVkX19uL0OVLQZ5gncFe5R8Yz2kA+JHq+Dzya2miZ9WwXAN4T8aD9y/w889vzw9LjF+3lvKCrtEzPX7QSSW6RI+76p9y+kJujR8efdGsYc4qOMar0pPvlP/5MC/YgACd9KC24IbNV1lfQjWJFnehr/raH0BYuO0J0pGYRs7fKBavNWVovFS9eiSGdX0Af1iz/69g44oC/7xjXIV/y1aEPrrqLCw8cXczK6jXOrmIZsCO55/p9JDHybkCoIZNzy6iJCQ5vv0o7cdLlj1VcDKuuXwPXek+c7HOb/IsR51W1Ag5bQ25kf5CwABIJLILX85Pp4A/fkrV6llOzQRcVgU2N7zge1VQkVhcO7zEAL8G6jdMhhzqjRamXQNj3kqmwh4w/xRJXgNzoLCzMDkbUDpmpYB2t1CGqawwy7FfVPBKt2Z9cvJwJXWxwdmQcBEW44VUoaKIDuwtp6W7UOnJ4Pi00ahJCRyCiFdTZCxbdswnAr99rCJm8XuGllcO10dt0RY/2sdubt7PjbMyorrgHHLuuWD11ocf6qUiYBy2SBTDVcbnkXlaR7uNiVfZcyhTuJbfb3brMGJi6sYkj6Ae3RZGYwjBU8Kjd7T+zRE6qs0+J8ChBKczX1TBKZZQzp3QQrgOFlmIt41qusaGlifeuZMTxijA7+I+vK0W6DfTesidGGMfZt41ANfb3j3Sr5t7eBPuiW2UqhaW3vli0GjNgM/86WTv5anE8N9VDDe7/ESKGauWQbsV4ngxgsc7IfQaWVowA+1et6kjtxyS88Bsc+WtcRhbGY4fbonUnJ6S1mLUW85DWl/gDc93vjsfFJq20T5/uMWG+UOiUX4m1e4NGFXR8hIBfqy8TxxgUIiLX8rVG8LoYBkPDTltf3oBitYCv/Kk5xGwjE6kRAjqObD8ZQfUm23/P8aRUgQPsknlEOYllEOpP0KC7YPfEfmTp99k4tIaxlPZIEPRp5EI49
 osotNvNW
 JDRATDUQ0N+7+4ySotZeGxN3xfzv2EgoEz4mQWTsyXEzaQhTp5sWYbyBhKV3fFAytURTu2Y9s75Fg6P9oa67soFTp05yn+k6uaFtIEwqPNzSc9DiomNKRnJBnFb5af2dUYau52JefvsE+0P8bFZvX4QHr9sjlwsdZ7mMd1NTE89z5UNMd07WwJilgoaqKi3ERtynEqUdBoqHn6JeopHEGmxQ/DFcVgOj3I7Kc6sWXTEax+baZ7uBtKsfwnmECsJcT0COx37IfqDWppehfcAtooTQtDpQqHJI0u3A52VZwuTPYKQR0Kj8yIYaQ5+1ZGOc6W3Ho1Z6usizBBiMWepSWQJwosYgH/ZHmqqvav9rsK1mHx29Mp5IRWs5KEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pasha,

Sorry, I accidentally sent this without trimming the context first.

Below is the version with the relevant bits:

 On Sat, Nov 22 2025, Pasha Tatashin wrote:

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
> ---
>  include/linux/kho/abi/luo.h      |  39 +-
>  include/linux/liveupdate.h       |  98 ++++
>  kernel/liveupdate/Makefile       |   1 +
>  kernel/liveupdate/luo_file.c     | 882 +++++++++++++++++++++++++++++++
>  kernel/liveupdate/luo_internal.h |  38 ++
>  5 files changed, 1057 insertions(+), 1 deletion(-)
>  create mode 100644 kernel/liveupdate/luo_file.c
>
> diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
> index a2d2940eca6b..fc143f243871 100644
> --- a/include/linux/kho/abi/luo.h
> +++ b/include/linux/kho/abi/luo.h
> @@ -65,6 +65,11 @@
>   *     Metadata for a single session, including its name and a physical pointer
>   *     to another preserved memory block containing an array of
>   *     `struct luo_file_ser` for all files in that session.
> + *
> + *   - struct luo_file_ser:
> + *     Metadata for a single preserved file. Contains the `compatible` string to
> + *     find the correct handler in the new kernel, a user-provided `token` for
> + *     identification, and an opaque `data` handle for the handler to use.
>   */
>  
>  #ifndef _LINUX_KHO_ABI_LUO_H
> @@ -82,13 +87,43 @@
>  #define LUO_FDT_COMPATIBLE	"luo-v1"
>  #define LUO_FDT_LIVEUPDATE_NUM	"liveupdate-number"
>  
> +#define LIVEUPDATE_HNDL_COMPAT_LENGTH	48
> +
> +/**
> + * struct luo_file_ser - Represents the serialized preserves files.
> + * @compatible:  File handler compatible string.
> + * @data:        Private data
> + * @token:       User provided token for this file
> + *
> + * If this structure is modified, LUO_SESSION_COMPATIBLE must be updated.
> + */
> +struct luo_file_ser {
> +	char compatible[LIVEUPDATE_HNDL_COMPAT_LENGTH];
> +	u64 data;
> +	u64 token;
> +} __packed;
> +
> +/**
> + * struct luo_file_set_ser - Represents the serialized metadata for file set
> + * @files:   The physical address of a contiguous memory block that holds
> + *           the serialized state of files (array of luo_file_ser) in this file
> + *           set.
> + * @count:   The total number of files that were part of this session during
> + *           serialization. Used for iteration and validation during
> + *           restoration.
> + */
> +struct luo_file_set_ser {
> +	u64 files;
> +	u64 count;
> +} __packed;

 The change to using file_set looks a lot nicer than what the previous
 version was doing!

> +
>  /*
>   * LUO FDT session node
>   * LUO_FDT_SESSION_HEADER:  is a u64 physical address of struct
>   *                          luo_session_header_ser
>   */
>  #define LUO_FDT_SESSION_NODE_NAME	"luo-session"
> -#define LUO_FDT_SESSION_COMPATIBLE	"luo-session-v1"
> +#define LUO_FDT_SESSION_COMPATIBLE	"luo-session-v2"
>  #define LUO_FDT_SESSION_HEADER		"luo-session-header"
>  
>  /**
[...]
> +int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
> +{
> +	struct liveupdate_file_op_args args = {0};
> +	struct liveupdate_file_handler *fh;
> +	struct luo_file *luo_file;
> +	struct file *file;
> +	int err;
> +
> +	if (luo_token_is_used(file_set, token))
> +		return -EEXIST;
> +
> +	file = fget(fd);
> +	if (!file)
> +		return -EBADF;
> +
> +	err = luo_alloc_files_mem(file_set);
> +	if (err)
> +		goto  err_files_mem;

 Nit:                ^^ two spaces here.

> +
> +	if (file_set->count == LUO_FILE_MAX) {
> +		err = -ENOSPC;
> +		goto err_files_mem;
> +	}
> +
> +	err = -ENOENT;
> +	luo_list_for_each_private(fh, &luo_file_handler_list, list) {
> +		if (fh->ops->can_preserve(fh, file)) {
> +			err = 0;
> +			break;
> +		}
> +	}
> +
[...]
> +int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
> +{
> +	struct liveupdate_file_handler *fh_iter;
> +	int err;
> +
> +	if (!liveupdate_enabled())
> +		return -EOPNOTSUPP;
> +
> +	/* Sanity check that all required callbacks are set */
> +	if (!fh->ops->preserve || !fh->ops->unpreserve ||
> +	    !fh->ops->retrieve || !fh->ops->finish) {

 You are still missing a check for can_preserve() here. It is a mandatory
 callback and luo_preserve_file() calls it without checking for NULL.

 With these and Mike's comments addressed,

 Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

> +		return -EINVAL;
> +	}
> +
[...]

-- 
Regards,
Pratyush Yadav

