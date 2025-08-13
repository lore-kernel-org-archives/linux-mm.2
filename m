Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC97CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 08:02:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F20DB8E01C9; Wed, 13 Aug 2025 04:02:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF8D48E01B6; Wed, 13 Aug 2025 04:02:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E35C48E01C9; Wed, 13 Aug 2025 04:02:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D50638E01B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 04:02:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 61C931DBBA0
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:02:39 +0000 (UTC)
X-FDA: 83770992438.06.D126ACA
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf05.hostedemail.com (Postfix) with ESMTP id 84D5D10000B
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:02:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PpOkLAod;
	spf=pass (imf05.hostedemail.com: domain of colin.i.king@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=colin.i.king@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755072157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XVe0idgYx1J+jUFo1Pbaqi+aQhg27OfKm5O0YenTYzE=;
	b=fvMJuQaNx6MkodjXqO4CpU5LNONesl8gR28PQpuEoUSDtsiQTWh985a8I6gNafxr96E0ig
	rVYNdFXsXfS47pkZM6YbAFYEq4ev8V84yiAU+gGug5O3ZiwH/AQcvnBy0f7SsLUFcT5u3l
	zN15kGUyauHUPAHtHT++8+OsvbtzMZ0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PpOkLAod;
	spf=pass (imf05.hostedemail.com: domain of colin.i.king@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=colin.i.king@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755072157; a=rsa-sha256;
	cv=none;
	b=4sEU3xDyGnyWyFmUSi3Tte/6geSVNRMrAtHlYCg9+o9Msi2QBrgEnUO6GlsgkyW1Fl++5z
	R9o94lytqgI+8dczt/SOSANaF67S54yYU6r3Jt81u4TcL6MuKo6lmGYLDlDeRVNg0zEIDG
	SXomZr260RahwdioI2BjByUpBHVthW8=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3b78294a233so5168780f8f.3
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 01:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755072156; x=1755676956; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XVe0idgYx1J+jUFo1Pbaqi+aQhg27OfKm5O0YenTYzE=;
        b=PpOkLAodoXT14vetIZleHB8FscIrQjnTxmqJLbAaoUj2yKl26szY3wd5WL18yE3qyf
         p6i5F82bfJAO5mgKCKpv5WBuStZARhzreebmbKEry1FzMgZF1ED9osxnL2uzq3wwyTax
         R2RxtoJS5942E7t6RZA381KzMbZQHIvljE7uK6SA6pGiNbOYnyf080WQl+gNDqDMIJQO
         pgtEYfQ5rtZeOOrdedO90RfTMUbFpWFliC8wBLw/WOOtqzQKq6sYaevUqP9UcKjqLKVQ
         K6OmZq6p+/yHfmeW2tUleWq6/vB+sHA7p/9Nscr98onnmzVwM39JaArUZKdR93s48OBf
         S2oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755072156; x=1755676956;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XVe0idgYx1J+jUFo1Pbaqi+aQhg27OfKm5O0YenTYzE=;
        b=nHUc29r1h5Ra/DIkrB682cH9QA1zSq2+UTwcEpVOX4p0C64F5HqdXNbo+RQ07NGx/5
         r69TKHA1ySh/ZbG/VO7v5DoWxO3lLS3Qik/ENqJst/ZUo8ffyra3X0OtC9KrJPERkNRW
         mHhkWFCk+GBK6dWoFelPTVFHnkRo1PDugDrCYULvDLQZeK0Ojnm/CL+NmcDFEahSQpZn
         Bt3GGEFaUh3H0RORPVgzlquLESxXBzkSpnek6uHPnTqfOXDrT1LsN4aWpjlYQa6QWRIw
         Be1PiCmD2pq4o+lwcoGT0K+/7g5rNrdyAewFMnYtnRvzqOGHPoZ/EiHns9rvUAL/Udal
         7Gtw==
X-Forwarded-Encrypted: i=1; AJvYcCV2olwS9kzy0+krSHCEkeHqkfuSuw4xvfSHWUc66go2+AHuuRW6/VJMAAY3q0cEvJvXZOp5MUo+oQ==@kvack.org
X-Gm-Message-State: AOJu0YwusYcGuLkTcxVA1774k3zGzHRP2UE2H4gxp4uoakt4fWBk7LHG
	u9QCqVGYRzEbN8mwUQ0DbiwWLNvuGp4tovpplbCS9pJMJPvPBys57eUx
X-Gm-Gg: ASbGncvwfyc96DRcUoWtxMNbl+ZNy2FSVeHbMhsV91Z5Yz0mEIGs/I/uEClmjUxWV7p
	x8KYk/zo9SDseR6pBj6mILHdjOwCwgxBKJqO5RwEGsTa4UYWvr4BIcJz4A8+AOHPeL/1eoDQ8gB
	3a1uowTTBUc5Ti6C3vKN09fE1YZ7YEtV22fMb+9ZsvOaONZrCMKm6r/9uyxavoQ+qAsVj7RZWKd
	IIKtyxWbsJt43+w8l/Ydf/j43fwNof74dOMWbZoagmuOSjxKtaaO+hQV99ORdlInXb2PZHfxNpU
	y8idQKUksgPllpVf+CKsbNVJhNEZoy/6Jrm5YyGiiaI/menLUV95i+3qjS++DIivQdaoucLIsvk
	2mGQYk06taEz09BarEZhy
X-Google-Smtp-Source: AGHT+IF2JGABNVx7BZux6MpyAVD1R1nKdKMygCmpURXyXIjOojtcxVvm42vK3OiP0B8MvRjzDo8c+g==
X-Received: by 2002:a05:6000:240c:b0:3b7:8af8:b91d with SMTP id ffacd0b85a97d-3b917eae69emr1631360f8f.35.1755072155716;
        Wed, 13 Aug 2025 01:02:35 -0700 (PDT)
Received: from localhost ([87.254.0.133])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45a16de760fsm18991555e9.17.2025.08.13.01.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 01:02:35 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] selftests/mm: Fix spelling mistake "mrmeap" -> "mremap"
Date: Wed, 13 Aug 2025 09:01:56 +0100
Message-ID: <20250813080156.1977375-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 84D5D10000B
X-Rspam-User: 
X-Stat-Signature: y4tsem4aig1j5w83za5m1st995u9gcir
X-Rspamd-Server: rspam09
X-HE-Tag: 1755072157-893649
X-HE-Meta: U2FsdGVkX19VIVOSFHWgjTMWnsyu9QDZeCATNpt8VBq4TixcVHzDxFfT77NosT8nRoIsEqNjHqu+x5Fd/9ClBSxVB8DJKNstsU20h+GUDUmZyAwLee5ZGTNl0VxpIfcikNlm5wKTz0v69nuHIsdvE9YZ9y6E+Hsyxmg1/mYE155ux4LTr1eigQLfUHUjP3KCBM63D2j3dT3855Cxjvb6cLsEfpRtTKELrVAC/2idu0fgZ447f+J33vieTCCf65CxNACmFGY0Hn+zJJ3PcDmOjFF6vOQqrLzSovcOWB/ncBgq0MTSgpbkXRJCpiA8hZKYtW9dYoAS6T52ArS7ocNFrOTJD9ZyrytvM9Y+1F+vDjSkx4wBprlQZ93zdnvZ4/Wsi5gAsV9aVplo/N1X53UVH9s08l9GD2zoF8V44b4BkXezXi0z+t3H7LnEx8EvoHqnUbLwFw/maujvEK6lLoCq5edAIuGWK+EvnscfuW/bFG80QqtQJzON/bAP0HSX5DCbdOVhUGVuu6MmkpfdwcT3eGCVUBO3pNdqxMa/Qc14eIXoaGtxLImwGFuczWo0JLkX2H7NAP+hxvvSsXl9nw5Bk5CQr+He7MmW1bsVThkOlcmjj+b348WKWQacHGvlCw+BUND0mAVurk8PBNMO0tiMeJgoJfAKlb+FmgMfmLYbofDqPVgeWMzjQWB/aJ36vZs5YKhyygbEo3H/G/53sfVqUQ0mTUY7w2C6jeZ+kzFfkIHbLLCKhW7mJ2d7cKxPKqTGsetWS2WpqjDbvl0wDfZD9sy9WmXAchfkSphXN6751n20zSEG2rIkLSytFfbqzS1fJ8K0BQJP3b9fSQ5fRH/uT80LNPPwbqk2u6AIMnGpA8EPBLX+B5KElEJBoqwH+R15Asvnkzze3swUl8fqN3kVKV/uUXNQa5ulKzaHn1BGIRXCoxE+G4ZxM+Bq8eDzEr710JdaGIhBITsGrqqvzTL
 7Aygli3p
 kzUU6CxXizXKVeUyOdv0YHlOn6IKfOPWcEXXNHDKGV1mrdOaQWSiAdqaCaFNLz/0BbQFxmATbvadHyXmCdb6qAJ91kOpp3Ppwb6/+En5qzJy2EGw44NHP5pHnPMIzzuVZ8gCcjApcvbDuIIM1ZymXOKmrZM0MqqZdJl5D5SKgqJQxqRq5gNvZ4A1NazwXRp7PHX2Qc61V50T1RSBHlS1SpoDHWXyev3+CSGDb984+ZdPprIUhH+zbjuy1Voiknym1XfUsbyAqLsN57q964zr2DEUT7iUfZPXLQF27ASjx+7DvWPg8U4cEtwCQ/RAiGE7v4aPIFFXKTFxL+lyUMQDxeESt5Y63rulk0XS6R9j+Ysi0iSak30tMOkwXECLqAdEnKwsdmeAJx14e2ajsHlKOJQ2DpnmnkRXip4kY8WGQ1nezCYrnO9pWufCLXG5MTtFP7vL2zo/cCCjkbwbnruy7XfCkr1ufulemorqUjf4KcdStyof8oodaZxcUjrbuodKg5vDWGAio+UtSma2Wk1dzb7yIYdeWjXdsNGjCLQOQEV8BGk0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are spelling mistakes in perror message. Fix these.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 tools/testing/selftests/mm/mremap_test.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 5bd52a951cbd..e289bb1112db 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -846,7 +846,7 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 	}
 	if (err != EFAULT) {
 		errno = err;
-		perror("mrmeap() unexpected error");
+		perror("mremap() unexpected error");
 		success = false;
 		goto out_unmap;
 	}
@@ -899,7 +899,7 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 	}
 	if (err != EFAULT) {
 		errno = err;
-		perror("mrmeap() unexpected error");
+		perror("remapp() unexpected error");
 		success = false;
 		goto out_unmap;
 	}
@@ -948,7 +948,7 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 	}
 	if (err != EFAULT) {
 		errno = err;
-		perror("mrmeap() unexpected error");
+		perror("remapp() unexpected error");
 		success = false;
 		goto out_unmap;
 	}
-- 
2.50.1


