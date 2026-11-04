Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9241C606A855
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NDNbfQiY
Received: by kanga.kvack.org (Postfix)
	id 79C906B05D1; Wed,  4 Nov 2026 14:21:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 773E66B05D2; Wed,  4 Nov 2026 14:21:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 662726B05D3; Wed,  4 Nov 2026 14:21:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38E416B05D1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:21:53 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AFDCB40837
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:21:52 +0000 (UTC)
X-FDA: 85398406464.01.E6A40D7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id F0B2114000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:21:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NDNbfQiY;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bRUY7zR2xEebSKJvbp7QJxGSJz7lwz+abCfF6bzfIu4=;
	b=TM/bptClBPnOXaomUMbFzLqmHxoM3MpaB2aP02DKcS8suDafSE6IOF6yNjCO4XPc5GTKWQ
	yhHR4D7rmD5UjMvOy1IzEqqeP7y7UBpTKOZKdh6gzWxpiRFvQ5dgnKqfeKG8cG/65ZjWJ2
	C/q+TgRhPWNgCSVC+GTXDu9+DEtdogQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NDNbfQiY;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820111;
	b=JH+h7Gw8W1z3RXd9cP59vIXpltXaBx2ycN6YaMkk2XzKkx0w1jieQHn1+4+MobK85jrdN7
	M4TBEYev53oV8xLG2ICrcH284qzvv295hGZqPSlf5pM9I0ToFxqSRtVTNoCv0NLHLMtArd
	ybLJeQBjpaw3foXUlk5A/eHfhszP4MI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 81533609F0;
	Wed,  4 Nov 2026 19:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E171E1F0093A;
	Wed,  4 Nov 2026 19:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820110;
	bh=bRUY7zR2xEebSKJvbp7QJxGSJz7lwz+abCfF6bzfIu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NDNbfQiYTs8QxoUaV5XJChR2qHa8xOxHYJocDlHmgzzJSqms9PhEZLUwt+ANrSmDj
	 kEnl6QN4BfZZeT44wGIKe0Ixtr1WXbuqCS+Gm8dZ1ubzgeNz5DCniH6FQ1eMnuGVya
	 K3FKmWhtDu4MeA/UnhfA3jbh1Uk2LEoIKcy3gsX0Lc9JtNW5MghWVftz4tHUP/Sp6I
	 pgjw5FHUrME1RTE8Z0LLnlJw9xm3sbv7a2SltWV0Lzh5QBwPcbr1XUZ/ihWdqFLxYk
	 cmed9ZYlW4eyWeUqshn66+fHBXUJ79jWAfcuK17k8f/Cw6JoctibeULlljIfW2t0nb
	 YnhLFoFESlk2Q==
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
Subject: [PATCH RESEND v2 23/51] scsi: BusLogic: don't return 0 from writes to the proc file
Date: Wed,  4 Nov 2026 20:21:35 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-23-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=938; i=brauner@kernel.org; h=from:subject:message-id; bh=7Bhyn2ehZ0sKrsH+Wp9jL6/kN1Jv4nVldfkK6knOcds=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bnx+qEer98CSA4p/dlzo/8F3vWvRwRxVzfXMGkIdb bJrIsumdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExkJSMjw5TaW9evl63Y5C0n mRnrGr7/ql2e7uxE7dKugO0X7TR/vWL47+CvtmlOQmAN85PS20YHZ06yX2SRZalWbxay2Sgy4bQ nKwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nrwcbjtiqpqfjisjztuhej16n3tm3iot
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: F0B2114000A
X-HE-Tag: 1793820110-866028
X-HE-Meta: U2FsdGVkX1+XIQoAwZmyJ56a2fhmjjUU8ZHR+QPMkzHGPB8t2oPKzG5rN59SRZ4an7SP3jpt2jK3xa0OejSu8n/DuXCdQ+xAyrLyh9/BviqZxX70YJL8QhZ8ybaaFdXg8HNh+LBIokVlDFQuJDauUMBfKH3OnNFDmKUc+FIB4eraSYpvxqd6aCY56FmwX+zoDbfINUu9u1sbsSSTN/RoHcAObiJ7n9HSqGSCIBeJU0OQqvqtAHHbRFdO/gAOuChWeK4oVqBYZo2zFQABvABTZNvVfCG2EAB04tsijH2dh01qOmkaUjDI3dbpCyJ+6dO/3M8X+/lzFQ9G7Jga7uuJW2u+sEtw4JTQ6c9L1yVI/PgxfH36ursDooiylu8l1urNjFTZr9YIBQOeWkFQX/Rih462LvuA3iwyNInuhHGLVmkneHvd+SM1sPB+euMj2qD4S//vl6m+QLS//aTVArsSbFkscjJ0UG+QItdiivs5bGLd7DQzjvWOSsR8p9KVVDp/vnYzR00sc5ENnBX2odIpTmHC5Zj/DBoNMyseUuft1sxif80YW1o2ouGATufr2oST19tPzUmt9QqGWJ/VRtumfMwaFPryBlHVF2hU/FnFGs2lvZlfix3hk7j6ebTl2xUGak2KUtygxpnAB91bk93B4q2fmHZDjavWJkZfnnEGyJNB6oDzHTKc8LpvO3uHDxD/Sq4G5vJPSrtLgxSbhYhYdxKar3FKFJj1uSbttkTSdKE4I8HE7xr5melfIbTevSdPmWL7CO1Ni6HKfYKmM6UOYQcKg4YPEd4MSHDRanbauN9WgpAyMuWZpVOdyLRmdBn8QH1DHzHG8ZJHjL7mNslnUDn9f5YQ8ilbtvtfP3NkzTj/EWSWx+jf0/c0wY/Zf1zXBfthbulSJjd4f2VEe2GpFRx1/qi1dNBQHVBppqKTxGEDB2bhW0YbT9YLl0HF7rXtWeRw8LWuNYrXlQNte2I
 MOrN6stz
 Jtxd5iM0tfyEX3jPtmPKnSHouUyppB/ofvH8F5iSVXCCtBIWun3YWadf5jjSr18Ccy8LtMP5OpmonDsxb8DabFunnKmuN9gPdcKUVyfuXZpoSJeLGmdBemQPL68sUSlfXXsWtHQnWn1DWfBNgOK07Z9q0KiGENVHUf2tc/DD1jVjwvddlya/NHbOF8vCyJo8l/pdBp2kpltoLVtUjcVCXXnYAoSbl9QpII24ax+dxy2bCGhRwvwb2Ny0Co/ve9KB1HulGVnADFdIe/YdBUtHMGjfMc+eTKGsW5Y6XxWA+jDvNagdonTyvkUdQ5TUD2skjVZvXEEv4JhDvPITzo2GuvM0OcNhw+gtjY2lTph4550L/JN7HMNn2lQShT99QUaExXys6OLfaJxRxMFrTqhGCJwt7uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A write to /proc/scsi/BusLogic/<n> resets the statistics and returns 0.
Writers that use stdio, echo for example, take that as no progress and
retry forever. Return the number of bytes that were written.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/scsi/BusLogic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 27b446c0c5d0..7ad814f549ae 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -3328,7 +3328,7 @@ static int blogic_write_info(struct Scsi_Host *shost, char *procbuf,
 	adapter->ext_resets = 0;
 	adapter->adapter_intern_errors = 0;
 	memset(tgt_stats, 0, BLOGIC_MAXDEV * sizeof(struct blogic_tgt_stats));
-	return 0;
+	return bytes_avail;
 }
 
 static int blogic_show_info(struct seq_file *m, struct Scsi_Host *shost)

-- 
2.53.0


