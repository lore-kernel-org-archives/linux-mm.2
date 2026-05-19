Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FB91CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 15:30:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A39E6B0096; Tue, 19 May 2026 11:30:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92CF36B00A0; Tue, 19 May 2026 11:30:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81CCB6B00AE; Tue, 19 May 2026 11:30:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B1F76B0096
	for <linux-mm@kvack.org>; Tue, 19 May 2026 11:30:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 29B9E405A5
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:30:04 +0000 (UTC)
X-FDA: 84784555128.09.4256810
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf13.hostedemail.com (Postfix) with ESMTP id 63ECB20009
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:30:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dQ97AVI5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779204602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ST4xr8elUyY4XVDi/DfkePwZ3bJPhuT8td7WsE6XkjA=;
	b=FIK2JQ/OSq/tWjjEzI4R9+MxYYTxi6Avdnvnfv4RZJ5lHPxFux36b1kY1FJN8u48NklSLc
	/v2jpsEWzNeWiaVTRAzDC5/VBSFKYl2mZCbL5aDkGaS+wKTKHZxzAyMP2xytsmFkkNSx59
	cyTIEGQxuyzkrW1jspJiFl0HD7aJWkA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779204602; a=rsa-sha256;
	cv=none;
	b=r0Yz62E9LZQ5gEQjLkBfss3zRPEeNPSQvRAARZaznVPW/hFJqXq/kkh05BMJwUF2GPN5gw
	fdxW0PDJITtq3jdIieEaDNPs51fMBtQOB4gBdFFubSK1B5bj3H6PFQLnKTF4Ypmwq1zplb
	kmZApHGOfD2X673DYS4fI28z6Htg/p4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dQ97AVI5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-44ccbd3290aso3517880f8f.2
        for <linux-mm@kvack.org>; Tue, 19 May 2026 08:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779204601; x=1779809401; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ST4xr8elUyY4XVDi/DfkePwZ3bJPhuT8td7WsE6XkjA=;
        b=dQ97AVI5M34XEFTGxEoEBwVc86FkCC768XXTMFXcyFHyWJWX+JroR/3dD3DGLWR2FV
         NHda90fwSi4+kRzzC+QpCAeG+vz99i6RPUKS6cKPs2Ayxv1ANfhIMJe61oeaaYoL2FtS
         LzPINHjjyvIfj0tf2y03i+UupZRMdWo8lgP00xLkTU1ARXYDHl4ucDDSQCs8vQ3AKkzh
         aU0U4IM6ShLbxKKJgX6VN70locSU9QjOQJm3N1hYDxpEpgUSZrAonVUOw156OXiBAcMs
         uPCNSw3hT4Hm0cJ8KgwqaVahYqKCYrk1ldRh1NoyUPJl/T5gA2NNFRKjeXDXEwMXeFal
         qSTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779204601; x=1779809401;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ST4xr8elUyY4XVDi/DfkePwZ3bJPhuT8td7WsE6XkjA=;
        b=r6lO3wmyDrgt8EI1QGpa8EEAPbDzWLso7shX77PF4a3QW+fg+P4WxFnjOxF0mCjShs
         k+4APjJGYdQIzJofkPr+QJvf9icX/A13TQ1phJz0ml8QuQLomvlcvYen47wIn8jmK+BM
         ADcxnNbhiiLJUPPy866vWV/dKp4v0oIO8Qmk4w+prHZR8GM+o151WL2H7G8Yn3nZL1Q4
         REfyVBa5t/KZIx3zoQOvJinBc7jItveMlayj2qHvdD81+b2bu8pcBWAUoe+smgPCOAuo
         LzluByviAE44Y1eRR/3aED1n1EcAgJmXpSeaQeGvSrbEtwi/2awT1kySdAef4+8x3tQ+
         +0+Q==
X-Gm-Message-State: AOJu0YzgqXpvqVr9Otnt94/bD5RvYAWpiUazjkIiq/z8Wn9fC6uduEJw
	GCIfAQLs0oxmF+QDKr9pAxTKYqrYtyg5/eBWaOGKe7lOe377w4wpKA0o
X-Gm-Gg: Acq92OHnCBhj6VBrmKLE52teamvPBpyqGtitEPeXTjOJfD7tQ138NPvtGVqZgn2ftoB
	L9UdP/UNygvlRetR94R6PVlvUVk8Yq0j+UL5wMJ1nL+ZXjQI6GyM9EGFRx25+5QBG15WgmDQutD
	JIYKDS6d7kyEjiCeqE+cqzOu3xf+5j/k4m7SwbgtSwre6j1Z1kfyk7F8LFyAT0X9PsCgCpUVOKw
	C3ckZ3U1DomVntpPLyBPSruwR5yjXshK7PoBs+BjNXWP30zBOx7YU0HiKJJgsiXNwXGSiX5GjvL
	Ac3vqCtIVy5/xOdazmh2bniCLpJVNjnU7dA3QgEz8p6XTl/sY6i7fTGCOAYTRZGo0DPoeNJPmIN
	lXE1bV5UuIgFHntuAasADulbWpVmlbPU4VT/NyfOZMQjcwOlY+2QnxXWpH0ZCvsR/8M4LB3Pr3w
	JRH13G8n2XGT7DnYhRL+BiJjYx4XKs
X-Received: by 2002:a05:6000:2dc5:b0:449:cfea:ca91 with SMTP id ffacd0b85a97d-45e5c5a6368mr32201223f8f.37.1779204600468;
        Tue, 19 May 2026 08:30:00 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:5670:761c:bfe8:8866])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-45da0a19c2dsm47458473f8f.21.2026.05.19.08.29.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 08:29:59 -0700 (PDT)
From: luca.boccassi@gmail.com
To: kexec@lists.infradead.org
Cc: linux-mm@kvack.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	linux-kernel@vger.kernel.org,
	Luca Boccassi <luca.boccassi@gmail.com>
Subject: [PATCH] liveupdate: document systemd support
Date: Tue, 19 May 2026 16:28:39 +0100
Message-ID: <20260519152957.548119-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 63ECB20009
X-Rspamd-Server: rspam04
X-Stat-Signature: 7zpfsssniyjm96u45ig4myo5jmw1zds1
X-HE-Tag: 1779204602-937946
X-HE-Meta: U2FsdGVkX1/a49KwjPBIBAKBVmFXkL6dmOCKFIhudcQDjLqklybB8nDgaMVpuYWVahSx4/Ld6ga7hhmqggM66M7+loZBLF9fHkAElvW5qz+pmK0TdnOAgHIaBc3zmxtmjk2DxLRg0aQGUK7Ip/q1Mr6/2F9z0JRXICd7jyjyF648qgU5x4KnxQHWOIwJdt1EylV57DDnJCW6ej+tixCwTx+LS0mLt/VdBfoy7mn51ivJ8vqiJaUPiK9/WTbZ+ygVoA4GmavVNGsH0LdoeIOjq4kEtulEoP7TEA75j4t8pfOKk6VkcHt8fk6y3le78pIsbIMfgJeNYG7+pGS6wwhPn5wHACeayNYHv2rWpT44/XzB4OhE4uGeasaDjoUvgC3F/YazKT1uCB6nTk2CC0pdn1BdpjDbNTh+57CdruRBsWI83WbdW4Gexmc8gRvszCn4jB+h44YeHblF4Rp/0l51uQ9ocS9BfQdaUnGbGTHMdtjggQjOdVC1inNABCBi2fID4ZPQIPJrrCIwzaqZx/aFVYgfeac2M9ZCyNIHmDjivrcDZ8P7FfDbm4GtOFNuN43BHPRwqyw7jtf3rpHgo21LwHKakoKyRX1UDfzlDL9QnTQlkuM2td7OqxzOqBoPQ0DA8xwk5fAYb6tR8uq17Pm6R0+sQCrf5X4Rpr7ll/bKEYgyVhgvvAlvpPimdhIurZxWYkP86rbgAhlpHOE2O2O2bxNSt/rZnJkqPR6jZqfeRA6rGirc67RVEOM+KLhFth23XGCcpHACPVOxNK0A5cyBUmKvm2qheP485SBPXwVU63wsIOcmy505urGtAWDwT3+jFmWoBpDDHSgtvE8M3+SKXGwI6V5NRt4sK3Spq8Jwym/G3cpQnMw/iu2omTiwIzyvE6ahvy+yEFs//XNIrsxc6sxQuVH3G8mOUsDZizduIB4NTQaz3MH+VnP+U+tYppcbySLLkA7bD2QnTNjAU6I
 FhvWWnoB
 zd7ouyWnSUT3SzaffDWFjLs6kpnhVi3YcUozL4amHQkthi3p3skgu2mrjFvUjdg35mE4D9RazlHsZjFWyIqb/lbk+seIVRER/VRYnFJwMNW5oGHbBNkWI9p4mMHAcYpHIsClhYW/wQUBYcyuA1fDoVMVs+vLS72yERcPBjW/Xzrq5CtCLsPdPlDZaST1vL0O19nTRV5h3pOdFDhxKpJ4B9coG5TRomnfHKp5bT3P88zaRTY6b7NE4eWD5rIjNO9tNw+YS8uLtWkRr+TJoYc2gwl1cKcwEAti2i0P2BtC3FuptZYJYNh3hi2KmmsYLmsnW1ky4f2hHAIGIbxd1AGd1rLA/hDmsuT6qUyz96ZU1/V7dMKKmkvb8tAMembvKdunJwXWgvvrLFa4G9NCeMUfS4QV8D25J/xU80AERFqJZwJZyWQfy9el+e/ar6jbf3aft+ittkRM1MPVfAWAP0UriMdrymWv2tO5+grmi00/o0Z52gXR1BBAhQ+xYmk8iqENChQeaRqkhzglVf/njjhAJzrPpgTXEt8YR97hxoeyjCBFkKyPGvuHB5VRgH6J3oFS9bacSDWcBf/JPGZlhgIUFJ+yH8wTJH9uwcRzOHAxdOH9uv5TcT4XvtQUOc3vzcphbZIMLQTu6xeNa5oF/ctXFbXaWycxGEMotnoBVWKCGqHNJYkb0kmqhStYZxQnEIXwowgfLZ+XmavRfE+A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luca Boccassi <luca.boccassi@gmail.com>

systemd v261 will add native support for LUO via the file descriptor
store mechanism. Add a brief paragraph in the LUO userspace documentation
page to inform users.

Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
---
NOTE: the external links will mention LUO after the next release is
      published, which should happen within ~4 weeks

 Documentation/userspace-api/liveupdate.rst | 23 ++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/Documentation/userspace-api/liveupdate.rst b/Documentation/userspace-api/liveupdate.rst
index 41c0473e4f16..f6efc32fb40b 100644
--- a/Documentation/userspace-api/liveupdate.rst
+++ b/Documentation/userspace-api/liveupdate.rst
@@ -14,6 +14,29 @@ ioctl uAPI
 ===========
 .. kernel-doc:: include/uapi/linux/liveupdate.h
 
+Userspace Integration
+=====================
+
+systemd (since version v261) uses LUO to preserve its per-service file
+descriptor store across a kexec-based live update. Services opt in by setting
+``FileDescriptorStoreMax=`` and ``FileDescriptorStorePreserve=`` in their unit,
+and push file descriptors with a name into the store via
+``sd_pid_notify_with_fds(... "FDSTORE=1\nFDNAME=foo")``.
+
+Services may also create their own LUO sessions (via ``/dev/liveupdate``) and
+push the resulting session fds into their file descriptor store like any other
+fd. systemd detects such session fds and handles them accordingly, and
+hands the re-retrieved session fd back to the service after kexec, using the
+existing file descriptor store service interface.
+
+For details, see:
+
+- `File Descriptor Store <https://systemd.io/FILE_DESCRIPTOR_STORE/>`_
+- `systemd.service(5) FileDescriptorStorePreserve=
+  <https://www.freedesktop.org/software/systemd/man/latest/systemd.service.html#FileDescriptorStorePreserve=>`_
+- `sd_pid_notify_with_fds(3)
+  <https://www.freedesktop.org/software/systemd/man/latest/sd_pid_notify_with_fds.html>`_
+
 See Also
 ========
 
-- 
2.47.3


