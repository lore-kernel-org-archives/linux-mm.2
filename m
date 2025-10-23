Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E410CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 07:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CADDE8E0005; Thu, 23 Oct 2025 03:44:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C85858E0002; Thu, 23 Oct 2025 03:44:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9BF38E0005; Thu, 23 Oct 2025 03:44:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A8E028E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 03:44:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5C82313C04B
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:44:28 +0000 (UTC)
X-FDA: 84028591416.12.98FBFCD
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6DF3F80002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:44:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761205466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=DhsDGEcJlnIM2loUQDP52Q83EiEbbdZT6r2iEDZkHqk=;
	b=5ViDJ0Sot3nMmyili+k3QgQDi+hIxERs4XIlr7mNW+wNte3Opl9bbxCX4eUuJw9mWXvFyf
	xM5n5+zzWGkk/V/7LAGnJtKPcwhyEBKDFxOKjQuUl3z5WLZAe3yywjw0BeNvPi4iE9o6ab
	vaYkdmeXPxc9lNHaW+czbnn2jXYH+uo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761205466; a=rsa-sha256;
	cv=none;
	b=BqCw2Mpkd7JMk5lS3sbNh8fIgu3CAZLu+u3KLuTm39CvMN8fgzDKemw96np6LvSPDLquil
	3M2qDJnAiam/oYmOg+vs7BqjjA1n9iKKfckmKs/yvVkXPRx8TcXsCU8IXHWWDrSvjzJ70F
	IedARvguHnQzF5Sn4HRoi7v3sOXPAeI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
X-AuditID: a67dfc5b-c2dff70000001609-5a-68f9dcd4f823
From: Byungchul Park <byungchul@sk.com>
To: linux-mm@kvack.org,
	netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	kernel_team@skhynix.com,
	harry.yoo@oracle.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	davem@davemloft.net,
	kuba@kernel.org,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	sdf@fomichev.me,
	saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	andrew+netdev@lunn.ch,
	edumazet@google.com,
	pabeni@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	horms@kernel.org,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ilias.apalodimas@linaro.org,
	willy@infradead.org,
	brauner@kernel.org,
	kas@kernel.org,
	yuzhao@google.com,
	usamaarif642@gmail.com,
	baolin.wang@linux.alibaba.com,
	almasrymina@google.com,
	toke@redhat.com,
	asml.silence@gmail.com,
	bpf@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	sfr@canb.auug.org.au,
	dw@davidwei.uk,
	ap420073@gmail.com,
	dtatulea@nvidia.com
Subject: [RFC mm v4 1/2] page_pool: check if nmdesc->pp is !NULL to confirm its usage as pp for net_iov
Date: Thu, 23 Oct 2025 16:44:09 +0900
Message-Id: <20251023074410.78650-2-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251023074410.78650-1-byungchul@sk.com>
References: <20251023074410.78650-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0hTcRjG+59zds5xODgts5NFxaICKbMweYNIoYITYQQSdPlQSw9utqlt
	uTQIpo0uM2/VaM2Jq0iXWtZM3SRXzmWaUWJoC0vNKFsXi2nLqWTbpG8/nvd5fp9eGhcXCmJo
	edZJXpUlVUhIISH8EXljQ/+7gCy+qZ0Cc0M9CXVTeVAzYhdAoH4MA3NtM4LJwCAFc22dCCbc
	z0j41uFDcOuGHwfzKx0BvxumcXC0jiH4arxLwqfOUQrqbCkwXP2ZgEfnW3AYLe0ioVg3g0Nb
	YJyCQrs1KG7UUtDbXCKAq9O3cWjRjlDwutVMwlD9nAA+u4oJ6DbdIeCXwY3DcEkydFqiwd/z
	HYG7oQUD/6VKEvqvt2LQ1NZPwZU+CwkfdcMI+jpGCTDMXiChoqAEwcxUUDleNimAiqdDVHIc
	V+DxkFzH95849/DOW4wbMJYTnMf5HOMcpvcUZ7Hlco3WWE7v6cM5W+1FkrP5LlPcu4FHJNdl
	nCE4x4etnMM+gXHFZ8fJfYsPCbel8wq5hldt3H5UKJvx1lA51pg8r+umQIvci/UogmaZBPaL
	uRjTIzrMBaV7QjHJrGM9ngAe4igmnrUaJoMspHGmiGYHnQ/Ch0VMBjv36RoV2hLMGvaNJYwi
	Zgt79aVi3r6Srbv/JNyOYBLZ7r9PqRCLg5Xe8mkqpGQZN8369Oeo+cFStt3qIcqQyIIW1CKx
	PEujlMoVCXGy/Cx5XlxattKGgp9RfWb2sB35elNdiKGRJFKU/GxKJhZINep8pQuxNC6JEmkO
	BiNRujT/NK/KPqLKVfBqF1pGE5Ilos3+U+liJkN6kj/O8zm86v8VoyNitGiVlV+/d5RfuEg8
	UJq04JTR27Ti+OHlurH7E97EQHsV7wxUpuQOKoW743K7iMdVKzOEmWlNS9+mRL/WFja8+qHP
	7Ks5scOZeuB9oC7ekJjg9aQ0V6qidBWZop6iZhX2h1h7zLT19+rt92L3SU/vX+2Yit5joo1D
	OyVJIy92bUwSSAi1TLopFleppf8AUtMB3BUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAzWRbUhTYRiGe3fOzjkOF4eldjCiWGRWpPb99EEZBL0VWlQo9SeHnrbhnLWp
	qKHMFCzLr1JaqbSSbKmhzspN1GSb5goqrNXKcsvSssQiTZ1GNoX+XTz3dd9/HoaQfCaDGaU6
	hdeoZSopJSJF0Tty171671VEOG6shcqGegrqptLhjscsBG/9FwFU1j5EMO7to2G2vRvBmP0x
	Bd9tvxBU35wgoPJ5Hgm/G6YJsLR+QfBNf4+Cwe4BGupMUeCuGSKhLb+FgIHiHgoK82YIaPeO
	0nDObPQNN+tosFU5hPDiYZEQyqZvE9Ci89DwsrWSgv76WSEMWQtJcFy/S8LPcjsB7qJI6DYE
	wcTTEQT2hhYBTFyqosB5rVUAD9qdNFzpNVDwKc+NoNc2QEL5n/MUVOQUIZiZ8k2OlowLoaKr
	n44MxzkuF4VtIz8IfP/uWwF+rS8lsavjiQBbrn+gscGUipuNa3CBq5fAptoLFDb9ukzj96/b
	KNyjnyGx5eM2bDGPCXBh7ih1OOiEaGcCr1Km8ZrwXXEixczwHfq0MTh92HpLqEP2wALEMBy7
	icspPliA/BiKXcW5XF5ijgPYCM5YPu5jEUOwFxmur6NpPljEyrnZwav0XJdkV3JvDPMoZjdz
	Zc9UcwbHLuPqGjvnbT92C+f420XPscSnvCidpkuQyIAW1KIApTotSaZUbQ7TJioy1Mr0sPjk
	JBPy/b4m60+pGY2/3GdFLIOk/uLIx1MKiVCWps1IsiKOIaQB4rTjvpM4QZaRyWuST2pSVbzW
	ipYwpHSx+EAsHydh5bIUPpHnT/Oa/6mA8QvWIb4/2vnqTMjW0OYFuz8sXBG7NzA/tKEuwe5M
	9pzqvFZyIjEl+6xn+5Ri2eTepT9Ln8jHxD3Zi1KP1Jg9bnX0HpzZv0MQIg9ambVcrs92NDYP
	DW70L9PF921wboiKvfB8tTnma1FMNf9On1U8GWXLb696BL8PHU3dH3DM/bTJIonxSkmtQrZ+
	DaHRyv4B18DwC/cCAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam01
X-Stat-Signature: uxzwu6kyc3t94p3zu4mbykac6zpsps8n
X-Rspam-User: 
X-Rspamd-Queue-Id: 6DF3F80002
X-HE-Tag: 1761205466-55207
X-HE-Meta: U2FsdGVkX19u3n/b6QYG/vywc4mcJETnKYmHhlUnpCGIKAgi/v7rKFwMWFsxe8cCPMay91fQo5vx2Pqi7c5nZ6cypvUDyWo7lVq/08yCz4+RpJSbEb27N3XcrvGnlhbttc66PGLhnY0KxH22284EiU2xgWNWGIA/h3M6Sp/BCB47fniZpPLmtpDAbmY/uv9Ohl6TBabEWp23pV4MIFoa3EI0sZ7YfFOSFpMO7LmqangFEO6vljLh0RcENyN8jyKsFHDZ3c94AjW1ribL0TnIyBQ7chcWDxoErTFJjkV2l1xSbGXIdfDgFt+qenXUAMzHZUzojZ78qZUyuGpsdU4E6cU+GCOM7obRJfMZp1MHnnWkSrdQXLL07eeaaWg7EhAhJcPExk6bcTNlu5cK7JyB9fpnp6uIvBU8uK/681ou/4nLGb16ruugLLDEPuVye8P4lmAw+64nbcK1Tr08Q1CxeH0srHplYHGSM5EgDczi5/cyNHaX9Mehr8m3zXZey9D8FZLsgLMpEl09wRXGkelxYdbEc/7zJucRMmA9BRTidcrDBkvs9gOfIgzPNJVErVdyFdLQWuX6t+iAAeMtxRqzxXn3Cc00MpWwkdt6lyDHSnOdwA1/HGMHpQY7juvLj6ZQyDS6ZrRDrnTYkY59OG5g5cd4O4NxdjE9qB1CDORCYhwdXmL1GqYkCDhIlI437UFZoD8sKnpMaP9B48gVbneBDc3mS+DIpgGil8EIRBgXcEJQzCKrn3Lzt//6RPNz1Dfg255xbwQY+9vtq+0trbvuAX9kdEOj/lcpcuyOV8roRBmybOz/v+ByQ1zC0Py/Jt3HQEtdIJJ/OhNvkZd0G/mgK3dbRmctwgKfhteMqiTgJIvAtxrfJluoDgA2mKNLbGjlImca2QFu9KiTqMKzKyJVrpfzQ0zSnEZcvT85rytjvw/LwkERTfE4mZYUU9iiUmn6Uj/FhC8S+QE2x+njQkv
 fzscwsLd
 z4WSnnDkXTnX53k0bRyQkj6wWP0bWYjdF2fzTTu/M5B3VrfPRA0AqLidbx1p9BjQ91yfTz95cNn81t/HOnO3r+FVtfBoYZH1tunU4S/iuHuBbkNMwv4sHCgVybtdNVs7n2ixQQOX5m18TM5GBxahnujvrPubd3EqQHLBs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

->pp_magic field in struct page is current used to identify if a page
belongs to a page pool.  However, ->pp_magic will be removed and page
type bit in struct page e.g. PGTY_netpp should be used for that purpose.

As a preparation, the check for net_iov, that is not page-backed, should
avoid using ->pp_magic since net_iov doens't have to do with page type.
Instead, nmdesc->pp can be used if a net_iov or its nmdesc belongs to a
page pool, by making sure nmdesc->pp is NULL otherwise.

For page-backed netmem, just leave unchanged as is, while for net_iov,
make sure nmdesc->pp is initialized to NULL and use nmdesc->pp for the
check.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 net/core/devmem.c      |  1 +
 net/core/netmem_priv.h |  8 ++++++++
 net/core/page_pool.c   | 16 ++++++++++++++--
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/net/core/devmem.c b/net/core/devmem.c
index d9de31a6cc7f..f81b700f1fd1 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -291,6 +291,7 @@ net_devmem_bind_dmabuf(struct net_device *dev,
 			niov = &owner->area.niovs[i];
 			niov->type = NET_IOV_DMABUF;
 			niov->owner = &owner->area;
+			niov->desc.pp = NULL;
 			page_pool_set_dma_addr_netmem(net_iov_to_netmem(niov),
 						      net_devmem_get_dma_addr(niov));
 			if (direction == DMA_TO_DEVICE)
diff --git a/net/core/netmem_priv.h b/net/core/netmem_priv.h
index 23175cb2bd86..5561fd556bc5 100644
--- a/net/core/netmem_priv.h
+++ b/net/core/netmem_priv.h
@@ -22,6 +22,14 @@ static inline void netmem_clear_pp_magic(netmem_ref netmem)
 
 static inline bool netmem_is_pp(netmem_ref netmem)
 {
+	/* net_iov may be part of a page pool.  For net_iov, ->pp in
+	 * net_iov.desc can be used to determine if the pages belong to
+	 * a page pool.  Ensure that the ->pp either points to its page
+	 * pool or is set to NULL if it does not.
+	 */
+	if (netmem_is_net_iov(netmem))
+		return !!netmem_to_nmdesc(netmem)->pp;
+
 	return (netmem_get_pp_magic(netmem) & PP_MAGIC_MASK) == PP_SIGNATURE;
 }
 
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 1a5edec485f1..2756b78754b0 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -699,7 +699,13 @@ s32 page_pool_inflight(const struct page_pool *pool, bool strict)
 void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
 {
 	netmem_set_pp(netmem, pool);
-	netmem_or_pp_magic(netmem, PP_SIGNATURE);
+
+	/* For page-backed, pp_magic is used to identify if it's pp.
+	 * For net_iov, it's ensured nmdesc->pp is non-NULL if it's pp
+	 * and nmdesc->pp is NULL if it's not.
+	 */
+	if (!netmem_is_net_iov(netmem))
+		netmem_or_pp_magic(netmem, PP_SIGNATURE);
 
 	/* Ensuring all pages have been split into one fragment initially:
 	 * page_pool_set_pp_info() is only called once for every page when it
@@ -714,7 +720,13 @@ void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
 
 void page_pool_clear_pp_info(netmem_ref netmem)
 {
-	netmem_clear_pp_magic(netmem);
+	/* For page-backed, pp_magic is used to identify if it's pp.
+	 * For net_iov, it's ensured nmdesc->pp is non-NULL if it's pp
+	 * and nmdesc->pp is NULL if it's not.
+	 */
+	if (!netmem_is_net_iov(netmem))
+		netmem_clear_pp_magic(netmem);
+
 	netmem_set_pp(netmem, NULL);
 }
 
-- 
2.17.1


