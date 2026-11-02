Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64CA1606A33E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tw8JvCxX
Received: by kanga.kvack.org (Postfix)
	id 874166B05BD; Mon,  2 Nov 2026 09:23:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84BD86B05BE; Mon,  2 Nov 2026 09:23:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73AE96B05BF; Mon,  2 Nov 2026 09:23:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 564FF6B05BD
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:23:28 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E5F5E12010F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:23:27 +0000 (UTC)
X-FDA: 85390396854.18.940034B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3570118000B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:23:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tw8JvCxX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ayyh3GSY9IX8l/NxmtUwOJrSt8ohKQ1xsnTJeKuAZFg=;
	b=fMYbewHRmsuOAKJup+ai+20Kjfd+vhFpTxTBgQ7A1ClnJ4PXUMjAk+glnjz410HNvW0jMg
	hrb+dQHbCb4Q4y0mCJoKmSqz/lHShjXSIddbJyi7crIaaRaTrO7byLFWlYk2JuXf75kMMm
	9rD6VIDug5zGi01ZOXYh5bP52QTSLfE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tw8JvCxX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629406;
	b=gpnK0pa8ssNKxIjuHqxhH64MggHTPElWNuvYgRdiNXlfKkfUIG3uzbi9bFv7UYk3dMnoid
	uY8BulcwAkSG8XPvpzOxp7BNBvTmDvDy0fUt/VKk4jRiGVMTK/F649ojCaPHeL68EerA/p
	lpZlnCSWjaYufdzvNh6Po4jDaG8pLxQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CDA3B600E2;
	Mon,  2 Nov 2026 14:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C471F00A18;
	Mon,  2 Nov 2026 14:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629405;
	bh=Ayyh3GSY9IX8l/NxmtUwOJrSt8ohKQ1xsnTJeKuAZFg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Tw8JvCxX+km1KBPRoMXNm8sioLL/SiBihZfuVNjDsAkWtVzRRNmE5Cc7zY4ut+0X5
	 Rl0KHYQi1x1Sz9PF1RgpgzXpUFQuZfg50HWRXxjw+hQiC/PXAgk/eR8W2vWm2wLiWv
	 tvpKqETwrDFgD85oMKX9xozlc6S0OZ/W5Nh9uZD5F+uNOl4/1vY/ZNRsBNo6TVAbtO
	 9xct4ES9MUcb8Lk4gqF+MaFsGvGgcXWCF6AdUApSp4FQtJeMZ864LzSIASS1Tvf3o+
	 oWd+nrIhC/gdzolHINRzQeTdVxMRiw3oiAWCylK9VGym+o8EZsK7NBzyrg6pK/30lF
	 lKmpkvKak5tHQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:22 +0100
Subject: [PATCH RFC 07/38] powerpc/rtas_flash: don't read past the validate
 message
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-7-59422ed3e465@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1303; i=brauner@kernel.org;
 h=from:subject:message-id; bh=7JHU1Fe1PUKfNakrIeb+3f7MU5rT/9SRwlQjBFg57NM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJN1X2VyVJzM0zaD4pd5IsePH+N4ZpyQLfS98+Jal
 7bIPwn8HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpADf5CyPDy8QjOeKy0icXe9kL
 dWRVXnzVHu/eWiK//28XY7LslJsLGf4XMiSre1zfdibVUb/UVG51TJRjtezPFx79q/9o//kddZk
 LAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 3570118000B
X-Stat-Signature: umnrogio1qiwuk663ntc4x3udedxp9i8
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793629406-74249
X-HE-Meta: U2FsdGVkX1/XsPatglwW48UwmhjwniV1I7qeO6MM2WekYxXKPcFEjV/Z0Fjx3Y36kqKv4bgdNiiKAyPPNOCQGufkUfSpy6wuVkzkSAXv+OwMWNrk2wveC9y+D3RIrhhdepeLcNMbzzbkVSQv+cnJuF9H6OUgVs4XMidsH5eKRICsXPwCW5YpdekJYHkn8f+aPyEHdlAapDLNAjASmqK6yDqKtoArbnZRB6CIvT5NzRYfDBZ9vL7rrfKszrznrTANjN551ORwi4utXxP0ofsiR0+sbwUl3VPSckRiTiy48mJUKWHYk4P8d0ZpCZU+KFN3/PMOWI+fFjNqEqlUmsHaJ5oOBo4CNKIUSkyPFbU59GV58O+/tvTRSc9+YD9hSvl5Twjo3ukV6g6C075vaE9gMDadTgh+Gi77Mg72P9eQ58lH6ZDkCWokJwybpmK2AcPj+uDvFND8LEqSCkNsdKV1xzFedaInPXSfmA9804uGNuZwqrpaFmnpJjWFSJ74Kt6cYj7EDMNqXUXAR0EmyIS+sjRjbrhYp6witPYzz9MpewDJUJhZQ/RUmY0Xq4a2ZE+chIM7rx84FQe+EySnHy8PTayLD1T3oJuCuGjijKiy9tTqSq9M7s/78I2oDWSoY46OCswMeV9jcbFJ6//TIBJn/3gGSdwAgLkWs7GuIDO6hZZMyO8W5zMfwGsXpGT9b98dDQiKtD5BtK8b2D84DsofKl5m92gE19aCvU3JFHW/4QLOGKy7c5v7JPWMCFMCMH2zIXqymPvSreSOr0h0k+PTLDo6SJiuEqxvduDqe4DcQq084woyYuFTiKnPCgmbPOWWzbMzUB5oF62atA8x/P7EaThb82UhtpR3KAEbU9LTcmOzitxbgL8FRIvrasGPx3BhJRhyvgAPzGXtpzeRnrfgdbZ/CWkWaVoLn6/4BsdQE0Bwb2+BBN3148kdsoWzdGTX01lYfC7K6A944KfSHpe
 x6nzoIuv
 tsWTpY51uGkwyIYr7xJBOuKlR21eE+daaZYpt9pFUOzJ7FVf0LDoO70PBBvhvWo3XsQuBJJZMidmMgKbBO4+rXOhwoJSTH8Y5k97VP0hjNaw6YDcOqmc3J9wfUIEMGFrTnQMxE9Yaex9oyJQhtAKxhOEcBy2i/M+DskicHXxanIRD84QmzT23Tc4WRKHIY4mJswuJsr17geYEbF5p7KNt9bPe0TbudpSC1aJuZR7/ulsbozerZZhY8paccmN0auNv9vZcnk7D3EowOWa85O0qaUVVB9wPHF0mes9gOQCSDhyYcAyRUGrkdIf+SSk6oZnU+mo/0kd9gRp4xWE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

get_validate_flash_msg() adds up what snprintf() returns, which is the
length of the whole string and not what fit into msg. If the update
results the firmware hands back don't fit into what is left of the 256
bytes, the length ends up larger than msg and validate_flash_read()
copies whatever follows it on the stack to userspace. Use scnprintf().

Fixes: a94a14720eaf ("powerpc/rtas_flash: Fix validate_flash buffer overflow issue")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/kernel/rtas_flash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/rtas_flash.c b/arch/powerpc/kernel/rtas_flash.c
index 722dbfb6fbf8..f1cd105f7426 100644
--- a/arch/powerpc/kernel/rtas_flash.c
+++ b/arch/powerpc/kernel/rtas_flash.c
@@ -448,7 +448,7 @@ static int get_validate_flash_msg(struct rtas_validate_flash_t *args_buf,
 		n = sprintf(msg, "%d\n", args_buf->update_results);
 		if ((args_buf->update_results >= VALIDATE_CUR_UNKNOWN) ||
 		    (args_buf->update_results == VALIDATE_TMP_UPDATE))
-			n += snprintf(msg + n, msglen - n, "%s\n",
+			n += scnprintf(msg + n, msglen - n, "%s\n",
 					args_buf->buf);
 	} else {
 		n = sprintf(msg, "%d\n", args_buf->status);

-- 
2.53.0


