Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6B2DCC6B2D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 23:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B8A26B0088; Wed, 14 Oct 2026 19:54:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 769F26B008A; Wed, 14 Oct 2026 19:54:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67ECE6B008C; Wed, 14 Oct 2026 19:54:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3D7C36B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:54:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C61C740797
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 23:54:25 +0000 (UTC)
X-FDA: 85322888490.09.1A4C654
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf24.hostedemail.com (Postfix) with ESMTP id 78DB8180008
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 23:54:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=KVC9icqg;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf24.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792022064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aBSAefliNrk3ebh4aSKUwcheBC1eSCHlIw0ty7Hc3FA=;
	b=1Ar/uRtwPqtPCwnlESRos9EFiR4Xbchijz+pcjR5Ir/SAlOMc/SiHyc3Q+rDrVYZpIXpNX
	Pa5XI9XRMTkmh65J/KxtoHhPQKWND/qnekZjquaukmSV/ZCRittk7a8Hesym9TFwYT/+Ti
	Z4en/nFGdfRivko+K4PTkoQS7c1Jh5o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=KVC9icqg;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf24.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792022064;
	b=Tc8UXz8mAHLkUx0cuptoP+ZF0F/WkJ7JASYPPJcmz8+vY0lluOLGc+IryTRCei20qPR45q
	88lPxCoti4ZlFmDrRrKdeTySYs4FuhGeXGR8zT3/EvCwR7E8qw2VKqFZ8UU+vL4k+7cHu1
	LJj+/pMoT0AsDPkroABlRrjrARIKQ7k=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E3EFB40E0497;
	Wed, 14 Oct 2026 23:54:20 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id l-Z3T2V8uaBz; Wed, 14 Oct 2026 23:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1792022056; bh=aBSAefliNrk3ebh4aSKUwcheBC1eSCHlIw0ty7Hc3FA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KVC9icqg+Bkd6Bx8Sh4kbtEYV01QU/kd2DV4hI8xE5f5bRF7uJkCJWMRhn9IAeU29
	 +4603uEKBLfuzgFFFvH5wEqe7NVQZV4d7Qh4yybEzGFfYs+fKBmFhRwODGleyC2R+o
	 9PPvDIoyMdgV/8UuGAntAsCZajrXMfmCWWkgOEPjDTl1E02ScIcbslrB76Mra7kq7s
	 dX5+Uo2pL8is+ZK74Tec9s9Pj1B7O0r3NVZrRh4MHBjIfU8DbY378IywoFbxUt9Fh1
	 65+WXn0QwHbtlEyzsG87Fhgc2yp7B7Lcuwp+YNyfgWm+qbsOIaMizqF9XWZpgWUD3W
	 izvKKUN43SZjHV0z/tfQ0HONWduiU7JPPJ8j6um5EGQlWl4VFcCank+AvrWid6JATv
	 BcfzlRlaTB94jGud8Beo0Z7Yh4conbenI3cQ61wgh8rnFlOQOqwk0pPflEh0yP/lnU
	 OUQ+gNR25zLOAnjrdBeaSUFs1OX/h9S2fC7gIQRsTk95ez/719zUEK5MHqdGnq7ycm
	 zaZgjz5NBRGEW04aEOll56xezUFhuWwJ7vdlUFTnp5AtGOtDj8RbqHKlzNMg3DigZZ
	 hz2q85Rxzn00PqrfD6AT23BV+zpCEtkbPvNqErFxNBDrxt/bAQAl0e51MIXMQ76T7/
	 XV41qop18yY1pEO63Uexn2Ak=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::3a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0851F40E02B0;
	Wed, 14 Oct 2026 23:53:59 +0000 (UTC)
Date: Wed, 14 Oct 2026 16:53:56 -0700
From: Borislav Petkov <bp@alien8.de>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: David Laight <david.laight.linux@gmail.com>,
	Rik van Riel <riel@surriel.com>, ljs@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	david@kernel.org, Mike Rapoport <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>,
	luizcap@redhat.com, pbonzini@redhat.com,
	Tal Zussman <tz2294@columbia.edu>,
	Matt Fleming <matt@readmodwrite.com>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <20261014235356.GBatAWFNsWaIA2HQ4M@fat_crate.local>
References: <ar/F6+OUzj8qQ8YC@pcnci.linuxbox.cz>
 <asAE3kLFDUx5v0Nw@gremlin>
 <asKdhWiJb3qXeopz@pcnci.linuxbox.cz>
 <bd8e9b01ad88cafb12da33331f32a1ce315f590b.camel@surriel.com>
 <20261005132113.43548696@pumpkin>
 <asP5xK4axiUk7jun@pcnci.linuxbox.cz>
 <aseMsMGpGPT/G548@pcnci.linuxbox.cz>
 <20261008182356.GBasffvDuTemTu1VUY@fat_crate.local>
 <20261009090042.39ba9c06@pumpkin>
 <aszH4vpXFAOQP1WG@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <aszH4vpXFAOQP1WG@pcnci.linuxbox.cz>
X-Stat-Signature: ypib8tf7goqhjawo8rht6np9mzr4k6d1
X-Rspam-User: 
X-Rspamd-Queue-Id: 78DB8180008
X-Rspamd-Server: rspam08
X-HE-Tag: 1792022063-112561
X-HE-Meta: U2FsdGVkX1/PGqT9H4tHxlU6C4+SgHFBoZchzoR4sCI08p+tDyGRBN7MPvcHHk6soLZh6ofGHyYkdTL1QNi67LiGGxeBjJWolUW6OXbxuFVVjwjyGDCrJ+Cz3PL2m2Y2YUKfweJzMysOp4qdyEve4J5AgVG1xHBhA9Blzs8k/cj3SkAgxwCkvJzOSdHEuMSFmJo1g46MYQovzkNaLudNi1MjK8zEvoq5dxRuy7Oh+2OP/V3ahlVz3xKAxP6WAdo5WG8vfHJlJyWhucdu8cawVh9LA2vyuxRmJDc/ddDjvhUAAU4Sx2VXkqwQS4Vz9mUg3+/hBMioT5XOrDtUYknO4FJIOkIiM0qNo4+8uqWtPfCL5wk9/esvqZbQBeDUwE5X+bJyVMXA/yG64ciz09bwXo69JXpKRoLS5hB9nzDnmn2Yxpf77t8JO44L11HwiTo5loFFgRYt0RU7J9+3cxhY5pJm/YjV1SQ6ahSBihb+m25O+nKoZlWMGkRascFlisbb+u/9jFqZdUD1joCFPyHlrm8YXTjsj3lASMb9SVAtbGULhjykbytadBuutFvHXxjQ6tr2Mu7x6Fx/58aJBlwFGPxvdMomEKfkZoBUsbQl4rurY8CivS9ZGO9OGp/xRnQ+O7H0MY2wgVHdyuFXBnFvxRsUpTTZdMwRFd8Y4F1PQJjvr13C6mSk97i6/t1NotM9BYHtgSbgzD7+2A+BeBKXAhZm2Jo3zZ3z+8AXMkmSgAa+IlAoJQGfIyer7ykxognmjR7cfMR8Ihc97GhlSAWw7R4lKhYIVYWGxMHIF/LGt/R5KzS8mu5K4pxc6wDBRS7f74wrVLJgTMfMfh8NjmObJDHeXNN+2tHDdlJvd6P52bJogoYvSB6w9ST5IUrlivpQU0yI8UzSkw9EXmiYR8b9w5ZgVJ5xGc2I5jN0MT0e3ZMe3vo7cddZFl4YryIUROLO0TADvg66t1zQ38ueVsV
 8GlKFpyz
 N7d20ECPro1viV1+U1k7giHque+dqNUoLgrhxTk1j9KR7Pu+59L87TEAeQmkC4OH3iBemVBSDhTWis5kyqs51BqsA3K627oXMWg6sM2LxJWwc+4rTnS1X1sEPlWEpnFytTA9qzIBnZruULHSxqDT2BF4LvRLthS5m1oX3Wa/PyG6wJOd263Vre0gc9nLGu6PgX961WzLY2nlO8Y02K4tFPTNp6Wyqvw6fzU1PqAQlf2XsxZzguUVN3H4zf5xZKXxezVjtm3TvvypMSlibo1DoRQjU20MkdKi0FGQtExiFicN/gFKalLclE2qXIjS7CpR62yDlVfgAsDSfJN2iHUr41sqAACEMd3yFAYGpk0s3Ydo4yr9h7tMFFe7MXzE5lcO9v5ncBpUo5VB1ibHlK2gMPuxJ7UjuoyFJrQGmlGA+DDztUWHq92k68J6nwzL5C6DDkqDGlLjDhVgSkhBJUpTWi1q9XpRVqP0zrkyjb4AO3mvm8No=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 01:43:30PM +0200, Nikola Ciprich wrote:
> Some more news.
>=20
> In the meantime, we=E2=80=99ve had the same crash on another of our own
> cluster nodes. This time it was booted with tlbi=3Dipi, so that
> didn=E2=80=99t help either, exactly as Borislav said.
>=20
> (Just a side note: it seems quite hard to check which TLB
> invalidation mechanism is in use. There is no message in dmesg,
> and invlpgb is deliberately not displayed in the /proc/cpuinfo flags,
> so apart from measuring with perf, I simply have to trust that
> the kernel parameter does what it should for my kernel release.)

Yeah, we probably should do something there. Maybe show it in /proc/cpuinfo=
 as
"tlbi" when enabled.

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpuf=
eatures.h
index f62944700975..44ecc82f2ca0 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -342,7 +342,7 @@
 #define X86_FEATURE_CLZERO		(13*32+ 0) /* "clzero" CLZERO instruction */
 #define X86_FEATURE_IRPERF		(13*32+ 1) /* "irperf" Instructions Retired Co=
unt */
 #define X86_FEATURE_XSAVEERPTR		(13*32+ 2) /* "xsaveerptr" Always save/res=
tore FP error pointers */
-#define X86_FEATURE_INVLPGB		(13*32+ 3) /* INVLPGB and TLBSYNC instruction=
s supported */
+#define X86_FEATURE_INVLPGB		(13*32+ 3) /* "tlbi" INVLPGB and TLBSYNC inst=
ructions supported */
 #define X86_FEATURE_RDPRU		(13*32+ 4) /* "rdpru" Read processor register a=
t user level */
 #define X86_FEATURE_WBNOINVD		(13*32+ 9) /* "wbnoinvd" WBNOINVD instructio=
n */
 #define X86_FEATURE_AMD_IBPB		(13*32+12) /* Indirect Branch Prediction Bar=
rier */

> So if I understand it correctly, we can now completely rule out
> an AMD firmware bug, right?
>=20
> Since I didn=E2=80=99t have anything else to try, and we started having
> crashes on our own cluster nodes, where I can be a bit bolder,
> I built 7.3-rc6, deployed it on two problematic AMD nodes, and
> started a migration torture loop.
>=20
> Over the weekend, there were ~70 migrations of ~160 VMs between
> those two nodes without a single issue.
>=20
> Today I upgraded both boxes to rc7 and started the migrations again.
>=20
> I can=E2=80=99t be sure yet, but it really seems the problems are gone in=
 7.3.
>=20
> The question is: what now? (I still think bisecting would be unreliable.)
>=20
> For those interested, I=E2=80=99ve tidied up the shared files a little and
> added some more content to https://storage.linuxbox.cz/index.php/s/6rcp8o=
WCGzAqPEY:

So I took a look. The one you added the sources for is this: 20261008-lbxv1f
and below is what I could decipher it to.

Long story short, I *think* that dentry pointer becomes funky:

        hlist_bl_for_each_entry_rcu(dentry, node, b, d_hash) {
                unsigned seq;

                /*
                 * The dentry sequence count protects us from concurrent
                 * renames, and thus protects parent and name fields.
                 *
                 * The caller must perform a seqcount check in order
                 * to do anything useful with the returned dentry.
                 *
                 * NOTE! We do a "raw" seqcount_begin here. That means that
                 * we don't wait for the sequence count to stabilize if it
                 * is in the middle of a sequence change. If we do the slow
                 * dentry compare, we will do seqretries until it is stable,
                 * and if we end up with a successful lookup, we actually
                 * want to exit RCU lookup anyway.
                 *
                 * Note that raw_seqcount_begin still *does* smp_rmb(), so
                 * we are still guaranteed NUL-termination of ->d_name.name.
                 */
                seq =3D raw_seqcount_begin(&dentry->d_seq);
					 ^^^^^^^^^^^^^^

Now, the $10^6 question is, do you have the crash dump still and if so, can
you figure out what the real address of that dentry is?

The wrong one is: 0xffffffff0c930020 so I'm guessing that 0 after the ffff's
should actually be 81-something as that's kernel memory.

Hmmm?

Thx.

[11402.940943] BUG: unable to handle page fault for address: ffffffff0c9300=
1c
[11402.942273] #PF: supervisor read access in kernel mode
[11402.943629] #PF: error_code(0x0000) - not-present page
[11402.945025] PGD 6d6f83a067 P4D 6d6f83b067 PUD 0=20
[11402.946469] Oops: Oops: 0000 [#1] SMP NOPTI
[11402.947950] CPU: 23 UID: 0 PID: 704950 Comm: servercare-moni Kdump: load=
ed Tainted: G            E       6.18.55lb9.01 #1 PREEMPT(voluntary)=20
[11402.951254] Tainted: [E]=3DUNSIGNED_MODULE
[11402.952913] Hardware name: ASUSTeK COMPUTER INC. RS720A-E12-RS12/K14PP-D=
24 Series, BIOS 1201 08/25/2023
[11402.956569] RIP: 0010:__d_lookup_rcu+0x4d/0xe0

ffffffff8165ae30 <__d_lookup_rcu>
		+0x4d =3D 0xffffffff8165ae7d

[11402.958452] Code: 48 8d 04 c2 f6 07 02 0f 85 a0 00 00 00 48 8b 10 48 89 =
d0 48 83 e0 fe 48 83 fa 01 77 0d e9 80 00 00 00 48 8b 00 48 85 c0 74 78 <44=
> 8b 58 fc 48 39 78 10 75 ee 48 83 78 08 00 74 e7 48 39 58 18 75

[11402.958452] Code: 48 8d 04 c2 f6 07 02 0f 85 a0 00 00 00 48 8b 10 48 89 =
d0 48 83 e0 fe 48 83 fa 01 77 0d e9 80 00 00 00 48 8b 00 48 85 c0 74 78 <44=
> 8b 58 fc 48 39 78 10 75 ee 48 83 78 08 00 74 e7 48 39 58 18 75

ffffffff8165ae6e:       77 0d                   ja     ffffffff8165ae7d <__=
d_lookup_rcu+0x4d>
ffffffff8165ae70:       e9 80 00 00 00          jmp    ffffffff8165aef5 <__=
d_lookup_rcu+0xc5>
ffffffff8165ae75:       48 8b 00                mov    (%rax),%rax
ffffffff8165ae78:       48 85 c0                test   %rax,%rax
ffffffff8165ae7b:       74 78                   je     ffffffff8165aef5 <__=
d_lookup_rcu+0xc5>
ffffffff8165ae7d:       44 8b 58 fc             mov    -0x4(%rax),%r11d

<--- here

that looks like:

struct dentry *__d_lookup_rcu(const struct dentry *parent,
=2E..

	                seq =3D raw_seqcount_begin(&dentry->d_seq);
			...

			#define raw_read_seqcount(s)                                            \
({                                                                      \
        unsigned __seq =3D seqprop_sequence(s);                           \

which is that unreadable gunk:

# ./include/linux/seqlock.h:227: SEQCOUNT_LOCKNAME(spinlock,     spinlock_t=
,      __SEQ_RT, spin)
#NO_APP
	movl	-4(%rax), %r11d	# MEM[(const volatile unsigned int *)node_49 + -4B], =
_25
# ./include/linux/seqlock.h:227: SEQCOUNT_LOCKNAME(spinlock,     spinlock_t=
,      __SEQ_RT, spin)

i.e., that dentry->d_seq _Generic selector pointer thing:

  seq =3D ({ ({ unsigned __seq =3D

        _Generic(*(&dentry->d_seq), seqcount_t:
                __seqprop_sequence, seqcount_raw_spinlock_t:
                __seqprop_raw_spinlock_sequence, seqcount_spinlock_t:
                __seqprop_spinlock_sequence, seqcount_rwlock_t:
                __seqprop_rwlock_sequence,  seqcount_mutex_t:
                __seqprop_mutex_sequence)(&dentry->d_seq);
  kcsan_atomic_next(1000); __seq; }) & ~1; });


ffffffff8165ae81:       48 39 78 10             cmp    %rdi,0x10(%rax)
ffffffff8165ae85:       75 ee                   jne    ffffffff8165ae75 <__=
d_lookup_rcu+0x45>
ffffffff8165ae87:       48 83 78 08 00          cmpq   $0x0,0x8(%rax)
ffffffff8165ae8c:       74 e7                   je     ffffffff8165ae75 <__=
d_lookup_rcu+0x45>
ffffffff8165ae8e:       48 39 58 18             cmp    %rbx,0x18(%rax)
ffffffff8165ae92:       75 e1                   jne    ffffffff8165ae75 <__=
d_lookup_rcu+0x45

All code
=3D=3D=3D=3D=3D=3D=3D=3D
   0:   48 8d 04 c2             lea    (%rdx,%rax,8),%rax
   4:   f6 07 02                testb  $0x2,(%rdi)
   7:   0f 85 a0 00 00 00       jne    0xad
   d:   48 8b 10                mov    (%rax),%rdx
  10:   48 89 d0                mov    %rdx,%rax
  13:   48 83 e0 fe             and    $0xfffffffffffffffe,%rax
  17:   48 83 fa 01             cmp    $0x1,%rdx
  1b:   77 0d                   ja     0x2a
  1d:   e9 80 00 00 00          jmp    0xa2
  22:   48 8b 00                mov    (%rax),%rax
  25:   48 85 c0                test   %rax,%rax
  28:   74 78                   je     0xa2
  2a:*  44 8b 58 fc             mov    -0x4(%rax),%r11d         <-- trappin=
g instruction

rax =3D ffffffff0c930020

  2e:   48 39 78 10             cmp    %rdi,0x10(%rax)
  32:   75 ee                   jne    0x22
  34:   48 83 78 08 00          cmpq   $0x0,0x8(%rax)
  39:   74 e7                   je     0x22
  3b:   48 39 58 18             cmp    %rbx,0x18(%rax)
  3f:   75                      .byte 0x75

Code starting with the faulting instruction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
   0:   44 8b 58 fc             mov    -0x4(%rax),%r11d
   4:   48 39 78 10             cmp    %rdi,0x10(%rax)
   8:   75 ee                   jne    0xfffffffffffffff8
   a:   48 83 78 08 00          cmpq   $0x0,0x8(%rax)
   f:   74 e7                   je     0xfffffffffffffff8
  11:   48 39 58 18             cmp    %rbx,0x18(%rax)
  15:   75                      .byte 0x75


[11402.964498] RSP: 0018:ff3eefdafcacfc40 EFLAGS: 00010292
[11402.966642] RAX: ffffffff0c930020 RBX: 000000061356452c RCX: 00000000000=
00006
[11402.968884] RDX: ffffffff0c930020 RSI: ff3eefdafcacfd70 RDI: ff2d1acd004=
09140
[11402.971167] RBP: ff3eefdafcacfda4 R08: 8080808080808080 R09: fefefefefef=
efeff
[11402.973512] R10: 0000303539343037 R11: 0000000000000004 R12: ff2d1acd8cb=
0b7e0
[11402.975915] R13: ff3eefdafcacfd70 R14: 0000000000000000 R15: 00000000000=
00000
[11402.978356] FS:  00007f757eaed640(0000) GS:ff2d1b89b5a42000(0000) knlGS:=
0000000000000000
[11402.980842] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[11402.983374] CR2: ffffffff0c93001c CR3: 00000004ba18e002 CR4: 00000000007=
71ef0
[11402.986004] PKRU: 55555554
[11402.988640] Call Trace:
[11402.991231]  <TASK>
[11402.993831]  lookup_fast+0x2b/0x100
[11402.996468]  walk_component+0x1f/0x150
[11402.999080]  link_path_walk+0x105/0x2a0
[11403.001714]  path_openat+0x99/0x2b0
[11403.004319]  ? srso_alias_return_thunk+0x5/0xfbef5
[11403.006983]  ? up_read+0x5a/0x90
[11403.009610]  ? srso_alias_return_thunk+0x5/0xfbef5
[11403.012250]  ? do_user_addr_fault+0x190/0x6a0
[11403.014927]  do_filp_open+0xd3/0x180
[11403.017635]  ? __pfx_kfree_link+0x10/0x10
[11403.020383]  ? srso_alias_return_thunk+0x5/0xfbef5
[11403.023097]  do_sys_openat2+0x8a/0xe0
[11403.025765]  __x64_sys_openat+0x69/0xa0
[11403.028424]  do_syscall_64+0x64/0xba0
[11403.031066]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[11403.033733] RIP: 0033:0x7f75816ff1e4
[11403.036336] Code: 24 20 eb 8f 66 90 44 89 54 24 0c e8 26 8c f8 ff 44 8b =
54 24 0c 44 89 e2 48 89 ee 41 89 c0 bf 9c ff ff ff b8 01 01 00 00 0f 05 <48=
> 3d 00 f0 ff ff 77 34 44 89 c7 89 44 24 0c e8 78 8c f8 ff 8b 44
[11403.044367] RSP: 002b:00007f757eaeb870 EFLAGS: 00000293 ORIG_RAX: 000000=
0000000101
[11403.047072] RAX: ffffffffffffffda RBX: 00007f757eaed5e0 RCX: 00007f75816=
ff1e4
[11403.049795] RDX: 0000000000080000 RSI: 00007f757edd90e2 RDI: 00000000fff=
fff9c
[11403.052470] RBP: 00007f757edd90e2 R08: 0000000000000000 R09: 00000000000=
00000
[11403.055070] R10: 0000000000000000 R11: 0000000000000293 R12: 00000000000=
80000
[11403.057594] R13: 00007f758187fe50 R14: 00007f75818e5040 R15: 00000000000=
00001
[11403.060096]  </TASK>
[11403.062521] Modules linked in: vhost_net(E) vhost(E) vhost_iotlb(E) tap(=
E) tun(E) ceph(E) libceph(E) cts(E) krb5enc(E) authenc(E) camellia_aesni_av=
x2(E) camellia_aesni_avx_x86_64(E) camellia_x86_64(E) camellia_generic(E) c=
mac(E) krb5(E) dns_resolver(E) netfs(E) nf_tables(E) tcp_diag(E) udp_diag(E=
) inet_diag(E) netconsole(E) sctp(E) ip6_udp_tunnel(E) udp_tunnel(E) rfkill=
(E) nfnetlink_cttimeout(E) nfnetlink(E) openvswitch(E) nf_conncount(E) nf_n=
at(E) nsh(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) sunrpc(E) =
kvm_amd(E) sr_mod(E) kvm(E) irqbypass(E) amd_atl(E) cdrom(E) sd_mod(E) amd6=
4_edac(E) wmi_bmof(E) cdc_ether(E) acpi_ipmi(E) sg(E) edac_mce_amd(E) acpi_=
cpufreq(E) usbnet(E) pcspkr(E) ipmi_si(E) mii(E) ipmi_ssif(E) i2c_piix4(E) =
ipmi_devintf(E) vfat(E) i2c_smbus(E) k10temp(E) ipmi_msghandler(E) wmi(E) f=
at(E) i2c_core(E) sch_fq_codel(E) fuse(E) ext4(E) crc16(E) mbcache(E) jbd2(=
E) raid1(E) usb_storage(E) nvme(E) ahci(E) libahci(E) mpt3sas(E) raid_class=
(E) xhci_pci(E) nvme_core(E) ghash_clmulni_intel(E) libata(E)
[11403.062611]  scsi_transport_sas(E) i40e(E) nvme_keyring(E) libie(E) nvme=
_auth(E) xhci_hcd(E) sp5100_tco(E) libie_adminq(E) hkdf(E) dm_mod(E) dax(E)=
 aesni_intel(E)
[11403.100478] CR2: ffffffff0c93001c


--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

