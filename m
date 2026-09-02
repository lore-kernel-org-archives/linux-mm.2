Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2A7FC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:41:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB67F6B0096; Wed,  2 Sep 2026 10:41:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3F496B00A9; Wed,  2 Sep 2026 10:41:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B06E96B00C4; Wed,  2 Sep 2026 10:41:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8AFFF6B0096
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:41:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E162C022E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:41:24 +0000 (UTC)
X-FDA: 85169085288.14.A67055A
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id 31AB718000E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:41:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=Fqw8hv2A;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=iovGKDVk;
	spf=pass (imf06.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.171 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788360082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4enQh/HRN5i8ej4OSTmzFcG+vE6phZ74enUPad5j238=;
	b=KidNMOjB0iGPQ1nBE9sQCMrjRVlyhcvG9ocpjGS5V7vaG0FBU2+bjyGR5OX0uCYExAPfpe
	IUskpCgLQ+gyvs97tLJ/DRl6ZU53m6aHassoBAkI7hqIR6cjOvBXFo89RrFcb29iUZzT6m
	lEth0+xsZZbA7IcA3qpLbG4C0Lmj+N0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788360082;
	b=AHnPcmDy9FkBWtuwxspVbBgoIcBPIs0vuF5ACPbfjtKbBRHQwiqUYAokWHe2HC6VMtqK8J
	pDak0P5F/zGOz3bcfCDjZlaPuLAOWE6T/0Sz3koXgrBx4yHs6dJ891ocuX+20bvnHgE2ff
	/Iinbt9FRPF7zLRl0Uqlzx3BZLLI39g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=Fqw8hv2A;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=iovGKDVk;
	spf=pass (imf06.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.171 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4hZlm05y6hzMlBB;
	Wed, 02 Sep 2026 16:41:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1788360080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4enQh/HRN5i8ej4OSTmzFcG+vE6phZ74enUPad5j238=;
	b=Fqw8hv2Ao0Y5A+xcInh0xP5xiVRqCrlgE/F8FI0utG8+7BPjpp2VpqdmWKv/h/7w2GpzaX
	xa322Kxw0E7mpc/B1pGSCpkQtEmdZmpixLtydqKz7FhNFONzE6rCpwhY9RnojvQH3DrB4z
	HZatkzU6NqeoHB1XhH12YbSi6iXkP/FXCqhekKbJAyRHh/ykbmtwVHxhkmWDO8jUK/mm1C
	AYT4L4YgUFsx0Zq3OQxBlaxcWGYibSuY9klwxREPni7ply1FaZNRB9spuhOpoNnCgllnw8
	aqzebRFlIemfcJXMRiqe4EosGoTCw+Cz/pdU1ZkZtgq3y8aNrPrz/8XPqIVwSQ==
From: Manuel Ebner <manuelebnerli@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1788360079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4enQh/HRN5i8ej4OSTmzFcG+vE6phZ74enUPad5j238=;
	b=iovGKDVki+JnqDpcKXRTDvggE1fGau7uLL2Viz4jKRlXhqYb1aCOw+hTxJQYiUf0WNTvkp
	BjQjNbCD31VFqYmJrsY2JpIoLbsggO+e2+ZaYuAqbHJGP5bVnkj0OCtp2/OmfKrbDR8sEj
	MidFLJpXanL+MfaTcfZ3xyKibPeGC4gwiGYmayjIheBjUWl2+gsOQsp35FwC6w5Iuj0ltJ
	8SFPX5a3gjEJviXRinZKX+MXPuw4bSmh6hAOKdCIxi60X/FPMEwsi/VIx7RXz0tvmzkdT2
	fhjcvKZzI0tJdoBKPWyamUkdhzxEYhXBX7JN7yBH1kRZQqU6MgoIDQSRKgSM1w==
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] docs: locking: Fix bracket
Date: Wed,  2 Sep 2026 16:39:38 +0200
Message-ID: <20260902143936.703665-4-manuelebnerli@mailbox.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-ID: 50c532a2ac21d6ca7ec
X-MBO-RS-META: k6xm1ysjhyaxg4ron4ywibt1c4uihwua
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 31AB718000E
X-Stat-Signature: 7wrb7w8k1i3k95d86fcrf6x8fpcbgut7
X-HE-Tag: 1788360082-362391
X-HE-Meta: U2FsdGVkX1+4qFs+R3lDUXC38nnRYXio9g6KUnDUljZiysSyynR6srxLOSrs+Io3erkvxzV4GE7HCuguYxqlqPquix2/Ubxs0Koa9u7P5EOdBKLBBZB9SWbZ1LQKQl48fPAGIgdGEETt6jopqzcUbi9v5XHG3p5y9qYCuQyqhjqjBCB+3zJs9UnhBG5nDaXIk/93pLXpBPMol6XGC97cIo7XoBRMA6u7x71cwoERHHotAteCruAqCPtrP8Vxsjc2Q5zMKGo2W8Xw5b+JtWf2MrM5BZv8UCyaKyb+d0XJtS1Yna2RWQNwGpz8BknjemkevUGV1Oy+rzxEoykD8Pq000dWM5yIz1M+eTuIt89LzNfuvF/iioc3bvnU3mTTyd3Y8dcmWJSmFJFo3Scn2Y33SHuHq6hg/N9hK7SheTyCjCwnyi4W8R+HfCg6PdeYL+zAaS3PCmyBN6POR7HlT9jpfCX7EeDzpuDvxWpzP1/jZybTuS3257fsFDX4QDWat0jqM/4rPtXv/8etJAkyI1qPpPR4olO59Ki4+PRbTAlSnXZfZFc1psrRGnLIVibhqO8b4Ut41JuKCDulQekMBRVOg9z7rfZSk//iy+33sqefn1cZJmnPYtIF0eK8GAXs4Zelu9Gp/r3R26CqjkcLlDyyPYwY3mdPwIP6QHpk77qYWBioJlha6pt93mlk4QSmUKnFkw9JZ7KVVwtoLCQx8QiJr9vubNU5gm+XUOyJr22HhsrWg+Dww7UdqAg2hmAzWfuR2nA4zUBm0cFmVdqWlaBpn/vZfkzY3/Ljd75zF9KNH4q8lp+wU7zSE1GCltN+3YuNgzlh0FdRN/2bHcnp5d0QFFLlFW0Dx33yHxXJIIP3Mpi9CzgAmhu9UgbvopoHHsckwFqNmUuM5WjwoE0d8orJcRYMM08uKDLkmIZJIkPqqtAM7Xy/qnZyC3kNtewBaI6v4EjSA5SmbZZpnimHwi2
 CQI1GVjj
 oTY9L0jKbnhKaohIVPXW8Mc9umttja8+lNWhufOCtqfGdYFNEmj3fl6U4GGdhnCORe9S5j4gc/xnenQxSvt4b94T2ghmP/bT7o0e28v2N+LCf8WLBS+FbH1Fsor5TinOUjDkJ+Ic77Ujq/EES6Kp4XJau8KlMgLh6qg1IqD1ixzC4UWBRxaMDIaSh+1A+ILADKG/wvU7ePvP15Qyy1Uch2dYIgcQkFcyKk/SGzrdbvGuuTMUYwJ0meUB8La17pv9Z1md4Q87/q72VgGVHtbeEaG2Em9xGzOZKR8uuxSyMVbffCgOwh7AKssI8FOkdxRGbJUe2dGUf296UXaE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove needless '(' from code block.

Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
---
Should I also replace ')(' with ') (' as it is in the second code block?
It would improve readability in my opinion.
---
 Documentation/filesystems/locking.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index 844d65eb4..1598cf555 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -27,7 +27,7 @@ prototypes::
 	int (*d_init)(struct dentry *);
 	void (*d_release)(struct dentry *);
 	void (*d_iput)(struct dentry *, struct inode *);
-	char *(*d_dname)((struct dentry *dentry, char *buffer, int buflen);
+	char *(*d_dname)(struct dentry *dentry, char *buffer, int buflen);
 	struct vfsmount *(*d_automount)(struct path *path);
 	int (*d_manage)(const struct path *, bool);
 	struct dentry *(*d_real)(struct dentry *, enum d_real_type type);
-- 
2.54.0


