Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5D98606E0C4
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 13:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=pDVoan8W
Received: by kanga.kvack.org (Postfix)
	id ED7726B05B0; Fri, 13 Nov 2026 08:57:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E705E6B05B2; Fri, 13 Nov 2026 08:57:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D885B6B05B3; Fri, 13 Nov 2026 08:57:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AF9FC6B05B0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:57:19 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 402201202A2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:57:19 +0000 (UTC)
X-FDA: 85430247798.07.A8F0332
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2E573160007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:57:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=pDVoan8W;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of nogikh@google.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=nogikh@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794578237;
	b=qdUESkSg23v0Un992IRnAIUAs2hDLFXJI45KmeVrznHc3wclY6iBHClbkecIgDN61X597R
	GuFbaHo6rfzVChuUv3uzoIE3pIpNwVctlaub9Oe7257NEIc+OYwCLlagG4z6ZrKw9Dz5Pk
	pnftKor9CqVJ7FLyTP5RoMiIfaD/7yA=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794578237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oyg73YpJiMIbGke9EcWnaG6kp5irY/WfHZ5cN6Nkeyw=;
	b=Pz8hT3E6wsMoRw1mM+yGEBSskLL9Bxpdeb8p3KHmXgGPpgMj6+zD3GQIbCJqtsm0PT/oAq
	JDQKVb3jWI8v3mcBe9vN82WiTWUfwwR3j2J9sUohz0/iqGJ2ZSNTqJGnxYzXNTSgeBxZm3
	kzK+m8p2awE2052B6SIj4R3Fh2B1Y9E=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=pDVoan8W;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of nogikh@google.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=nogikh@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-8439fe796ebso1391356a34.3
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:57:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794578236; cv=none;
        d=google.com; s=arc-20260327;
        b=S2Mc2ded4YIUG2UZ357E69mCrKdCMvGLIuKNIayMhjhNp02M8bs/eq+zqLgqQZ8hY5
         lCLzqulCuva+NgdOTlV1InroCHiTOGrnwH6uPSxuFfIuWnJapeWmeKPpiq3NioHiK3J9
         2qt11UlIYai6fIRu1pBXDsYxUKtpXxu1Cx+4OAWBPQ/vK0uH1Q9uOStsEQ5EtoDAupu9
         qahyGv//Hrzr+Qc9/vl9iIBj9wa+xJ/csz7rSwRYRlO1SeBtCaheSuwvNZRBfRMwtQTw
         ihaVsyTFGoPvjVnZwBlfIsnrng2g8S5TRpI6n6cZUbvgG+mKAhbveMR3+8pWlmzI5g02
         j4nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oyg73YpJiMIbGke9EcWnaG6kp5irY/WfHZ5cN6Nkeyw=;
        fh=7r+pzEXq4F2vtzsbq2aKitbN5AdNfWfBoxpuKE2KDXo=;
        b=WGrl0YC6LKcrTad/u2FX0CcYbIkjh7oA87zmdHNKCDLe20uB1LzQe3F37Qfumlwn8T
         ez46/lxW1WUJoOcJ76vwhuS6QIXUSotu/gj9cmhwqK7Ai4NlT2QCl7L+p+x29aYK/uTW
         8ufcesDE3JRQYqYN2tzwdxLSiB521t9qKS0BbXFwKJf4N1Hx0ZChCNop4BoGsWc8TSEy
         qB+HGD7DWRWj0XzsBN/I4Ia9sBHSDHTFwgdxq/9/lWxHz5WQ48CKelU0TpP+A93Ui63e
         7yzVjz0FQ0+tOuAK4xczhxRLFa7t46ZlDsu3JWVNFSiMtddZyUMkET57qhmfTYo9mYlp
         Zqtw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794578236; x=1795183036; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oyg73YpJiMIbGke9EcWnaG6kp5irY/WfHZ5cN6Nkeyw=;
        b=pDVoan8WcQPI+jg3IeHUsuwbDEX9G9o6Ibo33grSqMY/j8RrlLEUqEwD32GmYYgKo0
         vgkhHtQXBW9M0SZlKVN7H1+l1BEweKS+j0OjaYAhs8xeO8Pf3rQM2Ch3xppDi4iQ917N
         t1th1+uWHL4ybWN9yGWGKOW1o7oAYQwbWimwo18+xUcvJ3jnlA04TuOcw4cxxpGvR8DB
         4vOto09gMnQopYPl1rPEmmZdIy0FxHJuy45c+4TiD5Zeci6GPcsy3gLxaV6/ZA2kniKw
         3RPctC4Zpt4NQknM8kadKuY0BK0L5SjkrX2mjeKu86dHCtH8JUAk7s0oVX5kFoubJgMe
         zmbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794578236; x=1795183036;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oyg73YpJiMIbGke9EcWnaG6kp5irY/WfHZ5cN6Nkeyw=;
        b=lyXkSBQ26s6LIeqxvSNScZ73eJfAXisfTzs5kbOn635WLZezZvaSV6+nYIWo3s9+iB
         L6dl509wDbogMu1u17qYhCrXDMdpzF4xBO6mBRxTrFHRcozoS4OdMSi++FSU1/KRizaq
         WGshjf39IaQdVQuUPtOqD8xMysvY8JAv+w4m760qeTkS9EHdq2CB41ZvBFphd6qWoOWp
         Pt4ei7HGXHkNJMPI4KBEzs1BnkH08LU275tY7OpeK6V9PFmQaDgXImvi5UQf+OIwKb8z
         V2yZnSDsLJFFxtScSn9+30dWX9Sg30+PuFQFhb1mtNMlwO9c5KvmHxRsxTQCTxI9g+I/
         E8Pg==
X-Forwarded-Encrypted: i=1; AL+hErH9tBXMPtJcbvGmSjr+Ig7kTyVIrF/IAk7z2m3hklqweCfVbIeMSfizzYGA8XYRs4eVmsLNeNmqug==@kvack.org
X-Gm-Message-State: APuU4Z8V1XsUniBple199Fk5Uk0cmA+EQciapBMfO4x0cLOsx1VJLgjG
	wE1tKnlsR+QQwG/R+kJ4ikYMyBRv2L/GUDem0oWmM6sjNCDX4isc+J2BZknlcZAzKjzpMTwcFLT
	aYJFFjNauCS3tMwTNojDSE1FgrIgdf2tZROum5mCc
X-Gm-Gg: AYBFou0ewTGSr+wbVHnSRAvhQLbLUgx+YM4sPJhbetDRnvnHH6SdML1kocwxbqQzvlR
	vtqF+hICPPY3IN4w8z8qHKH/utN01WTz4LM9ksaHvK3tY9RExQg6CF1CyTgZ+FZEN8hac4VksBA
	O1C5p8rwYtZBfrZugGSMnF59um5flJMTFX+GR0d8ASWh3piWJFgmItaDYY/Ryl/93bubV6d8P0m
	qAZHVLbc82kyxcR4PrxO+XDMhzkjpBHxJ//4xoobBpUwUN5hJiCcUqLI5xv7d2tJKeZ53TabyyZ
	+BKcoRCRYQYhZsdAvW4H3OumRXDfUPwZ1arKVA83LIvFRW3r8onAjNKgSmzCONnoXFd1nl+otki
	eyuIcEomgRNM1Qdgro8mN17pikFPkJvHmATyzb1T32B3xLaeF8IITkljkNFfM9l66//8F2z6DW3
	QBT0dyA2LS47m/YKQ8jEHb838bJHzja3dO38QuTZ7bo+x9NGod/Z1kTdLDVGxDc7UywOBCcZzNN
	Ocs/CLP
X-Received: by 2002:a05:6808:3013:b0:56e:3380:1225 with SMTP id
 5614622812f47-56e64e03a5dmr1929551b6e.45.1794578235590; Fri, 13 Nov 2026
 05:57:15 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <6af144ed.f50b2b3a.2c0de7.0010.GAE@google.com> <20261108202849.2e5c40a630e66dd39334a915@linux-foundation.org>
 <CANp29Y5m+47Y5n3Y8WvCEm2UgzGBOnpMK2eqY4aO1L+hQb1yNg@mail.gmail.com>
In-Reply-To: <CANp29Y5m+47Y5n3Y8WvCEm2UgzGBOnpMK2eqY4aO1L+hQb1yNg@mail.gmail.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 13 Nov 2026 14:57:04 +0100
X-Gm-Features: AclHuK8GcatdsmJoXEjM9GYaBuZWdVQ-CUCU6-fQDT0msNyCcFfz9P5ZWrsfBG8
Message-ID: <CANp29Y5C+fex78EryCG-yO7Ex3ait1-LwOpEwZG5k_5T0z7iPQ@mail.gmail.com>
Subject: Re: [syzbot] [mm?] [bluetooth?] BUG: unable to handle kernel NULL
 pointer dereference in __refill_objects_node
To: Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot+73e34786d639a8eb1324@syzkaller.appspotmail.com>, 
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2E573160007
X-Rspamd-Server: rspam12
X-Stat-Signature: 9d1hp8crqkanghpjupn8e59b59n4fh14
X-Rspam-User:
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794578237-738012
X-HE-Meta: U2FsdGVkX19Wefb0nEXXwvxKKu5PI0J6FRtmZ9bKYSZaN4GNzRtkDmazVeK9Brjc13IJPKlcbYPHmSBYPFYEOXSRaSlioGAs1CXCiomM47SpV/Fw/oTwCk/cMYxOZ6c4OXBQqKfTcMmhwloTRx1wv5tRRN9mMOvXvmFw+SeK5apGrVo6Rv+HWbAqmgVZe1MTr8UagBozxEk5xeHvq7m7m9BNuA8GNvZNiNfOWDLk4SM2qStsZzjQNRDSAuSVAUvAZ4S/OdX/7tT7b5qWBXEQiUz93Nf58r64LvKHtBU6FBQOJcQ+WNW2VLJFf7u5IWWkrOQPXk5E8ksPvFxuyJiFNrarL3kn+MF0OreK9Duu8vixTpKo2EAZycklhx4pqGGAph+78HlI3AR5pnj+wEPZhiVqzFRGdZF9OsB9B8txk7W4ykzoH37FWPjTuj0x3TQ7f3zJmi/3opqoGseehYlXQLr1myxEQa8qXhEU+MZOaEfJcnugDPWo7L9YuHOzMiTmYAPF63klltTUveLXVd3GPsoguhLD2LKGZVRlBozYpPVk4bKUUGAIWWr5MyZpcKiN9jUfpLjHzDA6Fwu+0Y23nhoyzylheie8aP+mTQSA3i4f08lqKxf/btVMG+KmKbIy/ptsKjnqzhPzn222NT5QHHstmk1XpOF/2BZFF2KubrRyH3ilH6q9DiA0wf+tRhlwdVp9bcUasPCzR66QpoBkf7sxNi+gH2HGazC26kFaFE/5lfGGykDJ3gNG467G8yQnsWY8eDCVah/90bpkCXg7ciu9ns3WlRRIpzbAXBNTEUv7dFP8EGGGAMD06sptBbcuCzCuFzzr+yGtXeul9j6mxCzhdG6kV3FXnFHefV4SpkxbQ2uVo4Ey9UVdVgMiDpQCgHiTpnfYxrfD4KShdjjBEIC8NS1+iLH8xCfier1PgMi8ErLieBcmoDhjyfDDrx+nP5IKB1ZiqmREh8Te4BS
 43MVp14l
 WYeMlWIHmNyxUuqa5WaXv6IRKHeteEKjEEdnzhxMcCjXdPRSO+u3YlTRssLar4gKD0wA8xvy7YQ2g3yGTUDvhcWmAlXWvLHr0luXWgqwVA6ns9zknOUFIZqxKEuHIaViMz+EemawYseOuap04G+sqj71zaf/so+H72lCgNcU6HAU9GM5YJ1U/TDFTgIGyVL5yzJmlXQY3KS68nHjFjTJ8EIo8pfBlXnw7tVT8RHvOBjSdbwyMq5buxFsTqQafiHmlK2m61Oq+7CVoCsJCFIsL0nhBs0nCy9RUorPzMK0q/eyqLJn+7ZSNLRQx9batjQnrFITAdYPvCf2U2MycmOJK3nfXQK55YPsLck5srxaksnN4+zER0OK8lugdbM1T/WcNDC+MBtcXu391OEAL9t0m554JcIdCkPMOH68rNA8L/Mk7E6g2jeNqgi1UvZrrCa7J3blqDuqtSMZ9+GGLp9z4Sniq7Smd6QhKWD+T7oW/wuCjXd3lwbkRocaRkqodihFHrHatogKS5kHdWC702SKcFzKG95DoTH7MLCgaXvSy/Y774OKagzeSFXlHHZz2IWLAB6LoObfY2cKz2dSWQUAKV2I2q9Xm3KlrlBLNqQGkIszXDa5B30S6dCur6XG49zScElv69ItiGqmRqhitvOJbPsgKPwmrf+FKqz44kQ5PHSxtJZ1PAK/4bqtfnifXApaB9KXBMoUW7t7mQ3kvFH1RZ/eaG+AWhooiG9s6vqrLnZ3Lyh1VVjfEoEpfWJsfRt9wFBU7/WHG3yi0gEdVS53bVHjGqaHUvHCF8ZcJXCqC41b/kvUks2kD3cQ/pBA+SRjDPqQqJhJ2NjjLtJQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 9, 2026 at 6:35=E2=80=AFPM Aleksandr Nogikh <nogikh@google.com>=
 wrote:
>
> On Mon, Nov 9, 2026 at 5:28=E2=80=AFAM Andrew Morton <akpm@linux-foundati=
on.org> wrote:
> >
> > On Sun, 08 Nov 2026 19:58:37 -0800 syzbot <syzbot+73e34786d639a8eb1324@=
syzkaller.appspotmail.com> wrote:
> >
> > > syzbot found the following issue on:
> > > AI-generated root cause summary:
> > > In mm/slub.c, __refill_objects_node() replenishes percpu sheaves by d=
etaching a
> > > freelist from a partial slab via get_freelist_nofreeze() and iteratin=
g through
> > > the freelist pointers in a while (count && refilled < max) loop. Beca=
use the
> > > loop condition only checks count and refilled rather than validating =
that object
> > > is non-NULL, a prematurely terminated or corrupted freelist (where fe=
wer objects
> > > are linked in slab->freelist than the expected count =3D slab->object=
s -
> > > slab->inuse) causes object to become NULL before count reaches zero. =
On the
> > > subsequent iteration, get_freepointer() dereferences NULL + s->offset=
 (offset
> > > 0x400 for kmalloc-2k), resulting in an immediate kernel NULL pointer =
dereference
> > > crash at address 0x0000000000000400.
> > >
> > > full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=3D73e=
34786d639a8eb1324
> >
> > Thanks.
> >
> > : This looks like a bad syzkaller test, not a Bluetooth bug. The
> > : reproducer runs as root, opens the active PCI device's resource0
> > : (mode 0600), and maps its register space writable. It then places
> > : syscall arguments inside that mapping. On this GCE VM,
> > : 0000:00:02.0 is the NVMe controller; its BAR contains live control
> > : registers and queue doorbells.
>
> Yeah, it's unfortunately a known problem.. Sorry for the noise.
>
> I've just sent a PR[1] to prevent syzkaller from manipulating those inter=
faces.
> [1] https://github.com/google/syzkaller/pull/8111

That PR is merged and deployed, so the bot should stop triggering the bug.

Let's close the issue:
#syz invalid

>
> > :
> > : Both crash logs show NVMe completion ID and generation-counter
> > : errors immediately before the SLUB fault. During minimization, the
> > : same program produced crashes in several unrelated kernel paths,
> > : including runs without the Bluetooth operation. This points to
> > : disruption of the active NVMe device and subsequent corruption,
> > : rather than a demonstrated SLUB or Bluetooth defect.
> > :
> > : The logs do not show the precise MMIO access or establish how the
> > : freelist was damaged. Please rerun with the resource0 mapping
> > : removed and the read buffer in ordinary memory. If the SLUB fault
> > : persists without the NVMe errors, we can investigate it as a
> > : separate kernel bug.
> >

