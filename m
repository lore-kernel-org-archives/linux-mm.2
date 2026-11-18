Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F043606A8AB
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 08:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XFbRPSJF
Received: by kanga.kvack.org (Postfix)
	id AE6B56B05B8; Wed, 18 Nov 2026 03:33:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A97256B05B9; Wed, 18 Nov 2026 03:33:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 986686B05BA; Wed, 18 Nov 2026 03:33:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7454F6B05B8
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:33:18 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5B1F2C03AD
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:33:17 +0000 (UTC)
X-FDA: 85447575234.19.DCBE35A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9A6A680002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:33:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XFbRPSJF;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794990795;
	b=seswQyRNztG3Ec3oT41Mk4S4I4wdtMGKj1wUXQ5AsAiwoFDVV8gR2yOyQfA/uqxpQ9JINU
	yiitFMMvTaSa6Li3xQkUEntyxLOW9lsixD5mgkF3kVPfjsRt1g3g8SVunlwNK7TFitVd4a
	tSBl3S7VJLvnFmV/Rdr4qlKIQ9rFyjg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XFbRPSJF;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794990795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YkLjxEfejJuPL4lHxwbsC8p5SslZ5/tNoomXIlukABk=;
	b=HVQZB7Gmq5uFNNhVg+44h0FaVpyxyyxQrlg7dvkQdETZfEuw569GJ144Uhk6Pk6+McQYUu
	LzAB+OVSH22uLptpOlIOVZvAaEd3aQXfprsKEzp0QjtubKABhM/dfJQjTcqw7M7XC0bIFo
	dOlSxJtz7WLjkws5R13FajpQCiqr3Wg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 324EC61FA2;
	Wed, 18 Nov 2026 08:33:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8672B1F000CF;
	Wed, 18 Nov 2026 08:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794990795;
	bh=YkLjxEfejJuPL4lHxwbsC8p5SslZ5/tNoomXIlukABk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XFbRPSJFX/C69AzQPbkqVw/tMG+z4SsfmFkjidQfMzaUT0xe8Xguf6LVPNwXXQZOA
	 pl4yKwGbL4961etmhLq2EzM6JBV44sVEKbKx+9UM8VAnOvmW4F83SfyMHjZxasqmfG
	 GiKhIZe50KVtwYY4gq/ssBgCKx1mAcrKGNF6Z2LizVFZ8KZu6P4CK33PGEcFmcfK+p
	 HhP3bN47BPnVJJA01SYrXoLAs7Iq9AgsLupeYRubilFyX+ovvCAIGZJ3Zoslr4mHPm
	 NT9bXtUUK3iMkBugZzfwE2ipoe2UmJQbBOhAjsZ5//eGzEu//yAnBnNP4iDLdBW5tq
	 1yfGaEuCxTpLg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 18 Nov 2026 09:32:40 +0100
Subject: [PATCH net 3/4] net: skbuff: limit folio refcount when splicing
 pages into skbs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-skb_refcount_overflow-v1-3-5551b4954c3f@kernel.org>
References: <20261118-skb_refcount_overflow-v1-0-5551b4954c3f@kernel.org>
In-Reply-To: <20261118-skb_refcount_overflow-v1-0-5551b4954c3f@kernel.org>
To: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Kiryl Shutsemau <kas@kernel.org>, 
 Song Liu <songliubraving@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Rik van Riel <riel@surriel.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
 Pedro Falcato <pfalcato@suse.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, "David Hildenbrand (Arm)" <david@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2437; i=david@kernel.org;
 h=from:subject:message-id; bh=Sq30vkZVXk/xrSazqlDw0jf8y1oNryrxNBcxU8XdZv8=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLL+Jm37do1P+X5R0+dls19/cVWo8OU9eYM58WMZ1xt93
 fVtV5c2dpSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjCR7nuMDJN8wrev1035+iXw
 /6Qr8rILmL8d3be7VPVghYdIUK3ywxiGf7Zehb6Zbb877p5gL4l/pCVmNC/A6Kag+srMh0kWPOc
 E2AA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A6A680002
X-Stat-Signature: f7dms1f8ubmnfcpsiunzo5rho5uw8s6g
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794990795-652155
X-HE-Meta: U2FsdGVkX1+9Tnp7eOOuXhsvkVzlqkNubePC/HUo753b9vQ4YV2WMm8fMcUk/97s2dsfF24KMCasCPOc2nf4TjA6fik5Squq4Qe1HXuQiFWOUj4EEbaLWJ2b4QKHsiaERHJS6utTT4U93SAdUSGFaQv01XoK2zECtBIXNLWwHczMaTfH0oR0kp4EjNX4pusvsUqA+xpKRJvS7AHmTagShYGIB/8lu+g8ac/hHRplwHGuXPdXe4HctY6b8G74tOZMOZ/4tpNR0nJEZBN8uz79/fNsZD0EkpMtSCnqD6nTDJy1MLtpk65Ij7iTh7yPUbuy1Hd9aSmfFrc/O4JyVCWj41gHRCDPyD8CBhwv1F0urRXiuxMwSaAJEwMwkDiL3zaBU2YKy0S8Kb+O/0Qb+2jdLBiGut/qVY1W7Uq7SmXYYTwbwNVpyLeLtPn1Zy5JjXhF4xPENSVLU2GtQzw8WPIJApvNb+5CL4BBUBIFcidNhFLlg6AASRL4MLxmG8BYkSLo5mvZX2ZUG4LWJQceTz2YSdNNUv2czJ2qStQ1jMlZttl9Ey1t9EIuoeDotRTxH9b5r9l8lsdRH7Xv0mbYcw9WZcITQWi8yopL39gxT7BMQ93G1IfbDTGZ57OUpKhAJySe1MNkdTAR7iteE5+eWfyLH4QRGf11njMiQz3I2CKoC65avgbWIk5mfDHKDXSrBROFPl7eSiQ1lXDN+6xWt8Afji+nya+wk1Jm17ZEfm/63g8LrSb6r76XlSdgzo1vvmIEevFK6RDHENfy7a8KWpIUMzm7gSbct8AAmvxfwvGNneOw5GYU2AwXHLQa26I9yQcs+KJVE7yoA8JWMkMuAtF/0GkqJCKq+vRxeheseBOUCz/YYd8drT0y+nXccSwlrOqecsGXsnfT7poWItUX+bWs4OU4Hqg83WYtSv3s4wo/NxphXBzdL+aSfl5PHR0rhNuY92ueCcn2I8ftrb6oYDC
 5UA82dM6
 gM0YRRL7AjyKMQ5F/Q+zD/Q6b2zjv6M5VEBfrkopArwOTARsZI3sD1ykCqF9nx7s//dhY8e3Ox7Y0j8PCdmvBABnw4MnpnIMW6UOtfpWxU6C0ELttoylUl/u9S+GLBqus4vy4so7cMAIVEHrYxbuOtfOV2eYbGMO74ce/Cw5O8ckRsgCM5oyawEIh9NCt/ziMCXP6VOBQ4l3DUuYT3z6EXfMd+0vCCphkD9BUrtRNcLjFEoor18Qfvjx8Fw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Various networking features use MSG_SPLICE_PAGES to add pages to skbs,
whereby skb_append_pagefrags() takes a page reference for each fragment it
adds. Pages spliced from pipes were already checked when entering the
pipe, but in-kernel users like sunrpc pass pagecache pages directly. This
allows for exceeding folio refcount limits.

This is not specific to large pagecache folios, but with them it is a
lot easier to reach the refcount limit, as page table mappings can cheaply
create many references.

Let's use try_get_page() in skb_append_pagefrags() and fail with -EFAULT.
Don't use -EMSGSIZE, as TCP would just retry with a new skb. The only
caller, skb_splice_from_iter(), handles that.

Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Cc: stable@vger.kernel.org
Acked-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 net/core/skbuff.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index bed1c8c4c6b99..c937d74eed6ac 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4714,8 +4714,13 @@ int skb_append_pagefrags(struct sk_buff *skb, struct page *page,
 	if (skb_can_coalesce(skb, i, page, offset)) {
 		skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], size);
 	} else if (i < max_frags) {
+		/*
+		 * Don't use -EMSGSIZE, as callers would just retry with a new
+		 * skb.
+		 */
+		if (!try_get_page(page))
+			return -EFAULT;
 		skb_zcopy_downgrade_managed(skb);
-		get_page(page);
 		skb_fill_page_desc_noacc(skb, i, page, offset, size);
 	} else {
 		return -EMSGSIZE;
@@ -7613,8 +7618,9 @@ static void skb_splice_csum_page(struct sk_buff *skb, struct page *page,
  * possible, copying them to fragments if not possible (such as if they're slab
  * pages).
  *
- * Returns the amount of data spliced/copied or -EMSGSIZE if there's
- * insufficient space in the buffer to transfer anything.
+ * Returns the amount of data spliced/copied, -EMSGSIZE if there's
+ * insufficient space in the buffer to transfer anything, or -EFAULT if we
+ * could not take a page reference.
  */
 ssize_t skb_splice_from_iter(struct sk_buff *skb, struct iov_iter *iter,
 			     ssize_t maxsize)

-- 
2.43.0


