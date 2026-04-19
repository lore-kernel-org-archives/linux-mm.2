Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1A00EA7188
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 04:11:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DE206B02F4; Sun, 19 Apr 2026 00:11:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F44D6B02F6; Sun, 19 Apr 2026 00:11:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BC566B02F7; Sun, 19 Apr 2026 00:11:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E78406B02F4
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 00:11:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A715E14068F
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 04:11:58 +0000 (UTC)
X-FDA: 84673982316.27.F2DC279
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf16.hostedemail.com (Postfix) with ESMTP id AD129180005
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 04:11:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Bw8vj30g;
	spf=pass (imf16.hostedemail.com: domain of thecharlesjenkins@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=thecharlesjenkins@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776571916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/hH3x1N0+NvSvzMccwee+vm7y2aHZ5XliR6CKhRwp+o=;
	b=qqkQ5sNUCgQt4cTtjkVSzuGc8UPzLh/ePEdMuU5fMSzGxcD5Xg3r1ZMa258C11OByz/yGo
	f0WuBe5KDtiPEOyX5PK/UUn88rcsjZSsRijNhFCFkfe3aolEcA1hO7Hd/Kn4PvQPro/WeE
	KFr8Gugb5JlvzDUDs+8VGgk2ibXUf70=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Bw8vj30g;
	spf=pass (imf16.hostedemail.com: domain of thecharlesjenkins@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=thecharlesjenkins@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776571916; a=rsa-sha256;
	cv=none;
	b=2HYtSR98tYYycYKitOzNds+Qgp2b7ImunjIT6Iq73hLKryhdk4kFNA5BEMB5Wifx8Jyoao
	Jhg6lxeCopF5pger9y8/ndLcwyqy+tyDIoWe7BgDWCuyygqJkuDntk6HE2cgjz8irxe9Hv
	ycJL0o+jsBGXlSOIXIY+uM3NLBElwdY=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8d6d5e45c43so248550185a.3
        for <linux-mm@kvack.org>; Sat, 18 Apr 2026 21:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776571916; x=1777176716; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/hH3x1N0+NvSvzMccwee+vm7y2aHZ5XliR6CKhRwp+o=;
        b=Bw8vj30gAFeQkdFRszTOlawlcrWsH0RM0mxNqOqKVcIuZBIG7jMbiDb5zX+BBivKOD
         QUXjou4+5px2DyFiNynTm6rb0OtrW08kSujEtvViLYl/5spjqz+RoODVuDj7LFwTikpw
         dF0P/MQkzddNtUReiNXmbBMFf8JiLfQJhWikBpDGAxpWyQkrCNfp1tr4jMoE1Ob4nN7h
         jSYuV3ZeaT2eMKQE0k9kruAlgkkVQQVVO7oe/4Bsait6lHivuHF6LgLu98HjW1w8tzzT
         AegC6gbaZk+F0JJQQn7pPWpOZgYFIHTF5KbRi2Nwfn/tlcs2inzlyhV/Mk3NXYRkSfhL
         VSpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776571916; x=1777176716;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/hH3x1N0+NvSvzMccwee+vm7y2aHZ5XliR6CKhRwp+o=;
        b=MTtqm2K2lAewseALbMNWVZHsPksLhw4nmbolxyLh3e3XunjoPFUDN2TXg3QET1GY3k
         uTT01wCLSDE58EZOBbY/D30tqgA/J9kaqopZujjJmH5h5Y4WIp5DtVcaH3YYynkt+gti
         eNAm0j66aDLIk+ofl06Ay/6uy8jff+djWuCgGULe2g3GiD8Oq7b7anKgbwymkLzu8B4n
         JujYKU3YGiqGX/iZ348b8Dst7xgw0+FlGgeO30MsNA9PrnJJaJLMU3xkIMCKMXgRuqyq
         AY/mC+yTFeLozTgxLDYC6KKNo6T81St+n1gVIPtxbW1ZSPNzVGKcUjvluEDuYPa0P3YX
         BU1w==
X-Forwarded-Encrypted: i=1; AFNElJ81YEbSUtoHwSpdFhScinZgynRcv47+2iSMGvSNGD0e5rdqIwBsLdtnUjT/PjeNRQH8mcBDm8ZY/g==@kvack.org
X-Gm-Message-State: AOJu0Yxn23xTh7GwSGdgLl5Hz/1dOm4gUGHOSYYkNmQQvTErzxsUPjqn
	2kOFl1HanrS/mOFebS1KHuusirNLI7kT4Sv2LsQkhcH2mSDH0qV8Ak1t
X-Gm-Gg: AeBDiev76vXy5hYz8PShYR4RAk/67SS278VMU0LHWPs/IoZs1YwQSkC1iNww3cAncwd
	1KpsneSF5dP0PVLexJpTohq9L7xd5mTGpVxN66xMT7ajAHo7+HwrMcGIrczCmQisuYm/LnyB3v4
	HEswPDvG911+MAeJg8UzscPNoPdMsrSsyYCSD8oQqitoG3l6y8wcp8IGNqswbd50nWqer2WVweo
	/JTi9lgwHYQqquw9x7PyPfiV8l/rrTPwHVqfb7cTienRjfcMqX2qp5ccntkRHCKOMHjAHtwMaAw
	EuCxsLH5PC7bAOGjIE+aEZWcMV3/3cx5Zqw2Fft2akvpiyTS6UJ/XfJ/FBIU/BkHEIFoOIWi/zB
	dO4xiifxBdWOsgKJEDYTSshVaVR6QHCrgqaM1P2laWax70QOcsg6orjxJ5WcKTAQSKlZ+24ccdo
	o5AAHCVH5/3oVoN+0EEyBnZ8cAy+yrhthxNzLF1waS2Qca4EhR4huM
X-Received: by 2002:a05:620a:460c:b0:8cf:d5ca:ade0 with SMTP id af79cd13be357-8e78c4c2997mr1287310885a.0.1776571915848;
        Sat, 18 Apr 2026 21:11:55 -0700 (PDT)
Received: from inky.localdomain ([2607:fb91:4c8b:380b:91a:9dec:26e7:3d7e])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e7d5fe98dcsm508388385a.7.2026.04.18.21.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 21:11:54 -0700 (PDT)
From: Charlie Jenkins <thecharlesjenkins@gmail.com>
Date: Sun, 19 Apr 2026 00:11:02 -0400
Subject: [PATCH 1/2] Documentation/binfmt-misc.rst: Include AT_FLAGS info
 in "P" flag description
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260419-binfmt_misc_doc_update_p-v1-1-757c12f33cc2@gmail.com>
References: <20260419-binfmt_misc_doc_update_p-v1-0-757c12f33cc2@gmail.com>
In-Reply-To: <20260419-binfmt_misc_doc_update_p-v1-0-757c12f33cc2@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Kees Cook <kees@kernel.org>
Cc: linux-doc@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Charlie Jenkins <thecharlesjenkins@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776571911; l=1743;
 i=thecharlesjenkins@gmail.com; s=2026030; h=from:subject:message-id;
 bh=vOgkCAJEOBJpW+DNT3lDCOCb/13wAHR1oE/eova4bHk=;
 b=GdILJXyDkjiPFT06nt9j3mMJGZ8zJPsIeTbirlG4obzfAKTqWK8KcylOBCw3+aIEDbtyJ7ffN
 4W6attiNsIsBEdwSllepGqZDhmthEzFSz+stS7BB7ND+q4wmE5nXwcy
X-Developer-Key: i=thecharlesjenkins@gmail.com; a=ed25519;
 pk=vpF2USrG+aB6CTbSt34rzJKsAVe/l+GAXo1IomCMETk=
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AD129180005
X-Stat-Signature: awkhb5texrsrrbzf44rgzdckdkg3a8gm
X-Rspam-User: 
X-HE-Tag: 1776571916-30195
X-HE-Meta: U2FsdGVkX1/Tk4KKgdaXr56G+Uf7ISWU/7qzxGQgNHwCo0WERgLntvOLr6odRWV93ydYPlCuxmePs57/RZqZjyznPsqB27o7zI00hmNr0/qy2Fl+rBe5I23JWFO69iE1SwsEOkANElz1i+bwWj+qrGQRcZOVBksg6NI2on3JQR72dsF+vL2XqI2HhP0mDuzB0301FHtK4q/0ZNsV1hYigUS8aVU6qae5N/nryObKB8N4Lg6UfOdKE6ihP2vdc3sUN45oqZwUT3Y8pcXetfCXjifIlVtFV38ZOcEjrXRcgg7TddJuFazaP0u34zLmPiiUFCT74eUNuuWSYXEBXf2P7rJAZXQJGvQU/SLGhZJI+ro2dCEDkQhSNp8mVbJlbxlWmBINNG7AnEAlLCTO93uhMiiAijWp5/h3CG2k5+SyzK66KqcCuB9ccBsv6N3NUZ10RsxUNrmtUodzoqPhF8uFV7+qtj26J3Mdi5lr+8EOKjQUGyILDtL1O8GN0a8Owa12GAtsz0xC2tFPmVUsIuHMfQq4FtLuXB6HKNP13BFeounKetwVf5gX7flSxSOv7gNm5YY0s0MHOWcgHwU0wvMZgiAGP0Dl9kK6q6mBr5Cv4aV8YPHLV0qe8SqCzLjoi8qdqWfYWul8m33ODoeKnCFPxBvVWC287DAbp517QNFzv8pD98VKijJ/7G58XiYDOIRTC+qmOFPz7ZPAP1ERXnm8DnEQTEIG1Q5hDFGEBVg2hDeKmkMWqmRmaHuORZpYg9zv+/WGLgl2NSHvRwcnNsSwRzjKmSbkXPoxef8RmgpTHcm/G8tPvpxYyuxaXVJaNlSI8fGbPOJ+Tj3v723sDrRMlxFNf5K/nkY0Ta9qfPQVVGh2+x7vuunbHU9vTeJyCpbiBh/odqslm6dHHNrULF9QbaA7cyUaU9Wn/fVm6bB9BuzGQOhb2SRP9NkBzPXxYk8K9tmy6JA5l9AQzphR8yG
 9n1fT682
 29c1TB+Kf8recI89Z2MTeSATU5w5a9nloPOmL14bv14CqHJ+DtL0ADuGyUchOHfz3fW4Zjhtd49TLDOqITnG3NVFc5GHGfDOUjXa41MigiRPPKK2yUP3y7MjLRvcxj92lEGC7egWqn8BJf+P4yV79l4x8Ad1YL80CvoBEw4osU2WBYt8K9Ep35LTVvnBG8WXsuV6icsKjdS1kAzEaZ5/wjdQ5z4U5Y7cYjfz1DkYvYiSgRFGaqeb62fdEAAjO537484XR4DxjGxVNEiHYBmjdaIb8HhatG8VAa3o1eDEvNtzfjvvr7VPs0+HFiX76joFq3JVKaaUsQZoGLSlbqwJPSCx5pWXAzxW7fZ00K/JB92NpnEMfpAxVEeIYyupNN6z+xuj3Vahbl7DO2q4je2rYjeAS/70+rzf+FFigM4lkiKDu+NJV5MbufMRZD7U0AGMxPlesMvNPU4bfFOVFWr7bwuYLO2w+2I+Si2Jo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 2347961b11d4 ("binfmt_misc: pass binfmt_misc flags to the
interpreter") added a bit to AT_FLAGS in the aux vector to notify an
interpreter that the 'P' flag was set in binfmt-misc. Clarify that the
interpreter is able to be aware of the 'P' flag by using this bit.

Signed-off-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
---
 Documentation/admin-guide/binfmt-misc.rst | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/binfmt-misc.rst b/Documentation/admin-guide/binfmt-misc.rst
index 59cd902e3549..2e2be2922ba6 100644
--- a/Documentation/admin-guide/binfmt-misc.rst
+++ b/Documentation/admin-guide/binfmt-misc.rst
@@ -61,9 +61,11 @@ Here is what the fields mean:
             vector for this purpose, thus preserving the original ``argv[0]``.
             e.g. If your interp is set to ``/bin/foo`` and you run ``blah``
             (which is in ``/usr/local/bin``), then the kernel will execute
-            ``/bin/foo`` with ``argv[]`` set to ``["/bin/foo", "/usr/local/bin/blah", "blah"]``.  The interp has to be aware of this so it can
-            execute ``/usr/local/bin/blah``
-            with ``argv[]`` set to ``["blah"]``.
+            ``/bin/foo`` with ``argv[]`` set to ``["/bin/foo",
+            "/usr/local/bin/blah", "blah"]``.  The interp can be aware of this
+            by checking if bit 0 in AT_FLAGS in the auxilary vector is set to 1
+            so it can execute ``/usr/local/bin/blah`` with ``argv[]`` set to
+            ``["blah"]``.
       ``O`` - open-binary
 	    Legacy behavior of binfmt_misc is to pass the full path
             of the binary to the interpreter as an argument. When this flag is

-- 
2.53.0


