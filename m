Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0B88CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 04:50:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEECE8E0003; Mon, 20 Oct 2025 00:50:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9F4C8E0002; Mon, 20 Oct 2025 00:50:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB52E8E0003; Mon, 20 Oct 2025 00:50:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9ADDB8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 00:50:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0AE8788937
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 04:50:07 +0000 (UTC)
X-FDA: 84017265654.13.9BE0450
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf04.hostedemail.com (Postfix) with ESMTP id 246F44000B
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 04:50:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KZYeGaPK;
	spf=pass (imf04.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760935805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5yrib05gMjW351Vqcc315s4iU/oaqX4kqgiXM4x8fb8=;
	b=JHsrB3Xgb47paetOmmZJtnHLiNdymy01s+ciuM7tHhDRJCrnXp/Iq3EH2D9vW2dIjpCzL0
	9lPfIdrLDTMHrVi9YoM3tZMX51M1H//UD9Y5hCTn3/uw1zMTyRPNVclBELvsZ/LIJMg7Xx
	1DSAE9l1RITrucoYsg8grpSLOoNVUwk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KZYeGaPK;
	spf=pass (imf04.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760935805; a=rsa-sha256;
	cv=none;
	b=dmu4S9m425TWJhAgDJmwytpBfSiyA2us2zh42ZhSkKh/c9rC0FEvd1gf6EEleGVjnnMIFB
	WMahFpuAP3PxYhgQ285rmEPG/W9ZGpNLtIFgoZRRV0mSsDDjZFA8PfSOaE0LCMVkEW2S6w
	XqlISK/dikocmsNxtFS6A8umx88qUvU=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-78af3fe5b17so3170536b3a.2
        for <linux-mm@kvack.org>; Sun, 19 Oct 2025 21:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760935804; x=1761540604; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5yrib05gMjW351Vqcc315s4iU/oaqX4kqgiXM4x8fb8=;
        b=KZYeGaPKChOItXHFqlZF6TrQD3EHD+3AKUZvr8HvTLXlveuCGvGYsRG5iAl4AUVG7A
         DXDBhnzpaFvfEUuaSSTkDOL/f3S7jDssizr2gHWnYMuryT1BMdK+vWHgVcUAEct7CBrU
         Bkku66YiYs9aGuA/dxcs7ZvjbSOIpSgaeefEbSycq1bQ+UFOQnu0HUmcTUDlMZzmXMuH
         f1Q0eo9DSXtw20f+JuRPaXf33buaeseDi2yjh/EIxnSfnxNfOIm9HHT3pO5gjrR6i8ka
         BS8R+SHh0GTOgWanifmdD3R4x3G1prTPUPMvnNt+fn4MSipw17nuFjcEgISCXT9GJHyG
         5Zsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760935804; x=1761540604;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5yrib05gMjW351Vqcc315s4iU/oaqX4kqgiXM4x8fb8=;
        b=WouJB9KzX1e+6wHdsJ7gujHUCMLSgkNraNhBXI3zrif4UK81o4QyUsroh01a9LMncA
         kyODpmPJHiEBffPZbsVHoA+GGUFEYlPuAUWYx1QX8P2/mUSEHhrwIgbfnDcvNixgIhVg
         RT7vPodrk7GJZ9hJ5tVpR4AGLyDvSaUggRqyjyTMtcmv+1XAGl6/WEnMwJvAFr+YxavS
         dyxYCsrNfR9PLx/Ov9Psk+YB/mKWj+RkjA+nPmevbrVsm8PJEr2CAp2IOqmLTjKwordA
         F/kQb87em5YwMKBLTmAuLv5dNU451qt/J59qUXzRzuC62ASykwUN4P+rSXFpdQMwb7ZJ
         oQkg==
X-Forwarded-Encrypted: i=1; AJvYcCVE7BPBB7pmCsCkw0+hFERwlCBmmLKAg68tyW6QoP+oatLyPkhLNn+nfQKGKJ5R4HmIUjhK4v25fQ==@kvack.org
X-Gm-Message-State: AOJu0Yyn0/3YEwd+HRMy4yJjIc/cMc2zNQEOgvIlF2bxrq2mGldroY2z
	tjpxdhZwB/Rr1qA4QEzr/F0nnHwhIb3sry94DGl/q45OetRU8JLF3bbB
X-Gm-Gg: ASbGnctBLqW+X0gGDrYBfUKP2sG3eMlCxveQol6cCC8PcgTdfl1xdD5GQdrjTJqDe0l
	LhVPsTbyifQjT03WVL8eUkKLhq2U2/JzdbY4UCSvTzaBjBgIN0bw/OjS+r06327aQ8FuR6KFX76
	OvgBq7EhjKd8D7XVLQNXxovVLdNIGTZ+DPCGISAPT3yPbrr1RRc+EZ4SZ4arjFqqMc/4VXyGMkM
	eho2O+PJnmWvl6ktbxc74TBYhKxLnhGzIcFFUFF0EEsC7+q3xaudGouGsCtBTnZXp37MOdVUMF0
	BE0daCYoljsCK5kuXv0ydTGXKNA8ShEg4XoF0kbZ/+cPzRuXRVZqcur6ThR/EWNWkhBydJWpa8W
	3A3WRuOg00LnzC2aYhuHebW6mZCKwQ1eFrdid67e1WlkOZ1Lbs2onulcrE7ITYyRq3jCdXufdAL
	NdtSdJBIGHozWX4A==
X-Google-Smtp-Source: AGHT+IF61t4CBl41HaeKPrbb13q/MIse+rZVhP7zh+kIUADNetjtDhSymCvedTsDdoF1wGwNjkcrQg==
X-Received: by 2002:a05:6a20:7344:b0:309:48d8:cf0a with SMTP id adf61e73a8af0-334a8649ed5mr16272776637.54.1760935803784;
        Sun, 19 Oct 2025 21:50:03 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a76b36188sm6681007a12.27.2025.10.19.21.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Oct 2025 21:50:03 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 0156D4209E4C; Mon, 20 Oct 2025 11:50:00 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH mm-unstable] vmalloc: Separate gfp_mask adjunctive parentheses in __vmalloc_node_noprof() kernel-doc comment
Date: Mon, 20 Oct 2025 11:49:33 +0700
Message-ID: <20251020044933.15222-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.1.dirty
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1344; i=bagasdotme@gmail.com; h=from:subject; bh=im8TptqOKTACThJRbjpoq/Ap97qCFdNDCLeY9N2Fplo=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBlf973ivbO37Y7K7W/dR9LuWDZov/Zv327AV56n3J47p cx3rdTpjlIWBjEuBlkxRZZJiXxNp3cZiVxoX+sIM4eVCWQIAxenAEzkVyvD/9CJsq277tqHZDy8 svey9H3GApFU7cgZD+56zHV6sDaaIYHhn/KrW/naqf6T2jc/ebL0/ZHuygdSN1Q4PXv3h1+P4vW 14wQA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p5nzkjgw11komw1jmegrj5cndr58datt
X-Rspamd-Queue-Id: 246F44000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760935804-536697
X-HE-Meta: U2FsdGVkX19tuWhSQ+EB3Do0rWW8aXFfSgBD1SRyD4KNxsgbBAB9FArDdrBq7I5ZGyzTZ+IWmWWnCnAC3Td3hEKXGBsxrzZvffkH7z0cHXPL0rf2i71f6uI03YoG/8nm/E1gikzTvHHl0lF49IKIJpaB2HY2W2BKLHOv4+NKYNvbnR7SZmUO41352eXbkB3K4ZekJyIQ6XeesNvtDm/iK9j5TcjNGnbJDSCN895zKrCu8F9vyExbx2kG8l5+JWXYNHKI/yiHW/EuK90bmQbjKg+GVuhXAEq7cxuZvjBckOVm+m15K++fIaqOdrh/l2yAL5Lb/ksddgdM3bVN4dNxPSHYxYhzA0YJIlzWH0Pg9Mdi4aZAlr34EAAg9S24+uK+qCMKvjFXZBeJ14Iq/YYQQXE7ldUKfjO4M+vbKQUlPWPPpcHeLpSUsykKQN0SlrXWq2Qyi9eEnmeiCsqKG4Zb+ijx0A612qmBd77UdakxFpSynl/TV9x/FMd4ZKfVlrMyVIo9WnlP9+3GWoch/3W84FQtiyCN8AA0ZD3LoQr/ZQzmFrkuulX9kYsj04Uqo6mPYbb76vy31qQS/akinNFSsVOEHqYTOIavxT9qMftvwD2eadRb91n7viVgey3SlpX2Izx38sJV3w/0d+hTmcnPUXPphsfNB2t/pYxLsnp4OfEvkTXqa5zAZEEKx6Ck3mQ604P3MGRqH+MaJlaLrs2EEIwtew7Sdr/xf/xNUlSTO/NhTRztVzvYMtOHX50kGlLWFTT+DYnjv/9Z5O0x+DQrL1wjKytzX2nnInaOp6qouL1liqqm/IbX5vIaSBX7+0CVJaczmPxMs1v9IkuWWHJIY1BtLuwrCCYAbpy4eaDO4hs8imuiU5cMQAyvNolRGs3hCB6pmrpQW0wT7dSkVYkv3IefX695pp9DNCg58s+d56te47mNy6w7GBZOdPxLE9ipnw4F8mx3rRF3lfBg5kl
 KTxbebmY
 cWhBqyZEXPR8ziNRVZSg4tOtTE09mtJMvhNmG9jbDCXjML8AS3K6pcf9TkJ5A8AqYoYvtyowxTl6iUO5CnbJ1lcG6zR5iZ6jM3yfTxqETGFwUm1izQ/s7rTfOEczRY25U+nXFiD4iSjrJScsdZt7JWn6qyxY47/hO9+Jn80R71M+AvYyHMt7FdNOTNM4IvNxmmvo9ZOHsDOHt2zES9B5w/P+afi/FCBTGPDI8t00KacPxZqhgms4/OzVlPwkGbzKx2KajIULErn+SUCTqDH+mKSydf+7wZkcHMfXv6mw3iSOG2qOA+YmMb81goUXCufCpiq8qToIxcn6Kkt0itYw6kh3n/pVa09jofJVtkgBi31sw7g4NT1Ud+9+GEBGQw3Z4Z9emDFlPz0EvPFCm7VR7FBFMCP6kq+R2KJ8HeQJCeJRvcm/NpYRW9/qlhHCEJ7A4jbBQCIcSsoWyGox/1cBnlHmR51c+5PiM1Wkt62I2H+vs83TOUFKtyLogdc15c3ndMRzOoShbl6fTwsfmwPb1c5wnKUNtL1qALQy7Ly0nV7bq4RL3A2I2r3NGW9zNFvcg/NCKAJ3X6UH300ntcweXsX/ejz5Ho9g5h0L3o5fQ2eeH4QsMrA0Fq8rDzg7bqrZ2YirZRM5SFogOUZEszsgMPk/aCaO7C7rm8+XO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sphinx reports htmldocs warning on __vmalloc_node() comment:

Documentation/core-api/mm-api:52: ./mm/vmalloc.c:4036: WARNING: Inline strong start-string without end-string. [docutils]

Fix it by separating adjunctive parentheses from preceding gfp_mask
formatting markup.

Fixes: 32904ba6f5ef ("vmalloc: update __vmalloc_node_noprof() documentation")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/linux-next/20251020134902.3a11107e@canb.auug.org.au/
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 mm/vmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index e207ca64a688ee..091a07f6d92524 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4034,7 +4034,7 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
  * Allocate enough pages to cover @size from the page level allocator with
  * @gfp_mask flags.  Map them into contiguous kernel virtual space.
  *
- * Semantics of @gfp_mask(including reclaim/retry modifiers such as
+ * Semantics of @gfp_mask (including reclaim/retry modifiers such as
  * __GFP_NOFAIL) are the same as in __vmalloc_node_range_noprof().
  *
  * Return: pointer to the allocated memory or %NULL on error
-- 
An old man doll... just what I always wanted! - Clara


