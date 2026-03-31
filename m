Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DD3A10F92EF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 18:34:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A33D96B0098; Tue, 31 Mar 2026 14:34:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0B886B0099; Tue, 31 Mar 2026 14:34:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 921166B009B; Tue, 31 Mar 2026 14:34:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7E90A6B0098
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:34:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1789E585BA
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:34:40 +0000 (UTC)
X-FDA: 84607209120.16.B7670AB
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id E8F57A0019
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:34:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=EGcdM+wY;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774982078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DY3wbcvnuH3o7Ixe/6Ynw4mfzgsEK5w185n5jaWWQGM=;
	b=OEOcuS8nvWF4+Qd/YRkOkRsiZqE2gaEN/NL20VnYg/NuwghIxxjaztCoFoDrfVCJWUqbOw
	HHjJgTEOWeJurZeZnO8lQVQwNHmfZURSoBkpYSv4m1luIwkNi7WP1qhFvDc6OJLBc7qptE
	32O5kCxwtrwBSvxU9VP2rpZAjvbiouA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774982078; a=rsa-sha256;
	cv=pass;
	b=N8cRrVSM8JglKpp8Eq+IZfsHEogH8dqA1ocFQ5BeL+0RYTcQva+tXXXjEHuWJd+9HXBVvZ
	eiCezjDOh3/JeDAfljIUiXGbyaqQKl4PD1T/0deRSPDv6cqfeI180jHm1uheHTvsNlzpV8
	0T4Cch/QHKXEvQ6eaWZVDWzFCNC7cak=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=EGcdM+wY;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b979d16dd0cso1049462866b.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:34:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774982076; cv=none;
        d=google.com; s=arc-20240605;
        b=ALleXFSBvmezmvDkRkm7AZll64ALf4D8PH6soJQpleBtPZsi+gIbFuhpln2CLdghTD
         3yWbIvSKOgpPMbnTxSG0L957M5rZPUhubjHkqQRdZQT5GRsszla4MMu5fw6ztiZ250gT
         XNt6QLdN65CAYJSurLxstE5R1nY5wHGMqeKRq/eKGnerBxs70hRHfV6z830Ccmt/oStO
         rUHubg11uMt5IWKI46l8NcrjOgmxJIszTmXUb4RZOZ7jzU9jnkpOLn/SpqNNvmWVzbuP
         Rq6znHJAYwcAYE6Z6VLI/ujdW1RxeCC+pLT08I9gpvGtq2A/WDir41VNnwoPOSsVVMAa
         vzJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DY3wbcvnuH3o7Ixe/6Ynw4mfzgsEK5w185n5jaWWQGM=;
        fh=wgLMPrwGwyPuF7uFehKKCvbKRmkG4LqyPXmCtMOUunk=;
        b=OTXcqNt+07pxQMp7D/Cs0ytX4dqShxyUDuBqfAxlxfgbxb58fhhND4fPWxqxJPnhhH
         K1HVAuCGXLwI1ykIqa1/2EX+r1BBuOYakF4bEjbrI9wB7VvE8EPKQGeLkMmM2yhtwdRk
         IYmcL7EOoJaTvkuasOyV3d5aDPqxe+nEuIV85/a957QFApmWm2+PIARpwnNbIK2lo1Y6
         mUWIP76U37zwQ0kCPya6siALgnGWl67/gtLoYXauvDkI6gHQ2MY/hpF28fw0ZE0SWbr+
         NvXOO28CCiU8ZFpJYjsWydcizH74D61RjcXk4zS0wyH7zSSZArUatOkgN7EiMrt+YP9y
         xzHg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774982076; x=1775586876; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DY3wbcvnuH3o7Ixe/6Ynw4mfzgsEK5w185n5jaWWQGM=;
        b=EGcdM+wY0JyZNEUP3ZjbwcmNE9YUFjCqh4x79X/wziD/4C0fXJUAdaXCUsCCQLrBru
         1ok1AG3e6pOHsY6dZHG4lp4pTgc8QXkGEZ3xJfzbetAHo08JHtoOFw+PS8+C0hU8rpFv
         DI7M3yrRtzxqbSgM1dpfMkf6YN4gcnWgyMa+2wm6siq7Q+sLmVkibMZxtxReo/07sxUd
         Z3dnNPXF/YddstFBlZJwB5Aa106aDnlw6MAs3habFlG1rWr+IG/X7wHuHB+bpbq09XtL
         P2UvXHZLozBeH/kd/dXhFoYHzz0pzuAPP5nd9uYi+bMZThxAAAuooPO/xDtNR0t5W6b4
         jsyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774982076; x=1775586876;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DY3wbcvnuH3o7Ixe/6Ynw4mfzgsEK5w185n5jaWWQGM=;
        b=QhuZ1KROjjOp6rSPEyrTUntXB0yNDniOKft2g9Y3pI5vkQqe1vULOHijspbs8CCQsv
         U6Kd5uPOb0rrV656bs8ox465L+1UZAiyKIKyvFMi0vf/BaycD89ouYXRGXjhu7PYJWxH
         +NcBWEnkhvJXnEkniwdayNXYvWksJfS0QBiCzvNbA4A5lfsjcRAlEgPXKaHMxTiQvhIk
         vEAw6as15ip+tLmKitFx1okj94vUGG0B8hAaeSODaZ+Dy47ry78/+hMbNbIQSlUcX/ui
         JETf7JZT+HVreKxBTIGznZbMwNMlCBcEcodNH+hCEr68p49upep6ujyrS5NO9GFxXZPG
         0U6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUPPE+0J42aRQqlBx9W+s2Z+7QEW10HttwGonlQ61k0ezEsJa7By+zV1GeZT6VY43o64/0aBnIdiQ==@kvack.org
X-Gm-Message-State: AOJu0YynE7AKSaPqyI1n36CWCjvi0PYrY7JN0cBF8HCALS0reVDZaJcy
	QHtngT0DEk+ICz1sOVe7PaHw8qgnX8Nl0wVKAE1LNCvOfzRRTl+IQyVC3fx5sYh4f3BHe5ylFVs
	btlBTgW+IH1f7Mk85SL3A8fxAMg/dEsy63S5DZ29urA==
X-Gm-Gg: ATEYQzxf75cIV4UdXXJdRXNgsl8R0rWUUqlNc31hHPdnRKMF9RwDITdltoMOxl9hVy8
	77ZOsCycl1CL4lVp/Ff6FRGoXW93E5FgC3fX4n+VpvysfCI5c4hbrhxpnXJ2V8i0ryNQbeGdZ6+
	DTXcTeZ4SAaAzHpX9FqehyFA4T8YrLXfFTBySb7dYmAMTzTpmOXTeVrEeUQn5Uav2u7/mkQFeLI
	pV5PHaKD/5f6+gZhYPRV1dQMDCOIWeA6XfPSYubHlaBAI+7U3dUx36coKfH3oVHDYl2J7prkHWL
	WhtmSV/9AX2ybHw6JtOo8d2O7a4Y7kvITH3wAw==
X-Received: by 2002:a17:907:84d1:b0:b9b:fd23:d0c8 with SMTP id
 a640c23a62f3a-b9c13b0fd96mr41864466b.29.1774982076111; Tue, 31 Mar 2026
 11:34:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260331175639.4066033-1-luca.boccassi@gmail.com>
In-Reply-To: <20260331175639.4066033-1-luca.boccassi@gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 31 Mar 2026 14:33:59 -0400
X-Gm-Features: AQROBzBHBf68DKK7aZZU4u2jQSiYayfjEGRzUDBkbeEz7PAvcd2w4jNJnR0shvA
Message-ID: <CA+CK2bCKJ8rkJ_onp9Za0KNuWujH4Gzue3a=HvwOJAK2tYhReA@mail.gmail.com>
Subject: Re: [PATCH] liveupdate: add LIVEUPDATE_SESSION_GET_NAME ioctl
To: luca.boccassi@gmail.com
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com, 
	rppt@kernel.org, pratyush@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: 7rgp8ahyxz6tcx18gjx9wadz8e7xj13o
X-Rspamd-Queue-Id: E8F57A0019
X-Rspam-User: 
X-HE-Tag: 1774982077-809270
X-HE-Meta: U2FsdGVkX18MUhbS2aZoStDWXADhx5jCKVuMC03TXbrxBbBR4ZrFSdOy1IVyiCfreDqKWG4MHAWzZIJDC6aBs7XMayy6U/oIOKmgXPCbc58rgffDDfby9ERl+9o9NOwZCRA0LxG26sbDj0PhqrsohNPg0LDuaw3OOW68RO9NhALENTEvQax3mxfCXti0uD328b/MNf8AuBavplpfy9E3MWFjvevArFt/NZo6FoE/xgIyYZmjIqvHjbMN+Jm/sZ0NkJzOp1kWX9kzE8NWDxt4KimCV0OuIIYRtXX2KKcApYg+bZ50+9VGc4ikME4W6frJk/YkCAZwk6vYJP7mxRRWb0ozv+6kZ3DQVu1RINu2KgRY6Ynz17ae6OLEAKkl8bdsx6bp/08kSbORBEO9aqmhwFn3k74p8QJK/jh6cpiZEuwrw3J0dmyAEkEaCqmO8bLNt51EIa/DdbHtxNPKlVXXR3QgnnF/vy0mBRF35rMLi7jeuzaUseB60eFkPcOgegFLKeKr0AZ7uvoD2biH840HpJF9TkLmwufgGDhiFsEzIsCB/qa0un/50xVK5JgiXWmeAZ/ZpUt+6mMavYBKMYmbq4ja21aB4OHKRT5pwCELfuZ1AYAhVdcv/6OxQ2efBMBJ5J4RpLHOmcJwQWi1uMDg0nVCtyJ61/7HCkZLQSrHVTEkbgQgwAPttY/QseNK9TdinnmHjfRflJqSHeuqaiLDg+LpBVu7c5WEySG30bf50W7RQN9jIweF1ZONZzJAJMOxwJGuPJgMH98iWIvq8IMPM9mFiSmlvxZQdS9IyRg+BQsyyapxj5cqeG/WM2YwdJndihdlYxNcYawg0gJYC86YyOl0LkjgMxK1belU89BP8rYNGg8QpL9O9zFfnSxaXaW9lB8LJjeVOH1z7OyO5qwN7b33CilK2cCvMLxfhQBaywCL89Gky/XDt6gOopvWsLFYTeZB2M0qrKJ3p3ZMskW
 dylZ908f
 8g17vV2cDVaQhmryyK1jOXzhHJ3rdRJA3GQrVeL0MDjx5mGF8PbSct/jOIHR6EoW9PQQqvZT3Gt+M+YBn58jMRoVFxXgoc0dTtCuooEnO40j374XdwMI7mtkYJR/Kn8V3bO7DAw0B2FxtPVWK8VRXLMCuO51J0yRJiOo6Hvteo1H1+WIJ2GkEFeuGuIn9IlHTpuXENtwoVCf8ugi9J1zHa4NS9+f1U+0OIOe07HVTHp4uzCnzoN1zmvauQXcKf0DtLLZ8xMoEM6bX5g6CyLuLc+tE/rF2s6ZMOWL20Lgw+DmlwrR+ABX+l0/6wLkIQJ6RDAFOvKqomzmSET5uoNs5FQlC5DpnpCtjoi2EKseM0XugIoNZJmRy1BVUdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 1:56=E2=80=AFPM <luca.boccassi@gmail.com> wrote:
>
> From: Luca Boccassi <luca.boccassi@gmail.com>
>
> Userspace when requesting a session specifies a name and gets a FD,
> but then there is no way to go back the other way and get the name
> given a LUO session FD. This is problematic especially when there
> is a userspace orchestrator that wants to check what FDs it is
> handling for clients.
>
> Resolving the /proc/self/fd/X is lossy as that has a hard limit
> of characters, so names might be truncated. Also requiring going
> through procfs and doing manual string mangling is not a nice
> pattern.

Hi Luca,

Thank you for working on this.

This needs more explanation. The way I see it, the user orchestrator
can be the only one that has access to /dev/liveupdate (and this is
actually enforced by kernel). It opens it and creates session_fds for
any client out there. So, the orchestrator already has the FDs and
sends them to clients(e.g. via SCM_RIGHTS). It then monitors the PIDs
of the clients, and if they die, it closes the session_fds for them,
as their data does not need to be preserved.

Could you please explain why the user orchestrator would need to query
the session_fds, since it is the one that creates them in the first
place and has to keep them open in order to preserve them during a
live update?

Thank you,
Pasha

>
> Add a ioctl to simply get the name from an FD.
>
> Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> ---
> Need this for integration in systemd, so that I can check what
> FDs I get from clients and what they are, and so that I can know
> where to hand it back to
>
>  include/uapi/linux/liveupdate.h               | 19 +++++
>  kernel/liveupdate/luo_session.c               | 13 ++++
>  .../testing/selftests/liveupdate/liveupdate.c | 72 +++++++++++++++++++
>  3 files changed, 104 insertions(+)
>
> diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupd=
ate.h
> index 30bc66ee9436a..41dc44d239dde 100644
> --- a/include/uapi/linux/liveupdate.h
> +++ b/include/uapi/linux/liveupdate.h
> @@ -59,6 +59,7 @@ enum {
>         LIVEUPDATE_CMD_SESSION_PRESERVE_FD =3D LIVEUPDATE_CMD_SESSION_BAS=
E,
>         LIVEUPDATE_CMD_SESSION_RETRIEVE_FD =3D 0x41,
>         LIVEUPDATE_CMD_SESSION_FINISH =3D 0x42,
> +       LIVEUPDATE_CMD_SESSION_GET_NAME =3D 0x43,
>  };
>
>  /**
> @@ -213,4 +214,22 @@ struct liveupdate_session_finish {
>  #define LIVEUPDATE_SESSION_FINISH                                      \
>         _IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_FINISH)
>
> +/**
> + * struct liveupdate_session_get_name - ioctl(LIVEUPDATE_SESSION_GET_NAM=
E)
> + * @size:  Input; sizeof(struct liveupdate_session_get_name)
> + * @name:  Output; A null-terminated string with the full session name.
> + *
> + * Retrieves the full name of the session associated with this file desc=
riptor.
> + * This is useful because the kernel may truncate the name shown in /pro=
c.
> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +struct liveupdate_session_get_name {
> +       __u32           size;
> +       __u8            name[LIVEUPDATE_SESSION_NAME_LENGTH];
> +};
> +
> +#define LIVEUPDATE_SESSION_GET_NAME                                    \
> +       _IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_GET_NAME)
> +
>  #endif /* _UAPI_LIVEUPDATE_H */
> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_sess=
ion.c
> index 4a40c7fdfb44f..819e8864869fd 100644
> --- a/kernel/liveupdate/luo_session.c
> +++ b/kernel/liveupdate/luo_session.c
> @@ -289,10 +289,21 @@ static int luo_session_finish(struct luo_session *s=
ession,
>         return luo_ucmd_respond(ucmd, sizeof(*argp));
>  }
>
> +static int luo_session_get_name(struct luo_session *session,
> +                               struct luo_ucmd *ucmd)
> +{
> +       struct liveupdate_session_get_name *argp =3D ucmd->cmd;
> +
> +       strscpy((char *)argp->name, session->name, sizeof(argp->name));
> +
> +       return luo_ucmd_respond(ucmd, sizeof(*argp));
> +}
> +
>  union ucmd_buffer {
>         struct liveupdate_session_finish finish;
>         struct liveupdate_session_preserve_fd preserve;
>         struct liveupdate_session_retrieve_fd retrieve;
> +       struct liveupdate_session_get_name get_name;
>  };
>
>  struct luo_ioctl_op {
> @@ -319,6 +330,8 @@ static const struct luo_ioctl_op luo_session_ioctl_op=
s[] =3D {
>                  struct liveupdate_session_preserve_fd, token),
>         IOCTL_OP(LIVEUPDATE_SESSION_RETRIEVE_FD, luo_session_retrieve_fd,
>                  struct liveupdate_session_retrieve_fd, token),
> +       IOCTL_OP(LIVEUPDATE_SESSION_GET_NAME, luo_session_get_name,
> +                struct liveupdate_session_get_name, name),
>  };
>
>  static long luo_session_ioctl(struct file *filep, unsigned int cmd,
> diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/test=
ing/selftests/liveupdate/liveupdate.c
> index c2878e3d5ef90..510a583371fac 100644
> --- a/tools/testing/selftests/liveupdate/liveupdate.c
> +++ b/tools/testing/selftests/liveupdate/liveupdate.c
> @@ -102,6 +102,22 @@ static int create_session(int lu_fd, const char *nam=
e)
>         return args.fd;
>  }
>
> +/* Helper function to get a session name via ioctl. */
> +static int get_session_name(int session_fd, char *name, size_t name_len)
> +{
> +       struct liveupdate_session_get_name args =3D {};
> +
> +       args.size =3D sizeof(args);
> +
> +       if (ioctl(session_fd, LIVEUPDATE_SESSION_GET_NAME, &args))
> +               return -errno;
> +
> +       strncpy(name, (char *)args.name, name_len - 1);
> +       name[name_len - 1] =3D '\0';
> +
> +       return 0;
> +}
> +
>  /*
>   * Test Case: Create Duplicate Session
>   *
> @@ -345,4 +361,60 @@ TEST_F(liveupdate_device, preserve_unsupported_fd)
>         ASSERT_EQ(close(session_fd), 0);
>  }
>
> +/*
> + * Test Case: Get Session Name
> + *
> + * Verifies that the full session name can be retrieved from a session f=
ile
> + * descriptor via ioctl. This is important because /proc may truncate th=
e
> + * anon_inode name.
> + */
> +TEST_F(liveupdate_device, get_session_name)
> +{
> +       char name_buf[LIVEUPDATE_SESSION_NAME_LENGTH] =3D {};
> +       const char *session_name =3D "get-name-test-session";
> +       int session_fd;
> +
> +       self->fd1 =3D open(LIVEUPDATE_DEV, O_RDWR);
> +       if (self->fd1 < 0 && errno =3D=3D ENOENT)
> +               SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
> +       ASSERT_GE(self->fd1, 0);
> +
> +       session_fd =3D create_session(self->fd1, session_name);
> +       ASSERT_GE(session_fd, 0);
> +
> +       ASSERT_EQ(get_session_name(session_fd, name_buf, sizeof(name_buf)=
), 0);
> +       ASSERT_STREQ(name_buf, session_name);
> +
> +       ASSERT_EQ(close(session_fd), 0);
> +}
> +
> +/*
> + * Test Case: Get Session Name at Maximum Length
> + *
> + * Verifies that a session name using the full LIVEUPDATE_SESSION_NAME_L=
ENGTH
> + * (minus the null terminator) can be correctly retrieved.
> + */
> +TEST_F(liveupdate_device, get_session_name_max_length)
> +{
> +       char name_buf[LIVEUPDATE_SESSION_NAME_LENGTH] =3D {};
> +       char long_name[LIVEUPDATE_SESSION_NAME_LENGTH];
> +       int session_fd;
> +
> +       memset(long_name, 'A', sizeof(long_name) - 1);
> +       long_name[sizeof(long_name) - 1] =3D '\0';
> +
> +       self->fd1 =3D open(LIVEUPDATE_DEV, O_RDWR);
> +       if (self->fd1 < 0 && errno =3D=3D ENOENT)
> +               SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
> +       ASSERT_GE(self->fd1, 0);
> +
> +       session_fd =3D create_session(self->fd1, long_name);
> +       ASSERT_GE(session_fd, 0);
> +
> +       ASSERT_EQ(get_session_name(session_fd, name_buf, sizeof(name_buf)=
), 0);
> +       ASSERT_STREQ(name_buf, long_name);
> +
> +       ASSERT_EQ(close(session_fd), 0);
> +}
> +
>  TEST_HARNESS_MAIN
> --
> 2.47.3
>

