Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2CA160A380A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KYznopac
Received: by kanga.kvack.org (Postfix)
	id 093256B0A29; Thu, 22 Oct 2026 19:27:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 063426B0A2A; Thu, 22 Oct 2026 19:27:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1F2E6B0A2B; Thu, 22 Oct 2026 19:27:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B672E6B0A29
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:27:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E5AB41C3696
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:27:55 +0000 (UTC)
X-FDA: 85351852110.22.3ABB32E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id B7290180007
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:27:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KYznopac;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf24.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711673;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c2XaHicd3RQVicZnU+2gKJYlk0Hf6Vfb+nO23lyEM/w=;
	b=ISof/b8i0OpbZcadWWc3wBm0DxmUKBJ0lq0m/orNu8/bdB4wkj6Mkl9MfXBzGs+RzB96NU
	/4NGhVHNrIzYbjprXXbx6eYL4+9ghLPOMhwgxv4yA0jQN8Bo8+8YW9BsqrRL8kK8tRTBjo
	MLKrU2XmrJZ1v3tlmR6GQDbYrTt4xC8=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KYznopac;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf24.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711673;
	b=zXjCZ3OU8rqeAXr/2fLjYQJTbWExUuCzXE/SDEpgw8aWxrUCZ8yFjmHOfLfF80VtyEfkJ9
	Vbq0s2hCBW63HkRf4ppxe0EbcmO92/V8AX5SOrcy0omd/VYyZ1h4F6yJuHaCC2scUXwxxl
	L5NgOLjM4XEumYTUZGWIvn2N3S2xi2E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B2FC4452F;
	Thu, 22 Oct 2026 23:27:53 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711672;
	b=sdpAmBAGcv/hpQoMISxkqt82plYm7syHRGhIzNZdL5cgVEXoT9c0e+lDhAqvtTIKmvcE
	 qZ3cICAtLfXrOnEB3NU4N8EkoyHQJSwRpD6Gcd5zDt3J61RSITw+bWn+v7uGjTwFaepOO
	 UFwc0U1eusw5798FkPneb5pu4ZAv5nYPU6xyir4/soNH48SpN/yGX/zZWP7K0vGTQjvfV
	 fqBtkiP2iQ6s6/wr2YWgL4voEfQ/oZKjBLUXHfM2SQPbSBOAAVXdEoF13Pd84nzs1goA/
	 1KPnMWxwM+1jTmvU/H3PlvSlFC1/+SWVx0E+rnB6y3TuI/8OoZKRB/b8hG8uH/U1GJg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711672;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=c2XaHicd3RQVicZnU+2gKJYlk0Hf6Vfb+nO23lyEM/w=;
	b=Wbqm7kbPwIh42Iv+oboeh/zRBL7icPPKeL+IZBbYZP/44yuQSSRsTKmwfDzMG10vWBd5
	 hzklZoXxsHc9B7ZG9uAKCv+FRb07Z7tJ0u+jInxHkhO5i6MA/234id2IAOzFoPdTqxnXS
	 eg1EUjBw3ablpiVHWWnlvKjtBCa+B57Nm3pDLlJ7Fc3GQ0Yh1J3hOEoynIJGmvr9HvKXs
	 S0SvcKBe0DHlk1/WUm7H75V1VfsyDRJm/leMrZk6QnZkvajoQkXoPJBQf0UoWXgIqPn0+
	 E2fLoHBi2y+vabGX9ln1LfPPkIt6wqpoVWVszEyDq2NmiYOc4bsMJZl2jsUj1TooMVQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 234611F031F3;
	Thu, 22 Oct 2026 23:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711672;
	bh=c2XaHicd3RQVicZnU+2gKJYlk0Hf6Vfb+nO23lyEM/w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=KYznopacLAZs+FjHyw4fx/r1+PG3TLJa8Vz3MO+c8NdNcnntjMu21TQOSvWxIKcGH
	 NmdVaOrsIG0wqiFqUCii0C3i/EsI65whkOAIHOwc+is8dfRzOVy+5mnvLhbRE7VuvC
	 II11baqN8G/7HACu8TlzdCKI53gpwn6VrN5+sQ+HJEMOcfkxsy3ieeGf/coT/YKsYV
	 FJ1eFuR8g0X3xO5AFnkxmm/9E1z1IoLQE4hAMbVKrP/bttRwujXPQLnX/aIEKSmUiy
	 EZHKEtr8Fy921yqrNZCyOcw1KoKdvOsdf6Wup9lthDNJq6L87a/Z0E77wmjQxXyqzt
	 zaI900aTGx1Kg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 6A11E4204D;
	Thu, 22 Oct 2026 23:27:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:27:36 -0700
Subject: [PATCH RFC v2 04/50] KVM: guest_memfd: Support provider folio
 invalidation
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-4-5dd1dc6c660a@google.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
In-Reply-To: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
To: Alex Williamson <alex@shazbot.org>, Alexander Graf <graf@amazon.de>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Alexey Kardashevskiy <aik@amd.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Ashish Kalra <ashish.kalra@amd.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Baolu Lu <baolu.lu@linux.intel.com>, Bill Wendling <morbo@google.com>, 
 Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, 
 Christian Brauner <brauner@kernel.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Connor Williamson <connordw@amazon.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, David Hildenbrand <david@kernel.org>, 
 David Rientjes <rientjes@google.com>, David Woodhouse <dwmw2@infradead.org>, 
 Erdem Aktas <erdemaktas@google.com>, Frank van der Linden <fvdl@google.com>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, Fred Griffoul <griffoul@gmail.com>, 
 Gregory Price <gourry@gourry.net>, "H. Peter Anvin" <hpa@zytor.com>, 
 Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, 
 James Houghton <jthoughton@google.com>, Jan Kara <jack@suse.cz>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Jianxiong Gao <jxgao@google.com>, 
 Joerg Roedel <joro@8bytes.org>, Joey Gouly <joey.gouly@arm.com>, 
 John Starks <John.Starks@microsoft.com>, Jonathan Corbet <corbet@lwn.net>, 
 Justin Stitt <justinstitt@google.com>, Kevin Tian <kevin.tian@intel.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Michael Roth <michael.roth@amd.com>, Mike Rapoport <rppt@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Nicolin Chen <nicolinc@nvidia.com>, Oliver Upton <oupton@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Pratyush Yadav <pratyush@kernel.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Robin Murphy <robin.murphy@arm.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
 Steffen Eiden <seiden@linux.ibm.com>, Steven Price <steven.price@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Tom Lendacky <thomas.lendacky@amd.com>, Tycho Andersen <tycho@kernel.org>, 
 Vishal Annapurve <vannapurve@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, x86@kernel.org, 
 Shuah Khan <skhan@linuxfoundation.org>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=3364;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=pOpRjHf5uMOxgtWpi+y9tHx9LFOGMZVb62SpcPM8kAs=;
 b=vLwqcufTXFcP6D3c7Xlx1gPvTqIK7do8KFXsvGWNoKx6PNHZuiTN5j5zRaUPTc1ah71428kl4
 idyPlT0GodsAejJRsUI7uldFOvCZD5ylSwDRPPb/sVqn0//iiwhcJdR
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B7290180007
X-Stat-Signature: wu81srnq3jhiiwy3t44a1syctwkepr6j
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792711673-609196
X-HE-Meta: U2FsdGVkX19KVpX7KDYlz8KcI57x+o9vHTlk3mywImnj9klQ4kZz/pcq3Es2a3gsU8bqjjOoXD9xYJryS5JsMjm1rS5e0a0C8OAufbvz9fHRYNR7oBNk5WSgBDYagvIxUnZIS8y71YzP3cKPKOvGLvC2S20VzzYczr1GVXESIvL9bo6H30/XiToHN8+lSwj2jHPa+lFCIgg03xUaoIW4jctaPXEdtgKO7DO75MFX076ST9wFcoNjItjWdi2Uo1Vy674JnMd1tfX9TB1YPBFOdFUadtmgzTeVcGDG1cctPdvdHRyVjNV3wfBdSKOMV5WKsxl2DDbiyWZWvEsG6gL/uVrjVaSbCEmbiY/p+VOf8P98qE9R3uHZ4VvYGOgd2tfurNyIdgTGlVR8XGBKcOWQmgYLVNfxTcQq/KlaPhQITY+yZ1uiXNjgSriW31BmtH4GvfnVt2AZ2Jz8kXxWyDLvMflfTSUR6j16cg8c92mZBZDfdMJN8V9UJ+s8xTaCivNK4l3knX9vXsg2Hl7CrY3x6spYfRHaguSyqcB6pkTyGQSawiASiXu5kaMiBBwCXN3pA6EJecwuXGr0U/h6wRqdPR41HTig90qfzTTFsJup2d3l81ExyWl5FZABdXOH3yKtPvY7qozijA/XHIDvZkjEBHyiyR2pDqxhuQ3rLmvZOS8J5MLapvxxkvcg/Nt5Ezk40Fqcqy4Sa4hjWK8fgukl5UhfdjmlXQafNqeEVG/xDPyQgI4txlvta2yeYEadlKpAL99j9L2/8eHs5WM1hKnkd+eilHuT7GwtC7y+YEmjPxXW34hGM5esQkKndtnvIvEW9NgTYnPUDvP8t3kdKOIcWchxKylLb468L1x55UY8hn3qzVY77/m/dpwcDzfW+qQAFqeC/pMpL8NqX5OuyHFbcDFiIpHEH4uH9sRzzgW+LycbE4jskMeBrv3sTEQTvZAL8nSZib9weXDKAFfYDGX
 Cbj/iQO8
 9i2zw2J+84npJbv149lh1fl+y9kHI8VGYC/CP2bin78nAkwwHc6CfsKZVIkXAYHkZm22t+xox8UAD7F77t9pTCT1lKQQWa6MYqcNMlm/shNj/KEFJNX1rgNxagDI9LBzP3kJvXm+Xxlfuaat5HS0CujR8SrE5qkOX7OrX1iGnERuViK4b4Cjretv5AmdcdEFVTRbna7aNr/00SgxHQGTJZbjLpliplT0/jNdprXRJ2lH5+9JJAwc/d/Ugb25UWYYCjV6s97/LbB7zSxzk65iQv7RTi9jCeXnDFkdHbrLgjnziWdtts0WVIKRegLTFpFEWr1OwFt/IUx5BLnWej90y09Kv/6nJq7U6fbVA0eZyiNE8RAusX/GJdkNxmTBRAitvaIBV6shrg1Rbt99TT2/kjVW0vICreARwDNO6WJirb4lBvYPjT0ZID/4pgmRQhm3OIT9zyvB9a7dH03RuaTQiVAY6yeDPaVsScLgJbqQCjh8C1UFTv5SY7tqcmREzIYsOyWPQopg7BhnxCDfTwvAOz9Q/QGzSsz7vdsEPAZKEi+Y7pbiIenEmp2jz5P3irh6aIG5jJAGKGjceA/Vi0lAAW9oLdVD+Tm+5pcL6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

tmpfs increments the total number of used pages on the mount at allocation
time, so that number has to be decremented when the folio is removed from
tmpfs' ownership.

In this model where guest_memfd allocates from a tmpfs mount, I believe we
should respect the limits set in the mount, hence I require .alloc_folio()
to increment.

.invalidate_folio() is then the counterpart to .alloc_folio(), for undoing
any provider-specific per-folio work during allocations.

.invalidate_folio() requires mapping_set_release_always(). Not sure how odd
it is to use that mapping flag.

Using .free_folio() is hard because folio->mapping is NULL by then, so I
can't reach provider information. The provider information could also be
stuffed in folio->private? What do people think of that?

Another alternative would be to use a custom truncation function in
guest_memfd, just like shmem_truncate_range() or shmem_undo_range(). The
con is that guest_memfd might at some point support more generic mm stuff
like swap/reclaim, of some form? Or maybe never? Shall we go custom now and
unify later? Or just not think too far ahead?

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 545c3e646e9c1..ee823f2ef0368 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -113,6 +113,13 @@ static struct folio *gmem_provider_alloc_folio(struct gmem_inode *gi,
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
+static void gmem_provider_invalidate_folio(struct gmem_inode *gi,
+					   struct folio *folio)
+{
+	if (gi->provider_ops && gi->provider_ops->invalidate_folio)
+		gi->provider_ops->invalidate_folio(gi->provider, folio);
+}
+
 #define kvm_gmem_for_each_file(f, inode) \
 	list_for_each_entry(f, &GMEM_I(inode)->gmem_file_list, entry)
 
@@ -213,6 +220,7 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 
 	r = filemap_add_folio(inode->i_mapping, folio, index, GFP_KERNEL);
 	if (r) {
+		gmem_provider_invalidate_folio(GMEM_I(inode), folio);
 		folio_put(folio);
 		if (r == -EEXIST)
 			goto retry;
@@ -942,10 +950,24 @@ static void kvm_gmem_free_folio(struct folio *folio)
 }
 #endif
 
+static void kvm_gmem_invalidate_folio(struct folio *folio, size_t offset,
+				      size_t len)
+{
+	struct inode *inode = folio->mapping->host;
+	struct gmem_inode *gi = GMEM_I(inode);
+
+	/* guest_memfd only allows truncating full folios. */
+	if (WARN_ON_ONCE(offset != 0 || len != folio_size(folio)))
+		return;
+
+	gmem_provider_invalidate_folio(gi, folio);
+}
+
 static const struct address_space_operations kvm_gmem_aops = {
 	.dirty_folio = noop_dirty_folio,
 	.migrate_folio	= kvm_gmem_migrate_folio,
 	.error_remove_folio = kvm_gmem_error_folio,
+	.invalidate_folio = kvm_gmem_invalidate_folio,
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_RECLAIM
 	.free_folio = kvm_gmem_free_folio,
 #endif
@@ -984,6 +1006,7 @@ static int kvm_gmem_init_inode(struct inode *inode, loff_t size, u64 flags)
 	 */
 	mapping_set_inaccessible(inode->i_mapping);
 	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
+	mapping_set_release_always(inode->i_mapping);
 
 	gi->flags = flags;
 

-- 
2.56.0.257.gf7497c7d27-goog



