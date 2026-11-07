Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BD3B6079858
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AZR44uLX
Received: by kanga.kvack.org (Postfix)
	id 2F30A6B05BA; Fri,  6 Nov 2026 19:37:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2556C6B05BF; Fri,  6 Nov 2026 19:37:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0102E6B05BA; Fri,  6 Nov 2026 19:37:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE6B36B05BB
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:01 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4D71EC0128
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:01 +0000 (UTC)
X-FDA: 85406458242.12.0A5C288
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 36A3E160009
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:36:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AZR44uLX;
	spf=pass (imf08.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011819;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KYQcoPoT+TiTChq9S734+r6sv2Rvv/KnvU2FGo7SPLo=;
	b=nyPdujl2LgxgWRugHVw6gAzYnM8wlpTasoI9j0POblh7pwWGPg90KsAo5d5XBr7YSmiNcP
	rgmC3Dxi9k+qZIUYYMGZcFfWORABvKOYB6D3andEh+fWLtM8hwpyIEinTNR8EEVESSR+9w
	VR0eIxfD7NJyqZA9HCuyWY90uiDq3/k=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011819;
	b=JYMepP9BU0M6GPpElqaFM+ukmhXeZndK+i0B4VYk6LUl4g/iErKnfF1l5m8kCFGCOcvuiL
	nU2zuZqq787l7Da6GbadjwYwj9vLukLao8aG8CV/E2GmXxEoFRWUhxTzhgicKxV3BNW4aT
	v7aDacHpyU1uJLVwIMavbAyVEDn8fbU=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AZR44uLX;
	spf=pass (imf08.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BB61860D69;
	Sat,  7 Nov 2026 00:36:58 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011818;
	b=HRMiDfQ8ajIuCkQf+NqqMN+Nzxr/LBlZeEHUIvomvANEuQz2jo/dCI5nU+Fy2gCFQ6HJ
	 8bN/41fe09u8TtAWOwKTGzIjwLi/oNKPwuxIVdr9WY/eJ8+FN92vNGSrP1HLZkmP5g/wm
	 f9X9MxB06L183kgAruErsAdEve3IxyiXGxHohYva/JoqUnCBesEmD8ctNRDX9aRFHPIHM
	 NszHcX0Uc2PN8Bsw3xhG//834K+oSfKspPKJJpv7/3qqoqOILGh+K10jSTCRokvX6rXRg
	 TLqrYgoU6Kt/3tkTqc3hScRcmthgtD84HOUE2YBAcv/9VvHP0w6zbqv9WfX/10mYzow==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011818;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=KYQcoPoT+TiTChq9S734+r6sv2Rvv/KnvU2FGo7SPLo=;
	b=BgPp4xXKDhsbCSLSm5QfmSLOzIBPN/G3uvdE3ATK4iYWbuuv81WzNzbDMJINbYH9e/or
	 UJmC9Ko8ILfnwlxgp1hW+qasvHhbI+PFQF0qK6FeQvED0qfCQQQMqQu2cvZ4DKSAsYkb+
	 08oBHWc5N+RPx/0l8yeIse0zrhc6haOBG5QwcqpBDdaDudcHt5OJ9DoWaDeYk0XMfnESc
	 ilLngQ3pt6YVldZ8OSYM3wrn91Sx8pHtmQemQKBcA6J/zWp/iWi8QHroKcMT2f57gm2PT
	 tLsGVWuAR+OtKl0e+N5FLUQbFDZYyKZimuKQFF4kXaCVDD1Lu6o45tZxXT7NOj+GunQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 269641F00907;
	Sat,  7 Nov 2026 00:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011818;
	bh=KYQcoPoT+TiTChq9S734+r6sv2Rvv/KnvU2FGo7SPLo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=AZR44uLXAkzv9LkdZplwoYbYql1WdkWmMI3bK6jtFx9Nl3IHsg2IqgbZlzTjIXLqj
	 1ImkTjdYth0pcfyGQVeHKKlzpOijNOkeB2hg4aV4kkyQJS5gxvJLhY+0uLoF7jC39a
	 Mg/emigBmh7clPr/Tvv15ddcSnyw0rdZMHF1t2x7hQAHxKtvb4ptuQBVMUAq2qAAMh
	 Y0zyt5tTsH3M/tg8N5HDkAqj1uOgmSb+xzOnbiM9TRYmgfMGc5jXH8HsWWIcjEZhRd
	 J9TfFKMq0S5NyixMCz32mV//I99BNRJT+1JioVVmaJOb9W0A5TnI2v4M6/8s4kW05z
	 ggxbxZ10yvf9g==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 36FF84795B;
	Sat,  7 Nov 2026 00:36:54 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:36:52 -0800
Subject: [PATCH RFC v3 18/88] KVM: selftests: Document testing TODOs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-18-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=1090;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=r1ZmFiR1qPCCBxX8ciGCFcsvJLc5HDkv8vhs7vVOKUw=;
 b=6pZvfbTvHbGzO6Z9YIneIq3T90JrEFZL7fDyOhT8/iiNQMcWLUJ/EJt5W2PPBe1GU4JzzYZmE
 4L1rjvsT8X5BB33CyQAYR6oIMcuTNN3d2fOXsyT2kk5AxXVOgIZJjzF
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 36A3E160009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: mm3in5b7w6a6da4ejhrhqfuj7a5zb7e6
X-Rspam-User: 
X-HE-Tag: 1794011819-56754
X-HE-Meta: U2FsdGVkX1+xHCnSLQY8jwR5ecTXUtBEznhpOECjHQ98DV96VPnzVTv0Xs1vbx0zvVc6GwHGXB6vJKl7cJSKRMRUXwwiw7Trn1+RSqZfrjM22wTamZIjwM7hFlSu398LoG/Br49bx/UzQX3orcFuSgz52bFdZDoIrrZPUUaU/tEZhZwqfxPXbmZ2q1DBVkdel2gZnBKIUez4p0vZP9vrUYCBgVzFtGQ2FoD9y2KOgtmY8AXqAMfZVHEy330dfE1uNV+v8GmCaCylCSVRaOb23Qa3TtBdLfXezXaVnkXFVPpV9Jkqgw/CqkXrzW3qJAXOYCbzf8EhMefbnfZ2D80ze6dZaesIl459VhBx4fLiyEcf5ZkPislW0lftTCJ0ca9Zg97YtKulPPnH+bnUwEH8jDlSS1S5P/gI9jaNnrIJwdqHkRpev7wfW4a0FmLoZv9xxWNOG4lrUseM8cC1giVr0bdZDsHYZrxwWGrxT/+BvuPPCOKq8pQDQqvtJsl6mWYMsDSa5zrjsFiHJCGMciw0jeUSeE7I2s0BxvsAopi3+RG/a7ZpmB4w+xphUnxjQFKDe7GS4kIh0ZMrKmHulhjfnSKogFWo097dCow//S/FI4fzdYGzIxPmy+naQUKUgRb83/wZhxrbUvcw/GKppGBekgILkzZZ2nsji4vuRK3FlxIewzduMmG/j8Zzv3tvp8TuGvPzdmDpuce3FXqSjbygfXcbSB2aSo4zKaMVBIKIMAuFkLoBICm2NhEygZUILOQG/YoR+p4HKoIrN4nmk9X1wspJt7H5BVsUQUgDtGJAV1arzCsEv4ItHBnms930w7oyG4lZNP1F5dS4aultdCT7JjKesKoI2KxjDcLMe9vS3qqnnMj+w3yObtyI4T0fvNBw1EAFHj44kpidy5WOu7TdCGiSwgpnCnO2z/4OH8NigdzcbKNZtl51UMGyxFUGPvKOlq+BcosuyldSbC9cMqE
 inQ+KqV3
 0+LtSJU6COn58QFt3yZHX5+x3q5KmXLzoyfCodWqXZiiwf3IFgrT4FZHuDqC3YxaU7xtf8AfmXTjKJQMGaw9TfGq6PRb49jqafs50sTx4pRdOd0AzkxhNQEjqelhSO0V+9DyGlarJlJG5mXWEYpcgmr7Birt4yF3dszEoEknQZJd3s3BYRmcHQxh6ZFfYqmZhqCLd6146HuEelxlCReIgqok9QTfVdmyiypot/A07oY5Oz9spGJlijBrEk74vxPDoD7UPTpytESbCAlhX8R39bwpjI6Lk9kj9YfTvj1hPmf8paiji26C8K02l9X8Bgx35AMhoypYwrl8q7fmL0zaRHAHRAK5JuArrMqfzIpL5sygNViQjkxWg4Yx+2PSkfqnUTrZcErF7JZQtuG8m8XJ9MxGdP0A51xyZ98V/zLOyJIUlZ7On1rtBuJYX3s/f85qOcPdAAb6SiMJjknHQgkqme7AtkR5a5gBhL73xStZBycIi2EtblkDBf4L3nKnPcjJqxjVRXiejs5E/s9CB7o+OPERAayM10D7Av8FFnFGMtD8Pu/Vtej0nAoObew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Remind myself about all the tests (A)I did not write.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 8e9261db23354..fd249445ce3cc 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -701,6 +701,16 @@ static void test_guest_memfd(unsigned long vm_type)
 
 	test_guest_memfd_flags(vm);
 
+	/*
+	 * TODO: Test that guest_memfd creation rejects a read-only tmpfs mount
+	 * (e.g. MOUNT_ATTR_RDONLY) with EROFS.
+	 *
+	 * TODO: Test that guest_memfd creation rejects an ID-mapped tmpfs mount
+	 * (e.g. MOUNT_ATTR_IDMAP) lacking write or execute/search permissions
+	 * with EACCES.
+	 *
+	 * TODO: Test mpol fallback to mount config.
+	 */
 	test_resource_fd_invalid(vm);
 	test_resource_fd_unsupported_fs(vm);
 	test_resource_fd_memfd(vm);

-- 
2.56.0.455.g6c5a503b38-goog



