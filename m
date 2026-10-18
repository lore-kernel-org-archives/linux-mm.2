Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCACCCCA490
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 08:08:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB20E6B0092; Sun, 18 Oct 2026 04:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3B596B0093; Sun, 18 Oct 2026 04:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9034A6B0095; Sun, 18 Oct 2026 04:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A5216B0092
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 04:08:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F371714048F
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 08:08:09 +0000 (UTC)
X-FDA: 85335019098.26.3FFC453
Received: from mta0.migadu.com (out-200.mta0.migadu.com [91.218.175.200])
	by imf20.hostedemail.com (Postfix) with ESMTP id E15DB1C0005
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 08:08:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p7jnQJDx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.200 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792310888;
	b=NPSffiT5ma7w1G5ELHx+sIOjgbLpIzeWpVuKKASDvUC6UEIGdM7edomuAC/uyvL308ssec
	0gNHG0l7m2CGEmrEO+GmMIf6p7RNQDxNTom8ymck53PKlZG9uDDwka1WjnytUyVh0rnNH+
	ABUYIxmbIRFCjkQaYUzOlX5/omNGLy0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p7jnQJDx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.200 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792310888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XbcCGqXm08UD+4MN89FaxhWYXmB/b4iOm5BY4cHWO+0=;
	b=iASJWNh88gcHOClap7XV1uXVYphMavNP5qZ3xSoAop97KsZ5dsGWuG73uG+gvJ7TypA9bv
	tVkCU4Tt9w/vIj/BcUPDU2cuiSVa/xAhS+Vc3w73XosRPYuLpGTUHT/cEbOeqItMNOnhCM
	f0M/gr8zZtV+oNqmiZQu7NTcOr/tVSg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=XbcCGqXm08UD+4MN89FaxhWYXmB/b4iOm5BY4cHWO+0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792310885; v=1; x=1792915685;
 b=p7jnQJDxQMGX25AeFA7oM+lhn6PaZkuGuFKMJ28uIQrj5oGa14bN9VPLVMltoQNSZ3xMxHJ4
 MBwro4frvjNLi0qW4g74zXI+af9EHawmu1+cfcriWwvf+r4RygGT8ITaYfTpmMiYivez2iKfuca
 bTLLBgBV9PA8Dzjeg0ZTLouY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 56d35b3a46d02963;
	Sun, 18 Oct 2026 08:08:04 +0000
X-Mizu-Trace-ID: 56d35b3a46d02963
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	muchun.song@linux.dev,
	osalvador@suse.de,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	agl@us.ibm.com,
	mel@csn.ul.ie,
	riel@surriel.com,
	peterx@redhat.com,
	kas@kernel.org,
	rppt@kernel.org,
	josef@toxicpanda.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 08/10] mm/hugetlb: tolerate UFFD_WP markers outside uffd-wp VMAs
Date: Sun, 18 Oct 2026 16:07:59 +0800
Message-ID: <20261018080759.4295-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261015-urgent_fixes-v1-8-42796911043b@kernel.org>
References: <20261015-urgent_fixes-v1-8-42796911043b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E15DB1C0005
X-Stat-Signature: wnxd7ewzgj56xs7ap8i58wpn8pu1emjx
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1792310887-861419
X-HE-Meta: U2FsdGVkX1+zQJoLo7Ds0e3F7cyRt/MirdVv8NQ0lFJkNYtWOmrMSy7H4PeFhHn7ybYkKQauKlVGEIQ/k6STEEP8lzk++PSdFTGKwweCSjdntv7GAtUEPhoiV80iqxyG3//jEW8uah579GmNGmNyn31dwIDcyViSn57AMsCCqiRBET6WcexXWQ19WWNf18dxXeyvdTYb/SqjUl38zWIOsQE4Zr1b3LABolSOzrUfrftc1S6WTpzzvnG6D6xnejWgpjRozoWSQw1ycp1co//tWNtVKb9n9pJV2zSIMl2+FE5scOUZ5GeD9YgvVrZa8tevAdf8ldtV86X75Ks/1kMOlYJTUn3uyhKc0HFKIBa7jF4BVFhCLyBtNydtqs9t0Cy/ZgzSn5/OT0Xri99h+uIRbLUESKWBrCZShLa/Ifn3P+cgq9UEUoQuA4x2jtu2AkljFVMxyce18MC7LlvNpwjb5Bqhbl5E5F/1I9ZRXcU/WqoUH4QwVIlyZI/hN+tSGcYSgnBNSgEX7Ly1kG8Hc8dIHnzsm/hR5c21obdK1j8OXhdufBaUy/YYfKbn6GU/0z9H3dZ8xI58Er04fpzwt2Br0hHuh0uhXvAUR35IbsmnG+ZL1+y4UC0T2OQiQyYxWUoO8Nuh5sIweoWUxgpKT05/o8YO0Rv2XWRV5NzblG/Ld6upK8bMDgKCrabqnN5KQ9PeAVjGf2CBi624PilR9iUziArqzO+WBMY+tjo25l0LWUTTBYM6GjQOCT9w9Ig6rGl3ofTgNF2Qz/w0LYZMEeNDwx34w68FW4kPmgwyN28UMacuRFPHQhsyy3/B3nQgUcCIweG58aIOgsOR1Rs64wECk2Ia+A8BNxw/SVDSNrQzjJqXoXPF4YSDOLvSR8jgudYq0EcRantUnLUbV2kJ6z+VI6ip/LYXgxDpGHao8RQl9TnJgKArWJIpn+4+FqshoOpJBySTmSTeGfSLgd60nfR
 EMTFCXRw
 5n/E9YtmlJj7QGn34x/sZ8oEWM3U6m2uh89OdnnXiSwtzaWL/HVwpmSf0iRwGnrx0kPMd6wuiqyqN7RE34zsWYuVU46+cR91l3J4ZfZgV9b5byLXTRkQabVJ2K/x4KiQzZBvg/OBkLN05TTM1k4vdqVtcLCgytBfUfb/Pux33lo2jwoGtrA8X1p6bHbm4RY4NZ3pdZOQ0uY8eDvy+H4pWWGY+QQpE6lOcCGgZjuu6oVg3kOFvDhDfHSgXAJ4EYOVTtihK5LnkR2IeL57rUW37fp8axny1B1R/xeDN9fVRfty9HyMrmb6dQK+JMKcnJs/Yx+nILWWTbx9iSQjv49BbzntFtz3qRbsN4KQgCvwYbPktXGCcgiBGgtcoRjbKiqb2jEaW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Oct 15, 2026 at 06:07:14PM +0200, David Hildenbrand (Arm) wrote:
>UFFD PTE bit handling is a bit like swiss cheese, in particular with
>recently added RWP mode. Having uffd-wp markers outside uffd-wp VMAs
>already confused this code in the past and resulted in uffd-pte bits
>confusing other code later.
>
>Let's play safe and just ignore these markers in hugetlb_no_page(), not
>silently propagating the uffd-wp PTE bit.
>
>Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
>Cc: stable@vger.kernel.org
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

LGTM!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

