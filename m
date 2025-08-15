Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD10CCA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:40:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D0808E01E3; Fri, 15 Aug 2025 05:40:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A70D8E0002; Fri, 15 Aug 2025 05:40:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BC548E01E3; Fri, 15 Aug 2025 05:40:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A8A78E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:40:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EB9E71A0944
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:40:47 +0000 (UTC)
X-FDA: 83778497334.01.D4FBF6D
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf29.hostedemail.com (Postfix) with ESMTP id 32D0212000C
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:40:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bihslvdI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755250846; a=rsa-sha256;
	cv=none;
	b=7N77tOAb5UtSScxaYPtfklyVLwX1+95iAyVomoZ+pOmMhp12vvmGXq1lX7Z8/kIUQTpDVL
	f8IsUQRykdvVAJ5t0OxmwoisIoMT1zu4z2ePHdFHpkUFidyYBy0zw/pGhmb8Gc6NOCM4Vj
	DL7Z5ghRRVJ1+eW4Tsmt0/itO7tfHWQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bihslvdI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755250846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0EaYU3byF1ibThR0UBznWnxi/raQE1VP/oaQB9ZX8A0=;
	b=h3R+OWcIGt5BP99zEAZGT186xaXxzNWkhgnW3xh9hBCWNC+KgqcIW2vNLCJJ20YdGCQ1ro
	XjPF0YXjGCmaoWCiFEpZhmgelRCuQnt3861aT0EHxRGpKmqCrgfCCLoQs2cvefilo3iyQp
	JUGzVoE9sBfvZ6jti9HpWb4HuE6K3xc=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-76e2eb4a171so2517931b3a.3
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755250845; x=1755855645; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0EaYU3byF1ibThR0UBznWnxi/raQE1VP/oaQB9ZX8A0=;
        b=bihslvdI4/pduaEWTigQnx65d/O7AbuQQjep8X/o6Ve3espP72q6/aBnM0NVRRVuMm
         LTEWcvQSwskaOHeKmVqcgj1iNKqxDn3dQyADhDSn7Xv6s2vumBCPfUuVPH84mbxyyHd/
         TegQJVGhuxtUo3+w3Sk+Ci0TrBDIq257Dw/VhAdPhT0mUmFudokkv9ObuU69Td2QTAIl
         IZ6aY7kVduMUAQjuUuU5YHRP5JVJpPOy5Q63fTuv1W7k4KObb/xVESHA/yXgwASHyYuJ
         pbxQ9czwKG6kEb+qWTS6tDTVrZ9p8NTpTFy7lFH9uYYX20PqgEkzKcR4wTh4+4qCdPqs
         /Lyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755250845; x=1755855645;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0EaYU3byF1ibThR0UBznWnxi/raQE1VP/oaQB9ZX8A0=;
        b=em5duk37Biz29K202wUNiy4K+W5azvvmW6DMgbVaH9GZPt6RwTY/SpACMr+jW/ZHRI
         vmUHkAuQExFAy4yJB8KeLEJkCvgv/rGivGqkLgJDVNIAItJFrLwqFmfvUbNp4jiXRMUO
         asS33Om1zlzdKxoaBRL85Trmh0cO/fGfUw81o7twIfo3TIkOLN6twgD7e0J1dnPK48He
         +QT++oy6/H6ROgmCUB6ZAGr31vLVuplO3zMBVIF/2oxI/Ybg818hi3cRX7EVIVwjmwWO
         YKEVEE7y8/UHBcJ3s6Fp2qUPqOI+Td8d0GPb95JKacf59anf9HttiiBjGqAhF3IEhTEK
         B2/w==
X-Forwarded-Encrypted: i=1; AJvYcCWa3WCxgBIbTL+GvBiAsvjda3IW6aTu3DtI5/a0vFx4ew+16CZzyAdWfC0/UWOq8Wd1GHG/QUdzdw==@kvack.org
X-Gm-Message-State: AOJu0YwhcGPH09CsXDfGH8EiUSubIE8Rw5eQclauqX9wILv3T/2nGfTS
	7cPKlWfvuQCb68mDBKgGMFrySBUqeLLXCygXLCww2/8Gu2l6NcYq5vxS
X-Gm-Gg: ASbGncviiPOsve36e01DGum47qCFmXx5iw3PWCTTM+pwFHZXZH36lQwmDmmIi5w8+FN
	V6w9X0ZMaxb02ptoEho2Xmg0wb4lSoBHlh6he6BiK3OQW2sJbAaROMYARn9m6OzLXZuPbIrAMOg
	6Di9LUwUe9dxXZDtnrWykwcJeP+9rdo7vpkS1mbNTKrVgAXDjX8hRVeUvzZ8CkOHH298s4ZeT5l
	5rC8OJ8LWMS3DbcOcSYKVaZAVeVI+jiAqnbrzg4oMjY0LM6p4or5JtmiF5tUmuDs4jvj+QpclyN
	jqbgIPSj5n1/Vw8u2Ai1s+U1UDQmMSTlP0NAj7YxFq0dttwHy3ke1EJzhRI16UcrnQIOlT2HeM0
	nJz7d5cg9S/abNAoA
X-Google-Smtp-Source: AGHT+IEY6R3cStHuOBLGITafHPzeFrieZ36L/mlZDKfN6ZZxS9bt/cltVMPRkdogNSr7syQ3ssz5fg==
X-Received: by 2002:a05:6a00:3c94:b0:76b:e868:eedd with SMTP id d2e1a72fcca58-76e4481df98mr2161303b3a.24.1755250844960;
        Fri, 15 Aug 2025 02:40:44 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e4528c807sm767087b3a.41.2025.08.15.02.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 02:40:44 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: sj@kernel.org,
	honggyu.kim@sk.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: [PATCH] selftests/damon: change wrong json.dump usage to json.dumps
Date: Fri, 15 Aug 2025 18:40:29 +0900
Message-ID: <20250815094029.133063-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 32D0212000C
X-Stat-Signature: 9hdxuxuouafk9dt84ooo3bxrpwkzx5bm
X-HE-Tag: 1755250846-839893
X-HE-Meta: U2FsdGVkX19uafjq8UPaL9GNnTu+6sTHh+M1X+FtlA/4Vywps5PAnpd3TETfuOqeTvBbJrpDY2C+Gk4mh+fyBrbseK7NUAg8/eShv9w+XLXWnombDMHroHQAtMc/gduslOiUpqCbXzzR2Q8tDmfnkJ/DS9B1+Jm+RI4m2uo1LtzvwZhz0IOKqvOBIygOQs2Ig4+6pa5H1x/IoLEzd1KjV/wkx0wNXwbQLEhyhmHf/YjAR6qtM+XFQjAesN2k1WmzZohzQNO3pujlevm5WkbxMjhXocLaNMVXUh//QQDUzxw4wORhLBUMHakiYw6lCjM2+UQbryVUX/iX5kvCkZvDx9EKl5u9bYep8C6Dzrv+FILJzeYy+wdZ6qxjxbROTNTcv+8O5KwhTfZLubHNJ6MR73KFvyl6zfVo0YCWJ/YQm2wcoOEQKbePteZQ7ys9fPsiSEQf4BWzlNN2QJTPiNiKZHlmzG7QXc7aTT+O79RDeIn7puDTiPqOfA1XDvnInnyarHJOygmOifAT2v+VN8gdLvHlQ7vvhMtZJEgEx5MASZOzWxyVU2DzUYb+ZhaOMvlHNXWyopJm4pticmEaII8Kss3KlP41e57M7HqNgICl9jCyGcXdy2tlU7y+Lg2sQyLMzI/VCXTcw/Ij0O2M2oCBiYxdGfp8ebVWf+5rJmcJ3ix24IOX69MFuc3zngFiKCL4xX2GWv1TkzeYWwl49sdWHerQ91xF1fAdBkG9hN9t6QceelGW4whgm5TB7CJV9xJvbtWPAzXT8COip8Lm3r2BNW5Ko3SBbDuth0P9PaSUoIzEy3VR90R5T7xg/hcB52SCSNTRfHEA5hh9fssxm5W8FXULF/W5d0EOQm+pT+bEU2CHkY8QgY9drKn4BdY2N9P22SfqckVQ+Ll3/9hi9cozJ8orHvmw9S+KMXnH+RsM66u4ssixmmE2kaarDKryz6SphUgqnF7t9pOG3me/uVk
 47yytzmk
 FjCZZct9wmDYf2R2tSKcEtvKh3PTGDqPJhEVSAraaqMnT0Uv75WLAsmQtDyCe7YJ+sySRHxxO9lnT+1+q5LEh89ap8R02KK/tXct/NWu4JorDiwAZ0Tri8McVeSGabX0VZAgIEtCkXYop7euzJvsiiOOuwM4qnx8j2DuSFotZ4sqdzkZrJbzCbShCKPpyXU7nI+yADFV+BWfIeIwiwHfdbbdRM7GQDkav3JC0uS0buTo7vwLXW1Y0HQ12qnGhw2fwhGxZ4xh6IETVQTylKo8ZiDj91lxxmcnHQJIrzTZKbO73sldT1mpyh1w4SAWFDuHfugfU7aKpDWM1/2iZFyeW0EYlngSTvTzMrhesoj8Ge0KsWydGOlPtBy8OPXnxIzMrv74UG8Y79TVxEV8j23FJtjr0jKR2ffV6S6E0QpdFgtTIc+yiKpaGrdQCjg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To print drgn status to stdout json.dumps should be used without
json.dump. Change incorrect function call by typo.

Fixes: 441f487d6ebf ("selftests/damon: test no-op commit broke DAMON status")
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
First I'm sorry that make you guys work twice. This is fix of my last
patch [1]. I'll be more careful next time.

[1] https://lore.kernel.org/damon/20250810124354.16456-1-ekffu200098@gmail.com/

---
 tools/testing/selftests/damon/sysfs_no_op_commit_break.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/damon/sysfs_no_op_commit_break.py b/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
index f557587ebc81..2c65cffe6b54 100755
--- a/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
+++ b/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
@@ -62,8 +62,8 @@ def main():
         exit(1)
 
     if before_commit_status != after_commit_status:
-        print(f'before: {json.dump(before_commit_status, indent=2)}')
-        print(f'after: {json.dump(after_commit_status, indent=2)}')
+        print(f'before: {json.dumps(before_commit_status, indent=2)}')
+        print(f'after: {json.dumps(after_commit_status, indent=2)}')
         exit(1)
 
     kdamonds.stop()
-- 
2.43.0


