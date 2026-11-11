Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5009D606A337
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 00:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=nWYJ4qAB
Received: by kanga.kvack.org (Postfix)
	id C65ED6B05B7; Tue, 10 Nov 2026 19:24:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C16706B05B8; Tue, 10 Nov 2026 19:24:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2C1A6B05B9; Tue, 10 Nov 2026 19:24:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86C466B05B7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:24:18 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1962A401BE
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:18 +0000 (UTC)
X-FDA: 85420941396.02.BA9058E
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by imf09.hostedemail.com (Postfix) with ESMTP id 55B71140007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=nWYJ4qAB;
	spf=pass (imf09.hostedemail.com: domain of 3r7XzaggKCEgnwk3vkmuqyyqvo.mywvsx47-wwu5kmu.y1q@flex--dmatlack.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3r7XzaggKCEgnwk3vkmuqyyqvo.mywvsx47-wwu5kmu.y1q@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794356656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wY3MtbwEI65ANl7uiD47g3ph74JfuhEnWdITM5snLF0=;
	b=bsTwvC8s4YwN9GvrUphC5JDjZvUElxQlhKomFpvpenHrsCPH9FWforrA+Cfotqx4T+tTQG
	O+B3ZNq9ba1dnMpQRLR9RkS8DxRIt/8Wr8ziVtDAnY8fprpZ+43WNhNMzdrG9zA+2eBMju
	URk9lWAjLGL+k0KokCFB1kCa2E4MdMI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794356656;
	b=fUewlm2Q7Y+ZuZrtVb+1rzDF/XDqfyzNA1iGVRYYv7qC5k6+1YJOhxkYmvo1TZCngFcVRK
	oJhDcS37BDSqR4qoiLUj0hgRv/xlghh4WiZmBGNGpUfKbtKzGR/bzP/tL7XObVdntWoW93
	Wl4YkkhoyC2wP0DHyTaFCg/C1rCUPpk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=nWYJ4qAB;
	spf=pass (imf09.hostedemail.com: domain of 3r7XzaggKCEgnwk3vkmuqyyqvo.mywvsx47-wwu5kmu.y1q@flex--dmatlack.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3r7XzaggKCEgnwk3vkmuqyyqvo.mywvsx47-wwu5kmu.y1q@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4c7f887ac6bso3562068b6e.3
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:24:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794356655; x=1794961455; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wY3MtbwEI65ANl7uiD47g3ph74JfuhEnWdITM5snLF0=;
        b=nWYJ4qABVFyYdV1vkCM1lFg9KfOh+iEDEzodudb3ly0UIFxvXsJdYg6kH94Zw0VU6J
         neqfbmoydvCYaV0yQC6Ihjvm2oEfElATKkTFERYFtSnLeAvxTFrD3TBN797S0raWN25v
         85h0gxF7FduVYB6fH3PreklJGgjZjsSTvLmJhijN54sv0p5GcXNIAiRrJ0XJe2IB/xvv
         USZ7h2Kur/bMcC56cbo/JjQiqvBblVpHubg+kV6TSbcnyLakh1upF10wORbvG11YiN3w
         mOt/I7aVcT1RykumVV11FbmJex1l65r2h2sNyR9S76NX8QdOVsASvujIWqq/mbqVyrzV
         FZvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794356655; x=1794961455;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wY3MtbwEI65ANl7uiD47g3ph74JfuhEnWdITM5snLF0=;
        b=oJwXZ3mDFkwiermI4C9JT47LKxUWa/nmhUfNKhgNlbeSZqOXRBn5r1kr38qH6JNB/e
         FQ166ZDrTlhvGQgOuFXdbF2+nxcNNqVftvYwtAZ7uaK5D8OC4/cZYEGmA4RGE6+cWuvJ
         pjNBwj13gFW5lFzLMVXpf8MjZxyXLJlb3kSOq9K/dVeqWa/spqbSaMdfwK3y5vgosaeD
         8rbuiUPseXaOSmQcjqIGOIrniugoJhdX+RcaCB6teYpxH0k/WlNUYhtILK0x+6YAmw8U
         uGTTD8XcYW0hC4KQwRx9CFPCgiYZXC6eRoCW4Qp6jCyyRBbUDkEBWaPIVD7MgZU/G00O
         sw/Q==
X-Forwarded-Encrypted: i=1; AL+hErG6kbhFl1tQiHSXZ073Deu4jo5E51hqkzrGgrHSw+qlpYl0PukHYmOKQ+yD/lIMCr9WV4HbWrfhbg==@kvack.org
X-Gm-Message-State: APuU4Z8fXaGiml/mvAQ/2DOGN9hUZw+/TZB5cpSyBSD1U17YHeGBia/4
	TXHRpQV/6xHuhnhociH4UYFwH1kTqwg3YzH3LTMqsz3cnKQEDqbkWE3tBOE+az4ckSoKULzhjzH
	ogK6K0t/Eyly2sw==
X-Received: from ilbec1.prod.google.com ([2002:a05:6e02:4701:b0:523:5388:be99])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:4443:b0:4cb:f21b:6f91 with SMTP id 5614622812f47-56b9771429emr677558b6e.36.1794356655005;
 Tue, 10 Nov 2026 16:24:15 -0800 (PST)
Date: Wed, 11 Nov 2026 00:23:44 +0000
In-Reply-To: <20261111002358.1842967-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261111002358.1842967-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261111002358.1842967-7-dmatlack@google.com>
Subject: [PATCH v4 06/19] liveupdate: Don't WARN if tracking a retrieved file fails
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
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: hb9kxcbpzrgdr1b64a5qat135qr4u1sk
X-Rspamd-Queue-Id: 55B71140007
X-Rspam-User: 
X-HE-Tag: 1794356656-439255
X-HE-Meta: U2FsdGVkX1+yCDp/v7G3MyNVIk0ap5U6AHOILAv2KLIKh3xcOK1bUxLhjQtrqboGuaEyGCTEgS3n4vcFSZIy+pTD7H5kPoHWCCIURKKmXSz6FfE+x680WjTbtG1WNAuIlMHJM2IYQG77djgqhqcHWGqJLN28tE0bzVf0BWcm/cYQyHSBOR9nAmqjnn4cI6WJQjLZbotdbQ2XFyTZW9GPJOB7pLbmeHglNjWAEhO1Bak++2QPDveK39YB41fvJZkpAEwqFTdTCgqJXlyPMIg6mj6qHBGaADezuwVc87+oJFxuvcmuMZcU3/TonA8jhoCldv3uDHycd8ZE3JLfCCCNTckh6rG9Su9PN9A8SRCjTHNvO4J7wsf2MSnhq2/oN6wUeiNwavsZkLoiULnqx4/AzAc22ctfbf9+O5fH2GBAeqcH49HmUOZ4pBKHjq/0ovVePFYCUv/XhKW+3221A76YeuuuZhQjZeET4dhyJuewHnCS2c2zPQz8nFBvDlq4m/DYhF4wBITa+9UZKcFeyKOTqyEfoFZY+LsKb2ZSJzW257/eWZRYJFTuAGxOIoRvJrmT5LMGhi+/2bbVBKenOHYoAxWn8g+dB4aO6wJ4YlFGLL6ocj807z52dYD/vgNV/wSeGyurRNPKI7ygph8nfIFFVhgu1llULgPNZhPQZrz77ZL5WqgSRzgfyksAzrCGL4ICFUJouc0/L/YX5bTxubnwaZ5q37b7Mm4r+5xtrhhie3xzJ3LJVgPJrtqNl70sFBRmmT1xbtqoJHpSk+065XqYGjqZKd8r/qMB5G2W/UQ71DRqS6gHYKUz8JuVIn5o8Fm7+i36fQeT56z1bJbfcznDffCnwfinqx84I6U8k8y3+5psXjfooUilYRmmv1Lyp0EhZRG4AMkfO1lwrb3pDfw7HBQh5gleLbLnKHvdcb7lhUogRhOp/j/Zw8dd8PUTgfMyql0SASPFk+gYripajZ3
 d/EyxXAS
 KD4wOD9w1pmVoAgY+6WcACoSMVJ/j1zKZXylu5NBC5flP2cuSF3Vf2ZGBvszHCpJv/+y9daXfVdGN3XvyjbG3pNCdzG7KPLsyZJA92T6Gqp2mXhjSgEPzw6UKh2GB+2rA5SMERX4o1iW41MMga8YtYaYfNZDP1LzLntMrMG8L9oOBwpNrD+QdnkWA1InH5/W3EEr/qPP5Gg4zZYJpZwDhh2GzcZ7kuG7/VcNGt8uO53VGIT7gLyr+IdMVWMuroGcGDQ/JqQQkgReB1VmrEVWH5Dml+SyesdC3JJWy6Jc+HT11HVx0NG4MfVC61BZ6DlljUQOGsapxhPbT2hjTjiCTWkjFbrzgf7ymaIs9BBoNUesX0WaW6LlAwborvFjVeF/aclgn2FWWwV5F2DOYeQtRkFF/TbHsa6WG2vJPUUUB6ScLsTBEHHUfhnaAiY6G1LjvXHDIwAkc6ERguo+R7jVJHy8BcixQ9nh6CeyEwU5wmZ0PxEAXFUsq3sMmUKo/2L9n13/OPrO4MN4Zhoj8+LYKfW0Cox/T2QYSCJnl2YqwWBmjmyy3/hQaCd9WNJ7hFHl0F3iaqHdjd/5U1r9CtRdIiEjtao3AaPqwFTIT1AIAWMS5X17anbNpjrmU3QZhNJQeO8RHjVCvRR0atLhpRRewTYoLlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Handle a failure to add a retrieved file to luo_preserved_files instead
of triggering a WARN_ON(). Make the failure permanent, and keep the file
until the file set is finished, like any other retrieved file. Only warn
if the file is already tracked (-EBUSY), which would be a kernel bug,
since a retrieved file is always a new file.

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
 kernel/liveupdate/luo_file.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 0c9a3b6921d1..e5d333649f76 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -668,14 +668,28 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 		return err;
 	}
 
+	err = xa_insert(&luo_preserved_files,
+			luo_get_id(luo_file->fh, args.file), args.file,
+			GFP_KERNEL);
+	if (err) {
+		/* A retrieved file is new, so it can't be tracked already. */
+		WARN_ON_ONCE(err == -EBUSY);
+
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
2.56.0.542.g3ef89b7020-goog


