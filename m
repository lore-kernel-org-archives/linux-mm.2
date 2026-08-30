Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48329C61DE2
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 08:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA2506B0098; Sun, 30 Aug 2026 04:11:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D05566B0099; Sun, 30 Aug 2026 04:11:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1A416B009B; Sun, 30 Aug 2026 04:11:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 98D6C6B0098
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:11:03 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2C2F7A028A
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 08:11:03 +0000 (UTC)
X-FDA: 85157215206.23.8314C6C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8390F40003
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 08:11:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gQvyf6PN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788077461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8L0DQGDXoOlsLX4qSHAjD9TzK8pF9McDUOUSa7CuY7A=;
	b=wLwMPN10KN6JA7bzOcVtJw7B7JD8Iwb1Mjgo6TuHH1QReB6lovhTpMOl6Spj64T4FbY2O6
	+PJEMUVuBX8i5Kl4kQMlwBB0bB5CwrVvxP2Fix7SXLtOi3g3alAVJ88KOYDSB1MVKAz0CE
	HbGN6oNFXxpARONxcdyDlLDYWu+vIs4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gQvyf6PN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788077461;
	b=cDymgYQ/UomWWyvDdALq25KdXZurjaN72ATVVPeBuD/f1PLiNrqAlFQcPbXd3oKXbb1atG
	X39rAuBjn+7VVcQg3s3OieXNLQmVHJ/r7mZP3DaAniPx42930OMmMef9YoZVTmyCqrcl4K
	zF46+k5huxcK/kFRCVVi4Ts2K/9rHag=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D58CF44226;
	Sun, 30 Aug 2026 08:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8694B1F000E9;
	Sun, 30 Aug 2026 08:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788077460;
	bh=8L0DQGDXoOlsLX4qSHAjD9TzK8pF9McDUOUSa7CuY7A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gQvyf6PN3R9q93P8546a/NefC9aYrfJGhZBZdpjV6Fe3KOAasOetNmw2TYaKTIaWd
	 ti9JZzWYYUJf25XhXJF7aw0PJbG9VTxfr9PXW1aPVAuYV6OCwdRidp5UtsJBXocH7b
	 pwkLM2eskU8MTxCy51CulWv6QW3cQOT8/GPPLXzGp3P9LspNcN5B5u6tJjV6v4Ohl8
	 9+AKGZNxMpWbcTaP7/ArMhsnOsBzCs83PzOlR/o2TTMC44Y85jBGh5cpjIdkpH5S//
	 VpoNO+wsaqsn7AI+FJrQBIynEb9zdVELyRUKuEX9qJX1WsSKvPI8vgK61eeT2K36So
	 3LLd3zSMFkfOg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 30 Aug 2026 11:10:40 +0300
Subject: [PATCH 4/4] USB: serial: wwan: replace __get_free_page() with
 kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-usb-v1-4-aa349c302246@kernel.org>
References: <20260830-usb-v1-0-aa349c302246@kernel.org>
In-Reply-To: <20260830-usb-v1-0-aa349c302246@kernel.org>
To: Chas Williams <3chas3@gmail.com>, Duncan Sands <duncan.sands@free.fr>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Johan Hovold <johan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 accessrunner-general@lists.sourceforge.net, 
 linux-atm-general@lists.sourceforge.net, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-usb@vger.kernel.org, netdev@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: pf7fhr3q4xx7h86nkox1t1oncf8x8a35
X-Rspamd-Queue-Id: 8390F40003
X-HE-Tag: 1788077461-912249
X-HE-Meta: U2FsdGVkX19w7vSiHRCS0cqoGQxBDEjpdPX6N4WAEE6WxVYoYqzLOn+Pzwb6eQefl08x8wY+t3O0SiVNj7r9ZhLJTqFKZib6uL5g7s98HlEsST0H2f1SrFjpUnx5MX+cRjQJvIhnws3SyaY5DozAm8I9hn3F3zJZVA6z7NVoc9qntBIhUywnHoAsGoCt3Cqf6QRo8M6J5rczXv/J6ybYjQg93tyCM5DhQr50zc3HrKpnOZfmHo8nU2WNVy1HGUlMmSZUMj5ya1Jk9E72/TnlM292VXBAaU6EJXt+Q0Z54GLsygPuaoX+Qo5KnhPAdy2WOGGqtlG3GcU+iHWT8xFBH3TLOTbR+X9e3R88WWPgJ1D5Fhr82PhLnPKkYOCWdaMyHxLHYzH9k4BvrcmbnLdRQMFEtV1Ru42QcKj8SRybTCh3WmNqMx2hbZt56QKEZVJ54NP+U0AX/Z4YYrBLnUEewdwEFHx6pQlYL8iZ2sBFyj0dLngR5a0z8I50UEDeqHaJIrmAAFF2u+oa5OfbnV3wQ4v7L7Oyjg5pjJ2jBHyb5zSDo/A9xPkPrJG2asODPqK8QLfO410XEQ703MLbOg2SgM+iAmBbBaOpLac96wSF0W4xDDLnGzSnijhD6u4LA5bFcy3AZgLc6R3lEcMw5qr0MJluZY+oNncNcGj3jNW31752j2YNddcSHybfdndYdl4lL0Lqx3+eq7agqAYpbyHR22fMEGLwgz8A/60IMGYZTiL3GyMjnq8VCAvJqUFgCRGUsBoel5a2ftHtY0oAOVPPrMHcUm1jQzV6V49fwwWy/aK9KI8RJhU/WsL+ikbBqc4kkIM5dpLzRdj5xkCZQAfTqm2f3tTRytLdZVEpBWYS9cB4yOkNkABpyrxMxHqt0aPsqmeij42tDouRHr/lqWWgJZRIEUkVY5JDrPLIqNOkF78VlS21GdPA+a81KLNha1KW33ntPYryeXx1GLUzmiY
 uCH5zkfL
 rZDqv8dkHeT8yu/YgvB99ChkZxFaQ+9f+DbAlIorGftBOaReIQJcbuZLzNtVHCxaOZ3r5O4MvSR4pXt+byF3gBDwMprC04Eyu/4n5vD6s/QJAMzg2Whp1NasOGHAbTqg2gb4Z0DslmrAwgAtlyGSIfM41cFbx1WaJXuO6rbGatp0qBNIDlecw4QE47mDYTzjCIXWLjWjEDN4FV9HfO24eGjAhTay1jrQrCWU/dy7G9bPgtbzftGcyphcOTUGGRuqdANeMmh5Jkk1Klf3BjlNbLPV6G3j4o8MnP0SCISSvroSNAwy44j0f+mpqKLleA0b5OCkF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

usb_wwan_port_probe() allocates the transfer buffers for the read URBs.

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

While on it, allocate IN_BUFLEN bytes rather than a full page. IN_BUFLEN
is the transfer_buffer_length of the read URBs, the page allocator was
only used because IN_BUFLEN happens to equal PAGE_SIZE on x86.

Replace use of __get_free_page() with kmalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/usb/serial/usb_wwan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index a183cc4515ed..a3929d3a3ec1 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -455,7 +455,7 @@ int usb_wwan_port_probe(struct usb_serial_port *port)
 	init_usb_anchor(&portdata->delayed);
 
 	for (i = 0; i < N_IN_URB; i++) {
-		buffer = (u8 *)__get_free_page(GFP_KERNEL);
+		buffer = kmalloc(IN_BUFLEN, GFP_KERNEL);
 		if (!buffer)
 			goto bail_out_error;
 		portdata->in_buffer[i] = buffer;
@@ -492,7 +492,7 @@ int usb_wwan_port_probe(struct usb_serial_port *port)
 bail_out_error:
 	for (i = 0; i < N_IN_URB; i++) {
 		usb_free_urb(portdata->in_urbs[i]);
-		free_page((unsigned long)portdata->in_buffer[i]);
+		kfree(portdata->in_buffer[i]);
 	}
 	kfree(portdata);
 
@@ -510,7 +510,7 @@ void usb_wwan_port_remove(struct usb_serial_port *port)
 
 	for (i = 0; i < N_IN_URB; i++) {
 		usb_free_urb(portdata->in_urbs[i]);
-		free_page((unsigned long)portdata->in_buffer[i]);
+		kfree(portdata->in_buffer[i]);
 	}
 	for (i = 0; i < N_OUT_URB; i++) {
 		usb_free_urb(portdata->out_urbs[i]);

-- 
2.53.0


