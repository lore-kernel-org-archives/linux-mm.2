Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52B5DD111A8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 09:48:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0DC66B0095; Mon,  1 Dec 2025 04:48:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FA496B0096; Mon,  1 Dec 2025 04:48:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79BD16B0098; Mon,  1 Dec 2025 04:48:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5BF1E6B0095
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 04:48:17 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D738160855
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:48:17 +0000 (UTC)
X-FDA: 84170426634.17.48C8E30
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id 46CBA1C0007
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:48:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=MAgoP7AQ;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764582495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ft2UmGA5efiA6Tnkdeu/pt2sAJb70nd3fcBnsirWxOw=;
	b=rexiFUfSDPrRJGqGF2znIFdmvVOY4T52+Y2ZwH/seEkmoyl5I23bFelgWl5UnH/C5FSTct
	oN40ysJ1yNE2/+BnrYA5Gq7f4VMwHjhQh+YWK0gZarRSD0kIz/ONjoe+1NkxI8VNbswZZX
	DwEpRZvfM0emKhstLNqNdtd+EJhTVTI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764582495; a=rsa-sha256;
	cv=none;
	b=REwdveg79srb0Z/ZRwjH5SaRsPoeIEjNmQngG2ZmIPSrHB1e128rJbKamuUj3NMYOueuhC
	+oZCeYpEu+Y0hQOPKtwB4wsymKTcixd/Zq3MvdgK1Rwfqx/3gp7lbMwoud6wuslfOG0r2Y
	UpFTBO+BgIH/LCxim+8t8GSXZvBeThI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=MAgoP7AQ;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7d26a7e5639so4073124b3a.1
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 01:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1764582494; x=1765187294; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ft2UmGA5efiA6Tnkdeu/pt2sAJb70nd3fcBnsirWxOw=;
        b=MAgoP7AQcYcloZYSJkC0ut/+DBv2OcvgHV8ULvduKLC3mbn3JyPglGjLYEy4GYRE7b
         YN300CCyeF87lpOvGQKrV8G+FzWrcJ6E+JU7Su/r4PByU2Edd9s/KgSOTvl9Kr0Snj7G
         EewUlaNsSDaCtuX+IQyNye/CVK8SGiQasWvQ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764582494; x=1765187294;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ft2UmGA5efiA6Tnkdeu/pt2sAJb70nd3fcBnsirWxOw=;
        b=N3HriWdPhtE1F311ar8CKGQhMgkdBqqc7kGKClCNLHugxy9TPRxOO/xHhg6QKuOA1P
         Z0SZg4BG+4AQg5HC8ata20v5psL/raodP7yz29ZeQr77/zUyUS+0InAINHAoOKlukoOK
         EOyIZMDHNacYrJcJ/wAlg5oFK0R236an8v7lM7RNH823MVL5yVCBuJSDSy8KmjW5QgVK
         SPlq26qOWvxLEKGWeqzh8Q/75vYlNY4Pey87Ow6ZSvu8okpBYdD0J3+lAs+Yycup7/zn
         m62OTmxIbpsrsiVAhkaO2tOkX8+dNEqDUvfe2pi2nRIXe6yxvGFi7L3SRo6iT7V2iiLt
         +PmQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTpjj1J4oWCXLwl4G/yOaBTsq6eyG1HFdeS9NFa0/qYibq4cdA3CurfcJNj8EUzsic/5H3DQeSDA==@kvack.org
X-Gm-Message-State: AOJu0YwOF6OZ4LUQK1qTdX5F4RHVpLa6I/OqKcBzRGbpbACHiuUPzwYe
	C7b7CsSTNGZ/zR+Z+ZY7AbbXPdf2SQdaoRcX/5uWMnmlwlBacKGWFvgt6+fSlye+cg==
X-Gm-Gg: ASbGnctPIo3qDPGU6WRBI5Z54jS577lE9yVirIbd4CyMRE17pJ6KwVYc19y1nigNV/I
	IjgZJo0LQcvP41ng/gE3GrE7HYYtk83EiMgVyjnO0iI1UwIH0/vk9cwlPUxLROKk2IuBRPdpL9f
	vDtL2qvNuhzsk9lS3LurjriU8IyqpvyuyYPOKxdIIfRqz3Vrw207Cft0Wy1nb1juTsi1U9/mhxi
	ASHYw6hatmhII3tXGyM76QjOy2PuvpCt86pMd5iSP4CSckR4WvLzUhypqh8cd+pWfENFOmZUI+M
	NHWe81cUJdk/U3fp6Vw8BUSNcEkD8If4iLmeafm/LhvtOiT/h+ZZhmO6rKz34XOnmWK01F2JfLL
	wQQYKwW2M/NBcsreEGsKy97qZY7mm9KofseGjOFHV65/9bO3fPKQ/LqGUE5p/DAV300FXY1+2QA
	MD1lWAxCDkVNI4wuDUb8zQoU7sn4F6Ci7swjwROyTM+mgxphk71HOd7A1mjYACbMrcsQRfzX0mZ
	w==
X-Google-Smtp-Source: AGHT+IFr8VXpbsnicegVCTPVhcS5UEK7jUpu+3p79wdFmEMCIo/SsUZlSBzDwoKUtRp+pBy2lth03Q==
X-Received: by 2002:a05:6a20:7288:b0:361:3bec:fe28 with SMTP id adf61e73a8af0-3614ed96c9amr43808576637.37.1764582494151;
        Mon, 01 Dec 2025 01:48:14 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:943c:f651:f00f:2459])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d15e7db577sm12882074b3a.31.2025.12.01.01.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 01:48:13 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Richard Chang <richardycc@google.com>,
	Minchan Kim <minchan@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>,
	David Stevens <stevensd@google.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCHv2 3/7] zram: document writeback_batch_size
Date: Mon,  1 Dec 2025 18:47:50 +0900
Message-ID: <20251201094754.4149975-4-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
In-Reply-To: <20251201094754.4149975-1-senozhatsky@chromium.org>
References: <20251201094754.4149975-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 46CBA1C0007
X-Stat-Signature: qsqksxk5k57cau6ju8a853n41ut8hcws
X-HE-Tag: 1764582495-703995
X-HE-Meta: U2FsdGVkX19MYhZj7iVhZPtEqO0ndX+J9SUPdSAVXMp4O1O5T5jwRRZc2qOZZLkLaYhuJ8N89Yc8KyKPujZyvLs5eyriNeM3RtbbZUDuoW8SpHtIM4B3tld8hc0GecAPCm4qX8vJLh0t0wZvjmoXfW7hG4Z5hZgSkU5AjkTl9BSKDFnNQEHHyS9j74vifZgncGtqm46XlQQcsLIkgVPGUkRw6Wz4440sfpBqY4IaFtwOKKI0YIwIaOPm2SynVgkYxvaWtyEjKygYoqkTuLh+8yhUoU43dhh5QDMHlpqPNQ+v2vW3KVpFJUkhRQoH8tpYxKKmTwGPIp9X8HK5x0bDeoFpocrZsMgExzfsphmjV6EXWWFgwmC7wQmuASuecogh+ThgAnrasJimfGlZQrPhaLKaxM3IE9IAjC+yVn2VsA/Atlo4NzUJRaKTSMoL44JbLPdOOVu6+EoWuh6B1RtPNghU4vGPiDGeqgVhIJZ3H9ir9FCpVONSX07AzA/Hock5tXf1SwC34HKXwz/e51TYMzHvUmMUurQ3iAvGbk0eJ8vi5aGtg7QEWi8yoHEDPnjTqnYdyNABH/uJIsuue8Iq63tcGgOgxZyjbjW3HYEjR7jNEqu7Sy6atUAdjSFKOD8TL26EmV+/rdXA/hGg33ZHUGaG7+EoIk8Ty47AJ0ouF5neUUN1DqUzK9g0XsqCq3lncA/gX+0bFPxAqdymUZx/BJ/4UGG9q9hQ939lianUxq89Bjdqc968UaEBwXC/uao0GemoOhSyllXcuuylktzz3sMZyJTqYh4j+TTC15dVnuQKjnsteB+HeDO8QgyG+Cm4Q+IUV0fepSzxtF499amC7CePM5YGw5VhyieHkDohtDwmtZI/DTTti6sdjLkMn5wdfBz8b5vDhx8a4c2D8k1bovQy5Xf/3cbcqatfvUN957XyQNeBlhKjeu7IaHLFx7vHTKXPde1rhpE/ftrgKXl
 kR63H8jl
 GnjD0k507hi6NbfxHTPgwdFF3FgPL/gTQaSo3pPo3xu3h8WaUspPRf4bFPsk1aT+6jXDpqA7Xr1c3JUpASiL1zk9dMJI5UXibbbpdippJ9/sKe35H+ilu0dU0GRnEmwP2t9CbWKfU1RBDkvmp6uKzRoSVogcdyk3nGlyLCxTwwGpbh58B4ISeXP6sKxW5d1LnfldMGMLjOafChcVjw4bPT3tq3dhackWymX5wFJ+e20arA/qh4P2t4L6dNzT9E6IkP6u7aIidO3E64VVRdyrUMz/2jOcX8E4oRgUcpgdSgwTFtyBLsQv4TbaNy6uGat1r6fiimVUkSX4nrxSoWhoA0MSgq3tWElHJozhR/wQqJnhfK3Ajx6DqGHUBuw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add missing writeback_batch_size documentation.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 Documentation/ABI/testing/sysfs-block-zram  |  7 +++++++
 Documentation/admin-guide/blockdev/zram.rst | 11 ++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-block-zram b/Documentation/ABI/testing/sysfs-block-zram
index ed10c2e4b5c2..e538d4850d61 100644
--- a/Documentation/ABI/testing/sysfs-block-zram
+++ b/Documentation/ABI/testing/sysfs-block-zram
@@ -157,3 +157,10 @@ Contact:	Richard Chang <richardycc@google.com>
 Description:
 		The writeback_compressed device atrribute toggles compressed
 		writeback feature.
+
+What:		/sys/block/zram<id>/writeback_batch_size
+Date:		November 2025
+Contact:	Sergey Senozhatsky <senozhatsky@chromium.org>
+Description:
+		The writeback_batch_size device atrribute sets the maximum
+		number of in-flight writeback operations.
diff --git a/Documentation/admin-guide/blockdev/zram.rst b/Documentation/admin-guide/blockdev/zram.rst
index 9547e4e95979..94bb7f2245ee 100644
--- a/Documentation/admin-guide/blockdev/zram.rst
+++ b/Documentation/admin-guide/blockdev/zram.rst
@@ -214,6 +214,8 @@ mem_limit         	WO	specifies the maximum amount of memory ZRAM can
 writeback_limit   	WO	specifies the maximum amount of write IO zram
 				can write out to backing device as 4KB unit
 writeback_limit_enable  RW	show and set writeback_limit feature
+writeback_batch_size	RW	show and set maximum number of in-flight
+				writeback operations
 writeback_compressed	RW	show and set compressed writeback feature
 comp_algorithm    	RW	show and change the compression algorithm
 algorithm_params	WO	setup compression algorithm parameters
@@ -223,7 +225,6 @@ backing_dev	  	RW	set up backend storage for zram to write out
 idle		  	WO	mark allocated slot as idle
 ======================  ======  ===============================================
 
-
 User space is advised to use the following files to read the device statistics.
 
 File /sys/block/zram<id>/stat
@@ -447,6 +448,14 @@ this feature, execute::
 Note that this feature should be configured before the `zramX` device is
 initialized.
 
+Depending on backing device storage type, writeback operation may benefit
+from a higher number of in-flight write requests (batched writes).  The
+number of maximum in-flight writeback operations can be configured via
+`writeback_batch_size` attribute.  To change the default value (which is 32),
+execute::
+
+	$ echo 64 > /sys/block/zramX/writeback_batch_size
+
 If admin wants to measure writeback count in a certain period, they could
 know it via /sys/block/zram0/bd_stat's 3rd column.
 
-- 
2.52.0.487.g5c8c507ade-goog


