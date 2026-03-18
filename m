Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17CAF103E18D
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 14:17:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A2C16B0213; Wed, 18 Mar 2026 10:17:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 054746B0248; Wed, 18 Mar 2026 10:17:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5D986B0249; Wed, 18 Mar 2026 10:17:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BCC9E6B0213
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:17:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8BCBABAEDB
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:17:02 +0000 (UTC)
X-FDA: 84559385484.27.6A5E725
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id AAC75180006
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:17:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=V9m4jjjv;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773843420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ubd4lYK9V1coPSt+9iFoac0BiHxALbtZJdQokTSw3pM=;
	b=DXvDShvTVpS6nCc9/c4rnZ6Kwe1dvFtnPEjuiC6cnJ443Oj837TM7KP3sAjfSod/bquwWD
	3o+BAknwc4HeFVlsMhVBlKIWP78HyXvTJT/rfQBgFgNfNQfTJJrH/+mOUtoSuBn1tXMcVb
	QUorbTGpWDz2HAJY4KoC9ScIOAhcC0g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773843420; a=rsa-sha256;
	cv=none;
	b=AtmxqZY6oE8VqQ5+/PloadZFeT33GstLcKWPqDKbvSwIKfsRfQBTN0ZJYBNARG/VzuqPXj
	aQ3MjRnJtu7UstJmr2xLT1+zJijPpQH5j2u4tnmL6y/Docp+Xwd0SZIg9zQi/AOHEg2dlY
	Hp61R4+HJU+n1hYcTMbxkKQxUcWQABA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=V9m4jjjv;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-64c9cabfe5dso1302645d50.0
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1773843420; x=1774448220; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ubd4lYK9V1coPSt+9iFoac0BiHxALbtZJdQokTSw3pM=;
        b=V9m4jjjv9OeyDsmrSNCDsRzN58xmm8AsVAqgn42Trd+BElPHHDJsGaTuO6TrO1GFtD
         +QlgWcdT2HIzvi5hzGdirIggaijKOBt1Q+iiLw/wLwcT8KC32PNnhAi5rDEkE3uhMP0c
         gGt/MCQqOGeK/ixst4evmgMGCGjNqss5lG96x8/N2q8v/BSds2tvORZ/joozbM91lfLr
         gHZugTc0hmEqxrQR7ICzMX5ky66MgC8Oc0ivW4Mo1uSfmm48SZ05AmFfN+ubsJY+AH5y
         8yXo61Qvz4iphV5A+ORiRAB+AcHZ4SLFatJYShuq4xX13qNiUewwH9JHR3Abs7Wy611g
         bk8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773843420; x=1774448220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ubd4lYK9V1coPSt+9iFoac0BiHxALbtZJdQokTSw3pM=;
        b=hM1XVFOGu72D/ZMwfE5X97Q4iLx2WBksO8CkBBRcpw5/XlGPfWogNov8bvyTgQnoSx
         bHCXGxDTACgr/rpHEEhfZaPi8FPnVHDvslHETfREHOqhf2b9HbFRZwoKHK+/DXTg+QZ7
         K/h5omKGZmduD1MQ2jZXaXhDFImJ4zaIvAhsPzKjA4qIPBW5Y4r6Usdz7sV7KZvbpJNc
         wB5NsZ+PfGS4K/Z/tNfAOEO1bVqOG9sZWu8EbhD+8IUHQ1uC7n0wZn8fSKAMS3Gv855r
         0PawSk4+x+/8sAhCGIVCtu75TOzNMh7taZnj1UtEYFjnKur8p4dfMfi/Pcz0k3hkxuMA
         5Beg==
X-Forwarded-Encrypted: i=1; AJvYcCWjH++Lv3FUPwAbJ0WmGWNGd1ch6Iq7T1k1/EMCCo7fkefWuUXd4wXGbsarnsI7yrOrG6/LTlQ26g==@kvack.org
X-Gm-Message-State: AOJu0YxgWWQMZ9+e/Za02R9etouezn627UUQKBlt39AJwrDQKpb0BkUV
	CQ1AjbyMQ5A1psbW3+xM0k+rTT1vodd+UaKG5ioQIZR5MNWeNOjUHrz4MkhEoC9hN48=
X-Gm-Gg: ATEYQzxTCi62rr6cS8vKH1yVkIPAi4JC3Mwr0yUnCywapxy2LGx+QHQyhBKtynbT+Md
	5K+ySiCivfa2BfsQ8zumOBRJ0zLpZplLmLnRPQmelkdn2Ty2vM8tWQVS7JkOpehZDdwMq6f1xlV
	Kc3ieNeisdb0SKPSkq6jyuW0faa4Bfreno+kq8Cd7opImp4GuDT9u7WK9a+AgUsHoG2WIfXpXmJ
	OKOIuXaZflR4hkGW7e10e6Loz5T0i45zZ88z1l9+ClhDU99C17ffILFAezIjlq9Pqvda8W1+Rzu
	aKGdX12gC8uZjpEWfno3BqVpumDgts/s16NJywTQt5N7UoppHaLR95ZCAifcXloKNzhGjbqbhEh
	soPwVmw1wtPU7nx7j1DJpeua2O48p2H9PIoD3g17xf3hXeC8etofJMoAWb1Uo2adWA3QZVFfxmk
	BJFWjQgd03pEw089zJkhLCgmj0/iHSvokAPKmMPUy+9oru3bmBz+jbj/qpCIs4OtZhf8Wtyxcva
	orY1+ow87lo8QStV1rcptGvUBQFIBEb45I=
X-Received: by 2002:a53:bd0b:0:b0:649:3875:9200 with SMTP id 956f58d0204a3-64e912ecefamr2553595d50.1.1773843419489;
        Wed, 18 Mar 2026 07:16:59 -0700 (PDT)
Received: from soleen.c.googlers.com.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64e91be0e91sm1672028d50.15.2026.03.18.07.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 07:16:58 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org
Subject: [PATCH v2 3/8] liveupdate: Remove file handler module refcounting
Date: Wed, 18 Mar 2026 10:16:41 -0400
Message-ID: <20260318141637.1870220-13-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
In-Reply-To: <20260318141637.1870220-10-pasha.tatashin@soleen.com>
References: <20260318141637.1870220-10-pasha.tatashin@soleen.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3314; i=pasha.tatashin@soleen.com;
 h=from:subject; bh=Lffv2DnyZxO5nuM/8hkjo+xgENhHOwSyq1ggm1aLDpg=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBpurPKh1r+mZq+VPFRX+zQHHctHNNA9pcYeCPjk
 6lF1jfleF2JAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCabqzygAKCRC7dyhM23N6
 3lTYEACVTFybupdvgSPfd2fCzSR3N2UrbQXZNHejUkbPthks8joN8TV/SNAo22lQP0aZtDZ4m1t
 O66zZScB9l1jmnV14XgYXm2Vx/oAhvCSKfuB7ilBXB5bc2hS+uwv/uUsfWYVAeiRsi853EpRU+7
 3Ey8yY9NDR9WGk32UF2cDiysYUv+fcNvEi9P+8szI1T/l2IU+kb3l+Jo6Tdm+fxvKEJI0N5QVP4
 6RM9u0WgPcVbMV2FvsUr5GxKM/UWYqBRwO0eEt/0VQtXFNLPj3t+nWwi8mI4Z2LRsuF5pM6H4Ce
 sdS/DygdtovOXW1QHA1K/1ULI+TN1VDBA1XL8AHZFdEmvIByLxYRAkqKGzcN7m3DMemmPn5ryur
 Kty3b35GCRVri/n9X8zwZd73XmAW6qCFay89lFkZ97O17OiFXr5IDtJS8rZNVxE3TlBF41BtgBu
 w3HgMpreZVak9Q1OcDQzFqYPaxa9Dx2Yf+sL7ulD6wcDtQhVnu3wI8PbaLJDE8inLs4jLs1iGAK
 mf0AGRrHmwEIi6ytkimFdbZgC8v+GKMdzcqQ5MCmFbOWrcAeXOel3d0LfxkmsH9Ef1UK86Se0rA
 Uc3LFyCq4vMH7SbFdGYq5VJHI9vDXz8Jf019zHgQOGh/6h3bs8ASlTHB91fa7XtPuhx411vJfy/ 77L6oexIIBV/uyA==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp; fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4j49fwsadzfem4dx458n7jxtytmrgts8
X-Rspamd-Queue-Id: AAC75180006
X-Rspamd-Server: rspam03
X-HE-Tag: 1773843420-831418
X-HE-Meta: U2FsdGVkX18bgq12TVgzDU06gt35p/Uwvk6I4dJK1VCCYM52IFDeMn7JrDEoBl9L3czJ2MwEgpFTloOEX7yfeF05ERgZVkepcl8/YcLXm8Syhm5Q5XqH30Tf6r31QSUo0vnDt7scMw7Pw9fOPJxpS4uFLa2kytbYtrxgDdU4wbVfk1pPRWDIS/pDhSgG9Muv/HuiTA61oW9U62JBP7IDAptNAJ8ue6rJNCG9nYxfDR+ktDWJPlZ/EkJwnreLraaWEvYfV7S9xH2/yMVs11VkWlGZc4KcEhgeAdnhewVRfWO/yd/6LMxPfThylypGodjRkMIJTq2JOPR98Qnr3X41CKFivGNr0HR8MDxXpundC/Yqi3LnTGVrwc3T4hHj44To7lVOlnU27CZeNDYA9sLMS1IKXuUxSBL/CAV49OW8iBSxEgEqAiiVDTT8QPvRAgRZMNgHBreCIngTbfJqJm2RXhHZVvHyKHraR6vpc4Jp4O/LrMMw3CaMbGJL3eAOomIKz/fal2eV0E/L76SYUl1Sbfr3O13mP/b86Oc4hTF7wriL2TrOCCeVALOuaM01EjeUc/xMaDbMyKS4b7VzcFTgMFZsAYpVIq+EHVrbCRmuU33QDPhOu3MwOjeEGVBTKhQe7vUjbecP5pzL3P+d2wmOdAepRF7GztYNDpm3AoKQlxMT07NZm/NARapXlnCVoA0wcX/qhygvI8K9AO7ReA0upbOxGYIBVFwrDaDOQo6mT95txIzp3rt4K8ftd97bH/3Vhj1C8U1bh3vr77dUNZWDqz/BRM/Va/q3JHxRivy8I7YcKKT+0kF+NjPhqQnx+++p/18D/TTb1Ff/WGgMiwUWifxtA3NveBa3KvdwTcNSF97OoIcAKgRtw2jjbTtf51WHPsU5m9NYy2N+n2oJ5ZjM5Y8yhL+BueYJYcDF+OODCuYuU11A4SeR1i+QJ/JaI2OW3X6r56RS9TepyBKEww2
 W3evVr0H
 Rt8+B02FcB/xUKG/XW0QvXIOKjHVSJmA8KDRaLsOcpWPy1eLgyVLkTQblMAfwt2aAbSXNc0S194p1yx9ppGnW6EfCHJm2ly8Hxg+FN0fN3s6gNzrjwKPavux239cGjua+DUIUysE5AvKjvJ4RzJU/VD3JW+eGY3sTVai4LcTFKz0Q5SVdLVs7PsomZ+7EhEzcgw+lon+3B5ihYpfxK4wtQk6fdVdeDBjkgOX/5Tyl/ELqyHm8DVdG10iuwNIaRAC5Qz1OBsVrzyJ5/Yddc7VKSc+nw6wQChxdS4IlBcL6f9P5l79nSI7HiX2hu1MyH4J1g+hGlzjagAF+45os9jmSylzhCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

File handlers do not need to pin modules indefinitely or during active
live update sessions. The VFS 'struct file' pins the file handler's module
via f_op->owner during active sessions, making dynamic reference counting
unnecessary for handlers.

When a file is preserved, the live update core obtains a 'struct file'
via fdget(). As long as the file is kept open within the live update
session, the module is pinned by the VFS and cannot be unloaded.

Similarly, during deserialization, file handlers are matched based on
the compatible string. Because the handler list is protected by
luo_file_handler_lock, there is no race that requires dynamic
module refcounting.

Removing these module references ensures that modules implementing file
handlers can be unloaded when no longer providing active files.

Suggested-by: David Matlack <dmatlack@google.com>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_file.c | 28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 96fdd5790dcc..b124fd747841 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -836,7 +836,6 @@ void luo_file_set_destroy(struct luo_file_set *file_set)
 int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
 {
 	struct liveupdate_file_handler *fh_iter;
-	int err;
 
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
@@ -861,17 +860,11 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
 			if (!strcmp(fh_iter->compatible, fh->compatible)) {
 				pr_err("File handler registration failed: Compatible string '%s' already registered.\n",
 				       fh->compatible);
-				err = -EEXIST;
-				goto err_resume;
+				luo_session_resume();
+				return -EEXIST;
 			}
 		}
 
-		/* Pin the module implementing the handler */
-		if (!try_module_get(fh->ops->owner)) {
-			err = -EAGAIN;
-			goto err_resume;
-		}
-
 		INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, flb_list));
 		init_rwsem(&ACCESS_PRIVATE(fh, flb_lock));
 		INIT_LIST_HEAD(&ACCESS_PRIVATE(fh, list));
@@ -882,10 +875,6 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
 	liveupdate_test_register(fh);
 
 	return 0;
-
-err_resume:
-	luo_session_resume();
-	return err;
 }
 
 /**
@@ -907,8 +896,6 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
  */
 int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 {
-	int err = -EBUSY;
-
 	if (!liveupdate_enabled())
 		return -EOPNOTSUPP;
 
@@ -918,19 +905,18 @@ int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 		goto err_register;
 
 	scoped_guard(rwsem_write, &luo_file_handler_lock) {
-		if (!list_empty(&ACCESS_PRIVATE(fh, flb_list)))
-			goto err_resume;
+		if (!list_empty(&ACCESS_PRIVATE(fh, flb_list))) {
+			luo_session_resume();
+			goto err_register;
+		}
 
 		list_del(&ACCESS_PRIVATE(fh, list));
 	}
-	module_put(fh->ops->owner);
 	luo_session_resume();
 
 	return 0;
 
-err_resume:
-	luo_session_resume();
 err_register:
 	liveupdate_test_register(fh);
-	return err;
+	return -EBUSY;
 }
-- 
2.53.0.851.ga537e3e6e9-goog


