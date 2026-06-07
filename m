Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FA60CD8C88
	for <linux-mm@archiver.kernel.org>; Sun,  7 Jun 2026 00:35:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C95A66B0088; Sat,  6 Jun 2026 20:35:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C463A6B008A; Sat,  6 Jun 2026 20:35:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B35506B008C; Sat,  6 Jun 2026 20:35:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2B626B0088
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 20:35:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 36A101405BB
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 00:35:40 +0000 (UTC)
X-FDA: 84851248440.29.1DBA3F1
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf20.hostedemail.com (Postfix) with ESMTP id 597331C000D
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 00:35:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=J1IfmnJo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 32LwkagkKCD0sZqtmrZgtfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=32LwkagkKCD0sZqtmrZgtfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780792538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nufJSt5jy4ZHePo5cxkV3VuIDe3pE4bQw98uSuP49B0=;
	b=G1XzQ8PZpvbmoz6bRjDo8OVhX0yITH7M2h6x3hSLf3j38j87SXlI0IJXpi1z6zB49pWdRi
	Tfu8SMjSo2oIwIXO7IffJgiHo364KF8pFjC4yNo/NnkLo6+CYjhmGcO+s8z36fASqkeGx0
	IHsKJqBdFdczQNzP/gY5H4LmoImfxcw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=J1IfmnJo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 32LwkagkKCD0sZqtmrZgtfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=32LwkagkKCD0sZqtmrZgtfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780792538;
	b=BvCo9ASBV7FALp35nnHfwiQjB3wABZBufOSGMHUMoOs8vEX4EFn44lnmXP6dEOUJceT0Kg
	IM8sgO1SztXSHAWpjalUIBuaeV/rQyvKxsAzu6qG+lJ2KvAqYFHIGwfufoXJngozkWDqk7
	beRS3ZUutH6bW5lV4t8ZhU1YcHbMapo=
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-bebfe499101so282949266b.0
        for <linux-mm@kvack.org>; Sat, 06 Jun 2026 17:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780792537; x=1781397337; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nufJSt5jy4ZHePo5cxkV3VuIDe3pE4bQw98uSuP49B0=;
        b=J1IfmnJoUmDHY8qZNzsT3MrLgfvR8saFeL+yr9kslO7BfX1Pr/2BcpLv6Da0huM5Sl
         u9dsgu3lGyPI0/A8CxW7hBThmTqLQRJnq/B/hl69gyHQmZ1U4Q4VuN4oKot78+3MMtHe
         eVk63u5Do43c8RBoMtgSCOmAkXjGsil5IkJHaW29QSdokZi71MA2xwWZC8zmu8RD47OF
         Rn5hKwM5KvlO7ozSoTlWMINwtLWZl0va281gbcKFvP/GfP62GuwLU6PzOebBkXKjgsy+
         kc9ikEsqvk2F2Ji1dO/Oac6bSRq7Je9iBRb4DppNAuqjlxOul0AUB2HjnOIYFbZwk1c0
         EvTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780792537; x=1781397337;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nufJSt5jy4ZHePo5cxkV3VuIDe3pE4bQw98uSuP49B0=;
        b=VmaoCS6Y/41wG+l7sR/NpYG995t2SCabNRD7xRG3CcB2sWviPB/Z0QlE2ITxCgr9sg
         r+a2+ASSmcxOz0erRMvPkhagOsOtJJkj5B/tOnVlIanyqd/9l/wevWkPA9drGnITr/LE
         Z65mdwgLncRsktaSAeDa0gvmd7Ms0BIDNzD7WaiGJcq6SbC75FZY/keDA1j8P+eyAm2u
         eslir8IYsBmqgjrmCYOoVJfz0hdzTPD+zGn2nImTCmGsX2O/NwZAgmcRKStmb/mMDS5A
         N/vGKS7iAwKBjchezpkqVwQtFkhdxChc94jF6v9t0uzRXSKiic6B2j14a1Ir24lcwrEo
         7NtA==
X-Forwarded-Encrypted: i=1; AFNElJ9+gZD2FtPp5QyIpx9cgZGx0VnVtNhUfqiBUnm49ByO8s76oBvO0X4SChwbO1wKdllNTSXfQRHAvA==@kvack.org
X-Gm-Message-State: AOJu0YzSR0nOV9FjEO1nNoHW0LTPH1NvnnBZqCQqpdN9fT60hZhBvHGz
	7Dpe/iuV8cNqSSeBEKFJt3+ADlX5chvZss55QJG/r3pw+5Hxmje9YPrNZuvh+N/m6HX5oc2q++J
	yTBuaOxTgG5lE0ibKFQ==
X-Received: from ejbuz29.prod.google.com ([2002:a17:907:119d:b0:bcb:78f9:cf78])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:75ed:b0:bec:a1b4:1bb4 with SMTP id a640c23a62f3a-bf3a7302f33mr285294566b.10.1780792536653;
 Sat, 06 Jun 2026 17:35:36 -0700 (PDT)
Date: Sun, 07 Jun 2026 00:35:35 +0000
In-Reply-To: <c054ba0fb2639932bbe354420d3f4f84cce84905.1780676742.git.tarunsahu@google.com>
Mime-Version: 1.0
References: <cover.1780676742.git.tarunsahu@google.com> <c054ba0fb2639932bbe354420d3f4f84cce84905.1780676742.git.tarunsahu@google.com>
Message-ID: <9huzik7vxk4o.fsf@tarunix.c.googlers.com>
Subject: Re: [RFC PATCH v2 01/10] liveupdate: luo_file: Add internal APIs for
 file preservation
From: tarunsahu@google.com
To: Jonathan Corbet <corbet@lwn.net>, vannapurve@google.com, fvdl@google.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Shuah Khan <skhan@linuxfoundation.org>, sagis@google.com, 
	aneesh.kumar@kernel.org, skhawaja@google.com, vipinsh@google.com, 
	ackerleytng@google.com, Pratyush Yadav <pratyush@kernel.org>, david@redhat.com, 
	dmatlack@google.com, mark.rutland@arm.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	seanjc@google.com, axelrasmussen@google.com
Cc: linux-kselftest@vger.kernel.org, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kvm@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: y3s6mtm1nygxppeybmrxi4ez5riize9g
X-Rspamd-Queue-Id: 597331C000D
X-HE-Tag: 1780792538-881415
X-HE-Meta: U2FsdGVkX1/md4p1W15NojAI8sMZx0xCoZWYnaue41k+oTEbPNAnX2SDxSScN10gfQTcV+zFwH0YOV4ZKOgpaxUinfl45bguPQpNDoMAMS+n+PY56unn4T6YSMCrKi40rBZf6ukIyg935kEPUpXXGtyTX7rWauT6HYO8zNbozWSFtAMquXhJ52TCdGFN0XPS3VlS1z0xDFWP8yQwHUNKZUSlpSDXplYixSFf2SW7vyPyVXYwOxIraaywlG1EV9p+VG5ElFdgu/t18L159rDg0Ay+v22RCxr6k2moeZEC6AsbPcV5G+Osdr1Ufg6x2eskNzQzhhd/6I/mTxYg/WoLUXqqhv2NGne70Xs5JWqnUfHGLT7dk7JUaHMFfPlA8ANniKHghKcwgIRdyyUq3qr1ggf6e1lXFXOlKRUdbZE9tlOVOf1KM2C5ZYbmRHE+5pc/bFJszJgweLzXK3jW3LG2xF2u5r4+lQpM6/kJgqLDkafcChM7w21uYf9zhaLXUPeXV1OwRCyrAstKOIuZLK385v+jyVMaezrLn316o1cTg5goTMe8RsjWMfu4ZefLFisuBCTX3ougQKkvXQZGLRfnPx1R7bjCsZnQ81Dij9UR+v5f96yA3buqHEiMoE99t0hNugCc30BxdceHm3gd89MTRJrn1m9Azry/gXgHg9/ctuCn30Qm5/q8ykNhjMzQl20HRsEZeF3irRPPEWTwSqKfOleSG7Ya6Ytmq60pa9aHyem/mQCOZX03UR891MgqpZv96/b3L1cCQtA7VB/vRoKK2SWsJQbzVFZQ9SG26uJyQYBzH3vhhWBotRKsBlAHMCB7xk8leWFve5MSq6O7kUwKXFdPBVf/fRc/ttjZpmBqnY7SP8JqQzQ48OGgNvTiyQZGOstY8h+4BNGNHO/MZv1LNaNNyUYPqe7C9oq3krVncu6+E1XKCXSA/d27fNhc91jQ9EEuRCcj+csCGO52rAS
 OWRmMZW1
 vYKjoP1ly240BBbQBFeaFlV3NgmzpnJruKFdx8n117GhBj/DTG0hqe54wNxTPKGN+QnpHmFzmVng8b0vfcs6vlnOQocoiL2S19t5jJfNSAMnn838TvvNPTZhy45qmPi6My9ieIucHL9n5FJjpHJcRLpCBMRkxl++72PvpiBOKiMet+UHRArkiSV6CamMMJFD/A3b7jAxs4M81dDQNHS5r4xdi/qH2PX1URxkx7RoJp6wDGadUAFSux7ziynUWYV/eYTkP5niGDr1cpfN0vzxCxYBfqNte4kjLbAil52KXuWLcTIHXcxPhgO5sCu6Cg/MykK+7ypavaC5uBdZI9YOaaw7Yw4ejdmU5py8ONJ2K+lR1haxsHqD1C+IH3zJhFIzHRlmbRmLLNuYD67SDcPxFBAPEnoqPQelwgTGt+EcGy6uKBx2bHk6wmGJq1rUHd8Qs4gvTiwj4hkLQxaWF3f/XMIbERaZSx7dDQhxFEa4q99MzQTpu6mqx2qBUjn5I0/KmbyoH3mZ6n05F9l/b8uQyV4VuUcGN9Z1fotw+wf5TdrhdPSIqx9TlW340HcpDB+Oq7+4tZBEWaq+GGFXbAcR1IWJzT7hBhX1Ua5zk8t3AhDNl9W7Vl0BpJdoDb5+42oskXfjmM2OMi8nBubKVnkdAIFkYEXCoX3a2zuo49igcB3o/3UOh9AaTuSXyMpxQo+IoVY+oMHx0clLxJE2bTfqzA1KU0CbzrLEFIxYxIK11PrgbNj8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi,

I am sorry for incorrect layout of this series. After copy-pasting
I forgot to change the message id in header and the cover letter is not
attached to the same thread.

Please find the V2 cover letter here:
https://lore.kernel.org/all/cover.1780667929.git.tarunsahu@google.com/

Also for latest discussion related to scope:
https://lore.kernel.org/all/9huzldcrxkch.fsf@tarunix.c.googlers.com/

Thankyou

Tarun Sahu <tarunsahu@google.com> writes:

> From: Pasha Tatashin <pasha.tatashin@soleen.com>
>
> The core liveupdate mechanism allows userspace to preserve file
> descriptors. However, kernel subsystems often manage struct file
> objects directly and need to participate in the preservation process
> programmatically without relying solely on userspace interaction.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> ---
>  include/linux/liveupdate.h       | 21 ++++++++++
>  kernel/liveupdate/luo_file.c     | 69 ++++++++++++++++++++++++++++++++
>  kernel/liveupdate/luo_internal.h | 17 ++++++++
>  3 files changed, 107 insertions(+)
>
> diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
> index 30c5a39ff9e9..de052438eaac 100644
> --- a/include/linux/liveupdate.h
> +++ b/include/linux/liveupdate.h
> @@ -24,6 +24,7 @@ struct file;
>  /**
>   * struct liveupdate_file_op_args - Arguments for file operation callbacks.
>   * @handler:          The file handler being called.
> + * @session:          The session this file belongs to.
>   * @retrieve_status:  The retrieve status for the 'can_finish / finish'
>   *                    operation. A value of 0 means the retrieve has not been
>   *                    attempted, a positive value means the retrieve was
> @@ -44,6 +45,7 @@ struct file;
>   */
>  struct liveupdate_file_op_args {
>  	struct liveupdate_file_handler *handler;
> +	struct liveupdate_session *session;
>  	int retrieve_status;
>  	struct file *file;
>  	u64 serialized_data;
> @@ -240,6 +242,13 @@ void liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
>  
>  int liveupdate_flb_get_incoming(struct liveupdate_flb *flb, void **objp);
>  int liveupdate_flb_get_outgoing(struct liveupdate_flb *flb, void **objp);
> +/* kernel can internally retrieve files */
> +int liveupdate_get_file_incoming(struct liveupdate_session *s, u64 token,
> +				 struct file **filep);
> +
> +/* Get a token for an outgoing file, or -ENOENT if file is not preserved */
> +int liveupdate_get_token_outgoing(struct liveupdate_session *s,
> +				  struct file *file, u64 *tokenp);
>  
>  #else /* CONFIG_LIVEUPDATE */
>  
> @@ -285,5 +294,17 @@ static inline int liveupdate_flb_get_outgoing(struct liveupdate_flb *flb,
>  	return -EOPNOTSUPP;
>  }
>  
> +static inline int liveupdate_get_file_incoming(struct liveupdate_session *s,
> +					       u64 token, struct file **filep)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static inline int liveupdate_get_token_outgoing(struct liveupdate_session *s,
> +						struct file *file, u64 *tokenp)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
>  #endif /* CONFIG_LIVEUPDATE */
>  #endif /* _LINUX_LIVEUPDATE_H */
> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> index a0a419085e28..0aa0b4e5339f 100644
> --- a/kernel/liveupdate/luo_file.c
> +++ b/kernel/liveupdate/luo_file.c
> @@ -323,6 +323,7 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
>  	mutex_init(&luo_file->mutex);
>  
>  	args.handler = fh;
> +	args.session = luo_session_from_file_set(file_set);
>  	args.file = file;
>  	err = fh->ops->preserve(&args);
>  	if (err)
> @@ -380,6 +381,7 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
>  					   struct luo_file, list);
>  
>  		args.handler = luo_file->fh;
> +		args.session = luo_session_from_file_set(file_set);
>  		args.file = luo_file->file;
>  		args.serialized_data = luo_file->serialized_data;
>  		args.private_data = luo_file->private_data;
> @@ -411,6 +413,7 @@ static int luo_file_freeze_one(struct luo_file_set *file_set,
>  		struct liveupdate_file_op_args args = {0};
>  
>  		args.handler = luo_file->fh;
> +		args.session = luo_session_from_file_set(file_set);
>  		args.file = luo_file->file;
>  		args.serialized_data = luo_file->serialized_data;
>  		args.private_data = luo_file->private_data;
> @@ -432,6 +435,7 @@ static void luo_file_unfreeze_one(struct luo_file_set *file_set,
>  		struct liveupdate_file_op_args args = {0};
>  
>  		args.handler = luo_file->fh;
> +		args.session = luo_session_from_file_set(file_set);
>  		args.file = luo_file->file;
>  		args.serialized_data = luo_file->serialized_data;
>  		args.private_data = luo_file->private_data;
> @@ -621,6 +625,7 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
>  	}
>  
>  	args.handler = luo_file->fh;
> +	args.session = luo_session_from_file_set(file_set);
>  	args.serialized_data = luo_file->serialized_data;
>  	err = luo_file->fh->ops->retrieve(&args);
>  	if (err) {
> @@ -654,6 +659,7 @@ static int luo_file_can_finish_one(struct luo_file_set *file_set,
>  		struct liveupdate_file_op_args args = {0};
>  
>  		args.handler = luo_file->fh;
> +		args.session = luo_session_from_file_set(file_set);
>  		args.file = luo_file->file;
>  		args.serialized_data = luo_file->serialized_data;
>  		args.retrieve_status = luo_file->retrieve_status;
> @@ -671,6 +677,7 @@ static void luo_file_finish_one(struct luo_file_set *file_set,
>  	guard(mutex)(&luo_file->mutex);
>  
>  	args.handler = luo_file->fh;
> +	args.session = luo_session_from_file_set(file_set);
>  	args.file = luo_file->file;
>  	args.serialized_data = luo_file->serialized_data;
>  	args.retrieve_status = luo_file->retrieve_status;
> @@ -924,3 +931,65 @@ void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
>  	luo_flb_unregister_all(fh);
>  	list_del(&ACCESS_PRIVATE(fh, list));
>  }
> +EXPORT_SYMBOL_GPL(liveupdate_unregister_file_handler);
> +
> +/**
> + * liveupdate_get_token_outgoing - Get the token for a preserved file.
> + * @s:      The outgoing liveupdate session.
> + * @file:   The file object to search for.
> + * @tokenp: Output parameter for the found token.
> + *
> + * Searches the list of preserved files in an outgoing session for a matching
> + * file object. If found, the corresponding user-provided token is returned.
> + *
> + * This function is intended for in-kernel callers that need to correlate a
> + * file with its liveupdate token.
> + *
> + * Context: It must be called with session mutex acquired.
> + * Return: 0 on success, -ENOENT if the file is not preserved in this session.
> + */
> +int liveupdate_get_token_outgoing(struct liveupdate_session *s,
> +				  struct file *file, u64 *tokenp)
> +{
> +	struct luo_file_set *file_set = luo_file_set_from_session_locked(s);
> +	struct luo_file *luo_file;
> +	int err = -ENOENT;
> +
> +	list_for_each_entry(luo_file, &file_set->files_list, list) {
> +		if (luo_file->file == file) {
> +			if (tokenp)
> +				*tokenp = luo_file->token;
> +			err = 0;
> +			break;
> +		}
> +	}
> +
> +	return err;
> +}
> +
> +/**
> + * liveupdate_get_file_incoming - Retrieves a preserved file for in-kernel use.
> + * @s:      The incoming liveupdate session (restored from the previous kernel).
> + * @token:  The unique token identifying the file to retrieve.
> + * @filep:  On success, this will be populated with a pointer to the retrieved
> + *          'struct file'.
> + *
> + * Provides a kernel-internal API for other subsystems to retrieve their
> + * preserved files after a live update. This function is a simple wrapper
> + * around luo_retrieve_file(), allowing callers to find a file by its token.
> + *
> + * The caller receives a new reference to the file and must call fput() when it
> + * is no longer needed. The file's lifetime is managed by LUO and any userspace
> + * file descriptors. If the caller needs to hold a reference to the file beyond
> + * the immediate scope, it must call get_file() itself.
> + *
> + * Context: It must be called with session mutex acquired of a restored session.
> + * Return: 0 on success. Returns -ENOENT if no file with the matching token is
> + *         found, or any other negative errno on failure.
> + */
> +int liveupdate_get_file_incoming(struct liveupdate_session *s, u64 token,
> +				 struct file **filep)
> +{
> +	return luo_retrieve_file(luo_file_set_from_session_locked(s),
> +				 token, filep);
> +}
> diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
> index 875844d7a41d..08b198802e7f 100644
> --- a/kernel/liveupdate/luo_internal.h
> +++ b/kernel/liveupdate/luo_internal.h
> @@ -79,6 +79,23 @@ struct luo_session {
>  
>  extern struct rw_semaphore luo_register_rwlock;
>  
> +static inline struct liveupdate_session *luo_session_from_file_set(struct luo_file_set *file_set)
> +{
> +	struct luo_session *session;
> +
> +	session = container_of(file_set, struct luo_session, file_set);
> +
> +	return (struct liveupdate_session *)session;
> +}
> +
> +static inline struct luo_file_set *luo_file_set_from_session_locked(struct liveupdate_session *s)
> +{
> +	struct luo_session *session = (struct luo_session *)s;
> +
> +	lockdep_assert_held(&session->mutex);
> +	return &session->file_set;
> +}
> +
>  int luo_session_create(const char *name, struct file **filep);
>  int luo_session_retrieve(const char *name, struct file **filep);
>  int __init luo_session_setup_outgoing(void *fdt);
> -- 
> 2.54.0.1032.g2f8565e1d1-goog

