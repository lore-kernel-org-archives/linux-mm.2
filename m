Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C6BE606AF84
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kkGXBUKw
Received: by kanga.kvack.org (Postfix)
	id 7D7786B0604; Fri,  6 Nov 2026 19:37:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AD226B0607; Fri,  6 Nov 2026 19:37:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B0AA6B0606; Fri,  6 Nov 2026 19:37:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 275DE6B0607
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:24 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C4E04160264
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:23 +0000 (UTC)
X-FDA: 85406459166.22.0C5E343
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id A3E932000A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kkGXBUKw;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011841;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j6n9yIIcfnOcnGVEaQqxGzHzdc6SyqXvU+1WBCgMQDc=;
	b=5LP4w7r4jnRZpfmCITspJkR0tnmSBSQ7tXWwEnl9gZ0COd5+OMBXIiw7aQe/aTAgZ5u5Ez
	s2luCp4MVjwmTHFw5skMy22ccGGh5nlq3OKvIGjTKxAe2penm0pfvP17FKp96c2Bl+BFsp
	/p8AESaMUZCqBThfzlpWwWogLTIQwUc=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kkGXBUKw;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011841;
	b=p4G6PgXhR2FUb3TNnhOe2Rp7H63DxqYnFcl4nW9T6VQ2b3/fdvAfTehqlYgBrFVE/NXDRp
	SDzJVH3NKIg8IbGdBXcmyyUpOgE4VmVxFrsaRcawwXPyP5JwRJKbKUEvat2QJS4hrGkKSa
	i5RifSbCM+wtWH3X5b+C0OkRhEiV/XI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 70E4E44026;
	Sat,  7 Nov 2026 00:37:21 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011841;
	b=eb/vDVAKeECthiSwyI5qhxqUrowDLJpSM5ZwSeC41x/IhjM7aE+DtDB20ff4ODrWYYsC
	 kmFbrM37IpmEZlg10dSiY3WVW3Iy4LGmcSMFsQ/yZgcg44wGhZQ2ibMuj6OJynR56Gdqn
	 k7DVqRnIk/I9dUrSjrJzkFJOsPp9XmH1nMBJYXtsY+7HxLNgmnQqpz+SP4q2D1DaJ3s0a
	 nH4Ws04Wg61Mjja8PWpbBe57QiAcbw0qg+GnEq4hEk68fvRrgweaZpTG6b6SOPs+AUlEJ
	 eNhCJRY2iQoLsfapXSoeZrnlDi4dkA04j9BJpGHlTd9VyO30y88m9eo6PyH0kX+7SPA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011841;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=j6n9yIIcfnOcnGVEaQqxGzHzdc6SyqXvU+1WBCgMQDc=;
	b=ro78RZlwZHTVYCnzFJZgdtqsHg3U5WN+pLQL2pe2S9BB/te/oEL8gxa8WvJUR6HJK1S1
	 sAtBKO4qQEzeYj5mkPsKteLS8XqLeKnGRluf5CP3Zv3TmjG032koPohnG7Q7/OjsSsXuU
	 bMjIaXS+FkJglhH8HJTEMVNR1tlQ6upM5L7VlZtgL90Q3BKbgoRGx5Kup+6MOH9J48NbS
	 NaLTnDe9iar/6ejMz3MOxY4kLm8x2k9lr46XjB31SdOI1xiYiMWXJgVup1NZpHUyt3a6/
	 NHw0/kcsIdWV7kN33IFCxQquAkUCrB/8nJYg1CKCaEe3vppihGQflhlQYxfmHmSm5FA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D86FD1F008BC;
	Sat,  7 Nov 2026 00:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011841;
	bh=j6n9yIIcfnOcnGVEaQqxGzHzdc6SyqXvU+1WBCgMQDc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=kkGXBUKwR12OgLfL4wVSOZxLefx+VZHXQSIzpBVvnHzH/Jum7n/D20WJf32yzuE7h
	 bx8PQSe7qL0Bl9kgQZwNFgzRERPfOnvtfuCCmYAztkgyAFmZdFL7Q0OatKNYJ+a/Oj
	 p3wkoK3WcA7gm9TUSZ1zdUVei/vbtS+fiN/F9+06Be9GIIdlUNsFajFHQZXM9K9C2T
	 WuBHw6Vo6e5N3aRNyVVkWkMSeN7dVfaOCicIgaSUkUgIrRjijkp6QtgJtG2+YLNQTd
	 4fU83rNOiV5k5koUOnopmBTljpoFrikgBfSZH5PxM24y4ENrkhLzNq4394OViPIFs5
	 0FMmwKZVNlctw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 9BA8E47A60;
	Sat,  7 Nov 2026 00:36:58 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:38:00 -0800
Subject: [PATCH RFC v3 86/88] KVM: selftests: Expect successful conversion
 on MSI-X BARs in VFIO test
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-86-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
In-Reply-To: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
To: Alexey Kardashevskiy <aik@amd.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, 
 David Hildenbrand <david@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jianxiong Gao <jxgao@google.com>, 
 John Starks <John.Starks@microsoft.com>, 
 Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Vishal Annapurve <vannapurve@google.com>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=2135;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=VzsQCzajxaq4+sy1dgFu+2FHBF/aQtRmKeEX0OOIiWI=;
 b=S4xYrV5byO8s3TboxsOXiZx6GDu3T8GX8FRcNDg51wlr8/L7ZZOzal2WSfJanjxA8BGU7KO+2
 Iju/+vhbIDtBPvAbcjUo+0kvLnJoyMJvy/myX3jkaxwU9LK9VGetSTJ
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ejxfzmo3pgxqwua6js3znqae4bnbaup9
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A3E932000A
X-HE-Tag: 1794011841-360426
X-HE-Meta: U2FsdGVkX18hx/KhZkuUOJaTMA+Rz4kYk4wGdOFvkbgcav3DRIIm/njC+WrMjXSwJALClWdz3NiDTO2gWyGHq8IJVBR2KMWRQPCxmQRwPUbQ0vjslPOtpI777yYqiJzA+vYUhaQiKLb+vx1GS53s9yWGx/thxIpecnEyPNqWRwQeBz34c7SiAa9Ekh1Ff6SbIcOoRO4jUZsAy5h3jdsyN12QMxHWzGcceilN+/nYujOxRB9yLbBOXtW49tuNTNCJYeFvsS56cbhRkzvzJ4umYP4S33C+KOncQQuZOCHqKV5v8l9Tpv7n7wxNsmjcQo6umWnkiAhaVfkJkwLkUouCzT+rGeMsxg7D7mhSz0SfJB1QoHD+HJQ95vzi9fRgHxzbLbPeUDdLE48rU6lNyvWgBLvSbNGjgZMTkD2eZsNBV7pVosiO7K+OPhhpwANM2YjMGCFLIMTAtId7RTTFJqebAhIlLvyjX/I4mzNa0/lNvOXUPaxmF2vZ0J+6hIxrVBDElTkYb5TP21JKoPU4LtMOpoqmGU+oiU4I/KYgv2KcTwRX0guRryY7b6VJ2jiJtfiG7WNBheinqoxe5MqO87r5AxC5Kb+ZjWV+w8DUzY474qvSn+Mfygqgk+f4dW3c/8h6Ug1NCvDpyqf/xxGllkw5+ab1Vm/OLfM7D3tZYXYXAeVCZBTyR/RG3v6CT/6Iz/Tk6FRRCt5hR+duouSmXuN6fwTtOA8YV+Rl/MS+OGymT0YrO1GBKU8eKP9i5/Ybcnl+sUdEMzScwPAidvqqMXiIm/KhTUBRr/EIdAsEQFxdKKGJhAIpQ7JFvpx4B9GXLhI0fzglg5EL4Sj3iMYY5lnshcy9QHpuNHokhUcL4G/uFwDixh5pvqzBm1GVwVWXi4zqJ7KiobP6qaIiB6A1HoRFDkVfWlcOcevsHMRKY9gKcFh3rRoXrWlN4mDljQtj3EqdiFjr13tDXTSp9wahcuo
 Bdwo/5Nh
 DZgVprJJMhIF99oeo9OmJv0qDnEaVUWh0Ilw9STSsiQv6mdNpoJTFbSJC2N0vQiQXiCpUJoj0BCqiGiFO0V/DnIm07Npr+blTaBsuN8U/7l/Ya+pkKIceFnRWGjToD9vkd/AFh/fo+FbQxs4vdLOxrBZ54Qfkn2dlsvgNHYFs8bfgdHeQDBnOaOjRVkm6dS50Pha7lpztTk3jkGadQ1UbENzAfmUhHQG9/IW9SlKVNNX1S7Sq8F7deUU3qqC0sKZz+0rpi3RWV23qOWglA8TSsglOzLOpjn2bPBqHweNPK0Y2j8ZaA4A2jnOReMIMScN0P0lDMQcrATvqhfHQao3cAeW30FY12xvILeIiLGZQ9xMXdc14CKi3m+iNVaT7foA+gErTI/WcYWPHUJ7MWvNKbiUVEmaEiCq70mXHDgGvN63Qcdpjkviwp+HHwLxLS5fMvR9WK6jso+r/HtVw109dL27rcksQfaEsqsmDoDIEwgbycc3ubVZPqC0p5/GXo7I13NXdey0JlwL/jnVY0CvLqjlg8nLK/7xREzHc86L524L7bdSH3wb28AIMBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Disallowing private mappings of MSI-X vector tables is now enforced
lazily by rejecting private fault resolution when backends report
shared-only physical frames, rather than eagerly rejecting software
attribute conversions.

Update the conversions subtest to expect successful attribute conversion
on BAR3 containing the MSI-X table, matching the lazy rejection model.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
index a520cf45fccb8..325d5e0c66026 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
@@ -798,17 +798,19 @@ TEST_F(guest_memfd_vfio, conversions)
 	ASSERT_EQ(0, ret);
 
 	/*
-	 * BAR3 contains the MSI-X vector table and PBA. Private conversion
-	 * must be rejected by check_set_attributes to prevent host kernel
-	 * writes to interrupt tables from triggering fatal protection faults.
+	 * BAR3 contains the MSI-X vector table and PBA. Disallowing private
+	 * mappings of the MSI-X table is enforced lazily via NO_PRIVATE PFN
+	 * attributes rather than eagerly rejecting software attribute conversion.
+	 * Converting BAR3 attributes to private in guest_memfd succeeds, but
+	 * attempting to fault the MSI-X page into the guest as private is
+	 * rejected with -EFAULT in kvm_gmem_get_pfn(), causing KVM to exit with
+	 * KVM_EXIT_MEMORY_FAULT.
 	 */
 	ret = __gmem_set_private(self->gmem_fd, bar3_info.offset,
 				 bar3_info.size, &err_offset);
-	ASSERT_LT(ret, 0);
-	ASSERT_EQ(EINVAL, errno);
-	ASSERT_EQ(bar3_info.offset, err_offset);
+	ASSERT_EQ(0, ret);
 
-	/* Shared conversion on BAR3 should be permitted. */
+	/* Shared conversion on BAR3 should also succeed. */
 	ret = __gmem_set_shared(self->gmem_fd, bar3_info.offset,
 				bar3_info.size, &err_offset);
 	ASSERT_EQ(0, ret);

-- 
2.56.0.455.g6c5a503b38-goog



