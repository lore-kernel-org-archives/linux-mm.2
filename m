Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E46E2606A321
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 15:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=aros@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=LebiIaej
Received: by kanga.kvack.org (Postfix)
	id 114B66B00EF; Sat, 31 Oct 2026 11:22:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09EB86B05B1; Sat, 31 Oct 2026 11:22:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5A086B05B4; Sat, 31 Oct 2026 11:22:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B77E36B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 11:22:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2F15A1C43BC
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 15:22:25 +0000 (UTC)
X-FDA: 85383287850.16.90DA401
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2468D100008
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 15:22:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmx.com header.s=s31663417 header.b=LebiIaej;
	spf=pass (imf05.hostedemail.com: domain of aros@gmx.com designates 212.227.17.20 as permitted sender) smtp.mailfrom=aros@gmx.com;
	dmarc=pass (policy=quarantine) header.from=gmx.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793460143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eLl6f1LYL/UZ4WIb68htvev2zuj1DylnxY79Ju5sTEA=;
	b=NEDdqCTAZMUC2WJ/yyFwXPnvSaWuy4Rouz6TPFNWJ0l5gsGFXQqtSj0Kkmg8cljEHplcky
	d7mHNPK28bbhWt73Jyydhsk1+QFFtBppUNyAvYP5U7VmIlTGMjv7h/hUeB4rLsMVPeRYgi
	49NIGTJ8+KarZGwGfQLsqyL4EjauSHw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmx.com header.s=s31663417 header.b=LebiIaej;
	spf=pass (imf05.hostedemail.com: domain of aros@gmx.com designates 212.227.17.20 as permitted sender) smtp.mailfrom=aros@gmx.com;
	dmarc=pass (policy=quarantine) header.from=gmx.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793460143;
	b=7YDBdIlN3w43ylzlhkIQvlRC6/fy3iqsTTPeI2gcFwAppJNZ5P2Wpx+PfDiTqnj2HgKXK5
	ap5g8hSPSUYiPy+jFzb+TxzDpGTYpsXOzwTxRNxB4cPckIWvPm+VblmWIEqYIkF6VEl+oZ
	r52CChWjy5HCh6gUN/b48sHVk09+k/M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1793460138; x=1794064938; i=aros@gmx.com;
	bh=eLl6f1LYL/UZ4WIb68htvev2zuj1DylnxY79Ju5sTEA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:From:Subject:To:
	 Cc:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=LebiIaej+zKWDBUTcw0pvTD+pyvKhEiSS8GVWVpPl+3S+Hi2RIe6yV+QXGzNNWva
	 YgEKmnY6iqwLYmMqmj5HZzaQxRf7wJwO19IMdnSUXTUJmxrsYOG4rCU9SN5CKDfK3
	 3DLm8QHbzAmI+bcaAqA6VN1Yt3YuIn2TYrsxvHVuoC2gDbFz8ZIqIbAUTnOtlCnRX
	 IK+Ca3Wyzs4AyfUQCojksyGyW/d12Yw4E57pN+AV4J7d93YCIovVJZLmA2AKFpCnZ
	 S+HFKRU+nN6pbOLBPCySEG9/IANA3ap/B3czs2uSMxVDKitCuJ7W5MRh0Mqm/c66c
	 7AC5ZLXEO3FnrOL0UA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MA7KU-1xG49r2qUc-000aM3; Sat, 31
 Oct 2026 16:22:17 +0100
Message-ID: <73f0a43e-e314-4a31-bf1d-184019d58ed8@gmx.com>
Date: Sat, 31 Oct 2026 15:22:15 +0000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
From: "Artem S. Tashkinov" <aros@gmx.com>
Subject: mm: tmpfs: huge=always Kconfig help understates severe space
 amplification (follow up)
To: d@ilvokhin.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, david@kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:EakrhKYLSKK9kx8IDSMb5I5bcILvuCw+uClaAE/S+xoPYkvJyra
 VEhcKPmSYzRezCLX432l53KamuLLNtrFo+JFWWNTX7r0exCRGd8f88OU7GVQCEl3WLJY0Wg
 juL9fPcWP6DzUZW0AoRemP81gboGcr1uesUG5EGfWLoWEp7XpvGDl8uDSbFwqN1PgKYNQZI
 VSjNmqACtoneWoSXYkYVg==
UI-OutboundReport: notjunk:1;M01:P0:PZT2iqREkeo=;KfkeL8/uE70dCQPrNUltOA5sr06
 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
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2468D100008
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: djez3kp8difx74tak6h398a5jmhkoprh
X-HE-Tag: 1793460142-895582
X-HE-Meta: U2FsdGVkX189yPwG4JkCOUj7JK/RYGc9GqO21Gh7fV3v9tO/0t0j3B2xhJgXPhWApkxBygQr37abtA/ZS+LYIicYo1csArqqqPxl2B0NG6xHtMovx8MwCbAOQIyU4AjfuNt27lNDsLyC7c48cvI+Z27jLGuQZc6M6wpWVITAhrSFOBIKvjIOBOFaW9PZHfOqedtdmI5tKe0S2TqCGKW/ktYM4aSHer1srY2ZRcxDnV5VFvpfn+djLf/cg2tbxlIRaznkyvJ4SNNs+qHC/Z5jgI0oydFW/x4ce8HhKNazsRJhrk849lDpWcYTcmZlTWzRyEWyocee/B0LODtJ5ZATCx0sNx6r9x/hHSXp2uc3S5W9+XgtTblTCUz0SmGmGyqzBez6r/O+3ljf+ofvvsf8upSsASwynGT32CSlEUULRCMvsrhU1SbTOQ1INr5BdUgLu/l8aalImDrTJnnT8RQOWKRKw1FvK+nFQXqD09AgCDN07GKUNGYn2HB8owgiRpRc3aEQ/jRwc3/e2kWx9qEZAuOyvUWHzEQo4nD+urNaJxPnSqcj1NCy1TY9SpVy7ITpjPLWVXJOpxQbfU4C03Xa/PQ9Kok58y5xnlVkcIiJqYEmm2Z6Pv17Uyy3FDRwYMcO7viCukeT1c30afDpNXAyhIaEqi1eCifllALxgfnM0XA7QffmeGkfpCIFn9QooUXJEBQi1MSS+KgDgZOiVDR1fNcAbsMIAQD3JVPrmNpLw4DBuFFoHdFaOZALVsikxybCNoUX02rmVFjmwjn2LDDniBlo9sQHsTgtrW2bOVK8fI1OQgjHMOvYcsiUowtxZbNxL62srv1/0Pvv3oJgeYxG3W8cSIbVpdk8iYFayEK0O0I8LpeYuN+2kGWPQqad730lg6VeALwuajHn6p8omgDkOsqHaEyeux/TAGfnkF7CvdWScvjPdBdS57rD0IPY2JpzPE6i01gfo7yt3l4ZEaS
 c3ieT3Mm
 xmVB+z/2NS4XeoUNg+FJKHj3he15oFwoCRX4QYFb4EhUkLFZdZVhn8gVNKM0w1cw5XgSYQdginkkth+y6hxw9V/f4isAhQKfYXNnyudtqb+sVdLv7NcgeEMKiH+NJ1WSXpuJwtXAQYgXoQzktTn7bpkRjafNs0b/qt1DiPaMoHO7Pd49dfIhY9Uouf7TmYpmCfkqfm02KvxCtspjaBXBpznyLrPs4Ro0aF3Un6/L7I5pUbm4X/UPkRoqzAEXxvxxOFPm0wGEuMD0s5OcND73nmtpJ67DRTxhXmyqWXqWbrTmNbPceWACHqVXAZON8OtXG2ZTv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Dmitry,

One additional observation concerning diagnostic tools:

In this situation, ordinary du reports 45 GiB for a tree containing only=
=20
1.4 GiB of apparent data.

Although this is technically correct allocation accounting, it makes=20
identifying the cause quite difficult. Both df and du show an almost=20
full filesystem, while neither explains that huge-page allocation=20
overhead is responsible for most of the consumption.

Only comparing du against du --apparent-size exposed the scale of the=20
discrepancy.

This reinforces the need for explicit Kconfig documentation: users=20
investigating unexpectedly exhausted tmpfs filesystems may reasonably=20
conclude that they have accumulated excessive data, rather than=20
recognising that the selected allocation policy is consuming vastly more=
=20
space than the contents require.

I am not suggesting that GNU du is itself defective. Rather, this is a=20
diagnostic trap worth documenting alongside the configuration option.

Regards,
Artem

