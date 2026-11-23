Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 129DA606A330
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KTmcDw99
Received: by kanga.kvack.org (Postfix)
	id 2B6A86B05B1; Mon, 23 Nov 2026 12:57:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28E3D6B05B3; Mon, 23 Nov 2026 12:57:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CC5E6B05B4; Mon, 23 Nov 2026 12:57:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EFDC56B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:57:49 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7DA6316093B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:57:49 +0000 (UTC)
X-FDA: 85467141858.11.0EA1E88
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id E226B1C0008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:57:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KTmcDw99;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795456668;
	b=VPP/s3y3QeMmRwpnZn1pEX+WxO52+LO1QE6FypeSYfV9Ey6FRNhL+deJioikiDAoasjklL
	0iGcc9UezZdr+wn+cQ/74KOSsn7Ufh8i9mztFWvenkn8E6xKFsHGHJP0rLEo2PNKMAiVD+
	TuyB5rtVZCsry4IAqtkJSHVlfePh7To=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795456668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FygH8g0jvNBoZW+cHCkqSpUmMRuJL+3an1Z2bUsVRq4=;
	b=StwEwvb0UlQ2nAZstFUO17CS1fN0OT+g+j0y9g0kIdTebJVYaudIPZrf/YsnyqW2NVny1N
	atoYbNmfKsPBJVmNBi0zh85n7xRgCrjT8OKs7YyROdlz7pHmHrkGNx3MdDO0jIJzhwb6uK
	trEDnI8N/EozpgCvJfcSwzlNALT3kgE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KTmcDw99;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 04AB960E6F;
	Mon, 23 Nov 2026 17:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F18C1F000CF;
	Mon, 23 Nov 2026 17:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795456666;
	bh=FygH8g0jvNBoZW+cHCkqSpUmMRuJL+3an1Z2bUsVRq4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KTmcDw99fYlvBkqMPHrKYiHIdaafAHIkaELEmmQiUPF/yuskkJGbTOepnSdzDC4uS
	 IKPISIi5mGiw2pj8ulN5M65cJCoV8br0xYAefa1xOY2HuG6DOYkiOcyuCzVUK4Solu
	 HSCzuvMisVzGDfLUyRuYatnqsw2Tuiqc9bO4+f0TYl2K0LUonhi1xPjUiKH5xYzdXL
	 q+BCtuwFum6HJCJdnsroqKqTskq+513xMg9rLhEhLWD+HVw3je4q9Wtoe5A4sCDL8A
	 rQ4ck3+j+lBgNzjwUZyVU3DRF/2QuhsXGfTevqg/1MTQco1bE7H9fBn/wXR0bgs0TN
	 gSGS2a2LgP0Ew==
Date: Mon, 23 Nov 2026 17:57:40 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, david@kernel.org, akpm@linux-foundation.org, 
	kasong@tencent.com, baohua@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	baolin.wang@linux.alibaba.com
Subject: Re: [PATCH v5 0/4] skip empty PUD subtrees during aging with a
 PUD-level Bloom filter
Message-ID: <awR-UsoEGg733fQA@gremlin>
References: <20261123085800.981256-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261123085800.981256-1-baoquan.he@linux.dev>
X-Stat-Signature: eq8gppsa1e9jw3ys6xoajfibnuoq6uft
X-Rspamd-Queue-Id: E226B1C0008
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795456667-207689
X-HE-Meta: U2FsdGVkX18R6chzUM38WUkJ81gHsR8s3PxmXN0hjNbJ5/xEZSbyrjJHnjSdSPlpjc0C/YPP9f/LRhf2eGKwp3spgXYPmHPWWPHrIX7UuKAZAF29iBrsnjJyqxlYOzGXSSk0twwWfGXiIDoId3oacA4VVdzqVw3Lw3PbZ6uJ+tjzfSzOPHBouVcxXYNFdHgq9h98hYAlsiA7pBTqTD9XxygSVBGzwRx9w6vgtEq/1kjZblHjRDS7B7TKg0HGG1nhu//UCpZibecY8ilCNLIEwlnZUdjSboR6V0Pmt1nnX/lmdoiHMQ8YqMErSmy7Hj+33/vkjjGPzQT+xObyjNdAm04N4B1G2cWqmGI1QI9kO9k6BIWirSe+IRz9a61o6081to9fl8rOTSD70p3PYgCGhI8kdne2+ToJMe7slZmiTGZbCAB0ibX9U+8eF5rifjSMOWeyd36htEKibRRYROoiaeadixxvgX7hKGskTvTS0GzEajDdWzM4YTUS3lZPNeuHN+j/mHAVFu5AzgKkIY07LNGS7VlkcS16bmZHZWw8VoGXBs/Tvqzb5RA8kiZ0aUUuDBeEeTe/cJLl9vgWcTXsRN1Ycf0JVLRhlSMGc2GrIwI7JZV9U+7q9O3koE+jbd/k7/LFjPGVnmHmkjMkQxwhfmFec2b0iVRMk/wmaXPFAt5ez2psJG4n2+to+/nAB07BrvcbbY+vObIK7rE/OokYILZxCLqHnSlhHB80ffVHjGMkJBFF6TlXNxMLr1eUt/qkzoE4/d56dhJjpQ8qdbxJwcsHhA9K9sZb4582qVyk5kxc1jG8/XAs0iOnR3pfqmUYYDsAJKJhy6MRiC+bot6zRX4POxj3k84IlIKWYj/sRaBKOdzDxv11QeHMhy7X85UOBEVay9ohxqDoQElob7ZBEH3DmOjtBi2VuPj2VW+KN0vYT9RLQb+IL840PENrY09soUTlp9kLt+pARzRSto1
 Gcoxc8HL
 hJu84fHUsJ5FRZ3+Czry0R8gy9z7llX1Oi9g/xmmo9+p6BMU5hhjzJsiJ5aLQlRv4jW7AKBR7a48NCBpoobYv9qBARmEb7w+p1fOO9ORUSVR/457uWF4V7AbzQwbbJUzNzQUPZCLXod5gvIX7mAVMaGxOV0pdZ7PW5FXMh45f1BZh96OYjUUCmuh8xpJre/99kifrMDXu1xhm8AswTWL33hOUZ8h2dC+0AU5Re7IhdrESxu8iicfzASQ/JXde8oTnT7X5dvDBko2FdOCK8DFXfqSgByYOiltcNKdwPZelNoCSw9/75zhcxF/FM30Fi85Hhc+o2/dqxLLRrjLg97k6bEiyxb0p9o0W2lq6bwuZr7pHs3Wmk+6hErTeVPdbndvLyn2qbKqqzYeezytvSCKpLn6sdfEY/zPBJIEPR2lLmOz39ii5t93gHmqQV5ardiO+kl/9SPgXnJUL/C7faXOqOGsINck/UwvekAGuR4ECV1DtaThZIjo/wpaOL8ufn3dBX4PrdhVj22G6LMeHrZC1/GzSlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

(Got a script set up to detect things not cc'd now)

On Mon, Nov 23, 2026 at 04:57:56PM +0800, Baoquan He wrote:
>  mm/rmap.c              |   5 +-

MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
...
M:	Lorenzo Stoakes <ljs@kernel.org>

Please cc- me on rmap stuff, thanks ;)

--
Cheers, Lorenzo

