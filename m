Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 386B660A263E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 00:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=UAWewGxl
Received: by kanga.kvack.org (Postfix)
	id 02F216B05B2; Tue, 10 Nov 2026 19:24:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB1796B05B3; Tue, 10 Nov 2026 19:24:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4EB36B05B4; Tue, 10 Nov 2026 19:24:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A62B56B05B2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:24:11 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 345261A01CB
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:11 +0000 (UTC)
X-FDA: 85420941102.14.C5ECBB3
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6A6A82000A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=UAWewGxl;
	spf=pass (imf03.hostedemail.com: domain of 3qLXzaggKCEEgpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3qLXzaggKCEEgpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794356649;
	b=bMdV/oghYcLjosohll5sDXt3DIY2TD2rw5wdlJ/RQc8tUVGivHe6Nwh4wsNtos4hRAHbJS
	wE26mu9ODRHI68czifVyioiJvHKjt9Jf9ry5jQ3USDEWRDnAYp5x+Va3jrEAzHGpvN/GSk
	7qlp2kdkHNaIa3KJKpzdGqQ2CGCF9a4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=UAWewGxl;
	spf=pass (imf03.hostedemail.com: domain of 3qLXzaggKCEEgpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3qLXzaggKCEEgpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794356649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8hRjHNT+bDawf2n+fS4w87yYb1rrNIQllzNnUpN3o7M=;
	b=SK7LN0rlRPy+DhyKZCyN4Yb76YCh6C2m/4v2TYFB+DvK9iO0sHyMJN7ctkqe//sBgQOUUI
	kT+5EeJvvB5ThGoHeOixEbtOmlqFP3nrc418iwC2qksT3LDgxKAw7Onb9GXYmy2m8KxCdk
	ec0iG0++vyd7YtOY2gi+9mK15RRJvZI=
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4c467e19391so3965373b6e.3
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794356648; x=1794961448; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8hRjHNT+bDawf2n+fS4w87yYb1rrNIQllzNnUpN3o7M=;
        b=UAWewGxlhbBxHDBFZJ+LL142SyfhBVzclznjViMW8R0fHx0k3rQrjTf9hxABa52bx0
         gh35Yx7BNAzYDoMjiWjVdGi8Z5sGi+akNM/iinTuT1hbOXqMVEdt4xrTAV8En/xEHVeO
         SuAYYiEsJi0OGf/HdFfvXp+DKpPp4HOIKBJaatTW3NR1rzos/jn7nxlidnNm3TQufarr
         z0yE+oaGov2YbwacCr9mCZqYL+vutC5G/RLke9ISF0OZ/Vowx1Q58bUSZVbCz9VS9BpO
         V94jRzcEv1Y73O0S9BFiaCb2k8atYNEWhQLXnukZ97xz0V66r3KCxMUyb/AEVDyzOmZo
         /fvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794356648; x=1794961448;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8hRjHNT+bDawf2n+fS4w87yYb1rrNIQllzNnUpN3o7M=;
        b=GUiU+Ufw1smPZ1v4tbRTOPiNLBYKkiW5kuYjuLXxFLvsR58PtRDodnzWYe7iAvTNsk
         H92NsvRET3NgGCAtGOs2GG/6661tsTtbEAQKr7FsrmQCzcEvEk8nzwIYj8lmX/9se05i
         Rq60lJfsqLkgR29es3JiaSR+Un8o1w86CcNIvYuS+nS0sk3q/Ztvb3o7QJpnkXPeyVPQ
         UEEc9DTXhfPYMpgchKLSdW01a2ja66xDsFm5j+qW2CegOcny2LnHC+t5UchkVvZnSkLY
         SZkEawVxeDa6hXOU6q4l8OoV2YQYMAP0IgdD3VKwssfr1Zeu7yXq5zeDOmFR41mrFoaS
         YFIA==
X-Forwarded-Encrypted: i=1; AL+hErEFovGUjaynS/LShkKRVHM2KrRFiBp65KtpEbY18TY2FlS9nERNe0GyMp3D7OWH4JKnzGypQIusTw==@kvack.org
X-Gm-Message-State: APuU4Z+CulMfH8KgLf08C/rl9tnLe/RynPeHKtfvYcURZGMxWhZqLiyk
	yUgThU8o/AKFnmUn4KkFRg5Ts1oYQS7VTi81Pw4HBId9abzuV5ZgOTw+8UqS21EBaAJy16aV8BW
	BrV6NxXvAqsYzvw==
X-Received: from iohf2-n2.prod.google.com ([2002:a05:6602:a5c2:20b0:9e3:4940:4cc3])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:13cc:b0:567:fd8f:403b with SMTP id 5614622812f47-56b97b17653mr680403b6e.42.1794356648195;
 Tue, 10 Nov 2026 16:24:08 -0800 (PST)
Date: Wed, 11 Nov 2026 00:23:39 +0000
In-Reply-To: <20261111002358.1842967-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261111002358.1842967-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261111002358.1842967-2-dmatlack@google.com>
Subject: [PATCH v4 01/19] liveupdate: Remove the list of steps from
 luo_preserve_file()'s comment
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
X-Stat-Signature: b3pibi8dy31155uczb9waimrn74zo3hi
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6A6A82000A
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794356649-950118
X-HE-Meta: U2FsdGVkX19sKhziSPWGEEON35BqnoalVGwp2fniusDasOg5CABs/bmS3UmULg4SqVA1pZVG7x33XWT6Yg6qkpyWRdqoX1jgUiOBEBqaRYmurolz2hJenMcXe6+e+tLJXQD9aodyp8I48jKI4L8oLFOWeu7kZaHnc+KfS1T6UgFGARu9QjtM2wBhw5+ZyJpaoJ35hLbJhFyW5fi8ay4umOUvOVVu0hJWwJ5E+YPnS8tWu+dXjCxKayxbQ1sQAg7E6fEVKmicWrboROkVUEW+FEmrbElDXouQBYd1XG0JmVXL1SlDI+Mzb7KYbM19TGINbNuuh/fVMRU7Wj45zpkoHGNQ9SEYNon8YQZfLm9F0wXXfYLpuoPomz+5+ohKFCM9mk1Jur3jfgaSaJZqyLakYja6ipMVvPTbMfU5r4B+Rxw57+xPQJpZ4TtFAQ5OlFG9X70vmTmbmMgXC8n14wUERh1PdD8oFc27m99Rkt/zvWrKMkTO7bD1lcjZxn4ydzxEjmOuYYf38VPNcZ5r/IA2UQwQaoO05Re1AAT684RHBVg8roo+yOccEKllOMOi3FHteeVPwOuQmvZCwVDHuVXcKwPyOnXCwx7sFzNfuZoGG47YCYH1/YajnEQDEaYtt7BoDvM/5qT5Rf0wqlKPvBC9qhUGAGuOwzLMXXhf4us/jhPI8ed6JsYRMXX2Js7gRzswmsU945d2Dt7EqZ53FTQ4rnJW/RDvL8XU/Meh87tY1fPRfowZ8N8v2YlfAvAm9gyLXQnNDgkZWDv/xSMg8YWfQ0IH4CluKjHvY3NhG0NnywMFoZEeKP/x7Uc/YQmAHQCVT3/atP486Y/Lp/Uqg1nDVpOc0eZ/cXml4Vcrua4TR7bwKRg4xHlpuwK+WeNvscC01EUsL16db5u6OLYQ8VFno+79muUJYmdIldJiQu3KjrBC/FSg80+nfcn5OVA3K2K2ArXPr8vFO4mbW9TEZyZ
 pohyb+/H
 ymBIK3blrNpbPNnudQSvHRirttKZzNmb4/9Hbop4gKcyER3PgkuQjPby8L8NYZT9hueUg5EaJsQs2pQNDlQ7guQzYrAp+S7uYkCbPgt2m9WsPnxMtrnYI/9Lvn3W+rKUNXFLbBQknB+gvhtLFv0St7hVR+R0nwTRyCuEzaf2X/w4abnZ3lJoh5dGDKCFY46TJWNoOH0NkHgwAduWzQ0D9TgCf36x9Xqk6AxRmGCOau5p/NPKeUkuyr97oJx+17L2VtEA0RrtrnSr38U7KonnF3NE+3S5X7JYKjNq5iyhtpJmCrI/gMaCZ5OIjyg8Nj/IYFIkQxmnMpagOk4VuDjiTR4XGPfARJBaQWD7FIPNbK6POuCwP5N21B/1Z31ECcsH8YZwL2wS7H3XGB33QoaoodgNP+L0cFdjgkzq24cmhXQBb9NBQLg0cGjXwNqkYnDP9B2JCNV1EwM5Q174t7dJn9A7InXfVUU4IbxwPsObG9ieW0isabUQONWvUa5v2arDHZB6Sc3XfHyokLc8ufZGtai7jQq2dwCqwiOcmw+8ctLgjFIaVjxzlTWosIngWSYt+kTVuh15XdAN6l115hk/HTjF4XwN90O3Y4LonAz2ptVwS7tYR68zLKtmEyP7d4t3U5uXzJVlFlSe198pkUj6sD9kbLn3xpDamKnfX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Remove the numbered list of steps from the kernel-doc comment of
luo_preserve_file(), along with the sentence that introduces it, which
repeats the first sentence of the previous paragraph.

The list only restates what the code does, and goes stale whenever the
code changes.

Suggested-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 kernel/liveupdate/luo_file.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index a39992da504f..a42b60356d52 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -214,18 +214,6 @@ static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
  * unpreserved or successfully finished in the next kernel, preventing the file
  * from being prematurely destroyed.
  *
- * This function orchestrates the first phase of preserving a file. It performs
- * the following steps:
- *
- * 1. Validates that the @token is not already in use within the file_set.
- * 2. Ensures the file_set's memory for files serialization is allocated
- *    (allocates if needed).
- * 3. Iterates through registered handlers, calling can_preserve() to find one
- *    compatible with the given @fd.
- * 4. Calls the handler's .preserve() operation, which saves the file's state
- *    and returns an opaque private data handle.
- * 5. Adds the new instance to the file_set's internal list.
- *
  * On success, LUO takes a reference to the 'struct file' and considers it
  * under its management until it is unpreserved or finished.
  *
-- 
2.56.0.542.g3ef89b7020-goog


