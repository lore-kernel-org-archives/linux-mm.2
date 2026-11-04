Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15E4B606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 18:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DBRLuFS/
Received: by kanga.kvack.org (Postfix)
	id 725276B05B3; Wed,  4 Nov 2026 13:38:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B8C76B05B7; Wed,  4 Nov 2026 13:38:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48B326B05B5; Wed,  4 Nov 2026 13:38:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1E2CC6B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:38:05 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9BADA120732
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:38:04 +0000 (UTC)
X-FDA: 85398296088.22.33C8BC6
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id ACB65A0005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:38:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="DBRLuFS/";
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of 2dgodoy01227@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=2dgodoy01227@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793817482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5CJ4YCQzJ9RJKX3QjI84ekC4PN6T/7hvVM512TSC4LE=;
	b=LXF/Ay46hZZK8JpOciTPNw3Bosr9lwQLL3ynFZUUS3IeOEUfMJszMIFgyuIVnGtM0y1JrH
	lHIDi0k81E97bj7Yb3XqObe1XjaWe5KH/gI5Bnn7Qh3gXs0p7pR/SNYNAV6s2rGAHZfX0/
	ePfb5GR8BwBhdReoyOomsNEFPDX3EX0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793817482;
	b=OGMhRJPHigVatqt+5P6m9w77awNPxyH81QFWhWCdh5dj8WGLSsf7yeRbTGrd5ah6qUyu/8
	BDWCFcPlnwgsUeq4fp31A+SJZlH02Wf9pbETJu06MilxfOUM48c1ESEHsXSKNwT/2ksrPr
	Jp6IOZUQmqAMDrh/716WfGayhHvJDqw=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="DBRLuFS/";
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of 2dgodoy01227@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=2dgodoy01227@gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3ad41b47541so832377a91.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 10:38:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793817481; cv=none;
        d=google.com; s=arc-20260327;
        b=KowgDpkZcyxhaB0KDjXEhqBVMZpwZQoBcsDjWyX51Tf1e1zbh2OI8Blidokhcdw9Hg
         2FAntbImI0HTp95UUyOkO1OFpbWrGPUv9+w9qz+Iy4KmeWwkAfjkLy2mG4NbWB81tdIc
         4kaU4DbS7jrIXaUKjG0UD6bPaKNG3X5gOw5YlNoTgw5jsUmr0UHvTYbAmJCGO4zcxu5d
         PLLgMW7LkukdtkgKgrF52+sddtYnZn1zzqxSe0gSwLL6myx0dgHL7T8l5FTiojMl4Bdd
         ePOCUF9xKhemuwYpWDeCZaXw/I7QnsE5KPGiqH6EHFsw6ONAoT8G3kRDbTV96Yhp4eg8
         9dZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=5CJ4YCQzJ9RJKX3QjI84ekC4PN6T/7hvVM512TSC4LE=;
        fh=YxaQX7GTjfBsN7A2Jl+A9yP6mmGOQanoqU6QROKhVaA=;
        b=WuQcC5xpxtZdOJGHmzkjAgUEdZfQC4xEEeF0O3FF28EKHVCZ7q+lZS0TjeY00F+P6w
         hRYHM/MJmaCGbDbkbPSBn+iKoeVOl/k0IJRLRsZwWRO40gBtoxDvpckzwfBHzwjpGiRD
         R2CTlM3h7hi0eCGhUwktgjBE3PqjHazlwMFU96zThURkDD+p1hFVXxM6Qqs26B/RXsjB
         sYv+c9uwJvpLdfu82MD70ro6OLSjjle+v86NT8JSzrd7bmejb3q8UT6x4NxC8KxBQuiG
         kaSGoTRFGAgiQpcBk/oO75U+vn9ifbMElFbS+NWrEX7XYI3rAC40pvs1EsZFdAs2+kYO
         9FcA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793817481; x=1794422281; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5CJ4YCQzJ9RJKX3QjI84ekC4PN6T/7hvVM512TSC4LE=;
        b=DBRLuFS/u+OoKkUKM2THbz+qis1J0bUxGmxFpB0f3CHkE5tyUVN6tbiQ917dI8ZiTi
         lBatcqIw/vn3SJSZCwQVO1dNPmlnKseK086pj5iJPqgG31Kpo0wtEJluVKFfCqyOhDsN
         dgxDIfOtsv7xK5WXkVnBs0VEx0lqyWv+rn+HNAvtQbGzmgfF9m6ehk9NHgodVdRh/M7U
         fwrk29IxtnUUrlWqHABNaQFqjqK05suBDWJmoIxiyaIE7kXzFlSaG0d756O4RUXt64tE
         5GEorWPLL/zc+qvGqqCmZkAmDLljJluRZSjvMM9sA/qdE+2lHe/JperWoyNcWS9GZFQe
         WylQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793817481; x=1794422281;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=5CJ4YCQzJ9RJKX3QjI84ekC4PN6T/7hvVM512TSC4LE=;
        b=xPH3P0dDUQzkrmdos+hMyiKMFgwxq0mBDDdf6wguButq3lUwbAz91h0KxopKA9g1gJ
         Og/5fdkOv4z9ULR7DK9+TZJj2KS97zGrwIhiFkuX0V+NJnuaIpMUIdGKETWbgpu2DbXK
         AcRL/EOzE9hH7x0v6QyuOFwKFeQR3A+IIiNPQYnfzb1Scn9zaexrXWMr5+Zbko0pyu/s
         mKVioH0A1GUUC0HXuQ6G1ghXwPk01v/x5q50iNQ71Gj94L2KKYODxSltlxpqljxcjLpE
         InPlk+SuYX5PZrqv3GsxWSpUQghahO59RUMNLw9FuHhysBAPy+8mNXhGkpAsXo/1v+tc
         eJbw==
X-Gm-Message-State: APuU4Z9xTX9PH/9hWwUFUNN4xdt/2/m8d9luVtlk++Lw0IBqhsEChqJM
	beiQEdWW9zou3ezaiBrVXrMII8JgzH7V2KLhE80KbOQkOmtz6t4wWTcXEUhKQZE+haPodR8gju7
	peN0UgVZ66zUtixujev0zDpZrpNeHUf0=
X-Gm-Gg: AYBFou2pgTl+fRyapYTSjpn2YwylsNt9dFh10BmnnXYsH4xJeA48fmrifn1xFaIVLbE
	lkJB9LR3pZKer8qFXre7YnnFqNE2zqqJKYvSgaZ98zLPLgWNDKh/ZoIMr0fjIpoRmEbVj2TT25N
	FU3WEYtJwma0DewJHO106AV0m/4jP49heT/eu/YZ1dwjdwlSH3OqsJBHdJQ3anY69EndTBboE0p
	86/G/FKDNNk4EhAjCE0yDOpb6QBqGqeaXEplJPV6PRLNR3XlcPs3yEZ9deaGNI5z/cUb077xbUC
	psNGFPwmFotO/tHpkMTvRP6kN8oMNwk4lv3PMhPYLhbUTY77pIaVNjf56DOQjXY8SNZiD81Jvl6
	u1O2ofOc3+AER/JBQY1QYp/92z9+VcJJUySjTDaRdiiiAjqs61tR//Vk0JYBqL005o4fX
X-Received: by 2002:a17:90b:1c10:b0:39e:6a80:b799 with SMTP id
 98e67ed59e1d1-3ae89799522mr15326503a91.41.1793817481541; Wed, 04 Nov 2026
 10:38:01 -0800 (PST)
Received: from 511566560828 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 4 Nov 2026 18:38:00 +0000
Received: from 511566560828 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 4 Nov 2026 18:38:00 +0000
From: 2-D Godoy <2dgodoy01227@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Wed, 4 Nov 2026 18:38:00 +0000
X-Gm-Features: AclHuK_uUvW349hUDFCVLsr_g6yC4UK8HN-OOATBy6dK-CZmFIzlH2g_59RQy8M
Message-ID: <CAL1HEBDTP=A32fCM-LK_2WKFFJ4inuk7Nt0BPvGTGpgpr0pgxw@mail.gmail.com>
Subject: [PATCH 3/3] tools/mm: keep the allocator scan inside the record
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: i9sbn7mpajxtmo184q4384b6hfkzkn1w
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ACB65A0005
X-HE-Tag: 1793817482-471299
X-HE-Meta: U2FsdGVkX18KFoiGkpCLn/993IFLpQHV5w40D3Kj6a/x/uCKg/ukB67tr46B1fSwF2kx8d1szHGmb4FszR1CyGZM2bXGAq2nwOESy4ldybVdum0ppKolemI6elPOp2pP3qFWjwzVi5osGOyAvWabfVtvdLyunhxI7AxDrBxUMFAyiNwKc/W/YKEy86j1GHxqJYmbxSc1s4ucnn/CLsnt2PT1qufQxImtsB7crhnhlIe0YzUW192EeTwYVQa0g5nHnnNrZJdiuA+/nznjTBdFojMPIx0yx8G3cR0617c/HoWuCb76wnZklRl3YebmciSDrbqm29QqCGVcaEfk80WMrnwwuJuw7FW3EiJACsnAxXy/H82zk7LaipwLlFpeSnhEZVeMZDlR9sbGswXhz/c4k62XJNmOf5Ss4blz3DTFbrzo1wRH5eyrwsmd1jXCTclBbncFxO0dGSRXBPTIPBYgwwDi0AV8nQfbXmKO8NnKbfSUaxT6npAVqV+iuD/ClyUMORyvMVG9Q/mb2w0qCW7nm+G3j3Xm3BLehJRrrkqhSOUw5ngBLBwSj5d9I4buP8VN6KQmgbjxDnEMSB1eij5F8UgjuvP+yT7qKBb3xar1rzhjEK69mxO4mdkkZfNYLfMfZPf2k4IKLgIJoJmlXVM/qfMZKxMxj5tWsa+j0O8Xo17VfwBP0j5DnMVVOKpYF1inHlLflXrY7fW9YqryziK/C4ChYJnRGYj8KcJEHuo1cbmlnqrQ8AT7UJDBN/n9d9vy+rk8181SsHfxUq4IXYPG5nDGEL5MdvXsxFWkdTwbpDt6sbltICXdaYNMS0f8hpdHgjPYcEF646ZSW/fEBRkRkMiXfefDgezVMoiGd+FcQM17Uh3GDrNLUMZT9ik8ynqcQ10xl7E2T9xdpKeqaM5/b/kx5vy0ZYufaY9nVil4Qj4TcmwNNkPDFTNcDhAOA5uViiVVinO1xXqraqBFJd2
 KkRRhcG6
 P5hyHfT8kkX8j+VFJopoJxOAOhkx/KAHD11MBIcAyfe/3eI8G6jU/UO0Ho+RTFASjdrHL86Dg7sCYLC0D9ZND1RYf46C8EIIdn5HSH74XZCr9G1PBdSQmKGgna8snw/XKHuW9WHy+72ulrPqAofbhjq3EmVrhQ7ZLAzCVYjZgF8WV7JQJ8e9c2K7Zbd+Hbyx3il0QfZ+LcEkInSOF/YZjVZUKIzsPDan5d/2xNpgrVhaSTeK/lhBbln8zt+3G7eDMdecQ9/Iyy70DEX03fMZbVrWbh3xBKrgYkGdm+0S9zel8w3rJs7X9iSkEgDggaw0/8IW64NmCMh4TnlBMsB8GP1Y8SOUU/iXd0SYFnbdjhY0QrIQIHjUEAxjqBYu9ccsfBbi+Yy8Ly7oR0AcwrBQjpxbzjy01zQV4NEPCJfxeh+jDZpYOBSxGSD7gvU3+akDzvu1hlT0wZwV1KCsLJgVM1BEi6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

get_allocator() looks for the frame above __vmalloc_node_range by walking
back to the second newline before it, without checking where the buffer
starts.  When the vmalloc frame is the first stack entry of the record the
walk leaves the buffer and reads before it:

  ERROR: AddressSanitizer: heap-buffer-overflow
  READ of size 1, 1 byte to the left of a 131072-byte region
      #0 get_allocator tools/mm/page_owner_sort.c:501
      #1 add_list tools/mm/page_owner_sort.c:606

Remember the beginning of the line and stop at the start of the buffer.

Signed-off-by: Henrique Godoy <henrique.godoy@cloudwalk.io>
---
 tools/mm/page_owner_sort.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
index e56375f..f978988 100644
--- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -483,6 +483,18 @@ static int get_arg_type(const char *arg)
 	}
 }

+/*
+ * Return the beginning of the line holding @pos, never going back past the
+ * start of the buffer.
+ */
+static char *line_start(const char *buf, char *pos)
+{
+	while (pos > buf && pos[-1] != '\n')
+		pos--;
+
+	return pos;
+}
+
 static int get_allocator(const char *buf, const char *migrate_info)
 {
 	char *tmp, *first_line, *second_line;
@@ -495,13 +507,10 @@ static int get_allocator(const char *buf, const
char *migrate_info)
 	tmp = strstr(buf, "__vmalloc_node_range");
 	if (tmp) {
 		second_line = tmp;
-		while (*tmp != '\n')
-			tmp--;
-		tmp--;
-		while (*tmp != '\n')
-			tmp--;
-		first_line = ++tmp;
-		tmp = strstr(tmp, "alloc_pages");
+		first_line = line_start(buf, tmp);
+		if (first_line > buf)
+			first_line = line_start(buf, first_line - 1);
+		tmp = strstr(first_line, "alloc_pages");
 		if (tmp && first_line <= tmp && tmp < second_line)
 			allocator |= ALLOCATOR_VMALLOC;
 	}
-- 
2.39.5

