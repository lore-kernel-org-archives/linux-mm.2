Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A6BB606A686
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 13:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vvl/uopy
Received: by kanga.kvack.org (Postfix)
	id 3CF626B05B3; Mon, 23 Nov 2026 08:05:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A3D16B05B4; Mon, 23 Nov 2026 08:05:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B95F6B05B5; Mon, 23 Nov 2026 08:05:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 016976B05B3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:05:20 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8950D160820
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:05:20 +0000 (UTC)
X-FDA: 85466404800.11.E3C19C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id C3995100007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:05:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Vvl/uopy";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795439118;
	b=hBWEyctNs5A6fCl6+zh19JuYFs/oH9lYAtoDJXYLrkdEg0LD0c+wiGGVv/Z+ZguKlv6aEs
	6YPgzteYIXvbP0pF2og/gWRZp2DbRHgGT1tUeAjsbMrnoycX8vRQyAVZU2QasTo9jTDLGg
	QntNqNDNSQao9eX/M8yK8PpuAY3BNLA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795439118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aPK7OR8CzM9eLpteSO+lvQgKJGtTEcPn8rI1ujD6sP4=;
	b=fNhezBzf5DyyQRYrr0ungsr2/LHRbLqF8OsjIsiycHAKJqDBQBgO/9ANTvi6G0DtyCMRJ3
	NUrgT78oXE1ypqhs4TVZSb7hPlPd5LjjOcy7vkJB7hAzAd6yxRqfICTkfoXTLi1dof9Ev5
	EDMlCNEWNBrkSlLeaOEGcW0Jnw7jjmk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Vvl/uopy";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 106E1456A1;
	Mon, 23 Nov 2026 13:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2125B1F000E1;
	Mon, 23 Nov 2026 13:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795439118;
	bh=aPK7OR8CzM9eLpteSO+lvQgKJGtTEcPn8rI1ujD6sP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vvl/uopyu0VvgPP4uP38bzkxkZ1rfqoTtfRseS6r4oEvY3wFx/Xshiy7IGBESPgDI
	 bVPrRhiNvIqyn/K1cUdLQkKbnj6wYeCjejwZz4Q+/a7K/WwWoJFRkG7KpyGWjjMJ5q
	 LK6jPzXUb3s9b1/Bu8xzI4vRDMOsXRf+KDFkvVE6RxfatEULmDnKgXnVfnoODcQ93n
	 nJRSNHCfH1kKG6VIUT3v7XlKS1R/VCoeRJ/DLBpcBimPQE7Q7ZFC2afOPpILWwmJj3
	 9mSP2zTSTD4a/WNeA/Njjie9eb2nCC4oeq7j26NYQY4EtstC2AY9LzGbIy8surydY1
	 bdoSpJozUNlpw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Samiullah Khawaja <skhawaja@google.com>,
	Chris Down <chris@chrisdown.name>
Cc: kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 1/2] liveupdate: luo_file: allow keeping private_data from retrieve until finish
Date: Mon, 23 Nov 2026 13:05:07 +0000
Message-ID: <20261123130509.4032642-2-pratyush@kernel.org>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
In-Reply-To: <20261123130509.4032642-1-pratyush@kernel.org>
References: <20261123130509.4032642-1-pratyush@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zxkumkp3u3arz7s1e4axnn9wnnhd97wq
X-Rspamd-Queue-Id: C3995100007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795439118-104370
X-HE-Meta: U2FsdGVkX1/l1hvo/UVKaoxfFFIShjLAsmyjAljL26VLNULWdc6dpk4UiWx/bMfLt8UvR9OofiCkd4TWLP8dnJK7LVky/QbeR9vuLg/yfCzGhJg6k1ItnUoDAIxmVINMg8FU5Pi+a4aOhEBpsLIez+Y9SH8p6jnULWIIX6ysNcTbCh978985zInr4pajzbr+9LUswY1NyZWhqamKEkOC2PNncet5kkTIUfda2FOSJ7lipFA95cFsQW8LBlxNUw7WKfTMZHmCsMrWkDnJwDgOn5EdUsuE85b+LKr5nirlNkJZgYZJaIVs4PHNPbdghJE2tuPIjimszDH2Jca/kgDmgxf2wppTRFhURvLw6i4vL7NoGIMJmYPvlcxfcKeCYvE/2mwbahEsDoEUPUT6IkXaC7caiB6r3T/oYuMT3OhMMvg0klr0YlyoxxqUzIdhrrSVBR352hQFLiYtBS3pcA45NTbzMq+f+1Wl/WKrN0zaA3BgruS0hMnSxZRQDHgwH9wZVIGFT4p/GuyYbYg3dNlo9ZwwqGZZdGL0ef0Cujd4BVabI2x9nkQICP/g/tfbPcUtOxWzZ9/kyIa9zbY/SXq/vBninbsjRm2btaeUet7XbnwLsF5FL5ojn5pp/GXXvxVZX0wpnB4eFoqm61ew/galizevNi4nomVm/Xy037ofhdJ4f57f9DE330C/jit4PTdzOFiK9JoB5rR4QhNrP0fohDtNlHS4tA8Z2Wlyr4X0uvj1BHCX9dPSiAiXEUa4RosCMDej0yGV4M+ZBTT100/KUZ0UoOFBaF2TR0PAT5TnwLkSCBxQjE7DBlUEz9oM4xP7jZJcPmlshirhe4ihALhRo+Y7KevymPgvxBDHi/eRSmjzOhLFX0ejyZxYGwB+3rweQC2xH5XMRh10kDMG1Va7ImuqooDMgpvOuEEDUsEu85KubxWuDnfbhzX+VAeHKgVvpovS6iuU7xOIdLqzjAm
 x02ZXJx0
 HDgi/XpFPSaCCZmxi/3LDvYVNLW23/3+uqfdkXtUnUPs6cl9FKVrlmeAw76EnMhby1D4HYRqDxO7Lf0x9aD8TjDZ9ifEJC/WeRU3Gus98MNp2ERce0h3nuCM3Yj5nHo/kQbtg4OY+i4j+e3Gn3NoalW6JBr1RHl3zbn0FEvnzgcxwchlPNxFAC2deP34JG5/HJ7KMvkt5mm0wooEvpb4i0VwaG0huKOeCew2S44mmVmgymK7NiDoRAZ4M1nYD5l502CdXaDxE9jO9xfC2s9Cx0sjq/gmhxXMu/cHuNV3uxtRBUOFtuGtDFWDGQTElxD1WHJnSfcwm7etopVu+X1I9CajSv7j359wcxHGqK304gxUzByArdlArZj42SLUx0GWCHKkWqCFIFYOHF1Z5DWZAHnSCkH1f0HOZrg1LzzeYCqbhoh/ctb7F/AWUpHTNcYtQ++utomyfWMoUxVVgTVID9Q9l6ByaJt5i3RT8wKJ+C7wCVqxfloSv/APGyvm3iQiXFWIgVE34GPN1VmUTYLdlsUKck4nScgJFPWjt5zdBygCLubZtWk1rN2r0cOqez4+J80CZfYvgOd3lUBU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The private_data field of struct liveupdate_file_op_args lets file
handlers keep runtime state that is not preserved. It is set by
.preserve() and passed to the later outgoing callbacks, up to
.unpreserve(). But in the new kernel, nothing set by .retrieve() is
kept, and .can_finish() and .finish() always get a NULL private_data.

Handlers might need to keep runtime state from retrieve until finish.
For example, memfd will need to remember the folios it holds on to
until finish so it can release them there.

Save the private_data set by a successful .retrieve() in the luo_file,
and pass it to .can_finish() and .finish(). The handler must free it in
.finish().

While at it, update a stale comment under struct
liveupdate_file_op_args. There is no 'data', but there is
'serialized_data' and 'private_data'. Refer to them instead.

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/liveupdate.h   | 11 +++++++----
 kernel/liveupdate/luo_file.c | 11 ++++++++---
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 6051abc0612c..f01e9ab68d99 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -37,12 +37,15 @@ struct file;
  * @serialized_data:  The opaque u64 handle, preserve/prepare/freeze may update
  *                    this field.
  * @private_data:     Private data for the file used to hold runtime state that
- *                    is not preserved. Set by the handler's .preserve()
- *                    callback, and must be freed in the handler's
- *                    .unpreserve() callback.
+ *                    is not preserved. For outgoing, set by the handler's
+ *                    .preserve() callback, and must be freed in the handler's
+ *                    .unpreserve() callback. For incoming, set by the handler's
+ *                    .retrieve() callback on success, and must be freed in the
+ *                    handler's .finish() callback.
  *
  * This structure bundles all parameters for the file operation callbacks.
- * The 'data' and 'file' fields are used for both input and output.
+ * The 'file', 'serialized_data' and 'private_data' fields are used for both
+ * input and output.
  */
 struct liveupdate_file_op_args {
 	struct liveupdate_file_handler *handler;
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index a39992da504f..9bda37b0dc4f 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -145,9 +145,11 @@ static DEFINE_XARRAY(luo_preserved_files);
  *                 .retrieve(), and .finish() callbacks, allowing it to track
  *                 and update its serialized state across phases.
  * @private_data:  Pointer to the private data for the file used to hold runtime
- *                 state that is not preserved. Set by the handler's .preserve()
- *                 callback, and must be freed in the handler's .unpreserve()
- *                 callback.
+ *                 state that is not preserved. For outgoing, set by the
+ *                 handler's .preserve() callback, and must be freed in the
+ *                 handler's .unpreserve() callback. For incoming, set by the
+ *                 handler's .retrieve() callback, and must be freed in the
+ *                 handler's .finish() callback.
  * @retrieve_status: Status code indicating whether a user/kernel in the new kernel has
  *                 successfully called retrieve() on this file. This prevents
  *                 multiple retrieval attempts. A value of 0 means a retrieve()
@@ -616,6 +618,7 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 	}
 
 	luo_file->file = args.file;
+	luo_file->private_data = args.private_data;
 	/* Get reference so we can keep this file in LUO until finish */
 	get_file(luo_file->file);
 
@@ -643,6 +646,7 @@ static int luo_file_can_finish_one(struct luo_file_set *file_set,
 		args.session = luo_session_from_file_set(file_set);
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
+		args.private_data = luo_file->private_data;
 		args.retrieve_status = luo_file->retrieve_status;
 		can_finish = luo_file->fh->ops->can_finish(&args);
 	}
@@ -661,6 +665,7 @@ static void luo_file_finish_one(struct luo_file_set *file_set,
 	args.session = luo_session_from_file_set(file_set);
 	args.file = luo_file->file;
 	args.serialized_data = luo_file->serialized_data;
+	args.private_data = luo_file->private_data;
 	args.retrieve_status = luo_file->retrieve_status;
 
 	luo_file->fh->ops->finish(&args);
-- 
2.56.1.750.gf70dc682cf-goog


