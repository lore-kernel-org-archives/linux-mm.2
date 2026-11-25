Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8A2D606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 08:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hhmt6zbG
Received: by kanga.kvack.org (Postfix)
	id EC5AC6B0941; Wed, 25 Nov 2026 03:50:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E75CB6B0943; Wed, 25 Nov 2026 03:50:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D65A96B0944; Wed, 25 Nov 2026 03:50:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AFA316B0941
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 03:50:50 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2D22AC0E42
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:50:50 +0000 (UTC)
X-FDA: 85473021060.24.ADE8C92
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8EB6D40005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:50:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hhmt6zbG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795596648;
	b=2m3WKVx6B2WmCb2XdjZQ8IMFrPHGSD4jmh4kitsrRYp4oMNzPClLYXuResBP/2hfp7bAUw
	v5YcKpMOVEzswALOHog29rcXX15x9Zg+Q+y827hrNDhm/WQGoTWODuZi4ekk6v/4d5Rdx3
	UU+iu48CWyL3YLmRo+IM8Wpv+3gMH1I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795596648;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aop8Hm9coxwBkbW5nc/zazX+lOXSS7NOm8lx3A0fuCc=;
	b=6c0qArIopzn79T1qF0Ih/oTWHfglWx8HWtjAs60rH5/ArMOBsgaTrcp0JLXPv3DP3hrllq
	/fFdR5Sc+jY/h/oY6diLH2s2C9gS/C2I2HK5vkeva2ReB2s6uJNrxFK3vx0fUqSHqH+5sg
	Y4Nctif9hEUI0qlYhn6iGAJSA9HL46g=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hhmt6zbG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D8E4624FC;
	Wed, 25 Nov 2026 08:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4091F000C0;
	Wed, 25 Nov 2026 08:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795596647;
	bh=aop8Hm9coxwBkbW5nc/zazX+lOXSS7NOm8lx3A0fuCc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Hhmt6zbGLpFrHsWJOXEaH70BVtI1UVogbg3D89kLhq8qn2lo34eMwZSW8L2iqIJ8T
	 ALtKSQjWPyVI0FKFQrxU/3/DMjP7OniEIZcIClch4jew5zf/kTNGNo4dzQEboZw03R
	 SNnAaiKtompZYlrXS6L/TbUQIBOHXghH8DU7klroStPYUJevncG+QCiXe0DUVWdTZ6
	 0gXgQf5AFYneDTbp9l3WtZdoZk4VAb6D1JRvgL3807yTQm8IMyxIxLeBxLziViEP6M
	 9f0bwqMu60IGLUfXtS10FcWPXINgQrA5XEZsWgvFR1kECS0VvNiO64hb+Uv0yCqny0
	 eGFfclbt1KWMg==
Message-ID: <sashiko-outbox-232945@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] exec: annotate lockless tsk->comm update with
 data_race()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xiange Pi" <xiange.pi@intel.com>, "Kees Cook" <kees@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>
Cc: "Jan Kara" <jack@suse.cz>, linux-mm@kvack.org
In-Reply-To: <20261124083848.1430527-1-xiange.pi@intel.com>
References: <20261124083848.1430527-1-xiange.pi@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 08:50:46 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: zpp4gwc8zfefanjqsq7q6m3m45sgow8s
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8EB6D40005
X-Rspam-User:
X-HE-Tag: 1795596648-494791
X-HE-Meta: U2FsdGVkX1+Q8U8zPwTfP07dzyBWMZyFvwd6CPp6oauJrGBiJUD4HUEtLmS2xExsexMqjkpGxV0ADv1MNjB4tfIVHWWGnDUfYNdMlHeYJ3l5lv3QOVgvAMK7xJYsXo7sG/6To6SFaBsoU3L3aRNihU1KbdF2AgEVKiJFd0AvbHLGzNx2GI7IOFhCYOYpsFjruCQO/tO5gEvqWiG2fDSUVrowCncuaPIQkaXXz7XWnmd0Qx6OIx/KRfSfC+0HQcupOtmavQ/CZA6Ru7IH8PcszaGad0FWt6nRfmajMJOWfFGLdEi6Iz1jz/0z0nG8vAJzFBsgIChzuMMLfBEI0AwzOaf4Xi6O2QQBwBdcPxbZ4N+5u1tr7dp3QXkhbk56h5DlC0JCY1fPzJnnhlRk6gmxCQjSB3xiEpuvUWPtzvQOD9xRswEzre4nsGua5rmuO0TOj+W+MjCACECOnn7qnyxBRR1AjZAj86OIevA3i4ZScFD+o0on2CWLl8JgT96+nL1S/dyBZe+SN093roR6xZ6HDUzCUnpJCHplRkiC4R/VMH6olwx9zJZSQFgHPwaCfOOwNZkeahZhKrUY5KbptApGgn+sEdVCH/yfeQn128ijgi7R9lTKmH6Tuf4+FwUzapMbtxP0RCB9iJ2P8ZkO2QeWCSoXObf0fkk8DrOZIAnzAl0klXXObyMvWYJqXDWJ1I0Q0/S9D0cf2UIx6ZA16b1RRrKC1qs8hxxusb8JdetS9g3z9LMYQPrp/z2Dv8ghpjojoUR7XeRWJWeCje8RhAdZACflmj7unVPbi6G0kPpgUyvqqqemtUwMvGSPunxOq8dWa/kIk8ZKe4D31uE+Ov2TgavQtXp9svQ0Qzzenio57TcjBgPGRpNYHXeOS/SNGBOBVsRdlYdsSF2Pj9+hjERYy9NYz1+NKGmpZwSSdHg76TaoF5eCFdyzhwH/hw2nr7LaXIkbULlxHyrEoSfSDuX
 9w6yN8AN
 qK21ElL7TwSZ5H1cD9L6bvCezgj+P01RkjZG/VuHcc/xAUF5mhtQqw/rHy1XDvztrNHCiGryOZ1WapQI3nilagG6i1YGWHUtOgbdR+30RJ+NYkMMuCDyFX1M2Nr4BBBL75U0LCYKJxel9CIwxNQ+HdS5U/fFJw6DTIK4hvjciS9DjjX7mEVEwVyIf1plyj9le9JM8Ic9F+Pr5WniTQt/XKZA2/pJxc3ihqnpaFoNHgzKNTbYkOkRet8htnWRplLPZqnJVCBxIdQb8Tfa8QuDxq8KB60xlCJDqBxGWaoxjledzMFwtS40yvqA/gHuDEMFZWkGDRamd11G/ukM+4hiJDTtzLMV3nQkHaeiK+2iZzD5mGP6QrgWUHrTe4v2MGleJ/gBQGLTR9JtMz+C7ZnRHyDaXUH7YIJJeE5qkUq1IMXzXhNWTEt/8GLGjCTV/29boiaCz+YomujJPfJ4iH1jGdYEjIlKbq5F5WWBVvKb3okaagr6CHilXi8tiyMl2Vi+Wn8/LQITz2IO8E7LLUNnY0KISVEw6EKkU4bTMWNYh1CVUSLwwMwhkgLRyCzpIsE4ke5GZahvK1HU4tSbQUMyCb+yIAn9zvgLTAJH4oBlLktRnqYs0gJhdG+lH2qEYor6fEwzxOPZVOHm/nkYPhIjhldu8ZUyq8nDfTI3Hz5/wGVWbJgUU5uajfSIk6QYZct1lM7AUVznqjWBC9Mc/MP1Gt2bz5BsoE8o+ZDOyfpDPtq0DWURcKBTRQErHsGeA/h+06prVSqGnl/+8rkPn66A3m6nGKM1mr5pOGhvQ6wDG1Fv9nXv8SL0F2yG0gZJwcPsfsuzILwm5W7S+X3BquPn35vBrNtIsfk4vOyJ/XTByr2Zrle8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] exec: data_race() in __set_task_comm() still triggers KCSAN on
  readers
--

commit a04284363b9bce90bc6367728fc880cc5b2fd84a
Author: Xiange Pi <xiange.pi@intel.com>

exec: annotate lockless tsk->comm update with data_race()

This commit wraps the memcpy() and memset() calls in __set_task_comm()
with data_race() to suppress KCSAN warnings on lockless updates to
tsk->comm.

> diff --git a/fs/exec.c b/fs/exec.c
> index 8d2b14e1d455c..9a47cb27ce5d0 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1100,8 +1100,16 @@ void __set_task_comm(struct task_struct *tsk, cons=
t char *buf, bool exec)
>  	size_t len =3D strnlen(buf, sizeof(tsk->comm) - 1);
> =20
>  	trace_task_rename(tsk, buf);
> -	memcpy(tsk->comm, buf, len);
> -	memset(&tsk->comm[len], 0, sizeof(tsk->comm) - len);
> +	/*
> +	 * tsk->comm is read locklessly by many users (e.g. tracepoints,
> +	 * printk). comm[TASK_COMM_LEN - 1] is never written with a non-NUL
> +	 * byte, so concurrent readers see a bounded, NUL-terminated string;
> +	 * at worst a mix of the old and new name. Mark the update as
> +	 * intentionally racy.
> +	 */
> +	data_race(memcpy(tsk->comm, buf, len));
> +	/* Same as above: lockless readers tolerate a partially updated comm. */
> +	data_race(memset(&tsk->comm[len], 0, sizeof(tsk->comm) - len));

[Severity: Low]
Does annotating only the writer in __set_task_comm() actually suppress
KCSAN reports for unannotated lockless readers of tsk->comm?

data_race() disables KCSAN only on the writer thread via
__kcsan_disable_current().  Unannotated readers such as strlen() in
tracepoints or get_task_comm() still set up read watchpoints on tsk->comm
in kcsan_setup_watchpoint().  When a concurrent __set_task_comm() modifies
a watched byte to a different value, kcsan_found_watchpoint() on the
writer returns early without consuming the watchpoint, and the reader then
reports an unknown-origin data race under the default
CONFIG_KCSAN_REPORT_RACE_UNKNOWN_ORIGIN=3Dy:

kernel/kcsan/core.c:kcsan_found_watchpoint() {
	if (!kcsan_is_enabled(ctx))
		return;
	...
	/*
	 * If the other thread does not want to ignore the access, and there was
	 * a value change as a result of this thread's operation, we will still
	 * generate a report of unknown origin.
	 *
	 * Use CONFIG_KCSAN_REPORT_RACE_UNKNOWN_ORIGIN=3Dn to filter.
	 */
}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124083848.1430=
527-1-xiange.pi@intel.com?part=3D1

