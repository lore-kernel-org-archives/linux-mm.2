Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CFBDCFC27B
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 13:36:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98D846B00A0; Fri, 21 Nov 2025 08:36:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93EE46B00A3; Fri, 21 Nov 2025 08:36:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82D546B00A4; Fri, 21 Nov 2025 08:36:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6FB626B00A0
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 08:36:47 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 81AE913024A
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 13:36:45 +0000 (UTC)
X-FDA: 84134714370.21.C002C19
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9DAD840011
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 13:36:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b="v/g8zWjx";
	spf=pass (imf04.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.53 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763732203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TzEyBCas7IooWk+MKSQXAh7ZMi3I77yN3jnhiz/DdHY=;
	b=xc9ci8YCW69w1q6wpvq3zCdOZ+2SaZLSF8b9bTmTNzV58Cr3XW2g0D6HWXy3TVuBULeaXj
	OW/qXe1jPpE4DYjf/qZ2YV7cwIbXImIxIdIo/bOsck03c8yddpIGY2PyiB+5gglr2xc9I2
	M6tLNMVK2UsRhUSTpIlTzeOtRdjiTVo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b="v/g8zWjx";
	spf=pass (imf04.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.53 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763732203; a=rsa-sha256;
	cv=none;
	b=UBaFWuOSKhYEv4kjQox+QgvFH99VZ80EZn2nTLJqDQaHepoblepV5uYzvNwhle31dcrKjw
	GiqzzbSgHgx2H6SDHvEXEVpgxmP36smTZjYMs87OmQwgBfzkOBZvJg6Ar1n0Pdmcrv/5xE
	IP3rXsytHcvUVhp7pBLTTuLIdvTjXEw=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-477bf34f5f5so6875135e9.0
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 05:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763732202; x=1764337002; darn=kvack.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TzEyBCas7IooWk+MKSQXAh7ZMi3I77yN3jnhiz/DdHY=;
        b=v/g8zWjxFJ89VvbT6rTeMG64hJ653/Snk4elY4mnevJEx+7HbzCHoez2OUiPbvk0S5
         6L1NI59I6H9QosUfSP016+JXVTGdMr8cuaqpgexhs7JwdbROBilTJ77hvDnCTA3RHsS8
         rXQablA7CxfbMqMACU7lhd9JT54O288588k6cnWL4ghSmzGineMdhdESUN0y4Q1jU6Nv
         Dr6JxPlpMAdtbfrR/zpGFjijqi9VB505TUPtvtIIgQi9KJGvCaFzK7scXqj+WtHRbevf
         nRzk4cdnfyU7ICR0W9KSovhvuhUvn152KxMrdTSNYus5Z1dKlFH+S2PuwBksHkYwDph+
         qDkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763732202; x=1764337002;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TzEyBCas7IooWk+MKSQXAh7ZMi3I77yN3jnhiz/DdHY=;
        b=agMfwCZXuhd3/bgBZQbdGOPvPMW74hd5RAav1AQlcHONDAbr1paToJXo0zdwwRWsPt
         kqVM3mpTdKFDFNjuvMOL8rGSpfBjhtfRIU0v5dVYygL3P7U0G420ZTXOVI7DBgz6mXhx
         4UdLMoNV1jPesU8Kkz/lhYCBkcWTmuv7+InqmxDljs8AL2gsluoQEw3VbjTXhF19+AMQ
         vbtNzQz7i/LKYAQCd07uNfVezwoK9nGXYKtDtz34Y5datFQipMaBTfW+8ND4hKNHVnul
         e8/7MSkviDqGn0Z0HmOTFEqWh6gzQhnQQRomaWLM5ZupH5KFm61TYra1NaRIvinWhH9S
         Ks9g==
X-Forwarded-Encrypted: i=1; AJvYcCUd0btf2EKVyQxrgk2LKblp+Qp6mgSVxrqIRJaQ+t///v2oa39iNeJfb5ef2avh5V8LqTFhrKWIhw==@kvack.org
X-Gm-Message-State: AOJu0YyN7j3fOkT1zSijuf8gAZKnRfyY+EabmRqitnPjPqSUgFR8BCYz
	8Jxt0qI2wPSqtu3Fx3nBC13STgFEPzo+k4IO8V2mhsXhkWprl0O3jbEttTp9CvA8oBzQ0eXv1J/
	o1G/E
X-Gm-Gg: ASbGncsJOBEqnyTgLmei4FLKjlM2NW9EVmW978cNpQYJ//LCGPdnVfwOYYlfesKBSs2
	r9yJ+fSg8qTOuqSKsIsIN0FNdExVmu79OMzCDU0nCb3+xYs8sqyE54nKo0bPjb1G2wRgDIiK9Rf
	pOSiyDMV5JZi2vjKtGHXTRc86JkG03Dy+5olyt6JoaU1hF3tsYVQW++X5NdhWy6dk5PuNCj+oBU
	hOK+xBrXtzK1ICQ7tiDHeKTg6m9kd+Uw40dJzNgv61M31Wev61O8FTY5XxxauBL4ubvI+v1sdIi
	P3UEgwvPXR6KBjJQxyQUF++TbnVuLfVrd8rOlYzMQiGD0rfCd6UFtDxuSUPAqD+9vXwRyMZ959M
	zv67qWp+g4W/7ZjY5T+Aja5gNqorH0xWW5tCHsRx2BXjcYGYHKIYNHkWgNpVUiA5dN7Pc2Zjtvx
	7MWWYY/TYOr6NAXjbo
X-Google-Smtp-Source: AGHT+IHn72BgHYyXBAFrHrkEPwDLpmHZJhWH76OVXgjki7oj4pfilEmGcsYHhJxsG+r/JbIMusA7sA==
X-Received: by 2002:a05:600c:470d:b0:477:89d5:fdac with SMTP id 5b1f17b1804b1-477c01f4f4emr28632935e9.31.1763732202028;
        Fri, 21 Nov 2025 05:36:42 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-477bf3558d5sm43686925e9.1.2025.11.21.05.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 05:36:41 -0800 (PST)
Date: Fri, 21 Nov 2025 16:36:38 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Dan Carpenter <dan.carpenter@linaro.org>, damon@lists.linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH next] mm/damon/tests/sysfs-kunit: fix use after free on error
 path
Message-ID: <aSBq5uSPIqsqH8zO@stanley.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Rspamd-Queue-Id: 9DAD840011
X-Stat-Signature: jw8511kxcsyoaidc7m9wn4nxpupukuyb
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763732203-738187
X-HE-Meta: U2FsdGVkX1/i9edXFbkh1nxMvAeIunfEAjt1ho8CjXqRuTQ/wTBPrwTxc1R+LWSTPKjnrkFDlLduzDjT8aN3D396BwIsFXnjfJ639mo8hpbEXjgi5G+lcWEy9DsAPtvYYHx7oQFTZOKSIgBzvrUhIYgHJ9QMJmXqh90MY6tyMtnZw1vhtInbqb6k5GB4T1wW6yujrypzmGzfkPj3Hcj6F9OuvR9d1HTJvCY02Oux/f8klb+G+gsAjnXq5PHS1EESFFOt/T3hlm7lEuse2ZVmjdgExhFifFR1898az++hqSRkIt+tL1fMlK+gpcGlUaGr39D1kL6v408FrCEKwyWP/he5rUg+ag7/pd4RXBTKoAWEvIhziauEEvwssqau3Yt7tGbLBuXtzBZmhAl6XxVo+Mv/ULwYK4X3jMy1BKPl7uk6mwDVGhoTVooYFGtcOXbBvxu22W7gRDznX4oFc/0JQBRDMw/AvYofdhI5UVb71uLvmQLbBrHVUWWtf0h6eAXAQQGUsrHKJ59pcOWOvle1vF8oJdppI8Dk8bLq6UOaTSr+IKJ0x/5nKYJGBiKBQYdGCA7+e4QoSqwN4XlsBdhULn+++v711pNwjFX107283L/ytDRvFivMm4T7XL0NyXRcbqEatySfwUs8fzbvavZuh1W9CHKkxdnb+iQoIYMiw9FybiF764IZoz2TIAS7Triu8NdeEOLTnbuWRCFHWToPCtInVy5sdXcIuLRzgzxpurIiF5hTBUGO0vBmulAvpGCZzegD/3GMgmaRRm0b68I0WWIrZnHQOr+JFndvmKM8AEPgrgRXmGxzOpvM7JbpQ2YHqQXTHAEpSLcKavIlm3fuUMbCrwFfcTUbSQ+vNRytYEi362VNGrmLORXBE+LBknbQ8heQpc9i4dmtvSQUeiuRUPdioTtWVtPyjIPLD2oP5lvcwbbAhjhmS/dQHYwMNfgonhDfz3eJOlcJA0++62K
 HOevDpkm
 klky5IvynqzvE6RUe+BAJZJCgVnsPVl+8zowljD9bmoJ8JPGlI0m3GPv8q8Uch/PoevSZNPL05GBcoGsXB7DK4ZjzeUa/c0hvXnoZWUv3VsI/MdryH1O43oWF0QwOxG1W9ius1Uaf6UeVxO7KW6UeccstQIxY4uoJQFYQAnHz4ZeRjYFByAV/6B05v6o+21A8rbSW/w3HMe0Q9PsFkO5NGdbgW0CBJtgiZt5omiUCgmN3gfZr5iak+o3y7B2ddIe19k4iRaWF0/7S37MgL3dgqWuY6C6EgDNM7vqZbCtUOKjUOyJDGsOHMcF1C7hLVP/gBjflTsHAfI6qaWE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Re-order these frees to avoid dereferencing "sysfs_target" after it has
been freed.

Fixes: ee131696794c ("mm/damon/tests/sysfs-kunit: handle alloc failures on damon_sysfs_test_add_targets()")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 mm/damon/tests/sysfs-kunit.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/tests/sysfs-kunit.h b/mm/damon/tests/sysfs-kunit.h
index ce7218469f20..0c665ed255a3 100644
--- a/mm/damon/tests/sysfs-kunit.h
+++ b/mm/damon/tests/sysfs-kunit.h
@@ -76,8 +76,8 @@ static void damon_sysfs_test_add_targets(struct kunit *test)
 	if (!ctx) {
 		kfree(sysfs_targets->targets_arr);
 		kfree(sysfs_targets);
-		kfree(sysfs_target);
 		kfree(sysfs_target->regions);
+		kfree(sysfs_target);
 		kunit_skip(test, "ctx alloc fail");
 	}
 
-- 
2.51.0


