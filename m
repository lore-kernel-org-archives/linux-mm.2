Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55C94CED617
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 11:37:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B70596B00A1; Tue, 18 Nov 2025 06:37:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B47E26B00AF; Tue, 18 Nov 2025 06:37:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5E726B00B0; Tue, 18 Nov 2025 06:37:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93DC36B00A1
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:37:22 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4BF621A04FF
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 11:37:22 +0000 (UTC)
X-FDA: 84123527124.22.F2F29CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 68C6D80012
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 11:37:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="m3/oj6Kt";
	spf=pass (imf30.hostedemail.com: domain of devnull+david.ixit.cz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+david.ixit.cz@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763465840;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7hnSdEXh9XWJHB8iniGxuCWx+V/Zk1KRch6S68ZkIQs=;
	b=2WcU+6OG6+qWiYVbk7zbBpFEseRjRSupa1Cdv3CJHmZRoW+NeMQvOBl2WLenD8qBTsidXv
	WXjwSQAjm3/R50brTJSvuwvuK/3AjWdLn6trnvl1bA1b0h7g7DkCcWE42jxFWyQPhZkepY
	jz+DredD/ulH+XOUo+ZCasvn0j/SIX0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="m3/oj6Kt";
	spf=pass (imf30.hostedemail.com: domain of devnull+david.ixit.cz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+david.ixit.cz@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763465840; a=rsa-sha256;
	cv=none;
	b=LlBTOIm86v6lG0Pw4jNECyHN9A+rtzP3jzRn3uoyj7XnHhxTHqoqIBhwve4rSuhj+yQiBn
	qBYGgczi91Tcpz6zR8qn1Xwzy4W7KfFJIgrE+1Gxm38HJKQD1THwgTdvzUPuJ1Y9RHXEn7
	X1aUptIgHv3CjRUvWdsFLli5J+gOoSw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CCA2960629;
	Tue, 18 Nov 2025 11:37:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7A69FC19425;
	Tue, 18 Nov 2025 11:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763465839;
	bh=szJd34lUBHLNu9S3WWAy5BrQumAvduXH2t3XIhEX5zw=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=m3/oj6KtwbQaKH8dDXYgw5VwU3rbHBxx+7P3iMX8UaxPoH9oMPkZdKDkUKWE6ajed
	 AStKA3jRiKg1GsomdZklQmZZcH+RR/bZIP1znZlVdlepZih71RKf6AxV3bUdMdAiEr
	 qc6IDq1AGUK1DBVvOIQ/69L1jYVf/eXNImv/+JVcHw90L/iVn0iDD17HGjnmbINYBo
	 1GIZqsG/XpHNtf9Ais8br4WO2fwdVqeMYDn7GC2PYS02+nnkbFRT9tXMHq6Gp9+718
	 5SFA23FAw5CiRR5bL81vV8C9l588TMwdUVgBjgDXal2EH48DXOAMeVxqRP+bXUPahM
	 dq/PtlluM8lpg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42487CED624;
	Tue, 18 Nov 2025 11:37:19 +0000 (UTC)
From: David Heidelberg via B4 Relay <devnull+david.ixit.cz@kernel.org>
Date: Tue, 18 Nov 2025 12:37:16 +0100
Subject: [PATCH v2] mm/vmalloc: warn only once when vmalloc detect invalid
 gfp flags
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251118-only-one-vmalloc-v2-1-fe702aa68d8b@ixit.cz>
X-B4-Tracking: v=1; b=H4sIAGtaHGkC/32NQQqDMBBFryKzbooTtJqueo/iQuNYB9JEEglay
 d2beoBuPrwP//0DAnmmAPfiAE+RAzubQV4K0HNvXyR4zAyylDUitsJZs+cgEd+9MU6LoR2Vasq
 qbhRCni2eJt5O5bPLPHNYnd/Ph4i/9o8sokAh1dRSr4fqVtYP3ni96g90KaUvfHYjVa4AAAA=
X-Change-ID: 20251118-only-one-vmalloc-b8d997045791
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 phone-devel@vger.kernel.org, David Heidelberg <david@ixit.cz>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1257; i=david@ixit.cz;
 h=from:subject:message-id;
 bh=54i1YH3FbEzkceweElaDmkfgd6gmC6hf5zbFIJvmoD0=;
 b=owEBbQKS/ZANAwAIAWACP8TTSSByAcsmYgBpHFpuJ+ejYSTUfSbADLtP9gVRTjv696wsmMt5H
 LWLalPK7qOJAjMEAAEIAB0WIQTXegnP7twrvVOnBHRgAj/E00kgcgUCaRxabgAKCRBgAj/E00kg
 cqaeEACisQrL/b2MB5OMb7gMPoBEJzUnsNF3Y6KJ1b8zABV832iROP4kQ71qBkGr2GUG7olBzyY
 09YY/DGfZrUcnUnAuf/lhBrqg4WXBznjJDudhxk/zLK3Zv8TYmpysA4KLJquV4sJA2mP/em3O40
 yKgJjcuwotuyV8Qe8ofP8tcxCSl2jbA/wcOC93prPbxh/0x9u2lLaj7Tm/wti6iMo7hjVZLr60Z
 4jsMUKGxJy5/wqr+5e2oN9mzZcce7bGtNw7VKQNqyxpZTFbrqmNmoYdWM5d21B5vuY70I/U9ko6
 7mhMDCTIIQeoYiQ1bTrL6hPK1aG4KeLcul2EojTGaVyGAtcYDb7E9u3bLioYJCPJbvgYH27oQHY
 8mO4dfzh1g6EO568QqW6+rBbE95s5Rr+puKLSEyI9DPjl1Ynhzw/Sn5MMXX3jWLlv+4s4wePHu0
 R8NgtmSBOYw8IrwFrbAMk+DYn+6D9pEN81st9xMi3d/f3GaHb5/bVQyh5LgfALbWzDZxWtsUvBM
 o1jIHhbwodFsYTlx6vEP9YzOozUNDf3JDR0txNSvYHqprZgmsXb30+whk4n3eVUYAqBqIcXwRWO
 UB4YC+nqOVcCmAoXMFU0JcfCaUyiMcrUA380gFqUUpMB5rs5Lnix3VDAd2saEUNW9T9N0wjilTe
 khx4navcxX8ASLA==
X-Developer-Key: i=david@ixit.cz; a=openpgp;
 fpr=D77A09CFEEDC2BBD53A7047460023FC4D3492072
X-Endpoint-Received: by B4 Relay for david@ixit.cz/default with auth_id=355
X-Original-From: David Heidelberg <david@ixit.cz>
Reply-To: david@ixit.cz
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 68C6D80012
X-Stat-Signature: hgthdaog5ff15dgips1rhwzzasm3p5qd
X-Rspam-User: 
X-HE-Tag: 1763465840-877214
X-HE-Meta: U2FsdGVkX183RivHMsp2V6lEjUF8TARAfpl+4ZUuk5F9UxZU+i71F3YVAFVpVwrAS+KOtjG5TTPrUd2tspN+NBlwU7OnFLQgsNOMtaMCNpvN6CDJ0k5roC4LfTTZuZTLr+mJpqWQrMChAUFacaj2d6UsbbjmAj5RCk5qZZbe/IUVkX1pp5hl1CRaLANvFUCKXsP0L0BF9gWda8tiW4dYPNYEmzpagRsAiR2BsuVfUDCzKC/ICkhL7brbMltPGIJ6a8gnWHMizeuzrdjwHSHwQdR1VkKe2ikfqDn9cxyQfhExZ5VRwHeN2Yfjcye4nYaNyIBkiU7BX0NtHmO2UU2gPfrjyJPvcvY1kFc1DaAYzhfCX5fZm/eEMvaX9aiUnIuHvHeq3oAeSBT/rOtjDrqgHvFpX1lMe/VPbHiyZE35rRCRTJ3LTngKedoOUaS7NrS7TmF3EMEQCgNglUKWZoRgbhl7y0QqoLd3DYMQzTHzH8h7989djdZzpFG1UFxMsjCAzBz5G7XrXFmo4RGprg/Sf/HOq4qAVGnnPbuwa70GLUITai6Laos98ch+HkeUGamwxm7Pcowz1soMpFWKyM3rCG9gakek7nSY4B1txeVg7wjDj3yO1brVH+37aRkZ7CClfgllJn1ELv5xiNT056L6961DIavEsqtMu5iEERdmx4/acVXLQKj4gUjlgKETOX5CeaCO9325hmecV+utcdS9K4NeriYuTm5+XW2c2UOHgoKyuxxnOY9hdMS8JgeaivRIb0NIIuHgqH6DYHT5YHw3VzMf8zBRqe+R/dsxgFnBacHsFw4dWAychAMO+p7N5LwTeWFVviPjbJpyjRa3malwOo524PfA5MoV/r1bkf8giJcFkbXGL1Xl9Xi8sCAirFyH4Ol2x4+NU6TYTpUAoqA/2nx3sXXPSvG2xaFgFGuWuZqPrAD3f88eJDb71Zj2fZhJ88I6k0Q6oJTEnPRyZeq
 xezLTAfq
 8/m72Rh9YyJVoY255xv0Hj93sZ2FD/FgeKQKIyJYLeziS8vrgcWZFGTSfsBFL5qzudFkbE60BPY4m5TIbAeI1c8Y1UzVzZCTxJ7noH3d2dcHlK57J1+flIml7DqxA32YEBLk+TJAJl1aX5bjr8zgMjmHsB6hy9K431/8t753EbSzXvHR6PviP2o9Kme6RvGTUoruZWyVoDldPUOGxi6zFE3dUIsJ/3m7FZr32L4LzJiE5PGEGi0AE5fNmDl/bC4nZ2EkI1oSJfFbrkb3DAdLhPYcugTcQGqFksHcUhTGB3Kaa90csKYCk052/m/BhtawXjzyu7AkzduKI/uRFTEujirC12YaoC7668F5UAv0eSfxze1xBSurJZ3bbFmSiV8FB43B9y41y/uwpWiqmjBQBMxm53M1AXlxriuIkVvuhKDgyKtar3qxxV1Vcbh0qnA52Ajw531eCtg6e1eo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Heidelberg <david@ixit.cz>

Without WARN_ONCE, the logs get spammed immediately after the boot,
on devices as OnePlus 6T (Snapdragon 845).

Fixes: 7179b2256315 ("mm/vmalloc: warn on invalid vmalloc gfp flags")
Signed-off-by: David Heidelberg <david@ixit.cz>
---
Resend as requested.
---
Changes in v2:
- Fixed accidentally removed comma.
- Link to v1: https://lore.kernel.org/r/20251118-only-one-vmalloc-v1-1-29f8eacb4605@ixit.cz
---
 mm/vmalloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 49e0b68768d73..59a4ea8b7f91f 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3934,8 +3934,8 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
 	gfp_t invalid_mask = flags & ~GFP_VMALLOC_SUPPORTED;
 
 	flags &= GFP_VMALLOC_SUPPORTED;
-	WARN(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
-			invalid_mask, &invalid_mask, flags, &flags);
+	WARN_ONCE(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
+		  invalid_mask, &invalid_mask, flags, &flags);
 	return flags;
 }
 

---
base-commit: 0c1c7a6a83feaf2cf182c52983ffe330ffb50280
change-id: 20251118-only-one-vmalloc-b8d997045791

Best regards,
-- 
David Heidelberg <david@ixit.cz>



