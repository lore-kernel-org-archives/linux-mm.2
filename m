Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AC1860A2607
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=YTvWPP8/
Received: by kanga.kvack.org (Postfix)
	id D17AD6B0A0E; Thu, 22 Oct 2026 18:50:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF2DB6B0A10; Thu, 22 Oct 2026 18:50:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8FEF6B0A11; Thu, 22 Oct 2026 18:50:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 838D06B0A0E
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:50:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 008FF1202BD
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:50:45 +0000 (UTC)
X-FDA: 85351758492.24.903C99B
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4C95318000B
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:50:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="YTvWPP8/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3Q5PaaggKCDIRaOhZOQYUccUZS.QcaZWbil-aaYjOQY.cfU@flex--dmatlack.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3Q5PaaggKCDIRaOhZOQYUccUZS.QcaZWbil-aaYjOQY.cfU@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792709444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XQzlgw3emE84DnnF0oN4ahYTo145Q34I7Y43hlPChX4=;
	b=CD1hGuNhhvEUCdOXp1LEHlkGaraserxjnew7LQsElab0WaSuIbNYmrN+8lwF3or0itjexx
	MueeUyhK+f3Zm8mCsnBVx6OpbutU3fq1UI3ExqJYyXe5Vk01Xp0XUf7EUcByzldp4htz89
	MrGwZj5EcktNZuEZnBz24Jw7R5iNAhc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="YTvWPP8/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3Q5PaaggKCDIRaOhZOQYUccUZS.QcaZWbil-aaYjOQY.cfU@flex--dmatlack.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3Q5PaaggKCDIRaOhZOQYUccUZS.QcaZWbil-aaYjOQY.cfU@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792709444;
	b=xPmG3a4UnvVP5qd/YYWB90kmc8bfG7ZSGj0sk07nV1xqCeVjM+olYXpRo33k9bnHdZ0ZyR
	xC1kcdDb25IM/KulMc+mHUQrdhXZQDYdqR7I/RCJLGOgZja9y9TRmQvT8jUbgqdCHD1Jvu
	skg897XBQjFSoigvbTc0hxo2Ph6G/dI=
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3abb4c24125so208304a91.3
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792709443; x=1793314243; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XQzlgw3emE84DnnF0oN4ahYTo145Q34I7Y43hlPChX4=;
        b=YTvWPP8/VWuJQEOctyQwfsRic5YOym0gvYxlqtdNNXIbus7ruu7NYtNNwSxPzyMXb/
         7lWvL1IN9iSV7YiHttAPJeMmINCb+qNf0LrKDH2FKbZH2Wz6iSyZ7+828rJbLZ0HKCZ0
         Xcq+O/OYR35lNCZnyef0aG2SXITHQsqgAdijW3D4TcJdrjKUlcDn19DuoVl5MfJwo/Ly
         yykAEi/c7B1hj2zI+MEffocQPMo7QKQap5CxKYQsvrw+UuxVlo79D1pUZlv9GkUFP6h9
         u7ecRg/WEIIYxmPqog/kN6lKKcVg2uJ2EMg4xE8hy5vuQ5bW5XXqAY+WkUrE9I4BLwn4
         uWiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792709443; x=1793314243;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XQzlgw3emE84DnnF0oN4ahYTo145Q34I7Y43hlPChX4=;
        b=TwxwZmZrgXWxLdyTfJpvlzc1esAoHAEFFNxFBMlxJK2MCLlOtxc+nt+TheS69bIc4/
         nbhcH+oqC3VzzIwPLDtlXgYdggXj3ALunQ4tkePW1Ft+tEWOqVjxvSfjV0MPQucZ/I6q
         FQHEHsWfDbA7IfZCnucMT2LT+yHKSynjU9muyXO00N1JJQLjiC1tb9agthNUevly4aE3
         HCM6BBYEED3opIb8OFfoIpClsN9YObz+3i+xIjBeGWZXdb4dquvgY74Tu+MgsutRRrqN
         ZQYXhppwjQd5RMWLz1AscR/8mufwg+bfRlTvD78TLApAxpU8Ibbkzcm2MyCOhl5mjONk
         wcOA==
X-Forwarded-Encrypted: i=1; AKwUvBxqNmW/PTXPcYWvqIpkvUCJP4tUOVkl7yxAtgxAcwEIo7CQe3WC9T94dwuT/Ovc/lu9r8P6dNxnyg==@kvack.org
X-Gm-Message-State: AFq9FYI3lPphf5c5U+RfM+8XptJxw9dH9IimYN0CK6BkLvVYrHGDFaXw
	LPA7y3E39BUakrND0o4+MiEZZApOAfSNkhP5LNKl1FZ2iXVQuWiJDV43azAdvEDGnFS3BI9eYe1
	k8Evm3RjLYv0/2g==
X-Received: from pglu36.prod.google.com ([2002:a63:1424:0:b0:cd6:b233:e4aa])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2785:b0:3ac:d39d:ee4f with SMTP id 98e67ed59e1d1-3adce45d4b2mr203170a91.44.1792709443059;
 Thu, 22 Oct 2026 15:50:43 -0700 (PDT)
Date: Thu, 22 Oct 2026 22:50:31 +0000
In-Reply-To: <20261022225035.377445-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261022225035.377445-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261022225035.377445-7-dmatlack@google.com>
Subject: [PATCH v2 06/10] mm/shmem_luo: Don't make early retrieve failures permanent
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org
Cc: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4C95318000B
X-Stat-Signature: 9ojkgs6gshp6o7gm7crxhsxscdfen1wi
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792709444-639045
X-HE-Meta: U2FsdGVkX19wVZTyUd+oCV2AH1FHejnCS03/miW+EtVFv5ahC594osTDScuyZmmiC4VTt14XFX4dcTrvgVvlMkpxfz+0fCvx/ijOfGGTwyRpLp1doVuGBgS15/Oia7gHyjpeDiZD/nAb8q/TlExMY6WEgKiPrYh8c2Kpq9U9FGIlR87kqm2XmEdJB3uJcPvBr+CYT2JxyMe+ZQit10vSUJ2IA8n/uiFgXZVdwZ1X3b/k7A96OrzyWk8aqzffFpGfOGyzyR0POpKQRlpBWJdZEqMKdEHs2O4X5e0v96ml6UzFxJYJlhju3q7sy5jrcUNC81mdeYzXpnsHnNAW5NDXMZzDAqH1Z1geyXp9IlUTbO1og0yoyoMEVQ4KLC1o/3iwtZ++O6oDXqUJ17Yxaq1qjXjrJ83W0V26WgWOIImdAs8hY52fkwtAKfC0xpHDcXIgSMerzZuXyy5biBOjr0dJIRL2wAI0KvoIRpfg671Ye9gASRDvMEww6RH8FVrrT9Yxsd83qeybWlhShjFF6CC/b1sSsScsSJEA72KyacFe1R6ZkxQqA+eurx5Y3Ohe9EmPjXBj3TOYpDKMJFaB8BRT9tt68VZn1geQqunoAOgiP+ms2TAK0u1WFgeb90KyLGesFR9tONBpouwf1ov0ghZ+DIfRQg99X+0ZbZVW2jnXF8bifSfEDE/qio608iL3ZROSy8S1bLzR15xiUE71PqzddaWFG+UdkMUNG3h64Z8SQO3nw8QGRrY9BPwckuupCM0UeIcWrm7DLmoCtT5A+csCVvIOigCkJCh9CqKIeM/CT88AXZqck8TibFtn/WbsE0Uy/Uo5WviPumqitz21Xw05RMmUncXAPn1HnkZQMjXBywn+VAUA2u93X+xQg4OVArnJaRqtf3PdISbPk2SVoAFDOdTNlis8IxRnpRfvjE8ln4El3RdZHN378I2lgViTaz1IDNdQ6KtWtHxPmb3MkXY
 /t+cYaYb
 XSQWU7hSNrKPwTZ7VZv/ebhG/+ZY9+fYqy/rjcqVuBpAhIq/7grPrpoZuaELrftR1SQSUOP14Rg7n8jPCTQAR+jIyH16Jnorqpk3CuhKQuJ9u3Knva6piZIBF6Q3BMlDB/jK1f/dlzNZ//sG0NHTcw1Kj4NR13BzuiNcFH110+QYrGYzHw5GOaqzyCAePYrCs1X9TBSU1AMS7x/5D9wgYEIt3xmIvv9WQGluWplXB/5dhf5tfo2EydBDx4QF6rgYBwPd3wdT+OaAKW+X9jLJahMt86GKEys4tbwlLREl/KENPUJC5Z5VRvlWfQdghytqqrh0DyBGjt95uIvfxiEGq3t7sBy9Jugg/qHIlX1kahj61UCgeSspb2JvZOr0qZqQRi/tdmzJMrCfIxKp0k9vhJmx8d9YyVZDnr4TBIgBbgIhMU8WyY1gRR14aPEIHn7zE/k19CY2SCyVhSTVHGItJI2iHqyGpLQMJlHvStCSjH20335m5OAlSvdYeFKGz0uYbnIxdtsJdWuXXFQOd1qqNWyPAzTZxa8z1wpxo8UHhY99hVBdCUC8JZlBA1aAJNxTBc/PnxetSoZcNlajCokt9iKLoRqRpU6W2eZB59z2//p+v5UVy8+dlyl7mkZoD5b43zP3pT0OxUBiCf7c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

If shmem_luo_retrieve() fails before it starts restoring the folios,
mark the failure as retryable and return the error without freeing the
serialized state. Nothing has consumed the preserved state at that
point, so the retrieve can be tried again. If no retrieve succeeds,
finish() frees the preserved folios, like it does for a file that was
never retrieved.

This fixes leaking the preserved folios when one of these early steps
fails, e.g. because the file has seals that this kernel doesn't support.
The retrieve freed the serialized state but not the folios, and finish()
then skipped the file because its retrieve had failed.

Assisted-by: LLM
Signed-off-by: David Matlack <dmatlack@google.com>
---
 mm/shmem_luo.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/mm/shmem_luo.c b/mm/shmem_luo.c
index b8d86055912d..bcac1bbb3db3 100644
--- a/mm/shmem_luo.c
+++ b/mm/shmem_luo.c
@@ -390,9 +390,9 @@ static void shmem_luo_finish(struct liveupdate_file_op_args *args)
 	struct shmem_luo_ser *ser;
 
 	/*
-	 * If retrieve was successful, nothing to do. If it failed, retrieve()
-	 * already cleaned up everything it could. So nothing to do there
-	 * either. Only need to clean up when retrieve was not called.
+	 * If retrieve was successful, nothing to do. If it failed permanently,
+	 * retrieve() already cleaned up everything it could. So nothing to do
+	 * there either. Only need to clean up when the file was not retrieved.
 	 */
 	if (args->retrieve_status)
 		return;
@@ -526,11 +526,16 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
 	if (!ser)
 		return -EINVAL;
 
+	/*
+	 * Nothing has consumed the preserved state until the folios are
+	 * restored below, so failures before that can be retried. If no
+	 * retrieve succeeds, finish() frees the preserved state.
+	 */
+	args->retryable = true;
+
 	/* Make sure the file only has seals supported by this version. */
-	if (ser->seals & ~SHMEM_LUO_ALL_SEALS) {
-		err = -EOPNOTSUPP;
-		goto free_ser;
-	}
+	if (ser->seals & ~SHMEM_LUO_ALL_SEALS)
+		return -EOPNOTSUPP;
 
 	/*
 	 * The seals are preserved. Allow sealing here so they can be added
@@ -539,8 +544,7 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
 	file = memfd_alloc_file("", MFD_ALLOW_SEALING);
 	if (IS_ERR(file)) {
 		pr_err("failed to setup file: %pe\n", file);
-		err = PTR_ERR(file);
-		goto free_ser;
+		return PTR_ERR(file);
 	}
 
 	err = memfd_add_seals(file, ser->seals);
@@ -552,17 +556,20 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
 	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
 	i_size_write(file_inode(file), ser->size);
 
+	/* The preserved state is consumed from here on. */
+	args->retryable = false;
+
 	if (ser->nr_folios) {
 		folios_ser = kho_restore_vmalloc(&ser->folios);
 		if (!folios_ser) {
 			err = -EINVAL;
-			goto put_file;
+			goto free_ser;
 		}
 
 		err = shmem_luo_retrieve_folios(file, folios_ser, ser->nr_folios);
 		vfree(folios_ser);
 		if (err)
-			goto put_file;
+			goto free_ser;
 	}
 
 	args->file = file;
@@ -570,10 +577,10 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
 
 	return 0;
 
-put_file:
-	fput(file);
 free_ser:
 	kho_restore_free(ser);
+put_file:
+	fput(file);
 	return err;
 }
 
-- 
2.56.0.257.gf7497c7d27-goog


