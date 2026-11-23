Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E573606A335
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 11:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zlw6eqn7
Received: by kanga.kvack.org (Postfix)
	id 3F9546B05B4; Mon, 23 Nov 2026 06:42:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AA0D6B05B5; Mon, 23 Nov 2026 06:42:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C0DF6B05B6; Mon, 23 Nov 2026 06:42:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 00DE96B05B4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:42:01 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 839FDC087F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:42:01 +0000 (UTC)
X-FDA: 85466194842.03.E4E1A4D
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9F24B40002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:41:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zlw6eqn7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of thehajime@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795434119;
	b=OJr1szHTBCOLyl2Mk3MoSrDkXZ+r0AAsC6xMRpcSkuFARQwXQWcqLMrsbjroOQ0BEE9zoX
	sTmhwIQG7qTbjvx1XiWBd8XqiY9E0mqGWiZyWOaf4L6aZCllK4DqqmWAXRKkpjVaFtE9o2
	Zb+8soTuAoQeGputA6nN+5uABLuvGCs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795434119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2pe6kDm4hsS2/g1veafnEkrqROCAZR+w7+EWRL5nhP8=;
	b=UGfX0eqqLLn8S/31zW3lXdEU3lhJ028Q2h1QUPXkcONnCXbQdhbDG8n2ogBXKnghC7him7
	FJnWF29qKLD29Ad7kK3isBBkVMs3bHnqXG7Ald2SL/Apr+sdhwvrVxfgj3czVAyEOFH0WI
	DVWTlJevjo6S8PZfzyoAaZNzEYnXWwM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zlw6eqn7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of thehajime@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=thehajime@gmail.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cd60c5da24cso2043281a12.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795434118; x=1796038918; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:subject:cc:to:from:message-id:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=2pe6kDm4hsS2/g1veafnEkrqROCAZR+w7+EWRL5nhP8=;
        b=zlw6eqn7ImUCrfoLhKiDS9L2mCIWrq/Qoiud2B1rZhr4Af8NftBeNu3n+Kn2P/5jnw
         doWE+q08oiaZ0Hl/HzZZjAvvxehO0TOIuOrK7PGyz3uboD68T1GCUbz48E0jXjuWvRUT
         bBMX3QiTnW2SpbZvZxZZGMajjUDmyIrDmVn56orjYN1YsJKw6rVeY8tl/bkIZ31/dul+
         defGwDOYy6RDNMAyFNR9Q++5ZMhvvZipL05awdemxmMYW42NIQxYZIlvEBq26FI6x/C5
         zRhTaaWEb6FwWUkyni5/iaOwTdbFhW+RrOQJmO8fy529luz2ePB9zRrNdeUshg6WsB98
         bQIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795434118; x=1796038918;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:subject:cc:to:from:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2pe6kDm4hsS2/g1veafnEkrqROCAZR+w7+EWRL5nhP8=;
        b=hpWxFi55eKtZg0VNhwEorqNwdzD2E3cIhaFspp3FzJ2pcL5cnSqn2Pv3/rUokKjZbr
         yvPmGmRgyvY3gi6b4u9rpDjtdBu+IVmn/FCbJSEXT9OEPt0Rp8h4aDPHocgIt/04aMUR
         +tsBEL+bgNvrTCQkzKL0/haKbsZ0/v9TboWeTU4+g5u1gWy3ciCmvSX+cslUdSReQb6j
         A4mSAAaL3WPXUPFfB+6lLNdSKh6vC8vIXFJ7nI0sJzLbeN2xoLqBw6UYU3WkQpxCZyej
         UqaLx89IJYkJDBwvDdZKLu8baxjJUenAqrAY0RsAzz5mWGylRXZd9+5de4mbuQbru+d/
         BPbQ==
X-Forwarded-Encrypted: i=1; AL+hErFm/pgE6JwMcWSxQf3Y0LNmIEYapyJKpbn3my5PZX7kIySSNgkJ+hlnnQ70+EsAGO/X1qnpXsIOkg==@kvack.org
X-Gm-Message-State: APuU4Z8ZVN1mt6SkoykiRt6LFxGKYkwnTGcrJiCkYl0qgzcoKyWIQL0+
	UrkFMKlvDgHcpL2X9Vkq3AG5z/I0O6JEyks8W8RhCVstzaey3JzGfQGi
X-Gm-Gg: AZFdTZc7XIznYzR9xgll42XlBz5+6rfCibw770HPUgA6rDSw89YhtLHybJ60ZbE0l+O
	yUFDs9jPHYLOv9TXY7nBZmBlm1negwDV8JLZ4CI685Pi5j9hj7wDcEgaCUklH75GsstRX6S5688
	2+XZxxv22D6nVw99/QNKwA+yIs9swMKzzBAa1kWX+r97BGgMvgODFyonYIsELuGUgoFCF+ZTc3K
	zUSSgajDzc5bysNck8fXL1wuM5vmvzB1jWCDvi8EIJ5nP7ZOlX612hXcToGJgFsE0JxIV2o4KWs
	P+pdSK8QbqHQygZuoKiTklL4GVnIqmwyLnRWxEnNTux5aGn1rohKZ+myZc5dIsR1aad6LJDxYQ1
	VfTxqhUrUULnDBrnUG1TP0a4fb0FgWT0SZ/I6kZTW5wAk+zGdNYF3Xfe1jukYvM2RZEvq4KCliJ
	aYJM/w86Fq/A5uJdPYxNhqCILRFVagi88nURQCpE9LjUHqr3xaMuaH7AJqAZ2pCzd8k+bK2XZ24
	RQi1N0nx5TizgnBOuJ+Q/yoSgQSP2sUmS67hLCUdm7rZyUOWBNaLrM7u1T4Vbyvfafb8TIRqJrC
	UHtEY2zIgns2MCzNgfFiVYMNRs+bFXIehjPXuPyb7/LglCusfTUPo5lgBdHF6moXTYSzKI5qs55
	dQlkyLlFVyaCHSClFFs7lTqrUCckjrWCRoJALne0APgtK/zWRfIZq4cXmavdDf7AGykRmhHlfZD
	r//olcWkGFwiBlbqQPLfA5cBuKcf3lmgLR/aGj7VI=
X-Received: by 2002:a17:90b:4d89:b0:3b4:3c33:3e5d with SMTP id 98e67ed59e1d1-3b43c334caemr4444363a91.67.1795434118309;
        Mon, 23 Nov 2026 03:41:58 -0800 (PST)
Received: from mercury.gmail.com (221x241x217x81.ap221.ftth.ucom.ne.jp. [221.241.217.81])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b44b8c2fcesm5775530a91.4.2026.11.23.03.41.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 03:41:57 -0800 (PST)
Date: Mon, 23 Nov 2026 20:41:54 +0900
Message-ID: <87v75nsrjx.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: brad@sim.vu
Cc: akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	david@kernel.org,
	surenb@google.com,
	shakeel.butt@linux.dev,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/nommu: keep the maple tree in step when mremap() resizes in place
In-Reply-To: <20261121083139.803682-1-brad@sim.vu>
References: <20261121083139.803682-1-brad@sim.vu>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/31.1 Mule/6.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: multipart/mixed;
 boundary="Multipart_Mon_Nov_23_20:41:52_2026-1"
Content-Transfer-Encoding: binary
X-Stat-Signature: 7apookybkoc6qmcp9u1xodq6sm7czero
X-Rspam-User:
X-Rspamd-Queue-Id: 9F24B40002
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795434119-613490
X-HE-Meta: U2FsdGVkX1+RVrrHD4MGBMJc5OU8W5p/drDOofm2kMb4wRZoeXqaw4LLoX8cJQ1PEIjEr+kNPeIUec3GIJdpe5CaROXFEA33UBnAcl5VENsP228y+VPoGKIZUPRcXlF808akChPDKeEr84ozotJYi++jhbEkDhq5doMjomq0DJDAy+cYoYGHXacYZ6U0TeoqrIK7yp1JswJRk2XK2Z7JSpUrmp1+VnFIfO0ClS9NI+dDM+hcdrA6UeagNZfPgMjLhUUlPqijfous2snq7le7zWFJGFES59Ook/zkeQ20OvmIYjGQfGdV8+YCS+DjVvVgqGQznX84fF1yYlMW949dRhU+vtmiDngk5oKoAMO1kysSg1jnbXsOOfTXpu+l2vFAZze+s7L5WHsfbcte1p5jvfQAmlIUQTKqGgT0+vIMOvV3ejjDSGIYxOMYz6WpA5oDePN/WE/yVGYxi5D124kxgMWlI2LcouaPUwUcnzVTGwxRw6HG8FCLhkqUqb4HVF+WYQ/AB0q+QW9gb+Jt5F6FW26v372QB/H+E0JsQZLfqAAuFF0az1c4jsu6UFb/XhTG+YTkz6d7m+gFiuR1Xa6Ul0RCUNdlWn+F0lwutNhViRaQ0d85CSbAlQokLIx0ph4tlSY5eTlYJG0gOP1It/R1Wpw0bEjF4MM4xaxwAISxx8EebIRpCGVD2ozXTkoYYMGBJqbfcVsgINMK7Pzf/NA7wxfYEHYWSJg3sEn3DadPVaAhhPpB6xwhVJ/zrWvcGtoSoGRy+FYLA6xMyklsSoTBcCCUszYnHeWQYwQpIno7RQWNeShrUhab8Nb0ZaZtQcQ056I0IqCqQCk2GWxGj1hd6PhZnPgJVFVyfOnC5bOZO59iWEsNqM9jmghhC2yLdxYFI/nVC8XSTCSc1C6WkB3JQt/4sVA5N6v4qugTCT9C3TDS5FlUsD5cE3hCT5noQkbgHVnAZfUgT0N+ldq210e
 W+9NEqag
 F5RYARm8oDEcrCeBP/E2sLnKLwdHX6RSkFXpsnNu05PGf4xudSa5WtN2fV8+lfVd3/Ou40N87QMu/jE+nbS0tZKPX0H3Vcfuk/HGSBZid+bcok+2sxlL2jry7tDYlW43p35HT5tC5VHEMhTi5TU0v/fLTNVmzzIgAbuI3NT4x3AqK2Etwezte4FzGJFyipKIysilqBJPEt2499M7wcC31qoI3URnyLpO2FPGUm2ZpKanFBAoJl6j80lqEG9cGmfTtcg8yITKPpOKxlzpRMLtBRZq6CqriQ0e7jvej298J/bDdxSQnZDCa4mY4oroRUt/AZ4YtzGUswcO5TYmUjGWIRZlwG8hUiVxbdpMjRu8r4nx7oSzpUUOoCr7Z4PMm1gVRucL+r4lYJ/g6UXEAd2DvzajHf7rqtFhx9UeUQWGhQ+UAAqCfemj6FaSD301z+lLUdzlsrwEZH3CGEv40F3Ew48LqI+HhUemd9H3C/XOQnBW7OeLaxihNfBwHV5Ao7dXboRX14Z9qQtnHGcNQaghVvbNufO4vWdhAOmTTHxNfmn7e8mq4B7Gup8wl/wQ+egmPyTAEK6ADpEtcRhwO/hCo7i5wSlpnEz1PbDvdXVAV8iRLmcYkWJ3I9mUqpbJe18+J9Ej74E3OrwrnTNEbf/FwHjGOVJbYen40mlxht3Xq+geE1eursoqUMEX7YdBUYcn7ER8A9RlLo/P3zKj6l2EjtRlVN3bGbE8epZJU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--Multipart_Mon_Nov_23_20:41:52_2026-1
Content-Type: text/plain; charset=US-ASCII


Hello Brad,

On Sat, 21 Nov 2026 17:31:39 +0900,
Brad Hawthorne wrote:
> 
> On !MMU, do_mremap() resizes a VMA by writing vma->vm_end and nothing
> else, so mm->mm_mt keeps the old extent.
(snip)
> Sashiko's review of Hajime Tazaki's nommu series found the stale range
> in July, and his fixes and RFC since then cover it [1][2]; review asked
> for a minimal fix-only patch with a Fixes: tag [3]. This is a minimal
> version of that fix.
> 
> The consequence was reproduced and this patch drafted with an AI coding
> assistant (Claude, Anthropic): it reviewed mm/nommu.c, wrote the
> reproducer and ran the board and QEMU tests; I checked the result.
> Stable backports need adjusting: 6.6.y and 6.12.y lack
> vma_iter_store_overwrite(), and 6.1.y nommu uses the ma_state API.
> 
> Link: https://lore.kernel.org/linux-mm/20260710021028.892645-1-thehajime@gmail.com/ [1]
> Link: https://lore.kernel.org/linux-mm/20260813063401.1786548-2-thehajime@gmail.com/ [2]
> Link: https://lore.kernel.org/linux-mm/an77pELeQdW-sTEi@lucifer/ [3]
> Fixes: 524e00b36e8c ("mm: remove rb tree.")
> Cc: Hajime Tazaki <thehajime@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Brad Hawthorne <brad@sim.vu>
> ---
> Hajime, as you asked, here it is as a separate patch with you on Cc.
> Earlier note, and his reply: https://lore.kernel.org/linux-mm/20261120221021.789792-1-brad@sim.vu/

my earlier patchset contains a kselftest case, which tried to test the
issue which your patch addressed.  Part of kselftest is now upstreamed
and I would add the additional one specifically for the case of this
issue (this patch addressed).

Attached is locally tested kselftest with your patch.  Would be nice
to include this in your next spin as a part of patchset.

-- Hajime


--Multipart_Mon_Nov_23_20:41:52_2026-1
Content-Type: text/plain; type=patch; name="0001-selftests-nommu-test-mremap-grow-after-shrink.patch"; charset=US-ASCII
Content-Disposition: attachment; filename="0001-selftests-nommu-test-mremap-grow-after-shrink.patch"
Content-Transfer-Encoding: binary

From 608869187e388e16e4c2b2caf5a174c3a424dd7b Mon Sep 17 00:00:00 2001
From: Hajime Tazaki <thehajime@gmail.com>
Date: Mon, 23 Nov 2026 20:24:08 +0900
Subject: [PATCH] selftests/nommu: test mremap grow after shrink

The existing mremap shrink test covers dropping the old extent.  Growing
a shortened VMA must also store its restored extent in the maple tree.
Shrink an anonymous mapping, grow it back, then partially unmap the
regrown tail and the remainder to exercise that tree update.

Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
---
 .../selftests/nommu/nommu_mremap_test.c       | 58 ++++++++++++++++++-
 1 file changed, 57 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/nommu/nommu_mremap_test.c b/tools/testing/selftests/nommu/nommu_mremap_test.c
index 6ee89cb25f61..550c21fadbf4 100644
--- a/tools/testing/selftests/nommu/nommu_mremap_test.c
+++ b/tools/testing/selftests/nommu/nommu_mremap_test.c
@@ -133,6 +133,61 @@ static void mremap_shrink_test(void)
 	ksft_test_result_pass("mremap shrink\n");
 }
 
+/* mremap_shrink_test() covers stale entries after shrink; test regrowth here. */
+static void mremap_shrink_grow_test(void)
+{
+	void *addr, *addr2;
+	int cleanup, head, tail;
+
+	if (!nommu) {
+		ksft_test_result_skip("NOMMU only\n");
+		return;
+	}
+
+	addr = mmap(NULL, ps * 8, PROT_READ | PROT_WRITE,
+		    MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (addr == MAP_FAILED) {
+		ksft_test_result_error("mmap failed: %s\n", strerror(errno));
+		return;
+	}
+
+	addr2 = mremap(addr, ps * 8, ps * 4, 0);
+	if (addr2 == MAP_FAILED) {
+		ksft_test_result_fail("mremap shrink failed: %s\n", strerror(errno));
+		if (munmap(addr, ps * 8))
+			ksft_print_msg("cleanup after shrink failure failed: %s\n",
+				       strerror(errno));
+		return;
+	}
+
+	addr = mremap(addr2, ps * 4, ps * 8, 0);
+	if (addr == MAP_FAILED) {
+		ksft_test_result_fail("mremap grow failed: %s\n", strerror(errno));
+		if (munmap(addr2, ps * 4))
+			ksft_print_msg("cleanup after grow failure failed: %s\n",
+				       strerror(errno));
+		return;
+	}
+	if (munmap(addr + ps * 4, ps * 4)) {
+		ksft_test_result_fail("munmap grown range failed: %s\n", strerror(errno));
+		cleanup = munmap(addr, ps * 8);
+		if (cleanup) {
+			head = munmap(addr, ps * 4);
+			tail = munmap(addr + ps * 4, ps * 4);
+			cleanup = head || tail;
+		}
+		if (cleanup)
+			ksft_print_msg("cleanup after munmap failure failed: %s\n",
+				       strerror(errno));
+		return;
+	}
+	if (munmap(addr, ps * 4)) {
+		ksft_test_result_fail("munmap failed: %s\n", strerror(errno));
+		return;
+	}
+	ksft_test_result_pass("mremap shrink and grow\n");
+}
+
 static int get_shared_writable_file_expected_error(const char *path)
 {
 	if (nommu && get_fs_type(path) == RAMFS_MAGIC)
@@ -344,10 +399,11 @@ int main(int argc, char **argv)
 
 	ps = sysconf(_SC_PAGESIZE);
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(mremap_cases) + 2);
+	ksft_set_plan(ARRAY_SIZE(mremap_cases) + 3);
 
 	munmap_shrink_test();
 	mremap_shrink_test();
+	mremap_shrink_grow_test();
 
 	for (i = 0; i < (int)ARRAY_SIZE(mremap_cases); i++)
 		run_mremap_test(&mremap_cases[i]);
-- 
2.43.0


--Multipart_Mon_Nov_23_20:41:52_2026-1--

