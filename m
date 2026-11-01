Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B905D606A325
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 10:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=8alias.com header.i=@8alias.com header.a=rsa-sha256 header.s=dkim header.b=kyjPKvhS
Received: by kanga.kvack.org (Postfix)
	id C50296B00EF; Sun,  1 Nov 2026 05:14:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C00F26B05B1; Sun,  1 Nov 2026 05:14:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B172F6B05B2; Sun,  1 Nov 2026 05:14:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9040D6B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 05:14:21 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 33E88A032B
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 10:14:21 +0000 (UTC)
X-FDA: 85386140322.22.3AEC387
Received: from mail-200160.simplelogin.co (mail-200160.simplelogin.co [176.119.200.160])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9B1A51C0005
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 10:14:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=8alias.com header.s=dkim header.b=kyjPKvhS;
	spf=pass (imf21.hostedemail.com: domain of sl.lmysyibrg4ztonbqgiydqnzmeazdknbsgiytixi.jlnzkn3qr652q@8alias.com designates 176.119.200.160 as permitted sender) smtp.mailfrom=sl.lmysyibrg4ztonbqgiydqnzmeazdknbsgiytixi.jlnzkn3qr652q@8alias.com;
	arc=pass ("simplelogin.co:s=arc-20230626:i=1");
	dmarc=pass (policy=quarantine) header.from=8alias.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793528058;
	b=jVJKQ+HZKDckv0rNyC4pEGK5b3HS/rarxk6SH1y8xOrPw40rzCxwSpwb5re59gAsFhIZ4k
	x73Ea+LWH153z1HILD6Ubw3jfzFVfVbRRRm+Y2KNBU3Rf2FAgRZ1PVgnII/i6Yc/epFggM
	GVfq0MTmmcPbRzKNLEQgTmeF4oCBinU=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=8alias.com header.s=dkim header.b=kyjPKvhS;
	spf=pass (imf21.hostedemail.com: domain of sl.lmysyibrg4ztonbqgiydqnzmeazdknbsgiytixi.jlnzkn3qr652q@8alias.com designates 176.119.200.160 as permitted sender) smtp.mailfrom=sl.lmysyibrg4ztonbqgiydqnzmeazdknbsgiytixi.jlnzkn3qr652q@8alias.com;
	arc=pass ("simplelogin.co:s=arc-20230626:i=1");
	dmarc=pass (policy=quarantine) header.from=8alias.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793528058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hSHY3WVsUBqgQAxQOpMX314E9mDDGTULiBUsGnrUENs=;
	b=ODesMH43R3KR7mETdmFdOyiq/T9pIxrGq4qgzdbuVEVLklrn6cmD6XsfG4ioZnKNtguuK/
	QC6zrmBGi/OEwm3ym0GvvwVC5/UxiNkI4+JeFvXLIf6ppgWMyvVGA0zgJPAZSOAr7bn+aw
	coumEojekDv9bYliNymJqD82vVklisk=
ARC-Seal: i=1; a=rsa-sha256; d=simplelogin.co; s=arc-20230626; t=1793528057;
	cv=none; b=y/n6UpJn6xCpfz0q7tZfmTCP+Und3TJViuab/qVntZCRSWByzRCcFs9fN2M8SAeVfzyGlLnSQ8EcHyrAHacRZDmKyIqPcMSs3JJ6bWkWkf0Pu6FU+SQm3EbYP4sjbDRBItOwl+keovnttt0TU+rv5+v4DHKUiAwZZd9IjgcduDfW1E1MMmd5gticomGPvoD0plb2c6pN/vqxHpbw13JCSsQkXfvYQ30PorGTkUr+df66wTPCshtcFa1v4bDDxJpxDCzgOxcb1gVVkWL9SuHDpHid1vf2U251GBKxla4mL/jDpXKAyGZIjunmZNmyMGJ3+iDH0hCFn4y/UQiDGPTlQw==
ARC-Message-Signature: i=1; a=rsa-sha256; d=simplelogin.co; s=arc-20230626;
	t=1793528057; c=relaxed/simple;
	bh=hSHY3WVsUBqgQAxQOpMX314E9mDDGTULiBUsGnrUENs=;
	h=Date:Subject:In-Reply-To:From:To:Cc:References; b=BKf3zys5bCY1Zbs3vyuYwYCr5iN4HLeS+4nlbJhH+S3sFNUsueM91ZuLAVnQd+DoYAQaPQ6Qj/fNIHuEyBZ81fDyX5pGBDM63hmQJu/2AnV+YFCQNvcYWND5yYBcVSKtWgs621AC9Pnms9i2wmamN+XRLR4wLf1iFcDqDWNl6rywcf82s9vxIh1Wa2H3AEnwgKBzGL9zRy4VotUXZyt1d0fFsKgb5OAHDP6X6TGvNYzuJDLw0D3jBEm0gYldmE5abO02X/8GhYFLTiTlo7yZnhcTlr8TU0+TZJ9zsx9T1DDt6g6IFAsM0R/6jwfCyJmaTFDJx/E4Zj5zJW8FJdC0uA==
ARC-Authentication-Results: i=1; mail.protonmail.ch
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=8alias.com; s=dkim;
	t=1793528057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hSHY3WVsUBqgQAxQOpMX314E9mDDGTULiBUsGnrUENs=;
	b=kyjPKvhS/DT8rJw3p7gATGUiuirTty9AElIWO/xzd3Slx0AdrCNpVagyGZlsZVU/Ut1GwY
	rRM/z2JxZpOB3LL9erypHjLgHL7bgx2UiSG7aGblrjSponinPP579IqSJBfbqsmfq/+2iz
	Cnmr0nSnLBYtkluzEt51Xp5N36IW3Oo=
Date: Sun, 01 Nov 2026 10:14:06 +0000
Subject: Re: [PATCH 6.12.y 2/2] mm/early_ioremap: Sign-extend PAGE_MASK when
 aligning the physical address
In-Reply-To: <2026103137-showplace-numerator-a05b@gregkh>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: =?utf-8?q?Radek_Marci=C5=88a?= <github.unusual340@8alias.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org,Thomas Gleixner <tglx@kernel.org>,Ingo Molnar
 <mingo@redhat.com>,Borislav Petkov <bp@alien8.de>,Dave Hansen
 <dave.hansen@linux.intel.com>,x86@kernel.org,Andrew Morton
 <akpm@linux-foundation.org>,David Hildenbrand
 <david@kernel.org>,linux-mm@kvack.org,Arnd Bergmann <arnd@arndb.de>,Michael
 Kelley <mhkelley58@gmail.com>,linux-kernel@vger.kernel.org
Message-ID: <179352805420.7.6433291196676980630.1737402061@8alias.com>
References: <179346145167.7.7861216093151225931.1735978772@8alias.com>
 <179346152914.8.7838190602983146541.1735981230@8alias.com>
 <2026103137-showplace-numerator-a05b@gregkh>
X-SimpleLogin-Type: Reply
X-SimpleLogin-EmailLog-ID: 1737402087
X-SimpleLogin-Want-Signing: yes
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B1A51C0005
X-Stat-Signature: kabma83udkmxdjpqsc9m66wq1hfayq9s
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793528058-725284
X-HE-Meta: U2FsdGVkX18m4Iu81BTH8Bys2NgijBC0khc2VMPbSCJwLdyq3Zpg3ZPwm/X0DeNqY+E4Gpoz5DoGvdtAhIO5BMagjLDYGwLYrdeJ496kjdhqudHe7ZbfXB44hYmYCxrtKWtAS7EmJzurfCMkfNFYuuxlv29srGd2YPbyWsoydmWS2zM6mN3/ncv8CKrpiiglzR2kPz8NECOvpWhQaF6o+V+WXSyQVli7uhWY0hainbxMgFcXShn+vPhoeuz5mpCl0uJgJA1YQWN2y9X8K/rgawAcTeXLJrfqIzk7NAZA86NGpAybBbj8qCzYGc4ZvsuGebd+AgJ99ibdH0/m4mBq/ceE6RB4l8eWdt89DVtHCnZY372V3BxxAEqZ5Vbhw2FefJgGDc6t3SB+IFP03RMvWhB5tgrQEcaljsJ1WX6jJnJp+WkPBpRZeZyZxwa1tY8GVa+pb9+OKsiPJlNvuoD1sSaIlb68u0nvAU1aDXXQ1YR7PyEtPmFaYRqqaOTs1sTqJvgO9W8xxu0HfMqLZcC+YWaPrZs/Z1ZxX2UepVELslWWummZJAoa3Cxz4YDxoHrHz0Y86Rew/SfK6d7ar09CAt5o3Iw/ahmx+pkFvmMASQ2+zRIhou7huuySUZpkKCImeg8vXjOTHtKzC6u08FKFV4tD4T0iWI/MuRp+xumy+RR5W/VvqdfybrFQIPzvJdwwgyBzJPIIBYSXlqzt79IoiNq9Jw6ouw7hX8QjQmQMpFnaqxD0LqifwRT4q41aBkQJ88Y5fbZgWi4HqHTRi1uYjdKlTchOI/mcoCjfbbAW9prFICg02+ZxRA8wvcR46sPZpUNNOl6oDy0herTcKtYytKY0HSLMHmQ1NYG/W8t5p1lcTkCq48syEuFU4pSpKdR+3rI1h2x73/41W7dxkF8QQlPZXvsB/SdmlgOM0C3rZqTtOKdylRK0uS1P9YojI3XcTaOua0YNh86OwCed0jM
 KuGFsJnz
 bEW10x3lSvROC8OIrCMKqRnlXYca00JR1hDfc2gvji6Mb5qmm3DhE7+u+XqherCo2QxdHL12hAc5l5jorko/Pir+zkW5q3eJfw2Z7TfIrEMo0DESvxV8AyCCyxJ5CjQlKx9MqEWH96sPFsrgmuwduHzYCld7fqZaARpApiqgAWH9GdmMfZUKWYl8emyhZXcR5hD4W1gOZBby4xbv566dOY+Af6ykUFbmeXzPC7veYSYQaQ2dRfSCMc4itac6XrbEzNrppN9BXV4RBSxw04HLeyJqgK4b+sr9Jw+Mb2DWCCmhPR03PpFKIaKT7YC78IrOvPFufViazJWV/XZyftgrVY3j9JrlCTeSPRhCVozYSS3grkjWZM4rI2urRl3hg1e3HpD60uOwfvh/djEXAsGt7CCGwGBU1rKDsnYStFKeCSzlJA3XaD5Ce6tW+duRE+etWPnB9928oGDDB1+XAqDYIKIHu5/1yHJ8k3eorzymlAlMXjjuU3G96L9AXvjosaIG6/GQu5Cn+o4h7A6zNTg0mWQUa+8ym3sDBiiY7y94OQlxBvpUBkc8HvB1xQZwlchq3eYqjSo/lAdXtEIE6iREnhiZAN+mmVsaPLMe74tVpZw+GmHUGwCW2izG1vLcr2Rue9/Yjlyu+9XkgJNg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 2026-10-31 at 21:25 +0100, Greg KH wrote:
> On Sat, Oct 31, 2026 at 03:45:21PM +0000, Radek Marci=C5=88a wrote:
> > Signed-off-by: Radek Marci=C5=88a <github.unusual340@8alias.com>
>=20
> Sorry, but this isn't going to work for the obvious reason, so we
> can't take these as-is.

Thanks for a quick reply. I do have a public GitHub identity which
dates back to 2019 (https://github.com/marcinar).

Here's a recent PR using the same name and email (see the raw patch),
this proves that I control the account.
https://github.com/simple-login/app/pull/2866
https://github.com/simple-login/app/commit/f1eb1fcf36d1fd92a3c2057aab3faf1a=
5fae1e31.patch


Here's a PR from 2020 that was merged and has my full name (see the raw
patch), this proves that I didn't change the name or rewrote history.
https://github.com/ChargeTimeEU/Java-OCA-OCPP/pull/120
https://github.com/ChargeTimeEU/Java-OCA-OCPP/commit/9e8f2c09ee34a085103d3d=
6d46856606b05e9a8d.patch

Hopefully, this is enough. But if not, is there a way to contact you
(or someone else) privately about this?



