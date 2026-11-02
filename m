Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAB6D606F22C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bTZqC8ZG
Received: by kanga.kvack.org (Postfix)
	id 121C76B05C0; Mon,  2 Nov 2026 09:23:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F9A96B05C1; Mon,  2 Nov 2026 09:23:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2BF56B05C2; Mon,  2 Nov 2026 09:23:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D5DC46B05C0
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:23:56 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 58137A5B8B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:23:56 +0000 (UTC)
X-FDA: 85390398072.30.3E93229
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id A0CFB1C0009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:23:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bTZqC8ZG;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5idTO632MfTOh8DHBwsM5N+e4TPz7tW3oLCXLVOM1bU=;
	b=fauIC2XVc1nLBilodME8DVq8qW48nIxwgZj+TPRULqeFQu6YGuP7fMnw8rgcY41bf+2QcD
	i7mMUAsnsmonYN7P0be4VER08Da2NJv7ki+48POJI19fVUSgV/vC+CtPqWpBIqY5GxkpW3
	XxpHK2UeHKVlKlcI6jrD8cCdK0AQoPs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629434;
	b=ldsZn4m9ZUM0Cjz97hIP5rAwnsGo+3SrKNEsn3EFx50HpWOrBxBE10Ndy3kRj++JWr9hNC
	DMk1yloikAxgN/ILRNJh9xEsJvboyqpohavlFeeDhvCGwWX+He+wLd0UEGbTfoNRQry4Md
	5Tik0WRG6ar8CNzHNoXn7uPnLODDia8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bTZqC8ZG;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 39CF2600DC;
	Mon,  2 Nov 2026 14:23:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FB41F00A17;
	Mon,  2 Nov 2026 14:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629433;
	bh=5idTO632MfTOh8DHBwsM5N+e4TPz7tW3oLCXLVOM1bU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bTZqC8ZGdXxcFQd/3hUg3IW0rejRlM5K7QNfkjVY794R3YHFyVPBjLRGBUayKfnuB
	 o4SatPA8T6TNXjcltzn1X/uXTJRuPb2Rlfe8Ay7Lihwlip36LKfkuZzZ2uLD6o1lsn
	 vWG9sGTbL522XI7qvpHjUHz0MjvfEW17lvoFh1SmnCSdWAreu8wFgjZqF1c34Gdkms
	 8WxYyheLECrp0gW7AmhDwmWf847MgsFNk7fCgXMkAYJi+8MwP0s9Ehv9+slB77KTjN
	 Sw08w8UDfVr3lkJvosLxlggPqTYkDbchMzBmGfJx4chWnQ4NiIdZtKUt6Nf2GmPnXa
	 Jl4P8fqea13Rw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:24 +0100
Subject: [PATCH RFC 09/38] ALSA: info: don't write past the end of a data
 entry
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-9-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
In-Reply-To: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
 Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
 Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
 Greg Kroah-Hartman <gregkh@suse.de>, 
 Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, 
 Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
 linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
 linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
 coreteam@netfilter.org, kexec@lists.infradead.org, 
 linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net, 
 linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-cifs@vger.kernel.org, linux-fbdev@vger.kernel.org, 
 linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-sh@vger.kernel.org, 
 linux-usb@vger.kernel.org, samba-technical@lists.samba.org, 
 sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
 linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, 
 linux-atm-general@lists.sourceforge.net, Takashi Iwai <tiwai@suse.de>, 
 linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
 linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
 linux-debuggers@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1286; i=brauner@kernel.org;
 h=from:subject:message-id; bh=QDMkZvLaF3IWyPhoUUb9QYkcrNtI4YpDxPIetQD5jl0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJOVdu4T53QO71keyQs+h0u8P+U2ReHO2uq+t72Xn
 8zfu3i/eUcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBE2h8x/M+p1jq63Xz2BXau
 4IAvwU63lx9v/bDSeMfWNnHlszsNnwsyMhyxXa9lwZT9csfJKq+qsC5mVf35X28Ym77fVPdQjT/
 rICMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A0CFB1C0009
X-Stat-Signature: 5p6szwfbfaokdgomhda3bhsfxz565rqn
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793629434-64297
X-HE-Meta: U2FsdGVkX1+jJ8YlvRnKxp543U/e88FNnbQMqtA3uha0ucQe27TdREYp/tiVpigmxjmSRwD1j1SXJJCB1LecHl7haR31g3E6aDmBOagVYzfOA98z8hy6fzJjh6ZcuKcZr8KRIscyO5ngqPISapWJVuxlf4RNV81Wmn+jkc1K8xFIsqn+THMW7VfysbG9aPouLGSdSM96A5kbFEo3A61i9vUK2L5LdOu0voLSUsQzo/d8Bm/qjnSSBDYKAlOfEf0L2E2RGjXnogwzmyZz5z4R4LmjzeSEhVLrks1S+eLfkF4cxU+WfvkN3AnFruDaCgK1NA5dopfm5U/Ul1s8QC2GVHr5BdVjaegWN6dAiCnqI9DYiQIcju2aKDurSrC+ZADyWFtKlDCLsfP5DKCiSVHE0MrhCEoZLK3myfgz7ka19Q7j869wKe3msbqyVNzJue9YvRSzFilXMbouC55EhRFPZQfk5iGuuUmjHYsECLetN+ZjX4vUdidfCzsIK+465bD38IhEj2GRwYREZfGkeljtHpaRuR8V8a7uGXq02GGfIS7L5FyjZh7HOMyUutuBsd1mQbkhSxnI+3nuriHimsZBKN7HrXCPwcsr17PB3SriZPjLBPqusI6Urv3etAA7urm5dkKPv+5fExiGXzLtdlHa3LqIiUfoJSIWZSDvLV1w8pWTJw8LsgJKua7viiylDFBQPCL5YZm9ecikCgZptHm1J9lCnRaOx7bly475vZCbduA9hzWoTVseuz7rdrxfWjMCDLoiK5I6rOF9BDE1iGkW8OGL8NGXqxhK9vg9EwFMqVPilQCh1ZyUHFjPoMFd6ETA/0CzYPksdIWMeDQcyW1vOjv2abKbLod0IemIjoAIfIxECF4+59q1koGI8o1oZstfXqnvsnaQrSD8k2s3oWVqowrF4e2m+hCSODZKdejJ/BV0OjnMlK0dbiFXhB9QN0zHdhGMScyddM5g8jaFquY
 nYe4Z7Xg
 QhCOc7CXdN+/rkdjiS3jqUmKbpiVaQW7qeOQZKSb/384ZPIDIUhTXLy1jyUiysvVRW73sLTcMH4DL6AL6BdXAochWxbv4C/Xz3X6RJw5KmJ70YuSjrrseYtiHKtqFhKpO5rAYmcBKmaj2WyM4R8eCg08KxIpyOH7KU6yXC7kY60ZuKPaCaXWSgH9np1bvFtdztsM8XItbkCXrzdONQRfhN8VLX7tNRwvqBECvRGvJ3qjlJetiPtCiOUhjPhyLV3nvOvklTYlXGSzsC6Z6sLZ8Ygr1mWUk/UJ2+5VEndi9XM4IhuXEfN9k9wKQGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

snd_info_entry_write() clamps the count to what is left of the entry
by computing entry->size - pos as a size_t. For a position past the end
that wraps and the write goes to the driver unclamped, for opl4 into
sample memory outside of what the entry covers. At the end of the entry
the driver gets a count of 0 and vmalloc(0) warns. Before the clamp
moved into the common code the driver ignored such writes. Fail them
with -ENOSPC instead, like a block device does at the end of the
device. Returning 0 would make writers that use stdio retry forever.

Fixes: d97e1b78239c ("ALSA: info - Check file position validity in common layer")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 sound/core/info.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/core/info.c b/sound/core/info.c
index c4d57d0809ad..982087bc8575 100644
--- a/sound/core/info.c
+++ b/sound/core/info.c
@@ -171,6 +171,8 @@ static ssize_t snd_info_entry_write(struct file *file, const char __user *buffer
 	pos = *offset;
 	if (!valid_pos(pos, count))
 		return -EIO;
+	if (pos >= entry->size)
+		return count ? -ENOSPC : 0;
 	if (count > 0) {
 		size_t maxsize = entry->size - pos;
 		count = min(count, maxsize);

-- 
2.53.0


