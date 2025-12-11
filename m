Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9E29D3E780
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 21:37:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F70A6B0007; Wed, 10 Dec 2025 16:37:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A7656B0008; Wed, 10 Dec 2025 16:37:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F26DB6B000A; Wed, 10 Dec 2025 16:37:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E3E816B0007
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 16:37:34 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8CA0D134D99
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 21:37:34 +0000 (UTC)
X-FDA: 84204873228.23.F6C4673
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf22.hostedemail.com (Postfix) with ESMTP id B4B30C0004
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 21:37:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CoCR+uB0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765402652; a=rsa-sha256;
	cv=none;
	b=hCmmtI/KkZxzIxomGX1Jfa0FwENsm3ww5/MIdVpeSUOyTaLtvwjoLuUWjDYGRAzuC8AzpW
	5yROgYzOuMVxuQKGBUOyargfYnFBoasEv2yqB2nN6Yfvgz+k/xmRmdXhprK9NSGQba6I7w
	2iET7lMCDtKcGNYnKgR4qOLh9Ry6IuM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CoCR+uB0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765402652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9hLmL5UBaH7Jl//7hZV10HWpa1IsgMF0lpOrAgcARCs=;
	b=nPvZli0lkMtj/Fskg10hasHPnfZckELEzFpLldDN/p9X60nxPlRCTwdyuE1ktF8H4fiC4u
	tT8ukz4kXoHtjsaVTDpn1+A8BJ6TkARxH5SOz60h0pbw223LdRRYrkflpgeQ48Tj7ibOzG
	eMtnbXzyK4Bt9zdJ0nNdnQyNxOhtKUk=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-29812589890so4138295ad.3
        for <linux-mm@kvack.org>; Wed, 10 Dec 2025 13:37:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765402651; x=1766007451; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9hLmL5UBaH7Jl//7hZV10HWpa1IsgMF0lpOrAgcARCs=;
        b=CoCR+uB0qtvcO766sAs9CNgZ3rXqGtl8ebB7g0/32bF0iAxtfLMvwsqADhd5keV79D
         se7btv2OZsT8gHUzAcmKXXtI9vnyO0Vx2AjgUDsjPVRQ+2PQsC3VWMHF8gVhmYcGaF1/
         nXGxUmsIAc1pNjryT9Bzoh7Eb8ap8FSOe8rS1sjpWaGcKfdwtrxIITBddg9bL8xu64Im
         oh6Fu4sy8B2tDM22Te4Iv2w2s0QS0OOnvUZAnsTp7lrz/eNTICSdegx1QMFfOfu6N7nZ
         EayI21M9BIB4RIbcDJ8RBkSWwT2RUpEXE6QRsX2a6l9tnsn1zVAt1R99SehLaFWeyko2
         e4ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765402651; x=1766007451;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9hLmL5UBaH7Jl//7hZV10HWpa1IsgMF0lpOrAgcARCs=;
        b=UjLlVQfsx3PJrG5SfJSNxvt1Jakns6XoHZVF6woEEy7JQwqO6bMLhggOND5eI4P2z3
         jz5MpzyC8mr13F39H0HGPI66ZRRT5gWGyfUOfgjlO3cECmSrnFseKDFRXdgQpZTbYPRZ
         Uqg4eig3M8r8/hD2OpteOb73bAp7CfUU/SoDHlL1JL3i0fEo4Ay8GGtoF6p7mCPqXhcv
         C85ygdPwM7Q1i9V5DwE1HLf2PcaB7lLUk8L+lmRkW/55zjfx3A7Ou7PCXw4YY6igqcVd
         56zuwGV15EwdTuLiHpB/zLVmCT5FFvKWTNnYlNMtfVik6ik4xk22l1JjpDCiDKlZ/xwz
         lXJA==
X-Forwarded-Encrypted: i=1; AJvYcCW4pm6bOXzOX7US/dUNSiSimRCvWi9G2lYpkqtBMoPOQOuszdKlso9lZZgKILEzzwjTSJmMBqHgxw==@kvack.org
X-Gm-Message-State: AOJu0YzahmloDVozoz6Hf+7129Et+o83r6MXeGHDRa6+JPaxn1wvEiHi
	XIk2wIvwodFPI1JtiwmW9ufRaPrnZhsh5OB036VUyEhl735uz665aXCM
X-Gm-Gg: AY/fxX6q3aQov8ZobX+48EPapGAzwI8RAcFscimSsiyxX/C7R47AL3EZvJ53VhAtxxc
	dT5KJF2Nps7zXCSq25ukIpqkatL2F7QGWyyEpYuAtiQYpciY15N/31+7yeK+qd+dUL+hC7Zy1hA
	7bc2tXei1I3OEMoubPLolngL6zW0E8CIcyxvIvbzNg5cpP2kcp6BaLmgKLmVrxGFQWjwJlbZSMg
	SSFtsjMI2Ejqxs7Fp4knDCnSKUWDSWC3FdN7CR5179NxrwVN/fU0hA61Ky8IqkVNdSRosQa0gup
	dGT7hob+9tnz9c9DkWXkB8z8chb166OmHN0BQ+1NNrqewikdi3XxNi20AoZYLoYVr6UNGlEVKMI
	26SMToWT2ihuFZ1OlYnc1JFHhO4x5F6cQIBHSKCb+v12ha2vFl1TDzB5e93/GuB/v60tM+DaMCT
	yvHnoy1fHdwHHu/g49UjFOSENBrFA=
X-Google-Smtp-Source: AGHT+IFOKeCD7SLJaoyaxSzMzfFpQdgEfp6KhJDB1eupbtl6YbSdpyQhFlSIJb3jOZCFQdhFRs3+hQ==
X-Received: by 2002:a17:903:32d1:b0:295:8db9:305f with SMTP id d9443c01a7336-29ec2d40dd6mr37532245ad.34.1765402651414;
        Wed, 10 Dec 2025 13:37:31 -0800 (PST)
Received: from LilGuy ([2409:40c2:1056:3997:289:7d28:d8ed:a86])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29ee9d38b3dsm2922135ad.36.2025.12.10.13.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 13:37:30 -0800 (PST)
From: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
To: sj@kernel.org
Cc: akpm@linux-foundation.org,
	damon@lists.linux.dev,
	david.hunter.linux@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	swarajgaikwad1925@gmail.com
Subject: [PATCH v2] mm/damon/sysfs-schemes: Remove outdated TODO in target_nid_store()
Date: Thu, 11 Dec 2025 03:07:08 +0000
Message-ID: <20251211030707.16417-2-swarajgaikwad1925@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210150930.57679-1-sj@kernel.org>
References: <20251210150930.57679-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B4B30C0004
X-Stat-Signature: h9x5cyca4s8piwam6js1ibxw19ieyoor
X-Rspam-User: 
X-HE-Tag: 1765402652-907766
X-HE-Meta: U2FsdGVkX18Zg2t0eIRbudtgaXKfg1ymcZbA+qtZ7zz0MR7vM5raO1Te3XIpuVUh+z6YndZL1wbLmPCNa5aMucowlurjMrmKIXpU41EKiCNVrQ07HFGObBzRiw3wjXhihyoQfokn1DT0pGf7MiGMhnjwA0xkh1FZii9U5hJkMjZH1cuL04Aj4VdU7v2hAVlRAKCiIHHThb4+2OLS2O5xaRuZyqAEQYqHPasQGc2YnvSkoB2ibb64W+ONlDy2eGnUBH8WSDNW1Au0qBeW4xgUEIGHnuAUXLFnVUhtcR0i+R2mVf4vU6Et7eZMhORdYwDXHVe5c24Oh2VE/WRUDCS0iuN39Zjr015c5rE4GXJkZ92YiNauea/mYk/4+qydGED7eSeNgRAwucl6T90146zP7S3wprkGF9N3PuwlJuX7e6HB7vI7vb+p9fNK2y2pR8pYEUnJOx3GQVk+IWG8G6r9NObeeLdk9mf9DAWsFu8Q0J/rPB4fbYNhCMnG95s6LBDdWwapHVjV1E7TauBbQHX+BjnaHPWWUsPvKfvRMKAjHHNG/Gfof7xM6uMX3wbCbRiIwmAZXLcP6S6DnGgGk224NRHMSqDCp7yBRFh9GUUP6D2kps72W0pqnM5vH8DIAScu7p1ZUAVQOBruHSqK0gnhAnk4CbBEPZWz0iZVR21txoBsNV3PVI7IWRnomUuoO8oG2QvOtjRR98amofTF6Vey1pqJEzTQxiUFlqfsGKigksJPD8m41RtKFBePL/GOEu3H7VQiIyhF6pYry2u85Ea7lQhHnKQBmMpm9IXhKVGi3/q4byBbl115yq/OMJO2ZJiE0BfrwTywY7UQwVXYpe0ZtyeIPihCrA4QUV7UAvByTGUB/H9OpqOKCHWUfBNBItnfyGsxcfBfnkJVF9s8YEOE/Qtr6+NCrlQFS/myjjcVN/TwdyElh2/vcR26KRh4MOxc5BjKeJDwcf5K9IL5x8m
 nOu2QDWi
 damfJp5BJVWQ4nq48iNQW+zAlQIO0iifBz11axj/bm5CJCQKil0u/2UPLnAxoUqD1/Kl2wEmI/uRD3KlqkjAl7qUXVmBWdqPuZw+sU9F8WPs91XvsSkU5iHr28ev8wd/YX8qfUpawrIx7LgP+LdVvgr/J53pAQA/FG5yjMj9BDPoKWF80Gc4xI/m6vE7KMITLTfh5pR5yGDqRmmJuTryBHTVhaIedKGO9iEuUsRqRezowV7wMBHry7NEOVuWRjlw7JbzyEgNCliEtVevdcngrZV4ndpJMxgzDFEZD3LDFbflHbPYxfi3buOhRd0Ja9Z1N9sGLvPPY2uUCE4dUTSOCh8qDDUX9+e2gka2v0AAUfUCsnI2rjFM0by7CyTxAsyNt1sKIoXsNw0ve8ef7vC6KlxptlVuwdoqOudNBspSWPVEmYBL7Jy12VHKBXuM/YyEQX82rAUVBYJet1p80p4EGlCGK4hzSxhybCVUt4FP8MEfMZUECw/PR9uz823ZdvkoHT72MwSQRzvvwJFXxrvLSLxLo261Y/W3bnjFxTBAcMswbQEJLHwi4HURa5qyhHNUsF+5J
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The TODO comment in target_nid_store() suggested adding range validation
for target_nid. As discussed in [1], the current behavior of accepting
any integer value is intentional. DAMON sysfs aims to remain flexible,
including supporting users who prepare node IDs before future NUMA hotplug
events.

Because this behavior matches the broader design philosophy of the DAMON
sysfs interface, the TODO comment is now misleading. This patch removes the
comment.

No functional changes.

[1] https://lore.kernel.org/lkml/20251210150930.57679-1-sj@kernel.org/

v2:
 - Removed the logic changes (validation) introduced in v1.
 - Updated commit message to reflect that only the comment is being removed.

Suggested-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
---
 mm/damon/sysfs-schemes.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 6536f16006c9..14a17da350ab 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2245,7 +2245,6 @@ static ssize_t target_nid_store(struct kobject *kobj,
 			struct damon_sysfs_scheme, kobj);
 	int err = 0;

-	/* TODO: error handling for target_nid range. */
 	err = kstrtoint(buf, 0, &scheme->target_nid);

 	return err ? err : count;

base-commit: e9a6fb0bcdd7609be6969112f3fbfcce3b1d4a7c
--
2.52.0


