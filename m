Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C4EE606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 10:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YFmecJJZ
Received: by kanga.kvack.org (Postfix)
	id 5BACA6B0682; Tue, 27 Oct 2026 06:11:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56C3B6B0683; Tue, 27 Oct 2026 06:11:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45A0D6B0684; Tue, 27 Oct 2026 06:11:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1CD486B0682
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:11:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9088414096A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:11:00 +0000 (UTC)
X-FDA: 85367987880.24.271A917
Received: from mta0.migadu.com (out-221.mta0.migadu.com [91.218.175.221])
	by imf07.hostedemail.com (Postfix) with ESMTP id 773234000A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:10:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YFmecJJZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.221 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793095858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D1lqTZozMscar2SRArydDD07wjY6fFTz+QkMJLLtggA=;
	b=yBi1DF6eceDBXGszaFWnUkvZtU41Mwlqo0cXNpbcBH05/PwMfCh63uK+fqIdnWtqMSum7C
	FwpKDinGi1ik9YWQ8iFggPCNctP4lcb0vkPbtg7sS73nYSyU4F9ifKI44wPS6Hn2IbXKlu
	qNJB04PjOodverP6HHHbXWUsoT3lsEk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YFmecJJZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.221 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793095858;
	b=2cOU96ycSdwfJLnGkpxqrnKt0htGlAuQSwzjwYlhVU69lUhCYI1MNOsNQCql53i9vE+sX4
	abgN/+TAUJgkAVA2Dr3EiejeHhNcNqV1jg2HI2hEGceoccHAx7Mxy5RpfU6P3oX2RJ18jK
	eJrZ4eBNT395ZzAtKXlQvJEOVJwcQrU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7mCns8oF/JGvEa3tDBNQgrUGs+q1oTADhXwFuSXq1t8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793095857; v=1; x=1793700657;
 b=YFmecJJZKeHA01c886mlqLR/nZN8iGpB+vgeMniwilAo867sOLNn89XRo7kCb5lUC1Q7dafY
 fE/HqpW3Hyvy3QlLbemmwW0Gx7jcBURRR5mpsgCY9K6ZtNBp8GISyKMBiw8yaHC3dXMRazOf+qE
 zkm8+zqaOMKPq5gUXv1cB0Ek=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id ffb86d557cbfa937;
	Tue, 27 Oct 2026 10:10:56 +0000
X-Mizu-Trace-ID: ffb86d557cbfa937
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 05/16] hugetlbfs: enforce F_SEAL_EXEC in setattr
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <ed59aa45-0ce8-4e5b-8a19-b5323fbe7864@kernel.org>
Date: Tue, 27 Oct 2026 18:10:34 +0800
Cc: sashiko-reviews@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Gregory Price <gourry@gourry.net>,
 Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>,
 Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lukas Czerner <lczerner@redhat.com>,
 Carlos Maiolino <cmaiolino@redhat.com>,
 Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>,
 Daniel Verkamp <dverkamp@chromium.org>,
 Jeff Xu <jeffxu@google.com>,
 Oscar Salvador <osalvador@suse.de>,
 David Stevens <stevensd@chromium.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>,
 Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 linux-mm@kvack.org,
 Eva Kurchatova <eva.kurchatova@virtuozzo.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C1C8137C-D05D-440C-B143-4B5371624598@linux.dev>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-5-703206d5fa0c@kernel.org>
 <sashiko-outbox-186003@kernel.org>
 <ed59aa45-0ce8-4e5b-8a19-b5323fbe7864@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 773234000A
X-Stat-Signature: e517mg7a49hkosqab6zabpktr8sxxwpf
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793095858-992981
X-HE-Meta: U2FsdGVkX1+x2h7b0hUIKkKYuS/M00zNumIIh0x+nr4dW7/YMfCC/thDkbwa01ch3Q2tdRXWeJSvGIoivmjz9maIRetFoqNOsWvSm+cF2N5wH9/qlwXv86RLEmuK0UdDmYfZozxyvLbpfK+ebh/nOIabSSHO36UQn08FwcNumobRMSxHGMvCzgs7fm0ofVvRjjDWOv96mpMzoNpo7Ai+rzfxPEoorywWsmHPYzjxWlcksVRRZA3OFH9UH3BQV3JLohg7/1gnTL1yAyDQEKlbnUq37uY07EY+J9kTGSIBDVqTWKZU6+MKfgi69yWIi+Q1S24mfkhzMD/tGogFr68Y4VfR1KS663wcJjlD/2WHavsTI+J2LcJNeY0/2Qem1Wxha54fpY65P93QqwZDscLuAPOLR75PPo+qwU7Qokk3wd8wjPt/Kzf2Vais/Y6R2/LHm7dQ1BX0Oz2XEPGg9pvBkinfytXuQR23k8dc2Ji1CWIaPkHc4rUy29K+rikEKMQtae+em1E8iwRy0jnj7UkmOTNDtuDdGnEQLCHV7QYhRTjQaAo/v23yvEU9hMcN1FDQJY4OJQTLLMxBzhCgTBQ52LxCWHPLrfcippt4k5iNq13OI1nA9N0zNcXLpZMAJ5+1y9xHpE/+2wg37XQcbcUZZNPNNLjGG5hDNVv8T+kSMa+iF8C08FeYPMCG1q8oFmAULTdDsJYyyDoaGrfLdqCulrLrhp3hMNchpylyrRIuweWkUjeOeoGMv3+f2LRXO+tcIVdQVikEspl/97VgTexoYglGKeNR4WoCufmIn70xtj+VK+T+XuE40uvP/uaB/AzRC8tXU1RBVPLpv3drGJyw9wEcMceSCjfoPnEv1Z5t9Ng/Uvp7CdpD6R0sHtIUcrGQtGHjrVlDxB/RNHZ7JYeIOCTV16VNSOi6NbU0KLguqU/2UG4OryGAYXIL1vAK3spIM3cLeoOvC7bX+8gUoHn
 0pj579Zx
 AnQ7TsjQaPRaVL7gMO1TQ3QHvo+BPvD9+7WmAJWThGPJM0JuW58HAvj6lZGXiB915yRY9yvoAZjgyFvDtXXMMlDAvnsAHUm5mFtZBg2J//83aR+efRfrz5y5XKrWZ74OXdKeyzccvdqlRMd9FZq9GR94lJD6wo1dMFkwVlDuAo+JHzPGM5u/j4pn01qNC0Dy9XEPmVOhYrq8nFLL8yNR4YgHbb9vQvPVAQiicWFggf00O7lyouOCj1j+MCYfbX7J5w5L6juduOitV5iBUq7lHIBUOCECKIecyw56L53DP1UARWrFhBpZar/fhRkhrPZ5dABcG1usDSpSM6RP0UZVKtlkdiR8Jom2uIyqJsEsSI6UST4XhwdLxxWtCxpIrVTSiPo6h3XB6gmaaOhOfNNd3M+lkKu9u2yyqkOPusCIFI7BAX0S0Ex/HlRb1rhlIiTKjHwen6MMOqx20hip351i24foFkEANKoaW1cpurlfvN7KwBwVLq3q/xCVLnCyow2ciHxj77m/8QbRtGTGuGAge+r68SKKmo9NrGFGq3+qrz7NiFes=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 27, 2026, at 17:51, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 10/27/26 03:22, sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found 1 potential =
issue(s) to consider:
>> - [Medium] hugetlbfs: uninitialized info->seals read in =
hugetlbfs_setattr() on root dir
>> --
>>=20
>> commit dfab7a0d71278312f805e82ce52518a8ea2f538d
>> Author: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
>>=20
>> hugetlbfs: enforce F_SEAL_EXEC in setattr
>>=20
>> This patch updates hugetlbfs_setattr() to call =
memfd_check_seals_mode() when
>> ATTR_MODE is set so that fchmod() cannot modify execute bits on a =
hugetlbfs
>> memfd sealed with F_SEAL_EXEC.
>>=20
>> Link: =
https://patch.msgid.link/20260629180247.2343229-1-eva.kurchatova@virtuozzo=
.com
>>=20
>>> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
>>> index 6656807ce4377..7f5c3962b5d56 100644
>>> --- a/fs/hugetlbfs/inode.c
>>> +++ b/fs/hugetlbfs/inode.c
>>=20
>> [ ... ]
>>=20
>>> @@ -841,6 +842,13 @@ static int hugetlbfs_setattr(const struct =
mnt_idmap *idmap,
>>> if (error)
>>> return error;
>>>=20
>>> + if (ia_valid & ATTR_MODE) {
>>> + error =3D memfd_check_seals_mode(info->seals, inode->i_mode,
>>> +       attr->ia_mode);
>>> + if (error)
>>> + return error;
>>> + }
>>=20
>> [Severity: Medium]
>> Can this read uninitialized or stale slab memory from info->seals =
when
>> chmod() is called on a hugetlbfs root directory?
>>=20
>> hugetlbfs_dir_inode_operations wires .setattr to hugetlbfs_setattr(). =
Unlike
>> hugetlbfs_get_inode(), which sets info->seals =3D F_SEAL_SEAL,
>> hugetlbfs_get_root() allocates the root directory inode via =
new_inode() ->
>> hugetlbfs_alloc_inode() without initializing =
HUGETLBFS_I(inode)->seals:
>>=20
>> fs/hugetlbfs/inode.c:hugetlbfs_get_root() {
>> 	inode =3D new_inode(sb);
>> 	if (inode) {
>> ...
>> 		inode->i_op =3D &hugetlbfs_dir_inode_operations;
>> 		inode->i_fop =3D &simple_dir_operations;
>> 		HUGETLBFS_I(inode)->resv_map =3D NULL;
>> 		/* directory inodes start off with i_nlink =3D=3D 2 (for =
"." entry) */
>> 		inc_nlink(inode);
>> 		lockdep_annotate_inode_mutex_key(inode);
>> 	}
>> 	return inode;
>> }
>>=20
>> Because hugetlbfs_inode_cachep uses the init_once() slab constructor, =
which
>> only calls inode_init_once(&ei->vfs_inode), newly allocated or =
recycled
>> hugetlbfs_inode_info objects are not zeroed on allocation.
>>=20
>> Previously, hugetlbfs_setattr() only checked info->seals under =
ATTR_SIZE,
>> which is not reachable on directories. With the new ATTR_MODE check, =
changing
>> any execute/search bit on the mountpoint root directory reads =
info->seals
>> and can fail with -EPERM if the F_SEAL_EXEC bit is set in =
uninitialized
>> memory or left over from a previously freed sealed hugetlb memfd.
>>=20
>> Should hugetlbfs_get_root() also initialize HUGETLBFS_I(inode)->seals =
=3D
>> F_SEAL_SEAL?
>=20
> Shouldn't we just skip the check for directories?
>=20
>=20
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 7f5c3962b5d56..293c7965f4894 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -842,7 +842,7 @@ static int hugetlbfs_setattr(const struct =
mnt_idmap *idmap,
>        if (error)
>                return error;
>=20
> -       if (ia_valid & ATTR_MODE) {
> +       if (S_ISREG(inode->i_mode) && (ia_valid & ATTR_MODE)) {
>                error =3D memfd_check_seals_mode(info->seals, =
inode->i_mode,
>                                               attr->ia_mode);
>                if (error)
>=20
> Because sealing of directories does not apply.
>=20
> Thoughts?

Make sense to me.

Thanks,
Muchun

>=20
> --=20
> Cheers,
>=20
> David


