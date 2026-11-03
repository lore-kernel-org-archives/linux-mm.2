Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31673606A33D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 00:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l+we6k8K
Received: by kanga.kvack.org (Postfix)
	id 50B456B00EF; Mon,  2 Nov 2026 19:59:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E27A6B05B1; Mon,  2 Nov 2026 19:59:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41F3E6B05B2; Mon,  2 Nov 2026 19:59:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 29B356B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:59:52 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB4F4402F1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:59:51 +0000 (UTC)
X-FDA: 85392000582.23.BDF8852
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 25F62A0002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:59:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l+we6k8K;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793667590;
	b=Llz6v3NG00yqRyJZffj/v6Rzg+YtZuFP4JGDxyQ93eOtuifzUnDAy5+9/u0gRdI8OaHPPp
	GPljVwslVELsuc4g8qhONRGJhaOO8hMPL77fXZ/3irpTXQC397+hunJcBZyfyAKdyj6mRs
	9ZvuKKt5ClKbzIrrTbvo72YT80lDUSQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793667590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YsqNsUR8tZ9cD/Ii/qDTf0zO0JWBiVUzSsKIvjwmL+I=;
	b=8ivuD/7Swg1+h0l+Nhts3j4DOnkHP96uLJ7Zy/wGx/j6Civ1dSMJ2fRym0UDUX81B4byHg
	/k+OV6vlHFm9Fx80XxNFYe1pWGDLXMvkVj07sYTCHmKoQZtrCgiCXWW8eSc9Bp+8O96b5i
	axyL8a/CZ443aWEhQSA9gFGzIDtExpA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l+we6k8K;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 72C6C43F1F;
	Tue,  3 Nov 2026 00:59:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026D81F00A15;
	Tue,  3 Nov 2026 00:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793667589;
	bh=YsqNsUR8tZ9cD/Ii/qDTf0zO0JWBiVUzSsKIvjwmL+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l+we6k8KCmW4BkvQe7SPxXlCNhaiRWMXTgksJgucs0e/v4ivZNSqhFA/8kidd7f6M
	 4li/y68cM1v9XNCcSH9KQIVy4HtIMYV1Y9Os/O2pZv4E/b/mIBBoOn5H6DZCTKEKhA
	 lO03AJMI/43jsP2UkvOMY46hyDkJ5Ob8OEtfkEQA+cAzma8rzFuDIeRsjDPEoyPO5N
	 l8gXJTOflG9u/8xcT11RVbcspDlCejlpp1cqpZDhbsk0NRdlz2enStKtTHT9x/rfPA
	 snP31XQORX55zuNk9dsJMAnrbu/gQRar71FgzCAiDWFkKNukkHKaQKkptYhthadrlU
	 a7sOrbmzvWY/g==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aveline Noir <jm5905938@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Manuel Ebner <manuelebnerli@mailbox.org>
Subject: [PATCH v2 2/8] Docs/admin-guide/mm/damon/stat: fix pronoun agreement
Date: Mon,  2 Nov 2026 16:59:32 -0800
Message-ID: <20261103005940.91432-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103005940.91432-1-sj@kernel.org>
References: <20261103005940.91432-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: j8fuz11wg8zmxomogpthj8i447hx1mye
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 25F62A0002
X-HE-Tag: 1793667589-311188
X-HE-Meta: U2FsdGVkX1/7KeBVXY7hWKK2nSeV5ubPM/ezjYUhPxh3AV0iPxc72q5gz6nET2F82f7CCt1+q+yejncw5bnTJKT9F8Lgq+unfoGklkTKr6ekF+9J5FJLSp1qLj08U4NWz6Sv75arZ9D9P1MDHEIC8kxtFkSVpLD+UnehSETyjUuzX9etzyyZjEO3dmdcCKW/KsrtUEltfR8bPLJytclkbME6hqqd6uqU6OQ8zdRVdzvgbHrRVBkDK3I1rAXlUuLRtyDV7nAOX4RsBtq1NtryA6BM6t4/0XekxzBOmTNPcYLY1TdNyG4k+LMm4FF5hxnxZH/xFmy7TuSzk8Xgg7LyCCIrmiY3ve3fGQcAaVUJNJp8IsKT+EqXuwyramiGBesE/1ksfjR5vVDSEGpYcGwZVbz0RreQmiK/XRMevcdYQUFPjWuh1Lz80hNU8rvHHTcjlFDGzKDsiWaVhhc8NPiDBGcamZPiE1096BnebfAX5Q9mWnLLuzCD9n53dwJ8kkAB2GiD0fp+x7xBydCpAkkazSo3B3Okv38pCV4paSoJ7U+JA/InR/EPj5KMyZ+LZtdsd1mPksIssx/eCOqqKwb68exwhZV1QW4ImXwYnlZcQqNYao+UBKwD+wRwUiKDVat9mS7LKgyTqyC/yUahNFt0mSjiixauLehlJ67zpEIEuAlVEHvKbynNF6RvJd7Mx2tPSUE//L8/NVq1TRvR8zHaWBWsJ4WXKapig2xM8kwFRgAazTbHpkCUpQv0IkVSsSTm4eVwfMh6FaMKxgB4V6s8J6BeLBeh3/Uz0x4Ujghxf7jyznvlez6+bHV/Ne6+wpyRwpvCcS/K/YXpNIytgzGwT2++ratGP9j6Zfg9iC6hwjGx77737aovp9kAZV3h29MpCzAYMKs56NNmEgR7DNddZLYXlzubMQL/3EdSBSLtJJSj6yQ/FmIEo/02NzWZscdGoJDbqoIf4SK9iHSl5co
 kj8s8ewb
 pgs0njFwwKDLtoVkrdrDVcmREzFP92ftNX6eN2fuK+jo20PpdQ4Wa3bE5yTZmUTRI9v25q63lJQtz3TfNxXIOSdvLH4iQnUFRl6oW5Hep8tP1TEly4QS+xZna094rk+2g8qsAIzG1t658cNXVuC2GnxYqLgI6vHX7zgFx/fMH9tqUQnQr1syEZPF+FQJ3JjNZDZJPB1v0Qn4PJMDw9U+kXy0LXT+ndDymYlAmw7lCaVC7guw9JYFg18BlDYef0bVZ3OfMQAJtlkQws+K5n7m32ANYhHuRNBgpuYgTP0RGd6wcEFVzRFfnU8+gNXsjFTM6XDxmzgIfaoc7em89InS0ej0vdbsWeN6wAjjAlGLykm0op4sWrGS75yD+yNREGKh7tJaGblcWl4P1LD50aA6Or8Ddrv56hXsUXlvCgMct9FMyQp725DpVEu7dL8iDAvWBxFdNRUFW/wUssZBEX1Y9KsTBN+pUPfgS36ta3fXudJEY7OzsmTsPslgZxF0mSiVKOYy+JueLTSnrJuEQpuXFOSqn6Uh1Sb2wO6eG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Aveline Noir <jm5905938@gmail.com>

"converts it" refers to the access events, so I think it should be
"them".  Rewrap the paragraph while at it.

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Suggested-by: Manuel Ebner <manuelebnerli@mailbox.org>
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Manuel Ebner <manuelebnerli@mailbox.org>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/stat.rst | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/stat.rst b/Documentation/admin-guide/mm/damon/stat.rst
index 4a9db755a5265..7151ac118081d 100644
--- a/Documentation/admin-guide/mm/damon/stat.rst
+++ b/Documentation/admin-guide/mm/damon/stat.rst
@@ -41,8 +41,8 @@ enabled
 
 Enable or disable DAMON_STAT.
 
-You can enable DAMON_STAT by setting the value of this parameter as ``Y``.
-Setting it as ``N`` disables DAMON_STAT.  The default value is set by
+You can enable DAMON_STAT by setting the value of this parameter to ``Y``.
+Setting it to ``N`` disables DAMON_STAT.  The default value is set by
 ``CONFIG_DAMON_STAT_ENABLED_DEFAULT`` build config option.
 
 Note that this module (damon_stat) cannot run simultaneously with other
@@ -68,10 +68,10 @@ estimated_memory_bandwidth
 Estimated memory bandwidth consumption (bytes per second) of the system.
 
 DAMON_STAT reads observed access events on the current DAMON results snapshot
-and converts it to memory bandwidth consumption estimation in bytes per second.
-The resulting metric is exposed to user via this read-only parameter.  Because
-DAMON uses sampling, this is only an estimation of the access intensity rather
-than accurate memory bandwidth.
+and converts them to memory bandwidth consumption estimation in bytes per
+second.  The resulting metric is exposed to user via this read-only parameter.
+Because DAMON uses sampling, this is only an estimation of the access intensity
+rather than accurate memory bandwidth.
 
 memory_idle_ms_percentiles
 --------------------------
-- 
2.47.3

