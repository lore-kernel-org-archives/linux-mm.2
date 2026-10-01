Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5823CA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 04:28:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B3E36B0088; Thu,  1 Oct 2026 00:28:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1659B6B008A; Thu,  1 Oct 2026 00:28:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 054296B008C; Thu,  1 Oct 2026 00:28:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C807D6B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 00:28:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D50B9A02DF
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 04:28:24 +0000 (UTC)
X-FDA: 85272775728.04.0CAAA69
Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	by imf01.hostedemail.com (Postfix) with ESMTP id E0C214000A
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 04:28:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I49gq6J1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of rockeet@gmail.com designates 74.125.230.235 as permitted sender) smtp.mailfrom=rockeet@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790828902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4OULaCDmfSMFCasJeEbqNa2xN31uSNqvPEakF50eeTI=;
	b=oN3J5Y/VRf3IG+Sy+3EeJkhYZ87dJKWTC104gp1pKqfgXPmz+PZL09nTaIqrdhgQJwUbT4
	r/PNBzAk3rjY201q4HJ1tb1+n4BcuP8KG/4eMFdj2ir2uT7j0lXhr3vGV7I4yvEEHyQp2H
	0SGdKGTPCiSJ0kJcoE6CX9bHZGF4sn4=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I49gq6J1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of rockeet@gmail.com designates 74.125.230.235 as permitted sender) smtp.mailfrom=rockeet@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790828902;
	b=zdj2YoofU3Y/wIlH3iTeKlMkHSvgqaMdaFsHsE9PagzVYKno1t6UzJrevZJhm89C9EkIKk
	s/FTrTZbxiu5kRoRAKp1qzhQxCDY1cyOBEmnEV70hMZa4OyoRdbr4MzFhkQ6wIYP/Y8vfB
	7l8/3DKv4sywXOoItZO8XewUGz2fR0w=
Received: by mail-qk2-f43.google.com with SMTP id d75a77b69052e-5337b1cdcadso15610041cf.3
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 21:28:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790828902; cv=none;
        d=google.com; s=arc-20260327;
        b=QnJ0TZxliD6vsytplBqm0GdGcpCkI6EvGhNFe1kC7m+T10CWyERajI5MsNxcDdbHEK
         htOdMYhtDfZFI9fFIeNfQkrvKcEIwCSVZkvUich7mrYRS6nyIbPGE8tRukd+maL8YOPO
         DbjPge6YGLVtnGkBMg6BB10faV/Jvfls3vVo2MZRojJD6bEBKq2k0FDe85qNxUWMrfXI
         uFyt/V2fjDk9vfZUJgADtR9Zj9NP0DWxEpWyxYTjv65ptMdmxiR2sxkL31AebVk6NZAs
         vy2ZfXdWbUkFK3ts/jEeCQLoBFKKUvaiw10VgNcGMKZ7oSn9xk+1KsTTeViaCP9w4+D7
         W3hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4OULaCDmfSMFCasJeEbqNa2xN31uSNqvPEakF50eeTI=;
        fh=4LDtZRYyLEiyGfhnsUltXhSiXrgqChyuJ5tD4zXh5Ro=;
        b=n/AztmsSxv4q1JsWYA/HwPfG0R/Gx0Mk+g/Av9WsMcxXuvjmLvCqw4r8BJEsgwmfE+
         B+VdrGNAFRYWl3QzkkzZ1WhvByUCMIMtpT+vBpBFzY4uy3tiIZvZOAIRCq04MVEKaIa5
         fpOovvlRdAGu3ZKScCh0tj5LLz6crP1gUZ17eHDzK9olSxQ8MTM0G0DJRoCVTSHx82wX
         1QQ9/xHUCaXWenSyq8R2fRkdd56/xeHKyM11/Zfa7ol78E71gjhQsXI5k5JnW+54QOlC
         L4YqSrhyJtx1Pox58RZpbFdJ+2RifDj0m3Kvl5VbMjNqDUER9VdpCVAVrvlolfzrRRXa
         1hPQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790828902; x=1791433702; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4OULaCDmfSMFCasJeEbqNa2xN31uSNqvPEakF50eeTI=;
        b=I49gq6J11LvhoP9ELUWvrD6MdVoIy+s/Tr1aDm0Txpbg0dHCmfUZ7S3VVsDNmiAdS5
         kKTfMuWrsQ4tbQlAwjGEZSuPvQXQhzQWUrA6bYVPJp+k5Waxlxr4nIfHEaU7dwIoMJS8
         kinjpS2pVY+3O+zg4RGvpWZKWe1j6Jp2ZItSqfBMIMC9G7BQFCfdgNQSD2W7GW6snX8q
         sG7ZsgJtUfDpCEAo9W7I8LHfAnbrrPywpbala9R4tHILoQQzEfUVWG11SiPqwdOfzpXD
         vQEGK1XisL6aTZVGAKGYP71/F26eg6/U/vAR0NxQvjGSgjf7mq5oSu7YlRCC+TeGI4DF
         B7OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790828902; x=1791433702;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4OULaCDmfSMFCasJeEbqNa2xN31uSNqvPEakF50eeTI=;
        b=FSa5H9+hcdQHoYNrjvM+Vbbbo5D3ZBDMNU6pUol3I9ZC+CgEH45Zj+kLUoqc4t1bKZ
         nJLXBpDrbt0nopeVW8EK6/Pe279atm+RW6QKlgpcxzQgIR+GVmArvv0au8u2HhGRy5WQ
         FuTS7uUTuWig9pR1fGx8waPY1ys5F+qdn4EP1xXwT8Bj+6ukU2IHxKSqc3R7eQrGwcb/
         b6nXUwlCFwMe2tVWG4lEeIigcz0moP1RpbF9h7if91q2nF332gLWly5AmM5R8Nudg2Vi
         ReuOduWpwT3dGlHd1HVgha1B9iMS1jth1GFYJ2uvPPhJl3cRavYDHr2BqqLRqWtZHsBc
         0KYQ==
X-Forwarded-Encrypted: i=1; AKwUvBxhUrmjDIwiex0Ennb0UQjhRwJ8Rs1WFvFIA+ndfI/AJ6t3H7Zh9nBgHloywHJtGFaLbVYtrn0ToA==@kvack.org
X-Gm-Message-State: AFuF++mn7H6e3+tpBhnYB6Er0kkL2HQ0TiAbfZDeRxjAxsARvfe7ZFA2
	O8VAAf5MO0xKJqHS5l36AHS6S2s5BCLaYd7V1ZH2OuWa/YEeqfAYtIVrWhcdvSYRFtT64BZS7np
	lP7itbZmq7fJjJ6nNMTv2KxLSFESJRb6WCbQ+RqM=
X-Gm-Gg: AYBFou2WPBvtDWm34K6Y9LLm5eEJE1dW053wnmm88ys1e6xK84ukyljRwRViACpK6VD
	fdbgxjXBJGNv7FoxDac94vRe4BS3CnagT0k7WwXwDMaMBrLPTS9hKBkqFQJIXtAlGxvVtTdATU5
	QF00MoBoJ/vy5XE8niHgYqfLXZckvQCqJtqSuF2N1A2w/Oh4RWGn0fEAnsFoT2amvISzXsbQlfm
	z16TPAri9YYnBcGinIOBwv6KgSZNHMlvP5IHEt4Cqdo01oOTcwFeqLz3cnUUABY6nr2J+m2HlZC
	C2dF5GH1ezSn5somHiWmLsTtk3KkneaXMcra1It8I9yWDjp7o+6YoI4UV2tJxZsBHUezDbjvnSy
	0MwGkQAWEuVuATEDl7Gwr5M1jpMFNpg62D4SS9Q==
X-Received: by 2002:a05:622a:110a:b0:533:2120:a12b with SMTP id
 d75a77b69052e-53374f2948cmr66026171cf.60.1790828901926; Wed, 30 Sep 2026
 21:28:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAAE3jtfeKJLSypScqRAEEgvO8En5kJfpbcFn5X+LQ2YL+xz_vA@mail.gmail.com>
 <85aff663-2131-47da-ac04-8f0799a49b91@kernel.org> <CAAE3jtcRQ407P9LTbg=JOwhABQRViSaq2XBefnDdNWiD7PxvUg@mail.gmail.com>
 <1ce9cf3a-15dc-4815-ba29-2e22b05206fb@kernel.org> <art8EKRKMdwSDCkr@gremlin>
 <CAAE3jtftxMkCfWJ77W-xvV2x7jdAN8C8kyofYC3fEivM-Cq6UQ@mail.gmail.com>
 <arz0auULA33fqoWu@gremlin> <arz8Plu6J4YOTi0a@gremlin> <CAAE3jtcanTUrV3xfofwrvYGCFe5o=Vn7gS66bDzuxzeGg6c5=Q@mail.gmail.com>
 <CAAE3jtdHi7aSsJ62TpEjkxvwA-3TBLvr5i1ohCNg2aupND+_XQ@mail.gmail.com> <xhrorb6wn2j2j57ydnt226khnu6gv4ut3crrmjwjr4iwj7d6yo@43lugxdthgyi>
In-Reply-To: <xhrorb6wn2j2j57ydnt226khnu6gv4ut3crrmjwjr4iwj7d6yo@43lugxdthgyi>
From: =?UTF-8?B?5aSp54u8?= <rockeet@gmail.com>
Date: Thu, 1 Oct 2026 12:28:07 +0800
X-Gm-Features: AclHuK-hz19KHyF61zbpoHfI5VofTsev0rlhVKfjlD23fuWRs6UMTJBnDT2zXQM
Message-ID: <CAAE3jtexTRdqzAodzCkAy5NtH_s3VhtutXbxMjangf8BtB+-dQ@mail.gmail.com>
Subject: Re: [RFC] madvise: best-effort deferred writeback for shared file mappings
To: Jan Kara <jack@suse.cz>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6sanosf8cmx8qu6hetsdqrpr5kzkx7s9
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E0C214000A
X-HE-Tag: 1790828902-768539
X-HE-Meta: U2FsdGVkX1+zIFzeFttzH2aqKe2C8YyG/8Sbt7zZgqagm34UyqknnGEEmQVIWPqOvTqIuHrjJKcSiUKWm/4hK/UYqiDMLUnYLIVcqL4KqbN1Qte9Ic2SDWCKCXzOjafZ+rn7O2S71VPuvye+fQ3OfBU3Hy9hI4Sufm92H5aIzj29W/DdPYM/SqX71CtGZ7n2/4S/VwvEL51qRSGP8njDgXI4tlGKXBcnG9IOYUKUC+zdABcDtojQ0TkBVbfwYUqzBR+G4snRBhsSUSHMfheA3SoNMbzprLegpUZKcRclHU4CF1j4uPPylac4m7k7I/UQNeHLN4VIXqFh9l3TUSX1kDa8AnUKZT5TCth+2FaZVKGxT1wJypFkEDgDPSClYMDS6oJOUkEyD+ORJC6xM95pm88VsWs1ZBoQMSPKC6sSpA8VTIpCowgJWzgI18sA28Ltm6SLf/kD/MCO6JniVVJyLbV46LJtWw8LM+I1rbMu0/W/JOT1O92mHQ9ezQMG/q222nem0/FGqtnt586jK0q46nsPwtLfjc9xZ/4SMYLQpCx0+vQ1loda2HY756OoEbe0RIeE1aheW8SMZTniR19klXutR80nVUkfitaYJ2W0YVoP7cXxgkbd0a2tBRbCLYRpT85IaNTe2yo/yETryYGMdfcVIW/W0lpebIICJeMuhoe07/flhvZYBT3MDBegZJOeMw4eNuS4NSD+fKKl+9BcmuPvlLrWd9jIqAEYreTpLoWHZ3iCqsPQRL1qAI3dnT0ele2ERfwZK3f4bhk6IPut/wNOIzpSHuliVBNrTHjk4nIQDNDShwqB9hbhoXUIFHfvQ/zOJb5cRX6NxW1O/7lAYO79ol8k+C+fYjubXYR6uLr4geBQfewodAzXQVFufVoC1gTwzzudan4AeD0rGqrqXE/x3PcTuMtziPvKQo/PVRKVpKaDobEtRt6G4Op8aLdmS9HuPVo4y/5xoGR2O7m
 GvwP+6/7
 GoD0iptzSzMDXGRWOvDUh30GubjDCAXD8DMu6KNcFzIrFaOKq0sSIoI4Te9VrEt6mXbfmedBEQMlzAMbXKDPWDmfbqToQBwGYD3Xu70AN/eczsviW4NivgKuVyUX3D5UPI7DbcQE4c42vX0zO3Gkf8XIjqW+8mM4fdJ0HDWs1Hpf+pHkyb7Lagoofo6Crxbu0UWaTxgWQJKFlzu7E7Dusc5U+2dJsi7kRwEf9jzwpc2dqoqIVs7LTA8O5yX/1EQXax/TDTXJ1pom6OWt6dnSFCcGVA0xlfmNoN2Hdrar/i8FDS6lgencmh8VuSoR4vhgihnnk3RFoClhtks3IYY27N/mi9H3fxc7tgUA4UBH5ErwCQ394VOmPU0d/DE+JBynGfnHSAsqCQZCS5oJTyR+muBgRujDdDIIlEDpOqD7U+oL8ZdoRML6Lct1XdhS/3hzpw5s2Ed4VRA4EOEnRpjreKBoemuRzMyA4lcvz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jan,

The reasons for requesting this hint are:

1. With buffered I/O, the data already resides in shmem, and writing
it to the regular file allocates another set of page-cache pages. When
both copies are resident, this roughly doubles the memory occupied by
the data. Traditional LSM MemTables are usually small, so duplicating
one is relatively inexpensive (they waste so much elsewhere that they
never even reach the scale where this becomes a concern). Our
MemTables can be very large, making duplication a substantial waste of
memory that significantly undermines the advantages of our design.

2. During the MemTable-to-SST transition, existing readers still
access the data through the MemTable, while new readers access it
through the SST. We therefore cannot immediately release the shmem
copy. Our current ConvertToSST instead renames the existing file and
appends metadata. The inode remains the same, so the existing MemTable
mapping and the new SST mapping share the same page-cache pages
throughout this overlap period.

3. AIO or io_uring with direct I/O avoids allocating the destination
page cache during the write, but it does not turn the source shmem
pages into page-cache pages of the SST file. Subsequent SST mmap reads
populate a separate page cache, while existing MemTable readers still
need the shmem pages. The duplicate memory therefore remains a problem
during the overlap period.

4. Temporary files are a much broader use case. Periodic automatic
writeback is unnecessary for temporary data; writeback for memory
reclaim is what serves a practical purpose. A per-file exemption from
age-based periodic writeback would benefit these workloads as well.

The per-file hint you described would meet our needs: exempting the
inode from periodic writeback based on its dirty age. The kernel would
remain free to write it back for other reasons, and explicit
synchronization would continue to work normally.

Thanks,
Peng

Jan Kara <jack@suse.cz> =E4=BA=8E2026=E5=B9=B410=E6=9C=881=E6=97=A5=E5=91=
=A8=E5=9B=9B 00:38=E5=86=99=E9=81=93=EF=BC=9A
>
> Hello!
>
> On Wed 30-09-26 23:29:09, =E5=A4=A9=E7=8B=BC wrote:
> > The distinction behind this request is between surviving a process cras=
h
> > and surviving a power failure. After a process crash, the kernel and pa=
ge
> > cache remain alive. A shared file mapping therefore retains the writes
> > already made by the process, even if they have not been written to disk=
.
> >
> > ToplingDB has file-mmap MemTables whose data structures survive a proce=
ss
> > crash. Its crash-safe recovery reuses those MemTables instead of rebuil=
ding
> > them by replaying the entire WAL. A published sequence number aligns th=
e
> > MemTable's per-KV crash-safe boundary with the database's WriteBatch
> > atomicity, so recovery can reuse the published data and replay only the
> > remaining WAL tail.
> >
> > These MemTables also support cheap, millisecond-level ConvertToSST
> > (wrap-up and sync, i.e. LSM flush). The file-mmap path renames the exis=
ting
> > file and appends metadata, preserving the data structure already built =
in
> > it. This avoids copying the contents into a separately constructed SST.
> > Moving construction into shmem would add a transfer to the regular file
> > that this path currently avoids.
>
> So I think I understand your design and the issues you're facing. After a=
ll
> I've seen very similar issues with Berkley DB which was also using
> MAP_SHARED memory for the DB and under some circumstances the workload
> performance was suffering from too frequent writeback.
>
> Now what I miss from your problem description is why "a transfer to the
> regular file" from shmem would matter to you. What is the problem with
> that? Because a lot of databases do it like that and it works for them. I=
f
> you use AIO + direct IO (or io_uring) your performance is going to be eve=
n
> somewhat superior (or at least on par) to current writeback workers in th=
e
> kernel. In terms of data integrity guarantees you are again as good as or
> better than using in-kernel writeback because you are in full control whe=
n
> you write and what you write. So the only reason I can come up with is th=
at
> you want to avoid the complexity of your writeback process in your DB. Bu=
t
> in the same spirit we as kernel people want to keep the complexity out of
> the kernel :) and if we'd add a feature like this we'd have to maintain i=
t
> practically forever so we are very cautious with that.
>
> > Avoiding full WAL replay makes much larger MemTables practical. While a
> > large MemTable is being populated, random updates can repeatedly dirty
> > pages that background writeback has already written out. Those writes o=
f
> > intermediate states consume disk bandwidth without being necessary for
> > process-crash recovery. Deferring them is a performance optimization;
> > correctness does not depend on the kernel honoring the hint.
> >
> > This is a general problem, not something specific to ToplingDB. Topling=
DB
> > explicitly distinguishes process crashes from power failures and has
> > invested heavily in optimizing recovery from process crashes. By contra=
st,
> > LMDB faces the same problem but does not explicitly distinguish process
> > crashes from power failures. If sync is skipped when using LMDB, the
> > remaining writeback problem is the same as in ToplingDB.
> >
> > The global setting and kernel module described in my previous email let=
 us
> > work around this locally. The remaining problem is making the optimizat=
ion
> > available to users of a database library. We cannot reasonably require
> > every deployment to change a system-wide setting or install and maintai=
n
> > an out-of-tree kernel module. The module gets us from no solution to a
> > local solution, but it does not provide a broadly deployable interface.
> >
> > That is why I am asking for kernel support: a supported, best-effort hi=
nt
> > that applications can use directly, while leaving the kernel free to wr=
ite
> > back when necessary. madvise is not the only option, deferring writebac=
k
> > for the entire file would also be acceptable.
> > Per-file deferred writeback would require minimal kernel changes and po=
se
> > a very low risk, while offering enormous benefits.
>
> The problem I see with your per-inode hint is that its semantics is very
> vague (and practically tied to the implementation). And this practically
> always backfires because people start to make assumptions about the
> behavior, then something changes, people's expectations break and people
> complain. Or they come with 100 and 1 ways how to tweak the vague behavio=
r
> to fit their special usecase and it quickly becomes a mess of conflicting
> needs. We've been there many times :-|.
>
> What I could imagine both technically and semantically feasible (but
> haven't decided whether it would be used enough to be worth the hassle) i=
s
> to implement some say fcntl() / ioctl() with which an owner of the inode
> could set / clear a file hint that the inode should be extempt from
> periodic writeback - i.e., the writeback that runs once per 5s and flushe=
s
> inodes that were dirtied longer than 30s ago (by default). I.e., we will
> writeback the inode whenever we see fit but we won't do it just because o=
f
> the file's age.
>
> But again similarly as David or Lorenzo I think that implementing your ow=
n
> writeback worker would be a superior solution for your DB.
>
>
>                                                                 Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

