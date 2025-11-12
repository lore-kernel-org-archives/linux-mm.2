Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6215CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 02:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05D028E0007; Tue, 11 Nov 2025 21:00:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 034C58E0003; Tue, 11 Nov 2025 21:00:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8C738E0007; Tue, 11 Nov 2025 21:00:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D10908E0003
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 21:00:41 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 74B7A1402DD
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:00:41 +0000 (UTC)
X-FDA: 84100301082.12.4202021
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf13.hostedemail.com (Postfix) with ESMTP id C8DF720014
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:00:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cjqeAGmM;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762912839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=iUK9slEDktZYgXNEXqA3TGoJ4r8MnqYkr4EAB/HuO4I=;
	b=5iZj1g3T0Qk9fbNLga+HXmFQucrKJwy5qLDvlnSa/sSILwG+MJrfOFC4+dr7CCaVXNNfLI
	r5evYWG+a1d5o6F4psX7gQIEAEz1vxtahNYdPoYTNJ2Q8yaKwqcLDO066GpROLNCWIgjCY
	Jv9/XoT6522IDJcxwvr1AeRExJyvBa8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762912839; a=rsa-sha256;
	cv=none;
	b=NY0o3blFA121mZe4BNnlLD9QK3ieA/OjeYbjYnsRZ479Of428OZelq8f9EcjaICOEYJy9R
	ev1OF2VVaDLB2lQsrFCVqAHzmWXBfWShahTISjVCJe5m3aaV+90qW+j5BuLX6bd0YAf66X
	S3yKRIQChaa8ms9cXdRGdPGrfFUuq90=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cjqeAGmM;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b72134a5125so57353666b.0
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:00:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762912838; x=1763517638; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iUK9slEDktZYgXNEXqA3TGoJ4r8MnqYkr4EAB/HuO4I=;
        b=cjqeAGmMAJJTfHo6JhzXueZdDrRpV1q7rslsLAU/iLE2G/xE0O8ev/ymxd5Z03EaBh
         IyJ8LD9NmUq3Krs2VsD60vBoBflRla/Ukl9a5o/inA6+lSg36hHixR+xtnQJzi9Q/lGc
         6Xb0nNTtJ5RZUKo9ueyZXNxEbXA+pv5TPNWzb+Gzf8RYShEbguQq5DrWGq0/X1JKZhOK
         ZtPJBi2Ocdl7DWU8ePC2WrMui8pc90PhXV+h0wZgEFoePDBBfrHEkVMuedLM+38y7sOf
         UmGEG/S2WgOUtzK78LpWqVGNbMYE/Bb/woZpXGmvMvijf9oZdUstQpcLncGOOT2FUtQo
         FLSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762912838; x=1763517638;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iUK9slEDktZYgXNEXqA3TGoJ4r8MnqYkr4EAB/HuO4I=;
        b=BlumMNV91hGEjds9q4U+RZIAxkegh/7m2aRB0x5l2GkDtBpT+TpXJT7qNLmn4+aeTS
         OhgdKK1rXqzUA+PcrO7rrvijqkIXHnvDiETP0oVQWY0h9W6S3gbDGaHaaGXfNtY5I3s9
         iY0NY8EUlnmi59YjlJBSIMrR4hvS4hJqa6q+fPaqAks3QklCqUFbPl7ceTRkibb8uZ30
         ei+luwUCeX0GgRSIF0MZhZwz/SrPLaCXrBRdpCaogSQkwyXSIJ60v+1gR4/4A8rUhNzN
         fXBmQfMcdMqMC+HD3ML9TTIblG+/O5Z4ev+oAVldWpY3YN8k3Oemy9gkO7iUqO6b6qLT
         u7TQ==
X-Gm-Message-State: AOJu0YxFp8cYmSfaup2t2So99QG4pWXAq9mMMqN0088iTENg8nY49IZL
	rTciV3i+zwsxt4FTI8fC3a0Q7T+4lv+nm7XlBqlkG8bUeIE+/2pazV7b
X-Gm-Gg: ASbGnctVuy/lxpbVh2pGE0Bwft/fWNFaYWKxGJSor7iye+wPzRJGxRDYcbubvCuHUd9
	AIPdJqS2v0ZK1qE6yy6f88fCPVO14wcN2cN7xXV0vZMOHynQNOVPU+2xjtV1cZalLNEtspNcIH0
	LPgPr8nWFiUdhkztd0+QLFDitAORGdjaF4/C3fuhzJs8y/zwtflFi83bc9RL+lb7NZrg3TcNS/D
	JcsGiGa3WGPSTPawDaMNlvvhPrh70Lte+j5CHLBbovrDTRdZ3Ew9Ng+0pqB45gPwbhcrDOfkQUh
	WJ8NBb9BeXYYRWpgYgJOHsH8HjnmjHiwIPEup85/5672cLXGVJC2Ic+S5rLR+4efNUHlkuknF4H
	02a7PYRJIWZvj5EksaSaEzwG/tNNBQ1WmROF2iUKPYB0vXHPe3v31fHzMO7eslZl5PmGR5yU5oQ
	ipCK6I5jWochWmkw==
X-Google-Smtp-Source: AGHT+IFTFwMldvhG+0xBGnMSROt2guV9IQraoVk7NXSiRsy6N3Pv2nwdrN6Hej9qVVEBDhKX7xd4aw==
X-Received: by 2002:a17:906:c109:b0:b4e:f7cc:72f1 with SMTP id a640c23a62f3a-b733197e9a2mr123822666b.22.1762912838121;
        Tue, 11 Nov 2025 18:00:38 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bf9bcd59sm1457896466b.53.2025.11.11.18.00.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 11 Nov 2025 18:00:37 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH] mm/khugepaged: continue to collapse on SCAN_PMD_NONE
Date: Wed, 12 Nov 2025 02:00:31 +0000
Message-Id: <20251112020031.25350-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C8DF720014
X-Stat-Signature: 5wm5bmh5b9wkh4pbcuhusxnrzebchi4k
X-Rspam-User: 
X-HE-Tag: 1762912839-598266
X-HE-Meta: U2FsdGVkX1+GCdaljy/KBNBa6XB6fy7l4SAG1vCEJd7oiJSldMWGAW4wDPspc+4bgk570eqMEiYaDu4/BH3rEznqTOfxV0b1k8R+nmEW/Y1rkj/tuY24tZ4+jYV/75EISpPiVtdaLhLdwZX9FJuUituaHASr6LZGHnLZIHEe+EAMx6Ycnwl4TRcLWOwrpm7H3M/F5hWbzR9icepSHHAVqQcEhkxD9krCnQIWvo+4VLJEoEcVUVRwVG5tPJlV7nvJEtbpTB2GeDe7z6fhr17XbxMOMhgFN7BkazH7z46lG2ZOtj5Jgk+Xz3WKLpHPIyYgxmPCafkz9CPFMLcMozf/hSCE1DmXMoHmVLiYT/Dpu50TqZNKTtc0IMwEyPhnhCAGcXl7W6kAVcL+O9rmnaEGv9c+QMy/wawQSmVqQMESxGoU3zWJZyDGPozsOW0llfl37Ua7ZANXSB5oblJm4sWvGGY0cGkUj1EWhi+KTLj2Pl+hr+CqI6cfQO+q7s/IXPlcuDkS96ZJnKKygwJ3Jg2H4TnHuFVrpTv9esoz8QQMaH6w6YVshYYTGah2WMGGjwP8xF4uJMCKt92pD+WDDNPaiUEfYoRny0Ph6t2r9HfITUaK3FZDHOL1Gcqp829UzPVRaxX8xMVrkOvrc4nsA6tQ7LoNCUJXCc4HHOrGX6DVcMgS/+zZrB8TNtfM//l3FCSYXQ/r0vWDxZbmIaP8QfwZ/iTDf4hpw1attj4l2oancwCZ8uz6HKI5yrPZoA3OcjzPmZBFjSKrM7WwJX4iy/N6OMqocmwJGJ6w12vV9jdS4xec1ggmKem0dBp7ysr6gdScwhyWdncsyRocivM3uytsHgkbgp/B4HqUhmBy9rOfHF8oagSxLXd/pzXqpJG2hnfMAMiktLZGw8esUuwOAC/mvMw8viQWeylV9ZivCJm+JgIkqSIvr0cE77+ZsrJX4TgAJ8bqYL/PPO/KkJelVkx
 65UIdeKH
 P+7BWsyr+HbRsITjc++qaZrRKnY8JRS69KMSMti1Sgyq9u7cc3vcqh0DSMtzOAP6+Z2YCVj1eUHnuhV3dYruBwa95e6ML/n8lZxr5Usmso62dqNjo73XCW0tKfFSypxcudE4dsxu/ulCdxhweOkSyOiFjFH9IqBJ6Rn74F87RRWs9LXVy+U/7hwnqgkLFbWCA8iYJ4VV3dlFdwwnKPq5e6D4bE3P7Qhyz7zvBsEkiVAptkBfrHb0fjRszMzgIcw/UB1P04kDxqftc2FLfCkVI1z3xFM8NIr2ke3n+ZSsgen/vA9la47ruKcQ+xLmwzem7U3rs1MAGMXovvCzqZ4WodYQSJMLpP3V3Obtof6r3dOD0Dp8l6qfrlSjeSz0MvQwcLWYCC+VU9upLJQmniOINa4/sVfNkcFCP9cRIm33N9Eu8UGPrHFo/lezanxD+KoB2tj1RGOjs44dFWzA7gTzgM0mHRls5lsf7MMrV2jUd8KPePAGLrcHnRgE80LOOhlO3sYJX3sFnGoYXo45LKfJ4ED47zeKnE6COCh2Fj8SJSVut+i8LcXIbLGtP2aQxWMG0AmFcUzKsZhnPsyExFCpHIx02QjS2namjctOc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SCAN_PMD_NONE means current pmd is empty, but we can still continue
collapse next pmd range.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
---
 mm/khugepaged.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 7e8cb181d5bd..4c2217076ad3 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2835,6 +2835,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			goto handle_result;
 		/* Whitelisted set of results where continuing OK */
 		case SCAN_PMD_NULL:
+		case SCAN_PMD_NONE:
 		case SCAN_PTE_NON_PRESENT:
 		case SCAN_PTE_UFFD_WP:
 		case SCAN_LACK_REFERENCED_PAGE:
-- 
2.34.1


