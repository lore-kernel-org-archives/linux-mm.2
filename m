Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ED19606A33C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HE2Tpn85
Received: by kanga.kvack.org (Postfix)
	id 82B646B05B4; Wed,  4 Nov 2026 08:17:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B4D16B05CE; Wed,  4 Nov 2026 08:17:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67BF86B05CF; Wed,  4 Nov 2026 08:17:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D5F76B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:17:12 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5AF4C80719
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:17:11 +0000 (UTC)
X-FDA: 85397487462.24.E3E63A9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id BCF5D2000C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:17:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HE2Tpn85;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793798229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3H/gLjqgtzADma/hPoTM38pVJFvPU8bwDzlEhV95qGo=;
	b=IAwRCrL7EUhBBlG2iBzSeDI8AHZJPWpmwn/NMqwkZQ6FDIh6J3oP27fzuU1I0JF2KIWbmS
	6FXdx1WgNu+wQWXJYWskhtB6IDu1auABtpk/pMxa/cyBgzGVo6qfsPHgnLW0aCa8FTh9IH
	L50ai9bobwe7NwfDrCO+nXNcOoxyDn4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793798229;
	b=Uz6HirFlSNmvfepOs5Bqojj7KOHSW8Em8+7AOBoy/XBAl8N+MAcIb9CK8zV14x0iNYcHJ2
	f1mQHqp/QsJHC9SD1p0b69SElHzmDKFzFZoASSoBq+OL6cXU83Dd4tYgl96st4irOImBpZ
	ikqBzxWe9zV6I9fylaLh6IifKNX7RSc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HE2Tpn85;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4353B60546;
	Wed,  4 Nov 2026 13:17:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A701F000C1;
	Wed,  4 Nov 2026 13:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793798229;
	bh=3H/gLjqgtzADma/hPoTM38pVJFvPU8bwDzlEhV95qGo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=HE2Tpn85fZMvn0+DJkYUDDR3jn5ssQG2Eg7aG5vFhVPpRV1s3R+3WJBlk7TTjy7x4
	 pZsV3SR6ixdLdbJYGtXX4sGRinDgIuoe7jrOgEo6H/XoULroAaHXYnmepfg1Pmoy3T
	 gsppAx8YM6H9D4OWt74plOz9XYcZrIH2wMjveDKgKoVSDmBpM+HP4cBEaL+Nx6RsLD
	 pL4J6YPdDrFzvy0I9nTJViPT9GvF5vCHLYQZn3uN9/SrHgUxOvfm8gzjQLrPmy7pgE
	 ApvfvNTHjEFSKLtdxVCBWYA1FOnJUxipVPYl4iaIKuZPc+HND7ewVf/ObCmGnSvSkh
	 PnFVazMO0ayQg==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-kselftest@vger.kernel.org,
  linux-mm@kvack.org,  Alexander Graf <graf@amazon.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Baolin Wang <baolin.wang@linux.alibaba.com>,
  Christian Brauner <brauner@kernel.org>,  David Hildenbrand
 <david@kernel.org>,  Hugh Dickins <hughd@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  "Liam R. Howlett" <liam@infradead.org>,  Lorenzo
 Stoakes <ljs@kernel.org>,  Michal Hocko <mhocko@suse.com>,  Mike Rapoport
 <rppt@kernel.org>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  Randy Dunlap <rdunlap@infradead.org>,
  Samiullah Khawaja <skhawaja@google.com>,  Shuah Khan
 <skhan@linuxfoundation.org>,  Suren Baghdasaryan <surenb@google.com>,
  Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v3 01/10] liveupdate: Pass user argument to file
 preserve and retrieve
In-Reply-To: <20261103010216.3447716-2-dmatlack@google.com> (David Matlack's
	message of "Tue, 3 Nov 2026 01:02:07 +0000")
References: <20261103010216.3447716-1-dmatlack@google.com>
	<20261103010216.3447716-2-dmatlack@google.com>
Date: Wed, 04 Nov 2026 14:17:03 +0100
Message-ID: <2vxz4idwlos0.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam06
X-Stat-Signature: g19dxrst9r3fr1ijic3ptx8ddoon34ap
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: BCF5D2000C
X-Rspam-User: 
X-HE-Tag: 1793798229-203151
X-HE-Meta: U2FsdGVkX1/F0j3EyawUriGNv/b4HjFP7ch1a9j3gZWP/x/qCSXZrq75p7ZzeUCHrGpXwsGJRna6AZLLi2OXw7fX6+b6jgFjE8H6KPgo9YzDHG5KDxZEO2hu7LCvyv9znDVZvgiO5ABCshMbOtPZH6gjskmGfiXLEhX+foP+gLsgJfnuC8Y0IBf9CnQ/cfUNS46CKgmXShnRZegRkY+VduiR2/X9hvnJGwYnM30nib4qToALKn+Vq0qUPMjod+C/vHBAzpJ2KofFMbwRjVQqLg9avuhmnAwEt+L+sNV38q28yrsKk8pxWsaQXjd0XhZZ2yOv7OEGf8IFNJ5qAMvQ8Jhc9prltphP6FTdqyDcyV2/g/ogtkrwvdavaZN/hQ+8bNd9A7kvYNrS4uSDgTeelgQxxwlBde4quvgtxnmoErc/JPn+bCriTFaq+YyL+Dv41DYIgK6QWumkLF9PRMsQGUvJSI6BfjMoB1Rx49sulBoJIRZtx5PBHg1Yyi4XdgXccSiVwgaVpddT5wHYaYdgTn0PA66YC+g+BGGgp+2bozHRRkYzWo/YZRcRhPkFAHdrF+VeMirL8lFCXipzxPefEDdBMnCjbbh/mV6JLdtAP6QCd5stlS8gXfxLUUg5GtxFVhvVSJHH7fhSaaKfwm5i35LAwoOEAFZNBqTp4YH+qZDq6i/BILEm6ei45cfVzh87NiZz0+oyPHnyLEr+3yiorBScWlTS14Cp/VMvygBdLsGCbNckGeLD0xi1H56bGHL98FQ8OMM3/0f8GpbgEL9VBKWiOclrkYp4J2zYSeUJUaSZmA1DR0dYc6sTMMOMlByu5EvGripnc2uGJtwycNx1E12hNVIJRdQArPjQ1HOZbxFgtJxAEaYhTKNuuJ3W/NeoJLSCRVg0TBSCsC04uDOuhO73lcRmkRdOBR07SLD57StcaAyq7Ij+fG6HsGdBSLqucUBLn9B46ucY5X1zIU4
 17yRzpl4
 hllqgXdreX1xoaDIGtXrQEG3wBiB4B7SrFN/rDN6mjSt6zFbdtH7A5FuJ9xG+wKIwEt2ZJSPzmOKlXTQ86xVn88IhQYtOiYlh9py2LdCQCaRKpd9tsKGXgLkXJ+lK4+th+rZY7F1J0Q6hnlBjcoEUqV/ZfmwATEdNiBNFEgKZjBJ2AbycLBAG4dvelx1CawS6AehDkIUEqL57WbQajvznfuQ86qopmrt/+0GA1H0hh3Tx7g89KXHeZxuwx5iuLozSPvDIj27IhZa5UQt4niAmw606kh72SGqk6ijhSk2yGIGdE1s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

On Tue, Nov 03 2026, David Matlack wrote:

> From: Pasha Tatashin <pasha.tatashin@soleen.com>
>
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
> The argument only applies to the retrieve that restores the file.
> Retrieving a token that was already retrieved returns the existing file,
> so fail with -EBUSY if a non-zero argument is passed then, instead of
> silently ignoring it.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

LGTM for the most part, only a couple nitpicks below.

[...]
> @@ -173,12 +178,17 @@ struct liveupdate_session_preserve_fd {
>   * attempts to retrieve the token fail with the same error code. Failed
>   * retrieves are not retried.
>   *
> + * Retrieving a token that was already retrieved successfully returns a new file
> + * descriptor for the same file. The @arg only applies to the retrieve that
> + * restores the file, so passing a non-zero @arg then fails with -EBUSY.
> + *

Hmm, let's see how that plays out in practice. I would guess that code
which does multiple retrieves isn't smart enough to know the file was
already retrieved by someone else.

Anyway, that's not really a kernel problem, so no need to change
anything. Just thinking out loud.

[...]
>  /**
>   * luo_preserve_file - Initiate the preservation of a file descriptor.
>   * @file_set: The file_set to which the preserved file will be added.
>   * @token:    A unique, user-provided identifier for the file.
>   * @fd:       The file descriptor to be preserved.
> + * @arg:      User-space pointer to the handler argument structure, or 0.
>   *
>   * This function orchestrates the first phase of preserving a file. Upon entry,
>   * it takes a reference to the 'struct file' via fget(), effectively making LUO
> @@ -222,9 +257,11 @@ static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
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

TBH, I think this whole list is pointless. There is no reason to list
what the code does in a comment. It's only purpose would be to go stale.
The comment should be a high level description of the function, and the
details are already in the code.

It would be very nice if you add a preparatory patch deleting the whole
thing, but since it isn't something added by your patch, I won't insist
on it. It's optional for this series.

>   *
>   * On success, LUO takes a reference to the 'struct file' and considers it
>   * under its management until it is unpreserved or finished.
> @@ -239,10 +276,12 @@ static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
>   *         -EBADF if the file descriptor is invalid.
>   *         -ENOSPC if the file_set is full.
>   *         -ENOENT if no compatible handler is found.
> + *         -EOPNOTSUPP if @arg is non-zero and the handler does not accept an arg.
>   *         -ENOMEM on memory allocation failure.
>   *         Other erros might be returned by .preserve().
>   */
[...]
> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
> index f48e9a4185f9..ed9d53c7db77 100644
> --- a/kernel/liveupdate/luo_session.c
> +++ b/kernel/liveupdate/luo_session.c
> @@ -267,7 +267,8 @@ static int luo_session_preserve_fd(struct luo_session *session,
>  	int err;
>  
>  	guard(mutex)(&session->mutex);
> -	err = luo_preserve_file(&session->file_set, argp->token, argp->fd);
> +	err = luo_preserve_file(&session->file_set, argp->token, argp->fd,
> +				argp->arg);

Nit: I would prefer to start marking this as __user from here on out,
instead of keeping it u64 and hiding the fact that this is a user
pointer.

So luo_preserve_file() should take a "const void __user *arg" as
argument, instead of "u64 arg". And here we should pass
u64_to_user_ptr(argp->arg). Same for retrieve.

>  	if (err)
>  		return err;
>  
> @@ -290,7 +291,8 @@ static int luo_session_retrieve_fd(struct luo_session *session,
>  		return argp->fd;
>  
>  	mutex_lock(&session->mutex);
> -	err = luo_retrieve_file(&session->file_set, argp->token, &file);
> +	err = luo_retrieve_file(&session->file_set, argp->token, argp->arg,
> +				&file);
>  	mutex_unlock(&session->mutex);
>  	if (err < 0)
>  		goto err_put_fd;

-- 
Regards,
Pratyush Yadav

