Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E4AF606A329
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 08:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YvwomPFr
Received: by kanga.kvack.org (Postfix)
	id AEC5B6B05B0; Mon, 16 Nov 2026 03:57:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC41B6B05B1; Mon, 16 Nov 2026 03:57:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DB2D6B05B2; Mon, 16 Nov 2026 03:57:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 813BC6B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:57:02 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A47F1A0853
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:57:02 +0000 (UTC)
X-FDA: 85440377484.27.0895C5B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 80866A0007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:57:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YvwomPFr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794819420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=42Gs7+kt2Rgi78czHC7JtxOqLEeMRxWEH0wDlNcA+Ok=;
	b=DgtDrhol5Cc7mMhXAMsLiyPsDvnQsnQLpNIgorfoEh+Wyf2Yeyhp19Op/YOKOyCd0itOTy
	UCML/GMdqMpHaR3hxaJ9tQA6o0fumUPGKfTtf/3vEifjkwk6YNkZdN0YMTBvkFQlnKuhLW
	7BB8yl0ltSqKYsAn51nF4zCcPWysUX0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YvwomPFr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794819420;
	b=sqwPSz4Wv+o0wkYqdC5o9d3GJNo9/d8RFexjXQAXpKMve03/OkFknejUged5RJ4XVJBU1y
	bt/3RG2W9q6NQImZTl/8Ii5UOmGZp8xB+82461crqcFLQEsxuDI1NAqBntyW3CeM1HV19/
	UWia0x0k9bblQxHJDquwGz5wfpYPNws=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B55346274B;
	Mon, 16 Nov 2026 08:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2401F000C4;
	Mon, 16 Nov 2026 08:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794819419;
	bh=42Gs7+kt2Rgi78czHC7JtxOqLEeMRxWEH0wDlNcA+Ok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YvwomPFr3Dy9WSCTUXhwRiYexIxZeWPNOZRKwjA0vqfPQlD8u2H3Ih9BA+LuQbQ2T
	 vAUkKvnPltWir4szpjNDjLYjJrdeRcXGRAmJsy8SxC87nlJXLe9ntRGmxAtBZ+zerq
	 C8HZktnZdeV/l1EyOvBTBD80nuK9d9iFhWJDahqJhNpWJWvARiiH3tsbh75HbjeaO3
	 CuW6JIBoklYWu0IejwlPgG8nFzDc7QhmPhK0oQOHwhGvsMqYKLxIAZqr78s/rjvH5b
	 hokEF8CGgFxixV/C5RpoLk8uXvDgZ6m1YV776kOvDrJrLc0DxMWpe+XrHTr5K7vjjf
	 QLuwIefE37nPw==
Date: Mon, 16 Nov 2026 09:56:54 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	jm5905938@gmail.com
Subject: Re: [PATCH v2] hugetlbfs: report inode limits without a memory
 subpool
Message-ID: <avrFVm-VwMwoBZyS@localhost.localdomain>
References: <20261111130145.96534-1-dennylin0707@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111130145.96534-1-dennylin0707@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 80866A0007
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 5d3j8fni76y99kcmj1zcoe1g8rxn1x1z
X-HE-Tag: 1794819420-112207
X-HE-Meta: U2FsdGVkX1+h046dj+McR94TV/46WfuBLwEasNhuzy5srf2Yu/WH+SpNoiYu2qUMu/tYFGWEvYp4MhMPE09FCxPn1kKPTRpOrj8HA2TXaH9Eh6kW2giaD8x25V2KamCkdpuAfKWzAe6TfFgyrr2XbZrQe7Aflbdo4dgJHm1XIyjjLRr5+aK0Co5Zks+sx1Ugb2j0g77JZ3bsLlU0sPwFGgeqSoAtted+r1WuyBNyenGrC6RGl8qPVCAy9pInNOszPSbZ/9sI/FUx8sBnpYP4pOzkiCABTKbPZUCCXLfHBvniFNrt2YM+j/JzyzPD56POfJ+L7WFXcqUCp9uixz+JQw4NNUoCTHiY0XUzIR3l+VQRTquBAAd9njOPe31ywjECUYLTztXetlIye4wBnb703/Ams+jwQ6ZHOFJnlnhOWQPmDVgSD1u1E8BnQjw+KiHj4ZeEmkJOeIu/pjfFS4YEkF+cGohrTRRYUx3NtU6WtOVwZpamke6NSZnAzVNLR89KD7a1s3OAF/RMNzl58lnUPd8CXCB664c0p1FH/qPFUl17xkVKx4A/WImsfcz9+3WP6n3hx68UxiQSByuuN2uMaYUG92sYhIrkbfZRCJ72gjSDKodV7jKv7SyJhMaWvrXn4FjGOaKXL5TrNT+S2HhGzMu2q0oL9/16RHg2h4wvNuEzDJPHp00z/N36QgQEvxv7qrieBjGuUvSfM/VPkEfCQJcjiiFnuwItQD80CeTuh7Mp5aJK5WglDjzl7H+YpOF7Sr717CARd0Pa8ACr0jFJPeChVmRVGpoWCEu979UdfCbLwo5LMmLlykwcnDatAvZsqvmK7q/ZklGKu7vz9Wgi5FezFVXlXqYdxv7OxsUy8yN7J2RmT96MHQrHqc6drgcW9QM8ndK6rDbKHb9XkUyHrHzWBILc9UFNOFsOqdJsG6HGv8CAMfl9MMF9gG9qbeZCG9U9T7dxNES0XVduan4
 60RSydqB
 q7DfV4I1P096vuo2LiOHUlmwdOgVPjwm4Ojtf+Plo/mscXrPEE/9kURynEWxIqAzxIgbX6jF+uIU4To7T2J9DXdXbe3zP7ukAGePw8qFH9o4Ewf8++mr2PGCYyBN+/0XO0rXwhGJSYCbqtyJXap76+alkms3G73ZOyfLpHjt/sxuFPmfCpUoe1zU/a6dGKoUo0oHMg9D44AY0XuKYyedn9rBiICJDGoDDSneqzJvbra8iB13JDQarXj3pkmqSdMLgoSFx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 01:01:45PM +0000, Hungyu Lin wrote:
> A hugetlbfs mount can limit inodes with nr_inodes independently of size
> or min_size. hugetlbfs_statfs() only fills f_files and f_ffree when a
> memory subpool exists, so an inode-only limit is enforced but its inode
> counts are reported as zero.
> 
> For example, a fresh mount with nr_inodes=4 reports zero total and free
> inodes instead of 4 and 3. This hides the inode limit from tools such
> as df -i, even when creating another file fails with ENOSPC.
> 
> Report the inode counters when an inode limit is configured,
> independently of the memory subpool. Preserve the existing zero and -1
> results for unlimited inode counts.
> 
> Fixes: 74a8a65c5261 ("[PATCH] Fix hugetlbfs_statfs() reporting of block limits")
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
> Reviewed-by: Aveline Noir <jm5905938@gmail.com>
> Tested-by: Aveline Noir <jm5905938@gmail.com>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

