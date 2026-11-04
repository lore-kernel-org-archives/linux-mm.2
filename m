Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6683F606A32C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 07:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=plSfkN/Q
Received: by kanga.kvack.org (Postfix)
	id 81BF76B05B1; Wed,  4 Nov 2026 02:10:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CD2E6B05B2; Wed,  4 Nov 2026 02:10:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BB846B05B3; Wed,  4 Nov 2026 02:10:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4924E6B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:10:18 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 58C4B12057D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 07:10:17 +0000 (UTC)
X-FDA: 85396562874.08.3A8A76D
Received: from mail-pj2-f0.google.com (mail-pj2-f0.google.com [74.125.227.128])
	by imf12.hostedemail.com (Postfix) with ESMTP id 99A3A40006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 07:10:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="plSfkN/Q";
	spf=pass (imf12.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.227.128 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793776215;
	b=X4FspV0S3AR+04OBAO+VBMdgFbzzjBy/RGizBNF3Pa7zUcMnYyEWt/lHYkaQmlkXKx7q/x
	UTIbr4mdWPa19yOH2Hc2ANbHtnsBQlu9Bpht5X3r/hMIOwJ+7G/1pPizOeID8sm+G3Bvoz
	31p2ipEA4xGTskK2mNMMTA5qz1vaLFA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="plSfkN/Q";
	spf=pass (imf12.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.227.128 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793776215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JhcjK44jzqfwISimpbYLtHkEsfZ2sH/PIN1jlamuBwU=;
	b=uPLJnrlS6dbJbYyL1dT4Hr2iMkCxcRKy2L0bMMn6ruwHOkXqqrb7HbHQIT16gR1VdE5+qO
	zHZUzujL83mBgmz06SG8VFzoZUKKJaX1XFLilW9IYAMeHz7ucsuFG75VwSc3+EQRHS3Bxo
	PZ8Md8mfph4R5ixDLFUvaOcYih5YG6Q=
Received: by mail-pj2-f0.google.com with SMTP id 98e67ed59e1d1-3b094d5f1b4so155091a91.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 23:10:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793776214; x=1794381014; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JhcjK44jzqfwISimpbYLtHkEsfZ2sH/PIN1jlamuBwU=;
        b=plSfkN/QXXklAagVEmFC01oZ7yId4F+xKiRnqaEhiBlE1ZLFl1AYlO0sxxadb4QvfT
         35jdGu4QT9EvelC+ulpz2wRhfjCBF5bC0Zkj0H71UdPxQkxTLy96RK8SrjaUTcHs65Z6
         6aHxPkbyZ4EIJmPsd6KV9CFykJQ30TX3X+GxH3K1z7ViDEOPbQlOWk5eZHdV60q8n5h2
         S1fbTgHVZltYAHdrPOkDAVc+0mErYTHPSMTvkNWM4FDrfm/mbH++7dcEfSeXnxxnuSC8
         aH9SJPsxDuPrUlG70G+WBZOnOqa9XokqMLoGgIoswnKrnnTvdtViCq9ZvxPfgx3dsO/q
         BZKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793776214; x=1794381014;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JhcjK44jzqfwISimpbYLtHkEsfZ2sH/PIN1jlamuBwU=;
        b=rjne28dGU4cKujP1M/gloOcAf6LMHEeJv339cGAPIydydR6ta4FlZRF3F9O98FaMVP
         Y2aZzA+PWh1cHaPmuDbZaIPCczSFO/BYDTbtqNu5kO78953qxwtXj/mJQPQBZAaxgF+w
         SNXZF4IjkhTaHUJoFjWp/H+V1KwfxbmR5Uohh0RB3s0SYOY9qPb4hNYmjUkvsn5fdLil
         28sNDIJau1ciWn50AK33oNj2B2oC8BknPGyXsqWtXMQabhsNAnSbkGkCzJifxJIt6xFq
         aCYIZAont0xuTCNSJesq7jmoetHCiRcOUZKTThmgdK8tOA2eVPjCk+xtiPiFa8mIT18N
         6/oA==
X-Forwarded-Encrypted: i=1; AKwUvByK7M9zkOYU0fFOohVNcJU1dup4JuZN7UG2DB2F1MAaWsCnp+6OKXAixQwVKfQMEBJ3Mmoe66vo1Q==@kvack.org
X-Gm-Message-State: APuU4Z/HmrnZzwxQde+QmE4my29dEzQhj3ywn6itaqCsvaVUomzn6EXA
	WSXbNMzVYo3L1X6XCFfXzAq9UWMTEWMazCAU8HZhS30nyvTvyBYS0pCy
X-Gm-Gg: AYBFou2SJMtSBfU2zEMrWmZsw757iqHHVVl6zR2QuVyAA04zSLBd0xQYu8qUkQkN+AE
	gaBqk5DBWzRkR/opcK90yr2I0If3pNBSOqrdAnAEm7nx8LPJbrtByK8hGC/d5jdo/p7UC7AnP/A
	Q22vZixGIBX/jE/MzCR1BLy/DVcSIYhSf4qttSK9p0O3igbPCsk/kE+VVar6IebAv+B6BRRcZh4
	THyR3+OAmO3ZYUJu97Sh+p4M6AH8IyRDtTOiA5dtr0vMO3IvkLlbO33Er5TzIc9d3KvI0zxBqgd
	xA0YH18anJHDjCJ8DUTXRyyQ57m32rXXdKZzpoSmt2rwlYLdq/hz9bF2oKA6//B8pI7GuZYMHH/
	a3y+VMkQbZBX7TZdEGL90RzOI2fItJbHZBqz3zNCcIl4dR3sUfhc/NsY416m3dKdAcSmEA0K5TB
	WYOqxJE4L6A8XbDwYG6FqvTlXTv4/EJSEo0+kWRm+3KCw/p/k88zVFqXbLR2S53xTkdvPKvQ3Wg
	ARa6DXTcjZuNFF6spsaNSEqVqpI09ykKt9QMaN9qL4NgMPnMxzpXzG95V42ZmvdGlb0q30R/VUJ
	lsZIju1Z0srPmaf5+FQD7ceioDdGYah1Mw9sF3sLn5RGEn+zoQd96MzsyAv0zTB6iWMaX6p242j
	NynP97dybVxToqda0/m86klkXfuPEN7Eb6Vkz2Q==
X-Received: by 2002:a17:90b:2547:b0:3ab:9c73:12e with SMTP id 98e67ed59e1d1-3ae89536c0cmr12582654a91.6.1793776214401;
        Tue, 03 Nov 2026 23:10:14 -0800 (PST)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b093d481a3sm2651997a91.1.2026.11.03.23.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 23:10:13 -0800 (PST)
From: Hungyu Lin <dennylin0707@gmail.com>
To: willy@infradead.org,
	jack@suse.cz,
	akpm@linux-foundation.org
Cc: kas@kernel.org,
	dave.hansen@linux.intel.com,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Hungyu Lin <dennylin0707@gmail.com>
Subject: [PATCH] filemap: prefault writes starting beyond EOF
Date: Wed,  4 Nov 2026 07:10:02 +0000
Message-ID: <20261104071002.49693-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wh8tsuan1iggyyaso3unzumr6aggd5fq
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 99A3A40006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793776215-58500
X-HE-Meta: U2FsdGVkX1/NXhYTvZmdu8U79EzeZ4rY8KlaZyPBB1QoZvlTpbI9EMZRJQTJ3ZZUNPwZB4Pv744LxkEJROJGpUsfS9Vo8C56OjTUfteHgcEvmuOIE90Mvu1vZnzVEVYVzG0bgsViQSyaExRjoYkIUZ+XhEwZNJRe6t+zx8Ra1obIRk40sy9SHlBNxHcZecvNdJzb2hhSMB/K1DOpAcAOIPjzv+EDtglEFQe2oiTp9Oq8y7v7ddhS/4RHa8hkGik9FF55CMr5FYvZyHU9TibUyEsOhPn+OHr5zqAuPASw+SU32EkRSPMLTa8Cts1GXp2Z7WejD+mHeq5WTlv25DS7LpdNFbkZC2XcQm/5Akr/GAwc0J0ayw/pQvo0lEHkyzwxDcaKGWnTvMyZ5Z3LqR4OC06XzxO/ruxaDuInsqdjCt9a9iJ3cfw9oVG7pg09qtBNW65QfvxJaS1cVdIaIB7/HrW7C1prcyiTLp48dK/rXJ1C1zPIzMuYvwlaenr4tlpim0geKyxR5Y5UxkwUo8gNJNlesj7pO3cTCaaQj5l0MSvQKMqgVmoPaQtkCwEjudW0xEoOYvmO+OFYX0xXr+6NmiD6DAi7idav/580OdiAqwtGF4TtMcjsS2WyiOJLqs+VKg4UfQQizd+TynA4c5H6nXlxvYjvcFfS15L0Kq7tp1wsHSvwrCvj0EU+G6TzTrW36G767wXnXUFXH+7xqW22cWJIPbcGK0CvAF7Fosjv7ieX0OZLvBW4vvaHqLkwinU/3ymF6RtHEKHKrf3hys/m5dp23sVZcYp4RBIt3JCxJEqYxHybxbyi/c1nwapVRc+45yse9EHMYFLVjvJKP+pwuqEUyQKrJWRqsYJMZDT0QrIhb2y6p7Tq0aEs3LZa9HtS67PHlrU0wAKTZ/jRTmWLAx9liL10QQEjRyohPsLvPrKjo+0UPdT6FWEeS0aYE17YJNf67XbVTERUfPpxZ1Z
 LVB5Mn0+
 E6Mjl59P6V7Mkdk9EIWS6NTssshHXGwwjhwEX7fBQ9bcXAuaXtJD0JqlcK9w8uxGIeWf3FXitzwWRNa1NrVFi7RneezMSLfaJqZISffiWIQrirQc0LhouxznIjwcuqmR5hIe1kSGdOlq5LRUxw2gJ6pzPaqTIxlpQ59Z0gqT9DYgg1WpAVizn57kRgTmh0M4QeQA1xVmm2AHwDlefJu1EUbIKbiStsL7CNS29lFwit6InNeu90pSIkhj1A7aFD53Pq5xN0xonIuWFoyFd8DyFRkr/4RtVTp0QKhradf3oieOx75vAkxoZrrwhmNu/o/cK4tGKs+tZdYtTKHMnT6FEaS1NiSDp9fcQ+tGbopNRrtdpB3DqIS3nKSsHQVdgpQCoH0UF5oyc38P2hTc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since prefaulting moved to the slow write path, a buffered write can reach
->write_begin() and ->write_end() before discovering that its source buffer
is unreadable. Several filesystems can extend i_size in these callbacks
even when no data was copied. For example, a one-byte pwrite() at offset
4096 into an empty file can fail with EFAULT but leave a 4096-byte file.

Prefault the source before ->write_begin() when the write position is
beyond EOF, and return EFAULT if no source bytes can be made readable.
Overwrites and appends continue to skip this prefault. Keep the existing
slow-path faulting for forward progress after a failed atomic copy.

This also leaves intentional zero-length ->write_end() calls used by
generic_cont_expand_simple() unchanged. As with the previous prefaulting
behavior, a concurrent userspace unmap can still race with the later copy.

Fixes: 665575cff098 ("filemap: move prefaulting out of hot write path")
Reported-by: Kiryl Shutsemau <kas@kernel.org>
Closes: https://lore.kernel.org/linux-mm/at9xXRhD2xZhszEj@thinkstation/
Suggested-by: Kiryl Shutsemau <kas@kernel.org>
Link: https://lore.kernel.org/all/at-XtWBQg3jv3H8Z@thinkstation/
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---

 mm/filemap.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index b74bc1e5015c6f318333427f223b9f42061a6213..30414d55412b84f11ebe98b8eea607ee8c04eef5 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -4389,6 +4389,16 @@ ssize_t generic_perform_write(struct kiocb *iocb, struct iov_iter *i)
 			break;
 		}
 
+		/*
+		 * Some filesystems can extend i_size even when nothing was copied.
+		 * Prefault writes beyond EOF to catch unreadable source buffers.
+		 */
+		if (unlikely(pos > i_size_read(mapping->host)) &&
+		    fault_in_iov_iter_readable(i, bytes) == bytes) {
+			status = -EFAULT;
+			break;
+		}
+
 		status = a_ops->write_begin(iocb, mapping, pos, bytes,
 						&folio, &fsdata);
 		if (unlikely(status < 0))

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.43.0


