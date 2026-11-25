Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10F2B606A326
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 19:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xg/ObpAc
Received: by kanga.kvack.org (Postfix)
	id 24F326B0AB5; Wed, 25 Nov 2026 14:35:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D9F06B0AB7; Wed, 25 Nov 2026 14:35:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A1686B0AB8; Wed, 25 Nov 2026 14:35:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DA1EE6B0AB5
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:35:52 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 65066160FB6
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 19:35:52 +0000 (UTC)
X-FDA: 85474646544.19.6CE60AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id AB90B16000D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 19:35:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Xg/ObpAc";
	spf=pass (imf08.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795635350;
	b=TZuReFbUW6ZbSR431F2Oa85JH6KjmSf12ihlGF7kK+UEi5+nXvNIhMTIYksmEzQ0IBFws+
	lbRocIelZPmuo6thu8oCqOKnSVQmZ7MCzKA8vhUDjVeC0fEa06OozcW02k3748rtHRQApA
	3DPJIZ5SBJFWiJTrMdFvbxetnImUS3I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795635350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7RnKuGHXbcjROOB843xfx2NqlII83H4tFfUxJAZ3o/k=;
	b=X5znaEyHNKDD8OQjr7DH/iHJwlQ/4DH/CqUKTXqvkiO8P4gQfH1Rvxk1Po3mEOZxLGs9nc
	wZ//DWhXdjqzHVKYxUU4VR0qzqDxVLtUGp4PnQid17OozmkEqK5XZ78FhUtKZIRCW7X9LB
	rAaWuWhtmVt3QK+yqRCThi91cEuyeB4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Xg/ObpAc";
	spf=pass (imf08.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4BDC2623B2;
	Wed, 25 Nov 2026 19:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0071F000CF;
	Wed, 25 Nov 2026 19:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795635350;
	bh=7RnKuGHXbcjROOB843xfx2NqlII83H4tFfUxJAZ3o/k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Xg/ObpAcsvbaM3LzMQBoGpkUsNyyuXwh7u4dtOczWFJpS5vHWZ/tFGwxceZPICMWs
	 zGztd1W7WPrqE/5gK+q7EG4yz0I3j5YLJrAhCBW19LAocOsDDDotVM6xTXpseEpnGp
	 1i2jn4Prf7Ywp9sJ/b6yRo8+PRUFev9SudT7e2iYn2QCC2DLfbDpzot6xBqiJQVoY4
	 IOagaOjUWL9MlE3madKKryoOTBSgnbkfUBO236YN4iH86CfDd0knUV8F3NnhIUs1RC
	 3nEvxIZeuLzFKN+gg0YvaNzTXfeVi59kHg2fme3Ho0nUn92m2D4Aivc0EsuPyqUGmC
	 3dLv4j5zddQCg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Wed, 25 Nov 2026 20:35:14 +0100
Subject: [PATCH 3/3] mm/slab: document that local node allocations can use
 sheaves
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-sheaf-doc-update-v1-3-4a579abaf0b8@kernel.org>
References: <20261125-sheaf-doc-update-v1-0-4a579abaf0b8@kernel.org>
In-Reply-To: <20261125-sheaf-doc-update-v1-0-4a579abaf0b8@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1490; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=neHwOM1VlnyNi5ABTykKOG49HCJ+vaQthdyKZl4EJzA=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBrBzh4lgMGh/iGY0flnmQCxHAq24mqaj7v12Gog
 O2MROnuCU+JAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCawc4eAAKCRD6UCkIqsW9
 0DQxD/92stFHcb2XJRr1vITcoR/9yftHSzgXnMWB6MjhxO2uiqnrwHl2eg58uAuyuO53R33sKEV
 9Azv6zzCeXAcaRx8RhO20/H9Or0xUCnlAcoXw7LZg5b8emN7tJQzmuPLzAfqxBYGGszxZH8+66e
 G7InZkRX8ZMzTI4AE+L6H0okocza17P2grdG2xoxsJO8TfUa2z++f6xjhMDMNgBXW+d61C4FMhD
 Ks53rSLJDLFg/QbCUegJVv6AO41EhQbx+GYwPoNMYWIQX1UTn4C5CUEHdw3nY6pfQQPX7rQbA9m
 hfbdbcA6InhMAQkjT9kJKP0LFuePtxWwkiocc9EyP2/Ee49TlZNPbsVrtPXw2xgvXeepkQZV/0X
 glCSj2rfNN7cn0kXJN9Fr1HK8FEK10b9mJuWa1PxClossfVkwmU7Uv7ZhDbei9+3bJmhyFT5G9G
 rgDgTBtciURCNRVDYHvuuP9+z74d06vD3XQG+5oDMZcxaPCX/4e/ywPfkU2XV3AvsztK8SbphD7
 5XY/nw96zCfL7YrX4QxNI5zp8bc1pkGWyIZC0z1aJR8iSuH0XoY/LkVSNU/5grgWnc7Dc6pWMF9
 mR57psJ1EDIZN8pM5Y3+oRzHA3fIc/KUp/cBeKGiz0aYUeVopFOPm0qb0eoaTSe2XNFnHlV0zBC
 lN4tfQwmT/Zt0NQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AB90B16000D
X-Stat-Signature: scjdi81f79s71chzawc6xzjaceejwomf
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795635350-642216
X-HE-Meta: U2FsdGVkX1++sytTjjcPpj/lG1O5z4EFMcuOeK3GA8aSiRkmyv8pfl3YThhtd8C7PQStjWZPXmRFhUNlDnv7H1ztkl7TCZfDfsAQ2ts82oSPxcKgZ7mH+sLcIl/29kVvEdRdLGw8yORomoYLHRoZJqtOW7pBtLxShwcP8bsN2QnEuFDQfrMzkR0BfR7XuiWXqofphvYemKK6PGWj/gzXrkiYq++P5Z66IAwbmo2Q43rR24IspHSZe1k9+65c2+jua3157/2ZQfrP5VwEXLyRJHEqr6fFG+LFCuECFhWayeD5GqHoG94D+aOytwD4+FTRLjD5i+u+xFeLPhkyK40Kj9mXztQKrzlDs/LfE550aHk5VdEh3QYak3vIQ7G0vJYgjTLqIuGNnxe5rY92UY8vyoFK+9quei6IMNnTUidYVtmP12rM9M8pE8gldATd+PWQEZ6WgGwL+ZqBwAMOZp0rSFQ1pa8jotTn8AtQbSs6ehNXJV3NtsL02T6tQ97o/p3vzsOfALLQtWfDdcB9BKN6jhGQeG1vW8q5Ea/5b3mU2lxHqgGb23G65b6AwulojIBl2V5yZX4TofbKrmJt1YdC2WJX0i3xj10oolEc+S0XJP/eSljyOShwONHdWyTH1ojxJZGT3/roy1uuFYp3xrGz64OGLJmw6CkTeOxvnxrfAyAzbRQbog6cSk+egICMqQJrDmd1O/kI2Mr2EXIKVxV8gXUQhXR3qeaOu+1XEHbwvu4/hKi9jwXA4/zTEsBoFSvKctchSs62M6pwyMjrIRNb7JBqOrWfOAffoxSWw3X5tyqXJtz1+K/1QUyyQZbKvHCis3R8W+7fbqgw54uegTEp9nc5edIg3XIo5utk1/rCv5pXtbAvlXE2MZgHyoKTlMdoGNrvvxVnSh0O8v8PgPYUKUmg3AWQfj155dKV1WFsGHqfcX3Hk2X5wgFMsKldlhULNVf54exUgkDNEVKiH43
 /WY1rLKy
 YrTo8okdPmqcijsspTp7mSP0tKHLFCRvz9bsvRlh0/IGkbSAYCaXy6OX9EqwYk18FkTz8dajIa5rvFuHotmqjXyvYl2xcgk+yYIZbeZKrFCYkzx2394aHdAJtOudWSR7VKjuf8ci5hk50ucHDmRX48t6HfiZInR/SREtDcm/H1/YVNWZsN9IprPxoG11YsJNCfuLyHd+rUI89yPJHduKIupyiyYTmC/PK1f5uyS/WCmUSGwJAjpaqNHjiPdkVB/fxp72yfT0l8wtB+S4L65Z9KVgtqa7v/92cF2Dt/SpWwJY8sNpGJTGiG0tAK5SylQ7/Nq34XgC5l3lVclJ/FZAlLs93+Iz3wRzedC3ShSGcpd4JANcr77FDN4VLg8Zb1bhTZm5YWWLh60DjUhrz9m9/cfptGU96IITWIXIdMCrCTIA0ZMWtonTzBHxgjEu1iL9EFfc4cYrmv/rNVICWYx1I0/LuMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The documentation of the sheaf_capacity member of struct kmem_cache_args
states that allocations via kmem_cache_alloc_node() with a node specified
other than NUMA_NO_NODE bypass the sheaves.

This has not been the case since commit 4ec1a08d2031 ("slab: allow NUMA
restricted allocations to use percpu sheaves"). alloc_from_pcs() only
bypasses the sheaves when the requested node is not the local node. A
request for the local node is served from the sheaves if the object found
there is from that node.

Update the documentation to match.

Fixes: 4ec1a08d2031 ("slab: allow NUMA restricted allocations to use percpu sheaves")
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 include/linux/slab.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 8f484e1edcd2..ae9f305db9ea 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -369,7 +369,9 @@ struct kmem_cache_args {
 	 *
 	 * The sheaves do not enforce NUMA placement of objects, so allocations
 	 * via kmem_cache_alloc_node() with a node specified other than
-	 * NUMA_NO_NODE will bypass them.
+	 * NUMA_NO_NODE or the local node will bypass them. When the local node
+	 * is specified, an object from the sheaves is used only if it is from
+	 * that node.
 	 *
 	 * Bulk allocation and free operations also try to use the cpu sheaves
 	 * and barn, but fallback to using slab pages directly.

-- 
2.54.0



