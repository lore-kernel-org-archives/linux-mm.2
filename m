Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE33DCD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 15:50:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A1EE6B00D1; Wed, 13 May 2026 11:50:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2528C6B00D2; Wed, 13 May 2026 11:50:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1413C6B00D3; Wed, 13 May 2026 11:50:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF7D46B00D1
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:50:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 999EE1A01F4
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:50:51 +0000 (UTC)
X-FDA: 84762834702.05.B785779
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id DD0DA40014
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:50:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UOq5WGMG;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778687449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=00NsFvkzK/fLKo2U9SIUO3Q3y8fqUsIVlU17g/vdSjM=;
	b=xBc/lWSgdISVs1EZj96sS7y+FcBXJPneELfNtKynU0l/SOEqs+AsjI3CgKFkoR+2FZKKIU
	Px5O+v5T/sPe1G00JRKGQ2CWL26ipSI6DtLXO4UGFiWqpf//dNI+MFOupDWeEi33ACWj7D
	Yjo7HbTItNrG5Ih1JZhej5D91ljquiw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UOq5WGMG;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778687449; a=rsa-sha256;
	cv=none;
	b=PSg8HXybpivNoSgn0811UljP+UN4Pko6DZOGBvUrTARqkkD3lenCMI+ODn7/XMz2l4I6az
	cehxvv9Eft7iXlSsBJcJCHgGCnz1E4pHL6+jEQPDcjeNI5CZ088kq68HKEW11oClz998MS
	WfL5TfwFugWmf0ArxpLNuTTrHwuSShA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C9D060129;
	Wed, 13 May 2026 15:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7425CC2BCC7;
	Wed, 13 May 2026 15:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778687448;
	bh=mX0RUkU4koJwf03j43fM06txmuh5H3KfS8MzpElE8R8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UOq5WGMGF0HNf4rFbWd5tkdmWEP+Pta6b9RgYUSgo9tNsWF1goyuBzjDKYnFQKK/M
	 hszkFI8uSiDY7oWYfDcOAmSeARNOEEOmGvqG6zMpFFAgfLZe7WgmlO37nIvTez/Bx/
	 AZYp2+iXWISWo+4cVyCHFliShq5BcZpeqxSgS3dYg6kMsOo/LcRGFwhB++dylKH5oJ
	 RmmeL1NMifKlbFX/H+htu+XtO/G3LhRsIUBKoTzdHdDA7T4NWMaFFF1ZvjOq8G+E8M
	 vTkaFeztYKA5y9Z+kVckQxcJj/SHgmaLQMOZYHbFmLOkbj6sDPqL4/GerP0XU5J8WU
	 +zrGyoSnbGsTw==
Message-ID: <2a0afa8c-15be-4766-ad3d-494875395b94@kernel.org>
Date: Wed, 13 May 2026 17:50:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 8/9] mm: replace thp_disabled_by_hw() with
 pgtable_has_pmd_leaves()
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, baolin.wang@linux.alibaba.com, ziy@nvidia.com,
 lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
References: <cover.1777663129.git.luizcap@redhat.com>
 <d4fbc41a51f8fe9ab55cc6792d60c6c2c504b4d4.1777663129.git.luizcap@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <d4fbc41a51f8fe9ab55cc6792d60c6c2c504b4d4.1777663129.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: r8uuigs9kacsmmxg44ihz81tyabh67pb
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DD0DA40014
X-Rspam-User: 
X-HE-Tag: 1778687449-964398
X-HE-Meta: U2FsdGVkX18ql9lqV8jSmgPRZEYDclmu4lulcuD7j3c+ptP5DEIhAoxvr/715v+WC6YNn3LzVuNqB9UvAeDn9v3rcNk1DqSw/jxVTnQIDeoYy/S4HGSG3cAvfND/ihpZ0SsVm/pFu+Pj54+6AccOGvwPN/9BRO3MwLsJYvwDGBSYipNhD3JgEVv3MV+yspY3PYJo051NJpuYlktkCYaIf5xphQtKY2qJMzqvmVcgq1Tz27qGl3msXbLE+dlaXuuYCDsoUzrDG5Vdb+yPxWvdldQZ8M0qAwnAs9qVbNyE/h2DcrELWl+8r7a5t+4dUZFuGVm4GKcTepU3/Sy+tW+Uxg7lJKKxSoIL7ydExaoruVAVkr05VjSNiyvkR/AXLATam2cPd4OUrqDMbwwvcQrB3ThN1uROC3unvc8PBURXa+GWXJ7Kk1t/3/dx6UVLd0AKWuHLXcPG/RMzaI7LTqwq1zOEbiepj0+aFmYMgHmv6/J9kvbRiNZJLdXxjzGl5NnPo4iqA8OtFtgqlsVFVYFbtEgaQYo5tzbROB38wjfswM/FtSG/8u7yeOqIvx2sVPjIW3yEZwf+mLPf6G5H//iMIoWc5gOir0LRA+n6zCj1lm1sDv76vQXRLPHRyBbuw+gSKv+5mGaajMIAIDEj6sIWfANhKjgBGcRLSR1fVduwewP1fp9XocHppgXKfpj3UM/9nqtV9LVWBUoEiQH3OpBXCdXXe18O1e92oD72oHaGbWgeImQ6mk5MB4Fikjqm7WSCJY05qnRMMlBHCGU+JIpubijKcmtJWfGx0jK+3LhQ/imghX8xsQBE//6jkaqDQSrKyf48Dx5iQ8ezpaGSba6rCF4vNLXrrHflqxKFBuRLM/L5Yy8U6iJDKmxycQAXeqcWJfc3O0JFM7sSTwOT7mIxvCyLRqVbHvNOjT8NydVtZRi+EIhkyoh5m5shWJJLkP6F7fkh4rE5zR4bM7jM2Ep
 SwBCYtvD
 QfMT13DUVbGQXRDjvNBSmbMeQ+pCMUgU5d/+6wxHJShRhgCYHJ4PI3ABf0G74OhTwdwDTsT+CalJ0XKLwONxmrufQ7QimcLfUeEH7H7O92I4a20HJJ1XdbA4uAygAmMf9KlF50IjpRtFsCzsgmwfM7u2mvN3y0bkupLTwXwUzL1YQpLYibb+M/6RAd2u0CBeTndXhI+5++ROsjwy+2JPLubgV91KIvNcKlsbZuPeCemnyrWPXZm2zGPMIpJ4S/T8O6M46Mkqu+3z8eM0IEV8blHr83E1f03A2DR2q+l+sheaRabaUDXRatO1GTs8UT2GOJG2HjmT69EV/dYgBTYbgpAuF711Qs6b1xFNbvJ4s/9r+1qGRUfQd0cLRL5TCohy1YD0xqIesJQrlLk7VHqU22sUWLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/1/26 21:18, Luiz Capitulino wrote:
> Despite its name, thp_disabled_by_hw() just checks whether the
> architecture supports PMD-sized pages. It returns true when
> TRANSPARENT_HUGEPAGE_UNSUPPORTED is set in transparent_hugepage_flags,
> this only occurs if the architecture implements arch_has_pmd_leaves()
> and that function returns false.
> 
> Since pgtable_has_pmd_leaves() provides the same semantics, use it
> instead.
> 
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---

Makes sense, and the next patch will actually limit it only to PMD orders.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

