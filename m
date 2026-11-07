Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A2AD607C19E
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fP1ulBq5
Received: by kanga.kvack.org (Postfix)
	id 670406B05BB; Fri,  6 Nov 2026 19:37:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FF0A6B05C0; Fri,  6 Nov 2026 19:37:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 450126B05BB; Fri,  6 Nov 2026 19:37:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DF2D6B05BD
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:02 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AD9B314016A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:01 +0000 (UTC)
X-FDA: 85406458242.05.55D04F7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id B84A340006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:36:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fP1ulBq5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011819;
	b=Fwds49ywC2oqkYa7zmOlPBYEJ6GMQK0Ly50nqyK+8hQPoZQx5Oku6EYHcmYL/4pfgDNC7L
	CozSc7zcbQVqyi1E2jwUGwjwS9Msrr/OXAeKPt/4z6sIo5tIjF7viTD1KFjitTCUO2QSBS
	+/5kkJwG+QnErdb/seyZ/wMd4Qar6Ss=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011819;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+XUHsmZeTE+/d6Lf6AimXu/HQocGY6bYgFl0PE10MLE=;
	b=OYsakmQ2Wb8qRligM4c7JPIVTEMoXOYyMSu8cslFLdU8VAifW7ZSVG67gecC/tm1e9nH34
	DVEIlWbNUDD9hAKXsPXEpLoyUghOucR7YG7ZtatO7sWwT/xB3jpCBTv8ctvMwmYK0hrUTL
	NMCBKhbmz68qWtmDsRqJPzCcGpaQ6Mg=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fP1ulBq5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 38C2F60E11;
	Sat,  7 Nov 2026 00:36:59 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011818;
	b=r9zoGIUuYLOthhJjcZmYCrZl4WpPrnP8G/dzienPCnYpe3EGLeA/InkLE8aiJQ7RVsMl
	 vRnbaz2z0EU49PP7orF9+PEzIBk8NCdkDnlLyqHnvBRo4KJI3/1AjBdxqTXQjCwxuFa6m
	 bzC6CnY4cQ48NNJ9PUlixAkDAWwGe46oJdQAiVjNozzmLNX9BFe71wlEdMxoTdbBHc7Rp
	 jpXt9f20Iz1l/TncPoqM0R0DbtNQAZYasB9DDQaV4kVAPpdfg68jWbNRPI4Tv5mgw7pWe
	 gGmnQc7IiCHA+yPnSpCX0gu00RKWRDdDdpp1ylKUlcU7gZYhincJE7de6/B3NQ+S/LA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011818;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=+XUHsmZeTE+/d6Lf6AimXu/HQocGY6bYgFl0PE10MLE=;
	b=ofZiw1Z2GN8vWclmOs21GgnB+d0+dREUmewc60DsOqHnRHIrL57LGIia6SKoV7EMwUdU
	 rWXQ4Wp89QgkqcyCQkYIj8QlXJTPgUzqVAyk6XF1vXe5mqEyX5o2uYsW5Ddq54I2tL4sr
	 ahTAPa6paBzv7AO05F0zfBxGbSi7o9C9K6z4b/Ia24v/y/nNkS+9nbxU2ap6Ej2745Pu1
	 CQ6V3oqPCMj12f5OOGPlHSa7N0Z6hs7T56mVcfKTuBC1RDs8d9WD/Rqo922wgvSP9KKFA
	 roz+icR6I/mnzog2sdJrG4XgBtJRog+ITr1+KZqVWeCv+XFQ91UHFGZjC9kE4Hu/A/A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 9993E1F00901;
	Sat,  7 Nov 2026 00:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011818;
	bh=+XUHsmZeTE+/d6Lf6AimXu/HQocGY6bYgFl0PE10MLE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=fP1ulBq5oX6YZqsr2uTDb80dsrutYpVmZrOwSLqZUNVYjl0qGSHpxcZC2vyktS06t
	 FwJ5qt5enRvISsblVjhWnYzqf8XRmaARe3mZHDP79Xxw47+xnQhidaDztq9fTHTJxV
	 4ooiv0Pc5Ioay4UHy8S3J2+bNHZJ4sCSOys2Jtvj8laS0h6Lxz2OZujiEfn0rPGIsL
	 B58U9Vs1Q/Jd3cRurL76RSRs90QMs8J8a9IjlMF1/nXpuvi3RAWs6zX05CSCm1NPXC
	 2YAdwj7phB0aDnUE0NI3HiYFC7CBotJ7uihH4dP6sx+s+cCc9EROeBlzuYFP71gSVh
	 BHGFAX8rJsviQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 139FA47954;
	Sat,  7 Nov 2026 00:36:54 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:36:50 -0800
Subject: [PATCH RFC v3 16/88] KVM: selftests: Test that shared tmpfs
 resource pool size limit is respected
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-16-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=1067;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=NSNZp2TvUElTKQXMVaHgiSKEMn4WansSyP3qnP7lAE4=;
 b=TzAIr6cJe10IhPRtWsxgFp+NaYLpK7zef9IbjbEjVnmlhCYeSKRyS2vMmwoTfTHH/N/TeLBqI
 KF1EnJPBXCABQ4b8FSTXK49EUlCJHblKHNv0GHCSAiZkoYJ+Zw2o9za
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B84A340006
X-Stat-Signature: zspkzigna7sigtnoo585di9py9169rqk
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Rspamd-Server: rspam12
X-HE-Tag: 1794011819-695397
X-HE-Meta: U2FsdGVkX19YDwvZ8UCP5ER3zcwBu6ULJZ4o9KYwM+u1LABr/c/3Qel9KUuhRImHxCbFmDrUCSgzNUlS79traNv+6C+lK3ZczEn3SFLYz6OFnhY2LQLHxL9d+C9u+xvgb4iVOvzdB18OytfjxBPqROCFqLposD0eWb80HryQyJbUqWYLLvhT6TSJh7Y8wuLiW0neYpD0cYd8t1wtrjr7X4VgObIdBTLzrcyYMr8Y9Zt59ZFmy717aOad5Jp8V04yanEjeQEY6U6s/wrd0loipz1sl0cnz+4RcN3t/dzwxWBfaMWsDlMJFA3PsRw3sbUt5ksIMvUY0uk+9iNcQKBLipZpP0Zi38mZjG4JvPHlYgLtBqglgZLkgDPZo4IXE1jPI8wCTJPIbtektyGTsTR5EMkxxMCq2naKoYyY/i86sdNZe94I2zxw4OG40qCifDTXng86RJNRi9sF2rVZlaE0V4nkNvDPSXBVtv0PZmcJuf1Ll/XRQhsmxuoNQuswTPphujjHuqcuU55g86FwtKi4oCB5UBVqIgr2nPTkZOQ02Zdt7JY+rMSPKFLub5pGkguxHoPlJKK52/eZ8OPS+XZIonlfUcrPVcQulZhGnZxPwG/FlkNTtWoVIYHfF1FmU2SC2nmVqjtJgwX9cEoxYB/2Elv0S6TEntz8qRYo9WAfMcQKirOs3cYCJl7AzHYXO9Ul309JwAn4SatzBPxqYG2tAZedP8lyRXAM6ioUD64bBfgKbwR31OS8GkHf4EfRA+sziodMXSc1KvSTgCjHRk4ADlDG/fU0n6wCB/iZQlSZxOvwyNVrD+ZxDB/iNqZsuFsMhkfmT40nx3Q1M0giYDAMWYGu1p5//vNY4fFOezj24FeeEEuyEtG6jkDeM0loMpuqdfQHwxm9T2KmXVHGuM7dj8XPiYm/Fv5MMrRiRWnzKYQoyz0JvsONrLS2VRFpBv1ZzPo1/qBHh1mZcKuArk1
 65bE7838
 3FVslVZN8QtBTBACJRlFXsFidVzow8P+eP96iiLt0eQMqP/S3CeLNhjVEkvUnEGjpAlvKtyKuS8ehFlY3e032d3cL9VXC+LSisZ9ITLa6FEjvTBiY8bpH1cLuh0X5XCSKCQvHk/ZIHjM3p+1dd1Al/O57qK8G59nlcazTTxOFTC44dWpSci6Ws+4B62TAJAT2TUkfHQwEQLplae39Ev2aD0lnY1QYZMl1Y2B8VHvHoeGjK2bvmPiY6nLKP27LNmWUpZl+vclx9VFU1PI9ztiW2/zYzeIJSnW34Z6qXqVPcltLwXrTEeMnMaJ+jmt59PM0Y6KUSPOdD8JxSgEf0zhjdOPCSDmSOanHh3awccvlH5KJ7Oy+jyeX7bzWGSenZbYAA55RTV4L4Y8V494ryaCIGfwHInTFHPX8KvjSAn5PgHYuhI9CLFVotkp+84KGF7KiEPVbYNFouvDHhYLOOf8pNGz4Z+Dj1XKOjdR6meG4P0pmCYiMGO4FYE+LZWNG3sY0zjew8ST8poxICz2+03EmNpo4Rfte07PbxbsUuwK0YgPEXdZXiNrent2YndpDv9Z65QO6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Verify that allocating memory across guest_memfd instances sharing a
tmpfs resource pool fails with ENOSPC when the total allocation exceeds
the pool capacity.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 639b1b0c204ed..20de24ad535f1 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -604,6 +604,10 @@ static void test_resource_fd_tmpfs_shared_pool(struct kvm_vm *vm)
 	TEST_ASSERT(!fstatvfs(pool_fd, &svfs), "fstatvfs on pool_fd should succeed");
 	TEST_ASSERT_EQ(svfs.f_blocks - svfs.f_bfree, 2);
 
+	ret = fallocate(fd2, FALLOC_FL_KEEP_SIZE, page_size, page_size);
+	TEST_ASSERT(ret < 0, "fallocate exceeding pool capacity should fail");
+	TEST_ASSERT_EQ(errno, ENOSPC);
+
 	close(fd2);
 	close(fd1);
 	close(pool_fd);

-- 
2.56.0.455.g6c5a503b38-goog



