Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6B3B606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 14:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=r9OKEm7C
Received: by kanga.kvack.org (Postfix)
	id DEB286B05B3; Fri, 20 Nov 2026 09:10:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC2A46B05B4; Fri, 20 Nov 2026 09:10:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD8066B05B5; Fri, 20 Nov 2026 09:10:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A6E3D6B05B3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:10:59 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 399FF1A0F53
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:10:59 +0000 (UTC)
X-FDA: 85455683838.09.A01E76B
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4A8911A0013
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:10:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=r9OKEm7C;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of alex@amutable.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=alex@amutable.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795183857;
	b=YU8NxtkBq/4nLafKpPlvbl2GNDo1pca9fBlmM5sAIbYGSRD1MNQMmm+uH3MIpb+ZKCtIRP
	i31f2raaZGRed+2qnOn6OVm7kUZcOZcu8NNtbAyAn1aaVlw9WaD5KtA5AYWLQbMfhUkaDq
	fuC4C3rmc4y2TWXnd/unudTeqCWCed0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795183857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xdvxIbctXUQ0A6p+jo38RyjgMp4bn1ACclIQLuotDG0=;
	b=whu5uRzqzIQv555JC9JyMhpo9bOP1eVPRFqu+6AWrRTDV688dyN5WdPsLBhXqVUDZHcAcW
	ieFcL0APV9jK+0hGkQLCOtPpRcVexlvyDpMKNIX7uutlbGDiokIlufuQj9BAANKEsoqRYB
	k4HRJPOA5MM512hx7IpsTl8ti90U36k=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=r9OKEm7C;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of alex@amutable.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=alex@amutable.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4ac95761c85so7149925e9.2
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1795183856; x=1795788656; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=xdvxIbctXUQ0A6p+jo38RyjgMp4bn1ACclIQLuotDG0=;
        b=r9OKEm7C9HZsvQcmU1s5kbvVN2VCBklWU+SrF3K0DSG9DyImQb+md4HUgCQlw9tVfd
         Bm28/C4p0iWhD5yIXO9JSMvQo3fQrHOibHTnV9m4zNPk3E2QA6WzAPrErxCgpW+5SxRQ
         1VdQ/cdZRYupwzg0F7Lfu1jIMIbZVJY1xKe1buALAafvkFGrwvVAMjXa9qLBIhz0ZmiJ
         mEPvUSx8gLUptuYp1eGPGl8kKLy9tOR1fgia9aG3oAamzbfn8F5sPgUhJVW+oav2s6qP
         vQF614Po7Kvsxy02DvSHwWauqO/xBQLIWB7shWBuBqseTId4VeNqjNgxnFXPCcxu/KTW
         AYuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795183856; x=1795788656;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xdvxIbctXUQ0A6p+jo38RyjgMp4bn1ACclIQLuotDG0=;
        b=UQ6Kk2JgGCwIOWxCOLhDnX0VgdwAT+7CIYDRtUuB2MSuXBlaRGGR+9PDxAcXBofbTS
         D8oIQJpH+az+u2DRSJLyMcq9iliu/+2jtJHZ8BczYuWdEOcMRtnyY/gvNZo2F/SD2EKc
         MdAWvwD/Fny+53d+HhZINHTcPs9ZYoIp7mgZIZL3O3P8OtGsiWzJoqtxM0gPMi+Wxbkw
         fKKI+r7ENX6mpaAC07nbIHANVkXEy7VGyY82jUPxz9AjwHEqIGVhcHhVlig7qDMd8GKh
         vvcyAf+nv5SZT/Sq3LITxpUDmY8lO9IwU+6pZTSGKucI8kHt15BNz+T9tSQj3oLAIY6k
         Rr4w==
X-Forwarded-Encrypted: i=1; AL+hErEktuMt+7QSsx+A/twHid7HZ4UuhPqrSnMIIU8nMqG7j0QtHL1Q/5wgFY/Vpx2AZC7/5FB68ecA4A==@kvack.org
X-Gm-Message-State: APuU4Z/VLwYqTDKlZhL9jCzdVePpLDgWvGY+vdzL63Ni+uqXJWb0onK/
	FJHflMsJt2FFCxQvkSzG8mObA+LPNEq7rUC84ifLu+tFb4lU7CiVa0qmlb08iqlQshbg
X-Gm-Gg: AYBFou3DCkYgJbV4oQcTebWLbe9aJWG7/LjKfMx+qnrJZBiBEdEzZoVW7qlWXR1FrBi
	jLNjtPcyxwal/9jZZEGII/LiPLFedhap0fDxi/ezDUTAGrhJFHFai/rPRBr4HQmoep6R0g09liz
	79iutmGoHd65vNurWlJ+/eA7ZXmc7xbB0izUfy6YFiMKtA8p6G2HXcca4AbTgN5fthJM6XBIN/T
	QP5SSAy+stFRJB8Aa/ITBd2P7GRD0tAxTor3gEWPjCzq49VrpEtIEvj8o788E0QiffLqvbtVz4Y
	BrbtiUOZonjVpQYBp1cJg09dZUA1O60wro0JNxWjJkJmk2BRwVREQSTRZQgWmATs4ofRVntvKUD
	xXY5B42bg5g9LUZ3fEuImzoqvbJmtrhy9bn2UCM2xOjQXjWbw5YgD/NER36shhMBSYEV+uKPrLV
	++ln8BThi3W5wqF/RJ2LCAAg01+O7l9dsmfvD+m1VpmzvbFyJpqlcL4GUJpF/UbsaJwTQ4DJROV
	jJw3ffbIiTWFOqXnctbtWDPiWFIcAXM+llMMnEfmYeMmSITcWwRsOfWCtP59YB7bS9SCJhJqkV7
	dMdy04OCSYgcmXWkq3RqrnQbDl7sawG6pRuN/Enh6jh3TwhKqO/njxY8q6a38M/LrA==
X-Received: by 2002:a05:600c:1d8c:b0:4bb:5345:606b with SMTP id 5b1f17b1804b1-4bb8882358dmr73891225e9.31.1795183855925;
        Fri, 20 Nov 2026 06:10:55 -0800 (PST)
Received: from [10.0.0.233] (tmo-084-188.customers.d1-online.com. [80.187.84.188])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8538b3a7sm136973405e9.3.2026.11.20.06.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 06:10:55 -0800 (PST)
Message-ID: <60078f93cf307f3040b4913bb94b2d73798b4471.camel@amutable.com>
Subject: Re: [PATCH 2/3] pidfd: convert remaining visibility checks to
 pid_in_current_pidns()
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
 Jann Horn <jannh@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>,  Jan Kara <jack@suse.cz>, Jiwoo Kim
 <arpe1618@gmail.com>, Chen Linxuan <me@black-desk.cn>, 	linux-mm@kvack.org
Date: Fri, 20 Nov 2026 15:10:53 +0100
In-Reply-To: <20261120-work-pidfd-pidns_visible-v1-2-0e82d08469ae@kernel.org>
References: <20261120-work-pidfd-pidns_visible-v1-0-0e82d08469ae@kernel.org>
	 <20261120-work-pidfd-pidns_visible-v1-2-0e82d08469ae@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4A8911A0013
X-Stat-Signature: gusn91fcr3ozqmp7zx4id9zjkfyqccsb
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795183857-755298
X-HE-Meta: U2FsdGVkX19HnUQ5C32ZbnfgzlI+HooREOl0/hI9cEUCKeWPXaIwX1bG8R8Wo8MBe0zGum0bhqmeo0UnF6WD2PqmN+uJL+WLUwZyhT/yVbWXyQTGSu6LNJCClLRZHVB6Aet0BXfpfZ3sPMqHxjlQoXTVimUHeqUdeCAyY31VbK8hKGaC1PpQMuJmAhuQ8BkZPKkUVOtm/O69PTgKwJ0hk1XD9R7mMoy2cCdTHwM7NwjPob9FZMxmLGdEK3xHWi1D7R/EO2i+VIZGSj5Vb6EAVv7/XFf7dDN0FJzN7zTlHbgzSAgxXAtabUlfVv5DdjjWOMld4WWYd4AgQa+54tn0pU2eyN7LAb5X5v6zZTF9CRzlm0Wx+pawaoGJUn4fSVWELtxAdtKTwli8Y8eyupmq30mp+fXh6vwq67YnBYuHTOeBQmDhyUHu8ZqCS2nmO9kZX2+0jeXFTSpGtAdq/dqIV5LmrT/ShWIv4z7nEZWboqxswzMKG2pE9SprZA0gRkawt57eSM1BTTkrX5/Dfz6DPLibqyvuSVFeozacBNlODhFPPtyOtrAGS2qx3H+sh6pqnbngcs9UsIGpn78YFDCUTTPay200UoP0bsOxnBQZ6clQI2yCkcLMzUOV1xBnXk9F+Q1Zv3TmpQ17ipGVDokvuU1GIi75LHPTxvtKn65pUlKd2lqnv32vH2QObPqMTX+sYDInw6k8e2U7GIO7PIty7T7CqqHE/C/hJ6yJa1jkQsXemcJntd9td7eaQM4uQmsFaZo28g8iu+rx+pIuJPv3eS9CDFuGWK+yUqdsVpnmeKoLP7Gedt7abdPZUMdRNwtxPYzTibgNfaC8TKI2bLCFen60oJ3ND/9XITBgAiKqH37U932XlBkvf29OSSSjYHGXhsWju2Z8mm8jvtEP5XvvSPaUo06I2rV3+sd78R93HELNZENU77MncOsrveNa4GCqYLlQTtVJGTZU7JeBm/N
 NleR9/kF
 yOSMOrNk78G/ZyP/qIYFDOUIPK+//+Q0y/r0deCanSRExXOZKVCZ9jAlucQZKTL5hF2y5d0asPkNckFiDmc5JnTLD+VSqjr2JjULMQ35EoxnzEzY6kbF1iUPFJN1YYFQ91tfoLW0xc1owOBmLMwDjjGqDK4pter3EUpX9ajJWITn/HFmY2XnGl6kDECCNR/lroUUJOF06hCdhJO9BQEX5vHbndq3ugahp83SySnA3EhcgMgCjvmWzHvsnhOVg7Y0Mt/K1oIspgEymCiLTafP/q5T6efW3Ka7zTC2+hcew2OWQB4KbmEXn34hHrupFoI8H2+rGXFI/wkQiQ8LmfmQewn2oDRZHP//IJv0T5c17IZspDF284R3/fjftKy433XfHCwEXjJcfWwAOuc989Qtkpci2wwcclaMcpxEfp4gILx3/M9J6JqcESABxpGJsefrRz8UaDdgtQlij9FJ7d+GbogmvfUmJf7uDwbmFY5BTDkMuIMIWP8xotmeJqQQxp5l5ufU+mdpdSoPwmmNrjEDv6p+0ElEyzI/r7z36qnrzlxbGnUGEFuY91tOiKjQuTnyicIWTDDYe+5tSlEVDkTy4sE3GYAv16mmh6cndGuJj321lUZb03pZtJCXLhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 2026-11-20 at 14:42 +0100, Christian Brauner wrote:
> Switch the two remaining open-coded visibility checks in the pidfd
> api
> over to pid_in_current_pidns() and drop access_pidfd_pidns().
>=20
> pidfd_getfd() uses !pid_vnr(pid) which is the same check as explained
> in the previous patch.
>=20
> access_pidfd_pidns() walks up from ns_of_pid(pid) via ->parent until
> it
> either finds the caller's active pid namespace or runs out of
> parents.
> pid_in_current_pidns() instead looks directly at
> pid->numbers[active->level]. Both answer the same question.
> alloc_pid()
> fills in pid->numbers[i].ns with the ancestor at level i of the pid
> namespace the pid was allocated in, starting from that namespace at
> pid->level down to the initial pid namespace at level 0, and a pid
> namespace is always exactly one level below its parent. So
> pid->numbers[] is just the ->parent chain of ns_of_pid(pid) laid out
> by
> level:
>=20
> (1) The pid was allocated in the caller's active pid namespace or in
> a
> =C2=A0=C2=A0=C2=A0 descendant of it. The walk reaches the caller's namesp=
ace and
> =C2=A0=C2=A0=C2=A0 succeeds. The caller's namespace sits at active->level=
 <=3D pid-
> >level
> =C2=A0=C2=A0=C2=A0 in the chain, so pid->numbers[active->level].ns =3D=3D=
 active as
> well.
>=20
> (2) The pid was allocated in an ancestor of the caller's active pid
> =C2=A0=C2=A0=C2=A0 namespace. Then pid->level < active->level,
> pid_in_current_pidns()
> =C2=A0=C2=A0=C2=A0 fails right away, and the walk only visits namespaces =
above the
> =C2=A0=C2=A0=C2=A0 caller's and ends at the initial pid namespace's NULL =
parent.
>=20
> (3) The pid was allocated in an unrelated pid namespace, i.e.,
> neither
> =C2=A0=C2=A0=C2=A0 an ancestor nor a descendant. The walk never meets the=
 caller's
> =C2=A0=C2=A0=C2=A0 namespace and fails. If active->level <=3D pid->level =
then
> =C2=A0=C2=A0=C2=A0 pid->numbers[active->level].ns is the pid's ancestor a=
t that
> level
> =C2=A0=C2=A0=C2=A0 which isn't the caller's namespace, so pid_in_current_=
pidns()
> fails
> =C2=A0=C2=A0=C2=A0 too.
>=20
> With CONFIG_PID_NS=3Dn everything lives in init_pid_ns at level 0 and
> both checks trivially succeed.
>=20
> pidfd_send_signal() keeps returning -EINVAL for an invisible target
> as
> that is existing uapi. pidfd_getfd() keeps returning -EREMOTE.
>=20
> No functional changes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0kernel/pid.c=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A0kernel/signal.c | 23 +----------------------
> =C2=A02 files changed, 2 insertions(+), 23 deletions(-)
>=20
> diff --git a/kernel/pid.c b/kernel/pid.c
> index aa3ed6b5d4a9d..72b98d0f35ab1 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -918,7 +918,7 @@ static int pidfd_getfd(struct pid *pid, int fd)
> =C2=A0	 * Require the target to be visible in the caller's pid
> namespace,
> =C2=A0	 * like the pidfs ioctls that grant access to its resources.
> =C2=A0	 */
> -	if (!pid_vnr(pid))
> +	if (!pid_in_current_pidns(pid))
> =C2=A0		return -EREMOTE;
> =C2=A0
> =C2=A0	task =3D get_pid_task(pid, PIDTYPE_PID);
> diff --git a/kernel/signal.c b/kernel/signal.c
> index dd770e68faee0..2c2907d969485 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -4045,27 +4045,6 @@ SYSCALL_DEFINE2(kill, pid_t, pid, int, sig)
> =C2=A0	return kill_something_info(sig, SEND_SIG_NOINFO, pid);
> =C2=A0}
> =C2=A0
> -/*
> - * Verify that the signaler and signalee either are in the same pid
> namespace
> - * or that the signaler's pid namespace is an ancestor of the
> signalee's pid
> - * namespace.
> - */
> -static bool access_pidfd_pidns(struct pid *pid)
> -{
> -	struct pid_namespace *active =3D task_active_pid_ns(current);
> -	struct pid_namespace *p =3D ns_of_pid(pid);
> -
> -	for (;;) {
> -		if (!p)
> -			return false;
> -		if (p =3D=3D active)
> -			break;
> -		p =3D p->parent;
> -	}
> -
> -	return true;
> -}
> -
> =C2=A0static int copy_siginfo_from_user_any(kernel_siginfo_t *kinfo,
> =C2=A0		siginfo_t __user *info)
> =C2=A0{
> @@ -4186,7 +4165,7 @@ SYSCALL_DEFINE4(pidfd_send_signal, int, pidfd,
> int, sig,
> =C2=A0		if (IS_ERR(pid))
> =C2=A0			return PTR_ERR(pid);
> =C2=A0
> -		if (!access_pidfd_pidns(pid))
> +		if (!pid_in_current_pidns(pid))
> =C2=A0			return -EINVAL;
> =C2=A0
> =C2=A0		/* Infer scope from the type of pidfd. */

