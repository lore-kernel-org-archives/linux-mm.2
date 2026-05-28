Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F37D5CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 10:24:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24DF96B00B3; Thu, 28 May 2026 06:24:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 225366B00B5; Thu, 28 May 2026 06:24:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13C756B00B7; Thu, 28 May 2026 06:24:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 01EE76B00B3
	for <linux-mm@kvack.org>; Thu, 28 May 2026 06:24:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 96E1DA07F3
	for <linux-mm@kvack.org>; Thu, 28 May 2026 10:24:30 +0000 (UTC)
X-FDA: 84816444300.27.C127522
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 02079C0002
	for <linux-mm@kvack.org>; Thu, 28 May 2026 10:24:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bDt7TvPp;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779963869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=slIwflm/+XwBSB+Sc00rEqpqi43gBVcoe+YhIqLQhvU=;
	b=Mq0Rle7/cFMHyjR2AKx9OqzR/RaOw7UTK6eSY1rSYZQudd4BEL9NJNtRXYsKTb2QF+ey1g
	W3J9+CxzXGQKVgAF0DC6dW46FAGxns6jIElMPzegIhg5e0OTdRLhtHesoL9zKIBSANeYwz
	8P0q2A61r8SocbT0jWAzYINigDlc3Tg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779963869; a=rsa-sha256;
	cv=none;
	b=bksnrOGuARj3hqdV/tE5ecua6NWjOoHkSXKO+Ut4S+iZbSWGBvsh2OJdNq56YlqD3UopZr
	U8Hv9wWHrCj52LZVb1x/JcAxbpZmaYDPkOENERppzNwMZT/A7TPbtBzh44SuyS1NtEvQY+
	BsWmzAUy09wxvO9D4AjZTBpbOQ6FOP4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bDt7TvPp;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EE6DC44197;
	Thu, 28 May 2026 10:24:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD3B1F000E9;
	Thu, 28 May 2026 10:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779963867;
	bh=slIwflm/+XwBSB+Sc00rEqpqi43gBVcoe+YhIqLQhvU=;
	h=From:Subject:Date:To:Cc;
	b=bDt7TvPpY+qDGLo9EVpQWjBAPY0sn4yUYXH+UbHw0hPA1fQcBVcKVCwzoljW1C3e5
	 nvDnjRBsUWmk9KZUgF85Eis35xdFqaZsxEoeUmSQ7MGVvh8/0OkVkyViVcpNvIPc+F
	 v4ZX/sys+O3MFtL0E1q5wcgrEyFLsNUIKIWaoYzfjSJavj7ny8wqzEW+rjQSF3zmbN
	 v1QbmGF2vx4qvwdlBf2qf+aePAP61hh4Q+bQw1P3b510pxYvz4rom/nK/DuTPMi5uJ
	 K1r1z2OgYW0+3MWW2yJc0SBwNb7474dDZDPvk7yr6xwu+sJtTE0r5D+a+z+/MdOY7O
	 XfGRNlY7nRQmA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 0/4] tty: replace __get_free_pages() with kmalloc()
Date: Thu, 28 May 2026 13:24:16 +0300
Message-Id: <20260528-b4-tty-v1-0-9da9f7aec5f2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANAXGGoC/yWMSw7CMAwFr1J5jaWklPK5CmKRj0PNIiA7rUBV7
 04Cy3maeSsoCZPCpVtBaGHlZ65gdx2EyeU7IcfK0Jt+NIf+hH7AUj54DCOdTRpstHuo8kso8ft
 3dL39WWf/oFBa3QzvlNCLy2FqUxReSBT9nBIJbNsXIfJF6osAAAA=
X-Change-ID: 20260528-b4-tty-7c6e90f41d13
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Jiri Slaby <jirislaby@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-serial@vger.kernel.org
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Queue-Id: 02079C0002
X-Stat-Signature: pirtgg4dg13uzx4eku1rda3ah91fr5bi
X-Rspamd-Server: rspam06
X-HE-Tag: 1779963868-226799
X-HE-Meta: U2FsdGVkX19SvTaIAa9yL2OaWMSi+S5Pcoxxcj0IEU8a9SZCH+3SezLD4aQD8RSaSSZnO2mrGeEp+jxD/n1c5Rz+K+imIZMTE7++x1y5L1o7tjEJTtIqZ4l6y8xvDZxDodADeXryXo7R8NeCxCKEluu3RrWfXWjRZYkFJteOUI0hs2hOsEs/K1lRvgiNHU1R0oqN2pzyAXVGwtY5HRpet6UUOKWAQK1vqqUP8hmRL9pwzv9kmQIMsTaOLxVt26ShWwXrn4YY9kKkorp9Cg27lBbzmdCzu4RtUk+xpAY4TfZYjPJzzW3hxtRxaRuG78u7SXez4NQbioIKa0jCqWUSIexICQQPh2qR75VNSU8mwyZWc6EZRp7AbjLCRV4ITwrVfBUI7gTKwqEHEs3q8YZEi6+ooBI96VIjiJolq9RnCBJXnu+gom+lST7Az4JrsVkwmgk8US5A5JRnsJWM4qSWHiXku4Gn3E5m2bEJPskgCmoWdbnoOClEd7cibCgsMscaMdbQu5sSYDAW1JZ4aoTvs3TeT0vlkFEuxS3YECpJZMgx4W6OOgJTTbdXWwl7B/z4Ia49Ux9r79u8uTM74nExGtaeyZ7D+gI/VWqXhlOl0FcEzMpdOm5BM4WdVC8rQIQ1HyaZrOrhOLQyBqn5V0zhS/ExKICZWjptRJY/9gh6rfVRXlhufPAPv3iszYHwTOJ276SReXzWLj8a9F2v1O8/tjwVMk0Z0modp4dOnspZ6+NzrkhWVfmpdGtWxdNfsqDTk5EFPQiabp0RA9qq8u3yyScis3TNmJUwUJC1vHKlnLA5LEPsPyrZQIafIa8DT25Jn5G12TuSSJKJwxvbEut7sKMutAmRm5U8us7rBpYjkP8xLqhAREqUUH/5e687WdjRMUb2OqAky/fje9QoTa+xqCG7l2G0di1Onf4z2lFLLsG+dVCut2bVnOYULrsLUPxHPlJ6HkWUunVAgGxOknv
 Lh+bpiMa
 D7HXAccnsDuTBbAn9IQsyT/a582f358pmMmNyLw6r8K4tffSf++a7IIvRmmTs6JNE2s7QFa/5hU7pZ1jxq8GWN8SHAMoJEt5O+U79dWFTRSNSvY7gCyhK1THZMUkeAD2/ntTA7/+bQVp0wOsbOxe0TKijZkB7gThoHAp/mcAHgKNFjJViLo2SVZs9u+U/5z0N+VuHU/jOoHnrWWjFIrPVj+IQfi3UEInwZtZ6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a (tiny) part of larger work of replacing page allocator calls
with kmalloc.

Nowadays the right way to say "I need a buffer" is kmalloc() rather than
ancient and ugly __get_free_pages().

---
Mike Rapoport (Microsoft) (4):
      serial: pch: replace __get_free_page() with kmalloc()
      tty: amiserial: replace get_zeroed_page() with kzalloc()
      tty: serial: men_z135_uart: replace __get_free_page() with kmalloc()
      vc_screen: replace __get_free_pages() with kmalloc()

 drivers/tty/amiserial.c            | 14 +++++++-------
 drivers/tty/serial/men_z135_uart.c |  7 ++++---
 drivers/tty/serial/pch_uart.c      |  6 +++---
 drivers/tty/vt/vc_screen.c         |  6 ++----
 4 files changed, 16 insertions(+), 17 deletions(-)
---
base-commit: 5d6919055dec134de3c40167a490f33c74c12581
change-id: 20260528-b4-tty-7c6e90f41d13

Best regards,
--  
Sincerely yours,
Mike.


