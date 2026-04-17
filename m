Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 184CEF99C6A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 21:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A5BD6B014C; Fri, 17 Apr 2026 17:48:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 255C86B014D; Fri, 17 Apr 2026 17:48:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 143B36B014E; Fri, 17 Apr 2026 17:48:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EF5D06B014C
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 17:48:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BCC751B7949
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 21:48:24 +0000 (UTC)
X-FDA: 84669386928.17.D5FA05B
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id DB771C000D
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 21:48:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HnBvFr0z;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776462503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nHdL1Ocg1KAYUcmdB/M7wkvLdiK2qMWc0+wVJsX3Xkk=;
	b=sXHGpsD6xhf9NRs6670OFSDHKIKaQYddIOirN1lXxy/vzNpe+DMu++IM5C/sN1szCvZSgq
	StKjY/6ByVtR5lIBJwF8O6LHnZgcCPmAhwqp2UeXqoxFYOi0t8hZF9XPCrxwxvK5GBbRUR
	dep89L/7XXPwwhEu6f6OActJB01L8n8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776462503; a=rsa-sha256;
	cv=none;
	b=2qsXdAzW4GnQQWuWPvWay7zbhJ4H4cBF+WCQSZDmBgVNCDpKQDHq/RCNxci9siH1uM+g46
	KQqbMK7/XuILsiheiuk7yN/1bwfk5aNxW2NvBEjphkFim/FFq0RjuMIKHYYvQZHbKr9+hG
	Nkb7DrZcWW2MxMUSIjnP63+R7JOyUIY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HnBvFr0z;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8a210c813f8so8396516d6.0
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 14:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776462502; x=1777067302; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nHdL1Ocg1KAYUcmdB/M7wkvLdiK2qMWc0+wVJsX3Xkk=;
        b=HnBvFr0zWtccVeApqUJ21pW8iQJdCuUbHFhcx+QZPySONGvjyOoCd8Y/KmQrM7YI5u
         nJKGyWEc/ecuqP2+ASrDwrtd3zD/5av8Ql42cmbcnqr2/qT0aEBwBXKUzxrufkSkdW8q
         gWt4xCNPo6xbo2p1sTjdDsfxbG2L6BjwW4dCyPZZXKrk0U9MJov+k2IRu0SQDjgl7LY1
         qdAA78scGWkmavNB6YvJWamvf6K97lBgytOmokUJwggW1FNw+wgL+nOg3I3J9017qXV+
         eqGbD4N041VDWLb850VAF5X8mdGLVVnkO48uCfsaj7+4WOCR2ciMpVH1eaxEPsvxgNBJ
         Z5ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776462502; x=1777067302;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nHdL1Ocg1KAYUcmdB/M7wkvLdiK2qMWc0+wVJsX3Xkk=;
        b=mXKAg/tPL852wIEO28G02+SzsFdGfCAO2j7bzm+IOaLdQ4ulZv+IV/sY/NaK7e6D3k
         rajib30VCxtG7GcOoYBNKkJCzNq7ig/RoI/3OI5XIrfCLGsXmRb0b3Wqqdwur4f1l7aT
         /0Laeu6BwxqJw94xbimZ1l6bg7RdxiSh9VfNe5Y21e5QPCeNUyCNNzAQp28K28IDVcxX
         AYo++k5JSBHZn6ZMP8DuSo+kQiW3fuJKaeg8dOpSMDn6Q1ZU4o4FX+Aw0IO+Br3l3Qb4
         72rBq1DhHMod+ITnLDNYNvcQs2KlZRgTifbyzBvlG3odZsBzPkFnv/0ziDAHvKDddiz9
         Uf3g==
X-Forwarded-Encrypted: i=1; AFNElJ/sl4IVSVlC7X4/m28IhC4jwu//uXC0/akES15T2YpZxTeNT4HDJR2WjL7U2eQ1XNbSoI4DS62BOg==@kvack.org
X-Gm-Message-State: AOJu0Yx0WkHwbzwV6i5F9+rBzmb/snhCL/j7/i2dyT0TXa7p2+z300V8
	6fOlzOrkEjJCoqrVba9PGfS2vi43EzmcPsqYvn7pJnwdqtSQqkrhsAZqBLQKqb2zmA4=
X-Gm-Gg: AeBDiesZVhtVUFCC8CWPzEh5xulLfrqvEogQ1NTB8U8aiBK6lpwbwR0Bu4pQV8e5QyC
	a/ZhYwvg0MNXfULCkOFQ0jRGxK5DCS3pXZb//7yOevl+xznH9Fr57NyS8SGjOItCED+NR+zXuva
	KO3+Bu4q0R5H9S8HS/Y1m/vt0wQYd+5zYGDKiag0BhDAmdbTlctc12kwu/1J2pxJHXgaxbIBy1z
	NFpkuC+pZa2wJkTEJVf+t1X71wspEuvc42KmOp3ncNEMkdtx0rmBxmC6kxLOeMMwrZahb9ssYLC
	9hcBi+T1/74lTuyFy8IMP0xRImIPNikiGs8G4pS1V/7QKxkdfOLPGMbQtDYtEzQ+9mWO9qbqhK8
	TKOIKI4Qu5TAF2g7PIBYsHzpVKOGfgpbjBNsJFp2vdcX4Yw3PL325NjaF3XGwQwnEe8B7n1HOMu
	fS9nMdg+Vtt8ETXb/onMrel3psZ0182bwFP4MIN2PAR15TDhtmy34UvDBLhyrifM+03AEXMZk=
X-Received: by 2002:a05:6214:4f18:b0:89c:4812:cc2 with SMTP id 6a1803df08f44-8b028065b51mr63135706d6.15.1776462501707;
        Fri, 17 Apr 2026 14:48:21 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02aebc0f8sm19830736d6.47.2026.04.17.14.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 14:48:21 -0700 (PDT)
Date: Fri, 17 Apr 2026 21:48:19 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: luca.boccassi@gmail.com
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com, 
	rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	brauner@kernel.org
Subject: Re: [PATCH v2] liveupdate: add LIVEUPDATE_SESSION_GET_NAME ioctl
Message-ID: <huu6stumzw7ziu7i5qsbpo54hmvd4j4g6fge3acrulhwekw7ez@mjjf6psjty2g>
References: <20260417003856.1525287-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260417003856.1525287-1-luca.boccassi@gmail.com>
X-Stat-Signature: yhizrabtu1cfbftinbsgawnnzo9uijbq
X-Rspam-User: 
X-Rspamd-Queue-Id: DB771C000D
X-Rspamd-Server: rspam05
X-HE-Tag: 1776462502-62956
X-HE-Meta: U2FsdGVkX19TqPI8apVRiCsnzf3QxlBcGLRaC1F4foUE6+MioSfXdhge99Nn9uJJNTcYRNn6J9vOgaYsczU9afnLZmJMJYHsE/IkrR5k3rBE40RGQcgBBZXLTpirxmyHYfEF3Ods5Oq3YH3fYc+6dXo9bebtMG9b39gEK7u2vc4+WiP9p4DgKjHshkMwed/tWvQD6nndeyIrptIDXNV2QAWJlTgeFVN2FDYA6kEGjEGGBEHFKBRwrRmDJjHBdNWGfNaoA/P00QlGKnTnpkduWfGYtfsj31q6giZJZettkpEXj8ZoUCyuaF3ITCYqWqaOJ+CzLcfQV0bJy0D9rrGhZ/dGIXIUY4ylxOz093l9ANnrOmFRSbR6wQRds7LCUXEA+ww8Z5OwxPtS/8bFnIGseq81vspEEuRu6Ff5r8arQW2fKN0Nig7ug+ufESGoG8gvAlOR9FBY96mhZlix2wRUFS+yh8j5KKFJ7hHiDUBu5xXDy9F4hUjhOdHgNhil4gy1dbxCcIwCpMF+OPgqqf/D491SJvkChtpy1LcTvD7EdhkRcY+ENnhjXFhg83zQuiTx+Br7yPGgz+G85G0WgkvOinCMgIZpPB/jRxFhHinDf+Sjfw9I3HWc3XRSxRiVbMCbqIj0y6Ok/NAkEVDdcNvYb5gY1qGRCNQYc0qZAW5tqxEfOrFJIefoSk6Gt82Urr5Z9vKgBPnhogywCclto0TddYXYXLMpqIV25sudd/l8pNoDm0M33kwQzjzSUtzahgzzi1NI2bDKrX+zZnzFEvFE72zVO21+UpjyHqXkF3YOo8bW2Lc9nvIG171xlzBWdREsANisJQekG24j6n17OIgHM5aQLSPuTdhxXjZ5ncLZ+IO/4Y/djY+fxkvcSLPmWDyxf3tgAig9mj0HtMRfV0cknZ4HEP7z340Vl5opouuDQvBfc+zHtiVQXuQnz7+qeSnwJ/ScE8oLw1ZKQkbxhyK
 YaapLuM4
 AaXG/xjsxJm/2S3ja9Kw7tturaIeS6tz9U2E76rgG6FCiH1uJMpXB/PwNq9TJ1iPLjA9wqbiquM+J2ZcY6J41t+biGWxIbSSzyjVV3ZKOKOagxJcRY9zJUqXFYELTFds0YW7Oz1AxSGEWcSHiaXyixt8YhR8/yntqk86yAjxI5yz6kDTfgsFsvSaLTKTSKAbICeAVY2vHFrsCp9Imj/gaH6jRButgqxjgf3ukd5maHXg/lpGZOheolZfnBwfcraS6zokFDTc9Qr6m6sA03zBgJqiiEZg/uyMduoaVip+K2Hc3g2rzr+6f4oLKTYTTTzGx21vfbjcoQtMOZGbHP9IgwgPehHRtUVhduXzseSKRXVCIl9SK1AEMSx5XpedYmFCCcBw3dSxkSFgIJYK/kI3Cb29V6qcQAhG8qrINrjwnSSJRN9z1zMjPprslVO4KDoKZa/8EJ6WOO6E7rNl+1LPR4dybH18dJ6QZARtBtqRJ4mAqd6Cu58BfRiG1on3OB/hwRuSf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-17 01:36, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <luca.boccassi@gmail.com>
> 
> Userspace when requesting a session via the ioctl specifies a name and
> gets a FD, but then there is no ioctl to go back the other way and get
> the name given a LUO session FD. This is problematic especially when
> there is a userspace orchestrator that wants to check what FDs it is
> handling for clients without having to do manual string scraping of
> procfs, or without procfs at all.
> 
> Add a ioctl to simply get the name from an FD.
> 
> Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> ---
> This was requested by Lennart and Christian when discussing integration
> with systemd for LUO management.
> 
> v2: apply one fix from bot review about cleanup on error path:
>     https://sashiko.dev/#/patchset/20260415184536.1155220-1-luca.boccassi%40gmail.com
>     the other comments are invalid: luo is not a kmod, and the write hooks are not set up

Please split into two patches, and also CC to kernel-linux.
> 
>  include/uapi/linux/liveupdate.h               | 19 +++++
>  kernel/liveupdate/luo_session.c               | 13 ++++
>  .../testing/selftests/liveupdate/liveupdate.c | 71 +++++++++++++++++++
>  3 files changed, 103 insertions(+)
> 
> diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
> index 30bc66ee9436a..41dc44d239dde 100644
> --- a/include/uapi/linux/liveupdate.h
> +++ b/include/uapi/linux/liveupdate.h
> @@ -59,6 +59,7 @@ enum {
>  	LIVEUPDATE_CMD_SESSION_PRESERVE_FD = LIVEUPDATE_CMD_SESSION_BASE,
>  	LIVEUPDATE_CMD_SESSION_RETRIEVE_FD = 0x41,
>  	LIVEUPDATE_CMD_SESSION_FINISH = 0x42,
> +	LIVEUPDATE_CMD_SESSION_GET_NAME = 0x43,
>  };
>  
>  /**
> @@ -213,4 +214,22 @@ struct liveupdate_session_finish {
>  #define LIVEUPDATE_SESSION_FINISH					\
>  	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_FINISH)
>  
> +/**
> + * struct liveupdate_session_get_name - ioctl(LIVEUPDATE_SESSION_GET_NAME)
> + * @size:  Input; sizeof(struct liveupdate_session_get_name)
> + * @name:  Output; A null-terminated string with the full session name.
> + *
> + * Retrieves the full name of the session associated with this file descriptor.
> + * This is useful because the kernel may truncate the name shown in /proc.
> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +struct liveupdate_session_get_name {
> +	__u32		size;
> +	__u8		name[LIVEUPDATE_SESSION_NAME_LENGTH];

Add __u32  reserved;

Thanks,
Pasha


> +};
> +
> +#define LIVEUPDATE_SESSION_GET_NAME					\
> +	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_GET_NAME)
> +
>  #endif /* _UAPI_LIVEUPDATE_H */
> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
> index 25ae704d77873..af9e498206d24 100644
> --- a/kernel/liveupdate/luo_session.c
> +++ b/kernel/liveupdate/luo_session.c
> @@ -289,10 +289,21 @@ static int luo_session_finish(struct luo_session *session,
>  	return luo_ucmd_respond(ucmd, sizeof(*argp));
>  }
>  
> +static int luo_session_get_name(struct luo_session *session,
> +				struct luo_ucmd *ucmd)
> +{
> +	struct liveupdate_session_get_name *argp = ucmd->cmd;
> +
> +	strscpy((char *)argp->name, session->name, sizeof(argp->name));
> +
> +	return luo_ucmd_respond(ucmd, sizeof(*argp));
> +}
> +
>  union ucmd_buffer {
>  	struct liveupdate_session_finish finish;
>  	struct liveupdate_session_preserve_fd preserve;
>  	struct liveupdate_session_retrieve_fd retrieve;
> +	struct liveupdate_session_get_name get_name;
>  };
>  
>  struct luo_ioctl_op {
> @@ -319,6 +330,8 @@ static const struct luo_ioctl_op luo_session_ioctl_ops[] = {
>  		 struct liveupdate_session_preserve_fd, token),
>  	IOCTL_OP(LIVEUPDATE_SESSION_RETRIEVE_FD, luo_session_retrieve_fd,
>  		 struct liveupdate_session_retrieve_fd, token),
> +	IOCTL_OP(LIVEUPDATE_SESSION_GET_NAME, luo_session_get_name,
> +		 struct liveupdate_session_get_name, name),
>  };
>  
>  static long luo_session_ioctl(struct file *filep, unsigned int cmd,
> diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
> index c2878e3d5ef90..bdc1cedc4f944 100644
> --- a/tools/testing/selftests/liveupdate/liveupdate.c
> +++ b/tools/testing/selftests/liveupdate/liveupdate.c
> @@ -102,6 +102,22 @@ static int create_session(int lu_fd, const char *name)
>  	return args.fd;
>  }
>  
> +/* Helper function to get a session name via ioctl. */
> +static int get_session_name(int session_fd, char *name, size_t name_len)
> +{
> +	struct liveupdate_session_get_name args = {};
> +
> +	args.size = sizeof(args);
> +
> +	if (ioctl(session_fd, LIVEUPDATE_SESSION_GET_NAME, &args))
> +		return -errno;
> +
> +	strncpy(name, (char *)args.name, name_len - 1);
> +	name[name_len - 1] = '\0';
> +
> +	return 0;
> +}
> +
>  /*
>   * Test Case: Create Duplicate Session
>   *
> @@ -345,4 +361,59 @@ TEST_F(liveupdate_device, preserve_unsupported_fd)
>  	ASSERT_EQ(close(session_fd), 0);
>  }
>  
> +/*
> + * Test Case: Get Session Name
> + *
> + * Verifies that the full session name can be retrieved from a session file
> + * descriptor via ioctl.
> + */
> +TEST_F(liveupdate_device, get_session_name)
> +{
> +	char name_buf[LIVEUPDATE_SESSION_NAME_LENGTH] = {};
> +	const char *session_name = "get-name-test-session";
> +	int session_fd;
> +
> +	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
> +	if (self->fd1 < 0 && errno == ENOENT)
> +		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
> +	ASSERT_GE(self->fd1, 0);
> +
> +	session_fd = create_session(self->fd1, session_name);
> +	ASSERT_GE(session_fd, 0);
> +
> +	ASSERT_EQ(get_session_name(session_fd, name_buf, sizeof(name_buf)), 0);
> +	ASSERT_STREQ(name_buf, session_name);
> +
> +	ASSERT_EQ(close(session_fd), 0);
> +}
> +
> +/*
> + * Test Case: Get Session Name at Maximum Length
> + *
> + * Verifies that a session name using the full LIVEUPDATE_SESSION_NAME_LENGTH
> + * (minus the null terminator) can be correctly retrieved.
> + */
> +TEST_F(liveupdate_device, get_session_name_max_length)
> +{
> +	char name_buf[LIVEUPDATE_SESSION_NAME_LENGTH] = {};
> +	char long_name[LIVEUPDATE_SESSION_NAME_LENGTH];
> +	int session_fd;
> +
> +	memset(long_name, 'A', sizeof(long_name) - 1);
> +	long_name[sizeof(long_name) - 1] = '\0';
> +
> +	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
> +	if (self->fd1 < 0 && errno == ENOENT)
> +		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
> +	ASSERT_GE(self->fd1, 0);
> +
> +	session_fd = create_session(self->fd1, long_name);
> +	ASSERT_GE(session_fd, 0);
> +
> +	ASSERT_EQ(get_session_name(session_fd, name_buf, sizeof(name_buf)), 0);
> +	ASSERT_STREQ(name_buf, long_name);
> +
> +	ASSERT_EQ(close(session_fd), 0);
> +}
> +
>  TEST_HARNESS_MAIN
> -- 
> 2.47.3
> 

