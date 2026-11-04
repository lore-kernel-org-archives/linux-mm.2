Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 769E5606F69B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lTidc3ZG
Received: by kanga.kvack.org (Postfix)
	id 8C7106B05C7; Wed,  4 Nov 2026 12:51:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8504C6B05C8; Wed,  4 Nov 2026 12:51:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 718D96B05C9; Wed,  4 Nov 2026 12:51:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46CF96B05C7
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:51:34 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C15771C3E91
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:51:33 +0000 (UTC)
X-FDA: 85398178866.30.2C2A04B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4BA2920006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:51:33 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lTidc3ZG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793814692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E1vD3O9CKVYh6HjmlrAgiThE5xPMlSXjct4LkBIJ4ZU=;
	b=yeHxbzXYjf03ZQlPa9ikr9H/TuwfhPZh8ECK96e0LVuWZla2JYKlS/XfdSmy6D0b+1r2jT
	6sHQ8PqtWynu5yE9ntvrAQgWvdhizMVvIf5+S5z0LY7jkphiepvtgxIjI6qXqqC7eej1Vq
	U72YA3k42uVLeqjgp7nEgYr82/cimrw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793814692;
	b=uB4YDZzFYZJwTAvtDlM9Uvc8rnZWO3UXGaeCZItlmHpuc4i9uekKy+Bf0YyyjiSyHdjRjN
	YXFcNjVr4iIPeWkxfaeqI1RINC/uFWO9OXslnt7Z0dqi2Y9vLT8Wk8WxT6BF00bH11xClR
	td83rdFcOY4e3gLrVLfOlw4vg5JgJ80=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lTidc3ZG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 783FD6022B;
	Wed,  4 Nov 2026 17:51:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80441F00A02;
	Wed,  4 Nov 2026 17:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793814691;
	bh=E1vD3O9CKVYh6HjmlrAgiThE5xPMlSXjct4LkBIJ4ZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lTidc3ZG6DQkI9Vk+Zr6nZ+0Pv1ariRcKWpOZaHjUB13/k2sNBbs30yiyX6+yiHy0
	 XhLfUtzeKsMd2s14fzVjing8mXsTg9GPVyF+D7HxhM2JOno/05h8QGJ/OpDZLb1a89
	 5iNXriM20a3P8IKms8b+BrHgWU6kuTMh93epfuFbUMMIK8HZeuqdJpXYBJIe048tZu
	 t4MbQPatcoNdgYXUZlH/wZ14ucEumOSXNnrypsHgJpuEpbivjwib5dficqpT+MTkRc
	 eQanYcp7xT94DAQBNNR7JiADvWmbMOHcylJkVfCfUONsNhiW+36Oqtvx1ELJajB8v4
	 nA7YJqJ0gMb4w==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jann Horn <jannh@google.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Chris Mason <mason@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Eric Dumazet <edumazet@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jonathan Corbet <corbet@lwn.net>,
	Christoph Hellwig <hch@lst.de>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Joel Granados <joel.granados@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jan Kara <jack@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	netdev@vger.kernel.org,
	ntfs3@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	coreteam@netfilter.org,
	kexec@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-sound@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	ibm-acpi-devel@lists.sourceforge.net,
	jfs-discussion@lists.sourceforge.net,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-mm@kvack.org,
	linux-sh@vger.kernel.org,
	linux-usb@vger.kernel.org,
	samba-technical@lists.samba.org,
	sparclinux@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-doc@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-atm-general@lists.sourceforge.net,
	Takashi Iwai <tiwai@suse.de>,
	linux-input@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH v2 24/51] scsi: ips: don't return 0 from writes to the proc file
Date: Wed,  4 Nov 2026 18:47:10 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-24-bbf7d5546809@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=745; i=brauner@kernel.org; h=from:subject:message-id; bh=M56s+R4IzmhMvI79F+bEsnRzyAX8hD//ktSOts+7Usw=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9zrsjdmyn4qx5nPEffu759zLB8uCtDwzMpk9O5goJN X+S1b3I1FHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRo56MDM07m/kvz13dEbyc 8YVpQHNuxt6bEwLeph3epTM1uHvJ4kUM/4snuhUu6e/oc1L7a7B1wvUwTdl7eYU5DM2B9etlHzK msAIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: orjssojooezwza3es9a7rydtaypxhpbj
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4BA2920006
X-HE-Tag: 1793814693-226320
X-HE-Meta: U2FsdGVkX1/duqoTEAbilAEN1YCdHNmoVrNCWwtFEVQJZjIg5WxTACAVxDGhs2/3pz8Dwl8Zm41Yj4pKnYzFSk2AUy6GbAMuV68vRdkE8AO1iWAh2rjBdek7Ar96YC7mMRWP9mKO2FZReVYpvqmakXIgomlepZ7QkIZLtfAVxwzgYrHVlaHIDFWZBldzdt7PunZzXYXm0BiyL5h97jzD4XeukzSLOBCKqHL8Tkq085aCL0F45DhU4XemM5gPSwrO5tzMhhs+bBYNWh5OawnY5rTnC/w1r39cBuePuhGJ8gqLAZgpnHC6VIE/y0CS5pORRqplhlvG3pzbwpHlzFt8uUCuis3B+tUQdQUMKI9NWpToNg7aufeJMJ6OtNk1g50460u7oF2P6/IrdxIdTh8CNEBXajzPxhExNOslvm3YZGhcaFj5WbufYxh991YUgmwVeU2ZwW0zwuT1xGoPELI6XNMMIIYgQdw4Ba3a0OJNlCSSSnLzFKlUtErNy46VNcgEYTUxqHqrx8VwkcMTe9lVYV8U/KGMn2IgsIt2JcsT/oqB9ZiOVOg2BVFCF6SP4MhOS0n2B0QP1kUuKZQ4MFZUY9d+upx9OBsyOE775MBIDjrDkU+uQlGWIxxGjwhsm9hjjrb0YI3f877krb1o/h762k/RlwE8R3YbLFrriucsNdRBk/Bh4hNifW5+Rubg7HTgz4D0q+KyGu+UaVc1UaaQ4DAytCML36LPu0dzn46viJbHQuE12UbRT0HdqMA12o/q/NptVvLPVxzQAfZzzB5Hmtr3wtuYkK3A+KrJwo0mDAnLKcS6+7a+HtEJD8zuWKo/WSA8GzvmE+jxRVM8aEY2GEq7Qck6Ik8DtcTYEy+kOrFJSn1JpeRJUu3tokoMtpiuTGhMXUq9uLnyUCFG/1szJ4ty7+dE29txSIBKEkWdiivQ5qfUfICQhhKFx5T0ZvQCFD41WVKblwpgrBqmpWi
 cfKNfN+o
 6njijNPx6uvTgOOiC1GN+Njia9ehkTnHdl5L8JLduPhBQr8F/oqRYV//EMmdGDKcQNBo17/d4Vwi51n+123MO+Mg23bD5PgZ87paj/ICmO+Pc6fGjgr52zCvpkUsv7KHpHLytfg6ma+AI0YpMWzxzBlyvGqp6T9n3vI6gCckHPqfHjc5TPc7b+wEXAB0cv5qOw8jpjxlqjQn9KoQ9+XH3s7MH5ePmF2qw6udfH3D77vDlbvatldQSDMlJDyT9LO3n4sZ7EDphmkmbKLFvpEIhWugzXaML9cOoLai7E9VXQDOk3lj6WvslhTlY+gK45g8SGmN5QlMB8Vx4z6rcGzd4x+oXFjgNSWJIH6rJuiCiacYGVXzZtQHcJd+0TQuBYipavdwSlCbaSScVE5EzWj5RkhGAUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ips_write_info() ignores what is written to /proc/scsi/ips/<n> and
returns 0. Writers that use stdio, echo for example, take that as no
progress and retry forever. Return the number of bytes that were
written.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/scsi/ips.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index c7d6c5aae340..85c4fb164743 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -1428,7 +1428,7 @@ ips_write_info(struct Scsi_Host *host, char *buffer, int length)
 	if (!ha)
 		return (-EINVAL);
 
-	return 0;
+	return length;
 }
 
 static int

-- 
2.53.0


