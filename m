Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EFC5CAC59A
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 03:23:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2AD28E000A; Sun, 21 Sep 2025 23:23:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDB458E0001; Sun, 21 Sep 2025 23:23:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC9FC8E000A; Sun, 21 Sep 2025 23:23:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B8CDF8E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 23:23:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5F14AC0472
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 03:23:17 +0000 (UTC)
X-FDA: 83915440434.30.37EF6B1
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8AD9740002
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 03:23:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Fy0OpYvX;
	spf=pass (imf27.hostedemail.com: domain of hughd@google.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758511395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3FlwsER74cYqV32Cx96ZjhaczFHdoR+YcDNoqEmBa/E=;
	b=jBVABBsn3/eLaelUEoweX7vUPgKSDdKlMJdrBgxiQ+jSTMfY1ma6DVkItlreOlwJmFfPQQ
	YGkAjmp7olhzC+ceX6pMTsy6pRQY6xA7mAApl4wD/WaJ4MhcsjA4RrwHS4JR9EfhJIUUAu
	ttWmRul/caFwJF6uIUvgD5hkbf1puqI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Fy0OpYvX;
	spf=pass (imf27.hostedemail.com: domain of hughd@google.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758511395; a=rsa-sha256;
	cv=none;
	b=iSIchv5WhtOCPExp5DBm9heR5lyWYBcxEL4TOMms0+NEH8jNpj4HiDAIDCkIgGCik0Cens
	uPAaJcdF3vYWW+FJysHL2w1HVRcliUTwCuZK1xOdIfSSgdkpWzB/xv2qBl5UauWyp21L5x
	zILZG+cNBK48gbf0ADpQ2UDJ0OSnlzg=
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-71d605c6501so27154857b3.3
        for <linux-mm@kvack.org>; Sun, 21 Sep 2025 20:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758511394; x=1759116194; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3FlwsER74cYqV32Cx96ZjhaczFHdoR+YcDNoqEmBa/E=;
        b=Fy0OpYvXUI7DAb9UhxAX1yYrdmrfiFhl5me+M6N4rAoMnDEJMukE/KPpIzxucPJm5m
         DtMKAyyAQ13OML8X7Dn1TW5/W1tikIfblWhJkOhz3U1LNHKrHUUixfrhDGiUqPWKHeOl
         3Q2DqrLCwOLzcruLJpgFlCfp3pJ52I+GitWhB/tf4VamUSrq8d0d1aHCNpP8MgMniPpj
         5NUlTWwqveEBr7PRvExOinZmE+RMRmb1rZ/pUHjHewCO0T9xbdMLGdo51365Ftl9zJDB
         GLg/uCX30c4Dn2ksV9kZIzCADl31JgwAhshnl8uI1lGRI87SOR37QpZjs6YdBCJPV/wA
         E8fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758511394; x=1759116194;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3FlwsER74cYqV32Cx96ZjhaczFHdoR+YcDNoqEmBa/E=;
        b=tL5jnePFQbrD3PzJwkNbkRpErHFM2bE6Fg6ddRfYzltWO3NZ9qmN/zupQrdO/l+m7j
         LhxIB76swsdx+oGUY8tkBnOM+k3VB48xa9f38iavNxTC9RlxSU07PsS+B62MDRSBgGTU
         7IkfDYFuEUDhjN86WxgLzoXGAbEnxsGHyhmDW14y3hCaHGofKh3p4ucgrgmQo3oPpGck
         xiEoHCVt63dyVwDd6sJLz1cUZ21bnnwL1pdQB5YVY6BCU+6Eah5twirqQytg2iKSqqt/
         0mhmW+b75n0zSdXSS2Kfh5ZNi2ad1Ie0dcA1XgQi5on+Nd5mrp81dwUVLtV5PARd76Iu
         hjpQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGIjL+/7y801bj8mvu8y9Bjymckwa0Yh1Db1On70WDACWZLFBNhjRZ5HCPu/fwniNmmx/h5LyOCA==@kvack.org
X-Gm-Message-State: AOJu0Yw9ChIYIR81sWnq/1tYyuNBPP/SRHlzuYQElyE0BgrfpET+ykvU
	ZRqKL4LWaO8ypqOf1byI9mRyDv0ZF51tuhesPQU1aFmxFcqZVcUinoVVZNpDi+Jq8A==
X-Gm-Gg: ASbGnctxdA4FjEWWEfZFW/BKwvvkg4hH4U8zITHJFyHcbfrNLkhofIaQEHkEJDJ1aYc
	T+A6Udm19pzKvo1X6IJaHFWvT3Eb7e8iPZSp87OmnxZzXS+BnBaDjXwRblmwGiH3Di5GajRYDUt
	4cGNUWDvxjhquW8RRQ2fv/WwUDGsVOeQtDbj3ODbKMMW4M929oeKNWV0r0JfB5V9gcHPwYzan1g
	1TEr4MaJjiReRdstW3KZ4bIEugPcFIruBjk3fQC2NxjJiZBdXvoD9KZEmZ70q2ZFCBVUkmP8p7B
	TZ2VcTeP9OctVChcbAvKAgV0cUKQRvGYT12S89hQHE5sQu9NNly4HD2ozEGAxFMG3RVcH0yp5HO
	qsn3BRkIvSjB9sNf8YwH7UhX/tf4U1vl4Aw3N8QmXbyQZQ2bpKsjVI7M1fpiQWexstDjJ/IbtZW
	ikv+2UpMY=
X-Google-Smtp-Source: AGHT+IHN/ys8gHLrLIlg7s+DKUjMBq+p6tvCq2COmIp5lBOsMogpQZbYlGnq/VUVqHpKXGstFcOJKQ==
X-Received: by 2002:a05:690c:5c02:b0:722:6791:c5b2 with SMTP id 00721157ae682-73d3237b3bamr95872717b3.12.1758511394225;
        Sun, 21 Sep 2025 20:23:14 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-633bcce8a3esm3798775d50.6.2025.09.21.20.23.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Sep 2025 20:23:12 -0700 (PDT)
Date: Sun, 21 Sep 2025 20:23:01 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Paul Moore <paul@paul-moore.com>
cc: =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
    Hugh Dickins <hughd@google.com>, James Morris <jmorris@namei.org>, 
    Stephen Smalley <stephen.smalley.work@gmail.com>, 
    Jeff Vander Stoep <jeffv@google.com>, Nick Kralevich <nnk@google.com>, 
    Jeff Xu <jeffxu@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Isaac Manjarres <isaacmanjarres@google.com>, linux-kernel@vger.kernel.org, 
    linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
    linux-mm@kvack.org
Subject: Re: [PATCH v3] memfd,selinux: call
 security_inode_init_security_anon
In-Reply-To: <CAHC9VhSbWJ-8tj5BxSTxznGO8zraKRSE31a+tqdfMHB53ef-MQ@mail.gmail.com>
Message-ID: <a3f1a528-c2dc-74a6-b671-d8b2ccf23183@google.com>
References: <20250918020434.1612137-1-tweek@google.com> <CAHC9VhSbWJ-8tj5BxSTxznGO8zraKRSE31a+tqdfMHB53ef-MQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463770367-1534621582-1758511392=:2554"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8AD9740002
X-Stat-Signature: znm347c53ihomohie8jgazxkir44ydhh
X-HE-Tag: 1758511395-859521
X-HE-Meta: U2FsdGVkX19wgoDZZ0Y74M3pUzOy739AfP/jiz7VpkhAJ+ZXJIMKEZ+cgalWO7IJ+WyZ4qEUgjYfBgqyfnWlnDBFeMm9/qPzOmdF9T9i25v8NpKyGIdxHg8L2KKK6mp55nOMqEHjvdnUUEhExKhcR9U9WrpL56RFNWkGMDft3rux+nqu38uTXGVM2UpP1nKQWJe1npQfveS5kIIAlq/aJrnxHG8psH2z444+25H6P8vAFFUQaECBe9jgr2/8kFdAnUSeUtHfjL6v9jnPGZNsK+ZqJqhV79AVVAVNqeEUbWb+r/9FYtnKVQU+u97Spsams7MZpPyCIUwgolybxD1JCH4vE2LpNsKLQ5Fd1UeJV3eUsQ7Et+Kn+mDzSlTPhHJ5PJgbVqxOM5J3PRrbxTlrLkHczTdcCJPfGc6JKvSm2znD8W0vhmVlwp+23q2+uKorAWI7CkVWcS8oDRYyUc/jW6dsUexGxZpZFehFi/JOgh4TO4OAKs8gB60amtFJ5Y40sGuBIcM12f7Qlpaw+CFEtYYu3fFBqEHpWXbB9+dW3wpV9IICY8Ap9XKRJ66nC+JGZ6acxzEHdtQgXWERv6jfVQZJVPRkABB96FgIGPZrdDE2LM1ek/B3nNi4iB4sIuqzFccm+vxKbCm5RFuDvgAbyxezJaTIZxEufcjNjjdqdMSoJ6qNxlYWMqO6vBg3fwOvMWutFtjqxo9YXyiGZk1YKZoVz3P2iZXWYhmCE5IcgroZKcBVwTq9l3ib2zm5QaeFn1mNeH9cl8BroCLxxYxI9NTYOcI8jWaIlnmP5+cEV/X+2W29gtiI0MPHQFc6BHhVGZkKg+dNG5GkfYnwerNtUzmZ3Qzp3vj2r8CQKBG9Th36M6gT3bo3KUd4U+xl5jY+6n9ZI7+hUDG/4BmN00cHpwOyytrXeqsbQP08R3Mewi3UY6ObwIkqv2GECG6QKFOMKoPURy6Glat4L/JlJbZ
 ZEEKwNRv
 XScOwJhqY3PHDhg9LVojFADh3r6IDMnUUG04NbqGjfpdDNhSQ84aovaXOCjdIElLEioiyWcy9EXVwLg8XsayJ16b4R38K4Hbq7hvylMDT7tMmG/Sgo0bMUKY1VNU8bJ9jaxVP8aQuThXGq4bpeRCp3Ohh3WwhU8oQ7sNHFTU+2AEYtp7YjpgKxznQYMIjO30I16LclE9HTJP4NhPTAAFP2YNPYq+RspaDiHpuIB4JkGSNPE8+4t9NUbMN+EpZQ7XKxwmZP8fd9mGPXVlh72ODSGumTo+PEX8IDvnp+OxIHZzDuBZeS52lyV6YaPsZhMSYOPUJQi3rFQfRYtjAHMu1D4SqtRF5RZZ28GjeJ19itq60hZinYu+8NJYOJGEssmHNqrUBuqm9ZiGWzVB0CAhEOl5CD30Jr8Mpg5UnReZDyayyWH1Ii7ayCIMJioqxrXs908J1yVc02LEaZ5X38AYH6FcWtWg1y9htY1Cevo7SgYI7tR5QUn0UuPlueBCzKSOzIZTut9Cv9NXtnIyKUDH30BySmWvfm2qO1pqENOMGtfk9RrM4aI1cFh3733eTkQ9JQ6wm+r+eQ4ZGuSKO4fnZPYlbUACeEaDS1PJen33sgsG6434c/v6qqs2FSQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463770367-1534621582-1758511392=:2554
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sun, 21 Sep 2025, Paul Moore wrote:
> On Wed, Sep 17, 2025 at 10:04=E2=80=AFPM Thi=C3=A9baud Weksteen <tweek@go=
ogle.com> wrote:
> >
> > Prior to this change, no security hooks were called at the creation of =
a
> > memfd file. It means that, for SELinux as an example, it will receive
> > the default type of the filesystem that backs the in-memory inode. In
> > most cases, that would be tmpfs, but if MFD_HUGETLB is passed, it will
> > be hugetlbfs. Both can be considered implementation details of memfd.
> >
> > It also means that it is not possible to differentiate between a file
> > coming from memfd_create and a file coming from a standard tmpfs mount
> > point.
> >
> > Additionally, no permission is validated at creation, which differs fro=
m
> > the similar memfd_secret syscall.
> >
> > Call security_inode_init_security_anon during creation. This ensures
> > that the file is setup similarly to other anonymous inodes. On SELinux,
> > it means that the file will receive the security context of its task.
> >
> > The ability to limit fexecve on memfd has been of interest to avoid
> > potential pitfalls where /proc/self/exe or similar would be executed
> > [1][2]. Reuse the "execute_no_trans" and "entrypoint" access vectors,
> > similarly to the file class. These access vectors may not make sense fo=
r
> > the existing "anon_inode" class. Therefore, define and assign a new
> > class "memfd_file" to support such access vectors.
> >
> > Guard these changes behind a new policy capability named "memfd_class".
> >
> > [1] https://crbug.com/1305267
> > [2] https://lore.kernel.org/lkml/20221215001205.51969-1-jeffxu@google.c=
om/
> >
> > Signed-off-by: Thi=C3=A9baud Weksteen <tweek@google.com>
> > ---
> > Changes since v2:
> > - Add WARN_ON when using unexpected class. Return -EACCES instead
> >   of -EPERM
> > - Remove extra new line
> > - Rebase on selinux/dev
> >
> > Changes since v1:
> > - Move test of class earlier in selinux_bprm_creds_for_exec
> > - Remove duplicate call to security_transition_sid
> >
> > Changes since RFC:
> > - Remove enum argument, simply compare the anon inode name
> > - Introduce a policy capability for compatility
> > - Add validation of class in selinux_bprm_creds_for_exec
> >  include/linux/memfd.h                      |  2 ++
> >  mm/memfd.c                                 | 14 ++++++++++--
> >  security/selinux/hooks.c                   | 26 +++++++++++++++++-----
> >  security/selinux/include/classmap.h        |  2 ++
> >  security/selinux/include/policycap.h       |  1 +
> >  security/selinux/include/policycap_names.h |  1 +
> >  security/selinux/include/security.h        |  5 +++++
> >  7 files changed, 44 insertions(+), 7 deletions(-)
>=20
> Thanks Thi=C3=A9baud, I'm going to merge this into selinux/dev-staging no=
w
> with the plan to move it over to selinux/dev after the upcoming merge
> window closes.
>=20
> Hugh, since the changes between this patch and the v2 you ACK'd are
> minimal and limited to the SELinux error handling code (see diff
> below), I'm going to carry over your ACK, but if you have any concerns
> or objections please let us know.

Sure, please do carry over my ACK - thanks.

Hugh
---1463770367-1534621582-1758511392=:2554--

