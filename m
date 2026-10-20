Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15C9760A2600
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 11:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LWoFlziJ
Received: by kanga.kvack.org (Postfix)
	id 023A66B048D; Tue, 20 Oct 2026 07:08:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE8556B0490; Tue, 20 Oct 2026 07:08:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFE866B0491; Tue, 20 Oct 2026 07:08:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B57556B048D
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:08:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3CA6D14013C
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:08:21 +0000 (UTC)
X-FDA: 85342730802.02.9A29CE7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 90F824000B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:08:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LWoFlziJ;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792494499;
	b=G53najf7M995pKpHwFbFpoultg8irRnB4RICv63sLIWkXrNDZPNcbGkEzkGIlmRyCgmguR
	db14sAbtGpA8m0GegF2i5KldSF2PEwDBhL90KG/llMc8oMchXiGQFWHeRhrgB5LGtZbn45
	BnmcDjdaw3s+NeN/lA6p9PXML8clVNI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LWoFlziJ;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792494499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PlF7ghBaTUOdulozqC4E2cPwGAg3QGfupH1MiS+T580=;
	b=glALD6BTJd4MeLt2UzFv1MYISEg5byRRADSG5yHq5LL1T+rc1w60CwJz5JAJbmPOIXVObu
	WNkrYFLc5MpOCQmkRrgbyYlUbV+1Zo//Gp0ihreCcMx2kxJiAW7TiCmM0T8wMseE7pq+ZT
	f/xT8CfKEg7YAgRJ7AXSil53BSOKYTQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9937E4082D;
	Tue, 20 Oct 2026 11:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547E81F000CB;
	Tue, 20 Oct 2026 11:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792494498;
	bh=PlF7ghBaTUOdulozqC4E2cPwGAg3QGfupH1MiS+T580=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=LWoFlziJUISk7pi2VMy49q89tXOvLa/1vZF+kaDch//hMl5Rx1cjBvmCoEF4tW91w
	 FXfNinvQWAvC/afqzLQ3j4gvmvJb4va7CW0t01WIfQjOKxzvl7VDb6rbonvcR8Vrd0
	 KpbWN2F0nb7zY2sfYGyfiZbT5oklOmB9eY2lTKKh0UfwyB9R8GHkZhoVHiWMZcvJFB
	 YJnESXMK/u8fvej2k/lO/oW9/P54hRW31vDPeLvnkHBwrgZ1vN9lCrdggmUf6zF8io
	 UCUwEn4YAWBCXEj+D4ulM0xpZdmvppDAsQQUt9HywjvbKdIS46IoVdqXavtJQ0o18G
	 NYyNXupfdPSLw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org,  rppt@kernel.org,  shuah@kernel.org,
  akpm@linux-foundation.org,  linux-mm@kvack.org,  vipinsh@google.com,
  linux-kernel@vger.kernel.org,  dmatlack@google.com,
  kexec@lists.infradead.org,  pratyush@kernel.org,  graf@amazon.com
Subject: Re: [PATCH v1 1/7] liveupdate: Add LIVEUPDATE_SESSION_FREEZE ioctl
 to freeze sessions early
In-Reply-To: <20261015093816.2438942-2-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Thu, 15 Oct 2026 05:38:10 -0400")
References: <20261015093816.2438942-1-pasha.tatashin@soleen.com>
	<20261015093816.2438942-2-pasha.tatashin@soleen.com>
Date: Tue, 20 Oct 2026 13:08:14 +0200
Message-ID: <2vxz8q3shboh.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 90F824000B
X-Stat-Signature: ab4es6hc4qady1mnkx5za4hto8p1prmr
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792494499-786611
X-HE-Meta: U2FsdGVkX19sjN9wSs/0llBiXomf+GA3xT5QxcvRJt5da7Be/rodMwTKvNoc/LWO3jdiYEeXHx6nAyLOwuj8tdFp940I2mg5XRAh3uDXzeckXO55GdD5DlC/kUi0Njpt225YWSJyTOiTc7xJgPNHX4ieCCX5Q5ddRO4rb3z8mRBTdRljkXvcJqiHO6UW2vR1Zunp5vwjE7W8DN1ssOES6Xj+XcA2zk1SvV5nJL8xAilonKwVE11rc5fTsOIzLCRJBSrXJfaWhKqDtgRf7knlVatt2Ui1+LOkzE1gtd0GbXukwUKusJXJKWDca+WhsSIWl8itC86KOKH5PUd2W/4GNb382aKP9SxZgGixscIXMJo60WrDRcQrhBrr0BwxjUePuYsBXdt17CY4AdzxMDzXrIiJjBahgcmhQ4KNEd5RuNrJmPH+iH6xcFt8jt6LKYIKo1AwjnW/FD56tYty+1jv/DaVHuioOF/z2UPi7FVgZM+9zjEf4xAwqV3zSCBonkJjf0oI0HqV3qMVWY8xe43pBLfPD5Nn35tsvSwNau9IaaJW5YrppGGlbuiyvV9bI5OEx7gBTjuzv9i53eBiHFGgpQU2crA1PnnVLjCwrstorM83x49aDD/PN3QK1GO9kg8Mo0RU0F3Z8UUQx/9f+eX9dgJmyy8EdE4n3K3zPp5btYigk3aZ0KMFN7/44azqn3B/s0qZKF/pGeD7Ukef1IYE0BkMEBMGvalwPIWJVrDVoSyJho7d73jpapAMONr+jSRjMRNUE02s4CbRAGHwPWeAFelpU2WmAqvVDK5WfHHSdem7PUDyMVcCE+dA7/BNrrEG3VLO1Tifhu8S1OAYnlViRbwztje1sE6yMX3BnIYfPb3AhFgTdL0pBLjd66phlm7hCR6mW1kX75+02Occh9y2t43c2lEZ11qkRStRKSg5XujVAPHK3UMWm1+wOGYq0o8EjTYJXZTrdKCn0BsN1qM
 AoNWVFOv
 T136CHqPvIMFr8I9Dyf6Z94whq9YzgN6CyPfkUPwGW0O+ijRtPvXZLsGR53XFlOrXwKcEaS+bIsRuJLMifG0oiUZMvtPzHRFofrrveHUBs5nV7+iCeuRF/0LUO1Xn52aNjevW9zUxmHXiPoODjCa5oXF7KmfaaVFEb2E5t8g721QaIeMYTu9YFtwMPyndI3XCOoFh0N4vdsVUuIiVW47JlSyvGpIqF0rEHsfuX3zbUF0qyn7f+p7HUMoJIIZ5lyV4BR8izNOGcahVrQ8zOTLI44FdWeg9B1diofkHMU2RSBrlTs4fJHVz0I+NGoVyUNsniqSH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

On Thu, Oct 15 2026, Pasha Tatashin wrote:

> Currently, LUO sessions are frozen automatically only inside the
> reboot(LINUX_REBOOT_CMD_KEXEC) pathway, where luo_session_serialize()
> iterates through all outgoing sessions under global write locks and
> freezes them serially during shutdown. Allowing userspace to decide when
> to freeze a session once it is done with it (and to freeze multiple
> sessions in parallel, since luo_session_freeze() only acquires the
> per-session mutex) avoids postponing this work to kexec shutdown and
> reduces blackout time.
>
> Introduce LIVEUPDATE_SESSION_FREEZE on session file descriptors to freeze
> a session early. The ioctl runs .freeze() across all preserved files in the
> session and serializes their metadata. Once frozen, no additional files can
> be added to the session, and subsequent freeze calls return -EBUSY. Freeze
> is only valid on outgoing sessions and returns -EINVAL on incoming ones.
>
> During kexec, sessions that were already frozen early are skipped, while
> sessions that did not invoke this ioctl auto-freeze as before. If an
> early-frozen session is released before kexec, its files are rolled back
> via .unfreeze() before being unpreserved.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
[...]
> @@ -487,8 +488,10 @@ int luo_file_freeze(struct luo_file_set *file_set,
>  		file_ser->token = luo_file->token;
>  	}
>  
> -	file_set_ser->count = file_set->count;
> -	file_set_ser->files = kho_block_set_head_pa(&file_set->block_set);
> +	if (file_set_ser) {
> +		file_set_ser->count = file_set->count;
> +		file_set_ser->files = kho_block_set_head_pa(&file_set->block_set);
> +	}
>  
>  	return 0;
>  
> @@ -501,7 +504,7 @@ int luo_file_freeze(struct luo_file_set *file_set,
>  /**
>   * luo_file_unfreeze - Unfreezes all files in a file_set and clear serialization
>   * @file_set:     The file_set whose files are to be unfrozen.
> - * @file_set_ser: Serialized file_set.
> + * @file_set_ser: Serialized file_set, or %NULL if not serialized yet.
>   *
>   * This function rolls back the state of all files in a file_set after the
>   * freeze phase has begun but must be aborted. It is the counterpart to
> @@ -512,7 +515,8 @@ int luo_file_freeze(struct luo_file_set *file_set,
>   * their respective .unfreeze() handler callbacks.
>   *
>   * Context: This is called when the live update is aborted during
> - *          the reboot() syscall, after luo_file_freeze() has been called.
> + *          the reboot() syscall, after luo_file_freeze() has been called,
> + *          or when an early-frozen session is released before kexec.
>   */
>  void luo_file_unfreeze(struct luo_file_set *file_set,
>  		       struct luo_file_set_ser *file_set_ser)
> @@ -521,7 +525,8 @@ void luo_file_unfreeze(struct luo_file_set *file_set,
>  		return;
>  
>  	__luo_file_unfreeze(file_set, NULL);
> -	memset(file_set_ser, 0, sizeof(*file_set_ser));
> +	if (file_set_ser)
> +		memset(file_set_ser, 0, sizeof(*file_set_ser));
>  }
>  
>  /**
> diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
> index 64879ffe73781..b42369c3b1f30 100644
> --- a/kernel/liveupdate/luo_internal.h
> +++ b/kernel/liveupdate/luo_internal.h
> @@ -64,6 +64,8 @@ struct luo_file_set {
>   *              previous kernel) sessions.
>   * @retrieved:  A boolean flag indicating whether this session has been
>   *              retrieved by a consumer in the new kernel.
> + * @frozen:     A boolean flag indicating whether this session has been
> + *              frozen early from userspace.
>   * @file_set:   A set of files that belong to this session.
>   * @mutex:      protects fields in the luo_session.
>   */
> @@ -71,6 +73,7 @@ struct luo_session {
>  	char name[LIVEUPDATE_SESSION_NAME_LENGTH];
>  	struct list_head list;
>  	bool retrieved;
> +	bool frozen;
>  	struct luo_file_set file_set;
>  	struct mutex mutex;
>  };
> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
> index f48e9a4185f97..403906937bc0f 100644
> --- a/kernel/liveupdate/luo_session.c
> +++ b/kernel/liveupdate/luo_session.c
> @@ -34,10 +34,11 @@
>   * 1.  Creation: A userspace agent calls `luo_session_create()` to create a
>   *     new, empty session and receives a file descriptor for it.
>   *
> - * 2.  Serialization: When the `reboot(LINUX_REBOOT_CMD_KEXEC)` syscall is
> - *     made, `luo_session_serialize()` is called. It iterates through all
> - *     active sessions and writes their metadata into a memory area preserved
> - *     by KHO.
> + * 2.  Freeze / Serialization: Sessions may be frozen early from userspace
> + *     via `LIVEUPDATE_SESSION_FREEZE`. When the `reboot(LINUX_REBOOT_CMD_KEXEC)`
> + *     syscall is made, `luo_session_serialize()` is called to freeze any
> + *     remaining active sessions and write all session metadata into a memory
> + *     area preserved by KHO.
>   *
>   * 3.  Deserialization (in new kernel): After kexec, `luo_session_deserialize()`
>   *     runs, reading the serialized data and creating a list of `struct
> @@ -222,6 +223,10 @@ static void luo_session_unfreeze_one(struct luo_session *session,
>  				     struct luo_session_ser *ser)
>  {
>  	guard(mutex)(&session->mutex);
> +	if (session->frozen) {
> +		memset(&ser->file_set_ser, 0, sizeof(ser->file_set_ser));
> +		return;
> +	}
>  	luo_file_unfreeze(&session->file_set, &ser->file_set_ser);
>  }
>  
> @@ -229,6 +234,12 @@ static int luo_session_freeze_one(struct luo_session *session,
>  				  struct luo_session_ser *ser)
>  {
>  	guard(mutex)(&session->mutex);
> +	if (session->frozen) {
> +		ser->file_set_ser.count = session->file_set.count;
> +		ser->file_set_ser.files =
> +			kho_block_set_head_pa(&session->file_set.block_set);
> +		return 0;
> +	}

This is getting messy. If early freeze, then you set the file_set_ser
here, if late freeze, you set it in luo_file_freeze().

I think it is better to just set it here, and drop the code from
luo_file_freeze() entirely.

Same for unfreeze.

Maybe also rename the function to make it clear it only runs for
serialization? The core of serialization is done by luo_file_freeze().

>  	return luo_file_freeze(&session->file_set, &ser->file_set_ser);
>  }
>  
> @@ -249,8 +260,11 @@ static int luo_session_release(struct inode *inodep, struct file *filep)
>  		}
>  		sh = &luo_session_global.incoming;
>  	} else {
> -		scoped_guard(mutex, &session->mutex)
> +		scoped_guard(mutex, &session->mutex) {
> +			if (session->frozen)
> +				luo_file_unfreeze(&session->file_set, NULL);
>  			luo_file_unpreserve_files(&session->file_set);
> +		}
>  		sh = &luo_session_global.outgoing;
>  	}
>  
> @@ -267,6 +281,9 @@ static int luo_session_preserve_fd(struct luo_session *session,
>  	int err;
>  
>  	guard(mutex)(&session->mutex);
> +	if (session->frozen)
> +		return -EBUSY;
> +
>  	err = luo_preserve_file(&session->file_set, argp->token, argp->fd);
>  	if (err)
>  		return err;
> @@ -340,11 +357,34 @@ static int luo_session_get_name(struct luo_session *session,
>  	return luo_ucmd_respond(ucmd, sizeof(*argp));
>  }
>  
> +static int luo_session_freeze(struct luo_session *session,
> +			      struct luo_ucmd *ucmd)
> +{
> +	struct liveupdate_session_freeze *argp = ucmd->cmd;
> +	int err;
> +
> +	if (argp->reserved)
> +		return -EINVAL;
> +
> +	guard(mutex)(&session->mutex);
> +	if (session->frozen)
> +		return -EBUSY;
> +
> +	err = luo_file_freeze(&session->file_set, NULL);
> +	if (err)
> +		return err;
> +
> +	session->frozen = true;
> +
> +	return luo_ucmd_respond(ucmd, sizeof(*argp));
> +}
> +
[...]

-- 
Regards,
Pratyush Yadav

