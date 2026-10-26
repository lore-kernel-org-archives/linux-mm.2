Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80D00606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 11:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VR7FUDYa
Received: by kanga.kvack.org (Postfix)
	id 97FE46B05B2; Mon, 26 Oct 2026 07:26:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 930F76B05B3; Mon, 26 Oct 2026 07:26:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F86C6B05BD; Mon, 26 Oct 2026 07:26:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E66C6B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 07:26:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CDB2080714
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:26:54 +0000 (UTC)
X-FDA: 85364550348.09.62124B3
Received: from mail-pj2-f3.google.com (mail-pj2-f3.google.com [74.125.227.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0189D8000C
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:26:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VR7FUDYa;
	spf=pass (imf30.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.131 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793014013;
	b=eyeL2Q2dJdkTSDG6p//AI4zMhJXx15aqsJPU0x+Si+9cVUsf47+WaNYQpHWLjd6yrpcQjU
	Ces3L/v8H+3z5/wZ9eCUOyTrGptJEclWRFa3AahEij0NwHoM9pOFmWrLOoKKD2ixl2GNz/
	jZj9d9dBQl6G8VnP3iJLTpmcu0RSvKs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VR7FUDYa;
	spf=pass (imf30.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.131 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793014013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sEilWQt6Xf8SeL6f3xmlWFKcnQWSknDf8DdIPF1cvBk=;
	b=rZUSocNIzgze0CsaNrbPd5YVTXNwct4EO4/WiFKyWIW61msxjjk8Y6FeVkUSvAtgqfYCsZ
	Zd1uPIHPoRNXysYUlddazSz4m+uFWUMw9WqYLWKnzvVGRkgCE7baUSZT8fZ4Lwc54h8h09
	O/JFUnpoBcUT6vhuZLEi/HjNUuLV43U=
Received: by mail-pj2-f3.google.com with SMTP id 98e67ed59e1d1-3ada2f39f30so761468a91.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 04:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793014012; x=1793618812; darn=kvack.org;
        h=references:in-reply-to:message-id:date:content-transfer-encoding
         :content-type:mime-version:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sEilWQt6Xf8SeL6f3xmlWFKcnQWSknDf8DdIPF1cvBk=;
        b=VR7FUDYaEH0FipcHsZEZucyeI4UjcCteHPTNIaztingkpcTmutSM2gW4EH8hZmm5x7
         2s38DPlFcnKk+rFfLlKrb2y89O7M/PeWpGx67NCQh2XYiFO8+Phqp0JL8R9OXiqEOsvZ
         i7qQklAjFQ4mFJrrLzMj5BbME7QCjmL1quHnEbHhDTcafULO4UfQm5R7dZiUy+VCXrf+
         5Rgzq+J8JB9xTMyDqA0fMrnzNXKClWsT/5nsFoeuQi9SBP0u8rYYaeVXXty76MiXfuJZ
         SQYBbetxqdjK/7gyWYCWC6ocfVBkVmDS7mfFPFROqz/M3jmLeqU/FyI1P0pdqX2ao9Od
         sULg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793014012; x=1793618812;
        h=references:in-reply-to:message-id:date:content-transfer-encoding
         :content-type:mime-version:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sEilWQt6Xf8SeL6f3xmlWFKcnQWSknDf8DdIPF1cvBk=;
        b=t22Nykiv3RhZW266vqmKV1bImmtAEgYGVqzC4VxsY6KT/JtXSRSZL8COjqk2jqmrtH
         kK5DBihsmqg/ZJfymy8OMurly2oLGN32b5UZCi+tar/9jKhC/7j3X51R50mdTTG0Ekal
         /3lY5xUgHaw3RfaZgFGObm5OfaD0FEUEPF3EtvZYHmNewUxbIx2h9m7zGOuEdrnLgtpa
         p8BKuqcKX4wDo/i9p82rIYzP9rnLLH/1N+XjwgXRRxaLnx3sixPoV10jLJPKpOY8XJAo
         DxwrhJSpkHVuiur37vt9FfP5uDykPueJCjkYo/zZk/SVZXYheOiwvPF3UEvAkl5/+sMB
         317Q==
X-Forwarded-Encrypted: i=1; AKwUvBzU9fEIxgvne3gYE8yiGrhdcVgEfZ0io5UTlriX1cZs368ira6UFznRR4A1jvcaQ5u9Az7QXrHang==@kvack.org
X-Gm-Message-State: AFq9FYJ4abGe20D/6OjWbc7V58dhkkWD+NXjZE+fW0ysSvnyajjnGUGa
	VzIDd6gsxGWGsVuVVuYhFyWe7OKP2eRCz7Vg3DMTdhdxOqJvMj4qkMBY
X-Gm-Gg: AYBFou1hoQF/gpDQPsLDkPCLh8Gi/HuvM+svZm+wgxOo60rg09jdcvjL+B99qG5bKt6
	Ipb2UIsO00O8ZnA/T7DhfPsKL2OmtDR8dvHJ1EOPkwLXWT0a7rOCnmilzBhUi4MdQL23sIvRrXF
	ZB+HlEfzv8XGXxIWsBtCScX7xN3RRfwIb4aSp2O/2O4J+JAm1IcfQomy6SM/3/BJGe7KXtnmsRO
	lK8mIyAjgsleMGJtraQeUz6kxEZmVgvLW62/nUdc7g+XUeKWcPWOsAHuHKYiDiz/lvdPukAyJn8
	IIzq/DaVISlZpJndbSHhH5A1S9/D+PjoTJciLtpDAznDbL4Xf1Bs27R1UwwDyKEhLbFOz3FKEEF
	q6CssAbNBxp7pS7LEG6EX0cdT97ghOqHvTq/DJ+W+JW9LGVfO7r+MZ0o0thmXjr5+0WHnaikN4X
	Tk7PWuMV2H1AU/enIcOWwWBfWCABaMnCk59coAEvaON/2yZcwhopkq9OizV+oBe/fFUXB7MNbBO
	4XAWSpdOLxJdrGHSvK/U3PtgRS90cG4L2V/EbGZa0eKe7AAgQB7OiN+eKfFSwu5DygG4zYX+mfY
	P1P2QEIZpIiP9QfI4m96HQO8f0X2R1pRsJNHul9RvMsQEi6FcA7G
X-Received: by 2002:a17:90b:548e:b0:3ac:8741:e2e4 with SMTP id 98e67ed59e1d1-3adeafad105mr5506790a91.52.1793014011466;
        Mon, 26 Oct 2026 04:26:51 -0700 (PDT)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adebe9078asm7950626a91.10.2026.10.26.04.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 04:26:51 -0700 (PDT)
From: Aveline Noir <jm5905938@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Manuel Ebner <manuelebnerli@mailbox.org>,
 damon@lists.linux.dev,
 linux-mm@kvack.org,
 linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] Docs/mm/damon/maintainer-profile: fix subject-verb agreement
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 26 Oct 2026 22:14:39 +1100
Message-ID: <179301327249.2.2109326531018240569.damon-docs-grammar-7@gmail.com>
In-Reply-To: <179301327249.2.4690198998605536207.damon-docs-grammar-0@gmail.com>
References: <179301327249.2.4690198998605536207.damon-docs-grammar-0@gmail.com>
X-Stat-Signature: 4bndk6ywn57hobuct6b3tsm8xkyxhj86
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0189D8000C
X-Rspam-User: 
X-HE-Tag: 1793014012-934405
X-HE-Meta: U2FsdGVkX1/5KBbF9BFlUAE+NtON8ziRrovlO9DbUSm05ukz+W6s2KGENn6OmykLmPTh9T/ZEJWFbD1l/juH5u2njPgi2N/yazw34hgkUcEHVxVgpqlyoIAnlpOeA+ifxBaI2J8PxE+Fjo6EEBMIuyZCh/TqqW/3kK1FInWeWakco2/daSJ1HWCpoS9ExSJkT1uSjFrVocz5pkRKE4mEvQFYx8qVVtLT5OMyyH352LOIe/qBRWqo2rg+eFfSEMnCkDBZwwvB6jwCOoNIud20zf+9q+S7KmU4kyUdeM7w7SRfQXtC7DFuQlBeGvReSdpD33VOtICcK4bUMUxQ2GnDPeNBHlO2x53x5WgE5loVWWTsibapHC8aGO23X7vO/OTVV8SKX8zQ2pP2SDylyqlJE72nl6JZjao3dXVQB7cJnD8EtSnjXm9tfiCAOonHhpH3KknWam1ku6nopIWDj8mcTGEN1tHeW3YMKKKb0ImCkfQISAmq69AzzH2eFzSrppMuekLS/BnmDttOdJD6re7NyVKxBUqq6qti8Jt/eKmap4/aahceR6Cb2BcTXRk4XyuxQZDchxhA5a914AGHd5n6D2dhlJri03NbgS9OcRMkoLBdZ1Z/E3rAA/xVkgOzwdMWaUahAesuzQaKWMe8BscRu8kxN1OkScBPn8IyMCcA/FbHvkTb/UxHZpK2xeSo1Y7f6mE8eCWytlCyhHzVZc6Xca05oGLwp4FnP6I/yCChjIWDMgPL3fq2zCTtOyqON3GsSvx1oUyGYNxIptOdYCJEJYFRvrDcbGN5cIAA5fso95pyH6cbqHoTSMflWt1jFjZyyBI3CW0hgdHYc0dAOm/G3DLn1mpKBbesFtgVi0X8BggoT7WCaccsxcg8vncXSJ/cYnt3UzZlG8AK+LfR2DdiM9HVDWkuY9Ay7N4JBnQYNAchv0sGL72U+YHZjj3UTKupuaNmmNXvhNk2qoTqaKP
 wjfyVG9n
 ufxbBEtmbSnSkYroRzMXA2uW4F6ohCV+o71s4fm1iuhMB1/XD1/CFNDhqN9pvimCwHSR645ODuAKwkdkoT6lwD5p1Ih+Lek7vAeoJMvqwmBW7EXNfdfUKb7bcrlZyH3e7r/mBRAaZy6INV+a/R50x1T0cm/XEIW1bozLsPyRN+vRTN0ksHwmcjSZuTNoKAZD6+65HY1Ae2Bf1Jzf5LS8SLnK1PLa034zMVCE0Swe7xaLonWBTiUwE8wfFQoiRTfuzhnNQSkFRso22fVqXESWTaIgtNcHbtoL16LTJwK1mmFqjh/RI9XE/WAb2LMpYoHkif8TLfV9ZeK4zCmi/OuANYyKMh8EBuyr/AQMiLPQOBgeQ58fLkyWcaUR+T+hEqC5PRGjhD+RNjiCxMkAwg3FdJcycP9JGp1I3D56zDzPi91Q6LekBtXo3KSJbUogaTPmJxjxazYAOoYquBHfVriQlVPluHlsSm9ZGNXDG5UMMQL8Ha1jNcruuQ1mZpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"The DAMON maintainer usually work" should be "works".

Signed-off-by: Aveline Noir <jm5905938@gmail.com>
---
 Documentation/mm/damon/maintainer-profile.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/mm/damon/maintainer-profile.rst b/Documentation/mm/damon/maintainer-profile.rst
index a7c135233937..c48269032024 100644
--- a/Documentation/mm/damon/maintainer-profile.rst
+++ b/Documentation/mm/damon/maintainer-profile.rst
@@ -63,7 +63,7 @@ management subsystem maintainer.
 Review cadence
 --------------
 
-The DAMON maintainer usually work in a flexible way, except early morning in PT
+The DAMON maintainer usually works in a flexible way, except early morning in PT
 (Pacific Time).  The response to patches will occasionally be slow.  Do not
 hesitate to send a ping if you have not heard back within a week of sending a
 patch.

