Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02986D6ACE8
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 11:20:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 664C96B0088; Thu, 18 Dec 2025 06:20:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 612AA6B0089; Thu, 18 Dec 2025 06:20:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51EA86B008A; Thu, 18 Dec 2025 06:20:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 429D46B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:20:24 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E8F6B1376D0
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:20:23 +0000 (UTC)
X-FDA: 84232348326.03.A3657AB
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5C49D40009
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:20:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kyDdwn1d;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=klourencodev@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766056822; a=rsa-sha256;
	cv=none;
	b=sfImxKHD/J0mwl+Wr63pLpSc44hbGydi0wiVSF35Pm8TuEBV4wh1nNS7DIIbDtb6pR/lUt
	JjFnrbNLxGBmAUOjl75F+TPmPtmNM0gUdMPHd2O7S4Boz6K77/4eD6279RBAQdhyV2EEQo
	Pl838DKIdl9MGp45tCWv3X7XSqIgrTo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kyDdwn1d;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=klourencodev@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766056822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zeySsSjr7T3BxLGhGs1RQ9d1ia1ASpkUpFFpYnHDsS4=;
	b=c7f6sQ1pGpvtmgfGChennyFxgGChmQfFr2ca15kU9PWOXlLJPSp51WHsxEODdpfIXZcApH
	jWjEQknzG9gB2Ph0rgvH01ASqSEfjnUpEbWTnN5o4YWBNxwxyvh9USr8YfvzjlspZpZAvB
	Edbazkz9D1LP9Jg3rFdyi1PI8oQOsFs=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-477b198f4bcso3858595e9.3
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766056820; x=1766661620; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zeySsSjr7T3BxLGhGs1RQ9d1ia1ASpkUpFFpYnHDsS4=;
        b=kyDdwn1dsbik9FDoOESbZZ/ZjajMYhYy8sivHDOzPicVAS9Fw19EI5PuQztYwBnO3N
         MZMjB+l0IWvTwmbV54o9hpHLT71ef5Db+w1saVmBjAtskfzteFgWeedy2l1IW0p6UbNY
         ofsAyoYA7A9r87MTEVnKft2isG257lwu5dEu1LQul/yMGgxj3xI7R7TQcjyE+Kt+QM9l
         jE/AddzWiuHRvoJ9S1a0s3cd1rIvDu4rjUVxIAhLBTNOTHRPxCyEDjaAdZjkEffKzRVj
         x2aPfL7YnhusBBVUhP5RkwLxA5uEd9CFQ2d0hkHK1CCGw0ChtB2k8Ih0d1WPJGwk/tao
         hFzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766056820; x=1766661620;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zeySsSjr7T3BxLGhGs1RQ9d1ia1ASpkUpFFpYnHDsS4=;
        b=gjR6TB5Q1pTM7jA7eqSjjy1mU1XtUNC/JoqWLQyojWumB1+DwXwFmbnl3KH5sr653r
         67xPtZTuuGkqqhtSiPf+RZA5GE4Nxz8a9xk/2SxtmJKWSuQ6HFZl7xXMOKvGX7jFlCVC
         QuKVR0mwMryY1bA4H3ydnUvDGkWPDyh7CtNWrMGpqCwpjKD/v2aMYIgrATgW18h5/OD6
         MgXVB8IymNNCl6vem20pOe3kltKNdpUGVFpO41kunwZsfNR8xt6yUxzigxrJj1SWg/jE
         3q11UE1pY7v7fzsn0MdzfWeyUa3v4CWq6H6GQD0xn/5uEszb8KQpdbgqQOQ6fjmVAqrK
         HH4w==
X-Gm-Message-State: AOJu0YzB84uAg6ogxM4risJO5DQlgpxgx13QPEmEc1ueafdfbJd9+wih
	5lBAzklBbo/VI4P6kjS/w68/Uf36DOQlSLr+0DaSY/Y9bVFFrcyLT7Sj+U3VNw==
X-Gm-Gg: AY/fxX4T7zyo23KfWMCwD2Z1mFhIhggavUhQKPUtX6dFZN1x1Eu6lwONttKDcluG/hp
	22i3oAaRLKWrGupfXA9NeaWIPt8pDDBx2dkZj507tugXu439LCa4AajG2Tfr4J+sJkX/xkQ+HkN
	Yax+trYO98KkS+6mHgc5VxWEbQxD/Mveh+mqMexSKDkO33LuKdyWOASdUazTk6RLoyG8h57UbNH
	7yCBcqMMoZyh+39PluULI4pa4kMOTNr2NxaMbQuGcQ2mHdhloB69ip8/0yl94POOnSrJ2nq2B9o
	gw9pHMWB4+fV10lt1slyUqQluONqypLnlWhnpUM7aBvt2j0cvcSg91F47LLU/TlC26ndSCpLTfE
	ts1YpOOiDniGorhlAu67CGUaViOJwJ5FcG3m//eoaLFncDivno+OTeBUbaFakjQPIP4mFExjojO
	QfFoGnE32D2JYSeiwgSzgp7hzyNd8IRXtMwM5iCENGQ8/gpXl3uQgkme/LBF/VefLPQ7Fz0FI1j
	OvKcJBj0uWlscFqHg==
X-Google-Smtp-Source: AGHT+IHwryZBOwi4pY3mP3AlWv2m1qjLTICqSszJFxPME1xPMPSqjVVQ1eybCH9Exmfcswu1UpsuwA==
X-Received: by 2002:a05:600c:46cb:b0:477:7a78:3016 with SMTP id 5b1f17b1804b1-47a8f8a7f0fmr227478985e9.8.1766056820337;
        Thu, 18 Dec 2025 03:20:20 -0800 (PST)
Received: from desktop-mu90jgd.home (2a01cb0006769b001185461c960a9b50.ipv6.abo.wanadoo.fr. [2a01:cb00:676:9b00:1185:461c:960a:9b50])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be3a9687dsm12790515e9.3.2025.12.18.03.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 03:20:19 -0800 (PST)
From: klourencodev@gmail.com
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	Kevin Lourenco <klourencodev@gmail.com>
Subject: [PATCH] Correct minor spelling mistake in huge_memory.c.
Date: Thu, 18 Dec 2025 12:20:16 +0100
Message-ID: <20251218112016.9613-1-klourencodev@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5C49D40009
X-Stat-Signature: or5c1n8geoprs4byx9685hqw8byd5c4e
X-HE-Tag: 1766056822-246675
X-HE-Meta: U2FsdGVkX18hszxdrC8+ixuWHLgaGhbA3bsZTSJR6uldDOyJA9Bz5fXe2WBfRQ4GdA4bYFV7VlFOxQSDS48wnwrXODzeUEl/i4xfntDDn8WOAnaHPYOBnbqgw97HEV7uwktbuvrZ+v3gvjLl3awO2B/NfbyFUnL0JIXE9d8ly5mjQFEhqHgrdILqWWp1/ImS2FS0kv+rAgFA3W2k7fdnbsr7pDJ0JNiAOkgs3IdQ1Ntxt/VOBJ0MBKVt+5/XX/7f9IfyMUbTgWijHr/G6wcJsViJnwqoX6+BQIgNU4vF7hrVdg53uAjolx4OFtLOdJ0r/z+ERvFD/3sg1EAKFvRyNarB3ZN2Y5K4gm0H1Qf+crAj4woTGqSN3M9E2u95pMsjerM2GP02sSSeWGYSy065+MJ0IDxvY8RyMsL89Ihw6a+SQisjF862M/u4VQmzT2Z8DGJUBo6LhsMUx2MA5glo8Jb07+ZUneH0xx6k7YwgAyGbWupFKqaOnaJPO22ZaF7P2chQ42IazDhAvlACJvN36rFAau3bzUu02PrU52Njcl6jut+2T4jzgqSeRfs6gpJZgTjTaI0oCSC/TWnaAygxHUYEJ7EUxfy4C7Dvz4WnjC9lW7iWal/KEdbtTgs1C0UPaU9XkIhOf4w56rP5wpu6pmlMY0zoXyH3w0E0WQ+4UJfzgEssM90JoVczMkTNfhv/knmDqGGQeRRHAmSGoi0J8vDR8WyOJzLxxwVJqq56zjUxaraHdrS7vyNjPSHzMsABr4IzHkUUD9t7XGmJwwPYE8WOFHmIz5j0bJrdEPOAj8eimOMvpFdeywPTrCkBLLUpIMX7CVyTFZ5vJGcf5QsOhwx4mGCDbKvcXtSCvawdOLhLnrxgITv6Bicp4Qg5d6RiCfQELUeJA/yEOABU7mnOnKwDPOd0sw6URrZCIqod6P+rP/WSIfDJDb1oY8FZrkblRtaNPVlNOxw/u8jm72W
 7Fsu4xxD
 /S6wrZRvtAfmwpYRadGWSPB/TnwSno7aqmfe+sEWGOHRjin94BRMDzyB79TRaTvtPHxo3rSfDBqumUIx8exVre3yoIoAJDHKzgrZr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kevin Lourenco <klourencodev@gmail.com>

No functional changes.

Signed-off-by: Kevin Lourenco <klourencodev@gmail.com>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 40cf59301c21..5efd2cf4f073 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3220,7 +3220,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 				swp_entry = make_readable_device_private_entry(
 							page_to_pfn(page + i));
 			/*
-			 * Young and dirty bits are not progated via swp_entry
+			 * Young and dirty bits are not propagated via swp_entry
 			 */
 			entry = swp_entry_to_pte(swp_entry);
 			if (soft_dirty)
-- 
2.47.3


