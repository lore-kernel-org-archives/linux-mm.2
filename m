Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 945B7606A338
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 00:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=h9cKAkhE
Received: by kanga.kvack.org (Postfix)
	id A425F6B00EF; Mon,  2 Nov 2026 19:43:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F3526B05B1; Mon,  2 Nov 2026 19:43:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BEB46B05B2; Mon,  2 Nov 2026 19:43:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B3116B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:43:46 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C7E9080255
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:43:45 +0000 (UTC)
X-FDA: 85391960010.05.9AA1A00
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0D19A40008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:43:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=h9cKAkhE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793666624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7z1HE/KjWOtf8sdZhPk5sTCBtLjDDSjEVH4zmusVOl0=;
	b=2E1tr6Adx+qejZ80V297laL+ClbnfJ9su39qd3ORanfAM8s30i0G752GVIYZbN3YfEPITK
	NCtxMoP9HpPtLR22mJtdHSQLspuOQ0CEOIuNgS21j3I1uNMKNxnxhL26mBxUi+AjNmS5va
	iKiFPgtllr0wZrJCARGtcblnMPtZRdA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=h9cKAkhE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793666624;
	b=E4T0Od8M2pDFn4nUodZ3SBXFGRQg9FDQVJ7XFJAI6xxXESDw62Z4dDh+VcE2PeVHK/m+PU
	24Gc0Q1y222dk6rcdZnBR1WpttOzIzTfXv8YHz2x5lbDOV43fz7eJKwLJH80N58HBn5orP
	oZ59cS1acjh2Hffwva5NYerkap4CQ44=
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-3550c917fd3so4989373eec.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 16:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793666623; x=1794271423; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=7z1HE/KjWOtf8sdZhPk5sTCBtLjDDSjEVH4zmusVOl0=;
        b=h9cKAkhEUiSKxE8vp2XTRn0ohhyebKRQMFPjU2uFmVupXFruW8D0498KykASzHebhh
         AxkXmTFlXCTQkplH3ksV1GxCekdb/ncDH4/m8yytsBqkOAcDZprpWPDJYXNzMMDj1+cg
         34F15bJ+3MmjbAY+54/SJH7yy0PjfK10wqxeG0VQmgWUBH4JJfwifWT6bk0GG836Gh+c
         be2/tsO9/KP5Qm0V4Zh/LL38qNiXxleMjBhK2iRfOKYDqxUnTB2ng71z6YNiMZawYBqb
         f5eSAzJkXb/hQt73bSQuTMBcIq4XPSkz1Hk29uhE8i2AyQInz+Kn3attD95ECj8GRUPQ
         ifQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793666623; x=1794271423;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=7z1HE/KjWOtf8sdZhPk5sTCBtLjDDSjEVH4zmusVOl0=;
        b=icKy0srUyZntxCDBbM95Uh3kYmP5lhhiYE0ddZJRCeAmDs7eEmZOGH/V0mtHBq8tT5
         oJ+Uf9D6D8y4rJDqVAawtUNrODHXNmdy3gOrPUiLdsROv9DKTlSklVzStDZ4Wg92HTDj
         zc7UOe3MRv95BSyIjMgk2hxJVF9rhYHI6IAvTwmdoH12e/ZvyKL3plne8TiPStcl6w2F
         7dUE68qjxUxu3iIeQ/OgCRapBM9QstYqG/Y/rICSJo3tQS3zI5CJGr1o461IbkVsha2i
         MTG24wCrb9svJrlLuP7UXFXd41mxcXEN9/iHcNwUC9LHHRhiLqFtoNObzZuhyqLsTfft
         6bXQ==
X-Forwarded-Encrypted: i=1; AKwUvBwYntcUwOksUh9DY478i4EjLPkhQn554FWqgvtI846S/mvKlfg2PWpHWstTZEeJncSSjt+GFvWzAQ==@kvack.org
X-Gm-Message-State: AFq9FYKpwnXHCU2TmbF+qiY9y5Pi8c1pxqpKt23VMdMxX644xlvr9aFB
	Kkl33jtfTgONOahIFhE/bFdSQjLL5+RBckOPgav+ii5TId7rPBRYdnQg
X-Gm-Gg: AYBFou1jkIQANi/bLf0KBvZHLd9I89lP0NdozZyHb/pluhlxPra4ZzMrKXqoFtXtR0/
	/CW0NN/bOh6zbMu/p3YqJYr/bvk3nPYo3/OCmNyK0xE4BKSZ8JNVmx6TVtSR7AaVKK8jenUkCjX
	0o/0Cb0kigY628txSSlOpp6bwoPOflyyuhwm5OqcTYZvJ6j12fsbvHx0SMXUpuH1icqhzZrfH92
	bpBX21+RZ1SLSNmQeF9Sybp3TuVm6G4oJa2GaVGnEYddf8MTg49FJ9LokBoBNc+UA9i6DQL6fpA
	krPeCRIWbImuzSJQiU7p6D562zYf4v8fJ4bxeFE2pYHGmKCBl2pBcNrqXFxMzGruqZAUPpsS6/9
	OMhPsRXO7w3bBeCnnXsWEGQnX6yiNb8LMcTun1m2TBnIAECPdZ1wg+D9cBvFl2j5ioTMW33wAIx
	AsK8gdmuWWm2OfS4cZYprFcXjt5hSZcNYEKYEzVfIjiYx4W4M/ymAkkhdn7mGX4jg79IhJE31B9
	hJNciZasBw1vMRormmkMU4gAUeg9VPEpEEIspIxLRgJ1P3AFTrakt92QsdwfURVC33HG5XYpn65
	KCeqCnsKNMic9U1041H8OAfs
X-Received: by 2002:a05:7300:fb02:b0:358:5bc0:4f08 with SMTP id 5a478bee46e88-36a425f611cmr15512454eec.37.1793666622592;
        Mon, 02 Nov 2026 16:43:42 -0800 (PST)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428ecb61sm36846013eec.10.2026.11.02.16.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 16:43:42 -0800 (PST)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Mon, 02 Nov 2026 19:43:37 -0500
Subject: [PATCH v2] mm/filemap: clear page cache marks once when removing a
 folio
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-bug-mm-filemap-init-marks-once-v2-1-985753b11173@gmail.com>
X-B4-Tracking: v=1; b=H4sIADgu6WoC/42NQQ6CMBAAv0L27JoWYgVP/MNwaOsCG2lLWiQaw
 t+tvMDjzGFmg0SRKcGt2CDSyomDz1CeCrCj9gMhPzJDKUolRSXQvAZ0DnueyOkZ2fOCTsdnwuA
 toakrq7RWV6MN5Mgcqef3Mbh3mUdOS4if47fKn/07vUqUqJqmri69VaoR7eA0T2cbHHT7vn8Bw
 qJ4xcwAAAA=
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0D19A40008
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: n1xsz7u9ikf13k3d7qaxr7a57gnxznn9
X-HE-Tag: 1793666623-585706
X-HE-Meta: U2FsdGVkX1/oJWQw0PWgCeLslruDPtERoo/+U+L42GtD+i4ygRVMU66AbvtaVDdI3y3SU98N5xE8c5tSLJTWUCGQyO3BpSOI66cPQqNB857WUYeA5tdBfNvSxxC82mdo1Ho+um1iMzYrbTJcWlcyI7J/iVraMQz+ZMkHk5rLBH0PY8FFHn80B+neBDDNcp8vIhUcJm8tzV0ROd45TXXpfLVOLj+eZT15D27BrK8C6B70RinA7eTfU7Q8hRKnHs4YHQK2WItGp96akATLMJgLg4BxbximbiibUEGDq6h+PwmwlfVrPQ/Am9uAMGfikQgZJ9we5AkRtABe5nppvwuToH4Sr7zc4TD3cRDwmtvqPml0ORa9HQMKsGo4GE+XAJnkiO2BgeH0fRtdp09xc6QNAP09wfqSs4jYHuJ58fBPNKU+fFlEqqo2mDmVHJyALzCHTeE1azbiWnqhEdakJS4dSZ1SbsyW385beeWjq1VlnDxFOSaKSlshkiKGXNmvath6k29Tv5selw1NoZxLd759nprannQlmJll2ttNX5jdOpe9Tt4Y7bnu+iW/OO/bv/1j1XCmhqhFAa0XmCHddX4bifQAqtDt+KnFrtPfluyd6xfcvdHvwHagjkwCMQX8VcFZuNXpvK+0d4Xbnbk1oxwaxTk9K6k0ospQuqPspIay04zaDIUUOZaLtLmCoWTB3C9AkzKVZskbAc0WMZzQiuoQfjqUkyy0p7fWvmzGbquxz89YUZrezzjZWFn1N1D+6OWU0LfiBYOLPolcX7qcHekEw24MqJ5j+9XjI6/e1Ms5u2+vJQhy+YLFlqhtRqrqo5neNS/zlz6B4eEQMnhjE7pjTjrArVJ/VA6ArBJ1KJpRmCaQdG2GJ4CQ5D7WgRiqlGsano+jwKIG/r2UgoGcwJoXnClPAK++SIsTx8yk5Z2Dr9NXRtfarICW9bi4gPeTlHSJSHajceB05x0gvBEKkM8
 f84CrvtO
 dp2+M+PfgNnnOZGrgDegCxkBcHjqABVIyVzH0s4MtLHZR/DeqsiKMxrAvk5jTYi6+xdfgqsJpXPOJnpK77uWbBwB6X8x1rFZgsr8mqaUjr0U5Ui0ZmqmABnafh3l2qL3E8eRVwh+uNg4NY29Xvpm1CwPrhkdoKaRNdN4+vWdgXK3zIBpU97d+owG6l0enpOr3zbgI1WRyDLUerzn7TKon+jPwRC21YQHCCyXsbHEiAnDTEqqbfsfiBtLcof3x0zCUhHFQzB4EMDXSaFw5CHd8cCFtDK2kFMNNVC15VFt3Zs+5P+zwFQo7ngyP4450DBReLcyhGQb4UV6/y5qn9FdUR1U8h9Q07EGYkYMjUAQrrdvdmCCPGiY0wgQUtmxDmjDJb9UyB0POKM6He/lsgk2TlhyiXWBEiUXUL3mir+9KzH/D9uF3wDLj6vMJEGh9dNpC6cWgMIH8S/PjyPJWNPMLtifpcNMVKaL1fUcUkDs3ZHuTDRVW5BzcN08VrvFWtAdlGXTjCqK9gHWuk7s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

xas_store() clears the marks of an entry before it replaces the entry
with NULL.

page_cache_delete() calls xas_init_marks() after xas_store() whether it
stored a shadow entry or NULL, so a folio removed without a shadow, as
POSIX_FADV_DONTNEED and drop_caches do, has its marks cleared twice.
With 4K folios that is about 6% of the time it takes to drop clean page
cache.

Call xas_init_marks() only after storing a shadow entry, whose marks
xas_store() leaves alone. Dropping 8 GiB of 4K folios, median of five
runs, averaged over two boots of each kernel, in a 32 vCPU VM:

                          before    after
  POSIX_FADV_DONTNEED    1517 ms  1423 ms
  drop_caches            1515 ms  1422 ms

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
V1 -> V2:
- Explain the condition in a comment (Jan Kara)
- Add Reviewed-by from Jan
- Rebase on v7.4-rc1

v1: https://lore.kernel.org/r/20261030-bug-mm-filemap-init-marks-once-v1-1-699835fc6690@gmail.com
---
 mm/filemap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index b74bc1e5015c6..c2effedf975a2 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -140,7 +140,9 @@ static void page_cache_delete(struct address_space *mapping,
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 
 	xas_store(&xas, shadow);
-	xas_init_marks(&xas);
+	/* If xas_store() didn't clear marks, do it now */
+	if (shadow)
+		xas_init_marks(&xas);
 
 	folio->mapping = NULL;
 	/* Leave folio->index set: truncation lookup relies upon it */

---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261030-bug-mm-filemap-init-marks-once-b83c6aa67bab

Best regards,
-- 
Qiliang Yuan <odys.yuan@gmail.com>


