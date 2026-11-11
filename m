Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A5A1606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 21:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=C6mXfIdn
Received: by kanga.kvack.org (Postfix)
	id 92B206B00EF; Wed, 11 Nov 2026 16:08:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DBFD6B05B0; Wed, 11 Nov 2026 16:08:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CA0D6B05B1; Wed, 11 Nov 2026 16:08:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 54B5B6B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:08:44 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DF1FC1A0452
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:08:43 +0000 (UTC)
X-FDA: 85424077326.01.2305E48
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id F3BE4C0006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:08:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=C6mXfIdn;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794431322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=btDrkYTYNJ0PoGfoU0vNHJPAv57DG39AtPHvIg5EYYI=;
	b=CObFwdZCQ0uw6hNAlrgI0Voo27mWyI3FePEAEGiTA7vLiUdCLKwMITrKCL2LANmyePkHFk
	gk7sfuk40ihLEIm0odzDYFohryJQBETFzglixHiXno9nAGORxk5hDiV+6xv3KdVtK7VD1e
	IEbldj+WDr2nqtG94GGbUHlq8plzo3I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794431322;
	b=1Nnqwf5bOCI6k7pah2WJEmnlck512RViNy/7DiXXnGqZSSqu4qObnecUipxXbsuEFcZwJS
	xf/MtJHsykdmxVQcptNNLk6gLM9MFXGdHRYQkE4/Mg/c38hRT0BR/pXapdA7uES8UMbA7l
	7GPtkko6mdya8xP9OeTX4ym397snkCs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=C6mXfIdn;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-7a6e560f580so2669286137.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794431321; x=1795036121; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=btDrkYTYNJ0PoGfoU0vNHJPAv57DG39AtPHvIg5EYYI=;
        b=C6mXfIdnyK1JFeL2lCWibK6GwLNmTa+8eJT9EOXfCQFADclrG9SqdiNXn8eX5xCPZf
         hUxFKVrGEMx/DCq/9pq5FZoK513JkXlLQVmOJz/jXF3YbK862GeNEeWR1DTfDpqjXwYk
         okZ/IeK6gmWvCGTlwYZcCUPBvaKI7PmwEES/n3MyTl82IsYKmmB7Y3S0yK7tbfFFBXic
         d87LF0kw2i5tbByAG3XEv4S6bx5l/EMYFhxRyUp+fvCp+IykrIx21q+w/2r8zH7Qmt7I
         NEi9EqpBLEZzh2kkmBD3YwmTpqUlBZefMP4jBZNHJ0zAx7+2+a7TtB/Dv4JnZaKjsPU/
         N7gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794431321; x=1795036121;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=btDrkYTYNJ0PoGfoU0vNHJPAv57DG39AtPHvIg5EYYI=;
        b=bm76v5nxB+NfvoVSjzNfte/NQI+DGyo9fqe4WKfiYT6bF2li/gBiIMMkhtBbZGilyG
         vKhuWpVqZff7Ud6ZjECYYYRgjWRFv0qzksas13mDvlm2oqNpB3bSqU3cb2z6Ksdhhwie
         fU7QzDIPLDUtZWJ5jiLlBtzTFj1ICcqiPtt7ePXkKZYgJ/uJ5CXtW+fperBvBfasY9zJ
         1j3NS+GUREd6eDZ2jpd4C6p0UEh/uah74a9OhNGLcFyJHV9mj7UNzjTEzluN59Cd7lrw
         f76KHVxE2cys6wD3tHhfHt2GlW259zwm0Cyg2NOp9Qm8Lhwrkr9Se2Z9m2mRe1CxFesg
         h4wg==
X-Forwarded-Encrypted: i=1; AL+hErF+OWJhHnWdl6Kgi65jrSUEGJ/ABk7+COvhT0A+ik6sj4U0MG52jvE1H5xYV1nFIrRbm0hKixUwAA==@kvack.org
X-Gm-Message-State: APuU4Z+43ebYInJGZNzQ6XlAHsZUeuSJ5xhAfeqdWtuXuPUqcBoK7SBy
	3rU8aKJtZIayy1IhHO8+lO4gjX4492itAecRdFxfdm+JuNWFU2WWoLIMjX9VQmZYt+o=
X-Gm-Gg: AYBFou27pQIwEH6KsTAe0j1JSOrNqhHhAV1UUp7ncGDXwTr7VAn0CzCJKmBa/TQKswX
	YpRpJaK/vcNjgshPmXWWDjl5HwiGaewgNdQ3dOUmA1iRVAZfiWg8KCDn7Dc17z2O7eg+iIJMdzH
	pvTNSNGRNhdm8pH79lX9rrmYlEfr9yo7uQYGlNIA9cuAeTDvf3E0WppebP+9msi0G4QThq3SkCP
	im94vVZDfZGP7t32Kc+/uyHjzj0d7XrOo5RQSd7gHriDAZrHNFsjSVMBkzbEnTkrA91KdLoJ09Y
	Uz2uQX+eIaatD6vMzeO1sPdohDwm9qlBcW79nkmyOk1x/3ncy5n6Dl4otyercCLeNWyi0W89OnK
	CitbpEEOzhpca3qC6KkkUlvgbBN+kCJY3M3Y/QFVuDVMu9czoryMZ+LxyRlcm8sauGHvmjT3HSe
	8oDab2U3mJz/sPrXmHwPKsqgeBpy4oxsXDQqdvitIY7SbYkGXqbng8bVWsJuGJP4nejWS1aPAqy
	mpQGwkWmLA0yy8Y+LiXfslaX9Id8Y8Xn8RLVkRLM9U2HcGq6c971KCY1Jy67EkxbL0zNGqi2fir
	Nlc/1mlXWGYweiqnXPCGidLfEL7kIo+hex2GSANT5je7vdorRCr8YPhGC7bAHC375rYqU6oYthU
	zePGiqXI/U3VkqspozdMfg6pVlEnKtB9ucp/BUiZromAXHH+efw==
X-Received: by 2002:a67:e7cc:0:b0:7cc:2bb7:1335 with SMTP id ada2fe7eead31-7d50619786fmr1721867137.33.1794431320983;
        Wed, 11 Nov 2026 13:08:40 -0800 (PST)
Received: from localhost (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d302239188sm4464461137.2.2026.11.11.13.08.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 13:08:40 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 11 Nov 2026 16:08:39 -0500
Message-Id: <DMSOTBXD71F7.1EJSHUFZLZH39@soleen.com>
Cc: <linux-kselftest@vger.kernel.org>, <shuah@kernel.org>,
 <linux-mm@kvack.org>, <skhan@linuxfoundation.org>,
 <linux-doc@vger.kernel.org>, <vipinsh@google.com>,
 <linux-kernel@vger.kernel.org>, <corbet@lwn.net>, <dmatlack@google.com>,
 <kexec@lists.infradead.org>, <pratyush@kernel.org>,
 <rdunlap@infradead.org>, <graf@amazon.com>
Subject: Re: [PATCH v5 4/6] liveupdate: luo_flb: support incremental
 outgoing FLB publication
From: "Pasha Tatashin" <pasha.tatashin@soleen.com>
To: "Mike Rapoport" <rppt@kernel.org>, "Pasha Tatashin"
 <pasha.tatashin@soleen.com>
X-Mailer: aerc 0.22.0-39-g5d7784875be2
References: <20261105050053.3063001-1-pasha.tatashin@soleen.com>
 <20261105050053.3063001-5-pasha.tatashin@soleen.com>
 <179439592041.425130.7284974054491864276.b4-review@b4>
In-Reply-To: <179439592041.425130.7284974054491864276.b4-review@b4>
X-Rspamd-Server: rspam06
X-Stat-Signature: onh7uk6i7w57fh14syqiik6soz19wypo
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: F3BE4C0006
X-Rspam-User: 
X-HE-Tag: 1794431321-542991
X-HE-Meta: U2FsdGVkX1+kI5Zw36/oZr4bh8w3+SqMNw1Co4HFOchQAQZ6ENQQXX/4cuRY9M45s22A1dAlY4uvRI2NhneuGf+8UwcYABTSsdPGyNi7iN7rm7npilgr4Qyn6QhxxgIAlh5/Fh2+/QQa7zM7iPEfO9wXQQY6DpfegvJWaugJEiJv/i6DkgzKXabGfjvvlOEGgU1HVnriQU57yfQkh1zz8jvMBNCueKtiX63crengV3uFxjpT59lPQN1by8GxjkneXeHYDGX1czaKq//y7pt44muPjV/+/ko6+Mut9YJVrXpX31Nnl914VmJRi/W5tgBpFN4aMO7f39JD+n/KyBinIC1GFvHlrdgdqnDrMYmfF9GoNmMz2Dqrsqeuf+AmGEAj8dRCtF9KT6kjwFHJvbTx0VQCJeG0W4HR+evu7lJBeTbOjbaGQAg0i2CCMTvzR3mrhQ+R7yBb2yD1jzGxOr+ru40paIFoFT83mfRxs7PIwZr1VEFz231ZNzhXZgN0cTg6XjBBCYmyzbBrtpCJLkQe1Urh7mel6O82mUmfT+84k1IvA/Dnstwyk5dpvtTDSUFdStzUtxBmbupSKEsnPb8aiW80Bs7ZCjSWi2OijOCvSaDvSRNTIkXQW0IqXEPVR/in3l9l4r0VRaFB7jvu1QDuDTD8SeffdCm+iZStLC6Y57Fi9t21gFsJhoXe/msI1e5hhPY02Q9+qlBD8X0PrkMpuEHhkhYhxzS4JGLJnxQ5AIWqUlYsBMl7uNOHuBSH+8/+fUSVl3i2+aCf4QIeU90QiyeoEGw9YvB5YO8Z5Ss7bNQdZOjdPXfFbtVE3D45lAVbN/hTp5CIVd3JkX0TDXECRFonoC+NtqJxbW/hCoivaWfVUa/0JElvkdAwgPZWzyV8J3YLX1yuEAz0xYE8IZ9u+pzPuqFYJ8xzWtEu4mfvCEEMyysfKOQOcP+rGNAawsdy6BjnlXyOozyxNPQE0gl
 tlQe6dlr
 nlOW2PzJu18TAOhhFawvWOFwVaE0KnVbHnAW2ke9LStT+gRhs0ppLg/6m/HSvZdYWRH2Opu1jcqJ3lucj28418bNypEoi+k5D33QtEsvfSfeGKQE599h+ITsBwgO1khrGxFcaI9bK8oQ4xO+hj9EpXNeVdxFbku/0cLzXl3lpVuQN8FCn1riOwHVvZevIGQyOCgnTu3LVkvJB9ZZXAM6jSWIomOhhUtuQTyfrmD4VS+J4VMc6Otjuwf8FR2aqKwybjf6OnMtFjKTQtHoIpR8rVRmdm64+IXMc9MUqNpMf8A5Bzfn5b577qeqzuy1sn/GbdqCh2g/UwrGn048GZWaZuzTU7PRzEfx3Lpjf5yW2e4pDUpqO8/wxb5DscfeJTZnGCOfghxzVNQntSMLaUAPWqDkzMLu9jzhjYBRByyPf6YRadM5f+wjoU2U3dCiZjBZPeG6qwJYt2YmUhp8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed Nov 11, 2026 at 6:18 AM EST, Mike Rapoport wrote:
> Hi,
>
>> When a session is published to KHO via luo_session_publish_one() ahead
>> of reboot, any FLBs that its preserved files depend on must already be
>> present in the outgoing KHO FLB array so the KHO tree remains
>> self-consistent.
>>=20
>> Currently, outgoing FLB metadata in luo_ser->flbs_pa is populated only
>> during reboot by luo_flb_serialize(), leaving luo_ser->flbs_pa empty
>> when sessions are published earlier.
>>=20
>> Publish outgoing FLBs from luo_session_publish_one() via
>> luo_file_publish_flbs() -> luo_flb_file_publish() ->
>> luo_flb_ser_publish_one(), and drop the now-redundant
>> luo_flb_serialize() pass from liveupdate_reboot(). For each published
>
> Oh, my :(
> Why do we care about exact long call sequence here?
>
>> file, luo_flb_ser_publish_one() either appends a new luo_flb_ser entry
>> with count =3D 1 using smp_store_release() on header_ser->count or
>> increments the existing entry's count in place, keeping the serialized
>> count equal to the exact number of published files in KHO without
>> including uncommitted sessions or transient
>> liveupdate_flb_get_outgoing() references.
>
> Got tired here, the prose needs a lot of human touch.
>
>> FLB publication is one-way and never needs to unpublish: before reboot
>> it runs only when a session is committed, and a committed session never
>> unpreserves its files, keeping private->outgoing.count >=3D 1 until
>> reboot so flb->ops->unpreserve() is never called on a published FLB.
>> If more FDs using an already-published FLB are preserved later,
>> flb->ops->preserve() is not called again; file handlers update the
>> shared live object via liveupdate_flb_get_outgoing(). Consequently, FLB
>> handlers must:
>> - return a stable root KHO handle in argp->data from .preserve() whose
>>   address does not change as FDs are added later;
>> - synchronize concurrent mutations to outgoing.obj with their own lock;
>> - support per-FD rollback when uncommitted sessions close without
>>   disturbing already-committed entries.
>>=20
>> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>> ---
>>  kernel/liveupdate/luo_core.c     |  10 +--
>>  kernel/liveupdate/luo_file.c     |  16 +++++
>>  kernel/liveupdate/luo_flb.c      | 111 ++++++++++++++++++++-----------
>>  kernel/liveupdate/luo_internal.h |   3 +-
>>  kernel/liveupdate/luo_session.c  |   2 +
>>  5 files changed, 95 insertions(+), 47 deletions(-)
>>
>> diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
>> index 1b2bda22902d2..9fef5161a1f3d 100644
>> --- a/kernel/liveupdate/luo_core.c
>> +++ b/kernel/liveupdate/luo_core.c
>> @@ -219,18 +219,10 @@ late_initcall(luo_late_startup);
>>   */
>>  int liveupdate_reboot(void)
>>  {
>> -	int err;
>> -
>>  	if (!liveupdate_enabled())
>>  		return 0;
>> =20
>> -	err =3D luo_session_serialize();
>> -	if (err)
>> -		return err;
>> -
>> -	luo_flb_serialize();
>> -
>> -	return 0;
>> +	return luo_session_serialize();
>
> I suppose the wall of text above describes why you change this.

Yes, FLBs are now serialized as each session is serialized, so the separate=
 luo_flb_serialize() pass in liveupdate_reboot() goes away. I will make tha=
t clear and short in the commit message.

>
>>  }
>> =20
>>  /**
>> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
>> index 988eb313a135f..611b9967a3a91 100644
>> --- a/kernel/liveupdate/luo_file.c
>> +++ b/kernel/liveupdate/luo_file.c
>> @@ -380,6 +380,22 @@ void luo_file_unpreserve_files(struct luo_file_set =
*file_set)
>>  	kho_block_set_destroy(&file_set->block_set);
>>  }
>> =20
>> +/**
>> + * luo_file_publish_flbs - Publish FLBs for all preserved files in a fi=
le_set.
>> + * @file_set: The file_set being published to the outgoing KHO subtree.
>> + *
>> + * Iterates through all preserved files in @file_set and ensures their
>> + * associated FLB metadata is published in the outgoing KHO FLB array b=
efore
>> + * the session itself becomes visible in KHO.
>> + */
>> +void luo_file_publish_flbs(struct luo_file_set *file_set)
>> +{
>> +	struct luo_file *luo_file;
>> +
>> +	list_for_each_entry(luo_file, &file_set->files_list, list)
>> +		luo_flb_file_publish(luo_file->fh);
>> +}
>> +
>>  static int luo_file_freeze_one(struct luo_file_set *file_set,
>>  			       struct luo_file *luo_file)
>>  {
>> diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
>> index cd715a7c1d992..6cd87a9f8307d 100644
>> --- a/kernel/liveupdate/luo_flb.c
>> +++ b/kernel/liveupdate/luo_flb.c
>> @@ -34,6 +34,15 @@
>>   * This reference-counted approach ensures that shared state is saved e=
xactly
>>   * once and restored exactly once, regardless of how many files depend =
on it,
>>   * and that its lifecycle is correctly managed across the kexec transit=
ion.
>> + *
>> + * Serialization: Outgoing FLB metadata is published into the KHO FLB a=
rray
>> + * incrementally as sessions are published to KHO (when committed early=
 via
>> + * LIVEUPDATE_SESSION_FREEZE_COMMIT or during reboot). Because a commit=
ted
>> + * session never unpreserves its files, FLB publication is one-way: onc=
e
>> + * published, the FLB's .unpreserve() callback is never invoked and its=
 root
>> + * KHO handle from .preserve() remains immutable in KHO, while later se=
ssions
>> + * may still add or remove per-FD state in the shared live object under=
 the FLB
>> + * handler's own synchronization.
>>   */
>
>
>> =20
>>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>> @@ -72,6 +81,13 @@ static struct luo_flb_global luo_flb_global =3D {
>>  	.list =3D LIST_HEAD_INIT(luo_flb_global.list),
>>  };
>> =20
>> +/*
>> + * Serializes updates to luo_flb_global.outgoing.header_ser and .ser[].
>> + * Lock hierarchy:
>> + *   luo_register_rwlock -> private->outgoing.lock -> luo_flb_ser_lock
>> + */
>> +static DEFINE_MUTEX(luo_flb_ser_lock);
>> +
>>  /*
>>   * struct luo_flb_link - Links an FLB definition to a file handler's in=
ternal
>>   * list of dependencies.
>> @@ -104,6 +120,36 @@ static struct luo_flb_private *luo_flb_get_private(=
struct liveupdate_flb *flb)
>>  	return private;
>>  }
>> =20
>> +static void luo_flb_ser_publish_one(const struct liveupdate_flb *flb, u=
64 data)
>> +{
>> +	struct luo_flb_header *fh =3D &luo_flb_global.outgoing;
>> +	u64 nr;
>> +
>> +	guard(mutex)(&luo_flb_ser_lock);
>> +	if (!fh->active)
>> +		return;
>> +
>> +	nr =3D fh->header_ser->count;
>> +	for (u64 i =3D 0; i < nr; i++) {
>> +		if (!strcmp(fh->ser[i].name, flb->compatible)) {
>> +			WRITE_ONCE(fh->ser[i].count, fh->ser[i].count + 1);
>
> An LLM says:
>
>   Why the WRITE_ONCE()? All writers hold luo_flb_ser_lock, and nobody rea=
ds
>   this before kexec.

Same kho-ro prep as in patch 2, will switch to fh->ser[i].count++ in v6=20
and move the concurrent reader bits to the kho-ro or luo-ro series.

>
>> +			return;
>> +		}
>> +	}
>> +
>> +	if (WARN_ON_ONCE(nr >=3D LUO_FLB_MAX))
>> +		return;
>> +
>> +	strscpy(fh->ser[nr].name, flb->compatible, sizeof(fh->ser[nr].name));
>> +	fh->ser[nr].data =3D data;
>> +	fh->ser[nr].count =3D 1;
>> +	/*
>> +	 * Ensure the serialized FLB entry is visible before exposing the
>> +	 * incremented count to concurrent KHO readers.
>> +	 */
>> +	smp_store_release(&fh->header_ser->count, nr + 1);
>
> An LLM says:
>
>   And this release store pairs with nothing.

ditto

--=20
Pasha


