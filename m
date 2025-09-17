Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 404A0CA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 08:07:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A89E8E000E; Wed, 17 Sep 2025 04:07:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 759C18E0001; Wed, 17 Sep 2025 04:07:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 696138E000E; Wed, 17 Sep 2025 04:07:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 48F4A8E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 04:07:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EF12C13B080
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:07:25 +0000 (UTC)
X-FDA: 83898012450.17.BAE5CB2
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf22.hostedemail.com (Postfix) with ESMTP id CB468C0002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:07:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=iIU3ESEP;
	spf=pass (imf22.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758096444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DNRlI7ZexQlRn+KvWa3uWLIRDjuqm7xKDYy7L/4pZwc=;
	b=KHjmoJ+OVQJh5LerEVPknwBKKKOeL51qfAd1v6NikinbbjHx9zUWZo1sHslKr55qXGtttB
	9U3gR9z2sYUQ7NuvJpYeuXStKACK5gl6XYG1NZ6W1NYe7wGNYgZUr+P8EgbOY9rAkJ92/l
	XAS2TWgzBPPRbN0ctAoQSfR7AuoGk58=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=iIU3ESEP;
	spf=pass (imf22.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758096444; a=rsa-sha256;
	cv=none;
	b=Y1SQcDGjfGoufHVrghB+AtnXYSBXrcFI3mGya58e7VHMtuLcdFnujzPYNHHy+XDtMdXZLb
	BW/ASuOHnwTMUxMVwQ+bhXYXGaUrJA5fZcGakTFac2e3H4coHL7ISJCorR+OwgQIz++0qE
	LsE69SyAZo+iqo6JnQQdGXcT1b1QwwM=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b07883a5feeso1094593066b.1
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 01:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1758096442; x=1758701242; darn=kvack.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DNRlI7ZexQlRn+KvWa3uWLIRDjuqm7xKDYy7L/4pZwc=;
        b=iIU3ESEPlAW5wRSa3SLQybVx3cZSCki2jkNnvBZcDsxp52wIaUAo5M/K0J0WpTlkj4
         FbizGo1xk7wZoWdtWqbKpc0fl0wNHi+fa6uGW4ZPqcPXOwYvC97uf+W6EwhNgV26idof
         ikzN9/+VG/6SkuKSYLufggMWrC21Exa63FYlBx6LTzVG2793ukSwhX4FG8eFDYMcnwcb
         rFJu/QS98XlAroBp/TnSzUOrXMiPGXux8iGL04dbvGxFiT+DFp0hTca881pehKdP6MVS
         brhy3o2P9g/FVPK/ZaAIcPaI7Ce19dgmJaiB+ImtOJb+wKRjPoaPAyC+CilqOaiDImau
         atpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758096442; x=1758701242;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DNRlI7ZexQlRn+KvWa3uWLIRDjuqm7xKDYy7L/4pZwc=;
        b=ty47s+vJ22jI6D5Qyl1AQapzjJKX/Z1+ohuwVeVTn6V0jx6Hb4nyrI1eDmDivIXik4
         bDorRri5T7NmmULef3L+PBga75TVlB+58pDZp5iHmV60ps/6Y3wJHCl1kxrTHxuJ4Y6F
         VlC5RB/AwAz4/r2S6zIH8ETOhsSed6a7BFVNNGCweTylpFTkDbiUCKsMkym3AQirQnHR
         IGSjQbUBVeMPQgHIah0SnLkjHhCi80Kp8Sv12LtiKR5FVNNkBLlU2BJoI2q/oJ1nsY4E
         b7paBEjsEWXN2Cm4EDr2Ef7mqCZRrKx1OLQzKZZJ8qo2T6u0ExRqYFJ2aqbCMAc5RX/A
         5jKQ==
X-Forwarded-Encrypted: i=1; AJvYcCVXIAMYBSC+xq12mvXPHOh7oCQ8/Azjz3i1yN6p15sohS95oTrLbQ+XpNjEqSkqAPxVCSKfbw5Kzg==@kvack.org
X-Gm-Message-State: AOJu0YwLzwMMqr2HS7IVGrQHpTgHDTgZXA3+CO1yBaUyRbl3fnuGGf1E
	o2Eg/vdUcx5XnkmJ2IMuGleIdAgQT07ZuIlXu9nnG/PoBZUM9oSwSre6aF0+UfDDPz5jjoF/2tb
	rIPmV37lWaXOOGhAPfXxApqvp8cQ1CaL+4u8b+AFzVg==
X-Gm-Gg: ASbGnct/iIg9YDt+d2EKK4z6fItVLb7MwfZPU8HoKJIcPTg4XyCmErPOAvDcAp04Xml
	q4rtxwfbapX45qwuyz9sIkjn7Iz+IO8X8cPDwfmkXDih2ovYnEp+7CUNTAamUG0GaiQoqLIleBQ
	nfGiDNRhbGnOOh+Jt6iGcM6BzTUsEqzU6K4WkkpwvEs6XFXSMwcvmSNT+oyE0auMqpvAbsqSx0j
	GVNmiKKdmPQZwpvBY6WfEzcUCEA9phek5Ey8G41xEkH2x9xeWXiHvI=
X-Google-Smtp-Source: AGHT+IGvGeJqz6Q02mqcKbNieydN4sypFy+amTH/8OFJSTbb1lWyRw+kypV83RI9Z/BsTyTx51m2zUmiLCU85daA7Dw=
X-Received: by 2002:a17:907:7b8c:b0:b04:48c5:352 with SMTP id
 a640c23a62f3a-b1bb5e56dc0mr141453966b.5.1758096442148; Wed, 17 Sep 2025
 01:07:22 -0700 (PDT)
MIME-Version: 1.0
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 17 Sep 2025 10:07:11 +0200
X-Gm-Features: AS18NWBkDW9SAVDvoKJjAZoW5S3gl8FdSLNEHdMZ_rAESAoQoQ8-hAz_wKVvyLI
Message-ID: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
Subject: Need advice with iput() deadlock during writeback
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CB468C0002
X-Stat-Signature: oqjs45kd9tqoq18rrnrny9s7qsn1rh9j
X-HE-Tag: 1758096443-619346
X-HE-Meta: U2FsdGVkX186EHg1Sz7CnmYw05HZjaC+504URyOPKwrURrWGB09mwrrjM2jnVoA2+YEqzxw3isMAYCOw3KIA7J8RitAUfKgIW+TcQJ4eY6Rv5xR/amPZq2ztQ+fT++lj3VQS/5M27Bu/20bVjL1jyuacHFb/q9MZR2ssed2X8pcs6o4Y+FDbOs62ypp00WUihh3iu2tyGNtojcNjgQqwV4pMZ7oJYZNvQ/zJ6AGpfvFhbqY51EEGxFf5kc/VFvUb516DaCLtgEDlQ0D6ynzHVjnRmdIuv+yfmvcmsOZMnn8zYAAGUTpLkF6ksrrSshNmXWre1BTTqRN1GuyTsoatdWozn0xHo6Xefq5WA6Pfn2kDa2Bog74SlF+YZQ3mi7VZHJzkxStieNH0j8e+3/nrM+LPQkOcHn4uqrabkyChs7l9UR0BxzB9OYBE1HlKEYtSTXf/4rkV7mSudHeBEHHUbuc6+b4Hjl0yPjajNOtaYLxohvbYbEM5Hfp/qAbup7KWLg8MvQcA18vphJbvuqH0AEalY/QnPq5ha/zG2jiQm03VWMq/aOIfZNdfOToK2VOB6WIMtwDq02iw/fNT7IFPzhFX9TixlXskgKmUNTJ/yKPjYyJmrUnbC38dvEzk6k/h9Kl1AP6dUJ5BRMpngegpZBGJViqNUC/xR53VjzEJQwKec8pSlvIskfVi/Sbk60Hiqz/2q+gjyE9pPjzoUbrC09Mooc4D7c7ZFX2nslIZnSSZ7Nu1Unmzmkt5QyHmPcKZGHhu0F8lBMNmjZdSlgpLQzTxLbxKTNWDg6bDJE71mEKoVHj+2SiZzPWgJlZ/4BwwLCedQuhmch8Wa+nLzPdij9MsHl7iawbtovi2ponb8OulGomBp/BqGh4hobkRo5eWc71XwiKZnrUAwr3qgU+zyiqg6ESd7xXjwgVjk34ogkMqJ+vSAVnay3ikBMps+eloGWuuskl85mRmQg2BB4Z
 1v/uZYHd
 RQ5JgJ5C9/zqHpzethVMPDy2Gz0Ta6GWu+dchY6qydH1e55zJdaBbNkPBEzPfcKQsdYYOgih5Xy8z07SCEg2HF/nylNyw58LcQRXAAyf6mT/6Sy7jXjV401/tIrqyewv10hfjOgc665nvK3A/bhfc3gwssasf1LCTYPKG8DWIKFJpLWICH+ZJWad72w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I am currently hunting several deadlock bugs in the Ceph filesystem
that have been causing server downtimes repeatedly.

One of the deadlocks looks like this:

 INFO: task kworker/u777:6:1270802 blocked for more than 122 seconds.
       Not tainted 6.16.7-i1-es #773
 task:kworker/u777:6  state:D stack:0     pid:1270802 tgid:1270802
ppid:2      task_flags:0x4208060 flags:0x00004000
 Workqueue: writeback wb_workfn (flush-ceph-3)
 Call Trace:
  <TASK>
  __schedule+0x4ea/0x17d0
  schedule+0x1c/0xc0
  inode_wait_for_writeback+0x71/0xb0
  evict+0xcf/0x200
  ceph_put_wrbuffer_cap_refs+0xdd/0x220
  ceph_invalidate_folio+0x97/0xc0
  ceph_writepages_start+0x127b/0x14d0
  do_writepages+0xba/0x150
  __writeback_single_inode+0x34/0x290
  writeback_sb_inodes+0x203/0x470
  __writeback_inodes_wb+0x4c/0xe0
  wb_writeback+0x189/0x2b0
  wb_workfn+0x30b/0x3d0
  process_one_work+0x143/0x2b0

There's a writeback, and during that writeback, Ceph invokes iput()
releasing the last reference to that inode; iput() sees there's
pending writeback and waits for writeback to complete. But there's
nobody who will ever be able to finish writeback, because this is the
very thread that is supposed to finish writeback, so it's waiting for
itself.

It seems to me that iput() is a rather dangerous function because it
can easily block for a long time, and must never be called while
holding any lock. I wonder if all iput() callers are aware of this...

Anyway, I was wondering who is usually supposed to hold the inode
reference during writeback. If there is pending writeback, somebody
must still have a reference, or else the inode could have been evicted
before writeback even started - does that lead to UAF when writeback
actually happens?

One idea would be to postpone iput() calls to a workqueue to have it
in a different, safe context. Of course, that sounds overhead - and it
feels like a lousy kludge. There must be another way, a canonical
approach to avoiding this deadlock. I have a feeling that Ceph is
behaving weirdly, that Ceph is "holding it wrong".

I tried to trace ext4 writeback but found the inode reference counter
to be 1, the only reference being held by the dcache. But what if I
flush the dcache in the middle of writeback... I don't get it.

FS and MM experts - please help me understand how this is supposed to work.

Max

