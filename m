Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EE6ED3B9A9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 05:47:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 806EE6B0006; Wed, 10 Dec 2025 00:47:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B7B86B0007; Wed, 10 Dec 2025 00:47:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CDB76B0008; Wed, 10 Dec 2025 00:47:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5C68C6B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 00:47:30 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0B8C012F2F
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 05:47:30 +0000 (UTC)
X-FDA: 84202479060.29.B4F10D5
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3CA93180003
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 05:47:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ca+QVZTW;
	spf=pass (imf24.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765345648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZjPKi0vMLz/w6qpgbXNP/kuhIoVt0nM5db2+kyo0mvU=;
	b=mdnq1BBtoLmV17g8IMlnHiJKDrIcq2gNg40EUoJGqH66kXgWC/VhYN0ZBbf1MgIPAiW0cd
	P9EZIJTydrEsuPYIXtH39UjEou+BSTMUCI81GzaCAjvCPp4POrwhg5rEj3Iuhsy1MfafkA
	DHpWqPfAcApwqq67guUv20qR0X6jSe0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ca+QVZTW;
	spf=pass (imf24.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765345648; a=rsa-sha256;
	cv=none;
	b=1B47lafxu8aaVTCXLdc9MkoCDggng/En0ke3djTLPeg7cMHx4eRPt5u5AOfdemtk+/YrsL
	bfi8+WP0C0AULBRPyALvS3Wdc1CeqZnab2y6A+mYsW2B6s0JYFDqztCqWntfdO9FQrJM/I
	wi/OLQLYzLF3Zvg0aGzQkvE/kXGvPUA=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7b8e49d8b35so7958116b3a.3
        for <linux-mm@kvack.org>; Tue, 09 Dec 2025 21:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765345647; x=1765950447; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZjPKi0vMLz/w6qpgbXNP/kuhIoVt0nM5db2+kyo0mvU=;
        b=ca+QVZTWCTOyvlxdt4txXWxarCfUQ4AKAJH7/dpuSYK0ndoJz3K9Bx8jklOCEWN4CM
         1OPEPrmmYC5yJBgKIcbWGYlj6P/yL5/EU2O1Xmym2/3ZmYaRtfJemazRseWZMqmt6j5H
         0vf7SA3yZ0DAWYYHyjqv+I+VAe6He1vYHk4Ge2LyoF0ui4chlxz4w21eRKVLU2s3k7kM
         wnd8hW6NwaMa6z+E2cV5VeLnOeveY8Ikxg3qrjHC9Ca3we1v9g/O3359aQvFYKjMszAM
         LooyFRhSSsJftZ188lKQq12mQaAXDXEY9ELi2Nei9IiU2B6vP6SDh0zOcMGQRxrn0UEc
         Vi7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765345647; x=1765950447;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZjPKi0vMLz/w6qpgbXNP/kuhIoVt0nM5db2+kyo0mvU=;
        b=V0BWYfKnZlWVaixu4OLP/H7MNVaOS4z670PKjxYIA0q45fHiIoA2ihoir7Fpe10EQc
         jvEV55iqdRJ8UyCdB0U5EF6087dy18LKiU+lWPNr+XUEN9aoe4W72JMqZZR+0Fv2qqK3
         7AhenSy6XpVoJBVvVRfZEp65UMPesolhNovj1KX+yRFKzOiD3Q12UDNkkc1Id5mEcZZ/
         T32Hq+s5olgNmIIFWZMXJUMvLvojWvwgvpoBdS8p2A8pMqT78x4G675tHEoTadt4FGVw
         6FmfZF3bcnOp4hBdX+1hehzNvIMcN4xStJCRRz2iwhFOgshmmYV7TMrpL08jtFZBnd8l
         hveA==
X-Forwarded-Encrypted: i=1; AJvYcCXTaj16Ec2OSmqrMjcOqnslX4L9Qr/Vkk6tXLHiJyIqcdxHdv/DIRcOotZF9XAyCiyq14azu5D33w==@kvack.org
X-Gm-Message-State: AOJu0YzVw7NS+cfxiQuSkHmgesRnLrNjn0B6g1cViczLqf1praGW9lQ7
	l2bWcgB2AIef6lAKqJVGMeAZGsLywvjqLnrTW+T8xjlqrAq7d8q3dAns
X-Gm-Gg: ASbGnctMA9J3CKu8PV1DPWbFu0bYBDwGO3fBnT+F0lCLerOm615aqKgyTxSY0/Ok+RY
	Q3z+hZULfnGV2WnMwWfWjnvPPsNdACc3rOw17dz80ozzEhoSiIJ7wztm8qv4s7xE/+rULP4ClV+
	BU5+C6HZfaGBgeDNEs72MtFqregHIhW4l2c9fSGYSQBSEkv3FmKJxtfPpW6snsO6mYVvSxO2/mx
	WbS0cpxE31jwVHN/QVuGEMAaLyKm9X/emFrX5DAdkuVi+MfuvcrSlnUbVoIlQcHka734RpzoNpm
	p497ox1CWiD685iRmIoCHjtSYZ3Bc8gDVcRE3R/DOITHihKpu9iq8SA84CsXOCS5MziD0wbwvfC
	gHrmhCHlYyRk4gGWz/LHIOccsLaIaYz/dLXdEUfS6a5CCzuEzYOH3q8qOhqGvqBdwZl5sos4cSj
	8P4otNwEUxV1AbTQSzapQPmq8Hovw6jw==
X-Google-Smtp-Source: AGHT+IEwc7JOsazcwKpzU7ZHBl+xfNwWtdPzPxJDIDg8Q6HfKB4pbwai0Nw0QrSKvHi5o+uJJlmImg==
X-Received: by 2002:a05:6a00:cd2:b0:7f0:2d21:878e with SMTP id d2e1a72fcca58-7f22e0a14admr1193730b3a.25.1765345647036;
        Tue, 09 Dec 2025 21:47:27 -0800 (PST)
Received: from LilGuy ([2409:40c2:1295:13e8:41e8:60cd:6181:4fad])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-7e29f3e52c8sm17808011b3a.10.2025.12.09.21.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 21:47:26 -0800 (PST)
From: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev (open list:DAMON),
	linux-mm@kvack.org (open list:DAMON),
	linux-kernel@vger.kernel.org (open list)
Cc: skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Subject: [PATCH] mm/damon/sysfs: check for online node in target_nid_store
Date: Wed, 10 Dec 2025 11:17:07 +0000
Message-ID: <20251210111708.46959-1-swarajgaikwad1925@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pwxeiboo9esoseq5y6hor4haidoq7sut
X-Rspamd-Queue-Id: 3CA93180003
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765345648-949743
X-HE-Meta: U2FsdGVkX1+2p5rHLjx/bV8d6IpnzijJjRQW88Zf+beyju/lEnpv8okcUOQI2a3CoHg1NGGrPP+buIK97vZK9m4+50Q/WbTWOqTTFkmFp5ko4Dvf08RuKUMyrANmuICwZGb4DvORTVxOupAMMAcfPk5ZwZZF82AFX91IRys8+FiMh3WGJx4fY5loIL/1DAceOf7KbKvvVz8FOWb++f5An23W1kYzgMXsKUfj6MH+V7+OBjDwkB/+cJjLyX6kH9m2soTwxcTg4oFayplANPVZyhmm63p2jnCfDUHz1o0NSCsuhSqQxecab2AXXi4rKDsjwkZCz7ss5I9Ju9RrWfRBkkCLRB6KCBoPS55KBlDc3EyxCf7I1r1zzNv9GTLnRBcjHCfNSpJGm7dDWyzoe5Un1k3wzphrb02E3ig+grJ3CAKFds0MD+PHlaAKE6utpTMLgApQqjUPbpyrMSJ6mHx4L2QWNDDX4P0Hl/RHveAWi0q9D4Hx2fqZHt7HwPAVJNFso8jBzU/ongvpB0cuySAlK0AeFUedO8L36IBgS8IrvVciifvhC2yg6fRanR1ZLGRqZllFMElqg9DwlowhmtUh1DS2OPqTYnEmIPRK67l2YUPr296hgj1g1y80BGa1lng0MXubmz8fRfLOPDbOuZAgMIWj3x+ENgyRHA3FtohzqL4Jtcumn3hfVJEYMYRXi1krYQjiVMTiGtl14UE+jkytxJDF3N6rraka94BaWu2jVw2/gsCKL7leO8SD6D/HldPDpVJAJ4sXOpB83RlmufmKDI+TL9TPiyynW73UavqE5SGFCsgFzldS6apQSy9jSY4/iCj9ynSaprgMuySrAcgp3/A+wbsedQG7tww4F87NwetGH9hZyqBrcGieRoUbU9Xd1wkmwst60k5mY0HJxsyJ8qxOIsgjK8D60ClJxK9zOLigXGuh8k2ulWzI/XeFa1If1+aCl5WlJrvqEOFQaRh
 s1OtkSXg
 dQNsDJ+iUpS8Hp1HcFYRV5LCY/MyHVJ8X+tyA5oFIPT8SkLruSRWAhqejqlzKozVn81SCX1kR57mHRrrVP4IhzuHbBlgwaGgsva8PffjYyp5veW53yytl32fkyOZnrb2ulL0kTu+0JA3VfgS+zvb/rYXq759abgvDpOuogsYc+yCAZHYU7vgXAFYvVVGKtyUFKOn0AotIRCeP5T5m24YED5CeuNvbhnSebd+/FVadqynyaarlpRtA5H5JzeKtC4fDKkj2AUEMPiLHTPwy2Ekxwuyax/YW0SMH8uhywNzuJZAELLKwSfLN/jr9jy5itvroGrkSrYKuGGq3DufmeBRlNVpEfDQRgVCjoHMoQnavjW3BkI9TQZ6P1+Mpqxea1r9uK9UO8+yBgSrfT0zgi1SaVDTMXbhhMVxQAQroP2UW5weFdKKw2ZDyXYPoLKYH6lmKAZTwDzF5kOpHLBsw1wIGNb5TuZxP9PyYGlBg2/MRhxoGnxPoaOHygbNVA3zvJKfl+MQ3F/7D8tA69XQ0ozyVBGiKhLEQ1LIIegtMsA9pDH13BSU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The 'target_nid_store' function previously accepted any integer value
written to the 'target_nid' sysfs file without validation. This allowed
users to set invalid Node IDs (e.g., -1 or 9999).

This patch adds a check using 'node_online(nid)' to ensure the input
is a valid, online node. If the node is invalid, it returns
-EINVAL. This change also resolves the TODO comment "error handling
for target_nid range".

Test:
Built kernel successfully with CONFIG_DAMON_SYSFS=y. Verified the fix
using a bash script that first creates a DAMON scheme, resets
'target_nid' to a valid value (0), and then attempts to write
invalid values (9999 and -1).

Confirmed that writing 9999 and -1 previously succeeded (incorrectly),
but now fail by rejecting the write and retaining the valid value (0)
as expected.

Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
---
 mm/damon/sysfs-schemes.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 6536f16006c9..b18321e64423 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2244,11 +2244,18 @@ static ssize_t target_nid_store(struct kobject *kobj,
 	struct damon_sysfs_scheme *scheme = container_of(kobj,
 			struct damon_sysfs_scheme, kobj);
 	int err = 0;
+	int nid;

-	/* TODO: error handling for target_nid range. */
-	err = kstrtoint(buf, 0, &scheme->target_nid);
+	err = kstrtoint(buf, 0, &nid);
+	if (err)
+		return err;

-	return err ? err : count;
+	if (!node_online(nid))
+		return -EINVAL;
+
+	scheme->target_nid = nid;
+
+	return count;
 }

 static void damon_sysfs_scheme_release(struct kobject *kobj)

base-commit: e9a6fb0bcdd7609be6969112f3fbfcce3b1d4a7c
--
2.52.0


