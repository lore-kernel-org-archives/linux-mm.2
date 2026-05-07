Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E118ECD3427
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 04:30:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA47D6B0088; Thu,  7 May 2026 00:30:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B557E6B008A; Thu,  7 May 2026 00:30:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6BFC6B008C; Thu,  7 May 2026 00:30:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 962996B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 00:30:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 43BE91603FB
	for <linux-mm@kvack.org>; Thu,  7 May 2026 04:30:23 +0000 (UTC)
X-FDA: 84739347126.03.304C46F
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf24.hostedemail.com (Postfix) with ESMTP id 36830180005
	for <linux-mm@kvack.org>; Thu,  7 May 2026 04:30:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="FgIWb9//";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778128221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WSQDx1aVKPjTjfW9+Z2g0z5Qu0eZ2gr6y7uhSWPGOrk=;
	b=OkEj/wue4q+TP6n0p88NplY5PC+pzXp/UYV/B3clRhyjx9ilehi157MzmcCDED8YBcWdRa
	XLQsdCfF43ahaFIB/+23os6MIlrgF78GiWBXDc9JuWeqmlD1OL5DwFg97wuqJYGLBL22NU
	VD0EJ8TNF1V1H3sPhJ/cmjy7BC/pbNE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778128221; a=rsa-sha256;
	cv=none;
	b=W6yViOMYhLmiQvch+OCsVR4OAqG+KPF/c0jYBYLPXW+B0wZxIogyi2PrQtotmEnFV/pzcB
	RnKgDlQPnREDqaptG/d4cViOSpCUmX5h7KiLhRnulfSB8oGRSx6l9xOfU74NkgPLk+64yz
	rYzG5FsT+jxTlT303CAddBSidN66MKM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="FgIWb9//";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778128218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WSQDx1aVKPjTjfW9+Z2g0z5Qu0eZ2gr6y7uhSWPGOrk=;
	b=FgIWb9//6CirMif9jMkRE2sFeDtubBFUKxL0Y3xet2wlqV5u2uYK3DW7vatHlJ5IwIDTRD
	Xrz8yfaC4Oo8qfmk7+ZMJIgtjnvlxLQyLf1w5tnFyBXRTvZcSd1yCfvmkdK6FE9dufNFTl
	mJHFO07KgJcE95/ao3OH6VdGkYz3kzI=
From: Lance Yang <lance.yang@linux.dev>
To: ziy@nvidia.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	willy@infradead.org,
	songliubraving@fb.com,
	clm@fb.com,
	dsterba@suse.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 03/14] mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
Date: Thu,  7 May 2026 12:29:58 +0800
Message-Id: <20260507042958.95301-1-lance.yang@linux.dev>
In-Reply-To: <20260429152924.727124-4-ziy@nvidia.com>
References: <20260429152924.727124-4-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 36830180005
X-Stat-Signature: f794rtxzmrjmdsu3riob1m5x4azfir3y
X-Rspam-User: 
X-HE-Tag: 1778128220-345353
X-HE-Meta: U2FsdGVkX1/UNmA9NE+XocfTyUO5sbbWOCsyqmnw+MYGhKjZ0Fx3XFcUbN7m56qLre2IGMVhG55ynckt4jzZVwjrPxtHR7HB1T+Hr8oICp95PR9plhe0sj6a94Ek50mGCL4mXGFeopHTZHpm0zF+95NJLrPaPGw8Ccf+Oy1q9UelITTzI+UrtyuHzoix2bm8Jko3y2k/l3ONe/2nRpaHSjDWWLRsxgMakLi3FvXUb5zM2GSzJ25hMYSTQazj/H/pQxnbLV9X+IhlKv8UYfcPObQwdirCQqB49GbF/XVr6SO4u+iV1mwXsvAetzHSxV8dkXJNpqLcuy4K24lTX8si9kAwKu8RRmS7Q7LndSnYhFiDj+MiPrOnYgPBenuPA71/RaG95PJmg0lpcSAvRk8OCEIEksPAoS3cLYmOIWqedlrsYVfmuH1smpnV5XziR1Cjv0oSl0Oc4ZTaX1ELXZGbACV/uG5QLxliW6qIbZIthVz7KWP1ADpJE0pYS1z382+yxHUm20nnpnUCjXwRV77xFOGHn81CQ2lUv5NiBX2E4c6x26StMGeNj08HOAcf3YCTMBatoMTWErN441ChrPFjs6uXjgb1j/xYBLVRgVlt03YWn7QbIe0bSrXHp4j/wkj5W8LOD89S2IkoxomaUJsHYX876tL6OyCOKkOd7Rfnff5O60CRquabA6Ue/xU/JSGs9QsXufCfccLQixQHxNF0Ykv81BashU874MPlyZc1QVYU06XoCsrntfPvwJt7N1gPqWliDcPpYBgyek64I4DVNi+mUKupvyTUJ4ym6pSO8yFG5Uik5NmBg4POkNpaAxH0o/j8/fAgWuV9jRST4ktNkmkuWT85tvbPX3ctMXp9WoFZJI408h34SYptPI/BeQ076O9abBgMWGqkZ4t76Qk78/9WJiKe30zRM7ZV7M5aFGq+VRVDLyMCogEeZLli1EKQPCTjAXqC219qO1GzYZx
 JisNKq92
 op4tQsvit0pt3qiQwa7y/fLyFGLpqOZIzZWWcpcIvKr6DgLOu4LRzUUWSXIlUCzUgyIBEOkTBKhUZWETgVvvyPN+buS75qJbePFWqUh7nRSgDUFztGIx3gufXp7OpE36wvOTH0UrEB3ZweDQQNB1d/NCpwXRJqt0++3MEYptm9P98c4hdNBZ8KfFf/WBFgGZthCtWs9JpqRd1pKM7sLg+M9ZCuk4m1hA6B61aFRi2/9IizjjLgh9aJ3z2DkjmTFVBQBMM2BEiG1+Ozz1Std6Qa6i/gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Apr 29, 2026 at 11:29:13AM -0400, Zi Yan wrote:
>Replace it with a check on the max folio order of the file's address space
>mapping, making sure PMD folio is supported. Keep the inode open-for-write
>check, since even if collapse_file() now makes sure all to-be-collapsed
>folios are clean and the created PMD file THP can be handled by FSes
>properly, the filemap_flush() could perform undesirable write back.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>---

LGTM.
Reviewed-by: Lance Yang <lance.yang@linux.dev>

