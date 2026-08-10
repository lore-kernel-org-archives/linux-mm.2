Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41C6CC5AD4E
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 05:15:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4EDE6B007B; Mon, 10 Aug 2026 01:15:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFED76B008A; Mon, 10 Aug 2026 01:15:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEE496B008C; Mon, 10 Aug 2026 01:15:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A3BBD6B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 01:15:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9F67080670
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 05:15:18 +0000 (UTC)
X-FDA: 85084196316.24.E6030F0
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf18.hostedemail.com (Postfix) with ESMTP id BE95C1C000C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 05:15:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b1QmczoV;
	spf=pass (imf18.hostedemail.com: domain of doehyunbaek@gmail.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786338916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lojSe96VaMdUFUmXIjqilXx4hSCvFlEBJrCMRkmwWdA=;
	b=s/WA7pfyDGXIax2i7xRvhiEkjNL4KB6U4dJi9XplqNxETi9i679vZGjSFsSbk1LvqX/Hb/
	Cb52y8C5pjeb9sU60NhUhpnDdvM+QY1dE/NSeQ6wjzwNg4YJ251JTs1SibIeWgxSJMNzJf
	9MEbOS3ftwrCBW0plDNBdAefTkXaL+o=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786338916;
	b=TBhniqaMtWxJeZ739710OdwxO7O/1pVILEX8PSfkdBM/FXIVEsNWgJgvPOF4uQvMJAk5ri
	9Cn5+te3A7e3YKb/e5Jocf8fXrTQ1c2t9PW5S1mSlzI+U2q3koiWYXfDtsN/NdaQMLFGK0
	q6phahDs3HiAYS+UiryHh+rYI6/QHME=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b1QmczoV;
	spf=pass (imf18.hostedemail.com: domain of doehyunbaek@gmail.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-66b0230bcc2so63873d50.3
        for <linux-mm@kvack.org>; Sun, 09 Aug 2026 22:15:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786338916; cv=none;
        d=google.com; s=arc-20260327;
        b=MjXQ4I7bMXtJvfGovmv3tSphlzFxBTQcMxHc4Vgs7eteeSB79dMxX/ggiaNZIug5ol
         +rtFUbYNiF62pSo44KY7bqh9Cw0R7iuvAW3tOMDaJG5TJIMxAytEZ4AdWc1IPge0O+bV
         l0sNx1bUM0ZxbOqrlI3NN8hR/eNEQreB8Kj5Ulv1QHM1fNVyavtl7Sn97Q/nvX0Weg7a
         KQwRNeGLe+XEYQWqu6FhT2+Sp8yrovFSCu+UOe47rI5HI7/bVGwb/+fg6AQddkK/hu+m
         O8iqyTu9i1r9N29Cm3Q2HHuNksu7zXGuayVXzVYDkQCcr7qlTr7cu23ee5dlSbfR4SV2
         b9gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=lojSe96VaMdUFUmXIjqilXx4hSCvFlEBJrCMRkmwWdA=;
        fh=LQq0fqgjrzEcIztTvhupm9mQOsjXhIlCJL3PKGa9gSc=;
        b=jyRGPgoxfqJbTzN32veT2G7hUq4nYuhHtPpQ9oHbJhBxdsd5mq4I9GxA3NLFrIMs/3
         Ocoh3BcRkHPiaaB6PnqZ2STEZhO8mvnsjDfLwFa9bw/FQhMcNgttMiJX6QI0/p+ZBAk/
         NEg0JbtivTF5cjZ+3uNTYK1VkztRGUZ/YA8n6q+yF0QL8HwP/fsfAsOS1XauEXorhgvC
         0o/9CIzlCNftnpof+YLfx5qBUarXIWwvT6J7qkMTEwsXCDvCEDpgXrcJgnWJb5HoJCJD
         yVDFg1XU4Zs/7phkiooiLhdJGoY9xM6wW0UqxkHshuYOmapMo7fPcCVBlRhecxF/Gj3b
         mX4w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786338916; x=1786943716; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lojSe96VaMdUFUmXIjqilXx4hSCvFlEBJrCMRkmwWdA=;
        b=b1QmczoV8aS0Wlbv4nkh4gILyNoeY7IMzosZ+PNL6nvYMxNJtGawdhd9IHoZ/UDnJP
         Anfy/Gjt7UPQaPM+5stUoAGXHEwyVJIoG4VUSI96DzstS+BPmwtamdyY0QDR/F1MTnBD
         8bArXNMa4vMc5qXJ8jaAlEmiPj+JCuPv95770LkJX+aAcoUdWxpBjJaCYIbf1v7NUdF3
         Rc5fH/JkOGE4p7oT3OQIYsYW7QWXTQYosFG+SG8caxelM8jVSniWTiaQVOJhjT4Ucjlb
         sXBRYAyzjUSI8NM2graUOgv7GmcjB9oXbLHtp+Wu8d0nHTlkMaBAquexJALh0vhsV52L
         hKBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786338916; x=1786943716;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=lojSe96VaMdUFUmXIjqilXx4hSCvFlEBJrCMRkmwWdA=;
        b=QPetS+4kevZn4CWlKsgbqGLz5wMfad/hJChD7rkODlNt1FXaAZnMmHseYwon4dRwLW
         UGb0M+7RQpXdLXXqmDKeEHd89XGoYZ/Tb/EP5Q9BKGM5IS91lthSeE+lavd8E3Sg2ETZ
         sozdCTQe5WXvClNQfA8fxl4bOnfayU4LS6sIkM6TrOjwJMJ7/ADF2qEXb/AFrFDJci2r
         0ixtTAcPiSz5yGH3t6hZGbqNJBsQi4PMxMbqGt995bDsTn8m5FwESVNrBCDdRX/3clWJ
         kTMPUQ9ZyQSfY0YQllBQMuLWQdg051e3JD2s8ZTX/Y4bNcTLlE3KZtb+A4KPI7ujDFc7
         r8JA==
X-Forwarded-Encrypted: i=1; AHgh+Rr0RrVBxCyHI0/ZIjdzY0C5uaNYbHF+q+RWUfdKhEj+kNcA604UchBwUYuyiuqyXh98XYTOOhVWYA==@kvack.org
X-Gm-Message-State: AOJu0YwqCRCWHYQZ7BEt+YUae9EsyUVPiFJGwU7MNc9XXqxMZ22j8Gqh
	zO1v13pXV332kHjg87KvIae9HinCM5W2ZKEZIWNXyMdcCVzOhf65MzmYRZWRPbP7O9038hCBd9p
	aW+Jy873oI577vJ0GONF1WLMDf5Qq6Ww=
X-Gm-Gg: AR+sD10IaW0uOeWEa4822qJyZpI+HjqpUEbCQ+7iF1wafehyKE6FUpn0GhsXYz47ckq
	8LNx0zu6s7m96dh2+LL59ab+y94v/EossvkSCHIPxHjPPH9m05tGOywCZMYwKZzl10VaHq0E38s
	dQCuiAN5HODlhOGPnZMXWjqxLhUD0/LlHZzCnTKdlW+X5NBly/vpPAnC8H08eo7ZznuwwvO/GyA
	JRyBDNJhL8Ik+Ib7psU2gpZsDQ1abJwIhTY3nHZtjl6/AYVWSZVAoG+U5sorf920As/9rvZ5ZQF
	AYPI0CmLEvKRrDjEeUTfsQDyP0m+od1/2AZVoMOePLdvq8g0f24wfAxYyJoWL1riUhPNt02kk3m
	l1jVnhenpvR8FjPFkJNP7Q/zqKgNtV05jaTPgaaGT9VYSvZ1mNBt+9TBu5MM44SUnHR2ysLV9j5
	etRIQEbB8VTbCUOmbKGKVlefvHsw==
X-Received: by 2002:a05:690e:4508:10b0:667:b72c:8130 with SMTP id
 956f58d0204a3-66ac5a0736emr10253593d50.2.1786338915875; Sun, 09 Aug 2026
 22:15:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260708073246.1652828-1-doehyunbaek@gmail.com>
In-Reply-To: <20260708073246.1652828-1-doehyunbaek@gmail.com>
From: Doehyun Baek <doehyunbaek@gmail.com>
Date: Mon, 10 Aug 2026 07:14:40 +0200
X-Gm-Features: AUfX_mxAJJsVuR7GIBPDeXHBzKXhSvWnLlyS9A_HrwnYDLLcej0dEo0WIDioGKg
Message-ID: <CAN-j9UpTxLzvu7EruQW+kvvxivrtOaS3FBW_8dLc9TWuvLO7nA@mail.gmail.com>
Subject: Re: [PATCH v6 0/7] docs/zh_CN: update DAMON translations
To: Alex Shi <alexs@kernel.org>, Yanteng Si <si.yanteng@linux.dev>
Cc: Dongliang Mu <dzm91@hust.edu.cn>, SJ Park <sj@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="00000000000087800d0658aa7020"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BE95C1C000C
X-Stat-Signature: zwkxb5hgky1cjgbtb44niydg5gpbrebz
X-Rspam-User: 
X-HE-Tag: 1786338916-512529
X-HE-Meta: U2FsdGVkX183HvH8qZN6p4BjfRArGFgjDwo97M1j0zbKAg1pm4xJXScidMTLerE5TTd9KEoJhFyKvP3N4WVV9FdWbhYdzoWckfMG2lNnHHtFSnbhg34LyFbH9w/q88h/Se1Wn8Djtx1NJsdU8g7Eyu27cmN69KUyhdzM+tGF452gTY7+lWE6+IFZBf6Q1MXyUwcsIGCUc9Emq3HILR63MG42HdfSMCyv6n26dUvjgfIc07upba/MI5ExkxYjjk157QNMcPtAnShaQvitppf9WcWT78mGZeOHNhs9ZiTg1+5JH1av2N2VZWGDSgZQ48byVDq+y7wuFQEzvelSNzuEEuHQZeaiH678gk1V+FBMPWsOh83SS1RLji/UUMKXjA1xxPwthOEmz4K0HS2AXXhjidMyzK3A8u59MAyworzMsju7KRzgvCIHi0eXqTIpcNs0rPr1RATXvOcbtPlI18b3JY6Nal/Z14SVj2KCX+IxuR+XpVURRbvqLin+2LSde2qOa5CXQf338FRz2CkMOYTSkyYN7QAKsOct9nifzynMIMAfaXiLopNJz7O5DGp7HtLrWN7MeHsYMDUTrG8+nqLB8zvN8wy0DwF62SnOOIi2xoTD/bYWbdfAIMmRQif6JTRx3tyR5/lyXDBytG4IU2ejQnjvewMc285Ri4vMgYNoxZHraUaO+yUnDP7UtUyCXjJ9K8WBK4NbbPahde71ImsqNWnGCFI/1qrwYDxM769QYnSfC71zz2SYnxq/imQgXEhloZZzezBI82e2SHKcQF/z1mI98bKf5g68qU9wr8GviXyzjIN8pZjjLvgoZ6ztBXeViuZQ9KKj1qF5PBUC/Vn7OVX4uSBDr56XeHQXZnfKQuFY99IP849G/9zZU16dkUUYWu1dOCjQytTblMdIXPK3Fijx6U9mtFcrASVURIPmtgz8Fw5TBdgQ2Vh3sYLkIcKzN3d7Hc7IVIR/1Cczfmi
 gnxkZskY
 IZj/kEinZF0BWX8QxvXSwjLWbuUvZIwTslRkhJmAZQgnGvxKRXS5/kRP+O7RzOYINarbqcx6C9Qr+OQSiVtKg9/sidagLlLikNIBad4dKPEtUYI4S4qqjaU0hzAHEW1TozNIQLwxLg/ceAybKl7vq7qUWtTapVPg6EzfEM+BQe6Wgx09W/di4DF21qcX04NwsMb8EUQ9FiPBf4C9nuCwriUkmD8xukabLYWi5qDxsJsrr8wvnZi39R1ZSjhzCfArD70QRhzmZ7OZ1ga1tEoczyLM3p0CqHdGx+06jyZuvyFT/+dAmwc7Flyp74Zm4D/ex8blF8BRhZ93oWJut6KGBvhPkDyF92agfKoS6zVxA61V1z+/MaEyxypPmpQochweFTa3RRCv5s+byYXeaZN/W7bB1QC/STUE9kPNKDjIoGqVygcbFhsu+z9KcEOrp0dwFEKo8SbFp3b0BhyJkFls9O3auh+zPYDoWalUjGMBxKb9ht5s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000087800d0658aa7020
Content-Type: text/plain; charset="UTF-8"

Hi all,

A gentle ping on this series. It is still awaiting review.

If the current scope is too broad, I can split the series or reduce its
scope.
Conversely, I can expand it to cover additional DAMON documentation if that
would be preferable.

Please let me know how you would like me to proceed.

Thanks,
Doehyun

--00000000000087800d0658aa7020
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi all,<br><br>A gentle ping on this series. It is still a=
waiting review.<br><br>If the current scope is too broad, I can split the s=
eries or reduce its scope.<br>Conversely, I can expand it to cover addition=
al DAMON documentation if that would be preferable.<br><br>Please let me kn=
ow how you would like me to proceed.<br><br>Thanks, =C2=A0<br>Doehyun</div>

--00000000000087800d0658aa7020--

