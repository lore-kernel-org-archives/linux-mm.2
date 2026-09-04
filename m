Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49CCCC624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 12:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CEAC6B008A; Fri,  4 Sep 2026 08:21:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17FE16B0092; Fri,  4 Sep 2026 08:21:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06F336B0095; Fri,  4 Sep 2026 08:21:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D3D566B008A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:21:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BE4CEC1160
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:21:03 +0000 (UTC)
X-FDA: 85175989206.14.458646A
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	by imf22.hostedemail.com (Postfix) with ESMTP id 036F8C0005
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:21:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PaXHCb+u;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of hemanth.selam@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=hemanth.selam@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788524462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hd4PSrEusbAFa4INILvOws+6RzUQJp6h+WgDUNey2JU=;
	b=2QZKtCTr9eV6IyCq0WEy1lZSlGBjO6DzQfV+gHEyla6emu0n7oDPBcyis7X8pwpqGlmdzZ
	3Np3bITdN+JoHvx+QQ8KrsqkF1K68rhjtTVx/WROr18uDf8Z15LSvWRHZ1R0VAP4zV1GAs
	1wrsF3kctL5pBNJE8vRhCEUGRoRyZII=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788524462;
	b=3nH9IP7l//HEVKVYx71arQcwupXun2Qkkd+w5VtbXw8xm3uA6XM0tN3xgIMzbEowV/zkio
	SjYrhJKpAJkZVAjz3UwCN4frjWUqtqjpOb/fJn1LSNffMWsCO4LSIUwgS5G/Cqv7mN6oW3
	zGcgir7t+m4QTOwy/N+sBFTqr1LjAtY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PaXHCb+u;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of hemanth.selam@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=hemanth.selam@gmail.com
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7f3ece23165so776063a34.0
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 05:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788524461; x=1789129261; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hd4PSrEusbAFa4INILvOws+6RzUQJp6h+WgDUNey2JU=;
        b=PaXHCb+utkaDbHDwYk7UBLzZbSxy6SJT4FJTH7zwRQ0DS1EHuaoVXZk97J91bBzKsH
         iP43CkBz5GlxdvKaC1RLNGa5JOsg9yqVtmml+lXXbxp7AIbWs9W4MlEgGsvub1rVW8Lm
         MArqeKXeVkBgs6wKFrvg79SEp9SSar5yF5yHw8aJwUlNR9Alx7yQicY7SzPoyAuxVbzB
         07UD/02vcxbmH0Nm4/WXaUl3ekL1kwqDMfF397M60I7hh4AiSjC5F6/2lp/fe4LNsCqi
         wBcPTQgp/TZZu/i5v/sTXyoL2v5SwOUffPxpxW4w/0qpgKCjk/wKYIXc7Y7oZuvs7PQW
         WEeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788524461; x=1789129261;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hd4PSrEusbAFa4INILvOws+6RzUQJp6h+WgDUNey2JU=;
        b=aYzYFyxjrf9364g0IoH4rl49s0lHqWoBLeKoq2zVV2HDryZU3B0WU7p+jTCVQX23t9
         dQd2F3YRX4T4NR6UDgQiDNQoFg19t3qtLicVHOIG6+9V1lV5/h6R6biHyegQWifdyy2F
         T/thWTx5ni+lWmyJxDoFZIwpdjvEptYK85rL6SZ1PEpaUaw9NVOKZPEpuzwBqDfWL/dC
         FP9ztR1Ry4P0ZHbtXN5DELIKiIMNat3kofZTpB/lZWnNdYxbTvoWmv32dQ2JY8MdS08G
         UryQ6rKVRJyE/PhTqVE1o+ZsJpo8DzPeEdpARge8kFOnJRgXkJJWaF1TNcfDacjucfWn
         xmgg==
X-Forwarded-Encrypted: i=1; AKwUvByAdDM8Npgp1rB8J/tqZviIwN9Aj1CiAHfekCR5lUGjnx+1/zWjdpRqoGMWD6scsALtXeEMd+zqOw==@kvack.org
X-Gm-Message-State: AFuF++nNnqpvEDYuZKnZzv5LjjJNYZNy9mx+XsjbeXdbhLDHNGPtLT6h
	EyPnPaCP+ud1WrsJcZJuJHEx0BWlFZ8gS3LrKrOHm1daVEsXb3au/tzV
X-Gm-Gg: AYBFou054CzhBoropKVBypHxg6Fu3MGrL+xQbxeYNQLvIt7LyWptnMbiwcBv5vF01/g
	mOUFIGMb+bkOhxmCvMuho8d6ShxNZmfGpqpeLnKZbyXXmTkc/STsO9NN+duMOBseSar7pmEqMX+
	SxXJtPFmcrpRVt9ouOS98fZFSm6Z6Qjs6+COdzIr6EO139asyywv51tmC3g3OSHlScuA1rx2ZnX
	t+spZWlsyTPAISomBBC/dLSMWpOo19bMCailq4Vr+K+wWSsfI9Ol8eIB7A9NRYkNmyaUZy8OGnw
	0JnEdXNrMO+sI9hCz8E2QzlIjPY/14zJa8KWU7FxN5RuP33t2Tn0y3FDUcvnfMvK+nKTe3oYZhk
	5xYkqN4e+gvFEaoWwhtvE2ZtizjlpaeMlOwIU4t4Uqt9uEyd1070A96XnlprkRbnzHHoJlJV65c
	4HwB0XE9LcBVjjHYsbat2P4AZ79gmVdfbK2pnpZep29Dj3rPFEYU2ltHO67kK4Pd6KUmU3e1qoE
	+bO0lJZltsRqD5LsE4Sl73DcmR9Bj1YWqBD1g==
X-Received: by 2002:a05:6820:1694:b0:6b7:83d6:2932 with SMTP id 006d021491bc7-6b783d62f07mr1483331eaf.53.1788524460754;
        Fri, 04 Sep 2026 05:21:00 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339b608409sm7116019eec.21.2026.09.04.05.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 05:21:00 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Kees Cook <kees@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/3] elf: fix typo "accomodate" in comment
Date: Fri,  4 Sep 2026 17:50:50 +0530
Message-ID: <20260904122054.28531-2-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260904122054.28531-1-hemanth.selam@gmail.com>
References: <20260904122054.28531-1-hemanth.selam@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 036F8C0005
X-Stat-Signature: kjhmsiiz16ntcay4xz1o7rgnm1egyajf
X-Rspam-User: 
X-HE-Tag: 1788524461-932353
X-HE-Meta: U2FsdGVkX1+0YBxfY4immv0qh5INr2ZQwPu5p72oZU4jvF9Vvw8T7/Ghy7LF6oI0JLJRIQw93yMNuhKXb6ZQMGPzcS5/6NjFLAO1TFMZlubfOM1dzc99K431Om+ZA4Fes40ckbTTSDUiaM2ujr/nd+5A6ucS8HL35oXMTFBrm6vkcnCevojAWU95XZqWRJuKplKvaLfpy/lPVT2VQhTLdixycm592hlRs8VtxEdxg/lu6n1KjAIpdfmFHfENKAh8tHAJwX62GTCcRjJFeM8EBZDMAPe8Mou2OuzR1i/SfWfFmdUF0G2NeiPfgsrF8zdCwMKVN70+88PKnmg6cnHLoAo46Po/jIxbrDcdaF0gVARQSIToE2Z2NjVyAv3Ms15Nq0o2LjLZJ8bA3b3KedOCbV8NNpi+hZVdBf3pQCbXsc3l9Ewyb7p74B+bJfA90fIk2eYq2XVQ+Z0fjq5aaIoayrG3O1X7SshG9lhht3+2tiav5GSwuWntu4XF9m1jqnj1tkWL1bTMlWx+5B3itWalM9qlnA0bnaaNchL1C/+R0xUXjvZl27dFlJ1Tl3KuhNo6ZXI7o/lxORcele8JuDFI7KXqNmM1iDI57iznuWdO6nExfBmTOxGcxsgeGjiHMG5JPtbJZ8mh00Fk9vy/4wCbrX68n+inaO44kAxgW3u8BGYEyEIPVe+xNcuyic0Nv7J2iumXKG7drqy2yYIDaFAwI5sy1iCzYTsoYAQuDOm5OaE47zjpRSveM1hMFK7fKQFv+WkUhbK3Mf2zhEQDAqWYDhpmJvynBHbBM39SpVCUw5QFph3J+i5YMJ+rTK9BUSomYCF2KZwA5IhBZ8go29U4vXx3UgLGKoCWo0uCArVQas4N5IfxPMYHRrhHdEZ9m7gKlUrR9uLa5iO84aSfXS4S2a8i7zs7bD2qnvlGHkDVzgudJ7qjWkBf1Kbo8tgMCBIq0LcbJF36nol4Yls3bZO
 do4f4jqD
 /3dY8xcIeQIkDnutnxy96LDAVe6bfx743l7T3782P2JNyFN0MKNjYz7CAVxKpsig6ltl1igGoe7k+q8ZiUGKaWIDpVyk6ToK1y+29UXEaePOeRuhda3hdL7Zp89zXDu6o/fUiUGVUpkW0NT3GObMj3fZc70im7T25i7zng3SnRDTTJ9dQOEZAyolfSxUPIXdMJhblSCtmvRvsCpoknfFJf0S6iVw3cucBV2RG48iBSAYxuOCbuxOYLJPja3OAOMRrjT2wGntN5Io36hv+s4nyHMKqawxDcdxknFGj/0FuauY8DCKIGY14gx3KbKDKFaWutvT225IoUI28EKnBBe29cAX/DTqMs4FTb2mJP7UAQMgeB/dN1t0MHm3P2QS5BlJqfR2dlN5JOtKocnOrX/GWmXXVRUcHDHBG92c3br2M8hpIVHbA6u1L9C7hbhIJX4bBK1Fd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Correct "accomodate" to "accommodate", reported by scripts/checkpatch.pl
using the misspelling list in scripts/spelling.txt.  Only touches comments,
no code changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 include/uapi/linux/elf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index ee30dcd80901..91995dbd3ad3 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -408,7 +408,7 @@ typedef struct elf64_shdr {
 #define NT_AUXV		6
 /*
  * Note to userspace developers: size of NT_SIGINFO note may increase
- * in the future to accomodate more fields, don't assume it is fixed!
+ * in the future to accommodate more fields, don't assume it is fixed!
  */
 #define NN_SIGINFO      "CORE"
 #define NT_SIGINFO      0x53494749
-- 
2.48.1


