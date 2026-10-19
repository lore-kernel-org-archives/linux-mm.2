Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1AB5606A32E
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 19:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=L+neu+w0
Received: by kanga.kvack.org (Postfix)
	id D2DA26B034F; Mon, 19 Oct 2026 15:26:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDE7A6B0350; Mon, 19 Oct 2026 15:26:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCCF46B0351; Mon, 19 Oct 2026 15:26:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8CB5C6B034F
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:26:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1B9B7120827
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 19:26:15 +0000 (UTC)
X-FDA: 85340356710.13.4A23EFE
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	by imf15.hostedemail.com (Postfix) with ESMTP id 73C33A000F
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 19:26:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=L+neu+w0;
	spf=pass (imf15.hostedemail.com: domain of 3027WagkKCGgZGXaTYGNaMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--tarunsahu.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3027WagkKCGgZGXaTYGNaMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792437973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2rb0/sEAsfacPJuMtkQHcEOl+6Blya8Qkve331V8u98=;
	b=jZfnyq/3LgecHSQ9PrfqX5c7tAnfyxgkjZH7WmW+pC52XfsnBXSQETGiVwdKOUHZUMor59
	IX6p4T2kWze1KIaG+4YlK05MXCvkjLl/iPzyYEgiWZ8U/mFlhO7Q2mItIJpt89/b2kXbsN
	c8uogdPVWh4+QaKY3ajTYzdDBLlktBQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=L+neu+w0;
	spf=pass (imf15.hostedemail.com: domain of 3027WagkKCGgZGXaTYGNaMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--tarunsahu.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3027WagkKCGgZGXaTYGNaMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792437973;
	b=uwk6leciwtsZIyxO/SB7N5uQHywCtk6KwqaIqILH2N+kcdPdX2WG90L3lgkWeruddXoRqJ
	HkIans+F1ZJZdeF2BT2HnW+zRK16hjrMDyNPOXGc4U5li2D6XtfILGNHDG8U2x2vTmeQas
	qA74PRnygWdFF5QYWoO13hFiCV0gJas=
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c414c206673so245382366b.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792437972; x=1793042772; darn=kvack.org;
        h=content-type:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2rb0/sEAsfacPJuMtkQHcEOl+6Blya8Qkve331V8u98=;
        b=L+neu+w0whEplPgoR/Bv+Qzn2mzjI3tNUImK/xaCnLO+H7QoiFYhAB/Mt5EXbcNUiF
         eHQHQBCnO6IKoB2+8b+cFTNUX69uO9j96qBeRWLQUnd03a0rnN9H+zdbhpew5+wBxk4P
         Fx8NhWwIUizKeuPuXqGuLlMlkySKJo8WV0EpI6+912QLvWojYReioY+j4fh11LVUfktO
         PjdIPFKruQlHdWydEQOE/AMu0fzjwF9FNpWYeS5n+IOWFq9yR9Rm4gNEevSqCkUrjOMl
         GO2OM1/sdwC5IANdMf6g0K9tyLzt3I5H7Qa6lhdpQmsDjnREYn/cPt8Lc647nZsPWSPA
         uATg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792437972; x=1793042772;
        h=content-type:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2rb0/sEAsfacPJuMtkQHcEOl+6Blya8Qkve331V8u98=;
        b=QR6vwjm7Q5GnHC756YSkiVEiF+W/ByNH3QFo1vVEoA9RB7aNaO4MEWrq56ma8HD4OJ
         3SBj1y6ZpKb0C8WE5fHaLR3JZtaZ+2C4sh9eRIZnl+wr4QCHYmQzoaMNjuZ5mISYhiwy
         oMANL03RyK8pfKr7uHwvAiW3m9f2Zfb7dG22g6hyIdug3rm3GM1+r2CAsQGhQBqX4IQP
         T1OV5sunFyDkdPx78U95zRVC1qZVyPNyhd8/YFnsBgVz/LMfDVzUiTRKorMyUnqdpkey
         KZEDdepgygVsfXFI4xiroHYlmzryd25EihDG6dnXRm/6XLj4uEQ5Lz1NuyHU9xSw6MpJ
         f0IA==
X-Forwarded-Encrypted: i=1; AKwUvBwDkqvZ1Tp6pynCxl9N3JW8Db1kNU3jxXdgixTT7o63p0NkQ/0fyygFUW8qx4CwrDiFz3ZdkGUcTg==@kvack.org
X-Gm-Message-State: AFq9FYJU0SmFVer54Tu5zLbOPDn1bj0D/UKytRpx45kliednvpvlIWik
	+0tplNm4C68UTVw4mt1w9G+KJtwaZnc820Zn8PA963+04KQLXkiCrRsE/3Ha0sYd7D79zC9P17C
	PaOCAMn2VdRXbf7sgWw==
X-Received: from ejzr6.prod.google.com ([2002:a17:906:c286:b0:c3f:cc01:4b71])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:c308:b0:c40:773e:4f22 with SMTP id a640c23a62f3a-c419fbf1fa2mr575427066b.42.1792437971742;
 Mon, 19 Oct 2026 12:26:11 -0700 (PDT)
Date: Mon, 19 Oct 2026 19:26:11 +0000
In-Reply-To: <20261015093816.2438942-4-pasha.tatashin@soleen.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261015093816.2438942-1-pasha.tatashin@soleen.com> <20261015093816.2438942-4-pasha.tatashin@soleen.com>
Message-ID: <9huzwlrdh4q4.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v1 3/7] liveupdate: Pass user argument to file preserve
 and retrieve
From: tarunsahu@google.com
To: Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kselftest@vger.kernel.org, 
	rppt@kernel.org, shuah@kernel.org, akpm@linux-foundation.org, 
	linux-mm@kvack.org, vipinsh@google.com, linux-kernel@vger.kernel.org, 
	dmatlack@google.com, kexec@lists.infradead.org, pratyush@kernel.org, 
	graf@amazon.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 73C33A000F
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: bn7ikcchbdo9fmosn588ku3yenbrtqai
X-HE-Tag: 1792437973-715718
X-HE-Meta: U2FsdGVkX19F+By+ubOHhg9OHvNH+kyWjwkA+azmFm2P5V9vsKaX79009hA2I5cfS494Ke0RF6Jcg1YNWNFej/A6EnM8qi6NoElnwJC2nINE865yKsFEZvxFcEF28yVS8KrVnPj509ZjGHCRpQiPdhVT6u1zA8yb0FKA3e9ksB2f125HRVpwUakzIgnegkLyaIWvoFX8fRMvrBDa0cTh317qO4H+dHiwAhOKaEB38nF1cd3g6BP9Gf8djQYD3Bp8QA848h6mbDSOKFzcwm2+w0nfeVBH+cfETjUWAm7An2vOzYrKaLq+2eF8e4a/jyhoWN3Y9vc/OqdBJ/MkVOqt2mZKEMN++LN2VXbISdCJdBkvmLiy8Ty+4X2tZpafXGuOXEtRu0GmEDqnFGcf7cSTzkQpc5Dh7iijSRMGQKWUi0LjR+xkyH/S0K1oH+pYZkFAGlHXjOVu15AhdtL7AHE+eLGQJ5CxOeqJ5Sb7aSUrnFiRHXsMfgVJm48LabDGNx+pytRAKVDNTpIM+SCUVcGCMSsonTQ2VHAA1jJY64ny3rNF2nQAqgllDfVTdtuNCddtIGAFW5pD02Td5ku/P2Rt/sh+mzo8W/4/7oUWAU2tLtkmpxduEy+rCZj5RnnFaAFiekTTdWWR9An15OCyCAPFOMMPIDugPFLaVZe7cXwVx6fjRUZ9JFPM99nWfPeFJbCVbfLwNd0n5gqrXkVlE9vjimtxMN6elPQebiDlwW67g7lqt20CuCXm25BXYEu8bXyR8a0lKK3i8p3aKNPTQfmyjgv8tyQc2frdWtWkkxnmVVaIwd7NKC/FPNUVgkqQ3ALT1+Lex9FNgpqJELKC1B4OwKZXHm4gQsUV1TD8mbq3okMnCp2/5H39JUEUOnXTkWKwb7J3jXiY6dObf5C16WqS61DFycLWOrm0OnnBVoT4QmyOoVdDqjys7/l9LXkly0/3GEToGSJioV79Soj2Xkc
 O6Vjf6J0
 K3xVTJCVGQpU01DjBXY4PKWYcrjJQmBAAXyctm63gMnl/EroKNpKs+1Qo3hklF+KCiY+51tgT+SeDQi0r5/dBbPltRT8sea4LXc5rnV9/rPjMa747B7hCdI1TYdg0ojqSbtlpnVryXkKqpX2Gfq6a5xVy4SnZWcFzUegY6JocwytIjVK2xkcZGDFkPpYzzEEFx8a0Of3+TrluA37G0njec95y1dpAqaidGJJANknCU3g6q7b6rPpKw9sgknJXeHYVTU5PrOXGBYxBQ0oM1ZdZX4zjBEZdCnZxk0UojcOD7KOdIO5jYkQOm005u20CxWhrz9tZKmemVFGgYU8hvD69Ac0A58dxmCoLRhFGRkxhuDVr9CcDzczA4EIfGlkPuRan6JRTtm9WL+SA3Jar5OKEEJf/jToZOMeuyoc6TQPkZ5lEhWqZuGNONCjPvRGiqFj2T37YMxJqHQF8VvZwRphGR/810e13YZIgzVFrKnIl7tCFbS/MdvoJjQxEhMakKqaWAaWKKVMyB991+hhpcKb8GlqWu8RF/4YwLEiJjnNJIBcSersvjC5ts111s76Lx8DERxMHlgg21luaXy0CbnxL/NcGV0Ly0y9/Xoz0iMxK6q5G4y3HkRyWXlUHxKeisMI/D1qmHNLOrV+5NCg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


As Per Today's Hypervisor liveupdate meeting, This patch will be picked
by @dmatlack@google.com for latest tmpfs preservation series.

I have a suggestion to make here.

Let's send this patch as a saperate patch so that I can also use this in
my guest_memfd preservation work. This will help landing this feature
sooner and unblock other subsystem who needs it.

Let me know what you think?

~Tarun


Pasha Tatashin <pasha.tatashin@soleen.com> writes:

> Allow userspace to pass a file-handler-specific argument structure when
> preserving or retrieving an FD via LUO. File handlers may need
> additional context during preservation or retrieval, such as a target
> FD, device location, or handler-specific parameters, without introducing
> separate ioctls for each file type. Whether the argument is required,
> optional, or unused is defined by the file handler.
>
> Extend struct liveupdate_session_preserve_fd and
> struct liveupdate_session_retrieve_fd with a 64-bit arg field pointing
> to a handler-defined argument structure that begins with a 32-bit size
> field. Because IOCTL_OP validates a minimum size up to the token field,
> existing callers passing the 16-byte struct remain compatible and have
> arg zero-filled by copy_struct_from_user().
>
> Add parg and rarg (struct liveupdate_arg_spec) to
> struct liveupdate_file_ops, initialized via LIVEUPDATE_ARG(_struct,
> _min_last), which records the full struct size and minimum required size
> while enforcing at compile time that handler argument structures begin
> with a 32-bit size field. When arg is non-zero, LUO validates the
> minimum size and copies the user argument via copy_struct_from_user() up
> to the handler's expected size and passes the kernel copy in
> struct liveupdate_file_op_args, or returns -EOPNOTSUPP if the handler
> does not accept an argument.
>
> Also provide liveupdate_claim_file() and liveupdate_unclaim_file() so
> handlers whose .retrieve() callback restores state into an existing
> user-supplied file descriptor can claim it in luo_preserved_files before
> modifying the file.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  include/linux/liveupdate.h       | 60 +++++++++++++++++++
>  include/uapi/linux/liveupdate.h  |  6 ++
>  kernel/liveupdate/luo_file.c     | 99 +++++++++++++++++++++++++++++---
>  kernel/liveupdate/luo_internal.h |  5 +-
>  kernel/liveupdate/luo_session.c  |  6 +-
>  5 files changed, 164 insertions(+), 12 deletions(-)
>
> diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
> index 885ec0bbc4b8c..52d3f453ae011 100644
> --- a/include/linux/liveupdate.h
> +++ b/include/linux/liveupdate.h
> @@ -22,6 +22,36 @@ struct liveupdate_flb;
>  struct liveupdate_session;
>  struct file;
>  
> +/**
> + * struct liveupdate_arg_spec - Specification of a file handler user argument.
> + * @size:     Full size of the argument structure in the current kernel.
> + * @min_size: Minimum valid user-supplied size (offsetofend of the last
> + *            required field).
> + */
> +struct liveupdate_arg_spec {
> +	size_t size;
> +	size_t min_size;
> +};
> +
> +/**
> + * LIVEUPDATE_ARG - Validated specification of a file handler argument struct.
> + * @_struct:   The argument structure type.
> + * @_min_last: The last required member in @_struct.
> + *
> + * All file handler argument structures passed via
> + * &liveupdate_session_preserve_fd.arg or &liveupdate_session_retrieve_fd.arg
> + * must begin with a 32-bit @size field so they can be extended compatibly.
> + * Use this macro to initialize &liveupdate_file_ops.parg and
> + * &liveupdate_file_ops.rarg.
> + */
> +#define LIVEUPDATE_ARG(_struct, _min_last)				\
> +	{								\
> +		.size = sizeof(_struct) +				\
> +			BUILD_BUG_ON_ZERO(offsetof(_struct, size) != 0) + \
> +			BUILD_BUG_ON_ZERO(sizeof_field(_struct, size) != sizeof(u32)), \
> +		.min_size = offsetofend(_struct, _min_last),		\
> +	}
> +
>  /**
>   * struct liveupdate_file_op_args - Arguments for file operation callbacks.
>   * @handler:          The file handler being called.
> @@ -39,6 +69,11 @@ struct file;
>   *                    is not preserved. Set by the handler's .preserve()
>   *                    callback, and must be freed in the handler's
>   *                    .unpreserve() callback.
> + * @arg:              Kernel copy of the user-provided argument for .preserve()
> + *                    and .retrieve(), or %NULL if none was provided. Allocated
> + *                    to the handler's expected argument size with any trailing
> + *                    bytes beyond the user-supplied size zero-filled. Valid
> + *                    only for the duration of the callback.
>   *
>   * This structure bundles all parameters for the file operation callbacks.
>   * The 'data' and 'file' fields are used for both input and output.
> @@ -49,6 +84,7 @@ struct liveupdate_file_op_args {
>  	struct file *file;
>  	u64 serialized_data;
>  	void *private_data;
> +	const void *arg;
>  };
>  
>  /**
> @@ -67,6 +103,12 @@ struct liveupdate_file_op_args {
>   *                resources in the session.
>   * @finish:       Required. Final cleanup in the new kernel.
>   * @get_id:       Optional. Returns a unique identifier for the file.
> + * @parg:         Optional. Specification of the user argument structure
> + *                accepted by @preserve, initialized via LIVEUPDATE_ARG(). If
> + *                unset, non-zero user arguments are rejected with -EOPNOTSUPP.
> + * @rarg:         Optional. Specification of the user argument structure
> + *                accepted by @retrieve, initialized via LIVEUPDATE_ARG(). If
> + *                unset, non-zero user arguments are rejected with -EOPNOTSUPP.
>   * @owner:        Module reference
>   *
>   * All operations (except can_preserve) receive a pointer to a
> @@ -83,6 +125,8 @@ struct liveupdate_file_ops {
>  	bool (*can_finish)(struct liveupdate_file_op_args *args);
>  	void (*finish)(struct liveupdate_file_op_args *args);
>  	unsigned long (*get_id)(struct file *file);
> +	struct liveupdate_arg_spec parg;
> +	struct liveupdate_arg_spec rarg;
>  	struct module *owner;
>  };
>  
> @@ -237,6 +281,11 @@ int liveupdate_reboot(void);
>  int liveupdate_register_file_handler(struct liveupdate_file_handler *fh);
>  void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh);
>  
> +int liveupdate_claim_file(struct liveupdate_file_handler *fh,
> +			  struct file *file);
> +void liveupdate_unclaim_file(struct liveupdate_file_handler *fh,
> +			     struct file *file);
> +
>  int liveupdate_register_flb(struct liveupdate_file_handler *fh,
>  			    struct liveupdate_flb *flb);
>  void liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
> @@ -269,6 +318,17 @@ static inline void liveupdate_unregister_file_handler(struct liveupdate_file_han
>  {
>  }
>  
> +static inline int liveupdate_claim_file(struct liveupdate_file_handler *fh,
> +					struct file *file)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static inline void liveupdate_unclaim_file(struct liveupdate_file_handler *fh,
> +					   struct file *file)
> +{
> +}
> +
>  static inline int liveupdate_register_flb(struct liveupdate_file_handler *fh,
>  					  struct liveupdate_flb *flb)
>  {
> diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
> index 1644c502521e0..57a3c129d5a9d 100644
> --- a/include/uapi/linux/liveupdate.h
> +++ b/include/uapi/linux/liveupdate.h
> @@ -127,6 +127,8 @@ struct liveupdate_ioctl_retrieve_session {
>   * @size:  Input; sizeof(struct liveupdate_session_preserve_fd)
>   * @fd:    Input; The user-space file descriptor to be preserved.
>   * @token: Input; An opaque, unique token for preserved resource.
> + * @arg:   Input; User-space pointer to a file-handler-specific argument
> + *         structure starting with a 32-bit size field, or 0 if unused.
>   *
>   * Holds parameters for preserving a file descriptor.
>   *
> @@ -150,6 +152,7 @@ struct liveupdate_session_preserve_fd {
>  	__u32		size;
>  	__s32		fd;
>  	__aligned_u64	token;
> +	__aligned_u64	arg;
>  };
>  
>  #define LIVEUPDATE_SESSION_PRESERVE_FD					\
> @@ -161,6 +164,8 @@ struct liveupdate_session_preserve_fd {
>   * @fd:    Output; The new file descriptor representing the fully restored
>   *         kernel resource.
>   * @token: Input; An opaque, token that was used to preserve the resource.
> + * @arg:   Input; User-space pointer to a file-handler-specific argument
> + *         structure starting with a 32-bit size field, or 0 if unused.
>   *
>   * Retrieve a previously preserved file descriptor.
>   *
> @@ -180,6 +185,7 @@ struct liveupdate_session_retrieve_fd {
>  	__u32		size;
>  	__s32		fd;
>  	__aligned_u64	token;
> +	__aligned_u64	arg;
>  };
>  
>  #define LIVEUPDATE_SESSION_RETRIEVE_FD					\
> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> index 3c1c86ff14d69..e3bfdbc6baedc 100644
> --- a/kernel/liveupdate/luo_file.c
> +++ b/kernel/liveupdate/luo_file.c
> @@ -112,6 +112,7 @@
>  #include <linux/xarray.h>
>  #include <linux/slab.h>
>  #include <linux/string.h>
> +#include <linux/uaccess.h>
>  #include "luo_internal.h"
>  
>  static LIST_HEAD(luo_file_handler_list);
> @@ -176,6 +177,36 @@ static unsigned long luo_get_id(struct liveupdate_file_handler *fh,
>  	return fh->ops->get_id ? fh->ops->get_id(file) : (unsigned long)file;
>  }
>  
> +/**
> + * liveupdate_claim_file - Claim a file in the LUO preserved files table.
> + * @fh:   The file handler claiming @file.
> + * @file: The file to claim.
> + *
> + * File handlers whose .retrieve() callback restores state into an existing
> + * user-supplied &struct file (rather than allocating a new one) should call
> + * this before modifying @file to ensure @file is not already managed by LUO.
> + *
> + * Return: 0 on success, -EBUSY if @file is already managed by LUO, or a
> + *         negative errno on allocation failure.
> + */
> +int liveupdate_claim_file(struct liveupdate_file_handler *fh,
> +			  struct file *file)
> +{
> +	return xa_insert(&luo_preserved_files, luo_get_id(fh, file),
> +			 file, GFP_KERNEL);
> +}
> +
> +/**
> + * liveupdate_unclaim_file - Release a claimed file from the LUO preserved files table.
> + * @fh:   The file handler that claimed @file.
> + * @file: The file to release.
> + */
> +void liveupdate_unclaim_file(struct liveupdate_file_handler *fh,
> +			     struct file *file)
> +{
> +	xa_erase(&luo_preserved_files, luo_get_id(fh, file));
> +}
> +
>  static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
>  {
>  	struct luo_file *iter;
> @@ -188,11 +219,45 @@ static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
>  	return false;
>  }
>  
> +static int luo_copy_user_arg(u64 user_arg, const void **argp,
> +			     const struct liveupdate_arg_spec *spec)
> +{
> +	void *karg __free(kfree) = NULL;
> +	void __user *uptr;
> +	u32 user_size;
> +	int err;
> +
> +	if (!user_arg)
> +		return 0;
> +	if (!spec->size)
> +		return -EOPNOTSUPP;
> +
> +	uptr = u64_to_user_ptr(user_arg);
> +	if (get_user(user_size, (u32 __user *)uptr))
> +		return -EFAULT;
> +	if (user_size < spec->min_size)
> +		return -EINVAL;
> +	if (user_size > PAGE_SIZE)
> +		return -E2BIG;
> +
> +	karg = kmalloc(spec->size, GFP_KERNEL);
> +	if (!karg)
> +		return -ENOMEM;
> +
> +	err = copy_struct_from_user(karg, spec->size, uptr, user_size);
> +	if (err)
> +		return err;
> +
> +	*argp = no_free_ptr(karg);
> +	return 0;
> +}
> +
>  /**
>   * luo_preserve_file - Initiate the preservation of a file descriptor.
>   * @file_set: The file_set to which the preserved file will be added.
>   * @token:    A unique, user-provided identifier for the file.
>   * @fd:       The file descriptor to be preserved.
> + * @arg:      User-space pointer to the handler argument structure, or 0.
>   *
>   * This function orchestrates the first phase of preserving a file. Upon entry,
>   * it takes a reference to the 'struct file' via fget(), effectively making LUO
> @@ -208,9 +273,11 @@ static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
>   *    (allocates if needed).
>   * 3. Iterates through registered handlers, calling can_preserve() to find one
>   *    compatible with the given @fd.
> - * 4. Calls the handler's .preserve() operation, which saves the file's state
> + * 4. Copies the user argument structure (if @arg is non-zero) according to the
> + *    handler's parg specification.
> + * 5. Calls the handler's .preserve() operation, which saves the file's state
>   *    and returns an opaque private data handle.
> - * 5. Adds the new instance to the file_set's internal list.
> + * 6. Adds the new instance to the file_set's internal list.
>   *
>   * On success, LUO takes a reference to the 'struct file' and considers it
>   * under its management until it is unpreserved or finished.
> @@ -225,10 +292,12 @@ static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
>   *         -EBADF if the file descriptor is invalid.
>   *         -ENOSPC if the file_set is full.
>   *         -ENOENT if no compatible handler is found.
> + *         -EOPNOTSUPP if @arg is non-zero and the handler does not accept an arg.
>   *         -ENOMEM on memory allocation failure.
>   *         Other erros might be returned by .preserve().
>   */
> -int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
> +int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd,
> +		      u64 arg)
>  {
>  	struct liveupdate_file_op_args args = {0};
>  	struct liveupdate_file_handler *fh;
> @@ -264,10 +333,14 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
>  	if (err)
>  		goto err_fput;
>  
> +	err = luo_copy_user_arg(arg, &args.arg, &fh->ops->parg);
> +	if (err)
> +		goto err_module_put;
> +
>  	err = xa_insert(&luo_preserved_files, luo_get_id(fh, file),
>  			file, GFP_KERNEL);
>  	if (err)
> -		goto err_module_put;
> +		goto err_free_arg;
>  
>  	err = luo_flb_file_preserve(fh);
>  	if (err)
> @@ -290,6 +363,7 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
>  	if (err)
>  		goto err_kfree;
>  
> +	kfree(args.arg);
>  	luo_file->serialized_data = args.serialized_data;
>  	luo_file->private_data = args.private_data;
>  	list_add_tail(&luo_file->list, &file_set->files_list);
> @@ -303,6 +377,8 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
>  	luo_flb_file_unpreserve(fh);
>  err_erase_xa:
>  	xa_erase(&luo_preserved_files, luo_get_id(fh, file));
> +err_free_arg:
> +	kfree(args.arg);
>  err_module_put:
>  	module_put(fh->ops->owner);
>  err_fput:
> @@ -533,6 +609,7 @@ void luo_file_unfreeze(struct luo_file_set *file_set,
>   * luo_retrieve_file - Restores a preserved file from a file_set by its token.
>   * @file_set: The file_set from which to retrieve the file.
>   * @token:    The unique token identifying the file to be restored.
> + * @arg:      User-space pointer to the handler argument structure, or 0.
>   * @filep:    Output parameter; on success, this is populated with a pointer
>   *            to the newly retrieved 'struct file'.
>   *
> @@ -552,9 +629,10 @@ void luo_file_unfreeze(struct luo_file_set *file_set,
>   *          kernel.
>   * Return: 0 on success. Returns a negative errno on failure:
>   *         -ENOENT if no file with the matching token is found.
> + *         -EOPNOTSUPP if @arg is non-zero and the handler does not accept an arg.
>   *         Any error code returned by the handler's .retrieve() op.
>   */
> -int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
> +int luo_retrieve_file(struct luo_file_set *file_set, u64 token, u64 arg,
>  		      struct file **filep)
>  {
>  	struct liveupdate_file_op_args args = {0};
> @@ -591,9 +669,14 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
>  		return 0;
>  	}
>  
> +	err = luo_copy_user_arg(arg, &args.arg, &luo_file->fh->ops->rarg);
> +	if (err)
> +		return err;
> +
>  	args.handler = luo_file->fh;
>  	args.serialized_data = luo_file->serialized_data;
>  	err = luo_file->fh->ops->retrieve(&args);
> +	kfree(args.arg);
>  	if (err) {
>  		/* Keep the error code for later use. */
>  		luo_file->retrieve_status = err;
> @@ -604,9 +687,9 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
>  	/* Get reference so we can keep this file in LUO until finish */
>  	get_file(luo_file->file);
>  
> -	WARN_ON(xa_insert(&luo_preserved_files,
> -			  luo_get_id(luo_file->fh, luo_file->file),
> -			  luo_file->file, GFP_KERNEL));
> +	if (xa_load(&luo_preserved_files,
> +		    luo_get_id(luo_file->fh, luo_file->file)) != luo_file->file)
> +		WARN_ON(liveupdate_claim_file(luo_file->fh, luo_file->file));
>  
>  	*filep = luo_file->file;
>  	luo_file->retrieve_status = 1;
> diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
> index b42369c3b1f30..3bd9ef442934e 100644
> --- a/kernel/liveupdate/luo_internal.h
> +++ b/kernel/liveupdate/luo_internal.h
> @@ -87,13 +87,14 @@ int __init luo_session_setup_incoming(u64 sessions_pa);
>  int luo_session_serialize(void);
>  int luo_session_deserialize(void);
>  
> -int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd);
> +int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd,
> +		      u64 arg);
>  void luo_file_unpreserve_files(struct luo_file_set *file_set);
>  int luo_file_freeze(struct luo_file_set *file_set,
>  		    struct luo_file_set_ser *file_set_ser);
>  void luo_file_unfreeze(struct luo_file_set *file_set,
>  		       struct luo_file_set_ser *file_set_ser);
> -int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
> +int luo_retrieve_file(struct luo_file_set *file_set, u64 token, u64 arg,
>  		      struct file **filep);
>  int luo_file_finish(struct luo_file_set *file_set);
>  int luo_file_deserialize(struct luo_file_set *file_set,
> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
> index 403906937bc0f..74f8a1bf1da8c 100644
> --- a/kernel/liveupdate/luo_session.c
> +++ b/kernel/liveupdate/luo_session.c
> @@ -284,7 +284,8 @@ static int luo_session_preserve_fd(struct luo_session *session,
>  	if (session->frozen)
>  		return -EBUSY;
>  
> -	err = luo_preserve_file(&session->file_set, argp->token, argp->fd);
> +	err = luo_preserve_file(&session->file_set, argp->token, argp->fd,
> +				argp->arg);
>  	if (err)
>  		return err;
>  
> @@ -307,7 +308,8 @@ static int luo_session_retrieve_fd(struct luo_session *session,
>  		return argp->fd;
>  
>  	mutex_lock(&session->mutex);
> -	err = luo_retrieve_file(&session->file_set, argp->token, &file);
> +	err = luo_retrieve_file(&session->file_set, argp->token, argp->arg,
> +				&file);
>  	mutex_unlock(&session->mutex);
>  	if (err < 0)
>  		goto err_put_fd;
> -- 
> 2.56.0.385.gd3acb90ef8-goog

