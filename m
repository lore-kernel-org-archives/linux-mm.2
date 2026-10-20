Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5557B606A32F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 14:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=IwrNOKTS
Received: by kanga.kvack.org (Postfix)
	id 4273C6B04DD; Tue, 20 Oct 2026 10:47:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4006F6B04DE; Tue, 20 Oct 2026 10:47:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 315686B04DF; Tue, 20 Oct 2026 10:47:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EBF4A6B04DD
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:47:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 38C911C270F
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 14:47:26 +0000 (UTC)
X-FDA: 85343282892.29.8E15433
Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	by imf12.hostedemail.com (Postfix) with ESMTP id 821B940002
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 14:47:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=IwrNOKTS;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792507644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mML0rlUQf2leT75dFk0AVhURG3XCgO5T9MI2E8M1gKk=;
	b=fj6FAJiAW+c2AhduN+Er2ZekrY2zmenZzXBcCFPQDiCnUH9xVg63QEGGiBGKk1+VjAGs6f
	ESN+K0i9Bo/Oad2zXEg3IBTbvCu4Tdwy7NoIoa8aS8aDYspaOjuAi6X6CKWz6KM6EKj+C9
	1Ez35ZPO5Ncez2WqvjPkGHvrBYxxrn8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=IwrNOKTS;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792507644;
	b=yx3dGlfx3UyMIAXiYXPAeJH+Oe6l98lvwYaQKlgtkJ/fySXamMV6dX7kBeioYI5xTlfFNm
	BSWl/VfrAnkQnCcRjbG7V13qGyVpuzlM1dLUshBZMOTrb0w6mNn514kAeaAAjjkMIr+vOr
	LY3fCkwmejynNnLqlTc0xpv0dC2l+/k=
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-5eaa1b5b84aso708834e0c.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792507643; x=1793112443; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mML0rlUQf2leT75dFk0AVhURG3XCgO5T9MI2E8M1gKk=;
        b=IwrNOKTSwckkY6BQ19GGHS/nB1zRrHvjgYgiLelE0DrPvejct1YXROHdArBgWMCplk
         uN+mB0nP9Vrxh9m0f+MgJynx6eSHU8mlpbZyty98cyXOARl82Vv3nILh3DBheon6oZj9
         6AdI8EPFxXHivxQhdav50Xch5pS3KNibXIRaY6lMaWDrxkvRIb2fUUjea6YgYvLwchAs
         420iG9LXW+wSwakdflrHER8Mq8OsXQqChSaZfHPfNh6Ffj1CjwdB0V+1vUaXZQbAGsRv
         lUwpkji+kuhkW2jmUxQ8viW73/XWfRcSrTkxR4g1PLD2NANY655rW20YwYLg2lmhlvom
         hUlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792507643; x=1793112443;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=mML0rlUQf2leT75dFk0AVhURG3XCgO5T9MI2E8M1gKk=;
        b=EeaIYUyxxqKIV5dZo9JAH+sWU9KO5WBSURnFGE4F5bZrFqySuQ0wgEZRdAKPYTShOS
         mnlsYgxYmfJrt1oBfHlw8b1hbjXvjyLMnMXysiJeRmvnoNXEtfkps3WKBeiOVtYBlN6e
         KMd/jweuNy65RZbreucfUzYh8F6r8vV4DZHUdKFaDELxT+xhuO0HtyUxWM/Qg9zcv1dY
         /9tHZKD2Ir55r8AQVIZU/OAPUifo42rNvXJ2/25BBvgw7ftTKsp2iG6GPWGz60FTujsO
         /9NowuyHDBPywD/WDabMdzpNwpPv1q50viOHTwJAtvl1y9yyGsNG4ID2oNDMWlbi4vER
         KY9A==
X-Forwarded-Encrypted: i=1; AKwUvBxKn0x2DNlDlM8iBCMopiGFQpU5gUGX42vhEmJ6qY5vDo6L6qRf72KDLK3+Za6rV0Lb87oetk8/mQ==@kvack.org
X-Gm-Message-State: AFq9FYI8hiLZK1kfltPG0G0jjeWSe8wJXuTUtjEsUG7zuP8in439E22t
	UHnJzscbQuzL4BemL1J7zMGJnKKojbflUEP0HVg4jPW9ZNs5gKml9q9BRElKQzcULBw=
X-Gm-Gg: AYBFou0UKuI4ldTVVt0eLOuXTaBmHy3F+rOonbrlkMVebV5ewJqFj1/1UrsulUH/JD6
	pNHErrOr5FnLgE1blWLsTgeuLPR8EaUx82k/zxZKjA0J7KmV5HzqJ1bGsC/KmzNo0MsMgfS/TxS
	0NEwOnNXjXNhXorohest2T9oUDgxN2Bv79o8YgO+gz2x+0XOSd+upmIp1bhsM3dGlo/cExftpOC
	fgX23NyL2IBIbW+BG65/b1FAJIdWGnUQoIPIVZLTSkEwedf7BW4N07Kcdx1wKzauhvbJNyvnNhH
	n5hg5SuorOOM6938PfG17NnKiptNYwyM26vF+EefaIXXO6/5S+wnYSwVz/bSppboq2Ge7CTuZaM
	p9RrjoJpfs2uBBE8bA1jGBZbu1xcVPdEX6+t5LNchft2evGeUvWvMB0sHUaw+R26f0ELdTGN3Ka
	z06j6RC3gHyQ311VE5H9aYQ3Jpb9wdZ/ISJLVWyeKE9TE0I5kARsldX4ffWX/x0vHRmFfaR4w7E
	GE81VDhSAKzRwfN3WbZXyhEkXZwCZNBAg3O+kA5YuTB9EaaCo9U5312J4AyLwa6MS8dZpo9dmU6
	gYTOrWBEcliOUtqaFpO2GCQnxws6ah8dZav4gD+kk9EXSqI6wzs4mRwKukbYteKlkrizAHW9CYT
	L
X-Received: by 2002:a05:6122:1790:b0:5e9:5e79:aa5 with SMTP id 71dfb90a1353d-5eadcb1713cmr603117e0c.7.1792507643385;
        Tue, 20 Oct 2026 07:47:23 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ea9b536ccdsm12920421e0c.13.2026.10.20.07.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 07:47:20 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	vipinsh@google.com,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	graf@amazon.com
Subject: [PATCH v2 0/2] liveupdate: Add LIVEUPDATE_SESSION_FREEZE ioctl
Date: Tue, 20 Oct 2026 10:47:02 -0400
Message-ID: <20261020144710.4154339-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 821B940002
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: dsqtsn17qqn5gg53h9xjh1yncporzetm
X-HE-Tag: 1792507644-272961
X-HE-Meta: U2FsdGVkX19UslZPLAA8D4G5qwUhxnQyCrMQc7PXUjTNbVorhq/Tj43Ap6pYwfepUjS+78FjSiMaR9aUbjfoUdgzyDj7Tu7CJeN7SP0LCiIR/K7ocVE34ddTLirPwjTh19gqmbiEHktBLsQBUxK3+E2pkysBFB+NChTvmgyAjqsWxi/vDtOEkWtodp3xslq27TjenxCOoFiWPxseIyjR7HbmNINga/SzeZ3q69aI6NF4de0Fk7THh3GPZxEaQ2hptMoVkEUS7Hnv13sikL1UIc+LH19RlMU0N251ug4O6eWej5AVlwJKtrNyyZGCubjUc8TCTL5CcvQDW3Lo3p1HYtHg5RYxJOx2lx/3SI6xxN1U+6iZF9wG2JRiWCGMWyu+oH8zriYoU8v8R8sOKgLYW0zHgE6HV0X/M6V4KGFECIYznW+7usxrbHRDDAKcv0ko4EqBPskiZUMLYZVjCfFnSfBgPSU3G/RPnna3kIvrXH4HL3X4w+Y3LWvySRa/fhQ/06PGE3nsuVQJ/hxOWGfRMBUlk5i7EoeMeZgRK+fptI0nC3GJ9N0WQL/q4w1ZrYaOa9eKc4gSES077NvU/5cGddlfZdYg9izXhb8DsGcokIZ9f9dcFXczX/IMLhJ51A88xBtc6Lef7UFNjo3xE3b9tMhyc4h8MAkm/YqHgksaFvSADpVGaHNjFvI96HoKcM9au+H1iA/jecxFqAEPMaDPwPimyd8VgSvclKeKotjf4FGukUWMzDBw1hXnuSREr6AE3P/JAo2cVymX64gF6HbR6B7C4QkytnbdGzzrfR0ILkLSgkzeSqLRCvMmR+kW/Hr7uor6nCELtPvAJIvXUo4mLWtsSyt+74e3A/YAXJ5JJinUZrMB/QvuhDJu5FLe/P27OB+C83T/d/9xpwUXlRrZpbTN3P9JyaYujIqksQxEoa4mq3jYc4DH2/Wphy5/31WizKeI9JtNkylMy4NUGo3
 CaRkfAU5
 O2YWL0jsU8iD0WjLkj0+1adaOYTuOmD+AGfunvzMmueOeBTjepGm/VSYnmZ6C12vttQmzQ8FifhY08X/R2Q3O08zzkzlMUUSpNn/YkWYZJyaGmd9961ddKiw1+HkF85LVEpu8jEWzJYZCJOP25o7zGVseclXs8hjkT+n6uN1+CpBbyGmI55y3pVRjO5kXCz5DCeaJ4/bibTS8Df9T2pvE6b0ZpKpqlt0y2wbew4ppoNd0iiFAeafGQiy0vB8f0lM6XYlOFWFZ+AZ3J7Nknyjz02g8gY2u8Q+2mvKQKYViBocYsVcuQQawiBNPFlMH/24SPE5Cex7I2qJ/lbu25E4PeNu260IhdfLCWJBbgWci6KzQfSXYYv19CZiVDPegSrqS1Hrv0q8UkNeplfqk4hNCehKBdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Currently, LUO sessions are frozen automatically only inside the
reboot(LINUX_REBOOT_CMD_KEXEC) path, where luo_session_serialize()
iterates through all outgoing sessions under global write locks and
freezes them serially during shutdown.

This series introduces the LIVEUPDATE_SESSION_FREEZE ioctl on session
file descriptors so userspace can freeze a session as soon as it is done
with it, rather than delaying until auto-freeze at kexec time. Because
luo_session_freeze() only acquires the per-session mutex, userspace can
also freeze multiple sessions concurrently in advance, reducing kexec
blackout time.

Once frozen, no further files can be preserved in the session and
subsequent freeze attempts return -EBUSY (or -EINVAL on incoming
sessions). During kexec, already-frozen sessions skip the late
auto-freeze step; if an early-frozen session is closed before kexec, its
files are rolled back via .unfreeze() before being unpreserved.

This series is based on liveupdate/next commit 27be83a12b24 ("Merge
branch 'lu-pci-preservation' into next").

Changelog:
v2:
- Rebased onto liveupdate/next (commit 27be83a12b24 ("Merge branch
  'lu-pci-preservation' into next")) and split out early session freeze
  into a standalone series (tmpfs preservation and its per-file user
  argument plumbing were spun out into a separate series).
- Patch 1:
  - Drop struct luo_file_set_ser * from luo_file_freeze() and
    luo_file_unfreeze(), and rename the session helpers to
    luo_session_serialize_one() / luo_session_unserialize_one() so all
    of struct luo_session_ser is populated and cleared in one place
    (Suggested by Pratyush Yadav).
  - Unfreeze the session's files if luo_ucmd_respond() fails in
    luo_session_freeze().
  - Update remaining reboot-only wording in luo_file.c kernel-doc
    comments.
- Patch 2:
  - Add checks verifying that non-zero reserved bits and freezing an
    incoming post-kexec session fail with -EINVAL.
Link: https://lore.kernel.org/all/20261015093816.2438942-1-pasha.tatashin@soleen.com/ # v1

Pasha Tatashin (2):
  liveupdate: Add LIVEUPDATE_SESSION_FREEZE ioctl to freeze sessions
    early
  selftests: liveupdate: Add tests for LIVEUPDATE_SESSION_FREEZE

 include/linux/liveupdate.h                    |  3 +-
 include/uapi/linux/liveupdate.h               | 25 ++++++
 kernel/liveupdate/luo_file.c                  | 73 ++++++++---------
 kernel/liveupdate/luo_internal.h              |  9 +-
 kernel/liveupdate/luo_session.c               | 82 +++++++++++++++----
 mm/memfd_luo.c                                |  5 +-
 .../liveupdate/lib/include/libliveupdate.h    |  1 +
 .../selftests/liveupdate/lib/lu_utils.c       | 10 +++
 .../testing/selftests/liveupdate/liveupdate.c | 49 +++++++++++
 .../selftests/liveupdate/luo_kexec_simple.c   |  8 ++
 10 files changed, 202 insertions(+), 63 deletions(-)


base-commit: 27be83a12b246b6b3783e7d3ac5c378ff7520f25
-- 
2.56.0.212.g129ede20d9-goog


