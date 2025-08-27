Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 259FCCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 16:42:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 407CB6B0005; Wed, 27 Aug 2025 12:42:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DF776B0026; Wed, 27 Aug 2025 12:42:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CE016B0027; Wed, 27 Aug 2025 12:42:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B66B6B0005
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 12:42:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C508CC0780
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 16:42:14 +0000 (UTC)
X-FDA: 83823104988.14.06DD168
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id D74BF1A0008
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 16:42:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ms8jto0D;
	spf=pass (imf19.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756312932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ukNwbFQiSMrKDLfMwG5KZXIBLapa00t8EPrxLnQbq5Q=;
	b=EesNLFijkwQGreKbGuUb8mzezOdcfVAgz0C8SaNY19OUG6gY+TiaeZweuQEDbgf+O+5rnR
	y82wVAqjQ94OPrCa/zdk0L7CuiPzPJrIaY3fb/vnZ6iwpL8UwBp+dJNW5O8kJXHSCTvhij
	CNgNfTJHCQqT/5w6tKtJBZ5Jbq8Hm/Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ms8jto0D;
	spf=pass (imf19.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756312932; a=rsa-sha256;
	cv=none;
	b=nQqgLcpcHoWTbCQBRsHmI7INU46ADvgKDeQTRR7bbYp3E7GAMWHJ2jcdo6XVzWEp8IpPjX
	h6Pfj0FBeOMJxi22+Hi23eKZkyUw+o+FDQv9nm5mVlEvz/RonEDdMCKX3jgeRs5GJlReU6
	zoQJvUB6AlFm2eL3/DAWPmvVPTazOVc=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4b109921fe7so504431cf.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756312932; x=1756917732; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ukNwbFQiSMrKDLfMwG5KZXIBLapa00t8EPrxLnQbq5Q=;
        b=ms8jto0D4PC8uZnBRCKXvblDTknG3UI1msy2KWQ7FqThfSpQVsV+yt4SZw5hd1qjG6
         i31k+BdqVguNPOv86ERNl9vecAvNRNvfMFkBBWwJxqxp+uCEmFsuTKhmR/e8jL3aV8T9
         Pedo0D1b++GaBMjK8f4B5SkE74R3FC9cy9B+t3Z4ZhZC1TeS5Jp+Fi731iKNeHMtkPdU
         6E4ZIx48MTg1BhtU+6b4Qlod3ptTp75C0Coa3miBowch++hsuDsLctI0IU7fxQ67aDci
         aOBaJSBoMDQFeZ/BSVoXeUJYcj9gaYS65gIW69cqlX26GkWqbQQ1P9Btl0Fu2n/drZTC
         KWiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756312932; x=1756917732;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ukNwbFQiSMrKDLfMwG5KZXIBLapa00t8EPrxLnQbq5Q=;
        b=KSM9Sd8uEaDR0CUdCzD7VZfqrMTp0vY83NzN8Acn2kr4qbI86dRFbVknUfVHHreUxu
         sBLcGy51DKxCBw/WryhcVL+q7nOpVePgFMTLPdfD0AXKBFHtEd7uQ4ypVdn+tSRQ3KYG
         Zheep39+8ag8K/LkW1k5msSvyO7Ci+4XY0SH65H+F4qAOmXYgzu+VhD+4bprgRIr8Q0f
         LD5EgCboFRqeMhmrbAiIw4AZGuqy+yk2rDtHpDMqw3CREwiqI+MekpttIg4e+9FsIpNS
         hNXaYhzBDyEFwcyXTz8VQSiF/9c4JVYGWAVy65zFCVupePTtXL6/cIdBgQOLvfPUZt3m
         94pg==
X-Forwarded-Encrypted: i=1; AJvYcCVgj6f42ey5ohViPYdyPIglL7Ro8kbohitFebXkliJVILWdDzXwm9vMatKdXuQ30YmanxdwPgGRIg==@kvack.org
X-Gm-Message-State: AOJu0YzGYU/diCbq38vXzqJhAr2RT096Hj/S4YusgC7R41XXX7b87z83
	95phW05F6zb52CAkviXPlY6t6BgWn/RNUAWHlNw20FgLG0SD2nyyPVAiuMl54mUSIBzPkBggEph
	JPny3UmkAqq9Qgd759+k6CJm9RfZXBkE=
X-Gm-Gg: ASbGncuWlT/3sNE8rVcroZr1h5XsoqrgRzHhlL7df+PA9wVC7H5AfiemCASpiS1NPRc
	XdQafkdKakMxPQZEfWoV/XhvBI6NISIQUrGftMk2/L0sj+y2ldYHvB5oEYDwFMhlJfIHWI3DZdO
	Mt68W8YDecJbBUtLsnKRr8YExkxo3smP1agkzmn9t1UPpj7lzaByTEMbr+xerPo4e+884r0/YVd
	oMChRxf
X-Google-Smtp-Source: AGHT+IEdK6rv8rou1a4sOK6DISGx8RbBcTvJq0Xla0Iewbb5/AzkN8ABV37s99VrDH8YODTMQxRHkJAthNi4G6Esue0=
X-Received: by 2002:a05:622a:4016:b0:4ae:f8bb:7c6a with SMTP id
 d75a77b69052e-4b2aaaf96abmr235680241cf.54.1756312931784; Wed, 27 Aug 2025
 09:42:11 -0700 (PDT)
MIME-Version: 1.0
References: <68a841d7.050a0220.37038e.0051.GAE@google.com> <CANp29Y5zWmwXDq1uuzxi43_VXieykD2OOLF12YvBELCUS_Hibg@mail.gmail.com>
In-Reply-To: <CANp29Y5zWmwXDq1uuzxi43_VXieykD2OOLF12YvBELCUS_Hibg@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 27 Aug 2025 09:42:01 -0700
X-Gm-Features: Ac12FXwHpDFGX3qpd9AovfJG44VaG3oJdBDPHtt5VXniGKE2sjOw13BopanbSYA
Message-ID: <CAJnrk1Ziam4ZqqyzOpbUD8j=RwJOK22Uz3VMqWZsUNiJ5bkBrg@mail.gmail.com>
Subject: Re: [syzbot] [fs?] [mm?] linux-next test error: WARNING in __folio_start_writeback
To: Aleksandr Nogikh <nogikh@google.com>
Cc: syzbot <syzbot+0630e71306742d4b2aea@syzkaller.appspotmail.com>, 
	David Hildenbrand <david@redhat.com>, mszeredi@redhat.com, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-next@vger.kernel.org, sfr@canb.auug.org.au, 
	syzkaller-bugs@googlegroups.com, willy@infradead.org, 
	Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 95fq1y593tc5upiawxqmt7h8swu56kui
X-Rspam-User: 
X-Rspamd-Queue-Id: D74BF1A0008
X-Rspamd-Server: rspam01
X-HE-Tag: 1756312932-632306
X-HE-Meta: U2FsdGVkX1+bwUOBmS2SvQgDD2e3ixCEXS/2CueKrBjmaSdOg4IVZ66hJ/mS2WlKZi6YGO/c9kYS5SL2ZZtVtxKM/KEkAXgePGC5QUFbK1bAK6G/Uy6G2mfFCUpv7RuCw0JNn6Ac9ce5IAkK+anpmnptQs3mp8gDjPeYPRwzR9fXKRlQ9chPTpG9ONkjMFYIoDsp3th6pgTFgFwi4XzThpdDr6UOmS9bt4j2SEL7pJiTPzwge8chTEJa5EwVHqu+FBsYFMIFsOhxfgdKiyJPkgzWVFTB0l3bp9qbrxDr6oIi+lLdGfKFYcogwmQ2IAVKO92yoVjExTwskv79lHCsInhWMFGvTPf7HYo8pomEUnhNmuSQFRG8brbDPeXL2MEWvJRbj9PbVakbzDvcylU/vCHwE6ZcHOEgKimIcO7RLz9IccsEfKqCVr1nvUGrLdCW9SoqJOlhPHfze4DMX8a3Cy73Rf+n9tKupnVWKc6/CAf8GrFvrv70SdrH4VaI7oPjxNoLRGVUTvrCljxHJK1BPsHm5X0PLx4HWNL247wV0NyCiXuIPpiovF3qoSQ3EXcOxqObWbJhaZfCiMw+Fu23vBmo6kBKig+OFsICQxJQKaUcM9VFMKbsshOLSLEw8LBdBrhPo8of4fOA0z+XOjf3O33c5crxX09ymHlI2lUUSvQqyfpuE4GY2wgTjyZ98CfztuMEoeRkXYmz0QGA7WO3DWJVwdRf2nFFbWrJWrdZ7O8fG1DAgqUmiQboY9aU0mVCuqY6vSBxF688ssmnDPMV3wo9kyhakdFlLpTo3RrTT1Yvo1d2eMV+H/rpaea3Mrd/nWemBFZN4MFAlb8+gKop4asnZMLn6oFa9izPC7jAd6ewspKaVs0uDbwb9473rtuwA1B0dciU8Y3pPIT43TdsOZmTT4pkzEUV7PdRARo7C4/SGXsej2zoHyCeUHx5kIiK9YBkEQ+NfNqjUIJCMUV
 gmQCB3f8
 NGkwxLeDuJ+8n3rk7tNFqZTa9M8ADhZhYD9C81bfT3ghZODvVztGSpXtXCyymIi5MiqNXKDnTvYCgz6cWOmWj/bQsHvn304jWLR1N70gxTpwCEHtFHtnkbPjLn3147O93HyrQvcEgCC9xvVgrJ9ZeHnr8XftHmhcF2DNiTHxDq6yVU8W96eB7tgZhQJ4AcTPpqUIpU7cMInD9qEQe/RtXGM+0OykH/f7LFlbo12eW3qhS6k6nZPOkczQdbkiA4BiMQ4lKA1pmfPz2nabxRes9ImdrKZQr9hY9azck0fk/GIBewOzca6NrwJiF/S4Go4APgeXVJ+iIcSg66XmeFabrt72tOr1V1muUoHDx8LAcHF5Wf3CLVjpmr4XZpM0Fx8+0AcQVRsBKx+f8LuPw4qW8h+GGHRa/LHMZy5D20GxmoxHIRWTsERTpMj+Ttvoj3nCQ2a5joxXeIlw8pAo9cUUKKNeqgvixkCMjtEk0c9B7wrLWbiPLX0RdL5n4gpZIsuCwn8v7Y9kG4Ad7s6+nt6NGmSBJVZRoYi4binubG/er45r9HhpQnkvkJSC/4kUwK5+w3mBDd6BwiKIgA1UQNhZEya80hZAZe+LmjZAx8hZFCM/2UDBOBuR0M7b1oEHEnzQEuG7u+/adsraU0EAR5w1gUNxE1psrNRep9ww9Ctc6VMJLwsUhthmPJZaGqHa/EfbXOjT0Epr/4nUQzr/L6YHuN3RX1SXeSHGgEZCnT+tBn4YYzvuKYUIEs8gLTDfOeLt7O8ZZJ1v2r/XEB4k5VP9QetVV+w6jfUaqhJEk54MYnwi5AaFpPNzmEVMeLKx7E0CWmC65ckWQfc+wtZt1MblXJJWJc9PFcLxXAjaPVoABSPQuR/Xa7rsfVkhEuTEhbK0Pz/hXRieNxEzOg0NgqNtaZtp1i2EsClBmLFWAg9xjj+F+CSp1nATrYpcU3jLQfxslCDT+1A+QpdvA4hq89LqQFqCtgnfi
 pTWw28JH
 jFb4/OKPmajadPHtfJvAK1zyXKKlDqEbz/5s76JXtXbB/9JmBw4GaBMCvYkm9ghU0NHoqjnL7pHKSt42BDDkMumC7Cpc6DK2kGncGt1oO0MCLweycy3LXyJFtkCw1qcQcFpsgIrhNg2yRcqCam1rPBX2J61cOI/LfYXf0grk6wx7pW6XurnJJIH3IBkdhzbLBVrYj8ASV+yVSJYDn4urFS2AzcBLoIbhiP1TgJArh2ymwPmQJ/Uk0SSaogWtHoeXTbQ6QRqCkCSE7vpAbdUA/1JR7u//50yOwMKBu05A/HvmpFKu/cE5u9ok+Jt9M29uxJP3UUvdwMU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 6:45=E2=80=AFAM Aleksandr Nogikh <nogikh@google.com=
> wrote:
>
> I've bisected the problem to the following commit:
>
> commit 167f21a81a9c4dbd6970a4ee3853aecad405fa7f (HEAD)
> Author: Joanne Koong <joannelkoong@gmail.com>
> Date:   Mon Jul 7 16:46:06 2025 -0700
>
>     mm: remove BDI_CAP_WRITEBACK_ACCT
>
>     There are no users of BDI_CAP_WRITEBACK_ACCT now that fuse doesn't do
>     its own writeback accounting. This commit removes
>     BDI_CAP_WRITEBACK_ACCT.
>
> Joanne Koong, could you please take a look at the syzbot report below?

Hi Aleksandr,

Thanks for bisecting this. This is a duplicate of what Marek reported
in [1]. His patch in [2] fixes the warning getting triggered.

Marek, could you submit your patch formally to the mm tree so it could
be picked up?


Thanks,
Joanne


[1] https://lore.kernel.org/linux-fsdevel/a91010a8-e715-4f3d-9e22-e4c34efc0=
408@samsung.com/T/#u
[2] https://lore.kernel.org/linux-fsdevel/a91010a8-e715-4f3d-9e22-e4c34efc0=
408@samsung.com/T/#m3aa6506ee7de302242e64861f8e2199f24e4ad46

>
> On Fri, Aug 22, 2025 at 12:09=E2=80=AFPM syzbot
> <syzbot+0630e71306742d4b2aea@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    0f4c93f7eb86 Add linux-next specific files for 20250822
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D172c07bc580=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D21eed27c0de=
adb92
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D0630e71306742=
d4b2aea
> > compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6=
049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/669ede8f5d66/d=
isk-0f4c93f7.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/50feda89fe89/vmli=
nux-0f4c93f7.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/317a0d3516fb=
/bzImage-0f4c93f7.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+0630e71306742d4b2aea@syzkaller.appspotmail.com
> >
> > ------------[ cut here ]------------
> > WARNING: ./include/linux/backing-dev.h:243 at inode_to_wb include/linux=
/backing-dev.h:239 [inline], CPU#1: kworker/u8:6/2949
> > WARNING: ./include/linux/backing-dev.h:243 at __folio_start_writeback+0=
x9d5/0xb70 mm/page-writeback.c:3027, CPU#1: kworker/u8:6/2949
> > Modules linked in:
> > CPU: 1 UID: 0 PID: 2949 Comm: kworker/u8:6 Not tainted syzkaller #0 PRE=
EMPT(full)
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS=
 Google 07/12/2025
> > Workqueue: writeback wb_workfn (flush-8:0)
> > RIP: 0010:inode_to_wb include/linux/backing-dev.h:239 [inline]
> > RIP: 0010:__folio_start_writeback+0x9d5/0xb70 mm/page-writeback.c:3027
> > Code: 28 4c 89 f8 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 ff e8 ce a2 29=
 00 49 8b 07 25 ff 3f 00 00 e9 1b fa ff ff e8 7c 04 c6 ff 90 <0f> 0b 90 e9 =
d6 fb ff ff e8 6e 04 c6 ff 48 c7 c7 a0 f8 5f 8e 4c 89
> > RSP: 0018:ffffc9000bb06ea0 EFLAGS: 00010293
> > RAX: ffffffff81fad344 RBX: ffffea00050de8c0 RCX: ffff88802ee29e00
> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> > RBP: ffffc9000bb07010 R08: ffffc9000bb06f97 R09: 0000000000000000
> > R10: ffffc9000bb06f80 R11: fffff52001760df3 R12: ffffea00050de8c8
> > R13: 0000000000000000 R14: ffff888023060880 R15: ffff888023060660
> > FS:  0000000000000000(0000) GS:ffff8881258c3000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007f7354907000 CR3: 000000000e338000 CR4: 00000000003526f0
> > Call Trace:
> >  <TASK>
> >  __block_write_full_folio+0x75f/0xe10 fs/buffer.c:1928
> >  blkdev_writepages+0xd1/0x170 block/fops.c:484
> >  do_writepages+0x32e/0x550 mm/page-writeback.c:2604
> >  __writeback_single_inode+0x145/0xff0 fs/fs-writeback.c:1680
> >  writeback_sb_inodes+0x6c7/0x1010 fs/fs-writeback.c:1976
> >  __writeback_inodes_wb+0x111/0x240 fs/fs-writeback.c:2047
> >  wb_writeback+0x44f/0xaf0 fs/fs-writeback.c:2158
> >  wb_check_old_data_flush fs/fs-writeback.c:2262 [inline]
> >  wb_do_writeback fs/fs-writeback.c:2315 [inline]
> >  wb_workfn+0xaef/0xef0 fs/fs-writeback.c:2343
> >  process_one_work kernel/workqueue.c:3236 [inline]
> >  process_scheduled_works+0xade/0x17b0 kernel/workqueue.c:3319
> >  worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
> >  kthread+0x711/0x8a0 kernel/kthread.c:463
> >  ret_from_fork+0x47c/0x820 arch/x86/kernel/process.c:148
> >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> >  </TASK>
> >
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> >
> > If the report is already addressed, let syzbot know by replying with:
> > #syz fix: exact-commit-title
> >
> > If you want to overwrite report's subsystems, reply with:
> > #syz set subsystems: new-subsystem
> > (See the list of subsystem names on the web dashboard)
> >
> > If the report is a duplicate of another one, reply with:
> > #syz dup: exact-subject-of-another-report
> >
> > If you want to undo deduplication, reply with:
> > #syz undup
> >

