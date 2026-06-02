Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5C06CD6E5D
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 22:18:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE4E56B0092; Tue,  2 Jun 2026 18:18:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBBBE6B0095; Tue,  2 Jun 2026 18:18:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD20A6B0096; Tue,  2 Jun 2026 18:18:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E7A96B0092
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 18:18:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 45A221C0823
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:18:54 +0000 (UTC)
X-FDA: 84836388588.04.8B26695
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf11.hostedemail.com (Postfix) with ESMTP id 624CC4000C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:18:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cFe2Dl9j;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780438732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3cw0K4qIf6+fPTBj4/hLwQ9yPr+Jm8wfwQ5XwEakJxQ=;
	b=IDsvozcmYe4d6YZYXM4f/5TqmPk2FNBXpCd+ZWhDTAZLPzNqeYisy8ir9dYoNWL+vof+um
	PSxwiug9iWr9rS1m6cKugVDfmfDTWMrvx5Rni91vHBkbhHgmwyCxpx8djtM5FdPUMUItI8
	vHC23/MVyyafeszoJlrvJYWSI+ssNfA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cFe2Dl9j;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780438732;
	b=6GIlJ85G8N37odeByeO49ca0J6MaVsyuh7awTh3j/gI2ecNf+SFv9hz+BtGmY0o94EhH0G
	X+S9mEJUWqu9hb5NZ+LZ/QG839fogpLVwF0FGIXW9u/SJBBCH9ZmUeE0jPz2Nxa3tySzyt
	nT6UcwysJKm/aGxekvKh+7fdmDZ8NNk=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-45ef41adbc1so3214422f8f.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 15:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780438731; x=1781043531; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3cw0K4qIf6+fPTBj4/hLwQ9yPr+Jm8wfwQ5XwEakJxQ=;
        b=cFe2Dl9jJ/iDe8Nzn7A2gDJIfPwLT4j1wStbZkRLhPCtJxY51HSja5PPwb1wa/1KEp
         e3nRhkSzd8DGmhBLcAvz9DUwpDfaV4l2Nj2u8SjFcIr+EUR+2yg5tW01iLmvb9PZuPxy
         XHbM7abxIVvU7vyf7DpGoHtb79wVptwdhpqL5cF+tQUI/AnRVKrnzLduQwZ39lhK/w/7
         rI/stpzPfMXCwxBW/VMCuTJ+cNt7tPbiwwMdN4Puvl3I/MOXu5KXcaR0uE8tBtw1KPp3
         U2hrEyiCuAV7olRYA6NS1q1hYLw0lbIVH8VV8kxS4Ir4rzH++TSW7f28vT2Yen3aCf41
         tmxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780438731; x=1781043531;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3cw0K4qIf6+fPTBj4/hLwQ9yPr+Jm8wfwQ5XwEakJxQ=;
        b=RrlFCeT00rcLQp7SQ7jUH/tybekYb7OB3Z5WM4SxrcPqcQ6hM3NDSvn0o6/V0i7Fu0
         /z1xX5Khi9PLItBu+8x5N0e/Os5Rp+POo9PaC5gjYzcfkKBEXp8jeMVpvnwL/p5RGDmW
         SmOLT1NTN1pYRnqaNb5Sl119yCHPnQvm8tmX2pdl4nrK9mI1W7QUGeOAIk5blD8VcJq7
         R4xqRyITwlrcZrc9v8Bea7azBg2G2a96LtqMxajA3Vai0FGsuCTK7wkhuSb9oVfkFYIe
         O0RvCnnxwSupFeEP+1T1U5lSOgv+PbCgSAiFR87CW8QbnNjcPImZxV1Dut0g9rIDG/NG
         z4sg==
X-Forwarded-Encrypted: i=1; AFNElJ9NHZsnKklYy44dPqlN+iRhMXB9WhBjnqEa8rab460R0MpiuurQhXeQkKjOuHGlVHqry0epb9CEwA==@kvack.org
X-Gm-Message-State: AOJu0Yy84jVsa7IdbTHGciF/awlQ4/qD1u4Dg6Qbg6pF0hbbF8kPKmEg
	9dCj93NJzONEhEh2x8NgHCUnrnxJqxzV5BMycx/ts8HbencPJYw4/XGE
X-Gm-Gg: Acq92OGrwk5bYfWdIgSq+js/G5ndDfS8VlFjbp9bQ29QhGFh/6lz8b8tlz2ZLSMCHxR
	g28WblGqYKCQm+huupYLfoWyVz4YIF3y5ofL6mF5+HlA3kTFF7pGsvjaVMbTnRQhzE8kGxAPouf
	NktyqkdMlCUIjIVWQUCkty5HRW8JHL+fRvOoZLE55Nlp75cEBVv4Xi4So2g2ybqEy3El37VLXye
	3l5MwDx7D30UFodnsuj0s5xldr7jhOyF+fz6MVd5XYATJvoocUmpk7pVnLCUPzkXP3tSU2Qzrgf
	QnBCYhCuff1Tk4dOYngd3Fk6PkS5kmrHdVWxHYpG/WZmIewCdVzK8SAddnY2aM32dvAXQGpbAz9
	hJDEtN4mqQSyCwVNbvBmHxi8d6sbiGk1u+XMA1Bm3F1oi1xwOSmZZ4SSlonBncRmZIAPrgfalsj
	5CrvlIOXAYCoi4VPR3JH8GFwi00Zaw0MoTD4pt26aE
X-Received: by 2002:a05:600c:4fc8:b0:490:5057:f5f7 with SMTP id 5b1f17b1804b1-490b5e8cd0cmr10087195e9.11.1780438730762;
        Tue, 02 Jun 2026 15:18:50 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4601f2dcae2sm2882120f8f.6.2026.06.02.15.18.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2026 15:18:50 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: kas@kernel.org
Cc: Liam.Howlett@oracle.com,
	aarcange@redhat.com,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	david@kernel.org,
	jthoughton@google.com,
	kernel-team@meta.com,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	pbonzini@redhat.com,
	peterx@redhat.com,
	rppt@kernel.org,
	seanjc@google.com,
	sj@kernel.org,
	skhan@linuxfoundation.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com
Subject: Re: [PATCH v6 14/15] selftests/mm: add userfaultfd RWP tests
Date: Wed,  3 Jun 2026 01:18:31 +0300
Message-ID: <20260602221831.77366-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260529172716.357179-15-kas@kernel.org>
References: <20260529172716.357179-15-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 624CC4000C
X-Rspam-User: 
X-Stat-Signature: q4g6pykmsh44dt8pe81gt44y4uuhg5gr
X-Rspamd-Server: rspam09
X-HE-Tag: 1780438732-250867
X-HE-Meta: U2FsdGVkX18vXI56diqz3JkiOS1wCeKism5nnCsOVhf+oNhAfKs2k08OeXQzgHdoxrdSXVABOL2+Jv367vJZmIh3mGqGMEqVh+xAy+v9wbu92wNS0i7aI9N4F//rMFhxoDKKvZ0Zg3P1dcOmIhNEMY/1ojHtzRO2HtaKvlA199d6NHI3eZnW0uo0NoWKum7Jij149UXmUffXIuiknmsLV8ZOQR9XI/eRUplWsNcfBrTIgnfY9qEpEKIFxm1iXgQp7aVHam2vln4ExIWuve5TxAM6Y0PR0/NQboqOerTxVs7AoSt0J874Bsz3NO76BS22nZvYC6OGcqeMxs0sl1v6NoodmFqQul4sG/1PeW8RG5fmhyDK5s+a+Q+W7fazA6LJTzSFjaul/WlUGwKV5tyobR8r220c9Ze2v40xCH90okHjC61fOr1fuMG/573yGOa05ilG6OfD0ujJLB+4ZQTia1P0q6CEwfOfbXtpa6itk9degG1seNuut6kS0R7v7RQJgqCMnDaWDqvLZIPa0lpmuJEuLfqOdXjrxtWcfQT/NOvFq3lrcgmEat4vtTG3PrFkGvGQkZZrtuMz1S/d34zIYtbihMg1+wviFa9T7W8xxJaiP0HEhPNresfiKVqRJuvWxRgKbxSOU25NcvjPu1HhnbU4x8InaM19hUxux60qFwl14nG3+uEQd08iRRQ2VcLsHkzi0xyPS1igs7DlSUc/s8nQPf9MvSeOaf5eQvbOnQR4xOZvXgiKExATzwPeAOedYnEpvJgrYU8PlWGzgWU/l9wou6mdUDU9AAXkXy+OTfgFbs+Ze6pJhWiCXgMkh9zT68jDsPpyAF2MzXfdawznVFiGvkP5NYiBOui3IH9dEZBujhAoEH4GJYjnKNAYpytyiJTZbRBe3XI80PM6698BQ3j5HqHhX8lEYnCzOkSuI64gKpRFv8GNebKY5r8pjWzYnDohO/SY76z0zLVYu0g
 RLqSXGkm
 0540zOUYlaukPwgGFCBqlaTHPjkEsAw4kGKaNBgi/G+Jvh+S3iDSFTh7ruqxPOYmDbqJpMToMw+1JbvkkIdRBv9V/UNnGTNU6y+HS8//XjamCHSswYTS1jQeA3b7v/vOPI24uJM2Vtl24Ioa02/EFVdiQdCxV8qKi8Ry/EwSG99+4GBzpmYQJOMQZ5NQ/PIVWmuTBHloK9hDVIbOGZd9RlcWQEXJ1OQ57zqkjoFBaIx9sp791+2t8yc1hcyWEKC4ro1mdgO532Q/eTRpeLhsl5FAUtGRrQfpMxdEz+7XZegV2cQtvSV8BFIlR1PUdObJVn+NEYky9pCi4TsJkKsRCC4wMjxxNb+GoR7ryK/2nmaquLnai/EvWryzIksyd9AMckw5YsXpkMD2DvSiDb8o096LplabBJfcDRbeh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Kiryl Shutsemau (Meta)" <kas@kernel.org>:
> +/*
> + * Test that GUP resolves through protnone PTEs (async mode).
> + * vmsplice() into a pipe pins user pages via get_user_pages_fast() --
> + * unlike write(), which goes through copy_from_user() and ordinary
> + * hardware page faults -- so it exercises gup_can_follow_protnone() on
> + * the RW-protected PTE. In async mode the kernel auto-restores
> + * permissions and GUP returns the page.
> + */

Note that I recently submitted a patch, which makes vmsplice equivalent to
preadv2/pwritev2, and it was accepted to next.

For now it is just an experiment, it is possible it will be reverted.

https://lore.kernel.org/all/20260601-aufweichen-dissens-ausrechnen-0d9b84728113@brauner/

-- 
Askar Safin

