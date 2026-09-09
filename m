Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E00A0C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 15:25:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB6DE6B0092; Wed,  9 Sep 2026 11:25:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8EE86B009D; Wed,  9 Sep 2026 11:25:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA6356B009E; Wed,  9 Sep 2026 11:25:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 91CEB6B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:25:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0FFAF80259
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:25:46 +0000 (UTC)
X-FDA: 85194598692.19.F281B85
Received: from mail-yx2-f4.google.com (mail-yx2-f4.google.com [74.125.224.132])
	by imf14.hostedemail.com (Postfix) with ESMTP id 03DAF100003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:25:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BlIoqRDJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of diannaaav@gmail.com designates 74.125.224.132 as permitted sender) smtp.mailfrom=diannaaav@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788967544;
	b=UdVmBUaLbZHXaYUDvahqqPl1I3qGrVYgxifY+NAhEkAvzwdcCLzFWHImvOPNX8mq7hSf1Q
	YOJdJQM2qd9mD/SnnJkCl+keXhaK2h43ks3bozLtmmg3i2y/TygUjMPSIsfslrDrzWWswp
	VXvUUKfGINPXSBoOyRveMolnqIXas8k=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BlIoqRDJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of diannaaav@gmail.com designates 74.125.224.132 as permitted sender) smtp.mailfrom=diannaaav@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788967544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NTf+By+ndM0HUt8niBb2Pg1cCrBiUmo/ArZ+BvcMeVc=;
	b=hi68uGlyrlySDLOc49kZ+IjUTihxwefhueZ6RuO/Y7xfRJQXqzqKYMbl3W5AmNvaSEGky8
	6/MA7iDMTpdltsudTNrMc0iBAAoPUnKLyfdC1KNLIMXwPhC6Exb/R41DLRukItfgHL8XfW
	zPPb/2kwZwffJjb7amH4pKejHEt8cts=
Received: by mail-yx2-f4.google.com with SMTP id 956f58d0204a3-66fb34fa3b6so2033316d50.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 08:25:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788967543; cv=none;
        d=google.com; s=arc-20260327;
        b=RcKnUQn64R0Wt2OyPIPc8TnOCkuRWtEN3v86LqK5EPhqPtIeqemkMoALXAEAg92AtN
         R7YjY3KT+q4CGf7WhlneT3QJUgVumZQgA3pXHUAD0lxCENILSYZjeKfgbCizwtBTB9FP
         v7+pirB+q17hxIdoyprNa9jpY6S4OFUTgj16CtxIZOmMMa6+HWKsKDfyZxw6on9KKqqM
         iJc5H7WJpZsNyWJShAbEbDqb9ZggbkFlcqxLCwU5m5RMhSZGwfhfdUPhXLG2rjM5VUdz
         PiMtR9JcW6c6Fg53mwBTCNpjbN209p5JFJji3BNCxLiBEFTVMVAOkqhsiFbKBnva0DU5
         JNwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:dkim-signature;
        bh=NTf+By+ndM0HUt8niBb2Pg1cCrBiUmo/ArZ+BvcMeVc=;
        fh=5VJy2JWoGHqBKRjLIn8RHycSpr4D5dPLkOEWe6dSVIk=;
        b=gwMY5Cd27oizTri5JwKua7wu0qTT0z29hL4B71ff2vyTd4A++vJI0DmQfNVAUQJK41
         mnlt7RVoB7wDnpttbb4YjajW69QmbyQJVgFDgaxuomAHRugqLoFCxoAOZ3L2Fnv2/2tU
         XGT1RSqI7+NxvcSMS6jLzCsMffyeL54IWqOaR2vhLkikzew2nWAJU6f0uQKRfqRAcaUp
         LVUc4Nv2ib54WtKzOIl5R0K5nD7fwNRnqkwRLMVqlGeFycp7Tv9eGzTH8ZnP0goo7eVU
         Bpny0rQGXvC8ju8SujBCoHGcwSfAYO3KmbGffbYO7iXsT6WtRmrjIkfx8m9npAOYrW8X
         YnAA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788967543; x=1789572343; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NTf+By+ndM0HUt8niBb2Pg1cCrBiUmo/ArZ+BvcMeVc=;
        b=BlIoqRDJYVy9tlgIK6Vx6LHYtE5Z6ht+yODIvoepAj2kM6jUtRVg7obzHWzxm5Nc6b
         rA2BdE1V4Ts7/YE//AaeVJvFvys9u3pqERdPOrlRrC4f/dNAglNCXCyWakebdrSTmO13
         RIbf7TatrZjRb5159XN2r8MDuaOL1IIzk6+Mq8sSLWS0Ddi9zy7bntspJbpWHefhpg0c
         bEYODHUxJg1EeudGUcHtCPiYmi5LtnQ4gDxgCKr+j5MEq/n76QC0vX0CJKJJ40x2tyn+
         InhBEFHukygLk2umj574uMEod6EjKmhVCNqtDHx91kYgwAxnofE9TQ+4N3eReHobdj+4
         LH0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788967543; x=1789572343;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NTf+By+ndM0HUt8niBb2Pg1cCrBiUmo/ArZ+BvcMeVc=;
        b=oTmtwuFOPlaN3H2Fvnw46vf5gKZeQRW3GlO2Tq3hJOgUZrC1UGbAQaWdTDU7lBa6rE
         M5zUAoczUaPrzO5F90E/H2N/3TcGEFCCSnKa9YeSWrYiPcgb4nShnir3CgIXvzhFbLXx
         sKKO8M3LMHaIOKsGQCkpHLsHuyidrdwpDAfT5oJFa+ziWhzgrxB5RgaMnwbTL393kSz6
         Mhu8Z8ggrb06O9wvJ64VVMXXc8nXN0IUFiu3kQ+7tne6F6vryfhyhgk2XkkLovlpX2Ug
         jnLnelQzfJZy2nAdLhQf6b/6PnZXmOcls8SS2iaf1OEgTxKr3kJ4aLvLrKv6Hil80jtj
         smUA==
X-Forwarded-Encrypted: i=1; AKwUvBw/gfj9BPeey5gv4p+vobhUpxVKcfmwTGTBoDtKiiOce6YBbTEy8wiC7EVssRF9CZNP+q948HCRwg==@kvack.org
X-Gm-Message-State: AFuF++msR8xGpEGl9swHIeHUhpmDzOhmllzULuwc1dqPC/WY9ZcyEu7i
	QvPjFlTHxxY0uS9nC88AQY0PDKhytJDsw8xforz+dKmv9Etpm77uEPYJIsbxAN+bUnF6BioysFS
	e6Pl6Ovr0PuOoBiNeevvwFGTSpAtWLfY=
X-Gm-Gg: AYBFou1WUah/+lo46ZigXk2Xc0aLhQ+c4Uwi+LYvS4dlIRz2hLYL2EFJu5EV3Fmt/fo
	dai2cNFcmPyLPTB0c019BwZRoQo3y/r1R5ThRxRzVD5cKPV0e0cQDthxIsToWyTIpJjl0H9Lk5G
	kvy5U7Y8Ty+Cawk2T2q7C0BtsN0N6IPViXXjF50dCijMVwzuMBKOEgqhVb0ZdbrWY0r9y1XYtSR
	h06ZjQ4WUJiKoBKWs3AFyfEmlyWHKG55ZjNU7aVxK248DQZtGAOBB5DZsJAvbsMyQdiLeTCGhlf
	40AymRlpzYix0Sx47D1ippkp7tosBwM6lXRsXOUNmDyjqv3rZWZGuQ==
X-Received: by 2002:a53:bdc5:0:b0:66f:c1be:318a with SMTP id
 956f58d0204a3-66fc1be352cmr7235391d50.97.1788967542918; Wed, 09 Sep 2026
 08:25:42 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 9 Sep 2026 08:25:41 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 9 Sep 2026 08:25:41 -0700
MIME-Version: 1.0
From: Tianyi Chen <diannaaav@gmail.com>
In-Reply-To: <c991727d-ad63-46ec-a281-d09980ff08ca@kernel.org>
References: <CACGbirSdR30=YTPQGN-=202jZqiF8gBSewhq+K_fTSNpq=DMhQ@mail.gmail.com>
 <CACGbirTZFsyQhOszpfiHhrd7Red-L_Z_=ke7DbRDe5SQfzi9Pw@mail.gmail.com>
 <bef8f543-ffa9-4cc6-8a7b-6118daf14f76@kernel.org> <c991727d-ad63-46ec-a281-d09980ff08ca@kernel.org>
Date: Wed, 9 Sep 2026 08:25:41 -0700
X-Gm-Features: AcwNN1WmKueNfTKAn_RKSWUyGmYC9EGLG-M4ziRZDzKXzmf-aA6syq0wLvHFrCg
Message-ID: <CACGbirSXP+YSvp=K6q7F2f8-ybgeOs=3OHUw-RNBbZQt81d=HQ@mail.gmail.com>
Subject: Re: [PATCH v3 RESEND 0/2] selftests/mm: Validate selections and scope
 memfd_secret setup
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Joel Savitz <jsavitz@redhat.com>, 
	Tianyi Chen <diannaaav@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 03DAF100003
X-Stat-Signature: 4sg84e8mt36ix3ewwn7or3faduxbwf34
X-HE-Tag: 1788967543-742012
X-HE-Meta: U2FsdGVkX1/uGCjaSuZ3jqsj61RtzKTrE5B9oETY6iftMIAhJpo77Hhqg7zzLguGkt4+FsOigJk/uXz4vtk9XG0zDGfHI+p8AeAw+uLVQ5VgRFbfV/lBX89UFrakzon3ysik4mZyNbxj9q/PIgaJcXWINCGphxh21cRMLmY4L/C7GSVPL4vM+rS4twPFZB59Vzv/uPS5GI9oraUZoc8BXkjzoVX28SUXpSqsERjqzwvxD5rA9miPva6SysCcauD94sAh/YuE9rMAHOzYgQXuD8rNXegqalhhWqSUPs20P6YqvHMblzASytpbFroB1mlznWgSd8TQ39V3O716HI9R+Ayl4b+SAjTPmaQVDqCsGmttH/xmLYqt9NN4IZkaHWZUGXXHDtND1BfqhHeymZJxB5De+teVGmoGprsQC6/gmzmVABiaKqOE+JZpT0fnq6Jbd3ftpNpdtLZlY5sWZUrpOCYt71wPnLWEF5wDb0OPT2cCgCZPzaDpU1Z9ntcsCoLD3u1PomJG6uHgJ6GgCtyUJ3qhC28PW78hgapbrU/YwP/fhpPRy/8v3Oeh8FK/7XHntYnOnqTItHTUNmYBUvOLNRHVi2djHX8jr8F1YBAfJcaCQJ0zG355aH/rpjEHMjOnJCXn4Eo9V9JFCCWEacA67Z/eVLm/eBG5mCR6thS03pLUFmqOq8h3JVfnSpecR4wo0P8ztCAr4O2iRDVveo7F0yMBaNfDDsAglgj1v5bOC/p86g5DBxM/Loi5r646ctMr9zU3aDSBLJGYDF4Dy++W5zE7kLKJ8HPoK3QLmC+rX3ZFdsXCSGL6MWeQNDI7VcE2sv+cubVAZDEFnUcL+N3rsbEW6m9H7Evo972c7pPR2k7aRAITS6yPWvgXb7jTLy9bg+7IRyQGNfyfihWS7KTUOn+Jt72lDJEP/Joc8EKmJ1MQtvWTGRDBHbC41sb6e9NsCAjNmPVXli+byOU+vtj
 gfCZLdMi
 M6/ibMCtTthNWVkgvRTtQmZR/Fi7DW9xOZP5ysihcmdGOg3SpAfLOPwXYfNYYHX/Vq8sh9EgAL0VvcFy5Sm+xaxNoC6BLJib2dXHxLjQOAu97yFRwhYUI8FCR3EnMTRpmEv/7AMNbqPYAbzDwEV59fpJRsG9GssrU9iEmEIR5SCsET/SXGzWM++SB12vDuzhvw72TLeR1RobtGyvFW/+YJ6LSVFwbza67UTjmMpt6vk/bqvRPl3S9M5Yc742L0GlqVi9ydha9C2tK+QVZmWtcKXeV1atod9P1BlskWqMzffg6+cyZx9GxpX4mwEdY/jnK3uT3wkyZkXoCb3DGe159E08rJhfYeNNdXg9Oe4b/Rzm1jNQerbk8CvNI5GoF/HFwk4SDllfRqklKce5XnlgVgIroLY01tdFylPv0kN/DrwRfTBm6cWUMscr4V72kzC3Vx3GIqq4VJzsYao10ZXUz14ZYsq6kJi7QiiKSewyqE37GFlpf4NM87wsnZrLgEaabvirxmGG5PvqBqTI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

> I think what's happening is that something in your mail sending path wraps long
> lines and breaks the patch format.

You were right. I reproduced the same b4 error using an externally
received copy: outbound delivery wrapped the diff header and removed
whitespace. The copy in my Gmail Sent folder was intact, so my earlier
check missed the corruption. Sorry for the trouble.

I have resent the unchanged series as text/plain attachments:
https://lore.kernel.org/r/CACGbirTvSoSeNSpMCBiifTdRKKDsKbgk7nfvh=09fHw2b0M4Ew@mail.gmail.com

I verified the externally received attachments through b4 and git am.
They reproduce the prepared tree and retain the original authorship
and your Acked-by on patch 2.

I will use this Gmail address for follow-up, given the delivery problems
with my previous address.

Thanks,
Tianyi

