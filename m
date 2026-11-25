Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A25AE60A380B
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 15:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZFzHWDk9
Received: by kanga.kvack.org (Postfix)
	id C14CD6B0A51; Wed, 25 Nov 2026 10:35:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC6156B0A53; Wed, 25 Nov 2026 10:35:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB4886B0A54; Wed, 25 Nov 2026 10:35:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 830B56B0A51
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:35:43 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 11BDE80F28
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:35:43 +0000 (UTC)
X-FDA: 85474041366.27.DE71F29
Received: from mail-oo2-f2.google.com (mail-oo2-f2.google.com [74.125.231.130])
	by imf06.hostedemail.com (Postfix) with ESMTP id E1AEA180006
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:35:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZFzHWDk9;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.130 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795620941;
	b=mEubnmdX3A9STZoh22RcPQddDt5l+0P09rDzbwBaYlAvfJvfaNxYluskxxde8y3njRABF7
	KGx34lBIswRQzgKuq5cVEh4Ch9NF0b0HhAdxmHHHax1AHHUQc3NMtkQkbg3CDcjtCeXGX0
	FILnqtEBdrgvZfnu5nsFNFl+TIl+MtM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795620941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oGmzIPeBX3tzs7DPmiwC0d3aA7TfOiCBq2btcn9vuRw=;
	b=uY0QzfI+2t6+18lgLk+XyA1lbYbcp3vL7hOcYfyRh+pmGp4/oGieFthnmTlbXKP3hXaW4t
	SZSOCWtpt8XF1FFuUtV6cMk3WP0AXBUQgr2BSCLqfKtHKUthOJs2RvOVYUJAyeM13pCpEc
	CavDW8p83KDfLU9yfJCSPetxDSvU0xY=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ZFzHWDk9;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.130 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-oo2-f2.google.com with SMTP id 46e09a7af769-8629ff88e68so2220854a34.1
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:35:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795620940; cv=none;
        d=google.com; s=arc-20260327;
        b=fX1188Pu9rPDnFAZ1l5oM1Nama/N7sQKuNrbokjIMROnQ6lmqPl7621xy662BlNN0Z
         R2g2A8DDWNAsXFoRNgPONFBlFwYABi7ew/uVW35k6dddPchtsQuFOehmpNgrCswlQqHj
         slGWwwW4RlcSLXQiObAKN/iBwPAVJ8ob9wkqBC5fZ+ReEjj2EoeRCpbkD2XWnWBsNHCk
         etrtNgeNJOJg13g58Y+/88v09xmBCztMjhqST2tYGaJY12OgFotiCGDeWrQdBF5GMiiJ
         /nI8WSgFDtfJsVlsfpBEXWILM8cRyBQsu5q5VWRvF2lWPPiwpJphtIYcOd8T1egG65WA
         Kwyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:references:in-reply-to:dkim-signature;
        bh=oGmzIPeBX3tzs7DPmiwC0d3aA7TfOiCBq2btcn9vuRw=;
        fh=okNWW/ZTyW+ZsV9Y7hNQ2gehz0TMQoDC1668W/FMn4M=;
        b=Dvc+gYZUurOpIjnH0Y10q6l1/PQrg1ZGQr+Yf4G5AquLQl6a9fdKWVgWaS4UwIyBdV
         b8vw8G4Qo82AnFpfW35J9s+TpAzEVU/AqUhDbYUU0oDvWxY+I+rt//C2sKnqYpFHe1L0
         vJVVpKnArmL2WV0KS87PqBfCzzDnAxZrcL7tLCwInmVJkUDaK1TrReaXfxN/0IycyzCg
         eH4d2buXvDYHZD4Vc1jlr1NxwDm2hi6eT5Ij/tBr1skPj5nsymWcsw3VBDzrP3hrRdCl
         XFtO1rNWNhQqbNt1rS0j5s1g0H8GVZWMCltxFm1F/oJS7R4w58TNK/oWq04C3texLlEc
         VtnA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795620940; x=1796225740; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:references:in-reply-to:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oGmzIPeBX3tzs7DPmiwC0d3aA7TfOiCBq2btcn9vuRw=;
        b=ZFzHWDk9H/FI/zStZERFHv5a2IvUvwfNehreIVaHJwXCmhHHlzXX6ucs44gq/3pH8L
         2rzHPgk6aoz9cKccc2gJ3T8IsrMCCc/Dd4Y38DVLMDJpba2n4JbzRnTdtTA/nizqaQyd
         X8UtNEufVMqF+I+O9p6BhKACoCoN4Fn0LrIc4iyBUa5fHwTIztjbW1gA9+mKEtOddj9j
         88ciEF6pGCxiiUE55ceRMQxzXLfqM/nJu3rz2o5sU5M55RhOolIHTPuxLiKU+A/CXxLN
         My31P1G1IHlaFbyAjhQFbG1P6v+BXP44l3EXxStrugPfPXVERNgAqgc+VKGht0C1sAoO
         m4Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795620940; x=1796225740;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:references:in-reply-to:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oGmzIPeBX3tzs7DPmiwC0d3aA7TfOiCBq2btcn9vuRw=;
        b=NKarI+IO3+XUOTKqQmvYYEG/Xxwo4suQ96dxBs04ggMLiqOMz6s4MrdhNBP5FE3agr
         RTPiUM4E/IKlNkj7xyzLneXNMhX8aYUpGEnM09Jxag4KV5DGM4ZONd/2VMNqN5Ml+ocp
         lo5l4kVZ2NVfoRKvNbrPkaDxSL/TZO1bezJReQjtbd//lI6eF8oRc+2X/sSJ+QPnYM7P
         0kQEWRmbZdGFCTJTQTsw8d1xsDGN/1Eo50BqxjFskTu9WHiidCezhFfZ4lQl7Kca0Hxp
         s+aMSusNUpNPnQTNDFCsu0A0a7gUgSYw11E/uF+a0yDF1C8jifNV/eAlWNxJE1GStdK+
         KKuQ==
X-Forwarded-Encrypted: i=1; AL+hErFShs0NuudUNb4MDycPhUBaSvW/VJg01TQvShsQjoKBkhED9b1Ey3IhSXx7/S79OGuzHmPjtAqslg==@kvack.org
X-Gm-Message-State: APuU4Z+VALxRjWWjkZ86vZvWEecg4h4Viu74QMP0ZpzAB2p71p5w9pZi
	Rqne4+LDhiLBW1793sVjbOs+qBA4Cjh7/98RPmzTR2NnhmOzLibCDAwnp2Nk9ywmRp/BO196cp5
	+WfVV1WVvCYsJPd25Yj0laR1ixHLatuo=
X-Gm-Gg: AZFdTZfh20tbFqnbz5rL1vC7tHHW7kuRwVtb3GAsQ+Ptj0rR0qHbnnsY3mjxTXPvpK0
	QKMlLw1dW78EppyXpWOJg0P5gXSqusXNodeg8hKL6yFy3J6Ny0ieXPZo7BZzWpF60cgLJ25Y3Cm
	hKcM+GoolUFVuOs6PLJ+FF45XulrjQ2Ia6AO6wtfTy0ZqM4GW5nNJc7fIJV9m8wRQ18ODVdlBOD
	RgSGkeJI0nK/2a+4GRUjDJft1mWUAYYwF4XIibDE/D//wl2ZEaTrER9cPnjYKlmKQCeWZZJEwv5
	b5OGUuvgTWjWvm1IYqGdiqJPaC4KI4XIh1nwu3hTAdG1wJGPvWF8WjI6BJaLugKylwjHBuPlwpZ
	6LI59j8Yy+KX+kSm2M+MakZVV5l4e2jslf8+0fU/GdCna9ak5CKSFahlym8eu2/Hea25khivSgy
	KnuaL8yL8VY1U1Jua0WOpLpCDZtmTb4F7eVEqxMEGqKyxbLFrE
X-Received: by 2002:a05:6808:4f46:b0:578:c3ab:6abc with SMTP id
 5614622812f47-57a0ae27349mr22158101b6e.32.1795620939681; Wed, 25 Nov 2026
 07:35:39 -0800 (PST)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 25 Nov 2026 07:35:38 -0800
In-Reply-To: <bae41f6fc4114357a8a74c8b958f2bdc.1@linux-foundation.org>
References: <bae41f6fc4114357a8a74c8b958f2bdc.1@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
From: Aveline Noir <jm5905938@gmail.com>
X-Google-Nh-Sender: AW_J_UrQlBOqZOnyypQRms-WIzPNUGKKuKcZIXC42gjnUzfco8roWTACR7VkJYgNn81PckhccX2Z8o9Xn-0mFO9N1yJeBDi52RWHfEVs6AQK1KyDvZcPuRuGciBbXoKEiPmPExoAhR6UK3T86QnwEMvvHIIeKfltaGMxWLdqDdSc_vySTNgGsv5ucv_IP-VKkwWkEap3At57Bz8KSbGkZHGs4m8Sry-pvp1CnC-jYAx8dEkFExzf1JTTMq_XNtcsa29E2p7K
Date: Wed, 25 Nov 2026 07:35:38 -0800
X-Gm-Features: Aa3M54r7k5hNoC4v85ROE9NyxSX5pkWj_j_Ql2QLsZwf6aRX8G_gyLmwg1pMzSw
Message-ID: <nh-8c393f29-d063-491a-aef6-9d95b6714638@google.com>
Subject: [PATCH] lib/test_hmm: invalidate all mirrors on device-private migration
To: akpm@linux-foundation.org
Cc: mpenttil@redhat.com, linux-mm@kvack.org, rcampbell@nvidia.com, 
	jgg@ziepe.ca, leon@kernel.org, shuah@kernel.org, david@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, mhocko@suse.com, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fe5pot43d899amqrjxpwm9yua5d7bpwg
X-Rspamd-Queue-Id: E1AEA180006
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795620940-362166
X-HE-Meta: U2FsdGVkX1+NiMqq1lVFjOvYsOg1PDub6j+KZMOBJe2wdLBElAMFUggcHUBEKYUbdA0OWur2gOk+zRRohwRjuG+f5Bl5Hkw+VRcHkhuOm+vYWPjP48swQzLEwjA151nwaZVnsnBaRSQcMjQlx5DdYRMBDDbKMO5tsEnrwM3t8EjlV/qC7LpofYb5JDpsbeE+r76sTLrPff8zymvn80OUGP3fOW5YHEPZFcIH0SUENdWW2/bpkrUBv4rhb5HM0kcm7EZhsrDS2kMVuUOeXWxMCjJoLRLCX1Fj03SrRBu0Kj0dZReP6Kz610jpLJmRypJINPJ3GkoEpayM3b102OxL+oUTxtMUVSlo8o26xPBM8dUQOIj8iTSSLw4K9iwqMSbbXp/JH6q5IhwSWVX5M9d6a+ngCWS9Jk53pldT0igeVYfSCHM/59ic9YmmWyyNFS6Vmmh53UhU96SU74xzOEBK/oAoAe9Lq29GpQNAC+SXlfwUhO9TS4e7vZSF/xRJjbKUshAJV0iie0k6F0TjeqUBJEUHUphQpuY10Vb+ASAJ3tlh5MT/9s21BHYTZkBchPZ5QeOjr7rVH4ZCThB75lzu5AUqoLx/VjNB/oipVJdg3+LLWuXHjPBmbCs8EdXIXQu1aGwkQdG3tDVDk6i7k91JnZoIJq4aueeszJ2/SFSsNeRgKrj3DWgOoLILnieu+gOY1MtS7i3yJwLri31PaOPO9CsQqc1OwKwJoe6IIMtCKjVLxjaHECuBy/4cOewYig23IVU2zZ0fXsiLAPGmWnKyBKO0WlBjAk0DanQWTkZDgM/42VA1qfVQtLTAemhkmh3v5Ikra3uhSdGQJ97CyvZJ1EbFWTJXL/kDuiIyNU+Q+9OS2utCMkM6JeTtXzVlH4mp2TfJcSlLl6iTk38JMQ9eTacxnj1GIFVNqMI6H43hQS/n1AwJG6yMZwAXlr7GxGxEXDEv6tDqpocTcEODy+2
 EAruyfPn
 rDoA1867CdXD3Z27DIQQjEsElpQLqzuHlD2FbFMdbBhoN85DRKDMkTLVZx9bg9NSlClY30QLqn0NL3yL/4fw+W/HXygGauXHI6ZWKD4lo1f+1GluLq3yPrR/QsyMQz2jZyJoKSS2A1dr4swLtcn2Q1IT1dKc7vi0H80dadeXZj1g1HtY+N196HAUzOpwofSEZf5ur1x+iEpvoe4Xyf5SK6TJ7B8Uy9D5XeBwgVuxahDldaHiPGKbNuAugr0+MpDvSSnB32ixHFAzJ4GU+MgTU+2vjPWAVh3AXg2B9OUzF3Y2FyING7w/1dKq8J1OswQ8aSyqe4frYFPg3zbME2rAHHjZxqjw8v+Cydq1lbLP/O+1j5N7iEq9SMry3jmhXYJNOUaS8x4YNzVTKHRwllvv1OtTggkqXWcOCbFzgGyOMG+fSckfc4R+7fYuX9eRe7wuHf9ylLCiqOD5RZheboJI5HXEc8w+YVwWk4xhrSq4sDMuN/405VEXfDDtEccIqUJXHKwhlgC/yUel/W1LGEhpLiQxTr8gTIx4rdeFS2Jjl6AEFkpp0jsetbgQA6JHv3jEss2HZG8gOzgEZCZonhAeJM1zFTiaKc8YN6JeeIf2ied5PQbXpMZI0s+7lvrEobPVdtPMdGcGg+rirnp8UfUr3VUB6fNLNvBhdGJ40HbA1z2MSbQDCAdsDKDkX4RIuiqNVOiDvZ9ypHQCyrxuL05EpDVsBUr8o1CG+TIMfOUCYepz2HEZ0z9KViIJbVrXDm4zHw4tGJW1n0ji5MlRhVPKX2RRYl28S8T0S8yxyh947/PY/IMWKlYara/UCjOvf003GzRoY9PdlrNIP9KPS0r2rHKQIaPrR87EUW2ufySsw/uP/T5hSfPd1oVSaHFpin/bXCPbDpt2Aq/IjLaOhsOc+QeTZx7gQJMUgzCm1P2HWc/hsOHFk9nZa/U2qnuKdd4QlOg39A8w49kbLbrx5E65ezvG2B+Nu
 NLqChbNU
 EFuM+HSSfa+Vsk1Eh0cdKlO8TSxrrWMc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Tested-by: Aveline Noir <jm5905938@gmail.com>

On Tue, 24 Nov 2026 22:53:38 -0800, Andrew Morton
<akpm@linux-foundation.org> wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: lib/test_hmm: invalidate all mirrors on device-private migration
> Date: Sun, 22 Nov 2026 08:53:12 -0800
>
> When one open of the fake HMM device migrates a folio to device-private
> memory, a second open can fault the same address into its mirror page
> table. The second mirror then stores the inaccessible device page, which
> can oops the kernel when dmirror_do_read() copies from it. Store the
> corresponding RAM backing subpage instead.
>
> That conversion also makes the backing page's lifetime significant to
> the second mirror. migrate_vma_setup() notifies all mirrors before CPU
> faultback, but dmirror_interval_invalidate() skips the notification for
> every open on the same device. The faulting open clears only its own
> XArray entry. The other open can read or write the backing page after
> migrate_vma_finalize() frees it. Aveline reported a KASAN use-after-free
> and stale data through the second open.
>
> Handle migration invalidation for every mirror under its mutex. This
> clears pointers before faultback can free the backing pages and waits
> for an active mirror read or write. During system-to-device migration,
> the migrating open installs new entries after migration; other opens
> refault on their next access. Remove the now redundant XArray erase
> from the faultback copy loop.
>
> Extend the PMD migration selftest to read its last device-private
> subpage through a second open, then fault it back to RAM, change it,
> and read the new value through that open. The trigger is available to
> a process permitted to open /dev/hmm_dmirror* when CONFIG_TEST_HMM is
> enabled; it does not depend on physical GPU hardware.
>
> [akpm@linux-foundation.org: fix device-private backing subpage selection]
> Link: https://lore.kernel.org/r/20261122015246.d8b6b98ff5a8157168156339@l=
inux-foundation.org
> Link: https://lore.kernel.org/r/179535872126.34.4789080961796247940.b4-re=
ply@b4
> Fixes: b2ef9f5a5cb3 ("mm/hmm/test: add selftest driver for HMM")
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Reported-by: Aveline Noir <jm5905938@gmail.com>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Mika Penttil=C3=A4 <mpenttil@redhat.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Liam R. Howlett <liam@infradead.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: <stable@vger.kernel.org>
>
> lib/test_hmm.c | 20 +++++++-----------
> tools/testing/selftests/mm/hmm-tests.c | 25 +++++++++++++++++++++++
> 2 files changed, 33 insertions(+), 12 deletions(-)
>
> --- a/lib/test_hmm.c~lib-test_hmm-invalidate-all-mirrors-on-device-privat=
e-migration
> +++ a/lib/test_hmm.c
> @@ -292,6 +292,12 @@ static int dmirror_do_fault(struct dmirr
> page =3D hmm_pfn_to_page(*pfns);
> WARN_ON(!page);
>
> + if (is_device_private_page(page)) {
> + struct folio *folio =3D page_folio(page);
> + struct page *backing =3D BACKING_PAGE(&folio->page);
> +
> + page =3D backing + folio_page_idx(folio, page);
> + }
> entry =3D page;
> if (*pfns & HMM_PFN_WRITE)
> entry =3D xa_tag_pointer(entry, DPT_XA_TAG_WRITE);
> @@ -327,14 +333,6 @@ static bool dmirror_interval_invalidate(
> {
> struct dmirror *dmirror =3D container_of(mni, struct dmirror, notifier);
>
> - /*
> - * Ignore invalidation callbacks for device private pages since
> - * the invalidation is handled as part of the migration process.
> - */
> - if (range->event =3D=3D MMU_NOTIFY_MIGRATE &&
> - range->owner =3D=3D dmirror->mdevice)
> - return true;
> -
> if (mmu_notifier_range_blockable(range))
> mutex_lock(&dmirror->mutex);
> else if (!mutex_trylock(&dmirror->mutex))
> @@ -1198,7 +1196,6 @@ static vm_fault_t dmirror_devmem_fault_a
>
> src_page =3D pfn_to_page(page_to_pfn(spage) + i);
>
> - xa_erase(&dmirror->pt, addr >> PAGE_SHIFT);
> addr +=3D PAGE_SIZE;
> copy_highpage(dst_page, src_page);
> }
> @@ -1822,9 +1819,8 @@ static vm_fault_t dmirror_devmem_fault(s
> }
> migrate_vma_pages(&args);
> /*
> - * No device finalize step is needed since
> - * dmirror_devmem_fault_alloc_and_copy() will have already
> - * invalidated the device page table.
> + * The migration notifier has invalidated all mirror page tables
> + * before the backing pages can be freed.
> */
> migrate_vma_finalize(&args);
> err:
> --- a/tools/testing/selftests/mm/hmm-tests.c~lib-test_hmm-invalidate-all-=
mirrors-on-device-private-migration
> +++ a/tools/testing/selftests/mm/hmm-tests.c
> @@ -2087,6 +2087,7 @@ TEST_F(hmm, migrate_anon_huge_fault)
> void *old_ptr;
> void *map;
> int pagemap_fd;
> + int fd2 =3D -1;
> int *ptr;
> int ret;
>
> @@ -2143,12 +2144,36 @@ TEST_F(hmm, migrate_anon_huge_fault)
> }
>
> close(pagemap_fd);
> +
> + /* Read a device-private subpage through another open. */
> + fd2 =3D hmm_open(variant->device_number);
> + ASSERT_GE(fd2, 0);
> + buffer->ptr =3D (char *)map + (npages - 1) * self->page_size;
> + ret =3D hmm_dmirror_cmd(fd2, HMM_DMIRROR_READ, buffer, 1);
> + buffer->ptr =3D map;
> + ASSERT_EQ(ret, 0);
> + ASSERT_EQ(buffer->cpages, 1);
> + ASSERT_EQ(*(int *)buffer->mirror,
> + (npages - 1) * self->page_size / sizeof(int));
> }
>
> /* Fault pages back to system memory and check them. */
> for (i =3D 0, ptr =3D buffer->ptr; i < size / sizeof(*ptr); ++i)
> ASSERT_EQ(ptr[i], i);
>
> + if (fd2 >=3D 0) {
> + /* This open must not retain the freed device backing page. */
> + ptr[(npages - 1) * self->page_size / sizeof(*ptr)] =3D -1;
> + buffer->ptr =3D (char *)map + (npages - 1) * self->page_size;
> + ret =3D hmm_dmirror_cmd(fd2, HMM_DMIRROR_READ, buffer, 1);
> + buffer->ptr =3D map;
> + ASSERT_EQ(ret, 0);
> + ASSERT_EQ(buffer->cpages, 1);
> + ASSERT_EQ(buffer->faults, 1);
> + ASSERT_EQ(*(int *)buffer->mirror, -1);
> + ASSERT_EQ(close(fd2), 0);
> + }
> +
> buffer->ptr =3D old_ptr;
> hmm_buffer_free(buffer);
> }
> _

