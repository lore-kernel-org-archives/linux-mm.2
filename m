Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C2DF606A323
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 12:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mailbox.org header.i=@mailbox.org header.a=rsa-sha256 header.s=mail20150812 header.b=tYzOSWiM
Received: by kanga.kvack.org (Postfix)
	id 3F9AB6B05B6; Mon, 26 Oct 2026 08:45:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AA136B05B7; Mon, 26 Oct 2026 08:45:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C55B6B05BA; Mon, 26 Oct 2026 08:45:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A69B6B05B6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:45:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8644DA81C5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:45:02 +0000 (UTC)
X-FDA: 85364747244.18.8CC4943
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	by imf25.hostedemail.com (Postfix) with ESMTP id A1C2CA0006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:45:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=tYzOSWiM;
	spf=pass (imf25.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.161 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793018700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gNSvfMB+KSu6h3D0gLvM2K+YtllhQPeCS/Txg2cf7IA=;
	b=xF+GoVYQUiqzim/owCbi1wyy1Ipm1bjdWLISeCEdPRm5hF7RPlP4e+wh/R6/IerDgGvstF
	/ROk6HkFc2YcvX+lzf4EDmTkNB5f6cUXHLSY/xj6YRZM+wIsb5RR7qt5Vzq8JqKW0TjJzL
	YLDU7SWQg6jNcsQRkdz/6/MnegGIcs0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793018700;
	b=YDYIVfYKfxBOK4DNBk7ZR4aY7J0gpqPWROjY6UDn3emd2AdkbG6POKSBoFJMYqQQ8vO/5a
	rFTdo5iis0EZQg6FzYL7Jdj2FJzN8axOYQRQgQPJQFEkbEMBG9A4Kp6oiP5XUbRRjuxLat
	JpJQXEbuNGSskUu/ZFj6jjQ2MLkNEdU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=tYzOSWiM;
	spf=pass (imf25.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.161 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4jCtcn62WTzKm5M;
	Mon, 26 Oct 2026 13:44:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1793018697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gNSvfMB+KSu6h3D0gLvM2K+YtllhQPeCS/Txg2cf7IA=;
	b=tYzOSWiMgAO6iqMmGbzPgi7ambZF9u29A0182Egf/5Y8KqLX/99xqmrfu+u0IIVVZtVU6w
	YNU3sj7Q11Xdyq6RU6XsdvmYlmAn8uwxk5YKI0J+CLEO2Yv6t231xxmAXWJAMQK//DxFCz
	c/kvG6zon4JtTiOX22JjdxDJiH7mN19P+65Y1AAFqK7DjGuqBSNrAB54f+SOpXBrufwfOK
	GZzlmCCcsdj+QxmIR+i6V8RWzl7FNa+PPnQZ2OXfy81KLTc+y72RVBCGyF6YbD79J3MZO+
	Fk4jtdS3iAhHL29UUmHx0Smk8Q1Lwse2FLBYu1vXJYkJc3RWfyjOcLXQ0pX/cQ==
Message-ID: <203ef50d11ae600ab06546d73a2290f291381551.camel@mailbox.org>
Subject: Re: [PATCH 2/8] Docs/admin-guide/mm/damon/stat: fix pronoun
 agreement
From: Manuel Ebner <manuelebnerli@mailbox.org>
To: Aveline Noir <jm5905938@gmail.com>, SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>,  Randy Dunlap <rdunlap@infradead.org>,
 damon@lists.linux.dev, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Mon, 26 Oct 2026 13:44:55 +0100
In-Reply-To: <179301327249.2.17530814278215474568.damon-docs-grammar-2@gmail.com>
References: 
	<179301327249.2.4690198998605536207.damon-docs-grammar-0@gmail.com>
	 <179301327249.2.17530814278215474568.damon-docs-grammar-2@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MBO-RS-META: mkyds7qstpeqe1s9cnddd6e1xznqfuib
X-MBO-RS-ID: 34eaf3e72545e878961
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A1C2CA0006
X-Stat-Signature: fptrq9fmjjj3tmoicapucn5jbr1nnoin
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793018700-604879
X-HE-Meta: U2FsdGVkX182p81ej2Emn32N8a0yamJ64Hl99FggqRexgig8WdFiGqjg5n+YFCz+TaWTVIcAqMMy6ltIqNJuKSvlWLm5oKQUyBhZFedKTUxi2tT+OR21p+hObIhWhMcBdjHgneLE4veVsuSt0r7RkwGIkXqPDHS5L0sUoZOx9cPpxnYL31INKqBUGTqzOsVcfrU2fZ6q/gPmWaT/drTj5IuLfLfRngU7UmGNxRTTgplaaQ67H8WS+uqWRxEaqfebM7+4bmM9GNh39iioMKSxKlYtGaHw4BqKCYaZ+z/ncauiHFK1qOs8sjvCRQK785YLOrr6zCSuMbt4lm5otsfSoGs3/mQV9pAzO4xLGHwTyoEi+KyOixd8HpWwe/1xnJAovcC/jBoWkZK4Plisb3K3U2DNrXPnj1YEKGxRY3ybaeootbUSadJi8aZnfqFaACRdDeCGbKSPyvCrtloLQxt33F+AIVmgNpoMgvUNqqe9WFNpbicfD4jaLVaUj13WPp1M6YiL4r15Na2nWH0TNRiU/Nj3RjhvEOsyut2wSEVaqUFF0dAgtQEXvIDej6Vvee5bcwEQ+n12nTmQFlKbmXMNaUa5/1p5+YTO/08QV2whcE0rqluKwZegYOJoKDc4IDf3VhoqQzecGURtQwqQnrZAizBELqDhmj1P8sZzZWxba2wD9y7sTlUz1kVwFSEIC3JrxqOFn5tn63svct6ZgkbZXyegdELvNCggyAUidL+r9CZmBRcKdJ7FG2dk2lN0FnLNpthUhLVlq59FgDw9Ah0BWeY1IsuLX9QUjQSVM7HqJMsL4jU0nD4fyWwvyosBkqGrCZUU2jX/FQsKN1ns92Zn5ZDGmQ17KtsNV/3e5FU87dtftY6dZzn6takzH6PnzAbTEX2LqWJMSGUojr/fR6L6Dtqz92VPm3xXifOg0Cle0IhFsxWMRi+s8KQy9JCtGmiKxWvZW9eVWuzbF7+LqfV
 HU+kaQ2N
 GWSb0eyeIdO97iJy5xN2RlKGnqHBVDGQxX1vZwjj31G/Phbr3afpFLNpLZ8WUgKT0/QCulU68C3lZPkrFnCAEX7UmSRKKFoEH7p5T9zYS2MSQQkZJUwzKVlTLRnBU0eGRJIkYg5y8V8NDkqbW/ymU6FN7Xv5BLc427UBd443p36eQYctEzNzfLQLDN0rTDJgT8+dJ3T+xLiB8u0OFIAN1YgDO4O8LguoA+LOMcS8Iktf8/EMuYAV9m8a5QlBNxXEz8NgHBtGzaIi+CjB8edJwCvKz0NyLCOVwJp2cwNafagXig2lZw+x1xXCwK+7eSsgzYdAIkH3VCIolPHM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Aveline,

On Mon, 2026-10-26 at 22:14 +1100, Aveline Noir wrote:
> "converts it" refers to the access events, so I think it should be
> "them".=C2=A0 Rewrap the paragraph while at it.
>=20
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>
> ---
> =C2=A0Documentation/admin-guide/mm/damon/stat.rst | 8 ++++----
> =C2=A01 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/Documentation/admin-guide/mm/damon/stat.rst b/Documentation/=
admin-guide/mm/damon/stat.rst
> index 4a9db755a526..a93609649a5f 100644
> --- a/Documentation/admin-guide/mm/damon/stat.rst
> +++ b/Documentation/admin-guide/mm/damon/stat.rst

Here I found this one:
@@ -41,8 +41,8 @@ enabled
=20
 Enable or disable DAMON_STAT.
=20
-You can enable DAMON_STAT by setting the value of this parameter as ``Y``.
-Setting it as ``N`` disables DAMON_STAT.  The default value is set by
+You can enable DAMON_STAT by setting the value of this parameter to ``Y``.
+Setting it to ``N`` disables DAMON_STAT.  The default value is set by
 ``CONFIG_DAMON_STAT_ENABLED_DEFAULT`` build config option.
=20
> @@ -68,10 +68,10 @@ estimated_memory_bandwidth
> =C2=A0Estimated memory bandwidth consumption (bytes per second) of the sy=
stem.
> =C2=A0
> =C2=A0DAMON_STAT reads observed access events on the current DAMON result=
s snapshot
> -and converts it to memory bandwidth consumption estimation in bytes per =
second.
> -The resulting metric is exposed to user via this read-only parameter.=C2=
=A0 Because
> -DAMON uses sampling, this is only an estimation of the access intensity =
rather
> -than accurate memory bandwidth.
> +and converts them to memory bandwidth consumption estimation in bytes pe=
r
> +second.=C2=A0 The resulting metric is exposed to user via this read-only=
 parameter.
> +Because DAMON uses sampling, this is only an estimation of the access in=
tensity
> +rather than accurate memory bandwidth.
> =C2=A0
> =C2=A0memory_idle_ms_percentiles
> =C2=A0--------------------------


Thanks,
Reviewed-by: Manuel Ebner <manuelebnerli@mailbox.org>

