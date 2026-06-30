Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81B74C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 09:54:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 313376B00AF; Tue, 30 Jun 2026 05:54:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 276106B00B1; Tue, 30 Jun 2026 05:54:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F0116B00B2; Tue, 30 Jun 2026 05:54:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D7BC16B00AF
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:54:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 72F0C8B7A1
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:54:15 +0000 (UTC)
X-FDA: 84936118470.10.F2B285A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id BDF1D4000B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:54:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RoUHnc8k;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782813253;
	b=E+TDDGspFGL5TFeP48/04zb6u25ZAWQWQsbisIZGREo9ge60cHSHsYpVzeTM7GIj+11pFq
	UuvlUpTjeRNnqWSAX5AHyjWVfC9B/8sMEHVrKefz2wL0mSrwAdzZuUhRtDenIbpl0cz/Y5
	1bnlZhbb7In4SJkoxLIezdMEajWjUOw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782813253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hba6xOKzIlLJw5sTi2ZReL79jUmA452phwmu2dxW8ao=;
	b=5DjeI+p4dLgYutOM98k2mLz4fmHSznFEYNB3iXceD7NHjWPP7LAFLqZNcLox417/2XDHL5
	9sqb9eL0/i9k00e+p2zT6L803r0JIYzLOG33/8U1VHDK7scJWh+wkHlfdg61lLdANwkl/L
	w+Dggg9JmriZG4HwnCDX9FEOXLB0tCA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RoUHnc8k;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F1BC43E0C;
	Tue, 30 Jun 2026 09:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2005E1F00A3D;
	Tue, 30 Jun 2026 09:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782813252;
	bh=Hba6xOKzIlLJw5sTi2ZReL79jUmA452phwmu2dxW8ao=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RoUHnc8kB23/wkE4Cut/GBnnRbhwHSyZ93yJaQb92LNQVdq9/JU9EtI+GF2oytakX
	 oSRafzwA4auG6WU4plLi0lDiJxusEmNU3gAwV6/qor7YGf6sH0dqg+Wz4k0o/fpUin
	 XDe/sVM6Pp21UyN/JYwXEVoliGspk1m6DMISvKXIcAK+/HLVp0TPZPVU2BbJzfPbil
	 Q29gfH2iXSvAJ+TbMpBo4vZEPoLwb5Jdsi9q7DXnO6i0nxfkyjBICaP/jEy3Cfri8r
	 XZAMLTUfaCkCSCo+JQMOWXv2FlzbC51WKLORHDF7wH2yHvFC7F9FBovv8IZK6jnhyK
	 10d4tX9HWH7GQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 12:54:04 +0300
Subject: [PATCH v3 2/4] tty: amiserial: replace get_zeroed_page() with
 kzalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-tty-v3-2-a8476c66c582@kernel.org>
References: <20260630-b4-tty-v3-0-a8476c66c582@kernel.org>
In-Reply-To: <20260630-b4-tty-v3-0-a8476c66c582@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Jiri Slaby <jirislaby@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-serial@vger.kernel.org
X-Mailer: b4 0.15.2
X-Stat-Signature: fh4mcr5hmdd89sfdboawtmcdtukxug1b
X-Rspamd-Queue-Id: BDF1D4000B
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782813253-496499
X-HE-Meta: U2FsdGVkX1/UFbo1D8PuQuU9a4o9KSy0MBEd+OfKToI+OBlryikU+bsX5NHIx6VYSnbx54QH4HIyylAeuxGBc28H8PkxjDodJJmdG9EEAbm3jyDKKCEcmHcVk4KGFJrlt17uKJDopAlcXGd1nIgyc7717xJ5mlMs6XXDQuXqG1N7I1jHo0U01wI78px5hlfuaCm5fEcfLwJKQK2QkFGwTUX04CGJy2vCV6d+mGpiam62N2QZ5gtAn0IdurDDzKrdMYeRLn+eAnqhUfEoO+71axerKEBOFqyqpUgYP8yjh3X+h/VP2rTk1tc2oJKtWa99BviMseB9vrOeIQnfOFST8Es/4XXZ/H/pHi2ML2SH1+UlzNwE85XBRd3S6jWLu81psYVnI8kIfh8s5knJwmyY6L0XcOfFn5nYrV5ezniDf77lgI0o803jcVKTXqbtQi7XSAQN3Gqj3KUP8m7/yczPa0DbaaxLvGGzYfchnugYUOTwpeW1JKhGvA6tOog0a7q9Ju57KpozayiGGAa4iESgLb0/AC6/9XryFBssexnRCT7tteZoyNuD4s3RoKBRU7cBWt+Oeog+ocjYcCWRQhvhyCwPp+fT0iKgr9nJMiHjKtT+4Qgc1ILqeY2ctxThP0VuGP0nspDSSymxhb1XOsJSKSlkXLvc1uqZ/MQ4cvRQ00HCu7wZmNeIxkArkK+2hmTtp3f3UCS7bN4t77YlcfM4AdoOF35BaYHakIuqi7fhYiM+cyZBqSOJALR8S7yPlbaomBzyWU8kp7u4RWqvKX2IL4m44IjztEYQVOWXRpW4HGTb6pP5sS8antivHO8HcdGAnUpcPwfwIdroVjeWCAl7m9MlySKbzgO4IXj8vkPQrUWd6M3xQ6DaQsTRs8DGFTqna0tFKWhnqhej+pvXCOYLqfvP3v8n386r1hnu74YNYTORLBBQUMTx4OTejYCYlheV58JPlRrnZe/63mrJGgJ
 hj7wJhL+
 krr7N6PHrP/D98xNOmMqpBLjTVVEeqJxg6HlHf3GL/2mTUyNhwpKD6lYlxkO6TT39v3ZVXfvlDqF9LkyjcJNyO5nIstOVNqiJvOv7IHYl0MV6OXNkfQZo1na/ani9Pn8u/XnptNcPp/c0ZWS5QTWNc0bUporSc/rxmZs8IW17/lIJ0UYN6Xh8aGpgxJ+hOEtA9gRsaqKia2ED21PwrhbjBrjBVRL7oU1IgfIZ44L3xpYzQzfzG4q1LN4tG6bwdKdvPdC3EFMJOA1DnGmFq17lglrJ6LQUW0AixFE+3lo49auhst/P8VpI3kpAopH8vgnQt5B/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

rs_startup() allocates a transmit ring buffer that is used to buffer reads
and writes from/to serial data register.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/tty/amiserial.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index 81eaca751541..28af0fd98181 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -443,23 +443,23 @@ static int rs_startup(struct tty_struct *tty, struct serial_state *info)
 	struct tty_port *port = &info->tport;
 	unsigned long flags;
 	int	retval=0;
-	unsigned long page;
+	void *buffer;
 
-	page = get_zeroed_page(GFP_KERNEL);
-	if (!page)
+	buffer = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!buffer)
 		return -ENOMEM;
 
 	local_irq_save(flags);
 
 	if (tty_port_initialized(port)) {
-		free_page(page);
+		kfree(buffer);
 		goto errout;
 	}
 
 	if (info->xmit.buf)
-		free_page(page);
+		kfree(buffer);
 	else
-		info->xmit.buf = (unsigned char *) page;
+		info->xmit.buf = buffer;
 
 #ifdef SERIAL_DEBUG_OPEN
 	printk("starting up ttys%d ...", info->line);
@@ -537,7 +537,7 @@ static void rs_shutdown(struct tty_struct *tty, struct serial_state *info)
 	 */
 	free_irq(IRQ_AMIGA_VERTB, info);
 
-	free_page((unsigned long)info->xmit.buf);
+	kfree(info->xmit.buf);
 	info->xmit.buf = NULL;
 
 	info->IER = 0;

-- 
2.53.0


