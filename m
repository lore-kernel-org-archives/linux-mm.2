Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24194606A329
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 03:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=G9/dZ+5g
Received: by kanga.kvack.org (Postfix)
	id 0D2396B05B2; Sat, 14 Nov 2026 22:16:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AA156B05B3; Sat, 14 Nov 2026 22:16:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F29646B05B4; Sat, 14 Nov 2026 22:16:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF1996B05B2
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 22:16:58 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 067291604DE
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 03:16:58 +0000 (UTC)
X-FDA: 85435891716.28.CAFC840
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 855F0140003
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 03:16:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="G9/dZ+5g";
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794712616;
	b=K2EpfDvgcUXfIpXEXaIkP6dBkAq5cvDqT4NhTEYzW3Fr/z6pu4Eq158K50SdY1nfsVOmN0
	GMDvEDgEkLZpuqf6CzbKTLDGSg2JqeUJ8dVAKCz62d6EeI7TFIgZ510uX0CxjSvCSwMrFT
	ko8wyuCujSbtK3cCLDzits9L0TAevno=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="G9/dZ+5g";
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794712616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=OD8SJM7CfMjqtj+dIJ+Ky6I5eDJ7zx23/iK2Ybv81YU=;
	b=QwJpjMDJP7gYqO0dV0eAVb3i87Pm7srEET2jUgZQKjLxLXp4pI9BmW6gFZ3dokS1zYcQIa
	3KXqXDVnjdCIkiPVRPCLf2jwlvJK/adZ1MEUAgDemB148+7uAtIC6iDTIOGrySWVDfYG18
	lG8o45QtM2XzK8e9ZnmLvyMTk7cQrC8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2174560D46;
	Sun, 15 Nov 2026 03:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6CD1F000C4;
	Sun, 15 Nov 2026 03:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794712615;
	bh=OD8SJM7CfMjqtj+dIJ+Ky6I5eDJ7zx23/iK2Ybv81YU=;
	h=Date:To:Cc:From:In-Reply-To:References:Subject;
	b=G9/dZ+5gdkJ/OEXGsZG3IO9cZTBa9ZVrudOQDrrX//DM93+VBJp06j451GTwARrc2
	 nGE/8uJK1QfAaON2EeV6+gyelp2kFxnYP5cD9hnm73V/9UWnlrgTQdVpio5uadMSZ/
	 UM09FwVHjfSg85cw7Qc1djTsxM6kEOUTr8WmPoYg=
Date: Sat, 14 Nov 2026 19:16:55 -0800
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Shardul Bankar <shardul.b@mpiricsoftware.com>,
 "David Hildenbrand (ARM)" <david@kernel.org>, Dev Jain <dev.jain@arm.com>,
 janak@mpiricsoftware.com, Jinjiang Tu <tujinjiang@huawei.com>
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <2dfabfd9476542e39c7d5473a6597208.1@linux-foundation.org>
In-Reply-To: <2dfabfd9476542e39c7d5473a6597208.0@linux-foundation.org>
References: <2dfabfd9476542e39c7d5473a6597208.0@linux-foundation.org>
Subject: [PATCH 1/2] lib: xarray: free unused spare node in xas_create_range()
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 855F0140003
X-Stat-Signature: 86iwuy4m4aezjg5mq9ke35q6gfygnm5d
X-Rspam-User: 
X-HE-Tag: 1794712616-765423
X-HE-Meta: U2FsdGVkX1+AjRAynAd7W4LWGCoRlLw++xDhnavsV6vycubH4Po6nSGnMSiiYd5mCc+2ETCljXT2/rYWNk1Sude+YvfxZHm2zt7Cy7kCS2tvcojg96dHo0owcxZLhvlgS/ONu7ejI0gV2luAdHLX4EBLP71mexG1QWSXTSmFqM0j4hmdQrfHa8nXT3LBLihKs4t3rYLk4GnF2DzAIHxka8CfjFzEjZwRrmaEiJmO20jnBU0b+99ogtobUsdkfgdPHZ1kP22laQBakfITdrhoItm7gXjOW4x3QzqH/0IUZlIStT9f9q/IL+OJOZmy3BxebWw2VqV0afgrCOAPwKO1N7hPpv0w+SQ2hEMTDSuQXFzNnPUqnO/ZyF7Mx/x7xSyiZVCbQaNyGhNa0ObJhDp6TugD2ZosIzU04KbNV1W1RKqwYKSevPUV1BHv+PLq6FN9ki2+iwY6jtp8/elQh+03XOblsg9l8Ae7wxja/klD//XxglKHiP7rbj6l6Uxzb3y/5DAI3MgPzKNgi3kGmCmAPPAVur2kMZ4t+fuPWyuTsNIRYBPQ36/R/CRyevBAaJgAlkKSoKntqT7lq0yEENcWYwn0IsKsUOWw977Wu4uN7ckDtA0KHdqySwl04SxSMVwh3I2aWtUtPz2G8US0URzz5Nli05+J+X3MRurFkcHnY8EOJ1lt1bJTpHIFjm3ZKcz7l52jgf5jh38ubESy6TeeT/qHRbXmyEneCbvq2Y5GRWiXz+3FyLhWe8BAnxAErCndXdrwq2GwL1rqfC5t5Uc/AosIbRlj883RDCZjYJXk72WzvLY+EPOR5Y5yQILstzoKZ/r09gPL/szxzsjtbGb5zH1cpnxY3Y102zdOW/Jj2iMgBqHLRcUQjMndkUMKBjVhW0ePLay6NZg8RXhaNUjbc1cMl4+oN7iLp/nnCSxIrvOOX/AZFBFQ1UUlSk5buK2VpyAkeTudfsKde+Tdo+S
 woDVx8/9
 u8BtBn5zXybAZubPuxNH+r+oshtpFoSCOa3/RJBop4+3FXpvCdKGbAqjEcuAzrO1gw2reTUfsX8y9nxM3fNFk+M+dt0ZeVWUZh6m/ZgLj95dgpHfw09DTLv9FNUUXCa7Ao8udYZn2AhAnfpIqIPJxVRnKXc6i2yW3yJ29Iyvmo8AFymVL1y0MfrOuZX8IbRfNpyTQNpDh0Mn8qfOdSatO6OaFipN7UXZ6HLkFkvK2kmJ2q1XcHQAcT4i/N4OmPJKccOlHa0CnaZUWItXRNgIevAJldedGecALJ1PxXhOJMtA4QO46OW3V9so/VucWohoURhGjNVSBrG8GWT+dv7yATz6vplD8puCHN7VZthqdM53F4Ce71jsjKeH1k40xxsmq4d+TQbeYu9fzZ2qMUtLGPZRHseSWIGv8I/hdxdKzkbpvNY3AVIZPHcvuSy3/HDhgPGIaIce7fGOfs4TwT7EZV81PECuopCCOzC8k9QiUWqFDIzCDb3SYCIy48wj+7+Xp//GxQvD67Bc3dRWCFPNGyI7X2VHjiMwRy8vtAyu5JIUis6y+myrTzRuKVxucNxD2TePf4V/cVESBEosNzrbpTfluYffn/hOGqRKrAy15IevRWo5LmeQqPg6De/U5Kv8aM+x9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

From: Shardul Bankar <shardul.b@mpiricsoftware.com>

xas_create_range() is typically called in a retry loop that uses
xas_nomem() to handle -ENOMEM errors.  xas_nomem() may allocate a spare
xa_node and store it in xas->xa_alloc for use in the retry.

If the lock is dropped after xas_nomem(), another thread can expand the
xarray tree in the meantime.  On the next retry, xas_create_range() can
then succeed without consuming the spare node stored in xas->xa_alloc.  If
the function returns without freeing this spare node, it leaks.

xas_create_range() calls xas_create() multiple times in a loop for
different index ranges.  A spare node that isn't needed for one range
iteration might be needed for the next, so we cannot free it after each
xas_create() call.  We can only safely free it after xas_create_range()
completes.

Fix this by calling xas_destroy() at the end of xas_create_range() to free
any unused spare node.  This makes the API safer by default and prevents
callers from needing to remember cleanup.

This fixes a memory leak in mm/khugepaged.c and potentially other callers
that use xas_nomem() with xas_create_range().

Link: https://lore.kernel.org/20251204142625.1763372-1-shardul.b@mpiricsoftware.com
Link: https://syzkaller.appspot.com/bug?id=a274d65fc733448ed518ad15481ed575669dd98c
Link: https://lore.kernel.org/all/20251201074540.3576327-1-shardul.b@mpiricsoftware.com/ ("v3")
Fixes: cae106dd67b9 ("mm/khugepaged: refactor collapse_file control flow")
Signed-off-by: Shardul Bankar <shardul.b@mpiricsoftware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand (ARM) <david@kernel.org>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: <janak@mpiricsoftware.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>

 lib/xarray.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/lib/xarray.c~lib-xarray-free-unused-spare-node-in-xas_create_range
+++ a/lib/xarray.c
@@ -745,11 +745,16 @@ restore:
 	xas->xa_shift = shift;
 	xas->xa_sibs = sibs;
 	xas->xa_index = index;
-	return;
+	goto cleanup;
+
 success:
 	xas->xa_index = index;
 	if (xas->xa_node)
 		xas_set_offset(xas);
+
+cleanup:
+	/* Free any unused spare node from xas_nomem() */
+	xas_destroy(xas);
 }
 EXPORT_SYMBOL_GPL(xas_create_range);
 
_

