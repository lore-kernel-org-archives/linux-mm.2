Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF8B9606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 17:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OybFi93o
Received: by kanga.kvack.org (Postfix)
	id B0A676B0BBD; Fri, 23 Oct 2026 13:50:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A94276B0BBE; Fri, 23 Oct 2026 13:50:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95C286B0BBF; Fri, 23 Oct 2026 13:50:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 60A9B6B0BBD
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:50:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B48271C1730
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:50:46 +0000 (UTC)
X-FDA: 85354631292.14.A542EFF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id AD5FC40011
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:50:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OybFi93o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf01.hostedemail.com: domain of devnull+atanaskunchev.proton.me@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+atanaskunchev.proton.me@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792777844;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=meBRCLrwDaxtspgAamwB33hzav8w5yaWIMRhgDTGTsA=;
	b=nIPVDzayDeHaVD9UcIcpNgBa+/P+j3Ac4zVpxr6FH6LiAQ3zpoQqpwzYzYfY4ztgAeEzuQ
	QStvUXOhJpW97zapC1R0WyPwSPDw/QshwXvQpelRJhyZzlAjcBNYkdq6u1nEoLdsbu7Zr0
	21/JkH/85fBwxQyWvpICDRjObn33nU4=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OybFi93o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf01.hostedemail.com: domain of devnull+atanaskunchev.proton.me@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+atanaskunchev.proton.me@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792777844;
	b=qSxVYGmkA5JXscEEaH8OavxAyy/G45dYJ+TFeClzqQTFObRKlnb3BjWeHpgzoQLdjXLWKD
	xgSw37JIlptqIArK5Dl09Lqyko2gaMHsDBFu5NLoHvmANKVToagvQQEZov7MznYhS86ONI
	OcDmwpLZiENIwOXZjCd3t66dUDo1970=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 33F7E601DE;
	Fri, 23 Oct 2026 17:50:44 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792777843;
	b=xriVuTDv+8mX+qvh+yHbzm26FEUPhTmzZOZnrlooNDuMCAKu7qW/eoO5GIGDytUESZez
	 kjKPbO5f7PbAsD+VVxWnQZRQ0zzA30kpcM/jrEXvA/ASEmbrhbEEqLUAAWDqDj/pBY4qM
	 PIaCxTAOJVztakR/XbTM77lVOo22Jex/ZU0NepqkRuSgaLKqoT/708Q82UYBMA9BrearU
	 k24e6uaeiKrA1QKiF8cQLx6sMa1fwlJj24GvmI2OuR0lNetvDZYtcGMt8/1gBLx4z/m3M
	 afzOGhHfL4ZWKu7CbW4ZuPhKUp54RmfYKJf0azNGgACZZjH6qUj7sZCRwfVtZd8DX/A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792777843;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=meBRCLrwDaxtspgAamwB33hzav8w5yaWIMRhgDTGTsA=;
	b=gDHKmd4Y1b3jaOxGVnVWnKxoB+MWpMdu2zP8/tVVkgPawF389yu5M+PScwdWvPz8kKzF
	 0NV1VjeOMqC5TvGcXfISm+1VQB62/JuE3+5lM/mSblUxtwgAsEx1p6r3AiUdEiL8gRMYm
	 FLgbUV80uz+71OFBoD0U141eEFLzLqBNbi26aIGPkWztK045LXOKqjoa6cD2mAfaHy5Wr
	 2diawbVCBhvMGq1vpCjBLEoXqe87WTkAk2Itx4NrMhQTqshRw28tY/SDUUOLWernY83x3
	 a08rsNGFxf2w+FZpSeHSbloSW9REKgFhcW8GZ7hOrIKvdl4GNOtHBVnsac0m0oVS7MQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 6F6B01F01825;
	Fri, 23 Oct 2026 17:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792777843;
	bh=meBRCLrwDaxtspgAamwB33hzav8w5yaWIMRhgDTGTsA=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=OybFi93olWUQw/1/Z1JToW+nm3c9XKX6mzBRWeB8M5YPRM5X9ndf4LwFgbXjEA1IW
	 N8UQgWokNwOqmPwa/QkbeS8sRGr3lM7+roR+S7zZzorzc1C3ERf32OPR0Nq2ldFSgc
	 2vlmRLFmXBW+tySf3v95iRHwAkIclT2j9pa1NYHopI+HzJzCKW8zzgrN4b8rPl3XJ1
	 1qvW+SEnnbdh/L3bPGNZuYppKvj99Nm598bTAQRx7PAyHBHRITFjACt9633Y3xF1QN
	 HHpAdZeyWQYluIkkl/wR2gzv04yJAawaNjafd18F1ExQnmvxBmuUDOK3GYzvGVj5J+
	 boRECBQ+6p34Q==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id F0A9D445B0;
	Fri, 23 Oct 2026 17:50:42 +0000 (UTC)
From: Atanas Kunchev via B4 Relay <devnull+atanaskunchev.proton.me@kernel.org>
Date: Fri, 23 Oct 2026 20:50:46 +0300
Subject: [PATCH] binfmt_misc: fix typo in "auxiliary vector"
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261023-binfmt-typo-v1-1-459d4ae4c15f@proton.me>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDAyNj3aTMvLTcEt2SyoJ83aQ0CwNjA4tUI+NEAyWgjoKi1LTMCrBp0bG
 1tQAdmKLbXQAAAA==
X-Change-ID: 20261023-binfmt-typo-bf80308e23a0
To: Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Kees Cook <kees@kernel.org>
Cc: linux-doc@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Atanas Kunchev <atanaskunchev@proton.me>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792777850; l=1335;
 i=atanaskunchev@proton.me; h=from:subject:message-id;
 bh=2pX207vjhqtmwxK8nx0gyejv0Uothbk71WYMMlsUqzE=;
 b=i+SyRbqcik8GaT3nZQP2XAj+MD0WuTUYKk0+RqJXTY1hmJRh3SVhNMZVhmwU6sfTZE4EWoxjC
 SPZqpebrdTsDyccHoSkYYW+NhTYP+yBCsPr7XWkTpW8az2jyHj2eFRx
X-Developer-Key: i=atanaskunchev@proton.me; a=ed25519;
 pk=UZOV7XzSdjoak/BahXi4m/UsbdgtIb1vQI3+u1lAHOc=
X-Endpoint-Received: by B4 Relay for atanaskunchev@proton.me/default with
 auth_id=1293
X-Original-From: Atanas Kunchev <atanaskunchev@proton.me>
Reply-To: atanaskunchev@proton.me
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AD5FC40011
X-Stat-Signature: a7htinh4zed6fqxinzj4ysw6bktq18ay
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792777844-626787
X-HE-Meta: U2FsdGVkX1+aPqh8Ey8dunsuTCtIeWS530zJ06OTBcNSThWqrovpWzW+yE+/qCff0TBG669KZgKIMZjKpdNhbD6u/rvy33Uze1UevImEiBpDWSlalUBbPsuslh8MI62B6YM12mEIAmKEocqqfwOjLRNJmzIFg/MUoKFUkbWF+rFvhHhsBP5hMYEh0HO53jyTTv4BG3siJBb0/mNkfrq/M6IU/U3TATPlfSeKAypDNZO7L906jOgLqxeOTaykBTOo7QT+k9eVT4jgkkBiKmDSjvCS7whQUItUlUcQLGDk46BAcgI+3loyA0vF8B7beTm5rd6mnzGoUtccOF9Ml7AzBpuiYoRLCWfC5sbtWefO5puM80DYYzSoZwpJsKShaZnQH66+tS2lKII2clTAD/69MYCCK+IxqB5MnvTf0C0KepGjuE8s+A6EeCArrDr/CS3mCHAmRbWcjBdMT74gbni19MMpFEzsw8rRcK7gapfr5p2Pmtoj1HpsScywNcfl1dCVjKjouGOewXPK7FquPd/AuChYchUbtzYtLcazMnYUClpOWu7rKPUtA1x42z/VF/aWyntfm/P3JKmPnZba5nYSG5+UGYVVZoQtLrxgcJuGp4c85t6wzgPwcYQq+N+JnoVZCPef5K1aES4MkH/0YDzUsB5PShPqSnXj0gpjtVbXxMkqqZTcksBak8pYFC+Zd4Obo4zN68PJgZ9iS6cKNSngjy8PwNHag24J64DZbYFzivpgy9MdUKL09ioPU8ZmRbjb4pcyz9CuaIu2eF2x7Git+WW/yoHw9yQslpY7P87PGZEeNNeRs8JglIjyQJl1GdndTd7SpHF03ARhwRartnROo7tEdF/oSS9N6e0YU4p+ZsB7hh63QCByxyy8RhPreB+s3nGEscf9H5JeWWfjWthckUTlpe9yoAboJwhJJ0j3o0LrIwCb5abGCiO28Q384FPtNQQxqw+t1romGIHQQvE
 mgtDVFee
 TUAC7MynS3AzgHtB9ilpwsH6vZnXZonqoLhfl2+emhN2V9WaKozfrVWV9qSfebSwgerMgon1d9ZRReYM6tNX30FXb8vjlkqpaSThbeUngX4QaRNBNpki2hhv6I7qVgqjuR3pM6XmD11OmX7NzRkOtJ3RbJPvV1/eocvxV4JhA/GI0XwDZqDly6kH5rx0/a+w6SsX0v3A/H8kW62nPu8GGywlflo/KuKi5P27QSg0ZacvkTnqsY1Lqa9gD72bEVTBfNMUq9nS8WNuO7N2m6YvrCU/OazvmPiCFR/m3iEXuBYlocWAP52kJVlyM0hr1yDy48l7BEJw+/0ajKE01HMCN0OidlC6aZyYK2DJJbBaT2315C+/7ju2Voo87j/DG+kl0rThRxloZ015Ub0bM1AdqtSHLrNJqltOrBzBUef2G99oiM9y//0/lR6mJyEsPfLxPu8Rqp7qKUlAALnGBhcFEL6nsC5ImRDgsLKco0ciiR3RhvT3ganUkBI8E3WMXE1q4AoBR280dm9AQQ0+ozvYjva5xPkqpxE/1hKzm+HiGqgxk/kOhxUaOtk4F55wQyXhQVjiFmFaV1UPxz/A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Atanas Kunchev <atanaskunchev@proton.me>

Fix "auxilary" -> "auxiliary".

Signed-off-by: Atanas Kunchev <atanaskunchev@proton.me>
---
Fix a spelling mistake in the binfmt_misc documentation.
---
 Documentation/admin-guide/binfmt-misc.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/binfmt-misc.rst b/Documentation/admin-guide/binfmt-misc.rst
index 9e84b877d06d..e37668371453 100644
--- a/Documentation/admin-guide/binfmt-misc.rst
+++ b/Documentation/admin-guide/binfmt-misc.rst
@@ -73,7 +73,7 @@ Here is what the fields mean:
 	    Legacy behavior of binfmt_misc is to pass the full path
             of the binary to the interpreter as an argument. When this flag is
             included, binfmt_misc will open the file for reading and pass its
-            descriptor into the auxilary vector with the key "AT_EXECFD", thus
+            descriptor into the auxiliary vector with the key "AT_EXECFD", thus
             allowing the interpreter to execute non-readable binaries. This
             feature should be used with care - the interpreter has to be trusted
             not to emit the contents of the non-readable binary.

---
base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
change-id: 20261023-binfmt-typo-bf80308e23a0

Best regards,
-- 
Atanas Kunchev <atanaskunchev@proton.me>



