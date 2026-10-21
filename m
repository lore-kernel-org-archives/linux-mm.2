Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 216E6606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 10:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yuw/Sekv
Received: by kanga.kvack.org (Postfix)
	id 3D84F6B069E; Wed, 21 Oct 2026 06:14:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AE5D6B06A0; Wed, 21 Oct 2026 06:14:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C5DD6B06A1; Wed, 21 Oct 2026 06:14:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 049076B069E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:14:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 10356A04A4
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:14:12 +0000 (UTC)
X-FDA: 85346223144.09.9EF9033
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5F9D140002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:14:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Yuw/Sekv";
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792577650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LZVDv/ifhL0pps23IxWAzGyzN5pLImGVnvohaaA3ul8=;
	b=lcJNWOnuB9xnysXdpANKaqC0RcNCQrzMinvrknGVkPl8ggRIRxf905dn+Bp71OavW9uJ0P
	6Z2vny/inTQtoZ3gcxAfTSIAV/syLvbkXqPbgr+/kfgF+vT1I03WpAaDMGdn8AMgenajRv
	PN2dS14KJg1FF5X81VqBmEqEDuFdz6Q=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Yuw/Sekv";
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792577650;
	b=v3aXOldPGILNKvZWJUi9+ZP1GmDu99IJh/7313dtHIN8hW1z5gYQwzF3iW8g6T1KNCOAb4
	M/9AuZU9p7zWadyNuqAWRBDal6k6+Bwm7JqM/GYdaADD/StoSuiWxDk2psD8Tt1+nvZ/Ab
	944voiSzr4Kgyi6VFd2DBax29k57jZ8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 477D3402B5;
	Wed, 21 Oct 2026 10:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066A21F000C9;
	Wed, 21 Oct 2026 10:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792577649;
	bh=LZVDv/ifhL0pps23IxWAzGyzN5pLImGVnvohaaA3ul8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Yuw/SekvpA8wouPa4hXTPQKwya21oUto+gEM/H+kyCUI1ePM0O9xLhf64F1ydeCJG
	 EbLxMGYgsMgA32wr5KFIuEmy+ANcyot2YtVFDubrJRR6/+9bBxaNDGonlxbu7a26Mj
	 5wnShYj59Y0sQTUF8T25Dt4EMpvo2TK3nLPkOTcIH7YcOg8vSMMZrGz6PQTZxZ7L9H
	 vt9LIC9NtJHUdD/Np28olfMhroxRhdWvSQeWSWK4cZmB0fT+hZiPMniZF5vsC3g+kr
	 xHCUCftCuYkI58iO2N8teTFYWBHOFWOzLH6t03tpgXmZSKhoWe63wqTTe7Ejk4nZpj
	 cGz9F3R0PsP4w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org,  rppt@kernel.org,  shuah@kernel.org,
  akpm@linux-foundation.org,  linux-mm@kvack.org,  vipinsh@google.com,
  linux-kernel@vger.kernel.org,  dmatlack@google.com,
  kexec@lists.infradead.org,  pratyush@kernel.org,  graf@amazon.com
Subject: Re: [PATCH v2 1/2] liveupdate: Add LIVEUPDATE_SESSION_FREEZE ioctl
 to freeze sessions early
In-Reply-To: <20261020144710.4154339-2-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Tue, 20 Oct 2026 10:47:03 -0400")
References: <20261020144710.4154339-1-pasha.tatashin@soleen.com>
	<20261020144710.4154339-2-pasha.tatashin@soleen.com>
Date: Wed, 21 Oct 2026 12:14:05 +0200
Message-ID: <2vxz4iefgy36.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5F9D140002
X-Stat-Signature: xjabdsr1knczyasomaozmjknu6jbryuo
X-Rspam-User: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792577650-774395
X-HE-Meta: U2FsdGVkX19tHHbpY8LrBLGTDnYcg20Y6CBtm5nfbgD3o/zOHgh6FJM3ObfmPPJJ6T8zj1CLiybZzxdl0y7xHu4v8zzA2b6l0UyDrRqw2UTmBTegTZWAkjEEemQliHAlTIV7b2pGexiVj+hJDUkaWVxyzWGlI2VDNCLhFadGxQEbTOGorSnt4lc0qtZleWVpazp+DZPaj1BB/mC210FYLZQ4yGI6kZ5jAH/i5WF6LV2VRLZnEkRFZkYYwTGZfkOp7bzCYD6GJyRqn0uNXK9Uv1zl1rgOGx+3iZOkRQl/DwCSmSQizo6ZyuEpbstycmL00bn+ZyuEtynFI0t/Q8jVrfmhb50uX9GEUxldqUDH4ea/umGROmLUwqHZTPWT3CTnOrAXQx/uSdN1G9LJrt4OIdMRWiET7QdDCK/Jmm5zhoV43dFZ4yduRPVHlPO6To93mjy0AcTrhbUsJnepZlhr3Csv9DpFCVlf4ExtUWttKBimlnGSJc4ry45E90CH1hz4xns/Zu4gONT7+IDoPdDpP9t5fUtVtkqQo12r1tnM9eGNbJmaVqmnZtRi3Mzx9tqTKaa64aBgTXaE0qI7a5l8od3VwBM4oyFF2MIF1zDKKVaX2JNE1TIJIoy7Ph3Lg9bsHggfhc6A07Mm8G4SVGlWRlqgCeSmWTOvyDdqJCsPl+wqH38uW8TLHjSUDVS3NooL/5tmCrlK2LC18Ps7FX6XVbtiDGETI5dOL0UrGikYHPvwGhCwJwfILV2onHdDwuV530Y3lT6+Qu/obZtELaTqnDPFbc+GMotUNHZ65SfqNfZF3LeVBpfU/daeaS2bouIhI/r6oqlNFaRKs/HzRzi+1HULSxhlKFQQWDoNIsbzeSjwpz0pOfj4g/3kRoWCS3v+wgirSJTCfvfBwm7319YzgRAQlGnLaNuoI0cSTwdRMxG6NfjiiScQ4HU1oxyIn15GTW31FML/DTviY/G00eF
 BO79JLKh
 8K5EZCKPMqPhb8kwgzNy9jKhdtmBmW/18g1YLWlDSqJOyhb9QGt8j3inKnVHCX2iRp6/aoVZCp8EopHMI7s1rxsN89+vAxiHuNSlmLFcFuGG5zgTR4mbkkdB2cKgAOVVR5x+DXyW7KiWb2d++VMWQrCk846YraRpOpmOcZofsSlFAX0Dw0eoRO72BGOjuzhckU3XRlRc7kFF32o8zT2rHZZEZfYrmre8eRN9WAVmgKLUyCS3FFo4QSZP55CAOcjPuJB9c0MEPx+gMC30Pej1cp4TL+7dtJpvHHOYH2C9hSyaR8hu1LJY5MCHkVFdVfEI9ARx408JpkfS0kWKsOolZbgqJhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20 2026, Pasha Tatashin wrote:

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
> @@ -218,18 +219,33 @@ static int luo_session_finish_one(struct luo_session *session)
>  	return luo_file_finish(&session->file_set);
>  }
>  
> -static void luo_session_unfreeze_one(struct luo_session *session,
> -				     struct luo_session_ser *ser)
> +static void luo_session_unserialize_one(struct luo_session *session,
> +					struct luo_session_ser *ser)
>  {
>  	guard(mutex)(&session->mutex);
> -	luo_file_unfreeze(&session->file_set, &ser->file_set_ser);
> +	if (!session->frozen)
> +		luo_file_unfreeze(&session->file_set);

"Wait, this looks wrong. If session is not frozen then unfreeze it?
Should be the other way round, right?"

This was my first reaction until I realized that you only unfreeze
_automatically_ frozen sessions. User-frozen sessions stay frozen. Which
makes sense, but is not obvious at all.

Perhaps rename this to session->user_frozen and add a comment here?

With that fixed, feel free to add

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

> +	memset(ser, 0, sizeof(*ser));
>  }
>  
> -static int luo_session_freeze_one(struct luo_session *session,
> -				  struct luo_session_ser *ser)
> +static int luo_session_serialize_one(struct luo_session *session,
> +				     struct luo_session_ser *ser)
>  {
> +	int err;
> +
>  	guard(mutex)(&session->mutex);
> -	return luo_file_freeze(&session->file_set, &ser->file_set_ser);
> +	if (!session->frozen) {
> +		err = luo_file_freeze(&session->file_set);
> +		if (err)
> +			return err;
> +	}
> +
> +	strscpy(ser->name, session->name, sizeof(ser->name));
> +	ser->file_set_ser.count = session->file_set.count;
> +	ser->file_set_ser.files =
> +		kho_block_set_head_pa(&session->file_set.block_set);
> +
> +	return 0;
>  }
>  
>  static int luo_session_release(struct inode *inodep, struct file *filep)
[...]
> @@ -267,6 +286,9 @@ static int luo_session_preserve_fd(struct luo_session *session,
>  	int err;
>  
>  	guard(mutex)(&session->mutex);
> +	if (session->frozen)
> +		return -EBUSY;
> +
>  	err = luo_preserve_file(&session->file_set, argp->token, argp->fd);
>  	if (err)
>  		return err;
> @@ -340,11 +362,40 @@ static int luo_session_get_name(struct luo_session *session,
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
> +	err = luo_file_freeze(&session->file_set);
> +	if (err)
> +		return err;
> +
> +	err = luo_ucmd_respond(ucmd, sizeof(*argp));
> +	if (err) {
> +		luo_file_unfreeze(&session->file_set);
> +		return err;
> +	}
> +
> +	session->frozen = true;
> +
> +	return 0;
> +}
> +
>  union ucmd_buffer {
>  	struct liveupdate_session_finish finish;
>  	struct liveupdate_session_preserve_fd preserve;
>  	struct liveupdate_session_retrieve_fd retrieve;
>  	struct liveupdate_session_get_name get_name;
> +	struct liveupdate_session_freeze freeze;
>  };
>  
>  /* Type of sessions the ioctl applies to. */
[...]

-- 
Regards,
Pratyush Yadav

