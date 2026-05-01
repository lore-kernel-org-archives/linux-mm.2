Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C5FBFF885A
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 09:49:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 810166B0092; Fri,  1 May 2026 05:49:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C1356B0093; Fri,  1 May 2026 05:49:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AFEA6B0095; Fri,  1 May 2026 05:49:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 53F606B0092
	for <linux-mm@kvack.org>; Fri,  1 May 2026 05:49:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0BC678A859
	for <linux-mm@kvack.org>; Fri,  1 May 2026 09:49:42 +0000 (UTC)
X-FDA: 84718379004.08.8A50EB2
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2EAA91A0006
	for <linux-mm@kvack.org>; Fri,  1 May 2026 09:49:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KNYdGThs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of crisjacobmaamor@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=crisjacobmaamor@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777628980; a=rsa-sha256;
	cv=none;
	b=7IJ8qCXWS9qxZfpkjxkVuHBB8Xu6rZdc+wFoqHu/dg3gYBbcz0PwukSBhkjmJDHFausb/M
	ObhWXJCh64WOZTFc3SpDOv3r/AsJQvn92kYhK29AC492tS/yteoOvqDnp4jX+gdbWFYF5w
	UVm91qf686QBGu7qYIr1ErxMMelGso4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KNYdGThs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of crisjacobmaamor@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=crisjacobmaamor@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777628980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jpzP5NyCyl9kBFJtSorUnmMXLVo8P2gspi2fH3AtFbE=;
	b=253PL3sQoNzRpLgedBmAVCMkpH8SisU1YaLWtgpzihumE+xd77hW+lW34vTsmRHtqtyNpN
	mh0rwOojHXIi8aO8y1ChstyMq2vd7kD/U7Q79MqpPsN8LvCD9/E6eKfk/1voLdatOaLjvX
	J1W2aqwk5oCQo2aKfZGiKbmkAKaO0f4=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-82cebbdbdccso1059191b3a.1
        for <linux-mm@kvack.org>; Fri, 01 May 2026 02:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777628979; x=1778233779; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jpzP5NyCyl9kBFJtSorUnmMXLVo8P2gspi2fH3AtFbE=;
        b=KNYdGThsuxjVtvfIlN81sYgCD5PEToHHrZeVLxyn8/3mEtbIOWp8bc70cRRW2GwGoO
         QD0GpNoxNtDfpNetaNg8/Tuf7TL/86+MAWAL8lepVkLdZxKuKvEdVGPTSUJX9ImbSNuW
         zsnxfndeu2fxzjwdk8GDGP58W6lfYjWNNZT4cGgcJB80mZCdZD1qxfmIhaKEqgoxtgca
         UD3s9DouM8pUmYxw3buYVLdCYSyOcdf7V4sOEWALswMzsNh0YUAwm4rHGk6tSdaVQQlL
         2++mwMLT2kwgO9P14gltsyASLVtKvmTX14SbRQoEdy+IgQxYamVS/v/yQu8KYdf79LCN
         F5Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777628979; x=1778233779;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jpzP5NyCyl9kBFJtSorUnmMXLVo8P2gspi2fH3AtFbE=;
        b=YwoZRyysrkAU1KfOYjH2INOWAKkgXiRckQMgEYBa3VFTpEslCrkvxedr3+U6Jqh6kT
         9DzpHg4jv7n//e4z3QAXv7LgOxnelEHT0PDzRWHDsqb9Eb0rz7s/SXxlGJ6/+QYzx9EG
         mwNIvoZ8on8gQD5pxJ1OOKFB/qwOd0jV2Wq8Ah3ECdhwg9cehvhxUXyMdQKLGiPvjTDp
         X7nPqUC3ydzNXBhMl0e2WMjVejh4S2qHLAfZHsBoOpsifegYkbMGFezrS5YySKtlUWhD
         FYzGOLvzLA7z6gDFCvj3W1zM1vM1pcXU4nCcq66Q4rOMS/A5ekay4E6Iy2hOSiVUhjpr
         BdWQ==
X-Forwarded-Encrypted: i=1; AFNElJ8Vc6ba7RcAuNT1u5HXhc3fjGweDVD59oauSFgFe1NWHS8KgG2iPKrAq66DXcB4gnwlo+1G8Uwqcw==@kvack.org
X-Gm-Message-State: AOJu0YxvXhueKdDsr2lW59NVmse3QYbjOXlKNO8X6p2p6pedsRDqHrd+
	+W3nIk5ZICi/jcBylF6WKPVUwXbRtEYfeq8fI0WOCIs0wBc8ZVel4QIm
X-Gm-Gg: AeBDiesGdVTpuBafatInsZ41mswzUgvrTU5qcSnOlrWt9a5uwRFB4h+u4rqR/MHJwz6
	de4/sX7GwieAgdMgmJOdSUy5Ks5kX6DP5axhbSW0gH0k4bbX7FBXG8iRbyqAkhT22nqmO8uuqTa
	kYHUQsLoGKzAp3NMgt8h9Y+AmvpY9vjZ6Ohvt4sapLxfGjxNlwmbPg0jS4F0YL8upW2Fm6xPFfX
	TTZPf9yBCwJqMqDhuBlGvb8iVWiIGctyYdrjIEJE2RjViaVGKBCJjGqo0nP17U3IOEfxynIyyH9
	/Rfa4hgL20itmDiKcrY7KUcDKssRzVvmIF6/IbKNTlG5p78sMvOTueZOwVZSZDTY7+xSgUCes8g
	m3uAgSp6Pk+dWyaUp3mbATdnWJ5fv6KfXJMjJfbh7i+YMv3TzlDg2KBum5buLL9IZgXX4xaJYLl
	BRDIUBod8jQj6AJ5WwGl9sIZfITugRJisglznuWg==
X-Received: by 2002:aa7:88c6:0:b0:82c:9c4e:66ca with SMTP id d2e1a72fcca58-834fff74303mr5699537b3a.2.1777628978910;
        Fri, 01 May 2026 02:49:38 -0700 (PDT)
Received: from laptop ([2001:4455:8025:be00:eebe:247e:613c:24d7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8351582dd55sm2042729b3a.1.2026.05.01.02.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 02:49:38 -0700 (PDT)
From: Cris Jacob Maamor <crisjacobmaamor@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RFC 3/5] liveupdate: validate restored LUO session metadata
Date: Fri,  1 May 2026 17:46:35 +0800
Message-ID: <20260501094637.38650-4-crisjacobmaamor@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260501094637.38650-1-crisjacobmaamor@gmail.com>
References: <20260501094637.38650-1-crisjacobmaamor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: woxeg8kzzrs4foq3476iuhn36qus6wwk
X-Rspam-User: 
X-Rspamd-Queue-Id: 2EAA91A0006
X-Rspamd-Server: rspam07
X-HE-Tag: 1777628979-574488
X-HE-Meta: U2FsdGVkX1+F9jFRSXpNGUMdUIRnPYSpaGFsXM4C1KEevNYpUwO28Gjktr9UdREPMSC08GQrY2DRGdzBgY8gZNIT+TpZQgNMYlK2G/W2Ds45q6mnsHSbI6bOWy4t2bchTfcc1Ksu8Grv6pYSzJXpG5hcHcwOOMOaczQwPmGe5cs5o0lhJs2Bbf3S8ZITFDuSTbk7B9mtQ8+8Ynysnff2JFxIYK1It/D6f1QUal/QHoplzRXsmYzBSOee+CdEZuPnoWlcWo6fhGk6bayOpIXP+PjEO44pqOyQ593Ir8F8vEetrHan0+nCKJBWYrwhX8vmJEX5D1BmauMsTihRK3vL4RpwnaWsPl3LLtTmiBFCfXGq4G50c1ZPMKSQjjmAdnO/kRYiDi5bGrf/zIGeUBxVP5X6yGjrJN0K6rvy/2YxoIYJo4xuujmN/Zm4WeFpHQPCDeMFyNtxR3Ig2xd8rycFxQduRdjxuDvHtvqq0q6JicP2TdQHpE5zWQXPUGjhBb9O+MKVh0jr7q8Gd6Yf7IKlnm1Z4GSiz/JqRzzS7kRameOsXjwjFC48FVVqez2T9yXdZx/7xRaFWB/np9IbLf/06JxmnZEuFpUzlxQqa2jLvbqI7mMlVUdZTVJs+euPfeAPa7L5no6lRHGOE1a+7vSFcPAxRc2LK49xVhm5oC08sHHYUfESjtEQ1bgFfoUVFc70ZHDu+zZ5FPIHvpo0kIH2ni5ojVP9e7OSlZhWFSg6y1xIOV8Xwtc38iT+GnLXNe02an+Gd43q0i1qVBDoohTABpcqRTb5Fe9Q3BbTjdQwYNy/102HutWtupLUTsGkwntEz6N5xm2wnq99I9YeKuaDSWBfkEAEmsB12KpNe8rg3pt0TEJBeFBOoyUQ9ORfpeQiMHmAf1Szxc5s9xno4SfAVgJ06V6i/8Gd7LVCd8R9uywPFf36W1HiiEReu6eYy8Z8TvLAKW6ZqirGASJ3FAR
 gBFnQsZ6
 leamsL/kVSxUPKNVN7ab4tQZ33sgidbhWPRpOxd8o/bP5/8YX0Nn90Km70rnuD7qxtVO0t6nhhwt6KTqSgYQ5ufcuxXvR3njrj0IiMUu4WlyY/y03dlW760c/vIqhZAkP6KYj7Bap160oL4EIcEYbo6dSbsra+QxTt57TgFGkx8zU/aAcFlLfz+2gcMdA4e5kEEKqFiwFQEG06Stj9Pn4C1NeotvVRHvTjBxxz+aNOqRq2lIR2zcQCKwd0eQsxGaVccapAkL0E7Uq93GqkdF05h5N2lOV8upE2YMyX+Ub1ikWeptN5qdQBNu6FLZ0Y+LV0jQxruy1lHa5R6cCoR6MtACmiqL48ZbCHy1KAfbs4SCoXKEDm0aOAv7N0TBJzrAkCIiyaEfUuVftdtDvPLQGvqfUxzuGjSYgr1FV+uYw9v1OiyoX1RlhxxidCaA4B7HKuQzcJB9GXKp1P8U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Cris Jacob Maamor <crisjacobmaamor@gmail.com>
---
 kernel/liveupdate/luo_session.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index a3327a28fc1f..0244c071936d 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -501,7 +501,18 @@ int __init luo_session_setup_incoming(void *fdt_in)
 	}
 
 	header_ser_pa = get_unaligned((u64 *)ptr);
+	if (!kho_is_preserved(header_ser_pa, LUO_SESSION_PGCNT)) {
+		pr_err("Session header is not KHO preserved: %#llx\n",
+		       (unsigned long long)header_ser_pa);
+		return -EINVAL;
+	}
+
 	header_ser = phys_to_virt(header_ser_pa);
+	if (header_ser->count > LUO_SESSION_MAX) {
+		pr_err("Invalid session count: %llu\n",
+		       (unsigned long long)header_ser->count);
+		return -EINVAL;
+	}
 
 	luo_session_global.incoming.header_ser = header_ser;
 	luo_session_global.incoming.ser = (void *)(header_ser + 1);
@@ -515,6 +526,7 @@ int luo_session_deserialize(void)
 	struct luo_session_header *sh = &luo_session_global.incoming;
 	static bool is_deserialized;
 	static int err;
+	u64 count;
 
 	/* If has been deserialized, always return the same error code */
 	if (is_deserialized)
@@ -524,6 +536,13 @@ int luo_session_deserialize(void)
 	if (!sh->active)
 		return 0;
 
+	count = sh->header_ser->count;
+	if (count > LUO_SESSION_MAX) {
+		pr_err("Invalid session count: %llu\n",
+		       (unsigned long long)count);
+		return -EINVAL;
+	}
+
 	/*
 	 * Note on error handling:
 	 *
@@ -539,7 +558,7 @@ int luo_session_deserialize(void)
 	 * userspace to detect the failure and trigger a reboot, which will
 	 * reliably reset devices and reclaim memory.
 	 */
-	for (int i = 0; i < sh->header_ser->count; i++) {
+	for (u64 i = 0; i < count; i++) {
 		struct luo_session *session;
 
 		session = luo_session_alloc(sh->ser[i].name);
@@ -606,4 +625,3 @@ int luo_session_serialize(void)
 
 	return err;
 }
-
-- 
2.53.0


