Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA1EDC5DF86
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 23:10:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F0BD6B009D; Wed, 19 Aug 2026 19:10:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C97F6B009E; Wed, 19 Aug 2026 19:10:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F4806B009F; Wed, 19 Aug 2026 19:10:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 19E146B009D
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 19:10:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9C04E40458
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:10:10 +0000 (UTC)
X-FDA: 85119564180.30.5B204AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id DA750180006
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:10:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LEuB932n;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787181008;
	b=3wTdXPWzibDFKCH+IggDoztAAqqg0dOEN9xGMuiGZzn13GmwKw5ngUSK7oalinT8a5f4cj
	QgT6S/aPnHsu/UQvxn6/CjGSC0dMhYXhguKs9TsErYRMjps02FBeQS9CCGO44F8AFT8EIi
	QsWI737nPut4a1LypdX+tvSdLnA3MtU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LEuB932n;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787181008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0bW5IEgJKmSIJtwmTEEMkv73JLFJ3IXzsjpXfuyidoc=;
	b=eixBt3B/4Q7IuoVj3Tu0u8UsAbnWqwUFJdbNdQpOh/K1cApYHJqqS6PUq+t96omujcQYtc
	5q1LDMeAqBXldIcpM5zuAHY1kWnjSehOetJaxyegKHiWLVGW5xa3k1CdYWmFjRGkUSJJRB
	cJFZ15BJJdjs8qlO5zvIXw5jAXnj6ws=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5858061887;
	Wed, 19 Aug 2026 23:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D71A1F000E9;
	Wed, 19 Aug 2026 23:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787181008;
	bh=0bW5IEgJKmSIJtwmTEEMkv73JLFJ3IXzsjpXfuyidoc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LEuB932nM/UQEfWfWfw+dOgybuedzZaOhO1071ixqoQoMGoiYm2QscBoR/y1Lezs+
	 NvT56PSoLqff/NUiucZuYKdzV49MAfi00OrwzpOdkarTrTs7Pry9k1zO3t1p9eF89Y
	 awmjvXy/9IWizfJB3QQe5eIL2qWXTcU0fV+UNqvKIzzwNT2mbySQ19T8c/NqinCiLA
	 ow6UDBbGwBpzydM9cL+k3npIWi4glJWVz4PlywMdvwup0S5lpZwSBYlnLwxAiLfFAu
	 WeJ6kcitLnoLnFQxYwGiquxV/WtjI0r396xQBGdFFvQMjxH6aFWOLhRaa3lLWqgBcJ
	 Dmx30y1DHJEUA==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 20 Aug 2026 01:09:19 +0200
Subject: [PATCH v2 02/22] coredump: refuse negative skips
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-work-coredump-sparse-v2-2-ba32dd718c51@kernel.org>
References: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
In-Reply-To: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>, 
 Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Omar Sandoval <osandov@osandov.com>, 
 Jacob Lalonde <jalalonde@fb.com>, Shuah Khan <shuah@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=906; i=brauner@kernel.org;
 h=from:subject:message-id; bh=g0a1kYV53viXcxL/lVIPR2fuUykenxBNOGfzhwh0UJQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS1me9TP7f+9yQT8+WvJ+wQ0jY2mNB/LONcQnJeyOkDJ
 24lCISXdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExE/xrD/0q2Cxy3aozfKVUX
 5X0+Zqu+eOeEHYf2dJ5SnJnv351ec5eR4fgWa6cL2ksdZ3KVXt50XN92X1DWlz9iInYXiq5Kt3w
 /zQwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: DA750180006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: qhrz9bdd5jd3xcpyctuq4uiirr41aune
X-HE-Tag: 1787181008-174532
X-HE-Meta: U2FsdGVkX1+bLYzfICLE0LUYRpIxDg61RRW9nZAfvxkxvCphfL1hCr+DGffuWtwZIhdQ+hRD77QkGCU69ixu65Lj368yys9xHcT9ErRrUHWC0XDBFFgLHlByY//B4dCZ+4KjeieMiCC+YFxWZV47zxFNC65EYBZ0v8Vp8NX37b3/R6oiLONmPrUCXjOiNDokdLxAFHjb3NRBSwyn6gm8iSgSpHx9k7Cbba/VxiYJSdA5k3C8buq9EDIfGsDUE85T7TlMYBcRT4HZzpqroBUVu6AzC0i1UAI0fvdfZbANx15ujuXScSdyp8KjLjhXCY1OJN30FDJ3xi/pIwZoFFlkl+tLTMc2Eb+zQUuWBejSabV2wI/nAFOUbWw5f4VimmhoVq+STKcXQUdbvV+4RIJjtp87kf6oYDxJiPqzHdIciTsW1FXrb3PC/EEAPTvviMXS5AByXrL9VMFaJiTcikMpeCxw1xhcbMtvZQQN4rztcFbhiInSLzuIGEkkaxcBmWty45Dby0tBU59k4JGpH8hxpGkXLhXWEQ4xfHVrNgFJM199xHtjoVSuqK6IGIxNCg0mBOJmnxBKUccw0rWcRvx9UzfdDcwBWZQpjWe1hyudevSThsaFsMbNCcR8BsJFDvAmcQjgE1kLFBdHtP5kyry3x6WufFqVFflXEvM0M5+/B3E7U0GkbKXf6zCGiKK13z/v1tlNkdpQHfGFDzmu8IyowCTkQp3VeuOPaQfdcg2DMpkDah4/r+j9IxWlKser/wztK4fGmTBLklCv8U4fGC4ZiAJtzcSmlXWKoN/O0DOHbN2091wD5hIYOrcyoMDkkrpbVbuh2SShqt+ZT4d5OkkxA220EEIR/FpEVRh0AtlXOFfwk/pezdWUD4z+xl/D3MyOlz9H9lr4IC4xzSosiqiAbEHfSDnOytnY957OgToRtdAlc+lKewhOdEG6QYMel4YfVnHVdhBN+mXih/YtUCY
 ESFHoQ/Q
 wOc/hB2N82xU14xcAt9PUnIbNgL/Cl1iIvaI3rrQ4LltKf4RrkyNgnBZadrXqLaslflC1/HE6ai9tRzqgaxtl3T724tf3ty6IUz14ys6YTDv+Qwmfh+8Ne1aeXBWMIJSkHR/SbYmmrNTOdh57aMbZ5oo7yYAAEFLR9uHWeaKQwIO7AoZVRsiY4nfI2iYg6IuGXMtYBoR0jHPeFpPemAA2V+tinzT8b7LGCuCWL3qZnlCNKQq3nVwERa0LKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The dump_skip_to() helper calculates a relative skip based on the
absolute positon of the coredump:

	cprm->to_skip = pos - cprm->pos;

That's easy to mess up for callers and one already did. This risk
endless zero PAGE_SIZE loops or overwriting already written coredump
data thereby corrupting the dump.

I don't think skipping backwards has any meaning. So warn and refuse.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/coredump.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/coredump.c b/fs/coredump.c
index e68a76ff92a3..ac4e922c9cb9 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -1261,6 +1261,8 @@ EXPORT_SYMBOL(dump_emit);
 
 void dump_skip_to(struct coredump_params *cprm, unsigned long pos)
 {
+	if (WARN_ON_ONCE(pos < cprm->pos))
+		return;
 	cprm->to_skip = pos - cprm->pos;
 }
 EXPORT_SYMBOL(dump_skip_to);

-- 
2.53.0


