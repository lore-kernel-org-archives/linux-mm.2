Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67800606A32A
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 22:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=msTCBmdx
Received: by kanga.kvack.org (Postfix)
	id 7924D6B05B3; Sat, 21 Nov 2026 17:18:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CD436B05B5; Sat, 21 Nov 2026 17:18:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 595AB6B05B4; Sat, 21 Nov 2026 17:18:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31F406B05B2
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 17:18:35 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ADA071A05CB
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 22:18:34 +0000 (UTC)
X-FDA: 85460541348.13.A7C6D3F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 38827A0008
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 22:18:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=msTCBmdx;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795299513;
	b=8piWgaCQ7MlA+NtHQFFZKdoBXSY+3x9M4cikKS5tyxdPbV5CfwSc4i6db7hubFT4UChywg
	yg91gg+OI2TYSkVsca46XEenole1r6Z5qskJvjQsYQQPj4bVgQEfzPoB9vpFEqwnVT6a/3
	c7ci+i8shdF6KGRnVGpsJ36IEI8VhDs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795299513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=jc0e9w5B/WyGX+EuQP/e+iqjqymm8yhUQoI3phbuDaY=;
	b=tMC8aTyo+uefrrSYTjJ5OSvWqhsp3k1XkkQdCmPaiayUXBdgZ9OyZNj19g73tmUAH/VxWw
	1GxkHYGvQ2bMgwG5RBfuoEzR4scyem6+RRz521vCBB1Igch+KPM1YGqi27rjzDQjPhzKmQ
	4zDGSXhJTJQDDK+BvZdLbjQwUJLS9/4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=msTCBmdx;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C603E60F25;
	Sat, 21 Nov 2026 22:18:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C76D1F000E6;
	Sat, 21 Nov 2026 22:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795299512;
	bh=jc0e9w5B/WyGX+EuQP/e+iqjqymm8yhUQoI3phbuDaY=;
	h=Date:To:Cc:From:In-Reply-To:References:Subject;
	b=msTCBmdx/suzcgkscRklorUgg/8vtfuieQdHp9uhxXagQtLOwDnOXCi3AJ7WQpABL
	 +wwJrGEuXhSaVHGEX3Wl1wL3Kgc6esez2FUElfc+kH+LiUE//NDY2EPrfQO4VidCpk
	 4PUexmk42ZsdgF889/XL/Zpp0jKH6VEZGlksVkFo=
Date: Sat, 21 Nov 2026 14:18:32 -0800
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Nickolai Zeldovich <nickolai@csail.mit.edu>,
 syzbot+73641b60a3bc11dfca8c@syzkaller.appspotmail.com,
 Baoli Zhang <baoli.zhang@intel.com>, stable@vger.kernel.org
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <08ceefcb212e4dda9767389fe7f162a8.2@linux-foundation.org>
In-Reply-To: <08ceefcb212e4dda9767389fe7f162a8.0@linux-foundation.org>
References: <08ceefcb212e4dda9767389fe7f162a8.0@linux-foundation.org>
Subject: [PATCH v2 2/2] xarray: initialise the offset of a new root node
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 38827A0008
X-Stat-Signature: 6judhhwfejzsw4qzyxwwsewupb6redkp
X-Rspam-User:
X-HE-Tag: 1795299513-256221
X-HE-Meta: U2FsdGVkX192TCHSMCjfYBMeAIlRGbhW9fnTyaZDg0I9jpc32sZvdh018N1GMqZfWNT4FwXTv+7oR5PIbwqn/C329k5cIZhEndG+Gl4seab0UMH3McovIutVBk0+m0YTPLcWmVavVoIJDXebkGS7BZM4UYZ3hLbvXBMnS6xfhs+uKUiLPI0iYP5vtbtrtLp0UT2OetJtzrb/Wg2+akE/iQvUCHadwq3shM/WjeMPbaSqjCZ57vOEOK/h7+kb+ssQ4JgBCyLf9nlxKp7asQYZrJheDe0rfRDzDbbv7l++jt4q5qgmrQCARJV1yK6mXNjqcRwyEOK2Eej2NKhyUcgRBrpNkjycN8+cpoZEA82ClIzMHPIL1MfANPmh9CY/3G9uU3PxAP+THqmT6qGoO6dfI6fm0BVHMdw1LvI9CDNuUHBWbFboh3ryOzzdqu+6qS4NT/jHVKnvJXUO2zMI+CfCPYEAJUrvxKJcgirq58JVp0VJ41vjyPlCjHYMfNa9AiqS1GIge6i1V3cGt/n5bqWUG3K5mUdXFJznX/MGqEh9IU7WHbR4cxi8hVWs6VOBs/o9d/JY9v1O+PAhFgBGF4IdK7onkYm49C6gD3VMfznXvKVOC/Gq/M7AGAD87ihqS2e/RABwnw/PbP8eIRctMwKmFAVkktE1Qt6E502mn3Wq6vSYx7cNj+eGvhWTSoslbmYahJGMA1gXe6+k1NENa8EOEPpyQXX6Nyt/RR6lWYWosbbYDBEWrWmi6xBHUgdgNsnFnJS5b7eK6+pdW5HWHwy138pBJeaxspv0FTPoyGsyf9SFJRBtTKwxedvExibXyZIRkvgWRyKtktWD2UeTggmUPekELgwtLpXjxkZ0/RFmKE+14Fuod0MUfzeYL1uQp/QcD7cB4E0D/hYCyhFwIxu6oHIeEZ+OXvClrGVU1EDtk3C6Fya/SvbOQEH14pQUIjgSZ6mmDKbH3IsOxsPUzXO
 fdCIT9n+
 h+kCUlMh5wwJDQLdsbfdv2jpU9AypvBdd0gra8AFpwSJR9Gz6nvDG81zqstaaexjdhH7mqnw2fpNNxoW98zJrGcJBxQUbhCVi23d1gx3ByA74/o+nMbLGm9b8QTFKElFKWUzjpTXrzY2FexsSeI2mlaym3WRtjlC6eDhW/YyhRZncWw7wtcyH02IygiZeeVTEDRAnSzkMtchmImp34Zf3dUzBM672crhrIpCCUyliEKU8KSpoL7ZMKYbPGTSw+aWQUysHx5VEXWxO3f1J0reT7XWRLmnwSjBAPQOBBV9nRt4MlqjJWxQT1dYlj0defvT5lrbqYd8QckxebuMxPd3HOuUnmwbZICHo15mFKLLgeK01tlbpcoXNkkdTnq5jS5VgeaCe5/34G2PNsdLEUdbMi4w8e2Y5PjhOA9pjBHUdp1R0IPSx8nNVKqIvnleoOs/VbarGQXUli+RYZhQPIxFjXnhVixtVqMD/lwZMkFo7WLqwS/a1RZdITDo82XSBqaASdWJFugMX0pSPZPvmRGfWEaBFzrhNZF+Cz3zVK0y75W0fs76sE9/XNk8wVn1oo66HnNB2OBU5h3JrePzlLpcI3D96xghebi0qeEKf5dDpy0cqvFWrM8Bz1flOWpNxBGJit74zyBs4gKitYvxYkrQOTJMQh5nv1p/roX1r96K5Fl/FpTV54xsHGrRM1dXwe0WTRlvOzaa/ST3vo46NOuUn3nFMQ/Wy/T5IO3lVh5J3UHOouF/0h3qcnClkt263ehCIxB9/t3Hw3i6GG6VA3x37Ve4uv4qsK2WRkDlARJbW4VFQ/BIufqAFOXVF3ukZw0JkYc3tYvziwCDIRrdQPOFzwOI1LY8nQLsNufdAwnrpAwrX/x2I2EMN9qFGJkf15ZzEETzrT5fs+TpVb5fegg02M5cMSM21vXCNIXFwUqEvpR8KnTs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

From: Nickolai Zeldovich <nickolai@csail.mit.edu>

xas_alloc() sets node->offset only when the new node has a parent.  A root
node can retain a nonzero offset from its previous use in the slab.  While
xas_expand() links that root below a new one, an RCU walker can read the
stale offset and then the new parent pointer.  It can resume at the wrong
slot and report an entry at the wrong index or skip entries.

Initialize the offset to zero when allocating a root.  The old root
already has that offset when xas_expand() links it beneath the new root,
so remove the store to its offset during expansion.

Link: https://patch.msgid.link/20261024014344.830116-1-nickolai@csail.mit.edu
Fixes: 58d6ea3085f2 ("xarray: Add XArray unconditional store operations")
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <syzbot+73641b60a3bc11dfca8c@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=73641b60a3bc11dfca8c
Tested-by: Baoli Zhang <baoli.zhang@intel.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
---
akpm: Tested the two-patch series on x86-64, with the new test present on
both kernels.  Without the fix, 64 runs of the test each failed both
root-offset checks.  With the fix, neither check failed and all XArray
checks passed.  Both kernels used the same configuration and test setup. 
This tests the stale root offset; it does not separately reproduce the
concurrent RCU-walker failure.

 lib/xarray.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/xarray.c~xarray-initialise-the-offset-of-a-new-root-node
+++ a/lib/xarray.c
@@ -387,6 +387,8 @@ static void *xas_alloc(struct xa_state *
 		parent->count++;
 		XA_NODE_BUG_ON(node, parent->count > XA_CHUNK_SIZE);
 		xas_update(xas, parent);
+	} else {
+		node->offset = 0;
 	}
 	XA_NODE_BUG_ON(node, shift > BITS_PER_LONG);
 	XA_NODE_BUG_ON(node, !list_empty(&node->private_list));
@@ -617,10 +619,8 @@ static int xas_expand(struct xa_state *x
 		 * Now that the new node is fully initialised, we can add
 		 * it to the tree
 		 */
-		if (xa_is_node(head)) {
-			xa_to_node(head)->offset = 0;
+		if (xa_is_node(head))
 			rcu_assign_pointer(xa_to_node(head)->parent, node);
-		}
 		head = xa_mk_node(node);
 		rcu_assign_pointer(xa->xa_head, head);
 		xas_update(xas, node);
_

