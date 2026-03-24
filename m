Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33808F532E5
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 07:23:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A160A6B0099; Tue, 24 Mar 2026 03:23:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ED3B6B009E; Tue, 24 Mar 2026 03:23:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 929D86B00A0; Tue, 24 Mar 2026 03:23:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 836FF6B0099
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 03:23:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 627A4CAD74
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:23:08 +0000 (UTC)
X-FDA: 84580115256.29.E289AC4
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf27.hostedemail.com (Postfix) with ESMTP id 47F5A4000F
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:23:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=NLDM5yrF;
	spf=pass (imf27.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774336986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aCvtUfHhPT8xNOs2dDx7Ez7/7fbw+3cZJxP5S8bI/co=;
	b=g+aX55Zofx9eS3zrDvY4uwArS3eIrQHGIRdCsuKxbqOlOBMyQB+/J9lfpLjXpL6T+N/oBH
	YL84KHbc0EzEqDrf+ZElo8kji/aYs34lmmOiupC75LyWf8lQBba9G8FAXQfYuUDbMdaQI+
	C/e4A4Tt3B80Qz9edpWE4msxxiAWOI8=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=NLDM5yrF;
	spf=pass (imf27.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774336986; a=rsa-sha256;
	cv=pass;
	b=HDhtLbEvWlpqMLsqOTWc1ofquPVP3Hh7Ip17yMDt2bDOQpqMQNwhRgzQMieDmAhoTLO85Q
	ww9vepDvU9cwivou2CN36GH5S+wIn+ReRfflAygbC1vl4Z0YTEHIee7BnR6U2+KFZmZu02
	Rzy/Wh0SCEMZW5R1hBKy8RtwXJR+Emo=
ARC-Seal: i=1; a=rsa-sha256; t=1774336954; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=eRuUJv0Gbnr2OB9G44E+HGC/pViBj49DoluAQK1TVWWh3CzOA+rIL/zPFGlFZ9Li7HWRYzWkojzS/tJop278oZtp1I8cttsw/V7eAdBipRLlFyw0xCf1ytGMTsEz3j27tMCUW8J6hh8opxTXt25gZwVng08+7l6e8eJPR1c0k4k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774336954; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=aCvtUfHhPT8xNOs2dDx7Ez7/7fbw+3cZJxP5S8bI/co=; 
	b=jRYvSHrKoIISv3MawPjrt8MjyVAreHPTi5VPrHe/B5CEAE03ytyxtn8qa9eNFPKyJN5xziaSS6hmnJZqEIY9IfiDjdz5mvk1VCZvg69M7tXgYbdm52JNQXikKheZ+WkW6Ahf6/SPy6ZWKFvnMA8od+kNOVdjWUrtKgnJPnSmEDQ=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774336954;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=aCvtUfHhPT8xNOs2dDx7Ez7/7fbw+3cZJxP5S8bI/co=;
	b=NLDM5yrF0NJd7KzAX4gHw0oUi2Rv34xNrQjpmpbvba5sLjA0mkpk02GZydPhDfUX
	zB+C/lma0ReBSOihgI5Lcm+8vIJ2s6JNAKXMPsKOGe/865KpxeBPGa1Yk50m+idxUzG
	soE+z5hnw8kxLMjIX364sA0rillGukxwVRQFwgKE=
Received: by mx.zoho.eu with SMTPS id 1774336951189256.58536417741925;
	Tue, 24 Mar 2026 08:22:31 +0100 (CET)
Date: Tue, 24 Mar 2026 07:22:28 +0000
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>
CC: akpm@linux-foundation.org, damon@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v3_2/2=5D_mm/damon/core=3A_eliminate_hot-?=
 =?US-ASCII?Q?path_integer_division_in_damon=5Fmax=5Fnr=5Faccesses=28=29?=
User-Agent: Thunderbird for Android
In-Reply-To: <20260324071908.89152-1-sj@kernel.org>
References:  <20260324071908.89152-1-sj@kernel.org>
Message-ID: <F25B7F53-2D07-4761-A400-E5130A023716@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
X-Rspam-User: 
X-Stat-Signature: pt1u5q9o6k1jtrs8ymg6em48ua48tioc
X-Rspamd-Queue-Id: 47F5A4000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1774336986-157478
X-HE-Meta: U2FsdGVkX1+AHRUZ/uVfku61UgPj1XUDJLQR421Pf0PnHVbXCXTxbMQWgl+/w0B3wobV26RCBK/vEFf0SIcD/uZULKvFAZBLzIsBKsWVaOVkVxSGmFUoT83jLw3kckZU019r+KzR9trVx5llE7m024h4OsB1om2UGZVS9JJuCxL27XmbrCKHawIj5OMwrQP1Q2YcGq94rDpZXHdtxdRKAT/zXW3k9DedCdR6ekdbNbvuxjcB8bYUSS/ftSo6I4j5vuyRn77i6DSQT4wftdAvrAIhdKGVLdio07pL+9TQK0BHN0LDt8yr6JeKaNmu1kC631E/DwTc7SyfhudKOwfG5IScygx4fN0rgyfY9nzNlC2oomYUNSTTpZFM9RmZnRZhL62BemJzk6rm2yd2I+NSPWNN+OS9QwIGRYB+Q15b0ATM1H9+7St4nCR77/8jegsW2WRT6AfSrRwXpWc5Tvk8ZQ2l4XnUJWtOroNhyvgbBIbC5mPKaTwQTo+UqfbKuVo/yCCd3Vk/wA9nyAVQC7ahtNRXgrxzRWeBl6QqynWJQjRvVyldLrV03kxlZ1bcBSfzMZG2hTvU8O19otZ2nO3brXmGDN2CQN9ju38B3jLeCyQMVzBdhjkEi/2gOfddHGLdhZR+JCGimlo89fJYAbFGomALNp+rgtCjsjGy6AM/eBR3uFishbplhWo4/1JHVi73/L7OJC6a2XrwauK1FPABoJkTlX9lNmNsBXyVIPKsSjS0ZPEOnbhGv9cTLJyky2nvqEo6GGxJh4IoWzIswHXBaP/b9Mkz04n20S4PU1CQ+XS56HNKE/Ya0b+16MuTTPVP1g598twTSrIkFbNM7Pd19+D+tRip2oMQxnSduZ4dxZLvlMJXk0xjYfvxuJnZMsxfBRKcoGf1Bckho6IesboKzkIoiWf8rLg1xvaHMgb4p04aDBiAJsZ0tFeqMG425/hZxykB79ekwzbd0aqZ0HY
 n8C1+bAI
 q6JN3G3Akk7xVd2yydO9UBSISrLZF44M+jv9c8Lh4V8tqJci+2gMT6bGSxFYDnpzftG92tzNDbqL4JPjfd0JDkzZSmQKRVT4jfzXzXM9g56y4LDMSo5KP58N3HmAY5Po+0EbjD1HD1mkr++RqBLFMJIWOlmsfS3bV19jmTRIDMM6CFLdbS0fUKCeF/FqIzBwVp6IdTcMR/LVV2griagUVDF0rjx9uTaQkWWXlUQ8iThjWjFMIQomyOq9z7kviER1yZ76O9Ra/4RoHqdZocTUJ5HYLXglz852KiohgJBJT2wKhhiQ7lcwRaKiSEaTXzl4Pik9Z3q6lOOBKG3ZCE39U0MGeMZOQEV4Gr22B5uihdxjP5YjbQtyDVGwGqzM+g6akmfU+k4YqQzJ6YVuj+t8BRxGesgrIJ5ipDN28pSwywcpHI/zClrPXFTY18XFHrjgR5IxmQUPWnJZuJagrXSm42V1g1wfhZt1YBaMS2t4JPh2PsfrIMYGWN0Ige2CUHCDZInUUkMbATEYRJARS9Zlc1VZviCS8WD3oZWmuvpifRPhQxkVJdPPmXzPBCzJ/A23w7b2IwLUqD4xmhfFECrT+6KbjVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 24 March 2026 07:19:08 GMT, SeongJae Park <sj@kernel=2Eorg> wrote:
>On Sun, 22 Mar 2026 21:43:25 +0000 Josh Law <objecting@objecting=2Eorg> w=
rote:
>
>> Hardware integer division is slow=2E The function damon_max_nr_accesses=
(),
>> which is called very frequently (e=2Eg=2E, once per region per sample
>> interval inside damon_update_region_access_rate), performs an integer
>> division: attrs->aggr_interval / attrs->sample_interval=2E
>>=20
>> However, the struct damon_attrs already caches this exact ratio in the
>> internal field aggr_samples (since earlier commits)=2E We can eliminate
>> the hardware division in the hot path by simply returning aggr_samples=
=2E
>>=20
>> This significantly reduces the CPU cycle overhead of updating the acces=
s
>> rates for thousands of regions=2E
>>=20
>> Signed-off-by: Josh Law <objecting@objecting=2Eorg>
>> ---
>>  include/linux/damon=2Eh | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>=20
>> diff --git a/include/linux/damon=2Eh b/include/linux/damon=2Eh
>> index 6bd71546f7b2=2E=2E438fe6f3eab4 100644
>> --- a/include/linux/damon=2Eh
>> +++ b/include/linux/damon=2Eh
>> @@ -960,8 +960,7 @@ static inline bool damon_target_has_pid(const struc=
t damon_ctx *ctx)
>>  static inline unsigned int damon_max_nr_accesses(const struct damon_at=
trs *attrs)
>>  {
>>  	/* {aggr,sample}_interval are unsigned long, hence could overflow */
>> -	return min(attrs->aggr_interval / attrs->sample_interval,
>> -			(unsigned long)UINT_MAX);
>> +	return min_t(unsigned long, attrs->aggr_samples, UINT_MAX);
>>  }
>
>I just found this patch causes below divide-by-zero when
>tools/testing/selftets/damon/sysfs=2Epy is executed=2E
>
>'''
>[   42=2E462039] Oops: divide error: 0000 [#1] SMP NOPTI
>[   42=2E463673] CPU: 4 UID: 0 PID: 2044 Comm: kdamond=2E0 Not tainted 7=
=2E0=2E0-rc4-mm-new-damon+ #354 PREEMPT(full)
>[   42=2E465193] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), B=
IOS 1=2E16=2E3-debian-1=2E16=2E3-2 04/01/2014
>[   42=2E466590] RIP: 0010:damon_set_attrs (mm/damon/core=2Ec:769 (discri=
minator 1) mm/damon/core=2Ec:775 (discriminator 1) mm/damon/core=2Ec:786 (d=
iscriminator 1) mm/damon/core=2Ec:827 (discriminator 1) mm/damon/core=2Ec:8=
97 (discriminator 1))
>[   42=2E467287] Code: 48 39 c5 0f 84 dd 00 00 00 41 bb 59 17 b7 d1 48 8b=
 43 10 4c 8d 43 10 48 8d 48 e0 49 39 c0 75 5b e9 b0 00 00 00 8b 41 18 31 d2=
 <41> f7 f6 41 89 c5 69 c2 10 27 00 00 31 d2 45 69 ed 10 27 00 00 41
>All code
>=3D=3D=3D=3D=3D=3D=3D=3D
>   0:   48 39 c5                cmp    %rax,%rbp
>   3:   0f 84 dd 00 00 00       je     0xe6
>   9:   41 bb 59 17 b7 d1       mov    $0xd1b71759,%r11d
>   f:   48 8b 43 10             mov    0x10(%rbx),%rax
>  13:   4c 8d 43 10             lea    0x10(%rbx),%r8
>  17:   48 8d 48 e0             lea    -0x20(%rax),%rcx
>  1b:   49 39 c0                cmp    %rax,%r8
>  1e:   75 5b                   jne    0x7b
>  20:   e9 b0 00 00 00          jmp    0xd5
>  25:   8b 41 18                mov    0x18(%rcx),%eax
>  28:   31 d2                   xor    %edx,%edx
>  2a:*  41 f7 f6                div    %r14d            <-- trapping inst=
ruction
>  2d:   41 89 c5                mov    %eax,%r13d
>  30:   69 c2 10 27 00 00       imul   $0x2710,%edx,%eax
>  36:   31 d2                   xor    %edx,%edx
>  38:   45 69 ed 10 27 00 00    imul   $0x2710,%r13d,%r13d
>  3f:   41                      rex=2EB
>
>Code starting with the faulting instruction
>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>   0:   41 f7 f6                div    %r14d
>   3:   41 89 c5                mov    %eax,%r13d
>   6:   69 c2 10 27 00 00       imul   $0x2710,%edx,%eax
>   c:   31 d2                   xor    %edx,%edx
>   e:   45 69 ed 10 27 00 00    imul   $0x2710,%r13d,%r13d
>  15:   41                      rex=2EB
>[   42=2E470046] RSP: 0018:ffffd25c4586bcb0 EFLAGS: 00010246
>[   42=2E470818] RAX: 0000000000000000 RBX: ffff891346919400 RCX: ffff891=
3502dd040
>[   42=2E471923] RDX: 0000000000000000 RSI: ffff891348527600 RDI: ffff891=
344d94400
>[   42=2E472972] RBP: ffff891344d94598 R08: ffff891346919410 R09: 0000000=
000000000
>[   42=2E474028] R10: 0000000000000000 R11: 00000000d1b71759 R12: 0000000=
000000014
>[   42=2E475104] R13: ffff891348527778 R14: 0000000000000000 R15: ffff891=
348527798
>[   42=2E476191] FS:  0000000000000000(0000) GS:ffff89149efd8000(0000) kn=
lGS:0000000000000000
>[   42=2E477375] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>[   42=2E478235] CR2: 000000003a84f080 CR3: 000000004a824000 CR4: 0000000=
0000006f0
>[   42=2E479291] Call Trace:
>[   42=2E479670]  <TASK>
>[   42=2E480044]  damon_commit_ctx (mm/damon/core=2Ec:1538)
>[   42=2E480660]  damon_sysfs_commit_input (mm/damon/sysfs=2Ec:2153 mm/da=
mon/sysfs=2Ec:2181)
>[   42=2E481389]  kdamond_call (mm/damon/core=2Ec:3186)
>[   42=2E482492]  kdamond_fn (mm/damon/core=2Ec:3428)
>[   42=2E483041]  ? kthread_affine_node (kernel/kthread=2Ec:377)
>[   42=2E483766]  ? kfree (include/linux/kmemleak=2Eh:50 mm/slub=2Ec:2610=
 mm/slub=2Ec:6165 mm/slub=2Ec:6483)
>[   42=2E484257]  ? __pfx_kdamond_fn (mm/damon/core=2Ec:3368)
>[   42=2E484855]  ? __pfx_kdamond_fn (mm/damon/core=2Ec:3368)
>[   42=2E485459]  kthread (kernel/kthread=2Ec:436)
>[   42=2E485959]  ? __pfx_kthread (kernel/kthread=2Ec:381)
>[   42=2E486524]  ret_from_fork (arch/x86/kernel/process=2Ec:164)
>[   42=2E487105]  ? __pfx_kthread (kernel/kthread=2Ec:381)
>[   42=2E487668]  ret_from_fork_asm (arch/x86/entry/entry_64=2ES:258)
>[   42=2E488304]  </TASK>
>'''
>
>That's because damon_commit_ctx() is called to a context that just genera=
ted
>using damon_new_ctx(), which doesn't set the aggr_samples=2E  After apply=
ing
>below change, the divide-by-zero is gone=2E
>
>'''
>--- a/mm/damon/core=2Ec
>+++ b/mm/damon/core=2Ec
>@@ -676,6 +676,7 @@ struct damon_ctx *damon_new_ctx(void)
>        ctx->attrs=2Esample_interval =3D 5 * 1000;
>        ctx->attrs=2Eaggr_interval =3D 100 * 1000;
>        ctx->attrs=2Eops_update_interval =3D 60 * 1000 * 1000;
>+       ctx->attrs=2Eaggr_samples =3D 20;
>
>        ctx->passed_sample_intervals =3D 0;
>        /* These will be set from kdamond_init_ctx() */
>'''
>
>Also, kunit crashes like below=2E
>
>'''
>$ =2E/tools/testing/kunit/kunit=2Epy run --kunitconfig mm/damon/tests/
>[00:07:19] Configuring KUnit Kernel =2E=2E=2E
>[00:07:19] Building KUnit Kernel =2E=2E=2E
>Populating config with:
>$ make ARCH=3Dum O=3D=2Ekunit olddefconfig
>Building with:
>$ make all compile_commands=2Ejson scripts_gdb ARCH=3Dum O=3D=2Ekunit --j=
obs=3D8
>[00:08:11] Starting KUnit Kernel (1/1)=2E=2E=2E
>[00:08:11] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>Running tests with:
>$ =2Ekunit/linux kunit=2Eenable=3D1 mem=3D1G console=3Dtty kunit_shutdown=
=3Dhalt
>[00:08:11] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D damo=
n (28 subtests) =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>[00:08:11] [PASSED] damon_test_target
>[00:08:11] [PASSED] damon_test_regions
>[00:08:11] [PASSED] damon_test_aggregate
>[00:08:11] [PASSED] damon_test_split_at
>[00:08:11] [PASSED] damon_test_merge_two
>[00:08:11] [PASSED] damon_test_merge_regions_of
>[00:08:11] [PASSED] damon_test_split_regions_of
>[00:08:11] [PASSED] damon_test_ops_registration
>[00:08:11] [PASSED] damon_test_set_regions
>[00:08:11] [ERROR] Test: damon: missing expected subtest!
>[00:08:11] Kernel panic - not syncing: Kernel mode signal 4
>'''
>
>It can run without the error after below changes are applied:
>
>'''
>--- a/mm/damon/tests/core-kunit=2Eh
>+++ b/mm/damon/tests/core-kunit=2Eh
>@@ -514,6 +514,8 @@ static void damon_test_nr_accesses_to_accesses_bp(str=
uct kunit *test)
>                =2Eaggr_interval =3D ((unsigned long)UINT_MAX + 1) * 10
>        };
>
>+       attrs=2Eaggr_samples =3D attrs=2Eaggr_interval / attrs=2Esample_i=
nterval;
>+
>        /*
>         * In some cases such as 32bit architectures where UINT_MAX is
>         * ULONG_MAX, attrs=2Eaggr_interval becomes zero=2E  Calling
>@@ -532,7 +534,8 @@ static void damon_test_nr_accesses_to_accesses_bp(str=
uct kunit *test)
> static void damon_test_update_monitoring_result(struct kunit *test)
> {
>        struct damon_attrs old_attrs =3D {
>-               =2Esample_interval =3D 10, =2Eaggr_interval =3D 1000,};
>+               =2Esample_interval =3D 10, =2Eaggr_interval =3D 1000,
>+               =2Eaggr_samples =3D 100,};
>        struct damon_attrs new_attrs;
>        struct damon_region *r =3D damon_new_region(3, 7);
>
>@@ -544,19 +547,24 @@ static void damon_test_update_monitoring_result(str=
uct kunit *test)
>        r->age =3D 20;
>
>        new_attrs =3D (struct damon_attrs){
>-               =2Esample_interval =3D 100, =2Eaggr_interval =3D 10000,};
>+               =2Esample_interval =3D 100, =2Eaggr_interval =3D 10000,
>+               =2Eaggr_samples =3D 100,};
>        damon_update_monitoring_result(r, &old_attrs, &new_attrs, false);
>        KUNIT_EXPECT_EQ(test, r->nr_accesses, 15);
>        KUNIT_EXPECT_EQ(test, r->age, 2);
>
>        new_attrs =3D (struct damon_attrs){
>-               =2Esample_interval =3D 1, =2Eaggr_interval =3D 1000};
>+               =2Esample_interval =3D 1, =2Eaggr_interval =3D 1000,
>+               =2Eaggr_samples =3D 1000,
>+       };
>        damon_update_monitoring_result(r, &old_attrs, &new_attrs, false);
>        KUNIT_EXPECT_EQ(test, r->nr_accesses, 150);
>        KUNIT_EXPECT_EQ(test, r->age, 2);
>
>        new_attrs =3D (struct damon_attrs){
>-               =2Esample_interval =3D 1, =2Eaggr_interval =3D 100};
>+               =2Esample_interval =3D 1, =2Eaggr_interval =3D 100,
>+               =2Eaggr_samples =3D 100,
>+       };
>        damon_update_monitoring_result(r, &old_attrs, &new_attrs, false);
>        KUNIT_EXPECT_EQ(test, r->nr_accesses, 150);
>        KUNIT_EXPECT_EQ(test, r->age, 20);
>'''
>
>Josh, could you please also take a look if these fixups are sufficient?  =
And
>once the sufficient fixes are found from your side, could you please post=
 a new
>version of this patch after applying the fixees?  Also, please drop my
>Reviewed-by: from the new version=2E  I will review it again=2E
>
>
>Thanks,
>SJ
>
>[=2E=2E=2E]


Aw, I didnt notice that, I'm so sorry, I'll fix this soon

V/R


Josh Law

