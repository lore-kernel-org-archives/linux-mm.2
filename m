Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61FBEEDEBEC
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 19:41:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EC8D6B009F; Tue,  3 Mar 2026 14:41:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C3E06B00A0; Tue,  3 Mar 2026 14:41:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C7076B00A1; Tue,  3 Mar 2026 14:41:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7C9B96B009F
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:41:08 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 478E1138881
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:41:08 +0000 (UTC)
X-FDA: 84505770216.18.68CC6D5
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf15.hostedemail.com (Postfix) with ESMTP id 74DE6A0005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:41:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JlCAvxyM;
	spf=pass (imf15.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772566866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6QZyywLR6W23Tiu7K2mRjVRgp5iZjQzJfzb8/E2KBpg=;
	b=Rebhc128TZDbdZk7Hw2sAt/NNM0h3lsp97awi8r6TOE9mB4X65NGXHA9ANVzreD7CXfWLC
	Y08fwlkj/ToRvWSfKUgKp5/YJi8BH5GPxpabZtg/i+enaJTeCBtzBF/tsFQ0YLyxwldXHe
	M06CE4K8MCCsE+YhTz/qh/qzMRbiX0U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JlCAvxyM;
	spf=pass (imf15.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772566866; a=rsa-sha256;
	cv=none;
	b=ReahPgU9zX5GFdkc+52bNydt4wBW3ty3TNVtHPXw8OFGBzq8SlJGr/kP/VK65Y16Bve83v
	LztvBDW8TsWzIl2oKA4tGoPSnW1VLQ9xLK5q8xXIY5+t+ys1fEul0YgooYyc9dUpKfTVXw
	b/4PIBXTAQQnpw/0zjqVCfVlfp2J8FE=
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-12732e6a123so2840614c88.1
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 11:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772566865; x=1773171665; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6QZyywLR6W23Tiu7K2mRjVRgp5iZjQzJfzb8/E2KBpg=;
        b=JlCAvxyMYBHAaoNFYNEPOcZW8jBh438EnVmi8aVvwEHPPqu7BMEjI+4NFi3vTgeE4s
         Yq43Vw/6CN0zr9MwrAoH5Eao8nUqjyqMpjF0gKeTiKAtToIO1FBXTNjt7Tn1SEbnR+Gl
         B2uj0dUbLqGLhoanDzZRsHl4+Y7LerHDC6/dmj6xWY77kbht8vm9p4DrHivg0Pr8ziyI
         BIG14CcBZZ0FPpL5iVD8OXM63GqlSc2cffUZuEnUKT9Ene0tYKMhVOZNWr9SsHyQ7b9q
         /67GUqKErkLCHhV2rd/rooAdyoRLOxYCgtVX811TuTfyWhLp1+ZRwnhy9m1Idrf6vsoP
         8QLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772566865; x=1773171665;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6QZyywLR6W23Tiu7K2mRjVRgp5iZjQzJfzb8/E2KBpg=;
        b=gscd/l0CFjo5389d2DThlmozwXRgBtrlO9RQlBeW620338MWuy/11BT3oPxaI7MB3O
         pVxL87PH8Ao3gZrg0dqcEWIYrc6h5OvSwpLSI1s62aFGryk1XHc9/mZMCzUY2ETpsvxj
         0daW+8SfON3y9znZlvXUi6CW+4VoDlCLFWJ3+uTzgPBzmFjkND6G/oVfj2BJgLgZSV0+
         LSqudr9TzH+FkEOTzDYw+3LVtDoLmJK4PfDpaOqU1BRw/KCDRthgPAx/6Gjwe41NI57E
         TVkerEWzf738Dpnc5flA57/kSeyaHcviopBim5AmsJBXzsESIH4lJ98P1f5tI3vo0l+i
         6H4Q==
X-Forwarded-Encrypted: i=1; AJvYcCXTnreW6+vI/W2lgurGTxr5/kHaC5hM45hWpG0ZqFKf72GBM54fTICCRWeOBSbBLA3lN6xKSgIDMA==@kvack.org
X-Gm-Message-State: AOJu0YwKdSF6S+C6NiRJRdq5s0AQFuq7/mU4R2RVu45IX2/xjTxpyjlx
	iVD28JZ0Xf3MnXxD/cRS/q9ZSAdQ7AVvZ9aCkO2nLVpkEauMZ5oSblgN
X-Gm-Gg: ATEYQzx4dTRWxFTGYaZOtInQLoDgWnH0s0bTO4R1YXXXnsNdCi8cGsct16ouqeXgip/
	8guuLPpMIQ9h8SaP6IzlPGGeC1cQi4Dad50vmzOImAgPk7zjuHtIBcNpJNUTWNDzkEola/Hrq5F
	yCwFeyH5C7mV8oDUQJ7blSYbIFB/enwOehRpFRVv7c/LFvUbl7/ueaXHf3llZbF8gFOZq1LtzHi
	Z9h2JjSiS3iduyiLsAFWoL25IjLy/8GKNge+Y/NKuK6E7li8eDd/FwMX0Zuo2jocvoBc8GGHXNq
	cdO336gkZCPwH4SvRKK6qRwYgHK9PxuaqrA1Htd4zvDX1PCARI96vkTmBk3D5ISPYaWdWwllzCb
	gh0Lpj5PudWDOG5rPMfybCCKC8g7gjGSuHD2WhTkuP1qY7u2gMsxbmWK0rLsZHtMFI6q2KJkpGZ
	mWWSL9wN7ot5eITkVRem/xnKlhyc5QoZm4qfCI/pER5Qn1kzO7PVJ8CG5/FX7pRkgsHsF9mwqeq
	7ugbBLGmRguP34=
X-Received: by 2002:a05:7022:928:b0:11e:163:be60 with SMTP id a92af1059eb24-1278fd591f8mr7500249c88.31.1772566864967;
        Tue, 03 Mar 2026 11:41:04 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id 5a478bee46e88-2be21dc44fasm2228723eec.25.2026.03.03.11.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 11:41:04 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	Dave Hansen <dave.hansen@intel.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Rik van Riel <riel@surriel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Juergen Gross <jgross@suse.com>,
	Yu-cheng Yu <yu-cheng.yu@intel.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v7 1/4] x86/mm/pat: Convert pte code to use page table apis
Date: Tue,  3 Mar 2026 11:40:40 -0800
Message-ID: <20260303194040.1406267-1-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 74DE6A0005
X-Stat-Signature: u1uae1kgb1idafcxkw53pr4tefbz1hgn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772566866-852177
X-HE-Meta: U2FsdGVkX1+zDcbPTE8AaBpHl5olrRB6vhWa/mhGHk0nwdcE+oWlgHQNJ2lndelQDK1kVMI7EEliR8k70ePRH9kYPS13iDsr5I9GTIG3KgzoAFOgBM3aVackFj2GkIY1vCYoo1otUdZYDzFnTp+/i3ytG/fIY4ZYl/7QCfMHq7g3qA1i6bK0LM+u/b6iR3VHaV0DiXnH4JhNynZpchceQC1WHP9EJWy0mdD1zFjhbIHIxgJNayfIRnOgkiGjMU8FNNMcXStuwCpMtxs876to+nQRE3UwJaZOO1IipylxKx8x8FBNir6+aCxU/J8mOxD70+5n5+nZFxkdhKwSLpb5SS61N+YE5ypKKK2ziCf9vgiXe7o5ghPBzt8errZOvcELc/Hi3GsGYt+QHeJhXXohk9ontY3sFMiQ6w6Wi0QO4L+SdnciQtgZpU6Y6czqObm79QMIw9+2ds+a0wn9qq0tUUINfFvejfYnIAGAC95oMH3m9f5Lclu8hkD6QNKOUnFcEBKKFAdKTeI+6L+P9Ap2gOMV1w9K2mhws4LIqNg7k4AmbqYuHotTDjr2VFO7oIi8TIEWUCUlip3EqoJD9fGP8E7oRCk0mHHp4W/SvVaqka4gsS3pmes/PX1R5yjVQKQT2Yq1rVIjNOnId7/w4VTQq5P1/t+a+dCv7VpGx5Y/f3PWSLnx45W5lqni0UvdOvSaD18FfDIxQ69bJs4MXhajvzw/5YUqhFrXX248mfN3e2dOqYahyhz8B1CG10g43uwU72G8PhItuzqS0aM1R6SJjPNOY1IeDoftsWvCRBuTxUMxezLqz4MpSy60+xjBuKueN+tqLnG3FS5LQEMo3hyOL2tB6Cjyke4xTwft1S9pAXGwonxU3ms/5wuvss8Wm5Zpi42xW/xwSWP5S5oPb8aVc87gnITu9Vxt3OdK/KcMMqabiETBBqRxN9X2VK8lhOIKvPTqqufh3Jsvd0ybhuf
 3VnIcu4V
 qLodfGsd+0MYpGV4AeoslNlvZ94y5BHVIvd9aJ1irjJARAeTDH1xh5cgvZue3gXxnlTZCAWs9bBZA4hQnFmSxCgSsnlNRlXJm2zGe2copCajEPgsjRW6aGwBZPqCZ6Km7URP3c90aX/h0JAAjQ3VDF5lvYZa/2nCQ2y+gl+9aT57h3hDo9hnc9Z4Q7mceEf4F+aaFLclGdukcXSoc+WOP9dqPf+D9YcXyQQ5QI12rfcZoKqMtiRc80LN2h/mtZChOAfm6ZeKywUOz9WVNFWnRCVeNIzT/EafvuigjSKpZooemMrg8FHEJca/60F506YKHIs8hkJjzovIVOwpCMP3Tsdl3LqeBhgFZPO6sJeiYLraGqIFSrtuVx2qfkR8G6zwgH4D+JO1/ZiDtsUpTdWK7kaWvZUoTCfm7nmXHPvqvYKshm6l0wNR/XuLl2IYDl6mk6HgsRzlaWuNqSPFr8binMm4aBWi+f2D15SuNgYrsle1E8NBb9cUsZT9flNg3IjGoNxu7uKvzBUb8TylNAA8dbG7//81l21BqzytJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the ptdesc APIs for all page table allocation and free sites to allow
their separate allocation from struct page in the future. Convert the PTE
allocation and free sites to use the generic page table APIs, as they
already use ptdescs.

Pass through init_mm since these are kernel page tables; otherwise,
pte_alloc_one_kernel() becomes a no-op.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 40581a720fe8..a4b1b329c23d 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1408,7 +1408,7 @@ static bool try_to_free_pte_page(pte_t *pte)
 		if (!pte_none(pte[i]))
 			return false;
 
-	free_page((unsigned long)pte);
+	pte_free_kernel(&init_mm, pte);
 	return true;
 }
 
@@ -1539,7 +1539,7 @@ static void unmap_pud_range(p4d_t *p4d, unsigned long start, unsigned long end)
 
 static int alloc_pte_page(pmd_t *pmd)
 {
-	pte_t *pte = (pte_t *)get_zeroed_page(GFP_KERNEL);
+	pte_t *pte = pte_alloc_one_kernel(&init_mm);
 	if (!pte)
 		return -1;
 
-- 
2.53.0


