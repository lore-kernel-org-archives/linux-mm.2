Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFBB8CDC18E
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 12:29:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 366FD6B0093; Tue,  6 Jan 2026 07:29:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 311D06B0095; Tue,  6 Jan 2026 07:29:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 213DB6B0096; Tue,  6 Jan 2026 07:29:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 116476B0093
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 07:29:13 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D86EC1A0443
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 12:29:12 +0000 (UTC)
X-FDA: 84301468944.24.1AFDC9C
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf14.hostedemail.com (Postfix) with ESMTP id 02318100004
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 12:29:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sOKhoy1w;
	spf=pass (imf14.hostedemail.com: domain of 3FQBdaQgKCNoF68GI6J7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3FQBdaQgKCNoF68GI6J7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767702551; a=rsa-sha256;
	cv=none;
	b=Gtn6wdwNt8IgALq3TcdpEaXiN96sAzSLfbsdGXE3/r5AbNzjhmfH2UJJ5KEVmWm6BZUgkb
	a4skXhL5fC5gUC+wnX0datl3FVll7M15mKa8qV1x0nf9DbG4Pnebo1rF2sOeIm4sGM4feR
	kgTOn5jfM/0IKjYDOMtwERE7Gfhh+uA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sOKhoy1w;
	spf=pass (imf14.hostedemail.com: domain of 3FQBdaQgKCNoF68GI6J7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3FQBdaQgKCNoF68GI6J7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767702551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/pZdwAP/wq9kuKKVzLJ5M0q6p8KUwTZW9kKk5Fbt3zQ=;
	b=p60gsRtC/Bi/dBGSLKIIVNr86rI/9DBz9GTAEQXxDDNRIU77IVke9tlIkK8he+t088J+GV
	tVLis0qFMo00uq5n+gh7UTU7qzm99NNu3wbjWuaPLfOoQ7sG/jGV+NhF0X8zvJhyIax2Vb
	rsoglHaNL0KZUPbrx3lo7o6BCLbbs7Y=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477a1e2b372so7776815e9.2
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 04:29:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767702549; x=1768307349; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/pZdwAP/wq9kuKKVzLJ5M0q6p8KUwTZW9kKk5Fbt3zQ=;
        b=sOKhoy1wJZWmbYZmkD6clMjy8v3cvkjLUSmOA9db0JmfzZtDN2bSrAcdO0T+4jHRUy
         LI2A++oE5mgCDWdL/QIwKtn/akOhyE63+OESxpNXGaTpF9I73uQiQ9wFUZ6XgqkKSO2T
         S26UG12G5K5IcO4kANrN2rqIUGAT/ENDtvlTRv7EF7UGCOT6IGkoMze/kYS5a91K+PNr
         pzxeIxSf/bSEYIo1X0+3TKiNgqFwBtxmd3TD4G0/DXzyp6rBl5pVMru6E9Ux/slKjyBN
         TLx0DtBcE/tg0JP4vTFolWH0+KoUKJM7AsHxp9FWc8TO7nza6SF4pjSusHMDwN+3W5bV
         h7ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767702549; x=1768307349;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/pZdwAP/wq9kuKKVzLJ5M0q6p8KUwTZW9kKk5Fbt3zQ=;
        b=JcE/8VOXmCbQZFcU7EzEgyua7Wb+EJV1NFACbtPVATPfLTIJJvGuvbpBm28eTXQ7px
         iGgGxNgLOkUjnaTPb/ViWb+JzrOfZi2kqfPEI0crbABbKhwD+fepgDa7XyW8M6qU6wbl
         oANGoVKm5e5pvxG8d5O4ayH3O5pOGYYKe18U/2KQf6TLX9F0mvl1Tksth7TrDaxrOvPE
         slWs9C4yh9VIumuKeztAKB38hcz49+n1InKwqaSNEghVbThy3HGnqIFeYjl+m93gZSPT
         Fdj5u0q4E6bxheXT8R698UJj85zW2d9CpcMs+MhgZNRYriUNL9G+FVbpNJpR+E+YA0oi
         jMpw==
X-Forwarded-Encrypted: i=1; AJvYcCVmKLdsGhWNPhk1AlXaRNxnoa2nTarf7J4eqkxLKdN4VI4mXRnmTBUdgXt1jedGkgDOH8UDoWXmzQ==@kvack.org
X-Gm-Message-State: AOJu0YyrL8P2CP5o0bxqkutT727OdCsbUYTKPr0kFfcL4cjNc6regqdj
	BPsudPtHM3Ehl8GD8urg5kO+lM8mHxF3GOcCRm0d70FKkCyfOURys9ilLOgsTBufjdfgnU+YxG8
	ceoKZtAuCam+/aw==
X-Google-Smtp-Source: AGHT+IGDb5uS6PkHdgGZm/vN+neaeuomXNsUF5fH4vDNKaBbgCTUgMqpCF8VtoYm6kaWCOvj+sJGU4W9OTyeoQ==
X-Received: from wmoo8-n1.prod.google.com ([2002:a05:600d:108:10b0:479:36b0:ff54])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b27:b0:475:da1a:5418 with SMTP id 5b1f17b1804b1-47d7f062feamr32360515e9.1.1767702549472;
 Tue, 06 Jan 2026 04:29:09 -0800 (PST)
Date: Tue, 06 Jan 2026 12:29:08 +0000
In-Reply-To: <20251016104409.68985-1-reddybalavignesh9979@gmail.com>
Mime-Version: 1.0
References: <20250830163949.20952-1-reddybalavignesh9979@gmail.com> <20251016104409.68985-1-reddybalavignesh9979@gmail.com>
X-Mailer: aerc 0.21.0
Message-ID: <DFHI984SEFV3.2JL88CLHNT2SO@google.com>
Subject: Re: [PATCH v3] selftests: complete kselftest include centralization
From: Brendan Jackman <jackmanb@google.com>
To: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>, <akpm@linux-foundation.org>, 
	<shuah@kernel.org>, <richard.weiyang@gmail.com>
Cc: <david.shane.hunter@gmail.com>, <khalid@kernel.org>, 
	<Liam.Howlett@oracle.com>, <davem@davemloft.net>, <david@redhat.com>, 
	<edumazet@google.com>, <gnoack@google.com>, <horms@kernel.org>, 
	<kuba@kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-kselftest@vger.kernel.org>, <linux-mm@kvack.org>, 
	<linux-security-module@vger.kernel.org>, <lorenzo.stoakes@oracle.com>, 
	<mhocko@suse.com>, <mic@digikod.net>, <ming.lei@redhat.com>, 
	<pabeni@redhat.com>, <surenb@google.com>, <vbabka@suse.cz>, 
	<linux-kernel-mentees@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 02318100004
X-Rspamd-Server: rspam04
X-Stat-Signature: mwqjorc4g81azq3g7y7m49d3idp1cfqo
X-HE-Tag: 1767702550-803191
X-HE-Meta: U2FsdGVkX18IKoit1CHn6PUPZ/CuP+LVOzoBxDjVyeZxlXUi0TpONRf5XYTUS8tNBVRprhaSBgUfldN7PZPlcodEFcjxhPQSW7KK7Ty0TpDpT23XzGNh3Y4nUxRicuVFKvuKsO4/Hz/9JspTQnKxDQOtO4vuvrmPF4653+YX4RdoOu0GDxSMCdE09BxzUHf+utd7RTWZgx5bxYDAkPUJ6s+nVGaxANpwwLxrPCWMBhbRnet+Dzuoghf90cBU0vPBzrYhjVV6n34v20FpIWEpIFB3N7j+S9KxSTSB29kJpMyfUuPKx3piLBA8K0ShkuDHWyGiC+DowF/0d6trY+rI+w7MsivUSLnKtA3GRBY6d8aDHBSDn+Mr88uj3YVYP13eAGpK/zr8vZEPOPvyRYtJZPEZBfKqr3PXq/E1LJJI+rYQ77NiXOJXEyk6qJiLRXJuMcn26nkr+cTH84FaRw45a7/F75xdXYu+z1n1IPWm9a4mhHsYIiJnjg5Jt1y8yqSWGMuPqimsL7e4gWTHWumZbuAe7I6c/nPF7Ty1zEGx4TlKLhqoBm4TIpjWrw3dK/U9zxgph544PGdvbe4txyY4iBtD7/UnyuFsd2U8L3k+eqECWn4CPuGpOmR0L88Hogaq016EWZ++Tu/AgK1RYo1rT3ZA7THRW6Bt/L4lGaiLiapYpFDTYBJeKHKg6pyrd7rOdRxNRQaixXfVppPdpJnnhMTO7+daEGahu3sbTN2wFofEWUemgccuVreiohtW4jWQJlozyDSFtXmZqBMUllyVP3miHaz6+72yxGnHF3lZ52f5iaKtbE0oqQQXEqoc/cB+zBIEool6bj2AxYBxXD3dtwue8j0su3kJwL9YaaNrERAV71besw0RhqqB0ygGuu7zjB0QBXDs9JMLsJuUMl1LdZLo+OgYJRmOQYKWHxhmXjP5BF7tKKQmW+CjzAaYtWBNnXmTihner2r3jtppfpK
 Xxxc2ZLb
 l0Ep7nRfg+kavrqNbf4pahV8jZfW2oy4FNsSVk1v6ib66uWD0hoc97QPLRC/FbpgT8Cu7gZcVxcUKPxmrexQFWq2tL5eyd5x8pXh/PwpwU9io+Gig9CgbES9cQcm0qBNdMtJnTteAo5n0Vk3dj5gnXfdQkRWfnl43VU9SrW8z6wAptHojyyzsd2o9wlxCgSYVJw1RDS35/TX1SEO9tBwNswzQSxijyWaf2rzD8IMoUyQxOBq0Bmsol3Y6txN5ag3iCTUeCFhmA2ULPyDJpozE3ka2BNIs6qI2LCePi5VGmlAjj0zuuH8usBw0Ee1IFc1Uczompeq426j65MVvANhY0Tk6rGgdNQnDiF4N0NDANDiij2UKbpJn9ZeIcETZu/WJuCNE78NesbdqjCCD7npIOg+e54Hvw0pIlwBfqUQev79yO4CBRRU8wCJBHLkd0TUlYOezoefhRvFVrgY0/8Kd0g45RCH1rHdEZA3MgREwIkBs6YJnTrjnXSneHYBksH2mAFhykZahb5we51URtpEY7y281etOJ5JfN4d7t9wFFYGXWBtk1t2o/HvvjSleq0bgKU0nJNdO27lT4254Zcrr1oJxbEWnrF5kd5mNKf0YlGI2mopMLfvDUZ+QpfFYN74d0T4WSOZifjLZwnE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Oct 16, 2025 at 10:44 AM UTC, Bala-Vignesh-Reddy wrote:
> This follow-up patch completes centralization of kselftest.h and
> ksefltest_harness.h includes in remaining seltests files, replacing all
> relative paths with a non-relative paths using shared -I include path
> in lib.mk

This seems to be breaking the x86 build for me:

=E2=9D=AF=E2=9D=AF  git checkout e6fbd1759c9ece5044d3470f30a5e2166dc9de89
=E2=9D=AF=E2=9D=AF  make -j mrproper
=E2=9D=AF=E2=9D=AF  make -sj100 defconfig
=E2=9D=AF=E2=9D=AF  make -sj100 headers
=E2=9D=AF=E2=9D=AF  make -sj100 -C tools/testing/selftests  TARGETS=3D"x86"
In file included from syscall_nt.c:17:
helpers.h:10:10: fatal error: kselftest.h: No such file or directory
   10 | #include "kselftest.h"
      |          ^~~~~~~~~~~~~
[...]
=E2=9D=AF=E2=9D=AF  git checkout HEAD^
=E2=9D=AF=E2=9D=AF  make -sj100 -C tools/testing/selftests  TARGETS=3D"x86"
[builds]

If I just revert all the changes to tools/testing/selftests/x86/, it
builds again.

