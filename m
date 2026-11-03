Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A223606D808
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=cs8B/PIN
Received: by kanga.kvack.org (Postfix)
	id 49B886B05C7; Mon,  2 Nov 2026 20:02:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FCEA6B05C9; Mon,  2 Nov 2026 20:02:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29FCE6B05C8; Mon,  2 Nov 2026 20:02:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFC5C6B05C6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:02:32 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2C8001C2827
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:02:32 +0000 (UTC)
X-FDA: 85392007344.08.9F3E14B
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf21.hostedemail.com (Postfix) with ESMTP id 722AC1C000E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:02:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="cs8B/PIN";
	spf=pass (imf21.hostedemail.com: domain of 3pDLpaggKCA0qzn6ynpxt11tyr.p1zyv07A-zzx8npx.14t@flex--dmatlack.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3pDLpaggKCA0qzn6ynpxt11tyr.p1zyv07A-zzx8npx.14t@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793667750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pqlok/L90zyySLepqQOJQncJ0sDMJpbHVdvROaPHHJ8=;
	b=kaWv75fW/j3Tw1dUSab3nhrxKwciFcAYyd/R0SqCvquNO6xrdz8S7qJd/sLizbXrbZOAFG
	Q+sSTc5xUb9qOr2+8fnVk/OCKtbUjET1C+xxR6/YKjkBffOzVjL7QWamhSdUbikAqX9ANx
	xL5LwvH31v5GvZ0ZVwNNAS0TCogXozo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793667750;
	b=TFLStJfAXGYQk16j3pRO6sactWcHU//cmDe3K3gDo++yTa+7k1U2FePobMlp0MVczSf+Dm
	3NmeX1vrC1GibCN4zEMXLHLQRUf1/IMUlwhNUIkZzC5fVE4Kqf+yTU7YkBTJHXee3L6/ky
	pNGYxLCYRGV3ynOYiZ9P9+jigzXcN1A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="cs8B/PIN";
	spf=pass (imf21.hostedemail.com: domain of 3pDLpaggKCA0qzn6ynpxt11tyr.p1zyv07A-zzx8npx.14t@flex--dmatlack.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3pDLpaggKCA0qzn6ynpxt11tyr.p1zyv07A-zzx8npx.14t@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2e9821ca96fso58049525ad.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 17:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793667749; x=1794272549; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Pqlok/L90zyySLepqQOJQncJ0sDMJpbHVdvROaPHHJ8=;
        b=cs8B/PINpYbRG3Co1urs6mf96rs5isALacTJNpYBgW1Sg8OC9DAJ8F+/A/I1oErPC/
         8NEfkvKD8myUrDmttG2VYoC1WyO24CeHJR0m4sFSYGaqffC+4DfUQlP4bM3LN1jxdqdF
         FHEmyBOO/XMXjB18mWdQneebc23QI5RZF/S2K/gfbMFWrXIq+EIDKmD7GqkquHVz93WN
         ocYliFt99MHnY9dpe1jM16GUS9ONYNMG7Bw7+8euSki5PpeE6OaU89CIINv8xx6n9ISt
         EqG5qmM9qxHNV3JLvQJWB0ijESKjY0sXIf3+FKRvJ8qq8Iz+AHuXjOoub/4jhUg1pXtn
         xmLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793667749; x=1794272549;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Pqlok/L90zyySLepqQOJQncJ0sDMJpbHVdvROaPHHJ8=;
        b=fLrUbEnL8PqncSFekNxxNCeR/uPAuSKgwbPVCFfougcB0THZujTIuOC1uggfXIq2X9
         D9D7nP+GejM/WHoqf3ddCRhPajNeVcnqWKZ/DqLkPcEBunEEgTvWObaOeTlDztVX/m/g
         9wboyP3CpQ2EZY32mFzvKxM9DWZP3Jzg0XXIkuvUhTVRFscYi8gR134xMC8rXJf6LPgQ
         BrCCEnKcuPADMiq2i1zLVQ1uSeVTkN6kP9wdajaSruur7P5xJsgO2ZhkvY7Z9VPhDp3V
         +UODGUuFPjlLjcES9whgN2hY+JLIDhoOTnUItN2NALIvzEZrQ6k2yOF/hcTqsPgJmqkO
         BErw==
X-Forwarded-Encrypted: i=1; AKwUvBy8XfL6sH3LusdgBB27zNL7al9uyDVa3tW3y6jfu27KARa4efrYqMqkozmwpxzh5Kffm4xJsgI+0w==@kvack.org
X-Gm-Message-State: APuU4Z/V/EA1U6+BZDCRx96dNI5zWiyXFo8zp/k3A5aOZyEY0fYjfh0F
	VOCy5kcwCUboN4D4vnbY5h8Y7fDD5Uz1qy85WDHwsap+r/m9lOVSABulvvYwRZpkcui5KIdPwK2
	gED+JJxm6DhivUw==
X-Received: from plru1.prod.google.com ([2002:a17:902:b281:b0:2e8:f377:a4d4])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1ace:b0:2e9:5714:6079 with SMTP id d9443c01a7336-2eb3643f7e5mr119975855ad.31.1793667748954;
 Mon, 02 Nov 2026 17:02:28 -0800 (PST)
Date: Tue,  3 Nov 2026 01:02:11 +0000
In-Reply-To: <20261103010216.3447716-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261103010216.3447716-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261103010216.3447716-6-dmatlack@google.com>
Subject: [PATCH v3 05/10] liveupdate: Don't WARN if tracking a retrieved file fails
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
X-Rspamd-Server: rspam06
X-Stat-Signature: p8ndpro4iawy37z91ouka5x5fo1f3sme
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 722AC1C000E
X-Rspam-User: 
X-HE-Tag: 1793667750-612635
X-HE-Meta: U2FsdGVkX1/lrnl9i48pTQw0c5zSQawL2jB15GoLw9vvzrvDJ3LwyfBP/+IFZg2SM0AEqREXJVhZeMdPEeHJgdo39CzHxO3MwpoS33NAdTsTiIHJ4B7XjjS5vsVdmE40gIGXeeIquVlHnOJoRhHBkB+WLso92dpDUJqq/1iBjw0maqmcFjqlwmZ6xswUumz5OeqS1iQTNthBNEA9GSL5cdwjbf/5YANI1fHhOrA4XUHA9llF4QevxYEdDtSEYBkKfylv0Aun6YiuP/LTq/+mX/P0Brj1YuqTU01+1NmndXwCDI1Y+9lQf0YIy+ehVFy6ahtjeteegpil26Cd89TjTKXGvpOD32+VvHGMjHLfTGk2MME4iuR5PY/poHzTF8c6WVl7lyheIo2gElHGkUKx6FC40Xy3put+xd8W9/tYVg8diN+9/KO2dfEu+iN0uqN7AJUgFqu93621TNuoq88cmnl8MxQuOwRhA7cX+KjUU81zSC6k73QgkLR+lxCfWXfU5dTZue8SQA116MuaxQFwngQ6O6IBjxYO2euTAlfkMQg6VodTUjZWz3JGvb5VZhc0/oQDNsV6gCv7D/XynKrSnDp+3H68ha16qdcC3QyvdnEBqG6nxeDN7CXlVrv5tvwNSMVcwdwmV3yWH7nWzb/aNKisXa9Of5jkwQTEtEdCgD4IDI6XSejp7L1smckGEd4XlrT/Fg70CFHFWMRX7a8oxl1nrvtksEJ8Gkg1ktcrQDkWKbGtQ4+K7V/IC+oRUfPMuMb1V67SHs1Abt19suzArpXG6fnh71takJNxWmjCrXK84nBcCzLlQAzZEKtzyJlQt7cdPK7qImUwRyGF5X+45aY628ULy47XThUMdLv24SPuaFS7OKOMnmQJwGDoJZgZsgrQnAnLkFxCptsVnmz636m23wz97p18QzJ1+X9WVo2vVA7lFRgGDgdy3+oUcaIJ1WsCFdyCZgEKJsBIYxS
 Z+afLMKj
 ihuDA0NX2SETpx2F200FuCb5HXzbR2Jo+orHaq3vl+L0uvfryV5TvwDK7dxQMivb71giKXzSLZM9jE9lUlTYYPtxd280kFGey1dP4DksS5MXvOPyK6JbaqBPafqVnPz+rN2bQ7D9PKHzJNBzmiXXnRf7Q7h9Jl31GEid3eJMd1ro9CRu1SKghnoLkqMiyHq8eXXiVq/EPlvvKnS0gmIzepy6Wk6NeOCoY63uRM0gcQGaSCQdARIwgcljAWehBgw7HB2XM7qq8ko6CTABLI2i4N3rZgVucThIJc2kMA+eotJzinwwcMPp/h4p3M/hxKxmdI/+azapvmJl9uv5tWVvz6MXF+LVGktfEv0YZsl8ddut7xn70dp5IyEZnLpaxujMZkt6PQpgagk8/uuqZvODUMCMZhjB5deDWfXMTpUCbBjUh9Nhg0UELOCuIYnubnGGPQ8tQZCCGZ4ArDtrf0v/oYq1D0GfgfY8YbK7qHWMYrV71OO9/DndyuPK5R+gzVgX4dm4TGcl7r+G4nV8JrhMJOoCQN9uGCSwEcDFpoKxvqjEIp3TXPmwJ8vYx+60UzN2BDP8o80dxF7MY7gjl+YYHQZwBKG1QfpU+mtRfB2OAe4t8lHa+sDGFy+OoBl9cT9hEQHH9JE4Rap7PIWpmkR/G8nGEUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Handle a failure to add a retrieved file to luo_preserved_files instead
of triggering a WARN_ON(). Make the failure permanent, and keep the file
until the file set is finished, like any other retrieved file.

xa_insert() can fail with -ENOMEM, and userspace can trigger that with
LIVEUPDATE_SESSION_RETRIEVE_FD, so warning about it lets userspace crash
systems with panic_on_warn.

The handler has already consumed the preserved state when this happens,
so the retrieve can't be retried. Keeping the file ensures that its
resources are not released before the file set is finished. Finishing
the file set then erases the file from luo_preserved_files, which does
nothing for a file that was never added.

Fixes: 00d0b372374f ("liveupdate: prevent double management of files")
Signed-off-by: David Matlack <dmatlack@google.com>
Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_file.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 908ae124ea5e..5a82e45b9062 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -684,14 +684,25 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token, u64 arg,
 		return err;
 	}
 
+	err = xa_insert(&luo_preserved_files,
+			luo_get_id(luo_file->fh, args.file), args.file,
+			GFP_KERNEL);
+	if (err) {
+		/*
+		 * The handler has consumed the preserved state, so the retrieve
+		 * can't be retried. Keep the file until the file set is
+		 * finished, so that its resources are released at the same
+		 * time as those of other retrieved files.
+		 */
+		luo_file->file = args.file;
+		luo_file->retrieve_status = err;
+		return err;
+	}
+
 	luo_file->file = args.file;
 	/* Get reference so we can keep this file in LUO until finish */
 	get_file(luo_file->file);
 
-	WARN_ON(xa_insert(&luo_preserved_files,
-			  luo_get_id(luo_file->fh, luo_file->file),
-			  luo_file->file, GFP_KERNEL));
-
 	*filep = luo_file->file;
 	luo_file->retrieve_status = 1;
 
-- 
2.56.0.385.gac671c819a-goog


