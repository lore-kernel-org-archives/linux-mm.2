Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 397A0606A338
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oK7j//fA
Received: by kanga.kvack.org (Postfix)
	id 60B9C6B05B0; Wed, 11 Nov 2026 06:35:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 595D26B05C1; Wed, 11 Nov 2026 06:35:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45CE66B05C2; Wed, 11 Nov 2026 06:35:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1EF1B6B05B0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:35:44 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A9EF514028C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:35:43 +0000 (UTC)
X-FDA: 85422633366.22.8EEE55B
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id 00944C0008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:35:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="oK7j//fA";
	spf=pass (imf28.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794396942;
	b=G6G0JcU4Vc6LUN4Yvm4BtTxQCJaVyhM2grPKFzjQazfhLE+kQ9urF6aqjRmzQq5TirdE1/
	iw4M4dZXHpmj6EnntOEbjnvFFKvAVLDMAxpS4Fa6RezE6bHYj3bTLqZL7zCiqmFDhRfRQO
	uWfhWQ2pUkLnLU6audL2F5ZOTIHEq/s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="oK7j//fA";
	spf=pass (imf28.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794396942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NjJjHaen9J/fp2I0Vpm97Xgvh0z3rGeImkxT74DWJ7E=;
	b=cUiiZDNH1XFpgVNZEEqxjII22Z2+nw8Qi2M0oBKtaaIUmunqVuSpzbHvKVuSlL1Mr4RGD6
	QXTJbjr3jS90P6/3vo1oxHsuBI1yPD1Ekzg03bAG8PNZa8UEwDdvqpn7PdIy1TD+OmRPnY
	5IfUwGSqlMRJCr04947uivklG/kkgoo=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so37207985e9.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794396940; x=1795001740; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NjJjHaen9J/fp2I0Vpm97Xgvh0z3rGeImkxT74DWJ7E=;
        b=oK7j//fAz9Q+VIHp9VUYtscl2Aa2/zWsSKR0rPS7oosiDSSCaauRkfseA17tKur/A2
         6+1Zky149eT4lKQghML4fkUSKox30XIyDEiYwIDyIzscSZGQhjfXe7bXMBxhto09egOO
         jgemxJGCk9qT2lkRAbWWyhAdmhDINFmSa9sfCJSSZdkcN61rs070H7GtVaK+PQY5P0m6
         m8wADJu8tPWR1EXql8nKYZSMT6JXEJjco0RBXmCEY23ldUDgzwkJjdNCm2dJ22vhiPlh
         PHZO9ss3qjWsMxlAJQ7pr63VKprNmmSIzM3xIYxz0vN4IJPJDG/ajPzSo6OJamJVwdpQ
         exhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794396940; x=1795001740;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NjJjHaen9J/fp2I0Vpm97Xgvh0z3rGeImkxT74DWJ7E=;
        b=TWQc5nXeiE3R1EyCDrPcoxlPI/PwZKilnmnYeSLL8jCZT4thsq5GmSO1sJAi7253Fh
         +/3yp0IjqIfYM8aQJf1nxb7lyjfG+sPR92eqiZ11jhw7j7SWYX5/XpVPtQ+Xbd7iNVQf
         i2ZtQt3M3B6arfmvlqjBwjQVr7vONmhDLA/L6yFsrAq0J30Rw5RJ7ZM8z001G8Xksd0r
         KtPfQrVd60T55nDCEvrolbTYUo0kSXVRMH+PBdqzRYZfjiX5ZSFA5m9O+qnQssl4o+r8
         yHT/0iWat1FZ39JO2jyHZoJuHtYJaFeBveDp/T7dvD7EisxaMtjfyEzmgLfYKYjvOHHS
         odaA==
X-Forwarded-Encrypted: i=1; AL+hErEfBuqVzZEHMApDTMLoOdhoS60kHV27aPJbmnvTk1Bz4aUdgUOBVT/4nxmJSYaYOQk+AFRZ8ZdovA==@kvack.org
X-Gm-Message-State: APuU4Z8lMGoEgJCD0mukPsHUABaL2eXqgfgSgjIZnuMDvS+MJYEwNCJs
	FRy952onukOfIh46xCzao3bBthY1vcNxwDJghL2Glz7CpymxsjSwenX1
X-Gm-Gg: AYBFou0gT4w9EwvNRRVDVSYAhLayFfKqYMpgyb6vLegE2U0wVgymB4bp9t6vGRqU0++
	xDvaVsXsAm+dquqvmDaf1J3WgHyMi1heyXmbAuzNBrNhDfy4CjQeQ40JEar+a4ZSFl1uctfyVpH
	012pt3WeEPXXasi1ljWC1NWxYSTPR+zRyWXwTGYBrVVGxkTit9DJPEHeViVfeXlE7vKeD+SAB+3
	QedT3mFkwE8mmMQpknF/XZDthWYz43vUjQkoiK/y5/EbsNSE9A46sLUyuRrklZg5WdEdqrJVFwT
	Ba3cbf/LaoY8Hqj+nmemGoWufMug8orAk/kR1McTKrCuDW1WokV5D+O5yv6BU+x9YNGKMXRSRX+
	xl6huMcI6pU2RpWexTdHX1mKggpPhIPZ4zb7vcx3kBmLcP/KXbr1+2meHJLF0cliIFiIbGHfUqk
	F6jTpTN5BvWOJcNgIjY2b2mUdIvtMe6Ithu9ImMf8NxTHdL6R7EFHDzVN0QaawqYofpO1ipWCtG
	XkM1/h+0oIie3b99fldlP5mhM7b7ZIzSNH/f4o7UrKfrmTUNet0tEhaJQeLVBLtD2kDvEzb/QB/
	wdhLh2XVyXhUCg==
X-Received: by 2002:a05:600c:858c:b0:4a2:1002:223e with SMTP id 5b1f17b1804b1-4ba08dfde5emr38653035e9.7.1794396940348;
        Wed, 11 Nov 2026 03:35:40 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-498365cbbe5sm11598683f8f.42.2026.11.11.03.35.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 03:35:39 -0800 (PST)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Joanne Koong <joannelkoong@gmail.com>,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: [RFC PATCH 0/2] mm/huge_memory: find partially mapped shared folios with NO_PAGE_MAPCOUNT
Date: Wed, 11 Nov 2026 12:31:36 +0100
Message-ID: <20261111113535.330078-1-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 00944C0008
X-Stat-Signature: fq6cwdfo9sfri3z4e9ke7f4mr3pxjh9c
X-Rspam-User: 
X-HE-Tag: 1794396941-394845
X-HE-Meta: U2FsdGVkX1/VzCYoA/Dk6gymVm12ynkEh0RATOVswOt2fMZVtvEJOLLJlVkM3PJ0lfNO1IE/EXrn4KPUraY4nfdFITXTP0zcYDS9Ezz4mjouK6P5x/6pS/R5k0tUPwDqN7RX0JvRyDiMD6O+s1/Dby7r8H99A9uPiY0SZvpAKzHMvuic3WoM8PVM1IbZi7OKlEkVjmjTZAdQmC3Duk3tjWAobWGFZLHY5uj8it8u6bxAlX2ICs9AqZt1DQOn/gcLCOxksTiMYzs8tfSohs+PXKxTpUFTcMhYnohqBAzpSeBpxMRE7q7hVq37wW9lE2OeRE4BEFNZzHmKo5lYzX4xzI08zuNVHkHXH3tcAa2mtFYgaGaNcqN338Y8mXM7HzpG9UjtKHaM/ZBESj9U+QtNHv0NDIFO2epoizX0k4L9m6NG2Sgwd5ThPusuieDSE9bl8X/EowQx/I8ivqIeuZNp7+9aNbLtnB1/5kr6Tuyp/bbLj6t1jpjEoeKuQsrL81jikHLGbsMze0tefUWYPeJZ1+THDJvEqhZVxBQrhzq4kDFwZdjM6MdKkKKR98M5ri2chN6ieRulYkp94ds8+uv0QQaZZNwmPZY8Tn9rkLSwC8VQke4X3FzgRX0I+GaBRl6sRS2XuO+aTLDNhXv47vDmFJeuQ5D5rLFY3cjo20jhgr3hC5mPIt2E/mOdXKsP/an/0ZrAxr2B4rkUDCHXu53SJhlLiIi+KwvfpbhUR02Jhp86AsVXINaPjViqlv3jE3Wua53BTdtqpkMvlZemIhBnoqi5zmwm+D7bmrpwa7QWgOqQpkzCiUxOGixYPBhDyiv1DKK80Kv0FesZ4DHUR9P2eH0d83kdMAFMXh5lMYV4DkjJLm/fLIDfOsUIv+glNP42kr7bZzzhYZ3rmPsU7u132F5ias/xuBjfkKdEVhwg+gfzM9Oqp75s7xLQLkRZxWQIqCj51mCqfjbQzoY7Dte
 +Tf8cQEo
 w+L9ISJbx/8Xd9AV/1U1DQJg0z/j2bY3u58q+SXvf2Ij+Gqjs7rqgGdT6jZ0BfmOufQEQa2DFlsqdN9qGUiXvoynvj6w5DerVF0FhdTiAZxB0/4Mg+4vn1rKgmLorbTcRPuxVw8W2CLgl4Orf89zIiZRpbB4ZYtaDOAliKjPkTvTAS5tfuD07weEzXqKqiYpmuoWOYp4rMME//e6RL7rxdbKbKByYfO+WbjaCBaZudSPqjDUnHYtEmFTBttO7m0OsaOimvsdCw28mufM7N5tNthpLHi405+MqME22/4FTUFeUKXoCM0iG6Cyi30J1DerPYZtFxBI9GJRA5lGbtEA3Ijw6mQGI/1wCPsbCLkgGZAnQ2To7TRjMlCUYmdMrpLZVSLqa+Kx8GJYJxSoclwO1GXKtDMotdil6tE8dhCBesErfGE/gNJqFSy8hbxIrTJ+a9AuE9NBSvIifW2s8T9pr3AlhTcXEm7N1WN4XMDCoXifhjd8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With CONFIG_NO_PAGE_MAPCOUNT, an anon large folio mapped by several MMs
isn't seen as partially mapped while its mapcount stays at or above the
number of pages. If parent and child zap the same half of a THP after
fork(), that half is mapped by nobody, the folio is never queued for
deferred split, and the memory stays allocated until every mapper is
gone.

Patch 1 moves the split_underused_thp check out of
deferred_split_folio(). Patch 2 queues such folios as candidates and has
the shrinker walk the rmap to see which pages are still mapped.

512 MB of THPs with the same half zapped by every mapper, memory freed
by the shrinker:

                                before    after
  2M,  2 processes                0 MB   252 MB
  2M,  3 processes                0 MB   237 MB
  2M,  2 children + parent PMD    0 MB   244 MB
  64K, 2 processes                0 MB   252 MB
  64K, 3 processes                0 MB   252 MB

With patch 2 the shrinker reads shrink_underused itself, so folios
queued for the underused check aren't split anymore once it's turned
off.

David suggested a check from the shrinker for the opposite case in [1],
folios marked partially mapped by a PTE by PTE unmap. The walk in patch 2
could clear the flag there too, this series doesn't do it.

Questions:

- Is an rmap walk from the shrinker fine for this? Every CoW of a page
  in a shared PTE-mapped folio queues a candidate, and so does the last
  PMD mapper when it splits its PMD.

- The walk needs one bit per page, which is too much for the stack with
  64K pages, so I used a static bitmap under a mutex. That serializes
  the walks of all nodes and memcgs, and the mutex is taken with the
  folio locked. Where should the bitmap live?

No selftest yet, I'll turn the reproducer into one if the approach is
ok.

Based on mm-new.

Tested on x86_64 in QEMU, so no numbers from real hardware or with
concurrent reclaim.

[1] https://lore.kernel.org/all/20261109220958.2071687-1-joannelkoong@gmail.com/

Jose A. Perez de Azpillaga (2):
  mm/huge_memory: check split_underused_thp in the caller of
    deferred_split_folio()
  mm/huge_memory: detect partially mapped shared folios without per-page
    mapcounts

 mm/huge_memory.c | 86 ++++++++++++++++++++++++++++++++++++++++++++----
 mm/rmap.c        | 21 ++++++++++--
 2 files changed, 98 insertions(+), 9 deletions(-)

-- 
2.56.0


