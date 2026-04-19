Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2206EA7187
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 04:11:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C1F96B02F3; Sun, 19 Apr 2026 00:11:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84C296B02F4; Sun, 19 Apr 2026 00:11:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 713AB6B02F5; Sun, 19 Apr 2026 00:11:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BDCA6B02F3
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 00:11:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8FCCF16068E
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 04:11:56 +0000 (UTC)
X-FDA: 84673982232.25.2CA28AB
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id A5F15A0005
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 04:11:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iWFxSNA4;
	spf=pass (imf15.hostedemail.com: domain of thecharlesjenkins@gmail.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=thecharlesjenkins@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776571914; a=rsa-sha256;
	cv=none;
	b=Ap/I3HXfgeIZHpf9+ENLHzmBM8pa40llYqKCiUs3E08x3HXAjs77rCA5ZqX6NsVRhSCFlD
	Lu7yTqA7viuupvPhiqmWMjgs0zhVFTiu9CPs4jncvnhHiWM+Pe+A/Q7UI4+y95Kkde4oST
	7TbW7AkVAn7qw4wvpYii5+U3pw0ctTo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iWFxSNA4;
	spf=pass (imf15.hostedemail.com: domain of thecharlesjenkins@gmail.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=thecharlesjenkins@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776571914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pVtxPBGnCgVKFRrTeWoVJj1LFDo3OCMzE1ejj6WLoyo=;
	b=FC/6zunaqOs/oFn9oJJzI4idXsF9tOoj1l8AJP/Sp9gDzLg4HCmdARght0QohgYEP22JoJ
	eur0Bi3/8aDW2tO2maUYwk6LoayHdbDWv4AQ5BWb2PSRBjhIkZncbI56chSNDejytQ5qYO
	6GR9BN9vDXxXOcUDF1+mgEm2ja3OBiE=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8dbbc6c16b2so264006885a.0
        for <linux-mm@kvack.org>; Sat, 18 Apr 2026 21:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776571914; x=1777176714; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pVtxPBGnCgVKFRrTeWoVJj1LFDo3OCMzE1ejj6WLoyo=;
        b=iWFxSNA4xysyrvaTtNbnBwPq49JYO3hEveLCG0LY4x15gYHlcHDDqw3cZcOR07XEq9
         TyAQIodkYm2liElkfYHqhQKyoVMEnbUiGGRnwFcC95cVO7j4r5iCU/aUtuz4kttCB+IR
         qQBeuuqsu5ANxtAMIfk+1UpE8LVa1T9Q2MjufajSQFi2PpE7LF/W7/AXzIKk8jMT6VZT
         bCqicBPRBemSxKtSHkzoU1Sv3BRJiwz497DsiZoyHxgBF4Qrn/qKR2LapI+z9U5TFbwB
         k9l4F8z649fDsj2Lq+WHbBWsEhaAC+vUnWo/6ufv8TIoqO7GYUp7lzrPJhmws3xsxQIs
         KFZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776571914; x=1777176714;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pVtxPBGnCgVKFRrTeWoVJj1LFDo3OCMzE1ejj6WLoyo=;
        b=lC8brPPpaBu3yXS0Mdo8xU4yJVAwOcIf3D0pZqU3+7kdx1eh5Ter8p2M6np6RD0OZp
         QSq5wjwd/NgwWuzafj2MLZL3GA+2Sj6u1+D6DS0RbxYGyvl3Hap7hpfnC2LQ8C40o0np
         YZpfXhgeLVuSVkXIdE3lze2f7ICOt5PIGayPIXYgkm74hrPO5Us0OU1n8fRs+1sIoKX5
         VICd+c0S/m11evxqJim7dyp8yz1iPmSVGQpXYo5RuuJC4XVAXxphJ5Hl3CNk4bIzmWUk
         C9m+4T00W+5/QrDAFC6vzq3NuH9azgRQ6w4NwhFNrpJBg2j77yhdxLSbWfMqsiTV5yvS
         7ABw==
X-Forwarded-Encrypted: i=1; AFNElJ/6QyWlwiqXiQHl7PhVmju9LUlajeUPOpy9nQC3B3m3Ah5oZjxngtjAdzfD1Eq0PplsrohFXzpEgw==@kvack.org
X-Gm-Message-State: AOJu0YwqS84O3LJLt7Q5qrfK2mvh7J96LGZ01yaht1pBe8zcT8XP5xqR
	93o2BmkD9JK8d1VeFoXADd1M6AQNLS1INLntHE3V93eVHJwgyI/utsfS
X-Gm-Gg: AeBDieunhKFGL3R0P9wfYwRSHCaS1S305vvGOPDMWR4x+56b2b3xe4dOj09VA83ubq1
	A7MUUDyYmFpkZa1GlKy6iBZB0XhaaGlbX/WBlnr7svHA52YlrfSV64trenzN6Pk4NSL27C9BBb4
	9xsrcxIKvVsnDHz1GtWsrckXQ+sBQHgnktQ+Hzz/EC0vMxP0UwxZp9OPr8f+ac5Codfmxlr7For
	pCvpP7GOSwcygyU7FLJfvn1A1nHbq627qQ/B721dRSBCOWigTgxasbBwd0nvXxHtKnHdwjSgCGm
	jefgkjxuVPtFYJzIlQ5Hq6FlKQ/Ns5+skXvvIdIJPM3XTpKCgL4evuMhmb5Yw1L+VlQpI+fyDiK
	rzduT8wjqDe/qwjDpoHLXIGAzYDkmlOwL2KClLrDS8CmDYOXkeCRWFjtigpkgnZN7FAECMLxiCQ
	MEydqsh3X+47ZTT5/zUPOW4/XAyk6IJs0KCGwv553WSvKn0CTlPwBtTsnThjOuGZA=
X-Received: by 2002:a05:620a:460e:b0:8dc:3a83:9c08 with SMTP id af79cd13be357-8e789c5a0aamr1049192885a.7.1776571913676;
        Sat, 18 Apr 2026 21:11:53 -0700 (PDT)
Received: from inky.localdomain ([2607:fb91:4c8b:380b:91a:9dec:26e7:3d7e])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e7d5fe98dcsm508388385a.7.2026.04.18.21.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 21:11:53 -0700 (PDT)
From: Charlie Jenkins <thecharlesjenkins@gmail.com>
Subject: [PATCH 0/2] Documentation/binfmt-misc.rst: Clarify "P" flag
Date: Sun, 19 Apr 2026 00:11:01 -0400
Message-Id: <20260419-binfmt_misc_doc_update_p-v1-0-757c12f33cc2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANVV5GkC/x3MQQqAIBBA0avErBOmkoiuEiHmTDWLTLQiiO6et
 HyL/x9IHIUT9MUDkS9JsvuMqizArdYvrISyoca6RV11ahI/b4fZJDlDuzNnIHuwCQqtdhM1hBo
 t5DxEnuX+18P4vh/sGE9RagAAAA==
X-Change-ID: 20260418-binfmt_misc_doc_update_p-0a4cbd3d040a
To: Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Kees Cook <kees@kernel.org>
Cc: linux-doc@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Charlie Jenkins <thecharlesjenkins@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776571911; l=706;
 i=thecharlesjenkins@gmail.com; s=2026030; h=from:subject:message-id;
 bh=rwkZyPJHowgTvteFIKcMHs2QMro7vvfl61B+ONhW7eQ=;
 b=uTi176URT93ETW9wBjN6zZXUrjhyrUdfRr1vSDJuCme+FIlFtDY/vCj5hw4TExP4+QVGT7iX1
 H5JIwfhdRWCAY6kHIyRut/iwSDPeiQOyB9JWJXN457UCiNRhYw+3RdV
X-Developer-Key: i=thecharlesjenkins@gmail.com; a=ed25519;
 pk=vpF2USrG+aB6CTbSt34rzJKsAVe/l+GAXo1IomCMETk=
X-Rspamd-Queue-Id: A5F15A0005
X-Stat-Signature: sifoos1yddhgnsx7ty1bsm97mf1xraym
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776571914-518971
X-HE-Meta: U2FsdGVkX18OV416GQ5n/bcc9ymToY/Qo8f8Wqk4NRHQbW4vKrtcj5Rj1XjFj9ze4jEk+NUw0NHr94dablu72uIzFgNh7GsbF6G7AQVjH3JidEGOELpWwWsvXHjNe53pFhyUvGM8K3SqbDXVIOcJGlfJWnfu8aAQNOdkjFY/WFtUgxV4J/rKc5p2xKrLLGBOJMm1sUAukd1XZJ6EDLV7WE7WPZ4VoMEqc2cdmoOsc5Qs7Ph0GWP7GYQYzee87JOfe/iCI584i3dPP08dyVQQbrwBgPNOsWUFloR+YMsNYcE3dzF6zIJxdJEmyJJJCPvDlqQan1FrMjePYng+QTXwMpI81tkLTf+gbqd4YzWd0+3CBv7/p+zsLL/OtfW41jEc52IBppfBNQX37uOkcDts7Llim7Mfp2HEtq7pL/Mh5dYcXwqDopUEXzJCSMggp1APv00b5EPhh+T/anwcRbKkNq2oUiGW93HIFguLH4IpyaUEXegQtszks3yYu1yKhrGTkR7YCZFUqp4amI6zib8eVubmGA/o+AnpnRxAGMzJn9fsOVwbYyW/2X4EMzlFb+mUNFZJJAr11XIxTe4DlyuDemUmMT0dYE9wvsOkSxxX2VXzl6YFlrxFE0Um67oSSNE8C6zUIGor+MqSmio+KpNOl/9uwlq9nITvPr5Qr2tCRUtCKOhJAuaa9pcXdHIGI3AN13YL1Hy45e7TR1r3cgf+0rYqF4qSzJPdGgt7jwFxfdpb/Eqewlna4QZcJn97qrTYstSE6ym4o0M5VJAd4rhs4y6TVgI5eZNReyhsJP3lyiljTDUwA3Bi1NhNrOUefPjuTkHnWzpMIpUAfV+0QtTvhSQyfcQCOZH1TXCSbIP/1PMe5RfiPJpTLZmPs+G6Fj4MNJPyNHWQiFCzMSZgZBTXqo9mKI7KPlMImKRjbi8fyK3LzUjb1WCJjctDhN+PlKL+OhWKQPeDDTz1f1FqYcq
 6ATLW7CH
 DlusMU0ChQUoW8nUSTX84/CWDic4K4wIaSU+FU4nieYsUv73Tzx+BuivU+VaokPjAGl+5URw9dopPlERpe1gdE5cniRWxo/whiFEiWt3CdLxYOpYELVOGOdcWuOkcqm/DUtGER7NgaUHT9rwFvsYvDXmO9w6mDrbVC3mS3EMTi2I1lOK8PP580145gPqy8Qx+sKTrKvHER8Szoe3vmQeiOl8ehDXjDi29GkFR1ieMRStRWk9UF1Xbo/v8XaMD8LkymsFJIuOyGeX+DqgZrSpxKlI1cGSwzaBqGUPA31iefalWALNqoKJ7QkPSgF+U/kP81rysXTmyl3SEdNKgf9YlNm9mAQfMc3Sdp38PztuE9pMk3jOIUZ0tTgyVn3BC2R0tWNF+hgr6fXqi6T1nlRgkMUuhcAZhgyZZD/rJvt0zpox+kIXEsCjQrNYZDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Improve the wording of the description of the "P" flag to explain that
the interpreter gets the path to the file provided by execve and not the
full path as well as documenting that AT_FLAGS can be read to see if the
"P" flag is set.

Signed-off-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
---
Charlie Jenkins (2):
      Documentation/binfmt-misc.rst: Include AT_FLAGS info in "P" flag description
      Documenation/binfmt-misc.rst: Make "P" flag path desc more precise

 Documentation/admin-guide/binfmt-misc.rst | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)
---
base-commit: 028ef9c96e96197026887c0f092424679298aae8
change-id: ${change-id}

- Charlie


