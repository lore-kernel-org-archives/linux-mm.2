Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A31B6078260
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cc941YPS
Received: by kanga.kvack.org (Postfix)
	id 60B8F6B060E; Mon,  2 Nov 2026 10:49:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E2B66B0610; Mon,  2 Nov 2026 10:49:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F9376B0611; Mon,  2 Nov 2026 10:49:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 28A3F6B060E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:49:28 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AD0D81A0194
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:49:27 +0000 (UTC)
X-FDA: 85390613574.28.5BD5527
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 17A5F120008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:49:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cc941YPS;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793634566;
	b=t3CITdn2hcL884/WCZRgqLXFL3FHQsuOBzwd+hPFJ8cwXgzoz2RpC3UIbmISqXJpi8lena
	yuPKCu0X+RZtPcVVLkxNo54P4DsLtpKaNTy1DS+ybd3MHeTmKHP/SoXkg3znqUJkKctrV0
	24ogS8kuSNCcw3xYlRwYS9VtM5ANvKI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cc941YPS;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793634566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7iyy/gzO5i5xGg7RKRWVm/uJUgdHi052Mf3l4AbZX5U=;
	b=XIgYI1WNhh7IEoPJKln5McHefYcbP/G0Z9mviIauUrRqZoLkmVjLLtXwJj5hFjEPJpfWn4
	jD4Fv7wXbE3b1wE3+qE/Gz9RRj3A4vEy0He99IpaujoxGfYoPIzOKuuGtQLRqDQg3sXvNk
	BXRSARff/0hhuS5iV5W7cfg5xVAE/Po=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6BC5060621;
	Mon,  2 Nov 2026 15:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14D61F00A16;
	Mon,  2 Nov 2026 15:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793634565;
	bh=7iyy/gzO5i5xGg7RKRWVm/uJUgdHi052Mf3l4AbZX5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cc941YPS2nfcu/fdm4vKy5uACeS7NcqKa+wn1Ax+CmCToZ7mXauxuURM0O4tny9ld
	 6mWnKcTIooZ9IMq+yKdvUGUbGLSsrs0RG4k7qLucYclzvUGYk38Kz7HD9sXxjRrFdx
	 1PxdyrtJH5xVBt6Kbmpt6pgt9hidNgKD8TPy56sCzVSggBZhzlKcfikdyak2TafquQ
	 Oy7liuLaUTQWt6LIb+vvjAsCm9gn1BZrp02R2D/lfoKO2Tf/XU35wB6dU+C3j0iMna
	 yQVZMe1VBKfFIiD4Mk6k4T2BLBtp23slHJpUYw+2HbObkpws1A17Edz8akyZS30gWE
	 SoRMW1h6EAZ2g==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 0/3] Docs/admin-guide/mm/damon: minor fixes
Date: Mon,  2 Nov 2026 07:49:17 -0800
Message-ID: <20261102154917.99512-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102152849.96057-1-sj@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 17A5F120008
X-Stat-Signature: uemtpk36itth5o3oyur9pdoid9a5atqn
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793634565-505423
X-HE-Meta: U2FsdGVkX19UXJnoprBWKzURUNP5IlO+DcnUVQ66MMrWX3AyfwKp7ujAhNkzCPhea4rPNjAdcOgLVsPlBtce2t8a7e/5LtPWzHx8AfECB92Afh8gFkywHR+hlCR4BhGqEXpu9vOVCf0+qum++lDXZ4hfBc9122NWCRYLrMJd+HcRc97r+09vrkABwGOL1LpHRZGEV0BeAAwffLUrqHvTKXRoMo1gr231JByiLglT4slJEFLG9Ezslo0B+4mH/G4DvtnY1eShGVklxo2FnMwdVbc4/70LGubkV/g4pCoVXtX0XqWQ6En/MLnN7v7ar72kXfEoYFbuwcr3jn/4vBWOHV1FRta+euKN+jEj0X5gB0dBQI41med4q1htywU1VES6YQ+ruqGGPaPwvuI8iNJS7RYuJDuJcToU1KxaxYh8rlfS8OKE5okJDNIZZw5Lq3IBjWLjZjc7WCmbzKPmxj4eqzaPsRLGRKLFhr5CVB2C37VTmE2U8XUU8pA4hjPRuaq5/Ay+/KZJdvqDbRqxf1I5wIwy9Oc7aUTF3+mQYGp3tSrXUW6AXTbPsASPcq4rONF2uSaRszJqNcZfiKXbFEZfG7zsz/vKc0urOgXbiuYIB5UP0vJUiuPDU+uRgnnteP24+e68NMMzdPqrIALQgzHuwC4RJq0UqF0UJDrfC14t+RmaY6i1rozFWQ0Um1b0+u51oXlMiVaeiuHa5vMB2wioxnz31l3TijmBHxMbgirLGZyTeDmrp41CfHF/Q/JVKmAk2+NaoAgcyAEVxXivs8TN+xD/OV8waIauijcO15E5vP4iVOTmYe2d4TvYiD5FHIhHUfJci/cVrjIxUCQGn6wygErDTnOP+hnPEBQQ+1IR5Bih1c1HlIv4Kg2S4SMho3UcoCs2OgVKznDLdVe0v23jikCfJgCAWVHp4WNmptBZzA+XHNObgPF61DqpLacqRQsnV+t+D+TbE+IY+hhfWO/
 tv2iv878
 DFZ5/0Ryv8mFXoharaRZ+At5n9vv+rNsMiDgbb+O9xlniNBAQEcCDG0hTacuJXqUMti+q14H7umrGhBCmp3CTv2yeW27Yf1S8mfRHV89OWnhF5PgpDFEt2WVBnFdKLesfY4aeJrQf6kH8D+fCzM+Lx2RN6wNKqvwhN1mY7RhKDUCWQQDGgjT52JK66vmed4ESbFw7peNgibOp2SKA7THrY0V4dYA1yxMNhFIVafztWn61enXDdBB8aLLtDA4t+0bZ5Lg+WYqct5+sWaWiuWQ3mZrbgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Andrew,

On Mon,  2 Nov 2026 07:28:44 -0800 SJ Park <sj@kernel.org> wrote:

> From: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
> 
> Docs/admin-guide/mm/damon: minor fixes

I just found applying this series on mm-new fails, because this series depends
on another series [1].  Pleae apply after the other series, or let me know if
you prefer rebase of this series.  Sorry for inconvenience.

[1] https://lore.kernel.org/20261102150757.93058-1-sj@kernel.org


Thanks,
SJ

[...]

