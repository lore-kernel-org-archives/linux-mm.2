Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2D18606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 05:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PY5kdhTj
Received: by kanga.kvack.org (Postfix)
	id 899EE6B00EF; Fri, 30 Oct 2026 01:52:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84C1A6B05B2; Fri, 30 Oct 2026 01:52:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 789F06B05B4; Fri, 30 Oct 2026 01:52:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 592876B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 01:52:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 73CEB1A02B4
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 05:52:47 +0000 (UTC)
X-FDA: 85378223574.16.33CDE6B
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9DAB7100008
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 05:52:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=PY5kdhTj;
	spf=pass (imf05.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793339565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VbRiuv1zzZPpsXqO5zwHM0e9x6dnlvGPnhrO6rm2E7A=;
	b=K72tLawHVYjeI3zm1gAN+IYAAgqCdYDPHdXkhUdkrGrnNfH4dRnujXrPmHY1TyWMF2oiA/
	qBNIKlTLfMSsBPJKbDKxqNQApOc1Cdw7UjMlfbHkLQOv4IdrehJGSA+oLS0tym05uGwAl1
	fyiPnfgpkE+bCAt0UDbEILqrEU/Xn4I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793339565;
	b=l+aDUxkPuarS2N84iz/JHzfjH/gbMmJQPpmXdp+VYHxtKzukfQ2ysvqK1UblRccEQqNT4h
	zY6XrG5OoBPGGlrJokRxMHaDBWn9TQzEmE4kBd3EsJ4s5bNwZtAuZoLshYpDkfgRKvdrR+
	uzJvj0vLDSFZIFkFc2mizk+qt7Ngd4c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=PY5kdhTj;
	spf=pass (imf05.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-18cdcfc05ffso416533c88.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793339564; x=1793944364; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=VbRiuv1zzZPpsXqO5zwHM0e9x6dnlvGPnhrO6rm2E7A=;
        b=PY5kdhTjjyGngLWOdZZ12iS0yYkUDpmx4fzGL8lKLB/0zFc26sif9xBPO+QhiG4uc5
         lpKU4FnW43d7ATQzVBPNg+83ncQ4Axv8fadW+uVXGIzeLcFTUqcMKcSXIeGwkGYt9gEt
         wi8vBnSmiIqgGG7pJ1NZj0lQlqaCredUEcn0PRUxKRMhf0kyr4FWHNxw2zkIj01DCA7a
         OrIT12WEVRHPGYPbTxZZJsyrWZTSMIhdNprcOAwnAeV7sWpP0mXzCUjFVmejLCm6EQjq
         K7WcWMCKvLw/lOiGzq91jI370QGhnMhDEhoo9/Fa2/df1vuldoK9ss5O8pfBswDdv1Qc
         kwEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793339564; x=1793944364;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=VbRiuv1zzZPpsXqO5zwHM0e9x6dnlvGPnhrO6rm2E7A=;
        b=2jiobN0ofWkJH2v/P/RlfFc+VV33F11quSk3HiZ4aP45rVlhJeadepel5ju4h9Hp8n
         pQrwTxCIcoO/1Jvjj+j5iyCQLNYZuPAk+Xgxk+Jr8zfyz1i5oZInpdZWEt05jj2RlqRg
         5u0YkB8OX7TRUZ+mZRVnOi9CWvC8/n+ZrDwbT3sa1tyCR7AAeMwBP8ldq3CqbcK5+jEY
         sFQkiVrDo5JHKb04CzRKqjErm7cA1n1px9qvZO7QpMErZNucvtGt7bl2olB0BWryRzP/
         ptxdNNOoy80wTdgCW1VKkF/Z4qxLmdoAbPnG/OKHC6Wd9ZMXrhoK5rj8KuhszB2gHVw9
         3oVA==
X-Forwarded-Encrypted: i=1; AKwUvBzia3QpLQx4QSu9NPiacYfvfzQHjDLuhAeanR5t7cAbPpg8g9upOmBqwefkVToxWrLUFp+3MX1iPg==@kvack.org
X-Gm-Message-State: AFq9FYIZP46BMs+nwjW0NM6CcX/fUBkvzdz1K52OdkmBMRsY1LIeOddw
	UribqsIdzmRuWrlfNMSM9Ojz/tLvS2ofFbiGW2XNOXc0zx3K6VcCNEmB
X-Gm-Gg: AYBFou1QukJ3LFh1ntt4EbaYYaP8ml91CCdYVcFXjhGg1uusFbXx06/no0udKgAkdXR
	k8thhxb8AweL8m5Z66vQjeTKDcM2MQ7h0Nkj/2MpVN0ghSM4R1kgXqstab2KPtk+rODG+n4O/tB
	6R7mdOMv8BhS4+LZGfsS7Rv7Ybi4FF0oCs9oGU4b2uURM7Wtt8Hm96OQ516ePXsEt5rWGFp+pLI
	Rl5yq4a/aY4ZUKldpONAKupY8vjpQHQ8QnjWztLyOpd3mpFKFbgWdwZh26sgDVLC3vtioJHzGf8
	3pkkemOkGJkIstfMrGTUqAETq5jU3aB+LuNRYPxCNJ3nvRX4aRg89VBxhc8B2jyBKrwrF40UOSD
	OULu4YLMUEUJxvet/LVdV+kW6hrlsa6seZQVV5tb4mPqYvohoUwqRAA0bFbjBNYLfbbzYX7mEy0
	h23faBgNFkNPfbPVJpIcABn+WXi4rPdMyOXTTXgfy2H0t+89mUlx0f0U6bfJTJdZHs2SBlGb5zz
	cdANAvPBzXhlkVIsrvRyA2/fQQoZd36HPKWglhvq2e5N5vVjxn+rqXpjGnikHD7QA3sEvExNzKJ
	5ljm4vZK3eWyeTWh1H2SR3ph
X-Received: by 2002:a05:701b:2411:b0:1ac:75b9:f82c with SMTP id a92af1059eb24-1ac75b9f892mr1448025c88.34.1793339564232;
        Thu, 29 Oct 2026 22:52:44 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1b0a628bsm3675448c88.22.2026.10.29.22.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 22:52:43 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Fri, 30 Oct 2026 01:52:38 -0400
Subject: [PATCH] mm/filemap: clear page cache marks once when removing a
 folio
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261030-bug-mm-filemap-init-marks-once-v1-1-699835fc6690@gmail.com>
X-B4-Tracking: v=1; b=H4sIAKUw5GoC/x3NQQ5AMBBA0avIrE1SJCWuIhbTGkxoSYtIxN01l
 m/z/wORg3CENnsg8CVRNp9Q5BnYmfzEKEMylKrUhaoUmnNC53CUlR3tKF4OdBSWiJu3jKaprCb
 StSEDKbIHHuX+B13/vh+gfW5ecAAAAA==
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9DAB7100008
X-Stat-Signature: nwj8yadmhcgr5pubh61sdy48sy35m669
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793339565-832417
X-HE-Meta: U2FsdGVkX18GOcNMc9onqhCFuvmu5v3fpoluOfNbjeSxpVP/NLO5p3cKw3K5czzblQ80+i40OCalf1Wx6p0cxLQLDU5XC7N+9qz1bq9SqyhdYFQBWXR8xwvkzK8wSFLeaxr5K54VYCdH7hKjDP26CR6bmVzOkybcH0W3wsunv8JrmQT3BIwgy2VVjub+ljfuy0uCGkk1F2zIpC05t0jwSVgMVd5HFciDks0iW3aMtxSsjqGMS9ijulEymHTDZMxwDstwkmGK4sdmyJJcwxt3AOs9MOC6eFd6Y/RQq5wlQ1G9IjfNPwQHUw/mnkJABYaOUW20bsjoJl7I7QY/WzTsVZML2tZzdrtLUj+56SyF6YUK4CBo9PYrmMVVtEEvlmuweHPnWYFoKb7t56DEWAntAYjohewVht9SnOWMjnRJ46m6j4v2/AkrW2ry1kGOY+JZzqmbdP+YHEUPiEOXWpEjKYnu5yPqDoBQYblVkzag0aJ0dtLgfoSCvwFLhQ5e1SRLcpjH3hfzG53d8vLylGoWBlzXXuTJB9MLGnBch7m6fn5IPsQLS3AUJeuOB1KOzqSi2++VZOnntnqgPONSXe9J5YBf8H8bIvEjo/5HTU4neDhXqJd+wcDL/Dyq/G5RugubCZA0Hi0uWwqTYGdI/hfT0CxFctT/QBrQ5xnsyvRmEF1qO2SrSTE9uRcgnvdQ+KLib3jELXiaTrBGDrOkiVgmJa7AzeVGYHb3ERivnl7GgdHnCIwA4LUSjMOCkPkyaggHkc+lDP5pXy5Wd1Mb6dS8f29tZa1JCB3coMEhDZBOxp2QuNQrx6PQwFNIeafUbLzobTwyiBV9Bfv9t0Mr2n4Zt5GPuFxf4Ch88E3U42qiswrnal3Cc8FBKDXAAGXpW0+F2/K5eqYyRAuZARxhUAbTnOSREi8hy5dWHNcYnBE2fCUpI7pWaX/8pXuZrO0VSFJil+9bynMs4/ALoApDI7w
 wouY7Kjv
 eT5J4U8+jiXj+7FvOZdrOD/f8UUsxZLniQalcS8TZCdaOgI1Tmgfi0saScWrBI55lkb3AU8UPu6vavERbHgN4ZXJ1ADAjf2Q5MBaM1LEafzVuNMTXiSOh9oxZm+5brgXeLxFWhDbf9av2VtYO5Ic/JocBhydlvahdYDUoKNpbb+o213+IAouK/lG0UhxXn8hq8ANx8m/nAkjD49AR1ExdkaB7oL/nlghjCFMadmP3N2pZpZZQbDttnsiht7EliqZfvWGFIFG9x+PjKIxHagppHNQ1WgOLVWsnUX/Zqsn8kaW+2/sxZzeVXsKz0HOufL79ZngKdBvo36EmG+ZgkuehlT1vBHwsEYsv9cOe9nD0hYvjLihOEo75d9AYRFIqj6Uj1UDB/K2sJQAXbsY6YD2ca+Ndjzn3HzOxlxsUFiuv+QALhFik3S5ZpieT97xE/fg7VpKNJ1/LtwK4AQ3KxG1Jng/MU+e0eyM4604USU+Odpwj802AVtKQ0FksvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

xas_store() clears the marks of an entry before it replaces the entry
with NULL.

page_cache_delete() calls xas_init_marks() after xas_store() whether it
stored a shadow entry or NULL, so a folio removed without a shadow, as
POSIX_FADV_DONTNEED and drop_caches do, has its marks cleared twice.
With 4K folios that is about 6% of the time it takes to drop clean page
cache.

Call xas_init_marks() only after storing a shadow entry, whose marks
xas_store() leaves alone. Dropping 8 GiB of 4K folios, median of five
runs, averaged over two boots of each kernel, in a 32 vCPU VM:

                          before    after
  POSIX_FADV_DONTNEED    1517 ms  1423 ms
  drop_caches            1515 ms  1422 ms

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 mm/filemap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index b74bc1e5015c6..a0c959e74533e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -140,7 +140,8 @@ static void page_cache_delete(struct address_space *mapping,
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 
 	xas_store(&xas, shadow);
-	xas_init_marks(&xas);
+	if (shadow)
+		xas_init_marks(&xas);
 
 	folio->mapping = NULL;
 	/* Leave folio->index set: truncation lookup relies upon it */

---
base-commit: d89e1d186ec9271bf78e62771779e9fc03bf0fc3
change-id: 20261030-bug-mm-filemap-init-marks-once-b83c6aa67bab

Best regards,
-- 
Qiliang Yuan <odys.yuan@gmail.com>


