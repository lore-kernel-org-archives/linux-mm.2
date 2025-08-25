Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DC69CA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 14:58:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98B7E8E0039; Mon, 25 Aug 2025 10:58:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93D6A8E0038; Mon, 25 Aug 2025 10:58:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DE648E0039; Mon, 25 Aug 2025 10:58:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 682FC8E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:58:11 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 308B41DDA43
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:58:11 +0000 (UTC)
X-FDA: 83815585182.01.8A4BE28
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf09.hostedemail.com (Postfix) with ESMTP id 50B2E140009
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:58:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PW9+M36j;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf09.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=linyongting@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756133889; a=rsa-sha256;
	cv=none;
	b=0t9DLbknmYhE7DczzaiCIVgby0NCQ75Jn+kw14Ny2MwChSQE+s/1N/yGaB8ZwnYbW4rOsw
	mjVZTKd8SOgp0Oe8Wnbb0WInNxpnuUOnCuC5DvIj4J7WLtKhh33xYW+jBpn2KPy6KIfZgw
	lI706YMXBlfvOUp84kfDinCD2ZFKLOI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PW9+M36j;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf09.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=linyongting@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756133889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SXrNbcwSvagaIiS5O7F6FLpYe+f/n3DenUIqxElurVQ=;
	b=AQqDS3C5KSaL8FM0srmjy1nlZPlx+A3G3PEb9+zwLNr7Uqu/S98CyLWKK5vIhSWYEo9dV5
	lLAYk4PA/pg7AfHaUSzH7JCoP+TevJPuw527K4biZphvaO5p6FX2HEkuDuDYwB5Nqg3HKe
	q/a/EAPeEu9XIOH4PS6nftRqyHcSrkk=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-770522b34d1so1277278b3a.1
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756133888; x=1756738688; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SXrNbcwSvagaIiS5O7F6FLpYe+f/n3DenUIqxElurVQ=;
        b=PW9+M36j0f48oVSrPp7gkJGmnIss35fvbSKniyQLIx7Nzh5punoeJj9oZjwrRWMrLU
         8rCtXQme15IZOqcU1/4mVK2lXwcRAUlnl2Tu0hqDI/+dpxqVrhye4Cdjpplv1KU0Y3L7
         xVKoEeKwgEWc7aMwhEgZc8EMCY/mhpY2CftedcnUynrPFnYEer2lG3eL2tmb5Dz+4YqB
         o6G5KQOmo4EThs4xYT+wccpxX4uWM9LQeB4E0ChwaKBRj6DzQa5UQSHbBGw3u7Ih1odR
         CfnycSLrTn/7h7n3wgrmB07drwsOWMXA3oQjKP1vOkhvyJHUkAIehbRQN0A/t0IFwhg5
         3j7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756133888; x=1756738688;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SXrNbcwSvagaIiS5O7F6FLpYe+f/n3DenUIqxElurVQ=;
        b=U65znuK2Ya8W3mAg6PoFo1CAHwEYbb3+VSOFATiLTpwPtBx7TjWAczs2S6eOQHl94T
         5MKqKdm8H8hZXoOWgPFrsvoYLPUvi/Z/MjigLBhGFjDRLrS/7kiRzgSTly/fUAwJD3cJ
         vttHSrB1UPyO1YH9XFvoF3OEO27LZi4gNmhXRXYA+nESKqx57whRvpOj9vX8Jq4hWmCw
         DCWh/N0aQ4+L7J8FNNrzYkAptp4uFKf8AaRS2+YM1+8ha3N5pxddx9HlBL9ZMuDO7j+U
         TlrKjmHCcrRqmSw1qHdyWd0phjG1VIIk5hQKJsugPcTPpcb0IuerJTvrKp4IN9zhEJAn
         Rzlw==
X-Forwarded-Encrypted: i=1; AJvYcCVJvnf8KG95KwyCFeNY+JTtRWlWD4WxYENSZ0PXv1nMTgiIP7fVx9UJXBNSGZZkMKkZ6WLUPVJycQ==@kvack.org
X-Gm-Message-State: AOJu0Yw8XOOA+wVXoOcqecxPhvZdgRwvUjupe52KlPQiq4AW4kfYmJxX
	w8qbWUuKQz/uI3fijOx3BPf7UrAZ2/bxZE7XeNdh7pyuwZX2/duvdEyeKJljvnqpWvA=
X-Gm-Gg: ASbGncvxgLGsfqxwA9hsf8mtbB/PjPNvLDl8t87PGrHh9bfWaQ1sis26e0FbEruOCTl
	Z2kMj9v9RLSgg4v3NguDdeqvG03o1weYXgi6IUaMdMQO2r0potU8FtZKtP4FCw61cEZphuF8R79
	yGQf6pE13A8VzWoqEPtr+E9nMgSou5kstGf//j3gPSzH3BMHV+YUIcaJNnEbxwICk2qbUJrhz1r
	t0Ac+Q9UOGuaSOVM27FNuZBj0hpgmYaUYY1f4qOBPqoU/CumvquzJRYItXvR2fZub5TgRiHb56d
	Q3R8psAcgSbatyp09U+JkDHJk0P7qsUiYXgkWieSgPikScS/r6uYVyPed861X4YdqUReWkOORyZ
	UdMepYDPL41f5V29iYEdXgiWN86I54gFSOWhA1wK8Z3yr2AmY2H3KmyKzCn4uCSgsvpFB0Rc=
X-Google-Smtp-Source: AGHT+IGrjnb45Fa7DHzuc6Ch7rwJg1bCnvoGJ7/OuXRvlJDXrJ/ha9DOEb+cFlOakG8+pSYCIswgXw==
X-Received: by 2002:a05:6a20:a106:b0:220:1843:3b7b with SMTP id adf61e73a8af0-24340b58322mr18480454637.4.1756133888059;
        Mon, 25 Aug 2025 07:58:08 -0700 (PDT)
Received: from H3DJ4YJ04F.bytedance.net ([203.208.189.7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-770401b190asm7803436b3a.74.2025.08.25.07.58.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 25 Aug 2025 07:58:07 -0700 (PDT)
From: Yongting Lin <linyongting@bytedance.com>
To: anthony.yznaga@oracle.com,
	khalid@kernel.org,
	shuah@kernel.org,
	linyongting@bytedance.com
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: [PATCH 2/8] mshare: selftests: Adding config fragment
Date: Mon, 25 Aug 2025 22:57:13 +0800
Message-Id: <20250825145719.29455-11-linyongting@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250825145719.29455-1-linyongting@bytedance.com>
References: <20250825145719.29455-1-linyongting@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 50B2E140009
X-Stat-Signature: qo1k8c73r5aiaja13khkc8ddxtagew7j
X-HE-Tag: 1756133889-831871
X-HE-Meta: U2FsdGVkX19snqALnBQnC9z1sRIsAmlFLzRWbl6WNl407GGprwumLBXQFTBSOrYNjGp71c87YwcahFne9Sl7/81oGr9Pv0YzL8cBXaJTatMVql6sX21snmtTG2PDWlmnqcgJkOxFEyfsdCItyI7QMJITYOXgis+H7iAB+/zbAs2Tt8NsOL5pkHHIlTLnEruSsVFxiaF6I/sNCFnoxyEnlnR90yJx+0SpzuceTTEXJWRIBZK1E5HDxcNsZRrQzhiwYc4AmYOt1VstpYeW5TTLnm67ZvTOBuASdJEWjgfB+j2ZPQdPED/JGmhn1rdEcfHjjtItNdSoA3VVlq3jPb90jLYhDrF1C9meoLU1QD59lO+vzR0HxDQmaohFv9cgoz3XmMStT4ftXMGrptkfcSKzIqGWCJL4QJnwoltcfwvj+mdQpofrpeX7fT5t2OP5Td5D2f4x/9qllhrTKtl3Pt9yWzp61EXqHbOHiMJXdM8w2acTQ4Wg4JfwZgwJJY9WnId/lB8f1wRshWtiym2g+0/O0V1VS+cK9CENISN/SU73taIDNQnG/VAK0yCjOGrUiMXsoUpENXcKygBbgf7+IAHxrPuGzZFHI1Q5blb/H16zi2k3er6GphSnRISa3ziOxDNRpxPOKvYgJL6t6NSfA9hytTgYb459OM6HNNdyjPvsUXAUPGU1k6DsMZ7xvGkHFbNonyUA8G/ps84BnjZ2cT8SUV/agEwr9FqBS0YEuVxU4SgypzbmI6j4JxKsXMwzz8H3BSdSYdF9HsDsPYhgz/yah4gCZ0tDwYxaTyDQapwaT60Eo11RSM1g3Q59ndhgiG+KyluqwAMxO/1dzX81mYRc3deE1tVKmX4lNx/Q0LxS56bWDUdYFf1eUSFNoO+lat6K7CAVVURWX2txafoEEVq0yzA69peXHelYjUEUA3xajq6oyoirxgpnOY7UejbeF9+5MNROEFF2W2pNJhjHFjf
 Gck+HMQ3
 LpuscQ0uIkmIWqX+578h5N+0B/8XyICjJMCSXEdJlhv/9Qs8+8JkE/rxMpZlwktdhCJGZGutRC/sUNjX4pGgw1aL2qNHuk8WDdjqkGoNtJx50oCbcgnBrjtgwF8D5eP7+88p55XoGtvEpYnubX+8fGLqAwnXYTosV+/26HT8lJyS+8zJtRirJwkhbi04W4blhYltdFur8mOD80ws7Re0tUiXtIU7U4njyFxZJW/yD+0QTegQZTXShvOef3m5si+G+F7FNLZIMcRTMJVPFVT1tLyF/bpx2qKsye8ff9hBTa8UVjXjkG9lZ+kBz/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mshare test cases need pre-required kernel configs for the test
to get pass.

Signed-off-by: Yongting Lin <linyongting@bytedance.com>
---
 tools/testing/selftests/mshare/config | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 tools/testing/selftests/mshare/config

diff --git a/tools/testing/selftests/mshare/config b/tools/testing/selftests/mshare/config
new file mode 100644
index 000000000000..16fd9a3ca12a
--- /dev/null
+++ b/tools/testing/selftests/mshare/config
@@ -0,0 +1 @@
+CONFIG_MSHARE=y
-- 
2.20.1


