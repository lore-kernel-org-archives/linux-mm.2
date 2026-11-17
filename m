Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 680DE606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 11:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dywW+YKN
Received: by kanga.kvack.org (Postfix)
	id 8C1246B05B1; Tue, 17 Nov 2026 06:14:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 871526B05B2; Tue, 17 Nov 2026 06:14:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7613E6B05B6; Tue, 17 Nov 2026 06:14:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 583DF6B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 06:14:06 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DC1BDA7976
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:14:05 +0000 (UTC)
X-FDA: 85444351650.11.5341FEA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id C0CD71C0002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:14:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dywW+YKN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794914043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9H04yuSe4iuUyFfUm6ir/Pk1kCN7uCCpIfbwJZv1Sk4=;
	b=hdimUq4TkruAGAjbU7tcb9FwlqzDLIOmgNb7dgZqb60MGqiDElwJ3OcSg6PpraXFS4MVdq
	O7iTfGohmSEl6LjvP7vkURaRfbcE6JiOlei7aui53+VJdjhgKisDmG7TB+7di0kLs94QdO
	MR/h6YtON1F96YTo3Uq5i8IupvkecqU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dywW+YKN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794914043;
	b=6OBycNQ66+dP7wLDdan+iRDrLM2A/kdqdTr1zezvQvlKSL+zGCIS4J3Pj9ZkbBby7XGhD6
	a+3QR7ZzmI9IVHf9K8ndxz2VLeubRUoxQ79x19N7TSo4SlBU58DI6jtIvORlJKT5EbHtkC
	yi8K7WHyRaBDrmCP4r6uF9XaiArPaHs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C8C263411;
	Tue, 17 Nov 2026 11:14:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189481F000C6;
	Tue, 17 Nov 2026 11:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794914042;
	bh=9H04yuSe4iuUyFfUm6ir/Pk1kCN7uCCpIfbwJZv1Sk4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dywW+YKN6iJyQppnuJmCfBzF0LdqirAKoczgl5PvqKoHHoaL661RXS+DxDEnvakOZ
	 tWNpIiRvPOKmY8jsrsVTueqzkapr32vz1f/iC4HwgIHrUw8CnQ3zAJXokrOopQRcjY
	 xnTbhh0sOCpBrz+BDxs4e9T+0EZcN+2lQv54cxWjMZ4nWlp7O/JRYx0VMVnsYJXqi5
	 gB2iRGo0XM1oGw38o6vTr8O/8Qnam65eUY3jH0vvneQxSJw/gHHJErvVnfZwJgx/E2
	 d6pTtTL+qqzM48yE5GZARbm6WgsA2BIeiaaTICcz9efG/Y/jm6aWVjmJhngFp71niI
	 t1ZwJhqeT3Jzw==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 6D2AC198004A;
	Tue, 17 Nov 2026 06:13:53 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Tue, 17 Nov 2026 06:13:58 -0500
X-ME-Sender: <xms:8Db8av7h_UOsysMwvcP86csyLI0_L-Y0fG1zP_Y696MEVpVoGSo6pA>
    <xme:8Db8ag_C-YcksC8UEt5JqwVrNrFqw7N4ayelai8n5bDdR44rqlcW-oj-dq30kswsm
    TurKg_DLy8QPcQC18_IVy7cAgSuPNo0ucUTMY8f6Nf3JrRhjkCyWZux>
X-ME-Received: <xmr:8Db8ajJpxWRgU6AnCZfhG1HOiM4eiQeGdPrQuQmTXehknwhbVc9wyuTJqDc>
X-ME-Proxy-Cause: dmFkZTF+JKJTFhO7l5xRceP24AuGfujUQYiZxnoeyK5tA83zfmMRcw5/8FhiWDYeqCSpC6
    T6IC9ySjUHbOB+fpES9ocjUyQ76AHREBXteYhc/tTYbmY+NhXgoz5EC9qWmtA/bgfx1HcQ
    G3d0KvtgMZf8Ub9RJZlly0ltGkym3kClsfEB1T7YifuIlnuXXZdlnKkViCO3FwoDnOOoNU
    fnC07yqnaRgq+GBlBbKihyppy/cbRRiQR+t3z+FOPNU+/WP4gEOzuHSdR4pA8vgm07oi2g
    D3/E4LFSDXcLeLK/W8zOGBJMyubGd8PdT3AVGSvP39vq5QvTlAf9/kSmgnbhnuaJbtvetr
    QZIlkZrx7vANum40gg4v0gwpBxHKHqEL+fAh/bqzhJNG0FBXdi9gYVPQv7BV+zxuXkiHFx
    P9td+ZlRXFYdDU4DOehwuQZzkfrT5O4hw9eNghGseaPrMxtOOlyqszK/SsGikF0QYZdFuI
    ULcq/QuFEs6cf00KI/A6/Bvr+f1CfBwzCXierY4ahyW6eSdqVyCzpz6dFMaQV/LqCuPMtd
    k5OGuumM1Gv1yTxagC6J7H7NVrKyRWfZxMOGd5YwkFsimiV5aStmtxkyBAyFahfVVFV+Uv
    VHwuJSGk7buXeLxgT9ESlFGJXKATIALexZo+JJBnJbrq7qBblldkdK45j4MQ
X-ME-Proxy: <xmx:8Db8amfk0bunvDgiA6VEpYeOjqUloHypf2omjhvAtlcxCPmRt6ku3w>
    <xmx:8Db8aiqEz6AHO-G1dIo6Cxt0yxpSiwmh59qHZ_AOWG-Fbk10sRnv5Q>
    <xmx:8Db8anvHdUtnZwFV0GXcOVB8a_cROsYdtUX45OOlP2nTmQ2wKh4j-A>
    <xmx:8Db8arci-RC-UdiaB5yKwSiLiY2Db1UCTL5QN-r_ic6fok36Lv83IA>
    <xmx:8Db8akoOfVKWmLDdEFAHbFQrDXgCaRW25TF24W6hN7Ryn2vZzkFQ0TXE>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Nov 2026 06:13:52 -0500 (EST)
Date: Tue, 17 Nov 2026 11:13:51 +0000
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com, 
	byungchul@sk.com, david@kernel.org, gourry@gourry.net, jannh@google.com, 
	joshua.hahnjy@gmail.com, liam@infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, matthew.brost@intel.com, 
	mhocko@suse.com, pfalcato@suse.de, rppt@kernel.org, surenb@google.com, 
	vbabka@kernel.org, ying.huang@linux.alibaba.com, ziy@nvidia.com, hannes@cmpxchg.org, 
	riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com, 
	baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH v2 4/4] fs/proc/task_mmu: account device-private PMDs as
 present in smaps
Message-ID: <avw25cL2uCsbuPpC@shutemov.name>
References: <20261116063624.1382944-1-usama.arif@linux.dev>
 <20261116063624.1382944-5-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116063624.1382944-5-usama.arif@linux.dev>
X-Rspamd-Queue-Id: C0CD71C0002
X-Stat-Signature: xbhenr1bycs9id93e9brsyxucqfgt4me
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794914043-850038
X-HE-Meta: U2FsdGVkX19RuzR6FhXiMBbP8pI5kJT3UzxEj5VUlLySrXJ1sit8JA8uELDS+JA+WKh5uqKtVBpfS5im482xzjoKSb1zQ7q01dhpEhGkjanD6cjM9fc/9FFErK85NTSoA4Gl1gCXAUgdQ/D+m4kpD6qpj0c4BZhYD/3XuJkDsrRMF00PjI5edqAuCp6RBoLTYJr/D47d+X9pgJsmMjEiYpRwHEmezkhrsXwvgejar56fzOpPCpeOIPnPeb3VXg2VgzVJ/M2ydp8lPZ8Ioky/5tWdY6YAAFN4BgnmalVhMU5jPTOQjVCIYRvtOgRlwpDT97swCPumY7qzQTAzmyCsG7aTj6650zhO7jMlT3+/iTduq1/YgEE9VIjjXX+2iYNyTRxH/1KN/LwYQdWE6cXnQSoocP5MbFNm7Vy3EH9hT67cDdCKocCDMP2JEsqGzH5XG8CHeOMLSNd+kp34XorEQEdOuLXH5kbA9lR+LwXjEC8oD3Kl6HjwsR2D33Wcb9m7IUkY3GWj52sbo2PW9kU2nCYLwu1YW5ymqXcAoRQXff8k8my/vWyfRcvH4L60bzABBcehRIDYx6XUiEAZ2LHYfnn5ojy3/Dn+vgVjX698XMx6fIyOqVLsXUQmsDBdByI1ZraSop5+BqiYXveXTOovREcf01e0tmbfiERqHO/zUz1oCrGkrDIvcQW0XHl9YrL4HNWMekAEf3I1bHeu3e8rGHcauCFsvM8B1jdJjZLALSDJM5+pE/zbCZ+hGQaxnli9ct1znwYYdFD/SAl2aGr7gsL3KWRux9MACyjWYwZMvpSjXSc/lCPbg7hTDdjQtgqatYdRPGlUhPCRZnBoOnWXsMbI55oNRHgVVHLXIF8BmYs5i491roPWZUKc/g0vXIMSb8CxluphOpmEgzyd7m0RQ7WyvlgGJEamRMRlGMIWxhB9/1Gkw7LxdyuLokLdSsbk+/B3enW1tYmWcAPu6Ln
 3pjT22sE
 +vmtJipyueXSx/NdDljsjTgd4ZcPjPmMXjv0whYHzb73rU23VRlKmfYE3f8w0cFlg9KGDWUpzzObjgOtxZKt/u1PAlEaUXut1+jKRNAyq03Ex7wyq1OoNaBrxZTD1vAFkRPZctxCKuuqB5qRB2zftx7RhyXQau2l10NWCjZo+aZh3wbDJG5yf/CeXunCqIWgX0tJVQ2wzccZHWFYi9oUorAGWY6v+2vbYEVg9ikGR28A1pZKZO8zZ3gmSBGBXHVmausqH5Fsjy2vrKdG5HqwGM7LpZSaSMxM/22eRtHVGw6eCpJkCX7Qxx9Hght3e/Nx7P+mM1e82Xi/nuDjXh+kUMD2yYLotJ2kCnUbKMJ1MoPmv0OoQmN5+m0gflFOBwosO5W+ADYVn42nE/jj0G4wy1vk06Qun/wj8GH+nqNJeCRzH72n9kTrkhrjDbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 10:34:58PM -0800, Usama Arif wrote:
> Device-private PMDs represent mapped pages, but smaps_pmd_entry()
> passes present=false to smaps_account(). That treats them like migration
> entries: mapcounts are ignored, PSS is charged in full, and exclusive
> mappings are accounted as shared.
> 
> Match smaps_pte_entry() and mark device-private PMDs as present so
> smaps_account() uses mapcounts for PSS and private/shared accounting.
> 
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

