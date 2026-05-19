Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6321FCD4F52
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 08:13:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 874E26B0005; Tue, 19 May 2026 04:13:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 824D46B0088; Tue, 19 May 2026 04:13:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73BDE6B008C; Tue, 19 May 2026 04:13:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D3296B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 04:13:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 04BE6C0A65
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:13:32 +0000 (UTC)
X-FDA: 84783455106.04.CEE77FC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id B05DE1C0003
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:13:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i1N9qA0j;
	spf=pass (imf20.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779178410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8Zek5lka7I+V+M7YhuZBNsWHTpvMuxGl7NM9kjldurc=;
	b=t1w0WYfx1LPNSbotRupBa6PMvAtLhbJ4huvqFHJamIKd1CVQMX04eKFsUpj6YKV+Rjm2UH
	LgF9KITUs9Qhh4MVbTcZTrD1WgsrFWp4ULTyYeMBqYMdw32+XArA44GEVlZ8egzhyswPUn
	bXr+VFfzuv+rl1wZMzlhcEWpD1bMBwA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779178410; a=rsa-sha256;
	cv=none;
	b=Y0/PrgIVvubl0NaAIj/fVoeNQ5w2bbzUB//QSw1Cwrp7+d6Sy/jkZlcUpGAKf8fz/6awE2
	yi6vaZ5+dxaxn383DNufLQFiuLUypC/TqaVc6dRiBWo0A9TrUItFKbUbr6dlM+8mPh0qsa
	Pan2leraovf+NEOmLRkM4FcyrZeSp7Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i1N9qA0j;
	spf=pass (imf20.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779178410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8Zek5lka7I+V+M7YhuZBNsWHTpvMuxGl7NM9kjldurc=;
	b=i1N9qA0jOH92pu5vbOleiVTBwk+QM0pMQwFUV8pzItHyqUY5PslE/gJXKxeYQ1zjGoRAlH
	JKqJZffbDfmYX6I39l4cS4rn68pQpn0DSVrIu1CxwcfxlfCTB/NverHsa9095lqVX2wxWt
	Uy1U6vC+SVqpHEmUB9soaEPFVL+sYD8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-rvpVrE24NjqIPDmOtfLpDw-1; Tue, 19 May 2026 04:13:28 -0400
X-MC-Unique: rvpVrE24NjqIPDmOtfLpDw-1
X-Mimecast-MFC-AGG-ID: rvpVrE24NjqIPDmOtfLpDw_1779178407
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-45e80183514so1508484f8f.3
        for <linux-mm@kvack.org>; Tue, 19 May 2026 01:13:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779178407; x=1779783207;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Zek5lka7I+V+M7YhuZBNsWHTpvMuxGl7NM9kjldurc=;
        b=NsUmgswN3QLsFafePfxPWohvnrBUmLOnJeQHqW/inMuJ6swgE0nywtB6owM7tUI138
         PCt57t52yDQT1j1MvP7JpAweusApHC453tbt6nDI8KZlMAA0S2hlQ5GgpojglXmWk+/f
         vTJC3oWarGb0uQ7h2k1x85q+aHS+C/9/kS13dcraZT9H8jEgSnArTgUlEg2/ga0jfqzt
         2WYDNIsAaTilLECTnpw0Qi8NjLKWR2wQDfAFODOQXEcyDQN9o/o2MDkG41MKqIp8DHEN
         AHahEzWLfeHyVA0Q+S5UM1SAcyXmUq83QFI9p2arMf2RSbR9ZqBMwyuUeIFjj8ZI6Bn/
         EgqQ==
X-Gm-Message-State: AOJu0YxmulYqcx77TTFjaBTZ6RT/kElExHRNZGPkmgutPhWF67YRjzd5
	h1qs8d3JYySMbnSrxaSu0IcaAyxKj5hVlbH11HnTVp1rk+1AhbBTZ+iwMhNJXfX/jYUF4W7G6wG
	3v76SNK92XZp1DF4vgdI+5uujgCy+w6sB3eBG8k8P3iSqfa+DDqum
X-Gm-Gg: Acq92OHLLMn2gYJbWMNLNWzQ+cB3j2dk5URrWudnTs+w9m9PUdbgd0e+C89+4+TdpfE
	lqJWmH1uVO/8b8ym/8ra1Wmk4FjtJLscfJ60oJhMEy3saraM+i5S4crRMcfUhtw0ztw6OoahAyP
	EIeVlP6v8Q83uQMKxn+H/csSWTY0LuHJN/SmjmgixaSCoO+DZILUh/lKx5hbTwAfqN8zUsPQs+F
	Q5yyJJBwIXX8TvYPyDnZcYNlW0od84g/ydblYczDa1ZSUZvAbvMzl+kvLw1Sah0tnfrwWMlQ4Uo
	3uEg00fSfF+B3/TkeJ4+UmdgiRbDWgoBGLFWCPNF6TvyJPeUO3F4vS9guRsw4dD2ksj6WPQqA3c
	TS/1m13oum/rqiWYminTr2qu/32LEej+1bmAfO8FmPyMqdmT6zl0gYxhWB+QruSc5ELhoGnywkM
	qQ
X-Received: by 2002:a05:6000:4014:b0:441:1fa5:4577 with SMTP id ffacd0b85a97d-45e5c5f20f3mr28554558f8f.26.1779178407424;
        Tue, 19 May 2026 01:13:27 -0700 (PDT)
X-Received: by 2002:a05:6000:4014:b0:441:1fa5:4577 with SMTP id ffacd0b85a97d-45e5c5f20f3mr28554511f8f.26.1779178407031;
        Tue, 19 May 2026 01:13:27 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (85-67-173-121.pool.digikabel.hu. [85.67.173.121])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da0fe2464sm45189485f8f.32.2026.05.19.01.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 01:13:26 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 1/3] tmpfs: simplify constructing "security.foo" xattr names
Date: Tue, 19 May 2026 10:13:21 +0200
Message-ID: <20260519081324.979769-1-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iyGRrbcYPHSo5LXEV-SBGwmWx9uOflxvcwOLfYd6nMw_1779178407
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B05DE1C0003
X-Rspam-User: 
X-Stat-Signature: cxjw7r5oe6mbe9btom9qqhkw6ar18c31
X-HE-Tag: 1779178410-969632
X-HE-Meta: U2FsdGVkX18RfMUM1P7SY++M5CYmTE7YoRvcglnaFiTVpcVMm2mlfZq4dscip5u/VNseRV1HZEqikhBmJPNvZHlhvWrmvkT+kfJQRHwhmMDgk8D7M/E0p9oEx4ws5cEoqhQTB+ACBpq2B8uyP+Zy083NTq2kfKW/ZnvbHhrHiZtLFElTIgwZpUr3lnydJcmfZg9+5iF/2UFc7nROnf/UByO+ydwhzzXpcW8cm/DXLNzsW+5rVgc3JsEM74iirrIyQY0bpVHusmYDeVIv5VdzkQxmR4UF1NHba/lKFR1VNg0vEnzLz1vLmQpa/ExUna5touBehEngbChewdw7/ZqyXy8NWbMlpujLVoESD3JohWH0RqXWYoDimqwpZnsgdC3KQM/fcSSA+e8g4vNOLxYddHPw8eUligRhxnbPAxQo8Rsdm5ZwWU+uSOTLhAPipTzuIL/wOkTzlLe8LJWU2EXMMiaVsrYndrLvY8GgzPTMsKmyC646IjeNj+Dohp1HCrnJrJaqL55Drjcy5QhJNYAj3DT1WjYTprBbDBE2Cy5OR1Y78pck3fO51DpCrSdVrqslQX4GBGuzE6NBl23i2CUnxBw5XTCQJHiGvEjvdkTRO3QsgHnHp/kdKsu3sEEy7JI9kTh+W1r1KuPsozEkha63GHOwIjURy/bbsnzNKwvvi8Us/Ab5fmbsJ0zovNE/ku7E4kdQzb/KRoflA6B/24rdGWRt70JRA7JM7g62a/bh/eqRDezeJwENZK3IkoS9O0LSaOF1V2bNkrLGOWnZcZuckKRol0mE2+6nMw+PYsCFfZEKaVrU2Jpcc/oErvJdUgH0GLRSiCbEVc6LJzd2+f3MptZtdcJTe4so92VSRNn2Q9XRenYtBEsW+io6d6AVbevC8O9EMqj1XPo42zg3VWpTXCdR2atOySZau1N887pmmRWDctIN89RI00VtCOS7fZJONPzKEDgXwyHAxCn2ifM
 0r2pQH/1
 B9WHpYGbdzv9eozXGGmf9/5s8EKygiMGwIe/wyxwG7j6GsPu6pFAybyAZPWZYajGnkJ9cTiZydChItg4GabXe8Ibx8A8+bchilGKVDxpvDupJ6XQkl+KD1rentWCzPi0JGPsGxIRtKThProHyUDPpG2AG6HZKQEF2B3D3SYGJIT5uYR9/+MxLoBvlbzzaqgrswMhFxAu3Mcdq8gN1ovahu98KKgjsh0UktSmt1XajQYe2MvbBP6NEQFICNoJOcqTpIzSgIdeDFI5qBDMpousJ6tF7H0o+frh4X+nuCil1SP3/AKj6w5b/W270YcuRvRCXil5k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use kasprintf() instead of doing it with kmalloc() + 2 x memcpy().

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 mm/shmem.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 3b5dc21b323c..c7897570fc9f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4232,7 +4232,6 @@ static int shmem_initxattrs(struct inode *inode,
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	const struct xattr *xattr;
 	size_t ispace = 0;
-	size_t len;
 
 	CLASS(simple_xattrs, xattrs)();
 	if (IS_ERR(xattrs))
@@ -4260,17 +4259,11 @@ static int shmem_initxattrs(struct inode *inode,
 		if (IS_ERR(new_xattr))
 			break;
 
-		len = strlen(xattr->name) + 1;
-		new_xattr->name = kmalloc(XATTR_SECURITY_PREFIX_LEN + len,
-					  GFP_KERNEL_ACCOUNT);
+		new_xattr->name = kasprintf(GFP_KERNEL_ACCOUNT,
+					XATTR_SECURITY_PREFIX "%s", xattr->name);
 		if (!new_xattr->name)
 			break;
 
-		memcpy(new_xattr->name, XATTR_SECURITY_PREFIX,
-		       XATTR_SECURITY_PREFIX_LEN);
-		memcpy(new_xattr->name + XATTR_SECURITY_PREFIX_LEN,
-		       xattr->name, len);
-
 		if (simple_xattr_add(xattrs, new_xattr))
 			break;
 		retain_and_null_ptr(new_xattr);
-- 
2.54.0


