Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 802FCFF8873
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 21:22:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A59C86B0092; Wed, 29 Apr 2026 17:22:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A30DC6B0093; Wed, 29 Apr 2026 17:22:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E7C56B0095; Wed, 29 Apr 2026 17:22:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D8336B0092
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:22:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 16745C076D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:22:30 +0000 (UTC)
X-FDA: 84712867260.12.049E65A
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1CF3D4000C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:22:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nG84Eza9;
	spf=pass (imf01.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777497748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pxqYhYsj7HU7oN1/TsDhDPzLzeP41V18doSZqNDu2iE=;
	b=R9J43d7ZkAQXosxuBm/cCh7urIu7sFsUELw3i4+XXUYQowMg9gs4/2awPEZAYzvBNOBtMd
	0qYD/VUB//ROcsajnxIpScZGxOERZt+xSKC3LF1NkMv4BAI/bNbdUelqhbPa2t4B0YiT2r
	uLOPSNZ1AGzmgg0OCqNsmFZVMFCiOaU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nG84Eza9;
	spf=pass (imf01.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777497748; a=rsa-sha256;
	cv=none;
	b=QMejKXEJ2NnMlWQy8Rq/QCJIX+laUCbI0QiLhUBHhaxhLytGKJUPZ29W3zTtaSbVMHxsLu
	IyU5az8Rt2PTFxUKC0OboIFUKIXLIR9bfMZC/xhhG1dUK9v9Qa/kgHRMDUjxGfvHp1B3wf
	k5pRfJ3QrmZBjRWxzsES4nuIK/BBdOk=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4891e5b9c1fso2028005e9.2
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777497747; x=1778102547; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pxqYhYsj7HU7oN1/TsDhDPzLzeP41V18doSZqNDu2iE=;
        b=nG84Eza9VA7wfgO1swgoJ/Bk6OLOU0yVM7G6l1TNdLR+0ma7g3ZiC1jfr/ekUcAIld
         tkutX7mdgaAV6Vj1donZ3oXOwdjlANgkK4L8R9yKKAHIRXWXfEBY4RcWT9X6Epoodj5H
         UgviXyUjn1DSyEaJqppo+eqTcmyenYtLzCvdcpXwbndVDAOn51c1uv2W0AuSWkYaBgbY
         4gFJRtNLvyKaZSFPXZSZ8bwA8E6kWrwNbWQjY8p3u5y73JZke3VErfPk2G7sK2LFvQN3
         gdaNH2hq0Tgl+3986+6nvjV9+RWLJmLxROTI5wgfz8YEpO3iAiheiO9kzQJnybYHPg59
         U/Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777497747; x=1778102547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pxqYhYsj7HU7oN1/TsDhDPzLzeP41V18doSZqNDu2iE=;
        b=Gye3ICGHs3M/y0Sa7HUT8hurEZaf+AU+Ecwdt4gxHisp/BadXhFsEIb9UuHcj95tKK
         r5nwBqYenTUV2GRao3C8couRJy3FHEdFCkm8wRfFVlxXMGqZb0/RwNlQI+5M9fud6nVV
         qqSPwMNF2hsYuda3mdWzJqd3nG/RuomqIxqfXgBSQJCPOVRfOt9ynaQJROyPZ+JXU/Ll
         52lWGujcJ2LiLn2o71NK0I+Mz59ZZqbNi+CWMIOaQmbFY+rvELbTwPoAaC5HWDTzMhJJ
         mYwefA+g7uNOZm5/yVxoM+vGvNlrjLC8XsEw1Fam6FQFf6MQU80Xvb/Y0C4fSKB2/khU
         lpIA==
X-Gm-Message-State: AOJu0YwFjIIfOEA+6oyepQdncFspio2pwGIpW7eoyItUVSfOsHJ3KINQ
	37x/XkV/xgtIeSOgbMogYj7d1NUNRRHkL84S97i72p8PdKoaMXJ6wdjW
X-Gm-Gg: AeBDietkuXk3UwkIoIdRF71vUtad/GtAKIGqDNckYohJwAqx1BPWqmYOdmFPzuhqgKh
	X3aq0sda8ixJM7yt8CIdKKsI5Q5fRb2ghCRVFPexMRSImRAa1aeeIcmQ8XVChUVbp06HURNAyTZ
	q5hQZHIIB7yqguQ5NRUSpf5oALmXRSeapkMXeqJaLcMtgOcQbJ8fH31c7lmG0/Bh/efImJKua88
	q99b+/Vwu6OYFPuxP6R6qZxpr+4yRXtu+x11tBiDLXt78KM7n/o+ZvbzDTCbTMI1ntKUScNszYV
	hBImOpMFSXHL44plyP1PuO7jhWmaNVdqcc5Vfx2i2rvJkVY/vaftyK0SLszMXUzixpYY9JKxugE
	sDdIM4iUCVs2V1f23qjkUgjNF8JroeGpI2BwDs56qkw9dH/gOGzeQtQcLqpb3Pu38wY5It6eBpX
	MHbyWrKnGyg+sXCvfHfXpGbSJL7+0i80thouSN7X8=
X-Received: by 2002:a05:600c:1f8e:b0:488:a824:fe04 with SMTP id 5b1f17b1804b1-48a8447f466mr3197815e9.26.1777497746519;
        Wed, 29 Apr 2026 14:22:26 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:8fc7:44bf:8aca:ebae])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48a822d4b57sm45356905e9.15.2026.04.29.14.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 14:22:26 -0700 (PDT)
From: luca.boccassi@gmail.com
To: kexec@lists.infradead.org
Cc: linux-mm@kvack.org,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	linux-kernel@vger.kernel.org,
	Luca Boccassi <luca.boccassi@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v11 1/4] liveupdate: reject LIVEUPDATE_IOCTL_CREATE_SESSION with invalid name length
Date: Wed, 29 Apr 2026 22:21:14 +0100
Message-ID: <20260429212221.814107-2-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260429212221.814107-1-luca.boccassi@gmail.com>
References: <20260429212221.814107-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1CF3D4000C
X-Stat-Signature: ejjhemeb9mcjs8hn79a888sd4gf8hnmj
X-HE-Tag: 1777497747-797511
X-HE-Meta: U2FsdGVkX18ySXnXBqZUVf6o1DG9yWNsa9Pc2Lnlng+XHI3+3iLTiczgCnirCbORPvk2rTtfA9izYTzWAtfx473safpNA4wa4SGUiYf87ZlFASBMg1cgJrWFAUbu3i9iz4kMfA22kwPOzzsCaYf9H3qTIUeLsgQ5pEfm/0l+r9183B+hYl5dvlrPyENIDRFSllvoj3mfGVtUX0wO/lEpBRpiBC8ybpB+A60tzqew18a34qUaNlOiyDpFVuFN20XJwOYpVwrvn7npHhRqnuM2eLfRqbAvydHLqcvYlo18y7MK1gvyvT+DcPkjPNpDvxQtm06XAaN0j7jhGpjR80agMDGhKQhogeMyUlQU43iBdGh2APDD+1YqZUYZ4APFM0XRipcTNOjOrlK7RxTOu55MPf3/IhbT8hoZpuYppOfGmMuYWUJq3Vt/t1+OFwX1eXH8XNM+/mEuLwFVU6zVcEb/aPPi858XHmJ8Qu6ND6vc9ZEym8VLVc5TuHrpXjOheDY38PVKTssqhbxo75q/1DbRC39c3DLbDhJUgalQDoLXzMu7awiZOzmhJMRlK+Ql23BCUzRyKF2MZ5GooqmncHplOSCcaAcIq332la9XtkgcljxMA76MFv2dx4+bcwinvvULuN3zOn+dNqdANIOpsTUmEEUdN7OwQy7MWywCWve/4Loc7u+nDwOxGoVA0ZGoRRoKjrf8YMBqq8ulRlfgEp5DSmlJ75zuYmyyFnAt3syVY61v7TTHfUZVuDK4kOiLMN26yzCVENPK53+kasMVcmDY8KE4lXqcxEC6j5/iQl1KlPx9vq2NP5FNL00xrJ35Lz7op9yeyzejtZucAw7BfhOZATOXb/OXMUZcPKA9QNb9EqHxFzAUyFfzOcOb8FKBkHcUVmLSgJcJyiJl9RwMWFQPvhMovZ/dFvBBS2FJIka+RDc4s3SzSvuxDPMJmC63LqXyzS7b6gDZMXkziA9kyMD
 b3r3GVhN
 wnrt+pYPbS9cXH3LzrOumSmyr+G5/p8W5yW4tCucnIV29X1Ow4dsjzpbUoViiXLU0+ciSdCi1Hp5YB4891yqjQjiZyJ95wYxBiXFdPj8mrA4ElJji9M6veP0MrbEnLbCCLuRxz6HOTyFDQT+bUOh2d+4w0FVsAudiglUwo/VJFhhqzl9Yq+WSf+QnyF30gKIzCIDrc+ogEqNI2Zu0HDrIM/fu3j+wru0IyNxqB9/XthpUFzIzh2PCd8ucEpk2yUnMlJeH8gt7z68Ce3yMt75nWQ9YJ7fLHIjAsQbBpzWSLFmPP3VOV1cXoYfNm/5piXPTRECbbA6+Jq7pHcLkc4U2Eazd0LfN0nJgtXuheUYNCkSOY40rtKlQ0Wgy87a/4GuXJRnDyR6Se5gU4KctOuYTHCjg3PJBLliOfg+efYMN5h3ab1qOVr9h6KYRUPpKmAk9s6V/J4GBGVAp+YFSnraiarmgDERV0+bXvMN0BJmmoaIhfFfPp9UZBUgcwBBGpEE5046L4FkytbVNYL31u5POSLwLwc7+LzKMbf0FbJNC9083qyglE2c8s1t3x0DZzuf8EpEKAG8UAsJov64r4m/MpT5SzOefcfMuEZlrPy5yZfcDI7rdY22UZhuXZNiWMEGUYdMGSlKsmabUezcBkjvNm7M4wt+PH2ERLjGVmrXDS3hUng69GJRoMUX/V8QPa/4yClOM23EKUWfjYET03iDyfeGMS9Wao3XsImF/NDUwG9/un40=
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
Cc: stable@vger.kernel.org

Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
---
 kernel/liveupdate/luo_session.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index a3327a28fc1f..24b4f381d3c8 100644
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


