Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FE79606E035
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nAIbEQM5
Received: by kanga.kvack.org (Postfix)
	id 62B1D6B05BF; Mon,  2 Nov 2026 09:23:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DB346B05C0; Mon,  2 Nov 2026 09:23:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F1C46B05C1; Mon,  2 Nov 2026 09:23:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F7D16B05BF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:23:43 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2EA071A0134
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:23:42 +0000 (UTC)
X-FDA: 85390397484.24.94DCC99
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6065740005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:23:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nAIbEQM5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p9+kMzHwjVYuWJQ2+obB/IGMwn7xV7y09JcSQ7GHv6w=;
	b=eogScSTDGBITB6GIdwrLZa/LpeqlNkJjGFmdgEdWjDxQ/7UuHMZY8Jvmt4uakCCjZN4vxD
	N69U6uow8BenGfBaQH/2xEHZQIK/2942rPjRESv/LyhVkcp/WlIe4Gbhb7pLpDQDdoTAkU
	GMiQGS7j5i+/k0jjMYXkXRaUEpp+ytk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nAIbEQM5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629420;
	b=I1tOyhcm+I/AK1U79EFa2fOT+SiEzsFmgvEtHicZ3W/GJ7802HFTgA4SqtP77xbop6auEB
	P3Vy2t/2TomBUmaaxqFcFyEoc8W3ALwwqHBu1iQrM4c5PywX8yppqzy+pwMYCWKzuJ8uw3
	M91MTiKZ8fsu5J7wm8O6fq3518vDSmc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E20243615;
	Mon,  2 Nov 2026 14:23:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093CF1F00A16;
	Mon,  2 Nov 2026 14:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629419;
	bh=p9+kMzHwjVYuWJQ2+obB/IGMwn7xV7y09JcSQ7GHv6w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nAIbEQM5310ipFRGOeRF8vkUDKmZoV5fUvGFSkGfohJKN0td49Uhh6p07z0TmFoqG
	 z0/urFft9enaDILFt/KGwH99g1Xz8qTxz9V5KhpYKxR/eq8404ma/XNOuW0FOwDX/t
	 0PE6DmoJYSY8ZiM/40ale6fIy+EqB6fPMCmuJNMjn1QWIq1OGi616AHwx7G/kn/wGw
	 BCW3AFqvAlRL5IrAp7rRm4LqA00F+fqgqJ2GtAb/ljVve7mQg8o9Ut8ljd73Bm2K9x
	 r/t/01cUPSVVrBSMD5Iz4FAUC7uxwlFcUtQFHgxTNaeizL4CVMBd0e1DPRlOTx/w5l
	 sgFqKBS14xdCA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:23 +0100
Subject: [PATCH RFC 08/38] powerpc/rtasd: zero the error log buffer
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-8-59422ed3e465@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1050; i=brauner@kernel.org;
 h=from:subject:message-id; bh=mkSbMC6ZDV5f4P2v+qDezcMlza9tkw/MXVPMWZSeje8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJPVPCc69ObBpPxKX4EYzdNd5y45M2a5nV4sMttfg
 33rv7e/O0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZiaczwz+Dyc7k7r3mYHj8r
 qAndMSu2XSZzkQ7vApuNf60/cn9tncPwT29znoj0AvYqkRyWAyJMCsl27rNKA0KeH+L9eOAi76W
 pfAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6065740005
X-Stat-Signature: wk56puchq4yjxcmicgu7xwyt831rah43
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793629420-194358
X-HE-Meta: U2FsdGVkX1+K26gTbvw2mGXnnkF364JAcPKAx4rdK3PNPfOcaNyFLLyHk7tAb055fsejSQtz0G1bg/gMjwUEReyJpbvPgOcQNiY+MiIFp3BfkKxBhaYn2Az0UkVICBW8DYF6t8qvwDyQTBFYbAX2tnNCUlbtDbJaBbcQ6UZt9LXl+4NGeku04jHrY9wlJMPEQh9JvN6u7wqm1Kv1x1vtHd1qQWL2Q0gylOQ3ajehQ1MTWX4vr302JYHKWUfyhaxqPt8bM1HCE9HZ3o51tZ9FB8tVJWxxJbbUFKH+tAo0nweWjQxnCWlKucRiw2Xux+YbYIvoYcVAd9tdo3hBLMlTWrmO+g19jz/8W3KWdAd3rcR5Kxx8qL6BLMUWjuEHApfe0MNPS53xRCqpeOwpfEyxiTRyCkPlCE75j8wkZRfHMMJBWAN5Cd+Gz3GpK5eQU0s1CRAzepx5sIPI8sidUqi68LOcGC312qX7AhZyxjFlA15sBN1tuqf+NADQfTW10tQgyMloYo3TfMvCuwPh/iwtCe2jGqybJ56ZXjll5msyCa2tdg1kCbxX+UVxWeYaiwOMiaVkAzeAIPStWT3f+Z/QwakJ5FsUka9AODUdPJcCquBvQdBQVNE1x+wmjym0ax5YFTWkItAuES+xUeOwIdDbHlov1AY4HFiejduiJQMUDYosUAlU/YgkjyJPAlqGfzUsi7G2fuI4XqlWYc1YdpPCUtgMdHB2Yf8je8g4nEoa0hnsiF3IfbLhj+ovl9Pm1ddmjUhYRjRoSZj4mQdrfUnomtNTNk+sSePHnnKlMgTelyJIGO4gs7C8fl0aKAXRvLHUjvgHJn9MCWIQXEzMtmQePWXgIUFdZm2nOErq/MkKcUea/Yjn4rlHEuX7AdOgcpecuIQ1J0NL3GmiStUFb9EttPE6fszJJu0WlDJph3X9aKOKqgKmNihqKJmVo8UuownQRdneM4Y0n528q8ZInGq
 6Db+xkri
 2rufIFjt2k9m414o+tNRErdV5Tkf3Kp9+DRcnVmqm+5cdXvaYQpx2rg6VJ52O2MZjS63XY9QxEwwsqmmv8upG+29pvK4LUm3/Ib9lVQgnxjqSBqEfVoDYT6Han2kKxZeAeOZa5yuFhxjNROniVnykqJ8uVThxSZx9qpPgqBvEpu1S0jHoEfx8MkqbRsidjtzetLF0P+UWBu7VLq3gdgOwGl21l1FVcXyO5vPMsEI/GsZgELiQ8LNmVZVoj2zFrCJDJ6wLN95S9ExpRewvuAHi+cwuFJ/V/uMIRMSi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

rtas_log_read() hands out a whole slot of the error log but
pSeries_log_error() only fills in the sequence number and the event,
which is usually a lot shorter. The rest of the slot is whatever
vmalloc() left there. Use vzalloc().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 arch/powerpc/kernel/rtasd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/rtasd.c b/arch/powerpc/kernel/rtasd.c
index fd40864bdb70..dd0df5e164a3 100644
--- a/arch/powerpc/kernel/rtasd.c
+++ b/arch/powerpc/kernel/rtasd.c
@@ -523,7 +523,7 @@ static int __init rtas_event_scan_init(void)
 	rtas_error_log_max = rtas_get_error_log_max();
 	rtas_error_log_buffer_max = rtas_error_log_max + sizeof(int);
 
-	rtas_log_buf = vmalloc(array_size(LOG_NUMBER,
+	rtas_log_buf = vzalloc(array_size(LOG_NUMBER,
 					  rtas_error_log_buffer_max));
 	if (!rtas_log_buf) {
 		printk(KERN_ERR "rtasd: no memory\n");

-- 
2.53.0


