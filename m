Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E62D606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 03:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dAVxtSdE
Received: by kanga.kvack.org (Postfix)
	id 287746B08D8; Tue, 24 Nov 2026 22:04:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23CEE6B08D9; Tue, 24 Nov 2026 22:04:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14DAC6B08DA; Tue, 24 Nov 2026 22:04:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC9AA6B08D8
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 22:04:44 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 486A5160D0F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 03:04:44 +0000 (UTC)
X-FDA: 85472148888.15.7B23C95
Received: from mail-pj2-f5.google.com (mail-pj2-f5.google.com [74.125.227.133])
	by imf23.hostedemail.com (Postfix) with ESMTP id 91920140002
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 03:04:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dAVxtSdE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of bsdhenrymartin@gmail.com designates 74.125.227.133 as permitted sender) smtp.mailfrom=bsdhenrymartin@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795575882;
	b=E/u5ChfpiCokvXFg6VrOnOSgbDetlfnrzGPlrvTcLrBADeE/v4ZnVBZxQhuVYSSteQ2PKu
	HsstV7pbzw1Df0XZnXufJxf9ws+k+PEt1wnkEMg0wQnEdCgb67aXfIyvD2gnzVKmrfbPLw
	K1kehUlhB1hsaIzoNLTIiVPUSApmRxg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795575882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=eX4/tC2R5B5mthZ/Pbn5Ck0uCjL/h6zZMuH7cLWUB8o=;
	b=VQmn9dwpSe+HrqSDOYqKbs/5vP5me4Hq4HSY2zMOR2e1ADm93HWtrcxHPHmmCtJ9lVplwB
	kcDGmH4z8gjJMljhVN9BzMXibHcho0pO1XayluurhLIt1t3m5HUyj81DpKrZEBt1jjrKYT
	aVgBVFCxXUpDwO7iK/AkKnabUksDHFs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dAVxtSdE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of bsdhenrymartin@gmail.com designates 74.125.227.133 as permitted sender) smtp.mailfrom=bsdhenrymartin@gmail.com
Received: by mail-pj2-f5.google.com with SMTP id d9443c01a7336-2f04158d3cbso18481095ad.0
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 19:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795575881; x=1796180681; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eX4/tC2R5B5mthZ/Pbn5Ck0uCjL/h6zZMuH7cLWUB8o=;
        b=dAVxtSdEGOcEQt8XfSvM1u0eLZF0FCc8CtzTdZtARkmdW+Evrh6RJPiNy3ivHpCW8T
         mdURFVETJwMtt3mv6Jhl4j7NJ7cOD9IRrMZteEbdDrnHx4ik4eNhjedGCApYXfTR7/54
         wHbs8kfE0ZgOQ5JvOjfT4Z+Igg9FeVpg6Lod2DvPXtetaQ7tH6F6RHW6xZA2lJ4A1oOa
         9k+jnFedvbvG2M4rjjbCVjK1LB6vEPvAwFmIhKjpWtnBf2rT5rqoZwjO9/2vby7eDkp0
         jvIOLC6wfNLYLXibv9TAf1zygyZXK/DXBEGrxZaODtoV0EfFMpwu9rG2JqFbICggIyl7
         FXDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795575881; x=1796180681;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eX4/tC2R5B5mthZ/Pbn5Ck0uCjL/h6zZMuH7cLWUB8o=;
        b=p+D+tiSmr9rcU7K+SwoovkCQWzKPsi2EON8qYY2UiX9f9BtQeFb5FAzIOcCfXoTRg0
         /abK8mU6vNuIgOEmcxVEUWKP7noR/50WQBZgKk8uuCwbXLLXQT3eldI1pBG2dVzivDQn
         xFRbEn6/dMvuS4hPd8pFe7U3ZxM34N0VBKN4CwGg4V24Xrqvb3vk31+ETEYNy31gQ6R+
         Q9to5ofYtGdWLUs5COLN0Z7YeCIyhD2zuxLIJm2VgdZxYy4sifCLcZs1cyo4sd050KCF
         xJWLxaJ2cqHk47c5KnPmwdUMR+fBBvFmGw9nOFa9zB7iKWOFvqE4KFpQPa0o8z2NNlQ3
         SfAA==
X-Forwarded-Encrypted: i=1; AL+hErHz3DS0DbFy70W5/UxnDxIhIEhWyiph0071FVfcJ95QsFqx26mc8DgYgQERzzHm3tCwhu6dARHF3w==@kvack.org
X-Gm-Message-State: APuU4Z9eA4/qz+ca7UxYL3zYrZkSP3VCa0K7xarPDDhYaWVjdq7ALoE0
	jLSoUglau2V17XPbYq9EgQSX0yjsGMfu/EkzR4za8DB0voympdOQUeaG
X-Gm-Gg: AZFdTZdPo/ULNeouQuC+Enr4L/BtC4iXpipbTDU41D0K226IBzzG/DJHOh8tc6mSt7d
	fsmv5lyXA1wSKWnsix/a4o+KqhEWU/rnSLi6os+8+crHmxLtebES9P4YApqubV1+hS8LFtBfDay
	Lh4pzXhUMOwVx9fDrUh5jCDQpIhb61hiO9iOPeqqaL/AcWD9KaKv12PNIAiCzKacU6XwNkXLIMp
	SEOBJNk9iHLWWrp75fRiymU9FRKqtJytLnW1dwRgQi6C2UR7PpZfdDzN2Y3JaEX5ry18yD4tApQ
	/ELakjRy2+ZRBVV4FsBaSJvvS+X8fylsS1xKDWlWEV/n8iAC4KHJIsj50abecPBIlGRTLwFz/iU
	dS4Tob0Lx8o7mbx3dLWYsacTbTAcgfim8bZnB8uLLhDH40ZUjuA2SlYQ3iIG1PwXuvbEMAh5uuV
	et4Pi/tnV4db/WNggf6O/uDOptWVJPvIwb526pKNnmNffuwnsd3uXZRy9UOWgmniWGnUyD0hRR3
	JZqpQhBf4bJrmcMOfLpMde+IQKb+yh4kpUFLm0A2eL3vb6QcZdh1fEz8vlk8uXM/+un/RZpRmYx
	qlzKioNnypQTDM/lIuM5/1rvXhl8PU7mBtni7hlZ7xrTVOCwkIMJFQ7ZSv5wUkZTmfQR45xN9A=
	=
X-Received: by 2002:a05:6372:a705:b0:3fb:3d85:ef60 with SMTP id adf61e73a8af0-4014e45d185mr12947493637.60.1795575880940;
        Tue, 24 Nov 2026 19:04:40 -0800 (PST)
Received: from BSDHENRYMA-PC1.localdomain ([43.132.141.6])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6cea7c38sm8091113a12.2.2026.11.24.19.04.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 19:04:39 -0800 (PST)
From: Henry Martin <bsdhenrymartin@gmail.com>
To: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Henry Martin <bsdhenrymartin@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] mm: report all-zero cachestat for DAX mappings
Date: Wed, 25 Nov 2026 11:04:32 +0800
Message-ID: <20261125030432.274396-1-bsdhenrymartin@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: hf66qk14ht55xj57mmiej7ut8wzbdtmg
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 91920140002
X-Rspam-User:
X-HE-Tag: 1795575882-618800
X-HE-Meta: U2FsdGVkX18zXc89tLgGHmf083efkH30OGXsVMgFCxuNXFjrdrUZECFx83/CKzssa/SRqALMLivAqWKh8irL5HcfsDgBwzshyODKmriHI2Np9MW04wkZJoK9qFLAenHlG62fcC8AoLN8R3ztVlz4W+Tv9y/OlerAkb/rJCU3yFXb7XRRZA206xfLXNlDpyUF7jda1xURTuLTxnTlLKBa5bauSBTgcIGPBXsH2wJmjhZNXGYb4nbVH86Ip3J4I/bBf98lmAz1do3y2cOoXcivg7chbQrkBaJygkW+6M/TTkDIrzTJNet2pmy4QuiBbIDLUKcDNr5UKEP68TtIRyC9zzU5SzBbBLrYPhZQFsvEcQFQYh8xqWeaXqKCkagLd4LUzb+wlHkuyUOa1LQggsZinMUTtFP5Q1eQ2G7ha88NegjetL+lD4Zpnz1rhi66LLuXf2cITBoylvc9PLE4reZxiU17SY47LMF3QgB924qK3mFqUs9oRIf7jiS1D13skazHiQqkTjzhyHU0hGox/WJtlA+LjsxqZzSFJmB+wPpjyfoD+8Fa0HhEiwWKUoAzYPL4fUhlc0HVRrzYGVBqeLIBWXWJILMzGYMtNKL0VAIm8+tJxYW21ZDjOKTJgWmOq9O+Ms4tomuJwQw+G/wPycE37Q4xtjvUfO11skMyIBwlm6hBc0fMcWrUMNKNS9fziqTszy5f4FC6kzZel81F4qbdrsDtPwki6y74yyZcHjDWQNBkiAtfL0TraUp1IRivQQJxW68jIlIo9ihb5eD7Dn1QMtvtR6Qx2RxBuWsnI+Vv/2ahnzt2LyNYt97pBnY3M0gjbkC5cMMw1N3+a0Fht6d+rHW1a1lOjO6CpEMVuTVuPRw9gL2t4bfjwwI3tgnz4ozTc8tkZFuIc//qyLJ8JGJTDbM9fM1AijfWGQN4Q8bTtYVFH2J0BdycddXXkMpQ92As5a6P41zOc7177NQdmYr
 NLMHv8Vw
 77+aB+qTLKBH8UWfYM6sJMgs37pFFBw0ioPpklD7tdv9s/zCGKi43Xi4Jwy0PPAGbVhd2RSL9LoR09mMtp8dW+PkslhMwgC6X8tzk1CLOOO+PpwV6ulHxkxljExsYw6Io1xpYIvhFK/19TxiU8EZ9mPHE7hKwS1FxntCQqvv5Snh9/n5SLdSCLbbyG1+k7qs8aqoz/Pu/Mxw8IqJjlF+Wi3qvGIilcGV7I3nYuqzPF2H6sTBkGIycALZ4xRmUOkfe7DIqmqccOdCsYqVu1iKW8geL4mIM8xpZYy/ON7/favgDxubyCG7eMaqF7VjsfBqO1yvXE864HAtPP1g6PbtuukUpFrXAcYguQMQCDA3hsxdt+4qF+mLy2ME/RrBlRZ6KQ6hVOgtuce+Yv3duv/L1E8qxDjmGIyeEsq4E7zgt8Jdq+0ZgZJ2egxLiKXy4Bd3Re77wrLWhVT+EOIDWvCyZ56McRi+D3x3XzXnZbIQywE4AIFd06wVHuc4t7l1Wi+vGJlzpl5EZ/VbgdFp+2sbrAlmvWxInfAQ0lAW0fc3BPceAMSyinEl2tZtFlbOZhQwjYE2MP6v4IgrE4zEOwOP5Ue75rjmqhZQ9uIIVZ0WOCb9E2E/RTcekowZZ2GV6Lw5FS3GbgTMOQwgCp67x9evlYY2ccq13TlnjBE5x9/zuRbqktsg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

filemap_cachestat() treats every xarray value entry as a workingset
shadow.  On DAX mappings, value entries are DAX exceptional entries:
same value bit, different bit layout (flags in the low bits, pfn
above).  Decoded as a shadow, a DAX entry yields a bogus node id;
NODE_DATA() for it can be NULL, and lru_gen_test_recent() then
dereferences it:

  Oops: general protection fault
  RIP: 0010:lru_gen_test_recent+0xde/0x300
  Call Trace:
   workingset_test_recent
   filemap_cachestat
   __x64_sys_cachestat

Any writable file on a DAX mount triggers this once an mmap write
fault has populated entries.

DAX mappings have no page cache, so none of the cachestat fields
make sense for them.  Skip the xarray walk for them and report all
zeros, and document the behaviour in the syscall's kernel-doc.

This issue was discovered by Tencent CodeBuddy Security.
Cc: stable@vger.kernel.org
Fixes: cf264e1329fb ("cachestat: implement cachestat syscall")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
---
Changes in v2:
- Return all zeros for DAX mappings instead of counting DAX entries as
  cached, per Jan Kara's suggestion (Nhat Pham agreed).  This also drops
  the dirty-accounting gap and the inaccurate PMD-order claim from v1.
- Document the DAX behaviour in the syscall's kernel-doc.

Link: https://lore.kernel.org/linux-mm/lh4cnpy2kw3tdtmhubwhhvim25kxpqxo6xttt7sihyx7x5hqdf@3tvivew2qh7m/ [Jan Kara]
Link: https://lore.kernel.org/linux-mm/CAKEwX=Py7W0vOwxKdWMCZu3d=BbF2OkgDt6Tu_AHhEJZ06w0ew@mail.gmail.com/ [Nhat Pham]
Link: https://sashiko.dev/#/patchset/20261123030014.3116755-1-bsdhenrymartin@gmail.com?part=1

 mm/filemap.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index a1b2ca5b933cb..4f6fd1f4caedb 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -4779,7 +4779,8 @@ static inline bool can_do_cachestat(struct file *f)
  * The `flags` argument is unused for now, but is included for future
  * extensibility. User should pass 0 (i.e no flag specified).
  *
- * Currently, hugetlbfs is not supported.
+ * Currently, hugetlbfs is not supported.  DAX mappings have no page
+ * cache, so cachestat() always reports all zeros for them.
  *
  * Because the status of a page can change after cachestat() checks it
  * but before it returns to the application, the returned values may
@@ -4824,7 +4825,10 @@ SYSCALL_DEFINE4(cachestat, unsigned int, fd,
 		csr.len == 0 ? ULONG_MAX : (csr.off + csr.len - 1) >> PAGE_SHIFT;
 	memset(&cs, 0, sizeof(struct cachestat));
 	mapping = fd_file(f)->f_mapping;
-	filemap_cachestat(mapping, first_index, last_index, &cs);
+
+	/* DAX mappings have no page cache; report all zeros. */
+	if (!dax_mapping(mapping))
+		filemap_cachestat(mapping, first_index, last_index, &cs);
 
 	if (copy_to_user(cstat, &cs, sizeof(struct cachestat)))
 		return -EFAULT;
-- 
2.53.0


