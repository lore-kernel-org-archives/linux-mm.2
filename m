Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EE34606A320
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 14:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ROAhA9Bz
Received: by kanga.kvack.org (Postfix)
	id 8BC686B05B2; Wed, 28 Oct 2026 10:44:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 892476B05B8; Wed, 28 Oct 2026 10:44:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A8976B05B9; Wed, 28 Oct 2026 10:44:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C96E6B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:44:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D768DA2A87
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:44:42 +0000 (UTC)
X-FDA: 85372306404.08.9E7D085
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id EE90E180004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:44:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ROAhA9Bz;
	spf=pass (imf06.hostedemail.com: domain of charsyam@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=charsyam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793198680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P96ClWo1gYeNfWRCa3Ovp0/hmc4uTDQZqSRZRSUUrIw=;
	b=tAXItQNPOkPXt/RpG1MAk87RqYtAWOPKvqvFHO+eYc6AH/ltZMdINvCX9+m/8FvfQB0iSx
	q/53ql2BbdMzCvAS86BGjDA4TvDFm+5oH2XlkDRrK5jNLFRUvrR92RQ3xkqbHI8FWW46GI
	Uh178miHowLw5zt2z8zTI4O4d8GIomU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793198680;
	b=cgwUmB8uNuMeHHnv2bUdjssKKZW15rawlC1lgOi0L0YxSj74xbq0u3w7vKx3B8ALxWp2Tp
	O7ecpKEfOQss11Sg3+w6pUhP3/xToKg60daueo5q6iSbUiEP2AdmRfLgWB6Yinz4yilmxr
	zBDWAv2sNTda61TinTujEwjdi21Txuc=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ROAhA9Bz;
	spf=pass (imf06.hostedemail.com: domain of charsyam@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=charsyam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-8b0f1dfef72so1244037b3.2
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:44:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793198680; cv=none;
        d=google.com; s=arc-20260327;
        b=do+jdRG+2+0qLypTkx0Xmc3xvGjRtyiySOgirZB+ePtrkjVf2V4atAZTNfD++kNlLg
         wI7orD+gQrhRN1fsio4ghpYbdWOhMPYy/M3LE9YxuP6sDIpq7D2O1QxnliXKkv+x98XZ
         wvc/eVPyp6F6avr9sHlC9wk7LwgeG7Z6ow98g5bRZcuUP+pQA/jQorhQ+HOrepB60xbf
         xGzpCKvsKv1/IL4WQ8Qoeq5cZ2L3SfpQQK8naKUKV+tqLfVk5r0WslUsmQFebVnW/qeJ
         lNNk01oX5Er17yoGolqyY9MY8O9sfIpkuwuv/21MMVMfFfljozQsggyakJPfGyt0if74
         J0ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=P96ClWo1gYeNfWRCa3Ovp0/hmc4uTDQZqSRZRSUUrIw=;
        fh=rQV/XFiMBjI/St4AsByaASG//GjPDzRc1Tnfh6VgtrM=;
        b=FMvTi/2J7WUg4BHw2RGvokIwSZEOTS5qRls3iWbMyj+Ywf05XKBCe30r3pJnkCjUkj
         sOyK9XRdBVw5Xazt6ytIl2d6ITLylv0HYXqoTYZPvlkj0MNxD3w6qDAe5mYb4zJ2lDno
         T0wLtHY3AZsuBYS2gG+dXdd7UE6AaV3ou1dcmadGTMhN92r81v5qQG5GUT+ysLy0iBwC
         NgVYqew3QnQcIe+Z/j5XKUP/Wv0HdymbWfV5lHH8OUV0RVn0FVOg5xX9lvmLsuuqwRWC
         3pdv6Q7wSvq8EasYI0WV2DCLSiX+XEVgqy89KyJ/Unqu7si31F16SDf5WTLR8mKq1kG5
         iN7g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793198680; x=1793803480; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P96ClWo1gYeNfWRCa3Ovp0/hmc4uTDQZqSRZRSUUrIw=;
        b=ROAhA9Bz3kwItpsLP/av6chADH3jmIYYiXo6XwefMFkSXrS19SUmNbI5EmcxIQWdZ/
         Nkly2xPB3mHg6DwtcdNOKYz3+IFjreY5SWClP+cNJoE7BuztbpQpXK1VEdD+3kwWGr6J
         VKg6NiUCy9TLxoaUAwEtC3rn3GrjMSTat7T+LQyQ4+vj0GBUJ/+OWzulTZcSZUM3TTRY
         PPixKmUz9HyOBLUeEfLjxokgbEePlpZOuBp5z6WZwk01KBKa0eSllhM63MoFaHBW40CW
         RttckplCKJKuc9Z4uePotG0FImXjnKr/V9BrdtHB/wz2mDpexDrMFYV6CVpVQwKjtRZK
         Scrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793198680; x=1793803480;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=P96ClWo1gYeNfWRCa3Ovp0/hmc4uTDQZqSRZRSUUrIw=;
        b=KG0E2OSbCw7j7uXtiFHxoIu8HO2HziRxghzmrkUu2QEZG9NW/lz2o/AigptQWAOI+M
         Ne0j04OYqH3VqH28lkKTuZohEF4D9cwqPvB6K896fQIqgd1DlzfHAJdsxqO3pUvSkUL6
         BEjD55yQcyIjIDRRndVj9khMN4Cw+vE6CUDCpwgKTLKyzRxsbT/DWP8vCYH0iLJolAkb
         mllu2luGZIVl45Jxadf0H1qg1IBqXnGDVk1iu2d42XwGO9LsToVW+C/uaXiHv/ye4x17
         nUndWhTspZsdMPwkZF9E291XTKyImO0QKgQ4iBwIw2hfHieAauysBk2PMqUmuc6E5yMS
         k5rw==
X-Forwarded-Encrypted: i=1; AKwUvBw58RkttK4DnSUGVzoRighu5XC18bekmPMK4vYF6L3pA/v9En0QUMy109hKBqVjjXCp0T3A8pq0Gw==@kvack.org
X-Gm-Message-State: AFq9FYI6iUmrEIz7Fc7axrkk4fFc8qL6Na8nekbwwwZ8syBMq/kmP4hJ
	fAq3TlKWcMNkbaB+UBwI2gwGGPxCGsmWM5tNlPHem1gwe2kx5zwOomP3TtrQ0dj4C5oxmL8c5Kw
	f5YAHB+mbyHkxvI/inTIrcviEXbMEfSM=
X-Gm-Gg: AYBFou1IowcNar/tluxbVqoaErbQ3yo+3j/Q3fkrG5OOnJqcDUfvOWi/cXyI6UBi6jC
	qcjoZqwJEGlS16d81uUM57NHiJC45+nRzSDvQlkkeZFrBvrmb0nbKinzWVE3KYJ+iMUkduRHNrr
	+pifMukkEue8D/SZdizcvjuWkQ2dRz9ffuV8zhVwm97jmuXa+TOEZoFh3avTG9B1yf1REc0zBr/
	5m9U/9HQsAM5QIAx10qeh2/WuBUpeuH5tMBdtQ7NMmX4IBxBYo/vIqOnf6HPAgghgaj8qEYBZkk
	U0H518XCFmC/8c1vvI4aGNnbnaDipdFX7+JtVwGtrONo7snvnS9U4LlevRztzKRgVtlSZYuRAF5
	ljdly9EGnKxggVGMgxg/fzGUTxMs/PljrNoroMe0IcouG4gitKNYD8GYqZUCq
X-Received: by 2002:a05:690c:31d:b0:8b0:da84:d1c1 with SMTP id
 00721157ae682-8b1b55a38efmr31184787b3.0.1793198679983; Wed, 28 Oct 2026
 07:44:39 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <CAMrLSE6ySuzsJJX-KXoeG49pS4ZVbNWZve1dwj1v1avAhHeEdQ@mail.gmail.com>
 <20261028005452.157810-1-sj@kernel.org>
In-Reply-To: <20261028005452.157810-1-sj@kernel.org>
From: CharSyam <charsyam@gmail.com>
Date: Wed, 28 Oct 2026 23:44:28 +0900
X-Gm-Features: AclHuK8HBRkEplDz3YtgZM8eU0XyW1w5JL3yQ9MUiM0uclR1t0d6WB9xW2KIErs
Message-ID: <CAMrLSE7U92fKTBzRYL+hiSMzoMXO2=ZcQYVpV-90CF=193Khpg@mail.gmail.com>
Subject: Re: [PATCH] mm/damon/vaddr: preserve migration weights above UINT_MAX
To: SJ Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, akpm@linux-foundation.org, 
	bijantabatab@micron.com, ravis.opensrc@micron.com, bijan311@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EE90E180004
X-Stat-Signature: eif3ms5x1c5cnaqricgc5jyfwbeww8oj
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793198680-517524
X-HE-Meta: U2FsdGVkX18kvU3CZdiEj/YZ+Kpi3JVBviSO95g8uKnxZOdPnvpb1te+5uX5Ks+7S+oBgjCd/xOIJ5RCQCn5tEGVD4mpE58+qupi4x+Abo/Kx408UGh+tGw3xvzIJDXf/n/H03zLyW78+zWYFmBwEyvzKEl6KZNki1dzF1MkepGkNESNvodyEhbWAM2Mi1AJBCJBwIZewbC97jk9UF5iYqc1rQBFcRIFKYpDHqptqBB9H0nI3eM0m2+GjHBtHEmYzvEzxEvoWZzif/8cllSSm0CKvpQ35sl4j0AN8uUJzlIobcN2YXz4jCpwOKv1WvCKnPDCftdnslIcC+vaGnUZ6wocm5Cx9bssHWDJrFhSRTk/J9fAzjyphhAK/G1Fzkzmqdy0Vx/xM9SlhrtbbEaicPhSNNvcubfPKjSoWyaHJpE3+H48iuVZ3JmapeQDLJ6c78iAcKM01ylZJdlrBrPoTC8AFU//FxN/z7OxGiUKDsHt1Fgh6A10jJKdfD61apOu6rz+EEozQR1MhqmVYelE9hyhQYiQQYDall0kQYRJNkAi7vzyJbaNXgGMt40WOAPmvRy28ojPH3UzKdAi7z4OdyGkXrozdvW2gXIOutfjJZkgc/5kUDeKkqG2owlK+NI4b+rRD0NkQmuaqgzX0ElXD6xUGHbkoWTw90G4F/CA16GKxaV3FVetBjIF83h+xKQWaxBPwiXJB3GRGHYpWg1arFzGf4bsYGR0bAvncng7jdKLmr2Kr4surF9uFN7CtCE5lx1qYT7hni7E8A/jLXMEhzDv0IkKcqTUr9DCX0GdjgbFyHUiUShYbGX10IeNg/N/G0Cq0AcRXdyJKQZ0RMwpzE6BNPdaOBA6yGnt6xtJAMuwJjYldbOoaymRHfQMUCBe7bTIXfTOpuPAt2TBai/yzsT5Nx6h69kaWCnrjE1sTwxUqjIG9IkrdnRexFA6N3mE11BKsTKpvuLoJHE0NcY
 7C5yJ5LL
 Gyo13jpVSIb40q66tT6y0gvOeICdhvx4Z8pcMTwQVG87FyczKF4E9nGYEjGwiqSOBKfLIETop7ZDB4/qY2BnranmPU/lbJ92GG5Obd6cOGEDZUIMrQ2IQ0dptpvH3swXBr6gFCPL45TwguNWJ5AUtyPvXhmmhkcWq/+4I9lQ6vwd8NrrMSCtQP5sMuDJVjJJ7tgWw9xhjV8g7514BN6kL2bdPus8SU7MeUg+5jQYtbHICl3AFRYYje6msmmyNhMVteVBbnfSP7sgFgoknjiKD3empN8KpG5oQUXUWsyDQKmRJ/NJ+lYYKG9+AOSbsPJ6gW2hmVxMpt+fpG7ZKB065otQZUId2q2PsyNwJCv4wOmi3BkIcHxGSHoyGpTPYOHAjxZo66tLUdk0z3Ij7Z9cZqcVbXQw94xFqchZbTfhuMi6Hg2R7R49HxidUIBmg2dJM8Y0Rf6pxXVwXaKnonsoLIq13vj28jGp4sFeE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi, SJ

> Even just keeping the current behavior looks not really bad to me, as long as
> it is easy to test and only shoot the foot of users who didn't run test for
> their weird inputs.  We can revisit after a real issue report is delivered.
>
> What do you think?

 I agree. This is a correctness issue, but I am not aware of any
real-world impact,
so I do not think it needs to be fixed now. We can revisit it if a
user reports a problem.

> Please avoid top-posting [1] from the next time.

Sorry about that. I will reply inline from now on.

Thanks,
Daemyung

