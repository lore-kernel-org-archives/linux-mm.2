Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D46C606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 23:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=FwlZM3wu
Received: by kanga.kvack.org (Postfix)
	id 1A4C76B05BF; Mon, 23 Nov 2026 18:39:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17DC56B05C1; Mon, 23 Nov 2026 18:39:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0442A6B05C2; Mon, 23 Nov 2026 18:39:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A99A86B05BF
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:39:49 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 865B51609F1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:48 +0000 (UTC)
X-FDA: 85468003656.03.1AF3443
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com [209.85.160.72])
	by imf23.hostedemail.com (Postfix) with ESMTP id D84B7140002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=FwlZM3wu;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3wc4EawgKCNAz8wF7wy62AA270.yA8749GJ-886Hwy6.AD2@flex--dmatlack.bounces.google.com designates 209.85.160.72 as permitted sender) smtp.mailfrom=3wc4EawgKCNAz8wF7wy62AA270.yA8749GJ-886Hwy6.AD2@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795477187;
	b=XTdvCloM0l/4t6yklHNV37lAugEiX6W0cVsuDODiZkdVSX0QltIcSonuttAkyQT2H7CacW
	XZCNAvDGIPykMcJDullZpaqsggG8Ve+4vZFbgfh6PZHHB57v0QWCfREYZ5blHX6kFkIgI2
	/k7gxhRdcFbEgqmqNutnXXZ4A/jJAOk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795477187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+dO/10Kb1crg9LuSPobtfRm8dvZ5s9kHfaOxT9vk0Y4=;
	b=u7jtz2VJJDamuSxQzlhRwyFW/LK5P+PdZDpbqi91bLc/oRpBD4NEayaNgTPg/vJ67Euu7S
	E+LCb3l90TnIcNLeSGxySkTw9FS7qp05w4Ctv81YJD6T018H1GOyC7fCTXjZfpaKGTTvXH
	Rl9k3AQ6gol3WoHe6gYspQjtP2afF2Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=FwlZM3wu;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3wc4EawgKCNAz8wF7wy62AA270.yA8749GJ-886Hwy6.AD2@flex--dmatlack.bounces.google.com designates 209.85.160.72 as permitted sender) smtp.mailfrom=3wc4EawgKCNAz8wF7wy62AA270.yA8749GJ-886Hwy6.AD2@flex--dmatlack.bounces.google.com
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-49e5451d6a5so3595702fac.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:39:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795477186; x=1796081986; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+dO/10Kb1crg9LuSPobtfRm8dvZ5s9kHfaOxT9vk0Y4=;
        b=FwlZM3wu6y2vKyvPQEBZ96w0W97dWDDID28CRN7KnnwKCle5HFhnpvP4mwZR4oxxk6
         MbL/dwG3sHdSlZwvXHZycd1AR96mdNEOxv20fMG+TRAleP942kmH40WOesElPW8y7nCA
         9T2rGIq5HRaUkbuAStwuurhVVutwRyW1qeCP+MTKzU8GmWoPSOiaVYn3A7Nkh1wBUVAb
         iPrUKJBT6AffUKq37hG1jT4si6sh371h+40e3RWaccl9xySxr3aFKwVQkyTz/lEU8uqs
         J2e7+YheRYQm1wsSxOavwjLZMvkAoq0RyVgfksqQ3T0X0HyDm9mFB0qh61JfxIrHh0Gg
         E5lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795477186; x=1796081986;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+dO/10Kb1crg9LuSPobtfRm8dvZ5s9kHfaOxT9vk0Y4=;
        b=cUxxvGBdnPsYv6AidGZ8+oJ1+xE+MBwSwIZXJsO0r1asG9+BHCGzXvhFVal4BVKQxR
         TIYGHSrHqd0EpYuwnlniI8gO+h/h5XRo+LAJPktEqcw6B1vfkpThYNALK5cuPnepN4cf
         nmwHKkmOXajzerd4cqnvrEGNa4ODB7F+ewtWqmMcgCdJwvLNFTPNmEWeqXea7BJo1JRz
         sAtPNjtQtNNiu4NK/vy56wAT9xugle9/0oiqzMqT+f3a1+EPjaZ09VzzPkhPJe8OOhJa
         /h8Agpi/IByg7hJq2ICvMFgSEEip/r9tFOyQXmoyJNlTec5R7DBK+1T3UoXf2ilg+RaZ
         nT7w==
X-Forwarded-Encrypted: i=1; AL+hErFFiYI3PNq+ZeYr14yWp5R2CCssDnYry3yWacQn22qGFWrsXl/EvbjbaWsVMPZNm+uid193gaeVRA==@kvack.org
X-Gm-Message-State: APuU4Z/mn71Bnx+AtU8q4YETymnJeTgPqxxihfpNAyYPYG5Lu5CyhPly
	jHQmZY9kd6yBGZ+FiNNS0H6XXVWhgFWEK0n1K7SZvTiMmjowFVrY+zyjW0T6J/GK6gNJgKWgHva
	V9pUpaiZUKNU0VA==
X-Received: from ilej7-n1.prod.google.com ([2002:a05:6e02:6207:10b0:54e:a760:20a7])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:308b:b0:4f1:6c9c:78d3 with SMTP id 5614622812f47-57a0a92272dmr14361377b6e.26.1795477185579;
 Mon, 23 Nov 2026 15:39:45 -0800 (PST)
Date: Mon, 23 Nov 2026 23:39:17 +0000
In-Reply-To: <20261123233924.3970932-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261123233924.3970932-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261123233924.3970932-13-dmatlack@google.com>
Subject: [PATCH v5 12/18] mm/shmem_luo: Allow preserving tmpfs files
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
X-Rspamd-Queue-Id: D84B7140002
X-Stat-Signature: reniz14atika8bcyjq4cr16oz5zw4w3m
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795477186-309117
X-HE-Meta: U2FsdGVkX18pFp1dwJhVkh5FI3z7T2OgW2kqeYfpmCmNISFm51oEOtQSpaJcntLlKSD/Z5LO1wJ582Q/i4YMEr6j6npCz0rwI4+2flrUcNxFflywTdAkU8eXit8bOm8BB6hTwOmzUlYHH96W8he/gEQSoJAGCHSSkZGD1kUOGGa8AuCzfB5hwsLL28GmyvBCJ6EKH7iK9lSu3eTYmiueutT7P+JdwT/bUdCdbh+5WGlqybslFkHsAQwsCYkBcc+i/PMbHvZ1OKSDDE/7K9+JdJaxiHLJj9JuU9PER14m+s1LR8kR1ac2bFPWa7WGCY63sC63IjcOHiBg+5EeBXyehMa1ams/8xc1rQG4W9LdRPB0OESNwwJZXqu4RFlcvdPncrGXoooYLJ7jPSDYQFbVUXQHEepF25gC7K5bJY1P8LQOxECCH5xhJ3iWV6jiCcfLRGl+/RzHiPawrvau7hcQFxbsoFnclA8DMQEtHJS95eoB925lPqA4ppxSFhK5U1xRgCgWoIUBdBJ1nF/QR1Gz9vrsNh1PrGhQWy64oE4xPG99DLBnGi1mbxpTFidGzk02AaiHWZNtj6T/U/1xEjnN3YDKK6A085RZ4hbNGym7lp2upgJJzeaafk+matHrH8vcPsvg05DG4jR2iSgyTZ1PRzEfENFnqmpuAyvgMKwdQOhZBhk/ePvGM8YecfSz/TWWU1VurLTMKO12X4EHY20qixCUWCPvH1MiCsXEmbw+wxI+2YoCik69/xOTkcjxd4DYt1gLkJrVofT/8EiZhqLqLz2n25N835d0xaJ8p//mLMpPq2GnAwxn8m2JlpKzerXSw1MbmS7s4Pm5O/B+dZm2SFkDcVVJsrf5jB5gzvQyps2gMT/zdI4QUD8v3V5XNdVMeu+QhwAJmlE7jlHfq+6bl0JEj14FmPZQhumNBSgfP6/f0LU+E/7BEJPeJav0nMSe41vmNZhGkAfc9mUe8aQ
 kTHjupNS
 +tizxhjQ9tHAFpArRpe5+UUGXX+f1X2b+tdFCf4tr5gqpdxMpCB4fJ/S34Iwv0WvDsN6MY4UUIXO9Mru7BsFBJ4hDE9cr6V7WSxHrNa5FZoOwujyGOyUbiHXCvwNo7R+wMHFyVX+OuOYeKFb5+8y+AeUx7/I77uPK2xXdOj3L93N6U9rcd6H5ae/TJ07yJskSz4QTDd+eIDthOylPtfdUFENKTdqqi4Mtpwq5fzJC2koZoPK8pqvZSA2gnIFPifzZ7kYkA1fOoA0evUz4XdY9kBsA8lvWvALmw7SzMvL7jKoZbvS9wkZmdMiPrVDV4ggdVnXAFvyXI0TgG1TARmOAz6rtJmfQvn1av6LNLJX+mJQrKjCqLCGSXUL73vU/MS+AXoDjHXC5StEmszE746gDzFsomQp0ZcfmNSXWDSLGZiaE++0scSZvocvnB9nj1HnTnIZvm16MNpR0vJ3p6bkXKViX2HMZILgiv6i7M4ur02N4HkkxpbRqvU1F1FTWCpSmAiAdxWZL7jrEGGUKdI3vFWZFboxRtdb4Pz/IksDplPCj3XBJhBz6F2/rgPcu5m8SvSozmhIHQN+bgYO7YY0AoLAO8N28YivW9HvFVbwUiS1vMyvlsxtw0sWeWV8UE6WVpiU9t6Q/OigxvH+yMuw1ObL7MF7heMsQsy50sKCyJSbsUzZ0g8uEZaGvkzID/T3i66PUOC1rKd40+KXT8a2EYXeRKQqlBQFVeYF2MvG7wEBg0bjebgbqQclR+BLoqcRqOMQPRQL9apPQEhoa6EFKwWCFJpCuLRRicyByeEldiPhtzwdFRi7i4xZrSPqlIbwo1ShV2VVakTPrsSNB9/Tr2J4UnEvON+1Ar9RPRRQakQHrRC1TYPpYKrkwtbEvQzMhPHz3dDxP2k8FJtQqTCObXteIQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Allow preserving files on tmpfs mounts by dropping the link count check
from shmem_luo_can_preserve(). The check was meant to limit preservation
to memfds, which never have links. It isn't needed anymore, since tmpfs
files are now retrieved into a file on a tmpfs mount.

Userspace can keep using a linked file by its path until the Live
Update. The path of the file isn't preserved. Userspace creates the file
to retrieve it into, and can then link that file at the path it wants.

Preserving a linked file affects everyone who opens it by its path,
since its size is frozen while it is preserved. The permission check
added by "mm/shmem_luo: Require permission to preserve a file" covers
that: Callers need permission to write to the file, or must own it if
its size can't change anyway.

Signed-off-by: David Matlack <dmatlack@google.com>
Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 mm/shmem_luo.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/shmem_luo.c b/mm/shmem_luo.c
index 2ea161fb00fc..ab7e5f51dc7d 100644
--- a/mm/shmem_luo.c
+++ b/mm/shmem_luo.c
@@ -777,9 +777,7 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
 static bool shmem_luo_can_preserve(struct liveupdate_file_handler *handler,
 				   struct file *file)
 {
-	struct inode *inode = file_inode(file);
-
-	return shmem_file(file) && !inode->i_nlink;
+	return shmem_file(file);
 }
 
 static unsigned long shmem_luo_get_id(struct file *file)
-- 
2.56.1.809.ga0b61035b5-goog


