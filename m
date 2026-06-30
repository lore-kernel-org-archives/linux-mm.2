Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16488C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 09:54:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86A566B00B1; Tue, 30 Jun 2026 05:54:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 842156B00B2; Tue, 30 Jun 2026 05:54:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 731F46B00B3; Tue, 30 Jun 2026 05:54:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 427AB6B00B1
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:54:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BCA1C1A01D3
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:54:16 +0000 (UTC)
X-FDA: 84936118512.09.B249FEC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 22DBB160006
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:54:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BaW0UbMH;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782813255;
	b=5y6CfME9IVi57q8icl19Q/MqMSHfJ3RDLj8LJBl8SvNR1BO9Y1VNcRjoikjLZLICoAThcM
	kF6y2NM0QB+pb63BKdIzfG36Tg4da4fbZ8waUq8lQag7DteMnj9BjPtsXQ3q3ME0H2OVMy
	L3ONp1X/58eRDe7Tv/6I+Bg9GfsBRio=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782813255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YfIYXFpeOLT8zVHUHzuYoeYdkWWHFupYpwpzBCCce9Q=;
	b=t4zzZz1WrdnlP8AwVz4CiOKBA8OvYndeAtuW+WvtpcFn6hIIoYhFmwoizuKPxfb8jf6iyh
	sHEAFippDmGxieMtqndIo9cYpxqk12J7WBEMemaMkhWkfplxHTiE2B6KvKqH9CmsNeJNiZ
	lTaZYawF4zu7zKzTnV4VH7EDwUfBtNc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BaW0UbMH;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B4068601C7;
	Tue, 30 Jun 2026 09:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09CBD1F000E9;
	Tue, 30 Jun 2026 09:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782813254;
	bh=YfIYXFpeOLT8zVHUHzuYoeYdkWWHFupYpwpzBCCce9Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BaW0UbMH5ejYzIoTXvdKCCac/cJXwivlxwD2WF50m0UODbxHm2Ugi7mndIwi6kQUX
	 je+g1gYxh+zn8I6Mb4ko47+W0T2uMqflja/KQXhZHxA49+U+GrqTub62av836hjW0W
	 V8l+cveoTHJzG9nEACP7f9Syee2ZRR5UYDN1jaic1nlJvwcmsO69bA2ejzK2YU/7TJ
	 9XjQyJR27+HxfsnlNGqbo22Eu75g7N4u4TYQ2F/D5Mvu0j+B5lWgdw1c2nhaFGoeRv
	 FJQvlTLAY/YtISEExuTZgrf8qmy38oTuoTo8qPB44JGRGSfnjCMX/l44vljCPXdKQ9
	 g/NjNb+MaYiDQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 12:54:05 +0300
Subject: [PATCH v3 3/4] tty: serial: men_z135_uart: replace
 __get_free_page() with kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-tty-v3-3-a8476c66c582@kernel.org>
References: <20260630-b4-tty-v3-0-a8476c66c582@kernel.org>
In-Reply-To: <20260630-b4-tty-v3-0-a8476c66c582@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Jiri Slaby <jirislaby@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-serial@vger.kernel.org
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Stat-Signature: a7e15dtfaqncibmt91y18rwhuhztbecy
X-Rspamd-Queue-Id: 22DBB160006
X-Rspamd-Server: rspam06
X-HE-Tag: 1782813254-730044
X-HE-Meta: U2FsdGVkX182QQRp6sTPF0zcaJjbOUBN3MiLdqeGsy1E7SYXx7MqLoGHaH64FpcH/kzJM30WMAdHf3RM9zntYtHFf4DdHZxYez37cYqLEa9dyfdLAALO82CVufkL1aeUP9JuBwc83YjsM1vnGIMTi+2+vhrgiFos6/uRIjHnQG8S3rVvhCY39ousZ3I7AjMLsxySpC5HmDH0+EWDNb08bsUKPigpHhi+vMs9OU4XFKMdPzFhn21yigpcsQC/MUW87yNXXVeep7jS8hEU2Fz4Mv8nQ8DrF96G5rkwwsKeAHnO3kTfso8cWO1mCj4EGFzuq4nyGJu61MihmR6Joi6gyQW26z5A6q+EiFBmy77kasVVWWCtMu2ithhGA9ulbCe2KxuHBJVtQCIfyuyWtKVCF9HOg3aBlQ7Yj1mulgSHIFzJM5ZZDWM2YFbMGqhpLYJ0LNx+G/9nFFZbnQ9XoEQkCRgg15FSC38RrRLhgJdWjYpUZA15lB2MHAeUtWoy18ZnhJTsPIWfDWhQsZ2qYl+b189XnLVGgnNtIFiR5M1yk1/ggnYj+4tqQsZ/YTSi4gKtNLtIyt5bjNaf6V3Si2EKGqaMuP8dg+ipI0nxJIDUkJf6wEdCSpGiZpAD1xi3JC1SCBr/UbP6l+xnua3y/cKu/nt2awjSyodV+NpqgCM1O68YVM/fP/2s9FqIbKobpph6qJJKumPFVBb75GmklSxds1h0f0CjhT78dhB8yVlSQZ5sjra2bMa2G0Fv04kBsk25i3tP3JZ2bfWnP3y8QvakS593s0nELTNEiEHORWoG60ua16fq2w6E/q+9YLUitgrWgyA8TlliCGAD8pJHF9T2BV80KS/4Gcfn+SYisnCzX7NSLfaTBUdH+X/uRr9QpINad3V3S3X4N40jHJvwzycRsN9bdZgo2TEG4eTPUCUV/15ZY+W5JIYj1/fB8abEFHsGckr+F/RVXQcJV//CaIf
 p9kqRwYK
 Rflqj3nVnG0ewVaLQYbN/soy3u765neQAlnMLmxsmg7HXUlX0gudavQwoDeMhX+z38oQ5BISqdb3SukHBVWmxahI4nQx6v0XQnc+FLM2+uZMvs3bpsUqtf8sdV3LeD4NjvQr0KAZ2c97RYnmHrORlujy08G81GqgUMLMk20gEIGLszd1APpMzK+9d+GkAM9mWOu6xNcjiRp5RWgohDb/s5ILCq0yWMYA+XsL16UzCy5G42a99HRbDBSQYbm/b3LVgxtPY7KG1cpGVZ3qvSD17suUJig+p0xT/S9VbxmB6MZ4on9AU7U8cYTDGNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

men_z135_probe() allocates a receive staging buffer filled by the
CPU via memcpy_fromio() from the device MMIO region.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Replace use of __get_free_page() with kmalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/tty/serial/men_z135_uart.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/men_z135_uart.c b/drivers/tty/serial/men_z135_uart.c
index 6fad57fee912..9138fa29d301 100644
--- a/drivers/tty/serial/men_z135_uart.c
+++ b/drivers/tty/serial/men_z135_uart.c
@@ -16,6 +16,7 @@
 #include <linux/tty_flip.h>
 #include <linux/bitops.h>
 #include <linux/mcb.h>
+#include <linux/slab.h>
 
 #define MEN_Z135_MAX_PORTS		12
 #define MEN_Z135_BASECLK		29491200
@@ -811,7 +812,7 @@ static int men_z135_probe(struct mcb_device *mdev,
 	if (!uart)
 		return -ENOMEM;
 
-	uart->rxbuf = (unsigned char *)__get_free_page(GFP_KERNEL);
+	uart->rxbuf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!uart->rxbuf)
 		return -ENOMEM;
 
@@ -841,7 +842,7 @@ static int men_z135_probe(struct mcb_device *mdev,
 	return 0;
 
 err:
-	free_page((unsigned long) uart->rxbuf);
+	kfree(uart->rxbuf);
 	dev_err(dev, "Failed to add UART: %d\n", err);
 
 	return err;
@@ -858,7 +859,7 @@ static void men_z135_remove(struct mcb_device *mdev)
 
 	line--;
 	uart_remove_one_port(&men_z135_driver, &uart->port);
-	free_page((unsigned long) uart->rxbuf);
+	kfree(uart->rxbuf);
 }
 
 static const struct mcb_device_id men_z135_ids[] = {

-- 
2.53.0


