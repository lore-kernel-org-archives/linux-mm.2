Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64F1FC55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 13:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAC3A6B0096; Thu, 30 Jul 2026 09:34:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5D406B0098; Thu, 30 Jul 2026 09:34:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9A306B0099; Thu, 30 Jul 2026 09:34:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD2016B0096
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:34:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B5D6B1C00DC
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:34:56 +0000 (UTC)
X-FDA: 85045538592.11.0F0226A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id DD9B1140009
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:34:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kpD6ZCDp;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785418495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d90a+IuGYr7k1vJHi62UpvEXaFbPpLFLGqIFk5fm34Y=;
	b=BfbRU33kZu/hTRhb/9OAih09zcG8QIMYiermQ8PWaDqwEMDqpOs5YhdkyqtWAZSgg8ocKr
	y5aeAhJ+WWlKFlAnjmtHuve/2dYwp4J2nB5lVYr3ZRLOMSlTOtZ4yN25Ivw7bkG0xsdpnV
	CuJyjmEiQIUYJzOB4+mq+xfQJVant/c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kpD6ZCDp;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785418495;
	b=8FugVilX6i+H66uRjCnxwD9qsz0M9VjmJdrJuOf7rAUavrggpTdYT3Oj3G+KHEn39CJpXC
	vcr8SAtznlGJ1qteUneLN+gbmKO69uwGVXK1/E7YHINLL7E/Czi2tFozI2sZ+7FqkeA4bR
	yiSOmvaFZiV8mbIzgKu1JXymlUxFQEE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2BFA44051B;
	Thu, 30 Jul 2026 13:34:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D8B1F00A3D;
	Thu, 30 Jul 2026 13:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785418494;
	bh=d90a+IuGYr7k1vJHi62UpvEXaFbPpLFLGqIFk5fm34Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kpD6ZCDpRUDEVRZEQxHAn3/f0p4jsUl69dWThamJMiEKtEuJ0bOMyCV/OZ0YQxxJZ
	 h7vWZntQEMoU4ZLtpnChFr/eWY+En/DZN+jhg7GtQ7ZTbz1E5G98bkOTEXsecNjoni
	 BUuUohpkFIWRGLhtnDpJMr5BO4xtVVPpWzGBflICX454aBYxDONH9OYnu0BEteqtP9
	 6rxnk4PfzGyMxw6PPaKUponVYPBJcTPEKrF+oSdsXryuWlH0bzqK8OjLYZKK7nKk9d
	 SxxTLxx9zzYCVEitPPekrkX6xa4HsJF/yiFiImzv1Gqpz22j3eL1h4FhoxEHhH7tiz
	 b9WGYe7N4uTxw==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 30 Jul 2026 15:34:06 +0200
Subject: [PATCH 4/9] binfmt_misc: document registering an entry disabled
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-work-binfmt_misc-preopen-v1-4-4a0b0da71f16@kernel.org>
References: <20260730-work-binfmt_misc-preopen-v1-0-4a0b0da71f16@kernel.org>
In-Reply-To: <20260730-work-binfmt_misc-preopen-v1-0-4a0b0da71f16@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 Jonathan Corbet <corbet@lwn.net>, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, 
 jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-3e0c3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2413; i=brauner@kernel.org;
 h=from:subject:message-id; bh=JwE3rtGBn2iCx+TRsmqXKFLG9WMlHl4uFYo2z04LHvw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRlB70TuXCE755s+mnNIncukYnyTPPmnFmzRu7qE9Z6v
 UaFAm/tjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIkk72f4w2c/Y0/prm+SqosW
 3RO7sUW3mPHwD0VXPd84qaKkzLe9MQy/2Q9MO+V/W3NPkHvY7S89efccslMvS56ZwDPp+D/Nt16
 b2AE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DD9B1140009
X-Stat-Signature: 6p6futd7f46rneqzdfsmpzyid4s9wdzg
X-HE-Tag: 1785418494-434066
X-HE-Meta: U2FsdGVkX19PKUDl4ktgZvUJegGQKgvuPGKYu1qF7ckyc/PWa6dhAF2hn3drFUXa7ayejyGr6XgKna+fPPBPgwJa6vYS4BGlo6QjXHaXfnJnHci7Uzl+j0ZgbtLtp8B1M9T8aei1WssRQ34OBRbYOgyJLuhT0w1TQVCf5l/rupS/QyoY6ZdSRp10D8KS7eSQ9ksFwfZQLj4A1sYaYkm1D8Wb9R5RJ8ImUt16rju4uMW8qyezLpzy0BmiuFWZweB4zEU9zVEIftG1JEGTCi/C/WKbTO62y8dACk6ZekQcNQAHjcnv87x9Ss/6lLO/56rRcp+lcv2uzcWbGsyB0OmT27zo7TIorjrQNRLIHHUv6MxQJGTHHfXU5vXoO9G5TCrdZVVjOGmeL+g8oIGZQpfVaBMTJIjFqAAoh1cs0hKnvqF6OTgAvsjLRHBotsWpX+0fj3pJbzpckQJF4ZseZ03Qq1ZxCat8YVgEbc2EDX9RqyoV0yYJiVeNLYPn1tMJvJX0VlCnZ1dZygTQVdmfFPCyXUN6IrQ9Khrv0lCh6PUUxowPoUjX2RkQbufEqLVevTogl8s0wPoSXTalVKBDcffAFSjshdDx6Etdovnlc8g93xPVwjkSbPuxqj8/MAccuepheSvVAwtUC3HO6A6Mxns3wmMfdtmJgOVmeRpBLJk34DHqHblfEoUivsbRg4dlrhUsdayFG1M388mx+Tyv78q+J9RPaXWhwJU3OVCH21+8eXkAF5wHscPAzCKgRj0yMFhwd+rLRGkqK1Pp+GUsuMVsDo5QI2jnopOyDUQKQls1U1FU4evpI6MLM96fwynEizjal/D2m7FxzkrMb05HEZGovaNew/3uWovMzaOMbszg6z9JAS3swGy4VYQ8qx+p6R0Au4dL+VANF6dm31oL0aDrwyoGeGL0vTb2SlJH05WHHyF0jULHfJ8fJ10yJk8i12iB+DwfcoX/6j7iRDTJPTh
 PoMrbv0f
 WJtRaX/d6iSF+uP1jDkTKcnnnaOS7Ly50cJSF9CNFHfDn0vR3Bda8LLju0KJSkv6iMr0fzAw/+bG8Dow9MibxP7U3xg6qukavcYrnzE3U9PHjr0wZmwT6ZEPLT4Bl93DuYYgldkkyTvVcel/BZuT94Ur0Sk1WtJp67Msqf/xnskN9f0GBl0sxKqXbRQ4TPgMGAMZbFTwHvq/joaVNWlId+5knhaYsck2ma8PCuUM0uuD/LbwQPV77dPwEemaelYKrH0cHklk/g5D9H71HbjmJBwQaHMHnVfpfzX1OUWT21New/ux8qWchdMMOcsmO2dA1R05/HxzHShjEamk6ZtapQUG1KjqR0aF2/8ecfVVekMmLULZy9d3LnZ+UPrkZj96ErMgdwsdMlzUByBQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Describe the 'D' flag and what it changes about a registration:

- that the entry has to be enabled before it dispatches anything
- and that the flag is not read back

Scope the bpf section's "carries no flags" rule to invocation flags now
that 'D' composes with 'B'.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/admin-guide/binfmt-misc.rst | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/binfmt-misc.rst b/Documentation/admin-guide/binfmt-misc.rst
index c80702b4ccd5..8254ddcb3389 100644
--- a/Documentation/admin-guide/binfmt-misc.rst
+++ b/Documentation/admin-guide/binfmt-misc.rst
@@ -107,6 +107,15 @@ Here is what the fields mean:
             ``PT_INTERP``. See the "Loader substitution" section
             below. ``L`` rejects ``T``, ``P``, ``O`` and ``C``;
             ``F`` composes.
+      ``D`` - registered disabled
+            The entry is created disabled instead of being matchable at
+            once, and has to be enabled by writing ``1`` to its file
+            before it dispatches anything. This splits a registration
+            into creating the entry and activating it, leaving room to
+            configure it in between - which is what a ``B`` entry that
+            binds interpreters needs; see the bpf section below. The flag
+            is spent on the registration and is not read back: what an
+            entry file reports afterwards is whether it is enabled.
 
 
 There are some restrictions:
@@ -224,8 +233,10 @@ handler can decide them differently for each binary it handles:
   ``PT_INTERP`` and runs the binary as a fully native exec (the ``L``
   flag). It excludes the other flags and a staged interpreter argument.
 
-Because these are program choices, a ``B`` entry carries no flags in the
-register string; ``F`` (pre-open a fixed interpreter) has no meaning for it.
+Because these are program choices, a ``B`` entry carries no invocation
+flags in the register string; ``F`` (pre-open a fixed interpreter) has no
+meaning for it. The registration directive ``D`` is the exception: it
+decides how the entry starts out, not how the interpreter is invoked.
 
 Handlers are looked up in the user namespace the struct_ops map was
 registered in, falling back to ancestor namespaces, mirroring how

-- 
2.53.0


