Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 913FDCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 16:25:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCAD36B0461; Mon,  1 Jun 2026 12:25:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA3636B0463; Mon,  1 Jun 2026 12:25:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB80E6B0464; Mon,  1 Jun 2026 12:25:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BAD756B0461
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:25:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7C69516271A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:25:02 +0000 (UTC)
X-FDA: 84831868044.22.0DC536C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1F96CC0012
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:24:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="HhizHSD/";
	spf=pass (imf10.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780331100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cY1uXoengy1QKd4o3p+NIvdoWhVTneNFcdj5V9k5ZxM=;
	b=sd0j55pbMlEtuTx7h/+Y42feYbKDt8Rz4IepH1rPPCff89vfIUUAylpUYIN8q9w7AXt2JB
	D6DvSUkuuhLBA5PwSjWYLFOFcH7Qsg3/xlvm6coFPQpzI88935RAGp7p0Sl+hU7z9N2nTP
	TeP9tvLSQ018BQD1ulOuUBx/bx7rIH0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="HhizHSD/";
	spf=pass (imf10.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780331100;
	b=aXTCTxpvtZsW4dAS9yKrjAaXS9vW+kfyNBME/ZLBF1eRTWXjAHH9BQTxAjC14t/8Mn8J8K
	UN37hZDUnI0fO0PmdbEJLLQsdXbjT2IhePCTE4sGaNw+DxkTmxm/XYCODb+u3wrfzBDTEa
	ib7B/zPzxbBJ35689S7sohOORWS7V5c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780331099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=cY1uXoengy1QKd4o3p+NIvdoWhVTneNFcdj5V9k5ZxM=;
	b=HhizHSD/PV6wJpKrouRlNSIRPlvaxrysZlNcYCPg9k3q68gqoDanR5zV73HW7FBR9mQDoR
	iDRcRFUHT9njb4Htt1P5yH5EnGBUg5PkGuKyxTd7DsZVe6QYI81BeyB4MpIuIPGo8O9utG
	UnMB6czj2qlsG9W3zjw7LhFJixQxPPk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-456-DfgJpTXoNJeznpmv9ny4mg-1; Mon, 01 Jun 2026 12:24:58 -0400
X-MC-Unique: DfgJpTXoNJeznpmv9ny4mg-1
X-Mimecast-MFC-AGG-ID: DfgJpTXoNJeznpmv9ny4mg_1780331097
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-45eec27f5a5so2316691f8f.2
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 09:24:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780331097; x=1780935897;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cY1uXoengy1QKd4o3p+NIvdoWhVTneNFcdj5V9k5ZxM=;
        b=sXncoEcMAXuqbubTTdeRQkPli4AKjsmhPJb9R90Fj9brUcmv+i2gIf8whXrHj7wTxH
         mvK4q5zgbTVQfkOudepg164IwzLlmginJekH0GT7PKQ8yqGkhlRp5QaR9DDxcZSDpB7q
         Bwj30SAaffsVDfI/1zoHChhuAE/qepRFKIvxqUidclUxwscbXyCTZHDH3NMjebEODP6E
         Mpj5mzyEoRiSBAZtcB7L1m4HqHWvpdv1tmIz5ehht26eZtXnhD4+bXZnxd28uxz3gfOv
         0TXLoqgHWDx8F6+xNbyaIwHKkkOVJ4+1ZXQqoReOmb6BqYd5OhGD+B7xrKTSPtIvHd3B
         92vw==
X-Gm-Message-State: AOJu0YzzmERIdcoJF+xCKmQEFn1VHspaO/c8Y1T0GgnmXZDXGicyQtYg
	LiRUW+wuy6LlMVmDLtB1DLsT7KcsakdW7aUm0elgrk4r99dI1kqEyNjITog0YieWbK+28l2UBkU
	OUk6mfFqttJwmO3QpZ4LYyGmQnPwz/IBUhr5SaOUzINBEKVedIF9tagCRcH9b
X-Gm-Gg: Acq92OG/P2qAQA1Ss/A/Z3uzYB7yy4LBnDTurxdIz6Rn+eEDTXLteXbD5pi/qtPdYXm
	xmcxYxaNnOj26otK4O2DvuI5ymBrIn22CX5uidfBy45MFcEDhn29nBjSXCY8X9jr8K9T66vMYgU
	Pd1DmgciUUdoLoxfnNpxvISOwtef1M4LI56jY46+zqsHbtjWNEtjZ/NwQvlJfGNVQDeOxZC13n/
	PiecN/9whilf1WMIvGkHlZVeoFjj72nq9jhy2IL7cx8nHpc1ybPpSGfsDMOpjU2iSGTnGTRyNJP
	SsQDdOcHRZ8gX7GmUAh13raCbpO0FxpPbBCOepwhLU+hw0asahaHJsKz9d8xXcM5VNIgElHa78d
	odBeQyidXjDrH9m+Bve1iukJrKgvmrm5sNNn4B9e4x7woFT4cPrc2Ny6q59jGEB4V8jaAwEfyrJ
	ADi4D1VjkC5+4=
X-Received: by 2002:a05:6000:c10:b0:44a:b931:f32a with SMTP id ffacd0b85a97d-45ef6b5d61dmr18077824f8f.27.1780331097091;
        Mon, 01 Jun 2026 09:24:57 -0700 (PDT)
X-Received: by 2002:a05:6000:c10:b0:44a:b931:f32a with SMTP id ffacd0b85a97d-45ef6b5d61dmr18077795f8f.27.1780331096714;
        Mon, 01 Jun 2026 09:24:56 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (85-67-174-180.pool.digikabel.hu. [85.67.174.180])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef356b129sm33036213f8f.32.2026.06.01.09.24.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 09:24:55 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH v2 0/3] simple xattr improvements
Date: Mon,  1 Jun 2026 18:24:47 +0200
Message-ID: <20260601162454.2116375-1-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: AwcStBwsL1H51fnfENGEogfqx71pk0Ep_ZxXXPf6G5s_1780331097
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1F96CC0012
X-Stat-Signature: 6c9qshib9tkyhfy3eg4p5ny9woewffqe
X-Rspam-User: 
X-HE-Tag: 1780331099-914631
X-HE-Meta: U2FsdGVkX1997tcBF18OLtWYfpml4WE+MXtZmCi8WisU6D0oFXA8bWI1Aqv8rtAaQlyVTB1l/GWXKvneBIYpccDadwxvAlTE8ol3VVEKvtifjSZ1kSkTULVvW4Qc0RPkqZCIiVFMz3Z3xGjIJiT2Oqx1Gp3gBJsAFK3MkTSSdyw66uDW1R4k1p6cCv64C7FVdr2TERxwoYe6aRuH6oNYX5jK1x+uGQyIUbO7p0D0tc4aDu+hlBA8dRCUWOxE44f3VG4vEnnguOjh9uX/nXaTM9lKqwbqH8Ti/NSttYvhSDm0J7bNOBcGic/z4hMKa3jXtEYebYu67+DSe8rLFcqxJWEus3+O1h/lZQj9J6ivKp7F06BGuwCCCSbLGQu1WZbinE5gH21SlO5pkDR16uL+aw77s2tsmxAWhw8AE8gztWi9jKyXVTAdAgGseZo689aanJeXSCtQwv2a9sDWT5+9DP/vZTYVbyz7+1BEr4KGJGyraOIzy/sJe/7mQFprerRgTgMK51XMc8L8oGHVLZdJPbmPfWoQjoTnQwXpVO4d+Q9HEjiw/u0fxaxOt93F7dXmPOQFmG1L06yFBitIiQGytYoCwU9rse7i0z4pr+FtrcojAux2yEn6jpCIKdrvUM6L7osZ0uFdEgipKPn1oqVdoyUpVxNAtn8cPcqqOXWQ+jz3XkFnwrPr/Qx4eNdzuam7Vxqh3rboVndGxfT/4nhZAAjPdUd42SiBFujKaI2DQTMlqKB7Ij9FlQgSRKijvfoHqHVd3fFr52hpZlJcT9XxFdEooofZMgYirZTIpW2F2pcIyckltxPGVI6qrAIIuGabaks+5Lbs6p2P9BPmrbhNWQggSKHL9L37w4Gz8OWwTzxnpZSQITW5R8ew/mMVO925k0yndVKJxBe7rNVhiizGlSrQNEXQbT+UzS/PEA+ck1HFFDH7fyJiu8dHLE3dOyspFH/XQXFwZeSLQqybv3g
 hElanhta
 bYOk5QVnL6kpTSQ6ubUdNQo+Asp84sGTKmZy/ryF31IsIldgEfy5UV2Vga+xPJ2nmjO+YLgOfhPhBos/tUDr6j4JP02Ltnw3FoWK1CV4J8lXgY6r+JdyF4EuFcLA/fluc79UilJxpX8OkH6g7tMjQfxoCYN+naLpI8+KESd6sMxUEd0QCK8IvEpz8ng5jtLFFkryJY2kSV8anWDL9d6XiJx6NTUcmhd1mGqPRGUp/w21n1euIRKXAIdqa035/ur2xn6AnCKKVIjiN24aXsTIMY6cYsubuJAjlj+UMMeq4e376r54tHD8ag4kQnoW4wyRiV8yJVhKpflAK3LLIFuLaB/dPvIBqxtaOoL2S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

v2:
 - don't use xxhash
 - fix lazy alloc concurrency
 - fix rcu freeing on evict
 - fix rcu walk of per-inode list
 - don't double account freed space

Miklos Szeredi (3):
  tmpfs: simplify constructing "security.foo" xattr names
  simple_xattr: change interface to pass struct simple_xattrs **
  simpe_xattr: use per-sb cache

 fs/kernfs/dir.c             |  13 +-
 fs/kernfs/inode.c           |  28 ++--
 fs/kernfs/kernfs-internal.h |   4 +-
 fs/pidfs.c                  |  45 ++-----
 fs/xattr.c                  | 261 +++++++++++++++++++-----------------
 include/linux/shmem_fs.h    |   3 +-
 include/linux/xattr.h       |  35 +++--
 mm/shmem.c                  |  60 +++------
 net/socket.c                |  30 ++---
 9 files changed, 209 insertions(+), 270 deletions(-)

-- 
2.54.0


