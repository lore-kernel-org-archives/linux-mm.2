Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38322606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 05:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iR93k3TD
Received: by kanga.kvack.org (Postfix)
	id DBFA86B05B2; Fri, 30 Oct 2026 01:55:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D582E6B05B4; Fri, 30 Oct 2026 01:55:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6E486B05B5; Fri, 30 Oct 2026 01:55:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ACB2C6B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 01:55:55 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8A78D80547
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 05:55:53 +0000 (UTC)
X-FDA: 85378231386.26.4560DAF
Received: from mta0.migadu.com (out-5.mta0.migadu.com [91.218.175.5])
	by imf15.hostedemail.com (Postfix) with ESMTP id E1981A0003
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 05:55:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iR93k3TD;
	spf=pass (imf15.hostedemail.com: domain of liu.yun@linux.dev designates 91.218.175.5 as permitted sender) smtp.mailfrom=liu.yun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793339751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=usMfs5mXhTl34QarCArzKWSJBy4o70hsSSCeVu1OsrA=;
	b=NxB+shfWP0bRje3A+dZwI2MVF0sNnM2hM57RpEJsDJEH8pcDpe0P1wSrLF8+fqU7Jw4ZXg
	0LjvtzNj2N8UmveiR6WTJYrkkCIAtGnfa0NpbkO/cvzBfge9bUX/uz7tDBA+xekKgj+de8
	Qh7IqB2wwu+stF4wcBJFwGO2w5ADp/w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793339751;
	b=rdpTUYW/1s3Rv/R0kOukXJ7F06uMoV/4B6rMtGKn+JQ62Q1gZWKlBLfS2CJSfqyFQLnSmM
	y7dgEQRftldSS1zYwtHeGCvWjYa4y6iTonyxkqcSdkiqwg4sUSR1DhaSZ66Ccju+gAOGaS
	0o9FYgD2uOFzSk8nXbdwUf1fRrELGuA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iR93k3TD;
	spf=pass (imf15.hostedemail.com: domain of liu.yun@linux.dev designates 91.218.175.5 as permitted sender) smtp.mailfrom=liu.yun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ikqckRwTpoZ81VkeQhZ64AEwYoP4+cSdv8SlyoqDO6o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793339747; v=1; x=1793944547;
 b=iR93k3TDG1vqSTb0gWskdRipt0fLGKoB3AUTCNBmHMsgoySz/xsWVe/noEHNj3kLRF8TZdGw
 GZMe5Pr+OVAXlDA6WU1T1xo5KQQzrICnJRop7bWCy37roh73JKH+DUQuI7Xyd/SseFD8sbv16or
 KUwsnJV2+lP7pGqTH78AYrXA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c51cfdd6c67c2387;
	Fri, 30 Oct 2026 05:55:21 +0000
X-Mizu-Trace-ID: c51cfdd6c67c2387
X-Migadu-Flow: FLOW_OUT
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Fri, 30 Oct 2026 05:55:21 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Jackie Liu" <liu.yun@linux.dev>
Message-ID: <67833df2daf24cc413c212c14306b9230dde996f@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v2 0/3] kfence: fix pool allocation failure handling
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: glider@google.com, dvyukov@google.com, elver@google.com, pjw@kernel.org,
 alex@ghiti.fr, aou@eecs.berkeley.edu, linux-riscv@lists.infradead.org,
 linux-mm@kvack.org, kasan-dev@googlegroups.com, muchun.song@linux.dev
In-Reply-To: <20261029182645.d6e7b119a562c973d19cda63@linux-foundation.org>
References: <cover.1793242457.git.liuyun01@kylinos.cn>
 <20261029182645.d6e7b119a562c973d19cda63@linux-foundation.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E1981A0003
X-Stat-Signature: ihkn9zn6yuyyp7psjoks1hyb13q5etsd
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793339749-199144
X-HE-Meta: U2FsdGVkX19t9YgUYSUzk31JNpvHtgIQ3ZT1UCubAMcmVp5j/qaZ5/1k0OlU0SsM0DQaW+q9LYCCmn3nZ/VDo1F4ZqaLvCYbiCR2ZIrUIMH9qJQT+3MTMoqa2xbY8pQhh0ganoRBeGZQhw7wT0DA7h2gSa4k22LqEWeGAKy1S4tbRGGaT5bzr9JvRw7/MW4rR3ckSTOvm5bFE7+qtwJa3GonkLvvcH+vZTyINAkjnBeRWia+KZmvssbn0ZwfA/zYX3eZXi0getsuANHyb6owjL4TuzVWScanpxBYM5rm1FbzTSwhduZ1nr39Z70Yov2G4eRv0BO21KwkF39imYCV2tNgKzthCcmWbwTBbvpbhqVAsJGq5BivWFSGWXfjTP5s0EV0KOHo1lSgDXzOk05nd1VS5UGEZPW+ijNJp+g9zB+w3E+Vcf+JmxYK4I3Bqu7WvRWQVDCuYaEKL3+5W1TjOYXQgSv0OjEMHjlT5VeIvhjqwz+W5jNS2H6CDSilOJssIZJC5cl3L2WvYofxKmj4L/36kr26USVswcd7m6/oS1nXcOa3yPhhm3wCFdftVOkjopx831+GXQDE+HSScPRzFqgybsdzFG+9wfJFazFPHDa4sABQ6odW5mln0fsfqhhJNYYGGtt5sk+8RMnKS7RYEdFXI+SLBvEqIIezU6QpZ2IJQA5UgK0mHoe3dotDJsIQXKSs8lz2T20pZ47lb60CrgxDDyBr42okUYjXkx4SNdmXrdyDp+JHOA9PYsmaw3BaT2Tk1NRShaCePJX04EIaXhWRkphDTKO+n+J2po8LnyALAsHXOpDQWmEuwctgqFl3dcHogQKIDaDkKGAnNI0n259rzZvIaogmn+PgzQgXmZZzEkv5ZKwqhM5iulovCdU5cuFz2EtKV2i2iZgFDcF65m54EOIsTmrmX1cIcQNfXWqtuRnlhy7xLC9y5ZzliudE4Uh4BotqQFXC9/Sl2HP
 IFURtSYp
 /rsUw3hxiME7s8bgKxnGVBJsxqvZT3zU/ToQOeS3xFPC5iUUFQGbJFfSyDg7y8YMc6BgSS8IUs+ilnCEOEAscm1CLWkbsySoAkJWKvykrPRMwYk9FW51eUjeOHkVSJBZDar/fUqvFyX5f5/J5brcCJrDqCehB/QEEk/r7hIIaMKa7i2WJQ9D0+dwGt4Q4RI5K/bnZN6uptzArL/zX+jBOPqQtEY8nCbXELzVLSOEcS0JPCPn75tuxMH2ssqqIZEw774O5iOyrw6/IE4SGKyqgOaOrX+izQJXPwRX8yU5DJ/6Ggoj51akTLpwdmIUCzE1IZv/yIdjkrSXWQw9eXbMujWC1o5uyH+6kIfT3UYHj5TYui7M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

2026=E5=B9=B410=E6=9C=8830=E6=97=A5 09:26, "Andrew Morton" <akpm@linux-fo=
undation.org mailto:akpm@linux-foundation.org?to=3D%22Andrew%20Morton%22%=
20%3Cakpm%40linux-foundation.org%3E > =E5=86=99=E5=88=B0:


>=20
>=20On Thu, 29 Oct 2026 10:57:40 +0800 Jackie Liu <liu.yun@linux.dev> wro=
te:
>=20
>=20>=20
>=20> Fix the cleanup address and page reuse window in failed late KFENCE
> >  initialization. Also let RISC-V boot if the early pool reservation f=
ails.
> >=20=20
>=20>  Patch 2 depends on patch 1. Patch 3 can be applied independently.
> >=20
>=20Thanks.
>=20
>=20We're all horridly busy with bugfixes at present and the first thing
> recipients think when presented with yet another is "why should I look
> at this".
>=20
>=20So it really helps to start out with a succinct and punchy sentence
> which explains that thing.
>=20
>=20LLM suggested to me
>=20
>=20: KFENCE initialization failures can cause kernel crashes or memory
> : corruption, while a RISC-V failure can prevent the system from bootin=
g.
> : These fixes make the failure paths safe and allow systems to continue
> : running with KFENCE disabled.
>=20
>=20How does that sound?

Hi Andrew,

Thanks for the suggestion. That wording sounds good to me. It makes
the impact of these bugs much clearer, and I'll keep this in mind
when writing future patch descriptions.

Also, Sashiko has reported an issue with patch 3/3.

Could you please apply only the first two patches and drop patch 3/3
for now? I'll address the reported issue and resend the third patch
separately once it's fixed.

Thanks,
Jackie


>

