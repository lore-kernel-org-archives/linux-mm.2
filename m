Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D54DC5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 10:41:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D25EC6B0302; Fri, 14 Aug 2026 06:41:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFB7F6B0303; Fri, 14 Aug 2026 06:41:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B55696B0304; Fri, 14 Aug 2026 06:41:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 826C66B0305
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 06:41:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F40BE140409
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 10:41:26 +0000 (UTC)
X-FDA: 85099533372.05.185397E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 02540A0003
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 10:41:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a36d0zwY;
	spf=pass (imf25.hostedemail.com: domain of joel.granados@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786704085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dh4qwfF4YlLi2OoWPAsnix0OMoionI9oLcQ6gSwubnM=;
	b=h5wVNaIgNDv4CjVIknzA428gXN0gCVYS1RWy0ZCy7UTvt9MBIt1yb5nG8JMZLpIUmf/ez0
	xJIlS1UyCE0Vpq3y9CHRVuvTcSaT+Z1t5hK+LlpBME5bs2IfA4Csz0J3PAiU+YZbkxMkze
	yDjbbOFbcRfYqr6j3n9IhMCs+5ujlcA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786704085;
	b=g8RKnyIyuiWBSGUbgbmiiIw2B5RZPVnsiOvGeLd4ziYJty9yadvsUJdxPwruzPxLL91O8I
	lPblhrth24kbD8EUx4Gs1n3zTtaUD9ajpEo3/u+zNp4e56PB3vh+EjaY49bXQlFQ7EupwC
	TqqRD19x9QwzIf5BxMaaDeMjTU2lEho=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a36d0zwY;
	spf=pass (imf25.hostedemail.com: domain of joel.granados@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 01A7F4401B;
	Fri, 14 Aug 2026 10:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B705CC4AF09;
	Fri, 14 Aug 2026 10:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786704083;
	bh=ACmHDzg0bdqhRKtZiggZe9yyDKsjLpeE7LXC/BUIylE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=a36d0zwY52gz/cdEaRmS3cDOVCWTSZxFJ9ECsn9afWIL7bpOeKRzCS2m0MayPvOO8
	 VbiHHEJbLBMyxASNIUNwFlXpv25dFmldauNkqmyqnai/mMGMA6PGrdmcFJjOf2ANza
	 USfRD9/8INS7JurPTEVmyNwa3IBudfK3BVqaC8G4qFyKYh3x3Iaj8nKKa6/7sCxgQw
	 Lu7aYoIdEizHAphuamXXC2qIwmgRaT9UMZ8pZeRIFx7DeE/gb7FufC3GK1qUJH0Aje
	 urh6gyVKOm6lItITCY1xHOUPGp+zsCvNEq0SIyUceSnWHZKtZwcZe5KxBZI+m1CM8m
	 SVmZijnojIRMw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96FFDC5CFC1;
	Fri, 14 Aug 2026 10:41:23 +0000 (UTC)
From: Joel Granados <joel.granados@kernel.org>
Date: Fri, 14 Aug 2026 12:41:13 +0200
Subject: [PATCH v2 2/4] sysctl: Reject uint arrays before calling the
 general proc_vec
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260814-lklm-partial_ctlvec-v2-2-9df50d26e477@kernel.org>
References: <20260814-lklm-partial_ctlvec-v2-0-9df50d26e477@kernel.org>
In-Reply-To: <20260814-lklm-partial_ctlvec-v2-0-9df50d26e477@kernel.org>
To: Kees Cook <kees@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: Jianlin Shi <shijianlin11@foxmail.com>, akpm@linux-foundation.org, 
 vbabka@kernel.org, hannes@cmpxchg.org, surenb@google.com, mhocko@suse.com, 
 jackmanb@google.com, ziy@nvidia.com, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-mm@kvack.org, Joel Granados <joel.granados@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2851;
 i=joel.granados@kernel.org; h=from:subject:message-id;
 bh=ACmHDzg0bdqhRKtZiggZe9yyDKsjLpeE7LXC/BUIylE=;
 b=owJ4nAHtARL+kA0DAAoBupfNUreWQU8ByyZiAGp+8NDu6mELinrd4Zbsp71ht/npxGd5//lUz
 p/ms+oZ3YkI2okBswQAAQoAHRYhBK5HCVcl5jElzssnkLqXzVK3lkFPBQJqfvDQAAoJELqXzVK3
 lkFPOlcL/A582yimDhlcHkvz9SG0STpA5Qs3yhtyNi7XgDJdTE3l5T8et6PDFryntBnyzN/h2Kb
 NQ8Bm1TNmZLmNrZj/NQxdhp9obZAgFaePZAb6h6SKmZjZls60bDttBqmoufK+lz/qhD2tFpDYgV
 yM5RWJxWi3BZLDP9Fkxhw8ApM4bs+B9BC2DshT1jveym+shgHuts1D+sBhnH4RdWucKgvFl6Q7u
 mrbpywg0cl1GHRhe6ZwasXkLgrwUJs5oRw0cVCop4SqzLWipln452fskR6/WpF1p8YsmPT2s9ZN
 0jIS9/MI/aMXGFbfTo7wYZ5V7J6jj6Rg58gxXnKf2g7S/Q+Fi6deXQy0/izZ46RO2Qc9PC/bUWT
 KWz8Ysec+jRY7bSr8F5GZnSRVO5bZuOJW7YJtIMLiKU2rGq2ZTaK6TnMg17q0N3Kc//OJzGADvf
 pgMhe6EVetnBHd2ffgh9b3c6rM4wkI3X1GJAmzv1BsNxbsPWo5YTXWC6NSogE++M/IHTarsIUi9
 ak=
X-Developer-Key: i=joel.granados@kernel.org; a=openpgp;
 fpr=F1F8E46D30F0F6C4A45FF4465895FAAC338C6E77
X-Endpoint-Received: by B4 Relay for joel.granados@kernel.org/default with
 auth_id=239
X-Rspam-User: 
X-Stat-Signature: bskgmrru47ctrqf7c7irkpeiku1t9dpp
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 02540A0003
X-HE-Tag: 1786704084-185512
X-HE-Meta: U2FsdGVkX19m7ZJPKeolwdX4XX1nEdPT0EjjKOcYJaRwQvQk/WKkrSDN7DLIC0Ramv+Pa2ce+EDPo1wpM8OE6Ohn50MXYeyBdjCyJrfEmZGBkN5y1HT9Q5WwoSfG/8CVUru8s5k9uzsIlAQO9NpDaBOi+/px4n56nIx+lpjneqxWcxMT4xdw3lm3gEpwxpM3IB5dpEe1tz9jkh4IpndorPF7GHQOyKSWVHgdUVjiMueSG6vGVi3hHwGjuhtrzIBJQjizhFMHz/26WBNmgkFf2AFzidkSAJjXLjIVoTgKMVR7uoYER4i6CE/DPgLobL9wDieO1AsUmr1m4/aM1795JvhBzvFUQenZOhB/BtghFTRP9I0oXqn47IZSkfpjt8Jm0f4tBDR+Gd16iubWRNXHS8YbNx0EzlluVqK1jF4AcTCC4srldMWyuG3K/rjZt9T19EnbxrepV3B6xcWdiiatCwfI4n9V0WwCk98k5yf6L7QvcWdoi4fKLwRrCRyZPpQk6b24aBK38heAW+x6qEQE9bKVMGdmAUT4WWdASrcVgd3gpkRJjwGgcz8Tt4W4WmZ1OoToD3AR9qnXU4fZ9BvuIkl3u+PMngGzOv3EjmVbYys0jEIqQfTOlU9WiomwXb8vzZds3FCHYCY8lqCbuee1ADeRORfs2N5/l4V1i0maKVjFfCIA7j9FUPhwvdua5uG4Gomhx898JZ0BPL0ADPuJAdystHyDCTMkHyBq735SgT8SyDzzj4ze4ZlkJHJuF3AsshQP+5C+jqXLaz0etMR5UfMrXkaNeBhWqU4gxLMuSbBlL8uoZjCosB6hkeJ7E7XC1dSmR4hFWt4qryx6Hz44+3Jj8RjGuN7lDodIwfJtZ/rNoSCW8a9wL1fRt/FzPRTwmqrX75MRhBeadWP/UBtRst1DjdPZSxTTGBp7ZZpNUsbb7bjAhy1+w47pX/7/Nb9YJDpQkZlPBSBBXZQJjYB
 /K1kMrIB
 3mZuGRHWhtqW4Uw38PiMDF4emN0pHn3crrNW2Ty4gAj9NjSRn1GeAYaY5LdNaTIkh8fgXgTGRkW7wOGOPeAVcfLydsQOvRRAIfw4grrvxOwqXle7L88LjZ/xutHWygILF4B5CU10AxxQAqGTVmXhX+xT3A9CfbTgJN6za4azXlLXk2Q4+GZWnbhsvsRIJI/ntL8mcu6hEk5o9iDRekuW2xm4Cc1CCQiakz5WQt5YRQcakPzF843C86jattH5PYodjUf1o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the UINT vector size check to proc_douintvec_conv; the function
that routes UINT types only. Route all the UINT calls (including
proc_dou8vec_minmax) through proc_douintvec_conv.

UINT proc handlers that incorrectly define maxlen will now return
-EINVAL instead of 0 in the cases where data is missing, lenp is 0 or
ppos is 0. Note that maxlen == 0 is not considered as miss-defined.

Signed-off-by: Joel Granados <joel.granados@kernel.org>
---
 kernel/sysctl.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 47a92cbbcb69cd361a18dba6606ae6ae8f86b5e2..7e9024899be6d5971752dd5639ab4b806a899081 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -748,10 +748,6 @@ static int proc_vec(const struct ctl_table *table, int dir, void *buffer,
 		return 0;
 	}
 
-	/* uint arrays are not supported, *Do not* add support for them. */
-	if (type == PROC_VEC_UINT && (table->maxlen / data_size) != 1)
-		return -EINVAL;
-
 	if (SYSCTL_USER_TO_KERN(dir)) {
 		if (proc_first_pos_non_zero_ignore(ppos, table))
 			goto out;
@@ -797,6 +793,9 @@ int proc_douintvec_conv(const struct ctl_table *table, int dir, void *buffer,
 			int (*conv)(bool *negp, ulong *u_ptr, uint *k_ptr,
 				    int dir, const struct ctl_table *table))
 {
+	/* uint arrays are not supported, *Do not* add support for them. */
+	if (table->maxlen && (table->maxlen / sizeof(uint)) != 1)
+		return -EINVAL;
 
 	if (!conv)
 		conv = do_proc_uint_conv;
@@ -881,8 +880,7 @@ int proc_dointvec(const struct ctl_table *table, int dir, void *buffer,
 int proc_douintvec(const struct ctl_table *table, int dir, void *buffer,
 		size_t *lenp, loff_t *ppos)
 {
-	return proc_vec(table, dir, buffer, lenp, ppos, PROC_VEC_UINT,
-			(union proc_vec_conv){ .uint_conv = do_proc_uint_conv });
+	return proc_douintvec_conv(table, dir, buffer, lenp, ppos, do_proc_uint_conv);
 }
 
 /**
@@ -932,8 +930,8 @@ int proc_dointvec_minmax(const struct ctl_table *table, int dir,
 int proc_douintvec_minmax(const struct ctl_table *table, int dir,
 			  void *buffer, size_t *lenp, loff_t *ppos)
 {
-	return proc_vec(table, dir, buffer, lenp, ppos, PROC_VEC_UINT,
-			(union proc_vec_conv){ .uint_conv = do_proc_uint_conv_minmax });
+	return proc_douintvec_conv(table, dir, buffer, lenp, ppos,
+				   do_proc_uint_conv_minmax);
 }
 
 /**
@@ -976,8 +974,7 @@ int proc_dou8vec_minmax(const struct ctl_table *table, int dir,
 		tmp.extra2 = (unsigned int *) &max;
 
 	val = READ_ONCE(*data);
-	res = proc_vec(&tmp, dir, buffer, lenp, ppos, PROC_VEC_UINT,
-		       (union proc_vec_conv){ .uint_conv = do_proc_uint_conv_minmax });
+	res = proc_douintvec_minmax(&tmp, dir, buffer, lenp, ppos);
 	if (res)
 		return res;
 	if (SYSCTL_USER_TO_KERN(dir))

-- 
2.50.1



