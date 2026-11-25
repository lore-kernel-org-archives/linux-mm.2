Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 948D9606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 10:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jFHsyPjB
Received: by kanga.kvack.org (Postfix)
	id A7F3D6B09AB; Wed, 25 Nov 2026 05:35:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A30076B09AC; Wed, 25 Nov 2026 05:35:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F7C66B09AD; Wed, 25 Nov 2026 05:35:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D19C6B09AB
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:35:26 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 112B8160D49
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:35:26 +0000 (UTC)
X-FDA: 85473284652.30.DD0FF60
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4377640008
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:35:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jFHsyPjB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795602924;
	b=g02NJYSF9F3s2Qf75sRt/Gv45n3GJpfd6wNpBOskqD4Xk6/PGfDGvkziGIhhisyfYnsRr+
	EdLcItfbzSK087BeNRiDvMOhm+UYmBXWEVHg+NG4ATUK2A1FCW2xy6LmyWuxWzDWMvX4zl
	vcxuR5Z9X4l1OeAjKrFGbLCaCDpsx2o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795602924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fvL10l2RoihP9dzgHdGxJnk1aKUlUVrZH12BQ6hlv5Y=;
	b=n39ZHtXT+1wTzzpPyACHvudJgvpbhYAxCXe8s/mQCWHDgA5qgY1sCZ+tJ01syGdbl1rP0O
	JPV1OWJEC6bLLnsWCkVwd5YallDLOYKjIhyU9HcLK5XHdSUPf0ZlElIEhUc8NIwrBZUcQY
	nsfRaB+bQPseQk9ahi4r22w64F3oRE8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jFHsyPjB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 829BC40860;
	Wed, 25 Nov 2026 10:35:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7591F000E0;
	Wed, 25 Nov 2026 10:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795602923;
	bh=fvL10l2RoihP9dzgHdGxJnk1aKUlUVrZH12BQ6hlv5Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jFHsyPjBXG/IBwv5ZYZ5AIfJ/1lMpdr2rUtXlEhkctj/ZkNbmU+SvngB5ONjib0+u
	 SJG/TwewXudIA+Cd47ccRz52FgnYkPGRby1n6sZ5PZEK2emi4Fbsaxh6wb6UFeS+/B
	 /QnCx51+6ILNf63RxEzrL6ZXeeHIrFHVnokECu19HeO7jtOwtXbh+V5cAbBgaqIFtW
	 R7KxDPKhaN/YJL6dZ6liV8CHb1BcJdGGFE/BfGZPoJqS9UwwExY6HxiddA7UFWNVWw
	 6FUXm+hAnJ/D/lDkNo/BQPHg+ZmPMDXFT5S83+bDFk5wHFMRx7WfC5tfrC1UB31+QI
	 XXyTpjO+XNDEA==
Message-ID: <603ff6af-104a-4b00-8f66-94d7f79fa540@kernel.org>
Date: Wed, 25 Nov 2026 11:35:18 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] hugetlbfs: respect F_SEAL_GROW and FMODE_WRITE before
 growing i_size in mmap
To: Dominik Maier <dmnk@google.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, dmnk+artist@google.com
References: <20261119192209.2651562-1-dmnk@google.com>
 <ac761e74-b38a-4daf-b855-55d5790504e1@kernel.org>
 <b644bcc7-0c3b-4001-89e7-3e558fbb5d76@kernel.org>
 <20261124181146.144161-1-dmnk@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261124181146.144161-1-dmnk@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4377640008
X-Stat-Signature: sagnozqypk58ycr6f1upbiirotf5qoaa
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795602924-572056
X-HE-Meta: U2FsdGVkX19zqOqM2ggC2iW/JTeKGTqP0pqOnCkXeXeJDP68M2+J82X86bZcLd2ycUiyqI7RJmocUZMicdAYcJS+8yc+srFR+4UJ+Y8fQehK31EDsUMdix3qaPu4c+0gplzSbpg0XVnxO4q5wkImuxqfb/jwmdF+bHT6t1/GMTIKpq5L/jKF/cFANmY8ijyINVEQwwOeOjlftgcXOLa8QVY1Hi1sRE6f1pqNmpwcaxhGQXt+4/++fevzYVtDaO9voe23kx/tW+M//q6EHBmwh/U67nOng1Y+xW8QjTTLqmLkDI6k0XWyo4/MxahYKqsj9mbZHjGI/NyIybiFZ4vAMSXK7noNyY9AjYEdsKOwRf9yZm8GEIsuLXiImcdUV3BVNN9RBLys1DeW8bMGzgdAMSIwqBXTPIfJzfn3I12wyCU0WuDqqZW/XYNkrtQHW0LgwkBQR6unAflt78ZUfHpRbfe0dt3ZtNENnKVaFSJQBIm7VNm6VH3ncSE4OII93TiyvaJkEtWHbYMR3NRkbCFBENzWPC+uojv2Ptx8tUzzF4kql2pVfwrzUe/0fKU652JPq+PgADDPSA2u1F583MEKbBnCs6KPz+U3jGYTfDmL3/M3O94r2wIJa4CfjBQ3vasV0ajXcbukeyHEEOHmG1AL+TUbXIwe+KdvXwGkmkgR1++/tFK55sW649p/RNgGbVIMZqohYWPJlrZ1BR6bPK053P2T2XJGb1fL8pCmrWBLvMdd/OMWVgFhiI/gAH4kUrx54lGglrsy59YkXzbfhEXKLFyUUvcVXv7vgICWgwyi3Jjjc++J87bmfJseSEL6n3oI9T3dmRLeLvBZMhDqYLoWMbfaiLS4agQYXXxjBdscJSEe3o/QaVRxGaZiWNjAdRFZk/556u3r1PeTZcOjG1X68E0VJAo/V6+fteRuAhTw4LDz2n+2zmhljflzUHD/pQMB/eCsFVc+X0KYLPNMUgI
 NNUHpAX8
 QM/LBo9b2w+iP1rz0ZhcBCzaN5FzwjIqi2U4N4CDW+s7POs5OZNDUL69fiiUG/OAQgT2z/7oO7k5QA1TJAJ/9QVlj+qf81Xo8DZIFhRtZwu9zXGyRuFAg/wZICgIZtW26BTgM/C6ktn9ivowB6hLqUL/wAEtVBIRufvUg+1HJrdNGvOrJgZYevHT53TICu5hC3o/9PqYzpMPX6u65y8IymqhlUnKUwvSFDZyaQU6WQDLbwrKxm0CBAbh64zQ9B78xjszJIGEYndI1KfQdTMnAhGwzwZBtaAeDNl7HoWejMzotXLvLZUZXA9xnGCnIDpaDOaZBWb5Xh/BZfp4HOPRSeYTcGtEdZPn5ND6a0PIb/hr0uY84ISQHuUeRakL4245ZHp92G+/SGBKM46vmDPj7FdW8YvF2qD69pQAbL3Px0hYY8ixzIT/s++EkpBxDc2ePj5CYYPlGqJuZ6JBt2T++BLaYvpfdbIv8PkxyTVSJ8QRLlj3xBfovQjdTiytTE5h2TQ0DDptasMR1e182St3DcaayGcir16yJl3BP1Tiht+3+GJ4YJOTwuCXAtfL28JonJzGDx2QxEhADmmOM4RLLtkCaL4Mos7+OG8Xes/I6opFBay2WIAPNj+5UjA67idqQphBpbksaz6/qShfh7PfdbgrrPhDlLcvDguws
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 19:11, Dominik Maier wrote:
> Hi David,
> 
> Ah, I missed 14bcafd08ddc in mm-new, sorry for the noise! Leaving
> O_RDONLY and unsealed MAP_PRIVATE alone so QEMU doesn't break makes
> sense. Let me know if you want a small patch on mm-new stopping
> F_SEAL_GROW from reserving beyond EOF, otherwise happy to drop this one.

Yes, let's do that, that should likely not break existing use cases

-- 
Cheers,

David

