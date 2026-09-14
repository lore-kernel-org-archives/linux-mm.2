Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC12DC88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 19:06:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A23F96B0092; Mon, 14 Sep 2026 15:06:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D7856B0093; Mon, 14 Sep 2026 15:06:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D0E66B0095; Mon, 14 Sep 2026 15:06:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68FE56B0092
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:06:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D755D16023C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 19:06:42 +0000 (UTC)
X-FDA: 85213299444.26.CB4F8ED
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf26.hostedemail.com (Postfix) with ESMTP id 48D9914000A
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 19:06:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GDNlEHgT;
	spf=pass (imf26.hostedemail.com: domain of 3v0WoagYKCEg241oxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--surenb.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3v0WoagYKCEg241oxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789412801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ujSbo2jvt2lKoandhJb4qBMNnRK+BsRTVC7UFN9IFo8=;
	b=D4A9YS9LAP2zIK1+ulFYf6XcToBzETMlS7Lai0uQr4lJwG8ZURyB9JzVr2yyi4Zp64mGlz
	uy0bN+8Cc5Dj8nvfFaVVhtQt91C0N4HwdrMpXsjIWYEJycwsmLm03Fkfb5OUvv/g6bDr2k
	bNrBtKQ6tJdoES0JYV4c6YUS91sC1xI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789412801;
	b=WTSh+eMFWw9CzkmTQuCvBw/6wuKB5bNQDAc3d/7wKJaE02O2HQgPnz5Obg0dZLgh8eDj6k
	TMs6lqZ3bUoRD1EjEHh67x8FuoYT+mvJv9Qmj87vmJg97NdC1TvvagKl+7uAMYYUi2uqdV
	2bhKl9+N1Wjsy8mGGil7lWAeXU2mVOg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GDNlEHgT;
	spf=pass (imf26.hostedemail.com: domain of 3v0WoagYKCEg241oxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--surenb.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3v0WoagYKCEg241oxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc2229450b4so3219478a12.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789412800; x=1790017600; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ujSbo2jvt2lKoandhJb4qBMNnRK+BsRTVC7UFN9IFo8=;
        b=GDNlEHgTqNGqp8jdjMIReEkNLddz0/ORucvroLtf4F9etVZDvioRp+Gx5D6clpK7gN
         M/uhqk/rZwCQYN9FpNmRGk3LbeuGvnWUMBvKZDHrgSFvf6svt6339tgmZPtWV8tRI0w6
         g/zCn5zTBPAgUMOx0/nmbRAdbXFwOhR/STcfmg8cS1qJ82bzcY9ft9e7UE3q6OTlr/jh
         YXCOnN0W9XJqrBdU0uxbm73NWlrF+uDPx9i8mKLUieBYfwBzTkG/j1haLu1pdNEz+bR6
         7KEOh+KcSZElKU4cX8FuoMnvBDbQRghBBcnjQSGBy6981a+pvfh37cvmIZi+coN6cuxU
         05hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789412800; x=1790017600;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ujSbo2jvt2lKoandhJb4qBMNnRK+BsRTVC7UFN9IFo8=;
        b=pKOkbFA5nxOqG2lj36JhOXPZax+CnnWED+gHJcRbh0HPJlvv4VC9tkoDk+lEeaN00P
         6YJJnbNJO2rCcNUtOZ0QF9FyVaFLawcjFacEASGx0QThY1Cl2srS8tR4rGA6bc/OyjVR
         C8+bSGrGLBBShmRZ/QIY6pUT5nD5PE+mv2mYB9saryjf5MDg2GwwD3+Xnnv+gNUdVTuP
         FTm/YxnSqN0U8x75eMid0unYCtzoZJperSqNdcjPD7cQtX7TBAoHgWgpiVHdaUytQMud
         NMM2v39aWINUQDPYpsvSwQnv/M3gIzaOUAIxNaiSlLPV2uksld3wkuv+JoLmX1t3HOLm
         yPpg==
X-Forwarded-Encrypted: i=1; AKwUvBy97fY2Dabt5YxIZ/GagDEkY6H6BKTJCF3ehthBYwSdw04F/uWme5q3bhUzwvCOG021Xujfs6OXsw==@kvack.org
X-Gm-Message-State: AFuF++kc0ahJvZPQ5dwiY6pPck59w7lzoIUM+Nfja4vfxKZXm3Y0r4Wa
	7Smo4NgOvPe27CdJrzMj97xFUf76TDL6lxrVogxZw/92p1tKceBPX5knrTtESwa6b5nV7nYfV4c
	TZDniWQ==
X-Received: from dloo1.prod.google.com ([2002:a05:7023:a41:b0:143:85a6:47ef])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7344:b0:3bf:6d96:ac40
 with SMTP id adf61e73a8af0-3db40480717mr8061849637.12.1789412799736; Mon, 14
 Sep 2026 12:06:39 -0700 (PDT)
Date: Mon, 14 Sep 2026 12:06:31 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.1032.g73a4cd73de-goog
Message-ID: <20260914190631.3167420-1-surenb@google.com>
Subject: [PATCH 1/1] proc/task_mmu: remove unnecessary inlines in function definitions
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: david@kernel.org, liam@infradead.org, ljs@kernel.org, surenb@google.com, 
	linux-mm@kvack.org, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 39as1qowd89umjdeheb8ramj98zwur83
X-Rspam-User: 
X-Rspamd-Queue-Id: 48D9914000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1789412801-319414
X-HE-Meta: U2FsdGVkX1+M51VhWXFuiNpsO4kItDTVQnw3bRaQ14YYcnV8IJNuH0Hw8T80RoUJp13fl5p2hpIIeHdjWMDWL02geMtHGN8fy+ID8EcANQL8QDdwMApHtiIEOXh//WMZGjlghOw6dUsS9apaW+e8u/4h2/iH7TdDny9H0JN9hm47p5dbsi39ZnSlhJI2XiZX0gxZIW+dODlZxVx34IWiuifzq/rQAi8fQfMsO87A2WJjs/DDb9wHVN8hv/tdE02l8Q2DklL7FsHuRsTQ8D06XBHXngZxYGY+3xLdS+ysgfLaW5Ajxwp1Gen9h2zuVvIpxx04sp1YE29cDv7gpu8aye/c5R/z+vmYJSjtYueQ/Rp+LmWGE0IBij0AIsEAxK+JlZ1ZV5gpi8poz67tXBwR87uefaaiDRZYMuSFi2abPRBy43Tb8AmyV6glQwHagwwsgz94Pnr+Dh8zXAHrDp8JLDfhm2GSS6XLIR3pGCF5u2UUvoDkUXPtezE5Rrfk1yPSZy92sE2/NcIIdxpc8K/KBIDBqSZpqrfGXQCxwB8gKWtwWISqjMLuG+f+8oDrXddidzQT0twhCZGNFvpBL1hxdYxPolwVWbV7T1+N6W77SmPimOC3qeHDiUpvGsgJEEhRVKSdefHOeGQv+d1clLAkBUj5gIl1CTXv0zsxLQGoCJPhEdXp1AYPl4UnwdWl/ZhuvA/g5zMSvBQLzfSmPKEEeuUW8aH6UGiYA2bzHjE8yCUDHtoNqiBffuKkbl68ECjWToOqjF2dUd4IQytJ/+o0yUkfNS4DZgrGkL5BJpUisG8NMm7errwIDvgdzFJ2mSNCb0WkF1jOQM4wCB3lCkg6xVKDrISYbvNcno9KczWZUPWCNxfEfZalusnPuxy3vwbbvOGPw0LbLAGRDHq7JFXBBDuIPxgmQthqHrTNH3uES+yCR5bnHGPYNBRMRc6/pWtg7azS/2vyqLZKmbddHkR
 i+lkdJHD
 gOAl+ePfg3szHtM8NPR9C37WyI+IvYtDXeP/L6tF68uhRH+PrDE7bFSvDp7j25ad8jcHyW0m+n6VXhEMRk3bqfGrM1IB2JCfDclUBS3Lq5G1Nfd3ggTbURBhN7yhwSrzS/0wsCRpkG/PM7sYLEURLGlZfALc5EEihJMg76Lt0ZBa/XnHHPhCXRgr0WSApJXB/A2jrNtZSvmrNnhZ/Mx0Q5ThJfWOoh+twsYdXwnwApU2zo4YxH9aIApcsoumtnatzuy1gqMX5W6TxxkDSsc5b19X/vqAZskSxJ/IXWEOnGPZ1Jy/AmwW9wHdsqZmlVcz/4W+EhjFDwLjqGhypZgaAELfaRFVEpk7pomCO22V8HEKY6IwWdZXeKFytdgfIDZGuMfUFwT0xsbTNMqv+0MiP3BGYY7nUA0inDMwRurQUOmZyNTt3MeTxjLnQ5QYKVoME2RuxYTTqQV0RWwHX7qm4/tDh6Xmupa1wgZ6M7cu6ZaWbIq0WC8e8U48w+r4o5cq4ZRBlmn6+Qc9XR3uOiuXooxFU7IXUx3Pl53Uf/RQok/o2l0DPgdg2h1xlK8Ueu3ELu3X9//qgj0Qz6V3F/LQIdLa2H2z7Bxw5rbRIP+slGBITYflLps2j1Pzy/pUZHvzXxeG6jLP0M3ZPbaWsvWxdY+rrbs9oXC+a72LZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Uninlined drop_rcu() and reacquire_rcu() functions are not used when
CONFIG_PROC_PAGE_MONITOR=n. Exclure them in this configuration.

Fixes: 7edb437cbbfc ("proc/task_mmu: remove unnecessary inlines in function definitions")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609121422.hkKWuy7K-lkp@intel.com/
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 fs/proc/task_mmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 24425e230895..f8790a7095ff 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -184,6 +184,7 @@ static bool fallback_to_mmap_lock(struct proc_maps_private *priv,
 	return true;
 }
 
+#ifdef CONFIG_PROC_PAGE_MONITOR
 static void drop_rcu(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
@@ -201,6 +202,7 @@ static void reacquire_rcu(struct proc_maps_private *priv)
 	/* Reinitialize the iterator. */
 	vma_iter_set(&priv->iter, priv->lock_ctx.locked_vma->vm_end);
 }
+#endif
 
 static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppos)
 {

base-commit: baa8de2f3448d1466a888a805c18d01c998fe052
-- 
2.55.0.1032.g73a4cd73de-goog


