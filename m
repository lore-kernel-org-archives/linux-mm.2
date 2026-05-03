Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57A1DCD3424
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 15:51:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6BDB6B0005; Sun,  3 May 2026 11:51:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1B866B008A; Sun,  3 May 2026 11:51:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90AB06B008C; Sun,  3 May 2026 11:51:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7F89B6B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 11:51:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 438B01C046C
	for <linux-mm@kvack.org>; Sun,  3 May 2026 15:51:26 +0000 (UTC)
X-FDA: 84726548172.29.022D235
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9CAA01A0006
	for <linux-mm@kvack.org>; Sun,  3 May 2026 15:51:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=Q9oPpzEV;
	spf=pass (imf19.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777823484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fyRPsaLeyAmCgD7qP12n2O4WOzwaY15FpNC0oBQOyY4=;
	b=u+nSvOQHOtZFo0ML6OQvvfUbQ9ZHzDe4hftedDXm1G1/nug6CU1x9HdRanxG9Ps1q8/Mrn
	RCUsYg/t8iQ22jqHWElKLdU/rlpd4Qz9IsdNfrdKEqJoLPAcU321KoR9PZqbbPUi+DdMfd
	iY7xGKCd5ljvkuMQ/kTmeQ3rvT2V3gc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=Q9oPpzEV;
	spf=pass (imf19.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777823484; a=rsa-sha256;
	cv=none;
	b=e17zZKHMrrw/wYlAG0KOcAL5d9FxHKmoqFFjpoGGFe/Z7yrVrgJUJ9molFiVDTchVMIJG0
	H3txSmDmYgeUkpX5Hog5Rjj68BDsguTQ9Wn1RDvuK34d1+Pr2sw6VA1bZnZrXAE6DaIJyn
	YYmsyZ/GWkDXwk8+2L30CrCdtpZ4he8=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 759B141084
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1777823483; bh=fyRPsaLeyAmCgD7qP12n2O4WOzwaY15FpNC0oBQOyY4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Q9oPpzEV0FONZtRS5W4Fi9uvnUEQqPxOWkdpHtCbMXHJnDNo8ZYco68Gv+cdnRJQ0
	 HiYIRvbkdMQRdD4ggSgJrRNTgjJgFHRNO+M7U6FJy7tfxMkPdPeAS6W4PiTAj9oJb5
	 t7H6o2TmnslANristxpVyAsBCWVaXW0XkjUb2cDVKRFYJJFuFWHSMy6rJF02Y+1aQT
	 8peZdxLpkMbPuYLpPiF7PkfNRfkFroy/V8EA7zVNcA2ufyQtJ+85OQw3CLcbccPGI8
	 fG4mvPHY4NDJZqMstnuiRw1B4h08V4n/d1ZOqHJUHL7PpDiyOUchZ0EMzYzJohxyOS
	 YK8PRgeWb3v/w==
Received: from localhost (mdns.lwn.net [45.79.72.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 759B141084;
	Sun,  3 May 2026 15:51:22 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Manuel Ebner <manuelebner@mailbox.org>, Shuah Khan
 <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org, Kees Cook
 <kees@kernel.org>
Cc: linux-kernel@vger.kernel.org, workflows@vger.kernel.org,
 linux-sound@vger.kernel.org, rcu@vger.kernel.org,
 linux-media@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 0/3] Documentation: adopt new coding style of
 type-aware kmalloc-family
In-Reply-To: <df48beafcb0cc9caff40db78285113f0b1bd9b87.camel@mailbox.org>
References: <20260429070759.309110-3-manuelebner@mailbox.org>
 <87o6iwczjm.fsf@trenco.lwn.net>
 <df48beafcb0cc9caff40db78285113f0b1bd9b87.camel@mailbox.org>
Date: Sun, 03 May 2026 09:51:19 -0600
Message-ID: <87h5oobifc.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4zsyai8ync4ndfuk9uopkfpcg9c11opw
X-Rspamd-Queue-Id: 9CAA01A0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777823484-789308
X-HE-Meta: U2FsdGVkX1+HueYm41ObwARJSVa/yfQgyXwe+DOTmxhr1RgrMgDxtZ1EvKpfzS+2EQ1h9Ax6Na1khgjneEQSegka1I18D5IVTh2h8QcNf9T0FPaWchtjT1Zi0q6mdyxMPZatOlg0yQDvFlvv9fpKe5V+h0ycGKuDi0k1/AIMEaoPBQpV4RWN2nvO9p13jycASxmgYU08Gy5SrwFMFcN42yVx90RxvSWlOBKgDAc9QoKtWGPfF+TtLfvcH9wnJgz92iH+bYUrFLNBeTlfD4lQjf6BR7CftmF1Jz5zfPS90EdkK49xs/45S9I9dWposHjcNZI1rxhUrIe9z38leIP6gKB9wSwdBHJh11ogNSSKjLdv685OmuizOM1m2tgr04KlVnQQB/UNgXEce7QOSovnQQcUmXUyVuYWHey8HmKkNSRj2F/0F5/F+1gSk5yNAe02xV5CanaCI/wbPLKLY29B6ympAhabbSUxrZWd8Q2WmZHmNCImM2E5iPDLfGXNCL7VCwU32rsxWhYhB24gYpU0lSMEIUoIL5xMMfm413WDBmVJ0cbwhz37XRzcE5aIeaf4exdLxkfg3pDWwO0A84qQTD9y5FXfs5QcgpP9pnSCCyaUtV1o7bvs5P+g4C7v4fIrynoXQazES3TpEVVCuUU0r10OdzfPvHbZDzj7rrGKqoTU6eN3azEWEJ44MeJg3uvzxuHvHF62oQ1MmtwDRGo1o2UgoEKuLlDON+ry+/wFNt/P1+md7Jdg6boILN96vzOZ4Fh7FV6ofj25eROcoTjCqCMo6aNTI59+VLVCg/2m2NJwn0E3sUPvJovfJP+T96QVEpXxtGgma9UgNuXb97sxiZlEpJD9f5p6mxif83ssB2ViVvchR8o/YSn538ziBigFVctCoJrSZbfeMI3GqWxTZqBYVk8NmA0iounkHjonsPSzFIyWCnRPu4bs0fbuHrhq7agqch6DtUvg+ilIhpO
 m3c0iyU/
 0Q8p1u6+J4dJmZZBoBo5F5gNJvHILkKSk62bo45O3F6DxhVlP2WvMD7vWS4hU4qmWHq3u86+ZkOdPF/0+LzJk86s6jhyEmh1ISjRKobcfPbaqPM90Ia4U8aLXraYiiWzb4JCoPY6qIX8aBxFc6ACN2ASSAtp4M6MUy5RuK87gKV6cJ9EQ5TIxTqUju6O4sKDVgwMCWfCZpv8BiMcTqqU6bJgmL1XJeYcdGcw+hF5YyCQfifjbFLH3JEsxwXcHyoYmWEiKCXDeIPdDZGweiEUcpmQ2oNxSW5Q7THfs54fqMZm3vaxBIvLnqJmdICdCfWjGfWogKRcqicwRM98v2PmbIjNLr+/O0+mN3SPNtGC/10U05bK547+po/dLGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Manuel Ebner <manuelebner@mailbox.org> writes:

> On Sun, 2026-05-03 at 08:56 -0600, Jonathan Corbet wrote:
>> Manuel Ebner <manuelebner@mailbox.org> writes:
>>=20
>> > Update the documentation to reflect new type-aware kmalloc-family as
>> > suggested in commit 2932ba8d9c99 ("slab: Introduce kmalloc_obj()
>> > and family")
>>=20
>> OK, I have applied this series.=C2=A0 While doing so, I restored the "gf=
p"
>> parameter in the changelog portion where it had been mistakenly removed.
>
> That's good, thanks.
> I had two more changes lined up for v5 of this series:
>
> -	ptr =3D kmalloc(sizeof(struct foo, gfp);
> +	ptr =3D kmalloc(sizeof(struct foo), gfp);
>
> and=20
>
> -The argument gfp is optional, the default value is GFP_KERNEL.
> +The argument `gfp` is optional, the default value is `GFP_KERNEL`.
>
> I don't know how to go forward with this.
> please advice

Make a new patch on top of docs-next with the additional changes you
want to do.

Thanks,

jon

