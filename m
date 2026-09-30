Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EDE6CA5FC7
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 15:29:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 748AF6B0092; Wed, 30 Sep 2026 11:29:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F9886B0093; Wed, 30 Sep 2026 11:29:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 610316B0095; Wed, 30 Sep 2026 11:29:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 37BDE6B0092
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:29:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B4A46C0128
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 15:29:24 +0000 (UTC)
X-FDA: 85270812648.22.205E4F7
Received: from mail-qk2-f40.google.com (mail-qk2-f40.google.com [74.125.230.232])
	by imf20.hostedemail.com (Postfix) with ESMTP id A89BF1C0004
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 15:29:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=intwyHC9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of rockeet@gmail.com designates 74.125.230.232 as permitted sender) smtp.mailfrom=rockeet@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790782162;
	b=s+Xd1fjEzzJJ9Q+1t+m/Y+DthH3oVg1vz338XNFEKW8XtsmH8JF9PQ8SmaErERDjayt/Dg
	B27jZlwg6I0BdMQHDyaa+uomtH5H/EicTXLPFyLK/HjvZP2JZ8dwYwl+b5ssSCsj6k4G9C
	ECi+c1QrjWsQElx+khNv0YNsTHunj70=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=intwyHC9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of rockeet@gmail.com designates 74.125.230.232 as permitted sender) smtp.mailfrom=rockeet@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790782162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+s4UUy/dbmXVrn6D88sSbqjQQFVAT3AI4v3oDb3NPoo=;
	b=J5g4QIoOLoilTC82yTY93tha525jFL5GKnhZEWvnU0zoDrVLWgDAkq0Kdzcbq1e7rdAOTn
	q4PW0tR1J4Bo7RkjNpoHJrb8MFsCOs061PIihicE9oAmYDmb8ZmkGElqiQeh3ngzqyBmij
	oOOWBLVcKeRPZGkr9An6qWHWJ0b+9/A=
Received: by mail-qk2-f40.google.com with SMTP id d75a77b69052e-53324cfe178so39690551cf.3
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:29:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790782162; cv=none;
        d=google.com; s=arc-20260327;
        b=e78t93l2wDNrzEoRc5WGKQojHY0P0rFOAEbA24hZOtsVd+tNAhMjAH5nRiZrnLPNiU
         FhJRW49I4ZE9eTkyTowxBmCLYO1dgtHYWm5oVudCJ0F9wXV6vzBU+u9y1Un3uCxjeqyK
         9lPOOD/M2npg8xPaVKsZW+i+1Ye/C5Rj6ewxznzMzL3oJNK6BsjK5wegXk+ktJajqsru
         NW0PmdpU6xkUILj/K5HAhR7+ltV9cYoZO0Ir1d5cHfQeUfEz2RbrpkrO9uiPbDt47oe5
         d0SVSQ06ZU5oSJfeCSrjkCh+J30npAVc6yf/gW7dTrOm01t7gnRBSkv5gbxctRlt+KEu
         13zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+s4UUy/dbmXVrn6D88sSbqjQQFVAT3AI4v3oDb3NPoo=;
        fh=+6kTuEQ2kUZkVpNqUtrDsUyrw1oUSwvJfz0AzgI6gZ0=;
        b=pcSJ4zIkSHD8xw1CLitimJvZ6xFOSC6GNjsifl64T7q6Fwzg9hC2wLf4V/otT/JQ92
         ItbdfeV+jKeUJfNLD8UUrOlshW+Ctq5ndPR520kf3hhCgqI4yVUGDRexkaEcuSIA18Wz
         8wS1jTrmIBEnPMy8iKvhs5Fm9dOJfGV/CXOHQgvkcUCa0oeZMnX8SGL3qQcPrcBpZ7UC
         KBrW1gzBxQxJeXQguAoJGkk7EuufBTcy8ruLWFIh1X/GDyWMyz/ZN3trT8x7CSzUM4q/
         J1V6yfwWtjT0j4qNH1OCmEFfuIfGs9anS+uEvZFnOituOWpZ71qYVRuYF5KyWmOYaTHO
         HVLQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790782162; x=1791386962; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+s4UUy/dbmXVrn6D88sSbqjQQFVAT3AI4v3oDb3NPoo=;
        b=intwyHC9xQWerf+vjCGLp9YJ5GMizrcQrVylf8Lhf99GawCK2N7Uh7jh3aKPhoe1Nm
         V1rZC4owwvcsetaZd2BknmQ64f35iaLP952Dy0bUsLPdwhTCwJ25/AFBe6I2pni9FECy
         SsaVTiI8VzOqYzK1S2kta8U14XmT2iSar2QMITKarMiOuRKy+Y4CS0JyVRgV2KQvlc5G
         30XKvYPLApApJRNgenBe1wVHx6RQuiuW0z24vQg1Ect58joIeKnq4IN9td7Ar9u2w9Oz
         D8S5GGNEEEdZb4Ueo5AYqtYt/YTbM95Gl7jJ87IVkNny0/lzdKKqUVcxmUh4zKBmGAjI
         Q34Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790782162; x=1791386962;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+s4UUy/dbmXVrn6D88sSbqjQQFVAT3AI4v3oDb3NPoo=;
        b=oTpOGuJt2eEl8S89AJE/Oj/MUgOfpcmL1cIsgj3e6COsMmt8Ssds3IQuMrDI6qEdSz
         ghTY6V32m2enHCc5OTODAnAUinecWyNI2Rf0/q4C0myU2KMSnJeuRZLp5j9btaFnaXM0
         Wggg57E9+0sDsHpW+ieRQnV1EcySIBSiz+Be3/U5/mXOzUgg7sz8IG7Dw63nkpEPAuRG
         ie7i2qGMgVX+/GBTkVso156tf0LK/v3cnj2Lom6hskBBmj22NduGyhF0j+Zcgu99G4Mn
         4B594ea7oCHO/WuyQ9uAbQSn41LrrJkIc5MFOO6w+Py+COpuO8V/m6IuC9fCRdq3GiyX
         Pmdg==
X-Forwarded-Encrypted: i=1; AKwUvBzEEJYcAfGt0e7prn6AYyh3DLVoGbB/K0Me9SHIEXGjwQcO/tasdrb3dfIm2n1zG1IAhoOdjwoakw==@kvack.org
X-Gm-Message-State: AFuF++nAJfj5jtvgz3n9xoqdB3AHNVGFWpyRGOwXggFf2RDopnAuV8y6
	XyuAE//e0ewwDwiACg7EEqahWuUQ4ipPHcwx+6wCbDgyBoFeARHujn7Q/I2MzibSIWU0vkm4CZ5
	oIj/y87+0dmFHLba6gu7maRtJqqFIX/0=
X-Gm-Gg: AYBFou2bC39Gk2w1Yy7bpYIIyf1BjHW0h9dFiwW4bMADm+9oV9SxNQwrCCzz+1I1gZ0
	aUm5/cyVRrHFFFIvFMUQgkAIT5CNjDbQWzM5v3jQ8CFo99fdQP9P5xs9r1HWdQygDbskvPsDHFm
	uEJ7BXVA4/qcSaFZYq1LWMS9s6GFzbHgNe6zUAYxUGJ7ZhXHyb+ozK/0U0rQYH8Pqy29ZoEvq3A
	eCvWmP+FWVG4tH/nDKdvn3CumKNDBb95U4liT3xz2gsPjE/zMaeNduQZ3+1GNjqE8bhV+/8g4bJ
	ujy69oXToGNG4flLbbb0QvUDOw+1lDPWCIuM5weB/uMcwSAnsWl87JSadUNSOmEGulAglg9zFvU
	a/mWBXEVTLz6ZHDB7V7ikvhIpBlu4+kM6dERId/Kufnb4OMbJ
X-Received: by 2002:a05:622a:1102:b0:530:f37b:cabc with SMTP id
 d75a77b69052e-5337485e6b1mr35467951cf.12.1790782161399; Wed, 30 Sep 2026
 08:29:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAAE3jtcL_CZJdcattCwe0RraKnHcZO=UknxEUQVG858ouZCUQA@mail.gmail.com>
 <7ebe4591-2306-4b5c-b83e-6a2e34b52bd8@kernel.org> <CAAE3jtfeKJLSypScqRAEEgvO8En5kJfpbcFn5X+LQ2YL+xz_vA@mail.gmail.com>
 <85aff663-2131-47da-ac04-8f0799a49b91@kernel.org> <CAAE3jtcRQ407P9LTbg=JOwhABQRViSaq2XBefnDdNWiD7PxvUg@mail.gmail.com>
 <1ce9cf3a-15dc-4815-ba29-2e22b05206fb@kernel.org> <art8EKRKMdwSDCkr@gremlin>
 <CAAE3jtftxMkCfWJ77W-xvV2x7jdAN8C8kyofYC3fEivM-Cq6UQ@mail.gmail.com>
 <arz0auULA33fqoWu@gremlin> <arz8Plu6J4YOTi0a@gremlin> <CAAE3jtcanTUrV3xfofwrvYGCFe5o=Vn7gS66bDzuxzeGg6c5=Q@mail.gmail.com>
In-Reply-To: <CAAE3jtcanTUrV3xfofwrvYGCFe5o=Vn7gS66bDzuxzeGg6c5=Q@mail.gmail.com>
From: =?UTF-8?B?5aSp54u8?= <rockeet@gmail.com>
Date: Wed, 30 Sep 2026 23:29:09 +0800
X-Gm-Features: AclHuK83LCCP0gaa6JO7mCWIhwWocLHHA6V6Kq9BAXxYIFSYAN5NC5AE5EEmus8
Message-ID: <CAAE3jtdHi7aSsJ62TpEjkxvwA-3TBLvr5i1ohCNg2aupND+_XQ@mail.gmail.com>
Subject: Re: [RFC] madvise: best-effort deferred writeback for shared file mappings
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: u66i7x13gu3c5eiwg88uknqwghcs6f6d
X-Rspam-User: 
X-Rspamd-Queue-Id: A89BF1C0004
X-HE-Tag: 1790782162-697266
X-HE-Meta: U2FsdGVkX18X0k8P7r0UOoTMeMMJ25dmCUYE7kUu45b2IBClCj/uA6zPy/Hegngmywpdk89gNgfd7gNhrsoN9lwbLFYpDdxCnitPXIcHyTjmHWm3JF3Qe9vHwORp9OqUgzylUhrb58pwSjZP1AABBYj1JvTBbY9a7pJL8H1683Mfb/rYvI4IWzFJN2hsi66bHtogY0XgvjT4AB168OGBtBrpg5isu1YJjgaFn2EMHSWM9Oe12z3gr8LUcKJRirLA13zwxm6dDdZRbm663xBR14zL6tqCAbCcsGwv/laPas8A+lT/3048uvp0Qr8K+6LjxyLnDiGCxvIF5d7uedpjUaXYbwZZZfGs+OERZ+b70OoXo+dXTUfVaKkM9chmP7LdNAGe93OKT1EpZcsOtgxhD5GQeC1jPLzFOXN/vvSdQ8M5VPtX+zt+FINcBDDBdwtD27fASh1lOwnzCphkHe8tlHKZGKbmNrH6hdvE8OYbwkY2mzumsDHb/NOl2xy7FRynElx0BvfskrHD6u8vu7J4/mluQRdZ1wboxHO+y/JUVAZdrIhHuUpgG3CZEkm+Rh9tkrz2VtqCAgsUpRAS8B8Miq3J6MlQWwibxo61mCoBnccReWwmf/lPjSd6qBVi3N09KXlcBQaHVv91Vn/6MZUmQ0iOs+XQuIIU14pBWrI4Bcdlup4P/dcmbVMQSmPYcKcRU6bs71HNS0Twff1FaHXvDCbr1BGX0A57sT8F4lYDfzcWEf9SD09QsSh9bLDsYVk8OKOOqTAZTpRQ8f+MfjPvLlSHh1lcGB7CP4OyetQWvO1OzgEe9t1BJIujy/6PIubwwGxMoqIQ7zHCcjXQwvTXzM9r0G1/FMwZM4KHY2DLqpt/5ly9xL3SZji+P+Ia5lMBqkWPxl0yWadmTN44yjEj0UB/R/pPzUythAdCNcNiyoRF0IS8DuKLaPsrKZapB8KXH59c3GpfxheXZncoEMh
 /DVpzdOR
 9H7NVdNkAda9oVdhi/EYfio+JAo7qz2nkKLsLg2dEgCZ38pE5uflYy9aa9TSyGJ7pleZ0mv5wTknAOtIDRO5Djc5vVDXJEwQ358RTu31z9lhJAwJ5E0T5OcNeYGhdRMpZxPyiyNrk9Xx0Ynu31pskNUMDeaRa78rwSsxonw4bYkJ2HGwYD8ioY1DWHWmQ3bfUsIrgt/uaPgNdY47BAMDuK+fFV/6pTUKMOaDFD8dTB+2XWLrp/HzdgBDxViiDicRhtu6xyplRDSAXtVDWLs1CJaEBlZZhbkOvYEIafx+jU1Gg6E7mu4fLUoOBz/47PFrmifjaJW0bZyEgEvbB4qQejUqvKeNQ7vb2miUrLzOtwBVhuX4sIl/XnLNbUNbHv3WB7r2F5xOAqN+SZoFBj1l7pJ35ZBq2/QvGh8bIUCec/r/9zd01oiH3Lw6JSfBTNxBBWOxbtVkGV+BjVBJ2w2jSVL28sQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David, Lorenzo,

The distinction behind this request is between surviving a process crash
and surviving a power failure. After a process crash, the kernel and page
cache remain alive. A shared file mapping therefore retains the writes
already made by the process, even if they have not been written to disk.

ToplingDB has file-mmap MemTables whose data structures survive a process
crash. Its crash-safe recovery reuses those MemTables instead of rebuilding
them by replaying the entire WAL. A published sequence number aligns the
MemTable's per-KV crash-safe boundary with the database's WriteBatch
atomicity, so recovery can reuse the published data and replay only the
remaining WAL tail.

These MemTables also support cheap, millisecond-level ConvertToSST
(wrap-up and sync, i.e. LSM flush). The file-mmap path renames the existing
file and appends metadata, preserving the data structure already built in
it. This avoids copying the contents into a separately constructed SST.
Moving construction into shmem would add a transfer to the regular file
that this path currently avoids.

Avoiding full WAL replay makes much larger MemTables practical. While a
large MemTable is being populated, random updates can repeatedly dirty
pages that background writeback has already written out. Those writes of
intermediate states consume disk bandwidth without being necessary for
process-crash recovery. Deferring them is a performance optimization;
correctness does not depend on the kernel honoring the hint.

This is a general problem, not something specific to ToplingDB. ToplingDB
explicitly distinguishes process crashes from power failures and has
invested heavily in optimizing recovery from process crashes. By contrast,
LMDB faces the same problem but does not explicitly distinguish process
crashes from power failures. If sync is skipped when using LMDB, the
remaining writeback problem is the same as in ToplingDB.

The global setting and kernel module described in my previous email let us
work around this locally. The remaining problem is making the optimization
available to users of a database library. We cannot reasonably require
every deployment to change a system-wide setting or install and maintain
an out-of-tree kernel module. The module gets us from no solution to a
local solution, but it does not provide a broadly deployable interface.

That is why I am asking for kernel support: a supported, best-effort hint
that applications can use directly, while leaving the kernel free to write
back when necessary. madvise is not the only option, deferring writeback
for the entire file would also be acceptable.
Per-file deferred writeback would require minimal kernel changes and pose
a very low risk, while offering enormous benefits.

Thanks,
Peng

=E5=A4=A9=E7=8B=BC <rockeet@gmail.com> =E4=BA=8E2026=E5=B9=B49=E6=9C=8830=
=E6=97=A5=E5=91=A8=E4=B8=89 22:14=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi David, Lorenzo,
>
> We currently work around this issue by setting the global
> vm.dirty_expire_centisecs to 60000.
>
> We have also developed a kernel module as another option. It exposes an
> ioctl that takes a file descriptor. For an already-dirty inode, it update=
s
> dirtied_when to the current jiffies and moves the inode to the newest end
> of the writeback dirty list, postponing its selection by periodic
> writeback. It leaves the dirty state intact and does not remove an inode
> from an already-queued flush.
>
> To keep postponing periodic writeback, the application must call this
> ioctl continuously at intervals shorter than vm.dirty_expire_centisecs,
> expressed in centiseconds. Once the calls stop, the normal expiration
> interval applies from the last call.
>
> The key code, with checks and locking omitted, is:
>
>     inode->dirtied_when =3D jiffies;
>     if (!(inode->i_state & I_SYNC_QUEUED))
>         list_move(&inode->i_io_list, &wb->b_dirty);
>
> However, neither changing a global setting nor maintaining a separate
> kernel module is as elegant as having this supported directly in the
> kernel.
>
> Thanks,
> Peng
>
> Lorenzo Stoakes (ARM) <ljs@kernel.org> =E4=BA=8E2026=E5=B9=B49=E6=9C=8830=
=E6=97=A5=E5=91=A8=E4=B8=89 20:11=E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Wed, Sep 30, 2026 at 01:08:33PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > I'd say in general the shape of the solution would be something
> > > cgroups-ish, but since all of this is global stuff and the knobs are =
all
> > > global I think you need to think about your design a little more.
> >
> > (Sorry to be clear, this is - if we accepted that this was a kernel iss=
ue that
> > truly needed something like this - which I do not. The solution here is=
 to use
> > shared memory as per below.)
> >
> > > And in general we've seen a pattern of 'writes to MAP_SHARED, experie=
nces
> > > problems' before.
> > >
> > > And the solution is generally - use something like memfd, have a proc=
ess
> > > that does writebacks manually for you as you need.
> > >
> > > So I strongly suggest you do that! :)
> > >
> > > --
> > > Cheers, Lorenzo
> >
> > --
> > Cheers, Lorenzo

