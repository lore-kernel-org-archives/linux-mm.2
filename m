Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4453FE909D6
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 16:33:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FE5A6B0089; Tue, 17 Feb 2026 11:32:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76A856B008A; Tue, 17 Feb 2026 11:32:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A41A6B008C; Tue, 17 Feb 2026 11:32:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 55C556B0089
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 11:32:59 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1802E1B2A78
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:32:59 +0000 (UTC)
X-FDA: 84454492878.07.A4265F7
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf25.hostedemail.com (Postfix) with ESMTP id 54626A0013
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:32:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ILAAqNQd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3N5iUaQYKCA4685s1pu22uzs.q20zw18B-00y9oqy.25u@flex--surenb.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3N5iUaQYKCA4685s1pu22uzs.q20zw18B-00y9oqy.25u@flex--surenb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771345977; a=rsa-sha256;
	cv=none;
	b=8DC36SMHqPSQ9n4KR+fF7beM9CfOgBlXB6gVB+Lj12YECj8Q+Z6iqNF7/JOveR6A6gfdWl
	kP04iYmOVGUSzy1OwpNCB9X2eqc/opalml4GwXElI5FMsYRh9zfLlKv1OxdlMgF56jd6cg
	poAsrhV8lkCtJmj37j7dRmnZOcQlEFc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ILAAqNQd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3N5iUaQYKCA4685s1pu22uzs.q20zw18B-00y9oqy.25u@flex--surenb.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3N5iUaQYKCA4685s1pu22uzs.q20zw18B-00y9oqy.25u@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771345977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=20E8AsSTFCwzOiRhIxVDRmNYTsZqkvgm04spnyQD6co=;
	b=pFdgoeSqHu72opWwzE8tJ8BBkJUHROiliarpIO4cydcZJP0AbKCOhQ776uROki3vXkjKdI
	6Z50UDTdof7b/8BSdvSebTYOT+rTBUSJtXoGj+OyVbZP12+++mzVU2M9pJEzHiTkj8HL4+
	/UCNSorZx7cT0dJHl/HTpzNBuIBpjXE=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2ba66faa692so5801032eec.1
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 08:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771345976; x=1771950776; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=20E8AsSTFCwzOiRhIxVDRmNYTsZqkvgm04spnyQD6co=;
        b=ILAAqNQd1Cy85bGxAjxo2PCSuvTj75aNTumSg0qCJYwtQIlMScT+rYrJ6nUhUgITFc
         4RLaggCleP76+1VfhS8J17tSmQwS1sbK9DFZU/iGJmYBJUFbWjNR0Zt6lz/7fU479var
         95G3EGvR18gxFSmHmnLuhzNVkN2qeSlH2KjMVfqZkqUAaBpYrWiS40+XINcxkXe5SNuG
         CakIq0pV62jEKyB33M3WHsjDOWcGcWG3Yx9GIaRxDsV3207RL03V/q88n3mdE7f5z0sD
         BVEK0eAM9MuBDUz3xIt43RcmhpHmQ0xfOI5YWTrZ4leaMhNMK6ykogjOUd9k+/053ONB
         h0cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771345976; x=1771950776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=20E8AsSTFCwzOiRhIxVDRmNYTsZqkvgm04spnyQD6co=;
        b=pwQ0qi2taalTLtlerCaveVTmpDHq+ZyobspmAEUaL0HFYblNWvnMNXKWl/xfrc3F6F
         i9jrXVz3FqTV6L4ocZVZl+iM19S4Yl99ajgK6EiKixqZG3B1Y2SXW4c9BeKOrv/OudYr
         7XqSl5EDUnyFEFZKUjvLdhO0iqZsTyDlV64Y+Xf6hNTXU+p7aSSu+5mUpjoeNNwzK37W
         l4kA2UEc3l7JDShfiLwvVaMDxTFMzE8e9idjrefVf2Gq7igEzpCOK/WlI46a0+cDbHwQ
         2EuvxjCiXB+fmf0cv3AC3aDstaBWlFayTr3oVgUVWMl1xmWRoUNNEKGbtB3D3Eq04j8S
         Ysgw==
X-Forwarded-Encrypted: i=1; AJvYcCUoNpK7aGbMzj+Y3IQAlHkkdmn2yNe3C1DWiFi4YSnVMjsRMrwEIKR9MqUOJDj2drQwlSL8RCiZ5A==@kvack.org
X-Gm-Message-State: AOJu0YxdmjzMyhjkuhlaP2xH+tHzZ9h/f27KjiNeKTuLdq8U8X70lvi4
	XdByUxPy4LC/Rx4peHnfWqdBhdqFRk0GNZDOnRbAVBZZqR2/G4lGCZOkeqkRFjBHEEzAEnUs5yI
	gmaASVQ==
X-Received: from dybmv5.prod.google.com ([2002:a05:7300:cd45:b0:2ba:9f53:8c70])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:693c:2c8b:b0:2ba:7f8c:6754
 with SMTP id 5a478bee46e88-2bac97ceddbmr4300008eec.37.1771345975648; Tue, 17
 Feb 2026 08:32:55 -0800 (PST)
Date: Tue, 17 Feb 2026 08:32:48 -0800
In-Reply-To: <20260217163250.2326001-1-surenb@google.com>
Mime-Version: 1.0
References: <20260217163250.2326001-1-surenb@google.com>
X-Mailer: git-send-email 2.53.0.273.g2a3d683680-goog
Message-ID: <20260217163250.2326001-2-surenb@google.com>
Subject: [PATCH v2 1/3] mm/vma: cleanup error handling path in vma_expand()
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: d3bzipjdm5334uaokc3ois75543d48zq
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 54626A0013
X-HE-Tag: 1771345977-29092
X-HE-Meta: U2FsdGVkX1+nluDrpTWpL3wVJyTISQBPhuOcnFIt9fR9efjmEe0N00FBj7xjv96u2oFfzfu3TkgA4wo7vucIwJK7aq/9P2/749jMVklAedb43/SEsdG33ddulUewy4Udfuj2x8bEpui6pZX1wnED2KHCTgDCsveB+WlDYh/6NfZf23EQd33EzLULuxHAOyPfBJZU48yqrG/unaAmej3MizmTo66RACB+jiZIfqe2QcoFWnqn//zUf62+y5o0BNf0DAeKsuqlqp0I9AxBFBp8xk/UG/OE8zy7rj7wFpQMjN7IAcdfxKw/TcqGfLi/deb8E0ZlFS48e0Kly5RgajCfYJcykJGh+xI59hhUlqUO8mjthn/6WtPPJ6D5ZOZTtEvCzqfd50oSAI//Py5tdvE4Sv95+OYZGLeGDYtUNvEDQCxO8jdW/vdd7UG/IVgtGzzmGXcqp6koEDJIFFULhte7LTOKqcSQ7okupivJRg6y8G0kvz2cA9JbOUmJCi954mTj1cq+NZSMMX9tu8XgcA49AHSRqbkdrSULyBhHgetf2Z4QcfgG6VvsPQE00qdtNTCFeP8pTaYSZhefySs2RXjIcwvsEh8MeFnu69XJOenKSZG4g20foFD7mDZcKbadFR2eAnT/o+RaureWSebPwzKj35J46l/OvdLy/Uo+XuWb3Ry4+dnZ2RCpUTnOiJImjo215pmv6GiWOpthEEaju6Ew39kx8v0DduRgWHFM4kT3UT9j1Yu7vGXwZRRZfAtYAkXNm0o1wvrof27mmQ0XTftcSnjV15P/CrewOlHJgo76WOk69MPym1u6JqRaVXHV+44fHm85ltx25Nqi7eLoR763eyGbk5DdVYJG8mlSHVPO3mzhy1UA8stoGxKt122yPrP44D4DS56p1e0Sh9edIGWz4YLKaOvFDYFOqkLNgx/H9IdBeaEc7qcCroKucNv+jF8hrWjq7tpP6DyHfk2hAxC
 /pTwFSl2
 9PzbvKEXwx1FMRocNh8ptS+a9TsEOWdm30WeEcroNOLgas7FYICH4spJ/hSZkj/qL2w8DD0piUdfAqShvH5R3K6sFnnvalMCkQa9d+Tld2dtmV26I2tyqIMZAV3+6k2QrqgIiNvj+8j8unumoleeQYYU0XFU4tmOepu2swz58gODN0j7hQWonBnfct1Qig2oy18EWo2/qucZVdTkqmPBe0VoVD6b93qxIoQkLokZgUDTSeaYTokUyyyNXrYfsPANoF5ZvBkTt81MnuUMIwyOUvjjj1PA4/b0DjDR/E8a38QV9rAMkLrBcCJd4mjS3u7Lw8K2vF1aM9Bw0vCP3tTOZ3zvxIKhEzk33dlX8YMBP6gH18gD+CLHjBmIffTlCcv3l+X3eE5/xhm4dchhrcU4gbpCD3Gid/9c1Eh1wRtLOY8fcu2/vZqrPaYgJ/Ba8LKaBmD0z8W9QX9tSLuP0Srwn9JDSVva9zYXnSUcu9plyGzDvB2/f22stNT9OHUZZPY9IRWlXwxazGWi6yhA8k7wmaZDK00g/sYsku8LQ3MwlHWzruDsXKub4J7KDCfZ/CMBhit8aDO5a2zFNV3laZpk+pQl2g1tQHxzfIccFyK1mJozuYHZ50+hFMWANGPZS2r4JaVjawwN/r78mAp3V7YLr2KKtFSaJVCKaD1OmT4GRBcsBdlZqm0mZ41/ViBtqxHc6ChMSF32f35FpHj0X5MQbKDwiVMLeQYg6seKzRGc9hvJa3idzDrR/5OYgYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vma_expand() error handling is a bit confusing with "if (ret) return ret;"
mixed with "if (!ret && ...) ret = ...;". Simplify the code to check
for errors and return immediately after an operation that might fail.
This also makes later changes to this function more readable.

No functional change intended.

Suggested-by: Jann Horn <jannh@google.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 mm/vma.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index be64f781a3aa..bb4d0326fecb 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1186,12 +1186,16 @@ int vma_expand(struct vma_merge_struct *vmg)
 	 * Note that, by convention, callers ignore OOM for this case, so
 	 * we don't need to account for vmg->give_up_on_mm here.
 	 */
-	if (remove_next)
+	if (remove_next) {
 		ret = dup_anon_vma(target, next, &anon_dup);
-	if (!ret && vmg->copied_from)
+		if (ret)
+			return ret;
+	}
+	if (vmg->copied_from) {
 		ret = dup_anon_vma(target, vmg->copied_from, &anon_dup);
-	if (ret)
-		return ret;
+		if (ret)
+			return ret;
+	}
 
 	if (remove_next) {
 		vma_start_write(next);
-- 
2.53.0.273.g2a3d683680-goog


