Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22427F588DE
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 14:17:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 889816B0088; Mon, 20 Apr 2026 10:17:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 861FF6B0089; Mon, 20 Apr 2026 10:17:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74F726B008A; Mon, 20 Apr 2026 10:17:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5EBE56B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 10:17:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 114B71B8C8E
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:17:50 +0000 (UTC)
X-FDA: 84679137900.20.E106C06
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf13.hostedemail.com (Postfix) with ESMTP id 33C542000F
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:17:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AYTFVuh4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776694668; a=rsa-sha256;
	cv=none;
	b=En9JG9J4N5owLYoGjKxaUHJmvJDcWXopu0OUvIxTWxtLB/g8wMYITKjnMHYAEaU5MJb/DG
	ROETBm20i/ZidJEnSFXVunDvVF5gz6/LxrWd4+cZgntBXwh+zAjYiXoOzXyHAlyDTOBhfl
	UCRkcHny+0lnHEg4R1mzT4lplK9EE1A=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AYTFVuh4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776694668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qewxjB4gqze9ueAsfaggwvN0d9awd7MKHEueXVS3eI8=;
	b=8niPa6MpskJ2M55Ov3L052VnkSDrdmIdH3sGnpP/i9g24peF6UXypr8eWERa7ebdW5sPRk
	r4yZUtbls9/OEb09LB51UHFfWFBzSgsHT7uFj82DkQRIOVN6ViqoOOZR+3Y4ubPcEkgsnz
	Aa0urYvrTpr4x1JocdoNrRZFPomMkaQ=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-43cfd1f9fd1so1892524f8f.3
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 07:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776694666; x=1777299466; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qewxjB4gqze9ueAsfaggwvN0d9awd7MKHEueXVS3eI8=;
        b=AYTFVuh4rZQbcSrUvip0EWWvF+IOLa/qliIwDH53cu4L0lTOu0m5J6pH5IiJRPI61g
         XHYFFPQfcTYeRZKWTYrqg3Vccc+XXLmPPU2E5DSoIibTjvFa7/00admb1LTv0J6fKscG
         XX2T/OYGuJLdA65R8BbySrWt877HbfDoY7PXDGog5XMdP16QyqMkkASbkPh6qZF6cKa7
         8po8OPoWDTCiKDaXaMsp443+RoJnq/QJoJHjEcKm0aUFfKyQ4IULAxDatkWSKqXojGOG
         GqOOBsWg15sSnkQ5Fjs1nNJtY5mifPwZ4Yelf3+S+4NJmO8dB5scldCSmWEarlWiTSLT
         SAFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776694666; x=1777299466;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qewxjB4gqze9ueAsfaggwvN0d9awd7MKHEueXVS3eI8=;
        b=KZ9gN3Jlys8QLjAzgYS4MuaLXoEUxEnky0jsOcp3y20kCtAAjF/va5TzoeQ+oreWJT
         NV4ij7tW+8ZXNW7d7/u3M7AexDZBtXXOvjE672VedGgDucNoi213zJppXTheBML8igu8
         Z4xLN0rnHp08PLxez5O2agv/q1773gVHwFfcJqlaLLFj4TG+ffdr9JI+Vb6oHeSVlIcX
         ogK7jTZVR3J+pw7X+FiGQHnJ1bAWIuyfPP9tfoEvgWcN7PpupFlvt65zF50z9MKe7zZb
         PGtso0gVn1JE2eFPyHKex5WfoQxPBz++YnkcQOA6jO+jDaT7bAGN/wxBfmzsTeot+mgT
         2GvA==
X-Gm-Message-State: AOJu0YwICIJwxcnoEG1dbtyZFtQjKmSNKEGyM7+TOUgcux9Dw029Vv5q
	Gk0DRyuNoux92xRDVETnNWFhjKtkBYLNaC8wdh/SFJ34VwErAVjRjPul
X-Gm-Gg: AeBDieslvJkcZEvKsNn5eIqIlZXBPNdYhMpGNegeGI4sC2mvMXkEXqrHSrXuPPmm977
	N5Jr5JGqT178aHL6HESBWHixX3ySk1OQiUdrz5Mfcd8+pqQsWtMizliBqWx7TJ09aj1T7aumAPS
	jyZJKlJR0MfzH0kMx3RCv/4SR9S7PCy1ugrZgl16BdM8d7zVD24on2vcwROc1h223/CcHpGf6QP
	8/GPAQpUvvYl9SGCh9RFzYkwUuCwK8B+INLyblLFQgTvrGySPQEZgkmuPu1oF9J8zlZhzU9HHLC
	GL8ct+8LJS2hAAKwhFeRQjBXNK7biqP5EQXqtd58pqO7e4Xv60K0cfaI0R6BKZDCQpHLQMF8PPf
	o55UfqZw5vsp3FKVS1vShxJEptJYBhpAEdefbUpkbKriTUxJg+aqL4HeuR4uYE8U/HLne0/uUCO
	5xnSbBYS7QoJynjjwzFzS+GMAkfS91/6pe4qdcPXspAFYnpeBMMQ==
X-Received: by 2002:a05:600c:6296:b0:488:c40b:c8a4 with SMTP id 5b1f17b1804b1-488fb73d764mr194293145e9.1.1776694666131;
        Mon, 20 Apr 2026 07:17:46 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:355d:3be4:308b:c943])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-488fc1c0354sm269742375e9.11.2026.04.20.07.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 07:17:45 -0700 (PDT)
From: luca.boccassi@gmail.com
To: kexec@lists.infradead.org
Cc: linux-mm@kvack.org,
	graf@amazon.com,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	brauner@kernel.org,
	linux-kernel@vger.kernel.org,
	Luca Boccassi <luca.boccassi@gmail.com>
Subject: [PATCH v9 1/6] liveupdate: reject LIVEUPDATE_IOCTL_CREATE_SESSION with invalid name length
Date: Mon, 20 Apr 2026 15:15:09 +0100
Message-ID: <20260420141741.2688371-2-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260420141741.2688371-1-luca.boccassi@gmail.com>
References: <20260420141741.2688371-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 33C542000F
X-Rspamd-Server: rspam12
X-Stat-Signature: z85fwdq5sqhpgx93hpqismh3jrstuxeb
X-Rspam-User: 
X-HE-Tag: 1776694667-489101
X-HE-Meta: U2FsdGVkX1+QH++1tOGTwH0BwA8hUOS9ar/gqq25gOGDlEsJtgNsMIt8qX/3KpqLcvH1zOlmbG7hLA+ZJso6BNb1dDaoI84OWsLZbrd0u2UMDrQ5TUu6UgsLF0uSo3blYWKrv3w5fevmYokxDftQVmBhygVx1us3be+lJ7t4yNK+HAhFbbHiM0T5zgfXRTZB46AN6ci8hxJSXLwR62Cnz0vH7rr78CX2ZYlbwNaS2nOkZKEcjJtm104/RPEn/XZrBrNJLZfflSJhTGJChM9pnMBmlP++Y/oj1OnL/peAxx/jZEQMCi3Boh/5eEEdeMD9V8MuQ5CaY5QXam97glCiHJP4TkjIgL/hglEBH5jDCb+jKhoLUKe/m76S5VHYZUrzUSzAHNv9i7AxOZ5vMhN0QRy8oJALa414c72cAgZwb4EOfhOHWE8KRAp2iwuiUVDSfO/cEiV1Qu4lHxUUx7PMc03bLiCYf5W6XmICdfHvk+HPiE16sNqrBL1sCZwLDw9PWHdcprDYGxrnhwrBdQinHNap0a/0CiEnGex2gbTDQ9ZRFRjoYJZ2Db87WzMKL1oQ3ovvC7MidxyMsyrXiZDeM7mYNxSbl5PPbTZo+GUy6UDGtmXAmBWBXgvCkuj25kVJ5AJF0IaNP5qAlg5Bw82hSIskZTL1MPBjriI4ypLmEvFhMCSovY2lEu+wT3yKnfOr6sWWqldJjzMZX6j72rFyaVOEidq6pXoKYEPWrMD9w+pFZqIIEAB0OdjSJWfK1zvlNQnfXfcH/IlxJPiqToI0IdkVqINxer39Rly+IlEp4p310Vj0jq4K0dbdy1/zs6tIB9qzIqti1VDPh9xmJW+s5grIrNJioUzvjfuayG5MQSf72QtS0+qSTWE5xRCq54Ibbn63qeBPWV4Dac0jDAxtFssTqdbHZ3Z26N9ZJpakaIENlC2PIAmrTccbUdzCLtf1pOo17d1NqtAkgTmKno8
 jJvjl4Du
 OFjVNBcAk8CdiNltoTd26c/pHxsK1v0XiwVy3iLrU9a0tHeC951RDj5IijHohEVGOPgQBi0f7wQtKIGM90s+jjNyGrlL8FZgwAaCYubYkzmsb0t8u8CLF4EUdbSnIHFGewS4ovhzhFPiiHGpuCzkBXEwyZx0S66nqV+abrbvAd8BpVWB+avdQpluk3Q/MrD5j0/pK8zCo8jitosbuZhtYb+mKsIB1UOkI2ir/0Rrtr/P7/tp2uZZKULElzD299WrnLdqPbKY5fOVdTUcCnzyBRQ30g0lIJyGvarvaAgCtrqqbumDvQlzIKK7kDjJwClLk6sCubzlzhiX38tY29tzq5Kt95VQADMtDQas7nnadh29q9zxx8YMrxHz0phDaWg7O/uBaasizZS64x+br7tI/LyaIx83X2QD59cmaabKBFQHSPNbNTV19sBB9zuVqFW7P7TtOxd2ghnsy9Qj3oay/3iCGjv9aZ2GQcDNzzrsBO7Ls81Nsn+iWMgD3VcnRG+D1aky67s09Zz1N8UYGB76hdR9boTE7cEEl6jd3N8T5qTgNFPZKAvfWMBz8g9nqjCEL9YNxmzQdkm09HeO8vOpIcEx4HZngH+7HJVuAXBzLE61NTfUFd25Mo7xdV7AbxGItgCbu4Uo/TZ8LNgfgdpiHTx+nPW6JjSu7rNURnyublMSmDi4y3pv/TexPq+Xse/RmLrloTmqxUARN0l5QIjTOSJUwKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luca Boccassi <luca.boccassi@gmail.com>

A session name must not be an empty string, and must not exceed the
maximum size define in the uapi header, including null termination.

Fixes: 0153094d03df ("liveupdate: luo_session: add sessions support")

Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_session.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 25ae704d7787..5e316a4c5d71 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -382,9 +382,13 @@ static int luo_session_getfile(struct luo_session *session, struct file **filep)
 
 int luo_session_create(const char *name, struct file **filep)
 {
+	size_t len = strnlen(name, LIVEUPDATE_SESSION_NAME_LENGTH);
 	struct luo_session *session;
 	int err;
 
+	if (len == 0 || len > LIVEUPDATE_SESSION_NAME_LENGTH - 1)
+		return -EINVAL;
+
 	session = luo_session_alloc(name);
 	if (IS_ERR(session))
 		return PTR_ERR(session);
-- 
2.47.3


