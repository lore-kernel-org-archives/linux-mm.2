Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7647A606D824
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jqg3osV/
Received: by kanga.kvack.org (Postfix)
	id 63DF36B05B1; Wed,  4 Nov 2026 14:02:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C8396B05B8; Wed,  4 Nov 2026 14:02:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B75C6B05B9; Wed,  4 Nov 2026 14:02:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2639D6B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:02:13 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9AE3C160822
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:02:12 +0000 (UTC)
X-FDA: 85398356904.17.A9F4429
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf31.hostedemail.com (Postfix) with ESMTP id F0BAE20012
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:02:11 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="jqg3osV/";
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of 2dgodoy01227@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=2dgodoy01227@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793818930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9m7RVHJoTNX9vZUelgq/zfkDObxm0i0TSOz7tgsuBTc=;
	b=4TAuxtnSaJb3CcyhuVuRhClwjSvwdzosdh+Bc0rZEOh8B+QlohIVht/fprWnISOtN8lOVG
	W7j3++TjWo58jnLxE3Dv9Trriq7SmBIgL6hvo1P4wipzGWq6ZibpnL2us7swywLGewX9g3
	ijkDk0MJT2ifeAfM4c3SM75uRBx/q1c=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793818930;
	b=dZekYwNHVPdLrZHeqlGE0VOwbY3Bq4GF26Y2Js3E+sGit3TBaLLG7WFVQEVRWzsAnvvszy
	pOw3E1fEwUBYP6NzuGP4H/zzrJACAxEP31BX7hVy9iY/CQK4tOJKip6bv5jBu+QgPzx5gQ
	8axlNpkTBCDb0R1j8oHToeKLPyWZbic=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="jqg3osV/";
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of 2dgodoy01227@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=2dgodoy01227@gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2e9eb579c0eso7033165ad.3
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 11:02:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793818929; cv=none;
        d=google.com; s=arc-20260327;
        b=ebmjqJ05yaYzJuEfBH3EIhUYNSTsz9dIHeKmtHnl5BLc0mmsRCO0t1Re8QK7+9Vl3r
         +wxzUNevDlvsxyIi0MubDTbsJ/EA8Byqi8C5nbLvkaSrgHOxl5Qei8czTsB/+1+8nTtb
         /spSYmmf9MMESv8lhsJaRTId7d3pVluUTNig1sJU9MFi3mFjmrlp82RnL8uLik9lZ4gc
         hVvR8/6zeGTbi4gb7p/esIOFuS+SoA8Q9pRkBMWJR0RChoYHdCzhRU9+lLZl08Nyk9RB
         ueHDFQephHVAVDohJXhVn7913pqMtRjlEYY2qyiRTZ6so+4AijFzng7OKY9wMik1BgMs
         ftgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=9m7RVHJoTNX9vZUelgq/zfkDObxm0i0TSOz7tgsuBTc=;
        fh=YxaQX7GTjfBsN7A2Jl+A9yP6mmGOQanoqU6QROKhVaA=;
        b=WKgBrHY9kj7B7IqY+5a1bbUSqdabX1ebvhEStKFcE+1wfBMyE65x+ol6W+wXJqzvV4
         WmKazrGaX3H15n/zgOLL6rR+/XcmRoQzqYbVzzlhjwWZZsfFnNMWt7moXtXT/U2kyPhl
         DqCawYR1K4+H11X8RrEG67+jF8c8zLpdtFv/gRMSDMxQTRofLrQdkilqo991vJ2lLkdi
         jOrLUqaRpjCi0LMaSfBLOaoTQ178niIKJZ7Hal1Xhii1xFQVA+cTnzdo5sc8e7ZyhtG3
         q50pycGljpBnrWn2ZuV+ipSdOoc3ZcF06PZYblzmd5omPUpYYcb0yySjDSmY4BzeAW4B
         hGoQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793818929; x=1794423729; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9m7RVHJoTNX9vZUelgq/zfkDObxm0i0TSOz7tgsuBTc=;
        b=jqg3osV/sp0R+KBwUIJPjnpdx3grTeI3kaYfC/2C36PLc9oacicj3yjialxeCwRQ4A
         WLGuSpNfWrMWBSYngKEGwTwz1yepVfy69H4ygCKQgLwlPMiUl8In9qhQOoi/iI/s0RrB
         tdYa/Tpu7kbmMumSpFhwvJgwPKxKJqldVWNin50GHTxYwjVo355wzINDh62gFWS0XuOD
         L7MHutVoZvDTXBE/BZxm6Q+LuifhpVWkL7cqQNwheJ0E7xVZyJq9nZqrM3VE5s+xECvr
         HKbdThtAeJr1WFd0E2QQQWmzyzXxI+rBR8/PW14mN79QAWIWzE33awEUiNyxfglydl0y
         b/Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793818929; x=1794423729;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=9m7RVHJoTNX9vZUelgq/zfkDObxm0i0TSOz7tgsuBTc=;
        b=ZfOScOaA7jGB5ewWrICMmrTnu3KJ9L39iGuHhnbLMOszGb6gLetEoASHyw0PFRjdQK
         Xjs3DpLEo/lxFX3HzIMQxF022LWJIG9rONQ0qVaohSxyibD9gVD7KWr4xboqmieMjcLW
         ZL1/bKdOUzj/eq3hJPpbVjHbQAvu7/anORuBoe/Odso4VSiUJO8EF+u9qgfpGqeEznT9
         e3JN0zO50SOVkKser8+ewwRwm7H+VS8iw/dz/0C1egKydNu4YSpWyq/dX7Thr51GrVel
         9uDaF9nNg6MFk6ecITUE/E5Wfs+WxR0skOp5pnrC7QM2KkaXZppjaMMCYBnlmsVo2+tT
         xb+Q==
X-Gm-Message-State: APuU4Z97PFYfZLX04bzXSB8KP5CziBOlaOVeUqdHs8UmPw6R0ElYIxYv
	ENpCl0eGue49OjUN+lUrwhshw7MidLBTwJZE5Y0X/9EF4Mf5nRUhVdlIvUIJmLrXP6sCb2C2SDv
	WGIkFw0nCfyeJK3TEb4kbD9qqYIkT2as=
X-Gm-Gg: AYBFou3ihDyDCzf4yvRgXAELBydtDTGP4ZF7W57pwRK3PI9Pa21EuMfAB1tDGYyZuw1
	JIDfxXEeWBZ8maGNvy9Xt+ZKL3KGB/xDZi8Zn6t8PtcPZWSsX5HU+KRLkePoYc41jVrN87S+fSN
	D5iT8TRkrOQys/orfQictvujNawGol+CccsHlryvE9vvh9Q9q1omF1EHRAN418J7kdrQw3Z7mmN
	DUSZ+k/OOE5A71OU+gv+XiQmlAXfHvKmYQP3vP15CHT30eoVbcSYaPfYty8b1Pn+iGOFOIYLDfC
	AHEWw9rYSrU6rxZlYUyPH8gauCGJ+mMylpMCVVLtmF5keoOfuKayPM0Ne4xgEJCKarKLh8wA1nN
	NB9EUIUW5I0y5fyCo8tJJaPAhr7zFUyQjI7KfbxQdzJuAd6S10jXvyJphYCy1XvSeGIA=
X-Received: by 2002:a17:903:2f86:b0:2e9:5c55:c472 with SMTP id
 d9443c01a7336-2eb36469217mr154061545ad.42.1793818929400; Wed, 04 Nov 2026
 11:02:09 -0800 (PST)
Received: from 511566560828 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 4 Nov 2026 11:02:08 -0800
Received: from 511566560828 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 4 Nov 2026 11:02:08 -0800
From: Henrique Godoy <2dgodoy01227@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Wed, 4 Nov 2026 11:02:08 -0800
X-Gm-Features: AclHuK-NDBxEamBMdtik-7ORLe61ClxkfZSsfBGeZD2zKGsDfiKjHCul0scWrVQ
Message-ID: <CAL1HEBCsVKooMLqYUDc=cgNxzguUeTZa6ALqHrxe=kbC5xwYEw@mail.gmail.com>
Subject: [PATCH 1/3] tools/mm: keep the last record of a dump
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 9g7e1igrn59gkjxb8raiahccbeczpqyr
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F0BAE20012
X-HE-Tag: 1793818931-567191
X-HE-Meta: U2FsdGVkX19WNVEIge3PP3H8DJsnn+7r3Pg+6dO8N82PjmIN/cPB/x2/G7kYA/hkSuZphPMufMs1kzclxaQQ/XMw+vrOtGxOQbJkyKKyLVtZsECnN2IvGOceDBP1wSxQDZhz2ZMK2bYru71/RVNvs5RTng2KrS/AWVlRAP8UwHmEy2/3CsN1D+3P4x0Ml+q7b+cowlOfYKBZgqvJbvkKHqOB5Kk7IrK1aJ0ZlJ9XhLA+DKbsjr6us9bNGzTniNkNtQEFwOtikD2c2t3QkKdaKSNzQ+SSpU/jYNblMteD4K15aMIs0PDziw8pCR73To6kb9vLIbHU6ahkFzdN0RBfAUq2sreuAdJb2vT5SjCDIJ98bO2ARvFJTZxoEKgmKz5SottdIQAb0LrtorHHsi89Le5GvDgi/c13JEY+ONphxXiDui7+U/Tb2l89HM6dPrvT5jae1HJmnv2RrKCHrrsWN8VUvMBONdUaYoIaW6oy32+lNunAQ4iycbXg+ZGFUTpPBRDL2RtWCW2V/eeKrGh3lD/PWkMDWe52c30cRXCAQWM52LrOTiP96qWjzxg6jP+wXXFP1VSU5FInc+yl9J+SlxsQVSjiHh5DPkeVdRbYMayGHwNYEYkGgZQjOXgKba0C9AJY36vPTlR1tqvxnFwrUnXA+qXMmpFousbr9jAAMAfA7DuKCGLDeElShiOspY0J4A/PtyutUk/iydVLoemu0IoTf68lc3/AEmTWqV5SLhZg7vR+BhJ+HnHddlWWg52KxxyCNoSdGPvtYl2JnCiDAudjIeo4WNzcFOATEMGPlGVa4v0HhN/JbLiM4LJGwtsWhrUQSKUdXZ9zZd3WNOzrwPTKakgxlo3xxX4IbuvXXLVRMyBQ1dhHA0Mv4sH/OJr73GAsKRrtgJAOnUgEBrxfOSLHTV27ODeEA/H8tb9+9S5rncbBuubMKWSwA1oXA3r2tlDrpzJL0IVeDiXnu5t
 FC1lTdBA
 eB8iTWq06Q24ePAlhiZY3kOWq1u4NL++zUOA5cqith709Afri9Ue+2Yot+j+b9sf25lghS7D/EPEDVAZppsX5knUrdXcrouYxZQXOIgrM2QqGWFee5wtJtM9en5z8KhkIKZDxv2015EesfzFtBvfUk7QhI5kT+e8vJc/PdiD+NOKMm++bsGE+SDaPa//p7bOQBT/6zDZ0IdokvNmglkSBmcHMvJSgzKbF12O4aRFdrw5mWYkQT5Br9fbXFc1tJfczRQNmHYanaw0nKs+7TqwTVL9l9Fef7Jknikw62LZ4sH8NFo3O7u/1Y48zdJRtzZgBBb1XZ2LWKzkXebnEfyqvq/IuWZDzxD8P3mrTADRE4TpbCJ59MnNLEUUeEMyjs6aAP8u8hXRxjCJMMEQW0KiOascdFfTCcU4zDgWy2vEIGBEI0/3UoQesXbstDeRQSN/BgbkbFUGhthJFSE4YKb2O20+KHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

read_block() returns -1 to the caller when it reaches the end of the file,
and main() reads that as "no more records".  A record followed by the end
of the file, instead of by an empty line, is read into the buffer and then
dropped: a dump of ten records without the final empty line loads nine,
and the tenth disappears without a word.

Return what was accumulated when the end of the file arrives in the middle
of a record.

Co-developed-by: Pierre <pierre@cloudwalk.io>
Signed-off-by: Pierre <pierre@cloudwalk.io>
Signed-off-by: Henrique Godoy <henrique.godoy@cloudwalk.io>
---
 tools/mm/page_owner_sort.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
index 6c2ac5d..4c2a4e4 100644
--- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -134,7 +134,13 @@ int read_block(char *buf, char *ext_buf, int
buf_size, FILE *fin)
 		curr += strlen(curr);
 	}

-	return -1; /* EOF or no space left in buf. */
+	if (feof(fin)) {
+		if (curr > buf)
+			return curr - buf; /* record without the trailing empty line */
+		return -1;
+	}
+
+	return -1; /* no space left in buf. */
 }

 static int compare_txt(const void *p1, const void *p2)
-- 
2.39.5

