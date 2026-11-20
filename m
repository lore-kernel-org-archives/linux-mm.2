Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FA59606A32A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 14:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Pwv827zp
Received: by kanga.kvack.org (Postfix)
	id ADD336B05B1; Fri, 20 Nov 2026 09:10:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB4D66B05B2; Fri, 20 Nov 2026 09:10:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A4BD6B05B3; Fri, 20 Nov 2026 09:10:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 730A16B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:10:46 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EF4F780EBF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:10:45 +0000 (UTC)
X-FDA: 85455683250.29.5761E34
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id 04DA7140002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:10:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=Pwv827zp;
	spf=pass (imf26.hostedemail.com: domain of alex@amutable.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795183844;
	b=Uc9SRzxOPSm43w79ZEVog3y544+gr7/2kE5FLoPJFPlsbXeArn0saMHbb8IqhiOzfqYD8a
	4EcR3ojVCrN+3P/wMzm2G2yCbGDDYCY68RHr939AcbaRC8AbeVdmM8fkxkWc6/uO1egWIl
	9vbxl+8tjvXzGWyXrGsDpe+icwduKhI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795183844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A93guMQx13afloHMQAdIu6HoaXjBTOUttW4FwRn2JXg=;
	b=RC1VBtod/cXwrxQb6IJz71pnVNiKhCBjzv2zuf16ZP11qFuAgaBEBlLO8mqKcU82yt/VCK
	xH4lB9NvID67hgcdVP8B+ZFEXjt0QcnCnO39HdV8ME9suq5j3lU1gz0AsrO8ulEYpV57q1
	FDGk8UOwJs1S1mP3AzEhHmoCc4RxQEY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=Pwv827zp;
	spf=pass (imf26.hostedemail.com: domain of alex@amutable.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-491846221ffso729173f8f.3
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:10:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1795183842; x=1795788642; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=A93guMQx13afloHMQAdIu6HoaXjBTOUttW4FwRn2JXg=;
        b=Pwv827zpmERpHGrfi21yADXlKUw5ocSygzzcEQn7i82kA3oj4Pl5/24vrTHF/qJbMV
         WIstVjMLmyQvMPQSKDvmGFNOflyzuB4B9Z3wPU5psEACrQn2Mca1OUeUjvhqawJ3ekaI
         vzHpMHdYN4bNJ+Dp1LCxFdF97Ra6RZnDtqA1NbSOB50JVaQkvh6fcb6kdM/HcDJqqUl3
         K3h4JQ/B+/qEhAoLvKSmXxhCyxX5FsgR5UQyVcWJ+NBTkHvEnTcNfDpPgDjMVdXpy/Ls
         s7PHnXN1U4U9xgcevbnKcM9/Njj6j4FHU2o6PKi3ATXHgnuxbZCqOLHO55JHWHg3n/2Z
         HkRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795183842; x=1795788642;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A93guMQx13afloHMQAdIu6HoaXjBTOUttW4FwRn2JXg=;
        b=vevbDjkJV5XR2WhYPMxENuOkRWgy0j+sviiC1H8GdKyr+UUnolyyY8D9AGz9+lTHuu
         rCM41UKjFJs3q2Ou8RS5u8Qf5tPo4xB4JaZpzyqBw+pOcXcyFWRntI8HWowVGDXPf5El
         GwDpCiLKla0UTaCCQBFU12xauo2EnWPZzUJ+nSQTf3r6u9MJtyi3r9SqEufQY8SbRP7h
         u/CUiiYDOwFPAqADT/ruuq7diPrjq+idN3TGUdznm/MKDsDOkPn86mr7thWHKd2y7RcM
         IhVCY06zppw9tx2aHViCkZk8Ws6wi6GsXWwsGPXNJBmrrzAROZE5x/xLvFxofn20lkaG
         voJQ==
X-Forwarded-Encrypted: i=1; AL+hErEkebhBVv/rbMEcTZuebICiY3gNwp+XcIg7mpbAJ+MnVnFeRqhhKFtVkMHldYfhr6/ZOxFpCen8uw==@kvack.org
X-Gm-Message-State: APuU4Z/qZWUXnDVfNTzzm5vdb1BtC7cUqddlO4ZVoE/Kzf4DyDIslsGb
	y8z/A1pF2FE4ChpudmWUMDzic/yjhu1V0NwtvmabbrtljhuP2SucV8DPy0LtYYUrKKu4
X-Gm-Gg: AZFdTZdJ5dkI1LcQS6M9Np7dpdwHz/3zJnbdG1OAr+DulusvNG5u7x6z4PHmSLOy6em
	MmAAQqvgffc/GiPvbe9AT8RdxzEiCBfHvewW59+ATRC6tfYoJpZzoAANKPDLpno99p2D7Mzui1M
	aufwmQlSAftmpxBD7speYowv1KhKEG03/fk3QmjEpxk2kbQaDXzYQwHAUt/3QEnfyLoHLoJjI+U
	NVBpxNHrMvVUpXAPADms8xjUnFkm320baIyouVPLyfw8cr8uqWD9wt5SZBFnITrvvbwIjEA16mv
	GJPUSw5V21ZevP1eS+6IiHHHwy9Nldbm7+2pibef74830T5onBYI2Py/LPCrdwz9mY/Tt1mmpWC
	6cjvgNSFiy+Ry6K80o6YU9HnWozC/HV1r8qjg3OyTFfEpIb/NqrDO1rkyY4ms5TEf3GB0GyLivi
	4T00EUo1xqNbMgtzHdXOBH6IYXqJQsav1GUB8FQBvPIdjS2gt2TwAcLRa80LTnoDXnXrN4e23cV
	FPpRlXzPckPzZUSd4QrjO/qCkYbpZ8HgpUY0/0uEJB2+2rG6hetaFuXB1+ceDKqgKm19lyTPxiJ
	nX0uyQhlfk+JOfx/BhJ+0ax8p8Tx2tt5miTIvytm8x8EqZszzvCZQMVo+xNpmuwZsw==
X-Received: by 2002:a5d:63c5:0:b0:48b:4a2:8175 with SMTP id ffacd0b85a97d-4abb4e64383mr4811907f8f.43.1795183841815;
        Fri, 20 Nov 2026 06:10:41 -0800 (PST)
Received: from [10.0.0.233] (tmo-084-188.customers.d1-online.com. [80.187.84.188])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ad644140b5sm1875255f8f.17.2026.11.20.06.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 06:10:41 -0800 (PST)
Message-ID: <c80029503d191c086fca17d42e78d99604cc1311.camel@amutable.com>
Subject: Re: [PATCH 1/3] pid: move pid_in_current_pidns() into kernel/pid.c
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
 Jann Horn <jannh@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>,  Jan Kara <jack@suse.cz>, Jiwoo Kim
 <arpe1618@gmail.com>, Chen Linxuan <me@black-desk.cn>, 	linux-mm@kvack.org
Date: Fri, 20 Nov 2026 15:10:39 +0100
In-Reply-To: <20261120-work-pidfd-pidns_visible-v1-1-0e82d08469ae@kernel.org>
References: <20261120-work-pidfd-pidns_visible-v1-0-0e82d08469ae@kernel.org>
	 <20261120-work-pidfd-pidns_visible-v1-1-0e82d08469ae@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 04DA7140002
X-Rspam-User:
X-Stat-Signature: exg6skefpfqfor83m7y541gbajsdad5h
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795183843-128411
X-HE-Meta: U2FsdGVkX1/5glX+jJzp3zS97y4LNkFbA4IxVf/7ZX+eXPjnXcUB1p/So/1g+MecIyaL/36IDKeRxzfLYOIh8o1XNd8RxYIGwLaPcS8g7hCyQWzGPyVUbyZC4dQCJKWHXqdfoaXORKLoT/+ro1RQAehq0dly5oiBT6eeNp1G3907TFMJqVn8i7y0ol6xW41vws4ZQeZbqz+l3KiwGuZ3ijmDOQuZQFig6ooHUnH/tQnlQ3jMWmLUGG1alNngK98eS7ZgGl5eQswu0NTFUw5a7bDXqCMO/543GyEKgnQmS0JhpSdLy64qXlBlD9uGyVeonncXVl7PcVySXhaOeKu8Safpj2clEXo9jdLv4PTYeIt57lvivRek5Ok8qa3b4pZ0K4hML6uGloODgkPUL0IDtj8VIdAPan8qdubLr3xdHdllIki2CZGQZVScavgUjDTtwY0lhN3cGqWzbSpObaBecaDd+HFC5AgWFFayWBeM9NwtM2EP12tImkyoNcpmWpVkna5fNkADSEUdOr3ue34/UIBxWh2qKV2SzYUTQ+bujVYuQ7n52aMcg2kCpD5URMnVoCfa/8pMFAcAFlnlbrIEpSiS80n3hKAjWGztCpE7QhmVjIsTppn9MpFFL6srJJwKzSKwHsNXEgZVWml/D+zjz9rez6XQ2v200aim/4flacLNOGcVaWlFI2fe+DxpTflgga0DTY2TL9q7chSFgyRzOn5qJXhvQkpV+v7R41f3xwHybK+HRYmtgF+9+mtyLOzrrw2aRqieSCl3v1OZqfvpQh0KgX7BBGKCAQGXLHJlTKqppqnpVVWnGxrsuZD6IoQm0rj8/1Cmiol4K8SpWNneGHiI8LWJ6Piy3MrjorFwpgEca1hzlFOhcnQTDMAXL6xLbNYRNYZLC3oBEEYtn27Ndmajhp0K9ma22R9KXpThpRTfLnM8b/FKQecBAHuKNCrF5DmPXSGoQ1hO1KE62fm
 owbGrsCN
 Ue4JhmpcXv0F5zrmDB/AkAXTgG787Bm1W+HMAkr5/IPB9ZcpwCXEJV7UFfE+ZhoNMqy0yTmMnX5dCSM1l1RPd5RxcIsiLOTxDM28VUzAaPK5x6DTGa5gSNVAzs1Xq5sTUex/JmEmwVffoBO+b0S5HBhQce0ps5Q6CZiTMQNFDM2yO4Wchgmdrqty8VzU73IhRJ7zH17tFoPkGe7TTiXNuhJMBpkvsWQXNIVpCc5ew9RHm0vBVCNafe35dM2wvykv7OMkK+Fo3iAAnkqnp3FCAvdoGqZXciAeB6K1agK3zFaVloP8AtmL6DTFdsaDZcEHnv1LnfO2xyMGg5qrjKujeEBrrrrMTnxc6mq6oMOrPMSg2c5gi7yIB0efXhThdZt7GtzCqwGzC7GjBtvaUy7dy+HCefmYXSOWmVeDeHj1ORxf/L+1G4KErYItmNCec+vYN2MMLJ317CtBqG+rNOvaBHX51VlX/t/XFwx25mQsLbdLXo3ghf+w/nfYuF3ZUYaCczBshXxZ2hckzH9EvqV2Nsl4j0lKmc/5p145azoHWlKfWO3GaVhWvGLXkLXbI9GksTzXsGPp8xjsvSxpT7z9ZHDodN5nmr/4PlI5PUMsea8/xYq1vYaNVDoht5fMWoj+06K/miAlHXq86hRQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 2026-11-20 at 14:42 +0100, Christian Brauner wrote:
> The pidfd api checks in various places whether the target is visible
> in
> the caller's active pid namespace. pidfs has pid_in_current_pidns()
> for
> PIDFD_GET_INFO and the ioctls that hand out namespaces and task
> paths,
> the pidfs file handle lookup uses pid_vnr() directly, pidfd_getfd()
> uses pid_vnr() as well, and pidfd_send_signal() walks the pid
> namespace
> hierarchy in access_pidfd_pidns(). That's all the same check.
>=20
> Move pid_in_current_pidns() into kernel/pid.c so it can be used
> outside
> of pidfs and convert the pidfs file handle lookup to it while at it.
>=20
> pid_vnr() returns pid->numbers[ns->level].nr if ns->level <=3D pid-
> >level
> and pid->numbers[ns->level].ns =3D=3D ns, and 0 otherwise. That's exactly
> the condition pid_in_current_pidns() checks. Pid numbers handed out
> by
> alloc_pid() are always >=3D 1 and only pids allocated by alloc_pid()
> end
> up in the pidfs inode hashtable. So pid_vnr(pid) =3D=3D 0 is the same as
> !pid_in_current_pidns(pid) in the file handle lookup.
>=20
> No functional changes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Ha-ha, this is exactly what I was thinking about when reviewing
https://lore.kernel.org/all/20261117152332.1221-1-arpe1618@gmail.com/

LGTM

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/pidfs.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | =
12 +-----------
> =C2=A0include/linux/pid.h |=C2=A0 1 +
> =C2=A0kernel/pid.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 21 +++++++=
++++++++++++++
> =C2=A03 files changed, 23 insertions(+), 11 deletions(-)
>=20
> diff --git a/fs/pidfs.c b/fs/pidfs.c
> index a2a0691cf1310..85b160923177c 100644
> --- a/fs/pidfs.c
> +++ b/fs/pidfs.c
> @@ -327,16 +327,6 @@ static __poll_t pidfd_poll(struct file *file,
> struct poll_table_struct *pts)
> =C2=A0	return poll_flags;
> =C2=A0}
> =C2=A0
> -static inline bool pid_in_current_pidns(const struct pid *pid)
> -{
> -	const struct pid_namespace *ns =3D
> task_active_pid_ns(current);
> -
> -	if (ns->level <=3D pid->level)
> -		return pid->numbers[ns->level].ns =3D=3D ns;
> -
> -	return false;
> -}
> -
> =C2=A0static __u32 pidfs_coredump_mask(enum task_dumpable dumpable)
> =C2=A0{
> =C2=A0	switch (dumpable) {
> @@ -1028,7 +1018,7 @@ static struct pid *pidfs_ino_get_pid(u64 ino)
> =C2=A0	if (test_bit(PIDFS_ATTR_BIT_EXIT, &attr->attr_mask))
> =C2=A0		return NULL;
> =C2=A0	/* Within our pid namespace hierarchy? */
> -	if (pid_vnr(pid) =3D=3D 0)
> +	if (!pid_in_current_pidns(pid))
> =C2=A0		return NULL;
> =C2=A0	return get_pid(pid);
> =C2=A0}
> diff --git a/include/linux/pid.h b/include/linux/pid.h
> index 185bf0cde2d14..1b463921d2ed0 100644
> --- a/include/linux/pid.h
> +++ b/include/linux/pid.h
> @@ -239,6 +239,7 @@ static inline pid_t pid_nr(struct pid *pid)
> =C2=A0
> =C2=A0pid_t pid_nr_ns(struct pid *pid, struct pid_namespace *ns);
> =C2=A0pid_t pid_vnr(struct pid *pid);
> +bool pid_in_current_pidns(const struct pid *pid);
> =C2=A0
> =C2=A0/*
> =C2=A0 * Needs tasklist_lock if type > PIDTYPE_TGID. A lockless reader
> can:
> diff --git a/kernel/pid.c b/kernel/pid.c
> index 4f9a29eb29de7..aa3ed6b5d4a9d 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -559,6 +559,27 @@ pid_t pid_vnr(struct pid *pid)
> =C2=A0}
> =C2=A0EXPORT_SYMBOL_GPL(pid_vnr);
> =C2=A0
> +/**
> + * pid_in_current_pidns - check whether a pid is visible to the
> caller
> + * @pid: the pid to check
> + *
> + * A pid is visible to the caller if it has a number in the caller's
> active
> + * pid namespace, i.e., if it was allocated in the caller's active
> pid
> + * namespace or in one of its descendants.
> + *
> + * Return: true if @pid is visible in the caller's active pid
> namespace,
> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 false otherwise.
> + */
> +bool pid_in_current_pidns(const struct pid *pid)
> +{
> +	const struct pid_namespace *ns =3D
> task_active_pid_ns(current);
> +
> +	if (ns->level <=3D pid->level)
> +		return pid->numbers[ns->level].ns =3D=3D ns;
> +
> +	return false;
> +}
> +
> =C2=A0pid_t __task_pid_nr_ns(struct task_struct *task, enum pid_type type=
,
> =C2=A0			struct pid_namespace *ns)
> =C2=A0{

