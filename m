Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB375C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 19:38:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4FB86B00AA; Sun, 20 Sep 2026 15:38:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C272E6B00AB; Sun, 20 Sep 2026 15:38:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B184A6B00AC; Sun, 20 Sep 2026 15:38:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D9C86B00AA
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:38:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1FBA11604F7
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:38:09 +0000 (UTC)
X-FDA: 85235151498.29.4DF2E38
Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5A064140007
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:38:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PWn3QQqu;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789933087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xd0t5fQ0wbqovFneONezXRLopfuFSVDwWIsqSLQ6+6E=;
	b=Cb7tmxMHHvGjIEjJUJlGOnrlODwkro2vsOFVMgq5Cj2c3E00AFvuK3xR65Kk18zDdrxWqz
	513wM/LGQrTDAn/pOpKZkD0k+nztf+des+YTJime6zls1m3L5+8F+k3aLTlRwC+PdjIqiM
	GcnQ4EhCnfk3LVv0kqPSnaPvO0etArU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PWn3QQqu;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789933087;
	b=OwCNOkUDoUak+3kMW5zWwrBWj35DiI6GFAagq83FZ89O/5PffuHzEq2H+WkGdevKN77N16
	rMv9z9lIhlIENFlHTuP/vx9BkPKbRcCY1sfOPazaK8KPPyW5YohD864AP/zwYzI5IPGcFr
	/eWgZ5pa8Qkhg5BKudyIvhB+IjXhtoQ=
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66fded6b087so2183710d50.1
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933086; x=1790537886; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Xd0t5fQ0wbqovFneONezXRLopfuFSVDwWIsqSLQ6+6E=;
        b=PWn3QQquHRt6nyIMoosVKWJeLilQ2l/fVNviS5ydutI7fXAdmWKuHUplomxeSYC4pL
         2QMgAfzkqegocYeHMVWLf5ypmtzTQkvVUoKNa83ZfovU1FJ0TQcRLykIBMkoOshALFEt
         bOKdA1kPdFaRmy15noQT/CdCvukHsZ/A8ulL1ZCPrnLD2SKSoEzFOaSL/S/tudTHP9yo
         bJ15DkC6hNYZvo8NLNIRvNFZ6wG21V+DK4W371wGpezRW/qlILtNABVS66VpRtJcWAs3
         F8EqI+JjPbd5Rs1yMVIEv+QMVBeCcV0ATN7xdFTJwxE/PLsrx6mgCzn74t0dEI581yv+
         7HAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933086; x=1790537886;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Xd0t5fQ0wbqovFneONezXRLopfuFSVDwWIsqSLQ6+6E=;
        b=PlqUGIr+L7SulsL3XvnWyvr38qyWCVhhaOmch0YCTZzV3beBPyxXWosgTCmdJ9CBpD
         FKg1lhN7u5OQsGCugdjqs6SkCguFLuNiJ0CHxUnhWiHfeMBsELcOUn5ne4ylOsFQBKXb
         gAQSmOO7qKoKfErkcBvkVeDQ4tr8QIQadTfw0PoYrwqdecbQYRSlrl5pbnUCEm1ckofn
         VySEc6keBttdA6DK+QR2468KqQ99d+k+2EBqgQXwNLrQY1J49JuVvi39WwKRDwPCM3U4
         eiUzVyvPDkCOvEPAVIked3yo7Prp5vJwzh0dPTXSlVs4byPuwQw+dOeUTmzlnPuMddHE
         P3XQ==
X-Forwarded-Encrypted: i=1; AKwUvBwVFNUOK4SPvhObCHh97zqe4e8UZLIsnZzkzRKuU/jc6l7y547Jgbiu7QDyHPnxWxq+WcGabCr12A==@kvack.org
X-Gm-Message-State: AFuF++nM5T9QgN4Hi0qP3ODZ/7s/FF4Q6EHTlAg0Jo7K9brl7KmisMta
	QF8RtaOsB2s6Ls+SI2uO5QnNRLTvGa+MZOdsKdWo5fjlOiI8pzdBOS8bev+IyuF1ft0=
X-Gm-Gg: AYBFou2YGObBUodeGBQrwcEyhaGbEdCB+ZEf3VvRAD3NHxb3rMFkRd9VCnm874AqM8f
	cPR4HRQ0W0AmemDjGvJNGZ3IomsEB1ByNX62svpvKOqyXTfG14DAl+8VfUUR5fiLegAcdlNvuVj
	0CCMiUR1zrTHY9phhtg3K1fzwOviJdjo1TEU5GaVW17gT6VFPyA4p0YbFNuqQrfnfC3snVyxYEY
	rKgohfCdsING8YLJ3nGOUYbPOp6E/He8FissNi8tzV7fPBZV39M8HKEREQwajkCwzK7MtgNNs+A
	jipgRmkXhCvvnkuO1MSvvMm/0cM/kj6QaJiDeUjnf7SXXxDA7zKKQAKW1t+pixa4MecLxaIQlhv
	+bKf5IDSmeZ4fdtBjHxn7bLB/tyNyyjwcnaIlXsrji6Qr2sHjeV2CsHn3GN9fzI0pS8nk+SxX7s
	UdG77OeSeB00mIuf4VTJenq02DFxop2iQPXX+BVdYRUYWyIAe1PyLtZO9d/EBF7G/6U3C1Sk2Dl
	WEyRVq9pYvyhebhGe6AbZuzmm8EGW577Vc0/nN276GjQg7fmwpnJ/QME9WqrWhGdN+f4AAqRGf1
	KAmPlSneMpmrta2PXMY=
X-Received: by 2002:a05:690e:dce:b0:66f:c1be:a646 with SMTP id 956f58d0204a3-6717fd8f1ddmr2788927d50.56.1789933086522;
        Sun, 20 Sep 2026 12:38:06 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-672991445desm2614214d50.20.2026.09.20.12.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:38:06 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 12/46] liveupdate: Add liveupdate_session_name() helper
Date: Sun, 20 Sep 2026 15:36:16 -0400
Message-ID: <20260920193650.3373435-13-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: r8myu7mzoiucfnkhi1xydhwanx97g575
X-Rspamd-Queue-Id: 5A064140007
X-Rspamd-Server: rspam07
X-HE-Tag: 1789933087-425969
X-HE-Meta: U2FsdGVkX1/ui4iC7P2PtJGsl5OK0MnRRjSYfkKKUa01ohWPVWxrYKk9dPsUlQpcYI9arcEZyxx11+EPWscoL/mTP/7B/VjdUpVmHLPJrF8c95kME4HxcqeHBwBqsaTnpiRGShTjXOdZFuErXmVgjOuCRq2BcN7LIQFfVmXxEaF8+AQseQHusmpHjKjWnwNvFyYxv2zcTR4uu8Tvms2oVuNSD6l113Kj5wth5F44S9TuatnXs4C6OhlHwei47i/ajYeSly2rGL5VmnBDBFmqgBswUpNZ+j5FGwhbCCU8Jy55RzL0Z4QQSDaQnsb1zd7eY5i3f1GaThL9XS4N/0/0DxaQH/GTaZfclJDvE3He8ZwWzhRH9rr7BdaDHtNRyehcB7vA7FNVcW5TzYdeKXBLyyyP7wAoToMkg8cNCtRIn0jIPT9d42QHRHunNVqQNED0zTIXoQZjIFojVrZK5xIrqbEMnVFrMtKOJmSQGojlkpMCAGg0itPO7HDv4kmo0jaPJ/grRU678aD1qXIh9h1my72utfMOQiWCLX3vZSpcz/A7qQ21nSH7p4TAeojhLCdfzUqR8tVVdINzaznOiU9LUmRdWgz9MOwVr5MZrvSTnYZJ0fybotKrrwf/yJ+aH9e5KvnCEu4VJYBqG+680MwIIIlZjdvvaM1F1Bs5w3yPLF9QB99BSEgrod+E+99BsiN2f5TV3/Z5kBCUE3t1gTjp2Ob1uUNhOaxT9Gr6DEjlFRCKoQVmKQtc9nhfSSBs59GLzOtUGYf21TdLA/Qwsj52Gq2Iy3Hyls8TCuHPcvzMmd1ieRvRqp14CmGHhdI4KyNfpHXqRo2oELKH84J2vuBXl7Ws7fq7FsbbM71ws2UMkVrDEXYH1Jpdr8NBLAHHfzttC50U8RAXLbN1frP1JConftBqQTcQOMLr/CLDZ2cVpOLJDmpSnK6BEQH1cLMR7s3ch5A20x/RyrOUPwkwmVE
 r/JYnfgP
 1rbURBMLIZWUGjc6SYlPPZFZ5fGYiceVz0kIXXFRgeQ+IxGZXXCxbyyxAEXYxFe92GNiPZhZfTnrpiPJ2uXlnygT4SqTmz8u0s3P4oqvr0gckWdJD4Hw3WU+dz6wi+byty/0U4EpQ4qFAvFMYALuDwZnYDG9s/LPSS6Bq8Gp1Fzl49lyFzw3DSI3kOi4B+XBqhoIX0mF9VhndhC5FCVy+m7F7O6lmdwnCC52IGnVxjPsbfTgav6M78kQxCkVjQh/gILNiLgSCsZZA62ogXle8yQdon1lqfxO/Z2f6bz8/N6uMNlLg+1oDWmIL3enToMGV60TxicfIiB5xeEMbDdMTm4kWoGiJBcXueR5BS84AvdF+t95IpesZELiLLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Provide an accessor function liveupdate_session_name() to retrieve the
name of a live update session from its session handle.

This allows kernel subsystems like CPU preservation to identify the
session managing preserved resources.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/liveupdate.h      |  6 ++++++
 kernel/liveupdate/luo_session.c | 14 ++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 6051abc0612c..119ad0f82705 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -256,6 +256,7 @@ int liveupdate_get_file_incoming(struct liveupdate_session *s, u64 token,
 /* Get a token for an outgoing file, or -ENOENT if file is not preserved */
 int liveupdate_get_token_outgoing(struct liveupdate_session *s,
 				  struct file *file, u64 *tokenp);
+const char *liveupdate_session_name(struct liveupdate_session *s);
 
 #else /* CONFIG_LIVEUPDATE */
 
@@ -321,5 +322,10 @@ static inline int liveupdate_get_token_outgoing(struct liveupdate_session *s,
 	return -EOPNOTSUPP;
 }
 
+static inline const char *liveupdate_session_name(struct liveupdate_session *s)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_LIVEUPDATE */
 #endif /* _LINUX_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index f48e9a4185f9..3c4f195d375d 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -683,3 +683,17 @@ int luo_session_serialize(void)
 
 	return err;
 }
+
+/**
+ * liveupdate_session_name - Get the name of a liveupdate session
+ * @s: Live update session pointer.
+ *
+ * Return: Pointer to session name string.
+ */
+const char *liveupdate_session_name(struct liveupdate_session *s)
+{
+	struct luo_session *session = (struct luo_session *)s;
+
+	return session->name;
+}
+EXPORT_SYMBOL_GPL(liveupdate_session_name);
-- 
2.55.0.1082.g2b9226bbc0-goog


